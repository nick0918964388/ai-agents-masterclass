-- 建立車輛/設備的基本資料表
CREATE TABLE "ASSET"  (
                  "ASSETNUM" VARGRAPHIC(25 CODEUNITS16) NOT NULL WITH COMMENT '車號', -- 車號
                  "PARENT" VARGRAPHIC(25 CODEUNITS16) WITH COMMENT '父車號', -- 父車號                  
                  "CHANGEDATE" TIMESTAMP NOT NULL WITH COMMENT '變更日期', -- 變更日期
                  "CHANGEBY" VARGRAPHIC(30 CODEUNITS16) NOT NULL WITH COMMENT '變更人員', -- 變更人員
                  "EQ1" VARGRAPHIC(12 CODEUNITS16) WITH COMMENT '維修機廠', -- 維修機廠
                  "EQ2" VARGRAPHIC(12 CODEUNITS16) WITH COMMENT '維修機務段代號', -- 維修機務段代號
                  "EQ3" VARGRAPHIC(20 CODEUNITS16) WITH COMMENT '車種代號(如E:電車,D:柴油車,M:機車)', -- 車種代號(如E:電車,D:柴油車,M:機車)
                  "EQ4" VARGRAPHIC(20 CODEUNITS16) WITH COMMENT '車型代號(如:EMU900表示電聯車900型,TEMU1000表示電聯車1000型或太魯閣號,E1000表示電力機車1000型)', -- 車型代號(如:EMU900表示電聯車900型,TEMU1000表示電聯車1000型或太魯閣號,E1000表示電力機車1000型)                                    
                  "EQ9" VARGRAPHIC(10 CODEUNITS16) WITH COMMENT '車輛/車輛、車組或設備的區分(單一車輛車號或車組或設備)', -- 車輛/車輛、車組或設備的區分(單一車輛車號或車組或設備)
 );


-- 故障通報/車輛進廠維修/設備工具進廠維修的交易資料檔案
CREATE TABLE "TICKET"  (
                  "TICKETID" VARGRAPHIC(12 CODEUNITS16) NOT NULL WITH COMMENT '主要的Key', --主要的Key
                  "CLASS" VARGRAPHIC(16 CODEUNITS16) NOT NULL WITH COMMENT '區隔"車輛故障"、"車輛進廠維修"、"設備工具進廠維修"三種不同交易資料類型', -- 區隔"車輛故障"、"車輛進廠維修"、"設備工具進廠維修"三種不同交易資料類型
                  "DESCRIPTION" VARGRAPHIC(100 CODEUNITS16) WITH COMMENT '描述',  -- 描述
                  "STATUS" VARGRAPHIC(10 CODEUNITS16) NOT NULL WITH COMMENT '狀態', -- 狀態
                  "STATUSDATE" TIMESTAMP NOT NULL WITH COMMENT '狀態日期', -- 狀態日期
                  "REPORTEDPRIORITY" INTEGER WITH COMMENT '通報優先權', -- 通報優先權
                  "INTERNALPRIORITY" INTEGER WITH COMMENT '內部優先權', -- 內部優先權
                  "IMPACT" INTEGER WITH COMMENT '影響', -- 影響
                  "URGENCY" INTEGER WITH COMMENT '急迫性', -- 急迫性
                  "REPORTEDBY" VARGRAPHIC(30 CODEUNITS16) WITH COMMENT '通報人員', -- 通報人員
                  "REPORTDATE" TIMESTAMP WITH COMMENT '通報日期', -- 通報日期  
                  "AFFECTEDPERSON" VARGRAPHIC(30 CODEUNITS16) WITH COMMENT '受影響人員', -- 受影響人員
                  "AFFECTEDDATE" TIMESTAMP WITH COMMENT '受影響日期', -- 受影響日期
                  "SOURCE" VARGRAPHIC(20 CODEUNITS16) WITH COMMENT '來源', -- 來源
                  "SUPERVISOR" VARGRAPHIC(30 CODEUNITS16) WITH COMMENT '主管', -- 主管
                  "OWNER" VARGRAPHIC(30 CODEUNITS16) WITH COMMENT '擁有者', -- 擁有者
                  "OWNERGROUP" VARGRAPHIC(8 CODEUNITS16) WITH COMMENT '擁有者群組', -- 擁有者群組
                  "ISGLOBAL" INTEGER NOT NULL WITH COMMENT '是否為全域', -- 是否為全域
                  "RELATEDTOGLOBAL" INTEGER NOT NULL WITH COMMENT '是否與全域相關', -- 是否與全域相關
                  "GLOBALTICKETID" VARGRAPHIC(10 CODEUNITS16) WITH COMMENT '全域故障通報編號', -- 全域故障通報編號
                  "GLOBALTICKETCLASS" VARGRAPHIC(16 CODEUNITS16) WITH COMMENT '全域故障通報類型', -- 全域故障通報類型
                  "EXTERNALRECID" VARGRAPHIC(20 CODEUNITS16) WITH COMMENT '外部記錄編號', -- 外部記錄編號
                  "SITEVISIT" INTEGER NOT NULL WITH COMMENT '現場訪視', -- 現場訪視
                  "ORIGRECORDID" VARGRAPHIC(10 CODEUNITS16) WITH COMMENT '原始記錄編號', -- 原始記錄編號
                  "ASSETNUM" VARGRAPHIC(25 CODEUNITS16) WITH COMMENT '車號', -- 車號
                  "ORIGRECORDCLASS" VARGRAPHIC(16 CODEUNITS16) WITH COMMENT '原始記錄類型' -- 原始記錄類型
                    );

-- 庫存查詢
CREATE TABLE "INVBALANCES"  (
                  "INBALANCEID" VARGRAPHIC(12 CODEUNITS16) NOT NULL WITH COMMENT '主要的Key', --主要的Key
                  "ITEMNUM" VARGRAPHIC(12 CODEUNITS16) NOT NULL WITH COMMENT '料件編號', --項目編號
                  "CONDITIONCODE" VARGRAPHIC(10 CODEUNITS16) NOT NULL WITH COMMENT '料性', --條件碼
                  "BINNUM" VARGRAPHIC(10 CODEUNITS16) NOT NULL WITH COMMENT '櫃位編號', --倉庫編號
                  "CURBAL" INTEGER NOT NULL WITH COMMENT '庫存數量', --庫存數量
                  "LOCATION" VARGRAPHIC(10 CODEUNITS16) NOT NULL WITH COMMENT '倉庫位置', --倉庫位置
                  "CHANGEDATE" TIMESTAMP NOT NULL WITH COMMENT '變更日期', --變更日期
                  "CHANGEBY" VARGRAPHIC(30 CODEUNITS16) NOT NULL WITH COMMENT '變更人員', --變更人員
                    );





