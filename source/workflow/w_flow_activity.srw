$PBExportHeader$w_flow_activity.srw
$PBExportComments$Workflow Activity 콘트롤
forward
global type w_flow_activity from w_flow
end type
end forward

global type w_flow_activity from w_flow
end type
global w_flow_activity w_flow_activity

type variables
string is_proj_code
int ii_proj_seq
int ii_gateway_seq
int ii_gateway_display_seq

end variables

on w_flow_activity.create
call super::create
end on

on w_flow_activity.destroy
call super::destroy
end on

event open;call super::open;is_flow_type = 'activity'
is_default_box_object_name = 'u_box_activity'
is_default_progress_box_object_name = 'u_box_prgss_activity'

is_default_progress_dw_detail = 'dm_flow_activity_prgss'
is_default_progress_dw_remark = 'dm_flow_activity_prgss_remark'

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
int li_activity_seq
long ll_row
int li_x, li_y

auo_box.dw_info.accepttext()

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')
li_activity_seq = auo_box.dw_info.getitemnumber(1, 'activity_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq), 1, dw_box.rowcount())
if ll_row <= 0 then
	ll_row = dw_box.InsertRow(0)
end if

dw_box.object.proj_code[ll_row]     = auo_box.dw_info.getitemstring(1, 'proj_code')
dw_box.object.proj_seq[ll_row]      = auo_box.dw_info.getitemnumber(1, 'proj_seq')
dw_box.object.gateway_seq[ll_row]   = auo_box.dw_info.getitemnumber(1, 'gateway_seq')
dw_box.object.activity_seq[ll_row]  = auo_box.dw_info.getitemnumber(1, 'activity_seq')
dw_box.object.display_seq[ll_row]   = auo_box.dw_info.getitemnumber(1, 'display_seq')
dw_box.object.activity_name[ll_row] = auo_box.dw_info.getitemstring(1, 'activity_name')
//dw_box.object.f_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 'f_date')
//dw_box.object.t_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 't_date')
dw_box.object.prgss_rate[ll_row]    = auo_box.dw_info.getitemnumber(1, 'prgss_rate')
dw_box.object.finish_yn[ll_row]     = auo_box.dw_info.getitemstring(1, 'finish_yn')
dw_box.object.s_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 's_date')
dw_box.object.e_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 'e_date')
dw_box.object.deptcode[ll_row]      = auo_box.dw_info.getitemstring(1, 'deptcode')
dw_box.object.deptname[ll_row]      = auo_box.dw_info.getitemstring(1, 'deptname')
dw_box.object.co_deptcode[ll_row]   = auo_box.dw_info.getitemstring(1, 'co_deptcode')
dw_box.object.co_deptname[ll_row]   = auo_box.dw_info.getitemstring(1, 'co_deptname')

dw_box.object.f_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 'f_date')
dw_box.object.t_date[ll_row]        = auo_box.dw_info.getitemdatetime(1, 't_date')
dw_box.object.remarks[ll_row]       = auo_box.dw_info.getitemstring(1, 'remarks')
dw_box.object.product_file1[ll_row] = auo_box.dw_info.getitemstring(1, 'product_file1')
dw_box.object.product_file2[ll_row] = auo_box.dw_info.getitemstring(1, 'product_file2')
dw_box.object.product_file3[ll_row] = auo_box.dw_info.getitemstring(1, 'product_file3')
dw_box.object.product_file4[ll_row] = auo_box.dw_info.getitemstring(1, 'product_file4')
dw_box.object.product_file5[ll_row] = auo_box.dw_info.getitemstring(1, 'product_file5')
dw_box.object.attach_file1[ll_row]  = auo_box.dw_info.getitemstring(1, 'attach_file1')
dw_box.object.attach_file2[ll_row]  = auo_box.dw_info.getitemstring(1, 'attach_file2')
dw_box.object.attach_file3[ll_row]  = auo_box.dw_info.getitemstring(1, 'attach_file3')
dw_box.object.attach_file4[ll_row]  = auo_box.dw_info.getitemstring(1, 'attach_file4')
dw_box.object.attach_file5[ll_row]  = auo_box.dw_info.getitemstring(1, 'attach_file5')
li_x = auo_box.x
li_y = auo_box.y
wf_calc_pos_orig(li_x, li_y)
dw_box.object.object_x[ll_row] = li_x
dw_box.object.object_y[ll_row] = li_y
dw_box.object.visible[ll_row] = 'Y'

