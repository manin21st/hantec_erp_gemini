$PBExportHeader$w_flow.srw
$PBExportComments$Workflow 상속 원본
forward
global type w_flow from window
end type
type dw_print from datawindow within w_flow
end type
type dw_grid_property from datawindow within w_flow
end type
type dw_remark from datawindow within w_flow
end type
type st_box_white_6 from statictext within w_flow
end type
type st_box_white_5 from statictext within w_flow
end type
type st_box_white_7 from statictext within w_flow
end type
type st_box_white_8 from statictext within w_flow
end type
type st_box_white_4 from statictext within w_flow
end type
type st_box_white_3 from statictext within w_flow
end type
type st_box_white_1 from statictext within w_flow
end type
type st_box_white_2 from statictext within w_flow
end type
type dw_branch_property from datawindow within w_flow
end type
type st_box_red_2 from statictext within w_flow
end type
type dw_detail from datawindow within w_flow
end type
type dw_branch from datawindow within w_flow
end type
type dw_box from datawindow within w_flow
end type
type st_box_red_1 from statictext within w_flow
end type
type dw_summary from datawindow within w_flow
end type
end forward

global type w_flow from window
integer x = 110
integer y = 272
integer width = 4841
integer height = 2408
boolean hscrollbar = true
boolean vscrollbar = true
windowtype windowtype = child!
long backcolor = 16777215
event ue_add_box ( u_box auo_box )
event ue_save_box ( u_box auo_box )
event ue_retrieve_box ( long al_row )
event ue_save_page ( )
event ue_save_branch ( u_branch auo_branch )
event ue_retrieve_page ( string as_arg )
event ue_retrieve_branch ( long al_row )
event ue_select_box ( u_box auo_box )
event ue_doubleclick_process ( )
event ue_move_box ( )
event ue_retrieve_detail ( u_box auo_box )
event vscroll pbm_vscroll
event hscroll pbm_hscroll
event ue_retrieve_remark ( u_box auo_box )
event ue_save_remark ( )
event ue_save_detail ( )
event ue_delete_box ( u_box auo_box )
event ue_delete_branch ( u_branch auo_branch )
event type integer ue_deletequery_box ( u_box auo_box )
event ue_child_data_changed ( datetime adt_f_date,  datetime adt_t_date,  string as_finish_yn,  decimal ad_prgss_rate,  datetime adt_s_date,  datetime adt_e_date )
dw_print dw_print
dw_grid_property dw_grid_property
dw_remark dw_remark
st_box_white_6 st_box_white_6
st_box_white_5 st_box_white_5
st_box_white_7 st_box_white_7
st_box_white_8 st_box_white_8
st_box_white_4 st_box_white_4
st_box_white_3 st_box_white_3
st_box_white_1 st_box_white_1
st_box_white_2 st_box_white_2
dw_branch_property dw_branch_property
st_box_red_2 st_box_red_2
dw_detail dw_detail
dw_branch dw_branch
dw_box dw_box
st_box_red_1 st_box_red_1
dw_summary dw_summary
end type
global w_flow w_flow

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"

end prototypes

type variables
protected:
constant int MARGIN_X_NORM = 50
constant int MARGIN_Y_NORM = 50
constant int MARGIN_X_ZOOM = MARGIN_X_NORM / 2
constant int MARGIN_Y_ZOOM = 300

constant int UNIT_X_NORM = 200
constant int UNIT_Y_NORM = 20
constant int UNIT_X_ZOOM = UNIT_X_NORM / 2
constant int UNIT_Y_ZOOM = UNIT_Y_NORM / 2

public:
//m_flow_popup	im_popup

boolean ib_movable = true

//////////////////////////////////////////////////////////////////////////////
window iw_parent
window iw_parent_flow

boolean ib_changed = false
boolean ib_zoomout = false

boolean ib_summary_zoomout = false
int ii_summary_width, ii_summary_height

string is_retrieve_arg
string is_parent_display_seq

int ii_max_seq

statictext ist_grid[]
int ii_grid_count
u_grid_line ist_grid_line[]
int ii_grid_line_count

u_box iuo_box[]
u_box iuo_select_box, iuo_null_box
int ii_box_count
u_branch iuo_branch[]
u_branch iuo_select_branch, iuo_null_branch
u_branch iuo_pre_branch
int ii_branch_count

boolean ib_progress_mode = false
boolean ib_readonly = false
string is_flow_type
string is_box_object_name
string is_default_box_object_name
string is_default_progress_box_object_name
string is_default_progress_dw_detail
string is_default_progress_dw_remark

constant integer MODE_SELECT=1				// 선택 대기 상태
constant integer MODE_SELECT_BOX=2			// BOX 선택 상태
constant integer MODE_SELECT_LINE=3			// LINE 선택 상태
constant integer MODE_ADD_BOX=4				// BOX 추가 상태
constant integer MODE_ADD_LINE=5				// LINE 추가 상태

constant integer MODE_SELECT_TARGET1=11	// LINE 추가, 선택1 상태
constant integer MODE_SELECT_TARGET2=12	// LINE 추가, 선택2 상태

constant integer EDGE_TOP=1
constant integer EDGE_LEFT=2
constant integer EDGE_RIGHT=3
constant integer EDGE_BOTTOM=4

integer ii_mode = MODE_SELECT
integer ii_mode_add_line = MODE_SELECT_TARGET1

powerobject	io_target
integer ii_target_edge

end variables

forward prototypes
public function boolean wf_is_changed ()
public function integer wf_set_changed (boolean ab_changetag)
public function integer wf_get_mode ()
public function integer wf_get_mode_add_line ()
public subroutine wf_set_mode_select ()
public subroutine wf_doubleclick_process ()
public subroutine wf_set_target (powerobject ao_target, integer ai_edge)
public subroutine wf_set_mode_add_box ()
public subroutine wf_set_mode_add_line ()
public subroutine wf_set_zoomout ()
public function integer wf_new_box (integer ai_x, integer ai_y)
public subroutine wf_arrange_position (ref integer ai_x, ref integer ai_y)
public subroutine wf_freeze_box ()
public subroutine wf_release_box ()
public subroutine wf_refresh_page ()
public subroutine wf_redraw_page ()
public subroutine wf_set_movable (boolean ab_mode)
public subroutine wf_calc_pos_zoom (ref integer ai_x, ref integer ai_y)
public subroutine wf_set_mode (integer ai_mode)
public subroutine wf_set_mode_select_box (u_box auo_box)
public subroutine wf_set_target_edge (powerobject ao_target, integer ai_edge)
public subroutine wf_show_grid_box ()
public function boolean wf_is_select_mode ()
public subroutine wf_show_detail_float (boolean ab_switch, powerobject ao_target)
public subroutine wf_show_remark_float (boolean ab_switch, powerobject ao_target)
public subroutine wf_delete_select_item ()
public subroutine wf_set_readonly (boolean ab_mode)
public function boolean wf_is_progress_mode ()
public function boolean wf_is_readonly ()
public function integer wf_signature (datawindow adw_target)
public function integer wf_save_query (boolean ab_check_all)
public function integer wf_ismodified (boolean ab_check_all)
public subroutine wf_calc_pos_orig (ref integer ai_x, ref integer ai_y)
public function boolean wf_is_empty ()
public subroutine wf_set_progress_mode (boolean ab_mode)
public subroutine wf_reset_child_page ()
public function integer wf_reset_page ()
public subroutine wf_delete_box (u_box auo_box)
public subroutine wf_delete_line (u_branch auo_branch)
public subroutine wf_show_select_box (boolean ab_switch)
public subroutine wf_retrieve_page (string as_arg)
public subroutine wf_show_grid_line ()
public function integer wf_save_page (boolean ab_check_all)
public subroutine wf_update_parent_progress_info ()
public function boolean wf_is_dept_member (string as_deptcode)
public function integer wf_bridge_line (powerobject ao_target1, integer ai_target1_edge, powerobject ao_target2, integer ai_target2_edge)
public subroutine wf_set_mode_select_line (u_branch auo_branch)
public subroutine wf_add_box ()
public subroutine wf_print_create_page ()
public function string wf_get_seq_arg ()
public subroutine wf_show_remark (boolean ab_switch)
public subroutine wf_show_detail (boolean ab_switch)
public subroutine wf_show_grid_property (boolean ab_switch)
public subroutine wf_show_select_line (boolean ab_switch)
end prototypes

