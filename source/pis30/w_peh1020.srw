$PBExportHeader$w_peh1020.srw
$PBExportComments$** 학자금 수혜가족 등록
forward
global type w_peh1020 from w_inherite_standard
end type
type pb_1 from picturebutton within w_peh1020
end type
type pb_2 from picturebutton within w_peh1020
end type
type pb_3 from picturebutton within w_peh1020
end type
type pb_4 from picturebutton within w_peh1020
end type
type gb_4 from groupbox within w_peh1020
end type
type rb_1 from radiobutton within w_peh1020
end type
type rb_2 from radiobutton within w_peh1020
end type
type gb_5 from groupbox within w_peh1020
end type
type dw_main from u_key_enter within w_peh1020
end type
type dw_1 from u_key_enter within w_peh1020
end type
type rr_1 from roundrectangle within w_peh1020
end type
end forward

global type w_peh1020 from w_inherite_standard
string title = "학자금수혜가족등록"
event ue_dwtoggle pbm_custom40
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
gb_5 gb_5
dw_main dw_main
dw_1 dw_1
rr_1 rr_1
end type
global w_peh1020 w_peh1020

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
public function integer wf_itemchanged_check (string as_columnname, string as_data)
public function integer wf_required_check (integer al_row)
public function integer wf_update_check (string sempno)
public function integer wf_delete_check (string ls_empno)
end prototypes

public function integer wf_itemchanged_check (string as_columnname, string as_data);String snull,sCodeName,sCmpDate,sCmpZip
Int    il_currow,lnull,lReturnRow ,iOrderSeq
long   sAmt

SetNull(snull)
SetNull(lnull)

il_currow = dw_main.GetRow()

IF TRIM(as_data) ="" OR IsNull(as_data) THEN RETURN 1

CHOOSE CASE as_ColumnName
	CASE "relationcode"																//가족사항//
		IF IsNull(f_code_select('관계',as_data)) THEN
			MessageBox("확 인","등록되지 않은 관계코드입니다!!")
			dw_main.SetItem(il_currow,"relationcode",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "schoolgubn"		
		IF isnull(as_data) or as_data = '' THEN Return 1
		
		IF IsNull(f_check_ref('EH',as_data)) THEN
			MessageBox("확 인","등록되지 않은 학자금지급구분 입니다!!")
			dw_main.SetItem(il_currow,"schoolgubn",snull)
			Return -1
		ELSE
			Return 1
		END IF	
		
END CHOOSE

Return 1

end function

public function integer wf_required_check (integer al_row);string  ls_name,ls_schoolgubn
integer li_seq

li_seq  = dw_main.GetItemNumber(al_row,"seq")
ls_name = dw_main.GetItemString(al_row,"name")
ls_schoolgubn = dw_main.GetItemString(al_row,"schoolgubn")
	
IF IsNull(li_seq) THEN
	MessageBox("확 인","순번을 입력하십시요!!")
	dw_main.SetColumn("seq")
	dw_main.SetFocus()
	Return -1
END IF
	
IF ls_name ="" OR IsNull(ls_name) THEN
	MessageBox("확 인","성명을 입력하십시요!!")
	dw_main.SetColumn("name")
	dw_main.SetFocus()
	Return -1
END IF

IF ls_schoolgubn ="" OR IsNull(ls_schoolgubn) THEN
	MessageBox("확 인","학자금구분을 입력하십시요!!")
	dw_main.SetColumn("schoolgubn")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_update_check (string sempno);STRING sdeptcode

IF ls_updatetag = 'D' THEN
	IF li_level = 2 THEN
		SELECT "P1_MASTER"."ADDDEPTCODE"
	     INTO :sdeptcode 
	     FROM "P1_MASTER"  
	    WHERE "P1_MASTER"."EMPNO" = :sempno   ;
		  
		 IF ISNULL(sdeptcode) THEN sdeptcode  = '' 
		 
		 IF SQLCA.SQLCODE < 0 THEN
		    sdeptcode  = ''
		 END IF	  
	ELSE
		 SELECT "P1_MASTER"."DEPTCODE"
	      INTO :sdeptcode 
	      FROM "P1_MASTER"  
	     WHERE "P1_MASTER"."EMPNO" = :sempno   ;
		  
		 IF ISNULL(sdeptcode) THEN sdeptcode  = '' 
		  
		 IF SQLCA.SQLCODE < 0 THEN
			 sdeptcode  = ''
		 END IF	  
	END IF
	IF gs_dept <> sdeptcode THEN
		RETURN -1
	END IF	
END IF	

return 1
end function

public function integer wf_delete_check (string ls_empno);// 기본 마스타 자료 삭제시 하위 자료 전체 삭제

delete from p1_affiliates
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_careers
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_educations
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_families
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_foreignlicense
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_guarantee
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_language
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_license
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_military
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_orderno
 where companycode = :gs_company and orderno = :ls_empno ;

delete from p1_orders
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_passports
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_physique
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_retire
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_rewards
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_schooling
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_visa
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_wealth
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_etc
 where companycode = :gs_company and empno = :ls_empno ;

delete from p3_circledata
 where companycode = :gs_company and empno = :ls_empno ;

delete from p4_hujikhst
 where companycode = :gs_company and empno = :ls_empno ;
 
delete from p4_perkunmu
 where companycode = :gs_company and empno = :ls_empno ; 

commit using sqlca ;

return 0
end function

on w_peh1020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_5=create gb_5
this.dw_main=create dw_main
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.gb_4
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.gb_5
this.Control[iCurrent+9]=this.dw_main
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.rr_1
end on

on w_peh1020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_5)
destroy(this.dw_main)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()

