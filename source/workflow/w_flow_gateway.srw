$PBExportHeader$w_flow_gateway.srw
$PBExportComments$Workflow Gateway 콘트롤
forward
global type w_flow_gateway from w_flow
end type
end forward

global type w_flow_gateway from w_flow
end type
global w_flow_gateway w_flow_gateway

type variables
string is_proj_code
int ii_proj_seq

end variables

on w_flow_gateway.create
call super::create
end on

on w_flow_gateway.destroy
call super::destroy
end on

event open;call super::open;is_flow_type = 'gateway'
is_default_box_object_name = 'u_box_gateway'
is_default_progress_box_object_name = 'u_box_prgss_gateway'

is_default_progress_dw_detail = 'dm_flow_gateway_prgss'
is_default_progress_dw_remark = 'dm_flow_gateway_prgss_remark'

wf_set_progress_mode(false)

end event

event ue_child_data_changed;call super::ue_child_data_changed;if isvalid(iuo_select_box) then
//	if not ib_progress_mode then
		iuo_select_box.dw_info.setitem(1, 'f_date', adt_f_date)
		iuo_select_box.dw_info.setitem(1, 't_date', adt_t_date)
//	else
		iuo_select_box.dw_info.setitem(1, 'finish_yn', as_finish_yn)
		iuo_select_box.dw_info.setitem(1, 'prgss_rate', ad_prgss_rate)
		iuo_select_box.dw_info.setitem(1, 's_date', adt_s_date)
		iuo_select_box.dw_info.setitem(1, 'e_date', adt_e_date)
//	end if

	ib_changed = true
end if

end event

event ue_save_box;call super::ue_save_box;string ls_proj_code
int li_proj_seq
int li_gateway_seq
long ll_row
int li_x, li_y

auo_box.dw_info.accepttext()

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq), 1, dw_box.rowcount())
if ll_row <= 0 then
	ll_row = dw_box.InsertRow(0)
end if

dw_box.object.proj_code[ll_row]    = auo_box.dw_info.getitemstring(1, 'proj_code')
dw_box.object.proj_seq[ll_row]     = auo_box.dw_info.getitemnumber(1, 'proj_seq')
dw_box.object.gateway_seq[ll_row]  = auo_box.dw_info.getitemnumber(1, 'gateway_seq')
dw_box.object.display_seq[ll_row]  = auo_box.dw_info.getitemnumber(1, 'display_seq')
dw_box.object.gateway_name[ll_row] = auo_box.dw_info.getitemstring(1, 'gateway_name')
dw_box.object.f_date[ll_row]       = auo_box.dw_info.getitemdatetime(1, 'f_date')
dw_box.object.t_date[ll_row]       = auo_box.dw_info.getitemdatetime(1, 't_date')
dw_box.object.prgss_rate[ll_row]   = auo_box.dw_info.getitemnumber(1, 'prgss_rate')
dw_box.object.finish_yn[ll_row]    = auo_box.dw_info.getitemstring(1, 'finish_yn')
dw_box.object.s_date[ll_row]       = auo_box.dw_info.getitemdatetime(1, 's_date')
dw_box.object.e_date[ll_row]       = auo_box.dw_info.getitemdatetime(1, 'e_date')

dw_box.object.remarks[ll_row]      = auo_box.dw_info.getitemstring(1, 'remarks')
li_x = auo_box.x
li_y = auo_box.y
wf_calc_pos_orig(li_x, li_y)
dw_box.object.object_x[ll_row] = li_x
dw_box.object.object_y[ll_row] = li_y
dw_box.object.visible[ll_row] = 'Y'

end event

event ue_save_branch;call super::ue_save_branch;string ls_proj_code
int li_proj_seq
int li_gateway_seq, li_pre_gateway_seq
int li_edge_kind, li_pre_edge_kind
long ll_row
u_box luo_target1, luo_target2

luo_target1 = auo_branch.iuo_target1
luo_target2 = auo_branch.iuo_target2

ls_proj_code = is_proj_code
li_proj_seq = ii_proj_seq
li_pre_gateway_seq = luo_target1.dw_info.getitemnumber(1, 'gateway_seq')
li_gateway_seq = luo_target2.dw_info.getitemnumber(1, 'gateway_seq')
li_pre_edge_kind = auo_branch.ii_target1_edge
li_edge_kind = auo_branch.ii_target2_edge

ll_row = dw_branch.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and pre_gateway_seq = ' + string(li_pre_gateway_seq), 1, dw_branch.rowcount())
if ll_row <= 0 then
	ll_row = dw_branch.InsertRow(0)
end if

