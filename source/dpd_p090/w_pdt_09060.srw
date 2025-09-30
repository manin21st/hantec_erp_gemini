$PBExportHeader$w_pdt_09060.srw
$PBExportComments$월 생산 계획 및 실적[조]
forward
global type w_pdt_09060 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09060
end type
type shl_2 from statichyperlink within w_pdt_09060
end type
type st_1 from statictext within w_pdt_09060
end type
type shl_3 from statichyperlink within w_pdt_09060
end type
type st_2 from statictext within w_pdt_09060
end type
type rr_1 from roundrectangle within w_pdt_09060
end type
end forward

global type w_pdt_09060 from w_standard_print
string title = "품목별 생산실적"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
shl_2 shl_2
st_1 st_1
shl_3 shl_3
st_2 st_2
rr_1 rr_1
end type
global w_pdt_09060 w_pdt_09060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_pdtgu, ls_jocod

ls_year  = dw_ip.GetItemString(1, 'year')
ls_pdtgu = dw_ip.GetItemString(1, 'pdtgu')


IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231', ls_pdtgu, gs_codename) <= 0 THEN
	Return -1
END IF

Return 1
end function

on w_pdt_09060.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.shl_3=create shl_3
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.shl_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_pdt_09060.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;String sData1, sData2

dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'pdtgu', gs_code)
dw_ip.SetItem(1, 'titnm', gs_codename2)


wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_pdt_09060
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_pdt_09060
end type

type p_print from w_standard_print`p_print within w_pdt_09060
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09060
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_pdt_09060
end type



type dw_print from w_standard_print`dw_print within w_pdt_09060
integer x = 3255
string dataobject = "d_pdt_09020_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09060
integer x = 14
integer y = 96
integer width = 2656
integer height = 152
string dataobject = "d_pdt_09050_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09060
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 1996
string dataobject = "d_pdt_09060_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 7)  = 'silqty_' Then
	ll_Row = long(mid(ls_Object, 10, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', mid(ls_Object, 8, 2))
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event dw_list::clicked;call super::clicked;String ls_Object	
Long	 ll_Row
Boolean	lb_isopen
Window	lw_window

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 7)  = 'silqty_' Then
	ll_Row = long(mid(ls_Object, 10, 3))
	gs_code = This.GetItemString(row, 'itnbr')
	gs_codename = This.GetItemString(row, 'itdsc')
	gs_gubun  = dw_ip.GetItemString(1, 'year') + mid(ls_Object, 8, 2)
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09070' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09070)		

	OpenSheet(w_pdt_09070, w_mdi_frame, 0, Layered!)
	
	
End If



end event

type shl_1 from statichyperlink within w_pdt_09060
integer x = 69
integer y = 36
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "대분류별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09045' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_pdt_09045, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_2 from statichyperlink within w_pdt_09060
integer x = 402
integer y = 36
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "중분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09050' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_pdt_09050, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_pdt_09060
integer x = 325
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_3 from statichyperlink within w_pdt_09060
integer x = 777
integer y = 36
integer width = 270
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "품목별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_09060
integer x = 690
integer y = 32
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_09060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

