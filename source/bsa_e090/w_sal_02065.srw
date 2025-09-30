$PBExportHeader$w_sal_02065.srw
$PBExportComments$이벤트 제품 할인율 등록
forward
global type w_sal_02065 from w_inherite
end type
type gb_2 from groupbox within w_sal_02065
end type
type dw_detail from datawindow within w_sal_02065
end type
type rb_new from radiobutton within w_sal_02065
end type
type rb_upd from radiobutton within w_sal_02065
end type
type rr_1 from roundrectangle within w_sal_02065
end type
end forward

global type w_sal_02065 from w_inherite
string title = "이벤트 제품 할인율 등록"
gb_2 gb_2
dw_detail dw_detail
rb_new rb_new
rb_upd rb_upd
rr_1 rr_1
end type
global w_sal_02065 w_sal_02065

type variables

end variables

forward prototypes
public function integer wf_clear_item (integer nrow)
public function integer wf_calc_danga (integer nrow, string itnbr)
public function integer wf_catch_special_danga (integer nrow, ref double order_prc, ref double order_rate, string gbn)
public function integer wf_check_req ()
public function integer wf_protect (string gb)
end prototypes

public function integer wf_clear_item (integer nrow);String sNull

SetNull(snull)

dw_detail.SetItem(nRow,"itnbr",snull)
dw_detail.SetItem(nRow,"itdsc",snull)
dw_detail.SetItem(nRow,"ispec",snull)
dw_detail.SetItem(nRow,"jijil",snull)
dw_detail.SetItem(nRow,"ispec_code",snull)

dw_detail.SetItem(nRow,"dc_rate",        0)
dw_detail.SetItem(nRow,"sales_prc",      0)

dw_detail.SetItem(nRow,"curr",snull)
dw_detail.SetItem(nRow,"start_date",snull)
dw_detail.SetItem(nRow,"end_date",snull)

Return 0
end function

public function integer wf_calc_danga (integer nrow, string itnbr);string sOrderDate, sCurr, sPriceGbn
int    iRtnValue
double ditemprice,ddcrate

/* 판매단가및 할인율 */
sOrderDate = is_today
sCurr      = dw_detail.GetItemString(nRow,'curr')

If sCurr = 'WON' Then
	sPricegbn   = '1'
Else
	sPricegbn   = '2'
End If

iRtnValue = sqlca.Fun_Erp100000011(sOrderDate, Itnbr, '.' , sCurr, sPriceGbn, dItemPrice,dDcRate) 

Choose Case abs(iRtnValue)
	Case is > 0
		dw_detail.SetItem(nRow,"dc_rate",	dDcRate)
		dw_detail.SetItem(nRow,"sales_prc",	Truncate(dItemPrice,2))
	Case Else
		dDcRate = 0.0
		dItemPrice = 0
		dw_detail.SetItem(nRow,"dc_rate",0)
		dw_detail.SetItem(nRow,"sales_prc",0)
End Choose

Return 0

end function

public function integer wf_catch_special_danga (integer nrow, ref double order_prc, ref double order_rate, string gbn);/* ----------------------------------------------------- */
/* 특출일 경우 할인율과 단가 계산                        */
/* ----------------------------------------------------- */
string s_order_date,s_itnbr,s_ispec,s_curr,s_pricegbn
Long   irow,rtn

iRow = dw_detail.GetRow()
If iRow <=0 Then Return 2

s_order_date = f_today()
s_itnbr      = Trim(dw_detail.GetItemString(nRow,'itnbr'))
s_ispec      = Trim(dw_detail.GetItemString(nRow,'ispec'))
s_curr       = Trim(dw_detail.GetItemString(nRow,'curr'))

If s_curr = 'WON' Then
	s_pricegbn   = '1'
Else
	s_pricegbn   = '2'
End If

If IsNull(s_order_date) Or s_order_date = '' Then
   f_message_chk(40,'[등록일자]')
   Return -1
End If

If IsNull(s_itnbr) Or s_itnbr = '' Then
   f_message_chk(40,'[품번]')
   Return -1
End If

If IsNull(s_curr) Or s_curr = '' Then
   f_message_chk(40,'[통화단위]')
   Return -1
End If

If gbn = '1' Then
	/* 단가 입력시 할인율 계산 */
   rtn = sqlca.fun_erp100000014(s_itnbr, '.' ,order_prc,s_order_date,s_curr,s_pricegbn,order_rate)
   If rtn = -1 Then order_rate = 0
