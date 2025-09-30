$PBExportHeader$w_imt_03000.srw
$PBExportComments$외자발주검토
forward
global type w_imt_03000 from window
end type
type sle_bal from singlelineedit within w_imt_03000
end type
type st_2 from statictext within w_imt_03000
end type
type cb_bom from commandbutton within w_imt_03000
end type
type cb_cancel from commandbutton within w_imt_03000
end type
type cb_1 from commandbutton within w_imt_03000
end type
type pb_3 from picturebutton within w_imt_03000
end type
type pb_4 from picturebutton within w_imt_03000
end type
type pb_2 from picturebutton within w_imt_03000
end type
type pb_1 from picturebutton within w_imt_03000
end type
type dw_2 from datawindow within w_imt_03000
end type
type dw_1 from datawindow within w_imt_03000
end type
type cb_balju from commandbutton within w_imt_03000
end type
type dw_detail from datawindow within w_imt_03000
end type
type dw_datetime from datawindow within w_imt_03000
end type
type cb_save from commandbutton within w_imt_03000
end type
type st_message_text from statictext within w_imt_03000
end type
type cb_exit from commandbutton within w_imt_03000
end type
type cb_retrieve from commandbutton within w_imt_03000
end type
type sle_message_line from statictext within w_imt_03000
end type
type gb_2 from groupbox within w_imt_03000
end type
type gb_4 from groupbox within w_imt_03000
end type
type gb_1 from groupbox within w_imt_03000
end type
type gb_6 from groupbox within w_imt_03000
end type
type gb_3 from groupbox within w_imt_03000
end type
type dw_estima from datawindow within w_imt_03000
end type
type dw_list from datawindow within w_imt_03000
end type
end forward

global type w_imt_03000 from window
integer width = 3657
integer height = 2408
boolean titlebar = true
string title = "외자 발주 검토"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
sle_bal sle_bal
st_2 st_2
cb_bom cb_bom
cb_cancel cb_cancel
cb_1 cb_1
pb_3 pb_3
pb_4 pb_4
pb_2 pb_2
pb_1 pb_1
dw_2 dw_2
dw_1 dw_1
cb_balju cb_balju
dw_detail dw_detail
dw_datetime dw_datetime
cb_save cb_save
st_message_text st_message_text
cb_exit cb_exit
cb_retrieve cb_retrieve
sle_message_line sle_message_line
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_6 gb_6
gb_3 gb_3
dw_estima dw_estima
dw_list dw_list
end type
global w_imt_03000 w_imt_03000

type variables
boolean ib_ItemError, ib_any_typing
char ic_status
string is_Last_Jpno

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_cnvart             // 변환계수연산자
String     is_gubun             //변환계수사용구분
String     ls_auto                //자동채번여부


string is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_balju_qty ()
public function integer wf_move ()
public function integer wf_checkrequiredfield ()
public function integer wf_cust ()
public subroutine wf_setdate ()
public function integer wf_balju_create (long al_row, string as_baldate, decimal ad_seq, string as_cust)
end prototypes

public function integer wf_balju_qty ();string	sSort
long		lRow, last_row
dec		dJego_Qty

if dw_list.Accepttext() = -1	then 	return -1

last_row = 	dw_list.RowCount()

