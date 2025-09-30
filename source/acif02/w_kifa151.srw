$PBExportHeader$w_kifa151.srw
$PBExportComments$�ڵ���ǥ ���� : NEGO(���Ͼ��� ��)
forward
global type w_kifa151 from w_inherite
end type
type gb_1 from groupbox within w_kifa151
end type
type rb_1 from radiobutton within w_kifa151
end type
type rb_2 from radiobutton within w_kifa151
end type
type dw_junpoy from datawindow within w_kifa151
end type
type dw_sungin from datawindow within w_kifa151
end type
type dw_print from datawindow within w_kifa151
end type
type dw_group_detail from datawindow within w_kifa151
end type
type dw_sang from datawindow within w_kifa151
end type
type dw_detail from datawindow within w_kifa151
end type
type dw_ip from u_key_enter within w_kifa151
end type
type dw_ipgum from datawindow within w_kifa151
end type
type dw_bill from datawindow within w_kifa151
end type
type dw_rbill from datawindow within w_kifa151
end type
type dw_samebill_ngno from datawindow within w_kifa151
end type
type dw_cha_banje from datawindow within w_kifa151
end type
type rr_1 from roundrectangle within w_kifa151
end type
type dw_rtv from datawindow within w_kifa151
end type
type dw_delete from datawindow within w_kifa151
end type
type cbx_all from checkbox within w_kifa151
end type
end forward

global type w_kifa151 from w_inherite
string title = "NEGO��ǥ ó��(���Ͼ���)"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_group_detail dw_group_detail
dw_sang dw_sang
dw_detail dw_detail
dw_ip dw_ip
dw_ipgum dw_ipgum
dw_bill dw_bill
dw_rbill dw_rbill
dw_samebill_ngno dw_samebill_ngno
dw_cha_banje dw_cha_banje
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
cbx_all cbx_all
end type
global w_kifa151 w_kifa151

type variables

String     sUpmuGbn = 'N',LsAutoSungGbn

Double  dTotalMaichul,dTotalIpGum,dTotalBiyong,dTotalSunSu,dTotalSang,dTotalBill

end variables

forward prototypes
public function integer wf_insert_sang (integer irow, string sngno, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long lbjunno, integer llinno)
public function integer wf_insert_sang_cha (integer irow, string sngno, string sacc, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public subroutine wf_calculation_chaik_samebill (string sflag, integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik)
public function integer wf_delete_kfz12ot0 ()
public function double wf_get_rate (string sbasedate, string scurr)
public function integer wf_insert_chaik_samebill (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik)
public function integer wf_insert_dae (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik)
public function integer wf_insert_dae_samebill (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno)
public function integer wf_insert_kfz12ot0 (string ssaupj)
public subroutine wf_calculation_chaik (integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik)
public function integer wf_process_samebill (string ssaupj)
end prototypes

public function integer wf_insert_sang (integer irow, string sngno, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iInsertRow,iLinNoS
Double  dAmount,dAmountY
String  sCiNo,sAcc1,sAcc2,sDcGbn,sSaupjS,sAccDateS,sUpmuS,sBalDateS,sCrossNo
Long    lJunNoS,lBJunNoS

//dw_sang.Reset()

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),"KFZ01OM0"."DC_GU"
	INTO :sAcc1,								 :sAcc2,									 :sDcGbn
	FROM "SYSCNFG", "KFZ01OM0"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			( "SYSCNFG"."LINENO" = '25' ) AND
			(SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD") AND
			(SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD") ;
			
//sCiNo   = dw_detail.GetItemString(iRow,"cino")

DECLARE Cursor_BanJe CURSOR FOR  
	SELECT distinct "KIF08OT3"."CROSSNO",     NVL("KIF08OT3"."AMOUNT",0),      NVL("KIF08OT3"."AMOUNTY",0)  
		FROM "KIF08OT1",   "KIF08OT3"  
   	WHERE ( "KIF08OT1"."SABU" = "KIF08OT3"."SABU" ) and  
      	   ( "KIF08OT1"."NGNO" = "KIF08OT3"."NGNO" ) and 
         	( ( "KIF08OT1"."SABU" = '1' ) AND  ( "KIF08OT1"."NGNO" = :sNgNo ) AND  
//         	( "KIF08OT1"."CINO" = :sCiNo ) AND 
				( "KIF08OT3"."ACCODE" = :sAcc1||:sAcc2 ) AND ( "KIF08OT3"."SAUPNO" = :sSaupNo ) )   ;
				
Open Cursor_BanJe;
Do While True
	Fetch Cursor_BanJe INTO :sCrossNo,		:dAmount,					:dAmountY;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	sSaupjS   = Left(sCrossNo,2)
	sAccDateS = Mid(sCrossNo,3,8)
	sUpmuS    = Mid(sCrossNo,11,1)
	lJunNoS   = Long(Mid(sCrossNo,12,4))
	iLinNoS   = Integer(Mid(sCrossNo,16,3)) 
	sBalDateS = Mid(sCrossNo,19,8)
	lBJunNoS  = Long(Mid(sCrossNo,27,4)) 
	
	iInsertRow = dw_sang.InsertRow(0)
	
	dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
	dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
	dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuS)
	dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
	dw_sang.SetItem(iInsertRow,"lin_no",   iLinNoS)
	dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
	dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
		
	dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
	dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
	dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
	dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
	dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
	dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)
	dw_sang.SetItem(iInsertRow,"y_amt_s",  dAmountY)
Loop
Close Cursor_BanJe;

Return 1


end function

public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long lbjunno, integer llinno);String   sFullJunNo
Integer  iBilCnt

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+String(lBJunNo,'0000')+String(lLinNo,'000')

iBilCnt = dw_rbill.InsertRow(0)
dw_rbill.SetItem(iBilCnt,"bill_no",  	 dw_bill.GetItemString(iRow,"bill_no"))
dw_rbill.SetItem(iBilCnt,"saup_no",  	 dw_bill.GetItemString(iRow,"salecod")) 
dw_rbill.SetItem(iBilCnt,"bbal_dat", 	 dw_bill.GetItemString(iRow,"bbal_dat"))
dw_rbill.SetItem(iBilCnt,"bman_dat", 	 dw_bill.GetItemString(iRow,"bman_dat"))
dw_rbill.SetItem(iBilCnt,"bnk_cd",   	 dw_bill.GetItemString(iRow,"bill_bank"))
dw_rbill.SetItem(iBilCnt,"bill_gu",  	 dw_bill.GetItemString(iRow,"bill_gu"))
dw_rbill.SetItem(iBilCnt,"bill_jigu",	 dw_bill.GetItemString(iRow,"bill_jigu"))
dw_rbill.SetItem(iBilCnt,"bill_nm",  	 dw_bill.GetItemString(iRow,"bill_nm"))
dw_rbill.SetItem(iBilCnt,"status",  	 '1')
dw_rbill.SetItem(iBilCnt,"temp_bill_yn",dw_bill.GetItemString(iRow,"temp_bill_yn"))
dw_rbill.SetItem(iBilCnt,"bill_amt", 	 dw_bill.GetItemNumber(iRow,"bill_amt"))

dw_rbill.SetItem(iBilCnt,"remark1", 	 '�������� ����')
dw_rbill.SetItem(iBilCnt,"owner_saupj", sSaupj)
dw_rbill.SetItem(iBilCnt,"full_junno",  sFullJunNo)				

dw_rbill.SetItem(iBilCnt,"saupj",   	 sSaupj)
dw_rbill.SetItem(iBilCnt,"bal_date",	 sBalDate)
dw_rbill.SetItem(iBilCnt,"upmu_gu", 	 sUpmuGbn)
dw_rbill.SetItem(iBilCnt,"bjun_no", 	 lBJunNo)
dw_rbill.SetItem(iBilCnt,"lin_no",  	 lLinNo)
	
Return 1

end function

public function integer wf_insert_sang_cha (integer irow, string sngno, string sacc, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iInsertRow,iLinNoS
Double  dAmount,dAmountY
String  sCiNo,sSaupjS,sAccDateS,sUpmuS,sBalDateS,sCrossNo
Long    lJunNoS,lBJunNoS

//sCiNo   = dw_detail.GetItemString(iRow,"cino")

DECLARE Cursor_BanJe CURSOR FOR  
	SELECT distinct "KIF08OT5"."CROSSNO",     NVL("KIF08OT5"."AMOUNT",0),      NVL("KIF08OT5"."AMOUNTY",0)  
		FROM "KIF08OT1", "KIF08OT5"  
   	WHERE ( "KIF08OT1"."SABU" = "KIF08OT5"."SABU" ) and  
      	   ( "KIF08OT1"."NGNO" = "KIF08OT5"."NGNO" ) and 
				( "KIF08OT5"."SABU" = '1' ) AND  ( "KIF08OT5"."NGNO" = :sNgNo ) AND 
//				( "KIF08OT1"."CINO" = :sCiNo ) AND
         	( "KIF08OT5"."ACCODE" = :sAcc ) AND ( "KIF08OT5"."SAUPNO" = :sSaupNo ) ;
				
Open Cursor_BanJe;
Do While True
	Fetch Cursor_BanJe INTO :sCrossNo,		:dAmount,					:dAmountY;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	sSaupjS   = Left(sCrossNo,2)
	sAccDateS = Mid(sCrossNo,3,8)
	sUpmuS    = Mid(sCrossNo,11,1)
	lJunNoS   = Long(Mid(sCrossNo,12,4))
	iLinNoS   = Integer(Mid(sCrossNo,16,3)) 
	sBalDateS = Mid(sCrossNo,19,8)
	lBJunNoS  = Long(Mid(sCrossNo,27,4)) 
	
	iInsertRow = dw_sang.InsertRow(0)
	
	dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
	dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
	dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuS)
	dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
	dw_sang.SetItem(iInsertRow,"lin_no",   iLinNoS)
	dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
	dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
		
	dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
	dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
	dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
	dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
	dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
	dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)
	dw_sang.SetItem(iInsertRow,"y_amt_s",  dAmountY)
