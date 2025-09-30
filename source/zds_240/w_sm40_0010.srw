$PBExportHeader$w_sm40_0010.srw
$PBExportComments$출고등록(랩도스)
forward
global type w_sm40_0010 from w_inherite
end type
type rr_3 from roundrectangle within w_sm40_0010
end type
type rr_4 from roundrectangle within w_sm40_0010
end type
type dw_1 from datawindow within w_sm40_0010
end type
type pb_1 from u_pb_cal within w_sm40_0010
end type
type pb_2 from u_pb_cal within w_sm40_0010
end type
type rr_1 from roundrectangle within w_sm40_0010
end type
type rb_new from radiobutton within w_sm40_0010
end type
type rb_del from radiobutton within w_sm40_0010
end type
type st_2 from statictext within w_sm40_0010
end type
type cbx_1 from checkbox within w_sm40_0010
end type
type p_sort from picture within w_sm40_0010
end type
type cb_set0 from commandbutton within w_sm40_0010
end type
type rr_2 from roundrectangle within w_sm40_0010
end type
type pb_3 from picturebutton within w_sm40_0010
end type
type pb_4 from picturebutton within w_sm40_0010
end type
type pb_5 from picturebutton within w_sm40_0010
end type
type p_hmc_excel from uo_picture within w_sm40_0010
end type
type p_mobis from uo_picture within w_sm40_0010
end type
type st_3 from statictext within w_sm40_0010
end type
type st_4 from statictext within w_sm40_0010
end type
type cb_1 from commandbutton within w_sm40_0010
end type
type dw_2 from datawindow within w_sm40_0010
end type
type dw_print from datawindow within w_sm40_0010
end type
type dw_imhist from datawindow within w_sm40_0010
end type
type dw_3 from datawindow within w_sm40_0010
end type
type pb_6 from picturebutton within w_sm40_0010
end type
type p_excel from uo_picture within w_sm40_0010
end type
type cbx_move from checkbox within w_sm40_0010
end type
type dw_autoimhist from datawindow within w_sm40_0010
end type
type dw_4 from datawindow within w_sm40_0010
end type
type cb_2 from commandbutton within w_sm40_0010
end type
type cb_4 from commandbutton within w_sm40_0010
end type
type dw_pda from datawindow within w_sm40_0010
end type
type dw_pda_ins from datawindow within w_sm40_0010
end type
type cb_pda_ret from commandbutton within w_sm40_0010
end type
type dw_5 from datawindow within w_sm40_0010
end type
end forward

global type w_sm40_0010 from w_inherite
integer width = 4686
integer height = 2828
string title = "출고등록(외부)"
rr_3 rr_3
rr_4 rr_4
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rb_new rb_new
rb_del rb_del
st_2 st_2
cbx_1 cbx_1
p_sort p_sort
cb_set0 cb_set0
rr_2 rr_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
p_hmc_excel p_hmc_excel
p_mobis p_mobis
st_3 st_3
st_4 st_4
cb_1 cb_1
dw_2 dw_2
dw_print dw_print
dw_imhist dw_imhist
dw_3 dw_3
pb_6 pb_6
p_excel p_excel
cbx_move cbx_move
dw_autoimhist dw_autoimhist
dw_4 dw_4
cb_2 cb_2
cb_4 cb_4
dw_pda dw_pda
dw_pda_ins dw_pda_ins
cb_pda_ret cb_pda_ret
dw_5 dw_5
end type
global w_sm40_0010 w_sm40_0010

type variables
String is_depot_no
String is_pda
end variables

forward prototypes
public function integer wf_itnbr_check (string sitnbr)
public function integer wf_imhist_hk ()
public function integer wf_imhist_m1 ()
public function integer wf_imhist_m2 ()
public function integer wf_init ()
public function integer wf_imhist_etc ()
public function integer wf_chulgo_print (string arg_iojpno)
public function integer wf_setitem_new ()
public function integer wf_dup ()
public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date)
public function integer wf_imhist_etc_pda ()
end prototypes

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '삭제 가능 여부 CHECK 중.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from danmst_bg
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from ecomst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[ECO 정보]')
	return -1
end if

select count(*) into :icnt
  from itemas_zig
 where itnbr2 = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[지그/검사구 정보]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주_품목정보]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수출PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[입출고이력]')
	return -1
end if

//기술 BOM 체크  
//  SELECT COUNT("ESTRUC"."USSEQ")  
//    INTO :icnt  
//    FROM "ESTRUC"  
//   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;
//
//if icnt > 0 then
//	w_mdi_frame.sle_msg.text = ''
//	f_message_chk(38,'[기술BOM]')
//	return -1
//end if
	
//생산 BOM 체크  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[생산BOM]')
	return -1
end if

//외주 BOM 체크  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주BOM]')
	return -1
end if

//외주단가 BOM 체크  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주단가BOM]')
	return -1
end if

//할당 체크
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[할당]')
	return -1
end if

//월 재고
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기초재고]')
	return -1
end if

w_mdi_frame.sle_msg.text = ''

return 1
end function

public function integer wf_imhist_hk ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null ,ls_confirm_yn, ls_seogu, ls_gubun
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt , ll_cnt2
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

Dec ld_chqty , ld_ioqty


String ls_depot_in , ls_io_date

String ls_mdepot

String ls_iojpno
String ls_autojpno

SetNull(ls_null) 

if dw_insert.AcceptText() = -1 then Return -1 

ls_gubun =  Trim(dw_1.object.gubun[1])

// 현대CKD 미납분에 대해서는 출고일자 지정해서 처리 - 2006.12.29 - 송병호,박현숙
ls_ymd = Trim(dw_1.object.io_date[1])
if f_datechk(ls_ymd) = -1 then
	messagebox('확인','출고일자를 확인하십시오!!!')
	dw_1.setcolumn('io_date')
	dw_1.setfocus()
	return -1
end if

String ls_chul
ls_chul = dw_1.GetItemString(1, 'depot')
If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
	MessageBox('확인', '기준 출고창고를 지정하십시오!!')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	Return -1
End If


IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

dw_insert.SetRedraw(False)
dw_insert.SetSort("yymmdd A , btime A ")
dw_insert.Sort() 

ls_iogbn     = 'O02'  /* 정상매출 */
ls_iogbn_out = 'O05'  /* 창고이동 출고 */
ls_iogbn_in  = 'I11'  /* 창고이동 입고 */

Select jnpcrt , actiosp
  Into :ls_jnpcrt_1 , :ls_inpcnf_1
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_2 , :ls_inpcnf_2
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_out ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_3 , :ls_inpcnf_3
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_in ;
	
dw_imhist.Reset()
	
For i = 1 To dw_insert.Rowcount()


	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	ls_mdepot = Trim(dw_insert.object.mdepot[i])

	ll_cnt2 = 0 
	/* 물류업체 창고 여부 */
	Select count(*) Into :ll_cnt2
	  From vndmst
	 where cvgu = '5'
	   and jumaechul = '4'
		and cvcod = :ls_mdepot ;
		
	ld_chqty = dw_insert.object.yebid1[i]	//

	If isNull(ld_chqty) Then ld_chqty = 0 
	
	If ll_cnt2 > 0 Then
		
	Else
		If  ld_chqty <= 0 Then continue ;
	End iF
	
	If ll_cnt2 > 0 Then
		dw_insert.object.mdepot_no[i] = ls_mdepot
		dw_insert.object.yebis1[i] = 'Y'
	End if
	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("cvcod")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('확인','품번을 입력하세요.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
//	ls_ymd = Trim(dw_insert.object.yymmdd[i])
	
	If i = 1 Then dw_1.object.jisi_date[1] = ls_ymd
	If i = dw_insert.Rowcount() Then dw_1.object.jisi_date2[1] = ls_ymd
	
	If ls_ymd <> ls_ymd_pre or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_insert.SetRedraw(True)
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')

	ls_ymd_pre = ls_ymd
	
	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_orderno = Trim(dw_insert.object.orderno[i])
	ls_seogu   = Trim(dw_insert.object.seogu[i])
	ll_cnt = 1 
	
	//HK21공장일 경우 발주번호에 대한 기준정보가 없음. - by shingoon 2009.03.14
	//HK21,HK11공장일 경우 발주번호에 대한 기준정보가 없음. - by SHJEON 2010.09.29
	if ls_orderno > '.' then
		if ls_factory = 'HK21' OR ls_factory = 'HK11' then
			ll_cnt = 1
		else
			Select count(*) Into :ll_cnt
			  From reffpf
			 where rfcod = '2U'
				and rfgub = substr(:ls_orderno , -1 , 1 )
				and rfna3 = 'Y' ;
				
			// 랩도스 일경우 기준정보에 발주 번호에 대한 정보가 없어도 매출로 본다  BY SHJEON 20131015
			IF ls_gubun = 'HK' and ll_cnt = 0 THEN
				ll_cnt = 1
			END IF
		end if
	end if
		
	/* 서열지정 변경 - 1) 발주번호 서열기준, 2) 품목정보수정기준 (서선주) - 2007.01.23 */
	/* ll_cnt : 발주번호 정보의 기준 / ls_seogu : 품목정보수정new의 서열여부 / ll_cnt2 : 물류업체창고 여부 */
	If ll_cnt = 0  or ls_seogu = 'Y' or ll_cnt2 > 0 Then
//	If ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) or ( ll_cnt2 > 0 ) Then
		
		If ll_cnt2 > 0 Then
			
			ls_depot_in = ls_mdepot
			
			ls_confirm_yn = 'N'
			ld_ioqty  = 0
			ls_io_date = ls_null
			
			/* 공장별 관리방식으로 변경 - 2007.02.10 - 송병호 */
			Update vndmrp_new set mdepot = :ls_mdepot
			            where factory = :ls_factory
							  and itnbr = :ls_itnbr ;
							  
//			Update vndmrp set mdepot = :ls_mdepot
//			            where cvcod = :ls_cvcod
//							  and itnbr = :ls_itnbr ;
			IF sqlca.sqlnrows = 0 Then
				MessageBox('확인','품목정보 수정 실패 '+sqlca.sqlerrText )
				Rollback;
				Return -1
			End If			
		else
			ls_confirm_yn = 'Y'
			ld_ioqty  = dw_insert.object.yebid1[i]
			ls_io_date = ls_ymd
			
			Select cvcod 
			  Into :ls_depot_in
				from vndmst
			 Where cvgu = '5'
				and jumaechul = '3'
				and soguan = '1'
//				and ipjogun = :ls_saupj		// 사업장 구분하지 않고 조회 '20.05.19 BY BHKIM
				and jungmock = :ls_factory ;
		end if
		
///***********************************************************************************************************************/
////발주번호가 없는 출고자료는 중복에 체크되어 등록이 안됨.
////발주번호 없을 경우와 발주번호 있는 경우 두 가지로 나뉘어 중복확인 - by shingoon 2007.06.18
//		Long   ll_c
//		String ls_btime
//		ls_btime = dw_insert.GetItemString(i, 'btime')
//		If ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' Then
//			ls_orderno = '.'
//			Select Count(*) Into :ll_c
//			  From SM04_DAILY_ITEM_SALE
//			 Where saupj = :ls_saupj
//				and yymmdd = :ls_ymd
//				and btime = :ls_btime
//				and factory = :ls_factory
//				and itnbr = :ls_itnbr
//				and orderno = :ls_orderno ;
//			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
//			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				MessageBox('중복확인', '이미 처리된 발주 번호 입니다.')
//				Return -1
//			End If
//		Else
//			Long  ll_oseq
//			ll_oseq = dw_insert.GetItemNumber(i, 'oseq')
//			//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
//			SELECT COUNT('X') INTO :ll_c
//			  FROM SM04_DAILY_ITEM_SALE
//			 WHERE ORDERNO = :ls_orderno
//			   AND OSEQ    = :ll_oseq
//			   AND ITNBR   = :ls_itnbr
//			   AND FACTORY = :ls_factory ;
//			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
//			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				MessageBox('중복확인', '이미 처리된 발주 번호 입니다.')
//				Return -1
//			End If
//		End If
///***********************************************************************************************************************/
		
			
		// 창고이동 출고 

		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  ls_depot_in
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]	//
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 창고이동 출고'
		dw_imhist.object.botimh    [ll_r] = 'N'
