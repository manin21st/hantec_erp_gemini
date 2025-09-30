$PBExportHeader$w_pik1019.srw
$PBExportComments$** 출퇴근시간 생성(ID Card)
forward
global type w_pik1019 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_pik1019
end type
type dw_maxdate from datawindow within w_pik1019
end type
type dw_update from datawindow within w_pik1019
end type
type dw_insert1 from datawindow within w_pik1019
end type
end forward

global type w_pik1019 from w_inherite_multi
string title = "출퇴근시간생성"
dw_cond dw_cond
dw_maxdate dw_maxdate
dw_update dw_update
dw_insert1 dw_insert1
end type
global w_pik1019 w_pik1019

type variables
String               sProcDate,sProcfile,sgubn, il_filename
DataWindow   dw_Process
Integer             il_RowCount

integer  ii_fileid

end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_create_error (string sempno, string sflag)
public subroutine wf_calc_jhtime (integer ll_currow, string skmgubn, ref double djhtime)
public subroutine wf_calc_jktime (integer ll_currow, string skmgubn, ref double djktime)
public subroutine wf_calc_jttime (integer ll_currow, string skmgubn, ref double djttime)
public subroutine wf_calc_kltime (integer ll_currow, string skmgubn, string sjikgubn, string sjhgbn, ref double dkltime)
public subroutine wf_calc_octime (integer ll_currow, string skmgubn, ref double doctottime, ref double docsiltime)
public subroutine wf_calc_yjtime (integer ll_currow, string skmgubn, ref double dyjtime)
public subroutine wf_calc_yktime (integer ll_currow, string skmgubn, ref double dyktime)
public function double wf_conv_hhmm (double dtime)
public function double wf_get_hangtime (double dfrom, double dto, string skmgubn, string skhgubn)
public function double wf_use_time (double dfromtime, double dtotime, string sflag)
public function integer wf_enabled_chk (integer ll_currow, string sempno)
public subroutine wf_setsqlsyntax (string sflag)
public function string wf_proceduresql (string sflag)
public function integer wf_fileopen ()
public function integer wf_fileread ()
public subroutine wf_data_create (string sempno, string sdate, long stime, string lgubn)
public subroutine wf_calc_htime (integer ll_currow, string skmgubn, string sjikgbn, ref double dhyjtime, ref double dhcytime, ref double dhkltime)
end prototypes

public function integer wf_requiredchk (integer ll_row);//String sProcFile

sProcDate= dw_cond.GetItemString(ll_row,"kdate")
sProcFile = dw_cond.GetItemString(ll_row,"proc_file") 


//IF sProcDate = "" OR IsNull(sProcDate) THEN
//	MessageBox("확 인","처리일자는 필수입력입니다!!")
//	dw_cond.SetColumn("kdate")
//	dw_cond.SetFocus()
//	Return -1
//END IF

IF sProcFile = "" OR IsNull(sProcFile) THEN
	MessageBox("확 인","처리자료는 필수입력입니다!!")
	dw_cond.SetColumn("proc_file")
	dw_cond.SetFocus()
	Return -1
ELSE
	
END IF


Return 1
end function

public subroutine wf_create_error (string sempno, string sflag);//Int    il_CurRow
//String sEmpName
//
//il_CurRow = dw_error.InsertRow(0)
//dw_error.SetItem(il_CurRow,"empno",sempno)
//
//SELECT "P1_MASTER"."EMPNAME"  
//	INTO :sEmpName  
//   FROM "P1_MASTER"  
//   WHERE ( "P1_MASTER"."EMPNO" = :sEmpno ) AND  
//         ( "P1_MASTER"."COMPANYCODE" = :gs_company )   ;
//
//dw_error.SetItem(il_CurRow,"empname",sEmpName)
//
//IF sflag ='KUNTAE' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'근태자료 없슴')
//ELSEIF sflag = 'CKTIME' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'출근시각 없슴')
//ELSEIF sflag = 'TKTIME' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'퇴근시각 없슴')	
//ELSEIF sflag = 'ALLTIME' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'출퇴근시각 없슴')
//ELSEIF sflag = 'KMGU' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'근무일구분 없슴')
//ELSEIF sflag = 'KJ' THEN
//	dw_error.SetItem(il_CurRow,"errtext",'미결재 자료임')	
//END IF
//
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

dGetDkTime = dw_insert1.GetItemNumber(ll_currow,"dktime")					/*등교시각*/

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

sJkGbn     = dw_insert1.GetItemString(ll_currow,"jkgubn")					/*'0' (지각아님)*/
dGetJkTime = dw_insert1.GetItemNumber(ll_currow,"jktime")					/*지각시각*/

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

sJtGbn     = dw_insert1.GetItemString(ll_currow,"jtgubn")					/*'0' (조퇴아님)*/
dGetJtTime = dw_insert1.GetItemNumber(ll_currow,"jttime")					/*조퇴시각*/

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

sKtCode = dw_insert1.GetItemString(ll_currow,"ktcode")						/*근태코드*/
sHDGbn  = dw_insert1.GetItemString(ll_currow,"hdaygubn")						/*휴일구분*/

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