end event

event ue_save_branch;call super::ue_save_branch;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq, li_pre_activity_seq
int li_edge_kind, li_pre_edge_kind
long ll_row
u_box luo_target1, luo_target2

luo_target1 = auo_branch.iuo_target1
luo_target2 = auo_branch.iuo_target2

ls_proj_code = is_proj_code
li_proj_seq = ii_proj_seq
li_gateway_seq = ii_gateway_seq
li_pre_activity_seq = luo_target1.dw_info.getitemnumber(1, 'activity_seq')
li_activity_seq = luo_target2.dw_info.getitemnumber(1, 'activity_seq')
li_pre_edge_kind = auo_branch.ii_target1_edge
li_edge_kind = auo_branch.ii_target2_edge

ll_row = dw_branch.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq) + &
			' and pre_activity_seq = ' + string(li_pre_activity_seq), 1, dw_branch.rowcount())
if ll_row <= 0 then
	ll_row = dw_branch.InsertRow(0)
end if

dw_branch.object.proj_code[ll_row] = ls_proj_code
dw_branch.object.proj_seq[ll_row] = li_proj_seq
dw_branch.object.gateway_seq[ll_row] = li_gateway_seq
dw_branch.object.activity_seq[ll_row] = luo_target2.dw_info.getitemnumber(1, 'activity_seq')
dw_branch.object.pre_activity_seq[ll_row] = luo_target1.dw_info.getitemnumber(1, 'activity_seq')
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
auo_box.dw_info.setitem(1, 'gateway_seq', ii_gateway_seq)
ii_max_seq++
auo_box.dw_info.setitem(1, 'activity_seq', ii_max_seq)

end event

event ue_retrieve_page;call super::ue_retrieve_page;string ls_gateway_display_seq

is_proj_code = f_get_token(as_arg, '~n')
ii_proj_seq = integer(f_get_token(as_arg, '~n'))
ii_gateway_seq = integer(f_get_token(as_arg, '~n'))
ls_gateway_display_seq = f_get_token(as_arg, '~n')
ii_gateway_display_seq = integer(ls_gateway_display_seq)
is_parent_display_seq = ls_gateway_display_seq

dw_summary.retrieve(is_proj_code, ii_proj_seq, ii_gateway_seq)
dw_box.retrieve(is_proj_code, ii_proj_seq, ii_gateway_seq)
dw_branch.retrieve(is_proj_code, ii_proj_seq, ii_gateway_seq)

if dw_box.rowcount() > 0 then
	ii_max_seq = dw_box.getitemdecimal(1, 'max_seq')
else
	ii_max_seq = 0
end if

end event

event ue_retrieve_box;call super::ue_retrieve_box;int li_box
li_box = wf_new_box(dw_box.object.object_x[al_row], dw_box.object.object_y[al_row])

//	wf_retrieve_box(iuo_box[li_box])
//iuo_box[li_box].dw_info.retrieve(dw_box.object.proj_code[al_row], dw_box.object.proj_seq[al_row], dw_box.object.gateway_seq[al_row], dw_box.object.activity_seq[al_row])
iuo_box[li_box].dw_info.insertrow(1)
iuo_box[li_box].dw_info.setitem(1, 'proj_code',     dw_box.object.proj_code[al_row])
iuo_box[li_box].dw_info.setitem(1, 'proj_seq',      dw_box.object.proj_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'gateway_seq',   dw_box.object.gateway_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'activity_seq',  dw_box.object.activity_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'display_seq',   dw_box.object.display_seq[al_row])
iuo_box[li_box].dw_info.setitem(1, 'activity_name', dw_box.object.activity_name[al_row])
//iuo_box[li_box].dw_info.setitem(1, 'f_date',        dw_box.object.f_date[al_row])
//iuo_box[li_box].dw_info.setitem(1, 't_date',        dw_box.object.t_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 'prgss_rate',    dw_box.object.prgss_rate[al_row])
iuo_box[li_box].dw_info.setitem(1, 'finish_yn',     dw_box.object.finish_yn[al_row])
iuo_box[li_box].dw_info.setitem(1, 's_date',        dw_box.object.s_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 'e_date',        dw_box.object.e_date[al_row])
iuo_box[li_box].dw_info.setitem(1, 'deptcode',      dw_box.object.deptcode[al_row])
iuo_box[li_box].dw_info.setitem(1, 'deptname',      dw_box.object.deptname[al_row])
iuo_box[li_box].dw_info.setitem(1, 'co_deptcode',   dw_box.object.co_deptcode[al_row])
iuo_box[li_box].dw_info.setitem(1, 'co_deptname',   dw_box.object.co_deptname[al_row])

