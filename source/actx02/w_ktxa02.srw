$PBExportHeader$w_ktxa02.srw
$PBExportComments$부가세 명세서 조회 출력(이전)
forward
global type w_ktxa02 from w_standard_print
end type
type gb_4 from groupbox within w_ktxa02
end type
type rb_1 from radiobutton within w_ktxa02
end type
type rb_2 from radiobutton within w_ktxa02
end type
type dw_maiip_rtv from datawindow within w_ktxa02
end type
type dw_maichul_rtv from datawindow within w_ktxa02
end type
type rb_3 from radiobutton within w_ktxa02
end type
type tab_list from tab within w_ktxa02
end type
type tabpage_list from userobject within tab_list
end type
type dw_tax_print from datawindow within tabpage_list
end type
type rr_2 from roundrectangle within tabpage_list
end type
type tabpage_list from userobject within tab_list
dw_tax_print dw_tax_print
rr_2 rr_2
end type
type tabpage_list2 from userobject within tab_list
end type
type rr_3 from roundrectangle within tabpage_list2
end type
type dw_tax_print2 from datawindow within tabpage_list2
end type
type tabpage_list2 from userobject within tab_list
rr_3 rr_3
dw_tax_print2 dw_tax_print2
end type
type tab_list from tab within w_ktxa02
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
end type
type st_1 from statictext within w_ktxa02
end type
end forward

global type w_ktxa02 from w_standard_print
string title = "부가세명세서 조회 출력"
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
dw_maiip_rtv dw_maiip_rtv
dw_maichul_rtv dw_maichul_rtv
rb_3 rb_3
tab_list tab_list
st_1 st_1
end type
global w_ktxa02 w_ktxa02

type variables
String              prt_gu
DataWindow  Idw_tax_print
end variables

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
public function integer wf_maichul_segum (string svatgisu)
public function integer wf_maiip_segum (string svatgisu)
public function integer wf_maiip_hap (string svatgisu)
public function integer wf_maichul_hap (string svatgisu)
end prototypes

public function integer wf_print ();
IF prt_gu = "maiipjang" OR prt_gu = "maichuljang" OR prt_gu = "maiip_jip" OR prt_gu = "young_se" THEN
	IF tab_list.tabpage_list.dw_tax_print.RowCount() > 0 THEN
		OpenWithParm(w_print_options,tab_list.tabpage_list.dw_tax_print)
	END IF
ELSEIF prt_gu = "maiip_segum" OR prt_gu = "maichul_segum" OR prt_gu = "maiip_hap" OR prt_gu = "maichul_hap" or prt_gu = 'suchul' THEN
	openwithparm(w_print_options, idw_tax_print)
END IF

Return -1
end function

public function integer wf_retrieve ();String svatgisu,sTax,sJasa,saupj_name,sjasa_name,stax_name,sStart,sEnd,sabu,sApplyflag,sBalNm,sCrtDate

dw_ip.AcceptText()

sle_msg.text =""

sabu_f   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
svatgisu = dw_ip.getitemstring(dw_ip.getrow(),"vatgisu")
sStart   = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datef"))
sEnd     = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datet"))
sTax     = dw_ip.getitemstring(dw_ip.getrow(),"stax")
sJasa    = dw_ip.getitemstring(dw_ip.getrow(),"sjasa") 

IF sabu_f = "" OR IsNull(sabu_f) THEN 
	sabu_f = '10'
	sabu_t = '98'
	sabu   = '99'
else
	sabu_t = sabu_f
	sabu   = sabu_f
end if

IF sStart = "" OR IsNull(sStart) THEN
	F_MessageChk(1,'[거래기간]')	
	dw_ip.SetColumn("datef")
	dw_ip.SetFocus()
	Return -1 
END IF

IF sJasa = "" OR IsNull(sJasa) THEN
	SELECT "REFFPF"."RFNA1" 
		INTO :saupj_name 
		FROM "REFFPF"
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sabu );
ELSE
	SELECT "REFFPF_B"."RFNA1"     INTO :saupj_name 
	   FROM "REFFPF" "REFFPF_A",            "REFFPF" "REFFPF_B"  
	   WHERE ( "REFFPF_A"."RFGUB" = "REFFPF_B"."RFNA2" ) and  
   	      (( "REFFPF_A"."RFCOD" = 'JA' ) AND  
      	   ( "REFFPF_A"."RFGUB" = :sJasa ) AND  
         	( "REFFPF_B"."RFCOD" = 'AD' ))   ;
				
END IF			

