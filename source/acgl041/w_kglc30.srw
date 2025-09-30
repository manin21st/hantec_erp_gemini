$PBExportHeader$w_kglc30.srw
$PBExportComments$지급결제 전표-반제기준(신성)
forward
global type w_kglc30 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc30
end type
type rb_1 from radiobutton within w_kglc30
end type
type rb_2 from radiobutton within w_kglc30
end type
type dw_list from u_key_enter within w_kglc30
end type
type dw_save from datawindow within w_kglc30
end type
type dw_junpoy from datawindow within w_kglc30
end type
type dw_junpoylst from datawindow within w_kglc30
end type
type dw_sang from datawindow within w_kglc30
end type
type dw_jbill from datawindow within w_kglc30
end type
type dw_sungin from datawindow within w_kglc30
end type
type dw_print from datawindow within w_kglc30
end type
type tab_gyel from tab within w_kglc30
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
type tabpage_method from userobject within tab_gyel
rr_4 rr_4
dw_method dw_method
end type
type tab_gyel from tab within w_kglc30
tabpage_desc tabpage_desc
tabpage_method tabpage_method
end type
type st_2 from statictext within w_kglc30
end type
type em_gyelamt from editmask within w_kglc30
end type
type st_3 from statictext within w_kglc30
end type
type em_descamt from editmask within w_kglc30
end type
type rr_1 from roundrectangle within w_kglc30
end type
type rr_2 from roundrectangle within w_kglc30
end type
type dw_bill_detail from datawindow within w_kglc30
end type
end forward

global type w_kglc30 from w_inherite
integer height = 3220
string title = "지급결제전표 발행/삭제 처리"
dw_cond dw_cond
rb_1 rb_1
rb_2 rb_2
dw_list dw_list
dw_save dw_save
dw_junpoy dw_junpoy
dw_junpoylst dw_junpoylst
dw_sang dw_sang
dw_jbill dw_jbill
dw_sungin dw_sungin
dw_print dw_print
tab_gyel tab_gyel
st_2 st_2
em_gyelamt em_gyelamt
st_3 st_3
em_descamt em_descamt
rr_1 rr_1
rr_2 rr_2
dw_bill_detail dw_bill_detail
end type
global w_kglc30 w_kglc30

type variables
String    sBaseDate,LsAutoSungGbn, LsPayFeeGbn
Double  	 LdAryAmt[10]
String    LsAryAcc1[10],LsAryAcc2[10],LsAryChaDae[10],LsAryDescr[10]



end variables

forward prototypes
public subroutine wf_insert_sang (string gyeldate, long gyelseq, string saupj, string baldate, string upmugu, long bjunno, long linno, string acc1, string acc2, string sdept)
public function integer wf_dup_chk (string sbillno, string sbillgbn, string sflag)
public function integer wf_get_gyelseq (string sbaldate)
public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public subroutine wf_init ()
public subroutine wf_setting_remain (string spaymethod, double damount)
public function integer wf_save (string sbaldate, ref long lseqno)
public subroutine wf_display_gyelamt ()
public subroutine wf_calculation_gyel ()
public function integer wf_requiredchk ()
public subroutine wf_bill_detail ()
public function integer wf_setting_acc ()
public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq)
end prototypes

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

public subroutine wf_init ();String snull,sCurDate,sSdept

SetNull(snull)

tab_gyel.tabpage_method.dw_method.Enabled  = True

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
dw_save.Reset()
dw_bill_detail.Reset()

dw_list.SetRedraw(False)
tab_gyel.tabpage_desc.dw_detail.SetRedraw(False)

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

IF sModStatus = 'I' THEN					/*등록*/
	
	dw_cond.Modify("baldate.protect = 0")
	
	dw_list.DataObject = 'd_kglc202'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	tab_gyel.tabpage_desc.dw_detail.DataObject = 'd_kglc203'
	tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
	tab_gyel.tabpage_desc.dw_detail.Reset()
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
ELSE
	
	dw_cond.SetItem(dw_cond.GetRow(),"baldate", snull)
	
	dw_cond.Modify("baldate.protect = 1")
	
	dw_list.DataObject = 'd_kglc2020'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	tab_gyel.tabpage_desc.dw_detail.DataObject = 'd_kglc2030'
	tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
	tab_gyel.tabpage_desc.dw_detail.Reset()
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
END IF

dw_list.SetRedraw(True)
tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)

tab_gyel.tabpage_desc.dw_detail.SelectRow(0,False)

tab_gyel.SelectedTab = 1

//Lstr_PayGyel[1].AryCnt = 0

		
end subroutine

public subroutine wf_setting_remain (string spaymethod, double damount);if sPayMethod = '1' then
		tab_gyel.tabpage_method.dw_method.SetItem(1,"cashamt",    dAmount)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt",   0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_fund",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_sell",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt",    0)
	elseif sPayMethod = '2' then
		tab_gyel.tabpage_method.dw_method.SetItem(1,"cashamt",    0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt",   dAmount)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_fund",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_sell",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt",    0)
	elseif sPayMethod = '3' then
		tab_gyel.tabpage_method.dw_method.SetItem(1,"cashamt",    0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt",   0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_fund",dAmount)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_sell",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt",    0)
	elseif sPayMethod = '4' then	
		tab_gyel.tabpage_method.dw_method.SetItem(1,"cashamt",    0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt",   0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_fund",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_sell",dAmount)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt",    0)
	else
		tab_gyel.tabpage_method.dw_method.SetItem(1,"cashamt",    0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt",   0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_sell",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"accamt_fund",0)
		tab_gyel.tabpage_method.dw_method.SetItem(1,"billamt",    dAmount)
	end if