FOR lRow = 1	TO	last_row 

	sSort = dw_list.GetITemString(lRow, "sort")
	
	CHOOSE CASE sSort
	CASE '01','02','03','04','05'
		  dw_list.setitem(lrow, "prior_jego", dw_list.GetITemDecimal(lRow, "iw_qty"))
	CASE '1'
	
		dJego_Qty = dw_list.GetITemDecimal(lRow, "iw_qty")	   	// 현재고대신 월재고로 
		dw_list.SetItem(lRow, "prior_jego", dJego_Qty)				// 이월재고
																					// 재고 -> 다음레코드의 이월재고
		dw_list.SetItem(lRow, "jego", dJego_Qty + 						&
							 dw_list.GetItemDecimal(lRow, "tot_notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "balju_qty") -	&
							 dw_list.GetItemDecimal(lRow,	"yyyymm") -	&
							 dw_list.GetItemDecimal(lRow, "nextmonth"))						

	CASE '2', '3','4','5'
		dw_list.SetItem(lRow, "prior_jego", dw_list.GetItemDecimal(lRow - 1,"jego"))	// 이월재고 = 전레코드의 재고
																					// 재고 -> 다음레코드의 이월재고
		dw_list.SetItem(lRow, "jego", 											&
							 dw_list.GetItemDecimal(lRow, "prior_jego") +	&				 
							 dw_list.GetItemDecimal(lRow, "notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "balju_qty") -	&
							 dw_list.GetItemDecimal(lRow, "nextmonth"))						

	END CHOOSE
	
NEXT

RETURN 1
end function

public function integer wf_move ();string	sCust, sItem, sMoney, snadate, sbidate, sgub, sDepot_no, ssaupj
dec{5}	dBalQty, dPrice, dCnvfat
long		lRow, lRow_Estima, lCount

dw_detail.Accepttext() 

lCount = dw_list.RowCount()

sDepot_no  = dw_detail.getitemstring(1, "depot_no")

select ipjogun
  into :ssaupj
  from vndmst 
 where cvcod = :sdepot_no ;

FOR lRow = 1	TO	lCount
	
	dBalQty = dw_list.GetItemDecimal(lRow, "balju")
	sCust	= dw_list.GetItemSTring(lRow, "cust")
	sItem	= dw_list.GetItemString(lRow, "itnbr")
	
	// 발주확정량이 있을 경우 -> 발주예정생성
	IF dBalQty <= 0	THEN		CONTINUE

	IF IsNull(sCust)	or	sCust = ''	THEN
		f_message_chk(30, '[거래처]')
		dw_list.SetColumn("cust")
		dw_list.SetFocus()
		RETURN -1
	END IF

	// 
	lRow_Estima = dw_estima.InsertRow(0)

	dPrice = 0
	SetNull(sMoney)
	
	// 단가, 통화단위(단가마스타)
  SELECT "DANMST"."UNPRC",   
         "DANMST"."CUNIT"  
    INTO :dPrice,   
         :sMoney  
    FROM "DANMST"  
   WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
         ( "DANMST"."CVCOD" = :sCust ) AND
			( "DANMST"."OPSEQ" = '9999' ) ;
			
	IF IsNull(dPrice)		THEN	dPrice = 0

   snadate = dw_list.GetITemString(lRow, "indate")
   sbidate = dw_list.GetITemString(lRow, "bidate")

   if snadate < sbidate then 
		sgub = '2' //추가
   else
		sgub = '1' //정규 
	end if
	
	dw_estima.SetItem(lRow_Estima, "cvcod", sCust)
	dw_estima.SetItem(lRow_Estima, "cvnas", dw_list.GetITemString(lRow, "custname"))
	dw_estima.SetItem(lRow_Estima, "nadat", snadate)
	
	//전표번호 생성시 월별 거래처별 sort시 필요  
	dw_estima.SetItem(lRow_Estima, "mnadat", left(snadate,6))
	dw_estima.SetItem(lRow_Estima, "bigu", sgub)   //정규 추가 구분

	dw_estima.SetItem(lRow_Estima, "itnbr", sItem)
	dw_estima.SetItem(lRow_Estima, "itdsc", dw_list.GetITemString(lRow, "itdsc"))
	dw_estima.SetItem(lRow_Estima, "ispec", dw_list.GetITemString(lRow, "ispec"))
	dw_estima.SetItem(lRow_Estima, "jijil", dw_list.GetITemString(lRow, "jijil"))
	dw_estima.SetItem(lRow_Estima, "ispec_code", dw_list.GetITemString(lRow, "ispec_code"))
	dw_estima.SetItem(lRow_Estima, "balqty", dBalQty)
	dw_estima.SetItem(lRow_Estima, "unprc",  dPrice)
	dw_estima.SetItem(lRow_Estima, "tuncu",  sMoney)
	dw_estima.SetItem(lRow_Estima, "plnopn", dw_list.GetITemString(lRow, "opendate"))
	dw_estima.SetItem(lRow_Estima, "ipdpt",  sDepot_no)
	dw_estima.SetItem(lRow_Estima, "saupj",  ssaupj	)

	
	// 변환계수에 의한 수량 
	
	// 품목마스터의 conversion factor를 검색
	dCnvfat = 1
	Select nvl(cnvfat, 1)
	  into :dCnvfat
	  From Itemas
	 Where itnbr = :sItem;
	 
	If isnull(dCnvfat) or dCnvfat = 0 or is_gubun = 'N' then
		dCnvfat = 1
	end if

	if dCnvfat = 1 then
		dw_estima.setitem(Lrow_Estima, "cnvart", '*')
	else
		dw_estima.setitem(Lrow_Estima, "cnvart", is_cnvart)
	end if
	
	dw_estima.setitem(Lrow_Estima, "cnvfat", dCnvfat)
		
	// 변환계수 변환에 따른 내역 변경(수량, 단가, 금액)
	if dCnvfat = 1 then
		dw_Estima.setitem(Lrow_Estima, "cnvqty", dBalqty)
	elseif dw_estima.getitemstring(Lrow_Estima, "cnvart") = '/' then
		dw_Estima.setitem(Lrow_Estima, "cnvqty", Round(dBalqty / dCnvfat, 3))
	else
		dw_Estima.setitem(Lrow_Estima, "cnvqty", Round(dBalqty * dCnvfat, 3))
	end if

	if dPrice > 0 and dBalqty > 0 then
		if dCnvfat = 1  then
			dw_Estima.setitem(Lrow_Estima, "cnvprc", dPrice)		
		elseif dw_estima.getitemstring(Lrow_Estima, "cnvart") = '/' then
			dw_Estima.setitem(Lrow_Estima, "cnvprc", Round(dPrice * dCnvfat, 5))
		else
			dw_Estima.setitem(Lrow_Estima, "cnvprc", Round(dPrice / dCnvfat, 5))
		end if
	else
		dw_Estima.setitem(Lrow_Estima, "cnvprc", 0)
	end if	
	
NEXT

dw_estima.SetSort("nadat A, cvcod A")
dw_estima.Sort()

RETURN 1
end function

public function integer wf_checkrequiredfield ();long		lRow, lCount
string	sdepot
dec      dunprc
///////////////////////////////////////////////////////////////////////

lcount = dw_estima.RowCount()

FOR	lRow = 1		TO	lcount	

	sdepot = trim(dw_estima.GetItemString(lRow, "nadat"))
	IF (IsNull(sdepot) or sdepot = '' )	THEN
		f_message_chk(30,'[납기예정일]')
		dw_estima.SetFocus()
		RETURN -1
	END IF
	
	sdepot = dw_estima.GetItemString(lRow, "ipdpt")
	IF (IsNull(sdepot) or sdepot = '' )	THEN
		f_message_chk(30,'[입고예정창고]')		
		dw_estima.SetColumn("ipdpt")
		dw_estima.SetRow(lRow)
		dw_estima.SetFocus()
		RETURN -1
	END IF
	
	dunprc = dw_estima.GetItemDecimal(lRow, "unprc")
	IF IsNull(dunprc) or dunprc = 0	THEN
		f_message_chk(30,'[단가]')		
		dw_estima.SetColumn("unprc")
		dw_estima.SetRow(lRow)
		dw_estima.SetFocus()
		RETURN -1
	END IF

	sdepot = dw_estima.GetItemString(lRow, "tuncu")
	IF (IsNull(sdepot) or sdepot = '' )	THEN
		f_message_chk(30,'[통화단위]')		
		dw_estima.SetColumn("tuncu")
		dw_estima.SetRow(lRow)
		dw_estima.SetFocus()
		RETURN -1
	END IF

	sdepot = trim(dw_estima.GetItemString(lRow, "plnopn"))
	IF (IsNull(sdepot) or sdepot = '' )	THEN
		f_message_chk(30,'[OPEN  예정일]')
		dw_estima.SetFocus()
		RETURN -1
	END IF
	
NEXT


RETURN 1
end function

public function integer wf_cust ();string	sCust, sCustName,		&
			sItem, sYearMonth,	&
			sGubun, smoney
long		lRow, lCount
dec      dprice, drate 
sYearMonth = dw_detail.GetItemString(1, "yyyymm")

lCount = dw_list.RowCount()

FOR lRow = 1	TO		lCount
	
	sItem = dw_list.GetItemString(lRow, "itnbr")
	sGubun = dw_list.GetItemString(lRow, "sort")
	
	IF sGubun = '01'	THEN
		sCust = '' 
		sCustName = ''
      dprice = 0
		smoney = ''
		drate  = 0
		
		SELECT A.MTRVND, B.CVNAS
		  INTO :sCust, :sCustName
		  FROM MTRPLN_SUM A, VNDMST B
		 WHERE A.SABU = :gs_sabu	AND
				 A.MTRVND = B.CVCOD 	AND
				 A.ITNBR = :sItem		AND
				 A.MTRYYMM = :sYearMonth	AND
				 ROWNUM = 1 ;
		
		IF scust = '' or isnull(scust) then 
			SELECT CVCOD, FUN_GET_CVNAS(CVCOD) INTO :scust, :scustname 
			  FROM DANMST 
			 WHERE ITNBR = :sItem and OPSEQ = '9999' AND SLTCD = 'Y' and rownum = 1 ;
		END IF	
			
		  SELECT "DANMST"."UNPRC", "DANMST"."CUNIT", "DANMST"."STDRATE"  
			 INTO :dPrice, :sMoney, :dRate  
			 FROM "DANMST"  
			WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
					( "DANMST"."CVCOD" = :sCust ) AND
					( "DANMST"."OPSEQ" = '9999' ) ;
	END IF
		dw_list.SetItem(lRow, "cust", 	 sCust)
		dw_list.SetItem(lRow, "custname", sCustName)
		dw_list.SetItem(lRow, "custname2", sCustName)
		dw_list.SetItem(lRow, "danamt", 	 dPRice)
		dw_list.SetItem(lRow, "drate", 	 drate)
		dw_list.SetItem(lRow, "unit",     smoney)
	
NEXT

RETURN 1
end function

public subroutine wf_setdate ();string	sItem, sYearMonth, sdate, sSort
long		lRow, lCount
double   get_qty, get_dqty
int      i_ldtim, icount, k, iplus

sYearMonth = dw_detail.GetItemString(1, "yyyymm")

lCount =	dw_list.RowCount() 

FOR lRow = 1	TO	 lCount
	
	sSort = dw_list.GetItemString(lRow, "sort")

	If sSort = '1' then 
		sItem = dw_list.GetItemString(lRow, "itnbr")
		
		SELECT "ITEMAS"."LDTIM"  
		  INTO :i_Ldtim  
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :sItem   ;
		//리드타임을 읽어서 없으면 계속 다음 작업
		//리드타임에 한달(30일)기준으로 나눠 정수로 만든 후 그안에 월에는 납기일자가 15 setting
		if i_ldtim = 0 or isnull(i_ldtim) then i_ldtim = 1 
		
		icount = ceiling( i_ldtim / 30 ) 
		
		if icount > 5 then icount = 5 

		iplus = 0
		FOR k = lRow TO lRow + 4
			sdate = dw_list.getitemstring(k, "month")

			dw_list.SetItem(k, "opendate", 	 sdate + '07')
			
			iplus++
			
			if icount >= iplus then  
				dw_list.SetItem(k, "indate", 	 sdate + '15')
			else
				dw_list.SetItem(k, "indate", 	 sdate + '20')
			end if					
		NEXT
	ElseIf sSort = '01' then 
		sItem = dw_list.GetItemString(lRow, "itnbr")
		//기준월 이전 미입고량(어느 시점에서나 변경되지 않은 량) 
		SELECT NVL(SUM(NVL(A.BALQTY,0)) - SUM(NVL(IOQTY,0)), 0) 
	     INTO :get_qty
		  FROM POBLKT A,
             (SELECT SABU, BALJPNO, BALSEQ, SUM(NVL(IOSUQTY,0)) AS IOQTY
                FROM IMHIST 
               WHERE SABU    = :gs_sabu
					  AND ITNBR   = :sitem
					  AND PSPEC   = '.'            
                 AND IO_DATE < :sYearMonth 
            GROUP BY SABU, BALJPNO, BALSEQ)B
		 WHERE A.SABU  = :gs_sabu	  AND
				 A.ITNBR = :sitem      AND 
				 A.PSPEC =  '.'        AND 
				 A.BALSTS = '1'        AND /* 발주구분이 정상인 내역만 집계 */
				 A.NADAT < :sYearMonth AND 
             A.SABU = B.SABU(+)    AND  
             A.BALJPNO = B.BALJPNO(+) AND 
             A.BALSEQ = B.BALSEQ(+)    ;
				 
		// 당월 입고량(입고 수량 기준)
	  SELECT SUM(IOSUQTY)  
	    INTO :get_dqty
		 FROM IMHIST  
		WHERE ( SABU = :gs_sabu    ) AND  
				( IO_DATE >= :sYearMonth||'01' ) AND  
				( IO_DATE <= :sYearMonth||'31' ) AND  
				( ITNBR = :sItem      ) AND  
				( PSPEC =  '.'        ) AND
				( POBLNO > '.' )  ;
				
		FOR k = lRow TO lRow + 9
			dw_list.SetItem(k, "tot_notinqty", 	 get_qty)
			dw_list.SetItem(k, "cur_inqty", 	    get_dqty)
		NEXT
   End if
NEXT

RETURN 
end subroutine

public function integer wf_balju_create (long al_row, string as_baldate, decimal ad_seq, string as_cust);string	sItem,	&
			sEmpno,	&
			sGubun,	&
			sConfirm
long		lRow

sItem = dw_estima.GetItemString(al_Row, "itnbr")

// 결재조건
  SELECT "VNDMST"."RCVMG", "VNDMST"."EMP_ID"      
    INTO :sConfirm, :sEmpno  
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :as_Cust   ;

//거래처에 구매담당자가 없을 경우 DEFAULT 값 가져오기
If sempno ='' or isnull(sempno) then 

   SELECT "SYSCNFG"."DATANAME"    
	  INTO :sempno
     FROM "SYSCNFG"  
    WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
          ( "SYSCNFG"."SERIAL" = 14 ) AND  
          ( "SYSCNFG"."LINENO" = '1' )   ;
			 
End if

lRow = dw_1.InsertRow(0)

dw_1.SetItem(lRow, "sabu", 	gs_sabu)
dw_1.SetItem(lRow, "baljpno", as_baldate + string(ad_Seq, '0000'))
dw_1.SetItem(lRow, "balgu",	'1')
dw_1.SetItem(lRow, "baldate", is_Today)
dw_1.SetItem(lRow, "cvcod",	as_Cust)
dw_1.SetItem(lRow, "bal_empno", sEmpno)
dw_1.SetItem(lRow, "bal_suip", '2')
dw_1.SetItem(lRow, "plnopn",  dw_estima.GetItemString(al_Row, "plnopn"))
dw_1.SetItem(lRow, "plnbnk",  dw_estima.GetItemString(al_Row, "plnbnk"))

IF Right(dw_estima.GetItemString(al_Row, "nadat"), 2) = '15'	THEN
	sGubun = '2'	// 추가
ELSE
	sGubun = '1'	// 정규
END IF

dw_1.SetItem(lRow, "plncrt", sGubun)
dw_1.SetItem(lRow, "plnapp", sConfirm)

RETURN  1
end function

event open;is_window_id = Message.StringParm	
is_today = f_today()
is_totime = f_totime()

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

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

///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 구매의뢰 -> 발주확정 연산자를 환경설정에서 검색함 */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '4';
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
is_cnvart = sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

is_gubun = sCnvgu

/* 발주번호 자동채번여부를 환경설정에서 검색함 */
select dataname
  into :ls_auto
  from syscnfg
 where sysgu = 'S' and serial = 6 and lineno = '60';
 
If isNull(ls_auto) or Trim(ls_auto) = '' then
	ls_auto = 'Y'
End if

if ls_auto = 'Y' then 
	sle_bal.Visible = false
	st_2.Visible = false
end if

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_estima.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_datetime.insertrow(0)

IF f_change_name('1') = 'Y' then 
	is_pspec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_list.object.ispec_t.text = is_pspec
	dw_list.object.jijil_t.text = is_jijil
END IF

cb_cancel.TriggerEvent("clicked")


end event

on w_imt_03000.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.sle_bal=create sle_bal
this.st_2=create st_2
this.cb_bom=create cb_bom
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_balju=create cb_balju
this.dw_detail=create dw_detail
this.dw_datetime=create dw_datetime
this.cb_save=create cb_save
this.st_message_text=create st_message_text
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.sle_message_line=create sle_message_line
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_6=create gb_6
this.gb_3=create gb_3
this.dw_estima=create dw_estima
this.dw_list=create dw_list
this.Control[]={this.sle_bal,&
this.st_2,&
this.cb_bom,&
this.cb_cancel,&
this.cb_1,&
this.pb_3,&
this.pb_4,&
this.pb_2,&
this.pb_1,&
this.dw_2,&
this.dw_1,&
this.cb_balju,&
this.dw_detail,&
this.dw_datetime,&
this.cb_save,&
this.st_message_text,&
this.cb_exit,&
this.cb_retrieve,&
this.sle_message_line,&
this.gb_2,&
this.gb_4,&
this.gb_1,&
this.gb_6,&
this.gb_3,&
this.dw_estima,&
this.dw_list}
end on

on w_imt_03000.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_bal)
destroy(this.st_2)
destroy(this.cb_bom)
destroy(this.cb_cancel)
destroy(this.cb_1)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_balju)
destroy(this.dw_detail)
destroy(this.dw_datetime)
destroy(this.cb_save)
destroy(this.st_message_text)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.sle_message_line)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_6)
destroy(this.gb_3)
destroy(this.dw_estima)
destroy(this.dw_list)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  


