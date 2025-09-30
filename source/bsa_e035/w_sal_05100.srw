$PBExportHeader$w_sal_05100.srw
$PBExportComments$출고단가 일괄변경
forward
global type w_sal_05100 from w_inherite
end type
type cbx_1 from checkbox within w_sal_05100
end type
type rr_1 from roundrectangle within w_sal_05100
end type
type dw_list from u_d_select_sort within w_sal_05100
end type
type rb_3 from radiobutton within w_sal_05100
end type
type rb_4 from radiobutton within w_sal_05100
end type
type rb_5 from radiobutton within w_sal_05100
end type
type pb_1 from u_pb_cal within w_sal_05100
end type
type pb_2 from u_pb_cal within w_sal_05100
end type
type pb_3 from u_pb_cal within w_sal_05100
end type
type cb_1 from commandbutton within w_sal_05100
end type
type gb_2 from groupbox within w_sal_05100
end type
end forward

global type w_sal_05100 from w_inherite
string title = "거래처 출고단가 일괄변경"
cbx_1 cbx_1
rr_1 rr_1
dw_list dw_list
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
cb_1 cb_1
gb_2 gb_2
end type
global w_sal_05100 w_sal_05100

forward prototypes
public function integer wf_set_iojpno (string arg_iojpno)
public function integer wf_change_danga (string ar_prtgbn, long ar_ix, string ar_date, string ar_curr)
end prototypes

public function integer wf_set_iojpno (string arg_iojpno);String sIojpno, sItnbr, sItdsc, sIspec
String sCvcod, sCvnas2, sArea, sSteamCd, sIoDate
Double dIoPrc

select x.io_date, x.iojpno, x.itnbr, y.itdsc, y.ispec, x.ioprc, x.cvcod, v.cvnas2, v.sarea, a.steamcd
  into :sIoDate, :sIojpno , :sItnbr ,:sitdsc, :sispec , :dIoPrc,:sCvcod, :sCvnas2, :sArea, :sSteamCd
  from imhist x, itemas y, vndmst v, sarea a
 where x.cvcod = v.cvcod and
       v.sarea = a.sarea and
       x.itnbr = y.itnbr and
       x.sabu = :gs_sabu and
		 x.iojpno = :arg_iojpno;

If sqlca.sqlcode = 0 Then
	dw_insert.SetItem(1,'iojpno',  left(sIojpno,12))
	dw_insert.SetItem(1,'sdatef',  sIoDate)
	dw_insert.SetItem(1,'sdatet',  sIoDate)
	dw_insert.SetItem(1,'itnbr',   sItnbr)
	dw_insert.SetItem(1,'itdsc',   sItdsc)
	dw_insert.SetItem(1,'ispec',   sIspec)
	dw_insert.SetItem(1,'ioprc',   dIoPrc)
	dw_insert.SetItem(1,'steamcd', sSteamCd)
	dw_insert.SetItem(1,'sarea',   sArea)
	dw_insert.SetItem(1,'cvcod',   sCvcod)
	dw_insert.SetItem(1,'cvcodnm', sCvnas2)
End If

Return 0
end function

public function integer wf_change_danga (string ar_prtgbn, long ar_ix, string ar_date, string ar_curr);string sDatef,sDatet,sYymm,sIojpno,sItnbr,sSteamCd,sSArea,sCvcod, sToday, sSaupj, sPc, sGbn
Long   nCnt
string sOrderSpec, ls_column
Decimal dWeight
double ditemprice,ddcrate, dItemQty, ld_rate, ld_for_unit_price, ld_usrate

sCvcod 	  			= dw_list.GetItemString(ar_ix, "cvcod")
sOrderSpec 			= dw_list.GetItemString(ar_ix, "order_spec")
sItnbr	  			= dw_list.GetItemString(ar_ix, "itnbr")
dItemQty	  			= dw_list.GetItemNumber(ar_ix, "ioqty")
ld_for_unit_price = dw_list.GetItemnumber(ar_ix, "dyebi2") //외화단가
ld_rate    			= dw_list.GetItemnumber(ar_ix, "dyebi1")

If ar_curr = 'WON' Then
	sGbn = '1'
Else
	sGbn = '2'
End If

// 가중치
SELECT TO_NUMBER(RFNA2) INTO :dWeight FROM REFFPF WHERE RFCOD = '10' AND RFGUB = :ar_curr;
If IsNull(dWeight) Or dWeight <= 0 Then dWeight = 1