end subroutine

public function integer wf_save (string sbaldate, ref long lseqno);Integer k,iCurRow
String  sFlag,sLoNo
Double  dRemain,dChaIpAmt,dBillAmt

dw_save.Reset()

IF lSeqNo = 0 THEN
	lSeqNo = Wf_Get_GyelSeq(sBalDate)
	IF lSeqNo = 0 OR IsNull(lSeqNo) THEN
		F_MessageChk(48,'')
		Return -2
	END IF

	SetPointer(HourGlass!)
	
	FOR k = 1 TO tab_gyel.tabpage_desc.dw_detail.RowCount()	
		sFlag = tab_gyel.tabpage_desc.dw_detail.GetItemSTring(k,"chkflag")
		IF sFlag = 'Y' THEN
			iCurRow = dw_save.InsertRow(0)
			
			dw_save.SetItem(iCurRow,"gyel_date",sBalDate)
			dw_save.SetItem(iCurRow,"seqno",    lSeqNo)
			dw_save.SetItem(iCurRow,"saupj",    tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"saupj"))
			dw_save.SetItem(iCurRow,"acc_date", tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"acc_date"))
			dw_save.SetItem(iCurRow,"upmu_gu",  tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"upmu_gu"))
			dw_save.SetItem(iCurRow,"jun_no",   tab_gyel.tabpage_desc.dw_detail.GetItemNumber(k,"jun_no"))
			dw_save.SetItem(iCurRow,"lin_no",   tab_gyel.tabpage_desc.dw_detail.GetItemNumber(k,"lin_no"))
			dw_save.SetItem(iCurRow,"bal_date", tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"bal_date"))
			dw_save.SetItem(iCurRow,"bjun_no",  tab_gyel.tabpage_desc.dw_detail.GetItemNumber(k,"bjun_no"))	
			
			dw_save.SetItem(iCurRow,"acc1_cd",  tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"acc1_cd"))
			dw_save.SetItem(iCurRow,"acc2_cd",  tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"acc2_cd"))
			dw_save.SetItem(iCurRow,"saup_no",  tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"saup_no"))
			dw_save.SetItem(iCurRow,"sdept_cd", tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"sdept_cd"))
			dw_save.SetItem(iCurRow,"descr",    tab_gyel.tabpage_desc.dw_detail.GetItemString(k,"descr"))
			
			dw_save.SetItem(iCurRow,"crossamt", tab_gyel.tabpage_desc.dw_detail.GetItemNumber(k,"gyelamt"))		
			
			dw_save.SetItem(iCurRow,"asaupj",   dw_cond.GetItemString(1,"saupj"))
		END IF
	NEXT
	
	tab_gyel.tabpage_method.dw_method.SetItem(1,"gyel_date", sBalDate)
	tab_gyel.tabpage_method.dw_method.SetItem(1,"seqno",     lSeqNo)
	tab_gyel.tabpage_method.dw_method.SetItem(1,"sendfee",	dw_cond.GetItemNumber(1,"pcfee"))
	
	SetPointer(Arrow!)
	
	IF dw_save.Update() <> 1 THEN
		F_MessageChk(13,'[지급결제 내역]')
		Return -1
	END IF
END IF

IF tab_gyel.tabpage_method.dw_method.Update() <> 1 THEN
	F_MessageChk(13,'[지급결제]')
	Return -1
END IF

Integer iRow

dBillAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"billamt")
if IsNull(dBillAmt) or dBillAmt = 0 then
	iRow = dw_bill_detail.RowCount()	
	FOR k = iRow TO 1 Step -1
		dw_bill_detail.DeleteRow(k)
	NEXT
else
	FOR k = 1 TO dw_bill_detail.RowCount()	
		dw_bill_detail.SetItem(k,"gyel_date", sBalDate)
		dw_bill_detail.SetItem(k,"seqno",     lSeqNo)
	NEXT
end if

IF dw_bill_detail.Update() <> 1 THEN
	F_MessageChk(13,'[지급결제(어음)]')
	Return -1
END IF

Return 1
end function

public subroutine wf_display_gyelamt ();Double dDescAmt,dGyelAmt

tab_gyel.tabpage_method.dw_method.AcceptText()
IF tab_gyel.tabpage_method.dw_method.GetRow() <=0 THEN 
	dGyelAmt = 0
ELSE
	dGyelAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"gyelamt")
	
	IF IsNull(dGyelAmt) THEN dGyelAmt =0
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

/*계정상계 계정과목명 설정*/
String  sAccName,sAccCode
Integer iLoop

declare sacc_lst cursor for
	select rfna1,	rfna2 	from reffpf where rfcod = 'GT' and rfgub <> '00' order by rfgub;

open sacc_lst;
iLoop = 1
do while true
	fetch sacc_lst into :sAccName, :sAccCode ;
	if sqlca.sqlcode <> 0 then exit
	
	if iLoop = 1 then
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc1",    Left(sAccCode,5))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc2",    Mid(sAccCode,6,2))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"saccname", sAccName)
	elseif iLoop = 2 then
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc1_2", Left(sAccCode,5))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc2_2", Mid(sAccCode,6,2))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"saccname2", sAccName)
	else
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc1_3", Left(sAccCode,5))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"sacc2_3", Mid(sAccCode,6,2))
		tab_gyel.tabpage_method.dw_method.SetItem(1,"saccname3", sAccName)
	end if
	
	iLoop = iLoop + 1
