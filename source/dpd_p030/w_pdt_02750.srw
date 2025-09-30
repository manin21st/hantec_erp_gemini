$PBExportHeader$w_pdt_02750.srw
$PBExportComments$** 작업장 정보 현황
forward
global type w_pdt_02750 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02750
end type
end forward

global type w_pdt_02750 from w_standard_print
string title = "작업장 정보 현황"
rr_1 rr_1
end type
global w_pdt_02750 w_pdt_02750

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate

dw_ip.AcceptText()

sdate = trim(dw_ip.object.sdate[1])

if isnull(sdate) or sdate = "" then 
	f_message_chk(30,'[작업일자]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

if dw_print.Retrieve(gs_sabu, sdate) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
 
  dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_02750.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02750.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, "sdate", f_today())
dw_ip.SetColumn("sdate")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_02750
end type

type p_exit from w_standard_print`p_exit within w_pdt_02750
end type

type p_print from w_standard_print`p_print within w_pdt_02750
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02750
end type







type st_10 from w_standard_print`st_10 within w_pdt_02750
end type



type dw_print from w_standard_print`dw_print within w_pdt_02750
string dataobject = "d_pdt_02750_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02750
integer x = 73
integer y = 32
integer width = 686
integer height = 100
string dataobject = "d_pdt_02750_a"
end type

event dw_ip::itemchanged;string snull, sdate

setnull(snull)

IF this.GetColumnName() ="sdate" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[작업일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02750
integer x = 87
integer y = 200
integer width = 4512
integer height = 2100
string dataobject = "d_pdt_02750_1"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_pdt_02750
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 192
integer width = 4539
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

