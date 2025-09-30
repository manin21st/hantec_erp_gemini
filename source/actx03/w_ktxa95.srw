$PBExportHeader$w_ktxa95.srw
$PBExportComments$부가세 전자신고(2015년 2월 이후)
forward
global type w_ktxa95 from w_standard_print
end type
type tab_htax from tab within w_ktxa95
end type
type tabpage_101 from userobject within tab_htax
end type
type rr_1 from roundrectangle within tabpage_101
end type
type dw_101 from datawindow within tabpage_101
end type
type tabpage_101 from userobject within tab_htax
rr_1 rr_1
dw_101 dw_101
end type
type tabpage_101_1 from userobject within tab_htax
end type
type rr_2 from roundrectangle within tabpage_101_1
end type
type dw_101_1 from datawindow within tabpage_101_1
end type
type tabpage_101_1 from userobject within tab_htax
rr_2 rr_2
dw_101_1 dw_101_1
end type
type tabpage_115 from userobject within tab_htax
end type
type rr_4 from roundrectangle within tabpage_115
end type
type dw_115 from datawindow within tabpage_115
end type
type tabpage_115 from userobject within tab_htax
rr_4 rr_4
dw_115 dw_115
end type
type tabpage_150 from userobject within tab_htax
end type
type rr_7 from roundrectangle within tabpage_150
end type
type dw_150 from datawindow within tabpage_150
end type
type tabpage_150 from userobject within tab_htax
rr_7 rr_7
dw_150 dw_150
end type
type tabpage_106 from userobject within tab_htax
end type
type rr_3 from roundrectangle within tabpage_106
end type
type dw_106 from datawindow within tabpage_106
end type
type tabpage_106 from userobject within tab_htax
rr_3 rr_3
dw_106 dw_106
end type
type tabpage_108 from userobject within tab_htax
end type
type rr_5 from roundrectangle within tabpage_108
end type
type dw_108 from datawindow within tabpage_108
end type
type tabpage_108 from userobject within tab_htax
rr_5 rr_5
dw_108 dw_108
end type
type tabpage_120 from userobject within tab_htax
end type
type rr_9 from roundrectangle within tabpage_120
end type
type dw_120 from datawindow within tabpage_120
end type
type tabpage_120 from userobject within tab_htax
rr_9 rr_9
dw_120 dw_120
end type
type tabpage_112 from userobject within tab_htax
end type
type rr_8 from roundrectangle within tabpage_112
end type
type dw_112 from datawindow within tabpage_112
end type
type tabpage_112 from userobject within tab_htax
rr_8 rr_8
dw_112 dw_112
end type
type tabpage_135 from userobject within tab_htax
end type
type rr_6 from roundrectangle within tabpage_135
end type
type dw_135 from datawindow within tabpage_135
end type
type tabpage_135 from userobject within tab_htax
rr_6 rr_6
dw_135 dw_135
end type
type tabpage_117 from userobject within tab_htax
end type
type rr_13 from roundrectangle within tabpage_117
end type
type dw_117 from datawindow within tabpage_117
end type
type tabpage_117 from userobject within tab_htax
rr_13 rr_13
dw_117 dw_117
end type
type tabpage_177 from userobject within tab_htax
end type
type rr_12 from roundrectangle within tabpage_177
end type
type dw_177 from datawindow within tabpage_177
end type
type tabpage_177 from userobject within tab_htax
rr_12 rr_12
dw_177 dw_177
end type
type tab_htax from tab within w_ktxa95
tabpage_101 tabpage_101
tabpage_101_1 tabpage_101_1
tabpage_115 tabpage_115
tabpage_150 tabpage_150
tabpage_106 tabpage_106
tabpage_108 tabpage_108
tabpage_120 tabpage_120
tabpage_112 tabpage_112
tabpage_135 tabpage_135
tabpage_117 tabpage_117
tabpage_177 tabpage_177
end type
type p_create from p_retrieve within w_ktxa95
end type
type dw_text from datawindow within w_ktxa95
end type
type dw_rtv12 from datawindow within w_ktxa95
end type
type dw_rtv13 from datawindow within w_ktxa95
end type
type dw_rtv14 from datawindow within w_ktxa95
end type
end forward

global type w_ktxa95 from w_standard_print
integer width = 4690
integer height = 2400
string title = "부가세 전자신고"
tab_htax tab_htax
p_create p_create
dw_text dw_text
dw_rtv12 dw_rtv12
dw_rtv13 dw_rtv13
dw_rtv14 dw_rtv14
end type
global w_ktxa95 w_ktxa95

type variables
String  LsHomeTaxTag01,LsHomeTaxTag02,LsHomeTaxTag03,LsHomeTaxTag04,LsHomeTaxTag05,LsHomeTaxTag06,LsHomeTaxTag07,LsHomeTaxTag08
String  LsHomeTaxTag09
String  LsHomeTaxTag0A 		// 2009년 2기 확정 추가-2010.01
String  LsHomeTaxTag0B
String  LsHomeTaxTag0C
String  LsHomeTaxTag0D
String  LsHomeTaxTag0E		//영세율매출명세서
Integer LiBsImCnt = 0
end variables

forward prototypes
protected function integer wf_create_115 (string sfdate, string stdate, string sjasa)
public function string wf_setting_space (integer ll_total_lenght, integer ll_data_length)
protected function integer wf_create_101_1 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_101_2 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_file (string sfdate, string stdate, string sjasa, string spath)
public function integer wf_retrieve ()
protected function integer wf_create_108 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_101 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_150 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_120 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_153 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_112 (string sfdate, string stdate, string sjasa)
public subroutine wf_retrieve_112 ()
public function string wf_amtconv (decimal decamt)
public function string wf_setting_zero (integer ll_total_lenght, integer ll_data_length)
protected function integer wf_create_106 (string sfdate, string stdate, string sjasa, string srptcd, string srptdsc)
public function double wf_get_jong_amt (string sfrom, string sto, string sjasacod)
protected function integer wf_create_117 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_177 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_101_3 (string sfdate, string stdate, string sjasa)
protected function integer wf_create_101_4 (string sfdate, string stdate, string sjasa)
end prototypes

protected function integer wf_create_115 (string sfdate, string stdate, string sjasa);String   sDocCd = 'I104500',sSaupNo,sAddr
Double   dMaiChulSegum_g,dMaiChulSegum_v,dMaiChulYong_g,dMaiChulYong_v,dMaiipSegum_g,&
			dMaiipSegum_v,dMaiipYj_g,dMaiipYj_v,dTaxAdd,dTaxSub,dResult,dBanOut,dBanIn
Integer  iRowCount,k

delete from kfz_hometax_115
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[사업장별 과세표준]')
	Return -1
else
	delete from kfz_hometax_115_1
		where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
end if

tab_htax.tabpage_115.dw_115.AcceptText()
iRowCount = tab_htax.tabpage_115.dw_115.RowCount()
if iRowCount <=0 then Return 1

/*과세표준 세부내역*/
For k= 1 To iRowcount
	sSaupNo          = tab_htax.tabpage_115.dw_115.GetItemString(k,"sano")
	sAddr            = tab_htax.tabpage_115.dw_115.GetItemString(k,"addr1")
	
	dMaiChulSegum_g  = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maichul_tax_segum")
	dMaiChulSegum_v  = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maichul_tax_vat")
	dMaiChulYong_g   = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maichul_yong_gita")
	dMaiChulYong_v   = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maichul_yong_vat")
	dMaiipSegum_g    = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maiip_tax_segum")
	dMaiipSegum_v    = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maiip_tax_vat")
	dMaiipYj_g       = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maiip_yj_g")
	dMaiipYj_v       = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maiip_yj_v")
	dTaxAdd          = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"taxadd")
	dTaxSub          = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"maiip_tax_yong_vat")
	dResult          = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"calc")
	dBanOut          = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"tax_banout")
	dBanIn           = tab_htax.tabpage_115.dw_115.GetItemNumber(k,"tax_banin")
	
	if IsNull(dMaiChulSegum_g) then dMaiChulSegum_g = 0
	if IsNull(dMaiChulSegum_v) then dMaiChulSegum_v = 0
	if IsNull(dMaiChulYong_g) then dMaiChulYong_g = 0
	if IsNull(dMaiChulYong_v) then dMaiChulYong_v = 0
	if IsNull(dMaiipSegum_g) then dMaiipSegum_g = 0
	if IsNull(dMaiipSegum_v) then dMaiipSegum_v = 0
	if IsNull(dMaiipYj_g) then dMaiipYj_g = 0
	if IsNull(dMaiipYj_v) then dMaiipYj_v = 0
	if IsNull(dTaxAdd) then dTaxAdd = 0
	if IsNull(dTaxSub) then dTaxSub = 0
	if IsNull(dResult) then dResult = 0
	if IsNull(dBanOut) then dBanOut = 0
	if IsNull(dBanIn) then dBanIn = 0
	
	insert into kfz_hometax_115_1
		(rpt_fr,						rpt_to,				jasa_cd,				data_gu,				
		 doc_cd,						saupno,				addr,
		 taxout_g,					taxout_v,			taxyong_g,			taxyong_v,		
		 taxin_g,					taxin_v,				taxyj_g,				taxyj_v,			
		 tax_add,					tax_sub,				result_v,			banout,					banin)
	values
		(:sFdate,					:sTdate,				:sJasa,				'18',				
		 :sDocCd,					:sSaupNo,			:sAddr,
		 :dMaiChulSegum_g,		:dMaiChulSegum_v,	:dMaiChulYong_g,	:dMaiChulYong_v,	
		 :dMaiipSegum_g,			:dMaiipSegum_v,	:dMaiipYj_g,		:dMaiipYj_v,
		 :dTaxAdd,					:dTaxSub,			:dResult,			:dBanOut,				:dBanIn) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[사업장별 과세표준-세부내역]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
Next

/*과세표준 집계*/
dMaiChulSegum_g  = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maichul_tax_segum_hap")
dMaiChulSegum_v  = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maichul_tax_vat_hap")
dMaiChulYong_g   = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maichul_yong_gita_hap")
dMaiChulYong_v   = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maichul_yong_vat_hap")
dMaiipSegum_g    = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maiip_tax_segum_hap")
dMaiipSegum_v    = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maiip_tax_vat_hap")
dMaiipYj_g       = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maiip_yj_g_hap")
dMaiipYj_v       = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maiip_yj_v_hap")
dTaxAdd          = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"taxadd_hap")
dTaxSub          = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"maiip_tax_yong_vat_hap")
dResult          = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"calc_hap")
dBanOut          = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"tax_banout_hap")
dBanIn           = tab_htax.tabpage_115.dw_115.GetItemNumber(iRowCount,"tax_banin_hap")
	
if IsNull(dMaiChulSegum_g) then dMaiChulSegum_g = 0
if IsNull(dMaiChulSegum_v) then dMaiChulSegum_v = 0
if IsNull(dMaiChulYong_g) then dMaiChulYong_g = 0
if IsNull(dMaiChulYong_v) then dMaiChulYong_v = 0
if IsNull(dMaiipSegum_g) then dMaiipSegum_g = 0
if IsNull(dMaiipSegum_v) then dMaiipSegum_v = 0
if IsNull(dMaiipYj_g) then dMaiipYj_g = 0
if IsNull(dMaiipYj_v) then dMaiipYj_v = 0
if IsNull(dTaxAdd) then dTaxAdd = 0
if IsNull(dTaxSub) then dTaxSub = 0
if IsNull(dResult) then dResult = 0
if IsNull(dBanOut) then dBanOut = 0
if IsNull(dBanIn) then dBanIn = 0
	
insert into kfz_hometax_115
	(rpt_fr,						rpt_to,				jasa_cd,				data_gu,					doc_cd,	
	 taxout_g_hap,				taxout_v_hap,		taxyong_g_hap,		taxyong_v_hap,		
	 taxin_g_hap,				taxin_v_hap,		taxyj_g_hap,		taxyj_v_hap,			
	 tax_add_hap,				tax_sub_hap,		result_hap,			banout_hap,				banin_hap)
values
	(:sFdate,					:sTdate,				:sJasa,				'17',					 	:sDocCd,					
	 :dMaiChulSegum_g,		:dMaiChulSegum_v,	:dMaiChulYong_g,	:dMaiChulYong_v,	
	 :dMaiipSegum_g,			:dMaiipSegum_v,	:dMaiipYj_g,		:dMaiipYj_v,
	 :dTaxAdd,					:dTaxSub,			:dResult,			:dBanOut,				:dBanIn) ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[사업장별 과세표준-집계]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

Commit;

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
	Case 120
		ls_space_length =fill(' ',120)
	//2011년 1기 확정 신고 변경분(2011.07.04)
	Case 88
		ls_space_length =fill(' ',88)
	//
	Case 86
		ls_space_length =fill(' ',86)
	Case 73
		ls_space_length ='                                                                         '
	CASE 72
		ls_space_length ='                                                                        '	
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

protected function integer wf_create_101_1 (string sfdate, string stdate, string sjasa);String 	sDocCd = 'I103200',sHgbn,sTaxGbn,sCanGbn,sJoGiGbn, vCloseDt, sBankCd, sDepotNo, sBankName

dw_ip.AcceptText()

sTaxGbn  = dw_ip.GetItemString(dw_ip.GetRow(),"rpt_gubun") 		/*일반과세자구분 추가 2005.04.16*/
sJoGiGbn = dw_ip.GetItemString(dw_ip.GetRow(),"jogi") 			/*10:일반환급,20:영세율환급,30:시설투자환급*/

delete from kfz_new_hometax_101_1
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부가세신고서-일반]')
	Return -1
end if

Double dAmt3, dAmt4,dAmt_da, dAmt_aset, dAmt_na

tab_htax.tabpage_101.dw_101.AcceptText()
dAmt3     = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_segum")
dAmt4     = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_gita")
dAmt_aset = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gojeng")
dAmt_na   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_vat_subhap")
if IsNull(dAmt_na) then dAmt_na = 0
dAmt_da   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_vat_hap") - dAmt_na
if IsNull(dAmt_da) then dAmt_da = 0

if IsNull(dAmt3)   then dAmt3 = 0
if IsNull(dAmt4)   then dAmt4 = 0
if IsNull(dAmt_aset) then dAmt_aset = 0

if dAmt_da < 0 then									/*환급구분*/	
	sHgbn = 	sJoGiGbn
	
	if sJoGiGbn = '20' or sJoGiGbn = '42' then
		sCanGbn = '0'	
	else
		if ((dAmt3 <> 0 or dAmt4 <> 0) or (dAmt3 + dAmt4 = 0 and dAmt_aset <> 0)) and ( sJoGiGbn = '10' or  sJoGiGbn = '41')  then
			sCanGbn = '1'	
		else
			sCanGbn = '0'	
		end if
	end if
else
	sHgbn = 	sJoGiGbn
	sCanGbn = '0'	
end if

tab_htax.tabpage_101_1.dw_101_1.AcceptText()
Double dAmt1_g, dAmt1_v, dAmt2_g,dAmt2_v, dAmt3_g, dAmt3_v, dAmt4_g,dAmt4_v,dAmt5_g, dAmt6_g, dAmt7_g,dAmt7_v,dAmt8_v,dAmt9_g,dAmt9_ga

dAmt1_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_segum")
dAmt1_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_vat")
dAmt2_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_maiip_bal_gong")
dAmt2_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_maiip_bal_vat")
dAmt3_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_card_gong")
dAmt3_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_card_vat")
dAmt4_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_gita")
dAmt4_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_tax_gita_vat")
dAmt5_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_segum")
dAmt6_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_gita")
dAmt7_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_remain")
dAmt7_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_remain_vat")
dAmt8_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"daeson_tax")
dAmt9_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_hap")
dAmt9_ga   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_vat_hap")
if IsNull(dAmt1_g) then dAmt1_g = 0
if IsNull(dAmt1_v) then dAmt1_v = 0
if IsNull(dAmt2_g) then dAmt2_g = 0
if IsNull(dAmt2_v) then dAmt2_v = 0
if IsNull(dAmt3_g) then dAmt3_g = 0
if IsNull(dAmt3_v) then dAmt3_v = 0
if IsNull(dAmt4_g) then dAmt4_g = 0
if IsNull(dAmt4_v) then dAmt4_v = 0
if IsNull(dAmt5_g) then dAmt5_g = 0
if IsNull(dAmt6_g) then dAmt6_g = 0
if IsNull(dAmt7_g) then dAmt7_g = 0
if IsNull(dAmt7_v) then dAmt7_v = 0
if IsNull(dAmt8_v) then dAmt8_v = 0
if IsNull(dAmt9_g) then dAmt9_g = 0
if IsNull(dAmt9_ga) then dAmt9_ga = 0

Double dAmt32_g, dAmt32_v, dAmt33_g, dAmt33_v, dAmt34_g, dAmt35_g, dAmt36_g, dAmt36_v

dAmt32_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_tax_gong")
dAmt32_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_tax_vat")
dAmt33_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_tax_gong_gita")
dAmt33_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_tax_vat_gita")
dAmt34_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_yong_gong")
dAmt35_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_yong_gong_gita")
dAmt36_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_31g")
dAmt36_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_31v")
if IsNull(dAmt32_g) then dAmt32_g = 0
if IsNull(dAmt32_v) then dAmt32_v = 0
if IsNull(dAmt33_g) then dAmt33_g = 0
if IsNull(dAmt33_v) then dAmt33_v = 0
if IsNull(dAmt34_g) then dAmt34_g = 0
if IsNull(dAmt35_g) then dAmt35_g = 0
if IsNull(dAmt36_g) then dAmt36_g = 0
if IsNull(dAmt36_v) then dAmt36_v = 0

