$PBExportHeader$w_pdt_03830.srw
$PBExportComments$작업장 납기/부하 분석서
forward
global type w_pdt_03830 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_03830
end type
type pb_2 from u_pb_cal within w_pdt_03830
end type
type rr_1 from roundrectangle within w_pdt_03830
end type
end forward

global type w_pdt_03830 from w_standard_print
string title = "작업장 납기/부하 분석서"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_03830 w_pdt_03830

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate, edate, wkctr1, wkctr2, pdtgu

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
pdtgu  = trim(dw_ip.object.pdtgu[1])
wkctr1 = dw_ip.object.wkctr1[1]
wkctr2 = dw_ip.object.wkctr2[1]

if IsNull(sdate) or sdate = "" then 
   f_message_chk(30, "[작업일자-From]")
	return -1
end if

if IsNull(edate) or edate = "" then 
   f_message_chk(30, "[작업일자-To]")
	return -1
end if

if IsNUll(pdtgu) or pdtgu = "" then pdtgu = '%'

if IsNull(wkctr1) or wkctr1 = "" then wkctr1 = "."
if IsNull(wkctr2) or wkctr2 = "" then wkctr2 = "ZZZZZZ"

if dw_print.Retrieve( gs_sabu, sdate, edate, pdtgu, wkctr1, wkctr2) < 1 then
	f_message_chk(50, "[작업장 납기/부하 분석서]")
	dw_ip.Setfocus()
	return -1
end if	
    
	 dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_03830.create
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

on w_pdt_03830.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", f_today())
dw_ip.setitem(1, "edate", f_today())


end event

type p_preview from w_standard_print`p_preview within w_pdt_03830
end type

type p_exit from w_standard_print`p_exit within w_pdt_03830
end type

type p_print from w_standard_print`p_print within w_pdt_03830
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03830
end type







type st_10 from w_standard_print`st_10 within w_pdt_03830
end type



type dw_print from w_standard_print`dw_print within w_pdt_03830
string dataobject = "d_pdt_03830_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03830
integer x = 69
integer y = 28
integer width = 2789
integer height = 188
string dataobject = "d_pdt_03830_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[기간]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[기간]")
		this.object.edate[1] = ""
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
elseif this.GetColumnName() = "gubun" then 
	if s_cod = '1' then // 개별작업 
		dw_list.dataobject = 'd_pdt_03830_02' 
	   dw_print.dataobject = 'd_pdt_03830_02_p'  
   else                // batch 작업 
		dw_list.dataobject = 'd_pdt_03830_03'
	   dw_print.dataobject = 'd_pdt_03830_03_p'  
   end if
   dw_list.settransobject(sqlca) 
   dw_print.settransobject(sqlca)  
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

type dw_list from w_standard_print`dw_list within w_pdt_03830
integer x = 87
integer y = 248
integer width = 4512
integer height = 2048
string dataobject = "d_pdt_03830_02"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_pdt_03830
integer x = 681
integer y = 36
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_03830
integer x = 1093
integer y = 36
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_03830
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 240
integer width = 4539
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

