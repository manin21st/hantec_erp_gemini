$PBExportHeader$w_pik1005.srw
$PBExportComments$** 개인별 주야구분 등록
forward
global type w_pik1005 from w_inherite_standard
end type
type dw_allreg from u_key_enter within w_pik1005
end type
type rr_2 from roundrectangle within w_pik1005
end type
type rr_1 from roundrectangle within w_pik1005
end type
type dw_req from u_key_enter within w_pik1005
end type
type dw_list from u_d_select_sort within w_pik1005
end type
type dw_detail from u_d_select_sort within w_pik1005
end type
end forward

global type w_pik1005 from w_inherite_standard
string title = "개인별 주야구분 등록"
boolean maxbox = false
boolean resizable = false
event ue_rtv_dept ( )
dw_allreg dw_allreg
rr_2 rr_2
rr_1 rr_1
dw_req dw_req
dw_list dw_list
dw_detail dw_detail
end type
global w_pik1005 w_pik1005

forward prototypes
public subroutine wf_setradiobutton (integer lrow)
end prototypes

event ue_rtv_dept();dw_list.Retrieve()
dw_list.SelectRow(0,false)
dw_list.insertrow(1)
dw_list.SetItem(1,'deptname2','전      체')
dw_list.SelectRow(1,true)
end event

public subroutine wf_setradiobutton (integer lrow);int i
string snm[]

for i = 1 to lrow
	 select codenm into :snm[i]
	 from p0_ref
	 where codegbn = 'KG' and code <> '00' and code = to_char(:i);
next


if lrow = 1 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"
elseif lrow = 2 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/" 
elseif lrow = 3 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/" 
elseif lrow = 4 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/"+snm[4]+"	2/" 
elseif lrow = 5 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/"+snm[4]+"	2/"+snm[5]+"	2/" 
end if
end subroutine

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

on w_pik1005.create
int iCurrent
call super::create
this.dw_allreg=create dw_allreg
this.rr_2=create rr_2
this.rr_1=create rr_1
this.dw_req=create dw_req
this.dw_list=create dw_list
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_allreg
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_req
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_detail
end on

on w_pik1005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_allreg)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.dw_req)
destroy(this.dw_list)
destroy(this.dw_detail)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1005
integer x = 4210
end type

event p_mod::clicked;call super::clicked;String	ls_empno, ls_kunmu, ls_tag
long		ll_row, ll_cnt, i

ll_row = dw_detail.rowCount()

w_mdi_frame.sle_msg.text ="데이타를 저장하고 있습니다."

FOR i = 1 to ll_row

	ls_empno = dw_detail.getItemString(i,'empno')
	ls_kunmu = dw_detail.getItemString(i,'kunmu')
	ls_tag = dw_detail.getItemString(i,'tag')
	
	SELECT 	count(empno)
	INTO 		:ll_cnt
	FROM 		p1_kunmu
	WHERE 	empno = :ls_empno;
	
	IF ll_cnt <= 0 THEN
		INSERT INTO p1_kunmu
		VALUES(:ls_empno, :ls_kunmu, :ls_tag);
	ELSE
		UPDATE p1_kunmu SET
						kunmu = :ls_kunmu, 
						tag = :ls_tag
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

type p_del from w_inherite_standard`p_del within w_pik1005
boolean visible = false
integer x = 1234
integer y = 2308
end type

type p_inq from w_inherite_standard`p_inq within w_pik1005
integer x = 4037
end type

event p_inq::clicked;call super::clicked;Integer row, cnt,i
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
ls_type = dw_req.getItemString(1,'stype')       //급여구분
sSaup = trim(dw_req.GetItemString(1,"saup"))
sKunmu = trim(dw_req.GetItemString(1,"kunmu"))  //기본설정
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

select count(*) into :cnt from p0_ref where codegbn = 'KG' and code <> '00';

dw_detail.Object.kunmu.RadioButtons.Columns= cnt
wf_setradiobutton(cnt)
//dw_detail.Object.cgubn.values = snm[1]+"	1/"+snm[2]+"	2/" 
//dw_detail.Object.cgubn.values = "zz	1/ss	2/ee	3/" 

