$PBExportHeader$w_expnego_popup.srw
$PBExportComments$NEGO NO 선택 POPUP
forward
global type w_expnego_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_expnego_popup
end type
type pb_2 from u_pb_cal within w_expnego_popup
end type
type rr_1 from roundrectangle within w_expnego_popup
end type
end forward

global type w_expnego_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2469
integer height = 1984
string title = "Nego No. 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_expnego_popup w_expnego_popup

on w_expnego_popup.create
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

on w_expnego_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

f_window_center_response(this)

dw_jogun.SetItem(1,'sdatef',Left(gs_gubun,8))
dw_jogun.SetItem(1,'sdatet',Right(gs_gubun,8))

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')

dw_jogun.SetItem(1, 'sarea', sarea)
	
dw_jogun.SetFocus()
dw_jogun.SetItem(1,'custcode',gs_code)
dw_jogun.SetColumn('custcode')
dw_jogun.TriggerEvent(ItemChanged!)

dw_jogun.SetColumn('sdatef')

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_expnego_popup
integer y = 160
integer width = 2450
integer height = 196
string dataobject = "d_expnego_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

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
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea",   sarea)
			SetItem(1,"custname",	scvnas)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,"custcode", sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF

end Choose

end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "custcode", "custname"
		gs_gubun = '2'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
End Choose

end event

type p_exit from w_inherite_popup`p_exit within w_expnego_popup
integer x = 2272
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_expnego_popup
integer x = 1925
integer y = 8
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sCvcod, sSaupj, sarea

If dw_jogun.AcceptText() <> 1 Then Return 1

sSaupj = Trim(dw_jogun.GetItemString(1,'saupj'))
sDatef = Trim(dw_jogun.GetItemString(1,'sdatef'))
sDatet = Trim(dw_jogun.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_jogun.GetItemString(1,'custcode'))
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

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_jogun.SetColumn('saupj')
	Return
End If

If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''
If IsNull(sarea)  or sarea = ''  then sarea = ''

dw_1.Retrieve(gs_sabu,sDatef, sDatet, sArea+'%', sCvcod+'%', ssaupj )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_expnego_popup
integer x = 2098
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "ngno")
gs_codename = String(dw_1.GetItemNumber(ll_Row, "sunsu"))
gs_gubun = dw_1.GetItemString(ll_Row, "cvcod")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_expnego_popup
integer x = 41
integer y = 372
integer width = 2363
integer height = 1388
integer taborder = 20
string dataobject = "d_expnego_popup"
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

gs_code= dw_1.GetItemString(Row, "ngno")
gs_codename = String(dw_1.GetItemNumber(Row, "sunsu"))
gs_gubun = dw_1.GetItemString(Row, "cvcod")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_expnego_popup
boolean visible = false
integer x = 1070
integer y = 2008
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_expnego_popup
boolean visible = false
integer x = 1321
integer y = 1896
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_expnego_popup
boolean visible = false
integer x = 1952
integer y = 1896
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_expnego_popup
boolean visible = false
integer x = 1641
integer y = 1896
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_expnego_popup
boolean visible = false
integer x = 581
integer y = 2008
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_expnego_popup
boolean visible = false
integer x = 59
integer y = 2024
integer width = 494
string text = "C.INVOICE No."
end type

type pb_1 from u_pb_cal within w_expnego_popup
integer x = 731
integer y = 172
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_expnego_popup
integer x = 1193
integer y = 168
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_expnego_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 360
integer width = 2418
integer height = 1404
integer cornerheight = 40
integer cornerwidth = 55
end type

