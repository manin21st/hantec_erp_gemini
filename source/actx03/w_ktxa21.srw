$PBExportHeader$w_ktxa21.srw
$PBExportComments$세금계산서합계표 신고서,디스켓 처리
forward
global type w_ktxa21 from w_inherite
end type
type dw_title from datawindow within w_ktxa21
end type
type dw_maichul_hap from datawindow within w_ktxa21
end type
type dw_maichul_list from datawindow within w_ktxa21
end type
type dw_maiip_hap from datawindow within w_ktxa21
end type
type dw_maiip_list from datawindow within w_ktxa21
end type
type dw_work from datawindow within w_ktxa21
end type
type dw_maisu from datawindow within w_ktxa21
end type
type dw_maisu_maiip from datawindow within w_ktxa21
end type
type tab_vat from tab within w_ktxa21
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
type tab_vat from tab within w_ktxa21
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
tabpage_label tabpage_label
end type
type rb_1 from radiobutton within w_ktxa21
end type
type rb_2 from radiobutton within w_ktxa21
end type
type dw_rtv from datawindow within w_ktxa21
end type
type dw_file from datawindow within w_ktxa21
end type
type gb_1 from groupbox within w_ktxa21
end type
end forward

global type w_ktxa21 from w_inherite
string title = "세금계산서합계표 신고서,디스켓 처리"
dw_title dw_title
dw_maichul_hap dw_maichul_hap
dw_maichul_list dw_maichul_list
dw_maiip_hap dw_maiip_hap
dw_maiip_list dw_maiip_list
dw_work dw_work
dw_maisu dw_maisu
dw_maisu_maiip dw_maisu_maiip
tab_vat tab_vat
rb_1 rb_1
rb_2 rb_2
dw_rtv dw_rtv
dw_file dw_file
gb_1 gb_1
end type
global w_ktxa21 w_ktxa21

type variables

String   s_jasacode,sRptPath,sApplyFlag, IsCommJasa
Integer  Ii_TotalCnt = 0
end variables

forward prototypes
public function string wf_amtconv (decimal decamt)
public function boolean wf_clear (string sdate, string fromdate, string todate)
public function integer wf_label_print ()
public function integer wf_maichul_vat ()
public function integer wf_maiip_vat ()
public function integer wf_requiredchk (integer curr_row)
public function boolean wf_setting_maichul_hap ()
public function boolean wf_setting_maichul_list ()
public function boolean wf_setting_maiip_hap ()
public function boolean wf_setting_maiip_list ()
public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length)
public function boolean wf_setting_title ()
public function boolean wf_setting_work (string sfdate, string stdate)
public function string wf_setting_zero (integer ll_total_lenght, integer ll_data_length)
end prototypes

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

public function boolean wf_clear (string sdate, string fromdate, string todate);Int ll_sqlcode
String ls_date

ls_date =Mid(sdate,3,2)+Mid(sdate,5,2)+Right(sdate,2)

dw_title.Reset()

DELETE FROM "KFZ_VAT_TITLE"  
	WHERE ( "KFZ_VAT_TITLE"."GUBUN" = '7' ) AND  
         ( "KFZ_VAT_TITLE"."CDATE" = :ls_date )   ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 표지 테이블 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_MAICHUL_HAP"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 매출합계 테이블 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_MAICHUL_LIST"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 매출자료 테이블 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_MAIIP_HAP"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 매입합계 테이블 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_MAIIP_LIST"  ;
IF SQLCA.SQLCODE = 0 THEN
	ll_sqlcode =1
ELSE
	MessageBox("확  인","부가세 디스켓처리 매입자료 테이블 삭제 실패.!!!")
	Return False
END IF

DELETE FROM "KFZ_VAT_WORK"
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
w_mdi_frame.sle_msg.text ="매출처별 세금계산서 합계표 내역 조회 중...!!!"

tab_vat.tabpage_print1.dw_print.SetRedraw(False)
tab_vat.tabpage_print2.dw_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 21 THEN															//매출처별 세금계산서(갑)
	   tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sSettingGisu+' 기 )'
		
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
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_vat_amt",dw_rtv.GetItemNumber(1,"sum_vat"))

		//개인
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_num",dw_rtv.GetItemNumber(1,"per_cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_gensu",dw_rtv.GetItemNumber(1,"per_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_gon_sum",dw_rtv.GetItemNumber(1,"per_gong_sum"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"gaiin_vat_sum",dw_rtv.GetItemNumber(1,"per_vat_sum"))
		
		//사업자등록번호
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_num",dw_rtv.GetItemNumber(1,"sano_cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_gensu",dw_rtv.GetItemNumber(1,"sano_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_gon_sum",dw_rtv.GetItemNumber(1,"sano_gong_sum"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_vat_sum",dw_rtv.GetItemNumber(1,"sano_vat_sum"))
		
		//거래내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_vat_amt",dw_rtv.GetItemNumber(i,"cust_vat"))
	ELSE																		//매출처별 세금계산서(을)
		tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sSettingGisu+' 기 )'
		
		il_currow = tab_vat.tabpage_print2.dw_print2.Insertrow(0)
		
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		
		//거래내역
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_vat_amt",dw_rtv.GetItemNumber(i,"cust_vat"))
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


w_mdi_frame.sle_msg.text ="매출처별 세금계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

Return 1
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
IF dw_rtv.Retrieve(sDatefrom,sDateto,sJasaCod,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_rtv.RowCount()
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="매입처별 세금계산서 합계표 내역 조회 중...!!!"

tab_vat.tabpage_print1.dw_print.SetRedraw(False)
tab_vat.tabpage_print2.dw_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 27 THEN															//매입처별 세금계산서(갑)
		tab_vat.tabpage_print1.dw_print.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sSettingGisu+' 기 )'
		
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
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"eymd",sDateto)

		//합계내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup",il_RetrieveRow)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_saup_nbr",dw_rtv.GetItemNumber(1,"cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_gon_amt",dw_rtv.GetItemNumber(1,"gong_sum"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"tot_vat_amt",dw_rtv.GetItemNumber(1,"vat_sum"))

		//거래내역
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
		tab_vat.tabpage_print1.dw_print.SetItem(il_currow,"kfz17ot0_vat_amt",dw_rtv.GetItemNumber(i,"cust_vat"))
	ELSE																		//매입처별 세금계산서(을)
		tab_vat.tabpage_print2.dw_print2.object.gisu_t.text = '( '+left(sDatefrom, 4)+' 년 '+sSettingGisu+' 기 )'
		
		il_currow = tab_vat.tabpage_print2.dw_print2.Insertrow(0)
		
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"sano",dw_rtv.GetItemString(1,"jasa_sano"))
		
		//거래내역
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"seq_num",i)
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_rtv.GetItemString(i,"sano"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_cvnas",dw_rtv.GetItemString(i,"cusnm"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_uptae",dw_rtv.GetItemString(i,"uptae"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"vndmst_jongk",dw_rtv.GetItemString(i,"upjong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"saup_nbr",dw_rtv.GetItemNumber(i,"cust_cnt"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_rtv.GetItemNumber(i,"cust_gong"))
		tab_vat.tabpage_print2.dw_print2.SetItem(il_currow,"kfz17ot0_vat_amt",dw_rtv.GetItemNumber(i,"cust_vat"))
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

w_mdi_frame.sle_msg.text ="매입처별 세금계산서 합계표 조회 완료!!!"	
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

public function boolean wf_setting_maichul_hap ();Long   ll_maichul_cnt_hap,ll_segum_nbr_hap,ll_maichul_cnt_saup,ll_segum_nbr_saup,&
	    ll_maichul_cnt_person,ll_segum_nbr_person
Double ldb_gon_amt_hap,ldb_vat_amt_hap,ldb_gon_amt_saup,ldb_vat_amt_saup,&
		 ldb_gon_amt_person,ldb_vat_amt_person
String ls_saupno,sVatGisu,sFromDate,sToDate

tab_vat.tabpage_process.dw_process.AcceptText()
ls_saupno = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")


sFromDate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sToDate   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

SELECT COUNT(DISTINCT "KFZ17OT0"."SAUP_NO2")				/*매출처수(사업자등록번호발행분)*/
	INTO :ll_maichul_cnt_saup
	FROM "KFZ17OT0","REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" LIKE '2%') AND
			( "KFZ17OT0"."TAX_NO" <> '22') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ll_maichul_cnt_saup) THEN
	ll_maichul_cnt_saup =0
END IF

/*세금계산서 매수(사업자등록번호발행분)*/
IF dw_maisu_maiip.Retrieve(s_jasacode,sFromDate,sToDate,'2','%','2%','22',sapplyflag) <= 0 THEN
	ll_segum_nbr_saup =0
ELSE
	ll_segum_nbr_saup =dw_maisu_maiip.GetItemNumber(1,"ll_count")
END IF

SELECT SUM("KFZ17OT0"."GON_AMT"),SUM("KFZ17OT0"."VAT_AMT")	/*공급가액/세액(사업자등록번호발행분)*/
	INTO :ldb_gon_amt_saup,:ldb_vat_amt_saup
	FROM "KFZ17OT0","REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" LIKE '2%') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."TAX_NO" <> '22') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ldb_gon_amt_saup) THEN
	ldb_gon_amt_saup =0
