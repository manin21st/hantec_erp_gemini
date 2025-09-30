$PBExportHeader$w_kglc26.srw
$PBExportComments$지급결제 처리
forward
global type w_kglc26 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc26
end type
type rb_ins from radiobutton within w_kglc26
end type
type rb_mod from radiobutton within w_kglc26
end type
type dw_ins from u_key_enter within w_kglc26
end type
type dw_jigub from datawindow within w_kglc26
end type
type cbx_all from checkbox within w_kglc26
end type
type dw_print from datawindow within w_kglc26
end type
type dw_bill_detail from datawindow within w_kglc26
end type
type rr_1 from roundrectangle within w_kglc26
end type
type rr_2 from roundrectangle within w_kglc26
end type
end forward

global type w_kglc26 from w_inherite
string title = "지급결제 처리"
dw_cond dw_cond
rb_ins rb_ins
rb_mod rb_mod
dw_ins dw_ins
dw_jigub dw_jigub
cbx_all cbx_all
dw_print dw_print
dw_bill_detail dw_bill_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc26 w_kglc26

type variables
String    sBaseDate,LsAutoSungGbn, LsPayFeeGbn
Double  	 LdAryAmt[12]
String    LsAryAcc1[12],LsAryAcc2[12],LsAryChaDae[12],LsAryDescr[12]



end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_requiredchk ()
public function integer wf_seqno ()
end prototypes

public subroutine wf_init ();String sNull,sCurDate

SetNull(sNull)

IF dw_cond.GetRow() <=0 THEN
	SetNull(sCurDate)
ELSE
	sCurDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")
END IF

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)

IF sCurDate = "" OR IsNull(sCurDate) THEN
	dw_cond.SetItem(dw_cond.GetRow(),"basedate",F_Today())
ELSE
	dw_cond.SetItem(dw_cond.GetRow(),"basedate",sCurDate)	
END IF

dw_cond.SetRedraw(True)

dw_cond.SetColumn("basedate")
dw_cond.SetFocus()

dw_ins.SetRedraw(False)

IF sModStatus = 'I' THEN					/*등록*/

	dw_ins.DataObject = 'd_kglc262'
	dw_ins.SetTransObject(SQLCA)
	dw_ins.Reset()
	
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\전표처리_d.gif"
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_print.Enabled = False
	p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
	
	cbx_all.Visible = True

ELSE
	
	dw_ins.DataObject = 'd_kglc263'
	dw_ins.SetTransObject(SQLCA)
	dw_ins.Reset()
	
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\전표처리_up.gif"
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	p_print.Enabled = True
	p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	
	cbx_all.Visible = False
	
END IF

dw_ins.SetRedraw(True)
end subroutine

public function integer wf_requiredchk ();Int    i,iSelRow
Double dGeyAmt,dMiJiAmt,dGoAmt,dJanAmt,dMiAmt,dBillAmt,dCashAmt
String sBankCd,sManDate,sBillNo

iSelRow = dw_ins.GetItemNumber(1,"yescnt")
IF iSelRow = 0 or IsNull(iSelRow) THEN
	F_MessageChk(11,"")
	Return -1
END IF

