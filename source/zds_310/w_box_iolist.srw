$PBExportHeader$w_box_iolist.srw
$PBExportComments$입출내역(수불명세서)
forward
global type w_box_iolist from w_standard_print
end type
type pb_1 from u_pb_cal within w_box_iolist
end type
type pb_2 from u_pb_cal within w_box_iolist
end type
type rb_1 from radiobutton within w_box_iolist
end type
type rb_2 from radiobutton within w_box_iolist
end type
type dw_100 from datawindow within w_box_iolist
end type
type rr_1 from roundrectangle within w_box_iolist
end type
type rr_2 from roundrectangle within w_box_iolist
end type
end forward

global type w_box_iolist from w_standard_print
string title = "BOX수불명세서"
pb_1 pb_1
pb_2 pb_2
rb_1 rb_1
rb_2 rb_2
dw_100 dw_100
rr_1 rr_1
rr_2 rr_2
end type
global w_box_iolist w_box_iolist

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long   row

row = dw_ip.GetRow()
If row < 1 Then Return 0

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' Or IsNull(ls_st) Then
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	MessageBox('기간 확인', '기간을 입력하십시오.')
	Return 0
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' Or IsNull(ls_ed) Then
	dw_ip.SetColumn('d_ed')
	dw_ip.SetFocus()
	MessageBox('기간 확인', '기간을 입력하십시오.')
	Return 0
End If

String ls_depot

ls_depot = dw_ip.GetItemString(row, 'depot')
If Trim(ls_depot) = '' Or IsNull(ls_depot) Then ls_depot = '%'

String ls_box

ls_box = dw_ip.GetItemString(row, 'box')
If Trim(ls_box) = '' OR IsNull(ls_box) Then ls_box = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_depot, ls_st, ls_ed + '31', ls_box, ls_cvcod)
dw_list.SetRedraw(True)

Return 1
end function

on w_box_iolist.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_100=create dw_100
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_100
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_box_iolist.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_100)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_box_iolist
boolean visible = true
integer x = 4210
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_box_iolist
integer x = 3822
integer y = 196
end type

type p_preview from w_standard_print`p_preview within w_box_iolist
boolean visible = false
integer x = 4187
integer y = 180
end type

type p_exit from w_standard_print`p_exit within w_box_iolist
integer x = 4384
end type

type p_print from w_standard_print`p_print within w_box_iolist
boolean visible = false
integer x = 4361
integer y = 180
end type

type p_retrieve from w_standard_print`p_retrieve within w_box_iolist
integer x = 4037
end type







type st_10 from w_standard_print`st_10 within w_box_iolist
end type



type dw_print from w_standard_print`dw_print within w_box_iolist
integer x = 3872
string dataobject = "d_box_iolist_d002"
end type

type dw_ip from w_standard_print`dw_ip within w_box_iolist
integer x = 37
integer y = 32
integer width = 3214
integer height = 176
string dataobject = "d_box_iolist_d001"
end type

event dw_ip::itemchanged;call super::itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

This.AcceptText()

// 거래처
IF this.GetColumnName() = 'cvcod'		THEN

	sVendor = this.gettext()
	If Trim(sVendor) = '' OR IsNull(sVendor) Then
		this.setitem(1, 'cvnas', sNull)
		Return
	End If
	
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, "cvnas", sNull)
		return 1
	end if

	this.setitem(1, "cvnas", sVendorName)
	
End If
end event

event dw_ip::rbuttondown;call super::rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// 전표번호
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cvcod",		gs_code)
	SetItem(1, "cvnas",gs_codename)

END IF


end event

type dw_list from w_standard_print`dw_list within w_box_iolist
integer x = 50
integer y = 236
integer width = 4512
integer height = 2004
string dataobject = "d_box_iolist_d002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_box_iolist
integer x = 1189
integer y = 84
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', LEFT(gs_code, 6))

end event

type pb_2 from u_pb_cal within w_box_iolist
integer x = 1568
integer y = 84
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', LEFT(gs_code, 6))

end event

type rb_1 from radiobutton within w_box_iolist
integer x = 3323
integer y = 52
integer width = 206
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "상세"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_box_iolist_d002'
dw_print.DataObject = 'd_box_iolist_d002'

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_box_iolist
integer x = 3323
integer y = 128
integer width = 206
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "집계"
end type

event clicked;dw_list.DataObject = 'd_box_iolist_d003'
dw_print.DataObject = 'd_box_iolist_d003'

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type dw_100 from datawindow within w_box_iolist
boolean visible = false
integer x = 3369
integer y = 1508
integer width = 1175
integer height = 716
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "집계현황 DataWindow"
string dataobject = "d_box_iolist_d003"
boolean border = false
end type

type rr_1 from roundrectangle within w_box_iolist
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 4539
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_box_iolist
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3259
integer y = 32
integer width = 325
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

