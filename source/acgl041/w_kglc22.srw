$PBExportHeader$w_kglc22.srw
$PBExportComments$지급결제 전표-반제안함
forward
global type w_kglc22 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc22
end type
type rb_1 from radiobutton within w_kglc22
end type
type rb_2 from radiobutton within w_kglc22
end type
type dw_list from u_key_enter within w_kglc22
end type
type dw_junpoy from datawindow within w_kglc22
end type
type dw_sang from datawindow within w_kglc22
end type
type dw_jbill from datawindow within w_kglc22
end type
type dw_sungin from datawindow within w_kglc22
end type
type dw_print from datawindow within w_kglc22
end type
type dw_bill_detail from datawindow within w_kglc22
end type
type dw_rbill from datawindow within w_kglc22
end type
type tab_gyel from tab within w_kglc22
end type
type tabpage_desc from userobject within tab_gyel
end type
type rr_3 from roundrectangle within tabpage_desc
end type
type dw_detail from u_key_enter within tabpage_desc
end type
type tabpage_desc from userobject within tab_gyel
rr_3 rr_3
dw_detail dw_detail
end type
type tabpage_method from userobject within tab_gyel
end type
type rr_4 from roundrectangle within tabpage_method
end type
type dw_method from u_key_enter within tabpage_method
end type
type dw_method2 from datawindow within tabpage_method
end type
type tabpage_method from userobject within tab_gyel
rr_4 rr_4
dw_method dw_method
dw_method2 dw_method2
end type
type tab_gyel from tab within w_kglc22
tabpage_desc tabpage_desc
tabpage_method tabpage_method
end type
type st_2 from statictext within w_kglc22
end type
type em_gyelamt from editmask within w_kglc22
end type
type st_3 from statictext within w_kglc22
end type
type em_descamt from editmask within w_kglc22
end type
type dw_kfm03om0 from datawindow within w_kglc22
end type
type dw_kfz12ote from datawindow within w_kglc22
end type
type rr_1 from roundrectangle within w_kglc22
end type
type rr_2 from roundrectangle within w_kglc22
end type
end forward

global type w_kglc22 from w_inherite
integer width = 4622
string title = "지급결제전표 발행/삭제 처리"
dw_cond dw_cond
rb_1 rb_1
rb_2 rb_2
dw_list dw_list
dw_junpoy dw_junpoy
dw_sang dw_sang
dw_jbill dw_jbill
dw_sungin dw_sungin
dw_print dw_print
dw_bill_detail dw_bill_detail
dw_rbill dw_rbill
tab_gyel tab_gyel
st_2 st_2
em_gyelamt em_gyelamt
st_3 st_3
em_descamt em_descamt
dw_kfm03om0 dw_kfm03om0
dw_kfz12ote dw_kfz12ote
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc22 w_kglc22

type variables
String    sBaseDate,LsAutoSungGbn, LsPayFeeGbn
Double  LdAryAmt[12]
String    LsAryAcc1[12],LsAryAcc2[12],LsAryChaDae[12],LsAryDescr[12]
String    LsSelectGbn


end variables

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_get_gyelseq (string sbaldate)
public subroutine wf_insert_sang (string gyeldate, long gyelseq, string saupj, string baldate, string upmugu, long bjunno, long linno, string acc1, string acc2, string sdept)
public function integer wf_dup_chk (string sbillno, string sbillgbn, string sflag)
public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public subroutine wf_display_gyelamt ()
public subroutine wf_calculation_gyel ()
public function double wf_calculation_ija ()
public function string wf_chaip_no (string sgisandate)
public function integer wf_insert_kfz12ote (string saupj, string baldate, string upmugu, long bjunno, integer linno, string sacc1, string sacc2)
public function integer wf_delete_kfz12ot0 (STRING SJUNNO)
public function integer wf_setting_acc ()
public function integer wf_save (string sbaldate, ref long lseqno, string sflag)
public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq)
public subroutine wf_init ()
public subroutine wf_bill_detail ()
end prototypes

public function integer wf_requiredchk ();Integer i
Double  dAmt,dBillAmt,dCheckAmt,dDepotAmt,dAccAmt,dPcAmt,dChaIpAmt,dIjaAmt,dChaIpRate
String  sSaupj,sFlag,sGyelDate,sDepotNo,sBillNo,sBalDate,sManDate,sBnkcd,sAcc1,sAcc2,&
		  sDept, sEmpno,sSaupDept,sCheckCode,&
		  sFromDate,sChaIpBank,sYakJungNo,sToDate,sIjaDptNo,sRacc

dw_cond.AcceptText()

sBaseDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")
sSaupj    = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sGyelDate = dw_cond.GetItemString(dw_cond.GetRow(),"baldate")
sDept     = dw_cond.GetItemString(dw_cond.GetRow(),"deptcode")
sEmpno    = dw_cond.GetItemString(dw_cond.GetRow(),"empno")
sSaupDept = dw_cond.GetItemString(dw_cond.GetRow(),"sdeptcode")
dPcAmt    = dw_cond.GetItemNumber(dw_cond.GetRow(),"pcfee")
IF IsNull(dPcAmt) THEN dPcAmt =0

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_cond.Setcolumn("basedate")
	dw_cond.SetFocus()
	Return -1
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.Setcolumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF

IF sDept = "" OR IsNull(sDept) THEN
	F_MessageChk(1,'[결제부서]')
	dw_cond.Setcolumn("deptcode")
	dw_cond.SetFocus()
	Return -1
END IF

IF sModStatus = 'I' AND sGyelDate = "" OR IsNull(sGyelDate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_cond.Setcolumn("baldate")
	dw_cond.SetFocus()
	Return -1
END IF

IF sEmpNo = "" OR IsNull(sEmpNo) THEN
	F_MessageChk(1,'[결제자]')
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

IF sModStatus = 'I' THEN									/*등록시*/
	FOR i = 1 TO tab_gyel.tabpage_desc.dw_detail.RowCount()
		sFlag = tab_gyel.tabpage_desc.dw_detail.GetItemString(i,"chkflag")
		dAmt  = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(i,"gyelamt")
		IF IsNull(dAmt) THEN dAmt =0
		
		IF sFlag = 'Y' THEN
			IF dAmt = 0 OR IsNull(dAmt) THEN
				F_MessageChk(1,'[반제금액]')
				tab_gyel.tabpage_desc.dw_detail.SetColumn("gyelamt")
				tab_gyel.tabpage_desc.dw_detail.ScrollToRow(i)
				tab_gyel.tabpage_desc.dw_detail.SetFocus()
				Return -1
			END IF
		END IF
	NEXT
END IF

tab_gyel.tabpage_method.dw_method.AcceptText()
dBillAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"billamt")
dCheckAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"checkamt")
dDepotAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"depotamt")
dAccAmt   = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt")

IF IsNull(dBillAmt)  THEN 
	tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt", 0)
	dBillAmt  = 0
END IF

IF IsNull(dCheckAmt) THEN 
	tab_gyel.tabpage_method.dw_method.SetItem(1,"checkamt", 0)
	dCheckAmt = 0
END IF

IF IsNull(dDepotAmt) THEN 
	tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt", 0)	
	dDepotAmt = 0
END IF

IF IsNull(dAccAmt)   THEN 
	tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt", 0)	
	dAccAmt   = 0
END IF

tab_gyel.tabpage_method.dw_method2.AcceptText()
dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
IF IsNull(dChaIpAmt) THEN 
	tab_gyel.tabpage_method.dw_method2.SetItem(1,"chaip_amt", 0)
	dChaIpAmt = 0
END IF

IF dDepotAmt <> 0 THEN											/*예적금액 입력시*/
	sDepotNo = tab_gyel.tabpage_method.dw_method.GetItemSTring(1,"depotno")
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN
		F_MessageChk(1,'[예적금코드]')
		tab_gyel.tabpage_method.dw_method.SetColumn("depotno")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
ELSE
	sDepotNo = tab_gyel.tabpage_method.dw_method.GetItemSTring(1,"depotno")
	
	IF dChaIpAmt <> 0 AND (sDepotNo = "" OR IsNull(sDepotNo)) THEN
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt", dChaIpAmt)
		
		F_MessageChk(1,'[예적금코드]')
		tab_gyel.tabpage_method.dw_method.SetColumn("depotno")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF

//IF dBillAmt <> 0 THEN											/*어음금액 입력시*/
//	sBillNo  = tab_gyel.tabpage_method.dw_method.GetItemString(1,"billno")
//	sBalDate = tab_gyel.tabpage_method.dw_method.GetItemString(1,"bbaldate") 
//	sManDate = tab_gyel.tabpage_method.dw_method.GetItemString(1,"bmandate") 
//	sBnkCd   = tab_gyel.tabpage_method.dw_method.GetItemString(1,"bank_cd") 
//	
//	IF sBillNo = "" OR IsNull(sBillNo) THEN
//		F_MessageChk(1,'[어음번호]')
//		tab_gyel.tabpage_method.dw_method.SetColumn("billno")
//		tab_gyel.tabpage_method.dw_method.SetFocus()
//		Return -1
//	END IF
//	IF sBalDate = "" OR IsNull(sBalDate) THEN
//		F_MessageChk(1,'[발행일자]')
//		tab_gyel.tabpage_method.dw_method.SetColumn("bbaldate")
//		tab_gyel.tabpage_method.dw_method.SetFocus()
//		Return -1
//	END IF
//	IF sManDate = "" OR IsNull(sManDate) THEN
//		F_MessageChk(1,'[만기일자]')
//		tab_gyel.tabpage_method.dw_method.SetColumn("bmandate")
//		tab_gyel.tabpage_method.dw_method.SetFocus()
//		Return -1
//	END IF
//	IF sBnkCd = "" OR IsNull(sBnkCd) THEN
//		F_MessageChk(1,'[지급은행]')
//		tab_gyel.tabpage_method.dw_method.SetColumn("bank_cd")
//		tab_gyel.tabpage_method.dw_method.SetFocus()
//		Return -1
//	END IF
//END IF

IF dCheckAmt <> 0 THEN											/*당좌금액 입력시*/
	sCheckCode = tab_gyel.tabpage_method.dw_method.GetItemString(1,"checkcode")
	IF sCheckCode = "" OR IsNull(sCheckCode) THEN
		F_MessageChk(1,'[예적금코드]')
		tab_gyel.tabpage_method.dw_method.SetColumn("checkcode")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF

IF dAccAmt <> 0 THEN												/*계정상계 입력시*/
	sAcc1 = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1")
	sAcc2 = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN
		F_MessageChk(1,'[계정과목]')
		tab_gyel.tabpage_method.dw_method.SetColumn("sacc1")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
	IF sAcc2 = "" OR IsNull(sAcc2) THEN
		F_MessageChk(1,'[계정과목]')
		tab_gyel.tabpage_method.dw_method.SetColumn("sacc2")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF

