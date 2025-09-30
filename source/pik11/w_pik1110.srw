$PBExportHeader$w_pik1110.srw
$PBExportComments$** 개인별 근무타입 등록
forward
global type w_pik1110 from w_inherite_standard
end type
type rr_1 from roundrectangle within w_pik1110
end type
type rr_2 from roundrectangle within w_pik1110
end type
type dw_req from u_key_enter within w_pik1110
end type
type dw_allreg from u_key_enter within w_pik1110
end type
type dw_detail from u_d_select_sort within w_pik1110
end type
type dw_list from u_d_select_sort within w_pik1110
end type
end forward

global type w_pik1110 from w_inherite_standard
event ue_rtv_dept ( )
rr_1 rr_1
rr_2 rr_2
dw_req dw_req
dw_allreg dw_allreg
dw_detail dw_detail
dw_list dw_list
end type
global w_pik1110 w_pik1110

event ue_rtv_dept();dw_list.Retrieve()
dw_list.SelectRow(0,false)
dw_list.insertrow(1)
dw_list.SetItem(1,'deptname2','전      체')
dw_list.SelectRow(1,true)
end event

event open;call super::open;String	mod_string, err

dw_req.setTransObject(sqlca)
dw_allReg.setTransObject(sqlca)
dw_detail.setTransObject(sqlca)
dw_list.setTransObject(sqlca)

dw_req.setRow(dw_req.insertRow(0))
dw_req.Setitem(1,'sdate',left(f_today(),6)+'01')

f_set_saupcd(dw_req, 'saup', '1')
is_saupcd = gs_saupcd

dw_allReg.setRow(dw_allReg.insertRow(0))
dw_allReg.setItem(1,'ddltname','1')

event ue_rtv_dept()
p_inq.TriggerEvent(Clicked!)

dw_list.SetFocus()
end event

on w_pik1110.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_req=create dw_req
this.dw_allreg=create dw_allreg
this.dw_detail=create dw_detail
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.dw_req
this.Control[iCurrent+4]=this.dw_allreg
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.dw_list
end on

on w_pik1110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_req)
destroy(this.dw_allreg)
destroy(this.dw_detail)
destroy(this.dw_list)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1110
integer x = 4206
end type

event p_mod::clicked;call super::clicked;String	ls_empno, ls_ktype, ls_htype, ls_stype, ls_satype
long		ll_row, ll_cnt, i

ll_row = dw_detail.rowCount()

w_mdi_frame.sle_msg.text ="데이타를 저장하고 있습니다."

FOR i = 1 to ll_row

	ls_empno = dw_detail.getItemString(i,'empno')
	ls_ktype = dw_detail.getItemString(i,'ktype')
	ls_htype = dw_detail.getItemString(i,'htype')
	ls_stype = dw_detail.getItemString(i,'stype')
	ls_satype = dw_detail.getItemString(i,'satype')

	SELECT 	count(empno)
	INTO 		:ll_cnt
	FROM 		p1_ktype
	WHERE 	empno = :ls_empno;
	
	IF ll_cnt <= 0 THEN
		INSERT INTO p1_ktype
		VALUES(:ls_empno, :ls_ktype, :ls_htype, :ls_stype, :ls_satype);
	ELSE
		UPDATE p1_ktype SET
						ktype = :ls_ktype, 
						htype = :ls_htype, 
						stype = :ls_stype, 
						satype = :ls_satype
		WHERE empno = :ls_empno;
	END IF
NEXT

//MessageBox('sqlcode',string(sqlca.sqlcode))
IF sqlca.sqlcode = 0 THEN
	commit;
ELSE
	rollback;
	MessageBox(string(sqlca.sqlcode),'error message= '+SQLCA.SQLErrText)	
	w_mdi_frame.sle_msg.text ="저장에 실패하였습니다."
	return
END IF

w_mdi_frame.sle_msg.text ="저장 완료하였습니다."
end event

type p_del from w_inherite_standard`p_del within w_pik1110
boolean visible = false
integer x = 2386
integer y = 2372
end type

type p_inq from w_inherite_standard`p_inq within w_pik1110
integer x = 4027
end type

