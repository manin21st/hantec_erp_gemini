$PBExportHeader$w_imt_03020.srw
$PBExportComments$구매L/C등록
forward
global type w_imt_03020 from w_inherite
end type
type p_amend from uo_picture within w_imt_03020
end type
type dw_detail from datawindow within w_imt_03020
end type
type dw_1 from datawindow within w_imt_03020
end type
type dw_hidden from datawindow within w_imt_03020
end type
type pb_1 from u_pb_cal within w_imt_03020
end type
type pb_2 from u_pb_cal within w_imt_03020
end type
type pb_3 from u_pb_cal within w_imt_03020
end type
type pb_4 from u_pb_cal within w_imt_03020
end type
type rr_3 from roundrectangle within w_imt_03020
end type
type rr_4 from roundrectangle within w_imt_03020
end type
end forward

global type w_imt_03020 from w_inherite
boolean visible = false
string title = "구매L/C 등록"
p_amend p_amend
dw_detail dw_detail
dw_1 dw_1
dw_hidden dw_hidden
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_3 rr_3
rr_4 rr_4
end type
global w_imt_03020 w_imt_03020

type variables
char   ic_status
string is_Last_Jpno, is_Date
String is_cnvgu    //발주단위사용구분


end variables

forward prototypes
public function integer wf_bl_chk ()
public function integer wf_checkrequiredfield ()
public function integer wf_confirm_key ()
public function integer wf_dupchk (long lrow, string balno, integer balseq, string scurr)
public function integer wf_mult_custom (string as_code, string as_gubun)
public function integer wf_openchk (string sitnbr, integer lrow)
public subroutine wf_reset ()
public subroutine wf_set_poblkt (string ar_baljpno)
public subroutine wf_taborder ()
public subroutine wf_taborderzero ()
public function integer wf_delete ()
public function integer wf_amend_history (string slcno)
public subroutine wf_new ()
public subroutine wf_query ()
end prototypes

public function integer wf_bl_chk ();int    k, iseq, get_count
string sbaljpno, slcno

FOR k=1 TO dw_insert.rowcount()
	slcno    = dw_insert.getitemstring(k, 'polcno')
	sbaljpno = dw_insert.getitemstring(k, 'baljpno')
	iseq     = dw_insert.getitemnumber(k, 'balseq')
	
	get_count = 0	
	SELECT COUNT(*)
     INTO :get_count  
     FROM "POLCBL"  
    WHERE ( "POLCBL"."SABU"    = :gs_sabu ) AND  
          ( "POLCBL"."POLCNO"  = :slcno ) AND  
          ( "POLCBL"."BALJPNO" = :sbaljpno ) AND  
          ( "POLCBL"."BALSEQ"  = :iseq )   ;

	if get_count > 0 then 
		dw_insert.setitem(k, 'opt', 'N')
	end if

	get_count = 0
	SELECT COUNT(*)
     INTO :get_count  
     FROM "IMHIST"  
    WHERE ( "IMHIST"."SABU"    = :gs_sabu ) AND  
          ( "IMHIST"."POLCNO"  = :slcno ) AND  
          ( "IMHIST"."BALJPNO" = :sbaljpno ) AND  
          ( "IMHIST"."BALSEQ"  = :iseq )   ;

	if get_count > 0 then 
		dw_insert.setitem(k, 'opt', 'O')
	end if	
	
NEXT

return 1
end function

public function integer wf_checkrequiredfield ();string	sLcno, sitnbr, sBank, sOpendate, spobfcd
dec		dQty
long		lRow

sLcno = dw_detail.GetItemString(1, "polcno")
IF IsNull(sLcno) 	or   sLcno = ''	THEN
	f_message_chk(30,'[L/C 번호]')		
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN -1
END IF

sBank = dw_detail.GetItemString(1, "poopbk")
IF IsNull(sBank) 	or   sbank = ''	THEN
	f_message_chk(30,'[OPEN BANK]')		
	dw_detail.SetColumn("poopbk")
	dw_detail.SetFocus()
	RETURN -1
END IF

sOpendate = trim(dw_detail.GetItemString(1, "opndat"))
IF IsNull(sOpendate) 	or   sOpendate = ''	THEN
	f_message_chk(30,'[OPEN 일자]')		
	dw_detail.SetColumn("opndat")
	dw_detail.SetFocus()
	RETURN -1
END IF

spobfcd = dw_detail.GetItemString(1, "pobfcd")
IF IsNull(spobfcd) 	or   spobfcd = ''	THEN
	f_message_chk(30,'[원부재명]')		
	dw_detail.SetColumn("pobfcd")
	dw_detail.SetFocus()
	RETURN -1
END IF

///////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	sitnbr = dw_insert.GetItemString(lrow, "itnbr")
	IF IsNull(sitnbr) 	or   sitnbr = ''	THEN
		f_message_chk(30,'[품번]')		
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("itnbr")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	dQty = dw_insert.GetItemDecimal(lRow, "lcqty")
	IF IsNull(dQty) or dQty = 0	THEN
		f_message_chk(30,'[L/C 수량]')		
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("lcqty")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	dw_insert.SetItem(lRow, "polcno", sLcno)	
	
NEXT

RETURN 1
end function

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. Argument : None
		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=====================================================================*/
string	sLcno, sConfirm

sLcno = dw_detail.GetItemString(1, "polcno")

SELECT "POLCNO"
  INTO :sConfirm
  FROM "POLCHD"  
 WHERE ( "SABU" = :gs_sabu )		AND
 		 ( "POLCNO" = :sLcno )  ;
			
IF sqlca.sqlcode = 0 	then	
	f_message_chk(1, "")
	dw_detail.setcolumn("polcno")
	dw_detail.SetFocus()
	RETURN  -1 
END IF
RETURN  1

end function

public function integer wf_dupchk (long lrow, string balno, integer balseq, string scurr);long   lReturnRow
String sname

sname = balno + string(balseq)

lReturnRow = dw_insert.Find("schk = '"+sname+"' ", 1, dw_insert.RowCount())

if lrow = 99999999 then 
	IF (lReturnRow <> 0)		THEN
	
		f_message_chk(37,'[발주번호/항번]') 
		
		RETURN  -1
	END IF	
else
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		f_message_chk(37,'[발주번호/항번]') 
		
		RETURN  -1
	END IF	
end if


//통화단위 체크 => 첫번째면 체크 않고 두번째 이후 부터 첫번째 단위와 다르면 error 메세지
if dw_insert.RowCount() > 0 then 
   if dw_detail.GetItemString(1, 'pocurr') <> scurr then 
	   messagebox("확 인", "통화단위를 확인하세요!")
		return -1
	end if
end if
RETURN 1


end function

public function integer wf_mult_custom (string as_code, string as_gubun);//IF f_Mult_Custom(as_Code,as_Code,'9','','','','',as_Gubun) = -1	THEN	RETURN -1
//
//RETURN 1

string a_code, a_name, a_gubun, a_kwan_no, a_bnk_cd, a_acc1_cd, a_acc2_cd, a_proc_gbn
string spobfcd

spobfcd = Trim(dw_detail.GetItemString(1, 'pobfcd'))
If IsNull(spobfcd) Or spobfcd = '' Then spobfcd = a_code

a_code		= as_code
a_name		= spobfcd
a_gubun		= '9'
a_kwan_no	= ''
a_bnk_cd		= ''
a_acc1_cd	= ''
a_acc2_cd	= ''
a_proc_gbn	= as_gubun

