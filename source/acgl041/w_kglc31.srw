$PBExportHeader$w_kglc31.srw
$PBExportComments$지급결제 전표-전표발행/취소 처리
forward
global type w_kglc31 from w_inherite
end type
type rr_3 from roundrectangle within w_kglc31
end type
type rb_1 from radiobutton within w_kglc31
end type
type rb_2 from radiobutton within w_kglc31
end type
type dw_junpoy from datawindow within w_kglc31
end type
type dw_junpoylst from datawindow within w_kglc31
end type
type dw_sang from datawindow within w_kglc31
end type
type dw_jbill from datawindow within w_kglc31
end type
type dw_save from datawindow within w_kglc31
end type
type dw_sungin from datawindow within w_kglc31
end type
type dw_method2 from datawindow within w_kglc31
end type
type dw_list from u_d_select_sort within w_kglc31
end type
type dw_bill_detail from datawindow within w_kglc31
end type
type dw_cond from u_key_enter within w_kglc31
end type
type rr_1 from roundrectangle within w_kglc31
end type
type rr_2 from roundrectangle within w_kglc31
end type
type dw_method from u_key_enter within w_kglc31
end type
type gb_2 from groupbox within w_kglc31
end type
end forward

global type w_kglc31 from w_inherite
integer x = 27
integer y = 16
integer width = 4430
integer height = 2488
string title = "지급결제내역  전표발행 처리"
boolean minbox = false
windowtype windowtype = response!
rr_3 rr_3
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_junpoylst dw_junpoylst
dw_sang dw_sang
dw_jbill dw_jbill
dw_save dw_save
dw_sungin dw_sungin
dw_method2 dw_method2
dw_list dw_list
dw_bill_detail dw_bill_detail
dw_cond dw_cond
rr_1 rr_1
rr_2 rr_2
dw_method dw_method
gb_2 gb_2
end type
global w_kglc31 w_kglc31

type variables
String     sBaseDate,LsAutoSungGbn
Double     LdAryAmt[11]
String      LsAryAcc1[11],LsAryAcc2[11],LsAryChaDae[11],LsAryDescr[11]
end variables

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, long llinno)
public function integer wf_setting_acc ()
public subroutine wf_insert_sang (string gyeldate, long gyelseq, string saupj, string baldate, string upmugu, long bjunno, long linno, string acc1, string acc2, string sdept)
public subroutine wf_init ()
public function integer wf_delete_kfz12ot0 (string saupj, string baldate, string upmugu, long bjunno)
public function integer wf_create_kfz12ot0_hap (string sSaupj, string sBalDate, long ljunpoyno)
public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq)
end prototypes

public function integer wf_requiredchk ();Integer i
String  sSaupj,sDept, sEmpno,sSaupDept
Double  dPcAmt

dw_cond.AcceptText()

sSaupj    = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDept     = dw_cond.GetItemString(dw_cond.GetRow(),"deptcode")
sEmpno    = dw_cond.GetItemString(dw_cond.GetRow(),"empno")
sSaupDept = dw_cond.GetItemString(dw_cond.GetRow(),"sdeptcode")
dPcAmt    = dw_cond.GetItemNumber(dw_cond.GetRow(),"pcfee")
IF IsNull(dPcAmt) THEN dPcAmt =0

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.Setcolumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF

IF sDept = "" OR IsNull(sDept) THEN
	F_MessageChk(1,'[작성부서]')
	dw_cond.Setcolumn("deptcode")
	dw_cond.SetFocus()
	Return -1
END IF

IF sEmpNo = "" OR IsNull(sEmpNo) THEN
	F_MessageChk(1,'[작성자]')
	dw_cond.Setcolumn("empno")
	dw_cond.SetFocus()
	Return -1
END IF

IF dPcAmt <> 0 THEN
	IF sSaupDept = "" OR IsNull(sSaupDept) THEN
		F_MessageChk(1,'[원가부문]')
		dw_cond.Setcolumn("sdeptcode")
		dw_cond.SetFocus()
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, long llinno);Integer iFindRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGu+String(lJunNo,'0000')+String(lLinNo,'000')
					 
iFindRow = dw_jbill.InsertRow(0)
	
dw_jbill.SetItem(iFindRow,"saupj",			sSaupj)
dw_jbill.SetItem(iFindRow,"bal_date",		sBalDate)
dw_jbill.SetItem(iFindRow,"upmu_gu",		sUpmuGu)
dw_jbill.SetItem(iFindRow,"bjun_no",		lJunNo)
dw_jbill.SetItem(iFindRow,"lin_no",			lLinNo)
dw_jbill.SetItem(iFindRow,"full_junno",	sFullJunNo)

//dw_jbill.SetItem(iFindRow,"mbal_date",			sBalDate)
//dw_jbill.SetItem(iFindRow,"mupmu_gu",			sUpmuGu)
//dw_jbill.SetItem(iFindRow,"mjun_no",			lJunNo)
//dw_jbill.SetItem(iFindRow,"mlin_no",			lLinNo)

dw_jbill.SetItem(iFindRow,"bill_no",			dw_bill_detail.GetItemString(iRow,"billno"))
dw_jbill.SetItem(iFindRow,"saup_no",			dw_junpoylst.GetItemString(1,"saup_no"))
dw_jbill.SetItem(iFindRow,"bnk_cd",				dw_bill_detail.GetItemString(iRow,"bank_cd"))
dw_jbill.SetItem(iFindRow,"bbal_dat",			dw_bill_detail.GetItemString(iRow,"bbaldate"))
dw_jbill.SetItem(iFindRow,"bman_dat",			dw_bill_detail.GetItemString(iRow,"bmandate"))
dw_jbill.SetItem(iFindRow,"bill_amt",			dw_bill_detail.GetItemNumber(iRow,"billamt"))
dw_jbill.SetItem(iFindRow,"bill_nm",			dw_bill_detail.GetItemString(iRow,"bill_nm"))
dw_jbill.SetItem(iFindRow,"status",				'1')
dw_jbill.SetItem(iFindRow,"remark1",			dw_junpoylst.GetItemString(1,"descr"))

dw_jbill.SetItem(iFindRow,"owner_saupj",		sSaupj)

Return 1
end function

public function integer wf_setting_acc ();Double    dCashAmt,dDepotAmt,dAccAmt,dPcAmt,dAccSellAmt,dAccFundAmt,dBillAmt,dPayDptAmt,dAccAmt2,dAccAmt3
String    sDepotNo,sSaupj,sChNo
Integer   k

FOR k= 1 TO 10
	LsAryAcc1[k] = '';	LsAryAcc2[k] = '';	LsAryChaDae[k] ='';	LdAryAmt[k] =0;
NEXT

dw_cond.AcceptText()
dw_method.AcceptText()

sSaupj = dw_cond.GetItemString(1,"saupj")

dPcAmt = dw_cond.GetItemNumber(1,"pcfee")
IF IsNull(dPcAmt) THEN dPcAmt = 0

