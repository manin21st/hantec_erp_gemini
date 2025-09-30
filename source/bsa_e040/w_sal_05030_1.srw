$PBExportHeader$w_sal_05030_1.srw
$PBExportComments$세금계산서 발행-건별발행
forward
global type w_sal_05030_1 from w_inherite_popup
end type
type cbx_1 from checkbox within w_sal_05030_1
end type
type cbx_2 from checkbox within w_sal_05030_1
end type
type pb_1 from u_pb_cal within w_sal_05030_1
end type
type pb_2 from u_pb_cal within w_sal_05030_1
end type
type dw_auto from u_d_popup_sort within w_sal_05030_1
end type
type rr_1 from roundrectangle within w_sal_05030_1
end type
type rr_2 from roundrectangle within w_sal_05030_1
end type
end forward

global type w_sal_05030_1 from w_inherite_popup
integer x = 5
integer y = 688
integer width = 4210
integer height = 2184
string title = "매출에 의한 세금계산서 건별발행"
event ue_open pbm_custom01
cbx_1 cbx_1
cbx_2 cbx_2
pb_1 pb_1
pb_2 pb_2
dw_auto dw_auto
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_05030_1 w_sal_05030_1

event ue_open;string sDate

sDate = f_today()

dw_jogun.SetTransObject(Sqlca)
dw_jogun.InsertRow(0)
dw_jogun.SetItem(1,'frdate',Left(sDate,6) + '01')
dw_jogun.SetItem(1,'todate',sDate)

dw_jogun.SetFocus()
dw_jogun.SetRow(1)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_jogun.SetItem(1, 'saupj', gs_code)
//End If

dw_jogun.SetColumn('saupj')

dw_auto.SetTransObject(sqlca)

//this.Height = 404
//this.Width = 3666

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')

end event

on w_sal_05030_1.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_auto=create dw_auto
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_auto
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_sal_05030_1.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_auto)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_05030_1
integer x = 23
integer y = 20
integer width = 2290
integer height = 292
string dataobject = "d_sal_05030_auto_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sSaleDate,sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF  sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	Case "frdate","todate"
		sSaleDate = Trim(this.GetText())
		IF sSaleDate = "" OR IsNull(sSaleDate) THEN RETURN
		
		IF f_datechk(sSaleDate) = -1 THEN
			f_message_chk(35,'[매출기간]')
			Return 1
		END IF
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

event dw_jogun::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0,False)

end event

type p_exit from w_inherite_popup`p_exit within w_sal_05030_1
integer x = 3954
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_05030_1
integer x = 3598
integer y = 28
end type

event p_inq::clicked;call super::clicked;Long   ll_row,nRowCnt
String sCvcod,sFrdate,sTodate, sSaupj, sSalegu, sSalegbn

If 	dw_jogun.AcceptText() <> 1 Then Return

ll_Row = dw_jogun.GetRow()
IF 	ll_Row <= 0 THEN
   	f_message_chk(36,'')
   	return
END IF

dw_jogun.SetFocus()

sCvcod     = Trim(dw_jogun.GetItemString(ll_Row, "cvcod"))      /* 거래처(6) */
If 	sCvcod = '' Or IsNull(sCvcod) Then
	f_message_chk(203,'[거래처]')
	dw_jogun.SetColumn('cvcod')
	Return 1
End If

sSaupj = Trim(dw_jogun.GetItemString(ll_Row, "saupj"))
If 	sSaupj = '' Or IsNull(sSaupj) Then
	f_message_chk(203,'[부가사업장]')
	dw_jogun.SetColumn('saupj')
	Return 1
End If

sFrdate = Trim(dw_jogun.GetItemString(ll_Row, "frdate"))
If 	sFrdate = '' Or IsNull(sFrdate) Then
	f_message_chk(35,'[매출기간]')
	dw_jogun.SetColumn('frdate')
	Return 1
End If

sTodate    = Trim(dw_jogun.GetItemString(ll_Row, "todate"))
If 	sTodate = '' Or IsNull(sTodate) Then
	f_message_chk(35,'[매출기간]')
	dw_jogun.SetColumn('todate')
	Return 1
End If

sSalegu    = Trim(dw_jogun.GetItemString(ll_Row, "salegu"))
sSalegbn   = Trim(dw_jogun.GetItemString(ll_Row, "salegbn"))	// 실적거래처 집계여부

/* 거래내역 조회 */
nRowCnt = dw_auto.Retrieve(gs_sabu,'%','%',sCvcod,sFrdate,sTodate, sSaupj, sSalegu, sSalegbn)
If nRowcnt <= 0 Then 
	f_message_chk(130,'')
	Return
End If

cbx_2.TriggerEvent(Clicked!)

end event

type p_choose from w_inherite_popup`p_choose within w_sal_05030_1
integer x = 3776
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long nRCnt,ix,nRtn

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)
SetNull(gs_gubun)

