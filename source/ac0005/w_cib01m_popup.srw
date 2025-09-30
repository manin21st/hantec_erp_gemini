$PBExportHeader$w_cib01m_popup.srw
$PBExportComments$원가계정 조회 선택
forward
global type w_cib01m_popup from window
end type
type cb_3 from commandbutton within w_cib01m_popup
end type
type cb_2 from commandbutton within w_cib01m_popup
end type
type cb_1 from commandbutton within w_cib01m_popup
end type
type rb_2 from radiobutton within w_cib01m_popup
end type
type rb_1 from radiobutton within w_cib01m_popup
end type
type rr_1 from roundrectangle within w_cib01m_popup
end type
type p_exit from uo_picture within w_cib01m_popup
end type
type p_choose from uo_picture within w_cib01m_popup
end type
type p_inq from uo_picture within w_cib01m_popup
end type
type dw_1 from u_d_popup_sort within w_cib01m_popup
end type
type st_1 from statictext within w_cib01m_popup
end type
type rr_2 from roundrectangle within w_cib01m_popup
end type
end forward

global type w_cib01m_popup from window
integer x = 1577
integer y = 4
integer width = 2917
integer height = 2272
boolean titlebar = true
string title = "원가계정 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
rr_1 rr_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
st_1 st_1
rr_2 rr_2
end type
global w_cib01m_popup w_cib01m_popup

event open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()

F_Window_Center_Response(This)

dw_1.Retrieve('1')


end event

on w_cib01m_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rr_1=create rr_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.st_1=create st_1
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.rb_2,&
this.rb_1,&
this.rr_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.st_1,&
this.rr_2}
end on

on w_cib01m_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rr_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.rr_2)
end on

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type cb_3 from commandbutton within w_cib01m_popup
integer x = 3301
integer y = 592
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_cib01m_popup
integer x = 3301
integer y = 492
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_choose.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_cib01m_popup
integer x = 3296
integer y = 392
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_cib01m_popup
integer x = 626
integer y = 56
integer width = 242
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "손익"
end type

event clicked;dw_1.Retrieve('2')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

type rb_1 from radiobutton within w_cib01m_popup
integer x = 366
integer y = 56
integer width = 242
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "제조"
boolean checked = true
end type

event clicked;dw_1.Retrieve('1')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_cib01m_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 16
integer width = 910
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from uo_picture within w_cib01m_popup
integer x = 2697
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_cib01m_popup
integer x = 2523
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "acc1_cd") + dw_1.GetItemString(ll_Row, "acc2_cd")
gs_codename = dw_1.GetItemString(ll_Row, "acc2_nm")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_cib01m_popup
boolean visible = false
integer x = 1888
integer y = 8
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;//String ls_gaejung1, name1, name2
//
//dw_1.SetRedraw(False)
//dw_1.Reset()
//dw_1.Retrieve(ls_gaejung1,name1,name2)
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.SetFocus()
//dw_1.SetRedraw(True)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type dw_1 from u_d_popup_sort within w_cib01m_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 32
integer y = 180
integer width = 2830
integer height = 1864
integer taborder = 10
string dataobject = "dw_CIB01m_popup1"
boolean vscrollbar = true
boolean border = false
end type

event ue_keyenter;p_choose.TriggerEvent(Clicked!)
end event

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event doubleclicked;
String ls_mapno


IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(Row, "acc1_cd") + dw_1.GetItemString(Row, "acc2_cd")
gs_codename = dw_1.GetItemString(Row, "acc2_nm")

Close(Parent)

end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event clicked;string acc1_cd, acc2_cd, acc_name1, acc_name2

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	acc1_cd =dw_1.GetItemString(Row,"acc1_cd")
	acc2_cd =dw_1.GetItemString(Row,"acc2_cd")

	b_flag = False
END IF

call super ::clicked
end event

type st_1 from statictext within w_cib01m_popup
integer x = 46
integer y = 56
integer width = 270
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "계정구분"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_cib01m_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 168
integer width = 2848
integer height = 1888
integer cornerheight = 40
integer cornerwidth = 55
end type