pb_1.picturename =  "first.bmp"
pb_2.picturename =  "prior1.bmp"
pb_3.picturename =  "next1.bmp"
pb_4.picturename =  "last.bmp"

ib_any_typing	= False													/*항목변경*/
ib_ischanged   = False													/*변경여부*/

dw_main.Reset()
dw_main.InsertRow(0)
dw_main.SetItem(1,"companycode",gs_company)

is_status = '1'															/*등록*/


// 환경변수 근태담당부서 
SELECT dataname
	INTO :ls_dkdeptcode
	FROM syscnfg
	WHERE sysgu = 'P' and serial = 1 and lineno = '1' ;

//부서level check	
SELECT "P0_DEPT"."DEPT_LEVEL"  
  INTO :li_level
  FROM "P0_DEPT"  
 WHERE "P0_DEPT"."DEPTCODE" = :gs_dept   ;
	
IF SQLCA.SQLCODE <> 0 THEN	
	  li_level = 3
END IF	

if gs_dept = ls_dkdeptcode  then
	ls_updatetag= 'A'
else
	ls_updatetag= 'D'
end if	

end event

type p_mod from w_inherite_standard`p_mod within w_peh1020
end type

event p_mod::clicked;call super::clicked;Int il_currow
String snull

setpointer(hourglass!)

SetNull(snull)

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

IF ib_ischanged = False THEN
	IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
END IF
	
IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	ib_ischanged  = False
		
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	ib_ischanged  = True
	Return
END IF
	
dw_main.Setfocus()
setpointer(arrow!)
end event

type p_del from w_inherite_standard`p_del within w_peh1020
end type

event p_del::clicked;call super::clicked;Int il_currow ,count
String ls_empno

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return
IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)
	
IF dw_main.Update() > 0 THEN
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
		
IF il_currow = 1 OR il_currow <= dw_main.RowCount() THEN
ELSE
	dw_main.ScrollToRow(il_currow - 1)
	dw_main.SetColumn(1)
	dw_main.SetFocus()
END IF

end event

type p_inq from w_inherite_standard`p_inq within w_peh1020
integer x = 3515
end type

event p_inq::clicked;call super::clicked;String 	sEmpNo,sEmpName,sColumnName
Int      il_RowCount

dw_1.AcceptText()

sempno   = dw_1.GetItemString(1,"empno")
sempname = dw_1.GetItemString(1,"empname") 

IF IsNull(sempno) OR sempno ="" THEN 
	sempno =""
ELSE
	sColumnName = "empno"
	IF IsNull(wf_exiting_data(sColumnName,sempno,"1")) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF IsNull(sempname) OR sempname ="" THEN 
	sempname =""	
ELSE
	sColumnName = "empname"
	sempno = wf_exiting_data(sColumnName,sempname,"1")
	IF IsNull(sempno) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF (sempno ="" OR IsNull(sempno)) AND (sempname ="" OR IsNull(sempname)) THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_1.SetColumn("empname")
	dw_1.SetFocus()
	Return 
END IF

if wf_update_check(sempno) = -1 then
	MessageBox("확 인","다른 부서 사람은 등록할 수 없습니다.!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	return
end if	

dw_main.SetRedraw(False)

dw_1.Retrieve(gs_company,sempno +'%',sempname +'%')

IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
END IF
dw_main.setfocus()

dw_main.SetRedraw(True)

is_status = '2'																			/*수정*/
end event

type p_print from w_inherite_standard`p_print within w_peh1020
boolean visible = false
integer x = 539
integer y = 2684
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_peh1020
end type

