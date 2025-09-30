$PBExportHeader$w_preview_option.srw
$PBExportComments$미리보기 옵션-권
forward
global type w_preview_option from window
end type
type p_4 from uo_picture within w_preview_option
end type
type p_3 from uo_picture within w_preview_option
end type
type st_9 from statictext within w_preview_option
end type
type st_8 from statictext within w_preview_option
end type
type em_zoom from editmask within w_preview_option
end type
type st_6 from statictext within w_preview_option
end type
type st_5 from statictext within w_preview_option
end type
type st_4 from statictext within w_preview_option
end type
type ddlb_3 from dropdownlistbox within w_preview_option
end type
type ddlb_2 from dropdownlistbox within w_preview_option
end type
type ddlb_1 from dropdownlistbox within w_preview_option
end type
type st_3 from statictext within w_preview_option
end type
type sle_3 from singlelineedit within w_preview_option
end type
type sle_2 from singlelineedit within w_preview_option
end type
type st_2 from statictext within w_preview_option
end type
type st_1 from statictext within w_preview_option
end type
type sle_1 from singlelineedit within w_preview_option
end type
type rb_2 from radiobutton within w_preview_option
end type
type p_2 from picture within w_preview_option
end type
type p_1 from picture within w_preview_option
end type
type rb_1 from radiobutton within w_preview_option
end type
type sle_5 from singlelineedit within w_preview_option
end type
type rr_1 from roundrectangle within w_preview_option
end type
end forward

global type w_preview_option from window
integer width = 1778
integer height = 1616
boolean titlebar = true
string title = "인쇄 설정"
windowtype windowtype = response!
long backcolor = 32106727
p_4 p_4
p_3 p_3
st_9 st_9
st_8 st_8
em_zoom em_zoom
st_6 st_6
st_5 st_5
st_4 st_4
ddlb_3 ddlb_3
ddlb_2 ddlb_2
ddlb_1 ddlb_1
st_3 st_3
sle_3 sle_3
sle_2 sle_2
st_2 st_2
st_1 st_1
sle_1 sle_1
rb_2 rb_2
p_2 p_2
p_1 p_1
rb_1 rb_1
sle_5 sle_5
rr_1 rr_1
end type
global w_preview_option w_preview_option

type variables
datawindow 		idw_list

end variables

on w_preview_option.create
this.p_4=create p_4
this.p_3=create p_3
this.st_9=create st_9
this.st_8=create st_8
this.em_zoom=create em_zoom
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.ddlb_3=create ddlb_3
this.ddlb_2=create ddlb_2
this.ddlb_1=create ddlb_1
this.st_3=create st_3
this.sle_3=create sle_3
this.sle_2=create sle_2
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.rb_2=create rb_2
this.p_2=create p_2
this.p_1=create p_1
this.rb_1=create rb_1
this.sle_5=create sle_5
this.rr_1=create rr_1
this.Control[]={this.p_4,&
this.p_3,&
this.st_9,&
this.st_8,&
this.em_zoom,&
this.st_6,&
this.st_5,&
this.st_4,&
this.ddlb_3,&
this.ddlb_2,&
this.ddlb_1,&
this.st_3,&
this.sle_3,&
this.sle_2,&
this.st_2,&
this.st_1,&
this.sle_1,&
this.rb_2,&
this.p_2,&
this.p_1,&
this.rb_1,&
this.sle_5,&
this.rr_1}
end on

on w_preview_option.destroy
destroy(this.p_4)
destroy(this.p_3)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.em_zoom)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.ddlb_3)
destroy(this.ddlb_2)
destroy(this.ddlb_1)
destroy(this.st_3)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.rb_2)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.rb_1)
destroy(this.sle_5)
destroy(this.rr_1)
end on

event open;f_window_center(This)

idw_list = message.powerobjectparm

string paper_size, paper_orientation, ls_prtnm, ls_zoom

paper_size = idw_list.object.datawindow.print.paper.size
paper_orientation = idw_list.object.datawindow.print.orientation
ls_prtnm = idw_list.object.datawindow.printer
ls_zoom  = idw_list.object.datawindow.zoom
//st_printer.text = "프 린 터 : "   + string()
//st_paper.text 	 = "출력용지 : " + paper_mode[dec(paper_size) + 1]
Choose case paper_orientation
		 case '1'	//가로
				rb_2.Checked = True
		 case '2'	//세로
				rb_1.Checked = True
End choose

em_zoom.Text = ls_zoom

String	ls_printer, ls_orientation

nvo_PowerPrn = CREATE n_PowerPrinter

// default printer
ls_printer = nvo_PowerPrn.of_GetDefaultPrinterName()
// default printer orientation
ls_orientation = nvo_PowerPrn.of_GetPrinterOrientationString()

string	sName, sDriver, sPort

//// get
nvo_PowerPrn.of_GetDefaultPrinterEx(sName, sDriver, sPort)


//프린터 종류

string lsPrnList, lsprnName
long i, iPos

ddlb_1.reset()

lsPrnList = nvo_PowerPrn.of_GetPrinterList()

// printer names are separated by semicolon
iPos = pos(lsPrnlist , ";")
do while iPos > 0 
	lsprnName = left(lsPrnList, iPos -1)
	ddlb_1.AddItem(lsPrnName)
		
	lsPrnList = right(lsPrnList, len(lsPrnList) - iPos)
	iPos = pos(lsPrnlist , ";")