Double dAmt10_g, dAmt10_v, dAmt11_g, dAmt11_v, dAmt12_g, dAmt12_v,  dAmt37_g, dAmt37_v, dAmt38_g, dAmt38_v,  dAmt39_g, dAmt39_v  
dAmt10_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_segum")
dAmt10_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_vat")
dAmt11_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gojeng")
dAmt11_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gojeng_vat")
dAmt12_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax10_g")
dAmt12_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax10_v")
if IsNull(dAmt10_g) then dAmt10_g = 0
if IsNull(dAmt10_v) then dAmt10_v = 0
if IsNull(dAmt11_g) then dAmt11_g = 0
if IsNull(dAmt11_v) then dAmt11_v = 0
if IsNull(dAmt12_g) then dAmt12_g = 0
if IsNull(dAmt12_v) then dAmt12_v = 0

dAmt37_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_maip_gong")
dAmt37_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_maip_gong_vat")
dAmt38_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_maip_gita")
dAmt38_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_maip_gita_vat")
dAmt39_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_34g")
dAmt39_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_34v")
if IsNull(dAmt37_g) then dAmt37_g = 0
if IsNull(dAmt37_v) then dAmt37_v = 0
if IsNull(dAmt38_g) then dAmt38_g = 0
if IsNull(dAmt38_v) then dAmt38_v = 0
if IsNull(dAmt39_g) then dAmt39_g = 0
if IsNull(dAmt39_v) then dAmt39_v = 0

Double dAmt13_g, dAmt13_v, dAmt14_g, dAmt14_v, dAmt15_g, dAmt15_v,  dAmt16_g, dAmt16_v, dAmt48_g, dAmt48_v,  dAmt49_g, dAmt49_v, dAmt50_g, dAmt50_v, dAmt51_g, dAmt51_v, dAmt52_g, dAmt52_v, dAmt17_g     

dAmt13_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_maiip_bal_gong")
dAmt13_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_maiip_bal_vat")
dAmt14_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gita")
dAmt14_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gitga_vat")
if IsNull(dAmt13_g) then dAmt13_g = 0
if IsNull(dAmt13_v) then dAmt13_v = 0
if IsNull(dAmt14_g) then dAmt14_g = 0
if IsNull(dAmt14_v) then dAmt14_v = 0

dAmt48_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_40g")
dAmt48_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_40v")
if IsNull(dAmt48_g) then dAmt48_g = 0
if IsNull(dAmt48_v) then dAmt48_v = 0

dAmt15_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_hap")
dAmt15_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_vat_hap")
dAmt16_g   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_yong")
dAmt16_v   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_yong_vat")
if IsNull(dAmt15_g) then dAmt15_g = 0
if IsNull(dAmt15_v) then dAmt15_v = 0
if IsNull(dAmt16_g) then dAmt16_g = 0
if IsNull(dAmt16_v) then dAmt16_v = 0

dAmt49_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_notax_gon")
dAmt49_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_notax_vat")
if IsNull(dAmt49_g) then dAmt49_g = 0
if IsNull(dAmt49_v) then dAmt49_v = 0

dAmt50_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_notax_comm_gon")
dAmt50_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_notax_comm_vat")
dAmt51_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"daeson_gong")
dAmt51_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"daeson_vat")
dAmt52_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_44g")
dAmt52_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_44v")
dAmt17_g  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc14")
if IsNull(dAmt50_g) then dAmt50_g = 0
if IsNull(dAmt50_v) then dAmt50_v = 0
if IsNull(dAmt51_g) then dAmt51_g = 0
if IsNull(dAmt51_v) then dAmt51_v = 0
if IsNull(dAmt52_g) then dAmt52_g = 0
if IsNull(dAmt52_v) then dAmt52_v = 0
if IsNull(dAmt17_g) then dAmt17_g = 0

Double dAmt18_v, dAmt58_v, dAmt_Ra, dAmt_Ma,dAmt_Ba,dAmt_Sa,dAmt_Aa,dAmt_Za,dAmt26_v,dAmt30_g,dAmt31_g,dAmt80_g,dAmt81_g,dAmt82_g,dAmt83_g, dAmt_ChongV
dAmt18_v  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax15_v")
dAmt58_v  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_47v")
dAmt_Ra   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_ra")
dAmt_Ma   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax18_v")
dAmt_Ba   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax19_v")
dAmt_Sa   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax143_v")
dAmt_Aa   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax111_v")
dAmt_Za   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"plus_tax")
dAmt26_v  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_21")
dAmt30_g  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"jongk4amt")
dAmt31_g  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_26")
dAmt80_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_vat3")
dAmt81_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_56v")
dAmt82_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_payamt")
dAmt83_g  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_rcvamt")

dAmt_ChongV = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"chong_v")
if IsNull(dAmt18_v) then dAmt18_v = 0
if IsNull(dAmt58_v) then dAmt58_v = 0
if IsNull(dAmt_Ra) then dAmt_Ra = 0
if IsNull(dAmt_Ma) then dAmt_Ma = 0
if IsNull(dAmt_Ba) then dAmt_Ba = 0
if IsNull(dAmt_Sa) then dAmt_Sa = 0
if IsNull(dAmt_Aa) then dAmt_Aa = 0
if IsNull(dAmt_Za) then dAmt_Za = 0
if IsNull(dAmt26_v) then dAmt26_v = 0
if IsNull(dAmt30_g) then dAmt30_g = 0
if IsNull(dAmt31_g) then dAmt31_g = 0
if IsNull(dAmt80_g) then dAmt80_g = 0
if IsNull(dAmt81_g) then dAmt81_g = 0
if IsNull(dAmt82_g) then dAmt82_g = 0
if IsNull(dAmt83_g) then dAmt83_g = 0
if IsNull(dAmt_ChongV) then dAmt_ChongV = 0

vCloseDt = Trim(tab_htax.tabpage_101.dw_101.GetItemString(1,"close_dt"))	

INSERT INTO KFZ_NEW_HOMETAX_101_1
( 	RPT_FR,				RPT_TO,				JASA_CD,				SORT_NO,				DATA_GU,					DOC_CD,
  	OUT_STAX_3, 		OUT_STAX_4,			OUT_MAIP_5,			OUT_MAIP_6,			OUT_CARD_7,				OUT_CARD_8,				OUT_GITA_9,				OUT_GITA_10,			OUT_YOUNG_11,		OUT_YOUNG_12,	
	OUT_MISS_13,		OUT_MISS_14,		OUT_PLAN_TAX_15,	OUT_PLAN_TAX_16,	OUT_PLAN_GITA_17,		OUT_PLAN_GITA_18,		OUT_PLAN_YGITA_19,	OUT_PLAN_YGITA_20,	OUT_PLAN_HAP_21,	OUT_PLAN_HAP_22,
	OUT_DAESON_23,		OUT_STANDTAX_24,	RESULT_TAX_25,
	IN_TAX_26,			IN_TAX_27,			IN_ASET_28,			IN_ASET_29,			IN_MISS_30,				IN_MISS_31,				IN_PLAN_TAX_32,		IN_PLAN_TAX_33,		IN_PLAN_GITA_34,	IN_PLAN_GITA_35,
	IN_PLAN_HAP_36,	IN_PLAN_HAP_37,	IN_BAL_TAX_38,		IN_BAL_TAX_39,		IN_GITA_40,				IN_GITA_41,				GITA_42,					GITA_43,					GITA_HAP_44,		GITA_HAP_45,
	NOTAX_46,			NOTAX_47,			NOTAX2_48,			NOTAX2_49,			NOTAX_IN_50,			NOTAX_IN_51,			NOTAX_DS_52,			NOTAX_DS_53,			NOTAX_HAP_54,		NOTAX_HAP_55,
	CHAGAM_56,			CHAGAM_57,			NAPBU_58,			GITA_TAX_59,		GITA_TAX_60,			GITA_TAX_61,			GITA_TAX_62,			GITA_TAX_63,			GITA_TAX_64,		GITA_TAX_65,
	GITA_TAX_66,		GITA_TAX_67,		GITA_TAX_68,		GITA_TAX_69,		GITA_TAX_70,			GITA_TAX_71,			GITA_TAX_72,			GITA_TAX_73,			
	TAX_GUBUN_74,		BANK_CD_75,			DEPOT_CD_76,		SUBMIT_MO_77,		BANK_NM_78,				CLOSE_DT_79,			CLOSE_DESC_80,			STANDYN_81,				
	REAL_TAX_82,		
	RPT_TAXGBN_83,		JOGI_GBN_84 )
values
	(:sFdate,			:sTdate,				:sJasa,				1,						'17',						:sDocCd,
	 :dAmt1_g,			:dAmt1_v,			:dAmt2_g,			:dAmt2_v,			:dAmt3_g,				:dAmt3_v,				:dAmt4_g,				:dAmt4_v,				:dAmt5_g,			:dAmt6_g,
	 :dAmt7_g,			:dAmt7_v,			:dAmt32_g,			:dAmt32_v,			:dAmt33_g,				:dAmt33_v,				:dAmt34_g,				:dAmt35_g,				:dAmt36_g,			:dAmt36_v,
	 :dAmt8_v,			:dAmt9_g,			:dAmt9_ga,			
	 :dAmt10_g,			:dAmt10_v,			:dAmt11_g,			:dAmt11_v,			:dAmt12_g,				:dAmt12_v,				:dAmt37_g,				:dAmt37_v,				:dAmt38_g,			:dAmt38_v,
	 :dAmt39_g,			:dAmt39_v,			:dAmt13_g,			:dAmt13_v,			:dAmt14_g,				:dAmt14_v,				:dAmt48_g,				:dAmt48_v,				:dAmt15_g,			:dAmt15_v,
	 :dAmt16_g,			:dAmt16_v,			:dAmt49_g,			:dAmt49_v,			:dAmt50_g,				:dAmt50_v,				:dAmt51_g,				:dAmt51_v,				:dAmt52_g,			:dAmt52_v,
	 :dAmt17_g,			:dAmt_na,			:dAmt_da,			:dAmt18_v,			:dAmt58_v,				:dAmt_Ra,				:dAmt_Ma,				:dAmt_Ba,				:dAmt_Sa,			:dAmt_Aa,
	 :dAmt_Za,			:dAmt26_v,			:dAmt30_g,			:dAmt31_g,			:dAmt80_g,				:dAmt81_g,				:dAmt82_g,				:dAmt83_g,
	 :sHgbn,				null,					null,					null,					null,						:vCloseDt,				null,						'N',
	 :dAmt_ChongV,		
	 :sTaxGbn,			:sCanGbn )  ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[부가세신고서-일반]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

Return 1
end function

protected function integer wf_create_101_2 (string sfdate, string stdate, string sjasa);String 	sDocCd = 'I103200',sSuipGbn,sUptae,sJongk,sJongNm,sJongCd,sCountFlag = 'N'
Double   dAmount,dCalc47V, dCalc19G
String   sUpCol[4]  = {'jongk1nm','jongk2nm','jongk3nm','jongk4nm'}
String	sJkCol[4]  = {'jongk1',  'jongk2',  'jongk3',  'jongk4'}
String   sAmtCol[4] = {'jongk1amt',  'jongk2amt',  'jongk3amt',  'jongk4amt'}
Integer  k

delete from kfz_new_hometax_101_2
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부가세신고서-수입금액]')
	Return -1
end if

tab_htax.tabpage_101.dw_101.AcceptText()						/*과세표준명세*/
for k = 1 to 4
	sUptae  = tab_htax.tabpage_101.dw_101.GetItemString(1,sUpCol[k])
	sJongk  = tab_htax.tabpage_101.dw_101.GetItemString(1,sJkCol[k])
	dAmount = tab_htax.tabpage_101.dw_101.GetItemNumber(1,sAmtCol[k])
	
	if IsNull(sUptae) then sUptae = ' '
	if IsNull(dAmount) then dAmount = 0	
	
	if dAmount = 0 or IsNull(dAmount) then Continue
	
	sCountFlag = 'Y'
	
	select nvl(rfna2,' '),		nvl(rfna3,' ')		into :sJongNm, :sJongCd
		from reffpf
		where rfcod = 'AW' and rfgub = :sJongk;
	if sqlca.sqlcode <> 0 then
		sJongNm = ' '
		sJongCd = ' '
	else
		if IsNull(sJongNm) then sJongNm = ' '
		if IsNull(sJongCd) then sJongCd = ' '
	end if
	
	if mid(sJongk,3,1) = '4' then					/*수입금액 제외*/
		sSuipGbn = '02'
	else
		sSuipGbn = '01'
	end if	

	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dAmount);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입금액]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
next
if sCountFlag = 'N' then				/*과세표준명세가 없으면 주업종코드로 하나 만듬*/
	sSuipGbn = '01'
	
	select nvl(rfna1,' '),	nvl(rfna2,' '),		nvl(rfna3,' ')		
		into :sUptae,			:sJongNm, 				:sJongCd
		from reffpf
		where rfcod = 'AW' and substr(rfgub,3,1) = '1';
	if sqlca.sqlcode <> 0 then
		sJongNm = ' '
		sJongCd = ' '
		sUptae  = ' '
	else
		if IsNull(sJongNm) then sJongNm = ' '
		if IsNull(sJongCd) then sJongCd = ' '
		if IsNull(sUptae) then sUptae = ' '
	end if
	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			1,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		0);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입금액]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

/*신용카드(04)추가*/
dCalc19G = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax15_g")
if IsNull(dCalc19G) then dCalc19G = 0
if dCalc19G <> 0 then
	sSuipGbn = '04'	
	if sCountFlag = 'N' then	 
		select nvl(rfna1,' '),	nvl(rfna3,' ')		
			into :sUptae,		:sJongk
			from reffpf
			where rfcod = 'AW' and substr(rfgub,3,1) = '1' and rfna5 = :sJasa ;
		if sqlca.sqlcode <> 0 then
			sJongk = ' '
			sUptae  = ' '
		else
			if IsNull(sJongk) then sJongk = ' '
			if IsNull(sUptae) then sUptae = ' '
		end if	
	else
		sUptae   = tab_htax.tabpage_101.dw_101.GetItemString(1,sUpCol[1])
		sJongk   = tab_htax.tabpage_101.dw_101.GetItemString(1,sJkCol[1])		
		//2004.01.24 수정-2007년2기확정
		if IsNull(sUptae) then 
			select nvl(rfna1,' '),	nvl(rfna3,' ')		
			into :sUptae,		:sJongk
			from reffpf
			where rfcod = 'AW' and substr(rfgub,3,1) = (SELECT Min( substr(rfgub,3,1))  FROM reffpf where rfcod ='AW' and rfna5=:sJasa) and rfna5 = :sJasa ; //2004.01.24 수정 - MIN부분
			if sqlca.sqlcode <> 0 then
				sJongk = ' '
				sUptae  = ' '
			else
				if IsNull(sJongk) then sJongk = ' '
				if IsNull(sUptae) then sUptae = ' '
			end if	
		end if
	end if	
	select nvl(rfna6,' ') into :sJongCd from reffpf where rfcod ='JA' and rfgub = :sJasa;	
	k = k + 1	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dCalc19G);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-신용카드발행]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

/*기타 경감세액=전자신고세액공제'7'*/
dCalc47V = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_47v")
if IsNull(dCalc47V) then dCalc47V = 0
if dCalc47V <> 0 then
	sSuipGbn = '07'	
	if sCountFlag = 'N' then	 
		select nvl(rfna1,' '),	nvl(rfna3,' ')		
			into :sUptae,		:sJongk
			from reffpf
			where rfcod = 'AW' and substr(rfgub,3,1) = '1' and rfna5 = :sJasa ;
		if sqlca.sqlcode <> 0 then
			sJongk = ' '
			sUptae  = ' '
		else
			if IsNull(sJongk) then sJongk = ' '
			if IsNull(sUptae) then sUptae = ' '
		end if	
	else
		sUptae   = tab_htax.tabpage_101.dw_101.GetItemString(1,sUpCol[1])
		sJongk   = tab_htax.tabpage_101.dw_101.GetItemString(1,sJkCol[1])		
		//2004.01.24 수정-2007년2기확정
		if IsNull(sUptae) then 
			select nvl(rfna1,' '),	nvl(rfna3,' ')		
			into :sUptae,		:sJongk
			from reffpf
			where rfcod = 'AW' and substr(rfgub,3,1) = (SELECT Min( substr(rfgub,3,1))  FROM reffpf where rfcod ='AW' and rfna5=:sJasa) and rfna5 = :sJasa ; //2004.01.24 수정 - MIN부분
			if sqlca.sqlcode <> 0 then
				sJongk = ' '
				sUptae  = ' '
			else
				if IsNull(sJongk) then sJongk = ' '
				if IsNull(sUptae) then sUptae = ' '
			end if	
		end if
	end if	
	dAmount  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_vat4")	
	select nvl(rfna6,' ') into :sJongCd from reffpf where rfcod ='JA' and rfgub = :sJasa;	
	k = k + 1	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dCalc47V);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입금액]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

tab_htax.tabpage_101_1.dw_101_1.AcceptText()						/*면세수입금액1*/
sSuipGbn = '08'
sUptae   = tab_htax.tabpage_101_1.dw_101_1.GetItemString(1,"notax_uptae1")
sJongNm  = tab_htax.tabpage_101_1.dw_101_1.GetItemString(1,"notax_jong1")
dAmount  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_vat1")
if dAmount <> 0 and Not IsNull(dAmount) then	
	k = k + 1
	
	if IsNull(sUptae) then sUptae = ' '
	if IsNull(sJongNm) then sJongNm = ' '
	
	select nvl(dataname,' ')	into :sJongCd from syscnfg	where sysgu = 'A' and serial = 15 and lineno = '3' ;
	if sqlca.sqlcode <> 0 then
		sJongCd = ' '
	else
		if IsNull(sJongCd) then sJongCd = ' '
	end if
	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dAmount);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입금액1]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