end event

type sle_bal from singlelineedit within w_imt_03000
event ue_key pbm_keydown
integer x = 2693
integer y = 116
integer width = 265
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_key;//if key = KeyEnter! then
//	cb_mod.setfocus()
//end if
end event

event modified;//string sBaljpno, sNull
//LonG   lCount
//
//setnull(snull)
//
//sBaljpno = trim(this.text)
//
//  SELECT COUNT(*)
//    INTO :lCount
//    FROM POMAST  
//   WHERE SABU    =    '1'   
//     AND BALJPNO LIKE :sBaljpno||'%' ;
//
//IF lCount > 0 THEN
//	MessageBox("확 인", "등록된 발주번호입니다. 생성할 발주번호를 확인하세요!")
//	this.text = sNull
//	return 1
//END IF	
//
end event

type st_2 from statictext within w_imt_03000
integer x = 2633
integer y = 52
integer width = 407
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "생성 발주번호 "
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_bom from commandbutton within w_imt_03000
integer x = 1065
integer y = 1968
integer width = 567
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM 역전개(&B)"
end type

event clicked;if dw_detail.Accepttext() = -1	then 	return
if dw_list.rowcount() < 1 then return 

string  	sYearMonth

sYearMonth = TRIM(dw_detail.getitemstring(1, "yyyymm"))

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[기준년월]')
	dw_detail.SetColumn("yyyymm")
	dw_detail.SetFocus()
	RETURN
