$PBExportHeader$w_kfia27.srw
$PBExportComments$일자금수지 계획/실적 집계
forward
global type w_kfia27 from w_inherite
end type
type dw_cond from datawindow within w_kfia27
end type
type cb_6 from commandbutton within w_kfia27
end type
type gb_1 from groupbox within w_kfia27
end type
type st_2 from statictext within w_kfia27
end type
type uo_progress from u_progress_bar within w_kfia27
end type
type dw_lst from datawindow within w_kfia27
end type
type dw_detail from datawindow within w_kfia27
end type
type dw_update from datawindow within w_kfia27
end type
type dw_planlst from datawindow within w_kfia27
end type
end forward

global type w_kfia27 from w_inherite
string title = "일자금수지 계획/실적 집계"
dw_cond dw_cond
cb_6 cb_6
gb_1 gb_1
st_2 st_2
uo_progress uo_progress
dw_lst dw_lst
dw_detail dw_detail
dw_update dw_update
dw_planlst dw_planlst
end type
global w_kfia27 w_kfia27

type variables
String ls_saupj,ls_yy,ls_add_yy
Boolean continue_flag =True
Double ldb_dangi_amt
end variables

forward prototypes
public function integer wf_upcross (string scurdate)
public function integer wf_calculation_1 (string sfrom, string sto)
public function integer wf_calculation_2 (string sfrom, string sto)
public function integer wf_clear_kfm11ot0 (string saccdatef, string saccdatet, string sflag)
public function integer wf_create_kfm11ot0 (string sfrom, string sto)
public function integer wf_auto_calculation (string scurdate)
end prototypes

public function integer wf_upcross (string scurdate);
Int il_Count
String sFin_cd,test_cd
Double dac_tot,dpl_tot  

DECLARE cur_kfm11ot0 CURSOR FOR  
	SELECT "KFM10OM0"."FINANCE_CD"  
   	FROM "KFM10OM0"  
	 	WHERE "KFM10OM0"."AUTO_CD" = 'C' 
		ORDER BY "KFM10OM0"."FINANCE_CD" ASC;

open cur_kfm11ot0;

DO WHILE true
	FETCH cur_kfm11ot0 INTO :sfin_cd ;
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT	
	
	SELECT SUM(NVL(B.PLAN_AMT,0)), SUM(NVL(B.ACTUAL_AMT,0))      INTO :dpl_tot, :dac_tot
		FROM ( SELECT *
      	       FROM "KFM10OM0" 
         		 	CONNECT BY PRIOR "KFM10OM0"."FINANCE_CD" = "KFM10OM0"."SFIN_CD"  
                	START WITH "KFM10OM0"."SFIN_CD" = :sfin_cd ) A, 
           "KFM11OT0" B 
		WHERE A.FINANCE_CD = B.FINANCE_CD AND 
		      A.AUTO_CD = 'N' AND 
			 B.FINANCE_DATE = :sCurDate;
	IF SQLCA.SQLCODE <> 0 THEN	Return -1
	IF IsNull(dPl_Tot) THEN dPl_Tot = 0
	IF IsNull(dAc_Tot) THEN dAc_Tot = 0
	
	SELECT "KFM11OT0"."FINANCE_CD"            INTO :test_cd  
		FROM "KFM11OT0"  
      WHERE ( "KFM11OT0"."FINANCE_CD" = :sfin_cd ) AND ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
		
  	IF sqlca.sqlcode = 0 THEN	
	   UPDATE "KFM11OT0"  
		   SET "PLAN_AMT" = :dpl_tot,
				 "ACTUAL_AMT" = :dac_tot   
      	WHERE ( "KFM11OT0"."FINANCE_CD" = :sfin_cd ) AND  
         	   ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
	   IF SQLCA.SQLCODE <> 0 THEN	Return -1	
	ELSEIF sqlca.sqlcode = 100 THEN
		INSERT INTO "KFM11OT0"
			( "FINANCE_CD", "FINANCE_DATE", "PLAN_AMT", "ACTUAL_AMT" )  
      VALUES ( :sfin_cd, :sCurDate,      :dpl_tot,   :dac_tot ) ;
      IF SQLCA.SQLCODE <> 0 THEN	Return -1
	ELSE
	   Return -1
   END IF
