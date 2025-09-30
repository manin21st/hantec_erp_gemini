$PBExportHeader$w_kglb15.srw
$PBExportComments$�������� ������ǥ ó��-��������(Y/N)
forward
global type w_kglb15 from w_inherite
end type
type rr_1 from roundrectangle within w_kglb15
end type
type dw_ip from u_key_enter within w_kglb15
end type
type gb_2 from groupbox within w_kglb15
end type
type dw_junpoy from datawindow within w_kglb15
end type
type dw_sungin from datawindow within w_kglb15
end type
type dw_print from datawindow within w_kglb15
end type
type dw_rbill from datawindow within w_kglb15
end type
type dw_bill from datawindow within w_kglb15
end type
type gb_bill from groupbox within w_kglb15
end type
type dw_ipgum from datawindow within w_kglb15
end type
type gb_ipgum from groupbox within w_kglb15
end type
type dw_delete from datawindow within w_kglb15
end type
end forward

global type w_kglb15 from w_inherite
string title = "�������� ������ǥ ó��"
rr_1 rr_1
dw_ip dw_ip
gb_2 gb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_rbill dw_rbill
dw_bill dw_bill
gb_bill gb_bill
dw_ipgum dw_ipgum
gb_ipgum gb_ipgum
dw_delete dw_delete
end type
global w_kglb15 w_kglb15

type variables

String sUpmuGbn = 'I',LsAutoSungGbn,LsCheckLimitGbn,LsHalGb
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno)
public function integer wf_chk_validdate (ref string scurdate)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string s_bu, string s_sawon, double dsendfee)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"sun") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"kfm02ot0_saupj")
		sBalDate = dw_delete.GetItemString(k,"kfm02ot0_mbal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"kfm02ot0_mupmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"kfm02ot0_mjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1

		FOR i = iRowCount TO 1 STEP -1							/*��ǥ ����*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		END IF

		DELETE FROM "KFZ12OT1"  										/*��ǥǰ�ǳ��� ����*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
					
		/*�������� ��ǥ ���� ���*/
		DECLARE cursor_bill CURSOR FOR  
  			SELECT "KFM02OT0"."BILL_NO",   
      	   	 "KFM02OT0"."CHU_YMD"  
	    	FROM "KFM02OT0"  
   		WHERE ( "KFM02OT0"."MBAL_DATE" = :sBalDate ) AND  
      	   	( "KFM02OT0"."MUPMU_GU"  = :sUpmuGu ) AND  
         		( "KFM02OT0"."MJUN_NO"   = :lJunNo )   ;
		OPEN cursor_bill;
	
		DO WHILE true
			FETCH cursor_bill INTO :sBill,:sChuYmd;
			
			IF SQLCA.SQLCODE <> 0 THEN EXIT
			
			IF sChuYmd ="" OR IsNull(sChuYmd) THEN
				sStatus ='1'
			ELSE
				sStatus ='3'
			END IF
					
			UPDATE "KFM02OT0"  
				SET "STATUS" = :sStatus,   
					 "MBAL_DATE" = :snull,   
					 "MUPMU_GU" = :snull,   
					 "MJUN_NO" = :lnull  
				WHERE "KFM02OT0"."BILL_NO" = :sBill   ;
			IF SQLCA.SQLCODE <> 0 THEN
				F_MessageChk(12,'[��������]')
				ROLLBACK;
				SetPointer(Arrow!)
				RETURN -1
			END IF
		LOOP
		CLOSE cursor_bill;
	END IF
NEXT
SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno);Integer iFindRow,iCurRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+&
					       String(lJunNo,'0000')+String(lLinNo,'000')

iFindRow = dw_rbill.InsertRow(0)
	
dw_rbill.SetItem(iFindRow,"saupj",			sSaupj)
dw_rbill.SetItem(iFindRow,"bal_date",		sBalDate)
dw_rbill.SetItem(iFindRow,"upmu_gu",		sUpmuGbn)
dw_rbill.SetItem(iFindRow,"bjun_no",		lJunNo)
dw_rbill.SetItem(iFindRow,"lin_no",			lLinNo)
dw_rbill.SetItem(iFindRow,"full_junno",	sFullJunNo)

dw_rbill.SetItem(iFindRow,"mbal_date",		sBalDate)
dw_rbill.SetItem(iFindRow,"mupmu_gu",		sUpmuGbn)
dw_rbill.SetItem(iFindRow,"mjun_no",		lJunNo)
dw_rbill.SetItem(iFindRow,"mlin_no",		lLinNo)
	
dw_rbill.SetItem(iFindRow,"bill_no",		dw_bill.GetItemString(iRow,"bill_no"))
dw_rbill.SetItem(iFindRow,"saup_no",		dw_bill.GetItemString(iRow,"saup_no"))
dw_rbill.SetItem(iFindRow,"bnk_cd",			dw_bill.GetItemString(iRow,"bnk_cd"))
dw_rbill.SetItem(iFindRow,"bbal_dat",		dw_bill.GetItemString(iRow,"bbal_dat"))
dw_rbill.SetItem(iFindRow,"bman_dat",		dw_bill.GetItemString(iRow,"bman_dat"))
dw_rbill.SetItem(iFindRow,"bill_amt",		dw_bill.GetItemNumber(iRow,"bill_amt"))
dw_rbill.SetItem(iFindRow,"bill_nm",		dw_bill.GetItemString(iRow,"bill_nm"))
dw_rbill.SetItem(iFindRow,"bill_ris",		dw_bill.GetItemString(iRow,"bill_ris"))
dw_rbill.SetItem(iFindRow,"bill_gu",		dw_bill.GetItemString(iRow,"bill_gu"))
dw_rbill.SetItem(iFindRow,"bill_jigu",		dw_bill.GetItemString(iRow,"bill_jigu"))
dw_rbill.SetItem(iFindRow,"remark1",		dw_bill.GetItemString(iRow,"remark1"))
dw_rbill.SetItem(iFindRow,"status",			'4')
dw_rbill.SetItem(iFindRow,"bill_ntinc",		dw_ip.GetItemString(1, "hal_bank"))
dw_rbill.SetItem(iFindRow,"bill_change_date",dw_ip.GetItemString(1, "bal_date"))
dw_rbill.SetItem(iFindRow,"limit_aplgbn",    dw_bill.GetItemString(iRow,"limit_aplgbn"))

