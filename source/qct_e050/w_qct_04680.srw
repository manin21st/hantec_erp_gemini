$PBExportHeader$w_qct_04680.srw
$PBExportComments$**기간별 A/S고장내역
forward
global type w_qct_04680 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04680
end type
end forward

global type w_qct_04680 from w_standard_print
string title = "기간별 A/S 고장내역"
rr_1 rr_1
end type
global w_qct_04680 w_qct_04680

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate, lotno1, lotno2, itnbr1, itnbr2, rcvlog, s_rcvlog

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

dw_list.SetReDraw(False)
dw_list.ReSet()
dw_list.SetReDraw(True)

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
lotno1 = trim(dw_ip.object.lotno1[1])
lotno2 = trim(dw_ip.object.lotno2[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
rcvlog = trim(dw_ip.object.rcvlog[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(lotno1) or lotno1 = "")  then lotno1 = "*"
if (IsNull(lotno2) or lotno2 = "")  then lotno2 = "ZZZZZZZZZZ"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

if (IsNull(rcvlog) or rcvlog = "")  then 
	//dw_list.object.txt_rcvlog.text = "전체"
	rcvlog = "%"
//else
//	dw_list.object.txt_rcvlog.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(rcvlog) ', 1)"))
end if	

//dw_list.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
//dw_list.object.txt_lotno.text = lotno1 + " - " + lotno2
//dw_list.object.txt_itnbr.text = itnbr1 + " - " + itnbr2

IF dw_print.Retrieve(gs_sabu, sdate, edate, lotno1, lotno2, itnbr1, itnbr2, rcvlog) <= 0 then
	f_message_chk(50,'[기간별 A/S 고장내역]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04680.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04680.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04680
end type

type p_exit from w_standard_print`p_exit within w_qct_04680
end type

type p_print from w_standard_print`p_print within w_qct_04680
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04680
end type







type st_10 from w_standard_print`st_10 within w_qct_04680
end type



type dw_print from w_standard_print`dw_print within w_qct_04680
string dataobject = "d_qct_04680_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04680
integer x = 78
integer y = 48
integer width = 3643
integer height = 200
string dataobject = "d_qct_04680_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

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
elseif (this.GetColumnName() = "itnbr1") Then //품번
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn	
elseif (this.GetColumnName() = "itnbr2") Then //품번
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn	
end if

return
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "itnbr1" then //품번
	open(w_itemas_popup)
   this.object.itnbr1[1] = gs_code
   this.object.itdsc1[1] = gs_codename
elseif this.getcolumnname() = "itnbr2" then //품번
	open(w_itemas_popup)
   this.object.itnbr2[1] = gs_code
   this.object.itdsc2[1] = gs_codename
end if	

return
end event

type dw_list from w_standard_print`dw_list within w_qct_04680
integer x = 91
integer y = 272
integer width = 4402
integer height = 2024
string dataobject = "d_qct_04680_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_04680
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 260
integer width = 4430
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