/*결제 계정코드 가져오기*/
dCashAmt    = dw_method.GetItemNumber(1,"cashamt")
dDepotAmt   = dw_method.GetItemNumber(1,"depotamt")
dAccFundAmt = dw_method.GetItemNumber(1,"accamt_fund")
dAccSellAmt = dw_method.GetItemNumber(1,"accamt_sell")
dBillAmt		= dw_method.GetItemNumber(1,"billamt")

dAccAmt     = dw_method.GetItemNumber(1,"accamt")
dAccAmt2    = dw_method.GetItemNumber(1,"accamt2")
dAccAmt3    = dw_method.GetItemNumber(1,"accamt3")

IF IsNull(dCashAmt)  THEN dCashAmt  = 0
IF IsNull(dDepotAmt) THEN dDepotAmt = 0
IF IsNull(dAccFundAmt) THEN dAccFundAmt = 0
IF IsNull(dAccSellAmt) THEN dAccSellAmt = 0
IF IsNull(dBillAmt) THEN dBillAmt = 0

IF IsNull(dAccAmt)   THEN dAccAmt   = 0
IF IsNull(dAccAmt2)   THEN dAccAmt2   = 0
IF IsNull(dAccAmt3)   THEN dAccAmt3   = 0

LsAryAcc1[1] = '';	LsAryAcc2[1] = '';	LsAryChaDae[1] = '1';			/*처리할 지급결제 대상 자료*/
										
IF dCashAmt  <> 0 THEN										/*현금*/
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)  
   	INTO :LsAryAcc1[2],						 :LsAryAcc2[2]  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[2] = '00000'; LsAryAcc2[2] = '00';
		F_MessageChk(25,'[현금계정(A-1-1)]')
		Return -1
	END IF
	LsAryChaDae[2] = '2';		LsAryDescr[2] = '현금으로 지급';
	LdAryAmt[2] = dCashAmt 
ELSE
	LsAryAcc1[2] = '9'; LsAryAcc2[2] = '9';
	LdAryAmt[2] = 0
END IF

IF dDepotAmt <> 0 THEN										/*예금*/
	sDepotNo    = dw_method.GetItemString(1,"depotno")
	
	SELECT "KFM04OT0"."ACC1_CD",            "KFM04OT0"."ACC2_CD"  
		INTO :LsAryAcc1[3],						 :LsAryAcc2[3]  
	   FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sDepotNo  ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[3] = '00000'; LsAryAcc2[3] = '00';
		F_MessageChk(25,'[예금계정(예적금코드의 계정)]')
		Return -1
	END IF
	LsAryChaDae[3] = '2';		LsAryDescr[3] = '예금으로 지급';
	LdAryAmt[3] = dDepotAmt	+ dPcAmt
ELSE
	LsAryAcc1[3] = '9'; LsAryAcc2[3] = '9';	
	LdAryAmt[3] = 0;
END IF

IF dAccFundAmt <> 0 THEN										/*구매자금*/
	sChNo    = dw_method.GetItemString(1,"chaip_no")
	
	select substr(rfna2,1,5), substr(rfna2,6,2)
		into :LsAryAcc1[4],						 :LsAryAcc2[4]  
		from reffpf
		where rfcod = 'GM' and rfgub = '3' ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[4] = '00000'; LsAryAcc2[4] = '00';
		F_MessageChk(25,'[구매자금계정(차입금코드의 계정)]')
		Return -1
	END IF
	LsAryChaDae[4] = '2';		LsAryDescr[4] = '구매자금으로 지급';
	LdAryAmt[4] = dAccFundAmt
ELSE
	LsAryAcc1[4] = '9'; LsAryAcc2[4] = '9';	
	LdAryAmt[4] = 0;
END IF

IF dAccSellAmt <> 0 THEN										/*외상매출채권*/
	
	select substr(rfna2,1,5), substr(rfna2,6,2)
		into :LsAryAcc1[5],						 :LsAryAcc2[5]  
		from reffpf
		where rfcod = 'GM' and rfgub = '4' ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[5] = '00000'; LsAryAcc2[5] = '00';
		F_MessageChk(25,'[외상매출채권담보계정]')
		Return -1
	END IF
	LsAryChaDae[5] = '2';		LsAryDescr[5] = '외상매출채권담보로 지급';
	LdAryAmt[5] = dAccSellAmt
ELSE
	LsAryAcc1[5] = '9'; LsAryAcc2[5] = '9';	
	LdAryAmt[5] = 0;
END IF