FOR i = 1 TO dw_ins.RowCount()
	
	IF dw_ins.GetItemString(i,"chkflag") = "N" THEN Continue

	dGeyAmt  = dw_ins.GetItemNumber(i,"gey_amt")
	dMiJiAmt = dw_ins.GetItemNumber(i,"miji_amt")
	dGoAmt   = dw_ins.GetItemNumber(i,"go_amt")
	dJanAmt  = dw_ins.GetItemNumber(i,"jan_amt")
	dMiAmt   = dw_ins.GetItemNumber(i,"mi_amt")
	dBillAmt = dw_ins.GetItemNumber(i,"bill_amt")
	dCashAmt = dw_ins.GetItemNumber(i,"cash_amt")
	
	sBillNo  = dw_ins.GetItemString(i,"bill_no")
	sManDate = dw_ins.GetItemString(i,"bman_date")
	sBankCd  = dw_ins.GetItemString(i,"bank_cd")
	IF IsNull(dGeyAmt)  THEN dGeyAmt = 0
	IF IsNull(dMiJiAmt) THEN dMiJiAmt = 0
	IF IsNull(dGoAmt)   THEN dGoAmt = 0
	IF IsNull(dJanAmt)  THEN dJanAmt = 0
	IF IsNull(dMiAmt)   THEN dMiAmt = 0
	IF IsNull(dBillAmt) THEN dBillAmt = 0
	IF IsNull(dCashAmt) THEN dCashAmt = 0
	
	IF dGeyAmt+dMiJiAmt+dGoAmt+dJanAmt+dMiAmt < dBillAmt+dCashAmt THEN
		Messagebox("확인","지급금액을 확인하십시오!["+String(i)+"행]")
		dw_ins.setrow(i)
		dw_ins.setcolumn("bill_amt")
		dw_ins.setfocus()
		Return -1
	END IF
	
	IF dBillAmt <> 0 AND dCashAmt <> 0 THEN
		Messagebox("확인","현금과 어음을 동시에 처리할수 없습니다!["+String(i)+"행]")
		dw_ins.setrow(i)
		dw_ins.setcolumn("cash_amt")
		dw_ins.setfocus()
		Return -1
	END IF
	
	IF dBillAmt > 0 THEN
		IF sBillNo = "" OR IsNull(sBillNo) THEN
			Messagebox("확인","어음번호를 입력하십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bill_no")
			dw_ins.setfocus()
			Return -1
		END IF
		IF sManDate = "" OR IsNull(sManDate) THEN
			Messagebox("확인","만기일을 입력하십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bman_date")
			dw_ins.setfocus()
			Return -1
		END IF
		IF IsNull(sBankCd) OR sBankCd = "" THEN
			Messagebox("확인","지급은행을 입력하십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bank_cd")
			dw_ins.setfocus()
			Return -1
		END IF
	END IF
	
	IF dCashAmt > 0 THEN
		IF Len(sBillNo) > 0 THEN
			Messagebox("확인","어음번호를 입력하지 마십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bill_no")
			dw_ins.setfocus()
			Return -1
		END IF
		IF Len(sManDate) > 0 THEN
			Messagebox("확인","만기일을 입력하지 마십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bman_date")
			dw_ins.setfocus()
			Return -1
		END IF
		IF Len(sBankCd) > 0 THEN
			Messagebox("확인","지급은행을 입력하지 마십시오!["+String(i)+"행]")
			dw_ins.setrow(i)
			dw_ins.setcolumn("bank_cd")
			dw_ins.setfocus()
			Return -1
		END IF
	END IF
	
NEXT

Return 1
end function

public function integer wf_seqno ();Int   iSeqNo

Select Nvl(Max(seqno),0)+1
  Into :iSeqNo
  From kfz19ota
 Where gyel_date = :sBaseDate;

Return iSeqNo
end function

on w_kglc26.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.rb_ins=create rb_ins
this.rb_mod=create rb_mod
this.dw_ins=create dw_ins
this.dw_jigub=create dw_jigub
this.cbx_all=create cbx_all
this.dw_print=create dw_print
this.dw_bill_detail=create dw_bill_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.rb_ins
this.Control[iCurrent+3]=this.rb_mod
this.Control[iCurrent+4]=this.dw_ins
this.Control[iCurrent+5]=this.dw_jigub
this.Control[iCurrent+6]=this.cbx_all
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_bill_detail
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_kglc26.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.rb_ins)
destroy(this.rb_mod)
destroy(this.dw_ins)
destroy(this.dw_jigub)
destroy(this.cbx_all)
destroy(this.dw_print)
destroy(this.dw_bill_detail)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_cond.SetTransObject(SQLCA)

dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()

rb_ins.Checked = True
rb_ins.TriggerEvent(Clicked!)

dw_jigub.SetTransObject(SQLCA)
dw_bill_detail.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.object.datawindow.print.preview = "yes"
end event

type dw_insert from w_inherite`dw_insert within w_kglc26
boolean visible = false
integer x = 1449
integer width = 96
integer height = 52
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc26
boolean visible = false
integer x = 3662
integer y = 2756
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc26
boolean visible = false
integer x = 3479
integer y = 2756
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc26
boolean visible = false
integer x = 2903
integer y = 2756
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglc26
integer x = 3387
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\전표처리_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\전표처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\전표처리_up.gif"
end event

event p_ins::clicked;call super::clicked;OpenWithParm(W_Kglc28,sBaseDate)

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite`p_exit within w_kglc26
integer x = 4430
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_kglc26
integer x = 4256
integer taborder = 0
end type

