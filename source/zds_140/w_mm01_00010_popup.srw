$PBExportHeader$w_mm01_00010_popup.srw
$PBExportComments$** 입고번호 조회 팝업
forward
global type w_mm01_00010_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_mm01_00010_popup
end type
end forward

global type w_mm01_00010_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 1765
integer height = 1960
string title = "출고번호 조회(기타)"
rr_1 rr_1
end type
global w_mm01_00010_popup w_mm01_00010_popup

on w_mm01_00010_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mm01_00010_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)


dw_jogun.setitem(1, 'fr_date', f_afterday(f_today() , -60) )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mm01_00010_popup
integer x = 27
integer y = 32
integer width = 1138
integer height = 136
string dataobject = "d_mm01_00010_popup_1"
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

type p_exit from w_inherite_popup`p_exit within w_mm01_00010_popup
integer x = 1545
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mm01_00010_popup
integer x = 1198
integer y = 8
end type

event p_inq::clicked;call super::clicked;
String sdatef,sdatet

if dw_jogun.AcceptText() = -1 then return 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))


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

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet ) <= 0 THEN
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

type p_choose from w_inherite_popup`p_choose within w_mm01_00010_popup
integer x = 1371
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "jpno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mm01_00010_popup
integer x = 46
integer y = 200
integer width = 1669
integer height = 1636
string dataobject = "d_mm01_00010_popup_2"
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

gs_code= dw_1.GetItemString(Row, "jpno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mm01_00010_popup
boolean visible = false
integer x = 1102
integer y = 2100
integer width = 1001
integer height = 76
end type

type cb_1 from w_inherite_popup`cb_1 within w_mm01_00010_popup
boolean visible = false
integer x = 389
integer y = 2040
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_mm01_00010_popup
boolean visible = false
integer x = 1010
integer y = 2040
integer taborder = 40
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_mm01_00010_popup
boolean visible = false
integer x = 699
integer y = 2040
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mm01_00010_popup
boolean visible = false
integer x = 439
integer y = 2096
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_mm01_00010_popup
boolean visible = false
integer x = 169
integer y = 2116
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_mm01_00010_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 1682
integer height = 1660
integer cornerheight = 40
integer cornerwidth = 55
end type

