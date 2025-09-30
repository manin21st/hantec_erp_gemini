$PBExportHeader$w_sal_02190.srw
$PBExportComments$특출 거래처 등록
forward
global type w_sal_02190 from w_inherite
end type
type gb_2 from groupbox within w_sal_02190
end type
type dw_detail from datawindow within w_sal_02190
end type
type rb_new from radiobutton within w_sal_02190
end type
type rb_upd from radiobutton within w_sal_02190
end type
type pb_1 from u_pb_cal within w_sal_02190
end type
type rr_1 from roundrectangle within w_sal_02190
end type
end forward

global type w_sal_02190 from w_inherite
string title = "특출 거래처 등록"
gb_2 gb_2
dw_detail dw_detail
rb_new rb_new
rb_upd rb_upd
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_02190 w_sal_02190

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

//dw_detail.SetItem(nRow,"order_no",snull)
dw_detail.SetItem(nRow,"itnbr",snull)
dw_detail.SetItem(nRow,"itdsc",snull)
dw_detail.SetItem(nRow,"ispec",snull)
dw_detail.SetItem(nRow,"ispec_code",snull)
dw_detail.SetItem(nRow,"jijil",snull)
dw_detail.SetItem(nRow,"order_spec",snull)

dw_detail.SetItem(nRow,"dc_rate",        0)
dw_detail.SetItem(nRow,"sales_prc",      0)

dw_detail.SetItem(nRow,"curr",snull)
dw_detail.SetItem(nRow,"start_date",snull)
dw_detail.SetItem(nRow,"end_date",snull)

Return 0
end function

public function integer wf_calc_danga (integer nrow, string itnbr);string sOrderDate, sCvcod, sCurr, sPriceGbn
int    iRtnValue
double ditemprice,ddcrate

If IsNull(itnbr) Or itnbr = '' Then Return 0

/* 판매단가및 할인율 */
sOrderDate = dw_insert.GetItemString(1,"spcvnd_date")
sCvcod     = dw_insert.GetItemString(1,"cvcod")
sCurr      = dw_detail.GetItemString(nRow,'curr')

If sCurr = 'WON' Then
	sPricegbn   = '1'
Else
	sPricegbn   = '2'
End If

iRtnValue = sqlca.Fun_Erp100000010(sOrderDate, sCvcod, Itnbr, '.' ,sCurr,sPriceGbn, dItemPrice,dDcRate) 

Choose Case abs(iRtnValue)
	Case 1
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

s_order_date = Trim(dw_insert.GetItemString(1,'spcvnd_date'))
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

public function integer wf_check_req ();String sSpcVndNo, sCvcod, sCustNo, sItnbr, sStartDate
Long   nRow

IF dw_detail.AcceptText() = -1 THEN RETURN 0
IF dw_insert.AcceptText() = -1 THEN RETURN 0

dw_insert.SetFocus()

sSpcVndNo = dw_insert.GetItemString(1,'spcvnd_no')
If IsNull(sSpcVndNo) Or sSpcVndNo = ''  Then
	f_message_chk(30,'[등록번호]')
	dw_insert.SetColumn('spcvnd_no')
	return -1
End If

sCvcod = dw_insert.GetItemString(1,'cvcod')
If IsNull(sCvcod) Or sCvcod = ''  Then
	f_message_chk(30,'[거래처]')
	dw_insert.SetColumn('cvcod')
	return -1
End If

sCustNo = dw_insert.GetItemString(1,'cust_no')
If IsNull(sCustNo) Or sCustNo = ''  Then
	f_message_chk(30,'[고객번호]')
	dw_insert.SetColumn('cust_no')
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
		dw_insert.Modify('spcvnd_date.protect = 0')
		dw_insert.Modify('spcvnd_no.protect = 0')
		dw_insert.Modify('cvcod.protect = 0')
		dw_insert.Modify('cvnas2.protect = 0')
		dw_insert.Modify('cust_no.protect = 0')
		dw_insert.Modify('cust_name.protect = 0')
	Case '2' //수정
		dw_insert.Modify('spcvnd_date.protect = 0')
		dw_insert.Modify('spcvnd_no.protect = 0')
		dw_insert.Modify('cvcod.protect = 0')
		dw_insert.Modify('cvnas2.protect = 0')
		dw_insert.Modify('cust_no.protect = 0')
		dw_insert.Modify('cust_name.protect = 0')
	Case '3' //조회
		dw_insert.Modify('spcvnd_date.protect = 1')
		dw_insert.Modify('spcvnd_no.protect = 1')
		dw_insert.Modify('cvcod.protect = 1')
		dw_insert.Modify('cvnas2.protect = 1')
		dw_insert.Modify('cust_no.protect = 1')
		dw_insert.Modify('cust_name.protect = 1')
