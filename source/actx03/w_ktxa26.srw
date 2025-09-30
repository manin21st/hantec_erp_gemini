$PBExportHeader$w_ktxa26.srw
$PBExportComments$신용카드 매출전표 수취명세서 처리(2007년1기확정)
forward
global type w_ktxa26 from w_inherite
end type
type tab_vat from tab within w_ktxa26
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
type tab_vat from tab within w_ktxa26
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type
type dw_file from datawindow within w_ktxa26
end type
type dw_rtv13 from datawindow within w_ktxa26
end type
end forward

global type w_ktxa26 from w_inherite
integer height = 2428
string title = "신용카드매출전표 수취명세서"
tab_vat tab_vat
dw_file dw_file
dw_rtv13 dw_rtv13
end type
global w_ktxa26 w_ktxa26

type variables

String   s_jasacode,sRptPath,sApplyFlag, IsCommJasa
Integer  Ii_TotalCnt = 0
end variables

forward prototypes
public function integer wf_requiredchk (integer curr_row)
public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length)
public function integer wf_retrieve ()
public function integer wf_save_file (string sfdate, string stdate, string sjasa)
public function integer wf_create_160 (string sfdate, string stdate, string sjasa)
end prototypes

public function integer wf_requiredchk (integer curr_row);String sVatGisu,sdate,edate,jak_date,jacode,sBaseGbn,sProcGbn,sResid
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
	
jacode = tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"code")	
IF jacode ="" OR IsNull(jacode) THEN 
	f_messagechk(1,"자사코드")
	tab_vat.tabpage_process.dw_process.SetColumn("code")
	tab_vat.tabpage_process.dw_process.SetFocus()
  RETURN -1
END IF

sResid = tab_vat.tabpage_process.dw_process.GetItemString(curr_row,"resident")	
IF sResid ="" OR IsNull(sResid) THEN 
	f_messagechk(1,"법인(주민)번호")
	tab_vat.tabpage_process.dw_process.SetColumn("resident")
	tab_vat.tabpage_process.dw_process.SetFocus()
  RETURN -1
END IF
Return 1
end function

public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length);Int ll_space_length
String ls_space_length

ll_space_length = ll_total_lenght - ll_data_length
CHOOSE CASE ll_space_length
	Case 177
		ls_space_length =fill(' ',177)
	Case 151
		ls_space_length =fill(' ',151)
	Case 74
		ls_space_length =fill(' ',74)
	Case 73
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

public function integer wf_retrieve ();string sVatGisu,sDatefrom, sDateto,sCommJasa,sSano,sProcGbn,sJaSaCod,sCrtDate,sSettingGisu

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

/*신용카드매출전표등 수취명세서*/
Integer iRowCount,k,iCnt,iDivRow,i,lNull
String  sNull
String  sColId_CdNo[15] ={'card_no1',		'card_no2', 	'card_no3', 	'card_no4', 	'card_no5', &
							     'card_no6',		'card_no7', 	'card_no8', 	'card_no9', 	'card_no10',&
								  'card_no11',		'card_no12', 	'card_no13', 	'card_no14', 	'card_no15'} 
String  sColId_SaNo[15] ={'card_sano1',	'card_sano2', 	'card_sano3', 	'card_sano4', 	'card_sano5', &
							     'card_sano6',	'card_sano7', 	'card_sano8', 	'card_sano9', 	'card_sano10',&
								  'card_sano11',	'card_sano12', 'card_sano13', 'card_sano14', 'card_sano15'}	
String  sColId_Cnt[15] ={'card_cnt1',		'card_cnt2', 	'card_cnt3', 	'card_cnt4', 	'card_cnt5', &
							     'card_cnt6',		'card_cnt7', 	'card_cnt8', 	'card_cnt9', 	'card_cnt10',&
								  'card_cnt11',	'card_cnt12', 	'card_cnt13', 	'card_cnt14', 	'card_cnt15'}								  