/*-------- 경리거래처를 등록,수정,삭제처리하는 FUNCTION ---------------*/
/* ARGUMENT 해설                                                       */
/*   a_code     - 거래처코드(거래처  , 부서코드, 금융기관, L/C번호)    */
/*   a_name     - 거래처명  (거래처명, 부서명  , 은행명,   L/C번호)    */
/*   a_gubun    - 거래처구분(  '1'   ,   '3'   ,    '2',   '9'  )      */
/*   a_kwan_no  - 관리번호  (사업번호,   ''    ,    '' ,   ''   )      */
/*   a_bnk_cd   - 은행코드  (  ''    ,   ''    ,    '' ,   ''   )      */
/*   a_acc1_cd  - 계정코드  (  ''    ,   ''    ,    '' ,   ''   )      */
/*   a_acc2_cd  - 분류항목  (  ''    ,   ''    ,    '' ,   ''   )      */
/*   a_proc_gbn - 처리구분  (사용중지'97', 단종'98',삭제시 '99')       */
/***********************************************************************/

Integer iCount
String  sPerson_tx, sKwanNo

sKwanNo = a_kwan_no

/*처리구분이 삭제일때 상태코드를'2'로 갱신처리함 - 사용가능시'1'임*/
IF a_proc_gbn = '99' THEN
   UPDATE "KFZ04OM0"  
     SET "PERSON_STS" = '2',
	      "PERSON_TX"  = '삭제된코드임!'  
   WHERE ( "KFZ04OM0"."PERSON_CD" = :a_code ) AND  
         ( "KFZ04OM0"."PERSON_GU" = :a_gubun )   ;
ELSEIF a_proc_gbn = '98' OR a_proc_gbn = '97' THEN    //단종, 사용중지
   IF a_proc_gbn = '98' THEN	
	   sPerson_tx = '단종된코드임!'
	ELSE	
	   sPerson_tx = '사용중지코드임!'
   END IF
	
   SELECT Count("KFZ04OM0"."PERSON_CD")   		/*자료유무 체크*/
	  INTO :iCount
     FROM "KFZ04OM0"  
    WHERE ( "KFZ04OM0"."PERSON_CD" = :a_code ) AND ( "KFZ04OM0"."PERSON_GU" = :a_gubun );
	 
	IF SQLCA.SQLCODE = 100 then    //추가입력처리//
   	INSERT INTO "KFZ04OM0"  
      	( "PERSON_CD",		"PERSON_NM",		"PERSON_GU",	"PERSON_NO",	"PERSON_BNK", &
			  "PERSON_AC1",	"PERSON_CD2",		"PERSON_STS",	"PERSON_TX" )  
   	VALUES (:a_code,		:a_name,				:a_gubun,		:sKwanNo,		:a_bnk_cd,&
				  :a_acc1_cd,	:a_acc2_cd, 		'2',				:sPerson_tx )  ;
	ELSEIF SQLCA.SQLCODE = 0 AND iCount = 1 then  /*자료수정처리*/
	   UPDATE "KFZ04OM0"  
   	   SET "PERSON_NM"  = :a_name,   
             "PERSON_NO"  = :sKwanNo,
				 "PERSON_BNK" = :a_bnk_cd,
				 "PERSON_AC1" = :a_acc1_cd,
				 "PERSON_CD2" = :a_acc2_cd,
				 "PERSON_TX"  = :sPerson_tx,
				 "PERSON_STS" = '2'
		WHERE  ( "KFZ04OM0"."PERSON_CD" = :a_code ) AND ("KFZ04OM0"."PERSON_GU" = :a_gubun );
	ELSEIF SQLCA.SQLCODE = 0 AND iCount <= 0 THEN
		INSERT INTO "KFZ04OM0"  
      	( "PERSON_CD",		"PERSON_NM",		"PERSON_GU",	"PERSON_NO",	"PERSON_BNK", &
			  "PERSON_AC1",	"PERSON_CD2",		"PERSON_STS",	"PERSON_TX" )  
   	VALUES (:a_code,		:a_name,				:a_gubun,		:sKwanNo,		:a_bnk_cd,&
				  :a_acc1_cd,	:a_acc2_cd, 		'2',				:sPerson_tx )  ;
   END IF
ELSE
   SELECT Count("KFZ04OM0"."PERSON_CD")   		/*자료유무 체크*/
	   INTO :iCount
      FROM "KFZ04OM0"  
      WHERE ( "KFZ04OM0"."PERSON_CD" = :a_code ) AND ( "KFZ04OM0"."PERSON_GU" = :a_gubun );
	IF SQLCA.SQLCODE = 100 then    //추가입력처리//
   	INSERT INTO "KFZ04OM0"  
      	( "PERSON_CD",		"PERSON_NM",		"PERSON_GU",	"PERSON_NO",	"PERSON_BNK", &
			  "PERSON_AC1",	"PERSON_CD2",		"PERSON_STS",	"PERSON_TX" )  
   	VALUES (:a_code,		:a_name,				:a_gubun,		:sKwanNo,		:a_bnk_cd,&
				  :a_acc1_cd,	:a_acc2_cd, 		'1',				'' )  ;
	ELSEIF SQLCA.SQLCODE = 0 AND iCount = 1 then  /*자료수정처리*/
	   UPDATE "KFZ04OM0"  
   	   SET "PERSON_NM"  = :a_name,   
             "PERSON_NO"  = :sKwanNo,
				 "PERSON_BNK" = :a_bnk_cd,
				 "PERSON_AC1" = :a_acc1_cd,
				 "PERSON_CD2" = :a_acc2_cd,
				 "PERSON_TX"  = '',
				 "PERSON_STS" = '1'
		WHERE  ( "KFZ04OM0"."PERSON_CD" = :a_code ) AND ("KFZ04OM0"."PERSON_GU" = :a_gubun );
	ELSEIF SQLCA.SQLCODE = 0 AND iCount <= 0 THEN
		INSERT INTO "KFZ04OM0"  
      	( "PERSON_CD",		"PERSON_NM",		"PERSON_GU",	"PERSON_NO",	"PERSON_BNK", &
			  "PERSON_AC1",	"PERSON_CD2",		"PERSON_STS",	"PERSON_TX" )  
   	VALUES (:a_code,		:a_name,				:a_gubun,		:sKwanNo,		:a_bnk_cd,&
				  :a_acc1_cd,	:a_acc2_cd, 		'1',				'' )  ;
   END IF
END IF

IF SQLCA.SQLCODE = 0 THEN
   Return 1
ELSE
   Return -1
END IF
end function

public function integer wf_openchk (string sitnbr, integer lrow);string   get_no, get_tuncu, get_bank, get_cvcod, get_cvnm, get_pspec, get_saupj 
integer  iSeq, get_seq
dec		get_qty, get_lcoqty, get_prc, get_balqty, get_unamt
long		get_count