END IF
IF IsNull(ldb_vat_amt_saup) THEN
	ldb_vat_amt_saup =0
END IF

SELECT COUNT(DISTINCT "KFZ17OT0"."SAUP_NO")							/*매출처수(주민등록번호발행분)*/
	INTO :ll_maichul_cnt_person
	FROM "KFZ17OT0", "REFFPF" "REFFPF_B"  
	WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(( "KFZ17OT0"."JASA_CD" like :s_jasacode) AND
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" ='22') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ll_maichul_cnt_person) THEN
	ll_maichul_cnt_person =0
END IF

/*매수(주민등록번호발행분)*/
IF dw_maisu.Retrieve(s_jasacode,sFromDate,sToDate,'2',sapplyflag) <= 0 THEN
	ll_segum_nbr_person =0
ELSE
	ll_segum_nbr_person =dw_maisu.GetItemNumber(1,"ll_count")
END IF

SELECT COUNT(DISTINCT "KFZ17OT0"."JUN_NO") 
	INTO :ll_segum_nbr_person
	FROM "KFZ17OT0", "REFFPF" "REFFPF_B"  
	WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(( "KFZ17OT0"."JASA_CD" like :s_jasacode) AND
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" ='22') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ll_segum_nbr_person) THEN
	ll_segum_nbr_person =0
END IF

SELECT SUM("KFZ17OT0"."GON_AMT"),SUM("KFZ17OT0"."VAT_AMT")
	INTO :ldb_gon_amt_person,:ldb_vat_amt_person
	FROM "KFZ17OT0", "REFFPF" "REFFPF_B"  
	WHERE ( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(( "KFZ17OT0"."JASA_CD" like :s_jasacode) AND
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" ='22') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ldb_gon_amt_person) THEN
	ldb_gon_amt_person =0
END IF
IF IsNull(ldb_vat_amt_person) THEN
	ldb_vat_amt_person =0
END IF

//합계(매출처수,매수,공급가액,세액)
ll_maichul_cnt_hap = ll_maichul_cnt_saup + ll_maichul_cnt_person
ll_segum_nbr_hap   = ll_segum_nbr_saup   + ll_segum_nbr_person
ldb_gon_amt_hap    = ldb_gon_amt_saup    + ldb_gon_amt_person
ldb_vat_amt_hap    = ldb_vat_amt_saup    + ldb_vat_amt_person

IF ll_maichul_cnt_hap = 0 AND ll_segum_nbr_hap = 0 AND ldb_gon_amt_hap = 0 and ldb_vat_amt_hap = 0 THEN
	Return True
ELSE
	dw_maichul_hap.Reset()
	dw_maichul_hap.InsertRow(0)
	
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"gubun","3")
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"saupno",ls_saupno)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"hap_maichul_cnt",ll_maichul_cnt_hap)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"hap_segum_nbr",ll_segum_nbr_hap)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"hap_gon_amt",ldb_gon_amt_hap)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"hap_vat_amt",ldb_vat_amt_hap)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"saup_maichul_cnt",ll_maichul_cnt_saup)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"saup_segum_nbr",ll_segum_nbr_saup)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"saup_gon_amt",ldb_gon_amt_saup)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"saup_vat_amt",ldb_vat_amt_saup)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"person_maichul_cnt",ll_maichul_cnt_person)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"person_segum_nbr",ll_segum_nbr_person)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"person_gon_amt",ldb_gon_amt_person)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"person_vat_amt",ldb_vat_amt_person)
	dw_maichul_hap.SetItem(dw_maichul_hap.GetRow(),"bigo"," ")
	
	IF dw_maichul_hap.Update() =1 THEN
		Return True
	ELSE
		Return False
	END IF
END IF
end function

public function boolean wf_setting_maichul_list ();String ls_saupno,ls_customer,sVatGisu,ls_sangho,ls_uptae,ls_upjong,sFromDate,sToDate
Int    il_cursor_cnt,il_InsertRow,il_gon_length
Double ldb_gon_amt,ldb_vat_amt
Long   ll_maisu,ll_jechul_code,ll_space_length,ll_zero_cnt

dw_maichul_list.Reset()

tab_vat.tabpage_process.dw_process.AcceptText()
ls_saupno      = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")
ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")


sFromDate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sToDate   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

DECLARE cur_kfz17ot0_date CURSOR FOR  
	SELECT "KFZ17OT0"."SAUP_NO2", 			
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."CVNAS",'     '),NULL,NVL("KFZ17OT0"."CVNAS",'     '),NVL("VNDMST"."CVNAS",'     '))),1,15),   
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."UPTAE",'        '),NULL,NVL("KFZ17OT0"."UPTAE",'        '),NVL("VNDMST"."UPTAE",'        '))),1,8),   
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."JONGK",'            '),NULL,NVL("KFZ17OT0"."JONGK",'            '),NVL("VNDMST"."JONGK",'            '))),1,12),
			 NVL(SUM(DECODE("KFZ17OT0"."TAXGBN",'Y',1,0)),0) AS ll_count,
			 SUM(nvl("KFZ17OT0"."GON_AMT",0)),SUM(nvl("KFZ17OT0"."VAT_AMT",0))
	FROM "KFZ17OT0", "VNDMST", "REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."SAUP_NO" = "VNDMST"."CVCOD"(+)) AND
			( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='2') AND
			( "KFZ17OT0"."TAX_NO" LIKE '2%') AND
			( "KFZ17OT0"."TAX_NO" <> '22') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."ALC_GU" ='Y') 
	GROUP BY "KFZ17OT0"."SAUP_NO2"
	ORDER BY "KFZ17OT0"."SAUP_NO2" ASC;
OPEN cur_kfz17ot0_date;

il_cursor_cnt =1
il_InsertRow =1

DO  WHILE True
	FETCH cur_kfz17ot0_date INTO :ls_customer,	:ls_sangho,		:ls_uptae,		:ls_upjong,
										  :ll_maisu,		:ldb_gon_amt,	:ldb_vat_amt ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	ls_customer =Trim(ls_customer)

	IF IsNull(ls_sangho) THEN
		ls_sangho =""
	END IF
	IF IsNull(ls_uptae) THEN
		ls_uptae =""
	END IF
	IF IsNull(ls_upjong) THEN
		ls_upjong =""
	END IF
	IF IsNull(ll_maisu) then ll_maisu = 0
	IF IsNull(ldb_gon_amt) THEN
		ldb_gon_amt =0
	END IF

	IF IsNull(ldb_vat_amt) THEN
		ldb_vat_amt =0
	END IF

	w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 매출자료 DATA 갱신 중......["+ls_customer+']'
	
	ll_space_length =LenA(ls_customer)
	ls_customer =ls_customer +WF_SETTING_SPACE(10,ll_space_length)

	ll_space_length =LenA(ls_sangho)
	ls_sangho =ls_sangho +WF_SETTING_SPACE(30,ll_space_length)

	/*2004.03 세법변경 : 공란*/
	ls_uptae = ' '
	ll_space_length =LenA(ls_uptae)
	ls_uptae =ls_uptae +WF_SETTING_SPACE(17,ll_space_length)

	ls_upjong = ' '
	ll_space_length =LenA(ls_upjong)
	ls_upjong =ls_upjong +WF_SETTING_SPACE(25,ll_space_length)

	il_gon_length =LenA(String(Abs(ldb_gon_amt)))

	ll_zero_cnt = 14 - il_gon_length

	INSERT INTO "KFZ_MAICHUL_LIST"  
		( "GUBUN",				"SAUPNO1",			"SEQNO",				"SAUPNO2",			
		  "SANGHO2",			"UPTAE2",			"UPJONG2",			"MAICHUL_CNT",
		  "ZERO_CNT",			"GON_AMT",			"VAT_AMT",			"JUGU1",
		  "JUGU2",				"GUAN_NO",			"JECHUL_CODE",		"BIGO" )  
	VALUES ( '1',				:ls_saupno,			:il_cursor_cnt,	:ls_customer,
				:ls_sangho,		:ls_uptae,			:ls_upjong,		   :ll_maisu,
				:ll_zero_cnt,	:ldb_gon_amt,		:ldb_vat_amt,		0,
				0,					7501,					:ll_jechul_code,	'' )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","매출자료 처리 실패 : 사업자번호 - "+String(ls_customer,'@@@-@@-@@@@@') + "~n"+&
								 +sqlca.sqlerrtext)

		close cur_kfz17ot0_date;
		Return False
	END IF
	il_cursor_cnt +=1
