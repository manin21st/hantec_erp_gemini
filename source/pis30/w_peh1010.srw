$PBExportHeader$w_peh1010.srw
$PBExportComments$** 학자금 수혜가족 등록
forward
global type w_peh1010 from w_inherite_standard
end type
type dw_1 from datawindow within w_peh1010
end type
type cb_1 from commandbutton within w_peh1010
end type
type cb_2 from commandbutton within w_peh1010
end type
type dw_3 from datawindow within w_peh1010
end type
type dw_2 from u_d_popup_sort within w_peh1010
end type
type rr_1 from roundrectangle within w_peh1010
end type
type rr_2 from roundrectangle within w_peh1010
end type
type rr_3 from roundrectangle within w_peh1010
end type
end forward

global type w_peh1010 from w_inherite_standard
string title = "학자금 수혜가족 등록"
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
dw_3 dw_3
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_peh1010 w_peh1010

type variables
Int il_select_dw
String is_empno
u_ds_standard ds_1

//변경자료 저장시 flag
Boolean ib_ischanged

//현재 선택 버튼표시
String  sCurButton

//등록,수정 mode
String  is_status

//부서권한check
int li_level
string ls_updatetag,ls_dkdeptcode
end variables

forward prototypes
public function integer wf_required_check (long ag_row)
public subroutine f_dberr_check (long ag_errno, string ag_errtext)
end prototypes

public function integer wf_required_check (long ag_row);String ls_name, ls_schoolgubn, ls_schoolyear

if dw_3.AcceptText() = -1 then Return -1

ls_name = dw_3.Getitemstring(ag_row,"name")
ls_schoolgubn = dw_3.Getitemstring(ag_row,"schoolgubn")

if isnull(ls_name) then
	Messagebox("확인","수혜자이름은 필수항목입니다.!")
	dw_3.Setcolumn("name")
	dw_3.setfocus()
	Return -1
end if

if isnull(ls_schoolgubn) then
	Messagebox("확인","학자금 구분은 필수항목입니다.!")
	dw_3.Setcolumn("schoolgubn")
	dw_3.setfocus()
	Return -1
end if


Return 1
end function

public subroutine f_dberr_check (long ag_errno, string ag_errtext);if ag_errno = 1 then
	if match(ag_errtext,"무결성") = true then
		f_message_chk(1,"[자료확인]")
	else
		messagebox("Error Code = " + string(ag_errno),left(ag_errtext,100))
	end if
else
	Messagebox("Error Code = " + string(ag_errno),left(ag_errtext,90))
end if
end subroutine

on w_peh1010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_3=create dw_3
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_peh1010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetColumn("saupcd")
dw_1.SetFocus()

dw_1.setitem(1,'sdate', gs_today)
f_set_saupcd(dw_1, 'saupcd', '1')
is_saupcd = gs_saupcd
	
ib_any_typing	= False													/*항목변경*/
ib_ischanged   = False													/*변경여부*/

p_ins.enabled = false


end event

type p_mod from w_inherite_standard`p_mod within w_peh1010
end type

event p_mod::clicked;call super::clicked;long ll_currow, ll_row, ll_seq
String ls_empno

setpointer(hourglass!)

IF dw_3.Accepttext() = -1 THEN 	RETURN

ll_currow = dw_3.Getrow()

if ll_currow <= 0 then Return


////&&&&PK Setitem으로 넣기
ll_row = dw_2.Getrow()
ls_empno = dw_2.Getitemstring(ll_row,"empno")

select NVL(max(seq),0)
  into :ll_seq
 from p1_schoolfamilies
 where empno = :ls_empno ;

	if sqlca.sqlcode <> 0 then
		Return
	end if

dw_3.Setitem(ll_currow,"companycode",gs_company)
dw_3.Setitem(ll_currow,"empno",ls_empno)
dw_3.Setitem(ll_currow,"seq",(ll_seq+1))
////////////////////////////////////////////////

IF wf_required_check(ll_currow) = -1 THEN RETURN

IF dw_3.Update() = 1 THEN			
	COMMIT;
	ib_any_typing =False
	ib_ischanged  = False
		
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	ib_ischanged  = True
	Return
END IF
	
dw_3.Setfocus()
setpointer(arrow!)

p_ins.enabled = true
end event

type p_del from w_inherite_standard`p_del within w_peh1010
end type

