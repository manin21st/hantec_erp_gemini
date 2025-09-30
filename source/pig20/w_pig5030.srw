$PBExportHeader$w_pig5030.srw
$PBExportComments$교육복명서 등록
forward
global type w_pig5030 from w_inherite_standard
end type
type dw_mst from datawindow within w_pig5030
end type
type p_gwup from uo_picture within w_pig5030
end type
type dw_dsp from u_key_enter within w_pig5030
end type
type dw_plan from u_key_enter within w_pig5030
end type
type rr_1 from roundrectangle within w_pig5030
end type
end forward

global type w_pig5030 from w_inherite_standard
integer width = 4594
integer height = 2512
string title = "교육복명서 등록"
dw_mst dw_mst
p_gwup p_gwup
dw_dsp dw_dsp
dw_plan dw_plan
rr_1 rr_1
end type
global w_pig5030 w_pig5030

type variables
string    is_gub, Is_GwGbn = 'N'
Str_Edu   istr_edu
end variables

forward prototypes
public function integer wf_isu_chk (string arg_mode)
public subroutine wf_setting_retrievemode (string mode)
public function integer wf_col_validation_chk (string scolname, string scolvalue)
public subroutine wf_reset ()
public subroutine wf_init (string smode)
public function integer wf_insert_p5_education_r_gw (string seduyear, integer iempseq, string seduempno)
end prototypes

public function integer wf_isu_chk (string arg_mode);string   fd_isu, ls_eduyear, ls_eduempno
long     ll_empseq

if	dw_mst.AcceptText() = -1 then return -1

ls_eduyear  = dw_mst.GetItemString(1, "eduyear")
ll_empseq   = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno = dw_mst.GetItemString(1, "eduempno")

if istr_edu.str_gbn = '1' then
	select distinct isu	into :fd_isu
		from	p5_educations_s
		WHERE companycode = :gs_company and
				empno       = :ls_eduempno  and
				eduyear     = :ls_eduyear and
				empseq      = :ll_empseq  and
				egubn       = :istr_edu.str_gbn ;
else
	select isu	into :fd_isu
		from	p5_educations_s
		WHERE companycode = :gs_company and
				eduempno    = :ls_eduempno  and
				eduyear     = :ls_eduyear and
				empseq      = :ll_empseq  and
				egubn       = :istr_edu.str_gbn ;
end if
		
IF SQLCA.SQLCODE <> 0 THEN
   MessageBox(arg_mode + "실패", "교육계획이 등록 되어 있지 않습니다.!!")
	Return -1
end if

if fd_isu = "Y" then
   MessageBox(arg_mode + "실패", "이미 완료처리되어 있는 보고서는" + "~n" + &
                           arg_mode + "(을)를 할 수 없습니다.!!")	
   return -1
end if

return 1
end function

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
	
	String sGwStatus
	
	sGwStatus = dw_mst.GetItemString(1,"gwstatus") 
	if sGwStatus = '0' or sGwStatus = '5' or Is_GwGbn = 'N' then
		p_del.Enabled =True
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		
		p_ins.Enabled =True
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		
		p_gwup.Enabled = True
		p_gwup.PictureName = "C:\erpman\image\결재상신_up.gif"
		
		p_search.Enabled =True
		p_search.PictureName = "C:\erpman\image\설문지입력_up.gif"
	else
		if Is_GwGbn = 'Y' then
			if sGwStatus = '4' then
				MessageBox('확 인','전자결재에서 결재완료되었으므로 수정할 수 없습니다')
			else
				MessageBox('확 인','전자결재에서 결재진행중이므로 수정할 수 없습니다')
			end if
			
			p_del.Enabled =False
			p_del.PictureName = "C:\erpman\image\삭제_d.gif"
			
			p_mod.Enabled =False
			p_mod.PictureName = "C:\erpman\image\저장_d.gif"
			
			p_ins.Enabled =False
			p_ins.PictureName = "C:\erpman\image\추가_d.gif"
			
			p_gwup.Enabled = False
			p_gwup.PictureName = "C:\erpman\image\결재상신_d.gif"
			
			p_search.Enabled =False
			p_search.PictureName = "C:\erpman\image\설문지입력_d.gif"
		end if
	end if
		