LOOP
CLOSE cur_kfz17ot0_date;

Return True

end function

public function boolean wf_setting_maiip_hap ();String ls_saupno,sVatGisu,sFromDate,sToDate
Long ll_maiip_cnt,ll_segum_nbr
Double ldb_gon_amt,ldb_vat_amt

tab_vat.tabpage_process.dw_process.AcceptText()
ls_saupno = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")


sFromDate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sToDate   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

SELECT COUNT(DISTINCT "KFZ17OT0"."SAUP_NO2")						/*매입처수(합계)*/
	INTO :ll_maiip_cnt
	FROM "KFZ17OT0","REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='1') AND
			( "KFZ17OT0"."TAX_NO" LIKE '1%') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ll_maiip_cnt) THEN
	ll_maiip_cnt =0
END IF

//세금계산서 매수(합계)
IF dw_maisu_maiip.Retrieve(s_jasacode,sFromDate,sToDate,'1','%','1%','19',sapplyflag) <= 0 THEN
	ll_segum_nbr =0
ELSE
	ll_segum_nbr =dw_maisu_maiip.GetItemNumber(1,"ll_count")
END IF

SELECT SUM("KFZ17OT0"."GON_AMT"),SUM("KFZ17OT0"."VAT_AMT")				/*공급가액/세액(합계)*/
	INTO :ldb_gon_amt,:ldb_vat_amt
	FROM "KFZ17OT0","REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='1') AND
			( "KFZ17OT0"."TAX_NO" LIKE '1%') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."ALC_GU" ='Y') ;
IF IsNull(ldb_gon_amt) THEN
	ldb_gon_amt =0
END IF
IF IsNull(ldb_vat_amt) THEN
	ldb_vat_amt =0
END IF

IF ll_maiip_cnt = 0 AND ll_segum_nbr = 0 AND ldb_gon_amt = 0 AND ldb_vat_amt = 0 THEN
	Return True
ELSE
	dw_maiip_hap.Reset()
	dw_maiip_hap.InsertRow(0)
	
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"gubun","4")
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"saupno",ls_saupno)
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"maichul_cnt",ll_maiip_cnt)
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"segum_nbr",ll_segum_nbr)
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"gon_amt",ldb_gon_amt)
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"vat_amt",ldb_vat_amt)
	dw_maiip_hap.SetItem(dw_maiip_hap.GetRow(),"bigo"," ")
	
	IF dw_maiip_hap.Update() = 1 THEN
		Return True
	ELSE
		Return False
	END IF
END IF
end function

public function boolean wf_setting_maiip_list ();String ls_saupno,ls_customer,sVatGisu,ls_syy,ls_smm,ls_sdd,ls_eyy,ls_emm,ls_edd
Int il_cursor_cnt,il_InsertRow,il_gon_length
String ls_sangho,ls_uptae,ls_upjong,sFromDate,sToDate
Double ldb_gon_amt,ldb_vat_amt
Long ll_maisu,ll_jechul_code,ll_space_length,ll_zero_cnt

dw_maiip_list.Reset()

tab_vat.tabpage_process.dw_process.AcceptText()
ls_saupno      = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_saupno")
ll_jechul_code = tab_vat.tabpage_process.dw_process.GetItemNumber(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_maichul_list_jechul_code")

sFromDate = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
sToDate   = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

DECLARE cur_kfz17ot0_date CURSOR FOR  
	SELECT "KFZ17OT0"."SAUP_NO2",
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."CVNAS",'     '),NULL,NVL("KFZ17OT0"."CVNAS",'     '),NVL("VNDMST"."CVNAS",'     '))),1,15),   
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."UPTAE",'        '),NULL,NVL("KFZ17OT0"."UPTAE",'        '),NVL("VNDMST"."UPTAE",'        '))),1,8),   
			 SUBSTR(MAX(DECODE("VNDMST"."CVGU",'9',NVL("KFZ17OT0"."JONGK",'            '),NULL,NVL("KFZ17OT0"."JONGK",'            '),NVL("VNDMST"."JONGK",'            '))),1,12),
			 NVL(SUM(DECODE("KFZ17OT0"."TAXGBN",'Y',1,0)),0) AS ll_count,
			 SUM(nvl("KFZ17OT0"."GON_AMT",0)),SUM(nvl("KFZ17OT0"."VAT_AMT",0))
	FROM "KFZ17OT0",  "VNDMST", "REFFPF" "REFFPF_A","REFFPF" "REFFPF_B"
	WHERE ( "KFZ17OT0"."SAUP_NO" = "VNDMST"."CVCOD"(+)) AND
			( "KFZ17OT0"."TAX_NO" = "REFFPF_A"."RFGUB" ) and  
			( "REFFPF_A"."RFCOD" = 'AT') AND
			( "REFFPF_A"."RFGUB" <> '00') AND
			( "KFZ17OT0"."JASA_CD" = "REFFPF_B"."RFGUB" ) and  
			( "REFFPF_B"."RFCOD" = 'JA') AND
			( "REFFPF_B"."RFGUB" <> '00') AND
			(("KFZ17OT0"."JASA_CD" LIKE :s_jasacode ) AND  
			(SUBSTR("REFFPF_B"."RFNA2",1,1) LIKE :sapplyflag )) AND 
			(( "KFZ17OT0"."ACC_DATE" >= :sFromDate ) AND  
			( "KFZ17OT0"."ACC_DATE" <= :sToDate )) AND  
			( "KFZ17OT0"."IO_GU" ='1') AND
			( "KFZ17OT0"."TAX_NO" LIKE '1%') AND
			(SUBSTR("REFFPF_A"."RFNA2",1,1) ='1') AND
			( "KFZ17OT0"."ALC_GU" ='Y') 
		GROUP BY "KFZ17OT0"."SAUP_NO2"
		ORDER BY "KFZ17OT0"."SAUP_NO2" ASC;
OPEN cur_kfz17ot0_date;

il_cursor_cnt =1
il_InsertRow =1

