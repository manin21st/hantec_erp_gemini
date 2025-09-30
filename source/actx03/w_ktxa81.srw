$PBExportHeader$w_ktxa81.srw
$PBExportComments$계산서합계표 신고서(2013년1기확정)
forward
global type w_ktxa81 from w_inherite
end type
type dw_title from datawindow within w_ktxa81
end type
type dw_hap from datawindow within w_ktxa81
end type
type dw_list from datawindow within w_ktxa81
end type
type tab_vat from tab within w_ktxa81
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
type tab_vat from tab within w_ktxa81
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type
type rb_1 from radiobutton within w_ktxa81
end type
type rb_2 from radiobutton within w_ktxa81
end type
type dw_title2 from datawindow within w_ktxa81
end type
type dw_file from datawindow within w_ktxa81
end type
type gb_1 from groupbox within w_ktxa81
end type
end forward

global type w_ktxa81 from w_inherite
integer width = 4933
integer height = 2432
string title = "계산서합계표 신고서"
dw_title dw_title
dw_hap dw_hap
dw_list dw_list
tab_vat tab_vat
rb_1 rb_1
rb_2 rb_2
dw_title2 dw_title2
dw_file dw_file
gb_1 gb_1
end type
global w_ktxa81 w_ktxa81

type variables
Int    Ii_TotalCnt
String s_jasacode,sRptPath,sApplyFlag,IsCommJasa
end variables

forward prototypes
public function integer wf_requiredchk (integer curr_row)
public function boolean wf_setting_title (string sjasa, string scommjasa)
public function integer wf_maiip_vat ()
public function integer wf_maichul_vat ()
public function boolean wf_setting_list (string sfdate, string stdate, string sjasa, string sjasasano)
public function boolean wf_setting_jip (string sfdate, string stdate, string sjasa, string sjasasano)
end prototypes

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

public function boolean wf_setting_title (string sjasa, string scommjasa);String ls_saupj,ls_sdate,ls_edate,ls_date,ls_code,ls_saupno,ls_sanho,&
		 ls_name,ls_uptae,ls_upjong,ls_addr,ls_file_name,ls_resident,ls_posno,ls_telno
Long ll_jechul_code,ll_space_length
Boolean date_chk,function_chk

tab_vat.tabpage_process.dw_process.AcceptText()
ls_sdate       =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate")
ls_edate       =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate")
ls_date        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
ll_jechul_code =tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")
ls_code        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"code")
ls_saupno      =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")
ls_sanho       =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sangho")
ls_resident    =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"resident")
ls_name        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sname")
ls_uptae       =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_uptae")
ls_upjong      =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_upjong")
ls_addr        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_addr")

IF IsNull(ls_name) THEN ls_name =""
IF IsNull(ls_resident) THEN ls_resident =""
IF IsNull(ls_uptae) THEN ls_uptae =""
IF IsNull(ls_upjong) THEN ls_upjong =""
IF IsNull(ls_addr) THEN ls_addr =""

select posno,			nvl(telddd||telno1||telno2,'')
	into :ls_posno,	:ls_telno
	from vndmst
	where cvcod = :ls_code ;
if IsNull(ls_posno) then ls_posno = ''
if IsNull(ls_telno) then ls_telno = ''

dw_title.InsertRow(0)
dw_title.SetItem(dw_title.GetRow(),"gubun", 'A')
dw_title.SetItem(dw_title.GetRow(),"taxcd",  String(ll_jechul_code,'000'))
dw_title.SetItem(dw_title.GetRow(),"jdate",  ls_date)
dw_title.SetItem(dw_title.GetRow(),"jgubun", '2')		/*1:세무대리인2:법인3:개인*/

dw_title.SetItem(dw_title.GetRow(),"sano",   ls_saupno)
dw_title.SetItem(dw_title.GetRow(),"sname",  ls_sanho)
dw_title.SetItem(dw_title.GetRow(),"residno",ls_resident)
dw_title.SetItem(dw_title.GetRow(),"owname", ls_name)
dw_title.SetItem(dw_title.GetRow(),"posno",  ls_posno)
dw_title.SetItem(dw_title.GetRow(),"addr",   ls_addr)
dw_title.SetItem(dw_title.GetRow(),"telno",  ls_telno)		
dw_title.SetItem(dw_title.GetRow(),"korgbn", 101)			/*ksc*/

/*제출자별 인적사항*/
Integer iLoopCnt, iCurCnt

DECLARE taxlst CURSOR FOR  
	SELECT DISTINCT "KFZ17OT0"."JASA_CD", 			"VNDMST"."SANO",			"VNDMST"."OWNAM",
						 "VNDMST"."CVNAS",				"VNDMST"."POSNO", 
						 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' ') 
		FROM "KFZ17OT0", "REFFPF", "VNDMST"
		WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF"."RFGUB" ) and  
				( "KFZ17OT0"."JASA_CD" = "VNDMST"."CVCOD") AND
				("KFZ17OT0"."JASA_CD" like :sjasa ) AND
				(( "KFZ17OT0"."ACC_DATE" >= :ls_sdate ) AND  
				( "KFZ17OT0"."ACC_DATE" <= :ls_edate )) AND 				
				( "REFFPF"."RFCOD" = 'JA') AND
				( "REFFPF"."RFGUB" <> '00') AND
				(SUBSTR("REFFPF"."RFNA2",1,1) LIKE :sApplyFlag) AND   
				( "KFZ17OT0"."ALC_GU" = 'Y') AND  
				( "KFZ17OT0"."TAX_NO" = '19' OR "KFZ17OT0"."TAX_NO" = '29') AND
				( "KFZ17OT0"."TAXGBN" = 'Y') 
		ORDER BY "VNDMST"."SANO" ;