event p_del::clicked;call super::clicked;Int li_currow ,li_count
String ls_empno

li_currow = dw_3.GetRow()
IF li_currow <=0 Then Return
IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_3.DeleteRow(li_currow)
	
IF dw_3.Update()  = 1 THEN
	ib_any_typing =False
	ib_ischanged  = False
	sle_msg.text ="자료를 삭제하였습니다!!"
	commit;
ELSE
	rollback;
	ib_any_typing =True
	ib_ischanged  = True
	Return
END IF
		
IF li_currow = 1 OR li_currow <= dw_3.RowCount() THEN
ELSE
	dw_3.ScrollToRow(li_currow - 1)
	dw_3.SetColumn(1)
	dw_3.SetFocus()
END IF

p_ins.enabled = true
end event

type p_inq from w_inherite_standard`p_inq within w_peh1010
integer x = 3515
end type

event p_inq::clicked;call super::clicked;string ls_saupcd, ls_deptcode, ls_sdate

if dw_1.Accepttext() < -1 then Return

ls_saupcd = dw_1.Getitemstring(1,"saupcd")  //사업장 코드
ls_deptcode = dw_1.Getitemstring(1,"deptcode")
ls_sdate = dw_1.GetitemString(1,'sdate')

//if isnull(ls_saupcd) then
//	Messagebox("확인","사업장은 필수 항목입니다.")
//	dw_1.Setfocus()
//	Return 
//end if

//if isnull(ls_saupcd) then
//	Messagebox("확인","사업장 구분은 필수항목입니다!")
//end if

if isnull(ls_saupcd) or ls_saupcd = '' then 
	ls_saupcd = '%'
end if
if isnull(ls_deptcode) or ls_deptcode = '' then 
	ls_deptcode = '%'
end if
if IsNull(ls_sdate) or ls_sdate = '' then
	ls_sdate = gs_today
end if

if dw_2.Retrieve(ls_deptcode, ls_sdate, ls_saupcd) < 1 then 
	Messagebox("확인","조회된 사번이 없습니다.")
	dw_1.Setfocus()
	Return 
end if

p_ins.enabled = true
end event

type p_print from w_inherite_standard`p_print within w_peh1010
boolean visible = false
integer x = 535
integer y = 2544
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_peh1010
end type

event p_can::clicked;call super::clicked;
dw_2.Reset()
dw_3.Reset()

dw_1.Setredraw(false)
dw_1.Reset()
dw_1.insertrow(0)
dw_1.Setredraw(true)

dw_1.Setfocus()

p_ins.enabled = false
end event

type p_exit from w_inherite_standard`p_exit within w_peh1010
end type

type p_ins from w_inherite_standard`p_ins within w_peh1010
integer x = 3689
end type

event p_ins::clicked;call super::clicked;long ll_row

ll_row = dw_3.insertrow(0)
dw_3.Setrow(ll_row)
dw_3.setcolumn("name")
dw_3.Setfocus()

p_ins.enabled = false
end event

type p_search from w_inherite_standard`p_search within w_peh1010
boolean visible = false
integer x = 357
integer y = 2544
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_peh1010
boolean visible = false
integer x = 709
integer y = 2544
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_peh1010
boolean visible = false
integer x = 882
integer y = 2544
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_peh1010
boolean visible = false
integer y = 2548
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_peh1010
integer x = 2213
integer taborder = 0
end type

type cb_exit from w_inherite_standard`cb_exit within w_peh1010
boolean visible = false
integer x = 2898
integer y = 2532
integer taborder = 90
boolean enabled = false
end type

type cb_update from w_inherite_standard`cb_update within w_peh1010
boolean visible = false
integer x = 1787
integer y = 2532
integer taborder = 60
boolean enabled = false
end type

event cb_update::clicked;long ll_currow, ll_row, ll_seq
String ls_empno

setpointer(hourglass!)

IF dw_3.Accepttext() = -1 THEN 	RETURN

ll_currow = dw_3.Getrow()

if ll_currow <= 0 then Return


////&&&&PK Setitem으로 넣기
ll_row = dw_2.Getrow()
ls_empno = dw_2.Getitemstring(ll_row,"empno")

select NVL(max(seq),0)
  into :ll_seq
 from p1_schoolfamilies
 where empno = :ls_empno ;

	if sqlca.sqlcode <> 0 then
		Return
	end if

dw_3.Setitem(ll_currow,"companycode",gs_company)
dw_3.Setitem(ll_currow,"empno",ls_empno)
dw_3.Setitem(ll_currow,"seq",(ll_seq+1))
////////////////////////////////////////////////

IF wf_required_check(ll_currow) = -1 THEN RETURN

IF dw_3.Update() = 1 THEN			
	COMMIT;
	ib_any_typing =False
	ib_ischanged  = False
		
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	ib_ischanged  = True
	Return
END IF
	
dw_3.Setfocus()
setpointer(arrow!)

cb_insert.enabled = true
end event

type cb_insert from w_inherite_standard`cb_insert within w_peh1010
boolean visible = false
integer x = 1417
integer y = 2532
integer taborder = 50
boolean enabled = false
end type

