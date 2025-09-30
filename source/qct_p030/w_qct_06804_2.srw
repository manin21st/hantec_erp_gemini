$PBExportHeader$w_qct_06804_2.srw
$PBExportComments$년간품질현황 - (공정검사) 대분류별
forward
global type w_qct_06804_2 from w_standard_print
end type
type shl_1 from statichyperlink within w_qct_06804_2
end type
type st_1 from statictext within w_qct_06804_2
end type
type shl_2 from statichyperlink within w_qct_06804_2
end type
type rr_1 from roundrectangle within w_qct_06804_2
end type
end forward

global type w_qct_06804_2 from w_standard_print
string title = "년간품질현황 - (공정검사) 대분류별"
string menuname = ""
shl_1 shl_1
st_1 st_1
shl_2 shl_2
rr_1 rr_1
end type
global w_qct_06804_2 w_qct_06804_2

type variables
String	is_Tag = '1'
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year

ls_year = dw_ip.GetItemString(1, 'year')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_qct_06804_2.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.shl_2=create shl_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.shl_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_06804_2.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.shl_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'year', gs_gubun)


SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_qct_06804_2
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_qct_06804_2
end type

type p_print from w_standard_print`p_print within w_qct_06804_2
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06804_2
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_qct_06804_2
end type



type dw_print from w_standard_print`dw_print within w_qct_06804_2
string dataobject = "d_qct_06802"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06804_2
integer x = 18
integer y = 96
integer width = 658
integer height = 152
string dataobject = "d_qct_06801_a"
end type

type dw_list from w_standard_print`dw_list within w_qct_06804_2
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_qct_06804_2"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

/* 품종분류별 */
IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
	ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', '1')
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1

/*
String ls_Object, ls_month
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 3)  = 'cnt' Then
	ls_month = mid(ls_Object, 4, 2)
ElseIf mid(ls_Object, 1, 4)  = 'fcnt' Then
	ls_month = mid(ls_Object, 5, 2)
Else
	This.SetItem(This.GetRow(), 'opt', '0')
	Return
End If

f_get_token(ls_Object, '~t')
ll_Row = Long(f_get_token(ls_Object, '~t'))

If ll_Row < 1 or isnull(ll_Row) Then Return 
This.SetRow(ll_row)
This.SetItem(ll_row, 'opt', ls_month)

Return
*/
end event

event dw_list::clicked;String	ls_Object
Long		ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

/* 품종분류별 */
IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
	ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'itcls')
	gs_codename = this.GetItemString(row, 'titnm')
	gs_codename2 = this.GetItemString(row, 'ittyp')
	
	// 윈도우가 이미 열려있으면 닫는다.
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_qct_06805_2' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	If lb_isopen Then
		Close(lw_window)
	End If
	
	OpenSheet(w_qct_06805_2, w_mdi_frame, 0, Layered!)
		
End If
end event

type shl_1 from statichyperlink within w_qct_06804_2
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

type st_1 from statictext within w_qct_06804_2
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

type shl_2 from statichyperlink within w_qct_06804_2
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
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "(공정검사)대분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_06804_2
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

