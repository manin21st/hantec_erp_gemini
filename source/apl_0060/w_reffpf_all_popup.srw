$PBExportHeader$w_reffpf_all_popup.srw
$PBExportComments$구분코드를 받아서 참조코드내역을 조회
forward
global type w_reffpf_all_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_reffpf_all_popup
end type
end forward

global type w_reffpf_all_popup from w_inherite_popup
integer width = 1879
integer height = 1944
rr_1 rr_1
end type
global w_reffpf_all_popup w_reffpf_all_popup

on w_reffpf_all_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_reffpf_all_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String sname

Select rfna1 into :sname
  from reffpf
 where rfcod = :gs_code and rfgub = '00';
 
this.title = sname


dw_1.settransobject(sqlca)
dw_1.retrieve(gs_code)

gs_code = ''
gs_codename = ''
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_reffpf_all_popup
integer x = 55
integer y = 2276
integer width = 1326
end type

type p_exit from w_inherite_popup`p_exit within w_reffpf_all_popup
integer x = 1659
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_reffpf_all_popup
boolean visible = false
integer x = 311
integer y = 2104
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_reffpf_all_popup
integer x = 1486
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "rfgub")
gs_codename= dw_1.GetItemString(ll_row,"rfna1")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_reffpf_all_popup
integer x = 46
integer y = 192
integer width = 1778
integer height = 1632
integer taborder = 30
string dataobject = "d_reffpf_all"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "rfgub")
gs_codename= dw_1.GetItemString(row,"rfna1")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_reffpf_all_popup
boolean visible = false
integer x = 635
integer y = 2020
integer width = 859
boolean enabled = false
end type

event sle_2::getfocus;//IF dw_2.GetItemString(1,"rfgub") = '1' THEN
//	f_toggle_kor(Handle(this))
//ELSE
//	f_toggle_eng(Handle(this))
//END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_reffpf_all_popup
integer x = 635
integer y = 2148
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_reffpf_all_popup
integer x = 942
integer y = 2148
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_reffpf_all_popup
integer x = 50
integer y = 2000
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_reffpf_all_popup
boolean visible = false
integer x = 375
integer y = 2020
integer width = 261
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_reffpf_all_popup
boolean visible = false
integer x = 50
integer y = 2032
integer width = 315
string text = "설비코드"
end type

type rr_1 from roundrectangle within w_reffpf_all_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 1801
integer height = 1644
integer cornerheight = 40
integer cornerwidth = 55
end type

