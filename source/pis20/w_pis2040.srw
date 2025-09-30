$PBExportHeader$w_pis2040.srw
$PBExportComments$대여금 상환내역
forward
global type w_pis2040 from w_standard_print
end type
type rr_2 from roundrectangle within w_pis2040
end type
end forward

global type w_pis2040 from w_standard_print
string title = "대여금 상환내역"
rr_2 rr_2
end type
global w_pis2040 w_pis2040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_lendgbn, ls_jikjong, ls_deptcode, ls_date, ls_empno 


setpointer(hourglass!)
dw_ip.accepttext()


ls_lendgbn = dw_ip.GetItemString(1, "lendgbn")
IF ls_lendgbn = '' OR IsNull(ls_lendgbn) THEN ls_lendgbn = '%'


ls_date = trim(dw_ip.GetItemString(dw_ip.GetRow(),"yymm"))
if isnull(ls_date) or ls_date = '' then
	messagebox("조회일자", "조회 일자가 부정확합니다.!", information!)
	return -1
end if
//
//ls_deptcode = dw_ip.GetItemString(1, "deptcode")
//IF ls_deptcode = '' OR IsNull(ls_deptcode) THEN ls_deptcode = '%'
//
//ls_jikjong = dw_ip.GetItemString(1, 'jikjong')
//IF ls_jikjong = '' OR IsNull(ls_jikjong) THEN ls_jikjong = '%'
//
//ls_empno = dw_ip.GetItemString(1, 'empno')
//IF ls_empno = '' OR IsNull(ls_empno) THEN ls_empno = '%'
//

//if dw_print.retrieve(ls_lendgbn, ls_date, ls_deptcode, ls_jikjong, ls_empno  ) < 1 then
if dw_print.retrieve(ls_lendgbn, ls_date ) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	return -1
end if




 
dw_print.sharedata(dw_list)

setpointer(arrow!)

return 1
end function

on w_pis2040.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_pis2040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

//dw_list.Reset()
//dw_ip.Reset()

is_saupcd = gs_saupcd

dw_ip.SetItem(1, 'YYMM', left(f_today(), 6))

dw_ip.SetColumn('YYMM')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_pis2040
end type

type p_exit from w_standard_print`p_exit within w_pis2040
end type

type p_print from w_standard_print`p_print within w_pis2040
end type

type p_retrieve from w_standard_print`p_retrieve within w_pis2040
end type







type st_10 from w_standard_print`st_10 within w_pis2040
end type



type dw_print from w_standard_print`dw_print within w_pis2040
string dataobject = "d_pis2040_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pis2040
integer x = 73
integer y = 12
integer width = 1856
integer height = 172
string dataobject = "d_pis2040_c"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName, sDeptNo, sDeptName

AcceptText()

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 SetITem(1,"empno",SetNull)
				 SetITem(1,"empname",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "deptcode" THEN
	sDeptNo = GetItemString(1, "deptcode")
	
	IF sDeptNo = '' OR IsNull(sDeptNo) THEN
		SetItem(1, "deptcode", SetNull)
		SetItem(1, "deptname", SetNull)
	ELSE
		SELECT p0_dept.deptname2
		  INTO :sDeptName
		  FROM p0_dept
		 WHERE (p0_dept.companycode = :gs_company ) AND
		       (p0_dept.deptcode = :sDeptNo );
				 
	   IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인", "부서코드를 확인하세요!")
			SetItem(1, "deptcode", SetNull)
			SetItem(1, "deptname", SetNull)
			RETURN 1
		END IF
		   SetItem(1, "deptname", sDeptName)
	END IF
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF



SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF



//
//SetNull(Gs_code)
//SetNull(Gs_codename)
//SetNull(Gs_codename2)
//
//
//AcceptText()
//IF GetColumnName() = "deptname" THEN
//	Gs_Codename = GetItemString(this.GetRow(),"deptname")
//	
//	open(w_dept_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	SetItem(this.GetRow(),"deptcode",Gs_code)
//	SetItem(this.GetRow(),"deptname",Gs_codeName)
//	
//END IF
//
//IF GetColumnName() = "deptcode" THEN
//	Gs_Code = this.GetItemString(this.GetRow(),"deptcode")
//	
//	open(w_dept_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	SetItem(this.GetRow(),"deptcode",Gs_code)
//	SetItem(this.GetRow(),"deptname",Gs_codeName)
//END IF
//
//IF GetColumnName() = "empname" THEN
//	Gs_codename2 = GetItemString(this.GetRow(), "empname")
//   
//	open(w_employee_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	SetItem(this.GetRow(), "empno", Gs_code)
//	SetItem(this.GetRow(), "empname", GS_codename2)
//	
//END IF
//
//IF GetColumnName() = "empname" THEN
//	Gs_Code = this.GetItemString(this.GetRow(), "empno")
//	
//	open(w_employee_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	SetItem(this.GetRow(), "empno", Gs_code)
//	SetItem(this.GetRow(), "empname", Gs_codename2)
//	
//END IF
//	
//	
//
end event

type dw_list from w_standard_print`dw_list within w_pis2040
integer y = 212
integer width = 4549
integer height = 2016
string dataobject = "d_pis2040_1"
boolean border = false
end type

type rr_2 from roundrectangle within w_pis2040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4576
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