END IF

gs_gubun = sYearMonth

gs_code = dw_list.getitemstring(dw_list.getrow(), 'itnbr')

open(w_imt_03000_popup)

end event

type cb_cancel from commandbutton within w_imt_03000
integer x = 2779
integer y = 1968
integer width = 370
integer height = 108
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;string get_depot

IF cb_cancel.TEXT = '이전(&C)' THEN 
   cb_bom.enabled = true
   cb_save.enabled = true
   cb_balju.enabled = false
	dw_list.visible = true
	dw_estima.visible = false
	cb_cancel.TEXT = '취소(&C)'
	dw_estima.Reset()
	RETURN 
END IF

dw_1.Reset()
dw_2.Reset()

dw_list.Reset()
dw_detail.Reset()

dw_detail.InsertRow(0)
dw_detail.SetItem(1, "yyyymm", Mid(is_Today,1,6)) 

SELECT MIN("VNDMST"."CVCOD")  
  INTO :get_depot
  FROM "VNDMST"  
 WHERE ( "VNDMST"."CVGU" = '5' ) AND  
		 ( "VNDMST"."SOGUAN" = '3' ) AND  
		 ( "VNDMST"."JUMAECHUL" = '2' )   ;
		 
dw_detail.SetItem(1, "depot_no", get_depot) 
dw_detail.SetColumn("yyyymm")
dw_detail.SetFocus()

