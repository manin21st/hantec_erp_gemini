$PBExportHeader$w_sal_04050.srw
$PBExportComments$수금계획 생성
forward
global type w_sal_04050 from w_inherite
end type
type dw_ip from u_key_enter within w_sal_04050
end type
type gb_4 from groupbox within w_sal_04050
end type
type gb_3 from groupbox within w_sal_04050
end type
type gb_2 from groupbox within w_sal_04050
end type
type dw_sugumplan from datawindow within w_sal_04050
end type
type rr_2 from roundrectangle within w_sal_04050
end type
end forward

global type w_sal_04050 from w_inherite
string title = "수금계획 생성"
dw_ip dw_ip
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
dw_sugumplan dw_sugumplan
rr_2 rr_2
end type
global w_sal_04050 w_sal_04050

on w_sal_04050.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_sugumplan=create dw_sugumplan
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.dw_sugumplan
this.Control[iCurrent+6]=this.rr_2
end on

on w_sal_04050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_sugumplan)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_sugumplan.SetTransObject(sqlca)

dw_ip.InsertRow(0)
dw_ip.SetFocus()

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'saupj', saupj)
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

dw_insert.SetRowFocusIndicator(Hand!, 0, -15)
end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_04050
integer x = 114
integer y = 256
integer width = 4430
integer height = 2020
integer taborder = 20
string dataobject = "d_sal_04050"
boolean hscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;//SelectRow(0, FALSE)
//SetRow(row)
//SelectRow(row, TRUE)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;//SelectRow(0, FALSE)
//SetRow(currentrow)
//SelectRow(currentrow, TRUE)
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string sIpgumDate, sNull, sCheckNo, sSalegu, sSugumgb
Long 	 nRow, nfind, ix

nRow = GetRow()
If nRow <= 0 Then Return

setnull(sNull)

Choose Case GetColumnName()
	Case "ipgum_date"
		sIpgumDate = Trim(GetText())
		IF sIpgumDate = "" OR IsNull(sIpgumDate) THEN RETURN
		
		IF f_datechk(sIpgumDate) = -1 THEN
			f_message_chk(35,'[수금예정일자]')
			SetItem(nRow, "ipgum_date", snull)
			Return 1
		END IF

		sCheckNo = GetItemString(nRow, 'checkno')
		sSalegu  = GetItemString(nRow, 'salegu')
		sSugumgb  = GetItemString(nRow, 'sugumgb')
		For ix = 1 To RowCount()
			If ix = nRow Then Continue
		
			If sCheckNo = GetItemString(ix, 'checkno') And sSalegu  = GetItemString(ix, 'salegu') And & 
			   sIpgumDate = GetItemString(ix, 'ipgum_date') And sSugumgb = GetItemString(ix, 'sugumgb') Then
				MessageBox('확 인','동일한 일자로 수금계획이 존재합니다.!!~n~n'+string(ix)+' 줄')
				Return 1
			End If
		Next
	Case "sugumgb"
		sSugumgb = Trim(GetText())
		IF sSugumgb = "" OR IsNull(sSugumgb) THEN RETURN
		
		sCheckNo = GetItemString(nRow, 'checkno')
		sSalegu  = GetItemString(nRow, 'salegu')
		sIpgumDate  = GetItemString(nRow, 'ipgum_date')
		For ix = 1 To RowCount()
			If ix = nRow Then Continue
		
			If sCheckNo = GetItemString(ix, 'checkno') And sSalegu  = GetItemString(ix, 'salegu') And & 
			   sIpgumDate = GetItemString(ix, 'ipgum_date') And sSugumgb = GetItemString(ix, 'sugumgb') Then
				MessageBox('확 인','동일한 일자로 수금계획이 존재합니다.!!~n~n'+string(ix)+' 줄')
				Return 1
			End If
		Next
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_04050
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_04050
boolean visible = false
end type

type p_search from w_inherite`p_search within w_sal_04050
integer x = 2734
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\row복사_up.gif"
end type

event p_search::clicked;call super::clicked;Long nRow
String sNull

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

dw_insert.RowsCopy(nRow, nRow, Primary!, dw_insert, nRow+1, Primary!)

dw_insert.SetItem(nRow, 'ipgum_date', sNull)
dw_insert.SetItem(nRow, 'sugumgb', sNull)
dw_insert.SetItem(nRow, 'sugum_amt', 0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('ipgum_date')
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\row복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\row복사_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_04050
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_sal_04050
end type

type p_can from w_inherite`p_can within w_sal_04050
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