End Choose

Return 0
end function

on w_sal_02190.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.dw_detail=create dw_detail
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.rb_new
this.Control[iCurrent+4]=this.rb_upd
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_02190.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.dw_detail)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.settransobject(sqlca)
dw_detail.settransobject(sqlca)

rb_new.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02190
integer x = 5
integer y = 8
integer width = 1920
integer height = 420
integer taborder = 30
string dataobject = "d_sal_021901"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sIoCust, sNull, sIoCustName, sDate, sSpcvndNo
Long   nCnt

Choose Case GetColumnName()
	/* 등록번호 */
	Case 'spcvnd_no'
		sSpcvndNo = Trim(GetText())
		If IsNull(sSpcvndNo) or sSpcvndNo = '' Then Return
		
		select count(*) into :ncnt 
		  from spcvndh
		 where sabu = :gs_sabu and
		       spcvnd_no = :sSpcvndNo;
		
		If rb_new.Checked = True Then
			If nCnt > 0 Then
				f_message_chk(37,'')
				Return 2
			End If
		Else
			cb_inq.PostEvent(Clicked!)
		End If
	/* 등록일자 */
	Case 'spcvnd_date'
		sDate = Trim(GetText())
		IF sDate ="" OR IsNull(sDate) THEN RETURN
		
		IF f_datechk(sDate) = -1 THEN
			f_message_chk(35,'[등록일자]')
			SetItem(1,"spcvnd_date",snull)
			Return 1
		END IF
	
	/* 거래처 코드 */
	Case 'cvcod'
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"	  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cvnas2",  sIoCustName)
			SetItem(1,"cust_no", sIoCust)
			SetItem(1,"cust_name", sIoCustName)
		END IF
	/* 거래처명 */
	Case "cvnas2"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD"	  INTO :sIoCust
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cvcod",  sIoCust)
			SetItem(1,"cust_no", sIoCust)
			SetItem(1,"cust_name", sIoCustName)
			Return
		END IF
End Choose
end event

event dw_insert::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case 'spcvnd_no'
		Open(w_sal_02190_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"spcvnd_no",gs_code)
		p_inq.TriggerEvent(Clicked!)
	Case "cvcod","cvnas2"
		gs_gubun = '1'
		If GetColumnName() = "cvnas2" then			gs_codename = Trim(GetText())

		Open(w_agent_popup)	
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(1,"cvnas2",  sIoCustName)
			SetItem(1,"cust_no", gs_code)
			SetItem(1,"cust_name", sIoCustName)
		END IF
END Choose

end event

type p_delrow from w_inherite`p_delrow within w_sal_02190
boolean visible = false
integer x = 3694
integer y = 808
end type

type p_addrow from w_inherite`p_addrow within w_sal_02190
boolean visible = false
integer x = 3520
integer y = 808
end type

type p_search from w_inherite`p_search within w_sal_02190
boolean visible = false
integer x = 2825
integer y = 808
end type

type p_ins from w_inherite`p_ins within w_sal_02190
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long    nRow, nSeq
String  sSpcVndNo

If wf_check_req() < 0 Then Return

/* 수주번호 최대값 */
If dw_detail.Rowcount() > 0 Then
  nSeq = dw_detail.GetItemNumber(1,'maxseq')
  If IsNull(nSeq) or nSeq < 0 Then nSeq = 0   
End If
nSeq += 1

nRow = dw_detail.InsertRow(0)

sSpcVndNo = dw_insert.GetItemString(1,'spcvnd_no')
If IsNull(sSpcVndNo) or sSpcVndNo = '' Then Return

dw_detail.SetFocus()
dw_detail.SetItem(nRow,'sabu', gs_sabu)
dw_detail.SetItem(nRow,'spcvnd_no', sSpcVndNo)
dw_detail.SetItem(nRow,'curr', 'WON')
dw_detail.SetItem(nRow,'spcvnd_seq', nSeq)

dw_detail.SetRow(nRow)
dw_detail.SetColumn('itnbr')

wf_protect('3')
end event

type p_exit from w_inherite`p_exit within w_sal_02190
end type

type p_can from w_inherite`p_can within w_sal_02190
end type

event p_can::clicked;call super::clicked;rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_02190
boolean visible = false
integer x = 2999
integer y = 808
end type