cb_save.enabled = false
cb_balju.enabled = false
cb_bom.enabled = false

dw_list.visible = true
dw_estima.visible = false

end event

type cb_1 from commandbutton within w_imt_03000
integer x = 475
integer y = 1968
integer width = 567
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "발주서 출력(&P)"
end type

event clicked;open(w_imt_03650)
end event

type pb_3 from picturebutton within w_imt_03000
integer x = 3447
integer y = 84
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\last.gif"
end type

event clicked;dw_list.scrolltorow(999999999)
dw_list.setcolumn('balju')
dw_list.setfocus()
end event

type pb_4 from picturebutton within w_imt_03000
integer x = 3333
integer y = 84
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
end type

event clicked;dw_list.scrollnextpage()

dw_list.SetRow(dw_list.getrow() + 6)

dw_list.setcolumn('balju')

dw_list.setfocus()
end event

type pb_2 from picturebutton within w_imt_03000
integer x = 3218
integer y = 84
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
end type

event clicked;dw_list.scrollpriorpage()

dw_list.setcolumn('balju')

dw_list.setfocus()

//long priorrow
//
//dw_list.ScrollPriorRow()
//dw_list.ScrollPriorRow()
//dw_list.ScrollPriorRow()
//dw_list.ScrollPriorRow()
//dw_list.ScrollPriorRow()

