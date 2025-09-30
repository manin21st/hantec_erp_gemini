$PBExportHeader$w_pig3110.srw
$PBExportComments$차량 이력 등록
forward
global type w_pig3110 from w_inherite_standard
end type
type dw_list from u_d_select_sort within w_pig3110
end type
type dw_main from u_key_enter within w_pig3110
end type
type dw_ip from datawindow within w_pig3110
end type
type rr_1 from roundrectangle within w_pig3110
end type
type rr_2 from roundrectangle within w_pig3110
end type
end forward

global type w_pig3110 from w_inherite_standard
string title = "차량 이력 등록"
dw_list dw_list
dw_main dw_main
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
end type
global w_pig3110 w_pig3110

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);string ls_carno,  snull

SetNull(snull)


	if dw_main.accepttext() = -1 then return -1 

   ls_carno = dw_main.GetItemString(icurrow, 'carno')
	
	IF ls_carno = '' OR IsNull(ls_carno) THEN
		MessageBox("확  인", "차량번호를 입력하세요.")
		dw_main.SetColumn('carno')
		dw_main.SetFocus()
		Return -1
	END IF
	
	
Return 1
end function

on w_pig3110.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_main=create dw_main
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.dw_ip
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pig3110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_main)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)

String ls_carno

IF dw_list.Retrieve('%','%','%') <= 0 THEN
	MessageBox("확인", "조회된 자료가 없습니다.")
	Return 1
END IF

ls_carno = dw_list.GetItemString(1, 'carno')
IF dw_main.Retrieve(ls_carno, '%','%') < 1 THEN
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(), 'carno', ls_carno)
	dw_main.SetFocus()
	dw_main.SetColumn('carno')
END IF
end event

type p_mod from w_inherite_standard`p_mod within w_pig3110
end type

event p_mod::clicked;call super::clicked;long ls_modicnt, ls_delcnt
string ls_empno

w_mdi_frame.sle_msg.text =""

IF dw_main.GetRow() <=0 THEN Return
IF dw_main.AcceptText() = -1 then return 
	
IF Wf_RequiredChk(dw_main.GetRow()) = -1 THEN Return
	
IF f_dbconfirm("저장") = 2 THEN RETURN

ls_modicnt = dw_main.modifiedCount()
ls_delcnt = dw_main.DeletedCount()


IF ls_modicnt + ls_delcnt < 1 THEN
	MessageBox("저장취소", "변경 및 삭제될 자료가 없음.", Exclamation!)
	RETURN
END IF

IF dw_main.Update() = 1 THEN
	COMMIT USING SQLCA;
	MessageBox("저장", "저장성공")
ELSE
	ROLLBACK USING SQLCA;
	MessageBox("저장오류", "저장실패")
END IF

//p_inq.triggerevent(clicked!)
end event

type p_del from w_inherite_standard`p_del within w_pig3110
end type

event p_del::clicked;call super::clicked;Long ls_row
Integer ls_rtn
String ls_carno

w_mdi_frame.sle_msg.text =""	

ls_row = dw_list.GetRow()
IF ls_row < 1 THEN
	MessageBox("확인", "삭제할 자료가 없습니다.")
	Return 1
END IF

IF dw_main.RowCount() < 1 THEN Return

ls_rtn = MessageBox("삭제확인", "선택하신 자료를 삭제하시겠습니까?", &
						  Question!, YesNo!, 2)
IF ls_rtn <> 1 THEN RETURN  

dw_main.SetRedraw(false)
dw_main.DeleteRow(0)

dw_list.ScrollToRow(dw_list.GetRow())

IF dw_main.Update() = 1 THEN
	COMMIT USING SQLCA;
	MessageBox("삭제", "삭제성공")
   w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다."	
ELSE
	ROLLBACK USING SQLCA;
	MessageBox("삭제오류", "삭제실패")
END IF

ls_carno = dw_list.GetItemString(dw_list.GetRow(), 'carno')
dw_main.InsertRow(0)
dw_main.SetItem(dw_main.GetRow(), 'carno', ls_carno)
dw_main.SetColumn('carno')
dw_main.SetFocus()

dw_main.SetRedraw(true)






end event

type p_inq from w_inherite_standard`p_inq within w_pig3110
boolean visible = false
integer x = 1307
integer y = 2248
boolean enabled = false
end type

type p_print from w_inherite_standard`p_print within w_pig3110
boolean visible = false
integer x = 786
integer y = 2248
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_pig3110
end type

event p_can::clicked;call super::clicked;String ls_carno

w_mdi_frame.sle_msg.text =""	

dw_main.SetReDraw(False)
dw_main.Reset()
ls_carno = dw_list.GetItemString(dw_list.GetRow(), 'carno')
IF dw_main.retrieve(ls_carno,'%','%') < 1 THEN
   dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(), 'carno', ls_carno)
	dw_main.SetColumn('carno')
	dw_main.SetFocus()
END IF
dw_main.SetReDraw(True)
end event

