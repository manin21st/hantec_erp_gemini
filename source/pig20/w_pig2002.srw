$PBExportHeader$w_pig2002.srw
$PBExportComments$교육 보고서 등록
forward
global type w_pig2002 from w_inherite_standard
end type
type dw_mst from datawindow within w_pig2002
end type
type rr_1 from roundrectangle within w_pig2002
end type
end forward

global type w_pig2002 from w_inherite_standard
string title = "교육훈련 보고서 등록"
dw_mst dw_mst
rr_1 rr_1
end type
global w_pig2002 w_pig2002

type variables
str_edu    istr_edu

string is_gub
end variables

forward prototypes
public function integer wf_col_validation_chk (string scolname, string scolvalue)
public function integer wf_isu_chk (string arg_mode)
public subroutine wf_init ()
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public function integer wf_col_validation_chk (string scolname, string scolvalue);String sGetValue,sSqlValue,sNullValue,sgaej

SetNull(sNullValue)

IF scolname ="empno" THEN
	IF sColValue = '1' OR sColValue = '2' THEN
	ELSE
		dw_mst.SetItem(1,"empno",sNullValue)
		dw_mst.SetColumn("empno")
		Return -1
	END IF
END IF

Return 1

end function

public function integer wf_isu_chk (string arg_mode);string fd_isu, ls_empno, ls_eduyear, ls_eduempno
long ll_empseq

if	dw_mst.AcceptText() = -1 then return -1

ls_empno = dw_mst.GetItemString(1, "empno")
ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

select isu
into :fd_isu
from	p5_educations_s
WHERE companycode = :gs_company and
      empno       = :ls_empno   and
		eduyear     = :ls_eduyear and
		empseq      = :ll_empseq  and
		eduempno    = :ls_eduempno;
IF SQLCA.SQLCODE <> 0 THEN
   MessageBox(arg_mode + "실패", "교육훈련이수결과 등록이 ~r 되어있지 않습니다.!!")
	Return -1
end if

if fd_isu = "Y" then
   MessageBox(arg_mode + "실패", "이미 이수처리되어 있는 보고서는" + "~n" + &
                           arg_mode + "(을)를 할 수 없습니다.!!")	
   return -1
end if

return 1
end function

public subroutine wf_init ();String sNullValue

w_mdi_frame.sle_msg.text =""

SetNull(sNullValue)

dw_mst.SetRedraw(False)
dw_mst.Reset()
dw_mst.InsertRow(0)

dw_mst.SetItem(1,"companycode", gs_company)
dw_mst.SetItem(1,"empno",sNullValue)
dw_mst.SetItem(1,"eduyear", string(today(),'YYYY'))
dw_mst.SetItem(1,"empseq",sNullValue)
dw_mst.SetItem(1,"eduempno",sNullValue)
dw_mst.SetItem(1,"startdate",sNullValue)
dw_mst.SetItem(1,"enddate",sNullValue)
dw_mst.SetItem(1,"education1",sNullValue)
dw_mst.SetItem(1,"education2",sNullValue)
dw_mst.SetItem(1,"work1",sNullValue)
dw_mst.SetItem(1,"work2",snullvalue)
dw_mst.SetItem(1,"recommand1",sNullValue)
dw_mst.SetItem(1,"recommand2",sNullValue)

//dw_mst.SetColumn("empno")
//dw_mst.SetFocus()

dw_mst.SetRedraw(True)
end subroutine

public subroutine wf_setting_retrievemode (string mode);//************************************************************************************//
// **** FUNCTION NAME :WF_SETTING_RETRIEVEMODE(DATAWINDOW 제어)      					  //
//      * ARGUMENT : String mode(수정mode 인지 입력 mode 인지 구분)						  //
//		  * RETURN VALUE : 없슴 																		  //
//************************************************************************************//

dw_mst.SetRedraw(False)

p_mod.Enabled =True
IF mode ="조회" THEN							//수정
	dw_mst.SetTabOrder("empno", 0)
	dw_mst.SetTabOrder("eduyear", 0)
	dw_mst.SetTabOrder("empseq", 0)
	dw_mst.SetTabOrder("eduempno",0)

   dw_mst.Modify("empno.protect = 1")
   dw_mst.Modify("eduyear.protect = 1")
   dw_mst.Modify("empseq.protect = 1")
	
	p_del.Enabled =True
	p_ins.Enabled =True
	
