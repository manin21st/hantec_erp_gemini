$PBExportHeader$w_voda_activity_popup3.srw
$PBExportComments$PROCESS 선택
forward
global type w_voda_activity_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_voda_activity_popup3
end type
end forward

global type w_voda_activity_popup3 from w_inherite_popup
integer x = 233
integer y = 188
integer width = 1833
integer height = 1980
string title = "Process 선택"
rr_1 rr_1
end type
global w_voda_activity_popup3 w_voda_activity_popup3

on w_voda_activity_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_voda_activity_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.retrieve()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_voda_activity_popup3
boolean visible = false
integer x = 0
integer y = 1440
integer width = 3337
integer height = 140
end type

type p_exit from w_inherite_popup`p_exit within w_voda_activity_popup3
integer x = 1618
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_voda_activity_popup3
boolean visible = false
integer x = 891
integer y = 1460
end type

event p_inq::clicked;call super::clicked;String sGubun, sFdate, sTdate, smagbn

if dw_jogun.AcceptText() = -1 then return

sGubun = dw_jogun.GetItemString(1, 'sgubun')
sFdate = trim(dw_jogun.GetItemString(1, 'fdate'))
sTdate = trim(dw_jogun.GetItemString(1, 'tdate'))
sMagbn = trim(dw_jogun.GetItemString(1, 'magbn'))

IF sFdate = "" OR IsNull(sFdate) THEN
	sFdate = '10000101'
END IF

IF stdate = "" OR IsNull(stdate) THEN
	stdate = '99991231'
END IF

dw_1.SetRedraw(FALSE)

IF sGubun = 'Y' THEN
	dw_1.SetFilter("localyn ='Y'")
ELSEIF sGubun = 'N' THEN
	dw_1.SetFilter("localyn ='N'")
ELSE
	dw_1.SetFilter("")
END IF
dw_1.Filter()

IF dw_1.Retrieve(gs_sabu, sfdate, stdate, sMagbn) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn(1)
	dw_jogun.SetFocus()
	dw_1.SetRedraw(true)
	Return
END IF
dw_1.SetRedraw(true)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_voda_activity_popup3
integer x = 1445
integer y = 8
end type

event p_choose::clicked;call super::clicked;if dw_1.RowCount() < 1 then
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(dw_1.GetRow(), "proc_code")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_voda_activity_popup3
integer x = 27
integer y = 180
integer width = 1765
integer height = 1676
string dataobject = "d_voda_activity_popup3"
boolean hscrollbar = true
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

gs_code= dw_1.GetItemString(Row, "proc_code")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_voda_activity_popup3
boolean visible = false
integer x = 1106
integer y = 2296
integer width = 1001
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_voda_activity_popup3
integer x = 1015
integer y = 2244
end type

type cb_return from w_inherite_popup`cb_return within w_voda_activity_popup3
integer x = 1637
integer y = 2244
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_voda_activity_popup3
integer x = 1326
integer y = 2244
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_voda_activity_popup3
boolean visible = false
integer x = 443
integer y = 2296
integer width = 425
boolean enabled = false
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_voda_activity_popup3
boolean visible = false
integer x = 174
integer y = 2316
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_voda_activity_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 164
integer width = 1774
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