DO  WHILE True
	FETCH cur_kfz17ot0_date INTO :ls_customer,		:ls_sangho,		:ls_uptae,		:ls_upjong,
										  :ll_maisu,			  :ldb_gon_amt,	:ldb_vat_amt;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	ls_customer =Trim(ls_customer)

	IF IsNull(ls_sangho) THEN
		ls_sangho =""
	END IF
	IF IsNull(ls_uptae) THEN
		ls_uptae =""
	END IF
	IF IsNull(ls_upjong) THEN
		ls_upjong =""
	END IF
	if IsNull(ll_maisu) then ll_maisu = 0
	IF IsNull(ldb_gon_amt) THEN
		ldb_gon_amt =0
	END IF

	IF IsNull(ldb_vat_amt) THEN
		ldb_vat_amt =0
	END IF
	
	w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 매입자료 DATA 갱신 중......["+ls_customer+']'
	
	ll_space_length =LenA(ls_customer)
	ls_customer =ls_customer +WF_SETTING_SPACE(10,ll_space_length)

	ll_space_length =LenA(ls_sangho)
	ls_sangho =ls_sangho +WF_SETTING_SPACE(30,ll_space_length)

	/*2004.03 세법 변경 : 공란*/
	ls_uptae = ' '
	ll_space_length =LenA(ls_uptae)
	ls_uptae =ls_uptae +WF_SETTING_SPACE(17,ll_space_length)

	ls_upjong = ' '
	ll_space_length =LenA(ls_upjong)
	ls_upjong =ls_upjong +WF_SETTING_SPACE(25,ll_space_length)

	il_gon_length =LenA(String(Abs(ldb_gon_amt)))

	ll_zero_cnt = 14 - il_gon_length

	INSERT INTO "KFZ_MAIIP_LIST"
		("GUBUN",				"SAUPNO1",			"SEQ_NO",			"SAUPNO2",
		 "SANGHO2",				"UPTAE2",			"UPJONG2",		   "MAI_CNT",
		 "ZERO_CNT",			"GON_AMT",			"VAT_AMT",			"JUGU1",
		 "JUGU2",				"GUAN_NO",		 	"JECHUL_CD",		"BIGO")  
	VALUES ( '2',				:ls_saupno,			:il_cursor_cnt,	:ls_customer,
				:ls_sangho,		:ls_uptae,			:ls_upjong,		   :ll_maisu,
				:ll_zero_cnt,	:ldb_gon_amt,		:ldb_vat_amt,		0,
				0,					8501,					:ll_jechul_code,	'' )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","매입자료 처리 실패 : 사업자번호 - "+String(ls_customer,'@@@-@@-@@@@@') + "~n"+&
								 +sqlca.sqlerrtext)

		close cur_kfz17ot0_date;
		Return False
	END IF

	il_cursor_cnt +=1
LOOP
CLOSE cur_kfz17ot0_date;

Return True



end function

public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length);Int ll_space_length
String ls_space_length

ll_space_length = ll_total_lenght - ll_data_length
CHOOSE CASE ll_space_length
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

public function boolean wf_setting_title ();String ls_saupj,ls_sdate,ls_edate,ls_date,ls_code,ls_saupno,ls_sanho,&
		 ls_name,ls_uptae,ls_upjong,ls_addr,ls_file_name
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
ls_name        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sname")
ls_uptae       =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_uptae")
ls_upjong      =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_upjong")
ls_addr        =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_addr")

IF IsNull(ls_name) THEN
	ls_name =""
END IF

IF IsNull(ls_uptae) THEN
	ls_uptae =""
END IF

IF IsNull(ls_upjong) THEN
	ls_upjong =""
END IF
IF IsNull(ls_addr) THEN
	ls_addr =""
END IF

dw_title.InsertRow(0)
dw_title.SetItem(dw_title.GetRow(),"gubun","7")
dw_title.SetItem(dw_title.GetRow(),"saupno",ls_saupno)

ll_space_length =LenA(ls_sanho)
ls_sanho =ls_sanho + WF_SETTING_SPACE(30,ll_space_length)
dw_title.SetItem(dw_title.GetRow(),"sangho",ls_sanho)

ll_space_length =LenA(ls_name)
ls_name =ls_name + WF_SETTING_SPACE(15,ll_space_length)
dw_title.SetItem(dw_title.GetRow(),"sname",ls_name)

ll_space_length =LenA(ls_addr)
ls_addr =ls_addr + WF_SETTING_SPACE(45,ll_space_length)
dw_title.SetItem(dw_title.GetRow(),"addr",ls_addr)

/*2004.03 세법 변경:공란*/
ls_uptae = ' '
ll_space_length =LenA(ls_uptae)
ls_uptae =ls_uptae + WF_SETTING_SPACE(17,ll_space_length)
dw_title.SetItem(dw_title.GetRow(),"uptae",ls_uptae)

ls_upjong = ' '
ll_space_length =LenA(ls_upjong)
ls_upjong =ls_upjong + WF_SETTING_SPACE(25,ll_space_length)
dw_title.SetItem(dw_title.GetRow(),"upjong",ls_upjong)

dw_title.SetItem(dw_title.GetRow(),"sdate",Mid(ls_sdate,3,2)+Mid(ls_sdate,5,2)+Right(ls_sdate,2))
dw_title.SetItem(dw_title.GetRow(),"edate",Mid(ls_edate,3,2)+Mid(ls_edate,5,2)+Right(ls_edate,2))
dw_title.SetItem(dw_title.GetRow(),"cdate",Mid(ls_date,3,2)+Mid(ls_date,5,2)+Right(ls_date,2))
dw_title.SetItem(dw_title.GetRow(),"bigo","")

IF dw_title.Update() = 1 THEN
	Return True
ELSE
	Return False
END IF

end function

public function boolean wf_setting_work (string sfdate, string stdate);
//매출합계
Long ll_maichul_cnt_hap,ll_segum_nbr_hap,ll_maichul_cnt_saup,ll_segum_nbr_saup,&
	  ll_maichul_cnt_person,ll_segum_nbr_person

Double ldb_gon_amt_hap,ldb_vat_amt_hap,ldb_gon_amt_saup,ldb_vat_amt_saup,&
		 ldb_gon_amt_person,ldb_vat_amt_person

String ls_maichul_cnt_hap,ls_segum_nbr_hap,ls_maichul_cnt_saup,ls_segum_nbr_saup,&
	    ls_maichul_cnt_person,ls_segum_nbr_person,ls_gon_amt_hap,ls_vat_amt_hap,&
		 ls_gon_amt_saup,ls_vat_amt_saup,ls_gon_amt_person,ls_vat_amt_person
//표지
String ls_date_cond,ls_gubun,ls_saupno,ls_sangho,ls_name,ls_addr,ls_uptae,ls_upjong,&
		 ls_sdate,ls_edate,ls_date,ls_bigo,ls_setting_text
Long   ll_zero_length
Long   ll_space_length,ll_length

Integer ll_row

dw_work.Reset()
dw_work.Retrieve(sFdate,sTdate,IsCommJasa)

tab_vat.tabpage_process.dw_process.AcceptText()
ls_date_cond =tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate")
ls_date_cond =Right(ls_date_cond,6)

/*표지*/
SELECT "KFZ_VAT_TITLE"."GUBUN",   
       "KFZ_VAT_TITLE"."SAUPNO",   
       "KFZ_VAT_TITLE"."SANGHO",   
       "KFZ_VAT_TITLE"."SNAME",   
       "KFZ_VAT_TITLE"."ADDR",   
       "KFZ_VAT_TITLE"."UPTAE",   
       "KFZ_VAT_TITLE"."UPJONG",   
       "KFZ_VAT_TITLE"."SDATE",   
       "KFZ_VAT_TITLE"."EDATE",   
       "KFZ_VAT_TITLE"."CDATE",   
       "KFZ_VAT_TITLE"."BIGO"  
	INTO :ls_gubun,   
        :ls_saupno,   
        :ls_sangho,   
        :ls_name,   
        :ls_addr,   
        :ls_uptae,   
        :ls_upjong,   
        :ls_sdate,   
        :ls_edate,   
        :ls_date,   
        :ls_bigo  
   FROM "KFZ_VAT_TITLE"  
   WHERE "KFZ_VAT_TITLE"."CDATE" = :ls_date_cond   ;
IF SQLCA.SQLCODE = 0 THEN
	Ii_TotalCnt = 1

	IF IsNull(ls_bigo) THEN
		ls_bigo =""
	END IF
	
	ll_space_length =LenA(ls_sangho)
	ls_sangho =ls_sangho + WF_SETTING_SPACE(30,ll_space_length)
	
	ll_space_length =LenA(ls_name)
	ls_name =ls_name + WF_SETTING_SPACE(15,ll_space_length)
	
	ll_space_length =LenA(ls_addr)
	ls_addr =ls_addr + WF_SETTING_SPACE(45,ll_space_length)
	
	ll_space_length =LenA(ls_uptae)
	ls_uptae =ls_uptae + WF_SETTING_SPACE(17,ll_space_length)
	
	ll_space_length =LenA(ls_upjong)
	ls_upjong =ls_upjong + WF_SETTING_SPACE(25,ll_space_length)

	ll_space_length =LenA(ls_bigo)
	ls_bigo =ls_bigo+WF_SETTING_SPACE(9,ll_space_length)
	
	ls_setting_text =ls_gubun+ls_saupno+ls_sangho+ls_name+ls_addr+ls_uptae+ls_upjong+&
						  ls_sdate+ls_edate+ls_date+ls_bigo
	
	ll_row = dw_work.InsertRow(0)
	dw_work.SetItem(ll_row,"fdate",  sFdate)
	dw_work.SetItem(ll_row,"tdate",  sTdate)
	dw_work.SetItem(ll_row,"saupno", IsCommJasa)
	dw_work.SetItem(ll_row,"test",   ls_setting_text)
	dw_work.SetItem(ll_row,"seqno",  Ii_TotalCnt)
