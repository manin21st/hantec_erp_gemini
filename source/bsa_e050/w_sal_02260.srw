$PBExportHeader$w_sal_02260.srw
$PBExportComments$계산서대 수금 정리
forward
global type w_sal_02260 from w_inherite
end type
type gb_2 from groupbox within w_sal_02260
end type
type gb_1 from groupbox within w_sal_02260
end type
type dw_ip from u_key_enter within w_sal_02260
end type
type st_2 from statictext within w_sal_02260
end type
type dw_sugum from u_d_select_sort within w_sal_02260
end type
type dw_salesugum from u_d_select_sort within w_sal_02260
end type
type pb_up from picturebutton within w_sal_02260
end type
type pb_down from picturebutton within w_sal_02260
end type
type pb_1 from u_pb_cal within w_sal_02260
end type
type pb_2 from u_pb_cal within w_sal_02260
end type
type rr_3 from roundrectangle within w_sal_02260
end type
type ln_1 from line within w_sal_02260
end type
end forward

global type w_sal_02260 from w_inherite
integer height = 2396
string title = "계산서대 수금 정리"
gb_2 gb_2
gb_1 gb_1
dw_ip dw_ip
st_2 st_2
dw_sugum dw_sugum
dw_salesugum dw_salesugum
pb_up pb_up
pb_down pb_down
pb_1 pb_1
pb_2 pb_2
rr_3 rr_3
ln_1 ln_1
end type
global w_sal_02260 w_sal_02260

forward prototypes
public function integer wf_retrieve (integer row)
end prototypes

public function integer wf_retrieve (integer row);String sSaledt, sCvcod
Int	 isaleno
Dec 	 dMijan

If row <= 0 Then Return -1

sCvcod  = dw_insert.GetItemString(row, 'cvcod')
sSaledt = dw_insert.GetItemString(row, 'saledt')
iSaleNo = dw_insert.GetItemNumber(row, 'saleno')
dMijan  = dw_insert.GetItemNumber(row, 'mijan')
If IsNull(dMijan) Then dMijan = 0

dw_salesugum.Retrieve(gs_sabu, sSaledt, iSaleNo, sCvcod)
dw_sugum.Retrieve(gs_sabu, sCvcod)

If dMijan <> 0 Then
	pb_up.visible = True
Else
	pb_up.visible = False
End IF

Return 0
end function

on w_sal_02260.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_ip=create dw_ip
this.st_2=create st_2
this.dw_sugum=create dw_sugum
this.dw_salesugum=create dw_salesugum
this.pb_up=create pb_up
this.pb_down=create pb_down
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_ip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_sugum
this.Control[iCurrent+6]=this.dw_salesugum
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.rr_3
this.Control[iCurrent+12]=this.ln_1
end on

on w_sal_02260.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_ip)
destroy(this.st_2)
destroy(this.dw_sugum)
destroy(this.dw_salesugum)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_salesugum.SetTransObject(sqlca)
dw_sugum.SetTransObject(sqlca)

dw_ip.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If

dw_ip.SetItem(1, 'sarea', sarea)


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

cb_can.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_02260
integer x = 151
integer y = 360
integer width = 4325
integer height = 588
integer taborder = 10
string dataobject = "d_sal_02260"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row <= 0 Then Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

If wf_retrieve(row) <= 0 Then Return
end event

type p_delrow from w_inherite`p_delrow within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_02260
end type

type p_can from w_inherite`p_can within w_sal_02260
end type

event p_can::clicked;call super::clicked;
dw_insert.Reset()
dw_salesugum.Reset()
dw_sugum.Reset()

dw_ip.SetFocus()
dw_ip.SetItem(1,'sdatef', left(is_today,6)+'01')
dw_ip.SetItem(1,'sdatet', is_today)
dw_ip.SetColumn('sdatef')
end event

type p_print from w_inherite`p_print within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_02260
integer x = 4091
end type

event p_inq::clicked;call super::clicked;String sDatef,sDatet, steamcd, sarea, scvcod, sSaupj
Long   nRcnt

If dw_ip.AcceptText() <> 1 Then Return

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sarea  = Trim(dw_ip.GetItemString(1,'sarea'))
sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))

dw_ip.SetFocus()
IF f_datechk(sDatef) <> 1 THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatef")
	Return
END IF

IF f_datechk(sDatet) <> 1 THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatet")
	Return
END IF

IF IsNull(sSaupj) Or sSaupj = '' then
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return
END IF

If IsnUll(sarea)  Then sarea = ''
If IsnUll(sCvcod) Then sCvcod = ''

dw_salesugum.Reset()
dw_sugum.Reset()
dw_insert.Retrieve(gs_sabu, sDatef, sDatet, sArea+'%', sCvcod +'%', sSaupj)
end event

type p_del from w_inherite`p_del within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_02260
boolean visible = false
integer y = 184
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sal_02260
integer x = 4023
integer y = 276
integer taborder = 170
end type