SELECT COUNT(*), 		 MAX(A.CVCOD),    MAX(A.PLNBNK),   MAX(B.BALJPNO),  MAX(B.BALSEQ), 
		 MAX(B.CNVQTY), MAX(B.LCOQTY),   MAX(B.CNVPRC),   MAX(B.TUNCU),    MAX(B.SAUPJ), MAX(B.BALQTY), MAX(UNAMT)
  INTO :get_count,    :get_cvcod,      :get_bank,       :get_no, 		  :get_seq, 
		 :get_qty,      :get_lcoqty,     :get_prc,        :get_tuncu,    :get_saupj, :get_balqty, :get_unamt
  FROM POMAST A, POBLKT B
 WHERE ( A.SABU = B.SABU ) and ( A.BALJPNO = B.BALJPNO ) and  
		 ( A.BAL_SUIP = '2' AND B.BALSTS = '1' AND 
			A.SABU = :gs_sabu AND B.ITNBR = :sitnbr AND 
			B.CNVQTY > B.LCOQTY ) ;

if get_count = 1 then 
	if wf_dupchk(lrow, get_no, get_seq, get_tuncu) = -1 then 
		return -1
	end if	
	dw_insert.setitem(lrow, 'baljpno', get_no)
	dw_insert.setitem(lrow, 'balseq',  get_seq)
	dw_insert.setitem(lrow, 'pspec', get_pspec)
	dw_insert.setitem(lrow, 'saupj', get_saupj)
	dw_insert.setitem(lrow, 'poblkt_cnvqty', get_qty )
	dw_insert.setitem(lrow, 'lcqty', get_qty - get_lcoqty)
	dw_insert.setitem(lrow, 'old_lcqty', 0)
	dw_insert.setitem(lrow, 'tot_lcqty', get_lcoqty)
	dw_insert.setitem(lrow, 'lcprc', get_prc)
	
	if lrow = 1 then 
		SELECT "VNDMST"."CVNAS2" INTO :get_cvnm  
		  FROM "VNDMST"  WHERE "VNDMST"."CVCOD" = :get_cvcod   ;
		
		dw_detail.setitem(1, 'buyer',  get_cvcod)
		dw_detail.setitem(1, 'buyer_name',  get_cvnm)
		dw_detail.setitem(1, 'pocurr', get_tuncu)
		if get_bank > '.' then 
			dw_detail.setitem(1, 'poopbk', get_bank)
		end if	
	end if
	
	//dw_insert.setitem(lrow, 'lcamt', ( get_qty - get_lcoqty ) * get_prc)
	dw_insert.setitem(lrow, 'lcamt', ( get_qty - get_lcoqty ) * (get_unamt / get_balqty))
	
   dw_detail.SetItem(1, 'polamt', dw_insert.GetItemDecimal(lRow, "tot_amt"))
elseif get_count > 1 then 
	gs_code = sitnbr
	open(w_poblkt_popup2)
	if gs_code = '' or isnull(gs_code) then 
		return 1
	else
		if wf_dupchk(lrow, gs_code, integer(gs_codename), gs_gubun) = -1 then 
			return -1
		end if	
		iseq = integer(gs_codename)
		
		dw_insert.setitem(lrow, 'baljpno', gs_code)
		dw_insert.setitem(lrow, 'balseq',  iseq)
		
	   SELECT A.CNVQTY,  A.LCOQTY,   A.CNVPRC, A.TUNCU,    B.PLNBNK,  B.CVCOD, A.PSPEC, A.SAUPJ
		  INTO :get_qty, :get_lcoqty, :get_prc, :get_tuncu, :get_bank, :get_cvcod, :get_pspec, 
		       :get_saupj
		  FROM POBLKT A, POMAST B  
		 WHERE ( A.SABU = B.SABU ) and ( A.BALJPNO = B.BALJPNO ) and  
				 (	A.SABU = :gs_sabu AND A.BALJPNO = :gs_code AND A.BALSEQ = :iseq ) ;
		
		if sqlca.sqlcode = 0 then 
			dw_insert.setitem(lrow, 'poblkt_cnvqty', get_qty )
			dw_insert.setitem(lrow, 'lcqty', get_qty - get_lcoqty)
			dw_insert.setitem(lrow, 'old_lcqty', 0)
			dw_insert.setitem(lrow, 'tot_lcqty', get_lcoqty)
			dw_insert.setitem(lrow, 'lcprc', get_prc)
			dw_insert.setitem(lrow, 'pspec', get_pspec)
			dw_insert.setitem(lrow, 'saupj', get_saupj)

			if lrow = 1 then 
				SELECT "VNDMST"."CVNAS2" INTO :get_cvnm  
				  FROM "VNDMST"  WHERE "VNDMST"."CVCOD" = :get_cvcod   ;
				
				dw_detail.setitem(1, 'buyer',  get_cvcod)
				dw_detail.setitem(1, 'buyer_name',  get_cvnm)
				dw_detail.setitem(1, 'pocurr', get_tuncu)
				if get_bank > '.' then 
					dw_detail.setitem(1, 'poopbk', get_bank)
				end if	
			end if
			
			//dw_insert.setitem(lrow, 'lcamt', ( get_qty - get_lcoqty ) * get_prc)
			dw_insert.setitem(lrow, 'lcamt', ( get_qty - get_lcoqty ) * (get_unamt / get_balqty))
		   dw_detail.SetItem(1, 'polamt', dw_insert.GetItemDecimal(lRow, "tot_amt"))
		else
			return -1
		end if	
	end if				
else
	f_message_chk(109,'[품번]')		
	return -1
end if	

return 1
end function

public subroutine wf_reset ();string   snull
integer  iNull
long		lRow

SetNull(sNull)
SetNull(iNull)

lRow  = dw_insert.GetRow()	

dw_insert.setitem(lrow, 'itnbr',   snull)
dw_insert.setitem(lrow, 'itdsc',   snull)
dw_insert.setitem(lrow, 'ispec',   snull)
dw_insert.setitem(lrow, 'ispec_code',   snull)
dw_insert.setitem(lrow, 'jijil',   snull)
dw_insert.setitem(lrow, 'pspec',   snull)
dw_insert.setitem(lrow, 'baljpno', snull)
dw_insert.setitem(lrow, 'balseq',  inull)
dw_insert.setitem(lrow, 'poblkt_cnvqty', 0)
dw_insert.setitem(lrow, 'lcqty',  0)
dw_insert.setitem(lrow, 'lcprc',  0)
dw_insert.setitem(lrow, 'lcamt',  0)

end subroutine

public subroutine wf_set_poblkt (string ar_baljpno);/////////////////////////////////////////////////////////////////////////////
//																									//	
//  L/C 내역을 체크후에 L/C에 자료가 없으면 발주자료를 조회하는 FUNTION    //  
//  만약 발주자료도 없으면 아무 처리 않하고 있으면 발주자료로 L/C에 셋팅   //  
//																									//	
/////////////////////////////////////////////////////////////////////////////
string  get_name, sbajno, stuncu, sbank 
long    lcount, k, lcurrow
int     icount, ibaseq
dec {3} dbalqty, doplcqty, dqty, dtot  
dec {5} dprice, dunamt

dtot = 0

SELECT A.SABU  
  INTO :get_name 
  FROM POMAST A  
 WHERE A.SABU    = :gs_sabu AND  A.BALJPNO = :ar_Baljpno   ;