Loop

close sacc_lst;
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

//tab_gyel.tabpage_method.dw_method2.AcceptText()
//dChaIpAmt = tab_gyel.tabpage_method.dw_method2.GetItemNumber(tab_gyel.tabpage_method.dw_method2.GetRow(),"chaip_amt")
//IF IsNull(dChaIpAmt) THEN dChaIpAmt = 0
//dIjaAmt   = tab_gyel.tabpage_method.dw_method2.GetItemNumber(tab_gyel.tabpage_method.dw_method2.GetRow(),"ija_amt")
//IF IsNull(dIjaAmt) THEN dIjaAmt = 0
//
//IF dChaIpAmt <> 0 THEN
//	tab_gyel.tabpage_method.dw_method.SetItem(1,"depotamt", dChaIpAmt - dCashAmt + dPayFee)
//END IF

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

public function integer wf_requiredchk ();
String  sSaupj,sGyelDate,sDepotNo,sManDate,sAcc1,sAcc2,sDept, sEmpno,sSaupDept,sFlag,sKwanNo
Integer i
Double  dAmt,dBillAmt,dCheckAmt,dDepotAmt,dAccAmt,dPcAmt,dAccAmtSell,dAccAmtFund

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
dAccAmt   = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt")

dBillAmt  = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"billamt")
dCheckAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"checkamt")
dDepotAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"depotamt")
dAccAmtSell = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt_fund")
dAccAmtFund = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt_sell")
IF IsNull(dAccAmt)   THEN dAccAmt = 0

IF IsNull(dBillAmt)  THEN dBillAmt = 0
IF IsNull(dCheckAmt) THEN dCheckAmt = 0
IF IsNull(dDepotAmt) THEN dDepotAmt = 0
IF IsNull(dAccAmtFund) THEN dAccAmtFund = 0
IF IsNull(dAccAmtSell) THEN dAccAmtSell = 0

IF dDepotAmt <> 0 THEN											/*예적금액 입력시*/
	sDepotNo = tab_gyel.tabpage_method.dw_method.GetItemSTring(1,"depotno")
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN
		F_MessageChk(1,'[예적금코드]')
		tab_gyel.tabpage_method.dw_method.SetColumn("depotno")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF

IF dAccAmt <> 0 THEN												/*계정상계 입력시-대여금*/
	sAcc1   = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1")
	sAcc2   = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2")
	sKwanNo = tab_gyel.tabpage_method.dw_method.GetItemString(1,"kwan_no")
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
	IF sKwanNo = "" OR IsNull(sKwanNo) THEN
		F_MessageChk(1,'[대여금코드]')
		tab_gyel.tabpage_method.dw_method.SetColumn("kwan_no")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF
IF dAccAmtFund <> 0 or dAccAmtSell <> 0 THEN			/*외상매출담보채권,구매자금*/
	sKwanNo = tab_gyel.tabpage_method.dw_method.GetItemString(1,"chaip_no")
	sManDate= Trim(tab_gyel.tabpage_method.dw_method.GetItemString(1,"bmandate"))
	IF sKwanNo = "" OR IsNull(sKwanNo) THEN
		F_MessageChk(1,'[금융기관]')
		tab_gyel.tabpage_method.dw_method.SetColumn("chaip_no")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
	IF sManDate = "" OR IsNull(sManDate) THEN
		F_MessageChk(1,'[만기일자]')
		tab_gyel.tabpage_method.dw_method.SetColumn("bmandate")
		tab_gyel.tabpage_method.dw_method.SetFocus()
		Return -1
	END IF
END IF
Return 1
end function

public subroutine wf_bill_detail ();Integer k

//IF dw_bill_detail.RowCount() > 0 THEN
//	FOR k = 1 TO dw_bill_detail.RowCount()
//		Lstr_PayGyel[k].bill_gbn = dw_bill_detail.GetItemString(k,"bill_gbn")			
//		Lstr_PayGyel[k].billno   = dw_bill_detail.GetItemString(k,"billno")			
//		Lstr_PayGyel[k].bbaldate = dw_bill_detail.GetItemString(k,"bbaldate")			
//		Lstr_PayGyel[k].bmandate = dw_bill_detail.GetItemString(k,"bmandate")				
//		Lstr_PayGyel[k].bank_cd  = dw_bill_detail.GetItemString(k,"bank_cd")			
//		Lstr_PayGyel[k].bill_nm  = dw_bill_detail.GetItemString(k,"bill_nm")			
//		Lstr_PayGyel[k].billamt  = dw_bill_detail.GetItemNumber(k,"billamt")
//		
////		Lstr_PayGyel[k].gyel_date= dw_bill_detail.GetItemString(k,"gyel_date")
////		Lstr_PayGyel[k].seqno    = dw_bill_detail.GetItemNumber(k,"seqno")
//	NEXT
//	
//	Lstr_PayGyel[1].AryCnt = k - 1
//ELSE
////	Lstr_PayGyel[1].AryCnt = 0
//END IF

end subroutine

public function integer wf_setting_acc ();Double    dCashAmt,dDepotAmt,dAccAmt,dPcAmt,dAccSellAmt,dAccFundAmt,dBillAmt,dPayDptAmt,dAccAmt2,dAccAmt3
String    sDepotNo,sSaupj,sChNo
Integer   k

