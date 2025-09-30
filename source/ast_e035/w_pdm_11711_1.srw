$PBExportHeader$w_pdm_11711_1.srw
$PBExportComments$외주사급자재 단가등록
forward
global type w_pdm_11711_1 from window
end type
type p_del from uo_picture within w_pdm_11711_1
end type
type dw_1 from datawindow within w_pdm_11711_1
end type
type rr_2 from roundrectangle within w_pdm_11711_1
end type
end forward

global type w_pdm_11711_1 from window
integer width = 2135
integer height = 1412
boolean titlebar = true
string title = "사급단가 이력조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
p_del p_del
dw_1 dw_1
rr_2 rr_2
end type
global w_pdm_11711_1 w_pdm_11711_1

event open;string sparm

sparm = message.stringparm

dw_1.settransobject(sqlca)
If dw_1.retrieve(sparm) < 1 then
	Messagebox("이력", "자료가 없읍니다", stopsign!)
	close(this)
End if
end event

on w_pdm_11711_1.create
this.p_del=create p_del
this.dw_1=create dw_1
this.rr_2=create rr_2
this.Control[]={this.p_del,&
this.dw_1,&
this.rr_2}
end on

on w_pdm_11711_1.destroy
destroy(this.p_del)
destroy(this.dw_1)
destroy(this.rr_2)
end on

type p_del from uo_picture within w_pdm_11711_1
integer x = 1861
integer y = 1136
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;if dw_1.getrow() > 0 then
	dw_1.deleterow(dw_1.getrow())
	dw_1.update()
	commit;

end if
end event

type dw_1 from datawindow within w_pdm_11711_1
integer x = 32
integer y = 12
integer width = 2002
integer height = 1064
integer taborder = 10
string title = "none"
string dataobject = "d_pdm_11711_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_pdm_11711_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer width = 2066
integer height = 1104
integer cornerheight = 40
integer cornerwidth = 55
end type

