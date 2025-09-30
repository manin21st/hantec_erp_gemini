$PBExportHeader$w_sal_05030.srw
$PBExportComments$세금계산서 발행
forward
global type w_sal_05030 from w_inherite
end type
type dw_list from datawindow within w_sal_05030
end type
type rb_modify from radiobutton within w_sal_05030
end type
type rb_insert from radiobutton within w_sal_05030
end type
type dw_auto from datawindow within w_sal_05030
end type
type pb_1 from u_pb_cal within w_sal_05030
end type
type rr_4 from roundrectangle within w_sal_05030
end type
end forward

global type w_sal_05030 from w_inherite
integer height = 3772
string title = "세금계산서 발행 - 건별"
event ue_open ( )
dw_list dw_list
rb_modify rb_modify
rb_insert rb_insert
dw_auto dw_auto
pb_1 pb_1
rr_4 rr_4
end type
global w_sal_05030 w_sal_05030

type variables

String sAutoStatus  // 자동발행 여부

end variables

forward prototypes
public function string wf_calculation_orderno (string sorderdate)
public function integer wf_select_lcno (integer row, string lcno)
public function integer wf_calc_checkno (string sabu, string sdate)
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public subroutine wf_init ()
end prototypes

event ue_open;call super::ue_open;dw_insert.SetTransObject(SQLCA)
dw_insert.InsertRow(0)

/* 세금계산서 출력양식(hidden)*/
dw_list.SetTransObject(SQLCA)
dw_auto.SetTransObject(SQLCA)


rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)


end event

public function string wf_calculation_orderno (string sorderdate);String  sOrderNo,sOrderGbn
Integer iMaxOrderNo

sOrderGbn = 'S0'

iMaxOrderNo = sqlca.fun_junpyo(gs_sabu,sOrderDate,sOrderGbn)
IF iMaxOrderNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF
commit;

sOrderNo = sOrderDate + String(iMaxOrderNo,'000')

Return sOrderNo
end function

public function integer wf_select_lcno (integer row, string lcno);string s_lcno,s_cvcodnm,s_banklcno,s_curr,s_explcdt
dec    lcamt
Dec {2} wrate,urate

  SELECT "EXPLC"."EXPLCDT",
         "EXPLC"."EXPLCNO",   
         "EXPLC"."BANKLCNO",   
         "EXPLC"."LCAMT",
         "EXPLC"."CURR",
         FUN_GET_CVNAS("EXPLC"."CVCOD" ) AS CVCODNM  
	 INTO :s_explcdt, :s_lcno, :s_banklcno ,:lcamt,:s_curr, :s_cvcodnm
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :lcno )   ;

dw_insert.SetItem(row,'lcno',s_lcno)

select rstan,usdrat
  into :wrate,:urate
  from ratemt
 where rdate = :s_explcdt and
       rcurr = :s_curr;

If IsNull(wrate) Or wrate = 0 Then wrate = 0.0
If IsNull(urate) Or urate = 0 Then urate = 0.0
dw_insert.SetItem(row,'exchrate',wrate)

If Len(Trim(s_lcno)) <= 0 Or IsNull(s_lcno) Then    REturn 1

Return 0

end function

public function integer wf_calc_checkno (string sabu, string sdate);integer	nMAXNO

SELECT NVL(seqno, 0)
  INTO :nMAXNO
  FROM checkno
 WHERE ( sabu = :gs_sabu ) AND
		 ( base_yymm = :sdate ) for update;
		
Choose Case sqlca.sqlcode 
  Case is < 0 
			return -1
  Case 100 
    nMAXNO = 1

    INSERT INTO checkno ( sabu,base_yymm, seqno )
        VALUES ( :gs_sabu, :sDate, :nMaxNo ) ;  
  Case 0
	 nMAXNO = nMAXNO + 1

	 UPDATE checkno
   	 SET seqno = :nMAXNO
	  WHERE ( sabu = :gs_sabu ) AND
			  ( base_yymm = :sDate );
END Choose

If sqlca.sqlcode <> 0 Then	Return -1

RETURN nMAXNO

end function

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sSaleDate,sCvCod,sCvName,sSano,sUpTae,sUpJong,sVatGbn, sAddr, sResident, sSaupj

IF sDwObject = 'd_sal_020602_tmp' THEN
	sSaleDate = Trim(dw_insert.GetItemString(iCurRow,"saledt"))
	sCvcod    = Trim(dw_insert.GetItemString(iCurRow,"cvcod"))
	sCvName   = Trim(dw_insert.GetItemString(iCurRow,"cvnas"))
	sSano     = Trim(dw_insert.GetItemString(iCurRow,"sano"))
	sUpTae    = Trim(dw_insert.GetItemString(iCurRow,"uptae"))
	sUpJong   = Trim(dw_insert.GetItemString(iCurRow,"jongk"))
	sAddr     = Trim(dw_insert.GetItemString(iCurRow,"addr1"))
	sResident = Trim(dw_insert.GetItemString(iCurRow,"resident"))
	sVatGbn   = Trim(dw_insert.GetItemString(iCurRow,"tax_no"))
	sSaupj 	 = Trim(dw_insert.GetItemString(iCurRow,"saupj"))
	
	dw_insert.SetFocus()
	IF sSaleDate = "" OR IsNull(sSaleDate) THEN
		f_message_chk(30,'[매출일자]')
		dw_insert.SetColumn("saledt")
		Return -1
	END IF

	IF sSaupj = "" OR IsNull(sSaupj) THEN
		f_message_chk(30,'[부가사업장]')
		dw_insert.SetColumn("saupj")
		Return -1
	END IF
	
	IF sCvcod = "" OR IsNull(sCvcod) THEN
		f_message_chk(30,'[거래처]')
		dw_insert.SetColumn("cvcod")
		Return -1
	END IF
	
	IF sCvName = "" OR IsNull(sCvName) THEN
		f_message_chk(30,'[거래처명]')
		dw_insert.SetColumn("cvnas")
		Return -1
	END IF
	
	IF sVatGbn <> '22' And ( sSano = "" OR IsNull(sSano)) THEN
		f_message_chk(30,'[사업자등록번호]')
		dw_insert.SetColumn("sano")
		Return -1
	END IF
	
	IF sVatGbn <> '22' And ( sUpTae = "" OR IsNull(sUpTae)) THEN
		f_message_chk(30,'[업태]')
		dw_insert.SetColumn("uptae")
		Return -1
	END IF
	
	IF sVatGbn <> '22' And (sUpJong = "" OR IsNull(sUpJong)) THEN
		f_message_chk(30,'[업종]')
		dw_insert.SetColumn("jongk")
		Return -1
	END IF
	
	IF sAddr = "" OR IsNull(sAddr) THEN
		f_message_chk(30,'[주소]')
		dw_insert.SetColumn("addr1")
		Return -1
	END IF


