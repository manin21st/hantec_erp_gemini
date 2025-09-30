$PBExportHeader$w_print_options.srw
$PBExportComments$PRINT OPTION 기능
forward
global type w_print_options from window
end type
type st_5 from statictext within w_print_options
end type
type p_cancel from picture within w_print_options
end type
type p_setup from picture within w_print_options
end type
type p_save from picture within w_print_options
end type
type p_ok from picture within w_print_options
end type
type cb_1 from commandbutton within w_print_options
end type
type st_4 from statictext within w_print_options
end type
type rr_1 from roundrectangle within w_print_options
end type
type st_1 from statictext within w_print_options
end type
type sle_last from singlelineedit within w_print_options
end type
type cb_setup from u_cb_printsetup within w_print_options
end type
type st_orientation from statictext within w_print_options
end type
type cb_cancel from commandbutton within w_print_options
end type
type st_3 from statictext within w_print_options
end type
type sle_page_range from singlelineedit within w_print_options
end type
type rb_pages from radiobutton within w_print_options
end type
type rb_current_page from radiobutton within w_print_options
end type
type rb_all_pages from radiobutton within w_print_options
end type
type em_copies from editmask within w_print_options
end type
type st_2 from statictext within w_print_options
end type
type st_printer from statictext within w_print_options
end type
type cb_ok from commandbutton within w_print_options
end type
type st_last from statictext within w_print_options
end type
type st_paper from statictext within w_print_options
end type
type rr_2 from roundrectangle within w_print_options
end type
type rr_3 from roundrectangle within w_print_options
end type
end forward

global type w_print_options from window
integer x = 617
integer y = 688
integer width = 2071
integer height = 1104
boolean titlebar = true
string title = "출력 화면 설정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
toolbaralignment toolbaralignment = alignatleft!
st_5 st_5
p_cancel p_cancel
p_setup p_setup
p_save p_save
p_ok p_ok
cb_1 cb_1
st_4 st_4
rr_1 rr_1
st_1 st_1
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
st_last st_last
st_paper st_paper
rr_2 rr_2
rr_3 rr_3
end type
global w_print_options w_print_options

type variables
datawindow idw_dw
window activesheet
string ls_filename = ""
end variables

event open;
f_window_center_response(this)

string ls_copy
string paper_mode [40]={'Default paer size for the printer', &
								'Letter 8 1/2 x 11in', &
								'LetterSmall 1/2 x 11in', &
								'Tabloid 17 x 11inches', &
								'Ledger 17 x 11in', &
								'Legal 8 1/2 x 14in', &
								'Statement 5 1/2 x 8 1/2in', &
								'Executive 7 1/4 x 10 1/2in', &
								'A3 297 x 420 mm', &
								'A4 210 x 297 mm', &
								'A4 Small 210 x 297 mm', &
								'A5 148 x 210 mm', &
								'B4 250 x 354 mm', &
								'B5 182 x 257 mm', &
								'Folio 8 1/2 x 13 in', &
								'Quarto 215 x 275mm', &
								'10x14 in', &
								'11x17 in', &
								'Note 8 1/2 x 11 in', &
								'Envelope #9 3 7/8 x 8 7/8', &
								'Envelope #10 4 1/8 x 9 1/2', &
								'Envelope #11 4 1/2 x 10 3/8', &
								'Envelope #12 4 x 11 1/276', &
								'Envelope #14 5 x 11 1/2', &
								'C size sheet', &
								'D size sheet', &
								'E size sheet', &
								'Envelope DL 110 x 220 mm', &
								'Envelope C5 162 x 229 mm', &
								'Envelope C3 324 x 458 mm', &
								'Envelope C4 229 x 324 mm', &
								'Envelope C6 114 x 162 mm', &
								'Envelope C65 114 x 229 mm', &
								'Envelope B4 250 x 353 mm', &
								'Envelope B5 176 x 250 mm', &
								'Envelope B6 176 x 125 mm', &
								'Envelope 110 x 230 mm', &
								'Envelope Monarch 3.875 x 7.5 in', &
								'6 3/4 Envelope 3 5/8 x 6 1/2 in', &
								'US Std Fanfold 14 7/8 x 11 in' }

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


string mtext, swinid, sLeft, sMid, sRight

// 출력대상 원도우 및 문서명을 가져온다
activesheet = w_mdi_frame.GetActiveSheet()

