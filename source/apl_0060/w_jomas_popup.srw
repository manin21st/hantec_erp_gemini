$PBExportHeader$w_jomas_popup.srw
$PBExportComments$** 조코드 조회 선택
forward
global type w_jomas_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_jomas_popup
end type
type rr_1 from roundrectangle within w_jomas_popup
end type
end forward

global type w_jomas_popup from w_inherite_popup
integer x = 1257
integer y = 188
integer width = 2322
integer height = 1600
string title = "블럭 조회 선택"
boolean center = true
dw_2 dw_2
rr_1 rr_1
end type
global w_jomas_popup w_jomas_popup

type variables
String is_pdtgu
end variables

on w_jomas_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_jomas_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)

If gs_saupj = '10' Then
	is_pdtgu = '1'
ElseIf gs_saupj = '20' Then
	is_pdtgu = '2'
End If

dw_2.SetItem(1,'pdtgu', is_pdtgu)

dw_1.Retrieve(is_pdtgu)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_jomas_popup
boolean visible = false
integer x = 453
integer y = 2000
integer width = 613
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_jomas_popup
integer x = 2085
integer y = 16
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_jomas_popup
boolean visible = false
integer x = 1353
integer y = 1536
boolean enabled = false
end type

event p_inq::clicked;call super::clicked;If dw_2.AcceptText() <> 1 Then Return

is_pdtgu = Trim(dw_2.GetItemString(1,'pdtgu'))

dw_1.Retrieve(is_pdtgu)

end event

type p_choose from w_inherite_popup`p_choose within w_jomas_popup
integer x = 1911
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "jocod")
gs_codename = dw_1.GetItemString(ll_Row, "jonam")
gs_gubun = dw_1.GetItemString(ll_Row, "pdtgu")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_jomas_popup
integer x = 32
integer y = 204
integer width = 2263
integer height = 1300
integer taborder = 10
string dataobject = "d_jomas_popup"
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

gs_code = dw_1.GetItemString(Row, "jocod")
gs_codename = dw_1.GetItemString(Row, "jonam")
gs_gubun = dw_1.GetItemString(Row, "pdtgu")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_jomas_popup
boolean visible = false
integer x = 576
integer y = 1992
end type

type cb_1 from w_inherite_popup`cb_1 within w_jomas_popup
integer x = 453
integer y = 2524
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_jomas_popup
integer x = 773
integer y = 2524
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_jomas_popup
boolean visible = false
integer x = 978
integer y = 2228
boolean default = false
end type

event cb_inq::clicked;call super::clicked;dw_2.AcceptText()

is_pdtgu = Trim(dw_2.GetItemString(1, 'pdtgu'))

If isNull(is_pdtgu) Or is_pdtgu = '' Then
	is_pdtgu = '%'
End If

dw_1.Retrieve(is_pdtgu)
end event

type sle_1 from w_inherite_popup`sle_1 within w_jomas_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_jomas_popup
boolean visible = false
end type

type dw_2 from datawindow within w_jomas_popup
integer x = 82
integer y = 12
integer width = 1221
integer height = 176
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01400_02"
boolean border = false
boolean livescroll = true
end type

event itemchanged;p_inq.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_jomas_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 192
integer width = 2281
integer height = 1320
integer cornerheight = 40
integer cornerwidth = 55
end type

