$PBExportHeader$w_mroitem_popup.srw
$PBExportComments$�ܰ�����Ÿ���� �ŷ�ó�� ǰ�� ��ȸ ����
forward
global type w_mroitem_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_mroitem_popup
end type
end forward

global type w_mroitem_popup from w_inherite_popup
integer x = 466
integer y = 160
integer width = 2843
integer height = 2168
string title = "�ŷ�ó�� ǰ�� ��ȸ ����"
rr_1 rr_1
end type
global w_mroitem_popup w_mroitem_popup

type variables
string is_cvcod
end variables

on w_mroitem_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mroitem_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

is_cvcod = gs_code

dw_jogun.setitem(1, 'cvcod', is_cvcod )
dw_jogun.setitem(1, 'cvnas', gs_codename)
//dw_jogun.setitem(1, 'sempno', gs_gubun )
dw_jogun.SetFocus()
	
dw_1.ScrollToRow(1)

p_inq.PostEvent(Clicked!)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mroitem_popup
integer x = 9
integer y = 28
integer width = 1317
integer height = 140
string dataobject = "d_vnditem_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_mroitem_popup
integer x = 2610
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mroitem_popup
integer x = 2263
integer y = 16
end type

event p_inq::clicked;call super::clicked;if dw_jogun.AcceptText() = -1 then return 

IF dw_1.Retrieve(is_cvcod, gs_saupj) <= 0 THEN
	dw_jogun.SetFocus()
	Return
END IF

dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_mroitem_popup
integer x = 2437
integer y = 16
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mroitem_popup
integer x = 27
integer y = 184
integer width = 2752
integer height = 1856
integer taborder = 20
string dataobject = "d_mroitem_popup"
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
//   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
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

type sle_2 from w_inherite_popup`sle_2 within w_mroitem_popup
boolean visible = false
integer x = 1125
integer y = 2500
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_mroitem_popup
integer x = 1211
integer y = 2572
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_mroitem_popup
integer x = 1833
integer y = 2572
end type

type cb_inq from w_inherite_popup`cb_inq within w_mroitem_popup
integer x = 1522
integer y = 2572
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mroitem_popup
boolean visible = false
integer x = 462
integer y = 2500
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_mroitem_popup
boolean visible = false
integer x = 192
integer y = 2520
integer width = 251
string text = "ǰ���ڵ�"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_mroitem_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 176
integer width = 2779
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

