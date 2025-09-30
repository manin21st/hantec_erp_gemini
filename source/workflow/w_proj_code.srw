$PBExportHeader$w_proj_code.srw
forward
global type w_proj_code from w_inherite
end type
type dw_1 from datawindow within w_proj_code
end type
type st_3 from statictext within w_proj_code
end type
type sle_1 from singlelineedit within w_proj_code
end type
type sle_2 from singlelineedit within w_proj_code
end type
type dw_head from datawindow within w_proj_code
end type
type p_2 from uo_picture within w_proj_code
end type
type p_3 from uo_picture within w_proj_code
end type
type p_4 from uo_picture within w_proj_code
end type
type p_1 from uo_picture within w_proj_code
end type
type p_5 from uo_picture within w_proj_code
end type
type p_6 from uo_picture within w_proj_code
end type
type st_2 from statictext within w_proj_code
end type
type st_4 from statictext within w_proj_code
end type
type rr_1 from roundrectangle within w_proj_code
end type
type rr_2 from roundrectangle within w_proj_code
end type
type rr_3 from roundrectangle within w_proj_code
end type
type rr_4 from roundrectangle within w_proj_code
end type
end forward

global type w_proj_code from w_inherite
integer width = 4622
integer height = 2448
string title = "연구과제 등록"
dw_1 dw_1
st_3 st_3
sle_1 sle_1
sle_2 sle_2
dw_head dw_head
p_2 p_2
p_3 p_3
p_4 p_4
p_1 p_1
p_5 p_5
p_6 p_6
st_2 st_2
st_4 st_4
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_proj_code w_proj_code

type variables
string is_save_chk
end variables

on w_proj_code.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_3=create st_3
this.sle_1=create sle_1
this.sle_2=create sle_2
this.dw_head=create dw_head
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_1=create p_1
this.p_5=create p_5
this.p_6=create p_6
this.st_2=create st_2
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.sle_2
this.Control[iCurrent+5]=this.dw_head
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.p_3
this.Control[iCurrent+8]=this.p_4
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.p_5
this.Control[iCurrent+11]=this.p_6
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
this.Control[iCurrent+16]=this.rr_3
this.Control[iCurrent+17]=this.rr_4
end on

on w_proj_code.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.dw_head)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_1)
destroy(this.p_5)
destroy(this.p_6)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;long ll_return 
String ls_Manager, ls_code

is_save_chk = '0'

dw_insert.settransobject(sqlca) 
dw_1.settransobject(sqlca)
dw_head.SetTransObject(sqlca)
//ll_return = dw_insert.retrieve()

ll_return = dw_head.retrieve()

If ll_return < 1 then return 

ls_code = dw_head.getitemstring(1, 'proc_code')
dw_insert.Retrieve(ls_code)


//ls_manager = dw_insert.object.manager_empno[1] 
//
//sle_1.text = ls_manager 
//
//sle_1.triggerevent('modified')
end event