//		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_2
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_2
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'L'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]		//		
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True Then
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			If ls_autojpno <> '-1' Then
				dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
			End If
		End If		            		
		
		// 창고이동 입고 =======================================================================================
		ll_r = dw_imhist.InsertRow(0)
		ll_jpno++
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_in
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_depot_in
		dw_imhist.object.cvcod     [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		
		dw_imhist.object.ioqty     [ll_r] =  ld_ioqty
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(ld_ioqty * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  gs_empno
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  ld_ioqty
		
		dw_imhist.object.io_confirm[ll_r] =  ls_confirm_yn
		
		dw_imhist.object.io_date   [ll_r] =  ls_io_date
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/* 
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '창고이동 입고'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_iojpno
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_3
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_3
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
	   //============================================================================================
		
   else
	
		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  'O02'
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  dw_insert.object.cvcod[i]
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  gs_empno
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드분 매출'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_1
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_1
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]		
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]	
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True Then
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			If ls_autojpno <> '-1' Then
				dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
			End If
		End If		            	
	
	end if 
Next

dw_insert.AcceptText()

If dw_imhist.RowCount() > 0 Then
	If dw_autoimhist.RowCount() > 0 Then	
		/*울산이동출고 저장*/
		IF dw_autoimhist.Update()  <= 0 Then
			ROLLBACK;
			Messagebox("입출고저장", "울산이동출고 저장실패" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
			dw_insert.SetRedraw(True)
			Return -1
		End If
	end If
	
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_insert.SetRedraw(True)
		Return -1
	end if
end If

IF dw_insert.update() <= 0 	THEN
	ROLLBACK;
	Messagebox('확인','dw_insert 저장실패')
	dw_insert.SetRedraw(True)
	Return -1
end if

////공장품번 품목대체 처리_imhist트리거처리_dyyoon_20180822
//string ar_sabu , ar_iojpno, ar_itnbr , ar_utype , ar_error, ar_iogbn
//For i = 1 To dw_imhist.Rowcount() 
//	ar_sabu   =  dw_imhist.getitemstring(i,"sabu")
//	ar_iojpno = dw_imhist.getitemstring(i,"iojpno")
//	ar_itnbr    = dw_imhist.getitemstring(i,"itnbr")
//	ar_utype   = 'I'
//	ar_iogbn   =  dw_imhist.getitemstring(i,"iogbn")
//	
//    //에러 30자리 까지 
//	ar_error = '123456789012345678901234567890'
//	
//	If not (ar_iogbn  = 'O05' or  ar_iogbn  = 'O02')  then //이동출하 매출처리만 진행
//		continue
//	end If
//	
//	sqlca.sp_create_imhist_o25_mes(ar_sabu, ar_iojpno, ar_itnbr, ar_utype, ar_error);
//	
//	If ar_error <> 'N' then
//		ROLLBACK;
//		Messagebox('확인','공장품번 대체 입출고실패')
//		dw_insert.SetRedraw(True)
//		Return -1		
//	End If
        
//Next



Commit ;


//출고전표 출력 - 2006.12.08 - 송병호
wf_chulgo_print(ls_iojpno)

p_inq.TriggerEvent(Clicked!)
dw_insert.SetRedraw(True)

Return 1
	
end function

public function integer wf_imhist_m1 ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

String ls_depot_in

String ls_iojpno

Dec ld_chqty

SetNull(ls_null) 

if dw_insert.AcceptText() = -1 then Return -1 

IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])
// MOBIS A/S 미납분에 대해서는 출고일자 지정해서 처리 - 2006.12.14 - 송병호,서선주
ls_ymd = Trim(dw_1.object.io_date[1])
if f_datechk(ls_ymd) = -1 then
	messagebox('확인','출고일자를 확인하십시오!!!')
	dw_1.setcolumn('io_date')
	dw_1.setfocus()
	return -1
end if

String ls_chul
ls_chul = dw_1.GetItemString(1, 'depot')
If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
	messagebox('확인', '기준 출고창고를 지정하십시오!!')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	Return -1
End If

dw_insert.SetRedraw(False)
dw_insert.SetSort("yymmdd A  ")
dw_insert.Sort() 

ls_iogbn     = 'O02'  /* 정상매출      */
ls_iogbn_out = 'O05'  /* 창고이동 출고 */
ls_iogbn_in  = 'I11'  /* 창고이동 입고 */

Select jnpcrt , actiosp
  Into :ls_jnpcrt_1 , :ls_inpcnf_1
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn ;
	
//Select jnpcrt , actiosp
//  Into :ls_jnpcrt_2 , :ls_inpcnf_2
//  From iomatrix 
// Where sabu = '1'
//	and iogbn = :ls_iogbn_out ;
//	
//Select jnpcrt , actiosp
//  Into :ls_jnpcrt_3 , :ls_inpcnf_3
//  From iomatrix 
// Where sabu = '1'
//	and iogbn = :ls_iogbn_in ;
	
dw_imhist.Reset()

For i = 1 To dw_insert.Rowcount()
	
//	ls_new = Trim(dw_insert.object.is_new[i])
//	
//	If ls_new = 'Y' Then continue ;
	
	ld_chqty = dw_insert.object.yebid1[i]
	If isNull(ld_chqty) Then ld_chqty = 0 
	If ld_chqty <= 0 Then continue ;
	
	
	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("cvcod")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('확인','품번을 입력하세요.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		dw_insert.SetRedraw(True)
		Return -1
	End If

	// MOBIS A/S 미납분에 대해서는 출고일자 지정해서 처리 - 2006.12.14 - 송병호,서선주
//	ls_ymd = Trim(dw_insert.object.yymmdd[i])
	
//	If i = 1 Then dw_1.object.jisi_date[1] = ls_ymd
//	If i = dw_insert.Rowcount() Then dw_1.object.jisi_date2[1] = ls_ymd
	
	If ls_ymd <> ls_ymd_pre or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_insert.SetRedraw(True)
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
	
	ls_ymd_pre = ls_ymd
	
	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_orderno = Trim(dw_insert.object.orderno[i])
	ll_cnt = 0 
	
	ll_r = dw_imhist.InsertRow(0)
	
	dw_imhist.object.sabu      [ll_r] =  gs_sabu
	dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
	dw_imhist.object.iogbn     [ll_r] =  'O02'
	dw_imhist.object.sudat     [ll_r] =  ls_ymd
	dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
	dw_imhist.object.pspec     [ll_r] =  '.'
	dw_imhist.object.opseq     [ll_r] =  '9999'
	dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
	dw_imhist.object.cvcod     [ll_r] =  dw_insert.object.cvcod[i]
	
	dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
	dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
	dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
	dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
	dw_imhist.object.insdat    [ll_r] =  ls_ymd
	dw_imhist.object.insemp    [ll_r] =  ls_null
	dw_imhist.object.qcgub     [ll_r] =  '1'
	dw_imhist.object.iofaqty   [ll_r] =  0
	dw_imhist.object.iopeqty   [ll_r] =  0
	dw_imhist.object.iospqty   [ll_r] =  0
	dw_imhist.object.iocdqty   [ll_r] =  0
	dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
	dw_imhist.object.io_confirm[ll_r] =  'Y'
	dw_imhist.object.io_date   [ll_r] =  ls_ymd
	dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
	/*
	dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
	dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
	*/
	dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
	dw_imhist.object.loteno    [ll_r] =  ls_null
	dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
	dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
	dw_imhist.object.filsk     [ll_r] =  'Y'
	dw_imhist.object.bigo      [ll_r] = '납입카드분 매출'
	dw_imhist.object.botimh    [ll_r] = 'N'
	dw_imhist.object.ip_jpno   [ll_r] = ls_null
	dw_imhist.object.itgu      [ll_r] = '5'
	dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_1
	dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_1
	dw_imhist.object.ioredept  [ll_r] = gs_dept
	dw_imhist.object.ioreemp   [ll_r] = gs_empno
	dw_imhist.object.crt_date  [ll_r] = is_today
	dw_imhist.object.crt_time  [ll_r] = is_totime
	dw_imhist.object.crt_user  [ll_r] = gs_empno
	dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
	dw_imhist.object.decisionyn[ll_r] = 'Y'
	dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
	dw_imhist.object.lclgbn    [ll_r] = 'V'
	dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
	
	// 실제 납품번호 
	dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
		
	/* ----------------------------------------------------- */
	/* 울산이동출고 처리 2016.01.21 신동준 			 */
	/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
	/* ----------------------------------------------------- */		
	If cbx_move.Checked = True Then
		String ls_autojpno
		ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
		If ls_autojpno <> '-1' Then
			dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
		End If
	End If		            
Next

dw_insert.AcceptText()

If dw_imhist.RowCount() > 0 Then
	If dw_autoimhist.RowCount() > 0 Then	
		/*울산이동출고 저장*/
		IF dw_autoimhist.Update()  <= 0 Then
			ROLLBACK;
			Messagebox("입출고저장", "울산이동출고 저장실패" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
			dw_insert.SetRedraw(True)
			Return -1
		End If
	end If
	
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_insert.SetRedraw(True)
		Return -1
	end if
end If	


////공장품번 품목대체 처리_imhist트리거처리_dyyoon_20181822
//string ar_sabu , ar_iojpno, ar_itnbr , ar_utype , ar_error, ar_iogbn
//For i = 1 To dw_imhist.Rowcount() 
//	ar_sabu   =  dw_imhist.getitemstring(i,"sabu")
//	ar_iojpno = dw_imhist.getitemstring(i,"iojpno")
//	ar_itnbr    = dw_imhist.getitemstring(i,"itnbr")
//	ar_utype   = 'I'
//	ar_iogbn   =  dw_imhist.getitemstring(i,"iogbn")
//	
//    //에러 30자리 까지 
//	ar_error = '123456789012345678901234567890'
//	
//	If not (ar_iogbn  = 'O05' or  ar_iogbn  = 'O02')  then //이동출하 매출처리만 진행
//		continue
//	end If
//	
//	sqlca.sp_create_imhist_o25_mes(ar_sabu, ar_iojpno, ar_itnbr, ar_utype, ar_error);
//	
//	If ar_error <> 'N' then
//		ROLLBACK;
//		Messagebox('확인','공장품번 대체 입출고실패')
//		dw_insert.SetRedraw(True)
//		Return -1		
//	End If
//        
//Next


Commit ;


//출고전표 출력 - 2006.12.08 - 송병호
wf_chulgo_print(ls_iojpno)


p_inq.TriggerEvent(Clicked!)
dw_insert.SetRedraw(True)

Return 1
	
end function

public function integer wf_imhist_m2 ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in, ls_mdepot
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3
String ls_autojpno

Dec ld_chqty

String ls_depot_in

String ls_iojpno

SetNull(ls_null) 

if dw_insert.AcceptText() = -1 then Return -1 

IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

dw_insert.SetRedraw(False)
dw_insert.SetSort("yymmdd A , btime A ")
dw_insert.Sort() 

String ls_chul
ls_chul = dw_1.GetItemString(1, 'depot')
If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
	MessageBox('확인', '기준 출고창고를 지정하십시오!!')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	Return -1
End If

ls_iogbn     = 'O02'  /* 정상매출 */
ls_iogbn_out = 'O05'  /* 창고이동 출고 */
ls_iogbn_in  = 'I11'  /* 창고이동 입고 */

Select jnpcrt , actiosp
  Into :ls_jnpcrt_1 , :ls_inpcnf_1
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_2 , :ls_inpcnf_2
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_out ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_3 , :ls_inpcnf_3
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_in ;
	
dw_imhist.Reset()
	
For i = 1 To dw_insert.Rowcount()
	
//	ls_new = Trim(dw_insert.object.is_new[i])
//	
//	If ls_new = 'N' Then continue ;

	ld_chqty = dw_insert.object.yebid1[i]
	If isNull(ld_chqty) Then ld_chqty = 0 
	If ld_chqty <= 0 Then continue ;
	
	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	ls_mdepot = Trim(dw_insert.object.mdepot[i])
	
	ll_cnt = 0 
	Select count(*) Into :ll_cnt
	  From vndmst
	 where cvgu = '5'
	   and jumaechul = '4'
		and cvcod = :ls_mdepot ;


	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("cvcod")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('확인','품번을 입력하세요.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	ls_ymd = Trim(dw_insert.object.yymmdd[i])
	
	If i = 1 Then dw_1.object.jisi_date[1] = ls_ymd
	If i = dw_insert.Rowcount() Then dw_1.object.jisi_date2[1] = ls_ymd
	
	If ls_ymd <> ls_ymd_pre or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_insert.SetRedraw(True)
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')	
	ls_ymd_pre = ls_ymd
	
	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_orderno = Trim(dw_insert.object.orderno[i])
	

	If ll_cnt > 0 Then	// 물류업체 출고
		ls_depot_in = ls_mdepot

		// 창고이동 출고 
		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  ls_depot_in
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
	
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 창고이동 출고'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_2
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_2
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True Then
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			If ls_autojpno <> '-1' Then
				dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
			End If
		End If		            
		
		// 창고이동 입고 
		
		ll_r = dw_imhist.InsertRow(0)
		ll_jpno++
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_in
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_depot_in
		dw_imhist.object.cvcod     [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 창고이동 입고'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_iojpno
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_3
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_3
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
	

   Else
	
		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  'O02'
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  dw_insert.object.cvcod[i]
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  gs_empno
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '거래명세서 매출'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_1
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_1
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]	
		
		/* M1(모비스CKD)공장은 출고 후 별도 검수자료 없음. - by shingoon 2009.06.09 */
		/* 매출 출고처리되면 바로 검수 처리 - 고객지원영업팀 박상희 요청 */
		If dw_insert.object.factory[i] = 'M1' Then
			dw_imhist.object.yebi1[ll_r] = ls_ymd
		End If
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True And ls_saupj = '20' Then
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
		End If		            
		
	end if

Next

dw_insert.AcceptText()

If dw_imhist.RowCount() > 0 Then	
	If dw_autoimhist.RowCount() > 0 Then	
		/*울산이동출고 저장*/
		IF dw_autoimhist.Update()  <= 0 Then
			ROLLBACK;
			Messagebox("입출고저장", "울산이동출고 저장실패" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
			dw_insert.SetRedraw(True)
			Return -1
		End If
	end If
	
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_insert.SetRedraw(True)
		Return -1
	end if
end If


////공장품번 품목대체 처리_imhist트리거처리_20180822_dyyoon
//string ar_sabu , ar_iojpno, ar_itnbr , ar_utype , ar_error, ar_iogbn
//For i = 1 To dw_imhist.Rowcount() 
//	ar_sabu   =  dw_imhist.getitemstring(i,"sabu")
//	ar_iojpno = dw_imhist.getitemstring(i,"iojpno")
//	ar_itnbr    = dw_imhist.getitemstring(i,"itnbr")
//	ar_utype   = 'I'
//	ar_iogbn   =  dw_imhist.getitemstring(i,"iogbn")
//	
//    //에러 30자리 까지 
//	ar_error = '123456789012345678901234567890'
//	
//	If not (ar_iogbn  = 'O05' or  ar_iogbn  = 'O02')  then //이동출하 매출처리만 진행
//		continue
//	end If
//	
//	sqlca.sp_create_imhist_o25_mes(ar_sabu, ar_iojpno, ar_itnbr, ar_utype, ar_error);
//	
//	If ar_error <> 'N' then
//		ROLLBACK;
//		Messagebox('확인','공장품번 대체 입출고실패')
//		dw_insert.SetRedraw(True)
//		Return -1		
//	End If
//        
//Next

	
Commit ;


//출고전표 출력 - 2006.12.08 - 송병호
wf_chulgo_print(ls_iojpno)


dw_insert.SetRedraw(True)
p_inq.TriggerEvent(Clicked!)

Return 1
	
end function

public function integer wf_init ();String ls_gubun 

cbx_1.visible = False

String  ls_chk
SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END INTO :ls_chk FROM REFFPF WHERE SABU = '1' AND RFCOD = '47' AND RFGUB = :gs_empno ;
If ls_chk = 'Y' Then
	dw_1.SetItem(1, 'empno', gs_empno)
Else
	dw_1.SetItem(1, 'empno', '')
End If

dw_1.SetItem(1, 'saupj', '20')

f_child_saupj(dw_1, 'depot', '20')


If rb_new.Checked Then
	
	ls_gubun = Trim(dw_1.object.gubun[1])
	
	If ls_gubun = 'HK' Then
//		p_excel.visible = True
//		p_hmc_excel.visible = True
		p_search.visible = False
	else
//		p_excel.visible = False
//		p_hmc_excel.visible = False
		p_search.visible = True
	End if
	
	If ls_gubun = 'HK' Then
//		cb_4.Enabled = False
		dw_insert.Dataobject = 'd_sm40_0010_a_hk'
		st_2.Text="※ 납품서 발행(랩도스 처리) 후 물류업체 출고는 수량없이 납품서만 이동합니다."
	elseif ls_gubun = 'M1' Then
//		cb_4.Enabled = False
		dw_insert.Dataobject = 'd_sm40_0010_a_m1'
		st_2.Text="※ MOBIS A/S 는  VAN 발주정보에서 출고처리 합니다."
	elseif ls_gubun = 'M2' Then
//		cb_4.Enabled = False
		dw_insert.Dataobject = 'd_sm40_0010_a_m2'
		st_2.Text="※ MOBIS AUTO 및 기타업체는 주간(상차)계획에서 출고처리 합니다."
	else
//		cb_4.Enabled = true
		cbx_1.visible = True
		dw_insert.Dataobject = 'd_sm40_0010_a_et'
		st_2.Text="※ 주간(상차)계획에서 품목정보수정의 물류업체 지정된 품목만 출고처리 합니다."
	end if
	
	dw_autoimhist.Reset()
	cb_set0.enabled = true
else
	
	dw_insert.Dataobject = "d_sm40_0010_b"
	
	p_excel.visible = False
	p_hmc_excel.visible = False
	p_search.visible = False
	cb_set0.enabled = False
	
//	cb_4.Enabled = False
end if

dw_insert.SetTransObject(SQLCA)

Return 1
end function

public function integer wf_imhist_etc ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null ,ls_confirm_yn
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt , ll_cnt2
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

Dec ld_chqty , ld_ioqty


String ls_depot_in , ls_io_date

String ls_mdepot

String ls_iojpno

SetNull(ls_null) 

if dw_insert.AcceptText() = -1 then Return -1 

IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

dw_insert.SetRedraw(False)

String ls_chul
ls_chul = dw_1.GetItemString(1, 'depot')
If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
	MessageBox('확인', '기준 출고창고를 지정하십시오!!')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	Return -1
End If

ls_iogbn     = 'O02'  /* 정상매출 */
ls_iogbn_out = 'O05'  /* 창고이동 출고 */
ls_iogbn_in  = 'I11'  /* 창고이동 입고 */

Select jnpcrt , actiosp
  Into :ls_jnpcrt_1 , :ls_inpcnf_1
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_2 , :ls_inpcnf_2
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_out ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_3 , :ls_inpcnf_3
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_in ;
	
dw_imhist.Reset()
	
For i = 1 To dw_insert.Rowcount()


	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	ls_mdepot = Trim(dw_insert.object.mdepot[i])

	ll_cnt2 = 0 
	Select count(*) Into :ll_cnt2
	  From vndmst
	 where cvgu = '5'
	   and jumaechul = '4'
		and cvcod = :ls_mdepot ;
		
	ld_chqty = dw_insert.object.yebid1[i]

	If isNull(ld_chqty) Then ld_chqty = 0 
	
	If ll_cnt2 = 0 or ls_mdepot = '' or isNull(ls_mdepot) or ld_chqty = 0 Then
		Continue;
	Else
		dw_insert.object.mdepot_no[i] = ls_mdepot
		dw_insert.object.yebis1[i] = 'Y'
	End iF

	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("cvcod")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('확인','품번을 입력하세요.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		dw_insert.SetRedraw(True)
		Return -1
	End If
	
	ls_ymd = Trim(dw_insert.object.yymmdd[i])
	
	If i = 1 Then dw_1.object.jisi_date[1] = ls_ymd
	If i = dw_insert.Rowcount() Then dw_1.object.jisi_date2[1] = ls_ymd
	
	If ls_ymd <> ls_ymd_pre or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_insert.SetRedraw(True)
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')

	ls_ymd_pre = ls_ymd
	
	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_orderno = Trim(dw_insert.object.orderno[i])
	ll_cnt = 1 
	
	if ls_orderno > '.' then
		Select count(*) Into :ll_cnt
		  From reffpf
		 where rfcod = '2U'
			and rfgub = substr(:ls_orderno , -1 , 1 )
			and rfna3 = 'Y' ;
	end if
		

//	If ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) or ( ll_cnt2 > 0 ) Then
		
		If ll_cnt2 > 0 Then
			
			ls_depot_in = ls_mdepot
			
			ls_confirm_yn = 'N'
			ld_ioqty  = 0
			ls_io_date = ls_null
			
			/* 공장별 관리방식으로 변경 - 2007.02.10 - 송병호 */
			Update vndmrp_new set mdepot = :ls_mdepot
			            where factory = :ls_factory
							  and itnbr = :ls_itnbr ;
							  
//			Update vndmrp set mdepot = :ls_mdepot
//			            where cvcod = :ls_cvcod
//							  and itnbr = :ls_itnbr ;
			IF sqlca.sqlnrows = 0 Then
				MessageBox('확인','품목정보 수정 실패 '+sqlca.sqlerrText )
				Rollback;
				Return -1
			End If
			
		else
			
			ls_confirm_yn = 'Y'
			ld_ioqty  = dw_insert.object.yebid1[i]
			ls_io_date = ls_ymd
			
			Select cvcod 
			  Into :ls_depot_in
				from vndmst
			 Where cvgu = '5'
				and jumaechul = '3'
				and soguan = '1'
				and ipjogun = :ls_saupj
				and jungmock = :ls_factory ;
				
				
			
		end if
			
			
		// 창고이동 출고 

		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  ls_depot_in
		
		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 창고이동 출고'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_2
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_2
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'L'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True Then
			String ls_autojpno
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			If ls_autojpno <> '-1' Then
				dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
			End If
		End If		            		
		
		// 창고이동 입고 =======================================================================================
		ll_r = dw_imhist.InsertRow(0)
		ll_jpno++
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_in
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_depot_in
		dw_imhist.object.cvcod     [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		
		dw_imhist.object.ioqty     [ll_r] =  ld_ioqty
		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(ld_ioqty * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  gs_empno
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  ld_ioqty
		
		dw_imhist.object.io_confirm[ll_r] =  ls_confirm_yn
		
		dw_imhist.object.io_date   [ll_r] =  ls_io_date
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  '.'  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		//dw_imhist.object.bigo      [ll_r] = '창고이동 입고'
		dw_imhist.object.bigo      [ll_r] = dw_insert.object.bigo[i]
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_iojpno
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_3
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_3
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
	   //============================================================================================
		
//   else
	
//		ll_r = dw_imhist.InsertRow(0)
//		
//		dw_imhist.object.sabu      [ll_r] =  gs_sabu
//		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
//		dw_imhist.object.iogbn     [ll_r] =  'O02'
//		dw_imhist.object.sudat     [ll_r] =  ls_ymd
//		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
//		dw_imhist.object.pspec     [ll_r] =  '.'
//		dw_imhist.object.opseq     [ll_r] =  '9999'
//		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
//		dw_imhist.object.cvcod     [ll_r] =  dw_insert.object.cvcod[i]
//		
//		dw_imhist.object.ioqty     [ll_r] =  dw_insert.object.yebid1[i]
//		dw_imhist.object.ioprc     [ll_r] =  dw_insert.object.vndmrp_new_sales_price[i]
//		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_insert.object.yebid1[i] * dw_insert.object.vndmrp_new_sales_price[i] ,0 )
//		dw_imhist.object.ioreqty   [ll_r] =  dw_insert.object.yebid1[i]
//		dw_imhist.object.insdat    [ll_r] =  ls_ymd
//		dw_imhist.object.insemp    [ll_r] =  ls_null
//		dw_imhist.object.qcgub     [ll_r] =  '1'
//		dw_imhist.object.iofaqty   [ll_r] =  0
//		dw_imhist.object.iopeqty   [ll_r] =  0
//		dw_imhist.object.iospqty   [ll_r] =  0
//		dw_imhist.object.iocdqty   [ll_r] =  0
//		dw_imhist.object.iosuqty   [ll_r] =  dw_insert.object.yebid1[i]
//		dw_imhist.object.io_confirm[ll_r] =  'Y'
//		dw_imhist.object.io_date   [ll_r] =  ls_ymd
//		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
//		dw_imhist.object.lotsno    [ll_r] =  ls_orderno /* 발주번호 */
//		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
//		dw_imhist.object.filsk     [ll_r] =  'Y'
//		dw_imhist.object.bigo      [ll_r] = '납입카드분 매출'
//		dw_imhist.object.botimh    [ll_r] = 'N'
//		dw_imhist.object.ip_jpno   [ll_r] = ls_null
//		dw_imhist.object.itgu      [ll_r] = '5'
//		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_1
//		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_1
//		dw_imhist.object.ioredept  [ll_r] = gs_dept
//		dw_imhist.object.ioreemp   [ll_r] = gs_empno
//		dw_imhist.object.crt_date  [ll_r] = is_today
//		dw_imhist.object.crt_time  [ll_r] = is_totime
//		dw_imhist.object.crt_user  [ll_r] = gs_empno
//		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
//		dw_imhist.object.decisionyn[ll_r] = 'Y'
//		dw_imhist.object.facgbn    [ll_r] = dw_insert.object.factory[i]
//		dw_imhist.object.lclgbn    [ll_r] = 'V'
//		dw_imhist.object.sarea     [ll_r] = dw_insert.object.yebis2[i]
//		
//		
//		// 실제 납품번호 
//		dw_imhist.object.pjt_cd    [ll_r] = dw_insert.object.iojpno[i]
	
//	end if
                          
                        
Next

dw_insert.AcceptText()

If dw_imhist.RowCount() > 0 Then
	If dw_autoimhist.RowCount() > 0 Then	
		/*울산이동출고 저장*/
		IF dw_autoimhist.Update()  <= 0 Then
			ROLLBACK;
			Messagebox("입출고저장", "울산이동출고 저장실패" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
			dw_insert.SetRedraw(True)
			Return -1
		End If
	end If
	
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_insert.SetRedraw(True)
		Return -1
	end if
end If

IF dw_insert.update() <= 0 	THEN
	ROLLBACK;
	Messagebox('확인','dw_insert 저장실패')
	dw_insert.SetRedraw(True)
	Return -1
end if

//공장품번 품목대체 처리 --> imhist 트리거에서 처리함._dyyoon_20180822
//string ar_sabu , ar_iojpno, ar_itnbr , ar_utype , ar_error, ar_iogbn
//For i = 1 To dw_imhist.Rowcount() 
//	ar_sabu   =  dw_imhist.getitemstring(i,"sabu")
//	ar_iojpno = dw_imhist.getitemstring(i,"iojpno")
//	ar_itnbr    = dw_imhist.getitemstring(i,"itnbr")
//	ar_utype   = 'I'
//	ar_iogbn   =  dw_imhist.getitemstring(i,"iogbn")
//	
//    //에러 30자리 까지 
//	ar_error = '123456789012345678901234567890'
//	
//	If not (ar_iogbn  = 'O05' or  ar_iogbn  = 'O02')  then //이동출하 매출처리만 진행
//		continue
//	end If
//	
//	sqlca.sp_create_imhist_o25_mes_1(ar_sabu, ar_iojpno, ar_itnbr, ar_utype, ar_error);
//	
//	If ar_error <> 'N' then
//		ROLLBACK;
//		Messagebox('확인','공장품번 대체 입출고실패')
//		dw_insert.SetRedraw(True)
//		Return -1		
//	End If
//        
//Next

Commit ;




//출고전표 출력 - 2006.12.08 - 송병호
wf_chulgo_print(ls_iojpno)


p_inq.TriggerEvent(Clicked!)
dw_insert.SetRedraw(True)

Return 1
	
end function

public function integer wf_chulgo_print (string arg_iojpno);// 전표번호 자릿수 확인
if len(arg_iojpno) < 12 then return -1


string	ls_jpno
decimal	dqty


//----------------------------------------------------------------------------------------------
// 출고수량이 있는 경우에만 출력
ls_jpno = LEFT(arg_iojpno, 12)

select sum(ioreqty) into :dqty from imhist
 where sabu = :gs_sabu and iojpno like :ls_jpno||'%' ;
if isnull(dqty) or dqty = 0 then
	return -1
end if
//----------------------------------------------------------------------------------------------

If MessageBox('확인', '출고전표를 출력 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then
Else
	dw_print.Retrieve(ls_jpno)
	
	String ls_name
	ls_name = f_get_name5('02', gs_empno, '')
	
	dw_print.Modify("t_name.Text = '" + ls_name + "'")
	
	/* 프린터 미리보기 또는 프린터 설정 창이 뜬 후 종료(닫기)버튼을 누르면 출력되지 말아야 함. - 2006.12.13 by shingoon */
	OpenWithParm(w_print_options, dw_print)
	Long   ll_rtn
	ll_rtn = Message.DoubleParm
	
	If ll_rtn < 1 Then Return -1
	
//	dw_print.Modify("t_text.Text = '- 업 체 용 -'")
//	dw_print.Print()
//	dw_print.Modify("t_text.text= '- 고객지원팀 용 -'")
//	dw_print.Print()
End If

return 1
end function

public function integer wf_setitem_new ();long		lrow, ll_seq, ll_cnt
string	syymmdd, sfactory, scvcod, sitnbr, sseogu, smdepot, ls_ymd
decimal	dprc

String   ls_gub
ls_gub = dw_1.GetItemString(1, 'gubun')
If ls_gub = 'HK' Or ls_gub = 'M1' Then
	ls_ymd = Trim(dw_1.object.io_date[1])
	if f_datechk(ls_ymd) = -1 then
		messagebox('확인','출고일자를 확인하십시오!!!')
		dw_1.setcolumn('io_date')
		dw_1.setfocus()
		return -1
	end if
End If

String ls_chul
ls_chul = dw_1.GetItemString(1, 'depot')
If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
	messagebox('확인', '기준 출고창고를 지정하십시오!!')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return -1
end If

for lrow = 1 to dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'is_new') = 'N' then continue
	
	syymmdd = dw_insert.getitemstring(lrow,'yymmdd')
	if f_datechk(syymmdd) = -1 then
		messagebox('확인','발행일자를 지정하십시오!!!')
		dw_insert.setrow(lrow)
		dw_insert.scrolltorow(lrow)
		dw_insert.setfocus()
		return -1
	end if
	
	sfactory = dw_insert.getitemstring(lrow,'factory')
	if isnull(sfactory) or sfactory = '' or sfactory = '.' then
		messagebox('확인','공장을 지정하십시오!!!')
		dw_insert.setrow(lrow)
		dw_insert.scrolltorow(lrow)
		dw_insert.setfocus()
		return -1
	end if

	select rfna2 into :scvcod from reffpf
	 where rfcod = '2A' and rfgub = :sfactory ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','공장이 잘못 지정되었습니다!!')
		dw_insert.setrow(lrow)
		dw_insert.scrolltorow(lrow)
		dw_insert.setfocus()
		return -1
	end if
		
	dw_insert.setitem(lrow, "cvcod",  scvcod)

	sitnbr = dw_insert.getitemstring(lrow,'itnbr')
	if isnull(sitnbr) or sitnbr = '' then
		messagebox('확인','품번을 지정하십시오!!!')
		dw_insert.setrow(lrow)
		dw_insert.scrolltorow(lrow)
		dw_insert.setfocus()
		return -1
	end if
	
	/* CKD공장은 공장별 관리방식을 따르지 않고 직납 출고 처리 - 2014.03.25 BY SHINGOON ↓↓↓↓↓***************************************/
	String   ls_ckd
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_ckd
	  FROM REFFPF
	 WHERE RFCOD = '2A' AND RFCOMMENT = 'CKD' AND RFGUB = :sfactory ;
	If ls_ckd = 'N' Then
		/* 공장별 관리방식으로 변경 - 2007.02.10 - 송병호 */
		select nvl(seogu,'N'), mdepot into :sseogu, :smdepot from vndmrp_new
		 where factory = :sfactory and itnbr = :sitnbr ;
	
	//	select nvl(seogu,'N'), mdepot into :sseogu, :smdepot from vndmrp
	//	 where cvcod = :scvcod and itnbr = :sitnbr ;
		dw_insert.setitem(lrow, "seogu",  sseogu)
		dw_insert.setitem(lrow, "mdepot",  smdepot)
	Else
		dw_insert.setitem(lrow, "seogu",  'N')
		dw_insert.setitem(lrow, "mdepot",  '')
	End If

	/* CKD공장은 공장별 관리방식을 따르지 않고 직납 출고 처리 - 2014.03.25 BY SHINGOON ↑↑↑↑↑***************************************/
	
	select fun_vnddan_danga(:syymmdd, :sitnbr, :scvcod) into :dprc from dual ;
	dw_insert.setitem(lrow, "vndmrp_new_sales_price",  dprc)
	
	/***********************************************************************************************************************/
//발주번호가 없는 출고자료는 중복에 체크되어 등록이 안됨.
//발주번호 없을 경우와 발주번호 있는 경우 두 가지로 나뉘어 중복확인 - by shingoon 2007.06.18
//		Select Count(*) Into :ll_c
//		  From SM04_DAILY_ITEM_SALE
//		  Where saupj = :ls_saupj
//			 and yymmdd = :ls_ymd
//			 and btime = :ls_btime
//			 and factory = :ls_factory
//			 and itnbr = :ls_itnbr
//			 and orderno = :ls_orderno ;
		String ls_orderno, ls_saupj, ls_btime
		Long   ll_c
		ls_orderno = dw_insert.GetItemString(lrow, 'orderno')
		If Trim(ls_orderno) = '' OR IsNull(ls_orderno) Then
			MessageBox('확인', '발주번호를 입력 하십시오.')
			Return -1
		End If
		
		ls_saupj   = dw_insert.GetItemString(lrow, 'saupj')
		ls_btime   = dw_insert.GetItemString(lrow, 'btime')
		If ls_orderno = '' or isNull(ls_orderno) OR ls_orderno = '.' Then
			ls_orderno = '.'
			Select Count(*) Into :ll_c
			  From SM04_DAILY_ITEM_SALE
			 Where saupj = :ls_saupj
				and yymmdd = :syymmdd
				and btime = :ls_btime
				and factory = :sfactory
				and itnbr = :sitnbr
				and orderno = :ls_orderno ;
			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				Continue ;
				MessageBox('확인','해당 날짜에 이미 등록된 발주입니다.')
				w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 발주입니다.'
	//			uo_xl.uf_excel_Disconnect()
	//			uo_xltemp.uf_excel_Disconnect()
				Return -1
			End If
		Else
			If ls_gub <> 'HK' Then  //HK일 경우는 Excel Upload 할 때 중복 확인 함 - by shingoon 2013.11.26
				Long  ll_oseq
				ll_oseq = dw_insert.GetItemNumber(lrow, 'oseq')
				If IsNull(ll_oseq) Then ll_oseq = 0
				//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
				SELECT COUNT('X') INTO :ll_c
				  FROM SM04_DAILY_ITEM_SALE
				 WHERE ORDERNO = :ls_orderno
					AND OSEQ    = :ll_oseq
					AND ITNBR   = :sitnbr
					AND FACTORY = :sfactory ;
				//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
				If ll_c > 0 Or sqlca.sqlcode <> 0 Then
	//				Continue ;
					MessageBox('확인','이미 등록된 발주 입니다.')
					w_mdi_frame.sle_msg.text ='이미 등록된 발주 입니다.'
		//			uo_xl.uf_excel_Disconnect()
		//			uo_xltemp.uf_excel_Disconnect()
					Return -1
				End If
			End If
		End If
/***********************************************************************************************************************/

	ll_cnt++
next

if ll_cnt = 0 then return 1


/*송장번호 채번*/
ll_seq = sqlca.fun_junpyo(gs_sabu, ls_ymd, 'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
Commit;

ll_cnt = 0
for lrow = 1 to dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'is_new') = 'N' then continue

	ll_cnt++
	dw_insert.setitem(1, "iojpno", ls_ymd+string(ll_seq,'0000')+string(ll_cnt,'000'))	
next

return 1

end function

public function integer wf_dup ();Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return -1

Long   i
Long   ll_oseq
Long   ll_find
String ls_itnbr
String ls_factory
String ls_btime
String ls_ymd
String ls_saupj
String ls_orderno
For i = 1 To ll_cnt
	ls_orderno = dw_insert.GetItemString(i, 'orderno')
	ls_saupj   = dw_insert.GetItemString(i, 'saupj')
	ls_ymd     = dw_insert.GetItemString(i, 'yymmdd')
	ls_btime   = dw_insert.GetItemString(i, 'btime')
	ls_factory = dw_insert.GetItemString(i, 'factory')
	ls_itnbr   = dw_insert.GetItemString(i, 'itnbr')
	ll_oseq    = dw_insert.GetItemNumber(i, 'oseq')
	
	If ls_orderno = '.' OR IsNull(ls_orderno) Then
//		ls_orderno = '.'
//		
//		ll_find = dw_insert.Find("saupj='"+ls_saupj+"' and yymmdd='"+ls_ymd+"' and btime='"+ls_btime+&
//										 "' and factory='"+ls_factory+"' and itnbr='"+ls_itnbr+"' and orderno='"+&
//										 ls_orderno+"'", i + 1, ll_cnt)
//		If ll_find > 0 Then
//			MessageBox('중복자료!!', String(ll_find) + '행의 자료는 중복 자료 입니다.')
//			Return -1
//		End If
	Else
		If i = ll_cnt Then Exit
		ll_find = dw_insert.Find("orderno='"+ls_orderno+"' and string(oseq)='"+String(ll_oseq)+"' and itnbr='"+ls_itnbr+&
										 "' and factory='"+ls_factory+"'", i + 1, ll_cnt)
		If ll_find > 0 Then 
			MessageBox('중복자료!!', String(ll_find) + '행의 자료는 중복 자료 입니다.')
			Return -1
		End If
	End If
Next

Return 2
end function

public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date);/*출고처리시 자동으로 장안에서 출고처리, 울산에서 입고처리 하기위한 함수, 입고 전표번호를 리턴한다.
   장안에서 일반출고할 행을 가져와서 자동출고 처리한다.
	arg_rownum : 복사할 행
	arg_imhistdw : 복사할 데이터 윈도우
	arg_date : 출고일자*/

If IsNull(arg_date) Or arg_date = '' Then
	MessageBox('확인', '출고일자를 확인해 주십시요. (automove)')
	Return '-1'
End If
	
String ls_chulStock, ls_chIogbn, ls_chIojpno //출고처리 변수
String ls_ipStock, ls_ipIogbn, ls_ipIojpno //입고처리 변수
Int li_seq, li_chRow, li_ipRow

String ls_cvgu, ls_ipjogun, ls_jumaechul, ls_juhandle, ls_soguan

ls_chulStock = arg_imhistdw.GetItemString(arg_rownum, 'depot_no')

SELECT CVGU, IPJOGUN, JUMAECHUL, JUHANDLE, SOGUAN
INTO :ls_cvgu, :ls_ipjogun, :ls_jumaechul, :ls_juhandle, :ls_soguan
FROM VNDMST
WHERE CVCOD = :ls_chulStock
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 1')
    Return '-1'
End If

//출고창고의 사업장이 울산일경우 울산이동출고처리 하지 않는다.
If ls_ipjogun = '10' Then
	Return '-1'
End If

SELECT CVCOD
INTO :ls_ipStock
FROM VNDMST
WHERE NVL(CVGU, '.') LIKE NVL(:ls_cvgu, '%')
    AND NVL(IPJOGUN, '.') = '10'
    AND NVL(JUMAECHUL, '.') LIKE NVL(:ls_jumaechul, '%')
    AND NVL(JUHANDLE, '.') LIKE NVL(:ls_juhandle, '%')
    AND NVL(SOGUAN, '.') LIKE NVL(:ls_soguan, '%')
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 2')
    Return '-1'
End If

//SELECT CVCOD
//INTO :ls_ipStock
//FROM VNDMST
//WHERE CVGU = '5'
//    AND IPJOGUN = '10'
//    AND JUMAECHUL = '2'    
//    AND JUHANDLE = '1'
//    AND SOGUAN = '1';
//	 
//IF SQLCA.SQLCODE <> 0 THEN
//	MessageBox('출고오류', '울산이동출고 창고조회 오류')
//	Return '-1'
//End If

//ls_chulStock = 'Z07'	//장안 제품창고 (자동 출고창고)
//ls_ipStock = 'Z01' //울산 제품창고 (자동 입고창고)

//공장간 이동입,출고 수불구분
ls_chIogbn = 'OM7'
ls_ipIogbn = 'IM7'

li_seq = SQLCA.FUN_JUNPYO(gs_sabu, arg_date, 'C0')
If li_seq < 0 Then
	RollBack;
	Return '-1'
End If
Commit;

String ls_pspec, ls_itnbr, ls_opseq, ls_ioreemp, ls_filsk, ls_itgu, ls_pjtcd
Double ld_ioqty

ls_pspec = trim(arg_imhistdw.GetItemString(arg_rownum, 'pspec'))
If ls_pspec = '' Or isnull(ls_pspec) Then ls_pspec = '.'

ls_itnbr = arg_imhistdw.GetItemString(arg_rownum, 'itnbr')
ld_ioqty = arg_imhistdw.GetItemNumber(arg_rownum, 'ioqty')
ls_opseq = arg_imhistdw.GetitemString(arg_rownum, 'opseq')
ls_ioreemp = arg_imhistdw.GetitemString(arg_rownum, 'ioreemp')
ls_filsk = arg_imhistdw.GetitemString(arg_rownum, 'filsk')
ls_itgu = arg_imhistdw.GetitemString(arg_rownum, 'itgu')
ls_pjtcd = arg_imhistdw.GetitemString(arg_rownum, 'pjt_cd')

//앞의 자료를 울산출고 자료로 만들어 준다.
arg_imhistdw.SetItem(arg_rownum, 'saupj', '10')
arg_imhistdw.SetItem(arg_rownum, 'depot_no', ls_ipStock)

//자동출고 처리
li_chRow = dw_autoimhist.InsertRow(0)

ls_chIojpno = arg_date + String(li_seq, '0000') + String(li_chRow, '000')

dw_autoimhist.SetItem(li_chRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_chRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_chRow, 'inpcnf', 'O')		//입출고 구분
dw_autoimhist.SetItem(li_chRow, 'iojpno', ls_chIojpno)	
dw_autoimhist.SetItem(li_chRow, 'iogbn', ls_chIogbn)		//수불구분

dw_autoimhist.SetItem(li_chRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_chRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_chRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_chRow, 'depot_no', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_chRow, 'cvcod', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_chRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_chRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_chRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_chRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_chRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_chRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_chRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_chRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_chRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_chRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_chRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_chRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_chRow, 'bigo', '자동출고(울산이동)')

String ls_chSaupj
select ipjogun into :ls_chSaupj from vndmst where cvcod = :ls_chulStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_chRow, 'saupj', ls_chSaupj)

//자동입고 처리
li_ipRow = dw_autoimhist.InsertRow(0)

ls_ipIojpno = arg_date + String(li_seq, '0000') + String(li_ipRow, '000')

dw_autoimhist.SetItem(li_ipRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_ipRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_ipRow, 'inpcnf', 'O')		//입출고 구분
dw_autoimhist.SetItem(li_ipRow, 'iojpno', ls_ipIojpno)	
dw_autoimhist.SetItem(li_ipRow, 'iogbn', ls_ipIogbn)		//수불구분

dw_autoimhist.SetItem(li_ipRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_ipRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_ipRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_ipRow, 'depot_no', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_ipRow, 'cvcod', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_ipRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_ipRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_ipRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_ipRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_ipRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_ipRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_ipRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_ipRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_ipRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_ipRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_ipRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)

String ls_ipSaupj
select ipjogun into :ls_ipSaupj from vndmst where cvcod = :ls_ipStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_ipRow, 'saupj', ls_ipSaupj)

dw_autoimhist.SetItem(li_ipRow, 'ip_jpno', ls_chIojpno)
dw_autoimhist.SetItem(li_ipRow, 'bigo', '자동입고(울산이동)')

Return ls_ipIojpno
end function

public function integer wf_imhist_etc_pda ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null ,ls_confirm_yn
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt , ll_cnt2
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

Dec ld_chqty , ld_ioqty


String ls_depot_in , ls_io_date

String ls_mdepot, ls_lotno

String ls_iojpno

SetNull(ls_null) 

if dw_pda_ins.AcceptText() = -1 then Return -1 

//IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

dw_pda_ins.SetRedraw(False)

String ls_chul
//ls_chul = dw_1.GetItemString(1, 'depot')
//If Trim(ls_chul) = '' OR IsNull(ls_chul) Then
//	MessageBox('확인', '기준 출고창고를 지정하십시오!!')
//	dw_1.SetColumn('depot')
//	dw_1.SetFocus()
//	Return -1
//End If

ls_iogbn     = 'O02'  /* 정상매출 */
ls_iogbn_out = 'O05'  /* 창고이동 출고 */
ls_iogbn_in  = 'I11'  /* 창고이동 입고 */

Select jnpcrt , actiosp
  Into :ls_jnpcrt_1 , :ls_inpcnf_1
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_2 , :ls_inpcnf_2
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_out ;
	
Select jnpcrt , actiosp
  Into :ls_jnpcrt_3 , :ls_inpcnf_3
  From iomatrix 
 Where sabu = '1'
	and iogbn = :ls_iogbn_in ;
	
dw_imhist.Reset()

For i = 1 To dw_pda_ins.Rowcount()


	ls_cvcod = Trim(dw_pda_ins.object.cvcod[i])
	ls_itnbr = Trim(dw_pda_ins.object.itnbr[i])
	ls_mdepot = Trim(dw_pda_ins.object.mdepot[i])  //물류창고
	ls_lotno = Trim(dw_pda_ins.object.lotno[i])
	ls_chul = Trim(dw_pda_ins.object.depot_no[i])  //출고창고

	ll_cnt2 = 0 
	Select count(*) Into :ll_cnt2
	  From vndmst
	 where cvgu = '5'
	   and jumaechul = '4'
		and cvcod = :ls_mdepot ;
		
	ld_chqty = dw_pda_ins.object.yebid1[i]

	If isNull(ld_chqty) Then ld_chqty = 0 
	
	If ll_cnt2 = 0 or ls_mdepot = '' or isNull(ls_mdepot) or ld_chqty = 0 Then
		Continue;
	Else
		dw_pda_ins.object.mdepot_no[i] = ls_mdepot
		dw_pda_ins.object.yebis1[i] = 'Y'
	End iF

	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
//		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
//		dw_pda_ins.ScrollToRow(i)
//		dw_pda_ins.SetFocus()
//		dw_pda_ins.SetColumn("cvcod")
//		dw_pda_ins.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
//		MessageBox('확인','품번을 입력하세요.')
//		dw_pda_ins.ScrollToRow(i)
//		dw_pda_ins.SetFocus()
//		dw_pda_ins.SetColumn("itnbr")
//		dw_pda_ins.SetRedraw(True)
		Return -1
	End If
	
	ls_ymd = Trim(dw_pda_ins.object.yymmdd[i])
	
	If i = 1 Then dw_1.object.jisi_date[1] = ls_ymd
	If i = dw_pda_ins.Rowcount() Then dw_1.object.jisi_date2[1] = ls_ymd
	
	If ls_ymd <> ls_ymd_pre or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_pda_ins.SetRedraw(True)
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')

	ls_ymd_pre = ls_ymd
	
	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_pda_ins.object.factory[i])
	ls_orderno = Trim(dw_pda_ins.object.orderno[i])
	ll_cnt = 1 
	
	if ls_orderno > '.' then
		Select count(*) Into :ll_cnt
		  From reffpf
		 where rfcod = '2U'
			and rfgub = substr(:ls_orderno , -1 , 1 )
			and rfna3 = 'Y' ;
	end if
		

//	If ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) or ( ll_cnt2 > 0 ) Then
		
		If ll_cnt2 > 0 Then
			
			ls_depot_in = ls_mdepot
			
			ls_confirm_yn = 'N'
			ld_ioqty  = 0
			ls_io_date = ls_null
			
			/* 공장별 관리방식으로 변경 - 2007.02.10 - 송병호 */
			Update vndmrp_new set mdepot = :ls_mdepot
			            where factory = :ls_factory
							  and itnbr = :ls_itnbr ;
							  
//			Update vndmrp set mdepot = :ls_mdepot
//			            where cvcod = :ls_cvcod
//							  and itnbr = :ls_itnbr ;
			IF sqlca.sqlnrows = 0 Then
//				MessageBox('확인','품목정보 수정 실패 '+sqlca.sqlerrText )
				Rollback;
				Return -1
			End If
			
		else
			
			ls_confirm_yn = 'Y'
			ld_ioqty  = dw_pda_ins.object.yebid1[i]
			ls_io_date = ls_ymd
			
			Select cvcod 
			  Into :ls_depot_in
				from vndmst
			 Where cvgu = '5'
				and jumaechul = '3'
				and soguan = '1'
				and ipjogun = :ls_saupj
				and jungmock = :ls_factory ;
				
				
			
		end if
		
		/* 전표번호 기록 */
		dw_pda_ins.SetItem(i, 'pda_iojpno', ls_iojpno)
			
		// 창고이동 출고 

		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_pda_ins.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		dw_imhist.object.cvcod     [ll_r] =  ls_depot_in
		
		dw_imhist.object.ioqty     [ll_r] =  dw_pda_ins.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_pda_ins.object.sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_pda_ins.object.yebid1[i] * dw_pda_ins.object.sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_pda_ins.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_pda_ins.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  ls_lotno  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_pda_ins.object.oseq[i],'000000')
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 창고이동 출고'
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_null
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_2
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_2
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_pda_ins.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'L'
		dw_imhist.object.sarea     [ll_r] = dw_pda_ins.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_pda_ins.object.iojpno[i]
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
		/* ----------------------------------------------------- */		
		If cbx_move.Checked = True Then
			String ls_autojpno
			ls_autojpno = wf_automove(ll_r, dw_imhist, ls_ymd)
			If ls_autojpno <> '-1' Then
				dw_imhist.object.ip_jpno   [ll_r] = ls_autojpno
			End If
		End If
		
		// 창고이동 입고 =======================================================================================
		ll_r = dw_imhist.InsertRow(0)
		ll_jpno++
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_in
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_pda_ins.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_depot_in
		dw_imhist.object.cvcod     [ll_r] =  ls_chul//'Z01' 출고창고가 늘어남(제품창고, CKD창고) - BY SHINGOON 2009.11.30
		
		dw_imhist.object.ioqty     [ll_r] =  ld_ioqty
		dw_imhist.object.ioprc     [ll_r] =  dw_pda_ins.object.sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(ld_ioqty * dw_pda_ins.object.sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_pda_ins.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  gs_empno
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  ld_ioqty
		
		dw_imhist.object.io_confirm[ll_r] =  ls_confirm_yn
		
		dw_imhist.object.io_date   [ll_r] =  ls_io_date
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		/*
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		*/
		dw_imhist.object.lotsno    [ll_r] =  ls_lotno  /* LOTNO */
		dw_imhist.object.loteno    [ll_r] =  ls_null
		dw_imhist.object.polcno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.poblno    [ll_r] =  String(dw_pda_ins.object.oseq[i],'000000')
		
		
		dw_imhist.object.filsk     [ll_r] =  'Y'
		//dw_imhist.object.bigo      [ll_r] = '창고이동 입고'
		dw_imhist.object.bigo      [ll_r] = dw_pda_ins.object.bigo[i]
		dw_imhist.object.botimh    [ll_r] = 'N'
		dw_imhist.object.ip_jpno   [ll_r] = ls_iojpno
		dw_imhist.object.itgu      [ll_r] = '5'
		dw_imhist.object.inpcnf    [ll_r] = ls_inpcnf_3
		dw_imhist.object.jnpcrt    [ll_r] = ls_jnpcrt_3
		dw_imhist.object.ioredept  [ll_r] = gs_dept
		dw_imhist.object.ioreemp   [ll_r] = gs_empno
		dw_imhist.object.crt_date  [ll_r] = is_today
		dw_imhist.object.crt_time  [ll_r] = is_totime
		dw_imhist.object.crt_user  [ll_r] = gs_empno
		dw_imhist.object.saupj     [ll_r] = dw_1.object.saupj[1]
		dw_imhist.object.decisionyn[ll_r] = 'Y'
		dw_imhist.object.facgbn    [ll_r] = dw_pda_ins.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_pda_ins.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_pda_ins.object.iojpno[i]
	   //============================================================================================

Next

dw_pda_ins.AcceptText()

If dw_imhist.RowCount() > 0 Then
	If dw_autoimhist.RowCount() > 0 Then	
		/*울산이동출고 저장*/
		IF dw_autoimhist.Update()  <= 0 Then
			ROLLBACK;
//			Messagebox("입출고저장", "울산이동출고 저장실패" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
			dw_pda_ins.SetRedraw(True)
			Return -1
		End If
	end If
	
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
//		Messagebox('확인','imhist 저장실패')
		dw_pda_ins.SetRedraw(True)
		Return -1
	end if
end If

//IF dw_insert.update() <= 0 	THEN
//	ROLLBACK;
////	Messagebox('확인','dw_insert 저장실패')
//	dw_insert.SetRedraw(True)
//	Return -1
//end if

/* pda정보 저장 */
IF dw_pda_ins.update() <= 0 	THEN
	ROLLBACK;
//	Messagebox('확인','dw_pda_ins 저장실패')
	dw_pda_ins.SetRedraw(True)
	Return -1
end if


Commit ;


////출고전표 출력 - 2006.12.08 - 송병호
//wf_chulgo_print(ls_iojpno)

//p_inq.TriggerEvent(Clicked!)
dw_pda_ins.SetRedraw(True)

Return 1
	
end function

on w_sm40_0010.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rb_new=create rb_new
this.rb_del=create rb_del
this.st_2=create st_2
this.cbx_1=create cbx_1
this.p_sort=create p_sort
this.cb_set0=create cb_set0
this.rr_2=create rr_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.p_hmc_excel=create p_hmc_excel
this.p_mobis=create p_mobis
this.st_3=create st_3
this.st_4=create st_4
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_print=create dw_print
this.dw_imhist=create dw_imhist
this.dw_3=create dw_3
this.pb_6=create pb_6
this.p_excel=create p_excel
this.cbx_move=create cbx_move
this.dw_autoimhist=create dw_autoimhist
this.dw_4=create dw_4
this.cb_2=create cb_2
this.cb_4=create cb_4
this.dw_pda=create dw_pda
this.dw_pda_ins=create dw_pda_ins
this.cb_pda_ret=create cb_pda_ret
this.dw_5=create dw_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.rr_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rb_new
this.Control[iCurrent+8]=this.rb_del
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cbx_1
this.Control[iCurrent+11]=this.p_sort
this.Control[iCurrent+12]=this.cb_set0
this.Control[iCurrent+13]=this.rr_2
this.Control[iCurrent+14]=this.pb_3
this.Control[iCurrent+15]=this.pb_4
this.Control[iCurrent+16]=this.pb_5
this.Control[iCurrent+17]=this.p_hmc_excel
this.Control[iCurrent+18]=this.p_mobis
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.st_4
this.Control[iCurrent+21]=this.cb_1
this.Control[iCurrent+22]=this.dw_2
this.Control[iCurrent+23]=this.dw_print
this.Control[iCurrent+24]=this.dw_imhist
this.Control[iCurrent+25]=this.dw_3
this.Control[iCurrent+26]=this.pb_6
this.Control[iCurrent+27]=this.p_excel
this.Control[iCurrent+28]=this.cbx_move
this.Control[iCurrent+29]=this.dw_autoimhist
this.Control[iCurrent+30]=this.dw_4
this.Control[iCurrent+31]=this.cb_2
this.Control[iCurrent+32]=this.cb_4
this.Control[iCurrent+33]=this.dw_pda
this.Control[iCurrent+34]=this.dw_pda_ins
this.Control[iCurrent+35]=this.cb_pda_ret
this.Control[iCurrent+36]=this.dw_5
end on

on w_sm40_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rb_new)
destroy(this.rb_del)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.p_sort)
destroy(this.cb_set0)
destroy(this.rr_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.p_hmc_excel)
destroy(this.p_mobis)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_print)
destroy(this.dw_imhist)
destroy(this.dw_3)
destroy(this.pb_6)
destroy(this.p_excel)
destroy(this.cbx_move)
destroy(this.dw_autoimhist)
destroy(this.dw_4)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.dw_pda)
destroy(this.dw_pda_ins)
destroy(this.cb_pda_ret)
destroy(this.dw_5)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_1.InsertRow(0)

dw_imhist.SetTransObject(SQLCA)
dw_autoimhist.SetTransObject(SQLCA)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
//End If

dw_1.SetItem(1, 'saupj', gs_saupj)

//DataWindowChild ldw_depot
//IF dw_1.GetChild( "depot", ldw_depot ) > 0 THEN
//	ldw_depot.SetTransObject( SQLCA )
//	ldw_depot.Retrieve('10')
////	ldw_depot.Retrieve(gs_code)
//END IF

//p_excel.visible = True
p_search.visible = False

dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

//f_child_saupj(dw_1, 'depot', gs_saupj)

is_pda = 'N'  /* To PDA 버튼을 누르면 'Y' / 저장버튼 눌러 자료 출고저장하면 'N' */

//Timer(10) /* PDA 출하자료를 실시간 처리하기 위해 TIMER 처리 */

rb_new.Checked = True
wf_init()


end event

event timer;call super::timer;cb_4.TriggerEvent('Clicked')

//dw_pda.TriggerEvent('ButtonClicked')
dw_pda.Trigger Event ButtonClicked(1, 1, dw_pda.object.b_conf)

cb_pda_ret.TriggerEvent('Clicked')
if wf_imhist_etc_pda() < 1 Then Return
end event

type dw_insert from w_inherite`dw_insert within w_sm40_0010
string tag = "d_sm40_0010_a_hk"
integer x = 37
integer y = 408
integer width = 4562
integer height = 1892
integer taborder = 10
string dataobject = "d_sm40_0010_a_hk"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value , ls_saupj , ls_name ,ls_ispec , ls_jijil ,ls_null, ls_seogu
Long   ll_cnt
SetNull(ls_null)
ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
dw_1.AcceptText()
ls_saupj = Trim(dw_1.Object.saupj[1])
Choose Case ls_col
	Case 'factory'
		String ls_chk
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_chk
		  FROM REFFPF
		 WHERE SABU = :gs_sabu AND RFCOD = '2A' AND RFGUB = :ls_value ;
		If ls_chk <> 'Y' Then
			MessageBox('확인', '등록된 공장 코드가 아닙니다.')
			This.SetFocus()
			This.SetColumn('factory')
			Return 1
		End If
		
		String ls_itnbr

		ls_itnbr = this.GetItemString(row, 'itnbr')
		
		SELECT NVL(SEOGU, 'N')
		  INTO :ls_seogu
		  FROM VNDMRP_NEW
		 WHERE FACTORY = :ls_value
		   AND ITNBR = :ls_itnbr;
			
		this.SetItem(row, 'seogu', ls_seogu)
	Case 'cvcod'
		
		select cvnas into :ls_name
		  from vndmst
		 where cvcod = :ls_value ;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox('확인','등록된 거래처가 아닙니다.')
			SetItem(row,ls_col,0)
			SetColumn(ls_col)
			Return 1
		End iF
		
		Object.cvnas[row] = ls_name
	
	Case 'itnbr'
	
		Select itdsc , ispec , jijil
		  Into  :ls_name ,:ls_ispec , :ls_jijil
		  From itemas 
		  where itnbr = :ls_value ;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox('확인','등록된 품번이 아닙니다.')
			SetItem(row,ls_col,0)
//			Object.itemas_itdsc[row] = ls_null
//			Object.itemas_ispec[row] = ls_null
//			Object.itemas_jijil[row] = ls_null
			SetColumn(ls_col)
			Return 1
		End iF
		
		String ls_factory
		
		ls_factory = this.GetItemString(row, 'factory')
		
		SELECT NVL(SEOGU, 'N')
		  INTO :ls_seogu
		  FROM VNDMRP_NEW
		 WHERE FACTORY = :ls_factory
		   AND ITNBR = :ls_value;
			
		this.SetItem(row, 'seogu', ls_seogu)
		
//		Object.itemas_itdsc[row] = ls_name
//		Object.itemas_ispec[row] = ls_ispec
//		Object.itemas_jijil[row] = ls_jijil
		
	Case 'mdepot'
		
		If ls_value > '' Then
			Object.yebis1[row] = 'Y'
			Object.yebid1[row] = 0
		else
			Object.yebis1[row] = 'N'
			Object.yebid1[row] = dw_insert.object.napqty[row] - dw_insert.object.ioqty[row]
		end if
		
	
//	Case 'yebis1'
//		
//		If ls_value = 'Y' Then
//			Object.yebid1[row] = 0
//		else
//			Object.yebid1[row] = Object.napqty[row]
//		end if
		
	
End Choose


end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0
String ls_cvcod

	
this.AcceptText()

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.SetItem(row, "itnbr", gs_code)
		
		
//		Open(w_itemas_multi_popup)
//
//		lst_code = Message.PowerObjectParm
//		IF isValid(lst_code) = False Then Return 
//		If UpperBound(lst_code.code) < 1 Then Return 
//		
//		For i = row To UpperBound(lst_code.code) + row - 1
//			ll_i++
//			if i > row then p_ins.triggerevent("clicked")
//			
//			ls_cvcod = Trim(this.object.cvcod[i])
//			If ls_cvcod = '' or isNull(ls_cvcod) Then
//				this.SetItem(i,"cvcod",object.cvcod[i - 1])
//				this.SetItem(i,"cvnas",object.cvnas[i - 1])
//			end iF
//			
//			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			this.TriggerEvent("itemchanged")
//			
//		Next
		
	Case "cvcod"
	
		
		gs_gubun = '1' 
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(row,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	

	/* 2017.07.10 - 한텍, 고객사 공장별 작업사양 조회 선택 */
	Case 'yebis4'
		
		gs_code = Trim(Object.itnbr[row])

		Open(w_itmspec_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(row, "yebis4", gs_Code)

		
END Choose
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm40_0010
boolean visible = false
integer x = 2679
integer y = 4
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0010
boolean visible = false
integer x = 2871
integer y = 16
integer width = 174
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_sm40_0010
integer x = 4096
integer y = 168
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;//

PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;//


PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;/*************************************************************************************************************/
/*-------------------------------------------------------------------------------------------------------------
위아는 2가지 경우로 처리
위아CKD는 구분이 HKMC에서 TO EXCEL로 출고처리
위아 물류출고는 구분이 HKMC가 아닌 상태에서 "생성"버튼으로 처리
 -. M2 자료 생성 시 FACTORY = 'WP'는 제외(모비스 CKD만 처리)
BY SHINGOON 2013.11.07
공장 사양 적용   sm03_weekplan_item_sale.sangyn   -> SM04_DAILY_ITEM_SALE.YEBIS4 : ET , M2 적용
-------------------------------------------------------------------------------------------------------------*/

/*************************************************************************************************************/
String ls_saupj , ls_custcd ,ls_sdate ,ls_edate , ls_gubun, ls_empno, ls_chul
Long   ll_seq

If dw_1.AcceptText() < 1 Then Return

If rb_del.Checked Then
	MessageBox('확인','구분이 MOBIS A/S, 기타(MOBIS), 물류업체 이고 등록상태일때 처리 가능합니다.')
	Return
End IF

ls_saupj = Trim(dw_1.Object.saupj[1])

ls_sdate = Trim(dw_1.Object.jisi_date[1])
ls_edate = Trim(dw_1.Object.jisi_date2[1])

ls_gubun = Trim(dw_1.Object.gubun[1])

If f_datechk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자(시작)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if

If f_datechk(ls_edate) < 1 Then
	f_message_chk(35,'[기준일자(끝)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30, '[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

/*송장번호 채번*/
ll_seq = sqlca.fun_junpyo(gs_sabu,is_today,'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	dw_insert.SetRedraw(True)
	Return -1
END IF
Commit;

pointer oldpointer

oldpointer = SetPointer(HourGlass!)

select fun_get_reffpf_value('AD','10',4) Into :ls_custcd
  from dual ;
  
if ls_gubun = 'M1' then
	
	ls_sdate = Left(ls_sdate,4)+ '0101'
 
	insert into sm04_daily_item_sale (  IOJPNO   ,
													SAUPJ    ,
													YYMMDD   ,
													BTIME		,
													NCARNO   ,
													CUSTCD   ,
													FACTORY  ,
													NEWITS   ,
													ITNBR    ,
													ORDERNO  ,
													OSEQ     ,
													ORDQTY   ,
													NAPQTY   ,
													ARRYMD   ,
													ARRTIME  ,
													SEOGU    ,
													PILOTGU  ,
													CVCOD    ,
													YEBIS1   ,
													YEBIS2   ,
													YEBID1   ,
													YEBID2  ,
													 YEBIS4)
/* 매출은 울산사업장으로 발생되고 출고처리는 장안사업장에서 출고처리 되므로 VAN자료는 울산사업장 기준으로 가져오고
   생성 사업장은 장안사업장으로 생성 시킴 - BY SHINGOON 2016.03.04 */
	select :is_today||Trim(to_char(:ll_seq,'0000')) ||trim( to_char(rownum,'000')) as iojpno ,
			 /*a.saupj      as saupj , - 사업장은 선택된 사업장으로 생성 - by shingoon 2016.03.04 */
			 :ls_saupj    as saupj ,
			 :ls_edate    as yymmdd ,
			 null         as btime ,
			 null         as ncarno ,
			 :ls_custcd   as custcd ,
			 /****************************************************************************************************
			 MOBIS A/S 공장이 참조코드 내에 2건이 있음.
			 아래 FUNCTION으로 처리 시 MAS공장이 아닌 M7공장으로 처리 됨
			 (주)한텍 황성환DR 요청으로 'MAS'공장으로 고정 처리
			 - BY SHINGOON 2013.08.30
			 fun_get_reffpf_rfgub('2A',a.mcvcod,'1')  as factory ,
			 ****************************************************************************************************/
			 'MAS'        as factory ,
			 null         as newits  ,
			 a.mitnbr     as itnbr   ,   
			 a.ordno      as orderno , 
			 a.ord_seq    as oseq    ,
			 a.ord_qty    as ordqty  ,
		 	 nvl((select sum(x.ioqty) from imhist x 
											 where x.lotsno = a.ordno 
											   and to_number(x.loteno) = a.ord_seq ),0)   as napqty  ,
			 :is_today    as arrymd  ,
			 substr(:is_totime,1,4)         as arrtime ,
			 'N'          as seogu   ,
			 null         as pilotgu , 
			 a.mcvcod     as cvcod   ,   
			 null         as yebis1  ,
			 'M1'         as yebis2  ,
			 0            as yebid1  ,
			 null         as yebid2 ,
			 fun_get_mes_itnbr_sayang( a.mitnbr,'MAS' ) as  YEBIS4
	  from van_mobis_br a 
	 where a.saupj = '10'//:ls_saupj - VAN자료는 울산사업장(10)으로만 접수 됨 - BY SHINGOON 2016.03.04
		and a.due_date_boogook between :ls_sdate and :ls_edate 
//		and ( a.ord_qty >  
//			   nvl((select sum(x.ioqty) from imhist x 
//											   where x.lotsno = a.ordno 
//											     and to_number(x.loteno) = a.ord_seq ),0) )
		/* 아래 스크립트 실행 시 분납 발주건에 대해서는 재 출고 불가능 - by shingoon 2007.01.12 */
		/* 이미 생성된 자료는 중복생성 되지 않게 하기 위함. - 2006.10.25 by sHInGooN */
		and not exists (select 'x'
		                  from sm04_daily_item_sale 
		                 where saupj = :ls_saupj /*a.saupj - 생성된 자료는 장안사업장(20)으로 생성 됨 - by shingoon 2016.03.04 */
		                   and orderno = a.ordno
						       and itnbr = a.mitnbr
								 and yebis2 = 'M1'
								 and napqty = 0) 
		and exists (select 'x' from itemas where itnbr =  a.mitnbr )
			  ;
			  
	If sqlca.sqlnrows <= 0 Then
		MessageBox('확인','MOBIS A/S 발주내역이 없습니다.'+sqlca.sqlerrText)
		rollback;
		return
	End if
	
	commit;
	
elseif ls_gubun = 'M2' then
	
	insert into sm04_daily_item_sale (  IOJPNO   ,
													SAUPJ    ,
													YYMMDD   ,
													BTIME		,
													NCARNO   ,
													CUSTCD   ,
													FACTORY  ,
													NEWITS   ,
													ITNBR    ,
													ORDERNO  ,
													OSEQ     ,
													ORDQTY   ,
													NAPQTY   ,
													ARRYMD   ,
													ARRTIME  ,
													SEOGU    ,
													PILOTGU  ,
													CVCOD    ,
													YEBIS1   ,
													YEBIS2   ,
													YEBID1   ,
													YEBID2  ,
													YEBIS4)

     SELECT :is_today||Trim(to_char(:ll_seq,'0000')) ||trim( to_char(rownum,'000')) as IOJPNO,
				SAUPJ    ,
				YYMMDD   ,
				BTIME		,
				NCARNO   ,
				CUSTCD   ,
				FACTORY  ,
				NEWITS   ,
				ITNBR    ,
				ORDERNO  ,
				OSEQ     ,
				ORDQTY   ,
				NAPQTY   ,
				ARRYMD   ,
				ARRTIME  ,
				SEOGU    ,
				PILOTGU  ,
				CVCOD    ,
				YEBIS1   ,
				YEBIS2   ,
				YEBID1   ,
				YEBID2  ,
				YEBIS4
		 FROM (
					select a.saupj      as saupj ,
							 to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')     as yymmdd ,
							 null         as btime ,
							 null         as ncarno ,
							 :ls_custcd   as custcd ,
							 a.plnt		  as factory ,
				/*			 fun_get_reffpf_rfgub('2A',a.cvcod,'1')  as factory ,		*/
							 null         as newits  ,
							 a.itnbr      as itnbr   ,   
							 null         as orderno , 
							 0            as oseq    ,
							 a.itm_qty1   as ordqty  ,
							 a.itm_qty1   as napqty  ,
							 :is_today    as arrymd  ,
							 substr(:is_totime,1,4)         as arrtime ,
							 'N'          as seogu   ,
							 null         as pilotgu , 
							 a.cvcod      as cvcod   ,   
							 null         as yebis1  ,
							 'M2'         as yebis2  ,
							 0            as yebid1  ,
							 null         as yebid2 ,
							 a.sangyn  as YEBIS4
					  from sm03_weekplan_item_sale a /* 주간판매 계획은 장안사업장으로 생성 - by shingoon 2016.03.04 */  
					 where a.saupj = :ls_saupj
						and to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')  between :ls_sdate and :ls_edate
						and a.plnt in ('M2','M3','M4','M5','M6')
				/*		and a.plnt in ('M1','M2','M3','M4','M5','M6')	*/
						and not exists (select 'x'
												from sm04_daily_item_sale 
											  where saupj = a.saupj
												 and yymmdd = to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')
												 and itnbr = a.itnbr
												 and factory = a.plnt
												 and yebis2 = 'M2' )
				/*	   and a.gubun = 'MAT' ;	*/
				
					/* MOBIS CKD 반영 - 2007.03.27 - 송병호 */
					union all
					select :ls_saupj    as saupj ,
							 YODATE       as yymmdd ,
							 null         as btime ,
							 null         as ncarno ,
							 :ls_custcd   as custcd ,
							 a.FACTORY	  as factory ,
				/*			 fun_get_reffpf_rfgub('2A',a.cvcod,'1')  as factory ,		*/
							 null         as newits  ,
							 a.itnbr      as itnbr   ,   
							 A.BALNO      as orderno , 
							 TO_NUMBER(A.BALSEQ)    as oseq    ,
							 a.BALQTY     as ordqty  ,
							 a.BALQTY     as napqty  ,
							 :is_today    as arrymd  ,
							 substr(:is_totime,1,4)         as arrtime ,
							 'N'          as seogu   ,
							 null         as pilotgu , 
							 a.MCVCOD     as cvcod   ,   
							 null         as yebis1  ,
							 'M2'         as yebis2  ,
							 0            as yebid1  ,
							 null         as yebid2  ,
							 fun_get_mes_itnbr_sayang( a.itnbr, a.FACTORY)   as  YEBIS4
					  from VAN_MOBIS_CKD_B a 
					 where A.YODATE <> '00000000'
					   AND to_char(to_date(a.YODATE, 'yyyymmdd') + 1, 'yyyymmdd')  between :ls_sdate and :ls_edate
					 /***********************************************************************************/
					   AND A.FACTORY <> 'WP' //위아 CKD는 TO_EXCEL로 처리 - BY SHINGOON 2013.11.07
 					 /***********************************************************************************/
						and not exists (select 'x'
												from sm04_daily_item_sale 
											  where saupj = :ls_saupj
												 and yymmdd = a.yodate //to_char(to_date(a.YODATE) + 1,'yyyymmdd')
												 and itnbr = a.itnbr
												 and factory = a.FACTORY
												 and orderno = A.BALNO
												 and oseq    = TO_NUMBER(A.BALSEQ)
												 and yebis2  = 'M2' )
			) ;
	
		
	If sqlca.sqlnrows <= 0 Then
		MessageBox('확인-' + String(SQLCA.SQLCODE), 'MOBIS AUTO 판매계획이 없습니다.' + sqlca.sqlerrText)
		rollback;
		return
	End if
	
	commit;
	
elseif ls_gubun = 'ET' then
	
	insert into sm04_daily_item_sale (  IOJPNO   ,
													SAUPJ    ,
													YYMMDD   ,
													BTIME		,
													NCARNO   ,
													CUSTCD   ,
													FACTORY  ,
													NEWITS   ,
													ITNBR    ,
													ORDERNO  ,
													OSEQ     ,
													ORDQTY   ,
													NAPQTY   ,
													ARRYMD   ,
													ARRTIME  ,
													SEOGU    ,
													PILOTGU  ,
													CVCOD    ,
													YEBIS1   ,
													YEBIS2   ,
													YEBID1   ,
													YEBID2  ,
													YEBIS4)
   select :is_today||Trim(to_char(:ll_seq,'0000')) ||trim( to_char(rownum,'000')) as iojpno ,
			 a.saupj      as saupj ,
			 to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')     as yymmdd ,
			 null         as btime ,
			 null         as ncarno ,
			 :ls_custcd   as custcd ,
			 a.plnt       as factory ,
			 null         as newits  ,
			 a.itnbr      as itnbr   ,   
			 null         as orderno , 
			 0            as oseq    ,
			 a.itm_qty1   as ordqty  ,
			 a.itm_qty1   as napqty  ,
			 :is_today    as arrymd  ,
			 substr(:is_totime,1,4)         as arrtime ,
			 'N'          as seogu   ,
			 null         as pilotgu , 
			 a.cvcod      as cvcod   ,   
			 null         as yebis1  ,
			 'ET'         as yebis2  ,
			 0            as yebid1  ,
			 null         as yebid2  ,
			 a.sangyn    as YEBIS4
  	  from sm03_weekplan_item_sale a 
	 where a.saupj = :ls_saupj
	   and to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')  between :ls_sdate and :ls_edate
		and not exists (select 'x'
		                  from sm04_daily_item_sale 
		                 where saupj = a.saupj
		                   and yymmdd = to_char(to_date(a.yymmdd, 'yyyymmdd') + 1,'yyyymmdd')
						   	 and itnbr = a.itnbr
								 and factory = a.plnt
								 and yebis2 = 'ET' ) 
		/* 공장별 관리방식으로 변경 - 2007.02.10 - 송병호 */
	   and exists (select 'x' from vndmrp_new where factory = a.plnt
	                                        and itnbr = a.itnbr
											and mdepot is not null )  ;
		
//	   and exists (select 'x' from vndmrp where cvcod = a.cvcod
//	                                        and itnbr = a.itnbr
//											and mdepot is not null )  ;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인','물류업체에 출고예정인 주간계획이 없습니다.'+sqlca.sqlerrText)
		rollback;
		return
	End if
	
	commit;
	
end if

SetPointer(oldpointer)

p_inq.TriggerEvent(Clicked!)
	
	
end event

type p_ins from w_inherite`p_ins within w_sm40_0010
integer x = 3922
integer y = 168
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Long		lrow
String   ls_gubun, ls_saupj, ls_custcd, ls_empno, ls_chul

If dw_1.AcceptText() < 1 Then Return

If rb_del.Checked Then
	MessageBox('확인','등록상태일때 처리 가능합니다.')
	Return
End IF

ls_gubun = Trim(dw_1.Object.gubun[1])
if ls_gubun <> 'HK' AND ls_gubun <> 'M1' AND ls_gubun <> 'M2' then
	MessageBox('확인','구분이 HKMC(랩도스), MOBIS A/S, MOBIS AUTO 일때 처리 가능합니다.')
	Return
End IF

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30,'[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

//gs_code = dw_1.getitemstring(1,'saupj')
//open(w_sm40_0010_pop2)
//if gs_code = 'OK' then
//	p_inq.TriggerEvent(Clicked!)
//end if

/* 일단 기능 사용 중지(행 추가로 등록) - 2013.09.13 */
//If ls_gubun = 'HK' Then
//	/* D1접수 내역을 조회해서 선택(발주번호 지정하기 위함) - by shingoon 2013.09.04 */
//	dw_2.Visible = True
//	
//	String ls_sdate, ls_edate, ls_itnbr_fr, ls_itnbr_to, ls_factory, ls_mdepot
//	Long   ll_rcnt , i
//	dw_1.AcceptText() 
//	dw_insert.AcceptText() 
//	
//	ls_saupj = Trim(dw_1.Object.saupj[1])
//	ls_sdate = Trim(dw_1.Object.jisi_date[1])
//	ls_edate = Trim(dw_1.Object.jisi_date2[1])
//	
//	If f_datechk(ls_sdate) < 1 Then
//		f_message_chk(35,'[기준일자(시작)]')
//		dw_1.setitem(1, "jisi_date", '')
//		dw_1.SetFocus()
//		return 
//	end if
//	
//	If f_datechk(ls_edate) < 1 Then
//		f_message_chk(35,'[기준일자(끝)]')
//		dw_1.setitem(1, "jisi_date", '')
//		dw_1.SetFocus()
//		return 
//	end if
//		
//	ls_itnbr_fr = Trim(dw_1.Object.itnbr_from[1])
//	ls_itnbr_to = Trim(dw_1.Object.itnbr_from[1])
//	
//	ls_factory = Trim(dw_1.Object.factory[1])
//	
//	If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) then ls_itnbr_fr = '.'
//	If ls_itnbr_to = '' or isNull(ls_itnbr_to) then ls_itnbr_to = 'z'
//	If ls_factory = '' or isNull(ls_factory) or ls_factory= '.'  then ls_factory = '%'
//	
//	dw_2.SetRedraw(False)
//	Long   ll_rtn
//	ll_rtn = dw_2.Retrieve(ls_saupj, ls_sdate, ls_edate, ls_factory, ls_itnbr_fr, ls_itnbr_to)
//	dw_2.SetRedraw(True)
//	
//	If ll_rtn < 1 Then
//		MessageBox('자료 조회', '해당 기간에 미 출고된 검수내역이 없습니다.~r~n(기간, 공장, 품번 등의 조회조건을 확인 하십시오.)')
//		dw_2.Visible = False
//		Return
//	End If
//Else
	/* 추가등록은 팝업창이 아닌 직접 등록 (서선주) - 2007.01.23 */
	lrow = dw_insert.insertrow(0)
	
	ls_saupj = dw_1.getitemstring(1,'saupj')
	dw_insert.setitem(lrow, 'saupj', ls_saupj)
	
	select rfna5 into :ls_custcd from reffpf where rfcod = 'AD' and rfgub = :ls_saupj ;
	dw_insert.setitem(lrow, 'custcd', ls_custcd)
	
	dw_insert.setitem(lrow, 'yebis2', ls_gubun)
	dw_insert.setitem(lrow, 'oseq', 0)
	dw_insert.setitem(lrow, 'seogu', 'N')
//End If

end event

type p_exit from w_inherite`p_exit within w_sm40_0010
integer taborder = 0
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0010
integer taborder = 0
end type

event p_can::clicked;call super::clicked;cbx_1.visible = False
p_ins.visible = True
//p_excel.visible = True
p_search.visible = False


/***************************************************************/
/* 2016.12.21 - 사업장별 창고지정 오류 발생으로 아래 구문을 wf_init() 호출로 대체 함  */
//dw_insert.SetRedraw(False)
//dw_insert.Reset()
//dw_insert.SetRedraw(True)
//dw_autoimhist.Reset()
//
//dw_1.SetRedraw(False)
//dw_1.Reset()
//dw_1.InsertRow(0)
//
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
//End If
//
//dw_1.Object.jisi_date[1] = is_today
//dw_1.Object.jisi_date2[1] = is_today
//
//dw_1.SetRedraw(True)
//
wf_init()


end event

type p_print from w_inherite`p_print within w_sm40_0010
boolean visible = false
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_sm40_0010
integer x = 3922
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String ls_saupj , ls_sdate , ls_edate , ls_itnbr_fr , ls_itnbr_to , ls_empno , ls_factory ,ls_gubun ,ls_mdepot
Long   ll_rcnt , i
dw_1.AcceptText() 
dw_insert.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.jisi_date[1])
ls_edate = Trim(dw_1.Object.jisi_date2[1])