/* 선별 선택일 경우 */
SetPointer(HourGlass!)

If cbx_1.Checked = True  Then
  nRcnt = dw_auto.RowCount()
  If nRcnt <= 0 Then 
	 Close(Parent)
	 Return
  End If
  
  /* 선택되지 않은 것은 삭제 */
  dw_auto.SetRedraw(False)
  dw_auto.SetFilter("chk = 'Y'")
  dw_auto.filter()
  
  dw_auto.SetRedraw(True)
Else
	/* 선별선택이 아닌 경우 */
	
	/* 조회 */
	p_inq.TriggerEvent(Clicked!)
	nRcnt = dw_auto.RowCount()
	If nRcnt <= 0 Then 	 Return
	
	/* 모두선택 */
	For ix = 1 to nRcnt
		dw_auto.SetItem(ix,'chk','Y')
	Next
End If

/* 클립보드에 복사 */
If dw_auto.RowCount() > 0 then
	nRtn = dw_auto.SaveAs("dummy",Clipboard!,false)
	If nRtn = 1 Then
		gs_code     = Trim(dw_auto.GetItemString (1, "cvcod"))
		gs_codename = Trim(dw_jogun.GetItemString(1, "todate"))
		gs_gubun    = Trim(dw_jogun.GetItemString(1, "salegu"))
	Else
		f_message_chk(164,'')
	End If
End If

/* 일괄/건별 발행구분 */
If dw_jogun.GetItemString(1, 'balgu') = '1' Then
	gs_codename2 = 'Y'
Else
	gs_codename2 = 'N'
End IF

Close(parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_05030_1
boolean visible = false
integer x = 1275
integer y = 1712
integer width = 192
integer height = 116
boolean enabled = false
boolean vscrollbar = false
end type

event dw_1::ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_05030_1
boolean visible = false
integer x = 265
integer y = 1760
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_05030_1
boolean visible = false
integer x = 2130
integer y = 1796
integer taborder = 20
boolean enabled = false
string text = "발행(&S)"
end type

type cb_return from w_inherite_popup`cb_return within w_sal_05030_1
boolean visible = false
integer x = 2953
integer y = 1780
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sal_05030_1
boolean visible = false
integer x = 2587
integer y = 1796
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_05030_1
boolean visible = false
integer x = 1897
integer y = 1772
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_sal_05030_1
boolean visible = false
integer x = 123
integer y = 1620
end type

type cbx_1 from checkbox within w_sal_05030_1
boolean visible = false
integer x = 2656
integer y = 212
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "건별선택"
boolean checked = true
end type

event clicked;string chk

IF This.Checked = True THEN
	Chk = 'Y'
ELSE
	Chk = 'N'
END IF

/* 선별 선택일 경우 */
If 	chk = 'Y' Then
	cbx_2.Visible = True
	rr_2.Visible = True
	Parent.Height = 1684
//	Parent.Width = 2935
   	p_inq.Enabled = True
	p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
Else
	cbx_2.Visible = False
	rr_2.Visible = False
	Parent.Height = 404
//	Parent.Width = 2574
   	p_inq.Enabled = False
	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
End If

dw_jogun.SetFocus()
dw_jogun.SetColumn('cvcod')
end event

type cbx_2 from checkbox within w_sal_05030_1
integer x = 3767
integer y = 224
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;string chk
Long ix

IF This.Checked = True THEN
	Chk = 'Y'
ELSE
	Chk = 'N'
END IF

For ix = 1 To dw_auto.RowCount()
	dw_auto.SetItem(ix,'chk',chk)
Next
end event

type pb_1 from u_pb_cal within w_sal_05030_1
integer x = 713
integer y = 196
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('frdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'frdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05030_1
integer x = 1175
integer y = 196
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('todate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'todate', gs_code)

end event

type dw_auto from u_d_popup_sort within w_sal_05030_1
integer x = 32
integer y = 332
integer width = 4101
integer height = 1732
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_05030_auto"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05030_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 324
integer width = 4128
integer height = 1752
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_05030_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3712
integer y = 220
integer width = 416
integer height = 88
integer cornerheight = 40
integer cornerwidth = 55
end type