ELSEIF mode ="등록" THEN					//입력
	dw_mst.SetTabOrder("empno", 10)
	dw_mst.SetTabOrder("eduyear", 20)
	dw_mst.SetTabOrder("empseq", 30)
	dw_mst.SetTabOrder("eduempno", 40)

   dw_mst.Modify("empno.protect = 0")
   dw_mst.Modify("eduyear.protect = 0")
   dw_mst.Modify("empseq.protect = 0")

	p_del.Enabled =False
	p_ins.Enabled =false	
END IF

dw_mst.SetFocus()
dw_mst.SetRedraw(True)

end subroutine

on w_pig2002.create
int iCurrent
call super::create
this.dw_mst=create dw_mst
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mst
this.Control[iCurrent+2]=this.rr_1
end on

on w_pig2002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mst)
destroy(this.rr_1)
end on

event open;call super::open;dw_mst.SetTransObject(sqlca)
dw_mst.reset()
dw_mst.insertrow(0)
dw_mst.SetItem(1, 'companycode', gs_company)
dw_mst.SetItem(1, 'eduyear', string(today(), 'YYYY'))

dw_mst.setfocus()

dw_mst.setColumn("empno")

p_ins.enabled=false
p_del.enabled=false

end event

type p_mod from w_inherite_standard`p_mod within w_pig2002
integer x = 3877
end type

event p_mod::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno
long ll_empseq, ll_row
int ll_cnt

if dw_mst.AcceptText() = -1 then return 

ll_row = dw_mst.GetRow()

ls_empno = dw_mst.GetItemString(ll_row, 'empno')
ls_eduyear = dw_mst.GetItemString(ll_row, 'eduyear')

ll_empseq = dw_mst.GetItemNumber(ll_row, 'empseq')
ls_eduempno = dw_mst.GetItemString(ll_row, 'eduempno')

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empno')
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('eduyear')	  
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('empseq')	  	  
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('eduempno')	  	  	  
     return	
	  
  end if

IF is_gub =  "등록" THEN
	SELECT count(*)
		INTO :ll_cnt
		FROM p5_educations_r
		WHERE companycode = :gs_company and
		      empno       = :ls_empno   and
				eduyear     = :ls_eduyear and
				empseq      = :ll_empseq  and
				eduempno    = :ls_eduempno;
	IF sqlca.sqlcode = 0 and ll_cnt > 0 THEN
      MessageBox("확 인", "이미 입력되어 있는 자료입니다.!! ~r 확인하십시오.!!")
		Return
	END IF
END IF

if wf_isu_chk("저장") = -1 then return  // 이수구분이 "Y"이면, 저장, 삭제할수 없다.

if f_msg_update() = -1 then return

if dw_mst.update() > 0 then
	update p5_educations_s
	set    document  = 'Y'
	WHERE companycode = :gs_company and
  	      empno       = :ls_empno   and
			eduyear     = :ls_eduyear and
			empseq      = :ll_empseq  and
			eduempno    = :ls_eduempno;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback using sqlca;
	   MessageBox("저장 실패", "교육훈련이수결과 자료가 ~r등록되어 있지 않습니다.!!")
		Return
	END IF
	commit using sqlca; // update p5_educations_s에 대한 commit
else
	rollback using sqlca;
	MessageBox("확인", "저장실패")
	return
end if

commit using sqlca; //dw_mst.update() 에 대한 commit
ib_any_typing = false

is_gub = "조회"
WF_SETTING_RETRIEVEMODE(is_gub)									//조회 MODE

w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!"

dw_mst.setfocus()
dw_mst.setcolumn('education1')

end event

type p_del from w_inherite_standard`p_del within w_pig2002
integer x = 4050
end type

event p_del::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno
string fd_isu
long ll_empseq

if	dw_mst.AcceptText() = -1 then return
	
if dw_mst.RowCount() <= 0 then
	dw_mst.setfocus()
	return
end if

ls_empno = dw_mst.GetItemString(1, "empno")
ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
	  
  end if

IF wf_isu_chk("삭제") = -1 then return         // 이수구분이 "Y" 있으면 삭제할 수 없다.

if f_msg_delete() = -1 then return

dw_mst.setredraw(false)

