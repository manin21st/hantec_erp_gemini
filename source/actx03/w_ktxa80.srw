$PBExportHeader$w_ktxa80.srw
$PBExportComments$세금계산서합계표(2009년2기확정변경)
forward
global type w_ktxa80 from w_inherite
end type
type tab_vat from tab within w_ktxa80
end type
type tabpage_process from userobject within tab_vat
end type
type rr_1 from roundrectangle within tabpage_process
end type
type dw_process from u_key_enter within tabpage_process
end type
type tabpage_process from userobject within tab_vat
rr_1 rr_1
dw_process dw_process
end type
type tabpage_print1 from userobject within tab_vat
end type
type rr_2 from roundrectangle within tabpage_print1
end type
type dw_print from datawindow within tabpage_print1
end type
type tabpage_print1 from userobject within tab_vat
rr_2 rr_2
dw_print dw_print
end type
type tabpage_print2 from userobject within tab_vat
end type
type rr_3 from roundrectangle within tabpage_print2
end type
type dw_print2 from datawindow within tabpage_print2
end type
type tabpage_print2 from userobject within tab_vat
rr_3 rr_3
dw_print2 dw_print2
end type
type tab_vat from tab within w_ktxa80
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type
type rb_1 from radiobutton within w_ktxa80
end type
type rb_2 from radiobutton within w_ktxa80
end type
type dw_file from datawindow within w_ktxa80
end type
type gb_1 from groupbox within w_ktxa80
end type
end forward

global type w_ktxa80 from w_inherite
integer height = 2456
string title = "세금계산서합계표 신고서,디스켓 처리"
tab_vat tab_vat
rb_1 rb_1
rb_2 rb_2
dw_file dw_file
gb_1 gb_1
end type
global w_ktxa80 w_ktxa80

type variables
//
String   sRptPath,sApplyFlag,IsCommJasa
Integer  Ii_TotalCnt = 0
end variables

forward prototypes
public function integer wf_maiip_vat ()
public function integer wf_maichul_vat ()
public function integer wf_requiredchk (integer curr_row)
public function integer wf_summary_maichul (string sfdate, string stdate, string sjasa, string sjasasano)
public function integer wf_summary_maiip (string sfdate, string stdate, string sjasa, string sjasasano)
end prototypes

public function integer wf_maiip_vat ();string sVatGisu,sDatefrom, sDateto,sJaSaCod,sCrtDate,sGisu,sDateTerm
Int il_currow, il_RetrieveRow, i, il_dvdval


tab_vat.tabpage_process.dw_process.AcceptText()

sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") //부가세기수
sDatefrom = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))//
sDateto   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
sJasaCod = tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"code") //자사코드
sCrtDate = Trim(tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"kfz_vat_title_cdate"))//작성일자

//작성일자
IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@년 @@월 @@일')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@년 @@월 @@일')	
END IF

tab_vat.tabpage_print1.dw_print.Reset()
tab_vat.tabpage_print2.dw_print2.Reset()

tab_vat.tabpage_print1.dw_print.Modify("crtdate_t.text = '"+sCrtDate+"'")

sDateTerm = String(sDatefrom,'@@@@.@@.@@') + " - "+String(sDateto,'@@@@.@@.@@')
tab_vat.tabpage_print1.dw_print.Modify("t_dateterm.text = '"+sDateTerm + "'")

select SUBSTR(RFNA1,1,1) into :sGisu from reffpf where rfcod ='AV' and rfgub = :svatgisu ;
tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sGisu+' 기 )'
tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sGisu+' 기 )'

IF tab_vat.tabpage_print1.dw_print.Retrieve(sDatefrom,sDateto,sJasaCod) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	tab_vat.tabpage_print2.dw_print2.Retrieve(sDatefrom,sDateto,sJasaCod) 
END IF

il_RetrieveRow =tab_vat.tabpage_print1.dw_print.RowCount()
il_currow = tab_vat.tabpage_print2.dw_print2.RowCount()

IF il_RetrieveRow < 5 THEN
	il_dvdval =Mod(il_RetrieveRow,5)
	IF il_dvdval =0 THEN
	ELSE
		String sTmp_Saupno
		sTmp_Saupno = tab_vat.tabpage_print1.dw_print.GetItemString(1,"saupno2")
		if sTmp_Saupno = '' or IsNull(sTmp_Saupno) then
			tab_vat.tabpage_print1.dw_print.SetItem(1,"seq_no",1 )		
		end if
		FOR i =il_dvdval TO 4 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
		   tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seq_no",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_vat.tabpage_print2.dw_print2.InsertRow(0)
		NEXT
	END IF
END IF

w_mdi_frame.sle_msg.text ="매입처별 세금계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

return 1


end function

public function integer wf_maichul_vat ();string sVatGisu,sDatefrom, sDateto,sJaSaCod,sCrtDate,sGisu, sDateTerm
Int il_RetrieveRow ,il_currow, i, il_dvdval

tab_vat.tabpage_process.dw_process.AcceptText()

sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") //부가세기수
sDatefrom = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))//
sDateto   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
sJasaCod = tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"code") //자사코드
sCrtDate = Trim(tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"kfz_vat_title_cdate"))//작성일자

//작성일자
IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@년 @@월 @@일')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@년 @@월 @@일')	
END IF

tab_vat.tabpage_print1.dw_print.Reset()
tab_vat.tabpage_print2.dw_print2.Reset()

tab_vat.tabpage_print1.dw_print.Modify("crtdate_t.text = '"+sCrtDate+"'")

sDateTerm = String(sDatefrom,'@@@@.@@.@@') + " - "+String(sDateto,'@@@@.@@.@@')
tab_vat.tabpage_print1.dw_print.Modify("t_dateterm.text = '"+sDateTerm+"'")

select SUBSTR(RFNA1,1,1) into :sGisu from reffpf where rfcod ='AV' and rfgub = :svatgisu ;
tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sGisu+' 기 )'
tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sGisu+' 기 )'

IF tab_vat.tabpage_print1.dw_print.Retrieve(sDatefrom,sDateto,sJasaCod) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	tab_vat.tabpage_print2.dw_print2.Retrieve(sDatefrom,sDateto,sJasaCod) 
END IF

il_RetrieveRow =tab_vat.tabpage_print1.dw_print.RowCount()
il_currow = tab_vat.tabpage_print2.dw_print2.RowCount()