CHOOSE CASE prt_gu
	CASE "maiipjang", "maichuljang"
		IF sTax = "" OR IsNull(sTax) THEN sTax = '%'
		IF sJasa = "" OR IsNull(sJasa) THEN 
			sJasa = '%'
		ELSE
			SELECT "REFFPF"."RFNA1" 		INTO :sjasa_name 
				FROM "REFFPF"
				WHERE ( "REFFPF"."RFCOD" = 'JA' ) AND ( "REFFPF"."RFGUB" = :sJasa );
      END IF
		
		IF tab_list.tabpage_list.dw_tax_print.Retrieve(sabu_f,sabu_t,stax,sStart,sEnd,sjasa,saupj_name,sjasa_name) <=0 THEN															
			//f_Messagechk(14,"")
			tab_list.tabpage_list.dw_tax_print.insertrow(0)
			//Return -1
		END IF
		
		dw_print.Retrieve(sabu_f,sabu_t,stax,sStart,sEnd,sjasa,saupj_name,sjasa_name)														
		dw_print.sharedata(dw_list)
		sle_msg.Text ="조회 완료했습니다.!!!"

	CASE "maiip_segum"
		IF wf_maiip_segum(sVatGisu) = -1 THEN RETURN -1
		
	CASE "maichul_segum"
		IF wf_maichul_segum(sVatGisu) = -1 THEN RETURN -1
		
	CASE "maiip_jip"
		sTax  = dw_ip.GetItemString(dw_ip.GetRow(),"stax")
		sjasa = dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
      IF sjasa ="" OR IsNull(sjasa) THEN
	      sjasa ="%"
      END IF
		
		IF sTax ="" OR IsNull(sTax) THEN
			sTax ="%"
		ELSE
			SELECT "REFFPF"."RFNA1"  
		   	INTO :stax_name  
    			FROM "REFFPF"  
			   WHERE ( "REFFPF"."RFCOD" = 'AT' ) AND  ( "REFFPF"."RFGUB" = :sTax )   ;
		END IF
		
		sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
		IF tab_list.tabpage_list.dw_tax_print.Retrieve(sabu_f,sabu_t,sStart,sEnd,stax,saupj_name,stax_name,sJasa,sApplyFlag) <=0 THEN															
			//f_Messagechk(14,"")
			
			tab_list.tabpage_list.dw_tax_print.insertrow(0)
			//Return -1
		END IF
		dw_print.Retrieve(sabu_f,sabu_t,sStart,sEnd,stax,saupj_name,stax_name,sJasa,sApplyFlag)
		dw_print.sharedata(dw_list)
		sle_msg.Text ="매입매출집계표 조회 완료했습니다.!!!"

	CASE "maiip_hap"		
		IF wf_maiip_hap(sVatGisu) = -1 THEN RETURN -1
		
	CASE "maichul_hap"
		IF wf_maichul_hap(sVatgisu) = -1 THEN RETURN -1
		
	CASE "young_se"
		sjasa = dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
      IF sjasa ="" OR IsNull(sjasa) THEN
	      sjasa ="%"
      END IF
		sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))
//		sBalNm = dw_ip.GetItemString(dw_ip.GetRow(),"balname")
		
		IF tab_list.tabpage_list.dw_tax_print.Retrieve(sStart,sEnd,sjasa,svatgisu,sCrtDate) <=0 THEN															
			//f_Messagechk(14,"")
			tab_list.tabpage_list.dw_tax_print.insertrow(0)
			//Return -1
		END IF
		dw_print.Retrieve(sStart,sEnd,sjasa,svatgisu,sCrtDate)
		dw_print.sharedata(dw_list)
		sle_msg.Text ="영세율 첨부서류 목록을 조회 완료했습니다.!!!"
	
END CHOOSE	

Return 1
end function

public function integer wf_maichul_segum (string svatgisu);
String saupj,sJasa,sStart,sEnd,sCommJasa,sApplyFlag ='1',sCrtDate
Int il_currow , il_RetrieveRow, i,il_dvdval

sle_msg.text =""

//dw_ip.AcceptText()

tab_list.tabpage_list.dw_tax_print.Reset()
tab_list.tabpage_list2.dw_tax_print2.Reset()

sjasa =dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
sStart   = dw_ip.getitemstring(dw_ip.getrow(),"datef")
sEnd     = dw_ip.getitemstring(dw_ip.getrow(),"datet")
sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

IF isnull(sJasa) or sJasa = '' THEN
	sJasa = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.SetColumn("sjasa")
		dw_ip.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasa
	sApplyFlag = '%'
END IF

tab_list.tabpage_list.dw_tax_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_maichul_rtv.Retrieve(sabu_f,sabu_t,sStart,sEnd,sjasa,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"")
	Return -1
ELSE
	il_RetrieveRow =dw_maichul_rtv.RowCount()
END IF

SetPointer(HourGlass!)
sle_msg.text ="매출처별 세금계산서 합계표 내역 조회 중...!!!"

