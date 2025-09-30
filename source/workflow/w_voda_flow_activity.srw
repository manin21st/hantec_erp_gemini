$PBExportHeader$w_voda_flow_activity.srw
$PBExportComments$Work Flow (Parent Window)
forward
global type w_voda_flow_activity from w_inherite
end type
type rr_1 from roundrectangle within w_voda_flow_activity
end type
type dw_master from datawindow within w_voda_flow_activity
end type
type dw_master_select from datawindow within w_voda_flow_activity
end type
type dw_legend from datawindow within w_voda_flow_activity
end type
type p_1 from picture within w_voda_flow_activity
end type
type p_3 from picture within w_voda_flow_activity
end type
type dw_proj from datawindow within w_voda_flow_activity
end type
type dw_proj_file from datawindow within w_voda_flow_activity
end type
end forward

global type w_voda_flow_activity from w_inherite
string title = "프로젝트 관리"
event ue_flow_doubleclicked ( string as_flow_type,  string as_seq_arg )
event ue_child_data_changed ( datetime adt_f_date,  datetime adt_t_date,  string as_finish_yn,  decimal ad_prgss_rate,  datetime adt_s_date,  datetime adt_e_date )
event ue_postopen ( string as_arg )
event ue_flow_reset_child_page ( string as_flow_type )
rr_1 rr_1
dw_master dw_master
dw_master_select dw_master_select
dw_legend dw_legend
p_1 p_1
p_3 p_3
dw_proj dw_proj
dw_proj_file dw_proj_file
end type
global w_voda_flow_activity w_voda_flow_activity

type variables
long il_retrieve_priorrow

w_voda_flow iw_flow_page

//w_voda_flow iw_flow_gateway
w_voda_flow iw_flow_activity
//w_voda_flow iw_flow_activity_sub

window iw_parent
end variables

event ue_flow_doubleclicked(string as_flow_type, string as_seq_arg);//if as_flow_type = 'gateway' then
//	tab_detail.SelectedTab = 2
//elseif as_flow_type = 'activity' then
//	tab_detail.SelectedTab = 3
//end if
//
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

p_3.enabled = true 

end event

event ue_flow_reset_child_page(string as_flow_type);//if as_flow_type = 'gateway' then
//	tab_detail.tabpage_2.text = 'Activity'
//	iw_flow_activity.wf_reset_page()
//	tab_detail.tabpage_3.text = 'Activity Sub'
//	iw_flow_activity_sub.wf_reset_page()
//elseif as_flow_type = 'activity' then
//	tab_detail.tabpage_3.text = 'Activity Sub'
//	iw_flow_activity_sub.wf_reset_page()
//end if
//
end event

on w_voda_flow_activity.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_master=create dw_master
this.dw_master_select=create dw_master_select
this.dw_legend=create dw_legend
this.p_1=create p_1
this.p_3=create p_3
this.dw_proj=create dw_proj
this.dw_proj_file=create dw_proj_file
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.dw_master_select
this.Control[iCurrent+4]=this.dw_legend
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.p_3
this.Control[iCurrent+7]=this.dw_proj
this.Control[iCurrent+8]=this.dw_proj_file
end on

on w_voda_flow_activity.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_master)
destroy(this.dw_master_select)
destroy(this.dw_legend)
destroy(this.p_1)
destroy(this.p_3)
destroy(this.dw_proj)
destroy(this.dw_proj_file)
end on

event activate;Return 
end event

event mousemove;// override
return 
end event

event open;call super::open;string ls_arg

// 메세지 보관
ls_arg = Message.StringParm

//dw_insert.SetTransObject(sqlca)
dw_insert.InsertRow(0)
dw_master.SetTransObject(sqlca)
dw_master_select.SetTransObject(sqlca)
dw_master_select.InsertRow(0)
dw_legend.visible = false
dw_legend.InsertRow(0)