dw_ip.Modify('base_yymm.protect = 0')
dw_ip.Modify('saupj.protect = 0')
end event

type p_print from w_inherite`p_print within w_sal_04050
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sal_04050
integer x = 3744
end type

event p_inq::clicked;call super::clicked;String sBaseyymm, sSaupj, sRfna2, sIl, sIpgumDate, sSaleDt, sCashDate, sArea
Long   ix, lDay

If dw_ip.AcceptText() <> 1 Then Return

sArea = Trim(dw_ip.GetItemString(1, 'sarea'))
If IsNull(sArea) Or sArea = '' Then sArea = ''

sBaseYYmm = Trim(dw_ip.GetItemString(1, 'base_yymm'))
If IsNull(sBaseYYmm) Or sBaseYYmm = '' Then
	f_message_chk(30,'[기준년월]')
	Return
End If

sSaupj = Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	Return
End If

SetPointer(HourGlass!)

If dw_insert.retrieve(gs_sabu, sBaseyymm, sSaupj, sArea+'%') < 1 then
	f_message_chk(50,'')
	Return
End If

/* 수금기준일자 */
Select dataname into :sIl
 From syscnfg
Where (sysgu = 'S') and (serial = 3) and (lineno = '30');

If IsNull(sil) Or Not IsNumber(sil) Then	sIl = '10'

/* 수금예상일자 생성 */
For ix = 1 To dw_insert.RowCount()
	sIpgumDate = Trim(dw_insert.GetItemString(ix, 'ipgum_date'))
	If IsNull(sIpgumDate) Or sIpgumDate = '' Then
		sRfna2 = dw_insert.GetItemString(ix, 'rfna2')
		If IsNumber(sRfna2) Then
			lDay = Long(sRfna2)
		Else
			lDay = 0
		End If

		/* 수금일 */
		sSaleDt = Trim(dw_insert.GetItemString(ix, 'saledt'))
		sIpgumDate = f_aftermonth(Left(sSaledt,6),2) + sIl
		dw_insert.SetItem(ix, 'ipgum_date', sIpgumDate)	
				
		/* 결제조건에 따라 */
		If lDay = 0 Then
			dw_insert.SetItem(ix, 'sugumgb', '3') /* 현금 */
		Else
			dw_insert.SetItem(ix, 'sugumgb', '1') /* 어음 */
			
			/* 만기일 */
			sCashDate  = f_afterday(sIpgumDate, lDay)
			dw_insert.SetItem(ix, 'billdat', sCashDate)	
		End If

//		dw_insert.SetItem(ix, 'sugum_amt',  0)
	End If
Next

dw_ip.Modify('base_yymm.protect = 1')
dw_ip.Modify('saupj.protect = 1')
end event

type p_del from w_inherite`p_del within w_sal_04050
end type

event p_del::clicked;call super::clicked;Long nRow

nRow = dw_insert.GetRow()
IF nRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

IF F_Msg_Delete() = -1 THEN Return

dw_insert.DeleteRow(nRow)

sle_msg.text = '자료를 삭제하였습니다!! 저장버튼을 눌러야 반영됩니다.'

end event