tab_list.tabpage_list.dw_tax_print.SetRedraw(False)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 21 THEN															//매출처별 세금계산서(갑)
	   tab_list.tabpage_list.dw_tax_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		
		il_currow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
		
		//자사내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"sano",dw_maichul_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"cvnm",dw_maichul_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"ownm",dw_maichul_rtv.GetItemString(1,"jasa_manager"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr",&
				dw_maichul_rtv.GetItemString(1,"jasa_add1") + dw_maichul_rtv.GetItemString(1,"jasa_add2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"uptae",dw_maichul_rtv.GetItemString(1,"jasa_uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"jong",dw_maichul_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"symd",sStart)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"eymd",sEnd)

		//합계내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup",dw_maichul_rtv.GetItemNumber(1,"sum_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup_nbr",dw_maichul_rtv.GetItemNumber(1,"sum_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_gon_amt",dw_maichul_rtv.GetItemNumber(1,"sum_gong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_vat_amt",dw_maichul_rtv.GetItemNumber(1,"sum_vat"))

		//개인
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_num",dw_maichul_rtv.GetItemNumber(1,"per_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_gensu",dw_maichul_rtv.GetItemNumber(1,"per_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_gon_sum",dw_maichul_rtv.GetItemNumber(1,"per_gong_sum"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_vat_sum",dw_maichul_rtv.GetItemNumber(1,"per_vat_sum"))
		
		//사업자등록번호
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_num",dw_maichul_rtv.GetItemNumber(1,"sano_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_gensu",dw_maichul_rtv.GetItemNumber(1,"sano_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_gon_sum",dw_maichul_rtv.GetItemNumber(1,"sano_gong_sum"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_vat_sum",dw_maichul_rtv.GetItemNumber(1,"sano_vat_sum"))
		
		//거래내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maichul_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_cvnas",dw_maichul_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_uptae",dw_maichul_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_jongk",dw_maichul_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_nbr",dw_maichul_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maichul_rtv.GetItemNumber(i,"cust_gong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_vat_amt",dw_maichul_rtv.GetItemNumber(i,"cust_vat"))
	ELSE																		//매출처별 세금계산서(을)
		tab_list.tabpage_list2.dw_tax_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		
		il_currow = tab_list.tabpage_list2.dw_tax_print2.Insertrow(0)
		
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"sano",dw_maichul_rtv.GetItemString(1,"jasa_sano"))
		
		//거래내역
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maichul_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_cvnas",dw_maichul_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_uptae",dw_maichul_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_jongk",dw_maichul_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"saup_nbr",dw_maichul_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maichul_rtv.GetItemNumber(i,"cust_gong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_vat_amt",dw_maichul_rtv.GetItemNumber(i,"cust_vat"))
	END IF
NEXT

IF il_RetrieveRow < 21 THEN
	il_dvdval =Mod(il_RetrieveRow,21)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 20 STEP 1
			int llrow
			
			llrow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
			
		   tab_list.tabpage_list.dw_tax_print.SetItem(llrow,"seq_num",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_list.tabpage_list2.dw_tax_print2.InsertRow(0)
		NEXT
	END IF
END IF

tab_list.tabpage_list.dw_tax_print.SetRedraw(True)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(True)

sle_msg.text ="매출처별 세금계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

Return il_RetrieveRow

end function

public function integer wf_maiip_segum (string svatgisu);
String saupj,sJasa,sStart,sEnd,sCommJasa,sApplyFlag ='1',sCrtDate
Int il_currow , il_RetrieveRow, i,il_dvdval

sle_msg.text =""

dw_ip.AcceptText()

tab_list.tabpage_list.dw_tax_print.Reset()
tab_list.tabpage_list2.dw_tax_print2.Reset()

sJasa =dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
sStart   = dw_ip.getitemstring(dw_ip.getrow(),"datef")
sEnd     = dw_ip.getitemstring(dw_ip.getrow(),"datet")
sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

IF isnull(sJasa) or sJasa = '' THEN
	sJasa = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.SetColumn("sjasa")
		dw_ip.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasa
	sApplyFlag = '%'
END IF

tab_list.tabpage_list.dw_tax_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_maiip_rtv.Retrieve(sabu_f,sabu_t,sStart,sEnd,sjasa,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_maiip_rtv.RowCount()
END IF

SetPointer(HourGlass!)
sle_msg.text ="매입처별 세금계산서 합계표 내역 조회 중...!!!"

tab_list.tabpage_list.dw_tax_print.SetRedraw(False)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 27 THEN															//매입처별 세금계산서(갑)
		tab_list.tabpage_list.dw_tax_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		
		il_currow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
		
		//자사내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"sano",dw_maiip_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"cvnm",dw_maiip_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"ownm",dw_maiip_rtv.GetItemString(1,"jasa_manager"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr",&
				dw_maiip_rtv.GetItemString(1,"jasa_add1") + dw_maiip_rtv.GetItemString(1,"jasa_add2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"uptae",dw_maiip_rtv.GetItemString(1,"jasa_uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"jong",dw_maiip_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"symd",sStart)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"eymd",sEnd)

		//합계내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup",il_RetrieveRow)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup_nbr",dw_maiip_rtv.GetItemNumber(1,"cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_gon_amt",dw_maiip_rtv.GetItemNumber(1,"gong_sum"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_vat_amt",dw_maiip_rtv.GetItemNumber(1,"vat_sum"))

		//거래내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maiip_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_cvnas",dw_maiip_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_uptae",dw_maiip_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_jongk",dw_maiip_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_nbr",dw_maiip_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maiip_rtv.GetItemNumber(i,"cust_gong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_vat_amt",dw_maiip_rtv.GetItemNumber(i,"cust_vat"))
	ELSE																		//매입처별 세금계산서(을)
		tab_list.tabpage_list2.dw_tax_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		
		il_currow = tab_list.tabpage_list2.dw_tax_print2.Insertrow(0)
		
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"sano",dw_maiip_rtv.GetItemString(1,"jasa_sano"))
		
		//거래내역
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maiip_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_cvnas",dw_maiip_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_uptae",dw_maiip_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_jongk",dw_maiip_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"saup_nbr",dw_maiip_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maiip_rtv.GetItemNumber(i,"cust_gong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_vat_amt",dw_maiip_rtv.GetItemNumber(i,"cust_vat"))
	END IF
