$PBExportHeader$w_kcda03.srw
$PBExportComments$참조코드등록
forward
global type w_kcda03 from w_inherite
end type
type dw_list from u_d_popup_sort within w_kcda03
end type
type rb_1 from radiobutton within w_kcda03
end type
type rb_3 from radiobutton within w_kcda03
end type
type cbx_account from checkbox within w_kcda03
end type
type dw_detail from u_key_enter within w_kcda03
end type
type dw_remark from datawindow within w_kcda03
end type
type rr_1 from roundrectangle within w_kcda03
end type
type rr_2 from roundrectangle within w_kcda03
end type
type rr_3 from roundrectangle within w_kcda03
end type
end forward

global type w_kcda03 from w_inherite
string title = "참조코드 등록"
boolean maxbox = true
dw_list dw_list
rb_1 rb_1
rb_3 rb_3
cbx_account cbx_account
dw_detail dw_detail
dw_remark dw_remark
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_kcda03 w_kcda03

type variables
String  LsGubun
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_requiredchk (integer irow);String sRfGub,sRfna1,sRfna2

dw_detail.AcceptText()
sRfGub = dw_detail.getitemstring(iRow, "rfgub")
sRfNa1 = dw_detail.getitemstring(iRow, "rfna1")
sRfNa2 = dw_detail.getitemstring(iRow, "rfna2")

IF sRfGub = '' OR IsNull(sRfGub) THEN
	F_MessageChk(1,'[참조코드]')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	Return -1
END IF

IF sRfNa1 = '' OR IsNull(sRfNa1) THEN
	F_MessageChk(1,'[참조명칭]')
	dw_detail.SetColumn("rfna1")
	dw_detail.SetFocus()
	Return -1
END IF

IF sRfNa2 = '' OR IsNull(sRfna2) THEN
	dw_detail.setitem(iRow, "rfna2", LEFT(sRfna1, 30)) 
END IF

return 1


end function

on w_kcda03.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rb_1=create rb_1
this.rb_3=create rb_3
this.cbx_account=create cbx_account
this.dw_detail=create dw_detail
this.dw_remark=create dw_remark
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.cbx_account
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.dw_remark
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
end on

on w_kcda03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.cbx_account)
destroy(this.dw_detail)
destroy(this.dw_remark)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_remark.settransobject(sqlca)

dw_detail.Reset()

cbx_account.Checked = True
LsGubun = 'AA'

dw_list.Retrieve(LsGubun)
dw_list.Setfocus()

//cb_check()
end event

type dw_insert from w_inherite`dw_insert within w_kcda03
boolean visible = false
integer x = 69
integer y = 2364
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda03
boolean visible = false
integer x = 2702
integer y = 2536
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda03
boolean visible = false
integer x = 2528
integer y = 2536
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda03
boolean visible = false
integer x = 2912
integer y = 2552
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kcda03
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Integer iRowCount,iFunctionValue,iCurRow

if dw_list.GetSelectedRow(0) <=0 then return

w_mdi_frame.sle_msg.text =""

iRowCount = dw_detail.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_detail.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_detail.InsertRow(iCurRow)

	dw_detail.ScrollToRow(iCurRow)
	dw_detail.setitem(iCurRow, "rfcod", dw_list.getitemstring(dw_list.GetSelectedRow(0), "rfcod"))
	dw_detail.SetItem(iCurRow,'sflag','I')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	
	ib_any_typing =False

END IF


end event

type p_exit from w_inherite`p_exit within w_kcda03
end type

type p_can from w_inherite`p_can within w_kcda03
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_detail.Reset()

dw_list.SelectRow(0,False)
dw_list.Retrieve(LsGubun)


end event

type p_print from w_inherite`p_print within w_kcda03
boolean visible = false
integer x = 2610
integer y = 2776
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda03
boolean visible = false
integer x = 2766
integer y = 2772
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kcda03
end type

event p_del::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

IF dw_detail.GetRow() > 0 THEN 
	IF F_DbConFirm('삭제') = 2 THEN Return

	dw_detail.deleterow(0)
	IF dw_detail.Update() <> 1 THEN
		f_messagechk(12,"")
		ROLLBACK;
		Return
	END IF
	COMMIT;
END IF

