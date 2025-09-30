$PBExportHeader$w_pdt_02800.srw
$PBExportComments$** 할당변경신청현황
forward
global type w_pdt_02800 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_02800
end type
type pb_2 from u_pb_cal within w_pdt_02800
end type
type rr_1 from roundrectangle within w_pdt_02800
end type
end forward

global type w_pdt_02800 from w_standard_print
string title = "할당변경신청 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_02800 w_pdt_02800

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, chcod1, chcod2, sdept, sempno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
chcod1 = Trim(dw_ip.object.chcod1[1])
chcod2 = Trim(dw_ip.object.chcod2[1])
sdept  = Trim(dw_ip.object.dept[1])
sempno = Trim(dw_ip.object.empno[1])

if (IsNull(sdate) or sdate = "")  then sdate = '10000101'
if (IsNull(edate) or edate = "")  then edate = '99991231'
if (IsNull(chcod1) or chcod1 = "")  then chcod1 = "."
if (IsNull(chcod2) or chcod2 = "")  then chcod2 = "ZZZZZZ"
if (IsNull(sdept)  or sdept  = "")  then sdept  = "%"
if (IsNull(sempno) or sempno = "")  then sempno = "%"

if dw_print.Retrieve(gs_sabu, sdate, edate, chcod1, chcod2, sdept, sempno) <= 0 then
	f_message_chk(50,'[할당변경신청 현황]')
	dw_ip.Setfocus()
	return -1
end if
    
	dw_print.sharedata(dw_list) 
return 1
end function

on w_pdt_02800.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02800.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_02800
end type

type p_exit from w_standard_print`p_exit within w_pdt_02800
end type

type p_print from w_standard_print`p_print within w_pdt_02800
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02800
end type







type st_10 from w_standard_print`st_10 within w_pdt_02800
end type



type dw_print from w_standard_print`dw_print within w_pdt_02800
string dataobject = "d_pdt_02800_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02800
integer x = 73
integer y = 36
integer width = 3013
integer height = 196
string dataobject = "d_pdt_02800_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
Int     i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + "01") = -1 then
		f_message_chk(35, "[변경요청일]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + "01") = -1 then
		f_message_chk(35, "[변경요청일]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "dept" then	
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.dept[1] = s_cod
	this.object.dept_nm[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "empno" then	
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.empno[1] = s_cod
	this.object.empnm[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dept" then //부서
	open(w_vndmst_4_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.object.dept[1] = gs_code
	this.object.dept_nm[1] = gs_codename
elseif this.getcolumnname() = "empno" then //사원	
	open(w_sawon_popup)

	if gs_code = '' or isnull(gs_code) then return 

	this.object.empno[1] = gs_code
	this.object.empnm[1] = gs_codename
end if	

end event

type dw_list from w_standard_print`dw_list within w_pdt_02800
integer x = 87
integer y = 244
integer width = 4503
integer height = 2052
string dataobject = "d_pdt_02800_02"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type pb_1 from u_pb_cal within w_pdt_02800
integer x = 741
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02800
integer x = 1184
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02800
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 236
integer width = 4535
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

