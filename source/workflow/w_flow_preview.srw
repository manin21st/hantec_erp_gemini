$PBExportHeader$w_flow_preview.srw
$PBExportComments$미리보기
forward
global type w_flow_preview from window
end type
type cb_12 from commandbutton within w_flow_preview
end type
type cb_11 from commandbutton within w_flow_preview
end type
type cb_10 from commandbutton within w_flow_preview
end type
type cb_9 from commandbutton within w_flow_preview
end type
type pb_4 from picturebutton within w_flow_preview
end type
type gb_5 from groupbox within w_flow_preview
end type
type st_4 from statictext within w_flow_preview
end type
type pb_prior from picturebutton within w_flow_preview
end type
type pb_first from picturebutton within w_flow_preview
end type
type pb_last from picturebutton within w_flow_preview
end type
type pb_next from picturebutton within w_flow_preview
end type
type st_3 from statictext within w_flow_preview
end type
type ddlb_zoom from dropdownlistbox within w_flow_preview
end type
type st_2 from statictext within w_flow_preview
end type
type st_1 from statictext within w_flow_preview
end type
type ddlb_range from dropdownlistbox within w_flow_preview
end type
type cbx_rulers from checkbox within w_flow_preview
end type
type pb_3 from picturebutton within w_flow_preview
end type
type pb_2 from picturebutton within w_flow_preview
end type
type cb_7 from commandbutton within w_flow_preview
end type
type cb_6 from commandbutton within w_flow_preview
end type
type cb_5 from commandbutton within w_flow_preview
end type
type cb_4 from commandbutton within w_flow_preview
end type
type cb_3 from commandbutton within w_flow_preview
end type
type cb_2 from commandbutton within w_flow_preview
end type
type cb_1 from commandbutton within w_flow_preview
end type
type dw_list from datawindow within w_flow_preview
end type
type gb_1 from groupbox within w_flow_preview
end type
type gb_2 from groupbox within w_flow_preview
end type
type gb_3 from groupbox within w_flow_preview
end type
type gb_4 from groupbox within w_flow_preview
end type
type pb_1 from picturebutton within w_flow_preview
end type
type st_5 from statictext within w_flow_preview
end type
end forward

global type w_flow_preview from window
integer width = 4576
integer height = 2852
boolean titlebar = true
string title = "미리보기"
boolean controlmenu = true
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 80269524
event ue_fileopen ( )
event ue_zoom ( )
event ue_unzoom ( )
event ue_ruler ( )
event ue_print ( )
event ue_pagescroll pbm_custom02
cb_12 cb_12
cb_11 cb_11
cb_10 cb_10
cb_9 cb_9
pb_4 pb_4
gb_5 gb_5
st_4 st_4
pb_prior pb_prior
pb_first pb_first
pb_last pb_last
pb_next pb_next
st_3 st_3
ddlb_zoom ddlb_zoom
st_2 st_2
st_1 st_1
ddlb_range ddlb_range
cbx_rulers cbx_rulers
pb_3 pb_3
pb_2 pb_2
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_list dw_list
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
pb_1 pb_1
st_5 st_5
end type
global w_flow_preview w_flow_preview

type variables
String print_gu                 //window가 조회인지 인쇄인지  

String     is_today            //시작일자
String     is_totime           //시작시간
String     is_window_id    //윈도우 ID
String     is_usegub         //이력관리 여부
String     is_preview        // dw상태가 preview인지
boolean	  ib_ruler
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
boolean   ib_zoom = false

Datawindow	idw_dataobject

//DataWindow 				idw_Print // 미리보기관련
DataWindow          idw_preview
LONG        ii_pagecnt            //총페이지수 
LONG        ii_page = 1              //현 페이지    
end variables

event ue_fileopen;//string  sPathName, sFileName
//integer iRtn
//
//iRtn = GetFileOpenName("Select File",sPathName,sFileName,"PSR","PowerSoft Report Files (*.PSR),*.PSR")
//IF iRtn = 1 THEN 
//	dw_list.DataObject = sPathName
//	dw_list.Object.DataWindow.Print.Preview = "yes"
//	//m_main.m_file.m_print.Enabled = TRUE
//	RETURN
//END IF
//
////m_main.m_file.m_print.Enabled = FALSE
end event