END IF

/*매출 자료*/
p_mod.TriggerEvent("ue_work_maichul_list")

/*매출합계*/
SELECT "KFZ_MAICHUL_HAP"."GUBUN",   
       "KFZ_MAICHUL_HAP"."SAUPNO",   
       "KFZ_MAICHUL_HAP"."HAP_MAICHUL_CNT",   
       "KFZ_MAICHUL_HAP"."HAP_SEGUM_NBR",   
       "KFZ_MAICHUL_HAP"."HAP_GON_AMT",   
       "KFZ_MAICHUL_HAP"."HAP_VAT_AMT",   
       "KFZ_MAICHUL_HAP"."SAUP_MAICHUL_CNT",   
       "KFZ_MAICHUL_HAP"."SAUP_SEGUM_NBR",   
       "KFZ_MAICHUL_HAP"."SAUP_GON_AMT",   
       "KFZ_MAICHUL_HAP"."SAUP_VAT_AMT",   
       "KFZ_MAICHUL_HAP"."PERSON_MAICHUL_CNT",   
       "KFZ_MAICHUL_HAP"."PERSON_SEGUM_NBR",   
       "KFZ_MAICHUL_HAP"."PERSON_GON_AMT",   
       "KFZ_MAICHUL_HAP"."PERSON_VAT_AMT",   
       "KFZ_MAICHUL_HAP"."BIGO"  
  INTO :ls_gubun,   
       :ls_saupno,   
       :ll_maichul_cnt_hap,   
       :ll_segum_nbr_hap,   
       :ldb_gon_amt_hap,   
       :ldb_vat_amt_hap,   
       :ll_maichul_cnt_saup,   
       :ll_segum_nbr_saup,   
       :ldb_gon_amt_saup,   
       :ldb_vat_amt_saup,   
       :ll_maichul_cnt_person,   
       :ll_segum_nbr_person,   
       :ldb_gon_amt_person,   
       :ldb_vat_amt_person,   
       :ls_bigo  
  FROM "KFZ_MAICHUL_HAP"  ;
IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(ls_bigo) THEN
		ls_bigo =""
	END IF
	
	//매출합계 ZERO SETTING(합계)
	ls_maichul_cnt_hap =String(ll_maichul_cnt_hap)
	ll_zero_length =LenA(ls_maichul_cnt_hap)
	ls_maichul_cnt_hap =WF_SETTING_ZERO(7,ll_zero_length)+ls_maichul_cnt_hap
	
	ls_segum_nbr_hap =String(ll_segum_nbr_hap)
	ll_zero_length =LenA(ls_segum_nbr_hap)
	ls_segum_nbr_hap =WF_SETTING_ZERO(7,ll_zero_length)+ls_segum_nbr_hap
	
	ls_gon_amt_hap =String(ldb_gon_amt_hap)
	ll_zero_length =LenA(ls_gon_amt_hap)
	ls_gon_amt_hap =WF_SETTING_ZERO(15,ll_zero_length)+ls_gon_amt_hap
	
	ls_vat_amt_hap =String(ldb_vat_amt_hap)
	ll_zero_length =LenA(ls_vat_amt_hap)
	ls_vat_amt_hap =WF_SETTING_ZERO(14,ll_zero_length)+ls_vat_amt_hap
	
	//매출합계 ZERO SETTING(사업자등록번호발행분)
	ls_maichul_cnt_saup =String(ll_maichul_cnt_saup)
	ll_zero_length =LenA(ls_maichul_cnt_saup)
	ls_maichul_cnt_saup =WF_SETTING_ZERO(7,ll_zero_length)+ls_maichul_cnt_saup
	
	ls_segum_nbr_saup =String(ll_segum_nbr_saup)
	ll_zero_length =LenA(ls_segum_nbr_saup)
	ls_segum_nbr_saup =WF_SETTING_ZERO(7,ll_zero_length)+ls_segum_nbr_saup
	
	ls_gon_amt_saup =String(ldb_gon_amt_saup)
	ll_zero_length =LenA(ls_gon_amt_saup)
	ls_gon_amt_saup =WF_SETTING_ZERO(15,ll_zero_length)+ls_gon_amt_saup
	
	ls_vat_amt_saup =String(ldb_vat_amt_saup)
	ll_zero_length =LenA(ls_vat_amt_saup)
	ls_vat_amt_saup =WF_SETTING_ZERO(14,ll_zero_length)+ls_vat_amt_saup
	
	//매출합계 ZERO SETTING(주민등록번호발행분)
	ls_maichul_cnt_person =String(ll_maichul_cnt_person)
	ll_zero_length =LenA(ls_maichul_cnt_person)
	ls_maichul_cnt_person =WF_SETTING_ZERO(7,ll_zero_length)+ls_maichul_cnt_person
	
	ls_segum_nbr_person =String(ll_segum_nbr_person)
	ll_zero_length =LenA(ls_segum_nbr_person)
	ls_segum_nbr_person =WF_SETTING_ZERO(7,ll_zero_length)+ls_segum_nbr_person
	
	ls_gon_amt_person =String(ldb_gon_amt_person)
	ll_zero_length =LenA(ls_gon_amt_person)
	ls_gon_amt_person =WF_SETTING_ZERO(15,ll_zero_length)+ls_gon_amt_person
	
	ls_vat_amt_person =String(ldb_vat_amt_person)
	ll_zero_length =LenA(ls_vat_amt_person)
	ls_vat_amt_person =WF_SETTING_ZERO(14,ll_zero_length)+ls_vat_amt_person
	
	ll_space_length =LenA(ls_bigo)
	ls_bigo =ls_bigo + WF_SETTING_SPACE(30,ll_space_length)
	
	ls_setting_text =ls_gubun+ls_saupno+ls_maichul_cnt_hap+ls_segum_nbr_hap+ls_gon_amt_hap+&
						  ls_vat_amt_hap+ls_maichul_cnt_saup+ls_segum_nbr_saup+ls_gon_amt_saup+&
						  ls_vat_amt_saup+ls_maichul_cnt_person+ls_segum_nbr_person+&
						  ls_gon_amt_person+ls_vat_amt_person+ls_bigo
	
	Ii_TotalCnt = Ii_TotalCnt + 1
	
	ll_row = dw_work.InsertRow(0)
	dw_work.SetItem(ll_row,"fdate",  sFdate)
	dw_work.SetItem(ll_row,"tdate",  sTdate)
	dw_work.SetItem(ll_row,"saupno", IsCommJasa)
	dw_work.SetItem(ll_row,"test",   ls_setting_text)
	dw_work.SetItem(ll_row,"seqno",  Ii_TotalCnt)
END IF

//매입자료
p_mod.TriggerEvent("ue_work_maiip_list")

//매입합계
Long ll_maichul_cnt,ll_segum_nbr
Double ldb_gon_amt,ldb_vat_amt
String ls_maichul_cnt,ls_segum_nbr,ls_gon_amt,ls_vat_amt

SELECT "KFZ_MAIIP_HAP"."GUBUN",   
       "KFZ_MAIIP_HAP"."SAUPNO",   
       "KFZ_MAIIP_HAP"."MAICHUL_CNT",   
       "KFZ_MAIIP_HAP"."SEGUM_NBR",   
       "KFZ_MAIIP_HAP"."GON_AMT",   
       "KFZ_MAIIP_HAP"."VAT_AMT",   
       "KFZ_MAIIP_HAP"."BIGO"  
	INTO :ls_gubun,   
        :ls_saupno,   
        :ll_maichul_cnt,   
        :ll_segum_nbr,   
        :ldb_gon_amt,   
        :ldb_vat_amt,   
        :ls_bigo  
   FROM "KFZ_MAIIP_HAP"  ;