openwithparm(iw_flow_activity, this, "w_voda_flow", this)
//openwithparm(iw_flow_activity, this, "w_flow_activity", this)
//openwithparm(iw_flow_activity_sub, this, "w_flow_activity_sub", this)
//iw_flow_activity.iw_parent_flow = iw_flow_gateway
//iw_flow_activity_sub.iw_parent_flow = iw_flow_activity
//
//tab_detail.triggerevent('resize!')
//if IsValid(iw_flow_gateway) then
	iw_flow_activity.Move(this.X + 29, this.Y + 250)
	iw_flow_activity.Resize(this.Width - 68, this.Height - 350) // - dw_emplist.Height - 40)
//end if
//if IsValid(iw_flow_activity) then
//	iw_flow_activity.Move(tab_detail.X + 29, tab_detail.Y + 116)
//	iw_flow_activity.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
//end if
//if IsValid(iw_flow_activity_sub) then
//	iw_flow_activity_sub.Move(tab_detail.X + 29, tab_detail.Y + 116)
//	iw_flow_activity_sub.Resize(tab_detail.Width - 68, tab_detail.Height - 136) // - dw_emplist.Height - 40)
//end if

iw_flow_page = iw_flow_activity

gnv_Help = Create nvo_bubblehelp
gnv_help.iw_parent_voda = this
gnv_help.is_chk = 'Y'

//iw_flow_page.Move(dw_child.X, dw_child.Y)
iw_flow_page.post wf_set_movable(true)

this.post event ue_postopen(ls_arg)
//
//gnv_Help = Create nvo_bubblehelp
//
//gnv_help.iw_parent = this
//
end event

event closequery;// override
gnv_help.is_chk = 'N'
gnv_help.is_message = ''
return iw_flow_page.wf_save_query(true)

end event

type dw_insert from w_inherite`dw_insert within w_voda_flow_activity
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

type p_delrow from w_inherite`p_delrow within w_voda_flow_activity
event ue_enable ( boolean ab_flag )
boolean visible = false
integer x = 2670
integer y = 20
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

type p_addrow from w_inherite`p_addrow within w_voda_flow_activity
event ue_enable ( boolean ab_flag )
boolean visible = false
integer x = 3904
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

event p_addrow::clicked;call super::clicked;//string ls_arg
//string ls_proj_code
//int li_proj_seq
//long ll_row
//	
//if iw_flow_gateway.wf_is_empty() = false then return
//if dw_master.rowcount() <= 0 then return
//ll_row = dw_master.getrow()
//if ll_row <= 0 then return
//
//ls_arg = dw_master.getitemstring(ll_row, 'proj_code') + '~n' + string(dw_master.getitemnumber(ll_row, 'proj_seq'))
//openwithparm(w_wflow_excel_import, ls_arg)
//
//if Message.DoubleParm > 0 then
//	iw_flow_gateway.dynamic wf_retrieve_page(ls_arg)
//	iw_flow_activity.dynamic wf_reset_page()
//	iw_flow_activity_sub.dynamic wf_reset_page()
//end if
//
end event

type p_search from w_inherite`p_search within w_voda_flow_activity
boolean visible = false
integer x = 2226
integer y = 52
string picturename = "C:\erpman\image\연결_up.gif"
end type

event p_search::clicked;iw_flow_page.dynamic wf_set_mode_add_line()

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\연결_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\연결_up.gif"
end event

type p_ins from w_inherite`p_ins within w_voda_flow_activity
boolean visible = false
integer x = 2085
integer y = 204
integer width = 302
integer height = 204
string picturename = "C:\erpman\image\ZOOM_up.gif"
end type

event p_ins::clicked;//if dw_master.getrow() > 0 then
//	if iw_flow_activity_sub.wf_save_query(true) > 0 then
//		return
//	end if
//end if
//
//iw_flow_gateway.dynamic wf_set_zoomout()
//iw_flow_activity.dynamic wf_set_zoomout()
//iw_flow_activity_sub.dynamic wf_set_zoomout()
//
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\zoom_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\zoom_up.gif"
end event

type p_exit from w_inherite`p_exit within w_voda_flow_activity
integer y = 28
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_voda_flow_activity
boolean visible = false
integer x = 2880
integer y = 36
string picturename = "C:\erpman\image\새개체_up.gif"
end type

