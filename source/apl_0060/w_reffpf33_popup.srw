$PBExportHeader$w_reffpf33_popup.srw
$PBExportComments$공정검사시 불량원인
forward
global type w_reffpf33_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_reffpf33_popup
end type
end forward

global type w_reffpf33_popup from w_inherite_popup
integer width = 1893
integer height = 1936
string title = "공정검사 불량항목 조회 선택"
rr_1 rr_1
end type
global w_reffpf33_popup w_reffpf33_popup

on w_reffpf33_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_reffpf33_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;gs_code = ''
gs_codename = ''

dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_reffpf33_popup
integer x = 41
integer y = 32
integer width = 1472
integer height = 136
string dataobject = "d_reffpf33_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sData, sData2

Choose case GetColumnName()
	Case 'rfgub'
		sdata = Trim(GetText())
		
		sData2 = Trim(GetItemSTring(1, 'rfgub2'))
		
		If IsNull(sData)  Then sData  = ''
		If IsNull(sData2) Then sData2 = ''
		dw_1.Retrieve(sData+'%', sData2+'%')
	Case 'rfgub2'
		sdata2 = Trim(GetText())
		
		sData = Trim(GetItemSTring(1, 'rfgub'))
		
		If IsNull(sData)  Then sData  = ''
		If IsNull(sData2) Then sData2 = ''
		dw_1.Retrieve(sData+'%', sData2+'%')
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_reffpf33_popup
integer x = 1701
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_reffpf33_popup
boolean visible = false
integer x = 1504
integer y = 2084
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_reffpf33_popup
integer x = 1527
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "rfgub")
gs_codename= dw_1.GetItemString(ll_row,"rfna1")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_reffpf33_popup
integer x = 32
integer y = 188
integer width = 1824
integer height = 1632
integer taborder = 30
string dataobject = "d_reffpf33_popup"
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

gs_code= dw_1.GetItemString(Row, "rfgub")
gs_codename= dw_1.GetItemString(row,"rfna1")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_reffpf33_popup
boolean visible = false
integer x = 635
integer y = 2020
integer width = 859
boolean enabled = false
end type

event sle_2::getfocus;//IF dw_2.GetItemString(1,"rfgub") = '1' THEN
//	f_toggle_kor(Handle(this))
//ELSE
//	f_toggle_eng(Handle(this))
//END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_reffpf33_popup
integer x = 1029
integer y = 2192
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_reffpf33_popup
integer x = 1335
integer y = 2192
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_reffpf33_popup
integer x = 50
integer y = 2000
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_reffpf33_popup
boolean visible = false
integer x = 375
integer y = 2020
integer width = 261
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_reffpf33_popup
boolean visible = false
integer x = 50
integer y = 2032
integer width = 315
string text = "설비코드"
end type

type rr_1 from roundrectangle within w_reffpf33_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 1847
integer height = 1648
integer cornerheight = 40
integer cornerwidth = 55
end type