iuo_box[li_box].dw_info.setitem(1, 'f_date',        dw_box.object.f_date[al_row]       )
iuo_box[li_box].dw_info.setitem(1, 't_date',        dw_box.object.t_date[al_row]       )
iuo_box[li_box].dw_info.setitem(1, 'remarks',       dw_box.object.remarks[al_row]      )
iuo_box[li_box].dw_info.setitem(1, 'product_file1', dw_box.object.product_file1[al_row])
iuo_box[li_box].dw_info.setitem(1, 'product_file2', dw_box.object.product_file2[al_row])
iuo_box[li_box].dw_info.setitem(1, 'product_file3', dw_box.object.product_file3[al_row])
iuo_box[li_box].dw_info.setitem(1, 'product_file4', dw_box.object.product_file4[al_row])
iuo_box[li_box].dw_info.setitem(1, 'product_file5', dw_box.object.product_file5[al_row])
iuo_box[li_box].dw_info.setitem(1, 'attach_file1',  dw_box.object.attach_file1[al_row] )
iuo_box[li_box].dw_info.setitem(1, 'attach_file2',  dw_box.object.attach_file2[al_row] )
iuo_box[li_box].dw_info.setitem(1, 'attach_file3',  dw_box.object.attach_file3[al_row] )
iuo_box[li_box].dw_info.setitem(1, 'attach_file4',  dw_box.object.attach_file4[al_row] )
iuo_box[li_box].dw_info.setitem(1, 'attach_file5',  dw_box.object.attach_file5[al_row] )

iuo_box[li_box].dw_info.SetItemStatus(1, 0, Primary!, DataModified!)
iuo_box[li_box].dw_info.SetItemStatus(1, 0, Primary!, NotModified!)

iuo_box[li_box].dw_info.event retrieveend(1)

// 진행률 등록시 사용자 부서와 주관부서를 비교해서 다르면 입력불가 설정
if wf_is_progress_mode() then
	if wf_is_dept_member(dw_box.object.deptcode[al_row]) = false then
		iuo_box[li_box].uf_set_readonly(true)
	end if
end if

end event

event ue_retrieve_branch;call super::ue_retrieve_branch;int li_target1, li_target2
int li_branch
int i
u_box luo_target1, luo_target2

li_target1 = dw_branch.object.pre_activity_seq[al_row]
li_target2 = dw_branch.object.activity_seq[al_row]
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

event ue_retrieve_detail;call super::ue_retrieve_detail;dw_detail.retrieve(auo_box.dw_info.object.proj_code[1], auo_box.dw_info.object.proj_seq[1], auo_box.dw_info.object.gateway_seq[1], auo_box.dw_info.object.activity_seq[1])

end event

event ue_retrieve_remark;call super::ue_retrieve_remark;dw_remark.retrieve(auo_box.dw_info.object.proj_code[1], auo_box.dw_info.object.proj_seq[1], auo_box.dw_info.object.gateway_seq[1], auo_box.dw_info.object.activity_seq[1])

end event

event ue_save_remark;call super::ue_save_remark;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq
long ll_row

dw_remark.accepttext()
if dw_remark.modifiedcount() <= 0 then return

