$PBExportHeader$w_pdt_02360.srw
$PBExportComments$작업지시 REVISION 처리 출력
forward
global type w_pdt_02360 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02360
end type
end forward

global type w_pdt_02360 from w_standard_print
integer height = 2744
string title = "작업지시-Revison 현황"
rr_1 rr_1
end type
global w_pdt_02360 w_pdt_02360

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sstdat, seddat, spordno 

if dw_ip.accepttext() = -1 then return -1

sStdat = trim(dw_ip.getitemstring(1, "stdat"))
seddat = trim(dw_ip.getitemstring(1, "eddat"))
spordno = dw_ip.getitemstring(1, "gpordno")

IF sStdat = "" OR IsNull(sStdat) THEN
	f_message_chk(30,'[지시일자]')
	dw_ip.SetColumn("stdat")
	dw_ip.SetFocus()
	Return -1
END IF
IF seddat = "" OR IsNull(seddat) THEN
	f_message_chk(30,'[지시일자]')
	dw_ip.SetColumn("eddat")
	dw_ip.SetFocus()
	Return -1
END IF

if isnull(sPordno) or trim(sPordno) = '' then sPordno = '%'

if dw_print.retrieve(gs_sabu, sstdat, seddat, spordno) = 0 then
	f_message_chk(50,'[작업지시 조정현황]')
	return -1
End if
    
	dw_print.sharedata(dw_list) 
return 1
end function

on w_pdt_02360.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02360.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string sDate

sDate = f_today()

dw_ip.Object.stdat[1] = left(sDate,6) + '01'
dw_ip.Object.eddat[1]   = left(sDate,6) + '30'

dw_list.Settransobject(sqlca)


end event

type p_preview from w_standard_print`p_preview within w_pdt_02360
end type

type p_exit from w_standard_print`p_exit within w_pdt_02360
end type

type p_print from w_standard_print`p_print within w_pdt_02360
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02360
end type







type st_10 from w_standard_print`st_10 within w_pdt_02360
end type



type dw_print from w_standard_print`dw_print within w_pdt_02360
string dataobject = "d_pdt_02360_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02360
integer x = 73
integer y = 28
integer width = 2112
integer height = 104
string dataobject = "d_pdt_02360_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String spdtname, spdtgu

if dwo.name = 'stdat' then
	if f_datechk(gettext()) = -1 then
		f_message_chk(35,'[작업지시 시작일자]') 		
		setitem(1, "stdat", f_today())
		return 1
	end if
Elseif dwo.name = 'eddat' then
	if f_datechk(gettext()) = -1 then
		f_message_chk(35,'[작업지시 종료일자]')
		setitem(1, "eddat", f_today())
		return 1
	end if
end if
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = 'gpordno' then
	Open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then return
	setitem(1, "gpordno", gs_code)
elseif this.getcolumnname() = 'sitnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "sitnbr", gs_code)
elseif this.getcolumnname() = 'eitnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "eitnbr", gs_code)
end if
end event

type dw_list from w_standard_print`dw_list within w_pdt_02360
integer x = 91
integer y = 196
integer width = 4507
integer height = 2104
string dataobject = "d_pdt_02360_2"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_pdt_02360
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 188
integer width = 4530
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

