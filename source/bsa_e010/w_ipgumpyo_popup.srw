$PBExportHeader$w_ipgumpyo_popup.srw
$PBExportComments$ ===> �Աݴ���ں� �Ա�ǥ��ȣ POPUP
forward
global type w_ipgumpyo_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ipgumpyo_popup
end type
end forward

global type w_ipgumpyo_popup from w_inherite_popup
integer x = 850
integer y = 376
integer width = 805
integer height = 1412
boolean titlebar = false
rr_1 rr_1
end type
global w_ipgumpyo_popup w_ipgumpyo_popup

on w_ipgumpyo_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ipgumpyo_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_1.Reset()
if dw_1.Retrieve(gs_code) < 1 then
	MessageBox('Ȯ��', '�ش� ��������� �Ա�ǥ ������ �������� �ʽ��ϴ�.')
	SetNull(gs_gubun)
   SetNull(gs_code)
   SetNull(gs_codename)
   cb_return.TriggerEvent(Clicked!)
//   Close(Parent)
end if
	
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_ipgumpyo_popup
boolean visible = false
integer x = 0
integer y = 1696
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_ipgumpyo_popup
integer x = 603
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_ipgumpyo_popup
boolean visible = false
integer x = 974
integer y = 1720
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_ipgumpyo_popup
integer x = 430
end type

event p_choose::clicked;call super::clicked;Long cur_row

cur_row = dw_1.GetSelectedRow(0)

IF cur_row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(cur_row, "ipgum_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_ipgumpyo_popup
integer x = 23
integer y = 192
integer width = 727
integer height = 1168
integer taborder = 10
string dataobject = "d_ipgumpyo_pouup"
end type

event dw_1::clicked;call super::clicked;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
////	b_flag =True
//ELSE
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
////	b_flag = False
//END IF
//
////CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "ipgum_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_ipgumpyo_popup
boolean visible = false
integer x = 389
integer y = 1840
integer width = 1175
integer taborder = 0
long backcolor = 79741120
boolean enabled = false
boolean displayonly = true
end type

type cb_1 from w_inherite_popup`cb_1 within w_ipgumpyo_popup
boolean visible = false
integer x = 617
integer y = 1604
integer width = 311
integer height = 96
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_ipgumpyo_popup
boolean visible = false
integer x = 960
integer y = 1604
integer width = 311
integer height = 96
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_ipgumpyo_popup
boolean visible = false
integer x = 160
integer y = 1624
integer width = 379
integer taborder = 0
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_ipgumpyo_popup
boolean visible = false
integer x = 110
integer y = 1840
integer width = 270
integer taborder = 0
long backcolor = 79741120
boolean enabled = false
boolean displayonly = true
end type

type st_1 from w_inherite_popup`st_1 within w_ipgumpyo_popup
boolean visible = false
integer y = 1976
integer width = 325
string text = "�� �� �� :"
end type

type rr_1 from roundrectangle within w_ipgumpyo_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 184
integer width = 745
integer height = 1184
integer cornerheight = 40
integer cornerwidth = 55
end type

