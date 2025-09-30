$PBExportHeader$w_preview.srw
$PBExportComments$ 미리보기화면
forward
global type w_preview from window
end type
type p_exit from uo_picture within w_preview
end type
type p_print from uo_picture within w_preview
end type
type pb_1 from uo_picture within w_preview
end type
type pb_2 from uo_picture within w_preview
end type
type pb_4 from uo_picture within w_preview
end type
type pb_3 from uo_picture within w_preview
end type
type p_unzoom from uo_picture within w_preview
end type
type p_zoom from uo_picture within w_preview
end type
type dw_preview from datawindow within w_preview
end type
type ddlb_scrzoom from dropdownlistbox within w_preview
end type
type gb_1 from groupbox within w_preview
end type
type gb_3 from groupbox within w_preview
end type
type rr_1 from roundrectangle within w_preview
end type
end forward

global type w_preview from window
boolean visible = false
integer width = 4302
integer height = 2440
boolean titlebar = true
windowtype windowtype = popup!
long backcolor = 32106727
event ue_close pbm_custom01
p_exit p_exit
p_print p_print
pb_1 pb_1
pb_2 pb_2
pb_4 pb_4
pb_3 pb_3
p_unzoom p_unzoom
p_zoom p_zoom
dw_preview dw_preview
ddlb_scrzoom ddlb_scrzoom
gb_1 gb_1
gb_3 gb_3
rr_1 rr_1
end type
global w_preview w_preview

type variables
datawindow       idw_preview

String                 is_preview       
Integer               ii_factor = 100           // 프린트 확대축소
boolean              iv_b_down = false

end variables

on w_preview.create
this.p_exit=create p_exit
this.p_print=create p_print
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_4=create pb_4
this.pb_3=create pb_3
this.p_unzoom=create p_unzoom
this.p_zoom=create p_zoom
this.dw_preview=create dw_preview
this.ddlb_scrzoom=create ddlb_scrzoom
this.gb_1=create gb_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_print,&
this.pb_1,&
this.pb_2,&
this.pb_4,&
this.pb_3,&
this.p_unzoom,&
this.p_zoom,&
this.dw_preview,&
this.ddlb_scrzoom,&
this.gb_1,&
this.gb_3,&
this.rr_1}
end on

on w_preview.destroy
destroy(this.p_exit)
destroy(this.p_print)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.p_unzoom)
destroy(this.p_zoom)
destroy(this.dw_preview)
destroy(this.ddlb_scrzoom)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event open;
F_Window_Center_Response(this)

end event

type p_exit from uo_picture within w_preview
integer x = 4073
integer y = 32
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;parent.hide()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_print from uo_picture within w_preview
integer x = 3899
integer y = 32
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;if dw_preview.RowCount() <=0 then Return

gi_page = dw_preview.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_preview)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type pb_1 from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 처음페이지로 갑니다"
integer x = 64
integer y = 84
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\FIRST_1.BMP"
end type

event clicked;dw_preview.scrolltorow(1)
end event

event ue_lbuttondown;iv_b_down = true

pb_1.PictureName =  'c:\erpman\image\first_2.bmp'

end event

event ue_lbuttonup;iv_b_down = false

pb_1.PictureName ='c:\erpman\image\first_1.bmp'

end event

type pb_2 from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 이전페이지로 갑니다"
integer x = 197
integer y = 84
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\PRIOR_1.BMP"
end type

event clicked;dw_preview.scrollpriorpage()
end event

event ue_lbuttondown;iv_b_down = true

pb_2.PictureName = 'c:\erpman\image\prior_2.bmp'

end event

event ue_lbuttonup;iv_b_down = false

pb_2.PictureName = 'c:\erpman\image\prior_1.bmp'

end event

type pb_4 from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 마지막 페이지로 갑니다"
integer x = 448
integer y = 84
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\LAST_1.BMP"
end type

event clicked;dw_preview.scrolltorow(999999999)
end event

event ue_lbuttondown;iv_b_down = true

pb_4.PictureName = 'c:\erpman\image\last_2.bmp'
end event

event ue_lbuttonup;iv_b_down = false

pb_4.PictureName = 'c:\erpman\image\last_1.bmp'
end event

type pb_3 from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 다음페이지로 갑니다"
integer x = 320
integer y = 84
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\NEXT_1.BMP"
end type

event clicked;dw_preview.scrollnextpage()
end event

event ue_lbuttondown;iv_b_down = true

pb_3.PictureName = 'c:\erpman\image\next_2.bmp'
end event

event ue_lbuttonup;iv_b_down = false

pb_3.PictureName = 'c:\erpman\image\next_1.bmp'

end event

type p_unzoom from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 화면이 작아져 보입니다!"
integer x = 960
integer y = 92
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\UNZOOM_1.BMP"
end type

event clicked;call super::clicked;string tmp

IF ii_factor > 20 THEN
	dw_preview.scrolltorow(0)
	ii_factor = ii_factor - 2
	dw_preview.Modify ("datawindow.zoom = " + String (ii_factor))
	
	ddlb_scrzoom.text  = String (ii_factor)
END IF

tmp = dw_preview.describe(" evaluate('page()',1) ")
tmp = dw_preview.describe(" evaluate('pagecount()',1) ")

end event

event ue_lbuttondown;iv_b_down = true

PictureName = 'c:\erpman\image\unzoom_2.bmp'
end event

event ue_lbuttonup;iv_b_down = false

PictureName = 'c:\erpman\image\unzoom_1.bmp'
end event

type p_zoom from uo_picture within w_preview
string tag = "Bubblehelp=버튼을 누르시면 화면이 확대되어 보입니다!"
integer x = 1051
integer y = 92
integer width = 78
integer height = 68
boolean originalsize = true
string picturename = "C:\erpman\image\ZOOM_1.BMP"
end type

event clicked;string tmp

IF ii_factor < 180 THEN
	dw_preview.scrolltorow(0)
	ii_factor = ii_factor + 2
	dw_preview.Modify ("datawindow.zoom = " + String (ii_factor))
	
	ddlb_scrzoom.text  = String (ii_factor)
END IF

tmp = dw_preview.describe(" evaluate('page()',1) ")
tmp = dw_preview.describe(" evaluate('pagecount()',1) ")

end event

event ue_lbuttondown;iv_b_down = true

PictureName = 'c:\erpman\image\zoom_2.bmp'
end event

event ue_lbuttonup;iv_b_down = false

PictureName = 'c:\erpman\image\zoom_1.bmp'
end event

type dw_preview from datawindow within w_preview
integer x = 41
integer y = 236
integer width = 4197
integer height = 2076
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type ddlb_scrzoom from dropdownlistbox within w_preview
integer x = 640
integer y = 84
integer width = 306
integer height = 348
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "100"
boolean allowedit = true
boolean sorted = false
boolean vscrollbar = true
integer limit = 3
string item[] = {"30","40","50","60","75","90","100","120","150","170","200"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
dw_preview.modify('datawindow.zoom=' + this.text)
dw_preview.setfocus()
end event

on modified;triggerevent(selectionchanged!)

end on

type gb_1 from groupbox within w_preview
integer x = 594
integer y = 4
integer width = 576
integer height = 212
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미리보기"
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_preview
integer x = 32
integer y = 4
integer width = 539
integer height = 212
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_preview
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 224
integer width = 4224
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

