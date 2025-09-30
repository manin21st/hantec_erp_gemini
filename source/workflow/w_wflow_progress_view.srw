$PBExportHeader$w_wflow_progress_view.srw
$PBExportComments$프로젝트 진행률 조회
forward
global type w_wflow_progress_view from w_wflow_create
end type
end forward

global type w_wflow_progress_view from w_wflow_create
string title = "프로젝트 진행률"
end type
global w_wflow_progress_view w_wflow_progress_view

event open;call super::open;// 진행률 모드 설정
iw_flow_gateway.wf_set_progress_mode(true)
iw_flow_activity.wf_set_progress_mode(true)
iw_flow_activity_sub.wf_set_progress_mode(true)
// 읽기전용 설정
iw_flow_gateway.wf_set_readonly(true)
iw_flow_activity.wf_set_readonly(true)
iw_flow_activity_sub.wf_set_readonly(true)

dw_legend.visible = true

end event

on w_wflow_progress_view.create
call super::create
end on

on w_wflow_progress_view.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_insert from w_wflow_create`dw_insert within w_wflow_progress_view
end type

type p_delrow from w_wflow_create`p_delrow within w_wflow_progress_view
end type

type p_addrow from w_wflow_create`p_addrow within w_wflow_progress_view
boolean visible = false
end type

type p_search from w_wflow_create`p_search within w_wflow_progress_view
boolean visible = false
end type

type p_ins from w_wflow_create`p_ins within w_wflow_progress_view
end type

type p_exit from w_wflow_create`p_exit within w_wflow_progress_view
end type

type p_can from w_wflow_create`p_can within w_wflow_progress_view
boolean visible = false
end type

type p_print from w_wflow_create`p_print within w_wflow_progress_view
end type

type p_inq from w_wflow_create`p_inq within w_wflow_progress_view
end type

type p_del from w_wflow_create`p_del within w_wflow_progress_view
boolean visible = false
end type

type p_mod from w_wflow_create`p_mod within w_wflow_progress_view
boolean visible = false
end type

type cb_exit from w_wflow_create`cb_exit within w_wflow_progress_view
end type

type cb_mod from w_wflow_create`cb_mod within w_wflow_progress_view
end type

type cb_ins from w_wflow_create`cb_ins within w_wflow_progress_view
end type

type cb_del from w_wflow_create`cb_del within w_wflow_progress_view
end type

type cb_inq from w_wflow_create`cb_inq within w_wflow_progress_view
end type

type cb_print from w_wflow_create`cb_print within w_wflow_progress_view
end type

type st_1 from w_wflow_create`st_1 within w_wflow_progress_view
end type

type cb_can from w_wflow_create`cb_can within w_wflow_progress_view
end type

type cb_search from w_wflow_create`cb_search within w_wflow_progress_view
end type

type dw_datetime from w_wflow_create`dw_datetime within w_wflow_progress_view
end type

type sle_msg from w_wflow_create`sle_msg within w_wflow_progress_view
end type

type gb_10 from w_wflow_create`gb_10 within w_wflow_progress_view
end type

type gb_button1 from w_wflow_create`gb_button1 within w_wflow_progress_view
end type

type gb_button2 from w_wflow_create`gb_button2 within w_wflow_progress_view
end type

type tab_detail from w_wflow_create`tab_detail within w_wflow_progress_view
end type

type tabpage_1 from w_wflow_create`tabpage_1 within tab_detail
end type

type tabpage_2 from w_wflow_create`tabpage_2 within tab_detail
end type

type tabpage_3 from w_wflow_create`tabpage_3 within tab_detail
end type

type rr_1 from w_wflow_create`rr_1 within w_wflow_progress_view
end type

type dw_master from w_wflow_create`dw_master within w_wflow_progress_view
end type

type dw_master_select from w_wflow_create`dw_master_select within w_wflow_progress_view
end type

type dw_legend from w_wflow_create`dw_legend within w_wflow_progress_view
end type

