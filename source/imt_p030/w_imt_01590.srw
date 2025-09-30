$PBExportHeader$w_imt_01590.srw
$PBExportComments$** 자재소요계산서
forward
global type w_imt_01590 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_01590
end type
type rr_2 from roundrectangle within w_imt_01590
end type
end forward

global type w_imt_01590 from w_standard_print
string title = "자재 소요 계산서"
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_01590 w_imt_01590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String cym, itnbr1, itnbr2, itgu1, empno, scvcod1, scvcod2, sortgu
Integer mrseq

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cym = dw_ip.object.cym[1]
mrseq = dw_ip.object.mrseq[1]
itnbr1 = dw_ip.object.itnbr1[1]
itnbr2 = dw_ip.object.itnbr2[1]
scvcod1 = dw_ip.object.cvcod1[1]
scvcod2 = dw_ip.object.cvcod2[1]
itgu1 =  dw_ip.object.itgu[1]
empno = Trim(dw_ip.object.empno[1])
sortgu = dw_ip.object.sortgu[1]

if itgu1 = "1" then //내자
   itgu1 = "1"
elseif itgu1 = "3" then //외자
   itgu1 = "2"
else
	itgu1 = "%"
end if	

if IsNull(cym) or cym = "" then
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("cym")
	dw_ip.Setfocus()
	return -1
elseif f_datechk(cym + '01') = -1 then 
	f_message_chk(35, "[기준년월]")
	dw_ip.SetColumn("cym")
	dw_ip.Setfocus()
	return -1
end if

if mrseq < 0 and mrseq > 9 then
	MessageBox("계획차수 확인","계획차수가 잘못 되었습니다!")
	dw_ip.SetColumn("cym")
	dw_ip.Setfocus()
	return -1
end if	

if IsNull(itnbr1) or itnbr1 = "" then itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = "" then itnbr2 = "ZZZZZZZZZZZZZZZ"
if IsNull(scvcod1) or scvcod1 = "" then scvcod1 = "."
if IsNull(scvcod2) or scvcod2 = "" then scvcod2 = "ZZZZZZZZZZZZZZZ"

if IsNull(empno) or empno = "" then
   dw_print.SetFilter("")
else	
	//거래처에 구매담당자가 기록되어 있지 않으면 '01'번 구매담당자가 담당한다. 
	if empno = '01' then 
		dw_print.SetFilter("emp_id = '" + empno + "'" + "or IsNull(emp_id)")
	else
		dw_print.SetFilter("emp_id = '" + empno + "'")
	end if	
end if	
dw_print.Filter()

if sortgu = '1' then
	dw_print.setsort("emp_id A, mtrvnd A, itnbr A")
else
	dw_print.setsort("emp_id A, mtrvnd A, itdsc A, ispec A")
end if
dw_print.sort()
dw_print.GroupCalc()

if dw_print.Retrieve(gs_sabu, cym, mrseq, itnbr1, itnbr2, itgu1, scvcod1, scvcod2, gs_saupcd) < 1 then 
   f_message_chk(50, "[자재 소요 계산서]")
	return -1
else
	dw_print.sharedata(dw_list)
end if	

return 1

end function

on w_imt_01590.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_imt_01590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1
//integer rtncode1
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('empno', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,2) = '01'")
//	state_child1.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('empno', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child1.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//담당자
rtncode 	= dw_ip.GetChild('empno', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_imt_01590
end type

type p_exit from w_standard_print`p_exit within w_imt_01590
end type

type p_print from w_standard_print`p_print within w_imt_01590
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_01590
end type







type st_10 from w_standard_print`st_10 within w_imt_01590
end type



type dw_print from w_standard_print`dw_print within w_imt_01590
string dataobject = "d_imt_01590_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_01590
integer x = 69
integer y = 28
integer width = 3557
integer height = 256
string dataobject = "d_imt_01590_01"
end type

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "cym" then //기준년월
   if f_datechk(s_cod + '01') = -1 then
	   f_message_chk(35,"[기준년월]")
	   this.object.cym[1] = ""
		this.object.mrseq[1] = 0
	   return 1
   end if
   
	select max(mrseq) into :i_rtn
	  from mtrpln_sum
	 where sabu = :gs_sabu and mtryymm = :s_cod;
	
	if sqlca.sqlcode <> 0 or i_rtn < 1 or IsNull(i_rtn) then
		messagebox("계획차수 확인", mid(s_cod,1,4) + "년" + mid(s_cod,5,2) + "월 " + &
                 "연동소요계획 차수를 찾을 수 없습니다! ")
		this.object.mrseq[1] = 0
		return 1
	else 
		this.object.mrseq[1] = i_rtn
	end if	
elseif this.getcolumnname() = 'cvcod1' then //거래처코드(FROM)  
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[1] = s_cod
	this.object.cvnam1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then //거래처코드(TO)  
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[1] = s_cod
	this.object.cvnam2[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr1' then 
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc1' then 
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn	
elseif this.getcolumnname() = 'itdsc2' then 
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn	
elseif this.getcolumnname() = 'sortgu' then 
	if s_cod = '1' then
		dw_list.setsort("emp_id A, mtrvnd A, itnbr A")
	else
		dw_list.setsort("emp_id A, mtrvnd A, itdsc A, ispec A")
	end if
	dw_list.sort()
	dw_list.GroupCalc()
end if


end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "cvcod1"	THEN //거래처코드(FROM)		
	open(w_vndmst_popup)
   this.SetItem(row, "cvcod1", gs_code)
	this.SetItem(row, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN //거래처코드(TO)		
	open(w_vndmst_popup)
   this.SetItem(row, "cvcod2", gs_code)
	this.SetItem(row, "cvnam2", gs_codename)
ELSEIF this.getcolumnname() = "itnbr1"	THEN 
	open(w_itemas_popup)
   this.SetItem(row, "itnbr1", gs_code)
	this.SetItem(row, "itdsc1", gs_codename)
ELSEIF this.getcolumnname() = "itnbr2"	THEN 
	open(w_itemas_popup)
   this.SetItem(row, "itnbr2", gs_code)
	this.SetItem(row, "itdsc2", gs_codename)
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)

IF keydown(keyF2!) THEN	
	if this.getcolumnname() = "itnbr1" then //품번1
	   open(w_itemas_popup2)
	   this.object.itnbr1[1] = gs_code
		return
   elseif this.getcolumnname() = "itnbr2" then //품번2
	   open(w_itemas_popup2)
	   this.object.itnbr2[1] = gs_code
		return
   end if
END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_01590
integer x = 59
integer y = 328
integer width = 4539
integer height = 1968
string dataobject = "d_imt_01590_02"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_imt_01590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 24
integer width = 3584
integer height = 268
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_01590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 320
integer width = 4558
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 46
end type

