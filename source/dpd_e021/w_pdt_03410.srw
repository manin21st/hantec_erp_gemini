$PBExportHeader$w_pdt_03410.srw
$PBExportComments$작업지시 대기/승인화면
forward
global type w_pdt_03410 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_03410
end type
end forward

global type w_pdt_03410 from w_standard_print
string title = "작업지시 대기/승인"
rr_1 rr_1
end type
global w_pdt_03410 w_pdt_03410

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sstdat, seddat, spdtgu, sgubun, sprtgbn

if dw_ip.accepttext() = -1 then return -1

sStdat 	= dw_ip.getitemstring(1, "stdat")
seddat 	= dw_ip.getitemstring(1, "eddat")
spdtgu 	= dw_ip.getitemstring(1, "pdtgu")
sgubun 	= dw_ip.getitemstring(1, "gubun")
sprtgbn 	= dw_ip.getitemstring(1, "prtgbn")

if 	f_datechk(sStdat) = -1 then Return -1
if 	f_datechk(sEddat) = -1 then Return -1

if 	isnull(sPdtgu) or trim(spdtgu) = '' then
	spdtgu = '%'
end if



if 	sprtgbn = '1' then
	dw_list.dataobject 	= "d_pdt_03410_001"
	dw_print.dataobject = "d_pdt_03410_001_p"
Else
	dw_list.dataobject 	= "d_pdt_03410_002"
	dw_print.dataobject = "d_pdt_03410_002_p"
End if

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

if 	dw_print.retrieve(GS_SABU, sstdat, seddat, spdtgu, sgubun) <= 0 then
	f_message_chk(50,'[대기/승인]')
	return -1
End if
dw_print.ShareData(dw_list)

return 1
end function

on w_pdt_03410.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_03410.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "stdat", f_today())
dw_ip.setitem(1, "eddat", f_today())
end event

type p_preview from w_standard_print`p_preview within w_pdt_03410
end type

type p_exit from w_standard_print`p_exit within w_pdt_03410
end type

type p_print from w_standard_print`p_print within w_pdt_03410
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03410
end type







type st_10 from w_standard_print`st_10 within w_pdt_03410
end type



type dw_print from w_standard_print`dw_print within w_pdt_03410
integer y = 8
string dataobject = "d_pdt_03410_001_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03410
integer x = 69
integer y = 32
integer width = 2034
integer height = 176
string dataobject = "d_pdt_03410_000"
end type

event dw_ip::itemerror;call super::itemerror;return 1
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

type dw_list from w_standard_print`dw_list within w_pdt_03410
integer x = 91
integer y = 236
integer width = 4507
integer height = 2000
string dataobject = "d_pdt_03410_001"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_03410
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 228
integer width = 4535
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