ELSEIF mode ="등록" THEN					//입력
	dw_mst.SetTabOrder("empno", 10)
	dw_mst.SetTabOrder("eduyear", 20)
	dw_mst.SetTabOrder("empseq", 30)
	dw_mst.SetTabOrder("eduempno", 40)

   dw_mst.Modify("empno.protect = 0")
   dw_mst.Modify("eduyear.protect = 0")
   dw_mst.Modify("empseq.protect = 0")
	
	p_mod.Enabled =True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		
	p_del.Enabled =False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	p_ins.Enabled =false	
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	
	p_gwup.Enabled = False
	p_gwup.PictureName = "C:\erpman\image\결재상신_d.gif"
	
	p_search.Enabled =False
	p_search.PictureName = "C:\erpman\image\설문지입력_d.gif"
END IF

dw_mst.SetFocus()
dw_mst.SetRedraw(True)

end subroutine

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

public subroutine wf_reset ();DataWindowChild  Dwc_Dept
String           sDeptCode

select dataname	into :sDeptCode		
	from p0_syscnfg where sysgu = 'P' and serial = '1' and lineno = '1';

if sDeptCode = Gs_Dept then					/*담당부서*/
	dw_dsp.GetChild("deptcode",Dwc_Dept)
	Dwc_Dept.SetTransObject(Sqlca)
	Dwc_Dept.Retrieve('%')
else
	dw_dsp.GetChild("deptcode",Dwc_Dept)
	Dwc_Dept.SetTransObject(Sqlca)
	Dwc_Dept.Retrieve(gs_dept)	
end if

dw_dsp.Reset()
dw_dsp.InsertRow(0)

if sDeptCode = Gs_Dept then					/*담당부서*/
	dw_dsp.Modify("deptcode.protect = 0")
	
	dw_dsp.SetColumn("deptcode")					
else
	Integer iCount
	
	select Count(*)	into :iCount from p0_dept
		where companycode = :gs_company and updept = :gs_dept and usetag = '1';
	if sqlca.sqlcode = 0 and iCount = 0 then				/*최하위부서*/
		dw_dsp.SetItem(1,"deptcode", Gs_Dept)
		dw_dsp.Modify("deptcode.protect = 1")
	else
		dw_dsp.Modify("deptcode.protect = 0")
		dw_dsp.SetItem(1,"deptcode", Gs_Dept)
	end if
	
end if

end subroutine

public subroutine wf_init (string smode);String sNullValue

w_mdi_frame.sle_msg.text =""

SetNull(sNullValue)

if sMode = 'A' then
	dw_plan.SetRedraw(False)	
	dw_plan.Reset()
	dw_plan.InsertRow(0)
	dw_plan.SetRedraw(True)
end if

dw_mst.SetRedraw(False)
dw_mst.Reset()
dw_mst.InsertRow(0)

dw_mst.SetItem(1,"companycode", gs_company)
dw_mst.SetItem(1,"eduyear",     dw_dsp.GetItemsTring(1,"eduyear"))
dw_mst.SetItem(1,"empseq",      dw_plan.GetItemNumber(1,"empseq"))
dw_mst.SetItem(1,"empno",       dw_plan.GetItemsTring(1,"empno"))
dw_mst.SetItem(1,"eduempno",    dw_plan.GetItemsTring(1,"empno"))
dw_mst.SetItem(1,"startdate",   dw_plan.GetItemsTring(1,"restartdate"))
dw_mst.SetItem(1,"enddate",     dw_plan.GetItemsTring(1,"reenddate"))
dw_mst.SetItem(1,"eduamt",      dw_plan.GetItemNumber(1,"eduamt"))

if Is_GwGbn = 'Y' then
	dw_mst.SetItem(1,"gwstatus", '0')	
else
	dw_mst.SetItem(1,"gwstatus", '4')	
end if

dw_mst.SetRedraw(True)

end subroutine

public function integer wf_insert_p5_education_r_gw (string seduyear, integer iempseq, string seduempno);Integer  iCount

select Count(*)	into :iCount from p5_educations_r_gw
	where companycode = 'KN' and empno = :sEduempno and eduyear = :sEduYear and empseq = :iEmpSeq and eduempno = :sEduempno ;
if sqlca.sqlcode = 0 and iCount > 0 then
	if MessageBox('확 인','상신한 자료가 존재합니다. 변경하시겠습니까?',Question!,YesNo!) = 2 then Return 1
	
	delete from p5_educations_r_gw where companycode = 'KN' and empno = :sEduempno and eduyear = :sEduYear and empseq = :iEmpSeq and eduempno = :sEduempno ;
	Commit;
end if

