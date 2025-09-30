$PBExportHeader$w_kgla12b.srw
$PBExportComments$거래처 기초잔액 등록-통화단위별
forward
global type w_kgla12b from w_inherite
end type
type dw_disp from datawindow within w_kgla12b
end type
type dw_ins from u_key_enter within w_kgla12b
end type
type rr_1 from roundrectangle within w_kgla12b
end type
end forward

global type w_kgla12b from w_inherite
integer x = 59
integer y = 304
integer width = 3707
integer height = 1716
string title = "통화별 기초잔액 등록"
boolean controlmenu = false
boolean minbox = false
windowtype windowtype = response!
dw_disp dw_disp
dw_ins dw_ins
rr_1 rr_1
end type
global w_kgla12b w_kgla12b

type variables
String LsDcrGbn
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_requiredchk (integer irow);String sSaupj,sAccYm,sAcc,sSaupNo,sKwanNo

dw_disp.AcceptText()
sSaupj  = dw_disp.GetItemString(1,"saupj")
sAccYm  = dw_disp.GetItemString(1,"accym")
sAcc    = dw_disp.GetItemString(1,"acccode")
sSaupNo = dw_disp.GetItemString(1,"saupno")

dw_ins.AcceptText()
sKwanNo = dw_ins.GetItemString(irow,"kwan_no")

IF sSaupj = '' OR IsNull(sSaupj) THEN
	F_Messagechk(1,'[사업장]')
	cb_ins.SetFocus()
	Return -1
END IF
IF sAccYm = '' OR IsNull(sAccYm) THEN
	F_Messagechk(1,'[회계년월]')
	cb_ins.SetFocus()
	Return -1
END IF
IF sAcc = '' OR IsNull(sAcc) THEN
	F_Messagechk(1,'[계정과목]')
	cb_ins.SetFocus()
	Return -1
END IF
IF sSaupNo = '' OR IsNull(sSaupNo) THEN
	F_Messagechk(1,'[거래처]')
	cb_ins.SetFocus()
	Return -1
END IF

IF sKwanNo = '' OR IsNull(sKwanNo) THEN
	F_Messagechk(1,'[관리항목]')
	dw_ins.Setcolumn("kwan_no")
	dw_ins.SetFocus()
	Return -1
END IF

IF IsNull(dw_ins.GetItemNumber(iRow,"ydr_amt")) THEN
	dw_ins.SetItem(iRow,"ydr_amt",0)
END IF
IF IsNull(dw_ins.GetItemNumber(iRow,"ycr_amt")) THEN
	dw_ins.SetItem(iRow,"ycr_amt",0)
END IF
IF IsNull(dw_ins.GetItemNumber(iRow,"yjan_amt")) THEN
	dw_ins.SetItem(iRow,"yjan_amt",0)
END IF

IF IsNull(dw_ins.GetItemNumber(iRow,"dr_amt")) THEN
	dw_ins.SetItem(iRow,"dr_amt",0)
END IF
IF IsNull(dw_ins.GetItemNumber(iRow,"cr_amt")) THEN
	dw_ins.SetItem(iRow,"cr_amt",0)
END IF
IF IsNull(dw_ins.GetItemNumber(iRow,"jan_amt")) THEN
	dw_ins.SetItem(iRow,"jan_amt",0)
END IF
Return 1
end function

on w_kgla12b.create
int iCurrent
call super::create
this.dw_disp=create dw_disp
this.dw_ins=create dw_ins
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_disp
this.Control[iCurrent+2]=this.dw_ins
this.Control[iCurrent+3]=this.rr_1
end on

on w_kgla12b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_disp)
destroy(this.dw_ins)
destroy(this.rr_1)
end on

event open;call super::open;String sMsg

F_Window_Center_Response(This)

sMsg = Message.StringParm

dw_disp.SetTransObject(sqlca)
dw_disp.Reset()
dw_disp.InsertRow(0)

dw_disp.SetItem(1,"saupj",      Left(sMsg,2))
dw_disp.SetItem(1,"accym",      Mid(sMsg,3,6))
dw_disp.SetItem(1,"acccode",    Mid(sMsg,9,7))

select dc_gu into :LsDcrGbn from kfz01om0 where acc1_cd||acc2_cd = substr(:sMsg,9,7) ;

sMsg = Mid(sMsg,16,60)

dw_disp.SetItem(1,"saupno",     Left(sMsg,Pos(sMsg,'-') - 1))
dw_disp.SetItem(1,"saupname",   Mid(sMsg,Pos(sMsg,'-') + 1,30))

dw_ins.SetTransObject(sqlca)
dw_ins.Reset()

if dw_ins.Retrieve(dw_disp.GetItemString(1,"saupj"),&
						 dw_disp.GetItemString(1,"accym"),&
						 dw_disp.GetItemString(1,"acccode"),&
						 dw_disp.GetItemString(1,"saupno")) <=0 then
	cb_ins.SetFocus()
