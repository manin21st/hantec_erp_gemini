$PBExportHeader$w_pdt_03820.srw
$PBExportComments$작업부하 예외보고서
forward
global type w_pdt_03820 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_03820
end type
end forward

global type w_pdt_03820 from w_standard_print
string title = "작업 부하 예외 보고서"
rr_1 rr_1
end type
global w_pdt_03820 w_pdt_03820

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String spdtgu, sjigub, ssortgu, stoday

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

spdtgu 	= dw_ip.object.pdtgu[1]


stoday = f_today()

if IsNull(sPdtgu) or sPdtgu = "" then sPdtgu = "%"

if dw_print.Retrieve(gs_sabu, spdtgu, stoday) < 1 then
	f_message_chk(50, "[작업 부하 예외 보고서 ]")
	dw_ip.Setfocus()
	return -1
end if	
   
	dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_03820.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_03820.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_03820
end type

type p_exit from w_standard_print`p_exit within w_pdt_03820
end type

type p_print from w_standard_print`p_print within w_pdt_03820
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03820
end type







type st_10 from w_standard_print`st_10 within w_pdt_03820
end type



type dw_print from w_standard_print`dw_print within w_pdt_03820
string dataobject = "d_pdt_03820_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03820
integer x = 69
integer y = 32
integer width = 855
integer height = 100
string dataobject = "d_pdt_03820_a"
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
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr1[1] = s_cod
	this.object.wcdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "wkctr2" then	
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
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

type dw_list from w_standard_print`dw_list within w_pdt_03820
integer x = 87
integer y = 200
integer width = 4503
integer height = 2092
string dataobject = "d_pdt_03820_01"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_03820
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 188
integer width = 4535
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