type dw_insert from w_inherite`dw_insert within w_proj_code
integer x = 14
integer y = 848
integer width = 2862
integer height = 1388
string dataobject = "d_project_code_head"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row > 0 Then
	selectRow(0, False)
	selectRow(row, true)
Else
	selectRow(0, False)
	Return
End If

if RowCount() < 1 then return 

long ll_seq, ll_row
string sCode

ll_row = row

sCode  = dw_insert.GetItemString(ll_row, 'proc_code')
ll_seq = dw_insert.object.seq[ll_row]

dw_1.retrieve(sCode, ll_seq)

w_mdi_frame.sle_msg.text = '조회되었습니다.!'
end event

event dw_insert::itemchanged;call super::itemchanged;string ls_dept, ls_deptcode, ls_deptname, ls_co_dept, ls_co_deptcode, ls_co_deptname

if dwo.type = 'column' and dwo.name = 'deptname' then

	//Project Code
	ls_dept = gettext() 
	
	select deptcode, deptname 
	  into :ls_deptcode, :ls_deptname 
	  from p0_dept
	 where deptcode = :ls_dept
	    or deptname = :ls_dept ; 
	if sqlca.sqlcode <> 0  then 
		messagebox('확인', '잘못된 부서정보를 입력하셧습니다') 
		dw_insert.setrow(row)
		dw_insert.setcolumn('deptname')
		return
	end if 
	
	dw_insert.object.deptcode[row] = 	ls_deptcode
	dw_insert.object.deptname[row] = 	ls_deptname
	
elseif dwo.type = 'column' and dwo.name = 'co_deptname' then

	//Project Code
	ls_dept = gettext()
	
	select deptcode, deptname 
	  into :ls_deptcode, :ls_deptname 
	  from p0_dept
	 where trim(deptcode) = :ls_dept
	    or trim(deptname) = :ls_dept ; 
	if sqlca.sqlcode <> 0  then 
		messagebox('확인', '잘못된 부서정보를 입력하셧습니다') 
		dw_insert.setrow(row)
		dw_insert.setcolumn('co_deptname')
		return
	end if 
	
	dw_insert.object.co_deptcode[row] = 	ls_deptcode
	dw_insert.object.co_deptname[row] = 	ls_deptname
elseif dwo.type = 'column' and dwo.name = 'co_deptname2' then

	//Project Code
	ls_dept = gettext()
	
	select deptcode, deptname 
	  into :ls_deptcode, :ls_deptname 
	  from p0_dept
	 where trim(deptcode) = :ls_dept
	    or trim(deptname) = :ls_dept ; 
	if sqlca.sqlcode <> 0  then 
		messagebox('확인', '잘못된 부서정보를 입력하셧습니다') 
		dw_insert.setrow(row)
		dw_insert.setcolumn('co_deptname2')
		return
	end if 
	
	dw_insert.object.co_deptcode2[row] = 	ls_deptcode
	dw_insert.object.co_deptname2[row] = 	ls_deptname
elseif dwo.type = 'column' and dwo.name = 'co_deptname3' then

	//Project Code
	ls_dept = gettext()
	
	select deptcode, deptname 
	  into :ls_deptcode, :ls_deptname 
	  from p0_dept
	 where trim(deptcode) = :ls_dept
	    or trim(deptname) = :ls_dept ; 
	if sqlca.sqlcode <> 0  then 
		messagebox('확인', '잘못된 부서정보를 입력하셧습니다') 
		dw_insert.setrow(row)
		dw_insert.setcolumn('co_deptname3')
		return
	end if 
	
	dw_insert.object.co_deptcode3[row] = 	ls_deptcode
	dw_insert.object.co_deptname3[row] = 	ls_deptname

end if 
end event

event dw_insert::rbuttondown;call super::rbuttondown;IF GetColumnName() = 'deptname' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'deptcode', gs_code)
	SetItem(row, 'deptname', gs_codename)

//	st_title2.text = uf_get_display_title2()

ELSEIF GetColumnName() = 'co_deptname' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'co_deptcode', gs_code)
	SetItem(row, 'co_deptname', gs_codename)
ELSEIF GetColumnName() = 'co_deptname2' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'co_deptcode2', gs_code)
	SetItem(row, 'co_deptname2', gs_codename)
ELSEIF GetColumnName() = 'co_deptname3' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'co_deptcode3', gs_code)
	SetItem(row, 'co_deptname3', gs_codename)

END IF


end event

type p_delrow from w_inherite`p_delrow within w_proj_code
integer x = 3991
integer y = 692
end type

event p_delrow::clicked;call super::clicked;if dw_1.getrow() < 1 then return 

dw_1.deleterow(dw_1.getrow())
w_mdi_frame.sle_msg.text = '삭제되었습니다..저장버튼을 누르세요'
ib_any_typing = true

end event

