$PBExportHeader$w_qa00_00020_popup.srw
$PBExportComments$** 품질 정기검사 품목이력현황 팝업
forward
global type w_qa00_00020_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_qa00_00020_popup
end type
type rr_1 from roundrectangle within w_qa00_00020_popup
end type
end forward

global type w_qa00_00020_popup from w_inherite_popup
integer width = 2720
integer height = 1404
string title = "정기검사 등록 이력정보"
dw_2 dw_2
rr_1 rr_1
end type
global w_qa00_00020_popup w_qa00_00020_popup

on w_qa00_00020_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_qa00_00020_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.Object.cvcod[1] = gs_code
dw_jogun.Object.itnbr[1] = gs_codename
dw_jogun.Object.place[1] = gs_gubun

String ls_cvnas , ls_itdsc

Select cvnas Into :ls_cvnas
  from vndmst
 where cvcod = :gs_code ;
 

Select itdsc Into :ls_itdsc
  from itemas
 where itnbr = :gs_codename ;

dw_jogun.Object.cvnas[1] = ls_cvnas
dw_jogun.Object.itdsc[1] = ls_itdsc

dw_2.SetTransObject(SQLCA)

dw_2.Retrieve(gs_code , gs_codename, gs_gubun)



end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa00_00020_popup
integer x = 23
integer y = 0
integer width = 2331
integer height = 220
string dataobject = "d_qa00_00020_popup_01"
end type

type p_exit from w_inherite_popup`p_exit within w_qa00_00020_popup
integer x = 2405
integer y = 28
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa00_00020_popup
boolean visible = false
integer x = 2661
end type

type p_choose from w_inherite_popup`p_choose within w_qa00_00020_popup
boolean visible = false
integer x = 2834
end type

type dw_1 from w_inherite_popup`dw_1 within w_qa00_00020_popup
boolean visible = false
integer x = 2729
integer y = 264
integer width = 379
integer height = 232
end type

type sle_2 from w_inherite_popup`sle_2 within w_qa00_00020_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa00_00020_popup
end type

type cb_return from w_inherite_popup`cb_return within w_qa00_00020_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa00_00020_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa00_00020_popup
end type

type st_1 from w_inherite_popup`st_1 within w_qa00_00020_popup
end type

type dw_2 from datawindow within w_qa00_00020_popup
integer x = 41
integer y = 272
integer width = 2619
integer height = 996
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa00_00020_popup_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_qa00_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 240
integer width = 2661
integer height = 1044
integer cornerheight = 40
integer cornerwidth = 55
end type