OPEN TaxLst;

iLoopCnt = 1;		

DO  WHILE True
	FETCH TaxLst INTO :ls_code,		:ls_saupno,			:ls_name,		
							:ls_sanho,		:ls_posno,			:ls_addr ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	if IsNull(ls_saupno) then ls_saupno = ''
	if IsNull(ls_name) then ls_name = ''
	if IsNull(ls_sanho) then ls_sanho = ''
	if IsNull(ls_posno) then ls_posno = ''
	if IsNull(ls_telno) then ls_telno = ''
	if IsNull(ls_addr) then ls_addr = ''
	
	iCurCnt = dw_title2.InsertRow(0)
	dw_title2.SetItem(iCurCnt,"gubun", 'B')
	dw_title2.SetItem(iCurCnt,"taxcd",  String(ll_jechul_code,'000'))
	dw_title2.SetItem(iCurCnt,"serno",  iLoopCnt)

	dw_title2.SetItem(iCurCnt,"sano",   ls_saupno)
	dw_title2.SetItem(iCurCnt,"sname",  ls_sanho)
	dw_title2.SetItem(iCurCnt,"owname", ls_name)
	dw_title2.SetItem(iCurCnt,"posno",  ls_posno)
	dw_title2.SetItem(iCurCnt,"addr",   ls_addr)

	iLoopCnt += 1
LOOP
CLOSE TaxLst;

dw_title.SetItem(dw_title.GetRow(),"jcnt",  iLoopCnt - 1)			/*제출건수*/

IF dw_title.Update() <> 1 THEN						/*제출자레코드*/
	Return False
END IF
Commit;

IF dw_title2.Update() <> 1 THEN						/*제출자 인적사항*/
	Return False
END IF

Commit;

Return True


end function

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

il_RetrieveRow = tab_vat.tabpage_print1.dw_print.RowCount()
il_currow = tab_vat.tabpage_print2.dw_print2.RowCount()

IF il_RetrieveRow < 10 THEN
	il_dvdval =Mod(il_RetrieveRow,10)
	IF il_dvdval =0 THEN
	ELSE
		String sTmp_Saupno
		sTmp_Saupno = tab_vat.tabpage_print1.dw_print.GetItemString(1,"saupno2")
		if sTmp_Saupno = '' or IsNull(sTmp_Saupno) then
			tab_vat.tabpage_print1.dw_print.SetItem(1,"seq_no",1 )		
		end if
		FOR i =il_dvdval TO 9 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
		   tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seq_no",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,25)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 24 STEP 1
			tab_vat.tabpage_print2.dw_print2.InsertRow(0)
		NEXT
	END IF
END IF

w_mdi_frame.sle_msg.text ="매입처별 계산서 합계표 조회 완료!!!"	
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
			tab_vat.tabpage_print1.dw_print.SetItem(1,"seq_no",1 )		
		end if

		FOR i =il_dvdval TO 4 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
			tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seq_no",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,25)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 24 STEP 1
			tab_vat.tabpage_print2.dw_print2.InsertRow(0)
		NEXT
	END IF
END IF

w_mdi_frame.sle_msg.text ="매출처별 계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

return 1


end function

public function boolean wf_setting_list (string sfdate, string stdate, string sjasa, string sjasasano);String  ls_date,ls_Gisu,ls_sangho,ls_custno
Long    lTaxCode
Integer iLoopCnt, iCurCnt,iCustCnt,iTaxCnt,iDatagu
Double  dTaxAmt

tab_vat.tabpage_process.dw_process.AcceptText()

ls_date   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
lTaxCode  = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")
ls_Gisu   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu")

iDataGu = 18
//매입
DECLARE taxlst_io1 CURSOR FOR  
	select a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' '),
           nvl(sum(decode(a.taxgbn,'Y',1,0)),0) AS ll_count,
           sum(nvl(a.gon_amt,0))
    from kfz17ot0 a, vndmst b
    where  ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
	 		  ( a.saup_no = b.cvcod(+)) AND          
           (a.jasa_cd LIKE :sjasa ) AND
           ( a.tax_no = '19') AND
           ( a.alc_gu ='Y') AND
			  ( ( a.elegbn = '1' ) or 
			    ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' )
			  )
    group by a.saup_no2,  rpad(nvl(b.cvnas,' '),30,' ') 
	 order by a.saup_no2;
	 
OPEN taxlst_io1;

iLoopCnt = 1;		