iOcCnt = dw_insert1.GetItemNumber(ll_currow,"occnt")						/*외출횟수*/
IF iOcCnt = 0 OR IsNull(iOcCnt) THEN
	dOcTotTime =0
	dOcSilTime =0
	Return
END IF

dFrom = dw_insert1.GetItemNumber(ll_currow,"ocfromtime")						/*외출from시각*/
dTo   = dw_insert1.GetItemNumber(ll_currow,"octotime")							/*외출to시각*/

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

dGetTkTime = dw_insert1.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
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

public subroutine wf_calc_yktime (integer ll_currow, string skmgubn, ref double dyktime);/******************************************************************************************/
/*** 6. 야간시간																									*/
/***    6.1 근무일 TABLE의 '출퇴구분'이 '퇴근'인 자료의 from시간 보다 큰 자료와 근태 TABLE의*/
/***        '퇴근시각'과의 사이중 '급여항목'이 '3'(야간)인 시간을 ADD.							*/
/******************************************************************************************/

Double dTFrom,dMinFrom,dGetTkTime

dGetTkTime = dw_insert1.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
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

dYkTime = wf_get_hangTime(dMinFrom,dGetTkTime,sKmgubn,'3')			/*야간인 자료*/
dYkTime = wf_conv_hhmm(dYkTime)

end subroutine

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

public function double wf_get_hangtime (double dfrom, double dto, string skmgubn, string skhgubn); Double dNoPayTime,dTmpTime

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

	SELECT MAX(DECODE("P4_KUNMU"."TTIMEGUBN",'1',"P4_KUNMU"."TOTIME","P4_KUNMU"."TOTIME" + 2400))
		INTO :dTmpTime  
		FROM "P4_KUNMU"  
		WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				( "P4_KUNMU"."KMGUBN" = :skmgubn ) AND  
				( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400)  >= :dFrom ) AND  
				( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) < :dTo ) AND  
				( "P4_KUNMU"."KHGUBN" = :skhgubn )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		dTmpTime =0
	ELSE
		IF IsNull(dTmpTime) THEN dTmpTime =0
	END IF
	
	Long   iTimeHH_From,iTimeMM_From,iTimeHH_To,iTimeMM_To,&
			 iCalcHH,iCalcMM
	Double dCalc_Time
	
	IF dNoPayTime <=0 THEN
		dNoPayTime = 0
	ELSE	
		iTimeHH_From = Integer(Left(String(dTmpTime,'0000'),2))								/*from시*/
		iTimeMM_From = Integer(Mid(String(dTmpTime,'0000'),3,2))							/*from분*/
		
		iTimeHH_To = Integer(Left(String(dto,'0000'),2))									/*to시*/
		iTimeMM_To = Integer(Mid(String(dto,'0000'),3,2))									/*to분*/
		
		IF dto > dTmpTime then   	
			// 퇴근시간이 인정누적한시간보다 클경우 인정시간은 모두인정
		else	
			IF iTimeMM_From < iTimeMM_To THEN  
				iCalcHH = (iTimeHH_From - 1) - iTimeHH_To
				iCalcMM = (iTimeMM_From - iTimeMM_to) + 60
			ELSE
				iCalcHH = iTimeHH_From - iTimeHH_To
				iCalcMM = iTimeMM_From - iTimeMM_To
			END IF
			dCalc_Time = (iCalcHH * 60) + iCalcMM
 			dNoPayTime = dNoPayTime - dCalc_Time
		END IF	
	END IF
END IF

Return dNoPayTime

end function

public function double wf_use_time (double dfromtime, double dtotime, string sflag);/*********************************************************************/
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
      
IF sflag ='TIME' THEN
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

public function integer wf_enabled_chk (integer ll_currow, string sempno);/************************************************************************************/
/* 일근태 table의 자료 중 처리 가능 자료 체크													*/
/************************************************************************************/
String sKjGbn,sKmGbn,sKtCode
Long   ilTimeS,ilTimeE

IF ll_currow <=0 THEN											/*일근태 자료 없으면 ERROR*/
	wf_create_error(sEmpNo,'KUNTAE')
	Return -1
END IF
	
ilTimeS = dw_insert1.GetItemNumber(ll_currow,"cktime")		/*출근시각*/
ilTimeE = dw_insert1.GetItemNumber(ll_currow,"tktime")		/*퇴근시각*/
sKtCode = dw_insert1.GetItemString(ll_currow,"ktcode")		/*근태코드*/

IF sKtCode ="" OR IsNull(sKtCode) THEN
	IF ilTimeS = 0 AND ilTimeE <> 0 THEN							/*출근*/
		wf_create_error(sEmpNo,'CKTIME')
		Return -1
	ELSEIF ilTimeS <> 0 AND ilTimeE = 0 THEN						/*퇴근*/
		wf_create_error(sEmpNo,'TKTIME')
		Return -1
	ELSEIF ilTimeS = 0 OR ilTimeE = 0 THEN							/*출퇴근시각이 없으면 ERROR*/
		wf_create_error(sEmpNo,'ALLTIME')
		Return -1
	END IF
END IF