IF dBillAmt <> 0 THEN
	IF dw_bill_detail.GetItemNumber(1,"paycnt") > 0 THEN				/*지급어음*/
		SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)  
			INTO :LsAryAcc1[6],						  :LsAryAcc2[6]  
			FROM "SYSCNFG"  
			WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				  ( "SYSCNFG"."LINENO" = '24' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			LsAryAcc1[6] = '00000'; 		LsAryAcc2[6] = '00';
			F_MessageChk(25,'[지급어음계정(A-1-24)]')
			Return -1
		END IF
		LsAryChaDae[6] = '2';		LsAryDescr[6] = '지급어음 발행';
		LdAryAmt[6] = 0
	ELSE
		LsAryAcc1[6] = '9'; LsAryAcc2[6] = '9';	
		LdAryAmt[6]  = 0
	END IF
END IF

IF dPcAmt <> 0 THEN															/*PC뱅킹수수료*/
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)  
		INTO :LsAryAcc1[7],						  :LsAryAcc2[7]  
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			  ( "SYSCNFG"."LINENO" = '35' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[7] = '00000'; 		LsAryAcc2[7] = '00';
		F_MessageChk(25,'[수수료계정(A-1-35)]')
		Return -1
	END IF
	LsAryChaDae[7] = '1';		LsAryDescr[7] = '송금 수수료';
	LdAryAmt[7] = dPcAmt
ELSE
	LsAryAcc1[7] = '9'; LsAryAcc2[7] = '9';	
	LdAryAmt[7]  = dPcAmt
END IF

IF dAccAmt <> 0 THEN											/*계정1*/
	LsAryAcc1[8] = dw_method.GetItemString(1,"sacc1")
	LsAryAcc2[8] = dw_method.GetItemString(1,"sacc2")
	
	IF LsAryAcc1[8] = "" OR IsNull(LsAryAcc1[8]) THEN LsAryAcc1[8] = '00000'
	IF LsAryAcc2[8] = "" OR IsNull(LsAryAcc2[8]) THEN LsAryAcc2[8] = '00'
	
	LsAryChaDae[8] = '2';		
	LsAryDescr[8]  = dw_method.GetItemString(1,"saccname")+' 으로 지급';
	LdAryAmt[8]    = dAccAmt
ELSE
	LsAryAcc1[8] = '9'; LsAryAcc2[8] = '9';	
	LdAryAmt[8]  = dAccAmt
END IF

IF dAccAmt2 <> 0 THEN											/*계정2*/
	LsAryAcc1[9] = dw_method.GetItemString(1,"sacc1_2")
	LsAryAcc2[9] = dw_method.GetItemString(1,"sacc2_2")
	
	IF LsAryAcc1[9] = "" OR IsNull(LsAryAcc1[9]) THEN LsAryAcc1[9] = '00000'
	IF LsAryAcc2[9] = "" OR IsNull(LsAryAcc2[9]) THEN LsAryAcc2[9] = '00'
	
	LsAryChaDae[9] = '2';		
	LsAryDescr[9] = dw_method.GetItemString(1,"saccname2")+' 으로 지급';
	LdAryAmt[9] = dAccAmt2
ELSE
	LsAryAcc1[9] = '9'; LsAryAcc2[9] = '9';	
	LdAryAmt[9]  = dAccAmt2
END IF

IF dAccAmt3 <> 0 THEN											/*계정3*/
	LsAryAcc1[10] = dw_method.GetItemString(1,"sacc1_3")
	LsAryAcc2[10] = dw_method.GetItemString(1,"sacc2_3")
	
	IF LsAryAcc1[10] = "" OR IsNull(LsAryAcc1[10]) THEN LsAryAcc1[10] = '00000'
	IF LsAryAcc2[10] = "" OR IsNull(LsAryAcc2[10]) THEN LsAryAcc2[10] = '00'
	
	LsAryChaDae[10] = '2';		
	LsAryDescr[10] = dw_method.GetItemString(1,"saccname3")+' 으로 지급';
	LdAryAmt[10] = dAccAmt3
ELSE
	LsAryAcc1[10] = '9'; LsAryAcc2[10] = '9';	
	LdAryAmt[10]  = dAccAmt3
END IF


//IF dCheckAmt <> 0 THEN										/*당좌예금*/
//	sDepotNo    = dw_method.GetItemString(1,"checkcode")
//	
//	SELECT "KFM04OT0"."ACC1_CD",            "KFM04OT0"."ACC2_CD"  
//		INTO :LsAryAcc1[12],						 :LsAryAcc2[12]  
//	   FROM "KFM04OT0"  
//   	WHERE "KFM04OT0"."AB_DPNO" = :sDepotNo  ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		LsAryAcc1[12] = '00000'; LsAryAcc2[12] = '00';
//		F_MessageChk(25,'[예금계정(예적금코드의 계정)]')
//		Return -1
//	END IF
//	LsAryChaDae[12] = '2';		LsAryDescr[12] = '당좌예금으로 지급';
//	LdAryAmt[12] = dCheckAmt
//ELSE
//	LsAryAcc1[12] = '9'; LsAryAcc2[12] = '9';	
//	LdAryAmt[12] = 0;
//END IF

Return 1

end function

public subroutine wf_insert_sang (string gyeldate, long gyelseq, string saupj, string baldate, string upmugu, long bjunno, long linno, string acc1, string acc2, string sdept);
Integer iCount,iInsertRow,k

dw_save.Reset()

iCount = dw_save.Retrieve(gyeldate,gyelseq,acc1,acc2)
IF iCount <=0 THEN Return

FOR k = 1 TO iCount

	iInsertRow = dw_sang.InsertRow(0)
	
	dw_sang.SetItem(iInsertRow,"saupj",    dw_save.GetItemString(k,"saupj"))
	dw_sang.SetItem(iInsertRow,"acc_date", dw_save.GetItemString(k,"acc_date"))
	dw_sang.SetItem(iInsertRow,"upmu_gu",  dw_save.GetItemString(k,"upmu_gu"))
	dw_sang.SetItem(iInsertRow,"jun_no",   dw_save.GetItemNumber(k,"jun_no"))
	dw_sang.SetItem(iInsertRow,"lin_no",   dw_save.GetItemNumber(k,"lin_no"))
	dw_sang.SetItem(iInsertRow,"jbal_date",dw_save.GetItemString(k,"bal_date"))
	dw_sang.SetItem(iInsertRow,"bjun_no",  dw_save.GetItemNumber(k,"bjun_no"))
	
	dw_sang.SetItem(iInsertRow,"saupj_s",  saupj)
	dw_sang.SetItem(iInsertRow,"bal_date", baldate)
	dw_sang.SetItem(iInsertRow,"upmu_gu_s",upmugu)
	dw_sang.SetItem(iInsertRow,"bjun_no_s",bjunno)
	dw_sang.SetItem(iInsertRow,"lin_no_s", linno)
	dw_sang.SetItem(iInsertRow,"amt_s",    dw_save.GetItemNumber(k,"crossamt"))
NEXT

end subroutine

public subroutine wf_init ();
sle_msg.text = ''

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"saupj",   gs_saupj)
dw_cond.SetItem(dw_cond.GetRow(),"deptcode",gs_dept)
dw_cond.SetItem(dw_cond.GetRow(),"empno",   gs_empno)
dw_cond.SetItem(dw_cond.GetRow(),"empname", F_Get_PersonLst('4',Gs_EmpNo,'1'))
dw_cond.SetItem(dw_cond.GetRow(),"baldate", F_Today())
dw_cond.SetRedraw(True)

dw_cond.SetColumn("empno")
dw_cond.SetFocus()

dw_list.Reset()

dw_list.SetRedraw(False)
IF sModStatus = 'I' THEN											/*전표발행*/
	dw_list.DataObject = 'd_kglc212'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()

	dw_cond.Modify("t_sawon.visible = 0")
	dw_cond.Modify("t_dept.visible = 0")
	
	rr_3.Visible = True
	gb_2.Visible = True
	dw_method.Visible = True
ELSE
	dw_cond.SetItem(dw_cond.GetRow(),"deptcode",gs_dept)
	dw_cond.SetItem(dw_cond.GetRow(),"empno",   gs_empno)
	dw_cond.SetItem(dw_cond.GetRow(),"empname", F_Get_PersonLst('4',Gs_EmpNo,'1'))

	dw_list.DataObject = 'd_kglc2120'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	dw_cond.Modify("t_sawon.visible = 1")
	dw_cond.Modify("t_dept.visible = 1")
	
	rr_3.Visible = False
	gb_2.Visible = False
	dw_method.Visible = False
END IF
dw_list.SetRedraw(True)

dw_method.SetRedraw(False)
dw_method.Reset()
dw_method.InsertRow(0)
dw_method.SetRedraw(True)

dw_method2.SetRedraw(False)
dw_method2.Reset()
dw_method2.InsertRow(0)
dw_method2.SetRedraw(True)

end subroutine

public function integer wf_delete_kfz12ot0 (string saupj, string baldate, string upmugu, long bjunno);Integer iRowCount,k,iCurRow

dw_junpoy.Reset()
dw_sang.Reset()
dw_jbill.Reset()

SetPointer(HourGlass!)

iRowCount = dw_junpoy.Retrieve(Saupj,BalDate,UpmuGu,BJunNo)
IF iRowCount <=0 THEN Return 1

FOR k= iRowCount TO 1 STEP -1							/*전표 삭제*/
	dw_junpoy.DeleteRow(k)		
