$PBExportHeader$w_kgle02.srw
$PBExportComments$������: �� �̿�ó��
forward
global type w_kgle02 from w_inherite
end type
type dw_saupj from datawindow within w_kgle02
end type
type cb_6 from commandbutton within w_kgle02
end type
end forward

global type w_kgle02 from w_inherite
string title = "���̿�ó��"
dw_saupj dw_saupj
cb_6 cb_6
end type
global w_kgle02 w_kgle02

type variables
String ls_saupj,ls_yy,ls_add_yy
Boolean continue_flag =True
Double ldb_dangi_amt
end variables

forward prototypes
public function integer wf_create_acc (string ssaupj, string sbefyear, string siwolyear)
public function integer wf_create_acc_sdept (string ssaupj, string sbefyear, string siwolyear)
public function integer wf_create_cust (string ssaupj, string sbefyear, string siwolyear)
public function integer wf_create_cust_curr (string ssaupj, string sbefyear, string siwolyear)
public function integer wf_create_cust_sdept (string ssaupj, string sbefyear, string siwolyear)
end prototypes

public function integer wf_create_acc (string ssaupj, string sbefyear, string siwolyear);String  sIk_Acc1,sIk_Acc2,sSonIk_Acc1,sSonIk_Acc2
Double  dDangAmount,dDr
Integer iCount =0

w_mdi_frame.sle_msg.text = '['+f_get_refferance('AD',sSaupj)+'] ���� �ܰ� �̿� ó�� ��...'
SetPointer(HourGlass!)

/*�̿������׿��ݰ�������(ȯ������ A-1-52)*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)
	INTO :sIk_Acc1,						 	:sIk_Acc2
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '52' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[�����׿��ݰ���(A-1-52)]')
	Return -1
END IF

/*���Ͱ�������(ȯ������ A-1-53)
   ����ü�а����� �Է½ô� �׿��ݰ����ܾ��� �ƴҽÿ��� ���Ͱ����� �ܾ��� �����  */
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)
	INTO :sSonIk_Acc1,						 :sSonIk_Acc2
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '53' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[���Ͱ���(A-1-53)]')
	Return -1
END IF

/*������ ������*/
DELETE FROM "KFZ14OT0"
	WHERE ( "SAUPJ"  = :sSaupj ) AND  
         ( "ACC_YY" = :sIwolYear ) AND ( "ACC_MM" = '00' ) AND
			( "ACC1_CD"||"ACC2_CD" NOT IN 
					(SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ14OT0" WHERE "SAUPJ" = :sSaupj AND "ACC_YY"||"ACC_MM" = :sIwolYear||'00'
					 minus
					 SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ14OT0" WHERE "SAUPJ" = :sSaupj AND "ACC_YY" = :sBefYear)) ;
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[������ ������ - �ʱ�ȭ]')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

INSERT INTO "KFZ14OT0"  
	( "SAUPJ",    					"ACC_YY",      	   	"ACC_MM",        
	  "ACC1_CD",        			"ACC2_CD",
	  "DR_AMT",			   		"CR_AMT",		   		"JAN_AMT" )  
SELECT :sSaupj,					:sIwolYear,					'00',					
		 A.ACC1,						A.ACC2, 
		 NVL(A.CHA,0) AS CHA,	NVL(A.DAE,0) AS DAE,		NVL(A.REMAIN,0) AS JAN
	FROM(SELECT  "KFZ14OT0"."ACC1_CD" AS ACC1,   
         		 "KFZ14OT0"."ACC2_CD" AS ACC2,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ14OT0"."DR_AMT",0) - NVL("KFZ14OT0"."CR_AMT",0),0)) AS CHA,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ14OT0"."CR_AMT",0) - NVL("KFZ14OT0"."DR_AMT",0),0)) AS DAE,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ14OT0"."DR_AMT",0) - NVL("KFZ14OT0"."CR_AMT",0),
						      								  NVL("KFZ14OT0"."CR_AMT",0) - NVL("KFZ14OT0"."DR_AMT",0))) AS REMAIN
    		FROM "KFZ14OT0",            "KFZ01OM0"  
			WHERE ( "KFZ14OT0"."ACC1_CD" = "KFZ01OM0"."ACC1_CD" ) and  
					( "KFZ14OT0"."ACC2_CD" = "KFZ01OM0"."ACC2_CD" ) and  
					( "KFZ14OT0"."SAUPJ" = :sSaupj ) AND  
					( "KFZ14OT0"."ACC_YY"  = :sBefYear ) AND  
					(( "KFZ14OT0"."ACC1_CD" >= '10000' ) AND  
					( "KFZ14OT0"."ACC1_CD" <  '40000' )) AND  
					( "KFZ01OM0"."BAL_GU" <> '4' )
			GROUP BY "KFZ14OT0"."ACC1_CD",  "KFZ14OT0"."ACC2_CD") A
//	WHERE A.CHA <> 0 OR A.DAE <> 0 OR A.REMAIN <> 0
	;

IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[������ ������]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