//sKjGbn = dw_insert1.GetItemString(ll_currow,"kjgubn2")		/*연장내역결재구분*/
//IF sProcGbn = 'Y' AND sKjGbn = 'N' THEN						/*결재처리시 연장내역이 미결재면 ERROR*/
//	wf_create_error(sEmpNo,'KJ')
//	Return -1
//END IF
//
//IF sProcGbn = 'N' AND sKjGbn ='Y' THEN 						/*미결재처리시 결재내역은 SKIP*/
//	Return -1
//END IF

sKmGbn  = dw_insert1.GetItemString(ll_currow,"kmgubn")		/*근무일구분*/
IF sKmGbn = "" OR IsNull(sKmGbn) THEN							
	wf_create_error(sEmpNo,'KMGU')
	Return -1
END IF

Return 1
end function

public subroutine wf_setsqlsyntax (string sflag);//
//Int    k 
//String sGetSqlSyntax,sEmpNo,sProcPos
//Long   lSyntaxLength
//
//IF sFlag = 'CREATE' THEN
//	dw_cond.AcceptText()
//	sProcPos = dw_cond.GetItemString(1,"proc_pos")
//	
//	IF sProcPos = 'T' OR sProcPos = 'D' THEN
//		dw_Process = dw_total
//		il_RowCount = dw_total.RowCount()
//	ELSE
//		dw_Process = dw_personal
//		il_RowCount = dw_personal.RowCount()
//	END IF
//	
//	dw_insert1.DataObject ='d_pik10053'
//	dw_insert1.SetTransObject(SQLCA)
//	dw_insert1.Reset()
//	
//	sGetSqlSyntax = dw_insert1.GetSqlSelect()
//	
//	sGetSqlSyntax = sGetSqlSyntax + "WHERE ("
//	
//	dw_Process.AcceptText()
//	
//	FOR k = 1 TO il_rowcount
//		
//		sEmpNo = dw_Process.GetItemString(k,"empno")
//		
//		sGetSqlSyntax = sGetSqlSyntax + ' "P4_DKENTAE"."EMPNO" =' + "'"+ sEmpNo +"'"+ ' OR'
//		
//	NEXT
//	
//	lSyntaxLength = len(sGetSqlSyntax)
//	sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
//	
//	sGetSqlSyntax = sGetSqlSyntax + ")"
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."COMPANYCODE" = ' + "'" + gs_company +"'"+")"
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KDATE" = ' + "'" + sprocdate +"'"+")"
//	
//	dw_insert1.SetSQLSelect(sGetSqlSyntax)	
//ELSE
//	String sCalcDate
//	
//	dw_cond.AcceptText()
//	sProcPos  = dw_cond.GetItemString(1,"proc_pos")
//	sCalcDate = dw_cond.GetItemString(1,"beforedate")
//	
//	IF sProcPos = 'T' OR sProcPos = 'D' THEN
//		dw_Process = dw_total
//		il_RowCount = dw_total.RowCount()
//	ELSE
//		dw_Process = dw_personal
//		il_RowCount = dw_personal.RowCount()
//	END IF
//	
//	dw_insert1.DataObject ='d_pik10053'
//	dw_insert1.SetTransObject(SQLCA)
//	dw_insert1.Reset()
//	
//	sGetSqlSyntax = dw_insert1.GetSqlSelect()
//	
//	sGetSqlSyntax = sGetSqlSyntax + "WHERE ("
//	
//	dw_Process.AcceptText()
//	
//	FOR k = 1 TO il_rowcount
//		
//		sEmpNo = dw_Process.GetItemString(k,"empno")
//		
//		sGetSqlSyntax = sGetSqlSyntax + ' "P4_DKENTAE"."EMPNO" =' + "'"+ sEmpNo +"'"+ ' OR'
//		
//	NEXT
//	
//	lSyntaxLength = len(sGetSqlSyntax)
//	sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
//	
//	sGetSqlSyntax = sGetSqlSyntax + ")"
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."COMPANYCODE" = ' + "'" + gs_company +"'"+")"
//	sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KDATE" = ' + "'" + scalcdate +"'"+")"
//	
//	dw_insert1.SetSQLSelect(sGetSqlSyntax)	
//
//END IF
//
//
//
//
end subroutine

public function string wf_proceduresql (string sflag);//
//Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos,sSpace,sJikGbn,ls_date
//Long   lSyntaxLength
//
//dw_cond.AcceptText()
//sProcPos = dw_cond.GetItemString(1,"proc_pos")
//ls_date  = dw_cond.GetItemString(1,"beforedate")
//sProcDept= dw_cond.GetItemString(1,"deptcode") 
//
//IF sProcPos = 'T' OR sProcPos = 'D' THEN
//	dw_Process = dw_total
//	il_RowCount = dw_total.RowCount()
//ELSE
//	dw_Process = dw_personal
//	il_RowCount = dw_personal.RowCount()
//END IF
//
//IF sProcDept ="" OR IsNull(sProcDept) THEN
//	sProcDept ='%'
//END IF
//
////sSpace = ' '
//IF SFLAG = 'TIME' THEN
//	sGetSqlSyntax = 'select p1_master.empno,p1_master.jikjonggubn,p1_master.jhgubn,p1_master.jhtgubn from p1_master'
//ELSE
//	sGetSqlSyntax = 'select p1_master.empno from p1_master'
//END IF
//
////sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.retiredate = '+ "'"+sSpace +"'"+" ) OR "
////sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.retiredate >= '+ "'"+ls_date +"'"+" )) AND "
////sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.deptcode LIKE '+ "'"+sprocdept +"'"+" ) AND "
//
//dw_Process.AcceptText()
//
//sGetSqlSyntax = sGetSqlSyntax + ' WHERE ('
//
//FOR k = 1 TO il_rowcount
//	
//	sEmpNo = dw_Process.GetItemString(k,"empno")
//	
//	sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.empno =' + "'"+ sEmpNo +"')"+ ' OR'
//	
//NEXT
//
//lSyntaxLength = len(sGetSqlSyntax)
//sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
//
//sGetSqlSyntax = sGetSqlSyntax + ")"
//
////sGetSqlSyntax = sGetSqlSyntax + 'AND (p1_master.companycode = ' + "'" + gs_company +"'"+")"
//
Return sGetSqlSynTax
//
//
end function