NEXT

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(12,'[미승인전표]')
	Return -1
END IF

DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
	WHERE ( "KFZ12OT1"."SAUPJ"    = :Saupj  ) AND  
			( "KFZ12OT1"."BAL_DATE" = :BalDate ) AND  
			( "KFZ12OT1"."UPMU_GU"  = :UpmuGu ) AND  
			( "KFZ12OT1"."JUN_NO"   = :BJunNo ) ;
				
/*결제내역에 전표관련 자료 갱신*/
UPDATE "KFZ19OT2"  
	SET "ABAL_DATE" = null,   
       "AUPMU_GU" = null,   
       "ABJUN_NO" = null
   WHERE ( "KFZ19OT2"."ASAUPJ" = :Saupj ) AND ( "KFZ19OT2"."ABAL_DATE" = :BalDate ) AND
			( "KFZ19OT2"."AUPMU_GU" = :UpmuGu) AND ( "KFZ19OT2"."ABJUN_NO" = :BJunNo) ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(12,'[결제내역 갱신]')
	Return -1
END IF


Return 1

end function

public function integer wf_create_kfz12ot0_hap (string sSaupj, string sBalDate, long ljunpoyno);Integer iRowCount,k,iCurRow,i,iBillCnt,iInsRow,lgyelseq,iSelectRow
String  sUpmuGbn = 'T',sChaDae,sSangGbn,sCusGbn,sYesanGbn,sRemark1,sGbn1,sGbn4,sChGbn,&
		  sDepotNo,sgyeldate

dw_cond.AcceptText()
dw_method.AcceptText()

dw_junpoy.Reset()
dw_sang.Reset()
dw_jbill.Reset()
		
SetPointer(HourGlass!)

DO WHILE true
	iSelectRow = 	dw_list.GetSelectedRow(0)
	If iSelectRow = 0 then EXIT
	
	sgyeldate = dw_list.GetItemString(iSelectRow,"gyel_date")
	lgyelseq  = dw_list.GetItemNumber(iSelectRow,"seqno")
	
	dw_method.Retrieve(sgyeldate,lgyelseq)

	iRowCount = dw_junpoylst.Retrieve(sgyeldate,lgyelseq)
	IF iRowCount <= 0 THEN Return 1
	
	IF Wf_Setting_Acc() = -1 THEN Return -1
	
	FOR k = 1 TO 10
		IF LsAryAcc1[k] = '9' AND LsAryAcc2[k] = '9' THEN Continue			/*금액이 없으면 SKIP*/
		
		IF k = 1 THEN										/*지급결제 대상 자료 처리*/
			FOR i = 1 TO iRowCount									
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
				
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", dw_junpoylst.GetItemString(i,"acc1_cd"))
				dw_junpoy.SetItem(iCurRow,"acc2_cd", dw_junpoylst.GetItemString(i,"acc2_cd"))
				dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
				
				dw_junpoy.SetItem(iCurRow,"amt",     dw_junpoylst.GetItemNumber(i,"junamt"))
				dw_junpoy.SetItem(iCurRow,"descr",   dw_junpoylst.GetItemString(i,"descr"))
				
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_junpoylst.GetItemString(i,"sdept_cd"))
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(i,"saup_no")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
													F_Get_PersonLst('1',dw_junpoylst.GetItemString(i,"saup_no"),'1')) 
				
				Wf_Insert_Sang(sGyelDate,lGyelSeq,sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow,&
									dw_junpoylst.GetItemString(i,"acc1_cd"),dw_junpoylst.GetItemString(i,"acc2_cd"),&
									dw_junpoylst.GetItemString(i,"sdept_cd"))
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y') 
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			NEXT
		ELSEIF k = 6 THEN												/*지급어음*/
			SELECT "SANG_GU",		"CUS_GU", 	"YESAN_GU",		"DC_GU",		"REMARK1",	 "GBN1"
				INTO :sSangGbn, 	:sCusGbn,	:sYesanGbn,		:sChaDae,	:sRemark1,   :sGbn1
				FROM "KFZ01OM0"  
				WHERE ( "ACC1_CD" = :LsAryAcc1[k]) AND ( "ACC2_CD" = :LsAryAcc2[k])  ;
			IF SQLCA.SQLCODE <> 0 THEN
				sSangGbn = 'N';	sCusGbn  = 'N';	sYesanGbn = 'N';	sRemark1 = 'N';	sGbn1 = '';	sGbn4 = 'N';
			ELSE
				IF IsNull(sSangGbn) THEN sSangGbn = 'N'
				IF IsNull(sCusGbn) THEN sCusGbn = 'N'
				IF IsNull(sYesanGbn) THEN sYesanGbn = 'N'
				IF IsNull(sRemark1) THEN sRemark1 = 'N'
				IF IsNull(sGbn4) THEN sGbn4 = 'N'
			END IF
			
			dw_jbill.Retrieve(sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,1)
			
			iBillCnt = dw_bill_detail.Retrieve(dw_method.GetItemString(1,"gyel_date"),dw_method.GetItemNumber(1,"seqno"),'P')	
			FOR i = 1 TO iBillCnt
				iCurRow = dw_junpoy.InsertRow(0)
			
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
				
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", LsAryAcc1[k])
				dw_junpoy.SetItem(iCurRow,"acc2_cd", LsAryAcc2[k])
				dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
			
				dw_junpoy.SetItem(iCurRow,"amt",     dw_bill_detail.GetItemNumber(i,"billamt"))
				dw_junpoy.SetItem(iCurRow,"descr",   LsAryDescr[k])
		
				IF sCusGbn = 'Y' THEN
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(1,"saup_no")) 
						dw_junpoy.SetItem(iCurRow,"in_nm",   &
													F_Get_PersonLst('1',dw_junpoylst.GetItemString(1,"saup_no"),'1'))
				END IF		
		
				IF Wf_Insert_Kfz12otc(i,sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow) = 1 THEN
					dw_junpoy.SetItem(iCurRow,"jbill_gu",'Y')
		
					dw_junpoy.SetItem(iCurRow,"kwan_no", dw_bill_detail.GetItemString(i,"billno"))
					dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_bill_detail.GetItemString(i,"bmandate"))
				END IF
				
				IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
				END IF
				
				IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_cond.GetItemString(1,"deptcode")) 
				END IF
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			NEXT
		ELSE
			SELECT "SANG_GU",		"CUS_GU", 	"YESAN_GU",		"DC_GU",		"REMARK1",
					 "GBN1",			"GBN4"
				INTO :sSangGbn, 	:sCusGbn,	:sYesanGbn,		:sChaDae,	:sRemark1,
					  :sGbn1,		:sGbn4
				FROM "KFZ01OM0"  
				WHERE ( "ACC1_CD" = :LsAryAcc1[k]) AND ( "ACC2_CD" = :LsAryAcc2[k])  ;
			IF SQLCA.SQLCODE <> 0 THEN
				sSangGbn = 'N';	sCusGbn  = 'N';	sYesanGbn = 'N';	sRemark1 = 'N';	sGbn1 = '';	sGbn4 = 'N';
			ELSE
				IF IsNull(sSangGbn) THEN sSangGbn = 'N'
				IF IsNull(sCusGbn) THEN sCusGbn = 'N'
				IF IsNull(sYesanGbn) THEN sYesanGbn = 'N'
				IF IsNull(sRemark1) THEN sRemark1 = 'N'
				IF IsNull(sGbn4) THEN sGbn4 = 'N'
			END IF
			
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", LsAryAcc1[k])
			dw_junpoy.SetItem(iCurRow,"acc2_cd", LsAryAcc2[k])
			dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
		
			dw_junpoy.SetItem(iCurRow,"amt",     LdAryAmt[k])
			dw_junpoy.SetItem(iCurRow,"descr",   LsAryDescr[k])
			
			IF sCusGbn = 'Y' THEN
				IF sGbn1 = '5' THEN												/*예적금*/
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_method.GetItemString(1,"depotno")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('5',dw_method.GetItemString(1,"depotno"),'1')) 
				ELSEIF sGbn1 = '2' THEN											/*금융기관*/
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_method.GetItemString(1,"chaip_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('2',dw_method.GetItemString(1,"chaip_no"),'1')) 
				ELSE
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(1,"saup_no")) 
						dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_junpoylst.GetItemString(1,"saup_no"),'1'))
				END IF
			END IF				
			
			IF sSangGbn = 'Y' AND LsAryChaDae[k] <> sChaDae THEN				/*반제 처리 계정*/									
				lstr_jpra.saupjang = sSaupj
				lstr_jpra.baldate  = sGyelDate
				lstr_jpra.upmugu   = sUpmuGbn
				lstr_jpra.bjunno   = lJunPoyNo
				lstr_jpra.sortno   = iCurRow
				lstr_jpra.saupno   = dw_junpoylst.GetItemString(1,"saup_no")
				lstr_jpra.acc1     = LsAryAcc1[k]
				lstr_jpra.acc2     = LsAryAcc2[k]
				lstr_jpra.money    = LdAryAmt[k]
					
				OpenWithParm(W_kglb01g,'')
				IF Message.StringParm = '0' THEN		/*반제처리 안함*/
					F_MessageChk(17,'[반제 처리]')
					Return -1
				END IF			
			END IF
		
			IF k = 4 THEN
				dw_junpoy.SetItem(iCurRow,"k_eymd",    dw_method.GetItemString(1,"bmandate")) 
				dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_junpoylst.GetItemString(1,"saup_no")) 			
			ELSEIF k = 5 THEN
				dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_method.GetItemString(1,"chaip_no")) 
				dw_junpoy.SetItem(iCurRow,"k_eymd",    dw_method.GetItemString(1,"bmandate")) 
			ELSEIF k = 8 THEN
				dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_method.GetItemString(1,"kwan_no")) 			
			END IF
			
			IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
			END IF
			
			IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",   dw_cond.GetItemString(1,"deptcode")) 
			END IF
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		END IF
	NEXT
	
	dw_list.SelectRow(iSelectRow,FALSE)