Else
	/* 할인율 입력시 단가계산 */
   rtn = sqlca.fun_erp100000015(s_itnbr, '.' ,s_order_date,s_curr,s_pricegbn,order_rate,order_prc)
   If rtn = -1 Then 	order_prc = 0
	
	order_prc = truncate(order_prc,0)
End If

/* 할증된 경우 할인율은 0 (ETC품목 적용)*/
If order_rate < 0 Then order_rate = 0

return 1
end function

public function integer wf_check_req ();String sEventNo, sCvcod, sCustNo, sItnbr, sStartDate
Long   nRow

IF dw_detail.AcceptText() = -1 THEN RETURN 0
IF dw_insert.AcceptText() = -1 THEN RETURN 0

dw_insert.SetFocus()

sEventNo = dw_insert.GetItemString(1,'event_no')
If IsNull(sEventNo) Or sEventNo = ''  Then
	f_message_chk(30,'[등록번호]')
	dw_insert.SetColumn('event_no')
	return -1
End If

dw_detail.SetFocus()
nRow = dw_detail.RowCount()
If nRow > 0 Then
	sItnbr = dw_detail.GetItemString(nRow,'itnbr')
	
	If IsNull(sItnbr) Or sItnbr = ''  Then
		f_message_chk(30,'[품번]')
		dw_detail.ScrollToRow(nRow)
		dw_detail.SetColumn('itnbr')
		return -1
	End If

	sStartDate = dw_detail.GetItemString(nRow,'start_date')
	
	If f_datechk(sStartDate) <> 1   Then
		f_message_chk(30,'[적용시작일]')
		dw_detail.ScrollToRow(nRow)
		dw_detail.SetColumn('start_date')
		return -1
	End If
End If

Return 0
end function

public function integer wf_protect (string gb);/* Protect */

Choose Case gb
	Case '1' //등록
		dw_insert.Modify('event_year.protect = 0')
//		dw_insert.Modify("event_year.background.color = '" + string(Rgb(195,225,184)) + "'") 		
		dw_insert.Modify('event_no.protect = 0')
//		dw_insert.Modify("event_no.background.color = '" + string(Rgb(195,225,184)) + "'") 
		dw_insert.Modify('salegu.protect = 0')
//    dw_insert.Modify("salegu.background.color = '"+String(Rgb(195,225,184))+"'")		
	Case '2' //수정
		dw_insert.Modify('event_year.protect = 0')
//		dw_insert.Modify("event_year.background.color = '" + string(Rgb(195,225,184)) + "'") 
		dw_insert.Modify('event_no.protect = 0')
//		dw_insert.Modify("event_no.background.color = '" + string(Rgb(255,255,0)) + "'") 
		dw_insert.Modify('salegu.protect = 0')
//		dw_insert.Modify("salegu.background.color '" + string(Rgb(195,225,184)) + "'") 
	Case '3' //조회
		dw_insert.Modify('event_year.protect = 1')
//		dw_insert.Modify("event_year.background.color = 80859087") 
		dw_insert.Modify('event_no.protect = 1')
//		dw_insert.Modify("event_no.background.color = 80859087") 
		dw_insert.Modify('salegu.protect = 1')
//		dw_insert.Modify("salegu.background.color = 80859087") 
End Choose

Return 0
end function

on w_sal_02065.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.dw_detail=create dw_detail
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.rb_new
this.Control[iCurrent+4]=this.rb_upd
this.Control[iCurrent+5]=this.rr_1
end on

on w_sal_02065.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.dw_detail)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_detail.settransobject(sqlca)

rb_new.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02065
integer x = 0
integer y = 0
integer width = 2528
integer height = 280
integer taborder = 30
string dataobject = "d_sal_020651"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sEventNo
Long   nCnt

Choose Case GetColumnName()
	/* 등록번호 */
	Case 'event_no'
		sEventNo = Trim(GetText())
		If IsNull(sEventNo) or sEventNo = '' Then Return
		
		select count(*) into :ncnt 
		  from seventh
		 where sabu = :gs_sabu and
		       event_no = :sEventNo;
		
		If rb_new.Checked = True Then
			If nCnt > 0 Then
				f_message_chk(37,'')
				Return 2
			End If
		Else
			cb_inq.PostEvent(Clicked!)
		End If
