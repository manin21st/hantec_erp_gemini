$PBExportHeader$w_ktxa22.srw
$PBExportComments$계산서합계표 신고서,디스켓 처리
forward
global type w_ktxa22 from w_inherite
end type
type dw_title from datawindow within w_ktxa22
end type
type dw_hap from datawindow within w_ktxa22
end type
type dw_list from datawindow within w_ktxa22
end type
type dw_work from datawindow within w_ktxa22
end type
type tab_vat from tab within w_ktxa22
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
type tabpage_label from userobject within tab_vat
end type
type rr_4 from roundrectangle within tabpage_label
end type
type dw_label from datawindow within tabpage_label
end type
type tabpage_label from userobject within tab_vat
rr_4 rr_4
dw_label dw_label
end type
type tab_vat from tab within w_ktxa22
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
tabpage_label tabpage_label
end type
type rb_1 from radiobutton within w_ktxa22
end type
type rb_2 from radiobutton within w_ktxa22
end type
type dw_rtv from datawindow within w_ktxa22
end type
type dw_title2 from datawindow within w_ktxa22
end type
type dw_file from datawindow within w_ktxa22
end type
type gb_1 from groupbox within w_ktxa22
end type
end forward

global type w_ktxa22 from w_inherite
integer height = 2412
string title = "계산서합계표 신고서,디스켓 처리"
dw_title dw_title
dw_hap dw_hap
dw_list dw_list
dw_work dw_work
tab_vat tab_vat
rb_1 rb_1
rb_2 rb_2
dw_rtv dw_rtv
dw_title2 dw_title2
dw_file dw_file
gb_1 gb_1
end type
global w_ktxa22 w_ktxa22

type variables
Int    Ii_TotalCnt
String s_jasacode,sRptPath,sApplyFlag,IsCommJasa
end variables

forward prototypes
public function integer wf_label_print ()
public function integer wf_requiredchk (integer curr_row)
public function string wf_setting_zero (integer ll_total_lenght, integer ll_data_length)
public function boolean wf_setting_title (string sjasa, string scommjasa)
public function integer wf_maiip_vat ()
public function integer wf_maichul_vat ()
public function boolean wf_clear (string sdate, string fromdate, string todate)
public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length)
public function boolean wf_setting_jip (string sjasa, string scommjasa, string staxno)
public function boolean wf_setting_list (string sjasa, string scommjasa, string staxno)
public function boolean wf_setting_work (string sfdate, string stdate)
public function string wf_amtconv (decimal decamt)
end prototypes

public function integer wf_label_print ();string sVatGisu,sDatefrom, sDateto,sCommJasa,sSano,sProcGbn,sJaSaCod

tab_vat.tabpage_process.dw_process.AcceptText()

sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") 
sDatefrom = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
sProcGbn  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"procgbn")

sJasaCod = tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"code")

IF sProcGbn = '1' THEN
	sJasaCod = '%'
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
		tab_vat.tabpage_process.dw_process.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
			tab_vat.tabpage_process.dw_process.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasaCod
END IF

tab_vat.tabpage_label.dw_label.Reset()      
		
IF tab_vat.tabpage_label.dw_label.Retrieve(sDateTo,sDateFrom,sDateTo,sJasaCod,F_Get_Refferance('AV',sVatGisu),sCommJasa) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
END IF
		
Return 1
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

public function string wf_setting_zero (integer ll_total_lenght, integer ll_data_length);Int ll_space_length
String ls_space_length

ll_space_length = ll_total_lenght - ll_data_length
CHOOSE CASE ll_space_length	
	CASE 15
		ls_space_length ='000000000000000'
	CASE 14
		ls_space_length ='00000000000000'
	CASE 13
		ls_space_length ='0000000000000'
	CASE 12
		ls_space_length ='000000000000'
	CASE 11
		ls_space_length ='00000000000'
	CASE 10
		ls_space_length ='0000000000'
	CASE 9
		ls_space_length ='000000000'
	CASE 8
		ls_space_length ='00000000'
	CASE 7
		ls_space_length ='0000000'
	CASE 6
		ls_space_length ='000000'
	CASE 5
		ls_space_length ='00000'
	CASE 4
		ls_space_length ='0000'
	CASE 3
		ls_space_length ='000'
	CASE 2
		ls_space_length ='00'
	CASE 1
		ls_space_length ='0'
	CASE 0
		ls_space_length =''
END CHOOSE
Return ls_space_length

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

public function integer wf_maiip_vat ();string sVatGisu,sDatefrom, sDateto,sCommJasa,sSano,sProcGbn,sJaSaCod,sCrtDate,sSettingGisu

tab_vat.tabpage_process.dw_process.AcceptText()

sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") 
sDatefrom = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
sProcGbn  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"procgbn")

