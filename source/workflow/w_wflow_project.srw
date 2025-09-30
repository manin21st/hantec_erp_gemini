$PBExportHeader$w_wflow_project.srw
$PBExportComments$프로젝트 코드 등록
forward
global type w_wflow_project from w_inherite
end type
type dw_master from datawindow within w_wflow_project
end type
type dw_detail from datawindow within w_wflow_project
end type
type dw_copy_code from datawindow within w_wflow_project
end type
type dw_copy_seq from datawindow within w_wflow_project
end type
type dw_gateway from datawindow within w_wflow_project
end type
type dw_gateway_branch from datawindow within w_wflow_project
end type
type dw_activity_branch from datawindow within w_wflow_project
end type
type dw_activity from datawindow within w_wflow_project
end type
type dw_activity_sub from datawindow within w_wflow_project
end type
type dw_activity_sub_branch from datawindow within w_wflow_project
end type
type dw_proj_detail from datawindow within w_wflow_project
end type
type dw_detail_eo from datawindow within w_wflow_project
end type
end forward

global type w_wflow_project from w_inherite
string title = "프로젝트 코드등록"
dw_master dw_master
dw_detail dw_detail
dw_copy_code dw_copy_code
dw_copy_seq dw_copy_seq
dw_gateway dw_gateway
dw_gateway_branch dw_gateway_branch
dw_activity_branch dw_activity_branch
dw_activity dw_activity
dw_activity_sub dw_activity_sub
dw_activity_sub_branch dw_activity_sub_branch
dw_proj_detail dw_proj_detail
dw_detail_eo dw_detail_eo
end type
global w_wflow_project w_wflow_project

forward prototypes
public function integer wf_copy_data (datawindow adw_data, boolean ab_detail_copy, string as_proj_code, integer ai_proj_seq, string as_new_proj_code, integer ai_new_proj_seq)
public function integer wf_signature (datawindow adw_target)
public function integer wf_copy_from_project_detail ()
public function integer wf_copy_project_detail ()
public function integer wf_copy_project ()
end prototypes

public function integer wf_copy_data (datawindow adw_data, boolean ab_detail_copy, string as_proj_code, integer ai_proj_seq, string as_new_proj_code, integer ai_new_proj_seq);long ll_row, ll_row_count
datetime ldt_null, ldt_write
boolean lb_write_proj_code
boolean lb_clear_write, lb_clear_progress, lb_project_detail

adw_data.retrieve(as_proj_code)
if ab_detail_copy then
	adw_data.setfilter('proj_seq = ' + string(ai_proj_seq))
else
	adw_data.setfilter('')
end if
adw_data.filter()

// proj_code 갱신 여부
lb_write_proj_code = (as_new_proj_code <> '' and as_new_proj_code <> as_proj_code)
// 계획, 진행률 정보 clear 여부
lb_clear_write = (adw_data.describe('prgss_rate' + '.type') = 'column')
lb_clear_progress = (adw_data.describe('prgss_empno' + '.type') = 'column')
lb_project_detail = (adw_data.describe('write_date' + '.type') = 'column')

setnull(ldt_null)
ldt_write = datetime(today(), now())

ll_row_count = adw_data.rowcount()
for ll_row = 1 to ll_row_count
	adw_data.rowscopy(ll_row, ll_row, Primary!, adw_data, ll_row_count + ll_row, Primary!)
	if lb_write_proj_code then
		adw_data.setitem(ll_row_count + ll_row, 'proj_code', as_new_proj_code)
	end if
	if ab_detail_copy then
		adw_data.setitem(ll_row_count + ll_row, 'proj_seq', ai_new_proj_seq)
	end if
	// project_detail 작성 정보 기록
	if lb_project_detail then
		adw_data.setitem(ll_row_count + ll_row, 'write_date', ldt_write)
	end if
	if lb_clear_write then
		// 계획, 진행율 clear
		adw_data.setitem(ll_row_count + ll_row, 'f_date', ldt_null)
		adw_data.setitem(ll_row_count + ll_row, 't_date', ldt_null)
		adw_data.setitem(ll_row_count + ll_row, 'prgss_rate', 0)
		adw_data.setitem(ll_row_count + ll_row, 'finish_yn', 'N')
		adw_data.setitem(ll_row_count + ll_row, 's_date', ldt_null)
		adw_data.setitem(ll_row_count + ll_row, 'e_date', ldt_null)
		// 작성 정보 기록
		adw_data.setitem(ll_row_count + ll_row, 'write_empno', gs_empno)
		adw_data.setitem(ll_row_count + ll_row, 'write_time', ldt_write)
	end if
	if lb_clear_progress then
		adw_data.setitem(ll_row_count + ll_row, 'prgss_empno', '')
		adw_data.setitem(ll_row_count + ll_row, 'prgss_time', ldt_null)
	end if