INSERT INTO "P5_EDUCATIONS_R_GW"  
	( "COMPANYCODE",              			"EMPNO",              				"EDUYEAR",              
	  "EMPSEQ",              					"EDUEMPNO",   					   	"STARTDATE",   		         
	  "ENDDATE",            					"EDUCATION1",           			"EDUCATION2",          
	  "WORK1",  									"WORK2",   					   		"RECOMMAND1",   		 
	  "RECOMMAND2",   		    				"EDUNO",   			   				"EDUAMT",   
	  "CJAMT", 						   			"ISU",   			    				"ADDDOCPATH",   			 
	  "GWSTATUS",   	      					"EDUCUR", 								"EDUAREA", 
	  "EMPNAME",   		    					"DEPTNAME" )  
 
SELECT :Gs_Company,								"P5_EDUCATIONS_R"."EDUEMPNO",		"P5_EDUCATIONS_R"."EDUYEAR", 
		 "P5_EDUCATIONS_R"."EMPSEQ",        "P5_EDUCATIONS_R"."EDUEMPNO", 	"P5_EDUCATIONS_R"."STARTDATE",
		 "P5_EDUCATIONS_R"."ENDDATE",       "P5_EDUCATIONS_R"."EDUCATION1",	"P5_EDUCATIONS_R"."EDUCATION2", 
		 "P5_EDUCATIONS_R"."WORK1",         "P5_EDUCATIONS_R"."WORK2",       "P5_EDUCATIONS_R"."RECOMMAND1",   
       "P5_EDUCATIONS_R"."RECOMMAND2",    "P5_EDUCATIONS_R"."EDUNO",       "P5_EDUCATIONS_R"."EDUAMT",   
       "P5_EDUCATIONS_R"."CJAMT", 		   "P5_EDUCATIONS_R"."ISU",			"P5_EDUCATIONS_R"."ADDDOCPATH",
		 "P5_EDUCATIONS_R"."GWSTATUS",		"P5_EDUCATIONS_S"."EDUDESC",	   "P5_EDUCATIONS_S"."EDUAREA",
		 "P1_MASTER"."EMPNAME",				   "P0_DEPT"."DEPTNAME" 
   FROM "P5_EDUCATIONS_R", "P5_EDUCATIONS_S", "P1_MASTER","P0_DEPT"
   WHERE ( "P5_EDUCATIONS_R"."COMPANYCODE" = "P5_EDUCATIONS_S"."COMPANYCODE") AND
			 ( "P5_EDUCATIONS_R"."EMPNO" = "P5_EDUCATIONS_S"."EMPNO") AND	
			 ( "P5_EDUCATIONS_R"."EDUYEAR" = "P5_EDUCATIONS_S"."EDUYEAR") AND
			 ( "P5_EDUCATIONS_R"."EMPSEQ" = "P5_EDUCATIONS_S"."EMPSEQ") AND	
			 ( "P5_EDUCATIONS_R"."EDUEMPNO" = "P5_EDUCATIONS_S"."EDUEMPNO") AND		
		
			 ( "P5_EDUCATIONS_R"."COMPANYCODE" = "P1_MASTER"."COMPANYCODE") AND
			 ( "P5_EDUCATIONS_R"."EDUEMPNO" = "P1_MASTER"."EMPNO") AND
		
			 ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE") AND
			 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE") AND
		
			 ( "P5_EDUCATIONS_R"."COMPANYCODE" = :Gs_Company ) AND  
         ( "P5_EDUCATIONS_R"."EDUYEAR" = :sEduYear ) AND  
         ( "P5_EDUCATIONS_R"."EMPSEQ" = :iEmpSeq) AND  
         ( "P5_EDUCATIONS_R"."EDUEMPNO" = :sEduEmpno ) 
			;
if sqlca.sqlcode = 0 then 
	Commit;
	Return 1
else
	Return -1
end if
end function

on w_pig5030.create
int iCurrent
call super::create
this.dw_mst=create dw_mst
this.p_gwup=create p_gwup
this.dw_dsp=create dw_dsp
this.dw_plan=create dw_plan
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mst
this.Control[iCurrent+2]=this.p_gwup
this.Control[iCurrent+3]=this.dw_dsp
this.Control[iCurrent+4]=this.dw_plan
this.Control[iCurrent+5]=this.rr_1
end on

on w_pig5030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mst)
destroy(this.p_gwup)
destroy(this.dw_dsp)
destroy(this.dw_plan)
destroy(this.rr_1)
end on

event open;call super::open;
//select nvl(gubun,'N')	into :Is_GwGbn		from sub2_t where window_name = :is_window_id ;

dw_dsp.SetTransObject(sqlca)

Wf_Reset()