IF dChaIpAmt <> 0 THEN
	sChaIpBank = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_bnk")
	sYakJungNo = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"yakjung_no")
	sFromDate  = Trim(tab_gyel.tabpage_method.dw_method2.GetItemString(1,"gisan_date"))
	sToDate    = Trim(tab_gyel.tabpage_method.dw_method2.GetItemString(1,"mangi_date"))
	dChaIpRate = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_rate")

	dIjaAmt   = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"ija_amt")
	
	IF IsNull(dIjaAmt) THEN dIjaAmt = 0
	sIjaDptNo  = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"ija_guzoa")
	IF sYakJungNo = "" OR IsNull(sYakJungNo) THEN
		F_MessageChk(1,'[약정번호]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("yakjung_no")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	IF sChaIpBank = "" OR IsNull(sChaIpBank) THEN
		F_MessageChk(1,'[차입은행]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("chaip_bnk")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	IF sFromDate = "" OR IsNull(sFromDate) THEN
		F_MessageChk(1,'[기산일자]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("gisan_date")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	IF sToDate = "" OR IsNull(sToDate) THEN
		F_MessageChk(1,'[만기일자]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("mangi_date")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	IF sFromDate > sToDate THEN
		F_MessageChk(24,'[만기일자]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("mangi_date")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	IF dChaipRate = 0 OR IsNull(dChaipRate) THEN
		F_MessageChk(1,'[차입이율]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("chaip_rate")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
	
	IF dIjaAmt <> 0 AND (sIjaDptNo = '' OR IsNull(sIjaDptNo)) THEN
		F_MessageChk(1,'[이자지급계좌]')
		tab_gyel.tabpage_method.dw_method2.SetColumn("ija_guzoa")
		tab_gyel.tabpage_method.dw_method2.SetFocus()
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_get_gyelseq (string sbaldate);Long lMaxSeq

SELECT MAX("KFZ19OT3"."SEQNO") 	INTO :lMaxSeq  
	FROM "KFZ19OT3"  
   WHERE "KFZ19OT3"."GYEL_DATE" = :sBalDate   ;
IF SQLCA.SQLCODE <> 0 THEN
	lMaxSeq = 1
ELSE
	IF IsNull(lMaxSeq) THEN lMaxSeq = 0
	
	lMaxSeq = lMaxSeq + 1
END IF

Return lMaxSeq

end function

public subroutine wf_insert_sang (string gyeldate, long gyelseq, string saupj, string baldate, string upmugu, long bjunno, long linno, string acc1, string acc2, string sdept);//
//Integer iCount,iInsertRow,k
//
//dw_save.Reset()
//
//iCount = dw_save.Retrieve(gyeldate,gyelseq,acc1,acc2)
//IF iCount <=0 THEN Return
//
//FOR k = 1 TO iCount
//
//	iInsertRow = dw_sang.InsertRow(0)
//	
//	dw_sang.SetItem(iInsertRow,"saupj",    dw_save.GetItemString(k,"saupj"))
//	dw_sang.SetItem(iInsertRow,"acc_date", dw_save.GetItemString(k,"acc_date"))
//	dw_sang.SetItem(iInsertRow,"upmu_gu",  dw_save.GetItemString(k,"upmu_gu"))
//	dw_sang.SetItem(iInsertRow,"jun_no",   dw_save.GetItemNumber(k,"jun_no"))
//	dw_sang.SetItem(iInsertRow,"lin_no",   dw_save.GetItemNumber(k,"lin_no"))
//	dw_sang.SetItem(iInsertRow,"jbal_date",dw_save.GetItemString(k,"bal_date"))
//	dw_sang.SetItem(iInsertRow,"bjun_no",  dw_save.GetItemNumber(k,"bjun_no"))
//	
//	dw_sang.SetItem(iInsertRow,"saupj_s",  saupj)
//	dw_sang.SetItem(iInsertRow,"bal_date", baldate)
//	dw_sang.SetItem(iInsertRow,"upmu_gu_s",upmugu)
//	dw_sang.SetItem(iInsertRow,"bjun_no_s",bjunno)
//	dw_sang.SetItem(iInsertRow,"lin_no_s", linno)
//	dw_sang.SetItem(iInsertRow,"amt_s",    dw_save.GetItemNumber(k,"crossamt"))
//NEXT
//
end subroutine

public function integer wf_dup_chk (string sbillno, string sbillgbn, string sflag);String  sNull,sUseTag,sBnkCd,sOwner
Integer iDbCount

SetNull(snull)

/*수표.어음책*/
SELECT "KFM06OT0"."USE_GU","KFM06OT0"."CHECK_BNK"  INTO :sUseTag, :sBnkCd
  	FROM "KFM06OT0"  
  	WHERE "KFM06OT0"."CHECK_NO" = :sBillNo AND "KFM06OT0"."CHECK_GU" = :sBillGbn  ;
IF SQLCA.SQLCODE <> 0 THEN
	IF sflag = 'BILL' THEN
		F_MessageChk(20,'[어음번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"billno",snull)
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",snull)
	ELSE
		F_MessageChk(20,'[수표번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"checkno",snull)
	END IF
	Return -1
END IF

/*상태 <> '미사용'*/
IF sUseTag <> '0' THEN
	IF sflag = 'BILL' THEN
		F_MessageChk(10,'[어음번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"billno",snull)
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",snull)
	ELSE
		F_MessageChk(10,'[수표번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"checkno",snull)
	END IF
	Return -1
END IF

/*지급어음 마스타*/
IF sFlag = 'BILL' THEN
	SELECT COUNT("KFM01OT0"."BILL_NO")	INTO :iDbCount  
		FROM "KFM01OT0"  
		WHERE "KFM01OT0"."BILL_NO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"billno",snull)
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	/*전표의 지급어음(TEMP)*/
	SELECT COUNT("KFZ12OTC"."BILL_NO")	INTO :iDbCount  
		FROM "KFZ12OTC"  
		WHERE "KFZ12OTC"."BILL_NO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"billno",snull)
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	/*지급결재전표의 지급어음(kfz19ot4)*/
	SELECT COUNT("KFZ19OT4"."BILLNO")	INTO :iDbCount  
		FROM "KFZ19OT4"  
		WHERE "KFZ19OT4"."BILL_GBN" ='P' AND "KFZ19OT4"."BILLNO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"billno",snull)
		tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bank_cd",sBnkCd)
	
	/*발행인*/
	SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '80' )   ;
	tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bill_nm",sOwner)
	
	tab_gyel.tabpage_method.dw_method.SetItem(tab_gyel.tabpage_method.dw_method.GetRow(),"bbaldate",Lstr_PayGyel[1].Gyel_Date)
	
END IF
	
Return 1
end function

public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iFindRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGu+String(lJunNo,'0000')+String(lLinNo,'000')
					 
iFindRow = dw_rbill.InsertRow(0)
	
dw_rbill.SetItem(iFindRow,"saupj",			sSaupj)
dw_rbill.SetItem(iFindRow,"bal_date",		sBalDate)
dw_rbill.SetItem(iFindRow,"upmu_gu",		sUpmuGu)
dw_rbill.SetItem(iFindRow,"bjun_no",		lJunNo)
dw_rbill.SetItem(iFindRow,"lin_no",			lLinNo)
dw_rbill.SetItem(iFindRow,"full_junno",	sFullJunNo)

//dw_rbill.SetItem(iFindRow,"mbal_date",			sBalDate)
//dw_rbill.SetItem(iFindRow,"mupmu_gu",			sUpmuGu)
//dw_rbill.SetItem(iFindRow,"mjun_no",			lJunNo)
//dw_rbill.SetItem(iFindRow,"mlin_no",			lLinNo)
	
dw_rbill.SetItem(iFindRow,"bill_no",			dw_bill_detail.GetItemString(iRow,"billno"))
dw_rbill.SetItem(iFindRow,"saup_no",			dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"))
dw_rbill.SetItem(iFindRow,"bnk_cd",				dw_bill_detail.GetItemString(iRow,"bank_cd"))
dw_rbill.SetItem(iFindRow,"bbal_dat",			dw_bill_detail.GetItemString(iRow,"bbaldate"))
dw_rbill.SetItem(iFindRow,"bman_dat",			dw_bill_detail.GetItemString(iRow,"bmandate"))
dw_rbill.SetItem(iFindRow,"bill_amt",			dw_bill_detail.GetItemNumber(iRow,"billamt"))
dw_rbill.SetItem(iFindRow,"bill_nm",			dw_bill_detail.GetItemString(iRow,"bill_nm"))
//dw_rbill.SetItem(iFindRow,"bill_ris",			dw_bill_detail.GetItemString(iRow,"bill_ris"))
//dw_rbill.SetItem(iFindRow,"bill_gu",			dw_bill_detail.GetItemString(iRow,"bill_gu"))
//dw_rbill.SetItem(iFindRow,"bill_jigu",			dw_bill_detail.GetItemString(iRow,"bill_jigu"))
dw_rbill.SetItem(iFindRow,"status",				'5')
dw_rbill.SetItem(iFindRow,"bill_ntinc",		dw_bill_detail.GetItemString(iRow,"bill_change_place"))
dw_rbill.SetItem(iFindRow,"bill_change_date",dw_bill_detail.GetItemString(iRow,"bill_change_date"))

dw_rbill.SetItem(iFindRow,"remark1",			'어음 배서')
dw_rbill.SetItem(iFindRow,"owner_saupj",		sSaupj)

Return 1
end function

public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iFindRow
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
dw_jbill.SetItem(iFindRow,"saup_no",			dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"))
dw_jbill.SetItem(iFindRow,"bnk_cd",				dw_bill_detail.GetItemString(iRow,"bank_cd"))
dw_jbill.SetItem(iFindRow,"bbal_dat",			dw_bill_detail.GetItemString(iRow,"bbaldate"))
dw_jbill.SetItem(iFindRow,"bman_dat",			dw_bill_detail.GetItemString(iRow,"bmandate"))
dw_jbill.SetItem(iFindRow,"bill_amt",			dw_bill_detail.GetItemNumber(iRow,"billamt"))
dw_jbill.SetItem(iFindRow,"bill_nm",			dw_bill_detail.GetItemString(iRow,"bill_nm"))
dw_jbill.SetItem(iFindRow,"status",				'1')
//dw_jbill.SetItem(iFindRow,"remark1",			dw_junpoylst.GetItemString(1,"descr"))

dw_jbill.SetItem(iFindRow,"owner_saupj",		sSaupj)

Return 1
end function

public subroutine wf_display_gyelamt ();Double dDescAmt,dGyelAmt,dChaIpAmt,dAccAmt

tab_gyel.tabpage_method.dw_method2.AcceptText()
IF tab_gyel.tabpage_method.dw_method2.GetRow() <=0 THEN 
	dChaIpAmt = 0
ELSE
	dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
	IF IsNull(dChaIpAmt) THEN dChaIpAmt =0
END IF

tab_gyel.tabpage_method.dw_method.AcceptText()
IF tab_gyel.tabpage_method.dw_method.GetRow() <=0 THEN 
	dGyelAmt = 0
ELSE
	dGyelAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"gyelamt")
	dAccAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt")
	IF IsNull(dGyelAmt) THEN dGyelAmt =0
	IF IsNull(dAccAmt) THEN dAccAmt =0
END IF

IF sModStatus = 'I' THEN
	tab_gyel.tabpage_desc.dw_detail.AcceptText()
	IF tab_gyel.tabpage_desc.dw_detail.GetRow() <=0 THEN 
		dDescAmt = 0
	ELSE
		dDescAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(1,"sum_yamt")
		IF IsNull(dDescAmt) THEN dDescAmt = 0
	END IF
ELSE
	IF tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0) <=0 THEN
		dDescAmt = 0
	ELSE
		dDescAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0),"sangamt")
		IF IsNull(dDescAmt) THEN dDescAmt = 0	
	END IF
END IF
em_descamt.text = String(dDescAmt,'###,###,###,##0')
em_gyelamt.text = String(dGyelAmt,'###,###,###,##0')


end subroutine

public subroutine wf_calculation_gyel ();Double dDptAmt,dGyelAmt,dPayFee,dIjaAmt,dCashAmt,dAccAmt,dChaIpAmt,dSuIpAmt

IF tab_gyel.tabpage_desc.dw_detail.RowCount() > 0 THEN
	tab_gyel.tabpage_desc.dw_detail.AcceptText()
	IF smodstatus ='M' THEN
		IF tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0) <=0 THEN
			dGyelAmt = 0
		ELSE
			dGyelAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0),"sangamt")
		END IF
	ELSE
		dGyelAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(tab_gyel.tabpage_desc.dw_detail.GetRow(),"sum_yamt")
	END IF
	IF IsNull(dGyelAmt) THEN dGyelAmt = 0
ELSE
	dGyelAmt = 0
END IF

dw_cond.AcceptText()
dPayFee  = dw_cond.GetItemNumber(1,"pcfee")
IF IsNull(dPayFee) THEN dPayFee = 0

tab_gyel.tabpage_method.dw_method.AcceptText()
dCashAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(tab_gyel.tabpage_method.dw_method.GetRow(),"cashamt")
IF IsNull(dCashAmt) THEN dCashAmt = 0

dDptAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(tab_gyel.tabpage_method.dw_method.GetRow(),"depotamt")
IF IsNull(dDptAmt) THEN dDptAmt = 0

dAccAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(tab_gyel.tabpage_method.dw_method.GetRow(),"accamt")
IF IsNull(dAccAmt) THEN dAccAmt = 0

dSuIpAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(tab_gyel.tabpage_method.dw_method.GetRow(),"ijaamt")
IF IsNull(dSuIpAmt) THEN dSuIpAmt = 0

tab_gyel.tabpage_method.dw_method2.AcceptText()
dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(tab_gyel.tabpage_method.dw_method2.GetRow(),"chaip_amt")
IF IsNull(dChaIpAmt) THEN dChaIpAmt = 0
dIjaAmt   = tab_gyel.tabpage_method.dw_method2.GetItemNumber(tab_gyel.tabpage_method.dw_method2.GetRow(),"ija_amt")
IF IsNull(dIjaAmt) THEN dIjaAmt = 0

IF dChaIpAmt <> 0 THEN
	tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt", dChaIpAmt - dCashAmt + dPayFee)
END IF

//IF (dChaIpAmt <> 0 OR dIjaAmt <> 0) AND dDptAmt <> 0 THEN
//	IF LsPayFeeGbn = '1' THEN					/*예금에서 수수료 제외*/
//		dSumAmt_Cha = dGyelAmt + dPayFee + dIjaAmt + (dDptAmt - dIjaAmt - dPayFee)	
//	ELSE
//		dSumAmt_Cha = dGyelAmt + dPayFee + dIjaAmt + (dDptAmt - dIjaAmt)	
//	END IF
//ELSE
//	dSumAmt_Cha = dGyelAmt + dPayFee + dIjaAmt 
//END IF
//IF IsNull(dSumAmt_Cha) THEN dSumAmt_Cha =0
//
//IF dChaIpAmt <> 0 THEN
//	dSumAmt_Dae = dCashAmt + dDptAmt + dAccAmt + dSuIpAmt + dChaIpAmt
//ELSE
//	dSumAmt_Dae = dCashAmt + dDptAmt + dAccAmt + dSuIpAmt + dChaIpAmt + dPayFee
//END IF
//IF IsNull(dSumAmt_Dae) THEN dSumAmt_Dae =0

//em_cha.text = String(dSumAmt_Cha,"###,###,###,##0")
//em_dae.text = String(dSumAmt_Dae,"###,###,###,##0")

end subroutine

public function double wf_calculation_ija ();Double  dChaIpAmt,dIjaAmt,dLoRate
String  sFrom,sTo
Integer iDays

IF tab_gyel.tabpage_method.dw_method2.AcceptText() = -1 THEN Return 0

dLoRate   = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_rate")
IF IsNull(dLoRate) OR dLoRate = 0 THEN Return 0

dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
IF IsNull(dChaIpAmt) OR dChaIpAmt = 0 THEN Return 0
	
sFrom = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"gisan_date")
IF sFrom = "" OR IsNull(sFrom) THEN Return 0

sTo   = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"mangi_date")
IF sTo = "" OR IsNull(sTo) THEN Return 0
	
iDays = DaysAfter(Date(Left(sFrom,4)+'.'+Mid(sFrom,5,2)+'.'+Right(sFrom,2)),Date(Left(sTo,4)+'.'+Mid(sTo,5,2)+'.'+Right(sTo,2))) + 1

dIjaAmt = Round(dChaIpAmt * (iDays / 365) * (dLoRate / 100) ,2)

Return dIjaAmt
end function

public function string wf_chaip_no (string sgisandate);String   sChaipNo
Integer  iMaxNo

SELECT MAX(TO_NUMBER(SUBSTR(A.LOCD,5,3)))
	INTO :iMaxNo  
	FROM(SELECT "KFM03OT0"."LO_CD" AS LOCD
		   FROM "KFM03OT0"  
   		WHERE SUBSTR("KFM03OT0"."LO_AFDT",1,4) = SUBSTR(:sGisanDate,1,4) 
		  UNION ALL
		  SELECT "KFZ12OTE"."LO_CD" AS LOCD
		   FROM "KFZ12OTE"  
   		WHERE SUBSTR("KFZ12OTE"."LO_AFDT",1,4) = SUBSTR(:sGisanDate,1,4) 
		  UNION ALL
		  SELECT "KFZ19OT5"."CHAIP_NO" AS LOCD
		   FROM "KFZ19OT5"  
   		WHERE SUBSTR("KFZ19OT5"."GISAN_DATE",1,4) = SUBSTR(:sGisanDate,1,4) ) A;
			
IF SQLCA.SQLCODE <> 0 THEN
	iMaxNo = 0
ELSE
	IF IsNull(iMaxNo) THEN iMaxNo = 0
END IF

iMaxNo = iMaxNo + 1

sChaipNo = sGisanDate + String(iMaxNo,'000')

Return sChaipNo
end function

public function integer wf_insert_kfz12ote (string saupj, string baldate, string upmugu, long bjunno, integer linno, string sacc1, string sacc2);dw_kfz12ote.InsertRow(0)
			
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_cd",      tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_no"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_name",    &
							'구매결제 차입 -'+tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_no"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_bnkno",   tab_gyel.tabpage_method.dw_method2.GetItemString(1,"yakjung_no"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"acc1_cd",    sacc1)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"acc2_cd",    sacc2)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_bnkcd",   tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_bnk"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_afdt",    tab_gyel.tabpage_method.dw_method2.GetItemString(1,"gisan_date"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_atdt",    tab_gyel.tabpage_method.dw_method2.GetItemString(1,"mangi_date"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_rat",     tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_rate"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_camt",    tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_aday",    Right(BALDATE,2))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_curr",    'WON')
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_sgbn",    '1')

dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"saupj",      SAUPJ)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"bal_date",   BALDATE)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"upmu_gu",    UPMUGU)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"bjun_no",    BJUNNO)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lin_no",     LINNO)