type p_addrow from w_inherite`p_addrow within w_proj_code
integer x = 3813
integer y = 692
end type

event p_addrow::clicked;call super::clicked;if dw_insert.RowCount() < 1 then return

long ll_i, ll_row, ll_max, ll_file_row, ll_seq, lh_row
string scode, sname, sempno

lh_row = dw_insert.GetRow()
scode  = dw_insert.GetItemString(lh_row, 'proc_code')
ll_seq = dw_insert.GetItemNumber(lh_row, 'seq')

dw_1.ScrollToRow(dw_1.InsertRow(0))
ll_row = dw_1.RowCount()
dw_1.setitem(ll_row, 'proc_code', scode)
dw_1.setitem(ll_row, 'seq', ll_seq)


for ll_i =1 to dw_1.rowcount()
	dw_1.object.file_seq[ll_i] = ll_i
Next

dw_1.SetColumn('file_name')
dw_1.SetFocus()

ib_any_typing = true

Return 1
end event

type p_search from w_inherite`p_search within w_proj_code
integer x = 4169
integer y = 692
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_search::clicked;call super::clicked;if dw_1.AcceptText() <> 1 then return

string sname
long i
if dw_1.Rowcount() > 0 then
	for i = 1 to dw_1.RowCount()
		sname = dw_1.GetItemString(i, 'file_name')
		
		if sname = '' or isNull(sname) then
			f_message_chk(30, '파일명')
			dw_1.setrow(i)
			dw_1.SetColumn('file_name')
			dw_1.SetFocus()			
			return 2
		end if
	Next
end if

if dw_1.update() <> 1 then
	rollback;
	f_message_chk(31, '[저장실패]')
	return
end if
	
commit;
w_mdi_frame.sle_msg.text = '저장되었습니다.!'

ib_any_typing = false
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from w_inherite`p_ins within w_proj_code
boolean visible = false
integer x = 3383
integer y = 0
end type

event p_ins::clicked;call super::clicked;long ll_i, ll_row, ll_max 

if dw_insert.rowcount() = 0 then 
	dw_insert.insertrow(0) 
	dw_insert.object.seq[1] = 1
	dw_insert.object.display_seq[1] = 1
	return 
end if 
if dw_insert.getrow() < 1 then return 

ll_row = dw_insert.insertrow(dw_insert.getrow() + 1)

ll_max = dw_insert.object.c_max[ll_row] 

dw_insert.object.seq[ll_row] = ll_max + 1 

for ll_i =1 to dw_insert.rowcount() 
	 dw_insert.object.display_seq[ll_i] = ll_i
Next 
 	
end event

type p_exit from w_inherite`p_exit within w_proj_code
integer x = 4407
integer y = 20
end type

event p_exit::clicked;//
close(parent)
end event

type p_can from w_inherite`p_can within w_proj_code
boolean visible = false
integer x = 4622
integer y = 256
end type

type p_print from w_inherite`p_print within w_proj_code
boolean visible = false
integer x = 4805
integer y = 248
end type

type p_inq from w_inherite`p_inq within w_proj_code
boolean visible = false
integer x = 4978
integer y = 248
end type

type p_del from w_inherite`p_del within w_proj_code
boolean visible = false
integer x = 3557
integer y = 0
end type

event p_del::clicked;call super::clicked;long ll_seq 


if dw_insert.getrow() < 1 then return 

ll_seq = dw_insert.object.seq[dw_insert.getrow()]
dw_insert.deleterow(dw_insert.getrow()) 


delete from flow_activity_code_file 
 where seq = :ll_seq ; 
 
commit; 
end event

type p_mod from w_inherite`p_mod within w_proj_code
boolean visible = false
integer x = 3209
integer y = 0
end type

event p_mod::clicked;call super::clicked;DW_INSERT.UPDATE() 

commit using sqlca; 
end event

type cb_exit from w_inherite`cb_exit within w_proj_code
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_proj_code
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_proj_code
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_proj_code
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_proj_code
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_proj_code
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_proj_code
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_proj_code
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_proj_code
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_proj_code
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_proj_code
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_proj_code
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_proj_code
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_proj_code
boolean visible = true
end type

