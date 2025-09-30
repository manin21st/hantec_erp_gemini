$PBExportHeader$w_imt_00010.srw
$PBExportComments$** 연동구매계획
forward
global type w_imt_00010 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_00010
end type
end forward

global type w_imt_00010 from w_standard_print
string title = "연동 구매 계획 현황"
rr_1 rr_1
end type
global w_imt_00010 w_imt_00010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_mtryymm, ssaupj
String cvcod1, cvcod2, emp1, emp2, ls_m0, ls_m1, ls_m2, ls_m3, ls_m4
long lcnt, ll_mrseq

if dw_ip.AcceptText() = -1 then return -1

s_mtryymm = trim(dw_ip.GetItemString(1, "mtryymm"))
cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
emp1   = trim(dw_ip.GetItemString(1, "emp1"))
emp2   = trim(dw_ip.GetItemString(1, "emp2"))
ssaupj = dw_ip.GetItemString(1, "saupj")

If s_mtryymm = "" or IsNull(s_mtryymm) Then 
	f_message_chk(30,' [기준년월] ')
	dw_ip.Setcolumn('mtryymm')
	dw_ip.Setfocus()
	return -1
End If

If dw_ip.GetItemString(1, "mrseq") = "" or IsNull(dw_ip.GetItemString(1, "mrseq")) Then 
	f_message_chk(30,' [계획차수] ')
	dw_ip.Setcolumn('mrseq')
	dw_ip.Setfocus()
	return -1
End If

ll_mrseq = Long(dw_ip.GetItemString(1, "mrseq"))

IF IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
IF IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
IF IsNull(emp1) or emp1 = "" then emp1 = "."
IF IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

lcnt =  dw_print.Retrieve(gs_sabu, s_mtryymm, ll_mrseq ,cvcod1, cvcod2, emp1, emp2, ssaupj ) 

if lcnt < 1 then
	f_message_chk(50,'')
	dw_ip.Setcolumn('mtryymm')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

select To_char(add_months(to_date(:s_mtryymm,'YYYYMM'),0),'YYYY.MM'),
       To_char(add_months(to_date(:s_mtryymm,'YYYYMM'),1),'YYYY.MM'),
       To_char(add_months(to_date(:s_mtryymm,'YYYYMM'),2),'YYYY.MM'),
       To_char(add_months(to_date(:s_mtryymm,'YYYYMM'),3),'YYYY.MM'),
       To_char(add_months(to_date(:s_mtryymm,'YYYYMM'),4),'YYYY.MM')
into   :ls_m0, :ls_m1, :ls_m2, :ls_m3, :ls_m4
From    Dual;

dw_print.Object.t_1.text =  ls_m0
dw_print.Object.t_9.text =  String(ll_mrseq)
dw_print.Object.t_m0.text =  ls_m0
dw_print.Object.t_m1.text =  ls_m1
dw_print.Object.t_m2.text =  ls_m2
dw_print.Object.t_m3.text =  ls_m3
dw_print.Object.t_m4.text =  ls_m4

dw_list.Object.t_m0.text =  ls_m0
dw_list.Object.t_m1.text =  ls_m1
dw_list.Object.t_m2.text =  ls_m2
dw_list.Object.t_m3.text =  ls_m3
dw_list.Object.t_m4.text =  ls_m4

return 1

end function

on w_imt_00010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'mtryymm', left(f_today(), 6))
dw_ip.Setfocus()

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
   End if
End If

///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) <> 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) <> 'Z'")
//	
//	state_child1.Filter()
//	state_child2.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z'")
//	
//	state_child1.Filter()
//	state_child2.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//담당자 1
rtncode 	= dw_ip.GetChild('emp1', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)

//담당자 1
rtncode 	= dw_ip.GetChild('emp2', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_imt_00010
end type

type p_exit from w_standard_print`p_exit within w_imt_00010
end type

type p_print from w_standard_print`p_print within w_imt_00010
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_00010
end type











type dw_print from w_standard_print`dw_print within w_imt_00010
string dataobject = "d_imt_00010_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_00010
integer x = 9
integer y = 12
integer width = 3488
integer height = 256
integer taborder = 20
string dataobject = "d_imt_00010_h"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2, sdate, snull
integer i_rtn

setnull(snull)
s_cod = trim(this.GetText())

IF this.GetColumnName() = "mtryymm"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[취소일자 FROM]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1", s_cod)		
   this.setitem(1,"cvnam1", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2", s_cod)		
   this.setitem(1,"cvnam2", s_nam1)
	return i_rtn
END IF
return
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_00010
integer x = 32
integer y = 300
integer width = 4558
integer height = 2008
string dataobject = "d_imt_00010_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 284
integer width = 4594
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