sJasaCod = tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"code")
sCrtDate = Trim(tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"kfz_vat_title_cdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF
if sVatGisu = '1' or sVatGisu = '2' then
	sSettingGisu = '1'
else
	sSettingGisu = '2'
end if
IF sProcGbn = '1' THEN
	sJasaCod = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
	   INTO :sCommJasa  
	    FROM "SYSCNFG"  
	   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
	         ( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
		tab_vat.tabpage_process.dw_process.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
			tab_vat.tabpage_process.dw_process.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasaCod
	sApplyFlag = '%'
END IF

Int il_currow , il_RetrieveRow, i,il_dvdval

tab_vat.tabpage_print1.dw_print.Reset()
tab_vat.tabpage_print2.dw_print2.Reset()

tab_vat.tabpage_print1.dw_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_rtv.Retrieve(sDatefrom,sDateTo,sJasaCod,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_rtv.RowCount()
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="매입처별 계산서 합계표 내역 조회 중...!!!"

tab_vat.tabpage_print1.dw_print.SetRedraw(False)
tab_vat.tabpage_print2.dw_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 27 THEN															//매입처별 계산서(갑)
		tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+sSettingGisu+' 기 )'
	
		il_currow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
		
		//자사내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"cvnm",dw_rtv.GetItemString(1,"jasa_nm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"ownm",dw_rtv.GetItemString(1,"jasa_manager"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"addr",&
										dw_rtv.GetItemString(1,"jasa_add1") + dw_rtv.GetItemString(1,"jasa_add2"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"uptae",dw_rtv.GetItemString(1,"jasa_uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"jong",dw_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"symd",sDateFrom)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"eymd",sDateTo)

		//합계내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup",il_RetrieveRow)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup_nbr",dw_rtv.GetItemNumber(1,"cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_gon_amt",dw_rtv.GetItemNumber(1,"gong_sum"))

		//거래내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"addr2",       dw_rtv.GetItemString(i,"addr2"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
	ELSE																		//매입처별 계산서(을)
		tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+sSettingGisu+' 기 )'
		il_currow = tab_vat.tabpage_print2.dw_print2.Insertrow(0)
		
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"cvnm",dw_rtv.GetItemString(1,"jasa_nm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"ownm",dw_rtv.GetItemString(1,"jasa_manager"))
		
		//거래내역
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"addr2",       dw_rtv.GetItemString(i,"addr2"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
	END IF
NEXT

IF il_RetrieveRow < 27 THEN
	il_dvdval =Mod(il_RetrieveRow,27)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 26 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
		   tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seq_num",llrow )
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

tab_vat.tabpage_print1.dw_print.SetRedraw(True)
tab_vat.tabpage_print2.dw_print2.SetRedraw(True)

w_mdi_frame.sle_msg.text ="매입처별 계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

return 1


end function

public function integer wf_maichul_vat ();string sVatGisu,sDatefrom, sDateto,sCommJasa,sSano,sProcGbn,sJaSaCod,sCrtDate,sSettingGisu

tab_vat.tabpage_process.dw_process.AcceptText()

sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") 
sDatefrom = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
sProcGbn  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"procgbn")

sJasaCod = tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"code")
sCrtDate = Trim(tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"kfz_vat_title_cdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF
if sVatGisu = '1' or sVatGisu = '2' then
	sSettingGisu = '1'
else
	sSettingGisu = '2'
end if
IF sProcGbn = '1' THEN
	sJasaCod = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
	   INTO :sCommJasa  
	    FROM "SYSCNFG"  
	   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
	         ( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
		tab_vat.tabpage_process.dw_process.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			tab_vat.tabpage_process.dw_process.SetColumn("jasa_cd")
			tab_vat.tabpage_process.dw_process.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasaCod
	sApplyFlag = '%'
END IF

Int il_currow , il_RetrieveRow, i,il_dvdval

tab_vat.tabpage_print1.dw_print.Reset()
tab_vat.tabpage_print2.dw_print2.Reset()

tab_vat.tabpage_print1.dw_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_rtv.Retrieve(sDateFrom,sDateTo,sJasaCod,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_rtv.RowCount()
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="매출처별 계산서 합계표 조회 중...!!!"

tab_vat.tabpage_print1.dw_print.SetRedraw(False)
tab_vat.tabpage_print2.dw_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 21 THEN															//매출처별 계산서(갑)
		tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+sSettingGisu+' 기 )'
	
		il_currow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
		
		//자사내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"cvnm",dw_rtv.GetItemString(1,"jasa_nm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"ownm",dw_rtv.GetItemString(1,"jasa_manager"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"addr",&
				dw_rtv.GetItemString(1,"jasa_add1") + dw_rtv.GetItemString(1,"jasa_add2"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"uptae",dw_rtv.GetItemString(1,"jasa_uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"jong",dw_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"symd",sDateFrom)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"eymd",sDateTo)

		//합계내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup",dw_rtv.GetItemNumber(1,"sum_cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup_nbr",dw_rtv.GetItemNumber(1,"sum_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_gon_amt",dw_rtv.GetItemNumber(1,"sum_gong"))

		//개인
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_num",dw_rtv.GetItemNumber(1,"per_cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_gensu",dw_rtv.GetItemNumber(1,"per_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_gon_sum",dw_rtv.GetItemNumber(1,"per_gong_sum"))
		
		//사업자등록번호
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_num",dw_rtv.GetItemNumber(1,"sano_cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_gensu",dw_rtv.GetItemNumber(1,"sano_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_gon_sum",dw_rtv.GetItemNumber(1,"sano_gong_sum"))
		
		//거래내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"addr2",       dw_rtv.GetItemString(i,"addr2"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
	ELSE																		//매출처별 계산서(을)
		tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+sSettingGisu+' 기 )'
		
		il_currow = tab_vat.tabpage_print2.dw_print2.Insertrow(0)
		
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"cvnm",dw_rtv.GetItemString(1,"jasa_nm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"ownm",dw_rtv.GetItemString(1,"jasa_manager"))
		
		//거래내역
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"addr2",       dw_rtv.GetItemString(i,"addr2"))		
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
	END IF
NEXT

IF il_RetrieveRow < 21 THEN
	il_dvdval =Mod(il_RetrieveRow,21)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 20 STEP 1
			int llrow
			
			llrow = tab_vat.tabpage_print1.dw_print.InsertRow(0)
			
		   tab_vat.tabpage_print1.dw_print.SetItem(llrow,"seq_num",llrow )
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

tab_vat.tabpage_print1.dw_print.SetRedraw(True)
tab_vat.tabpage_print2.dw_print2.SetRedraw(True)

w_mdi_frame.sle_msg.text ="매출처별 계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)


Return 1
end function

public function boolean wf_clear (string sdate, string fromdate, string todate);Int ll_sqlcode
String ls_date

ls_date =Mid(sdate,3,2)+Mid(sdate,5,2)+Right(sdate,2)

dw_title.Reset()

DELETE FROM "KFZ_TAX_TITLE" ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 제출자레코드 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_TAX_TITLE2" ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 제출자인적사항 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_TAX_JIP"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 제출자별집계 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_TAX_LIST"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 거래명세서 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_TAX_WORK"
WHERE "FDATE" = :fromdate AND "TDATE" = :todate AND "SAUPNO" = :IsCommJasa;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 작업용 삭제 실패.!!!")
	Return False
END IF

IF ll_sqlcode =1 THEN
	Return True
END IF
end function

public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length);Int ll_space_length
String ls_space_length

ll_space_length = ll_total_lenght - ll_data_length
CHOOSE CASE ll_space_length
	Case 151
		ls_space_length ='                                                                         '
	CASE 70
		ls_space_length ='                                                                      '
	CASE 69
		ls_space_length ='                                                                     '
	CASE 68
		ls_space_length ='                                                                    '	
	CASE 67
		ls_space_length ='                                                                   '		
	CASE 60
		ls_space_length ='                                                            '	
	CASE 59
		ls_space_length ='                                                           '		
	CASE 58
		ls_space_length ='                                                          '
	CASE 57
		ls_space_length ='                                                         '	
	CASE 56
		ls_space_length ='                                                        '		
	CASE 55
		ls_space_length ='                                                       '			
	CASE 54
		ls_space_length ='                                                      '				
	CASE 53
		ls_space_length ='                                                     '					
	CASE 52
		ls_space_length ='                                                    '						
	CASE 51
		ls_space_length ='                                                   '							
	CASE 50
		ls_space_length ='                                                  '
	CASE 49
		ls_space_length ='                                                 '
	CASE 48
		ls_space_length ='                                                '
	CASE 47
		ls_space_length ='                                               '
	CASE 46
		ls_space_length ='                                              '	
	CASE 45				  
		ls_space_length ='                                             '
	CASE 44
		ls_space_length ='                                            '
	CASE 43
		ls_space_length ='                                           '
	CASE 42
		ls_space_length ='                                          '
	CASE 41
		ls_space_length ='                                         '
	CASE 40
		ls_space_length ='                                        '
	CASE 39
		ls_space_length ='                                       '
	CASE 38
		ls_space_length ='                                      '
	CASE 37
		ls_space_length ='                                     '
	CASE 36
		ls_space_length ='                                    '
	CASE 35
		ls_space_length ='                                   '
	CASE 34
		ls_space_length ='                                  '
	CASE 33
		ls_space_length ='                                 '
	CASE 32
		ls_space_length ='                                '
	CASE 31
		ls_space_length ='                               '
	CASE 30
		ls_space_length ='                              '
	CASE 29
		ls_space_length ='                             '
	CASE 28
		ls_space_length ='                            '
	CASE 27
		ls_space_length ='                           '
	CASE 26
		ls_space_length ='                          '
	CASE 25
		ls_space_length ='                         '
	CASE 24
		ls_space_length ='                        '
	CASE 23
		ls_space_length ='                       '
	CASE 22
		ls_space_length ='                      '
	CASE 21
		ls_space_length ='                     '
	CASE 20
		ls_space_length ='                    '
	CASE 19
		ls_space_length ='                   '
	CASE 18
		ls_space_length ='                  '
	CASE 17				   
		ls_space_length ='                 '
	CASE 16
		ls_space_length ='                '
	CASE 15
		ls_space_length ='               '
	CASE 14
		ls_space_length ='              '
	CASE 13
		ls_space_length ='             '
	CASE 12
		ls_space_length ='            '
	CASE 11
		ls_space_length ='           '
	CASE 10
		ls_space_length ='          '
	CASE 9
		ls_space_length ='         '
	CASE 8
		ls_space_length ='        '
	CASE 7
		ls_space_length ='       '
	CASE 6
		ls_space_length ='      '
	CASE 5
		ls_space_length ='     '
	CASE 4
		ls_space_length ='    '
	CASE 3
		ls_space_length ='   '
	CASE 2
		ls_space_length ='  '
	CASE 1
		ls_space_length =' '
	CASE 0
		ls_space_length =''
END CHOOSE
Return ls_space_length

end function

public function boolean wf_setting_jip (string sjasa, string scommjasa, string staxno);String  ls_sdate,ls_edate,ls_date,ls_saupno,ls_Gisu
Long    lTaxCode,lSpaceLength
Integer iLoopCnt, iCurCnt,iCustCnt,iTaxCnt,iDatagu
Double  dTaxAmt

tab_vat.tabpage_process.dw_process.AcceptText()

ls_sdate  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate")
ls_edate  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate")
ls_date   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
lTaxCode  = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

ls_Gisu   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu")

IF Left(sTaxNo,1) = '1' THEN								/*자료구분 - 매입*/
	iDataGu = 18
ELSE
	iDataGu = 17
END IF
	
dw_hap.Retrieve(iDataGu,'%')

DECLARE taxlst CURSOR FOR  
	SELECT "VNDMST"."SANO",
			 Count(DISTINCT "KFZ17OT0"."SAUP_NO2"),
			 NVL(SUM(DECODE("KFZ17OT0"."TAXGBN",'Y',1,0)),0),
			 SUM("KFZ17OT0"."GON_AMT")
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
			( "KFZ17OT0"."TAX_NO" = :sTaxNo ) 
	GROUP BY "VNDMST"."SANO";

OPEN TaxLst;

iLoopCnt = 1;		

DO  WHILE True
	FETCH TaxLst INTO :ls_saupno,			:iCustCnt,		:iTaxCnt,		:dTaxAmt;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
		
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
	dw_hap.SetItem(iCurCnt,"serno",  iLoopCnt)
	dw_hap.SetItem(iCurCnt,"sano",   ls_saupno)

	dw_hap.SetItem(iCurCnt,"jyear",  		Long(Left(ls_sdate,4)))
	dw_hap.SetItem(iCurCnt,"fdate",  		ls_sdate)
	dw_hap.SetItem(iCurCnt,"tdate",  		ls_edate)
	dw_hap.SetItem(iCurCnt,"cdate",  		ls_date)
	
	dw_hap.SetItem(iCurCnt,"hap_custcnt",  iCustCnt)			/*합계*/
	dw_hap.SetItem(iCurCnt,"hap_taxcnt",   iTaxCnt)
	
	if dTaxAmt >= 0 then													/*양수:0/음수:1)*/
		dw_hap.SetItem(iCurCnt,"hap_buho",  0)
	else
		dw_hap.SetItem(iCurCnt,"hap_buho",  1)
	end if
	dw_hap.SetItem(iCurCnt,"hap_taxamt",   dTaxAmt)
	
	if iDataGu = 17 then											/*매출*/
		dw_hap.SetItem(iCurCnt,"saup_custcnt",  iCustCnt)			/*사업자별*/
		dw_hap.SetItem(iCurCnt,"saup_taxcnt",   iTaxCnt)
		
		if dTaxAmt >= 0 then											
			dw_hap.SetItem(iCurCnt,"saup_buho",  0)
		else
			dw_hap.SetItem(iCurCnt,"saup_buho",  1)
		end if
		dw_hap.SetItem(iCurCnt,"saup_taxamt",   dTaxAmt)
		
		dw_hap.SetItem(iCurCnt,"per_custcnt",  0)						/*개인별*/
		dw_hap.SetItem(iCurCnt,"per_taxcnt",   0)
		
		dTaxAmt = 0
		if dTaxAmt >= 0 then											
			dw_hap.SetItem(iCurCnt,"per_buho",  0)
		else
			dw_hap.SetItem(iCurCnt,"per_buho",  1)
		end if
		dw_hap.SetItem(iCurCnt,"per_taxamt",   0)
	end if
	
	iLoopCnt += 1
LOOP
CLOSE TaxLst;

IF dw_hap.Update() <> 1 THEN						/*제출자 인적사항*/
	Return False
END IF
Commit;

Return True


end function

public function boolean wf_setting_list (string sjasa, string scommjasa, string staxno);String  ls_sdate,ls_edate,ls_date,ls_saupno,ls_Gisu,ls_sangho,ls_custno
Long    lTaxCode,lSpaceLength
Integer iLoopCnt, iCurCnt,iCustCnt,iTaxCnt,iDatagu
Double  dTaxAmt

tab_vat.tabpage_process.dw_process.AcceptText()

ls_sdate  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate")
ls_edate  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate")
ls_date   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
lTaxCode  = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

ls_Gisu   = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu")

IF Left(sTaxNo,1) = '1' THEN								/*자료구분 - 매입*/
	iDataGu = 18
ELSE
	iDataGu = 17
END IF
	
dw_list.Retrieve(iDataGu,'%')

DECLARE taxlst CURSOR FOR  
	SELECT "VNDMST"."SANO",
			 "KFZ17OT0"."SAUP_NO2",
			DECODE(SAUP."CVGU",'9',"KFZ17OT0"."CVNAS",NULL,"KFZ17OT0"."CVNAS",SAUP."CVNAS") AS  cvname,   //2008.01.25 -2기확정때 수정
			 NVL(SUM(DECODE("KFZ17OT0"."TAXGBN",'Y',1,0)),0),
			 SUM("KFZ17OT0"."GON_AMT")
	FROM "KFZ17OT0", "REFFPF", "VNDMST", VNDMST SAUP   //2008.01.25 -2기확정때 수정
	WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF"."RFGUB" ) and  
			( "KFZ17OT0"."JASA_CD" = "VNDMST"."CVCOD") AND
			  ( "KFZ17OT0"."SAUP_NO" = SAUP.CVCOD(+) ) AND     //2008.01.25 -2기확정때 수정
			("KFZ17OT0"."JASA_CD" like :sjasa ) AND
			(( "KFZ17OT0"."ACC_DATE" >= :ls_sdate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :ls_edate )) AND 				
			( "REFFPF"."RFCOD" = 'JA') AND
			( "REFFPF"."RFGUB" <> '00') AND
			(SUBSTR("REFFPF"."RFNA2",1,1) LIKE :sApplyFlag) AND   
			( "KFZ17OT0"."ALC_GU" = 'Y') AND  
			( "KFZ17OT0"."TAX_NO" = :sTaxNo ) 
	GROUP BY "VNDMST"."SANO",
			 "KFZ17OT0"."SAUP_NO2",
			 DECODE(SAUP."CVGU",'9',"KFZ17OT0"."CVNAS",NULL,"KFZ17OT0"."CVNAS",SAUP."CVNAS")  ; //2008.01.25 -2기확정때 수정

OPEN TaxLst;

iLoopCnt = 1;		

DO  WHILE True
	FETCH TaxLst INTO :ls_saupno,			:ls_custno,		:ls_sangho,		:iTaxCnt,		:dTaxAmt;
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
	dw_list.SetItem(iCurCnt,"sano",   ls_saupno)
	dw_list.SetItem(iCurCnt,"custno",   ls_custno)
	dw_list.SetItem(iCurCnt,"custnm",   ls_sangho)
	
	dw_list.SetItem(iCurCnt,"taxcnt",   iTaxCnt)
	
	if dTaxAmt >= 0 then													/*양수:0/음수:1)*/
		dw_list.SetItem(iCurCnt,"buho",  0)
	else
		dw_list.SetItem(iCurCnt,"buho",  1)
	end if
	dw_list.SetItem(iCurCnt,"taxamt",   dTaxAmt)
	
	iLoopCnt += 1
LOOP
CLOSE TaxLst;

IF dw_list.Update() <> 1 THEN						/*제출자 인적사항*/
	Return False
END IF
Commit;

Return True


end function

public function boolean wf_setting_work (string sfdate, string stdate);Integer k,i,iCurRow,iJcnt,iKorGbn,iJgbn,iSpacelength,iRowCount,iCustCntH,iTaxCntH,iBuhoH,iDataGu,&
		  iCustCntP,iTaxCntP,iBuhoP,iDetailCnt
String  sGubun,sTaxCd,sJdate,sKwanNo,sSano,sName,sResid,sOwnam,sPosNo,sAddr,sTelNo,sBigo,sJcnt,&
		  sReqSano,sCustNo,sSettingText,sSpace
Long    lSerNo
Double  dTaxAmtH,dTaxAmtP

dw_work.Reset()
dw_work.Retrieve(sFDate,sTdate,IsCommJaSa)

/*제출자 레코드*/
select gubun,		taxcd,					jdate,					jgubun,					kwanno,		sano,
		 sname,		nvl(residno,' '),		nvl(owname,' '),		nvl(posno,' '),		addr,			nvl(telno,' '),
		 jcnt,		korgbn
into :sGubun,		:sTaxCd,		:sJdate,		:iJgbn,		:sKwanNo,	:sSano,
	  :sName,		:sResid,		:sOwnam,		:sPosno,		:sAddr,		:sTelno,
	  :ijCnt,		:iKorgbn
from kfz_tax_title;

if sqlca.sqlcode <> 0 then
	Return False
end if
Ii_TotalCnt = 1

iSpacelength =LenA(sSano)
sSano =sSano + WF_SETTING_SPACE(10,  iSpacelength)

iSpacelength =LenA(sName)
sName = sName + WF_SETTING_SPACE(40,  iSpacelength)

iSpacelength =LenA(sResid)
sResid = sResid + WF_SETTING_SPACE(13,  iSpacelength)

iSpacelength =LenA(sOwnam)
sOwnam = sOwnam + WF_SETTING_SPACE(30,  iSpacelength)

iSpacelength =LenA(sPosno)
sPosno = sPosno + WF_SETTING_SPACE(10,  iSpacelength)

iSpacelength =LenA(sAddr)
sAddr = sAddr + WF_SETTING_SPACE(70,  iSpacelength)

iSpacelength =LenA(sTelno)
sTelno = sTelno + WF_SETTING_SPACE(15,  iSpacelength)

sJCnt  = String(ijCnt,'00000')

sSpace = WF_SETTING_SPACE(15,  0)

sSettingText = sGubun + sTaxCd + sJDate + String(iJgbn) + WF_SETTING_SPACE(6,0) + sSano + &
					sName + sResid + sOwNam + sPosNo + sAddr + sTelNo + sJCnt + String(iKorGbn) + sSpace 
				
iCurRow = dw_work.InsertRow(0)
dw_work.SetItem(iCurRow,"fdate",  sFdate)
dw_work.SetItem(iCurRow,"tdate",  sTdate)
dw_work.SetItem(iCurRow,"saupno", IsCommJasa)
dw_work.SetItem(iCurRow,"seqno",  Ii_TotalCnt)
dw_work.SetItem(iCurRow,"text",   sSettingText)

declare TaxLst Cursor For				/*제출자 인적사항*/
	select gubun,		taxcd,		serno,		nvl(sano,' '),		nvl(sname,' '),		nvl(owname,' '),		nvl(posno,' '),		nvl(addr,' ')
		from kfz_tax_title2
		order by serno ;
		
OPEN TaxLst;	

DO  WHILE True
	FETCH TaxLst INTO :sGubun,		:sTaxCd,		:lSerNo,	:sSano,	:sName,	:sOwnam,	:sPosNo,	:sAddr ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
		
	sSettingText = '';		sBigo = '';
	
	Ii_TotalCnt = Ii_TotalCnt + 1
	
	sReqSano = sSano
	
	iSpacelength =LenA(sSano)
	sSano =sSano + WF_SETTING_SPACE(10,  iSpacelength)
	
	iSpacelength =LenA(sName)
	sName = sName + WF_SETTING_SPACE(40,  iSpacelength)
	
	iSpacelength =LenA(sOwnam)
	sOwnam = sOwnam + WF_SETTING_SPACE(30,  iSpacelength)
	
	iSpacelength =LenA(sPosno)
	sPosno = sPosno + WF_SETTING_SPACE(10,  iSpacelength)
	
	iSpacelength =LenA(sAddr)
	sAddr = sAddr + WF_SETTING_SPACE(70,  iSpacelength)
	
	sSpace = WF_SETTING_SPACE(60,  0)
	
	sSettingText = sGubun + sTaxCd + String(lSerNo,'000000') + sSano + sName + sOwNam + sPosNo + &
						sAddr + sSpace

	iCurRow = dw_work.InsertRow(0)
	dw_work.SetItem(iCurRow,"fdate",  sFdate)
	dw_work.SetItem(iCurRow,"tdate",  sTdate)
	dw_work.SetItem(iCurRow,"saupno", IsCommJasa)
	dw_work.SetItem(iCurRow,"seqno",  Ii_TotalCnt)
	dw_work.SetItem(iCurRow,"text",   sSettingText)

	for iDataGu = 17 to 18
		iRowCount = dw_hap.Retrieve(iDataGu,sReqSano)		/*매출 집계*/
		if iRowCount > 0 then
			for k = 1 to iRowCount
				sSettingText = '';		
				
				Ii_TotalCnt = Ii_TotalCnt + 1
				
				lSerNo   = dw_hap.GetItemNumber(k,"serno")
				
				iCustCntH = dw_hap.GetItemNumber(k,"hap_custcnt")
				iTaxCntH  = dw_hap.GetItemNumber(k,"hap_taxcnt")
				iBuhoH    = dw_hap.GetItemNumber(k,"hap_buho")
				dTaxAmtH  = dw_hap.GetItemNumber(k,"hap_taxamt")
				
				if IsNull(iCustCntH) then iCustCntH = 0
				if IsNull(iTaxCntH) then iTaxCntH = 0
				if IsNull(dTaxAmtH) then dTaxAmtH = 0
				
				IF iDataGu = 17 THEN						/*매출이면*/
					sBigo = '                                                                                                 '
					
					iCustCntP = dw_hap.GetItemNumber(k,"per_custcnt")
					iTaxCntP  = dw_hap.GetItemNumber(k,"per_taxcnt")
					iBuhoP    = dw_hap.GetItemNumber(k,"per_buho")
					dTaxAmtP  = dw_hap.GetItemNumber(k,"per_taxamt")
					
					if IsNull(iCustCntP) then iCustCntP = 0
					if IsNull(iTaxCntP) then iTaxCntP = 0
					if IsNull(dTaxAmtP) then dTaxAmtP = 0
				
					sSettingText = dw_hap.GetItemString(k,"gubun") + String(iDataGu,'00') + &
										dw_hap.GetItemString(k,"vatgi") + dw_hap.GetItemString(k,"rptgbn") + &
										dw_hap.GetItemString(k,"taxcd") + String(lSerNo,'000000') + sSano + &
										String(dw_hap.GetItemNumber(k,"jyear"),'0000') + &
										dw_hap.GetItemString(k,"fdate") + dw_hap.GetItemString(k,"tdate") + &
										dw_hap.GetItemString(k,"cdate") + String(iCustCntH,'000000') + &
										String(iTaxCntH,'000000') + String(iBuhoH) + &
										String(Abs(dTaxAmtH),'00000000000000') + &
										String(iCustCntH,'000000') + String(iTaxCntH,'000000') + &
										String(iBuhoH) + String(Abs(dTaxAmtH),'00000000000000') + &
										String(iCustCntP,'000000') + String(iTaxCntP,'000000') + &
										String(iBuhoP) + String(Abs(dTaxAmtP),'00000000000000') + sBigo
					
				ELSE
					sBigo = '                                                                                                                                                       ';
					sSettingText = dw_hap.GetItemString(k,"gubun") + String(iDataGu,'00') + &
										dw_hap.GetItemString(k,"vatgi") + dw_hap.GetItemString(k,"rptgbn") + &
										dw_hap.GetItemString(k,"taxcd") + String(lSerNo,'000000') + sSano + &
										String(dw_hap.GetItemNumber(k,"jyear"),'0000') + &
										dw_hap.GetItemString(k,"fdate") + dw_hap.GetItemString(k,"tdate") + &
										dw_hap.GetItemString(k,"cdate") + String(iCustCntH,'000000') + &
										String(iTaxCntH,'000000') + String(iBuhoH) + &
										String(Abs(dTaxAmtH),'00000000000000') + sBigo
					
				END IF
				
				iCurRow = dw_work.InsertRow(0)
				dw_work.SetItem(iCurRow,"fdate",  sFdate)
				dw_work.SetItem(iCurRow,"tdate",  sTdate)
				dw_work.SetItem(iCurRow,"saupno", IsCommJasa)
				dw_work.SetItem(iCurRow,"seqno",  Ii_TotalCnt)
				dw_work.SetItem(iCurRow,"text",sSettingText)
				
				/*거래명세*/
				iDetailCnt = dw_list.Retrieve(iDataGu,sReqSano)
				if iDetailCnt > 0 then
					for i = 1 to iDetailCnt
						sSettingText = '';		
						
						Ii_TotalCnt = Ii_TotalCnt + 1
						
						lSerNo   = dw_list.GetItemNumber(i,"serno")
						
						sCustNo  = dw_list.GetItemString(i,"custno")
						sName    = dw_list.GetItemString(i,"custnm")
						
						iTaxCntH  = dw_list.GetItemNumber(i,"taxcnt")
						iBuhoH    = dw_list.GetItemNumber(i,"buho")
						dTaxAmtH  = dw_list.GetItemNumber(i,"taxamt")
						
						if IsNull(iTaxCntH) then iTaxCntH = 0
						if IsNull(dTaxAmtH) then dTaxAmtH = 0
						
						iSpacelength =LenA(sCustNo)
						sCustNo =sCustNo + WF_SETTING_SPACE(10,  iSpacelength)
						
						iSpacelength =LenA(sName)
						sName = sName + WF_SETTING_SPACE(40,  iSpacelength)
		
						sBigo = '                                                                                                                                        ' 
						sSettingText = dw_list.GetItemString(i,"gubun") + String(iDataGu,'00') + &
											dw_list.GetItemString(i,"vatgi") + dw_list.GetItemString(i,"rptgbn") + &
											dw_list.GetItemString(i,"taxcd") + String(lSerNo,'000000') + sSano + &
											sCustNo + sName + String(iTaxCntH,'00000') + String(iBuhoH) + &
											String(Abs(dTaxAmtH),'00000000000000') + sBigo
									
						iCurRow = dw_work.InsertRow(0)
						dw_work.SetItem(iCurRow,"fdate",  sFdate)
						dw_work.SetItem(iCurRow,"tdate",  sTdate)
						dw_work.SetItem(iCurRow,"saupno", IsCommJasa)
						dw_work.SetItem(iCurRow,"seqno",  Ii_TotalCnt)
						dw_work.SetItem(iCurRow,"text",sSettingText)
					next		
				end if
				
			next
		end if
		
	NEXT
LOOP
CLOSE TaxLst;
IF dw_work.Update() =1 THEN
	Commit;
	
	Return True
ELSE
	Return False
END IF
end function

public function string wf_amtconv (decimal decamt);String  sAmt
Integer nLen

//소숫점 이하 삭제
sAmt = String(decAmt,'###')
nLen = LenA(sAmt)
IF decAmt < 0 THEN
	CHOOSE CASE Right(sAmt,1)
		CASE '0'
			sAmt = Mid(sAmt,2,nLen - 2) + '}'
		CASE '1'
			sAmt = Mid(sAmt,2,nLen - 2) + 'J'
		CASE '2'
			sAmt = Mid(sAmt,2,nLen - 2) + 'K'
		CASE '3'
			sAmt = Mid(sAmt,2,nLen - 2) + 'L'
		CASE '4'
			sAmt = Mid(sAmt,2,nLen - 2) + 'M'
		CASE '5'
			sAmt = Mid(sAmt,2,nLen - 2) + 'N'
		CASE '6'
			sAmt = Mid(sAmt,2,nLen - 2) + 'O'
		CASE '7'
			sAmt = Mid(sAmt,2,nLen - 2) + 'P'
		CASE '8'
			sAmt = Mid(sAmt,2,nLen - 2) + 'Q'
		CASE '9'
			sAmt = Mid(sAmt,2,nLen - 2) + 'R'
	END CHOOSE
END IF
Return sAmt
end function

event open;call super::open;String mm,dd,sJasa,sSano,sName,sJasaName,sUptae,sUpjong,sAddr,sStart,sEnd,sVatGisu,sPath
		 
tab_vat.tabpage_process.dw_process.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)
tab_vat.tabpage_label.dw_label.SetTransObject(SQLCA)

dw_title.SetTransObject(SQLCA)
dw_title2.SetTransObject(SQLCA)
dw_work.SetTransObject(SQLCA)
dw_file.SetTransObject(SQLCA)
dw_hap.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_rtv.SetTransObject(SQLCA)

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

on w_ktxa22.create
int iCurrent
call super::create
this.dw_title=create dw_title
this.dw_hap=create dw_hap
this.dw_list=create dw_list
this.dw_work=create dw_work
this.tab_vat=create tab_vat
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_rtv=create dw_rtv
this.dw_title2=create dw_title2
this.dw_file=create dw_file
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_title
this.Control[iCurrent+2]=this.dw_hap
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_work
this.Control[iCurrent+5]=this.tab_vat
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.dw_rtv
this.Control[iCurrent+9]=this.dw_title2
this.Control[iCurrent+10]=this.dw_file
this.Control[iCurrent+11]=this.gb_1
end on

on w_ktxa22.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_title)
destroy(this.dw_hap)
destroy(this.dw_list)
destroy(this.dw_work)
destroy(this.tab_vat)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_rtv)
destroy(this.dw_title2)
destroy(this.dw_file)
destroy(this.gb_1)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa22
boolean visible = false
integer x = 1696
integer y = 2804
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa22
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa22
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa22
boolean visible = false
integer x = 3369
integer y = 2716
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa22
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa22
integer x = 4416
integer y = 20
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa22
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa22
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
else
	gi_page = tab_vat.tabpage_label.dw_label.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options,tab_vat.tabpage_label.dw_label)	
end if

end event

type p_inq from w_inherite`p_inq within w_ktxa22
boolean visible = false
integer x = 3561
integer y = 2716
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa22
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa22
integer x = 4069
integer y = 20
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;String  ls_sdate, ls_edate,  ls_date, ls_saupno,ls_sanho,&
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

IF sProcGbn = '1' THEN
	s_jasacode = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :IsCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		Return 
	ELSE
		IF IsNull(IsCommJasa) OR IsCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			Return 1
		END IF
	END IF
ELSE
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
END IF
			
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="계산서합계표 관련 초기화 중......"

/*계산서합계표 디스켓처리 관련 데이터 삭제*/
function_chk =WF_CLEAR(ls_date,ls_sdate,ls_edate)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 데이터 초기화 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

Double dTaxAmt

SELECT SUM("KFZ17OT0"."GON_AMT")
	INTO :dTaxAmt
	FROM "KFZ17OT0", "REFFPF", "VNDMST"
	WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF"."RFGUB" ) and  
			( "KFZ17OT0"."JASA_CD" = "VNDMST"."CVCOD") AND
			("KFZ17OT0"."JASA_CD" like :s_jasacode ) AND
			(( "KFZ17OT0"."ACC_DATE" >= :ls_sdate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :ls_edate )) AND 				
			( "REFFPF"."RFCOD" = 'JA') AND
			( "REFFPF"."RFGUB" <> '00') AND
			(SUBSTR("REFFPF"."RFNA2",1,1) LIKE '%') AND   
			( "KFZ17OT0"."ALC_GU" = 'Y') AND  
			( "KFZ17OT0"."TAX_NO" in ('19','29') )  ;
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

w_mdi_frame.sle_msg.text ="계산서합계표 표지 갱신 중......"
function_chk =WF_SETTING_TITLE(s_jasacode,IsCommJasa)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 표지 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF
w_mdi_frame.sle_msg.text = "계산서합계표 매출합계 갱신 중......"
function_chk = WF_SETTING_JIP(s_jasacode,IsCommJasa,'29')
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 매출합계 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="계산서합계표 매출자료 갱신 중......"
function_chk = WF_SETTING_LIST(s_jasacode,IsCommJasa,'29')
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 매출자료 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="계산서합계표 매입합계 갱신 중......"
function_chk =WF_SETTING_JIP(s_jasacode,IsCommJasa,'19')
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 매입합계 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="계산서합계표 매입자료 갱신 중......"
function_chk =WF_SETTING_LIST(s_jasacode,IsCommJasa,'19')
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 매입자료 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="계산서합계표 내역을  TEXT로 받는 중입니다.!!!"
function_chk =WF_SETTING_WORK(ls_sdate,ls_edate)
IF function_chk =False THEN
	MessageBox("확 인","계산서합계표 처리 작업용 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
END IF

COMMIT;

/*화일 저장 위치*/
String sFileName
sPath       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"spath")
sFileName	= tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"savefilename")

sSaveFile   = sPath + sFileName

dw_file.Retrieve(ls_sDate,ls_edate,IsCommJaSa)
dw_file.SaveAs(sSaveFile, TEXT!, FALSE)

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="계산서합계표 디스켓처리 완료"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_ktxa22
integer x = 3781
integer y = 3032
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa22
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
integer x = 3081
integer y = 3032
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa22
integer x = 2080
integer y = 3028
end type

type cb_del from w_inherite`cb_del within w_ktxa22
integer x = 2446
integer y = 3084
end type

type cb_inq from w_inherite`cb_inq within w_ktxa22
integer x = 2802
integer y = 3084
end type

type cb_print from w_inherite`cb_print within w_ktxa22
integer x = 3433
integer y = 3032
end type

type st_1 from w_inherite`st_1 within w_ktxa22
integer y = 2112
end type

type cb_can from w_inherite`cb_can within w_ktxa22
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa22
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa22
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa22
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa22
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa22
integer x = 2418
integer y = 3032
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa22
integer x = 3040
integer y = 2984
integer width = 1083
integer height = 180
end type

type dw_title from datawindow within w_ktxa22
boolean visible = false
integer x = 101
integer y = 3016
integer width = 1266
integer height = 100
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

type dw_hap from datawindow within w_ktxa22
boolean visible = false
integer x = 101
integer y = 2792
integer width = 1266
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "제출자별 집계"
string dataobject = "dw_ktxa223"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type dw_list from datawindow within w_ktxa22
boolean visible = false
integer x = 101
integer y = 2648
integer width = 1266
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "거래명세서"
string dataobject = "dw_ktxa226"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_work from datawindow within w_ktxa22
boolean visible = false
integer x = 137
integer y = 2516
integer width = 1266
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "최종저장"
string dataobject = "dw_ktxa229"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type tab_vat from tab within w_ktxa22
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
tabpage_label tabpage_label
end type

on tab_vat.create
this.tabpage_process=create tabpage_process
this.tabpage_print1=create tabpage_print1
this.tabpage_print2=create tabpage_print2
this.tabpage_label=create tabpage_label
this.Control[]={this.tabpage_process,&
this.tabpage_print1,&
this.tabpage_print2,&
this.tabpage_label}
end on

on tab_vat.destroy
destroy(this.tabpage_process)
destroy(this.tabpage_print1)
destroy(this.tabpage_print2)
destroy(this.tabpage_label)
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
	else
		if Wf_Label_Print() = -1 then 
			p_print.Enabled = False
		else
			p_print.Enabled = True
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
		/*2008.01.30 2기확정때는 거래년도를 현재년에에서 1년 빼주도록 한다. - JSW */
		String sGisu, sYYYY
		SELECT rfgub, SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
			INTO :sGisu, :sStart,								:sEnd  
   		FROM "REFFPF"  
		   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
		if sGisu = '4' then
			sYYYY = string(long(Left(f_Today(),4))-1)
		else
			sYYYY = Left(f_Today(),4)
		end if
		this.SetItem(this.GetRow(),"kfz_vat_title_sdate",sYYYY+sStart)
		this.SetItem(this.GetRow(),"kfz_vat_title_edate",sYYYY+sEnd)	
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
string dataobject = "dw_ktxa22p"
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
string dataobject = "dw_ktxa22p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_label from userobject within tab_vat
boolean visible = false
integer x = 18
integer y = 96
integer width = 4485
integer height = 1936
long backcolor = 32106727
string text = "디스켓 표지"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_label dw_label
end type

on tabpage_label.create
this.rr_4=create rr_4
this.dw_label=create dw_label
this.Control[]={this.rr_4,&
this.dw_label}
end on

on tabpage_label.destroy
destroy(this.rr_4)
destroy(this.dw_label)
end on

type rr_4 from roundrectangle within tabpage_label
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4434
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_label from datawindow within tabpage_label
integer x = 41
integer y = 32
integer width = 4407
integer height = 1884
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa22l"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_ktxa22
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
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa22p'
	
	tab_vat.tabpage_print2.text = '매입처별 계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa22p1' 
	
	dw_rtv.DataObject = 'dw_ktxa22p2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	dw_rtv.SetTransObject(Sqlca)
end if
end event

type rb_2 from radiobutton within w_ktxa22
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
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa22po'
	
	tab_vat.tabpage_print2.text = '매출처별 계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa22po1' 
	
	dw_rtv.DataObject = 'dw_ktxa22po2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	dw_rtv.SetTransObject(Sqlca)
end if
end event

type dw_rtv from datawindow within w_ktxa22
boolean visible = false
integer x = 2391
integer y = 2560
integer width = 869
integer height = 112
boolean bringtotop = true
boolean titlebar = true
string title = "계산서합계표 조회"
string dataobject = "dw_ktxa22p2"
boolean border = false
boolean livescroll = true
end type

type dw_title2 from datawindow within w_ktxa22
boolean visible = false
integer x = 101
integer y = 2904
integer width = 1266
integer height = 100
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

type dw_file from datawindow within w_ktxa22
boolean visible = false
integer x = 1463
integer y = 2632
integer width = 978
integer height = 172
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

type gb_1 from groupbox within w_ktxa22
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