dw_mst.deleterow(0)
IF dw_mst.Update() = 1 THEN
	update p5_educations_s
	set    document  = 'N'
	WHERE companycode = :gs_company and
  	      empno       = :ls_empno   and
			eduyear     = :ls_eduyear and
			empseq      = :ll_empseq  and
			eduempno    = :ls_eduempno;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback using sqlca;
	   MessageBox("저장 실패", "보고서 작성에 실패하였습니다.")
		Return
	else 
		commit using sqlca;
	END IF
	COMMIT using sqlca;
	WF_INIT()
	w_mdi_frame.sle_msg.text =" 자료가 삭제되었습니다.!!!"
	p_mod.Enabled =True
	ib_any_typing=False
ELSE
   MessageBox("저장 실패", "보고서 작성에 실패하였습니다.")
	dw_mst.SetFocus()
	ROLLBACK using sqlca;	
END IF	
is_gub = "등록"

dw_mst.setredraw(true)

WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

dw_mst.setfocus()
dw_mst.setcolumn('empno')
end event

type p_inq from w_inherite_standard`p_inq within w_pig2002
integer x = 3534
end type

event p_inq::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno, &
       ls_sdate, ls_edate
long ll_empseq

if	dw_mst.AcceptText() = -1 then return
	
if dw_mst.RowCount() <= 0 then
	dw_mst.setfocus()
	return
end if

ls_empno = dw_mst.GetItemString(1, "empno")
ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

ls_sdate= dw_mst.GetItemString(1, "startdate")
ls_edate= dw_mst.GetItemString(1, "enddate")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empno')
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('eduyear')
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empseq')
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('eduempno')
     return	
	  
  end if

dw_mst.SetRedraw(false)

if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, & 
                  ll_empseq, ls_eduempno) <= 0 then
   dw_mst.reset()
   dw_mst.insertrow(0)
   dw_mst.SetItem(1, 'companycode', gs_company)		
   dw_mst.SetItem(1, 'empno', ls_empno)		
   dw_mst.SetItem(1, 'eduyear', ls_eduyear)		
   dw_mst.SetItem(1, 'empseq', ll_empseq)		
   dw_mst.SetItem(1, 'startdate', ls_sdate)		
   dw_mst.SetItem(1, 'enddate', ls_edate)				
   dw_mst.SetItem(1, 'eduempno', ls_eduempno)
	
	dw_mst.setfocus()	
	dw_mst.SetColumn('education1')

   dw_mst.SetRedraw(true)	
	is_gub = "등록"
   WF_SETTING_RETRIEVEMODE(is_gub)							
   ib_any_typing=False	
	Return
else
   dw_mst.SetRedraw(true)	
   ib_any_typing=False	
	is_gub = "조회"
   WF_SETTING_RETRIEVEMODE(is_gub)	//수정 mode 
	dw_mst.setfocus()
	dw_mst.SetColumn('education1')	
   ib_any_typing=False	
END IF

w_mdi_frame.sle_msg.text = "자료가 조회되었습니다.!!"
end event

type p_print from w_inherite_standard`p_print within w_pig2002
integer x = 4023
integer y = 5124
end type

type p_can from w_inherite_standard`p_can within w_pig2002
integer x = 4224
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

p_mod.Enabled =True

WF_INIT()

//dw_mst.SetFocus()
is_gub ="등록"

ib_any_typing=False

WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

dw_mst.setfocus()
dw_mst.setcolumn('empno')

w_mdi_frame.sle_msg.text = "자료가 취소되었습니다.!!"


end event

type p_exit from w_inherite_standard`p_exit within w_pig2002
integer x = 4398
end type