String  sColId_Gon[15] ={'card_gon1',		'card_gon2', 	'card_gon3', 	'card_gon4', 	'card_gon5', &
							    'card_gon6',		'card_gon7', 	'card_gon8', 	'card_gon9', 	'card_gon10',&
								 'card_gon11',		'card_gon12', 	'card_gon13', 	'card_gon14', 	'card_gon15'}
String  sColId_Vat[15] ={'card_vat1',		'card_vat2', 	'card_vat3', 	'card_vat4', 	'card_vat5', &
							    'card_vat6',		'card_vat7', 	'card_vat8', 	'card_vat9', 	'card_vat10',&
								 'card_vat11',		'card_vat12', 	'card_vat13', 	'card_vat14', 	'card_vat15'}								 

SetNull(sNull)
SetNull(lNull)
if tab_vat.tabpage_print1.dw_print.Retrieve(sDateFrom,sDateTo,sCommJasa,sVatGisu) > 0 then
	tab_vat.tabpage_print2.dw_print2.SetFilter("")
	tab_vat.tabpage_print2.dw_print2.Filter()
	iRowCount = tab_vat.tabpage_print2.dw_print2.Retrieve(sDateFrom,sDateTo,sJasaCod,sVatGisu)
	if iRowCount > 0 then
		For k = 1 To 15
			if k > 15 then Exit
			
			if iRowCount < k then
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_CdNo[k], sNull)
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_SaNo[k], sNull)
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Cnt[k],  lNull)
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Gon[k],  lNull)
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Vat[k],  lNull)
			else
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_CdNo[k], tab_vat.tabpage_print2.dw_print2.GetItemString(k,"card_no1"))
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_SaNo[k], tab_vat.tabpage_print2.dw_print2.GetItemString(k,"card_sano1"))
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Cnt[k], tab_vat.tabpage_print2.dw_print2.GetItemNumber(k,"card_cnt1"))
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Gon[k],  tab_vat.tabpage_print2.dw_print2.GetItemNumber(k,"card_gon1"))
				tab_vat.tabpage_print1.dw_print.SetItem(1, sColId_Vat[k],  tab_vat.tabpage_print2.dw_print2.GetItemNumber(k,"card_vat1"))
			end if
			
		Next
		
		tab_vat.tabpage_print2.dw_print2.SetFilter("rownum > 15")
		tab_vat.tabpage_print2.dw_print2.Filter()
		
		iCnt = tab_vat.tabpage_print2.dw_print2.RowCount()
		iDivRow  = Mod(iCnt,28)
		FOR i = iDivRow TO 27
			tab_vat.tabpage_print2.dw_print2.InsertRow(0)
		NEXT
	end if
else
	tab_vat.tabpage_print2.dw_print2.Reset()
end if
tab_vat.tabpage_print1.dw_print.Object.DataWindow.Print.Preview = 'yes'
tab_vat.tabpage_print2.dw_print2.Object.DataWindow.Print.Preview = 'yes'

w_mdi_frame.sle_msg.text ="신용카드매출전표수취명세서 조회 완료!!!"	
SetPointer(Arrow!)

Return 1
end function

public function integer wf_save_file (string sfdate, string stdate, string sjasa);String   sSettingText,sMainDocCd = 'V164',sSpace,sDataGu,sDocCd
Integer  iSpacelength,lLoopCnt

w_mdi_frame.sle_msg.text = '신용카드매출전표수취명세서(HL) 작업테이블 저장 중...'
SetPointer(HourGlass!)

String  sText1,sText2,sSano,sSangHo,sOwner,sRedNo

lLoopCnt = 1

DECLARE HomeTax_160 CURSOR FOR
	select data_gu||vat_year||vat_gisu||rpt_gbn||sano,sangho,owner,red_no,vat_date
		from kfz_hometax_160
		where rpt_fr = :sFdate and rpt_to = :sTdate and jasa_cd = :sJasa ;
		
Open HomeTax_160;