event ue_add_box(u_box auo_box);//

end event

event ue_save_box(u_box auo_box);//

end event

event ue_retrieve_box(long al_row);//

end event

event ue_save_page();//

end event

event ue_save_branch(u_branch auo_branch);//
end event

event ue_retrieve_page(string as_arg);//
end event

event ue_retrieve_branch(long al_row);//

end event

event ue_select_box(u_box auo_box);//
end event

event ue_doubleclick_process();iw_parent.dynamic event ue_flow_doubleclicked(is_flow_type, wf_get_seq_arg())

end event

event ue_move_box();ib_changed = True

end event

event ue_retrieve_detail(u_box auo_target);//
end event

event vscroll;if dw_branch_property.visible and scrollcode = 8 then
	dw_branch_property.y = 0

	wf_show_grid_property(not dw_grid_property.visible)
end if

int i
for i = 1 to ii_grid_line_count
	ist_grid_line[i].y = 0
next

end event

event hscroll;if dw_branch_property.visible and scrollcode = 8 then
	dw_branch_property.x = this.WorkSpaceWidth() - dw_branch_property.width

	wf_show_grid_property(not dw_grid_property.visible)
end if

end event

event ue_retrieve_remark(u_box auo_box);//
end event

event ue_save_remark();//
end event

event ue_save_detail();//
end event

event ue_delete_box(u_box auo_box);//
end event

event ue_delete_branch(u_branch auo_branch);//
end event

event type integer ue_deletequery_box(u_box auo_box);return 1

end event

event ue_child_data_changed(datetime adt_f_date, datetime adt_t_date, string as_finish_yn, decimal ad_prgss_rate, datetime adt_s_date, datetime adt_e_date);//
end event

public function boolean wf_is_changed ();Return ib_changed
end function

public function integer wf_set_changed (boolean ab_changetag);ib_changed = ab_changetag

Return 1
end function

public function integer wf_get_mode ();return ii_mode

end function

public function integer wf_get_mode_add_line ();return ii_mode_add_line

end function

public subroutine wf_set_mode_select ();wf_set_mode(MODE_SELECT)

wf_release_box()

pointer = "arrow!"

end subroutine

public subroutine wf_doubleclick_process ();event ue_doubleclick_process()

end subroutine

public subroutine wf_set_target (powerobject ao_target, integer ai_edge);if ii_mode = MODE_ADD_LINE then
	if ii_mode_add_line = MODE_SELECT_TARGET1 then
		io_target = ao_target
		ii_target_edge = ai_edge
		ii_mode_add_line = MODE_SELECT_TARGET2
	elseif ii_mode_add_line = MODE_SELECT_TARGET2 then
		if iuo_pre_branch.uf_pre_bridge_line(io_target, ii_target_edge, ao_target, ai_edge) < 0 then
			messagebox('확인', '지금 선택하신 연결은 현재 지원되지 않습니다.')
		else
			iuo_pre_branch.uf_reset()
			wf_bridge_line(io_target, ii_target_edge, ao_target, ai_edge)
		end if

		wf_set_mode_select()
	end if
end if

end subroutine

public subroutine wf_set_mode_add_box ();// BOX 추가 상태
wf_set_mode(MODE_ADD_BOX)

wf_freeze_box()
setfocus(this)
pointer = "cross!"

end subroutine

public subroutine wf_set_mode_add_line ();// LINE 추가 상태
wf_set_mode(MODE_ADD_LINE)
ii_mode_add_line = MODE_SELECT_TARGET1

wf_freeze_box()
setfocus(this)
pointer = "cross!"

end subroutine

public subroutine wf_set_zoomout ();ib_zoomout = not ib_zoomout

wf_redraw_page()

end subroutine

public function integer wf_new_box (integer ai_x, integer ai_y);u_box luo_new

wf_calc_pos_zoom(ai_x, ai_y)
wf_arrange_position(ai_x, ai_y)

OpenUserObject(luo_new, is_box_object_name, ai_x, ai_y)
luo_new.iw_parent  = This
luo_new.BringToTop = True
if ib_progress_mode then
	luo_new.DragAuto   = false
else
	luo_new.DragAuto   = True
end if
luo_new.uf_set_zoomout(ib_zoomout)
luo_new.is_parent_display_seq = is_parent_display_seq
luo_new.uf_set_readonly(wf_is_readonly())

ii_box_count++
luo_new.ii_index = ii_box_count
iuo_box[ii_box_count] = luo_new

return ii_box_count

end function

public subroutine wf_arrange_position (ref integer ai_x, ref integer ai_y);int li_margin_x
int li_margin_y
int li_unit_x
int li_unit_y

if ib_zoomout then
	li_margin_x = MARGIN_X_ZOOM
	li_margin_y = MARGIN_Y_ZOOM
	li_unit_x = UNIT_X_ZOOM
	li_unit_y = UNIT_Y_ZOOM
else
	li_margin_x = MARGIN_X_NORM
	li_margin_y = MARGIN_Y_NORM
	li_unit_x = UNIT_X_NORM
	li_unit_y = UNIT_Y_NORM
end if

If ai_x < 1 Then
	ai_x = li_margin_x
Else
	ai_x = round((ai_x - li_margin_x) / li_unit_x, 0) * li_unit_x + li_margin_x
End If
If ai_y < 1 Then
	ai_y = li_margin_y
Else
	ai_y = round((ai_y - li_margin_y) / li_unit_y, 0) * li_unit_y + li_margin_y
End If

end subroutine

public subroutine wf_freeze_box ();int i

for i = 1 to ii_box_count
	if IsValid(iuo_box[i]) Then
		iuo_box[i].DragAuto = False
//		iuo_box[i].Pointer = "..\image\cross_p.cur"
		iuo_box[i].dw_info.enabled = false
	end if
next

end subroutine

public subroutine wf_release_box ();int i

for i = 1 to ii_box_count
	if IsValid(iuo_box[i]) Then
		iuo_box[i].DragAuto = true
//		iuo_box[i].Pointer = "Arrow!"
		iuo_box[i].dw_info.enabled = true
	end if
next

end subroutine

public subroutine wf_refresh_page ();wf_retrieve_page(is_retrieve_arg)

end subroutine

public subroutine wf_redraw_page ();// 현재는 다시 조회..
// 수정 계획 : 현재 정보로 다시 배치..

wf_retrieve_page(is_retrieve_arg)

end subroutine

public subroutine wf_set_movable (boolean ab_mode);ib_movable = ab_mode

end subroutine

public subroutine wf_calc_pos_zoom (ref integer ai_x, ref integer ai_y);if ib_zoomout then
	ai_x = ai_x / 2 + MARGIN_X_ZOOM
	ai_y = ai_y / 2 + MARGIN_Y_ZOOM
end if

end subroutine

public subroutine wf_set_mode (integer ai_mode);// mode 변경
wf_show_grid_property(false)
wf_show_select_line(false)
wf_show_select_box(false)
dw_detail.visible = false
dw_remark.visible = false

pointer = "arrow!"

ii_mode = ai_mode

end subroutine

public subroutine wf_set_mode_select_box (u_box auo_box);// BOX 선택 상태
wf_set_mode(MODE_SELECT_BOX)

iuo_select_box = auo_box

// 오류로 임시 막음...
//event ue_select_box(auo_box)

wf_show_select_box(true)

end subroutine