IF il_RetrieveRow < 5 THEN
	il_dvdval =Mod(il_RetrieveRow,5)
	IF il_dvdval =0 THEN
	ELSE
		String sTmp_Saupno
		sTmp_Saupno = tab_vat.tabpage_print1.dw_print.GetItemString(1,"saupno2")
		if sTmp_Saupno = '' or IsNull(sTmp_Saupno) then
			tab_vat.tabpage_print1.dw_print.SetItem(1,"seqno",1 )		
		end if

		FOR i =il_dvdval TO 4 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
			tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seqno",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_vat.tabpage_print2.dw_print2.InsertRow(0)
		NEXT
	END IF
END IF

w_mdi_frame.sle_msg.text ="매출처별 세금계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

return 1


end function

public function integer wf_requiredchk (integer curr_row);String sVatGisu,sdate,edate,jak_date,jacode,sBaseGbn,sProcGbn
Long jachul

sBaseGbn = tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"gubun")
IF sBaseGbn = '1' THEN										/*신고기수 기준*/
	sVatGisu = tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"vatgisu")
	IF sVatGisu ="" OR IsNull(sVatGisu) THEN
		f_messagechk(1,"부가세 기수")
		tab_vat.tabpage_process.dw_process.SetColumn("vatgisu")
		tab_vat.tabpage_process.dw_process.SetFocus()
		RETURN -1
	END IF   	
ELSE
	sdate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"kfz_vat_title_sdate"))
	IF sdate ="" OR IsNull(sdate) THEN
		f_messagechk(1,"거래기간(FROM)")
		tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_sdate")
		tab_vat.tabpage_process.dw_process.SetFocus()
		RETURN -1
	END IF   	
	edate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"kfz_vat_title_edate"))
	IF edate ="" OR IsNull(edate) THEN
		f_messagechk(1,"거래기간(TO)")
		tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_edate")
		tab_vat.tabpage_process.dw_process.SetFocus()
		RETURN -1
	END IF	
END IF

jak_date = Trim(tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"kfz_vat_title_cdate"))
IF jak_date ="" OR IsNull(jak_date) THEN 
	f_messagechk(1,"작성일자")
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_cdate")
	tab_vat.tabpage_process.dw_process.SetFocus()
   RETURN -1
END IF	
	
jachul = tab_vat.tabpage_process.dw_process.GetItemNumber(curr_row,"kfz_maichul_list_jechul_code")
IF jachul =0 OR IsNull(jachul) THEN 
	f_messagechk(1,"제출서")
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_maichul_list_jechul_code")
	tab_vat.tabpage_process.dw_process.SetFocus()
   RETURN -1
END IF	

jacode = tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"code")	
IF jacode ="" OR IsNull(jacode) THEN 
	f_messagechk(1,"자사코드")
	tab_vat.tabpage_process.dw_process.SetColumn("code")
	tab_vat.tabpage_process.dw_process.SetFocus()
  RETURN -1
END IF

Return 1
end function

public function integer wf_summary_maichul (string sfdate, string stdate, string sjasa, string sjasasano);String  sSaupNo, sCvnas, sUptae, sJongk
Long    lCount,iGonAmtLen,ll_jechul_code
Integer iZeroCnt,il_cursor_cnt
Double  dGonAmt, dVatAmt

ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

DECLARE Cur_MaiChulLst CURSOR FOR          //매출내역
    select a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' '),
//           rpad(nvl(b.uptae,' '),17,' '),
//           rpad(nvl(b.jongk,' '),25,' '),
			  '',
			  '',
           nvl(sum(decode(a.taxgbn,'Y',1,0)),0) AS ll_count,
           sum(nvl(a.gon_amt,0)),
           sum(nvl(a.vat_amt,0))
    from kfz17ot0 a, vndmst b, reffpf c, reffpf d
    where ( a.saup_no = b.cvcod(+)) AND
          ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
          ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND (substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
          (a.jasa_cd LIKE :sjasa ) AND
          ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
           ( a.io_gu ='2') AND
           ( a.tax_no LIKE '2%') AND
           ( a.tax_no <> '22') AND
           ( a.tax_no <> '27') AND
           ( a.tax_no <> '2A') AND
			  ( NVL(a.mbill,0) <> 1 ) AND
           ( a.alc_gu ='Y') AND
			  ( ( a.elegbn = '1' ) or 
			    ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' )
			  )
    group by a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' ')
//			  ,
//           rpad(nvl(b.uptae,' '),17,' '),
//           rpad(nvl(b.jongk,' '),25,' ')
           ;

il_cursor_cnt = 1

OPEN Cur_MaiChulLst;
DO  WHILE True
	FETCH Cur_MaiChulLst INTO :sSaupNo,	:sCvnas,		:sUptae,		:sJongk,   :lCount,	:dGonAmt,	:dVatAmt ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	IF IsNull(lCount) then lCount = 0
	IF IsNull(dGonAmt) THEN dGonAmt =0
	IF IsNull(dVatAmt) THEN dVatAmt =0

	w_mdi_frame.sle_msg.text ="부가세 집계 - 매출자료 ["+sSaupNo+']'
	
	if Trim(sCvnas) = '' or IsNull(Trim(sCvnas)) then
		MessageBox('확인','거래처를 찾을 수 없습니다')
		return -1
	end if
		
	iGonAmtLen =Len(String(Abs(dGonAmt)))

	iZeroCnt = 14 - iGonAmtLen

	INSERT INTO "KFZ_SEGUM_MAICHUL_LIST"  
		( "RPT_FR",				"RPT_TO",			"JASACD",
		  "GUBUN",				"SAUPNO1",			"SEQNO",				"SAUPNO2",			
		  "SANGHO2",			"UPTAE2",			"UPJONG2",			"MAICHUL_CNT",
		  "ZERO_CNT",			"GON_AMT",			"VAT_AMT",			"JUGU1",
		  "JUGU2",				"GUAN_NO",			"JECHUL_CODE",		"BIGO" )  
	VALUES ( :sfdate,			:stdate,				:sJasa,
				'1',				:sJasaSano,			:il_cursor_cnt,	:sSaupNo,
				:sCvnas,			:sUptae,				:sJongk,		   	:lCount,
				:iZeroCnt,		:dGonAmt,			:dVatAmt,			0,
				0,					7501,					:ll_jechul_code,	'' )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
		MessageBox("확 인","매출자료 처리 실패 : 사업자번호 - "+String(sSaupNo,'@@@-@@-@@@@@') + "~n"+&
								 +sqlca.sqlerrtext)

		close Cur_MaiChulLst;
		Return -1
	END IF
	il_cursor_cnt +=1
LOOP
CLOSE Cur_MaiChulLst;

