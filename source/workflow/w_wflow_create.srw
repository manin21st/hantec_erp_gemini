$PBExportHeader$w_wflow_create.srw
$PBExportComments$프로젝트 등록
forward
global type w_wflow_create from w_inherite
end type
type tab_detail from tab within w_wflow_create
end type
type tabpage_1 from userobject within tab_detail
end type
type tabpage_1 from userobject within tab_detail
end type
type tabpage_2 from userobject within tab_detail
end type
type tabpage_2 from userobject within tab_detail
end type
type tabpage_3 from userobject within tab_detail
end type
type tabpage_3 from userobject within tab_detail
end type
type tab_detail from tab within w_wflow_create
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type rr_1 from roundrectangle within w_wflow_create
end type
type dw_master from datawindow within w_wflow_create
end type
type dw_master_select from datawindow within w_wflow_create
end type
type dw_legend from datawindow within w_wflow_create
end type
end forward

global type w_wflow_create from w_inherite
string title = "프로젝트 등록"
event ue_flow_doubleclicked ( string as_flow_type,  string as_seq_arg )
event ue_child_data_changed ( datetime adt_f_date,  datetime adt_t_date,  string as_finish_yn,  decimal ad_prgss_rate,  datetime adt_s_date,  datetime adt_e_date )
event ue_postopen ( string as_arg )
event ue_flow_reset_child_page ( string as_flow_type )
tab_detail tab_detail
rr_1 rr_1
dw_master dw_master
dw_master_select dw_master_select
dw_legend dw_legend
end type
global w_wflow_create w_wflow_create

type variables
long il_retrieve_priorrow

w_flow iw_flow_page

w_flow iw_flow_gateway
w_flow iw_flow_activity
w_flow iw_flow_activity_sub

end variables

event ue_flow_doubleclicked(string as_flow_type, string as_seq_arg);if as_flow_type = 'gateway' then
	tab_detail.SelectedTab = 2
elseif as_flow_type = 'activity' then
	tab_detail.SelectedTab = 3
end if

end event

event ue_child_data_changed(datetime adt_f_date, datetime adt_t_date, string as_finish_yn, decimal ad_prgss_rate, datetime adt_s_date, datetime adt_e_date);long ll_row

ll_row = dw_master.getrow()
//if not iw_flow_gateway.ib_progress_mode then
	dw_master.setitem(ll_row, 'f_date', adt_f_date)
	dw_master.setitem(ll_row, 't_date', adt_t_date)
//else
	dw_master.setitem(ll_row, 'finish_yn', as_finish_yn)
	dw_master.setitem(ll_row, 'prgss_rate', ad_prgss_rate)
	dw_master.setitem(ll_row, 's_date', adt_s_date)
	dw_master.setitem(ll_row, 'e_date', adt_e_date)
//end if

end event

event ue_postopen(string as_arg);string ls_arg
string ls_proj_code, ls_proj_name
int    li_proj_seq
long   ll_find_row

if isnull(as_arg) = false and as_arg <> '' then
	ls_arg = as_arg
	ls_proj_code = f_get_token(ls_arg, '~t')
	li_proj_seq = integer(f_get_token(ls_arg, '~t'))

	  SELECT proj_name
	  	 INTO	:ls_proj_name
    FROM flow_project   
   WHERE flow_project.proj_code = :ls_proj_code ;

	IF Sqlca.SqlCode <> 0 THEN 
		Return
	END IF

	dw_insert.SetItem(1, 'proj_code', ls_proj_code)
	dw_insert.SetItem(1, 'proj_name', ls_proj_name)

	p_inq.TriggerEvent(clicked!)

	ll_find_row = dw_master.find('proj_code = "' + ls_proj_code + '" and proj_seq = ' + string(li_proj_seq), 1, dw_master.rowcount())
	if ll_find_row < 1 then
		messagebox('오류', '해당 프로젝트가 존재하지 않습니다.')
		return
	end if
	dw_master.scrolltorow(ll_find_row)
end if

end event