dw_rbill.SetItem(iFindRow,"owner_saupj",	sSaupj)

Return 1
end function

public function integer wf_chk_validdate (ref string scurdate);String sDayGbn,sHDayGbn
Integer iValidChk = -1

Do
	SELECT NVL("DAYGUBN",'0'),   NVL("HDAYGUBN",'0')		INTO :sDayGbn,   :sHDayGbn     	
		FROM "P4_CALENDAR"  WHERE "CLDATE" = :scurdate;

	if sDayGbn <> '1' THEN 			/*���ϱ��� <> '�Ͽ���'*/
		iValidChk = 1
	else
		sCurDate = String(RelativeDate(Date(Left(sCurDate,4)+'.'+Mid(sCurDate,5,2)+'.'+Right(sCurDate,2)),1),'yyyymmdd')
		iValidChk = -1
	end if
Loop Until iValidChk = 1
	
Return iValidChk
end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string s_bu, string s_sawon, double dsendfee);/************************************************************************************/
/* ������� ���������� �ڵ����� ��ǥ ó���Ѵ�.													*/
/* 1. ���� : ���¿���, �������� , ���η�,���޼�����											*/
/* 2. �뺯 : ���������������� �߻�																	*/
/************************************************************************************/
String  sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sSaupNo,sDepotNo,sBillNo,sStatus,sBManDate
String  sDcGbn, sExp, sName,sAcc1_SendFee,sAcc2_SendFee,sChaDae,sYesanGbn,sDepotName,sRemark1
Integer k,lLinNo,lJunNo,iCurRow
Double  dAmount,dwonAmount
Integer i
String  sAcc1_DaeChe, sAcc2_DaeChe, sDpno, s_hal_bank, s_hal_bank_nm,sPrcGbn
Decimal d_rate

dw_junpoy.Reset()
dw_rbill.Reset()
dw_sungin.Reset()

w_mdi_frame.sle_msg.text =""

/*��������*/
SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2)						/*��������*/
	INTO :sAcc1_Dae,  				:sAcc2_Dae	
   FROM "SYSCNFG"  
   WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND  ( "LINENO" = '23' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[�������� ����]')
	Return -1
END IF

/* �۱ݼ����� */
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		
	INTO :sAcc1_SendFee,						  :sAcc2_SendFee	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '34' )  ;			
IF SQLCA.SQLCODE <> 0 THEN
   F_MessageChk(56,'�۱ݼ����� ����[(A-1-34)]')
   RETURN -1
END IF

w_mdi_frame.sle_msg.text ="�������� ���� �ڵ���ǥ ó�� �� ..."

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[��������]')
	Return -1
END IF
		