ls_gubun = Trim(dw_1.Object.gubun[1])

If f_datechk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자(시작)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if

If f_datechk(ls_edate) < 1 Then
	f_message_chk(35,'[기준일자(끝)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if
	
ls_itnbr_fr = Trim(dw_1.Object.itnbr_from[1])
ls_itnbr_to = Trim(dw_1.Object.itnbr_from[1])

ls_factory = Trim(dw_1.Object.factory[1])
ls_empno = Trim(dw_1.Object.empno[1])

If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) then ls_itnbr_fr = '.'
If ls_itnbr_to = '' or isNull(ls_itnbr_to) then ls_itnbr_to = 'z'
If ls_factory = '' or isNull(ls_factory) or ls_factory= '.'  then ls_factory = '%'
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

String ls_mul

ls_mul = dw_1.GetItemString(1, 'mcvcod')
If Trim(ls_mul) = '' OR IsNull(ls_mul) Then ls_mul = '%'

dw_insert.SetRedraw(False)

//messageBox('', ls_saupj +' '+ ls_sdate +' '+  ls_edate +' '+  ls_factory +' '+ ls_itnbr_fr +' '+  ls_itnbr_to+' '+  ls_empno +' '+ ls_gubun )

If ls_gubun = 'ET' Then
	ll_rcnt = dw_insert.Retrieve(ls_saupj, ls_sdate, ls_edate, ls_factory, ls_itnbr_fr, ls_itnbr_to, ls_empno, ls_gubun, ls_mul)
