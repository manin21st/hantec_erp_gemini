$PBExportHeader$w_kfga02_popup.srw
$PBExportComments$재무분석코드 조회 선택
forward
global type w_kfga02_popup from window
end type
type cb_3 from commandbutton within w_kfga02_popup
end type
type cb_2 from commandbutton within w_kfga02_popup
end type
type cb_1 from commandbutton within w_kfga02_popup
end type
type p_exit from uo_picture within w_kfga02_popup
end type
type p_choose from uo_picture within w_kfga02_popup
end type
type p_inq from uo_picture within w_kfga02_popup
end type
type dw_1 from u_d_popup_sort within w_kfga02_popup
end type
type rr_1 from roundrectangle within w_kfga02_popup
end type
end forward

global type w_kfga02_popup from window
integer x = 2208
integer y = 4
integer width = 1591
integer height = 2272
boolean titlebar = true
string title = "재무분석코드 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
rr_1 rr_1
end type
global w_kfga02_popup w_kfga02_popup

event open;F_Window_Center_Response(This)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

p_inq.TriggerEvent(Clicked!)


end event

on w_kfga02_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.rr_1}
end on

on w_kfga02_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
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

type cb_3 from commandbutton within w_kfga02_popup
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

type cb_2 from commandbutton within w_kfga02_popup
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

type cb_1 from commandbutton within w_kfga02_popup
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

type p_exit from uo_picture within w_kfga02_popup
integer x = 1381
integer width = 178
integer taborder = 40
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

type p_choose from uo_picture within w_kfga02_popup
integer x = 1207
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "accd")
gs_codename = dw_1.GetItemString(ll_Row, "accd_nm")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfga02_popup
integer x = 1033
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;
dw_1.Reset()
dw_1.Retrieve('%','%')

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfga02_popup
integer x = 55
integer y = 156
integer width = 1477
integer height = 1892
integer taborder = 10
string dataobject = "dw_kfga02_popup"
boolean vscrollbar = true
boolean border = false
end type

event doubleclicked;call super::doubleclicked;
String ls_mapno

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(Row, "accd")
gs_codename = dw_1.GetItemString(Row, "accd_nm")

Close(Parent)

end event

event clicked;string acc1_cd, acc2_cd, acc_name1, acc_name2

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	acc1_cd =dw_1.GetItemString(Row,"accd")
	acc_name1 =dw_1.GetItemString(Row,"accd_nm")

	b_flag = False
END IF

call super ::clicked
end event

type rr_1 from roundrectangle within w_kfga02_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 148
integer width = 1509
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