public function integer wf_fileopen ();

if FileLength(sprocfile) = -1 then
	MessageBox("화일 오류", "작업할 화일이 존재하지 않습니다?")
	return -1
end if


ii_fileID = FileOpen(sprocfile, LineMode!)
if ii_fileID = -1 then
	MessageBox("화일,폴더 오류", "화일및 폴더지정이 올바른지 확인하십시요.")
	return -1
end if





return 1
end function

public function integer wf_fileread ();string  il_Input_Data , sCode,sYymmdd, stime, sEmpno,sTimeS,sTimeE ,MaxDate , sYy
integer li_bytes, Return_Value, il_count


Return_Value = FileRead( ii_fileid, il_Input_Data)
DO WHILE Return_Value > 0
	IF sgubn = '1' THEN
		sCode   = mid(il_input_data,4,1)                      /*출퇴근구분 */
		sYymmdd = mid(il_input_data,7,8)      					   /*일자*/
		stime   = string(Integer(mid(il_input_data,15,4)), "0000")		/*시간*/
		sEmpno  = mid(il_input_data,19,6)	  	               /*사번*/
	ELSE
		sCode   = mid(il_input_data,4,1)                      /*출퇴근구분 */
		sYy     = mid(il_input_data,7,2)      					   /*년도*/
		IF sYy < '99' THEN
			sYymmdd = '20' + mid(il_input_data,7,6)			   /*일자*/	
		ELSE
			sYymmdd = '19' + mid(il_input_data,7,6)			   /*일자*/	
		END IF	
		stime   = string(Integer(mid(il_input_data,13,4)), "0000")		/*시간*/
		sEmpno  = mid(il_input_data,17,6)	  	               /*사번*/
	END IF	
	
//	
	CHOOSE CASE sCode
			 CASE '0'  /*퇴근*/
					IF stime = '0000' THEN
						sTime = '0001'
					END IF	
					IF sTime <= '1000' THEN    /*전일퇴근시간 */
						SELECT MAX("P4_DKENTAE"."KDATE")  
    					  INTO :MaxDate  
					     FROM "P4_DKENTAE"  
					    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
							    ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
					          ( "P4_DKENTAE"."KDATE" < :sYymmdd )   ;
 						 IF SQLCA.SQLCODE <> 0 OR IsNull(MaxDate)  THEN
							 MaxDate =  sYymmdd 	
						 END IF
						 wf_data_create(sEmpno, MaxDate,long(sTime), '0')	
					ELSE	 
						 wf_data_create(sEmpno, sYymmdd,long(sTime), '0')	 						 
					END IF	 
			 CASE '1'  /*출근*/
						 wf_data_create(sEmpno, sYymmdd,long(sTime), '1')
			 CASE '2'  /*외출*/
						 wf_data_create(sEmpno, sYymmdd,long(sTime), '2')				
			 CASE '3'  /*귀사*/
						 wf_data_create(sEmpno, sYymmdd,long(sTime), '3')								
			 CASE '4'  /*조퇴*/	
						 wf_data_create(sEmpno, sYymmdd,long(sTime), '4')				 
END CHOOSE
il_count = il_count + 1	
Return_Value = FileRead( ii_fileid, il_Input_Data)
LOOP

return il_count

end function

public subroutine wf_data_create (string sempno, string sdate, long stime, string lgubn);
string eData, sKTCode ,sDeptCode, sKMGubn,sAddDept,sHDayGubn,sJKGubn, sJTGubn 

long sJKTime ,sOCcnt ,sOCFromTime,sOCToTime,sJTTime, sFromTime

//인사자료(부서코드) 
  SELECT "P1_MASTER"."DEPTCODE" , "P1_MASTER"."ADDDEPTCODE" 
    INTO :sDeptCode ,:sAddDept
    FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_MASTER"."EMPNO" = :sEmpno )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		sDeptCode  = ''
	END IF	
			
