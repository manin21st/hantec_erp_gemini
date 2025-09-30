$PBExportHeader$w_imt_05000_1.srw
$PBExportComments$** 매입마감 회계전송 - 차수조회
forward
global type w_imt_05000_1 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_imt_05000_1
end type
type rr_2 from roundrectangle within w_imt_05000_1
end type
end forward

global type w_imt_05000_1 from w_inherite_popup
integer x = 457
integer y = 124
integer width = 2862
integer height = 2080
string title = "구매/외주 마감번호"
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_05000_1 w_imt_05000_1

on w_imt_05000_1.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_imt_05000_1.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)
dw_jogun.setitem(1, "yymm",  left(f_today(), 6))
if gs_code = '1' or gs_code = '2' or gs_code = '3' or gs_code = '9' then
	dw_jogun.setitem(1, "gubun", gs_code)
else
	dw_jogun.setitem(1, "gubun", 'Z')
	dw_jogun.SetTabOrder('gubun',0)
end if

f_mod_saupj(dw_jogun,'saupj')

setnull(gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_05000_1
integer x = 82
integer y = 48
integer width = 2071
integer height = 324
string dataobject = "d_imt_05000_1_01"
end type

event dw_jogun::itemchanged;call super::itemchanged;string s_cod, s_nam1, s_nam2, snull
int    i_rtn
long   lrow, lreturnrow

lrow = this.getrow()

setnull(snull)

if this.GetColumnName() = "cvcod1" then	
   s_cod = Trim(this.GetText())
	
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[lrow] = s_cod
	this.object.cvnam1[lrow] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "cvcod2" then	
   s_cod = Trim(this.GetText())
	
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[lrow] = s_cod
	this.object.cvnam2[lrow] = s_nam1
	return i_rtn	
elseif this.GetColumnName() = "empno1" then	
   s_cod = Trim(this.GetText())
	
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.empno1[lrow] = s_cod
	this.object.empnm1[lrow] = s_nam1
	return i_rtn		
elseif this.GetColumnName() = "empno2" then	
   s_cod = Trim(this.GetText())
	
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.empno2[lrow] = s_cod
	this.object.empnm2[lrow] = s_nam1
	return i_rtn			
end if
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;string snull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(sNull)

IF	this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then 
		this.SetItem(row, "cvcod1", snull)
		this.SetItem(row, "cvnam1", sNull)		
		return 
	end if
	this.SetItem(row, "cvcod1", gs_code)
	this.SetItem(row, "cvnam1", gs_codename)
elseIF	this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then 
		this.SetItem(row, "cvcod2", snull)
		this.SetItem(row, "cvnam2", sNull)		
		return 
	end if
	this.SetItem(row, "cvcod2", gs_code)
	this.SetItem(row, "cvnam2", gs_codename)
elseIF	this.getcolumnname() = "empno1"	THEN		
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then 
		this.SetItem(row, "empno1", snull)
		this.SetItem(row, "empnm1", snull)			
		return 
	end if
	this.SetItem(row, "empno1", gs_code)
	this.SetItem(row, "empnm1", gs_codename)	
elseIF	this.getcolumnname() = "empno2"	THEN		
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then 
		this.SetItem(row, "empno2", snull)
		this.SetItem(row, "empnm2", snull)			
		return 
	end if
	this.SetItem(row, "empno2", gs_code)
	this.SetItem(row, "empnm2", gs_codename)		
end if	
end event

type p_exit from w_inherite_popup`p_exit within w_imt_05000_1
integer x = 2642
integer y = 16
end type

event p_exit::clicked;gi_page = 0
close(parent)

end event

type p_inq from w_inherite_popup`p_inq within w_imt_05000_1
integer x = 2295
integer y = 16
end type

event p_inq::clicked;call super::clicked;if dw_jogun.accepttext() = -1 then return

String syymm, scvcod1, scvcod2, sgubun, sempno1, sempno2, ssaupj

syymm 	= dw_jogun.getitemstring(1, "yymm")
sgubun 	= dw_jogun.getitemstring(1, "gubun")
scvcod1	= dw_jogun.getitemstring(1, "cvcod1")
scvcod2  = dw_jogun.getitemstring(1, "cvcod2")
sempno1  = dw_jogun.getitemstring(1, "empno1")
sempno2  = dw_jogun.getitemstring(1, "empno2")
ssaupj   = dw_jogun.getitemstring(1, "saupj")

if isnull(scvcod1) or trim(scvcod1) = '' then scvcod1 = '.'
if isnull(scvcod2) or trim(scvcod2) = '' then scvcod2 = 'ZZZZZZZZZZ'
if isnull(sempno1) or trim(sempno1) = '' then sempno1 = '.'
if isnull(sempno2) or trim(sempno2) = '' then sempno2 = 'ZZZZZZZZZZ'

if not (sempno1 = '.' and sempno2 = 'ZZZZZZZZZZ') then 
	dw_1.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"'")
	dw_1.filter()
end if

dw_1.retrieve(gs_sabu, syymm, sgubun, scvcod1, scvcod2, ssaupj)

end event

type p_choose from w_inherite_popup`p_choose within w_imt_05000_1
integer x = 2469
integer y = 16
end type

event p_choose::clicked;call super::clicked;if dw_1.getrow() > 0 then
	gs_code = dw_1.getitemstring(dw_1.getrow(), "mayymm")
	gi_page = dw_1.getitemdecimal(dw_1.getrow(), "mayysq")
	gs_codename = dw_1.getitemstring(dw_1.getrow(), "cvcod")		
	gs_gubun = dw_1.getitemstring(dw_1.getrow(), 'magubn')
	gs_codename2 = dw_1.getitemstring(dw_1.getrow(), "saupj")	
	close(parent)
end if
end event

type dw_1 from w_inherite_popup`dw_1 within w_imt_05000_1
integer x = 23
integer y = 420
integer width = 2766
integer height = 1528
integer taborder = 20
string dataobject = "d_imt_05000_1_02"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;if row > 0 then
	gs_code = dw_1.getitemstring(row, "mayymm")
	gi_page = dw_1.getitemdecimal(row, "mayysq")
	gs_codename = dw_1.getitemstring(row, "cvcod")	
	gs_gubun = dw_1.getitemstring(row, 'magubn')
	
	gs_codename2 = dw_1.getitemstring(row, "saupj")	
	close(parent)
end if
end event

type sle_2 from w_inherite_popup`sle_2 within w_imt_05000_1
boolean visible = false
integer x = 558
integer y = 1848
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_imt_05000_1
boolean visible = false
integer x = 1879
integer y = 2316
end type

type cb_return from w_inherite_popup`cb_return within w_imt_05000_1
boolean visible = false
integer x = 2514
integer y = 2316
end type

type cb_inq from w_inherite_popup`cb_inq within w_imt_05000_1
boolean visible = false
integer x = 2199
integer y = 2316
end type

type sle_1 from w_inherite_popup`sle_1 within w_imt_05000_1
boolean visible = false
integer x = 393
integer y = 1748
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_imt_05000_1
boolean visible = false
integer x = 69
integer y = 1776
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_imt_05000_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 36
integer width = 2158
integer height = 348
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_05000_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 412
integer width = 2793
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 46
end type