sSettingText = ''
Do While True
	Fetch HomeTax_160 into :sText1,:sSangHo,:sOwner,:sRedNo,:sText2 ;
	if sqlca.sqlcode <> 0 then exit
	
	iSpacelength =LenA(sSangHo)
	sSangHo = sSangHo + WF_SETTING_SPACE(60,  iSpacelength)

	iSpacelength =LenA(sOwner)
	sOwner = sOwner + WF_SETTING_SPACE(30,  iSpacelength)
	
	iSpacelength =LenA(sRedNo)
	sRedNo = sRedNo + WF_SETTING_SPACE(13,  iSpacelength)
	
	sSpace = WF_SETTING_SPACE(11,  0)
	
	sSettingText = sText1 + sSangHo + sOwner + sRedNo + sText2 + sSpace
	
	if sSettingText <> '' and Not IsNull(sSettingText) then
		lLoopCnt = lLoopCnt + 1
		
		insert into kfz_card_work
			(rpt_fr,		rpt_to,		jasa_cd,			sort_no,		doc_cd,			text)
		values
			(:sFdate,	:sTdate,		:sJasa,			:lLoopCnt,	:sMainDocCd,	:sSettingText);
		if sqlca.sqlcode <> 0 then
			rollback;
			Close HomeTax_160;
			F_MessageChk(13,'[신용카드파일(HL)]')
			w_mdi_frame.sle_msg.text = ''
			SetPointer(Arrow!)
			Return -1
		end if
	end if		
Loop
Close HomeTax_160;

String sCardGu, sCardNo,sCustSano,sBuhoG,sBuhoV
Double   dGamt,dVamt
Long     lCnt

w_mdi_frame.sle_msg.text = '신용카드매출전표수취명세서-거래내역(DL) 작업테이블 저장 중...'
SetPointer(HourGlass!)

DECLARE HomeTax_160_1 CURSOR FOR
	//2008.01.22 - 2기확정 때 수정 - 수정사유:현금영수증은 화면에는 보이나 텍스트파일 데이터로 생성이 안되었음...nvl처리... select data_gu||vat_year||vat_gisu||rpt_gbn||sano, cardgu, card_no, cust_sano, datacnt,	gamt_buho, gamt, vamt_buho, vamt
     select data_gu||vat_year||vat_gisu||rpt_gbn||sano, cardgu, nvl(card_no,' '), nvl(cust_sano,' '), datacnt,	gamt_buho, gamt, vamt_buho, vamt
		from kfz_hometax_160_1
		where rpt_fr = :sFdate and rpt_to = :sTdate and jasa_cd = :sJasa
		order by serno;
		
Open HomeTax_160_1;

sSettingText = ''

Do While True
	Fetch HomeTax_160_1 into :sText1, :sCardGu,  :sCardNo, :sCustSano, :lCnt,	:sBuhoG, :dGamt, :sBuhoV, :dVamt ;
	if sqlca.sqlcode <> 0 then exit
	
	iSpacelength =LenA(sCardNo)
	sCardNo = sCardNo + WF_SETTING_SPACE(20,  iSpacelength)

	iSpacelength =LenA(sCustSano)
	sCustSano = sCustSano + WF_SETTING_SPACE(10,  iSpacelength)
	
	sSpace = WF_SETTING_SPACE(54,  0)
	
	sSettingText = sText1 + sCardGu + sCardNo + sCustSano + String(lCnt,'000000000') + sBuhoG + &
						String(dGamt,'0000000000000') + sBuhoV + String(dVamt,'0000000000000') + sSpace
	
	if sSettingText <> '' and Not IsNull(sSettingText) then
		lLoopCnt = lLoopCnt + 1
	
		insert into kfz_card_work
			(rpt_fr,		rpt_to,		jasa_cd,			sort_no,		doc_cd,			text)
		values
			(:sFdate,	:sTdate,		:sJasa,			:lLoopCnt,	:sMainDocCd,	:sSettingText);
		if sqlca.sqlcode <> 0 then
			rollback;
			Close HomeTax_160_1;
			F_MessageChk(13,'[신용카드파일(DL)]')
			w_mdi_frame.sle_msg.text = ''
			SetPointer(Arrow!)
			Return -1
		end if
	end if		
