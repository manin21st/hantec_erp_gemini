$PBExportHeader$wp_pik2111.srw
$PBExportComments$**기간별 개인근태 현황
forward
global type wp_pik2111 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pik2111
end type
end forward

global type wp_pik2111 from w_standard_print
integer x = 0
integer y = 0
integer height = 2608
string title = "기간별개인근태현황"
rr_2 rr_2
end type
global wp_pik2111 wp_pik2111

type variables
int li_level
string ls_dkdeptcode, is_timegbn
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_retrieve ()
end prototypes

public subroutine wf_reset ();string sname

// 환경변수 근태담당부서 
SELECT dataname
	INTO :ls_dkdeptcode
	FROM p0_syscnfg
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
	dw_ip.SetItem(1,"deptcode",'')
else
	dw_ip.SetItem(1,"deptcode",gs_dept)
	
	/*부서명*/
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :gs_dept ); 
	if sqlca.sqlcode <> 0 then
	else
		dw_ip.SetItem(1,"deptname",sname)
	end if	
end if	




end subroutine

public function integer wf_retrieve ();String sStartYear,sEndYear, sdeptcode,sdept,sadddept
string sEmpNo1,   sDeptName ,sEmpNo2, sabu
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3


if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"dayfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"dayto"))

sEmpno1    = trim(dw_ip.GetItemString(1,"empno1"))
sEmpNo2    = trim(dw_ip.GetItemString(1,"empno2"))

sJikjong0  = dw_ip.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_ip.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_ip.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_ip.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_ip.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_ip.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_ip.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_ip.GetItemString(1,"kunmu3")		// 용역 : 40

sabu = dw_ip.getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'
sdeptcode    = trim(dw_ip.GetItemString(1,"deptcode"))
IF sdeptcode = '' or isnull(sdeptcode) THEN
	sdeptcode = '%'
END IF

if li_level = 3 then
	sdept = sdeptcode
	sadddept = '%'
else
	sdept = '%'
	sadddept = sdeptcode
	
end if		
		