type cb_mod from w_inherite`cb_mod within w_sal_02260
integer y = 2312
integer taborder = 110
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_02260
integer y = 2312
integer taborder = 100
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_02260
integer y = 2312
integer taborder = 120
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02260
integer x = 3781
integer y = 524
integer taborder = 130
end type

type cb_print from w_inherite`cb_print within w_sal_02260
integer y = 2312
integer taborder = 140
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_02260
end type

type cb_can from w_inherite`cb_can within w_sal_02260
integer x = 3662
integer y = 276
integer taborder = 150
end type

event cb_can::clicked;call super::clicked;
dw_insert.Reset()
dw_salesugum.Reset()
dw_sugum.Reset()

dw_ip.SetFocus()
dw_ip.SetItem(1,'sdatef', left(is_today,6)+'01')
dw_ip.SetItem(1,'sdatet', is_today)
dw_ip.SetColumn('sdatef')
end event

type cb_search from w_inherite`cb_search within w_sal_02260
integer y = 2312
integer taborder = 160
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02260
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02260
end type

type gb_2 from groupbox within w_sal_02260
integer x = 114
integer y = 300
integer width = 4389
integer height = 656
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[계산서내역]"
end type

type gb_1 from groupbox within w_sal_02260
integer x = 114
integer y = 964
integer width = 4389
integer height = 1204
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[수금내역]"
end type

type dw_ip from u_key_enter within w_sal_02260
integer x = 155
integer y = 88
integer width = 2240
integer height = 168
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_022603"
boolean border = false
end type

event itemchanged;call super::itemchanged;String  sDateFrom, sDateTo, snull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[매출기간]')
			SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[매출기간]')
			SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea", 	   sarea)
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
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"sarea", sarea)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF
END Choose
end event

event rbuttondown;call super::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
END Choose

end event

event itemerror;call super::itemerror;return 1
end event

type st_2 from statictext within w_sal_02260
integer x = 160
integer y = 1572
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "미연결 수금내역"
boolean focusrectangle = false
end type

type dw_sugum from u_d_select_sort within w_sal_02260
integer x = 151
integer y = 1636
integer width = 4325
integer height = 508
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sal_022602"
boolean hscrollbar = false
borderstyle borderstyle = stylelowered!
end type

type dw_salesugum from u_d_select_sort within w_sal_02260
integer x = 151
integer y = 1032
integer width = 4325
integer height = 508
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_022601"
boolean hscrollbar = false
borderstyle borderstyle = stylelowered!
end type

type pb_up from picturebutton within w_sal_02260
integer x = 1275
integer y = 1548
integer width = 101
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\UP.BMP"
end type

event clicked;Long nRow
Dec  dMiJan, dSunjan, dAmt
String sSaleDt, sSugumNo
Int    iSaleNo, iSugumSeq

/* 수금정보 */
nRow = dw_sugum.GetSelectedRow(0)
If nRow <= 0 Then Return

sSugumNo  = dw_sugum.GetItemString(nRow, 'sugum_no')
iSugumSeq = dw_sugum.GetItemNumber(nRow, 'sugum_seq')
dSunJan = dw_sugum.GetItemNumber(nRow, 'sunjan')	/* 선수금 잔액 */
If IsNull(dSunJan) Then dSunJan = 0

/* 미수금정보 */
nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return
sSaleDt 	 = dw_insert.GetItemString(nRow, 'saledt')
iSaleNo   = dw_insert.GetItemNumber(nRow, 'saleno')
dmiJan 	 = dw_insert.GetItemNumber(nRow, 'mijan')	/* 미수금 잔액 */
If IsNull(dmiJan) Then dmiJan = 0

SetPointer(HourGlass!)

If dSunJan > dMijan Then
	dAmt = dMijan
Else
	dAmt = dSunJan
End If

/* 저장 */
nRow = dw_salesugum.InsertRow(0)

