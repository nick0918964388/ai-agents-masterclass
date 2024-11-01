-- 建立車輛/設備的基本資料表
CREATE TABLE "ASSET"  (
                  "ASSETNUM" VARGRAPHIC(25 CODEUNITS16) NOT NULL , -- 車輛/設備編號
                  "PARENT" VARGRAPHIC(25 CODEUNITS16) , -- 父車輛/設備編號
                  "SERIALNUM" VARGRAPHIC(64 CODEUNITS16) , -- 車輛/設備序號
                  "ASSETTAG" VARGRAPHIC(64 CODEUNITS16) , -- 車輛/設備標籤
                  "LOCATION" VARGRAPHIC(12 CODEUNITS16) , -- 車輛/設備位置
                  "DESCRIPTION" VARGRAPHIC(256 CODEUNITS16) , -- 車輛/設備描述
                  "VENDOR" VARGRAPHIC(250 CODEUNITS16) , -- 車輛/設備供應商
                  "FAILURECODE" VARGRAPHIC(12 CODEUNITS16) , -- 車輛/設備故障碼
                  "MANUFACTURER" VARGRAPHIC(250 CODEUNITS16) , -- 車輛/設備製造商
                  "PURCHASEPRICE" DECIMAL(10,2) NOT NULL , -- 車輛/設備購買價格
                  "REPLACECOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備更換成本
                  "INSTALLDATE" DATE , -- 車輛/設備安裝日期
                  "WARRANTYEXPDATE" DATE , -- 車輛/設備保固到期日
                  "TOTALCOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備總成本
                  "YTDCOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備年度累計成本
                  "BUDGETCOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備預算成本
                  "CALNUM" VARGRAPHIC(8 CODEUNITS16) , -- 車輛/設備計算編號
                  "ISRUNNING" INTEGER NOT NULL , -- 車輛/設備是否運行
                  "ITEMNUM" VARGRAPHIC(30 CODEUNITS16) , -- 車輛/設備項目編號
                  "UNCHARGEDCOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備未計算成本
                  "TOTUNCHARGEDCOST" DECIMAL(10,2) NOT NULL , -- 車輛/設備總未計算成本
                  "TOTDOWNTIME" DOUBLE NOT NULL , -- 車輛/設備總停機時間
                  "STATUSDATE" TIMESTAMP , -- 車輛/設備狀態日期
                  "CHANGEDATE" TIMESTAMP NOT NULL , -- 車輛/設備變更日期
                  "CHANGEBY" VARGRAPHIC(30 CODEUNITS16) NOT NULL , -- 車輛/設備變更人員
                  "EQ1" VARGRAPHIC(12 CODEUNITS16) , -- 車輛/維修機廠
                  "EQ2" VARGRAPHIC(12 CODEUNITS16) , -- 車輛/維修機務段代號
                  "EQ3" VARGRAPHIC(20 CODEUNITS16) , -- 車輛/車種代號(如E:電車,D:柴油車,M:機車)
                  "EQ4" VARGRAPHIC(20 CODEUNITS16) , -- 車輛/車型代號(如:EMU900表示電聯車900型,TEMU1000表示電聯車1000型或太魯閣號,E1000表示電力機車1000型)
                  "EQ5" VARGRAPHIC(8 CODEUNITS16) , -- 車輛/車輛編號
                  "EQ6" TIMESTAMP , -- 車輛/車輛狀態日期
                  "EQ7" VARGRAPHIC(20 CODEUNITS16) , -- 車輛/車輛狀態
                  "EQ8" VARGRAPHIC(12 CODEUNITS16) , -- 車輛/車輛位置
                  "EQ9" VARGRAPHIC(10 CODEUNITS16) , -- 車輛/車輛、車組或設備的區分(單一車輛車號或車組或設備)
 );


-- 故障通報/車輛進廠維修/設備工具進廠維修的交易資料檔案
CREATE TABLE "TICKET"  (
                  "TICKETID" VARGRAPHIC(12 CODEUNITS16) NOT NULL , --主要的Key
                  "CLASS" VARGRAPHIC(16 CODEUNITS16) NOT NULL , -- 區隔"車輛故障"、"車輛進廠維修"、"設備工具進廠維修"三種不同交易資料類型
                  "DESCRIPTION" VARGRAPHIC(100 CODEUNITS16) ,  -- 描述
                  "STATUS" VARGRAPHIC(10 CODEUNITS16) NOT NULL , -- 狀態
                  "STATUSDATE" TIMESTAMP NOT NULL , -- 狀態日期
                  "REPORTEDPRIORITY" INTEGER , -- 通報優先權
                  "INTERNALPRIORITY" INTEGER , -- 內部優先權
                  "IMPACT" INTEGER , -- 影響
                  "URGENCY" INTEGER , -- 急迫性
                  "REPORTEDBY" VARGRAPHIC(30 CODEUNITS16) , -- 通報人員
                  "REPORTDATE" TIMESTAMP , -- 通報日期  
                  "AFFECTEDPERSON" VARGRAPHIC(30 CODEUNITS16) , -- 受影響人員
                  "AFFECTEDDATE" TIMESTAMP , -- 受影響日期
                  "SOURCE" VARGRAPHIC(20 CODEUNITS16) , -- 來源
                  "SUPERVISOR" VARGRAPHIC(30 CODEUNITS16) , -- 主管
                  "OWNER" VARGRAPHIC(30 CODEUNITS16) , -- 擁有者
                  "OWNERGROUP" VARGRAPHIC(8 CODEUNITS16) , -- 擁有者群組
                  "ISGLOBAL" INTEGER NOT NULL , -- 是否為全域
                  "RELATEDTOGLOBAL" INTEGER NOT NULL , -- 是否與全域相關
                  "GLOBALTICKETID" VARGRAPHIC(10 CODEUNITS16) , -- 全域故障通報編號
                  "GLOBALTICKETCLASS" VARGRAPHIC(16 CODEUNITS16) , -- 全域故障通報類型
                  "EXTERNALRECID" VARGRAPHIC(20 CODEUNITS16) , -- 外部記錄編號
                  "SITEVISIT" INTEGER NOT NULL , -- 現場訪視
                  "ORIGRECORDID" VARGRAPHIC(10 CODEUNITS16) ,
                  "ORIGRECORDCLASS" VARGRAPHIC(16 CODEUNITS16)
                    );





