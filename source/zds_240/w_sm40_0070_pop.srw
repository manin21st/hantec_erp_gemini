$PBExportHeader$w_sm40_0070_pop.srw
$PBExportComments$단가소급 품목선택(multi-select)
forward
global type w_sm40_0070_pop from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sm40_0070_pop
end type
end forward

global type w_sm40_0070_pop from w_inherite_popup
integer width = 2734
integer height = 2384
string title = "단가소급 품목선택"
event ue_open ( )
rr_1 rr_1
end type
global w_sm40_0070_pop w_sm40_0070_pop

event ue_open();dw_jogun.InsertRow(0)

String ls_cvcod
String ls_gubun

ls_cvcod = gs_code
ls_gubun = gs_codename

//ls_gubun = 'Z01'이면 공장 조회조건 Visible = True

If ls_gubun <> 'Z01' Then
	dw_jogun.Modify('factory.Visible = False')
	dw_jogun.Modify('factory_t.Visible = False')
	dw_jogun.Modify('t_2.Visible = False')
	
	dw_1.DataObject = 'd_sm40_0070_pop_003'
	dw_1.SetTransObject(SQLCA)
End If

dw_jogun.SetItem(1, 'cvcod', ls_cvcod)
dw_jogun.SetItem(1, 'cvnas', f_get_name5('11', ls_cvcod, ''))

DataWindowChild dwc_fac

dw_jogun.GetChild('factory', dwc_fac)
dwc_fac.SetTransObject(SQLCA)
dwc_fac.Retrieve(ls_cvcod)

end event

event open;call super::open;This.TriggerEvent('ue_open')
end event

on w_sm40_0070_pop.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sm40_0070_pop.destroy
call super::destroy
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_sm40_0070_pop
integer x = 37
integer y = 32
integer width = 2071
integer height = 192
string dataobject = "d_sm40_0070_pop_001"
end type

type p_exit from w_inherite_popup`p_exit within w_sm40_0070_pop
integer x = 2482
integer y = 36
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm40_0070_pop
integer x = 2135
integer y = 36
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_cvcod
String ls_fac

ls_cvcod = dw_jogun.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	Messagebox('거래처 확인', '거래처가 선택되지 않았습니다.')
	Return
End If

If dw_jogun.Describe("factory.Visible") = '1' Then
	ls_fac = dw_jogun.GetItemString(row, 'factory')
	If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
		MessageBox('공장코드 확인', '공장코드가 선택되지 않았습니다.')
		dw_jogun.SetColumn('factory')
		dw_jogun.SetFocus()
		Return
	End If
End If

If dw_jogun.Describe("factory.Visible") = '1' Then
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_fac, ls_cvcod)
	dw_1.SetRedraw(True)
Else
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_cvcod)
	dw_1.SetRedraw(True)
End If
end event

type p_choose from w_inherite_popup`p_choose within w_sm40_0070_pop
integer x = 2309
integer y = 36
end type

event p_choose::clicked;call super::clicked;Long   ll_find

ll_find = dw_1.Find("chk = 'Y'", 1, dw_1.RowCount())
If ll_find < 1 Then
	MessageBox('확인', '자료를 선택 하십시오.')
	Return
End If

gs_code = 'OK'

SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sm40_0070_pop
integer x = 50
integer y = 236
integer width = 2615
integer height = 2008
string dataobject = "d_sm40_0070_pop_002"
boolean hsplitscroll = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_sm40_0070_pop
boolean visible = false
integer x = 1047
integer y = 2628
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm40_0070_pop
boolean visible = false
integer x = 1522
integer y = 2376
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sm40_0070_pop
boolean visible = false
integer x = 2158
integer y = 2376
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm40_0070_pop
boolean visible = false
integer x = 1842
integer y = 2376
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm40_0070_pop
boolean visible = false
integer x = 864
integer y = 2628
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_sm40_0070_pop
boolean visible = false
integer x = 585
integer y = 2640
end type

type rr_1 from roundrectangle within w_sm40_0070_pop
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 224
integer width = 2642
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

