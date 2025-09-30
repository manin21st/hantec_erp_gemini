$PBExportHeader$w_pdt_09030.srw
$PBExportComments$생산효율 종합분석-권
forward
global type w_pdt_09030 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09030
end type
type shl_2 from statichyperlink within w_pdt_09030
end type
type st_1 from statictext within w_pdt_09030
end type
type shl_3 from statichyperlink within w_pdt_09030
end type
type st_2 from statictext within w_pdt_09030
end type
type shl_4 from statichyperlink within w_pdt_09030
end type
type st_3 from statictext within w_pdt_09030
end type
type rr_1 from roundrectangle within w_pdt_09030
end type
end forward

global type w_pdt_09030 from w_standard_print
string title = "비가동내역"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
shl_2 shl_2
st_1 st_1
shl_3 shl_3
st_2 st_2
shl_4 shl_4
st_3 st_3
rr_1 rr_1
end type
global w_pdt_09030 w_pdt_09030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_pdtgu

ls_year = dw_ip.GetItemString(1, 'year')
ls_pdtgu = dw_ip.GetItemString(1, 'wkctr')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(gs_sabu, ls_year+'0101', ls_year+'1231', ls_pdtgu) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_pdt_09030.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.shl_3=create shl_3
this.st_2=create st_2
this.shl_4=create shl_4
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.shl_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.shl_4
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.rr_1
end on

on w_pdt_09030.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.shl_4)
destroy(this.st_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'pdtgu', Left(gs_codename2,1))
dw_ip.SetItem(1, 'jonam', Mid(gs_codename2,2))
dw_ip.SetItem(1, 'wkctr', gs_code)
dw_ip.SetItem(1, 'wcdsc', gs_codename)

SetNull(gs_gubun)
SetNull(gs_code)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_pdt_09030
boolean visible = false
integer x = 3675
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_pdt_09030
end type

type p_print from w_standard_print`p_print within w_pdt_09030
boolean visible = false
integer x = 3849
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09030
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_pdt_09030
end type



type dw_print from w_standard_print`dw_print within w_pdt_09030
integer x = 4087
integer y = 56
string dataobject = "d_pdt_09020_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09030
integer x = 14
integer y = 96
integer width = 3561
integer height = 152
string dataobject = "d_pdt_09030_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09030
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_pdt_09030_1"
boolean border = false
end type

type shl_1 from statichyperlink within w_pdt_09030
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
string text = "생산팀별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09010' then
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
	OpenSheet(w_pdt_09010, w_mdi_frame, 0, Layered!)	
end if

end event

type shl_2 from statichyperlink within w_pdt_09030
integer x = 462
integer y = 36
integer width = 261
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
string text = "작업조별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09020' then
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
	OpenSheet(w_pdt_09020, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_pdt_09030
integer x = 334
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

type shl_3 from statichyperlink within w_pdt_09030
integer x = 1266
integer y = 36
integer width = 370
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
string text = "비가동내역별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_09030
integer x = 736
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

type shl_4 from statichyperlink within w_pdt_09030
integer x = 864
integer y = 36
integer width = 261
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
string text = "작업장별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09025' then
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
	OpenSheet(w_pdt_09025, w_mdi_frame, 0, Layered!)	
end if
end event

type st_3 from statictext within w_pdt_09030
integer x = 1138
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

type rr_1 from roundrectangle within w_pdt_09030
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

