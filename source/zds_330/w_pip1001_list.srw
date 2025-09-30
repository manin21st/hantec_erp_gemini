$PBExportHeader$w_pip1001_list.srw
$PBExportComments$퇴직자 연봉 조회
forward
global type w_pip1001_list from w_standard_print
end type
type rr_1 from roundrectangle within w_pip1001_list
end type
end forward

global type w_pip1001_list from w_standard_print
string title = "퇴직자 연봉 현황"
rr_1 rr_1
end type
global w_pip1001_list w_pip1001_list

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_base

ls_base = dw_ip.GetItemString(row, 'd_base')
If Trim(ls_base) = '' OR IsNull(ls_base) Then
	MessageBox('기준월 확인', '기준월은 필수 입력항목 입니다.')
	dw_ip.SetColumn('d_base')
	dw_ip.SetFocus()
	Return -1
Else
	If IsDate(LEFT(ls_base, 4) + '.' + MID(ls_base, 5, 2) + '.' + '01') = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_base')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_yymm

ls_yymm = dw_ip.GetItemString(row, 'd_yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('기준월 확인', '기준월은 필수 입력항목 입니다.')
	dw_ip.SetColumn('d_yymm')
	dw_ip.SetFocus()
	Return -1
Else
	If IsDate(LEFT(ls_yymm, 4) + '.' + MID(ls_yymm, 5, 2) + '.' + '01') = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_yymm')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_emp
String ls_nam

ls_emp = dw_ip.GetItemString(row, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then 
	ls_emp = dw_ip.GetItemString(row, 'empnm')
	If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
		ls_emp = '%'
	Else
		ls_emp = '%' + ls_emp + '%'
	End If
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_base, ls_yymm, ls_emp)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1

end function

on w_pip1001_list.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pip1001_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String ls_base
SELECT MAX(YYMM)
  INTO :ls_base
  FROM P3_EDITYEARPAY ;

dw_ip.SetItem(1, 'd_base', ls_base)
dw_ip.SetItem(1, 'd_yymm', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_pip1001_list
integer x = 3849
integer y = 12
boolean enabled = false
end type

type p_sort from w_standard_print`p_sort within w_pip1001_list
integer x = 3671
integer y = 12
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_pip1001_list
boolean visible = false
integer x = 3310
integer y = 16
end type

type p_exit from w_standard_print`p_exit within w_pip1001_list
integer x = 4384
end type

type p_print from w_standard_print`p_print within w_pip1001_list
boolean visible = false
integer x = 3483
integer y = 16
end type

type p_retrieve from w_standard_print`p_retrieve within w_pip1001_list
integer x = 4210
end type







type st_10 from w_standard_print`st_10 within w_pip1001_list
end type



type dw_print from w_standard_print`dw_print within w_pip1001_list
integer x = 4059
string dataobject = "d_pip1001_list_001"
end type

type dw_ip from w_standard_print`dw_ip within w_pip1001_list
integer x = 37
integer width = 2053
integer height = 180
string dataobject = "d_pip1001_list_002"
end type

type dw_list from w_standard_print`dw_list within w_pip1001_list
integer x = 50
integer y = 224
integer width = 4535
integer height = 2000
string dataobject = "d_pip1001_list_001"
boolean border = false
end type

type rr_1 from roundrectangle within w_pip1001_list
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4562
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