istr_edu.str_dept = Gs_Dept
istr_edu.str_eduYear = Left(F_Today(),4)

dw_dsp.SetItem(1,"deptcode", istr_edu.str_dept)
dw_dsp.SetItem(1,"eduyear",  istr_edu.str_eduyear)
dw_dsp.SetColumn("ekind")
dw_dsp.SetFocus()

dw_plan.SetTransObject(Sqlca)
dw_mst.SetTransObject(sqlca)

Wf_Init('A')

p_ins.enabled = false
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

end event

type p_mod from w_inherite_standard`p_mod within w_pig5030
integer x = 3822
integer y = 16
integer taborder = 60
end type

event p_mod::clicked;string   ls_eduyear, ls_eduempno
long     ll_empseq, ll_row
int      ll_cnt

if dw_mst.AcceptText() = -1 then return 
ll_row = dw_mst.GetRow()

ls_eduyear  = dw_mst.GetItemString(ll_row, 'eduyear')
ll_empseq   = dw_mst.GetItemNumber(ll_row, 'empseq')
ls_eduempno = dw_mst.GetItemString(ll_row, 'eduempno')

if ls_eduyear="" or isnull(ls_eduyear) then
	MessageBox("확 인", "년도는 필수입력사항입니다.!!")
	dw_dsp.setColumn('eduyear')	  
	dw_dsp.setfocus()	  
	return	
end if

if ll_empseq=0 or isnull(ll_empseq) then	
	MessageBox("확 인", "순번은 필수입력사항입니다.!!")
	dw_plan.setColumn('empseq')	  	  
	dw_plan.setfocus()	 
	return	
end if

if ls_eduempno="" or isnull(ls_eduempno) then	
	MessageBox("확 인", "사번은 필수입력사항입니다.!!")
	dw_plan.setColumn('eduempno')	  	  	  
	dw_plan.setfocus()	  	
	return		
end if

IF is_gub =  "등록" THEN
	SELECT count(*)
		INTO :ll_cnt
		FROM p5_educations_r
		WHERE companycode = :gs_company and
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
  	      eduyear     = :ls_eduyear and
			empseq      = :ll_empseq  and
			eduempno    = :ls_eduempno and
			egubn			= :istr_edu.str_gbn;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback ;
	   MessageBox("저장 실패", "교육 계획이 등록되어 있지 않습니다.!!")
		Return
	END IF
else
	rollback;
	MessageBox("확인", "저장실패")
	return
end if

commit ; 
ib_any_typing = false

is_gub = "조회"
WF_SETTING_RETRIEVEMODE(is_gub)									//조회 MODE

w_mdi_frame.sle_msg.text = "자료가 저장되었습니다."

dw_mst.setcolumn('education1')
dw_mst.setfocus()

end event

type p_del from w_inherite_standard`p_del within w_pig5030
integer x = 3995
integer y = 16
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string  ls_eduyear, ls_eduempno
string  fd_isu
long    ll_empseq

if	dw_mst.AcceptText() = -1 then return
if dw_mst.GetRow() <=0 then Return

ls_eduyear  = dw_mst.GetItemString(1, "eduyear")
ll_empseq   = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno = dw_mst.GetItemString(1, "eduempno")

IF wf_isu_chk("삭제") = -1 then return        

if f_msg_delete() = -1 then return

dw_mst.setredraw(false)
dw_mst.deleterow(0)

IF dw_mst.Update() = 1 THEN
	
	update p5_educations_s
		set    document  = 'N'
		WHERE companycode = :gs_company and
				empno       = :ls_eduempno  and
				eduyear     = :ls_eduyear and
				empseq      = :ll_empseq  and
				eduempno    = :ls_eduempno;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
	   MessageBox("저장 실패", "복명서 작성에 실패하였습니다.")
		Return
	end if
	commit;

	WF_INIT('A')
	
	w_mdi_frame.sle_msg.text =" 자료가 삭제되었습니다.!!!"
	p_mod.Enabled =True
	ib_any_typing=False
ELSE
   MessageBox("저장 실패", "보고서 작성에 실패하였습니다.")
	dw_mst.SetFocus()
	ROLLBACK ;	
	Return
END IF	
is_gub = "등록"

dw_mst.setredraw(true)

WF_SETTING_RETRIEVEMODE(is_gub)									

dw_plan.setcolumn('empseq')
dw_plan.setfocus()


end event

