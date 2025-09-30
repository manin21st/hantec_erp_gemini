$PBExportHeader$w_ref_popup.srw
$PBExportComments$** 참조코드구분조회
forward
global type w_ref_popup from window
end type
type cb_1 from commandbutton within w_ref_popup
end type
type cb_return from commandbutton within w_ref_popup
end type
type dw_1 from u_d_popup_sort within w_ref_popup
end type
end forward

global type w_ref_popup from window
integer x = 1938
integer y = 84
integer width = 1650
integer height = 1684
boolean titlebar = true
string title = "참조 코드 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
cb_1 cb_1
cb_return cb_return
dw_1 dw_1
end type
global w_ref_popup w_ref_popup

event open;f_Window_Center_Response(This)
dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_1.Retrieve()

end event

on w_ref_popup.create
this.cb_1=create cb_1
this.cb_return=create cb_return
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.cb_return,&
this.dw_1}
end on

on w_ref_popup.destroy
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.dw_1)
end on

type cb_1 from commandbutton within w_ref_popup
integer x = 978
integer y = 1460
integer width = 293
integer height = 108
integer taborder = 10
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

gs_code = dw_1.GetItemString(ll_Row, "codegbn")
gs_codename = dw_1.GetItemString(ll_Row, "codenm")

Close(Parent)


end event

type cb_return from commandbutton within w_ref_popup
integer x = 1307
integer y = 1460
integer width = 293
integer height = 108
integer taborder = 20
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

type dw_1 from u_d_popup_sort within w_ref_popup
integer x = 41
integer y = 28
integer width = 1563
integer height = 1412
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_ref_popup"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag =False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "codegbn")
gs_codename = dw_1.GetItemString(Row, "codenm")

Close(Parent)

end event