LOOP

SetPointer(Arrow!)

IF dw_jbill.Update() <> 1 THEN
	F_MessageChk(13,'[지급어음]')
	Return -1	
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	Return -1
END IF

IF dw_sang.Update() <> 1 THEN
	F_MessageChk(13,'[반제결과]')
	Return -1	
END IF

/*결제내역에 전표관련 자료 갱신*/
UPDATE "KFZ19OT2"  
	SET "ABAL_DATE" = :sGyelDate,   
       "AUPMU_GU" = :sUpmuGbn,   
       "ABJUN_NO" = :lJunPoyNo
   WHERE ( "KFZ19OT2"."GYEL_DATE" = :sGyelDate ) AND ( "KFZ19OT2"."ASAUPJ" = :sSaupj) AND
			( "ABAL_DATE" = '' OR "ABAL_DATE" IS NULL);
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(13,'[결제내역 갱신]')
	Return -1
END IF
					 
Return 1
end function

public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq);Integer iRowCount,k,iCurRow,i,iBillCnt,iInsRow
String  sSaupj,sUpmuGbn = 'T',sChaDae,sSangGbn,sCusGbn,sYesanGbn,sRemark1,sGbn1,sGbn4,sChGbn,sDepotNo
Long    lJunPoyNo

dw_cond.AcceptText()
dw_method.AcceptText()

iRowCount = dw_junpoylst.Retrieve(sgyeldate,lgyelseq)
IF iRowCount <= 0 THEN Return 1

sSaupj = dw_cond.GetItemString(1,"saupj")

IF Wf_Setting_Acc() = -1 THEN Return -1

IF F_Check_LimitDate(sgyeldate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
		
lJunPoyNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sgyeldate)

dw_junpoy.Reset()
dw_sang.Reset()
dw_jbill.Reset()

SetPointer(HourGlass!)