ls_proj_code = dw_remark.getitemstring(1, 'proj_code')
li_proj_seq = dw_remark.getitemnumber(1, 'proj_seq')
li_gateway_seq = dw_remark.getitemnumber(1, 'gateway_seq')
li_activity_seq = dw_remark.getitemnumber(1, 'activity_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq), 1, dw_box.rowcount())
if ll_row <= 0 then
	ll_row = dw_box.InsertRow(0)
end if

dw_box.object.proj_code[ll_row]     = dw_remark.getitemstring(1, 'proj_code')
dw_box.object.proj_seq[ll_row]      = dw_remark.getitemnumber(1, 'proj_seq')
dw_box.object.gateway_seq[ll_row]   = dw_remark.getitemnumber(1, 'gateway_seq')
dw_box.object.activity_seq[ll_row]  = dw_remark.getitemnumber(1, 'activity_seq')
dw_box.object.f_date[ll_row]        = dw_remark.getitemdatetime(1, 'f_date')
dw_box.object.t_date[ll_row]        = dw_remark.getitemdatetime(1, 't_date')
dw_box.object.remarks[ll_row]       = dw_remark.getitemstring(1, 'remarks')
dw_box.object.product_file1[ll_row] = dw_remark.getitemstring(1, 'product_file1')
dw_box.object.product_file2[ll_row] = dw_remark.getitemstring(1, 'product_file2')
dw_box.object.product_file3[ll_row] = dw_remark.getitemstring(1, 'product_file3')
dw_box.object.product_file4[ll_row] = dw_remark.getitemstring(1, 'product_file4')
dw_box.object.product_file5[ll_row] = dw_remark.getitemstring(1, 'product_file5')
dw_box.object.attach_file1[ll_row]  = dw_remark.getitemstring(1, 'attach_file1')
dw_box.object.attach_file2[ll_row]  = dw_remark.getitemstring(1, 'attach_file2')
dw_box.object.attach_file3[ll_row]  = dw_remark.getitemstring(1, 'attach_file3')
dw_box.object.attach_file4[ll_row]  = dw_remark.getitemstring(1, 'attach_file4')
dw_box.object.attach_file5[ll_row]  = dw_remark.getitemstring(1, 'attach_file5')

end event

event ue_save_detail;call super::ue_save_detail;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq
long ll_row

dw_detail.accepttext()
if dw_detail.modifiedcount() <= 0 then return

ls_proj_code = dw_detail.getitemstring(1, 'proj_code')
li_proj_seq = dw_detail.getitemnumber(1, 'proj_seq')
li_gateway_seq = dw_detail.getitemnumber(1, 'gateway_seq')
li_activity_seq = dw_detail.getitemnumber(1, 'activity_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq), 1, dw_box.rowcount())
if ll_row <= 0 then
	ll_row = dw_box.InsertRow(0)
end if

dw_box.object.proj_code[ll_row]     = dw_detail.getitemstring(1, 'proj_code')
dw_box.object.proj_seq[ll_row]      = dw_detail.getitemnumber(1, 'proj_seq')
dw_box.object.gateway_seq[ll_row]   = dw_detail.getitemnumber(1, 'gateway_seq')
dw_box.object.activity_seq[ll_row]  = dw_detail.getitemnumber(1, 'activity_seq')
dw_box.object.display_seq[ll_row]   = dw_detail.getitemnumber(1, 'display_seq')
dw_box.object.activity_name[ll_row] = dw_detail.getitemstring(1, 'activity_name')
//dw_box.object.f_date[ll_row]        = dw_detail.getitemdatetime(1, 'f_date')
//dw_box.object.t_date[ll_row]        = dw_detail.getitemdatetime(1, 't_date')
dw_box.object.prgss_rate[ll_row]    = dw_detail.getitemnumber(1, 'prgss_rate')
dw_box.object.finish_yn[ll_row]     = dw_detail.getitemstring(1, 'finish_yn')
dw_box.object.s_date[ll_row]        = dw_detail.getitemdatetime(1, 's_date')
dw_box.object.e_date[ll_row]        = dw_detail.getitemdatetime(1, 'e_date')
dw_box.object.deptcode[ll_row]      = dw_detail.getitemstring(1, 'deptcode')
dw_box.object.deptname[ll_row]      = dw_detail.getitemstring(1, 'deptname')
dw_box.object.co_deptcode[ll_row]   = dw_detail.getitemstring(1, 'co_deptcode')
dw_box.object.co_deptname[ll_row]   = dw_detail.getitemstring(1, 'co_deptname')

end event

event ue_delete_branch;call super::ue_delete_branch;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq, li_pre_activity_seq
long ll_row
u_box luo_target1, luo_target2

luo_target1 = auo_branch.iuo_target1
luo_target2 = auo_branch.iuo_target2

ls_proj_code = is_proj_code
li_proj_seq = ii_proj_seq
li_gateway_seq = ii_gateway_seq
li_pre_activity_seq = luo_target1.dw_info.getitemnumber(1, 'activity_seq')
li_activity_seq = luo_target2.dw_info.getitemnumber(1, 'activity_seq')

ll_row = dw_branch.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq) + &
			' and pre_activity_seq = ' + string(li_pre_activity_seq), 1, dw_branch.rowcount())

