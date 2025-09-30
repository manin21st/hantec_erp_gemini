$PBExportHeader$w_psd1005_2.srw
$PBExportComments$** 월별 학자금 지급내역
forward
global type w_psd1005_2 from w_standard_print
end type
type rr_1 from roundrectangle within w_psd1005_2
end type
end forward

global type w_psd1005_2 from w_standard_print
string title = "월별학자금지급내역"
string menuname = "m_print"
boolean maxbox = true
rr_1 rr_1
end type
global w_psd1005_2 w_psd1005_2

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

public function integer wf_retrieve ();String syy,ssaupj
Long i

if dw_ip.AcceptText() = -1 then return -1
dw_list.Reset()

syy   = dw_ip.GetItemString(1,"sfdate")
ssaupj = dw_ip.GetItemString(1, "saupcd")

IF syy = "" OR IsNull(syy) THEN
	MessageBox("확 인","조회년도를 입력하세요.")
	dw_ip.SetColumn("sfdate")
	dw_ip.SetFocus()
	Return -1
END IF 

if ssaupj = "" or isnull(ssaupj) then
	ssaupj = '%'
end if


SetPointer(HourGlass!)	

dw_list.SetRedraw(False)
	IF dw_list.Retrieve(syy,ssaupj) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.SetRedraw(True)
		SetPointer(Arrow!)	
		Return -1
	END IF
dw_list.SetRedraw(True)
SetPointer(Arrow!)	

Return 1

end function

event open;call super::open;dw_ip.SetItem(1,"sfdate",left(gs_today, 4))
//wf_reset()
f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd
dw_ip.SetColumn('sfdate')
dw_ip.SetFocus()


end event

on w_psd1005_2.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_print" then this.MenuID = create m_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_psd1005_2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_psd1005_2
end type

type p_exit from w_standard_print`p_exit within w_psd1005_2
end type

type p_print from w_standard_print`p_print within w_psd1005_2
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd1005_2
end type







type st_10 from w_standard_print`st_10 within w_psd1005_2
end type



type dw_print from w_standard_print`dw_print within w_psd1005_2
string dataobject = "d_psd1005_2"
end type

type dw_ip from w_standard_print`dw_ip within w_psd1005_2
integer width = 1618
integer height = 132
string dataobject = "d_psd1005_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, snull, ls_name

SetNull(snull)

AcceptText()

IF GetColumnName() = "saupcd" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF


IF this.GetcolumnName() ="sfdate" THEN
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "조회년도를 입력하세요.")
		SetItem(getrow(),'sfdate',snull)
		SetColumn('sfdate')
		dw_ip.SetFocus()
		Return 1
   END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_psd1005_2
integer x = 50
integer y = 220
integer width = 4539
integer height = 2012
string dataobject = "d_psd1005_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_psd1005_2
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