next

return 1

end function

public function integer wf_signature (datawindow adw_target);long   ll_Row, ll_RowCount
datetime ldt_now
dwItemStatus l_status

adw_target.AcceptText()

ll_Row = 0
ll_RowCount = adw_target.RowCount()
ldt_now = datetime(today(), now())
do while ll_Row <= ll_RowCount
	ll_Row = adw_target.GetNextModified(ll_Row, Primary!)
   if ll_row <= 0 then exit

	l_status = adw_target.GetItemStatus(ll_row, 0, Primary!)

	if l_status = NewModified! or l_status = DataModified! then
		adw_target.SetItem(ll_row, 'write_empno', gs_empno)
		adw_target.SetItem(ll_row, 'write_time', ldt_now)
	end if
loop

return 1

end function

public function integer wf_copy_from_project_detail ();string ls_src_proj_code, ls_tar_proj_code
integer li_src_proj_seq, li_tar_proj_seq
long ll_src_row, ll_tar_row
long ll_row, ll_row_count
datetime ldt_null, ldt_write

dw_master.accepttext()
dw_detail.accepttext()

dw_copy_seq.accepttext()
ls_src_proj_code = dw_copy_seq.getitemstring(1, 'src_proj_code')
li_src_proj_seq = dw_copy_seq.getitemdecimal(1, 'src_proj_seq')
ll_src_row = dw_master.getrow()
ls_tar_proj_code = dw_master.getitemstring(ll_src_row, 'proj_code')
li_tar_proj_seq = dw_copy_seq.getitemdecimal(1, 'copy_seq')
if dw_proj_detail.retrieve(ls_src_proj_code, li_src_proj_seq) < 1 then
	return -1
end if

ll_tar_row = dw_detail.rowcount() + 1
dw_proj_detail.rowscopy(1, 1, Primary!, dw_detail, ll_tar_row, Primary!)
dw_detail.setitem(ll_tar_row, 'proj_code', ls_tar_proj_code)
dw_detail.setitem(ll_tar_row, 'proj_seq', li_tar_proj_seq)
dw_detail.setitem(ll_tar_row, 'write_date', ldt_write)