NEXT

IF il_RetrieveRow < 27 THEN
	il_dvdval =Mod(il_RetrieveRow,27)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 26 STEP 1
			int llrow
			
			llrow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
			
		   tab_list.tabpage_list.dw_tax_print.SetItem(llrow,"seq_num",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_list.tabpage_list2.dw_tax_print2.InsertRow(0)
		NEXT
	END IF
END IF

tab_list.tabpage_list.dw_tax_print.SetRedraw(True)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(True)

sle_msg.text ="매입처별 세금계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

Return il_RetrieveRow

end function

public function integer wf_maiip_hap (string svatgisu);
String saupj,sJasa,sStart,sEnd,sCommJasa,sApplyFlag,sCrtDate
Int il_currow , il_RetrieveRow, i,il_dvdval

sle_msg.text =""

dw_ip.AcceptText()
sJasa   = dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
sStart  = dw_ip.getitemstring(dw_ip.getrow(),"datef")
sEnd    = dw_ip.getitemstring(dw_ip.getrow(),"datet")
sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

tab_list.tabpage_list.dw_tax_print.Reset()
tab_list.tabpage_list2.dw_tax_print2.Reset()

IF isnull(sJasa) or sJasa = '' THEN
	sJasa = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.SetColumn("sjasa")
		dw_ip.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasa
	sApplyFlag = '%'
END IF

tab_list.tabpage_list.dw_tax_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_maiip_rtv.Retrieve(sabu_f,sabu_t,sStart,sEnd,sjasa,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_maiip_rtv.RowCount()
END IF

SetPointer(HourGlass!)
sle_msg.text ="매입처별 계산서 합계표 내역 조회 중...!!!"

tab_list.tabpage_list.dw_tax_print.SetRedraw(False)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 27 THEN															//매입처별 계산서(갑)
		tab_list.tabpage_list.dw_tax_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
	
		il_currow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
		
		//자사내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"sano",dw_maiip_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"cvnm",dw_maiip_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"ownm",dw_maiip_rtv.GetItemString(1,"jasa_manager"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr",&
				dw_maiip_rtv.GetItemString(1,"jasa_add1") + dw_maiip_rtv.GetItemString(1,"jasa_add2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"uptae",dw_maiip_rtv.GetItemString(1,"jasa_uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"jong",dw_maiip_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"symd",sStart)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"eymd",sEnd)

		//합계내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup",il_RetrieveRow)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup_nbr",dw_maiip_rtv.GetItemNumber(1,"cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_gon_amt",dw_maiip_rtv.GetItemNumber(1,"gong_sum"))

		//거래내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maiip_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_cvnas",dw_maiip_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_uptae",dw_maiip_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_jongk",dw_maiip_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr2",       dw_maiip_rtv.GetItemString(i,"addr2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_nbr",dw_maiip_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maiip_rtv.GetItemNumber(i,"cust_gong"))
	ELSE																		//매입처별 계산서(을)
		tab_list.tabpage_list2.dw_tax_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		il_currow = tab_list.tabpage_list2.dw_tax_print2.Insertrow(0)
		
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"sano",dw_maiip_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"cvnm",dw_maiip_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"ownm",dw_maiip_rtv.GetItemString(1,"jasa_manager"))
		
		//거래내역
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maiip_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_cvnas",dw_maiip_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_uptae",dw_maiip_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_jongk",dw_maiip_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"addr2",       dw_maiip_rtv.GetItemString(i,"addr2"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"saup_nbr",dw_maiip_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maiip_rtv.GetItemNumber(i,"cust_gong"))
	END IF
NEXT