LOOP
close cur_kfm11ot0;

Return 1

end function

public function integer wf_calculation_1 (string sfrom, string sto);/*현금유관 계정의 전표 자료를 자금수지 실적에 집계함.             */
/*환경파일(A-30-1)의 자료가 '1'(전표에 직접 입력)로 설정          */

/****************************************************************************************/
/*   일자금 실적을 집계합니다!!																			 */
/* 1. 갱신 테이블 : 일자금실적(KFM11OT0)																 */
/* 2. 처리																										 */
/*    1. 처리일자의 승인 전표 중 계정과목마스타에 현금유관계정 = 'Y'인 전표를 조회한다. */
/*    2. 1)의 미승인전표번호로 자금수지상세 내역을 조회하여 집계한다.						 */
/****************************************************************************************/
Double    dAmount
Integer   iRowCount,i,il_meterposition,iFindRow,iCurRow
String    sFinCode,sAccDate

iRowCount = dw_lst.RowCount()

dw_update.Retrieve(sFrom,sTo)					/*기존의 일집계 자료 조회*/

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "일자금실적 마감 집계 중......"

uo_progress.Show()

FOR i = 1 TO iRowCount
	sAccDate = dw_lst.GetItemString(i,"acc_date") 
	sFinCode = dw_lst.GetItemString(i,"finance_cd") 
	dAmount  = dw_lst.GetItemNumber(i,"amount")
	
	IF IsNull(dAmount) THEN dAmount = 0
	IF sFinCode = "" OR IsNull(sFinCode) THEN Continue
	
	il_meterPosition = (i / iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
		
	iFindRow = dw_update.Find("finance_cd ='" + sFinCode + "' and finance_date = '"+sAccDate+"'",1, dw_update.RowCount())
		
	IF iFindRow > 0 THEN
		dw_update.SetItem(iFindRow,"actual_amt",  &
									dw_update.GetItemNumber(iFindRow,"actual_amt") + dAmount)
	ELSE
		iCurRow = dw_update.InsertRow(0)
		dw_update.SetItem(iCurRow,"finance_cd",  sFinCode)
		dw_update.SetItem(iCurRow,"finance_date",sAccDate)
		dw_update.SetItem(iCurRow,"actual_amt",  dAmount)
	END IF
NEXT

IF dw_update.Update() <> 1 THEN
	F_MessageChk(13,'[일집계]')
	Rollback;
	Return -1
END IF

Return 1
end function

public function integer wf_calculation_2 (string sfrom, string sto);/*현금유관 계정의 전표 자료를 자금수지 실적에 집계함.             			*/
/*환경파일(A-30-1)의 자료가 '2'(계정과목마스타의 자금코드)로 설정          */

/****************************************************************************************/
/*   일자금 실적을 집계합니다!!																			 */
/* 1. 갱신 테이블 : 일자금실적(KFM11OT0)																 */
/* 2. 처리																										 */
/*    1. 처리일자의 승인 전표 중 계정과목마스타에 현금유관계정 = 'Y'인 전표를 조회한다. */
/*    2. 현금유관계정이 발생한 반대편의 전표라인 중 계정과목마스타에 자금관련계정이 있는*/
/*       항목의 전표 금액을 ADD 또는 INSERT 한다.													 */
/*       반대편의 차대구분이 '차변'이면 차변자금관련계정,'대변'이면 대변자금관련계정	 */
/****************************************************************************************/
Double    dAmount
Long      lJunNo
Integer   iRowCount,iFindayCnt,i,il_meterposition,iDetailCnt,k,iFindRow,iCurRow
String    sSaupj,sAccDate,sUpmuGbn,sOriDcGbn,sDcGbn,sFinCode

iRowCount = dw_lst.RowCount()

iFinDayCnt = dw_update.Retrieve(sFrom,sTo)					/*기존의 일집계 자료 조회*/

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "일자금실적 마감 집계 중......"

uo_progress.Show()

FOR i = 1 TO iRowCount
	sSaupj   = dw_lst.GetItemString(i,"saupj")
	sAccDate = dw_lst.GetItemString(i,"acc_date") 
	sUpmuGbn = dw_lst.GetItemString(i,"upmu_gu") 
	lJunNo   = dw_lst.GetItemNumber(i,"jun_no") 
	
	sOriDcGbn = dw_lst.GetItemString(i,"dcr_gu") 					/*현금유관계정 발생 위치*/
	
	IF sOriDcGbn = '1' THEN
		sDcGbn = '2'
	ELSEIF sOriDcGbn = '2' THEN
		sDcGbn = '1'
	END IF
	
	il_meterPosition = (i / iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iDetailCnt = dw_detail.Retrieve(sSaupj,sAccDate,sUpmuGbn,lJunNo,sDcGbn)
	IF iDetailCnt <= 0 THEN Continue
	
	FOR k = 1 TO iDetailCnt
		IF sDcGbn = '1' THEN										/*전표의 발생 위치 - 차변*/
			sFinCode = dw_detail.GetItemString(k,"cha_ficode")
		ELSE															/*전표의 발생 위치 - 대변*/
			sFinCode = dw_detail.GetItemString(k,"dae_ficode")
		END IF
		IF sFinCode = "" OR IsNull(sFinCode) THEN Continue
		
		dAmount = dw_detail.GetItemNumber(k,"amt")
		IF IsNull(dAmount) THEN dAmount = 0
		
		iFindRow = dw_update.Find("finance_cd ='" + sFinCode + "' and finance_date = '"+sAccDate+"'",1, dw_update.RowCount())
		
		IF iFindRow > 0 THEN
			dw_update.SetItem(iFindRow,"actual_amt",  &
										dw_update.GetItemNumber(iFindRow,"actual_amt") + dAmount)
		ELSE
			iCurRow = dw_update.InsertRow(0)
			dw_update.SetItem(iCurRow,"finance_cd",  sFinCode)
			dw_update.SetItem(iCurRow,"finance_date",sAccDate)
			dw_update.SetItem(iCurRow,"actual_amt",  dAmount)
		END IF
	NEXT
NEXT

IF dw_update.Update() <> 1 THEN
	F_MessageChk(13,'[일집계]')
	Rollback;
	Return -1
END IF

Return 1
end function

public function integer wf_clear_kfm11ot0 (string saccdatef, string saccdatet, string sflag);
if sFlag = 'P' then
	UPDATE "KFM11OT0"  
		SET "PLAN_AMT" = 0  
		WHERE "KFM11OT0"."FINANCE_DATE" >= :sAccDateF and
				"KFM11OT0"."FINANCE_DATE" <= :sAccDateT ;		
else
	UPDATE "KFM11OT0"  
		SET "ACTUAL_AMT" = 0  
		WHERE "KFM11OT0"."FINANCE_DATE" >= :sAccDateF and
				"KFM11OT0"."FINANCE_DATE" <= :sAccDateT ;	
end if
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","자료 초기화 실패!")
	Return -1
END IF

Return 1
end function

public function integer wf_create_kfm11ot0 (string sfrom, string sto);/****************************************************************************************/
/*   일자금 계획을 집계합니다!!																			 */
/* 1. 갱신 테이블 : 일자금수지(KFM11OT0)																 */
/* 2. 처리																										 */
/*    1. 기간의 월자금수지계획내역을 읽어서 일자금수지로 insert or update.					 */
/****************************************************************************************/

Double    dAmount
Integer   iRowCount,i,il_meterposition,iFindRow,iCurRow
String    sFinCode,sFinDate

iRowCount = dw_planlst.Retrieve(sFrom,sTo)

dw_update.Retrieve(sFrom,sTo)									/*기존의 일집계 자료 조회*/

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "일자금계획 집계 중......"

uo_progress.Show()

FOR i = 1 TO iRowCount
	sFinDate = dw_planlst.GetItemString(i,"fin_date") 
	sFinCode = dw_planlst.GetItemString(i,"finance_cd") 
	dAmount  = dw_planlst.GetItemNumber(i,"amount")
	
	IF IsNull(dAmount) THEN dAmount = 0
	IF sFinCode = "" OR IsNull(sFinCode) THEN Continue
	
	il_meterPosition = (i / iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
		
	iFindRow = dw_update.Find("finance_cd ='" + sFinCode + "' and finance_date = '"+sFinDate+"'",1, dw_update.RowCount())
		
	IF iFindRow > 0 THEN
		dw_update.SetItem(iFindRow,"plan_amt",  &
									dw_update.GetItemNumber(iFindRow,"plan_amt") + dAmount)
	ELSE
		iCurRow = dw_update.InsertRow(0)
		dw_update.SetItem(iCurRow,"finance_cd",  sFinCode)
		dw_update.SetItem(iCurRow,"finance_date",sFinDate)
		dw_update.SetItem(iCurRow,"plan_amt",    dAmount)
	END IF
NEXT

IF dw_update.Update() <> 1 THEN
	F_MessageChk(13,'[일계획 집계]')
	Rollback;
	Return -1
END IF

Return 1
end function

public function integer wf_auto_calculation (string scurdate);String  sAdd_Cd[5],sSub_Cd[5],sFin_cd,sIwolFlag,sBefDay
Double  dIwol_Actu_Amt,dIwol_Plan_Amt,dLast_Actu,dLast_Plan,dAdd_Actu_Amount,dAdd_Plan_Amount,&
		  dTotal_Actu_Add,dTotal_Plan_Add,dTotal_Actu_Sub,dTotal_Plan_Sub,dSub_Actu_Amount,dSub_Plan_Amount

Integer k,il_Select_Cnt

dtotal_plan_add = 0
dtotal_plan_sub = 0
dLast_Plan      = 0

dtotal_actu_add = 0
dtotal_actu_sub = 0
dLast_Actu      = 0

DECLARE cur_kfm10om0 CURSOR FOR  
	SELECT "KFM10OM0"."FINANCE_CD",   "KFM10OM0"."ADD_CD1",      "KFM10OM0"."ADD_CD2",      
	       "KFM10OM0"."ADD_CD3",      "KFM10OM0"."ADD_CD4",      "KFM10OM0"."ADD_CD5",   
          "KFM10OM0"."SUB_CD1",      "KFM10OM0"."SUB_CD2",      "KFM10OM0"."SUB_CD3", 
			 "KFM10OM0"."SUB_CD4",      "KFM10OM0"."SUB_CD5",      "KFM10OM0"."TRANSE_CD"  
	FROM "KFM10OM0"  
   WHERE "KFM10OM0"."AUTO_CD" = 'Y'   
	ORDER BY "KFM10OM0"."FINANCE_CD" ASC  ;

OPEN cur_kfm10om0;

DO WHILE TRUE

	FETCH cur_kfm10om0 INTO :sFin_cd,  			:sAdd_cd[1],    	:sAdd_cd[2],
									:sAdd_cd[3],		:sAdd_cd[4],		:sAdd_cd[5],
									:sSub_cd[1],		:sSub_cd[2],		:sSub_cd[3],
									:sSub_cd[4],		:sSub_cd[5],      :sIwolFlag ;
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	IF sIwolFlag = 'Y' THEN
		SELECT MAX("KFM11OT0"."FINANCE_DATE") 		INTO :sBefDay
			FROM "KFM11OT0"
			WHERE ( "KFM11OT0"."FINANCE_DATE" < :sCurDate );
		IF SQLCA.SQLCODE <> 0 THEN
			dLast_Actu = 0;			dLast_Plan = 0;
		ELSE
			IF IsNull(sBefDay) OR sBefDay = '' THEN
				dLast_Actu = 0;			dLast_Plan = 0;
			ELSE
				SELECT NVL("KFM11OT0"."PLAN_AMT",0),	NVL("KFM11OT0"."ACTUAL_AMT",0)  	
					INTO :dIwol_Plan_Amt,					:dIwol_Actu_Amt     					//전일잔액
					FROM "KFM11OT0","KFM10OM0"  
					WHERE ("KFM11OT0"."FINANCE_CD" = "KFM10OM0"."FINANCE_CD") AND
							( "KFM10OM0"."LAST_CD" = 'Y' AND "KFM11OT0"."FINANCE_DATE" = :sBefDay );		
				IF SQLCA.SQLCODE <> 0 THEN
					dIwol_Plan_Amt =0
					dIwol_Actu_Amt =0
				ELSE
					IF IsNull(dIwol_Actu_Amt) THEN dIwol_Actu_Amt = 0			
					IF IsNull(dIwol_Plan_Amt) THEN dIwol_Plan_Amt = 0			
				END IF
				dLast_Actu = dIwol_Actu_Amt
				dLast_Plan = dIwol_Plan_Amt
			END IF
		END IF
	ELSE
		FOR k = 1 TO 5
			IF sAdd_cd[k] = "" OR sAdd_cd[k] = ' ' OR IsNull(sAdd_cd[k]) THEN
				dAdd_Plan_Amount =0
				dAdd_actu_amount =0
			ELSE
				SELECT NVL("KFM11OT0"."PLAN_AMT",0),   NVL("KFM11OT0"."ACTUAL_AMT",0) 
					INTO :dAdd_plan_amount,             :dAdd_actu_amount	//연산(+)
					FROM "KFM11OT0"  
					WHERE ( "KFM11OT0"."FINANCE_CD" = :sAdd_cd[k] ) AND  
							( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
				IF SQLCA.SQLCODE <> 0 THEN
					dAdd_plan_amount =0
					dAdd_actu_amount =0
				END IF
			END IF
			dtotal_actu_add = dtotal_actu_add + dAdd_actu_amount
			dtotal_plan_add = dtotal_plan_add + dAdd_plan_amount
	
			IF sSub_cd[k] = "" OR sSub_cd[k] = ' ' OR IsNull(sSub_cd[k]) THEN
				dSub_plan_amount =0
				dSub_actu_amount =0
			ELSE
				SELECT NVL("KFM11OT0"."PLAN_AMT",0),   NVL("KFM11OT0"."ACTUAL_AMT",0)
					INTO :dSub_plan_amount,             :dSub_actu_amount   //연산(-)
					FROM "KFM11OT0"  
					WHERE ( "KFM11OT0"."FINANCE_CD" = :sSub_cd[k] ) AND  
							( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
				IF SQLCA.SQLCODE <> 0 THEN
					dSub_plan_amount =0
					dSub_actu_amount =0
				END IF
			END IF
			dtotal_plan_sub = dtotal_plan_sub + dSub_plan_amount
			dtotal_actu_sub = dtotal_actu_sub + dSub_actu_amount
		NEXT
		dLast_Actu = dtotal_actu_add - dtotal_actu_sub				// 실적 = 연산(+)합 - 연산(-)합
		dLast_Plan = dtotal_plan_add - dtotal_plan_sub				// 계획 = 연산(+)합 - 연산(-)합
	END IF	
	
	SELECT COUNT(*)	INTO :il_select_cnt
		FROM "KFM11OT0"  
		WHERE ( "KFM11OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
	IF il_select_cnt = 1 THEN
		UPDATE "KFM11OT0"  
			SET "PLAN_AMT"     = :dLast_Plan,
				 "ACTUAL_AMT"   = :dLast_Actu
			WHERE ( "KFM11OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
	ELSE
		INSERT INTO "KFM11OT0"  
			( "FINANCE_CD",   "FINANCE_DATE",   "PLAN_AMT",   "ACTUAL_AMT" )  
		VALUES ( :sFin_cd,   :sCurDate,        :dLast_Plan,  :dLast_Actu )  ;
	END IF
	
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[일집계 - 자동계산]')
		ROLLBACK;
		Return -1
	END IF
   dtotal_plan_add = 0
   dtotal_plan_sub = 0
   dLast_Plan     = 0

   dtotal_actu_add = 0
   dtotal_actu_sub = 0
   dLast_Actu      = 0
LOOP
CLOSE cur_kfm10om0;

Return 1
end function

event open;call super::open;
dw_cond.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_update.SetTransObject(sqlca)
dw_planlst.SetTransObject(sqlca)

dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"acc_date",Left(f_today(),6)+'01')
dw_cond.SetItem(1,"todate",f_today())
dw_cond.SetFocus()

uo_progress.Hide()


end event

on w_kfia27.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.cb_6=create cb_6
this.gb_1=create gb_1
this.st_2=create st_2
this.uo_progress=create uo_progress
this.dw_lst=create dw_lst
this.dw_detail=create dw_detail
this.dw_update=create dw_update
this.dw_planlst=create dw_planlst
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.cb_6
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_progress
this.Control[iCurrent+6]=this.dw_lst
this.Control[iCurrent+7]=this.dw_detail
this.Control[iCurrent+8]=this.dw_update
this.Control[iCurrent+9]=this.dw_planlst
end on

on w_kfia27.destroy
call super::destroy
destroy(this.dw_cond)
destroy(this.cb_6)
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.uo_progress)
destroy(this.dw_lst)
destroy(this.dw_detail)
destroy(this.dw_update)
destroy(this.dw_planlst)
end on

type dw_insert from w_inherite`dw_insert within w_kfia27
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia27
boolean visible = false
integer x = 2793
integer y = 28
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia27
boolean visible = false
integer x = 2619
integer y = 28
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia27
boolean visible = false
integer x = 1925
integer y = 28
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia27
boolean visible = false
integer x = 2446
integer y = 28
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfia27
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kfia27
boolean visible = false
integer x = 3314
integer y = 28
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfia27
boolean visible = false
integer x = 2098
integer y = 28
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia27
boolean visible = false
integer x = 2272
integer y = 28
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfia27
boolean visible = false
integer x = 3141
integer y = 28
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfia27
integer x = 4270
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;/****************************************************************************************/
/*   일자금 실적을 집계합니다!!																			 */
/* 1. 갱신 테이블 : 일자금실적(KFM11OT0)																 */
/* 2. 처리구분 : 초기화후 집계 - 처리일자로 들어있는 일자금실적(ACTUAL_AMT)을 0으로 초기*/
/*                            화 후 처리한다.														 */
/*               집계          - 이전 자료에 ADD한다.												 */
/* 3. 처리																										 */
/*    1. 처리일자의 승인 전표 중 계정과목마스타에 현금유관계정 = 'Y'인 전표를 조회한다. */
/*    2. 현금유관계정이 발생한 반대편의 전표라인 중 계정과목마스타에 자금관련계정이 있는*/
/*       항목의 전표 금액을 ADD 또는 INSERT 한다.													 */
/*       반대편의 차대구분이 '차변'이면 차변자금관련계정,'대변'이면 대변자금관련계정	 */
/****************************************************************************************/

String    sAcc_DateF,sAcc_DateT,sGubun,sCreateGbn,sPlanFlag,sActualFlag
Integer   iRowCount,iFunRtnVal

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sAcc_DateF   = Trim(dw_cond.GetItemString(1,"acc_date"))
sAcc_DateT   = Trim(dw_cond.GetItemString(1,"todate"))
sGubun       = dw_cond.GetItemString(1,"gubun")
sPlanFlag    = dw_cond.GetItemString(1,"plangbn")
sActualFlag  = dw_cond.GetItemString(1,"actualgbn")

IF sAcc_DateF ="" OR IsNull(sAcc_DateF) THEN
	F_Messagechk(1,'[처리일자]')
	dw_cond.SetColumn("acc_date")
	dw_cond.SetFocus()
	Return
END IF
IF sAcc_DateT ="" OR IsNull(sAcc_DateT) THEN
	F_Messagechk(1,'[처리일자]')
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	Return
END IF

IF sPlanFlag = 'P' THEN
	IF sGubun = '1' THEN
		IF wf_clear_kfm11ot0(sAcc_DateF,sAcc_DateT,sPlanFlag) = -1 THEN 
			ROLLBACK;
		ELSE
			COMMIT;
		END IF
	END IF
	
	IF Wf_Create_Kfm11ot0(sAcc_DateF,sAcc_DateT) = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

IF sActualFlag = 'A' THEN
	IF sGubun = '1' THEN
		IF wf_clear_kfm11ot0(sAcc_DateF,sAcc_DateT,sActualFlag) = -1 THEN 
			ROLLBACK;
		ELSE
			COMMIT;
		END IF
	END IF
	
	select nvl(substr(dataname,1,1),'0') 	into :sCreateGbn	from syscnfg where sysgu = 'A' and serial = 30 and lineno = '1';
	if sCreateGbn = '1' then							/*전표에서 가져옴*/
		dw_lst.DataObject = 'dw_kfia27_21'
		dw_lst.SetTransObject(sqlca)
		dw_lst.Reset()
		
		iRowCount = dw_lst.Retrieve(sAcc_DateF,sAcc_DateT)
		IF iRowCount <=0 THEN
			F_MessageChk(14,'[승인전표]')
			Return 
		END IF
		
		if Wf_Calculation_1(sAcc_DateF,sAcc_DateT) = -1 THEN Return	
	elseif sCreateGbn = '2' then						/*계정과목 마스타의 자금코드로 가져옴*/
		dw_lst.DataObject = 'dw_kfia27_2'
		dw_lst.SetTransObject(sqlca)
		dw_lst.Reset()
		
		iRowCount = dw_lst.Retrieve(sAcc_DateF,sAcc_DateT)
		IF iRowCount <=0 THEN
			F_MessageChk(14,'[승인전표]')
			Return 
		END IF
	
		if Wf_Calculation_2(sAcc_DateF,sAcc_DateT) = -1 THEN Return
	else
		Return
	end if
	Commit ;
END IF

w_mdi_frame.sle_msg.text = '상위자금코드로 집계 중...'
SetPointer(HourGlass!)
iFunRtnVal = Sqlca.fun_calculation_upcross(sAcc_DateF,sAcc_Datet);
if iFunRtnVal = 0 then
	F_MessageChk(59,'')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
elseif iFunRtnVal = 1 then
	Commit;
else
	F_MessageChk(13,'[상위집계]')	
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
end if
w_mdi_frame.sle_msg.text = '상위자금코드로 집계 완료'
SetPointer(Arrow!)

w_mdi_frame.sle_msg.text = '자동 계산 중...'
SetPointer(HourGlass!)
iFunRtnVal = Sqlca.fun_calculation_auto(sAcc_DateF,sAcc_Datet);
if iFunRtnVal = 0 then
	F_MessageChk(59,'')
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
elseif iFunRtnVal = 1 then
	Commit;
else
	F_MessageChk(13,'[자동계산]')	
	Rollback;
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
end if
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = "일자금실적 마감 집계 완료"

end event

type cb_exit from w_inherite`cb_exit within w_kfia27
boolean visible = false
integer x = 3209
integer y = 1924
integer width = 315
end type

type cb_mod from w_inherite`cb_mod within w_kfia27
boolean visible = false
integer x = 978
integer y = 2560
integer width = 293
end type

type cb_ins from w_inherite`cb_ins within w_kfia27
boolean visible = false
integer x = 649
integer y = 2560
integer width = 293
end type

type cb_del from w_inherite`cb_del within w_kfia27
boolean visible = false
integer x = 1303
integer y = 2560
integer width = 293
end type

type cb_inq from w_inherite`cb_inq within w_kfia27
boolean visible = false
integer y = 2560
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kfia27
boolean visible = false
integer x = 1952
integer y = 2560
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia27
boolean visible = false
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_kfia27
boolean visible = false
integer x = 2277
integer y = 2560
integer width = 293
end type

type cb_search from w_inherite`cb_search within w_kfia27
boolean visible = false
integer x = 2601
integer y = 2560
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia27
boolean visible = false
integer x = 2853
integer width = 741
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kfia27
boolean visible = false
integer x = 325
integer width = 2528
end type

type gb_10 from w_inherite`gb_10 within w_kfia27
boolean visible = false
integer width = 3598
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia27
boolean visible = false
integer x = 731
integer y = 2320
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia27
boolean visible = false
integer x = 2816
integer y = 1872
integer width = 754
end type

type dw_cond from datawindow within w_kfia27
event ue_pressenter pbm_dwnprocessenter
integer x = 1147
integer y = 548
integer width = 1385
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfia27_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type cb_6 from commandbutton within w_kfia27
event ue_sonik pbm_custom01
boolean visible = false
integer x = 2857
integer y = 1928
integer width = 315
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&E)"
end type

on ue_sonik;Double ldb_tot_cha,ldb_tot_dai
//////////////////////////////////////////////////////////
//*********당기 순손익 or 순손실                        //
//************IF 대변 SUM - 차변 SUM < 0 THEN 당기순손실//
//************   대변 SUM - 차변 SUM > 0 THEN 당기순이익//              
//////////////////////////////////////////////////////////
SELECT SUM("KFZ14OT0"."DR_AMT"),
		 SUM("KFZ14OT0"."CR_AMT")
	INTO :ldb_tot_cha,
		  :ldb_tot_dai
 	FROM "KFZ14OT0"  
   WHERE ("KFZ14OT0"."SAUPJ" = :ls_saupj) AND  
         ("KFZ14OT0"."ACC_YY" = :ls_yy) AND  
         (("KFZ14OT0"."ACC_MM" >= '00') AND  
         ("KFZ14OT0"."ACC_MM" <= '12')) AND  
         (("KFZ14OT0"."ACC1_CD" >= '40000') AND  
         ("KFZ14OT0"."ACC1_CD" <= '48010')) AND
			("KFZ14OT0"."ACC2_CD" <> '  ') ;
IF SQLCA.SQLCODE =0 THEN
	ldb_dangi_amt =ldb_tot_dai - ldb_tot_cha
ELSE
	ldb_dangi_amt =0
END IF







end on

type gb_1 from groupbox within w_kfia27
integer x = 1029
integer y = 432
integer width = 1655
integer height = 416
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type st_2 from statictext within w_kfia27
integer x = 928
integer y = 312
integer width = 1888
integer height = 132
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "일자금수지를 집계합니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_progress from u_progress_bar within w_kfia27
integer x = 1326
integer y = 936
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_lst from datawindow within w_kfia27
boolean visible = false
integer x = 73
integer y = 1352
integer width = 1458
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "집계처리대상 전표(실적)"
string dataobject = "dw_kfia27_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_detail from datawindow within w_kfia27
boolean visible = false
integer x = 78
integer y = 1464
integer width = 1458
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "전표상세 조회(계정과목마스타의 자금코드)"
string dataobject = "dw_kfia27_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_update from datawindow within w_kfia27
boolean visible = false
integer x = 78
integer y = 1572
integer width = 1458
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "일자금 저장"
string dataobject = "dw_kfia27_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_planlst from datawindow within w_kfia27
boolean visible = false
integer x = 73
integer y = 1256
integer width = 1458
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "월자금수지 계획 자료"
string dataobject = "dw_kfia27_5"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