DO  WHILE True
	FETCH taxlst_io1 INTO :ls_custno,		:ls_sangho,		:iTaxCnt,		:dTaxAmt;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	iCurCnt = dw_list.InsertRow(0)
	dw_list.SetItem(iCurCnt,"gubun", 'D')
	dw_list.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_list.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_list.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_list.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_list.SetItem(iCurCnt,"rptgbn", '2')
	END IF	
	
	dw_list.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_list.SetItem(iCurCnt,"serno",  iLoopCnt)
	dw_list.SetItem(iCurCnt,"sano",   trim(sjasasano))
	dw_list.SetItem(iCurCnt,"custno",   trim(ls_custno))
	dw_list.SetItem(iCurCnt,"custnm",   trim(ls_sangho))
	
	dw_list.SetItem(iCurCnt,"taxcnt",   iTaxCnt)
	
	if dTaxAmt >= 0 then													/*양수:0/음수:1)*/
		dw_list.SetItem(iCurCnt,"buho",  0)
	else
		dw_list.SetItem(iCurCnt,"buho",  1)
	end if
	dw_list.SetItem(iCurCnt,"taxamt",   Abs(dTaxAmt))
	dw_list.SetItem(iCurCnt,"rpt_fr",   sfdate)
	dw_list.SetItem(iCurCnt,"rpt_to",   stdate)
	dw_list.SetItem(iCurCnt,"jasacd",   sjasa)

	iLoopCnt += 1
LOOP
CLOSE taxlst_io1;

iDataGu = 17
//매출
DECLARE taxlst_io2 CURSOR FOR  
	select a.saup_no2,
           rpad(nvl(b.cvnas,' '),30,' '),
           nvl(sum(decode(a.taxgbn,'Y',1,0)),0) AS ll_count,
           sum(nvl(a.gon_amt,0))
    from kfz17ot0 a, vndmst b
    where  ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND
	 		  ( a.saup_no = b.cvcod(+)) AND          
           (a.jasa_cd LIKE :sjasa ) AND
           ( a.tax_no = '29') AND
           ( a.alc_gu ='Y') AND
			  ( ( a.elegbn = '1' ) or 
			    ( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' )
			  )
    group by a.saup_no2,  rpad(nvl(b.cvnas,' '),30,' ') 
	 order by a.saup_no2;
	 
OPEN taxlst_io2;

iLoopCnt = 1;		

DO  WHILE True
	FETCH taxlst_io2 INTO :ls_custno,		:ls_sangho,		:iTaxCnt,		:dTaxAmt;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
		
	iCurCnt = dw_list.InsertRow(0)
	dw_list.SetItem(iCurCnt,"gubun", 'D')
	dw_list.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_list.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_list.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_list.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_list.SetItem(iCurCnt,"rptgbn", '2')
	END IF	
	
	dw_list.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_list.SetItem(iCurCnt,"serno",  iLoopCnt)
	dw_list.SetItem(iCurCnt,"sano",   trim(sjasasano))
	dw_list.SetItem(iCurCnt,"custno",   trim(ls_custno))
	dw_list.SetItem(iCurCnt,"custnm",   trim(ls_sangho))
	
	dw_list.SetItem(iCurCnt,"taxcnt",   iTaxCnt)
	
	if dTaxAmt >= 0 then													/*양수:0/음수:1)*/
		dw_list.SetItem(iCurCnt,"buho",  0)
	else
		dw_list.SetItem(iCurCnt,"buho",  1)
	end if
	dw_list.SetItem(iCurCnt,"taxamt",   Abs(dTaxAmt))
	dw_list.SetItem(iCurCnt,"rpt_fr",   sfdate)
	dw_list.SetItem(iCurCnt,"rpt_to",   stdate)
	dw_list.SetItem(iCurCnt,"jasacd",   sjasa)
	
	iLoopCnt += 1
LOOP
CLOSE taxlst_io2;

IF dw_list.Update() <> 1 THEN						/*제출자 인적사항*/
	Return False
END IF
Commit;

Return True


end function

public function boolean wf_setting_jip (string sfdate, string stdate, string sjasa, string sjasasano);String ls_date,ls_Gisu
Long    lTaxCode
Integer iDatagu, iCurCnt

tab_vat.tabpage_process.dw_process.AcceptText()

ls_date   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
lTaxCode  = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

ls_Gisu   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu")

Long    lSaupCnt_Saup, lTaxCnt_Saup, lSaupCnt_Per, lTaxCnt_Per
Double  dpGonAmt_Saup, dGonAmt_Per 

iDataGu = 17
//매출C레코드-전자외
//매출처,매수,공급가액(사업자등록분-전자이외분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Saup,            :lTaxCnt_Saup,                         :dpGonAmt_Saup
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '29') AND ( a.alc_gu ='Y') and
			 ( ( a.elegbn = '1' ) or
				( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Saup = 0; lTaxCnt_Saup  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Saup) then lSaupCnt_Saup = 0
	if IsNull(lTaxCnt_Saup) then lTaxCnt_Saup = 0
	if IsNull(dpGonAmt_Saup) then dpGonAmt_Saup = 0
end if

//매출처,매수,공급가액(개인-전자이외분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Per,             :lTaxCnt_Per,                         :dGonAmt_Per
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '28') AND ( a.alc_gu ='Y') and
			 ( ( a.elegbn = '1' ) or
				( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Per = 0; lTaxCnt_Per  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Per) then lSaupCnt_Per = 0
	if IsNull(lTaxCnt_Per) then lTaxCnt_Per = 0
	if IsNull(dGonAmt_Per) then dGonAmt_Per = 0
end if

if lSaupCnt_Saup + lSaupCnt_Per <> 0 then
	iCurCnt = dw_hap.InsertRow(0)				
	dw_hap.SetItem(iCurCnt,"gubun", 'C')
	dw_hap.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_hap.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_hap.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"rptgbn", '2')
	END IF	

	dw_hap.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_hap.SetItem(iCurCnt,"serno",  1)
	dw_hap.SetItem(iCurCnt,"sano",   sjasasano)
	
	dw_hap.SetItem(iCurCnt,"jyear",  Long(Left(sfdate,4)))
	dw_hap.SetItem(iCurCnt,"fdate",  sfdate)
	dw_hap.SetItem(iCurCnt,"tdate",  stdate)
	dw_hap.SetItem(iCurCnt,"cdate",  ls_date)
	
	dw_hap.SetItem(iCurCnt,"hap_custcnt",  lSaupCnt_Saup + lSaupCnt_Per )			
	dw_hap.SetItem(iCurCnt,"hap_taxcnt",   lTaxCnt_Saup + lTaxCnt_Per )
	
	if dpGonAmt_Saup + dGonAmt_Per >= 0 then													/*양수:0/음수:1)*/
		dw_hap.SetItem(iCurCnt,"hap_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"hap_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"hap_taxamt",   Abs(dpGonAmt_Saup + dGonAmt_Per))

	dw_hap.SetItem(iCurCnt,"saup_custcnt",  lSaupCnt_Saup)			
	dw_hap.SetItem(iCurCnt,"saup_taxcnt",   lTaxCnt_Saup)
	


	if dpGonAmt_Saup >= 0 then											
		dw_hap.SetItem(iCurCnt,"saup_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"saup_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"saup_taxamt",   Abs(dpGonAmt_Saup))
	
	dw_hap.SetItem(iCurCnt,"per_custcnt",  lSaupCnt_Per)						
	dw_hap.SetItem(iCurCnt,"per_taxcnt",   lTaxCnt_Per)

	if dGonAmt_Per >= 0 then											
		dw_hap.SetItem(iCurCnt,"per_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"per_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"per_taxamt",   Abs(dGonAmt_Per))
	dw_hap.SetItem(iCurCnt,"rpt_fr", sfdate)
	dw_hap.SetItem(iCurCnt,"rpt_to", stdate)
	dw_hap.SetItem(iCurCnt,"jasacd", sjasa)

	lSaupCnt_Saup = 0
	lTaxCnt_Saup = 0
	dpGonAmt_Saup = 0
	lSaupCnt_Per = 0
	lTaxCnt_Per = 0
	dGonAmt_Per = 0