Loop
Close HomeTax_160_1;

w_mdi_frame.sle_msg.text = '신용카드매출전표수취명세서(TL) 작업테이블 저장 중...'
SetPointer(HourGlass!)

select data_gu||vat_year||vat_gisu||rpt_gbn||sano||
		 ltrim(to_char(datacnt, '0000000'))||
		 ltrim(to_char(cnt_h,   '000000000'))||
		 gamt_buho||ltrim(to_char(gamt_h, '000000000000000'))||
		 vamt_buho||ltrim(to_char(vamt_h,  '000000000000000'))
	into :sSettingText
	from kfz_hometax_160_2
	where rpt_fr = :sFdate and rpt_to = :sTdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	sSettingText = ''
end if

if sSettingText <> '' and Not IsNull(sSettingText) then
	lLoopCnt = lLoopCnt + 1
	
	sSpace = WF_SETTING_SPACE(74,  0)
	
	insert into kfz_card_work
		(rpt_fr,		rpt_to,		jasa_cd,			sort_no,		doc_cd,			text)
	values
		(:sFdate,	:sTdate,		:sJasa,			:lLoopCnt,	:sMainDocCd,	:sSettingText||:sSpace);
	if sqlca.sqlcode <> 0 then
		rollback;
		F_MessageChk(13,'[신용카드파일(TL)]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if	

Commit;

Return 1
end function

public function integer wf_create_160 (string sfdate, string stdate, string sjasa);String   sDocCd = 'V164',sVatGisu,sRpt_Sano,sRpt_Sangho,sRpt_Owner,sRpt_Resid,sRpt_Year,sRpt_Gisu,&
			sRpt_Gbn,sCrtDate,sRcvGbn,sCardNo,sSano,sBuHoG,sBuhoV,sYmFr,sYmTo,sCdGbn
Double   dGamtH,dVamtH,dCntH,dGamt_Card,dVamt_Card,dCnt_Card,dGamt_Cash,dVamt_Cash,dCnt_Cash,dGonamt,dVatAmt, &
		   dGamt_Drv, dVamt_Drv, dCnt_Drv , dGamt_Saup, dVamt_Saup, dCnt_Saup
Integer  iRowCount,k, iCnt

tab_vat.tabpage_process.dw_process.AcceptText()
sVatGisu  = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"vatgisu") 
sCrtDate = Trim(tab_vat.tabpage_process.dw_process.GetItemstring(tab_vat.tabpage_process.dw_process.getrow(),"kfz_vat_title_cdate"))

sYmFr     = Left(sfdate,6)
sYmTo     = Left(stdate,6)

sRpt_Year = Left(sfdate,4)						/*귀속년도*/
if Mid(sfdate,5,2) <='06' then					/*기수*/
	sRpt_Gisu = '1'	
else
	sRpt_Gisu = '2'	
end if

Choose Case Mid(stdate,5,2)					/*반기내월 : 월의 순차번호, 예정신고'3',확정신고'6'*/
	Case '01','07'
		sRpt_Gbn = '1'
	Case '02','08'
		sRpt_Gbn = '2'
	Case '03','09'
		sRpt_Gbn = '3'	
	Case '04','10'
		sRpt_Gbn = '4'		
	Case '05','11'
		sRpt_Gbn = '5'	
	Case '06','12'
		sRpt_Gbn = '6'		
End Choose

tab_vat.tabpage_print1.dw_print.AcceptText()
iRowCount = tab_vat.tabpage_print1.dw_print.RowCount()
if iRowCount <=0 then Return 1
sRpt_SangHo =  tab_vat.tabpage_process.dw_process.GetItemString(1,"kfz_vat_title_sangho")
sRpt_Sano   = tab_vat.tabpage_process.dw_process.GetItemString(1,"kfz_vat_title_saupno")
sRpt_Owner  =  tab_vat.tabpage_process.dw_process.GetItemString(1,"kfz_vat_title_sname")
sRpt_Resid  =  tab_vat.tabpage_process.dw_process.GetItemString(1,"resident")

