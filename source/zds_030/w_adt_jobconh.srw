$PBExportHeader$w_adt_jobconh.srw
$PBExportComments$작업조건 선택 POPUP
forward
global type w_adt_jobconh from w_inherite_popup
end type
type rr_2 from roundrectangle within w_adt_jobconh
end type
end forward

global type w_adt_jobconh from w_inherite_popup
string title = "작업조건 선택 POPUP"
rr_2 rr_2
end type
global w_adt_jobconh w_adt_jobconh

type variables
String is_saupj
end variables

on w_adt_jobconh.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_adt_jobconh.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;is_saupj = Left(gs_saupj,1)
dw_1.Retrieve(is_saupj)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_adt_jobconh
boolean visible = false
integer y = 12
integer width = 1600
end type

type p_exit from w_inherite_popup`p_exit within w_adt_jobconh
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_adt_jobconh
end type

event p_inq::clicked;call super::clicked;dw_1.Retrieve(is_saupj)
end event

type p_choose from w_inherite_popup`p_choose within w_adt_jobconh
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code			= dw_1.GetItemString(ll_Row,"jobconh_jobcode")
gs_codename		= dw_1.GetItemString(ll_row,"jobconh_jobnm")
gs_gubun			= dw_1.GetItemString(ll_row,"jobconh_wkctr")
gs_codename2	= dw_1.GetItemString(ll_row,"wrkctr_wcdsc")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_adt_jobconh
integer x = 23
integer y = 196
integer width = 2258
integer height = 1744
string dataobject = "d_adt_jobconh"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code			= dw_1.GetItemString(Row,"jobconh_jobcode")
gs_codename		= dw_1.GetItemString(row,"jobconh_jobnm")
gs_gubun			= dw_1.GetItemString(row,"jobconh_wkctr")
gs_codename2	= dw_1.GetItemString(row,"wrkctr_wcdsc")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_adt_jobconh
end type

type cb_1 from w_inherite_popup`cb_1 within w_adt_jobconh
end type

type cb_return from w_inherite_popup`cb_return within w_adt_jobconh
end type

type cb_inq from w_inherite_popup`cb_inq within w_adt_jobconh
end type

type sle_1 from w_inherite_popup`sle_1 within w_adt_jobconh
end type

type st_1 from w_inherite_popup`st_1 within w_adt_jobconh
end type

type rr_2 from roundrectangle within w_adt_jobconh
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 192
integer width = 2281
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

