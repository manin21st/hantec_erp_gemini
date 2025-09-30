$PBExportHeader$w_sm50_0020.srw
$PBExportComments$납품실적 등록(물류업체)
forward
global type w_sm50_0020 from w_inherite
end type
type dw_1 from datawindow within w_sm50_0020
end type
type dw_imhist from datawindow within w_sm50_0020
end type
type pb_1 from u_pb_cal within w_sm50_0020
end type
type pb_2 from u_pb_cal within w_sm50_0020
end type
type rr_1 from roundrectangle within w_sm50_0020
end type
type rb_new from radiobutton within w_sm50_0020
end type
type rb_del from radiobutton within w_sm50_0020
end type
type pb_date from u_pb_cal within w_sm50_0020
end type
type p_excel from uo_picture within w_sm50_0020
end type
type dw_import from datawindow within w_sm50_0020
end type
type st_sts from statictext within w_sm50_0020
end type
type cbx_1 from checkbox within w_sm50_0020
end type
type cb_1 from commandbutton within w_sm50_0020
end type
type p_1 from uo_picture within w_sm50_0020
end type
type st_2 from statictext within w_sm50_0020
end type
type st_3 from statictext within w_sm50_0020
end type
type p_2 from picture within w_sm50_0020
end type
type rr_2 from roundrectangle within w_sm50_0020
end type
type rr_3 from roundrectangle within w_sm50_0020
end type
type rr_4 from roundrectangle within w_sm50_0020
end type
end forward

global type w_sm50_0020 from w_inherite
integer width = 4677
integer height = 2672
string title = "납품실적 등록"
dw_1 dw_1
dw_imhist dw_imhist
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rb_new rb_new
rb_del rb_del
pb_date pb_date
p_excel p_excel
dw_import dw_import
st_sts st_sts
cbx_1 cbx_1
cb_1 cb_1
p_1 p_1
st_2 st_2
st_3 st_3
p_2 p_2
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sm50_0020 w_sm50_0020

type variables
String is_depot_no
end variables

forward prototypes
public function integer wf_imhist_hk ()
public function integer wf_init ()
public function integer wf_imhist_import ()
public subroutine wf_status ()
end prototypes

public function integer wf_imhist_hk ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null ,ls_confirm_yn
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt , ll_cnt2
String ls_orderno, ls_yebi1
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

Dec ld_chqty , ld_sum_chqty , ld_ioqty , ld_jqty


String ls_depot_in , ls_io_date

String ls_mdepot

String ls_iojpno

SetNull(ls_null) 

if dw_insert.AcceptText() = -1 then Return -1  

IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

ls_ymd = Trim(dw_1.object.io_date[1])

If f_datechk(ls_ymd) < 1 Then
	Messagebox('확인','납품일자를 입력하세요.')
	dw_1.SetFocus()
	dw_1.SetColumn("io_date")
	Return -1
End IF

dw_insert.SetRedraw(False)

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

ll_jpno = 0 

String ls_seo
	
For i = 1 To dw_insert.Rowcount()

	ld_chqty = dw_insert.object.yebid1[i]
	
//	ld_sum_chqty =  dw_insert.object.sum_yebid1[i]
//	ld_jqty =  dw_insert.object.jego_qty[i]
//	
//	If ld_sum_chqty > ld_jqty Then
//		MessageBox('확인','출고수량이 재고수량보다 클수 없습니다.')
//      dw_insert.ScrollToRow(i)
//		dw_insert.SetRedraw(True)
//		Return -1
//	End If
	
	
	If isNull(ld_chqty) Then ld_chqty = 0 
	If ld_chqty <= 0 Then continue ;
	
	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	ls_mdepot = Trim(dw_insert.object.mdepot[i])
	
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

	If ll_jpno = 0 or  ll_jpno > 998 Then
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

	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_orderno = Trim(dw_insert.object.orderno[i])

	ll_cnt = 1 

/*	
    신ERP 로 바뀐 뒤부터는 주문번호의 발주 분류 구분이 없다고 함 --- By shjeon 20101215
	주문번호 있는 경우는 무조건 매출로 잡는다.
	Select count(*) Into :ll_cnt
	  From reffpf
	 where rfcod = '2U'
	   and rfgub = substr(:ls_orderno , -1 , 1 )
		and rfna3 = 'Y' ;
*/			
	/* 서열 여부로 "창고이동출고/판매출고" 로 정의 - by shingoon 2009.03.10********************************************/
   SELECT SEOGU
	  INTO :ls_seo
	  FROM VNDMRP_NEW
	 WHERE FACTORY = :ls_factory
	   AND ITNBR   = :ls_itnbr
		AND CVCOD   = :ls_cvcod ;
	If ls_seo = 'Y' Then
		ll_cnt2 = 0
		SetNull(ls_yebi1)
	Else
		ll_cnt2  = 1
		ls_yebi1 = ls_ymd
	End If
	/*******************************************************************************************************************
	// 파워텍 발주번호 정보 변경 - 참조코드의 A발주, B발주, W발주 등의 정보가 접수되지 않음. - by shingoon 2007.09.14
	// 파워텍 발주번호는 순수 발주번호(4504435257W -> 4504435257-0010으로 변경)에 순번(4자리) - by shingoon 2007.09.14
	
	/* // 위아, 현대모비스는 납품실적이 곧 검수(매출) - 2007.01.02 - 송병호
	if ls_factory = 'WK' or ls_factory = 'WS' or ls_factory = 'WP' or ls_factory = 'M1' or &
		ls_factory = 'M2' or ls_factory = 'M3' or ls_factory = 'M4' or ls_factory = 'M5' or ls_factory = 'M6' then*/
	
	if ls_factory = 'WK' or ls_factory = 'WS' or ls_factory = 'WP' or ls_factory = 'M1' or &
		ls_factory = 'M2' or ls_factory = 'M3' or ls_factory = 'M4' or ls_factory = 'M5' or ls_factory = 'M6' or &
		ls_factory = 'T6' or ls_factory = 'T7' or ls_factory = 'T8' or ls_factory = 'T9' then
		ll_cnt2 = 1
		ls_yebi1 = ls_ymd
	else
		ll_cnt2 = 0
		setnull(ls_yebi1)
	end if
	*******************************************************************************************************************/

	/* 서열에 대한 중복매출 발생 조치 - 2011.05.09 - 송병호 */