else
	dw_ins.SetFocus()
end if





end event

type dw_insert from w_inherite`dw_insert within w_kgla12b
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla12b
boolean visible = false
integer x = 4032
integer y = 1716
end type

type p_addrow from w_inherite`p_addrow within w_kgla12b
boolean visible = false
integer x = 3858
integer y = 1716
end type

type p_search from w_inherite`p_search within w_kgla12b
boolean visible = false
integer x = 3314
integer y = 1712
end type

type p_ins from w_inherite`p_ins within w_kgla12b
integer x = 2811
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_ins.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_ins.InsertRow(iCurRow)

	dw_ins.ScrollToRow(iCurRow)
	dw_ins.SetItem(iCurRow,'sflag','I')
	
	dw_ins.SetItem(iCurRow,"saupj",   dw_disp.GetItemString(1,"saupj"))
	dw_ins.SetItem(iCurRow,"acc_yy",  Left(dw_disp.GetItemString(1,"accym"),4))
	dw_ins.SetItem(iCurRow,"acc_mm",  Right(dw_disp.GetItemString(1,"accym"),2))
	dw_ins.SetItem(iCurRow,"acc1_cd", Left(dw_disp.GetItemString(1,"acccode"),5))
	dw_ins.SetItem(iCurRow,"acc2_cd", Right(dw_disp.GetItemString(1,"acccode"),2))
	dw_ins.SetItem(iCurRow,"saup_no", dw_disp.GetItemString(1,"saupno"))
	
	dw_ins.SetColumn("kwan_no")
	dw_ins.SetFocus()
	
	ib_any_typing = False

END IF



end event

type p_exit from w_inherite`p_exit within w_kgla12b
integer x = 3506
end type

type p_can from w_inherite`p_can within w_kgla12b
integer x = 3333
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_disp.AcceptText()

dw_ins.SetRedraw(False)
IF dw_ins.Retrieve(dw_disp.GetItemString(1,"saupj"),&
						 dw_disp.GetItemString(1,"accym"),&
						 dw_disp.GetItemString(1,"acccode"),&
						 dw_disp.GetItemString(1,"saupno")) > 0 THEN
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
ELSE
	p_ins.SetFocus()
END IF
dw_ins.SetRedraw(True)

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_kgla12b
boolean visible = false
integer x = 3488
integer y = 1712
end type

type p_inq from w_inherite`p_inq within w_kgla12b
boolean visible = false
integer x = 3662
integer y = 1712
end type

type p_del from w_inherite`p_del within w_kgla12b
integer x = 3159
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ins.DeleteRow(dw_ins.GetRow())
IF dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(k,'sflag','M')
	NEXT
	
	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kgla12b
integer x = 2985
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_ins.AcceptText() = -1 THEN Return

IF dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO dw_ins.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(k,'sflag','M')
	NEXT

	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kgla12b
integer x = 3113
integer y = 1824
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_kgla12b
integer x = 2043
integer y = 1824
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_ins.AcceptText() = -1 THEN Return

IF dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO dw_ins.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(k,'sflag','M')
	NEXT

	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF


end event

type cb_ins from w_inherite`cb_ins within w_kgla12b
integer x = 64
integer y = 1824
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

sle_msg.text =""

iRowCount = dw_ins.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_ins.InsertRow(iCurRow)

	dw_ins.ScrollToRow(iCurRow)
	dw_ins.SetItem(iCurRow,'sflag','I')
	
	dw_ins.SetItem(iCurRow,"saupj",   dw_disp.GetItemString(1,"saupj"))
	dw_ins.SetItem(iCurRow,"acc_yy",  Left(dw_disp.GetItemString(1,"accym"),4))
	dw_ins.SetItem(iCurRow,"acc_mm",  Right(dw_disp.GetItemString(1,"accym"),2))
	dw_ins.SetItem(iCurRow,"acc1_cd", Left(dw_disp.GetItemString(1,"acccode"),5))
	dw_ins.SetItem(iCurRow,"acc2_cd", Right(dw_disp.GetItemString(1,"acccode"),2))
	dw_ins.SetItem(iCurRow,"saup_no", dw_disp.GetItemString(1,"saupno"))
	
	dw_ins.SetColumn("kwan_no")
	dw_ins.SetFocus()
	
	ib_any_typing = False

END IF



end event

type cb_del from w_inherite`cb_del within w_kgla12b
integer x = 2400
integer y = 1824
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ins.DeleteRow(dw_ins.GetRow())
IF dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(k,'sflag','M')
	NEXT
	
	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kgla12b
boolean visible = false
integer x = 1138
integer y = 2168
end type

type cb_print from w_inherite`cb_print within w_kgla12b
end type

type st_1 from w_inherite`st_1 within w_kgla12b
boolean visible = false
integer y = 2036
end type

