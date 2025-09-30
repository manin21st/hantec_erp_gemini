$PBExportHeader$w_han_01010_if.srw
$PBExportComments$생산실적 현황 - I/F 현황
forward
global type w_han_01010_if from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_han_01010_if
end type
type pb_2 from u_pb_cal within w_han_01010_if
end type
type tab_1 from tab within w_han_01010_if
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
end type
type tabpage_3 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_3 rr_3
end type
type tab_1 from tab within w_han_01010_if
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_han_01010_if from w_inherite_popup
integer width = 4416
integer height = 2616
string title = "I/F 현황"
boolean controlmenu = true
pb_1 pb_1
pb_2 pb_2
tab_1 tab_1
end type
global w_han_01010_if w_han_01010_if

on w_han_01010_if.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.tab_1
end on

on w_han_01010_if.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.tab_1)
end on

event open;call super::open;dw_jogun.SetItem(1, 'd_st', String(RelativeDate(TODAY(), -1), 'yyyymmdd'))
dw_jogun.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
SELECT DATANAME
  INTO :ls_st
  FROM SYSCNFG
 WHERE SYSGU  = 'Y'
   AND SERIAL = '89'
   AND LINENO = 'ST' ;
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
SELECT DATANAME
  INTO :ls_ed
  FROM SYSCNFG
 WHERE SYSGU  = 'Y'
   AND SERIAL = '89'
   AND LINENO = 'ED' ;
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_jogun.SetItem(1, 'stim', ls_st)
dw_jogun.SetItem(1, 'etim', ls_ed)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_han_01010_if
integer x = 37
integer y = 32
integer width = 3579
integer height = 164
string dataobject = "d_han_01010_if_001"
end type

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event dw_jogun::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', '0630')
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', '0630')
		End If
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_han_01010_if
integer x = 4146
integer y = 40
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_han_01010_if
integer x = 3973
integer y = 40
end type

event p_inq::clicked;call super::clicked;dw_jogun.SetTransObject(SQLCA)

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_st
String ls_ed

ls_st = dw_jogun.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_jogun.SetColumn('d_st')
		dw_jogun.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_jogun.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_jogun.SetColumn('d_ed')
		dw_jogun.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_jogun.SetColumn('d_st')
	dw_jogun.SetFocus()
	Return -1
End If

String ls_stim

ls_stim = dw_jogun.GetItemString(row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_jogun.GetItemString(row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

//전송여부
String ls_stat
//Y:전송, N:미전송, %:전체
ls_stat = dw_jogun.GetItemString(row, 'stat')
If Trim(ls_stat) = '' OR IsNull(ls_stat) Then ls_stat = '%'

//에러여부
String ls_fail

//S:성공, E:에러, %:전체
ls_fail = dw_jogun.GetItemString(row, 'fail')
If Trim(ls_fail) = '' OR IsNull(ls_fail) Then ls_fail = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_stat, ls_fail)
dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_han_01010_if
boolean visible = false
integer x = 3689
integer y = 52
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_han_01010_if
integer x = 69
integer y = 332
integer width = 4219
integer height = 2112
string dataobject = "d_han_01010_if_002"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_han_01010_if
boolean visible = false
integer x = 544
integer y = 2472
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_han_01010_if
boolean visible = false
integer x = 672
integer y = 2356
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_han_01010_if
boolean visible = false
integer x = 1307
integer y = 2356
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_han_01010_if
boolean visible = false
integer x = 992
integer y = 2356
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_han_01010_if
boolean visible = false
integer x = 361
integer y = 2472
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_han_01010_if
boolean visible = false
integer x = 82
integer y = 2484
end type

type pb_1 from u_pb_cal within w_han_01010_if
integer x = 562
integer y = 72
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_jogun.GetItemString(1, 'd_ed') Then
	dw_jogun.SetItem(1, 'etim', '2400')
Else
	dw_jogun.SetItem(1, 'etim', '0630')
End If
end event

type pb_2 from u_pb_cal within w_han_01010_if
integer x = 1230
integer y = 72
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_jogun.GetItemString(1, 'd_st') Then
	dw_jogun.SetItem(1, 'etim', '2400')
Else
	dw_jogun.SetItem(1, 'etim', '0630')
End If


end event

type tab_1 from tab within w_han_01010_if
integer x = 32
integer y = 208
integer width = 4288
integer height = 2264
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

event selectionchanged;Choose Case NewIndex
	Case 1
		dw_1.DataObject = 'd_han_01010_if_002'
	Case 2
		dw_1.DataObject = 'd_han_01010_if_003'
	Case 3
		dw_1.DataObject = 'd_han_01010_if_004'
End Choose

dw_1.SetTransObject(SQLCA)
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4251
integer height = 2152
long backcolor = 32106727
string text = "작업실적"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.Control[]={this.rr_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 16
integer width = 4247
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4251
integer height = 2152
long backcolor = 32106727
string text = "비 가동"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
end type

on tabpage_2.create
this.rr_2=create rr_2
this.Control[]={this.rr_2}
end on

on tabpage_2.destroy
destroy(this.rr_2)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 16
integer width = 4247
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4251
integer height = 2152
long backcolor = 32106727
string text = "불량"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
end type

on tabpage_3.create
this.rr_3=create rr_3
this.Control[]={this.rr_3}
end on

on tabpage_3.destroy
destroy(this.rr_3)
end on

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 16
integer width = 4247
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