insert into kfz_hometax_160
	(rpt_fr,		rpt_to,				jasa_cd,		data_gu,		doc_cd,		vat_year,	vat_gisu,	rpt_gbn,
	 sano,		sangho,				owner,		red_no,		vat_date,	bigo)
values
	(:sFdate,		:sTdate,			:sJasa,		'HL',			:sDocCd,		:sRpt_Year,	:sRpt_Gisu,	:sRpt_Gbn,
	 :sRpt_Sano,	:sRpt_Sangho,	:sRpt_Owner,:sRpt_Resid,:sCrtDate,	null) ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[신용카드매출전표수취명세서(HL)]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

dCntH      = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"hap_cnt")
dGamtH     = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"hap_gon")
dVamtH     = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"hap_vat")
if IsNull(dCntH) then dCntH = 0
if IsNull(dGamtH) then dGamtH = 0
if IsNull(dVamtH) then dVamtH = 0

dCnt_Card  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cmaisu")
dGamt_Card = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cgon_amt")
dVamt_Card = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cvat_amt")
if IsNull(dCnt_Card) then dCnt_Card = 0
if IsNull(dGamt_Card) then dGamt_Card = 0
if IsNull(dVamt_Card) then dVamt_Card = 0

dCnt_Cash  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cash_cnt")
dGamt_Cash = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cash_gon")
dVamt_Cash = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"cash_vat")
if IsNull(dCnt_Cash) then dCnt_Cash = 0
if IsNull(dGamt_Cash) then dGamt_Cash = 0
if IsNull(dVamt_Cash) then dVamt_Cash = 0

dCnt_Drv   = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"dmaisu")
dGamt_Drv  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"dgon_amt")
dVamt_Drv  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"dvat_amt")
if IsNull(dCnt_Drv) then dCnt_Drv = 0
if IsNull(dGamt_Drv) then dGamt_Drv = 0
if IsNull(dVamt_Drv) then dVamt_Drv = 0

dCnt_Saup   = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"smaisu")
dGamt_Saup  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"sgon_amt")
dVamt_Saup  = tab_vat.tabpage_print1.dw_print.GetItemNumber(iRowCount,"svat_amt")
if IsNull(dCnt_Saup) then dCnt_Saup = 0
if IsNull(dGamt_Saup) then dGamt_Saup = 0
if IsNull(dVamt_Saup) then dVamt_Saup = 0
/*신용카드(DR)-거래내역*/
sRcvGbn = '1'
if dCntH <> 0 or dGamtH <> 0 or dVamtH <> 0 then
	dw_rtv13.DataObject = 'dw_ktxa26_rtv'
	dw_rtv13.SetTransObject(Sqlca)
	iRowCount = dw_rtv13.Retrieve(sFdate,sTdate,sJasa,sVatGisu,'16')
	if iRowCount > 0 then
		For k = 1 To iRowCount
			sCdGbn  = trim(dw_rtv13.GetItemString(k,"card_gbn1"))
			sCardNo = trim(dw_rtv13.GetItemString(k,"card_no1"))
			sSano   = trim(dw_rtv13.GetItemString(k,"card_sano1"))
			iCnt    = dw_rtv13.GetItemNumber(k,"card_cnt1")
			dGonAmt = dw_rtv13.GetItemNumber(k,"card_gon1")
			dVatAmt = dw_rtv13.GetItemNumber(k,"card_vat1")
			
			if IsNull(iCnt) then iCnt = 0
			if IsNull(dGonAmt) then dGonAmt = 0
			if IsNull(dVatAmt) then dVatAmt = 0
			
			if dGonAmt >=0 then
				sBuhoG = ' '
			else
				sBuhoG = '-'
			end if
			if dVatAmt >=0 then
				sBuhoV = ' '
			else
				sBuhoV = '-'
			end if
			
			insert into kfz_hometax_160_1
				( rpt_fr,		rpt_to,			jasa_cd,		data_gu,		doc_cd,		vat_year,	vat_gisu,	rpt_gbn, 
				  sano,			cardgu,			serno,		card_no,		cust_sano,	datacnt,		gamt_buho,	gamt,			
				  vamt_buho,	vamt)
			values
				(:sFdate,		:sTdate,			:sJasa,		'DL',			:sDocCd,		:sRpt_Year,	:sRpt_Gisu,	:sRpt_Gbn,
				 :sRpt_Sano,	:sCdGbn,			:k,			:sCardNo,	:sSano,		:iCnt,		:sBuhoG,		ABS(:dGonAmt), /*2008.01.29 추가 - 현금 영수증 관련 분만 발생된 경우 처리*/
				 :sBuhoV,		ABS(:dVatAmt)) ;
			if sqlca.sqlcode <> 0 then
				Rollback;
				F_MessageChk(13,'[신용카드매출전표수취명세서(DL)]')
				w_mdi_frame.sle_msg.text = ''
				SetPointer(Arrow!)
				Return -1
			end if	
		Next		
	end if