event p_can::clicked;call super::clicked;
Int il_currow

SetNull(is_empno)

ib_any_typing = False

is_status = '1'								/*등록*/

dw_1.SetRedraw(False)
dw_main.SetRedraw(False)

dw_1.Reset()
dw_main.Reset()
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()

dw_1.SetRedraw(True)
dw_main.SetRedraw(True)

	

end event

type p_exit from w_inherite_standard`p_exit within w_peh1020
end type

type p_ins from w_inherite_standard`p_ins within w_peh1020
integer x = 3689
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_insrow

dw_1.AcceptText()
is_empno = dw_1.GetItemString(1,"empno")

il_currow = dw_main.GetRow()
	
IF il_currow > 0 THEN
	IF wf_required_check(il_currow) <> 1 THEN RETURN
END IF
dw_main.SetRedraw(False)

il_insrow = dw_main.InsertRow(0)
dw_main.SetItem(il_insrow,"companycode",gs_company)
dw_main.SetItem(il_insrow,"empno",is_empno)
dw_main.ScrollToRow(il_insrow)
dw_main.VScrollBar = True
dw_main.HScrollBar = True

dw_main.SetRedraw(True)
dw_main.SetItem(il_insrow,"seq",il_insrow)
dw_main.SetColumn("name")
dw_main.Setfocus()




end event

type p_search from w_inherite_standard`p_search within w_peh1020
boolean visible = false
integer x = 361
integer y = 2684
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_peh1020
boolean visible = false
integer x = 713
integer y = 2692
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_peh1020
boolean visible = false
integer x = 891
integer y = 2700
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_peh1020
boolean visible = false
integer y = 2680
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_peh1020
end type

type cb_exit from w_inherite_standard`cb_exit within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 80
boolean enabled = false
end type

type cb_update from w_inherite_standard`cb_update within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 50
boolean enabled = false
end type

event cb_update::clicked;call super::clicked;Int il_currow
String snull

setpointer(hourglass!)

SetNull(snull)

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

IF ib_ischanged = False THEN
	IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
END IF
	
IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	ib_ischanged  = False
		
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	ib_ischanged  = True
	Return
END IF
	
dw_main.Setfocus()
setpointer(arrow!)
end event

type cb_insert from w_inherite_standard`cb_insert within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 40
boolean enabled = false
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_insrow

dw_1.AcceptText()
is_empno = dw_1.GetItemString(1,"empno")

il_currow = dw_main.GetRow()
	
IF il_currow > 0 THEN
	IF wf_required_check(il_currow) <> 1 THEN RETURN
END IF
dw_main.SetRedraw(False)

il_insrow = dw_main.InsertRow(0)
dw_main.SetItem(il_insrow,"companycode",gs_company)
dw_main.SetItem(il_insrow,"empno",is_empno)
dw_main.ScrollToRow(il_insrow)
dw_main.VScrollBar = True
dw_main.HScrollBar = True

dw_main.SetRedraw(True)
dw_main.SetItem(il_insrow,"seq",il_insrow)
dw_main.SetColumn("name")
dw_main.Setfocus()




end event

