$PBExportHeader$w_vnditem_popup.srw
$PBExportComments$임시 발주에서 거래처별 품번 조회 선택
forward
global type w_vnditem_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_vnditem_popup
end type
end forward

global type w_vnditem_popup from w_inherite_popup
integer x = 197
integer y = 200
integer width = 2615
integer height = 2124
string title = "거래처별 품번 조회 선택"
rr_1 rr_1
end type
global w_vnditem_popup w_vnditem_popup

type variables
string is_cvcod
end variables

on w_vnditem_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_vnditem_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

is_cvcod = gs_code

dw_jogun.setitem(1, 'cvcod', is_cvcod )
dw_jogun.setitem(1, 'cvnas', gs_codename)
dw_jogun.setitem(1, 'sempno', gs_gubun )
dw_jogun.SetFocus()
	
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_vnditem_popup
integer x = 23
integer y = 24
integer width = 1234
integer height = 144
string dataobject = "d_vnditem_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_vnditem_popup
integer x = 2405
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_vnditem_popup
integer x = 2057
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sempno

if dw_jogun.AcceptText() = -1 then return 

sempno = dw_jogun.GetItemString(1,"sempno")

IF sempno ="" OR IsNull(sempno) THEN
	sempno ='%'
END IF

IF dw_1.Retrieve(gs_sabu,is_cvcod,sempno) <= 0 THEN
	dw_jogun.SetFocus()
	Return
END IF

dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_vnditem_popup
integer x = 2231
integer y = 16
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_vnditem_popup
integer x = 32
integer y = 184
integer width = 2537
integer height = 1816
integer taborder = 20
string dataobject = "d_vnditem_popup"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_vnditem_popup
boolean visible = false
integer x = 1061
integer y = 2076
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_vnditem_popup
integer x = 2062
integer y = 2060
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_vnditem_popup
integer x = 2683
integer y = 2060
end type

type cb_inq from w_inherite_popup`cb_inq within w_vnditem_popup
integer x = 2373
integer y = 2060
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_vnditem_popup
boolean visible = false
integer x = 398
integer y = 2076
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_vnditem_popup
boolean visible = false
integer x = 128
integer y = 2096
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_vnditem_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 180
integer width = 2569
integer height = 1824
integer cornerheight = 40
integer cornerwidth = 55
end type

