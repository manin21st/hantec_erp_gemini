$PBExportHeader$w_daeche_popup.srw
$PBExportComments$대체번호조회 popup-권
forward
global type w_daeche_popup from w_inherite_popup
end type
type dw_3 from datawindow within w_daeche_popup
end type
type pb_1 from u_pb_cal within w_daeche_popup
end type
type pb_2 from u_pb_cal within w_daeche_popup
end type
type rr_1 from roundrectangle within w_daeche_popup
end type
end forward

global type w_daeche_popup from w_inherite_popup
integer width = 3090
integer height = 1740
string title = "내수 -> 수출대체 처리 조회"
dw_3 dw_3
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_daeche_popup w_daeche_popup

on w_daeche_popup.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_daeche_popup.destroy
call super::destroy
destroy(this.dw_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;f_window_center_response(This)

dw_3.InsertRow(0)
dw_3.SetItem(1, 'sdate', left(f_today(),6)+'01')
dw_3.SetItem(1, 'edate', f_today())

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_daeche_popup
integer x = 105
integer y = 1916
end type

type p_exit from w_inherite_popup`p_exit within w_daeche_popup
integer x = 2848
end type

event clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_daeche_popup
integer x = 2501
end type

event p_inq::clicked;call super::clicked;String	ls_sdate, ls_edate, ls_local, ls_cvcod

IF dw_3.AcceptText() = -1 THEN Return

ls_sdate = dw_3.GetITemString(1, 'sdate')
ls_edate = dw_3.GetITemString(1, 'edate')
ls_local = dw_3.GetITemString(1, 'local')
ls_cvcod = dw_3.GetITemString(1, 'cvcod')

IF ls_sdate = '' Or IsNull(ls_sdate) THEN ls_sdate = '10010101'
IF ls_edate = '' Or IsNull(ls_edate) THEN ls_edate = '99991231'
IF ls_cvcod = '' Or IsNull(ls_cvcod) THEN ls_cvcod = '%'

IF dw_1.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_cvcod, ls_local) <= 0 THEN 
	f_message_chk(50, '[]')
	dw_3.SetFocus()
	dw_3.Setcolumn('sdate')
	Return
END IF
end event

type p_choose from w_inherite_popup`p_choose within w_daeche_popup
integer x = 2674
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "imhist_daeche_repno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_daeche_popup
integer x = 64
integer y = 320
integer width = 2949
integer height = 1284
string dataobject = "d_daeche_popup2"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "imhist_daeche_repno")  


Close(Parent)

end event

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type sle_2 from w_inherite_popup`sle_2 within w_daeche_popup
boolean visible = false
integer x = 297
integer y = 2112
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_daeche_popup
boolean visible = false
integer x = 2235
integer y = 1952
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code= dw_1.GetItemString(ll_Row, "imhist_daeche_repno")  
//
//Close(Parent)
//
end event

type cb_return from w_inherite_popup`cb_return within w_daeche_popup
boolean visible = false
integer x = 2871
integer y = 1952
end type

event cb_return::clicked;call super::clicked;//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_daeche_popup
boolean visible = false
integer x = 2555
integer y = 1952
end type

event cb_inq::clicked;call super::clicked;//String	ls_sdate, ls_edate, ls_local, ls_cvcod
//
//IF dw_3.AcceptText() = -1 THEN Return
//
//ls_sdate = dw_3.GetITemString(1, 'sdate')
//ls_edate = dw_3.GetITemString(1, 'edate')
//ls_local = dw_3.GetITemString(1, 'local')
//ls_cvcod = dw_3.GetITemString(1, 'cvcod')
//
//IF ls_sdate = '' Or IsNull(ls_sdate) THEN ls_sdate = '10010101'
//IF ls_edate = '' Or IsNull(ls_edate) THEN ls_edate = '99991231'
//IF ls_cvcod = '' Or IsNull(ls_cvcod) THEN ls_cvcod = '%'
//
//IF dw_1.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_cvcod, ls_local) <= 0 THEN 
//	f_message_chk(50, '[]')
//	dw_3.SetFocus()
//	dw_3.Setcolumn('sdate')
//	Return
//END IF
end event

type sle_1 from w_inherite_popup`sle_1 within w_daeche_popup
boolean visible = false
integer x = 114
integer y = 2112
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_daeche_popup
boolean visible = false
integer x = 466
integer y = 2040
end type

type dw_3 from datawindow within w_daeche_popup
event ue_pressenter pbm_dwnprocessenter
integer x = 46
integer y = 44
integer width = 2235
integer height = 256
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_daeche_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String	ls_name, ls_data

IF GetColumnName() = 'cvcod' THEN
	
	ls_data = GetText()
	
	SELECT	cvnas2
	INTO		:ls_name
	FROM		vndmst
	WHERE		cvcod = :ls_data	
	  AND		cvstatus = '0'	;
	  
	IF Sqlca.SqlCode <> 0 THEN
		MessageBox('확인', '등록되지않은 거래처 입니다.')
		SetItem(1, 'cvcod', '')
		SetItem(1, 'cvnas', '')
		Return 1
	END IF
	
	SetItem(1, 'cvnas', ls_name)
	
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF GetColumnName() = 'cvcod' THEN
	open(w_vndmst_popup)
	IF gs_code = '' OR IsNull(gs_code) THEN Return
		
	SetItem(1, 'cvcod', gs_code)
	SetItem(1, 'cvnas', gs_codename)
END IF
end event

type pb_1 from u_pb_cal within w_daeche_popup
integer x = 791
integer y = 92
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

type pb_2 from u_pb_cal within w_daeche_popup
integer x = 1271
integer y = 92
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

type rr_1 from roundrectangle within w_daeche_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 308
integer width = 2971
integer height = 1308
integer cornerheight = 40
integer cornerwidth = 55
end type

