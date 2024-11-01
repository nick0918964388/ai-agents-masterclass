-- 建立車輛/設備的基本資料表
CREATE TABLE "ASSET"  (
                  "ASSETNUM" VARGRAPHIC(25 CODEUNITS16) NOT NULL , -- 車號
                  "PARENT" VARGRAPHIC(25 CODEUNITS16) , -- 父車號                  
                  "CHANGEDATE" TIMESTAMP NOT NULL , -- 變更日期
                  "CHANGEBY" VARGRAPHIC(30 CODEUNITS16) NOT NULL , -- 變更人員
                  "EQ1" VARGRAPHIC(12 CODEUNITS16) , -- 維修機廠
                  "EQ2" VARGRAPHIC(12 CODEUNITS16) , -- 維修機務段代號
                  "EQ3" VARGRAPHIC(20 CODEUNITS16) , -- 車種代號(如E:電車,D:柴油車,M:機車)
                  "EQ4" VARGRAPHIC(20 CODEUNITS16) , -- 車型代號(如:EMU900表示電聯車900型,TEMU1000表示電聯車1000型或太魯閣號,E1000表示電力機車1000型)                                    
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