event p_can::clicked;call super::clicked;rb_ins.Checked = True
rb_ins.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_kglc26
integer x = 3735
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String sJunMm

dw_cond.AcceptText()

sBaseDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_cond.Setcolumn("basedate")
	dw_cond.SetFocus()
	Return
END IF

Select to_char(add_months(:sBaseDate,-1),'YYYYMM')
  Into :sJunMm
  From dual;

SetPointer(HourGlass!)

IF dw_print.Retrieve(sJunMm,sBaseDate) <=0 THEN
	F_MessageChk(14,'')
	SetPointer(Arrow!)
	Return
END IF

IF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_print)

SetPointer(Arrow!)

w_mdi_frame.sle_msg.text = "인쇄되었습니다!"
end event

type p_inq from w_inherite`p_inq within w_kglc26
integer x = 3561
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;Int    i
Double dHapAmt
String sJunMm

dw_cond.AcceptText()

sBaseDate = dw_cond.GetItemString(dw_cond.GetRow(),"basedate")

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_cond.Setcolumn("basedate")
	dw_cond.SetFocus()
	Return
END IF

Select to_char(add_months(:sBaseDate,-1),'YYYYMM')
  Into :sJunMm
  From dual;

SetPointer(HourGlass!)

dw_ins.SetRedraw(False)

IF dw_ins.Retrieve(sJunMm,sBaseDate) <=0 THEN
	Wf_Init()
	F_MessageChk(14,'')
	dw_ins.SetRedraw(True)
	SetPointer(Arrow!)
	Return
END IF

SetPointer(Arrow!)

dw_ins.SetRedraw(True)

w_mdi_frame.sle_msg.text = "조회되었습니다!"
end event

type p_del from w_inherite`p_del within w_kglc26
integer x = 4082
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Int    i,iSelRow,iSeqNo,iRowCnt

dw_ins.AcceptText()

IF F_DbConFirm("삭제") = 2 THEN Return

iSelRow = dw_ins.GetItemNumber(1,"yescnt")
IF iSelRow = 0 or IsNull(iSelRow) THEN
	F_MessageChk(11,"")
	Return -1
END IF

FOR i = 1 TO dw_ins.RowCount()
	
	IF dw_ins.GetItemString(i,"chkflag") = "N" THEN Continue
	
	dw_jigub.Reset()
	dw_bill_detail.Reset()
	
	iSeqNo = dw_ins.GetItemNumber(i,"seqno")
	
	IF dw_jigub.Retrieve(sBaseDate,iSeqNo) = 0 THEN
		Rollback;
		Messagebox("확인","삭제할 자료가 없습니다!["+String(i)+"행 지급결제 내역]")
		dw_ins.SetRow(i)
		dw_ins.SetColumn("cash_amt")
		dw_ins.SetFocus()
		Return
	END IF

	dw_jigub.DeleteRow(0)
	
	IF dw_jigub.Update() <> 1 THEN
		Rollback;
		F_MessageChk(13,'[지급결제 내역]')
		dw_ins.SetRow(i)
		dw_ins.SetColumn("cash_amt")
		dw_ins.SetFocus()
		Return
	END IF
	
	iRowCnt = dw_bill_detail.Retrieve(sBaseDate,iSeqNo)
	
	IF iRowCnt > 0 THEN
		dw_bill_detail.deleterow(0)
		
		IF dw_bill_detail.Update() <> 1 THEN
			Rollback;
			F_MessageChk(13,'[어음상세]')
			dw_ins.SetRow(i)
			dw_ins.SetColumn("cash_amt")
			dw_ins.SetFocus()
			Return
		END IF
	END IF
	
NEXT

Commit;

p_inq.TriggerEvent(CLicked!)

w_mdi_frame.sle_msg.text = "삭제되었습니다!"
end event