IF il_RetrieveRow < 27 THEN
	il_dvdval =Mod(il_RetrieveRow,27)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 26 STEP 1
			int llrow
			
			llrow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
			
		   tab_list.tabpage_list.dw_tax_print.SetItem(llrow,"seq_num",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_list.tabpage_list2.dw_tax_print2.InsertRow(0)
		NEXT
	END IF
END IF

tab_list.tabpage_list.dw_tax_print.SetRedraw(True)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(True)

sle_msg.text ="매입처별 계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)

Return il_RetrieveRow

end function

public function integer wf_maichul_hap (string svatgisu);
String saupj,sJasa,sStart,sEnd,sCommJaSa,sApplyflag,sCrtDate
Int il_currow , il_RetrieveRow, i,il_dvdval

sle_msg.text =""

dw_ip.AcceptText()
sjasa    = dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
sStart   = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datef"))
sEnd     = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datet"))
sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE

	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

tab_list.tabpage_list.dw_tax_print.Reset()
tab_list.tabpage_list2.dw_tax_print2.Reset()

IF isnull(sJasa) or sJasa = '' THEN
	sJasa = '%'
	sApplyFlag = '1'										/*총괄납부 적용여부 1)적용*/
	
	SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.SetColumn("sjasa")
		dw_ip.SetFocus()
		Return -1
	ELSE
		IF IsNull(sCommJasa) OR sCommJasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
	END IF
ELSE
	sCommJasa = sJasa
	sApplyFlag = '%'
END IF

tab_list.tabpage_list.dw_tax_print.Modify("crtdate_t.text = '"+sCrtDate+"'")
IF dw_maichul_rtv.Retrieve(sabu_f,sabu_t,sStart,sEnd,sjasa,sCommJasa,sApplyFlag) <= 0 THEN 											
	f_Messagechk(14,"") 
	Return -1
ELSE
	il_RetrieveRow =dw_maichul_rtv.RowCount()
END IF

SetPointer(HourGlass!)
sle_msg.text ="매출처별 계산서 합계표 조회 중...!!!"

tab_list.tabpage_list.dw_tax_print.SetRedraw(False)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(False)

FOR i =1 TO il_RetrieveRow STEP 1
	IF i <= 21 THEN															//매출처별 계산서(갑)
		tab_list.tabpage_list.dw_tax_print.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
	
		il_currow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
		
		//자사내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"sano",dw_maichul_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"cvnm",dw_maichul_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"ownm",dw_maichul_rtv.GetItemString(1,"jasa_manager"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr",&
				dw_maichul_rtv.GetItemString(1,"jasa_add1") + dw_maichul_rtv.GetItemString(1,"jasa_add2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"uptae",dw_maichul_rtv.GetItemString(1,"jasa_uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"jong",dw_maichul_rtv.GetItemString(1,"jasa_upjong"))
		
		//거래일자
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"symd",sStart)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"eymd",sEnd)

		//합계내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup",dw_maichul_rtv.GetItemNumber(1,"sum_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_saup_nbr",dw_maichul_rtv.GetItemNumber(1,"sum_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"tot_gon_amt",dw_maichul_rtv.GetItemNumber(1,"sum_gong"))

		//개인
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_num",dw_maichul_rtv.GetItemNumber(1,"per_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_gensu",dw_maichul_rtv.GetItemNumber(1,"per_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"gaiin_gon_sum",dw_maichul_rtv.GetItemNumber(1,"per_gong_sum"))
		
		//사업자등록번호
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_num",dw_maichul_rtv.GetItemNumber(1,"sano_cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_gensu",dw_maichul_rtv.GetItemNumber(1,"sano_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_gon_sum",dw_maichul_rtv.GetItemNumber(1,"sano_gong_sum"))
		
		//거래내역
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maichul_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_cvnas",dw_maichul_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_uptae",dw_maichul_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"vndmst_jongk",dw_maichul_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"addr2",       dw_maichul_rtv.GetItemString(i,"addr2"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"saup_nbr",dw_maichul_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list.dw_tax_print.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maichul_rtv.GetItemNumber(i,"cust_gong"))
	ELSE																		//매출처별 계산서(을)
		tab_list.tabpage_list2.dw_tax_print2.object.gisu_t.text = '( '+left(sCrtDate, 4)+' 년 '+svatgisu+' 기 )'
		
		il_currow = tab_list.tabpage_list2.dw_tax_print2.Insertrow(0)
		
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"sano",dw_maichul_rtv.GetItemString(1,"jasa_sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"cvnm",dw_maichul_rtv.GetItemString(1,"jasa_nm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"ownm",dw_maichul_rtv.GetItemString(1,"jasa_manager"))
		
		//거래내역
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"seq_num",i)
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_saup_no2",dw_maichul_rtv.GetItemString(i,"sano"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_cvnas",dw_maichul_rtv.GetItemString(i,"cusnm"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_uptae",dw_maichul_rtv.GetItemString(i,"uptae"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"vndmst_jongk",dw_maichul_rtv.GetItemString(i,"upjong"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"addr2",       dw_maichul_rtv.GetItemString(i,"addr2"))		
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"saup_nbr",dw_maichul_rtv.GetItemNumber(i,"cust_cnt"))
		tab_list.tabpage_list2.dw_tax_print2.SetItem(il_currow,"kfz17ot0_gon_amt",dw_maichul_rtv.GetItemNumber(i,"cust_gong"))
	END IF
NEXT

IF il_RetrieveRow < 21 THEN
	il_dvdval =Mod(il_RetrieveRow,21)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 20 STEP 1
			int llrow
			
			llrow = tab_list.tabpage_list.dw_tax_print.InsertRow(0)
			
		   tab_list.tabpage_list.dw_tax_print.SetItem(llrow,"seq_num",llrow )
		NEXT
	END IF