IF IsValid(activesheet) THEN
	mtext = idw_dw.describe("datawindow.objects")
	If Pos(mtext, 'left_tx') > 0 And Pos(mtext, 'mid_tx') > 0 And Pos(mtext, 'right_tx') > 0 Then
		swinid = lower(activesheet.ClassName())
		
		st_5.text = swinid
		select left_tx , mid_tx, right_tx into :sleft, :sMid, :sRight from sub2_t where window_name = :swinid;
		If IsNull(sLeft) Or Trim(sLeft)   = '' Then sLeft = ''
		If IsNull(sRight) Or Trim(sRight) = '' Then sRight = ''
		If IsNull(sMid) Or Trim(sMid)     = '' Then sMid = ''
		
		idw_dw.Object.left_tx.text = sleft
		idw_dw.Object.mid_tx.text  = sMid
		idw_dw.Object.right_tx.text = sRight
	End If
END IF
end event

on w_print_options.create
this.st_5=create st_5
this.p_cancel=create p_cancel
this.p_setup=create p_setup
this.p_save=create p_save
this.p_ok=create p_ok
this.cb_1=create cb_1
this.st_4=create st_4
this.rr_1=create rr_1
this.st_1=create st_1
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
this.st_last=create st_last
this.st_paper=create st_paper
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.st_5,&
this.p_cancel,&
this.p_setup,&
this.p_save,&
this.p_ok,&
this.cb_1,&
this.st_4,&
this.rr_1,&
this.st_1,&
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
this.st_last,&
this.st_paper,&
this.rr_2,&
this.rr_3}
end on

on w_print_options.destroy
destroy(this.st_5)
destroy(this.p_cancel)
destroy(this.p_setup)
destroy(this.p_save)
destroy(this.p_ok)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.st_1)
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
destroy(this.st_last)
destroy(this.st_paper)
destroy(this.rr_2)
destroy(this.rr_3)
end on

type st_5 from statictext within w_print_options
integer x = 1362
integer y = 36
integer width = 626
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[NONE]"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_cancel from picture within w_print_options
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 448
integer y = 1388
integer width = 475
integer height = 100
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\닫기01_up.jpg"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_cancel.PictureName = 'C:\erpman\image\닫기01_dn.jpg'
end event

event ue_lbuttonup;p_cancel.PictureName = 'C:\erpman\image\닫기01_up.jpg'
end event

event clicked;cb_cancel.TriggerEvent(Clicked!)
end event

type p_setup from picture within w_print_options
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 448
integer y = 1292
integer width = 475
integer height = 100
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\인쇄설정01_up.jpg"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_setup.PictureName = 'C:\erpman\image\인쇄설정01_dn.jpg'
end event

event ue_lbuttonup;p_setup.PictureName = 'C:\erpman\image\인쇄설정01_up.jpg'
end event

event clicked;cb_setup.TriggerEvent(Clicked!)
end event

type p_save from picture within w_print_options
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 448
integer y = 1196
integer width = 475
integer height = 100
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\파일저장01_up.jpg"
boolean focusrectangle = false
end type

event ue_lbuttonup;p_save.PictureName = 'C:\erpman\image\파일저장01_up.jpg'
end event

event ue_lbuttondown;p_save.PictureName = 'C:\erpman\image\파일저장01_dn.jpg'
end event

event clicked;cb_1.TriggerEvent(Clicked!)
end event

type p_ok from picture within w_print_options
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 448
integer y = 1100
integer width = 475
integer height = 100
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\인쇄01_up.jpg"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_ok.PictureName = 'C:\erpman\image\인쇄01_dn.jpg'
end event

event ue_lbuttonup;p_ok.PictureName = 'C:\erpman\image\인쇄01_up.jpg'
end event

event clicked;cb_ok.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_print_options
integer x = 1509
integer y = 680
integer width = 439
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "파일저장(&S)"
end type

event clicked;idw_dw.SaveAs()

//int li_rtn
//string ls_path, &
//       ls_name
//
////idw_dw = str_dw.idw
////------------한글 제목을 excel로 가져오는 부분-----------------
//li_rtn = GetFileSaveName("Save File", &
//                         ls_path, ls_name, "XLS", &
//                         "Excel Files (*.XLS), *.XLS")
//
//IF li_rtn = 1  THEN
//   SetPointer(HourGlass!)
//	//dw이름으로 txt파일로 저장하고 그걸 다시 excel파일로 저장한다..
//	idw_dw.SaveAsAscii('c:\'+idw_dw.dataobject+'.txt')
//	
//	oleobject myole
//	
//	int i
//	
//	myole = create oleobject
//	
//	i = myole.connecttonewobject("excel.application")
//	
//	if i <> 0 then
//		messagebox('!','실패')
//		destroy myole
//		return
//	end if
//	
//   SetPointer(HourGlass!)
//	myole.workbooks.open('c:\'+idw_dw.dataobject+'.txt')
//	//-4143은 excel통합문서 format이다..
//	myole.application.workbooks(1).saveas(ls_path, -4143)
//	myole.application.quit
//	myole.disconnectobject()
//	destroy myole
//   MessageBox("저장","EXCEL File이" + ls_path + "에 생성되었습니다")
//ELSE
//   MessageBox("확인","EXCEL File 생성을 취소했습니다")
//END IF 
////---------------------------------------------------
end event

