$PBExportHeader$w_wflow_full_list.srw
$PBExportComments$프로젝트 조회
forward
global type w_wflow_full_list from w_inherite
end type
type rr_1 from roundrectangle within w_wflow_full_list
end type
type dw_master_select from datawindow within w_wflow_full_list
end type
type dw_legend from datawindow within w_wflow_full_list
end type
type dw_detail from datawindow within w_wflow_full_list
end type
type dw_master from datawindow within w_wflow_full_list
end type
end forward

global type w_wflow_full_list from w_inherite
string title = "프로젝트 조회"
event ue_postopen ( string as_arg )
rr_1 rr_1
dw_master_select dw_master_select
dw_legend dw_legend
dw_detail dw_detail
dw_master dw_master
end type
global w_wflow_full_list w_wflow_full_list

type variables
long il_retrieve_priorrow

end variables

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

on w_wflow_full_list.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_master_select=create dw_master_select
this.dw_legend=create dw_legend
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_master_select
this.Control[iCurrent+3]=this.dw_legend
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_master
end on

on w_wflow_full_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_master_select)
destroy(this.dw_legend)
destroy(this.dw_detail)
destroy(this.dw_master)
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
dw_detail.SetTransObject(sqlca)
dw_master_select.SetTransObject(sqlca)
dw_master_select.InsertRow(0)
dw_legend.InsertRow(0)

this.post event ue_postopen(ls_arg)

end event

event closequery;// override

end event

type dw_insert from w_inherite`dw_insert within w_wflow_full_list
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

type p_delrow from w_inherite`p_delrow within w_wflow_full_list
boolean visible = false
integer x = 3506
end type

type p_addrow from w_inherite`p_addrow within w_wflow_full_list
boolean visible = false
integer x = 3328
end type

type p_search from w_inherite`p_search within w_wflow_full_list
boolean visible = false
integer x = 2930
end type

type p_ins from w_inherite`p_ins within w_wflow_full_list
boolean visible = false
integer x = 3877
end type

type p_exit from w_inherite`p_exit within w_wflow_full_list
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_wflow_full_list
boolean visible = false
integer x = 2752
end type

type p_print from w_inherite`p_print within w_wflow_full_list
boolean visible = false
integer x = 4059
end type

type p_inq from w_inherite`p_inq within w_wflow_full_list
integer x = 4251
end type

event p_inq::clicked;string ls_proj_code

if dw_insert.AcceptText() = -1 then return

ls_proj_code = dw_insert.GetItemString(1, 'proj_code')
if ls_proj_code = '' or isnull(ls_proj_code) then return

dw_master.Retrieve(ls_proj_code)

end event

type p_del from w_inherite`p_del within w_wflow_full_list
boolean visible = false
integer x = 3109
end type

type p_mod from w_inherite`p_mod within w_wflow_full_list
boolean visible = false
integer x = 3698
end type

type cb_exit from w_inherite`cb_exit within w_wflow_full_list
end type

type cb_mod from w_inherite`cb_mod within w_wflow_full_list
end type

type cb_ins from w_inherite`cb_ins within w_wflow_full_list
end type

type cb_del from w_inherite`cb_del within w_wflow_full_list
end type

type cb_inq from w_inherite`cb_inq within w_wflow_full_list
end type

type cb_print from w_inherite`cb_print within w_wflow_full_list
end type

type st_1 from w_inherite`st_1 within w_wflow_full_list
end type

type cb_can from w_inherite`cb_can within w_wflow_full_list
end type

type cb_search from w_inherite`cb_search within w_wflow_full_list
end type







type gb_button1 from w_inherite`gb_button1 within w_wflow_full_list
end type

type gb_button2 from w_inherite`gb_button2 within w_wflow_full_list
end type

type rr_1 from roundrectangle within w_wflow_full_list
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

type dw_master_select from datawindow within w_wflow_full_list
integer x = 14
integer y = 188
integer width = 2126
integer height = 252
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project_detail_select_prgss"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;dw_master.visible = true

end event

type dw_legend from datawindow within w_wflow_full_list
integer x = 3287
integer y = 296
integer width = 1326
integer height = 132
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_progress_legend"
boolean border = false
boolean livescroll = true
end type

type dw_detail from datawindow within w_wflow_full_list
event type long ue_retrieve ( )
integer x = 37
integer y = 448
integer width = 4576
integer height = 1808
integer taborder = 140
boolean bringtotop = true
string dataobject = "dm_flow_full_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event type long ue_retrieve();string ls_proj_code
int li_proj_seq
long ll_rc
long ll_row

ll_row = dw_master.getrow()

ls_proj_code = dw_master.getitemstring(ll_row, 'proj_code')
li_proj_seq = dw_master.getitemnumber(ll_row, 'proj_seq')

ll_rc = this.retrieve(ls_proj_code, li_proj_seq)

this.SelectRow(0, FALSE)
this.SelectRow(1, TRUE)

return ll_rc

end event

event rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

end event

type dw_master from datawindow within w_wflow_full_list
boolean visible = false
integer x = 46
integer y = 428
integer width = 1614
integer height = 1128
integer taborder = 130
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

dw_detail.event ue_retrieve()

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
	dw_detail.reset()
end if

end event

event losefocus;dw_master.visible = false

end event

event clicked;dw_master.visible = false

end event

event retrievestart;il_retrieve_priorrow = this.getrow()

end event

