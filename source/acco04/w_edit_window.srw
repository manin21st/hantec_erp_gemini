$PBExportHeader$w_edit_window.srw
$PBExportComments$원가실행 Multi Line Edit
forward
global type w_edit_window from window
end type
type shl_1 from statichyperlink within w_edit_window
end type
type shl_2 from statichyperlink within w_edit_window
end type
type mle_1 from multilineedit within w_edit_window
end type
end forward

global type w_edit_window from window
integer width = 3168
integer height = 1876
boolean titlebar = true
string title = "편집 화면"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
shl_1 shl_1
shl_2 shl_2
mle_1 mle_1
end type
global w_edit_window w_edit_window

event key;IF key = keyescape! THEN 
	shl_2.TriggerEvent("Clicked")
END IF
end event

event open;window	lw_parent
lw_parent = This.ParentWindow()

This.X			= lw_parent.X
This.Y			= lw_parent.Y
This.Width		= lw_parent.Width
This.Height		= lw_parent.Height

mle_1.width		= This.Width - 50
mle_1.height	= This.Height - 200

shl_1.X			= This.Width - 600
shl_2.X			= This.Width - 400

mle_1.SetFocus()

end event

on w_edit_window.create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.mle_1=create mle_1
this.Control[]={this.shl_1,&
this.shl_2,&
this.mle_1}
end on

on w_edit_window.destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.mle_1)
end on

type shl_1 from statichyperlink within w_edit_window
integer x = 2601
integer y = 20
integer width = 192
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
string text = "OK"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;CloseWithReturn(Parent, mle_1.text)

end event

type shl_2 from statichyperlink within w_edit_window
integer x = 2839
integer y = 20
integer width = 283
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 255
long backcolor = 32106727
string text = "CANCEL"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;CloseWithReturn(Parent, "")

end event

type mle_1 from multilineedit within w_edit_window
integer x = 9
integer y = 112
integer width = 3118
integer height = 1652
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
integer limit = 4000
borderstyle borderstyle = stylelowered!
end type

event constructor;This.text = Message.StringParm
end event