type cb_can from w_inherite`cb_can within w_kgla12b
integer x = 2757
integer y = 1824
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_disp.AcceptText()

dw_ins.SetRedraw(False)
IF dw_ins.Retrieve(dw_disp.GetItemString(1,"saupj"),&
						 dw_disp.GetItemString(1,"accym"),&
						 dw_disp.GetItemString(1,"acccode"),&
						 dw_disp.GetItemString(1,"saupno")) > 0 THEN
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("ydr_amt")
	dw_ins.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_ins.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_kgla12b
integer taborder = 60
end type

type dw_datetime from w_inherite`dw_datetime within w_kgla12b
boolean visible = false
integer y = 2036
end type

type sle_msg from w_inherite`sle_msg within w_kgla12b
boolean visible = false
integer y = 2036
end type

type gb_10 from w_inherite`gb_10 within w_kgla12b
boolean visible = false
integer y = 1984
end type

type gb_button1 from w_inherite`gb_button1 within w_kgla12b
integer x = 27
integer y = 1768
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla12b
integer x = 2002
integer y = 1768
end type

type dw_disp from datawindow within w_kgla12b
integer x = 64
integer y = 28
integer width = 2725
integer height = 264
boolean bringtotop = true
string dataobject = "dw_kgla12b1"
boolean border = false
boolean livescroll = true
end type

type dw_ins from u_key_enter within w_kgla12b
integer x = 82
integer y = 300
integer width = 3493
integer height = 1172
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgla12b2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_any_typing= True
end event

event itemchanged;String   sCurr,sNull
Double   dDr,dCr
Integer  iFindRow

SetNull(sNull)

IF this.GetColumnName() = "kwan_no" THEN
	sCurr = this.GetText()
	IF sCurr = "" OR IsNull(sCurr) THEN RETURN
	
	IF IsNull(F_Get_Refferance('10',sCurr)) THEN
		F_MessageChk(20,'[통화단위]')
		this.SetItem(this.GetRow(),"kwan_no",snull)
		Return 1
	END IF
	
	iFindRow = this.find("kwan_no ='" + sCurr + "'", 1, this.RowCount())

	IF (this.GetRow() <> iFindRow) and (iFindRow <> 0) THEN
		f_MessageChk(10,'[통화단위]')
		this.SetItem(this.GetRow(),"kwan_no",snull)
		RETURN  1
	END IF

END IF

IF this.GetColumnName() = "ydr_amt" THEN
	dDr = Double(this.GetText())
	IF IsNull(dDr) THEN Return 1
	
	dCr = this.GetItemNumber(this.GetRow(),"ycr_amt")
	IF IsNull(dCr) THEN dCr = 0
	
	IF LsDcrGbn = '1' THEN
		this.SetItem(this.GetRow(),"yjan_amt",dDr - dCr)
	ELSE
		this.SetItem(this.GetRow(),"yjan_amt",dCr - dDr)
	END IF
END IF

IF this.GetColumnName() = "ycr_amt" THEN
	dCr = Double(this.GetText())
	IF IsNull(dCr) THEN Return 1
	
	dDr = this.GetItemNumber(this.GetRow(),"ydr_amt")
	IF IsNull(dDr) THEN dDr = 0
	
	IF LsDcrGbn = '1' THEN
		this.SetItem(this.GetRow(),"yjan_amt",dDr - dCr)
	ELSE
		this.SetItem(this.GetRow(),"yjan_amt",dCr - dDr)
	END IF
END IF

IF this.GetColumnName() = "dr_amt" THEN
	dDr = Double(this.GetText())
	IF IsNull(dDr) THEN Return 1
	
	dCr = this.GetItemNumber(this.GetRow(),"cr_amt")
	IF IsNull(dCr) THEN dCr = 0
	
	IF LsDcrGbn = '1' THEN
		this.SetItem(this.GetRow(),"jan_amt",dDr - dCr)
	ELSE
		this.SetItem(this.GetRow(),"jan_amt",dCr - dDr)
	END IF
END IF

IF this.GetColumnName() = "cr_amt" THEN
	dCr = Double(this.GetText())
	IF IsNull(dCr) THEN Return 1
	
	dDr = this.GetItemNumber(this.GetRow(),"dr_amt")
	IF IsNull(dDr) THEN dDr = 0
	
	IF LsDcrGbn = '1' THEN
		this.SetItem(this.GetRow(),"jan_amt",dDr - dCr)
	ELSE
		this.SetItem(this.GetRow(),"jan_amt",dCr - dDr)
	END IF
END IF






end event

event itemerror;Return 1
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type rr_1 from roundrectangle within w_kgla12b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 296
integer width = 3547
integer height = 1184
integer cornerheight = 40
integer cornerwidth = 46
end type