// 단가만 변경하는 경우
If ar_Prtgbn = '1' Then
	sqlca.Fun_Erp100000016(gs_sabu,  ar_date, sCvcod, sItnbr, sOrderSpec, ar_curr, sGbn, ld_for_unit_price, dDcRate)
	If IsNull(dItemPrice) Then dItemPrice = 0
	If IsNull(dDcRate) Then dDcRate = 0
	
	// 원화,미화 환율
	If ar_curr = 'WON' Then
		SELECT 1 , RSTAN
		  into :ld_rate, :ld_usrate
		 FROM RATEMT 
		WHERE RDATE = :ar_date 
		  and rcurr = 'USD';
	Else
		SELECT RSTAN , USDRAT
		  into :ld_rate, :ld_usrate
		 FROM RATEMT 
		WHERE RDATE = :ar_date 
		  and rcurr = :ar_curr; 
	End If
	
	if ld_rate = 0 or isnull(ld_rate) then		ld_rate = 1
	if ld_usrate = 0 or isnull(ld_usrate) then ld_usrate = 1
	
	/* 외화단가 및 원화단가 계산 */
	ld_for_unit_price = TrunCate(ld_for_unit_price,5)
	dItemPrice  = ld_for_unit_price * ld_rate / dWeight
End If

// 환율 변경하는 경우
If ar_Prtgbn = '3' Then
	if ar_curr = 'WON' then 
		SELECT 1 , RSTAN
		  into :ld_rate, :ld_usrate
		 FROM RATEMT 
		WHERE RDATE = :ar_date 
		  and rcurr = 'USD';
	else
		SELECT RSTAN , USDRAT
		  into :ld_rate, :ld_usrate
		 FROM RATEMT 
		WHERE RDATE = :ar_date 
		  and rcurr = :ar_curr; 
	End if 

	if ld_rate = 0 or isnull(ld_rate) then		ld_rate = 1
	if ld_usrate = 0 or isnull(ld_usrate) then ld_usrate = 1
	
	ld_for_unit_price = round(ld_for_unit_price,5)
	dItemPrice  = round(ld_for_unit_price * ld_rate / dWeight,5)
End If

// PO별 변경하는 경우
If ar_Prtgbn = '4' Then
	ld_rate    = dw_list.GetItemnumber(ar_ix, "wrate")
	ld_usrate  = dw_list.GetItemnumber(ar_ix, "urate")
	dWeight    = dw_list.GetItemnumber(ar_ix, "weight")
	
	if ld_rate = 0 or isnull(ld_rate) then		ld_rate = 1
	if ld_usrate = 0 or isnull(ld_usrate) then ld_usrate = 1
	if dWeight = 0 or isnull(dWeight) then dWeight = 1
	
	ld_for_unit_price = round(ld_for_unit_price,5)
	dItemPrice  = round(ld_for_unit_price * ld_rate / dWeight,5)
End If

/* 금액 계산 */	
dw_list.SetItem(ar_ix,"vioprc",   dItemPrice)
dw_list.SetItem(ar_ix,"vdyebi2",  ld_for_unit_price)
dw_list.SetItem(ar_ix,"vioamt",   round(dItemQty * dItemPrice,0))
dw_list.SetItem(ar_ix,"exch_rate",ld_rate)
dw_list.SetItem(ar_ix,"vdyebi2",  ld_for_unit_price)
dw_list.SetItem(ar_ix,"vyebi2",   ar_curr)
dw_list.SetItem(ar_ix,"exch_rate",ld_rate)

// 부가세 계산
if dw_list.object.lclgbn[ar_ix] = 'L' then 
	dw_list.SetItem(ar_ix,"vvatamt",0)
else
	dw_list.SetItem(ar_ix,"vvatamt",TrunCate(dw_list.GetItemNumber(ar_ix, 'vioamt') *0.1,0))
end if

// 외화금액,미화금액
dw_list.SetItem(ar_ix,"imhist_foramt",  ld_for_unit_price * dItemQty)
If ar_curr = 'WON' Then
	dw_list.SetItem(ar_ix,"imhist_foruamt", (ld_for_unit_price * dItemQty) / ld_usrate)
Else
	dw_list.SetItem(ar_ix,"imhist_foruamt", ld_for_unit_price * dItemQty * ld_usrate)
End If

Return 0

end function