event cb_insert::clicked;call super::clicked;long ll_row

ll_row = dw_3.insertrow(0)
dw_3.Setrow(ll_row)
dw_3.setcolumn("name")
dw_3.Setfocus()

cb_insert.enabled = false
end event

type cb_delete from w_inherite_standard`cb_delete within w_peh1010
boolean visible = false
integer x = 2158
integer y = 2532
integer taborder = 70
boolean enabled = false
end type

event cb_delete::clicked;call super::clicked;Int li_currow ,li_count
String ls_empno

li_currow = dw_3.GetRow()
IF li_currow <=0 Then Return
IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_3.DeleteRow(li_currow)
	
IF dw_3.Update()  = 1 THEN
	ib_any_typing =False
	ib_ischanged  = False
	sle_msg.text ="자료를 삭제하였습니다!!"
	commit;
ELSE
	rollback;
	ib_any_typing =True
	ib_ischanged  = True
	Return
END IF
		
IF li_currow = 1 OR li_currow <= dw_3.RowCount() THEN
ELSE
	dw_3.ScrollToRow(li_currow - 1)
	dw_3.SetColumn(1)
	dw_3.SetFocus()
END IF

cb_insert.enabled = true
end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_peh1010
boolean visible = false
integer x = 142
integer y = 2476
integer taborder = 40
boolean enabled = false
end type

event cb_retrieve::clicked;call super::clicked;string ls_saupcd, ls_deptcode, ls_sdate

if dw_1.Accepttext() < -1 then Return

//ls_saupcd = dw_1.Getitemstring(1,"saupcd")  //사업장 코드
ls_deptcode = dw_1.Getitemstring(1,"deptcode")
ls_sdate = dw_1.GetitemString(1,'sdate')

//if isnull(ls_saupcd) then
//	Messagebox("확인","사업장은 필수 항목입니다.")
//	dw_1.Setfocus()
//	Return 
//end if

//if isnull(ls_saupcd) then
//	Messagebox("확인","사업장 구분은 필수항목입니다!")
//end if

if isnull(ls_deptcode) or ls_deptcode = '' then 
	ls_deptcode = '%'
end if
if IsNull(ls_sdate) or ls_sdate = '' then
	ls_sdate = gs_today
end if

if dw_2.Retrieve(ls_deptcode, ls_sdate) < 1 then 
	Messagebox("확인","조회된 사번이 없습니다.")
	dw_1.Setfocus()
	Return 
end if

cb_insert.enabled = true
end event

type st_1 from w_inherite_standard`st_1 within w_peh1010
integer x = 46
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_peh1010
boolean visible = false
integer x = 2528
integer y = 2532
integer taborder = 80
boolean enabled = false
end type

event cb_cancel::clicked;call super::clicked;
dw_2.Reset()
dw_3.Reset()

dw_1.Setredraw(false)
dw_1.Reset()
dw_1.insertrow(0)
dw_1.Setredraw(true)

dw_1.Setfocus()

cb_insert.enabled = false
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_peh1010
integer x = 2857
end type

type sle_msg from w_inherite_standard`sle_msg within w_peh1010
integer x = 375
end type

type gb_2 from w_inherite_standard`gb_2 within w_peh1010
boolean visible = false
integer x = 1367
integer y = 2480
integer width = 1911
integer height = 188
boolean enabled = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_peh1010
boolean visible = false
integer x = 101
integer y = 2424
integer width = 411
integer height = 188
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_peh1010
integer x = 27
end type

type dw_1 from datawindow within w_peh1010
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 279
integer y = 68
integer width = 2642
integer height = 132
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_peh1010_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(keyF1!) then
	Triggerevent(rbuttondown!)