Else
	ll_rcnt = dw_insert.Retrieve( ls_saupj , ls_sdate , ls_edate , ls_factory ,ls_itnbr_fr , ls_itnbr_to, ls_empno ,ls_gubun ) 
End If

Long ll_nap, ll_io
If ll_rcnt > 0 Then
	If rb_new.Checked Then
		If ls_gubun = 'HK' then
			For i = 1 To ll_rcnt 
				
				ls_mdepot = Trim(dw_insert.object.mdepot[i] )
				If isNull(ls_mdepot) = false Then continue ;
				ll_nap = dw_insert.object.napqty[i]
				ll_io  = dw_insert.object.ioqty[i]
				If IsNull(ll_io) Then ll_io = 0
				If IsNull(ll_nap) Then ll_nap = 0
//				dw_insert.object.yebid1[i] = dw_insert.object.napqty[i] - dw_insert.object.ioqty[i]
				dw_insert.object.yebid1[i] = ll_nap - ll_io
			Next
		End if
	End if
	
Else
	Messagebox('확인','조건에 해당하는 데이타가 없습니다.')

End iF
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm40_0010
integer x = 4270
integer y = 168
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Long i ,ll_rcnt , ll_cnt , ii
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust ,ls_new 
String ls_iojpno , ls_ipjpno , ls_null , ls_ipconf 