type p_ins from w_inherite_standard`p_ins within w_pig2002
integer x = 3707
end type

event p_ins::clicked;call super::clicked;long ll_cnt

setNull(gs_code)

if dw_mst.AcceptText() = -1 then return

gs_code = dw_mst.GetItemString(1, 'companycode')
istr_edu.str_empno = dw_mst.GetItemString(1, 'empno')
istr_edu.str_eduyear = dw_mst.GetItemString(1, 'eduyear')
istr_edu.str_empseq = dw_mst.GetItemNumber(1, 'empseq')
istr_edu.str_eduempno = dw_mst.GetItemString(1, 'eduempno')

 if istr_edu.str_empno="" or isnull(istr_edu.str_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
     return	  
  elseif istr_edu.str_eduyear="" or isnull(istr_edu.str_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
     return	
  elseif istr_edu.str_empseq=0 or isnull(istr_edu.str_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
     return	
  elseif istr_edu.str_eduempno="" or isnull(istr_edu.str_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
     return	
	  
  end if
  
IF is_gub = "조회" THEN
ELSE
	SELECT count(*)
		INTO :ll_cnt
		FROM p5_educations_r
		WHERE companycode = :gs_company and
		      empno       = :istr_edu.str_empno   and
				eduyear     = :istr_edu.str_eduyear and
				empseq      = :istr_edu.str_empseq  and
				eduempno    = :istr_edu.str_eduempno;
	IF sqlca.sqlcode = 0 and ll_cnt = 0 THEN
	   MessageBox("확 인", "등록되어 있는 보고서 자료가 존재하지 않습니다")
//      wf_init()
//		wf_setting_retrievemode("등록")
		Return
	END IF
END IF

IF wf_isu_chk("설문지 작성") = -1 then return         // 이수구분이 "Y" 있으면 삭제할 수 없다.  

//openwithparm(w_pig2007, istr_edu)

end event

type p_search from w_inherite_standard`p_search within w_pig2002
integer x = 3854
integer y = 5124
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig2002
integer x = 3986
integer y = 5276
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig2002
integer x = 4160
integer y = 5276
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig2002
integer x = 229
integer y = 5092
end type

type st_window from w_inherite_standard`st_window within w_pig2002
integer x = 2322
integer y = 5300
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig2002
integer x = 3319
integer y = 5128
end type

type cb_update from w_inherite_standard`cb_update within w_pig2002
integer x = 2245
integer y = 5128
integer taborder = 30
end type

event cb_update::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno
long ll_empseq, ll_row
int ll_cnt

if dw_mst.AcceptText() = -1 then return 

ll_row = dw_mst.GetRow()

ls_empno = dw_mst.GetItemString(ll_row, 'empno')
ls_eduyear = dw_mst.GetItemString(ll_row, 'eduyear')

ll_empseq = dw_mst.GetItemNumber(ll_row, 'empseq')
ls_eduempno = dw_mst.GetItemString(ll_row, 'eduempno')

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empno')
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('eduyear')	  
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('empseq')	  	  
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()	  
	  dw_mst.setColumn('eduempno')	  	  	  
     return	
	  
  end if

IF is_gub =  "등록" THEN
	SELECT count(*)
		INTO :ll_cnt
		FROM p5_educations_r
		WHERE companycode = :gs_company and
		      empno       = :ls_empno   and
				eduyear     = :ls_eduyear and
				empseq      = :ll_empseq  and
				eduempno    = :ls_eduempno;
	IF sqlca.sqlcode = 0 and ll_cnt > 0 THEN
      MessageBox("확 인", "이미 입력되어 있는 자료입니다.!! ~r 확인하십시오.!!")
		Return
	END IF
END IF

if wf_isu_chk("저장") = -1 then return  // 이수구분이 "Y"이면, 저장, 삭제할수 없다.

if f_msg_update() = -1 then return

if dw_mst.update() > 0 then
	update p5_educations_s
	set    document  = 'Y'
	WHERE companycode = :gs_company and
  	      empno       = :ls_empno   and
			eduyear     = :ls_eduyear and
			empseq      = :ll_empseq  and
			eduempno    = :ls_eduempno;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback using sqlca;
	   MessageBox("저장 실패", "교육훈련이수결과 자료가 ~r등록되어 있지 않습니다.!!")
		Return
	END IF
	commit using sqlca; // update p5_educations_s에 대한 commit
else
	rollback using sqlca;
	MessageBox("확인", "저장실패")
	return
end if

commit using sqlca; //dw_mst.update() 에 대한 commit
ib_any_typing = false

is_gub = "조회"
WF_SETTING_RETRIEVEMODE(is_gub)									//조회 MODE

sle_msg.text = "자료가 저장되었습니다.!!"

dw_mst.setfocus()
dw_mst.setcolumn('education1')

end event

