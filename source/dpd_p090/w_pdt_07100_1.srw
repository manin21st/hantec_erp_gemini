$PBExportHeader$w_pdt_07100_1.srw
$PBExportComments$Lot SimulationMain화면(순번조회)
forward
global type w_pdt_07100_1 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pdt_07100_1
end type
end forward

global type w_pdt_07100_1 from w_inherite_popup
integer x = 357
integer y = 424
integer width = 3611
integer height = 1676
string title = "순번조회"
rr_1 rr_1
end type
global w_pdt_07100_1 w_pdt_07100_1

on w_pdt_07100_1.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_07100_1.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;f_window_center_response(this)

dw_1.retrieve(gs_sabu, gs_code)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_07100_1
integer x = 818
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_07100_1
integer x = 1609
integer y = 5000
end type

type p_inq from w_inherite_popup`p_inq within w_pdt_07100_1
integer x = 2007
integer y = 5000
end type

type p_choose from w_inherite_popup`p_choose within w_pdt_07100_1
integer x = 864
integer y = 5000
end type

type dw_1 from w_inherite_popup`dw_1 within w_pdt_07100_1
integer x = 50
integer y = 36
integer width = 3497
integer height = 1512
string dataobject = "d_pdt_07100_a"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;if row > 0 then
	gs_codename = string(dw_1.getitemdecimal(row, "seq"))
	close(parent)
end if
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_07100_1
boolean visible = false
integer x = 2030
integer y = 1984
integer width = 1061
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_07100_1
integer x = 2441
integer width = 325
end type

event cb_1::clicked;Long lrow

lrow = dw_1.getrow()
if lrow > 0 then
	gs_codename = string(dw_1.getitemdecimal(lrow, "seq"))
	close(parent)
end if
end event

type cb_return from w_inherite_popup`cb_return within w_pdt_07100_1
integer x = 2779
integer width = 325
end type

event cb_return::clicked;setnull(gs_code)
close(parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_pdt_07100_1
boolean visible = false
integer x = 1125
integer y = 5000
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_07100_1
boolean visible = false
integer x = 1801
integer y = 1984
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_07100_1
end type

type rr_1 from roundrectangle within w_pdt_07100_1
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 12
integer width = 3538
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

