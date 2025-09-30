$PBExportHeader$w_sal_03100_popup2.srw
$PBExportComments$소급적용 등록(매출)
forward
global type w_sal_03100_popup2 from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_sal_03100_popup2
end type
type pb_2 from u_pb_cal within w_sal_03100_popup2
end type
type rr_1 from roundrectangle within w_sal_03100_popup2
end type
end forward

global type w_sal_03100_popup2 from w_inherite_popup
integer x = 233
integer y = 188
integer width = 4069
integer height = 1952
string title = "소급전표번호 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_03100_popup2 w_sal_03100_popup2

on w_sal_03100_popup2.create
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

on w_sal_03100_popup2.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_03100_popup2
integer x = 9
integer y = 28
integer width = 1307
integer height = 140
string dataobject = "d_sal_03100_popup2_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_sal_03100_popup2
integer x = 3849
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_03100_popup2
integer x = 3502
integer y = 8
end type

event p_inq::clicked;call super::clicked;
String sdatef,sdatet

dw_jogun.AcceptText()

sdatef = dw_jogun.GetItemString(1,"fr_date")
sdatet = dw_jogun.GetItemString(1,"to_date")


IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF


IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, gs_saupj, sdatef, sdatet) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sal_03100_popup2
integer x = 3675
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "imhist_iojpno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_03100_popup2
integer x = 27
integer y = 180
integer width = 3982
integer height = 1644
string dataobject = "d_sal_03100_popup2_2"
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

gs_code= dw_1.GetItemString(Row, "imhist_iojpno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_03100_popup2
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_03100_popup2
integer x = 489
integer y = 2044
end type

type cb_return from w_inherite_popup`cb_return within w_sal_03100_popup2
integer x = 1111
integer y = 2044
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_sal_03100_popup2
integer x = 800
integer y = 2044
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_03100_popup2
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_sal_03100_popup2
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_sal_03100_popup2
integer x = 613
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_sal_03100_popup2
integer x = 1065
integer y = 52
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rr_1 from roundrectangle within w_sal_03100_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 176
integer width = 4009
integer height = 1656
integer cornerheight = 40
integer cornerwidth = 55
end type

