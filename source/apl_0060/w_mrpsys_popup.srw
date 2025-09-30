$PBExportHeader$w_mrpsys_popup.srw
$PBExportComments$** MRPSYS 순번 조회 선택
forward
global type w_mrpsys_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_mrpsys_popup
end type
type rb_1 from radiobutton within w_mrpsys_popup
end type
type rb_2 from radiobutton within w_mrpsys_popup
end type
type rb_3 from radiobutton within w_mrpsys_popup
end type
type rb_4 from radiobutton within w_mrpsys_popup
end type
type rr_1 from roundrectangle within w_mrpsys_popup
end type
type rr_2 from roundrectangle within w_mrpsys_popup
end type
type rr_3 from roundrectangle within w_mrpsys_popup
end type
end forward

global type w_mrpsys_popup from w_inherite_popup
integer x = 146
integer y = 188
integer width = 3319
integer height = 1900
string title = "MRP 순번 조회 선택"
dw_2 dw_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_mrpsys_popup w_mrpsys_popup

type variables
int  li_use  //거래처마스타는 거래중지인 경우도 조회
end variables

on w_mrpsys_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_mrpsys_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)

//dw_1.Retrieve()
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mrpsys_popup
boolean visible = false
integer x = 73
integer y = 2016
integer width = 210
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_mrpsys_popup
integer x = 3067
integer y = 16
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mrpsys_popup
boolean visible = false
integer x = 2702
integer y = 2024
end type

type p_choose from w_inherite_popup`p_choose within w_mrpsys_popup
integer x = 2894
integer y = 16
boolean originalsize = true
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = string(dw_1.GetItemNumber(ll_Row, "actno"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mrpsys_popup
integer x = 41
integer y = 180
integer width = 2066
integer height = 1596
integer taborder = 10
string dataobject = "d_mrpsys_popup1"
end type

event dw_1::clicked;long lactno

If Row <= 0 then
	dw_1.SelectRow(0,False)
	dw_2.reset()
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	lactno = this.getitemnumber(row, 'actno')
	dw_2.retrieve(gs_sabu, lactno )
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = string(dw_1.GetItemNumber(Row, "actno"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mrpsys_popup
boolean visible = false
integer x = 530
integer y = 2068
integer width = 1225
end type

event sle_2::getfocus;IF dw_2.GetItemString(1,"rfgub") = '1' THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_mrpsys_popup
boolean visible = false
integer x = 1481
integer y = 2008
end type

type cb_return from w_inherite_popup`cb_return within w_mrpsys_popup
boolean visible = false
integer x = 1792
integer y = 2008
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_mrpsys_popup
boolean visible = false
integer x = 2377
integer y = 2024
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mrpsys_popup
boolean visible = false
integer x = 329
integer y = 2068
integer width = 197
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_mrpsys_popup
boolean visible = false
integer y = 2084
integer width = 315
string text = "거래처코드"
end type

type dw_2 from datawindow within w_mrpsys_popup
event ue_key pbm_dwnkey
integer x = 2167
integer y = 180
integer width = 1083
integer height = 1596
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mrpsys_popup2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_mrpsys_popup
integer x = 110
integer y = 52
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "년간계획"
end type

event clicked;dw_1.DataObject = 'd_mrpsys_popup'
dw_1.SetTransObject(sqlca)

dw_1.retrieve(gs_sabu, gs_saupj)
end event

type rb_2 from radiobutton within w_mrpsys_popup
integer x = 503
integer y = 52
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "연동계획"
end type

event clicked;dw_1.DataObject = 'd_mrpsys_popup1'
dw_1.SetTransObject(sqlca)

dw_1.retrieve(gs_sabu, gs_saupj)
end event

type rb_3 from radiobutton within w_mrpsys_popup
boolean visible = false
integer x = 933
integer y = 52
integer width = 603
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "주간계획-영업기준"
end type

event clicked;dw_1.DataObject = 'd_mrpsys_popup3'
dw_1.SetTransObject(sqlca)

dw_1.retrieve(gs_sabu)
end event

type rb_4 from radiobutton within w_mrpsys_popup
boolean visible = false
integer x = 1582
integer y = 52
integer width = 603
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "주간계획-생산기준"
end type

event clicked;dw_1.DataObject = 'd_mrpsys_popup4'
dw_1.SetTransObject(sqlca)

dw_1.retrieve(gs_sabu)
end event

type rr_1 from roundrectangle within w_mrpsys_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 16
integer width = 878
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mrpsys_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 176
integer width = 2089
integer height = 1612
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_mrpsys_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2158
integer y = 176
integer width = 1106
integer height = 1612
integer cornerheight = 40
integer cornerwidth = 55
end type