Return 1
end function

public function integer wf_delete_kfz12ot0 (STRING SJUNNO);Integer iRowCount,k
String  sSaupj, sBalDate,sUpmuGbn
Long    lJunNo

dw_junpoy.Reset()
dw_sang.Reset()

SetPointer(HourGlass!)

sSaupj   = Left(sJunNo,2)
sBalDate = Mid(sJunNo,3,8)
sUpmuGbn = Mid(sJunNo,11,1)
lJunNo   = Long(Right(sJunNo,4))

iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGbn,lJunNo)
IF iRowCount <=0 THEN Return 1

FOR k= iRowCount TO 1 STEP -1							/*전표 삭제*/
	dw_junpoy.DeleteRow(k)		
NEXT

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(12,'[미승인전표]')
	Return -1
END IF

DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
	WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
			( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
			( "KFZ12OT1"."UPMU_GU"  = :sUpmuGbn ) AND  
			( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
DELETE FROM "KFZ12OT3"  										/*전표송부내역 삭제*/
	WHERE ( "KFZ12OT3"."SAUPJ"    = :sSaupj ) AND  
			( "KFZ12OT3"."BAL_DATE" = :sBalDate ) AND  
			( "KFZ12OT3"."UPMU_GU"  = :sUpmuGbn ) AND  
			( "KFZ12OT3"."JUN_NO"   = :lJunNo )   ;
					
Return 1


end function

public function integer wf_setting_acc ();Double    dCashAmt,dDepotAmt,dAccAmt,dSuIpIjaAmt,dPcAmt,dCheckAmt,dBillCashAmt,dBillAmt,dChaIpIjaAmt,dChaIpAmt,dPayDptAmt
String    sDepotNo,sSaupj
Integer   k

FOR k= 1 TO 12
	LsAryAcc1[k] = '';	LsAryAcc2[k] = '';	LsAryChaDae[k] ='';	LdAryAmt[k] =0;
NEXT

dw_cond.AcceptText()
tab_gyel.tabpage_method.dw_method.AcceptText()

sSaupj = dw_cond.GetItemString(1,"saupj")

dPcAmt = dw_cond.GetItemNumber(1,"pcfee")
IF IsNull(dPcAmt) THEN dPcAmt = 0

/*결제 계정코드 가져오기*/
dCashAmt    = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"cashamt")
dDepotAmt   = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"depotamt")
dCheckAmt   = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"checkamt")

dAccAmt     = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt")
dSuIpIjaAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"ijaamt")
dBillAmt		= tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"billamt")
dBillCashAmt= tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"bill_cashamt")

dChaIpAmt   = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
dChaIpIjaAmt= tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"ija_amt")

IF IsNull(dCashAmt)  THEN dCashAmt  = 0
IF IsNull(dDepotAmt) THEN dDepotAmt = 0
IF IsNull(dCheckAmt) THEN dCheckAmt = 0

IF IsNull(dAccAmt)   THEN dAccAmt   = 0
IF IsNull(dSuIpIjaAmt)   THEN dSuIpIjaAmt   = 0
IF IsNull(dBillAmt) THEN dBillAmt = 0
IF IsNull(dBillCashAmt) THEN dBillCashAmt = 0

IF IsNull(dChaIpAmt)    THEN dChaIpAmt  = 0
IF IsNull(dChaIpIjaAmt) THEN dChaIpIjaAmt = 0

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
	sDepotNo    = tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno")
	
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

IF dPcAmt <> 0 THEN															/*PC뱅킹수수료*/
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)  
		INTO :LsAryAcc1[4],						  :LsAryAcc2[4]  
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			  ( "SYSCNFG"."LINENO" = '35' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[4] = '00000'; 		LsAryAcc2[4] = '00';
		F_MessageChk(25,'[수수료계정(A-1-35)]')
		Return -1
	END IF
	LsAryChaDae[4] = '1';		LsAryDescr[4] = '송금 수수료';
	LdAryAmt[4] = dPcAmt
ELSE
	LsAryAcc1[4] = '9'; LsAryAcc2[4] = '9';	
	LdAryAmt[4]  = dPcAmt
END IF

IF dBillAmt <> 0 THEN
	IF dw_bill_detail.GetItemNumber(1,"paycnt") > 0 THEN				/*지급어음*/
		SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)  
			INTO :LsAryAcc1[5],						  :LsAryAcc2[5]  
			FROM "SYSCNFG"  
			WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				  ( "SYSCNFG"."LINENO" = '24' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			LsAryAcc1[5] = '00000'; 		LsAryAcc2[5] = '00';
			F_MessageChk(25,'[지급어음계정(A-1-24)]')
			Return -1
		END IF
		LsAryChaDae[5] = '2';		LsAryDescr[5] = '지급어음 발행';
		LdAryAmt[5] = 0
	ELSE
		LsAryAcc1[5] = '9'; LsAryAcc2[5] = '9';	
		LdAryAmt[5]  = 0
	END IF
	
	IF dw_bill_detail.GetItemNumber(1,"rcvcnt") > 0 THEN				/*받을어음*/
		SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2)						/*받을어음*/
			INTO :LsAryAcc1[6],				:LsAryAcc2[6]  
			FROM "SYSCNFG"  
			WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND  ( "LINENO" = '23' )  ;
		IF SQLCA.SQLCODE <> 0 THEN
			LsAryAcc1[6] = '00000'; 		LsAryAcc2[6] = '00';
			F_MessageChk(25,'[받을어음계정(계정마스타의 소속사업장)]')
			Return -1
		END IF
		LsAryChaDae[6] = '2';		LsAryDescr[6] = '받을어음 배서';
		LdAryAmt[6] = 0
	ELSE
		LsAryAcc1[6] = '9'; LsAryAcc2[6] = '9';	
		LdAryAmt[6]  = 0
	END IF
END IF

IF dAccAmt <> 0 THEN											/*계정*/
	LsAryAcc1[7] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1")
	LsAryAcc2[7] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2")
	
	IF LsAryAcc1[7] = "" OR IsNull(LsAryAcc1[7]) THEN LsAryAcc1[7] = '00000'
	IF LsAryAcc2[7] = "" OR IsNull(LsAryAcc2[7]) THEN LsAryAcc2[7] = '00'
	
	LsAryChaDae[7] = '2';		LsAryDescr[7] = '계정상계로 지급';
	LdAryAmt[7] = dAccAmt
ELSE
	LsAryAcc1[7] = '9'; LsAryAcc2[7] = '9';	
	LdAryAmt[7]  = dAccAmt
END IF

IF dSuIpIjaAmt <> 0 THEN											/*수입이자*/
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)  
   	INTO :LsAryAcc1[8],						 :LsAryAcc2[8]  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '61' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[8] = '00000'; LsAryAcc2[8] = '00';
		F_MessageChk(25,'[수입이자계정(A-1-61)]')
		Return -1		
	END IF
	LsAryChaDae[8] = '2';		LsAryDescr[8] = '수입이자';
	LdAryAmt[8] = dSuIpIjaAmt
ELSE
	LsAryAcc1[8] = '9'; LsAryAcc2[8] = '9';	
	LdAryAmt[8]  = dSuIpIjaAmt
END IF

IF dChaipIjaAmt <> 0 AND dDepotAmt <> 0 THEN						/*차입금을 예금으로 입금*/
	IF dDepotAmt = dChaIpAmt THEN
		dPayDptAmt = dDepotAmt - dChaIpIjaAmt
	ELSE