Long   ll_conf , ll_cnt2, ll_chlqty, ll_cnt3
Dec    ld_napqty , ld_ioqty

SetNull(ls_null)
if dw_1.AcceptText() = -1 then return -1

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_gubun = Trim(dw_1.Object.gubun[1])

if dw_insert.AcceptText() = -1 then return -1
if dw_insert.rowcount() <= 0 then return -1

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	dw_insert.SetRedraw(TRUE)
	Return
End IF

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

Long    ll_err
String  ls_err
String  ls_sm04jpno, ls_rowid

ii = 0 
For i = ll_rcnt To 1 Step -1
	
	If dw_insert.isSelected(i) Then

		If rb_del.Checked Then
			
			ls_iojpno = Trim(dw_insert.object.iojpno[i])
			ls_ipjpno = Trim(dw_insert.object.pjt_cd[i])

			If ls_gubun = 'HK' Then
				
				ll_conf = dw_insert.object.conf[i]
				ls_cvcod = dw_insert.object.cvcod[i]
				
				ll_cnt2=0
				Select count(*) Into :ll_cnt2
				  from vndmst
				 where cvgu = '5'
				   and jumaechul = '4'
					and cvcod = :ls_cvcod ; 
				
				If ll_conf > 0  and ll_cnt2 > 0 Then
					MessageBox('확인',String(i) +'행은 삭제 불가능합니다. 이미 물류업체 입고처리 된 항목입니다.')
					dw_insert.ScrollToRow(i)
					p_inq.TriggerEvent(Clicked!)
					dw_insert.SetRedraw(TRUE)
					Return
				End If
				
				Update sm04_daily_item_sale Set yebis1 = :ls_null ,
				                                mdepot_no = :ls_null
												 where iojpno = :ls_ipjpno ;
				If sqlca.sqlnrows = 0 Then
					MessageBox('확인',sqlca.sqlerrText)
					Rollback;
					MessageBox('확인','삭제 실패3')
					dw_insert.SetRedraw(TRUE)
					return
				End if		
			End if
			
			If ls_gubun = 'ET' Then
				
				ll_conf = dw_insert.object.conf[i]
				ls_cvcod = dw_insert.object.cvcod[i]
				ll_chlqty = dw_insert.object.ioqty[i]
				
				ll_cnt2=0
				Select count(*) Into :ll_cnt2
				  from vndmst
				 where cvgu = '5'
				   and jumaechul = '4'
					and cvcod = :ls_cvcod ; 
				
				If ll_conf > 0  and ll_cnt2 > 0 Then
					MessageBox('확인',String(i) +'행은 삭제 불가능합니다. 이미 물류업체 입고처리 된 항목입니다.')
					dw_insert.ScrollToRow(i)
					p_inq.TriggerEvent(Clicked!)
					dw_insert.SetRedraw(TRUE)
					Return
				End If
				
				/* PDA처리 여부 확인 */
				SELECT SM04JPNO, ROWID INTO :ls_sm04jpno, :ls_rowid FROM PDA_GET_SCANLIST WHERE IOJPNO = :ls_iojpno ;
				If Trim(ls_sm04jpno) = '' OR IsNull(ls_sm04jpno) Then
					Update sm04_daily_item_sale Set yebid1 = yebid1 - :ll_chlqty
					 where iojpno = :ls_ipjpno ;
				
					If sqlca.sqlnrows = 0 Then
						MessageBox('확인',sqlca.sqlerrText)
						Rollback;
						MessageBox('확인','삭제 실패4-1')
						dw_insert.SetRedraw(TRUE)
						return
					End if
				Else
					UPDATE SM04_DAILY_ITEM_SALE SET YEBID1 = YEBID1 - :ll_chlqty
					 WHERE IOJPNO = :ls_sm04jpno ;
				
					If sqlca.sqlnrows = 0 Then
						MessageBox('확인',sqlca.sqlerrText)
						Rollback;
						MessageBox('확인','삭제 실패4-2')
						dw_insert.SetRedraw(TRUE)
						return
					End if
					
					UPDATE PDA_GET_SCANLIST
					   SET IOJPNO = '', SM04JPNO = ''
					 WHERE IOJPNO = :ls_iojpno AND ROWID = :ls_rowid ;
				
					If sqlca.sqlnrows = 0 Then
						MessageBox('확인',sqlca.sqlerrText)
						Rollback;
						MessageBox('확인','삭제 실패5')
						dw_insert.SetRedraw(TRUE)
						return
					End if
				End If
				
			End if
			
			/* IP_JPNO 검색하면 매입자료나 기타 자료까지 검색이 되어서 삭제 됨 - BY SHINGOON 2016.12.26
			Delete From imhist where sabu = '1' and ( iojpno = :ls_iojpno or ip_jpno = :ls_iojpno ) ;
			*/
			Delete From imhist where sabu = '1' and ( iojpno = :ls_iojpno ) ;
			If sqlca.sqlcode <> 0 Then
				MessageBox('확인',sqlca.sqlerrText)
				Rollback;
				MessageBox('확인','삭제 실패2')
				dw_insert.SetRedraw(TRUE)
				return
			End if
			
			/* 물류처 창고이동 자료는 삭제가 되지 않아서 삭제 처리 함 - BY SHINGOON 2017.03.13 */
			DELETE FROM IMHIST WHERE SABU = '1' AND IP_JPNO = :ls_iojpno AND IOGBN = 'I11' ;
			If sqlca.sqlcode <> 0 Then
				MessageBox('확인',sqlca.sqlerrText)
				Rollback;
				MessageBox('확인','삭제 실패3')
				dw_insert.SetRedraw(TRUE)
				return
			End if
			
			
			/* 공장품번 수불 삭제 처리-20180821_dyyoon imhist트리거처리함 */
//			DELETE FROM IMHIST where sabu = '1' and pjt_cd = :ls_iojpno and iogbn in ('O25','I13') ;
//			If sqlca.sqlcode <> 0 Then
//				MessageBox('확인',sqlca.sqlerrText)
//				Rollback;
//				MessageBox('확인','공장수불 삭제실패')
//				dw_insert.SetRedraw(TRUE)
//				return
//			End if
			
			/*울산이동출고자료 삭제 */
			/*2016.01.21 신동준*/
			/* 자동수불용 수불구분 변경(IM7, OM7) - BY SHINGOON 2016.02.26 */
			/* 2명이상의 작업자가 작업시 한쪽은 등록되기전 자료가 조회 되있고 한쪽은 이미 등록이 완료된 상태에서 등록되기전 자료가 있는곳에서 삭제를 할 경우 
			    자동수불 데이터가 남아있으므로 삭제 체크 되어있을때만 수불자료 삭제 되도록 수정 2023.07.24 by dykim */
			String ls_ipjpnoIM7
			ls_ipjpnoIM7 = Trim(dw_insert.object.ip_jpno[i])
			IF IsNull(ls_ipjpnoIM7) = False Then
				String ls_IM7jpno
			
				SELECT IP_JPNO
				INTO :ls_IM7jpno
				FROM IMHIST
				WHERE SABU = '1' AND IOGBN = 'IM7' AND IOJPNO = :ls_ipjpnoIM7;
			
				DELETE FROM IMHIST WHERE SABU = '1' AND IOGBN = 'IM7' AND IOJPNO = :ls_ipjpnoIM7;
					IF SQLCA.SQLCODE <> 0 THEN
					ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
					ROLLBACK USING SQLCA;
					MessageBox('Delete Err [' + String(ll_err) + ']', '울산이동 출고 자료 삭제 오류[-20011]~r~n' + ls_err)
					Return
				END IF
			
				DELETE FROM IMHIST WHERE SABU = '1' AND IOGBN = 'OM7' AND IOJPNO = :ls_IM7jpno;
				IF SQLCA.SQLCODE <> 0 THEN
					ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
					ROLLBACK USING SQLCA;
					MessageBox('Delete Err [' + String(ll_err) + ']', '울산이동 출고 자료 삭제 오류[-20012]~r~n' + ls_err)
					Return
				END IF
			End If
		
			/* pda스캔내역 정리 - by shingoon 20180521 */
			UPDATE PDA_GET_SCANLIST
			   SET IOJPNO = NULL, SM04JPNO = NULL
			 WHERE SM04JPNO = :ls_ipjpno
			   AND IOJPNO   = :ls_iojpno ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Delete Err [' + String(ll_err) + ']', 'PDA스캔 내역 삭제 오류[-20013]~r~n' + ls_err)
		         Return
			End If
	
	
			dw_insert.ScrollToRow(i)
			dw_insert.DeleteRow(i)
			
			
		else
			
			ls_iojpno = Trim(dw_insert.object.iojpno[i])

			ld_ioqty  = dw_insert.object.ioqty[i]
			
			If ld_ioqty > 0 Then
				Rollback;
				MessageBox('확인','이미 입고처리된 수량이 있습니다. 삭제 불가합니다.')
				dw_insert.SetRedraw(TRUE)
				return
			End if
			
			/* 저장버튼을 눌러 자동수불이 일어난 자료일경우 삭제 못하도록 수정 2023.07.24 by dykim */
			SELECT COUNT('X')
			   INTO :ll_cnt3
		      FROM  IMHIST
			WHERE PJT_CD = :ls_iojpno
			    AND  IOGBN IN ('OM7', 'IM7');
			
			If ll_cnt3 > 0 Then
				Rollback;
				MessageBox('확인', '이미 등록된 자료 입니다. 재조회 후 확인하여 주시기 바랍니다.')
				dw_insert.SetRedraw(TRUE)
				return
			End if
			
			ls_new = Trim(dw_insert.object.is_new[i])
			If ls_new = 'N' Then
				Delete From sm04_daily_item_sale where iojpno = :ls_iojpno ;
				If sqlca.sqlnrows = 0 Then
					Rollback;
					MessageBox('확인','삭제 실패2')
					dw_insert.SetRedraw(TRUE)
					return
				End if
			End If
			
			dw_insert.ScrollToRow(i)
			dw_insert.DeleteRow(i)
			
		End if
		
		/*울산이동출고자료 삭제 */
		/*2016.01.21 신동준*/
		/* 자동수불용 수불구분 변경(IM7, OM7) - BY SHINGOON 2016.02.26 */
		/*String ls_ipjpnoIM7
		ls_ipjpnoIM7 = Trim(dw_insert.object.ip_jpno[i])
		IF IsNull(ls_ipjpnoIM7) = False Then
			String ls_IM7jpno
			
			SELECT IP_JPNO
			INTO :ls_IM7jpno
			FROM IMHIST
			WHERE SABU = '1' AND IOGBN = 'IM7' AND IOJPNO = :ls_ipjpnoIM7;
			
			DELETE FROM IMHIST WHERE SABU = '1' AND IOGBN = 'IM7' AND IOJPNO = :ls_ipjpnoIM7;
			IF SQLCA.SQLCODE <> 0 THEN
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Delete Err [' + String(ll_err) + ']', '울산이동 출고 자료 삭제 오류[-20011]~r~n' + ls_err)
				Return
			END IF
			
			DELETE FROM IMHIST WHERE SABU = '1' AND IOGBN = 'OM7' AND IOJPNO = :ls_IM7jpno;
			IF SQLCA.SQLCODE <> 0 THEN
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Delete Err [' + String(ll_err) + ']', '울산이동 출고 자료 삭제 오류[-20012]~r~n' + ls_err)
				Return
			END IF
		End If
		
		/* pda스캔내역 정리 - by shingoon 20180521 */
		UPDATE PDA_GET_SCANLIST
		   SET IOJPNO = NULL, SM04JPNO = NULL
		 WHERE SM04JPNO = :ls_ipjpno
		   AND IOJPNO   = :ls_iojpno ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
			MessageBox('Delete Err [' + String(ll_err) + ']', 'PDA스캔 내역 삭제 오류[-20013]~r~n' + ls_err)
         Return
		End If
	
	
		dw_insert.ScrollToRow(i)
		dw_insert.DeleteRow(i)
		*/
		
		ii++
	End if		

	
Next

commit ;

sle_msg.text =	string(ii) + "건의 자료를 삭제하였습니다!!"	
	
dw_insert.SetRedraw(TRUE)
end event

type p_mod from w_inherite`p_mod within w_sm40_0010
integer x = 4096
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;String ls_gubun

If rb_del.Checked Then 
	Messagebox('확인','등록 상태일때 저장가능합니다.')
	Return
End if

If dw_1.AcceptText() < 1 Then Return
if wf_setitem_new() < 1 Then Return

ls_gubun = Trim(dw_1.object.gubun[1])
If ls_gubun = 'HK' Then
	if wf_dup() < 1 Then Return
	if wf_imhist_hk() < 1 Then Return
elseIf ls_gubun = 'M1' Then
	if wf_imhist_m1() < 1 Then Return
elseIf ls_gubun = 'M2' Then
	if wf_imhist_m2() < 1 Then Return
else
//	/* is_pda = 'Y'   To PDA 버튼을 누르면 'Y' 저장버튼 눌러 자료 출고저장하면 'N' */
//	If is_pda <> 'Y' Then
		if wf_imhist_etc() < 1 Then Return /* PDA출하 불러오기 처리로 수정 함 - by shingoon 20180518 */
//	Else
//		cb_pda_ret.TriggerEvent('Clicked')
//		if wf_imhist_etc_pda() < 1 Then Return
//		
//		is_pda = 'N'
//	End If
end if
end event

type cb_exit from w_inherite`cb_exit within w_sm40_0010
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0010
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0010
end type

type cb_del from w_inherite`cb_del within w_sm40_0010
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0010
end type

type cb_print from w_inherite`cb_print within w_sm40_0010
end type

type st_1 from w_inherite`st_1 within w_sm40_0010
end type

type cb_can from w_inherite`cb_can within w_sm40_0010
end type

type cb_search from w_inherite`cb_search within w_sm40_0010
end type







type gb_button1 from w_inherite`gb_button1 within w_sm40_0010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0010
end type

type rr_3 from roundrectangle within w_sm40_0010
string tag = "KMC"
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3045
integer y = 80
integer width = 251
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sm40_0010
string tag = "KMC"
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2830
integer y = 92
integer width = 251
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sm40_0010
event ue_keydown pbm_dwnprocessenter
event ue_enter pbm_dwnprocessenter
integer x = 27
integer y = 12
integer width = 3287
integer height = 324
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(This), 256, 9, 0)
Return 1
end event

event itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case 'saupj'
		f_child_saupj(dw_1, 'depot', data)
	Case "gubun"
		
		cbx_1.visible = False
		
		If rb_new.Checked Then
			
			If ls_value = 'HK' then
//				p_excel.visible = True
//			   p_hmc_excel.visible = True
				p_search.visible = False
				cb_1.Visible = False
			else
//				p_excel.visible = False
//			   p_hmc_excel.visible = False
				p_search.visible = True
				If ls_value = 'M1' Then
					cb_1.Visible = True
				Else
					cb_1.Visible = False
				End If					
			end if
			//MOBIS AUTO 출고등록 시 추가작업 가능 - 개발ITEM 등록 관련 : 2007.03.27 BY SHINGOON (서선주JI)
			If ls_value = 'HK' Or ls_value = 'M1' OR ls_value = 'M2' then
				p_ins.visible = True
			else
				p_ins.visible = False
			end if
			
			If ls_value = 'HK' Then
				dw_insert.Dataobject = 'd_sm40_0010_a_hk'
				st_2.Text="※ 납품서 발행(랩토스 처리) 후 물류업체 출고는 수량없이 납품서만 이동합니다."
				p_mobis.visible = False
				cb_4.Enabled = False
	      elseif ls_value = 'M1' Then
				dw_insert.Dataobject = 'd_sm40_0010_a_m1'
				st_2.Text="※ MOBIS A/S 는  VAN 발주정보에서 출고처리 합니다."
//				p_mobis.visible = True
				cb_4.Enabled = False
			elseif ls_value = 'M2' Then
				cbx_1.visible = True
				dw_insert.Dataobject = 'd_sm40_0010_a_m2'
				st_2.Text="※ MOBIS AUTO 및 기타업체는 주간(상차)계획에서 출고처리 합니다."
				p_mobis.visible = False
				cb_4.Enabled = False
			else
				cbx_1.visible = True
				dw_insert.Dataobject = 'd_sm40_0010_a_et'
				st_2.Text="※ 주간(상차)계획에서 품목정보수정의 물류업체 지정된 품목만 출고처리 합니다."
				p_mobis.visible = False
//				cb_4.Enabled = True
			end if
			
			dw_insert.SetTransObject(SQLCA)			
			dw_autoimhist.Reset()
			
		else
			p_excel.visible = False
			p_hmc_excel.visible = False
			p_search.visible = False
			p_mobis.visible = False
		end if
				
	Case "itnbr_from"
		This.SetItem(row, 'itnbr_to', data)
//	Case "itnbr_to"
//		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
//		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
//			This.SetItem(row, 'itnbr_from', ls_value)
//	   end if
//	
	Case "saupj"
		DataWindowChild ldw_depot
		IF dw_1.GetChild( "depot", ldw_depot ) > 0 THEN
			ldw_depot.SetTransObject( SQLCA )
			ldw_depot.Retrieve(ls_value)
		END IF
	
END CHOOSE

end event

event itemerror;Return 1
end event

type pb_1 from u_pb_cal within w_sm40_0010
integer x = 622
integer y = 160
integer width = 91
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sm40_0010
integer x = 1106
integer y = 160
integer width = 91
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date2', gs_code)

end event

type rr_1 from roundrectangle within w_sm40_0010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 400
integer width = 4576
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_new from radiobutton within w_sm40_0010
integer x = 3346
integer y = 84
integer width = 210
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;wf_init()
end event

type rb_del from radiobutton within w_sm40_0010
integer x = 3346
integer y = 208
integer width = 201
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
string text = "삭제"
end type

event clicked;wf_init()
end event

type st_2 from statictext within w_sm40_0010
integer x = 46
integer y = 348
integer width = 3282
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "※ 납품서 발행(랩도스 처리) 후 물류업체 출고는 수량없이 납품서만  이동합니다."
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_sm40_0010
boolean visible = false
integer x = 3342
integer y = 336
integer width = 777
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "계획수량 0 이상만 표시"
end type

event clicked;dw_1.accepttext()

if this.checked then
	if dw_1.Object.gubun[1] = 'ET' OR dw_1.Object.gubun[1] = 'M2' then
		dw_insert.setfilter("ordqty > 0")
		dw_insert.filter()
	else
		dw_insert.setfilter("")
		dw_insert.filter()
	end if
else
	if dw_1.Object.gubun[1] = 'ET' OR dw_1.Object.gubun[1] = 'M2' then
		dw_insert.setfilter("")
		dw_insert.filter()
	else
		dw_insert.setfilter("")
		dw_insert.filter()
	end if
end if
end event

type p_sort from picture within w_sm40_0010
integer x = 4443
integer y = 168
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type cb_set0 from commandbutton within w_sm40_0010
integer x = 4096
integer y = 312
integer width = 521
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "출고수량 0 지정"
end type

event clicked;long	lrow

if messagebox('확인','조회된 자료의 출고수량을 0 으로 지정합니다.',question!,yesno!,2) = 2 then return

setpointer(hourglass!)
dw_insert.setredraw(false)
for lrow = 1 to dw_insert.rowcount()
	dw_insert.setitem(lrow, 'yebid1', 0)
next
dw_insert.setredraw(true)
end event

type rr_2 from roundrectangle within w_sm40_0010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3319
integer y = 20
integer width = 251
integer height = 316
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_3 from picturebutton within w_sm40_0010
boolean visible = false
integer x = 4078
integer y = 108
integer width = 192
integer height = 136
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "KMC Excel"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;p_excel.TriggerEvent('Clicked')
end event

type pb_4 from picturebutton within w_sm40_0010
boolean visible = false
integer x = 4274
integer y = 108
integer width = 192
integer height = 136
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "HMC Excel"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;p_hmc_excel.TriggerEvent('Clicked')
end event

type pb_5 from picturebutton within w_sm40_0010
boolean visible = false
integer x = 4471
integer y = 108
integer width = 192
integer height = 136
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "A/S Excel"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;p_mobis.TriggerEvent('Clicked')
end event

type p_hmc_excel from uo_picture within w_sm40_0010
boolean visible = false
integer x = 2866
integer y = 168
integer width = 178
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
uo_xlobject uo_xl , uo_xltemp
string ls_docname, ls_named[] ,ls_line , ls_empno
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value
Long   ll_err , ll_succeed  
String ls_file , ls_orderno, ls_seogu, ls_chul, ls_typ, ls_ckd

Long ll_seq , ll_jpno  , ll_count, ll_cha, ll_chul

If dw_1.AcceptText() <> 1 Then Return -1

If rb_del.Checked Then
	MessageBox('확인','구분이 HKMC(랩도스) 이고 등록상태일때 처리 가능합니다.')
	Return
End IF

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30, '[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

ls_saupj = Trim(dw_1.Object.saupj[1]) 

// 엘셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("HMC 일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','c:\erpman\bin\date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting/////////////////////////////////////////////////////////
	//ll_xl_row = 6 //e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon
	//ll_xl_row = 7 //e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon
	ll_xl_row = 8
	////////////////////////////////////////////////////////////////////////////////
	
	ll_jpno = 0 
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
		
		ll_r = dw_insert.InsertRow(0) 
		ll_cnt++
		ll_jpno++
		
		dw_insert.Scrolltorow(ll_r)
	
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_ymd = Trim(uo_xl.uf_gettext(ll_xl_row,1))
		//ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		//ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row,5))
		//ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row,7))
		//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
		//ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 2))		// 발행일자
		//ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 3))		// 시간
		//ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 5))      // 공장
		//ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 6))      // 품번
		/* 업로드 양식 변경 - 2013.09.30 by shingoon
		ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 9))		// 9.발행일자
		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 10))		// 10.시간
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 1))      // 1.공장
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 3))      // 3.품번		*/		
		ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 3))		// 3.발행일자
		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 4))	   // 4.시간
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 1))    // 1.공장
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 10))   // 10.품번
		//////////////////////////////////////////////////////////////////////
		
		/////////////////////////////////////////////////////////////
		/* 품번에 '-'하이픈이 없이 들어옴 - BY SHINGOON 2013.09.30 */
		/* 혹시나 사용자가 하이픈을 넣고 올릴 경우 대비.. */
		SELECT ITNBR
		  INTO :ls_itnbr
		  FROM ITEMAS
		 WHERE REPLACE(ITNBR, '-', '') = REPLACE(:ls_itnbr, '-', '') ;
 		/////////////////////////////////////////////////////////////
		
		w_mdi_frame.sle_msg.text = ls_itnbr + ' / ' + String(ll_cnt) + '행'
		
		/* 엑셀의 날짜포멧 값을 문자형으로 변경 */
		uo_xltemp.uf_setvalue( 1, 1, ls_ymd )
		
	   ls_ymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		         String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		If f_datechk(ls_ymd) < 1 Then
			MessageBox('확인','날자형식에 맞지 않습니다.')
			Rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			Return
		End If
		
		If ix = 1 Then dw_1.object.jisi_date[1] = ls_ymd
		
		////////////////////////////////////////////////////////////////
		/* 시간값은 일반 포멧으로 바뀜 - by shingoon 2013.09.30
		uo_xltemp.uf_setvalue( 1, 1, ls_btime )
		
		ls_btime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		           String(Long(uo_xltemp.uf_gettext(1,6)),'00') 
		*/
		If Len(ls_btime) < 2 Then
			ls_btime = '0' + ls_btime + '00'
		Else
			ls_btime = ls_btime + '00'
		End If
		////////////////////////////////////////////////////////////////
		
		if isnull(ls_itnbr) or trim(ls_itnbr) = '' then exit
		 
		Select rfgub, fun_get_scvcod( rfgub, :ls_itnbr ,''  ) Into :ls_factory ,:ls_cvcod 
		  From Reffpf
		 Where rfcod = '2A'
			and rfgub != '00'
			and rfgub = :ls_plant ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then
			
			dw_insert.Object.factory[ll_r]     =    "미등록 공장"
			ll_err++
			ll_xl_row ++
			Continue ;

		End IF
	   ll_c = 0 
		select count(*), itnbr
		  into :ll_c   , :ls_itnbr
		  from itemas
		 where replace(itnbr, '-', '') = replace(:ls_itnbr, '-', '') and ittyp <> '9'
		group by itnbr ;
			
		if ll_c = 0 then
			
			dw_insert.Object.itnbr[ll_r]     =    "미등록 품번"
			ll_err++
			ll_xl_row ++
			Continue ;
	
		End IF
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_orderno =  Trim(uo_xl.uf_gettext(ll_xl_row,8))
		//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
		//ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 7))		// 발주번호
		
		/* 엑셀 양식 변경 - by shingoon 2013.09.30 
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 6))		// 6.발주번호*/
		/* 정보 변경 요청 - BY SHINGOON 2017.05.25
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 23))		// 23.발주번호(P/D No.) */
		
		/* 자료 중복 문제로 다시 원복 처리 - BY SHINGOON 2017.05.26 
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 19))    // 19.발주번호(판매문서번호)  기존 p/d번호에서 판매문서번호로 변경 - 2017.05.25 */
		/* 원복 처리 - BY SHINGOON 2017.05.26 */
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 23))		// 23.발주번호(P/D No.)
		//////////////////////////////////////////////////////////////////////
		
		/* ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ */
		/* 발주번호 중복 확인 체크 변경 (총 출고수량으로 확인) - BY SHINGOON 2013.11.12
		   발주번호가 없는 경우는 기존 그대로 확인                                      */
/***********************************************************************************************************************/
//발주번호가 없는 출고자료는 중복에 체크되어 등록이 안됨.
//발주번호 없을 경우와 발주번호 있는 경우 두 가지로 나뉘어 중복확인 - by shingoon 2007.06.18
		If ls_orderno = '' or isNull(ls_orderno) Then
			ls_orderno = '.'
			Select Count(*) Into :ll_c
			  From SM04_DAILY_ITEM_SALE
			 Where saupj = :ls_saupj
				and yymmdd = :ls_ymd
				and btime = :ls_btime
				and factory = :ls_factory
				and itnbr = :ls_itnbr
				and orderno = :ls_orderno ;
			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue ;
			End If
		Else
			Long  ll_oseq
			ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
//			//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
//			SELECT COUNT('X') INTO :ll_c
//			  FROM SM04_DAILY_ITEM_SALE
//			 WHERE ORDERNO = :ls_orderno
//			   AND OSEQ    = :ll_oseq
//			   AND ITNBR   = :ls_itnbr
//			   AND FACTORY = :ls_factory ;
//			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
//			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
//			End If
			/* 기아공장일 경우 PDNO가 아닌 SALEDOT로 발주번호 확인 - BY SHINGOON 2013.11.27 */
			SELECT RFNA3, RFCOMMENT INTO :ls_typ, :ls_ckd FROM REFFPF WHERE RFCOD = '2A' AND RFGUB = :ls_factory ;
			If ls_ckd = 'CKD' Then
				If ls_typ = 'K' Then
					/* 중복확인 - 발주번호, 발주순번의 총 출고량으로 확인 */
					SELECT MAX(NVL(A.PLAN_DQTY, 0)) - MAX(NVL(B.YEBID1, 0))
					  INTO :ll_cha
					  FROM VAN_CKDD2 A,  /* 발주량 */
							 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
								  FROM SM04_DAILY_ITEM_SALE
								 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
								GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
					 WHERE A.PLANT   = :ls_factory
						AND A.SALEDOT = :ls_orderno
						AND A.MITNBR  = :ls_itnbr
						AND A.MITNBR  = B.ITNBR(+)
						AND A.SALEDOT = B.ORDERNO(+)
					GROUP BY A.MITNBR, A.SALEDOT;
				Else
					/* 중복확인 - 발주번호, 발주순번의 총 출고량으로 확인 */
					SELECT MAX(NVL(A.PLAN_DQTY, 0)) - MAX(NVL(B.YEBID1, 0))
					  INTO :ll_cha
					  FROM VAN_CKDD2 A,  /* 발주량 */
							 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
								  FROM SM04_DAILY_ITEM_SALE
								 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
								GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
					 WHERE A.PLANT   = :ls_factory
						AND A.PDNO    = :ls_orderno
						AND A.MITNBR  = :ls_itnbr
						AND A.MITNBR  = B.ITNBR(+)
						AND A.PDNO    = B.ORDERNO(+)
					GROUP BY A.MITNBR, A.PDNO;
				End If
			Else
				SELECT MAX(NVL(A.ORDER_QTY, 0)) - MAX(NVL(B.YEBID1, 0))
				  INTO :ll_cha
				  FROM VAN_HKCD68 A,
						 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
							  FROM SM04_DAILY_ITEM_SALE
							 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
							GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
				 WHERE A.FACTORY = :ls_factory
					AND A.MITNBR  = :ls_itnbr
					AND A.ORDERNO = :ls_orderno
					AND A.MITNBR  = B.ITNBR(+)
					AND A.ORDERNO = B.ORDERNO(+)
				GROUP BY A.MITNBR, A.ORDERNO ;
			End If
			If ll_cha < 1 Then // 잔량 < 1 이면 추가 출고 제외(출고가 완료된 경우)
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue
			End If
			
			If ll_cha < ll_chul Then // 잔량 < 출고요청수량 이면 출고 제외(분할출고 처리 중 잔량을 초과할 경우)
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue
			End If
		End If
/***********************************************************************************************************************/
		/* ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ */		
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//도착일자, 도착시간은 e-Rapdos로 변경되면서 정보 삭제됨.
		/*********************************************************************
		ls_arrymd = Trim(uo_xl.uf_gettext(ll_xl_row,12))
		ls_arrtime = Trim(uo_xl.uf_gettext(ll_xl_row,13))
		
		ls_arrymd = f_replace(ls_arrymd , '-','') 
		ls_arrtime = f_replace(ls_arrtime , ':','') 
		
		uo_xltemp.uf_setvalue( 1, 1, ls_arrymd )
		
	   ls_arrymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		            String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					   String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		uo_xltemp.uf_setvalue( 1, 1, ls_arrtime )
		
		ls_arrtime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		             String(Long(uo_xltemp.uf_gettext(1,6)),'00') 
		**********************************************************************/
						 
		If ll_jpno = 1 or ll_jpno > 998 Then
			/*송장번호 채번*/
			ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
			IF ll_seq <= 0 THEN
				f_message_chk(51,'')
				ROLLBACK;
				Return -1
			END IF
			Commit;
			ll_jpno = 1
		end if
		
		String ls_na5
		  SELECT RFNA5
		    INTO :ls_na5
			 FROM REFFPF
			WHERE RFCOD = 'AD'
			  AND RFGUB = :ls_saupj ;
		If Trim(ls_na5) = '' OR IsNull(ls_na5) Then ls_na5 = 'P655'
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////////////////////////////
		//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
		dw_insert.Object.iojpno[ll_r]      = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_insert.Object.saupj[ll_r]       = ls_saupj
		dw_insert.Object.yymmdd[ll_r]      = ls_ymd		//9.발행일자
		dw_insert.Object.btime[ll_r]	     = ls_btime			//10.시간
		
//		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,3))
//		dw_insert.Object.custcd[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,4))
//		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		// 차량
		/* 엑셀 양식 변경 - by shingoon 2013.09.30
		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 11))		// 11.차량번호 */
		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 7))		// 7.차량번호
		
		dw_insert.Object.custcd[ll_r]      = ls_na5 //e-Rapdos변경 후 해당정보 삭제 됨.	
		
		dw_insert.Object.factory[ll_r]     = ls_factory    			// 1.공장  
		
//		dw_insert.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,6))    
//		dw_insert.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 하치장
		dw_insert.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 2))		// 2. 하치장

		dw_insert.Object.itnbr[ll_r]       = ls_itnbr					//10.품번
		dw_insert.Object.orderno[ll_r]     = ls_orderno			//23.발주번호
		//해당정보는 변동 없음.		
		//dw_insert.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))		// 발주 SEQ
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* 엑셀 양식 변경 - by shingoon 2013.09.30		
		dw_insert.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))		// 5. 발주 SEQ
		dw_insert.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 10))))   	// 발주수량
		//dw_insert.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 	// 납품수량
		dw_insert.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8)))) 	// 8.납품수량
		dw_insert.Object.nabpum_no[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		// 4. 납품서번호
		dw_insert.Object.yebis6[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 12.인쇄여부
		dw_insert.Object.yebis3[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 13))		// 13.출하전송
		dw_insert.Object.yebis5[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 14))		// 14.납입일자 */		
		dw_insert.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 9))))		// 9. 발주 SEQ
		dw_insert.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 14))))   	// 14.발주수량
		dw_insert.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 15)))) 	// 15.납품수량
		dw_insert.Object.nabpum_no[ll_r]   = Trim(uo_xl.uf_gettext(ll_xl_row, 8))						// 8. 납품서번호
		dw_insert.Object.yebis6[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 27))						// 27.인쇄여부
		dw_insert.Object.yebis3[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 28))						// 28.출하전송
		dw_insert.Object.yebis5[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 17))						// 17.납기일자
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		if ls_factory = 'HK11' OR ls_factory = 'HK21' then		// 현대 CKD 인 경우는 수량 0으로 초기화
			dw_insert.Object.yebid1[ll_r]   = 0
		else
			
			//dw_insert.Object.yebid1[ll_r]   = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			/* 엑셀 양식 변경 - by shingoon 2013.09.30
			dw_insert.Object.yebid1[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))  	// 8.납품수량 */
			dw_insert.Object.yebid1[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,15))))  	// 15.납품수량
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
		end if
		
		dw_insert.Object.arrymd[ll_r]      = ls_arrymd
		dw_insert.Object.arrtime[ll_r]     = ls_arrtime 
		//dw_insert.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,14)) 
		
//		dw_insert.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row,15))
//		dw_insert.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row, 13))
		
		dw_insert.Object.cvcod[ll_r]       = ls_cvcod  
		///////////////////////////////////////////////////////////////////////////////////////////////

/* HMC EXCEL UPLOAD 처리 시 서열 ITEM이 없음 (한텍-박소연씨 통화 확인) - BY SHINGOON 2013.10.17
   서열구분값에 무조건 'N' 처리 
	
		/* 서열기준은 발주번호가 있을 경우는 참조코드를 따르고 없을 경우는 품목정보 수정 따름 - 2007.01.23 - 송병호 */
		if ls_orderno > '.' then
			ll_count = 0 
			Select count(*) Into :ll_count
			  From reffpf 
			 Where rfcod = '2U'
				and rfgub = substr(:ls_orderno , -1 , 1 )
				and rfna3 = 'Y' ;
			If ll_count = 0 Then
				dw_insert.Object.seogu[ll_r] = 'Y' 
			else
				dw_insert.Object.seogu[ll_r] = 'N'
			end If
		else
			Select Nvl(seogu,'N') Into :ls_seogu From vndmrp_new
			 Where factory = :ls_factory And itnbr = :ls_itnbr ;

//			Select Nvl(seogu,'N') Into :ls_seogu From vndmrp
//			 Where cvcod = :ls_cvcod And itnbr = :ls_itnbr ;
			dw_insert.Object.seogu[ll_r] = ls_seogu
		end if
*/
		// dw_insert.Object.seogu[ll_r] = 'N' // HMC Excel 처리 시 서열 품목이 없음 - 2013.10.17 by shingoon
		// 서열품 등록하는 경우가 추가 발생하였기에 공장, 품목별로 조회하여 추가하는 로직으로 변경 '20.05.25 BY BHKIM
		SELECT NVL(SEOGU, 'N')
		  INTO :ls_seogu
		  FROM VNDMRP_NEW
		 WHERE FACTORY = :ls_factory
		   AND ITNBR = :ls_itnbr;
			
		dw_insert.Object.seogu[ll_r] = ls_seogu
		
		dw_insert.Object.yebis2[ll_r]      = 'HK'	 
		
		ll_xl_row ++
		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text =ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()


// 출고일자 기록
//dw_1.Object.io_date[1] = ls_ymd


dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return -1
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End if

MessageBox('Import 성공', '"저장"버튼을 눌러 최종 출고처리 하시기 바랍니다.~r~n저장 하지 않으면 출고에 나타나지 않습니다.')

w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하였습니다.'

Return ll_cnt
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\excel_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\excel_up.gif"
end event

