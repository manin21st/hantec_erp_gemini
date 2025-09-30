$PBExportHeader$w_sugumno_popup.srw
$PBExportComments$ ===> 수금번호 조회 Popup
forward
global type w_sugumno_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_sugumno_popup
end type
type pb_2 from u_pb_cal within w_sugumno_popup
end type
type rr_2 from roundrectangle within w_sugumno_popup
end type
end forward

global type w_sugumno_popup from w_inherite_popup
integer width = 2501
integer height = 2200
string title = "수금번호조회, 선택"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_sugumno_popup w_sugumno_popup

event open;call super::open;String sToday

f_window_center_response(this)

dw_1.SetTransObject(SQLCA)
dw_jogun.SetTransObject(SQLCA)

// 관할구역 설정
f_child_saupj(dw_jogun, 'areacode', gs_saupj)

dw_jogun.InsertRow(0)

sToDay = f_today()

dw_jogun.SetItem(1,'sdatef',Left(sToday,6) + '01' )
dw_jogun.SetItem(1,'sdatet',sToday)


// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_jogun.SetItem(1, 'areacode', sarea)
	dw_jogun.Modify("areacode.protect=1")
	dw_jogun.Modify("areacode.background.color = 80859087")
End If

dw_jogun.SetFocus()
dw_jogun.SetColumn('sdatef')
end event

on w_sugumno_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_sugumno_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_sugumno_popup
integer x = 14
integer y = 176
integer width = 2464
integer height = 212
string dataobject = "d_sugumno_popup_key"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sSaupj

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'areacode', sSaupj)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sugumno_popup
integer x = 2299
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sugumno_popup
integer x = 1952
end type

event clicked;call super::clicked;string sFrDate, sToDate, sCvCod, sArea, sSaupj

If dw_jogun.AcceptText() <> 1 then Return

sFrDate = Trim(dw_jogun.GetItemstring(1,'sdatef'))
sToDate = Trim(dw_jogun.GetItemstring(1,'sdatet'))
sArea   = Trim(dw_jogun.GetItemstring(1,'areacode'))
sCvcod  = Trim(dw_jogun.GetItemstring(1,'custcode'))
sSaupj  = Trim(dw_jogun.GetItemstring(1,'saupj'))

If f_datechk(sFrdate) <> 1 Or f_datechk(sToDate) <> 1 Then
	f_message_chk(1400,'[수금기간]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('sdatef')
	Return
End If

IF IsNull(sArea)  or sArea  = "" THEN	sArea  = ""
IF IsNull(sCvcod) or sCvCod = "" THEN	sCvCod = ""
IF IsNull(sSaupj) or sSaupj = "" THEN	sSaupj = ""

If dw_1.Retrieve(sFrdate, sToDate, sCvCod+'%', sArea+'%', sSaupj+'%') < 1 then
	f_message_chk(50, '[수금번호조회]')
	Return
End If
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sugumno_popup
integer x = 2126
end type

event p_choose::clicked;call super::clicked;Long cur_row

cur_row = dw_1.GetSelectedRow(0)

IF cur_row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(cur_Row, "sugum_no")
gs_codename= String(dw_1.GetItemNumber(cur_row,"sugum_seq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sugumno_popup
integer x = 32
integer y = 400
integer width = 2427
integer height = 1684
string dataobject = "d_sugumno_popup"
end type

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "sugum_no")
gs_codename= String(dw_1.GetItemNumber(row,"sugum_seq"))

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_sugumno_popup
boolean visible = false
integer x = 2734
integer y = 64
end type

type cb_1 from w_inherite_popup`cb_1 within w_sugumno_popup
boolean visible = false
integer y = 2204
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sugumno_popup
boolean visible = false
integer y = 2204
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sugumno_popup
boolean visible = false
integer y = 2204
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sugumno_popup
boolean visible = false
integer x = 2601
integer y = 64
end type

type st_1 from w_inherite_popup`st_1 within w_sugumno_popup
boolean visible = false
integer x = 2894
integer y = 240
end type

type pb_1 from u_pb_cal within w_sugumno_popup
integer x = 727
integer y = 188
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sugumno_popup
integer x = 1170
integer y = 184
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

type rr_2 from roundrectangle within w_sugumno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 392
integer width = 2446
integer height = 1700
integer cornerheight = 40
integer cornerwidth = 55
end type