/*��ǥ��ȣ ä��*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1
  
/*�Ա��׸��� �ǰ��� ó��    */
/* �������� ���¿���, �������� */
FOR i = 1 TO dw_ipgum.RowCount()
	sDpno = dw_ipgum.GetItemString(i, "e_code")

   SELECT "KFZ04OM0_V5"."PERSON_AC1", "KFZ04OM0_V5"."PERSON_CD2",
			 "KFZ04OM0_V5"."PERSON_NM",	"KFZ04OM0_V5"."PERSON_NO"
		INTO :sAcc1_Cha,	 	            :sAcc2_Cha,
			  :sDepotName,						:sDepotNo	 	
   	FROM "KFZ04OM0_V5"
   	WHERE "KFZ04OM0_V5"."PERSON_CD" = :sDpNo   ;
   IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(16,'[���¿� ���� �������� ����]')
	   RETURN -1
   END IF
	
	dAmount   = dw_ipgum.GetItemNumber(i,"e_gum")
			
	sDcGbn = '1'											/*���� ��ǥ*/
			
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)		
	dw_junpoy.SetItem(iCurRow,"dept_cd", s_bu)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
	dw_junpoy.SetItem(iCurRow,"sawon",   s_sawon)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '�������� ���� �Ա�')
		
	dw_junpoy.SetItem(iCurRow,"sdept_cd", dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd"))
	dw_junpoy.SetItem(iCurRow,"saup_no", sDpNo) 
	dw_junpoy.SetItem(iCurRow,"in_nm",   sDepotName+'['+sDepotNo+']') 
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
   lLinNo = lLinNo + 1			
NEXT			

/* �۱ݼ����� insert */	
IF dSendFee <> 0 AND Not IsNull(dSendFee) THEN
	SELECT "KFZ01OM0"."DC_GU",		"KFZ01OM0"."YESAN_GU",			"KFZ01OM0"."REMARK1"
		INTO :sChaDae,					:sYesanGbn,							:sRemark1
		FROM "KFZ01OM0"  
		WHERE ("KFZ01OM0"."ACC1_CD" = :sAcc1_SendFee) AND ("KFZ01OM0"."ACC2_CD" = :sAcc2_SendFee);

	sDcGbn  = '1'							/*���� ��ǥ*/
		
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	dw_junpoy.SetItem(iCurRow,"dept_cd", s_bu)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_SendFee)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_SendFee)
	dw_junpoy.SetItem(iCurRow,"sawon",   s_sawon)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
	dw_junpoy.SetItem(iCurRow,"amt",     dSendFee)	 
	dw_junpoy.SetItem(iCurRow,"descr",   '�۱ݼ�����')
	dw_junpoy.SetItem(iCurRow,"sdept_cd", dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd"))
	
	dw_junpoy.SetItem(iCurRow,"saup_no", s_bu) 
	dw_junpoy.SetItem(iCurRow,"in_nm",   F_Get_PersonLst('3',s_Bu,'%')) 
				
//	dw_junpoy.SetItem(iCurRow,"kwan_no", sBillNo) 
//	dw_junpoy.SetItem(iCurRow,"k_symd",  sbaldate)
//	dw_junpoy.SetItem(iCurRow,"k_eymd",  sBManDate)
//	dw_junpoy.SetItem(iCurRow,"k_rate",  d_rate)
//	dw_junpoy.SetItem(iCurRow,"exp_gu",  sStatus) 
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",s_bu)
	END IF
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
	lLinNo = lLinNo + 1
END IF

/*���η�(����ä�ǸŰ��ս�) ó��*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		
	INTO :sAcc1_cha,  						  :sAcc2_cha	
	FROM "SYSCNFG"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			( "SYSCNFG"."LINENO" = '36' )  ;			
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[����ä�ǸŰ��ս�(A-1-36)]')
	RETURN -1
END IF

/*���η�(����ä�ǸŰ��ս�)�� �������������� */
d_rate        = dec(dw_ip.GetItemNumber(1,   "su")) 
s_hal_bank    = dw_ip.GetItemString(1, "hal_bank")
s_hal_bank_nm = dw_ip.GetItemString(1, "banknm")

FOR i = 1 TO dw_bill.RowCount()	
	IF dw_bill.GetItemString(i, "sun") = '1' THEN
		sBillNo    = dw_bill.GetItemString(i, "bill_no")
		sBManDate  = dw_bill.GetItemString(i, "bman_dat")
		sSaupNo    = dw_bill.GetItemString(i, "saup_no")
		dAmount    = dw_bill.GetItemNumber(i, "yul")
		dwonAmount = dw_bill.GetItemNumber(i, "bill_amt")
		Sstatus    = dw_bill.GetItemString(i, "status")
		SName      = dw_bill.GetItemString(i, "person_nm")
			
		sDcGbn     = '1'							/*���� ��ǥ*/
				
		/* ���η�(����ä�ǸŰ��ս�) or ���޺�� insert */
		SELECT "KFZ01OM0"."DC_GU",		"KFZ01OM0"."YESAN_GU",				"KFZ01OM0"."REMARK1"
			INTO :sChaDae,					:sYesanGbn,								:sRemark1
			FROM "KFZ01OM0"  
			WHERE ("KFZ01OM0"."ACC1_CD" = :sAcc1_cha) AND ("KFZ01OM0"."ACC2_CD" = :sAcc2_cha);
				
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
		dw_junpoy.SetItem(iCurRow,"dept_cd", s_bu)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   s_sawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
		dw_junpoy.SetItem(iCurRow,"descr",    '����ä�ǸŰ��ս�')		
		dw_junpoy.SetItem(iCurRow,"sdept_cd", dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd"))
	
		dw_junpoy.SetItem(iCurRow,"saup_no",  s_hal_bank) 
		dw_junpoy.SetItem(iCurRow,"in_nm",    dw_ip.GetItemString(1,"banknm")) 
		dw_junpoy.SetItem(iCurRow,"y_rate",   dw_ip.GetItemNumber(1,"su1"))
		dw_junpoy.SetItem(iCurRow,"k_rate",   dw_ip.GetItemNumber(1,"su"))
		dw_junpoy.SetItem(iCurRow,"exp_gu",   sStatus) 

		IF sPrcGbn = 'Y' THEN		
			dw_junpoy.SetItem(iCurRow,"k_amt",   dAmount)
						
			dw_junpoy.SetItem(iCurRow,"kwan_no",  sAcc1_DaeChe+sAcc2_DaeChe) 
			dw_junpoy.SetItem(iCurRow,"k_symd",   sbaldate)
			dw_junpoy.SetItem(iCurRow,"k_eymd",   Wf_Chk_ValidDate(sBManDate))
		ELSE
			dw_junpoy.SetItem(iCurRow,"k_amt",   dwonAmount)
			dw_junpoy.SetItem(iCurRow,"kwan_no",  sBillNo) 
			dw_junpoy.SetItem(iCurRow,"k_symd",   sbaldate)
			dw_junpoy.SetItem(iCurRow,"k_eymd",   sBManDate)
		END IF
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",s_bu)
		END IF
	
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		lLinNo = lLinNo + 1
	
		/*��������*/	
		sDcGbn = '2'											/*�뺯 ��ǥ*/
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
		dw_junpoy.SetItem(iCurRow,"dept_cd", s_bu)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   s_sawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
		sExp = '�������� ���� ' + '[' + s_hal_bank_nm + ']' 		
		
		dw_junpoy.SetItem(iCurRow,"amt",     dwonAmount)
		dw_junpoy.SetItem(iCurRow,"descr",   sExp)
				
		dw_junpoy.SetItem(iCurRow,"sdept_cd", dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd"))
	
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo) 
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_bill.GetItemString(i,"person_nm")) 
							
		IF Wf_Insert_Kfz12otd(i,sSaupj,sBalDate,lJunNo,lLinNo) = 1 THEN
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
			dw_junpoy.SetItem(iCurRow,"kwan_no", sBillNo) 
			dw_junpoy.SetItem(iCurRow,"k_eymd",  sBManDate) 
		ELSE
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 
			Return -1
		END IF
		
//		/*�������� data�� ����*/
//		dw_bill.SetItem(i, "kfm02ot0_status",      '4')
//		dw_bill.SetItem(i, "kfm02ot0_bill_ntinc",  s_hal_bank) 
//		dw_bill.SetItem(i, "kfm02ot0_mbal_date",   sbaldate)
//		dw_bill.SetItem(i, "kfm02ot0_mupmu_gu",    sUpmuGbn)
//		dw_bill.SetItem(i, "kfm02ot0_mjun_no",     lJunNo)
//		dw_bill.SetItem(i, "kfm02ot0_mlin_no",     lLinNo)
//		dw_bill.SetItem(i, "kfm02ot0_bill_change_date", sbaldate)
//		dw_bill.SetItem(i, "kfm02ot0_acc_date",    sbaldate)
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		
		lLinNo = lLinNo + 1
	END IF
NEXT
IF dw_rbill.Update() <> 1 THEN
	F_MessageChk(13,'[��������]')
	SetPointer(Arrow!)
	Return -1
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[�̽�����ǥ]')
	SetPointer(Arrow!)
	Return -1
END IF

MessageBox("Ȯ ��","�߻��� �̰���ǥ��ȣ :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))

w_mdi_frame.sle_msg.text ="�������� ������� ��ǥ ó�� �Ϸ�!!"

Return 1
end function

on w_kglb15.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_ip=create dw_ip
this.gb_2=create gb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_rbill=create dw_rbill
this.dw_bill=create dw_bill
this.gb_bill=create gb_bill
this.dw_ipgum=create dw_ipgum
this.gb_ipgum=create gb_ipgum
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_sungin
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.dw_rbill
this.Control[iCurrent+8]=this.dw_bill
this.Control[iCurrent+9]=this.gb_bill
this.Control[iCurrent+10]=this.dw_ipgum
this.Control[iCurrent+11]=this.gb_ipgum
this.Control[iCurrent+12]=this.dw_delete
end on

on w_kglb15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_ip)
destroy(this.gb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_rbill)
destroy(this.dw_bill)
destroy(this.gb_bill)
destroy(this.dw_ipgum)
destroy(this.gb_ipgum)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(), "saupj"   ,gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(), "bal_date",f_today())
dw_ip.SetItem(dw_ip.Getrow(), "dept_cd", Gs_Dept)
dw_ip.SetItem(dw_ip.Getrow(), "sawon",   Gs_EmpNo)
dw_ip.SetItem(dw_ip.Getrow(), "sun",    '1')