sUptae   = tab_htax.tabpage_101_1.dw_101_1.GetItemString(1,"notax_uptae2")
sJongNm  = tab_htax.tabpage_101_1.dw_101_1.GetItemString(1,"notax_jong2")
dAmount  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_vat2")
if dAmount <> 0 and Not IsNull(dAmount) then	
	k = k + 1
	
	if IsNull(sUptae) then sUptae = ' '
	if IsNull(sJongNm) then sJongNm = ' '
	
	select nvl(dataname,' ')	into :sJongCd from syscnfg	where sysgu = 'A' and serial = 15 and lineno = '4' ;
	if sqlca.sqlcode <> 0 then
		sJongCd = ' '
	else
		if IsNull(sJongCd) then sJongCd = ' '
	end if
	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt,		bigo)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dAmount,		null);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입금액2]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

//면세수입금액-수입금액제외
sSuipGbn = '14'
sUptae   = '수입금액제외'
sJongNm  = tab_htax.tabpage_101_1.dw_101_1.GetItemString(1,"notax_jong3")
dAmount  = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"notax_vat3")
if dAmount <> 0 and Not IsNull(dAmount) then	
	k = k + 1
	
	if IsNull(sUptae) then sUptae = ' '
	if IsNull(sJongNm) then sJongNm = ' '
	
	select nvl(dataname,' ')	into :sJongCd from syscnfg	where sysgu = 'A' and serial = 15 and lineno = '4' ;
	if sqlca.sqlcode <> 0 then
		sJongCd = ' '
	else
		if IsNull(sJongCd) then sJongCd = ' '
	end if
	
	insert into kfz_new_hometax_101_2
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,
		 suip_gbn,	uptae,			upjong,		jong_cd,			suip_amt)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'15',				:sDocCd,			:k,
		 :sSuipGbn,	:sUptae,			:sJongNm,	:sJongCd,		:dAmount);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-수입제외금액]')
		SetPointer(Arrow!)
		Return -1
	end if
end if

Return 1
end function

protected function integer wf_create_file (string sfdate, string stdate, string sjasa, string spath);String   sFilePath,sFileName,sSaveFile,sDocCd,sCrtDate,sSano,sTaxTag,sSuChulTag

if sPath = '' or IsNull(sPath) then 
	sFilePath = 'c:\'
else
	sFilePath = sPath
end if

dw_ip.AcceptText()
sCrtDate  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"kfz_vat_title_cdate"))
sSano     = Trim(dw_ip.GetItemString(dw_ip.getrow(),"kfz_vat_title_saupno"))

/*전자신고제외코드-계산서*/
select nvl(rfna2,'N')  into :sTaxTag from reffpf where rfcod = 'TD' and rfgub = '01';

if sqlca.sqlcode = 0 then
	if IsNull(sTaxTag) then sTaxTag = 'N'
else
	sTaxTag = 'N'
end if
if sTaxTag = 'Y' then sTaxTag = 'B'

/*전자신고제외코드-수출실적*/
select nvl(rfna2,'N')  into :sSuchulTag from reffpf where rfcod = 'TD' and rfgub = '02';

if sqlca.sqlcode = 0 then
	if IsNull(sSuchulTag) then sSuchulTag = 'N'
else
	sSuchulTag = 'N'
end if
if sSuchulTag = 'Y' then sSuchulTag = 'C'
	
w_mdi_frame.sle_msg.text = '신고자료를 파일로 받는 중입니다...'
SetPointer(HourGlass!)

/*전체 통합 파일*/
sDocCd = 'V101'
String sTaxFrom //2008.01.24 계산서 시작일 조회조건 추가
sTaxFrom = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"tax_from"))
if sTaxFrom='' or isnull(sTaxFrom) then
	messagebox("사용자확인", "계산서시작일을 입력하세요")
	dw_ip.SetColumn('tax_from'); dw_ip.setfocus()
	return 1
end if
if dw_text.Retrieve(sFdate,sTdate,sJasa,sTaxTag,sSuchulTag, sTaxFrom) > 0 then

	sFileName   = sCrtDate+'.'+Right(sDocCd,3)
	sSaveFile   = sFilePath + sFileName
	
	dw_text.SaveAs(sSaveFile, TEXT!, FALSE)
end if
Return 1
end function

public function integer wf_retrieve ();string   sVatGisu,sDatefrom,sDateto,sJasaCod,sCrtDate,sApplyFlag = '%',sSano,sRptDsc,sSaupj,sGubun,sJogi,sTaxOffice,sRptCode
string   sSingoIn,sSemu, sReportGisu
Integer  iRowCount, k

dw_ip.AcceptText()

sVatGisu  = dw_ip.GetItemString(dw_ip.GetRow(),"vatgisu") 
sDatefrom = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_edate"))
sJasaCod  = dw_ip.GetItemstring(dw_ip.getrow(),"code")
sCrtDate  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"kfz_vat_title_cdate"))
sRptCode  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"rptdsc"))
sGubun    = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"rpt_gubun"))
sSingoIn  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"kfz_vat_title_sangho"))
sJogi     = dw_ip.GetItemstring(dw_ip.getrow(),"jogi")

IF sDateFrom = '' or IsNull(sDateFrom) THEN
	F_MessageChk(1,'[신고기간]')
	dw_ip.SetColumn("kfz_vat_title_sdate")
	dw_ip.SetFocus()
	Return -1
END IF
IF sDateTo = '' or IsNull(sDateTo) THEN
	F_MessageChk(1,'[신고기간]')
	dw_ip.SetColumn("kfz_vat_title_edate")
	dw_ip.SetFocus()
	Return -1
END IF
IF sGubun = '' or IsNull(sGubun) THEN
	F_MessageChk(1,'[구분]')
	dw_ip.SetColumn("gubun")
	dw_ip.SetFocus()
	Return -1
END IF
//IF sCrtDate = "" OR IsNull(sCrtDate) THEN
//	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
//ELSE
//	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
//END IF

IF sJasaCod = '' or IsNull(sJasaCod) THEN
	F_MessageChk(1,'[자사코드]')
	dw_ip.SetColumn("code")
	dw_ip.SetFocus()
	Return -1
ELSE
	select rfna3	into :sSaupj from reffpf where rfcod = 'JA' and rfgub = :sJasaCod;
	if sSaupj = '' or IsNull(sSaupj) then sSaupj = '10'
END IF

if sVatGisu = '1' or sVatGisu = '2' then
	sReportGisu = '1'
else
	sReportGisu = '2'
end if
	

/*영세율첨부서류*/
if LsHomeTaxTag04 = 'N' and (sRptCode = '' or IsNull(sRptCode)) then
	F_MessageChk(1,'[제출사유]')
	dw_ip.SetColumn("rptdsc")
	dw_ip.SetFocus()
	Return -1
else
	select rfna1||nvl(rfna3,'') into :sRptDsc from reffpf where rfcod = 'TC' and rfgub = :sRptCode;
end if

p_create.Enabled = True
p_create.PictureName = 'C:\erpman\image\자료생성_up.gif'

LiBsImCnt = 0

/*부가세신고서*/
if tab_htax.tabpage_101.dw_101.Retrieve(sJasaCod,sJasaCod,sVatGisu,sDateFrom,sDateTo,sApplyFlag,sSaupj,sJogi) > 0 then
	String sTaxFrom //2008.01.24 계산서 시작일 조회조건 추가
	sTaxFrom = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"tax_from"))
	if sTaxFrom='' or isnull(sTaxFrom) then
	   messagebox("사용자확인", "계산서시작일을 입력하세요")
	   dw_ip.SetColumn('tax_from'); dw_ip.setfocus()
	   return 1
	end if
	if tab_htax.tabpage_101_1.dw_101_1.Retrieve(sJasaCod,sVatGisu,sDateFrom,sDateTo,sApplyFlag, sTaxFrom) <=0 then//2008.01.24 계산서 시작일 조회조건 추가
		tab_htax.tabpage_101_1.dw_101_1.InsertRow(0)
	end if
	SELECT "VNDMST"."SANO"     	INTO :sSano  
		FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sJasaCod;

	IF SQLCA.SQLCODE = 0 THEN
		tab_htax.tabpage_101_1.dw_101_1.Modify("s1.text  ='"+Mid(sSano,1,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s2.text  ='"+Mid(sSano,2,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s3.text  ='"+Mid(sSano,3,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s4.text  ='"+Mid(sSano,4,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s5.text  ='"+Mid(sSano,5,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s6.text  ='"+Mid(sSano,6,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s7.text  ='"+Mid(sSano,7,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s8.text  ='"+Mid(sSano,8,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s9.text  ='"+Mid(sSano,9,1)+"'")
		tab_htax.tabpage_101_1.dw_101_1.Modify("s10.text ='"+Mid(sSano,10,1)+"'")
	END IF
	
	select rfna1 into :sTaxOffice from reffpf where rfcod = 'TO' and rfna2 = :sJasaCod ;
	IF  (sVatGisu = '2' OR sVatGisu ='4')  THEN
		tab_htax.tabpage_101.dw_101.SetItem(1,"tax15_v",           10000)	
		tab_htax.tabpage_101_1.dw_101_1.SetItem(1,"gita_vat4",  10000)	
	ELSE
		tab_htax.tabpage_101.dw_101.SetItem(1,"tax15_v",           0)	
		tab_htax.tabpage_101_1.dw_101_1.SetItem(1,"gita_vat4",  0)	
	END IF
	
	tab_htax.tabpage_101.dw_101.Object.t_date.text = Mid(sCrtDate,1,4) + " 년  " + Mid(sCrtDate,5,2) + " 월  " + Mid(sCrtDate,7,2) + " 일"
	tab_htax.tabpage_101.dw_101.Object.t_singoin.text = "신고인 " + sSingoIn + " (서명 또는 인)"
	tab_htax.tabpage_101.dw_101.Object.t_tax_office.text = sTaxOffice 
end if

if LsHomeTaxTag03 = 'N' then			/*사업장별 과세표준*/
	String sJasaOwner
	
	select dataname	into :sJasaOwner	from syscnfg where sysgu = 'C' and serial = 4 and lineno = '1';
	if sqlca.sqlcode = 0 then
		if IsNull(sJasaOwner) then sJasaOwner = '0'
	else
		sJasaOwner = '0'
	end if
	if sJasaOwner = sJasaCod and sGubun = '2' then					/*대표자사*/
		tab_htax.tabpage_115.dw_115.Retrieve(sVatGisu,sDateFrom,sDateTo,'%', sGubun)
	else
		tab_htax.tabpage_115.dw_115.Retrieve(sVatGisu,sDateFrom,sDateTo,'', sGubun)
	end if
else
	tab_htax.tabpage_115.dw_115.Reset()
end if

if LsHomeTaxTag03 = 'N' then	
	if sGubun = '1' then				/*사업자단위,납부자 과세표준*/
		tab_htax.tabpage_150.dw_150.Retrieve(Left(sDateFrom,4),sDateFrom,sDateTo,sJasaCod)	
	else
		tab_htax.tabpage_150.dw_150.Reset()
	end if
else
	tab_htax.tabpage_150.dw_150.Reset()	
end if

if LsHomeTaxTag04 = 'N' then			//영세율 첨부서류
	tab_htax.tabpage_106.dw_106.Retrieve(sDateFrom,sDateTo,sJasaCod,sVatGisu,sCrtDate,sRptDsc) 
	tab_htax.tabpage_106.dw_106.Object.DataWindow.Print.Preview = 'yes'
ELSE
	tab_htax.tabpage_106.dw_106.Reset()
END IF

if LsHomeTaxTag05 = 'N' then					/*건물등 감가상각자산취득명세서로 대체:2004.10.18*/
	IF tab_htax.tabpage_108.dw_108.Retrieve(sDateFrom,sDateTo,sJasaCod,sVatGisu,sCrtDate) > 0 THEN
		tab_htax.tabpage_108.dw_108.Object.t_semuseo.text = sTaxOffice
	END IF
else
	tab_htax.tabpage_108.dw_108.Reset()	
end if

if LsHomeTaxTag07 = 'N' then
	//부동산임대공급가액 명세서
	IF tab_htax.tabpage_120.dw_120.Retrieve(sDateFrom,sDateTo,sJasaCod,sVatGisu) > 0 THEN
		iRowCount = tab_htax.tabpage_120.dw_120.RowCount()
		LiBsImCnt = iRowCount
		
		IF iRowCount < 20 THEN
			FOR k = 1 TO 20 - iRowCount
				tab_htax.tabpage_120.dw_120.InsertRow(0)
			NEXT
		END IF
	END IF
else
	tab_htax.tabpage_120.dw_120.Reset()	
end if

//대손공제변제 제외여부 = 'Y'(제외)
if LsHomeTaxTag08 = 'N' then
	Wf_Retrieve_112()
else
	tab_htax.tabpage_112.dw_112.Reset()
end if

if LsHomeTaxTag09 = 'N' then					//공제받지 못할 매입세액
	tab_htax.tabpage_135.dw_135.Retrieve(Left(sDateFrom,4),sDateFrom,sDateTo,sJasaCod,sVatGisu)
else
	tab_htax.tabpage_135.dw_135.Reset()
end if

if LsHomeTaxTag0B = 'N' then					//신용카드매출전표발행집계표
	tab_htax.tabpage_117.dw_117.Retrieve(sDateFrom,sDateTo,sJasaCod,sVatGisu)
else
	tab_htax.tabpage_117.dw_117.Reset()
end if

//영세율매출명세서(2013년 2기 예정 추가:2013.09.16)
Double dMaichulYoung1, dMaichulYoung2
String sTerm

if tab_htax.tabpage_101.dw_101.RowCount() > 0 then
	dMaichulYoung1 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_segum")
	dMaichulYoung2 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_gita")
	if IsNull(dMaichulYoung1) then dMaichulYoung1 = 0
	if IsNull(dMaichulYoung2) then dMaichulYoung2 = 0
else
	dMaichulYoung1 = 0
	dMaichulYoung2 = 0
end if
if dMaichulYoung1 + dMaichulYoung2 = 0 then
	tab_htax.tabpage_177.dw_177.Reset()
	LsHomeTaxTag0E = 'Y'						//제외
else	
	tab_htax.tabpage_177.dw_177.Retrieve(sDateFrom,sDateTo,sJasaCod)	
	
	if sVatGisu = '1' or sVatGisu = '3' then
		sTerm = '(' + left(sDateFrom,4) +'년 '+ sReportGisu + '기 [V]예정 [ ]확정)'
	else
		sTerm = '(' + left(sDateFrom,4) +'년 '+ sReportGisu + '기 [ ]예정 [V]확정)'	
	end if
	tab_htax.tabpage_177.dw_177.Object.t_term.text = sTerm 
	tab_htax.tabpage_177.dw_177.Object.DataWindow.Print.Preview = 'no'
	
	LsHomeTaxTag0E = 'N'
end if
//

Double  dAmount, dAmt21	

if tab_htax.tabpage_101.dw_101.RowCount() > 0 then
	if   sGubun = '2'  then	
		select  sum(nvl( taxno_79 ,0))	into :dAmount
			from kfz_hometax_101_1
			where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd <> :sJasaCod ;
		if sqlca.sqlcode <> 0 then
			dAmount = 0
		else
			if IsNull(dAmount) then dAmount = 0
		end if
		
		dAmt21 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_21")
		if IsNull(dAmt21) then dAmt21 = 0
		
		tab_htax.tabpage_101.dw_101.SetItem(1,"chong_v", dAmt21 + dAmount)
	elseif sGubun = '0' or sGubun = '5' then
		dAmt21 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_21")
		if IsNull(dAmt21) then dAmt21 = 0
		
		tab_htax.tabpage_101.dw_101.SetItem(1,"chong_v", dAmt21 )
	else
		tab_htax.tabpage_101.dw_101.SetItem(1,"chong_v", 0)
	end if
end if
	
tab_htax.tabpage_101.dw_101.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_101_1.dw_101_1.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_115.dw_115.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_108.dw_108.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_135.dw_135.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_150.dw_150.Object.DataWindow.Print.Preview = 'no'
tab_htax.tabpage_120.dw_120.Object.DataWindow.Print.Preview = 'no'

tab_htax.tabpage_117.dw_117.Object.DataWindow.Print.Preview = 'no'

Return 1
end function

protected function integer wf_create_108 (string sfdate, string stdate, string sjasa);String   sDocCd ='I103800'
Double   dGamt_T,dVamt_T,dGamt_G1,dGamt_G2,dGamt_G3,dGamt_G4,dVamt_G1,dVamt_G2,dVamt_G3,dVamt_G4
Integer  iCnt_T,iCnt_G1,iCnt_G2,iCnt_G3,iCnt_G4

delete from kfz_hometax_108
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[감가상각자산 취득명세서]')
	Return -1
end if

tab_htax.tabpage_108.dw_108.AcceptText()
if tab_htax.tabpage_108.dw_108.RowCount() <=0 then Return 1

iCnt_T   = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"tot_cnt")
dGamt_T  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"tot_gon") 
dVamt_T  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"tot_vat") 
if IsNull(iCnt_T) then iCnt_T = 0
if IsNull(dGamt_T) then dGamt_T = 0
if IsNull(dVamt_T) then dVamt_T = 0

iCnt_G1  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun1_cnt")
dGamt_G1 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun1_gon") 
dVamt_G1 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun1_vat") 
if IsNull(iCnt_G1) then iCnt_G1 = 0
if IsNull(dGamt_G1) then dGamt_G1 = 0
if IsNull(dVamt_G1) then dVamt_G1 = 0

iCnt_G2  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun2_cnt")
dGamt_G2 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun2_gon") 
dVamt_G2 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun2_vat") 
if IsNull(iCnt_G2) then iCnt_G2 = 0
if IsNull(dGamt_G2) then dGamt_G2 = 0
if IsNull(dVamt_G2) then dVamt_G2 = 0

iCnt_G3  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun3_cnt")
dGamt_G3 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun3_gon") 
dVamt_G3 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun3_vat") 
if IsNull(iCnt_G3) then iCnt_G3 = 0
if IsNull(dGamt_G3) then dGamt_G3 = 0
if IsNull(dVamt_G3) then dVamt_G3 = 0

iCnt_G4  = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun4_cnt")
dGamt_G4 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun4_gon") 
dVamt_G4 = tab_htax.tabpage_108.dw_108.GetItemNumber(1,"gubun4_vat") 
if IsNull(iCnt_G4) then iCnt_G4 = 0
if IsNull(dGamt_G4) then dGamt_G4 = 0
if IsNull(dVamt_G4) then dVamt_G4 = 0

insert into kfz_hometax_108
	(rpt_fr,		rpt_to,		jasa_cd,		data_gu,		doc_cd,
	 tot_cnt,	tot_gon,		tot_vat,		gbn1_cnt,	gbn1_gon,		gbn1_vat,
	 gbn2_cnt,	gbn2_gon,	gbn2_vat,	gbn3_cnt,	gbn3_gon,		gbn3_vat,		gbn4_cnt,	gbn4_gon,	gbn4_vat)
values
	(:sFdate,	:sTdate,		:sJasa,		'17',			:sDocCd,			
	 :iCnt_T,	:dGamt_T,	:dVamt_T,	:iCnt_G1,	:dGamt_G1,		:dVamt_G1,
	 :iCnt_G2,	:dGamt_G2,	:dVamt_G2,	:iCnt_G3,	:dGamt_G3,		:dVamt_G3,		:iCnt_G4,	:dGamt_G4,	:dVamt_G4) ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[감가상각자산 취득명세서]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

Commit;
Return 1
end function

protected function integer wf_create_101 (string sfdate, string stdate, string sjasa);string  sVatGisu,sCrtDate,sMainJong,sUserId,sSano,sSangHo,sOwner,sResid,sUptae,&
		  sUpjong,sAddr,sTelNo,sOpenDate,sMailId = ' ', vCloseDt
String 	                         sRptGbn, sRptDtlGbn, sYearGi,sRptKind,&	  		 									
/*서식코드*/		                sDocCd = 'I103200',&							
/*납세자구분1:개인,8:법인*/		 sSaupGbn = '8', &
/*세무프로그램코드-기타('9000')*/ sPgmCode = '9000'

Integer  								 iRptSeq, &
/*순차번호1:정기,2:수정*/			 iSerNo = 1

dw_ip.AcceptText()

sVatGisu  = dw_ip.GetItemString(dw_ip.GetRow(),"vatgisu") 
sCrtDate  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"kfz_vat_title_cdate"))
sMainJong = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"main_upcod"))
sUserId   = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"userid"))
sOpenDate = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"opendate"))