loop



//공급장치 

string lsBinList, lsBinName
integer iStart, iLen


ddlb_3.reset()


	lsBinList = nvo_PowerPrn.of_GetNamedPaperBinList()

iLen = len(lsBinList)
iStart = 1
iPos = pos(lsBinList, ";")

do while (iPos > 0 )
	
	lsBinName = mid(lsBinList, iStart, (iPos - iStart))
	ddlb_3.AddItem(lsBinName)
	iStart = iPos + 1
	iPos = pos(lsBinList, ";", iStart)
loop

//페이퍼 사이즈

string lsPaperList, lsPaperName

ddlb_2.reset()

lsPaperList = nvo_PowerPrn.of_GetSupportedPaperSizeList()

iLen = len(lsPaperList)
iStart = 1
iPos = pos(lspaperList, ";")

do while (iPos > 0 )
	
	lspaperName = mid(lsPaperList, iStart, (iPos - iStart))
	ddlb_2.AddItem(lsPaperName)
	iStart = iPos + 1
	iPos = pos(lsPaperList, ";", iStart)
loop

ddlb_1.Text = sName





end event

event close;DESTROY nvo_PowerPrn
end event

type p_4 from uo_picture within w_preview_option
integer x = 1536
integer y = 1356
integer width = 178
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;CloseWithReturn(Parent, idw_list)
end event

type p_3 from uo_picture within w_preview_option
integer x = 1358
integer y = 1356
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;string ls_modify, ls_page, ls_return
int		i

IF rb_1.Checked THEN 	//세로
	ls_modify = "datawindow.print.orientation= '2'"
ELSEIF rb_2.Checked THEN 	//가로
	ls_modify = "datawindow.print.orientation= '1'"
END IF

integer iSize
string sPaperSize

sPaperSize = ddlb_2.Text

iSize = integer(left(spaperSize, pos(sPaperSize, " ")))

String ls_factor

ls_factor = em_zoom.Text
ls_modify = ls_modify + "datawindow.zoom = '" + ls_factor + "'"

ls_modify = ls_modify + "datawindow.print.paper.size = '" + String(iSize) + "'"

idw_list.modify(ls_modify)
CloseWithReturn(w_preview_option, idw_list)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type st_9 from statictext within w_preview_option
integer x = 466
integer y = 808
integer width = 434
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "확대/축소 배율"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within w_preview_option
integer x = 1271
integer y = 804
integer width = 78
integer height = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33027312
string text = "%"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_zoom from editmask within w_preview_option
integer x = 1019
integer y = 792
integer width = 247
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "100"
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
double increment = 5
end type

type st_6 from statictext within w_preview_option
integer x = 78
integer y = 664
integer width = 251
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "배율"
boolean focusrectangle = false
end type

type st_5 from statictext within w_preview_option
integer x = 288
integer y = 1212
integer width = 146
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "공급"
boolean focusrectangle = false
end type

type st_4 from statictext within w_preview_option
integer x = 288
integer y = 1076
integer width = 146
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "용지"
boolean focusrectangle = false
end type

type ddlb_3 from dropdownlistbox within w_preview_option
integer x = 457
integer y = 1192
integer width = 1065
integer height = 700
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean vscrollbar = true
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type ddlb_2 from dropdownlistbox within w_preview_option
integer x = 457
integer y = 1060
integer width = 1065
integer height = 700
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean vscrollbar = true
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type ddlb_1 from dropdownlistbox within w_preview_option
integer x = 457
integer y = 208
integer width = 1065
integer height = 700
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean vscrollbar = true
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_preview_option
integer x = 78
integer y = 944
integer width = 251
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "용지설정"
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_preview_option
integer x = 338
integer y = 964
integer width = 1335
integer height = 16
integer taborder = 20
integer textsize = -2
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_preview_option
integer x = 338
integer y = 396
integer width = 1335
integer height = 16
integer taborder = 10
integer textsize = -2
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_preview_option
integer x = 78
integer y = 380
integer width = 251
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "용지방향"
boolean focusrectangle = false
end type

type st_1 from statictext within w_preview_option
integer x = 78
integer y = 96
integer width = 229
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "프린터"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_preview_option
integer x = 338
integer y = 112
integer width = 1335
integer height = 16
integer taborder = 10
integer textsize = -2
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_preview_option
integer x = 1253
integer y = 520
integer width = 288
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "가로"
end type

type p_2 from picture within w_preview_option
integer x = 1061
integer y = 500
integer width = 160
integer height = 108
boolean originalsize = true
string picturename = "C:\erpman\image\가로.jpg"
boolean focusrectangle = false
end type

type p_1 from picture within w_preview_option
integer x = 425
integer y = 484
integer width = 133
integer height = 140
boolean originalsize = true
string picturename = "C:\erpman\image\세로.jpg"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_preview_option
integer x = 594
integer y = 520
integer width = 288
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "세로"
end type

type sle_5 from singlelineedit within w_preview_option
integer x = 338
integer y = 680
integer width = 1335
integer height = 16
integer taborder = 20
boolean bringtotop = true
integer textsize = -2
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_preview_option
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 40
integer width = 1701
integer height = 1300
integer cornerheight = 40
integer cornerwidth = 55
end type