If sqlca.sqlcode = 0 then 
	lcount = dw_hidden.retrieve(gs_sabu, ar_baljpno)
	
   FOR k = 1 TO lcount
		sbajno  = dw_hidden.getitemstring(k, 'pomast_baljpno')
		ibaseq  = dw_hidden.getitemnumber(k, 'poblkt_balseq')
		stuncu  = dw_hidden.getitemstring(k, 'poblkt_tuncu' )

		lcurrow = dw_insert.insertrow(0)
		dw_insert.setitem(lcurrow, 'baljpno', sbajno)
		dw_insert.setitem(lcurrow, 'balseq', ibaseq)
		dw_insert.setitem(lcurrow, 'itnbr', dw_hidden.getitemstring(k, 'poblkt_itnbr' ))
		dw_insert.setitem(lcurrow, 'saupj', dw_hidden.getitemstring(k, 'poblkt_saupj' ))
		dw_insert.setitem(lcurrow, 'itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lcurrow, 'ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lcurrow, 'jijil', dw_hidden.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lcurrow, 'ispec_code', dw_hidden.getitemstring(k, 'itemas_ispec_code' ))
		dw_insert.setitem(lcurrow, 'pspec', dw_hidden.getitemstring(k, 'poblkt_pspec' ))
		
		dbalqty  = dw_hidden.getitemdecimal(k, 'poblkt_cnvqty' )
		doplcqty = dw_hidden.getitemdecimal(k, 'poblkt_lcoqty' )
		dprice   = dw_hidden.getitemdecimal(k, 'poblkt_cnvprc' )
		dqty     = dbalqty - doplcqty 
		
		dw_insert.setitem(lcurrow, 'poblkt_cnvqty', dbalqty)
		dw_insert.setitem(lcurrow, 'lcqty', dqty)
		dw_insert.setitem(lcurrow, 'old_lcqty', 0)
		dw_insert.setitem(lcurrow, 'tot_lcqty', doplcqty)
		
		dw_insert.setitem(lcurrow, 'lcprc', dprice)
//		dw_insert.SetItem(lcurrow, "lcamt", dQty * dPrice)		// LC금액

		// 금액은 발주금액/발주수량 * 수량으로 재계산한다
		dw_insert.SetItem(lcurrow, "lcamt", dQty * (dw_hidden.getitemdecimal(k, 'unamt') / dbalqty))		// LC금액
		dtot = dtot + (dQty * dPrice)
		
		icount ++
		if icount = 1 then 
			dw_detail.setitem(1, 'pocurr', stuncu)
			dw_detail.setitem(1, 'buyer',  dw_hidden.getitemstring(k, 'pomast_cvcod' ))
			dw_detail.setitem(1, 'buyer_name', dw_hidden.getitemstring(k, 'vndmst_cvnas2' ))
			sBank =	dw_hidden.getitemstring(k, 'pomast_plnbnk' )
			if sbank > '.' then 
				dw_detail.setitem(1, 'poopbk', sbank)
			end if	
		end if
	NEXT
	
	// 일일환율 및 대미환산율 검색
	dec {5} dusdrat, drate
	string srdat
	srdat = dw_detail.getitemstring(1, "opndat")
	dusdrat = sqlca.erp000000090(srdat, stuncu, 1, '3', '', 'N');	// 대미환산율
	if dw_detail.getitemstring(1, "localyn") = 'Y' then
		drate = sqlca.erp000000090(srdat, stuncu, 1, '2', '3', 'N');	// local이면 매매기준환율
	else
		drate = sqlca.erp000000090(srdat, stuncu, 1, '2', '2', 'N');	// direct이면 전신환매도율
	end if	
	
	dw_detail.setitem(1, "usdrat", dusdrat)
	dw_detail.setitem(1, "lrate",  drate)
	dw_detail.accepttext()	
	
End if	

if dw_insert.rowcount() > 0 then
	dw_detail.SetItem(1, 'polamt', dw_insert.getitemdecimal(1, "tot_amt"))
end if

dw_detail.accepttext()

Return 

end subroutine

public subroutine wf_taborder ();dw_detail.SetTabOrder("polcno", 10)
dw_detail.SetColumn("polcno")
end subroutine

public subroutine wf_taborderzero ();dw_detail.SetTabOrder("polcno", 0)

end subroutine

public function integer wf_delete ();long	lRow, lRowCount

dw_detail.DeleteRow(0)

lRowCount = dw_insert.RowCount()

FOR  lRow = lRowCount 	TO	 1		STEP -1
	
	dw_insert.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public function integer wf_amend_history (string slcno);decimal {2} damt, damtb
string sdate, edate, sdateb, edateb, stoday
long amdno

stoday = f_today()

if p_del.enabled then  // 수정모드이면

	Select posdat, poedat, polamt
	  into :sdateb, :edateb, :damtb
	  from polchd
	 where sabu = :gs_sabu and polcno = :slcno;

	// S/D, E/D, L/C금액이 변경되지 않으면 작성하지 않는다.
	if sdate = sdateb AND edate = edateb and damt = damtb then
		return 1
	end if

	select max(amendno) into :amdno 
	  from polchd_amend
	 where sabu = :gs_sabu and polcno = :slcno;
	if isnull(amdno) then amdno = 0
	
	amdno++
	
	select posdat,  poedat,  polamt
	  into :sdateb, :edateb, :damtb
	  From polchd
	 where sabu = :gs_sabu and polcno = :slcno;
			 
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Amend History", "L/C내역 검색중 오류발생" + '~n' + &
											 sqlca.sqlerrtext, stopsign!)
		return -1
	end if
	
	sdate = dw_detail.getitemstring(1, "posdat")	
	edate = dw_detail.getitemstring(1, "poedat")
	damt  = dw_detail.getitemdecimal(1, "polamt")
	
	if sdate = sdateb then sdateb = ''
	if edate = edateb then edateb = ''
	if damt  = damtb  then damtb  = 0
	
	insert into polchd_amend 
			(sabu,			polcno,			amendno,			amenddate,		
			 polcsdb,		polcsda,			polcedb,			polceda,
			 polcamtb,		polcamta)
		values
			(:gs_sabu,		:slcno,			:amdno,			:stoday,
			 :sdateb,		:sdate,			:edateb,			:edate,
			 :damtb,			:damt);
			 
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Amend History", "Amend History작성중 오류발생" + '~n' + &
											 sqlca.sqlerrtext, stopsign!)
		return -1
	end if			 

else		// 입력모드이면
	sdate = dw_detail.getitemstring(1, "posdat")	
	edate = dw_detail.getitemstring(1, "poedat")
	damt  = dw_detail.getitemdecimal(1, "polamt")
	
	insert into polchd_amend 
			(sabu,			polcno,			amendno,			amenddate,		
			 polcsdb,		polcsda,			polcedb,			polceda,
			 polcamtb,		polcamta)
		values
			(:gs_sabu,		:slcno,			:amdno,			:stoday,
			 null,			:sdate,			null,				:edate,
			 0,				:damt);
			 
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Amend History", "Amend 기본내역 작성중 오류발생" + '~n' + &
											 sqlca.sqlerrtext, stopsign!)
		return -1
	end if
	
end if

return 1
end function

public subroutine wf_new ();ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)

decimal {4} dusdrat, drate
string  sdate

sdate = f_today()

dusdrat = sqlca.erp000000090(sdate, 'USD', 1, '3', '', 'N');	// 대미환산율
drate = sqlca.erp000000090(sdate, 'USD', 1, '2', '2', 'N');	// direct이면 전신환매도율
	
dw_detail.setitem(1, "usdrat", dusdrat)
dw_detail.setitem(1, "lrate",  drate)		

wf_TabOrder()

dw_detail.setredraw(true)
///////////////////////////////////////////////


dw_detail.enabled = true
dw_insert.enabled = true

