$PBExportHeader$w_pdt_03780.srw
$PBExportComments$월 생산실적 현황 [상세]
forward
global type w_pdt_03780 from w_standard_print
end type
end forward

global type w_pdt_03780 from w_standard_print
string title = "월 생산실적 현황[상세]"
end type
global w_pdt_03780 w_pdt_03780

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, sugugb

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
sugugb = trim(dw_ip.object.sugugb[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(sugugb) or sugugb = "")  then sugugb = '%'

dw_print.object.txt_date.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")

if dw_print.Retrieve(gs_sabu, sdate, edate, sugugb ) <= 0 then
	f_message_chk(50,"[월 생산 실적 현황[상세]]")
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_03780.create
call super::create
end on

on w_pdt_03780.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', left(is_today, 6) + '01')
dw_ip.setitem(1, 'edate', is_today)
end event

type dw_list from w_standard_print`dw_list within w_pdt_03780
integer height = 1964
string dataobject = "d_pdt_03780"
end type

type cb_print from w_standard_print`cb_print within w_pdt_03780
end type

type cb_excel from w_standard_print`cb_excel within w_pdt_03780
end type

type cb_preview from w_standard_print`cb_preview within w_pdt_03780
end type

type cb_1 from w_standard_print`cb_1 within w_pdt_03780
end type

type dw_print from w_standard_print`dw_print within w_pdt_03780
string dataobject = "d_pdt_03780_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03780
integer y = 56
integer height = 188
string dataobject = "d_pdt_03780_01"
end type

event dw_ip::itemchanged;String s_cod

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
end if
end event

event dw_ip::itemerror;return 1
end event

type r_1 from w_standard_print`r_1 within w_pdt_03780
end type

type r_2 from w_standard_print`r_2 within w_pdt_03780
end type

type rr_1 from roundrectangle within w_pdt_03780
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 188
integer width = 4539
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 55
end type

