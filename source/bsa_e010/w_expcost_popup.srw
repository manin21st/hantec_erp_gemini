$PBExportHeader$w_expcost_popup.srw
$PBExportComments$수출비용 선택 POPUP
forward
global type w_expcost_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_expcost_popup
end type
type pb_2 from u_pb_cal within w_expcost_popup
end type
type rr_1 from roundrectangle within w_expcost_popup
end type
end forward

global type w_expcost_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 3086
integer height = 1836
string title = "수출비용 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_expcost_popup w_expcost_popup

on w_expcost_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_expcost_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;String sToday

sToday = f_today()

dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)
dw_jogun.SetFocus()
dw_jogun.SetItem(1,'sdatef', left(sToday,6)+'01')
dw_jogun.SetItem(1,'sdatet', sToday)
dw_jogun.SetColumn('sdatef')

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_expcost_popup
integer y = 28
integer width = 2450
string dataobject = "d_date_from_to"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sDate, snull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'sdatef','sdatet'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(1,GetColumnName(),sNull)
	      Return 1
      END IF
End Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_expcost_popup
integer x = 2853
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_expcost_popup
integer x = 2505
integer y = 28
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet
String sSaupj

If dw_jogun.AcceptText() <> 1 Then Return

sSaupj = Trim(dw_jogun.GetItemString(1,'saupj'))

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_jogun.SetColumn('saupj')
	Return
End If

sDatef = dw_jogun.GetItemString(1,'sdatef')
sDatet = dw_jogun.GetItemString(1,'sdatet')

dw_1.Retrieve(gs_sabu, sDatef, sDatet, sSaupj)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_expcost_popup
integer x = 2679
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long ll_row, xx

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code			= dw_1.GetItemString(ll_Row, "costno")
gs_codename		 = String(dw_1.getitemdecimal(ll_row, "iseq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_expcost_popup
integer x = 32
integer y = 212
integer width = 3003
integer height = 1480
integer taborder = 40
string dataobject = "d_expcost_popup"
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

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "costno")
gs_codename		= String(dw_1.getitemdecimal(row, "iseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_expcost_popup
boolean visible = false
integer x = 329
integer y = 1896
integer width = 78
integer taborder = 30
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_expcost_popup
boolean visible = false
integer x = 1339
integer y = 1952
integer taborder = 50
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_expcost_popup
boolean visible = false
integer x = 1952
integer y = 1952
integer taborder = 70
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_expcost_popup
boolean visible = false
integer x = 1646
integer y = 1952
integer taborder = 60
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_expcost_popup
boolean visible = false
integer x = 443
integer y = 1896
integer width = 78
boolean enabled = false
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_expcost_popup
boolean visible = false
integer y = 1948
integer width = 315
long textcolor = 128
string text = "발생일자"
end type

type pb_1 from u_pb_cal within w_expcost_popup
integer x = 686
integer y = 52
integer height = 76
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_expcost_popup
integer x = 1134
integer y = 48
integer height = 76
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_expcost_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 204
integer width = 3026
integer height = 1496
integer cornerheight = 40
integer cornerwidth = 55
end type