type dw_1 from datawindow within w_proj_code
integer x = 2903
integer y = 848
integer width = 1605
integer height = 1388
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_project_code_detail"
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_proj_code
boolean visible = false
integer x = 439
integer y = 1360
integer width = 677
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "[프로젝트 총괄담당자]"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_proj_code
boolean visible = false
integer x = 1125
integer y = 1356
integer width = 306
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

event modified;string ls_empno, ls_empname
Long   ll_i 

ls_empno = this.text 
ls_empname = f_get_name('EMPNO', ls_empno) 

if ls_empname = '' or isnull(ls_empname) then 
	Messagebox('확인', '프로젝트 총괄 담당자의 이름을 확인 할 수 없습니다') 
	Return 
else
	sle_2.text = ls_empname
	if Dw_insert.rowcount() < 1 then 
		return 
	else 
		For ll_i = 1 to Dw_insert.rowcount()
			dw_insert.object.manager_empno[ll_i] = ls_empno 
		Next 
	End if 
End if 

//*************************************************************************************//
//**** 부서,담당자명 가져오기(f_get_name)
// * argument : String scolname (부서(DPTNO),담당자구분(EMPNO)),
//                     scolvalue(코드)
// * return   : String (명칭) 
//************************************************************************************//
//
//String sname
//
//
//IF scolname ="DPTNO" THEN																//부서명
//	SELECT "VNDMST"."CVNAS2"  
//     INTO :sname  
//     FROM "VNDMST"  
//    WHERE ( "VNDMST"."CVCOD" = :scolvalue ) AND ( "VNDMST"."CVGU" = '4' )  AND
//	       ( "VNDMST"."CVSTATUS" = '0' ) ;	
//ELSEIF scolname ="EMPNO" THEN															//담당자명
//	SELECT "P1_MASTER"."EMPNAME"  
//     INTO :sname  
//     FROM "P1_MASTER"  
//    WHERE "P1_MASTER"."EMPNO" = :scolvalue AND 
//	       "P1_MASTER"."SERVICEKINDCODE" <> '3'  ;
//END IF
//
//IF SQLCA.SQLCODE <> 0 THEN
//	SetNull(sname)
//END IF
//
//Return sname
end event

event rbuttondown;Gs_Code = this.text

open(w_employee_popup)

IF IsNull(Gs_code) THEN RETURN

sle_1.text = gs_code 
this.triggerevent('modified') 

end event

type sle_2 from singlelineedit within w_proj_code
boolean visible = false
integer x = 1440
integer y = 1356
integer width = 672
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
end type

type dw_head from datawindow within w_proj_code
event ue_processenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 196
integer width = 4466
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_project_code_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_processenter;send(handle(this),256,9,0)
return 1
end event

event ue_key;if keydown(keyF1!) then
	TriggerEvent(RButtonDown!)
end if
end event

event itemerror;return 1
end event

event itemchanged;string scode, sname, snull

setNull(sNull)

Choose Case GetColumnName()
	Case 'manager_empno'
		scode = Trim(GetText())
		
		select empname into :sname
		  from p1_master
		 where empno = :scode;
		
		if sqlca.sqlcode = 0 then
			setItem(GetRow(), 'empname', sname)
		else
			setItem(GetRow(), 'empname', snull)
			setItem(GetRow(), 'empname', snull)
			setColumn('manager_empno')
		end if
		
End Choose
end event

event rbuttondown;string sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

Choose Case GetColumnName()
	case 'manager_empno'
		Open(w_sawon_popup)
		
		if gs_code = '' or isNull(gs_code) then
			return
		else
			setitem(getrow(), 'manager_empno', gs_code)
			setitem(getrow(), 'empname', gs_codename)
		end if
End Choose
		
	
end event

event rowfocuschanged;string scode

selectRow(0, false)
selectRow(currentRow, True)

if currentrow <= 0 then return

scode = getitemstring(currentrow, 'proc_code')

dw_insert.Retrieve(scode)
dw_1.Reset()

w_mdi_frame.sle_msg.text = '조회되었습니다.!'
end event