dw_bill.SetTransObject(SQLCA)
dw_ipgum.SetTransObject(SQLCA)
dw_delete.SetTransObject(SQLCA)
dw_rbill.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

gb_bill.Visible   = True
gb_ipgum.Visible  = True
dw_bill.Visible   = True
dw_ipgum.Visible  = True

dw_delete.Visible = False

p_addrow.Visible  = True
p_delrow.Visible  = True

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*�ڵ� ���� ���� üũ*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '08' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

SELECT "SYSCNFG"."DATANAME"      INTO :LsCheckLimitGbn  			/*��������� �����ѵ� ��� üũ*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 16 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsCheckLimitGbn = 'N'
ELSE
	IF IsNull(LsCheckLimitGbn) THEN LsCheckLimitGbn = 'N'
END IF

IF LsCheckLimitGbn = 'Y' THEN
	dw_ip.Modify("t_bank.visible = 1")
	dw_ip.Modify("t_rate.visible = 1")
ELSE
	dw_ip.Modify("t_bank.visible = 0")
	dw_ip.Modify("t_rate.visible = 0")	
END IF

//���α���(1:���������,2:�������&�ŷ�ó,3:�������&��������)
SELECT dataname INTO :LsHalGb
   FROM syscnfg
   WHERE sysgu = 'A' AND serial = 16 AND lineno = 2;

IF LsHalGb = "2" THEN
	dw_ip.object.t_incd.visible = True
	dw_ip.object.t_incd1.visible = True
	dw_ip.object.p_incd.visible = True
	dw_ip.object.incd.visible = True
	dw_ip.object.innm.visible = True
ELSE
	dw_ip.object.t_incd.visible = False
	dw_ip.object.t_incd1.visible = False
	dw_ip.object.p_incd.visible = False
	dw_ip.object.incd.visible = False
	dw_ip.object.innm.visible = False
END IF

dw_ip.SetColumn("saupj")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kglb15
boolean visible = false
integer x = 2021
integer y = 2732
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglb15
integer x = 4379
integer y = 2048
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;long l_row

l_row = dw_ipgum.GetRow()

IF l_row <= 0 THEN
	F_MessageChk(11,'')
	return
END IF

IF MessageBox("Ȯ��", "�Ա��׸��� " + string(l_row) + "��° ���� �����Ͻðڽ��ϱ�?", Question!, YesNo! ) = 1 THEN
	dw_ipgum.deleteRow(l_row)
ELSE
	return
END IF
           
end event

type p_addrow from w_inherite`p_addrow within w_kglb15
integer x = 4206
integer y = 2048
integer taborder = 50
end type

event p_addrow::clicked;String   sDepotCd
Integer  k, iCurRow
Double   dSendFee,dDepotAmt

//IF dw_ipgum.GetRow() <=0 THEN RETURN

dSendFee = dw_ip.GetItemNumber(1,"sendfee")
IF IsNull(dSendFee) THEN dSendFee = 0

IF dw_ipgum.RowCount() > 0 THEN
	FOR k = 1 TO dw_ipgum.RowCount()
		sDepotCd  = dw_ipgum.GetItemString(k,"e_code")
		dDepotAmt = dw_ipgum.GetItemNumber(k,"e_gum")
		
		IF sDepotCd = "" OR Isnull(sDepotCd) THEN
			f_messagechk(1, "�����ڵ�")
			dw_Ipgum.Setcolumn("e_code")
			dw_Ipgum.Setfocus()
			Return
		END IF
		IF dDepotAmt = 0 OR Isnull(dDepotAmt) THEN
			f_messagechk(1, "�Աݾ�")
			dw_Ipgum.Setcolumn("e_gum")
			dw_Ipgum.Setfocus()
			Return
		END IF
	NEXT
END IF

iCurRow = dw_ipgum.InsertRow(0)
dw_ipgum.ScrollToRow(iCurRow)

IF iCurRow = 1 THEN
	dw_ipgum.SetItem(iCurRow,"e_gum",dw_bill.GetItemNumber(dw_bill.RowCount(),"s_ipgum") - dSendFee)
ELSE
	dw_ipgum.SetItem(iCurRow,"e_gum",0)	
END IF

dw_ipgum.SetColumn("e_code")
dw_ipgum.Setfocus()

end event

type p_search from w_inherite`p_search within w_kglb15
boolean visible = false
integer x = 2446
integer y = 2772
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglb15
boolean visible = false
integer x = 2967
integer y = 2772
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglb15
integer x = 4466
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kglb15
integer x = 4293
integer taborder = 80
end type

event p_can::clicked;call super::clicked;
dw_bill.Reset()
dw_delete.Reset()
dw_ipgum.Reset()

dw_ip.SetItem(1, "sun", '1')

gb_bill.Visible   = True
gb_ipgum.Visible  = True
dw_bill.Visible   = True
dw_ipgum.Visible  = True

dw_delete.Visible = False

p_addrow.Visible  = True
p_delrow.Visible  = True

dw_ip.SetColumn("saupj")
dw_ip.Setfocus()
end event

type p_print from w_inherite`p_print within w_kglb15
boolean visible = false
integer x = 2619
integer y = 2772
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long   lBJunNo,iRtnVal,lJunNo

IF MessageBox("Ȯ ��", "����Ͻðڽ��ϱ� ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

sSaupj   = dw_junpoy.GetItemString(1,"saupj")
sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
sUpmuGu  = dw_junpoy.GetItemString(1,"upmu_gu") 
lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 

select distinct jun_no into :lJunNo	from kfz10ot0 
	where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu and bjun_no = :lBJunNo;
if sqlca.sqlcode = 0 then
	iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,sPrtGbn,'P')
else
	iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
end if
		
IF iRtnVal = -1 THEN
	F_MessageChk(14,'')
	Return -1
ELSEIF iRtnVal = -2 THEN
	Return 1
ELSE	
	sPrtGbn = '1'
END IF
end event

type p_inq from w_inherite`p_inq within w_kglb15
integer x = 3945
integer taborder = 20
end type

event p_inq::clicked;String sSelected,sSaupj,sDateF,sDateT,sAccCode,sInCd

IF dw_ip.AcceptText() = -1 THEN RETURN

sSelected  = dw_ip.GetItemString(dw_ip.GetRow(), "sun")
sSaupj     = dw_ip.GetItemString(dw_ip.GetRow(), "saupj")
sDateF     = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "fdate"))
sDateT     = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "tdate"))
sInCd      = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "incd"))

IF sSaupj = '' or IsNull(sSaupj) THEN
	F_MessageChk(1,'[�����]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return
END IF

IF sDateF = "" OR IsNull(sDateF) THEN sDateF = '00000000'
IF sDateT = "" OR IsNull(sDateT) THEN sDateT = '99999999'

IF LsHalGb = "1" THEN
	sInCd = "%"
ELSEIF LsHalGb = "2" THEN
	IF sInCd = '' or IsNull(sInCd) THEN
		F_MessageChk(1,'[�ŷ�ó]')
		dw_ip.SetColumn("incd")
		dw_ip.SetFocus()
		Return
	END IF
ELSEIF LsHalGb = "3" THEN
	sInCd = "%"
END IF

IF sSelected = '1' THEN 					/*��ǥ ����*/
	IF dw_bill.Retrieve(sSaupj,sDateF,sDateT,sInCd) > 0 THEN
		p_addrow.Enabled = True
		dw_bill.Setfocus()
		
		dw_ipgum.Reset()
	ELSE
		F_MessageChk(14,'')
		p_addrow.Enabled = False
	END IF
