$PBExportHeader$w_smorpm_popup.srw
$PBExportComments$** 판매/생산 계획 선택
forward
global type w_smorpm_popup from w_inherite_popup
end type
end forward

global type w_smorpm_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 1353
integer height = 528
string title = "판매/생산 계획 선택"
end type
global w_smorpm_popup w_smorpm_popup

on w_smorpm_popup.create
call super::create
end on

on w_smorpm_popup.destroy
call super::destroy
end on

event open;call super::open;dw_jogun.InsertRow(0)

setnull(gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_smorpm_popup
integer x = 41
integer y = 24
integer width = 1029
integer height = 368
string dataobject = "d_smorpm_popup0"
end type

type p_exit from w_inherite_popup`p_exit within w_smorpm_popup
boolean visible = false
integer x = 2034
integer y = 16
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_smorpm_popup
boolean visible = false
integer x = 2299
integer y = 16
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_smorpm_popup
integer x = 1102
integer y = 48
end type

event p_choose::clicked;call super::clicked;gs_gubun= dw_jogun.getitemstring(1,'jegoyn')
gs_code = dw_jogun.getitemstring(1,'smorpm')
if isnull(gs_code) or gs_code = '' then return

close(parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_smorpm_popup
boolean visible = false
integer x = 2446
integer y = 416
integer width = 169
integer height = 128
integer taborder = 20
end type

type sle_2 from w_inherite_popup`sle_2 within w_smorpm_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_smorpm_popup
boolean visible = false
integer x = 1728
integer y = 1952
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_smorpm_popup
boolean visible = false
integer x = 2048
integer y = 1952
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_smorpm_popup
boolean visible = false
integer x = 1074
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_smorpm_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_smorpm_popup
boolean visible = false
end type