//dw_list.setfocus()
//
//priorrow = dw_list.getrow() - 10
//
//dw_list.scrolltorow(priorrow)
//	
end event

type pb_1 from picturebutton within w_imt_03000
integer x = 3104
integer y = 84
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;dw_list.scrolltorow(6)
dw_list.setcolumn('balju')
dw_list.setfocus()

end event

type dw_2 from datawindow within w_imt_03000
boolean visible = false
integer x = 686
integer y = 2428
integer width = 494
integer height = 360
boolean titlebar = true
string title = "발주품목정보"
string dataobject = "d_imt_03004"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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

type dw_1 from datawindow within w_imt_03000
boolean visible = false
integer x = 105
integer y = 2420
integer width = 494
integer height = 360
boolean titlebar = true
string title = "발주일반정보"
string dataobject = "d_imt_03003"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_balju from commandbutton within w_imt_03000
integer x = 2217
integer y = 1968
integer width = 443
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "발주확정"
end type

event clicked;////////////////////////////////////////////////////////////////////////////
//  * 정규/추가구분, 납기월, 거래처가 틀릴 경우 발주번호 채번
////////////////////////////////////////////////////////////////////////////
string	sCust, sOldCust, sOldyymm, syymm, soldgu, sgub, sBaldate, sAccod, sItnbr 
long		lRow, lRow_Bal
dec		dSeq
int		iCount, iReturn

IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF sBaldate = '' or isnull(sBaldate) THEN 
		MessageBox("확 인", "생성할 발주번호를 입력하세요!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = f_today()
END IF

iReturn = Messagebox('확 인','발주확정 처리를 하시겠습니까?',Question!,YesNo!,1) 

IF iReturn <> 1 THEN
   Return 
END IF

dw_1.Reset()	// 발주일반정보
dw_2.Reset()	// 발주품목정보

IF wf_CheckRequiredField() = -1	THEN	RETURN

sOldCust = ' '
sOldyymm = ' '
sOldgu   = ' '

dw_estima.SetSort("mnadat A, cvcod A, bigu D")
dw_estima.Sort()

FOR  lRow = 1	TO	 dw_estima.RowCount()

	sCust = dw_estima.GetItemString(lRow, "cvcod")
	syymm = dw_estima.GetItemString(lRow, "mnadat")
	sgub  = dw_estima.GetItemString(lRow, "bigu")
	
	IF sCust <>	sOldCust	or syymm <> sOldyymm	or sgub <> soldgu THEN
		
		dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sBaldate, 'K0')
		wf_Balju_Create(lRow, sBaldate, dSeq, sCust)
		iCount = 0
		
	END IF

	iCount++
	// 발주품목정보작성
	lRow_Bal = dw_2.InsertRow(0)
	dw_2.SetItem(lRow_Bal, "sabu", 		gs_sabu)
	dw_2.SetItem(lRow_Bal, "baljpno",	sBaldate + string(dSeq, '0000'))
	dw_2.SetItem(lRow_Bal, "balseq",		iCount)
	
	sItnbr = dw_estima.GetItemString(lRow, "itnbr")
	dw_2.SetItem(lRow_Bal, "itnbr",		sItnbr)

	dw_2.SetItem(lRow_Bal, "opseq",		'9999')
	dw_2.SetItem(lRow_Bal, "gudat",		dw_estima.GetItemString(lRow, "nadat"))
	dw_2.SetItem(lRow_Bal, "nadat",		dw_estima.GetItemString(lRow, "nadat"))
	dw_2.SetItem(lRow_Bal, "balqty",		dw_estima.GetItemDecimal(lRow, "balqty"))
	dw_2.SetItem(lRow_Bal, "balsts",		'1')			// 발주상태 = '정상'
	dw_2.SetItem(lRow_Bal, "sayeo",		'N')
	dw_2.SetItem(lRow_Bal, "fnadat",		dw_estima.GetItemString(lRow, "nadat"))
	dw_2.SetItem(lRow_Bal, "tuncu",		dw_estima.GetItemString(lRow, "tuncu"))
	dw_2.SetItem(lRow_Bal, "unprc",		dw_estima.GetItemDecimal(lRow, "unprc"))
	dw_2.SetITem(lRow_Bal, "unamt",		dw_estima.GetItemDecimal(lRow, "balqty") *	&
													dw_estima.GetItemDecimal(lRow, "unprc"))
	dw_2.SetItem(lRow_Bal, "ipdpt",     dw_estima.GetItemString(lRow, "ipdpt"))
	dw_2.SetItem(lRow_Bal, "saupj",     dw_estima.GetItemString(lRow, "saupj"))
	
	// 변환내역저장
	dw_2.setitem(Lrow_Bal, "cnvfat",    dw_estima.GetItemdecimal(lRow, "cnvfat"))
	dw_2.setitem(Lrow_Bal, "cnvart", 	dw_estima.GetItemString(lRow, "cnvart"))
	dw_2.setitem(Lrow_Bal, "cnvqty", 	dw_estima.GetItemdecimal(lRow, "cnvqty"))
	dw_2.setitem(Lrow_Bal, "cnvprc", 	dw_estima.GetItemdecimal(lRow, "cnvprc"))
	dw_2.setitem(Lrow_Bal, "cnvamt", 	dw_estima.GetItemdecimal(lRow, "cnvprc") * &
													dw_estima.GetItemdecimal(lRow, "cnvqty"))	
													
   //매입계정코드 가져오기
	sAccod = SQLCA.FUN_GET_ITNACC(sItnbr, '4');   
	dw_2.setitem(Lrow_Bal, "accod",  sAccod )	

	sOldCust = sCust
	sOldYymm = syymm
	sOldGu = sgub
	