public subroutine wf_set_target_edge (powerobject ao_target, integer ai_edge);if ii_mode = MODE_ADD_LINE then
	if ii_mode_add_line = MODE_SELECT_TARGET2 then
		iuo_pre_branch.uf_pre_bridge_line(io_target, ii_target_edge, ao_target, ai_edge)
	end if
end if

end subroutine

public subroutine wf_show_grid_box ();string ls_grid_unit
int li_grid_start_no
int li_grid_count
int li_grid_width
int i
string ls_label
long ll_color[2]

if dw_summary.rowcount() > 0 then
	ls_grid_unit     = dw_summary.getitemstring(1, 'grid_unit')
	li_grid_start_no = dw_summary.getitemnumber(1, 'grid_start_no')
	li_grid_count    = dw_summary.getitemnumber(1, 'grid_count')
	li_grid_width    = dw_summary.getitemnumber(1, 'grid_width')
else
	ls_grid_unit     = 'M'
	li_grid_start_no = 1
	li_grid_count    = 6
	li_grid_width    = 1000
end if

if li_grid_width <= 0 then
	li_grid_width = 1000
end if
if ib_zoomout then
	li_grid_width /= 2
end if

ll_color[1] = rgb(255, 255, 255)
ll_color[2] = rgb(240, 240, 255)

for i = 1 to li_grid_count
	if i > ii_grid_count then
		OpenUserObject(ist_grid[i], (i - 1) * li_grid_width, 0)
		ii_grid_line_count = i
	else
		ist_grid[i].move((i - 1) * li_grid_width, 0)
	end if
	ist_grid[i].bringtotop = false
	ist_grid[i].alignment = Right!
	if isnull(ls_grid_unit) or ls_grid_unit = '' then
		ls_label = ''
	else
		ls_label = ls_grid_unit + '+'
	end if
	ist_grid[i].text = ls_label + string(li_grid_start_no + i - 1)
	ist_grid[i].enabled = false
	ist_grid[i].border = false
	ist_grid[i].backcolor = ll_color[mod(i, 2) + 1]
	ist_grid[i].resize(li_grid_width, this.WorkSpaceHeight())
next

end subroutine

public function boolean wf_is_select_mode ();Return (ii_mode = MODE_SELECT) &
    or (ii_mode = MODE_SELECT_BOX) &
    or (ii_mode = MODE_SELECT_LINE)

end function

public subroutine wf_show_detail_float (boolean ab_switch, powerobject ao_target);u_box luo_select_box

if ab_switch = false then
	if dw_detail.controlmenu = false then
		dw_detail.visible = false
	end if
else
	if wf_is_select_mode() and dw_detail.visible = false then
		dw_detail.x = pointerx() + 20
		dw_detail.y = pointery() + 40
		if dw_detail.y + dw_detail.height > this.WorkSpaceHeight() then
			dw_detail.y = this.WorkSpaceHeight() - dw_detail.height
			if dw_detail.y < 0 then dw_detail.y = 0
		end if
		dw_detail.controlmenu = false
		dw_detail.visible = true
		//event ue_retrieve_detail(ao_target)
		luo_select_box = ao_target
		luo_select_box.dw_info.sharedata(dw_detail)
	end if
end if

end subroutine

public subroutine wf_show_remark_float (boolean ab_switch, powerobject ao_target);u_box luo_select_box

if ab_switch = false then
	if dw_remark.controlmenu = false then
		dw_remark.visible = false
	end if
else
	if wf_is_select_mode() and dw_remark.visible = false then
		dw_remark.x = pointerx() + 20
		dw_remark.y = pointery() + 40
		if dw_remark.y + dw_remark.height > this.WorkSpaceHeight() then
			dw_remark.y = this.WorkSpaceHeight() - dw_remark.height
			if dw_remark.y < 0 then dw_remark.y = 0
		end if
		dw_remark.controlmenu = false
		dw_remark.visible = true
		//event ue_retrieve_remark(ao_target)
		luo_select_box = ao_target
		luo_select_box.dw_info.sharedata(dw_remark)
	end if
end if

end subroutine

public subroutine wf_delete_select_item ();if ii_mode = MODE_SELECT_BOX then
	wf_delete_box(iuo_select_box)
elseif ii_mode = MODE_SELECT_LINE then
	wf_delete_line(iuo_select_branch)
end if

end subroutine

public subroutine wf_set_readonly (boolean ab_mode);ib_readonly = ab_mode

end subroutine

public function boolean wf_is_progress_mode ();return ib_progress_mode

end function

public function boolean wf_is_readonly ();return ib_readonly

end function

public function integer wf_signature (datawindow adw_target);long   ll_Row, ll_RowCount
datetime ldt_now
dwItemStatus l_status
string ls_col_empno, ls_col_time

adw_target.AcceptText()

if ib_progress_mode then
	ls_col_empno = 'prgss_empno'
	ls_col_time = 'prgss_time'
else
	ls_col_empno = 'write_empno'
	ls_col_time = 'write_time'
end if

ll_Row = 0
ll_RowCount = adw_target.RowCount()
ldt_now = datetime(today(), now())
do while ll_Row <= ll_RowCount
	ll_Row = adw_target.GetNextModified(ll_Row, Primary!)
   if ll_row <= 0 then exit

	l_status = adw_target.GetItemStatus(ll_row, 0, Primary!)

	if l_status = NewModified! or l_status = DataModified! then
		adw_target.SetItem(ll_row, ls_col_empno, gs_empno)
		adw_target.SetItem(ll_row, ls_col_time, ldt_now)
	end if
loop

return 1

end function

public function integer wf_save_query (boolean ab_check_all);if wf_ismodified(ab_check_all) > 0 then
	choose case messagebox('데이타 변경 확인', '자료가 변경되었습니다.~r~n~r~n저장하시겠습니까?', question!, yesnocancel!, 1)
		case 1
			if wf_save_page(ab_check_all) < 0 then
				return 1
			else
				return 0
			end if
		case 2
			return 0
		case 3
			return 1
	end choose
end if

return 0

end function

public function integer wf_ismodified (boolean ab_check_all);integer	i

if ib_changed then
	return 1
end if

for i = 1 to ii_box_count
	if not iuo_box[i].ib_deleted then
		iuo_box[i].dw_info.accepttext()
		if iuo_box[i].dw_info.modifiedcount() > 0 then
			return 1
		end if
	end if
next

if ab_check_all then
	// 상위 수정 확인
	if isvalid(iw_parent_flow) then
		return iw_parent_flow.dynamic wf_ismodified(ab_check_all)
	end if
end if

return 0

end function

public subroutine wf_calc_pos_orig (ref integer ai_x, ref integer ai_y);if ib_zoomout then
	ai_x = (ai_x - MARGIN_X_ZOOM) * 2
	ai_y = (ai_y - MARGIN_Y_ZOOM) * 2
end if

end subroutine

public function boolean wf_is_empty ();int i

if ii_box_count = 0 then
	return true
end if

for i = 1 to ii_box_count
	if not IsValid(iuo_box[i]) then continue
	if iuo_box[i].ib_deleted then continue
	return false
next

return true

end function

public subroutine wf_set_progress_mode (boolean ab_mode);ib_progress_mode = ab_mode
if ib_progress_mode then
	is_box_object_name = is_default_progress_box_object_name
else
	is_box_object_name = is_default_box_object_name
end if

if ib_progress_mode then
	dw_detail.dataobject = is_default_progress_dw_detail
	dw_detail.settransobject(sqlca)
	dw_remark.dataobject = is_default_progress_dw_remark
	dw_remark.settransobject(sqlca)
end if

end subroutine

public subroutine wf_reset_child_page ();iw_parent.dynamic event ue_flow_reset_child_page(is_flow_type)

end subroutine

public function integer wf_reset_page ();integer	li_index, li_max
long		ll_lastrow

