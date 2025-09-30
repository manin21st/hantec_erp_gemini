$PBExportHeader$w_sal_02190_popup.srw
$PBExportComments$특출 거래처 등록
forward
global type w_sal_02190_popup from w_inherite_popup
end type
type st_2 from statictext within w_sal_02190_popup
end type
type dw_ip from u_key_enter within w_sal_02190_popup
end type
type pb_1 from u_pb_cal within w_sal_02190_popup
end type
type pb_2 from u_pb_cal within w_sal_02190_popup
end type
type rr_1 from roundrectangle within w_sal_02190_popup
end type
type rr_2 from roundrectangle within w_sal_02190_popup
end type
end forward

global type w_sal_02190_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2971
integer height = 1904
string title = "특출거래처 선택"
st_2 st_2
dw_ip dw_ip
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02190_popup w_sal_02190_popup

on w_sal_02190_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.dw_ip=create dw_ip
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sal_02190_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.dw_ip)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sDate

dw_ip.InsertRow(0)
dw_ip.SetFocus()

sDate = f_today()
dw_ip.SetItem(1,'sdatef',Left(sDate,6)+'01')
dw_ip.SetItem(1,'sdatet',sDate)
dw_ip.SetColumn('sdatef')


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_02190_popup
boolean visible = false
integer x = 315
integer y = 808
end type

type p_exit from w_inherite_popup`p_exit within w_sal_02190_popup
integer x = 2766
integer y = 0
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_02190_popup
integer x = 2418
integer y = 0
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet

If dw_ip.AcceptText() <> 1 Then Return 

sDatef = dw_ip.GetItemString(1,'sdatef')
sDatet = dw_ip.GetItemString(1,'sdatet')

dw_1.Retrieve(gs_sabu, sDatef, sDatet)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sal_02190_popup
integer x = 2592
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "spcvndh_spcvnd_no")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_02190_popup
integer x = 46
integer y = 176
integer width = 2866
integer height = 1588
integer taborder = 40
string dataobject = "d_sal_021903"
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

gs_code= dw_1.GetItemString(Row, "spcvndh_spcvnd_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_02190_popup
boolean visible = false
integer x = 2373
integer y = 4
integer width = 78
integer taborder = 30
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_sal_02190_popup
boolean visible = false
integer x = 1275
integer y = 28
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_sal_02190_popup
boolean visible = false
integer x = 1888
integer y = 28
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_sal_02190_popup
boolean visible = false
integer x = 1582
integer y = 28
integer taborder = 60
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_02190_popup
boolean visible = false
integer x = 2263
integer y = 4
integer width = 78
boolean enabled = false
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_sal_02190_popup
integer x = 110
integer y = 44
integer width = 251
integer weight = 400
long backcolor = 33027312
string text = "등록일자"
end type

type st_2 from statictext within w_sal_02190_popup
integer x = 110
integer y = 32
integer width = 229
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_ip from u_key_enter within w_sal_02190_popup
integer x = 27
integer y = 8
integer width = 2231
integer height = 124
integer taborder = 20
string dataobject = "d_date_from_to"
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

type pb_1 from u_pb_cal within w_sal_02190_popup
integer x = 1157
integer y = 24
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02190_popup
integer x = 686
integer y = 24
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02190_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1047
integer y = 12
integer width = 146
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02190_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 164
integer width = 2917
integer height = 1628
integer cornerheight = 40
integer cornerwidth = 55
end type