if dw_detail.rowcount() <= 0 		then 														/* 전부 삭제된 경우 */  
	if messagebox("전산실 확인", "구분코드를 삭제하시겠습니까 ?",exclamation!, okcancel!) = 1 then
		dw_list.DeleteRow(dw_list.GetSelectedRow(0))
		IF dw_list.Update() <> 1 THEN
			f_messagechk(12,'[구분코드]')
			ROLLBACK;
			Return
		ELSE
			dw_remark.DeleteRow(0)
			IF dw_remark.Update() <> 1 THEN
				f_messagechk(12,'[참조값 설명]')
				ROLLBACK;
				Return
			END IF
		END IF
		Commit;
	end if   
end if

w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ib_any_typing = False


end event

type p_mod from w_inherite`p_mod within w_kcda03
end type

event p_mod::clicked;call super::clicked;Integer  i

w_mdi_frame.sle_msg.text =""

dw_list.accepttext()
IF dw_list.GetSelectedRow(0) <=0 THEN Return

IF dw_detail.RowCount() <=0 THEN Return
FOR i = 1 TO dw_detail.RowCount()
	IF Wf_RequiredChk(i) = -1 THEN Return
NEXT

IF F_DbConfirm('저장') = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	f_messagechk(13,'')
	ROLLBACK;
	Return
ELSE
	IF dw_remark.Update() <> 1 THEN
		f_messagechk(13,'[참조값 설명]')
		ROLLBACK;
		Return
	END IF	
END IF
Commit;

FOR i = 1 TO dw_detail.RowCount()
	dw_detail.SetItem(i,'sflag','M')
NEXT
	
w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ib_any_typing = False

end event

type cb_exit from w_inherite`cb_exit within w_kcda03
integer x = 1851
integer y = 2776
end type

type cb_mod from w_inherite`cb_mod within w_kcda03
integer x = 768
integer y = 2776
end type

event cb_mod::clicked;call super::clicked;Integer  i

sle_msg.text =""

dw_list.accepttext()
IF dw_list.GetSelectedRow(0) <=0 THEN Return

IF dw_detail.RowCount() <=0 THEN Return
FOR i = 1 TO dw_detail.RowCount()
	IF Wf_RequiredChk(i) = -1 THEN Return
NEXT

IF F_DbConfirm('저장') = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	f_messagechk(13,'')
	ROLLBACK;
	Return
ELSE
	IF dw_remark.Update() <> 1 THEN
		f_messagechk(13,'[참조값 설명]')
		ROLLBACK;
		Return
	END IF	
END IF
Commit;

FOR i = 1 TO dw_detail.RowCount()
	dw_detail.SetItem(i,'sflag','M')
NEXT
	
sle_msg.text ="자료가 저장되었습니다.!!!"
ib_any_typing = False

end event

type cb_ins from w_inherite`cb_ins within w_kcda03
integer x = 59
integer y = 2756
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;Integer iRowCount,iFunctionValue,iCurRow

if dw_list.GetSelectedRow(0) <=0 then return

sle_msg.text =""

iRowCount = dw_detail.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_detail.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_detail.InsertRow(iCurRow)

	dw_detail.ScrollToRow(iCurRow)
	dw_detail.setitem(iCurRow, "rfcod", dw_list.getitemstring(dw_list.GetSelectedRow(0), "rfcod"))
	dw_detail.SetItem(iCurRow,'sflag','I')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	
	ib_any_typing =False

END IF


end event

type cb_del from w_inherite`cb_del within w_kcda03
integer x = 1129
integer y = 2776
end type

event cb_del::clicked;call super::clicked;
sle_msg.text =""

IF dw_detail.GetRow() > 0 THEN 
	IF F_DbConFirm('삭제') = 2 THEN Return

	dw_detail.deleterow(0)
	IF dw_detail.Update() <> 1 THEN
		f_messagechk(12,"")
		ROLLBACK;
		Return
	END IF
	COMMIT;
END IF

if dw_detail.rowcount() <= 0 		then 														/* 전부 삭제된 경우 */  
	if messagebox("전산실 확인", "구분코드를 삭제하시겠습니까 ?",exclamation!, okcancel!) = 1 then
		dw_list.DeleteRow(dw_list.GetSelectedRow(0))
		IF dw_list.Update() <> 1 THEN
			f_messagechk(12,'[구분코드]')
			ROLLBACK;
			Return
		ELSE
			dw_remark.DeleteRow(0)
			IF dw_remark.Update() <> 1 THEN
				f_messagechk(12,'[참조값 설명]')
				ROLLBACK;
				Return
			END IF
		END IF
		Commit;
	end if   
end if

sle_msg.text ="자료가 삭제되었습니다.!!!"
ib_any_typing = False


end event

type cb_inq from w_inherite`cb_inq within w_kcda03
integer x = 978
integer y = 2500
end type

