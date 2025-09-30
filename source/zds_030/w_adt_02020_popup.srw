$PBExportHeader$w_adt_02020_popup.srw
$PBExportComments$공정 LOT NO 조회
forward
global type w_adt_02020_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_adt_02020_popup
end type
end forward

global type w_adt_02020_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3214
integer height = 1948
string title = "공정 LOT NO 조회"
rr_1 rr_1
end type
global w_adt_02020_popup w_adt_02020_popup

type variables
string is_jobcode, is_pdtgu
end variables

on w_adt_02020_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_adt_02020_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

// 작업조건 번호 : gs_gubun이 null이면 공정코드로 조회하며 not null이면 작업조건으로 조회한다
If IsNull(gs_gubun) Then
	SetNull(is_jobcode)
	dw_1.DataObject = 'd_adt_02020_popup_3'
Else
	// 생산팀
	select pdtgu into :is_pdtgu from wrkctr where wkctr = :gs_code;
	
	is_jobcode = gs_gubun
	dw_1.DataObject = 'd_adt_02020_popup_2'
	dw_jogun.object.t_roslt.visible = false
	dw_jogun.object.roslt.visible = false
End If
dw_1.SetTransObject(sqlca)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_adt_02020_popup
integer x = 5
integer y = 24
integer width = 2053
integer height = 140
string dataobject = "d_adt_02020_popup_1"
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

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_adt_02020_popup
integer x = 2976
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_adt_02020_popup
integer x = 2629
integer y = 16
end type

event p_inq::clicked;call super::clicked;
String sdatef, sdatet, sRoslt

if dw_jogun.AcceptText() = -1 then return 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))
sRoslt = trim(dw_jogun.GetItemString(1,"roslt"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sRoslt = "" OR IsNull(sRoslt) THEN sRoslt = ''

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

If Not IsNull(is_jobcode) Then
	IF dw_1.Retrieve(gs_sabu, sDatef, sDatet, is_jobcode, is_pdtgu) <= 0 THEN
		messagebox("확인", "조회한 자료가 없습니다!!")
		dw_jogun.SetColumn(1)
		dw_jogun.SetFocus()
		Return
	END IF
Else
	IF dw_1.Retrieve(gs_sabu, sDatef, sDatet, sRoslt) <= 0 THEN
		messagebox("확인", "조회한 자료가 없습니다!!")
		dw_jogun.SetColumn(1)
		dw_jogun.SetFocus()
		Return
	END IF
End If

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_adt_02020_popup
integer x = 2802
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "shpact_lotsno")  
gs_codename = dw_1.GetItemString(ll_Row, "itnbr")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_adt_02020_popup
integer x = 23
integer y = 196
integer width = 3127
integer height = 1636
string dataobject = "d_adt_02020_popup_2"
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

gs_code= dw_1.GetItemString(Row, "shpact_lotsno")  
gs_codename = dw_1.GetItemString(Row, "itnbr")  

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_adt_02020_popup
boolean visible = false
integer x = 1010
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_adt_02020_popup
integer x = 242
integer y = 2028
end type

type cb_return from w_inherite_popup`cb_return within w_adt_02020_popup
integer x = 864
integer y = 2028
integer taborder = 40
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_adt_02020_popup
integer x = 553
integer y = 2028
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_adt_02020_popup
boolean visible = false
integer x = 347
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_adt_02020_popup
boolean visible = false
integer x = 73
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_adt_02020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 184
integer width = 3154
integer height = 1660
integer cornerheight = 40
integer cornerwidth = 55
end type