this.SetRedraw(False)
//// 그리드 라인
//wf_show_grid_line()
////wf_show_grid_box()

dw_summary.reset()
dw_summary.bringtotop = true

wf_set_mode_select()

for li_index = 1 to ii_box_count
	CloseUserObject(iuo_box[li_index])
next
ii_box_count = 0

for li_index = 1 to ii_branch_count
	iuo_branch[li_index].uf_reset()
next
ii_branch_count = 0

this.SetRedraw(True)

return 1

end function

public subroutine wf_delete_box (u_box auo_box);// 선택 대기 상태
wf_set_mode(MODE_SELECT)

if event ue_deletequery_box(auo_box) > 0 then
	event ue_delete_box(auo_box)
	auo_box.uf_delete_box()

	wf_set_changed(true)

	wf_reset_child_page()
end if

end subroutine

public subroutine wf_delete_line (u_branch auo_branch);// 선택 대기 상태
wf_set_mode(MODE_SELECT)

event ue_delete_branch(auo_branch)

auo_branch.uf_delete_branch()

wf_set_changed(true)

end subroutine

public subroutine wf_show_select_box (boolean ab_switch);int li_x1, li_y1, li_x2, li_y2

if ab_switch = false then
	//iuo_select_box = iuo_null_box

	st_box_white_1.visible = false
	st_box_white_2.visible = false
	st_box_white_3.visible = false
	st_box_white_4.visible = false
	st_box_white_5.visible = false
	st_box_white_6.visible = false
	st_box_white_7.visible = false
	st_box_white_8.visible = false
else
	li_x1 = iuo_select_box.x
	li_y1 = iuo_select_box.y
	li_x2 = li_x1 + iuo_select_box.width
	li_y2 = li_y1 + iuo_select_box.height

	st_box_white_1.x = li_x1 - st_box_white_1.width / 2
	st_box_white_1.y = li_y1 - st_box_white_1.height / 2
	st_box_white_2.x = li_x2 - st_box_white_2.width / 2
	st_box_white_2.y = li_y1 - st_box_white_2.height / 2
	st_box_white_3.x = li_x1 - st_box_white_3.width / 2
	st_box_white_3.y = li_y2 - st_box_white_3.height / 2
	st_box_white_4.x = li_x2 - st_box_white_4.width / 2
	st_box_white_4.y = li_y2 - st_box_white_4.height / 2
	st_box_white_5.x = (li_x1 + li_x2) / 2 - st_box_white_5.width / 2
	st_box_white_5.y = li_y1 - st_box_white_5.height / 2
	st_box_white_6.x = li_x1 - st_box_white_6.width / 2
	st_box_white_6.y = (li_y1 + li_y2) / 2 - st_box_white_6.height / 2
	st_box_white_7.x = li_x2 - st_box_white_7.width / 2
	st_box_white_7.y = (li_y1 + li_y2) / 2 - st_box_white_7.height / 2
	st_box_white_8.x = (li_x1 + li_x2) / 2 - st_box_white_8.width / 2
	st_box_white_8.y = li_y2 - st_box_white_8.height / 2

	st_box_white_1.visible = true
	st_box_white_2.visible = true
	st_box_white_3.visible = true
	st_box_white_4.visible = true
	st_box_white_5.visible = true
	st_box_white_6.visible = true
	st_box_white_7.visible = true
	st_box_white_8.visible = true
	st_box_white_1.bringtotop = true
	st_box_white_2.bringtotop = true
	st_box_white_3.bringtotop = true
	st_box_white_4.bringtotop = true
	st_box_white_5.bringtotop = true
	st_box_white_6.bringtotop = true
	st_box_white_7.bringtotop = true
	st_box_white_8.bringtotop = true
end if

end subroutine

public subroutine wf_retrieve_page (string as_arg);integer li_index, li_readcount

wf_reset_page()

is_retrieve_arg = as_arg
event ue_retrieve_page(as_arg)

Send(Handle(this), 277, 6, 0)	// Scroll To Top
Send(Handle(this), 276, 5, 0)	// Scroll To Left edge

// 그리드 라인
wf_show_grid_line()
//wf_show_grid_box()

li_readcount = dw_box.RowCount()
for li_index = 1 to li_readcount
	this.event ue_retrieve_box(li_index)
next

li_readcount = dw_branch.RowCount()
for li_index = 1 to li_readcount
	this.event ue_retrieve_branch(li_index)
next

if not ib_movable then
	wf_freeze_box()
end if

//w_mainframe.SetRedraw(true)
ib_changed = false

end subroutine

public subroutine wf_show_grid_line ();string ls_grid_unit
int li_grid_start_no
int li_grid_count
int li_grid_width
int i
string ls_label

if dw_summary.rowcount() > 0 then
	ls_grid_unit     = dw_summary.getitemstring(1, 'grid_unit')
	li_grid_start_no = dw_summary.getitemnumber(1, 'grid_start_no')
	if isnull(li_grid_start_no) then li_grid_start_no = 1
	li_grid_count    = dw_summary.getitemnumber(1, 'grid_count')
	if isnull(li_grid_count) then li_grid_count = 6
	li_grid_width    = dw_summary.getitemnumber(1, 'grid_width')
	if isnull(li_grid_width) then li_grid_width = 1000
else
	ls_grid_unit     = 'M'
	li_grid_start_no = 1
	li_grid_count    = 6
	li_grid_width    = 1000
end if

if li_grid_width <= 50 then
	li_grid_width = 1000
end if
if ib_zoomout then
	li_grid_width /= 2
end if

for i = 1 to li_grid_count
	if i > ii_grid_line_count then
		OpenUserObject(ist_grid_line[i], i * li_grid_width, 0)
		ii_grid_line_count = i
	else
		ist_grid_line[i].move(i * li_grid_width, 0)
	end if
	if isnull(ls_grid_unit) or ls_grid_unit = '' then
		ls_label = ''
	else
		ls_label = ls_grid_unit + '+'
	end if
	ist_grid_line[i].st_label.text = ls_label + string(li_grid_start_no + i - 1)
	ist_grid_line[i].bringtotop = false
	ist_grid_line[i].enabled = false
	ist_grid_line[i].uf_set_position(i * li_grid_width, this.WorkSpaceHeight())
	ist_grid_line[i].height = this.WorkSpaceHeight()
	ist_grid_line[i].visible = true
//	ist_grid_line[i].dragauto = true
next

for i = li_grid_count + 1 to ii_grid_line_count
	ist_grid_line[i].visible = false
next

dw_summary.bringtotop = true
for i = 1 to ii_box_count
	iuo_box[i].bringtotop = true
next
for i = 1 to ii_branch_count
	iuo_branch[i].uf_bringtotop()
next
dw_grid_property.bringtotop = true
dw_branch_property.bringtotop = true

end subroutine

public function integer wf_save_page (boolean ab_check_all);integer	li_index

if wf_ismodified(ab_check_all) = 0 then
	return 0
end if

// 스크롤 된 경우 위치 조정..
Send(Handle(This), 277, 6, 0)	// Scroll To Top
Send(Handle(This), 276, 5, 0)	// Scroll To Left edge

// 기간 정보를 상위에 기록
wf_update_parent_progress_info()

// 이벤트 호출
event ue_save_page()

// 상위를 먼저 저장
if isvalid(iw_parent_flow) then
	iw_parent_flow.dynamic wf_save_page(ab_check_all)
end if

for li_index = 1 to ii_box_count
	if IsValid(iuo_box[li_index]) then
		if not iuo_box[li_index].ib_deleted then
			event ue_save_box(iuo_box[li_index])
			iuo_box[li_index].dw_info.resetupdate()
		end if
	end if
next

for li_index = 1 to ii_branch_count
	if IsValid(iuo_branch[li_index]) then
		if not iuo_branch[li_index].ib_deleted then
			event ue_save_branch(iuo_branch[li_index])
		end if
	end if
next