type p_mod from w_inherite`p_mod within w_sal_04050
end type

event p_mod::clicked;call super::clicked;String syymm, sSaupj, sIpgumdate, sSugumgb, sArea
Long 	 ix, nRow
Double dSugumAmt

If dw_insert.AcceptText() <> 1 Then Return

IF F_Msg_Update() = -1 THEN Return

syymm  = Trim(dw_ip.GetItemString(1, 'base_yymm'))
sSaupj = Trim(dw_ip.GetItemString(1, 'saupj'))
sArea  = Trim(dw_ip.GetItemString(1, 'sarea'))

dw_sugumplan.Reset()

dw_insert.SetFocus()
For ix = 1 To dw_insert.RowCount()
	sIpgumDate = Trim(dw_insert.GetItemString(ix, 'ipgum_date'))
	If IsNull(sIpgumDate) Or sIpgumDate = '' Then Continue
	
	dSugumAmt = dw_insert.GetItemNumber(ix, 'sugum_amt')
	If IsNull(dSugumAmt) Or dSugumAmt = 0 Then Continue
	
	sSugumgb = Trim(dw_insert.GetItemString(ix, 'sugumgb'))
	If IsNull(sSugumgb) Or sSugumgb = '' Then
		f_message_chk(1400,'수금구분')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetColumn('sugumgb')
		Return
	End If
	
	nRow = dw_sugumplan.InsertRow(0)

	dw_sugumplan.SetItem(nRow, "SABU", 			gs_sabu)
	dw_sugumplan.SetItem(nRow, "SALEDT",   	Trim(dw_insert.GetItemString(ix, 'saledt')))
	dw_sugumplan.SetItem(nRow, "CHECKNO",  	Trim(dw_insert.GetItemString(ix, 'checkno')))
	dw_sugumplan.SetItem(nRow, "IPGUM_DATE",  Trim(dw_insert.GetItemString(ix, 'ipgum_date')))
	dw_sugumplan.SetItem(nRow, "CVCOD",   		Trim(dw_insert.GetItemString(ix, 'cvcod')))
	dw_sugumplan.SetItem(nRow, "SALEGU",   	dw_insert.GetItemString(ix, 'salegu'))
	dw_sugumplan.SetItem(nRow, "CURR",   		dw_insert.GetItemString(ix, 'cur'))
	dw_sugumplan.SetItem(nRow, "WRATE",   		dw_insert.GetItemNumber(ix, 'wrate'))
	dw_sugumplan.SetItem(nRow, "EXPAMT",   	dw_insert.GetItemNumber(ix, 'expamt'))
	dw_sugumplan.SetItem(nRow, "WAMT",   		dw_insert.GetItemNumber(ix, 'wamt'))
	dw_sugumplan.SetItem(nRow, "SUGUM_AMT",   dw_insert.GetItemNumber(ix, 'sugum_amt'))
	dw_sugumplan.SetItem(nRow, "SAUPJ",			dw_insert.GetItemString(ix, 'saupj'))
	dw_sugumplan.SetItem(nRow, "BILLDAT",		dw_insert.GetItemString(ix, 'billdat'))
	dw_sugumplan.SetItem(nRow, "SUGUMGB",		dw_insert.GetItemString(ix, 'sugumgb'))
Next

//If nRow > 0 Then
	/* 기존데이타 삭제 */
	DELETE FROM SUGUMPLAN A
	 WHERE A.SABU = :gs_sabu AND
			 A.SALEDT LIKE :sYymm||'%' AND
			 A.SAUPJ = :sSaupj AND
			 EXISTS ( SELECT B.CVCOD FROM VNDMST B
			           WHERE B.CVCOD = A.CVCOD AND
						        B.SAREA LIKE :sarea||'%' );
	
	IF dw_sugumplan.Update() <> 1 THEN
		ROLLBACK;
		f_message_chk(32,'')
		Return
	END IF
	
	COMMIT;
	
	cb_inq.TriggerEvent(Clicked!)
	
	sle_msg.text ='자료를 저장하였습니다!!'
//Else
//	MessageBox('확 인','생성된 자료가 없습니다.!!')
//End If
end event

type cb_exit from w_inherite`cb_exit within w_sal_04050
integer x = 3255
integer y = 1936
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_sal_04050
integer x = 2542
integer y = 1936
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_sal_04050
integer x = 603
integer y = 1936
integer taborder = 40
string text = "분할(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_04050
integer x = 960
integer y = 1936
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_sal_04050
integer x = 101
integer y = 1936
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sal_04050
integer y = 2176
integer taborder = 100
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_04050
end type

type cb_can from w_inherite`cb_can within w_sal_04050
integer x = 2898
integer y = 1936
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_04050
integer y = 2176
integer taborder = 110
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_04050
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_04050
end type

type dw_ip from u_key_enter within w_sal_04050
integer x = 96
integer y = 44
integer width = 2642
integer height = 184
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_04050_01"
boolean border = false
end type

event itemchanged;call super::itemchanged;string sfromdate, sNull

setnull(sNull)

Choose Case GetColumnName()
	Case "base_yymm"
		sFromDate = Trim(GetText())
		IF sFromDate = "" OR IsNull(sFromDate) THEN RETURN
		
		IF f_datechk(sFromDate+'01') = -1 THEN
			f_message_chk(35,'[기준년월]')
			SetItem(1,"base_yymm", snull)
			Return 1
		END IF
End Choose
end event

type gb_4 from groupbox within w_sal_04050
boolean visible = false
integer x = 2496
integer y = 1884
integer width = 1129
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_sal_04050
boolean visible = false
integer x = 567
integer y = 1884
integer width = 759
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_sal_04050
boolean visible = false
integer x = 59
integer y = 1884
integer width = 416
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_sugumplan from datawindow within w_sal_04050
boolean visible = false
integer x = 2807
integer y = 1212
integer width = 1815
integer height = 220
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_04050_02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_sal_04050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 248
integer width = 4448
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