IF sStartYear = '' or isnull(sStartYear) THEN
	MessageBox("확 인","시작일자를 입력하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sEndYear = '' or isnull(sEndYear) THEN
	MessageBox("확 인","종료일자를 입력하세요!!")
	dw_ip.SetColumn('dayto')
	dw_ip.SetFocus()
	Return -1
END IF
IF sStartYear > sEndYear THEN
	MessageBox("확 인","출력년월일 범위를 확인하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF	

IF sEmpNo1 = "" OR IsNull(sEmpNo1) THEN
	sEmpNo1='.'
	sEmpNo2='z'
ELSEIF sEmpNo2 = "" OR IsNull(sEmpNo2) THEN
	sEmpNo2 = sEmpNo1
END IF

IF dw_list.Retrieve(sStartYear,sEndYear,sEmpNo1,sDeptName,sEmpNo2,sdept,sadddept,sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF

 Return 1
end function

on wp_pik2111.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pik2111.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_print.ShareDataOff()

dw_ip.SetItem(1,"dayfrom",String(gs_today))
dw_ip.SetItem(1,"dayto",String(gs_today))
dw_ip.SetItem(1,"jikjong0", "0")
dw_ip.SetItem(1,"jikjong1", "1")
dw_ip.SetItem(1,"jikjong2", "2")
dw_ip.SetItem(1,"kunmu0", "10")
//wf_reset()
f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd
dw_ip.SetColumn('dayfrom')
dw_ip.SetFocus()


is_timegbn = f_get_p0_syscnfg(8, '1')
end event

type p_xls from w_standard_print`p_xls within wp_pik2111
end type

type p_sort from w_standard_print`p_sort within wp_pik2111
end type

type p_preview from w_standard_print`p_preview within wp_pik2111
integer x = 4069
end type

event p_preview::clicked;String sStartYear,sEndYear, sdeptcode,sdept,sadddept
string sEmpNo1,   sDeptName ,sEmpNo2, sabu

if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"dayfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"dayto"))

sEmpno1    = trim(dw_ip.GetItemString(1,"empno1"))
sEmpNo2    = trim(dw_ip.GetItemString(1,"empno2"))

sabu = dw_ip.getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'
sdeptcode    = trim(dw_ip.GetItemString(1,"deptcode"))
IF sdeptcode = '' or isnull(sdeptcode) THEN
	sdeptcode = '%'
END IF

if li_level = 3 then
	sdept = sdeptcode
	sadddept = '%'
else
	sdept = '%'
	sadddept = sdeptcode
	
end if		
		

IF sEmpNo1 = "" OR IsNull(sEmpNo1) THEN
	sEmpNo1='.'
	sEmpNo2='z'
ELSEIF sEmpNo2 = "" OR IsNull(sEmpNo2) THEN
	sEmpNo2 = sEmpNo1
END IF

dw_print.Retrieve(gs_company,sStartYear,sEndYear,sEmpNo1,sDeptName,sEmpNo2,sdept,sadddept,sabu, is_timegbn) 
OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within wp_pik2111
integer x = 4416
end type

type p_print from w_standard_print`p_print within wp_pik2111
integer x = 4242
end type

event p_print::clicked;String sStartYear,sEndYear, sdeptcode,sdept,sadddept
string sEmpNo1,   sDeptName ,sEmpNo2, sabu
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3

if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"dayfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"dayto"))

sEmpno1    = trim(dw_ip.GetItemString(1,"empno1"))
sEmpNo2    = trim(dw_ip.GetItemString(1,"empno2"))

sJikjong0  = dw_ip.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_ip.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_ip.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_ip.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_ip.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_ip.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_ip.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_ip.GetItemString(1,"kunmu3")		// 용역 : 40

sabu = dw_ip.getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'
sdeptcode    = trim(dw_ip.GetItemString(1,"deptcode"))
IF sdeptcode = '' or isnull(sdeptcode) THEN
	sdeptcode = '%'
END IF

if li_level = 3 then
	sdept = sdeptcode
	sadddept = '%'
else
	sdept = '%'
	sadddept = sdeptcode
	
end if		
		

IF sEmpNo1 = "" OR IsNull(sEmpNo1) THEN
	sEmpNo1='.'
	sEmpNo2='z'
ELSEIF sEmpNo2 = "" OR IsNull(sEmpNo2) THEN
	sEmpNo2 = sEmpNo1
END IF

dw_print.Retrieve(gs_company,sStartYear,sEndYear,sEmpNo1,sDeptName,sEmpNo2,sdept,sadddept,sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3)

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pik2111
integer x = 3895
end type

type st_window from w_standard_print`st_window within wp_pik2111
boolean visible = false
integer x = 2427
integer y = 2712
end type

type sle_msg from w_standard_print`sle_msg within wp_pik2111
boolean visible = false
integer x = 453
integer y = 2712
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik2111
boolean visible = false
integer x = 2921
integer y = 2712
end type

type st_10 from w_standard_print`st_10 within wp_pik2111
boolean visible = false
integer x = 91
integer y = 2712
end type

type gb_10 from w_standard_print`gb_10 within wp_pik2111
boolean visible = false
integer x = 78
integer y = 2660
end type

type dw_print from w_standard_print`dw_print within wp_pik2111
string dataobject = "dp_pik2111_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within wp_pik2111
integer x = 370
integer y = 40
integer width = 3493
integer height = 260
integer taborder = 30
string dataobject = "dp_pik2111_4"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpCode,sEmpName,SetNull,sDeptCode,sDeptName, ls_date,sColName1,sColName2, ls_name

AcceptText()
sColName1 = GetColumnName()

IF sColName1 = "empno1" or sColName1 = "empno2" THEN
	
	IF sColName1 = "empno1" THEN sColName2 = "empname1"
	IF sColName1 = "empno2" THEN sColName2 = "empname2"
	
	sEmpCode = GetItemString(1,sColName1)

	IF sEmpCode = "" OR ISNULL(sEmpCode) THEN
		SetItem(1,sColName2,"")
		Return 1
	ELSE
		SELECT "P1_MASTER"."EMPNAME"  
		  INTO :sEmpName  
		  FROM "P1_MASTER"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpCode ) ; 
   	IF SQLCA.SQLCODE <> 0  THEN
			 MessageBox("확인" ,"사원코드를 확인하세요!") 
		    SetItem(1,sColName1,"")
			 SetItem(1,sColName2,"")
			 Return 1
		END IF
		    SetItem(1,sColName2,sEmpName) 
	END IF

END IF

IF sColName1 = "empname1" or sColName1 = "empname2" THEN
	
	IF sColName1 = "empname1" THEN sColName2 = "empno1"
	IF sColName1 = "empname2" THEN sColName2 = "empno2"
	
	sEmpName = GetItemString(1,sColName1)

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', '%')	 
	 if IsNull(ls_name) then 
		 Setitem(1,sColName1,ls_name)
		 Setitem(1,sColName2,ls_name)
		 return 2
    end if
	 Setitem(1,sColName2,ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', '%')
	 Setitem(1,sColName1,ls_name)
	 return 1

END IF

IF GetColumnName() = "deptcode" then
  sDeptCode = GetItemString(1,"deptcode")

	  IF sDeptCode = '' or isnull(sDeptCode) THEN
		  SetITem(1,"deptcode",SetNull)
		  SetITem(1,"deptname",SetNull)
	  ELSE	
		  IF f_chk_saupemp(sDeptCode, '2', is_saupcd) = False THEN
			  SetItem(getrow(),'deptcode',SetNull)
			  SetColumn('deptcode')
			  dw_ip.SetFocus()
			  Return 1
		  END IF			
		
		  SELECT "P0_DEPT"."DEPTNAME"  
			 INTO :sDeptName
			 FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
					( "P0_DEPT"."DEPTCODE" = :sDeptCode ); 
			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원번호를 확인하세요!!") 
//				 SetITem(1,"deptcode",SetNull)
//				 SetITem(1,"deptname",SetNull)
//				 RETURN 1 
//			 END IF
				SetITem(1,"deptname",sDeptName  )
				
	 END IF
END IF


IF GetColumnName() = "sabu" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF


IF this.GetcolumnName() ="dayfrom" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'dayfrom',SetNull)
		SetColumn('dayfrom')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF


IF this.GetcolumnName() ="dayto" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'dayto',SetNull)
		SetColumn('dayto')
		dw_ip.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(this.GetRow(), 'dayfrom')
	IF long(data) < long(ls_date) THEN
		MessageBox("확 인", "출력일자 범위가 부정확합니다.")
		SetItem(getrow(),'dayto',SetNull)
		SetColumn('dayto')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF

return
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

AcceptText()
IF GetColumnName() = "empno1" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno1")
	
	Gs_Gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno1",Gs_code)
	SetItem(this.GetRow(),"empname1",Gs_codeName)
	
END IF

IF GetColumnName() = "empno2" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno2")
	
	Gs_Gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno2",Gs_code)
	SetItem(this.GetRow(),"empname2",Gs_codeName)
	
END IF

IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	Gs_gubun = is_saupcd
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wp_pik2111
integer x = 393
integer y = 328
integer width = 3817
integer height = 1952
string dataobject = "dp_pik2111"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pik2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 375
integer y = 320
integer width = 3849
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

