$PBExportHeader$w_qct_04500.srw
$PBExportComments$** A/S의뢰서
forward
global type w_qct_04500 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04500
end type
end forward

global type w_qct_04500 from w_standard_print
string title = " A/S 의뢰서"
rr_1 rr_1
end type
global w_qct_04500 w_qct_04500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, rcvlog, jpno1, jpno2

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
rcvlog = trim(dw_ip.object.rcvlog[1])
jpno1 = trim(dw_ip.object.jpno1[1])
jpno2 = trim(dw_ip.object.jpno2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(rcvlog) or rcvlog = "")  then 
	rcvlog = "%"
else
	rcvlog = rcvlog + "%"
end if
if (IsNull(jpno1) or jpno1 = "")  then jpno1 = "100001010001"
if (IsNull(jpno2) or jpno2 = "")  then jpno2 = "999912319999"

IF dw_print.Retrieve(gs_sabu, sdate, edate, rcvlog, jpno1, jpno2) <= 0 then
	f_message_chk(50,'[A/S 의뢰서]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04500.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04500
end type

type p_exit from w_standard_print`p_exit within w_qct_04500
end type

type p_print from w_standard_print`p_print within w_qct_04500
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04500
end type







type st_10 from w_standard_print`st_10 within w_qct_04500
end type



type dw_print from w_standard_print`dw_print within w_qct_04500
string dataobject = "d_qct_04500_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04500
integer x = 329
integer y = 64
integer width = 2624
integer height = 228
string dataobject = "d_qct_04500_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] =  ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "jpno1" then
	open(w_asno_popup)
   this.object.jpno1[1] = gs_code
elseif this.getcolumnname() = "jpno2" then
	open(w_asno_popup)
   this.object.jpno2[1] = gs_code
end if	
end event

type dw_list from w_standard_print`dw_list within w_qct_04500
integer x = 347
integer y = 312
integer width = 3776
integer height = 1992
string dataobject = "d_qct_04500_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_qct_04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 329
integer y = 304
integer width = 3813
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

