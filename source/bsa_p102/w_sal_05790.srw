$PBExportHeader$w_sal_05790.srw
$PBExportComments$전년 동월 대비 제품별 판매실적 현황
forward
global type w_sal_05790 from w_standard_dw_graph
end type
type dw_view from datawindow within w_sal_05790
end type
end forward

global type w_sal_05790 from w_standard_dw_graph
string title = "전년 동월 대비 제품별 판매실적 현황"
dw_view dw_view
end type
global w_sal_05790 w_sal_05790

forward prototypes
public function integer wf_retrieve ()
public function integer wf_setting_datawindow (string sdatef, string sdatet, string sgubun, string stitle)
end prototypes

public function integer wf_retrieve ();String sdatef, sDatet
Long   ix, nRow

If dw_ip.AcceptText() <> 1 Then Return -1

sdatet   = Trim(dw_ip.GetItemString(1,'sym'))

if	f_datechk(sDatet+'01') <> 1 then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

dw_list.SetRedraw(False)
dw_list.Reset()

/* 2년전 실적 금액 */
sDatef = f_aftermonth(sDatet,-24)
wf_setting_datawindow(sDatef, sDatef, '1',String(sDatef,'@@@@.@@'))

/* 1년전 실적 금액 */
sDatef = f_aftermonth(sDatet,-12)
wf_setting_datawindow(sDatef, sDatef, '2',String(sDatef,'@@@@.@@'))

/* 당월 실적 금액 */
wf_setting_datawindow(sDatet, sDatet, '3',String(sDatet,'@@@@.@@'))

dw_list.Object.txt_sdate.text = String(sDatet,'@@@@.@@')

dw_list.SetRedraw(True)

return 1
end function

public function integer wf_setting_datawindow (string sdatef, string sdatet, string sgubun, string stitle);Long nRow , ix, iy, row
Double dQty, dAmt

/* N-UP 수 지정 */
Int  nNupCnt = 14

/* 실적 금액 조회*/
nRow = dw_view.Retrieve(gs_sabu, sdatef, sdatet)
If nRow <= 0 Then Return -1

/* 중분류가 N-up수 이상이면 자른다 */
If nRow >= nNupCnt Then
	iy = nNupCnt
Else
	iy = nRow
End If

For ix = 1 To iy - 1
	row = dw_list.InsertRow(0)	
	
	dw_list.SetItem(row,'gubun',sGubun)
	dw_list.SetItem(row,'title',sTitle)
	dw_list.SetItem(row,'titnm',dw_view.GetItemString(ix,'titnm'))
	dw_list.SetItem(row,'sales_qty',dw_view.GetItemNumber(ix,'sales_qty'))
	dw_list.SetItem(row,'sales_amt',dw_view.GetItemNumber(ix,'sales_amt')/1000)
Next

/* 마지막 row인 [기타]와 N-Up수 이상 실적을 집계한다 */
For ix = iy To nRow
	dQty += dw_view.GetItemNumber(ix,'sales_qty')
	dAmt += dw_view.GetItemNumber(ix,'sales_amt')
Next
row = dw_list.InsertRow(0)	
dw_list.SetItem(row,'gubun',sGubun)
dw_list.SetItem(row,'title',sTitle)
dw_list.SetItem(row,'titnm',    dw_view.GetItemString(nRow,'titnm'))
dw_list.SetItem(row,'sales_qty',dQty)
dw_list.SetItem(row,'sales_amt',dAmt/1000)

/* N-up에 모자라는 수만큼 Insert한다 */
If nRow < nNupCnt Then
	For ix = 1 To nNupCnt - nRow
		dw_list.InsertRow(0)
	Next
End If

Return 0

end function

on w_sal_05790.create
int iCurrent
call super::create
this.dw_view=create dw_view
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_view
end on

on w_sal_05790.destroy
call super::destroy
destroy(this.dw_view)
end on

event open;call super::open;dw_view.SetTransObject(sqlca)

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

dw_ip.setitem(1,'sym',left(f_today(),6))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05790
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05790
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05790
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05790
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05790
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05790
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05790
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05790
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05790
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05790
integer x = 27
integer y = 32
integer width = 910
integer height = 136
string dataobject = "d_sal_05790_01"
end type

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05790
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05790
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05790
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05790
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05790
integer y = 204
integer width = 4553
integer height = 2112
string dataobject = "d_sal_05790"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05790
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05790
integer y = 192
integer width = 4585
integer height = 2144
end type

type dw_view from datawindow within w_sal_05790
boolean visible = false
integer x = 137
integer y = 2372
integer width = 1499
integer height = 360
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_05780_01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