p_mod.enabled = true
p_del.enabled = false
p_amend.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true
p_inq.enabled = true
p_ins.enabled = true

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"
p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"
p_amend.PictureName = "C:\erpman\image\amend_d.gif"
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_inq.PictureName = "C:\erpman\image\조회_up.gif"

//ib_ItemError  = true
ib_any_typing = false

dw_detail.SetFocus()

end subroutine

public subroutine wf_query ();w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()

dw_detail.SetFocus()

// button
p_mod.enabled = true
p_del.enabled = true
p_amend.enabled = true
//cb_insert.enabled = false

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"
p_amend.PictureName = "C:\erpman\image\amend_up.gif"

end subroutine

on w_imt_03020.create
int iCurrent
call super::create
this.p_amend=create p_amend
this.dw_detail=create dw_detail
this.dw_1=create dw_1
this.dw_hidden=create dw_hidden
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_amend
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_hidden
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.pb_4
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_4
end on

on w_imt_03020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_amend)
destroy(this.dw_detail)
destroy(this.dw_1)
destroy(this.dw_hidden)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :is_cnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(is_cnvgu) or Trim(is_cnvgu) = '' then
	is_cnvgu = 'N'
End if

if is_cnvgu = 'Y' then // 발주단위 사용시
	dw_1.dataobject = 'd_poblkt_popup3_3'
	dw_hidden.dataobject = 'd_imt_03020_hidden2'
Else						// 발주단위 사용안함
	dw_1.dataobject = 'd_poblkt_popup3'	
	dw_hidden.dataobject = 'd_imt_03020_hidden'
End if

dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_hidden.settransobject(sqlca)

is_Date = f_Today()

p_can.TriggerEvent("clicked")
end event

type dw_insert from w_inherite`dw_insert within w_imt_03020
integer x = 27
integer y = 796
integer width = 4571
integer height = 1512
integer taborder = 20
string dataobject = "d_imt_03021"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string   sitnbr, sitdsc, sispec, snull, sjijil, sispec_code
integer  ireturn, iNull
dec{3}	dLcQty, dBalQty, doldqty, dtotqty, dblqty, dprvdata, dQty, dAmt, dipqty
dec{5}	dPrice
dec {2}	  dBalRate
long		lRow

SetNull(sNull)
SetNull(iNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	if sitnbr ='' or isnull(sitnbr) then 
		wf_reset()
		return 
	end if	
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	IF ireturn = 0 then 
   	if wf_openchk(sitnbr, lrow) = -1 then 
         wf_reset()
			return 1
		end if	
	ELSE
		wf_reset()
	END IF
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	if sitdsc ='' or isnull(sitdsc) then 
		wf_reset()
		return 
	end if	
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	IF ireturn = 0 then 
   	if wf_openchk(sitnbr, lrow) = -1 then 
         wf_reset()
			return 1
		end if	
	ELSE
		wf_reset()
	END IF
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	if sispec ='' or isnull(sispec) then 
		wf_reset()
		return 
	end if	
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	IF ireturn = 0 then 
   	if wf_openchk(sitnbr, lrow) = -1 then 
         wf_reset()
			return 1
		end if	
	ELSE
		wf_reset()
	END IF
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	if sjijil ='' or isnull(sjijil) then 
		wf_reset()
		return 
	end if	
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	IF ireturn = 0 then 
   	if wf_openchk(sitnbr, lrow) = -1 then 
         wf_reset()
			return 1
		end if	
	ELSE
		wf_reset()
	END IF
	RETURN ireturn	
	
	
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sIspec_code = trim(this.GetText())
	if sispec_code ='' or isnull(sispec_code) then 
		wf_reset()
		return 
	end if	
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	IF ireturn = 0 then 
   	if wf_openchk(sitnbr, lrow) = -1 then 
         wf_reset()
			return 1
		end if	
	ELSE
		wf_reset()
	END IF
	RETURN ireturn	
	
// L/C수량 > 발주수량 -> ERROR
ELSEIF this.getcolumnname() = "lcqty" 	THEN
	dPrvdata = this.getitemdecimal(lRow, 'lcqty')
 	dLcqty 	= dec(this.GetText())
	dBalqty  = this.GetITemDecimal(lRow, "poblkt_cnvqty")
	doldqty  = this.GetITemDecimal(lRow, "old_lcqty")
	dtotqty  = this.GetITemDecimal(lRow, "tot_lcqty")

	dblqty   = this.GetITemDecimal(lRow, "polcdt_blqty")
	dipqty   = this.GetITemDecimal(lRow, "ipqty")

	this.AcceptText()

	dPrice = this.getitemdecimal(lRow, "lcprc")

	sItnbr = getitemstring(lrow, 'itnbr')
	SELECT BALRATE INTO :dbalrate FROM ITEMAS WHERE ITNBR = :sItnbr;
	if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100
	
	if dlcqty < truncate(dblqty * dBalRate / 100, 3) or dlcqty < dipqty  then
		f_message_chk(307, '[L/C수량]')
		this.setitem(Lrow, "lcqty", dPrvdata)
	   this.SetItem(lRow, "lcamt", dPrvdata * dPrice)		// LC금액
		return 1
	end if

 	IF dLcqty > truncate(dBalqty * dBalRate / 100, 3) - dtotqty + doldqty 		THEN
		MessageBox("확인", "L/C수량은 발주수량과 이미OPEN된 L/C수량보다 클 수 없습니다.")
		this.SetItem(lRow, "lcqty", dprvdata)
	   this.SetItem(lRow, "lcamt", dPrvdata * dPrice)		// LC금액
		RETURN 1
	END IF

   this.SetItem(lRow, "lcamt", dlcQty * dPrice)		// LC금액
   dw_detail.SetItem(1, 'polamt', this.GetItemDecimal(lRow, "tot_amt"))
	
ELSEIF this.getcolumnname() = "lcprc"		THEN

	this.AcceptText()

	dQty   = this.getitemdecimal(lRow, "lcqty") 
	dPrice = this.getitemdecimal(lRow, "lcprc")
	
   this.SetItem(lRow, "lcamt", dQty * dPrice)		// LC금액

   dw_detail.SetItem(1, 'polamt', this.GetItemDecimal(lRow, "tot_amt"))
END IF

end event

event dw_insert::itemerror;call super::itemerror;RETURN 1
end event

event dw_insert::losefocus;call super::losefocus;this.AcceptText()
end event

event dw_insert::rbuttondown;call super::rbuttondown;long	lRow

lRow  = this.GetRow()	

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
//ELSEIF this.GetColumnName() = "baljpno"	THEN
//	open(w_poblkt_popup)
//	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(lRow,"baljpno",gs_code)
//	this.SetItem(lRow,"balseq",integer(gs_codename))
//	
//	this.TriggerEvent(ItemChanged!)
END IF

end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type p_delrow from w_inherite`p_delrow within w_imt_03020
integer taborder = 70
end type

event p_delrow::clicked;call super::clicked;long	lrow, icount
string	sGubun, sPolcno

lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN
////////////////////////////////////////////////////////

sGubun = dw_detail.GetItemString(1, "pomaga")
sPolcno = dw_detail.GetItemString(1, "polcno")

IF sGubun = 'Y'	THEN
	MessageBox("확인", "완료처리된 L/C번호는 삭제할 수 없습니다.")
	RETURN 
END IF

if dw_insert.getitemstring(lrow, 'opt') = 'N' then
	MessageBox("확인", "B/L에 등록된 자료는 삭제할 수 없습니다!!")
	RETURN 