// 작성 정보 기록
wf_signature(dw_box)
if dw_box.Update(True, False) = 1 then
	if dw_branch.Update(True, False) = 1 then
		if dw_summary.Update(True, False) = 1 then
			COMMIT USING SQLCA;
			dw_box.ResetUpdate()
			dw_branch.ResetUpdate()
			dw_summary.ResetUpdate()
		else
			MessageBox("오류", "연결정보 저장실패", StopSign!)
			ROLLBACK USING SQLCA;
			return -1
		end if
	else
		MessageBox("오류", "연결정보 저장실패", StopSign!)
		ROLLBACK USING SQLCA;
		return -1
	end if
else
	MessageBox("오류", "개체 저장실패"+ SQLCA.sqlerrtext)
	ROLLBACK USING SQLCA;
	return -1
end if

ib_changed = false

return 1

end function

public subroutine wf_update_parent_progress_info ();int i
datetime ldt_f_date, ldt_t_date, ldt_page_f_date, ldt_page_t_date
//	ib_progress_mode
datetime ldt_s_date, ldt_e_date, ldt_page_s_date, ldt_page_e_date
decimal ld_prgss_rate, ld_page_prgss_rate
decimal ld_total_days, ld_paln_days, ld_prgss_days
string ls_finish_yn, ls_page_finish_yn

for i = 1 to ii_box_count
	if not IsValid(iuo_box[i]) then continue
	if iuo_box[i].ib_deleted then continue

	ldt_f_date = iuo_box[i].dw_info.getitemdatetime(1, 'f_date')
	ldt_t_date = iuo_box[i].dw_info.getitemdatetime(1, 't_date')
// ib_progress_mode
	ls_finish_yn = iuo_box[i].dw_info.getitemstring(1, 'finish_yn')
	ld_prgss_rate = iuo_box[i].dw_info.getitemnumber(1, 'prgss_rate')
	ldt_s_date = iuo_box[i].dw_info.getitemdatetime(1, 's_date')
	ldt_e_date = iuo_box[i].dw_info.getitemdatetime(1, 'e_date')
	ld_paln_days = daysafter(date(ldt_f_date), date(ldt_t_date)) + 1
	if isnull(ld_prgss_rate) then ld_prgss_rate = 0
	if isnull(ld_paln_days) then ld_paln_days = 0

	if i = 1 then
		ldt_page_f_date = ldt_f_date
		ldt_page_t_date = ldt_t_date
//	ib_progress_mode
		ls_page_finish_yn = ls_finish_yn
		ldt_page_s_date = ldt_s_date
		ldt_page_e_date = ldt_e_date
		ld_total_days = ld_paln_days
		ld_prgss_days = ld_paln_days * ld_prgss_rate / 100
	else
		// 시작예정일중 하나라도 시작예정일이 있으면 전체를 시작예정일로 지정
		if isnull(ldt_page_f_date) or ldt_f_date < ldt_page_f_date then
			ldt_page_f_date = ldt_f_date
		end if
		// 종료예정일중 하나라도 종료예정일이 있으면 전체를 종료예정일로 지정
		if isnull(ldt_page_t_date) or ldt_t_date > ldt_page_t_date then
			ldt_page_t_date = ldt_t_date
		end if
//	ib_progress_mode
		// 시작일중 하나라도 시작일이 있으면 전체를 시작일로 지정
		if isnull(ldt_page_s_date) or ldt_s_date < ldt_page_s_date then
			ldt_page_s_date = ldt_s_date
		end if
		// 종료일중 하나라도 널(미정)이 있으면 전체를 널(미정)로 지정
		if isnull(ldt_e_date) or ldt_e_date > ldt_page_e_date then
			ldt_page_e_date = ldt_e_date
		end if
		if ls_page_finish_yn = 'Y' and ls_finish_yn = 'Y' then
			ls_page_finish_yn = 'Y'
		else
			ls_page_finish_yn = 'N'
		end if
		ld_total_days += ld_paln_days
		ld_prgss_days += ld_paln_days * ld_prgss_rate / 100
	end if
next
//	ib_progress_mode
if ld_total_days <> 0 then
	ld_page_prgss_rate = ld_prgss_days / ld_total_days * 100
else
	ld_page_prgss_rate = 0
end if

if isvalid(iw_parent_flow) then
	iw_parent_flow.dynamic event ue_child_data_changed(ldt_page_f_date, ldt_page_t_date, ls_page_finish_yn, ld_page_prgss_rate, ldt_page_s_date, ldt_page_e_date)
else
	iw_parent.dynamic event ue_child_data_changed(ldt_page_f_date, ldt_page_t_date, ls_page_finish_yn, ld_page_prgss_rate, ldt_page_s_date, ldt_page_e_date)
end if

end subroutine

public function boolean wf_is_dept_member (string as_deptcode);// 사용자가 해당부서인지 check
return (as_deptcode = gs_dept)

end function

public function integer wf_bridge_line (powerobject ao_target1, integer ai_target1_edge, powerobject ao_target2, integer ai_target2_edge);u_branch luo_branch

ii_branch_count++
luo_branch = create u_branch
luo_branch.ii_index = ii_branch_count
luo_branch.iw_parent = this
luo_branch.uf_bridge_line(ao_target1, ai_target1_edge, ao_target2, ai_target2_edge)
iuo_branch[ii_branch_count] = luo_branch

wf_set_changed(true)

return ii_branch_count

//ii_branch_count++
//iuo_branch[ii_branch_count] = create u_branch
//iuo_branch[ii_branch_count].ii_index = ii_branch_count
//iuo_branch[ii_branch_count].iw_parent = this
//iuo_branch[ii_branch_count].uf_bridge_line(ao_target1, ai_target1_edge, ao_target2, ai_target2_edge)
//
//return ii_branch_count

end function

public subroutine wf_set_mode_select_line (u_branch auo_branch);// LINE 선택 상태
wf_set_mode(MODE_SELECT_LINE)

//wf_freeze_box()

iuo_select_branch = auo_branch

wf_show_select_line(true)

//setfocus(this)
//pointer = "cross!"

end subroutine

public subroutine wf_add_box ();u_box luo_new
int li_x, li_y
int li_box

li_x = this.PointerX()
li_y = this.PointerY()
wf_arrange_position(li_x, li_y)

li_box = wf_new_box(li_x, li_y)

iuo_box[li_box].dw_info.insertrow(1)
event ue_add_box(iuo_box[li_box])

wf_set_changed(true)

wf_set_mode_select()

end subroutine

public subroutine wf_print_create_page ();/* dw_box에 검색된 내용을 화면구성후 출력하는 함수이다.*/
string  ls_syntax, ls_syntax_into
integer li_index
long ll_left_margin, ll_top_margin
long ll_max_x, ll_max_y
long ll_paper_width, ll_paper_height
int li_print_rate
u_dw_syntax luo_dw_syntax
string ls_name
long ll_y

Send(Handle(this), 277, 6, 0)	// Scroll To Top
Send(Handle(this), 276, 5, 0)	// Scroll To Left edge

//데이타 검색테이블 연결
//if dw_print.DataObject <> 'dr_flow_basic' then
	dw_print.DataObject = 'dr_flow_basic'
   dw_print.SetTransObject(SQLCA)
//end if
//dw_print.reset()

//기본 화면을 가저온다.
ls_syntax = string(dw_print.object.datawindow.syntax)
ls_syntax_into = ''

ll_left_margin = 4 // 23
ll_top_margin  = 4 // 12

// 전체 오브젝트 Max 값 계산 위해 초기화
luo_dw_syntax.uf_init_max_value()

ls_syntax_into += luo_dw_syntax.uf_get_datawindow(ll_left_margin, ll_top_margin, dw_summary, 't_grid,t_zoom')

