$PBExportHeader$w_imt_02045_ckd_pop.srw
$PBExportComments$CKD 발주 팝업
forward
global type w_imt_02045_ckd_pop from w_inherite_popup
end type
type pb_2 from u_pb_cal within w_imt_02045_ckd_pop
end type
type pb_1 from u_pb_cal within w_imt_02045_ckd_pop
end type
type st_2 from statictext within w_imt_02045_ckd_pop
end type
type st_3 from statictext within w_imt_02045_ckd_pop
end type
type cbx_1 from checkbox within w_imt_02045_ckd_pop
end type
type st_4 from statictext within w_imt_02045_ckd_pop
end type
type rr_1 from roundrectangle within w_imt_02045_ckd_pop
end type
end forward

global type w_imt_02045_ckd_pop from w_inherite_popup
integer x = 466
integer y = 160
integer width = 4155
integer height = 2564
string title = "CKD 발주 선택"
boolean controlmenu = true
pb_2 pb_2
pb_1 pb_1
st_2 st_2
st_3 st_3
cbx_1 cbx_1
st_4 st_4
rr_1 rr_1
end type
global w_imt_02045_ckd_pop w_imt_02045_ckd_pop

type variables
string is_cvcod
end variables

on w_imt_02045_ckd_pop.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_2=create st_2
this.st_3=create st_3
this.cbx_1=create cbx_1
this.st_4=create st_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rr_1
end on

on w_imt_02045_ckd_pop.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cbx_1)
destroy(this.st_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

is_cvcod = gs_code

//dw_jogun.setitem(1, 'cvcod', is_cvcod )
dw_jogun.setitem(1, 'cvnas', gs_codename)
//dw_jogun.setitem(1, 'd_st', f_afterday(f_today(), -30))
//dw_jogun.setitem(1, 'd_ed', f_today())

dw_jogun.setitem(1, 'd_st', String(RelativeDate(TODAY(), -31), 'yyyymmdd'))
dw_jogun.setitem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

dw_jogun.SetFocus()
	
dw_1.ScrollToRow(1)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_inq.TriggerEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_02045_ckd_pop
integer x = 9
integer y = 12
integer width = 2798
integer height = 236
string dataobject = "d_imt_02045_ckd_pop1"
end type

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "cvnas", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
END IF
end event

event dw_jogun::itemchanged;call super::itemchanged;Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(1, 'cvnas', '')
			cbx_1.Enabled = False
			Return
		End If
		
		This.SetItem(1, 'cvnas', f_get_name5('11', data, ''))
		cbx_1.Enabled = True
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_imt_02045_ckd_pop
integer x = 3863
integer y = 0
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imt_02045_ckd_pop
integer x = 3515
integer y = 0
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_jogun.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_jogun.SetColumn('d_st')
		dw_jogun.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_jogun.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_jogun.SetColumn('d_ed')
		dw_jogun.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_jogun.setColumn('d_st')
	dw_jogun.SetFocus()
	Return -1
End If

String ls_fac

ls_fac = dw_jogun.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

String ls_stit

ls_stit = dw_jogun.GetItemString(row, 'stit')
If Trim(ls_stit) = '' OR IsNull(ls_stit) Then ls_stit = '.'

String ls_edit

ls_edit = dw_jogun.GetItemString(row, 'edit')
If Trim(ls_edit) = '' OR IsNull(ls_edit) Then ls_edit = 'ZZZZZZZZZZZZZZZZZZZZ'

String ls_cvcod

ls_cvcod = dw_jogun.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_fac, ls_stit, ls_edit, ls_cvcod)
dw_1.SetRedraw(True)

If dw_1.RowCount() < 1 Then Return -1

Return 1

end event

type p_choose from w_inherite_popup`p_choose within w_imt_02045_ckd_pop
integer x = 3689
integer y = 0
end type

event p_choose::clicked;call super::clicked;String ls_cvcod

ls_cvcod = dw_jogun.GetItemString(1, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('거래처 확인', '거래처를 입력 하신 후 선택하시기 바랍니다.')
	p_inq.TriggerEvent('Clicked')
	Return
End If

long		lsow, lrow
decimal	dqty, dbalqty

lsow = dw_1.FIND("opt='Y'", 1, dw_1.rowcount())
if lsow <= 0 then
	messagebox('확인','자료를 선택하십시오!!!')
	return
end if

gs_code = 'OK'

SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_imt_02045_ckd_pop
integer x = 27
integer y = 328
integer width = 4055
integer height = 2108
integer taborder = 20
string dataobject = "d_imt_02045_ckd_pop2"
boolean hscrollbar = true
boolean hsplitscroll = true
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

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_imt_02045_ckd_pop
boolean visible = false
integer x = 1125
integer y = 2500
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_imt_02045_ckd_pop
integer x = 1211
integer y = 2572
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_imt_02045_ckd_pop
integer x = 1833
integer y = 2572
end type

type cb_inq from w_inherite_popup`cb_inq within w_imt_02045_ckd_pop
integer x = 1522
integer y = 2572
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imt_02045_ckd_pop
boolean visible = false
integer x = 462
integer y = 2500
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imt_02045_ckd_pop
boolean visible = false
integer x = 192
integer y = 2520
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_2 from u_pb_cal within w_imt_02045_ckd_pop
integer x = 1271
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.SetColumn('d_ed')
IF IsNull(gs_code) THEN Return
If dw_jogun.Object.d_ed.protect = '1' Or dw_jogun.Object.d_ed.TabSequence = '0' Then Return

dw_jogun.SetItem(1, 'd_ed', gs_code)
end event

type pb_1 from u_pb_cal within w_imt_02045_ckd_pop
integer x = 795
integer y = 28
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.SetColumn('d_st')
IF IsNull(gs_code) THEN Return
If dw_jogun.Object.d_st.protect = '1' Or dw_jogun.Object.d_st.TabSequence = '0' Then Return

dw_jogun.SetItem(1, 'd_st', gs_code)
end event

type st_2 from statictext within w_imt_02045_ckd_pop
boolean visible = false
integer x = 2830
integer y = 152
integer width = 1248
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "※ 발주에 대한 납기요구일은 -3일 입니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_02045_ckd_pop
integer x = 2830
integer y = 208
integer width = 1193
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 자료 선택 전 발주처로 조회먼저 하십시오."
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_imt_02045_ckd_pop
integer x = 32
integer y = 252
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "전체선택"
end type

event clicked;Long   i
Long   ll_cnt

ll_cnt = dw_1.RowCount()
If ll_cnt < 1 Then Return

String ls_chk

If cbx_1.Checked = True Then
	ls_chk = 'Y'
Else
	ls_chk = 'N'
End If

For i = 1 To ll_cnt
	dw_1.SetItem(i, 'opt', ls_chk)
Next
end event

type st_4 from statictext within w_imt_02045_ckd_pop
integer x = 430
integer y = 256
integer width = 1824
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "※ 붉은색으로 표시된 자료는 분납자료 입니다. 영업팀 확인 바랍니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_imt_02045_ckd_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 320
integer width = 4087
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

