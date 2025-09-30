$PBExportHeader$w_kglc02a.srw
$PBExportComments$승인전표 상세 조회
forward
global type w_kglc02a from window
end type
type cb_1 from commandbutton within w_kglc02a
end type
type dw_2 from datawindow within w_kglc02a
end type
type dw_disp from datawindow within w_kglc02a
end type
type gb_1 from groupbox within w_kglc02a
end type
type rr_1 from roundrectangle within w_kglc02a
end type
end forward

global type w_kglc02a from window
integer x = 169
integer y = 148
integer width = 3323
integer height = 2060
boolean titlebar = true
string title = "승인전표 상세 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_1 cb_1
dw_2 dw_2
dw_disp dw_disp
gb_1 gb_1
rr_1 rr_1
end type
global w_kglc02a w_kglc02a

event open;String ls_colx

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu, lstr_jpra.bjunno)

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu, lstr_jpra.bjunno)

//h split scrollbar
ls_colx = dw_2.Object.kfz10ot0_vatamt.x

// Set the position of the horizontal split scroll point.
dw_2.Object.datawindow.horizontalscrollsplit = ls_colx

end event

on w_kglc02a.create
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_disp=create dw_disp
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.cb_1,&
this.dw_2,&
this.dw_disp,&
this.gb_1,&
this.rr_1}
end on

on w_kglc02a.destroy
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_disp)
destroy(this.gb_1)
destroy(this.rr_1)
end on

type cb_1 from commandbutton within w_kglc02a
integer x = 2921
integer y = 1848
integer width = 320
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "완료(&F)"
boolean default = true
end type

on clicked;close(parent)
end on

type dw_2 from datawindow within w_kglc02a
integer x = 37
integer y = 224
integer width = 3237
integer height = 1552
string dataobject = "dw_kglc02a2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event buttonclicked;
IF dwo.name = 'dcb_detail' THEN					/*적요내역 버튼 클릭시*/

	lstr_jpra.saupjang = this.GetItemString(this.GetRow(),"kfz10ot0_saupj")
	lstr_jpra.baldate  = this.GetItemString(this.GetRow(),"kfz10ot0_bal_date")
	lstr_jpra.upmugu   = this.GetItemString(this.GetRow(),"kfz10ot0_upmu_gu")	
	lstr_jpra.bjunno   = this.GetItemNumber(this.GetRow(),"kfz10ot0_bjun_no")
	lstr_jpra.sortno   = this.GetItemNumber(this.GetRow(),"kfz10ot0_lin_no")	
//	Open(W_Kglb04)			
END IF
end event

type dw_disp from datawindow within w_kglc02a
integer x = 32
integer y = 4
integer width = 3003
integer height = 200
string dataobject = "dw_kglc02a1"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_kglc02a
integer x = 2889
integer y = 1800
integer width = 389
integer height = 172
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kglc02a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 204
integer width = 3273
integer height = 1596
integer cornerheight = 40
integer cornerwidth = 55
end type