ELSEIF sDwObject = 'd_sal_020602' THEN	
	sVatGbn  = Trim(dw_insert.GetItemString(iCurRow,"tax_no"))
	
	IF sVatGbn = "" OR IsNull(sVatGbn) THEN
		f_message_chk(30,'[계산서구분]')
		dw_insert.SetColumn("tax_no")
		dw_insert.SetFocus()
		Return -1
	END IF
	
	sVatGbn  = Trim(dw_insert.GetItemString(iCurRow,"vatgbn"))
	
	IF sVatGbn = "" OR IsNull(sVatGbn) THEN
		f_message_chk(30,'[부가세 업종구분]')
		dw_insert.SetColumn("vatgbn")
		dw_insert.SetFocus()
		Return -1
	END IF
END IF

Return 1
end function

public subroutine wf_init ();/* 자동발행 */
rollback;

SetNull(sAutoStatus)  
ib_any_typing = False
w_mdi_frame.sle_msg.Text = ''

dw_auto.Reset()
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)

String	ls_sano, ls_cvnas, ls_ownam, ls_addr, ls_uptae, ls_jongmok, ls_saupj, ls2_saupj, ls_cvcod
String  ls_2, ls_3, ls_4, ls_5,  ls_8, ls_9

// 부가세 사업장 설정
f_mod_saupj(dw_insert, 'saupj')

// 부가세 업종구분
f_child_saupj(dw_insert, 'vatgbn', gs_saupj)

//자사거래처 코드
//select a.dataname  , b.rfgub	into	 :ls_cvcod , :ls2_saupj
//  from syscnfg  a , reffpf b
// where  a.sysgu = 'C'     and 	 a.serial = 4   and    a.lineno = '1'  &
//   and  b.rfcod = 'AD'     and     b.rfna2 = a.dataname
//	and b.rfgub = :gs_saupj;
 
//ls_2 = '2'    ; ls_3 = '3' ; ls_4 = '4'   ; ls_5 = '5'   ; ls_8 = '8'   ; ls_9 = '9'
//
////사업자 번호
//select dataname    	into	 :ls_sano
//  from 	 syscnfg   
// where  sysgu = 'C'     and 	 serial = 1   and    lineno = :ls_2 ;
////법인명
//select dataname 	into	 :ls_cvnas
//		from 	 syscnfg  
//		where  sysgu = 'C'  	and 	 serial = 1 and    lineno = :ls_3 ;
////대표자
//select dataname  	into	 :ls_ownam
//		from 	 syscnfg 
//		where  sysgu = 'C'  and 	 serial = 1 and    lineno = :ls_4 ;
////주소
//select dataname 	into	 :ls_addr
//		from 	 syscnfg 
//		where  sysgu = 'C'  and 	 serial = 1 and    lineno = :ls_5 ;
//
////업태
//select dataname 	into	 :ls_uptae
//		from 	 syscnfg 
//		where  sysgu = 'C' and 	 serial = 1 and    lineno = :ls_8 ;
//
////업종
//select dataname 	into	 :ls_jongmok
//		from 	 syscnfg 
//		where  sysgu = 'C' and 	 serial = 1 and    lineno = :ls_9 ;

//자사거래처 코드
select a.sano, a.cvnas, a.ownam, a.addr1, a.uptae, a.jongk
  into :ls_sano, :ls_cvnas, :ls_ownam, :ls_addr, :ls_uptae,:ls_jongmok
  from reffpf b, vndmst a
 where b.rfcod = 'AD'
   and b.rfna2 = a.cvcod
	and b.rfgub = :gs_saupj;

dw_insert.SetItem(1, 'vndmst_sano', ls_sano)
dw_insert.SetItem(1, 'vndmst_cvnas', ls_cvnas)
dw_insert.SetItem(1, 'vndmst_ownam', ls_ownam)
dw_insert.SetItem(1, 'vndmst_addr1', ls_addr)
dw_insert.SetItem(1, 'vndmst_uptae', ls_uptae)
dw_insert.SetItem(1, 'vndmst_jongk', ls_jongmok)

IF sModStatus = 'I' THEN        /* 등록 */
	dw_insert.Modify('saledt.protect = 0')
	dw_insert.Modify('saleno.protect = 1')
	dw_insert.Modify('checkno.protect = 0')
	dw_insert.Modify('cvcod.protect = 0')