/*�������� ���*/
SELECT SUM("KFZ14OT0"."CR_AMT") - SUM("KFZ14OT0"."DR_AMT")
	INTO :dDangAmount
	FROM "KFZ14OT0"  
   WHERE ("KFZ14OT0"."SAUPJ" = :sSaupj ) AND  ("KFZ14OT0"."ACC_YY" = :sBefYear) AND  
         ("KFZ14OT0"."ACC1_CD" = :sSonIk_Acc1) AND ("KFZ14OT0"."ACC2_CD" = :sSonIk_Acc2);
IF SQLCA.SQLCODE <> 0 THEN 
	dDangAmount = 0
ELSE
	IF Isnull(dDangAmount) THEN dDangAmount = 0	
END IF

SELECT Count(*) 			INTO :iCount
	FROM "KFZ14OT0"
   WHERE ( "KFZ14OT0"."SAUPJ"   = :sSaupj ) AND ("KFZ14OT0"."ACC_YY"   = :sIwolYear ) AND 
			( "KFZ14OT0"."ACC_MM"  = '00' )    AND ( "KFZ14OT0"."ACC1_CD" = :sIk_Acc1 ) AND  
         ( "KFZ14OT0"."ACC2_CD" = :sIk_Acc2 )  ;
IF SQLCA.SQLCODE <> 0 THEN
	iCount = 0
ELSE
	IF Isnull(iCount) THEN iCount = 0
END IF

IF iCount = 0 THEN
	INSERT INTO "KFZ14OT0"  
   	( "SAUPJ",		"ACC_YY",		"ACC_MM",		"ACC1_CD",		"ACC2_CD",
		  "DR_AMT",		"CR_AMT",		"JAN_AMT" )  
  	VALUES 
	  	( :sSaupj,		:sIwolYear,		'00',				:sIk_Acc1,		:sIk_Acc2,
		  0,				:dDangAmount,	:dDangAmount)  ;
ELSE
	UPDATE "KFZ14OT0"
		SET "CR_AMT"  = "CR_AMT" + :dDangAmount,
		    "DR_AMT"  = "DR_AMT" + 0,
			 "JAN_AMT" = "JAN_AMT" + :dDangAmount 
		WHERE ( "KFZ14OT0"."SAUPJ" = :sSaupj ) AND
		      ( "KFZ14OT0"."ACC_YY" = :sIwolYear ) AND ( "KFZ14OT0"."ACC_MM" ='00' ) AND
         	( "KFZ14OT0"."ACC1_CD" = :sIk_Acc1 ) AND ( "KFZ14OT0"."ACC2_CD" = :sIk_Acc2 )  ;	
END IF
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[������ ������-�����׿���]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF

/* 2008.5.13  kwy 
   �����̿������׿����� ������ �׿��� ���������� �ܾ��� 0���� �缳���� 
   �ֳ� ���⿡�� �Ѿ�� ��ó�������׿����� ��� �����̿������׿��� ������ �հ��Ǿ� ���� ���� */
UPDATE "KFZ14OT0"
		SET "CR_AMT"  = 0,		    "DR_AMT"  =  0,		 "JAN_AMT" = 0
		WHERE ( "KFZ14OT0"."SAUPJ" = :sSaupj ) AND
		      ( "KFZ14OT0"."ACC_YY" = :sIwolYear ) AND ( "KFZ14OT0"."ACC_MM" ='00' ) AND
         	( "KFZ14OT0"."ACC1_CD" = :sIk_Acc1 ) AND ( "KFZ14OT0"."ACC2_CD" <> :sIk_Acc2 )  ;	
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[������ ������-�׿��ݰ��� �����ʱ�ȭ]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF

/*  */
Commit;

Return 1

end function

public function integer wf_create_acc_sdept (string ssaupj, string sbefyear, string siwolyear);String  sIk_Acc1,sIk_Acc2,sSonIk_Acc1,sSonIk_Acc2
Double  dDangAmount,dDr
Integer iCount =0

w_mdi_frame.sle_msg.text = '�����ι��� ������ ������ ó�� ��...'
SetPointer(HourGlass!)
/*�����ι��� ������ ������*/
DELETE FROM "KFZ14OT1"  
	WHERE ( "KFZ14OT1"."ACC_YY" = :sIwolYear ) AND ( "KFZ14OT1"."ACC_MM" = '00' )   ;
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�����ι��� ������ ������ - �ʱ�ȭ]')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

INSERT INTO "KFZ14OT1"  
	( "SAUP_DEPT",					"ACC_YY",      	   	"ACC_MM",        
	  "ACC1_CD",        			"ACC2_CD",
	  "DR_AMT",			   		"CR_AMT",		   		"JAN_AMT" )  
