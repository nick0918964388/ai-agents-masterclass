from dotenv import load_dotenv
from swarm import Agent
import ibm_db
import os

load_dotenv()
model = os.getenv('LLM_MODEL', 'qwen2.5-coder:7b')

# DB2連接參數從環境變量獲取
DB2_DATABASE = os.getenv('DB2_DATABASE')
DB2_HOSTNAME = os.getenv('DB2_HOSTNAME')
DB2_PORT = os.getenv('DB2_PORT')
DB2_USERNAME = os.getenv('DB2_USERNAME')
DB2_PASSWORD = os.getenv('DB2_PASSWORD')

# 創建DB2連接字符串
conn_str = (
    f"DATABASE={DB2_DATABASE};"
    f"HOSTNAME={DB2_HOSTNAME};"
    f"PORT={DB2_PORT};"
    f"PROTOCOL=TCPIP;"
    f"UID={DB2_USERNAME};"
    f"PWD={DB2_PASSWORD};"
)

try:
    # 建立DB2連接
    conn = ibm_db.connect(conn_str, "", "")
except Exception as e:
    print(f"連接DB2數據庫時發生錯誤: {str(e)}")
    raise


# 讀取第二個數據庫的表結構
with open("ai-news-complete-tables.sql", "r") as table_schema_file:
    table_schemas = table_schema_file.read()


def run_sql_select_statement(sql_statement):
    """執行SQL SELECT語句並返回結果"""
    print(f"執行SQL語句: {sql_statement}")
    try:
        # 使用ibm_db執行查詢
        stmt = ibm_db.exec_immediate(conn, sql_statement)
        records = []
        
        # 獲取列信息
        column_names = [ibm_db.field_name(stmt, i) 
                       for i in range(ibm_db.num_fields(stmt))]
        
        # 獲取所有記錄
        result = ibm_db.fetch_tuple(stmt)
        while result:
            records.append(result)
            result = ibm_db.fetch_tuple(stmt)

        if not records:
            return "未找到結果。"
        
        # 計算列寬
        col_widths = [len(str(name)) for name in column_names]
        for row in records:
            for i, value in enumerate(row):
                col_widths[i] = max(col_widths[i], len(str(value)))
        
        # 格式化結果
        result_str = ""
        
        # 添加表頭
        header = " | ".join(
            str(name).ljust(width) 
            for name, width in zip(column_names, col_widths)
        )
        result_str += header + "\n"
        result_str += "-" * len(header) + "\n"
        
        # 添加數據行
        for row in records:
            row_str = " | ".join(
                str(value).ljust(width) 
                for value, width in zip(row, col_widths)
            )
            result_str += row_str + "\n"
        
        return result_str
        
    except Exception as e:
        return f"執行查詢時發生錯誤: {str(e)}"


def get_sql_router_agent_instructions():
    return """你是不同SQL數據專家的協調者，你的工作是確定哪個代理最適合
    處理用戶的請求，並將對話轉交給該代理。"""


def get_sql_agent_instructions():
    return f"""你是一位DB2 SQL專家，負責接收用戶的信息請求，創建SELECT語句來檢索
    必要的信息，然後調用函數運行查詢並獲取結果，最後向用戶報告他們想要知道的信息。
    
    這是你可以查詢的數據庫表結構：
    
    {table_schemas}

    請確保你的SQL SELECT語句100%符合DB2語法和這些架構。
    你要隨時準備創建和執行SQL語句來回答用戶的問題。
    """
    print(get_sql_agent_instructions())


sql_router_agent_db2 = Agent(
    name="路由代理",
    instructions=get_sql_router_agent_instructions(),
    model="qwen2.5:3b"
)

car_base_info_agent = Agent(
    name="車輛與設備基本資料代理",
    instructions=get_sql_agent_instructions() + 
    "\n\n負責處理與[車輛與設備]相關基本資料的數據查詢，查詢車輛基本資料，車輛維修機廠，車輛維修機務段代號，車輛車種代號，車輛車型代號。請不要用*來找尋全部欄位",
    functions=[run_sql_select_statement],
    model=model
)

abnormal_report_agent = Agent(
    name="故障通報代理",
    instructions=get_sql_agent_instructions() + 
    "\n\n負責處理與[故障通報]相關的數據查詢，查詢故障通報ID，故障通報類型，故障通報描述，故障通報狀態，故障通報狀態日期，故障通報通報優先權，故障通報編號，故障通報全域故障通報類型，故障通報外部記錄編號，故障通報現場訪視，故障通報原始記錄編號，故障通報原始記錄類型。請不要用*來找尋全部欄位",
    functions=[run_sql_select_statement],
    model=model
)

invbalances_agent = Agent(
    name="材料庫存代理",
    instructions=get_sql_agent_instructions() + 
    "\n\n負責處理與[庫存數量/庫存內容/庫存位置]相關的數據查詢代理。",
    functions=[run_sql_select_statement],
    model=model
)


def transfer_back_to_router_agent():
    """當用戶詢問當前代理無法處理的數據時調用此函數"""
    return sql_router_agent_db2


def transfer_to_car_base_info_agent():
    return car_base_info_agent


def transfer_to_abnormal_report_agent():
    return abnormal_report_agent


def transfer_to_invbalances_agent():
    return invbalances_agent


sql_router_agent_db2.functions = [
    transfer_to_car_base_info_agent,
    transfer_to_abnormal_report_agent,
    transfer_to_invbalances_agent
]

car_base_info_agent.functions.append(transfer_back_to_router_agent)
abnormal_report_agent.functions.append(transfer_back_to_router_agent)
invbalances_agent.functions.append(transfer_back_to_router_agent)


def cleanup():
    """清理數據庫連接"""
    try:
        ibm_db.close(conn)
        print("DB2連接已關閉")
    except Exception as e:
        print(f"關閉DB2連接時發生錯誤: {str(e)}") 