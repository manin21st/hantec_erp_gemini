$PBExportHeader$w_psd3013.srw
$PBExportComments$화일통계자료조회출력
forward
global type w_psd3013 from w_standard_print
end type
type rr_1 from roundrectangle within w_psd3013
end type
end forward

global type w_psd3013 from w_standard_print
string title = "화일(문서) 통계자료 조회"
string menuname = "m_print"
boolean maxbox = true
rr_1 rr_1
end type
global w_psd3013 w_psd3013

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

public function integer wf_retrieve ();
string ls_year, ls_gubn, ls_filejong 

if dw_ip.accepttext() = -1 then return -1

ls_year = dw_ip.getitemstring(1,"year")
ls_gubn = dw_ip.getitemstring(1,"gubn")
ls_filejong  = dw_ip.getitemstring(1,"fd_gubn")

IF ls_year = "" OR IsNull(ls_year) THEN
	MessageBox("확 인","처리년도를 입력하세요.")
	dw_ip.SetColumn("year")
	dw_ip.SetFocus()
	Return -1
END IF 

if ls_filejong = "" or isnull(ls_filejong) then
	messagebox('확인','종류를 선택하세요')
	dw_ip.setfocus()
	return -1
end if

if ls_gubn = '1' then
	dw_list.dataobject = 'd_psd2013_1'
	dw_print.dataobject = 'd_psd2013_1_1'
elseif ls_gubn = '2' then
	dw_list.dataobject = 'd_psd2013_2'
	dw_print.dataobject = 'd_psd2013_2_1'
elseif ls_gubn = '3' then
	dw_list.dataobject = 'd_psd2013_3'
	dw_print.dataobject = 'd_psd2013_3_1'
end if
dw_list.settransobject(sqlca)

if dw_list.retrieve(ls_year, ls_filejong ) < 1 then
	messagebox('확인','자료가 없습니다')
	dw_ip.setcolumn("year")
	dw_ip.setfocus()
	return -1
end if

return 1


	

end function

event open;call super::open;dw_ip.SetItem(1,"year",left(gs_today, 4))
dw_ip.SetColumn('year')
dw_ip.SetFocus()


end event

on w_psd3013.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_print" then this.MenuID = create m_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_psd3013.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_psd3013
end type

type p_exit from w_standard_print`p_exit within w_psd3013
end type

type p_print from w_standard_print`p_print within w_psd3013
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd3013
end type







type st_10 from w_standard_print`st_10 within w_psd3013
end type



type dw_print from w_standard_print`dw_print within w_psd3013
string dataobject = "d_psd2013_1"
end type

type dw_ip from w_standard_print`dw_ip within w_psd3013
integer width = 2638
integer height = 152
string dataobject = "d_psd3013_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, snull, ls_name

SetNull(snull)

AcceptText()

IF this.GetcolumnName() ="year" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "처리년도를 입력하세요.")
		SetItem(getrow(),'year',snull)
		SetColumn('year')
		dw_ip.SetFocus()
		Return 1
   END IF
END IF

IF this.GetcolumnName() ="fd_gubn" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "종류를 입력하세요.")
		SetItem(getrow(),'fd_gubn',snull)
		SetColumn('fd_gubn')
		dw_ip.SetFocus()
		Return 1
   END IF
END IF
	
	
end event

type dw_list from w_standard_print`dw_list within w_psd3013
integer x = 50
integer y = 220
integer width = 4539
integer height = 2012
string dataobject = "d_psd2013_1_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_psd3013
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

