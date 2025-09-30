$PBExportHeader$w_project_popup.srw
$PBExportComments$PROJECT 선택 POPUP
forward
global type w_project_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_project_popup
end type
end forward

global type w_project_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2619
integer height = 1936
string title = "프로젝트 조회 선택 POPUP"
rr_2 rr_2
end type
global w_project_popup w_project_popup

on w_project_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_project_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;/* gs_gubun : 1(영업),2(연구소) */
dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

dw_jogun.SetFocus()

If gs_gubun = '1' Then
	dw_jogun.SetItem(1, 'gubun','1')
Else
	dw_jogun.SetItem(1, 'gubun','2')
End If

dw_jogun.SetColumn('sdatef')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_project_popup
integer x = 23
integer y = 180
integer width = 2583
integer height = 148
string dataobject = "d_project_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_project_popup
integer x = 2414
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_project_popup
integer x = 2066
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sMax, sMin, sGubun

If dw_jogun.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_jogun.GetItemString(1,'sdatef'))
sDatet = Trim(dw_jogun.GetItemString(1,'sdatet'))
sGubun = Trim(dw_jogun.GetItemString(1,'gubun'))

dw_jogun.SetFocus()

SELECT MAX(PJTNO), MIN(PJTNO)
  INTO :sMax, :sMin
  FROM VW_PROJECT
 WHERE GUBUN = :sGubun;

If IsNull(sDatef) Or sDatef = '' Then sDatef = sMin
If IsNull(sDatet) Or sDatet = '' Then sDatet = sMax

dw_1.Retrieve(gs_sabu, sDatef, sDatet, sGubun)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_project_popup
integer x = 2240
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "pjtno")
gs_codename = dw_1.GetItemString(ll_Row, "pjtdes")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_project_popup
integer x = 37
integer width = 2546
integer height = 1492
integer taborder = 20
string dataobject = "d_project_popup"
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

gs_code = dw_1.GetItemString(Row, "pjtno")
gs_codename = dw_1.GetItemString(Row, "pjtdes")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_project_popup
boolean visible = false
integer x = 1010
integer y = 2008
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_project_popup
integer x = 2752
integer y = 1844
end type

type cb_return from w_inherite_popup`cb_return within w_project_popup
integer x = 3374
integer y = 1844
end type

type cb_inq from w_inherite_popup`cb_inq within w_project_popup
integer x = 3063
integer y = 1844
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_project_popup
boolean visible = false
integer x = 521
integer y = 2008
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_project_popup
boolean visible = false
integer y = 2024
integer width = 494
string text = "C.INVOICE No."
end type

type rr_2 from roundrectangle within w_project_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 344
integer width = 2574
integer height = 1500
integer cornerheight = 40
integer cornerwidth = 55
end type

