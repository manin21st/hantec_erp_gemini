$PBExportHeader$w_pdt_02550.srw
$PBExportComments$** 작업예정지시서
forward
global type w_pdt_02550 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_02550
end type
type rr_1 from roundrectangle within w_pdt_02550
end type
end forward

global type w_pdt_02550 from w_standard_print
string title = "작업 예정 지시서"
pb_1 pb_1
rr_1 rr_1
end type
global w_pdt_02550 w_pdt_02550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate, depot1, depot2, ittyp, pdtgu1, pdtgu2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate   = TRIM(dw_ip.object.sdate[1])
depot1  = dw_ip.object.depot1[1]
depot2  = dw_ip.object.depot2[1]
pdtgu1  = dw_ip.object.pdtgu1[1]
pdtgu2  = dw_ip.object.pdtgu2[1]
ittyp   = dw_ip.object.ittyp[1]

if IsNull(ittyp) or ittyp = "" then 
   f_message_chk(30, "[품목구분]")
	dw_ip.SetColumn("ittyp")
	return -1
end if

if IsNull(sdate) or sdate = "" then 
   f_message_chk(30, "[작업예정일자]")
   dw_ip.SetColumn("sdate")
	return -1
end if

if IsNull(depot1) or depot1 = "" then depot1 = "."
if IsNull(depot2) or depot2 = "" then depot2 = "ZZZZZZ"
if IsNull(pdtgu1) or pdtgu1 = "" then pdtgu1 = "."
if IsNull(pdtgu2) or pdtgu2 = "" then pdtgu2 = "ZZZZZZ"

if Dw_print.Retrieve(sdate, depot1, depot2, ittyp, pdtgu1, pdtgu2) < 1 then
	f_message_chk(50, "[작업 예정 지시서]")
	dw_ip.Setfocus()
	return -1
end if	
   
	dw_print.ShareData(dw_list)
return 1
end function

on w_pdt_02550.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_02550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;String sDate

select max(widat) 
  into :sDate
  from estima_examination;
  
dw_ip.setitem(1, "sdate", sDATE)

end event

type p_preview from w_standard_print`p_preview within w_pdt_02550
end type

type p_exit from w_standard_print`p_exit within w_pdt_02550
end type

type p_print from w_standard_print`p_print within w_pdt_02550
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02550
end type







type st_10 from w_standard_print`st_10 within w_pdt_02550
end type



type dw_print from w_standard_print`dw_print within w_pdt_02550
string dataobject = "d_pdt_02550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02550
integer x = 69
integer y = 40
integer width = 2725
integer height = 184
string dataobject = "d_pdt_02550_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[작업예정일자]")
		this.object.sdate[1] = ""
		return 1
	end if	
end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_02550
integer x = 82
integer y = 260
integer width = 4507
integer height = 2032
string dataobject = "d_pdt_02550_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdt_02550
integer x = 777
integer y = 128
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 252
integer width = 4539
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

