$PBExportHeader$w_expbl_popup.srw
$PBExportComments$BL NO 선택 POPUP
forward
global type w_expbl_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_expbl_popup
end type
end forward

global type w_expbl_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2176
integer height = 1848
string title = "B/L No. 선택"
rr_1 rr_1
end type
global w_expbl_popup w_expbl_popup

on w_expbl_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_expbl_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string scode, sname

f_window_center_response(this)

sle_1.text = gs_code

scode = trim(sle_1.text)

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

dw_1.Retrieve(scode)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_expbl_popup
boolean visible = false
integer x = 82
integer y = 1972
integer width = 997
end type

type p_exit from w_inherite_popup`p_exit within w_expbl_popup
integer x = 1975
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_expbl_popup
integer x = 1627
end type

event p_inq::clicked;call super::clicked;string scode, sname

scode = trim(sle_1.text)

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

dw_1.Retrieve(scode)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_expbl_popup
integer x = 1801
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "blno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_expbl_popup
integer x = 41
integer y = 204
integer width = 2089
integer height = 1520
integer taborder = 30
string dataobject = "d_expbl_popup"
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

gs_code= dw_1.GetItemString(Row, "blno")
//gs_codename= dw_1.GetItemString(row,"cust_name")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_expbl_popup
boolean visible = false
integer x = 1001
integer width = 1138
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_expbl_popup
boolean visible = false
integer x = 485
integer y = 2040
integer taborder = 40
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_expbl_popup
boolean visible = false
integer x = 1115
integer y = 2040
integer taborder = 60
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_expbl_popup
boolean visible = false
integer x = 805
integer y = 2040
integer taborder = 50
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_expbl_popup
integer x = 352
integer y = 104
integer width = 617
integer height = 56
long backcolor = 32106727
integer limit = 20
end type

type st_1 from w_inherite_popup`st_1 within w_expbl_popup
integer x = 27
integer y = 104
integer width = 315
string text = "B/L No."
end type

type rr_1 from roundrectangle within w_expbl_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 196
integer width = 2107
integer height = 1536
integer cornerheight = 40
integer cornerwidth = 55
end type