event ue_flow_reset_child_page;if as_flow_type = 'gateway' then
	tab_detail.tabpage_2.text = 'Activity'
	iw_flow_activity.wf_reset_page()
	tab_detail.tabpage_3.text = 'Activity Sub'
	iw_flow_activity_sub.wf_reset_page()
elseif as_flow_type = 'activity' then
	tab_detail.tabpage_3.text = 'Activity Sub'
	iw_flow_activity_sub.wf_reset_page()
end if

end event

on w_wflow_create.create
int iCurrent
call super::create
this.tab_detail=create tab_detail
this.rr_1=create rr_1
this.dw_master=create dw_master
this.dw_master_select=create dw_master_select
this.dw_legend=create dw_legend
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_detail
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.dw_master_select
this.Control[iCurrent+5]=this.dw_legend
end on

on w_wflow_create.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_detail)
destroy(this.rr_1)
destroy(this.dw_master)
destroy(this.dw_master_select)
destroy(this.dw_legend)
end on

event activate;Return 
end event

event mousemove;// override
return 
end event

event open;string ls_arg

// 메세지 보관
ls_arg = Message.StringParm

//dw_insert.SetTransObject(sqlca)
dw_insert.InsertRow(0)
dw_master.SetTransObject(sqlca)
dw_master_select.SetTransObject(sqlca)
dw_master_select.InsertRow(0)
dw_legend.visible = false
dw_legend.InsertRow(0)

openwithparm(iw_flow_gateway, this, "w_flow_gateway", this)
openwithparm(iw_flow_activity, this, "w_flow_activity", this)
openwithparm(iw_flow_activity_sub, this, "w_flow_activity_sub", this)
iw_flow_activity.iw_parent_flow = iw_flow_gateway
iw_flow_activity_sub.iw_parent_flow = iw_flow_activity

//tab_detail.triggerevent('resize!')
if IsValid(iw_flow_gateway) then
	iw_flow_gateway.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_gateway.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if
if IsValid(iw_flow_activity) then
	iw_flow_activity.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_activity.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if
if IsValid(iw_flow_activity_sub) then
	iw_flow_activity_sub.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_activity_sub.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if

iw_flow_page = iw_flow_gateway
//iw_flow_page.Move(dw_child.X, dw_child.Y)
iw_flow_page.post wf_set_movable(true)

this.post event ue_postopen(ls_arg)

end event

event closequery;// override
return iw_flow_page.wf_save_query(true)

end event

type dw_insert from w_inherite`dw_insert within w_wflow_create
integer x = 14
integer y = 36
integer width = 2126
integer height = 140
string dataobject = "dc_flow_project"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;IF GetColumnName() = 'proj_code' THEN
	String	ls_code, ls_name	
	
	ls_code = GetText()
	
	  SELECT proj_name
	  	 INTO	:ls_name
    FROM flow_project   
   WHERE flow_project.proj_code = :ls_code ;
	
	IF Sqlca.SqlCode <> 0 THEN 
		SetItem(1, 'proj_code', '')
		SetItem(1, 'proj_name', '')
		Return 1
	END IF
	
	SetItem(1, 'proj_name', ls_name)
	
	p_inq.TriggerEvent(clicked!)
END IF

end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)

IF GetColumnName() = 'proj_code' THEN
	open(w_wflow_project_pop)

	IF gs_code = '' Or IsNull(gs_code) THEN REturn

	SetItem(1, 'proj_code', gs_code)
	SetItem(1, 'proj_name', gs_codename)
	p_inq.TriggerEvent(clicked!)
END IF

end event

type p_delrow from w_inherite`p_delrow within w_wflow_create
event ue_enable ( boolean ab_flag )
boolean visible = false
integer x = 3506
string picturename = "C:\erpman\image\부서_up.gif"
end type

event p_delrow::ue_enable(boolean ab_flag);if ab_flag then
	this.enabled = true
	this.PictureName = "C:\erpman\image\부서_up.gif"
else
	this.enabled = false
	this.PictureName = "C:\erpman\image\부서_d.gif"
end if

end event

event p_delrow::ue_lbuttondown;PictureName = "C:\erpman\image\부서_dn.gif"
end event

event p_delrow::ue_lbuttonup;PictureName = "C:\erpman\image\부서_up.gif"
end event