//기타자료(근무일구분,휴일구분,근무일별 출근시간)
	  SELECT "P4_CALENDAR"."HDAYGUBN" 
	    INTO :sHDayGubn 
  		 FROM "P4_CALENDAR"   
      WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P4_CALENDAR"."CLDATE" = :sDate )     ;
			  
	  IF SQLCA.SQLCODE <> 0 THEN
		  sHDayGubn  = ''
	  END IF		
	  
	  SELECT "P4_PERKUNMU"."KMGUBN","P4_KUNMU"."FROMTIME"  
	  	 INTO :sKMGubn , :sFromTime	
		 FROM "P4_PERKUNMU" , "P4_KUNMU"
	   WHERE ( "P4_PERKUNMU"."COMPANYCODE" = :gs_company ) AND  
   			( "P4_PERKUNMU"."EMPNO" = :sEmpno ) AND  
	         ( "P4_PERKUNMU"."KDATE" = :sDate ) AND
		  		( "P4_PERKUNMU"."KMGUBN"= "P4_KUNMU"."KMGUBN" ) AND
				( "P4_KUNMU"."CTGUBN" = '1')  ;
			  
	  IF SQLCA.SQLCODE <> 0 THEN
		  sKMGubn    = ''
		  sFromTime	 = 0		  
	  END IF			  

//기존자료 존재 여부 check
SELECT  empno ,  ktcode
  INTO :eData , :sKTCode
  FROM "P4_DKENTAE"  
 WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
  	    ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
       ( "P4_DKENTAE"."KDATE" = :sdate )   ;
IF SQLCA.SQLCODE <> 0 THEN
	eData    = '' 
	sKTCode  = ''
ELSEIF 	IsNull(sKTCode) THEN
	sKTCode  = ''
END IF	
		 