dw_branch.object.proj_code[ll_row] = ls_proj_code
dw_branch.object.proj_seq[ll_row] = li_proj_seq
dw_branch.object.gateway_seq[ll_row] = luo_target2.dw_info.getitemnumber(1, 'gateway_seq')
dw_branch.object.pre_gateway_seq[ll_row] = luo_target1.dw_info.getitemnumber(1, 'gateway_seq')
dw_branch.object.edge_kind[ll_row] = auo_branch.ii_target2_edge
dw_branch.object.pre_edge_kind[ll_row] = auo_branch.ii_target1_edge
if auo_branch.ie_line_style = dot! then
	dw_branch.object.line_style[ll_row] = 'D'
else
	dw_branch.object.line_style[ll_row] = 'C'
end if
dw_branch.object.line_thick[ll_row] = auo_branch.ii_line_thickness
dw_branch.object.line_color[ll_row] = auo_branch.il_line_color

end event

event ue_add_box;call super::ue_add_box;auo_box.dw_info.setitem(1, 'proj_code', is_proj_code)
auo_box.dw_info.setitem(1, 'proj_seq', ii_proj_seq)
ii_max_seq++
auo_box.dw_info.setitem(1, 'gateway_seq', ii_max_seq)

end event

event ue_retrieve_page;call super::ue_retrieve_page;is_proj_code = f_get_token(as_arg, '~n')
ii_proj_seq = integer(f_get_token(as_arg, '~n'))
is_parent_display_seq = ''

dw_summary.retrieve(is_proj_code, ii_proj_seq)
dw_box.retrieve(is_proj_code, ii_proj_seq)
dw_branch.retrieve(is_proj_code, ii_proj_seq)

if dw_box.rowcount() > 0 then
	ii_max_seq = dw_box.getitemdecimal(1, 'max_seq')
else
	ii_max_seq = 0
end if

end event

event ue_retrieve_box;call super::ue_retrieve_box;int li_box
li_box = wf_new_box(dw_box.object.object_x[al_row], dw_box.object.object_y[al_row])

//	wf_retrieve_box(iuo_box[li_box])
//iuo_box[li_box].dw_info.retrieve(dw_box.object.proj_code[al_row], dw_box.object.proj_seq[al_row], dw_box.object.gateway_seq[al_row])
iuo_box[li_box].dw_info.insertrow(1)
iuo_box[li_box].dw_info.setitem(1, 'proj_code',    dw_box.object.proj_code[al_row])
iuo_box[li_box].dw_info.setitem(1, 'proj_seq',     dw_box.object.proj_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'gateway_seq',  dw_box.object.gateway_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'display_seq',  dw_box.object.display_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'gateway_name', dw_box.object.gateway_name[al_row])
iuo_box[li_box].dw_info.setitem(1, 'f_date',       dw_box.object.f_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 't_date',       dw_box.object.t_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 'prgss_rate',   dw_box.object.prgss_rate[al_row])
iuo_box[li_box].dw_info.setitem(1, 'finish_yn',    dw_box.object.finish_yn[al_row])
iuo_box[li_box].dw_info.setitem(1, 's_date',       dw_box.object.s_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 'e_date',       dw_box.object.e_date[al_row])

iuo_box[li_box].dw_info.setitem(1, 'remarks',      dw_box.object.remarks[al_row]      )
//dw_box.rowscopy(al_row, al_row, Primary!, iuo_box[li_box].dw_info, 1, Primary!)

iuo_box[li_box].dw_info.SetItemStatus(1, 0, Primary!, DataModified!)
iuo_box[li_box].dw_info.SetItemStatus(1, 0, Primary!, NotModified!)

iuo_box[li_box].dw_info.event retrieveend(1)

// 진행률 등록시 사용자 부서와 주관부서를 비교해서 다르면 입력불가 설정
// gateway 는 주관부서 없음..

end event

event ue_retrieve_branch;call super::ue_retrieve_branch;int li_target1, li_target2
int li_branch
int i
u_box luo_target1, luo_target2

li_target1 = dw_branch.object.pre_gateway_seq[al_row]
li_target2 = dw_branch.object.gateway_seq[al_row]
for i = 1 to ii_box_count
	if iuo_box[i].uf_get_seq() = li_target1 then
		luo_target1 = iuo_box[i]
		exit
	end if
next

for i = 1 to ii_box_count
	if iuo_box[i].uf_get_seq() = li_target2 then
		luo_target2 = iuo_box[i]
		exit
	end if
next

if not isvalid(luo_target2) or not isvalid(luo_target2) then
	messagebox('오류', '연결 설정이 잘못된 자료가 있습니다.~r~n삭제 했습니다.')
	//dw_branch.deleterow(al_row)
	return
end if