event p_can::clicked;iw_flow_page.dynamic wf_set_mode_add_box()

end event

event p_can::ue_lbuttondown;PictureName = "C:\erpman\image\새개체_dn.gif"
end event

event p_can::ue_lbuttonup;PictureName = "C:\erpman\image\새개체_up.gif"
end event

type p_print from w_inherite`p_print within w_voda_flow_activity
integer x = 4270
integer y = 28
end type

event p_print::clicked;call super::clicked;//iw_flow_page.dynamic wf_print_create_page()
//
//// 미리보기
//OpenWithParm(w_flow_preview, iw_flow_page.dw_print)

//// 출력
//if iw_flow_page.dw_print.rowcount() > 0 then
//	gi_page = iw_flow_page.dw_print.GetItemNumber(1, 'last_page')
//else
//	gi_page = 1
//end if
//OpenWithParm(w_print_options, iw_flow_page.dw_print)

end event

type p_inq from w_inherite`p_inq within w_voda_flow_activity
integer x = 3575
integer y = 28
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

gs_code = ls_proj_code 

iw_flow_page.dynamic wf_retrieve()
end event

type p_del from w_inherite`p_del within w_voda_flow_activity
integer x = 3749
integer y = 28
end type

event p_del::clicked;call super::clicked;String ls_proj_code , ls_proj_file[10]
Long 	 ll_count, ll_i, ll_i2, ll_return
Datastore lds_flow_file_chk

ls_proj_code = dw_insert.object.proj_code[1]

select count(proj_code) 
  into :ll_count 
  from flow_project 
 where proj_code = :ls_proj_code ; 

if sqlca.sqlcode <> 0 then 
	Messagebox('확인', '삭제하고자 한 프로젝트를 선택하십시오') 
	Return 
End if 

lds_flow_file_chk = create datastore 
lds_flow_file_chk.dataobject = 'd_voda_proj_file'
lds_flow_file_chk.settransobject(sqlca)

ll_return = Messagebox('확인', '[프로젝트 No : ' + ls_proj_code + ' ]를 삭제하시겠습니까?', Exclamation!, Okcancel!,2) 
if ll_return = 2 then return 

ll_return = Messagebox('확인', '[프로젝트 No : ' + ls_proj_code + ' ]가 삭제됩니다.~n진행하시겠습니까?', Exclamation!, Okcancel!,2) 
if ll_return = 2 then return 

//프로젝트 리트리브
ll_return = lds_flow_file_chk.retrieve(ls_proj_code,1,1) 

if ll_return > 0 then  
	
	For ll_i = 1 to ll_return 
		 ls_proj_file[1] = lds_flow_file_chk.object.product_file1[ll_i]
		 ls_proj_file[2] = lds_flow_file_chk.object.product_file2[ll_i]
		 ls_proj_file[3] = lds_flow_file_chk.object.product_file3[ll_i]
		 ls_proj_file[4] = lds_flow_file_chk.object.product_file4[ll_i]
		 ls_proj_file[5] = lds_flow_file_chk.object.product_file5[ll_i]
		 ls_proj_file[6] = lds_flow_file_chk.object.Attach_file1[ll_i]
		 ls_proj_file[7] = lds_flow_file_chk.object.Attach_file2[ll_i]
		 ls_proj_file[8] = lds_flow_file_chk.object.Attach_file3[ll_i]
		 ls_proj_file[9] = lds_flow_file_chk.object.Attach_file4[ll_i]
		 ls_proj_file[10] = lds_flow_file_chk.object.Attach_file5[ll_i]
		 
		 //파일 등록 유무체크 
		 for ll_i2 = 1 to 10 
			if trim(ls_proj_file[ll_i2]) <> '' and isnull(ls_proj_file[ll_i2]) = false then 
				Messagebox('확인', '[프로젝트 No : ' + ls_proj_code + ' ] 해당 프로젝트에 이미 산출물이 등록되어 있습니다. ~n 해당 프로젝트를 삭제 하기위해서는 등록된 산출물 정보를 먼저 삭제해야 합니다.' ) 
				Return
			End if 
 			
		 Next 
	Next 

End if


//하위레벨부터
Delete from FLOW_ACTIVITY_BLOB where proj_code = :ls_proj_code ; 
Delete from Flow_Activity where proj_code = :ls_proj_code ; 
Delete from Flow_gateway where proj_code = :ls_proj_code ; 
Delete from Flow_proj_detail where proj_code = :ls_proj_code ; 
Delete from Flow_Project where proj_code = :ls_proj_code ; 

Commit using sqlca; 

//Page Reset
dw_insert.object.proj_code[1] = '' 
dw_insert.object.proj_name[1] = '' 

iw_flow_page.dynamic wf_reset_page()
Messagebox('확인', '[프로젝트 No : ' + ls_proj_code + ' ] 삭제완료!')

end event

type p_mod from w_inherite`p_mod within w_voda_flow_activity
integer x = 4096
integer y = 28
end type

