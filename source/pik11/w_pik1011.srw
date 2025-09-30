$PBExportHeader$w_pik1011.srw
$PBExportComments$** 개인별 월간 일근태 수정
forward
global type w_pik1011 from w_inherite_standard
end type
type dw_2 from u_d_select_sort within w_pik1011
end type
type st_2 from statictext within w_pik1011
end type
type pb_4 from picturebutton within w_pik1011
end type
type pb_3 from picturebutton within w_pik1011
end type
type pb_2 from picturebutton within w_pik1011
end type
type pb_1 from picturebutton within w_pik1011
end type
type cb_1 from commandbutton within w_pik1011
end type
type cb_calc from commandbutton within w_pik1011
end type
type gb_5 from groupbox within w_pik1011
end type
type rr_1 from roundrectangle within w_pik1011
end type
type rr_2 from roundrectangle within w_pik1011
end type
type dw_1 from u_key_enter within w_pik1011
end type
type dw_3 from u_d_select_sort within w_pik1011
end type
type rb_2 from radiobutton within w_pik1011
end type
type rb_1 from radiobutton within w_pik1011
end type
type gb_4 from groupbox within w_pik1011
end type
end forward

global type w_pik1011 from w_inherite_standard
integer height = 2476
string title = "월간 일근태 수정"
boolean resizable = false
dw_2 dw_2
st_2 st_2
pb_4 pb_4
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
cb_1 cb_1
cb_calc cb_calc
gb_5 gb_5
rr_1 rr_1
rr_2 rr_2
dw_1 dw_1
dw_3 dw_3
rb_2 rb_2
rb_1 rb_1
gb_4 gb_4
end type
global w_pik1011 w_pik1011

type variables
Boolean  Ib_DetailFlag = False
string   ls_dkdeptcode,sYearMonthDay_From,sFlag , &
         sYearMonthDay_To
Double   dYkTime		

String print_gu                 //window가 조회인지 인쇄인지  

String    is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false

String    is_empno
String	 is_timegbn

end variables

forward prototypes
public subroutine wf_calc_htime (integer ll_currow, string skmgubn, string sjikgbn, ref double dhyjtime, ref double dhcytime, ref double dhkltime)
public subroutine wf_calc_jhtime (integer ll_currow, string skmgubn, ref double djhtime)
public subroutine wf_calc_jktime (integer ll_currow, string skmgubn, ref double djktime)
public subroutine wf_calc_jttime (integer ll_currow, string skmgubn, ref double djttime)
public subroutine wf_calc_kltime (integer ll_currow, string skmgubn, string sjikgubn, string sjhgbn, ref double dkltime)
public subroutine wf_calc_octime (integer ll_currow, string skmgubn, ref double doctottime, ref double docsiltime)
public subroutine wf_calc_yjtime (integer ll_currow, string skmgubn, ref double dyjtime)
public subroutine wf_calc_yktime (integer ll_currow, string skmgubn, ref double dykgtime)
public function integer wf_check_remainday (integer icurrow, string sempno, string sktdate, string scode, string sflag1)
public function double wf_conv_hhmm (double dtime)
public function integer wf_enabled_chk (string syearmonth)
public subroutine wf_get_cttime (string skmgbn, ref long lcktime, ref long ltktime)
public function double wf_get_hangtime (double dfrom, double dto, string skmgubn, string skhgubn)
public subroutine wf_init_clear (integer ll_currow, string ls_addgubn)
public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck)
public function string wf_proceduresql (string sempno)
public subroutine wf_reset ()
public subroutine wf_set_sqlsyntax (string sdate, string sdept)
public subroutine wf_taborder (string stag)
public function double wf_use_time (double dfromtime, double dtotime, string sflags)
end prototypes

public subroutine wf_calc_htime (integer ll_currow, string skmgubn, string sjikgbn, ref double dhyjtime, ref double dhcytime, ref double dhkltime);/******************************************************************************************/
/*** 7. 휴일연장(특근연장)시간																				*/
/***    7.1 근무일 TABLE의 '출퇴구분'이 '퇴근'인 자료의 from시간 보다 큰 자료와 근태 TABLE의*/
/***        '퇴근시각'과의 사이중 '급여항목'이 '4'(특근연장)인 시간을 ADD.						*/
/*** 8. 휴일철야(특근철야)시간																				*/
/***    8.1 근무일 TABLE의 '출퇴구분'이 '퇴근'인 자료의 from시간 보다 큰 자료와 근태 TABLE의*/
/***        '퇴근시각'과의 사이중 '급여항목'이 '5'(특근철야)인 시간을 ADD.						*/
/*** 9. 휴일근로(특근)시간 : 																					*/
/***      근태 TABLE의 '근태코드'가 있거나 '휴일구분'이 '0'(근무일)이 아닌 경우			   */
/***    9.1 근태 TABLE의 '퇴근 시각'부터 '출근 시각'사이 중 근무일 TABLE의 '급여항목'이   */
/***        '3','4','5','9'(무급)인 자료는제외하고 계산.												*/
/******************************************************************************************/

Double dTFrom,dMinFrom,dGetTkTime,dGetCkTime

dGetTkTime = dw_2.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
dGetCkTime = dw_2.GetItemNumber(ll_currow,"cktime")						/*출근시각*/

IF IsNull(dGetTkTime) THEN dGetTkTime =0
IF IsNull(dGetCkTime) THEN dGetCkTime =0

SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간(퇴근)*/
	INTO :dTFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."CTGUBN" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dTFrom =0
ELSE
	IF IsNull(dTFrom) THEN dTFrom =0
END IF	

SELECT MIN(NVL("P4_KUNMU"."FROMTIME",0))  					/*근무일 table의 퇴근인 from시간보다 큰 from시간*/
	INTO :dMinFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."FROMTIME" > :dTFrom )   ;

dHYjTime = wf_get_hangTime(dMinFrom,dGetTkTime,sKmgubn,'4')			/*휴일연장인 자료*/
dHYjTime = wf_conv_hhmm(dHYjTime)										

dHCyTime = wf_get_hangTime(dMinFrom,dGetTkTime,sKmgubn,'5')			/*휴일철야인 자료*/
dHCyTime = wf_conv_hhmm(dHCyTime)		

String sKtCode,sHDGbn

sKtCode = dw_2.GetItemString(ll_currow,"ktcode")						/*근태코드*/
sHDGbn  = dw_2.GetItemString(ll_currow,"hdaygubn")					/*휴일구분*/

IF (sKtCode = "" OR IsNull(sKtCode)) AND sHDGbn <> '0' THEN
	IF sHDGbn ='5' AND sJikGbn = '1' THEN										/*관리직,토요일*/
		dHKlTime =0
	ELSE
		IF dGetTkTime <= 1000 THEN
			dGetTkTime = dGetTkTime + 2400
		END IF
	
		SELECT SUM(NVL("P4_KUNMU"."GBUN",0))  
			INTO :dHKlTime  
			FROM "P4_KUNMU"  
			WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
					( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
					((DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) >= :dGetCkTime ) AND  
					( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) < :dGetTkTime )) AND  
					(( "P4_KUNMU"."KHGUBN" <> '3') AND
					( "P4_KUNMU"."KHGUBN" <> '4') AND
					( "P4_KUNMU"."KHGUBN" <> '5') AND
					( "P4_KUNMU"."KHGUBN" <> '9'))  ;	
		IF SQLCA.SQLCODE <> 0 THEN
			dHKlTime =0
		ELSE
			IF IsNull(dHKlTime) THEN 
				dHKlTime =0
			ELSE
				dHKlTime = wf_conv_hhmm(dHKlTime)
			END IF
		END IF
	END IF
ELSE
	dHKlTime = 0
END IF


end subroutine

public subroutine wf_calc_jhtime (integer ll_currow, string skmgubn, ref double djhtime);/******************************************************************************************/
/*** 8. 등교시간  																								*/
/***    8.1 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중  */
/***        '출퇴구분' = '퇴근'인 자료의 TO시간															*/
/***    8.2 근태 TABLE의 등교시각																			*/
/***    8.3 (8.1) - (8.2) = 등교시간(무급시간은 제외)													*/
/******************************************************************************************/

String sJtGbn
Double dToTime,dGetDkTime,dNoPayTime

dGetDkTime = dw_2.GetItemNumber(ll_currow,"dktime")					/*등교시각*/

IF IsNull(dGetDkTime) THEN dGetDkTime = 0

IF dGetDkTime = 0 OR IsNull(dGetDkTime) THEN
	dJhTime = 0
	Return
END IF

