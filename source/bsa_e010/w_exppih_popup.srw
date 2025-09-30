$PBExportHeader$w_exppih_popup.srw
$PBExportComments$P/I NO 선택 POPUP
forward
global type w_exppih_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_exppih_popup
end type
type pb_2 from u_pb_cal within w_exppih_popup
end type
type rr_1 from roundrectangle within w_exppih_popup
end type
end forward

global type w_exppih_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2862
integer height = 1872
string title = "Proforma Invoice No. 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_exppih_popup w_exppih_popup

type variables
String isLocalYn
end variables

on w_exppih_popup.create
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

on w_exppih_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;// Local 구분
If gs_code = 'ALL' Then
	isLocalYn = ''
ElseIf gs_code = 'Y' Then
	isLocalYn = 'Y'
Else
	isLocalYn = 'N'
End If

If gs_gubun = '2' Then
	dw_1.DataObject = 'd_exppih_popup2'
Else
	dw_1.DataObject = 'd_exppih_popup'
End If

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_jogun.SetTransObject(sqlca)

// 관할구역 설정
f_child_saupj(dw_jogun, 'sarea', gs_saupj)

dw_jogun.InsertRow(0)

String sDate
String sarea, steam, saupj

sDate = f_today()

dw_jogun.SetItem(1, 'sdatef', Left(sDate,6) + '01')
dw_jogun.SetItem(1, 'sdatet', sDate)

/* User별 관할구역 Setting */
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If
dw_jogun.SetItem(1, 'sarea', sarea)

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')

f_window_center_response(this)
	
dw_jogun.SetFocus()
dw_jogun.SetColumn('sdatef')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_exppih_popup
integer x = 41
integer y = 28
integer width = 2272
integer height = 200
string dataobject = "d_exppi_01_popup"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
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
end Choose

end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
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

type p_exit from w_inherite_popup`p_exit within w_exppih_popup
integer x = 2665
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_exppih_popup
integer x = 2318
integer y = 28
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sCvcod, sSaupj, sarea

If dw_jogun.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_jogun.GetItemString(1,'sdatef'))
sDatet = Trim(dw_jogun.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_jogun.GetItemString(1,'cvcod'))
sSaupj = Trim(dw_jogun.GetItemString(1,'saupj'))
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
	Return
End If

If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''
If IsNull(sarea)  or sarea = ''  then sarea = ''

dw_1.Retrieve(gs_sabu,sDatef, sDatet, sCvcod+'%', sarea+'%', sSaupj, isLocalYn+'%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_exppih_popup
integer x = 2491
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "exppih_pino")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_exppih_popup
integer x = 50
integer y = 256
integer width = 2770
integer height = 1452
integer taborder = 20
string dataobject = "d_exppih_popup"
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

gs_code= dw_1.GetItemString(Row, "exppih_pino")
//gs_codename= dw_1.GetItemString(row,"cust_name")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_exppih_popup
boolean visible = false
integer x = 1010
integer y = 1888
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_exppih_popup
boolean visible = false
integer x = 466
integer y = 1872
end type

type cb_return from w_inherite_popup`cb_return within w_exppih_popup
boolean visible = false
integer x = 1097
integer y = 1872
end type

type cb_inq from w_inherite_popup`cb_inq within w_exppih_popup
boolean visible = false
integer x = 786
integer y = 1872
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_exppih_popup
boolean visible = false
integer x = 521
integer y = 1888
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_exppih_popup
boolean visible = false
integer y = 1816
integer width = 494
string text = "C.INVOICE No."
end type

type pb_1 from u_pb_cal within w_exppih_popup
integer x = 709
integer y = 40
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

type pb_2 from u_pb_cal within w_exppih_popup
integer x = 1157
integer y = 36
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

type rr_1 from roundrectangle within w_exppih_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 244
integer width = 2798
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 55
end type