type p_inq from w_inherite_standard`p_inq within w_pig5030
integer x = 3479
integer y = 16
integer taborder = 30
end type

event p_inq::clicked;
if dw_dsp.AcceptText() = -1 then Return
istr_edu.str_egubn = dw_dsp.GetItemString(1,"ekind")
istr_edu.str_gbn   = dw_dsp.GetItemString(1,"egubn")

if dw_plan.AcceptText() = -1 then Return
istr_edu.str_empseq  = dw_plan.GetItemNumber(1,"empseq")
istr_edu.str_empno   = dw_plan.GetItemString(1,"empno")

if istr_edu.str_egubn = '' or IsNull(istr_edu.str_egubn) then
	MessageBox('확 인','교육종류를 입력하세요!')
	dw_dsp.SetColumn("ekind")
	dw_dsp.SetFocus()
	Return
end if
if istr_edu.str_empseq = 0 or IsNull(istr_edu.str_empseq) then
	MessageBox('확 인','순번을 입력하세요!')
	dw_plan.SetColumn("empseq")
	dw_plan.SetFocus()
	Return
end if

if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then
	MessageBox('확 인','사번을 입력하세요!')
	dw_plan.SetColumn("empno")
	dw_plan.SetFocus()
	Return
end if
dw_mst.SetRedraw(false)
if dw_mst.Retrieve(gs_company,istr_edu.str_empno,istr_edu.str_eduyear,istr_edu.str_empseq,istr_edu.str_empno) <=0 then
	
	Wf_Init('M')
	
	is_gub = "등록"
   WF_SETTING_RETRIEVEMODE(is_gub)							
   ib_any_typing=False	
	Return
else
   dw_mst.SetRedraw(true)	
   ib_any_typing=False	
	is_gub = "조회"
   WF_SETTING_RETRIEVEMODE(is_gub)	//수정 mode 
	
	dw_mst.SetColumn('startdate')
	dw_mst.setfocus()
   ib_any_typing=False	
END IF

w_mdi_frame.sle_msg.text = "자료가 조회되었습니다.!!"
end event

type p_print from w_inherite_standard`p_print within w_pig5030
boolean visible = false
integer x = 4023
integer y = 5124
integer taborder = 0
end type

type p_can from w_inherite_standard`p_can within w_pig5030
integer x = 4169
integer y = 16
integer taborder = 80
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

WF_INIT('A')

is_gub ="등록"

ib_any_typing=False

WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

dw_plan.setcolumn('empseq')
dw_plan.setfocus()

p_mod.Enabled =True

w_mdi_frame.sle_msg.text = "자료가 취소되었습니다.!!"


end event

type p_exit from w_inherite_standard`p_exit within w_pig5030
integer x = 4343
integer y = 16
integer taborder = 90
end type

type p_ins from w_inherite_standard`p_ins within w_pig5030
integer x = 3653
integer y = 16
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;WF_INIT('A')

dw_plan.SetColumn("empseq")
dw_plan.SetFocus()

is_gub ="등록"
ib_any_typing=False
WF_SETTING_RETRIEVEMODE(is_gub)									//입력 MODE

end event

type p_search from w_inherite_standard`p_search within w_pig5030
integer x = 3296
integer y = 16
integer taborder = 100
boolean originalsize = true
string picturename = "C:\erpman\image\설문지입력_d.gif"
end type

event p_search::clicked;call super::clicked;if dw_plan.AcceptText() = -1 then Return
istr_edu.str_empseq  = dw_plan.GetItemNumber(1,"empseq")
istr_edu.str_empno   = dw_plan.GetItemString(1,"empno")

IF wf_isu_chk("설문지 작성") = -1 then return         // 이수구분이 "Y" 있으면 삭제할 수 없다.  

openwithparm(w_pig5031, istr_edu)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\설문지입력_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\설문지입력_up.gif"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pig5030
boolean visible = false
integer x = 3986
integer y = 5276
integer taborder = 0
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig5030
boolean visible = false
integer x = 4160
integer y = 5276
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig5030
boolean visible = false
integer x = 1038
integer y = 5100
integer taborder = 0
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_pig5030
boolean visible = false
integer x = 2322
integer y = 5300
integer taborder = 0
boolean enabled = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig5030
boolean visible = false
integer x = 3319
integer y = 5128
integer taborder = 0
end type