end if

end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;if dw_1.Getcolumnname() = "deptcode" then
	open(w_dept_popup)
	
	if isnull(gs_code) then
	else
		dw_1.Setitem(1,"deptcode",gs_code)
		dw_1.Setitem(1,"deptname",gs_codename)
	end if
end if
end event

event itemchanged;String ls_deptcode, ls_deptname, snull
SetNull(snull)

dw_1.AcceptText()

ls_deptcode = dw_1.Getitemstring(1,"deptcode")

if dw_1.Getcolumnname() = "deptcode" then
	
	if isnull(ls_deptcode) or trim(ls_deptcode) = '' then
		dw_1.Setitem(1,"deptname",'')
	end if
	
end if

IF dw_1.Getcolumnname() = "saupcd" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF

IF this.GetcolumnName() ="sdate" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "퇴직기준일을 입력하세요.")
		SetItem(getrow(),'sdate',snull)
		SetColumn('sdate')
		dw_1.SetFocus()
		Return 1
   END IF
	
	IF f_datechk(data) = -1 THEN
		MessageBox("확 인", "퇴직기준일을 확인하세요.")
		SetItem(getrow(),'sdate',snull)
		SetColumn('sdate')
		dw_1.SetFocus()
		Return 1
   END IF
END IF
end event

event itemerror;Return 1
end event

type cb_1 from commandbutton within w_peh1010
boolean visible = false
integer x = 2569
integer y = 236
integer width = 635
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "학년일괄변경(증가)"
end type

event clicked;call super::clicked;
String ls_saupcd

ls_saupcd = dw_1.Getitemstring(1,"saupcd")

if isnull(ls_saupcd) then
	Messagebox("확인","학년일괄 변경은 사업장 단위로만 가능합니다!~n사업장을 선택하십시요!")
	dw_1.setcolumn("saupcd")
	dw_1.Setfocus()
	Return
end if

if Messagebox("일괄변경(증가)","사업장별 전체 일괄변경을 하시겠습니까?~n 학년증가시 대학교 1학년은 삭제됩니다. ", &
   Question!,OkCancel!) = 2 then
   Return 
end if

/////////&&&&일괄처리
SetPointer(HourGlass!)
sle_msg.text = '일괄변경 중......(사업장 단위로만 생성됩니다!)'

///////////기존의 대학교 1학년은 수혜자 명단에서 삭제.
DELETE FROM P1_SCHOOLFAMILIES 
      WHERE SCHOOLGUBN = '3' AND SCHOOLYEAR = '1' AND 
		      EMPNO IN 
						(SELECT A.EMPNO FROM P1_MASTER A,P0_DEPT B
						  WHERE A.DEPTCODE = B.DEPTCODE AND B.SAUPCD = :ls_saupcd) ;
						
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox("확인","일괄처리 형성에 실패하였습니다.")	
	RETURN 
END IF
				
//////////한 학년씩 상승
UPDATE P1_SCHOOLFAMILIES
   SET SCHOOLGUBN = DECODE(SCHOOLGUBN,'1',DECODE(SCHOOLYEAR,'3',TO_CHAR(TO_NUMBER(SCHOOLGUBN) + 1),SCHOOLGUBN),
	                                   '2',DECODE(SCHOOLYEAR,'3',TO_CHAR(TO_NUMBER(SCHOOLGUBN) + 1),SCHOOLGUBN),
												      SCHOOLGUBN),
		 SCHOOLYEAR = DECODE(SCHOOLGUBN,'1',DECODE(SCHOOLYEAR,'3','1',TO_CHAR(TO_NUMBER(SCHOOLYEAR) + 1)),
												  '2',DECODE(SCHOOLYEAR,'3','1',TO_CHAR(TO_NUMBER(SCHOOLYEAR) + 1)),
												     TO_CHAR(TO_NUMBER(SCHOOLYEAR) + 1))
 WHERE EMPNO IN (SELECT A.EMPNO FROM P1_MASTER A,P0_DEPT B
						  WHERE A.DEPTCODE = B.DEPTCODE AND B.SAUPCD = :ls_saupcd) ;
 
IF SQLCA.SQLCODE <> 0 THEN 
	Messagebox("확인","일괄처리 형성에 실패하였습니다.")
	RETURN
END IF

Commit;
/////////&&&&&

SetPointer(Arrow!)
sle_msg.text = '일괄변경 작업 완료!'