type p_addrow from w_inherite`p_addrow within w_wflow_create
event ue_enable ( boolean ab_flag )
integer x = 3328
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event p_addrow::ue_enable(boolean ab_flag);if ab_flag then
	this.enabled = true
	this.PictureName = "C:\erpman\image\엑셀변환_up.gif"
else
	this.enabled = false
	this.PictureName = "C:\erpman\image\엑셀변환_d.gif"
end if

end event

event p_addrow::ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

event p_addrow::ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

event p_addrow::clicked;call super::clicked;string ls_arg
string ls_proj_code
int li_proj_seq
long ll_row
	
if iw_flow_gateway.wf_is_empty() = false then return
if dw_master.rowcount() <= 0 then return
ll_row = dw_master.getrow()
if ll_row <= 0 then return

ls_arg = dw_master.getitemstring(ll_row, 'proj_code') + '~n' + string(dw_master.getitemnumber(ll_row, 'proj_seq'))
openwithparm(w_wflow_excel_import, ls_arg)

if Message.DoubleParm > 0 then
	iw_flow_gateway.dynamic wf_retrieve_page(ls_arg)
	iw_flow_activity.dynamic wf_reset_page()
	iw_flow_activity_sub.dynamic wf_reset_page()
end if

end event

type p_search from w_inherite`p_search within w_wflow_create
integer x = 2930
string picturename = "C:\erpman\image\연결_up.gif"
end type

event p_search::clicked;iw_flow_page.dynamic wf_set_mode_add_line()

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\연결_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\연결_up.gif"
end event

type p_ins from w_inherite`p_ins within w_wflow_create
integer x = 4078
string picturename = "C:\erpman\image\ZOOM_up.gif"
end type

event p_ins::clicked;if dw_master.getrow() > 0 then
	if iw_flow_activity_sub.wf_save_query(true) > 0 then
		return
	end if
end if

iw_flow_gateway.dynamic wf_set_zoomout()
iw_flow_activity.dynamic wf_set_zoomout()
iw_flow_activity_sub.dynamic wf_set_zoomout()

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\zoom_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\zoom_up.gif"
end event

type p_exit from w_inherite`p_exit within w_wflow_create
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_wflow_create
integer x = 2752
string picturename = "C:\erpman\image\새개체_up.gif"
end type

event p_can::clicked;iw_flow_page.dynamic wf_set_mode_add_box()

end event

event p_can::ue_lbuttondown;PictureName = "C:\erpman\image\새개체_dn.gif"
end event

event p_can::ue_lbuttonup;PictureName = "C:\erpman\image\새개체_up.gif"
end event

type p_print from w_inherite`p_print within w_wflow_create
integer x = 4261
end type

event p_print::clicked;call super::clicked;iw_flow_page.dynamic wf_print_create_page()

// 미리보기
OpenWithParm(w_flow_preview, iw_flow_page.dw_print)

//// 출력
//if iw_flow_page.dw_print.rowcount() > 0 then
//	gi_page = iw_flow_page.dw_print.GetItemNumber(1, 'last_page')
//else
//	gi_page = 1
//end if
//OpenWithParm(w_print_options, iw_flow_page.dw_print)

end event

type p_inq from w_inherite`p_inq within w_wflow_create
integer x = 3721
end type

event p_inq::clicked;string ls_proj_code

if dw_master.getrow() > 0 then
	if iw_flow_page.wf_save_query(true) > 0 then
		return
	end if
	//iw_flow_page.wf_refresh_page()
end if

if dw_insert.AcceptText() = -1 then return

ls_proj_code = dw_insert.GetItemString(1, 'proj_code')
if ls_proj_code = '' or isnull(ls_proj_code) then return

dw_master.Retrieve(ls_proj_code)

end event

type p_del from w_inherite`p_del within w_wflow_create
integer x = 3109
end type

event p_del::clicked;call super::clicked;if f_msg_delete() = -1 then return  //삭제 Yes/No ?

iw_flow_page.dynamic wf_delete_select_item()

end event

type p_mod from w_inherite`p_mod within w_wflow_create
integer x = 3899
end type