End Choose
end event

event dw_insert::rbuttondown;String sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case 'event_no'
		Open(w_sal_02065_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"event_no",gs_code)
		p_inq.TriggerEvent(Clicked!)
END Choose

end event

type p_delrow from w_inherite`p_delrow within w_sal_02065
boolean visible = false
integer x = 2999
integer y = 924
end type

type p_addrow from w_inherite`p_addrow within w_sal_02065
boolean visible = false
integer x = 2825
integer y = 924
end type

type p_search from w_inherite`p_search within w_sal_02065
boolean visible = false
integer x = 3177
integer y = 932
end type

type p_ins from w_inherite`p_ins within w_sal_02065
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long    nRow, nSeq
String  sEventNo, sSaleGu

If wf_check_req() < 0 Then Return

nRow = dw_detail.InsertRow(0)

sEventNo = Trim(dw_insert.GetItemString(1,'event_no'))
If IsNull(sEventNo) or sEventNo = '' Then Return

dw_detail.SetFocus()
dw_detail.SetItem(nRow,'sabu', gs_sabu)
dw_detail.SetItem(nRow,'event_no', sEventNo)

sSalegu = dw_insert.GetItemString(1,'salegu')
If sSalegu = '1' Then
	dw_detail.SetItem(nRow,'curr', 'WON')
Else
	dw_detail.SetItem(nRow,'curr', 'USD')
End If

dw_detail.SetRow(nRow)
dw_detail.SetColumn('itnbr')

wf_protect('3')

end event

type p_exit from w_inherite`p_exit within w_sal_02065
end type

type p_can from w_inherite`p_can within w_sal_02065
end type

event p_can::clicked;call super::clicked;rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_02065
boolean visible = false
integer x = 2647
integer y = 924
end type

type p_inq from w_inherite`p_inq within w_sal_02065
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sEventNo

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return

sEventNo = dw_insert.GetItemString(1,'event_no')
IF sEventNo ="" OR IsNull(sEventNo) THEN
	f_message_chk(30,'[이벤트번호]')
	dw_insert.SetColumn("event_no")
	dw_insert.SetFocus()
	Return 
END IF

If dw_insert.Retrieve(gs_sabu, sEventNo) <= 0 Then
	f_message_chk(50,'')
	Return
End If

dw_detail.Retrieve(gs_sabu, sEventNo)

wf_protect('3')

end event

type p_del from w_inherite`p_del within w_sal_02065
end type

event p_del::clicked;call super::clicked;long nRow

If dw_detail.accepttext() <> 1 Then Return

nRow = dw_detail.getrow()

IF nRow <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
	dw_detail.deleterow(nRow)
	
	if dw_detail.update() = 1 then
		commit ;
		w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!!"
	else 
		rollback;
	end if		
end if
end event