//	If ( ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) ) and ll_cnt2 = 0 Then
	//If ( ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) ) and ll_cnt2 = 0 Then
	/* 서열만 참조하여 매출 발생 시키도록 함 - 2011.05.23 - 전상현 */
	If ls_seo = 'Y' and ll_cnt2 = 0 Then
		
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
		
		// 창고이동 출고 

		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_insert.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_mdepot
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
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 물류창고 출고'
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
		dw_imhist.object.cvcod     [ll_r] =  ls_mdepot
		
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
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 납품창고 입고'
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
		dw_imhist.object.depot_no  [ll_r] =  ls_mdepot
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
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_insert.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드분 매출(물류)'
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
		//일 검수 확인 작업하는데.. 자동으로 검수일자가 들어감. 확인작업 해야함.(이석기GJ) - by shingoon 2009.06.18
		//dw_imhist.object.yebi1     [ll_r] = ls_yebi1
	
	end if
                          
                        
Next

dw_insert.AcceptText()

If dw_imhist.RowCount() > 0 Then
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_insert.SetRedraw(True)
		Return -1
	end if
end If

Commit ;

p_inq.TriggerEvent(Clicked!)
dw_insert.SetRedraw(True)

Return 1
	
end function

public function integer wf_init ();String ls_gubun 


If rb_new.Checked Then
	
   dw_insert.Dataobject = "d_sm50_0020_a"
	
	dw_1.object.gubun[1] = '1'
	pb_date.visible = True
	cb_1.Visible = True
	p_delrow.Visible = True
	p_del.Visible = False
else
	
	dw_insert.Dataobject = "d_sm50_0020_b"
	dw_1.object.gubun[1] = '2'
	pb_date.visible = False
	cb_1.Visible = False
	p_delrow.Visible = False
	p_del.Visible = True
	
end if

dw_insert.SetTransObject(SQLCA)

Return 1
end function

public function integer wf_imhist_import ();string ls_saupj , ls_factory , ls_cvcod , ls_itnbr , ls_new , ls_null ,ls_confirm_yn, ls_yebi1, ls_seo
String ls_ymd  , ls_ymd_pre='x' 
Long i ,ll_jpno ,ll_seq ,ll_r , ll_cnt , ll_cnt2
String ls_orderno
String ls_iogbn , ls_iogbn_out ,ls_iogbn_in
String ls_jnpcrt_1 , ls_inpcnf_1
String ls_jnpcrt_2 , ls_inpcnf_2
String ls_jnpcrt_3 , ls_inpcnf_3

Dec ld_chqty , ld_sum_chqty , ld_ioqty , ld_jqty


String ls_depot_in , ls_io_date

String ls_mdepot

String ls_iojpno

SetNull(ls_null) 

if dw_import.AcceptText() = -1 then Return -1 

//IF f_msg_update() < 1 then Return -1 

ls_saupj = Trim(dw_1.object.saupj[1])

ls_ymd = Trim(dw_1.object.io_date[1])

If f_datechk(ls_ymd) < 1 Then
	Messagebox('확인','납품일자를 입력하세요.')
	dw_1.SetFocus()
	dw_1.SetColumn("io_date")
	Return -1
End IF

dw_import.SetRedraw(False)

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

ll_jpno = 0 

st_sts.visible = True
	
For i = 1 To dw_import.Rowcount()
	

	ld_chqty = dw_import.object.yebid1[i]
	
//	ld_sum_chqty =  dw_import.object.sum_yebid1[i]
//	ld_jqty =  dw_import.object.jego_qty[i]
//	
//	If ld_sum_chqty > ld_jqty Then
//		MessageBox('확인','출고수량이 재고수량보다 클수 없습니다.')
//      dw_import.ScrollToRow(i)
//		st_sts.visible = false
//		Return -1
//	End If
	
	
	If isNull(ld_chqty) Then ld_chqty = 0 
	If ld_chqty <= 0 Then continue ;
	
	ls_cvcod = Trim(dw_import.object.cvcod[i])
	ls_itnbr = Trim(dw_import.object.itnbr[i])
	ls_mdepot = Trim(dw_import.object.mdepot[i])
	
	st_sts.text = ls_itnbr + " 품번을 출고하고 있습니다."
	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('확인','거래처코드는 필수 입니다. 참조코드에서 공장별 거래처를 입력후 다시 시도하세요. ')
		dw_import.ScrollToRow(i)
		dw_import.SetFocus()
		dw_import.SetColumn("cvcod")
		dw_import.SetRedraw(True)
		Return -1
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('확인','품번을 입력하세요.')
		dw_import.ScrollToRow(i)
		dw_import.SetFocus()
		dw_import.SetColumn("itnbr")
		dw_import.SetRedraw(True)
		st_sts.visible = false
		Return -1
	End If

	If ll_jpno = 0 or  ll_jpno > 998 Then
		/*송장번호 채번*/
		ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
		IF ll_seq <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			dw_import.SetRedraw(True)
			st_sts.visible = false
			Return -1
		END IF
		Commit;
		ll_jpno = 1

	else
		ll_jpno++
	end if 
	
	ls_iojpno = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
	
	dw_import.object.ip_jpno    [i] =  ls_iojpno

	// imhist 전표 생성 ( 매출 ) =======================================================================
	
	ls_factory = Trim(dw_import.object.factory[i])
	ls_orderno = Trim(dw_import.object.orderno[i])
	ll_cnt = 1 

/*	
    신ERP 로 바뀐 뒤부터는 주문번호의 발주 분류 구분이 없다고 함 --- By shjeon 20101215
	주문번호 있는 경우는 무조건 매출로 잡는다.
	Select count(*) Into :ll_cnt
	  From reffpf
	 where rfcod = '2U'
	   and rfgub = substr(:ls_orderno , -1 , 1 )
		and rfna3 = 'Y' ;
*/
/* 서열 여부로 "창고이동출고/판매출고" 로 정의 추가 - by SHJEON 2011.06.22********************************************/
   SELECT SEOGU
	  INTO :ls_seo
	  FROM VNDMRP_NEW
	 WHERE FACTORY = :ls_factory
	   AND ITNBR   = :ls_itnbr
		AND CVCOD   = :ls_cvcod ;
	If ls_seo = 'Y' Then
		ll_cnt = 0
	Else
		ll_cnt = 1
	End If
