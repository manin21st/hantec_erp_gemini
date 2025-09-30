$PBExportHeader$w_sal_07000.srw
$PBExportComments$년간판매계획및실적 - Level (1)
forward
global type w_sal_07000 from w_standard_print
end type
type shl_1 from statichyperlink within w_sal_07000
end type
type st_team from statictext within w_sal_07000
end type
type dw_list_g from datawindow within w_sal_07000
end type
type st_titnm from statictext within w_sal_07000
end type
type rr_team from roundrectangle within w_sal_07000
end type
type rr_1 from roundrectangle within w_sal_07000
end type
type rr_titnm from roundrectangle within w_sal_07000
end type
type rr_2 from roundrectangle within w_sal_07000
end type
end forward

global type w_sal_07000 from w_standard_print
string title = "년간판매계획및실적현황"
string menuname = ""
shl_1 shl_1
st_team st_team
dw_list_g dw_list_g
st_titnm st_titnm
rr_team rr_team
rr_1 rr_1
rr_titnm rr_titnm
rr_2 rr_2
end type
global w_sal_07000 w_sal_07000

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year

ls_year = dw_ip.GetItemString(1, 'year')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231') <= 0 Or dw_list_g.Retrieve(ls_year+'0101', ls_year+'1231') <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_sal_07000.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_team=create st_team
this.dw_list_g=create dw_list_g
this.st_titnm=create st_titnm
this.rr_team=create rr_team
this.rr_1=create rr_1
this.rr_titnm=create rr_titnm
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_team
this.Control[iCurrent+3]=this.dw_list_g
this.Control[iCurrent+4]=this.st_titnm
this.Control[iCurrent+5]=this.rr_team
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_titnm
this.Control[iCurrent+8]=this.rr_2
end on

on w_sal_07000.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_team)
destroy(this.dw_list_g)
destroy(this.st_titnm)
destroy(this.rr_team)
destroy(this.rr_1)
destroy(this.rr_titnm)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,'year', Left(f_today(),4))

dw_list_g.settransobject(sqlca)

end event

type p_preview from w_standard_print`p_preview within w_sal_07000
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_sal_07000
end type

type p_print from w_standard_print`p_print within w_sal_07000
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_07000
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_sal_07000
end type



type dw_print from w_standard_print`dw_print within w_sal_07000
string dataobject = "d_sal_07000"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_07000
integer x = 18
integer y = 96
integer width = 631
integer height = 152
string dataobject = "d_sal_07030_a"
end type

event dw_ip::itemchanged;//Long    nRow
//
//nRow = GetRow()
//If nRow <=0 Then Return
//
//Choose Case GetColumnName() 
//	Case 'tag'
//		If data = '1' Then
//			If dw_list.DataObject <> 'd_sal_07000' Then
//				dw_list.DataObject = 'd_sal_07000'
//			End If
//		Else
//			If dw_list.DataObject <> 'd_sal_07010' Then
//				dw_list.DataObject = 'd_sal_07010'
//			End If
//		End If
//		is_Tag = data
//		dw_list.SetTransObject(SQLCA)
//END Choose
//
end event

type dw_list from w_standard_print`dw_list within w_sal_07000
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 336
integer width = 4558
integer height = 920
string dataobject = "d_sal_07000"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

/* 영업팀별 */
If mid(ls_Object, 1, 7)  = 'steamcd' Then
	ll_Row = long(mid(ls_Object, 8, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', '1')
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event dw_list::clicked;String	ls_Object
Long		ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

/* 영업팀별 */
IF mid(ls_Object, 1, 7)  = 'steamcd' THEN 
	ll_Row = long(mid(ls_Object, 8, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'steamcd')
	
	// 윈도우가 이미 열려있으면 닫는다.
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_sal_07002' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	If lb_isopen Then
		Close(lw_window)
	End If
	
	OpenSheet(w_sal_07002, w_mdi_frame, 0, Layered!)
	
END IF

end event

type shl_1 from statichyperlink within w_sal_07000
integer x = 41
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
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "년도별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_team from statictext within w_sal_07000
integer x = 59
integer y = 268
integer width = 448
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 32106727
long backcolor = 28144969
string text = "영업팀별"
boolean focusrectangle = false
end type

type dw_list_g from datawindow within w_sal_07000
event ue_mousemove pbm_mousemove
event ue_key pbm_dwnkey
integer x = 46
integer y = 1392
integer width = 4558
integer height = 920
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_07010"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_mousemove;String ls_Object
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
end event

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose
end event

event clicked;String	ls_Object
Long		ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())


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
		if ClassName(lw_window) = 'w_sal_07011' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	If lb_isopen Then
		Close(lw_window)
	End If
	
	OpenSheet(w_sal_07011, w_mdi_frame, 0, Layered!)
	
END IF

end event

event constructor;if wf_objectcheck() = -1 then
	is_preview = 'yes'
end if
end event

type st_titnm from statictext within w_sal_07000
integer x = 59
integer y = 1324
integer width = 453
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 32106727
long backcolor = 28144969
string text = "품종분류별"
boolean focusrectangle = false
end type

type rr_team from roundrectangle within w_sal_07000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 28144969
integer x = 37
integer y = 252
integer width = 590
integer height = 108
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sal_07000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 324
integer width = 4576
integer height = 944
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_titnm from roundrectangle within w_sal_07000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 28144969
integer x = 37
integer y = 1308
integer width = 590
integer height = 108
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_07000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1380
integer width = 4576
integer height = 944
integer cornerheight = 40
integer cornerwidth = 55
end type