end if

//매출E레코드-전자
//매출처,매수,공급가액(사업자등록분-전자분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Saup,            :lTaxCnt_Saup,                         :dpGonAmt_Saup
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '29') AND ( a.alc_gu ='Y') and
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Saup = 0; lTaxCnt_Saup  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Saup) then lSaupCnt_Saup = 0
	if IsNull(lTaxCnt_Saup) then lTaxCnt_Saup = 0
	if IsNull(dpGonAmt_Saup) then dpGonAmt_Saup = 0
end if

//매출처,매수,공급가액(개인-전자분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Per,             :lTaxCnt_Per,                         :dGonAmt_Per
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '28') AND ( a.alc_gu ='Y') and
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Per = 0; lTaxCnt_Per  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Per) then lSaupCnt_Per = 0
	if IsNull(lTaxCnt_Per) then lTaxCnt_Per = 0
	if IsNull(dGonAmt_Per) then dGonAmt_Per = 0
end if

if lSaupCnt_Saup + lSaupCnt_Per <> 0 then
	iCurCnt = dw_hap.InsertRow(0)				
	dw_hap.SetItem(iCurCnt,"gubun", 'E')
	dw_hap.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_hap.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_hap.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"rptgbn", '2')
	END IF	

	dw_hap.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_hap.SetItem(iCurCnt,"serno",  1)
	dw_hap.SetItem(iCurCnt,"sano",   sjasasano)
	
	dw_hap.SetItem(iCurCnt,"jyear",  Long(Left(sfdate,4)))
	dw_hap.SetItem(iCurCnt,"fdate",  sfdate)
	dw_hap.SetItem(iCurCnt,"tdate",  stdate)
	dw_hap.SetItem(iCurCnt,"cdate",  ls_date)
	
	dw_hap.SetItem(iCurCnt,"hap_custcnt",  lSaupCnt_Saup + lSaupCnt_Per )			
	dw_hap.SetItem(iCurCnt,"hap_taxcnt",   lTaxCnt_Saup + lTaxCnt_Per )

	if dpGonAmt_Saup + dGonAmt_Per >= 0 then													/*양수:0/음수:1)*/
		dw_hap.SetItem(iCurCnt,"hap_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"hap_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"hap_taxamt",   Abs(dpGonAmt_Saup + dGonAmt_Per))
	
	dw_hap.SetItem(iCurCnt,"saup_custcnt",  lSaupCnt_Saup)			
	dw_hap.SetItem(iCurCnt,"saup_taxcnt",   lTaxCnt_Saup)
	
	if dpGonAmt_Saup >= 0 then											
		dw_hap.SetItem(iCurCnt,"saup_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"saup_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"saup_taxamt",   Abs(dpGonAmt_Saup))

	dw_hap.SetItem(iCurCnt,"per_custcnt",  lSaupCnt_Per)						
	dw_hap.SetItem(iCurCnt,"per_taxcnt",   lTaxCnt_Per)
	
	if dGonAmt_Per >= 0 then											
		dw_hap.SetItem(iCurCnt,"per_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"per_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"per_taxamt",   Abs(dGonAmt_Per))
	dw_hap.SetItem(iCurCnt,"rpt_fr", sfdate)
	dw_hap.SetItem(iCurCnt,"rpt_to", stdate)
	dw_hap.SetItem(iCurCnt,"jasacd", sjasa)