NEXT


IF dw_1.Update() <= 0	THEN
	ROLLBACK;
	f_RollBack()
	RETURN 
END IF

IF dw_2.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_RollBack()
	RETURN
END IF

MessageBox("확인", "발주완료 되었습니다.")

cb_cancel.TriggerEvent(Clicked!)

RETURN 

end event

type dw_detail from datawindow within w_imt_03000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 36
integer width = 2615
integer height = 180
integer taborder = 10
string dataobject = "d_imt_03000"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;
gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'item'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"item",gs_code)
	SetItem(1,"itdsc", gs_codename)

ELSEIF this.GetColumnName() = 'item2'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"item2",gs_code)
	SetItem(1,"itdsc2", gs_codename)

ELSEIF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	
	open(w_vndmst_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"cvcod",gs_code)
	SetItem(1,"cvnm",gs_codename)

END IF
end event

event itemerror;RETURN 1
end event

event itemchanged;string	sDate, sNull, scvcod, scvnm
int      ireturn 

SetNull(sNull)

IF this.GetColumnName() = 'yyyymm' THEN

	sDate  = trim(this.gettext()) 
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "yyyymm", sNull)
		return 1
	END IF

ELSEIF this.GetColumnName() = 'cvcod'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('V1', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"cvcod",scvcod)
	SetItem(1,"cvnm", scvnm)
	RETURN ireturn 
ELSEIF this.GetColumnName() = 'item'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품번', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"item",scvcod)
	SetItem(1,"itdsc", scvnm)
	RETURN ireturn 	
ELSEIF this.GetColumnName() = 'item2'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품번', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"item2",scvcod)
	SetItem(1,"itdsc2", scvnm)
	RETURN ireturn 		
ELSEIF this.GetColumnName() = 'itdsc'	THEN
	scvnm  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품명', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"item",scvcod)
	SetItem(1,"itdsc", scvnm)
	RETURN ireturn 			
ELSEIF this.GetColumnName() = 'itdsc2'	THEN
	scvnm  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품명', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"item2",scvcod)
	SetItem(1,"itdsc2", scvnm)
	RETURN ireturn
END IF
end event

type dw_datetime from datawindow within w_imt_03000
integer x = 2862
integer y = 2120
integer width = 759
integer height = 108
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type cb_save from commandbutton within w_imt_03000
integer x = 1746
integer y = 1968
integer width = 443
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "발주검토"
end type

event clicked;if dw_list.AcceptText() = -1 then return 

dw_list.visible = false
dw_estima.visible = true
//dw_estima.Reset()

// 발주검토예정
IF wf_Move() = -1		THEN	
	dw_list.visible = true
	dw_estima.visible = false
	RETURN
END IF

IF dw_estima.RowCount() > 0	THEN
	cb_balju.enabled = true
ELSE
	f_message_chk(50,'[발주검토내역]')
	dw_list.visible = true
	dw_estima.visible = false
	RETURN
END IF

cb_cancel.TEXT = '이전(&C)'
cb_save.enabled = false
cb_bom.enabled = false

end event

type st_message_text from statictext within w_imt_03000
integer x = 18
integer y = 2120
integer width = 347
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_imt_03000
event key_in pbm_keydown
integer x = 3173
integer y = 1968
integer width = 370
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_imt_03000
integer x = 82
integer y = 1968
integer width = 370
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;
dw_list.visible = true
dw_estima.visible = false

if dw_detail.Accepttext() = -1	then 	return

string  	sYearMonth,	 sItemFrom,	sItemTo,   sDepot_no, sCvcod,	 &
			sPriorMonth[0 to 9], 	sNextMonth[0 to 4]
int		iSeq[0 to 9],	iCount

sYearMonth = dw_detail.getitemstring(1, "yyyymm")
sDepot_no  = dw_detail.getitemstring(1, "depot_no")
sCvcod     = dw_detail.getitemstring(1, "cvcod")

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[기준년월]')
	dw_detail.SetColumn("yyyymm")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sDepot_no) or sDepot_no = "" 	THEN
	IF Messagebox('확 인', '창고를 입력하지 않으면 현재고가 전체창고 수량입니다.' &
	                       +"~n"+ +  '계속 진행 하시겠습니까?',Question!,YesNo!,1)  = 2 THEN
		Return 
	END IF
	sDepot_no = 'ALL'
END IF