end if

if dw_insert.getitemstring(lrow, 'opt') = 'O' then
	MessageBox("확인", "입고에 등록된 자료는 삭제할 수 없습니다!!")
	RETURN 
end if

SELECT COUNT(*)  INTO :icount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POLCNO = :sPolcno   ;
IF icount > 0 then 
	MessageBox("확인", "수입비용이 등록된 L/C번호는 삭제할 수 없습니다.")
	RETURN 
END IF

IF f_msg_delete() = -1 THEN	RETURN

dw_insert.DeleteRow(lRow)

if dw_insert.rowcount() > 0 then 
	dw_detail.SetItem(1, 'polamt', dw_insert.GetItemDecimal(1, "tot_amt"))
else
	dw_detail.SetItem(1, 'polamt', 0)
end if

ib_any_typing = true
end event

type p_addrow from w_inherite`p_addrow within w_imt_03020
integer taborder = 60
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return


//////////////////////////////////////////////////////////
long		lRow
string  	sLcno

sLcno	= dw_detail.getitemstring(1, "polcno")

IF isnull(sLcno) or sLcno = "" 	THEN
	f_message_chk(30,'[L/C번호]')
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN
END IF

lRow = dw_insert.InsertRow(0)

//dw_insert.SetItem(lRow, "rdate", sStartDate)

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("baljpno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_imt_03020
boolean visible = false
integer x = 2144
integer y = 12
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03020
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

//////////////////////////////////////////////////////////
long	 k, lcurrow
string sopt, slcno, sbajno, stuncu, sbank
int	 iCount, ibaseq
dec{3} dqty, dbalqty, doplcqty, dunamt
dec{5} dprice

sLcno	= dw_detail.getitemstring(1, "polcno")

IF isnull(sLcno) or sLcno = "" 	THEN
	f_message_chk(30,'[L/C번호]')
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN
END IF

Setnull(gs_code)
open(w_poblkt_popup3)
if Isnull(gs_code) or Trim(gs_code) = "" then return
dw_1.reset()
dw_1.ImportClipboard()

FOR k=1 TO dw_1.rowcount()
	sopt = dw_1.getitemstring(k, 'opt')
	if sopt = 'Y' then 
		sbajno  = dw_1.getitemstring(k, 'baljpno')
		ibaseq  = dw_1.getitemnumber(k, 'poblkt_balseq')
		stuncu  = dw_1.getitemstring(k, 'poblkt_tuncu' )
		if wf_dupchk(99999999, sbajno, ibaseq, stuncu) = -1 then 
			continue 
		end if	

		lcurrow = dw_insert.insertrow(0)
		dw_insert.setitem(lcurrow, 'baljpno', sbajno)
		dw_insert.setitem(lcurrow, 'balseq', ibaseq)
		dw_insert.setitem(lcurrow, 'itnbr', dw_1.getitemstring(k, 'poblkt_itnbr' ))
		dw_insert.setitem(lcurrow, 'itdsc', dw_1.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lcurrow, 'ispec', dw_1.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lcurrow, 'pspec', dw_1.getitemstring(k, 'poblkt_pspec' ))
		dw_insert.setitem(lcurrow, 'jijil', dw_1.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lcurrow, 'saupj', dw_1.getitemstring(k, 'poblkt_saupj' ))
		
		if is_cnvgu = 'Y' then // 발주단위 사용시
			dbalqty  = dw_1.getitemdecimal(k, 'poblkt_cnvqty' )
			dprice   = dw_1.getitemdecimal(k, 'poblkt_cnvprc' )
		else
			dbalqty  = dw_1.getitemdecimal(k, 'poblkt_balqty' )
			dprice   = dw_1.getitemdecimal(k, 'poblkt_unprc' )
		end if
		
		dunamt  = dw_1.getitemdecimal(k, 'poblkt_unamt' )
		
		doplcqty = dw_1.getitemdecimal(k, 'poblkt_lcoqty' )
		dqty     = dbalqty - doplcqty 
		
		dw_insert.setitem(lcurrow, 'poblkt_cnvqty', dbalqty)
		dw_insert.setitem(lcurrow, 'lcqty', dqty)
		dw_insert.setitem(lcurrow, 'old_lcqty', 0)
		dw_insert.setitem(lcurrow, 'tot_lcqty', doplcqty)
		
		dw_insert.setitem(lcurrow, 'lcprc', dprice)
		
		dw_insert.setitem(lcurrow, 'lcamt', ( dqty ) * (dunamt / dbalqty))
//		dw_insert.SetItem(lcurrow, "lcamt", dQty * dPrice)		// LC금액
      
		icount ++
      if icount = 1 then 
   		dw_detail.setitem(1, 'pocurr', stuncu)
   		dw_detail.setitem(1, 'buyer', dw_1.getitemstring(k, 'cvcod' ))
   		dw_detail.setitem(1, 'buyer_name', dw_1.getitemstring(k, 'vndmst_cvnas2' ))
         sBank =	dw_1.getitemstring(k, 'pomast_plnbnk' )
			if sbank > '.' then 
	   		dw_detail.setitem(1, 'poopbk', sbank)
			end if	
      end if
		
      dw_detail.SetItem(1, 'polamt', dw_insert.GetItemDecimal(1, "tot_amt"))
	end if	
NEXT
dw_1.reset()
dw_insert.ScrollToRow(lcurrow)
dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()

// 일일환율 및 대미환산율 검색
dec {5} dusdrat, drate
string srdat
srdat = dw_detail.getitemstring(1, "opndat")
dusdrat = sqlca.erp000000090(srdat, stuncu, 1, '3', '', 'N');	// 대미환산율
if dw_detail.getitemstring(1, "localyn") = 'Y' then
	drate = sqlca.erp000000090(srdat, stuncu, 1, '2', '3', 'N');	// local이면 매매기준환율
else
	drate = sqlca.erp000000090(srdat, stuncu, 1, '2', '2', 'N');	// direct이면 전신환매도율
end if	

dw_detail.setitem(1, "usdrat", dusdrat)
dw_detail.setitem(1, "lrate",  drate)
dw_detail.accepttext()

ib_any_typing = true
end event

type p_exit from w_inherite`p_exit within w_imt_03020
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_imt_03020
integer taborder = 100
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

wf_New()

dw_insert.Reset()


end event

