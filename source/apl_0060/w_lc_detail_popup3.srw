$PBExportHeader$w_lc_detail_popup3.srw
$PBExportComments$** L/C 품목정보 조회 선택3(L/C번호로 선택)
forward
global type w_lc_detail_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_lc_detail_popup3
end type
end forward

global type w_lc_detail_popup3 from w_inherite_popup
integer x = 23
integer y = 612
integer width = 3611
integer height = 948
string title = "L/C 품목정보 조회 선택"
rr_1 rr_1
end type
global w_lc_detail_popup3 w_lc_detail_popup3

on w_lc_detail_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_lc_detail_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;if dw_1.Retrieve(gs_sabu, gs_code) < 1 then 
	f_message_chk(33, "[자료확인]")
	setnull(gs_code)
	setnull(gs_codename)
	setnull(gs_gubun)
	Close(this)
	return 
end if	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_lc_detail_popup3
integer x = 0
integer y = 1148
end type

type p_exit from w_inherite_popup`p_exit within w_lc_detail_popup3
integer x = 3397
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_lc_detail_popup3
boolean visible = false
integer x = 745
integer y = 952
end type

type p_choose from w_inherite_popup`p_choose within w_lc_detail_popup3
integer x = 3223
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
ELSEIF dw_1.GetItemString(ll_row, "polchd_pomaga") = 'Y' then
	Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
	return 
END IF

gs_code= dw_1.GetItemString(ll_Row, "polcdt_polcno")
gs_codename= dw_1.GetItemString(ll_row,"polcdt_baljpno")
gs_gubun= string(dw_1.GetItemNumber(ll_row,"polcdt_balseq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_lc_detail_popup3
integer x = 27
integer y = 192
integer width = 3538
integer height = 644
integer taborder = 10
string dataobject = "d_lc_detail_popup3"
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
//ELSEIF this.GetItemString(row, "polchd_pomaga") = 'Y' then
//	Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
//	return 
END IF

gs_code= dw_1.GetItemString(Row, "polcdt_polcno")
gs_codename= dw_1.GetItemString(row,"polcdt_baljpno")
gs_gubun= string(dw_1.GetItemNumber(row,"polcdt_balseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_lc_detail_popup3
boolean visible = false
integer x = 722
integer y = 1132
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_lc_detail_popup3
integer x = 1595
integer y = 1016
end type

type cb_return from w_inherite_popup`cb_return within w_lc_detail_popup3
integer x = 2235
integer y = 1016
end type

type cb_inq from w_inherite_popup`cb_inq within w_lc_detail_popup3
integer x = 1925
integer y = 1016
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_lc_detail_popup3
boolean visible = false
integer x = 297
integer y = 1132
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_lc_detail_popup3
boolean visible = false
integer y = 1144
integer width = 251
long backcolor = 12632256
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_lc_detail_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 188
integer width = 3561
integer height = 660
integer cornerheight = 40
integer cornerwidth = 55
end type