dw_salesugum.SetItem(nRow, 'sale_sugum_sabu', gs_sabu)
dw_salesugum.SetItem(nRow, 'sale_sugum_saledt', sSaledt)
dw_salesugum.SetItem(nRow, 'sale_sugum_saleno', isaleno)
dw_salesugum.SetItem(nRow, 'sale_sugum_sugum_no', sSugumNo)
dw_salesugum.SetItem(nRow, 'sale_sugum_sugum_seq', isugumseq)
dw_salesugum.SetItem(nRow, 'sale_sugum_ipgum_amt', dAmt)

If dw_salesugum.Update() <> 1 Then
	RollBack;
	MessageBox('확인','계산서/수금 저장시 오류입니다.!!')
	Return
End If


UPDATE SALEH
   SET MIJAN = MIJAN - :dAmt
 WHERE SABU = :gs_sabu AND
       SALEDT = :sSaledt AND
		 SALENO = :iSaleNo;
If sqlca.sqlnrows <= 0 Then
	RollBack;
	MessageBox('확인','계산서 저장시 오류입니다.!!')
	Return
End If

UPDATE SUGUM
   SET SUNJAN = SUNJAN - :dAmt
 WHERE SABU = :gs_sabu AND
       SUGUM_NO = :sSugumNo AND
		 SUGUM_SEQ = :iSugumSeq;
If sqlca.sqlnrows <= 0 Then
	RollBack;
	MessageBox('확인','수금 저장시 오류입니다.!!')
	Return
End If

commit;

cb_inq.TriggerEvent(Clicked!)

sle_msg.Text = '정상적으로 작업을 완료하였습니다.'
end event

event getfocus;sle_msg.text = '수금내역을 계산서와 연결합니다'
end event

type pb_down from picturebutton within w_sal_02260
integer x = 1458
integer y = 1548
integer width = 101
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\DOWN.BMP"
end type

event clicked;Long nRow
Dec  dIpgumAmt
String sSaleDt, sSugumNo
Int    iSaleNo, iSugumSeq

nRow = dw_salesugum.GetSelectedRow(0)
If nRow <= 0 Then Return

sSaleDt 	 = dw_salesugum.GetItemString(nRow, 'sale_sugum_saledt')
iSaleNo   = dw_salesugum.GetItemNumber(nRow, 'sale_sugum_saleno')
sSugumNo  = dw_salesugum.GetItemString(nRow, 'sale_sugum_sugum_no')
iSugumSeq = dw_salesugum.GetItemNumber(nRow, 'sale_sugum_sugum_seq')
dIpgumAmt = dw_salesugum.GetItemNumber(nRow, 'sale_sugum_ipgum_amt')
If IsNull(dIpgumAmt) Then dIpgumAmt = 0

SetPointer(HourGlass!)

/* 삭제 */
UPDATE SALEH
   SET MIJAN = MIJAN + :dIpgumAmt
 WHERE SABU = :gs_sabu AND
       SALEDT = :sSaledt AND
		 SALENO = :iSaleNo;
If sqlca.sqlnrows <= 0 Then
	RollBack;
	MessageBox('확인','계산서 저장시 오류입니다.!!')
	Return
End If

UPDATE SUGUM
   SET SUNJAN = SUNJAN + :dIpgumAmt
 WHERE SABU = :gs_sabu AND
       SUGUM_NO = :sSugumNo AND
		 SUGUM_SEQ = :iSugumSeq;
If sqlca.sqlnrows <= 0 Then
	RollBack;
	MessageBox('확인','수금 저장시 오류입니다.!!')
	Return
End If

dw_salesugum.DeleteRow(nRow)
If dw_salesugum.Update() <> 1 Then
	RollBack;
	MessageBox('확인','계산서/수금 저장시 오류입니다.!!')
	Return
End If

commit;

//dw_insert.SetFocus()
//nRow = dw_insert.GetRow()
//If nRow > 0 Then	wf_retrieve(nRow)

cb_inq.TriggerEvent(Clicked!)


sle_msg.Text = '정상적으로 작업을 완료하였습니다.'
end event

event getfocus;sle_msg.text = '계산서와 연결된 수금내역을 해제합니다'
end event

type pb_1 from u_pb_cal within w_sal_02260
integer x = 837
integer y = 96
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02260
integer x = 1294
integer y = 96
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_3 from roundrectangle within w_sal_02260
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 105
integer y = 56
integer width = 2363
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_sal_02260
long linecolor = 28144969
integer linethickness = 4
integer beginx = 160
integer beginy = 1528
integer endx = 325
integer endy = 1672
end type

