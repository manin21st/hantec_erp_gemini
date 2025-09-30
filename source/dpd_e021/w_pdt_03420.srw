$PBExportHeader$w_pdt_03420.srw
$PBExportComments$생산일정현황(CHart)
forward
global type w_pdt_03420 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_03420
end type
end forward

global type w_pdt_03420 from w_standard_print
string title = "생산 일정 현황"
rr_1 rr_1
end type
global w_pdt_03420 w_pdt_03420

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sstdat, seddat, spdtgu, spordno, sitnbr, eitnbr

if dw_ip.accepttext() = -1 then return -1

sStdat = trim(dw_ip.getitemstring(1, "stdat"))
seddat = trim(dw_ip.getitemstring(1, "eddat"))
spdtgu = dw_ip.getitemstring(1, "pdtgu")
spordno = dw_ip.getitemstring(1, "gpordno")
sitnbr = dw_ip.getitemstring(1, "sitnbr")
eitnbr = dw_ip.getitemstring(1, "eitnbr")

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

if isnull(sPdtgu) or trim(spdtgu) = '' then	spdtgu = '%'
if isnull(sPordno) or trim(sPordno) = '' then sPordno = '%'
if isnull(sitnbr) or trim(sitnbr) = '' then	sitnbr = '.'
if isnull(eitnbr) or trim(eitnbr) = '' then eitnbr = 'zzzzzzzzzzzzzzz'

dw_print.modify("t_fromto.Text = '" + String(sstdat, '@@@@.@@.@@ - ') + String(seddat, '@@@@.@@.@@') + "'")

if dw_print.retrieve(gs_sabu, sstdat, seddat, spdtgu, spordno, sitnbr, eitnbr) = 0 then
	f_message_chk(50,'[생산일정현황]')
	return -1
End if
   
//dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_03420.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_03420.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "stdat", f_today())
dw_ip.setitem(1, "eddat", f_today())
end event

type p_preview from w_standard_print`p_preview within w_pdt_03420
end type

type p_exit from w_standard_print`p_exit within w_pdt_03420
end type

type p_print from w_standard_print`p_print within w_pdt_03420
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03420
end type







type st_10 from w_standard_print`st_10 within w_pdt_03420
end type



type dw_print from w_standard_print`dw_print within w_pdt_03420
string dataobject = "d_pdt_03420_001_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03420
integer x = 73
integer y = 32
integer width = 2496
integer height = 184
string dataobject = "d_pdt_03420_000"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;String spdtname, spdtgu

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
Elseif dwo.name = 'pdtgu' then
	spdtgu = gettext()
	Select rfna1 into :spdtname
	  From reffpf where rfcod = '03' And rfgub = :sPdtgu;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[생산팀]')		
		setitem(1, "pdtgu", '')
		return 1		
	End if;
end if
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
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

type dw_list from w_standard_print`dw_list within w_pdt_03420
integer x = 87
integer y = 240
integer width = 4489
integer height = 2048
string dataobject = "d_pdt_03420_001"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_03420
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 232
integer width = 4512
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