Loop
Close Cursor_BanJe;

Return 1


end function

public subroutine wf_calculation_chaik_samebill (string sflag, integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik);/************************************************************************/
/**           					��ȯ����/�� ����  	            			  **/
/*  A = SUM((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) **/
/*  IF A > 0 THEN ��ȯ���� RETURN '1'											  **/
/*  ELSEIF A < 0 THEN ��ȯ���� RETURN '0'										  **/
/*  ELSE                       RETURN '-1' 									  **/
/************************************************************************/
Double  dCiwRate,dUamt,dRate2,dIpGum,dBiYong,dMaiChul,dSunSuAmt,dSangAmt,dBillAmt
Integer iCount,k

iCount = dw_detail.Retrieve(sNgno,iweight,dw_samebill_ngno.GetItemString(icurrow,"icurr"),'')
IF iCount <=0 THEN 
	dMaiChul = 0
ELSE
	dMaiChul = dw_detail.GetItemNumber(1,"maichul")
	IF IsNull(dMaiChul) THEN dMaiChul = 0
END IF

IF dw_Ipgum.RowCount() <=0 THEN
	dIpGum = 0
ELSE
	dIpGum = dw_ipgum.GetItemNumber(1,"total_ipgum")	
	IF IsNull(dIpGum) THEN dIpGum = 0
END IF

IF dw_group_detail.RowCount() <=0 THEN
	dBiYong = 0
ELSE
	dBiYong = dw_group_detail.GetItemNumber(1,"sumconsamt")	
	IF IsNull(dBiYong) THEN dBiYong = 0
END IF

dSunSuAmt = dw_samebill_ngno.GetItemNumber(icurrow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

if dw_cha_banje.RowCount() <=0 then
	dSangAmt = 0
else
	dSangAmt  = dw_cha_banje.GetItemNumber(1,"sum_sangamt")
	IF IsNull(dSangAmt) THEN dSangAmt = 0
end if

if dw_bill.RowCount() <=0 then
	dBillAmt = 0
else
	dBillAmt  = dw_bill.GetItemNumber(1,"sum_billamt")
	IF IsNull(dBillAmt) THEN dBillAmt = 0
end if

dTotalMaiChul = dTotalMaiChul + dMaiChul
dTotalBiYong  = dTotalBiYong  + dBiYong
dTotalSunSu   = dTotalSunSu   + dSunSuAmt
dTotalSang    = dTotalSang    + dSangAmt
dTotalBill    = dTotalBill    + dBillAmt

if sFlag = 'L' then
	IF dTotalMaiChul + dTotalSunSu > dTotalIpGum + dTotalBiYong + dTotalSang + dTotalBill THEN							/*�ܻ���� > �Ա� + ��� + ���ݾ�=��ȯ����*/
		dChaSon = dChaSon + ((dTotalMaiChul + dTotalSunSu) - (dTotalIpGum + dTotalBiYong + dTotalSang + dTotalBill))
	ELSEIF dTotalMaiChul + dTotalSunSu < dTotalIpGum + dTotalBiYong + dTotalSang + dTotalBill THEN							/*�ܻ���� < �Ա� + ���=��ȯ����*/
		dChaIk  = dChaIk + ((dTotalIpGum + dTotalBiYong + dTotalSang + dTotalBill) - (dTotalMaiChul + dTotalSunSu))
	END IF
else
	dChaSon = 0
	dChaIk = 0
end if
end subroutine

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
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
		
		/*nego�ڷ� ��ǥ ���� ���*/
		UPDATE "KIF08OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null
		WHERE ( "KIF08OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF08OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF08OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF08OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[NEGO�ڷ�]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*���� ����*/
//	FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
//         ( "SYSCNFG"."LINENO" = '1' )   ;
//IF SQLCA.SQLCODE <> 0 THEN 
//	sJipFlag = 'N'
//ELSE
//	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
//END IF
//
//IF sJipFlag = 'Y' THEN
//	sJipFrom = dw_delete.GetItemString(1,"min_ym")
//	sJipTo   = dw_delete.GetItemString(1,"max_ym")
//	
//	//stored procedure�� ������,�ŷ�ó�� ���� ���� ó��(���۳��,������)
//	sle_msg.text ="������,�ŷ�ó�� ������ ����ó�� ���Դϴ�..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//����� ����('00'��)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure�� ����ι��� ���� ���� ó��(���۳��,������)
//	sle_msg.text ="����ι��� ������ ����ó�� ���Դϴ�..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	sle_msg.text ="����ι��� �ŷ�ó�� ������ ����ó�� ���Դϴ�..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function double wf_get_rate (string sbasedate, string scurr);Double  dRate = 0
String  sMaxDate

SELECT MAX("KFZ34OT1"."CLOSING_DATE")  
	INTO :sMaxDate  
   FROM "KFZ34OT1"  
   WHERE ( "KFZ34OT1"."Y_CURR" = :sCurr ) AND ( NVL("KFZ34OT1"."Y_RATE",0) <> 0 );
IF SQLCA.SQLCODE <> 0 THEN
	sMaxDate = '00000000'
ELSE
	IF IsNull(sMaxDate) THEN sMaxDate = '00000000'
END IF

IF sMaxDate = '00000000' THEN
	dRate = 0
ELSE
	IF sMaxDate >= sBaseDate THEN
		SELECT "KFZ34OT1"."Y_RATE"  
    		INTO :dRate  
    		FROM "KFZ34OT1"  
   		WHERE ( "KFZ34OT1"."CLOSING_DATE" = :sMaxDate ) AND ( "KFZ34OT1"."Y_CURR" = :sCurr ) ;
		IF SQLCA.SQLCODE <> 0 THEN
			dRate = 0
		ELSE
			IF IsNull(dRate) THEN dRate = 0
		END IF
	ELSE
		dRate = 0
	END IF
END IF

Return dRate
end function

public function integer wf_insert_chaik_samebill (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik);/********************************************************************************/
/** ��ȯ����/�� ���� �� �뺯 ��ǥ ����	  	     					       			    **/
/*  1. ��ȯ����/�� ����																			 **/
/*     A = SUM((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) 		 **/
/*     IF A > 0 THEN ��ȯ���� 																 **/
/*     ELSEIF A < 0 THEN ��ȯ���� 							  								 **/
/*  2. �뺯 ��ǥ ����(��ȭ�ܻ�����)														 **/
/*  3. �뺯 ��ǥ ����(������(����)):�����ݾ� <> 0										 **/
/********************************************************************************/
Double  dAmount = 0,dMaiChulAmt,dSunSuAmt,dCurMaichul
Integer iCurRow
String  sAcc_ChaSon,sDcGbn,sYesanGbn,sSangGbn,sAccDcr,sChaDae,&
        sAcc1_SonIk,sAcc2_SonIk,sSonIkGbn,sRemark1
Double  dTmpSonIk = 0,dTotalSonIk,dInsAmount = 0

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*��ȯ����/��*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;

IF dChaSon <> 0 OR dChaIk <> 0 THEN
	IF dChaSon <> 0 THEN										/*��ȯ����*/
		sSonIkGbn = '1';			sDcGbn = '1';
		
		dTotalSonIk = dChaSon
		
		sAcc1_SonIk = Mid(sAcc_ChaSon,8,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,13,2)
	ELSEIF dChaIk <> 0 THEN									/*��ȯ����*/	
		sSonIkGbn = '2';			sDcGbn = '2';
	
		dTotalSonIk = dChaIk
		
		sAcc1_SonIk = Left(sAcc_ChaSon,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,6,2)
	END IF
	
	SELECT "KFZ01OM0"."SANG_GU",				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sSangGbn,							 :sChaDae,					:sRemark1  
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1_SonIk AND "KFZ01OM0"."ACC2_CD" = :sAcc1_SonIk;
				
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(irow,"exdept_cd"))	
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_SonIk)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_SonIk)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dTotalSonIk)	
	dw_junpoy.SetItem(iCurRow,"descr",   'ȯ ��' )	
	
	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN		
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF	
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(iRow,"exdept_cd"))
	END IF
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	lLinNo = lLinNo + 1		
END IF

Return 1


end function

public function integer wf_insert_dae (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik);/********************************************************************************/
/** ��ȯ����/�� ���� �� �뺯 ��ǥ ����	  	     					       			    **/
/*  1. ��ȯ����/�� ����																			 **/
/*     A = SUM((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) 		 **/
/*     IF A > 0 THEN ��ȯ���� 																 **/
/*     ELSEIF A < 0 THEN ��ȯ���� 							  								 **/
/*  2. �뺯 ��ǥ ����(��ȭ�ܻ�����)														 **/
/*  3. �뺯 ��ǥ ����(������(����)):�����ݾ� <> 0										 **/
/********************************************************************************/
Double  dWrate,dCiwRate,dUamt,dAmount = 0,dMaiChulAmt,dSunSuAmt,dCurMaichul
Integer iCount,iCurRow,k
String  sAcc_ChaSon,sDcGbn,sAcc1_Dae,sAcc2_Dae,sChaDae,sYesanGbn,sSangGbn,sAccDcr,&
        sAcc1_SonIk,sAcc2_SonIk,sSonIkGbn,sRemark1
