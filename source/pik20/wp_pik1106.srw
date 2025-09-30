$PBExportHeader$wp_pik1106.srw
$PBExportComments$**기간별근태현황집계표
forward
global type wp_pik1106 from w_standard_print
end type
type dw_excel from datawindow within wp_pik1106
end type
type rr_1 from roundrectangle within wp_pik1106
end type
end forward

global type wp_pik1106 from w_standard_print
string title = "기간별근태현황집계표"
dw_excel dw_excel
rr_1 rr_1
end type
global wp_pik1106 wp_pik1106

type variables
string is_timegbn
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sStartYear,sEndYear, sabu
string sDeptcode,sempno, sService
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3

if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"dayfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"dayto"))

sDeptcode   = trim(dw_ip.GetItemString(1,"deptcode"))
sempno   = trim(dw_ip.GetItemString(1,"empno"))

sService   = trim(dw_ip.GetItemString(1,"service"))

sJikjong0  = dw_ip.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_ip.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_ip.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_ip.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_ip.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_ip.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_ip.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_ip.GetItemString(1,"kunmu3")		// 용역 : 40

sabu = dw_ip.Getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'

IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
	sDeptcode= '%'
END IF

IF sempno = "" OR IsNull(sempno) THEN	
	sempno= '%'
END IF

IF sService = "" OR IsNull(sService) THEN	
	sService= '%'
END IF

IF sStartYear = "" OR IsNull(sStartYear) THEN
	MessageBox("확 인","시작일자를 입력하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sEndYear = "" OR IsNull(sEndYear) THEN
	MessageBox("확 인","종료일자를 입력하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sStartYear > sEndYear THEN
	MessageBox("확 인","출력일자 범위를 확인하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF


IF dw_print.Retrieve(sDeptcode,sStartYear,sEndYear, sempno, sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2, sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3,sService) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF
   dw_list.Retrieve(sDeptcode,sStartYear,sEndYear, sempno, sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2, sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3,sService)
   dw_excel.Retrieve(sDeptcode,sStartYear,sEndYear, sempno, sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2, sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3,sService)	
Return 1
end function

on wp_pik1106.create
int iCurrent
call super::create
this.dw_excel=create dw_excel
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_excel
this.Control[iCurrent+2]=this.rr_1
end on

on wp_pik1106.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_excel)
destroy(this.rr_1)
end on

event open;call super::open;dw_excel.settransobject(sqlca)

dw_print.ShareDataOff()
dw_ip.SetItem(1,"jikjong0", "0")
dw_ip.SetItem(1,"jikjong1", "1")
dw_ip.SetItem(1,"jikjong2", "2")
dw_ip.SetItem(1,"kunmu0", "10")
dw_ip.SetItem(1,"dayfrom",String(gs_today))
dw_ip.SetItem(1,"dayto",String(gs_today))
dw_ip.SetColumn('dayfrom')
dw_ip.SetFocus()

f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd

is_timegbn = f_get_p0_syscnfg(8, '1')

//권한체크 (2024.04.29 김은희 요청)

string sAuth, sDeptName, sEmpname
Int iGetAuth

SELECT COUNT("P0_SYSCNFG"."DATANAME")  														/*근태 담당부서*/
	INTO :iGetAuth 
   FROM "P0_SYSCNFG"  
   WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "P0_SYSCNFG"."SERIAL" = 1 ) AND  
         ( "P0_SYSCNFG"."LINENO" <> '00' ) AND
		( "P0_SYSCNFG"."DATANAME"  = :gs_dept );

IF SQLCA.SQLCODE <> 0 THEN	
	sAuth = 'N'
END IF				
			
IF iGetAuth < 1 THEN 
	sAuth = 'N'
ELSE
	sAuth = 'Y'	
END IF

IF sAuth = 'N' THEN
	dw_ip.SetItem(1,"deptcode",gs_dept)

	SELECT "DEPTNAME2"	INTO :sDeptName
		FROM "P0_DEPT"
		WHERE "P0_DEPT"."DEPTCODE" =:gs_dept;
		
	dw_ip.SetItem(1,"deptname",sDeptName)
	dw_ip.Modify("deptcode.protect = 1")
	
	sEmpName =  f_get_empname(gs_empno)
	
	dw_ip.SetItem(1,"empno",gs_empno)	
	dw_ip.SetItem(1,"empname",sEmpName)
	dw_ip.Modify("empno.protect = 1")	
	dw_ip.Modify("empname.protect = 1")		
	
END IF

end event

type p_xls from w_standard_print`p_xls within wp_pik1106
boolean visible = true
integer x = 4443
integer y = 164
end type

event p_xls::clicked;If this.Enabled Then wf_excel_down(dw_excel)
end event

type p_sort from w_standard_print`p_sort within wp_pik1106
integer x = 4265
integer y = 164
end type

type p_preview from w_standard_print`p_preview within wp_pik1106
end type

type p_exit from w_standard_print`p_exit within wp_pik1106
end type

type p_print from w_standard_print`p_print within wp_pik1106
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik1106
end type

type st_window from w_standard_print`st_window within wp_pik1106
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pik1106
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik1106
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pik1106
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pik1106
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pik1106
integer x = 4119
integer y = 180
string dataobject = "dp_pik1106_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik1106
integer x = 169
integer y = 28
integer width = 3744
integer height = 292
string dataobject = "dp_pik1106_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, ls_date, ls_name

AcceptText()

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE	
		  IF f_chk_saupemp(sEmpNo, '1', is_saupcd) = False THEN
			  SetItem(getrow(),'empno',SetNull)
			  SetColumn('empno')
			  dw_ip.SetFocus()
			  Return 1
		  END IF			
		
			 SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원번호를 확인하세요!!") 
//				 SetITem(1,"empno",SetNull)
//				 SetITem(1,"empname",SetNull)
//				 RETURN 1 
//			 END IF
				SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
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
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	Gs_Gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF



SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

AcceptText()
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

type dw_list from w_standard_print`dw_list within wp_pik1106
integer x = 187
integer y = 328
integer width = 4224
integer height = 1904
string dataobject = "dp_pik1106"
boolean border = false
end type

type dw_excel from datawindow within wp_pik1106
boolean visible = false
integer x = 3945
integer y = 176
integer width = 155
integer height = 136
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dp_pik1106_excel"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within wp_pik1106
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 178
integer y = 320
integer width = 4242
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