type p_mobis from uo_picture within w_sm40_0010
boolean visible = false
integer x = 2555
integer y = 116
integer width = 178
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
uo_xlobject uo_xl, uo_xltemp
string ls_docname, ls_named, ls_line, ls_empno
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value
Long   ll_err , ll_succeed  
String ls_file , ls_orderno, ls_seogu, ls_chul

Long ll_seq , ll_jpno  , ll_count

If dw_1.AcceptText() <> 1 Then Return -1

If dw_insert.RowCount() < 1 Then
	MessageBox('확인', '자료 조회 후 Upload를 진행 하십시오.')
	Return
End If

If rb_del.Checked Then
	MessageBox('확인','등록 상태일 때 처리 가능합니다.')
	Return
End IF

String ls_gubun
ls_gubun = Trim(dw_1.Object.gubun[1])
if ls_gubun <> 'M1' then
	MessageBox('확인','구분이 MOBIS A/S 일때 처리 가능합니다.')
	Return
End IF

If dw_1.RowCount() < 1 Then
	MessageBox('확인', '자료 조회 또는 생성처리 후 진행 하십시오.')
	Return
End If

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30, '[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

ls_saupj = Trim(dw_1.Object.saupj[1]) 

// 엘셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("MOBIS A/S 납품실적 가져오기", ls_docname, ls_named, & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

//dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists(ls_docname) = False Then
	MessageBox('확인',ls_docname+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xl = create uo_xlobject
uo_xl.uf_excel_connect(ls_docname, false , 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1,1, '@' + space(30))

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','c:\erpman\bin\date_conv.xls'+' 파일이 존재하지 않습니다.')
	uo_xl.uf_excel_Disconnect()
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

//Data 시작 Row Setting
ll_xl_row = 5
ll_jpno = 0 

/* To Excel 기능을 SM04_DAILY_ITEM_SALE에 직접넣는 방식이 아닌 자료조회 후 발주번호로 자료찾고 검수수량을 기입하는 형태로 처리 - BY SHINGOON 2013.07.09 */
/* 처리방식 - 1. A/S모드 에서 "생성"버튼으로 VAN자료를 SM04_DAILY_ITEM_SALE에 생성 **********************************************************************/
/*            2. 생성된 자료를 조회한 후 "To Excel"버튼을 눌러 발주번호로 검수수량을 자동 입력 **********************************************************/
Integer li_find
Long    ll_yebid1
Do While(True)
	
	//Data가 없을경우엔 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,3)) or trim(uo_xl.uf_gettext(ll_xl_row,3)) = '' then exit
	
	ll_cnt++
	
	dw_insert.Scrolltorow(ll_r)

	For i =1 To 15
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
	Next
	
	ls_plant   = 'MAS'      // 1.공장-정보없음.
	ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 3))		                       // 3.발주번호
	ls_itnbr   = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 6)), ' ', '-')      // 6.품번
	
	w_mdi_frame.sle_msg.text = ls_itnbr + ' / ' + String(ll_cnt) + '행'
	
	if isnull(ls_itnbr) or trim(ls_itnbr) = '' then exit
/***********************************************************************************************************************/
	li_find = dw_insert.Find("factory = '" + ls_plant + "' and orderno = '" + ls_orderno + "' and itnbr = '" + ls_itnbr + "'", 1, dw_insert.RowCount())
	If li_find < 1 Then
		MessageBox('자료 확인', '[' + ls_orderno + ']의 [' + ls_itnbr + ']은 대상 LIST에 없거나 이미 출고 된 항목 입니다.~r~n계속 진행 합니다.')
		ll_xl_row ++
		ll_succeed++
		ll_err++
		w_mdi_frame.sle_msg.text =ls_named + ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		Continue
	Else
		// 같은 날 같은 발주번호가 있을 경우 수량 합산 - by shingoon 2013.10.18
		ll_yebid1 = 0
		ll_yebid1 = dw_insert.Object.yebid1[li_find] //기 등록된 수량
		If IsNull(ll_yebid1) Then ll_yebid1 = 0
		ll_yebid1 = ll_yebid1 + Long(Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 9))))
		
		//dw_insert.Object.yebid1[li_find] = Long(Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 9)))) // 발주수량
		dw_insert.Object.yebid1[li_find] = ll_yebid1 // 발주수량
	End If
/***********************************************************************************************************************/
	ll_xl_row ++
	
	ll_succeed++
	
	w_mdi_frame.sle_msg.text =ls_named + ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
	
Loop

uo_xl.uf_excel_Disconnect()
// 엑셀 IMPORT  END ***************************************************************

dw_insert.AcceptText()

//If dw_insert.Update() < 1 Then
//	Rollback;
//	MessageBox('확인','저장실패')
//	Return -1
//Else
//	Commit;
//	p_inq.TriggerEvent(Clicked!)
//End if
MessageBox('Import 성공', '"저장"버튼을 눌러 최종 출고처리 하시기 바랍니다.~r~n저장 하지 않고 다른 작업을 하시게 되면 자료를 잃게 됩니다.')
w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하였습니다.~r~n저장 버튼을 눌러 최종 처리 하시기 바랍니다.'

Return ll_cnt
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\excel_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\excel_up.gif"
end event

type st_3 from statictext within w_sm40_0010
boolean visible = false
integer x = 3104
integer y = 88
integer width = 142
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 134217750
string text = "KMC"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sm40_0010
boolean visible = false
integer x = 2885
integer y = 100
integer width = 142
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 134217750
string text = "HMC"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sm40_0010
boolean visible = false
integer x = 2830
integer y = 236
integer width = 448
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "발주취소처리"
end type

event clicked;String ls_gubun
ls_gubun = Trim(dw_1.Object.gubun[1])
if ls_gubun <> 'M1' then
	MessageBox('확인','구분이 MOBIS A/S 일때 처리 가능합니다.')
	Return
End IF

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

Integer li_find
li_find = dw_insert.Find("yebid3 = 1", 1, li_cnt)
If li_find < 1 Then Return

li_find = 0

Integer i
Integer ll_err
String  ls_err
String  ls_jpno
For i = 1 To li_cnt
	li_find = dw_insert.Find("yebid3 = 1", i, li_cnt)
	If li_find < 1 Then Exit
	
	ls_jpno = dw_insert.GetItemString(li_find, 'iojpno')
	
	UPDATE SM04_DAILY_ITEM_SALE
	   SET YEBID3 = 1
	 WHERE IOJPNO = :ls_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox(String(ll_err), ls_err)
		Return
	End If
Next

COMMIT USING SQLCA;
MessageBox('확인', '저장 되었습니다.')

p_inq.TriggerEvent(Clicked!)
end event

type dw_2 from datawindow within w_sm40_0010
boolean visible = false
integer x = 155
integer y = 496
integer width = 4146
integer height = 1744
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "D1 일 검수 목록"
string dataobject = "d_sm40_0010_a_d1"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
string icon = "Information!"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;This.SetTransObject(SQLCA)
end event

event buttonclicked;Choose Case dwo.name
	Case 'b_1' //선택
		Integer li_cnt
		li_cnt = This.RowCount()
		If li_cnt < 1 Then Return
		
		Integer li_find
		li_find = This.Find("f_chk = 'Y'", 1, li_cnt)
		If li_find < 1 Then
			MessageBox('선택 확인', '선택 된 행이 없습니다.')
			Return
		End If
		
		li_find = 0
		
		String  ls_saupj
		ls_saupj = dw_1.GetItemString(1, 'saupj')

		Long    ll_qty
		Integer i
		Integer li_ins
		String  ls_fac
		String  ls_itn
		String  ls_ord
		String  ls_vnd
		String  ls_seo
		String  ls_chk
		For i = 1 To li_cnt
			li_find = This.Find("f_chk = 'Y'", i, li_cnt)
			If li_find < 1 Then Exit
			
			ls_fac = This.GetItemString(li_find, 'factory')
			ls_itn = This.GetItemString(li_find, 'mitnbr' )
			ls_ord = This.GetItemString(li_find, 'orderno')
			ls_vnd = This.GetItemString(li_find, 'mcvcod' )
			ll_qty = This.GetItemNumber(li_find, 'ipqty'  )
			
			/* 서열기준은 발주번호가 있을 경우는 참조코드를 따르고 없을 경우는 품목정보 수정 따름 */
			If Trim(ls_ord) = '' OR IsNull(ls_ord) Then ls_ord = '.'
			
			If ls_ord > '.' Then
				SetNull(ls_chk)
				SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
				  INTO :ls_chk
				  FROM REFFPF
				 WHERE RFCOD = '2U' AND RFGUB = SUBSTR(:ls_ord, -1, 1) AND RFNA3 = 'Y' ;
				If ls_chk = 'N' Then
					ls_seo = 'Y'
				Else
					ls_seo = 'N'
				End If
			Else
				SELECT NVL(SEOGU, 'N')
				  INTO :ls_seo
				  FROM VNDMRP_NEW
				 WHERE FACTORY = :ls_fac AND ITNBR = :ls_itn ;
			End If
			
			li_ins = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(li_ins, 'saupj'  , ls_saupj)
			dw_insert.SetItem(li_ins, 'custcd' , 'P655'  )
			dw_insert.SetItem(li_ins, 'factory', ls_fac  )
			dw_insert.SetItem(li_ins, 'itnbr'  , ls_itn  )
			dw_insert.SetItem(li_ins, 'orderno', ls_ord  )
			dw_insert.SetItem(li_ins, 'oseq'   , 0       )
			dw_insert.SetItem(li_ins, 'ordqty' , ll_qty  )
			dw_insert.SetItem(li_ins, 'napqty' , ll_qty  )
			dw_insert.SetItem(li_ins, 'seogu'  , ls_seo  )
			dw_insert.SetItem(li_ins, 'cvcod'  , ls_vnd  )
			dw_insert.SetItem(li_ins, 'yebis2' , 'HK'    )
			dw_insert.SetItem(li_ins, 'yebid1' , ll_qty  )
			
			i = li_find
		Next
		
		This.Visible = False
	Case 'b_2' //닫기
		This.Visible = False
End Choose
end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type dw_print from datawindow within w_sm40_0010
boolean visible = false
integer x = 2770
integer y = 1168
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_chul_p_new"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_imhist from datawindow within w_sm40_0010
boolean visible = false
integer x = 3465
integer y = 1112
integer width = 782
integer height = 504
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "none"
string dataobject = "d_sm40_0010_imhist"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_sm40_0010
boolean visible = false
integer x = 3177
integer y = 404
integer width = 741
integer height = 604
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "조건 선택"
string dataobject = "d_sm40_0010_1_upload"
boolean controlmenu = true
string icon = "Information!"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;This.Visible = False

Choose Case data
	Case '1' //HMC
		pb_4.PostEvent(Clicked!)
	Case '2' //KMC
		pb_3.PostEvent(Clicked!)
	Case '3' //A/S
		pb_5.PostEvent(Clicked!)
	Case '4' //WIA
		pb_6.PostEvent(Clicked!)
End Choose
end event

type pb_6 from picturebutton within w_sm40_0010
boolean visible = false
integer x = 3881
integer y = 108
integer width = 192
integer height = 136
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "WIA Excel"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;/**************************************************************************************************************
위아CKD 일일 실적으로 출고자료 생성
위아 물류처 출고는 기존 방식대로 처리
BY SHINGOON 2013.11.08
**************************************************************************************************************/
String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
uo_xlobject uo_xl , uo_xltemp
string ls_docname, ls_named[] ,ls_line , ls_empno
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value
Long   ll_err , ll_succeed, ll_cha
String ls_file , ls_orderno, ls_seogu, ls_chul, ls_nap, ls_date

Long ll_seq , ll_jpno  , ll_count

If dw_1.AcceptText() <> 1 Then Return -1

If rb_del.Checked Then
	MessageBox('확인','구분이 HKMC(랩도스/WIA CKD) 이고 등록 상태일 때 처리 가능합니다.')
	Return
End IF

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30, '[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

ls_saupj = Trim(dw_1.Object.saupj[1]) 

// 엑셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("WIA CKD 일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','c:\erpman\bin\date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, false , 3)
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting/////////////////////////////////////////////////////////
	ll_xl_row = 2
	////////////////////////////////////////////////////////////////////////////////
	
	ll_jpno = 0 
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit
		
		ll_r = dw_insert.InsertRow(0) 
		ll_cnt++
		ll_jpno++
		
		dw_insert.Scrolltorow(ll_r)
	
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		String  ls_balno
		String  ls_balseq
		Long    ll_chul
		ls_balno = Trim(uo_xl.uf_gettext(ll_xl_row, 5))  //발주번호가 4502819962 00160(발주번호 + 발주순번) 형태로 입력 됨
		//발주번호 분리 - 중간에 공백을 기준으로 자료 분리
		SELECT TRIM(SUBSTR(:ls_balno, 1, INSTR(:ls_balno, ' ', 1, 1))),
      		 TRIM(SUBSTR(:ls_balno, INSTR(:ls_balno, ' ', 1, 1), LENGTH(:ls_balno)))
		  INTO :ls_balno, :ls_balseq
		  FROM DUAL ;
		
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 6))  //품번
		//품번에 알파벳이 첫자리에 나타나고 하이픈('-')이 없이 들어옴 : C289612E200
		//첫자리 C는 있는것과 없는것 2가지 형태로 발생
		SELECT ITNBR
		  INTO :ls_itnbr
		  FROM ITEMAS
		 WHERE :ls_itnbr LIKE '%'||NVL(REPLACE(ITNBR, '-', ''), '.')||'%'
		 AND ITNBR <> 'E';
		 //WHERE REPLACE(ITNBR, '-', '') = DECODE(SUBSTR(:ls_itnbr, 1, 1), 'C', SUBSTR(:ls_itnbr, 2, LENGTH(:ls_itnbr)), :ls_itnbr) ; 다른 구분자도 확인하기 위해 구문 변경 '20.05.29 BY BHKIM
		 /*WHERE REPLACE(ITNBR, '-', '') = SUBSTR(:ls_itnbr, 2, LENGTH(:ls_itnbr)) ;*/
		
		ll_chul = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 11)))  //출하수량
		
		ls_ymd   = String(TODAY(), 'yyyymmdd')  //발행일 정보 없음
		ls_btime = String(TODAY(), 'hhmm')      //발행일시 정보 없음
		ls_plant = 'WP'
		
		w_mdi_frame.sle_msg.text = ls_itnbr + ' / ' + String(ll_cnt) + '행'
		
		ls_arrymd = Trim(uo_xl.uf_gettext(ll_xl_row, 15)) //도착일자
		/* 날짜포멧을 문자열로 변경 */
		uo_xltemp.uf_setvalue( 1, 1, ls_arrymd )
	   ls_arrymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		            String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					   String(Long(uo_xltemp.uf_gettext(1,4)),'00')					
		If f_datechk(ls_arrymd) < 1 Then
			MessageBox('확인','날자형식에 맞지 않습니다.')
			Rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			Return
		End If
		
		If ix = 1 Then dw_1.object.jisi_date[1] = ls_ymd
		
		ls_arrtime = Trim(uo_xl.uf_gettext(ll_xl_row, 15)) //도착시간
		/* 시간포멧을 문자열로 변경 */
		uo_xltemp.uf_setvalue( 1, 1, ls_arrtime )
		ls_arrtime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		             String(Long(uo_xltemp.uf_gettext(1,6)),'00') 

		if isnull(ls_itnbr) or trim(ls_itnbr) = '' then exit
		 
		Select rfgub, fun_get_scvcod( rfgub, :ls_itnbr ,''  ) Into :ls_factory ,:ls_cvcod 
		  From Reffpf
		 Where rfcod = '2A'
			and rfgub != '00'
			and rfgub = :ls_plant ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then
			
			dw_insert.Object.factory[ll_r]     =    "미등록 공장"
			ll_err++
			ll_xl_row ++
			Continue ;

		End IF
	   ll_c = 0 
		select count(*) 
		  into :ll_c
		  from itemas
		 where itnbr = :ls_itnbr and ittyp <> '9' ;
			
		if ll_c = 0 then
			
			dw_insert.Object.itnbr[ll_r]     =    "미등록 품번"
			ll_err++
			ll_xl_row ++
			Continue ;
	
		End IF
		
		/* 중복확인 - 발주번호, 발주순번의 총 출고량으로 확인 */
		SELECT A.BALQTY - NVL(B.YEBID1, 0)
		  INTO :ll_cha
		  FROM VAN_MOBIS_CKD_B A,  /* 발주량 */
				 ( SELECT ORDERNO, OSEQ, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
					  FROM SM04_DAILY_ITEM_SALE
					 WHERE FACTORY = 'WP' AND ORDERNO IS NOT NULL AND YEBIS2 = 'HK'
					GROUP BY ORDERNO, OSEQ, ITNBR ) B /* 출고량 */
		 WHERE A.FACTORY = 'WP'
		   AND A.BALNO   = :ls_balno
			AND A.BALSEQ  = :ls_balseq
			AND A.ITNBR   = :ls_itnbr
			AND A.BALNO   = B.ORDERNO(+)
			AND A.BALSEQ  = B.OSEQ(+) ;
		If ll_cha < 1 Then // 잔량 < 1 이면 추가 출고 제외
			dw_insert.DeleteRow(ll_r)
			ll_xl_row ++
			ll_succeed++
			If ll_jpno = 1 Then ll_jpno = 0
			Continue
		End If
		
		If ll_cha < ll_chul Then // 잔량 < 출고요청수량 이면 출고 제외
			dw_insert.DeleteRow(ll_r)
			ll_xl_row ++
			ll_succeed++
			If ll_jpno = 1 Then ll_jpno = 0
			Continue
		End If
						 
		If ll_jpno = 1 or ll_jpno > 998 Then
			/*송장번호 채번*/
			ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
			IF ll_seq <= 0 THEN
				f_message_chk(51,'')
				ROLLBACK;
				Return -1
			END IF
			Commit;
			ll_jpno = 1
		end if
		
		String ls_na5
		  SELECT RFNA5
		    INTO :ls_na5
			 FROM REFFPF
			WHERE RFCOD = 'AD'
			  AND RFGUB = :ls_saupj ;
		If Trim(ls_na5) = '' OR IsNull(ls_na5) Then ls_na5 = 'P655'
		
		ls_nap = Trim(uo_xl.uf_gettext(ll_xl_row, 3))  //출하문서번호[Item]
		//출하문서번호[Item] 공백제거
		SELECT REPLACE(:ls_nap, ' ', '-') INTO :ls_nap
		  FROM DUAL ;
		
		dw_insert.Object.iojpno[ll_r]      = ls_ymd + String(ll_seq, '0000') + String(ll_jpno, '000')
		dw_insert.Object.saupj[ll_r]       = ls_saupj
		dw_insert.Object.yymmdd[ll_r]      = ls_ymd
		dw_insert.Object.btime[ll_r]	     = ls_btime
		dw_insert.Object.factory[ll_r]     = ls_factory
		dw_insert.Object.custcd[ll_r]      = ls_na5
		dw_insert.Object.itnbr[ll_r]       = ls_itnbr
		dw_insert.Object.orderno[ll_r]     = ls_balno
		dw_insert.Object.oseq[ll_r]        = Long(Dec(Trim(ls_balseq)))
		dw_insert.Object.ordqty[ll_r]      = Long(Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 11))))
		dw_insert.Object.napqty[ll_r]      = Long(Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 11))))	
		dw_insert.Object.nabpum_no[ll_r]   = Trim(uo_xl.uf_gettext(ll_xl_row, 3))  //출하문서번호
		dw_insert.Object.newits[ll_r]      = LEFT(Trim(uo_xl.uf_gettext(ll_xl_row, 18)), 3)  //하치장
		dw_insert.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row, 14))
		
		dw_insert.Object.yebid1[ll_r]      = Long(Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 11)))) // 15.납품수량
		
//		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))  //차량번호
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		dw_insert.Object.arrymd[ll_r]      = ls_arrymd   //도착일자
		dw_insert.Object.arrtime[ll_r]     = ls_arrtime  //도착시간
		dw_insert.Object.cvcod[ll_r]       = ls_cvcod    //거래처
		///////////////////////////////////////////////////////////////////////////////////////////////

		dw_insert.Object.seogu[ll_r]  = 'N'	
		
		dw_insert.Object.yebis2[ll_r] = 'HK'	 
		
		ll_xl_row ++
		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text =ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엑셀 IMPORT  END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

// 출고일자 기록
//dw_1.Object.io_date[1] = ls_ymd

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return -1
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End if

w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하였습니다.'

Return ll_cnt
end event

type p_excel from uo_picture within w_sm40_0010
boolean visible = false
integer x = 3086
integer y = 156
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
uo_xlobject uo_xl , uo_xltemp
string ls_docname, ls_named[] ,ls_line , ls_empno
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value
Long   ll_err , ll_succeed  
String ls_file , ls_orderno, ls_seogu, ls_chul, ls_typ, ls_ckd

Long ll_seq , ll_jpno  , ll_count, ll_cha, ll_chul

If dw_1.AcceptText() <> 1 Then Return -1

If rb_del.Checked Then
	MessageBox('확인','구분이 HKMC(랩도스) 이고 등록상태일때 처리 가능합니다.')
	Return
End IF

ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' or isNull(ls_empno) then 
	f_message_chk(30,'[담당자]')
	dw_1.setcolumn("empno")
	dw_1.SetFocus()
	return 
end if

ls_chul = Trim(dw_1.Object.depot[1])
If ls_chul = '' or isNull(ls_chul) then
	f_message_chk(30, '[기준창고]')
	dw_1.setcolumn('depot')
	dw_1.setfocus()
	return
end if

ls_saupj = Trim(dw_1.Object.saupj[1]) 