event p_mod::clicked;int li_rc

dw_master.update()
li_rc = iw_flow_page.dynamic wf_save_page(true)

if li_rc = 0 then
	w_mdi_frame.sle_msg.text = "수정된 내용이 없습니다!"	
	return 
elseif li_rc > 0 then
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
else
	//f_message_chk(32,'[자료저장 실패]') 
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

iw_flow_page.wf_refresh_page()

end event

type cb_exit from w_inherite`cb_exit within w_wflow_create
end type

type cb_mod from w_inherite`cb_mod within w_wflow_create
end type

type cb_ins from w_inherite`cb_ins within w_wflow_create
end type

type cb_del from w_inherite`cb_del within w_wflow_create
end type

type cb_inq from w_inherite`cb_inq within w_wflow_create
end type

type cb_print from w_inherite`cb_print within w_wflow_create
end type

type st_1 from w_inherite`st_1 within w_wflow_create
end type

type cb_can from w_inherite`cb_can within w_wflow_create
end type

type cb_search from w_inherite`cb_search within w_wflow_create
end type







type gb_button1 from w_inherite`gb_button1 within w_wflow_create
end type

type gb_button2 from w_inherite`gb_button2 within w_wflow_create
end type

type tab_detail from tab within w_wflow_create
event resize pbm_size
integer x = 41
integer y = 324
integer width = 4553
integer height = 1932
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

event resize;//TabpostEvent('ue_tabpage_resize')

if IsValid(iw_flow_gateway) then
	iw_flow_gateway.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_gateway.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if

if IsValid(iw_flow_activity) then
	iw_flow_activity.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_activity.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if

if IsValid(iw_flow_activity_sub) then
	iw_flow_activity_sub.Move(tab_detail.X + 29, tab_detail.Y + 116)
	iw_flow_activity_sub.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
end if

end event

on tab_detail.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_detail.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanging;if oldindex >= 2 then
	return iw_flow_page.wf_save_query(false)
end if

return 0

end event

event selectionchanged;string ls_seq_arg
string ls_arg
string ls_proj_code
int li_proj_seq
long ll_row

if newindex = 1 then
	iw_flow_activity.hide()
	iw_flow_activity_sub.hide()
	iw_flow_page = iw_flow_gateway
elseif newindex = 2 then
	iw_flow_gateway.hide()
	iw_flow_activity_sub.hide()
	iw_flow_page = iw_flow_activity
	if not isvalid(iw_flow_gateway.iuo_select_box) then
		tabpage_2.text = 'Activity'
		iw_flow_page.dynamic wf_reset_page()
		tabpage_3.text = 'Activity Sub'
		iw_flow_activity_sub.dynamic wf_reset_page()
	else
		tabpage_2.text = 'Activity - ' + f_nvl(iw_flow_gateway.iuo_select_box.dw_info.getitemstring(1, 'gateway_name'), '')

		if newindex > oldindex then
			ll_row = dw_master.getrow()
			if ll_row > 0 then
				ls_seq_arg = iw_flow_gateway.dynamic wf_get_seq_arg()
				ls_arg = dw_master.getitemstring(ll_row, 'proj_code') + '~n' + &
							string(dw_master.getitemnumber(ll_row, 'proj_seq')) + '~n' + &
							ls_seq_arg
				iw_flow_page.dynamic wf_retrieve_page(ls_arg)
			end if
		end if
	end if
else
	iw_flow_gateway.hide()
	iw_flow_activity.hide()
	iw_flow_page = iw_flow_activity_sub
	if not isvalid(iw_flow_activity.iuo_select_box) then
		tabpage_3.text = 'Activity Sub'
		iw_flow_page.dynamic wf_reset_page()
	else
		tabpage_3.text = 'Activity Sub - ' + f_nvl(iw_flow_activity.iuo_select_box.dw_info.getitemstring(1, 'activity_name'), '')

		if newindex > oldindex then
			ll_row = dw_master.getrow()
			if ll_row > 0 then
				ls_seq_arg = iw_flow_activity.dynamic wf_get_seq_arg()
				ls_arg = dw_master.getitemstring(ll_row, 'proj_code') + '~n' + &
							string(dw_master.getitemnumber(ll_row, 'proj_seq')) + '~n' + &
							ls_seq_arg
				iw_flow_page.dynamic wf_retrieve_page(ls_arg)
			end if
		end if
	end if
end if

// 부서별 조회 버튼 활성/비활성
if iw_flow_page.wf_is_empty() then
	p_delrow.event ue_enable(false)
else
	p_delrow.event ue_enable(true)
end if

iw_flow_page.show()

end event

type tabpage_1 from userobject within tab_detail
event ue_tabpage_resize ( )
integer x = 18
integer y = 108
integer width = 4517
integer height = 1808
long backcolor = 32106727
string text = "Gateway"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
end type

event ue_tabpage_resize();//if IsValid(iw_flow_gateway) then
//	iw_flow_gateway.Move(tab_detail.X + 29, tab_detail.Y + 116)
//	iw_flow_gateway.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
//end if

end event

type tabpage_2 from userobject within tab_detail
event ue_tabpage_resize ( )
integer x = 18
integer y = 108
integer width = 4517
integer height = 1808
long backcolor = 32106727
string text = "Activity"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
end type

event ue_tabpage_resize();//if IsValid(iw_flow_activity) then
//	iw_flow_activity.Move(tab_detail.X + 29, tab_detail.Y + 116)
//	iw_flow_activity.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
//end if

end event

type tabpage_3 from userobject within tab_detail
integer x = 18
integer y = 108
integer width = 4517
integer height = 1808
long backcolor = 32106727
string text = "Sub Activity"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
end type

type rr_1 from roundrectangle within w_wflow_create
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 196
integer width = 1216
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_master from datawindow within w_wflow_create
boolean visible = false
integer x = 46
integer y = 320
integer width = 1614
integer height = 1128
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project_detail_display"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event rowfocuschanged;string ls_arg
string ls_proj_code
int li_proj_seq

if currentrow <= 0 then return

this.SelectRow(0, false)
this.SelectRow(currentrow, true)

dw_master_select.ScrollToRow(currentrow)

ls_arg = getitemstring(currentrow, 'proj_code') + '~n' + string(getitemnumber(currentrow, 'proj_seq'))
iw_flow_gateway.wf_retrieve_page(ls_arg)
iw_flow_activity.wf_reset_page()
iw_flow_activity_sub.wf_reset_page()

// 엑셀변환 버튼 활성/비활성
if iw_flow_gateway.wf_is_empty() then
	p_addrow.event ue_enable(true)
	p_delrow.event ue_enable(false)
else
	p_addrow.event ue_enable(false)
	p_delrow.event ue_enable(true)
end if

end event

event rowfocuschanging;return iw_flow_page.wf_save_query(true)

end event

event retrieveend;string ls_arg
string ls_proj_code
int li_proj_seq

if rowcount > 0 then
	dw_master.sharedata(dw_master_select)
else
	dw_master_select.reset()
	dw_master_select.insertrow(0)
end if

if rowcount > 0 then
	// 이전 row 가 1이 아니면 rowfocuschanged() 자동 발생됨
	// 이전 row 가 1이면 rowfocuschanged() 자동 발생안되므로 강제 실행
	if il_retrieve_priorrow = 1 then
		this.event rowfocuschanged(1)
	end if
else
	iw_flow_gateway.dynamic wf_reset_page()
	iw_flow_activity.dynamic wf_reset_page()
	iw_flow_activity_sub.dynamic wf_reset_page()
end if

end event

event losefocus;dw_master.visible = false

end event

event clicked;dw_master.visible = false

end event

event retrievestart;il_retrieve_priorrow = this.getrow()

end event

type dw_master_select from datawindow within w_wflow_create
integer x = 14
integer y = 188
integer width = 2126
integer height = 140
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project_detail_select"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;dw_master.visible = true

end event

type dw_legend from datawindow within w_wflow_create
boolean visible = false
integer x = 3287
integer y = 284
integer width = 1326
integer height = 132
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_progress_legend"
boolean border = false
boolean livescroll = true
end type