//	dw_insert.Modify('saupj.protect = 0')
ELSE        /* 수정 */
	dw_insert.Modify('saledt.protect = 0')
	dw_insert.Modify('saleno.protect = 0')
	dw_insert.Modify('checkno.protect = 1')
	dw_insert.Modify('cvcod.protect = 1')
//	dw_insert.Modify('saupj.protect = 1')
END IF
dw_insert.SetRedraw(True)

dw_insert.SetFocus()	
dw_insert.SetColumn("saledt")

end subroutine

on w_sal_05030.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rb_modify=create rb_modify
this.rb_insert=create rb_insert
this.dw_auto=create dw_auto
this.pb_1=create pb_1
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rb_modify
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.dw_auto
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_4
end on

on w_sal_05030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.rb_modify)
destroy(this.rb_insert)
destroy(this.dw_auto)
destroy(this.pb_1)
destroy(this.rr_4)
end on

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_05030
integer x = 178
integer y = 196
integer width = 4325
integer height = 2140
integer taborder = 20
string dataobject = "d_sal_020602_tmp"
boolean border = false
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String  sMonthDay,sVatGbn,sVoucGbn,sItemUseYn, sYear
Double  dItemQty,dItemPrice
string  s_itnbr,s_itdsc,s_ispec
int     iMaxSaleNo,nRow
String  sSaleDate,sCust,sCustName,sCustSano,sCustOwner,sCustResident
string  sCustUpTae,sCustUpJong, sCustAddr,sCustGbn,sNull,scheckno, sSaleCod, sSaupj
String  ls_sano, ls_cvnas, ls_ownam, ls_addr, ls_uptae, ls_jongmok

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

