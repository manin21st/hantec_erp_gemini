$PBExportHeader$wp_peh1010.srw
$PBExportComments$** 학자금 지급 집계표
forward
global type wp_peh1010 from w_standard_print
end type
type rr_1 from roundrectangle within wp_peh1010
end type
end forward

global type wp_peh1010 from w_standard_print
string title = "학자금지급집계표"
string menuname = "m_print"
boolean maxbox = true
rr_1 rr_1
end type
global wp_peh1010 wp_peh1010

type variables
string       ls_dkdeptcode
int            li_level
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

public function integer wf_retrieve ();String sbunki,syy,sdeptcode,ssaupj,saupname
Long i

if dw_ip.AcceptText() = -1 then return -1
dw_list.Reset()

sbunki = dw_ip.GetItemString(1,"bunki")
syy   = dw_ip.GetItemString(1,"year")
ssaupj = dw_ip.GetItemString(1, "saupcd")
sdeptcode = dw_ip.GetItemString(1,'deptcode')

IF syy = "" OR IsNull(syy) THEN
	MessageBox("확 인","출력년도를 입력하세요.")
	dw_ip.SetColumn("year")
	dw_ip.SetFocus()
	Return -1
END IF 

IF sdeptcode = "" OR IsNull(sdeptcode) THEN
	sdeptcode = '%'
END IF

if ssaupj = "" or isnull(ssaupj) then
	ssaupj = '%'
end if

SELECT "P0_SAUPCD"."SAUPNAME"  
 INTO :saupname  
 FROM "P0_SAUPCD"  
WHERE ( "P0_SAUPCD"."COMPANYCODE" = :gs_company ) AND  
		( "P0_SAUPCD"."SAUPCODE" = :ssaupj )   ;

IF ssaupj = '%' THEN
	dw_list.Modify("t_10.text ='"+"전체"+"'")	
ELSE	
	dw_list.Modify("t_10.text ='"+trim(saupname)+"'")
END IF	

SetPointer(HourGlass!)	

dw_list.SetRedraw(False)
if li_level = 2  then	 
	IF dw_list.Retrieve(gs_company,syy,sbunki,ssaupj,'%',sdeptcode) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.SetRedraw(True)
		Return -1
	END IF
else
	IF dw_list.Retrieve(gs_company,syy,sbunki,ssaupj,sdeptcode,'%') <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.SetRedraw(True)
		Return -1
	END IF

end if	
dw_list.SetRedraw(True)
SetPointer(Arrow!)	

Return 1

end function

event open;call super::open;dw_ip.SetItem(1,"year",left(gs_today, 4))
//wf_reset()
f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd
dw_ip.SetColumn('year')
dw_ip.SetFocus()


end event

on wp_peh1010.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_print" then this.MenuID = create m_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_peh1010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within wp_peh1010
end type

type p_exit from w_standard_print`p_exit within wp_peh1010
end type

type p_print from w_standard_print`p_print within wp_peh1010
end type

type p_retrieve from w_standard_print`p_retrieve within wp_peh1010
end type







type st_10 from w_standard_print`st_10 within wp_peh1010
end type



type dw_print from w_standard_print`dw_print within wp_peh1010
string dataobject = "dp_peh1010_20a"
end type

type dw_ip from w_standard_print`dw_ip within wp_peh1010
integer width = 3314
integer height = 152
string dataobject = "dp_peh1010_10"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)


AcceptText()
IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	Gs_Gubun = is_saupcd
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, snull, ls_name

SetNull(snull)

AcceptText()

IF GetColumnName() = "deptcode" then
  sDeptCode = GetItemString(1,"deptcode")

	  IF sDeptCode = '' or isnull(sDeptCode) THEN
		  SetITem(1,"deptcode",SetNull)
		  SetITem(1,"deptname",SetNull)
	  ELSE	
		  IF f_chk_saupemp(sDeptCode, '2', is_saupcd) = False THEN
			  SetItem(getrow(),'deptcode',snull)
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


IF GetColumnName() = "saupcd" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF


IF this.GetcolumnName() ="year" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "출력년도를 입력하세요.")
		SetItem(getrow(),'year',snull)
		SetColumn('year')
		dw_ip.SetFocus()
		Return 1
   END IF
END IF

IF this.GetcolumnName() ="bunki" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "분기를 입력하세요.")
		SetItem(getrow(),'bunki',snull)
		SetColumn('bunki')
		dw_ip.SetFocus()
		Return 1
   END IF
END IF
	
	
end event

type dw_list from w_standard_print`dw_list within wp_peh1010
integer x = 50
integer y = 220
integer width = 4539
integer height = 2012
string dataobject = "dp_peh1010_20a_1"
boolean border = false
end type

type rr_1 from roundrectangle within wp_peh1010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 204
integer width = 4562
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