on w_sal_05100.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.dw_list=create dw_list
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.cb_1=create cb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rb_5
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_3
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_sal_05100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.dw_list)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.cb_1)
destroy(this.gb_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String  ls_date, ls_curr
DECIMAL ld_rate
Int     ll_i = 1
dw_list.SetTransObject(sqlca)

//DataWindowChild state_child
integer rtncode
  
//영업팀
f_child_saupj(dw_insert, 'steamcd', gs_saupj)
f_child_saupj(dw_insert, 'sarea', gs_saupj)

dw_insert.SetTransObject(sqlca)
dw_insert.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_insert.Modify("sarea.protect=1")
	dw_insert.Modify("steamcd.protect=1")
End If

dw_insert.SetItem(1, 'sarea', sarea)
dw_insert.SetItem(1, 'steamcd', steam)
	
p_can.TriggerEvent(Clicked!)
 

/* 부가 사업장 */
f_mod_saupj  (dw_insert, 'saupj')

// 초기화면에서 해당일자로 환율 셋팅
//if dw_insert.object.prtgbn[1] = '3' then 
//	
//	ls_date = f_today()
//	dw_insert.object.edate[1] = ls_date
//	
//	DECLARE EXCH_R  CURSOR FOR  
//	SELECT RCURR, RSTAN 
//	 FROM RATEMT
//   WHERE RDATE = :ls_date 
//	ORDER BY DECODE ( RCURR, 'USD', '1', 'JPY', '2' , '3' );
//
//	OPEN EXCH_R;
//	
//	DO WHILE true
//		FETCH EXCH_R INTO :ls_curr, :ld_rate;
//		IF SQLCA.SQLCODE <> 0 THEN EXIT
//		
//		if ll_i = 1 then
//			dw_insert.object.exch_rate_t.text = ls_curr + ' 환율'
//			dw_insert.object.exch_rate[1] = ld_rate
//			dw_insert.object.exch_rate_t.visible = true 
//			dw_insert.object.exch_rate.visible = true 
//			dw_insert.object.exch_rate_t1.visible = false 
//			dw_insert.object.exch_rate1.visible = false 
//			dw_insert.object.exch_rate_t2.visible = false 
//			dw_insert.object.exch_rate2.visible = false 
//			dw_insert.object.exch_rate_t3.visible = false 
//			dw_insert.object.exch_rate3.visible = false 
//		elseif ll_i = 2 then
//			dw_insert.object.exch_rate_t1.text = ls_curr + ' 환율'
//			dw_insert.object.exch_rate1[1] = ld_rate
//			dw_insert.object.exch_rate_t1.visible = true 
//			dw_insert.object.exch_rate1.visible = true 
//			dw_insert.object.exch_rate_t2.visible = false 
//			dw_insert.object.exch_rate2.visible = false 
//			dw_insert.object.exch_rate_t3.visible = false 
//			dw_insert.object.exch_rate3.visible = false 
//		elseif ll_i = 3 then
//			dw_insert.object.exch_rate_t2.text = ls_curr + ' 환율'
//			dw_insert.object.exch_rate2[1] = ld_rate
//			dw_insert.object.exch_rate_t2.visible = true 
//			dw_insert.object.exch_rate2.visible = true
//			dw_insert.object.exch_rate_t3.visible = false 
//			dw_insert.object.exch_rate3.visible = false 
//		elseif ll_i = 4 then
//			dw_insert.object.exch_rate_t3.text = ls_curr + ' 환율'
//			dw_insert.object.exch_rate3[1] = ld_rate
//			dw_insert.object.exch_rate_t3.visible = true
//			dw_insert.object.exch_rate3.visible = True 
//		end if 
//
//		ll_i = ll_i + 1 
//	LOOP
//	
//	CLOSE EXCH_R;
//
//	
//
//end if 
end event

type dw_insert from w_inherite`dw_insert within w_sal_05100
integer x = 0
integer y = 32
integer width = 3419
integer height = 484
string dataobject = "d_sal_05100"
boolean border = false
end type

event dw_insert::itemchanged;String  sDateFrom,sDateTo,snull, ls_data, ls_date, ls_curr
Decimal ld_rate
String  sItnbr,sIttyp, sItcls,sItdsc, sIspec, sItemclsname, sIojpNo, sJijil, sIspeccode
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long    nRow, nCnt, ireturn, ll_i=0

SetNull(snull)
		
nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName()
	Case  'prtgbn'
		ls_data = this.gettext() 
		if ls_data = '1' Or ls_data = '3' then 
			dw_list.dataobject = 'd_sal_05100_ds_r'
			dw_list.settransobject(sqlca)
			
			If ls_data = '3' Then
				pb_3.visible = true
			Else
				pb_3.visible = false
			End If
			
			return
		Elseif ls_data = '4'  then // po별 조정
			dw_list.dataobject = 'd_sal_05100_ds_r1'
			dw_list.settransobject(sqlca)
		else 
			dw_list.dataobject = 'd_sal_05100_ds'
			dw_list.settransobject(sqlca) 
		End if 

		pb_3.visible = false 
		dw_insert.object.exch_rate_t.visible = false 
		dw_insert.object.exch_rate.visible = false 
		dw_insert.object.exch_rate_t1.visible = false 
		dw_insert.object.exch_rate1.visible = false 
		dw_insert.object.exch_rate_t2.visible = false 
		dw_insert.object.exch_rate2.visible = false 
		dw_insert.object.exch_rate_t3.visible = false 
		dw_insert.object.exch_rate3.visible = false 
			
	Case  'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(dw_insert, 'steamcd', sSaupj)
		f_child_saupj(dw_insert, 'sarea', sSaupj)
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
	
		SELECT COUNT("IMHIST"."IOJPNO")   INTO :nCnt
	  	  FROM "IMHIST"  
    	 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
	    	    ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
 		 		 ( "IMHIST"."JNPCRT" ='004') ;

		IF SQLCA.SQLCODE <> 0 THEN	  Return 2

  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "steamcd"
	SetItem(1,'sarea',sNull)
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)

	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		FROM "SAREA"  
		WHERE "SAREA"."SAREA" = :sarea   ;
		
   SetItem(1,'steamcd',steam)
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
//			SetItem(1,"steamcd", steam)
//			SetItem(1,"sarea",   sarea)
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
//			SetItem(1,"steamcd",   steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF	
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
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
		RETURN ireturn
	/* 마감일자 */
	Case 'edate'
		ls_date = Trim(GetText())
		
		DECLARE EXCH_R  CURSOR FOR  
		SELECT RCURR, RSTAN 
		 FROM RATEMT
		WHERE RDATE = :ls_date 
		ORDER BY DECODE ( RCURR, 'USD', '1', 'JPY', '2' , '3' );
		
		OPEN EXCH_R;
		
		DO WHILE true
			FETCH EXCH_R INTO :ls_curr, :ld_rate;
			IF SQLCA.SQLCODE <> 0 THEN EXIT
			
			ll_i = ll_i + 1 
			
			if ll_i = 1 then
				dw_insert.object.exch_rate_t.text = ls_curr + ' 환율'
				dw_insert.object.exch_rate[1] = ld_rate
				dw_insert.object.exch_rate_t.visible = true 
				dw_insert.object.exch_rate.visible = true 
				dw_insert.object.exch_rate_t1.visible = false 
				dw_insert.object.exch_rate1.visible = false 
				dw_insert.object.exch_rate_t2.visible = false 
				dw_insert.object.exch_rate2.visible = false 
				dw_insert.object.exch_rate_t3.visible = false 
				dw_insert.object.exch_rate3.visible = false 
			elseif ll_i = 2 then
				dw_insert.object.exch_rate_t1.text = ls_curr + ' 환율'
				dw_insert.object.exch_rate1[1] = ld_rate
				dw_insert.object.exch_rate_t1.visible = true 
				dw_insert.object.exch_rate1.visible = true 
				dw_insert.object.exch_rate_t2.visible = false 
				dw_insert.object.exch_rate2.visible = false 
				dw_insert.object.exch_rate_t3.visible = false 
				dw_insert.object.exch_rate3.visible = false 
			elseif ll_i = 3 then
				dw_insert.object.exch_rate_t2.text = ls_curr + ' 환율'
				dw_insert.object.exch_rate2[1] = ld_rate
				dw_insert.object.exch_rate_t2.visible = true 
				dw_insert.object.exch_rate2.visible = true
				dw_insert.object.exch_rate_t3.visible = false 
				dw_insert.object.exch_rate3.visible = false 
			elseif ll_i = 4 then
				dw_insert.object.exch_rate_t3.text = ls_curr + ' 환율'
				dw_insert.object.exch_rate3[1] = ld_rate
				dw_insert.object.exch_rate_t3.visible = true
				dw_insert.object.exch_rate3.visible = True 
			end if
		LOOP
		
		CLOSE EXCH_R;
		
		If ll_i <= 0 Then
			MessageBox('확 인','등록된 환율이 없습니다.!!')
			dw_insert.object.exch_rate[1]  = 0
			dw_insert.object.exch_rate1[1] = 0
			dw_insert.object.exch_rate2[1] = 0
			dw_insert.object.exch_rate2[1] = 0
			Return
		End If
END Choose
end event

event dw_insert::rbuttondown;string sCvcod
Long   nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName()
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
	/* 품목 */
	Case "itnbr","itdsc","ispec"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	/* 출고승인 전표 */
	Case "iojpno" 
		sCvcod = Trim(GetItemString(nRow,'cvcod'))
		If IsNull(sCvcod) Then sCvcod = ''
		
		gs_code     = sCvcod
		gs_gubun    = '004'
		gs_codename = 'A'
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		wf_set_iojpno(gs_code)
		SetColumn('ioprc')
END Choose
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_05100
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_05100
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_05100
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_05100
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_05100
end type

type p_can from w_inherite`p_can within w_sal_05100
end type

event p_can::clicked;call super::clicked;String sDate

//dw_insert.Reset()
//dw_insert.InsertRow(0)

sdate = f_today()
dw_insert.SetItem(1,'sdatef',Left(sdate,6)+'01')
dw_insert.SetItem(1,'sdatet',sDate)

dw_list.Reset()
end event

type p_print from w_inherite`p_print within w_sal_05100
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_05100
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string sDatef,sDatet,sYymm,sIojpno,sItnbr,sSteamCd,sSArea,sCvcod, sPrtgbn, sToday, sSaupj, sPc, sGbn
Long   nCnt, ix
string sOrderSpec, ls_column, ls_curr, ls_date, sEdate
Decimal dWeight
double ditemprice,ddcrate, dItemQty, ld_rate, ld_for_unit_price, ld_usrate


If dw_insert.AcceptText() <> 1 then Return

sDatef = Trim(dw_insert.GetItemString(1,'sdatef'))
sDatet = Trim(dw_insert.GetItemString(1,'sdatet'))
sPrtgbn = Trim(dw_insert.GetItemString(1,'prtgbn'))
sSaupj = Trim(dw_insert.GetItemString(1,'saupj'))
sEdate = Trim(dw_insert.GetItemString(1,'edate'))
sPc	 = Trim(dw_insert.GetItemString(1,'spc'))

dw_insert.SetFocus()

sYymm  = Left(sDatef,6)
If IsNull(sdatef) Or sdatef = '' Or IsNull(sdatet) Or sdatet = '' Then
   f_message_chk(1400,'[출고기간]')
	dw_insert.SetColumn('sdatef')
	Return 
End If

//If Left(sDatef,6) <> Left(sDatet,6) Then
//	MessageBox('확 인','출고기간은 같은 년월만 가능합니다.!!')
//	Return
//End If

If IsNull(sSaupj) Or sSaupj = '' Then
   f_message_chk(1400,'[부가사업장]')
	dw_insert.SetColumn('saupj')
	Return 
End If

If sPrtgbn = '3' And ( IsNull(sEdate) Or sEdate = '' ) Then
   f_message_chk(1400,'[마감일자]')
	dw_insert.SetColumn('edate')
	Return 	
End If

/* 마감처리된 년월 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" >= :sYymm );

If nCnt > 0 Then
	f_message_chk(60,'')
	Return 
End If

/* 품번 */
sItnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
If IsNull(sItnbr) Then sItnbr = ''

sSteamCd = Trim(dw_insert.GetItemString(1,'steamcd'))
sSArea   = Trim(dw_insert.GetItemString(1,'sarea'))
sCvcod   = Trim(dw_insert.GetItemString(1,'cvcod'))
If IsNull(sSteamCd) Then sSteamCd = ''
If IsNull(sSArea)   Then sSarea = ''
If IsNull(sCvcod)   Then sCvcod = ''

If dw_list.retrieve(gs_sabu, sdatef, sdatet, ssteamcd+'%', ssarea+'%', sCvcod+'%', sItnbr+'%', sSaupj, spc) <= 0 Then
	f_message_chk(300,'')
	Return
End If

SetPointer(HourGlass!)

If sPrtGbn = '3' Or sPrtGbn = '1' Or sPrtgbn = '4' Then
	For ix = 1 To dw_list.RowCount()
		// 단가만 변경하는 경우 기준일자는 출고일자
		If sPrtgbn = '1' Then	ls_date = dw_list.GetItemString(ix, "io_date")
		If sPrtgbn = '4' Then	ls_date = dw_list.GetItemString(ix, "io_date")
		
		// 환율 변경하는 경우 기준일자는 마감일자
		If sPrtgbn = '3' Then	ls_date = dw_insert.object.edate[1]
		
		// 단가 및 환율 변경(sPrtgbn 1(단가),3(환율) // ix(해당 row) // ls_date(기준일자)
		ls_curr = dw_list.GetItemString(ix, "yebi2")
		wf_change_danga(sPrtgbn, ix, ls_date, ls_curr)
	Next

End If
end event

type p_del from w_inherite`p_del within w_sal_05100
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_05100
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long nRow, ix, nCnt=0
Double dIoPrc, dIoAmt, dVatAmt, ld_rate, ld_dyebi2
String ls_yebi2

If dw_list.AcceptText() <> 1 Then Return

if dw_insert.object.prtgbn[1] = '1' Or dw_insert.object.prtgbn[1] = '3' Or dw_insert.object.prtgbn[1] = '4' then
	
	// 선택하지 않은 내역은 제외한다
	dw_list.SetFilter("chk = 'Y'")
	dw_list.Filter()
	dw_list.RowsDiscard(1, dw_list.FilteredCount(), Filter!)

	nRow = dw_list.RowCount()
	If nRow <= 0 Then Return

	For ix = 1 To nRow
		If dw_list.GetItemString(ix, 'chk') = 'N' Then Continue
		
		dIoPrc = dw_list.GetItemNumber(ix, 'vioprc')
		ld_rate = dw_list.GetItemNumber(ix, 'exch_rate')
		ld_dyebi2 = dw_list.GetItemNumber(ix, 'vdyebi2')
		ls_yebi2 = dw_list.GetItemstring(ix, 'vyebi2')
		dVatAmt   = dw_list.GetItemNumber(ix, 'vvatamt')
		If IsNull(dIoPrc) Then Continue
		
		If dIoPrc = 0 Then 
			MessageBox("단가누락", String(ix) + ' 열의 단가가 0 원입니다.~r단가를 입력하세요.')
			dw_list.ScrollToRow(ix)
			dw_list.SetItem(ix,'vioprc', 0)
			dw_list.SetFocus()
			dw_list.SetColumn('vioprc')
			return
		End If
		
		
		dIoamt = abs(dw_list.GetItemNumber(ix, 'vioamt'))
		If IsNull(dIoAmt) Then Continue
	
		dVatamt = abs(dw_list.GetItemNumber(ix, 'vvatamt'))
		If IsNull(dVatAmt) Then Continue
		
		dw_list.SetItem(ix, 'ioprc', dIoPrc)
		dw_list.SetItem(ix, 'ioamt', dIoAmt)
		dw_list.SetItem(ix, 'dyebi3', dVatAmt)
		dw_list.SetItem(ix, 'dyebi1', ld_rate)
		dw_list.SetItem(ix, 'dyebi2', ld_dyebi2)
		dw_list.SetItem(ix, 'yebi2', ls_yebi2)
		
		nCnt += 1
	Next
	
	If nCnt <= 0 Then
		MessageBox('확 인','변경된 정보가 없습니다')
		Return
	End If
	
	If dw_list.Update() <> 1 Then
		RollBack;
		f_message_chk(32,'')
		Return
	Else
		Commit;
		MessageBox('확 인','총 '+string(ncnt)+'건 변경되었습니다.!!')
	End If

else 
	For ix = 1 To nRow
		If dw_list.GetItemString(ix, 'chk') = 'N' Then Continue
		
		dIoPrc = dw_list.GetItemNumber(ix, 'vioprc')
		If IsNull(dIoPrc) Then Continue
		
		If dIoPrc = 0 Then 
			MessageBox("단가누락", String(ix) + ' 열의 단가가 0 원입니다.~r단가를 입력하세요.')
			dw_list.ScrollToRow(ix)
			dw_list.SetItem(ix,'vioprc', 0)
			dw_list.SetFocus()
			dw_list.SetColumn('vioprc')
			return
		End If
		
		dIoamt = abs(dw_list.GetItemNumber(ix, 'vioamt'))
		If IsNull(dIoAmt) Then Continue
	
		dVatamt = abs(dw_list.GetItemNumber(ix, 'vvatamt'))
		If IsNull(dVatAmt) Then Continue
		
		dw_list.SetItem(ix, 'ioprc', dIoPrc)
		dw_list.SetItem(ix, 'ioamt', dIoAmt)
		dw_list.SetItem(ix, 'dyebi3', dVatAmt)
		
		nCnt += 1
	Next
	
	If nCnt <= 0 Then
		MessageBox('확 인','변경된 정보가 없습니다')
		Return
	End If
	
	If dw_list.Update() <> 1 Then
		RollBack;
		f_message_chk(32,'')
		Return
	Else
		Commit;
		MessageBox('확 인','총 '+string(ncnt)+'건 변경되었습니다.!!')
	End If
	
end if 
p_can.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_05100
integer x = 3735
integer y = 2484
integer taborder = 50
end type

type cb_mod from w_inherite`cb_mod within w_sal_05100
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05100
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_sal_05100
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05100
integer x = 2880
integer y = 2472
end type

type cb_print from w_inherite`cb_print within w_sal_05100
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05100
end type

type cb_can from w_inherite`cb_can within w_sal_05100
integer x = 3365
integer y = 2496
integer taborder = 40
end type

type cb_search from w_inherite`cb_search within w_sal_05100
integer x = 3918
integer y = 2508
integer width = 334
integer taborder = 20
string text = "저장(&P)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_05100
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05100
end type

type cbx_1 from checkbox within w_sal_05100
integer x = 2496
integer y = 116
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long ll_count
string ls_status

if this.checked=true then
	ls_status='Y'
elseif this.checked=false then
	ls_status='N'
else
	setnull(ls_status)
end if

 for ll_count=1 to dw_list.rowcount()
	dw_list.setitem(ll_count,'chk',ls_status)
next

end event

type rr_1 from roundrectangle within w_sal_05100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 540
integer width = 4626
integer height = 1724
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from u_d_select_sort within w_sal_05100
integer x = 23
integer y = 556
integer width = 4585
integer height = 1684
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_05100_ds_r"
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;Long nRow 
Dec	dIoPrc, dIoQty, dIoamt, ld_calvalue, dexch_rate, ld_for_unit_prc, dWeight
String ls_lclgbn, ls_date, ls_prc_unit, sCurr
nRow = GetRow()
If nRow <= 0 Then Return

// 가중치
If GetColumnName() = 'vyebi2' Then
	sCurr = GetText()
Else
	sCurr = GetItemString(nRow, 'vyebi2')
End If
SELECT TO_NUMBER(RFNA2) INTO :dWeight FROM REFFPF WHERE RFCOD = '10' AND RFGUB = :sCurr;
		
Choose Case GetColumnName()
	Case 'lclgbn'
		ls_lclgbn = GetText()
		
		ls_prc_unit = dw_list.object.vyebi2[nrow]
		ls_date = dw_list.object.io_date[nrow]
			
		
		dIoQty = GetItemNumber(nRow, 'ioqty')							//수량
		ld_for_unit_prc = getitemnumber(nRow, 'vdyebi2')			//외화단가
		ld_calvalue = GetItemNumber(nRow, 'iomatrix_calvalue')	//
		//ls_lclgbn = getitemstring(nRow, 'lclgbn')						// LCgbn
		
		
		SetItem(nRow, 'exch_rate', dexch_rate )
		SetItem(nRow, 'vioprc', dexch_rate * ld_for_unit_prc )
		SetItem(nRow, 'vioamt', TrunCate(dIoQty  * dexch_rate * ld_for_unit_prc ,0))
		if ls_lclgbn = 'L' then 
			SetItem(nRow, 'vvatamt', 0 )
		else
			SetItem(nRow, 'vvatamt', TrunCate(dIoQty  * dexch_rate * ld_for_unit_prc ,0))
		end if 
	/* 통화단위 변경 */
	Case 'vyebi2'
		ls_prc_unit = GetText()
		
		If dw_insert.GetItemString(1, 'prtgbn') = '1' Then
			ls_date = dw_list.object.io_date[nrow]
		Else
			ls_date = dw_insert.GetItemString(1, 'edate')
		End If
		
		// 단가 및 환율 변경(sPrtgbn 1(단가),3(환율) // ix(해당 row) // ls_date(기준일자)
		Post wf_change_danga('1', nRow, ls_date, ls_prc_unit)
		
//		select fun_get_daily_exch_rate( '1' ,  :ls_date, :ls_prc_unit ) 
//		  into :dexch_rate 
//		  from dual ; 
//		
//		if dexch_rate = 0 or isnull(dexch_rate) or dexch_rate = -1 then 
//			if ls_prc_unit <> 'WON' then 
//		   	Messagebox('확인', ls_date + '일자 통화단위 [' + ls_prc_unit  + ']가 등록되지 않았습니다')
//				Return
//			else 
//				ld_for_unit_prc = 1 
//			End if 
//		End if 	
//		
//		dIoQty = GetItemNumber(nRow, 'ioqty')							//수량
//		ld_for_unit_prc = getitemnumber(nRow, 'vdyebi2')			//외화단가
//		ld_calvalue = GetItemNumber(nRow, 'iomatrix_calvalue')	//
//		ls_lclgbn = getitemstring(nRow, 'lclgbn')						// LCgbn
//		
//		
//		SetItem(nRow, 'exch_rate', dexch_rate )
//		SetItem(nRow, 'vioprc', dexch_rate * ld_for_unit_prc / dWeight )
//		
//		dIoAmt = TrunCate(dIoQty  * dexch_rate * ld_for_unit_prc / dWeight ,0)
//		SetItem(nRow, 'vioamt', dIoAmt)
//		
//		if ls_lclgbn = 'L' then 
//			SetItem(nRow, 'vvatamt', 0 )
//		else
//			SetItem(nRow, 'vvatamt', dIoAmt * 0.1)
//		end if
	// 환율 변경
	Case 'exch_rate'
		dexch_rate = Dec(GetText())
		
		dIoQty = GetItemNumber(nRow, 'ioqty')							//수량
		ld_for_unit_prc = getitemnumber(nRow, 'vdyebi2')			//외화단가
		ld_calvalue = GetItemNumber(nRow, 'iomatrix_calvalue')	//
		ls_lclgbn = getitemstring(nRow, 'lclgbn')						// LCgbn
		
		SetItem(nRow, 'vioprc', dexch_rate * ld_for_unit_prc / dWeight)
		
		dIoAmt = TrunCate(dIoQty  * dexch_rate * ld_for_unit_prc / dWeight ,0)
		SetItem(nRow, 'vioamt', dIoAmt)
		if ls_lclgbn = 'L' then 
			SetItem(nRow, 'vvatamt', 0 )
		else
			SetItem(nRow, 'vvatamt', dIoAmt * 0.1)
		end if 
	// 외화단가 변경
	Case 'vdyebi2'
		ld_for_unit_prc = Dec(GetText())
		
		dexch_rate =  GetItemNumber(nRow, 'exch_rate')
		dIoQty = GetItemNumber(nRow, 'ioqty')

		ls_lclgbn = getitemstring(nRow, 'lclgbn')
		
		SetItem(nRow, 'vioprc', dexch_rate * ld_for_unit_prc / dWeight )
		
		dIoAmt = TrunCate(dIoQty  * dexch_rate * ld_for_unit_prc / dWeight ,0)
		SetItem(nRow, 'vioamt', dIoAmt)
		if ls_lclgbn = 'L' then 
			SetItem(nRow, 'vvatamt', 0 )
		else
			SetItem(nRow, 'vvatamt',  dIoAmt * 0.1)
		end if 
	Case 'vioprc'
		dIoPrc = Dec(GetText())
		
		dIoQty = GetItemNumber(nRow, 'ioqty')
		ld_calvalue = GetItemNumber(nRow, 'iomatrix_calvalue')
		ls_lclgbn = getitemstring(nRow, 'lclgbn')
		
		SetItem(nRow, 'vioamt', TrunCate(dIoPrc * dIoQty,0))
		if ls_lclgbn = 'L' then 
			SetItem(nRow, 'vvatamt', 0)
		else
			SetItem(nRow, 'vvatamt', TrunCate(dIoPrc * dIoQty *0.1 ,0))
		end if
	CASE 'vioamt'
		dIoamt = Dec(GetText())
		dIoQty = GetItemNumber(nRow, 'ioqty')
		
		SetItem(nRow, 'vioprc', dIoamt / dIoqty)
		ls_lclgbn = getitemstring(nRow, 'lclgbn')
		
		SetItem(nRow, 'vioamt', TrunCate(dIoPrc * dIoQty,0))
		if ls_lclgbn = 'L' then 
			SetItem(nRow, 'vvatamt', 0)
		else
			SetItem(nRow, 'vvatamt', TrunCate(dIoamt *0.1,0))
		end if
		
End Choose
end event

type rb_3 from radiobutton within w_sal_05100
boolean visible = false
integer x = 3511
integer y = 424
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;dw_list.setFilter("")
dw_list.Filter()

//dw_print.setFilter("")
//dw_print.Filter()
end event

type rb_4 from radiobutton within w_sal_05100
boolean visible = false
integer x = 3913
integer y = 424
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "OEM"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'OEM'")
dw_list.Filter()

//dw_print.SetFilter( "imhist_pspec = 'OEM'")
//dw_print.Filter()
end event

type rb_5 from radiobutton within w_sal_05100
boolean visible = false
integer x = 4306
integer y = 424
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "CKD"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'CKD'")
dw_list.Filter()

//dw_print.SetFilter( "imhist_pspec = 'CKD'")
//dw_print.Filter()
end event

type pb_1 from u_pb_cal within w_sal_05100
integer x = 667
integer y = 132
integer width = 78
integer height = 72
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05100
integer x = 1097
integer y = 132
integer width = 82
integer height = 72
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatet', gs_code)

end event

type pb_3 from u_pb_cal within w_sal_05100
integer x = 667
integer y = 392
integer width = 82
integer height = 72
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;String ls_date, ls_curr
Decimal ld_rate
int 		ll_i = 1

//해당 컬럼 지정
dw_insert.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'edate', gs_code)
dw_insert.SetFocus()
dw_insert.SetColumn('edate')
dw_insert.TriggerEvent(ItemChanged!)