SELECT NVL("P4_KUNMU"."TOTIME",0)  					/*근무일 table의 to시간*/
	INTO :dToTime  
   FROM "P4_KUNMU"  
   WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
         ( "P4_KUNMU"."CTGUBN" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dToTime = 0
ELSE
	IF IsNull(dToTime) THEN dToTime =0
END IF

dJhTime = wf_use_time(dGetDkTime,dToTime,'TIME')						/*범위내 소요시간*/

dNoPayTime = wf_Get_HangTime(dGetDkTime,dToTime,skmgubn,'9')		/*무급시간*/

/*소요시간 = 소요시간 - (무급시간 )*/
IF dNoPayTime = 0 OR IsNull(dNoPayTime) THEN
ELSE
	dJhTime = dJhTime - dNoPayTime 
END IF
dJhtime = wf_conv_hhmm(dJhTime)

end subroutine

public subroutine wf_calc_jktime (integer ll_currow, string skmgubn, ref double djktime);/******************************************************************************************/
/*** 1. 지각시간 : 근태 table(p4_dkentae)의 '지각여부'가 '1'(지각)인 경우 계산. 				*/
/***    1.1 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중  */
/***        '출퇴구분' = '출근'인 자료의 FROM시간														*/
/***    1.2 근태 table의 지각 시각 																			*/
/***    1.3 (1.2) - (1.1) = 지각시간 (무급시간은 제외)												*/
/******************************************************************************************/
String sJkGbn
Double dFromTime,dGetJkTime,dNoPayTime

sJkGbn     = dw_2.GetItemString(ll_currow,"jkgubn")					/*'0' (지각아님)*/
dGetJkTime = dw_2.GetItemNumber(ll_currow,"jktime")					/*지각시각*/

IF IsNull(dGetJkTime) THEN dGetJkTime = 0

IF sJkGbn ="" OR IsNull(sJkGbn) OR sJkGbn = '0' THEN
	dJkTime = 0
	Return
END IF

SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간*/
	INTO :dFromTime  
   FROM "P4_KUNMU"  
   WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
         ( "P4_KUNMU"."CTGUBN" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dFromTime = 0
ELSE
	IF IsNull(dFromTime) THEN dFromTime =0
END IF

dJkTime = wf_use_time(dFromTime,dGetJkTime,'TIME')						/*범위내 소요시간*/

dNoPayTime = wf_Get_HangTime(dFromTime,dGetJkTime,skmgubn,'9')		/*무급시간*/

/*소요시간 = 소요시간 - (무급시간 )*/
IF dNoPayTime = 0 OR IsNull(dNoPayTime) THEN
ELSE
	dJkTime = dJkTime - dNoPayTime 
END IF
dJkTime = wf_conv_hhmm(dJkTime)




end subroutine

public subroutine wf_calc_jttime (integer ll_currow, string skmgubn, ref double djttime);/******************************************************************************************/
/*** 3. 조퇴시간 : 근태 table의 '조퇴여부'가 '1'(조퇴)인 경우 계산.								*/
/***    3.1 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중  */
/***        '출퇴구분' = '퇴근'인 자료의 TO시간															*/
/***    3.2 근태 TABLE의 조퇴시각																			*/
/***    3.3 (3.1) - (3.2) = 조퇴시간(무급시간은 제외)													*/
/******************************************************************************************/

String sJtGbn
Double dToTime,dGetJtTime,dNoPayTime

sJtGbn     = dw_2.GetItemString(ll_currow,"jtgubn")					/*'0' (조퇴아님)*/
dGetJtTime = dw_2.GetItemNumber(ll_currow,"jttime")					/*조퇴시각*/

IF IsNull(dGetJtTime) THEN dGetJtTime = 0

IF sJtGbn ="" OR IsNull(sJtGbn) OR sJtGbn = '0' THEN
	dJtTime = 0
	Return
END IF

SELECT NVL("P4_KUNMU"."TOTIME",0)  					/*근무일 table의 to시간*/
	INTO :dToTime  
   FROM "P4_KUNMU"  
   WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
         ( "P4_KUNMU"."CTGUBN" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dToTime = 0
ELSE
	IF IsNull(dToTime) THEN dToTime =0
END IF

dJtTime = wf_use_time(dGetJtTime,dToTime,'TIME')						/*범위내 소요시간*/

dNoPayTime = wf_Get_HangTime(dGetJtTime,dToTime,skmgubn,'9')		/*무급시간*/

/*소요시간 = 소요시간 - (무급시간 )*/
IF dNoPayTime = 0 OR IsNull(dNoPayTime) THEN
ELSE
	dJtTime = dJtTime - dNoPayTime 
END IF
dJttime = wf_conv_hhmm(dJtTime)

end subroutine

public subroutine wf_calc_kltime (integer ll_currow, string skmgubn, string sjikgubn, string sjhgbn, ref double dkltime);/******************************************************************************************/
/*** 4. 근로시간 : 인사마스타(P1_MASTER)의 '직종구분'에 따라서 처리.								*/
/***    4.1 '직종구분' = '1'(관리직)																		*/
/***        - 근태 TABLE의 '근태코드'가 NULL이고 '휴일구분'이 NULL이면 1을 ADD.				*/
/***        - 재학생이면 근로시간으로 계산한다.															*/
/***    4.2 '직종구분' = '2'(생산직)																		*/
/***        - 근태 TABLE의 '출근시각'과 '퇴근시각'으로 근무일 TABLE의 출근~퇴근 중        */
/***          '급여항목'이 '1'(기본급)인 자료의 시간을 SUM하여 ADD.								*/
/******************************************************************************************/
String sKtCode,sHDGbn
Double dFrom,dTo

sKtCode = dw_2.GetItemString(ll_currow,"ktcode")						/*근태코드*/
sHDGbn  = dw_2.GetItemString(ll_currow,"hdaygubn")						/*휴일구분*/

IF (sHDGbn = '5' AND sjikGubn = '1') AND sJhGbn = 'N' THEN			/*휴일구분 ='토요일'이면*/
	IF (IsNull(sKtCode) OR sKtCode ="") AND sHdGbn = '0' THEN		/*근태코드 없고 근무일이면*/
		dKlTime = 1
	ELSE
		dKlTime = 0
	END IF
ELSE
	IF sjikgubn = '1' AND sJhGbn = 'N' THEN															/*직종구분 = '관리직'*/
		IF (IsNull(sKtCode) OR sKtCode ="") AND sHdGbn = '0' THEN		/*근태코드 없고 근무일이면*/
			dKlTime = 1
		ELSE
			dKlTime = 0
		END IF
	ELSE
		SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간(출근)*/
			INTO :dFrom  
			FROM "P4_KUNMU"  
			WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
					( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
					( "P4_KUNMU"."CTGUBN" = '1' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			dFrom =0
		ELSE
			IF IsNull(dFrom) THEN dFrom =0
		END IF
		
		SELECT NVL("P4_KUNMU"."TOTIME",0)  					/*근무일 table의 to시간(퇴근)*/
			INTO :dTo  
			FROM "P4_KUNMU"  
			WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
					( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
					( "P4_KUNMU"."CTGUBN" = '2' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			dTo =0
		ELSE
			IF IsNull(dTo) THEN dTo =0
		END IF	
		
		dKlTime = wf_get_hangTime(dFrom,dTo,skmgubn ,'1')			/*기본급인 자료*/
		dKlTime = wf_conv_hhmm(dKlTime)
	END IF
END IF

end subroutine

public subroutine wf_calc_octime (integer ll_currow, string skmgubn, ref double doctottime, ref double docsiltime);/******************************************************************************************/
/*** 2. 외출시간 : 근태 table의 '외출횟수'가 0보다 큰 경우 계산									*/
/***    2.1 외출총공제시간 = 외출to - 외출from(무급시간은 제외)									*/
/***    2.2 외출실공제시간 = 외출총공제시간 - 2															*/
/******************************************************************************************/
Int    iOcCnt
Double dFrom,dTo,dNoPayTime

iOcCnt = dw_2.GetItemNumber(ll_currow,"occnt")						/*외출횟수*/
IF iOcCnt = 0 OR IsNull(iOcCnt) THEN
	dOcTotTime =0
	dOcSilTime =0
	Return
END IF

dFrom = dw_2.GetItemNumber(ll_currow,"ocfromtime")						/*외출from시각*/
dTo   = dw_2.GetItemNumber(ll_currow,"octotime")							/*외출to시각*/

dOcTotTime = wf_use_time(dFrom,dTo,'TIME')										/*외출소요시간*/

dNoPayTime = wf_Get_HangTime(dFrom,dTo,skmgubn,'9')							/*무급시간*/

/*소요시간 = 소요시간 - (무급시간)*/
IF dNoPayTime = 0 OR IsNull(dNoPayTime) THEN
ELSE
	dOcTotTime = dOcTotTime - (dNoPayTime )									/*외출총시간*/
END IF

dOcTotTime = wf_conv_hhmm(dOcTotTime)
IF dOcTotTime <= 2 THEN																	/*외출실시간*/
	dOcSilTime =0
ELSE
	dOcSilTime = dOcTotTime - 2
END IF






end subroutine

public subroutine wf_calc_yjtime (integer ll_currow, string skmgubn, ref double dyjtime);/******************************************************************************************/
/*** 5. 연장시간 																									*/
/***    5.1 근무일 TABLE의 '출퇴구분'이 '퇴근'인 자료의 from시간 보다 큰 자료와 근태 TABLE의*/
/***        '퇴근시각'과의 사이중 '급여항목'이 '2'(연장)인 시간을 ADD.							*/
/******************************************************************************************/
Double dTFrom,dMinFrom,dGetTkTime

dGetTkTime = dw_2.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
IF IsNull(dGetTkTime) THEN dGetTkTime =0

SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간(퇴근)*/
	INTO :dTFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."CTGUBN" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dTFrom =0
ELSE
	IF IsNull(dTFrom) THEN dTFrom =0
END IF	

SELECT MIN(NVL("P4_KUNMU"."FROMTIME",0))  					/*근무일 table의 퇴근인 from시간보다 큰 from시간*/
	INTO :dMinFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."FROMTIME" > :dTFrom )   ;

dYjTime = wf_get_hangTime(dMinFrom,dGetTkTime,sKmgubn,'2')			/*연장인 자료*/
dYjTime = wf_conv_hhmm(dYjTime)

end subroutine

public subroutine wf_calc_yktime (integer ll_currow, string skmgubn, ref double dykgtime);/******************************************************************************************/
/*** 6. 야간시간																									*/
/***    6.1 근무일 TABLE의 '출퇴구분'이 '퇴근'인 자료의 from시간 보다 큰 자료와 근태 TABLE의*/
/***        '퇴근시각'과의 사이중 '급여항목'이 '3'(야간)인 시간을 ADD.							*/
/******************************************************************************************/

Double dTFrom,dMinFrom,dGetTkTime

dGetTkTime = dw_2.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
IF IsNull(dGetTkTime) THEN dGetTkTime =0

SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간(퇴근)*/
	INTO :dTFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."CTGUBN" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	dTFrom =0
ELSE
	IF IsNull(dTFrom) THEN dTFrom =0
END IF	

SELECT MIN(NVL("P4_KUNMU"."FROMTIME",0))  					/*근무일 table의 퇴근인 from시간보다 큰 from시간*/
	INTO :dMinFrom
  	FROM "P4_KUNMU"  
  	WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
     	   ( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
        	( "P4_KUNMU"."FROMTIME" > :dTFrom )   ;

dYkgTime = wf_get_hangTime(dMinFrom,dGetTkTime,sKmgubn,'3')			/*야간인 자료*/
dYkgTime = wf_conv_hhmm(dYkTime)

end subroutine

public function integer wf_check_remainday (integer icurrow, string sempno, string sktdate, string scode, string sflag1);String  sYearMonth,sSex,sFromDate,sToDate,sYearMonthDay,snull
Integer lYDay,lsCnt,lsyDay,lCnt

SetNull(snull)

sYearMonthDay = left(sKtDate, 4) + mid(sKtDate, 5, 2) + right(sKtDate, 2)
sYearMonth   = left(sKtDate, 4) + mid(sKtDate, 5, 2)

///* 월차 체크 */
//IF sFlag1 = "1" THEN
//	lscnt = dw_2.GetItemNumber(1,"sum_monthcnt")								/*월차 사용일수*/
//	IF IsNull(lscnt) THEN lscnt =0
//	
//	SELECT NVL("P4_MONTHLIST"."YDAY",0) + NVL("P4_MONTHLIST"."BDAY",0) 	//이월일수 + 발생일수
//		INTO :lsyday  
//		FROM "P4_MONTHLIST"  
//		WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//		 	   ( "P4_MONTHLIST"."YYMM" = :sYearMonth ) AND  ( "P4_MONTHLIST"."EMPNO" = :sEmpNo )   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확인", "월차를 사용할수 없습니다 (월차 생성 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//     	dw_2.setfocus()
//		return -1
//	ELSE
//		IF IsNull(lsyday) THEN lsyday =0
//	END IF
//		
//	IF lsyday - lscnt >= 0 then										//잔여일수
//	else
//		MessageBox("확인", "월차를 사용할수 없습니다 (잔여 월차 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		return -1
//	END IF	
//END IF
//
//IF sFlag1 = "2" then														// 년차
//	lscnt = dw_2.GetItemNumber(1,"sum_yearcnt")					/*년차 사용일수*/
//	IF IsNull(lscnt) THEN lscnt =0
//	
//	SELECT "P4_YEARLIST"."YDAY" +"P4_YEARLIST"."BDAY" - "P4_YEARLIST"."KDAY",
//			 "P4_YEARLIST"."KDATE", "P4_YEARLIST"."KDATETO"
//		INTO :lYDay , :sFromDate, :sToDate 
//		FROM "P4_YEARLIST"  
//		WHERE ( "P4_YEARLIST"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_YEARLIST"."EMPNO" = :sempno ) AND 
//				( SUBSTR("P4_YEARLIST"."KDATE",1,6) <= :sYearMonth ) AND
//				( SUBSTR("P4_YEARLIST"."KDATETO",1,6) >= :sYearMonth ) ;
//	if sqlca.sqlcode <> 0 then
//		messagebox("확인", "년차를 사용할수 없습니다. !! ~r(총무과에 년차생성을 의뢰하십시오.) ")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1
//	END IF
//			
//	SELECT count("P4_DKENTAE"."KTCODE")  		/*사용일수*/
//		INTO :lCnt  
//		FROM "P4_DKENTAE"  
//		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
//				( "P4_DKENTAE"."KDATE" >= :sFromDate ) AND  
//				( "P4_DKENTAE"."KDATE" <= :sToDate ) AND  
//				( SUBSTR("P4_DKENTAE"."KDATE",1,6) < :sYearMonth) AND
//				( "P4_DKENTAE"."KTCODE" = :scode )   ;
//	if SQLCA.SqLCODE <> 0 THEN
//		lCnt = 0
//	ELSE
//		IF IsNull(lCnt) THEN lCnt =0
//	END IF	
//			
//	IF lYDay - (lsCnt + lCnt) < 0 then								//잔여일수
//		messagebox("확인", "년차를 사용할수 없습니다 (잔여년차확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1
//	end if	
//	
//end if
// 생리
if sFlag1 = "3" then
	lscnt = dw_2.GetItemNumber(1,"sum_sanglicnt")					/*생리 사용일수*/
	IF IsNull(lscnt) THEN lscnt =0
	
	sSex = left(dw_2.Getitemstring(iCurRow,'residentno2'), iCurRow)
	if sSex = 'iCurRow' then // 남자는 생리 휴가를 사용할수 없다.
		MessageBox("확인","남자사원은 생리휴가를 사용할수 없습니다.!!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		return -1
	end  if	
	
	IF lscnt  > 1  then
		MessageBox("확인", "생리를 사용할수 없습니다 (이미사용) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		return -1
	END IF
END IF

Return 1
end function

public function double wf_conv_hhmm (double dtime);/*분이 60을 넘을 경우 시간에 add 처리*/

Int iMM
//Int iHH,iMM
//
//iHH = Integer(Left(String(dTime,'00.00'),2))								/*시간*/
//iMM = Integer(Mid(String(dTime,'00.00'),4,2))								/*분*/
//	
//IF iMM >= 60 THEN
//	iMM = iMM - 60
//	iHH = iHH + 1
//	dTime = Round(((iHH * 100) + iMM)/100,2) 
//END IF

iMM   = Mod(dTime,60)
dTime = Truncate(dTime / 60,0)

dTime = (dTime + (iMM / 100))

Return dTime
	
end function

public function integer wf_enabled_chk (string syearmonth);/* 마감 처리된 월은 수정 불가*/

string ls_flag

SELECT "P4_MFLAG"."GUBN"  
	INTO :ls_flag  
  	FROM "P4_MFLAG" 
  	WHERE companycode= :gs_company AND myymm = :syearmonth ;
IF SQLCA.SQLCODE = 0 THEN
	IF ls_flag = '1' THEN
		MessageBox("확인","마감 처리되었으므로 변경 할 수 없습니다!!")
		Return -1
	END IF
END IF

Return 1
end function

public subroutine wf_get_cttime (string skmgbn, ref long lcktime, ref long ltktime);SELECT NVL("P4_KUNMU"."FROMTIME",0)  											/*출근시각*/
	INTO :lCkTime  
   FROM "P4_KUNMU"  
   WHERE ( "P4_KUNMU"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_KUNMU"."KMGUBN" = :sKmGbn ) AND  
         ( "P4_KUNMU"."CTGUBN" = '1' )   ;

SELECT NVL("P4_KUNMU"."TOTIME",0)  											/*퇴근시각*/
	INTO :lTkTime  
   FROM "P4_KUNMU"  
   WHERE ( "P4_KUNMU"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_KUNMU"."KMGUBN" = :sKmGbn ) AND  
         ( "P4_KUNMU"."CTGUBN" = '2' )   ;
end subroutine

public function double wf_get_hangtime (double dfrom, double dto, string skmgubn, string skhgubn);Double dNoPayTime,dTmpTime,dTmpYkTime

IF dTo <= 1000 AND skhgubn <> '9' THEN
	dTo = dTo + 2400
END IF

IF skhgubn ='9' THEN
	Double dTmpFrom,dTmpTo,dTmpCalcFrom,dTmpCalcTo
	
	SELECT SUM(NVL("P4_KUNMU"."GBUN",0))  
		INTO :dNoPayTime  
		FROM "P4_KUNMU"  
		WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
				( "P4_KUNMU"."TOTIME" >= :dFrom ) AND  
				( "P4_KUNMU"."FROMTIME" < :dTo ) AND  
				( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		dNoPayTime =0
	ELSE
		IF IsNull(dNoPayTime) THEN dNoPayTime =0
	END IF
	
	SELECT NVL("P4_KUNMU"."FROMTIME",0)  												/*무급 시작기본시간*/
		INTO :dTmpFrom  
		FROM "P4_KUNMU"  
		WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
				( "P4_KUNMU"."FROMTIME" <= :dFrom ) AND  
				( "P4_KUNMU"."TOTIME" >= :dFrom ) AND  
				( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		dTmpFrom =0
	ELSE
		IF IsNull(dTmpFrom) THEN dTmpFrom =0
	END IF
	IF dTmpFrom > 0 THEN
		dTmpCalcFrom = Wf_use_time(dTmpFrom,dFrom,'TIME')
	ELSE
		dTmpCalcFrom =0
	END IF
	
	SELECT NVL("P4_KUNMU"."TOTIME",0)  												/*무급 종료기본시간*/
		INTO :dTmpTo  
		FROM "P4_KUNMU"  
		WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
				( "P4_KUNMU"."FROMTIME" < :dTo ) AND  
				( "P4_KUNMU"."TOTIME" >= :dTo ) AND  
				( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		dTmpTo =0
	ELSE
		IF IsNull(dTmpTo) THEN dTmpTo =0
	END IF
	IF dTmpTo > 0 THEN
		dTmpCalcTo = Wf_use_time(dto,dTmpTo,'TIME')
	ELSE
		dTmpCalcTo =0
	END IF
	
	dNoPayTime = dNoPayTime - dTmpCalcFrom - dTmpCalcTo
	
ELSE
	
	SELECT SUM(NVL("P4_KUNMU"."GBUN",0))  
		INTO :dNoPayTime  
		FROM "P4_KUNMU"  
		WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
				( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400)  >= :dFrom ) AND  
				( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) < :dTo ) AND 
				( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		dNoPayTime =0
	ELSE
		IF IsNull(dNoPayTime) THEN dNoPayTime =0
	END IF
	
	String  sNightGbn
	Long    lGbun,lCalc_TotalTime =0,lCalc_YkTotal = 0
	Integer iCurCnt
	
	/*기타 급여 항목 해당 시간*/
	DECLARE cur_kunmu CURSOR FOR
		SELECT "P4_KUNMU"."NIGHTGUBN","P4_KUNMU"."GBUN",
				 DECODE("P4_KUNMU"."TTIMEGUBN",'1',"P4_KUNMU"."TOTIME","P4_KUNMU"."TOTIME" + 2400)	 
			FROM "P4_KUNMU"  
			WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
					( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
					( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400)  >= :dFrom ) AND  
					( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) < :dTo ) AND  
					( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	OPEN cur_kunmu;
	
	lCalc_TotalTime =0
	lCalc_YkTotal = 0
	iCurCnt  =0
	
	DO WHILE TRUE
		FETCH cur_kunmu INTO :sNightGbn,	:lGbun,	:dTmpTime;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
		
		IF IsNull(lGbun) THEN lGbun =0
		IF IsNull(dTmpTime) THEN dTmpTime = 0

		Long   iTimeHH_From,iTimeMM_From,iTimeHH_To,iTimeMM_To,&
				 iCalcHH,iCalcMM
		Double dCalc_Time
	
		IF dNoPayTime <=0 THEN
			dNoPayTime = 0
		ELSE	
			iTimeHH_From = Integer(Left(String(dTmpTime,'0000'),2))							/*from시*/
			iTimeMM_From = Integer(Mid(String(dTmpTime,'0000'),3,2))							/*from분*/
			
			iTimeHH_To = Integer(Left(String(dto,'0000'),2))									/*to시*/
			iTimeMM_To = Integer(Mid(String(dto,'0000'),3,2))									/*to분*/
			
			IF dto >= dTmpTime then   	
				lCalc_TotalTime = lCalc_TotalTime + lGbun
				IF sNightGbn = 'Y' THEN
					lCalc_YkTotal = lCalc_YkTotal + lGbun
				END IF
			else	
				IF iTimeMM_From < iTimeMM_To THEN  
					iCalcHH = (iTimeHH_From - 1) - iTimeHH_To
					iCalcMM = (iTimeMM_From - iTimeMM_to) + 60
				ELSE
					iCalcHH = iTimeHH_From - iTimeHH_To
					iCalcMM = iTimeMM_From - iTimeMM_To
				END IF
				dCalc_Time = (iCalcHH * 60) + iCalcMM
				
				lCalc_TotalTime = lCalc_TotalTime + dCalc_Time
				IF sNightGbn = 'Y' THEN
					lCalc_YkTotal = lCalc_YkTotal + dCalc_Time
				END IF
			END IF	
		END IF
		
		dCalc_Time = 0
		iCurCnt    = iCurCnt + 1
		
	LOOP
	CLOSE cur_kunmu;
	IF iCurCnt > 1 THEN
		dNoPayTime = lCalc_TotalTime
	ELSE
		dNoPayTime = dNoPayTime - lCalc_TotalTime
	END IF
	
	dYkTime = dYkTime + lCalc_YkTotal
	
END IF

Return dNoPayTime

end function

public subroutine wf_init_clear (integer ll_currow, string ls_addgubn);String ls_null

SetNull(ls_null)
//dw_2.SetItem(ll_currow,"jkgubn",'0')
//dw_2.SetItem(ll_currow,"jkgtime",0)
//dw_2.SetItem(ll_currow,"jktime",0)
//dw_2.SetItem(ll_currow,"occnt",0)
//dw_2.SetItem(ll_currow,"ocfromtime",0)
//dw_2.SetItem(ll_currow,"octotime",0)
//dw_2.SetItem(ll_currow,"ocgttime",0)
//dw_2.SetItem(ll_currow,"ocggtime",0)
//dw_2.SetItem(ll_currow,"jtgubn",'0')
//dw_2.SetItem(ll_currow,"jtgktime",0)
//dw_2.SetItem(ll_currow,"jtgytime",0)
//dw_2.SetItem(ll_currow,"jttime",0)
//dw_2.SetItem(ll_currow,"okfromtime",0)
//dw_2.SetItem(ll_currow,"oktotime",0)
//dw_2.SetItem(ll_currow,"ykgtime100",0)
//dw_2.SetItem(ll_currow,"hkcygtime",0)
//dw_2.SetItem(ll_currow,"dktime",0)
//dw_2.SetItem(ll_currow,"dkgtime",0)

dw_2.SetItem(ll_currow,"kmgubn",ls_null)
dw_2.SetItem(ll_currow,"cktime",0)
dw_2.SetItem(ll_currow,"tktime",0)

IF ls_addgubn = '1' THEN
	dw_2.SetItem(ll_currow,"klgtime",8)
ELSE
	dw_2.SetItem(ll_currow,"klgtime",0)
END IF

dw_2.SetItem(ll_currow,"yjgtime",0)
dw_2.SetItem(ll_currow,"ykgtime",0)
dw_2.SetItem(ll_currow,"hkgtime",0)
dw_2.SetItem(ll_currow,"hkyjgtime",0)
dw_2.SetItem(ll_currow,"hkcygtime",0)
dw_2.SetItem(ll_currow,"hkgtime2",0)
dw_2.SetItem(ll_currow,"jchgtime",0)
dw_2.SetItem(ll_currow,"lungtime",0)

end subroutine

public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck);	String	ls_KtCode, ls_AttTime
Double	ld_Cktime, ld_Tktime, ld_col[11]

ls_KtCode	= dw_2.GetItemString(ll_row,'ktcode')
ls_AttTime	= dw_2.GetItemString(ll_row,'attendancetime')

SELECT	kltime,		yjtime,		yktime,		hktime,		 hltime,		 jctime,
			jstime,		hyjtime,		hyktime,		cktime,		 tktime
  INTO	:ld_col[1], :ld_col[2], :ld_col[3], :ld_col[4],  :ld_col[5], :ld_col[6],
  			:ld_col[7], :ld_col[8], :ld_col[9], :ld_col[10], :ld_col[11]
  FROM 	p0_ktype
  WHERE	ktype = :ls_ktype;

IF isnull(ls_KtCode) OR trim(ls_KtCode) = '' OR ls_AttTime = '1' THEN
	dw_2.SetItem(ll_row,'KMGUBN',ls_ktype)
	dw_2.SetItem(ll_row,'KLGTIME',ld_col[1])
	dw_2.SetItem(ll_row,'YJGTIME',ld_col[2])
	dw_2.SetItem(ll_row,'YKGTIME',ld_col[3])
	dw_2.SetItem(ll_row,'HKGTIME',ld_col[4])
	dw_2.SetItem(ll_row,'HKGTIME2',ld_col[5])
	dw_2.SetItem(ll_row,'JCHGTIME',ld_col[6])
	dw_2.SetItem(ll_row,'LUNGTIME',ld_col[7])
	dw_2.SetItem(ll_row,'HKYJGTIME',ld_col[8])
	dw_2.SetItem(ll_row,'HKCYGTIME',ld_col[9])
	dw_2.SetItem(ll_row,'CKTIME',ld_col[10])
	dw_2.SetItem(ll_row,'TKTIME',ld_col[11])
	Return 1
ELSEIF lb_codecheck = TRUE THEN
	MessageBox('확인','시간 입력이 불가능한 근태입니다!~r~r타입을 등록하려면 먼저 근태를 삭제하세요.')
END IF

Return -1
end function

public function string wf_proceduresql (string sempno);	
String sGetSqlSyntax

sGetSqlSyntax = 'select p1_master.empno,p1_master.jikjonggubn,p1_master.jhgubn,p1_master.jhtgubn from p1_master '

sGetSqlSyntax = sGetSqlSyntax + ' where (p1_master.empno =' + "'"+ sEmpNo +"')"

Return sGetSqlSynTax
end function

public subroutine wf_reset ();String sEmpName,sDeptCode, sDeptName

dw_1.reset()
dw_1.Insertrow(0)

dw_1.SetItem(1,"kdate",left(gs_today,6)+'01')
dw_1.SetItem(1,"todate",gs_today)
dw_1.SetItem(1,"empno",gs_empno)

SELECT "P1_MASTER"."EMPNAME", "P0_DEPT"."DEPTCODE",  "P0_DEPT"."DEPTNAME2"  
	INTO :sEmpName,   			:sDeptCode,            :sDeptName  
	FROM "P1_MASTER",   "P0_DEPT"  
	WHERE ( p1_master.companycode = p0_dept.companycode (+)) and
   	   ( p1_master.deptcode = p0_dept.deptcode (+)) and  
         ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
        	( "P1_MASTER"."EMPNO" = :gs_empno ) )   ;

dw_1.SetItem(1,"empname",sEmpName)
dw_1.SetItem(1,"deptcode",sDeptCode)
dw_1.SetItem(1,"deptname",sDeptName)
	
// 환경변수 근태담당부서 
SELECT "DATANAME"
	INTO :ls_dkdeptcode
	FROM "P0_SYSCNFG"
	WHERE "SYSGU" = 'P' and "SERIAL" = 1 and "LINENO" = '1' ;

if gs_dept = ls_dkdeptcode  then
	dw_1.modify("empno.protect= 0")
	sflag = '0'
	
	pb_1.Enabled = True
	pb_2.Enabled = True
	pb_3.Enabled = True
	pb_4.Enabled = True
else
	dw_1.modify("empno.protect= 1")
	sflag = '1'
	
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
end if	

rb_1.Checked = True

Wf_TabOrder('USE')

dw_2.Reset()

sYearMonthDay_From = gs_today
sYearMonthDay_To = gs_today

w_mdi_frame.sle_msg.text =""

ib_any_typing = False
ib_detailflag = False

dw_2.SetItem(dw_2.GetRow(),"sflag",sflag)


end subroutine

public subroutine wf_set_sqlsyntax (string sdate, string sdept);
String sGetSqlSyntax,sGbn1,sGbn2
Long   lSyntaxLength

IF rb_1.Checked = True THEN
	dw_2.DataObject = 'd_pik1009_3'
	dw_2.SetTransObject(SQLCA)
	dw_2.Reset()
ELSE
	dw_2.DataObject = 'd_pik1009_2'
	dw_2.SetTransObject(SQLCA)
	dw_2.Reset()
END IF

sGetSqlSyntax = dw_2.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KDATE" = ' + "'" + sdate +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."DEPTCODE" LIKE ' + "'" + sdept +"'"+")"

//lSyntaxLength = len(sGetSqlSyntax)
//sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
//
//sGetSqlSyntax = sGetSqlSyntax + ")"

//IF rb_3.Checked = True THEN									/*결재*/
//	sGbn1 = 'Y'
//	sGbn2 = 'Y'
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KJGUBN1" = ' + "'" + sGbn1 +"'"+")" +&
// 											  ' AND ("P4_DKENTAE"."KJGUBN2" = ' + "'" + sGbn2 +"'"+")"	
//ELSEIF rb_4.Checked = True THEN													/*미결재*/
//	sGbn1 = 'N'
//	sGbn2 = 'N'
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' AND (("P4_DKENTAE"."KJGUBN1" = ' + "'" + sGbn1 +"'"+")" +&
// 											  ' OR  ("P4_DKENTAE"."KJGUBN2" = ' + "'" + sGbn2 +"'"+"))"	
//												
//ELSEIF rb_5.Checked = True THEN													/*전체*/
//	sGbn1 ='%'
//	sGbn2 ='%'
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KJGUBN1" LIKE ' + "'" + sGbn1 +"'"+")" +&
// 											  ' AND ("P4_DKENTAE"."KJGUBN2" LIKE ' + "'" + sGbn2 +"'"+")"	
//END IF

dw_2.SetSQLSelect(sGetSqlSyntax)	





end subroutine

public subroutine wf_taborder (string stag);
IF sTag = 'USE' THEN
	dw_2.SetTabOrder("ktcode",    10)
	dw_2.SetTabOrder("cktime",    20)
	dw_2.SetTabOrder("tktime",    30)
	dw_2.SetTabOrder("jktime",    40)
	dw_2.SetTabOrder("jttime",    50)
	dw_2.SetTabOrder("ocfromtime",60)
	dw_2.SetTabOrder("octotime",  70)
	dw_2.SetTabOrder("dktime",    80)
	dw_2.SetTabOrder("kjgubn1",   90)
	dw_2.SetTabOrder("kjgubn2",   100)
ELSE
	dw_2.SetTabOrder("ktcode",    0)
	dw_2.SetTabOrder("cktime",    0)
	dw_2.SetTabOrder("tktime",    0)
	dw_2.SetTabOrder("jktime",    0)
	dw_2.SetTabOrder("jttime",    0)
	dw_2.SetTabOrder("ocfromtime",0)
	dw_2.SetTabOrder("octotime",  0)
	dw_2.SetTabOrder("dktime",    0)
	dw_2.SetTabOrder("kjgubn1",   0)
	dw_2.SetTabOrder("kjgubn2",   0)
END IF
end subroutine

public function double wf_use_time (double dfromtime, double dtotime, string sflags);/*********************************************************************/
/* argument : dfromtime(시작시간),dtotime(종료시간),sflag(처리구분)	*/
/*				  sflag = 'TIME', 시간 계산 										*/
/*				  sflag = 'DATA', '급여항목'으로 계산							*/
/* return   : 계산된 인정시간														*/
/*********************************************************************/

Long   iStandardTime,iTimeHH_From,iTimeMM_From,iTimeHH_To,iTimeMM_To,&
	    iCalcHH,iCalcMM
Double dCalc_Time

iTimeHH_From = Integer(Left(String(dfromtime,'0000'),2))								/*from시간*/
iTimeMM_From = Integer(Mid(String(dfromtime,'0000'),3,2))							/*from분*/

iTimeHH_To = Integer(Left(String(dtotime,'0000'),2))									/*to시간*/
iTimeMM_To = Integer(Mid(String(dtotime,'0000'),3,2))									/*to분*/

IF iTimeHH_From > iTimeHH_To THEN
	iStandardTime = 24
ELSE
	iStandArdTime = 12
END IF
      
IF sflags ='TIME' THEN
/* 시,분을 나누어서 계산한다                        */
/* 시소요 = |(TO시 - TO기본) + (FROM기본 - FROM시)| */
/* 분소요 = TO분 - FROM분									 */
/* 분소요가 0보다 작으면 분소요 = 60 - |분소요|,시소요 = |시소요| - 1 */

	iCalcMM = iTimeMM_To - iTimeMM_From										/*분  */

	IF iTimeHH_From <= 12 AND iTimeHH_To <= 12 THEN						/*시간 */
		iCalcHH = iTimeHH_To - iTimeHH_From									
	ELSEIF iTimeHH_From <= 12 AND iTimeHH_To > 12 THEN
		iCalcHH = (iStandardTime - iTimeHH_From) + (iTimeHH_To - iStandardTime)
	ELSEIF iTimeHH_From > 12 AND iTimeHH_To <= 12 THEN
		iCalcHH = (iStandardTime - iTimeHH_From) + iTimeHH_To
	ELSEIF iTimeHH_From > 12 AND iTimeHH_To > 12 THEN
		iCalcHH = iTimeHH_To - iTimeHH_From									
	END IF
	
	IF iCalcHH = 0 THEN															/*시간이 같은 시간대이면*/
		iCalcMM = Abs(iCalcMM)
	ELSE
		IF iCalcMM < 0 THEN
			iCalcMM = 60 - Abs(iCalcMM)
			iCalcHH = iCalcHH - 1
		END IF
	END IF
	
	dCalc_Time = (iCalcHH * 60) + iCalcMM
	IF dCalc_Time < 0 THEN dCalc_Time =0
	
END IF

Return dCalc_Time
end function

event open;call super::open;
dw_datetime.InsertRow(0)

w_mdi_frame.sle_msg.text =""

ib_any_typing=False
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

Wf_Reset()
f_set_saupcd(dw_1, 'saupcd', '1')
is_saupcd = gs_saupcd

is_timegbn = f_get_p0_syscnfg(8, '1')

p_inq.TriggerEvent(Clicked!)
end event

on w_pik1011.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.st_2=create st_2
this.pb_4=create pb_4
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cb_1=create cb_1
this.cb_calc=create cb_calc
this.gb_5=create gb_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_1=create dw_1
this.dw_3=create dw_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.pb_4
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_calc
this.Control[iCurrent+9]=this.gb_5
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.dw_3
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.rb_1
this.Control[iCurrent+16]=this.gb_4
end on

on w_pik1011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.cb_calc)
destroy(this.gb_5)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_4)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1011
end type

event p_mod::clicked;call super::clicked;
IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_2.RowCount() <=0 THEN RETURN

IF wf_Enabled_Chk(Left(dw_2.GetItemString(1,"kdate"),6)) = -1 THEN RETURN

IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

IF dw_2.Update() <> 1 THEN
	MessageBox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ="자료가 저장되었습니다!"

//IF MessageBox("확 인","시간계산을 다시하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
//w_mdi_frame.sle_msg.text ="시간계산 재작업중!"
///*시간 다시 계산*/
//ib_detailflag = False
//cb_calc.TriggerEvent(Clicked!)
//
//p_inq.TriggerEvent(Clicked!)

ib_any_typing = False
//sle_msg.text ="시간계산 작업완료!"

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_del from w_inherite_standard`p_del within w_pik1011
end type

event p_del::clicked;call super::clicked;
Int iSelectedRow,iRowCount,iCurRow, i
string ls_kjgubn1 ,ls_kjgubn2


iRowCount = dw_2.RowCount()
IF iRowCount <=0 THEN RETURN

IF wf_Enabled_Chk(Left(dw_2.GetItemString(1,"kdate"),6)) = -1 THEN RETURN


IF MessageBox("확 인","선택한 자료(들)를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
	FOR i = iRowCount to 1 STEP -1
		IF dw_2.IsSelected(i) THEN dw_2.DeleteRow(i)
	NEXT

IF dw_2.Update() <>  1 THEN
	MessageBox("확 인","자료 삭제를 실패하였습니다!!")
	Rollback;
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

end event

type p_inq from w_inherite_standard`p_inq within w_pik1011
integer x = 3689
end type

event p_inq::clicked;call super::clicked;String  sDeptCode, ls_saupcd, sGbn ='N'
Integer il_SearchRow


dw_1.accepttext()
sYearMonthDay_From = dw_1.Getitemstring(1,'kdate')
sYearMonthDay_To = dw_1.Getitemstring(1,'todate')
sDeptCode     = dw_1.Getitemstring(1,'deptcode')
ls_saupcd = dw_1.GetItemString(1, 'saupcd')

IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN ls_saupcd = '%'

IF (sYearMonthDay_From = "" OR IsNull(sYearMonthDay_From)) AND &
	(sYearMonthDay_To = "" OR IsNull(sYearMonthDay_To)) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return 1

END IF

IF (sYearMonthDay_From > sYearMonthDay_To) THEN
	MessageBox("확 인","근태일자범위를 확인하십시오!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return 1
END IF

IF sDeptCode = "" OR IsNull(sDeptCode) THEN
	MessageBox("확 인","부서코드는 필수입력입니다!!")
	dw_1.SetColumn("deptcode")
	dw_1.SetFocus()
	Return 1
END IF

Wf_TabOrder('USE')

IF dw_3.Retrieve(gs_company, sYearMonthDay_From, sYearMonthDay_To, sDeptCode, ls_saupcd, '%', '%') <= 0 then
 	messagebox("확인","해당하는 사원이 없습니다!")
	dw_1.setfocus()
	return 1
END IF

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

dw_3.event RowFocusChanged(1)
end event

type p_print from w_inherite_standard`p_print within w_pik1011
boolean visible = false
integer x = 2149
integer y = 2384
end type

type p_can from w_inherite_standard`p_can within w_pik1011
end type

event p_can::clicked;call super::clicked;long ll_row, ll_count

wf_reset()
sYearMonthDay_From = dw_1.GetItemString(1,'kdate')

ll_row = dw_3.GetRow()
ll_count = dw_3.RowCount()

IF ll_row >= 1 AND ll_row <= ll_count THEN
	dw_3.Event RowFocusChanged(ll_row)
ELSE
	p_inq.TriggerEvent(Clicked!)
END IF

Enabled = false
PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_exit from w_inherite_standard`p_exit within w_pik1011
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pik1011
boolean visible = false
integer x = 2322
integer y = 2384
end type

type p_search from w_inherite_standard`p_search within w_pik1011
boolean visible = false
integer x = 1970
integer y = 2384
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1011
boolean visible = false
integer x = 2496
integer y = 2384
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1011
boolean visible = false
integer x = 2670
integer y = 2384
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1011
boolean visible = false
integer x = 1710
integer y = 2384
end type

type st_window from w_inherite_standard`st_window within w_pik1011
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1011
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1011
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1011
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1011
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1011
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1011
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1011
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1011
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1011
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1011
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1011
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1011
boolean visible = false
end type

type dw_2 from u_d_select_sort within w_pik1011
event ue_keyenter pbm_dwnprocessenter
integer x = 1006
integer y = 232
integer width = 3547
integer height = 1988
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pik10112_saup"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;call super::clicked;//If Row <= 0 then
//	b_flag =True
//ELSE
//	b_flag = False
//END IF

//CALL SUPER ::CLICKED
end event

event editchanged;ib_any_typing = True
p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"
end event

event itemchanged;String sKtCode,sKtName,snull,sKtDate, sAttendGbn,sYearMonthDay,sEmpNo,sSex,&
		 sFromDate,sToDate,sAttendTime,sAttendadd, sAttName, skmgubn

SetNull(snull)
sle_msg.text =""

this.accepttext()

sEmpNo = this.Getitemstring(this.GetRow(),'empno')

IF this.getcolumnname() = "ktcode" THEN									/* 근태코드 */
	sKtCode = this.GetText()
	
	IF sKtCode = "" OR IsNull(sKtCode) THEN
		sAttendTime = '1'
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
		Return
   END IF 
	SELECT "ATTENDANCENAME", "ATTENDANCEGUBN",  /*근태코드 검사*/
			 "ATTENDANCETIME", "ATTENDANCEADD"
		INTO :sAttName, :sAttendGbn ,:sAttendTime, :sAttendAdd
		FROM "P0_ATTENDANCE"  
		WHERE "P0_ATTENDANCE"."ATTENDANCECODE" = :sKtCode  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","근태코드를 확인하십시오!")
		this.SetItem(this.GetRow(),"ktcode",snull)
		this.setcolumn("ktcode")
		this.setfocus()
		return 1
	ELSE
		IF sAttendGbn = '3' THEN
			String gender
			gender = GetItemString(row,"sex")
			IF gender <> '2' and gender <> '4' THEN
				MessageBox("확인","남자 사원이므로 '"+sAttName+"' 근태를   ~r~r      사용할 수 없습니다.",Exclamation!)
				this.SetItem(this.GetRow(),"ktcode",snull)
				this.setcolumn("ktcode")
				this.setfocus()
				return 1
			END IF
		END IF
		
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
	END IF
	
	sKtDate = this.Getitemstring(this.GetRow(),'kdate')
	
	IF sAttendTime = '1' THEN													/*시간 입력 가능*/
	ELSE
		wf_init_clear(this.GetRow(), sAttendAdd)
	END IF	
END IF

IF this.getcolumnname() = "kmgubn" THEN									/* 근무타입 */
	skmgubn = this.GetText()
	IF wf_modify_ktype(this.GetRow(),skmgubn,TRUE) = -1 THEN
		this.SetItem(this.GetRow(),"kmgubn",snull)
		this.setcolumn("kmgubn")
		this.setfocus()
		RETURN 1
	END IF
END IF

double sjikak,jotoei,ochul
IF this.GetColumnName() = 'jkgtime' THEN
	sjikak = Double(Trim(this.GetText()))
	IF IsNull(sjikak) THEN sjikak =0	
	IF sjikak = 0 THEN
		this.SetItem(this.GetRow(),"jkgubn",snull)	
	ELSE
		this.SetItem(this.GetRow(),"jkgubn",'1')		
	END IF
END IF

IF this.GetColumnName() = 'jtgktime' THEN
	jotoei = Double(Trim(this.GetText()))
	IF IsNull(jotoei) THEN jotoei =0		
	IF jotoei = 0 THEN
		this.SetItem(this.GetRow(),"jtgubn",snull)	
	ELSE
		this.SetItem(this.GetRow(),"jtgubn",'1')		
	END IF		
END IF

IF this.GetColumnName() = 'ocgttime' THEN
	ochul = Double(Trim(this.GetText()))
	IF IsNull(ochul) THEN ochul =0		
	IF ochul = 0 THEN
		this.SetItem(this.GetRow(),"occnt",0)			
	ELSE
		this.SetItem(this.GetRow(),"occnt",1)		
	END IF
END IF


if IsNull(this.Getitemstring(this.GetRow(),'ktcode')) or &
   IsNull(this.Getitemstring(this.GetRow(),'kmgubn')) or &
   IsNull(this.GetitemNumber(this.GetRow(),'klgtime')) then
else
	this.Setitem(this.Getrow(),'kdate', this.Getitemstring(this.GetRow(),'cldate'))
	this.Setitem(this.Getrow(),'empno', is_empno)
	this.Setitem(this.Getrow(),'companycode', gs_company)
	
end if

ib_detailflag = True

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"



end event

event itemerror;Return 1
end event

event retrieveend;//int i
//string empno
//
//For i = 1 to this.rowcount() 
//    empno = this.GetitemString(i,'empno')
// 	
//	 if IsNull(empno) or empno = '' then
//		 this.object.kmgubn.protect = 0
//	end if
//	
//	
//Next
end event

event retrieverow;
IF row <=0 then return

dw_2.SetItem(row,"sflag",sflag)
end event

event rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)
end event

type st_2 from statictext within w_pik1011
integer x = 2350
integer y = 120
integer width = 1189
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
string text = "생성하지 않은자료는 수정되지 않습니다!!"
boolean focusrectangle = false
end type

type pb_4 from picturebutton within w_pik1011
boolean visible = false
integer x = 969
integer y = 2580
integer width = 82
integer height = 72
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\last.gif"
alignment htextalign = right!
end type

event clicked;string  sEmpNo,sEmpName,sMax_name,sDept
Integer iCount

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :sEmpNo  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE" >= :syearmonthday_from));
	IF IsNull(sEmpNo) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND
	      	(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE" >= :syearmonthday_from));
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :sEmpNo 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	INTO :sEmpName,   			  :sDept  
	FROM "P1_MASTER",   "P0_DEPT"  
	WHERE ( p1_master.companycode = p0_dept.companycode (+)) and  
         ( p1_master.deptcode = p0_dept.deptcode (+)) and  
     	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
        	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
			  
dw_1.SetItem(1,"empno",sEmpNo)			 
dw_1.SetItem(1,"empname",sEmpName)
dw_1.SetItem(1,"deptcode",sDept)
	
SELECT COUNT("P4_DKENTAE"."KTCODE")		INTO :iCount  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."KDATE" >= :syearmonthday_from ) AND  
			( "P4_DKENTAE"."KDATE" <= :syearmonthday_to ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo )   ;
IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False	
END IF

dw_2.SetRedraw(False)
dw_2.Retrieve(sYearMonthDay_From,sEmpNo,sYearMonthDay_To)
dw_2.SetRedraw(True)
end event

type pb_3 from picturebutton within w_pik1011
boolean visible = false
integer x = 859
integer y = 2580
integer width = 82
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\next.gif"
alignment htextalign = right!
end type

event clicked;string  sEmpNo,sEmpName,sMin_name,sDept,sGetEmpNo,sJikGbn
Integer iCount

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	sEmpNo = dw_1.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :sGetEmpNo
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :sEmpNo AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From));
	IF IsNull(sGetEmpNo) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sEmpName = dw_1.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sEmpName	AND
				(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From));
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :sGetEmpNo 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2" ,	"P1_MASTER"."JIKJONGGUBN" 
	INTO :sEmpName,   			  :sDept,						:sJikGbn
	FROM "P1_MASTER",   "P0_DEPT"  
	WHERE ( p1_master.companycode = p0_dept.companycode (+)) and  
         ( p1_master.deptcode = p0_dept.deptcode (+)) and  
     	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
        	( "P1_MASTER"."EMPNO" = :sGetEmpNo ) )   ;
			  
dw_1.SetItem(1,"empno",sGetEmpNo)			  
dw_1.SetItem(1,"empname",sEmpName)
dw_1.SetItem(1,"deptcode",sDept)
dw_1.SetItem(1,"jikjonggubn",sJikGbn)
	
SELECT COUNT("P4_DKENTAE"."KTCODE")		INTO :iCount  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."KDATE" >= :syearmonthDay_From ) AND  
			( "P4_DKENTAE"."KDATE" <= :syearmonthDay_To ) AND  	
         ( "P4_DKENTAE"."EMPNO" = :sGetEmpNo )   ;
IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False	
END IF

dw_2.SetRedraw(False)
dw_2.Retrieve(sYearMonthDay_From,sGetEmpNo,sYearMonthDay_To)

dw_2.SetRedraw(True)
end event

type pb_2 from picturebutton within w_pik1011
boolean visible = false
integer x = 750
integer y = 2580
integer width = 105
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\prior.gif"
alignment htextalign = right!
end type

event clicked;string  sEmpNo,sEmpName,sMax_name,sDept,sGetEmpNo
Integer iCount

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	sEmpNo = dw_1.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :sGetEmpNo  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :sEmpNo AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From)) ;
	IF IsNull(sGetEmpNo) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sEmpName = dw_1.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sEmpName AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From)) ;
				
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :sGetEmpNo 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	INTO :sEmpName,   			  :sDept  
	FROM "P1_MASTER",   "P0_DEPT"  
	WHERE ( p1_master.companycode = p0_dept.companycode (+)) and  
         ( p1_master.deptcode = p0_dept.deptcode (+)) and  
     	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
        	( "P1_MASTER"."EMPNO" = :sGetEmpNo ) )   ;
			  
dw_1.SetItem(1,"empno",sGetEmpNo)			  
dw_1.SetItem(1,"empname",sEmpName)
dw_1.SetItem(1,"deptcode",sDept)

SELECT COUNT("P4_DKENTAE"."KTCODE")		INTO :iCount  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."KDATE" >= :syearmonthDay_From) AND  
			( "P4_DKENTAE"."KDATE" <= :syearmonthDay_To) AND  	
         ( "P4_DKENTAE"."EMPNO" = :sGetEmpNo )   ;
IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False	
END IF

dw_2.SetRedraw(False)
dw_2.Retrieve(sYearMonthDay_From,sEmpNo,sYearMonthDay_To)
dw_2.SetRedraw(True)

end event

type pb_1 from picturebutton within w_pik1011
boolean visible = false
integer x = 640
integer y = 2580
integer width = 82
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\first.gif"
alignment htextalign = right!
end type

event clicked;string sEmpNo,sEmpName,sMin_name,sDept
Integer iCount

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF


IF rb_1.Checked = True THEN
	SELECT min("P1_MASTER"."EMPNO")  
		INTO :sEmpNo  
	   FROM "P1_MASTER"  
	   WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company) AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
             "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From)) ;
				
	IF IsNull(sEmpNo) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
      WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company) AND
      		(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
             "P1_MASTER"."RETIREDATE"  >= :syearmonthDay_From)) ;
				
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :sEmpNo 
		   FROM "P1_MASTER"  
		   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	INTO :sEmpName,   			  :sDept  
	FROM "P1_MASTER",   "P0_DEPT"  
	WHERE ( p1_master.companycode = p0_dept.companycode (+)) and  
         ( p1_master.deptcode = p0_dept.deptcode (+)) and  
     	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
        	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
			  
dw_1.SetItem(1,"empno",sEmpNo)
dw_1.SetItem(1,"empname",sEmpName)
dw_1.SetItem(1,"deptcode",sDept)

SELECT COUNT("P4_DKENTAE"."KTCODE")		INTO :iCount  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."KDATE" >= :syearmonthDay_From ) AND  
			( "P4_DKENTAE"."KDATE" <= :syearmonthDay_To ) AND  	
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo )   ;
IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False	
END IF

dw_2.SetRedraw(False)
dw_2.Retrieve(sYearMonthDay_From,sEmpNo,sYearMonthDay_To)
dw_2.SetRedraw(True)
end event

type cb_1 from commandbutton within w_pik1011
boolean visible = false
integer x = 2949
integer y = 2448
integer width = 489
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이전시간계산"
end type

event clicked;///******************************************************************************************/
///*** 일근태시간 계산(처리선택된 자료의 근태자료를 읽어서 아래 사항을 갱신한다)				*/
///*** - 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중       */
///*** 1. 지각시간 : wf_calc_jktime 															 				*/ 
///*** 2. 외출시간 : wf_calc_octime																			*/
///*** 3. 조퇴시간 : wf_calc_jttime																			*/
///*** 4. 근로시간 : wf_calc_kltime																			*/
///*** 5. 연장시간 : wf_calc_yjtime																			*/
///*** 6. 야간시간 : wf_calc_yktime																			*/
///*** 7. 휴일(특근)시간 : wf_calc_htime																		*/
///******************************************************************************************/
//
//Int    k,il_FromRow,il_ToRow
//String sEmpNo,sKmGbn,sJikGbn,sKtCode,sJhGbn,sJhtGbn,sEnabledFlag,sEnabledAddFlag
//Double dJkTime,				&													
//		 dOcTotTime,			&
//		 dOcSilTime,			&
//		 dJtTime,				&
//		 dKlTime,				&
//		 dYjTime,				&
//		 dJhTime,				&
//		 dHYjTime,				&
//		 dHCyTime,				&
//		 dHKlTime				/*지각,외출총공제,외출실공제,조퇴,근로,연장,야간,휴일연장,휴일철야,휴일근로*/
//Integer iConv_KlBun,iConv_JhBun
//
//sle_msg.text = '일근태시간 계산 중......'
//SetPointer(HourGlass!)
//
//IF ib_detailflag = True THEN
//	il_FromRow  = dw_2.GetRow()
//	il_ToRow    = dw_2.GetRow()
//ELSE
//	il_FromRow = 1
//	il_ToRow   = dw_2.RowCount()
//END IF
//
//dw_2.AcceptText()
//
//FOR k = il_FromRow TO il_ToRow
//	
//	sEmpNo  = dw_2.GetItemString(k,"empno")
//	sJikGbn = dw_2.GetItemString(k,"jikjonggubn")
//	sKmGbn  = dw_2.GetItemString(k,"kmgubn")									/*근무일구분*/
//	sKtCode = dw_2.GetItemString(k,"ktcode")									/*근태코드*/ 
//	sJhGbn  = dw_2.GetItemString(k,"jhgubn")									/*재학생여부*/ 
//	sJhtGbn = dw_2.GetItemString(k,"jhtgubn")									/*등교시간공제여부*/ 
//	
//	dYkTime = 0
//	
//	IF sKtCode <> "" AND Not IsNull(sKtCode) THEN								/*근태코드별 계산유무*/
//		SELECT "P0_ATTENDANCE"."ATTENDANCETIME",  		/* ATTENDANCETIME :'1'= 시간계산*/
//	        	 "P0_ATTENDANCE"."ATTENDANCEADD"  			/* ATTENDANCEADD  :'1'= 근로일수에포함 */
//    		INTO :sEnabledFlag ,:sEnabledAddFlag 
//    		FROM "P0_ATTENDANCE"  
//   		WHERE "P0_ATTENDANCE"."ATTENDANCECODE" = :sKtCode   ;
//		IF SQLCA.SQLCODE <> 0 THEN SetNull(sEnabledFlag)
//	END IF
//	
//	IF sKtCode = "" or IsNull(sKtCode) OR sEnabledFlag = '1' THEN 
//	
//		wf_Calc_JkTime(k,sKmGbn,dJkTime)										/*지각시간*/
//		wf_Calc_OcTime(k,sKmGbn,dOcTotTime,dOcSilTime)					/*외출시간(총,실)*/
//		wf_Calc_JtTime(k,sKmGbn,dJtTime)										/*조퇴시간*/
//		wf_Calc_KlTime(k,sKmGbn,sJikGbn,sJhGbn,dKlTime)							/*근로시간*/
//	
//		wf_Calc_YjTime(k,sKmGbn,dYjTime)										/*연장시간*/
////		wf_Calc_YkTime(k,sKmGbn,dYkTime)										/*야간시간*/
//		
//		IF sJhGbn ='Y' AND sJhtGbn ='Y' THEN								/*등교시간*/
//			wf_calc_JhTime(k,sKmGbn,dJhTime)
//		ELSE
//			dJhTime = 0
//		END IF
//		
//		wf_Calc_HTime(k,sKmGbn,sJikGbn,dHYjTime,dHCyTime,dHKltime)				/*특근시간(연장,철야,근로)*/
//	else
//		dJkTime =0; dOcTotTime =0 ; dOcSilTime =0;	dJtTime =0;  dKlTime = 0; dYjTime =0;
//		dYkTime =0; dHYjTime =0; 	 dHCyTime =0; 		dHKlTime =0; dJhTime = 0;
//	end if
//	
//	/*야간 시간 시,분으로 계산*/
//	dYkTime = wf_conv_hhmm(dYkTime)
//	
//	IF sJikGbn = '2' THEN									/*생산직*/
//		iConv_KlBun = Integer(Left(String(dKlTime,'00.00'),2)) * 60 + Integer(Right(String(dKlTime,'00.00'),2))
//		iConv_JhBun = Integer(Left(String(dJhTime,'00.00'),2)) * 60 + Integer(Right(String(dJhTime,'00.00'),2))
//		
//		IF iConv_KlBun - iConv_JhBun < 0 THEN
//			dKlTime = 0
//			dJhTime = 0
//		ELSE
//			dKlTime = Wf_conv_hhmm(iConv_KlBun - iConv_JhBun)				/*근로시간 = 근로시간 - 등교시간*/
//			dJhTime = 0
//		END IF
//	END IF	
//	
//	dw_2.SetItem(k,"jkgtime",   dJkTime)
//	dw_2.SetItem(k,"ocgttime",  dOcTotTime)
//	dw_2.SetItem(k,"ocggtime",  dOcSilTime)
//	dw_2.SetItem(k,"jtgktime",  dJtTime)
//	dw_2.SetItem(k,"klgtime",   dKlTime)
//	dw_2.SetItem(k,"yjgtime",   dYjTime)
//	dw_2.SetItem(k,"ykgtime",   dYkTime)
//	dw_2.SetItem(k,"hkyjgtime", dHYjTime)
//	dw_2.SetItem(k,"hkcygtime", dHCyTime)
//	dw_2.SetItem(k,"hkgtime",   dHKlTime)
//	dw_2.SetItem(k,"dkgtime",   dJhTime)
//NEXT
//
//SetPointer(Arrow!)
//sle_msg.text ='일근태시간 계산 완료!!'
//
end event

type cb_calc from commandbutton within w_pik1011
boolean visible = false
integer x = 2194
integer y = 2468
integer width = 489
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이전시간계산"
end type

event clicked;/******************************************************************************************/
/*** 일근태시간 계산(처리선택된 자료의 근태자료를 읽어서 아래 사항을 갱신한다)				*/
/*** - 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중       */
/*** 1. 지각시간 : wf_calc_jktime 															 				*/ 
/*** 2. 외출시간 : wf_calc_octime																			*/
/*** 3. 조퇴시간 : wf_calc_jttime																			*/
/*** 4. 근로시간 : wf_calc_kltime																			*/
/*** 5. 연장시간 : wf_calc_yjtime																			*/
/*** 6. 야간시간 : wf_calc_yktime																			*/
/*** 7. 등교시간 : wf_calc_jktime																			*/
/*** 8. 휴일(특근)시간 : wf_calc_htime																		*/
/******************************************************************************************/

String  ls_kdate,sEmpNo,sMasterSql,sRtnValue,ls_flag, ls_yymm
Integer k

dw_1.AcceptText()
ls_yymm  = dw_1.GetItemString(1,"kdate")
sEmpNo   = dw_1.GetItemString(1,"empno")

// 마감 처리된 월은 수정 불가
SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = :ls_yymm ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	

sMasterSql = wf_ProcedureSql(sEmpNo)

sle_msg.text = '일근태시간 계산 중......'
SetPointer(HourGlass!)

FOR k = 1 TO dw_2.RowCount()
	ls_kdate = dw_2.GetItemString(k,"kdate")
	
	sRtnValue = sqlca.sp_calculation_dkentaetime(ls_kdate,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);

	IF Left(sRtnValue,2) <> 'OK' then
		MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
		Return
	END IF
NEXT

SetPointer(Arrow!)
sle_msg.text ='일근태시간 계산 완료!!'


end event

type gb_5 from groupbox within w_pik1011
boolean visible = false
integer x = 594
integer y = 2492
integer width = 521
integer height = 228
integer taborder = 110
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 80269524
string text = "자료선택"
end type

type rr_1 from roundrectangle within w_pik1011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 987
integer y = 228
integer width = 3584
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pik1011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 228
integer width = 910
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from u_key_enter within w_pik1011
event ue_key pbm_dwnkey
integer x = 50
integer width = 2199
integer height = 228
integer taborder = 11
string dataobject = "d_pik1011_1"
boolean border = false
end type

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;call super::itemchanged;string sDeptNo, sDeptName, sJikGbn, snull

sle_msg.text =""

SetNull(snull)
IF This.AcceptText() = -1 THEN return

IF this.GetColumnName() = "kdate" THEN
	sYearMonthDay_From = Trim(this.GetText())
	
	IF sYearMonthDay_From ="" OR IsNull(sYearMonthDay_From) THEN Return
	
	IF F_datechk(sYearMonthDay_From) = -1 THEN
		messagebox("확인","근태일자From를 확인하십시오!")
		//this.SetItem(1,"kdate",'')
		Object.kdate[1] = ''
		this.setcolumn("kdate")
		Return 1
	END IF
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "todate" THEN
	sYearMonthDay_To = Trim(this.GetText())
	
	IF sYearMonthDay_To ="" OR IsNull(sYearMonthDay_To) THEN Return
	
	IF F_datechk(sYearMonthDay_To) = -1 THEN
		messagebox("확인","근태일자To를 확인하십시오!")
		//this.SetItem(1,"todate",'')
		Object.todate[1] = ''
		this.setcolumn("todate")
		Return 1
	END IF
	p_inq.TriggerEvent(Clicked!)
END IF

IF GetColumnName() = "deptcode" then
  sDeptNo = this.GetText()

	  IF sDeptNo = '' or isnull(sDeptNo) THEN
		  SetITem(1,"deptcode",SNull)
		  SetITem(1,"deptname",SNull)
		  Return
	  ELSE	
		  IF f_chk_saupemp(sDeptNo, '2', is_saupcd) = False THEN
			  SetItem(getrow(),'deptcode',snull)
			  SetColumn('deptcode')
			  dw_1.SetFocus()
			  Return 1
		  END IF
		  
			 SELECT "P0_DEPT"."DEPTNAME"  
				INTO :sDeptName
				FROM "P0_DEPT"  
			  WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
					  ( "P0_DEPT"."DEPTCODE" = :sDeptNo ); 
			 
			 IF sDeptName = '' OR ISNULL(sDeptName) THEN
			 	 MessageBox("확 인","부서번호를 확인하세요!!") 
				 SetITem(1,"deptcode",SNull)
				 SetITem(1,"deptname",SNull) 
				 SetColumn("deptcode")
				 Return 1
			 END IF	
				SetITem(1,"deptname",sDeptName  )
				p_inq.TriggerEvent(Clicked!)
	 END IF
END IF


IF GetColumnName() = "saupcd" THEN
	is_saupcd = this.GetText()
	
	this.SetItem(this.Getrow(), 'deptcode', snull)
	this.SetItem(this.GetRow(), 'deptname', snull)
//	p_inq.TriggerEvent(Clicked!)
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;This.AcceptText()

IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(gs_gubun)
	
	Gs_Gubun = is_saupcd
	IF gs_gubun = '' OR IsNull(gs_gubun) THEN gs_gubun = '%'
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	this.TriggerEvent(itemchanged!)
	
END IF

//IF this.GetColumnName() = "empno"  THEN
//	
//	Open(w_employee_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	this.SetItem(this.GetRow(),"empno",gs_code)
//	this.TriggerEvent(ItemChanged!)
//END IF
//
//IF this.GetColumnName() = "empname"  THEN
//	
//	Open(w_employee_popup)
//	
//	IF IsNull(Gs_codename) THEN RETURN
//	
//	this.SetItem(this.GetRow(),"empname",gs_codename)
//	this.TriggerEvent(ItemChanged!)
//END IF

end event

type dw_3 from u_d_select_sort within w_pik1011
integer x = 82
integer y = 232
integer width = 882
integer height = 1988
integer taborder = 11
string title = "none"
string dataobject = "d_pik1011_2"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;String empno

//IF ISNULL(CurrentRow) THEN CurrentRow = 1
IF CurrentRow < 1 THEN 
	this.SelectRow(0, FALSE)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(CurrentRow, TRUE)

	empno = GetItemString(CurrentRow,'empno')
	is_empno = empno
	dw_2.SetRedraw(false)

	IF dw_2.retrieve(sYearMonthDay_From,empno,sYearMonthDay_To, is_saupcd,is_timegbn) <= 0 then
		dw_2.SetRedraw(true)
 		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!"
		dw_3.setfocus()
		return 1
	ELSE
		IF Wf_Enabled_Chk(Left(sYearMonthDay_To,6)) = -1 THEN
			Wf_TabOrder('ENABLE')
		END IF
		dw_2.SetRedraw(true)
	END IF
END IF
end event

event rowfocuschanging;call super::rowfocuschanging;IF ib_any_typing = True OR ib_detailflag = True THEN
	ib_any_typing = false
	ib_detailflag = false
	IF MessageBox('확인','수정한 데이타가 있습니다.~r~r~n  저장하시겠습니까?',Question!,YesNo!) <> 1 THEN
		Return
	ELSE
		IF dw_2.update() = 1 THEN
			commit;
			Return -1
		ELSE
			MessageBox('저장 실패', '저장에 실패하였습니다!')
			rollback;
		END IF
	END IF
END IF
end event

type rb_2 from radiobutton within w_pik1011
boolean visible = false
integer x = 5170
integer y = 328
integer width = 233
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 8388608
long backcolor = 33027312
string text = "성명"
end type

type rb_1 from radiobutton within w_pik1011
boolean visible = false
integer x = 4873
integer y = 328
integer width = 233
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 8388608
long backcolor = 33027312
string text = "사번"
boolean checked = true
end type

type gb_4 from groupbox within w_pik1011
boolean visible = false
integer x = 4823
integer y = 236
integer width = 635
integer height = 228
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 128
long backcolor = 33027312
string text = "정렬"
end type