FOR k = 1 TO 10
	IF LsAryAcc1[k] = '9' AND LsAryAcc2[k] = '9' THEN Continue			/*금액이 없으면 SKIP*/

	IF k = 1 THEN										/*지급결제 대상 자료 처리*/
		FOR i = 1 TO iRowCount									
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", dw_junpoylst.GetItemString(i,"acc1_cd"))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", dw_junpoylst.GetItemString(i,"acc2_cd"))
			dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
			
			dw_junpoy.SetItem(iCurRow,"amt",     dw_junpoylst.GetItemNumber(i,"junamt"))
			dw_junpoy.SetItem(iCurRow,"descr",   dw_junpoylst.GetItemString(i,"descr"))
			
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_junpoylst.GetItemString(i,"sdept_cd"))
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(i,"saup_no")) 
			dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_junpoylst.GetItemString(i,"saup_no"),'1')) 
			
			Wf_Insert_Sang(sGyelDate,lGyelSeq,sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow,&
								dw_junpoylst.GetItemString(i,"acc1_cd"),dw_junpoylst.GetItemString(i,"acc2_cd"),&
								dw_junpoylst.GetItemString(i,"sdept_cd"))
			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y') 
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		NEXT
	ELSEIF k = 6 THEN												/*지급어음*/
		SELECT "SANG_GU",		"CUS_GU", 	"YESAN_GU",		"DC_GU",		"REMARK1",	 "GBN1"
			INTO :sSangGbn, 	:sCusGbn,	:sYesanGbn,		:sChaDae,	:sRemark1,   :sGbn1
		   FROM "KFZ01OM0"  
		   WHERE ( "ACC1_CD" = :LsAryAcc1[k]) AND ( "ACC2_CD" = :LsAryAcc2[k])  ;
		IF SQLCA.SQLCODE <> 0 THEN
			sSangGbn = 'N';	sCusGbn  = 'N';	sYesanGbn = 'N';	sRemark1 = 'N';	sGbn1 = '';	sGbn4 = 'N';
		ELSE
			IF IsNull(sSangGbn) THEN sSangGbn = 'N'
			IF IsNull(sCusGbn) THEN sCusGbn = 'N'
			IF IsNull(sYesanGbn) THEN sYesanGbn = 'N'
			IF IsNull(sRemark1) THEN sRemark1 = 'N'
			IF IsNull(sGbn4) THEN sGbn4 = 'N'
		END IF
		
		dw_jbill.Retrieve(sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,1)
		
		iBillCnt = dw_bill_detail.Retrieve(dw_method.GetItemString(1,"gyel_date"),dw_method.GetItemNumber(1,"seqno"),'P')	
		FOR i = 1 TO iBillCnt
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", LsAryAcc1[k])
			dw_junpoy.SetItem(iCurRow,"acc2_cd", LsAryAcc2[k])
			dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
		
			dw_junpoy.SetItem(iCurRow,"amt",     dw_bill_detail.GetItemNumber(i,"billamt"))
			dw_junpoy.SetItem(iCurRow,"descr",   LsAryDescr[k])

			IF sCusGbn = 'Y' THEN
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(1,"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_junpoylst.GetItemString(1,"saup_no"),'1'))
			END IF		

			IF Wf_Insert_Kfz12otc(i,sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow) = 1 THEN
				dw_junpoy.SetItem(iCurRow,"jbill_gu",'Y')

				dw_junpoy.SetItem(iCurRow,"kwan_no", dw_bill_detail.GetItemString(i,"billno"))
				dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_bill_detail.GetItemString(i,"bmandate"))
			END IF
			
			IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
			END IF
			
			IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_cond.GetItemString(1,"deptcode")) 
			END IF
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		NEXT
	ELSE
		SELECT "SANG_GU",		"CUS_GU", 	"YESAN_GU",		"DC_GU",		"REMARK1",
				 "GBN1",			"GBN4"
			INTO :sSangGbn, 	:sCusGbn,	:sYesanGbn,		:sChaDae,	:sRemark1,
				  :sGbn1,		:sGbn4
		   FROM "KFZ01OM0"  
		   WHERE ( "ACC1_CD" = :LsAryAcc1[k]) AND ( "ACC2_CD" = :LsAryAcc2[k])  ;
		IF SQLCA.SQLCODE <> 0 THEN
			sSangGbn = 'N';	sCusGbn  = 'N';	sYesanGbn = 'N';	sRemark1 = 'N';	sGbn1 = '';	sGbn4 = 'N';
		ELSE
			IF IsNull(sSangGbn) THEN sSangGbn = 'N'
			IF IsNull(sCusGbn) THEN sCusGbn = 'N'
			IF IsNull(sYesanGbn) THEN sYesanGbn = 'N'
			IF IsNull(sRemark1) THEN sRemark1 = 'N'
			IF IsNull(sGbn4) THEN sGbn4 = 'N'
		END IF
		
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", LsAryAcc1[k])
		dw_junpoy.SetItem(iCurRow,"acc2_cd", LsAryAcc2[k])
		dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
	
		dw_junpoy.SetItem(iCurRow,"amt",     LdAryAmt[k])
		dw_junpoy.SetItem(iCurRow,"descr",   LsAryDescr[k])
		
		IF sCusGbn = 'Y' THEN
			IF sGbn1 = '5' THEN												/*예적금*/
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_method.GetItemString(1,"depotno")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('5',dw_method.GetItemString(1,"depotno"),'1')) 
			ELSEIF sGbn1 = '2' THEN											/*금융기관*/
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_method.GetItemString(1,"chaip_no")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('2',dw_method.GetItemString(1,"chaip_no"),'1')) 
			ELSE
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_junpoylst.GetItemString(1,"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('1',dw_junpoylst.GetItemString(1,"saup_no"),'1'))
			END IF
		END IF				
		
		IF sSangGbn = 'Y' AND LsAryChaDae[k] <> sChaDae THEN				/*반제 처리 계정*/									
			lstr_jpra.saupjang = sSaupj
			lstr_jpra.baldate  = sGyelDate
			lstr_jpra.upmugu   = sUpmuGbn
			lstr_jpra.bjunno   = lJunPoyNo
			lstr_jpra.sortno   = iCurRow
			lstr_jpra.saupno   = dw_junpoylst.GetItemString(1,"saup_no")
			lstr_jpra.acc1     = LsAryAcc1[k]
			lstr_jpra.acc2     = LsAryAcc2[k]
			lstr_jpra.money    = LdAryAmt[k]
				
			OpenWithParm(W_kglb01g,'')
			IF Message.StringParm = '0' THEN		/*반제처리 안함*/
				F_MessageChk(17,'[반제 처리]')
				Return -1
			END IF			
		END IF

		IF k = 4 THEN
			dw_junpoy.SetItem(iCurRow,"k_eymd",    dw_method.GetItemString(1,"bmandate")) 
			dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_junpoylst.GetItemString(1,"saup_no")) 			
		ELSEIF k = 5 THEN
			dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_method.GetItemString(1,"chaip_no")) 
			dw_junpoy.SetItem(iCurRow,"k_eymd",    dw_method.GetItemString(1,"bmandate")) 
		ELSEIF k = 8 THEN
			dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_method.GetItemString(1,"kwan_no")) 			
		END IF
		
		IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
		END IF
		
		IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",   dw_cond.GetItemString(1,"deptcode")) 
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	END IF
NEXT
SetPointer(Arrow!)

IF dw_jbill.Update() <> 1 THEN
	F_MessageChk(13,'[지급어음]')
	Return -1	
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	Return -1
END IF

IF dw_sang.Update() <> 1 THEN
	F_MessageChk(13,'[반제결과]')
	Return -1	
END IF

/*결제내역에 전표관련 자료 갱신*/
UPDATE "KFZ19OT2"  
	SET "ABAL_DATE" = :sGyelDate,   
       "AUPMU_GU" = :sUpmuGbn,   
       "ABJUN_NO" = :lJunPoyNo
   WHERE ( "KFZ19OT2"."GYEL_DATE" = :sGyelDate ) AND  
         ( "KFZ19OT2"."SEQNO" = :lGyelSeq )   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(13,'[결제내역 갱신]')
	Return -1
END IF

MessageBox("확 인","발생된 미결전표번호 :"+String(sGyelDate,'@@@@.@@.@@')+'-'+String(lJunPoyNo,'0000'))
					 
Return 1
end function

on w_kglc31.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_junpoylst=create dw_junpoylst
this.dw_sang=create dw_sang
this.dw_jbill=create dw_jbill
this.dw_save=create dw_save
this.dw_sungin=create dw_sungin
this.dw_method2=create dw_method2
this.dw_list=create dw_list
this.dw_bill_detail=create dw_bill_detail
this.dw_cond=create dw_cond
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_method=create dw_method
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_junpoylst
this.Control[iCurrent+6]=this.dw_sang
this.Control[iCurrent+7]=this.dw_jbill
this.Control[iCurrent+8]=this.dw_save
this.Control[iCurrent+9]=this.dw_sungin
this.Control[iCurrent+10]=this.dw_method2
this.Control[iCurrent+11]=this.dw_list
this.Control[iCurrent+12]=this.dw_bill_detail
this.Control[iCurrent+13]=this.dw_cond
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
this.Control[iCurrent+16]=this.dw_method
this.Control[iCurrent+17]=this.gb_2
end on