type cb_delete from w_inherite_standard`cb_delete within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 60
boolean enabled = false
end type

event cb_delete::clicked;call super::clicked;Int il_currow ,count
String ls_empno

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return
IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)
	
IF dw_main.Update() > 0 THEN
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
		
IF il_currow = 1 OR il_currow <= dw_main.RowCount() THEN
ELSE
	dw_main.ScrollToRow(il_currow - 1)
	dw_main.SetColumn(1)
	dw_main.SetFocus()
END IF

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 30
boolean enabled = false
end type

event cb_retrieve::clicked;call super::clicked;String 	sEmpNo,sEmpName,sColumnName
Int      il_RowCount

dw_1.AcceptText()

sempno   = dw_1.GetItemString(1,"empno")
sempname = dw_1.GetItemString(1,"empname") 

IF IsNull(sempno) OR sempno ="" THEN 
	sempno =""
ELSE
	sColumnName = "empno"
	IF IsNull(wf_exiting_data(sColumnName,sempno,"1")) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF IsNull(sempname) OR sempname ="" THEN 
	sempname =""	
ELSE
	sColumnName = "empname"
	sempno = wf_exiting_data(sColumnName,sempname,"1")
	IF IsNull(sempno) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF (sempno ="" OR IsNull(sempno)) AND (sempname ="" OR IsNull(sempname)) THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_1.SetColumn("empname")
	dw_1.SetFocus()
	Return 
END IF

if wf_update_check(sempno) = -1 then
	MessageBox("확 인","다른 부서 사람은 등록할 수 없습니다.!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	return
end if	

dw_main.SetRedraw(False)

dw_1.Retrieve(gs_company,sempno +'%',sempname +'%')

IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
END IF
dw_main.setfocus()

dw_main.SetRedraw(True)

is_status = '2'																			/*수정*/
end event

type st_1 from w_inherite_standard`st_1 within w_peh1020
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_peh1020
boolean visible = false
integer y = 2612
integer taborder = 70
boolean enabled = false
end type

event cb_cancel::clicked;call super::clicked;
Int il_currow

SetNull(is_empno)

ib_any_typing = False

is_status = '1'								/*등록*/

dw_1.SetRedraw(False)
dw_main.SetRedraw(False)

dw_1.Reset()
dw_main.Reset()
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()

dw_1.SetRedraw(True)
dw_main.SetRedraw(True)

	

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_peh1020
end type

type sle_msg from w_inherite_standard`sle_msg within w_peh1020
integer x = 379
end type

type gb_2 from w_inherite_standard`gb_2 within w_peh1020
boolean visible = false
integer y = 2552
boolean enabled = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_peh1020
boolean visible = false
integer y = 2552
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_peh1020
end type

type pb_1 from picturebutton within w_peh1020
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 1861
integer y = 3012
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
alignment htextalign = left!
end type

event clicked;string scode,sname,sMin_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_1.SetRedraw(True)
IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF

dw_main.SetRedraw(False)
dw_main.Retrieve(gs_company,is_empno)

dw_main.SetRedraw(True)
dw_1.SetRedraw(False)

is_status = '2'																			/*수정*/
end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_2 from picturebutton within w_peh1020
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 1975
integer y = 3012
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
end type

event clicked;string scode,sname,sMax_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sname	;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_1.SetRedraw(True)
IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF

dw_main.SetRedraw(False)
dw_main.Retrieve(gs_company,is_empno)
dw_main.SetRedraw(True)
dw_1.SetRedraw(False)

is_status = '2'																			/*수정*/



end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_3 from picturebutton within w_peh1020
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2094
integer y = 3012
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
end type

event clicked;string scode,sname,sMin_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sname	;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_1.SetRedraw(True)
IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF

dw_main.SetRedraw(False)
dw_main.Retrieve(gs_company,is_empno)

dw_main.SetRedraw(True)
dw_1.SetRedraw(False)

is_status = '2'																			/*수정*/



end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_4 from picturebutton within w_peh1020
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2208
integer y = 3012
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
end type

event clicked;string scode,sname,sMax_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")

	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_1.SetRedraw(True)
IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF

dw_main.SetRedraw(False)
dw_main.Retrieve(gs_company,is_empno)

dw_main.SetRedraw(True)
dw_1.SetRedraw(False)

is_status = '2'																			/*수정*/


end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type gb_4 from groupbox within w_peh1020
boolean visible = false
integer x = 1801
integer y = 2616
integer width = 562
integer height = 276
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "정렬"
end type

type rb_1 from radiobutton within w_peh1020
boolean visible = false
integer x = 1902
integer y = 2692
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_peh1020
boolean visible = false
integer x = 1902
integer y = 2780
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
string text = "성명순"
end type

type gb_5 from groupbox within w_peh1020
boolean visible = false
integer x = 1801
integer y = 2932
integer width = 562
integer height = 196
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "자료선택"
end type