IF SQLCA.SQLCODE = 0 THEN	
	IF IsNull(ls_bigo) THEN
		ls_bigo =""
	END IF
//	ll_space_length =Len(ls_bigo)
//	ls_bigo =ls_bigo+WF_SETTING_SPACE(116,ll_space_length)
	
	//매입합계 ZERO SETTING
	ls_maichul_cnt =String(ll_maichul_cnt)
	ll_zero_length =LenA(ls_maichul_cnt)
	ls_maichul_cnt =WF_SETTING_ZERO(7,ll_zero_length)+ls_maichul_cnt
	
	ls_segum_nbr =String(ll_segum_nbr)
	ll_zero_length =LenA(ls_segum_nbr)
	ls_segum_nbr =WF_SETTING_ZERO(7,ll_zero_length)+ls_segum_nbr
	
	ls_gon_amt =String(ldb_gon_amt)
	ll_zero_length =LenA(ls_gon_amt)
	ls_gon_amt =WF_SETTING_ZERO(15,ll_zero_length)+ls_gon_amt
	
	ls_vat_amt =String(ldb_vat_amt)
	ll_zero_length =LenA(ls_vat_amt)
	ls_vat_amt =WF_SETTING_ZERO(14,ll_zero_length)+ls_vat_amt
	
	ls_bigo = '                                                                                                                    '
	
	ls_setting_text =ls_gubun+ls_saupno+ls_maichul_cnt+ls_segum_nbr+ls_gon_amt+ls_vat_amt+&
						  ls_bigo
	
	Ii_TotalCnt = Ii_TotalCnt + 1
	
	ll_row = dw_work.InsertRow(0)
	dw_work.SetItem(ll_row,"fdate",  sFdate)
	dw_work.SetItem(ll_row,"tdate",  sTdate)
	dw_work.SetItem(ll_row,"saupno", IsCommJasa)
	dw_work.SetItem(ll_row,"test",   ls_setting_text)
	dw_work.SetItem(ll_row,"seqno",  Ii_TotalCnt)
END IF

IF dw_work.Update() =1 THEN
	Return True
ELSE
	Return False
END IF
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

event open;call super::open;String mm,dd,sJasa,sSano,sName,sJasaName,sUptae,sUpjong,sAddr,sStart,sEnd,sVatGisu,sPath
		 
tab_vat.tabpage_process.dw_process.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)
tab_vat.tabpage_label.dw_label.SetTransObject(SQLCA)

dw_maichul_hap.SetTransObject(SQLCA)
dw_maichul_list.SetTransObject(SQLCA)
dw_maiip_hap.SetTransObject(SQLCA)
dw_maiip_list.SetTransObject(SQLCA)
dw_title.SetTransObject(SQLCA)
dw_work.SetTransObject(SQLCA)
dw_file.SetTransObject(SQLCA)
dw_maisu.SetTransObject(SQLCA)
dw_maisu_maiip.SetTransObject(SQLCA)

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

on w_ktxa21.create
int iCurrent
call super::create
this.dw_title=create dw_title
this.dw_maichul_hap=create dw_maichul_hap
this.dw_maichul_list=create dw_maichul_list
this.dw_maiip_hap=create dw_maiip_hap
this.dw_maiip_list=create dw_maiip_list
this.dw_work=create dw_work
this.dw_maisu=create dw_maisu
this.dw_maisu_maiip=create dw_maisu_maiip
this.tab_vat=create tab_vat
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_rtv=create dw_rtv
this.dw_file=create dw_file
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_title
this.Control[iCurrent+2]=this.dw_maichul_hap
this.Control[iCurrent+3]=this.dw_maichul_list
this.Control[iCurrent+4]=this.dw_maiip_hap
this.Control[iCurrent+5]=this.dw_maiip_list
this.Control[iCurrent+6]=this.dw_work
this.Control[iCurrent+7]=this.dw_maisu
this.Control[iCurrent+8]=this.dw_maisu_maiip
this.Control[iCurrent+9]=this.tab_vat
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.dw_rtv
this.Control[iCurrent+13]=this.dw_file
this.Control[iCurrent+14]=this.gb_1
end on

on w_ktxa21.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_title)
destroy(this.dw_maichul_hap)
destroy(this.dw_maichul_list)
destroy(this.dw_maiip_hap)
destroy(this.dw_maiip_list)
destroy(this.dw_work)
destroy(this.dw_maisu)
destroy(this.dw_maisu_maiip)
destroy(this.tab_vat)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_rtv)
destroy(this.dw_file)
destroy(this.gb_1)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa21
boolean visible = false
integer x = 293
integer y = 2248
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa21
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa21
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa21
boolean visible = false
integer x = 2885
integer y = 2528
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa21
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa21
integer x = 4416
integer y = 20
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa21
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa21
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

