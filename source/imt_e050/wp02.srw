$PBExportHeader$wp02.srw
$PBExportComments$금형수리의뢰 접수 및 결과등록
forward
global type wp02 from w_inherite
end type
type dw_1 from datawindow within wp02
end type
type dw_list from u_d_select_sort within wp02
end type
type cbx_1 from checkbox within wp02
end type
type pb_1 from u_pb_cal within wp02
end type
type pb_2 from u_pb_cal within wp02
end type
type pb_3 from u_pb_cal within wp02
end type
type pb_4 from u_pb_cal within wp02
end type
type p_1 from uo_picture within wp02
end type
type dw_2 from datawindow within wp02
end type
type cb_1 from commandbutton within wp02
end type
type cb_2 from commandbutton within wp02
end type
type cb_3 from commandbutton within wp02
end type
type p_2 from picture within wp02
end type
type dw_print from datawindow within wp02
end type
type rr_1 from roundrectangle within wp02
end type
end forward

global type wp02 from w_inherite
integer width = 4677
integer height = 4084
string title = "금형 수리 접수 및 결과등록"
dw_1 dw_1
dw_list dw_list
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
p_1 p_1
dw_2 dw_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
p_2 p_2
dw_print dw_print
rr_1 rr_1
end type
global wp02 wp02

type variables
String is_chk
end variables

forward prototypes
public subroutine wf_ini ()
public function integer wf_chk ()
public subroutine wf_cal (string as_data[], long row)
public function integer wf_daychk (string as_str[])
end prototypes

public subroutine wf_ini ();If is_chk = '1' OR is_chk = '2' Then
	cbx_1.Enabled = True
	
	dw_insert.SetTabOrder('susidat', 0)
	dw_insert.SetTabOrder('susitim', 0)
	dw_insert.SetTabOrder('sueddat', 0)
	dw_insert.SetTabOrder('suedtim', 0)
	dw_insert.SetTabOrder('chkman' , 0)
	dw_insert.SetTabOrder('gorsl'  , 0)
	dw_insert.SetTabOrder('gocod'  , 0)
	dw_insert.SetTabOrder('bigo'   , 0)
	dw_insert.SetTabOrder('ipnum'  , 0)
//	dw_insert.SetTabOrder('testdat', 0)
//	dw_insert.SetTabOrder('testtim', 0)
	
Else
	
	dw_insert.SetTabOrder('chkman' , 30 )
	dw_insert.SetTabOrder('susidat', 40 )
	dw_insert.SetTabOrder('susitim', 50 )
	dw_insert.SetTabOrder('sueddat', 60 )
	dw_insert.SetTabOrder('suedtim', 70 )
//	dw_insert.SetTabOrder('testdat', 80 )
//	dw_insert.SetTabOrder('testtim', 90 )
   dw_insert.SetTabOrder('ipnum'  , 80 )
	dw_insert.SetTabOrder('gocod'  , 100)
	dw_insert.SetTabOrder('gorsl'  , 110)
	dw_insert.SetTabOrder('bigo'   , 120)
End If

end subroutine

public function integer wf_chk ();dw_insert.AcceptText()

String ls_data[]

Long   row
Long   ll_min

row = dw_insert.GetRow()
If row < 1 Then Return -1
	
ls_data[9]  = dw_insert.GetItemString(row, 'edtim')
ls_data[10] = dw_insert.GetItemString(row, 'eddat') 