/* 매출일자 */
Choose Case GetColumnName()
	Case "saupj"
		sSaupj = Trim(GetText())
		
		// 부가세 업종구분
		f_child_saupj(dw_insert, 'vatgbn', sSaupj)
		
		// 업체정보
		select a.sano, a.cvnas, a.ownam, a.addr1, a.uptae, a.jongk
		  into :ls_sano, :ls_cvnas, :ls_ownam, :ls_addr, :ls_uptae,:ls_jongmok
		  from reffpf b, vndmst a
		 where b.rfcod = 'AD'
			and b.rfna2 = a.cvcod
			and b.rfgub = :sSaupj;
		
		dw_insert.SetItem(1, 'vndmst_sano',  ls_sano)
		dw_insert.SetItem(1, 'vndmst_cvnas', ls_cvnas)
		dw_insert.SetItem(1, 'vndmst_ownam', ls_ownam)
		dw_insert.SetItem(1, 'vndmst_addr1', ls_addr)
		dw_insert.SetItem(1, 'vndmst_uptae', ls_uptae)
		dw_insert.SetItem(1, 'vndmst_jongk', ls_jongmok)

	Case "saledt"
		sSaleDate = Trim(GetText())
		IF sSaleDate ="" OR IsNull(sSaleDate) THEN RETURN
		
		IF f_datechk(sSaleDate) = -1 THEN
			f_message_chk(35,'[매출일자]')
			SetItem(1,"saledt",sNull)
			Return 1
		END IF
	/* 거래처 */
	Case 'cvcod'
		sCust = Trim(GetText())
		
		IF sCust ="" OR IsNull(sCust) THEN
			SetItem(nRow,"cvnas",sNull)
			SetItem(nRow,"sano",sNull)
			SetItem(nRow,"ownam",sNull)
			SetItem(nRow,"resident",sNull)
			SetItem(nRow,"uptae",sNull)
			SetItem(nRow,"jongk",sNull)
			SetItem(nRow,"addr1",sNull)
			Return
		End If
		
		SELECT "VNDMST"."CVNAS2",  		"VNDMST"."SALESCOD"
		  INTO :sCustName,   				:sSaleCod
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sCust;
	
		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow,"cvcod",sNull)
			SetItem(nRow,"salecod",sNull)
			SetItem(nRow,"cvnas",sNull)
			SetItem(nRow,"sano",sNull)
			SetItem(nRow,"ownam",sNull)
			SetItem(nRow,"resident",sNull)
			SetItem(nRow,"uptae",sNull)
			SetItem(nRow,"jongk",sNull)
			SetItem(nRow,"addr1",sNull)
			Return 2
		ELSE
			SetItem(nRow,"salecod",  sSaleCod)
			
			SELECT "VNDMST"."CVNAS2", 		   "VNDMST"."SANO",  		 		"VNDMST"."UPTAE",   
					 "VNDMST"."JONGK",   		"VNDMST"."OWNAM",   				"VNDMST"."RESIDENT",   
					 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),	"VNDMST"."CVGU"  
			  INTO :sCustName,   				:sCustSano,   						:sCustUpTae,   
					 :sCustUpjong,   				:sCustOwner,   					:sCustResident,
					 :sCustAddr,   														:sCustGbn  
			  FROM "VNDMST"  
			 WHERE "VNDMST"."CVCOD" = :sSaleCod;
		
			IF SQLCA.SQLCODE <> 0 THEN
				SetItem(nRow,"salecod",sNull)
				SetItem(nRow,"cvnas",sNull)
				SetItem(nRow,"sano",sNull)
				SetItem(nRow,"ownam",sNull)
				SetItem(nRow,"resident",sNull)
				SetItem(nRow,"uptae",sNull)
				SetItem(nRow,"jongk",sNull)
				SetItem(nRow,"addr1",sNull)
				Return 2
			ELSE
				SetItem(nRow,"cvnas",  sCustName)
				SetItem(nRow,"sano",	  sCustSano)
				SetItem(nRow,"ownam",  sCustOwner)
				SetItem(nRow,"resident",sCustResident)
				SetItem(nRow,"uptae",	sCustUptae)
				SetItem(nRow,"jongk",	sCustUpjong)
				SetItem(nRow,"addr1",   sCustAddr)
			END IF
		END IF	

	/* 계산서 번호 */
	Case "checkno"
		scheckno = Trim(GetText())
		
		scheckno = fill(' ',10 - len(scheckno)) + scheckno
		Post SetItem(row,'checkno',scheckno)
		
		
	Case "tax_no" 
		sVatGbn = Trim(this.GetText())
		IF sVatGbn = "" OR IsNull(sVatGbn) THEN RETURN
			
		/* 매출영세율일 경우 부가세 = 0 */
		If sVatGbn = '23' Then
			SetItem(nRow,'vatamt1',0)
			SetItem(nRow,'vatamt2',0)
			SetItem(nRow,'vatamt3',0)
			SetItem(nRow,'vatamt4',0)
		End If
		This.SetItem(1,'tax_no',sVatGbn)
		
		Case "vouc_gu"
		sVoucGbn = this.GetText()
		IF sVoucGbn = "" OR IsNull(sVoucGbn) THEN RETURN
		
		SELECT "REFFPF"."RFCOD"  	INTO :sVoucGbn  
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = :gs_sabu ) AND  ( "REFFPF"."RFCOD" = 'AU' ) AND  
				 ( "REFFPF"."RFGUB" = :sVoucGbn )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[영세율증빙구분]')
			this.SetItem(1,"vouc_gu",snull)
			Return 1
		END IF
	Case  "pum1","pum2","pum3","pum4"    // 품명입력시
		s_itdsc = Trim(GetText())
		
		SELECT "ITEMAS"."ISPEC"
		  INTO  :s_ispec
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITDSC" = :s_itdsc AND "ITEMAS"."GBWAN" = 'Y' ;
		
		IF SQLCA.SQLCODE <> 0  THEN
			return 0
			
			Gs_CodeName = '품명'
			Gs_Code = s_itdsc
			open(w_itemas_popup5)
			s_itnbr = gs_code
			s_itdsc = gs_codename
			s_ispec = gs_gubun
		END IF
		
		If s_ispec = '' Or IsNull(s_ispec)   Then 
			this.setitem(nRow, GetColumnName() , sNull)
			this.setitem(nRow, "size" + Right(GetColumnName(),1), sNull)
			Return 2
		End If
		
		this.setitem(nRow,GetColumnName(), s_itdsc)
		this.setitem(nRow, 'size'+Right(GetColumnName(),1), s_ispec)
	Case  "size1","size2","size3","size4"           // 규격입력시
		s_ispec = Trim(GetText())
		
		SELECT "ITEMAS"."ITDSC"
		  INTO :s_itdsc
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ISPEC" = :s_ispec AND "ITEMAS"."GBWAN" = 'Y' ;
		
		IF SQLCA.SQLCODE <> 0  THEN
			return 0
			
			Gs_CodeName = '규격'
			Gs_Code = s_ispec
			
			open(w_itemas_popup5)
			s_itnbr = gs_code 
			s_itdsc = gs_codename
			s_ispec = gs_gubun
		END IF
		
		If s_itdsc = '' Or IsNull(s_itdsc)   Then 
			this.setitem(nRow,GetColumnName(), sNull)
			this.setitem(nRow, "size" + Right(GetColumnName(),1), sNull)			
			Return 2
		End If
		
		this.setitem(nRow, "pum"+Right(GetColumnName(),1), s_itdsc)
		this.setitem(nRow,GetColumnName(), s_ispec)
	Case "mmdd1", "mmdd2","mmdd3","mmdd4"
		sMonthDay = Trim(this.GetText())
		IF sMonthDay = "" OR IsNull(sMonthDay) THEN RETURN
		
		sYear = Left(GetItemString(1,'saledt'),4)
		
		IF f_datechk(sYear+sMonthDay) = -1 THEN
			f_message_chk(35,'[월일]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 수량 */
	Case "qty1","qty2","qty3","qty4"
		dItemQty = Double(this.GetText())
		IF IsNull(dItemQty) THEN 
			SetItem(row,"qty"+Right(GetColumnName(),1),0)
			Return
		End If
		
		dItemPrice = GetItemNumber(row,"uprice"+Right(GetColumnName(),1))
		IF dItemPrice = 0 Or IsNull(dItemPrice) THEN Return
		
		/* 공급가 */
		SetItem(row,"gonamt"+Right(GetColumnName(),1),dItemQty * dItemPrice)
		
		/* 부가세 */
		sVatGbn = Trim(GetItemString(nRow,'tax_no'))
		If sVatGbn <> '23' Then
			SetItem(row,"vatamt"+Right(GetColumnName(),1),(dItemQty * dItemPrice) * 0.1)
		Else
			SetItem(row,"vatamt"+Right(GetColumnName(),1),0)
		End If
	/* 단가 */
	Case "uprice1" ,"uprice2","uprice3","uprice4"
		dItemPrice = Double(this.GetText())
		IF dItemPrice = 0 OR IsNull(dItemPrice) THEN 
			SetItem(row,"uprice"+Right(GetColumnName(),1),0)
			RETURN
		End If
	
		dItemQty = this.GetItemNumber(row,"qty"+Right(GetColumnName(),1))
		IF dItemQty = 0 Or IsNull(dItemQty) THEN Return
		
		this.SetItem(row,"gonamt"+Right(GetColumnName(),1),dItemQty * dItemPrice)
		
		/* 부가세 */
		sVatGbn = Trim(GetItemString(nRow,'tax_no'))
		If sVatGbn <> '23' Then
			SetItem(row,"vatamt"+Right(GetColumnName(),1),(dItemQty * dItemPrice) * 0.1)
		Else
			SetItem(row,"vatamt"+Right(GetColumnName(),1),0)
		End If
	Case 'lcno'  // LC접수번호
		gs_code = Trim(GetText())
		If wf_select_lcno(row,gs_code) = 1 Then
			f_message_chk(33,'')
			return 1
		End If
	/* 내수/수출 구분 */
	Case 'expgu'
		SetItem(1,'lcno',sNull)
		SetItem(1,'vouc_gu',sNull)
		SetItem(1,'for_amt',0)
		SetItem(1,'exchrate',0)
End Choose

ib_any_typing = True
end event

event dw_insert::rbuttondown;string  col_name
Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)
SetNull(gs_gubun)