if sVatGisu = '1' or sVatGisu = '2' then		/*1기 예정/확정*/
	sYearGi = Left(sFdate,4)+'01'
else
	sYearGi = Left(sFdate,4)+'02'
end if

vCloseDt = Trim(tab_htax.tabpage_101.dw_101.GetItemString(1,"close_dt"))	
if IsNull(vCloseDt) or vCloseDt = '' then
	if sVatGisu = '1' or sVatGisu = '3' then		//신고구분
		sRptGbn = '03'
	else
		sRptGbn = '01'
	end if
else
	sRptGbn = '01'
end if

//if mid(sFdate,5,2) = '03' or mid(sFdate,5,2) = '06' or mid(sFdate,5,2) = '09' or mid(sFdate,5,2)  = '12' then		//신고구분상세
	sRptDtlGbn = '01'	
//else
//	sRptDtlGbn = '07'			
//end if

if mid(sFdate,5,2) = '04' or mid(sFdate,5,2) = '10' then
	sRptKind = 'C05'
elseif mid(sFdate,5,2) = '05' or mid(sFdate,5,2) = '11' then
	sRptKind = 'C06'	
elseif mid(sFdate,5,2) = '01' or mid(sFdate,5,2) = '07' then
	sRptKind = 'C15'
elseif mid(sFdate,5,2) = '02' or mid(sFdate,5,2) = '08' then
	sRptKind = 'C16'
elseif mid(sFdate,5,2) = '03' or mid(sFdate,5,2) = '09' then
	sRptKind = 'C17'	
elseif mid(sFdate,5,2) = '06' or mid(sFdate,5,2) = '12' then
	sRptKind = 'C07'	
end if

IF sMainJong = '' or IsNull(sMainJong) THEN
	F_MessageChk(1,'[주업종코드]')
	dw_ip.SetColumn("main_upcod")
	dw_ip.SetFocus()
	Return -1
END IF
IF sUserId = '' or IsNull(sUserId) THEN
	F_MessageChk(1,'[사용자ID]')
	dw_ip.SetColumn("userid")
	dw_ip.SetFocus()
	Return -1
END IF
IF sOpenDate = '' or IsNull(sOpenDate) THEN
	F_MessageChk(1,'[개업일자]')
	dw_ip.SetColumn("opendate")
	dw_ip.SetFocus()
	Return -1
END IF

sSano   = dw_ip.GetItemString(1,"kfz_vat_title_saupno")
sSangHo = dw_ip.GetItemString(1,"kfz_vat_title_sangho")
sOwner  = dw_ip.GetItemString(1,"kfz_vat_title_sname")
sResid  = dw_ip.GetItemString(1,"resident")
sUptae  = dw_ip.GetItemString(1,"kfz_vat_title_uptae")
sUpjong = dw_ip.GetItemString(1,"kfz_vat_title_upjong")
sAddr   = dw_ip.GetItemString(1,"kfz_vat_title_addr")
if IsNull(sSano) or sSano = '' then sSano = ' '
if IsNull(sSangHo) or sSangHo = '' then sSangHo = ' '
if IsNull(sOwner) or sOwner = '' then sOwner = ' '
if IsNull(sResid) or sResid = '' then sResid = ' '
if IsNull(sUptae) or sUptae = '' then sUptae = ' '
if IsNull(sUpjong) or sUpjong = '' then sUpjong = ' '
if IsNull(sAddr) or sAddr = '' then sAddr = ' '

delete from kfz_new_hometax_101
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부가세신고서-헤더]')
	Return -1
end if

String sAgentNm,sAgentTel,sAgentNo

tab_htax.tabpage_101.dw_101.AcceptText()
sAgentNm  = tab_htax.tabpage_101.dw_101.GetItemString(1,"agent_nm")
sAgentNo  = tab_htax.tabpage_101.dw_101.GetItemString(1,"agent_no")
sAgentTel = tab_htax.tabpage_101.dw_101.GetItemString(1,"agent_tel")
sTelNo    = tab_htax.tabpage_101.dw_101.GetItemString(1,"telddd") + &
				tab_htax.tabpage_101.dw_101.GetItemString(1,"telno1") + &
				tab_htax.tabpage_101.dw_101.GetItemString(1,"telno2") 
				
insert into kfz_new_hometax_101
	(rpt_fr,		rpt_to,			jasa_cd,			sort_no,				data_gu,			doc_cd,
	 saup_no,	dtl_gu,			rpt_gbn,			rpt_dtl_gbn,		year_gi,			rpt_kind,
	 
	 serno,		use_id,			resid_no,		agent_nm,			agent_no,		agent_tel,
	 saup_nm,	saup_owner,		saup_addr,		saup_tel,			owner_addr,		owner_tel,
	 uptae_nm,	jong_nm,			jong_cd,			fr_date,				to_date,			crt_date,
	 open_date, revi_gbn,		owner_hp,		pgm_cd,				agent_sano,		mailaddr)
values
	(:sfDate,	:sTdate,			:sJasa,			1,						'11',				:sDocCd,
	 :sSano,		'41',				:sRptGbn,		:sRptDtlGbn,		:sYearGi,		:sRptKind,
	 :iSerNo,	:sUserId,		:sResid,			:sAgentNm,			null,				:sAgentTel,
	 :sSangHo,	:sOwner,			:sAddr,			:sTelNo,				null,				null,
	 :sUptae,	:sUpjong,		:sMainJong,		:sFdate,				:sTdate,			:sCrtDate,
	 :sOpenDate,'N',				null,				:sPgmCode,			:sAgentNo,		null)  ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[부가세신고서-헤더]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

Return 1
end function

protected function integer wf_create_150 (string sfdate, string stdate, string sjasa);String   sDocCd = 'I103900',sSangHo,sAddr,sSerNo
Double   dMaiChulSegum_g,dMaiChulSegum_v,dMaiChulSegum_Gita_g,dMaiChulSegum_Gita_v, dMaiChulYong_g,dMaiChulYong_Gita_g, dMaiChulHap,&
			dMaiipSegum_g,dMaiipSegum_v,dMaiipYj_g,dMaiipYj_v,dTaxAdd,dTaxSub,dResult
Integer  iRowCount,k

delete from kfz_hometax_150 where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
delete from kfz_hometax_150_1 where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[사업자단위 과세표준]')
	Return -1
end if

tab_htax.tabpage_150.dw_150.AcceptText()
iRowCount = tab_htax.tabpage_150.dw_150.RowCount()
if iRowCount <=0 then Return 1

/*과세표준 세부내역*/
For k= 1 To iRowcount
	sSerNo           = String(tab_htax.tabpage_150.dw_150.GetItemNumber(k,"serno"),'0000')
	
	sSangHo          = tab_htax.tabpage_150.dw_150.GetItemString(k,"cvnas")
	sAddr            = tab_htax.tabpage_150.dw_150.GetItemString(k,"addr1")
	
	dMaiChulSegum_g  = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_tax_segum")
	dMaiChulSegum_v  = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_tax_vat")
	dMaiChulSegum_Gita_g  = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_tax_segum_gita")
	dMaiChulSegum_Gita_v  = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_tax_segum_gita_vat")
	
	dMaiChulYong_g   = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_yong")
	dMaiChulYong_Gita_g   = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maichul_yong_gita")
	
	dMaiipSegum_g    = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maiip_tax_segum")
	dMaiipSegum_v    = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maiip_tax_vat")
	dMaiipYj_g       = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maiip_yj_g")
	dMaiipYj_v       = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maiip_yj_v")
	dTaxAdd          = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"taxadd")
	dTaxSub          = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"maiip_tax_yong_vat")
	dResult          = tab_htax.tabpage_150.dw_150.GetItemNumber(k,"calc")
	
	if IsNull(dMaiChulSegum_g) then dMaiChulSegum_g = 0
	if IsNull(dMaiChulSegum_v) then dMaiChulSegum_v = 0
	if IsNull(dMaiChulSegum_Gita_g) then dMaiChulSegum_Gita_g = 0
	if IsNull(dMaiChulSegum_Gita_v) then dMaiChulSegum_Gita_v = 0
	if IsNull(dMaiChulYong_g) then dMaiChulYong_g = 0
	if IsNull(dMaiChulYong_Gita_g) then dMaiChulYong_Gita_g = 0
	
	dMaiChulHap = dMaiChulSegum_g + dMaiChulSegum_Gita_g + dMaiChulYong_g + dMaiChulYong_Gita_g
	
	if IsNull(dMaiipSegum_g) then dMaiipSegum_g = 0
	if IsNull(dMaiipSegum_v) then dMaiipSegum_v = 0
	if IsNull(dMaiipYj_g) then dMaiipYj_g = 0
	if IsNull(dMaiipYj_v) then dMaiipYj_v = 0
	if IsNull(dTaxAdd) then dTaxAdd = 0
	if IsNull(dTaxSub) then dTaxSub = 0
	if IsNull(dResult) then dResult = 0
	
	insert into kfz_hometax_150_1
		(rpt_fr,						rpt_to,					jasa_cd,						data_gu,						doc_gu, 					serno,					cvnas,				old_addr,	 
		 mout_segum_gon,			mout_segum_vat,		mout_gita_gon,				mout_gita_vat,				mout_young_segum,		mout_young_gita,		mout_hap,	
		 min_segum_gon,			min_segum_vat,			min_yj_gon,					min_yj_vat,					add_amt,					sub_amt,					chagam,				new_addr	) 
	values
		(:sFdate,					:sTdate,					:sJasa,						'18',							:sDocCd,					:sSerNo,					:sSangHo,			:sAddr,
		 :dMaiChulSegum_g,		:dMaiChulSegum_v,		:dMaiChulSegum_Gita_g,	:dMaiChulSegum_Gita_v,	:dMaiChulYong_g,		:dMaiChulYong_Gita_g,:dMaiChulHap,	
		 :dMaiipSegum_g,			:dMaiipSegum_v,		:dMaiipYj_g,				:dMaiipYj_v,				:dTaxAdd,				:dTaxSub,				:dResult,			'') ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[사업자단위 과세표준-세부내역]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
Next

/*과세표준 집계*/
dMaiChulSegum_g  = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_tax_segum_hap")
dMaiChulSegum_v  = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_tax_vat_hap")
dMaiChulSegum_Gita_g  = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_tax_segum_gita_hap")
dMaiChulSegum_Gita_v  = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_tax_vat_gita_hap")

dMaiChulYong_g        = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_yong_hap")
dMaiChulYong_Gita_g   = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maichul_yong_gita_hap")

dMaiipSegum_g    = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maiip_tax_segum_hap")
dMaiipSegum_v    = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maiip_tax_vat_hap")
dMaiipYj_g       = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maiip_yj_g_hap")
dMaiipYj_v       = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maiip_yj_v_hap")
dTaxAdd          = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"taxadd_hap")
dTaxSub          = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"maiip_tax_yong_vat_hap")
dResult          = tab_htax.tabpage_150.dw_150.GetItemNumber(iRowCount,"calc_hap")
	
if IsNull(dMaiChulSegum_g) then dMaiChulSegum_g = 0
if IsNull(dMaiChulSegum_v) then dMaiChulSegum_v = 0
if IsNull(dMaiChulSegum_Gita_g) then dMaiChulSegum_Gita_g = 0
if IsNull(dMaiChulSegum_Gita_v) then dMaiChulSegum_Gita_v = 0
if IsNull(dMaiChulYong_g) then dMaiChulYong_g = 0
if IsNull(dMaiChulYong_Gita_g) then dMaiChulYong_Gita_g = 0

if IsNull(dMaiipSegum_g) then dMaiipSegum_g = 0
if IsNull(dMaiipSegum_v) then dMaiipSegum_v = 0
if IsNull(dMaiipYj_g) then dMaiipYj_g = 0
if IsNull(dMaiipYj_v) then dMaiipYj_v = 0
if IsNull(dTaxAdd) then dTaxAdd = 0
if IsNull(dTaxSub) then dTaxSub = 0
if IsNull(dResult) then dResult = 0

dMaiChulHap = dMaiChulSegum_g + dMaiChulSegum_Gita_g + dMaiChulYong_g + dMaiChulYong_Gita_g

insert into kfz_hometax_150
	(rpt_fr,						rpt_to,					jasa_cd,						data_gu,						doc_gu,	 
	 mout_segum_gon,			mout_segum_vat,		mout_gita_gon,				mout_gita_vat,				mout_young_segum,			mout_young_gita,			mout_hap,		
	 min_segum_gon,			min_segum_vat,			min_yj_gon,					min_yj_vat,					add_vat,						sub_vat,						chagam )
values
	(:sFdate,					:sTdate,					:sJasa,						'17',					 		:sDocCd,					
	 :dMaiChulSegum_g,		:dMaiChulSegum_v,		:dMaiChulSegum_Gita_g,	:dMaiChulSegum_Gita_v,	:dMaiChulYong_g,			:dMaiChulYong_Gita_g,	:dMaiChulHap,	
	 :dMaiipSegum_g,			:dMaiipSegum_v,		:dMaiipYj_g,				:dMaiipYj_v,				:dTaxAdd,					:dTaxSub,					:dResult) ;
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[사업자단위 과세표준-집계]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

Commit;

Return 1
end function

protected function integer wf_create_120 (string sfdate, string stdate, string sjasa);String sDocCd = 'I103600',sAddr,sChung,sHosu,sRentNm,sRentSano,sRentSdate,sRentEdate,sSano,sUpDown,sDongNm, sUptdate
Double dBoAmt,dWolAmt,dHapAmt,dBoIjaAmt,dRentAmt,dRentMamt,dIjaAmt,dArea
Int    iRowCount,k,iImCnt

delete from kfz_hometax_120
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부동산공급가액 명세서]')
	Return -1
else
	delete from kfz_hometax_120_1
		where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
end if
commit;

tab_htax.tabpage_120.dw_120.AcceptText()
iRowCount = tab_htax.tabpage_120.dw_120.RowCount()
if iRowCount <=0 then Return 1

sSano = tab_htax.tabpage_120.dw_120.GetItemString(1,"jasa_sano")
sAddr = tab_htax.tabpage_120.dw_120.GetItemString(1,"jasa_addr")
dBoAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(1,"bo_sum")
dWolAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(1,"wol_sum")
dHapAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(1,"hap_sum")
dBoIjaAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(1,"boija_sum")

insert into kfz_hometax_120
	(rpt_fr,		rpt_to,		jasa_cd,			sort_no,			data_gu,		doc_cd,
	 sernogu,	sojeji,		bojung_hap,		wolse_hap,		suip_hap,	subo_hap,		suwol_hap,  imdae_sano,   im_cnt, down_serno)
values
	(:sfDate,	:sTdate,		:sJasa,			1,					'17',			:sDocCd,
	 1,			:sAddr,		:dBoAmt,			:dWolAmt,		:dHapAmt,	:dBoIjaAmt,		0,				:sSano,		  :LiBsImCnt, '0000');
if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[부동산임대공급가액명세서-헤더]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if