end if
//사업용카드
if dCnt_Saup <> 0 or dGamt_Saup <> 0 or dVamt_Saup <> 0 then		
	sCdGbn  ='4'
	sCardNo = ''
	sSano   = ''
	
	if dGamt_Saup >=0 then
		sBuhoG = ' '
	else
		sBuhoG = '-'
	end if
	if dVamt_Saup >=0 then
		sBuhoV = ' '
	else
		sBuhoV = '-'
	end if
	
	k = k + 1
	
	insert into kfz_hometax_160_1
		( rpt_fr,		rpt_to,			jasa_cd,		data_gu,		doc_cd,		vat_year,			vat_gisu,			rpt_gbn, 
		  sano,			cardgu,		serno,		card_no,		cust_sano,	datacnt,			gamt_buho,		gamt,			
		  vamt_buho,	vamt)
	values
		(:sFdate,		:sTdate,			:sJasa,		'DL',			:sDocCd,		:sRpt_Year,		:sRpt_Gisu,	:sRpt_Gbn,
		 :sRpt_Sano,	:sCdGbn,		:k,				:sCardNo,	:sSano,		:dCnt_Saup,		:sBuhoG,		ABS(:dGamt_Saup),  
		 :sBuhoV,		ABS(:dVamt_Saup)) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[신용카드매출전표수취명세서(DL)]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if		
end if

/*신용카드(TR)-합계*/
if dCntH <> 0 or dGamtH <> 0 or dVamtH <> 0 then
	if dGamtH >=0 then
		sBuhoG = ' '
	else
		sBuhoG = '-'
	end if
	if dVamtH >=0 then
		sBuhoV = ' '
	else
		sBuhoV = '-'
	end if

	insert into kfz_hometax_160_2
		( rpt_fr,		rpt_to,			jasa_cd,		data_gu,		doc_cd,		vat_year,	vat_gisu,	rpt_gbn, 
		  sano,			datacnt,			cnt_h,		gamt_buho,	gamt_h,		vamt_buho,	vamt_h )
	values
		(:sFdate,		:sTdate,			:sJasa,		'TL',			:sDocCd,		:sRpt_Year,	:sRpt_Gisu,	:sRpt_Gbn,
		 :sRpt_Sano,	:iRowCount,		:dCntH,		:sBuhoG,		:dGamtH,		:sBuhoV,		:dVamtH) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[신용카드매출전표수취명세서(TL)]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if
Commit;

Return 1
end function

event open;call super::open;String mm,dd,sJasa,sSano,sName,sJasaName,sUptae,sUpjong,sAddr,sStart,sEnd,sVatGisu,sPath,sResid
		 