//	If ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' )  Then
		
/*	// 위아, 현대모비스는 납품실적이 곧 검수(매출) - 2007.01.02 - 송병호
	if ls_factory = 'WK' or ls_factory = 'WS' or ls_factory = 'WP' or ls_factory = 'M1' or &
		ls_factory = 'M2' or ls_factory = 'M3' or ls_factory = 'M4' or ls_factory = 'M5' or ls_factory = 'M6' then*/
	// 파워텍 발주번호 정보 변경 - 참조코드의 A발주, B발주, W발주 등의 정보가 접수되지 않음. - by shingoon 2007.09.14
	// 파워텍 발주번호는 순수 발주번호(4504435257W -> 4504435257-0010으로 변경)에 순번(4자리) - by shingoon 2007.09.14
	if ls_factory = 'WK' or ls_factory = 'WS' or ls_factory = 'WP' or ls_factory = 'M1' or &
		ls_factory = 'M2' or ls_factory = 'M3' or ls_factory = 'M4' or ls_factory = 'M5' or ls_factory = 'M6' or &
		ls_factory = 'T7' or ls_factory = 'T8' or ls_factory = 'T9' then
		ll_cnt2 = 1
		ls_yebi1 = ls_ymd
	else
		ll_cnt2 = 0
		setnull(ls_yebi1)
	end if

	//If ( ll_cnt = 0  or ( ls_orderno = '' or isNull(ls_orderno) or ls_orderno = '.' ) ) and ll_cnt2 = 0 Then
	/* 서열만 참조하여 매출 발생 시키도록 함 - 20110622 - 전상현 */
	If ls_seo = 'Y' and ll_cnt2 = 0 Then
		
		ls_confirm_yn = 'Y'
		ld_ioqty  = dw_import.object.yebid1[i]
		ls_io_date = ls_ymd
		
		Select cvcod 
		  Into :ls_depot_in
			from vndmst
		 Where cvgu = '5'
			and jumaechul = '3'
			and soguan = '1'
			and ipjogun = :ls_saupj
			and jungmock = :ls_factory ;
		
		// 창고이동 출고 

		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_out
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_import.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_mdepot
		dw_imhist.object.cvcod     [ll_r] =  ls_depot_in
		
		dw_imhist.object.ioqty     [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_import.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_import.object.yebid1[i] * dw_import.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_import.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 물류창고 출고'
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
		dw_imhist.object.facgbn    [ll_r] = dw_import.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'L'
		dw_imhist.object.sarea     [ll_r] = dw_import.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_import.object.iojpno[i]
		
		
		// 창고이동 입고 =======================================================================================
		ll_r = dw_imhist.InsertRow(0)
		ll_jpno++
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_imhist.object.iogbn     [ll_r] =  ls_iogbn_in
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_import.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_depot_in
		dw_imhist.object.cvcod     [ll_r] =  ls_mdepot
		
		dw_imhist.object.ioqty     [ll_r] =  ld_ioqty
		dw_imhist.object.ioprc     [ll_r] =  dw_import.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(ld_ioqty * dw_import.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_import.object.yebid1[i]
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
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno  /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_import.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드 납품창고 입고'
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
		dw_imhist.object.facgbn    [ll_r] = dw_import.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_import.object.yebis2[i]
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_import.object.iojpno[i]
	   //============================================================================================
		
   else
	
		ll_r = dw_imhist.InsertRow(0)
		
		dw_imhist.object.sabu      [ll_r] =  gs_sabu
		dw_imhist.object.iojpno    [ll_r] =  ls_iojpno
		dw_imhist.object.iogbn     [ll_r] =  'O02'
		dw_imhist.object.sudat     [ll_r] =  ls_ymd
		dw_imhist.object.itnbr     [ll_r] =  dw_import.object.itnbr[i]
		dw_imhist.object.pspec     [ll_r] =  '.'
		dw_imhist.object.opseq     [ll_r] =  '9999'
		dw_imhist.object.depot_no  [ll_r] =  ls_mdepot
		dw_imhist.object.cvcod     [ll_r] =  dw_import.object.cvcod[i]
		
		dw_imhist.object.ioqty     [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.ioprc     [ll_r] =  dw_import.object.vndmrp_new_sales_price[i]
		dw_imhist.object.ioamt     [ll_r] =  Truncate(dw_import.object.yebid1[i] * dw_import.object.vndmrp_new_sales_price[i] ,0 )
		dw_imhist.object.ioreqty   [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.insdat    [ll_r] =  ls_ymd
		dw_imhist.object.insemp    [ll_r] =  ls_null
		dw_imhist.object.qcgub     [ll_r] =  '1'
		dw_imhist.object.iofaqty   [ll_r] =  0
		dw_imhist.object.iopeqty   [ll_r] =  0
		dw_imhist.object.iospqty   [ll_r] =  0
		dw_imhist.object.iocdqty   [ll_r] =  0
		dw_imhist.object.iosuqty   [ll_r] =  dw_import.object.yebid1[i]
		dw_imhist.object.io_confirm[ll_r] =  'Y'
		dw_imhist.object.io_date   [ll_r] =  ls_ymd
		dw_imhist.object.io_empno  [ll_r] =  dw_1.object.empno[1]
		dw_imhist.object.lotsno    [ll_r] =  ls_orderno /* 발주번호 */
		dw_imhist.object.loteno    [ll_r] =  String(dw_import.object.oseq[i],'000000')
		dw_imhist.object.filsk     [ll_r] =  'Y'
		dw_imhist.object.bigo      [ll_r] = '납입카드분 매출(물류)'
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
		dw_imhist.object.facgbn    [ll_r] = dw_import.object.factory[i]
		dw_imhist.object.lclgbn    [ll_r] = 'V'
		dw_imhist.object.sarea     [ll_r] = dw_import.object.yebis2[i]
		
		
		// 실제 납품번호 
		dw_imhist.object.pjt_cd    [ll_r] = dw_import.object.iojpno[i]
		dw_imhist.object.yebi1     [ll_r] = ls_yebi1
	
	end if
                          
                        
Next

dw_import.AcceptText()

st_sts.text = " 출고 데이타를 저장 중입니다."

If dw_imhist.RowCount() > 0 Then
	IF dw_imhist.update() <= 0 	THEN
		ROLLBACK;
		Messagebox('확인','imhist 저장실패')
		dw_import.SetRedraw(True)
		st_sts.visible = false
		Return -1
	end if
end If

st_sts.visible =false
Commit ;

p_inq.TriggerEvent(Clicked!)
dw_import.SetRedraw(True)

Return 1
	
Return 1
end function

public subroutine wf_status ();dw_insert.AcceptText()

Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '실적 기초자료 저장 중 오류가 발생했습니다.')
	Return
End If

end subroutine

on w_sm50_0020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_imhist=create dw_imhist
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rb_new=create rb_new
this.rb_del=create rb_del
this.pb_date=create pb_date
this.p_excel=create p_excel
this.dw_import=create dw_import
this.st_sts=create st_sts
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.p_1=create p_1
this.st_2=create st_2
this.st_3=create st_3
this.p_2=create p_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_imhist
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rb_new
this.Control[iCurrent+7]=this.rb_del
this.Control[iCurrent+8]=this.pb_date
this.Control[iCurrent+9]=this.p_excel
this.Control[iCurrent+10]=this.dw_import
this.Control[iCurrent+11]=this.st_sts
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.p_1
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.p_2
this.Control[iCurrent+18]=this.rr_2
this.Control[iCurrent+19]=this.rr_3
this.Control[iCurrent+20]=this.rr_4
end on

on w_sm50_0020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_imhist)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rb_new)
destroy(this.rb_del)
destroy(this.pb_date)
destroy(this.p_excel)
destroy(this.dw_import)
destroy(this.st_sts)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_imhist.SetTransObject(SQLCA)
dw_import.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
End If

dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

dw_1.Object.io_date[1] = is_today

rb_new.Checked = True

dw_1.Object.mdepot[1] = 'ZZ1'

wf_init()


end event

type dw_insert from w_inherite`dw_insert within w_sm50_0020
integer x = 37
integer y = 356
integer width = 4562
integer height = 1916
integer taborder = 10
string dataobject = "d_sm50_0020_a"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value , ls_saupj , ls_name ,ls_ispec , ls_jijil ,ls_null
Long   ll_cnt
SetNull(ls_null)
ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
dw_1.AcceptText()
ls_saupj = Trim(dw_1.Object.saupj[1])
Choose Case ls_col
		
	Case 'is_chek'
		
			If ls_value = 'Y' Then
			
				dw_insert.object.yebid1[row] = dw_insert.object.napqty[row]
			
			else
				dw_insert.object.yebid1[row] = 0
			
			end if
			
		Case 'yebid1'
			Long   ll_yebid1
			
			ll_yebid1 = dw_insert.GetItemNumber(row, 'yebid1')
			
			If ll_yebid1 > 0 Then
				dw_insert.SetItem(row, 'is_chek', 'N')
			Else
				dw_insert.SetItem(row, 'is_chek', 'Y')
			End If	
	
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
		
		Open(w_itemas_multi_popup)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			
			ls_cvcod = Trim(this.object.cvcod[i])
			If ls_cvcod = '' or isNull(ls_cvcod) Then
				this.SetItem(i,"cvcod",object.cvcod[i - 1])
				this.SetItem(i,"vndmst_cvnas",object.vndmst_cvnas[i - 1])
			end iF
			
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
		
	Case "cvcod"
	
		
		gs_gubun = '1' 
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(row,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	
		
END Choose
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm50_0020
boolean visible = false
integer x = 3323
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;dw_insert.AcceptText()

If f_msg_delete() <> 1 Then Return

String ls_chk
String ls_yebis
Long   i, l

MessageBox('자료 확인', '구분이 "물류처"인 경우 삭제 가능 합니다.')

l = 0

For i = 1 To dw_insert.RowCount()
	ls_yebis = dw_insert.GetItemString(i, 'yebis2')
	If ls_yebis = 'NP' Then //물류처에서 랩도스 등록 했을 경우만 삭제
		ls_chk = dw_insert.GetItemString(i, 'is_chek')
		If ls_chk = 'Y' Then
			dw_insert.DeleteRow(i)	
			i = i - 1
		End If
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('삭제', '삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('실패', '삭제 중 오류가 발생 했습니다.')
	Return
End If
end event

type p_addrow from w_inherite`p_addrow within w_sm50_0020
boolean visible = false
integer x = 4201
integer y = 192
integer width = 174
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_sm50_0020
boolean visible = false
integer x = 3922
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

type p_ins from w_inherite`p_ins within w_sm50_0020
boolean visible = false
integer x = 3360
integer y = 140
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_sm50_0020
integer taborder = 0
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm50_0020
integer taborder = 0
end type

event p_can::clicked;call super::clicked;
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
End If

dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

dw_1.SetRedraw(True)





end event

type p_print from w_inherite`p_print within w_sm50_0020
boolean visible = false
integer x = 4384
integer y = 200
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_sm50_0020
integer x = 3749
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String ls_saupj , ls_sdate , ls_edate , ls_itnbr_fr , ls_itnbr_to , ls_empno , ls_factory ,ls_gubun
Long   ll_rcnt , i
dw_1.AcceptText() 
dw_insert.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.jisi_date[1])
ls_edate = Trim(dw_1.Object.jisi_date2[1])