For k= 1 To iRowcount
	
	sChung  = tab_htax.tabpage_120.dw_120.GetItemString(k,"chung")
	sHosu   = tab_htax.tabpage_120.dw_120.GetItemString(k,"hosu")
	sUpDown = tab_htax.tabpage_120.dw_120.GetItemString(k,"updowngbn")
	sDongNm = tab_htax.tabpage_120.dw_120.GetItemString(k,"dong_nm")
	
	dArea = tab_htax.tabpage_120.dw_120.GetItemNumber(k,"area")
	sRentNm = tab_htax.tabpage_120.dw_120.GetItemString(k,"rent_nm")
	sRentSano = tab_htax.tabpage_120.dw_120.GetItemString(k,"rent_sano")
	sRentSdate = tab_htax.tabpage_120.dw_120.GetItemString(k,"rent_sdate")
	sRentEdate = tab_htax.tabpage_120.dw_120.GetItemString(k,"rent_edate")
	dRentAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(k,"rent_amt")
	dRentMamt = tab_htax.tabpage_120.dw_120.GetItemNumber(k,"rent_mamt")
	dHapAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(k,"hap_amt")
	dIjaAmt = tab_htax.tabpage_120.dw_120.GetItemNumber(k,"ija_amt")
	
	sUptdate = tab_htax.tabpage_120.dw_120.GetItemString(k,"uptdate")
	IF IsNull(dRentAmt) THEN dRentAmt = 0
	IF IsNull(dRentMamt) THEN dRentMamt = 0
	IF IsNull(dHapAmt) THEN dHapAmt = 0
	IF IsNull(dIjaAmt) THEN dIjaAmt = 0
	
	if dHapAmt <> 0 or dIjaAmt <> 0 then
		insert into kfz_hometax_120_1
			(rpt_fr,			rpt_to,		jasa_cd,		sort_no,			data_gu,			doc_cd,			sernogu,
			 serno,			chung,		hosu,			area,				rent_nm,			rent_sano,		rent_sdate,
			 rent_edate,	amt,			mamt,			su_gye,			bo_ija,			su_wol,			updown_gbn, down_serno, dong_nm, 	uptdt)		
		values
			(:sFdate,		:sTdate,		:sJasa,		1,					'18',				:sDocCd,			1,
			 :k,				:sChung,		:sHosu,		:dArea,			:sRentNm,		:sRentSano,		:sRentSdate,
			 :sRentEdate,	:dRentAmt,	:dRentMamt,	:dHapAmt,		:dIjaAmt,		0,					:sUpDown ,  '0000',		:sDongNm,	:sUptdate);
		
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'[부동산임대공급가액 명세서(세부)]')
			w_mdi_frame.sle_msg.text = ''
			SetPointer(Arrow!)
			Return -1
		end if
	end if	
NEXT

Return 1
end function

protected function integer wf_create_153 (string sfdate, string stdate, string sjasa);String sDocCd ='I103300',sNotaxCd
Double dGonggongAn,dGongseAn,dBulseAn,dMesuSegum,dGongSegum,dMeseSegum,dBulchongJung,dGibulJung
Double dGasanJung,dGasanNapbu,dMesu,dGonAmt,dVatAmt
String sSayu
Int    iRowCount

//집계표
delete from kfz_hometax_153
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[공제받지 못할 매입세액-153]')
	Return -1
end if

tab_htax.tabpage_135.dw_135.AcceptText()
iRowCount = tab_htax.tabpage_135.dw_135.RowCount()
if iRowCount <=0 then Return 1

dMesuSegum = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"tot_cnt")
dGongSegum = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"tot_amt")
dMeseSegum = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"tot_vat")
if IsNull(dMesuSegum) then dMesuSegum = 0
if IsNull(dGongSegum) then dGongSegum = 0
if IsNull(dMeseSegum) then dMeseSegum = 0

dGonggongAn = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"sum_comm_gong")
dGongseAn = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"sum_comm_vat")
dBulseAn = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"sum_calc_bul")
if IsNull(dGonggongAn) then dGonggongAn = 0
if IsNull(dGongseAn) then dGongseAn = 0
if IsNull(dBulseAn) then dBulseAn = 0

//dBulchongJung = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"")
//dGibulJung = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"")
//dGasanJung = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"")
//dGasanNapbu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"")
if IsNull(dBulchongJung) then dBulchongJung = 0
if IsNull(dGibulJung) then dGibulJung = 0
if IsNull(dGasanJung) then dGasanJung = 0
if IsNull(dGasanNapbu) then dGasanNapbu = 0

IF dGonggongAn + dGongseAn + dBulseAn + dMesuSegum + dGongSegum + dMeseSegum + dBulchongJung + &
   dGibulJung + dGasanJung + dGasanNapbu = 0 THEN Return 1

insert into kfz_hometax_153
	(rpt_fr,				rpt_to,			jasa_cd,			data_gu,			doc_cd,
	 mesu_segum,		gong_segum,		mese_segum,		gonggong_an,	gongse_an,		bulse_an,
	 bulchong_jung,	gibul_jung,		gasan_jung,		gasan_napbu,	bigo)
values
	(:sFdate,			:sTdate,			:sJasa,			'17',				:sDocCd,
	 :dMesuSeGum,  	:dGongSeGum,	:dMeseSegum,	:dGonggongAn,	:dGongseAn,		:dBulseAn,
	 :dBulchongJung,	:dGibulJung,	:dGasanJung,	:dGasanNapbu,	'');

if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[공제받지 못할 매입세액]')
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return -1
end if
commit;

//명세
delete from kfz_hometax_153_1
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[공제받지 못할 매입세액-153_1]')
	Return -1
end if

//필요적 기재사항 누락등
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp1_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "01"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp1_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp1_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-필요적 기재사항 누락 등]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//사업과 직접 관련없는 지출
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp2_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "02"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp2_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp2_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-사업과 직접 관련없는 지출]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//비영업용 소형차량 구입등
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"count")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "03"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"maiip_tax_yong")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"maiip_tax_yong_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-비영업용 소형차량 구입]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//접대비및 이와 유사한 비용 관련
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp7_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "04"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp7_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp7_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-접대비및 이와 유사한 비용 관련]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//면세사업 관련
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp3_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "05"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp3_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp3_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-면세사업 관련]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//토지의 자본적 지출 관련
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp8_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "06"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp8_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp8_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-토지의 자본적 지출 관련]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//사업자등록전 매입세액
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp4_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "07"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp4_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp4_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-사업자등록전 매입세액]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF

//금거래계좌 미사용 관련 매입액 -- 2008년 8월 적용 시작
dMesu = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp9_cnt")
IF IsNull(dMesu) THEN dMesu = 0

IF dMeSu > 0 THEN
	sSaYu = "08"
	dGonAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp9_amt")
	dVatAmt = tab_htax.tabpage_135.dw_135.GetItemNumber(1,"comp9_vat")
	IF IsNull(dGonAmt) THEN dGonAmt = 0
	IF IsNull(dVatAmt) THEN dVatAmt = 0
	
	insert into kfz_hometax_153_1
		(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
		 sayu,			mesu,				gon_amt,		vat_amt,			bigo)
	values
		(:sFdate,		:sTdate,			:sJasa,		'18',				:sDocCd,
		 :sSaYu,			:dMesu,			:dGonAmt,	:dVatAmt,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-금거래계좌 미사용 관련 매입액]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
END IF
commit;
//금거래계좌 미사용 관련 매입액 -- 2008년 8월 적용 끝

//안분내역
delete from kfz_hometax_153_2
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[공제받지 못할 매입세액-안분내역]')
	Return -1
end if

Integer  k
String   sColName_Gong[5]   = {"comm_gong", "comm_gong2",  "comm_gong3",  "comm_gong4",  "comm_gong5"}
String   sColName_Vat[5]     = {"comm_vat",    "comm_vat2",     "comm_vat3",     "comm_vat4",    "comm_vat5"}
String   sColName_Total[5]   = {"tot_gong",     "tot_gong2",        "tot_gong3",       "tot_gong4",      "tot_gong5"}
String   sColName_NoTax[5]  = {"notax_gong",     "notax_gong2",        "notax_gong3",       "notax_gong4",      "notax_gong5"}
String   sColName_Bul[5]       = {"calc_bul",          "calc_bul2",        "calc_bul3",       "calc_bul4",      "calc_bul5"}

String  sSerno
Double dGong, dVat, dTotal, dNotax, dBul
for k = 1 to 5
	dGong   = 	tab_htax.tabpage_135.dw_135.GetItemNumber(1, sColName_Gong[k])
	dVat     = 	tab_htax.tabpage_135.dw_135.GetItemNumber(1, sColName_Vat[k])
	dTotal   =    tab_htax.tabpage_135.dw_135.GetItemNumber(1, sColName_Total[k])
	dNoTax  =   tab_htax.tabpage_135.dw_135.GetItemNumber(1, sColName_Notax[k])
	dBul      =   tab_htax.tabpage_135.dw_135.GetItemNumber(1, sColName_Bul[k])
	
	if IsNull(dGong) then dGong = 0
	if IsNull(dVat) then dVat = 0
	if IsNull(dTotal) then dTotal = 0
	if IsNull(dNoTax) then dNoTax = 0
	if IsNull(dBul) then dBul = 0
	
	sSerno = String(k,'000000')
	
	if dBul > 0 then
		insert into kfz_hometax_153_2
			(rpt_fr,			rpt_to,			jasa_cd,		data_gu,			doc_cd,
			 seqno,			ins_gong,		ins_vat,		tot_gong,		notax_gong,		bul_gong,		bigo)
		values
			(:sFdate,			:sTdate,			:sJasa,		'19',				:sDocCd,
			 :sSerno,			:dGong,			:dVat,  	    :dTotal,			:dNoTax,			:dBul,				'');
	
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'[공제받지 못할 매입세액-안분내역]')
			w_mdi_frame.sle_msg.text = ''
			SetPointer(Arrow!)
			Return -1
		end if		
	end if	
next
commit;

//정산내역
delete from kfz_hometax_153_3
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[공제받지 못할 매입세액-정산내역]')
	Return -1
end if

Double  dTotCommTax, dNoTaxRate, dTotBulVat, dGiBulTax, dAddTax

dTotCommTax = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "tot_comm_tax")
dNoTaxRate     = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "notax_rate")
dTotBulVat       = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "tot_bul_vat")
dGiBulTax         = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "gi_bul_tax")
dAddTax           = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "add_tax")

if IsNull(dTotCommTax) then dTotCommTax = 0
if IsNull(dNoTaxRate) then dNoTaxRate = 0
if IsNull(dTotBulVat) then dTotBulVat = 0
if IsNull(dGiBulTax) then dGiBulTax = 0
if IsNull(dAddTax) then dAddTax = 0

if dTotCommTax > 0 then
	insert into kfz_hometax_153_3
		(rpt_fr,			rpt_to,				jasa_cd,			data_gu,			doc_cd,
		 seqno,			tot_vat,				notax_rate,		bul_tax,			gi_bul_tax,			add_tax,		bigo)
	values
		(:sFdate,			:sTdate,				:sJasa,			'20',				:sDocCd,
		 '000001',		:dTotCommTax,	:dNoTaxRate,  	:dTotBulVat,		:dGiBulTax,			:dAddTax,	'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-정산내역]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if				
end if
commit;

//납부내역
delete from kfz_hometax_153_4
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[공제받지 못할 매입세액-납부내역]')
	Return -1
end if

Double  dMaiipVat, dMaiipDay, dRate, dAddMaiipVat

dMaiipVat = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "pay_maiip_vat")
dMaiipDay     = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "pay_day")
dRate       = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "pay_rate")
dAddMaiipVat         = tab_htax.tabpage_135.dw_135.GetItemNumber(1, "add_maiip_vat")

if IsNull(dMaiipVat) then dMaiipVat = 0
if IsNull(dMaiipDay) then dMaiipDay = 0
if IsNull(dRate) then dRate = 0
if IsNull(dAddMaiipVat) then dAddMaiipVat = 0

if dAddMaiipVat > 0 then
	insert into kfz_hometax_153_4
		(rpt_fr,			rpt_to,				jasa_cd,			data_gu,				doc_cd,
		 maiip_vat,		maiip_day,			updown_rate,	add_maiip_vat,		bigo)
	values
		(:sFdate,			:sTdate,				:sJasa,			'21',					:sDocCd,
		 :dMaiipVat,		:dMaiipDay,			:dRate,  			:dAddMaiipVat,		'');

	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[공제받지 못할 매입세액-납부내역]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if				
end if
commit;

Return 1
end function

protected function integer wf_create_112 (string sfdate, string stdate, string sjasa);String   sDocCd = 'I102800',sCvnas,sSaup,sOwner,sAddr,sDate,sBigo,sDsGbn
Double   dAmt,dVat
Integer  iRow,k

delete from kfz_hometax_112
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[대손공제(변제)신고서]')
	Return -1
end if

iRow = dw_rtv14.Retrieve(sfdate,stdate,sJasa,'1')
for k = 1 to iRow
	sDate  = dw_rtv14.GetItemString(k,"insu_dat")
	dAmt   = dw_rtv14.GetItemNumber(k,"dsamt")
	dVat   = dw_rtv14.GetItemNumber(k,"dsvat")
	sCvnas = dw_rtv14.GetItemString(k,"cvnas")
	sOwner = dw_rtv14.GetItemString(k,"ownam")
	sSaup  = dw_rtv14.GetItemString(k,"sano")
	sAddr  = dw_rtv14.GetItemString(k,"addr")
	sBigo  = dw_rtv14.GetItemString(k,"reson")	
	
	sDsGbn = '1'
	
	insert into kfz_hometax_112
		(rpt_fr,			rpt_to,			jasa_cd,			data_gu,				doc_cd,				
		 dsgbn,        seqno,								dsdt,					dsamt,				dsvat,				
		 cvnas,		   cvowner,			 saupno,			addr,					bigo )
	values
		(:sFdate,		:sTdate,			:sJasa,			'17',					:sDocCd,	
		 :sDsGbn,		trim(to_char(:k,'000000')),		:sDate,				:dAmt,				:dVat,		
		 :sCvnas,		:sOwner,			:sSaup,			:sAddr,				:sBigo);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[대손공제]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
next

iRow = dw_rtv14.Retrieve(sfdate,stdate,sJasa,'2')
for k = 1 to iRow
	sDate  = dw_rtv14.GetItemString(k,"insu_dat")
	dAmt   = dw_rtv14.GetItemNumber(k,"dsamt")
	dVat   = dw_rtv14.GetItemNumber(k,"dsvat")
	sCvnas = dw_rtv14.GetItemString(k,"cvnas")
	sOwner = dw_rtv14.GetItemString(k,"ownam")
	sSaup  = dw_rtv14.GetItemString(k,"sano")
	sAddr  = dw_rtv14.GetItemString(k,"addr")
	sBigo  = dw_rtv14.GetItemString(k,"reson")	
	
	sDsGbn = '2'
	
	insert into kfz_hometax_112
		(rpt_fr,			rpt_to,			jasa_cd,			data_gu,				doc_cd,				
		 dsgbn,        seqno,								dsdt,					dsamt,				dsvat,				
		 cvnas,		   cvowner,			 saupno,			addr,					bigo )
	values
		(:sFdate,		:sTdate,			:sJasa,			'17',					:sDocCd,	
		 :sDsGbn,		trim(to_char(:k,'000000')),		:sDate,				:dAmt,				:dVat,		
		 :sCvnas,		:sOwner,			:sSaup,			:sAddr,				:sBigo);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[대손변제]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
next

Return 1
end function

public subroutine wf_retrieve_112 ();string   sDatefrom,sDateto,sDate,sCvnas,sOwner,sSaup,sAddr,sBigo,sJasaCod,sJasaOwner
Integer  iRow,k
Double   dAmt,dVat

String   sDsCol1[2] ={"ds_dt1","ds_dt2"}
String   sDsCol2[2] ={"ds_amt1","ds_amt2"}
String   sDsCol3[2] ={"ds_vat1","ds_vat2"}
String   sDsCol4[2] ={"ds_saupnm1","ds_saupnm2"}
String   sDsCol5[2] ={"ds_owner1","ds_owner2"}
String   sDsCol6[2] ={"ds_saup1","ds_saup2"}
String   sDsCol7[2] ={"ds_addr1","ds_addr2"}
String   sDsCol8[2] ={"ds_bigo1","ds_bigo2"}

String   sDbCol1[2] ={"db_dt1","db_dt2"}
String   sDbCol2[2] ={"db_amt1","db_amt2"}
String   sDbCol3[2] ={"db_vat1","db_vat2"}
String   sDbCol4[2] ={"db_saupnm1","db_saupnm2"}
String   sDbCol5[2] ={"db_owner1","db_owner2"}
String   sDbCol6[2] ={"db_saup1","db_saup2"}
String   sDbCol7[2] ={"db_addr1","db_addr2"}
String   sDbCol8[2] ={"db_bigo1","db_bigo2"}

tab_htax.tabpage_112.dw_112.Reset()

dw_ip.AcceptText()

sDatefrom = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_edate"))
sJasaCod  = dw_ip.GetItemstring(dw_ip.getrow(),"code")

tab_htax.tabpage_112.dw_112.Retrieve(sJasaCod,sDateto)

iRow = dw_rtv14.Retrieve(sDatefrom,sDateto,sJasaCod,'1')

For k = 1 to iRow
	sDate  = dw_rtv14.GetItemString(k,"insu_dat")
	dAmt   = dw_rtv14.GetItemNumber(k,"dsamt")
	dVat   = dw_rtv14.GetItemNumber(k,"dsvat")
	sCvnas = dw_rtv14.GetItemString(k,"cvnas")
	sOwner = dw_rtv14.GetItemString(k,"ownam")
	sSaup  = dw_rtv14.GetItemString(k,"sano")
	sAddr  = dw_rtv14.GetItemString(k,"addr")
	sBigo  = dw_rtv14.GetItemString(k,"reson")
	
	if k > 2 then continue
	
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol1[k], sDate)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol2[k], dAmt)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol3[k], dVat)	
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol4[k], sCvnas)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol5[k], sOwner)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol6[k], sSaup)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol7[k], sAddr)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDsCol8[k], sBigo)
Next