Double  dTmpSonIk = 0,dTotalSonIk,dInsAmount = 0

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*��ȯ����/��*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;

dWrate   = dw_rtv.GetItemNumber(irow,"wrate")
IF IsNull(dWrate) THEN dWrate = 0

IF dChaSon <> 0 OR dChaIk <> 0 THEN
	IF dChaSon <> 0 THEN										/*��ȯ����*/
		sSonIkGbn = '1';			sDcGbn = '1';
		
		dTotalSonIk = dChaSon
		
		sAcc1_SonIk = Mid(sAcc_ChaSon,8,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,13,2)
	ELSEIF dChaIk <> 0 THEN									/*��ȯ����*/	
		sSonIkGbn = '2';			sDcGbn = '2';
	
		dTotalSonIk = dChaIk
		
		sAcc1_SonIk = Left(sAcc_ChaSon,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,6,2)
	END IF
			
//	iCount = dw_detail.Retrieve(sNgno,dw_rtv.GetItemNumber(iRow,"weight"),dw_rtv.GetItemString(irow,"icurr"),sSonIkGbn)
//	dw_detail.SetSort("chai_wamt A")
//	dw_detail.Sort()
//	FOR k = 1 TO iCount
//		dAmount = dw_detail.GetItemNumber(k,"chai_wamt")
//		IF IsNull(dAmount) OR dAmount = 0 THEN Continue
//		
//		IF sSonIkGbn = '1' AND dAmount < 0 THEN								/*��ȯ����*/
//			sDcGbn = '2'
//					
//			sAcc1_SonIk = Left(sAcc_ChaSon,5)
//			sAcc2_SonIk = Mid(sAcc_ChaSon,6,2)
//		ELSEIF sSonIkGbn = '1' AND dAmount > 0 THEN							/*��ȯ����*/
//			sDcGbn = '1'
//		
//			sAcc1_SonIk = Mid(sAcc_ChaSon,8,5)
//			sAcc2_SonIk = Mid(sAcc_ChaSon,13,2)
//		ELSEIF sSonIkGbn = '2' AND dAmount < 0 THEN							/*��ȯ����*/
//			sDcGbn = '1'
//		
//			sAcc1_SonIk = Mid(sAcc_ChaSon,8,5)
//			sAcc2_SonIk = Mid(sAcc_ChaSon,13,2)
//		ELSEIF sSonIkGbn = '2' AND dAmount > 0 THEN							/*��ȯ����*/
//			sDcGbn = '2'
//					
//			sAcc1_SonIk = Left(sAcc_ChaSon,5)
//			sAcc2_SonIk = Mid(sAcc_ChaSon,6,2)
//		END IF
//	
//		SELECT "DC_GU",	"YESAN_GU",	"REMARK1"   INTO :sChaDae,	:sYesanGbn,	:sRemark1
//			FROM "KFZ01OM0"  
//			WHERE ( "ACC1_CD" = :sAcc1_SonIk) AND ( "ACC2_CD" = :sAcc2_SonIk);
//
//		IF k = iCount THEN
//			dInsAmount = Abs(dTotalSonIk - dTmpSonIk)
//		ELSE
//			dInsAmount = Abs(dAmount)
//		END IF
		
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
							
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_SonIk)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_SonIk)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dTotalSonIk)	
		dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' ȯ ��' )	
		
		IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN		
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
		END IF			
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))
//		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(k,"chai_uamt"))
//		
//		dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"chai_rate"))
		
	//	dw_junpoy.SetItem(iCurRow,"k_qty",   dw_rtv.GetItemNumber(iRow,"svwrate"))
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(iRow,"exdept_cd"))
		END IF
				
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		lLinNo = lLinNo + 1		
//		
//		dTmpSonIk = dTmpSonIk + dAmount
//	NEXT
END IF

sDcGbn = '2'											/*�뺯 ��ǥ-��ȭ�ܻ�����*/

dMaiChulAmt = dw_rtv.GetItemNumber(iRow,"wuihaw_maichul")
IF IsNull(dMaiChulAmt) THEN dMaiChulAmt = 0

IF dMaiChulAmt <> 0 THEN
	
	iCount = dw_detail.Retrieve(sNgno,dw_rtv.GetItemNumber(iRow,"weight"),dw_rtv.GetItemString(irow,"icurr"),'')
	IF iCount <=0 THEN 
		F_MessageChk(14,'[NEGO ��]')
		Return -1
	END IF

	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU",				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1  
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '25' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
//	dw_sang.Reset()
	
//	FOR k = 1 TO iCount
//		dCurMaichul = dw_detail.GetItemNumber(k,'calc_wonamt')
		dCurMaichul = dw_detail.GetItemNumber(1,'maichul')
		IF IsNull(dCurMaichul) THEN dCurMaichul = 0
		
		iCurRow = dw_junpoy.InsertRow(0)
			
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
		dw_junpoy.SetItem(iCurRow,"amt",     dCurMaichul)
		dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' ��ȭ�ܻ����� ' + dw_rtv.GetItemString(iRow,"curr") )	
		IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN				
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
		END IF
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
			
		IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
			IF Wf_Insert_Sang(k,sNgNo,dw_rtv.GetItemString(iRow,"cvcod"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo) > 0 THEN							
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
			ELSE
				Return -1
			END IF
		ELSE
			dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
		END IF
		
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))		
		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(1,"sum_uamt"))
		
//		if dw_detail.GetItemNumber(k,"drate2") = 0 OR IsNull(dw_detail.GetItemNumber(k,"drate2")) then
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"ciwrate"))
//		else
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"drate2"))
//		end if
		dw_junpoy.SetItem(iCurRow,"k_qty",  	dw_rtv.GetItemNumber(iRow,"wrate"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
		lLinNo = lLinNo + 1	
//	NEXT
END IF

/*�뺯 ��ǥ - ������*/
dSunSuAmt = dw_rtv.GetItemNumber(iRow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

IF dSunSuAmt <> 0 THEN
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU" ,				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1 
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '62' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
	dw_junpoy.SetItem(iCurRow,"amt",     dSunSuAmt)
	dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' ������ �߻�' + dw_rtv.GetItemString(iRow,"explcno"))	
	
	IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN			
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF
	
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
		
	IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
//		IF Wf_Insert_Sang(dw_rtv.GetItemString(iRow,"sabu"),	&
//								dw_rtv.GetItemString(iRow,"ngno"),&
//								dw_rtv.GetItemNumber(iRow,"weight"),&									
//								sSaupj,		sBalDate,	sUpmuGbn,	lJunNo,	lLinNo) > 0 THEN							
//			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
//		ELSE
//			Return -1
//		END IF
	ELSE
		dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
	END IF
	
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))		
	dw_junpoy.SetItem(iCurRow,"y_amt",   dw_rtv.GetItemNumber(iRow,"usunsuamt"))
	dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(iRow,"wrate"))
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
	lLinNo = lLinNo + 1	
END IF

Return 1


end function

public function integer wf_insert_dae_samebill (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno);/********************************************************************************/
/** ��ȯ����/�� ���� �� �뺯 ��ǥ ����	  	     					       			    **/
/*  1. ��ȯ����/�� ����																			 **/
/*     A = SUM((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) 		 **/
/*     IF A > 0 THEN ��ȯ���� 																 **/
/*     ELSEIF A < 0 THEN ��ȯ���� 							  								 **/
/*  2. �뺯 ��ǥ ����(��ȭ�ܻ�����)														 **/
/*  3. �뺯 ��ǥ ����(������(����)):�����ݾ� <> 0										 **/
/********************************************************************************/
Double  dWrate,dCiwRate,dUamt,dAmount = 0,dMaiChulAmt,dSunSuAmt,dCurMaichul
Integer iCount,iCurRow,k
String  sDcGbn,sAcc1_Dae,sAcc2_Dae,sChaDae,sYesanGbn,sSangGbn,sAccDcr,&
        sAcc1_SonIk,sAcc2_SonIk,sSonIkGbn,sRemark1

sDcGbn = '2'											/*�뺯 ��ǥ-��ȭ�ܻ�����*/

dMaiChulAmt = dw_samebill_ngno.GetItemNumber(iRow,"wuihaw_maichul")
IF IsNull(dMaiChulAmt) THEN dMaiChulAmt = 0