//		dPayDptAmt = dDepotAmt - dChaIpIjaAmt - dPcAmt
		dPayDptAmt = dDepotAmt - dChaIpIjaAmt
	END IF
	
	IF dPayDptAmt <> 0 THEN
		sDepotNo    = tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno")
	
		SELECT "KFM04OT0"."ACC1_CD",            "KFM04OT0"."ACC2_CD"  
			INTO :LsAryAcc1[9],						 :LsAryAcc2[9]  
			FROM "KFM04OT0"  
			WHERE "KFM04OT0"."AB_DPNO" = :sDepotNo  ;
		IF SQLCA.SQLCODE <> 0 THEN
			LsAryAcc1[9] = '00000'; LsAryAcc2[9] = '00';
		END IF
		
		LsAryChaDae[9] = '1';		LsAryDescr[9] = '차입잔액을 예금으로 입금';
		LdAryAmt[9] = dPayDptAmt
	ELSE
		LsAryAcc1[9] = '9'; LsAryAcc2[1] = '9';
		LdAryAmt[9] = 0;
	END IF
ELSE
	LsAryAcc1[9] = '9'; LsAryAcc2[9] = '9';	
	LdAryAmt[9] = 0;
END IF

IF dChaIpIjaAmt <> 0 THEN															/*차입이자*/
	select substr(b.dataname,1,5),			substr(b.dataname,6,2)
		into :LsAryAcc1[10], 					:LsAryAcc2[10]
		from syscnfg b
		where b.sysgu = 'A' and b.serial = 17 and b.lineno = '02';
		
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[10] = '00000'; LsAryAcc2[10] = '00';
	END IF
		
	LsAryChaDae[10] = '1';		LsAryDescr[10] = '차입이자';
	LdAryAmt[10] = dChaIpIjaAmt
ELSE
	LsAryAcc1[10] = '9'; LsAryAcc2[10] = '9';	
	LdAryAmt[10] = 0;
END IF

IF dChaIpAmt <> 0 THEN									/*차입금*/
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)  
   	INTO :LsAryAcc1[11],						 :LsAryAcc2[11]  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 17 ) AND  
         ( "SYSCNFG"."LINENO" = '01' ) ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[11] = '00000'; LsAryAcc2[11] = '00';
	END IF
	LsAryChaDae[11] = '2';		LsAryDescr[11] = '구매 결제 차입';
	LdAryAmt[11] = dChaIpAmt
ELSE
	LsAryAcc1[11] = '9'; LsAryAcc2[11] = '9';	
	LdAryAmt[11]  = dChaIpAmt	
END IF

IF dCheckAmt <> 0 THEN										/*당좌예금*/
	sDepotNo    = tab_gyel.tabpage_method.dw_method.GetItemString(1,"checkcode")
	
	SELECT "KFM04OT0"."ACC1_CD",            "KFM04OT0"."ACC2_CD"  
		INTO :LsAryAcc1[12],						 :LsAryAcc2[12]  
	   FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sDepotNo  ;
	IF SQLCA.SQLCODE <> 0 THEN
		LsAryAcc1[12] = '00000'; LsAryAcc2[12] = '00';
		F_MessageChk(25,'[예금계정(예적금코드의 계정)]')
		Return -1
	END IF
	LsAryChaDae[12] = '2';		LsAryDescr[12] = '당좌예금으로 지급';
	LdAryAmt[12] = dCheckAmt
ELSE
	LsAryAcc1[12] = '9'; LsAryAcc2[12] = '9';	
	LdAryAmt[12] = 0;
END IF


Return 1

end function

public function integer wf_save (string sbaldate, ref long lseqno, string sflag);Integer k
String  sLoNo
Double  dRemain,dChaIpAmt

IF sFlag = '1' THEN									/*어음내역 저장*/
	IF lSeqNo = 0 THEN
		lSeqNo = Wf_Get_GyelSeq(sBalDate)
		IF lSeqNo = 0 OR IsNull(lSeqNo) THEN
			F_MessageChk(48,'')
			Return -2
		END IF
	
		tab_gyel.tabpage_method.dw_method.SetItem(1,"gyel_date", sBalDate)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"seqno",     lSeqNo)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sendfee",	dw_cond.GetItemNumber(1,"pcfee"))
		
		FOR k = 1 TO dw_bill_detail.RowCount()	
			dw_bill_detail.SetItem(k,"gyel_date", sBalDate)
			dw_bill_detail.SetItem(k,"seqno",     lSeqNo)
		NEXT
		
		tab_gyel.tabpage_method.dw_method2.SetItem(1,"gyel_date", sBalDate)
		tab_gyel.tabpage_method.dw_method2.SetItem(1,"seqno",     lSeqNo)
		
		dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
		IF IsNull(dChaIpAmt) THEN dChaIpAmt = 0
		
		IF dChaIpAmt <> 0 THEN
			/*차입번호의 자동 채번*/
			tab_gyel.tabpage_method.dw_method2.SetItem(1,"chaip_no", Wf_Chaip_No(tab_gyel.tabpage_method.dw_method2.GetItemString(1,"gisan_date")))
		
			/*약정마스타 갱신*/
			sLoNo = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"yakjung_no")
			IF sLoNo <> "" AND Not IsNull(sLoNo) THEN 
				IF dw_kfm03om0.Retrieve(sLoNo) = 1 THEN
					dRemain = dw_kfm03om0.GetItemNumber(1,"lo_hamt")
					IF IsNull(dRemain) THEN dRemain = 0
					
					dw_kfm03om0.SetItem(1,"lo_hamt", dRemain - dChaIpAmt)
				END IF
			END IF
		END IF
	END IF
	IF dw_bill_detail.Update() <> 1 THEN
		F_MessageChk(13,'[지급결제(어음)]')
		Return -1
	END IF
ELSE
	IF tab_gyel.tabpage_method.dw_method.Update() <> 1 THEN
		F_MessageChk(13,'[지급결제]')
		Return -1
	END IF
	
	IF tab_gyel.tabpage_method.dw_method2.Update() <> 1 THEN
		F_MessageChk(13,'[지급결제-차입]')
		Return -1
	END IF
	
	IF dw_kfm03om0.Update() <> 1 THEN
		F_MessageChk(13,'[약정마스타]')
		Return -1
	END IF
	IF dw_bill_detail.Update() <> 1 THEN
		F_MessageChk(13,'[지급결제(어음)]')
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq);Integer k,iCurRow,i,iBillCnt,iInsRow,iRtnValue
Long    lJunpoyNo
String  sSaupj,sUpmuGbn = 'A',sChaDae,sSangGbn,sCusGbn,sYesanGbn,sRemark1,sGbn1,sGbn4,sChGbn,sDepotNo

dw_junpoy.Reset()
dw_sang.Reset()
dw_jbill.Reset()
dw_rbill.Reset()
dw_kfz12ote.Reset()
dw_sungin.Reset()

dw_cond.AcceptText()
tab_gyel.tabpage_method.dw_method.AcceptText()

sSaupj = dw_cond.GetItemString(1,"saupj")

IF Wf_Setting_Acc() = -1 THEN Return -1

IF F_Check_LimitDate(sgyeldate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
		
lJunPoyNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sgyeldate)

SetPointer(HourGlass!)

FOR k = 1 TO 12
	IF LsAryAcc1[k] = '9' AND LsAryAcc2[k] = '9' THEN Continue			/*금액이 없으면 SKIP*/

	IF k = 1 THEN										/*지급결제 대상 자료 처리*/
		FOR i = 1 TO tab_gyel.tabpage_desc.dw_detail.RowCount()						
			if tab_gyel.tabpage_desc.dw_detail.GetItemString(i,"chkflag") <> 'Y'then Continue
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sGyelDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_cond.GetItemString(1,"deptcode"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", tab_gyel.tabpage_desc.dw_detail.GetItemString(i,"acc1_cd"))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", tab_gyel.tabpage_desc.dw_detail.GetItemString(i,"acc2_cd"))
			dw_junpoy.SetItem(iCurRow,"sawon",   dw_cond.GetItemString(1,"empno"))
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  LsAryChaDae[k])
			
			dw_junpoy.SetItem(iCurRow,"amt",     tab_gyel.tabpage_desc.dw_detail.GetItemNumber(i,"amount"))
			dw_junpoy.SetItem(iCurRow,"descr",   tab_gyel.tabpage_desc.dw_detail.GetItemString(i,"descr"))
			
