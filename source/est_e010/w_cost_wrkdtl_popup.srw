$PBExportHeader$w_cost_wrkdtl_popup.srw
$PBExportComments$원가테이블 조회 선택 POPUP
forward
global type w_cost_wrkdtl_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_cost_wrkdtl_popup
end type
end forward

global type w_cost_wrkdtl_popup from w_inherite_popup
integer x = 430
integer y = 200
integer width = 3186
integer height = 1916
string title = "원가테이블 조회 선택 POPUP"
rr_1 rr_1
end type
global w_cost_wrkdtl_popup w_cost_wrkdtl_popup

type variables
String sWkctr
end variables

on w_cost_wrkdtl_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cost_wrkdtl_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event w_cost_wrkdtl_popup::open;call super::open;f_window_center(this)

sWkctr	  = gs_code
sle_1.Text = gs_gubun
sle_2.Text = gs_codename

p_inq.TriggerEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_cost_wrkdtl_popup
integer x = 82
integer y = 2380
end type

type p_exit from w_inherite_popup`p_exit within w_cost_wrkdtl_popup
integer x = 2939
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_cost_wrkdtl_popup
integer x = 2592
integer y = 28
end type

event p_inq::clicked;call super::clicked;dw_1.Retrieve(gs_sabu, trim(sle_1.text), sWkctr)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_cost_wrkdtl_popup
integer x = 2766
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "mchno")
gs_codename = dw_1.GetItemString(ll_Row, "mchnam")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_cost_wrkdtl_popup
integer x = 46
integer y = 188
integer width = 3077
integer height = 1604
string dataobject = "d_cost_wrkdtl_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "mchno")
gs_codename= dw_1.GetItemString(ll_Row, "mchnam")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_cost_wrkdtl_popup
integer x = 603
integer y = 2260
integer width = 1193
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_cost_wrkdtl_popup
boolean visible = false
integer x = 1042
integer y = 2240
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code     = dw_1.GetItemString(ll_Row, "mchno")
//gs_codename = dw_1.GetItemString(ll_Row, "mchnam")
//
//Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_cost_wrkdtl_popup
boolean visible = false
integer x = 1678
integer y = 2240
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_cost_wrkdtl_popup
boolean visible = false
integer x = 1362
integer y = 2240
end type

event cb_inq::clicked;call super::clicked;
//dw_1.Retrieve(gs_sabu, trim(sle_1.text), sWkctr)
//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
end event

type sle_1 from w_inherite_popup`sle_1 within w_cost_wrkdtl_popup
integer x = 421
integer y = 2260
end type

type st_1 from w_inherite_popup`st_1 within w_cost_wrkdtl_popup
integer x = 142
integer y = 2272
string text = "기준년도"
end type

type rr_1 from roundrectangle within w_cost_wrkdtl_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 3099
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