IF dMaiChulAmt <> 0 THEN
	
	iCount = dw_detail.Retrieve(sNgno,dw_samebill_ngno.GetItemNumber(iRow,"weight"),dw_samebill_ngno.GetItemString(irow,"icurr"),'')
	IF iCount <=0 THEN 
		F_MessageChk(14,'[NEGO ��]')
		Return -1
	END IF

	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU",				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1  
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '25' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
//	dw_sang.Reset()
//	
//	FOR k = 1 TO iCount
//		dCurMaichul = dw_detail.GetItemNumber(k,'calc_wonamt')
		dCurMaichul = dw_detail.GetItemNumber(1,'maichul')
		IF IsNull(dCurMaichul) THEN dCurMaichul = 0
		
		iCurRow = dw_junpoy.InsertRow(0)
			
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_samebill_ngno.GetItemString(iRow,"exdept_cd"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
		dw_junpoy.SetItem(iCurRow,"amt",     dCurMaichul)
		dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' ��ȭ�ܻ����� ' + dw_samebill_ngno.GetItemString(iRow,"curr"))	
		IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN				
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_samebill_ngno.GetItemString(iRow,"cost_cd"))
		END IF
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_samebill_ngno.GetItemString(iRow,"cvcod"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_samebill_ngno.GetItemString(iRow,"cvname"))
			
		IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
			IF Wf_Insert_Sang(k,sNgNo,dw_samebill_ngno.GetItemString(iRow,"cvcod"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo) > 0 THEN							
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
			ELSE
				Return -1
			END IF
		ELSE
			dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
		END IF
		
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_samebill_ngno.GetItemString(iRow,"curr"))		
		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(1,"sum_uamt"))
		
//		if dw_detail.GetItemNumber(k,"drate2") = 0 OR IsNull(dw_detail.GetItemNumber(k,"drate2")) then
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"ciwrate"))
//		else
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"drate2"))
//		end if
		dw_junpoy.SetItem(iCurRow,"k_qty",  	dw_samebill_ngno.GetItemNumber(iRow,"wrate"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
		lLinNo = lLinNo + 1	
//	NEXT
END IF

/*�뺯 ��ǥ - ������*/
dSunSuAmt = dw_samebill_ngno.GetItemNumber(iRow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

IF dSunSuAmt <> 0 THEN
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU" ,				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1 
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '62' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_samebill_ngno.GetItemString(iRow,"exdept_cd"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
	dw_junpoy.SetItem(iCurRow,"amt",     dSunSuAmt)
	dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' ������ �߻�' + dw_samebill_ngno.GetItemString(iRow,"explcno"))	
	
	IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN			
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_samebill_ngno.GetItemString(iRow,"cost_cd"))
	END IF
	
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_samebill_ngno.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_samebill_ngno.GetItemString(iRow,"cvname"))
		
	IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
//		IF Wf_Insert_Sang(dw_samebill_ngno.GetItemString(iRow,"sabu"),	&
//								dw_samebill_ngno.GetItemString(iRow,"ngno"),&
//								dw_samebill_ngno.GetItemNumber(iRow,"weight"),&									
//								sSaupj,		sBalDate,	sUpmuGbn,	lJunNo,	lLinNo) > 0 THEN							
//			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
//		ELSE
//			Return -1
//		END IF
	ELSE
		dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
	END IF
	
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_samebill_ngno.GetItemString(iRow,"curr"))		
	dw_junpoy.SetItem(iCurRow,"y_amt",   dw_samebill_ngno.GetItemNumber(iRow,"usunsuamt"))
	dw_junpoy.SetItem(iCurRow,"y_rate",  dw_samebill_ngno.GetItemNumber(iRow,"wrate"))
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
	lLinNo = lLinNo + 1	
END IF

Return 1


end function

public function integer wf_insert_kfz12ot0 (string ssaupj);/******************************************************************************************/
/* NEGO�ڷḦ �ڵ����� ��ǥ ó���Ѵ�.																		*/
/* 1. ���� : 1.��ȭ����(���¿���)���� �߻�(�� �� �̻�)												*/
/*             ���� - �Աݰ����ڵ��� ��������															*/
/*             �ݾ� - �Աݾ�																			 		*/
/*           2.������������� �߻�.(�Ǻ��� �߻�)														*/
/*             ���� - KIF08OT2�� COSTCD�� �����ڵ�('65')�� ������(S)�� 7�ڸ�					*/
/*             �ݾ� - KIF08OT2�� COSTAMT�� ��															*/
/*           3.��ȯ�������� �߻�.(�ܻ����ݾ� > �Աݾ� + ������)					 			*/															
/*             ���� - ȯ�������� A-1-16�� 8���� 7�ڸ�													*/
/*             �ݾ� - ((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) ��(C)	*/
/* 2. �뺯 : 1.��ȭ�ܻ����� �������� �߻�.(ȯ�������� A-1-25)									*/
/*             �ݾ� - KIF08OT1�� (UAMT * CIWRATE)�� ��												*/
/*             ���� ó�� - 																					*/
/*           2.��ȯ�������� �߻�.(�����(C)�� 0���� ũ��)											*/
/*             ���� - ȯ�������� A-1-16�� 1���� 7�ڸ�													*/
/*             �ݾ� - ((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) ��(C)	*/
/*           3.������(����) �������� �߻�(ȯ�������� A-1-62)									   */
/*             �ݾ� - KIF08OT0�� �����ݾ�(SUNSUAMT)													*/
/*             ���� - ȯ�������� A-1-62																	*/
/******************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sDcGbn,sAcCode,sDepot,sNgNo,sWuiChaGbn,sYesanGbn,sChaDae,&
			sDepotNo,sBalDate,sAcc_ChaSon,sICurr,sRemark1,sSangGbn,sCusGbn
Integer  k,iCnt,i,lLinNo,iCurRow,iDetailCnt,iMaiChulCnt,iWeight,iIpGumCnt
Long     lJunNo
Double   dAmount,dMaiChul,dWuiChaSonAmt = 0, dWuiChaIkamt = 0

w_mdi_frame.sle_msg.text =""

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*��ȯ����/��*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[��ȯ����/�� ����]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="NEGO �ڵ���ǥ ó�� �� ..."

dw_rtv.AcceptText()

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_junpoy.Reset()
		dw_sang.Reset()
		dw_rbill.Reset()
		dw_sungin.Reset()

//		sSaupj   = dw_rtv.GetItemString(k,"sabu")
		sBalDate = dw_rtv.GetItemString(k,"ngdt")
		sNgNo    = dw_rtv.GetItemString(k,"ngno")								/*nego��ȣ*/
		sICurr   = dw_rtv.GetItemString(k,"icurr")
		
		dMaiChul = dw_rtv.GetItemNumber(k,"wuihaw_maichul")							
		IF IsNull(dMaiChul) THEN dMaiChul = 0
		
		iWeight  = dw_rtv.GetItemNumber(k,"weight")
		IF IsNull(iWeight) THEN iWeight = 1
		
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(28,'[��������]')
			Continue
		END IF
		