IF lgubn= '0' THEN /* 퇴근시간갱신 */
	  
		IF eData = '' OR  IsNull(eData) THEN 
			INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE","DEPTCODE" ,"EMPNO"   ,"KDATE"   ,"KTCODE"    ,"KMGUBN"  ,"HDAYGUBN",   
         			  "JKGUBN"     ,"JKGTIME"  ,"JKTIME"  ,"OCCNT"   ,"OCFROMTIME","OCTOTIME","OCGTTIME",   
			           "OCGGTIME"   ,"JTGUBN"   ,"JTGKTIME","JTGYTIME","JTTIME"    ,"CKTIME"  ,"TKTIME",   
                    "OKFROMTIME" ,"OKTOTIME" ,"KLGTIME" ,"YJGTIME" ,"YKGTIME"   ,"HKGTIME" ,"HKYJGTIME",   
			           "HKCYGTIME"  ,"BIGO"     ,"KJGUBN1" ,"KJGUBN2" ,"KJGUBN3"   ,"DKTIME"  ,"DKGTIME",   
				        "PRTDEPT"    ,"USECARTAG","TOPLACE" ,"HKGTIME2","HKGTIME3" )  
			  VALUES ( :gs_company  ,:sDeptCode ,:sEmpno   ,:sdate    ,''          ,:sKMGubn  ,:sHDayGubn,   
			           '0'	   	   ,0          ,0         ,0		    ,0           ,0         ,0         ,   
			           0            ,'0'        ,0         ,0         ,0           ,0         ,:sTime    ,   
			           0            ,0          ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,''         ,'N'       ,'N'       ,'N'         ,0         ,0         ,   
			           :sAddDept    ,''         ,''        ,0         ,0 )  ;
		ELSE
			UPDATE "P4_DKENTAE"  
			   SET "TKTIME" = :sTime 
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF			 
ELSEIF lgubn= '1' THEN /* 출근시간갱신 */	
	   IF sHDayGubn = '0' THEN 
	   	/*지각여부CHECK*/
		   IF sTime > sFromTime  THEN
			   sJKGubn    =  '1'
		  		sJKTime    =  sTime 
			ELSE		
				sJKGubn    =  '0'
			   sJKTime    =  0
			END IF	
		ELSE
			sJKGubn    =  '0'
		   sJKTime    =  0
		END IF	
		IF eData = '' OR  IsNull(eData) THEN 	
			  INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE","DEPTCODE" ,"EMPNO"   ,"KDATE"   ,"KTCODE"    ,"KMGUBN"  ,"HDAYGUBN",   
         			  "JKGUBN"     ,"JKGTIME"  ,"JKTIME"  ,"OCCNT"   ,"OCFROMTIME","OCTOTIME","OCGTTIME",   
			           "OCGGTIME"   ,"JTGUBN"   ,"JTGKTIME","JTGYTIME","JTTIME"    ,"CKTIME"  ,"TKTIME",   
                    "OKFROMTIME" ,"OKTOTIME" ,"KLGTIME" ,"YJGTIME" ,"YKGTIME"   ,"HKGTIME" ,"HKYJGTIME",   
			           "HKCYGTIME"  ,"BIGO"     ,"KJGUBN1" ,"KJGUBN2" ,"KJGUBN3"   ,"DKTIME"  ,"DKGTIME",   
				        "PRTDEPT"    ,"USECARTAG","TOPLACE" ,"HKGTIME2","HKGTIME3" )  
			  VALUES ( :gs_company  ,:sDeptCode ,:sEmpno   ,:sdate    ,''          ,:sKMGubn  ,:sHDayGubn,   
			           :sJKGubn     ,0          ,:sJKTime  ,0   		 ,0           ,0         ,0         ,   
			           0            ,'0'  	   ,0         ,0         ,0           ,:sTime    ,0         ,   
			           0            ,0          ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,''         ,'N'       ,'N'       ,'N'         ,0         ,0         ,   
			           :sAddDept    ,''         ,''        ,0         ,0 )  ;
		ELSE
			 UPDATE "P4_DKENTAE"  
				 SET "KMGUBN" = :skmgubn,"HDAYGUBN" = :shdaygubn,"JKGUBN" = :Sjkgubn,"JKTIME" = :Sjktime,   
			        "CKTIME" = :sTime   
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF			 
ELSEIF lgubn= '2' THEN /* 외출(from)시간갱신 */	
		IF eData = '' OR  IsNull(eData) THEN 	
			  INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE","DEPTCODE" ,"EMPNO"   ,"KDATE"   ,"KTCODE"    ,"KMGUBN"  ,"HDAYGUBN",   
         			  "JKGUBN"     ,"JKGTIME"  ,"JKTIME"  ,"OCCNT"   ,"OCFROMTIME","OCTOTIME","OCGTTIME",   
			           "OCGGTIME"   ,"JTGUBN"   ,"JTGKTIME","JTGYTIME","JTTIME"    ,"CKTIME"  ,"TKTIME",   
                    "OKFROMTIME" ,"OKTOTIME" ,"KLGTIME" ,"YJGTIME" ,"YKGTIME"   ,"HKGTIME" ,"HKYJGTIME",   
			           "HKCYGTIME"  ,"BIGO"     ,"KJGUBN1" ,"KJGUBN2" ,"KJGUBN3"   ,"DKTIME"  ,"DKGTIME",   
				        "PRTDEPT"    ,"USECARTAG","TOPLACE" ,"HKGTIME2","HKGTIME3" )  
			  VALUES ( :gs_company  ,:sDeptCode ,:sEmpno   ,:sdate    ,''          ,:sKMGubn  ,:sHDayGubn,   
			           '0'          ,0          ,0         ,1         ,:sTime		  ,0         ,0         ,   
			           0            ,'0'        ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,0          ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,''         ,'N'       ,'N'       ,'N'         ,0         ,0         ,   
			           :sAddDept    ,''         ,''        ,0         ,0 )  ;
		ELSE
			 UPDATE "P4_DKENTAE"  
				 SET "KMGUBN" = :skmgubn,"HDAYGUBN" = :shdaygubn,   "OCCNT" = 1,   
			        "OCFROMTIME" = :sTime   
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF			 		
ELSEIF lgubn= '3' THEN /* 외출(to)시간갱신 */	
		IF eData = '' OR  IsNull(eData) THEN 	
			  INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE","DEPTCODE" ,"EMPNO"   ,"KDATE"   ,"KTCODE"    ,"KMGUBN"  ,"HDAYGUBN",   
         			  "JKGUBN"     ,"JKGTIME"  ,"JKTIME"  ,"OCCNT"   ,"OCFROMTIME","OCTOTIME","OCGTTIME",   
			           "OCGGTIME"   ,"JTGUBN"   ,"JTGKTIME","JTGYTIME","JTTIME"    ,"CKTIME"  ,"TKTIME",   
                    "OKFROMTIME" ,"OKTOTIME" ,"KLGTIME" ,"YJGTIME" ,"YKGTIME"   ,"HKGTIME" ,"HKYJGTIME",   
			           "HKCYGTIME"  ,"BIGO"     ,"KJGUBN1" ,"KJGUBN2" ,"KJGUBN3"   ,"DKTIME"  ,"DKGTIME",   
				        "PRTDEPT"    ,"USECARTAG","TOPLACE" ,"HKGTIME2","HKGTIME3" )  
			  VALUES ( :gs_company  ,:sDeptCode ,:sEmpno   ,:sdate    ,''          ,:sKMGubn  ,:sHDayGubn,   
			           '0'          ,0          ,0         ,1         ,0		     ,:sTime    ,0         ,   
			           0            ,'0'        ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,0          ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,''         ,'N'       ,'N'       ,'N'         ,0         ,0         ,   
			           :sAddDept    ,''         ,''        ,0         ,0 )  ;
		ELSE
			 UPDATE "P4_DKENTAE"  
				 SET "KMGUBN" = :skmgubn,"HDAYGUBN" = :shdaygubn,"OCCNT"= 1,
				 	  "OCTOTIME" = :sTime  
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF
ELSEIF lgubn= '4' THEN /* 조퇴시간(퇴근시간)갱신 */	
		IF eData = '' OR  IsNull(eData) THEN 	
			  INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE","DEPTCODE" ,"EMPNO"   ,"KDATE"   ,"KTCODE"    ,"KMGUBN"  ,"HDAYGUBN",   
         			  "JKGUBN"     ,"JKGTIME"  ,"JKTIME"  ,"OCCNT"   ,"OCFROMTIME","OCTOTIME","OCGTTIME",   
			           "OCGGTIME"   ,"JTGUBN"   ,"JTGKTIME","JTGYTIME","JTTIME"    ,"CKTIME"  ,"TKTIME",   
                    "OKFROMTIME" ,"OKTOTIME" ,"KLGTIME" ,"YJGTIME" ,"YKGTIME"   ,"HKGTIME" ,"HKYJGTIME",   
			           "HKCYGTIME"  ,"BIGO"     ,"KJGUBN1" ,"KJGUBN2" ,"KJGUBN3"   ,"DKTIME"  ,"DKGTIME",   
				        "PRTDEPT"    ,"USECARTAG","TOPLACE" ,"HKGTIME2","HKGTIME3" )  
			  VALUES ( :gs_company  ,:sDeptCode ,:sEmpno   ,:sdate    ,''          ,:sKMGubn  ,:sHDayGubn,   
			           '0'          ,0          ,0         ,0         ,0		     ,0		    ,0         ,   
			           0            ,'1'        ,0         ,0         ,:sTime      ,0		    ,:sTime    ,   
			           0            ,0          ,0         ,0         ,0           ,0         ,0         ,   
			           0            ,''         ,'N'       ,'N'       ,'N'         ,0         ,0         ,   
			           :sAddDept    ,''         ,''        ,0         ,0 )  ;
		ELSE
			 UPDATE "P4_DKENTAE"  
				 SET "KMGUBN" = :skmgubn,"HDAYGUBN" = :shdaygubn,"JTGUBN"= '1',
				 	  "JTTIME" = :sTime , "TKTIME" = :sTime 
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF		
END IF	
IF SQLCA.SQLCODE <> 0 then
	ROLLBACK;
