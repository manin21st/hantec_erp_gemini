$PBExportHeader$w_sal_02065_popup.srw
$PBExportComments$이벤트 제품 할인율 등록
forward
global type w_sal_02065_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sal_02065_popup
end type
type dw_ip from u_key_enter within w_sal_02065_popup
end type
type st_2 from statictext within w_sal_02065_popup
end type
type rr_2 from roundrectangle within w_sal_02065_popup
end type
end forward

global type w_sal_02065_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2359
integer height = 1824
string title = "이벤트 제품 할인율 선택"
rr_1 rr_1
dw_ip dw_ip
st_2 st_2
rr_2 rr_2
end type
global w_sal_02065_popup w_sal_02065_popup

on w_sal_02065_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_ip=create dw_ip
this.st_2=create st_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_2
end on

on w_sal_02065_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_ip)
destroy(this.st_2)
destroy(this.rr_2)
end on

event open;call super::open;String sDate

dw_ip.InsertRow(0)
dw_ip.SetFocus()

sDate = f_today()
dw_ip.SetItem(1,'syear',Left(sDate,4))

dw_ip.SetColumn('syear')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_02065_popup
integer x = 9
integer y = 2012
end type

type p_exit from w_inherite_popup`p_exit within w_sal_02065_popup
integer x = 2135
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_02065_popup
integer x = 1787
integer y = 8
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet

sDatef = dw_ip.GetItemString(1,'syear')

dw_1.Retrieve(gs_sabu, sDatef)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sal_02065_popup
integer x = 1961
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "event_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_02065_popup
integer x = 50
integer y = 192
integer width = 2231
integer height = 1480
integer taborder = 40
string dataobject = "d_sal_020652"
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

gs_code= dw_1.GetItemString(Row, "event_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_02065_popup
boolean visible = false
integer x = 2587
integer y = 44
integer width = 78
integer taborder = 30
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_sal_02065_popup
integer x = 1106
integer y = 1868
integer taborder = 50
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "event_no")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_sal_02065_popup
integer x = 1723
integer y = 1868
integer taborder = 70
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_02065_popup
integer x = 1417
integer y = 1868
integer taborder = 60
boolean default = false
end type

event cb_inq::clicked;String sDatef, sDatet

sDatef = dw_ip.GetItemString(1,'syear')

dw_1.Retrieve(gs_sabu, sDatef)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_sal_02065_popup
boolean visible = false
integer x = 2478
integer y = 44
integer width = 78
boolean enabled = false
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_sal_02065_popup
integer x = 73
integer y = 56
integer width = 256
integer weight = 400
long backcolor = 33027312
string text = "행사년도"
end type

type rr_1 from roundrectangle within w_sal_02065_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 16
integer width = 681
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_sal_02065_popup
integer x = 315
integer y = 36
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_date_year"
boolean border = false
end type

event itemchanged;String sDate, snull

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

event itemerror;return 1
end event

type st_2 from statictext within w_sal_02065_popup
integer x = 32
integer y = 56
integer width = 59
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sal_02065_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 168
integer width = 2295
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

