$PBExportHeader$w_sm360_01010.srw
$PBExportComments$공장별 월 매출현황
forward
global type w_sm360_01010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sm360_01010
end type
type pb_2 from u_pb_cal within w_sm360_01010
end type
type rr_1 from roundrectangle within w_sm360_01010
end type
end forward

global type w_sm360_01010 from w_standard_print
string title = "공장별 매출현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sm360_01010 w_sm360_01010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('시작일 확인', '시작일을 입력 하십시오.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	MessageBox('종료일 확인', '종료일을 입력 하십시오.')
	dw_ip.SetColumn('d_ed')
	dw_ip.SetFocus()
	Return -1
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '종료일이 시작일 보다 빠릅니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then
	Return -1
Else
	dw_list.ShareData(dw_print)
End If

Return 1
end function

on w_sm360_01010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm360_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_sm360_01010
end type

type p_sort from w_standard_print`p_sort within w_sm360_01010
end type

type p_preview from w_standard_print`p_preview within w_sm360_01010
end type

type p_exit from w_standard_print`p_exit within w_sm360_01010
end type

type p_print from w_standard_print`p_print within w_sm360_01010
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm360_01010
end type







type st_10 from w_standard_print`st_10 within w_sm360_01010
end type



type dw_print from w_standard_print`dw_print within w_sm360_01010
string dataobject = "d_sm360_01010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_sm360_01010
integer x = 37
integer y = 32
integer width = 1307
integer height = 164
string dataobject = "d_sm360_01010_001"
end type

type dw_list from w_standard_print`dw_list within w_sm360_01010
integer x = 46
integer y = 220
integer width = 4553
integer height = 2028
string dataobject = "d_sm360_01010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sm360_01010
integer x = 539
integer y = 76
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
end event

type pb_2 from u_pb_cal within w_sm360_01010
integer x = 978
integer y = 76
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_sm360_01010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 208
integer width = 4581
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