type p_mod from w_inherite`p_mod within w_kglc26
integer x = 3909
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;Int    i,iSeqNo,iCurRow,iRowCnt
Double dWonAmt,dBuAmt,dSaGubAmt,dMiJiAmt,dGoAmt,dJanAmt,dMiAmt,dGeyAmt,dBillAmt,dCashAmt
String sNull,sSaupNo,sSaupNm,sManDate,sBankCd,sBankNm,sBillNo

SetNull(sNull)

dw_ins.AcceptText()

IF F_DbConFirm("저장") = 2 THEN Return

IF Wf_RequiredChk() = -1 THEN Return

IF sModStatus = "I" THEN
	
	dw_jigub.Reset()
	dw_bill_detail.Reset()
	
	iSeqNo = Wf_SeqNo()
	
	FOR i = 1 TO dw_ins.RowCount()
		
		IF dw_ins.GetItemString(i,"chkflag") = "N" THEN Continue
		
		iCurRow = dw_jigub.InsertRow(0)
		
		sSaupNo   = dw_ins.GetItemString(i,"saup_no")
		sSaupNm   = dw_ins.GetItemString(i,"saup_nm")
		dWonAmt   = dw_ins.GetItemNumber(i,"won_amt")
		dBuAmt    = dw_ins.GetItemNumber(i,"bu_amt")
		dSaGubAmt = dw_ins.GetItemNumber(i,"sagub_amt")
		dGeyAmt   = dw_ins.GetItemNumber(i,"gey_amt")
		dMiJiAmt  = dw_ins.GetItemNumber(i,"miji_amt")
		dGoAmt    = dw_ins.GetItemNumber(i,"go_amt")
		dJanAmt   = dw_ins.GetItemNumber(i,"jan_amt")
		dMiAmt    = dw_ins.GetItemNumber(i,"mi_amt")
		dBillAmt  = dw_ins.GetItemNumber(i,"bill_amt")
		dCashAmt  = dw_ins.GetItemNumber(i,"cash_amt")
		sBillNo   = dw_ins.GetItemString(i,"bill_no")
		sManDate  = dw_ins.GetItemString(i,"bman_date")
		sBankCd   = dw_ins.GetItemString(i,"bank_cd")
		sBankNm   = dw_ins.GetItemString(i,"bank_nm")
		
		IF IsNull(dWonAmt)   THEN dWonAmt = 0
		IF IsNull(dBuAmt)    THEN dBuAmt = 0
		IF IsNull(dSaGubAmt) THEN dSaGubAmt = 0
		IF IsNull(dGeyAmt)   THEN dGeyAmt = 0
		IF IsNull(dMiJiAmt)  THEN dMiJiAmt = 0
		IF IsNull(dGoAmt)    THEN dGoAmt = 0
		IF IsNull(dJanAmt)   THEN dJanAmt = 0
		IF IsNull(dMiAmt)    THEN dMiAmt = 0
		IF IsNull(dBillAmt)  THEN dBillAmt = 0
		IF IsNull(dCashAmt)  THEN dCashAmt = 0

		dw_jigub.SetItem(iCurRow,"gyel_date",sBaseDate)
		dw_jigub.SetItem(iCurRow,"seqno",    iSeqNo)
		dw_jigub.SetItem(iCurRow,"saup_no",  sSaupNo)
		dw_jigub.SetItem(iCurRow,"saup_nm",  sSaupNm)
		dw_jigub.SetItem(iCurRow,"won_amt",  dWonAmt)
		dw_jigub.SetItem(iCurRow,"bu_amt",  dBuAmt)
		dw_jigub.SetItem(iCurRow,"sagub_amt",  dSaGubAmt)
		dw_jigub.SetItem(iCurRow,"gey_amt",  dGeyAmt)
		dw_jigub.SetItem(iCurRow,"miji_amt",  dMiJiAmt)
		dw_jigub.SetItem(iCurRow,"go_amt",  dGoAmt)
		dw_jigub.SetItem(iCurRow,"jan_amt", dJanAmt)
		dw_jigub.SetItem(iCurRow,"mi_amt", dMiAmt)
		dw_jigub.SetItem(iCurRow,"bill_amt",  dBillAmt)
		dw_jigub.SetItem(iCurRow,"cash_amt", dCashAmt)
		
		dw_jigub.SetItem(iCurRow,"bill_no",  sBillNo)
		dw_jigub.SetItem(iCurRow,"bman_date",sManDate)
		dw_jigub.SetItem(iCurRow,"bank_cd",  sBankCd)
		dw_jigub.SetItem(iCurRow,"bank_nm",  sBankNm)
		
		IF dBillAmt > 0 THEN
			dw_jigub.SetItem(iCurRow,"type","어음")
		ELSEIF dCashAmt > 0 THEN
			dw_jigub.SetItem(iCurRow,"type","현금")
		ELSE
			dw_jigub.SetItem(iCurRow,"type","사급")
		END IF
		
		IF dBillAmt > 0 THEN
		
			iCurRow = dw_bill_detail.InsertRow(0)
			
			dw_bill_detail.SetItem(iCurRow,"gyel_date",sBaseDate)
			dw_bill_detail.SetItem(iCurRow,"seqno",    iSeqNo)
			dw_bill_detail.SetItem(iCurRow,"bill_gbn", "P")
			dw_bill_detail.SetItem(iCurRow,"billno",   sBillNo)
			dw_bill_detail.SetItem(iCurRow,"bbaldate", sBaseDate)
			dw_bill_detail.SetItem(iCurRow,"bmandate", sManDate)
			dw_bill_detail.SetItem(iCurRow,"bank_cd",  sBankCd)
			dw_bill_detail.SetItem(iCurRow,"billamt",  dBillAmt)
			
		END IF
		
		iSeqNo++
		
	NEXT
	
	IF dw_jigub.Update() <> 1 THEN
		Rollback;
		F_MessageChk(13,'[지급결제 내역]')
		Return
	END IF
	
	IF dw_bill_detail.Update() <> 1 THEN
		Rollback;
		F_MessageChk(13,'[어음상세]')
		Return
	END IF
	
	Commit;
	
	rb_mod.Checked = True
	rb_mod.TriggerEvent(Clicked!)
	
ELSE
	
	FOR i = 1 TO dw_ins.RowCount()
		IF dw_ins.GetItemString(i,"chkflag") = "N" THEN Continue
		
		dw_jigub.Reset()
		dw_bill_detail.Reset()
		
		iSeqNo   = dw_ins.GetItemNumber(i,"seqno")
		
		dBillAmt = dw_ins.GetItemNumber(i,"bill_amt")
		dCashAmt = dw_ins.GetItemNumber(i,"cash_amt")
		sBillNo  = dw_ins.GetItemString(i,"bill_no")
		sManDate = dw_ins.GetItemString(i,"bman_date")
		sBankCd  = dw_ins.GetItemString(i,"bank_cd")
		sBankNm  = dw_ins.GetItemString(i,"bank_nm")
		
		IF IsNull(dBillAmt) THEN dBillAmt = 0
		IF IsNull(dCashAmt) THEN dCashAmt = 0

		IF dw_jigub.Retrieve(sBaseDate,iSeqNo) = 0 THEN
			Rollback;
			Messagebox("확인","조회할 자료가 없습니다!["+String(i)+"행 지급결제 내역]")
			dw_ins.SetRow(i)
			dw_ins.SetColumn("cash_amt")
			dw_ins.SetFocus()
			Return
		END IF

		dw_jigub.SetItem(1,"bill_amt", dBillAmt)
		dw_jigub.SetItem(1,"cash_amt", dCashAmt)
		dw_jigub.SetItem(1,"bill_no",  sBillNo)
		dw_jigub.SetItem(1,"bman_date",sManDate)
		dw_jigub.SetItem(1,"bank_cd",  sBankCd)
		dw_jigub.SetItem(1,"bank_nm",  sBankNm)
		
		IF dw_jigub.Update() <> 1 THEN
			Rollback;
			F_MessageChk(13,'[지급결제 내역]')
			dw_ins.SetRow(i)
			dw_ins.SetColumn("cash_amt")
			dw_ins.SetFocus()
			Return
		END IF
		
		iRowCnt = dw_bill_detail.Retrieve(sBaseDate,iSeqNo)
		
		IF dBillAmt > 0 THEN
			IF iRowCnt > 0 THEN
				dw_bill_detail.SetItem(1,"billno",  sBillNo)
				dw_bill_detail.SetItem(1,"bmandate",sManDate)
				dw_bill_detail.SetItem(1,"bank_cd", sBankCd)
				dw_bill_detail.SetItem(1,"billamt", dBillAmt)
			ELSE
				iCurRow = dw_bill_detail.InsertRow(0)
				
				dw_bill_detail.SetItem(iCurRow,"gyel_date",sBaseDate)
				dw_bill_detail.SetItem(iCurRow,"seqno",    iSeqNo)
				dw_bill_detail.SetItem(iCurRow,"bill_gbn", "P")
				dw_bill_detail.SetItem(iCurRow,"billno",   sBillNo)
				dw_bill_detail.SetItem(iCurRow,"bbaldate", sBaseDate)
				dw_bill_detail.SetItem(iCurRow,"bmandate", sManDate)
				dw_bill_detail.SetItem(iCurRow,"bank_cd",  sBankCd)
				dw_bill_detail.SetItem(iCurRow,"billamt",  dBillAmt)
			END IF
		ELSE
			IF iRowCnt > 0 THEN
				dw_bill_detail.deleterow(0)
			END IF
		END IF
		
		IF dw_bill_detail.Update() <> 1 THEN
			Rollback;
			F_MessageChk(13,'[어음상세]')
			dw_ins.SetRow(i)
			dw_ins.SetColumn("cash_amt")
			dw_ins.SetFocus()
			Return
		END IF
	NEXT
	Commit;
END IF

p_inq.TriggerEvent(CLicked!)
	
w_mdi_frame.sle_msg.text = "저장되었습니다!"
end event

type cb_exit from w_inherite`cb_exit within w_kglc26
integer x = 4169
integer y = 2576
end type