// 연결선 먼저 처리
for li_index = 1 to ii_branch_count
	if IsValid(iuo_branch[li_index]) then
		if not iuo_branch[li_index].ib_deleted then
			ls_syntax_into += iuo_branch[li_index].uf_get_dw_syntax(ll_left_margin, ll_top_margin)
		end if
	end if
next

// 박스 처리
for li_index = 1 to ii_box_count
	if IsValid(iuo_box[li_index]) then
		if not iuo_box[li_index].ib_deleted then
			ls_syntax_into += iuo_box[li_index].uf_get_dw_syntax(ll_left_margin, ll_top_margin)
		end if
	end if
next

// 현재 선택된 용지 크기 조회
luo_dw_syntax.uf_getpapersizeunit(dw_print, ll_paper_width, ll_paper_height)
ll_paper_width -= long(dw_print.Object.DataWindow.Print.Margin.Left) + long(dw_print.Object.DataWindow.Print.Margin.Right)
ll_paper_height -= long(dw_print.Object.DataWindow.Print.Margin.Top) + long(dw_print.Object.DataWindow.Print.Margin.Bottom)
// 여백
ll_paper_width -= 16
ll_paper_height -= 16

// 전체 오브젝트 Max 값 계산 위해 초기화
luo_dw_syntax.uf_get_max_value(ll_max_x, ll_max_y)
ll_max_x += 120
ll_max_y += 120

if ll_max_x <= ll_paper_width and ll_max_y < ll_paper_height then
	ll_max_x = ll_paper_width
	ll_max_y = ll_paper_height
	li_print_rate = 100
else
	if ll_paper_width / ll_max_x < ll_paper_height / ll_max_y then
		// 가로가 더 큰 경우
		ll_max_y = ll_max_x / ll_paper_width * ll_paper_height
		li_print_rate = ll_paper_width / ll_max_x * 100
	else
		// 세로가 더 큰 경우
		ll_max_x = ll_max_y / ll_paper_height * ll_paper_width
		li_print_rate = ll_paper_height / ll_max_y * 100
	end if
end if

// 그리드 라인
for li_index = 1 to ii_grid_line_count
	if ist_grid_line[li_index].visible and ist_grid_line[li_index].x + ist_grid_line[li_index].width < ll_max_x then
		//ls_syntax_into += uo_dw_syntax.uf_get_line_background(ll_left_margin + ist_grid_line[li_index].x, ll_top_margin + ist_grid_line[li_index].y, ist_grid_line[li_index].ln_line, li_index)
		//ls_syntax_into += uo_dw_syntax.uf_get_text_background(ll_left_margin + ist_grid_line[li_index].x, ll_top_margin + ist_grid_line[li_index].y, ist_grid_line[li_index].st_label, li_index)
		ls_syntax_into += ist_grid_line[li_index].uf_get_dw_syntax(ll_left_margin, ll_top_margin, li_index)
	end if
next

ls_syntax = ls_syntax + ls_syntax_into

//MessageBox('test', ls_syntax)
dw_print.Create(ls_syntax)
dw_print.Object.DataWindow.Zoom = li_print_rate

// detail band 높이 조정
dw_print.object.datawindow.detail.height = ll_max_y + 4

//dw_print.object.t_title.text = dw_summary.getitemstring(1, 'org_title')
dw_print.object.frame_top.x1 = ll_left_margin
dw_print.object.frame_top.y1 = ll_top_margin
dw_print.object.frame_top.x2 = ll_max_x
dw_print.object.frame_top.y2 = ll_top_margin
dw_print.object.frame_left.x1 = ll_left_margin
dw_print.object.frame_left.y1 = ll_top_margin
dw_print.object.frame_left.x2 = ll_left_margin
dw_print.object.frame_left.y2 = ll_max_y
dw_print.object.frame_right.x1 = ll_max_x
dw_print.object.frame_right.y1 = ll_top_margin
dw_print.object.frame_right.x2 = ll_max_x
dw_print.object.frame_right.y2 = ll_max_y
dw_print.object.frame_bottom.x1 = ll_left_margin
dw_print.object.frame_bottom.y1 = ll_max_y
dw_print.object.frame_bottom.x2 = ll_max_x
dw_print.object.frame_bottom.y2 = ll_max_y

dw_print.object.info_12.x = ll_max_x - long(dw_print.object.info_12.width) - 8
dw_print.object.info_12.y = ll_top_margin + 12
dw_print.object.info_11.x = long(dw_print.object.info_12.x) - long(dw_print.object.info_11.width)
dw_print.object.info_11.y = ll_top_margin + 12
dw_print.object.info_22.x = long(dw_print.object.info_12.x)
dw_print.object.info_22.y = long(dw_print.object.info_12.y) + long(dw_print.object.info_12.height)
dw_print.object.info_21.x = long(dw_print.object.info_11.x)
dw_print.object.info_21.y = long(dw_print.object.info_11.y) + long(dw_print.object.info_11.height)
dw_print.object.info_32.x = long(dw_print.object.info_22.x)
dw_print.object.info_32.y = long(dw_print.object.info_22.y) + long(dw_print.object.info_22.height)
dw_print.object.info_31.x = long(dw_print.object.info_21.x)
dw_print.object.info_31.y = long(dw_print.object.info_21.y) + long(dw_print.object.info_21.height)

li_index = 1
do while true
	ls_name = 'background_t_' + string(li_index)
	if dw_print.describe(ls_name + '.type') <> 'text' then exit
	ll_y = ll_max_y - long(dw_print.describe(ls_name + '.height'))
	dw_print.modify(ls_name + '.y="' + string(ll_y) + '"')
	ls_name = 'background_l_' + string(li_index)
	dw_print.modify(ls_name + '.y2="' + string(ll_y) + '"')
	li_index ++
loop

dw_print.insertrow(0)

end subroutine

public function string wf_get_seq_arg ();string ls_arg
int li_seq, li_display_seq

//li_seq = iuo_select_box.uf_get_seq()
li_display_seq = iuo_select_box.uf_get_display_seq()
//ls_arg = string(li_seq) + '~n' + string(li_display_seq)
ls_arg = iuo_select_box.uf_get_seq_key() + '~n'
if len(is_parent_display_seq) > 0 then
	ls_arg += is_parent_display_seq + '~n'
end if
ls_arg += f_nvl(string(li_display_seq), '')

return ls_arg

end function

public subroutine wf_show_remark (boolean ab_switch);if ab_switch = false then
	dw_remark.accepttext()
	dw_remark.visible = false
	//event ue_save_remark()
else
	if wf_is_select_mode() then
		dw_remark.x = iuo_select_box.x + iuo_select_box.width
		dw_remark.y = iuo_select_box.y
		if dw_remark.y + dw_remark.height > this.WorkSpaceHeight() then
			dw_remark.y = this.WorkSpaceHeight() - dw_remark.height
			if dw_remark.y < 0 then dw_remark.y = 0
		end if
		dw_remark.controlmenu = true
		dw_remark.visible = true
		//event ue_retrieve_remark(iuo_select_box)
		iuo_select_box.dw_info.sharedata(dw_remark)

		if iuo_select_box.ib_readonly then
			dw_remark.object.datawindow.readonly = 'yes'
		else
			dw_remark.object.datawindow.readonly = 'no'
		end if
	end if
end if

end subroutine

public subroutine wf_show_detail (boolean ab_switch);if ab_switch = false then
	dw_detail.accepttext()
	dw_detail.visible = false
	//event ue_save_detail()
else
	if wf_is_select_mode() then
		dw_detail.x = iuo_select_box.x + iuo_select_box.width
		dw_detail.y = iuo_select_box.y
		if dw_detail.y + dw_detail.height > this.WorkSpaceHeight() then
			dw_detail.y = this.WorkSpaceHeight() - dw_detail.height
			if dw_detail.y < 0 then dw_detail.y = 0
		end if
		dw_detail.controlmenu = true
		dw_detail.visible = true
		//event ue_retrieve_detail(iuo_select_box)
		iuo_select_box.dw_info.sharedata(dw_detail)

		if iuo_select_box.ib_readonly then
			dw_detail.object.datawindow.readonly = 'yes'
		else
			dw_detail.object.datawindow.readonly = 'no'
		end if
	end if