ls_gubun = Trim(dw_1.Object.mdepot[1])

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
If ls_empno = '' or isNull(ls_empno) then ls_empno = '%'

String ls_status

If cbx_1.Checked = True Then
	ls_status = '%'
Else
	ls_status = 'N'
End If

dw_insert.SetRedraw(False)
ll_rcnt = dw_insert.Retrieve( ls_saupj , ls_sdate , ls_edate , ls_factory ,ls_itnbr_fr , ls_itnbr_to, ls_gubun, ls_status  ) 
	
If ll_rcnt > 0 Then

	
Else
	Messagebox('확인','조건에 해당하는 데이타가 없습니다.')

End iF
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm50_0020
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Long i ,ll_rcnt , ll_cnt , ii
string ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust ,ls_new
String ls_iojpno

if dw_1.AcceptText() = -1 then return -1

If rb_new.Checked Then
	MessageBox('확인','등록 상태일때는  삭제할 수 없습니다.')
	Return
End IF

ls_saupj = Trim(dw_1.Object.saupj[1])


if dw_insert.AcceptText() = -1 then return -1
if dw_insert.rowcount() <= 0 then return -1

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

ii = 0
Long   ll_err
String ls_err
For i = ll_rcnt To 1 Step -1
	
	If dw_insert.isSelected(i) Then
	
		ls_iojpno = Trim(dw_insert.object.iojpno[i])
		
		If rb_del.Checked Then
	
			Delete From imhist where sabu = '1' and ( iojpno = :ls_iojpno or ip_jpno = :ls_iojpno ) ;
			If sqlca.sqlcode <> 0 Then
				ll_err = sqlca.sqldbcode ; ls_err = sqlca.sqlerrtext
				Rollback;
				MessageBox('확인 ' + String(ll_err), '삭제 실패2~r~n' + ls_err)
				return
			End if
	
		End if
	
		dw_insert.ScrollToRow(i)
		dw_insert.DeleteRow(i)
		ii++
	End if
		