type cb_mod from w_inherite`cb_mod within w_kglc26
integer x = 3099
integer y = 2576
end type

type cb_ins from w_inherite`cb_ins within w_kglc26
integer x = 2290
integer y = 2568
integer width = 453
integer height = 124
string text = "전표처리(&A)"
end type

type cb_del from w_inherite`cb_del within w_kglc26
integer x = 3456
integer y = 2576
end type

type cb_inq from w_inherite`cb_inq within w_kglc26
integer x = 2752
integer y = 2576
end type

type cb_print from w_inherite`cb_print within w_kglc26
integer x = 3566
integer y = 2364
end type

type st_1 from w_inherite`st_1 within w_kglc26
end type

type cb_can from w_inherite`cb_can within w_kglc26
integer x = 3813
integer y = 2576
end type

type cb_search from w_inherite`cb_search within w_kglc26
integer x = 2642
integer y = 2436
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc26
integer x = 2830
end type

type sle_msg from w_inherite`sle_msg within w_kglc26
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_kglc26
integer x = 9
integer width = 3584
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc26
integer x = 37
integer y = 1896
integer width = 416
integer height = 172
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc26
integer x = 2117
integer y = 1896
integer width = 1477
integer height = 172
end type

type dw_cond from u_key_enter within w_kglc26
event ue_key pbm_dwnkey
integer x = 32
integer y = 168
integer width = 782
integer height = 156
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kglc261"
boolean border = false
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sNull
Int    iCurRow

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "basedate" THEN
	sBaseDate = Trim(this.GetText())
	IF sBaseDate = "" OR IsNull(sBaseDate) THEN RETURN
	
	IF F_DateChk(sBaseDate) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(iCurRow,"basedate",sNull)
		Return 1
	END IF
END IF
end event

type rb_ins from radiobutton within w_kglc26
integer x = 55
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
end type

event clicked;sModStatus = 'I'

Wf_Init()
end event

type rb_mod from radiobutton within w_kglc26
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
end type

event clicked;sModStatus = 'M'

Wf_Init()
end event

type dw_ins from u_key_enter within w_kglc26
integer x = 50
integer y = 344
integer width = 4535
integer height = 1868
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_kglc262"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;Int    i,iCurRow,iUseCnt,iSeqNo
Double dBillAmt
String sNull,sManDate,sBnkCd,sBnkNm,sBillNo,sBillNo1,sUseTag

SetNull(sNull)

This.AcceptText()

iCurRow = This.GetRow()

IF This.GetColumnName() = "bill_amt" THEN
	dBillAmt = Double(This.GetText())
	IF dBillAmt = 0 OR IsNull(dBillAmt) THEN
		This.SetItem(iCurRow,"bill_no",sNull)
		This.SetItem(iCurRow,"bman_date",sNull)
		This.SetItem(iCurRow,"bank_cd",sNull)
		This.SetItem(iCurRow,"bank_nm",sNull)
		Return
	END IF
END IF

IF This.GetColumnName() = "bill_no" THEN
	sBillNo = Trim(This.GetText())
	IF sBillNo = "" OR IsNull(sBillNo) THEN Return
	
	FOR i = 1 TO This.rowcount()
		sBillNo1 = This.GetItemString(i,"bill_no")
		
		IF i <> iCurRow THEN
			IF sBillNo = sBillNo1 THEN
				Messagebox("확인","이미 사용한 어음번호입니다!")
				This.SetItem(iCurRow,"bill_no",sNull)
				Return 1
			END IF
		END IF
	NEXT
	
	IF sModStatus = "M" THEN
		iSeqNo = This.GetItemNumber(iCurRow,"seqno")
		
		SELECT COUNT(*)
			INTO :iUseCnt
			FROM "KFZ19OTA"  
			WHERE "KFZ19OTA"."BILL_NO" = :sBillNo
			  AND "KFZ19OTA"."SEQNO" <> :iSeqNo;
	ELSE
		SELECT COUNT(*)
			INTO :iUseCnt
			FROM "KFZ19OTA"  
			WHERE "KFZ19OTA"."BILL_NO" = :sBillNo;
	END IF
		
	IF iUseCnt > 0 THEN
		Messagebox("확인","이미 사용한 어음번호입니다!")
		This.SetItem(iCurRow,"bill_no",sNull)
		Return 1
	END IF
	
	SELECT "KFM06OT0"."USE_GU"
		INTO :sUseTag
		FROM "KFM06OT0"  
		WHERE "KFM06OT0"."CHECK_NO" = :sBillNo;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[수표용지번호]')
		This.SetItem(iCurRow,"bill_no",sNull)
		Return 1
	END IF
	
	IF sUseTag <> "0" THEN
		F_MessageChk(10,'[수표용지번호]')
		This.SetItem(iCurRow,"bill_no",sNull)
		Return 1
	END IF
END IF

IF This.GetColumnName() = "bman_date" THEN
	sManDate = Trim(This.GetText())
	IF sManDate = "" OR IsNull(sManDate) THEN Return
	
	IF F_DateChk(sManDate) = -1 THEN
		F_MessageChk(21,'[만기일자]')
		This.SetItem(iCurRow,"bman_date",sNull)
		Return 1
	END IF
END IF

IF This.GetColumnName() = "bank_cd" THEN
	This.SetItem(iCurRow,"bank_nm",sNull)
	sBnkCd = This.GetText()
	IF sBnkCd = "" OR IsNull(sBnkCd) THEN Return
	
	SELECT "KFZ04OM0_V2"."PERSON_NM"
		INTO :sBnkNm
    	FROM "KFZ04OM0_V2"  
   	WHERE "KFZ04OM0_V2"."PERSON_CD" = :sBnkCd;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[지급은행]')
		This.SetItem(iCurRow,"bank_cd",sNull)
		Return 1
	END IF
	This.SetItem(iCurRow,"bank_nm",sbnkNm)
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;Int   iCurRow

SetNull(gs_code)
SetNull(gs_codename)

iCurRow = This.GetRow()

IF This.GetColumnName() = "bill_no" THEN
	OpenWithParm(W_KFM06OT0_POPUP,'2')
	
	IF gs_code = "" OR IsNull(gs_code) THEN REturn
	
	This.SetItem(This.GetRow(),"bill_no",gs_code)
	This.TriggerEvent(ItemChanged!)
END IF

IF This.GetColumnName() ="bank_cd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = Trim(This.GetItemString(This.GetRow(),"bank_cd"))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	This.SetItem(This.GetRow(),"bank_cd",lstr_custom.code)
	This.SetItem(This.GetRow(),"bank_nm",lstr_custom.name)
END IF
end event

event getfocus;call super::getfocus;This.AcceptText()

F_Toggle_Eng(Handle(this))
end event

type dw_jigub from datawindow within w_kglc26
boolean visible = false
integer x = 64
integer y = 2432
integer width = 955
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "지급결제 저장"
string dataobject = "d_kglc265"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type cbx_all from checkbox within w_kglc26
integer x = 910
integer y = 260
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Int    i

IF This.Checked = True THEN
	FOR i = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(i,"chkflag","Y")
	NEXT
ELSE
	FOR i = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(i,"chkflag","N")
	NEXT
END IF
end event

type dw_print from datawindow within w_kglc26
boolean visible = false
integer x = 3200
integer y = 44
integer width = 146
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_kglc263_p"
boolean livescroll = true
end type

type dw_bill_detail from datawindow within w_kglc26
integer x = 64
integer y = 2540
integer width = 955
integer height = 96
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "어음상세 저장"
string dataobject = "d_kglc267"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglc26
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

type rr_2 from roundrectangle within w_kglc26
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 4567
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