type cb_insert from w_inherite_standard`cb_insert within w_pig2002
integer x = 261
integer y = 5128
integer width = 544
integer taborder = 70
string text = "설문지 입력(&I)"
end type

event cb_insert::clicked;call super::clicked;long ll_cnt

setNull(gs_code)

if dw_mst.AcceptText() = -1 then return

gs_code = dw_mst.GetItemString(1, 'companycode')
istr_edu.str_empno = dw_mst.GetItemString(1, 'empno')
istr_edu.str_eduyear = dw_mst.GetItemString(1, 'eduyear')
istr_edu.str_empseq = dw_mst.GetItemNumber(1, 'empseq')
istr_edu.str_eduempno = dw_mst.GetItemString(1, 'eduempno')

 if istr_edu.str_empno="" or isnull(istr_edu.str_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
     return	  
  elseif istr_edu.str_eduyear="" or isnull(istr_edu.str_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
     return	
  elseif istr_edu.str_empseq=0 or isnull(istr_edu.str_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
     return	
  elseif istr_edu.str_eduempno="" or isnull(istr_edu.str_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
     return	
	  
  end if
  
IF is_gub = "조회" THEN
ELSE
	SELECT count(*)
		INTO :ll_cnt
		FROM p5_educations_r
		WHERE companycode = :gs_company and
		      empno       = :istr_edu.str_empno   and
				eduyear     = :istr_edu.str_eduyear and
				empseq      = :istr_edu.str_empseq  and
				eduempno    = :istr_edu.str_eduempno;
	IF sqlca.sqlcode = 0 and ll_cnt = 0 THEN
	   MessageBox("확 인", "등록되어 있는 보고서 자료가 존재하지 않습니다")
//      wf_init()
//		wf_setting_retrievemode("등록")
		Return
	END IF
END IF

IF wf_isu_chk("설문지 작성") = -1 then return         // 이수구분이 "Y" 있으면 삭제할 수 없다.  

//openwithparm(w_pig2007, istr_edu)

end event

type cb_delete from w_inherite_standard`cb_delete within w_pig2002
integer x = 2615
integer y = 5128
integer taborder = 40
end type

event cb_delete::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno
string fd_isu
long ll_empseq

if	dw_mst.AcceptText() = -1 then return
	
if dw_mst.RowCount() <= 0 then
	dw_mst.setfocus()
	return
end if

ls_empno = dw_mst.GetItemString(1, "empno")
ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도는 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
     WF_INIT()	
     is_gub = "등록"	  
     WF_SETTING_RETRIEVEMODE("등록")									//입력 MODE	  
     return	
	  
  end if

IF wf_isu_chk("삭제") = -1 then return         // 이수구분이 "Y" 있으면 삭제할 수 없다.

if f_msg_delete() = -1 then return

dw_mst.setredraw(false)

dw_mst.deleterow(0)
IF dw_mst.Update() = 1 THEN
	update p5_educations_s
	set    document  = 'N'
	WHERE companycode = :gs_company and
  	      empno       = :ls_empno   and
			eduyear     = :ls_eduyear and
			empseq      = :ll_empseq  and
			eduempno    = :ls_eduempno;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback using sqlca;
	   MessageBox("저장 실패", "보고서 작성에 실패하였습니다.")
		Return
	else 
		commit using sqlca;
	END IF
	COMMIT using sqlca;
	WF_INIT()
	sle_msg.text =" 자료가 삭제되었습니다.!!!"
	cb_update.Enabled =True
	ib_any_typing=False
ELSE
   MessageBox("저장 실패", "보고서 작성에 실패하였습니다.")
	dw_mst.SetFocus()
	ROLLBACK using sqlca;	
END IF	
is_gub = "등록"

dw_mst.setredraw(true)

WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

dw_mst.setfocus()
dw_mst.setcolumn('empno')
end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig2002
integer x = 1874
integer y = 5128
integer taborder = 20
end type

event cb_retrieve::clicked;call super::clicked;string ls_empno, ls_eduyear, ls_eduempno, &
       ls_sdate, ls_edate
long ll_empseq

if	dw_mst.AcceptText() = -1 then return
	
if dw_mst.RowCount() <= 0 then
	dw_mst.setfocus()
	return
end if

ls_empno = dw_mst.GetItemString(1, "empno")
ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

