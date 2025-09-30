$PBExportHeader$w_psd1230.srw
$PBExportComments$최종고과점수표
forward
global type w_psd1230 from w_standard_print
end type
type rr_1 from roundrectangle within w_psd1230
end type
type rr_2 from roundrectangle within w_psd1230
end type
end forward

global type w_psd1230 from w_standard_print
string title = "최종고과점수표"
rr_1 rr_1
rr_2 rr_2
end type
global w_psd1230 w_psd1230

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string is_ym, is_dept, is_empno//, is_saupcd

if dw_ip.accepttext() = -1 then return -1

is_ym = dw_ip.getitemstring(1,"ym")
is_dept = dw_ip.getitemstring(1,"dept")
is_empno = dw_ip.getitemstring(1,"empno")
is_saupcd = dw_ip.GetItemString(1,"saupcd")


if is_ym = "" or isnull(is_ym) then 
	messagebox('확인','고과년월을 입력하세요')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1
end if

if is_dept = "" or isnull(is_dept) then is_dept = '%'
if is_empno = "" or isnull(is_empno) then is_empno = '%'
if is_saupcd = ""  or  isnull(is_saupcd) then	is_saupcd = '%'

if dw_list.retrieve(  is_empno, is_ym,is_dept, is_saupcd) < 1 then 
	messagebox('확인','자료가 없습니다')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1
end if	

return 1
end function

on w_psd1230.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_psd1230.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

f_set_saupcd(dw_ip,'saupcd','1')
is_saupcd = gs_saupcd

//dw_ip.insertrow(0)
dw_ip.setitem(1,"ym", left(f_today(),6))
dw_ip.setcolumn("ym")
dw_ip.setfocus()

end event

type p_xls from w_standard_print`p_xls within w_psd1230
end type

type p_sort from w_standard_print`p_sort within w_psd1230
end type

type p_preview from w_standard_print`p_preview within w_psd1230
end type

type p_exit from w_standard_print`p_exit within w_psd1230
end type

type p_print from w_standard_print`p_print within w_psd1230
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd1230
end type







type st_10 from w_standard_print`st_10 within w_psd1230
end type



type dw_print from w_standard_print`dw_print within w_psd1230
string dataobject = "d_psd1230_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_psd1230
integer x = 114
integer y = 20
integer width = 2875
string dataobject = "d_psd1230_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_empno, ls_empnm,ls_deptcode, ls_deptname

if this.getcolumnname() = "empno" then
	ls_empno = this.gettext()
	
	if ls_empno = "" or isnull(ls_empno) then 
		this.setitem(this.getrow(), "empname", "")
		return 
	end if
	
	  SELECT "P1_MASTER"."EMPNAME"
       INTO :ls_empnm
       FROM "P1_MASTER"  
      WHERE "P1_MASTER"."EMPNO" = :ls_empno ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(this.getrow(), "empno", ls_empno)
		this.setitem(this.getrow(), "empname", ls_empnm)
	end if

ELSEIF this.getcolumnname() = "dept" then
	ls_deptcode = this.gettext()

	if ls_deptcode = "" or isnull(ls_deptcode) then 
		this.setitem(this.getrow(), "deptname", "")
		return 
	end if
	
	  SELECT "P0_DEPT"."DEPTNAME"
	  INTO :ls_deptname
       FROM "P0_DEPT"  
      WHERE "P0_DEPT"."DEPTCODE" = :ls_deptcode ;
           
	if sqlca.sqlcode = 0 then
		this.setitem(this.getrow(), "dept", ls_deptcode)
		this.setitem(this.getrow(), "deptname", ls_deptname)
	end if
	
end if
end event

event dw_ip::rbuttondown;call super::rbuttondown;
setnull(gs_code)
setnull(gs_codename)

if this.getcolumnname() = "empno" then

	open(w_employee_popup)
	
	if isnull(gs_code) then return -1
		
	this.setitem(this.getrow(), "empno", gs_code)
	this.setitem(this.getrow(), "empname", gs_codename)
	
end if

if this.getcolumnname() = "dept" then

	open(w_dept_popup)
	
	if isnull(gs_code) then return -1
		
	this.setitem(this.getrow(), "dept", gs_code)
	this.setitem(this.getrow(), "deptname", gs_codename)
	
end if
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

type dw_list from w_standard_print`dw_list within w_psd1230
integer x = 69
integer y = 352
integer width = 4457
integer height = 1888
string dataobject = "d_psd1230_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_psd1230
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 41
integer y = 16
integer width = 3502
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1230
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 4521
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

