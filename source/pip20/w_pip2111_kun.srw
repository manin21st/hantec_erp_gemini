$PBExportHeader$w_pip2111_kun.srw
$PBExportComments$** 월근태popup
forward
global type w_pip2111_kun from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pip2111_kun
end type
end forward

global type w_pip2111_kun from w_inherite_popup
integer width = 2144
integer height = 584
string title = "월근태조회"
boolean controlmenu = true
rr_1 rr_1
end type
global w_pip2111_kun w_pip2111_kun

on w_pip2111_kun.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pip2111_kun.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.retrieve(gs_company, gs_code, gs_codename)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pip2111_kun
integer x = 14
integer y = 528
integer width = 110
integer height = 92
end type

type p_exit from w_inherite_popup`p_exit within w_pip2111_kun
integer x = 2011
integer y = 1824
end type

type p_inq from w_inherite_popup`p_inq within w_pip2111_kun
integer x = 1664
integer y = 1824
end type

type p_choose from w_inherite_popup`p_choose within w_pip2111_kun
integer x = 1838
integer y = 1824
end type

type dw_1 from w_inherite_popup`dw_1 within w_pip2111_kun
integer x = 46
integer y = 48
integer width = 2021
integer height = 400
string dataobject = "d_pip2111_kuntae"
boolean vscrollbar = false
end type

event dw_1::rowfocuschanged;//override
end event

event dw_1::clicked;//override
end event

type sle_2 from w_inherite_popup`sle_2 within w_pip2111_kun
end type

type cb_1 from w_inherite_popup`cb_1 within w_pip2111_kun
end type

type cb_return from w_inherite_popup`cb_return within w_pip2111_kun
end type

type cb_inq from w_inherite_popup`cb_inq within w_pip2111_kun
end type

type sle_1 from w_inherite_popup`sle_1 within w_pip2111_kun
end type

type st_1 from w_inherite_popup`st_1 within w_pip2111_kun
end type

type rr_1 from roundrectangle within w_pip2111_kun
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer y = 44
integer width = 2085
integer height = 412
integer cornerheight = 40
integer cornerwidth = 55
end type

