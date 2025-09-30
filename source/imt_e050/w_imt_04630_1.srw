$PBExportHeader$w_imt_04630_1.srw
$PBExportComments$금형마스터-[IMAGE]
forward
global type w_imt_04630_1 from w_inherite
end type
type rr_2 from roundrectangle within w_imt_04630_1
end type
type rr_1 from roundrectangle within w_imt_04630_1
end type
type st_2 from statictext within w_imt_04630_1
end type
type sle_find from singlelineedit within w_imt_04630_1
end type
type cb_find from commandbutton within w_imt_04630_1
end type
end forward

global type w_imt_04630_1 from w_inherite
integer x = 357
integer y = 112
integer width = 3003
integer height = 2180
string title = "금형마스터-[IMAGE]"
boolean minbox = false
windowtype windowtype = response!
rr_2 rr_2
rr_1 rr_1
st_2 st_2
sle_find sle_find
cb_find cb_find
end type
global w_imt_04630_1 w_imt_04630_1

on w_imt_04630_1.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
this.st_2=create st_2
this.sle_find=create sle_find
this.cb_find=create cb_find
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_find
this.Control[iCurrent+5]=this.cb_find
end on

on w_imt_04630_1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.sle_find)
destroy(this.cb_find)
end on

event open;call super::open;f_window_center(this)

sle_find.text = Message.StringParm 

dw_insert.SetTransObject(SQLCA)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.object.imgpath[1] = sle_find.text
dw_insert.SetRedraw(True)
end event

type dw_insert from w_inherite`dw_insert within w_imt_04630_1
integer x = 69
integer y = 196
integer width = 2853
integer height = 1856
integer taborder = 0
string dataobject = "d_imt_04630_1"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;this.AcceptText()
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_04630_1
end type

type p_addrow from w_inherite`p_addrow within w_imt_04630_1
end type

type p_search from w_inherite`p_search within w_imt_04630_1
boolean visible = false
integer x = 3058
end type

type p_ins from w_inherite`p_ins within w_imt_04630_1
end type

type p_exit from w_inherite`p_exit within w_imt_04630_1
integer x = 2784
integer y = 12
end type

event p_exit::clicked;CloseWithReturn(Parent, "")
end event

type p_can from w_inherite`p_can within w_imt_04630_1
integer x = 2610
integer y = 12
end type

event p_can::clicked;call super::clicked;sle_find.text = ""
dw_insert.object.imgpath[1] = ""
end event

type p_print from w_inherite`p_print within w_imt_04630_1
end type

type p_inq from w_inherite`p_inq within w_imt_04630_1
end type

type p_del from w_inherite`p_del within w_imt_04630_1
end type

type p_mod from w_inherite`p_mod within w_imt_04630_1
integer x = 2437
integer y = 12
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_mod::ue_lbuttonup;picturename = "C:\erpman\image\확인_up.gif"
end event

event p_mod::ue_lbuttondown;picturename = "C:\erpman\image\확인_dn.gif"
end event

event p_mod::clicked;call super::clicked;CloseWithReturn(Parent, sle_find.Text)
end event

type cb_exit from w_inherite`cb_exit within w_imt_04630_1
boolean visible = false
integer x = 2121
integer y = 5000
integer width = 306
integer height = 92
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_imt_04630_1
boolean visible = false
integer x = 1472
integer y = 5000
integer width = 306
integer height = 92
integer taborder = 40
string text = "확인(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_imt_04630_1
boolean visible = false
integer x = 503
integer y = 2268
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_imt_04630_1
boolean visible = false
integer x = 1157
integer y = 1936
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_imt_04630_1
boolean visible = false
integer x = 73
integer y = 1936
integer taborder = 10
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_imt_04630_1
boolean visible = false
integer x = 869
integer y = 2260
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_imt_04630_1
boolean visible = false
integer y = 2444
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_imt_04630_1
boolean visible = false
integer x = 1797
integer y = 5000
integer width = 306
integer height = 92
end type

type cb_search from w_inherite`cb_search within w_imt_04630_1
boolean visible = false
integer x = 2542
integer y = 1936
integer width = 334
integer taborder = 100
boolean enabled = false
string text = "IMAGE"
end type

type dw_datetime from w_inherite`dw_datetime within w_imt_04630_1
boolean visible = false
integer y = 2444
end type

type sle_msg from w_inherite`sle_msg within w_imt_04630_1
boolean visible = false
integer y = 2444
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_imt_04630_1
boolean visible = false
integer y = 2392
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_04630_1
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_04630_1
end type

type rr_2 from roundrectangle within w_imt_04630_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 1801
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_imt_04630_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 184
integer width = 2949
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_imt_04630_1
integer x = 50
integer y = 72
integer width = 489
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "Image File 위치"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_find from singlelineedit within w_imt_04630_1
integer x = 549
integer y = 60
integer width = 1051
integer height = 76
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event modified;dw_insert.object.imgpath[1] = sle_find.text
end event

type cb_find from commandbutton within w_imt_04630_1
integer x = 1605
integer y = 60
integer width = 96
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "..."
end type

event clicked;string pathname, filename

integer value

string defext = "Image"
string Filter = "BMP Files (*.bmp),*.bmp," + &
					 "JPG Files (*.jpg),*.jpg," +& 
					 "JPEG Files (*.jpeg),*.jpeg," + &
					 "GIF Files (*.gif),*.gif"
					 
/* 원소스(*.BMP파일 단독으로 가져올때!) */					 
//value = GetFileOpenName("열기", pathname, filename, "BMP", "Image Files (*.BMP),*.BMP")
value = GetFileOpenName("열기", pathname, filename, defext, filter)

if value = 0 THEN return
if value <> 1 then
	MessageBox("열기 윈도우 실패","전산실로 문의 하세요!")
   return
end if

sle_find.text = pathname
dw_insert.object.imgpath[1] = sle_find.text


end event

