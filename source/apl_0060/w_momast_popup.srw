$PBExportHeader$w_momast_popup.srw
$PBExportComments$** 작업지시 추가시 조회 선택
forward
global type w_momast_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_momast_popup
end type
end forward

global type w_momast_popup from w_inherite_popup
integer x = 800
integer y = 172
integer width = 2386
integer height = 2100
string title = "작업지시 추가시 조회 선택"
rr_1 rr_1
end type
global w_momast_popup w_momast_popup

on w_momast_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_momast_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'itnbr', gs_code)
dw_jogun.SetItem(1, 'pspec', gs_codename)

string DWfilter2

DWfilter2 = "useqty > 0 "
dw_1.SetFilter(DWfilter2)
dw_1.Filter( )

dw_1.retrieve(gs_sabu, gs_code, gs_codename)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_momast_popup
integer x = 27
integer y = 160
integer width = 2226
integer height = 144
string dataobject = "d_momast_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_momast_popup
integer x = 2181
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_momast_popup
boolean visible = false
integer x = 937
integer y = 2060
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_momast_popup
integer x = 2007
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun= dw_1.GetItemString(ll_Row, "pordno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_momast_popup
integer x = 41
integer y = 308
integer width = 2290
integer height = 1664
string dataobject = "d_momast_popup"
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

gs_gubun= dw_1.GetItemString(Row, "pordno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_momast_popup
integer x = 338
integer y = 2104
end type

type cb_1 from w_inherite_popup`cb_1 within w_momast_popup
integer x = 832
integer y = 2232
integer taborder = 10
end type

type cb_return from w_inherite_popup`cb_return within w_momast_popup
integer x = 1143
integer y = 2232
integer taborder = 20
end type

type cb_inq from w_inherite_popup`cb_inq within w_momast_popup
integer x = 1221
integer y = 2248
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_momast_popup
end type

type st_1 from w_inherite_popup`st_1 within w_momast_popup
end type

type rr_1 from roundrectangle within w_momast_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 304
integer width = 2304
integer height = 1680
integer cornerheight = 40
integer cornerwidth = 55
end type