ls_sdate= dw_mst.GetItemString(1, "startdate")
ls_edate= dw_mst.GetItemString(1, "enddate")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empno')
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('eduyear')
     return	
  elseif ll_empseq=0 or isnull(ll_empseq) then	
     MessageBox("확 인", "일련번호는 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('empseq')
     return	
  elseif ls_eduempno="" or isnull(ls_eduempno) then	
     MessageBox("확 인", "참석사번은 필수입력사항입니다.!!")
	  dw_mst.setfocus()
	  dw_mst.setColumn('eduempno')
     return	
	  
  end if

dw_mst.SetRedraw(false)

if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, & 
                  ll_empseq, ls_eduempno) <= 0 then
   dw_mst.reset()
   dw_mst.insertrow(0)
   dw_mst.SetItem(1, 'companycode', gs_company)		
   dw_mst.SetItem(1, 'empno', ls_empno)		
   dw_mst.SetItem(1, 'eduyear', ls_eduyear)		
   dw_mst.SetItem(1, 'empseq', ll_empseq)		
   dw_mst.SetItem(1, 'startdate', ls_sdate)		
   dw_mst.SetItem(1, 'enddate', ls_edate)				
   dw_mst.SetItem(1, 'eduempno', ls_eduempno)
	
	dw_mst.setfocus()	
	dw_mst.SetColumn('education1')

   dw_mst.SetRedraw(true)	
	is_gub = "등록"
   WF_SETTING_RETRIEVEMODE(is_gub)							
   ib_any_typing=False	
	Return
else
   dw_mst.SetRedraw(true)	
   ib_any_typing=False	
	is_gub = "조회"
   WF_SETTING_RETRIEVEMODE(is_gub)	//수정 mode 
	dw_mst.setfocus()
	dw_mst.SetColumn('education1')	
   ib_any_typing=False	
END IF

sle_msg.text = "자료가 조회되었습니다.!!"
end event

