$PBExportHeader$w_kfic05.srw
$PBExportComments$부도어음 미해결 현황
forward
global type w_kfic05 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic05
end type
end forward

global type w_kfic05 from w_standard_print
string title = "부도어음 미해결 현황"
rr_1 rr_1
end type
global w_kfic05 w_kfic05

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_ymd

if dw_ip.accepttext() = -1 then return -1

ls_ymd = dw_ip.getitemstring(1, "ymd")

if ls_ymd = "" or isnull(ls_ymd) then
	f_messagechk(1, "[처리일자]")
	dw_ip.setfocus()
	return -1 
end if

if dw_print.retrieve(ls_ymd) <= 0 then
	f_messagechk(14, "")
	dw_ip.setfocus()
	return -1 
end if

dw_print.sharedata(dw_list)
return 1
end function

on w_kfic05.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "ymd", f_today())
end event

type p_preview from w_standard_print`p_preview within w_kfic05
end type

type p_exit from w_standard_print`p_exit within w_kfic05
end type

type p_print from w_standard_print`p_print within w_kfic05
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic05
end type







type st_10 from w_standard_print`st_10 within w_kfic05
end type



type dw_print from w_standard_print`dw_print within w_kfic05
string dataobject = "d_kfic05_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic05
integer x = 0
integer y = 0
integer width = 722
integer height = 184
string dataobject = "d_kfic05_1"
end type

type dw_list from w_standard_print`dw_list within w_kfic05
integer x = 14
integer y = 192
integer width = 4594
integer height = 2132
string dataobject = "d_kfic05_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 188
integer width = 4622
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