type p_2 from uo_picture within w_proj_code
integer x = 3877
integer y = 20
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\행추가_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\행추가_dn.gif'
end event

event clicked;call super::clicked;long lRow

lRow = dw_head.ScrollToRow(dw_head.insertRow(0))

is_save_chk = '1'

dw_head.SetColumn('proc_code')
dw_head.SetFocus()

ib_any_typing = true
w_mdi_frame.sle_msg.text = ''
return 1
end event

type p_3 from uo_picture within w_proj_code
integer x = 4055
integer y = 20
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\행삭제_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\행삭제_dn.gif'
end event

event clicked;call super::clicked;if dw_head.RowCount() < 1 then return

long lRow, nrow
string sCode

nrow = dw_head.getrow()
if nrow <= 0 then return

sCode = dw_head.GetItemString(nrow, 'proc_code')

select count(*) into :lRow
  from flow_activity_code
 where seq <> 0;
 
if lRow > 0 then
	MessageBox('[삭제불가]', '프로세스 하위 공정이 등록되어 있습니다.~r' +&
	                         '삭제할 수 없습니다.', Exclamation!)
	return
end if

dw_head.DeleteRow(dw_head.GetRow())
w_mdi_frame.sle_msg.text = '삭제되었습니다..저장버튼을 누르세요'
ib_any_typing = true
end event

type p_4 from uo_picture within w_proj_code
integer x = 4233
integer y = 20
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\저장_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\저장_dn.gif'
end event

event clicked;call super::clicked;if dw_head.AcceptText() <> 1 then return

p_search.TriggerEvent(Clicked!)
p_6.TriggerEvent(Clicked!)
//////////////////////////////////////////
long lRow, i
string sCode, sName, sEmpno

lRow = dw_head.RowCount()

if lRow < 1 then
	if dw_head.update() <> 1 then
		rollback;
		f_Message_chk(31, '[저장실패]')
		return
	end if
	
	commit;
	
	w_mdi_frame.sle_msg.text = '저장되었습니다.!'
	
	ib_any_typing = false
	is_save_chk = '0'
	return
end if

For i = 1 to lRow
	sCode  = dw_head.GetItemString(i, 'proc_code')
	sName  = dw_head.GetItemString(i, 'proc_name')
	sEmpno = dw_head.GetItemString(i, 'manager_empno')
	
	if scode = '' or isNull(scode) then
		f_message_chk(30, '[프로세스 코드]')
		ib_any_typing = true
		dw_head.setRow(i)
		dw_head.SetColumn('proc_code')
		dw_head.SetFocus()		
		return 2
	end if
		
	if sname = '' or isNull(sname) then
		f_message_chk(30, '[프로세스 명]')
		ib_any_typing = true
		dw_head.setRow(i)
		dw_head.SetColumn('proc_name')
		dw_head.SetFocus()
		return 2
	end if
	
	if sempno = '' or isNull(sempno) then
		f_message_chk(30, '[총괄담당자]')
		ib_any_typing = true
		dw_head.setRow(i)
		dw_head.SetColumn('manager_empno')
		dw_head.SetFocus()
		return 2
	end if
Next

if dw_head.update() <> 1 then
	rollback;
	f_Message_chk(31, '[저장실패]')
	return
end if
	
commit;
w_mdi_frame.sle_msg.text = '저장되었습니다.!'

ib_any_typing = false
is_save_chk = '0'
return

end event

type p_1 from uo_picture within w_proj_code
integer x = 2258
integer y = 692
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;if dw_head.RowCount() < 1 then return
if is_save_chk <> '0' then
	MessageBox('[프로세스 저장]', '프로세스의 변경사항이 있습니다.' +&
	                              '프로세스 변경사항 저장 후 다시 시도하십시오', Exclamation!)
	return
end if

long   ll_i, ll_row, ll_max, ll_file_row, ll_seq, lh_row
string scode, sname, sempno