setnull(ldt_null)
ldt_write = datetime(today(), now())
// 계획, 진행율 clear
dw_detail.setitem(ll_tar_row, 'f_date', ldt_null)
dw_detail.setitem(ll_tar_row, 't_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'prgss_rate', 0)
dw_detail.setitem(ll_tar_row, 'finish_yn', 'N')
dw_detail.setitem(ll_tar_row, 's_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'e_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'prgss_step', '')
// 작성 정보 기록
dw_detail.setitem(ll_tar_row, 'write_empno', gs_empno)
dw_detail.setitem(ll_tar_row, 'write_time', ldt_write)

wf_copy_data(dw_gateway,             true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)
wf_copy_data(dw_gateway_branch,      true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)
wf_copy_data(dw_activity,            true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)
wf_copy_data(dw_activity_branch,     true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)
wf_copy_data(dw_activity_sub,        true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)
wf_copy_data(dw_activity_sub_branch, true, ls_src_proj_code, li_src_proj_seq, ls_tar_proj_code, li_tar_proj_seq)

if dw_master.update() < 0 then
	rollback;
else
	if dw_detail.update() < 0 then
		rollback;
	else
		if dw_gateway.update() < 0 then
			rollback;
		else
			if dw_gateway_branch.update() < 0 then
				rollback;
			else
				if dw_activity.update() < 0 then
					rollback;
				else
					if dw_activity_branch.update() < 0 then
						rollback;
					else
						if dw_activity_sub.update() < 0 then
							rollback;
						else
							if dw_activity_sub_branch.update() < 0 then
								rollback;
							else
								commit;
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

return 1

end function

public function integer wf_copy_project_detail ();string ls_src_proj_code, ls_tar_proj_code
integer li_src_proj_seq, li_tar_proj_seq
long ll_src_row, ll_tar_row
long ll_row, ll_row_count
datetime ldt_null, ldt_write

dw_master.accepttext()
dw_detail.accepttext()

ll_src_row = dw_detail.getrow()
ls_src_proj_code = dw_detail.getitemstring(ll_src_row, 'proj_code')
li_src_proj_seq = dw_detail.getitemdecimal(ll_src_row, 'proj_seq')
dw_copy_seq.accepttext()
li_tar_proj_seq = dw_copy_seq.getitemdecimal(1, 'copy_seq')

ll_tar_row = dw_detail.rowcount() + 1
dw_detail.rowscopy(ll_src_row, ll_src_row, Primary!, dw_detail, ll_tar_row, Primary!)
dw_detail.setitem(ll_tar_row, 'proj_seq', li_tar_proj_seq)
dw_detail.setitem(ll_tar_row, 'write_date', ldt_write)

setnull(ldt_null)
ldt_write = datetime(today(), now())
// 계획, 진행율 clear
dw_detail.setitem(ll_tar_row, 'f_date', ldt_null)
dw_detail.setitem(ll_tar_row, 't_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'prgss_rate', 0)
dw_detail.setitem(ll_tar_row, 'finish_yn', 'N')
dw_detail.setitem(ll_tar_row, 's_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'e_date', ldt_null)
dw_detail.setitem(ll_tar_row, 'prgss_step', '')
// 작성 정보 기록
dw_detail.setitem(ll_tar_row, 'write_empno', gs_empno)
dw_detail.setitem(ll_tar_row, 'write_time', ldt_write)

wf_copy_data(dw_gateway,             true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)
wf_copy_data(dw_gateway_branch,      true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)
wf_copy_data(dw_activity,            true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)
wf_copy_data(dw_activity_branch,     true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)
wf_copy_data(dw_activity_sub,        true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)
wf_copy_data(dw_activity_sub_branch, true, ls_src_proj_code, li_src_proj_seq, '', li_tar_proj_seq)

if dw_master.update() < 0 then
	rollback;
else
	if dw_detail.update() < 0 then
		rollback;
	else
		if dw_gateway.update() < 0 then
			rollback;
		else
			if dw_gateway_branch.update() < 0 then
				rollback;
			else
				if dw_activity.update() < 0 then
					rollback;
				else
					if dw_activity_branch.update() < 0 then
						rollback;
					else
						if dw_activity_sub.update() < 0 then
							rollback;
						else
							if dw_activity_sub_branch.update() < 0 then
								rollback;
							else
								commit;
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

return 1

end function

public function integer wf_copy_project ();string ls_src_proj_code, ls_tar_proj_code
long ll_src_row, ll_tar_row
long ll_row, ll_row_count
datetime ldt_null, ldt_write

dw_master.accepttext()
dw_detail.accepttext()

ll_src_row = dw_master.getrow()
ls_src_proj_code = dw_master.getitemstring(ll_src_row, 'proj_code')
dw_copy_code.accepttext()
ls_tar_proj_code = dw_copy_code.getitemstring(1, 'copy_code')

ll_tar_row = dw_master.rowcount() + 1
dw_master.rowscopy(ll_src_row, ll_src_row, Primary!, dw_master, ll_tar_row, Primary!)
dw_master.setitem(ll_tar_row, 'proj_code', ls_tar_proj_code)
ldt_write = datetime(today(), now())
// 작성 정보 기록
dw_master.setitem(ll_tar_row, 'write_empno', gs_empno)
dw_master.setitem(ll_tar_row, 'write_time', ldt_write)

wf_copy_data(dw_detail,              false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_gateway,             false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_gateway_branch,      false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_activity,            false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_activity_branch,     false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_activity_sub,        false, ls_src_proj_code, 0, ls_tar_proj_code, 0)
wf_copy_data(dw_activity_sub_branch, false, ls_src_proj_code, 0, ls_tar_proj_code, 0)

if dw_master.update() < 0 then
	rollback;
else
	if dw_detail.update() < 0 then
		rollback;
	else
		if dw_gateway.update() < 0 then
			rollback;
		else
			if dw_gateway_branch.update() < 0 then
				rollback;
			else
				if dw_activity.update() < 0 then
					rollback;
				else
					if dw_activity_branch.update() < 0 then
						rollback;
					else
						if dw_activity_sub.update() < 0 then
							rollback;
						else
							if dw_activity_sub_branch.update() < 0 then
								rollback;
							else
								commit;
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

dw_detail.event ue_retrieve()

return 1

end function

on w_wflow_project.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.dw_copy_code=create dw_copy_code
this.dw_copy_seq=create dw_copy_seq
this.dw_gateway=create dw_gateway
this.dw_gateway_branch=create dw_gateway_branch
this.dw_activity_branch=create dw_activity_branch
this.dw_activity=create dw_activity
this.dw_activity_sub=create dw_activity_sub
this.dw_activity_sub_branch=create dw_activity_sub_branch
this.dw_proj_detail=create dw_proj_detail
this.dw_detail_eo=create dw_detail_eo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_copy_code
this.Control[iCurrent+4]=this.dw_copy_seq
this.Control[iCurrent+5]=this.dw_gateway
this.Control[iCurrent+6]=this.dw_gateway_branch
this.Control[iCurrent+7]=this.dw_activity_branch
this.Control[iCurrent+8]=this.dw_activity
this.Control[iCurrent+9]=this.dw_activity_sub
this.Control[iCurrent+10]=this.dw_activity_sub_branch
this.Control[iCurrent+11]=this.dw_proj_detail
this.Control[iCurrent+12]=this.dw_detail_eo
end on

on w_wflow_project.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.dw_copy_code)
destroy(this.dw_copy_seq)
destroy(this.dw_gateway)
destroy(this.dw_gateway_branch)
destroy(this.dw_activity_branch)
destroy(this.dw_activity)
destroy(this.dw_activity_sub)
destroy(this.dw_activity_sub_branch)
destroy(this.dw_proj_detail)
destroy(this.dw_detail_eo)
end on

event open;call super::open;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_detail_eo.SetTransObject(sqlca)
dw_proj_detail.SetTransObject(sqlca)
dw_gateway.SetTransObject(sqlca)
dw_gateway_branch.SetTransObject(sqlca)
dw_activity.SetTransObject(sqlca)
dw_activity_branch.SetTransObject(sqlca)
dw_activity_sub.SetTransObject(sqlca)
dw_activity_sub_branch.SetTransObject(sqlca)

dw_copy_code.insertrow(1)
dw_copy_seq.insertrow(1)

end event

type dw_insert from w_inherite`dw_insert within w_wflow_project
boolean visible = false
integer x = 2213
integer y = 44
integer width = 110
integer height = 64
end type

type p_delrow from w_inherite`p_delrow within w_wflow_project
integer x = 4416
integer y = 1056
end type

event p_delrow::clicked;call super::clicked;long ll_row
string ls_proj_code
int li_proj_seq
long ll_child_count

ll_row = dw_detail.getrow()
if ll_row <= 0 then return

ls_proj_code = dw_detail.getitemstring(ll_row, 'proj_code')
li_proj_seq = dw_detail.getitemdecimal(ll_row, 'proj_seq')

  SELECT count(*)
	 INTO :ll_child_count
	 FROM flow_gateway  
	WHERE proj_code = :ls_proj_code   
	  and proj_seq = :li_proj_seq ;

if ll_child_count = 0 then
	if f_msg_delete() = -1 then return  //삭제 Yes/No ?
else
	//MessageBox("삭 제", "작성한 Workflow 가 존재합니다.~r~nWorkflow 를 삭제후 다시 삭제하십시요!")
	if messagebox('삭제 확인', 'Workflow 가 존재합니다.~r~n~r~nWorkflow 전체를 삭제하시겠습니까?', question!, yesno!, 1) <> 1 then
		return -1
	end if

	  delete 
		 from flow_activity_sub_branch
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if
	
	  delete 
		 from flow_activity_sub
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if
	
	  delete 
		 from flow_activity_branch
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if
	
	  delete 
		 from flow_activity
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if

	  delete 
		 from flow_gateway_branch
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if
	
	  delete 
		 from flow_gateway
		where proj_code = :ls_proj_code
		  and proj_seq = :li_proj_seq ;
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		return -1
	end if

end if

  delete 
	 from flow_proj_detail_eo
	where proj_code = :ls_proj_code
	  and proj_seq = :li_proj_seq ;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	return -1
end if

dw_detail.DeleteRow(ll_row)

end event

type p_addrow from w_inherite`p_addrow within w_wflow_project
integer x = 4242
integer y = 1056
end type

event p_addrow::clicked;call super::clicked;string ls_proj_code
long ll_newrow

ll_newrow = dw_detail.InsertRow(0)
dw_detail.scrolltorow(ll_newrow)

ls_proj_code = dw_master.getitemstring(dw_master.getrow(), 'proj_code')
dw_detail.setitem(ll_newrow, 'proj_code', ls_proj_code)
// NewModified 에서 New! 로 변경(NotModified! 설정)
dw_detail.SetItemStatus(ll_newrow, 0, Primary!, NotModified!)

dw_detail.setfocus()

end event

type p_search from w_inherite`p_search within w_wflow_project
boolean visible = false
integer x = 3525
boolean originalsize = true
string picturename = "C:\erpman\image\세부복사_up.gif"
end type

event p_search::clicked;call super::clicked;if dw_master.getrow() <= 0 then return

dw_copy_seq.x = this.x
if dw_copy_seq.x + dw_copy_seq.width > parent.width then
	dw_copy_seq.x = parent.width - dw_copy_seq.width
end if
dw_copy_seq.y = this.y + this.height
dw_copy_seq.visible = True

// 참조 프로젝트 clear
dw_copy_seq.setitem(1, 'src_proj_code', '')

dw_copy_seq.SetColumn('copy_seq')
dw_copy_seq.SetFocus()

end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\세부복사_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\세부복사_up.gif"
end event

type p_ins from w_inherite`p_ins within w_wflow_project
integer x = 3922
end type

event p_ins::clicked;call super::clicked;long ll_newrow

ll_newrow = dw_master.insertrow(0)
dw_master.scrolltorow(ll_newrow)
dw_master.setfocus()

end event

type p_exit from w_inherite`p_exit within w_wflow_project
end type

type p_can from w_inherite`p_can within w_wflow_project
integer x = 3570
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_can::clicked;call super::clicked;if dw_master.getrow() <= 0 then return

dw_copy_code.x = this.x
if dw_copy_code.x + dw_copy_code.width > parent.width then
	dw_copy_code.x = parent.width - dw_copy_code.width
end if
dw_copy_code.y = this.y + this.height
dw_copy_code.visible = True

dw_copy_code.SetColumn('copy_code')
dw_copy_code.SetFocus()

end event

event p_can::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event p_can::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

type p_print from w_inherite`p_print within w_wflow_project
boolean visible = false
integer x = 4443
end type

type p_inq from w_inherite`p_inq within w_wflow_project
integer x = 3749
end type

event p_inq::clicked;call super::clicked;dw_master.event ue_Retrieve()

end event

type p_del from w_inherite`p_del within w_wflow_project
end type

event p_del::clicked;call super::clicked;long ll_row

ll_row = dw_master.getrow()
if ll_row > 0 then
	if dw_detail.rowcount() > 0 then
		Messagebox('삭제 불가', '세부내역의 자료가 존재합니다.', information!)
		return
	end if

	if f_msg_delete() = -1 then return  //삭제 Yes/No ?

	dw_master.DeleteRow(ll_row)
end if

end event

type p_mod from w_inherite`p_mod within w_wflow_project
integer x = 4270
end type

event p_mod::clicked;call super::clicked;dw_master.accepttext()
dw_detail.accepttext()
dw_detail_eo.accepttext()

// 작성 정보 기록
wf_signature(dw_master)
wf_signature(dw_detail)

if dw_master.update() < 0 then
	rollback;
	f_message_chk(32,'[자료저장 실패]') 
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
else
	if dw_detail.update() < 0 then
		rollback;
		f_message_chk(32,'[자료저장 실패]') 
   	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	else
		if dw_detail_eo.update() < 0 then
			rollback;
			f_message_chk(32,'[자료저장 실패]') 
			w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
		else
			commit;
			w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
		end if
	end if
end if

end event

type cb_exit from w_inherite`cb_exit within w_wflow_project
end type

type cb_mod from w_inherite`cb_mod within w_wflow_project
end type

type cb_ins from w_inherite`cb_ins within w_wflow_project
end type

type cb_del from w_inherite`cb_del within w_wflow_project
end type

type cb_inq from w_inherite`cb_inq within w_wflow_project
end type

type cb_print from w_inherite`cb_print within w_wflow_project
end type

type st_1 from w_inherite`st_1 within w_wflow_project
end type

type cb_can from w_inherite`cb_can within w_wflow_project
end type

type cb_search from w_inherite`cb_search within w_wflow_project
end type







type gb_button1 from w_inherite`gb_button1 within w_wflow_project
end type

type gb_button2 from w_inherite`gb_button2 within w_wflow_project
end type

type dw_master from datawindow within w_wflow_project
event type long ue_retrieve ( )
integer x = 37
integer y = 184
integer width = 4576
integer height = 856
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event type long ue_retrieve();long ll_rc

ll_rc = this.retrieve()

this.SelectRow(0, FALSE)
this.SelectRow(1, TRUE)

return ll_rc

end event

event rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

dw_detail.event ue_retrieve()

end event

type dw_detail from datawindow within w_wflow_project
event type long ue_retrieve ( )
integer x = 37
integer y = 1216
integer width = 4576
integer height = 1020
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event type long ue_retrieve();string ls_proj_code
long ll_rc

ls_proj_code = dw_master.getitemstring(dw_master.getrow(), 'proj_code')
ll_rc = retrieve(ls_proj_code)

dw_detail.SelectRow(0, FALSE)
dw_detail.SelectRow(1, TRUE)

return ll_rc

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF GetColumnName() = 'itnbr' THEN
	Open(w_itemas_popup)
	
	IF gs_code = '' Or IsNull(gs_code) THEN Return
	
	SetItem(row, 'itnbr', gs_code)
	SetItem(row, 'itdsc', gs_codename)
END IF
end event

event rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

end event

event doubleclicked;string	ls_window_id
boolean	lb_isopen
Window	lw_window
string	sPass
string	ls_arg, ls_proj_code
int		li_proj_seq

if row < 1 then return

SetPointer(HourGlass!)

ls_window_id = 'w_wflow_create'
	
lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = ls_window_id then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
		
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	SELECT "SUB2_T"."PASSWORD"  
	  INTO :sPass
	  FROM "SUB2_T"  
	 WHERE "SUB2_T"."WINDOW_NAME" = :ls_window_id ;

	IF sPass ="" OR IsNull(sPass) THEN
	ELSE
		OpenWithParm(W_PGM_PASS,spass)
		IF Message.StringParm = "CANCEL" THEN RETURN
	END IF		
	
	ls_proj_code = this.getitemstring(row, 'proj_code')
	li_proj_seq = this.getitemdecimal(row, 'proj_seq')
	ls_arg = ls_proj_code + '~t' + string(li_proj_seq)

	OpenSheetWithParm(lw_window, ls_arg, ls_window_id, w_mdi_frame, 0, Layered!)
end if

end event

event buttonclicked;if dwo.name = 'b_pop' and row > 0 then
	this.SetRow(row)
	dw_detail_eo.event ue_retrieve()
	dw_detail_eo.visible = true
end if

end event

event clicked;if row > 0 then
	if integer(this.Describe(dwo.Name + ".TabSequence")) = 0 then
		this.SetRow(row)
	end if
end if

end event

type dw_copy_code from datawindow within w_wflow_project
event key pbm_dwnkey
boolean visible = false
integer x = 2002
integer y = 176
integer width = 1106
integer height = 124
integer taborder = 30
boolean bringtotop = true
string dataobject = "ds_flow_project_copy_code"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event key;if key = keyEscape! then
	this.visible = false
elseif key = keyEnter! then
	this.visible = false
	wf_copy_project()
end if

end event

event losefocus;This.visible = False

end event

type dw_copy_seq from datawindow within w_wflow_project
event key pbm_dwnkey
boolean visible = false
integer x = 2002
integer y = 300
integer width = 1431
integer height = 124
integer taborder = 40
boolean bringtotop = true
string dataobject = "ds_flow_project_copy_seq"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event key;string ls_src_proj_code

if key = keyEscape! then
	this.visible = false
elseif key = keyEnter! then
	this.visible = false
	ls_src_proj_code = this.getitemstring(1, 'src_proj_code')
	if not isnull(ls_src_proj_code) and ls_src_proj_code <> '' then
		wf_copy_from_project_detail()
	else
		wf_copy_project_detail()
	end if
end if

end event

event losefocus;This.visible = False

end event

event buttonclicked;if dwo.name = 'b_ref' then
	SetNull(gs_code)
	open(w_wflow_project_detail_pop)

	IF gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(1, 'src_proj_code', gs_code)
	SetItem(1, 'src_proj_seq', long(gs_codename))

	This.visible = True
end if

end event

type dw_gateway from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 620
integer width = 1093
integer height = 96
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_gateway"
string dataobject = "dm_flow_copy_gateway"
end type

type dw_gateway_branch from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 712
integer width = 1093
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_gateway_branch"
string dataobject = "dm_flow_copy_gateway_branch"
end type

type dw_activity_branch from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 896
integer width = 1093
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_branch"
string dataobject = "dm_flow_copy_activity_branch"
end type

type dw_activity from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 804
integer width = 1093
integer height = 96
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity"
string dataobject = "dm_flow_copy_activity"
end type

type dw_activity_sub from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 992
integer width = 1093
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_sub"
string dataobject = "dm_flow_copy_activity_sub"
end type

type dw_activity_sub_branch from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 1084
integer width = 1093
integer height = 96
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_sub_branch"
string dataobject = "dm_flow_copy_activity_sub_branch"
end type

type dw_proj_detail from datawindow within w_wflow_project
boolean visible = false
integer x = 69
integer y = 528
integer width = 1093
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_proj_detail"
string dataobject = "dm_flow_copy_project_detail"
end type

type dw_detail_eo from datawindow within w_wflow_project
event type long ue_retrieve ( )
boolean visible = false
integer x = 1175
integer y = 1364
integer width = 1824
integer height = 528
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "dm_flow_project_detail_eo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event type long ue_retrieve();string ls_proj_code
int li_proj_seq
long ll_rc

ls_proj_code = dw_detail.getitemstring(dw_detail.getrow(), 'proj_code')
li_proj_seq = dw_detail.getitemnumber(dw_detail.getrow(), 'proj_seq')
ll_rc = retrieve(ls_proj_code, li_proj_seq)

this.SelectRow(0, FALSE)
this.SelectRow(1, TRUE)

return ll_rc

end event

event rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

end event

event buttonclicked;long ll_newrow
		
choose case dwo.name
	case 'b_add'
		ll_newrow = this.insertrow(1)
		this.scrolltorow(ll_newrow)
		
		this.setitem(ll_newrow, 'proj_code', dw_detail.getitemstring(dw_detail.getrow(), 'proj_code'))
		this.setitem(ll_newrow, 'proj_seq', dw_detail.getitemnumber(dw_detail.getrow(), 'proj_seq'))
		// NewModified 에서 New! 로 변경(NotModified! 설정)
		this.SetItemStatus(ll_newrow, 0, Primary!, NotModified!)
	case 'b_delete'
		if this.getrow() > 0 then
			this.deleterow(this.getrow())
		end if
	case 'b_save'
		if this.rowcount() > 0 then
			this.accepttext()
			dw_detail.setitem(dw_detail.getrow(), 'eo_seq', this.getitemnumber(1, 'eo_seq'))
			dw_detail.setitem(dw_detail.getrow(), 'eco_no', this.getitemstring(1, 'eo_no'))
		end if
		p_mod.TriggerEvent(Clicked!)
		this.visible = false
	case 'b_cancel'
		this.reset()
		this.visible = false
end choose

end event

event losefocus;this.visible = false
this.reset()

end event