SELECT A.SDEPT,					:sIwolYear,					'00',					
		 A.ACC1,						A.ACC2, 
		 NVL(A.CHA,0) AS CHA,	NVL(A.DAE,0) AS DAE,		NVL(A.REMAIN,0) AS JAN
	FROM(SELECT  "KFZ14OT1"."SAUP_DEPT" AS SDEPT,
					 "KFZ14OT1"."ACC1_CD" AS ACC1,   
         		 "KFZ14OT1"."ACC2_CD" AS ACC2,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ14OT1"."DR_AMT",0) - NVL("KFZ14OT1"."CR_AMT",0),0)) AS CHA,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ14OT1"."CR_AMT",0) - NVL("KFZ14OT1"."DR_AMT",0),0)) AS DAE,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ14OT1"."DR_AMT",0) - NVL("KFZ14OT1"."CR_AMT",0),
						      								  NVL("KFZ14OT1"."CR_AMT",0) - NVL("KFZ14OT1"."DR_AMT",0))) AS REMAIN
    		FROM "KFZ14OT1",            "KFZ01OM0"  
			WHERE ( "KFZ14OT1"."ACC1_CD" = "KFZ01OM0"."ACC1_CD" ) and  
					( "KFZ14OT1"."ACC2_CD" = "KFZ01OM0"."ACC2_CD" ) and  
					( "KFZ14OT1"."ACC_YY"  = :sBefYear ) AND  
					(( "KFZ14OT1"."ACC1_CD" >= '10000' ) AND  
					( "KFZ14OT1"."ACC1_CD" <  '40000' )) AND  
					( "KFZ01OM0"."BAL_GU" <> '4' )
			GROUP BY "KFZ14OT1"."SAUP_DEPT","KFZ14OT1"."ACC1_CD",  "KFZ14OT1"."ACC2_CD") A
//	WHERE A.CHA <> 0 OR A.DAE <> 0 OR A.REMAIN <> 0
;

IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�����ι��� ������ ������]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

Return 1

end function

public function integer wf_create_cust (string ssaupj, string sbefyear, string siwolyear);
w_mdi_frame.sle_msg.text = '['+f_get_refferance('AD',sSaupj)+'] �ŷ�ó �ܰ� �̿� ó�� ��...'
SetPointer(HourGlass!)

/*�ŷ�ó�� ������*/
DELETE "KFZ13OT0"
	WHERE ( "SAUPJ"  = :sSaupj ) AND  
         ( "ACC_YY" = :sIwolYear ) AND ( "ACC_MM" = '00' ) AND
			( "ACC1_CD"||"ACC2_CD" NOT IN 
					(SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ13OT0" WHERE "SAUPJ" = :sSaupj AND "ACC_YY"||"ACC_MM" = :sIwolYear||'00'
					 minus
					 SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ13OT0" WHERE "SAUPJ" = :sSaupj AND "ACC_YY" = :sBefYear)) ;
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�ŷ�ó�� ������ - �ʱ�ȭ]')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

INSERT INTO "KFZ13OT0"  
	( "SAUPJ",    						"ACC_YY",      	   	"ACC_MM",        
	  "ACC1_CD",        				"ACC2_CD",					"SAUP_NO",
	  "DR_AMT",			   			"CR_AMT",		   		"JAN_AMT",
	  "DR_QTY",							"CR_QTY",					"JAN_QTY",
	  "YDR_AMT",						"YCR_AMT",					"YJAN_AMT")  
SELECT :sSaupj,						:sIwolYear,					'00',					
		 A.ACC1,							A.ACC2,						A.SAUP, 
		 NVL(A.CAMT,0) AS CAMT,		NVL(A.DAMT,0) AS DAMT,	NVL(A.RAMT,0) AS JAN_AMT,
		 NVL(A.CQTY,0) AS CQTY,		NVL(A.DQTY,0) AS DQTY,	NVL(A.RQTY,0) AS JAN_QTY,
		 NVL(A.CYAMT,0) AS CYAMT,	NVL(A.DYAMT,0) AS DAMT,	NVL(A.RYAMT,0) AS JAN_YAMT
	FROM(SELECT  "KFZ13OT0"."ACC1_CD" AS ACC1,   
         		 "KFZ13OT0"."ACC2_CD" AS ACC2,
					 "KFZ13OT0"."SAUP_NO" AS SAUP,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."DR_AMT",0) - NVL("KFZ13OT0"."CR_AMT",0),0)) AS CAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT0"."CR_AMT",0) - NVL("KFZ13OT0"."DR_AMT",0),0)) AS DAMT,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."DR_AMT",0) - NVL("KFZ13OT0"."CR_AMT",0),
						      								  NVL("KFZ13OT0"."CR_AMT",0) - NVL("KFZ13OT0"."DR_AMT",0))) AS RAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."DR_QTY",0) - NVL("KFZ13OT0"."CR_QTY",0),0)) AS CQTY,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT0"."CR_QTY",0) - NVL("KFZ13OT0"."DR_QTY",0),0)) AS DQTY,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."DR_QTY",0) - NVL("KFZ13OT0"."CR_QTY",0),
						      								  NVL("KFZ13OT0"."CR_QTY",0) - NVL("KFZ13OT0"."DR_QTY",0))) AS RQTY,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."YDR_AMT",0) - NVL("KFZ13OT0"."YCR_AMT",0),0)) AS CYAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT0"."YCR_AMT",0) - NVL("KFZ13OT0"."YDR_AMT",0),0)) AS DYAMT,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT0"."YDR_AMT",0) - NVL("KFZ13OT0"."YCR_AMT",0),						      								  
					 											  NVL("KFZ13OT0"."YCR_AMT",0) - NVL("KFZ13OT0"."YDR_AMT",0))) AS RYAMT																  
    		FROM "KFZ13OT0",            "KFZ01OM0"  
			WHERE ( "KFZ13OT0"."ACC1_CD" = "KFZ01OM0"."ACC1_CD" ) and  
					( "KFZ13OT0"."ACC2_CD" = "KFZ01OM0"."ACC2_CD" ) and  
					( "KFZ13OT0"."SAUPJ" = :sSaupj ) AND  
					( "KFZ13OT0"."ACC_YY"  = :sBefYear ) AND  
					(( "KFZ13OT0"."ACC1_CD" >= '10000' ) AND  
					( "KFZ13OT0"."ACC1_CD" <  '40000' )) AND  
					( "KFZ01OM0"."BAL_GU" <> '4' )
			GROUP BY "KFZ13OT0"."ACC1_CD",  "KFZ13OT0"."ACC2_CD","KFZ13OT0"."SAUP_NO") A
