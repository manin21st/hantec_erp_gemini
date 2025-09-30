$PBExportHeader$w_itmspec_popup.srw
$PBExportComments$**작업사양 조회 선택(2017.06.18-한텍)
forward
global type w_itmspec_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itmspec_popup
end type
end forward

global type w_itmspec_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 2094
integer height = 1480
string title = "작업사양 조회 선택"
rr_1 rr_1
end type
global w_itmspec_popup w_itmspec_popup

on w_itmspec_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itmspec_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'itnbr' , gs_code)	
dw_1.Retrieve(gs_code)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmspec_popup
integer x = 14
integer y = 32
integer width = 1225
integer height = 136
string dataobject = "d_itmspec_popup_1"
end type

type p_exit from w_inherite_popup`p_exit within w_itmspec_popup
integer x = 1856
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmspec_popup
boolean visible = false
integer x = 645
integer y = 2316
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itmspec_popup
integer x = 1682
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "sayang")
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmspec_popup
integer x = 32
integer y = 200
integer width = 1993
integer height = 1156
integer taborder = 20
string dataobject = "d_itmspec_popup_2"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "sayang")
Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itmspec_popup
boolean visible = false
integer x = 215
integer y = 2220
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmspec_popup
integer x = 1381
integer y = 2288
end type

type cb_return from w_inherite_popup`cb_return within w_itmspec_popup
integer x = 1701
integer y = 2288
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmspec_popup
integer x = 887
integer y = 2308
integer height = 92
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmspec_popup
boolean visible = false
integer y = 2268
end type

type st_1 from w_inherite_popup`st_1 within w_itmspec_popup
boolean visible = false
integer y = 2280
end type

type rr_1 from roundrectangle within w_itmspec_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 196
integer width = 2016
integer height = 1168
integer cornerheight = 40
integer cornerwidth = 55
end type

