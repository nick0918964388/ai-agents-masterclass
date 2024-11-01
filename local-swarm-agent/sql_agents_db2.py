from dotenv import load_dotenv
from swarm import Agent
import ibm_db_sa
import ibm_db
from sqlalchemy import create_engine
import os

load_dotenv()
model = os.getenv('LLM_MODEL', 'qwen2.5-coder:7b')

# DB2连接参数从环境变量获取
DB2_DATABASE = os.getenv('DB2_DATABASE')
DB2_HOSTNAME = os.getenv('DB2_HOSTNAME')
DB2_PORT = os.getenv('DB2_PORT')
DB2_USERNAME = os.getenv('DB2_USERNAME')
DB2_PASSWORD = os.getenv('DB2_PASSWORD')

# 创建DB2连接字符串
conn_str = (
    f"DATABASE={DB2_DATABASE};"
    f"HOSTNAME={DB2_HOSTNAME};"
    f"PORT={DB2_PORT};"
    f"PROTOCOL=TCPIP;"
    f"UID={DB2_USERNAME};"
    f"PWD={DB2_PASSWORD};"
)

try:
    # 建立DB2连接
    conn = ibm_db.connect(conn_str, "", "")
    # 同时创建SQLAlchemy引擎用于更复杂的查询
    engine = create_engine(
        f'db2+ibm_db://{DB2_USERNAME}:{DB2_PASSWORD}@{DB2_HOSTNAME}:'
        f'{DB2_PORT}/{DB2_DATABASE}'
    )
except Exception as e:
    print(f"连接DB2数据库时发生错误: {str(e)}")
    raise


# 读取第二个数据库的表结构
with open("ai-news-complete-tables.sql", "r") as table_schema_file:
    table_schemas = table_schema_file.read()


def run_sql_select_statement(sql_statement):
    """执行SQL SELECT语句并返回结果"""
    print(f"执行SQL语句: {sql_statement}")
    try:
        # 使用ibm_db执行查询
        stmt = ibm_db.exec_immediate(conn, sql_statement)
        records = []
        
        # 获取列信息
        column_names = [ibm_db.field_name(stmt, i) 
                       for i in range(ibm_db.num_fields(stmt))]
        
        # 获取所有记录
        result = ibm_db.fetch_tuple(stmt)
        while result:
            records.append(result)
            result = ibm_db.fetch_tuple(stmt)

        if not records:
            return "未找到结果。"
        
        # 计算列宽
        col_widths = [len(str(name)) for name in column_names]
        for row in records:
            for i, value in enumerate(row):
                col_widths[i] = max(col_widths[i], len(str(value)))
        
        # 格式化结果
        result_str = ""
        
        # 添加表头
        header = " | ".join(
            str(name).ljust(width) 
            for name, width in zip(column_names, col_widths)
        )
        result_str += header + "\n"
        result_str += "-" * len(header) + "\n"
        
        # 添加数据行
        for row in records:
            row_str = " | ".join(
                str(value).ljust(width) 
                for value, width in zip(row, col_widths)
            )
            result_str += row_str + "\n"
        
        return result_str
        
    except Exception as e:
        return f"执行查询时发生错误: {str(e)}"


def get_sql_router_agent_instructions():
    return """你是不同SQL数据专家的协调者，你的工作是确定哪个代理最适合
    处理用户的请求，并将对话转交给该代理。"""


def get_sql_agent_instructions():
    return f"""你是一位DB2 SQL专家，负责接收用户的信息请求，创建SELECT语句来检索
    必要的信息，然后调用函数运行查询并获取结果，最后向用户报告他们想要知道的信息。
    
    这是你可以查询的数据库表结构：
    
    {table_schemas}

    请确保你的SQL SELECT语句100%符合DB2语法和这些架构。
    你要随时准备创建和执行SQL语句来回答用户的问题。
    """


sql_router_agent = Agent(
    name="路由代理",
    instructions=get_sql_router_agent_instructions(),
    model="qwen2.5:3b"
)

data_agent_1 = Agent(
    name="数据代理1",
    instructions=get_sql_agent_instructions() + 
    "\n\n负责处理与[具体业务领域1]相关的数据查询。",
    functions=[run_sql_select_statement],
    model=model
)

data_agent_2 = Agent(
    name="数据代理2",
    instructions=get_sql_agent_instructions() + 
    "\n\n负责处理与[具体业务领域2]相关的数据查询。",
    functions=[run_sql_select_statement],
    model=model
)

data_agent_3 = Agent(
    name="数据代理3",
    instructions=get_sql_agent_instructions() + 
    "\n\n负责处理与[具体业务领域3]相关的数据分析。",
    functions=[run_sql_select_statement],
    model=model
)


def transfer_back_to_router_agent():
    """当用户询问当前代理无法处理的数据时调用此函数"""
    return sql_router_agent


def transfer_to_data_agent_1():
    return data_agent_1


def transfer_to_data_agent_2():
    return data_agent_2


def transfer_to_data_agent_3():
    return data_agent_3


sql_router_agent.functions = [
    transfer_to_data_agent_1,
    transfer_to_data_agent_2,
    transfer_to_data_agent_3
]

data_agent_1.functions.append(transfer_back_to_router_agent)
data_agent_2.functions.append(transfer_back_to_router_agent)
data_agent_3.functions.append(transfer_back_to_router_agent)


def cleanup():
    """清理数据库连接"""
    try:
        ibm_db.close(conn)
        print("DB2连接已关闭")
    except Exception as e:
        print(f"关闭DB2连接时发生错误: {str(e)}") 