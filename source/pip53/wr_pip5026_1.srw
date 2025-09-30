$PBExportHeader$wr_pip5026_1.srw
$PBExportComments$** PRINT OPTION 기능2
forward
global type wr_pip5026_1 from window
end type
type cbx_print_file from checkbox within wr_pip5026_1
end type
type sle_last from singlelineedit within wr_pip5026_1
end type
type cb_setup from u_cb_printsetup within wr_pip5026_1
end type
type st_orientation from statictext within wr_pip5026_1
end type
type cb_cancel from commandbutton within wr_pip5026_1
end type
type st_3 from statictext within wr_pip5026_1
end type
type sle_page_range from singlelineedit within wr_pip5026_1
end type
type rb_pages from radiobutton within wr_pip5026_1
end type
type rb_current_page from radiobutton within wr_pip5026_1
end type
type rb_all_pages from radiobutton within wr_pip5026_1
end type
type em_copies from editmask within wr_pip5026_1
end type
type st_2 from statictext within wr_pip5026_1
end type
type st_printer from statictext within wr_pip5026_1
end type
type cb_ok from commandbutton within wr_pip5026_1
end type
type gb_4 from groupbox within wr_pip5026_1
end type
type gb_1 from groupbox within wr_pip5026_1
end type
type st_last from statictext within wr_pip5026_1
end type
type st_paper from statictext within wr_pip5026_1
end type
type gb_2 from groupbox within wr_pip5026_1
end type
end forward

global type wr_pip5026_1 from window
integer x = 617
integer y = 688
integer width = 2446
integer height = 1016
boolean titlebar = true
string title = "출력 화면 설정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
toolbaralignment toolbaralignment = alignatleft!
cbx_print_file cbx_print_file
sle_last sle_last
cb_setup cb_setup
st_orientation st_orientation
cb_cancel cb_cancel
st_3 st_3
sle_page_range sle_page_range
rb_pages rb_pages
rb_current_page rb_current_page
rb_all_pages rb_all_pages
em_copies em_copies
st_2 st_2
st_printer st_printer
cb_ok cb_ok
gb_4 gb_4
gb_1 gb_1
st_last st_last
st_paper st_paper
gb_2 gb_2
end type
global wr_pip5026_1 wr_pip5026_1

type variables
datawindow idw_dw
string ls_filename = ""
end variables

event open;
f_window_center(this)

string ls_copy
string paper_mode [11]={'Default paer size for the printer', &
								'Letter 8 1/2 x 11in', &
								'LetterSmall 1/2 x 11in', &
								'Tabloid 17 x 11inches', &
								'Ledger 17 x 11in', &
								'Legal 8 1/2 x 14in', &
								'Statement 5 1/2 x 8 1/2in', &
								'Executive 7 1/4 x 10 1/2in', &
								'A3 297 x 420 mm', &
								'A4 210 x 297 mm', &
								'A4 Small 210 x 297 mm'}
							

idw_dw = message.powerobjectparm

string paper_size, paper_orientation

paper_size = idw_dw.object.datawindow.print.paper.size
paper_orientation = idw_dw.object.datawindow.print.orientation

st_printer.text = "프 린 터 : "   + string(idw_dw.object.datawindow.printer)
st_paper.text 	 = "출력용지 : " + paper_mode[dec(paper_size) + 1]
Choose case paper_orientation
		 case '0'
				st_orientation.text = "출력방향 : " + "The default orientation for your printer"
		 case '1'
				st_orientation.text = "출력방향 : " + "Landscape(가로)"
		 case '2'
				st_orientation.text = "출력방향 : " + "Portrait(세로)"				
End choose

ls_copy = string(idw_dw.object.datawindow.print.copies)

if ls_copy <> "" and ls_copy <> "0" then
   em_copies.text = ls_copy
else
   em_copies.text = "1"
end If

sle_last.text = string(gi_page)

ls_filename = trim(string(idw_dw.object.datawindow.print.filename))

cbx_print_file.checked = (ls_filename <> "")
end event

on wr_pip5026_1.create
this.cbx_print_file=create cbx_print_file
this.sle_last=create sle_last
this.cb_setup=create cb_setup
this.st_orientation=create st_orientation
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.sle_page_range=create sle_page_range
this.rb_pages=create rb_pages
this.rb_current_page=create rb_current_page
this.rb_all_pages=create rb_all_pages
this.em_copies=create em_copies
this.st_2=create st_2
this.st_printer=create st_printer
this.cb_ok=create cb_ok
this.gb_4=create gb_4
this.gb_1=create gb_1
this.st_last=create st_last
this.st_paper=create st_paper
this.gb_2=create gb_2
this.Control[]={this.cbx_print_file,&
this.sle_last,&
this.cb_setup,&
this.st_orientation,&
this.cb_cancel,&
this.st_3,&
this.sle_page_range,&
this.rb_pages,&
this.rb_current_page,&
this.rb_all_pages,&
this.em_copies,&
this.st_2,&
this.st_printer,&
this.cb_ok,&
this.gb_4,&
this.gb_1,&
this.st_last,&
this.st_paper,&
this.gb_2}
end on