FOR k= 1 TO 10
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
dAccFundAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt_fund")
dAccSellAmt = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt_sell")
dBillAmt		= tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"billamt")

dAccAmt     = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt")
dAccAmt2    = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt2")
dAccAmt3    = tab_gyel.tabpage_method.dw_method.GetItemNumber(1,"accamt3")

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

IF dAccFundAmt <> 0 THEN										/*구매자금*/
	sChNo    = tab_gyel.tabpage_method.dw_method.GetItemString(1,"chaip_no")
	
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
	LsAryAcc1[8] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1")
	LsAryAcc2[8] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2")
	
	IF LsAryAcc1[8] = "" OR IsNull(LsAryAcc1[8]) THEN LsAryAcc1[8] = '00000'
	IF LsAryAcc2[8] = "" OR IsNull(LsAryAcc2[8]) THEN LsAryAcc2[8] = '00'
	
	LsAryChaDae[8] = '2';		
	LsAryDescr[8]  = tab_gyel.tabpage_method.dw_method.GetItemString(1,"saccname")+' 으로 지급';
	LdAryAmt[8]    = dAccAmt
ELSE
	LsAryAcc1[8] = '9'; LsAryAcc2[8] = '9';	
	LdAryAmt[8]  = dAccAmt
END IF

IF dAccAmt2 <> 0 THEN											/*계정2*/
	LsAryAcc1[9] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1_2")
	LsAryAcc2[9] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2_2")
	
	IF LsAryAcc1[9] = "" OR IsNull(LsAryAcc1[9]) THEN LsAryAcc1[9] = '00000'
	IF LsAryAcc2[9] = "" OR IsNull(LsAryAcc2[9]) THEN LsAryAcc2[9] = '00'
	
	LsAryChaDae[9] = '2';		
	LsAryDescr[9] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"saccname2")+' 으로 지급';
	LdAryAmt[9] = dAccAmt2
ELSE
	LsAryAcc1[9] = '9'; LsAryAcc2[9] = '9';	
	LdAryAmt[9]  = dAccAmt2
END IF

IF dAccAmt3 <> 0 THEN											/*계정3*/
	LsAryAcc1[10] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc1_3")
	LsAryAcc2[10] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"sacc2_3")
	
	IF LsAryAcc1[10] = "" OR IsNull(LsAryAcc1[10]) THEN LsAryAcc1[10] = '00000'
	IF LsAryAcc2[10] = "" OR IsNull(LsAryAcc2[10]) THEN LsAryAcc2[10] = '00'
	
	LsAryChaDae[10] = '2';		
	LsAryDescr[10] = tab_gyel.tabpage_method.dw_method.GetItemString(1,"saccname3")+' 으로 지급';
	LdAryAmt[10] = dAccAmt3
ELSE
	LsAryAcc1[10] = '9'; LsAryAcc2[10] = '9';	
	LdAryAmt[10]  = dAccAmt3
END IF


//IF dCheckAmt <> 0 THEN										/*당좌예금*/
//	sDepotNo    = tab_gyel.tabpage_method.dw_method.GetItemString(1,"checkcode")
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

public function integer wf_create_kfz12ot0 (string sgyeldate, long lgyelseq);Integer iRowCount,k,iCurRow,i,iBillCnt,iInsRow
Long    lJunpoyNo
String  sSaupj,sUpmuGbn = 'T',sChaDae,sSangGbn,sCusGbn,sYesanGbn,sRemark1,sGbn1,sGbn4,sChGbn,sDepotNo

dw_junpoy.Reset()
dw_sang.Reset()
dw_jbill.Reset()
dw_sungin.Reset()

dw_cond.AcceptText()
tab_gyel.tabpage_method.dw_method.AcceptText()

iRowCount = dw_junpoylst.Retrieve(sgyeldate,lgyelseq)
IF iRowCount <= 0 THEN Return 1

sSaupj = dw_cond.GetItemString(1,"saupj")

IF Wf_Setting_Acc() = -1 THEN Return -1

IF F_Check_LimitDate(sgyeldate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
		
lJunPoyNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sgyeldate)

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
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('5',tab_gyel.tabpage_method.dw_method.GetItemString(1,"depotno"),'1')) 
			ELSEIF sGbn1 = '2' THEN											/*금융기관*/
				dw_junpoy.SetItem(iCurRow,"saup_no", tab_gyel.tabpage_method.dw_method.GetItemString(1,"chaip_no")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   &
											F_Get_PersonLst('2',tab_gyel.tabpage_method.dw_method.GetItemString(1,"chaip_no"),'1')) 											
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

		IF sRemark1 = 'Y' AND sChaDae = LsAryChaDae[k] THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_cond.GetItemString(1,"sdeptcode"))
		END IF
		
		IF k = 4 THEN
			dw_junpoy.SetItem(iCurRow,"k_eymd",    tab_gyel.tabpage_method.dw_method.GetItemString(1,"bmandate")) 
			dw_junpoy.SetItem(iCurRow,"kwan_no",   dw_junpoylst.GetItemString(1,"saup_no")) 			
		ELSEIF k = 5 THEN
			dw_junpoy.SetItem(iCurRow,"kwan_no",   tab_gyel.tabpage_method.dw_method.GetItemString(1,"chaip_no")) 
			dw_junpoy.SetItem(iCurRow,"k_eymd",    tab_gyel.tabpage_method.dw_method.GetItemString(1,"bmandate")) 
		ELSEIF k = 8 THEN
			dw_junpoy.SetItem(iCurRow,"kwan_no",   tab_gyel.tabpage_method.dw_method.GetItemString(1,"kwan_no")) 			
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