event ue_zoom;string tmp

IF ii_factor < 180 THEN
dw_list.scrolltorow(0)
ii_factor = ii_factor + 2
dw_list.Modify ("datawindow.zoom = " + String (ii_factor))
END IF

tmp = dw_list.describe(" evaluate('page()',1) ")
tmp = dw_list.describe(" evaluate('pagecount()',1) ")


end event

event ue_unzoom;
string tmp

IF ii_factor > 20 THEN
dw_list.scrolltorow(0)
ii_factor = ii_factor - 2
dw_list.Modify ("datawindow.zoom = " + String (ii_factor))
END IF

tmp = dw_list.describe(" evaluate('page()',1) ")
tmp = dw_list.describe(" evaluate('pagecount()',1) ")

end event

event ue_print;IF dw_list.RowCount() = 0 THEN
	MessageBox('확인', '출력할 자료가 없습니다!')
ELSE
	gi_page = dw_list.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_list)
END IF


end event

event ue_pagescroll;//long row
//
//row = long(dw_list.describe("datawindow.firstrowonpage"))
//if row <= 0 then return
//
//st_4.text = dw_list.Describe("evaluate('page()', 1)") + " / "
//MessageBOx('',st_4.text)
//st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")

end event

on w_flow_preview.create
this.cb_12=create cb_12
this.cb_11=create cb_11
this.cb_10=create cb_10
this.cb_9=create cb_9
this.pb_4=create pb_4
this.gb_5=create gb_5
this.st_4=create st_4
this.pb_prior=create pb_prior
this.pb_first=create pb_first
this.pb_last=create pb_last
this.pb_next=create pb_next
this.st_3=create st_3
this.ddlb_zoom=create ddlb_zoom
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_range=create ddlb_range
this.cbx_rulers=create cbx_rulers
this.pb_3=create pb_3
this.pb_2=create pb_2
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_list=create dw_list
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.pb_1=create pb_1
this.st_5=create st_5
this.Control[]={this.cb_12,&
this.cb_11,&
this.cb_10,&
this.cb_9,&
this.pb_4,&
this.gb_5,&
this.st_4,&
this.pb_prior,&
this.pb_first,&
this.pb_last,&
this.pb_next,&
this.st_3,&
this.ddlb_zoom,&
this.st_2,&
this.st_1,&
this.ddlb_range,&
this.cbx_rulers,&
this.pb_3,&
this.pb_2,&
this.cb_7,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_list,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.pb_1,&
this.st_5}
end on

on w_flow_preview.destroy
destroy(this.cb_12)
destroy(this.cb_11)
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.pb_4)
destroy(this.gb_5)
destroy(this.st_4)
destroy(this.pb_prior)
destroy(this.pb_first)
destroy(this.pb_last)
destroy(this.pb_next)
destroy(this.st_3)
destroy(this.ddlb_zoom)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_range)
destroy(this.cbx_rulers)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.pb_1)
destroy(this.st_5)
end on

event open;//String	ls_modify, paper_size, paper_copy, paper_orient
//
//idw_dataobject = Message.PowerObjectParm
//
//dw_list.dataobject = idw_dataobject.dataobject
//
//idw_dataobject.sharedata(dw_list)
//dw_list.object.datawindow.print.preview = "yes"	
//dw_list.modify("Datawindow.print.preview.zoom = '"+'85'+"'")


//미리보시 dw를 SaveAs()함수를 사용하여 dw를 .psr화일로 만든후에 .psr화일로 출력.. yoonho,,

idw_preview = Message.PowerObjectParm
string ls_DataObject
long row

ls_DataObject = idw_preview.DataObject + '.psr'
if idw_preview.SaveAs(ls_DataObject, PSReport!, false) > 0 then
	dw_list.DataObject = ls_DataObject
	dw_list.Object.DataWindow.Print.Preview = 'yes'
	dw_list.Object.DataWindow.Print.Preview.rulers = 'yes'
	// 20040127.dana
	dw_list.Object.DataWindow.zoom = idw_preview.Object.DataWindow.zoom