if ll_row > 0 then
	dw_branch.deleteRow(ll_row)
end if

end event

event ue_delete_box;call super::ue_delete_box;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq
long ll_row

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')
li_activity_seq = auo_box.dw_info.getitemnumber(1, 'activity_seq')

ll_row = dw_box.find('proj_code = "' + ls_proj_code + &
			'" and proj_seq = ' + string(li_proj_seq) + &
			' and gateway_seq = ' + string(li_gateway_seq) + &
			' and activity_seq = ' + string(li_activity_seq), 1, dw_box.rowcount())

if ll_row > 0 then
	dw_box.deleteRow(ll_row)
end if

end event

event ue_deletequery_box;call super::ue_deletequery_box;string ls_proj_code
int li_proj_seq
int li_gateway_seq
int li_activity_seq
long ll_child_count

ls_proj_code = auo_box.dw_info.getitemstring(1, 'proj_code')
li_proj_seq = auo_box.dw_info.getitemnumber(1, 'proj_seq')
li_gateway_seq = auo_box.dw_info.getitemnumber(1, 'gateway_seq')
li_activity_seq = auo_box.dw_info.getitemnumber(1, 'activity_seq')

  select count(*)
    into :ll_child_count
	 from flow_activity_sub
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq
	  and activity_seq = :li_activity_seq ;

if ll_child_count = 0 then
	return 1
end if

//messagebox('삭제', 'Sub Activity가 존재합니다.~r~n~r~nSub Activity를 먼저 삭제하세요!')
if messagebox('삭제 확인', 'Sub Activity가 존재합니다.~r~n~r~nSub Activity 전체를 삭제하시겠습니까?', question!, yesno!, 1) <> 1 then
	return -1
end if

  delete 
	 from flow_activity_sub_branch
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq
	  and activity_seq = :li_activity_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

  delete 
	 from flow_activity_sub
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq
	  and gateway_seq = :li_gateway_seq
	  and activity_seq = :li_activity_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

return 1

end event

type dw_print from w_flow`dw_print within w_flow_activity
end type

type dw_grid_property from w_flow`dw_grid_property within w_flow_activity
end type