// 엘셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("KMC 일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','c:\erpman\bin\date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting/////////////////////////////////////////////////////////
	//ll_xl_row = 6 //e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon
	ll_xl_row = 7
	////////////////////////////////////////////////////////////////////////////////
	
	ll_jpno = 0 
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,5)) or trim(uo_xl.uf_gettext(ll_xl_row,5)) = '' then exit
		
		ll_r = dw_insert.InsertRow(0) 
		ll_cnt++
		ll_jpno++
		
		dw_insert.Scrolltorow(ll_r)
	
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_ymd = Trim(uo_xl.uf_gettext(ll_xl_row,1))
		//ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		//ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row,5))
		//ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row,7))
		ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 2))
		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 3))
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 5))
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 6))
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_itnbr + ' / ' + String(ll_cnt) + '행'
		
		uo_xltemp.uf_setvalue( 1, 1, ls_ymd )
		
	   ls_ymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		         String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		If f_datechk(ls_ymd) < 1 Then
			MessageBox('확인','날자형식에 맞지 않습니다.')
			Rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			Return
		End If
		
		If ix = 1 Then dw_1.object.jisi_date[1] = ls_ymd
	
		
		uo_xltemp.uf_setvalue( 1, 1, ls_btime )
		
		ls_btime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		           String(Long(uo_xltemp.uf_gettext(1,6)),'00') 
	
		
		if isnull(ls_itnbr) or trim(ls_itnbr) = '' then exit
		 
		Select rfgub, fun_get_scvcod( rfgub, :ls_itnbr ,''  ) Into :ls_factory ,:ls_cvcod 
		  From Reffpf
		 Where rfcod = '2A'
			and rfgub != '00'
			and rfgub = :ls_plant ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then
			
			dw_insert.Object.factory[ll_r]     =    "미등록 공장"
			ll_err++
			ll_xl_row ++
			Continue ;

		End IF
	   ll_c = 0 
		select count(*) 
		  into :ll_c
		  from itemas
		 where replace(itnbr, '-', '') = replace(:ls_itnbr, '-', '') and ittyp <> '9' ;
			
		if ll_c = 0 then
			
			dw_insert.Object.itnbr[ll_r]     =    "미등록 품번"
			ll_err++
			ll_xl_row ++
			Continue ;
	
		End IF
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_orderno =  Trim(uo_xl.uf_gettext(ll_xl_row,8))
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 7))
		//////////////////////////////////////////////////////////////////////
		
		/* ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ */
		/* 발주번호 중복 확인 체크 변경 (총 출고수량으로 확인) - BY SHINGOON 2013.11.12
		   발주번호가 없는 경우는 기존 그대로 확인                                      */
/***********************************************************************************************************************/
//발주번호가 없는 출고자료는 중복에 체크되어 등록이 안됨.
//발주번호 없을 경우와 발주번호 있는 경우 두 가지로 나뉘어 중복확인 - by shingoon 2007.06.18
		If ls_orderno = '' or isNull(ls_orderno) Then
			ls_orderno = '.'
			Select Count(*) Into :ll_c
			  From SM04_DAILY_ITEM_SALE
			 Where saupj = :ls_saupj
				and yymmdd = :ls_ymd
				and btime = :ls_btime
				and factory = :ls_factory
				and itnbr = :ls_itnbr
				and orderno = :ls_orderno ;
			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue ;
			End If
		Else
			Long  ll_oseq
			ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
			If IsNull(ll_oseq) Then ll_oseq = 0
//			//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
//			SELECT COUNT('X') INTO :ll_c
//			  FROM SM04_DAILY_ITEM_SALE
//			 WHERE ORDERNO = :ls_orderno
//			   AND OSEQ    = :ll_oseq
//			   AND ITNBR   = :ls_itnbr
//			   AND FACTORY = :ls_factory ;
//			//2007.01.09 by shingoon - 이미 등록된 자료일 경우 Pass, 미등록 자료만 추가 등록 가능토록 수정
//			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
//			End If
			
			/* 공장이 CKD인지 확인 */
			SELECT RFNA3, RFCOMMENT INTO :ls_typ, :ls_ckd FROM REFFPF WHERE RFCOD = '2A' AND RFGUB = :ls_factory ;
			
			/* 글로비스 공장(L2, L3)일 경우 VAN_HKCD68에서 총량 확인 - BY SHINGOON 2013.11.28 */
			If ls_factory = 'L2' OR ls_factory = 'L3' Then
				SELECT MAX(NVL(A.ORDER_QTY, 0)) - MAX(NVL(B.YEBID1, 0))
				  INTO :ll_cha
				  FROM VAN_HKCD68 A,
						 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
							  FROM SM04_DAILY_ITEM_SALE
							 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
							GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
				 WHERE A.FACTORY = :ls_factory
					AND A.MITNBR  = :ls_itnbr
					AND A.ORDERNO = :ls_orderno
					AND A.MITNBR  = B.ITNBR(+)
					AND A.ORDERNO = B.ORDERNO(+)
				GROUP BY A.MITNBR, A.ORDERNO ;
			Else
				/* 기아CKD공장일 경우 PDNO가 아닌 SALEDOT로 발주번호 확인 - BY SHINGOON 2013.11.27 */
				If ls_ckd = 'CKD' Then
					If ls_typ = 'K' Then
						/* 중복확인 - 발주번호, 발주순번의 총 출고량으로 확인 */
						SELECT MAX(NVL(A.PLAN_DQTY, 0)) - MAX(NVL(B.YEBID1, 0))
						  INTO :ll_cha
						  FROM VAN_CKDD2 A,  /* 발주량 */
								 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
									  FROM SM04_DAILY_ITEM_SALE
									 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
									GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
						 WHERE A.PLANT   = :ls_factory
							AND A.SALEDOT = :ls_orderno
							AND A.MITNBR  = :ls_itnbr
							AND A.MITNBR  = B.ITNBR(+)
							AND A.SALEDOT = B.ORDERNO(+)
						GROUP BY A.MITNBR, A.SALEDOT ;
					Else
						/* 중복확인 - 발주번호, 발주순번의 총 출고량으로 확인 */
						SELECT MAX(NVL(A.PLAN_DQTY, 0)) - MAX(NVL(B.YEBID1, 0))
						  INTO :ll_cha
						  FROM VAN_CKDD2 A,  /* 발주량 */
								 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
									  FROM SM04_DAILY_ITEM_SALE
									 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
									GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
						 WHERE A.PLANT   = :ls_factory
							AND A.PDNO    = :ls_orderno
							AND A.MITNBR  = :ls_itnbr
							AND A.MITNBR  = B.ITNBR(+)
							AND A.PDNO    = B.ORDERNO(+)
						GROUP BY A.MITNBR, A.PDNO ;
					End If
				Else
					SELECT MAX(NVL(A.ORDER_QTY, 0)) - MAX(NVL(B.YEBID1, 0))
					  INTO :ll_cha
					  FROM VAN_HKCD68 A,
							 ( SELECT ORDERNO, ITNBR, SUM(NVL(YEBID1, 0)) YEBID1
								  FROM SM04_DAILY_ITEM_SALE
								 WHERE FACTORY = :ls_factory AND ORDERNO IS NOT NULL
								GROUP BY ORDERNO, ITNBR ) B /* 출고량 */
					 WHERE A.FACTORY = :ls_factory
						AND A.MITNBR  = :ls_itnbr
						AND A.ORDERNO = :ls_orderno
						AND A.MITNBR  = B.ITNBR(+)
						AND A.ORDERNO = B.ORDERNO(+)
					GROUP BY A.MITNBR, A.ORDERNO ;
				End If
			End If
			
			If ll_cha < 1 Then // 잔량 < 1 이면 추가 출고 제외(출고가 완료된 경우)
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue
			End If
			
			If ll_cha < ll_chul Then // 잔량 < 출고요청수량 이면 출고 제외(분할출고 처리 중 잔량을 초과할 경우)
				dw_insert.DeleteRow(ll_r)
				ll_xl_row ++
				ll_succeed++
				If ll_jpno = 1 Then ll_jpno = 0
				Continue
			End If
		End If
/***********************************************************************************************************************/
		/* ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ */
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//도착일자, 도착시간은 e-Rapdos로 변경되면서 정보 삭제됨.
		/*********************************************************************
		ls_arrymd = Trim(uo_xl.uf_gettext(ll_xl_row,12))
		ls_arrtime = Trim(uo_xl.uf_gettext(ll_xl_row,13))
		
		ls_arrymd = f_replace(ls_arrymd , '-','') 
		ls_arrtime = f_replace(ls_arrtime , ':','') 
		
		uo_xltemp.uf_setvalue( 1, 1, ls_arrymd )
		
	   ls_arrymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		            String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					   String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		uo_xltemp.uf_setvalue( 1, 1, ls_arrtime )
		
		ls_arrtime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		             String(Long(uo_xltemp.uf_gettext(1,6)),'00') 
		**********************************************************************/
						 
		If ll_jpno = 1 or ll_jpno > 998 Then
			/*송장번호 채번*/
			ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
			IF ll_seq <= 0 THEN
				f_message_chk(51,'')
				ROLLBACK;
				Return -1
			END IF
			Commit;
			ll_jpno = 1
		end if
		
		String ls_na5
		  SELECT RFNA5
		    INTO :ls_na5
			 FROM REFFPF
			WHERE RFCOD = 'AD'
			  AND RFGUB = :ls_saupj ;
		If Trim(ls_na5) = '' OR IsNull(ls_na5) Then ls_na5 = 'P655'
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////////////////////////////
		dw_insert.Object.iojpno[ll_r]      = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_insert.Object.saupj[ll_r]       = ls_saupj
		dw_insert.Object.yymmdd[ll_r]      = ls_ymd
		dw_insert.Object.btime[ll_r]	     = ls_btime
		
//		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,3))
//		dw_insert.Object.custcd[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,4))
		dw_insert.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))
		dw_insert.Object.custcd[ll_r]      = ls_na5 //e-Rapdos변경 후 해당정보 삭제 됨.
		
		dw_insert.Object.factory[ll_r]     = ls_factory   
		
//		dw_insert.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,6))   
		dw_insert.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))

		dw_insert.Object.itnbr[ll_r]       = ls_itnbr
		dw_insert.Object.orderno[ll_r]     = ls_orderno
		//해당정보는 변동 없음.
		dw_insert.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
		dw_insert.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10))))   
		dw_insert.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		if ls_factory = 'Y' then		// 현대 CKD 인 경우는 수량 0으로 초기화
			dw_insert.Object.yebid1[ll_r]   = 0
		else
			dw_insert.Object.yebid1[ll_r]   = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))
		end if
		
		dw_insert.Object.arrymd[ll_r]      = ls_arrymd
		dw_insert.Object.arrtime[ll_r]     = ls_arrtime 
		//dw_insert.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,14)) 
		
//		dw_insert.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row,15))
		dw_insert.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row, 13))
		
		dw_insert.Object.cvcod[ll_r]       = ls_cvcod  
		///////////////////////////////////////////////////////////////////////////////////////////////

/********************* ↓CKD는 서열처리 하지 않음 - 품목정보 수정(NEW)에 관리되는 서열기준을 따름 - 2013.03.19 BY SHINGOON *********************/
		/* 서열기준은 발주번호가 있을 경우는 참조코드를 따르고 없을 경우는 품목정보 수정 따름 - 2007.01.23 - 송병호 */
		if ls_orderno > '.' then
			If ls_ckd = 'CKD' Then
				Select Nvl(seogu,'N') Into :ls_seogu From vndmrp_new
				 Where factory = :ls_factory And itnbr = :ls_itnbr ;
				dw_insert.Object.seogu[ll_r] = ls_seogu
			Else
				ll_count = 0 
				Select count(*) Into :ll_count
				  From reffpf 
				 Where rfcod = '2U'
					and rfgub = substr(:ls_orderno , -1 , 1 )
					and rfna3 = 'Y' ;
				If ll_count = 0 Then
					dw_insert.Object.seogu[ll_r] = 'Y' 
				else
					dw_insert.Object.seogu[ll_r] = 'N'
				end If
			End If
		else
			Select Nvl(seogu,'N') Into :ls_seogu From vndmrp_new
			 Where factory = :ls_factory And itnbr = :ls_itnbr ;

//			Select Nvl(seogu,'N') Into :ls_seogu From vndmrp
//			 Where cvcod = :ls_cvcod And itnbr = :ls_itnbr ;
			dw_insert.Object.seogu[ll_r] = ls_seogu
		end if
/********************* ↑CKD는 서열처리 하지 않음 - 품목정보 수정(NEW)에 관리되는 서열기준을 따름 - 2013.03.19 BY SHINGOON *********************/
		
		dw_insert.Object.yebis2[ll_r]      = 'HK'	 
		
		ll_xl_row ++
		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text =ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

// 출고일자 기록
//dw_1.Object.io_date[1] = ls_ymd

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return -1
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End if

MessageBox('Import 성공', '"저장"버튼을 눌러 최종 출고처리 하시기 바랍니다.~r~n저장 하지 않으면 출고에 나타나지 않습니다.')

w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하였습니다.'

Return ll_cnt
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\excel_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\excel_up.gif"
end event

type cbx_move from checkbox within w_sm40_0010
integer x = 2843
integer y = 336
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "울산이동출고"
boolean checked = true
end type

type dw_autoimhist from datawindow within w_sm40_0010
boolean visible = false
integer x = 526
integer y = 1252
integer width = 1678
integer height = 944
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sm40_0010_autio"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
end type

type dw_4 from datawindow within w_sm40_0010
boolean visible = false
integer x = 3813
integer y = 2332
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm40_0010_b"
boolean border = false
end type

type cb_2 from commandbutton within w_sm40_0010
integer x = 3575
integer y = 180
integer width = 343
integer height = 144
integer taborder = 70
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
string text = "To Excel"
end type

event clicked;dw_3.ReSet()
dw_3.InsertRow(0)

dw_3.Visible = True
end event

type cb_4 from commandbutton within w_sm40_0010
boolean visible = false
integer x = 3575
integer y = 24
integer width = 343
integer height = 144
integer taborder = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
boolean enabled = false
string text = "To PDA"
end type

event clicked;//String  ls_emp
//ls_emp = dw_1.GetItemString(1, 'empno')
//If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
////	MessageBox('확인', '담당자를 선택 하십시오.')
//	Return
//End If
//
//String  ls_depot
//ls_depot = dw_1.GetItemString(1, 'depot')
//If Trim(ls_depot) = '' Or IsNull(ls_depot) Then
////	MessageBox('확인', '기준창고를 선택 하십시오.')
//	Return
//End If
//
//String  ls_mcvcod
//ls_mcvcod = dw_1.GetItemString(1, 'mcvcod')
//If Trim(ls_mcvcod) = '' OR IsNull(ls_mcvcod) Then
////	MessageBox('확인', '물류업체를 선택 하십시오.')
//	Return
//End If
//
//String  ls_fac
//ls_fac = dw_1.GetItemString(1, 'factory')
//If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
////	MessageBox('확인', '공장을 선택 하십시오.')
//	Return
//End If
//
//Long    ll_cnt
//ll_cnt = dw_insert.RowCount()
//If ll_cnt < 1 Then
////	MessageBox('확인', '조회된 내역이 없습니다.')
//	Return
//End If

//If MessageBox('확인', 'PDA 출하 스캔 자료를 불러오겠습니까?', Question!, YesNo!, 1) <> 1 Then Return

dw_pda.SetRedraw(False)
dw_pda.Retrieve()

//dw_pda.X       = dw_insert.X + 100
//dw_pda.Y       = dw_insert.Y - 250
//dw_pda.Height  = dw_insert.Height
//dw_pda.Width   = dw_insert.Width - 250
//dw_pda.Visible = True

dw_pda.SetRedraw(True)

is_pda = 'Y' /* To PDA 버튼을 누르면 'Y' 저장버튼 눌러 자료 출고저장하면 'N' */
end event

type dw_pda from datawindow within w_sm40_0010
boolean visible = false
integer x = 2290
integer y = 1612
integer width = 928
integer height = 588
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "PDA 출하스캔 목록"
string dataobject = "d_pda_scanlist_010"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;This.SetTransObject(SQLCA)
end event

event buttonclicked;If row < 1 Then Return

Long    ll_pda
ll_pda = This.RowCount()

Long    ll_cnt

Choose Case dwo.name
	Case 'b_conf'
		Long    i
		Long    ll_find
		Long    ll_fchk
		Long    ll_pda_qty
		Long    ll_chl_qty
		String  ls_pda_itnbr
		String  ls_chl_jpno
		String  ls_cdat
		String  ls_plnt
		String  ls_depot
		String  ls_muluno
		String  ls_pda_itnbr_pre
		For i = 1 To ll_pda
			/* PDA 선택 자료 확인 */
			ll_find = This.Find("f_chk = 'Y'", i, ll_cnt)
			If ll_find < 1 Then Exit
			
			ls_cdat      = This.GetItemString(ll_find, 'chuldat' )
			ls_plnt      = This.GetItemString(ll_find, 'plnt'    )
			ls_depot     = This.GetItemString(ll_find, 'depot_no')
			ls_muluno	 = This.GetItemString(ll_find, 'mulu_no' )
			ls_pda_itnbr = This.GetItemString(ll_find, 'itnbr'   )
			ll_pda_qty   = This.GetItemNumber(ll_find, 'chulqty' )
			
			If ls_pda_itnbr <> ls_pda_itnbr_pre Then
				dw_5.SetRedraw(False)
				ll_cnt = dw_5.Retrieve('20', ls_cdat, ls_cdat, ls_plnt, ls_pda_itnbr, ls_pda_itnbr, '%', 'ET', ls_muluno)
				dw_5.SetRedraw(True)
			End If
			
			ls_pda_itnbr_pre = ls_pda_itnbr
			
			/* 출하목록에 품번확인 */
			ll_fchk = dw_5.Find("itnbr = '" + ls_pda_itnbr + "'", 1, ll_cnt)
			If ll_fchk < 1 Then
//				MessageBox('확인', '[' + ls_pda_itnbr + '] 품번은 물류업체 출하 대상에 없습니다.~r~n확인을 누르면 계속 진행 합니다.')
				i = ll_find
				Continue
			End If
			
			/* 선택 품번의 출하list에서 기존 출고수량을 가져온다(누적) */
			ll_chl_qty = dw_5.GetItemNumber(ll_fchk, 'yebid1')
			/* 수량 누적 기록 */
			dw_5.SetItem(ll_fchk, 'yebid1', ll_pda_qty + ll_chl_qty)
			
			/* 출하list에서 찾은 출하의뢰번호를 pda스캔 내역에 기록 */
			ls_chl_jpno = dw_5.GetItemString(ll_fchk, 'iojpno')
			/* 출하의뢰전표번호를 pda에 기록 */
			This.SetItem(ll_find, 'sm04jpno', ls_chl_jpno)
			
			i = ll_find
			
			If dw_5.UPDATE() = 1 Then
				COMMIT USING SQLCA;
			Else
				ROLLBACK USING SQLCA;
				Return
			End If
		Next
		
		If This.UPDATE() = 1 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
		End If
End Choose

end event

event itemchanged;If row < 1 Then Return

//Long    ll_cnt
//ll_cnt = This.RowCount()
//
//Choose Case dwo.name
//	Case 'f_chk'
//		String  ls_crtno
//		ls_crtno = This.GetItemString(row, 'crt_no')
//		
//		Long    i
//		Long    ll_find
//		For i = 1 To ll_cnt
//			ll_find = This.Find("crt_no = '" + ls_crtno + "'", i, ll_cnt)
//			If ll_find < 1 Then Exit
//			
//			This.SetItem(ll_find, 'f_chk', data)
//			
//			i = ll_find
//		Next
//End Choose
end event

type dw_pda_ins from datawindow within w_sm40_0010
boolean visible = false
integer x = 3269
integer y = 1652
integer width = 997
integer height = 480
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "PDA스캔자료 출고처리"
string dataobject = "d_pda_scanlist_020"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_pda_ret from commandbutton within w_sm40_0010
boolean visible = false
integer x = 3447
integer y = 1868
integer width = 407
integer height = 176
integer taborder = 90
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "조회"
end type

event clicked;dw_pda_ins.SetRedraw(False)
dw_pda_ins.Retrieve()
dw_pda_ins.SetRedraw(True)

//String ls_saupj , ls_sdate , ls_edate , ls_itnbr_fr , ls_itnbr_to , ls_empno , ls_factory ,ls_gubun ,ls_mdepot
//Long   ll_rcnt , i
//dw_1.AcceptText() 
//dw_insert.AcceptText() 
//
//ls_saupj = Trim(dw_1.Object.saupj[1])
//ls_sdate = Trim(dw_1.Object.jisi_date[1])
//ls_edate = Trim(dw_1.Object.jisi_date2[1])
//
//ls_gubun = Trim(dw_1.Object.gubun[1])
//
//If f_datechk(ls_sdate) < 1 Then
//	f_message_chk(35,'[기준일자(시작)]')
//	dw_1.setitem(1, "jisi_date", '')
//	dw_1.SetFocus()
//	return 
//end if
//
//If f_datechk(ls_edate) < 1 Then
//	f_message_chk(35,'[기준일자(끝)]')
//	dw_1.setitem(1, "jisi_date", '')
//	dw_1.SetFocus()
//	return 
//end if
//	
//ls_itnbr_fr = Trim(dw_1.Object.itnbr_from[1])
//ls_itnbr_to = Trim(dw_1.Object.itnbr_from[1])
//
//ls_factory = Trim(dw_1.Object.factory[1])
//ls_empno = Trim(dw_1.Object.empno[1])
//
//If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) then ls_itnbr_fr = '.'
//If ls_itnbr_to = '' or isNull(ls_itnbr_to) then ls_itnbr_to = 'z'
//If ls_factory = '' or isNull(ls_factory) or ls_factory= '.'  then ls_factory = '%'
//If ls_empno = '' or isNull(ls_empno) then 
//	f_message_chk(30,'[담당자]')
//	dw_1.setcolumn("empno")
//	dw_1.SetFocus()
//	return 
//end if
//
//String ls_mul
//
//ls_mul = dw_1.GetItemString(1, 'mcvcod')
//If Trim(ls_mul) = '' OR IsNull(ls_mul) Then ls_mul = '%'
//
//dw_pda_ins.SetRedraw(False)
//
//If ls_gubun = 'ET' Then
//	ll_rcnt = dw_pda_ins.Retrieve(ls_saupj, ls_sdate, ls_edate, ls_factory, ls_itnbr_fr, ls_itnbr_to, ls_empno, ls_gubun, ls_mul)
//End If
//
//Long ll_nap, ll_io
//If ll_rcnt < 1 Then
//	Messagebox('확인','조건에 해당하는 데이타가 없습니다.')
//End iF
//
//dw_pda_ins.SetRedraw(True)
end event

type dw_5 from datawindow within w_sm40_0010
boolean visible = false
integer x = 2053
integer y = 1192
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sm40_0010_a_et_pda"
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