If cbx_1.Checked = True Then	
	ls_data[5] = dw_insert.GetItemString(row, 'chkman')
	If Trim(ls_data[5]) = '' OR IsNull(ls_data[5]) Then
		MessageBox('수리담당자', '수리담당자를 입력하십시오.')
		dw_insert.SetColumn('chkman')
		dw_insert.SetFocus()
		Return -1
	End If
	
	ls_data[1] = dw_insert.GetItemString(row, 'susidat')
	If Trim(ls_data[1]) = '' OR IsNull(ls_data[1]) Then
		MessageBox('수리시작일', '수리시작일을 입력하십시오.')
		dw_insert.SetColumn('susidat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	ls_data[11] = dw_insert.GetItemString(row, 'redat')
	If Trim(ls_data[11]) = '' OR IsNull(ls_data[11]) Then
		ls_data[11] = ls_data[1]
		dw_insert.SetItem(row, 'redat', ls_data[1])
	End If
	
	ls_data[2] = dw_insert.GetItemString(row, 'susitim')
	If Trim(ls_data[2]) = '' OR IsNull(ls_data[2]) Then
		ls_data[2] = '0000'
//		MessageBox('수리시작시간', '수리시작시간을 입력하십시오.')
//		dw_insert.SetColumn('susitim')
//		dw_insert.SetFocus()
//		Return -1
	End If
	
	ls_data[3] = dw_insert.GetItemString(row, 'sueddat')
	If Trim(ls_data[3]) = '' OR IsNull(ls_data[3]) Then
		MessageBox('수리종료일', '수리종료일을 입력하십시오.')
		dw_insert.SetColumn('sueddat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	ls_data[12] = dw_insert.GetItemString(row, 'comdat')
	If Trim(ls_data[12]) = '' OR IsNull(ls_data[12]) Then
		ls_data[12] = ls_data[3]
		dw_insert.SetItem(row, 'comdat', ls_data[3])
	End If
	
	ls_data[4] = dw_insert.GetItemString(row, 'suedtim')
	If Trim(ls_data[4]) = '' OR IsNull(ls_data[4]) Then
		ls_data[4] = '0000'
//		MessageBox('수리종료시간', '수리종료시간을 입력하십시오.')
//		dw_insert.SetColumn('suedtim')
//		dw_insert.SetFocus()
//		Return -1
	End If
	
	ls_data[6] = dw_insert.GetItemString(row, 'gocod')
	If Trim(ls_data[6]) = '' OR IsNull(ls_data[6]) Then
		MessageBox('고장원인', '고장원인을 입력하십시오.')
		dw_insert.SetColumn('gocod')
		dw_insert.SetFocus()
		Return -1
	End If
	
//	ls_data[7] = dw_insert.GetItemString(row, 'testdat')
//	If Trim(ls_data[7]) = '' OR IsNull(ls_data[7]) Then
//		MessageBox('가동시작일', '가동시작일을 입력하십시오.')
//		dw_insert.SetColumn('testdat')
//		dw_insert.SetFocus()
//		Return -1
//	End If
//	
//	ls_data[8] = dw_insert.GetItemString(row, 'testtim')
//	If Trim(ls_data[8]) = '' OR IsNull(ls_data[8]) Then
//		MessageBox('가동시작시간', '가동시작시간을 입력하십시오.')
//		dw_insert.SetColumn('testtim')
//		dw_insert.SetFocus()
//		Return -1
//	End If
	
	ls_data[99] = 'A'
	
	If wf_daychk(ls_data[]) < 1 Then Return -1	
	
	wf_cal(ls_data[], row)

Else
	ls_data[1] = dw_insert.GetItemString(row, 'redat')
	If Trim(ls_data[1]) = '' OR IsNull(ls_data[1]) Then
		MessageBox('의뢰접수일', '의뢰접수일을 입력하십시오.')
		dw_insert.SetColumn('redat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	ls_data[2] = dw_insert.GetItemString(row, 'comdat')
	If Trim(ls_data[2]) = '' OR IsNull(ls_data[2]) Then
		MessageBox('수리예정일', '수리예정일을 입력하십시오.')
		dw_insert.SetColumn('comdat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	ls_data[99] = 'N'
	
	If wf_daychk(ls_data[]) < 1 Then Return -1
	
End If

Return 1
end function

public subroutine wf_cal (string as_data[], long row);Long   ll_day
Long   ll_min

String ls_day1
String ls_day2
String ls_tim1
String ls_tim2

ls_day1 = LEFT(as_data[1], 4) + '/' + MID(as_data[1], 5, 2) + '/' + RIGHT(as_data[1], 2)
ls_day2 = LEFT(as_data[3], 4) + '/' + MID(as_data[3], 5, 2) + '/' + RIGHT(as_data[3], 2)

ls_tim1 = LEFT(as_data[2], 2) + ':' + RIGHT(as_data[2], 2)
ls_tim2 = LEFT(as_data[4], 2) + ':' + RIGHT(as_data[4], 2)

If NOT (IsDate(ls_day1) AND IsDate(ls_day2) AND IsTime(ls_tim1) AND IsTime(ls_tim2)) Then
	Return
End If

//수리시간

ll_day = DaysAfter(Date(ls_day1), Date(ls_day2))

ll_day = (ll_day * 24) * 60

ll_min = SecondsAfter(Time(ls_tim1), Time(ls_tim2))
ll_min = (ll_min / 60) + ll_day

dw_insert.SetItem(row, 'fixtim', ll_min)

//SetNull(ll_min)
//SetNull(ll_day)
//SetNull(ls_day1)
//SetNull(ls_day2)
//SetNull(ls_tim1)
//SetNull(ls_tim2)
//
////고장시간
//
//ls_day1 = LEFT(as_data[10], 4) + '/' + MID(as_data[10], 5, 2) + '/' + RIGHT(as_data[10], 2)
//ls_day2 = LEFT(as_data[7], 4) + '/' + MID(as_data[7], 5, 2) + '/' + RIGHT(as_data[7], 2)
//
//ls_tim1 = LEFT(as_data[9], 2) + ':' + RIGHT(as_data[9], 2)
//ls_tim2 = LEFT(as_data[8], 2) + ':' + RIGHT(as_data[8], 2)
//
//If NOT (IsDate(ls_day1) AND IsDate(ls_day2) AND IsTime(ls_tim1) AND IsTime(ls_tim2)) Then
//	Return
//End If
//
//ll_day = DaysAfter(Date(ls_day1), Date(ls_day2))
//
//ll_day = (ll_day * 24) * 60
//
//ll_min = SecondsAfter(Time(ls_tim1), Time(ls_tim2))
//ll_min = (ll_min / 60) + ll_day
//
//dw_insert.SetItem(row, 'trbtim', ll_min)
end subroutine

public function integer wf_daychk (string as_str[]);/*-------------------------------------------------------------------------------------------------------------------------
[1]  = 수리시작일
[2]  = 수리시작시간
[3]  = 수리종료일
[4]  = 수리종료시간
[7]  = 가동시작일
[8]  = 가동시작시간
[9]  = 생산종료시간
[10] = 생산종료일
[11] = 요청접수일
[12] = 수리완료예정일
-------------------------------------------------------------------------------------------------------------------------*/
If as_str[99] = 'A' Then
	//생산종료일보다 요청접수일이 빠를경우
	If as_str[10] > as_str[11] Then
		MessageBox('일자확인', '생산종료일보다 요청접수일이 빠릅니다.')
		dw_insert.SetColumn('redat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//요청접수일보다 수리완료예정일이 빠를경우
	If as_str[11] > as_str[12] Then
		MessageBox('일자확인', '요청접수일 보다 수리완료예정일이 빠릅니다.')
		dw_insert.SetColumn('comdat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//요청접수일보다 수리시작일이 빠를경우
	If as_str[11] > as_str[1] Then
		MessageBox('일자확인', '요청접수일 보다 수리시작일이 빠릅니다.')
		dw_insert.SetColumn('susidat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//생산종료일자와 수리시작일이 같은 경우 시간 확인
	If as_str[10] = as_str[1] Then
		If as_str[9] > as_str[2] Then
			dw_insert.SetItem(1, 'susitim', as_str[9])
//			MessageBox('시간확인', '생산종료시간 보다 수리시작시간이 빠릅니다.')
//			dw_insert.SetColumn('susitim')
//			dw_insert.SetFocus()
//			Return -1
		End If
	End If
	
	//수리시작일보다 수리종료일이 빠를 경우
	If as_str[1] > as_str[3] Then
		MessageBox('일자확인', '수리시작일 보다 수리종료일이 빠릅니다.')
		dw_insert.SetColumn('sueddat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//수리시작일과 수리종료일이 같은 경우 시간 확인
	If as_str[1] = as_str[3] Then
		If as_str[2] > as_str[4] Then
			dw_insert.SetItem(1, 'suedtim', as_str[2])
//			MessageBox('시간확인', '수리시작시간 보다 수리종료시간이 빠릅니다.')
//			dw_insert.SetColumn('suedtim')
//			dw_insert.SetFocus()
//			Return -1
		End If
	End If
	
//	//수리종료일보다 가동시작일이 빠를 경우
//	If as_str[3] > as_str[7] Then
//		MessageBox('일자확인', '수리종료일 보다 가동시작일이 빠릅니다.')
//		dw_insert.SetColumn('testdat')
//		dw_insert.SetFocus()
//		Return -1
//	End If
//	
//	//수리종료일과 가동시작일이 같은 경우 시간확인
//	If as_str[3] = as_str[7] Then
//		If as_str[4] > as_str[8] Then
//			MessageBox('시간확인', '수리종료시간 보다 가동시작시간이 빠릅니다.')
//			dw_insert.SetColumn('testtim')
//			dw_insert.SetFocus()
//			Return -1
//		End If
//	End If
		
Else
	/*----------------------------------------------------------------
	[1]  = 요청접수일
	[2]  = 수리완료예정일
	[10] = 생산종료일
	----------------------------------------------------------------*/
	
	//생산종료일보다 요청접수일이 빠를경우
	If as_str[10] > as_str[1] Then
		MessageBox('일자확인', '생산종료일보다 요청접수일이 빠릅니다.')
		dw_insert.SetColumn('redat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//요청접수일보다 수리완료예정일이 빠를경우
	If as_str[1] > as_str[2] Then
		MessageBox('일자확인', '요청접수일 보다 수리완료예정일이 빠릅니다.')
		dw_insert.SetColumn('comdat')
		dw_insert.SetFocus()
		Return -1
	End If	
	
End If

Return 1















































































































end function

on wp02.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.p_1=create p_1
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.p_2=create p_2
this.dw_print=create dw_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.pb_4
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.p_2
this.Control[iCurrent+14]=this.dw_print
this.Control[iCurrent+15]=this.rr_1
end on

on wp02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.p_2)
destroy(this.dw_print)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_insert.InsertRow(0)

DataWindowChild dwc_sub

dw_1.GetChild('sub', dwc_sub)
dwc_sub.SetTransObject(SQLCA)
dwc_sub.Retrieve('%')

dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

String ls_st
String ls_ed

ls_st = String(TODAY(), 'yyyymm') + '01'
ls_ed = String(TODAY(), 'yyyymmdd')

dw_1.SetItem(1, 'sidat', ls_st)
dw_1.SetItem(1, 'eddat', ls_ed)

wf_ini()
end event

type dw_insert from w_inherite`dw_insert within wp02
integer x = 2162
integer y = 240
integer width = 2459
integer height = 2024
string dataobject = "d_kumpe01_00040_03"
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_gubun) 
SetNull(gs_code) 
SetNull(gs_codename)

Choose Case This.GetColumnName()	
	Case 'chkman'
		Open(w_sawon_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(1, 'chkman' , gs_code                         )
		This.SetItem(1, 'empname_1', f_get_name5('02', gs_code, ''))
End Choose
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

This.AcceptText()

Choose Case dwo.name
	Case 'susidat', 'susitim', 'sueddat', 'suedtim'
		String ls_sidat
		String ls_sitim
		String ls_eddat
		String ls_edtim
		
		ls_sidat = This.GetItemString(row, 'susidat')
		ls_sitim = This.GetItemString(row, 'susitim')
		ls_eddat = This.GetItemString(row, 'sueddat')
		ls_edtim = This.GetItemString(row, 'suedtim')
		
		If Trim(ls_sidat) = '' OR IsNull(ls_sidat) OR IsDate(String(ls_sidat, '@@@@-@@-@@')) = False Then Return
		If Trim(ls_sitim) = '' OR IsNull(ls_sitim) OR IsDate(String(ls_eddat, '@@@@-@@-@@')) = False Then Return
		If Trim(ls_eddat) = '' OR IsNull(ls_eddat) OR IsTime(String(ls_sitim, '@@:@@:@@'))   = False Then Return
		If Trim(ls_edtim) = '' OR IsNull(ls_edtim) OR IsTime(String(ls_edtim, '@@:@@:@@'))   = False Then Return
		
		Long   ll_day
		Long   ll_tim
		
		ll_day = DaysAfter(Date(String(ls_sidat, '@@@@-@@-@@')), Date(String(ls_eddat, '@@@@-@@-@@')))
		ll_tim = SecondsAfter(Time(String(ls_sitim, '@@:@@:@@')), Time(String(ls_edtim, '@@:@@:@@')))
		
		Long   ll_min
		
		ll_min = (ll_day * 60) + (ll_tim / 60)
		This.SetItem(row, 'fixtim', ll_min)
		
End Choose
end event

event dw_insert::buttonclicked;//

end event

type p_delrow from w_inherite`p_delrow within wp02
boolean visible = false
integer x = 901
integer y = 28
end type

type p_addrow from w_inherite`p_addrow within wp02
boolean visible = false
integer x = 727
integer y = 28
end type

type p_search from w_inherite`p_search within wp02
boolean visible = false
integer x = 32
integer y = 28
end type

type p_ins from w_inherite`p_ins within wp02
boolean visible = false
integer x = 553
integer y = 28
end type

type p_exit from w_inherite`p_exit within wp02
integer x = 4448
integer y = 20
end type

type p_can from w_inherite`p_can within wp02
integer x = 4274
integer y = 20
end type

event p_can::clicked;call super::clicked;dw_1.AcceptText()

String ls_st
String ls_ed

ls_st = dw_1.GetItemString(1, 'sidat')
ls_ed = dw_1.GetItemString(1, 'eddat')

dw_1.ReSet()
dw_list.ReSet()
dw_insert.ReSet()
dw_2.ReSet()

dw_1.InsertRow(0)
dw_insert.InsertRow(0)

dw_1.SetItem(1, 'sidat', ls_st)
dw_1.SetItem(1, 'eddat', ls_ed)

wf_ini()

cbx_1.Checked = False
end event

type p_print from w_inherite`p_print within wp02
boolean visible = false
integer x = 206
integer y = 28
end type

type p_inq from w_inherite`p_inq within wp02
integer x = 3753
integer y = 20
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

String ls_st
String ls_ed
String ls_kum
String ls_sta

row = dw_1.GetRow()
If row < 1 Then Return

ls_st = dw_1.GetItemString(row, 'sidat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('의뢰일자', '의뢰일자를 입력하십시오!')
	dw_1.SetColumn('sidat')
	dw_1.SetFocus()
	Return
End If

ls_ed = dw_1.GetItemString(row, 'eddat')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	MessageBox('의뢰일자', '의뢰일자를 입력하십시오!')
	dw_1.SetColumn('eddat')
	dw_1.SetFocus()
	Return
End If

//ls_kum = dw_1.GetItemString(row, 'kumno')
//If Trim(ls_kum) = '' OR IsNull(ls_kum) Then ls_kum = '%'

String  ls_itm
ls_itm = dw_1.GetItemString(row, 'itnbr')
If Trim(ls_itm) = '' OR IsNull(ls_itm) Then ls_itm = '%'

ls_sta = dw_1.GetItemString(row, 'status')
If Trim(ls_sta) = '' OR IsNull(ls_sta) Then ls_sta = '%'

String ls_gub1
String ls_gub2
String ls_gub3
String ls_gub4

ls_gub1 = dw_1.GetItemString(row, 'gbn1')
If Trim(ls_gub1) = '' OR IsNull(ls_gub1) Then ls_gub1 = 'N'
ls_gub2 = dw_1.GetItemString(row, 'gbn2')
If Trim(ls_gub2) = '' OR IsNull(ls_gub2) Then ls_gub2 = 'N'
ls_gub3 = dw_1.GetItemString(row, 'gbn3')
If Trim(ls_gub3) = '' OR IsNull(ls_gub3) Then ls_gub3 = 'N'
ls_gub4 = dw_1.GetItemString(row, 'gbn4')
If Trim(ls_gub4) = '' OR IsNull(ls_gub4) Then ls_gub4 = 'N'

String ls_gub

ls_gub = ls_gub1 + ls_gub2 + ls_gub3 + ls_gub4
If ls_gub = 'NNNN' Then ls_gub = '%'

//String ls_grp
//
//ls_grp = dw_1.GetItemString(row, 'grp')
//If Trim(ls_grp) = '' OR IsNull(ls_grp) OR ls_grp = '%' Then
//	ls_grp = '%'
//Else
//	ls_grp = ls_grp + '%'
//End If
//
//String ls_sub
//ls_sub = dw_1.GetItemString(row, 'sub')
//If Trim(ls_sub) = '' OR IsNull(ls_sub) OR ls_sub = '%' Then
//	ls_sub = '%'
//End If

String ls_gubun

ls_gubun = dw_1.GetItemString(row, 'gubun')
If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = '%'

dw_list.SetRedraw(False)
//dw_list.Retrieve(ls_st, ls_ed, ls_kum, ls_sta, ls_gub, ls_grp, ls_sub)
//dw_list.Retrieve(ls_st, ls_ed, ls_kum, ls_sta, ls_gub, ls_gubun)
dw_list.Retrieve(ls_st, ls_ed, ls_itm, ls_sta, ls_gub, ls_gubun)
dw_list.SetRedraw(True)

If is_chk = '3' Then
	cbx_1.Checked = True
Else
	cbx_1.Checked = False
End If

If dw_list.RowCount() < 1 Then
	p_2.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_2.Enabled = False
	Return
Else
	p_2.PictureName = 'C:\erpman\image\인쇄_up.gif'
	p_2.Enabled = True
End If
end event

type p_del from w_inherite`p_del within wp02
integer x = 4101
integer y = 20
end type

event p_del::clicked;call super::clicked;/**********************************************************************************************************/
/******																															  ******/
/******               삭제 時 상태 변경 작업하기 위함 (DATA 삭제는 이루어 지지 않음)                 ******/
/******											      	2005.11.04    													  ******/
/**********************************************************************************************************/
If f_msg_delete() = -1 Then Return

Long   row

String ls_stat
String ls_jpno

row = dw_list.GetRow()
If row < 1 Then Return

ls_jpno = dw_list.GetItemString(row, 'kumrsl_kum_jpno')
ls_stat = dw_list.GetItemString(row, 'status'         )

Choose Case ls_stat
	Case '1'
		//의뢰
		MessageBox('의뢰자료 삭제', '의뢰중인 자료는 삭제하실 수 없습니다.')
		Return
		
	Case '2'
		//접수
		UPDATE KUMRSL_KUM
		   SET REDAT  = NULL,
			    COMDAT = NULL
		 WHERE JPNO   = :ls_jpno ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			f_message_chk(32, '[삭제실패]')
			Return
		End If
		
	Case '3'
		//완료
		UPDATE KUMRSL_KUM
		   SET SUSIDAT = NULL, SUSITIM = NULL, SUEDDAT = NULL, SUEDTIM = NULL,
			    CHKMAN  = NULL, GORSL   = NULL, GOCOD   = NULL, BIGO    = NULL,
				 TESTDAT = NULL, TESTTIM = NULL, FIXTIM  = NULL, TRBTIM  = NULL
		 WHERE JPNO    = :ls_jpno ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			f_message_chk(32, '[삭제실패]')
			Return
		End If
		
End Choose

COMMIT USING SQLCA;

cbx_1.Checked = False

ib_any_typing = False

p_inq.PostEvent(Clicked!)

wf_ini()











end event

type p_mod from w_inherite`p_mod within wp02
integer x = 3927
integer y = 20
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

If dw_insert.GetItemStatus(1, 0, Primary!) = NotModified! Then Return

If f_msg_update() = -1 Then Return

If wf_chk() = -1 Then Return

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	f_message_chk(32, '[저장실패]')
	Return
End If

cbx_1.Checked = False

ib_any_typing = False

p_inq.PostEvent(Clicked!)

wf_ini()
end event

type cb_exit from w_inherite`cb_exit within wp02
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within wp02
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within wp02
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within wp02
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within wp02
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within wp02
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within wp02
end type

type cb_can from w_inherite`cb_can within wp02
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within wp02
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within wp02
end type

type gb_button2 from w_inherite`gb_button2 within wp02
end type

type dw_1 from datawindow within wp02
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 24
integer width = 3031
integer height = 220
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kumpe01_00040_02"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;This.AcceptText()

String ls_name

Choose Case dwo.name
	Case 'kumno'
		SELECT KUMNAME
		  INTO :ls_name
		  FROM KUMMST
		 WHERE KUMNO = :data ;
		If Trim(ls_name) = '' OR IsNull(ls_name) Then
			MessageBox('금형코드', '등록된 금형코드가 아닙니다.')
			This.SetColumn('kumno')
			This.SetFoCus()
			Return 1
		End If
		
		This.SetItem(1, 'kumnm', ls_name)
		
	Case 'grp'
		DataWindowChild dwc_sub

		dw_1.GetChild('sub', dwc_sub)
		dwc_sub.SetTransObject(SQLCA)
		
		If Trim(data) = '' OR IsNull(data) Then
			dwc_sub.Retrieve('%')
		Else
			dwc_sub.Retrieve(data)
		End If
			
End Choose
end event

event itemerror;return 1

end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

String ls_name

Choose Case This.GetColumnName()
	Case 'kumno'
		Open(w_imt_04630_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		SELECT KUMNAME
		  INTO :ls_name
		  FROM KUMMST
		 WHERE KUMNO = :gs_code ;
		If Trim(ls_name) = '' OR IsNull(ls_name) Then
			Messagebox('금형 마스터', '등록된 금형코드가 아닙니다!')
			Return 1
		End If
		
		This.SetItem(1, 'kumno', gs_code)
		This.SetItem(1, 'kumnm', ls_name)
		
End Choose




end event

type dw_list from u_d_select_sort within wp02
integer x = 37
integer y = 252
integer width = 2103
integer height = 2004
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_kumpe01_00040_01"
boolean border = false
boolean hsplitscroll = true
end type

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow < 1 Then Return

This.SelectRow(0, FALSE)
This.SetRow(currentrow)	
This.SelectRow(currentrow, TRUE)

String ls_jpno

ls_jpno = This.GetItemString(currentrow, 'kumrsl_kum_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then Return

is_chk = This.GetItemString(currentrow, 'status')
If is_chk = '1' OR is_chk = '2' Then
	cbx_1.Enabled = True
	cbx_1.Checked = False
ElseIf is_chk = '3' Then
	cbx_1.Enabled = True
	cbx_1.Checked = True
Else
	cbx_1.Enabled = False
	cbx_1.Checked = False
End If

dw_insert.Retrieve(ls_jpno)

dw_2.SetRedraw(False)
dw_2.Retrieve(ls_jpno)
dw_2.SetRedraw(True)

wf_ini()


end event

event retrieveend;call super::retrieveend;If rowcount < 1 Then 
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	Return
End If

String ls_jp

ls_jp = This.GetItemString(1, 'kumrsl_kum_jpno')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_jp)
dw_insert.SetRedraw(True)

dw_2.SetRedraw(False)
dw_2.Retrieve(ls_jp)
dw_2.SetRedraw(True)

is_chk = This.GetItemString(1, 'status')

If is_chk = '1' OR is_chk = '2' Then
	cbx_1.Enabled = True
	cbx_1.Checked = False
ElseIf is_chk = '3' Then
	cbx_1.Enabled = True
	cbx_1.Checked = True
Else
	cbx_1.Enabled = False
	cbx_1.Checked = False
End If
end event

type cbx_1 from checkbox within wp02
integer x = 4032
integer y = 1200
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "결과등록"
end type

event clicked;If cbx_1.Checked = True Then
	dw_insert.SetTabOrder('chkman' , 30 )
	dw_insert.SetTabOrder('susidat', 40 )
	dw_insert.SetTabOrder('susitim', 50 )
	dw_insert.SetTabOrder('sueddat', 60 )
	dw_insert.SetTabOrder('suedtim', 70 )
	dw_insert.SetTabOrder('testdat', 80 )
	dw_insert.SetTabOrder('testtim', 90 )
	dw_insert.SetTabOrder('gorsl'  , 100)
	dw_insert.SetTabOrder('gocod'  , 110)
	dw_insert.SetTabOrder('bigo'   , 120)
	dw_insert.SetTabOrder('ipnum'  , 130)	
Else
	dw_insert.SetTabOrder('chkman' , 0)
	dw_insert.SetTabOrder('susidat', 0)
	dw_insert.SetTabOrder('susitim', 0)
	dw_insert.SetTabOrder('sueddat', 0)
	dw_insert.SetTabOrder('suedtim', 0)
	dw_insert.SetTabOrder('testdat', 0)
	dw_insert.SetTabOrder('testtim', 0)
	dw_insert.SetTabOrder('gorsl'  , 0)
	dw_insert.SetTabOrder('gocod'  , 0)
	dw_insert.SetTabOrder('bigo'   , 0)
	dw_insert.SetTabOrder('ipnum'  , 0)
End If
end event

type pb_1 from u_pb_cal within wp02
integer x = 2866
integer y = 1184
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('redat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'redat', gs_code)
end event

type pb_2 from u_pb_cal within wp02
integer x = 3904
integer y = 1180
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('comdat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'comdat', gs_code)
end event

type pb_3 from u_pb_cal within wp02
integer x = 2944
integer y = 1472
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;If cbx_1.Checked = False Then Return

dw_insert.Setcolumn('susidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'susidat', gs_code)
end event

type pb_4 from u_pb_cal within wp02
integer x = 2944
integer y = 1560
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;If cbx_1.Checked = False Then Return

dw_insert.Setcolumn('sueddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'sueddat', gs_code)
end event

type p_1 from uo_picture within wp02
boolean visible = false
integer x = 3447
integer y = 20
integer width = 306
integer taborder = 180
boolean bringtotop = true
string picturename = "C:\erpman\image\사용자재등록_up.gif"
end type

event clicked;call super::clicked;////If dw_list.RowCount() < 1 Then Return

//If dw_list.GetItemString(dw_list.GetRow(), 'status') <> '3' Then
//	MessageBox('확인', '완료된 자료만 등록 가능합니다.')
//	Return
//End If

gstr_array lstr_a

If dw_insert.AcceptText() = -1 Then Return

/*----------------------------------------
lstr_a.as_str[1] = 의뢰일자
lstr_a.as_str[2] = 금형코드
lstr_a.as_str[3] = 수리시작일
lstr_a.as_str[4] = 구분(1:수정, 2:수리, 3:청소)
lstr_a.as_str[5] = 전표번호
lstr_a.as_str[6] = Window Title
----------------------------------------*/

lstr_a.as_str[1] = Trim(dw_insert.GetItemString(1, 'sidat')  )
lstr_a.as_str[2] = Trim(dw_insert.GetItemString(1, 'kumno')  )
lstr_a.as_str[3] = Trim(dw_insert.GetItemString(1, 'susidat'))
lstr_a.as_str[4] = Trim(dw_insert.GetItemString(1, 'gubun')  )
//lstr_a.as_str[5] = Trim(dw_insert.GetItemString(1, 'iojpno') )
lstr_a.as_str[5] = Trim(dw_insert.GetItemString(1, 'jpno') )
lstr_a.as_str[6] = '수리결과 '

If lstr_a.as_str[2] = '' OR IsNull(lstr_a.as_str[2]) Then
	MessageBox("자료 확인", "금형코드를 확인하세요!")
	Return
End If

Openwithparm(w_kumpe01_00040_pop1, lstr_a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\사용자재등록_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\사용자재등록_up.gif"
end event

type dw_2 from datawindow within wp02
event ue_enter pbm_dwnprocessenter
boolean visible = false
integer x = 1975
integer y = 2332
integer width = 1678
integer height = 404
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_kumpe01_00040_04_jig"
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(This), 256, 9, 0)
Return 1
end event

event constructor;This.SetTransObject(SQLCA)
end event

event buttonclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'b_1'
		p_1.PostEvent(Clicked!)
End Choose

end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

type cb_1 from commandbutton within wp02
boolean visible = false
integer x = 3653
integer y = 2328
integer width = 402
integer height = 128
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
boolean enabled = false
string text = "추가"
end type

event clicked;String ls_jpno

ls_jpno = dw_insert.GetItemString(1, 'jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('확인', '의뢰번호가 선택되지 않았습니다.')
	Return
End If

Long   in_row

in_row = dw_2.InsertRow(0)

dw_2.SetItem(in_row, 'jpno', ls_jpno)
dw_2.SetItem(in_row, 'usedat', String(TODAY(), 'yyyymmdd'))
end event

type cb_2 from commandbutton within wp02
boolean visible = false
integer x = 3653
integer y = 2460
integer width = 402
integer height = 128
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
boolean enabled = false
string text = "삭제"
end type

event clicked;Long   row

row = dw_2.GetRow()
If row < 1 Then Return

If f_msg_delete() < 1 Then Return

dw_2.DeleteRow(row)

If dw_2.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제오류', '삭제 중 오류가 발생했습니다.')
	
	String ls_jpno
	
	ls_jpno = dw_insert.GetItemString(1, 'jpno')
	
	dw_2.SetRedraw(False)
	dw_2.Retrieve(ls_jpno)
	dw_2.SetRedraw(True)
End If

end event

type cb_3 from commandbutton within wp02
boolean visible = false
integer x = 3653
integer y = 2592
integer width = 402
integer height = 128
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
boolean enabled = false
string text = "저장"
end type

event clicked;If f_msg_update() < 1 Then Return

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = dw_insert.GetItemString(row, 'jpno')
If trim(ls_jpno) = '' OR IsNull(ls_jpno) Then Return

Long  ll_cnt

ll_cnt = dw_2.RowCount()
If ll_cnt < 1 Then Return

Long   i
Long   ll_find

String ls_gbn
String ls_ipno

For i = 1 To ll_cnt
	ls_gbn  = dw_2.GetItemString(i, 'gubun')
	ls_ipno = dw_2.GetItemString(i, 'ipno' )
	
	If i = ll_cnt Then Exit
	
	ll_find = dw_2.FIND("jpno = '" + ls_jpno + "' AND gubun = '" + ls_gbn + "' AND ipno = '" + ls_ipno + "'", i + 1, ll_cnt)
	If ll_find > 0 Then
		MessageBox('중복자료', String(i) + '행과 ' + String(ll_find) + '행이 중복입니다.')
		dw_2.SetColumn('ipno')
		dw_2.SetFocus()
		dw_2.ScrollToRow(i)
		Return
	End If
Next

If dw_2.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장에 실패 했습니다')
End If
end event

type p_2 from picture within wp02
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3072
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\인쇄_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_2.PictureName = 'C:\erpman\image\인쇄_dn.gif'
end event

event ue_lbuttonup;p_2.PictureName = 'C:\erpman\image\인쇄_up.gif'
end event

event clicked;Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = dw_insert.GetItemString(row, 'jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then Return

dw_print.Retrieve(ls_jpno)

OpenWithParm(w_print_preview, dw_print)	

end event

type dw_print from datawindow within wp02
integer x = 1271
integer y = 2288
integer width = 183
integer height = 136
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_kumpe01_00030_p1_new"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within wp02
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 244
integer width = 2126
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