type dw_remark from w_flow`dw_remark within w_flow_activity
boolean visible = true
integer x = 3342
integer y = 324
integer width = 654
integer height = 1588
string dataobject = "dm_flow_activity_remark"
end type

event dw_remark::clicked;string 	ls_column, ls_filepath, ls_proj_code, ls_path
string 	ls_Null
long   	ll_rc
int    	li_proj_seq, li_gateway_seq, li_activity_seq
Integer 	li_fp, li_loops, i, li_complete, li_rc
Long    	ll_new_pos, ll_flen, ll_bytes_read
Blob    	lbb_file_data, lbb_chunk
String  	ls_folder, ls_file_name, ls_file_id, ls_upd_dtms, ls_upd_check
string 	ls_sql 

wstr_parm ls_str_parm

this.accepttext()

SetPointer(HourGlass!)
// 열기 버튼
if dwo.type = 'text' then

	//Project Code
	ls_column = UPPER(dwo.tag)
//	ls_path = "c:\erpman"
	if ls_column = '?' or ls_column = '' then return
	ls_proj_code = THIS.OBJECT.proj_code[1]
	li_proj_seq  = This.object.proj_seq[1] 
	li_gateway_seq = This.object.gateway_seq[1]
	li_activity_seq = This.object.activity_seq[1] 
//	ls_file_name = ls_path + "\" + this.getitemstring(row, ls_column) 
	ls_file_name = this.getitemstring(row, ls_column) 
	if trim(ls_file_name) = '' or isnull(ls_file_name) then return 
	
	if ls_column = 'PRODUCT_FILE1' then 
	
		SELECTBLOB PRODUCT_FILE_BLOB1  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT PRODUCT_FILE1  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

	elseif ls_column = 'PRODUCT_FILE2' then 
	
		SELECTBLOB PRODUCT_FILE_BLOB2  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT PRODUCT_FILE2  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'PRODUCT_FILE3' then 
	
		SELECTBLOB PRODUCT_FILE_BLOB3  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT PRODUCT_FILE3  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'PRODUCT_FILE4' then 
	
		SELECTBLOB PRODUCT_FILE_BLOB4  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT PRODUCT_FILE4  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'PRODUCT_FILE5' then 
	
		SELECTBLOB PRODUCT_FILE_BLOB5  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT PRODUCT_FILE5  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'ATTACH_FILE1' then 
	
		SELECTBLOB ATTACH_FILE_BLOB1  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT ATTACH_FILE1  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'ATTACH_FILE2' then 
	
		SELECTBLOB ATTACH_FILE_BLOB2 
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT ATTACH_FILE2  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'ATTACH_FILE3' then 
	
		SELECTBLOB ATTACH_FILE_BLOB3  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT ATTACH_FILE3  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'ATTACH_FILE4' then 
	
		SELECTBLOB ATTACH_FILE_BLOB4  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;

			  SELECT ATTACH_FILE4  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	elseif ls_column = 'ATTACH_FILE5' then 
	
		SELECTBLOB ATTACH_FILE_BLOB5  
				 into :lbb_file_data 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	

			  SELECT ATTACH_FILE5  
				 into :ls_file_name 
				 From Flow_ACTIVITY_BLOB 
			  where PROJ_CODE  = :ls_proj_code and
					  proj_seq = :li_proj_seq and
					  gateway_seq = :li_gateway_seq and
					  activity_seq = :li_activity_seq ;
	
	End if 
	
		If IsNull(lbb_file_data) Then
			messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
			close(w_getblob)

		End If
		
		IF SQLCA.SQLCode = 0 AND Not IsNull(lbb_file_data) THEN
			li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
	
			ll_new_pos 	= 1
			li_loops 	= 0
			ll_flen 		= 0
	
			IF li_fp = -1 or IsNull(li_fp) then
				messagebox('확인',ls_path + ' Folder가 존재치 않거나 사용중인 자료입니다.')
				close(w_getblob)
			Else
				ll_flen = len(lbb_file_data)
				
				if ll_flen > 32765 then
					if mod(ll_flen,32765) = 0 then
						li_loops = ll_flen / 32765
					else
						li_loops = (ll_flen/32765) + 1
					end if
				else
					li_loops = 1
				end if
	
				if li_loops = 1 then 
					ll_bytes_read = filewrite(li_fp,lbb_file_data)
					Yield()					
//					w_getblob.uo_3d_meter.uf_set_position(100)	
				else
					for i = 1 to li_loops
						if i = li_loops then
							lbb_chunk = blobmid(lbb_file_data,ll_new_pos)
						else
							lbb_chunk = blobmid(lbb_file_data,ll_new_pos,32765)
						end if
						ll_bytes_read = filewrite(li_fp,lbb_chunk)
						ll_new_pos = ll_new_pos + ll_bytes_read
	
						Yield()
						li_complete = ( (32765 * i ) / len(lbb_file_data)) * 100
//						w_getblob.uo_3d_meter.uf_set_position(li_complete)	
					next
						Yield()
//						w_getblob.uo_3d_meter.uf_set_position(100)	
				end if
				
				li_rc = 0 
				
				FileClose(li_fp)
	
				close(w_getblob)
			
			END IF
		END IF
//		
//==[프로그램 실행/다운완료후]
ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
//
	return		
End if 


//////////////////////
SetPointer(HourGlass!)

if this.object.datawindow.readonly = 'yes' then return


if dwo.type = 'button' then
	ls_column = dwo.tag
	if ls_column = '?' or ls_column = '' then return
	if integer(this.Describe(ls_column + ".TabSequence")) = 0 then return
	//if dwo.tag <> 'link_file' then return

	string ls_proj_seq, ls_gateway_seq, ls_activity_seq 
		
	ls_filepath = this.getitemstring(row, ls_column)
	if isnull(ls_filepath) then ls_filepath = ''
	
	ls_str_parm.s_parm[1] = ls_filepath 
	ls_str_parm.s_parm[2] = THIS.OBJECT.proj_code[1]
	ls_str_parm.s_parm[3] = string(THIS.OBJECT.proj_seq[1] )
	ls_str_parm.s_parm[4] = string(This.object.gateway_seq[1] )
	ls_str_parm.s_parm[5] = string(this.object.activity_seq[1] )
	ls_str_parm.s_parm[6] = ls_column 
	
	//
	ls_proj_code = THIS.OBJECT.proj_code[1]
	li_proj_seq  = This.object.proj_seq[1] 
	li_gateway_seq = This.object.gateway_seq[1]
	li_activity_seq = This.object.activity_seq[1] 
   
	
	
	openwithparm(w_wflow_file_copy, ls_str_parm)
	
	if isnull(gs_code) or gs_code = '' then return 
	
	ls_str_parm = message.powerobjectparm
	ls_filepath = ls_str_parm.s_parm[1]
	
	//if Message.StringParm <> '' then
		//ls_filepath = trim(Message.StringParm)
		this.setitem(row, ls_column, ls_filepath)
	//end if
	
	//Dynamic Sql Query
   ls_sql = "       	 update flow_activity " 
	ls_sql = ls_sql + " 	 set " + ls_column + " = '" + ls_filepath + "' " 
   ls_sql = ls_sql + " where proj_code = '" +   ls_proj_code + "'  "  
   ls_sql = ls_sql + "   and proj_seq = to_number('" +   string(li_proj_seq) + "')  "  
   ls_sql = ls_sql + "   and gateway_seq = to_number('" +   string(li_gateway_seq) + "')  "  
   ls_sql = ls_sql + "   and activity_seq = to_number('" +   string(li_activity_seq) + "')  "  

	EXECUTE IMMEDIATE :ls_sql using sqlca ;
	
	commit using sqlca ; 
end if

end event

event dw_remark::itemchanged;call super::itemchanged;string ls_column, ls_proj_code, ls_file_name, ls_blob_str , ls_sql, ls_filepath, ls_org_filename
int 	 li_proj_seq, li_gateway_seq, li_activity_seq
long 	 ll_return 


if upper(dwo.name) = 'PRODUCT_FILE1' OR upper(dwo.name) = 'PRODUCT_FILE2'  OR upper(dwo.name) = 'PRODUCT_FILE3' OR & 
	upper(dwo.name) = 'PRODUCT_FILE4' OR upper(dwo.name) = 'PRODUCT_FILE5'  OR upper(dwo.name) = 'ATTACH_FILE1' OR  & 
	upper(dwo.name) = 'ATTACH_FILE2'  OR upper(dwo.name) = 'ATTACH_FILE3' OR upper(dwo.name) = 'ATTACH_FILE4' OR upper(dwo.name) = 'ATTACH_FILE5' then 
//IF UPPER(dwo.type) = 'COLUMN' then	
	//Project Code
	ls_column = upper(dwo.name)

	if ls_column = '?' or ls_column = '' then return
	ls_proj_code = THIS.OBJECT.proj_code[1]
	li_proj_seq  = This.object.proj_seq[1] 
	li_gateway_seq = This.object.gateway_seq[1]
	li_activity_seq = This.object.activity_seq[1] 
	ls_blob_str     = mid(ls_column, 1, len(ls_column) - 1 ) + "_BLOB" + mid(ls_column, len(ls_column) , 1 )
	ls_org_filename = getitemstring(row, ls_column, primary!, true ) 
	
	//데이타가 삭제되면 데이타 베이스도 삭제
	if data = '' or isnull(data) then
			
			ll_return = MessageBox("확인! ", "저장 데이타명을 삭제하면 해당 데이타가 삭제됩니다. 진행하시겠습니까? " ,  &
			 								Exclamation!, OKCancel!, 1)
			
				IF ll_return = 1 THEN
				
					//BLOB 데이타 삭제	
					ls_sql = "       	 update flow_activity_blob " 
					ls_sql = ls_sql + " 	 set " + ls_column 	+ " = null, "
					ls_sql = ls_sql + " 	     " + ls_blob_str + " = null "
					ls_sql = ls_sql + " where proj_code = '" +   ls_proj_code + "'  "  
					ls_sql = ls_sql + "   and proj_seq = to_number('" +   string(li_proj_seq) + "')  "  
					ls_sql = ls_sql + "   and gateway_seq = to_number('" +   string(li_gateway_seq) + "')  "  
					ls_sql = ls_sql + "   and activity_seq = to_number('" +   string(li_activity_seq) + "')  "  
					
					EXECUTE IMMEDIATE :ls_sql using sqlca ;
			
					//Dynamic Sql Query
					ls_sql = "       	 update flow_activity" 
					ls_sql = ls_sql + " 	 set " + ls_column + " = null " 
					ls_sql = ls_sql + " where proj_code = '" +   ls_proj_code + "'  "  
					ls_sql = ls_sql + "   and proj_seq = to_number('" +   string(li_proj_seq) + "')  "  
					ls_sql = ls_sql + "   and gateway_seq = to_number('" +   string(li_gateway_seq) + "')  "  
					ls_sql = ls_sql + "   and activity_seq = to_number('" +   string(li_activity_seq) + "')  "  
					
					EXECUTE IMMEDIATE :ls_sql using sqlca ;
		
					commit using sqlca ; 
				
				ELSE
					this.setitem ( row, ls_column ,ls_org_filename )
					return 1
				END IF

	end if 
	
	ls_file_name = this.getitemstring(row, ls_column)
	if trim(ls_file_name) = '' or isnull(ls_file_name) then return 

end if 

end event

event dw_remark::itemerror;call super::itemerror;RETURN 1
end event

type st_box_white_6 from w_flow`st_box_white_6 within w_flow_activity
end type