on w_kglc30.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_list=create dw_list
this.dw_save=create dw_save
this.dw_junpoy=create dw_junpoy
this.dw_junpoylst=create dw_junpoylst
this.dw_sang=create dw_sang
this.dw_jbill=create dw_jbill
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.tab_gyel=create tab_gyel
this.st_2=create st_2
this.em_gyelamt=create em_gyelamt
this.st_3=create st_3
this.em_descamt=create em_descamt
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_bill_detail=create dw_bill_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_save
this.Control[iCurrent+6]=this.dw_junpoy
this.Control[iCurrent+7]=this.dw_junpoylst
this.Control[iCurrent+8]=this.dw_sang
this.Control[iCurrent+9]=this.dw_jbill
this.Control[iCurrent+10]=this.dw_sungin
this.Control[iCurrent+11]=this.dw_print
this.Control[iCurrent+12]=this.tab_gyel
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.em_gyelamt
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.em_descamt
this.Control[iCurrent+17]=this.rr_1
this.Control[iCurrent+18]=this.rr_2
this.Control[iCurrent+19]=this.dw_bill_detail
end on

on w_kglc30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_list)
destroy(this.dw_save)
destroy(this.dw_junpoy)
destroy(this.dw_junpoylst)
destroy(this.dw_sang)
destroy(this.dw_jbill)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.tab_gyel)
destroy(this.st_2)
destroy(this.em_gyelamt)
destroy(this.st_3)
destroy(this.em_descamt)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_bill_detail)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

tab_gyel.tabpage_desc.dw_detail.SetTransObject(SQLCA)
tab_gyel.tabpage_method.dw_method.SetTransObject(SQLCA)

dw_save.SetTransObject(SQLCA)
dw_junpoy.SetTransObject(SQLCA)
dw_junpoylst.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)
dw_jbill.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_sungin.SetTransObject(SQLCA)
dw_bill_detail.SetTransObject(SQLCA)

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
	LsPayFeeGbn = '1'
ELSE
	IF IsNull(LsPayFeeGbn) THEN LsPayFeeGbn = 'N'
END IF

end event

type dw_insert from w_inherite`dw_insert within w_kglc30
boolean visible = false
integer x = 1449
integer width = 96
integer height = 52
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc30
boolean visible = false
integer x = 3662
integer y = 2756
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc30
boolean visible = false
integer x = 3479
integer y = 2756
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc30
boolean visible = false
integer x = 3278
integer y = 2768
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglc30
integer x = 3557
integer taborder = 50
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\전표처리_up.gif"
end type

event p_ins::clicked;call super::clicked;Open(W_Kglc31)

IF sModStatus = 'M' then
	Wf_Init()
END IF

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\전표처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\전표처리_up.gif"
end event

type p_exit from w_inherite`p_exit within w_kglc30
integer x = 4430
end type

type p_can from w_inherite`p_can within w_kglc30
integer x = 4256
end type

event p_can::clicked;call super::clicked;ROLLBACK;

Wf_Init()

Integer k

IF Lstr_PayGyel[1].AryCnt = 0 OR IsNull(Lstr_PayGyel[1].AryCnt) THEN Return

For k = 1 TO Lstr_PayGyel[1].AryCnt
	SetNull(Lstr_PayGyel[k].bill_gbn)
	SetNull(Lstr_PayGyel[k].billno)
	SetNull(Lstr_PayGyel[k].bbaldate)
	SetNull(Lstr_PayGyel[k].bmandate)
	SetNull(Lstr_PayGyel[k].bill_nm)
	SetNull(Lstr_PayGyel[k].billamt)
NEXT
		

end event

type p_print from w_inherite`p_print within w_kglc30
boolean visible = false
integer x = 3845
integer y = 2752
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String sSaupj,sUpmuGbn,sBalDate,sPrtGbn = '0',sJunGbn = '1'
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

type p_inq from w_inherite`p_inq within w_kglc30
integer x = 3735
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,sAcc1,sAcc2,sGbn,sCust

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

IF sAcc1 = '%' and sAcc2 = '%' THEN
	sGbn = 'Y'	
ELSE
	sGbn = '%'
END IF

IF sCust = "" OR IsNull(sCust) THEN sCust = '%'

IF sModStatus = 'I' THEN
	sSaupj = '%'
ELSE
	sSaupj = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
END IF

IF dw_list.Retrieve(sBaseDate,sAcc1,sAcc2,sGbn,sCust,sSaupj) <=0 THEN
	
	F_MessageChk(14,'')
		
	Wf_Init()
	
	Return
END IF

tab_gyel.tabpage_desc.dw_detail.SetRedraw(False)

dw_list.SelectRow(0,False)
dw_list.SelectRow(1,True)
dw_list.ScrollToRow(1)

IF sModStatus = 'I' THEN
	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(1,"saup_no"),sAcc1,sAcc2,sSaupj)
ELSE
	tab_gyel.tabpage_desc.dw_detail.Retrieve(dw_list.GetItemString(1,"saup_no"),sAcc1,sAcc2,sSaupj)
END IF

tab_gyel.tabpage_desc.dw_detail.ScrollToRow(1)
tab_gyel.tabpage_desc.dw_detail.SetColumn("chkflag")
tab_gyel.tabpage_desc.dw_detail.SetFocus()

tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)



end event

type p_del from w_inherite`p_del within w_kglc30
integer x = 4082
end type

