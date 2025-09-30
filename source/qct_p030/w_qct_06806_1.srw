$PBExportHeader$w_qct_06806_1.srw
$PBExportComments$년간품질현황 - (출고검사) 품목별
forward
global type w_qct_06806_1 from w_standard_print
end type
type shl_1 from statichyperlink within w_qct_06806_1
end type
type st_1 from statictext within w_qct_06806_1
end type
type shl_2 from statichyperlink within w_qct_06806_1
end type
type shl_3 from statichyperlink within w_qct_06806_1
end type
type st_2 from statictext within w_qct_06806_1
end type
type shl_4 from statichyperlink within w_qct_06806_1
end type
type st_3 from statictext within w_qct_06806_1
end type
type rr_1 from roundrectangle within w_qct_06806_1
end type
end forward

global type w_qct_06806_1 from w_standard_print
string title = "년간품질현황 - (출고검사) 품목별"
string menuname = ""
shl_1 shl_1
st_1 st_1
shl_2 shl_2
shl_3 shl_3
st_2 st_2
shl_4 shl_4
st_3 st_3
rr_1 rr_1
end type
global w_qct_06806_1 w_qct_06806_1

type variables
String	is_Tag = '1'
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_sarea, ls_ittyp

ls_year = dw_ip.GetItemString(1, 'year')
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')
ls_sarea = dw_ip.GetItemString(1, 'large')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year, ls_sarea, ls_ittyp) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_qct_06806_1.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.shl_2=create shl_2
this.shl_3=create shl_3
this.st_2=create st_2
this.shl_4=create shl_4
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.shl_2
this.Control[iCurrent+4]=this.shl_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.shl_4
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.rr_1
end on

on w_qct_06806_1.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.shl_2)
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.shl_4)
destroy(this.st_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year'    ,gs_gubun    )
dw_ip.SetItem(1, 'large'   ,gs_code     )
dw_ip.SetItem(1, 'large_nm',gs_codename )
dw_ip.SetItem(1, 'ittyp'   ,gs_codename2)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_qct_06806_1
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_qct_06806_1
end type

type p_print from w_standard_print`p_print within w_qct_06806_1
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06806_1
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_qct_06806_1
end type



type dw_print from w_standard_print`dw_print within w_qct_06806_1
string dataobject = "d_qct_06806_1"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06806_1
integer x = 18
integer y = 96
integer width = 2249
integer height = 152
string dataobject = "d_qct_06805_a"
end type

type dw_list from w_standard_print`dw_list within w_qct_06806_1
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_qct_06806_1"
boolean border = false
end type

type shl_1 from statichyperlink within w_qct_06806_1
integer x = 41
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
string text = "년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_qct_06801' then
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
	OpenSheet(w_qct_06801, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_qct_06806_1
integer x = 297
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
long textcolor = 16711680
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_qct_06806_1
integer x = 411
integer y = 36
integer width = 553
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
string text = "(출고검사)대분류별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_qct_06804_1' then
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
	OpenSheet(w_qct_06804_1, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_3 from statichyperlink within w_qct_06806_1
integer x = 1097
integer y = 36
integer width = 274
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
	if ClassName(lw_window) = 'w_qct_06805_1' then
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
	OpenSheet(w_qct_06805_1, w_mdi_frame, 0, Layered!)	
end if
end event

type st_2 from statictext within w_qct_06806_1
integer x = 974
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
long textcolor = 16711680
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_4 from statichyperlink within w_qct_06806_1
integer x = 1490
integer y = 36
integer width = 215
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

type st_3 from statictext within w_qct_06806_1
integer x = 1376
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
long textcolor = 16711680
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_06806_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