//	WHERE A.CAMT  <> 0 OR A.DAMT  <> 0 OR A.CQTY  <> 0 OR A.DQTY <> 0 OR
//			A.CYAMT <> 0 OR A.DYAMT <> 0 
			;

IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�ŷ�ó�� ������]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

Return 1

end function

public function integer wf_create_cust_curr (string ssaupj, string sbefyear, string siwolyear);
w_mdi_frame.sle_msg.text = '['+f_get_refferance('AD',sSaupj)+'] ��ȭ �ܰ� �̿� ó�� ��...'
SetPointer(HourGlass!)

/*�ŷ�ó�� ������*/
DELETE "KFZ13OT2"
	WHERE ( "SAUPJ"  = :sSaupj ) AND  
         ( "ACC_YY" = :sIwolYear ) AND ( "ACC_MM" = '00' ) AND
			( "ACC1_CD"||"ACC2_CD" NOT IN 
					(SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ13OT2" WHERE "SAUPJ" = :sSaupj AND "ACC_YY"||"ACC_MM" = :sIwolYear||'00'
					 minus
					 SELECT "ACC1_CD"||"ACC2_CD" FROM "KFZ13OT2" WHERE "SAUPJ" = :sSaupj AND "ACC_YY" = :sBefYear)) ;
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[��ȭ�� ������ - �ʱ�ȭ]')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

INSERT INTO "KFZ13OT2"  
	( "SAUPJ",    						"ACC_YY",      	   	"ACC_MM",        
	  "ACC1_CD",       				"ACC2_CD",					"SAUP_NO",			"KWAN_NO",
	  "DR_AMT",			   			"CR_AMT",		   		"JAN_AMT",
	  "DR_QTY",							"CR_QTY",					"JAN_QTY",
	  "YDR_AMT",						"YCR_AMT",					"YJAN_AMT")  
SELECT :sSaupj,						:sIwolYear,					'00',					
		 A.ACC1,							A.ACC2,						A.SAUP,				A.KWAN_NO, 
		 NVL(A.CAMT,0) AS CAMT,		NVL(A.DAMT,0) AS DAMT,	NVL(A.RAMT,0) AS JAN_AMT,
		 NVL(A.CQTY,0) AS CQTY,		NVL(A.DQTY,0) AS DQTY,	NVL(A.RQTY,0) AS JAN_QTY,
		 NVL(A.CYAMT,0) AS CYAMT,	NVL(A.DYAMT,0) AS DAMT,	NVL(A.RYAMT,0) AS JAN_YAMT
	FROM(SELECT  "KFZ13OT2"."ACC1_CD" AS ACC1,   
         		 "KFZ13OT2"."ACC2_CD" AS ACC2,
					 "KFZ13OT2"."SAUP_NO" AS SAUP,
					 "KFZ13OT2"."KWAN_NO" AS KWAN_NO,	
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."DR_AMT",0) - NVL("KFZ13OT2"."CR_AMT",0),0)) AS CAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT2"."CR_AMT",0) - NVL("KFZ13OT2"."DR_AMT",0),0)) AS DAMT,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."DR_AMT",0) - NVL("KFZ13OT2"."CR_AMT",0),
						      								  NVL("KFZ13OT2"."CR_AMT",0) - NVL("KFZ13OT2"."DR_AMT",0))) AS RAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."DR_QTY",0) - NVL("KFZ13OT2"."CR_QTY",0),0)) AS CQTY,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT2"."CR_QTY",0) - NVL("KFZ13OT2"."DR_QTY",0),0)) AS DQTY,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."DR_QTY",0) - NVL("KFZ13OT2"."CR_QTY",0),
						      								  NVL("KFZ13OT2"."CR_QTY",0) - NVL("KFZ13OT2"."DR_QTY",0))) AS RQTY,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."YDR_AMT",0) - NVL("KFZ13OT2"."YCR_AMT",0),0)) AS CYAMT,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT2"."YCR_AMT",0) - NVL("KFZ13OT2"."YDR_AMT",0),0)) AS DYAMT,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT2"."YDR_AMT",0) - NVL("KFZ13OT2"."YCR_AMT",0),						      								  
					 											  NVL("KFZ13OT2"."YCR_AMT",0) - NVL("KFZ13OT2"."YDR_AMT",0))) AS RYAMT																  
    		FROM "KFZ13OT2",            "KFZ01OM0"  
			WHERE ( "KFZ13OT2"."ACC1_CD" = "KFZ01OM0"."ACC1_CD" ) and  
					( "KFZ13OT2"."ACC2_CD" = "KFZ01OM0"."ACC2_CD" ) and  
					( "KFZ13OT2"."SAUPJ" = :sSaupj ) AND  
					( "KFZ13OT2"."ACC_YY"  = :sBefYear ) AND  
					(( "KFZ13OT2"."ACC1_CD" >= '10000' ) AND  
					( "KFZ13OT2"."ACC1_CD" <  '40000' )) AND  
					( "KFZ01OM0"."BAL_GU" <> '4' )
			GROUP BY "KFZ13OT2"."ACC1_CD",  "KFZ13OT2"."ACC2_CD","KFZ13OT2"."SAUP_NO","KFZ13OT2"."KWAN_NO") A