type cb_update from w_inherite_standard`cb_update within w_pig5030
boolean visible = false
integer x = 2245
integer y = 5128
integer taborder = 0
boolean enabled = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig5030
boolean visible = false
integer x = 247
integer y = 5128
integer width = 558
integer taborder = 0
boolean enabled = false
string text = "설문지 입력(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig5030
boolean visible = false
integer x = 2615
integer y = 5128
integer taborder = 0
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig5030
boolean visible = false
integer x = 1874
integer y = 5128
integer taborder = 0
boolean enabled = false
end type

type st_1 from w_inherite_standard`st_1 within w_pig5030
boolean visible = false
integer x = 155
integer y = 5300
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig5030
boolean visible = false
integer x = 2949
integer y = 5128
integer taborder = 0
boolean enabled = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig5030
boolean visible = false
integer x = 2967
integer y = 5300
boolean enabled = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig5030
boolean visible = false
integer x = 485
integer y = 5300
boolean enabled = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig5030
boolean visible = false
integer x = 1824
integer y = 5068
integer width = 1920
boolean enabled = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig5030
boolean visible = false
integer x = 197
integer y = 5068
integer width = 704
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig5030
boolean visible = false
integer x = 137
integer y = 5248
boolean enabled = false
end type

type dw_mst from datawindow within w_pig5030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 206
integer y = 492
integer width = 4288
integer height = 1664
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pig50303"
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

event itemchanged;String  ls_empno, ls_eduyear, ls_sdate, ls_edate, ls_eduempno,sProState, &
		  get_sdate, get_edate,seduno,sNull
int     scnt,iNull
long ll_empseq,deduamt, ecjamt

SetNull(sNull);	SetNull(iNull);

w_mdi_frame.sle_msg.text =""

IF dwo.name ="empseq" THEN
	IF IsNull(data) OR long(trim(data)) = 0 THEN Return
	
	ls_eduempno = dw_mst.GetItemstring(1, 'eduempno')		
	ls_empno = '999999'
	ls_eduyear = dw_mst.GetItemstring(1, 'eduyear')
	ll_empseq = long(data)
	
	if IsNull(ls_eduempno) or ls_eduempno = '' then
		select count(*) into :scnt
			from p5_educations_s
			where companycode = :gs_company and empno  = :ls_empno and
					eduyear = :ls_eduyear and empseq  = :ll_empseq;	
		if scnt <= 0 then
			MessageBox("확인", "자료가 존재하지 않습니다.")
			dw_mst.SetItem(1,"empseq",iNull)
			dw_mst.SetColumn("empseq")
			return 1
		end if
	else		
		select restartdate, reenddate, eduno, eduamt, rebackamt, prostate
			into :get_sdate, :get_edate, :seduno, :deduamt, :ecjamt, :sProState
			from p5_educations_s
			where companycode = :gs_company and empno  = :ls_empno and
				eduyear = :ls_eduyear and empseq  = :ll_empseq and
				eduempno = :ls_eduempno ;
		if sqlca.sqlcode < 0 then
			MessageBox("확인", "자료가 존재하지 않습니다.")
			dw_mst.SetItem(1,"empseq",iNull)
			dw_mst.SetColumn("empseq")
			return 1
		end if
		if sProState = 'C' or sProState = 'R' then
			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
			dw_mst.SetItem(1,"empseq",iNull)
			dw_mst.SetColumn("empseq")
			return 1
		end if
		
		dw_mst.SetItem(1, 'startdate', get_sdate)
		dw_mst.SetItem(1, 'enddate', get_edate)
		dw_mst.SetItem(1, 'eduamt', deduamt)
//		p_inq.TriggerEvent(Clicked!)	
	end if	
END IF

IF dwo.name ="eduempno" THEN
	IF IsNull(data) OR trim(data) ="" THEN Return
	
	ls_empno    = '999999'
	ls_eduyear  = dw_mst.GetItemstring(1, 'eduyear')
	ll_empseq   = dw_mst.GetItemNumber(1, 'empseq')		
	ls_eduempno = data
	
	if IsNull(ls_eduempno) or ls_eduempno = '' then
		select count(*) into :scnt
			from p5_educations_s
			where companycode = :gs_company and empno  = :ls_empno and
					eduyear = :ls_eduyear and empseq  = :ll_empseq;	
		if scnt <= 0 then
			MessageBox("확인", "자료가 존재하지 않습니다.")
			dw_mst.SetItem(1,"eduempno", sNull)
			dw_mst.SetItem(1,"empname",  sNull)
			dw_mst.SetColumn("eduempno")
			return 1
		end if
	else		
		select restartdate, reenddate, eduno, eduamt, rebackamt, prostate
			into :get_sdate, :get_edate, :seduno, :deduamt, :ecjamt, :sProState
			from p5_educations_s
			where companycode = :gs_company and empno  = :ls_empno and
				eduyear = :ls_eduyear and empseq  = :ll_empseq and
				eduempno = :ls_eduempno ;
		if sqlca.sqlcode < 0 then
			MessageBox("확인", "자료가 존재하지 않습니다.")
			dw_mst.SetItem(1,"eduempno", sNull)
			dw_mst.SetItem(1,"empname",  sNull)
			dw_mst.SetColumn("eduempno")
			return 1
		end if
		if sProState = 'C' or sProState = 'R' then
			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
			dw_mst.SetItem(1,"eduempno", sNull)
			dw_mst.SetColumn("eduempno")
			return 1
		end if
		dw_mst.SetItem(1,"empname",    f_get_empname(ls_eduempno))
		dw_mst.SetItem(1, 'startdate', get_sdate)
		dw_mst.SetItem(1, 'enddate',   get_edate)
		dw_mst.SetItem(1, 'eduamt',    deduamt)
		p_inq.TriggerEvent(Clicked!)	
	end if	