type st_4 from statictext within w_print_options
integer x = 18
integer y = 504
integer width = 384
integer height = 52
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "[인쇄범위]"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_print_options
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 108
integer width = 2007
integer height = 364
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_1 from statictext within w_print_options
integer x = 18
integer y = 32
integer width = 773
integer height = 52
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "[프린터/출력상태/매수]"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_last from singlelineedit within w_print_options
integer x = 1490
integer y = 360
integer width = 325
integer height = 72
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
end type

type cb_setup from u_cb_printsetup within w_print_options
integer x = 1509
integer y = 776
integer width = 439
integer height = 84
integer taborder = 20
integer textsize = -9
string text = "인쇄설정(&P)"
end type

event clicked;call super::clicked;st_printer.text = "프린터 : " + string(idw_dw.object.datawindow.printer)
end event

type st_orientation from statictext within w_print_options
integer x = 46
integer y = 284
integer width = 1929
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력방향 :"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_print_options
integer x = 1509
integer y = 872
integer width = 439
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫    기(&C)"
boolean cancel = true
end type

event clicked;closewithreturn(parent, -1)
end event

type st_3 from statictext within w_print_options
integer x = 82
integer y = 840
integer width = 1175
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "쉼표로 구분하여 쪽 번호 및 쪽 범위를 입력하십시오. 예) 1, 3, 5-12 "
boolean focusrectangle = false
end type

type sle_page_range from singlelineedit within w_print_options
integer x = 526
integer y = 740
integer width = 837
integer height = 76
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
end type

event getfocus;rb_all_pages.checked = false
rb_current_page.checked = false
rb_pages.checked = true
end event

type rb_pages from radiobutton within w_print_options
integer x = 41
integer y = 748
integer width = 485
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "PAGE 번호(&I)"
end type

type rb_current_page from radiobutton within w_print_options
integer x = 41
integer y = 676
integer width = 489
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "현재 PAGE(&E)"
end type

type rb_all_pages from radiobutton within w_print_options
integer x = 41
integer y = 604
integer width = 448
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체(&A)"
boolean checked = true
end type

type em_copies from editmask within w_print_options
integer x = 411
integer y = 360
integer width = 352
integer height = 72
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "1"
string mask = "#####"
boolean spin = true
string displaydata = ""
end type

type st_2 from statictext within w_print_options
integer x = 50
integer y = 368
integer width = 338
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "인쇄매수 :"
boolean focusrectangle = false
end type

type st_printer from statictext within w_print_options
integer x = 46
integer y = 140
integer width = 1929
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "프 린 터 :"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_print_options
integer x = 1509
integer y = 588
integer width = 439
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인    쇄(&O)"
boolean default = true
end type

event clicked;string ls_modify, ls_page, ls_return
Long   ll_row

ls_modify = "datawindow.print.copies=" + em_copies.text

//if cbx_print_file.checked then
//	ls_modify = ls_modify + "datawindow.print.filename='" + ls_filename + "'"
//else
	ls_modify = ls_modify + "datawindow.print.filename=''"
//end if

if rb_all_pages.checked then
	ls_modify = ls_modify + "datawindow.print.page.range=''"
elseif rb_current_page.checked then
	ll_row = long(idw_dw.describe("datawindow.firstrowonpage"))
	idw_dw.object.datawindow.print.page.range = idw_dw.describe("evaluate('page()', " + idw_dw.object.datawindow.firstrowonpage + ")")
else
	ls_modify = ls_modify + "datawindow.print.page.range='" + sle_page_range.text + "'"
end if

ls_return = idw_dw.modify(ls_modify)

if ls_return <> "" then
	messagebox("확인", ls_return)
end if

//parent.visible = false

idw_dw.print(true)

this.setfocus()

close(parent)
end event

type st_last from statictext within w_print_options
integer x = 1010
integer y = 368
integer width = 503
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "마지막 페이지:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_paper from statictext within w_print_options
integer x = 46
integer y = 212
integer width = 1929
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력용지 :"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_print_options
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 572
integer width = 1413
integer height = 404
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_print_options
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1449
integer y = 572
integer width = 567
integer height = 404
integer cornerheight = 40
integer cornerwidth = 55
end type

