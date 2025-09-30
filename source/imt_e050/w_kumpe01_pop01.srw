$PBExportHeader$w_kumpe01_pop01.srw
$PBExportComments$금형수리의뢰 선택
forward
global type w_kumpe01_pop01 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_kumpe01_pop01
end type
end forward

global type w_kumpe01_pop01 from w_inherite_popup
integer width = 3378
integer height = 2092
string title = "금형 수리의뢰 선택"
event ue_open ( )
rr_1 rr_1
end type
global w_kumpe01_pop01 w_kumpe01_pop01

event ue_open();String ls_st
String ls_ed

ls_st = String(RelativeDate(TODAY(), -15), 'yyyymmdd')
ls_ed = String(TODAY(), 'yyyymmdd')

dw_jogun.SetItem(1, 'sidat', ls_st)
dw_jogun.SetItem(1, 'eddat', ls_ed)


end event

on w_kumpe01_pop01.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kumpe01_pop01.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)
dw_1.SetTransObject(SQLCA)


This.PostEvent('ue_open')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kumpe01_pop01
integer width = 3296
string dataobject = "d_kumpe01_00030_pop01"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_gubun) 
SetNull(gs_code) 
SetNull(gs_codename)

String ls_dpcd
String ls_dpnm
String ls_cod

ls_cod = This.GetColumnName()

Choose Case ls_cod
	Case 'dept'
		Open(w_vndmst_4_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(1, 'dept'   , gs_code    )
		This.SetItem(1, 'dept_nm', gs_codename)
		
	Case 'empcd'
		Open(w_sawon_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(1, 'empcd' , gs_code                       )
		This.SetItem(1, 'emp_nm', f_get_name5('02', gs_code, ''))

		SELECT A.DEPTCODE, B.CVNAS
		  INTO :ls_dpcd  , :ls_dpnm
  		  FROM P1_MASTER A,
			    VNDMST    B 
       WHERE A.DEPTCODE        =  B.CVCOD
		   AND A.SERVICEKINDCODE <> '3' 
		   AND A.EMPNO           =  :gs_code ;
		
		This.SetItem(row, 'dept' , ls_dpcd)
		This.SetItem(row, 'empcd', ls_dpnm)
End Choose
end event

event dw_jogun::itemchanged;call super::itemchanged;This.AcceptText()

String ls_dpcd
String ls_dpnm

Choose Case dwo.name
	Case 'dept'
		This.SetItem(row, 'dept_nm', f_get_name5('01', data, ''))
	Case 'empcd'
		This.SetItem(row, 'emp_nm', f_get_name5('02', data, ''))		

		SELECT A.DEPTCODE, B.CVNAS
		  INTO :ls_dpcd  , :ls_dpnm
  		  FROM P1_MASTER A,
			    VNDMST    B 
       WHERE A.DEPTCODE        =  B.CVCOD
		   AND A.SERVICEKINDCODE <> '3' 
		   AND A.EMPNO           =  :data ;
		
		This.SetItem(row, 'dept' , ls_dpcd)
		This.SetItem(row, 'empcd', ls_dpnm)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_kumpe01_pop01
integer x = 3086
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kumpe01_pop01
integer x = 2738
integer y = 16
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

String ls_st
String ls_ed
String ls_emp
String ls_dpt

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

ls_st = dw_jogun.GetItemString(row, 'sidat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('의뢰일자 확인', '의뢰일자를 입력하십시오.')
	dw_jogun.SetColumn('sidat')
	dw_jogun.SetFocus()
	Return
Else
	If IsDate(LEFT(ls_st, 4) + '/' + MID(ls_st, 5, 2) + '/' + RIGHT(ls_st, 2)) Then
	Else
		MessageBox('일자확인', '잘못된 일자 형식입니다.')
		dw_jogun.SetColumn('sidat')
		dw_jogun.SetFocus()
		Return
	End If
End If

ls_ed = dw_jogun.GetItemString(row, 'eddat')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	MessageBox('의뢰일자 확인', '의뢰일자를 입력하십시오.')
	dw_jogun.SetColumn('eddat')
	dw_jogun.SetFocus()
	Return
Else
	If IsDate(LEFT(ls_ed, 4) + '/' + MID(ls_ed, 5, 2) + '/' + RIGHT(ls_ed, 2)) Then
	Else
		MessageBox('일자확인', '잘못된 일자 형식입니다.')
		dw_jogun.SetColumn('eddat')
		dw_jogun.SetFocus()
		Return
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '종료일자 보다 시작일자가 큽니다.')
	dw_jogun.SetColumn('sidat')
	dw_jogun.SetFocus()
	Return
End If

ls_emp = dw_jogun.GetItemString(row, 'empcd')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then ls_emp = '%'

ls_dpt = dw_jogun.GetItemString(row, 'dept')
If Trim(ls_dpt) = '' OR IsNull(ls_dpt) Then ls_dpt = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_emp, ls_dpt)
dw_1.SetRedraw(True)



end event

type p_choose from w_inherite_popup`p_choose within w_kumpe01_pop01
integer x = 2912
integer y = 16
end type

event p_choose::clicked;call super::clicked;dw_1.AcceptText()

Long   row

String ls_kum

row = dw_1.GetRow()
If row < 1 Then Return

ls_kum = dw_1.GetItemString(row, 'kumrsl_kum_kumno')

If Trim(ls_kum) = '' OR IsNull(ls_kum) Then
	MessageBox('학인', '항목을 선택하십시오.')
	Return
End If

String ls_dat

ls_dat = dw_1.GetItemString(row, 'kumrsl_kum_sidat')

SetNull(gs_code)
SetNull(gs_codename)

gs_code = ls_kum
gs_codename = ls_dat

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_kumpe01_pop01
integer x = 37
integer y = 352
integer width = 3259
integer height = 1604
string dataobject = "d_kumpe01_00030_pop02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;p_choose.PostEvent(Clicked!)
end event

type sle_2 from w_inherite_popup`sle_2 within w_kumpe01_pop01
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_kumpe01_pop01
boolean visible = false
integer x = 946
integer y = 2068
end type

type cb_return from w_inherite_popup`cb_return within w_kumpe01_pop01
boolean visible = false
integer x = 1582
integer y = 2068
end type

type cb_inq from w_inherite_popup`cb_inq within w_kumpe01_pop01
boolean visible = false
integer x = 1266
integer y = 2068
end type

type sle_1 from w_inherite_popup`sle_1 within w_kumpe01_pop01
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_kumpe01_pop01
boolean visible = false
end type

type rr_1 from roundrectangle within w_kumpe01_pop01
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 340
integer width = 3287
integer height = 1628
integer cornerheight = 40
integer cornerwidth = 55
end type