iCurRow = this.GetRow()
col_name = GetColumnName()

Choose Case col_name
  	Case "saledt"
		IF sModStatus = 'M' THEN
			Open(w_sale_popup)
			
			IF gs_code = "" OR IsNull(gs_code) THEN RETURN
			SetItem(1,"saupj",gs_codename2)
			SetItem(1,"saledt",gs_code)
			SetItem(1,"saleno",Long(gs_codename))
			
			cb_inq.PostEvent(Clicked!)
		END IF
	Case "cvcod"
		Open(w_agent_popup)
	
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		TriggerEvent(ItemChanged!)
		Return
  	Case "pum1","pum2","pum3","pum4"
		gs_codename = this.GetText()
	
	 	open(w_itemas_popup)
	 	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 	this.SetItem(iCurRow,col_name,gs_codename)               /* 품명 */
	 	this.SetItem(iCurRow,'size'+Right(col_name,1),gs_gubun)  /* 규격 */
  	Case "size1","size2","size3","size4"
	 	gs_gubun = this.GetText()
	
	 	open(w_itemas_popup)
	 	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 	this.SetItem(iCurRow,'pum'+Right(col_name,1),gs_codename)/* 품명 */
	 	this.SetItem(iCurRow,col_name,gs_gubun)  /* 규격 */
	Case "cust_no"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
		this.SetItem(iCurRow,"cust_no",gs_code)
		this.TriggerEvent(ItemChanged!)
	Case "cust_name"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
		this.SetItem(iCurRow,"cust_name",gs_codeName)
		this.TriggerEvent(ItemChanged!)
	Case "lcno"                              // lc 접수번호 선택 popup 
  		Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		wf_select_lcno(row,gs_code)
END Choose


end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::editchanged;sle_msg.text = ''
end event