type p_exit from w_inherite_standard`p_exit within w_pig3110
end type

event p_exit::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""	
end event

type p_ins from w_inherite_standard`p_ins within w_pig3110
integer x = 3689
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow, iFunctionValue
String ls_carno
w_mdi_frame.sle_msg.text =""	

ls_carno = dw_list.GetItemString(dw_list.GetRow(), 'carno')
IF dw_main.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_main.GetRow())   // fk 체크 후 메시지. 1이면 에러 없음. 
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_main.InsertRow(0)

	dw_main.ScrollToRow(iCurRow)
	
	dw_main.SetItem(iCurRow, 'carno', ls_carno)
	dw_main.SetColumn("carno")
	dw_main.SetFocus()
	
//	dw_list.SelectRow(0,False)
//	dw_list.SelectRow(iCurRow,True)
	
//	dw_list.ScrollToRow(iCurRow)

	
END IF


end event

type p_search from w_inherite_standard`p_search within w_pig3110
boolean visible = false
integer x = 613
integer y = 2248
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig3110
boolean visible = false
integer x = 960
integer y = 2248
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig3110
boolean visible = false
integer x = 1134
integer y = 2248
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig3110
boolean visible = false
integer x = 23
integer y = 2252
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_pig3110
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig3110
end type

type cb_update from w_inherite_standard`cb_update within w_pig3110
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig3110
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig3110
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig3110
end type

type st_1 from w_inherite_standard`st_1 within w_pig3110
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig3110
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig3110
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig3110
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig3110
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig3110
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig3110
end type

type dw_list from u_d_select_sort within w_pig3110
integer x = 46
integer y = 372
integer width = 1591
integer height = 1784
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pig3110_1"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
end type

event clicked;call super::clicked;String ls_carno
w_mdi_frame.sle_msg.text =""	

IF dw_list.GetClickedRow() > 0 THEN
IF Row <= 0 then
	dw_main.SelectRow(0,False)
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_main.ScrollToRow(row)
	
	dw_main.SetReDraw(False)
	ls_carno = this.GetItemString(Row, 'carno')
	IF dw_main.Retrieve(ls_carno,'%','%') < 1 THEN
		MessageBox("확인", "조회된 자료가 없습니다.")
		dw_main.InsertRow(0)
		dw_main.SetItem(dw_main.GetRow(), 'carno', ls_carno) 
		dw_main.SetColumn('carno')
		dw_main.SetFocus()
	END IF
	dw_main.SetReDraw(True)
	
END IF

CALL SUPER ::CLICKED
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow <= 0 THEN

	dw_main.SelectRow(0, False)
	
ELSE
	
	SelectRow(0, False)
	SelectRow(currentrow, TRUE)
	
	dw_main.ScrollToRow(currentrow)
END IF

end event

type dw_main from u_key_enter within w_pig3110
event ue_key pbm_dwnkey
integer x = 1733
integer y = 376
integer width = 2807
integer height = 1784
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pig3110_3"
boolean hscrollbar = true
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_carno, ls_costgbn, ls_jdate, snull
SetNull(snull)

IF this.GetColumnName() = 'carno' THEN
	ls_carno = THIS.GetText()
	
	IF ls_carno = '' OR IsNull(ls_carno) THEN
		MessageBox("확인", "차량번호를 입력하십시오.")
		this.SetItem(this.GetRow(), 'carno', snull)
		this.SetColumn('carno')
		this.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'jdate' THEN
	ls_jdate = THIS.GetText()
	
	If f_datechk(ls_jdate) = -1 Then return 1
	
	IF ls_jdate = '' OR IsNull(ls_jdate) THEN
		MessageBox("확인", "발생일자를 입력하십시오.")
		this.SetItem(this.GetRow(), 'jdate', snull)
		this.SetColumn('jdate')
		this.SetFocus()
		Return 1
	END IF
END IF




end event

type dw_ip from datawindow within w_pig3110
integer x = 73
integer y = 48
integer width = 3008
integer height = 224
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pig3110_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_cargbn, ls_useoil, ls_status

ls_cargbn = dw_ip.GetItemString(1, "cargbn")
ls_useoil = dw_ip.GetItemString(1, "useoil")
ls_status = dw_ip.GetItemString(1, "status")

if ls_cargbn = ''  or IsNull(ls_cargbn) then
		ls_cargbn = '%'
end if

if ls_useoil = ''  or IsNull(ls_useoil) then
		ls_useoil = '%'
end if



if this.GetColumnName() = "cargbn" then
	ls_cargbn = this.GetText()
end if

if this.GetColumnName() = "useoil" then
	ls_useoil = this.GetText()
end if

if this.GetColumnName() = "status" then
	ls_status = this.GetText()
end if



if dw_list.Retrieve(ls_cargbn, ls_useoil,ls_status) <= 0 then
		messagebox("확인","조회된 자료가 없습니다.")
end if
end event

type rr_1 from roundrectangle within w_pig3110
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 364
integer width = 1623
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pig3110
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1719
integer y = 364
integer width = 2834
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