li_branch = wf_bridge_line(luo_target1, dw_branch.object.pre_edge_kind[al_row], luo_target2, dw_branch.object.edge_kind[al_row])
iuo_branch[li_branch].ii_line_thickness = dw_branch.object.line_thick[al_row]
iuo_branch[li_branch].il_line_color = dw_branch.object.line_color[al_row]
if dw_branch.object.line_style[al_row] = 'D' then
	iuo_branch[li_branch].ie_line_style = dot!
else
	iuo_branch[li_branch].ie_line_style = continuous!
end if
iuo_branch[li_branch].uf_redraw()

end event

event ue_retrieve_detail;call super::ue_retrieve_detail;dw_detail.retrieve(auo_box.dw_info.object.proj_code[1], auo_box.dw_info.object.proj_seq[1], auo_box.dw_info.object.gateway_seq[1])

end event

event ue_retrieve_remark;call super::ue_retrieve_remark;dw_remark.retrieve(auo_box.dw_info.object.proj_code[1], auo_box.dw_info.object.proj_seq[1], auo_box.dw_info.object.gateway_seq[1])

end event

event ue_delete_branch;call super::ue_delete_branch;string ls_proj_code
int li_proj_seq
int li_gateway_seq, li_pre_gateway_seq
long ll_row
u_box luo_target1, luo_target2

luo_target1 = auo_branch.iuo_target1
luo_target2 = auo_branch.iuo_target2

ls_proj_code = is_proj_code
li_proj_seq = ii_proj_seq
li_pre_gateway_seq = luo_target1.dw_info.getitemnumber(1, 'gateway_seq')
li_gateway_seq = luo_target2.dw_info.getitemnumber(1, 'gateway_seq')

ll_row = dw_branch.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and pre_gateway_seq = ' + string(li_pre_gateway_seq), 1, dw_branch.rowcount())

if ll_row > 0 then
	dw_branch.deleteRow(ll_row)
end if

end event

event ue_delete_box;call super::ue_delete_box;string ls_proj_code
int li_proj_seq
int li_gateway_seq
long ll_row

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq), 1, dw_box.rowcount())

if ll_row > 0 then
	dw_box.deleteRow(ll_row)
end if

end event

event ue_deletequery_box;call super::ue_deletequery_box;string ls_proj_code
int li_proj_seq
int li_gateway_seq
long ll_child_count

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')

  select count(*)
    into :ll_child_count
	 from flow_activity
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq ;

if ll_child_count = 0 then
	return 1
end if

//messagebox('삭제', 'Activity가 존재합니다.~r~n~r~nActivity를 먼저 삭제하세요!')
if messagebox('삭제 확인', 'Activity가 존재합니다.~r~n~r~nActivity 전체를 삭제하시겠습니까?', question!, yesno!, 1) <> 1 then
	return -1
end if

  delete 
	 from flow_activity_sub_branch
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

  delete 
	 from flow_activity_sub
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

  delete 
	 from flow_activity_branch
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

  delete 
	 from flow_activity
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

return 1

end event

type dw_print from w_flow`dw_print within w_flow_gateway
end type

type dw_grid_property from w_flow`dw_grid_property within w_flow_gateway
end type

type dw_remark from w_flow`dw_remark within w_flow_gateway
integer width = 654
integer height = 696
string dataobject = "dm_flow_gateway_remark"
end type

type st_box_white_6 from w_flow`st_box_white_6 within w_flow_gateway
end type

type st_box_white_5 from w_flow`st_box_white_5 within w_flow_gateway
end type

type st_box_white_7 from w_flow`st_box_white_7 within w_flow_gateway
end type

type st_box_white_8 from w_flow`st_box_white_8 within w_flow_gateway
end type

type st_box_white_4 from w_flow`st_box_white_4 within w_flow_gateway
end type

type st_box_white_3 from w_flow`st_box_white_3 within w_flow_gateway
end type

type st_box_white_1 from w_flow`st_box_white_1 within w_flow_gateway
end type

type st_box_white_2 from w_flow`st_box_white_2 within w_flow_gateway
end type

type dw_branch_property from w_flow`dw_branch_property within w_flow_gateway
end type

type st_box_red_2 from w_flow`st_box_red_2 within w_flow_gateway
end type

type dw_detail from w_flow`dw_detail within w_flow_gateway
integer width = 654
integer height = 584
string dataobject = "dm_flow_gateway_info"
end type

type dw_branch from w_flow`dw_branch within w_flow_gateway
string dataobject = "dm_flow_gateway_branch"
end type

type dw_box from w_flow`dw_box within w_flow_gateway
string dataobject = "dm_flow_gateway"
end type

type st_box_red_1 from w_flow`st_box_red_1 within w_flow_gateway
end type

type dw_summary from w_flow`dw_summary within w_flow_gateway
integer width = 2505
string dataobject = "dm_flow_gateway_summary"
end type