//		dRate2 = Wf_Get_Rate(sBalDate, dw_rtv.GetItemString(k,"curr"))
		
		iMaiChulCnt = dw_detail.Retrieve(sNgno,iWeight,sICurr,'')						/*nego��*/
			
		/*��ǥ��ȣ ä��*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		iIpGumCnt = dw_ipgum.Retrieve(sNgNo)
		FOR i = 1 TO iIpGumCnt
			sDepot  = dw_ipgum.GetItemString(i,"dptno")										/*�Աݰ����ڵ�*/
			IF sDepot = '' OR IsNull(sDepot) THEN Continue
			
			SELECT "ACC1_CD", 	"ACC2_CD",		"AB_NO"		/*��������*/
				INTO :sAcc1_Cha,  :sAcc2_Cha,		:sDepotNo
				FROM "KFM04OT0"  
				WHERE "KFM04OT0"."AB_DPNO" = :sDepot   ;
			
			sDcGbn = '1'											/*���� ��ǥ-����*/
			
			SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
				FROM "KFZ01OM0"  
				WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
							
			dAmount = dw_ipgum.GetItemNumber(i,"wonamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
			dw_junpoy.SetItem(iCurRow,"descr",   '�Ա�')	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN			
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			END IF
			dw_junpoy.SetItem(iCurRow,"saup_no", sDepot)
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_ipgum.GetItemString(i,"dptname"))
			dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo)
			
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"icurr"))
			dw_junpoy.SetItem(iCurRow,"y_amt",   dw_ipgum.GetItemNumber(i,"foramt"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_ipgum.GetItemNumber(1,"svwrate"))
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
			END IF
				
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1
		NEXT
		
		iDetailCnt = dw_group_detail.Retrieve(sNgNo)						/*���������*/
		IF iDetailCnt > 0 THEN
			FOR i = 1 TO iDetailCnt
				
				sDcGbn = '1'	
				
				dAmount   = dw_group_detail.GetItemNumber(i,"costamt")
				IF IsNull(dAmount) OR dAmount = 0 THEN Continue
				
				sAcc1_Cha = Left(dw_group_detail.GetItemString(i,"reffpf_rfna2"),5)
				sAcc2_Cha = Mid(dw_group_detail.GetItemString(i,"reffpf_rfna2"),6,2)
				
				SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      
					INTO :sChaDae,	:sYesanGbn,	:sRemark1
					FROM "KFZ01OM0"  
					WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
			
				iCurRow = dw_junpoy.InsertRow(0)
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
				dw_junpoy.SetItem(iCurRow,"descr",   dw_group_detail.GetItemString(i,"reffpf_rfna1") + &
																 dw_rtv.GetItemString(k,"explcno") + '(' + &
																 String(dw_group_detail.GetItemNumber(i,"costforamt"),'###,###,###,##0.00') + ')')	
																 
				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				END IF
				
				dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"curr"))
				dw_junpoy.SetItem(iCurRow,"y_amt",   dw_group_detail.GetItemNumber(i,"costforamt"))
				dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"wrate"))
		
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
				END IF
		
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		iDetailCnt = dw_cha_banje.Retrieve(sNgNo)						/*�ܻ���Ա�,�����ޱ� ���:2002.01.07*/
		IF iDetailCnt > 0 THEN
			FOR i = 1 TO iDetailCnt
				
				sDcGbn = '1'	
				
				dAmount   = dw_cha_banje.GetItemNumber(i,"amount")
				IF IsNull(dAmount) OR dAmount = 0 THEN Continue
				
				sAcc1_Cha = Left(dw_cha_banje.GetItemString(i,"accode"),5)
				sAcc2_Cha = Mid(dw_cha_banje.GetItemString(i,"accode"),6,2)
				
				SELECT "DC_GU",	"YESAN_GU",	"REMARK1",  "SANG_GU"      
					INTO :sChaDae,	:sYesanGbn,	:sRemark1,	:sSangGbn
					FROM "KFZ01OM0"  
					WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
			
				iCurRow = dw_junpoy.InsertRow(0)
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
				dw_junpoy.SetItem(iCurRow,"descr",   dw_cha_banje.GetItemString(i,"saupname") + ' ���')	
				
				
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_cha_banje.GetItemString(i,"saupno"))
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_cha_banje.GetItemString(i,"saupname"))
				
				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				END IF
				
				dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"curr"))
				dw_junpoy.SetItem(iCurRow,"y_amt",   dw_cha_banje.GetItemNumber(i,"amounty"))
				dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"wrate"))
		
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
				END IF
		
				IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
					IF Wf_Insert_Sang_Cha(k,sNgNo,sAcc1_Cha+sAcc2_Cha,dw_cha_banje.GetItemString(i,"saupno"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo) > 0 THEN
						dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
					ELSE
						Return -1
					END IF
				ELSE
					dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
				END IF
		
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		iDetailCnt = dw_bill.Retrieve(sNgNo)						/*���� �߰� : 2001.12.26*/
		IF iDetailCnt > 0 THEN
			SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2),						/*��������*/
					 "DC_GU",						"YESAN_GU",								"REMARK1",		"CUS_GU"
				INTO :sAcc1_Cha,					:sAcc2_Cha,
					  :sChaDae,						:sYesanGbn,								:sRemark1,		:sCusGbn
				FROM "SYSCNFG", "KFZ01OM0"  
				WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND ( "LINENO" = '23' ) AND
						( SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" ) AND
						( SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ) ;
			
			FOR i = 1 TO iDetailCnt
				if dw_bill.GetItemString(i,"samebill") = 'Y' then Continue
				
				sDcGbn = '1'	
				
				dAmount   = dw_bill.GetItemNumber(i,"bill_amt")
				IF IsNull(dAmount) OR dAmount = 0 THEN Continue
				
				iCurRow = dw_junpoy.InsertRow(0)
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
				dw_junpoy.SetItem(iCurRow,"descr",  F_Get_Refferance('BJ',dw_bill.GetItemString(i,"bill_gu"))+' '+&
																dw_bill.GetItemString(i,"bill_bank"))
				
				IF Wf_Insert_Kfz12otd(i,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 					
					Return -1
				ELSE
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
					dw_junpoy.SetItem(iCurRow,"kwan_no", dw_bill.GetItemString(i,"bill_no")) 
					dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_bill.GetItemString(i,"bman_dat")) 					
				END IF
				
				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				END IF
				
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
				END IF
		
				IF sCusGbn = 'Y' THEN
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_bill.GetItemString(i,"salecod")) 
					dw_junpoy.SetItem(iCurRow,"saup_no", f_get_personlst('1',dw_bill.GetItemString(i,"salecod"),'%'))
				END IF
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		Wf_Calculation_ChaIk(k,sNgNo,iWeight,dWuiChaSonAmt,dWuiChaIkamt)			/*��ȯ����/��*/
		
		/*��ȯ����/�� �߻� �� �뺯��ǥ �߻�*/
		IF Wf_Insert_Dae(k,sNgNo,sSaupj,sBalDate,lJunNo,lLinNo,dWuiChaSonAmt,dWuiChaIkamt) = -1 then 
			Return -1
		END IF
		dWuiChaSonAmt = 0; 		dWuiChaIkamt = 0;
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[�������]')
				SetPointer(Arrow!)
				Return -1		
			END IF
			IF dw_rbill.Update() <> 1 THEN
				F_MessageChk(13,'[��������]')
				SetPointer(Arrow!)
				Return -1		
			END IF
			
			dw_rtv.SetItem(k,"saupj",   sSaupj)
			dw_rtv.SetItem(k,"bal_date",sBalDate)
			dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
			dw_rtv.SetItem(k,"bjun_no", lJunNo)
			
			/*�ڵ� ���� ó��*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '���� ó�� ��...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
//					Return -1
				END IF	
				dw_rtv.SetItem(k,"acc_date",dw_sungin.GetItemString(1,"acc_date"))
				dw_rtv.SetItem(k,"jun_no",  dw_sungin.GetItemNumber(1,"jun_no"))
				dw_rtv.SetItem(k,"alc_gu",  'Y')
			END IF
		END IF
	END IF
NEXT
			
IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[NEGO�ڷ�]')
	SetPointer(Arrow!)	
	RETURN -1
END IF
COMMIT;

w_mdi_frame.sle_msg.text ="NEGO ��ǥ ó�� �Ϸ�!!"

Return 1
end function

public subroutine wf_calculation_chaik (integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik);/************************************************************************/
/**           					��ȯ����/�� ����  	            			  **/
/*  A = SUM((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) **/
/*  IF A > 0 THEN ��ȯ���� RETURN '1'											  **/
/*  ELSEIF A < 0 THEN ��ȯ���� RETURN '0'										  **/
/*  ELSE                       RETURN '-1' 									  **/
/************************************************************************/
Double  dWrate,dCiwRate,dUamt,dRate2,dIpGum,dBiYong,dMaiChul,dSunSuAmt,dSangAmt,dBillAmt
Integer iCount,k

iCount = dw_detail.Retrieve(sNgno,iweight,dw_rtv.GetItemString(icurrow,"icurr"),'')
IF iCount <=0 THEN 
	dchason = 0
	dchaik = 0	
	Return	
ELSE
	dMaiChul = dw_detail.GetItemNumber(1,"maichul")
	IF IsNull(dMaiChul) THEN dMaiChul = 0
END IF

IF dw_Ipgum.RowCount() <=0 THEN
	dIpGum = 0
ELSE
	dIpGum = dw_ipgum.GetItemNumber(1,"total_ipgum")	
	IF IsNull(dIpGum) THEN dIpGum = 0
END IF

IF dw_group_detail.RowCount() <=0 THEN
	dBiYong = 0
ELSE
	dBiYong = dw_group_detail.GetItemNumber(1,"sumconsamt")	
	IF IsNull(dBiYong) THEN dBiYong = 0
END IF