ELSE
	il_dvdval =Mod(il_currow,29)
	IF il_dvdval =0 THEN
	ELSE
		FOR i =il_dvdval TO 28 STEP 1
			tab_list.tabpage_list2.dw_tax_print2.InsertRow(0)
		NEXT
	END IF
END IF

tab_list.tabpage_list.dw_tax_print.SetRedraw(True)
tab_list.tabpage_list2.dw_tax_print2.SetRedraw(True)

sle_msg.text ="매출처별 계산서 합계표 조회 완료!!!"	
SetPointer(Arrow!)


Return il_RetrieveRow

end function

on w_ktxa02.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_maiip_rtv=create dw_maiip_rtv
this.dw_maichul_rtv=create dw_maichul_rtv
this.rb_3=create rb_3
this.tab_list=create tab_list
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_maiip_rtv
this.Control[iCurrent+5]=this.dw_maichul_rtv
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.tab_list
this.Control[iCurrent+8]=this.st_1
end on

on w_ktxa02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_maiip_rtv)
destroy(this.dw_maichul_rtv)
destroy(this.rb_3)
destroy(this.tab_list)
destroy(this.st_1)
end on

event open;call super::open;print_gu="DOUBLE"

//dw_ip.SetItem(dw_ip.GetRow(),"saupj", gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')
dw_ip.SetItem(dw_ip.Getrow(),"sjunno",1)
dw_ip.SetItem(dw_ip.Getrow(),"ejunno",9999)

tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)

dw_maiip_rtv.SetTransObject(SQLCA)
dw_maichul_rtv.SetTransObject(SQLCA)

prt_gu    = "maiipjang"
idw_tax_print = tab_list.tabpage_list.dw_tax_print

//rb_1.Checked =True
//rb_1.TriggerEvent(Clicked!)

dw_ip.SetColumn("vatgisu")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_ktxa02
end type

event p_preview::clicked;IF prt_gu = "maiipjang" OR prt_gu = "maichuljang" OR prt_gu = "maiip_jip" OR prt_gu = "young_se" THEN
	IF tab_list.tabpage_list.dw_tax_print.RowCount() > 0 THEN
		OpenWithParm(w_print_preview,dw_print)
	END IF
ELSEIF prt_gu = "maiip_segum" OR prt_gu = "maichul_segum" OR prt_gu = "maiip_hap" OR prt_gu = "maichul_hap" or prt_gu = 'suchul' THEN
	OpenWithParm(w_print_preview,idw_tax_print)
END IF




end event

type p_exit from w_standard_print`p_exit within w_ktxa02
integer x = 4439
end type

type p_print from w_standard_print`p_print within w_ktxa02
integer x = 4265
end type

event p_print::clicked;IF Wf_Print() = -1 then return
end event

type p_retrieve from w_standard_print`p_retrieve within w_ktxa02
end type





type dw_datetime from w_standard_print`dw_datetime within w_ktxa02
integer x = 2834
end type

type st_10 from w_standard_print`st_10 within w_ktxa02
end type

type gb_10 from w_standard_print`gb_10 within w_ktxa02
integer x = 55
integer y = 2932
integer width = 3584
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_ktxa02
string dataobject = "dw_ktxa012_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa02
integer x = 23
integer y = 32
integer width = 2926
integer height = 448
string dataobject = "dw_ktxa011"
end type

