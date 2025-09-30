$PBExportHeader$w_longmisu_popup.srw
$PBExportComments$ ===> 거래처별 장기미수 책정일자 Popup
forward
global type w_longmisu_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_longmisu_popup
end type
end forward

global type w_longmisu_popup from w_inherite_popup
integer x = 690
integer y = 388
integer width = 2341
integer height = 1408
rr_1 rr_1
end type
global w_longmisu_popup w_longmisu_popup

on w_longmisu_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_longmisu_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'cvcod', gs_code)
dw_jogun.SetItem(1, 'cvnas', gs_codename)

dw_1.Reset()
if dw_1.Retrieve(gs_code) < 1 then
	MessageBox('확인', '해당 거래처의 장기미수 내역이 존재하지 않습니다.')
	SetNull(gs_gubun)
   SetNull(gs_code)
   SetNull(gs_codename)
   p_exit.TriggerEvent(Clicked!)
end if
	
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_longmisu_popup
integer x = 27
integer y = 24
integer width = 1431
integer height = 144
string dataobject = "d_longmisu_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_longmisu_popup
integer x = 2112
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_longmisu_popup
boolean visible = false
integer x = 1765
boolean enabled = false
boolean originalsize = false
end type

type p_choose from w_inherite_popup`p_choose within w_longmisu_popup
integer x = 1938
end type

event p_choose::clicked;call super::clicked;Long cur_row

cur_row = dw_1.GetSelectedRow(0)

IF cur_row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(cur_row, "long_misu_date")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_longmisu_popup
integer x = 46
integer y = 192
integer width = 2240
integer height = 1100
integer taborder = 10
string dataobject = "d_longmisu_popup"
end type

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
//	b_flag =True
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
//	b_flag = False
END IF

//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "long_misu_date")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_longmisu_popup
boolean visible = false
integer x = 905
integer y = 1668
integer width = 1175
integer taborder = 0
long backcolor = 79741120
boolean enabled = false
boolean displayonly = true
end type

type cb_1 from w_inherite_popup`cb_1 within w_longmisu_popup
boolean visible = false
integer x = 539
integer y = 1584
integer width = 379
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_longmisu_popup
boolean visible = false
integer x = 946
integer y = 1584
integer width = 379
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_longmisu_popup
boolean visible = false
integer x = 123
integer y = 1596
integer width = 379
integer taborder = 0
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_longmisu_popup
boolean visible = false
integer x = 608
integer y = 1668
integer width = 270
integer taborder = 0
long backcolor = 79741120
boolean enabled = false
boolean displayonly = true
end type

type st_1 from w_inherite_popup`st_1 within w_longmisu_popup
boolean visible = false
integer x = 279
integer y = 1676
integer width = 325
string text = "거 래 처 :"
end type

type rr_1 from roundrectangle within w_longmisu_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 2258
integer height = 1116
integer cornerheight = 40
integer cornerwidth = 55
end type

