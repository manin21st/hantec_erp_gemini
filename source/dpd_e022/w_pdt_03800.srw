$PBExportHeader$w_pdt_03800.srw
$PBExportComments$�۾��� ������/���� ���Ϻ���
forward
global type w_pdt_03800 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_03800
end type
end forward

global type w_pdt_03800 from w_standard_print
string title = "�۾��� ������/���� ���� ����"
rr_1 rr_1
end type
global w_pdt_03800 w_pdt_03800

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String spdtgu, wkctr1, wkctr2 
dec {2} trate, brate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

spdtgu = dw_ip.object.pdtgu[1]
wkctr1 = dw_ip.object.wkctr1[1]
wkctr2 = dw_ip.object.wkctr2[1]
trate  = dw_ip.object.trate[1]
brate  = dw_ip.object.brate[1]

if IsNull(sPdtgu) or sPdtgu = "" then sPdtgu = "%"
if IsNull(wkctr1) or wkctr1 = "" then wkctr1 = "."
if IsNull(wkctr2) or wkctr2 = "" then wkctr2 = "ZZZZZZ"

dw_list.ShareDataOff()

if dw_list.Retrieve(gs_sabu, wkctr1, wkctr2, spdtgu, trate, brate) < 1 then
	f_message_chk(50, "[�۾��� ������/���� ���� ����]")
	dw_ip.Setfocus()
	return -1
end if	

if dw_print.Retrieve(gs_sabu, wkctr1, wkctr2, spdtgu, trate, brate) < 1 then
	f_message_chk(50, "[�۾��� ������/���� ���� ����]")
	dw_ip.Setfocus()
	return -1
end if	

return 1
end function

on w_pdt_03800.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_03800.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_03800
end type

type p_exit from w_standard_print`p_exit within w_pdt_03800
end type

type p_print from w_standard_print`p_print within w_pdt_03800
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03800
end type







type st_10 from w_standard_print`st_10 within w_pdt_03800
end type



type dw_print from w_standard_print`dw_print within w_pdt_03800
string dataobject = "d_pdt_03800_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03800
integer x = 73
integer y = 28
integer width = 2149
integer height = 184
string dataobject = "d_pdt_03800_a"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "pdtgu" then
	if IsNull(s_cod) or s_cod = "" then return
	s_nam1 =  f_get_reffer('03', s_cod) 
	if IsNull(s_nam1) then
		this.object.sdate[1] = s_nam1
		return 1
	end if	
elseif this.GetColumnName() = "wkctr1" then	
	i_rtn = f_get_name2("�۾���", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr1[1] = s_cod
	this.object.wcdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "wkctr2" then	
	i_rtn = f_get_name2("�۾���", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr2[1] = s_cod
	this.object.wcdsc2[1] = s_nam1
	return i_rtn
end if	
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "wkctr1" then
	open(w_workplace_popup)
   this.object.wkctr1[1] = gs_code
	this.object.wcdsc1[1] = gs_codename
elseif this.getcolumnname() = "wkctr2" then
	open(w_workplace_popup)
   this.object.wkctr2[1] = gs_code
	this.object.wcdsc2[1] = gs_codename
end if	
return
end event

type dw_list from w_standard_print`dw_list within w_pdt_03800
integer x = 87
integer y = 236
integer width = 4512
integer height = 2060
string dataobject = "d_pdt_03800_01"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_pdt_03800
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 228
integer width = 4539
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