on w_kglc31.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_junpoylst)
destroy(this.dw_sang)
destroy(this.dw_jbill)
destroy(this.dw_save)
destroy(this.dw_sungin)
destroy(this.dw_method2)
destroy(this.dw_list)
destroy(this.dw_bill_detail)
destroy(this.dw_cond)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_method)
destroy(this.gb_2)
end on

event open;call super::open;
F_Window_Center_Response(This)

dw_cond.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_method.SetTransObject(SQLCA)
dw_method2.SetTransObject(SQLCA)

dw_save.SetTransObject(SQLCA)
dw_junpoy.SetTransObject(SQLCA)
dw_junpoylst.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

dw_jbill.SetTransObject(SQLCA)
dw_bill_detail.SetTransObject(SQLCA)

dw_sungin.SetTransObject(SQLCA)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '15' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_cond.SetItem(dw_cond.GetRow(),"saupj",   gs_saupj)
dw_cond.SetItem(dw_cond.GetRow(),"deptcode",gs_dept)
dw_cond.SetItem(dw_cond.GetRow(),"empno",   gs_empno)
dw_cond.SetItem(dw_cond.GetRow(),"empname", F_Get_PersonLst('4',Gs_EmpNo,'1'))


			



end event

type dw_insert from w_inherite`dw_insert within w_kglc31
boolean visible = false
integer x = 2592
integer y = 2636
integer height = 144
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc31
boolean visible = false
integer x = 3433
integer y = 2624
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc31
boolean visible = false
integer x = 3259
integer y = 2624
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc31
integer x = 3872
integer y = 4
integer taborder = 60
string pointer = "c:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_search::clicked;Integer iSelectRow
String  sSaupj,sBalDate,sUpmuGbn='T',sAlcGbn,sNoGbn
Long    lJunPoyNo,lBJunNo

dw_cond.AcceptText()
sSaupj   = dw_cond.GetItemString(1,"saupj")
sBalDate = dw_cond.GetItemString(1,"baldate")
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return
END IF
IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_cond.SetColumn("baldate")
	dw_cond.SetFocus()
	Return
END IF

select substr(nvl(dataname,'1'),1,1)	into :sNoGbn			/*전표번호 채번방식:1(건별)*/
	from syscnfg where sysgu = 'A' and serial = 8 and lineno = '10';
if sqlca.sqlcode = 0 then
	if IsNull(sNoGbn) then sNoGbn = '1'
else
	sNoGbn = '1'
end if

iSelectRow = dw_list.GetSelectedRow(0)
IF iSelectRow <=0 Then
	F_MessageChk(11,'')
	dw_cond.SetFocus()
	Return
END IF

SetPointer(HourGlass!)
IF sModStatus = 'I' THEN												/*전표발행시*/
	
	IF Wf_RequiredChk() = -1 THEN Return
	IF MessageBox("확 인","전표발행하시겠습니까?",Question!,YesNo!) = 2 THEN Return
	
	if sNoGbn <> '1' then			/*묶어서 처리*/
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[발행일자]')
			Return -1
		END IF
				
		lJunPoyNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
	
		IF Wf_Create_Kfz12ot0_Hap(sSaupj,sBalDate,lJunPoyNo) = -1 THEN
			Rollback;
		ELSE
			commit;
		
			MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunPoyNo,'0000'))

			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
					Return -1
				END IF	
			END IF
		END IF
	else
		DO WHILE true
			iSelectRow = 	dw_list.GetSelectedRow(0)
			If iSelectRow = 0 then EXIT
		
			dw_method.Retrieve(dw_list.GetItemString(iSelectRow,"gyel_date"),dw_list.GetItemNumber(iSelectRow,"seqno"))
			
			IF Wf_Create_Kfz12ot0(dw_list.GetItemString(iSelectRow,"gyel_date"),&
										 dw_list.GetItemNumber(iSelectRow,"seqno")) = -1 THEN
				Rollback;
			ELSE
				commit;
				
				/*자동 승인 처리*/
				IF LsAutoSungGbn = 'Y' THEN
					w_mdi_frame.sle_msg.text = '승인 처리 중...'
					IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
						SetPointer(Arrow!)
						Return -1
					END IF	
				END IF
			END IF
		
			dw_list.SelectRow(iSelectRow,FALSE)
		LOOP
	end if
ELSE
	IF MessageBox("확 인","전표발행취소하시겠습니까?",Question!,YesNo!) = 2 THEN Return
	DO WHILE true
		iSelectRow = 	dw_list.GetSelectedRow(0)
		If iSelectRow = 0 then EXIT
	
		sSaupj   = dw_list.GetItemString(iSelectRow,"asaupj")
		sBalDate = dw_list.GetItemString(iSelectRow,"abal_date")
		sUpmuGbn = dw_list.GetItemString(iSelectRow,"aupmu_gu")
		lBJunNo  = dw_list.GetItemNumber(iSelectRow,"abjun_no")
		
		SELECT DISTINCT "KFZ12OT0"."ALC_GU"  INTO :sAlcGbn  
			FROM "KFZ12OT0"  
			WHERE ( "KFZ12OT0"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT0"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT0"."UPMU_GU"  = :sUpmuGbn ) AND  
					( "KFZ12OT0"."BJUN_NO"  = :lBJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(50,'')
			SetPointer(Arrow!)
			Return
		END IF
		
		sle_msg.text = '전표 발행 취소 중...'
		IF Wf_Delete_Kfz12ot0(sSaupj,sBalDate,sUpmuGbn,lBJunNo) = -1 then 
			Rollback;
			SetPointer(Arrow!)
			Return
		ELSE
			commit;
		END IF
		dw_list.SelectRow(iSelectRow,FALSE)
	LOOP	
END IF
SetPointer(Arrow!)

Wf_Init()

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_kglc31
boolean visible = false
integer x = 3086
integer y = 2624
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc31
integer x = 4219
integer y = 4
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kglc31
integer x = 4046
integer y = 4
integer taborder = 40
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_kglc31
boolean visible = false
integer x = 2912
integer y = 2628
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc31
integer x = 3698
integer y = 4
end type

event p_inq::clicked;call super::clicked;String sSaupj,sBalDate

dw_cond.AcceptText()
sSaupj   = dw_cond.GetItemString(1,"saupj")
sBalDate = dw_cond.GetItemString(1,"baldate")
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return
END IF
IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_cond.SetColumn("baldate")
	dw_cond.SetFocus()
	Return
END IF
IF dw_list.Retrieve(sSaupj,sBalDate) <=0 THEN
	F_MessageChk(14,'')
	dw_cond.SetColumn("sdeptcode")
	dw_cond.SetFocus()
	Return
END IF

dw_list.SelectRow(0,False)
dw_list.SelectRow(1,True)
dw_list.ScrollToRow(1)

dw_method.Retrieve(dw_list.GetItemString(1,"gyel_date"),dw_list.GetItemNumber(1,"seqno"))
dw_bill_detail.Retrieve(dw_list.GetItemString(1,"gyel_date"),dw_list.GetItemNumber(1,"seqno"),'%')
end event

type p_del from w_inherite`p_del within w_kglc31
boolean visible = false
integer x = 3781
integer y = 2624
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc31
boolean visible = false
integer x = 3616
integer y = 2624
integer width = 169
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kglc31
boolean visible = false
integer x = 3703
integer y = 3276
end type