iRow = dw_rtv14.Retrieve(sDatefrom,sDateto,sJasaCod,'2')
For k = 1 to iRow
	sDate  = dw_rtv14.GetItemString(k,"insu_dat")
	dAmt   = dw_rtv14.GetItemNumber(k,"dsamt")
	dVat   = dw_rtv14.GetItemNumber(k,"dsvat")
	sCvnas = dw_rtv14.GetItemString(k,"cvnas")
	sOwner = dw_rtv14.GetItemString(k,"ownam")
	sSaup  = dw_rtv14.GetItemString(k,"sano")
	sAddr  = dw_rtv14.GetItemString(k,"addr")
	sBigo  = dw_rtv14.GetItemString(k,"reson")
	
	if k > 2 then continue
	
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol1[k], sDate)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol2[k], dAmt)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol3[k], dVat)	
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol4[k], sCvnas)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol5[k], sOwner)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol6[k], sSaup)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol7[k], sAddr)
	tab_htax.tabpage_112.dw_112.SetItem(1,sDbCol8[k], sBigo)
Next

tab_htax.tabpage_112.dw_112.Object.DataWindow.Print.Preview = 'yes'


end subroutine

public function string wf_amtconv (decimal decamt);String  sAmt
Integer nLen

//소숫점 이하 삭제
sAmt = String(decAmt,'###')
nLen = Len(sAmt)
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

protected function integer wf_create_106 (string sfdate, string stdate, string sjasa, string srptcd, string srptdsc);String   sDocCd = 'I105800',sDocName,sBalName,sBalDate,sCurr,sGbn
Double   dExcRate,dAmtY,dAmtW,dRptAmtY,dRptAmtW
Integer  iRowCount,k
Long     lCurRow

delete from kfz_hometax_106
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[영세율첨부서류]')
	Return -1
end if

tab_htax.tabpage_106.dw_106.AcceptText()
iRowCount = tab_htax.tabpage_106.dw_106.RowCount()
if iRowCount <=0 then Return 1

For k= 1 To iRowcount
	sGbn = tab_htax.tabpage_106.dw_106.GetItemString(k,"sflag")
	
	if sGbn = '1' then						/*자료*/
		lCurRow   = tab_htax.tabpage_106.dw_106.GetItemNumber(k,"icurrow")
		sDocName  = tab_htax.tabpage_106.dw_106.GetItemString(k,"vouc_name")
		sBalName  = tab_htax.tabpage_106.dw_106.GetItemString(k,"balgup")
		sBalDate  = tab_htax.tabpage_106.dw_106.GetItemString(k,"gey_date")
		sCurr     = tab_htax.tabpage_106.dw_106.GetItemString(k,"curr")
		dExcRate  = tab_htax.tabpage_106.dw_106.GetItemNumber(k,"exc_rate")
		dAmtY     = tab_htax.tabpage_106.dw_106.GetItemNumber(k,"for_amt")
		dAmtW     = tab_htax.tabpage_106.dw_106.GetItemNumber(k,"gon_amt")
		if IsNull(dExcRate) then dExcRate = 0
		if IsNull(dAmtY) then dAmtY = 0
		if IsNull(dAmtW) then dAmtW = 0
		
		insert into kfz_hometax_106
			(rpt_fr,				rpt_to,				jasa_cd,			sort_no,			data_gu,			doc_cd,		rpt_cod,			rpt_dsc,
			 serno,				docname,				balname,			baldate,			sdate,			curr,
			 yrate,				yamt,					wamt,				rpt_yamt,		rpt_wamt,		bigo)
		values
			(:sFdate,			:sTdate,				:sJasa,			1,					'17',				:sDocCd,		:srptcd,			:srptdsc,
			 :lCurRow,			:sDocName,			:sBalName,		:sBalDate,		:sBalDate,		:sCurr,
			 :dExcRate,			:dAmtY,				:dAmtW,			:dAmtY,			:dAmtW,			' ') ;
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'[영세율첨부서류]')
			w_mdi_frame.sle_msg.text = ''
			SetPointer(Arrow!)
			Return -1
		end if
		
	end if
Next

Return 1
end function

public function double wf_get_jong_amt (string sfrom, string sto, string sjasacod);Double  dAmount
		
if   dw_ip.GetItemstring(1,"rpt_gubun") = '2'  then		
	select  sum(nvl( taxno_79 ,0))	into :dAmount
		from kfz_hometax_101_1
		where rpt_fr = :sFrom and rpt_to = :sTo and jasa_cd <> :sJasaCod ;
	if sqlca.sqlcode <> 0 then
		dAmount = 0
	else
		if IsNull(dAmount) then dAmount = 0
	end if
	
else
	dAmount = 0
end if

Return dAmount
end function

protected function integer wf_create_117 (string sfdate, string stdate, string sjasa);String sDocCd = 'I103400'
DOUBLE dTotal_Card,dTotal_Cash,dTax_Card,dTax_Cash,dNotax_Card,dNotax_Cash,dBong_Card,dBong_Cash,dCard_Tax,dCard_Geysanse

delete from kfz_hometax_117
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[신용카드매출전표발행금액집계표]')
	Return -1
end if
commit;

tab_htax.tabpage_117.dw_117.AcceptText()
dTotal_Card = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"hap_card")
dTotal_Cash = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"hap_cash")
dTax_Card   = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"card_tax")
dTax_Cash   = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"cash_tax")
dNotax_Card = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"card_young")
dNotax_Cash = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"cash_young")
dBong_Card  = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"card_bong")
dBong_Cash  = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"cash_bong")
dCard_Tax   = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"tax")
dCard_Geysanse = tab_htax.tabpage_117.dw_117.GetItemNumber(1,"geysanse")

if IsNull(dTotal_Card) then dTotal_Card = 0
if IsNull(dTotal_Cash) then dTotal_Cash = 0
if IsNull(dTax_Card) then dTax_Card = 0
if IsNull(dTax_Cash) then dTax_Cash = 0
if IsNull(dNotax_Card) then dNotax_Card = 0
if IsNull(dNotax_Cash) then dNotax_Cash = 0
if IsNull(dBong_Card) then dBong_Card = 0
if IsNull(dBong_Cash) then dBong_Cash = 0
if IsNull(dCard_Tax) then dCard_Tax = 0
if IsNull(dCard_Geysanse) then dCard_Geysanse = 0

if dTotal_Card + dTotal_Cash <> 0 then
	insert into kfz_hometax_117
		(rpt_fr,			rpt_to,		jasa_cd,		data_gu,				doc_cd,
		 total_amt,										total_card,			total_cash,		
		 total_tax,										tax_card,			tax_cash,
		 total_notax,									notax_card,			notax_cash,		
		 total_bong,									bong_card,			bong_cash,
		 card_tax,										card_geysanse)
	values
		(:sfDate,	:sTdate,		:sJasa,			'17',					:sDocCd,
		 :dTotal_Card + :dTotal_Cash,			 	:dTotal_Card,		:dTotal_Cash,		
		 :dTax_Card + :dTax_Cash,					:dTax_Card,			:dTax_Cash,
		 :dNotax_Card + :dNotax_Cash,				:dNotax_Card,		:dNotax_Cash,
		 :dBong_Card + :dBong_Cash,				:dBong_Card,		:dBong_Cash,
		 :dCard_Tax,									:dCard_Geysanse );
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[신용카드매출전표 발행금액집계표]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

Return 1
end function

protected function integer wf_create_177 (string sfdate, string stdate, string sjasa);String sDocCd = 'I104000'
DOUBLE dVat01, dVat02, dVat03, dVat04, dVat05, dVat06, dVat07, dVat08, dVat09, dVat10, dVat11, dVat12, dVat13, dVat14, dVat15, dVat16, dYoungHap

delete from kfz_hometax_177
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[영세율매출명세서]')
	Return -1
end if
commit;

tab_htax.tabpage_177.dw_177.AcceptText()

dVat01    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a01")
dVat02    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a02")
dVat03    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a03")
dVat04    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a04")
dVat05    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a05")
dVat06    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a06")
dVat07    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a07")
dVat08    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a08")
dVat09    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a09")
dVat10    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a10")
dVat11    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a11")
dVat12    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a12")
dVat13    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a13")
dVat14    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a14")
dVat15    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a15")
dVat16    = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"a16")

dYoungHap = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"total")

if IsNull(dYoungHap) then dYoungHap = 0
if IsNull(dVat01) then dVat01 = 0
if IsNull(dVat02) then dVat02 = 0
if IsNull(dVat03) then dVat03 = 0
if IsNull(dVat04) then dVat04 = 0
if IsNull(dVat05) then dVat05 = 0
if IsNull(dVat06) then dVat06 = 0
if IsNull(dVat07) then dVat07 = 0
if IsNull(dVat08) then dVat08 = 0
if IsNull(dVat09) then dVat09 = 0
if IsNull(dVat10) then dVat10 = 0
if IsNull(dVat11) then dVat11 = 0
if IsNull(dVat12) then dVat12 = 0
if IsNull(dVat13) then dVat13 = 0
if IsNull(dVat14) then dVat14 = 0
if IsNull(dVat15) then dVat15 = 0
if IsNull(dVat16) then dVat16 = 0

if dYoungHap <> 0 then
	insert into kfz_hometax_177
		(rpt_fr,			rpt_to,		jasa_cd,				data_gu,		doc_cd,
		 vat_direct,	vat_jong,	vat_sinyong,		vat04,		vat05,		vat06,		vat07,		vat08,		vat09,		vat10, 		
		 vat11,			vat12,		vat13,				vat14,		vat15,		vat16,		vat_hap,		young_hap)
	values
		(:sfDate,		:sTdate,		:sJasa,					'17',		:sDocCd,
		 :dVat01,		:dVat02,		:dVat03,				:dVat04,		:dVat05,		:dVat06,		:dVat07,		:dVat08,		:dVat09,		:dVat10, 	
		 :dVat11,		:dVat12,		:dVat13,				:dVat14,		:dVat15,		:dVat16,		:dYoungHap,	:dYoungHap);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[영세율매출명세서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

Return 1
end function

protected function integer wf_create_101_3 (string sfdate, string stdate, string sjasa);String 	sDocCd = 'I103200',sSubGbn
Double   dAmount, dVatAmt
Integer  k = 0

delete from kfz_new_hometax_101_3
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부가세신고서-공제신고서]')
	Return -1
end if

tab_htax.tabpage_101_1.dw_101_1.AcceptText()						
dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_gong1")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_vat1")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '211'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_cardaset_gong")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_cardaset_vat")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '212'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_wuije_gon")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"vat_wuije_vat")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '230'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_gong2")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_vat2")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '270'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = 0
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_vat3")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '292'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = 0
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_maip_vat4")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '293'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = 0
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_vat4")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '310'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = 0
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_vat7")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '321'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = 0
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"gita_vat6")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '361'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax15_g")
dVatAmt = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"tax16_v")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sSubGbn = '410'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_3
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 sub_code,		seqno,			sub_amt,		sub_vat )
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'14',				:sDocCd,			:k,			 :sSubGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-공제신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

Return 1
end function

protected function integer wf_create_101_4 (string sfdate, string stdate, string sjasa);String 	sDocCd = 'I103200',sAddGbn
Double   dAmount, dVatAmt
Integer  k = 0

delete from kfz_new_hometax_101_4
	where rpt_fr = :sfdate and rpt_to = :stdate and jasa_cd = :sJasa ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(12,'[부가세신고서-가산세신고서]')
	Return -1
end if

tab_htax.tabpage_101_1.dw_101_1.AcceptText()						
dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong1")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat1")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B1100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong10")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat10")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B3100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong11")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat11")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B3200'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong6")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat6")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B3400'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong8")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat8")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B4300'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong9")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat9")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B4100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong2")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat2")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B5100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong20")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat20")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B5300'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong3")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat3")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A2110'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong30")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat30")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A2210'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong31")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat31")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A3110'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong32")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat32")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A3210'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong4")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat4")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A7100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong5")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat5")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'A4200'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong7")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat7")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B7100'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong90")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat90")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B7200'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong145")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat145")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B7300'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

dAmount = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_gong147")
dVatAmt = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"add_vat147")
if IsNull(dAmount) then dAmount = 0
if IsNull(dVatAmt) then dVatAmt = 0
if dAmount <> 0 then
	sAddGbn = 'B7400'	
		
	k = k + 1	
	insert into kfz_new_hometax_101_4
		(rpt_fr,		rpt_to,			jasa_cd,		sort_no,			data_gu,			doc_cd,			serno,		 add_code,		seqno,			add_amt,		add_vat)
	values
		(:sFdate,	:sTdate,			:sJasa,		1,					'13',				:sDocCd,			:k,			 :sAddGbn,		:k,				:dAmount,	:dVatAmt);
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'[부가세신고서-가산세신고서]')
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return -1
	end if
end if

Return 1
end function

on w_ktxa95.create
int iCurrent
call super::create
this.tab_htax=create tab_htax
this.p_create=create p_create
this.dw_text=create dw_text
this.dw_rtv12=create dw_rtv12
this.dw_rtv13=create dw_rtv13
this.dw_rtv14=create dw_rtv14
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_htax
this.Control[iCurrent+2]=this.p_create
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.dw_rtv12
this.Control[iCurrent+5]=this.dw_rtv13
this.Control[iCurrent+6]=this.dw_rtv14
end on

on w_ktxa95.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_htax)
destroy(this.p_create)
destroy(this.dw_text)
destroy(this.dw_rtv12)
destroy(this.dw_rtv13)
destroy(this.dw_rtv14)
end on

event open;
ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF

String sPath,sVatGisu,sStart,sEnd,sJasa,sSano,sJasaName,sName,sUptae,sUpjong,sAddr,sresident,sOpenDate,&
		 sMainJong

/*저장위치*/
select dataname	into :sPath	from syscnfg where sysgu = 'A' and serial = 15 and lineno = '2';
if sPath = '' or IsNull(sPath) then sPath = 'c:\'

SELECT "VNDMST"."CVCOD",   "VNDMST"."SANO",   "VNDMST"."OWNAM",   
		 "VNDMST"."CVNAS",   "VNDMST"."UPTAE",  "VNDMST"."JONGK",
		 NVL("VNDMST"."ADDR1",' ') || NVL("VNDMST"."ADDR2",' ') ,"VNDMST"."RESIDENT", "VNDMST"."CDATE" 
	INTO :sJasa,   			:sSano,   			 :sName,   
        :sJasaName,   		:sUptae,   			 :sUpjong,   
        :sAddr,															   :sresident,				:sOpenDate
	FROM "VNDMST","SYSCNFG"  
   WHERE "VNDMST"."CVCOD" = SUBSTR("SYSCNFG"."DATANAME",1,6) AND
			"SYSCNFG"."SYSGU" = 'C' AND
			"SYSCNFG"."SERIAL" = 4 AND "SYSCNFG"."LINENO" = '1';

sVatGisu = F_Get_VatGisu(gs_saupj,f_today())
										
SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
	INTO :sStart,								:sEnd  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;

dw_ip.SetItem(dw_ip.GetRow(),"vatgisu",  sVatGisu)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_sdate",Left(f_Today(),4)+sStart)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_edate",Left(f_Today(),4)+sEnd)
dw_ip.SetItem(dw_ip.GetRow(),"tax_from",Left(f_Today(),4)+sStart) //2008.01.24추가 - 계산서 시작일

String sAddPath
select nvl(rfna5,'') into :sAddPath from reffpf where rfcod = 'JA' and rfgub = :sJasa;
if sAddPath = '' or IsNull(sAddPath) then
	dw_ip.SetItem(dw_ip.GetRow(),"spath",   sPath)
else
	dw_ip.SetItem(dw_ip.GetRow(),"spath",   sPath + sAddPath + '\')
end if

dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_cdate", F_today())
dw_ip.SetItem(dw_ip.GetRow(),"code",                sJasa)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_saupno",sSano)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_sname",sName)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_sangho",sJasaName)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_uptae",sUptae)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_upjong",sUpjong)
dw_ip.SetItem(dw_ip.GetRow(),"kfz_vat_title_addr",sAddr)
dw_ip.SetItem(dw_ip.GetRow(),"resident",          sresident)
dw_ip.SetItem(dw_ip.GetRow(),"opendate",          sOpenDate)

/*주업종코드*/
select rfna5 into :sMainJong from reffpf where rfcod = 'JA' and rfgub = :sJasa;
if sMainJong = '' or IsNull(sMainJong) then
	select dataname	into :sMainJong	from syscnfg where sysgu = 'A' and serial = 15 and lineno = '5';
end if

dw_ip.SetItem(dw_ip.GetRow(),"main_upcod",        sMainJong)

dw_ip.SetColumn("kfz_vat_title_sdate")
dw_ip.SetFocus()

tab_htax.tabpage_101.dw_101.SetTransObject(SQLCA)
tab_htax.tabpage_101_1.dw_101_1.SetTransObject(SQLCA)
tab_htax.tabpage_106.dw_106.SetTransObject(SQLCA)
tab_htax.tabpage_112.dw_112.SetTransObject(SQLCA)
tab_htax.tabpage_115.dw_115.SetTransObject(SQLCA)
tab_htax.tabpage_108.dw_108.SetTransObject(SQLCA)
tab_htax.tabpage_135.dw_135.SetTransObject(SQLCA)
tab_htax.tabpage_150.dw_150.SetTransObject(SQLCA)
tab_htax.tabpage_120.dw_120.SetTransObject(SQLCA)
tab_htax.tabpage_117.dw_117.SetTransObject(SQLCA)
tab_htax.tabpage_177.dw_177.SetTransObject(SQLCA)

dw_text.SetTransObject(Sqlca)
dw_rtv12.SetTransObject(Sqlca)
dw_rtv13.SetTransObject(Sqlca)
dw_rtv14.SetTransObject(Sqlca)

tab_htax.SelectedTab = 1