ELSE
	COMMIT;
END IF	
end subroutine

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

dGetTkTime = dw_insert1.GetItemNumber(ll_currow,"tktime")						/*퇴근시각*/
dGetCkTime = dw_insert1.GetItemNumber(ll_currow,"cktime")						/*출근시각*/

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

sKtCode = dw_insert1.GetItemString(ll_currow,"ktcode")						/*근태코드*/
sHDGbn  = dw_insert1.GetItemString(ll_currow,"hdaygubn")					/*휴일구분*/

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

on w_pik1019.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_maxdate=create dw_maxdate
this.dw_update=create dw_update
this.dw_insert1=create dw_insert1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_maxdate
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.dw_insert1
end on

on w_pik1019.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_maxdate)
destroy(this.dw_update)
destroy(this.dw_insert1)
end on

event open;call super::open;String sDayGbn,sHDayGbn,sDeptName,sGetSysDept,sStartTime,sEndTime,sBefore_Date
dw_insert1.SetTransObject(SQLCA)
dw_update.SetTransObject(SQLCA)
dw_maxdate.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

SELECT "P4_CALENDAR"."DAYGUBN",   "P4_CALENDAR"."HDAYGUBN"  			/*요일,휴일구분*/
	INTO :sDayGbn,   :sHDayGbn  
   FROM "P4_CALENDAR"  
   WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_CALENDAR"."CLDATE" = :gs_today )   ;

dw_cond.SetItem(1,"kdate",gs_today)
dw_cond.SetItem(1,"p4_calendar_daygubn",sDayGbn)
dw_cond.SetItem(1,"p4_calendar_hdaygubn",sHDayGbn)
//dw_cond.setitem(1,"proc_file", 'c:\erpman\pi\kw990504.txt')

dw_cond.SetColumn("kdate")
dw_cond.SetFocus()




end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1019
boolean visible = false
integer x = 3314
integer y = 3004
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1019
boolean visible = false
integer x = 3141
integer y = 3004
end type

type p_search from w_inherite_multi`p_search within w_pik1019
boolean visible = false
integer x = 2446
integer y = 3004
end type

type p_ins from w_inherite_multi`p_ins within w_pik1019
boolean visible = false
integer x = 2967
integer y = 3004
end type

type p_exit from w_inherite_multi`p_exit within w_pik1019
integer x = 4421
end type

type p_can from w_inherite_multi`p_can within w_pik1019
boolean visible = false
integer x = 3671
integer y = 3004
end type

type p_print from w_inherite_multi`p_print within w_pik1019
boolean visible = false
integer x = 2619
integer y = 3004
end type

type p_inq from w_inherite_multi`p_inq within w_pik1019
boolean visible = false
integer x = 2793
integer y = 3004
end type

type p_del from w_inherite_multi`p_del within w_pik1019
boolean visible = false
integer x = 3497
integer y = 3004
end type

type p_mod from w_inherite_multi`p_mod within w_pik1019
integer x = 4247
end type

event p_mod::clicked;call super::clicked;/******************************************************************************************/
/*** 일근태 출퇴근 시간 일괄 생성      																	*/
/******************************************************************************************/

Int     il_meterPosition,k,il_ReturnValue,il_CurRow,il_Count,iMaxSeq
String  sCopy,temp_value

// 월마감작업후 월근태 집계처리 못함
string ls_flag, ls_yymm
ls_yymm = left(sprocdate,6)

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = :ls_yymm ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	
 
dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF


w_mdi_frame.sle_msg.text = '일근태 작성 중......'
SetPointer(HourGlass!)

sprocfile = dw_cond.GetItemString(1,"proc_file")
sgubn = dw_cond.GetItemString(1,"gubn")



IF wf_fileopen() <> 1 THEN RETURN
temp_value =left(il_filename,1)
if left(il_filename,1) = 'K' or left(il_filename,1) = 'k' then
	sgubn = '1'
else
	sgubn = '0'
END IF	
IF wf_fileread() <  1 THEN
	MessageBox("확 인","근태 생성 실패!!")
	Rollback;
	SetPointer(Arrow!)
	sle_msg.text =''
	Return
