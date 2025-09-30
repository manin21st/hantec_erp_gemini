$PBExportHeader$w_bl_popup4.srw
$PBExportComments$B/L + 인수증 번호 조회
forward
global type w_bl_popup4 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_bl_popup4
end type
type rb_1 from radiobutton within w_bl_popup4
end type
type rb_2 from radiobutton within w_bl_popup4
end type
type pb_1 from u_pb_cal within w_bl_popup4
end type
type pb_2 from u_pb_cal within w_bl_popup4
end type
type rr_2 from roundrectangle within w_bl_popup4
end type
end forward

global type w_bl_popup4 from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3355
integer height = 1944
string title = "B/L(인수증)번호 조회"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_bl_popup4 w_bl_popup4

on w_bl_popup4.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_2
end on

on w_bl_popup4.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;IF gs_gubun = '9' then //인수증
	dw_jogun.DataObject = 'd_bl_popup4_1'
	dw_1.DataObject = 'd_bl_popup2'
	rb_2.Checked = true 
ELSE //BL
	dw_jogun.DataObject = 'd_bl_popup'
	dw_1.DataObject = 'd_bl_popup1'
	rb_1.Checked = true 
END IF

dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)
dw_1.SetTransObject(SQLCA)

f_mod_saupj(dw_jogun, 'saupj')
dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_bl_popup4
integer x = 526
integer y = 24
integer width = 2171
string dataobject = "d_bl_popup"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_bl_popup4
integer x = 3131
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_bl_popup4
integer x = 2784
end type

event p_inq::clicked;call super::clicked;
String sdatef, sdatet, ssaupj

if dw_jogun.AcceptText() = -1 then return 

ssaupj = trim(dw_jogun.GetItemString(1,"saupj"))
sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))

IF ssaupj ="" OR IsNull(ssaupj) THEN
	ssaupj =''
END IF

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF


IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, sDatef, sDatet, ssaupj+'%') <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn(1)
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_bl_popup4
integer x = 2958
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "polcbl_poblno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_bl_popup4
integer x = 41
integer y = 192
integer width = 3250
integer height = 1644
string dataobject = "d_bl_popup1"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "polcbl_poblno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_bl_popup4
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_bl_popup4
integer x = 206
integer y = 2028
end type

type cb_return from w_inherite_popup`cb_return within w_bl_popup4
integer x = 827
integer y = 2028
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_bl_popup4
integer x = 517
integer y = 2028
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_bl_popup4
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_bl_popup4
boolean visible = false
integer x = 224
integer y = 1932
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_bl_popup4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 28
integer width = 494
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_bl_popup4
integer x = 59
integer y = 56
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "B/L"
end type

event clicked;dw_jogun.DataObject = 'd_bl_popup'
dw_1.DataObject = 'd_bl_popup1'

dw_jogun.InsertRow(0)
dw_1.SetTransObject(SQLCA)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type rb_2 from radiobutton within w_bl_popup4
integer x = 256
integer y = 56
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "인수증"
end type

event clicked;dw_jogun.DataObject = 'd_bl_popup2_1'
dw_1.DataObject = 'd_bl_popup2'

dw_jogun.InsertRow(0)
dw_1.SetTransObject(SQLCA)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type pb_1 from u_pb_cal within w_bl_popup4
integer x = 2112
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_bl_popup4
integer x = 2555
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_2 from roundrectangle within w_bl_popup4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 3273
integer height = 1652
integer cornerheight = 40
integer cornerwidth = 55
end type