type p_delrow from w_inherite`p_delrow within w_sal_05030
boolean visible = false
integer x = 2139
integer y = 2892
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_05030
boolean visible = false
integer x = 1966
integer y = 2892
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_05030
boolean visible = false
integer x = 1454
integer y = 2932
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sal_05030
integer x = 3749
integer y = 28
end type

event p_ins::clicked;call super::clicked;int    nRow,iMaxSaleNo,ix,nRowCnt,rtn, iGon
string sCvcod,sPum,sIspec, sSudat, sToDate, sExpgu, sVatgbn, sStrAmt, sStrVat, sBalgu
double dGonAmt,dVatAmt,dIoqty,dIoPrc, dTotGon, dTotVat
String sCustName, sCustSano, sCustUpTae,   sCustUpjong, sCustOwner, sCustResident, sCustAddr, sCustGbn , sSaleCod
		 
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF wf_warndataloss("자동 발행") = -1 THEN  	RETURN
//If dw_saleh_ins.RowCount() <= 0 Then Return
If dw_insert.RowCount() <= 0 Then Return
//nRow = dw_insert.GetRow()
nRow = dw_insert.GetRow()
//If nRow  <= 0 Then Return

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)

/* 초기화 */
sAutoStatus = 'N'

/* 자동발행할 매출 선택 */
Open(w_sal_05030_1)
If IsNull(gs_code) Or gs_code = '' then Return

sCvcod  = gs_code
sToDate = gs_codename
sExpgu  = gs_gubun
sBalgu  = gs_codename2

/* ClipBoard의 내용을 copy한다 */
dw_auto.Reset()
rtn = dw_auto.ImportClipBoard()
nRowCnt = dw_auto.RowCount()

/* key check */
If rtn <=0 Then Return 0
If nRowCnt <= 0 Then Return 0

/* 선택된 row들을 update가능하도록 변경 */
For ix = 1 To nRowCnt
	rtn = dw_auto.SetItemStatus(ix, 0, Primary!, DataModified!)
	If rtn <> 1 Then
		MessageBox('dw_auto status modify failed','전산실로 연락하십시요!!')
		Return
	End If
Next

/* 거래처 설정 */
dw_insert.SetItem(1,'saupj',  dw_auto.GetItemString(1,'saupj'))	/*부가사업장 */
dw_insert.SetItem(1,'saledt',sTodate)

dw_insert.SetItem(1,'salegu', dw_auto.GetItemString(1,'salegu'))

/* 거래처 조회후 막음 */
SELECT "VNDMST"."CVNAS2", 		   "VNDMST"."SANO",  		 		"VNDMST"."UPTAE",   
		 "VNDMST"."JONGK",   		"VNDMST"."OWNAM",   				"VNDMST"."RESIDENT",   
		 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),	"VNDMST"."CVGU",  NVL("VNDMST"."SALESCOD" ,"VNDMST"."CVCOD")
  INTO :sCustName,   				:sCustSano,   						:sCustUpTae,   
		 :sCustUpjong,   				:sCustOwner,   					:sCustResident,
		 :sCustAddr,   														:sCustGbn , :sSaleCod
  FROM "VNDMST"  
 WHERE "VNDMST"."CVCOD" = :sCvcod;

dw_insert.SetItem(1,'cvcod',sCvcod)
dw_insert.SetItem(1,"cvnas",  sCustName)
dw_insert.SetItem(1,"sano",	  sCustSano)
dw_insert.SetItem(1,"ownam",  sCustOwner)
dw_insert.SetItem(1,"resident",sCustResident)
dw_insert.SetItem(1,"uptae",	sCustUptae)
dw_insert.SetItem(1,"jongk",	sCustUpjong)
dw_insert.SetItem(1,"addr1",   sCustAddr)
dw_insert.SetItem(1,"salecod",  sSaleCod)

dw_insert.Modify('cvcod.protect = 1')
dw_insert.Modify('saupj.protect = 1')

dTotGon = 0
dTotVat = 0
/* 품목이 4건 이상이면 일괄발행 */
If sBalgu = 'Y' Or nRowCnt > 4 Then
  
  dGonAmt = TRUNCATE(dw_auto.GetItemNumber(1,'sum_gonamt'), 0) /* 공급가액 */
  dVatAmt = dw_auto.GetItemNumber(1,'sum_vatamt') /* 부가세액 */
  dIoqty  = dw_auto.GetItemNumber(1,'sum_qty') /* 수량 */
  sPum    = dw_auto.GetItemString(1,'pum') + ' 외 ' + string(nRowcnt - 1)

	dw_insert.SetItem(nRow,'mmdd1',Mid(sTodate,5))
	dw_insert.Setitem(nRow,'pum1',sPum)
	dw_insert.SetItem(nRow,'gonamt1',dGonAmt)
	dw_insert.SetItem(nRow,'vatamt1',dVatAmt)
   dw_insert.SetItem(nRow,'qty1',dIoqty)
	
	dTotGon += dGonAmt
	dTotVat += dVatAmt
/* 품목이 4건 이하이면 건별발행 */
Else
  For ix = 1 To nRowCnt
	 dIoQty  = dw_auto.GetItemNumber(ix,'ioqty') 
	 dIoPrc  = dw_auto.GetItemNumber(ix,'ioprc')
    dGonAmt = TRUNCATE(dw_auto.GetItemNumber(ix,'gonamt'), 0) /* 공급가액 */
    dVatAmt = dw_auto.GetItemNumber(ix,'vatamt') /* 부가세액 */
    sPum    = dw_auto.GetItemString(ix,'pum')
    sIspec  = dw_auto.GetItemString(ix,'ispec')
	 
	 sSuDat  = dw_auto.GetItemString(ix,'sudat')	 

	 dw_insert.SetItem(nRow,'mmdd'+String(ix,'0'),   Mid(sSudat,5))
    dw_insert.Setitem(nRow,'pum'+String(ix,'0'),    sPum)
    dw_insert.Setitem(nRow,'size'+String(ix,'0'),   sIspec)
	 dw_insert.Setitem(nRow,'qty'+String(ix,'0'),    dIoQty)
	 dw_insert.Setitem(nRow,'uprice'+String(ix,'0'), dIoPrc)
    dw_insert.SetItem(nRow,'gonamt'+String(ix,'0'), dGonAmt)
    dw_insert.SetItem(nRow,'vatamt'+String(ix,'0'), dVatAmt)
	 
		dTotGon += dGonAmt
		dTotVat += dVatAmt
  Next
End If

// 화면에 보여주기 위한 공란수/공급가/부가세
SELECT LENGTH(to_char(:dTotGon,'0000000000')) - LENGTH(to_char(:dTotGon)),
		 to_char(:dTotGon,'9999999999'), to_char(:dtotVat,'999999999') INTO :iGon, :sStrAmt, :sStrVat FROM DUAL;
dw_insert.SetItem(nRow,'gong_cnt',iGon)
dw_insert.SetItem(nRow,'cgon_amt',sStrAmt)
dw_insert.SetItem(nRow,'cvat_amt',sStrVat)
	
If sExpGu = '1' Then
	dw_insert.SetItem(nRow,'tax_no','21')
	dw_insert.SetItem(nRow,'tax_no','21')
Else
	dw_insert.SetItem(nRow,'tax_no','24')
	dw_insert.SetItem(nRow,'expgu','2')
	dw_insert.SetItem(nRow,'vouc_gu','3')
End If
dw_insert.SetItem(nRow,'autobal_yn','Y')    /* 자동발행 여부 */
dw_insert.SetItem(nRow,'vatgbn','1')		  /* 부가세 업종구분 임의 지정 */

sAutoStatus = 'Y'

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"	
end event

type p_exit from w_inherite`p_exit within w_sal_05030
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_05030
integer y = 28
end type

event p_can::clicked;call super::clicked;
Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_05030
integer x = 3575
integer y = 28
end type

event p_print::clicked;call super::clicked;String  sSaleDate, sSaupj
Integer iSaleNo,Rcnt

If dw_insert.AcceptText() <> 1 Then Return


sSaleDate = dw_insert.GetItemString(1,"saledt")
sSaupj	 = dw_insert.GetItemString(1,"saupj")
iSaleNo   = dw_insert.GetItemNumber(1,"saleno")

dw_insert.SetFocus()
IF sSaleDate ="" OR IsNull(sSaleDate) THEN
	f_message_chk(30,'[발행일자]')
	dw_insert.SetColumn("saledt")
	Return 
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_insert.SetColumn("saupj")
	Return 
END IF

IF iSaleNo =0 OR IsNull(iSaleNo) THEN
	f_message_chk(30,'[발행번호]')
	dw_insert.SetColumn("saleno")
	Return 
END IF