END IF


end event

event itemerror;return 1
end event

event clicked;IF dwo.name ="b_path"THEN
	string docname, named

	integer value
	
	value = GetFileOpenName("Select File", docname, named)
	
	if value = 1 then 
		this.SetItem(this.GetRow(),"adddocpath",named)
	else
		this.SetItem(this.GetRow(),"adddocpath",'')
	end if
END IF

IF dwo.name ="b_view_addfile"THEN
	string sFileName
	
	sFileName = this.GetItemString(this.GetRow(),"adddocpath")
	if sFileName = '' or IsNull(sFileName) then Return
	
	Choose Case Upper(Right(sFileName,4))
		Case '.XLS'
			
		Case '.DOC'
		Case '.PPT'
			Run("C:\Program Files\Microsoft Office\Office\POWERPNT.EXE"+' '+sFileName)
		Case '.HWP'
		Case '.TXT'	
	End Choose
END IF



end event

type p_gwup from uo_picture within w_pig5030
boolean visible = false
integer y = 2916
integer width = 178
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\결재상신_d.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\결재상신_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\결재상신_dn.gif"
end event

event clicked;String   ls_eduyear,ls_eduempno
Integer  ll_empseq

if dw_mst.accepttext() = -1 then return -1

ls_eduyear= dw_mst.GetItemString(1, "eduyear")
ll_empseq = dw_mst.GetItemNumber(1, "empseq")
ls_eduempno= dw_mst.GetItemString(1, "eduempno")

//그룹웨어 연동구분
STRING s_gwgbn

Select dataname into :s_gwgbn
	from syscnfg
	where sysgu = 'W' and
		 serial = 1 and
		 lineno = '1';

/* 전자결제 상신 */
IF s_gwgbn = 'Y'  then
	if Wf_Insert_p5_education_r_gw(ls_eduyear,ll_empseq,ls_eduempno) = -1 then
		F_MessageChk(13,'[전자결재 상신 자료]')
		Rollback;
		Return
	else
		Commit;
	end if
	
	gs_code  = "&COMPANYCODE=" + Gs_company + "&EDUYEAR=" + ls_eduyear + "&EMPSEQ=" + string(ll_empseq) + "&EDUEMPNO=" + ls_eduempno 
	gs_gubun = '0000000080'	//그룹웨어 문서번호
	SetNull(gs_codename)
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
END IF
end event

type dw_dsp from u_key_enter within w_pig5030
integer x = 96
integer y = 28
integer width = 2857
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig50301"
boolean border = false
end type

event itemchanged;String  sNull

SetNull(sNull)

if this.GetColumnName() = 'ekind' then
	istr_edu.str_egubn = this.GetText()
	if istr_edu.str_egubn = '' or IsNull(istr_edu.str_egubn) then Return
	
	select nvl(educationgbn,'1')	into :istr_edu.str_gbn
		from p0_education where educationcode = :istr_edu.str_egubn;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되지 않은 교육종류입니다.')
		this.SetItem(this.GetRow(),"ekind",sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"egubn",istr_edu.str_gbn)
end if

if this.GetColumnName() = 'eduyear' then
	istr_edu.str_eduYear = this.GetText()
	if istr_edu.str_eduYear = '' or IsNull(istr_edu.str_eduYear) then Return
	
	if F_DateChk(istr_edu.str_eduYear+'0101') = -1 then
		MessageBox('확 인','교육년도를 확인하십시요.')
		this.SetItem(this.GetRow(),"eduyear",sNull)
		Return 1
	end if