on wr_pip5026_1.destroy
destroy(this.cbx_print_file)
destroy(this.sle_last)
destroy(this.cb_setup)
destroy(this.st_orientation)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.sle_page_range)
destroy(this.rb_pages)
destroy(this.rb_current_page)
destroy(this.rb_all_pages)
destroy(this.em_copies)
destroy(this.st_2)
destroy(this.st_printer)
destroy(this.cb_ok)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.st_last)
destroy(this.st_paper)
destroy(this.gb_2)
end on

type cbx_print_file from checkbox within wr_pip5026_1
integer x = 1920
integer y = 816
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "FILE 저장"
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_file, ls_file_name

if this.checked then
//	getfilesavename("FILE 저장 선택", ls_file_name, ls_file, "XLS", "EXCEL Files (*.XLS), *.XLS," + &
//	                                                                " TEXT Files (*.TXT), *.TXT," + &
//						                                                 "  DOC Files (*.DOC), *.DOC")
	idw_dw.saveas()
else
	ls_file_name = ""
end if
end event

type sle_last from singlelineedit within wr_pip5026_1
integer x = 1486
integer y = 336
integer width = 325
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_setup from u_cb_printsetup within wr_pip5026_1
integer x = 1861
integer y = 620
integer width = 475
integer height = 84
integer taborder = 20
integer textsize = -9
end type

event clicked;call super::clicked;st_printer.text = "프린터 : " + string(idw_dw.object.datawindow.printer)
end event

type st_orientation from statictext within wr_pip5026_1
integer x = 69
integer y = 264
integer width = 2309
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "출력방향 :"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within wr_pip5026_1
integer x = 1861
integer y = 712
integer width = 475
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;closewithreturn(parent, -1)
end event

type st_3 from statictext within wr_pip5026_1
integer x = 146
integer y = 780
integer width = 1175
integer height = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "쉼표로 구분하여 쪽 번호 및 쪽 범위를 입력하십시오. 예) 1, 3, 5-12 "
boolean focusrectangle = false
end type

type sle_page_range from singlelineedit within wr_pip5026_1
integer x = 558
integer y = 676
integer width = 1179
integer height = 84
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;rb_all_pages.checked = false
rb_current_page.checked = false
rb_pages.checked = true
end event

type rb_pages from radiobutton within wr_pip5026_1
integer x = 69
integer y = 692
integer width = 485
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "PAGE 번호(&I)"
borderstyle borderstyle = stylelowered!
end type

type rb_current_page from radiobutton within wr_pip5026_1
integer x = 69
integer y = 620
integer width = 489
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "현재 PAGE(&E)"
borderstyle borderstyle = stylelowered!
end type

type rb_all_pages from radiobutton within wr_pip5026_1
integer x = 69
integer y = 548
integer width = 448
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체(&A)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type em_copies from editmask within wr_pip5026_1
integer x = 407
integer y = 336
integer width = 352
integer height = 84
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string displaydata = ""
end type

type st_2 from statictext within wr_pip5026_1
integer x = 73
integer y = 348
integer width = 338
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "인쇄매수 :"
boolean focusrectangle = false
end type

type st_printer from statictext within wr_pip5026_1
integer x = 69
integer y = 120
integer width = 2309
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "프 린 터 :"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within wr_pip5026_1
integer x = 1861
integer y = 528
integer width = 475
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&O)"
end type

event clicked;string ls_modify, ls_page, ls_return

ls_modify = "datawindow.print.copies=" + em_copies.text

if cbx_print_file.checked then
	ls_modify = ls_modify + "datawindow.print.filename='" + ls_filename + "'"
else
	ls_modify = ls_modify + "datawindow.print.filename=''"
end if

if rb_all_pages.checked then
	ls_modify = ls_modify + "datawindow.print.page.range=''"
elseif rb_current_page.checked then
	ls_page = idw_dw.describe("evaluate('page()', " + string(idw_dw.getrow()) + ")")
	ls_modify = ls_modify + "datawindow.print.page.range='" + ls_page + "'"
else
	ls_modify = ls_modify + "datawindow.print.page.range='" + sle_page_range.text + "'"
end if

ls_return = idw_dw.modify(ls_modify)

if ls_return <> "" then
	messagebox("확인", ls_return)
end if

parent.visible = false

idw_dw.modify("st_name.text = '<발행자 보관용>'")
idw_dw.print(true)
idw_dw.modify("st_name.text = '<발행자 보고용>'")
idw_dw.print(true)
idw_dw.modify("st_name.text = '<소득자 보관용>'")
idw_dw.print(true)

this.setfocus()

close(parent)
end event

type gb_4 from groupbox within wr_pip5026_1
integer x = 1810
integer y = 456
integer width = 590
integer height = 452
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_1 from groupbox within wr_pip5026_1
integer x = 27
integer y = 456
integer width = 1774
integer height = 452
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "인쇄 범위"
borderstyle borderstyle = stylelowered!
end type

type st_last from statictext within wr_pip5026_1
integer x = 1006
integer y = 348
integer width = 503
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "마지막 페이지:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_paper from statictext within wr_pip5026_1
integer x = 69
integer y = 192
integer width = 2309
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "출력용지 :"
boolean focusrectangle = false
end type

type gb_2 from groupbox within wr_pip5026_1
integer x = 27
integer y = 28
integer width = 2373
integer height = 408
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "프린터 / 출력상태 / 매수"
end type