dw_3.Reset()
cb_retrieve.triggerevent(Clicked!)
end event

type cb_2 from commandbutton within w_peh1010
boolean visible = false
integer x = 3328
integer y = 236
integer width = 635
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "학년일괄변경(감소)"
end type

event clicked;call super::clicked;
String ls_saupcd

ls_saupcd = dw_1.Getitemstring(1,"saupcd")

if isnull(ls_saupcd) then
	Messagebox("확인","학년일괄 변경은 사업장 단위로만 가능합니다! ~n사업장을 선택하십시요!")
	dw_1.setcolumn("saupcd")
	dw_1.Setfocus()
	Return
end if

if Messagebox("일괄변경(감소)","사업장별 전체 일괄변경(감소)을 하시겠습니까? ~n 중학교 1학년은 삭제됩니다.", &
   Question!,OkCancel!) = 2 then
   Return 
end if

////////////&&&일괄처리
SetPointer(HourGlass!)
sle_msg.text = '일괄변경 중......(사업장 단위로만 생성됩니다!)'

///////////기존의 중학교1학년은 수혜자 명단에서 삭제.
DELETE FROM P1_SCHOOLFAMILIES 
      WHERE SCHOOLGUBN = '1' AND SCHOOLYEAR = '1' AND 
		      EMPNO IN 
				(SELECT A.EMPNO FROM P1_MASTER A,P0_DEPT B
				  WHERE A.DEPTCODE = B.DEPTCODE AND B.SAUPCD = :ls_saupcd) ;
				
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox("확인","일괄처리 형성에 실패하였습니다.")
	RETURN 
END IF
				
				
//////////한 학년씩 하강
UPDATE P1_SCHOOLFAMILIES
   SET SCHOOLGUBN = DECODE(SCHOOLGUBN,'2',DECODE(SCHOOLYEAR,'1',TO_CHAR(TO_NUMBER(SCHOOLGUBN) - 1),SCHOOLGUBN),
	                                   '3',DECODE(SCHOOLYEAR,'1',TO_CHAR(TO_NUMBER(SCHOOLGUBN) - 1),SCHOOLGUBN),
												      SCHOOLGUBN),
		 SCHOOLYEAR = DECODE(SCHOOLGUBN,'2',DECODE(SCHOOLYEAR,'1','3',TO_CHAR(TO_NUMBER(SCHOOLYEAR) - 1)),
												  '3',DECODE(SCHOOLYEAR,'1','3',TO_CHAR(TO_NUMBER(SCHOOLYEAR) - 1)),
												  TO_CHAR(TO_NUMBER(SCHOOLYEAR) - 1))
 WHERE EMPNO IN (SELECT A.EMPNO FROM P1_MASTER A,P0_DEPT B 
                  WHERE A.DEPTCODE = B.DEPTCODE AND B.SAUPCD = :ls_saupcd) ; 
 
IF SQLCA.SQLCODE <> 0 THEN 
	Messagebox("확인","일괄처리 형성에 실패하였습니다.")
	RETURN
END IF

Commit;
//////////////&&&&&&


SetPointer(Arrow!)
sle_msg.text = '일괄생성 작업 완료!'

dw_3.Reset()
cb_retrieve.triggerevent(Clicked!)

end event

type dw_3 from datawindow within w_peh1010
event ue_enterkey pbm_dwnprocessenter
integer x = 2222
integer y = 368
integer width = 2162
integer height = 1840
integer taborder = 30
string title = "none"
string dataobject = "d_peh1010_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event dberror;f_dberr_check(sqldbcode,sqlerrtext)
Return 1
end event

type dw_2 from u_d_popup_sort within w_peh1010
integer x = 293
integer y = 368
integer width = 1719
integer height = 1840
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_peh1010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;String ls_empno

if row <= 0 then Return 

ls_empno = dw_2.Getitemstring(row,"empno")

if isnull(ls_empno) then Return

Selectrow(0,false)
Selectrow(row,true)

dw_3.Retrieve(ls_empno)
dw_3.Setfocus()
end event

type rr_1 from roundrectangle within w_peh1010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 279
integer y = 356
integer width = 1742
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_peh1010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2217
integer y = 356
integer width = 2181
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_peh1010
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2496
integer y = 228
integer width = 1531
integer height = 100
integer cornerheight = 40
integer cornerwidth = 55
end type