type st_1 from w_inherite_standard`st_1 within w_pig2002
integer x = 155
integer y = 5300
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig2002
integer x = 2949
integer y = 5128
integer taborder = 50
end type

event cb_cancel::clicked;call super::clicked;sle_msg.text =""

cb_update.Enabled =True

WF_INIT()

//dw_mst.SetFocus()
is_gub ="등록"

ib_any_typing=False

WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

dw_mst.setfocus()
dw_mst.setcolumn('empno')

sle_msg.text = "자료가 취소되었습니다.!!"



end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig2002
integer x = 2967
integer y = 5300
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig2002
integer x = 485
integer y = 5300
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig2002
integer x = 1824
integer y = 5068
integer width = 1920
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig2002
integer x = 197
integer y = 5068
integer width = 704
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig2002
integer x = 137
integer y = 5248
end type

type dw_mst from datawindow within w_pig2002
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 654
integer y = 300
integer width = 3159
integer height = 1740
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig2002_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;if dw_mst.GetColumnName() = "education2" or dw_mst.GetColumnName() = "work2" or &
     dw_mst.GetColumnName() = "recommand2" then
	  return
else 
   Send(Handle(this),256,9,0)
   Return 1
end if

end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;string ls_empno, ls_eduyear, ls_eduempno, ls_sdate, ls_edate
long ll_empseq

setNull(Gs_code)
setNull(Gs_codename)


IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	wf_init()
	this.SetItem(this.GetRow(), "empno", Gs_code)

	is_gub = "등록"
	
   WF_SETTING_RETRIEVEMODE(is_gub)								
	this.setfocus()
   this.SetColumn('empno')
	
END IF

IF This.GetColumnName() = "empseq" THEN

	Gs_Code  = gs_company

   istr_edu.str_empno   = this.Getitemstring(1, "empno")   // 사번
   istr_edu.str_eduyear = this.Getitemstring(1, "eduyear") // 계획년도

	openwithparm(w_stot_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or &
	   IsNull(istr_edu.str_empseq) or IsNull(istr_edu.str_gbn) THEN 
   	this.SetItem(1, "eduyear", string(today(), "YYYY"))
    	this.SetColumn('eduyear')	
		return
   else
   	wf_init()		

      this.SetItem(1, "empno", istr_edu.str_empno)				
      this.SetItem(1, "eduyear", istr_edu.str_eduyear)		
      this.SetItem(1, "empseq", istr_edu.str_empseq)				
      this.SetItem(1, "startdate", istr_edu.str_sdate)
    	this.SetItem(1, "enddate", istr_edu.str_edate)

   	is_gub = "등록"
	
      WF_SETTING_RETRIEVEMODE(is_gub)								
		 
   	this.setfocus()		 
    	this.SetColumn('eduempno')			 
   end if

END IF

IF This.GetColumnName() = "eduempno" THEN

	Gs_Code  = gs_company

   istr_edu.str_eduyear = this.Getitemstring(1, "eduyear")   // 계획년도
   istr_edu.str_empno   = this.Getitemstring(1, "empno")     // 사번
   istr_edu.str_empseq   = this.GetitemNumber(1, "empseq")   // 순번
	
	openwithparm(w_pig_popup1, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value
	
	if IsNull(istr_edu.str_eduempno) THEN 
    	this.SetColumn('eduempno')
		return 1
   else
    	this.SetItem(1, "eduempno", istr_edu.str_eduempno)
   end if
	
	ls_empno = dw_mst.GetItemString(1, 'empno')
	ls_eduyear = dw_mst.GetItemString(1, 'eduyear')
	ll_empseq = dw_mst.GetItemNumber(1, 'empseq')	
	ls_eduempno = dw_mst.GetItemString(1, 'eduempno')	
	ls_sdate   = dw_mst.GetItemString(1, 'startdate')
	ls_edate   = dw_mst.GetItemString(1, 'enddate')
	
    dw_mst.SetRedraw(false)
   if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, & 
                  ll_empseq, ls_eduempno) <= 0 then
      dw_mst.reset()
		dw_mst.insertrow(0)
      dw_mst.SetItem(1, 'companycode', gs_company)		
      dw_mst.SetItem(1, 'empno', ls_empno)		
      dw_mst.SetItem(1, 'eduyear', ls_eduyear)		
      dw_mst.SetItem(1, 'empseq', ll_empseq)		
      dw_mst.SetItem(1, 'startdate', ls_sdate)		
      dw_mst.SetItem(1, 'enddate', ls_edate)				
      dw_mst.SetItem(1, 'eduempno', ls_eduempno)
		dw_mst.SetColumn('education1')
//		MessageBox("조회 실패", "자료를 조회할 수 없습니다.")
   	is_gub = '등록'	
   else
	   is_gub = '조회'	
   end if	
    dw_mst.SetColumn('education1')			
    dw_mst.SetRedraw(true)			
	 
    ib_any_typing=False

    WF_SETTING_RETRIEVEMODE(is_gub)								//수정 mode 
END IF

end event

event editchanged;ib_any_typing =True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ="education1" OR this.GetColumnName() ="education2" OR &
   this.GetColumnName() ="work1" OR this.GetColumnName() ="work2" OR &
	this.GetColumnName() ="recommand1" or this.GetColumnName() ="recommand2" THEN
	
	f_toggle_kor(wnd)
	
ELSE
	
	f_toggle_eng(wnd)
	
END IF
end event

event itemchanged;string ls_empno, ls_eduyear, ls_sdate, ls_edate

string get_sdate, get_edate

long ll_empseq

w_mdi_frame.sle_msg.text =""

IF dwo.name ="empno"THEN
	IF IsNull(data) OR trim(data) ="" THEN Return 1
END IF

IF dwo.name ="eduyear" THEN
	IF IsNull(data) OR trim(data) ="" THEN Return 1
END IF

IF dwo.name ="empseq" THEN
	IF IsNull(data) OR long(trim(data)) = 0 THEN
		Return 1
	else
		ls_sdate = dw_mst.GetItemstring(1, 'startdate')
		ls_edate = dw_mst.GetItemstring(1, 'enddate')		
		
		if (isnull(ls_sdate) or ls_sdate ="") or &
    		(isnull(ls_sdate) or ls_sdate ="") then
			 
		   ls_empno = dw_mst.GetItemstring(1, 'empno')
   		ls_eduyear = dw_mst.GetItemstring(1, 'eduyear')
	   	ll_empseq = long(data)
		
		   select restartdate, reenddate
   		into :get_sdate, :get_edate
   		from p5_educations_s
   		where companycode = :gs_company and
	   	      empno  = :ls_empno and
		   		eduyear = :ls_eduyear and
			   	empseq  = :ll_empseq and
   				empno = eduempno;
	      	if sqlca.sqlcode <> 0 then
		      	MessageBox("확인", "자료가 존재하지 않습니다.")
   			   dw_mst.SetColumn("empseq")
   	   		return 1
      		end if
	   	dw_mst.SetItem(1, 'startdate', get_sdate)
   		dw_mst.SetItem(1, 'enddate', get_edate)
	   	dw_mst.SetColumn("eduempno")
		end if
   end if
END IF

IF dwo.name ="eduempno" THEN
	IF IsNull(data) OR trim(data) ="" THEN Return 1
	p_inq.TriggerEvent(Clicked!)
END IF


end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pig2002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 626
integer y = 276
integer width = 3328
integer height = 1788
integer cornerheight = 40
integer cornerwidth = 55
end type