end if

iDataGu = 18		
//매입C레코드-전자외
//매입처,매수,공급가액(사업자등록분-전자이외분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Saup,            :lTaxCnt_Saup,                         :dpGonAmt_Saup
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '19') AND ( a.alc_gu ='Y') and
			 ( ( a.elegbn = '1' ) or
				( a.elegbn = '2' and nvl(a.send_date, a.acc_date) > to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Saup = 0; lTaxCnt_Saup  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Saup) then lSaupCnt_Saup = 0
	if IsNull(lTaxCnt_Saup) then lTaxCnt_Saup = 0
	if IsNull(dpGonAmt_Saup) then dpGonAmt_Saup = 0
end if

if lSaupCnt_Saup <> 0 then
	iCurCnt = dw_hap.InsertRow(0)				
	dw_hap.SetItem(iCurCnt,"gubun", 'C')
	dw_hap.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_hap.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_hap.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"rptgbn", '2')
	END IF	

	dw_hap.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_hap.SetItem(iCurCnt,"serno",  1)
	dw_hap.SetItem(iCurCnt,"sano",   sjasasano)
	
	dw_hap.SetItem(iCurCnt,"jyear",  Long(Left(sfdate,4)))
	dw_hap.SetItem(iCurCnt,"fdate",  sfdate)
	dw_hap.SetItem(iCurCnt,"tdate",  stdate)
	dw_hap.SetItem(iCurCnt,"cdate",  ls_date)
	
	dw_hap.SetItem(iCurCnt,"hap_custcnt",  lSaupCnt_Saup  )			
	dw_hap.SetItem(iCurCnt,"hap_taxcnt",   lTaxCnt_Saup )

	if dpGonAmt_Saup  >= 0 then													/*양수:0/음수:1)*/
		dw_hap.SetItem(iCurCnt,"hap_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"hap_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"hap_taxamt",   Abs(dpGonAmt_Saup))
	
	dw_hap.SetItem(iCurCnt,"saup_custcnt",  lSaupCnt_Saup)			
	dw_hap.SetItem(iCurCnt,"saup_taxcnt",   lTaxCnt_Saup)
	
	if dpGonAmt_Saup >= 0 then											
		dw_hap.SetItem(iCurCnt,"saup_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"saup_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"saup_taxamt",   Abs(dpGonAmt_Saup))
	dw_hap.SetItem(iCurCnt,"rpt_fr", sfdate)
	dw_hap.SetItem(iCurCnt,"rpt_to", stdate)
	dw_hap.SetItem(iCurCnt,"jasacd", sjasa)
end if

//매입E레코드-전자
//매입처,매수,공급가액(사업자등록분-전자분)	
select count(distinct a.saup_no2),  nvl(sum(decode(a.taxgbn,'Y',1,0)),0),  sum(nvl(a.gon_amt,0))
	 into :lSaupCnt_Saup,            :lTaxCnt_Saup,                         :dpGonAmt_Saup
	 from kfz17ot0 a
	 where ( a.acc_date >= :sfdate ) AND ( a.acc_date <= :stdate ) AND ( a.jasa_cd LIKE :sjasa ) AND 
			 ( a.tax_no = '19') AND ( a.alc_gu ='Y') and
			 ( a.elegbn = '2' ) and 
			 ( nvl(a.send_date, a.acc_date) <= to_char(add_months( substr(:stdate,1,6)||'01' ,1),'yyyymm')||'11' ) ;
if sqlca.sqlcode <> 0 then
	lSaupCnt_Saup = 0; lTaxCnt_Saup  = 0;  dpGonAmt_Saup = 0; 
else
	if IsNull(lSaupCnt_Saup) then lSaupCnt_Saup = 0
	if IsNull(lTaxCnt_Saup) then lTaxCnt_Saup = 0
	if IsNull(dpGonAmt_Saup) then dpGonAmt_Saup = 0
end if

if lSaupCnt_Saup <> 0 then
	iCurCnt = dw_hap.InsertRow(0)				
	dw_hap.SetItem(iCurCnt,"gubun", 'E')
	dw_hap.SetItem(iCurCnt,"datagu", iDataGu)
	
	IF ls_Gisu = '1' OR ls_Gisu = '2' THEN					/*1기 -> 1*/
		dw_hap.SetItem(iCurCnt,"vatgi", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"vatgi", '2')
	END IF
	
	IF ls_Gisu = '1' OR ls_Gisu = '3' THEN					/*예정 -> 1*/
		dw_hap.SetItem(iCurCnt,"rptgbn", '1')
	ELSE
		dw_hap.SetItem(iCurCnt,"rptgbn", '2')
	END IF	

	dw_hap.SetItem(iCurCnt,"taxcd",  String(lTaxCode,'000'))	
	dw_hap.SetItem(iCurCnt,"serno",  1)
	dw_hap.SetItem(iCurCnt,"sano",   sjasasano)
	
	dw_hap.SetItem(iCurCnt,"jyear",  Long(Left(sfdate,4)))
	dw_hap.SetItem(iCurCnt,"fdate",  sfdate)
	dw_hap.SetItem(iCurCnt,"tdate",  stdate)
	dw_hap.SetItem(iCurCnt,"cdate",  ls_date)
	
	dw_hap.SetItem(iCurCnt,"hap_custcnt",  lSaupCnt_Saup )			
	dw_hap.SetItem(iCurCnt,"hap_taxcnt",   lTaxCnt_Saup  )

	if dpGonAmt_Saup  >= 0 then													/*양수:0/음수:1)*/
		dw_hap.SetItem(iCurCnt,"hap_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"hap_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"hap_taxamt",   Abs(dpGonAmt_Saup) )
	
	dw_hap.SetItem(iCurCnt,"saup_custcnt",  lSaupCnt_Saup)			
	dw_hap.SetItem(iCurCnt,"saup_taxcnt",   lTaxCnt_Saup)

	if dpGonAmt_Saup >= 0 then											
		dw_hap.SetItem(iCurCnt,"saup_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"saup_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"saup_taxamt",   Abs(dpGonAmt_Saup))
	dw_hap.SetItem(iCurCnt,"rpt_fr", sfdate)
	dw_hap.SetItem(iCurCnt,"rpt_to", stdate)
	dw_hap.SetItem(iCurCnt,"jasacd", sjasa)
