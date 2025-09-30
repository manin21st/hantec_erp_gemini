$PBExportHeader$w_qct_01545.srw
$PBExportComments$** 공정이상발생통보서현황
forward
global type w_qct_01545 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_01545
end type
end forward

global type w_qct_01545 from w_standard_print
string title = "공정 이상발생통보서 현황"
rr_1 rr_1
end type
global w_qct_01545 w_qct_01545

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
dw_list.setredraw(false)

//if dw_list.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
//	dw_list.setredraw(True)
//	f_message_chk(50,'[제품 이상발생 통보서 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

dw_list.setredraw(True)

IF dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[제품 이상발생 통보서 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_01545.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_01545.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_qct_01545
end type

type p_exit from w_standard_print`p_exit within w_qct_01545
end type

type p_print from w_standard_print`p_print within w_qct_01545
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01545
end type







type st_10 from w_standard_print`st_10 within w_qct_01545
end type



type dw_print from w_standard_print`dw_print within w_qct_01545
string dataobject = "d_qct_01545_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01545
integer x = 46
integer y = 40
integer width = 3561
integer height = 124
string dataobject = "d_qct_01545_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "itnbr1" then 
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "itnbr2" then 
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
end if
return
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF2!) THEN
	if this.GetColumnName() = "itnbr1" then
	   open(w_itemas_popup2)
	   this.object.itnbr1[1] = gs_code
	   this.object.itdsc1[1] = gs_codename
   elseif this.GetColumnName() = "itnbr2" then
	   open(w_itemas_popup2)
	   this.object.itnbr2[1] = gs_code
	   this.object.itdsc2[1] = gs_codename
   end if	
	return
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "itnbr1" then
	open(w_itemas_popup)
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
elseif this.GetColumnName() = "itnbr2" then
	open(w_itemas_popup)
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
end if	
return
end event

type dw_list from w_standard_print`dw_list within w_qct_01545
integer y = 212
integer width = 4535
integer height = 2104
string dataobject = "d_qct_01545_03"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_01545
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 4581
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 55
end type

