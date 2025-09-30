$PBExportHeader$w_sal_07012.srw
$PBExportComments$년간판매계획및실적 - Level (1-3) - 제품별
forward
global type w_sal_07012 from w_standard_print
end type
type st_2 from statictext within w_sal_07012
end type
type shl_1 from statichyperlink within w_sal_07012
end type
type shl_2 from statichyperlink within w_sal_07012
end type
type st_1 from statictext within w_sal_07012
end type
type shl_4 from statichyperlink within w_sal_07012
end type
type rr_1 from roundrectangle within w_sal_07012
end type
end forward

global type w_sal_07012 from w_standard_print
string title = "년간판매계획및실적-제품별"
string menuname = ""
st_2 st_2
shl_1 shl_1
shl_2 shl_2
st_1 st_1
shl_4 shl_4
rr_1 rr_1
end type
global w_sal_07012 w_sal_07012

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_steamcd, ls_sarea, ls_cvcod, ls_month, ls_last_date, ls_ittyp

ls_year = dw_ip.GetItemString(1, 'year')
ls_steamcd = dw_ip.GetItemString(1, 'large')
ls_sarea = dw_ip.GetItemString(1, 'middle')
ls_month = dw_ip.GetItemString(1, 'month')
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year + ls_month, ls_steamcd, ls_sarea, ls_ittyp) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

shl_4.Text = "제품별(" + ls_month + "월)"

Return 1
end function

on w_sal_07012.create
int iCurrent
call super::create
this.st_2=create st_2
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.shl_4=create shl_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.shl_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.shl_4
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_07012.destroy
call super::destroy
destroy(this.st_2)
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.shl_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'large', gs_code)
dw_ip.SetItem(1, 'large_nm', gs_codename)
dw_ip.SetItem(1, 'middle', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'middle_nm', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'month', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'ittyp', f_get_token(gs_codename2, '~t'))

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_sal_07012
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_sal_07012
end type

type p_print from w_standard_print`p_print within w_sal_07012
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_07012
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_sal_07012
end type



type dw_print from w_standard_print`dw_print within w_sal_07012
integer x = 3255
string dataobject = "d_sal_07012"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_07012
integer x = 14
integer y = 96
integer width = 2949
integer height = 152
string dataobject = "d_sal_06903_a"
end type

type dw_list from w_standard_print`dw_list within w_sal_07012
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_sal_07012"
boolean border = false
end type

type st_2 from statictext within w_sal_07012
integer x = 754
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

type shl_1 from statichyperlink within w_sal_07012
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
	if ClassName(lw_window) = 'w_sal_07000' then
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
	OpenSheet(w_sal_07000, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_2 from statichyperlink within w_sal_07012
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
	if ClassName(lw_window) = 'w_sal_07011' then
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
	OpenSheet(w_sal_07011, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_sal_07012
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

type shl_4 from statichyperlink within w_sal_07012
integer x = 914
integer y = 36
integer width = 526
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

type rr_1 from roundrectangle within w_sal_07012
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

