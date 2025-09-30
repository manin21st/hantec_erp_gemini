$PBExportHeader$w_gojung_popup.srw
$PBExportComments$고정자산팝업윈도우
forward
global type w_gojung_popup from w_inherite_popup
end type
end forward

global type w_gojung_popup from w_inherite_popup
integer width = 1696
integer height = 1928
string title = "고정자산조회선택"
end type
global w_gojung_popup w_gojung_popup

on w_gojung_popup.create
call super::create
end on

on w_gojung_popup.destroy
call super::destroy
end on

event open;call super::open;f_Window_Center_Response(This)
dw_1.retrieve('%')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_gojung_popup
boolean visible = false
integer x = 155
integer y = 2024
integer width = 142
integer height = 68
end type

type p_exit from w_inherite_popup`p_exit within w_gojung_popup
integer x = 1449
integer y = 16
end type

event p_exit::clicked;call super::clicked;setnull(gi_page)
setnull(gs_code)
setnull(gs_codename)

close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_gojung_popup
integer x = 1102
integer y = 16
end type

event p_inq::clicked;call super::clicked;String ls_kfcod1,ls_kfname,ls_kfcod
long ll_kfcod2

//ls_kfcod = ls_kfcod1 + string(ll_kfcod2)
//ls_kfcod = sle_1.text + "%"
ls_kfname ="%"+Trim(sle_2.text)+"%"

IF dw_1.Retrieve(ls_kfname) <=0 THEN
	MessageBox("자산명확인","고정자산 자료가 없습니다!!!")
	Return
END IF
end event

type p_choose from w_inherite_popup`p_choose within w_gojung_popup
integer x = 1275
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "kfcod1")
gi_page = dw_1.GetItemDecimal(ll_Row, "kfcod2")
gs_codename = dw_1.GetItemString(ll_Row, "kfname")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_gojung_popup
integer x = 46
integer y = 180
integer width = 1568
string dataobject = "d_pin1015_03"
end type

event dw_1::doubleclicked;call super::doubleclicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "kfcod1")
gi_page = dw_1.GetItemDecimal(ll_Row, "kfcod2")
gs_codename = dw_1.GetItemString(ll_Row, "kfname")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_gojung_popup
integer x = 73
integer y = 72
integer width = 1015
end type

type cb_1 from w_inherite_popup`cb_1 within w_gojung_popup
integer x = 677
end type

type cb_return from w_inherite_popup`cb_return within w_gojung_popup
integer x = 1312
end type

type cb_inq from w_inherite_popup`cb_inq within w_gojung_popup
integer x = 997
end type

type sle_1 from w_inherite_popup`sle_1 within w_gojung_popup
boolean visible = false
integer x = 558
end type

type st_1 from w_inherite_popup`st_1 within w_gojung_popup
integer y = 20
integer width = 494
string text = "고정자산명"
end type

