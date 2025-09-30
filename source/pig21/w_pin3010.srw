$PBExportHeader$w_pin3010.srw
$PBExportComments$교육계획조회(출력)
forward
global type w_pin3010 from w_standard_print
end type
type rr_1 from roundrectangle within w_pin3010
end type
end forward

global type w_pin3010 from w_standard_print
string title = "교육계획"
rr_1 rr_1
end type
global w_pin3010 w_pin3010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupjang, ls_startdate, ls_enddate, ls_deptcode, ls_empno, ls_prtgbn1, ls_prtgbn2
string ls_kind, ls_eoffice

ls_saupjang = dw_ip.getitemstring(1,"saupjang")
ls_startdate = dw_ip.getitemstring(1,"edudatefrom")
ls_enddate = dw_ip.getitemstring(1,"edudateto")
ls_deptcode = dw_ip.getitemstring(1,"deptcode")
ls_empno = dw_ip.getitemstring(1,"empno")
ls_prtgbn2 = dw_ip.getitemstring(1,"prtgbn2")
ls_kind = dw_ip.getitemstring(1,"ekind")
ls_eoffice = dw_ip.getitemstring(1,"eoffice")

/////////////조건 check
if isnull(ls_saupjang) or ls_saupjang = '' then
	ls_saupjang = '%'
end if

if isnull(ls_kind) or ls_kind = '' then
	ls_kind = '%'
end if

if isnull(ls_eoffice) or ls_eoffice = '' then
	ls_eoffice = '%'
end if

if f_datechk(ls_startdate) = -1 then
   f_message_chk(30,'[조회일]')
	dw_ip.Setcolumn("edudatefrom")
	dw_ip.setfocus()
	Return -1 
elseif f_datechk(ls_enddate) = -1 then
   f_message_chk(30,'[조회일]')
	dw_ip.Setcolumn("edudateto")
	dw_ip.setfocus()
	Return -1 
end if

if date(ls_startdate) > date(ls_enddate)  then
   f_message_chk(50,'[조회일]')
	dw_ip.Setcolumn("edudateto")
	dw_ip.setfocus()
	Return -1 
end if


if isnull(ls_deptcode) or ls_deptcode = '' then
	ls_deptcode = '%'
end if

if isnull(ls_empno) or ls_empno = '' then
	ls_empno = '%'
end if

if ls_prtgbn2 = '1' then
	dw_print.Dataobject = "d_pin3010_02_p"  /*부서별*/	
elseif ls_prtgbn2 = '2' then	
	dw_print.Dataobject = "d_pin3010_03_p"  /*유형별*/	
elseif ls_prtgbn2 = '3' then
	dw_print.Dataobject = "d_pin3010_04_p"  /*교육기관별*/	
elseif ls_prtgbn2 = '4' then	
	dw_print.Dataobject = "d_pin3010_05_p"  /*일자별*/	
elseif ls_prtgbn2 = '5' then	
	dw_print.Dataobject = "d_pin3010_06_p"  /*전체*/		
end if

dw_print.Settransobject(sqlca)



if dw_print.retrieve(ls_empno,ls_startdate,ls_enddate,ls_kind,ls_deptcode, ls_eoffice) < 1 then
	f_message_chk(50,"[ 자료확인 ]")
	dw_ip.setfocus()
	Return -1
end if
   dw_print.Sharedata(dw_list)

Return 1	

end function

on w_pin3010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pin3010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string ls_startdate, ls_enddate

dw_ip.setitem(1,"edudatefrom",left(f_today(),4)+'0101')
dw_ip.setitem(1,"edudateto",f_today())
dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_pin3010
end type

type p_exit from w_standard_print`p_exit within w_pin3010
end type

type p_print from w_standard_print`p_print within w_pin3010
end type

event p_print::clicked;string ls_saupjang, ls_startdate, ls_enddate, ls_deptcode, ls_empno, ls_prtgbn1, ls_prtgbn2
string gbn

ls_saupjang = dw_ip.getitemstring(1,"saupjang")
ls_startdate = dw_ip.getitemstring(1,"edudatefrom")
ls_enddate = dw_ip.getitemstring(1,"edudateto")
ls_deptcode = dw_ip.getitemstring(1,"deptcode")
ls_empno = dw_ip.getitemstring(1,"empno")
ls_prtgbn1 = dw_ip.getitemstring(1,"prtgbn1")
ls_prtgbn2 = dw_ip.getitemstring(1,"prtgbn2")
gbn = dw_ip.getitemstring(1,"gbn")
/////////////조건 check
if isnull(ls_saupjang) or ls_saupjang = '' then
	ls_saupjang = '%'
end if

if isnull(ls_deptcode) or ls_deptcode = '' then
	ls_deptcode = '%'
end if

if isnull(ls_empno) or ls_empno = '' then
	ls_empno = '%'
end if

if ls_prtgbn1 = '1' then
	dw_print.object.prtgbn1.text = "[ 사내 교육 ]"
elseif ls_prtgbn1 = '2' then
	dw_print.object.prtgbn1.text = "[ 사외 교육 ]"
elseif ls_prtgbn1 = '3' then
	ls_prtgbn1 = '%'
end if

dw_print.retrieve(ls_empno,ls_startdate,ls_enddate,ls_prtgbn1,ls_deptcode,ls_saupjang,gbn) 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pin3010
end type

type st_window from w_standard_print`st_window within w_pin3010
integer x = 2633
integer y = 3976
end type

type sle_msg from w_standard_print`sle_msg within w_pin3010
integer x = 658
integer y = 3976
end type

type dw_datetime from w_standard_print`dw_datetime within w_pin3010
integer x = 3127
integer y = 3976
end type

type st_10 from w_standard_print`st_10 within w_pin3010
integer x = 297
integer y = 3976
end type

type gb_10 from w_standard_print`gb_10 within w_pin3010
integer x = 283
integer y = 3940
end type

type dw_print from w_standard_print`dw_print within w_pin3010
string dataobject = "d_pin3020_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pin3010
integer x = 489
integer y = 28
integer width = 3186
integer height = 316
string dataobject = "d_pin3010_01"
end type

event dw_ip::rbuttondown;call super::rbuttondown;if dw_ip.getcolumnname() = "empno" then
	open(w_employee_popup)
	
	dw_ip.setitem(1,"empno",gs_code)
	dw_ip.setitem(1,"empname",gs_codename)
elseif dw_ip.getcolumnname() = "deptcode" then
	open(w_dept_popup)
	
	dw_ip.setitem(1,"deptcode",gs_code)
end if

end event

event dw_ip::itemchanged;call super::itemchanged;string ls_empno, sname

if this.AcceptText() <> 1 then Return 

if this.getcolumnname() = "empno" then
	
	ls_empno = this.getitemstring(1,"empno")
	
	if isnull(ls_empno) or ls_empno = '' then
	 this.setitem(1,"empname",'')
   end if
	
	select empname into :sname
	from p1_master
	where companycode = :gs_company and
	      empno = :ls_empno;
			
			dw_ip.setitem(1,"empname",sname)
end if
end event

type dw_list from w_standard_print`dw_list within w_pin3010
integer x = 215
integer y = 372
integer width = 4219
integer height = 1768
string dataobject = "d_pin3010_02"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pin3010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 201
integer y = 364
integer width = 4251
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