//	WHERE A.CAMT  <> 0 OR A.DAMT  <> 0 OR A.CQTY  <> 0 OR A.DQTY <> 0 OR
//			A.CYAMT <> 0 OR A.DYAMT <> 0 
			;

IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[��ȭ�� ������]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

Return 1

end function

public function integer wf_create_cust_sdept (string ssaupj, string sbefyear, string siwolyear);
w_mdi_frame.sle_msg.text = '�����ι��� �ŷ�ó�� ������ ó�� ��...'
SetPointer(HourGlass!)
/*�����ι��� �ŷ�ó�� ������*/
DELETE FROM "KFZ13OT1"  
	WHERE ( "KFZ13OT1"."ACC_YY" = :sIwolYear ) AND ( "KFZ13OT1"."ACC_MM" = '00' )   ;
IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�����ι��� �ŷ�ó�� ������ - �ʱ�ȭ]')
	Rollback;
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

INSERT INTO "KFZ13OT1"  
	( "SAUP_DEPT",					"CVCOD",						"ACC_YY",
	  "ACC_MM",        		   "ACC1_CD",       			"ACC2_CD",
	  "DR_AMT",			   		"CR_AMT",		   		"JAN_AMT" )  
SELECT A.SDEPT,					A.SAUP,						:sIwolYear,	
		 '00',					 	A.ACC1,						A.ACC2, 
		 NVL(A.CHA,0) AS CHA,	NVL(A.DAE,0) AS DAE,		NVL(A.REMAIN,0) AS JAN
	FROM(SELECT  "KFZ13OT1"."SAUP_DEPT" AS SDEPT,
					 "KFZ13OT1"."CVCOD" AS SAUP,
					 "KFZ13OT1"."ACC1_CD" AS ACC1,   
         		 "KFZ13OT1"."ACC2_CD" AS ACC2,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT1"."DR_AMT",0) - NVL("KFZ13OT1"."CR_AMT",0),0)) AS CHA,
					 SUM(DECODE("KFZ01OM0"."DC_GU",'2',NVL("KFZ13OT1"."CR_AMT",0) - NVL("KFZ13OT1"."DR_AMT",0),0)) AS DAE,   
					 SUM(DECODE("KFZ01OM0"."DC_GU",'1',NVL("KFZ13OT1"."DR_AMT",0) - NVL("KFZ13OT1"."CR_AMT",0),
						      								  NVL("KFZ13OT1"."CR_AMT",0) - NVL("KFZ13OT1"."DR_AMT",0))) AS REMAIN
    		FROM "KFZ13OT1",            "KFZ01OM0"  
			WHERE ( "KFZ13OT1"."ACC1_CD" = "KFZ01OM0"."ACC1_CD" ) and  
					( "KFZ13OT1"."ACC2_CD" = "KFZ01OM0"."ACC2_CD" ) and  
					( "KFZ13OT1"."ACC_YY"  = :sBefYear ) AND  
					(( "KFZ13OT1"."ACC1_CD" >= '10000' ) AND  
					( "KFZ13OT1"."ACC1_CD" <  '40000' )) AND  
					( "KFZ01OM0"."BAL_GU" <> '4' )
			GROUP BY "KFZ13OT1"."SAUP_DEPT",		"KFZ13OT1"."CVCOD",
						"KFZ13OT1"."ACC1_CD",		"KFZ13OT1"."ACC2_CD") A
//	WHERE A.CHA <> 0 OR A.DAE <> 0 OR A.REMAIN <> 0
	;

IF SQLCA.SQLCODE <> 0 THEN 
	F_MessageChk(13,'[�����ι��� �ŷ�ó�� ������]'+sqlca.sqlerrtext)
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
END IF
Commit;

Return 1

end function

event open;call super::open;
dw_saupj.SetTransObject(sqlca)
dw_saupj.Reset()
dw_saupj.InsertRow(0)
dw_saupj.SetItem(dw_saupj.GetRow(),"saupj",gs_saupj)
dw_saupj.SetItem(dw_saupj.GetRow(),"acc_yy",String(today(),"yyyy"))