type cb_mod from w_inherite`cb_mod within w_kglc31
boolean visible = false
integer x = 2683
integer y = 3276
integer width = 640
string text = "전표발행(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_kglc31
boolean visible = false
integer x = 2382
integer y = 3012
string text = "추가&A)"
end type

type cb_del from w_inherite`cb_del within w_kglc31
boolean visible = false
integer x = 2720
integer y = 2896
end type

type cb_inq from w_inherite`cb_inq within w_kglc31
boolean visible = false
integer x = 2331
integer y = 3280
end type

type cb_print from w_inherite`cb_print within w_kglc31
boolean visible = false
integer x = 2496
integer y = 3248
end type

type st_1 from w_inherite`st_1 within w_kglc31
boolean visible = false
integer x = 142
integer y = 3240
end type

type cb_can from w_inherite`cb_can within w_kglc31
boolean visible = false
integer x = 3346
integer y = 3276
end type

type cb_search from w_inherite`cb_search within w_kglc31
boolean visible = false
integer x = 3072
integer y = 2896
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc31
boolean visible = false
integer x = 2912
integer y = 3236
end type

type sle_msg from w_inherite`sle_msg within w_kglc31
boolean visible = false
integer x = 494
integer y = 3240
integer width = 2418
end type

type gb_10 from w_inherite`gb_10 within w_kglc31
boolean visible = false
integer x = 123
integer y = 3188
integer width = 3547
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc31
boolean visible = false
integer x = 2807
integer y = 3028
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc31
boolean visible = false
integer x = 2615
integer y = 2660
integer width = 1417
end type

type rr_3 from roundrectangle within w_kglc31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2816
integer y = 376
integer width = 1573
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_kglc31
integer x = 3616
integer y = 224
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'I'									

Wf_Init()

end event

type rb_2 from radiobutton within w_kglc31
integer x = 4005
integer y = 224
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제"
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'M'									

Wf_Init()

end event

type dw_junpoy from datawindow within w_kglc31
integer x = 73
integer y = 2500
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_junpoylst from datawindow within w_kglc31
boolean visible = false
integer x = 73
integer y = 2640
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표처리할 결제내역 계정별 합"
string dataobject = "d_kifa107"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kglc31
boolean visible = false
integer x = 1312
integer y = 2804
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리결과 저장"
string dataobject = "d_kifa108"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_jbill from datawindow within w_kglc31
boolean visible = false
integer x = 73
integer y = 2740
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음 저장"
string dataobject = "d_kifa109"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_save from datawindow within w_kglc31
boolean visible = false
integer x = 73
integer y = 2848
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "결제내역조회"
string dataobject = "d_kifa105"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sungin from datawindow within w_kglc31
boolean visible = false
integer x = 1317
integer y = 2580
integer width = 1234
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_method2 from datawindow within w_kglc31
boolean visible = false
integer x = 2926
integer y = 2000
integer width = 87
integer height = 76
boolean bringtotop = true
string dataobject = "d_kglc214"
boolean border = false
boolean livescroll = true
end type

type dw_list from u_d_select_sort within w_kglc31
integer x = 78
integer y = 380
integer width = 2688
integer height = 1860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kglc212"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;
IF currentrow <=0 THEN Return

dw_method.Retrieve(this.GetItemString(currentrow,"gyel_date"),this.GetItemNumber(currentrow,"seqno"))
dw_method2.Retrieve(this.GetItemString(currentrow,"gyel_date"),this.GetItemNumber(currentrow,"seqno"))

dw_cond.SetItem(1,"pcfee", dw_method.GetItemNumber(1,"sendfee"))




end event

event clicked;
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
		
	dw_method.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
//	dw_method2.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
	
	dw_cond.SetItem(1,"pcfee", dw_method.GetItemNumber(1,"sendfee"))
END IF

CALL SUPER ::CLICKED
end event

event rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

type dw_bill_detail from datawindow within w_kglc31
boolean visible = false
integer x = 1317
integer y = 2696
integer width = 1234
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "어음결제내역 저장"
string dataobject = "d_kifa465"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_cond from u_key_enter within w_kglc31
event ue_key pbm_dwnkey
integer x = 55
integer width = 3401
integer height = 356
integer taborder = 20
string dataobject = "d_kglc211"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event getfocus;
this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String  sSaupj,sBalDate,sAcc1_cd,sAcc2_cd,sAccName,sDeptCode,sEmpNo,sEmpName,sSdeptCode,snull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "basedate" THEN
	sBaseDate = Trim(this.GetText())
	IF sBaseDate = "" OR IsNull(sBaseDate) THEN RETURN
	
	IF F_DateChk(sBaseDate) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(iCurRow,"basedate",snull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
	END IF
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
	END IF
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	IF IsNull(F_Get_PersonLst('3',sDeptCode,'1')) THEN
		F_MessageChk(20,'[결제부서]')
		this.SetItem(iCurRow,"deptcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "baldate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[결제일자]')
		this.SetItem(iCurRow,"baldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "empno" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(iCurRow,"empname",snull)
		Return
	END IF
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
		F_MessageChk(20,'[결제자]')
		this.SetItem(iCurRow,"empno",snull)
		this.SetItem(iCurRow,"empname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"empname",sEmpName)
	END IF
END IF

IF this.GetColumnName() = "sdeptcode" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(iCurRow,"sdeptcode",snull)
		Return 1
	END IF
END IF

end event

event rbuttondown;
this.AcceptText()
IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"acc1_cd"),1)
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
		
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="sawon" THEN
	SetNull(lstr_custom.code)
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon", lstr_custom.code)
	this.SetItem(this.GetRow(),"empname",lstr_custom.name)
	
END IF

end event

type rr_1 from roundrectangle within w_kglc31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3566
integer y = 196
integer width = 823
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kglc31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 372
integer width = 2715
integer height = 1888
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_method from u_key_enter within w_kglc31
event ue_key pbm_dwnkey
integer x = 2898
integer y = 468
integer width = 1403
integer height = 1196
integer taborder = 0
string dataobject = "d_kglc313"
boolean border = false
end type

type gb_2 from groupbox within w_kglc31
integer x = 2871
integer y = 400
integer width = 1477
integer height = 1800
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "결제 방법"
borderstyle borderstyle = stylelowered!
end type