type dw_main from u_key_enter within w_peh1020
integer x = 763
integer y = 644
integer width = 3063
integer height = 1212
integer taborder = 20
string dataobject = "d_peh1010_2"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemchanged;String snull,ssql

SetNull(snull)

IF wf_Itemchanged_check(this.GetColumnName(),Trim(data)) = -1 THEN
	Return 1
END IF
ib_any_typing = True

end event

event itemerror;
String snull

SetNull(snull)

Beep(1)

IF this.GetColumnName() = 'insurancegubn' THEN
	this.SetItem(this.GetRow(),"insurancegubn",snull)	
END IF
IF this.GetColumnName() = 'taxgubn' THEN
	this.SetItem(this.GetRow(),"taxgubn",snull)	
END IF
IF this.GetColumnName() = 'respectgubn' THEN
	this.SetItem(this.GetRow(),"respectgubn",snull)		
END IF
IF this.GetColumnName() = 'rubbergubn' THEN
	this.SetItem(this.GetRow(),"rubbergubn",snull)			
END IF

Return 1
end event

event itemfocuschanged;IF dwo.name = "name"  THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF
end event

event clicked;il_select_dw =9
end event

type dw_1 from u_key_enter within w_peh1020
event ue_key pbm_dwnkey
integer x = 1166
integer y = 208
integer width = 2290
integer height = 396
integer taborder = 10
string dataobject = "d_peh1010_1"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String 	sEmpNo,sEmpName,sEnterDate,snull
Int      il_RowCount
Double   lYearCnt
			
SetNull(snull)

dw_1.Accepttext()

sle_msg.text = ''

dw_main.SetRedraw(False)

sempno = dw_1.getitemstring(1,"empno")

//sle_msg.text = '자료 조회 중'
SetPointer(HourGlass!)

If dw_1.GetColumnName() = "empname" and (sempno = "" or isnull(sempno)) Then
	sempname = this.GetText()

	sempno  = wf_exiting_data(dw_1.GetColumnName(),sempname,"1")
	IF IsNull(sempno) THEN	
		dw_main.Modify("empname.protect = 0")
		MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
		dw_1.SetItem(1,"empno",snull)
		dw_1.SetItem(1,"empname",snull)
		Return 1
	ELSE
//		if wf_update_check(sempno) = -1 then
//			MessageBox("확 인","다른 부서 사람은 등록할 수 없습니다.!!")
//			dw_1.SetItem(1,"empno",snull)
//			dw_1.SetItem(1,"empname",snull)
//			Return 1
//		end if	
		
		dw_1.SetRedraw(False)	
		dw_1.Retrieve(gs_company,sempno,'%')		
		dw_main.Retrieve(gs_company,sempno)
		dw_1.SetRedraw(TRUE)
	END IF
end if

If dw_1.GetColumnName() = "empno" Then
	sempno = this.GetText()
	
	IF IsNull(wf_exiting_data(dw_1.GetColumnName(),sempno,"1")) THEN	
		dw_main.Modify("empname.protect = 0")
		MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
		dw_1.SetItem(1,"empno",snull)
		dw_1.SetItem(1,"empname",snull)
		Return 1
	ELSE
//		if wf_update_check(sempno) = -1 then
//			MessageBox("확 인","다른 부서 사람은 등록할 수 없습니다.!!")
//			dw_1.SetItem(1,"empno",snull)
//			dw_1.SetItem(1,"empname",snull)
//			Return 1
//		end if	
		
		dw_1.SetRedraw(False)
		dw_1.Retrieve(gs_company,sempno,'%')	
		dw_main.Retrieve(gs_company,sempno)
		dw_1.SetRedraw(TRUE)
	END IF
END IF
dw_1.SetRedraw(TRUE)
dw_main.SetRedraw(True)

sle_msg.text = ''
SetPointer(Arrow!)

is_empno =sempno
ib_any_typing = False

il_select_dw = 9
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF dwo.name = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

IF dwo.name = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;
Return 1
end event

event editchanged;il_select_dw =9
ib_any_typing = True
end event

type rr_1 from roundrectangle within w_peh1020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 754
integer y = 636
integer width = 3090
integer height = 1232
integer cornerheight = 40
integer cornerwidth = 55
end type