type p_inq from w_inherite`p_inq within w_ktxa21
boolean visible = false
integer x = 3077
integer y = 2528
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa21
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa21
event ue_work_maichul_list pbm_custom01
event ue_work_maiip_list pbm_custom02
integer x = 4069
integer y = 20
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_work_maichul_list;//매출 자료
Long ll_cursor_cnt,ll_seqno,ll_maisu,ll_zero_cnt,ll_jugu1,ll_jugu2,ll_guan_no,&
	  ll_jechul_code,ll_zero_length
Double ldb_gon_amt,ldb_vat_amt
String ls_saupno1,ls_saupno2,ls_gubun,ls_uptae,ls_upjong,ls_sangho,ls_bigo,ls_setting_text
String ls_cursor_cnt,ls_seqno,ls_maisu,ls_zero_cnt,ls_jugu1,ls_jugu2,ls_guan_no,&
	    ls_jechul_code,ls_gon_amt,ls_vat_amt,ls_sdate,ls_edate
Integer ll_row

tab_vat.tabpage_process.dw_process.AcceptText()
ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

DECLARE save_maichul_list CURSOR FOR  
	SELECT "KFZ_MAICHUL_LIST"."GUBUN",   
          "KFZ_MAICHUL_LIST"."SAUPNO1",   
          "KFZ_MAICHUL_LIST"."SEQNO",   
          "KFZ_MAICHUL_LIST"."SAUPNO2",   
          "KFZ_MAICHUL_LIST"."SANGHO2",   
          "KFZ_MAICHUL_LIST"."UPTAE2",   
          "KFZ_MAICHUL_LIST"."UPJONG2",   
          "KFZ_MAICHUL_LIST"."MAICHUL_CNT",   
          "KFZ_MAICHUL_LIST"."ZERO_CNT",   
          "KFZ_MAICHUL_LIST"."GON_AMT",   
          "KFZ_MAICHUL_LIST"."VAT_AMT",   
          "KFZ_MAICHUL_LIST"."JUGU1",   
          "KFZ_MAICHUL_LIST"."JUGU2",   
          "KFZ_MAICHUL_LIST"."GUAN_NO",   
          "KFZ_MAICHUL_LIST"."JECHUL_CODE",   
          "KFZ_MAICHUL_LIST"."BIGO"  
   FROM "KFZ_MAICHUL_LIST"  
	ORDER BY "KFZ_MAICHUL_LIST"."SEQNO" ASC;
OPEN save_maichul_list;
ll_cursor_cnt =1
DO WHILE TRue
	FETCH save_maichul_list INTO :ls_gubun,
										  :ls_saupno1,
										  :ll_seqno,
										  :ls_saupno2,
										  :ls_sangho,
										  :ls_uptae,
										  :ls_upjong,
										  :ll_maisu,
										  :ll_zero_cnt,
										  :ldb_gon_amt,
										  :ldb_vat_amt,
										  :ll_jugu1,
										  :ll_jugu2,
										  :ll_guan_no,
										  :ll_jechul_code,
										  :ls_bigo;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	Ii_TotalCnt = Ii_TotalCnt + 1
	
	ls_seqno =String(ll_seqno)
	ll_zero_length =LenA(ls_seqno)
	ls_seqno =WF_SETTING_ZERO(4,ll_zero_length)+ls_seqno

	/*99.07.16 수정 - 상호,업태,업종 NULL 체크*/
	IF IsNull(ls_sangho) THEN
		ls_sangho =""
	END IF
	ll_zero_length =LenA(ls_sangho)
	ls_sangho =ls_sangho+WF_SETTING_SPACE(30,ll_zero_length)
	
	IF IsNull(ls_uptae) THEN
		ls_uptae =""
	END IF
	ll_zero_length =LenA(ls_uptae)
	ls_uptae =ls_uptae+WF_SETTING_SPACE(17,ll_zero_length)
	
	IF IsNull(ls_upjong) THEN
		ls_upjong =""
	END IF
	ll_zero_length =LenA(ls_upjong)
	ls_upjong = ls_upjong+WF_SETTING_SPACE(25,ll_zero_length)
	
	ls_maisu =String(ll_maisu)
	ll_zero_length =LenA(ls_maisu)
	ls_maisu =WF_SETTING_ZERO(7,ll_zero_length)+ls_maisu

	/*2004.03월 공란수 = 0*/
//	ls_zero_cnt =String(ll_zero_cnt)
//	ll_zero_length =Len(ls_zero_cnt)
	ls_zero_cnt =WF_SETTING_ZERO(2,0)

	ls_gon_amt = wf_amtconv(ldb_gon_amt)
	ll_zero_length =LenA(ls_gon_amt)
	ls_gon_amt =WF_SETTING_ZERO(14,ll_zero_length)+ls_gon_amt

	ls_vat_amt = wf_amtconv(ldb_vat_amt)
	ll_zero_length =LenA(ls_vat_amt)
	ls_vat_amt =WF_SETTING_ZERO(13,ll_zero_length)+ls_vat_amt

	ls_jugu1 =String(ll_jugu1)
	ll_zero_length =LenA(ls_jugu1)
	ls_jugu1 =WF_SETTING_SPACE(1,ll_zero_length)+ls_jugu1

	ls_jugu2 =String(ll_jugu2)
	ll_zero_length =LenA(ls_jugu2)
	ls_jugu2 =WF_SETTING_SPACE(1,ll_zero_length)+ls_jugu2

	ls_guan_no =String(ll_guan_no)
	ll_zero_length =LenA(ls_guan_no)
	ls_guan_no =WF_SETTING_ZERO(4,ll_zero_length)+ls_guan_no

	ls_jechul_code =String(ll_jechul_code)
	ll_zero_length =LenA(ls_jechul_code)
	ls_jechul_code =WF_SETTING_ZERO(3,ll_zero_length)+ls_jechul_code

	IF IsNull(ls_bigo) THEN
		ls_bigo =""
	END IF
	ll_zero_length =LenA(ls_bigo)
	ls_bigo =ls_bigo+WF_SETTING_SPACE(28,ll_zero_length)

	ls_setting_text=ls_gubun+ls_saupno1+ls_seqno+ls_saupno2+ls_sangho+ls_uptae+ls_upjong+&
						 ls_maisu+ls_zero_cnt+ls_gon_amt+ls_vat_amt+ls_jugu1+ls_jugu2+&
						 ls_guan_no+ls_jechul_code+ls_bigo

	ll_row = dw_work.InsertRow(0)
	dw_work.SetItem(ll_row,"fdate",  ls_sdate)
	dw_work.SetItem(ll_row,"tdate",  ls_edate)
	dw_work.SetItem(ll_row,"saupno", IsCommJasa)
	dw_work.SetItem(ll_row,"test",   ls_setting_text)
	dw_work.SetItem(ll_row,"seqno",  Ii_TotalCnt)
LOOP
CLOSE save_maichul_list;
end event

event p_mod::ue_work_maiip_list;//매출 자료
Long ll_cursor_cnt,ll_seqno,ll_maisu,ll_zero_cnt,ll_jugu1,ll_jugu2,ll_guan_no,&
	  ll_jechul_code,ll_zero_length
Double ldb_gon_amt,ldb_vat_amt
String ls_saupno1,ls_saupno2,ls_gubun,ls_uptae,ls_upjong,ls_sangho,ls_bigo,ls_setting_text
String ls_cursor_cnt,ls_seqno,ls_maisu,ls_zero_cnt,ls_jugu1,ls_jugu2,ls_guan_no,&
	    ls_jechul_code,ls_gon_amt,ls_vat_amt,ls_sdate,ls_edate
Integer ll_row

tab_vat.tabpage_process.dw_process.AcceptText()
ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))

 DECLARE save_maiip_list CURSOR FOR  
  SELECT "KFZ_MAIIP_LIST"."GUBUN",   
         "KFZ_MAIIP_LIST"."SAUPNO1",   
         "KFZ_MAIIP_LIST"."SEQ_NO",   
         "KFZ_MAIIP_LIST"."SAUPNO2",   
         "KFZ_MAIIP_LIST"."SANGHO2",   
         "KFZ_MAIIP_LIST"."UPTAE2",   
         "KFZ_MAIIP_LIST"."UPJONG2",   
         "KFZ_MAIIP_LIST"."MAI_CNT",   
         "KFZ_MAIIP_LIST"."ZERO_CNT",   
         "KFZ_MAIIP_LIST"."GON_AMT",   
         "KFZ_MAIIP_LIST"."VAT_AMT",   
         "KFZ_MAIIP_LIST"."JUGU1",   
         "KFZ_MAIIP_LIST"."JUGU2",   
         "KFZ_MAIIP_LIST"."GUAN_NO",   
         "KFZ_MAIIP_LIST"."JECHUL_CD",   
         "KFZ_MAIIP_LIST"."BIGO"  
    FROM "KFZ_MAIIP_LIST"  
	ORDER BY "KFZ_MAIIP_LIST"."SEQ_NO" ASC;
OPEN save_maiip_list;
ll_cursor_cnt =1
DO WHILE TRue
	FETCH save_maiip_list INTO :ls_gubun,
										  :ls_saupno1,
										  :ll_seqno,
										  :ls_saupno2,
										  :ls_sangho,
										  :ls_uptae,
										  :ls_upjong,
										  :ll_maisu,
										  :ll_zero_cnt,
										  :ldb_gon_amt,
										  :ldb_vat_amt,
										  :ll_jugu1,
										  :ll_jugu2,
										  :ll_guan_no,
										  :ll_jechul_code,
										  :ls_bigo;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	Ii_TotalCnt = Ii_TotalCnt + 1
	
	ls_seqno =String(ll_seqno)
	ll_zero_length =LenA(ls_seqno)
	ls_seqno =WF_SETTING_ZERO(4,ll_zero_length)+ls_seqno

	/*99.07.16 수정 - 상호,업태,업종 NULL 체크*/
	IF IsNull(ls_sangho) THEN
		ls_sangho =""
	END IF
	ll_zero_length =LenA(ls_sangho)
	ls_sangho =ls_sangho+WF_SETTING_SPACE(30,ll_zero_length)
	
	IF IsNull(ls_uptae) THEN
		ls_uptae =""
	END IF
	ll_zero_length =LenA(ls_uptae)
	ls_uptae =ls_uptae+WF_SETTING_SPACE(17,ll_zero_length)
	
	IF IsNull(ls_upjong) THEN
		ls_upjong =""
	END IF
	ll_zero_length =LenA(ls_upjong)
	ls_upjong = ls_upjong+WF_SETTING_SPACE(25,ll_zero_length)
	
	ls_maisu =String(ll_maisu)
	ll_zero_length =LenA(ls_maisu)
	ls_maisu =WF_SETTING_ZERO(7,ll_zero_length)+ls_maisu

	/*2004.03월 공란수 = 0*/
//	ls_zero_cnt =String(ll_zero_cnt)
//	ll_zero_length =Len(ls_zero_cnt)
	ls_zero_cnt =WF_SETTING_ZERO(2,0)

	ls_gon_amt = wf_amtconv(ldb_gon_amt)
	ll_zero_length =LenA(ls_gon_amt)
	ls_gon_amt =WF_SETTING_ZERO(14,ll_zero_length)+ls_gon_amt

	ls_vat_amt = wf_amtconv(ldb_vat_amt)
	ll_zero_length =LenA(ls_vat_amt)
	ls_vat_amt =WF_SETTING_ZERO(13,ll_zero_length)+ls_vat_amt

	ls_jugu1 =String(ll_jugu1)
	ll_zero_length =LenA(ls_jugu1)
	ls_jugu1 =WF_SETTING_SPACE(1,ll_zero_length)+ls_jugu1

	ls_jugu2 =String(ll_jugu2)
	ll_zero_length =LenA(ls_jugu2)
	ls_jugu2 =WF_SETTING_SPACE(1,ll_zero_length)+ls_jugu2

	ls_guan_no =String(ll_guan_no)
	ll_zero_length =LenA(ls_guan_no)
	ls_guan_no =WF_SETTING_ZERO(4,ll_zero_length)+ls_guan_no

	ls_jechul_code =String(ll_jechul_code)
	ll_zero_length =LenA(ls_jechul_code)
	ls_jechul_code =WF_SETTING_ZERO(3,ll_zero_length)+ls_jechul_code

	IF IsNull(ls_bigo) THEN
		ls_bigo =""
	END IF
	ll_zero_length =LenA(ls_bigo)
	ls_bigo =ls_bigo+WF_SETTING_SPACE(28,ll_zero_length)

	ls_setting_text=ls_gubun+ls_saupno1+ls_seqno+ls_saupno2+ls_sangho+ls_uptae+ls_upjong+&
						 ls_maisu+ls_zero_cnt+ls_gon_amt+ls_vat_amt+ls_jugu1+ls_jugu2+&
						 ls_guan_no+ls_jechul_code+ls_bigo

	ll_row = dw_work.InsertRow(0)
	dw_work.SetItem(ll_row,"fdate",   ls_sdate)
	dw_work.SetItem(ll_row,"tdate",   ls_edate)
	dw_work.SetItem(ll_row,"saupno",  IsCommJasa)
	dw_work.SetItem(ll_row,"test",    ls_setting_text)
	dw_work.SetItem(ll_row,"seqno",   Ii_TotalCnt)
LOOP
CLOSE save_maiip_list;
end event

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
	F_MessageChk(1,'[제출서]')
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
w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 DATA 초기화 중......"

/*부가세 디스켓처리 관련 데이터 삭제*/
function_chk =WF_CLEAR(ls_date,ls_sdate,ls_edate)
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 데이터 초기화 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 표지 DATA 갱신 중......"
function_chk =WF_SETTING_TITLE()
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 표지 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 매출자료 DATA 갱신 중......"
function_chk =WF_SETTING_MAICHUL_LIST()
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 매출자료 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text = "부가세 디스켓처리 관련 매출합계 DATA 갱신 중......"
function_chk = WF_SETTING_MAICHUL_HAP()
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 매출합계 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 매입자료 DATA 갱신 중......"
function_chk =WF_SETTING_MAIIP_LIST()
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 매입자료 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="부가세 디스켓처리 관련 매입합계 DATA 갱신 중......"
function_chk =WF_SETTING_MAIIP_HAP()
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 관련 매입합계 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
ELSE
	commit;
END IF

w_mdi_frame.sle_msg.text ="부가세 내역을  TEXT로 받는 중입니다.!!!"
function_chk =WF_SETTING_WORK(ls_sdate,ls_edate)
IF function_chk =False THEN
	MessageBox("확 인","부가세 디스켓 처리 작업용 DATA 갱신 실패.!!!")
	ROLLBACK;
	Return
END IF

COMMIT;

/*화일 저장 위치*/
String sFileName
sPath       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"spath")
sFileName	= tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"savefilename")

sSaveFile   = sPath + sFileName

dw_file.Retrieve(ls_sdate,ls_edate,IsCommJasa)

dw_file.SaveAs(sSaveFile, TEXT!, FALSE)

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="부가세 디스켓처리 완료"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_ktxa21
integer x = 3630
integer y = 2740
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa21
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
integer x = 2930
integer y = 2740
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa21
integer x = 2080
integer y = 3028
end type

type cb_del from w_inherite`cb_del within w_ktxa21
integer x = 2446
integer y = 3084
end type

