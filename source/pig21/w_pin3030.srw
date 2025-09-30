$PBExportHeader$w_pin3030.srw
$PBExportComments$교육계획서
forward
global type w_pin3030 from w_standard_print
end type
type rr_1 from roundrectangle within w_pin3030
end type
end forward

global type w_pin3030 from w_standard_print
string title = "교육계획서"
rr_1 rr_1
end type
global w_pin3030 w_pin3030

type variables
str_edu    istr_edu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_year, ls_empno, ls_sdate, ls_edate,isEdetail
int li_seq

ls_year = dw_ip.getitemstring(1,"eduyear")
ls_empno = dw_ip.getitemstring(1,"empno")
li_seq = dw_ip.getitemNumber(1,"empseq")
ls_sdate = dw_ip.getitemstring(1,"restartdate")
ls_edate = dw_ip.getitemstring(1,"reenddate")


/////////////조건 check
if isnull(ls_year) or ls_year = '' then
	messagebox("조회","년도를 입력하십시요!")
	dw_ip.Setcolumn('eduyear')
	dw_ip.Setfocus()
	return -1
end if

if isnull(ls_year) or ls_year = '' then
	messagebox("조회","사번을 입력하십시요!")
	dw_ip.Setcolumn('eduyear')
	dw_ip.Setfocus()
	return -1
end if

if isnull(ls_year) or ls_year = '' then
	messagebox("조회","순번을 입력하십시요!")
	dw_ip.Setcolumn('eduyear')
	dw_ip.Setfocus()
	return -1
end if

if f_datechk(ls_sdate) = -1 then
   f_message_chk(30,'[조회일]')
	dw_ip.Setcolumn("restartdate")
	dw_ip.setfocus()
	Return -1 
elseif f_datechk(ls_edate) = -1 then
   f_message_chk(30,'[조회일]')
	dw_ip.Setcolumn("reenddate")
	dw_ip.setfocus()
	Return -1 
end if

if date(ls_sdate) > date(ls_edate)  then
   f_message_chk(50,'[조회일]')
	dw_ip.Setcolumn("edudateto")
	dw_ip.setfocus()
	Return -1 
end if

select nvl(edudetailgbn,'N')	
into :isEdetail
from p0_education a, p5_educations_s b
where a.educationcode = b.ekind and
      b.companycode = :gs_company and
		b.empno = :ls_empno and
		b.empseq = :li_seq and
		b.restartdate = :ls_sdate and
		b.reenddate = :ls_edate;

if isEdetail = 'Y' then
	dw_list.Setredraw(false)
	dw_print.DataObject = 'd_pin3030_03'
	dw_list.DataObject = 'd_pin3030_03'
else
	dw_list.Setredraw(false)
	dw_print.DataObject = 'd_pin3030_02'
	dw_list.DataObject = 'd_pin3030_02'
end if
dw_list.Settransobject(sqlca)
dw_print.Settransobject(sqlca)

	dw_list.Setredraw(true)
if dw_print.retrieve(gs_company,ls_empno,ls_year,li_seq,ls_sdate, ls_edate) < 1 then
	f_message_chk(50,"[ 자료확인 ]")
	dw_ip.setfocus()
	Return -1
end if
   dw_print.Sharedata(dw_list)

Return 1	

end function

on w_pin3030.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pin3030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,"eduyear",left(f_today(),4))

dw_ip.setfocus()
dw_list.insertrow(0)
end event

type p_preview from w_standard_print`p_preview within w_pin3030
end type

type p_exit from w_standard_print`p_exit within w_pin3030
end type

type p_print from w_standard_print`p_print within w_pin3030
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

type p_retrieve from w_standard_print`p_retrieve within w_pin3030
end type

type st_window from w_standard_print`st_window within w_pin3030
integer x = 2633
integer y = 3976
end type

type sle_msg from w_standard_print`sle_msg within w_pin3030
integer x = 658
integer y = 3976
end type

type dw_datetime from w_standard_print`dw_datetime within w_pin3030
integer x = 3127
integer y = 3976
end type

type st_10 from w_standard_print`st_10 within w_pin3030
integer x = 297
integer y = 3976
end type

type gb_10 from w_standard_print`gb_10 within w_pin3030
integer x = 283
integer y = 3940
end type

type dw_print from w_standard_print`dw_print within w_pin3030
string dataobject = "d_pin3030_02"
end type

type dw_ip from w_standard_print`dw_ip within w_pin3030
integer x = 247
integer y = 28
integer width = 3186
integer height = 208
string dataobject = "d_pin3030_01"
end type

event dw_ip::rbuttondown;call super::rbuttondown;IF This.GetColumnName() = "empno" THEN
	istr_edu.str_eduyear = this.GetItemString(1,"eduyear")
	
	openwithparm(w_edus_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)	
	this.SetItem(this.GetRow(),"restartdate",       istr_edu.str_sdate)
	this.SetItem(this.GetRow(),"reenddate",       istr_edu.str_edate)
//	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF This.GetColumnName() = "empseq" THEN
   istr_edu.str_eduyear = this.GetItemString(1,"eduyear")
	
	openwithparm(w_edus_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)	
	this.SetItem(this.GetRow(),"restartdate",       istr_edu.str_sdate)
	this.SetItem(this.GetRow(),"reenddate",       istr_edu.str_edate)
//	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	this.TriggerEvent(ItemChanged!)
	Return
END IF


end event

event dw_ip::itemchanged;call super::itemchanged;
String   sDateF,sDateT,sProState,sEduDesc
Double   dEduAmt
Integer  iNull

SetNull(iNull);

w_mdi_frame.sle_msg.text =""


IF this.GetColumnName() ="empno" THEN
	istr_edu.str_empno = this.GetText()
	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
	
	istr_edu.str_empseq = this.GetItemNumber(1,"empseq")
	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return
	
	select distinct restartdate,  reenddate
	into :sDateF, 					:sDateT
	from p5_educations_s
	where companycode = :gs_company and empno  = :istr_edu.str_empno and
	   	eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq;
		
	
	if sqlca.sqlcode <> 0 then		
			MessageBox('확 인','계획자료가 존재하지 않습니다!')
			this.SetItem(1,"empseq", iNull)
			this.SetColumn("empseq")
			return 1
	end if
		
	this.SetItem(1, 'restartdate', sDateF)
	this.SetItem(1, 'reenddate',   sDateT)
		
	p_retrieve.TriggerEvent(Clicked!)	

END IF
IF this.GetColumnName() ="empseq" THEN
	istr_edu.str_empseq = Long(this.GetText())
	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return
	
	istr_edu.str_empno = this.GetItemString(1,"empno")
	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
	
	select distinct restartdate,  reenddate
	into :sDateF, 					:sDateT
	from p5_educations_s
	where companycode = :gs_company and empno  = :istr_edu.str_empno and
	   	eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq;
		
	
	if sqlca.sqlcode <> 0 then		
			MessageBox('확 인','계획자료가 존재하지 않습니다!')
			this.SetItem(1,"empseq", iNull)
			this.SetColumn("empseq")
			return 1
	end if
		
	this.SetItem(1, 'restartdate', sDateF)
	this.SetItem(1, 'reenddate',   sDateT)
		

	p_retrieve.TriggerEvent(Clicked!)	
	
end if	
end event

type dw_list from w_standard_print`dw_list within w_pin3030
integer x = 215
integer y = 248
integer width = 4219
integer height = 1768
string dataobject = "d_pin3030_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pin3030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 201
integer y = 240
integer width = 4251
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