Next

commit ;

sle_msg.text =	string(ii) + "건의 자료를 삭제하였습니다!!"	
	
dw_insert.SetRedraw(TRUE)
end event

type p_mod from w_inherite`p_mod within w_sm50_0020
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;String ls_gubun

If rb_del.Checked Then 
	Messagebox('확인','등록 상태일때 저장가능합니다.')
	Return
End if

If dw_1.AcceptText() < 1 Then Return

wf_imhist_hk()
end event

type cb_exit from w_inherite`cb_exit within w_sm50_0020
end type

type cb_mod from w_inherite`cb_mod within w_sm50_0020
end type

type cb_ins from w_inherite`cb_ins within w_sm50_0020
end type

type cb_del from w_inherite`cb_del within w_sm50_0020
end type

type cb_inq from w_inherite`cb_inq within w_sm50_0020
end type

type cb_print from w_inherite`cb_print within w_sm50_0020
end type

type st_1 from w_inherite`st_1 within w_sm50_0020
end type

type cb_can from w_inherite`cb_can within w_sm50_0020
end type

type cb_search from w_inherite`cb_search within w_sm50_0020
end type







type gb_button1 from w_inherite`gb_button1 within w_sm50_0020
end type

type gb_button2 from w_inherite`gb_button2 within w_sm50_0020
end type

type dw_1 from datawindow within w_sm50_0020
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 12
integer width = 2962
integer height = 324
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm50_0020_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	
	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'itnbr_to', ls_value)
	   end if
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if
	
END CHOOSE

end event

event itemerror;Return 1
end event

type dw_imhist from datawindow within w_sm50_0020
boolean visible = false
integer x = 2464
integer y = 356
integer width = 1888
integer height = 916
integer taborder = 10
boolean bringtotop = true
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

type pb_1 from u_pb_cal within w_sm50_0020
integer x = 814
integer y = 144
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sm50_0020
integer x = 1298
integer y = 144
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date2', gs_code)

end event

type rr_1 from roundrectangle within w_sm50_0020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 348
integer width = 4576
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_new from radiobutton within w_sm50_0020
integer x = 3040
integer y = 80
integer width = 224
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

type rb_del from radiobutton within w_sm50_0020
integer x = 3040
integer y = 208
integer width = 224
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

type pb_date from u_pb_cal within w_sm50_0020
integer x = 2066
integer y = 236
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('io_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'io_date', gs_code)

end event

type p_excel from uo_picture within w_sm50_0020
integer x = 3922
integer y = 180
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
uo_xlobject uo_xl , uo_xltemp,ls_nabpum_no,ls_printyn,ls_chul_con,ls_nab_date

string ls_docname, ls_named[] ,ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_orderno, ls_mdepot_no

Long ll_seq , ll_jpno  , ll_count

String ls_custcd , ls_iojpno[]

If dw_1.AcceptText() <> 1 Then Return -1

ls_saupj = Trim(dw_1.Object.saupj[1]) 
ls_mdepot_no = Trim(dw_1.Object.mdepot[1])

Select fun_get_reffpf_value('AD' , :ls_saupj , 4 ) Into :ls_custcd from dual ; 

// 엘셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("KMC 일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_import.Reset()
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
uo_xltemp.uf_excel_connect('C:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

st_sts.visible = True

String ls_depot
ls_depot = dw_1.GetItemString(1, 'mdepot')

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	st_sts.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		st_sts.visible = false
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
		if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
		
		ll_r = dw_import.InsertRow(0) 
		ll_cnt++
		ll_jpno++
		
		dw_import.Scrolltorow(ll_r)
	
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
//		If Trim(uo_xl.uf_gettext(ll_xl_row,4)) <> ls_custcd Then
//			Continue ;
//		End IF
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_ymd = Trim(uo_xl.uf_gettext(ll_xl_row,1))
		//ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		//ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row,5))
		//ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row,7))
		
		ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 2))		// 발행일자
		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 3))		// 시간
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 5))      // 공장
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 6))      // 품번
		//////////////////////////////////////////////////////////////////////
		
	   st_sts.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
		
		uo_xltemp.uf_setvalue( 1, 1, ls_ymd )
		
	   ls_ymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		         String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		If f_datechk(ls_ymd) < 1 Then
			MessageBox('확인','날자형식에 맞지 않습니다.')
			Rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			st_sts.visible = false
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
			
			dw_import.Object.factory[ll_r]     =    "미등록 공장"
			ll_err++
			ll_xl_row ++
			Continue ;

		End IF
	   ll_c = 0 
		select count(*) 
		  into :ll_c
		  from itemas
		 where itnbr = :ls_itnbr ;
			
		if ll_c = 0 then
			
			dw_import.Object.itnbr[ll_r]     =    "미등록 품번"
			ll_err++
			ll_xl_row ++
			Continue ;
	
		End IF
		
		SetNull(ll_c)
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_orderno =  Trim(uo_xl.uf_gettext(ll_xl_row,8))		// 납기일자
		
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 7))		// 발주번호
		