end event

type cb_1 from commandbutton within w_sal_05100
integer x = 3461
integer y = 408
integer width = 402
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "끝전조정"
end type

event clicked;boolean lb_found
long ll_breakrow
Dec  dAmt, dTemp, dCha, dtotCha, dtotvat
String sItdsc

lb_found = FALSE

ll_breakrow = 0

DO WHILE NOT (lb_found)
	ll_breakrow = dw_list.FindGroupChange(ll_breakrow, 1)
		IF ll_breakrow <= 0 THEN EXIT
	
	dAmt	= dw_list.GetItemNumber(ll_breakrow, 'gr_vamt')
	dTemp	= dw_list.GetItemNumber(ll_breakrow, 'gr_chamt')
	sItdsc = dw_list.GetItemstring(ll_breakrow, 'itemas_itdsc')
	
	dCha = dTemp - dAmt
	If dCha <> 0 Then
		dw_list.SetItem(ll_breakrow, 'vioamt', dw_list.getitemnumber(ll_breakrow, 'vioamt') + dcha)
		dTotcha += dcha
	End If

	ll_breakrow = ll_breakrow + 1
LOOP

dw_list.groupCalc();

// Po별 인 겨우 부가세 금액을 조정한다
If dw_insert.GetItemSTring(1, 'prtgbn') = '4' Then
	lb_found = FALSE
	
	ll_breakrow = 0
	
	DO WHILE NOT (lb_found)
		ll_breakrow = dw_list.FindGroupChange(ll_breakrow, 1)
			IF ll_breakrow <= 0 THEN EXIT
		
		dAmt	= dw_list.GetItemNumber(ll_breakrow, 'gr_vat')
		dTemp	= truncate(dw_list.GetItemNumber(ll_breakrow, 'gr_gongamt') * 0.1,0)
		sItdsc = dw_list.GetItemstring(ll_breakrow, 'itemas_itdsc')
		
		dCha = dTemp - dAmt
		If dCha <> 0 Then
			dw_list.SetItem(ll_breakrow, 'dyebi3', dw_list.getitemnumber(ll_breakrow, 'dyebi3') + dcha)
			dtotvat += dcha
		End If
	
		ll_breakrow = ll_breakrow + 1
	LOOP	
End If

dw_list.groupCalc();

MessageBox('확인','공급가액 ' + string(dtotCha,'#,##0') + " 원 부가세액 " + string(dtotVAT,'#,##0') + " 원 조정하였습니다.!!" )

end event

type gb_2 from groupbox within w_sal_05100
boolean visible = false
integer x = 3451
integer y = 356
integer width = 1175
integer height = 144
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력 Filter"
end type