end event

on w_kgle02.create
int iCurrent
call super::create
this.dw_saupj=create dw_saupj
this.cb_6=create cb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_saupj
this.Control[iCurrent+2]=this.cb_6
end on

on w_kgle02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_saupj)
destroy(this.cb_6)
end on

type dw_insert from w_inherite`dw_insert within w_kgle02
boolean visible = false
integer x = 498
integer y = 2024
integer taborder = 40
end type

type p_delrow from w_inherite`p_delrow within w_kgle02
boolean visible = false
integer x = 3063
integer y = 2212
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgle02
boolean visible = false
integer x = 2889
integer y = 2212
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgle02
boolean visible = false
integer x = 2194
integer y = 2212
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgle02
boolean visible = false
integer x = 2715
integer y = 2212
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgle02
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kgle02
boolean visible = false
integer x = 3584
integer y = 2212
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgle02
boolean visible = false
integer x = 2368
integer y = 2212
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgle02
boolean visible = false
integer x = 2542
integer y = 2212
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kgle02
boolean visible = false
integer x = 3410
integer y = 2212
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kgle02
event ue_sonik pbm_custom01
integer x = 4270
integer taborder = 20
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::ue_sonik;Double ldb_tot_cha,ldb_tot_dai
//////////////////////////////////////////////////////////
//*********��� ������ or ���ս�                        //
//************IF �뺯 SUM - ���� SUM < 0 THEN �����ս�//
//************   �뺯 SUM - ���� SUM > 0 THEN ��������//              
//////////////////////////////////////////////////////////
SELECT SUM("KFZ14OT0"."DR_AMT"),
		 SUM("KFZ14OT0"."CR_AMT")
	INTO :ldb_tot_cha,
		  :ldb_tot_dai
 	FROM "KFZ14OT0"  
   WHERE ("KFZ14OT0"."SAUPJ" = :ls_saupj) AND  
         ("KFZ14OT0"."ACC_YY" = :ls_yy) AND  
         (("KFZ14OT0"."ACC_MM" >= '00') AND  
         ("KFZ14OT0"."ACC_MM" <= '12')) AND  
         (("KFZ14OT0"."ACC1_CD" >= '40000') AND  
         ("KFZ14OT0"."ACC1_CD" <= '48010')) AND
			("KFZ14OT0"."ACC2_CD" <> '  ') ;
IF SQLCA.SQLCODE =0 THEN
	ldb_dangi_amt =ldb_tot_dai - ldb_tot_cha
ELSE
	ldb_dangi_amt =0
END IF







end event

event p_mod::clicked;call super::clicked;String  sIWolYear,sYear,sSaupj
Integer iRtnValue,iFrom,iTo,k
Double  dDangAmount

w_mdi_frame.sle_msg.text =""

dw_saupj.AcceptText()
sSaupj = dw_saupj.GetItemString(dw_saupj.GetRow(),"saupj")
sYear  = dw_saupj.GetItemString(dw_saupj.GetRow(),"acc_yy")

IF sYear ="" OR IsNull(sYear) THEN
	F_MessageChk(1,'[ó���⵵]')
	dw_saupj.SetColumn("acc_yy")
	dw_saupj.SetFocus()
	Return
ELSE
	IF Not IsNumber(sYear) THEN
		F_MessageChk(21,'[ó���⵵]')
		dw_saupj.SetColumn("acc_yy")
		dw_saupj.SetFocus()
		Return
	END IF
	
	sIwolYear = String(Long(sYear) + 1,'0000')
END IF

IF IsNull(sSaupj) OR sSaupj ="" THEN
	select min(to_number(rfgub)) 	into :iFrom from reffpf where rfcod = 'AD' and rfgub <> '99' and rfgub <> '00';

	select max(to_number(rfgub)) 	into :iTo from reffpf where rfcod = 'AD' and rfgub <> '99' and rfgub <> '00';
ELSE
	iFrom = Integer(sSaupj);			iTo = Integer(sSaupj);
END IF

FOR k = iFrom TO iTo
	sSaupj = String(k,'00')
	
	iRtnValue = Wf_Create_Acc(sSaupj,sYear,sIwolYear)				/*������*/
	IF iRtnValue = -1 THEN Return
	
	iRtnValue = Wf_Create_Cust(sSaupj,sYear,sIwolYear)				/*�ŷ�ó��*/
	IF iRtnValue = -1 THEN Return	
	
	iRtnValue = Wf_Create_Cust_Curr(sSaupj,sYear,sIwolYear)				/*�ŷ�ó,��ȭ��*/
	IF iRtnValue = -1 THEN Return	
NEXT

iRtnValue = Wf_Create_Acc_Sdept(sSaupj,sYear,sIwolYear)				/*������-�����ι�*/
IF iRtnValue = -1 THEN Return
	
iRtnValue = Wf_Create_Cust_Sdept(sSaupj,sYear,sIwolYear)				/*�ŷ�ó��-�����ι�*/
IF iRtnValue = -1 THEN Return	
	