//			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdept_cd"))
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no")) 
			dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"),'1')) 

			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		NEXT
	ELSEIF k = 5 THEN												/*지급어음*/
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
		
		iBillCnt = dw_bill_detail.Retrieve(tab_gyel.tabpage_method.dw_method.GetItemString(1,"gyel_date"),tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"seqno"),'P')	
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
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"),'1'))
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
	ELSEIF k = 6 THEN												/*받을어음*/
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
		dw_rbill.Retrieve(sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,1)
		
		iBillCnt = dw_bill_detail.Retrieve(tab_gyel.tabpage_method.dw_method.GetItemString(1,"gyel_date"),tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"seqno"),'R')	
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
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
												F_Get_PersonLst('1',dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"),'1'))
			END IF		

			IF Wf_Insert_Kfz12otd(i,sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow) = 1 THEN
				dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y')

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
	ELSEIF k = 11 THEN												/*차입금*/
		SELECT "SANG_GU",		"CUS_GU", 	"YESAN_GU",		"DC_GU",		"REMARK1",
				 "GBN1",			"GBN4",		"CH_GU"
			INTO :sSangGbn, 	:sCusGbn,	:sYesanGbn,		:sChaDae,	:sRemark1,
				  :sGbn1,		:sGbn4,		:sChGbn
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
			IF sGbn1 = '2' THEN												/*은행*/
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_bnk")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
													F_Get_PersonLst('2',tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_bnk"),'1')) 
			ELSEIF sGbn1 = '5' THEN												/*예적금*/
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('5',tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno"),'1')) 
			ELSEIF sGbn1 = '6' THEN												/*차입금*/
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method2.GetItemString(1,"chaip_no")) 
			ELSE
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('1',dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"),'1'))
			END IF
		END IF				
		IF sChGbn = 'Y' THEN
			Wf_Insert_Kfz12ote(sSaupj,sGyelDate,sUpmuGbn,lJunPoyNo,iCurRow,LsAryAcc1[k],LsAryAcc2[k])
			dw_junpoy.SetItem(iCurRow,"chaip_gu", 'Y') 
		END IF
				
		IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
		END IF
		
		IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",   dw_cond.GetItemString(1,"deptcode")) 
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
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
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('5',tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno"),'1')) 
			ELSE
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('1',dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"),'1'))
			END IF
		END IF				
		
		IF sGbn4 = 'Y' THEN						/*선급비용 처리*/
			dw_junpoy.SetItem(iCurRow,"k_symd",   tab_gyel.tabpage_method.dw_method2.GetItemString(1,"gisan_date"))
			dw_junpoy.SetItem(iCurRow,"k_eymd",   tab_gyel.tabpage_method.dw_method2.GetItemString(1,"mangi_date"))
			dw_junpoy.SetItem(iCurRow,"k_amt",    LdAryAmt[2])
			dw_junpoy.SetItem(iCurRow,"kwan_no",  tab_gyel.tabpage_method.dw_method2.GetItemString(1,"racccode"))
		END IF
		
		IF sSangGbn = 'Y' AND LsAryChaDae[k] <> sChaDae THEN				/*반제 처리 계정*/									
			lstr_jpra.saupjang = sSaupj
			lstr_jpra.baldate  = sGyelDate
			lstr_jpra.upmugu   = sUpmuGbn
			lstr_jpra.bjunno   = lJunPoyNo
			lstr_jpra.sortno   = iCurRow
			lstr_jpra.saupno   = tab_gyel.tabpage_desc.dw_detail.GetItemString(1,"saup_no")
			lstr_jpra.acc1     = LsAryAcc1[k]
			lstr_jpra.acc2     = LsAryAcc2[k]
			lstr_jpra.money    = LdAryAmt[k]
				
			OpenWithParm(W_kglb01g,'')
			IF Message.StringParm = '0' THEN		/*반제처리 안함*/
				F_MessageChk(17,'[반제 처리]')
				Return -1
			END IF			
		END IF

		IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
		END IF
		
		IF (sYesanGbn = 'Y' OR sYesanGbn = 'A') AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",   dw_cond.GetItemString(1,"deptcode")) 
		END IF
		
		if k = 12 then
			dw_junpoy.SetItem(iCurRow,"kwan_no",   tab_gyel.tabpage_method.dw_method.GetItemString(1,"checkno")) 
		end if
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	END IF
NEXT
SetPointer(Arrow!)

IF dw_rbill.Update() <> 1 THEN
	F_MessageChk(13,'[받을어음]')
	Return -1	
END IF
IF dw_jbill.Update() <> 1 THEN
	F_MessageChk(13,'[지급어음]')
	Return -1	
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	Return -1
ELSE
	tab_gyel.tabpage_method.dw_method.SetItem(1,"accjunno", sSaupj+sGyelDate+sUpmuGbn+String(lJunPoyNo,'0000'))
	
	dw_bill_detail.Retrieve(sgyeldate,lgyelseq,'%')
	FOR k = 1 TO dw_bill_detail.RowCount()	
		dw_bill_detail.SetItem(k,"accjunno", sSaupj+sGyelDate+sUpmuGbn+String(lJunPoyNo,'0000'))
	NEXT	
	tab_gyel.tabpage_method.dw_method2.SetItem(1,"accjunno", sSaupj+sGyelDate+sUpmuGbn+String(lJunPoyNo,'0000'))
	
	iRtnValue = Wf_Save(sGyelDate,lgyelseq,'2')
	IF iRtnValue = -1 THEN
		Rollback;	
		SetPointer(Arrow!)
		Return -1
	ELSEIF iRtnValue = -2 THEN
		SetPointer(Arrow!)
		Return -1
	END IF
END IF

MessageBox("확 인","발생된 미결전표번호 :"+String(sGyelDate,'@@@@.@@.@@')+'-'+String(lJunPoyNo,'0000'))
						 
Return 1
end function

public subroutine wf_init (); String snull,sCurDate,sSdept

SetNull(snull)

tab_gyel.tabpage_method.dw_method.Enabled  = True
tab_gyel.tabpage_method.dw_method2.Enabled = True

IF dw_cond.GetRow() <=0 THEN
	SetNull(sCurDate)
ELSE
	sCurDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")
END IF
dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.Modify("pcfee.protect = 0")
		
IF sCurDate = "" OR IsNull(sCurDate) THEN
	dw_cond.SetItem(dw_cond.GetRow(),"basedate",f_Today())
ELSE
	dw_cond.SetItem(dw_cond.GetRow(),"basedate",sCurDate)	
END IF

dw_cond.SetItem(dw_cond.GetRow(),"saupj",   gs_saupj)
dw_cond.SetItem(dw_cond.GetRow(),"baldate", f_Today())
dw_cond.SetItem(dw_cond.GetRow(),"deptcode",gs_dept)
dw_cond.SetItem(dw_cond.GetRow(),"empno",   gs_empno)
dw_cond.SetItem(dw_cond.GetRow(),"empname", F_Get_PersonLst('4',Gs_EmpNo,'1'))

SELECT "VW_CDEPT_CODE"."COST_CD"      INTO :sSdept  
	FROM "VW_CDEPT_CODE"  
   WHERE "VW_CDEPT_CODE"."DEPT_CD" = :Gs_Dept ;
dw_cond.SetItem(dw_cond.GetRow(),"sdeptcode",sSdept)	

dw_cond.SetRedraw(True)

dw_cond.SetColumn("acc1_cd")
dw_cond.SetFocus()

dw_list.Reset()
tab_gyel.tabpage_desc.dw_detail.Reset()
dw_bill_detail.Reset()

dw_list.SetRedraw(False)
tab_gyel.tabpage_desc.dw_detail.SetRedraw(False)

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
tab_gyel.tabpage_method.dw_method2.Reset()
tab_gyel.tabpage_method.dw_method2.InsertRow(0)
tab_gyel.tabpage_method.dw_method2.SetRedraw(True)

IF sModStatus = 'I' THEN					/*등록*/
	
	dw_cond.Modify("baldate.protect = 0")
	
	dw_list.DataObject = 'd_kglc222'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	tab_gyel.tabpage_desc.dw_detail.DataObject = 'd_kglc223'
	tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
	tab_gyel.tabpage_desc.dw_detail.Reset()
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	dw_cond.Modify("t_1.text = '기준일자'")
ELSE
	
	dw_cond.SetItem(dw_cond.GetRow(),"baldate", snull)
	
	dw_cond.Modify("baldate.protect = 1")
	
	dw_list.DataObject = 'd_kglc2220'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	tab_gyel.tabpage_desc.dw_detail.DataObject = 'd_kglc2230'
	tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
	tab_gyel.tabpage_desc.dw_detail.Reset()
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
	dw_cond.Modify("t_1.text = '결제일자'")
END IF

dw_list.SetRedraw(True)
tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)

tab_gyel.tabpage_desc.dw_detail.SelectRow(0,False)

tab_gyel.SelectedTab = 1

//Lstr_PayGyel[1].AryCnt = 0

		
end subroutine

public subroutine wf_bill_detail ();Integer k

IF dw_bill_detail.RowCount() > 0 THEN
	FOR k = 1 TO dw_bill_detail.RowCount()
		Lstr_PayGyel[k].bill_gbn = dw_bill_detail.GetItemString(k,"bill_gbn")			
		Lstr_PayGyel[k].billno   = dw_bill_detail.GetItemString(k,"billno")			
		Lstr_PayGyel[k].bbaldate = dw_bill_detail.GetItemString(k,"bbaldate")			
		Lstr_PayGyel[k].bmandate = dw_bill_detail.GetItemString(k,"bmandate")				
		Lstr_PayGyel[k].bank_cd  = dw_bill_detail.GetItemString(k,"bank_cd")			
		Lstr_PayGyel[k].bill_nm  = dw_bill_detail.GetItemString(k,"bill_nm")			
		Lstr_PayGyel[k].billamt  = dw_bill_detail.GetItemNumber(k,"billamt")
		
//		Lstr_PayGyel[k].gyel_date= dw_bill_detail.GetItemString(k,"gyel_date")
//		Lstr_PayGyel[k].seqno    = dw_bill_detail.GetItemNumber(k,"seqno")
	NEXT
	
	Lstr_PayGyel[1].AryCnt = k - 1
ELSE
	Lstr_PayGyel[1].AryCnt = 0
END IF

end subroutine

on w_kglc22.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_list=create dw_list
this.dw_junpoy=create dw_junpoy
this.dw_sang=create dw_sang
this.dw_jbill=create dw_jbill
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_bill_detail=create dw_bill_detail
this.dw_rbill=create dw_rbill
this.tab_gyel=create tab_gyel
this.st_2=create st_2
this.em_gyelamt=create em_gyelamt
this.st_3=create st_3
this.em_descamt=create em_descamt
this.dw_kfm03om0=create dw_kfm03om0
this.dw_kfz12ote=create dw_kfz12ote
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sang
this.Control[iCurrent+7]=this.dw_jbill
this.Control[iCurrent+8]=this.dw_sungin
this.Control[iCurrent+9]=this.dw_print
this.Control[iCurrent+10]=this.dw_bill_detail
this.Control[iCurrent+11]=this.dw_rbill
this.Control[iCurrent+12]=this.tab_gyel
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.em_gyelamt
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.em_descamt
this.Control[iCurrent+17]=this.dw_kfm03om0
this.Control[iCurrent+18]=this.dw_kfz12ote
this.Control[iCurrent+19]=this.rr_1
this.Control[iCurrent+20]=this.rr_2
end on

on w_kglc22.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_list)
destroy(this.dw_junpoy)
destroy(this.dw_sang)
destroy(this.dw_jbill)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_bill_detail)
destroy(this.dw_rbill)
destroy(this.tab_gyel)
destroy(this.st_2)
destroy(this.em_gyelamt)
destroy(this.st_3)
destroy(this.em_descamt)
destroy(this.dw_kfm03om0)
destroy(this.dw_kfz12ote)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
tab_gyel.tabpage_method.dw_method.SetTransObject(SQLCA)
tab_gyel.tabpage_method.dw_method2.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)
dw_jbill.SetTransObject(SQLCA)
dw_rbill.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_sungin.SetTransObject(SQLCA)
dw_bill_detail.SetTransObject(SQLCA)

dw_kfm03om0.SetTransObject(Sqlca)
dw_kfz12ote.SetTransObject(Sqlca)

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

/*송금 수수료 지급 방법(1:예금,2:현금)-2000.11.26*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)      INTO :LsPayFeeGbn
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 17 ) AND  
         ( "SYSCNFG"."LINENO" = '03' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsPayFeeGbn = 'N'
ELSE
	IF IsNull(LsPayFeeGbn) THEN LsPayFeeGbn = 'N'
END IF

/*결제 대상 선정 방법(1:당일기준, 2:전월기준-2001.07.20*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)      INTO :LsSelectGbn
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 17 ) AND  ( "SYSCNFG"."LINENO" = '05' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsSelectGbn = '1'
ELSE
	IF IsNull(LsSelectGbn) THEN LsSelectGbn = '1'
END IF


end event

type dw_insert from w_inherite`dw_insert within w_kglc22
boolean visible = false
integer x = 4000
integer y = 2760
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc22
boolean visible = false
integer x = 3822
integer y = 2780
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc22
boolean visible = false
integer x = 3648
integer y = 2780
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc22
boolean visible = false
integer x = 3634
integer y = 2936
integer taborder = 80
end type

type p_ins from w_inherite`p_ins within w_kglc22
boolean visible = false
integer x = 2551
integer y = 8
integer taborder = 0
string picturename = "C:\erpman\image\전표처리_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\전표처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\전표처리_up.gif"
end event

event p_ins::clicked;call super::clicked;Open(W_Kglc21)

IF sModStatus = 'M' then
	Wf_Init()
END IF

end event

type p_exit from w_inherite`p_exit within w_kglc22
integer x = 4434
integer y = 4
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kglc22
integer x = 4261
integer y = 4
integer taborder = 60
end type

event p_can::clicked;call super::clicked;ROLLBACK;

Wf_Init()

Integer k

//IF Lstr_PayGyel[1].AryCnt = 0 OR IsNull(Lstr_PayGyel[1].AryCnt) THEN Return
//
//For k = 1 TO Lstr_PayGyel[1].AryCnt
//	SetNull(Lstr_PayGyel[k].bill_gbn)
//	SetNull(Lstr_PayGyel[k].billno)
//	SetNull(Lstr_PayGyel[k].bbaldate)
//	SetNull(Lstr_PayGyel[k].bmandate)
//	SetNull(Lstr_PayGyel[k].bill_nm)
//	SetNull(Lstr_PayGyel[k].billamt)
//NEXT
		

end event

type p_print from w_inherite`p_print within w_kglc22
boolean visible = false
integer x = 3278
integer y = 2784
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc22
integer x = 3739
integer y = 4
end type

event p_inq::clicked;call super::clicked;String sSaupj,sAcc1,sAcc2,sCust

dw_cond.AcceptText()

sBaseDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")
sAcc1     = dw_cond.GetItemString(dw_cond.GetRow(),"acc1_cd")
sAcc2     = dw_cond.GetItemString(dw_cond.GetRow(),"acc2_cd") 
sCust     = dw_cond.GetItemString(dw_cond.GetRow(),"cust")
sSaupj    = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_cond.Setcolumn("basedate")
	dw_cond.SetFocus()
	Return
END IF

IF sAcc1 = "" OR IsNull(sAcc1) THEN sAcc1 = '%'
IF sAcc2 = "" OR IsNull(sAcc2) THEN sAcc2 = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'

IF sModStatus = 'I' THEN
	sSaupj = '%'
ELSE
	sSaupj = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
END IF

IF dw_list.Retrieve(sBaseDate,sAcc1,sAcc2,sCust,sSaupj) <=0 THEN
	
	F_MessageChk(14,'')
		
	Wf_Init()
	
	Return
END IF

tab_gyel.tabpage_desc.dw_detail.SetRedraw(False)

dw_list.SelectRow(0,False)
dw_list.SelectRow(1,True)
dw_list.ScrollToRow(1)

IF sModStatus = 'I' THEN
	IF LsSelectGbn = '2' THEN														/*전월*/
		sBaseDate = Left(sBaseDate,6)+'00'
	END IF

	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(1,"saup_no"),sAcc1,sAcc2,sSaupj)
ELSE
	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(1,"saup_no"),sAcc1,sAcc2,sSaupj)
END IF

tab_gyel.tabpage_desc.dw_detail.ScrollToRow(1)
tab_gyel.tabpage_desc.dw_detail.SetColumn("chkflag")
tab_gyel.tabpage_desc.dw_detail.SetFocus()

tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)



end event