type p_mod from w_inherite`p_mod within w_sal_02065
end type

event p_mod::clicked;call super::clicked;Long   nCnt, ix
String sItnbr, sStartDate, sOrderSpec

If wf_check_req() < 0 Then Return

If rb_new.Checked = True Then
	dw_insert.SetItem(1,'sabu', gs_sabu)
End If

/* 품번및 적용시작일이 없으면 삭제 */
nCnt = dw_detail.RowCount()
For ix = nCnt To 1 Step -1
	sItnbr = Trim(dw_detail.GetItemString(ix,'itnbr'))
	If IsNull(sItnbr) or sItnbr = '' Then
		dw_detail.DeleteRow(ix)
		Continue
	End If
	
	sStartDate = Trim(dw_detail.GetItemString(ix,'start_date'))
	If f_datechk(sStartDate) <> 1 and IsNull(sStartDate) Then
		dw_detail.DeleteRow(ix)
		Continue
	End If
Next

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'header')
	Return
End If

If dw_detail.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'detail')
	Return
End If

commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_sal_02065
boolean visible = false
integer x = 3113
integer y = 1012
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_sal_02065
boolean visible = false
integer x = 3570
integer y = 948
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;Long   nCnt, ix
String sItnbr, sStartDate, sOrderSpec

If wf_check_req() < 0 Then Return

If rb_new.Checked = True Then
	dw_insert.SetItem(1,'sabu', gs_sabu)
End If

/* 품번및 적용시작일이 없으면 삭제 */
nCnt = dw_detail.RowCount()
For ix = nCnt To 1 Step -1
	sItnbr = Trim(dw_detail.GetItemString(ix,'itnbr'))
	If IsNull(sItnbr) or sItnbr = '' Then
		dw_detail.DeleteRow(ix)
		Continue
	End If
	
	sStartDate = Trim(dw_detail.GetItemString(ix,'start_date'))
	If f_datechk(sStartDate) <> 1 and IsNull(sStartDate) Then
		dw_detail.DeleteRow(ix)
		Continue
	End If
Next

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'header')
	Return
End If

If dw_detail.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'detail')
	Return
End If

commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_02065
boolean visible = false
integer x = 3109
integer y = 760
integer width = 361
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Long    nRow, nSeq
String  sEventNo, sSaleGu

If wf_check_req() < 0 Then Return

nRow = dw_detail.InsertRow(0)

sEventNo = Trim(dw_insert.GetItemString(1,'event_no'))
If IsNull(sEventNo) or sEventNo = '' Then Return

dw_detail.SetFocus()
dw_detail.SetItem(nRow,'sabu', gs_sabu)
dw_detail.SetItem(nRow,'event_no', sEventNo)

sSalegu = dw_insert.GetItemString(1,'salegu')
If sSalegu = '1' Then
	dw_detail.SetItem(nRow,'curr', 'WON')
Else
	dw_detail.SetItem(nRow,'curr', 'USD')
End If

dw_detail.SetRow(nRow)
dw_detail.SetColumn('itnbr')

wf_protect('3')

end event

type cb_del from w_inherite`cb_del within w_sal_02065
boolean visible = false
integer x = 3552
integer y = 1032
integer taborder = 70
end type

event cb_del::clicked;call super::clicked;long nRow

If dw_detail.accepttext() <> 1 Then Return

nRow = dw_detail.getrow()

IF nRow <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
	dw_detail.deleterow(nRow)
	
	if dw_detail.update() = 1 then
		commit ;
		w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!!"
	else 
		rollback;
	end if		
end if
end event

type cb_inq from w_inherite`cb_inq within w_sal_02065
boolean visible = false
integer x = 2720
integer y = 868
integer taborder = 10
end type

event cb_inq::clicked;call super::clicked;String sEventNo

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return

sEventNo = dw_insert.GetItemString(1,'event_no')
IF sEventNo ="" OR IsNull(sEventNo) THEN
	f_message_chk(30,'[이벤트번호]')
	dw_insert.SetColumn("event_no")
	dw_insert.SetFocus()
	Return 
END IF

If dw_insert.Retrieve(gs_sabu, sEventNo) <= 0 Then
	f_message_chk(50,'')
	Return
End If

dw_detail.Retrieve(gs_sabu, sEventNo)

wf_protect('3')

end event

type cb_print from w_inherite`cb_print within w_sal_02065
boolean visible = false
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02065
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02065
boolean visible = false
integer x = 3570
integer y = 1104
integer taborder = 80
end type

