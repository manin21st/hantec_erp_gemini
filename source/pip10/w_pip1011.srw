$PBExportHeader$w_pip1011.srw
$PBExportComments$수당지급여부 등록
forward
global type w_pip1011 from w_inherite_standard
end type
type dw_1 from datawindow within w_pip1011
end type
type dw_2 from datawindow within w_pip1011
end type
type rr_2 from roundrectangle within w_pip1011
end type
end forward

global type w_pip1011 from w_inherite_standard
integer height = 2632
dw_1 dw_1
dw_2 dw_2
rr_2 rr_2
end type
global w_pip1011 w_pip1011

on w_pip1011.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_pip1011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)
dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)
dw_2.setcolumn("empno")
dw_2.setfocus()


end event

type p_mod from w_inherite_standard`p_mod within w_pip1011
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_1.Accepttext() = -1 THEN 	RETURN

//IF dw_1.RowCount() > 0 THEN
//	IF wf_requiredcheck(dw_main.GetRow()) = -1 THEN RETURN
//END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

SetPointer(HourGlass!)
FOR k = 1 TO dw_1.RowCount()
//	dw_1.SetItem(k,"totbasepay",dw_main.GetItemNumber(k,"ctotal"))
NEXT

SetPointer(Arrow!)
IF dw_1.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_1.Setfocus()
		

end event

type p_del from w_inherite_standard`p_del within w_pip1011
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_1.DeleteRow(il_currow)

IF dw_1.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_1.ScrollToRow(il_currow - 1)
		//dw_main.SetColumn("salary")
		dw_1.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_inq from w_inherite_standard`p_inq within w_pip1011
integer x = 3511
end type

event p_inq::clicked;call super::clicked;string empno, empname
w_mdi_frame.sle_msg.text = ''

dw_2.AcceptText()
empno = dw_2.getitemstring(1,"empno")
empname = dw_2.getitemstring(1,"empname")

if isnull(empno) and isnull(empname) then
	dw_1.Retrieve('%', '%')
elseif isnull(empno) and not isnull(empname) then
	dw_1.Retrieve('%',empname + '%')
elseif not isnull(empno) and isnull(empname) then
	dw_1.Retrieve(empno + '%','%')
elseif not isnull(empno) and not isnull(empname) then
	dw_1.Retrieve(empno+'%' , empname + '%')
end if

	
IF dw_1.RowCount() <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return
END IF

w_mdi_frame.sle_msg.text = " 조회 "

dw_1.ScrollToRow(dw_1.RowCount())
dw_1.SetFocus()

end event

type p_print from w_inherite_standard`p_print within w_pip1011
boolean visible = false
end type

type p_can from w_inherite_standard`p_can within w_pip1011
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

//dw_level.SetRedraw(False)
//dw_level.Reset()
//dw_level.Insertrow(0)
dw_1.Setfocus()
//dw_level.SetRedraw(True)

dw_1.Reset()
ib_any_typing = false

end event

type p_exit from w_inherite_standard`p_exit within w_pip1011
end type

type p_ins from w_inherite_standard`p_ins within w_pip1011
integer x = 3685
end type

event p_ins::clicked;call super::clicked;dw_1.insertRow(0)
end event

type p_search from w_inherite_standard`p_search within w_pip1011
boolean visible = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip1011
boolean visible = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip1011
boolean visible = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip1011
boolean visible = false
end type

type st_window from w_inherite_standard`st_window within w_pip1011
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip1011
end type

type cb_update from w_inherite_standard`cb_update within w_pip1011
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip1011
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip1011
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip1011
end type

type st_1 from w_inherite_standard`st_1 within w_pip1011
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip1011
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip1011
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip1011
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip1011
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip1011
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip1011
end type

type dw_1 from datawindow within w_pip1011
integer x = 64
integer y = 360
integer width = 4457
integer height = 1920
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1011_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event rbuttondown;//SetNull(empno)
//SetNull(empname)

IF this.GetColumnName() ="p3_allowance_emp_empno" or this.GetColumnName() ="p3_allowance_emp_empname" THEN
	Open(w_employee_popup)

	//IF IsNull(empno) THEN RETURN
	
	this.SetItem(1,"p3_allowance_emp_empno",gs_code)
	this.SetItem(1,"p3_allowance_emp_empname",gs_codename)	
	
	this.TriggerEvent(ItemChanged!)

END IF

end event

type dw_2 from datawindow within w_pip1011
integer x = 41
integer y = 28
integer width = 3387
integer height = 272
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1011_2"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;//SetNull(empno)
//SetNull(empname)

IF this.GetColumnName() ="empno" or this.GetColumnName() ="empname" THEN
	Open(w_employee_popup)

	//IF IsNull(empno) THEN RETURN
	
	this.SetItem(1,"empno",gs_code)
	this.SetItem(1,"empname",gs_codename)	
	
	this.TriggerEvent(ItemChanged!)

END IF

end event

type rr_2 from roundrectangle within w_pip1011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 352
integer width = 4485
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