lh_row = dw_head.GetRow()
scode  = dw_head.GetItemString(lh_row, 'proc_code')
sname  = dw_head.GetItemString(lh_row, 'proc_name')
sempno = dw_head.GetItemString(lh_row, 'manager_empno')

dw_insert.ScrollToRow(dw_insert.InsertRow(0))
dw_insert.SetItem(dw_insert.rowcount(), 'proc_code', scode)
dw_insert.SetItem(dw_insert.rowcount(), 'proc_name', sname)
dw_insert.SetItem(dw_insert.rowcount(), 'seq', dw_insert.rowcount())
dw_insert.SetItem(dw_insert.rowcount(), 'manager_empno', sempno)

dw_insert.SetColumn('activity_name')
dw_insert.SetFocus()

ib_any_typing = true

Return 1
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\행추가_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\행추가_up.gif'
end event

type p_5 from uo_picture within w_proj_code
integer x = 2432
integer y = 692
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;if dw_insert.RowCount() < 1 then return

long lRow, lseq
string sCode

sCode = dw_insert.GetItemString(dw_insert.GetRow(), 'proc_code')
lseq  = dw_insert.GetItemNumber(dw_insert.GetRow(), 'seq')

select count(*) into :lRow
  from flow_activity_code_file
 where proc_code = :scode
   and seq = :lseq;
 
if lRow > 0 then
	MessageBox('[삭제불가]', '공정관련 산출물 등록이 되어있습니다.~r' +&
	                         '삭제할 수 없습니다.', Exclamation!)
	return
end if

dw_insert.DeleteRow(dw_insert.GetRow())
w_mdi_frame.sle_msg.text = '삭제되었습니다..저장버튼을 누르세요'

ib_any_typing = true
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\행삭제_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\행삭제_up.gif'
end event

type p_6 from uo_picture within w_proj_code
integer x = 2610
integer y = 692
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if dw_insert.AcceptText() <> 1 then return

long lRow, i
string sCode, sName, sDept

lRow = dw_insert.RowCount()

if lRow < 1 then
	if dw_insert.update() <> 1 then
		rollback;
		f_Message_chk(31, '[저장실패]')
		return
	end if
	
	commit;
	w_mdi_frame.sle_msg.text = '저장되었습니다.!'
	ib_any_typing = false
	is_save_chk = '0'
	return
end if

For i = 1 to lRow
	sName = dw_insert.GetItemString(i, 'activity_name')
	sdept = dw_insert.GetItemString(i, 'deptcode')
	
	if sname = '' or isNull(sname) then
		f_message_chk(30, '[공정명]')
		ib_any_typing = true
		dw_insert.setRow(i)
		dw_insert.SetColumn('activity_name')
		dw_insert.SetFocus()
		return 2
	end if
	
	if sdept = '' or isNull(sdept) then
		f_message_chk(30, '[주관부서]')
		ib_any_typing = true
		dw_insert.setRow(i)
		dw_insert.SetColumn('deptcode')
		dw_insert.SetFocus()
		return 2
	end if
Next


if dw_insert.update() <> 1 then
	rollback;
	f_Message_chk(31, '[저장실패]')
	return
end if
	
commit;
w_mdi_frame.sle_msg.text = '저장되었습니다.!'
ib_any_typing = false
is_save_chk = '0'
return
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\저장_up.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\저장_up.gif'
end event

type st_2 from statictext within w_proj_code
integer x = 59
integer y = 732
integer width = 1385
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 연구과제에 대한 순서 및 주관/관련부서를 등록"
boolean focusrectangle = false
end type

type st_4 from statictext within w_proj_code
integer x = 2926
integer y = 732
integer width = 782
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 공정별 산출물명을 등록"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_proj_code
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 430
integer y = 1332
integer width = 1705
integer height = 112
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_proj_code
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 656
integer width = 2880
integer height = 1600
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_proj_code
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 188
integer width = 4512
integer height = 452
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_proj_code
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2898
integer y = 656
integer width = 1618
integer height = 1600
integer cornerheight = 40
integer cornerwidth = 55
end type

