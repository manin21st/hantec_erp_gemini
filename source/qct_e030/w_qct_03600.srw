$PBExportHeader$w_qct_03600.srw
$PBExportComments$불만분석현황
forward
global type w_qct_03600 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03600
end type
type pb_2 from u_pb_cal within w_qct_03600
end type
type rr_1 from roundrectangle within w_qct_03600
end type
end forward

global type w_qct_03600 from w_standard_print
integer width = 4640
integer height = 2440
string title = "불만 분석 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_03600 w_qct_03600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate, ls_edate, ls_name, ls_deptname, ls_title

if dw_ip.AcceptText() = -1 then return -1


ls_sdate = trim(dw_ip.GetItemString(1,'sdate'))
ls_edate = trim(dw_ip.GetItemString(1,'edate'))
ls_deptname   = dw_ip.GetItemString(1,'deptname')
ls_name  = trim(dw_ip.GetItemString(1,'name'))
ls_title  = trim(dw_ip.GetItemString(1,'title'))


if isnull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if isnull(ls_edate) or ls_edate = "" then ls_edate = '99991231'
if isnull(ls_deptname) then ls_deptname = "" 
if isnull(ls_name ) then ls_name = ""
if isnull(ls_title) then ls_title = ""


IF dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate) <= 0 then 
	f_message_chk(50,"[불만 분석 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
//	Return -1
END IF

//IF dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate) <= 0 then 
//	dw_print.insertrow(0)
//END IF
dw_list.object.txt_deptname.text = ls_deptname
dw_list.object.txt_name.text = ls_name
dw_list.object.txt_title.text = ls_title

//dw_print.ShareData(dw_list)

return 1
end function

on w_qct_03600.create
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

on w_qct_03600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.SharedataOff()
end event

type p_preview from w_standard_print`p_preview within w_qct_03600
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_qct_03600
end type

type p_print from w_standard_print`p_print within w_qct_03600
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_qct_03600
end type







type st_10 from w_standard_print`st_10 within w_qct_03600
end type



type dw_print from w_standard_print`dw_print within w_qct_03600
string dataobject = "d_qct_03600_02_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03600
integer width = 3104
integer height = 224
string dataobject = "d_qct_03600_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = "dept" then 
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.dept[1] = s_cod
	this.object.deptname[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "writer" then 
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.writer[1] = s_cod
	this.object.name[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "gubun" then
	    dw_list.setredraw(false)
		 
   if s_cod = '1' then
		dw_list.dataobject = 'd_qct_03600_02_p'		// user별 
		dw_print.dataobject = 'd_qct_03600_02_p'	// user별 
	else
		dw_list.dataobject = 'd_qct_03600_04_p'		// 원인별 
		dw_print.dataobject = 'd_qct_03600_04_p'	// 원인별 
	end if
	  
	   dw_list.settransobject(sqlca)
	   dw_print.settransobject(sqlca)
		dw_list.setredraw(true)
End If
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dept" then
	open(w_vndmst_4_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "dept", gs_code)
	this.SetItem(1, "deptname", gs_codename)
	return
elseif this.getcolumnname() = "writer" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "writer", gs_code)
	this.SetItem(1, "name", gs_codename)
	return
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03600
integer x = 64
integer y = 276
integer width = 4544
integer height = 2036
string dataobject = "d_qct_03600_02_p"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qct_03600
integer x = 1504
integer y = 36
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03600
integer x = 1943
integer y = 36
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 55
integer y = 268
integer width = 4571
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