ELSE												/*��ǥ ����*/	
	select substr(dataname,1,7) into :sAccCode	from syscnfg where sysgu = 'A' and serial = 1 and lineno = 36;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(56,'[���η�(A-1-26)]')
		dw_ip.SetColumn("fdate")
		dw_ip.SetFocus()
		return -1
	end if
	
	IF dw_delete.Retrieve(sSaupj, sDateF,sDateT,sAccCode) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	ELSE
		dw_delete.Setfocus()
	END IF
END IF
dw_ipgum.Reset()
end event

type p_del from w_inherite`p_del within w_kglb15
boolean visible = false
integer x = 3662
integer y = 2772
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglb15
integer x = 4119
integer taborder = 70
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

event p_mod::clicked;String    sSaupj, sBalDate, sDeptCd, sSawon, sDisCountBank, sSdeptCode, sInCd
Dec       dSelectedBill, dSelectedRate, dIpGumAmt, dChai, dDisCountRate, dSendFee,dLimitAmt

dw_ip.AcceptText()
dw_ipgum.AcceptText()

IF dw_ip.GetItemString(1, "sun") = '1' THEN				/*��ǥ ����*/
	IF dw_bill.RowCount() <= 0 THEN Return
 
 	if dw_bill.GetItemNumber(1,"yescount") = 0 or IsNull(dw_bill.GetItemNumber(1,"yescount")) then
	   F_MessageChk(11,'')
		dw_bill.SetColumn("sun")
		dw_bill.SetFocus()
	   Return
   END IF

   IF dw_ipgum.RowCount() <= 0 THEN
   	F_MessageChk(1,'[�Աݳ���]')
		p_addrow.SetFocus()
	   Return
   END IF
	
   sSaupj    = dw_ip.GetItemString(1, "saupj")
	sInCd     = Trim(dw_ip.GetItemString(1, "incd"))
   sBalDate  = Trim(dw_ip.GetItemString(1, "bal_date"))
   sDeptCd   = dw_ip.GetItemString(1, "dept_cd")
   sSawon    = dw_ip.GetItemString(1, "sawon")
   dSendFee  = dw_ip.GetItemNumber(1, "sendfee")
	sSdeptCode = dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd")
	
	IF IsNull(dSendFee) THEN dSendFee = 0
	
	IF sSaupj = "" OR Isnull(sSaupj) THEN
	   f_messagechk(1, "�����")
	   dw_Ip.Setcolumn("saupj")
      dw_Ip.Setfocus()
		Return
	END IF
	
	IF LsHalGb = "2" THEN
		IF sInCd = '' or IsNull(sInCd) THEN
			F_MessageChk(1,'[�ŷ�ó]')
			dw_ip.SetColumn("incd")
			dw_ip.SetFocus()
			Return
		END IF
	END IF
		
	IF sBalDate = "" OR Isnull(sBalDate) THEN
		f_messagechk(1, "�ۼ�����")
	   dw_Ip.Setcolumn("bal_date")
      dw_Ip.Setfocus()
		Return
	END IF
		
	IF sDeptCd = "" OR Isnull(sDeptCd) THEN
		f_messagechk(1, "�ۼ��μ�")
	   dw_Ip.Setcolumn("dept_cd")
      dw_Ip.Setfocus()
		Return
	END IF
		
	IF sSawon = "" OR Isnull(sSawon) THEN	
		f_messagechk(1, "�ۼ���")
	   dw_Ip.Setcolumn("sawon")
      dw_Ip.Setfocus()
		Return
   END IF

	/*ó���� �ڷ��� �ݾ� Ȯ��*/
	dSelectedBill = dw_bill.GetItemNumber(dw_bill.GetRow(),    "s_total_hap")
	dSelectedRate = dw_bill.GetItemNumber(dw_bill.GetRow(),    "s_hap_2")
	dIpGumAmt     = dw_ipgum.GetItemNumber(dw_ipgum.GetRow(),  "e_ge")
	
	IF LsCheckLimitGbn = 'Y' THEN
	   sDisCountBank = dw_ip.GetItemString(1, "hal_bank") 
	   dDisCountRate = Dec(dw_ip.GetItemNumber(1, "su"))
		dLimitAmt     = dw_ip.GetItemNumber(1, "jango")
		IF IsNull(dLimitAmt) then dLimitAmt = 0
		
		IF sDisCountBank = "" OR Isnull(sDisCountBank) THEN	
			f_messagechk(1, "��������")
			dw_Ip.Setcolumn("hal_bank")
			dw_Ip.Setfocus()
			Return
		END IF
	
		IF dDisCountRate = 0 OR dDisCountRate = 0.0 OR dDisCountRate = 0.00 OR Isnull(dDisCountRate) THEN	
			f_messagechk(1, "������")
			dw_Ip.Setcolumn("su")
			dw_Ip.Setfocus()
			Return
		END IF
		
		if dSelectedBill > dLimitAmt then
			F_MessageChk(16,'[�����ѵ��ܾ� < ���αݾ�]')
			dw_Ip.Setcolumn("su")
			dw_Ip.Setfocus()
			Return
		end if
	END IF
	
	dChai = dSelectedBill - dSelectedRate - dSendFee
	
	IF dIpGumAmt <> dChai THEN
		F_MessageChk(47,'[�Ա��Ѿ� <> ó���Ҿ����� - ó���Ҿ��� ���ξ� - ���޼�����]')
		return
	END IF
	
	IF Wf_Insert_Kfz12ot0(sSaupj, sBalDate, sDeptCd, sSawon,dSendFee) = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
	
   /*�ڵ� ���� ó��*/
	IF LsAutoSungGbn = 'Y' THEN
		w_mdi_frame.sle_msg.text = '���� ó�� ��...'
		IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
			SetPointer(Arrow!)
			Return -1
		END IF	
	END IF
	
	p_print.TriggerEvent(Clicked!)
ELSE	
	if dw_delete.RowCount() <=0 then Return
	
	if dw_delete.GetItemNumber(1,"yescount") = 0 or IsNull(dw_delete.GetItemNumber(1,"yescount")) then
	   F_MessageChk(11,'')
		dw_delete.SetColumn("sun")
		dw_delete.SetFocus()
	   Return
   END IF
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF	
END IF

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_kglb15
boolean visible = false
integer x = 2094
integer y = 2788
end type

type cb_mod from w_inherite`cb_mod within w_kglb15
boolean visible = false
integer x = 1403
integer y = 2788
string text = "ó��(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglb15
boolean visible = false
integer x = 2729
integer y = 2572
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglb15
boolean visible = false
integer x = 1024
integer y = 2788
integer width = 366
string text = "�����(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_kglb15
boolean visible = false
integer x = 283
integer y = 2784
end type