//		If ls_orderno = '' or isNull(ls_orderno) Then ls_orderno = '.'
//	
//		Select Count(*) Into :ll_c
//		  From SM04_DAILY_ITEM_SALE
//		  Where saupj = :ls_saupj
//			 and yymmdd = :ls_ymd
//			 and btime = :ls_btime
//			 and factory = :ls_factory
//			 and itnbr = :ls_itnbr
//			 and orderno = :ls_orderno ;
//			 
//		If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//			MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
//			w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
//			uo_xl.uf_excel_Disconnect()
//			uo_xltemp.uf_excel_Disconnect()
//			st_sts.visible = false
//			Return -1
//		End If
		
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
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
				MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
				w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
				uo_xl.uf_excel_Disconnect()
				uo_xltemp.uf_excel_Disconnect()
				Return -1
			End If
		Else
			Long  ll_oseq
			//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
			ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))		// 발주 SEQ
			
			//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
			
			SELECT COUNT(*)
			  INTO :ll_c
			  FROM SM04_DAILY_ITEM_SALE
			 WHERE SAUPJ = :ls_saupj
			   AND YYMMDD = :ls_ymd
				AND FACTORY = :ls_factory
				AND ITNBR = :ls_itnbr
				AND ORDERNO = :ls_orderno
				AND OSEQ = :ll_oseq ;
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
				MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
				w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
				uo_xl.uf_excel_Disconnect()
				uo_xltemp.uf_excel_Disconnect()
				Return -1
			End If
		End If
/***********************************************************************************************************************/
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
				st_sts.visible = false
				Return -1
			END IF
			Commit;
			iii++
			ls_iojpno[iii] = ls_ymd + String(ll_seq,'0000')
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
		dw_import.Object.iojpno[ll_r]      = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_import.Object.saupj[ll_r]       = ls_saupj
		dw_import.Object.yymmdd[ll_r]      = ls_ymd			//9.발행일자
		dw_import.Object.btime[ll_r]	     = ls_btime			//10.시간
		
//		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,3))
//		dw_import.Object.custcd[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,4))
		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		// 차량
		dw_import.Object.custcd[ll_r]      = ls_na5 //e-Rapdos변경 후 해당정보 삭제 됨.	
		
		dw_import.Object.factory[ll_r]     = ls_factory   			// 1.공장
		
//		dw_import.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,6))   
		dw_import.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 하치장
		
		dw_import.Object.itnbr[ll_r]       = ls_itnbr					//3.품번
		dw_import.Object.orderno[ll_r]     = ls_orderno			//6.발주번호
		
		dw_import.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))		// 발주 SEQ
		dw_import.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10))))   	// 발주수량
		dw_import.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 	// 납품수량	
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		dw_import.Object.yebid1[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))  	// 8.납품수량
		
		dw_import.Object.arrymd[ll_r]      = ls_arrymd
		dw_import.Object.arrtime[ll_r]     = ls_arrtime 
		//dw_import.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,14))		// SERI 기존 안넣었음
		//dw_import.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,7))		// 7.SERI
		
//		dw_import.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row,15))
		dw_import.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row, 13))		//   PILLOT
		
		dw_import.Object.cvcod[ll_r]       = ls_cvcod
		
		dw_import.Object.mdepot_no[ll_r]   = ls_mdepot_no
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		
		ll_count = 0 
		Select count(*) Into :ll_count
		  From reffpf 
		 Where rfcod = '2U'
		   and rfgub = substr(:ls_orderno , -1 , 1 )
			and rfna3 = 'Y' ;
		If ll_count = 0 Then
			dw_import.Object.seogu[ll_r] = 'Y' 
		else
			dw_import.Object.seogu[ll_r] = 'N'
		end If 
		
		dw_import.Object.yebis2[ll_r]      = 'NP'		// 납품	 
		
		ll_xl_row ++
		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text =ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

dw_import.AcceptText()

st_sts.text =' 데이타를 저장 중입니다.'

If dw_import.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	st_sts.visible = false
	Return -1
Else
	Commit;
	st_sts.visible = false
	
	dw_import.Retrieve(ls_iojpno[1] + '0000', ls_iojpno[ UpperBound(ls_iojpno) ] + '9999')
	
	If wf_imhist_import() > 0 Then
		rb_new.Checked = false
		rb_del.Checked = True
		wf_init()
		
		dw_1.object.jisi_date[1] = dw_1.object.io_date[1]
		dw_1.object.jisi_date2[1] = dw_1.object.io_date[1]
		dw_1.object.itnbr_from[1] =''
		dw_1.object.itnbr_to[1] = ''
		dw_1.object.factory[1] = ''
		p_inq.TriggerEvent(Clicked!)
		
	End if

End if

w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하엿습니다.'

Return ll_cnt
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\excel_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\excel_up.gif"
end event

type dw_import from datawindow within w_sm50_0020
boolean visible = false
integer x = 32
integer y = 732
integer width = 4581
integer height = 1544
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "엑셀 IMPORT"
string dataobject = "d_sm50_0010_import"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_sts from statictext within w_sm50_0020
boolean visible = false
integer x = 1733
integer y = 820
integer width = 1253
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 32106727
string text = "파일을 읽는 중입니다....."
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_sm50_0020
integer x = 2304
integer y = 248
integer width = 585
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "종료 발주 보기"
end type

type cb_1 from commandbutton within w_sm50_0020
integer x = 3319
integer y = 240
integer width = 457
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "발주완료"
end type

event clicked;wf_status()
end event

type p_1 from uo_picture within w_sm50_0020
integer x = 4274
integer y = 180
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime,ls_nab_date
uo_xlobject uo_xl , uo_xltemp,ls_nabpum_no,ls_printyn,ls_chul_con

string ls_docname, ls_named[] ,ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_orderno, ls_mdepot_no

Long ll_seq , ll_jpno  , ll_count

String ls_custcd , ls_iojpno[]

If dw_1.AcceptText() <> 1 Then Return -1

ls_saupj = Trim(dw_1.Object.saupj[1]) 
ls_mdepot_no = Trim(dw_1.Object.mdepot[1])

Select fun_get_reffpf_value('AD' , :ls_saupj , 4 ) Into :ls_custcd from dual ; 

// 엘셀 IMPORT ***************************************************************

ll_value = GetFileOpenName("HMC 일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

//dw_import.visible = True			//테스트 때 풀어서 확인함
dw_import.Reset()
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
uo_xltemp.uf_excel_connect('C:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

st_sts.visible = True

String ls_depot
ls_depot = dw_1.GetItemString(1, 'mdepot')

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	st_sts.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		st_sts.visible = false
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
		
		ll_r = dw_import.InsertRow(0) 
		ll_cnt++
		ll_jpno++
		
		dw_import.Scrolltorow(ll_r)
	
		//e-Rapdos로 변경 Excel Format 바뀜 길이 및 일자 위치변경. - 2012.03.30 by shjeon ////////
		For i =1 To 29
			//uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
			if i = 3 or i = 5 or i = 17 then											// 발행일자, 납입일자 날짜 서식 그대로 받는다
				uo_xl.uf_set_format(ll_xl_row,i, 'yyyy-mm-dd')		// 날짜 형식이 먹혔을 때 서식 변환하면 실제 데이터는 2011-05-05 00:00:00 으로 들어온다
			else
				uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))	
			end if
		Next
		