type p_print from w_inherite`p_print within w_imt_03020
boolean visible = false
integer x = 2309
integer y = 16
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03020
integer x = 3054
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sLcno,		&
			sDate,		&
			sNull
SetNull(sNull)

sLcno	= dw_detail.getitemstring(1, "polcno")

IF isnull(sLcno) or sLcno = "" 	THEN
	f_message_chk(30,'[L/C번호]')
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, sLcno) < 1	THEN
	f_message_chk(50, '[L/C번호]')
	dw_detail.setcolumn("POLCNO")
	dw_detail.setfocus()
	ib_any_typing = false
   p_can.TriggerEvent(Clicked!)
	RETURN
END IF

dw_detail.SetRedraw(True)

IF dw_insert.Retrieve(gs_Sabu, sLcno) > 0 then 
   wf_bl_chk()
END IF

wf_Query()
dw_detail.SetFocus()

//////////////////////////////////////////////////////////////////////////
//	* 마감된 '구매L/C' 자료는 삭제할 수 없음
// * Direct인 경우 B/L  내역이 있는 경우에는 수정할 수 없음
// * Local 인 경우 입고 내역이 있는 경우에는 수정할 수 없음
//////////////////////////////////////////////////////////////////////////
string	sGubun 

sGubun 	= dw_detail.GetItemString(1, "pomaga")

IF sGubun = 'Y' THEN 
	w_mdi_frame.sle_msg.text  = '완료처리된 자료는 수정할 수 없읍니다.'	
	dw_detail.enabled = false	
	dw_insert.enabled = false	
	
	p_mod.enabled = false	
	p_del.enabled = false	
	p_addrow.enabled = false	
	p_delrow.enabled = false	
	p_amend.enabled = false	
	p_ins.enabled = false

	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_addrow.PictureName = "C:\erpman\image\행추가_d.gif"
	p_delrow.PictureName = "C:\erpman\image\행삭제_d.gif"
	p_ins.PictureName    = "C:\erpman\image\추가_d.gif"
	p_amend.PictureName = "C:\erpman\image\amend_d.gif"
	
END IF
dw_insert.setcolumn('lcqty')
dw_insert.setfocus()

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_imt_03020
integer taborder = 90
end type

event p_del::clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
int      k, icount
string	sGubun, sPolcno

if dw_detail.accepttext() = -1 then return 

sGubun  = dw_detail.GetItemString(1, "pomaga")
sPolcno = dw_detail.GetItemString(1, "polcno")

IF sGubun = 'Y'	THEN
	MessageBox("확인", "완료처리된 L/C번호는 삭제할 수 없습니다.")
	RETURN 
END IF

FOR k=1 TO dw_insert.rowcount()
   if dw_insert.getitemstring(k, 'opt') = 'N' then
		MessageBox("확인", "B/L에 등록된 자료는 삭제할 수 없습니다!!")
		RETURN 
	end if
   if dw_insert.getitemstring(k, 'opt') = 'O' then
		MessageBox("확인", "입고에 등록된 자료는 삭제할 수 없습니다!!")
		RETURN 
	end if	
NEXT

SELECT COUNT(*)  INTO :icount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POLCNO = :sPolcno   ;
IF icount > 0 then 
	MessageBox("확인", "수입비용이 등록된 L/C번호는 삭제할 수 없습니다.")
	RETURN 
END IF

//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
dw_detail.setredraw(false)

IF wf_Delete() = -1		THEN
	dw_detail.setredraw(true)
	RETURN
END IF
//////////////////////////////////////////////////////////////////
IF dw_detail.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
	dw_detail.setredraw(true)
	RETURN
END IF

IF dw_insert.Update() > 0		THEN
	IF wf_mult_custom(sPolcno, '99') = -1	THEN		
		ROLLBACK USING sqlca;
		F_ROLLBACK()
		dw_detail.setredraw(true)
		Return
	End If	
	Delete from polchd_amend where sabu = :gs_sabu and polcno = :spolcno;
	if sqlca.sqlcode <> 0 then 
		ROLLBACK USING sqlca;
		F_ROLLBACK()
		dw_detail.setredraw(true)
		Return	
	end if
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

wf_New()

dw_insert.Reset()
	
dw_detail.setredraw(true)

	

end event

type p_mod from w_inherite`p_mod within w_imt_03020
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 
	messagebox("확 인", "L/C 품목정보를 입력 후 자료를 저장하십시요!")
	RETURN 
END IF
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN

string	sPolcno

sPolcno = dw_detail.GetItemString(1, "polcno")

IF	wf_CheckRequiredField() = -1		THEN	RETURN

// 신규등록시 L/C번호 확인
IF ic_status = '1'	THEN

	IF wf_Confirm_Key() = -1	THEN	RETURN

END IF

// 발주자료를 확인하여 현재L/C의 자료와 LOCAL여부가 같지않으면 ERROR처리
Long lrow
string slocalyn, slcyn, sbaljpno

w_mdi_frame.sle_msg.text  = 'Local여부를 확인중입니다'

slcyn = dw_detail.getitemstring(1, "localyn")
For lrow = 1 to dw_insert.rowcount()
	
	 sbaljpno = dw_insert.getitemstring(lrow, "baljpno")
	 Select localyn into :slocalyn from pomast
	  where sabu = :gs_sabu And baljpno = :sbaljpno;
	
	 if isnull(slocalyn) then // null인 경우에는 skip
	 elseif slocalyn <> slcyn then
		 Messagebox("Local구분", "L/C의 Local구분과 발주의 Local구분이 일치하지 않읍니다",stopsign!)
		 w_mdi_frame.sle_msg.text = ''		 
		 dw_insert.setrow(Lrow)
		 dw_insert.setfocus()
		 return
	 end if
	
Next
w_mdi_frame.sle_msg.text  = ''
/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

// amend history생성
IF wf_amend_history(spolcno) = -1	THEN		
	Return
End If		

IF dw_detail.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

IF dw_insert.Update() > 0		THEN
	IF wf_mult_custom(spolcno, '1') = -1	THEN		
		ROLLBACK USING sqlca;
		F_ROLLBACK()
		Return
	End If	
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

ib_any_typing = false

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_imt_03020
end type

type cb_mod from w_inherite`cb_mod within w_imt_03020
end type

type cb_ins from w_inherite`cb_ins within w_imt_03020
end type

type cb_del from w_inherite`cb_del within w_imt_03020
end type

type cb_inq from w_inherite`cb_inq within w_imt_03020
end type

type cb_print from w_inherite`cb_print within w_imt_03020
end type

type st_1 from w_inherite`st_1 within w_imt_03020
end type

type cb_can from w_inherite`cb_can within w_imt_03020
end type

type cb_search from w_inherite`cb_search within w_imt_03020
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03020
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03020
end type

type p_amend from uo_picture within w_imt_03020
integer x = 3227
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string picturename = "C:\erpman\image\amend_up.gif"
end type

event clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

openwithparm(w_imt_03020_1, dw_detail.getitemstring(1, "polcno"))

if gs_codename = 'Y' then  // amend내역을 수정한 경우

	ib_any_typing = false
	
	MessageBox("취소", "현재의 내용은 자동으로 취소됩니다", stopsign!)
	
	p_can.triggerevent(clicked!)
	
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\amend_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\amend_up.gif'
end event

type dw_detail from datawindow within w_imt_03020
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 27
integer y = 204
integer width = 4571
integer height = 548
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03020"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;string	sDate, 			&
			sCode, sName,	srdat, &
			sNull

decimal {2} dRate
decimal {4} dusdrat			
			
SetNull(sNull)

this.accepttext()

// L/C No
IF this.GetColumnName() = 'polcno' THEN

	sCode  = trim(this.gettext())

	if scode = '' or isnull(scode) then return 

	SELECT "POLCHD"."POLCNO"  
     INTO :sName  
     FROM "POLCHD"  
    WHERE ( "POLCHD"."SABU" = :gs_sabu ) AND  
          ( "POLCHD"."POLCNO" = :scode )   ;

	IF sqlca.sqlcode = 0 THEN
		p_inq.TriggerEvent(Clicked!)
	   return 1
	ELSE
		wf_set_poblkt(scode)
   END IF	