event dw_ip::itemchanged;String  sSaupj,sSelectGbn,sVatGisu,sJasaCode,sTaxGbn,sStartDate,sEndDate,sNull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "sselect_gu" THEN
	sSelectGbn = this.GetText()
	
	IF sSelectGbn = '1' THEN
		prt_gu ="maiipjang"
	
		tab_list.tabpage_list.Text ="매입장"
		
		IF rb_1.Checked = True THEN
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa012"
			dw_print.DataObject ="dw_ktxa012_p"
		ELSEIF rb_2.Checked = True THEN
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0121"
			dw_print.DataObject ="dw_ktxa0121_p"
		ELSE
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0122"
			dw_print.DataObject ="dw_ktxa0122_p"
		END IF
		
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()

		tab_list.tabpage_list2.Text ='      '
		
		rb_1.Enabled =True
		rb_2.Enabled =True
		st_1.Enabled =True
		rb_3.Enabled =True
	ELSEIF sSelectGbn = '2' THEN
		prt_gu ="maichuljang"

		tab_list.tabpage_list.Text ="매출장"
		
		IF rb_2.Checked = True THEN
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa013"
			dw_print.DataObject ="dw_ktxa013_p"
		ELSEIF rb_1.Checked = True THEN
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0131"
			dw_print.DataObject ="dw_ktxa0131_p"
		ELSE
			tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0132"
			dw_print.DataObject ="dw_ktxa0132_p"
		END IF
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
		
		tab_list.tabpage_list2.Text ='      '
		
		rb_1.Enabled =True
		rb_2.Enabled =True
		st_1.Enabled =True
		rb_3.Enabled =True	
	ELSEIF sSelectGbn = '3' THEN
		prt_gu ="maiip_segum"

		tab_list.tabpage_list.Text ="매입처별 세금계산서 합계표(갑)"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa014"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
					
		tab_list.tabpage_list2.Text ="매입처별 세금계산서 합계표(을)"	
		tab_list.tabpage_list2.dw_tax_print2.DataObject ="dw_ktxa0141"
		tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)
			
		dw_maiip_rtv.title = '매입처별 세금계산서 자료 조회'
		dw_maiip_rtv.DataObject ="dw_ktxa0142"
		dw_maiip_rtv.SetTransObject(SQLCA)
		dw_maiip_rtv.Reset()
			
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '4' THEN
		prt_gu ="maichul_segum"

		tab_list.tabpage_list.Text ="매출처별 세금계산서 합계표(갑)"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa015"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()		
			
		tab_list.tabpage_list2.Text ="매출처별 세금계산서 합계표(을)"	
		tab_list.tabpage_list2.dw_tax_print2.DataObject ="dw_ktxa0151"
		tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)
			
		dw_maichul_rtv.title = '매출처별 세금계산서 자료 조회'
		dw_maichul_rtv.DataObject ="dw_ktxa0152"
		dw_maichul_rtv.SetTransObject(SQLCA)
		dw_maichul_rtv.Reset()
			
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '5' THEN
		prt_gu ="maiip_hap"

		tab_list.tabpage_list.Text ="매입처별 계산서 합계표(갑)"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa016"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
			
		tab_list.tabpage_list2.Text ="매입처별 계산서 합계표(을)"	
		tab_list.tabpage_list2.dw_tax_print2.DataObject ="dw_ktxa0161"
		tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)
			
		dw_maiip_rtv.title = '매입처별 계산서 자료 조회'
		dw_maiip_rtv.DataObject ="dw_ktxa0162"
		dw_maiip_rtv.SetTransObject(SQLCA)
		dw_maiip_rtv.Reset()
		
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '6' THEN
		prt_gu ="maichul_hap"

		tab_list.tabpage_list.Text ="매출처별 계산서 합계표(갑)"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa017"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
			
		tab_list.tabpage_list2.Text ="매출처별 계산서 합계표(을)"			
		tab_list.tabpage_list2.dw_tax_print2.DataObject ="dw_ktxa0171"
		tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)
			
		dw_maichul_rtv.title = '매출처별 계산서 자료 조회'
		dw_maichul_rtv.DataObject ="dw_ktxa0172"
		dw_maichul_rtv.SetTransObject(SQLCA)
		dw_maichul_rtv.Reset()
						
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '7' THEN
		prt_gu ="maiip_jip"

		tab_list.tabpage_list.Text ="매입매출집계표"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa018"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
		dw_print.DataObject ="dw_ktxa018_p"
		dw_print.SetTransObject(SQLCA)
		dw_print.Reset()
		
		tab_list.tabpage_list2.Text ='      '
		
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '8' THEN		
		prt_gu ="young_se"

		tab_list.tabpage_list.Text ="영세율 첨부서류"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa019"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
		dw_print.DataObject ="dw_ktxa019_p"
		dw_print.SetTransObject(SQLCA)
		dw_print.Reset()
		
		tab_list.tabpage_list2.Text ='      '
		
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	ELSEIF sSelectGbn = '9' THEN		
		prt_gu ="suchul"

		tab_list.tabpage_list.Text ="수출실적 명세서(갑)"
		tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0195"
		tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
		tab_list.tabpage_list.dw_tax_print.Reset()
			
		tab_list.tabpage_list2.Text ="수출실적 명세서(을)"	
		tab_list.tabpage_list2.dw_tax_print2.DataObject ="dw_ktxa01951"
		tab_list.tabpage_list2.dw_tax_print2.SetTransObject(SQLCA)
			
		rb_1.Enabled =False
		rb_2.Enabled =False
		st_1.Enabled =False
		rb_3.Enabled =False
	END IF
	tab_list.SelectedTab = 1
	
	sle_msg.text =""
	
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(iCurRow,"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),SUBSTR("REFFPF"."RFNA2",5,4)   
    		INTO :sStartDate,						:sEndDate  
		   FROM "REFFPF"  
   		WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  
         		( "REFFPF"."RFGUB" = :sVatGisu )   ;
		this.SetItem(iCurRow,"datef",Left(f_Today(),4)+sStartDate)
		this.SetItem(iCurRow,"datet",Left(f_Today(),4)+sEndDate)
	END IF
END IF

IF this.GetColumnName() ="sjasa" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN RETURN
		
	IF IsNull(F_Get_Refferance('JA',sJasaCode)) THEN
		F_MessageChk(20,'[자사코드]')
		this.SetItem(iCurRow,"sjasa",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="stax" THEN
	sTaxGbn = this.GetText()
	IF sTaxGbn ="" OR IsNull(sTaxGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sTaxGbn)) THEN
		F_MessageChk(20,'[부가세구분]')
		this.SetItem(iCurRow,"stax",snull)
		Return 1
	END IF
END IF


end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_ktxa02
boolean visible = false
integer x = 2240
integer y = 2908
integer width = 681
integer height = 104
string title = "매입장"
string dataobject = "dw_ktxa082"
boolean hsplitscroll = false
end type

type gb_4 from groupbox within w_ktxa02
integer x = 2962
integer y = 24
integer width = 681
integer height = 448
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "정렬순서"
end type

type rb_1 from radiobutton within w_ktxa02
integer x = 2999
integer y = 116
integer width = 631
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "회계일자 전표번호순"
boolean checked = true
end type

event clicked;
IF prt_gu ="maiipjang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa012"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
ELSEIF prt_gu ="maichuljang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa013"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
END IF

p_retrieve.TriggerEvent(Clicked!)


end event

type rb_2 from radiobutton within w_ktxa02
integer x = 2999
integer y = 196
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업자등록번호"
end type

event clicked;IF prt_gu ="maiipjang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0121"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
ELSEIF prt_gu ="maichuljang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0131"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

type dw_maiip_rtv from datawindow within w_ktxa02
boolean visible = false
integer x = 2217
integer y = 3032
integer width = 928
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "매입처별 조회"
string dataobject = "dw_ktxa0142"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type dw_maichul_rtv from datawindow within w_ktxa02
boolean visible = false
integer x = 2217
integer y = 3148
integer width = 933
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "매출처별 조회"
string dataobject = "dw_ktxa0152"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type rb_3 from radiobutton within w_ktxa02
integer x = 2999
integer y = 352
integer width = 571
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업자등록번호순"
end type

event clicked;IF prt_gu ="maiipjang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0122"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
ELSEIF prt_gu ="maichuljang" THEN
	tab_list.tabpage_list.dw_tax_print.DataObject ="dw_ktxa0132"
	tab_list.tabpage_list.dw_tax_print.SetTransObject(SQLCA)
	tab_list.tabpage_list.dw_tax_print.Reset()
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

type tab_list from tab within w_ktxa02
integer x = 41
integer y = 508
integer width = 4576
integer height = 1752
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
end type

on tab_list.create
this.tabpage_list=create tabpage_list
this.tabpage_list2=create tabpage_list2
this.Control[]={this.tabpage_list,&
this.tabpage_list2}
end on

on tab_list.destroy
destroy(this.tabpage_list)
destroy(this.tabpage_list2)
end on

event selectionchanging;
IF prt_gu = "maiipjang" OR prt_gu = "maichuljang" OR prt_gu = "maiip_jip" OR prt_gu = "young_se" THEN 
	IF oldindex = 1 AND newindex = 2 THEN Return 1
END IF

end event

event selectionchanged;
IF newindex = 1 THEN
	Idw_tax_print = tab_list.tabpage_list.dw_tax_print
ELSEIF newindex = 2 THEN
	Idw_tax_print = tab_list.tabpage_list2.dw_tax_print2
END IF
end event

type tabpage_list from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4539
integer height = 1640
long backcolor = 32106727
string text = "매입장"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_tax_print dw_tax_print
rr_2 rr_2
end type

on tabpage_list.create
this.dw_tax_print=create dw_tax_print
this.rr_2=create rr_2
this.Control[]={this.dw_tax_print,&
this.rr_2}
end on

on tabpage_list.destroy
destroy(this.dw_tax_print)
destroy(this.rr_2)
end on

type dw_tax_print from datawindow within tabpage_list
integer x = 14
integer y = 20
integer width = 4517
integer height = 1604
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_ktxa012"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event retrieveend;Integer k

IF prt_gu ="young_se" THEN
	if rowcount > 0 then
		FOR k = 1 TO rowcount
			if this.GetItemString(k,"sflag") = '1' then
				this.SetItem(k,"firstflag",'D')
			else
				this.SetItem(k,"firstflag",'V')
				exit
			end if
		NEXT
	end if
END IF
end event

type rr_2 from roundrectangle within tabpage_list
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 12
integer width = 4535
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_list2 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4539
integer height = 1640
long backcolor = 32106727
string text = "        "
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_tax_print2 dw_tax_print2
end type

on tabpage_list2.create
this.rr_3=create rr_3
this.dw_tax_print2=create dw_tax_print2
this.Control[]={this.rr_3,&
this.dw_tax_print2}
end on

on tabpage_list2.destroy
destroy(this.rr_3)
destroy(this.dw_tax_print2)
end on

type rr_3 from roundrectangle within tabpage_list2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 12
integer width = 4535
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_tax_print2 from datawindow within tabpage_list2
integer x = 18
integer y = 24
integer width = 4507
integer height = 1596
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa0141"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_ktxa02
integer x = 3054
integer y = 264
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = " 회계일자순"
boolean focusrectangle = false
boolean disabledlook = true
end type