//전자신고 포함 여부(Y:제외)
select nvl(rfna2,'N')  into :LsHomeTaxTag01 from reffpf where rfcod = 'TD' and rfgub = '01';		//계산서
if LsHomeTaxTag01 = '' or IsNull(LsHomeTaxTag01) then LsHomeTaxTag01 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag02 from reffpf where rfcod = 'TD' and rfgub = '02';		//수출실적
if LsHomeTaxTag02 = '' or IsNull(LsHomeTaxTag02) then LsHomeTaxTag02 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag03 from reffpf where rfcod = 'TD' and rfgub = '03';		//사업장과세표준
if LsHomeTaxTag03 = '' or IsNull(LsHomeTaxTag03) then LsHomeTaxTag03 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag04 from reffpf where rfcod = 'TD' and rfgub = '04';		//영세율 첨부서류
if LsHomeTaxTag04 = '' or IsNull(LsHomeTaxTag04) then LsHomeTaxTag04 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag05 from reffpf where rfcod = 'TD' and rfgub = '05';		//건물등감가상각자산
if LsHomeTaxTag05 = '' or IsNull(LsHomeTaxTag05) then LsHomeTaxTag05 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag06 from reffpf where rfcod = 'TD' and rfgub = '06';		//신용카드수취명세
if LsHomeTaxTag06 = '' or IsNull(LsHomeTaxTag06) then LsHomeTaxTag06 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag07 from reffpf where rfcod = 'TD' and rfgub = '07';		//부동산임대공급가액
if LsHomeTaxTag07 = '' or IsNull(LsHomeTaxTag07) then LsHomeTaxTag07 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag08 from reffpf where rfcod = 'TD' and rfgub = '08';		//대손공제신고서
if LsHomeTaxTag08 = '' or IsNull(LsHomeTaxTag08) then LsHomeTaxTag08 = 'N'

select nvl(rfna2,'N')  into :LsHomeTaxTag09 from reffpf where rfcod = 'TD' and rfgub = '09';		//공제받지못할 매입세액
if LsHomeTaxTag09 = '' or IsNull(LsHomeTaxTag09) then LsHomeTaxTag09 = 'N'

//전자세금계산서 공제신고서 - 2009년 2기확정 추가:2010.01
select nvl(rfna2,'N')  into :LsHomeTaxTag0A from reffpf where rfcod = 'TD' and rfgub = '0A';		//전자세금계산서 공제신고서
if LsHomeTaxTag0A = '' or IsNull(LsHomeTaxTag0A) then LsHomeTaxTag0A = 'N'
//
//신용카드매출전표 발행집계표
select nvl(rfna2,'N')  into :LsHomeTaxTag0B from reffpf where rfcod = 'TD' and rfgub = '0B';		//신용카드매출전표 발행금액
if LsHomeTaxTag0B = '' or IsNull(LsHomeTaxTag0B) then LsHomeTaxTag0B = 'N'

//내국신용장.구매확인서
select nvl(rfna2,'N')  into :LsHomeTaxTag0C from reffpf where rfcod = 'TD' and rfgub = '0C';		//내국신용장.구매확인서
if LsHomeTaxTag0C = '' or IsNull(LsHomeTaxTag0C) then LsHomeTaxTag0C = 'N'

//원산지확인서
select nvl(rfna2,'N')  into :LsHomeTaxTag0D from reffpf where rfcod = 'TD' and rfgub = '0D';		//원산지확인서
if LsHomeTaxTag0D = '' or IsNull(LsHomeTaxTag0D) then LsHomeTaxTag0D = 'N'

if LsHomeTaxTag04 = 'N' then 
	dw_ip.Modify("t_jechul.visible = 1")
else
	dw_ip.Modify("t_jechul.visible = 0")	
end if


end event

type p_preview from w_standard_print`p_preview within w_ktxa95
boolean visible = false
integer x = 4480
integer y = 416
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_ktxa95
integer x = 4453
integer y = 12
integer taborder = 0
end type

type p_print from w_standard_print`p_print within w_ktxa95
integer x = 4283
integer y = 12
integer taborder = 0
end type

event p_print::clicked;gi_page = 1

IF tab_htax.SelectedTab = 1 THEN					/*부가세신고서(갑)*/
	OpenWithParm(w_print_options, tab_htax.tabpage_101.dw_101)
	
ELSEIF tab_htax.SelectedTab = 2 THEN			/*부가세신고서(을)*/
	OpenWithParm(w_print_options, tab_htax.tabpage_101_1.dw_101_1)

ELSEIF tab_htax.SelectedTab = 3 THEN			/*사업장별 과세표준*/
	OpenWithParm(w_print_options, tab_htax.tabpage_115.dw_115)
	
ELSEIF tab_htax.SelectedTab = 4 then			/*사업자단위 신고*/		
	OpenWithParm(w_print_options, tab_htax.tabpage_150.dw_150)	
			
ELSEIF tab_htax.SelectedTab = 5 THEN			/*영세율첨부서류*/
	OpenWithParm(w_print_options, tab_htax.tabpage_106.dw_106)
	
ELSEIF tab_htax.SelectedTab = 6 THEN			/*건물취득명세서*/	
	OpenWithParm(w_print_options, tab_htax.tabpage_108.dw_108)
			
ELSEIF tab_htax.SelectedTab = 7 THEN			/*부동산임대공급가액 명세서*/
	OpenWithParm(w_print_options, tab_htax.tabpage_120.dw_120)	

ELSEIF tab_htax.SelectedTab = 8 THEN			/*대손공제(변제)*/
	OpenWithParm(w_print_options, tab_htax.tabpage_112.dw_112)	

ELSEIF tab_htax.SelectedTab = 9 then			/*공제받지 못할 매입세액*/		
	OpenWithParm(w_print_options, tab_htax.tabpage_135.dw_135)	
ELSEIF tab_htax.SelectedTab = 11 then			/*신용카드매출전표발행금액집계표*/	
	OpenWithParm(w_print_options, tab_htax.tabpage_117.dw_117)
ELSEIF tab_htax.SelectedTab = 12 then			/*원산지확인서*/		
	OpenWithParm(w_print_options, tab_htax.tabpage_117.dw_117)
ELSEIF tab_htax.SelectedTab = 13 then			/*영세율매출*/		
	OpenWithParm(w_print_options, tab_htax.tabpage_177.dw_177)	
END IF

end event

type p_retrieve from w_standard_print`p_retrieve within w_ktxa95
integer x = 3936
integer y = 12
integer taborder = 0
end type



type sle_msg from w_standard_print`sle_msg within w_ktxa95
integer x = 384
end type



type st_10 from w_standard_print`st_10 within w_ktxa95
end type



type dw_print from w_standard_print`dw_print within w_ktxa95
integer x = 4878
integer y = 596
string dataobject = "dw_ktxa24p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa95
integer x = 9
integer y = 12
integer width = 4631
integer height = 336
integer taborder = 0
string dataobject = "dw_ktxa241"
end type

event dw_ip::itemchanged;String ls_saupno,ls_sanho, ls_name, sVatGisu, sStart, sEnd, sCommJasa, snull,s_jasacode,&
		 ls_uptae,ls_upjong,ls_addr1,ls_addr2,ls_resident,ls_opendate, sRate

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
		this.SetItem(this.GetRow(),"tax_from",sYYYY+sStart)
	END IF
END IF