end if

end subroutine

public subroutine wf_show_grid_property (boolean ab_switch);int li_x1, li_y1, li_x2, li_y2

if ab_switch = false then
	dw_grid_property.accepttext()
	dw_grid_property.visible = false
else
	Send(Handle(this), 277, 6, 0)	// Scroll To Top
	Send(Handle(this), 276, 5, 0)	// Scroll To Left edge

	dw_grid_property.x = this.WorkSpaceWidth() - dw_grid_property.width
	dw_grid_property.y = 0
	dw_grid_property.visible = true
	dw_grid_property.setitem(1, 'grid_unit',     dw_summary.getitemstring(1, 'grid_unit'))
	dw_grid_property.setitem(1, 'grid_start_no', dw_summary.getitemnumber(1, 'grid_start_no'))
	dw_grid_property.setitem(1, 'grid_count',    dw_summary.getitemnumber(1, 'grid_count'))
	dw_grid_property.setitem(1, 'grid_width',    dw_summary.getitemnumber(1, 'grid_width'))

	if wf_is_readonly() then
		dw_grid_property.object.datawindow.readonly = 'yes'
	else
		dw_grid_property.object.datawindow.readonly = 'no'
	end if
end if

end subroutine

public subroutine wf_show_select_line (boolean ab_switch);int li_x1, li_y1, li_x2, li_y2

if ab_switch = false then
	iuo_select_branch = iuo_null_branch

	st_box_red_1.visible = false
	st_box_red_2.visible = false
	dw_branch_property.accepttext()
	dw_branch_property.visible = false
else
	iuo_select_branch.iuo_target1.dynamic uf_get_connect_pos(iuo_select_branch.ii_target1_edge, li_x1, li_y1)
	iuo_select_branch.iuo_target2.dynamic uf_get_connect_pos(iuo_select_branch.ii_target2_edge, li_x2, li_y2)

	st_box_red_1.x = li_x1 - st_box_red_1.width / 2
	st_box_red_1.y = li_y1 - st_box_red_1.height / 2
	st_box_red_2.x = li_x2 - st_box_red_2.width / 2
	st_box_red_2.y = li_y2 - st_box_red_2.height / 2

	st_box_red_1.visible = true
	st_box_red_2.visible = true
	st_box_red_1.bringtotop = true
	st_box_red_2.bringtotop = true

	dw_branch_property.x = this.WorkSpaceWidth() - dw_branch_property.width
	dw_branch_property.y = 0
	dw_branch_property.visible = true
	dw_branch_property.setitem(1, 'line_thick', iuo_select_branch.ii_line_thickness)
	if iuo_select_branch.ie_line_style = dot! then
		dw_branch_property.setitem(1, 'line_style', 'D')
	else
		dw_branch_property.setitem(1, 'line_style', 'C')
	end if

	if wf_is_readonly() then
		dw_branch_property.object.datawindow.readonly = 'yes'
	else
		dw_branch_property.object.datawindow.readonly = 'no'
	end if
end if

end subroutine

on w_flow.create
this.dw_print=create dw_print
this.dw_grid_property=create dw_grid_property
this.dw_remark=create dw_remark
this.st_box_white_6=create st_box_white_6
this.st_box_white_5=create st_box_white_5
this.st_box_white_7=create st_box_white_7
this.st_box_white_8=create st_box_white_8
this.st_box_white_4=create st_box_white_4
this.st_box_white_3=create st_box_white_3
this.st_box_white_1=create st_box_white_1
this.st_box_white_2=create st_box_white_2
this.dw_branch_property=create dw_branch_property
this.st_box_red_2=create st_box_red_2
this.dw_detail=create dw_detail
this.dw_branch=create dw_branch
this.dw_box=create dw_box
this.st_box_red_1=create st_box_red_1
this.dw_summary=create dw_summary
this.Control[]={this.dw_print,&
this.dw_grid_property,&
this.dw_remark,&
this.st_box_white_6,&
this.st_box_white_5,&
this.st_box_white_7,&
this.st_box_white_8,&
this.st_box_white_4,&
this.st_box_white_3,&
this.st_box_white_1,&
this.st_box_white_2,&
this.dw_branch_property,&
this.st_box_red_2,&
this.dw_detail,&
this.dw_branch,&
this.dw_box,&
this.st_box_red_1,&
this.dw_summary}
end on

on w_flow.destroy
destroy(this.dw_print)
destroy(this.dw_grid_property)
destroy(this.dw_remark)
destroy(this.st_box_white_6)
destroy(this.st_box_white_5)
destroy(this.st_box_white_7)
destroy(this.st_box_white_8)
destroy(this.st_box_white_4)
destroy(this.st_box_white_3)
destroy(this.st_box_white_1)
destroy(this.st_box_white_2)
destroy(this.dw_branch_property)
destroy(this.st_box_red_2)
destroy(this.dw_detail)
destroy(this.dw_branch)
destroy(this.dw_box)
destroy(this.st_box_red_1)
destroy(this.dw_summary)
end on

event dragdrop;DragObject	ldo_control
u_box			luo_box
Integer		li_newx, li_newy
long			ll_row

ldo_control = DraggedObject()
if TypeOf(ldo_control) = userobject! then
	luo_box = ldo_control
	li_newx = This.PointerX() - luo_box.ii_clicked_x
	li_newy = This.PointerY() - luo_box.ii_clicked_y
	wf_arrange_position(li_newx, li_newy)

	luo_box.uf_move(li_newx, li_newy)
end if

end event

event open;if isvalid(Message.PowerObjectParm) then
	if TypeOf(Message.PowerObjectParm) = Window! then
		iw_parent = Message.PowerObjectParm
	end if
end if

ib_changed = false
ib_zoomout = false
ib_progress_mode = false

ib_summary_zoomout = false
ii_summary_width = dw_summary.width
ii_summary_height = dw_summary.height

//is_default_box_object_name = 'u_box'
//is_default_progress_box_object_name = 'u_box'
//wf_set_progress_mode(false)

//im_popup = Create m_flow_popup

iuo_pre_branch = create u_branch
iuo_pre_branch.ii_index = 0
iuo_pre_branch.iw_parent = this

dw_box.SetTransObject(SQLCA)
dw_branch.SetTransObject(SQLCA)
dw_summary.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_remark.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)

dw_branch_property.insertrow(0)
dw_grid_property.insertrow(0)

//wf_show_grid_line()
wf_redraw_page()

end event

event close;wf_reset_page()

destroy iuo_pre_branch
//destroy im_popup

end event

event clicked;// BOX 추가 상태
if ii_mode = MODE_ADD_BOX then
	wf_add_box()
elseif ii_mode <> MODE_SELECT then
	wf_set_mode_select()
end if

end event

event mousemove;if ii_mode = MODE_ADD_LINE then
	if ii_mode_add_line = MODE_SELECT_TARGET2 then
		iuo_pre_branch.uf_pre_bridge_line(io_target, ii_target_edge, xpos, ypos)
	end if
end if

end event

event key;if key = KEYESCAPE! then
	if ii_mode <> MODE_SELECT then
		if ii_mode = MODE_ADD_LINE then
			if ii_mode_add_line = MODE_SELECT_TARGET2 then
				iuo_pre_branch.uf_reset()
			end if
		end if
		wf_set_mode_select()
	end if
elseif key = KEYDELETE! then
	if ii_mode = MODE_SELECT_LINE then
		wf_delete_line(iuo_select_branch)
	end if
end if

end event

type dw_print from datawindow within w_flow
boolean visible = false
integer x = 32
integer y = 1492
integer width = 686
integer height = 400
integer taborder = 40
string dataobject = "dr_flow_basic"
boolean livescroll = true
end type

