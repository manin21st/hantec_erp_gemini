$PBExportHeader$w_save_popup.srw
$PBExportComments$** 저축코드 조회
forward
global type w_save_popup from window
end type
type cb_1 from commandbutton within w_save_popup
end type
type cb_return from commandbutton within w_save_popup
end type
type dw_1 from u_d_popup_sort within w_save_popup
end type
end forward

global type w_save_popup from window
integer x = 2034
integer y = 36
integer width = 1577
integer height = 1716
boolean titlebar = true
string title = "저축코드 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
cb_1 cb_1
cb_return cb_return
dw_1 dw_1
end type
global w_save_popup w_save_popup

event open;f_Window_Center_Response(This)
String schadae
dw_1.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.Retrieve()
end event

on w_save_popup.create
this.cb_1=create cb_1
this.cb_return=create cb_return
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.cb_return,&
this.dw_1}
end on

on w_save_popup.destroy
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.dw_1)
end on

type cb_1 from commandbutton within w_save_popup
integer x = 914
integer y = 1508
integer width = 293
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "savecode")
gs_codename = dw_1.GetItemString(ll_Row, "savename")

Close(Parent)


end event

type cb_return from commandbutton within w_save_popup
integer x = 1243
integer y = 1508
integer width = 293
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type dw_1 from u_d_popup_sort within w_save_popup
integer x = 37
integer y = 20
integer width = 1504
integer height = 1472
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_save_popup"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return

END IF

gs_code = dw_1.GetItemString(Row, "savecode")
gs_codename = dw_1.GetItemString(Row, "savename")

Close(Parent)

end event