Rcnt = dw_list.Retrieve(gs_sabu, sSaleDate,iSaleNo, ssaupj)
If Rcnt = 0 Then
	MessageBox('확인','출력할 데이타가 없습니다~r~n~r~n저장이나 조회후 출력하십시요!!')
	Return
End If

gi_page = rcnt
OpenWithParm(w_print_options, dw_list)
end event

type p_inq from w_inherite`p_inq within w_sal_05030
integer x = 3401
integer y = 28
end type

event p_inq::clicked;String  sSaleDate, sCheckNo, ls_saupj
Integer iSaleNo,nCnt, nCntExp

If dw_insert.AcceptText() <> 1 Then Return

ls_saupj  = dw_insert.GetItemString(1,"saupj")
sSaleDate = dw_insert.GetItemString(1,"saledt")
iSaleNo   = dw_insert.GetItemNumber(1,"saleno")

IF ls_saupj ="" OR IsNull(ls_saupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_insert.SetColumn("saupj")
	dw_insert.SetFocus()
	Return 
END IF

IF sSaleDate ="" OR IsNull(sSaleDate) THEN
	f_message_chk(30,'[발행일자]')
	dw_insert.SetColumn("saledt")
	dw_insert.SetFocus()
	Return 
END IF

IF iSaleNo =0 OR IsNull(iSaleNo) THEN
	f_message_chk(30,'[발행번호]')
	dw_insert.SetColumn("saleno")
	dw_insert.SetFocus()
	Return 
END IF

dw_insert.SetRedraw(False)
IF dw_insert.Retrieve(gs_sabu,sSaleDate,iSaleNo, ls_saupj) <=0 THEN
	f_message_chk(50,'')
	
	Wf_Init()
	dw_insert.SetRedraw(True)
	Return
ELSE
	dw_insert.Modify('saledt.protect = 1')

	dw_insert.Modify('saleno.protect = 1')
	
	dw_insert.SetColumn("checkno")
	dw_insert.SetFocus()
	
	/* 회계시스템 이월여부 */
   SELECT COUNT("KIF03OT0"."SABU" )
     INTO :nCnt  
     FROM "KIF03OT0"  
    WHERE ( "KIF03OT0"."SALEDT" = :sSaleDate ) AND  
          ( "KIF03OT0"."SALENO" = :iSaleNo )   ;

	/* 수출일 경우 수출매출 Interface 확인 */
	If dw_insert.GetItemString(1,'expgu') = '2' Then
		sCheckNo = dw_insert.GetItemString(1,'checkno')
		
		SELECT COUNT(*) INTO :nCntExp
		  FROM KIF05OT0
		 WHERE SABU = :gs_sabu AND
		       CINO IN ( 	SELECT CINO
								  FROM EXPCIH
								 WHERE CHECKNO = :sCheckNo );
		 		 
	End If
	
	If nCnt > 0 Or nCntExp > 0 Then
		p_del.Enabled = False
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"		
		p_mod.Enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"		
		w_mdi_frame.sle_msg.Text = '회계시스템으로 전송처리된 세금계산서입니다.!!'
	Else
		p_del.Enabled = True
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"		
		p_mod.Enabled = True
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"		
	End If
END IF
dw_insert.SetRedraw(True)
ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_sal_05030
integer y = 28
boolean enabled = false
end type

event p_del::clicked;call super::clicked;String  sCheckNo, sExpGu
Integer iCurRow,ncnt
Long    lSaleNo

IF dw_insert.AcceptText() = -1 THEN Return
iCurRow = dw_insert.GetRow()

If iCurRow <=0 Then 
  f_message_chk(36,'')
  Return
End If

lSaleNo  = dw_insert.GetItemNumber(icurrow,"saleno")
sCheckNo = dw_insert.GetItemString(iCurRow,'checkno')
sExpgu   = dw_insert.GetItemString(iCurRow,'expgu')

IF IsNull(lSaleNo) OR lSaleNo = 0 THEN
  f_message_chk(36,'')
  Return
END IF

IF IsNull(sCheckNo) OR sCheckNo = '' THEN
  f_message_chk(36,'일련번호')
  Return
END IF

IF F_Msg_Delete() = -1 THEN Return

SetPointer(HourGlass!)
/* saleh delete */
dw_insert.SetRedraw(False)
dw_insert.DeleteRow(iCurRow)
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

UPDATE "IMHIST"
   SET "CHECKNO" = null,
		 "YEBI4" = null 
 WHERE "IMHIST"."SABU" = :gs_sabu AND
       "IMHIST"."CHECKNO" = :sCheckNo   ;
 
If sqlca.sqlcode = 0 Then
  COMMIT;
Else
	f_message_chk(32,'')
	Rollback;
End If

/* 수출일 경우 CI CHECK NO DELETE */
If sExpgu = '2' Then
	UPDATE "EXPCIH"
		SET "CHECKNO" = null  
	 WHERE "EXPCIH"."CHECKNO" = :sCheckNo   ;
	 
	If sqlca.sqlcode = 0 Then
	  COMMIT;
	Else
		f_message_chk(32,'')
		Rollback;
	End If
End If

dw_insert.SetRedraw(True)

Wf_Init()
w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'

end event

type p_mod from w_inherite`p_mod within w_sal_05030
integer y = 28
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;Integer 	iMaxSaleNo,iMaxCheckNo,nRowCnt,ix
string  	sCheckNo,sSaleDate
Dec		ld_gonamt, ld_vatamt

/*필수 체크*/ 
if dw_insert.AcceptText() = -1 Then Return

If Wf_RequiredChk(dw_insert.DataObject,1) = -1 THEN Return