w_mdi_frame.sle_msg.text ="������,�ŷ�ó�� ���� ���� ��...."
F_ACC_SUM(sIwolYear+"00",sIwolYear+"00")

SetPointer(Arrow!)

w_mdi_frame.sle_msg.text ="���̿� ó���� �Ϸ��߽��ϴ�.!!!"


end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kgle02
integer x = 3209
integer y = 1892
integer width = 315
end type

type cb_mod from w_inherite`cb_mod within w_kgle02
integer x = 978
integer y = 2560
integer width = 293
end type

event cb_mod::clicked;call super::clicked;//String date
//Long ll_add_yy
//Double ldb_cha_amt,ldb_dai_amt,ldb_bef_ik
//
//sle_msg.text =""
//dw_saupj.AcceptText()
//ls_saupj =dw_saupj.GetItemString(dw_saupj.GetRow(),"saupj")
//ls_yy =dw_saupj.GetItemString(dw_saupj.GetRow(),"acc_yy")
//
//Date =ls_yy+"/"+"01"+"/"+"01"
//IF ls_saupj ="" OR IsNull(ls_yy) THEN
//	MessageBox("Ȯ��","������� �Է��ϼ���.!!!")
//	dw_saupj.SetColumn("saupj")
//	dw_saupj.SetFocus()
//	Return
//END IF
//
//IF ls_yy ="" OR IsNull(ls_yy) THEN
//	MessageBox("Ȯ��","ȸ��⵵�� �Է��ϼ���.!!!")
//	dw_saupj.SetColumn("acc_yy")
//	dw_saupj.SetFocus()
//	Return
//ELSEIF Not IsDate(Date) THEN
//	MessageBox("Ȯ��","ȸ��⵵�� Ȯ���ϼ���.!!!")
//	dw_saupj.SetColumn("acc_yy")
//	dw_saupj.SetFocus()
//	Return
//END IF
//
//ll_add_yy =Long(ls_yy)										//�̿��ϰ����ϴ� �⵵
//ll_add_yy +=1
//ls_add_yy =String(ll_add_yy)
//
//cb_6.TriggerEvent("ue_sonik") 							//���̰����� �����ս�/������
//
//cb_5.TriggerEvent("ue_gaejung_init") 					//������ ������ �ʱ�ȭ
//IF continue_flag =False THEN
//	MessageBox("Ȯ��","������ �������� �ʱ�ȭ�� �����߽��ϴ�.!!!")
//	continue_flag =True
//	Return
//ELSE
//	sle_msg.text ="������ �������� �ʱ�ȭ�� �Ϸ��߽��ϴ�.!!!"
//END IF
//
//SetPointer(HourGlass!)
//cb_5.TriggerEvent(Clicked!)
//IF continue_flag =False THEN
//	MessageBox("Ȯ��","������ ������ ����ó���� �����߽��ϴ�.!!!")
//	continue_flag =True
//	Return
//ELSE
//	COMMIT;
//	sle_msg.text ="������ ������ ����ó���� �Ϸ��߽��ϴ�.!!!"
//END IF
//
////���Ͱ������� ����  '�����ս�/������' �� �����̿������׿���(33080-01)�� UPDATE//
//
//SELECT "KFZ14OT0"."CR_AMT" ,"KFZ14OT0"."DR_AMT"
//   INTO :ldb_dai_amt, :ldb_cha_amt
//   FROM "KFZ14OT0"
//   WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND
//			( "KFZ14OT0"."ACC_YY" = :ls_add_yy ) AND 
//			( "KFZ14OT0"."ACC_MM" ='00' ) AND
//         ( "KFZ14OT0"."ACC1_CD" = '33080' ) AND  
//         ( "KFZ14OT0"."ACC2_CD" = '01' )  ;
//
//IF IsNull(ldb_dai_amt) OR ldb_dai_amt = 0 THEN
//	ldb_bef_ik =ldb_dangi_amt
// ELSE
//	ldb_bef_ik =ldb_dai_amt + ldb_dangi_amt		
//END IF
//
//IF SQLCA.SQLCODE =0 THEN
//	UPDATE "KFZ14OT0"
//		SET "CR_AMT" = :ldb_bef_ik,
//		    "DR_AMT" = 0
//		WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND
//		      ( "KFZ14OT0"."ACC_YY" = :ls_add_yy ) AND 
//				( "KFZ14OT0"."ACC_MM" ='00' ) AND
//         	( "KFZ14OT0"."ACC1_CD" = '33080' ) AND  
//         	( "KFZ14OT0"."ACC2_CD" = '01' )  ;	
//ELSE
//	INSERT INTO "KFZ14OT0"  
//        ( "SAUPJ","ACC_YY","ACC_MM","ACC1_CD","ACC2_CD","CR_AMT","DR_AMT" )  
//  		VALUES ( :ls_saupj,:ls_add_yy,'00','33080','01',:ldb_bef_ik,0)  ;
//END IF
//IF SQLCA.SQLCODE <> 0 THEN
//	MessageBox("Ȯ��","�����������̿������׿��� UPDATE�� �����߽��ϴ�.!!!")
//	Return
//ELSE
//	COMMIT;
//END IF
//
////���Ͱ������� ����  '�����ս�/������' �� �����̿������׿���(33080-01)�� UPDATE//
//
////SELECT "KFZ14OT0"."CR_AMT" ,"KFZ14OT0"."DR_AMT"
////   INTO :ldb_dai_amt, :ldb_cha_amt
////   FROM "KFZ14OT0"
////   WHERE ( "KFZ14OT0"."SAUPJ" = '9' ) AND
////			( "KFZ14OT0"."ACC_YY" = :ls_add_yy ) AND 
////			( "KFZ14OT0"."ACC_MM" ='00' ) AND
////         ( "KFZ14OT0"."ACC1_CD" = '33080' ) AND  
////         ( "KFZ14OT0"."ACC2_CD" = '01' )  ;
////
////IF IsNull(ldb_dai_amt) OR ldb_dai_amt = 0 THEN
////	ldb_bef_ik =ldb_dangi_amt
//// ELSE
////	ldb_bef_ik =ldb_dai_amt + ldb_dangi_amt		
////END IF
////
////IF SQLCA.SQLCODE =0 THEN
////	UPDATE "KFZ14OT0"
////		SET "CR_AMT" = :ldb_bef_ik,
////		    "DR_AMT" = 0
////		WHERE ( "KFZ14OT0"."SAUPJ" = '9' ) AND
////		      ( "KFZ14OT0"."ACC_YY" = :ls_add_yy ) AND 
////				( "KFZ14OT0"."ACC_MM" ='00' ) AND
////         	( "KFZ14OT0"."ACC1_CD" = '33080' ) AND  
////         	( "KFZ14OT0"."ACC2_CD" = '01' )  ;	
////ELSE
////	INSERT INTO "KFZ14OT0"  
////        ( "SAUPJ","ACC_YY","ACC_MM","ACC1_CD","ACC2_CD","CR_AMT","DR_AMT" )  
////  		VALUES ( '9',:ls_add_yy,'00','33080','01',:ldb_bef_ik,0)  ;
////END IF
////IF SQLCA.SQLCODE <> 0 THEN
////	MessageBox("Ȯ��","�����������̿������׿��� ������ UPDATE�� �����߽��ϴ�(����).!!!")
////	Return
////ELSE
////	COMMIT;
////END IF
//
//cb_2.TriggerEvent("ue_saupno_init") 					//�ŷ�ó�� ������ �ʱ�ȭ
//IF continue_flag =False THEN
//	MessageBox("Ȯ��","�ŷ�ó�� �������� �ʱ�ȭ�� �����߽��ϴ�.!!!")
//	continue_flag =True
//	Return
//ELSE
//	sle_msg.text ="�ŷ�ó�� �������� �ʱ�ȭ�� �Ϸ��߽��ϴ�.!!!"
//END IF
//
//cb_2.TriggerEvent(Clicked!)
//IF continue_flag =False THEN
//	MessageBox("Ȯ��","�ŷ�ó�� ������ ����ó���� �����߽��ϴ�.!!!")
//	continue_flag =True
//	Return
//ELSE
//	COMMIT;
//	sle_msg.text ="�ŷ�ó�� ������ ����ó���� �Ϸ��߽��ϴ�.!!!"
//END IF
//
//sle_msg.text ="������,�ŷ�ó�� ���� ���� ��...."
//
//F_ACC_SUM(ls_add_yy+"00",ls_add_yy+"00")
//SetPointer(Arrow!)
//sle_msg.text ="���̿� ó���� �Ϸ��߽��ϴ�.!!!"
//
//
end event

type cb_ins from w_inherite`cb_ins within w_kgle02
integer x = 649
integer y = 2560
integer width = 293
string text = "�߰�(&I)"
end type