type dw_grid_property from datawindow within w_flow
boolean visible = false
integer x = 1966
integer y = 136
integer width = 507
integer height = 308
integer taborder = 20
string dataobject = "dm_flow_grid_property"
end type

event itemchanged;string ls_col_name

string ls_grid_unit
long ll_grid_start_no
long ll_grid_count
long ll_grid_width

ls_col_name = dwo.name

//ls_grid_unit     = this.getitemstring(1, 'grid_unit')
//ll_grid_start_no = this.getitemnumber(1, 'grid_start_no')
//ll_grid_count    = this.getitemnumber(1, 'grid_count')
//ll_grid_width    = this.getitemnumber(1, 'grid_width')
//dw_grid_property.setitem(1, 'grid_unit',     dw_summary.getitemstring(1, 'grid_unit'))
//dw_grid_property.setitem(1, 'grid_start_no', dw_summary.getitemnumber(1, 'grid_start_no'))
//dw_grid_property.setitem(1, 'grid_count',    dw_summary.getitemnumber(1, 'grid_count'))
//dw_grid_property.setitem(1, 'grid_width',    dw_summary.getitemnumber(1, 'grid_width'))

if ls_col_name = 'grid_unit' then
	dw_summary.setitem(1, ls_col_name, data)
else
	dw_summary.setitem(1, ls_col_name, long(data))
end if

ib_changed = true

wf_show_grid_line()

end event

type dw_remark from datawindow within w_flow
boolean visible = false
integer x = 1883
integer y = 1364
integer width = 622
integer height = 492
integer taborder = 50
boolean titlebar = true
string title = "추가 정보"
boolean controlmenu = true
string icon = "Information!"
boolean livescroll = true
end type

event clicked;string ls_column, ls_filepath
string ls_Null
long   ll_rc

this.accepttext()
// 열기 버튼
if dwo.type = 'text' then
	ls_column = dwo.tag
	if ls_column = '?' or ls_column = '' then return
	ls_filepath = this.getitemstring(row, ls_column)
	if isnull(ls_filepath) then return
//	run('cmd.exe /c start "' + ls_filepath + '"')
	SetNull(ls_Null)
	ll_rc = ShellExecuteA(handle(parent), 'open', ls_filepath, ls_Null, ls_Null, 1)
	return
end if

// 등록 버튼
//string ls_file
//integer li_rc

if this.object.datawindow.readonly = 'yes' then return

if dwo.type = 'button' then
	ls_column = dwo.tag
	if ls_column = '?' or ls_column = '' then return
	if integer(this.Describe(ls_column + ".TabSequence")) = 0 then return
	//if dwo.tag <> 'link_file' then return

	ls_filepath = this.getitemstring(row, ls_column)
	if isnull(ls_filepath) then ls_filepath = ''
//	li_rc = GetFileOpenName('등록 파일 선택', ls_filepath, ls_file)
//	if li_rc = 1 then
//		ls_filepath = trim(ls_filepath)
//		this.setitem(row, string(dwo.name), ls_filepath)
//	end if

	openwithparm(w_wflow_file_copy, ls_filepath)
	if Message.StringParm <> '' then
		ls_filepath = trim(Message.StringParm)
		this.setitem(row, ls_column, ls_filepath)
	end if
end if

end event

event doubleclicked;//string ls_filepath, ls_file
//integer li_rc
//
//if this.object.datawindow.readonly = 'yes' then return
//
//if dwo.type = 'column' then
//	if integer(this.Describe(dwo.name + ".TabSequence")) = 0 then return
//	if dwo.tag <> 'link_file' then return
//
//	this.accepttext()
//	ls_filepath = this.getitemstring(row, string(dwo.name))
//	if isnull(ls_filepath) then ls_filepath = ''
////	li_rc = GetFileOpenName('등록 파일 선택', ls_filepath, ls_file)
////	if li_rc = 1 then
////		ls_filepath = trim(ls_filepath)
////		this.setitem(row, string(dwo.name), ls_filepath)
////	end if
//
//	openwithparm(w_wflow_file_copy, ls_filepath)
//	if Message.StringParm <> '' then
//		ls_filepath = trim(Message.StringParm)
//		this.setitem(row, string(dwo.name), ls_filepath)
//	end if
//end if
//
end event

event losefocus;this.accepttext()

end event

type st_box_white_6 from statictext within w_flow
boolean visible = false
integer x = 1714
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_5 from statictext within w_flow
boolean visible = false
integer x = 1632
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_7 from statictext within w_flow
boolean visible = false
integer x = 1801
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_8 from statictext within w_flow
boolean visible = false
integer x = 1883
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_4 from statictext within w_flow
boolean visible = false
integer x = 1550
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_3 from statictext within w_flow
boolean visible = false
integer x = 1467
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_1 from statictext within w_flow
boolean visible = false
integer x = 1298
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_box_white_2 from statictext within w_flow
boolean visible = false
integer x = 1381
integer y = 268
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_branch_property from datawindow within w_flow
boolean visible = false
integer x = 2501
integer y = 136
integer width = 873
integer height = 308
integer taborder = 40
string dataobject = "dm_flow_branch_property"
end type

event clicked;if not wf_is_readonly() then
	if dwo.type = 'rectangle' then
		iuo_select_branch.il_line_color = long(dwo.brush.color)
		iuo_select_branch.uf_redraw()

		ib_changed = true
	end if
end if

end event

event editchanged;if dwo.name = 'line_thick' then
	iuo_select_branch.ii_line_thickness = integer(data)
	iuo_select_branch.uf_redraw()

	ib_changed = true
end if

end event

event itemchanged;if dwo.name = 'line_style' then
	if data = 'D' then
		iuo_select_branch.ie_line_style = dot!
		iuo_select_branch.ii_line_thickness = 1
		setitem(1, 'line_thick', 1)
	else
		iuo_select_branch.ie_line_style = continuous!
	end if
	iuo_select_branch.uf_redraw()

	ib_changed = true
end if

end event

type st_box_red_2 from statictext within w_flow
boolean visible = false
integer x = 1381
integer y = 188
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 255
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_detail from datawindow within w_flow
boolean visible = false
integer x = 992
integer y = 1364
integer width = 622
integer height = 492
integer taborder = 40
boolean titlebar = true
string title = "세부 정보"
boolean controlmenu = true
string icon = "Information!"
boolean livescroll = true
end type

event losefocus;this.accepttext()

end event

type dw_branch from datawindow within w_flow
boolean visible = false
integer x = 1618
integer y = 532
integer width = 1449
integer height = 776
integer taborder = 10
boolean titlebar = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_box from datawindow within w_flow
boolean visible = false
integer x = 41
integer y = 540
integer width = 1449
integer height = 776
integer taborder = 30
boolean titlebar = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type st_box_red_1 from statictext within w_flow
boolean visible = false
integer x = 1298
integer y = 188
integer width = 32
integer height = 28
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 255
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_summary from datawindow within w_flow
integer width = 2578
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;if dwo.name = 't_zoom' then
//	if ib_summary_zoomout then
//		dw_summary.width = ii_summary_width
//		dw_summary.height = ii_summary_height
//		dw_summary.border = true
//		ib_summary_zoomout = false
//	else
//		dw_summary.width = 170 // 82
//		dw_summary.height = 72
//		dw_summary.border = false
//		ib_summary_zoomout = true
//	end if
	if ib_summary_zoomout then
		dw_summary.width = ii_summary_width
		dw_summary.height = ii_summary_height
		dw_summary.x = 0
		dw_summary.border = true
		ib_summary_zoomout = false
	else
		//dw_summary.width = 170 // 82
		dw_summary.height = 72
		dw_summary.x = -770
		dw_summary.border = false
		ib_summary_zoomout = true
	end if
elseif dwo.name = 't_grid' then
	wf_show_grid_property(not dw_grid_property.visible)
end if

end event