If F_Msg_Update() = -1 THEN Return

sSaleDate = dw_insert.GetItemString(1,"saledt")

IF sSaleDate ="" OR IsNull(sSaleDate) THEN
	f_message_chk(30,'[발행일자]')
	dw_insert.SetColumn("saledt")
	dw_insert.SetFocus()
	Return 
END IF

If rb_insert.Checked = True Then
  /* 전표번호 채번 */
  iMaxSaleNo = sqlca.fun_junpyo(gs_sabu,sSaleDate,'G0')
  IF iMaxSaleNo <= 0 THEN
     f_message_chk(51,'')
	  rollback;
     Return 1
  END IF	
  commit;
  
  dw_insert.SetItem(1,"saleno",iMaxSaleNo)

  /* 계산서 일련번호 채번 */
  iMaxCheckNo = wf_calc_checkno(gs_sabu,Left(sSaleDate,6))
  IF iMaxCheckNo <= 0 Or iMaxCheckNo > 9999 THEN
    f_message_chk(51,'일련번호')
    Return 1
  END IF	
  dw_insert.SetItem(1,"checkno",Left(sSaleDate,6) + Trim(String(iMaxCheckNo,'0000')))
Else
  iMaxSaleNo = dw_insert.GetItemNumber(1,"saleno")
End If

ld_gonamt = dw_insert.GetItemNumber(1, 'gonamt1') +&
				dw_insert.GetItemNumber(1, 'gonamt2') +&
				dw_insert.GetItemNumber(1, 'gonamt3') +&
				dw_insert.GetItemNumber(1, 'gonamt4')
				
ld_vatamt = dw_insert.GetItemNumber(1, 'vatamt1') +&
				dw_insert.GetItemNumber(1, 'vatamt2') +&
				dw_insert.GetItemNumber(1, 'vatamt3') +&
				dw_insert.GetItemNumber(1, 'vatamt4')				

dw_insert.SetItem(1,"sabu", gs_sabu)
dw_insert.SetItem(1, "gon_amt", ld_gonamt)
dw_insert.SetItem(1, "vat_amt", ld_vatamt)


/* 자동발행으로 생성된 경우 : imhist에 세금계산서 출력됨을 기록한다 */
If sAutoStatus = 'Y' Then
	nRowCnt = dw_auto.RowCount()
	If nRowCnt <= 0 Then Return
	
	sCheckNo = dw_insert.GetItemString(1,"checkno")
	
	IF sCheckNo ="" OR IsNull(sCheckNo) THEN
	  f_message_chk(30,'[계산서일련번호]')
	  dw_insert.SetColumn("checkno")
	  dw_insert.SetFocus()
	  rollback;
	  Return 
   END IF
	
	For ix = 1 to nRowCnt
		dw_auto.SetItem(ix,'checkno',sCheckNo)  // 세금계산서번호
		dw_auto.Setitem(ix,'yebi4', dw_insert.GetItemString(1,"saledt")) // 세금계산서일자
	Next
	
	IF dw_auto.Update() <> 1 THEN
	   ROLLBACK;
	   Return
   END IF
End If

/* IMHIST 저장후 SALEH를 저장한다. SALEH TRIGGER에서 부가세 끝전차이를 조정함 */
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'

IF MessageBox("확 인","세금계산서를 출력하시겠습니까?",Question!,YesNo!) = 1 THEN 
	p_print.TriggerEvent(Clicked!)
END IF

Wf_Init()


end event

type cb_exit from w_inherite`cb_exit within w_sal_05030
integer x = 3131
integer y = 3048
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_05030
integer x = 2089
integer y = 3048
integer taborder = 50
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05030
integer x = 3739
integer y = 3172
integer width = 718
integer height = 132
integer taborder = 90
boolean enabled = false
string text = "건별 발행(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_05030
integer x = 2437
integer y = 3048
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05030
integer x = 59
integer y = 3048
integer taborder = 30
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_05030
integer x = 407
integer y = 3048
integer width = 539
integer taborder = 40
boolean enabled = false
string text = "계산서 출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_05030
integer y = 3196
end type

type cb_can from w_inherite`cb_can within w_sal_05030
integer x = 2784
integer y = 3048
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_05030
integer x = 256
integer y = 2876
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_05030
integer y = 3196
end type

type sle_msg from w_inherite`sle_msg within w_sal_05030
integer y = 3196
end type

type gb_10 from w_inherite`gb_10 within w_sal_05030
integer y = 3144
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_05030
integer y = 3416
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05030
integer y = 3440
end type

type dw_list from datawindow within w_sal_05030
boolean visible = false
integer x = 3872
integer y = 2636
integer width = 119
integer height = 156
boolean bringtotop = true
boolean titlebar = true
string title = "세금계산서 출력양식"
string dataobject = "d_sal_05030_list"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_modify from radiobutton within w_sal_05030
integer x = 306
integer y = 72
integer width = 224
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;sModStatus = 'M'											/*수정*/

Wf_Init()
end event

type rb_insert from radiobutton within w_sal_05030
integer x = 55
integer y = 72
integer width = 224
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*등록*/
Wf_Init()

p_del.Enabled = True
end event

type dw_auto from datawindow within w_sal_05030
boolean visible = false
integer x = 4151
integer y = 2660
integer width = 151
integer height = 176
boolean bringtotop = true
string dataobject = "d_sal_05030_auto"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

type pb_1 from u_pb_cal within w_sal_05030
integer x = 1115
integer y = 308
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
DW_INSERT.SetColumn('saledt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
DW_INSERT.SetItem(1, 'saledt', gs_code)

end event

type rr_4 from roundrectangle within w_sal_05030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 36
integer width = 535
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