event p_del::clicked;call super::clicked;Integer iSelectRow,iRowCount,k
String  sBalDate,sGyelDate,sLoNo
Long    lSeqNo
Double  dChaIpAmt,dRemain

iSelectRow = tab_gyel.tabpage_desc.dw_detail.GetSelectedRow(0)
IF iSelectRow <=0 Then
	F_MessageChk(11,'')
	dw_cond.SetFocus()
	Return
END IF

sBalDate = tab_gyel.tabpage_desc.dw_detail.GetItemSTring(iSelectRow,"abal_date")
IF sBalDate <> "" AND Not IsNull(sBalDate) THEN
	F_MessageChk(49,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN Return 

sGyelDate = tab_gyel.tabpage_desc.dw_detail.GetItemString(iSelectRow,"gyel_date")
lSeqNo    = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(iSelectRow,"seqno")

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.DeleteRow(0)

iRowCount = dw_bill_detail.RowCount()
For k = iRowCount TO 1 Step -1
	dw_bill_detail.DeleteRow(k)	
NEXT

IF tab_gyel.tabpage_method.dw_method.Update() = 1 AND dw_bill_detail.Update() = 1 THEN
	DELETE FROM "KFZ19OT2"  
   	WHERE ( "KFZ19OT2"."GYEL_DATE" = :sGyelDate ) AND ( "KFZ19OT2"."SEQNO" = :lSeqNo )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(12,'[결제내역]')
		Rollback;
		tab_gyel.tabpage_method.dw_method.SetRedraw(True)
		Return
	ELSE
		COMMIT;
		w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
	END IF
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

p_inq.TriggerEvent(Clicked!)





end event

type p_mod from w_inherite`p_mod within w_kglc30
integer x = 3909
integer taborder = 40
end type

event p_mod::clicked;Double  dSelectAmt
Integer iRtnValue,iSelectRow
Long    lGyelSeq
String  sBalDate,sJBalDate

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
	
	sJBalDate = Trim(tab_gyel.tabpage_desc.dw_detail.GetItemSTring(iSelectRow,"abal_date"))
	IF sJBalDate <> "" AND Not IsNull(sJBalDate) THEN
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
iRtnValue = Wf_Save(sBalDate,lGyelSeq)
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

IF MessageBox("확 인","전표로 발행하시겠습니까?",Question!,YesNo!) = 1 THEN 
	IF Wf_Create_Kfz12ot0(sBalDate,lGyelSeq) = -1 THEN
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
		
		p_print.TriggerEvent(Clicked!)
		
		w_mdi_frame.sle_msg.text = '전표처리를 완료하였습니다!!'
	END IF
END IF
SetPointer(Arrow!)

//Wf_Init()
tab_gyel.tabpage_method.dw_method.Enabled = True

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_kglc30
boolean visible = false
integer x = 4169
integer y = 2576
end type

type cb_mod from w_inherite`cb_mod within w_kglc30
boolean visible = false
integer x = 3099
integer y = 2576
end type

type cb_ins from w_inherite`cb_ins within w_kglc30
boolean visible = false
integer x = 2290
integer y = 2568
integer width = 453
integer height = 124
string text = "전표처리(&A)"
end type

type cb_del from w_inherite`cb_del within w_kglc30
boolean visible = false
integer x = 3456
integer y = 2576
end type

type cb_inq from w_inherite`cb_inq within w_kglc30
boolean visible = false
integer x = 2752
integer y = 2576
end type

type cb_print from w_inherite`cb_print within w_kglc30
boolean visible = false
integer x = 2766
integer y = 2712
end type

type st_1 from w_inherite`st_1 within w_kglc30
end type

type cb_can from w_inherite`cb_can within w_kglc30
boolean visible = false
integer x = 3813
integer y = 2576
end type

type cb_search from w_inherite`cb_search within w_kglc30
boolean visible = false
integer x = 2272
integer y = 2712
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc30
integer x = 2830
end type

type sle_msg from w_inherite`sle_msg within w_kglc30
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_kglc30
integer x = 9
integer width = 3584
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc30
boolean visible = false
integer x = 37
integer y = 1896
integer width = 416
integer height = 172
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc30
boolean visible = false
integer x = 2117
integer y = 1896
integer width = 1477
integer height = 172
end type

type dw_cond from u_key_enter within w_kglc30
event ue_key pbm_dwnkey
integer x = 27
integer y = 168
integer width = 4590
integer height = 296
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kglc201"
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
//		
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
//		this.SetItem(iCurRow,"empno",snull)
//		this.SetItem(iCurRow,"empname",snull)
//		Return 1
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

type rb_1 from radiobutton within w_kglc30
integer x = 78
integer y = 52
integer width = 215
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
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'I'									

Wf_Init()

end event

type rb_2 from radiobutton within w_kglc30
integer x = 306
integer y = 52
integer width = 215
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
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;sModStatus = 'M'									

Wf_Init()

end event

type dw_list from u_key_enter within w_kglc30
integer x = 55
integer y = 484
integer width = 1029
integer height = 1732
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_kglc202"
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
	tab_gyel.tabpage_desc.dw_detail.Retrieve(sBaseDate,dw_list.GetItemString(row,"saup_no"),sAcc1,sAcc2,sSaupj)
ELSE
	tab_gyel.tabpage_desc.dw_detail.Retrieve(dw_list.GetItemString(row,"saup_no"),sAcc1,sAcc2,sSaupj)
END IF

tab_gyel.tabpage_desc.dw_detail.SetRedraw(True)

tab_gyel.tabpage_method.dw_method.SetRedraw(False)
tab_gyel.tabpage_method.dw_method.Reset()
tab_gyel.tabpage_method.dw_method.InsertRow(0)
tab_gyel.tabpage_method.dw_method.SetRedraw(True)

em_descamt.text = String(0,'###,###,###,##0')
em_gyelamt.text = String(0,'###,###,###,##0')

tab_gyel.SelectedTab = 1



end event

type dw_save from datawindow within w_kglc30
boolean visible = false
integer x = 69
integer y = 2520
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "결제내역 저장"
string dataobject = "d_kifa105"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_junpoy from datawindow within w_kglc30
boolean visible = false
integer x = 69
integer y = 2644
integer width = 1234
integer height = 128
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

type dw_junpoylst from datawindow within w_kglc30
boolean visible = false
integer x = 69
integer y = 2732
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

type dw_sang from datawindow within w_kglc30
boolean visible = false
integer x = 1307
integer y = 2636
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

type dw_jbill from datawindow within w_kglc30
boolean visible = false
integer x = 1307
integer y = 2740
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

type dw_sungin from datawindow within w_kglc30
boolean visible = false
integer x = 69
integer y = 2828
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

type dw_print from datawindow within w_kglc30
boolean visible = false
integer x = 1307
integer y = 2836
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

type tab_gyel from tab within w_kglc30
integer x = 1115
integer y = 476
integer width = 3474
integer height = 1756
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
integer width = 3438
integer height = 1644
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
integer height = 1616
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from u_key_enter within tabpage_desc
integer x = 14
integer y = 28
integer width = 3401
integer height = 1600
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kglc203"
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
	IF this.GetItemString(row,"abal_date") = "" OR IsNull(this.GetItemString(row,"abal_date")) THEN
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
	if sModStatus = 'I'	then
		this.SetItem(row,'gyelamt',this.GetItemNumber(row,"remain_amt"))
	end if
END IF
end event

type tabpage_method from userobject within tab_gyel
integer x = 18
integer y = 96
integer width = 3438
integer height = 1644
long backcolor = 32106727
string text = "결제방법"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_method dw_method
end type

on tabpage_method.create
this.rr_4=create rr_4
this.dw_method=create dw_method
this.Control[]={this.rr_4,&
this.dw_method}
end on

on tabpage_method.destroy
destroy(this.rr_4)
destroy(this.dw_method)
end on

type rr_4 from roundrectangle within tabpage_method
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

type dw_method from u_key_enter within tabpage_method
event ue_key pbm_dwnkey
integer x = 169
integer y = 140
integer width = 3186
integer height = 884
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kglc304"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event buttonclicked;Integer   k,iCurRow,iFindRow,iCount,iSeqNo
Double    dDescAmt,dGyelAmt,dSilGyelAmt
String    sGyelDate

IF tab_gyel.tabpage_desc.dw_detail.RowCount() <=0 THEN Return

IF dwo.name = 'dcb_bill_detail' THEN
	
	/*결제금액*/
	dGyelAmt = this.GetItemNumber(1,"billamt")
	IF IsNull(dGyelAmt) THEN dGyelAmt = 0

	IF sModStatus = 'I' THEN
		sGyelDate = dw_cond.GetItemString(1,"baldate")	
		iSeqNo    = 0
	ELSE
		sGyelDate = this.GetItemString(1,"gyel_date")	
		iSeqNo    = this.GetItemNumber(1,"seqno")	
	END IF

	OpenWithParm(w_kglc30a,sGyelDate+String(iSeqNo,'0000')+String(dGyelAmt))

	dw_bill_detail.Reset()
	if Message.StringParm = '1' then		
		dw_bill_detail.ImportClipboard()	
		
		for k = 1 to dw_bill_detail.RowCount()
			dw_bill_detail.SetItem(k,"gyel_date", sGyelDate)
			dw_bill_detail.SetItem(k,"seqno",     iSeqNo)
		next
	end if
	
	Wf_Display_GyelAmt()
END IF

end event

event itemchanged;Double dAmount,dAmount1,dAmount2,dAmount3,dBillCash,dChaIpAmt,lnull,dDescAmt
String sDepotNo,sCheckNo,sAcc1,sAcc2,sBalGbn,snull,sPayMethod,sChNo

SetNull(snull)
SetNull(lnull)

dDescAmt = tab_gyel.tabpage_desc.dw_detail.GetItemNumber(1,"sum_yamt")
IF IsNull(dDescAmt) THEN dDescAmt = 0
		
IF this.GetColumnName() = "pay_method" THEN
	sPayMethod = this.GetText()
	if sPayMethod = '' or IsNull(sPayMethod) then Return
	
	dAmount1 = this.GetItemNumber(1,"accamt")
	if IsNull(dAmount1) then dAmount1 = 0
	
	dAmount2 = this.GetItemNumber(1,"accamt2")
	if IsNull(dAmount2) then dAmount2 = 0
	
	dAmount3 = this.GetItemNumber(1,"accamt3")
	if IsNull(dAmount3) then dAmount3 = 0
	
	Wf_Setting_Remain(sPayMethod,dDescAmt - dAmount1 - dAmount2 - dAmount3)
END IF

IF this.GetColumnName() = "cashamt" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
END IF

IF this.GetColumnName() = "depotamt" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
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

IF this.GetColumnName() = "accamt_fund" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
END IF

IF this.GetColumnName() = "chaip_no" THEN
	sChNo = this.GetText()
	IF sChNo = "" OR IsNull(sChNo) THEN Return
	
	IF IsNull(F_Get_Personlst('2',sChNo,'1')) THEN
		F_MessageChk(20,'[금융기관]')
		this.SetItem(this.GetRow(),"chaip_no",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"chaipname",F_Get_Personlst('2',sChNo,'1'))
	END IF
END IF

IF this.GetColumnName() = "accamt_sell" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
END IF

IF this.GetColumnName() = "billamt" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
END IF

IF this.GetColumnName() = "checkamt" THEN
	dAmount = Double(this.GetText())
	
	IF IsNull(dAmount) THEN Return 1	
END IF

IF this.GetColumnName() = "checkcode" THEN
	sDepotNo = this.GetText()
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN Return
	
	IF IsNull(F_Get_Personlst('5',sDepotNo,'1')) THEN
		F_MessageChk(20,'[예적금코드]')
		this.SetItem(this.GetRow(),"checkcode",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"ckname",  F_Get_Personlst('5',sDepotNo,'1'))
	END IF
END IF

IF this.GetColumnName() = "checkno" THEN
	sCheckNo = this.GetText()
	IF sCheckNo = "" OR IsNull(sCheckNo) THEN Return
	
	IF Wf_Dup_Chk(sCheckNo,'1','CHECK') = -1 THEN Return 1
END IF

IF this.GetColumnName() = "accamt" THEN
	dAmount1 = Double(this.GetText())
	IF IsNull(dAmount1) THEN Return 1	
	
	sPayMethod = this.GetItemString(1,"pay_method")
	
	dAmount2 = this.GetItemNumber(1,"accamt2")
	if IsNull(dAmount2) then dAmount2 = 0
	
	dAmount3 = this.GetItemNumber(1,"accamt3")
	if IsNull(dAmount3) then dAmount3 = 0
	
	Wf_Setting_Remain(sPayMethod,dDescAmt - dAmount1 - dAmount2 - dAmount3)
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

IF this.GetColumnName() = "kwan_no" THEN
	sDepotNo = this.GetText()
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN Return
	
	IF IsNull(F_Get_Personlst('91',sDepotNo,'1')) THEN
		F_MessageChk(20,'[대여금코드]')
		this.SetItem(this.GetRow(),"kwan_no",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"lendname",F_Get_Personlst('91',sDepotNo,'1'))
	END IF
END IF

IF this.GetColumnName() = "accamt2" THEN
	dAmount2 = Double(this.GetText())
	IF IsNull(dAmount2) THEN Return 1	
	
	sPayMethod = this.GetItemString(1,"pay_method")
	
	dAmount1 = this.GetItemNumber(1,"accamt")
	if IsNull(dAmount1) then dAmount1 = 0
	
	dAmount3 = this.GetItemNumber(1,"accamt3")
	if IsNull(dAmount3) then dAmount3 = 0
	
	Wf_Setting_Remain(sPayMethod,dDescAmt - dAmount1 - dAmount2 - dAmount3)
	
END IF

IF this.GetColumnName() = "accamt3" THEN
	dAmount3 = Double(this.GetText())
	IF IsNull(dAmount3) THEN Return 1	
	
	sPayMethod = this.GetItemString(1,"pay_method")
	
	dAmount1 = this.GetItemNumber(1,"accamt")
	if IsNull(dAmount1) then dAmount1 = 0
	
	dAmount2 = this.GetItemNumber(1,"accamt2")
	if IsNull(dAmount2) then dAmount2 = 0
	
	Wf_Setting_Remain(sPayMethod,dDescAmt - dAmount1 - dAmount2 - dAmount3)
	
END IF

IF this.GetColumnName() = "ijaamt" THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) THEN Return 1	
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
IF this.GetColumnName() ="kwan_no" THEN						/*대여금코드*/
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"kwan_no"),1))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	lstr_custom.name = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'91')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"kwan_no",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="depotno" THEN						/*예적금*/
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"depotno"),1))
	
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2)  
   	INTO :lstr_account.acc1_cd,			 :lstr_account.acc2_cd  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '22' )   ;
			
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	lstr_custom.name = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'5')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"depotno",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="chaip_no" THEN						/*차입금*/
	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"chaip_no"),1))

	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	lstr_custom.name = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"chaip_no",lstr_custom.code)
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
	
	this.SetItem(this.GetRow(),"checkno",gs_code)
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

type st_2 from statictext within w_kglc30
integer x = 2766
integer y = 492
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

type em_gyelamt from editmask within w_kglc30
integer x = 3122
integer y = 492
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

type st_3 from statictext within w_kglc30
integer x = 1792
integer y = 492
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

type em_descamt from editmask within w_kglc30
integer x = 2203
integer y = 492
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

type rr_1 from roundrectangle within w_kglc30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 24
integer width = 517
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kglc30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 472
integer width = 1061
integer height = 1756
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_bill_detail from datawindow within w_kglc30
boolean visible = false
integer x = 1303
integer y = 2496
integer width = 882
integer height = 128
boolean bringtotop = true
boolean titlebar = true
string title = "어음결제 상세 저장"
string dataobject = "d_kglc20a2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

