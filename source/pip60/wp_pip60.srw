$PBExportHeader$wp_pip60.srw
$PBExportComments$** 급호 TABLE
forward
global type wp_pip60 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pip60
end type
end forward

global type wp_pip60 from w_standard_print
integer x = 0
integer y = 0
string title = "급호 TABLE"
rr_1 rr_1
end type
global wp_pip60 wp_pip60

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_level, ls_jik

dw_list.reset()

dw_ip.accepttext()

setpointer(hourglass!)

ls_jik = trim(dw_ip.getitemstring(1, "jik"))
ls_level = trim(dw_ip.getitemstring(1, "a"))

if isnull(ls_level) or ls_level = "" then
	ls_level = "%"	
else
	ls_level = ls_level + "%"
end if

if dw_print.retrieve(ls_jik,ls_level) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.setfocus()
	return -1
end if
   dw_print.sharedata(dw_list)
setpointer(arrow!)

return 1
end function

on wp_pip60.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pip60.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"
end event

type p_preview from w_standard_print`p_preview within wp_pip60
integer y = 4
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pip60
integer y = 4
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pip60
integer y = 4
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip60
integer y = 4
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pip60
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pip60
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip60
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pip60
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pip60
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pip60
integer x = 3721
integer y = 28
string dataobject = "dp_pip60_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip60
integer x = 603
integer y = 40
integer width = 2075
integer height = 136
string dataobject = "dp_pip60_1"
end type

event dw_ip::itemchanged;if this.GetColumnName() = 'a' then
	p_retrieve.TriggerEvent(Clicked!)
end if
end event

type dw_list from w_standard_print`dw_list within wp_pip60
integer x = 626
integer y = 204
integer width = 3602
integer height = 2040
string dataobject = "dp_pip60"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pip60
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 608
integer y = 200
integer width = 3634
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