dSunSuAmt = dw_rtv.GetItemNumber(icurrow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

if dw_cha_banje.RowCount() <=0 then
	dSangAmt = 0
else
	dSangAmt  = dw_cha_banje.GetItemNumber(1,"sum_sangamt")
	IF IsNull(dSangAmt) THEN dSangAmt = 0
end if

if dw_bill.RowCount() <=0 then
	dBillAmt = 0
else
	dBillAmt  = dw_bill.GetItemNumber(1,"sum_billamt")
	IF IsNull(dBillAmt) THEN dBillAmt = 0
end if

dWrate   = dw_rtv.GetItemNumber(icurrow,"wrate")
IF IsNull(dWrate) THEN dWrate = 0

IF dMaiChul + dSunSuAmt > dIpGum + dBiYong + dSangAmt + dBillAmt THEN							/*�ܻ���� > �Ա� + ��� + ���ݾ�=��ȯ����*/
	dChaSon = dChaSon + ((dMaiChul + dSunSuAmt) - (dIpGum + dBiYong + dSangAmt + dBillAmt))
ELSEIF dMaiChul + dSunSuAmt < dIpGum + dBiYong + dSangAmt + dBillAmt THEN							/*�ܻ���� < �Ա� + ���=��ȯ����*/
	dChaIk  = dChaIk + ((dIpGum + dBiYong + dSangAmt + dBillAmt) - (dMaiChul + dSunSuAmt))
END IF

//FOR k = 1 TO iCount
//	dRate2   = dw_detail.GetItemNumber(k,"drate2")
//	dCiwRate = dw_detail.GetItemNumber(k,"ciwrate")
//	IF IsNull(dRate2) THEN dRate2 = 0
//	IF IsNull(dCiwRate) THEN dCiwRate = 0
//	
//	dUamt    = dw_detail.GetItemNumber(k,"uamt")
//	IF IsNull(dUamt) THEN dUamt = 0
//	
//NEXT



end subroutine

public function integer wf_process_samebill (string ssaupj);/******************************************************************************************/
/* NEGO�ڷḦ �ڵ����� ��ǥ ó���Ѵ�.																		*/
/* 1. ���� : 1.��ȭ����(���¿���)���� �߻�(�� �� �̻�)												*/
/*             ���� - �Աݰ����ڵ��� ��������															*/
/*             �ݾ� - �Աݾ�																			 		*/
/*           2.������������� �߻�.(�Ǻ��� �߻�)														*/
/*             ���� - KIF08OT2�� COSTCD�� �����ڵ�('65')�� ������(S)�� 7�ڸ�					*/
/*             �ݾ� - KIF08OT2�� COSTAMT�� ��															*/
/*           3.��ȯ�������� �߻�.(�ܻ����ݾ� > �Աݾ� + ������)					 			*/															
/*             ���� - ȯ�������� A-1-16�� 8���� 7�ڸ�													*/
/*             �ݾ� - ((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) ��(C)	*/
/* 2. �뺯 : 1.��ȭ�ܻ����� �������� �߻�.(ȯ�������� A-1-25)									*/
/*             �ݾ� - KIF08OT1�� (UAMT * CIWRATE)�� ��												*/
/*             ���� ó�� - 																					*/
/*           2.��ȯ�������� �߻�.(�����(C)�� 0���� ũ��)											*/
/*             ���� - ȯ�������� A-1-16�� 1���� 7�ڸ�													*/
/*             �ݾ� - ((KIF08OT0�� WRATE - KIF08OT1�� CIWRATE) * KIF08OT1�� UAMT) ��(C)	*/
/*           3.������(����) �������� �߻�(ȯ�������� A-1-62)									   */
/*             �ݾ� - KIF08OT0�� �����ݾ�(SUNSUAMT)													*/
/*             ���� - ȯ�������� A-1-62																	*/
/******************************************************************************************/
String     sAcc_ChaSon,sBalDate,sNgNo,siCurr,sDepot,sAcc1_Cha,sAcc2_Cha,sDepotNo,sDcGbn,sChaDae,sYesanGbn,&
			  sRemark1,sSangGbn,sDescr,sCusGbn
Double     dAmount,dWuiChaSonAmt = 0, dWuiChaIkamt = 0
Integer    k,i,m,iNgCnt,iWeight,iIpgumCnt,iCurRow,iDetailCnt,lLinNo
Long       lJunNo

w_mdi_frame.sle_msg.text =""

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*��ȯ����/��*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[��ȯ����/�� ����]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="NEGO �ڵ���ǥ ó�� �� ..."

dw_samebill_ngno.AcceptText()

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		sBalDate = dw_rtv.GetItemString(k,"ngdt")
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(28,'[��������]')
			Continue
		END IF
		
		iNgCnt = dw_samebill_ngno.Retrieve(sSaupj,sBalDate)							/*ó���� nego�Ǽ�*/
		if iNgCnt <=0 then Continue
		
		/*��ǥ��ȣ ä��*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		dw_junpoy.Reset()
		dw_sang.Reset()
		dw_rbill.Reset()
		
		dtotalbiyong  = 0
		dtotalipgum   = 0
		dtotalmaichul = 0
		dtotalsang    = 0
		dtotalsunsu   = 0
		dtotalbill    = 0
		
		FOR i = 1 TO iNgCnt
			sNgNo    = dw_samebill_ngno.GetItemString(i,"ngno")								/*nego��ȣ*/
			sICurr   = dw_samebill_ngno.GetItemString(i,"icurr")
			
			iWeight  = dw_samebill_ngno.GetItemNumber(i,"weight")
			IF IsNull(iWeight) THEN iWeight = 1

			iIpGumCnt = dw_ipgum.Retrieve(sNgNo)
			FOR m = 1 TO iIpGumCnt
				sDepot  = dw_ipgum.GetItemString(m,"dptno")										/*�Աݰ����ڵ�*/
				IF sDepot = '' OR IsNull(sDepot) THEN Continue
				
				SELECT "ACC1_CD", 	"ACC2_CD",		"AB_NO"		/*��������*/
					INTO :sAcc1_Cha,  :sAcc2_Cha,		:sDepotNo
					FROM "KFM04OT0"  
					WHERE "KFM04OT0"."AB_DPNO" = :sDepot   ;
				
				sDcGbn = '1'											/*���� ��ǥ-����*/
				
				SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
					FROM "KFZ01OM0"  
					WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
								
				dAmount = dw_ipgum.GetItemNumber(m,"wonamt")
				IF IsNull(dAmount) THEN dAmount = 0
				
				iCurRow = dw_junpoy.InsertRow(0)
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
				dw_junpoy.SetItem(iCurRow,"descr",   sNgNo + ' �Ա�')	
				
				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN			
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				END IF
				dw_junpoy.SetItem(iCurRow,"saup_no", sDepot)
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_ipgum.GetItemString(m,"dptname"))
				dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo)
				
				dw_junpoy.SetItem(iCurRow,"y_curr",  dw_samebill_ngno.GetItemString(i,"icurr"))
				dw_junpoy.SetItem(iCurRow,"y_amt",   dw_ipgum.GetItemNumber(m,"foramt"))
				dw_junpoy.SetItem(iCurRow,"y_rate",  dw_ipgum.GetItemNumber(1,"svwrate"))
				
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
				END IF
					
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
			
			iDetailCnt = dw_group_detail.Retrieve(sNgNo)						/*���������*/
			IF iDetailCnt > 0 THEN
				FOR m = 1 TO iDetailCnt
					sDcGbn = '1'	
					
					dAmount   = dw_group_detail.GetItemNumber(m,"costamt")
					IF IsNull(dAmount) OR dAmount = 0 THEN Continue
					
					sAcc1_Cha = Left(dw_group_detail.GetItemString(m,"reffpf_rfna2"),5)
					sAcc2_Cha = Mid(dw_group_detail.GetItemString(m,"reffpf_rfna2"),6,2)
					
					SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      
						INTO :sChaDae,	:sYesanGbn,	:sRemark1
						FROM "KFZ01OM0"  
						WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
				
					iCurRow = dw_junpoy.InsertRow(0)
					dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
					dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
					dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
					dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
					dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
					dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
					dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
					dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
					dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
					dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
					dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
					dw_junpoy.SetItem(iCurRow,"descr",   dw_group_detail.GetItemString(m,"reffpf_rfna1") + &
																	 String(dw_group_detail.GetItemNumber(m,"costforamt"),'###,###,###,##0.00') + ')')	
																	 
					IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
						dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
					END IF
					
					dw_junpoy.SetItem(iCurRow,"y_curr",  dw_samebill_ngno.GetItemString(i,"curr"))
					dw_junpoy.SetItem(iCurRow,"y_amt",   dw_group_detail.GetItemNumber(m,"costforamt"))
					dw_junpoy.SetItem(iCurRow,"y_rate",  dw_samebill_ngno.GetItemNumber(i,"wrate"))
			
					IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
						dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
					END IF
			
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
					lLinNo = lLinNo + 1
				NEXT
			END IF
			
			iDetailCnt = dw_cha_banje.Retrieve(sNgNo)						/*�ܻ���Ա�,�����ޱ� ���:2002.01.07*/
			IF iDetailCnt > 0 THEN
				FOR m = 1 TO iDetailCnt
					
					sDcGbn = '1'	
					
					dAmount   = dw_cha_banje.GetItemNumber(m,"amount")
					IF IsNull(dAmount) OR dAmount = 0 THEN Continue
					
					sAcc1_Cha = Left(dw_cha_banje.GetItemString(m,"accode"),5)
					sAcc2_Cha = Mid(dw_cha_banje.GetItemString(m,"accode"),6,2)
					
					SELECT "DC_GU",	"YESAN_GU",	"REMARK1",  "SANG_GU"      
						INTO :sChaDae,	:sYesanGbn,	:sRemark1,	:sSangGbn
						FROM "KFZ01OM0"  
						WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
				
					iCurRow = dw_junpoy.InsertRow(0)
					dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
					dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
					dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
					dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
					dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
					dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
					dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
					dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
					dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
					dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
					dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
					dw_junpoy.SetItem(iCurRow,"descr",   dw_cha_banje.GetItemString(m,"saupname") + ' ���')	
					
					
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_cha_banje.GetItemString(m,"saupno"))
					dw_junpoy.SetItem(iCurRow,"in_nm",   dw_cha_banje.GetItemString(m,"saupname"))
					
					IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
						dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
					END IF
					
					dw_junpoy.SetItem(iCurRow,"y_curr",  dw_samebill_ngno.GetItemString(i,"curr"))
					dw_junpoy.SetItem(iCurRow,"y_amt",   dw_cha_banje.GetItemNumber(m,"amounty"))
					dw_junpoy.SetItem(iCurRow,"y_rate",  dw_samebill_ngno.GetItemNumber(i,"wrate"))
			
					IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
						dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
					END IF
			
					IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
						IF Wf_Insert_Sang_Cha(k,sNgNo,sAcc1_Cha+sAcc2_Cha,dw_cha_banje.GetItemString(m,"saupno"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo) > 0 THEN
							dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
						ELSE
							Return -1
						END IF
					ELSE
						dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
					END IF
			
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
					lLinNo = lLinNo + 1
				NEXT
			END IF
		
			iDetailCnt = dw_bill.Retrieve(sNgNo)						/*���� �߰� : 2001.12.26*/
			IF iDetailCnt > 0 THEN
				SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2),						/*��������*/
						 "DC_GU",						"YESAN_GU",								"REMARK1",		"CUS_GU" 
					INTO :sAcc1_Cha,					:sAcc2_Cha,
						  :sChaDae,						:sYesanGbn,								:sRemark1,		:sCusGbn
					FROM "SYSCNFG", "KFZ01OM0"  
					WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND ( "LINENO" = '23' ) AND
							( SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" ) AND
							( SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ) ;
				
				FOR m = 1 TO iDetailCnt
					if dw_bill.GetItemString(m,"samebill") = 'Y' then Continue
					
					sDcGbn = '1'	
					
					dAmount   = dw_bill.GetItemNumber(m,"bill_amt")
					IF IsNull(dAmount) OR dAmount = 0 THEN Continue
					
					iCurRow = dw_junpoy.InsertRow(0)
					dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
					dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
					dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
					dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
					dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
					dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
					dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
					dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
					dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
					dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
					dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
					
					if IsNull(dw_bill.GetItemString(m,"bill_gu")) then
						sDescr = dw_bill.GetItemString(m,"bill_bank")
					else
						sDescr = F_Get_Refferance('BJ',dw_bill.GetItemString(m,"bill_gu"))+' '+dw_bill.GetItemString(m,"bill_bank")
					end if
					dw_junpoy.SetItem(iCurRow,"descr",  sDescr)
					
					IF Wf_Insert_Kfz12otd(m,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
						dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 					
						Return -1
					ELSE
						dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
						dw_junpoy.SetItem(iCurRow,"kwan_no", dw_bill.GetItemString(m,"bill_no")) 
						dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_bill.GetItemString(m,"bman_dat")) 					
					END IF
					
					IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
						dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
					END IF
					
					IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
						dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
					END IF
			
					IF sCusGbn = 'Y' THEN
						dw_junpoy.SetItem(iCurRow,"saup_no", dw_bill.GetItemString(m,"salecod")) 
						dw_junpoy.SetItem(iCurRow,"saup_no", f_get_personlst('1',dw_bill.GetItemString(m,"salecod"),'%'))
					END IF
				
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
					lLinNo = lLinNo + 1
				NEXT
			END IF
			if i = iNgCnt then
				Wf_Calculation_ChaIk_SameBill('L',i,sNgNo,iWeight,dWuiChaSonAmt,dWuiChaIkamt)			/*��ȯ����/��*/	
			else
				Wf_Calculation_ChaIk_SameBill('C',i,sNgNo,iWeight,dWuiChaSonAmt,dWuiChaIkamt)			/*��ȯ����/��*/	
			end if
			
			/*�뺯��ǥ �߻�*/
			IF Wf_Insert_Dae_SameBill(i,sNgNo,sSaupj,sBalDate,lJunNo,lLinNo) = -1 then 
				Return -1
			END IF
		NEXT		
		/*��ȯ����/�� �߻�*/
		IF Wf_Insert_ChaIk_SameBill(k,sSaupj,sBalDate,lJunNo,lLinNo,dWuiChaSonAmt,dWuiChaIkamt) = -1 then 
			Return -1
		END IF
		
		dtotalbiyong  = 0;		dtotalipgum   = 0;		dtotalmaichul = 0;
		dtotalsang    = 0;		dtotalsunsu   = 0;		dtotalbill    = 0;

		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[�������]')
				SetPointer(Arrow!)
				Return -1		
			END IF
			IF dw_rbill.Update() <> 1 THEN
				F_MessageChk(13,'[��������]')
				SetPointer(Arrow!)
				Return -1		
			END IF

			/*�װ� ���� ����*/
			UPDATE "KIF08OT0"  
				SET "BAL_DATE" = :sBalDate,   "UPMU_GU" = :sUpmuGbn,   "BJUN_NO" = :lJunNo,   "ALC_GU" = 'N'  
				WHERE ( "KIF08OT0"."SABU" = '1' ) AND  ( "KIF08OT0"."NGDT" = :sBalDate ) AND  
						( "KIF08OT0"."SAMEGU" = 'Y' ) AND  
						( "KIF08OT0"."BAL_DATE" = '' or "KIF08OT0"."BAL_DATE" is null ) ;
			IF SQLCA.SQLCODE <> 0 THEN
				F_MessageChk(13,'[NEGO����]')
				SetPointer(Arrow!)
				Return -1		
			END IF
			
			/*�ڵ� ���� ó��*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '���� ó�� ��...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
				END IF
			END IF
		END IF
	END IF
NEXT
COMMIT;

w_mdi_frame.sle_msg.text ="NEGO ��ǥ ó�� �Ϸ�!!"

Return 1
end function

on w_kifa151.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_group_detail=create dw_group_detail
this.dw_sang=create dw_sang
this.dw_detail=create dw_detail
this.dw_ip=create dw_ip
this.dw_ipgum=create dw_ipgum
this.dw_bill=create dw_bill
this.dw_rbill=create dw_rbill
this.dw_samebill_ngno=create dw_samebill_ngno
this.dw_cha_banje=create dw_cha_banje
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
this.cbx_all=create cbx_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_sungin
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.dw_group_detail
this.Control[iCurrent+8]=this.dw_sang
this.Control[iCurrent+9]=this.dw_detail
this.Control[iCurrent+10]=this.dw_ip
this.Control[iCurrent+11]=this.dw_ipgum
this.Control[iCurrent+12]=this.dw_bill
this.Control[iCurrent+13]=this.dw_rbill
this.Control[iCurrent+14]=this.dw_samebill_ngno
this.Control[iCurrent+15]=this.dw_cha_banje
this.Control[iCurrent+16]=this.rr_1
this.Control[iCurrent+17]=this.dw_rtv
this.Control[iCurrent+18]=this.dw_delete
this.Control[iCurrent+19]=this.cbx_all
end on

on w_kifa151.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_group_detail)
destroy(this.dw_sang)
destroy(this.dw_detail)
destroy(this.dw_ip)
destroy(this.dw_ipgum)
destroy(this.dw_bill)
destroy(this.dw_rbill)
destroy(this.dw_samebill_ngno)
destroy(this.dw_cha_banje)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
destroy(this.cbx_all)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",  Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ipgum.SetTransObject(SQLCA)
dw_group_detail.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_bill.SetTransObject(SQLCA)
dw_rbill.SetTransObject(SQLCA)
dw_samebill_ngno.SetTransObject(SQLCA)
dw_cha_banje.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*�ڵ� ���� ���� üũ*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '13' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_kifa151
boolean visible = false
integer x = 55
integer y = 3120
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa151
boolean visible = false
integer x = 3182
integer y = 3108
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa151
boolean visible = false
integer x = 3008
integer y = 3108
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa151
boolean visible = false
integer x = 2304
integer y = 3104
integer taborder = 0
string picturename = "C:\erpman\image\����ȸ_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����ȸ_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����ȸ_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa151
boolean visible = false
integer x = 2834
integer y = 3108
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa151
integer y = 12
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa151
boolean visible = false
integer x = 3703
integer y = 3108
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa151
boolean visible = false
integer x = 2487
integer y = 3100
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF MessageBox("Ȯ ��", "����Ͻðڽ��ϱ� ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

FOR i = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(i,"chk") = '1' THEN
		sSaupj   = dw_rtv.GetItemString(i,"saupj")
		sBalDate = dw_rtv.GetItemString(i,"bal_date") 
		sUpmuGu  = dw_rtv.GetItemString(i,"upmu_gu") 
		lBJunNo  = dw_rtv.GetItemNumber(i,"bjun_no") 
		
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
	END IF
NEXT

end event

type p_inq from w_inherite`p_inq within w_kifa151
integer x = 4096
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaleDtf,sSaleDtT,sSaupj,sSameGu

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sSaleDtf = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtf"))
sSaleDtt = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtt"))
sSameGu  = dw_ip.GetItemString(dw_ip.GetRow(),"samegu")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[�����]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[NEGO����]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[NEGO����]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(False)
dw_delete.SetRedraw(False)
if sSameGu = 'N' then
	dw_rtv.DataObject = 'd_kifa152'
	dw_delete.DataObject = 'd_kifa153'
else
	dw_rtv.DataObject = 'd_kifa1512'
	dw_delete.DataObject = 'd_kifa1515'		
end if
dw_rtv.SetTransObject(Sqlca)
dw_delete.SetTransObject(Sqlca)
dw_rtv.SetRedraw(True)
dw_delete.SetRedraw(True)

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa151
boolean visible = false
integer x = 3529
integer y = 3108
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa151
integer x = 4270
integer y = 12
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

event p_mod::clicked;call super::clicked;Integer iYesCnt,k
String  sSaupj,sSameGu

IF rb_1.Checked =True THEN
	IF dw_ip.AcceptText() = -1 THEN RETURN
	sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sSameGu  = dw_ip.GetItemString(dw_ip.GetRow(),"samegu")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[�����]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_rtv.RowCount() <=0 THEN Return
	iYesCnt = dw_rtv.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF
		
	if sSameGu = 'N' then
		IF Wf_Insert_Kfz12ot0(sSaupj) = -1 THEN
			Rollback;
			Return
		END IF
	else
		IF Wf_Process_SameBill(sSaupj) = -1 THEN
			Rollback;
			Return
		END IF
	end if
	Commit;
	
	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	iYesCnt = dw_delete.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
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

type cb_exit from w_inherite`cb_exit within w_kifa151
boolean visible = false
integer x = 3959
integer y = 2792
end type

type cb_mod from w_inherite`cb_mod within w_kifa151
boolean visible = false
integer x = 3602
integer y = 2792
string text = "ó��(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa151
boolean visible = false
integer x = 1609
integer y = 2908
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa151
boolean visible = false
integer x = 2469
integer y = 2908
end type

type cb_inq from w_inherite`cb_inq within w_kifa151
boolean visible = false
integer x = 3241
integer y = 2792
end type

type cb_print from w_inherite`cb_print within w_kifa151
boolean visible = false
integer x = 2811
integer y = 2796
end type

type st_1 from w_inherite`st_1 within w_kifa151
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa151
boolean visible = false
integer x = 3177
integer y = 2908
end type

type cb_search from w_inherite`cb_search within w_kifa151
boolean visible = false
integer x = 2290
integer y = 2796
integer width = 498
string text = "ǰ�񺸱�(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa151
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kifa151
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kifa151
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa151
boolean visible = false
integer x = 1577
integer y = 2856
integer width = 1970
integer height = 184
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa151
boolean visible = false
integer x = 3195
integer y = 2736
integer width = 1134
end type

type gb_1 from groupbox within w_kifa151
integer x = 2862
integer width = 891
integer height = 176
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "�۾�����"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kifa151
integer x = 2880
integer y = 68
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ǥ����ó��"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="NEGO �ڵ���ǥ ����"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa151
integer x = 3305
integer y = 68
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ǥ����ó��"
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="NEGO �ڵ���ǥ ����"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa151
boolean visible = false
integer x = 82
integer y = 2280
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ ����"
string dataobject = "d_kifa106"
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

type dw_sungin from datawindow within w_kifa151
boolean visible = false
integer x = 87
integer y = 2388
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "������ǥ ���κ� ����"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa151
boolean visible = false
integer x = 87
integer y = 2492
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ �μ�"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_group_detail from datawindow within w_kifa151
boolean visible = false
integer x = 1289
integer y = 2336
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "��������� ��"
string dataobject = "d_kifa154"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kifa151
boolean visible = false
integer x = 87
integer y = 2596
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "����ó����� ����"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_detail from datawindow within w_kifa151
boolean visible = false
integer x = 1289
integer y = 2548
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "NEGO�ݾ� ��"
string dataobject = "d_kifa155"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_kifa151
event ue_key pbm_dwnkey
integer x = 50
integer width = 2816
integer height = 188
integer taborder = 10
string dataobject = "d_kifa1511"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '99' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[�����]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��꼭��������")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��꼭��������")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "custf" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(1,"custfname",snull)
		Return
	END IF
	
	/*�ŷ�ó�� ���� ó��*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[�ŷ�ó]')
		this.SetItem(1,"custf",    sNull)
		this.SetItem(1,"custfname",sNull)
		Return 1
	ELSE
		this.SetItem(1,"custfname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "custt" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(1,"custtname",snull)
		Return
	END IF
	
	/*�ŷ�ó�� ���� ó��*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[�ŷ�ó]')
		this.SetItem(1,"custt",    sNull)
		this.SetItem(1,"custtname",sNull)
		Return 1
	ELSE
		this.SetItem(1,"custtname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "deptf" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[�����μ�]')
		this.SetItem(1,"deptf",snull)
		Return 1
	END IF
	this.SetItem(1,"deptfname",sDeptName)
END IF

IF this.GetColumnName() = "deptt" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[�����μ�]')
		this.SetItem(1,"deptt",snull)
		Return 1
	END IF
	this.SetItem(1,"depttname",sDeptName)
END IF

IF dwo.name = 'samegu' THEN
	IF data = '' or IsNull(data) then return
	
	dw_rtv.SetRedraw(False)
	dw_delete.SetRedraw(False)
	if data = 'N' then
		dw_rtv.DataObject = 'd_kifa152'
		dw_delete.DataObject = 'd_kifa153'
	else
		dw_rtv.DataObject = 'd_kifa1512'
		dw_delete.DataObject = 'd_kifa1515'		
	end if
	dw_rtv.SetTransObject(Sqlca)
	dw_delete.SetTransObject(Sqlca)
	dw_rtv.SetRedraw(True)
	dw_delete.SetRedraw(True)
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_ipgum from datawindow within w_kifa151
boolean visible = false
integer x = 1289
integer y = 2436
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "�Աݳ��� ��"
string dataobject = "d_kifa156"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type dw_bill from datawindow within w_kifa151
boolean visible = false
integer x = 1289
integer y = 2656
integer width = 1010
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "��������"
string dataobject = "d_kifa1514"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_rbill from datawindow within w_kifa151
boolean visible = false
integer x = 87
integer y = 2700
integer width = 1006
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "�������� ����"
string dataobject = "d_kifa054"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_samebill_ngno from datawindow within w_kifa151
boolean visible = false
integer x = 2299
integer y = 2652
integer width = 905
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "���Ͼ������� ngno"
string dataobject = "d_kifa1513"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event retrieveend;Integer k

this.SetRedraw(False)
FOR k = 1 TO rowcount
	IF dw_detail.Retrieve(this.GetItemString(k,"ngno"),this.GetItemNumber(k,"weight"),this.GetItemString(k,"icurr"),'') > 0 THEN
		this.SetItem(k,"wuihaw_maichul",dw_detail.GetItemNumber(1,"maichul"))
	ELSE
		this.SetItem(k,"wuihaw_maichul",0)		
	END IF

	IF dw_group_detail.Retrieve(this.GetItemString(k,"ngno")) > 0 THEN
		this.SetItem(k,"bwonhaw",dw_group_detail.GetItemNumber(1,"sumconsamt"))
		this.SetItem(k,"bwuihaw",dw_group_detail.GetItemNumber(1,"sumconsforamt"))
	ELSE
		this.SetItem(k,"bwonhaw",0)
		this.SetItem(k,"bwuihaw",0)
	END IF
NEXT
this.SetRedraw(True)
end event

type dw_cha_banje from datawindow within w_kifa151
boolean visible = false
integer x = 2299
integer y = 2544
integer width = 905
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "�ܻ���Աݻ��,�����ޱ��ڷ�"
string dataobject = "d_kifa158"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kifa151
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 192
integer width = 4539
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kifa151
integer x = 73
integer y = 200
integer width = 4512
integer height = 2024
integer taborder = 30
string dataobject = "d_kifa152"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()

end event

event itemerror;Return 1
end event

event itemchanged;Double dAmount,dSunSuAmt
String sGbn,sAcc1_Dae,sAcc2_Dae,snull

SetNull(snull)

IF this.GetcolumnName() = "chk" THEN
	sGbn = this.GetText()
	IF sGbn = "" OR IsNull(sGbn) THEN Return
	
	if dw_ip.GetItemString(1,"samegu") = 'Y' then Return
	
	dAmount   = this.GetItemNumber(this.GetRow(),"wuihaw_maichul")
	IF Isnull(dAmount) THEN dAmount = 0
	
	dSunSuAmt = this.GetItemNumber(this.GetRow(),"wsunsuamt")
	IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0
	
	IF sGbn = '1' AND dAmount = 0 AND dSunSuAmt = 0 THEN
		F_MessageChk(16,'[��ȭ�ܻ����ݾ� = 0 OR �����ݾ� = 0]')
		this.SetItem(this.GetRow(),"chk",'N')
		Return 1
	END IF
END IF
end event

event retrieveend;Integer k
Double  dRate

if dw_ip.GetItemString(1,"samegu") = 'N' then
	this.SetRedraw(False)
	FOR k = 1 TO rowcount
		IF dw_detail.Retrieve(this.GetItemString(k,"ngno"),this.GetItemNumber(k,"weight"),dw_rtv.GetItemString(k,"icurr"),'') > 0 THEN
			this.SetItem(k,"wuihaw_maichul",dw_detail.GetItemNumber(1,"maichul"))
		ELSE
			this.SetItem(k,"wuihaw_maichul",0)		
		END IF
	
		IF dw_group_detail.Retrieve(this.GetItemString(k,"ngno")) > 0 THEN
			this.SetItem(k,"bwonhaw",dw_group_detail.GetItemNumber(1,"sumconsamt"))
			this.SetItem(k,"bwuihaw",dw_group_detail.GetItemNumber(1,"sumconsforamt"))
		ELSE
			this.SetItem(k,"bwonhaw",0)
			this.SetItem(k,"bwuihaw",0)
		END IF
	NEXT
	this.SetRedraw(True)
end if
end event

event doubleclicked;Double dWuiChaSonAmt,dWuiChaIkamt

IF row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

if dw_ip.GetItemString(1,"samegu") = 'Y' then Return

Wf_Calculation_ChaIk(row,this.GetItemString(row,"ngno"),&
								 this.GetItemNumber(row,"weight"),dWuiChaSonAmt,dWuiChaIkamt)			/*��ȯ����/��*/
IF dWuiChaSonAmt <> 0 AND dWuiChaIkamt = 0 THEN
	Gs_Gubun = '2'
ELSEIF  dWuiChaSonAmt = 0 AND dWuiChaIkamt <> 0 THEN
	Gs_Gubun = '1'
ELSE
	Gs_Gubun = ''
END IF

OpenWithParm(w_kifa15b,this.GetItemString(row,"ngno"))
end event

type dw_delete from datawindow within w_kifa151
integer x = 73
integer y = 200
integer width = 4512
integer height = 2024
integer taborder = 40
string dataobject = "d_kifa153"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;IF row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

OpenWithParm(w_kifa15b,this.GetItemString(row,"ngno"))
end event

event clicked;//IF Row <=0 THEN Return
//
////IF this.GetColumnName() = "chk" THEN
////	SelectRow(0,False)
////ELSE
//	SelectRow(0,False)
//	SelectRow(Row,True)	
////END IF
	
end event

type cbx_all from checkbox within w_kifa151
integer x = 3762
integer y = 112
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ü����"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '�ڷ� ���� ��...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