//		If Trim(uo_xl.uf_gettext(ll_xl_row,4)) <> ls_custcd Then
//			Continue ;
//		End IF
		
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
		//ls_ymd   = Trim(uo_xl.uf_gettext(ll_xl_row, 9))		// 9.발행일자
//		ls_ymd   = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 9)),10) 		// 9.발행일자
//		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 10))		// 10.시간
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row, 1))      // 1.공장
//		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 3))      // 3.품번		
//		ls_nab_date = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 14)),10)		// 14.납입일자
		//e-Rapdos로 변경 Excel Format 바뀜. - 2012.03.30 by shjeon ////////
		ls_ymd   = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 3)),10) 		// 3.발행일자
		ls_btime = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		                  // 4.시간
		ls_itnbr = LEFT(Trim(uo_xl.uf_gettext(ll_xl_row, 10)),5)+'-'+MID(Trim(uo_xl.uf_gettext(ll_xl_row, 10)),6)                        // 10.품번	품번 중간에 - 구분자가 없이 들어와 강제 입력	
		ls_nab_date = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 17)),10)		// 17.납기일자 <- 납입일자 
		//////////////////////////////////////////////////////////////////////
		
	   st_sts.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
		
//		uo_xltemp.uf_setvalue( 1, 1, ls_ymd )
//		
//	   ls_ymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
//		         String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
//					String(Long(uo_xltemp.uf_gettext(1,4)),'00')

		SELECT REPLACE(:ls_ymd, '-', ''),
				 REPLACE(:ls_nab_date , '-', '')
		  INTO :ls_ymd, :ls_nab_date 			//발행일자, 납입일자
		  FROM DUAL ;
	  
		If f_datechk(ls_ymd) < 1 Then
			MessageBox('확인','날자형식에 맞지 않습니다.')
			Rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			st_sts.visible = false
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
			
			dw_import.Object.factory[ll_r]     =    "미등록 공장"
			ll_err++
			ll_xl_row ++
			Continue ;

		End IF
	   ll_c = 0 
		select count(*) 
		  into :ll_c
		  from itemas
		 where itnbr = :ls_itnbr ;					
			
		if ll_c = 0 then
			
			dw_import.Object.itnbr[ll_r]     =    "미등록 품번"
			ll_err++
			ll_xl_row ++
			Continue ;
	
		End IF
		
		SetNull(ll_c)
		
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//ls_orderno =  Trim(uo_xl.uf_gettext(ll_xl_row,8))		// 납기일자
		//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
		//ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 7))		// 발주번호
//		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 6))		// 6.발주번호
		//e-Rapdos로 변경 Excel Format 바뀜. - 2012.03.30 by shjeon ////////
		ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 12.구매번호 <- 발주번호
		
//		If ls_orderno = '' or isNull(ls_orderno) Then ls_orderno = '.'
//	
//		Select Count(*) Into :ll_c
//		  From SM04_DAILY_ITEM_SALE
//		  Where saupj = :ls_saupj
//			 and yymmdd = :ls_ymd
//			 and btime = :ls_btime
//			 and factory = :ls_factory
//			 and itnbr = :ls_itnbr
//			 and orderno = :ls_orderno ;
//			 
//		If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//			MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
//			w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
//			uo_xl.uf_excel_Disconnect()
//			uo_xltemp.uf_excel_Disconnect()
//			st_sts.visible = false
//			Return -1
//		End If
		
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
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
				MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
				w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
				uo_xl.uf_excel_Disconnect()
				uo_xltemp.uf_excel_Disconnect()
				Return -1
			End If
		Else
			Long  ll_oseq
			//e-Rapdos로 변경 Excel Format 바뀜. - 2010.09.06 by shjeon ////////
			//ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))		// 발주 SEQ
//			ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))		//5. 발주 SEQ
		    //e-Rapdos로 변경 Excel Format 바뀜. - 2012.03.30 by shjeon ////////
			ll_oseq = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,13))))		//13. 구매문서번호 <- 발주 SEQ
			//위의 쿼리는 일자가 다를 경우 발주가 중복으로 생성 됨.
			
			SELECT COUNT(*)
			  INTO :ll_c
			  FROM SM04_DAILY_ITEM_SALE
			 WHERE SAUPJ = :ls_saupj
			   AND YYMMDD = :ls_ymd
				AND FACTORY = :ls_factory
				AND ITNBR = :ls_itnbr
				AND ORDERNO = :ls_orderno
				AND OSEQ = :ll_oseq ;
			If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//				dw_insert.DeleteRow(ll_r)
//				ll_xl_row ++
//				ll_succeed++
//				If ll_jpno = 1 Then ll_jpno = 0
//				Continue ;
				MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
				w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
				uo_xl.uf_excel_Disconnect()
				uo_xltemp.uf_excel_Disconnect()
				Return -1
			End If
		End If
/***********************************************************************************************************************/
		//e-Rapdos로 변경 Excel Format 바뀜. - 2008.09.01 by shingoon ////////
		//도착일자, 도착시간은 e-Rapdos로 변경되면서 정보 삭제됨.
		//e-Rapdos로 변경 Excel Format 바뀜. - 2012.03.30 by shjeon ////////
		//도착일자, 도착시간 다시 들어오기 시작함.
//		/*********************************************************************
		ls_arrymd = Trim(uo_xl.uf_gettext(ll_xl_row,5))			// 5. 도착일자
		ls_arrtime = Trim(uo_xl.uf_gettext(ll_xl_row,6))            // 6. 도착시간
		
		ls_arrymd = f_replace(ls_arrymd , '-','') 
		ls_arrtime = f_replace(ls_arrtime , ':','') 
		
		uo_xltemp.uf_setvalue( 1, 1, ls_arrymd )
		
	   ls_arrymd = String(Long(uo_xltemp.uf_gettext(1,2)),'0000') + &
		            String(Long(uo_xltemp.uf_gettext(1,3)),'00') + &
					   String(Long(uo_xltemp.uf_gettext(1,4)),'00')
					
		uo_xltemp.uf_setvalue( 1, 1, ls_arrtime )
		
		ls_arrtime = String(Long(uo_xltemp.uf_gettext(1,5)),'00') + &
		             String(Long(uo_xltemp.uf_gettext(1,6)),'00') 