type cb_print from w_inherite`cb_print within w_kcda03
integer x = 1344
integer y = 2504
end type

type st_1 from w_inherite`st_1 within w_kcda03
end type

type cb_can from w_inherite`cb_can within w_kcda03
integer x = 1490
integer y = 2776
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_detail.Reset()

dw_list.SelectRow(0,False)
dw_list.Retrieve(LsGubun)


end event

type cb_search from w_inherite`cb_search within w_kcda03
integer x = 1714
integer y = 2508
end type







type gb_button1 from w_inherite`gb_button1 within w_kcda03
integer x = 14
integer y = 2700
integer width = 421
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda03
integer x = 736
integer y = 2720
end type

type dw_list from u_d_popup_sort within w_kcda03
integer x = 59
integer y = 48
integer width = 1024
integer height = 1844
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kcda03_2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	b_flag = True
ELSE
	this.SelectRow(0,False)
	this.SelectRow(row,True)

	b_flag = False
	
	dw_detail.Retrieve(this.GetItemString(row,"rfcod"))
	if dw_remark.Retrieve(this.GetItemString(row,"rfcod")) <=0 then
		dw_remark.InsertRow(0)
		dw_remark.SetItem(1,"rfcod",this.GetItemString(row,"rfcod"))
	end if
END IF

call super ::clicked
end event

event rowfocuschanged;If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	
	dw_detail.SetRedraw(False)
	dw_detail.Retrieve(this.GetItemString(currentrow,"rfcod"))
	dw_detail.SetRedraw(True)
	
	dw_remark.SetRedraw(False)
	if dw_remark.Retrieve(this.GetItemString(currentrow,"rfcod")) <=0 then
		dw_remark.InsertRow(0)
		dw_remark.SetItem(1,"rfcod", this.GetItemString(currentrow,"rfcod"))
	end if
	dw_remark.SetRedraw(True)
	
	this.ScrollToRow(currentrow)
	this.SetFocus()
END IF
end event

type rb_1 from radiobutton within w_kcda03
integer x = 2304
integer y = 76
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "구분코드 등록"
end type

event clicked;OpenWithParm(w_kcda03c,'')
IF Left(Message.StringParm,1) = '1' THEN									/*신규코드 등록했으면*/
	dw_list.Selectrow(0,False)
	dw_list.Retrieve(LsGubun)
	dw_list.Setfocus()
	
	dw_detail.Reset()
END IF

end event

type rb_3 from radiobutton within w_kcda03
integer x = 2830
integer y = 76
integer width = 654
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "참조코드 조회 출력"
end type

event clicked;OPEN(w_kcda03b)
end event

type cbx_account from checkbox within w_kcda03
integer x = 1285
integer y = 84
integer width = 526
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
string text = "회계사용코드만"
boolean checked = true
end type

event clicked;IF cbx_account.Checked = True THEN
	LsGubun ='AA'
ELSE
	LsGubun ='00'
END IF

dw_list.SelectRow(0,False)

dw_list.Retrieve(LsGubun)
dw_detail.Reset()

end event

type dw_detail from u_key_enter within w_kcda03
integer x = 1143
integer y = 204
integer width = 3447
integer height = 1696
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kcda03_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rfna1" OR dwo.name ="rfna2" or dwo.name = 'rfna3' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event editchanged;ib_any_typing = true
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event itemchanged;String    sRfGub,sNull
Integer   iFindRow,iCurRow

SetNull(sNull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "rfgub" THEN
	sRfGub = this.GetText()
	IF sRfGub = '' OR IsNull(sRfGub) THEN Return
	
	iFindRow = this.find("rfgub ='" + sRfGub + "'", 1, this.RowCount())

	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
		f_MessageChk(10,'[참조코드]')
		this.SetItem(iCurRow,"rfgub",sNull)
		RETURN  1
	END IF

END IF	

end event

event itemerror;Return 1
end event

type dw_remark from datawindow within w_kcda03
integer x = 46
integer y = 1936
integer width = 4567
integer height = 284
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kcda03_3"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kcda03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 36
integer width = 1074
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kcda03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2254
integer y = 52
integer width = 1243
integer height = 116
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kcda03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1138
integer y = 196
integer width = 3474
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 46
end type