tab_vat.tabpage_process.dw_process.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)
dw_rtv13.SetTransObject(SQLCA)
dw_file.SetTransObject(SQLCA)

/*저장위치*/
select dataname	into :sPath	from syscnfg where sysgu = 'A' and serial = 15 and lineno = '2';
if sPath = '' or IsNull(sPath) then sPath = 'c:\'

SELECT "VNDMST"."CVCOD",   "VNDMST"."SANO",   "VNDMST"."OWNAM",   
		 "VNDMST"."CVNAS",   "VNDMST"."UPTAE",  "VNDMST"."JONGK",
		 NVL("VNDMST"."ADDR1",' ') || NVL("VNDMST"."ADDR2",' ') , "VNDMST"."RESIDENT" 
	INTO :sJasa,   			:sSano,   			 :sName,   
        :sJasaName,   		:sUptae,   			 :sUpjong,   
        :sAddr,				:sResid  
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
tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"resident",				sResid)

tab_vat.tabpage_process.dw_process.SetItem(tab_vat.tabpage_process.dw_process.GetRow(),"spath",   sPath)

tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_sdate")
tab_vat.tabpage_process.dw_process.SetFocus()

tab_vat.SelectedTab = 1
end event

on w_ktxa26.create
int iCurrent
call super::create
this.tab_vat=create tab_vat
this.dw_file=create dw_file
this.dw_rtv13=create dw_rtv13
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_vat
this.Control[iCurrent+2]=this.dw_file
this.Control[iCurrent+3]=this.dw_rtv13
end on

on w_ktxa26.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_vat)
destroy(this.dw_file)
destroy(this.dw_rtv13)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa26
boolean visible = false
integer x = 293
integer y = 2248
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa26
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa26
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa26
boolean visible = false
integer x = 2885
integer y = 2528
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa26
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa26
integer x = 4416
integer y = 20
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa26
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa26
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

type p_inq from w_inherite`p_inq within w_ktxa26
boolean visible = false
integer x = 3077
integer y = 2528
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa26
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa26
integer x = 4069
integer y = 20
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;String  ls_sdate, ls_edate,  ls_date, ls_saupno,ls_sanho,&
		  ls_uptae, ls_upjong, ls_addr, sPath,sSaveFile,sBaseGbn,    sProcGbn
Boolean function_chk

tab_vat.tabpage_process.dw_process.AcceptText()

IF wf_requiredchk(tab_vat.tabpage_process.dw_process.GetRow()) = -1 THEN RETURN 

sBaseGbn       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"gubun")
ls_sdate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_sdate"))
ls_edate       = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_edate"))
ls_date        = Trim(tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"kfz_vat_title_cdate"))
sProcGbn       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"procgbn")

IF ls_date ="" OR IsNull(ls_date) THEN
	F_MessageChk(1,'[작성일자]')
	tab_vat.tabpage_process.dw_process.SetColumn("kfz_vat_title_cdate")
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

if Wf_Retrieve() = -1 then return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="신용카드매출전표 수취명세서 관련 테이블 초기화 중......"
/*신용카드(HR)*/
delete from kfz_hometax_160 	where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasa_cd = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[신용카드매출전표수취명세서(HL)]')
	Return -1
end if

delete from kfz_hometax_160_1 	where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasa_cd = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[신용카드매출전표수취명세서(DL)]')
	Return -1
end if

delete from kfz_hometax_160_2 	where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasa_cd = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[신용카드매출전표수취명세서(TL)]')
	Return -1
end if
delete from kfz_card_work 	where rpt_fr = :ls_sdate and rpt_to = :ls_edate and jasa_cd = :IsCommJasa ;
commit;

w_mdi_frame.sle_msg.text ="신용카드매출전표 수취명세서 자료 저장 중......"
IF Wf_Create_160(ls_sdate,ls_edate,IsCommJasa) = -1 THEN RETURN

w_mdi_frame.sle_msg.text ="신용카드매출전표 수취명세서 파일 생성 중......"
IF Wf_Save_File(ls_sdate,ls_edate,IsCommJasa) = -1 THEN RETURN

COMMIT;

/*화일 저장 위치*/
String sFileName
sPath       = tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"spath")
sFileName	= tab_vat.tabpage_process.dw_process.GetItemString(tab_vat.tabpage_process.dw_process.GetRow(),"savefilename")

sSaveFile   = sPath + sFileName

dw_file.Retrieve(ls_sdate,ls_edate,IsCommJasa)

dw_file.SaveAs(sSaveFile, TEXT!, FALSE)

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="신용카드매출전표 수취명세서 파일 생성 완료"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_ktxa26
boolean visible = false
integer x = 3630
integer y = 2740
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa26
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
boolean visible = false
integer x = 2930
integer y = 2740
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa26
boolean visible = false
integer x = 2080
integer y = 3028
end type

type cb_del from w_inherite`cb_del within w_ktxa26
boolean visible = false
integer x = 2446
integer y = 3084
end type