event p_inq::clicked;call super::clicked;Integer row
string ls_jjong, ls_dept, ls_type, mod_string, sSaup, sKunmu, ls_date, snull

dw_req.acceptText()
dw_list.acceptText()

row = dw_list.GetRow()
IF row <= 0 OR row > dw_list.RowCount() THEN
	parent.event ue_rtv_dept()
	dw_list.SelectRow(1,True)
	row = 1
END IF

ls_dept = dw_list.GetItemString(row,'deptcode')
ls_jjong = dw_req.getItemString(1,'jikjong')
ls_type = dw_req.getItemString(1,'stype')
sSaup = trim(dw_req.GetItemString(1,"saup"))
sKunmu = trim(dw_req.GetItemString(1,"kunmu"))
ls_date = dw_req.GetitemString(1,'sdate')


w_mdi_frame.sle_msg.text ="데이타를 조회하고 있습니다."

IF ls_dept = '' OR IsNull(ls_dept) THEN ls_dept = '%'	
IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF isNull(ls_jjong) or ls_jjong = '' THEN ls_jjong = '%'
IF isNull(ls_type) or ls_type = '' THEN ls_type = '%'
IF isNull(ls_date) or ls_date = '' THEN 
	messagebox("확인","기준일자를 입력하세요!")
	dw_req.Setcolumn('sdate')
	dw_req.Setfocus()
	return
else
	if f_datechk(ls_date) = -1 then
		messagebox("확인","기준일자를 확인하세요!")
		dw_req.Setitem(1,'sdate', snull)
		dw_req.Setcolumn('sdate')
		dw_req.Setfocus()
		return
	end if
end if

IF dw_detail.retrieve(ls_date,ls_jjong,ls_dept,ls_type,sSaup,sKunmu) < 1 THEN
	w_mdi_frame.sle_msg.text ="조회된 데이타가 없습니다."
ELSE
	w_mdi_frame.sle_msg.text ="데이타를 조회했습니다."
	dw_list.SetFocus()
END IF

return


end event

type p_print from w_inherite_standard`p_print within w_pik1110
boolean visible = false
integer x = 1682
integer y = 2372
end type

type p_can from w_inherite_standard`p_can within w_pik1110
boolean visible = false
integer x = 2560
integer y = 2372
end type

type p_exit from w_inherite_standard`p_exit within w_pik1110
end type

type p_ins from w_inherite_standard`p_ins within w_pik1110
boolean visible = false
integer x = 1861
integer y = 2372
end type

type p_search from w_inherite_standard`p_search within w_pik1110
boolean visible = false
integer x = 1504
integer y = 2372
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1110
boolean visible = false
integer x = 2034
integer y = 2372
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1110
boolean visible = false
integer x = 2208
integer y = 2372
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1110
boolean visible = false
integer x = 1239
integer y = 2380
end type

type st_window from w_inherite_standard`st_window within w_pik1110
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1110
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1110
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1110
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1110
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1110
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1110
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1110
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1110
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1110
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1110
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1110
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1110
boolean visible = false
end type

type rr_1 from roundrectangle within w_pik1110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1344
integer y = 284
integer width = 3017
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pik1110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 229
integer y = 284
integer width = 1088
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_req from u_key_enter within w_pik1110
integer x = 210
integer y = 32
integer width = 2327
integer height = 240
integer taborder = 11
string title = "none"
string dataobject = "d_pik1110_1"
boolean border = false
end type

event editchanged;call super::editchanged;String ls_chk

acceptText()
ls_chk = getItemString(1,'sdeptcode')

IF GetColumnName() = "sdeptcode" THEN
	IF isNull(ls_chk) or ls_chk = "" THEN
		setItem(1,'sdeptname','')
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF dwo.Name = 'saup' OR &
	dwo.Name = 'kunmu' OR &
   dwo.Name = 'jikjong' OR &
	dwo.Name = 'stype' THEN 
		p_inq.TriggerEvent(Clicked!)
END IF
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF dw_req.GetColumnName() = "sdeptcode" THEN
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_req.SetITem(1,"sdeptcode",gs_code)
	dw_req.SetITem(1,"sdeptname",gs_codename)
	p_inq.TriggerEvent(Clicked!)