event cb_can::clicked;call super::clicked;rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type cb_search from w_inherite`cb_search within w_sal_02065
boolean visible = false
integer x = 3045
integer y = 896
integer width = 462
string text = "전체삭제(&W)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_02065
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02065
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02065
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02065
end type

type gb_2 from groupbox within w_sal_02065
integer x = 2574
integer width = 494
integer height = 252
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[작업구분]"
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_sal_02065
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_1"
integer x = 46
integer y = 308
integer width = 4553
integer height = 2012
string dataobject = "d_sal_02065"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sItnbr, sItdsc, sIspec, sItnbrGbn,lsItnbrYn, sOrderDate, sNull, sIspecCode, sJijil
Long   nRow, iRtnValue, nFind
Double dItemPrice, dNewDcRate

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"itnbr" 
		sItnbr = Trim(this.GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			Wf_Clear_Item(nRow)
			Return
		END IF
		
		/* 동일한 품번을 입력할 경우 */
		nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
		If nFind > 0 AND nFind <> nRow Then
			f_message_chk(49,'')
			ScrollToRow(nFind)
			Wf_Clear_Item(nRow)
			Return 2
		End If
	
		SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",    "ITEMAS"."ITTYP", "ITEMAS"."ISPEC_CODE", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		   :sIspec, 		      :sItnbrGbn, :sIspecCode, :sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		END IF

		/* 입력가능여부 */
		SELECT DECODE(RFNA2,'N',RFNA2,'Y') INTO :lsItnbrYn
		  FROM REFFPF  
		 WHERE RFCOD = '05' AND     RFGUB <> '00' AND
		       RFGUB = :sItnbrGbn;
		
		If IsNull(lsItnbrYn) Then sItnbr = 'Y'
		
		If lsItnbrYn = 'N' Then
			f_message_chk(58,'')
			Wf_Clear_Item(nRow)
			Return 1
		End If
		
		SetItem(nRow,"itdsc",   sItDsc)
		SetItem(nRow,"ispec",   sIspec)
		SetItem(nRow,"ispec_code", sIspecCode)
		SetItem(nRow,"jijil",   sJijil)
		
		/* 판매단가및 할인율 */
		iRtnValue = wf_calc_danga(nRow,sItnbr)
		If iRtnValue =  1 Then Return 1
				
		SetColumn('sales_prc')
	/* 품명 */
	Case "itdsc"
		sItDsc = trim(this.GetText())	
		IF sItDsc = ""	or	IsNull(sItDsc)	THEN
			Wf_Clear_Item(nRow)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("itdsc")
			Return 1
		End If
		
		SetColumn('order_prc')
	/* 규격 */
	Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec")
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec")
			Return 1
		End If
		
		SetColumn('order_prc')

	/* 재질 */
	Case "jijil"
		sJijil = trim(this.GetText())	
		IF sJijil = ""	or	IsNull(sJijil)	THEN
			Wf_Clear_Item(nRow)
			this.SetColumn("jijil")
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("jijil")
			Return 1
		End If
		
		SetColumn('order_prc')
	/* 규격코드 */
	Case "ispec_code"
		sIspeccode = trim(this.GetText())	
		IF sIspeccode = ""	or	IsNull(sIspeccode)	THEN
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec_code")
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec_code")
			Return 1
		End If
		
		SetColumn('order_prc')
	/* 단가 */
	Case "sales_prc"
		dItemPrice = Double(this.GetText())
		If IsNull(dItemPrice) Then dItemPrice = 0
		
		/* 특출 할인율 계산 */
		dNewDcRate = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'1') <> 1 Then Return 2
		SetItem(nRow,"dc_rate",dNewDcRate)
		
	/* 할인율 */
	Case "dc_rate"
		dNewDcRate = Double(GetText())
		If IsNull(dNewDcRate) Then dNewDcRate = 0
		
		/* 특출 할인율 계산 */
		dItemPrice = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'2') <> 1 Then Return 2
		SetItem(nRow,"sales_prc",dItemPrice)
	/* 통화단위 */
	Case 'curr'
		sItnbr = GetItemString(nRow, 'itnbr')
		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
	/* 적용시작일 */
	Case "start_date"
		sOrderDate = Trim(this.GetText())
		IF sOrderDate = "" OR IsNull(sOrderDate) THEN Return
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[적용시작일]')
			this.SetItem(nRow,"start_date",snull)
			Return 1
		END IF
	/* 적용마감일 */
	Case "end_date"
		sOrderDate = Trim(this.GetText())
		IF sOrderDate = "" OR IsNull(sOrderDate) THEN Return
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[적용미김일]')
			this.SetItem(nRow,"end_date",snull)
			Return 1
		END IF
END Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = this.GetText()
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "ispec"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose

end event

type rb_new from radiobutton within w_sal_02065
integer x = 2647
integer y = 64
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_detail.Reset()

dw_insert.InsertRow(0)

dw_insert.SetItem(1,'event_year',left(is_today,4))
dw_insert.SetItem(1,'salegu','1')

wf_protect('1')

dw_insert.SetFocus()
dw_insert.SetColumn('event_year')

//p_del.Enabled = True
//p_del.picture = "c:\erpman\image\삭제_up.gif"

dw_insert.SetRedraw(True)

ib_any_typing = false
end event

type rb_upd from radiobutton within w_sal_02065
integer x = 2647
integer y = 140
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_detail.Reset()

dw_insert.InsertRow(0)

wf_protect('2')

dw_insert.SetFocus()
dw_insert.SetColumn('event_no')

//p_del.Enabled = False
//p_del.PictureName = "c:\erpman\image\삭제_dn.gif"

dw_insert.SetRedraw(True)

ib_any_typing = false
end event

type rr_1 from roundrectangle within w_sal_02065
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 280
integer width = 4622
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