end if

IF dw_hap.Update() <> 1 THEN						
	Return False
END IF
Commit;

Return True


end function

event open;call super::open;String mm,dd,sJasa,sSano,sName,sJasaName,sUptae,sUpjong,sAddr,sStart,sEnd,sVatGisu,sPath
		 
tab_vat.tabpage_process.dw_process.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)

dw_title.SetTransObject(SQLCA)
dw_title2.SetTransObject(SQLCA)
dw_file.SetTransObject(SQLCA)
dw_hap.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

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

on w_ktxa81.create
int iCurrent
call super::create
this.dw_title=create dw_title
this.dw_hap=create dw_hap
this.dw_list=create dw_list
this.tab_vat=create tab_vat
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_title2=create dw_title2
this.dw_file=create dw_file
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_title
this.Control[iCurrent+2]=this.dw_hap
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.tab_vat
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.dw_title2
this.Control[iCurrent+8]=this.dw_file
this.Control[iCurrent+9]=this.gb_1
end on

on w_ktxa81.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_title)
destroy(this.dw_hap)
destroy(this.dw_list)
destroy(this.tab_vat)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_title2)
destroy(this.dw_file)
destroy(this.gb_1)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa81
boolean visible = false
integer x = 4411
integer y = 2932
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa81
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa81
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa81
integer x = 4069
integer y = 20
integer taborder = 0
string picturename = "C:\erpman\image\자료생성_up.gif"
end type

event p_search::clicked;call super::clicked;String  ls_sdate, ls_edate,  ls_date, ls_saupno,ls_sanho,&
		  ls_uptae, ls_upjong, ls_addr, sPath,sSaveFile,sBaseGbn,    sProcGbn
Long    ll_jechul_code
Boolean function_chk

tab_vat.tabpage_process.dw_process.AcceptText()

IF wf_requiredchk(tab_vat.tabpage_process.dw_process.GetRow()) = -1 THEN RETURN 

sBaseGbn       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"gubun")
ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
ls_date        = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate"))
ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")
sProcGbn       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"procgbn")
ls_saupno      = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")