END IF
end event

type dw_allreg from u_key_enter within w_pik1110
integer x = 2683
integer y = 16
integer width = 855
integer height = 252
integer taborder = 21
string title = "none"
string dataobject = "d_pik1110_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;long ll_rows, i
String ls_regNum

dw_allReg.acceptText()

IF dw_allReg.GetColumnName() = 'ddwtype' THEN
	CHOOSE CASE dw_allReg.getItemString(1,'ddltname')
		CASE '1' 
			ls_regNum = 'ktype'
		CASE '2' 
			ls_regNum = 'htype'
		CASE '3' 
			ls_regNum = 'stype'
		CASE '4' 
			ls_regNum = 'satype'			
END CHOOSE

	IF dw_allReg.GetColumnName() = 'ddwtype' THEN
		ll_rows = dw_detail.rowCount()

		for i = 1 to ll_rows
			dw_detail.setItem(i,ls_regNum,dw_allReg.getItemString(1,"ddwtype"))
		next

	END IF
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_detail from u_d_select_sort within w_pik1110
event ue_pressenter pbm_dwnprocessenter
integer x = 1362
integer y = 292
integer width = 2981
integer height = 2028
integer taborder = 21
string dataobject = "d_pik1110_3"
boolean hscrollbar = false
boolean border = false
end type

event type long ue_pressenter();Send(Handle(this), 256, 9, 0)
Return 1
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

type dw_list from u_d_select_sort within w_pik1110
integer x = 242
integer y = 296
integer width = 1056
integer height = 2020
integer taborder = 11
string dataobject = "d_pik1110_4"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow <= 0 then
	this.SelectRow(0,False)
	b_flag =True
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(CurrentRow, TRUE)
	b_flag = False
	p_inq.TriggerEvent(Clicked!)
END IF
end event

event clicked;int li_idx,li_loc, li_i
long ll_clickedrow, ll_cur_row
String ls_raised = '6' , ls_lowered = '5' 
string ls_keydowntype,ls_dwobject, ls_tabkey = '~t', ls_dwobject_name
String ls_modify, ls_setsort, ls_rc, ls_sort_title, ls_col_no
DataWindow dw_sort

SetPointer(HourGlass!)

ls_dwobject = GetObjectAtPointer()
li_loc = Pos(ls_dwobject, ls_tabkey)
If li_loc = 0 Then Return
ls_dwobject_name = Left(ls_dwobject, li_loc - 1)
//유 상웅 추가(99.04) 헤드에 _t가 없으면 바로 RETURN  
if '_t' <> Right(ls_dwobject_name, 2) then return 
	
//IF b_flag =False THEN 
//	b_flag =True
//	RETURN
//END IF 
If ls_dwobject_name = 'type'  Then
	If Describe(ls_dwobject_name + ".border") = ls_lowered Then
		ls_modify = ls_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'오름차순'"
	Else
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'내림차순'"
	End If

	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If
	uf_sort(is_old_dwobject_name)
	Return
End If

If is_old_dwobject_name <> ls_dwobject_name Then 
	If uf_sort(ls_dwobject_name) = -1 Then Return
	If is_old_dwobject_name = "" Then
		ls_col_no = String(Describe("datawindow.column.count"))
		For li_i = 1 To Integer(ls_col_no)
			If Describe("#" + ls_col_no + ".border") = ls_lowered Then
				is_old_dwobject_name = Describe("#" + ls_col_no + &
				 + ".name") + "_t"
				is_old_color = Describe(is_old_dwobject_name + ".color")
				Exit
			End If
		Next
	End If
	If is_old_dwobject_name <> "" Then
		ls_modify = is_old_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + &
		 is_old_dwobject_name + ".color=" + is_old_color
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
	End If
	is_old_color = Describe(ls_dwobject_name + ".color")
	ls_modify = ls_dwobject_name + ".border=" + ls_lowered
	ls_modify = ls_modify + " " + &
	 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If

	is_old_dwobject_name = ls_dwobject_name
End If


If Row <= 0 then
	this.SelectRow(0,False)
//	b_flag =True
END IF

end event