end if


row = long(dw_list.describe("datawindow.firstrowonpage"))
if row <= 0 then return

ii_pagecnt = integer(dw_list.Describe("evaluate('pagecount()', 1)"))

st_4.text = string(ii_page) + " / "
st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")


end event

event resize;dw_list.SetRedraw(False)
dw_list.resize(This.width - 120, This.Height - 440)
gb_4.resize(dw_list.width +20, dw_list.Height + 24)
dw_list.SetRedraw(True)

end event

event closequery;FileDelete(idw_preview.DataObject + '.psr')
end event

type cb_12 from commandbutton within w_flow_preview
integer x = 3643
integer y = 52
integer width = 320
integer height = 120
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string text = "옵션"
end type

event clicked;openwithparm(w_flow_preview_option, parent)

end event

type cb_11 from commandbutton within w_flow_preview
integer x = 3314
integer y = 536
integer width = 320
integer height = 120
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "설정"
end type

type cb_10 from commandbutton within w_flow_preview
integer x = 3319
integer y = 52
integer width = 320
integer height = 120
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string text = "설정"
end type

event clicked;if printsetup() = -1 then
	messagebox("프린트 선택 에러!", "프린트를 선택할 수 없습니다.")
end if

end event

type cb_9 from commandbutton within w_flow_preview
integer x = 2999
integer y = 52
integer width = 320
integer height = 120
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string text = "출력"
end type

event clicked;long ll_row 

if dw_list.rowcount() <= 0 then
	messagebox(title, '출력할 내용이 존재하지 않습니다.', information!)
	return 
end if

Choose Case ddlb_range.text
	case '전체'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "0"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '홀수쪽'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "2"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '짝수쪽'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "1"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '현재'
			ll_row = long(dw_list.describe("datawindow.firstrowonpage"))
		dw_list.object.datawindow.print.page.range = dw_list.describe("evaluate('page()', " + dw_list.object.datawindow.firstrowonpage + ")")
   case else

		dw_list.Object.DataWindow.Print.page.range = trim(ddlb_range.text)
end choose

dw_list.print()
end event

type pb_4 from picturebutton within w_flow_preview
integer x = 3671
integer y = 1228
integer width = 320
integer height = 120
integer taborder = 100
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "옵션"
end type

event clicked;openwithparm(w_preview_option, parent)

end event

type gb_5 from groupbox within w_flow_preview
integer x = 4146
integer y = 36
integer width = 338
integer height = 144
integer taborder = 100
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type st_4 from statictext within w_flow_preview
integer x = 347
integer y = 76
integer width = 370
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_prior from picturebutton within w_flow_preview
integer x = 229
integer y = 64
integer width = 110
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "c:\erpman\image\13_PRIOR.BMP"
alignment htextalign = right!
end type

event clicked;//dw_list.scrollpriorpage()
//parent.triggerevent("ue_pagescroll")
//
long row

row = long(dw_list.describe("datawindow.firstrowonpage"))
if row <= 0 then return

ii_pagecnt = integer(dw_list.Describe("evaluate('pagecount()', 1)"))

if ii_page <= 1 then return;

dw_list.scrollpriorpage()
ii_page = ii_page - 1


st_4.text = string(ii_page) + " / "
st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")

 
end event

type pb_first from picturebutton within w_flow_preview
integer x = 119
integer y = 64
integer width = 110
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "c:\erpman\image\13_FIRST.BMP"
alignment htextalign = right!
end type

event clicked;//dw_list.scrolltorow(1)
//parent.triggerevent("ue_pagescroll")
//
long row

row = long(dw_list.describe("datawindow.firstrowonpage"))
if row <= 0 then return

ii_pagecnt = integer(dw_list.Describe("evaluate('pagecount()', 1)"))

if ii_page <= 1 then return;

dw_list.scrolltorow(1)


st_4.text = '1' + " / "
st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")

 
end event

type pb_last from picturebutton within w_flow_preview
integer x = 832
integer y = 64
integer width = 110
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "c:\erpman\image\13_LAST.BMP"
alignment htextalign = right!
end type