type cb_del from w_inherite`cb_del within w_kgle02
integer x = 1303
integer y = 2560
integer width = 293
end type

type cb_inq from w_inherite`cb_inq within w_kgle02
integer y = 2560
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kgle02
integer x = 1957
integer y = 2552
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kgle02
integer y = 2100
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_kgle02
integer x = 2277
integer y = 2556
integer width = 293
end type

type cb_search from w_inherite`cb_search within w_kgle02
integer x = 2601
integer y = 2560
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kgle02
integer x = 2853
integer y = 2100
integer width = 741
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kgle02
integer x = 325
integer y = 2100
integer width = 2528
end type

type gb_10 from w_inherite`gb_10 within w_kgle02
integer y = 2048
end type

type gb_button1 from w_inherite`gb_button1 within w_kgle02
integer x = 1874
integer y = 2260
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle02
integer x = 2862
integer y = 1836
integer width = 727
end type

type dw_saupj from datawindow within w_kgle02
event ue_pressenter pbm_dwnprocessenter
integer x = 613
integer y = 344
integer width = 3291
integer height = 1384
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgle02_0"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type cb_6 from commandbutton within w_kgle02
event ue_sonik pbm_custom01
boolean visible = false
integer x = 2912
integer y = 1888
integer width = 315
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ó��(&E)"
end type