type p_inq from w_inherite`p_inq within w_sal_02190
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sSpcVndNo

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return

sSpcVndNo = dw_insert.GetItemString(1,'spcvnd_no')
IF sSpcVndNo ="" OR IsNull(sSpcVndNo) THEN
	f_message_chk(30,'[등록번호]')
	dw_insert.SetColumn("spcvnd_no")
	dw_insert.SetFocus()
	Return 
END IF

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu, sSpcVndNo) <= 0 Then
	f_message_chk(50,'')
	p_can.TriggerEvent(Clicked!)
	dw_insert.SetRedraw(True)
	Return
End If

dw_insert.SetRedraw(True)

dw_detail.Retrieve(gs_sabu, sSpcVndNo)

wf_protect('3')
end event

type p_del from w_inherite`p_del within w_sal_02190
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

type p_mod from w_inherite`p_mod within w_sal_02190
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
	If f_datechk(sStartDate) <> 1 Then
		dw_detail.DeleteRow(ix)
		Continue
	End If
Next

/* 사업장, 순번 */
For ix = 1 To dw_detail.RowCount()
	dw_detail.SetItem(ix,'sabu', gs_sabu)
	dw_detail.SetItem(ix,'spcvnd_seq', ix)
	
	sOrderSpec = dw_detail.GetItemString(ix,'order_spec')
	If IsNull(sOrderSpec) or sOrderSpec = '' Then
		dw_detail.SetItem(ix,'order_spec', '.')
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

type cb_exit from w_inherite`cb_exit within w_sal_02190
integer x = 3506
integer y = 996
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_sal_02190
integer x = 2789
integer y = 1160
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_sal_02190
integer x = 2642
integer y = 1032
integer width = 361
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02190
integer x = 3200
integer y = 1152
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_02190
integer x = 3040
integer y = 1028
integer taborder = 10
end type

event cb_inq::clicked;call super::clicked;String sSpcVndNo

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return

sSpcVndNo = dw_insert.GetItemString(1,'spcvnd_no')
IF sSpcVndNo ="" OR IsNull(sSpcVndNo) THEN
	f_message_chk(30,'[등록번호]')
	dw_insert.SetColumn("spcvnd_no")
	dw_insert.SetFocus()
	Return 
END IF

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu, sSpcVndNo) <= 0 Then
	f_message_chk(50,'')
	p_can.TriggerEvent(Clicked!)
	dw_insert.SetRedraw(True)
	Return
End If

dw_insert.SetRedraw(True)

dw_detail.Retrieve(gs_sabu, sSpcVndNo)

wf_protect('3')
end event

type cb_print from w_inherite`cb_print within w_sal_02190
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02190
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02190
integer x = 3570
integer y = 1148
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_02190
integer x = 1486
integer y = 2420
integer width = 462
boolean enabled = false
string text = "전체삭제(&W)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_02190
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02190
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02190
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02190
end type

type gb_2 from groupbox within w_sal_02190
integer x = 1938
integer y = 4
integer width = 389
integer height = 236
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[작업구분]"
end type

type dw_detail from datawindow within w_sal_02190
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_1"
integer x = 27
integer y = 452
integer width = 4576
integer height = 1852
string dataobject = "d_sal_021902"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sItnbr, sItdsc, sIspec, sItnbrGbn,lsItnbrYn, sOrderDate, sNull, sIspecCode, sJijil
Long   nRow, iRtnValue, ireturn
Double dItemPrice, dNewDcRate

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
		
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)

		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
		
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)

		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
		
		RETURN ireturn
	/* 재질 */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)

		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
		
		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)

		/* 판매단가및 할인율 */
		Post wf_calc_danga(nRow,sItnbr)
		
		RETURN ireturn
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

type rb_new from radiobutton within w_sal_02190
integer x = 2007
integer y = 68
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_detail.Reset()

dw_insert.InsertRow(0)

dw_insert.SetItem(1,'spcvnd_date',is_today)
dw_insert.SetFocus()
dw_insert.SetColumn('spcvnd_no')

wf_protect('1')

p_del.Enabled = True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

dw_insert.SetRedraw(True)

ib_any_typing = false
end event

type rb_upd from radiobutton within w_sal_02190
integer x = 2007
integer y = 148
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "수정"
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_detail.Reset()

dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.SetColumn('spcvnd_no')

wf_protect('2')

p_del.Enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

dw_insert.SetRedraw(True)


ib_any_typing = false
end event

type pb_1 from u_pb_cal within w_sal_02190
integer x = 1554
integer y = 28
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('spcvnd_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'spcvnd_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02190
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 436
integer width = 4626
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