IF this.GetColumnName() ="kfz_vat_title_sdate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"거래기간")
		this.SetItem(1,"kfz_vat_title_sdate",snull)
		this.SetItem(1,"tax_from",snull)              //2008.01.24추가
		Return 1
	ELSE
		OBJECT.TAX_FROM[GETROW()] = this.GetText()    //2008.01.24추가
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
		this.SetItem(this.GetRow(),"opendate",snull)
		Return
	END IF
	
  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2","VNDMST"."RESIDENT", "VNDMST"."CDATE"  
   INTO :ls_saupno        ,:ls_name        ,:ls_sanho       ,:ls_uptae,   
        :ls_upjong        ,:ls_addr1       ,:ls_addr2			,:ls_resident,			 :ls_opendate
   FROM "VNDMST"  
  	WHERE "VNDMST"."CVCOD" = :s_jasacode   ;
	
	IF IsNull(ls_addr1) THEN
		ls_addr1 =""
	END IF
	
	IF IsNull(ls_addr2) THEN
		ls_addr2 =""
	END IF
	
	this.SetItem(this.GetRow(),"kfz_vat_title_saupno",ls_saupno)
	this.SetItem(this.GetRow(),"kfz_vat_title_sname", ls_name)
	this.SetItem(this.GetRow(),"kfz_vat_title_sangho",ls_sanho)
	this.SetItem(this.GetRow(),"resident",            ls_resident)
	this.SetItem(this.GetRow(),"kfz_vat_title_uptae", ls_uptae)
	this.SetItem(this.GetRow(),"kfz_vat_title_upjong",ls_upjong)
	this.SetItem(this.GetRow(),"kfz_vat_title_addr",  ls_addr1+ls_addr2)
	this.SetItem(this.GetRow(),"opendate",            ls_opendate)
	
	/*저장위치*/
	String sPath,sAddPath
	select dataname	into :sPath	from syscnfg where sysgu = 'A' and serial = 15 and lineno = '2';
	if sPath = '' or IsNull(sPath) then sPath = 'c:\'
	
	select rfna5 into :sAddPath from reffpf where rfcod = 'JA' and rfgub = :s_jasacode;	
	
	if sAddPath = '' or IsNull(sAddPath) then
		dw_ip.SetItem(dw_ip.GetRow(),"spath",   sPath)
	else
		dw_ip.SetItem(dw_ip.GetRow(),"spath",   sPath + sAddPath + '\')
	end if
	dw_ip.SetItem(dw_ip.GetRow(),"main_upcod",   sAddPath)
END IF

IF this.GetColumnName() = 'prev_rate' then
	sRate = this.GetText()
	
	IF tab_htax.SelectedTab = 1 THEN					/*부가세신고서(갑)*/
		tab_htax.tabpage_101.dw_101.Modify("Datawindow.Zoom=" + sRate);		
	ELSEIF tab_htax.SelectedTab = 2 THEN			/*부가세신고서(을)*/
		 tab_htax.tabpage_101_1.dw_101_1.Modify("Datawindow.Zoom=" + sRate);	
	ELSEIF tab_htax.SelectedTab = 3 THEN			/*사업장별 과세표준*/
		tab_htax.tabpage_115.dw_115.Modify("Datawindow.Zoom=" + sRate);
	ELSEIF tab_htax.SelectedTab = 4 THEN			/*사업자단위*/
		tab_htax.tabpage_150.dw_150.Modify("Datawindow.Zoom=" + sRate);		
	ELSEIF tab_htax.SelectedTab = 5 THEN			/*영세율첨부서류*/
		tab_htax.tabpage_106.dw_106.Modify("Datawindow.Zoom=" + sRate);		
	ELSEIF tab_htax.SelectedTab = 6 THEN			/*건물취득*/	
		tab_htax.tabpage_108.dw_108.Modify("Datawindow.Zoom=" + sRate);				
	ELSEIF tab_htax.SelectedTab = 7 THEN			/*부동산임대공급가액 명세서*/
		tab_htax.tabpage_120.dw_120.Modify("Datawindow.Zoom=" + sRate);
	ELSEIF tab_htax.SelectedTab = 8 then			/*공제받지 못할 매입세액*/
		tab_htax.tabpage_135.dw_135.Modify("Datawindow.Zoom=" + sRate);		
	ELSEIF tab_htax.SelectedTab = 10 THEN			/*신용카드발행*/	
		tab_htax.tabpage_117.dw_117.Modify("Datawindow.Zoom=" + sRate);
	ELSEIF tab_htax.SelectedTab = 11 THEN			/*대손공제(변제)*/
		tab_htax.tabpage_112.dw_112.Modify("Datawindow.Zoom=" + sRate);
	ELSEIF tab_htax.SelectedTab = 12 THEN			/*영세율매출*/
		tab_htax.tabpage_177.dw_177.Modify("Datawindow.Zoom=" + sRate);
	END IF
end if


end event

type dw_list from w_standard_print`dw_list within w_ktxa95
boolean visible = false
integer x = 73
integer y = 2788
integer width = 1696
integer height = 128
integer taborder = 0
boolean titlebar = true
string title = "전자신고"
string dataobject = "dw_ktxa242"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
end type

type tab_htax from tab within w_ktxa95
integer x = 27
integer y = 356
integer width = 4585
integer height = 1852
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_101 tabpage_101
tabpage_101_1 tabpage_101_1
tabpage_115 tabpage_115
tabpage_150 tabpage_150
tabpage_106 tabpage_106
tabpage_108 tabpage_108
tabpage_120 tabpage_120
tabpage_112 tabpage_112
tabpage_135 tabpage_135
tabpage_117 tabpage_117
tabpage_177 tabpage_177
end type

on tab_htax.create
this.tabpage_101=create tabpage_101
this.tabpage_101_1=create tabpage_101_1
this.tabpage_115=create tabpage_115
this.tabpage_150=create tabpage_150
this.tabpage_106=create tabpage_106
this.tabpage_108=create tabpage_108
this.tabpage_120=create tabpage_120
this.tabpage_112=create tabpage_112
this.tabpage_135=create tabpage_135
this.tabpage_117=create tabpage_117
this.tabpage_177=create tabpage_177
this.Control[]={this.tabpage_101,&
this.tabpage_101_1,&
this.tabpage_115,&
this.tabpage_150,&
this.tabpage_106,&
this.tabpage_108,&
this.tabpage_120,&
this.tabpage_112,&
this.tabpage_135,&
this.tabpage_117,&
this.tabpage_177}
end on

on tab_htax.destroy
destroy(this.tabpage_101)
destroy(this.tabpage_101_1)
destroy(this.tabpage_115)
destroy(this.tabpage_150)
destroy(this.tabpage_106)
destroy(this.tabpage_108)
destroy(this.tabpage_120)
destroy(this.tabpage_112)
destroy(this.tabpage_135)
destroy(this.tabpage_117)
destroy(this.tabpage_177)
end on

type tabpage_101 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "부가세신고서(갑)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_101 dw_101
end type

on tabpage_101.create
this.rr_1=create rr_1
this.dw_101=create dw_101
this.Control[]={this.rr_1,&
this.dw_101}
end on

on tabpage_101.destroy
destroy(this.rr_1)
destroy(this.dw_101)
end on

type rr_1 from roundrectangle within tabpage_101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4507
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_101 from datawindow within tabpage_101
integer x = 46
integer y = 60
integer width = 4475
integer height = 1640
integer taborder = 50
string title = "none"
string dataobject = "dw_ktxa24p1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event editchanged;Double dJongAmt

IF dwo.name <> 'chong_v' then
	this.AcceptText()
	
	dJongAmt = wf_Get_Jong_Amt(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_sdate"),dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_edate"),dw_ip.GetItemstring(dw_ip.getrow(),"code"))

	if   dw_ip.GetItemstring(1,"rpt_gubun") = '2'  OR dw_ip.GetItemstring(1,"rpt_gubun") = '0' then		
		this.SetItem(1,"chong_v", this.GetItemNumber(1,"calc_21") + dJongAmt)
	end if	
end if
end event

event itemerror;Return 1
end event

type tabpage_101_1 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "부가세신고서(을)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_101_1 dw_101_1
end type

on tabpage_101_1.create
this.rr_2=create rr_2
this.dw_101_1=create dw_101_1
this.Control[]={this.rr_2,&
this.dw_101_1}
end on

on tabpage_101_1.destroy
destroy(this.rr_2)
destroy(this.dw_101_1)
end on

type rr_2 from roundrectangle within tabpage_101_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4439
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_101_1 from datawindow within tabpage_101_1
integer x = 59
integer y = 60
integer width = 4384
integer height = 1636
integer taborder = 60
string title = "none"
string dataobject = "dw_ktxa24p1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;Double dJongAmt

this.AcceptText()

tab_htax.tabpage_101.dw_101.SetItem(1,"tax15_v", tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"calc_47v") )

dJongAmt = wf_Get_Jong_Amt(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_sdate"),dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_edate"),dw_ip.GetItemstring(dw_ip.getrow(),"code"))
	
if   dw_ip.GetItemstring(1,"rpt_gubun") = '2'  OR dw_ip.GetItemstring(1,"rpt_gubun") = '0' then		
	tab_htax.tabpage_101.dw_101.SetItem(1,"chong_v", tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_21") + dJongAmt )
end if

end event

type tabpage_115 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "사업장별 과세표준"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_115 dw_115
end type

on tabpage_115.create
this.rr_4=create rr_4
this.dw_115=create dw_115
this.Control[]={this.rr_4,&
this.dw_115}
end on

on tabpage_115.destroy
destroy(this.rr_4)
destroy(this.dw_115)
end on

type rr_4 from roundrectangle within tabpage_115
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4439
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_115 from datawindow within tabpage_115
integer x = 46
integer y = 52
integer width = 4393
integer height = 1644
integer taborder = 60
string title = "none"
string dataobject = "dw_ktxa24p3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_150 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "사업자단위신고"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_7 rr_7
dw_150 dw_150
end type

on tabpage_150.create
this.rr_7=create rr_7
this.dw_150=create dw_150
this.Control[]={this.rr_7,&
this.dw_150}
end on

on tabpage_150.destroy
destroy(this.rr_7)
destroy(this.dw_150)
end on

type rr_7 from roundrectangle within tabpage_150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 36
integer width = 4530
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_150 from datawindow within tabpage_150
integer x = 27
integer y = 48
integer width = 4498
integer height = 1644
integer taborder = 70
string dataobject = "dw_ktxa24p7"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_106 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "영세율첨부서류"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_106 dw_106
end type

on tabpage_106.create
this.rr_3=create rr_3
this.dw_106=create dw_106
this.Control[]={this.rr_3,&
this.dw_106}
end on

on tabpage_106.destroy
destroy(this.rr_3)
destroy(this.dw_106)
end on

type rr_3 from roundrectangle within tabpage_106
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4439
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_106 from datawindow within tabpage_106
integer x = 46
integer y = 56
integer width = 4398
integer height = 1632
integer taborder = 70
string title = "none"
string dataobject = "dw_ktxa24p2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_108 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "건물등감가상각자산취득명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_108 dw_108
end type

on tabpage_108.create
this.rr_5=create rr_5
this.dw_108=create dw_108
this.Control[]={this.rr_5,&
this.dw_108}
end on

on tabpage_108.destroy
destroy(this.rr_5)
destroy(this.dw_108)
end on

type rr_5 from roundrectangle within tabpage_108
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4439
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_108 from datawindow within tabpage_108
integer x = 37
integer y = 52
integer width = 4411
integer height = 1644
integer taborder = 60
string dataobject = "dw_ktxa24p5"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_120 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "부동산임대공급가액명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_9 rr_9
dw_120 dw_120
end type

on tabpage_120.create
this.rr_9=create rr_9
this.dw_120=create dw_120
this.Control[]={this.rr_9,&
this.dw_120}
end on

on tabpage_120.destroy
destroy(this.rr_9)
destroy(this.dw_120)
end on

type rr_9 from roundrectangle within tabpage_120
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 36
integer width = 4526
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_120 from datawindow within tabpage_120
integer x = 27
integer y = 48
integer width = 4489
integer height = 1640
integer taborder = 80
string title = "부동산임대공급가액명세서"
string dataobject = "dw_ktxa24p8"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_112 from userobject within tab_htax
string tag = "대손공제(변제)신고서"
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "대손공제(변제)신고서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_8 rr_8
dw_112 dw_112
end type

on tabpage_112.create
this.rr_8=create rr_8
this.dw_112=create dw_112
this.Control[]={this.rr_8,&
this.dw_112}
end on

on tabpage_112.destroy
destroy(this.rr_8)
destroy(this.dw_112)
end on

type rr_8 from roundrectangle within tabpage_112
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 36
integer width = 4526
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_112 from datawindow within tabpage_112
integer x = 27
integer y = 48
integer width = 4489
integer height = 1640
integer taborder = 70
string title = "none"
string dataobject = "dw_ktxa24p9"
boolean hscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_135 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "공제받지 못할 매입세액"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_6 rr_6
dw_135 dw_135
end type

on tabpage_135.create
this.rr_6=create rr_6
this.dw_135=create dw_135
this.Control[]={this.rr_6,&
this.dw_135}
end on

on tabpage_135.destroy
destroy(this.rr_6)
destroy(this.dw_135)
end on

type rr_6 from roundrectangle within tabpage_135
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 40
integer width = 4439
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_135 from datawindow within tabpage_135
integer x = 41
integer y = 56
integer width = 4402
integer height = 1640
integer taborder = 70
string title = "none"
string dataobject = "dw_ktxa24p4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_117 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "신용카드매출전표 발행금액 집계표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_13 rr_13
dw_117 dw_117
end type

on tabpage_117.create
this.rr_13=create rr_13
this.dw_117=create dw_117
this.Control[]={this.rr_13,&
this.dw_117}
end on

on tabpage_117.destroy
destroy(this.rr_13)
destroy(this.dw_117)
end on

type rr_13 from roundrectangle within tabpage_117
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 32
integer width = 4517
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_117 from datawindow within tabpage_117
integer x = 27
integer y = 44
integer width = 4471
integer height = 1648
integer taborder = 70
string title = "none"
string dataobject = "dw_ktxa24pb"
boolean border = false
boolean livescroll = true
end type

type tabpage_177 from userobject within tab_htax
integer x = 18
integer y = 96
integer width = 4549
integer height = 1740
long backcolor = 32106727
string text = "영세율매출"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_12 rr_12
dw_177 dw_177
end type

on tabpage_177.create
this.rr_12=create rr_12
this.dw_177=create dw_177
this.Control[]={this.rr_12,&
this.dw_177}
end on

on tabpage_177.destroy
destroy(this.rr_12)
destroy(this.dw_177)
end on

type rr_12 from roundrectangle within tabpage_177
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 32
integer width = 4517
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_177 from datawindow within tabpage_177
integer x = 27
integer y = 44
integer width = 4498
integer height = 1644
integer taborder = 70
string title = "none"
string dataobject = "dw_ktxa24pe"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event itemchanged;Double dMaichulYoung1, dMaichulYoung2, dYounHap

tab_htax.tabpage_101.dw_101.AcceptText()
dMaichulYoung1 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_segum")
dMaichulYoung2 = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_gita")
if IsNull(dMaichulYoung1) then dMaichulYoung1 = 0
if IsNull(dMaichulYoung2) then dMaichulYoung2 = 0

this.AcceptText()
dYounHap = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"total")
if IsNull(dYounHap) then dYounHap = 0 

if dMaichulYoung1 + dMaichulYoung2 <> dYounHap then
	MessageBox('확인','부가세신고서 상의 영세율 금액과 합계가 다릅니다')
	return 1
end if
end event

type p_create from p_retrieve within w_ktxa95
integer x = 4110
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\create.cur"
boolean enabled = false
string picturename = "C:\erpman\image\자료생성_d.gif"
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\자료생성_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\자료생성_up.gif'
end event

event clicked;string  sVatGisu,sDatefrom, sDateto, sJasaCod,sApplyFlag = '%',sSano,sPath,sDocCd,&
		  sFileName,sCrtDate,sSaveFile,sTaxTag,sSuChulTag,sRptCode,sRptDsc,sJoGiGbn
Long    lSerNo = 0
Double  dAmt3, dAmt4, dChongV

dw_ip.AcceptText()

sVatGisu  = dw_ip.GetItemString(dw_ip.GetRow(),"vatgisu") 
sDatefrom = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_sdate"))
sDateto   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"kfz_vat_title_edate"))
sJasaCod  = dw_ip.GetItemstring(dw_ip.getrow(),"code")
sCrtDate  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"kfz_vat_title_cdate"))
sJoGiGbn = dw_ip.GetItemString(dw_ip.GetRow(),"jogi") 			/*영세율등조기환급:'1'(일반환금),'2'(영세율환급)*/

IF sDateFrom = '' or IsNull(sDateFrom) THEN
	F_MessageChk(1,'[신고기간]')
	dw_ip.SetColumn("kfz_vat_title_sdate")
	dw_ip.SetFocus()
	Return -1
END IF
IF sDateTo = '' or IsNull(sDateTo) THEN
	F_MessageChk(1,'[신고기간]')
	dw_ip.SetColumn("kfz_vat_title_edate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sJasaCod = '' or IsNull(sJasaCod) THEN
	F_MessageChk(1,'[자사코드]')
	dw_ip.SetColumn("code")
	dw_ip.SetFocus()
	Return -1
END IF
IF sCrtDate = '' or IsNull(sCrtDate) THEN
	F_MessageChk(1,'[작성일자]')
	dw_ip.SetColumn("kfz_vat_title_cdate")
	dw_ip.SetFocus()
	Return -1
END IF

tab_htax.tabpage_101.dw_101.AcceptText()

if tab_htax.tabpage_101.dw_101.RowCount() <=0 then return
	
//2007년 2기 확정 변경시작
Double dAmt5,dChong21, dAmt34R, dAmt35R
String sGubun
sGubun    = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"rpt_gubun"))

dChongV   = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"chong_v")
dChong21  = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"calc_21")

dAmt3     = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_segum")
dAmt4     = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maichul_yong_gita")
dAmt5     = tab_htax.tabpage_101.dw_101.GetItemNumber(1,"maiip_tax_gojeng")
if IsNull(dChongV) then dChongV = 0
if IsNull(dChong21) then dChong21 = 0
if IsNull(dAmt3) then dAmt3 = 0
if IsNull(dAmt4) then dAmt4 = 0
if IsNull(dAmt5) then dAmt5 = 0

dAmt34R     = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_yong_gong")
dAmt35R     = tab_htax.tabpage_101_1.dw_101_1.GetItemNumber(1,"remain_yong_gong_gita")
if IsNull(dAmt34R) then dAmt34R = 0
if IsNull(dAmt35R) then dAmt35R = 0

//영세율매출명세서 입력 시 신고서와 값 체크(2013.09.16)
if  dAmt3 + dAmt4 + dAmt34R + dAmt35R  <> 0 then
	Double dYounHap
	tab_htax.tabpage_177.dw_177.AcceptText()
	dYounHap = tab_htax.tabpage_177.dw_177.GetItemNumber(1,"total")
	if IsNull(dYounHap) then dYounHap = 0 
	
	if dAmt3 + dAmt4 + dAmt34R + dAmt35R <> dYounHap then
		MessageBox('확인','부가세신고서 상의 영세율 합계와 영세율매출명세서상의 합계가 다릅니다')
		return 
	end if
end if
//

if sGubun = '2' then
	if dChongV < 0 then
		IF sJoGiGbn = '' OR iSnULL(sJoGiGbn) THEN
			F_MessageChk(1,'[환급구분]')
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		END IF
		
		if (dAmt3 <> 0 or dAmt4 <> 0) and sJoGiGbn <> '42' then
			MessageBox('확 인',"매출영세율 값이 있으면 환급구분은 '영세율환급(총괄)'이어야 합니다")
//			dw_ip.SetItem(1,"jogi",'42')
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		end if
		if (dAmt3 = 0 and dAmt4 = 0 and dAmt5 <> 0) and sJoGiGbn <> '43' then
			MessageBox('확 인',"매출영세율없이 자산매입이 있으면 환급구분은 '시설투자환급(총괄)'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		end if
		if (dAmt3 = 0 and dAmt4 = 0 and dAmt5 = 0) and sJoGiGbn <> '41' then
			MessageBox('확 인',"매출영세율없이 자산매입이 있으면 환급구분은 '일반환급(총괄)'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		end if
	else				/*2007년 2기 확정 변경(기존:null -> 변경: 차감감 값 읽어서 처리)*/
		if dChong21 < 0 and sJoGiGbn <> '40' then
			MessageBox('확 인',"총괄납부세액이 0보다 크고 차가감납부세액이 0보다 작으면 '환급(총괄)'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		else
			IF sJoGiGbn <> '' and Not IsNull(sJoGiGbn) THEN
				MessageBox('확 인','환급구분을 입력할 수 없습니다')
				dw_ip.SetColumn("jogi")
				dw_ip.SetFocus()
				Return -1	
			END IF			
		end if		
	end if
else
	if dChong21 < 0 then
		IF sJoGiGbn = '' OR iSnULL(sJoGiGbn) THEN
			F_MessageChk(1,'[환급구분]')
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		END IF
		
		if (dAmt3 <> 0 or dAmt4 <> 0) and sJoGiGbn <> '20' then
			MessageBox('확 인',"매출영세율 값이 있으면 환급구분은 '영세율환급'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	 
		end if
		if (dAmt3 = 0 and dAmt4 = 0 and dAmt5 <> 0) and sJoGiGbn <> '30' then
			MessageBox('확 인',"매출영세율없이 자산매입이 있으면 환급구분은 '시설투자환급'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	 
		end if		
		if (dAmt3 = 0 and dAmt4 = 0 and dAmt5 = 0) and sJoGiGbn <> '10' then
			MessageBox('확 인',"조기환급 대상이 아니면 환급구분은 '일반환급'이어야 합니다")
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		end if		
	else
		IF sJoGiGbn <> '' and Not IsNull(sJoGiGbn) THEN
			MessageBox('확 인','환급구분을 입력할 수 없습니다')
			dw_ip.SetColumn("jogi")
			dw_ip.SetFocus()
			Return -1	
		END IF			
	end if	
end if

/*파일로 저장*/
sPath = dw_ip.GetItemString(dw_ip.GetRow(),"spath")

/*부가세 신고서 자료 저장*/
w_mdi_frame.sle_msg.text = '부가세 신고서-헤더 작성 중...'
SetPointer(HourGlass!)
if Wf_Create_101(sDateFrom,sDateTo,sJasaCod) = -1 then Return

w_mdi_frame.sle_msg.text = '부가세 신고서-일반 작성 중...'
SetPointer(HourGlass!)
if Wf_Create_101_1(sDateFrom,sDateTo,sJasaCod) = -1 then Return

w_mdi_frame.sle_msg.text = '부가세 신고서-수입금액 작성 중...'
SetPointer(HourGlass!)
if Wf_Create_101_2(sDateFrom,sDateTo,sJasaCod) = -1 then Return

w_mdi_frame.sle_msg.text = '부가세 신고서-공제신고서 작성 중...'
SetPointer(HourGlass!)
if Wf_Create_101_3(sDateFrom,sDateTo,sJasaCod) = -1 then Return

w_mdi_frame.sle_msg.text = '부가세 신고서-가산세신고서 작성 중...'
SetPointer(HourGlass!)
if Wf_Create_101_4(sDateFrom,sDateTo,sJasaCod) = -1 then Return

IF LsHomeTaxTag03 = 'N' THEN
	w_mdi_frame.sle_msg.text = '사업자단위 사업장별 과세표준 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_150(sDateFrom,sDateTo,sJasaCod) = -1 then Return
END IF
/*전자신고제외코드-사업장별 과세표준*/
if LsHomeTaxTag03 = 'Y' then
	delete from kfz_hometax_115 where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	w_mdi_frame.sle_msg.text = '사업장별 과세표준 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_115(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if
commit;
	
/*전자신고제외코드-영세율첨부서류*/
if LsHomeTaxTag04 = 'Y' then
	delete from kfz_hometax_106  where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	sRptCode  = Trim(dw_ip.GetItemstring(dw_ip.getrow(),"rptdsc"))
	
	select rfna1||nvl(rfna3,'') into :sRptDsc from reffpf where rfcod = 'TC' and rfgub = :sRptCode;
	
	w_mdi_frame.sle_msg.text = '영세율첨부서류 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_106(sDateFrom,sDateTo,sJasaCod, sRptCode, sRptDsc) = -1 then Return
end if
commit;
/*전자신고제외코드-감가상각자산취득명세서*/
if LsHomeTaxTag05 = 'Y' then
	delete from kfz_hometax_108
		where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod;
else
	w_mdi_frame.sle_msg.text = '건물등 감가상각취득명세서 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_108(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if
commit;
	
/*전자신고제외코드-부동산공급가액 명세서*/
if LsHomeTaxTag07 = 'Y' then
	delete from kfz_hometax_120   where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
	delete from kfz_hometax_120_1 where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	w_mdi_frame.sle_msg.text = '부동산공급가액 명세서 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_120(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if
commit;

/*대손공제변제 제외여부*/
if LsHomeTaxTag08 = 'Y' then
	delete from kfz_hometax_112   where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	w_mdi_frame.sle_msg.text = '대손공제(변제)신고서 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_112(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if
commit;

/*전자신고제외코드-공제받지 못할 매입세액*/
if LsHomeTaxTag09 = 'Y' then
	delete from kfz_hometax_153
		where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	w_mdi_frame.sle_msg.text = '공제받지 못할 매입세액 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_153(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if	
Commit;
	
/*전자신고제외코드-전자세금계산서 공제신고서-2010.01*/
if LsHomeTaxTag0A = 'Y' then
	delete from kfz_hometax_171
		where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
end if	
Commit;

/*신용카드매출전표발행금액집계표*/
if LsHomeTaxTag0B = 'Y' then
	delete from kfz_hometax_117
		where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
else
	w_mdi_frame.sle_msg.text = '신용카드매출전표발행금액집계표 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_117(sDateFrom,sDateTo,sJasaCod) = -1 then Return
end if	
Commit;
	
/*내국신용장*/
if LsHomeTaxTag0C = 'Y' then
	delete from kfz_hometax_174 where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
	delete from kfz_hometax_174_1 where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
end if	
Commit;

/*원산지확인서*/
if LsHomeTaxTag0D= 'Y' then
	delete from kfz_hometax_175 where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;
end if	
Commit;
	
//영세율매출명세서
if LsHomeTaxTag0E = 'N' then
	w_mdi_frame.sle_msg.text = '영세율매출명세서 작성 중...'
	SetPointer(HourGlass!)
	if Wf_Create_177(sDateFrom,sDateTo,sJasaCod) = -1 then Return
else
	delete from kfz_hometax_177
		where rpt_fr = :sDateFrom and rpt_to = :sDateTo and jasa_cd = :sJasaCod ;	
end if	
Commit;

w_mdi_frame.sle_msg.text = '파일 생성 중입니다....'

String  sMsg
Integer iReturn = 1

DECLARE start_acsp_create_vatfile_totaltax PROCEDURE FOR acsp_create_vatfile_totaltax(:sCrtDate, :sDateFrom, :sDateTo, :sJasaCod);
EXECUTE start_acsp_create_vatfile_totaltax;
FETCH start_acsp_create_vatfile_totaltax INTO :iReturn, :sMsg ;

if iReturn <> 1 then
	rollback;
	Messagebox('확인','자료생성을 실패하였습니다.')
	return
end if	
commit;
	
if Wf_Create_File(sDateFrom,sDateTo,sJasaCod,sPath) = -1 then Return

tab_htax.tabpage_101.dw_101.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_101_1.dw_101_1.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_115.dw_115.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_108.dw_108.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_135.dw_135.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_150.dw_150.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_120.dw_120.Object.DataWindow.Print.Preview = 'yes'
tab_htax.tabpage_117.dw_117.Object.DataWindow.Print.Preview = 'yes'


w_mdi_frame.sle_msg.text = '부가세 전자신고 자료 작성 완료.'
SetPointer(Arrow!)
end event

type dw_text from datawindow within w_ktxa95
boolean visible = false
integer x = 73
integer y = 2956
integer width = 1696
integer height = 128
boolean bringtotop = true
boolean titlebar = true
string title = "전자신고통합파일"
string dataobject = "dw_ktxa243"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_rtv12 from datawindow within w_ktxa95
boolean visible = false
integer x = 1792
integer y = 2796
integer width = 1303
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "사업설비투자실적조회"
string dataobject = "dw_ktxa244"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_rtv13 from datawindow within w_ktxa95
boolean visible = false
integer x = 1792
integer y = 2976
integer width = 1303
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "신용카드수취명세"
string dataobject = "dw_ktxa24p61_rtv"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_rtv14 from datawindow within w_ktxa95
boolean visible = false
integer x = 1792
integer y = 3176
integer width = 1303
integer height = 124
boolean bringtotop = true
boolean titlebar = true
string title = "대손공제(변제)신고서"
string dataobject = "dw_ktxa245"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

