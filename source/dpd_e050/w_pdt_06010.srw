$PBExportHeader$w_pdt_06010.srw
$PBExportComments$** 설비마스터[IMAGE]
forward
global type w_pdt_06010 from w_inherite
end type
type rr_2 from roundrectangle within w_pdt_06010
end type
type st_2 from statictext within w_pdt_06010
end type
type cb_find from commandbutton within w_pdt_06010
end type
type sle_find from singlelineedit within w_pdt_06010
end type
type rr_1 from roundrectangle within w_pdt_06010
end type
end forward

global type w_pdt_06010 from w_inherite
integer x = 82
integer y = 112
integer width = 3584
integer height = 2320
string title = "Image File 찾기"
boolean minbox = false
windowtype windowtype = response!
rr_2 rr_2
st_2 st_2
cb_find cb_find
sle_find sle_find
rr_1 rr_1
end type
global w_pdt_06010 w_pdt_06010

on w_pdt_06010.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.st_2=create st_2
this.cb_find=create cb_find
this.sle_find=create sle_find
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_find
this.Control[iCurrent+4]=this.sle_find
this.Control[iCurrent+5]=this.rr_1
end on

on w_pdt_06010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.st_2)
destroy(this.cb_find)
destroy(this.sle_find)
destroy(this.rr_1)
end on

event open;call super::open;sle_find.text = Message.StringParm 
dw_insert.SetTransObject(SQLCA)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.object.imgpath[1] = sle_find.text
dw_insert.SetRedraw(True)
end event

type dw_insert from w_inherite`dw_insert within w_pdt_06010
integer x = 46
integer y = 228
integer width = 3479
integer height = 1956
integer taborder = 0
string dataobject = "d_pdt_06010_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;this.AcceptText()
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06010
integer x = 3598
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06010
integer x = 3424
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06010
integer x = 2729
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06010
integer x = 3250
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06010
integer x = 3378
integer y = 16
end type

event p_exit::clicked;CloseWithReturn(Parent, "")
end event

type p_can from w_inherite`p_can within w_pdt_06010
integer x = 3205
integer y = 16
end type

event p_can::clicked;call super::clicked;sle_find.text = ""
dw_insert.object.imgpath[1] = ""
end event

type p_print from w_inherite`p_print within w_pdt_06010
integer x = 2903
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06010
integer x = 3077
integer y = 5000
end type

type p_del from w_inherite`p_del within w_pdt_06010
integer x = 3945
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_06010
integer x = 3031
integer y = 16
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event p_mod::clicked;call super::clicked;CloseWithReturn(Parent, sle_find.Text)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06010
boolean visible = false
integer x = 2592
integer y = 5000
integer width = 306
integer height = 92
integer taborder = 70
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06010
boolean visible = false
integer x = 1902
integer y = 5000
integer width = 306
integer height = 92
integer taborder = 40
integer textsize = -9
string text = "확인(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06010
boolean visible = false
integer x = 503
integer y = 2308
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_pdt_06010
boolean visible = false
integer x = 1157
integer y = 1936
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06010
boolean visible = false
integer x = 73
integer y = 1936
integer taborder = 10
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_06010
boolean visible = false
integer x = 869
integer y = 2300
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_pdt_06010
boolean visible = false
integer x = 87
integer y = 2476
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06010
boolean visible = false
integer x = 2249
integer y = 5000
integer width = 306
integer height = 92
integer textsize = -9
end type

type cb_search from w_inherite`cb_search within w_pdt_06010
boolean visible = false
integer x = 2542
integer y = 1936
integer width = 334
integer taborder = 100
boolean enabled = false
string text = "IMAGE"
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_06010
boolean visible = false
integer x = 2930
integer y = 2476
end type

type sle_msg from w_inherite`sle_msg within w_pdt_06010
boolean visible = false
integer x = 439
integer y = 2476
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06010
boolean visible = false
integer x = 69
integer y = 2424
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06010
end type

type rr_2 from roundrectangle within w_pdt_06010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 20
integer width = 2505
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_pdt_06010
integer x = 50
integer y = 60
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "Image File 위치"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_find from commandbutton within w_pdt_06010
integer x = 2318
integer y = 52
integer width = 96
integer height = 76
integer taborder = 20
boolean bringtotop = true
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
value = GetFileOpenName("열기", pathname, filename, "BMP", "Bmp Files (*.bmp),*.bmp,JPEG (*.jpg),*.jpg")

if value = 0 THEN return
if value <> 1 then
	MessageBox("열기 윈도우 실패","전산실로 문의 하세요!")
   return
end if

sle_find.text = pathname
dw_insert.object.imgpath[1] = sle_find.text


end event

type sle_find from singlelineedit within w_pdt_06010
integer x = 526
integer y = 52
integer width = 1787
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;dw_insert.object.imgpath[1] = sle_find.text
end event

type rr_1 from roundrectangle within w_pdt_06010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 184
integer width = 3529
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