type st_box_white_5 from w_flow`st_box_white_5 within w_flow_activity
end type

type st_box_white_7 from w_flow`st_box_white_7 within w_flow_activity
end type

type st_box_white_8 from w_flow`st_box_white_8 within w_flow_activity
end type

type st_box_white_4 from w_flow`st_box_white_4 within w_flow_activity
end type

type st_box_white_3 from w_flow`st_box_white_3 within w_flow_activity
end type

type st_box_white_1 from w_flow`st_box_white_1 within w_flow_activity
end type

type st_box_white_2 from w_flow`st_box_white_2 within w_flow_activity
end type

type dw_branch_property from w_flow`dw_branch_property within w_flow_activity
end type

type st_box_red_2 from w_flow`st_box_red_2 within w_flow_activity
end type

type dw_detail from w_flow`dw_detail within w_flow_activity
integer width = 654
integer height = 592
string dataobject = "dm_flow_activity_info"
end type

type dw_branch from w_flow`dw_branch within w_flow_activity
string dataobject = "dm_flow_activity_branch"
end type

type dw_box from w_flow`dw_box within w_flow_activity
string dataobject = "dm_flow_activity"
end type

type st_box_red_1 from w_flow`st_box_red_1 within w_flow_activity
end type

type dw_summary from w_flow`dw_summary within w_flow_activity
integer width = 3415
string dataobject = "dm_flow_activity_summary"
end type