//매출처,매수,공급가액,세액(사업자등록분-전자세금이외분)
Long    lSaupCnt21, lTaxCnt21, lSaupCnt22, lTaxCnt22
Double  dGonAmt21, dVatAmt21, dGonAmt22, dVatAmt22
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0)),  sum(nvl(a.vat_amt,0))
	 into :lSaupCnt21,               :lTaxCnt21,                            :dGonAmt21,             :dVatAmt21
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND(substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 ( a.jasa_cd LIKE :sjasa ) AND ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='2') AND ( a.tax_no LIKE '2%') AND ( a.tax_no <> '22') AND ( a.tax_no <> '27') AND ( a.tax_no <> '2A') AND
			 ( NVL(a.mbill,0) <> 1 ) AND ( a.alc_gu ='Y') and
			 ( ( a.elegbn = '1' ) or
			   ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt21 = 0; lTaxCnt21  = 0;  dGonAmt21 = 0;  dVatAmt21 = 0;
else
	if IsNull(lSaupCnt21) then lSaupCnt21 = 0
	if IsNull(lTaxCnt21) then lTaxCnt21 = 0
	if IsNull(dGonAmt21) then dGonAmt21 = 0
	if IsNull(dVatAmt21) then dVatAmt21 = 0
end if;

//매출처,매수,공급가액,세액(주민번호분-전자세금이외분)
select count(distinct a.saup_no),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0), sum(nvl(a.gon_amt,0)), sum(nvl(a.vat_amt,0))
	 into :lSaupCnt22,               :lTaxCnt22,                            :dGonAmt22,           :dVatAmt22
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND(substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 (a.jasa_cd LIKE :sjasa  ) AND ( a.acc_date >= :sfdate  ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='2') AND ( a.tax_no IN ('22','2A') ) AND
			 ( NVL(a.mbill,0) <> 1 ) AND ( a.alc_gu ='Y') and 
			 ( ( a.elegbn = '1' ) or 
			   ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt22 = 0; lTaxCnt22  = 0;  dGonAmt22 = 0;  dVatAmt22 = 0;
else
	if IsNull(lSaupCnt22) then lSaupCnt22 = 0
	if IsNull(lTaxCnt22) then lTaxCnt22 = 0
	if IsNull(dGonAmt22) then dGonAmt22 = 0
	if IsNull(dVatAmt22) then dVatAmt22 = 0
end if;

insert into kfz_segum_maichul_hap
	 ( rpt_fr,			rpt_to,		jasacd,		 gubun,         saupno,     
	   hap_maichul_cnt,     hap_segum_nbr,     hap_gon_amt,       hap_vat_amt,
		saup_maichul_cnt,    saup_segum_nbr,    saup_gon_amt,      saup_vat_amt,
		person_maichul_cnt,  person_segum_nbr,  person_gon_amt,    person_vat_amt)
values
 	( :sfdate,			:stdate,		:sJasa,		 '3',            :sJasaSano,        
	  :lSaupCnt21 + :lSaupCnt22,  :lTaxCnt21 + :lTaxCnt22,    :dGonAmt21 + :dGonAmt22,    :dVatAmt21 + :dVatAmt22,
	  :lSaupCnt21,          :lTaxCnt21,        :dGonAmt21,        :dVatAmt21,
	  :lSaupCnt22,          :lTaxCnt22,        :dGonAmt22,        :dVatAmt22);
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox('확 인','매출합계 저장 실패(전자세금이외분)!!')
	return -1
end if    

//매출처,매수,공급가액,세액(사업자등록분-전자세금분)
Long    lSaupCnt21_Ele, lTaxCnt21_Ele, lSaupCnt22_Ele, lTaxCnt22_Ele
Double  dGonAmt21_Ele, dVatAmt21_Ele, dGonAmt22_Ele, dVatAmt22_Ele
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0)),  sum(nvl(a.vat_amt,0))
	 into :lSaupCnt21_Ele,           :lTaxCnt21_Ele,                        :dGonAmt21_Ele,             :dVatAmt21_Ele
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND(substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 ( a.jasa_cd LIKE :sjasa ) AND ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='2') AND ( a.tax_no LIKE '2%') AND ( a.tax_no <> '22') AND ( a.tax_no <> '27') AND ( a.tax_no <> '2A') AND
			 ( NVL(a.mbill,0) <> 1 ) AND ( a.alc_gu ='Y') and 
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt21_Ele = 0; lTaxCnt21_Ele  = 0;  dGonAmt21_Ele = 0;  dVatAmt21_Ele = 0;
else
	if IsNull(lSaupCnt21_Ele) then lSaupCnt21_Ele = 0
	if IsNull(lTaxCnt21_Ele) then lTaxCnt21_Ele = 0
	if IsNull(dGonAmt21_Ele) then dGonAmt21_Ele = 0
	if IsNull(dVatAmt21_Ele) then dVatAmt21_Ele = 0	
end if;

//매출처,매수,공급가액,세액(주민번호분-전자세금분)
select count(distinct a.saup_no),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0), sum(nvl(a.gon_amt,0)), sum(nvl(a.vat_amt,0))
	 into :lSaupCnt22_Ele,           :lTaxCnt22_Ele,                       :dGonAmt22_Ele,        :dVatAmt22_Ele
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND(substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 (a.jasa_cd LIKE :sjasa  ) AND ( a.acc_date >= :sfdate  ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='2') AND ( a.tax_no IN ('22','2A') ) AND
			 ( NVL(a.mbill,0) <> 1 ) AND ( a.alc_gu ='Y') and 
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt22_Ele = 0; lTaxCnt22_Ele  = 0;  dGonAmt22_Ele = 0;  dVatAmt22_Ele = 0;
else
	if IsNull(lSaupCnt22_Ele) then lSaupCnt22_Ele = 0
	if IsNull(lTaxCnt22_Ele) then lTaxCnt22_Ele = 0
	if IsNull(dGonAmt22_Ele) then dGonAmt22_Ele = 0
	if IsNull(dVatAmt22_Ele) then dVatAmt22_Ele = 0	
end if;

if dGonAmt21_Ele + dGonAmt22_Ele <> 0 then
	insert into kfz_segum_maichul_hap
		 ( rpt_fr,			rpt_to,		jasacd,		 gubun,         saupno,     
			hap_maichul_cnt,     
			hap_segum_nbr,     
			hap_gon_amt,       
			hap_vat_amt,
			saup_maichul_cnt,    saup_segum_nbr,    saup_gon_amt,      saup_vat_amt,
			person_maichul_cnt,  person_segum_nbr,  person_gon_amt,    person_vat_amt)
	values
		( :sfdate,			:stdate,		:sJasa,		 '5',            :sJasaSano,        
		  :lSaupCnt21_Ele + :lSaupCnt22_Ele,  
		  :lTaxCnt21_Ele + :lTaxCnt22_Ele,    
		  :dGonAmt21_Ele + :dGonAmt22_Ele,    
		  :dVatAmt21_Ele + :dVatAmt22_Ele,
		  :lSaupCnt21_Ele,      :lTaxCnt21_Ele,    :dGonAmt21_Ele,    :dVatAmt21_Ele,
		  :lSaupCnt22_Ele,      :lTaxCnt22_Ele,    :dGonAmt22_Ele,    :dVatAmt22_Ele);
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox('확 인','매출합계 저장 실패(전자세금분)!!')
		return -1
	end if    
end if
commit;

return 1
end function

public function integer wf_summary_maiip (string sfdate, string stdate, string sjasa, string sjasasano);String  sSaupNo, sCvnas, sUptae, sJongk
Long    lCount,iGonAmtLen,ll_jechul_code
Integer iZeroCnt,il_cursor_cnt
Double  dGonAmt, dVatAmt

ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

DECLARE Cur_MaiIplLst CURSOR FOR          //매입내역
    select a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' '),
			  '',
			  '',