event p_mod::clicked;call super::clicked;iw_flow_page.dynamic wf_save()

dw_insert.object.proj_code[1] = gs_code 
dw_insert.object.proj_name[1] = gs_codename 

update flow_project 
  set proj_name = :gs_codename 
 where proj_code = :gs_code ; 
 
if sqlca.sqlcode <> 0 then 
	 messagebox('에러', sqlca.sqlerrtext ) 
end if 

COMMIT USING SQLCA; 

SetNull(gs_code)
SetNull(gs_codename)

p_inq.triggerevent('clicked')
end event

type cb_exit from w_inherite`cb_exit within w_voda_flow_activity
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_voda_flow_activity
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_voda_flow_activity
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_voda_flow_activity
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_voda_flow_activity
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_voda_flow_activity
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_voda_flow_activity
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_voda_flow_activity
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_voda_flow_activity
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_voda_flow_activity
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_voda_flow_activity
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_voda_flow_activity
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_voda_flow_activity
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_voda_flow_activity
boolean visible = true
end type

type rr_1 from roundrectangle within w_voda_flow_activity
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

type dw_master from datawindow within w_voda_flow_activity
boolean visible = false
integer x = 1234
integer y = 472
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

event rowfocuschanged;//string ls_arg
//string ls_proj_code
//int li_proj_seq
//
//if currentrow <= 0 then return
//
//this.SelectRow(0, false)
//this.SelectRow(currentrow, true)
//
//dw_master_select.ScrollToRow(currentrow)
//
//ls_arg = getitemstring(currentrow, 'proj_code') + '~n' + string(getitemnumber(currentrow, 'proj_seq'))
//iw_flow_gateway.wf_retrieve_page(ls_arg)
//iw_flow_activity.wf_reset_page()
//iw_flow_activity_sub.wf_reset_page()
//
//// 엑셀변환 버튼 활성/비활성
//if iw_flow_gateway.wf_is_empty() then
//	p_addrow.event ue_enable(true)
//	p_delrow.event ue_enable(false)
//else
//	p_addrow.event ue_enable(false)
//	p_delrow.event ue_enable(true)
//end if
//
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
//	iw_flow_gateway.dynamic wf_reset_page()
	iw_flow_activity.dynamic wf_reset_page()
//	iw_flow_activity_sub.dynamic wf_reset_page()
end if

end event

event losefocus;dw_master.visible = false

end event

event clicked;dw_master.visible = false

end event

event retrievestart;il_retrieve_priorrow = this.getrow()

end event

type dw_master_select from datawindow within w_voda_flow_activity
boolean visible = false
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

type dw_legend from datawindow within w_voda_flow_activity
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

type p_1 from picture within w_voda_flow_activity
integer x = 3922
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\조정_up.gif"
boolean focusrectangle = false
end type

event clicked;string ls_proj_code
//
iw_flow_page.dynamic wf_insert()

ls_proj_code = dw_insert.GetItemString(1, 'proj_code')
if ls_proj_code = '' or isnull(ls_proj_code) then return

dw_master.Retrieve(ls_proj_code)

gs_code = ls_proj_code 

iw_flow_page.dynamic wf_retrieve()

end event

type p_3 from picture within w_voda_flow_activity
event ue_b_up pbm_lbuttonup
event ue_b_dn pbm_lbuttondown
integer x = 3278
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event clicked;Long ll_return , ll_i, ll_i2, ll_seq, ll_i3
string ls_max_proj_code, ls_yyyymmdd, ls_proj_code, ls_string, ls_activity_name, ls_file[10], ls_deptcode, ls_deptname, ls_co_deptcode, ls_co_deptname
String ls_co_deptcode2, ls_co_deptname2, ls_co_deptcode3, ls_co_deptname3
//string ls_file1, ls_file2, ls_file3, ls_file4, ls_file5, ls_file6, ls_file7, ls_file8, ls_file9, ls_file10

ll_return = messagebox('확인', '신규 프로젝트를 생성하시겠습니까?', exclamation!, okcancel!, 2) 

if ll_return = 2 then return 

//Process 선택
setnull(gs_code)
open(w_voda_activity_popup3)
if gs_code = '' or isNull(gs_code) then return

ls_yyyymmdd = Left(f_today(),6)
ls_string = ls_yyyymmdd + '%' 

//오늘 일자로 생성된 Project code가 있는 지를 조회
select max(proj_code) 
  into :ls_max_proj_code
  from flow_project
 where proj_code like :ls_string ;
 
 if trim(ls_max_proj_code) = '' or isnull(ls_max_proj_code) then 
	 ls_proj_code = ls_yyyymmdd + '001'
 else 
	ls_proj_code = string(long(ls_max_proj_code) + 1,'000') 
 end if 	
 



//Project 
insert into flow_project (PROJ_CODE)
 values ( :ls_proj_code) ; 

if sqlca.sqlcode <> 0 then 
 	Messagebox('Project', sqlca.sqlerrtext)
	Rollback; 
	return 
end if 
 
 
//project Detail 
//insert into flow_proj_detail (PROJ_CODE, proj_seq, s_date, e_date)
// values ( :ls_proj_code, 1, sysdate, sysdate + 30) ;
insert into flow_proj_detail (PROJ_CODE, proj_seq)
 values ( :ls_proj_code, 1) ;

if sqlca.sqlcode <> 0 then 
 	Messagebox('Project_Detail', sqlca.sqlerrtext)
	Rollback; 
	 return 
end if 

//Gateway
insert into flow_gateway (PROJ_CODE, proj_seq, gateway_seq)
 values ( :ls_proj_code, 1, 1) ;

if sqlca.sqlcode <> 0 then 
 	Messagebox('Gateway', sqlca.sqlerrtext)
	Rollback; 
	 return 
end if 

//ACTIVITY
dw_proj.settransobject(sqlca) 
dw_proj_file.settransobject(sqlca) 

ll_return = dw_proj.retrieve(gs_code) 
if ll_return < 1 then 
	messagebox('확인', '프로젝트 코드등록이 먼저 진행되어야 합니다.')
	Rollback; 
	return
end if 

For ll_i = 1 to dw_proj.rowcount() 
	 ll_seq  = dw_proj.object.seq[ll_i]
    ls_activity_name =    dw_proj.object.activity_name[ll_i]
	 ls_deptcode = dw_proj.object.deptcode[ll_i]
	 ls_deptname = dw_proj.object.deptname[ll_i]
	 ls_co_deptcode = dw_proj.object.co_deptcode[ll_i]
	 ls_co_deptname = dw_proj.object.co_deptname[ll_i]
	 ls_co_deptcode2 = dw_proj.object.co_deptcode2[ll_i]
	 ls_co_deptname2 = dw_proj.object.co_deptname2[ll_i]
	 ls_co_deptcode3 = dw_proj.object.co_deptcode3[ll_i]
	 ls_co_deptname3 = dw_proj.object.co_deptname3[ll_i]
	 
	 //파일명 가지고 오기 
	 ll_return = dw_proj_file.retrieve(gs_code, ll_seq)
	 if ll_return > 0 then 
	 	 For ll_i2 = 1 to ll_return
			  ls_file[ll_i2] = dw_proj_file.object.file_name[ll_i2]
		 Next
	 else 
		
	 end if 	
	 
	 //파일 10개만 값 채워주기
	 For ll_i3 = 1 to 10
		 if trim(ls_file[ll_i3]) = '' or isnull(ls_file[ll_i3]) then 
			 ls_file[ll_i3] = ' ' 
		 end if 
	 Next 
	
	//인서트
	insert into flow_activity (PROJ_CODE, 		PROJ_SEQ, 			GATEWAY_SEQ, 	ACTIVITY_SEQ,		DISPLAY_SEQ, 		ACTIVITY_NAME,
										deptcode, 		deptname, 		co_deptcode, 		co_deptname, 		co_deptcode2, 		co_deptname2, 			co_deptcode3, 		co_deptname3)
 	values 						 ( :ls_proj_code, 1, 					1,					:ll_i, 				:ll_i,		 		:ls_activity_name,  
	 									:ls_deptcode,	:ls_deptname,	:ls_co_deptcode,	:ls_co_deptname ,	:ls_co_deptcode2,	:ls_co_deptname2 ,	:ls_co_deptcode3,	:ls_co_deptname3 ) ;
	
	if sqlca.sqlcode <> 0 then 
 		Messagebox('Activity_Insert', sqlca.sqlerrtext)
		Rollback; 
	 	return 
	end if 
	
	update flow_activity
	  set PRODUCT_FILE1 = :ls_file[1], 
			PRODUCT_FILE2 = :ls_file[2], 
			PRODUCT_FILE3 = :ls_file[3], 
			PRODUCT_FILE4 = :ls_file[4], 
			PRODUCT_FILE5 = :ls_file[5], 
			ATTACH_FILE1    = :ls_file[6], 
			ATTACH_FILE2    = :ls_file[7], 
			ATTACH_FILE3    = :ls_file[8], 
			ATTACH_FILE4    = :ls_file[9], 
			ATTACH_FILE5    = :ls_file[10] 
	where PROJ_CODE = :ls_proj_code
	  and PROJ_SEQ  = 1 
	  and GATEWAY_SEQ = 1 
	  and ACTIVITY_SEQ = :ll_i ; 
	
	if sqlca.sqlcode <> 0 then 
 		Messagebox('Activity_Update', sqlca.sqlerrtext)
	 	Rollback; 
		return 
	end if
	 //파일명 삭제
	 For ll_i3 = 1 to 10
		ls_file[ll_i3] = '' 
	 Next
Next 

COMMIT USING SQLCA; 

//
messagebox('확인', '[프로젝트 No : ' + ls_proj_code + ' ] 생성완료!')
//생성된 프로젝트 조회
gs_code = ls_proj_code

dw_insert.object.proj_code[1] = gs_code 
dw_insert.object.proj_name[1] = '' 

p_inq.triggerevent('clicked')
// 
end event

type dw_proj from datawindow within w_voda_flow_activity
boolean visible = false
integer x = 2395
integer y = 284
integer width = 1152
integer height = 400
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_project_code_head"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type dw_proj_file from datawindow within w_voda_flow_activity
boolean visible = false
integer x = 3419
integer y = 676
integer width = 1157
integer height = 400
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_project_code_detail"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