event clicked;//dw_list.scrolltorow(999999)
//parent.triggerevent("ue_pagescroll")

long row

row = long(dw_list.describe("datawindow.firstrowonpage"))
if row <= 0 then return

ii_pagecnt = integer(dw_list.Describe("evaluate('pagecount()', 1)"))

if ii_pagecnt <= ii_page then return;

dw_list.scrolltorow(999999)

st_4.text = string(ii_pagecnt) + " / "
st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")

end event

type pb_next from picturebutton within w_flow_preview
integer x = 718
integer y = 64
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "c:\erpman\image\13_NEXT.BMP"
alignment htextalign = right!
end type

event clicked;//dw_list.scrollnextpage()
//parent.triggerevent("ue_pagescroll")
//

long row

row = long(dw_list.describe("datawindow.firstrowonpage"))
if row <= 0 then return

ii_pagecnt = integer(dw_list.Describe("evaluate('pagecount()', 1)"))

if ii_pagecnt <= ii_page then return;

dw_list.scrollnextpage()
ii_page = ii_page + 1


st_4.text = string(ii_page) + " / "
st_4.text = st_4.text + dw_list.Describe("evaluate('pagecount()', 1)")

end event

type st_3 from statictext within w_flow_preview
integer x = 110
integer y = 56
integer width = 841
integer height = 112
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type ddlb_zoom from dropdownlistbox within w_flow_preview
integer x = 1275
integer y = 80
integer width = 283
integer height = 604
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
string text = "100"
boolean allowedit = true
boolean sorted = false
boolean vscrollbar = true
string item[] = {"200","150","125","100","80","65","30"}
borderstyle borderstyle = stylelowered!
end type

event modified;if isnumber(text) then
   dw_list.object.DataWindow.Print.Preview.Zoom = text
end if
end event

type st_2 from statictext within w_flow_preview
integer x = 1111
integer y = 92
integer width = 219
integer height = 48
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "화면:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_flow_preview
integer x = 1577
integer y = 96
integer width = 306
integer height = 48
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "출력범위:"
boolean focusrectangle = false
end type

type ddlb_range from dropdownlistbox within w_flow_preview
integer x = 1883
integer y = 80
integer width = 658
integer height = 468
integer taborder = 90
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
string text = "전체"
boolean allowedit = true
boolean autohscroll = true
boolean sorted = false
boolean vscrollbar = true
string item[] = {"전체","홀수쪽","짝수쪽","현재",""}
borderstyle borderstyle = stylelowered!
end type

type cbx_rulers from checkbox within w_flow_preview
integer x = 2583
integer y = 88
integer width = 325
integer height = 60
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "눈금자"
boolean checked = true
end type

event clicked;if checked then 
	dw_list.object.DataWindow.Print.Preview.rulers = 'yes'
else
	dw_list.object.DataWindow.Print.Preview.rulers = 'no'
end if


end event

type pb_3 from picturebutton within w_flow_preview
integer x = 3026
integer y = 336
integer width = 320
integer height = 120
integer taborder = 50
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력"
end type

event clicked;if dw_list.rowcount() <= 0 then
	messagebox(title, '출력할 내용이 존재하지 않습니다.', information!)
	return 
end if

Choose Case ddlb_range.text
	case '전  체'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "0"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '홀수면'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "1"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '짝수면'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "2"
		dw_list.Object.DataWindow.Print.page.range = ""
	case '현재면'
		dw_list.Object.DataWindow.Print.page.rangeinclude = "0"
		dw_list.Object.DataWindow.Print.page.range = string(dw_list.getitemnumber(dw_list.getrow(), 'page'), "#,###")
	case else
		dw_list.Object.DataWindow.Print.page.rangeinclude = "0"
		dw_list.Object.DataWindow.Print.page.range = trim(text)
end choose

dw_list.print()
end event

type pb_2 from picturebutton within w_flow_preview
integer x = 3351
integer y = 1228
integer width = 320
integer height = 120
integer taborder = 90
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "설정"
end type

