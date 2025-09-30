$PBExportHeader$w_kcda01c.srw
$PBExportComments$계정과목 일괄삭제
forward
global type w_kcda01c from window
end type
type p_exit from uo_picture within w_kcda01c
end type
type p_del from uo_picture within w_kcda01c
end type
type dw_1 from datawindow within w_kcda01c
end type
end forward

global type w_kcda01c from window
integer width = 2530
integer height = 1664
boolean titlebar = true
string title = "계정과목 일괄삭제"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
p_exit p_exit
p_del p_del
dw_1 dw_1
end type
global w_kcda01c w_kcda01c

on w_kcda01c.create
this.p_exit=create p_exit
this.p_del=create p_del
this.dw_1=create dw_1
this.Control[]={this.p_exit, &
this.p_del, &
this.dw_1}
end on

on w_kcda01c.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.dw_1)
end on

event open;
f_window_center_Response(this)
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()
end event

event resize;
dw_1.width = this.width - 100
dw_1.height = this.height - dw_1.y - 100

p_del.x = this.width - p_del.width - p_exit.width - 60
p_exit.x = this.width - p_exit.width - 40
end event

type p_exit from uo_picture within w_kcda01c
integer x = 2300
integer y = 28
integer width = 178
integer taborder = 30
string picturename = "btn_close_up.gif"
end type

event clicked;
Close(Parent)
end event

type p_del from uo_picture within w_kcda01c
integer x = 2110
integer y = 28
integer width = 178
integer taborder = 20
string picturename = "btn_delete_up.gif"
end type

event clicked;
IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","자료 삭제 실패 !!")
	ROLLBACK;
	RETURN
END IF
COMMIT;
MessageBox("확 인","자료가 삭제되었습니다.")
dw_1.Retrieve()
end event

type dw_1 from datawindow within w_kcda01c
integer x = 46
integer y = 128
integer width = 2427
integer height = 1408
integer taborder = 10
string dataobject = "dw_kcda01c_1"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type