//           rpad(nvl(b.uptae,' '),17,' '),
//           rpad(nvl(b.jongk,' '),25,' '),
           nvl(sum(decode(a.taxgbn,'Y',1,0)),0) AS ll_count,
           sum(nvl(a.gon_amt,0)),
           sum(nvl(a.vat_amt,0))
    from kfz17ot0 a, vndmst b, reffpf c, reffpf d
    where ( a.saup_no = b.cvcod(+)) AND
          ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
          ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND (substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
          (a.jasa_cd LIKE :sjasa ) AND
          ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
           ( a.io_gu ='1') AND
           ( a.tax_no LIKE '1%') AND
           ( a.alc_gu ='Y') and 
			  ( ( a.elegbn = '1' ) or 
			    ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' )
			  )
    group by a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' ')
			  //,
           //rpad(nvl(b.uptae,' '),17,' '),
           //rpad(nvl(b.jongk,' '),25,' ')
			  ;

il_cursor_cnt = 1

OPEN Cur_MaiIplLst;
DO  WHILE True
	FETCH Cur_MaiIplLst INTO :sSaupNo,	:sCvnas,		:sUptae,		:sJongk,   :lCount,	:dGonAmt,	:dVatAmt ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	IF IsNull(lCount) then lCount = 0
	IF IsNull(dGonAmt) THEN dGonAmt =0
	IF IsNull(dVatAmt) THEN dVatAmt =0

	w_mdi_frame.sle_msg.text ="부가세 집계 - 매입자료 ["+sSaupNo+']'
	
	if Trim(sCvnas) = '' or IsNull(Trim(sCvnas)) then
		MessageBox('확인','거래처를 찾을 수 없습니다')
		return -1
	end if
		
	iGonAmtLen =Len(String(Abs(dGonAmt)))

	iZeroCnt = 14 - iGonAmtLen

	INSERT INTO kfz_segum_maiip_list
		 ( rpt_fr,			  rpt_to,			jasacd,			 gubun,        	saupno1,        
		   seq_no,          saupno2,        sangho2,        uptae2,        	upjong2,        
			mai_cnt,			  zero_cnt,       gon_amt,        vat_amt,         jugu1,            
			jugu2,           guan_no,    		jechul_cd,      bigo)
	values
		 ( :sfdate,			  :stdate,		   :sJasa,			 '2',             :sJasaSano,            
		   :il_cursor_cnt,  :sSaupNo,       :sCvnas,        :sUptae,    		:sJongk,        
			:lCount,			  :iZeroCnt,      :dGonAmt,       :dVatAmt,        0,                
			0,                8501,        	:ll_jechul_code, ' ');                    
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
		MessageBox("확 인","매입자료 처리 실패 : 사업자번호 - "+String(sSaupNo,'@@@-@@-@@@@@') + "~n"+&
								 +sqlca.sqlerrtext)

		close Cur_MaiIplLst;
		Return -1
	END IF
	il_cursor_cnt +=1
LOOP
CLOSE Cur_MaiIplLst;

//매입처수, 매수, 공급가액, 부가세(사업자등록분-전자세금이외분)
Long    lSaupCnt21, lTaxCnt21, lSaupCnt22, lTaxCnt22
Double  dGonAmt21, dVatAmt21, dGonAmt22, dVatAmt22

select count(distinct a.saup_no2), nvl(sum(decode(a.taxgbn,'Y',1,0)),0), sum(nvl(a.gon_amt,0)), sum(nvl(a.vat_amt,0))
	 into :lSaupCnt21,              :lTaxCnt21,                           :dGonAmt21,            :dVatAmt21
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND  ( substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 ( a.jasa_cd LIKE :sjasa ) AND
			 ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='1') AND ( a.tax_no LIKE '1%') AND ( a.alc_gu ='Y') and 
			 ( ( a.elegbn = '1' ) or 
			    ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' )
			  );
if sqlca.sqlcode <> 0 then
	lSaupCnt21 = 0; lTaxCnt21  = 0;  dGonAmt21 = 0;  dVatAmt21 = 0;
else
	if IsNull(lSaupCnt21) then lSaupCnt21 = 0
	if IsNull(lTaxCnt21) then lTaxCnt21 = 0
	if IsNull(dGonAmt21) then dGonAmt21 = 0
	if IsNull(dVatAmt21) then dVatAmt21 = 0
end if;

//매입처수, 매수, 공급가액, 부가세(개인분-전자세금이외분)
lSaupCnt22 = 0; lTaxCnt22  = 0;  dGonAmt22 = 0;  dVatAmt22 = 0;

insert into kfz_segum_maiip_hap
	( rpt_fr,					rpt_to,					jasacd,				gubun,        saupno,        
	  hap_maichul_cnt,    	
	  hap_segum_nbr,    	
	  hap_gon_amt,    	
	  hap_vat_amt,
	  saup_maichul_cnt,     saup_segum_nbr,      saup_gon_amt,     saup_vat_amt, 
     per_maichul_cnt,      per_segum_nbr,       per_gon_amt,      per_vat_amt)
values
    ( :sfdate,			:stdate,			:sjasa,		 '4',         :sJasaSano,        
	   :lSaupCnt21 + :lSaupCnt22,    
		:lTaxCnt21 + :lTaxCnt22,    
		:dGonAmt21 + :dGonAmt22,  
		:dVatAmt21 + :dVatAmt22,  
	   :lSaupCnt21,   		:lTaxCnt21,    		:dGonAmt21,  		:dVatAmt21,  
		:lSaupCnt22,   		:lTaxCnt22,    		:dGonAmt22,  		:dVatAmt22);
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox('확 인','매입합계 저장 실패(전자세금이외분)!!')
	return -1