type p_del from w_inherite`p_del within w_kglc22
integer x = 4087
integer y = 4
integer taborder = 50
end type

event p_del::clicked;call super::clicked;Integer iSelectRow,iRowCount,k
String  sAlcGbn,sGyelDate,sLoNo
Long    lSeqNo
Double  dChaIpAmt,dRemain

iSelectRow = tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0)
IF iSelectRow <=0 Then
	F_MessageChk(11,'')
	dw_cond.SetFocus()
	Return
END IF

sAlcGbn = tab_gyel.tabpage_desc.dw_detail.GetItemSTring(iSelectRow,"alc_gu")
IF sAlcGbn ='Y' THEN
	F_MessageChk(51,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN Return 

IF Wf_Delete_Kfz12ot0(tab_gyel.tabpage_desc.dw_detail.GetItemString(iSelectRow,"accjunno")) = -1 THEN 
	Rollback;
	Return
END IF

sGyelDate = tab_gyel.tabpage_desc.dw_detail.GetItemString(iSelectRow,"gyel_date")
lSeqNo    = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(iSelectRow,"seqno")

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.DeleteRow(0)

iRowCount = dw_bill_detail.RowCount()
For k = iRowCount TO 1 Step -1
	dw_bill_detail.DeleteRow(k)	
NEXT

sLoNo      = tab_gyel.tabpage_method.dw_method2.GetItemString(1,"yakjung_no")
dChaIpAmt  = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
IF IsNull(dChaIpAmt) THEN dChaIpAmt = 0

tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
tab_gyel.tabpage_method.dw_method2.DeleteRow(0)

IF tab_gyel.tabpage_method.dw_method.Update() = 1 AND dw_bill_detail.Update() = 1 AND tab_gyel.tabpage_method.dw_method2.Update() = 1 THEN
	IF sLoNo <> '' AND Not IsNull(sLoNo) THEN
		IF dw_kfm03om0.Retrieve(sLoNo) = 1 THEN
			dRemain = dw_kfm03om0.GetItemNumber(1,"lo_hamt")
			IF IsNull(dRemain) THEN dRemain = 0
			
			dw_kfm03om0.SetItem(1,"lo_hamt", dRemain + dChaIpAmt)
		END IF
		IF dw_kfm03om0.Update() <> 1 THEN
			F_MessageChk(12,'[약정마스타]')
			Rollback;
			Return			
		END IF
	END IF
	
	COMMIT;
	sle_msg.text = '자료를 삭제하였습니다!!'
	tab_gyel.tabpage_method.dw_method.SetRedraw(True)
ELSE
	F_MessageChk(12,'[결제조건]')
	Rollback;
	tab_gyel.tabpage_method.dw_method.SetRedraw(True)
	
	Return
END IF

tab_gyel.tabpage_method.dw_method.Enabled = True

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
tab_gyel.tabpage_method.dw_method2.Reset()
tab_gyel.tabpage_method.dw_method2.InsertRow(0)
tab_gyel.tabpage_method.dw_method2.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_kglc22
integer x = 3913
integer y = 4
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Double  dSelectAmt
Integer iRtnValue,iSelectRow
Long    lGyelSeq
String  sBalDate,sAccNo

IF tab_gyel.tabpage_desc.dw_detail.AcceptText() = -1 THEN Return
IF tab_gyel.tabpage_desc.dw_detail.RowCount() <=0 THEN Return

IF tab_gyel.tabpage_method.dw_method.AcceptText() = -1 THEN Return
IF tab_gyel.tabpage_method.dw_method.GetRow() <=0 THEN Return

IF Wf_RequiredChk() = -1 THEN Return

IF sModStatus = 'I' THEN												/*등록시*/
	dSelectAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(1,"sum_yamt")
	IF dSelectAmt = 0 OR IsNull(dSelectAmt) THEN
		F_MessageChk(11,'')
		dw_cond.SetFocus()
		Return
	END IF
	sBalDate = dw_cond.GetItemString(1,"baldate")							/*결제일자*/
	IF sBalDate = "" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[결제일자]')
		dw_cond.Setcolumn("baldate")
		dw_cond.SetFocus()
		Return
	END IF
	IF dSelectAmt <> tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"gyelamt") THEN
		F_MessageChk(47,'')
		tab_gyel.tabpage_method.dw_method.SetColumn("cashamt")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return
	END IF	

	lGyelSeq = 0
ELSE
	iSelectRow = tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0)
	IF iSelectRow <=0 Then
		F_MessageChk(11,'')
		dw_cond.SetFocus()
		Return
	END IF
	
	sAccNo = Trim(tab_gyel.tabpage_desc.dw_detail.GetItemSTring(iSelectRow,"accno"))
	IF sAccNo <> "" AND Not IsNull(sAccNo) THEN
		F_MessageChk(49,'')
		Return
	END IF	
	IF tab_gyel.tabpage_desc.dw_detail.GetItemNumber(iSelectRow,"sum_yamt") <> tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"gyelamt") THEN
		F_MessageChk(47,'')
		tab_gyel.tabpage_method.dw_method.SetColumn("cashamt")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return
	END IF	

	sBalDate = tab_gyel.tabpage_desc.dw_detail.GetItemString(iSelectRow,"gyel_date")
	lGyelSeq = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(iSelectRow,"seqno")
END IF

IF F_DbConFirm('저장') = 2 THEN Return 

SetPointer(HourGlass!)
iRtnValue = Wf_Save(sBalDate,lGyelSeq,'1')
IF iRtnValue = -1 THEN
	Rollback;	
	SetPointer(Arrow!)
	Return
ELSEIF iRtnValue = -2 THEN
	SetPointer(Arrow!)
	Return 
END IF
w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
commit;

//if MessageBox('확 인','전표로 발행하시겠습니까?',Question!,YesNo!,1) = 1 then

w_mdi_frame.sle_msg.text = '전표 처리 중...'
IF Wf_Create_Kfz12ot0(sBalDate,lGyelSeq) = -1 THEN
	Rollback;
	Return
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
	
	p_print.TriggerEvent(Clicked!)
	
	w_mdi_frame.sle_msg.text = '전표처리를 완료하였습니다!!'
END IF

//else
//	iRtnValue = Wf_Save(sBalDate,lGyelSeq,'2')
//	IF iRtnValue = -1 THEN
//		Rollback;	
//		SetPointer(Arrow!)
//		Return -1
//	ELSEIF iRtnValue = -2 THEN
//		SetPointer(Arrow!)
//		Return -1
//	END IF
//	commit;
//end if
SetPointer(Arrow!)

//Wf_Init()
tab_gyel.tabpage_method.dw_method.Enabled = True
tab_gyel.tabpage_method.dw_method2.Enabled = True

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
tab_gyel.tabpage_method.dw_method2.Reset()
tab_gyel.tabpage_method.dw_method2.InsertRow(0)
tab_gyel.tabpage_method.dw_method2.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_kglc22
boolean visible = false
integer x = 3790
integer y = 2508
end type

type cb_mod from w_inherite`cb_mod within w_kglc22
boolean visible = false
integer x = 2725
integer y = 2508
end type

type cb_ins from w_inherite`cb_ins within w_kglc22
boolean visible = false
integer x = 1911
integer y = 2508
integer width = 443
integer height = 124
string text = "전표처리(&A)"
end type

type cb_del from w_inherite`cb_del within w_kglc22
boolean visible = false
integer x = 3081
integer y = 2508
end type

type cb_inq from w_inherite`cb_inq within w_kglc22
boolean visible = false
integer x = 2373
integer y = 2512
end type

type cb_print from w_inherite`cb_print within w_kglc22
boolean visible = false
integer x = 2926
integer y = 2836
end type

event cb_print::clicked;call super::clicked;String sSaupj,sUpmuGbn,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long   lBJunNo,iRtnVal,lJunNo

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

sSaupj   = dw_junpoy.GetItemString(1,"saupj")
sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
sUpmuGbn = dw_junpoy.GetItemString(1,"upmu_gu") 
lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 

select distinct jun_no into :lJunNo	from kfz10ot0 
	where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGbn and bjun_no = :lBJunNo;
if sqlca.sqlcode = 0 then
	iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGbn,lJunNo,sPrtGbn,'P')
else
	iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGbn,lBJunNo,sPrtGbn,'P')
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

type st_1 from w_inherite`st_1 within w_kglc22
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc22
boolean visible = false
integer x = 3438
integer y = 2508
end type

type cb_search from w_inherite`cb_search within w_kglc22
boolean visible = false
integer x = 2418
integer y = 2844
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc22
boolean visible = false
integer x = 2830
end type

