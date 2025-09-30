$PBExportHeader$w_salehaldang_popup.srw
$PBExportComments$영업할당 조회 선택 POPUP
forward
global type w_salehaldang_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_salehaldang_popup
end type
type pb_2 from u_pb_cal within w_salehaldang_popup
end type
type rr_1 from roundrectangle within w_salehaldang_popup
end type
end forward

global type w_salehaldang_popup from w_inherite_popup
integer x = 174
integer y = 144
integer width = 3081
integer height = 1968
string title = "영업할당 조회 선택 POPUP"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_salehaldang_popup w_salehaldang_popup

on w_salehaldang_popup.create
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

on w_salehaldang_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event w_salehaldang_popup::open;call super::open;dw_1.SetTransObject(SQLCA)
dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

String sDate

sDate = f_today()

dw_jogun.SetItem(1, 'sdatef', Left(sDate,6) + '01')
dw_jogun.SetItem(1, 'sdatet', sDate)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If
dw_jogun.SetItem(1, 'sarea', sarea)
	
dw_jogun.SetFocus()
dw_jogun.SetColumn('sdatef')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_salehaldang_popup
integer x = 23
integer width = 3049
string dataobject = "d_salehaldang_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1, sNull

SetNull(sNull)

Choose Case GetColumnName()
   // 시작일자 유효성 Check
	Case "sdatef"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "sdatef", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "sdatet"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "sdatet", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
End Choose

end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_salehaldang_popup
integer x = 2871
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_salehaldang_popup
integer x = 2523
integer y = 8
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sCvcod,sarea

If dw_jogun.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_jogun.GetItemString(1,'sdatef'))
sDatet = Trim(dw_jogun.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_jogun.GetItemString(1,'cvcod'))
sarea  = Trim(dw_jogun.GetItemString(1,'sarea'))

dw_jogun.SetFocus()
If f_datechk(sDatef) <> 1  then
	f_message_chk(35,'')
	dw_jogun.SetColumn('sdatef')
	Return 
End If

If f_datechk(sDatet) <> 1  then
	f_message_chk(35,'')
	dw_jogun.SetColumn('sdatet')
	Return 
End If

If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''
If IsNull(sarea)  or sarea  = '' then sarea = ''

dw_1.Retrieve(gs_sabu,sDatef, sDatet, sarea+'%', sCvcod+'%' )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_salehaldang_popup
integer x = 2697
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "holdstock_hold_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_salehaldang_popup
integer x = 37
integer y = 340
integer width = 2990
integer height = 1476
integer taborder = 20
string dataobject = "d_salehaldang_popup"
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

gs_code= dw_1.GetItemString(Row, "holdstock_hold_no")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_salehaldang_popup
boolean visible = false
integer x = 1074
integer y = 2044
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_salehaldang_popup
boolean visible = false
integer x = 1842
integer y = 2096
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_salehaldang_popup
boolean visible = false
integer x = 2464
integer y = 2096
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_salehaldang_popup
boolean visible = false
integer x = 2153
integer y = 2096
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_salehaldang_popup
boolean visible = false
integer x = 585
integer y = 2044
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_salehaldang_popup
boolean visible = false
integer x = 64
integer y = 2060
integer width = 494
string text = "C.INVOICE No."
end type

type pb_1 from u_pb_cal within w_salehaldang_popup
integer x = 658
integer y = 188
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_salehaldang_popup
integer x = 1102
integer y = 184
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_salehaldang_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 328
integer width = 3008
integer height = 1504
integer cornerheight = 40
integer cornerwidth = 55
end type