//		**********************************************************************/
						 
		If ll_jpno = 1 or ll_jpno > 998 Then
			/*송장번호 채번*/
			ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
			IF ll_seq <= 0 THEN
				f_message_chk(51,'')
				ROLLBACK;
				st_sts.visible = false
				Return -1
			END IF
			Commit;
			iii++
			ls_iojpno[iii] = ls_ymd + String(ll_seq,'0000')
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
		//e-Rapdos로 변경 Excel Format 바뀜. - 2012.03.30 by shjeon ////////
		dw_import.Object.iojpno[ll_r]      = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
		dw_import.Object.saupj[ll_r]       = ls_saupj
		dw_import.Object.yymmdd[ll_r]      = ls_ymd			//발행일자
		dw_import.Object.btime[ll_r]	     = ls_btime			//시간
		
//		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,3))
//		dw_import.Object.custcd[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,4))
//		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		// 차량
//		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 11))		// 11.차량번호
		dw_import.Object.ncarno[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 7))		// 7.차량번호
		dw_import.Object.custcd[ll_r]      = ls_na5 //e-Rapdos변경 후 해당정보 삭제 됨.	
		
		dw_import.Object.factory[ll_r]     = ls_factory   			// 1.공장
		
//		dw_import.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row,6))   
//		dw_import.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 하치장
		dw_import.Object.newits[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 2))		// 2. 하치장
		
		dw_import.Object.itnbr[ll_r]       = ls_itnbr					//3.품번
		dw_import.Object.orderno[ll_r]     = ls_orderno			//6.발주번호
		
		//dw_import.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))		// 발주 SEQ
//		dw_import.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))		// 5. 발주 SEQ
		dw_import.Object.oseq[ll_r]        = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,13))))		// 13. 발주 SEQ
//		dw_import.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))   	// 발주수량
		dw_import.Object.ordqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,14))))   	// 14.발주수량
		
		//dw_import.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 	// 납품수량
//		dw_import.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8)))) 	// 8.납품수량
		dw_import.Object.napqty[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,15)))) 	// 15.납품수량
		
		
//		dw_import.Object.nabpum_no[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 4))		// 4. 납품서번호
//		dw_import.Object.yebis6[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 12))		// 12.인쇄여부
//		dw_import.Object.yebis3[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 13))		// 13.출하전송
		
		dw_import.Object.nabpum_no[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 8))		// 8. 납품서번호
		dw_import.Object.yebis6[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 27))		// 27.인쇄여부
		dw_import.Object.yebis3[ll_r]      = Trim(uo_xl.uf_gettext(ll_xl_row, 28))		// 28.출하전송
		dw_import.Object.yebis5[ll_r]      = ls_nab_date										// 14.납입일자
		/////////////////////////////////////////////////////////////////////////////////////////////
		
//		dw_import.Object.yebid1[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))  	// 8.납품수량
		dw_import.Object.yebid1[ll_r]      = Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,15))))  	// 15.납품수량
		
		dw_import.Object.arrymd[ll_r]      = ls_arrymd
		dw_import.Object.arrtime[ll_r]     = ls_arrtime 
		//dw_import.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,14))		// SERI 기존 안넣었음
		//dw_import.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,7))		// 7.SERI
		
//		dw_import.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row,15))
//		dw_import.Object.pilotgu[ll_r]     = Trim(uo_xl.uf_gettext(ll_xl_row, 13))		//   PILLOT
		
		dw_import.Object.cvcod[ll_r]       = ls_cvcod
		
		dw_import.Object.mdepot_no[ll_r]   = ls_mdepot_no
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		
		ll_count = 0 
		Select count(*) Into :ll_count
		  From reffpf 
		 Where rfcod = '2U'
		   and rfgub = substr(:ls_orderno , -1 , 1 )
			and rfna3 = 'Y' ;
		If ll_count = 0 Then
			dw_import.Object.seogu[ll_r] = 'Y' 
		else
			dw_import.Object.seogu[ll_r] = 'N'
		end If 
		
		dw_import.Object.yebis2[ll_r]      = 'NP'		// 납품	 
		
		ll_xl_row ++
		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text =ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

dw_import.AcceptText()

st_sts.text =' 데이타를 저장 중입니다.'

If dw_import.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	st_sts.visible = false
	Return -1
Else
	Commit;
	st_sts.visible = false
	
	dw_import.Retrieve(ls_iojpno[1] + '0000', ls_iojpno[ UpperBound(ls_iojpno) ] + '9999')
	
	If wf_imhist_import() > 0 Then
		rb_new.Checked = false
		rb_del.Checked = True
		wf_init()
		
		dw_1.object.jisi_date[1] = dw_1.object.io_date[1]
		dw_1.object.jisi_date2[1] = dw_1.object.io_date[1]
		dw_1.object.itnbr_from[1] =''
		dw_1.object.itnbr_to[1] = ''
		dw_1.object.factory[1] = ''
		p_inq.TriggerEvent(Clicked!)
		
	End if

End if

w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_err)+',성공 :'+String(ll_succeed) + ') 데이타 처리를 하엿습니다.'

Return ll_cnt
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\excel_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\excel_up.gif"
end event

type st_2 from statictext within w_sm50_0020
integer x = 3785
integer y = 192
integer width = 142
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217750
string text = "KMC"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm50_0020
integer x = 4133
integer y = 192
integer width = 142
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 134217857
long backcolor = 134217750
string text = "HMC"
boolean focusrectangle = false
end type

type p_2 from picture within w_sm50_0020
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 3502
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event ue_lbuttondown;PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(dw_insert,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type rr_2 from roundrectangle within w_sm50_0020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2999
integer y = 16
integer width = 283
integer height = 316
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm50_0020
string tag = "KMC"
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3781
integer y = 168
integer width = 338
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sm50_0020
string tag = "KMC"
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 4128
integer y = 168
integer width = 338
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