type cb_inq from w_inherite`cb_inq within w_ktxa21
integer x = 2802
integer y = 3084
end type

type cb_print from w_inherite`cb_print within w_ktxa21
integer x = 3282
integer y = 2740
end type

type st_1 from w_inherite`st_1 within w_ktxa21
integer y = 2112
end type

type cb_can from w_inherite`cb_can within w_ktxa21
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa21
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa21
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa21
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa21
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa21
integer x = 2075
integer y = 2676
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa21
integer x = 2889
integer y = 2692
integer width = 1083
integer height = 180
end type

type dw_title from datawindow within w_ktxa21
boolean visible = false
integer x = 73
integer y = 2380
integer width = 667
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "부가세 디스켓 표지"
string dataobject = "dw_ktxa212"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_maichul_hap from datawindow within w_ktxa21
boolean visible = false
integer x = 73
integer y = 2488
integer width = 649
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "매출합계"
string dataobject = "dw_ktxa213"
boolean livescroll = true
end type

type dw_maichul_list from datawindow within w_ktxa21
boolean visible = false
integer x = 722
integer y = 2484
integer width = 649
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "매출자료"
string dataobject = "dw_ktxa216"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_maiip_hap from datawindow within w_ktxa21
boolean visible = false
integer x = 73
integer y = 2588
integer width = 649
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "매입합계"
string dataobject = "dw_ktxa217"
boolean livescroll = true
end type

type dw_maiip_list from datawindow within w_ktxa21
boolean visible = false
integer x = 727
integer y = 2588
integer width = 649
integer height = 100
boolean dragauto = true
boolean bringtotop = true
boolean titlebar = true
string title = "매입자료"
string dataobject = "dw_ktxa218"
boolean livescroll = true
end type

type dw_work from datawindow within w_ktxa21
integer x = 78
integer y = 2716
integer width = 1225
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "부가세 디스켓 작업"
string dataobject = "dw_ktxa219"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_maisu from datawindow within w_ktxa21
boolean visible = false
integer x = 1403
integer y = 2484
integer width = 649
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "매출,합(매수)"
string dataobject = "dw_ktxa214"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_maisu_maiip from datawindow within w_ktxa21
boolean visible = false
integer x = 1408
integer y = 2592
integer width = 649
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "매입합(매수)"
string dataobject = "dw_ktxa215"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type tab_vat from tab within w_ktxa21
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
string dataobject = "dw_ktxa211"
boolean border = false
end type

event itemchanged;String ls_saupno,ls_sanho, ls_name, ls_uptae, ls_upjong, ls_addr1,ls_addr2,&
		 sVatGisu, sStart,   sEnd,    sProcGbn, sCommJasa, sGbn,	   snull

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
string dataobject = "dw_ktxa21p"
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
string dataobject = "dw_ktxa21p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_label from userobject within tab_vat
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
string dataobject = "dw_ktxa21l"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_ktxa21
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
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa21p'
	
	tab_vat.tabpage_print2.text = '매입처별 세금계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa21p1' 
	
	dw_rtv.DataObject = 'dw_ktxa21p2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	dw_rtv.SetTransObject(Sqlca)
end if
end event

type rb_2 from radiobutton within w_ktxa21
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
	tab_vat.tabpage_print1.dw_print.DataObject = 'dw_ktxa21po'
	
	tab_vat.tabpage_print2.text = '매출처별 세금계산서 합계표(을)'
	tab_vat.tabpage_print2.dw_print2.DataObject = 'dw_ktxa21po1' 
	
	dw_rtv.DataObject = 'dw_ktxa21po2' 
	
	tab_vat.tabpage_print1.dw_print.SetTransObject(Sqlca)
	tab_vat.tabpage_print2.dw_print2.SetTransObject(Sqlca)
	dw_rtv.SetTransObject(Sqlca)
end if
end event

type dw_rtv from datawindow within w_ktxa21
integer x = 73
integer y = 2908
integer width = 869
integer height = 112
boolean bringtotop = true
boolean titlebar = true
string title = "매입세금계산서합계표 조회"
string dataobject = "dw_ktxa21p2"
boolean border = false
boolean livescroll = true
end type

type dw_file from datawindow within w_ktxa21
boolean visible = false
integer x = 73
integer y = 3036
integer width = 1554
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "파일저장"
string dataobject = "dw_ktxa219f"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type gb_1 from groupbox within w_ktxa21
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