type sle_msg from w_inherite`sle_msg within w_kglc22
boolean visible = false
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_kglc22
boolean visible = false
integer x = 9
integer width = 3584
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc22
boolean visible = false
integer x = 2295
integer y = 2608
integer width = 416
integer height = 172
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc22
boolean visible = false
integer x = 2738
integer y = 2580
integer width = 1477
integer height = 172
end type

type dw_cond from u_key_enter within w_kglc22
event ue_key pbm_dwnkey
integer x = 32
integer y = 164
integer width = 4599
integer height = 300
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kglc221"
boolean border = false
end type

event ue_key;IF key = keyF1! or key = keytab! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event getfocus;
this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String  sSaupj,sBalDate,sAcc1_cd,sAcc2_cd,sAccName,sDeptCode,sEmpNo,sEmpName,sSdeptCode,&
		  sSaupNo,sCvName,snull
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
	
	SELECT "KFZ01OM0"."ACC2_NM","KFZ01OM0"."GBN1"   INTO :sAccName, :lstr_account.gbn1  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
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
	
	SELECT "KFZ01OM0"."ACC2_NM","KFZ01OM0"."GBN1"   INTO :sAccName, :lstr_account.gbn1  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
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

IF this.GetColumnName() = "cust" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(this.GetRow(),"custname",sNull)
		Return 
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_NM"	   INTO :sCvName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sSaupNo AND "KFZ04OM0"."PERSON_GU" = :lstr_account.gbn1);
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"custname",sCvName)
	ELSE
//		F_MessageChk(20,'[거래처]')
		
//		this.SetItem(this.GetRow(),"cust",    sNull)
//		this.SetItem(this.GetRow(),"custname",sNull)
//		Return 1
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
	IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
		F_MessageChk(29,'[결제일자]')
		this.SetItem(1,"baldate",snull)
		this.SetColumn("baldate")
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
//		F_MessageChk(20,'[결제자]')
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

event rbuttondown;string ls_acc1_cd

this.AcceptText()
IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
//	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) and Isnull(lstr_account.acc2_cd) THEN 
		this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
		this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
		this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
		setnull(lstr_account.gbn1)
		Return
	END IF
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
		
//	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="cust" THEN
	SetNull(lstr_custom.code)
	
	lstr_custom.code = this.GetItemString(this.GetRow(),"cust")
	
	ls_acc1_cd = dw_cond.getitemstring(dw_cond.getrow(), "acc1_cd")
	
	if ls_acc1_cd = '' or isnull(ls_acc1_cd) then 
		setnull(lstr_account.gbn1)
		if isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP, lstr_account.gbn1)
	else
		gs_code = dw_cond.getitemstring(dw_cond.getrow(), "acc1_cd") + dw_cond.getitemstring(dw_cond.getrow(), "acc2_cd")
		if lstr_account.gbn1 = '' or isnull(lstr_account.gbn1) then	lstr_account.gbn1 = '%'	
		OpenWithParm(W_KFZ04OM0_POPUP_KWAN, lstr_account.gbn1)
	end if
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"cust", lstr_custom.code)
	this.SetItem(this.GetRow(),"custname",lstr_custom.name)
	
END IF

IF this.GetColumnName() ="empno" THEN
	SetNull(lstr_custom.code)
	
	lstr_custom.code = this.GetItemString(this.GetRow(),"empno")
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"empno", lstr_custom.code)
	this.SetItem(this.GetRow(),"empname",lstr_custom.name)
	
END IF

end event

type rb_1 from radiobutton within w_kglc22
integer x = 69
integer y = 52
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'I'									

Wf_Init()

end event

type rb_2 from radiobutton within w_kglc22
integer x = 347
integer y = 52
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'M'									

Wf_Init()

end event

type dw_list from u_key_enter within w_kglc22
integer x = 50
integer y = 484
integer width = 1038
integer height = 1736
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_kglc222"
boolean vscrollbar = true
boolean border = false
end type

event clicked;String sSaupj,sAcc1,sAcc2

IF Row <=0 THEN Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

sAcc1  = dw_cond.GetItemString(dw_cond.GetRow(),"acc1_cd")
sAcc2  = dw_cond.GetItemString(dw_cond.GetRow(),"acc2_cd")  
IF sAcc1 = "" OR IsNull(sAcc1) THEN sAcc1 = '%'
IF sAcc2 = "" OR IsNull(sAcc2) THEN sAcc2 = '%'

IF sModStatus = 'I' THEN
	sSaupj = '%'
ELSE
	sSaupj = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")  
END IF

tab_gyel.tabpage_desc.dw_detail.SetRedraw(False)
IF sModStatus = 'I' THEN
	IF LsSelectGbn = '2' THEN														/*전월*/
		sBaseDate = Left(sBaseDate,6)+'00'
	END IF
	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(row,"saup_no"),sAcc1,sAcc2,sSaupj)
ELSE
	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(row,"saup_no"),sAcc1,sAcc2,sSaupj)
END IF

tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
tab_gyel.tabpage_method.dw_method2.Reset()
tab_gyel.tabpage_method.dw_method2.InsertRow(0)
tab_gyel.tabpage_method.dw_method2.SetRedraw(True)

em_descamt.text = String(0,'###,###,###,##0')
em_gyelamt.text = String(0,'###,###,###,##0')

tab_gyel.SelectedTab = 1



end event

type dw_junpoy from datawindow within w_kglc22
boolean visible = false
integer x = 73
integer y = 2476
integer width = 1234
integer height = 100
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

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_sang from datawindow within w_kglc22
boolean visible = false
integer x = 1307
integer y = 2476
integer width = 905
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리결과 저장"
string dataobject = "d_kifa108"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_jbill from datawindow within w_kglc22
boolean visible = false
integer x = 1307
integer y = 2580
integer width = 905
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음 저장"
string dataobject = "dw_kglb01c1_3"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sungin from datawindow within w_kglc22
boolean visible = false
integer x = 73
integer y = 2584
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
end type

type dw_print from datawindow within w_kglc22
boolean visible = false
integer x = 1307
integer y = 2676
integer width = 905
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_bill_detail from datawindow within w_kglc22
boolean visible = false
integer x = 402
integer y = 2684
integer width = 905
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "어음결제 상세 저장"
string dataobject = "d_kglc206"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_rbill from datawindow within w_kglc22
boolean visible = false
integer x = 1307
integer y = 2776
integer width = 905
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "받을어음 배서내역 저장"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type tab_gyel from tab within w_kglc22
integer x = 1111
integer y = 476
integer width = 3493
integer height = 1760
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_desc tabpage_desc
tabpage_method tabpage_method
end type

on tab_gyel.create
this.tabpage_desc=create tabpage_desc
this.tabpage_method=create tabpage_method
this.Control[]={this.tabpage_desc,&
this.tabpage_method}
end on

on tab_gyel.destroy
destroy(this.tabpage_desc)
destroy(this.tabpage_method)
end on

event selectionchanged;
Wf_Display_GyelAmt()



end event

type tabpage_desc from userobject within tab_gyel
integer x = 18
integer y = 96
integer width = 3456
integer height = 1648
long backcolor = 32106727
string text = "결제대상"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_detail dw_detail
end type

on tabpage_desc.create
this.rr_3=create rr_3
this.dw_detail=create dw_detail
this.Control[]={this.rr_3,&
this.dw_detail}
end on

on tabpage_desc.destroy
destroy(this.rr_3)
destroy(this.dw_detail)
end on

type rr_3 from roundrectangle within tabpage_desc
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 16
integer width = 3419
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from u_key_enter within tabpage_desc
integer x = 27
integer y = 24
integer width = 3387
integer height = 1604
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kglc223"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event clicked;
IF row <=0 THEN Return

IF sModStatus = 'M' THEN
	SelectRow(0,False)
	SelectRow(row,True)
	
	dw_cond.SetItem(dw_cond.GetRow(),"baldate",this.GetItemString(row,"gyel_date"))
	
	tab_gyel.tabpage_method.dw_method.SetRedraw(False)
	tab_gyel.tabpage_method.dw_method.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
	IF tab_gyel.tabpage_method.dw_method.RowCount() <=0 THEN
		tab_gyel.tabpage_method.dw_method.Reset()
		tab_gyel.tabpage_method.dw_method.InsertRow(0)
	END IF
	IF this.GetItemString(row,"accno") = "" OR IsNull(this.GetItemString(row,"accno")) THEN
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sflag",'1')
		tab_gyel.tabpage_method.dw_method.Enabled = True
		
		dw_cond.Modify("pcfee.protect = 0")
	ELSE
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sflag",'2')
		tab_gyel.tabpage_method.dw_method.Enabled = False
		
		dw_cond.Modify("pcfee.protect = 1")	
	END IF
	dw_cond.SetItem(1,"pcfee", tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"sendfee"))
	
	dw_bill_detail.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"),'%')
	tab_gyel.tabpage_method.dw_method.SetRedraw(True)
	
	tab_gyel.tabpage_method.dw_method2.SetRedraw(False)
	tab_gyel.tabpage_method.dw_method2.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
	IF tab_gyel.tabpage_method.dw_method2.RowCount() <=0 THEN
		tab_gyel.tabpage_method.dw_method2.Reset()
		tab_gyel.tabpage_method.dw_method2.InsertRow(0)
	END IF
	IF this.GetItemString(row,"accno") = "" OR IsNull(this.GetItemString(row,"accno")) THEN
		tab_gyel.tabpage_method.dw_method2.SetItem(1,"sflag",'1')
		tab_gyel.tabpage_method.dw_method2.Enabled = True
	ELSE			
		tab_gyel.tabpage_method.dw_method2.SetItem(1,"sflag",'2')
		tab_gyel.tabpage_method.dw_method2.Enabled = False
	END IF
	tab_gyel.tabpage_method.dw_method2.SetRedraw(True)

	Wf_Display_GyelAmt()
END IF
end event

event itemchanged;Double dAmount,dCurAmt,lnull
String sFlag

SetNull(lnull)

IF this.GetColumnName() = "chkflag" THEN
	sFlag = this.GetText()
	IF sFlag = "" OR IsNull(sFlag) THEN Return
	
	dCurAmt = this.GetItemNumber(this.GetRow(),"remain_amt")				/*미반제금액*/
	IF dCurAmt = 0 OR IsNull(dCurAmt) THEN dCurAmt = 0
	
	IF sFlag = 'Y' THEN
		this.SetItem(this.GetRow(),"gyelamt",dCurAmt)
	ELSE
		this.SetItem(this.GetRow(),"gyelamt",0)		
	END IF
END IF

IF this.GetColumnName() = "gyelamt" THEN
	dAmount = Double(this.GetText())
	IF dAmount = 0 OR IsNull(dAmount) THEN Return
	
	dCurAmt = this.GetItemNumber(this.GetRow(),"remain_amt")				/*미반제금액*/
	IF dCurAmt = 0 OR IsNull(dCurAmt) THEN dCurAmt = 0
	
	IF dCurAmt < dAmount THEN
		F_MessageChk(47,'')
		this.SetItem(this.GetRow(),"gyelamt",0)
		Return 1
	END IF	
END IF

Wf_Display_GyelAmt()
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,"chkflag",'Y')
END IF
end event

event itemfocuschanged;call super::itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="descr"  THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type tabpage_method from userobject within tab_gyel
integer x = 18
integer y = 96
integer width = 3456
integer height = 1648
long backcolor = 32106727
string text = "결제방법"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_method dw_method
dw_method2 dw_method2
end type

on tabpage_method.create
this.rr_4=create rr_4
this.dw_method=create dw_method
this.dw_method2=create dw_method2
this.Control[]={this.rr_4,&
this.dw_method,&
this.dw_method2}
end on

on tabpage_method.destroy
destroy(this.rr_4)
destroy(this.dw_method)
destroy(this.dw_method2)
end on

type rr_4 from roundrectangle within tabpage_method
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 20
integer width = 3419
integer height = 1616
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_method from u_key_enter within tabpage_method
event ue_key pbm_dwnkey
integer x = 91
integer y = 148
integer width = 3227
integer height = 1352
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kglc224"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event buttonclicked;Integer   k,iCurRow,iFindRow,iCount
Double    dDescAmt,dGyelAmt,dSilGyelAmt

IF tab_gyel.tabpage_desc.dw_detail.RowCount() <=0 THEN Return

IF dwo.name = 'dcb_bill_detail' THEN
	
	dDescAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(tab_gyel.tabpage_desc.dw_detail.GetRow(),"sum_yamt")
	IF dDescAmt = 0 OR IsNull(dDescAmt) THEN Return
	IF dw_method.RowCount() <=0 THEN Return
		
	/*결제금액*/
	dGyelAmt = this.GetItemNumber(this.GetRow(),"gyelamt") - this.GetItemNumber(1,"billamt")
	IF IsNull(dGyelAmt) THEN dGyelAmt = 0

	/*실제 어음 결제할 금액*/
	dSilGyelAmt = dDescAmt - dGyelAmt
	IF IsNull(dSilGyelAmt) THEN dSilGyelAmt = 0
	
	Lstr_PayGyel[1].sFlag = sModStatus

	Lstr_payGyel[1].Gyel_Date      = dw_cond.GetItemString(dw_cond.GetRow(),"baldate")
	Lstr_payGyel[1].SeqNo          = dw_method.GetItemNumber(dw_method.GetRow(),"seqno")
	Lstr_PayGyel[1].Total_GyelAmt  = dSilGyelAmt
	Lstr_PayGyel[1].saupj			 = dw_cond.GetItemString(dw_cond.GeTRow(),"saupj")
	
	Wf_Bill_Detail()
	
	Open(w_kglc20a)
	
	IF Lstr_PayGyel[1].sFlag = '1' THEN							/*자료 변경 있으면*/
		/*이전 자료 삭제*/
		iCount = dw_bill_detail.RowCount()
		for k = iCount to 1 step -1
			dw_bill_detail.deleterow(k)
		next
		dw_bill_detail.Update()
		
		FOR k = 1 TO Lstr_PayGyel[1].AryCnt
			iFindRow = dw_bill_detail.Find("bill_gbn = '" + Lstr_PayGyel[k].bill_Gbn +"' and billno = '" + Lstr_PayGyel[k].billNo + "'",1,dw_bill_detail.RowCount())
			IF iFindRow <> 0 THEN
				iCurRow = iFindRow				
			ELSE
				iCurRow = dw_bill_detail.InsertRow(0)
				dw_bill_detail.SetItem(iCurRow,"bill_gbn",			Lstr_PayGyel[k].bill_Gbn)
				dw_bill_detail.SetItem(iCurRow,"billno",  			Lstr_PayGyel[k].billno)
			END IF
			dw_bill_detail.SetItem(iCurRow,"bbaldate",  				Lstr_PayGyel[k].bbaldate)
			dw_bill_detail.SetItem(iCurRow,"bmandate", 				Lstr_PayGyel[k].bmandate)
			dw_bill_detail.SetItem(iCurRow,"bank_cd",   				Lstr_PayGyel[k].bank_cd)
			dw_bill_detail.SetItem(iCurRow,"bill_nm",   				Lstr_PayGyel[k].bill_nm)
			dw_bill_detail.SetItem(iCurRow,"billamt",   				Lstr_PayGyel[k].billamt)
			dw_bill_detail.SetItem(iCurRow,"bill_change_place",   dw_list.GetItemString(dw_list.GetSelectedRow(0),"saup_no"))
			dw_bill_detail.SetItem(iCurRow,"bill_change_date",    Lstr_PayGyel[1].gyel_date)
			
			dw_bill_detail.SetItem(iCurRow,"gyel_date", 				Lstr_PayGyel[1].gyel_date)
			dw_bill_detail.SetItem(iCurRow,"seqno",      			Lstr_PayGyel[1].seqno)
			
		NEXT
		
		this.SetItem(this.GetRow(),"billamt",Lstr_PayGyel[1].Total_GyelAmt)
		
//		this.SetItem(this.GetRow(),"bill_cashamt",dSilGyelAmt - Lstr_PayGyel[1].Total_GyelAmt)		
		this.SetItem(this.GetRow(),"accamt",dSilGyelAmt - Lstr_PayGyel[1].Total_GyelAmt)		
	END IF
	Wf_Display_GyelAmt()
END IF

end event

event itemchanged;Double dAmount,dBillCash,dChaIpAmt,lnull
String sDepotNo,sCheckNo,sAcc1,sAcc2,sBalGbn,snull,aaa

SetNull(snull)
SetNull(lnull)

IF this.GetColumnName() = "cashamt" THEN
	dAmount = Double(this.GetText())
	aaa     = this.GetText()
	IF IsNull(dAmount) OR dAmount = 0 THEN 
		this.SetItem(1,"cashamt",  0)
		dAmount = 0 
//		Return 2
	END IF
END IF

IF this.GetColumnName() = "depotamt" THEN
	dAmount = Double(this.GetText())
	IF dAmount = 0 OR IsNull(dAmount) THEN	
		dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(1,"chaip_amt")
		IF IsNull(dChaIpAmt) OR IsNull(dChaIpAmt) THEN
			this.SetItem(1,"depotamt",  0)
			this.SetItem(1,"depotno",   sNull)
//			Return 2
		ELSE
			this.SetItem(1,"depotamt",dChaIpAmt)
			Wf_Display_GyelAmt()
			Return 2
		END IF
	END IF
END IF

IF this.GetColumnName() = "depotno" THEN
	sDepotNo = this.GetText()
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN Return
	
	IF IsNull(F_Get_Personlst('5',sDepotNo,'1')) THEN
		F_MessageChk(20,'[예적금코드]')
		this.SetItem(this.GetRow(),"depotno",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"depotname",F_Get_Personlst('5',sDepotNo,'1'))
	END IF
END IF

IF this.GetColumnName() = "checkamt" THEN
	dAmount = Double(this.GetText())
	IF dAmount = 0 OR IsNull(dAmount) THEN
		this.SetItem(1,"checkamt",  0)
		this.SetItem(1,"checkcode", snull)		
		this.SetItem(1,"checkno",   snull)		
		this.SetItem(1,"ckname",    snull)		
//		Return 2
	END IF
END IF

IF this.GetColumnName() = "checkcode" THEN
	sDepotNo = this.GetText()
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN Return
	
	IF IsNull(F_Get_Personlst('5',sDepotNo,'1')) THEN
		F_MessageChk(20,'[예적금코드]')
		this.SetItem(this.GetRow(),"checkcode",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"ckname",F_Get_Personlst('5',sDepotNo,'1'))
	END IF
END IF

IF this.GetColumnName() = "checkno" THEN
	sCheckNo = this.GetText()
	IF sCheckNo = "" OR IsNull(sCheckNo) THEN Return
	
	IF Wf_Dup_Chk(sCheckNo,'1','CHECK') = -1 THEN Return 1
END IF

IF this.GetColumnName() = "accamt" THEN
	dAmount = Double(this.GetText())
	IF dAmount = 0 OR IsNull(dAmount) THEN 
		this.SetItem(1,"accamt",  0)
		this.SetItem(1,"sacc1",snull)
		this.SetItem(1,"sacc2",snull)
		dAmount = 0
//		Return 2
	END IF
END IF

IF this.GetColumnName() = "sacc1" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	sAcc2 = this.GetItemString(this.GetRow(),"sacc2")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"sacc1",snull)
			this.Setitem(this.getrow(),"sacc2",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"sacc1",snull)
		this.Setitem(this.getrow(),"sacc2",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = 'sacc2' THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	sAcc1 = this.GetItemString(this.GetRow(),"sacc1")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"sacc1",snull)
			this.Setitem(this.getrow(),"sacc2",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"sacc1",snull)
		this.Setitem(this.getrow(),"sacc2",snull)
		this.SetColumn("sacc1")
		this.SetFocus()
		Return 1
	end if
END IF

IF this.GetColumnName() = "ijaamt" THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) OR dAmount = 0 THEN 
		this.SetItem(1,"ijaamt",  0)
		dAmount = 0
//		Return 2
	END IF
END IF

Wf_Display_GyelAmt()

end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event rbuttondown;String ls_gj1,ls_gj2

SetNull(lstr_custom.code)

this.AcceptText()
IF this.GetColumnName() ="depotno" THEN						/*예적금*/
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"depotno"),1))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	lstr_custom.name = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'5')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"depotno",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="billno" THEN
	SetNull(gs_code)
	SetNull(gs_codename)

	gs_code =this.GetItemString(this.GetRow(),"billno")
	
	OpenWithParm(W_KFM06OT0_POPUP,'2')
	
	IF gs_code = "" OR IsNull(gs_code) THEN REturn
	
	this.SetItem(this.GetRow(),"billno",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="checkcode" THEN						/*예적금*/

	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)  
		INTO :lstr_account.acc1_cd,			 :lstr_account.acc2_cd  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '17' )   ;
			
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"checkcode"),1))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	lstr_custom.name = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'5')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"checkcode",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="checkno" THEN						/*수표번호*/
	SetNull(gs_code)
	SetNull(gs_codename)

	OpenWithParm(W_KFM06OT0_POPUP,'1')
	
	IF gs_code = "" OR IsNull(gs_code) THEN REturn
	
	this.SetItem(this.GetRow(),"checkno",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="sacc1" OR this.GetColumnName() ="sacc2" THEN

	ls_gj1 =this.GetItemString(this.GetRow(),"sacc1")
	ls_gj2 =this.GetItemString(this.GetRow(),"sacc2")

	IF IsNull(ls_gj1) then
   	ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
   	ls_gj2 = ""
	end if

 	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	this.SetItem(this.GetRow(),"sacc1",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"sacc2",lstr_account.acc2_cd)

	this.TriggerEvent(ItemChanged!)
END IF


end event

type dw_method2 from datawindow within tabpage_method
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
boolean visible = false
integer x = 9
integer y = 1620
integer width = 133
integer height = 84
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kglc225"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Double  dAmount,dChaIpAmt,lNull,dLoRate,dLoRemain
String  sNull,sDepotNo,sDptName,sDate,sBank,sRacc,sLoNo,sChaIpBank,sFrom,sTo
Integer iDays

SetNull(lNull);	SetNull(sNull)

IF this.GetColumnName() = "chaip_amt" THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) OR dAmount = 0 THEN 
		this.SetItem(1,"chaip_amt",  0)
		dAmount = 0
		Return 2
	END IF
		
	IF dAmount > 0 THEN
		this.SetItem(1,"gisan_date",dw_cond.GetItemString(1,"baldate"))
	ELSE
		this.SetItem(1,"chaip_bnk",  sNull)
		this.SetItem(1,"yakjung_no", sNull)
		this.SetItem(1,"chaip_no",   sNull)
		this.SetItem(1,"gisan_date", sNull)
		this.SetItem(1,"mangi_date", sNull)
		this.SetItem(1,"chaip_rate", 0)
		this.SetItem(1,"ija_amt",    0)
		this.SetItem(1,"ija_guzoa",  sNull)
	END IF
	this.SetItem(1,"ija_amt", Wf_Calculation_Ija())
	
	Wf_Display_GyelAmt()
END IF

IF this.GetColumnName() = "yakjung_no" THEN
	sLoNo = this.GetText()
	IF sLoNo = "" OR IsNull(sLoNo) THEN 
		this.SetItem(1,"chaip_bnk",  snull)
		this.SetItem(1,"chaip_rate", 0)
		Return
	END IF
	
	dChaIpAmt = this.GetItemNumber(1,"chaip_amt")
	IF IsNull(dChaIpAmt) THEN dChaIpAmt = 0
	
	SELECT nvl("KFM03OM0"."LO_CRATE",0),   "KFM03OM0"."LO_HAMT",		"KFM03OM0"."LO_BNKCD"
	   INTO :dLoRate,   		        			:dLoRemain,						:sChaIpBank
	   FROM "KFM03OM0"  
   	WHERE "KFM03OM0"."LO_NO" = :sLoNo AND 
				("KFM03OM0"."LO_HDATE" IS NULL OR "KFM03OM0"."LO_HDATE" = '') ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[약정번호]')
		this.SetItem(this.GetRow(),"yakjung_no",snull)
		this.SetItem(1,"chaip_bnk",  snull)
		this.SetItem(1,"chaip_rate", 0)		
		Return 1
	ELSE
		IF dLoRemain < dChaipAmt THEN
			F_MessageChk(16,'[차입금액 > 약정잔액]')
			this.SetItem(this.GetRow(),"yakjung_no",snull)
			this.SetItem(1,"chaip_bnk",  snull)
			this.SetItem(1,"chaip_rate", 0)
			Return 1					
		END IF
	END IF
	this.SetItem(1,"chaip_bnk",     sChaIpBank)
	this.SetItem(1,"chaip_rate",    dLoRate)
	this.SetItem(1,"ija_amt",       Wf_Calculation_Ija())
END IF

IF this.GetColumnName() ="gisan_date" THEN				/*기산일자*/
	sDate = Trim(this.GetText())
	IF sDate ="" OR isNull(sDate) THEN REturn
	
	IF F_DateChk(sDate) = -1 THEN 
		F_MessageChk(21,'[기산일자]')
		this.SetItem(this.GetRow(),"gisan_date",snull)
		Return 1
	END IF
	this.SetItem(1,"ija_amt", Wf_Calculation_Ija())
END IF

IF this.GetColumnName() ="mangi_date" THEN				/*만기일자*/
	sDate = Trim(this.GetText())
	IF sDate ="" OR isNull(sDate) THEN REturn
	
	IF F_DateChk(sDate) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(this.GetRow(),"mangi_date",snull)
		Return 1
	END IF
	this.SetItem(1,"ija_amt", Wf_Calculation_Ija())
END IF

IF this.GetColumnName() = "chaip_bnk" THEN
	sBank = this.GetText()
	IF sBank = "" OR IsNull(sBank) THEN Return
	
	IF IsNull(F_Get_Personlst('2',sBank,'1')) THEN
		F_MessageChk(20,'[차입은행]')
		this.SetItem(this.GetRow(),"chaip_bnk",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "chaip_rate" THEN
	dLoRate = Double(this.GetText())
	IF dLoRate = 0 OR IsNull(dLoRate) THEN 
		Return
	END IF
	
	this.SetItem(1,"ija_amt", Wf_Calculation_Ija())
END IF

IF this.GetColumnName() = "ija_amt" THEN
	IF this.GetText() = '' OR IsNull(this.GetText()) THEN
		this.SetItem(1,"ija_amt", 0)
	END IF
END IF

IF this.GetColumnName() = "ija_guzoa" THEN
	sDepotNo = this.GetText()
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN Return
	
	sDptName = F_Get_Personlst('5',sDepotNo,'1')
	IF IsNull(sDptName) THEN
		F_MessageChk(20,'[이자지급계좌]')
		this.SetItem(this.GetRow(),"ija_guzoa",snull)
		this.SetItem(this.GetRow(),"ija_dptname",snull)
		Return 1
	END IF
	this.SetItem(this.GetRow(),"ija_dptname",sDptName)
END IF

IF this.GetColumnName() = "racccode" THEN
	sRacc = this.GetText()
	IF sRacc = "" OR IsNull(sRacc) THEN Return
	
	IF IsNull(F_Get_Personlst('80',sRacc,'1')) THEN
		F_MessageChk(20,'[대체계정]')
		this.SetItem(this.GetRow(),"racccode",snull)
		Return 1
	END IF
END IF

Wf_Calculation_Gyel()
end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(lstr_custom.code);	SetNull(Gs_Code);

this.AcceptText()
IF this.GetColumnName() ="ija_guzoa" THEN						/*이자지급계좌*/
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"ija_guzoa"),1))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	lstr_custom.name = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'5')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"ija_guzoa",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="yakjung_no" THEN						/*약정번호*/
	Gs_Code = Trim(Left(this.GetItemString(this.GetRow(),"yakjung_no"),1))
	
	IF IsNull(Gs_Code) THEN
		Gs_Code = ""
	END IF

//	Open(W_KFM03OM0_POPUP)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"yakjung_no",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

type st_2 from statictext within w_kglc22
integer x = 3031
integer y = 488
integer width = 384
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "결제한 금액"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_gyelamt from editmask within w_kglc22
integer x = 3419
integer y = 488
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean border = false
alignment alignment = right!
boolean displayonly = true
string mask = "###,###,###,##0"
end type

type st_3 from statictext within w_kglc22
integer x = 2057
integer y = 488
integer width = 407
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "결제대상 금액"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_descamt from editmask within w_kglc22
integer x = 2469
integer y = 488
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean border = false
alignment alignment = right!
boolean displayonly = true
string mask = "###,###,###,##0"
end type

type dw_kfm03om0 from datawindow within w_kglc22
boolean visible = false
integer x = 320
integer y = 2792
integer width = 983
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "약정마스타 갱신"
string dataobject = "d_kglc208"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_kfz12ote from datawindow within w_kglc22
boolean visible = false
integer x = 320
integer y = 2896
integer width = 983
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "미결전표(차입금) 저장"
string dataobject = "d_kglc207"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglc22
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 16
integer width = 590
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kglc22
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 472
integer width = 1061
integer height = 1760
integer cornerheight = 40
integer cornerwidth = 55
end type