// L/C 구분
elseIF this.GetColumnName() = 'polcgu' THEN

	sCode  = trim(this.gettext())
	// 일일환율 검색
	sname = getitemstring(1, "pocurr")	
	// OpeN일자가 있는 경우 Open일자를 기준으로 하고 없으면 현재일자를 기준으로 한다.
	srdat = getitemstring(1, "opndat")
	if isnull(srdat) or trim(srdat) = '' then
		srdat = f_today()
	end if

	if scode = '' or isnull(scode) then return 

	if scode = '2' or scode = '3' then
		setitem(1, "localyn", 'Y')
		drate = sqlca.erp000000090(srdat, sname, 1, '2', '3', 'N');	// local이면 매매기준환율		
	else
		setitem(1, "localyn", 'N')		
		drate = sqlca.erp000000090(srdat, sname, 1, '2', '2', 'N');	// direct이면 전신환매도율		
	end if
	
	setitem(1, "lrate",  drate)		
	
// 선적예정일(S/D)
ELSEIF this.GetColumnName() = 'posdat' THEN

	sDate  = trim(this.gettext())

	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[S/D]')
		this.setitem(1, "posdat", sNull)
		return 1
	END IF
	
// 구매 L/C 유효일자(E/D)
ELSEIF this.GetColumnName() = 'poedat' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[E/D]')
		this.setitem(1, "poedat", sNull)
		return 1
	END IF
	
// 구매 L/C 부보일자
ELSEIF this.GetColumnName() = 'bubo_date' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[부보일자]')
		this.setitem(1, "bubo_date", sNull)
		return 1
	END IF
	
// OPEN일자
ELSEIF this.GetColumnName() = 'opndat' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[OPEN 일자]')
		this.setitem(1, "opndat", sNull)
		return 1
	END IF
	
	// OpeN일자가 있는 경우 Open일자를 기준으로 하고 없으면 현재일자를 기준으로 한다.
	scode = getitemstring(1, "pocurr")	
	srdat = getitemstring(1, "opndat")
	if isnull(srdat) or trim(srdat) = '' then
		srdat = f_today()
	end if		
	
	// 일일환율 및 대미환산율 검색

	dusdrat = sqlca.erp000000090(srdat, scode, 1, '3', '', 'N');	// 대미환산율
	if getitemstring(1, "localyn") = 'Y' then
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '3', 'N');	// local이면 매매기준환율
	else
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '2', 'N');	// direct이면 전신환매도율
	end if	
	
	setitem(1, "usdrat", dusdrat)
	setitem(1, "lrate",  drate)		
	
////////////////////////////////////////////////////////////////////////////
// 1. OPEN BANK
// 2. 은행별 보증한도금액 CHECK
/////////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "poopbk" THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then	return 

   SELECT CVNAS
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode  AND	 CVGU = '3'  AND	 CVSTATUS = '0';

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[OPEN 은행]')
		this.setitem(1, 'poopbk', sNull)
	   return 1
   END IF
	
   SELECT BANKCD
     INTO :sName
     FROM POBANK
    WHERE BANKCD = :sCode;

	IF sqlca.sqlcode = 100 	THEN
		INSERT INTO POBANK ( SABU, BANKCD, CNFDAT)
		 VALUES(:gs_sabu, :scode, to_char(sysdate,'YYYYMMDD') );
		 COMMIT;
//		MessageBox('확 인','은행을 확인하세요. 금융등록후 처리 하세요!')
//		this.setitem(1, 'poopbk', sNull)
//	   return 1
   END IF

// buyer
ELSEIF this.GetColumnName() = "buyer" THEN
	
	sCode = this.GetText()								
	if scode = '' or isnull(scode) then
		this.setitem(1, 'buyer_name', sNull)
		return 
	end if

   SELECT CVNAS
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode 	AND CVSTATUS = '0' ;

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[BUYER]')
		this.setitem(1, 'buyer', sNull)
		this.setitem(1, 'buyer_name', sNull)
	   return 1
	ELSE
		this.setitem(1, 'buyer_name', sName)
   END IF
	
// 통화단위
ELSEIF this.GetColumnName() = 'pocurr' THEN

	sCode = this.gettext()
	
	if scode = '' or isnull(scode) then return 

  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[통화단위]')
		this.setitem(1, "pocurr", sNull)
		return 1
	end if
	
	// OpeN일자가 있는 경우 Open일자를 기준으로 하고 없으면 현재일자를 기준으로 한다.
	srdat = getitemstring(1, "opndat")
	if isnull(srdat) or trim(srdat) = '' then
		srdat = f_today()
	end if		
	
	// 일일환율 및 대미환산율 검색

	dusdrat = sqlca.erp000000090(srdat, scode, 1, '3', '', 'N');	// 대미환산율
	if getitemstring(1, "localyn") = 'Y' then
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '3', 'N');	// local이면 매매기준환율
	else
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '2', 'N');	// direct이면 전신환매도율
	end if
	
	setitem(1, "usdrat", dusdrat)
	setitem(1, "lrate",  drate)	
	
// Local여부
ELSEIF this.GetColumnName() = 'localyn' THEN	
	
	// 일일환율 및 대미환산율 검색
	sname = this.gettext()
	scode = getitemstring(1, "pocurr")
	
	// OpeN일자가 있는 경우 Open일자를 기준으로 하고 없으면 현재일자를 기준으로 한다.
	srdat = getitemstring(1, "opndat")
	if isnull(srdat) or trim(srdat) = '' then
		srdat = f_today()
	end if	

	dusdrat = sqlca.erp000000090(srdat, scode, 1, '3', '', 'N');	// 대미환산율
	if sname = 'Y' then
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '3', 'N');	// local이면 매매기준환율
	else
		drate = sqlca.erp000000090(srdat, scode, 1, '2', '2', 'N');	// direct이면 전신환매도율
	end if
	
	setitem(1, "usdrat", dusdrat)
	setitem(1, "lrate",  drate)		
	
END IF


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;string sname

gs_gubun = ''
gs_code  = ''
gs_codename = ''

// lc번호
IF this.GetColumnName() = 'polcno'	THEN
   IF MessageBox("선 택", "발주정보를 조회 하시겠습니까?", Exclamation!, YesNo!, 2) = 1 THEN 
		Open(w_pomast_popup)
		if Isnull(gs_code) or Trim(gs_code) = "" then return
		THIS.SetItem(1,"polcno",		gs_code)
		wf_set_poblkt(Gs_code)
   ELSE
		Open(w_lc_popup)
		if Isnull(gs_code) or Trim(gs_code) = "" then return
		THIS.SetItem(1,"polcno",		gs_code)
		p_inq.TriggerEvent(Clicked!)
	END IF

// BUYER
ELSEIF this.GetColumnName() = 'buyer'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"buyer",		gs_code)
	SetItem(1,"buyer_name", gs_codename)
	
END IF


end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_1 from datawindow within w_imt_03020
boolean visible = false
integer x = 837
integer y = 2540
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_poblkt_popup3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_hidden from datawindow within w_imt_03020
boolean visible = false
integer x = 1403
integer y = 2528
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03020_hidden"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_imt_03020
integer x = 2587
integer y = 276
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('opndat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'opndat', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03020
integer x = 2587
integer y = 360
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('bubo_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'bubo_date', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_03020
integer x = 2587
integer y = 444
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('posdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'posdat', gs_code)



end event

type pb_4 from u_pb_cal within w_imt_03020
integer x = 4087
integer y = 428
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('poedat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'poedat', gs_code)



end event

type rr_3 from roundrectangle within w_imt_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 184
integer width = 4590
integer height = 588
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 788
integer width = 4590
integer height = 1532
integer cornerheight = 40
integer cornerwidth = 55
end type

