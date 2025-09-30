$PBExportHeader$w_carmst_popup.srw
forward
global type w_carmst_popup from w_inherite_popup
end type
type st_2 from statictext within w_carmst_popup
end type
type rb_1 from radiobutton within w_carmst_popup
end type
type rb_2 from radiobutton within w_carmst_popup
end type
type rb_3 from radiobutton within w_carmst_popup
end type
type rb_4 from radiobutton within w_carmst_popup
end type
type rr_3 from roundrectangle within w_carmst_popup
end type
type rr_4 from roundrectangle within w_carmst_popup
end type
end forward

global type w_carmst_popup from w_inherite_popup
integer width = 2117
integer height = 2076
string title = "차종정보 조회 POPUP"
st_2 st_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_3 rr_3
rr_4 rr_4
end type
global w_carmst_popup w_carmst_popup

on w_carmst_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_3
this.Control[iCurrent+7]=this.rr_4
end on

on w_carmst_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;dw_1.SetTransObject(sqlca)
dw_1.Retrieve('E')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_carmst_popup
boolean visible = false
end type

type p_exit from w_inherite_popup`p_exit within w_carmst_popup
integer x = 1897
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_carmst_popup
boolean visible = false
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_carmst_popup
integer x = 1723
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "carcode")
gs_codename= dw_1.GetItemString(ll_row,"carnm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_carmst_popup
integer y = 204
integer width = 2034
integer height = 1724
string dataobject = "d_carmst_popup_1"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "carcode")
gs_codename= dw_1.GetItemString(row,"carnm")

Close(Parent)

end event

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type sle_2 from w_inherite_popup`sle_2 within w_carmst_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_carmst_popup
end type

type cb_return from w_inherite_popup`cb_return within w_carmst_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_carmst_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_carmst_popup
end type

type st_1 from w_inherite_popup`st_1 within w_carmst_popup
end type

type st_2 from statictext within w_carmst_popup
integer x = 46
integer y = 68
integer width = 315
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
string text = "차종정보"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_carmst_popup
integer x = 443
integer y = 64
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.Retrieve('E')

dw_1.Object.t_nm.text = '차종코드'
dw_1.Object.t_nm1.text = '차종명'

end event

type rb_2 from radiobutton within w_carmst_popup
boolean visible = false
integer x = 1120
integer y = 148
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미션"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.Retrieve('T')

dw_1.Object.t_nm.text = '차종코드'
dw_1.Object.t_nm1.text = '차종명'
end event

type rb_3 from radiobutton within w_carmst_popup
boolean visible = false
integer x = 1403
integer y = 144
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "기타(LG)"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.Retrieve('0')

dw_1.Object.t_nm.text = '기종코드'
dw_1.Object.t_nm1.text = '기종명'
end event

type rb_4 from radiobutton within w_carmst_popup
integer x = 690
integer y = 64
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "STYLE"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.Retrieve('4')

dw_1.Object.t_nm.text = 'STYLE'
dw_1.Object.t_nm1.text = 'STYLE명'
end event

type rr_3 from roundrectangle within w_carmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 366
integer y = 44
integer width = 663
integer height = 100
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_carmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 192
integer width = 2053
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