end if 

//매입처수, 매수, 공급가액, 부가세(사업자등록분-전자세금분)
Long    lSaupCnt21_Ele, lTaxCnt21_Ele, lSaupCnt22_Ele, lTaxCnt22_Ele
Double  dGonAmt21_Ele, dVatAmt21_Ele, dGonAmt22_Ele, dVatAmt22_Ele

select count(distinct a.saup_no2), nvl(sum(decode(a.taxgbn,'Y',1,0)),0), sum(nvl(a.gon_amt,0)), sum(nvl(a.vat_amt,0))
	 into :lSaupCnt21_Ele,          :lTaxCnt21_Ele,                       :dGonAmt21_Ele,        :dVatAmt21_Ele
	 from kfz17ot0 a, vndmst b, reffpf c, reffpf d
	 where ( a.saup_no = b.cvcod(+)) AND
			 ( a.tax_no  = c.rfgub ) and ( c.rfcod = 'AT') AND ( c.rfgub  <> '00') AND ( substr(c.rfna2,1,1) ='1') AND
			 ( a.jasa_cd = d.rfgub ) and ( d.rfcod = 'JA') AND ( d.rfgub <> '00') AND  ( substr(d.rfna2,1,1) LIKE :sApplyFlag ) AND
			 ( a.jasa_cd LIKE :sjasa ) AND
			 ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
			 ( a.io_gu ='1') AND ( a.tax_no LIKE '1%') AND ( a.alc_gu ='Y') and 
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt21_Ele = 0; lTaxCnt21_Ele  = 0;  dGonAmt21_Ele = 0;  dVatAmt21_Ele = 0;
end if;

//매입처수, 매수, 공급가액, 부가세(개인분-전자세금분)
lSaupCnt22_Ele = 0; lTaxCnt22_Ele  = 0;  dGonAmt22_Ele = 0;  dVatAmt22_Ele = 0;

if dGonAmt21_Ele + dGonAmt22_Ele <> 0 then
	insert into kfz_segum_maiip_hap
		( rpt_fr,					rpt_to,					jasacd,				gubun,        saupno,        
		  hap_maichul_cnt,    	
		  hap_segum_nbr,    	
		  hap_gon_amt,    	
		  hap_vat_amt,
		  saup_maichul_cnt,     saup_segum_nbr,      saup_gon_amt,     saup_vat_amt, 
		  per_maichul_cnt,      per_segum_nbr,       per_gon_amt,      per_vat_amt)
	values
		 ( :sfdate,			:stdate,			:sjasa,		 '6',         :sJasaSano,        
			:lSaupCnt21_Ele + :lSaupCnt22_Ele,    
			:lTaxCnt21_Ele + :lTaxCnt22_Ele,    
			:dGonAmt21_Ele + :dGonAmt22_Ele,  
			:dVatAmt21_Ele + :dVatAmt22_Ele,  
			:lSaupCnt21_Ele,   		:lTaxCnt21_Ele,    		:dGonAmt21_Ele,  		:dVatAmt21_Ele,  
			:lSaupCnt22_Ele,   		:lTaxCnt22_Ele,    		:dGonAmt22_Ele,  		:dVatAmt22_Ele);
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox('확 인','매입합계 저장 실패(전자세금분)!!')
		return -1
	end if 
end if
commit;
return 1
end function

event open;call super::open;String mm,dd,sJasa,sSano,sName,sJasaName,sUptae,sUpjong,sAddr,sStart,sEnd,sVatGisu,sPath
		 
tab_vat.tabpage_process.dw_process.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)
dw_file.SetTransObject(SQLCA)

/*저장위치*/
select dataname	into :sPath	from syscnfg where sysgu = 'A' and serial = 15 and lineno = '2';
if sPath = '' or IsNull(sPath) then sPath = 'c:\'

SELECT "VNDMST"."CVCOD",   "VNDMST"."SANO",   "VNDMST"."OWNAM",   
		 "VNDMST"."CVNAS",   "VNDMST"."UPTAE",  "VNDMST"."JONGK",
		 NVL("VNDMST"."ADDR1",' ') || NVL("VNDMST"."ADDR2",' ')  
	INTO :sJasa,   			:sSano,   			 :sName,   
        :sJasaName,   		:sUptae,   			 :sUpjong,   
        :sAddr  
	FROM "VNDMST","SYSCNFG"  
   WHERE "VNDMST"."CVCOD" = SUBSTR("SYSCNFG"."DATANAME",1,6) AND
			"SYSCNFG"."SYSGU" = 'C' AND
			"SYSCNFG"."SERIAL" = 4 AND "SYSCNFG"."LINENO" = '1';

sVatGisu = F_Get_VatGisu(gs_saupj,f_today())
										
SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
	INTO :sStart,								:sEnd  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;

tab_vat.tabpage_process.dw_process.Reset()
tab_vat.tabpage_process.dw_process.InsertRow(0)

tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"saupj",    gs_saupj)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu",  sVatGisu)

tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate",Left(f_Today(),4)+sStart)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate",Left(f_Today(),4)+sEnd)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate",F_today())
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"code",sJasa)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno",sSano)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sname",sName)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sangho",sJasaName)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_uptae",sUptae)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_upjong",sUpjong)
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_addr",sAddr)

tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"spath",   sPath)

tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_sdate")
tab_vat.tabpage_process.dw_process.SetFocus()

tab_vat.SelectedTab = 1
end event

on w_ktxa80.create
int iCurrent
call super::create
this.tab_vat=create tab_vat
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_file=create dw_file
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_vat
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_file
this.Control[iCurrent+5]=this.gb_1
end on

on w_ktxa80.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_vat)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_file)
destroy(this.gb_1)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa80
boolean visible = false
integer x = 645
integer y = 2484
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa80
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa80
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa80
integer x = 4069
integer y = 20
integer taborder = 0
string picturename = "C:\erpman\image\자료생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

event p_search::clicked;call super::clicked;String  s_jasacode, ls_sdate, ls_edate,  ls_date, ls_saupno,ls_sanho,sProcGbn,sPath,sSaveFile
Long    ll_jechul_code
Integer iCount

tab_vat.tabpage_process.dw_process.AcceptText()

IF wf_requiredchk(tab_vat.tabpage_process.dw_process.GetRow()) = -1 THEN RETURN 

ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
ls_date        = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate"))
ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")
s_jasacode     = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"code")
ls_saupno      = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")
ls_sanho       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sangho")

