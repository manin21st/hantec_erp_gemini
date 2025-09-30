$PBExportHeader$w_sal_07024.srw
$PBExportComments$연동판매계획 - Level (1-3) - 제품별
forward
global type w_sal_07024 from w_standard_print
end type
type st_2 from statictext within w_sal_07024
end type
type shl_2 from statichyperlink within w_sal_07024
end type
type shl_4 from statichyperlink within w_sal_07024
end type
type shl_1 from statichyperlink within w_sal_07024
end type
type st_1 from statictext within w_sal_07024
end type
type rr_1 from roundrectangle within w_sal_07024
end type
end forward

global type w_sal_07024 from w_standard_print
string title = "연동판매계획 - 제품별"
string menuname = ""
st_2 st_2
shl_2 shl_2
shl_4 shl_4
shl_1 shl_1
st_1 st_1
rr_1 rr_1
end type
global w_sal_07024 w_sal_07024

type variables
String	is_month[]

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_steamcd, ls_sarea, ls_cvcod, ls_month, ls_last_date, ls_ittyp
Int		li_int

ls_year = dw_ip.GetItemString(1, 'year')
ls_steamcd = dw_ip.GetItemString(1, 'large')
ls_sarea = dw_ip.GetItemString(1, 'middle')
ls_month = dw_ip.GetItemString(1, 'month')
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year, ls_steamcd, ls_sarea, ls_month, ls_ittyp) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

li_int	= Integer(ls_month)
ls_month = is_month[li_int]

shl_4.Text = "제품별(" + ls_month + "월)"

Return 1
end function

on w_sal_07024.create
int iCurrent
call super::create
this.st_2=create st_2
this.shl_2=create shl_2
this.shl_4=create shl_4
this.shl_1=create shl_1
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.shl_4
this.Control[iCurrent+4]=this.shl_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_07024.destroy
call super::destroy
destroy(this.st_2)
destroy(this.shl_2)
destroy(this.shl_4)
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.TriggerEvent(itemchanged!)
dw_ip.SetItem(1, 'large', gs_code)
dw_ip.SetItem(1, 'large_nm', gs_codename)
dw_ip.SetItem(1, 'middle', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'middle_nm', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'month', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'ittyp', f_get_token(gs_codename2, '~t'))

//ii_month_seq = Integer(f_get_token(gs_codename2, '~t'))
//
//String ls_str
//
//ls_str = String( Integer(Right(gs_gubun,2)) + ii_month_seq )
//
//dw_ip.SetItem(1, 'month', ls_str)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_sal_07024
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_sal_07024
end type

type p_print from w_standard_print`p_print within w_sal_07024
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_07024
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_sal_07024
end type



type dw_print from w_standard_print`dw_print within w_sal_07024
integer x = 3255
string dataobject = "d_sal_07024"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_07024
integer x = 14
integer y = 96
integer width = 2752
integer height = 152
string dataobject = "d_sal_07024_a"
end type

event dw_ip::itemchanged;call super::itemchanged;Long		nRow
Int		li_int, li_s_m

nRow = GetRow()
If nRow <=0 Then Return

Choose Case GetColumnName()
		
	Case 'year'

		If IsNull(data) Then
			data = This.Object.year[1]
		End If
		is_month[1] = Right(data, 2)
		li_s_m = Integer(is_month[1])

		For li_int = 1 To 4
			If li_s_m + li_int > 12 Then
				is_month[li_int+1] = String( li_s_m + li_int - 12, '00')
			Else
				is_month[li_int+1] = String( li_s_m + li_int, '00')
			End If
		Next

		This.Object.month.Values = &
		is_month[1] + "	01/" + &
		is_month[2] + "	02/" + &
		is_month[3] + "	03/" + &
		is_month[4] + "	04/" + &
		is_month[5] + "	05/"


//		If data < Right(ls_Str,2)  Then
//			MessageBox("입력오류", "기준년월보다 적은 달을 선택하실 수 없습니다.")
//			Return 1
//		End If
		
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_07024
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_sal_07024"
boolean border = false
end type

type st_2 from statictext within w_sal_07024
integer x = 850
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

type shl_2 from statichyperlink within w_sal_07024
integer x = 517
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
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "중분류별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_07022' then
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
	OpenSheet(w_sal_07022, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_4 from statichyperlink within w_sal_07024
integer x = 1010
integer y = 36
integer width = 581
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
string text = "제품별"
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_sal_07024
integer x = 69
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
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "계획년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_07020' then
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
	OpenSheet(w_sal_07020, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_sal_07024
integer x = 402
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

type rr_1 from roundrectangle within w_sal_07024
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

