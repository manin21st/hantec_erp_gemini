$PBExportHeader$w_sal_06901.srw
$PBExportComments$년간수주실적 - Level (1-2) - 중분류별
forward
global type w_sal_06901 from w_standard_print
end type
type shl_1 from statichyperlink within w_sal_06901
end type
type shl_2 from statichyperlink within w_sal_06901
end type
type st_1 from statictext within w_sal_06901
end type
type rr_1 from roundrectangle within w_sal_06901
end type
end forward

global type w_sal_06901 from w_standard_print
string title = "년간 수주실적 - 중분류별"
string menuname = ""
shl_1 shl_1
shl_2 shl_2
st_1 st_1
rr_1 rr_1
end type
global w_sal_06901 w_sal_06901

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_sarea, ls_ittyp

ls_year = dw_ip.GetItemString(1, 'year')
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')
ls_sarea = dw_ip.GetItemString(1, 'large')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231', ls_sarea, ls_ittyp) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_sal_06901.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_06901.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'ittyp', gs_codename2)
dw_ip.SetItem(1, 'large', gs_code)
dw_ip.SetItem(1, 'large_nm', gs_codename)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_sal_06901
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_sal_06901
end type

type p_print from w_standard_print`p_print within w_sal_06901
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06901
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_sal_06901
end type



type dw_print from w_standard_print`dw_print within w_sal_06901
integer x = 3255
string dataobject = "d_sal_06901"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06901
integer x = 14
integer y = 96
integer width = 2327
integer height = 152
string dataobject = "d_sal_06901_a"
end type

type dw_list from w_standard_print`dw_list within w_sal_06901
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_sal_06901"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 10)  = 'order_amt_' Then
	ll_Row = long(mid(ls_Object, 13, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', mid(ls_Object, 11, 2))
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event dw_list::clicked;call super::clicked;String  ls_Object
Long	  ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 10)  = 'order_amt_' THEN 
	ll_Row = long(mid(ls_Object, 13, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 
	
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = dw_ip.GetItemString(row, 'large')
	gs_codename = trim(dw_ip.GetItemString(row, 'large_nm'))
	gs_codename2 = this.GetItemString(row, 'itcls') + '~t' +&
						trim(this.GetItemString(row, 'titnm')) + '~t' +&
						+ mid(ls_Object, 11, 2) + '~t' + this.GetItemString(row, 'ittyp')
	
	// 윈도우가 이미 열려있으면 닫는다.
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_sal_06903' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	If lb_isopen Then
		Close(lw_window)
	End If
	
	OpenSheet(w_sal_06903, w_mdi_frame, 0, Layered!)
	
END IF

end event

type shl_1 from statichyperlink within w_sal_06901
integer x = 69
integer y = 36
integer width = 187
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
string text = "년도별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_06880' then
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
	OpenSheet(w_sal_06880, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_2 from statichyperlink within w_sal_06901
integer x = 421
integer y = 36
integer width = 311
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
string text = "중분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sal_06901
integer x = 283
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

type rr_1 from roundrectangle within w_sal_06901
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