event clicked;if printsetup() = -1 then
	messagebox("프린트 선택 에러!", "프린트를 선택할 수 없습니다.")
end if

end event

type cb_7 from commandbutton within w_flow_preview
integer x = 2235
integer y = 676
integer width = 306
integer height = 140
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&C)"
end type

event clicked;
Close(Parent)
end event

type cb_6 from commandbutton within w_flow_preview
integer x = 1815
integer y = 736
integer width = 306
integer height = 92
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "여백(&M)"
end type

event clicked;string tmp
if ib_ruler = False then
	dw_list.Modify ("datawindow.print.preview.rulers = yes")
	ib_ruler = True
else
  dw_list.Modify ("datawindow.print.preview.rulers = no")
  ib_ruler = False
end if
dw_list.scrolltorow(0)
tmp = dw_list.describe(" evaluate('page()',1) ")
tmp = dw_list.describe(" evaluate('pagecount()',1) ")

end event

type cb_5 from commandbutton within w_flow_preview
integer x = 2670
integer y = 784
integer width = 306
integer height = 92
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "설정(&S)"
end type

event clicked;DataWindow ldw_list
String		ls_orient, ls_size

OpenWithParm(w_preview_option, dw_list)
ldw_list = Message.PowerObjectParm

IF IsNull(ldw_list.DataObject) THEN Return 

ls_orient = ldw_list.object.datawindow.print.orientation
ls_size   = ldw_list.object.datawindow.print.paper.size
dw_list.modify("Datawindow.print.orientation = '"+ls_orient+"'")
dw_list.modify("Datawindow.print.paper.size = '"+ls_size+"'")

end event

type cb_4 from commandbutton within w_flow_preview
integer x = 2336
integer y = 576
integer width = 306
integer height = 92
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인쇄(&T)"
end type

event clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type cb_3 from commandbutton within w_flow_preview
integer x = 1938
integer y = 520
integer width = 306
integer height = 92
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "돋보기(&Z)"
end type

event clicked;IF ib_zoom = False Then
	dw_list.modify("Datawindow.print.preview.zoom = '"+'150'+"'")
	ib_zoom = True
ELSE
	dw_list.modify("Datawindow.print.preview.zoom = '"+'85'+"'")
	ib_zoom = False
END IF
end event

type cb_2 from commandbutton within w_flow_preview
integer x = 1431
integer y = 732
integer width = 306
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이전(&P)"
end type

event clicked;dw_list.scrollpriorpage()
end event

type cb_1 from commandbutton within w_flow_preview
integer x = 1563
integer y = 556
integer width = 306
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "다음(&N)"
end type

event clicked;dw_list.scrollnextpage()
end event

type dw_list from datawindow within w_flow_preview
integer x = 41
integer y = 240
integer width = 4462
integer height = 2476
integer taborder = 20
boolean bringtotop = true
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event retrieveend;object.DataWindow.Print.preview = 'yes'
cbx_rulers.checked = true
object.DataWindow.Print.Preview.rulers = 'yes'
//parent.postevent("ue_pagescroll")

end event

event scrollvertical;parent.postevent("ue_pagescroll")
end event

type gb_1 from groupbox within w_flow_preview
integer x = 2990
integer y = 36
integer width = 983
integer height = 144
integer taborder = 60
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_flow_preview
integer x = 1102
integer y = 36
integer width = 1851
integer height = 144
integer taborder = 60
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_flow_preview
integer x = 82
integer y = 36
integer width = 891
integer height = 144
integer taborder = 110
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
end type

type gb_4 from groupbox within w_flow_preview
integer x = 32
integer y = 228
integer width = 4480
integer height = 2500
integer taborder = 100
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type pb_1 from picturebutton within w_flow_preview
integer x = 4155
integer y = 52
integer width = 320
integer height = 120
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "c:\erpman\image\6424_확인.jpg"
alignment htextalign = left!
end type

event clicked;//parent.hide()
//show(parent.parentwindow())
Close(Parent)
end event

type st_5 from statictext within w_flow_preview
integer x = 37
integer y = 16
integer width = 4475
integer height = 192
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

