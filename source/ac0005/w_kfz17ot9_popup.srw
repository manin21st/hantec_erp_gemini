$PBExportHeader$w_kfz17ot9_popup.srw
$PBExportComments$�ε����ڵ� ��ȸ����(POPUP)
forward
global type w_kfz17ot9_popup from window
end type
type cb_3 from commandbutton within w_kfz17ot9_popup
end type
type cb_2 from commandbutton within w_kfz17ot9_popup
end type
type p_exit from uo_picture within w_kfz17ot9_popup
end type
type p_choose from uo_picture within w_kfz17ot9_popup
end type
type dw_1 from u_d_popup_sort within w_kfz17ot9_popup
end type
type rr_1 from roundrectangle within w_kfz17ot9_popup
end type
end forward

global type w_kfz17ot9_popup from window
integer x = 1911
integer y = 4
integer width = 2651
integer height = 2152
boolean titlebar = true
string title = "�ε����ڵ� ��ȸ����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
p_exit p_exit
p_choose p_choose
dw_1 dw_1
rr_1 rr_1
end type
global w_kfz17ot9_popup w_kfz17ot9_popup

event open;
String schadae

F_Window_Center_Response(This)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

schadae = gs_code

dw_1.Retrieve()
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

on w_kfz17ot9_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.p_exit=create p_exit
this.p_choose=create p_choose
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.cb_3,&
this.cb_2,&
this.p_exit,&
this.p_choose,&
this.dw_1,&
this.rr_1}
end on

on w_kfz17ot9_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type cb_3 from commandbutton within w_kfz17ot9_popup
integer x = 3173
integer y = 588
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_kfz17ot9_popup
integer x = 3173
integer y = 488
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&V)"
end type

event clicked;p_choose.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kfz17ot9_popup
integer x = 2427
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;SetNull(Gs_Code)
SetNull(Gs_CodeName)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\���_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\���_up.gif'
end event

type p_choose from uo_picture within w_kfz17ot9_popup
integer x = 2254
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "code")

Close(Parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\����_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\����_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfz17ot9_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 46
integer y = 168
integer width = 2537
integer height = 1860
integer taborder = 10
string dataobject = "dw_kfz17ot9_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_keyenter;p_choose.triggerEvent(Clicked!)
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

event doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "code")

Close(Parent)

end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type rr_1 from roundrectangle within w_kfz17ot9_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 160
integer width = 2565
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

