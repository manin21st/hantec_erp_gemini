$PBExportHeader$w_qa00_00010_popup2.srw
$PBExportComments$** 품질 검사기준 이력 팝업
forward
global type w_qa00_00010_popup2 from w_inherite_popup
end type
type dw_2 from datawindow within w_qa00_00010_popup2
end type
type rr_1 from roundrectangle within w_qa00_00010_popup2
end type
end forward

global type w_qa00_00010_popup2 from w_inherite_popup
integer width = 2222
integer height = 1404
string title = "품질 검사기준 이력 팝업"
dw_2 dw_2
rr_1 rr_1
end type
global w_qa00_00010_popup2 w_qa00_00010_popup2

on w_qa00_00010_popup2.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_qa00_00010_popup2.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;String ls_cvnas , ls_itdsc

if gs_gubun = '1' then
	dw_jogun.dataobject = 'd_qa00_00010_popup2_01'
	dw_2.dataobject = 'd_qa00_00010_popup2_a_new'
elseif gs_gubun = '2' then
	dw_jogun.dataobject = 'd_qa00_00010_popup2_02'
	dw_2.dataobject = 'd_qa00_00010_popup2_b_new'
elseif gs_gubun = '3' then
	dw_jogun.dataobject = 'd_qa00_00010_popup2_01'
	dw_2.dataobject = 'd_qa00_00010_popup2_c_new'
elseif gs_gubun = '4' then
	dw_jogun.dataobject = 'd_qa00_00010_popup2_02'
	dw_2.dataobject = 'd_qa00_00010_popup2_d_new'
end if	

dw_jogun.InsertRow(0)

Select cvnas Into :ls_cvnas from vndmst where cvcod = :gs_code ;
if sqlca.sqlcode = 0 then
	dw_jogun.Object.cvcod[1] = gs_code 
	dw_jogun.Object.cvnas[1] = ls_cvnas
end if

Select itdsc Into :ls_itdsc from itemas where itnbr = :gs_codename ;
if sqlca.sqlcode = 0 then
	dw_jogun.Object.itnbr[1] = gs_codename 
	dw_jogun.Object.itdsc[1] = ls_itdsc
end if

dw_2.SetTransObject(SQLCA)
dw_2.Retrieve(gs_code,gs_codename)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa00_00010_popup2
integer y = 0
integer width = 1893
integer height = 220
string dataobject = "d_qa00_00010_popup2_01"
end type

type p_exit from w_inherite_popup`p_exit within w_qa00_00010_popup2
integer x = 1952
integer y = 28
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa00_00010_popup2
boolean visible = false
integer x = 2661
end type

type p_choose from w_inherite_popup`p_choose within w_qa00_00010_popup2
boolean visible = false
integer x = 2834
end type

type dw_1 from w_inherite_popup`dw_1 within w_qa00_00010_popup2
boolean visible = false
integer x = 2729
integer y = 264
integer width = 379
integer height = 232
end type

type sle_2 from w_inherite_popup`sle_2 within w_qa00_00010_popup2
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa00_00010_popup2
end type

type cb_return from w_inherite_popup`cb_return within w_qa00_00010_popup2
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa00_00010_popup2
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa00_00010_popup2
end type

type st_1 from w_inherite_popup`st_1 within w_qa00_00010_popup2
end type

type dw_2 from datawindow within w_qa00_00010_popup2
integer x = 37
integer y = 248
integer width = 2126
integer height = 1024
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa00_00010_popup2_a_new"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_qa00_00010_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 240
integer width = 2158
integer height = 1044
integer cornerheight = 40
integer cornerwidth = 55
end type

