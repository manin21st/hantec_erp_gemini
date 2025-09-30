$PBExportHeader$w_qct_06801.srw
$PBExportComments$년간품질현황 - Level (1)
forward
global type w_qct_06801 from w_standard_print
end type
type shl_1 from statichyperlink within w_qct_06801
end type
type rr_1 from roundrectangle within w_qct_06801
end type
end forward

global type w_qct_06801 from w_standard_print
string title = "년간품질현황"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
rr_1 rr_1
end type
global w_qct_06801 w_qct_06801

type variables

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

// header text set
Int	li_int, li_month

li_month = Integer(Right( ls_year, 2 ))

// ▷ 1
dw_list.Object.t_m_01.Text = String( li_month ) + '월'

// ▷ 2
If li_month + 1 > 12 Then
	dw_list.Object.t_m_02.Text = String( li_month + 1 - 12 ) + '월'
Else
	dw_list.Object.t_m_02.Text = String( li_month + 1 ) + '월'
End If

// ▷ 3
If li_month + 2 > 12 Then
	dw_list.Object.t_m_03.Text = String( li_month + 2 - 12 ) + '월'
Else
	dw_list.Object.t_m_03.Text = String( li_month + 2 ) + '월'
End If

// ▷ 4
If li_month + 3 > 12 Then
	dw_list.Object.t_m_04.Text = String( li_month + 3 - 12 ) + '월'
Else
	dw_list.Object.t_m_04.Text = String( li_month + 3 ) + '월'
End If
 
// ▷ 5
If li_month + 4 > 12 Then
	dw_list.Object.t_m_05.Text = String( li_month + 4 - 12 ) + '월'
Else
	dw_list.Object.t_m_05.Text = String( li_month + 4 ) + '월'
End If
 
// ▷ 6
If li_month + 5 > 12 Then
	dw_list.Object.t_m_06.Text = String( li_month + 5 - 12 ) + '월'
Else
	dw_list.Object.t_m_06.Text = String( li_month + 5 ) + '월'
End If
 
// ▷ 7
If li_month + 6 > 12 Then
	dw_list.Object.t_m_07.Text = String( li_month + 6 - 12 ) + '월'
Else
	dw_list.Object.t_m_07.Text = String( li_month + 6 ) + '월'
End If
 
// ▷ 8
If li_month + 7 > 12 Then
	dw_list.Object.t_m_08.Text = String( li_month + 7 - 12 ) + '월'
Else
	dw_list.Object.t_m_08.Text = String( li_month + 7 ) + '월'
End If
 
// ▷ 9
If li_month + 8 > 12 Then
	dw_list.Object.t_m_09.Text = String( li_month + 8 - 12 ) + '월'
Else
	dw_list.Object.t_m_09.Text = String( li_month + 8 ) + '월'
End If
 
// ▷ 10
If li_month + 9 > 12 Then
	dw_list.Object.t_m_10.Text = String( li_month + 9 - 12 ) + '월'
Else
	dw_list.Object.t_m_10.Text = String( li_month + 9 ) + '월'
End If
 
// ▷ 11
If li_month + 10 > 12 Then
	dw_list.Object.t_m_11.Text = String( li_month + 10 - 12 ) + '월'
Else
	dw_list.Object.t_m_11.Text = String( li_month + 10 ) + '월'
End If
 
// ▷ 12
If li_month + 11 > 12 Then
	dw_list.Object.t_m_12.Text = String( li_month + 11 - 12 ) + '월'
Else
	dw_list.Object.t_m_12.Text = String( li_month + 11 ) + '월'
End If
 

 
Return 1
end function

on w_qct_06801.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_qct_06801.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'year', Left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_qct_06801
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_qct_06801
end type

type p_print from w_standard_print`p_print within w_qct_06801
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06801
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_qct_06801
end type



type dw_print from w_standard_print`dw_print within w_qct_06801
string dataobject = "d_qct_06801"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06801
integer x = 18
integer y = 96
integer width = 658
integer height = 152
string dataobject = "d_sal_07020_a"
end type

type dw_list from w_standard_print`dw_list within w_qct_06801
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_qct_06801"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 5)  = 'titnm' Then
	ll_Row = long(mid(ls_Object, 6, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', '1')
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event dw_list::clicked;call super::clicked;String	ls_Object, ls_str
Long		ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())


IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
	ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	
	ls_str = This.GetItemString(ll_Row, 'sort')
	Choose Case ls_str
		Case '1' //수입검사
			lb_isopen = FALSE
			lw_window = parent.GetFirstSheet()
			DO WHILE IsValid(lw_window)
				if ClassName(lw_window) = 'w_qct_06802' then
					lb_isopen = TRUE
					Exit
				else		
					lw_window = parent.GetNextSheet(lw_window)
				end if
			LOOP
			
			If lb_isopen Then
				Close(lw_window)
			End If
			
			OpenSheet(w_qct_06802, w_mdi_frame, 0, Layered!)
			
		Case '2' //출하검사
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
			
			If lb_isopen Then
				Close(lw_window)
			End If
			
			OpenSheet(w_qct_06804_1, w_mdi_frame, 0, Layered!)
			
		Case '3' //공정검사
			lb_isopen = FALSE
			lw_window = parent.GetFirstSheet()
			DO WHILE IsValid(lw_window)
				if ClassName(lw_window) = 'w_qct_06804_2' then
					lb_isopen = TRUE
					Exit
				else		
					lw_window = parent.GetNextSheet(lw_window)
				end if
			LOOP
			
			If lb_isopen Then
				Close(lw_window)
			End If
			
			OpenSheet(w_qct_06804_2, w_mdi_frame, 0, Layered!)
			
			
	
	End Choose
	
END IF
end event

type shl_1 from statichyperlink within w_qct_06801
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
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "년월별"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_06801
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