type cb_print from w_inherite`cb_print within w_kglb15
boolean visible = false
integer x = 3200
integer y = 2496
end type

type st_1 from w_inherite`st_1 within w_kglb15
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglb15
boolean visible = false
integer x = 1751
integer y = 2788
end type

type cb_search from w_inherite`cb_search within w_kglb15
boolean visible = false
integer x = 626
integer y = 2788
integer width = 379
string text = "���߰�(&A)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kglb15
boolean visible = false
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_kglb15
boolean visible = false
integer width = 2482
end type

type gb_10 from w_inherite`gb_10 within w_kglb15
boolean visible = false
integer width = 3616
end type

type gb_button1 from w_inherite`gb_button1 within w_kglb15
boolean visible = false
integer x = 3191
integer y = 2696
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kglb15
boolean visible = false
integer x = 1358
integer y = 2732
integer width = 1106
end type

type rr_1 from roundrectangle within w_kglb15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 652
integer width = 4553
integer height = 1572
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_kglb15
event ue_key pbm_dwnkey
integer x = 5
integer y = 8
integer width = 3927
integer height = 624
integer taborder = 10
string dataobject = "dw_kglb151"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sNull,ssql,sSaupj,sDate,sBnkNo,sCust, sCustName, sBalDate, s_sun, sInCd, sInNm
Integer i
Decimal dLimitRemain

SetNull(sNull)

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return

	IF IsNull(F_Get_Refferance('AD', sSaupj)) then
  	  	f_messagechk(20,"[�����]")
		This.SetItem(row,"saupj",sNull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="fdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��������")
		This.SetItem(row,"fdate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="tdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��������")
		This.SetItem(row,"tdate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="incd" THEN
	sInCd = this.GetText()
	IF sInCd = '' OR IsNull(sInCd) THEN
		this.SetItem(row,"innm",sNull)
		Return
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sInNm
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sInCd) AND 
				(( "KFZ04OM0"."PERSON_GU" like '%') OR 
				( "KFZ04OM0"."PERSON_GU" = '99')) AND
				( "KFZ04OM0"."PERSON_STS" like '%');

	IF SQLCA.SQLCODE = 0 THEN
		This.SetItem(row,"innm",sInNm)
	ELSE
		f_Messagechk(20,"[�ŷ�ó]") 
		This.SetItem(row,"incd",sNull)
		This.SetItem(row,"innm",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bal_date" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"�ۼ�����")
		This.SetItem(row,"bal_date",sNull)
		Return 1
	END IF
	IF F_Check_LimitDate(sDate,'B') = -1 THEN
		F_MessageChk(29,'[�ۼ�����]')
		this.SetItem(row,"bal_date",sNull)
		this.SetColumn("bal_date")
		Return 1
	END IF
END IF

IF this.GetColumnName() = "hal_bank" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(row,"banknm",sNull)
		this.SetItem(row,"jango",sNull)
		Return
	END IF

	select person_nm	into :sCustName	from kfz04om0_v2 where person_cd = :sCust;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[��������]')
		this.SetItem(row,"hal_bank",sNull)
		this.SetItem(row,"banknm",sNull)
		This.SetColumn("hal_bank")
		This.Setfocus()
		Return 1
	ELSE	
		this.SetItem(row,"banknm",sCustName)
	END IF

	sBalDate    = This.GetItemString(1, "bal_date")
	IF sBalDate = "" or IsNull(sBalDate) THEN
		F_MessageChk(1,'[�ۼ�����]')
      This.SetColumn("bal_date")
		This.Setfocus()
		return 1
	END IF

	IF LsCheckLimitGbn = 'Y' THEN								/*��������� �����ѵ� ���*/
	
		IF LsHalGb = "1" THEN
			dLimitRemain = F_credit_check(scust,"00000000000000000000",sBalDate)	//���������
		ELSEIF LsHalGb = "2" THEN
			dLimitRemain = F_credit_check(scust,This.getitemstring(row,"incd"),sBalDate)	//�������&�ŷ�ó
		ELSEIF LsHalGb = "3" THEN
			dLimitRemain = F_credit_check(scust,"1",sBalDate)	//�������&��������
		END IF
		
		IF dLimitRemain = -1 THEN
			f_messagechk(16, "[�����ѵ�üũ]")
			This.SetItem(row,"hal_bank",sNull)
			This.SetItem(row,"banknm",sNull)
			Return 1
		ELSE
			This.Setitem(row,"jango",dLimitRemain)
		END IF
	ELSE
		This.Setitem(row,"jango",0)
	END IF
END IF

IF this.GetColumnName() ="sun" THEN
	s_sun = this.GetText()
	
   IF s_sun = '1' THEN
		gb_bill.Visible   = True
		gb_ipgum.Visible  = True
		dw_bill.Visible   = True
		dw_ipgum.Visible  = True
		
		dw_delete.Visible = False
		p_addrow.Visible  = True
		p_delrow.Visible  = True
	ELSE
		dw_bill.Visible   = False
		gb_bill.Visible   = False
		dw_ipgum.Visible  = False
		gb_ipgum.Visible  = False
		
		dw_delete.Visible = True
		p_addrow.Visible  = False
		p_delrow.Visible  = False
	END IF
END IF
end event

event rbuttondown;Double  dLimitRemain
String  sBalDate, snull

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)
SetNull(snull)

IF this.GetColumnName() ="incd" THEN
	
	lstr_custom.code = This.GetItemString(row,"incd")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP, "%")
	
	IF IsNull(lstr_custom) THEN
		This.SetItem(row, "incd",snull)
		This.SetItem(row, "innm",snull)
	ELSE	
		This.SetItem(row, "incd",lstr_custom.code)
		This.SetItem(row, "innm",lstr_custom.name)
	END IF
	
END IF

IF this.GetColumnName() ="hal_bank" THEN

   sBalDate = This.GetItemString(1, "bal_date")
   IF sBalDate = "" or Isnull(sBalDate) THEN
	   F_MessageChk(1,'[�ۼ�����]')
      This.SetColumn("bal_date")
      This.Setfocus()
	   return 1
   END IF
	
	OpenWithParm(W_Kfm08ot0_POPUP,'2')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	This.SetItem(row,"hal_bank",lstr_custom.code)
	This.SetItem(row,"banknm",  lstr_custom.name)
	
	IF LsCheckLimitGbn = 'Y' THEN
		
		IF LsHalGb = "1" THEN
			dLimitRemain = F_credit_check(lstr_custom.code,"00000000000000000000",sBalDate)	//���������
		ELSEIF LsHalGb = "2" THEN
			dLimitRemain = F_credit_check(lstr_custom.code,This.getitemstring(row,"incd"),sBalDate)	//�������&�ŷ�ó
		ELSEIF LsHalGb = "3" THEN
			dLimitRemain = F_credit_check(lstr_custom.code,"1",sBalDate)	//�������&��������
		END IF
		
		IF dLimitRemain = -1 THEN
			f_messagechk(16, "[�����ѵ�üũ]")
			This.SetItem(row,"hal_bank",snull)
			This.SetItem(row,"banknm",snull)
			Return 1
		ELSE
			This.Setitem(row,"jango",dLimitRemain)
			This.Setcolumn("su")
			This.Setfocus()
		END IF
	ELSE
		This.Setitem(row,"jango",0)
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

type gb_2 from groupbox within w_kglb15
boolean visible = false
integer x = 18
integer y = 2732
integer width = 837
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_junpoy from datawindow within w_kglb15
boolean visible = false
integer x = 1088
integer y = 2488
integer width = 1006
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ����"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_sungin from datawindow within w_kglb15
boolean visible = false
integer x = 1088
integer y = 2600
integer width = 1006
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "������ǥ ���κ� ����"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_print from datawindow within w_kglb15
boolean visible = false
integer x = 64
integer y = 2532
integer width = 1006
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ�μ�"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_rbill from datawindow within w_kglb15
boolean visible = false
integer x = 64
integer y = 2636
integer width = 1006
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "�������� ���γ��� ����"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_bill from datawindow within w_kglb15
event ue_enter pbm_dwnprocessenter
integer x = 55
integer y = 720
integer width = 3054
integer height = 1468
integer taborder = 30
string title = "��������"
string dataobject = "dw_kglb152"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;//Send(Handle(this),256,9,0)
//Return 1
end event

event clicked;//IF Row <=0 THEN Return
//
//SelectRow(0,False)
//SelectRow(Row,True)	
//
	
end event

event itemchanged;String   sSelected, sBalDate, sManDate,s_null
Double   dDiscountAmt, dCurrBillAmt, dDiscountDay, dDisCountRate

SetNull(s_null)

dw_ip.AcceptText()

IF this.GetColumnName() = "sun" THEN
	sSelected = this.GetText()
	
	IF sSelected = '2' THEN				
		This.Setitem(this.GetRow(), "yul",     0)
		This.SetItem(this.GetRow(), "s_hap_1", 0)
	ELSE																	/*���� �� ���η� ���*/
		sBalDate    = Trim(dw_ip.GetItemString(1, "bal_date"))
	   IF sBalDate = "" or Isnull(sBalDate) THEN
		   F_MessageChk(1,'[�ۼ�����]')
         dw_ip.SetColumn("bal_date")
		   dw_ip.Setfocus()
		   return 1
		ELSE
			sBalDate = Left(sBalDate, 4) + '/' + Mid(sBalDate, 5, 2) + '/' + Right(sBalDate, 2)		
		END IF
		sManDate = Trim(dw_bill.GetItemString(this.GetRow(),  "bman_dat"))		/*������*/
		Wf_Chk_ValidDate(sManDate)
		sManDate   = Left(sManDate, 4) + '/' + Mid(sManDate, 5, 2) + '/' + Right(sManDate, 2)
		
		IF Date(sManDate) < Date(sBalDate) THEN
			F_MessageChk(16,'[�������� < �ۼ�����]')
			this.SetColumn("sun")
			this.SetFocus()
			return 1
		END IF
		
		dCurrBillAmt = dw_bill.GetItemNumber(this.GetRow(), "bill_amt")			/*�����ݾ� */
		
		IF LsCheckLimitGbn = 'Y' THEN
			dDisCountRate = Dec(dw_ip.GetItemNumber(1, "su"))							/*���η��� �ޱ�*/
			IF dDisCountRate = 0 OR IsNull(dDisCountRate) THEN
				f_messagechk(1, "������")
				dw_ip.SetColumn("su")
				dw_ip.Setfocus()
				Return 1
			END IF
		ELSE
			dDisCountRate = 0;
		END IF
		
		dDiscountDay = Dec(DaysAfter(Date(sBalDate),  Date(sManDate)) / 365)
		/*���η�  = �����ݾ� * (������ - ȸ����)/365 * ���μ������� * 0.01 (���̸� ����)*/
		dDiscountAmt = Truncate((dCurrBillAmt * dDiscountDay * dDisCountRate * 0.01), 0) 	

		This.SetItem(this.GetRow(), "yul", dDiscountAmt)
	END IF	
END IF
		
		
end event

event rowfocuschanged;//IF currentrow <=0 THEN Return
//
//SelectRow(0,False)
//SelectRow(currentrow,True)	
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type gb_bill from groupbox within w_kglb15
integer x = 37
integer y = 668
integer width = 3090
integer height = 1536
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "��������"
borderstyle borderstyle = stylelowered!
end type

type dw_ipgum from datawindow within w_kglb15
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 3154
integer y = 720
integer width = 1371
integer height = 1308
integer taborder = 40
string title = "�Ա��׸�"
string dataobject = "dw_kglb154"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;IF Row <=0 THEN Return
	
SelectRow(0,False)
SelectRow(Row,True)	

	
end event

event getfocus;this.AcceptText()
end event

event itemchanged;string scust, snull, sCustName

This.AcceptText()
Setnull(snull)

IF this.GetColumnName() = "e_code" THEN
	sCust = data
	
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(row, "e_nm",   snull)
		this.SetItem(row, "e_gum",  snull)
		this.SetItem(row, "e_ss",   snull)
		Return
	END IF
	

	/*�����ݸ� �������� 1:1*/
	SELECT "KFZ04OM0_V5"."PERSON_NM"
	  INTO :sCustName
    FROM  "KFZ04OM0_V5"
	 WHERE "KFZ04OM0_V5"."PERSON_CD" = :sCust ;

	
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[�����ڵ�]')
		this.SetItem(row, "e_code", snull)
		this.SetItem(row, "e_nm",   snull)
		this.SetItem(row, "e_gum",  snull)
		this.SetItem(row, "e_ss",   snull)
		This.SetColumn("e_code")
		This.Setfocus()
		Return 1		
	ELSE	
		this.SetItem(row, "e_nm",      sCustName)
	END IF
	
END IF		
end event

event itemerror;Return 1
end event

event rbuttondown;integer i_return_val
String  s_il, snull

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)
SetNull(snull)


//������ �ڵ�

IF this.GetColumnName() ="e_code" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ipgum.SetItem(row,  "e_code",lstr_custom.code)
	dw_ipgum.SetItem(row,  "e_nm",  lstr_custom.name)
	

	dw_ipgum.Setcolumn("e_gum")
	dw_ipgum.Setfocus()
	
END IF

end event

type gb_ipgum from groupbox within w_kglb15
integer x = 3136
integer y = 668
integer width = 1413
integer height = 1376
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�Աݳ���"
borderstyle borderstyle = stylelowered!
end type

type dw_delete from datawindow within w_kglb15
boolean visible = false
integer x = 55
integer y = 720
integer width = 4443
integer height = 1468
integer taborder = 100
string title = "��ǥ����"
string dataobject = "dw_kglb153"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