IF dw_detail.retrieve(ls_date,ls_jjong,ls_dept,sKunmu,sSaup,ls_type) < 1 THEN
	w_mdi_frame.sle_msg.text ="조회된 데이타가 없습니다."
ELSE
	w_mdi_frame.sle_msg.text ="데이타를 조회했습니다."
	dw_list.SetFocus()
END IF

return


end event

type p_print from w_inherite_standard`p_print within w_pik1005
boolean visible = false
integer x = 535
integer y = 2308
end type

type p_can from w_inherite_standard`p_can within w_pik1005
boolean visible = false
integer x = 1408
integer y = 2308
end type

type p_exit from w_inherite_standard`p_exit within w_pik1005
end type

type p_ins from w_inherite_standard`p_ins within w_pik1005
boolean visible = false
integer x = 713
integer y = 2308
end type

type p_search from w_inherite_standard`p_search within w_pik1005
boolean visible = false
integer x = 357
integer y = 2308
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1005
boolean visible = false
integer x = 887
integer y = 2308
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1005
boolean visible = false
integer x = 1061
integer y = 2308
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1005
boolean visible = false
integer y = 2312
end type

type st_window from w_inherite_standard`st_window within w_pik1005
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1005
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1005
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1005
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1005
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1005
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1005
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1005
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1005
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1005
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1005
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1005
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1005
boolean visible = false
end type

type dw_allreg from u_key_enter within w_pik1005
integer x = 3054
integer y = 20
integer width = 855
integer height = 252
integer taborder = 11
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1005_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;long ll_rows, i
String ls_regNum, snull

dw_allReg.acceptText()

IF dw_allReg.GetColumnName() = 'ddwtype' THEN
	ls_regNum = this.Gettext() 
		ll_rows = dw_detail.rowCount()

		for i = 1 to ll_rows
			dw_detail.setItem(i,'kunmu',ls_regNum)
		next
   
	
END IF


end event

type rr_2 from roundrectangle within w_pik1005
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

type rr_1 from roundrectangle within w_pik1005
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

type dw_req from u_key_enter within w_pik1005
integer x = 896
integer y = 32
integer width = 2185
integer height = 240
integer taborder = 11
string title = "none"
string dataobject = "d_pik1005_1"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
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

event itemchanged;call super::itemchanged;IF dwo.Name = 'saup' OR &
	dwo.Name = 'kunmu' OR &
   dwo.Name = 'jikjong' OR &
	dwo.Name = 'sdate' OR &
	dwo.Name = 'stype' THEN 
		p_inq.TriggerEvent(Clicked!)
END IF
end event

event editchanged;call super::editchanged;String ls_chk

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

ls_chk = getItemString(1,'sdeptcode')

IF GetColumnName() = "sdeptcode" THEN
	IF isNull(ls_chk) or ls_chk = "" THEN
		setItem(1,'sdeptname','')
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF
end event

type dw_list from u_d_select_sort within w_pik1005
integer x = 242
integer y = 296
integer width = 1056
integer height = 2020
integer taborder = 11
string dataobject = "d_pik1005_4"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;string snull

If CurrentRow <= 0 then
	this.SelectRow(0,False)
	b_flag =True
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(CurrentRow, TRUE)
	b_flag = False
	p_inq.TriggerEvent(Clicked!)
	dw_allreg.setitem(1,'ddwtype',snull)
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

type dw_detail from u_d_select_sort within w_pik1005
event ue_pressenter pbm_dwnprocessenter
integer x = 1362
integer y = 292
integer width = 2981
integer height = 2028
integer taborder = 11
string dataobject = "d_pik1005_3"
boolean hscrollbar = false
boolean border = false
end type

event ue_pressenter;Send(Handle(this), 256, 9, 0)
Return 1
end event

event itemchanged;call super::itemchanged;string skunmu

if this.GetColumnName() = 'kunmu' then
   skunmu = this.Gettext()
	
//	if IsNull(skunmu) or skunmu = '' then
//	else
//		this.Setitem(this.getrow(),'tag',skunmu)
//	end if
	
	
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