IF ls_date ="" OR IsNull(ls_date) THEN
	F_MessageChk(1,'[작성일자]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_cdate")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF

IF IsNull(ll_jechul_code) THEN
	F_MessageChk(1,'[세무서코드]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_maichul_list_jechul_code")
	tab_vat.tabpage_process.dw_process.SetFocus()
	Return
END IF

s_jasacode     = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"code")
ls_saupno      = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")
ls_sanho       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sangho")

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

Integer iCount
select Count(*) into :iCount from kfz_tax_work 
	where fdate = :ls_sdate and tdate = :ls_edate and saupno = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	iCount = 0
end if
if iCount > 0 then
	if MessageBox('확 인','이미 집계자료가 있습니다. 삭제 후 다시 집계하시겠습니까?',Question!,YesNo!) = 2 then return
end if

delete from kfz_tax_title  ;
delete from kfz_tax_title2 ;
delete from kfz_tax_jip  where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_tax_list where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa;
delete from kfz_tax_work where fdate = :ls_sdate and tdate = :ls_edate and saupno = :IsCommJasa ;
commit ;

dw_title.Reset()
dw_title2.Reset()
dw_hap.Reset()
dw_list.Reset()

Double dTaxAmt
select sum(nvl(gon_amt,0)) into :dTaxAmt
	from kfz17ot0 
	where acc_date >= :ls_sdate and acc_date <= :ls_edate and jasa_cd = :IsCommJasa and tax_no in ( '19','29' ) ;
IF SQLCA.SQLCODE <> 0 THEN
	dTaxAmt = 0
ELSE
	IF IsNull(dTaxAmt) THEN dTaxAmt = 0
END IF
IF dTaxAmt = 0 THEN
	MessageBox('확 인','처리할 자료가 없습니다!!')
	w_mdi_frame.sle_msg.text =""
	Return
end if

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="계산서 자료 집계 중......"

w_mdi_frame.sle_msg.text ="계산서합계표 표지 갱신 중......"
function_chk =WF_SETTING_TITLE(s_jasacode,IsCommJasa)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 표지 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text = "계산서합계표 집계금액 갱신 중......"
function_chk = WF_SETTING_JIP(ls_sdate,ls_edate,IsCommJasa, ls_saupno)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 집계 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="계산서합계표 내역 갱신 중......"
function_chk = WF_SETTING_LIST(ls_sdate,ls_edate,IsCommJasa, ls_saupno)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 내역 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

//신고파일 생성
insert into kfz_tax_work
 ( text,
	fdate,            tdate,            saupno,                seqno)
select t.vatdata,
		 :ls_sdate,    :ls_edate,        :IsCommJasa,            rownum
from (
		select k.vatdata
		from ( //표지
				select '1' as sort, 1 as seq, 
						 gubun||rpad(nvl(taxcd,' '),3)||jdate||jgubun||rpad(nvl(kwanno,' '),6)||sano||rpad(nvl(sname,' '),40)||rpad(nvl(residno,' '),13)||rpad(nvl(owname,' '),30)||
						 rpad(nvl(posno,' '),10)||rpad(nvl(addr,' '),70)||rpad(nvl(telno,' '),15)||trim(to_char(jcnt,'00000'))||korgbn||rpad(' ',15) as vatdata
				  from kfz_tax_title
				union all
				select '2' as sort, 2 as seq, 
						 gubun||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||rpad(nvl(sname,' '),40)||rpad(nvl(owname,' '),30)||rpad(nvl(posno,' '),10)||
						 rpad(nvl(addr,' '),70)||rpad(' ',60)  as vatdata
					from kfz_tax_title2
				union all
				select '3' as sort, 1 as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||jyear||fdate||tdate||cdate||
						 trim(to_char(hap_custcnt,'000000'))||trim(to_char(hap_taxcnt,'000000'))||hap_buho||trim(to_char(hap_taxamt,'00000000000000'))||
						 trim(to_char(saup_custcnt,'000000'))||trim(to_char(saup_taxcnt,'000000'))||saup_buho||trim(to_char(saup_taxamt,'00000000000000'))||
						 trim(to_char(per_custcnt,'000000'))||trim(to_char(per_taxcnt,'000000'))||per_buho||trim(to_char(per_taxamt,'00000000000000'))||rpad(' ',97) as vatdata
					from kfz_tax_jip
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'C' and datagu = 17   
				union all
				select '4' as sort, serno as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||custno||rpad(nvl(custnm,' '),40)||
						 trim(to_char(taxcnt,'00000'))||buho||trim(to_char(taxamt,'00000000000000'))||rpad(' ',136) as vatdata
					from kfz_tax_list
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'D' and datagu = 17  
				union all
				select '5' as sort, 1 as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||jyear||fdate||tdate||cdate||
						 trim(to_char(hap_custcnt,'000000'))||trim(to_char(hap_taxcnt,'000000'))||hap_buho||trim(to_char(hap_taxamt,'00000000000000'))||
						 trim(to_char(saup_custcnt,'000000'))||trim(to_char(saup_taxcnt,'000000'))||saup_buho||trim(to_char(saup_taxamt,'00000000000000'))||
						 trim(to_char(per_custcnt,'000000'))||trim(to_char(per_taxcnt,'000000'))||per_buho||trim(to_char(per_taxamt,'00000000000000'))||rpad(' ',97) as vatdata
					from kfz_tax_jip
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'E' and datagu = 17   
				union all
				select '6' as sort, 1 as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||jyear||fdate||tdate||cdate||
						 trim(to_char(hap_custcnt,'000000'))||trim(to_char(hap_taxcnt,'000000'))||hap_buho||trim(to_char(hap_taxamt,'00000000000000'))||
						 trim(to_char(saup_custcnt,'000000'))||trim(to_char(saup_taxcnt,'000000'))||saup_buho||trim(to_char(saup_taxamt,'00000000000000'))||
						 trim(to_char(per_custcnt,'000000'))||trim(to_char(per_taxcnt,'000000'))||per_buho||trim(to_char(per_taxamt,'00000000000000'))||rpad(' ',97) as vatdata
					from kfz_tax_jip
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'C' and datagu = 18   
				union all
				select '7' as sort, serno as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||custno||rpad(nvl(custnm,' '),40)||
						 trim(to_char(taxcnt,'00000'))||buho||trim(to_char(taxamt,'00000000000000'))||rpad(' ',136) as vatdata
					from kfz_tax_list
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'D' and datagu = 18  
				union all
				select '8' as sort, 1 as seq,
						 gubun||datagu||vatgi||rptgbn||rpad(nvl(taxcd,' '),3)||trim(to_char(serno,'000000'))||sano||jyear||fdate||tdate||cdate||
						 trim(to_char(hap_custcnt,'000000'))||trim(to_char(hap_taxcnt,'000000'))||hap_buho||trim(to_char(hap_taxamt,'00000000000000'))||
						 trim(to_char(saup_custcnt,'000000'))||trim(to_char(saup_taxcnt,'000000'))||saup_buho||trim(to_char(saup_taxamt,'00000000000000'))||
						 trim(to_char(per_custcnt,'000000'))||trim(to_char(per_taxcnt,'000000'))||per_buho||trim(to_char(per_taxamt,'00000000000000'))||rpad(' ',97) as vatdata
					from kfz_tax_jip
					where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasacd = :IsCommJasa and gubun = 'E' and datagu = 18  
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
w_mdi_frame.sle_msg.text ="계산서합계표 자료 생성 완료"
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_ktxa81
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa81
integer x = 4416
integer y = 20
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa81
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa81
integer x = 4242
integer y = 20
integer taborder = 40
end type

event p_print::clicked;call super::clicked;if tab_vat.SelectedTab = 2 or tab_vat.SelectedTab = 3 then
	if tab_vat.tabpage_print1.dw_print.RowCount() > 0 then
		gi_page = tab_vat.tabpage_print1.dw_print.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_vat.tabpage_print1.dw_print)	
	end if
	if tab_vat.tabpage_print2.dw_print2.RowCount() > 0 then
		gi_page = tab_vat.tabpage_print2.dw_print2.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_vat.tabpage_print2.dw_print2)	
	end if
end if

end event

type p_inq from w_inherite`p_inq within w_ktxa81
boolean visible = false
integer x = 3561
integer y = 2716
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa81
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa81
integer x = 3584
integer y = 48
integer width = 475
integer height = 100
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\파일저장01_up.jpg"
end type

event p_mod::clicked;String  ls_sdate, ls_edate,  sPath,sSaveFile

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

type cb_exit from w_inherite`cb_exit within w_ktxa81
integer x = 3781
integer y = 3032
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa81
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
integer x = 3081
integer y = 3032
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa81
integer x = 2080
integer y = 3028
end type

type cb_del from w_inherite`cb_del within w_ktxa81
integer x = 2446
integer y = 3084
end type

type cb_inq from w_inherite`cb_inq within w_ktxa81
integer x = 2802
integer y = 3084
end type

type cb_print from w_inherite`cb_print within w_ktxa81
integer x = 3433
integer y = 3032
end type

type st_1 from w_inherite`st_1 within w_ktxa81
integer y = 2112
end type

type cb_can from w_inherite`cb_can within w_ktxa81
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa81
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa81
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa81
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa81
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa81
integer x = 2418
integer y = 3032
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa81
integer x = 3040
integer y = 2984
integer width = 1083
integer height = 180
end type

type dw_title from datawindow within w_ktxa81
boolean visible = false
integer x = 1285
integer y = 2496
integer width = 974
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "제출자"
string dataobject = "dw_ktxa222"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_hap from datawindow within w_ktxa81
boolean visible = false
integer x = 1289
integer y = 2664
integer width = 974
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "제출자별 집계"
string dataobject = "dw_ktxa223"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type dw_list from datawindow within w_ktxa81
boolean visible = false
integer x = 1280
integer y = 2780
integer width = 974
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "거래명세서"
string dataobject = "dw_ktxa226"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type tab_vat from tab within w_ktxa81
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
string text = "디스켓 작성"
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
integer y = 24
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
string dataobject = "dw_ktxa221"
boolean border = false
end type

event itemchanged;String ls_saupno,ls_sanho, ls_name, ls_uptae, ls_upjong, ls_addr1,ls_addr2,&
		 sVatGisu, sStart,   sEnd,    sProcGbn, sCommJasa, sGbn,	   snull,ls_Resident

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
		this.SetItem(this.GetRow(),"resident",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)		
		this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
		this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
	
		Return
	END IF
	
  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2","VNDMST"."RESIDENT" 
   INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,:ls_uptae,   
        :ls_upjong        ,:ls_addr1       ,:ls_addr2			,:ls_resident
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
	this.SetItem(this.GetRow(),"resident", ls_resident)
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
		this.SetItem(this.GetRow(),"resident", snull)
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
			this.SetItem(this.GetRow(),"resident", snull)
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
				this.SetItem(this.GetRow(),"resident", snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_uptae", snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_upjong",snull)
				this.SetItem(this.GetRow(),"kfz_vat_title_addr",  snull)
				Return 1
			END IF
		END IF		
		
		SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
				 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2","VNDMST"."RESIDENT"   
		INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,:ls_uptae,   
			  :ls_upjong        ,:ls_addr1       ,:ls_addr2			,:ls_resident
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
		this.SetItem(this.GetRow(),"resident", ls_resident)
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
string text = "매입처별 계산서 합계표(갑)"
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
integer x = 27
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
string dataobject = "dw_ktxa81p_i"
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
string text = "매입처별 계산서 합계표(을)"
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
string dataobject = "dw_ktxa81p_i2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_ktxa81
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
string text = "매입처별 계산서 합계표"
boolean checked = true
end type

event clicked;if this.Checked = True then
	tab_vat.tabpage_print1.text = '매입처별 계산서 합계표(갑)'
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa81p_i'
	
	tab_vat.tabpage_print2.text = '매입처별 계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa81p_i2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	
end if
end event

type rb_2 from radiobutton within w_ktxa81
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
string text = "매출처별 계산서 합계표"
end type

event clicked;if this.Checked = True then
	tab_vat.tabpage_print1.text = '매출처별 계산서 합계표(갑)'
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa81p_o'
	
	tab_vat.tabpage_print2.text = '매출처별 계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa81p_o2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	
end if
end event

type dw_title2 from datawindow within w_ktxa81
boolean visible = false
integer x = 1280
integer y = 2328
integer width = 974
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "제출자 인적사항"
string dataobject = "dw_ktxa224"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_file from datawindow within w_ktxa81
boolean visible = false
integer x = 919
integer y = 3020
integer width = 978
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "파일저장"
string dataobject = "dw_ktxa229f"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type gb_1 from groupbox within w_ktxa81
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