IF ls_date ="" OR IsNull(ls_date) THEN
	F_MessageChk(1,'[작성일자]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_cdate")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF

IF IsNull(ll_jechul_code) THEN
	F_MessageChk(1,'[제출서]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_maichul_list_jechul_code")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF

IF IsNull(ls_saupno) OR ls_saupno ="" THEN
	F_MessageChk(1,'[사업자번호]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_saupno")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF

IF IsNull(ls_sanho) OR ls_sanho ="" THEN
	F_MessageChk(1,'[상호]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_sangho")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF
IsCommJasa = s_jasacode
sApplyFlag = '%'
			
select Count(*) into :iCount from kfz_vat_work 
	where fdate = :ls_sdate and tdate = :ls_edate and saupno = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	iCount = 0
end if
if iCount > 0 then
	if MessageBox('확 인','이미 집계자료가 있습니다. 삭제 후 다시 집계하시겠습니까?',Question!,YesNo!) = 2 then return
end if

delete from kfz_vat_title where gubun = '7' and cdate = substr(:ls_date,3,6) ;
delete from kfz_segum_maichul_hap where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_segum_maichul_list where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_segum_maiip_hap where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_segum_maiip_list where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_vat_work where fdate = :ls_sdate and tdate = :ls_edate and saupno = :IsCommJasa;
commit ;

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="부가세 자료 집계 중......"

//자사내역 조회
String sCvnas, sSano, sOwname, sAddr
select rpad(cvnas,30),  rpad(sano,10),     rpad(ownam,15),  rpad(addr1||nvl(addr2,''),45)
	into :sCvnas,    		:sSano,            :sOwname,    		:sAddr
	from vndmst
	where cvcod = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	MessageBox('확인','자사 정보를 찾을 수 없습니다')
	w_mdi_frame.sle_msg.text =''
	return 
end if

//표지 생성
insert into kfz_vat_title
	( gubun,  		saupno,    		sangho,   	sname,     	addr,    	    
	  sdate,    						edate,   					cdate, 			bigo )
values
   ( '7',    		:sSano,    		:sCvnas,  	:sOwname,  	:sAddr,   	    
	  substr(:ls_sdate,3,6),    	substr(:ls_edate,3,6),  substr(:ls_date,3,6),       ' ') ;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox('확인','표지 생성 실패!!')
	w_mdi_frame.sle_msg.text =''
	return 
end if
commit;

//매출
if wf_summary_maichul(ls_sdate, ls_edate, IsCommJasa, sSano ) = -1 then return 
//매입
if wf_summary_maiip(ls_sdate, ls_edate, IsCommJasa, sSano ) = -1 then return 

//신고파일 생성
insert into kfz_vat_work
 ( test,
	fdate,            tdate,            saupno,                seqno)
select t.vatdata,
		 :ls_sdate,    :ls_edate,        :IsCommJasa,            rownum
from (
		select k.vatdata
		from ( //표지
				select '1' as sort, 1 as seq, gubun||saupno||sangho||sname||addr||rpad(' ',17)||rpad(' ',25)||sdate||edate||cdate||rpad(' ',9) as vatdata
				 from kfz_vat_title
				 where cdate = substr(:ls_date,3,6)
				union all //매출내역(전자세금이외분)
				select '2' as sort, seqno as seq, gubun||saupno1||trim(to_char(seqno,'0000'))||saupno2||sangho2||rpad(' ',17)||rpad(' ',25)||trim(to_char(maichul_cnt,'0000000'))||
						 trim(to_char(0,'00'))||fun_crt_vatfile_conv_amt(gon_amt,14)||fun_crt_vatfile_conv_amt(vat_amt,13)||jugu1||' '||guan_no||jechul_code||
						 rpad(' ',28)  as vatdata
				 from kfz_segum_maichul_list
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa  
				union all //매출합계(전자세금이외분)
				select '3' as sort, 1 as seq,
					 gubun||saupno||
					 trim(to_char(hap_maichul_cnt,   '0000000'))||trim(to_char(hap_segum_nbr,   '0000000'))||fun_crt_vatfile_conv_amt(hap_gon_amt,15)||fun_crt_vatfile_conv_amt(hap_vat_amt,14)||
					 trim(to_char(saup_maichul_cnt,  '0000000'))||trim(to_char(saup_segum_nbr,  '0000000'))||fun_crt_vatfile_conv_amt(saup_gon_amt,15)||fun_crt_vatfile_conv_amt(saup_vat_amt,14)||
					 trim(to_char(person_maichul_cnt,'0000000'))||trim(to_char(person_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(person_gon_amt,15)||fun_crt_vatfile_conv_amt(person_vat_amt,14)||
					 rpad(' ',30)  as vatdata
				 from kfz_segum_maichul_hap
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = '3' 
				union all //매출합계(전자세금)
				select '4' as sort, 1 as seq,
					 gubun||saupno||
					 trim(to_char(hap_maichul_cnt,   '0000000'))||trim(to_char(hap_segum_nbr,   '0000000'))||fun_crt_vatfile_conv_amt(hap_gon_amt,15)||fun_crt_vatfile_conv_amt(hap_vat_amt,14)||
					 trim(to_char(saup_maichul_cnt,  '0000000'))||trim(to_char(saup_segum_nbr,  '0000000'))||fun_crt_vatfile_conv_amt(saup_gon_amt,15)||fun_crt_vatfile_conv_amt(saup_vat_amt,14)||
					 trim(to_char(person_maichul_cnt,'0000000'))||trim(to_char(person_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(person_gon_amt,15)||fun_crt_vatfile_conv_amt(person_vat_amt,14)||
					 rpad(' ',30)  as vatdata
				 from kfz_segum_maichul_hap
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = '5'  
				 union all //매입내역(전자세금이외분)
				 select '5' as sort, seq_no as seq,
						  gubun||saupno1||trim(to_char(seq_no,'0000'))||saupno2||sangho2||rpad(' ',17)||rpad(' ',25)||trim(to_char(mai_cnt,'0000000'))||
						  trim(to_char(0,'00'))||fun_crt_vatfile_conv_amt(gon_amt,14)||fun_crt_vatfile_conv_amt(vat_amt,13)||jugu1||' '||guan_no||jechul_cd||
						  rpad(bigo,28)  as vatdata
				 from kfz_segum_maiip_list
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa 	  
				 union all //매입합계(전자세금이외분)
				 select '6' as sort, 1 as seq,
						  gubun||saupno||
						  trim(to_char(hap_maichul_cnt,'0000000'))||trim(to_char(hap_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(hap_gon_amt,15)||fun_crt_vatfile_conv_amt(hap_vat_amt,14)||
						  trim(to_char(saup_maichul_cnt,'0000000'))||trim(to_char(saup_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(saup_gon_amt,15)||fun_crt_vatfile_conv_amt(saup_vat_amt,14)||
						  trim(to_char(per_maichul_cnt,'0000000'))||trim(to_char(per_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(per_gon_amt,15)||fun_crt_vatfile_conv_amt(per_vat_amt,14)||
						  rpad(' ',30)  as vatdata
				 from kfz_segum_maiip_hap
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = '4' 	
				 union all //매입합계(전자세금)
				 select '7' as sort, 1 as seq,
						  gubun||saupno||
						  trim(to_char(hap_maichul_cnt,'0000000'))||trim(to_char(hap_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(hap_gon_amt,15)||fun_crt_vatfile_conv_amt(hap_vat_amt,14)||
						  trim(to_char(saup_maichul_cnt,'0000000'))||trim(to_char(saup_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(saup_gon_amt,15)||fun_crt_vatfile_conv_amt(saup_vat_amt,14)||
						  trim(to_char(per_maichul_cnt,'0000000'))||trim(to_char(per_segum_nbr,'0000000'))||fun_crt_vatfile_conv_amt(per_gon_amt,15)||fun_crt_vatfile_conv_amt(per_vat_amt,14)||
						  rpad(' ',30)  as vatdata
				 from kfz_segum_maiip_hap
				 where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = '6' 	
			 ) k
	 order by k.sort, k.seq
) t ;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox('확 인','신고파일 저장 실패!!')
	return 
end if
commit;				
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="부가세 자료 집계 완료"

end event

type p_ins from w_inherite`p_ins within w_ktxa80
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa80
integer x = 4416
integer y = 20
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa80
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa80
integer x = 4242
integer y = 20
integer taborder = 40
end type

event p_print::clicked;call super::clicked;if tab_vat.SelectedTab = 2 then
	if tab_vat.tabpage_print1.dw_print.RowCount() > 0 then
		gi_page = tab_vat.tabpage_print1.dw_print.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_vat.tabpage_print1.dw_print)	
	end if
//	if tab_vat.tabpage_print2.dw_print2.RowCount() > 0 then
//		gi_page = tab_vat.tabpage_print2.dw_print2.GetItemNumber(1,"last_page")
//		OpenWithParm(w_print_options,tab_vat.tabpage_print2.dw_print2)	
//	end if
elseif tab_vat.SelectedTab = 3 then
	if tab_vat.tabpage_print2.dw_print2.RowCount() > 0 then
		gi_page = tab_vat.tabpage_print2.dw_print2.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_vat.tabpage_print2.dw_print2)	
	end if
end if

end event

type p_inq from w_inherite`p_inq within w_ktxa80
boolean visible = false
integer x = 3077
integer y = 2528
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa80
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa80
integer x = 3575
integer y = 44
integer width = 475
integer height = 100
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\파일저장01_up.jpg"
end type

event p_mod::clicked;String  s_jasacode, ls_sdate, ls_edate,  sPath,sSaveFile

tab_vat.tabpage_process.dw_process.AcceptText()

IF wf_requiredchk(tab_vat.tabpage_process.dw_process.GetRow()) = -1 THEN RETURN 

/*화일 저장 위치*/
String sFileName
ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
s_jasacode     = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"code")

IsCommJasa = s_jasacode
sApplyFlag = '%'

sPath       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"spath")
sFileName	= tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"savefilename")

sSaveFile   = sPath + sFileName

dw_file.Retrieve(ls_sdate,ls_edate,IsCommJasa)

dw_file.SaveAs(sSaveFile, TEXT!, FALSE)

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="파일저장 완료"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\파일저장01_dn.jpg"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\파일저장01_up.jpg"
end event

type cb_exit from w_inherite`cb_exit within w_ktxa80
integer x = 3630
integer y = 2740
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa80
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
integer x = 2930
integer y = 2740
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa80
integer x = 2080
integer y = 3028
end type

type cb_del from w_inherite`cb_del within w_ktxa80
integer x = 2446
integer y = 3084
end type

type cb_inq from w_inherite`cb_inq within w_ktxa80
integer x = 2802
integer y = 3084
end type

type cb_print from w_inherite`cb_print within w_ktxa80
integer x = 3282
integer y = 2740
end type

type st_1 from w_inherite`st_1 within w_ktxa80
integer y = 2112
end type

type cb_can from w_inherite`cb_can within w_ktxa80
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa80
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa80
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa80
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa80
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa80
integer x = 2075
integer y = 2676
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa80
integer x = 2889
integer y = 2692
integer width = 1083
integer height = 180
end type

type tab_vat from tab within w_ktxa80
integer x = 73
integer y = 180
integer width = 4521
integer height = 2048
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type

on tab_vat.create
this.tabpage_process=create tabpage_process
this.tabpage_print1=create tabpage_print1
this.tabpage_print2=create tabpage_print2
this.Control[]={this.tabpage_process,&
this.tabpage_print1,&
this.tabpage_print2}
end on

on tab_vat.destroy
destroy(this.tabpage_process)
destroy(this.tabpage_print1)
destroy(this.tabpage_print2)
end on

event selectionchanged;if newindex = 1 then
	p_mod.Enabled = True
	p_print.Enabled   = False
else
	p_mod.Enabled = False
	p_print.Enabled   = True
	
	if newindex = 2 or newindex = 3 then
		if rb_1.Checked = True then
			if Wf_Maiip_Vat() = -1 then 
				p_print.Enabled = False
			else
				p_print.Enabled = True
				
				tab_vat.tabpage_print1.dw_print.object.datawindow.print.preview = 'yes'
				tab_vat.tabpage_print2.dw_print2.object.datawindow.print.preview = 'yes'
			end if	
		elseif rb_2.Checked = True then
			if Wf_Maichul_Vat() = -1 then 
				p_print.Enabled = False
			else
				p_print.Enabled = True
				
				tab_vat.tabpage_print1.dw_print.object.datawindow.print.preview = 'yes'
				tab_vat.tabpage_print2.dw_print2.object.datawindow.print.preview = 'yes'
			end if	
		end if		
	end if
end if
end event

type tabpage_process from userobject within tab_vat
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4485
integer height = 1936
long backcolor = 32106727
string text = "디스텟 작성"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_process dw_process
end type

on tabpage_process.create
this.rr_1=create rr_1
this.dw_process=create dw_process
this.Control[]={this.rr_1,&
this.dw_process}
end on

on tabpage_process.destroy
destroy(this.rr_1)
destroy(this.dw_process)
end on

type rr_1 from roundrectangle within tabpage_process
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer width = 4434
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_process from u_key_enter within tabpage_process
integer x = 480
integer y = 120
integer width = 3424
integer height = 1756
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa81"
boolean border = false
end type

event itemchanged;String ls_saupno,ls_sanho, ls_name, ls_uptae, ls_upjong, ls_addr1,ls_addr2,&
		 sVatGisu, sStart,   sEnd,    sProcGbn, sCommJasa, sGbn,	   snull, s_jasacode

SetNull(snull)

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(this.GetRow(),"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
			INTO :sStart,								:sEnd  
   		FROM "REFFPF"  
		   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
		this.SetItem(this.GetRow(),"kfz_vat_title_sdate",Left(f_Today(),4)+sStart)
		this.SetItem(this.GetRow(),"kfz_vat_title_edate",Left(f_Today(),4)+sEnd)	
	END IF
END IF

IF this.GetColumnName() ="kfz_vat_title_sdate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"거래기간")
		this.SetItem(1,"kfz_vat_title_sdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfz_vat_title_edate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"거래기간")
		this.SetItem(1,"kfz_vat_title_edate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfz_vat_title_cdate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"작성일자") 
		this.SetItem(1,"kfz_vat_title_cdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "code" THEN
	s_jasacode = this.GetText()
	IF s_jasacode = "" OR IsNull(s_jasacode) THEN
		this.SetItem(this.GetRow(),"kfz_vat_title_saupno",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_sname", snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_sangho",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
	
		Return
	END IF
	
  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2"  
   INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,:ls_uptae,   
        :ls_upjong        ,:ls_addr1       ,:ls_addr2
   FROM "VNDMST"  
  	WHERE "VNDMST"."CVCOD" = :s_jasacode   ;
	
	IF IsNull(ls_addr1) THEN
		ls_addr1 =""
	END IF
	
	IF IsNull(ls_addr2) THEN
		ls_addr2 =""
	END IF
	
	this.SetItem(this.GetRow(),"kfz_vat_title_saupno",ls_saupno)
	this.SetItem(this.GetRow(),"kfz_vat_title_sname",ls_name)
	this.SetItem(this.GetRow(),"kfz_vat_title_sangho",ls_sanho)
	this.SetItem(this.GetRow(),"kfz_vat_title_uptae",ls_uptae)
	this.SetItem(this.GetRow(),"kfz_vat_title_upjong",ls_upjong)
	this.SetItem(this.GetRow(),"kfz_vat_title_addr",ls_addr1+ls_addr2)
END IF

IF this.GetColumnName() = "procgbn" THEN
	sProcGbn = this.getText()
	IF sProcGbn = '2' THEN								/*개별납부*/
		this.SetItem(this.GetRow(),"code",                snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_saupno",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_sname", snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_sangho",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
	ELSE
		SELECT "SYSCNFG"."DATANAME"  
	   	INTO :sCommJasa  
   	 	FROM "SYSCNFG"  
   		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         		( "SYSCNFG"."LINENO" = '1' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			this.SetItem(this.GetRow(),"code",                snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_saupno",snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_sname", snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_sangho",snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
			this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
			Return 1
		ELSE
			IF IsNull(sCommJasa) OR sCommJasa = "" THEN
				F_MessageChk(56,'[자사코드(C-4-1)]')
				this.SetItem(this.GetRow(),"code",                snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_saupno",snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_sname", snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_sangho",snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
				Return 1
			END IF
		END IF		
		
		SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
				 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2"  
		INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,:ls_uptae,   
			  :ls_upjong        ,:ls_addr1       ,:ls_addr2
		FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sCommJasa   ;
		
		IF IsNull(ls_addr1) THEN
			ls_addr1 =""
		END IF
		
		IF IsNull(ls_addr2) THEN
			ls_addr2 =""
		END IF
		this.SetItem(this.GetRow(),"code",                sCommJasa)
		this.SetItem(this.GetRow(),"kfz_vat_title_saupno",ls_saupno)
		this.SetItem(this.GetRow(),"kfz_vat_title_sname", ls_name)
		this.SetItem(this.GetRow(),"kfz_vat_title_sangho",ls_sanho)
		this.SetItem(this.GetRow(),"kfz_vat_title_uptae", ls_uptae)
		this.SetItem(this.GetRow(),"kfz_vat_title_upjong",ls_upjong)
		this.SetItem(this.GetRow(),"kfz_vat_title_addr",  ls_addr1+ls_addr2)
		
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

type tabpage_print1 from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4485
integer height = 1936
long backcolor = 32106727
string text = "매입처별 세금계산서 합계표(갑)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_print dw_print
end type

on tabpage_print1.create
this.rr_2=create rr_2
this.dw_print=create dw_print
this.Control[]={this.rr_2,&
this.dw_print}
end on

on tabpage_print1.destroy
destroy(this.rr_2)
destroy(this.dw_print)
end on

type rr_2 from roundrectangle within tabpage_print1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 24
integer width = 4434
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print from datawindow within tabpage_print1
integer x = 41
integer y = 36
integer width = 4407
integer height = 1876
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa80p"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_print2 from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4485
integer height = 1936
long backcolor = 32106727
string text = "매입처별 세금계산서 합계표(을)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_print2 dw_print2
end type

on tabpage_print2.create
this.rr_3=create rr_3
this.dw_print2=create dw_print2
this.Control[]={this.rr_3,&
this.dw_print2}
end on

on tabpage_print2.destroy
destroy(this.rr_3)
destroy(this.dw_print2)
end on

type rr_3 from roundrectangle within tabpage_print2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4434
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print2 from datawindow within tabpage_print2
integer x = 41
integer y = 32
integer width = 4407
integer height = 1876
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa80p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_ktxa80
integer x = 187
integer y = 68
integer width = 795
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "매입처별 세금계산서 합계표"
boolean checked = true
end type

event clicked;if this.Checked = True then
	tab_vat.tabpage_print1.text = '매입처별 세금계산서 합계표(갑)'
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa80p'
	
	tab_vat.tabpage_print2.text = '매입처별 세금계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa80p1' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
end if
end event

type rb_2 from radiobutton within w_ktxa80
integer x = 1344
integer y = 68
integer width = 795
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "매출처별 세금계산서 합계표"
end type

event clicked;if this.Checked = True then
	tab_vat.tabpage_print1.text = '매출처별 세금계산서 합계표(갑)'
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa80po'
	
	tab_vat.tabpage_print2.text = '매출처별 세금계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa80po1' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
end if
end event

type dw_file from datawindow within w_ktxa80
boolean visible = false
integer x = 1056
integer y = 2448
integer width = 1554
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "파일저장"
string dataobject = "dw_ktxa219"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type gb_1 from groupbox within w_ktxa80
integer x = 69
integer y = 8
integer width = 2245
integer height = 152
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출력구분"
end type