dw_list.setredraw(false)

SetPointer(HourGlass!)

sItemFrom = dw_detail.GetITemString(1, "item")
sItemTo	 = dw_detail.GetITemString(1, "item2")

IF IsNull(sItemFrom)	or	Trim(sItemFrom) = ''		THEN	sItemFrom = '.'
IF IsNull(sItemTo)	or	Trim(sItemTo) = ''		THEN	sItemTo = 'zzzzzzzzzzzzzzz'

// 9개월 전
sPriorMonth[0] = sYearMonth
FOR iCount = 1		TO		9

		sPriorMonth[iCount] = f_PriorMonth(sPriorMonth[iCount -1])
	
NEXT

// 4개월 후
sNextMonth[0] = sYearMonth
FOR iCount = 1		TO		4

		sNextMonth[iCount] = f_NextMonth(sNextMonth[iCount -1])
	
NEXT


///////////////////////////////////////////////////////////////////////////
// 9개월 전 -> 최대계획차수
///////////////////////////////////////////////////////////////////////////

FOR iCount = 0		TO		9
	
	int	iMaxSeq
	
	  SELECT Max("MRSEQ")  
	    INTO :iMaxSeq  
    	 FROM "MTRPLN_SUM"  
   	WHERE ( "SABU" = :gs_Sabu ) AND  
      	   ( "MTRYYMM" = :sPriorMonth[iCount] )   ;

	IF	IsNull(iMaxSeq)	THEN	iMaxSeq = 0
	iSeq[iCount] = iMaxSeq

NEXT

dw_list.setfilter("")
//////////////////////////////////////////////////////////////////////////////
IF dw_list.Retrieve( gs_Sabu, sItemFrom, sItemTo,	sdepot_no,  & 
            sPriorMonth[9], sPriorMonth[8], sPriorMonth[7], sPriorMonth[6], sPriorMonth[5], &
			   sPriorMonth[4], sPriorMonth[3], sPriorMonth[2], sPriorMonth[1], sYearMonth,	&
				sNextMonth[1],  sNextMonth[2],  sNextMonth[3],  sNextMonth[4],		&
				iSeq[9], iSeq[8], iSeq[7], iSeq[6], iSeq[5],  &
				iSeq[4], iSeq[3], iSeq[2], iSeq[1], iSeq[0] )  < 1		THEN
	dw_detail.SetColumn("yyyymm")
	dw_detail.SetFocus()
	cb_bom.enabled = FALSE
	cb_save.enabled = FALSE	
	dw_list.setredraw(true)
	RETURN
END IF
						
wf_Cust()

if scvcod > '.' then 
	dw_list.setfilter("cust = '"+ scvcod +" '")
end if	
dw_list.filter()

wf_setdate()

wf_Balju_Qty() 

dw_list.setredraw(true)
dw_list.SetFocus()

cb_bom.enabled = true
cb_save.enabled = true
end event

type sle_message_line from statictext within w_imt_03000
integer x = 370
integer y = 2120
integer width = 2491
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_imt_03000
integer x = 3058
integer width = 530
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_imt_03000
integer x = 32
integer width = 3017
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_imt_03000
integer x = 27
integer y = 1900
integer width = 1655
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type gb_6 from groupbox within w_imt_03000
integer x = 1691
integer y = 1900
integer width = 1024
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_imt_03000
integer x = 2725
integer y = 1900
integer width = 869
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type dw_estima from datawindow within w_imt_03000
boolean visible = false
integer x = 27
integer y = 232
integer width = 3557
integer height = 1688
integer taborder = 30
string dataobject = "d_imt_03002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_imt_03000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 232
integer width = 3561
integer height = 1688
integer taborder = 20
string dataobject = "d_imt_03001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;RETURN 1
end event

event itemchanged;long		lRow, ireturn 
string	sDate, sCode, sName, sNull, sName2
SetNull(sNull)

lRow = this.GetRow()

// 납기일자
IF this.GetColumnName() = 'indate' THEN

	sDate  = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 

	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[납기일자]')
		this.setitem(lRow, "indate", sNull)
		return 1
	END IF

END IF

// open 
IF this.GetColumnName() = 'opendate' THEN

	sDate  = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[OPEN예정일]')
		this.setitem(lRow, "opendate", sNull)
		return 1
	END IF

END IF

// 
IF this.GetcolumnName() = 'cust'	THEN
	
	sCode = this.GetText()								
	if scode = '' or isnull(scode) then
   	this.setitem(lRow, "custname", snull)	
		return 
	end if
	
	ireturn = f_get_name2('V1', 'Y', sCode, sName, sName2)    //1이면 실패, 0이 성공	
	this.setitem(lRow, "cust", scode)	
	this.setitem(lRow, "custname", sname)	
	RETURN ireturn
	
END IF

end event

event rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

long	lRow
lRow = this.GetRow()

IF this.GetColumnName() = 'cust'	THEN
   gs_code = this.getitemstring(lrow, 'itnbr')
	gs_codename = '9999'   
	Open(w_danmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow, "cust",		gs_code)
	
	SELECT "VNDMST"."CVNAS2"  
     INTO :gs_codename  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :gs_code   ;
	
	SetItem(lRow, "custname",  gs_codename)

END IF

end event