type cb_inq from w_inherite`cb_inq within w_ktxa26
boolean visible = false
integer x = 2802
integer y = 3084
end type

type cb_print from w_inherite`cb_print within w_ktxa26
boolean visible = false
integer x = 3282
integer y = 2740
end type

type st_1 from w_inherite`st_1 within w_ktxa26
integer y = 2112
end type

type cb_can from w_inherite`cb_can within w_ktxa26
boolean visible = false
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa26
boolean visible = false
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa26
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa26
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa26
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa26
boolean visible = false
integer x = 2075
integer y = 2676
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa26
boolean visible = false
integer x = 2889
integer y = 2692
integer width = 1083
integer height = 180
end type

type tab_vat from tab within w_ktxa26
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
		if Wf_Retrieve() = -1 then 
			p_print.Enabled = False
		else
			p_print.Enabled = True
			
			tab_vat.tabpage_print1.dw_print.object.datawindow.print.preview = 'yes'
			tab_vat.tabpage_print2.dw_print2.object.datawindow.print.preview = 'yes'
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
string dataobject = "dw_ktxa251"
boolean border = false
end type

event itemchanged;String ls_saupno,ls_sanho, ls_name, ls_uptae, ls_upjong, ls_addr1,ls_addr2,&
		 sVatGisu, sStart,   sEnd,    sProcGbn, sCommJasa, sGbn,	   snull, ls_resid

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
	
  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS",		"VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2",		"VNDMST"."RESIDENT"  
   INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,		:ls_uptae,   
        :ls_upjong        ,:ls_addr1       ,:ls_addr2,				:ls_resid
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
	this.SetItem(this.GetRow(),"resident",				ls_resid)
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
		this.SetItem(this.GetRow(),"resident",				  snull)
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
			this.SetItem(this.GetRow(),"resident",				  snull)
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
				this.SetItem(this.GetRow(),"resident",				  snull)
				Return 1
			END IF
		END IF		
		
		SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS",	"VNDMST"."UPTAE",   
				 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2",	"VNDMST"."RESIDENT"  
		INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,	:ls_uptae,   
			  :ls_upjong        ,:ls_addr1       ,:ls_addr2,			:ls_resid
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
		this.SetItem(this.GetRow(),"resident",				  ls_resid)
		
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
string text = "신용카드매출전표수취명세서(갑)"
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
string dataobject = "dw_ktxa26p1"
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
string text = "신용카드매출전표수취명세서(을)"
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
string dataobject = "dw_ktxa26p2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_file from datawindow within w_ktxa26
boolean visible = false
integer x = 274
integer y = 2644
integer width = 923
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "파일저장"
string dataobject = "dw_ktxa25_file"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_rtv13 from datawindow within w_ktxa26
boolean visible = false
integer x = 283
integer y = 2508
integer width = 914
integer height = 128
boolean bringtotop = true
boolean titlebar = true
string title = "카드내역 조회"
string dataobject = "dw_ktxa26_rtv"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