END IF

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ='일근태 자료 생성 완료!!'

//sCopy = 'c:\erpman\pi\foo.bat ' + trim(sprocfile)
//il_ReturnValue= RUN(sCopy,  Minimized!)
//il_ReturnValue= RUN("C:\orawin95\bin\sqlldr80 erpman2/erpman2@erpman control=c:\erpman\pi\foo.ctl", Minimized!)
//
//IF il_ReturnValue = 1 THEN
//	cb_process.TriggerEvent(Clicked!)
//ELSE	
//	MessageBox("확 인","근태 생성 실패!!")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//END IF
//
//
end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1019
boolean visible = false
integer x = 3666
integer y = 2788
end type

type st_window from w_inherite_multi`st_window within w_pik1019
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pik1019
boolean visible = false
integer x = 599
integer y = 3564
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1019
boolean visible = false
integer x = 3168
integer y = 2604
end type

type cb_update from w_inherite_multi`cb_update within w_pik1019
boolean visible = false
integer x = 2071
integer y = 2604
end type

type cb_insert from w_inherite_multi`cb_insert within w_pik1019
boolean visible = false
integer x = 965
integer y = 3564
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1019
boolean visible = false
integer x = 2437
integer y = 2604
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1019
boolean visible = false
integer x = 233
integer y = 3564
end type

type st_1 from w_inherite_multi`st_1 within w_pik1019
boolean visible = false
integer x = 169
integer y = 3736
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1019
boolean visible = false
integer x = 2802
integer y = 2604
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1019
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1019
boolean visible = false
integer x = 498
integer y = 3736
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1019
boolean visible = false
integer x = 2030
integer y = 2544
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1019
boolean visible = false
integer x = 187
integer y = 3504
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1019
boolean visible = false
integer x = 151
integer y = 3684
end type

type dw_cond from u_key_enter within w_pik1019
integer x = 1143
integer y = 732
integer width = 2176
integer height = 588
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1019_1"
boolean border = false
end type

event itemerror;
Return 1
end event

event itemchanged;
String sDayGbn,sHDayGbn,sDeptCode,sDeptName,sProcGbn,sBefore_Date,snull

SetNull(snull)

this.AcceptText()
IF this.GetColumnName() = "kdate" THEN
	sProcDate = Trim(this.GetText())
	
	IF sProcDate = "" OR IsNull(sProcDate) THEN 
		dw_cond.SetItem(1,"p4_calendar_daygubn",snull)
		dw_cond.SetItem(1,"p4_calendar_hdaygubn",snull)
		RETURN
	END IF
	
	IF f_datechk(sProcDate) = -1 THEN
		MessageBox("확 인","유효한 날짜가 아닙니다!!")
		dw_cond.SetItem(1,"kdate",snull)
		dw_cond.SetItem(1,"p4_calendar_daygubn",snull)
		dw_cond.SetItem(1,"p4_calendar_hdaygubn",snull)
		Return 1
	END IF
	
	SELECT "P4_CALENDAR"."DAYGUBN",   "P4_CALENDAR"."HDAYGUBN"  
		INTO :sDayGbn,   					 :sHDayGbn  
   	FROM "P4_CALENDAR"  
   	WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P4_CALENDAR"."CLDATE" = :sProcDate )   ;
	IF SQLCA.SQLCODE = 0 THEN
		dw_cond.SetItem(1,"p4_calendar_daygubn",sDayGbn)
		dw_cond.SetItem(1,"p4_calendar_hdaygubn",sHDayGbn)
	ELSE
		dw_cond.SetItem(1,"p4_calendar_daygubn",snull)
		dw_cond.SetItem(1,"p4_calendar_hdaygubn",snull)
	END IF
END IF


end event

event getfocus;this.AcceptText()
end event

event rbuttondown;integer fh, ret

blob Emp_pic
string txtname, named
string defext = "TXT"
string Filter = "txt Files (*.txt), *.txt"

	ret = GetFileOpenName("Open Text", txtname, named, defext, filter)
	
	IF ret = 1 THEN
      this.setitem(this.getrow(), 'proc_file', txtname)
	END IF

end event

event buttonclicking;integer fh, ret

blob Emp_pic
string txtname 
string defext = "TXT"
string Filter = "txt Files (*.txt), *.txt"

	ret = GetFileOpenName("Open Text", txtname, il_filename, defext, filter)
	
	IF ret = 1 THEN
      this.setitem(this.getrow(), 'proc_file', txtname)
	END IF

end event

type dw_maxdate from datawindow within w_pik1019
boolean visible = false
integer x = 306
integer y = 3500
integer width = 978
integer height = 108
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "근태일자 이전 최근 근태생성일자"
string dataobject = "d_pik10055"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_update from datawindow within w_pik1019
boolean visible = false
integer x = 1294
integer y = 3504
integer width = 681
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "일근태저장(퇴근)"
string dataobject = "d_pik1019_3"
boolean resizable = true
boolean livescroll = true
end type

type dw_insert1 from datawindow within w_pik1019
boolean visible = false
integer x = 306
integer y = 3620
integer width = 608
integer height = 104
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "일근태 저장(출근)"
string dataobject = "d_pik1019_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

