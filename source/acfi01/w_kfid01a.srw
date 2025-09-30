$PBExportHeader$w_kfid01a.srw
$PBExportComments$받을어음 상세 조회
forward
global type w_kfid01a from window
end type
type dw_1 from datawindow within w_kfid01a
end type
type em_junno from editmask within w_kfid01a
end type
type st_1 from statictext within w_kfid01a
end type
type gb_1 from groupbox within w_kfid01a
end type
type rr_1 from roundrectangle within w_kfid01a
end type
end forward

global type w_kfid01a from window
integer x = 123
integer y = 148
integer width = 3794
integer height = 2136
boolean titlebar = true
string title = "받을어음 전표 상세 내역 조회"
boolean controlmenu = true
long backcolor = 32106727
dw_1 dw_1
em_junno em_junno
st_1 st_1
gb_1 gb_1
rr_1 rr_1
end type
global w_kfid01a w_kfid01a

on w_kfid01a.create
this.dw_1=create dw_1
this.em_junno=create em_junno
this.st_1=create st_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.dw_1,&
this.em_junno,&
this.st_1,&
this.gb_1,&
this.rr_1}
end on

on w_kfid01a.destroy
destroy(this.dw_1)
destroy(this.em_junno)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;String   sMsgParm,sSaupj,sBalDate,sUpmuGu
Long     lJunNo

F_Window_Center_Response(this)

dw_1.SetTransObject(sqlca)
dw_1.Reset()

sMsgParm = Message.StringParm
em_junno.text = String(Message.StringParm,'@@-@@@@.@@.@@-@-@@@@')

sSaupj   = String(Integer(Left(sMsgParm,2)))
sBalDate = Mid(sMsgParm,3,8)
sUpmuGu  = Mid(sMsgParm,11,1)
lJunNo   = Long(Mid(sMsgParm,12,4))

dw_1.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
end event

type dw_1 from datawindow within w_kfid01a
integer x = 55
integer y = 200
integer width = 3653
integer height = 1780
string dataobject = "d_kfid01a1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type em_junno from editmask within w_kfid01a
integer x = 357
integer y = 60
integer width = 1065
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type st_1 from statictext within w_kfid01a
integer x = 110
integer y = 72
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "전표번호"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_kfid01a
integer x = 46
integer width = 1445
integer height = 184
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfid01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 196
integer width = 3694
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