end if

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_plan from u_key_enter within w_pig5030
integer x = 101
integer y = 188
integer width = 4421
integer height = 280
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig50302"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;

dw_dsp.Accepttext()

istr_edu.str_dept = dw_dsp.GetItemString(1,"deptcode")
istr_edu.str_eduyear = dw_dsp.GetItemString(1,"eduyear")

IF This.GetColumnName() = "empseq" THEN
	istr_edu.str_egubn = dw_dsp.GetItemString(1,"ekind")
	
	openwithparm(w_pig5030_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)
	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF This.GetColumnName() = "empno" THEN
	istr_edu.str_egubn = dw_dsp.GetItemString(1,"ekind")
	
	openwithparm(w_pig5030_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)
	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	
	this.TriggerEvent(ItemChanged!)
	Return
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;
String   sDateF,sDateT,sProState,sEduDesc
Double   dEduAmt
Integer  iNull

SetNull(iNull);

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() ="empseq" THEN
	istr_edu.str_empseq = Long(this.GetText())
	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return
	
	istr_edu.str_empno = this.GetItemString(1,"empno")
	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
	
	if istr_edu.str_gbn = '1' then				/*사내이면*/
		select distinct restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
			into :sDateF, 					:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
			from p5_educations_s
			where companycode = :gs_company and empno  = :istr_edu.str_empno and
					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
					egubn   = :istr_edu.str_gbn ;
	else
		select restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
			into :sDateF, 		:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
			from p5_educations_s
			where companycode = :gs_company and eduempno  = :istr_edu.str_empno and
					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
					egubn   = :istr_edu.str_gbn ;
	end if
	if sqlca.sqlcode = 0 then
		if sProState = 'C' or sProState = 'R' then
			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
			this.SetItem(1,"empseq", iNull)
			this.SetColumn("empseq")
			return 1
		end if
		
		this.SetItem(1, 'restartdate', sDateF)
		this.SetItem(1, 'reenddate',   sDateT)	
		this.SetItem(1, 'edudesc',   	 sEduDesc)
		this.SetItem(1, 'eduamt',      deduamt)
		
		dw_mst.SetItem(1, 'eduyear',   istr_edu.str_eduyear)		
		dw_mst.SetItem(1, 'empseq',    istr_edu.str_empseq)
		dw_mst.SetItem(1, 'eduempno',  istr_edu.str_empno)
		dw_mst.SetItem(1, 'startdate', sDateF)
		dw_mst.SetItem(1, 'enddate',   sDateT)
		dw_mst.SetItem(1, 'eduamt',    deduamt)
		
		
		dw_mst.SetColumn("startdate")
		dw_mst.SetFocus()
		
		p_inq.TriggerEvent(Clicked!)	
	end if	
END IF

IF this.GetColumnName() ="empno" THEN
	istr_edu.str_empno = this.GetText()
	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
	
	istr_edu.str_empseq = this.GetItemNumber(1,"empseq")
	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return
	
	if istr_edu.str_gbn = '1' then				/*사내이면*/
		select distinct restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
			into :sDateF, 					:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
			from p5_educations_s
			where companycode = :gs_company and empno  = :istr_edu.str_empno and
					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
					egubn   = :istr_edu.str_gbn ;
	else
		select restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
			into :sDateF, 		:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
			from p5_educations_s
			where companycode = :gs_company and eduempno  = :istr_edu.str_empno and
					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
					egubn   = :istr_edu.str_gbn ;
	end if
	if sqlca.sqlcode = 0 then
		if sProState = 'C' or sProState = 'R' then
			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
			this.SetItem(1,"empseq", iNull)
			this.SetColumn("empseq")
			return 1
		end if
		
		this.SetItem(1, 'restartdate', sDateF)
		this.SetItem(1, 'reenddate',   sDateT)
		this.SetItem(1, 'eduamt',      deduamt)
		this.SetItem(1, 'edudesc',   	 sEduDesc)
		
		dw_mst.SetItem(1, 'eduyear',   istr_edu.str_eduyear)
		dw_mst.SetItem(1, 'empseq',    istr_edu.str_empseq)
		dw_mst.SetItem(1, 'eduempno',  istr_edu.str_empno)
		dw_mst.SetItem(1, 'startdate', sDateF)
		dw_mst.SetItem(1, 'enddate',   sDateT)
		
		dw_mst.SetColumn("startdate")
		dw_mst.SetFocus()
		
		p_inq.TriggerEvent(Clicked!)	
	end if	
END IF

end event

type rr_1 from roundrectangle within w_pig5030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 480
integer width = 4421
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

