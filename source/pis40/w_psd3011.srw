$PBExportHeader$w_psd3011.srw
$PBExportComments$화일문서자료조회
forward
global type w_psd3011 from w_standard_print
end type
type dw_1 from datawindow within w_psd3011
end type
type rr_1 from roundrectangle within w_psd3011
end type
end forward

global type w_psd3011 from w_standard_print
string title = "화일(문서)자료조회"
string menuname = "m_print"
boolean maxbox = true
dw_1 dw_1
rr_1 rr_1
end type
global w_psd3011 w_psd3011

type variables
string       ls_dkdeptcode
int            li_level

DataWindowChild state_child

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

public function integer wf_retrieve ();string ls_yy, ls_gubn, ls_sdept, ls_filejong, ls_filecode

if dw_ip.accepttext() = -1 then return -1
if dw_1.accepttext() = -1 then return -1

ls_yy = dw_ip.getitemstring(1,"yy")
ls_sdept = dw_ip.getitemstring(1,"sdept")
ls_gubn = dw_ip.getitemstring(1,"gubn")
ls_filejong = dw_ip.getitemstring(1,"fd_gubn")
ls_filecode = dw_1.getitemstring(1,"filecode")

IF ls_yy = "" OR IsNull(ls_yy) THEN
	MessageBox("확 인","처리년도를 입력하세요.")
	dw_ip.SetColumn("yy")
	dw_ip.SetFocus()
	Return -1
END IF 

if ls_sdept = "" or isnull(ls_sdept) then ls_sdept = '%'

if ls_filejong = "" or isnull(ls_filejong) then
	messagebox('확인','종류를 선택하세요')
	dw_ip.setfocus()
	return -1
end if

if ls_filecode = "" or isnull(ls_filecode) then ls_filecode = '%'
	
if ls_gubn = '1' then
	dw_list.dataobject = 'd_psd3011_2'
	dw_print.dataobject = 'd_psd3011_2_1'
elseif ls_gubn = '2' then
	dw_list.dataobject = 'd_psd3011_3'
	dw_print.dataobject = 'd_psd3011_3_1'
elseif ls_gubn = '3' then
	dw_list.dataobject = 'd_psd3011_4'
	dw_print.dataobject = 'd_psd3011_4_1'
elseif ls_gubn = '4' then
	dw_list.dataobject = 'd_psd3011_5'
	dw_print.dataobject = 'd_psd3011_5_1'
elseif ls_gubn = '5' then
	dw_list.dataobject = 'd_psd3011_6'
	dw_print.dataobject = 'd_psd3011_6_1'
end if
dw_list.settransobject(sqlca)

setpointer(hourglass!)
if dw_list.retrieve(ls_sdept, ls_yy, ls_filejong, ls_filecode) < 1 then
	messagebox('확인','자료가 없습니다')
	dw_ip.setcolumn("yy")
	dw_ip.setfocus()
	return -1
end if

return 1

setpointer(arrow!)


	
end function

on w_psd3011.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_print" then this.MenuID = create m_print
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_psd3011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.insertrow(0)
dw_1.GetChild('filecode',state_child)
state_child.settransobject(sqlca)

dw_ip.setitem(1,"yy",left(gs_today, 4))
dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_psd3011
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_psd3011
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_psd3011
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd3011
integer taborder = 30
end type







type st_10 from w_standard_print`st_10 within w_psd3011
end type



type dw_print from w_standard_print`dw_print within w_psd3011
string dataobject = "d_psd3011_2"
end type

type dw_ip from w_standard_print`dw_ip within w_psd3011
integer width = 2967
integer height = 248
string dataobject = "d_psd3011_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, snull, ls_name, ls_deptcode

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

IF this.GetColumnName() = 'sdept' then 
	
	dw_1.GetChild('filecode',state_child)
	
	ls_deptcode = this.Getitemstring(1,"sdept")
	if ls_deptcode = "" or isnull(ls_deptcode) then
		ls_deptcode = '%'
	end if
	
	state_child.settransobject(sqlca)
	state_child.retrieve(ls_deptcode)

end if

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

type dw_list from w_standard_print`dw_list within w_psd3011
integer x = 50
integer y = 296
integer width = 4539
integer height = 1960
integer taborder = 40
string dataobject = "d_psd3011_2_1"
boolean border = false
end type

type dw_1 from datawindow within w_psd3011
integer x = 1970
integer y = 36
integer width = 1024
integer height = 124
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3011_1_s"
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_psd3011
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 280
integer width = 4562
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

