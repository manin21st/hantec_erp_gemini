$PBExportHeader$w_kfe01om0_popup.srw
$PBExportComments$예산계정과목 popup
forward
global type w_kfe01om0_popup from window
end type
type cb_3 from commandbutton within w_kfe01om0_popup
end type
type cb_2 from commandbutton within w_kfe01om0_popup
end type
type cb_1 from commandbutton within w_kfe01om0_popup
end type
type p_choose from uo_picture within w_kfe01om0_popup
end type
type p_inq from uo_picture within w_kfe01om0_popup
end type
type p_exit from uo_picture within w_kfe01om0_popup
end type
type dw_1 from u_d_popup_sort within w_kfe01om0_popup
end type
type rr_1 from roundrectangle within w_kfe01om0_popup
end type
end forward

global type w_kfe01om0_popup from window
integer x = 1714
integer y = 12
integer width = 1993
integer height = 2272
boolean titlebar = true
string title = "계정과목조회선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_choose p_choose
p_inq p_inq
p_exit p_exit
dw_1 dw_1
rr_1 rr_1
end type
global w_kfe01om0_popup w_kfe01om0_popup

type variables
String is_old_dwobject_name, is_old_color

end variables

event open;
F_Window_Center_Response(This)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()


p_inq.TriggerEvent(Clicked!)
end event

on w_kfe01om0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_choose=create p_choose
this.p_inq=create p_inq
this.p_exit=create p_exit
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_choose,&
this.p_inq,&
this.p_exit,&
this.dw_1,&
this.rr_1}
end on

on w_kfe01om0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.rr_1)
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

type cb_3 from commandbutton within w_kfe01om0_popup
integer x = 2382
integer y = 588
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

type cb_2 from commandbutton within w_kfe01om0_popup
integer x = 2382
integer y = 488
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

type cb_1 from commandbutton within w_kfe01om0_popup
integer x = 2377
integer y = 388
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

type p_choose from uo_picture within w_kfe01om0_popup
integer x = 1600
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

event clicked;call super::clicked;Long ll_row
String sgaej1,sgaej2,sname1,sname2


ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

sgaej1 = dw_1.GetItemString(ll_Row, "acc1_cd")
sgaej2 = dw_1.GetItemString(ll_Row, "acc2_cd")
sname1 = dw_1.GetItemString(ll_Row, "acc1_nm")
sname2 = dw_1.GetItemString(ll_Row, "yacc2_nm")

gs_code = sgaej1 + sgaej2
gs_codename = sname2

Close(Parent)

end event

type p_inq from uo_picture within w_kfe01om0_popup
integer x = 1426
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event clicked;call super::clicked;
dw_1.Reset()
dw_1.Retrieve('%','%','%')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type p_exit from uo_picture within w_kfe01om0_popup
integer x = 1774
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type dw_1 from u_d_popup_sort within w_kfe01om0_popup
event ue_key pbm_keydown
event ue_keyenter pbm_dwnprocessenter
integer x = 46
integer y = 156
integer width = 1893
integer height = 1888
integer taborder = 10
string dataobject = "dw_kfe01om0_popup"
boolean vscrollbar = true
boolean border = false
end type

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

event ue_keyenter;p_choose.triggerEvent(Clicked!)
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
	acc_name1 =dw_1.GetItemString(Row,"acc1_nm")
	acc_name2 =dw_1.GetItemString(Row,"yacc2_nm")

	b_flag = False
END IF

call super ::clicked
end event

event doubleclicked;String sgaej1,sgaej2,sname1,sname2

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

sgaej1 = dw_1.GetItemString(Row, "acc1_cd")
sgaej2 = dw_1.GetItemString(Row, "acc2_cd")
sname1 = dw_1.GetItemString(Row, "acc1_nm")
sname2 = dw_1.GetItemString(Row, "yacc2_nm")

gs_code = sgaej1 + sgaej2
gs_codename = sname2

Close(Parent)

end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type rr_1 from roundrectangle within w_kfe01om0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 148
integer width = 1911
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

