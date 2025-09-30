$PBExportHeader$w_kfia29.srw
$PBExportComments$월자금수지  집계
forward
global type w_kfia29 from w_inherite
end type
type dw_cond from datawindow within w_kfia29
end type
type cb_6 from commandbutton within w_kfia29
end type
type gb_1 from groupbox within w_kfia29
end type
type st_2 from statictext within w_kfia29
end type
type dw_lst from datawindow within w_kfia29
end type
end forward

global type w_kfia29 from w_inherite
integer height = 3412
string title = "월자금수지 집계"
dw_cond dw_cond
cb_6 cb_6
gb_1 gb_1
st_2 st_2
dw_lst dw_lst
end type
global w_kfia29 w_kfia29

type variables
String ls_saupj,ls_yy,ls_add_yy
Boolean continue_flag =True
Double ldb_dangi_amt
end variables

forward prototypes
public function integer wf_clear_kfm12ot0 (string sym)
public function integer wf_upcross (string sym)
public function integer wf_auto_calculation (string scurym)
end prototypes

public function integer wf_clear_kfm12ot0 (string sym);
UPDATE "KFM12OT0"  
	SET "PLAN_AMT" = 0,
		 "ACTUAL_AMT" = 0  
   WHERE "KFM12OT0"."FINANCE_YM" = :sYm   ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","자료 초기화 실패!")
	Return -1
END IF

Return 1
end function

public function integer wf_upcross (string sym);
Int il_Count
String sFin_cd,test_cd
Double dac_tot ,dpl_tot 

DECLARE cur_kfm12ot0 CURSOR FOR  
	SELECT "KFM10OM0"."FINANCE_CD"  
   	FROM "KFM10OM0"  
	 	WHERE "KFM10OM0"."AUTO_CD" = 'C' 
		ORDER BY "KFM10OM0"."FINANCE_CD" ASC;

open cur_kfm12ot0;

DO WHILE true
	FETCH cur_kfm12ot0 INTO :sfin_cd ;
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT	
	
	SELECT SUM(NVL(B.PLAN_AMT,0)), SUM(NVL(B.ACTUAL_AMT,0))    INTO :dpl_tot,:dac_tot
		FROM ( SELECT *
      	       FROM "KFM10OM0" 
         		 	CONNECT BY PRIOR "KFM10OM0"."FINANCE_CD" = "KFM10OM0"."SFIN_CD"  
                	START WITH "KFM10OM0"."SFIN_CD" = :sfin_cd ) A, 
           "KFM12OT0" B 
		WHERE A.FINANCE_CD = B.FINANCE_CD AND 
		      A.AUTO_CD = 'N' AND 
			 B.FINANCE_YM = :sYm;

	IF SQLCA.SQLCODE <> 0 THEN	Return -1

	SELECT "KFM12OT0"."FINANCE_CD"            INTO :test_cd  
		FROM "KFM12OT0"  
      WHERE ( "KFM12OT0"."FINANCE_CD" = :sfin_cd ) AND ( "KFM12OT0"."FINANCE_YM" = :sYm );
  	IF sqlca.sqlcode = 0 THEN	
	   UPDATE "KFM12OT0"  
		   SET "PLAN_AMT"   = :dpl_tot,
				 "ACTUAL_AMT" = :dac_tot   
      	WHERE ( "KFM12OT0"."FINANCE_CD" = :sfin_cd ) AND  
         	   ( "KFM12OT0"."FINANCE_YM" = :sYm)   ;
	   IF SQLCA.SQLCODE <> 0 THEN	Return -1	
	ELSEIF sqlca.sqlcode = 100 THEN
		INSERT INTO "KFM12OT0"
			( "FINANCE_CD", "FINANCE_YM", "PLAN_AMT", "ACTUAL_AMT" )  
      VALUES ( :sfin_cd, :sYm,         :dpl_tot,   :dac_tot ) ;
      IF SQLCA.SQLCODE <> 0 THEN	Return -1
	ELSE
	   Return -1
   END IF
LOOP
close cur_kfm12ot0;

Return 1

end function

public function integer wf_auto_calculation (string scurym);String  sAdd_Cd[5],sSub_Cd[5],sFin_cd,sIwolFlag,sBefYm
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
		sBefYm = Left(String(RelativeDate(Date(String(sCurYm+'01','@@@@.@@.@@')),-1),'yyyymmdd'),6)
		
		SELECT NVL("KFM12OT0"."ACTUAL_AMT",0),	NVL("KFM12OT0"."ACTUAL_AMT",0)  	
			INTO :dIwol_Plan_Amt,					:dIwol_Actu_Amt   			 		//전월잔액
			FROM "KFM12OT0","KFM10OM0"  
			WHERE ("KFM12OT0"."FINANCE_CD" = "KFM10OM0"."FINANCE_CD") AND
					( "KFM10OM0"."LAST_CD" = 'Y' AND "KFM12OT0"."FINANCE_YM" = :sBefYm );		
		IF SQLCA.SQLCODE <> 0 THEN
			dIwol_Plan_Amt =0
			dIwol_Actu_Amt =0
		ELSE
			IF IsNull(dIwol_Actu_Amt) THEN dIwol_Actu_Amt = 0			
			IF IsNull(dIwol_Plan_Amt) THEN dIwol_Plan_Amt = 0			
		END IF
		dLast_Actu = dIwol_Actu_Amt
		dLast_Plan = dIwol_Plan_Amt
	ELSE
		FOR k = 1 TO 5
			IF sAdd_cd[k] = "" OR sAdd_cd[k] = ' ' OR IsNull(sAdd_cd[k]) THEN
				dAdd_Plan_Amount =0
				dAdd_actu_amount =0
			ELSE
				SELECT NVL("KFM12OT0"."PLAN_AMT",0),   NVL("KFM12OT0"."ACTUAL_AMT",0) 
					INTO :dAdd_plan_amount,             :dAdd_actu_amount					//연산(+)
					FROM "KFM12OT0"  
					WHERE ( "KFM12OT0"."FINANCE_CD" = :sAdd_cd[k] ) AND  
							( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
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
				SELECT NVL("KFM12OT0"."PLAN_AMT",0),   NVL("KFM12OT0"."ACTUAL_AMT",0)
					INTO :dSub_plan_amount,             :dSub_actu_amount 			   //연산(-)
					FROM "KFM12OT0"  
					WHERE ( "KFM12OT0"."FINANCE_CD" = :sSub_cd[k] ) AND  
							( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
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
		FROM "KFM12OT0"  
		WHERE ( "KFM12OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
	IF il_select_cnt = 1 THEN
		UPDATE "KFM12OT0"  
			SET "PLAN_AMT"     = :dLast_Plan, 
				 "ACTUAL_AMT"   = :dLast_Actu
			WHERE ( "KFM12OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
	ELSE
		INSERT INTO "KFM12OT0"  
			( "FINANCE_CD",   "FINANCE_YM",   "PLAN_AMT",   "ACTUAL_AMT" )  
		VALUES ( :sFin_cd,   :sCurYm,        :dLast_Plan,  :dLast_Actu )  ;
	END IF
	
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[월집계 - 자동계산]')
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
dw_lst.SetTransObject(sqlca)

dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"from_ym",Left(f_today(),6))
dw_cond.SetItem(1,"to_ym",  Left(f_today(),6))
dw_cond.SetFocus()




end event

on w_kfia29.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.cb_6=create cb_6
this.gb_1=create gb_1
this.st_2=create st_2
this.dw_lst=create dw_lst
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.cb_6
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_lst
end on

on w_kfia29.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.cb_6)
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.dw_lst)
end on

type dw_insert from w_inherite`dw_insert within w_kfia29
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia29
boolean visible = false
integer x = 2519
integer y = 40
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia29
boolean visible = false
integer x = 2345
integer y = 40
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia29
boolean visible = false
integer x = 1650
integer y = 40
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia29
boolean visible = false
integer x = 2171
integer y = 40
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfia29
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kfia29
boolean visible = false
integer x = 3040
integer y = 40
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfia29
boolean visible = false
integer x = 1824
integer y = 40
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia29
boolean visible = false
integer x = 1998
integer y = 40
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfia29
boolean visible = false
integer x = 2866
integer y = 40
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfia29
integer x = 4270
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;/******************************************************************************************/
/*   월자금 실적을 집계합니다!!																			   */
/* 1. 갱신 테이블 : 월자금실적(KFM12OT0)																   */
/* 2. 처리																										   */
/*    * 처리년월의 일자금실적을 집계하여 월자금실적 자료를 만든다.(이전자료 삭제 후 처리) */
/*    * 자금코드마스타의 자동계산 여부의 값에 따라서 별도 처리한다.								*/
/*    1.자동계산 여부 = 'N'인 자료 처리																	*/
/*        처리년월의 일자금실적을 집계하여 월자금실적자료를 만든다.								*/
/*    2.자동계산 여부 = 'C'인 자료의 처리 																*/
/*        처리년월의 자동계산 여부 = 'N'인 월자금실적을 집계하여 상위계정으로 적상한다.   */
/*    3.자동계산 여부 = 'Y'인 자료의 처리																	*/
/*        처리년월의 월자금실적으로 자동 계산 처리한다.												*/
/*    ** 이월자금 여부 = 'Y'이면 전월의 월집계자료 중 차월자금 여부 = 'Y'인 값을 가져온다.*/
/******************************************************************************************/
String  sStartYm,sEndYm,sCurYm,sFinCode
Integer iRowCount,i,iFunRtnVal
Long    lk,lStartYm,lEndYm
Double  dNewActu,dOriActu,dNewPlan,dOriPlan

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sStartYm = Trim(dw_cond.GetItemString(1,"from_ym"))
sEndYm   = Trim(dw_cond.GetItemString(1,"to_ym"))

IF sStartYm = "" OR IsNull(sStartYm) THEN
	F_MessageChk(1,'[처리년월]')
	dw_cond.SetColumn("from_ym")
	dw_cond.Setfocus()
	Return
END IF
IF sEndYm = "" OR IsNull(sEndYm) THEN
	F_MessageChk(1,'[처리년월]')
	dw_cond.SetColumn("to_ym")
	dw_cond.Setfocus()
	Return
END IF

IF DaysAfter(Date(String(sStartYm+'01','@@@@.@@.@@')),Date(String(sEndYm+'01','@@@@.@@.@@'))) < 0 THEN
	F_Messagechk(26,'[처리년월]')
	dw_cond.SetColumn("to_ym")
	Return
ELSE
	lStartYm = Long(sStartYm)
	lEndYm   = Long(sEndYm)
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "월자금실적 마감 집계 중......"

FOR lk = lStartYm TO lEndYm 
	sCurYm = String(lK,'000000')
	
	iRowCount = dw_lst.Retrieve(sCurYm)
	IF iRowCount <=0 THEN Continue

	IF wf_clear_kfm12ot0(sCurYm) = -1 THEN 							/*이전자료 초기화*/
		ROLLBACK;
	ELSE
		COMMIT;
	END IF

	w_mdi_frame.sle_msg.text = String(sCurYm,'@@@@.@@') + "월 자금실적 마감 집계 중......"
	
	FOR i = 1 TO iRowCount
		sFinCode = dw_lst.GetItemString(i,"finance_cd")
		IF sFinCode = "" OR IsNull(sFinCode) THEN Continue
		
		dNewActu = dw_lst.GetItemNumber(i,"sum_actu")
		dNewPlan = dw_lst.GetItemNumber(i,"sum_plan")
		
		IF IsNull(dNewActu) THEN dNewActu = 0
		IF IsNull(dNewPlan) THEN dNewPlan = 0
		
		SELECT "KFM12OT0"."PLAN_AMT",    "KFM12OT0"."ACTUAL_AMT"  
    		INTO :dOriPlan,				   :dOriActu  
    		FROM "KFM12OT0"  
   		WHERE ( "KFM12OT0"."FINANCE_CD" = :sFinCode ) AND ( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
		IF SQLCA.SQLCODE = 100 THEN
			INSERT INTO "KFM12OT0"  
         	( "FINANCE_CD",   "FINANCE_YM",   "PLAN_AMT",   "ACTUAL_AMT" )  
			VALUES ( :sFinCode,	:sCurYm,			 :dNewPlan,		:dNewActu)  ;
		ELSEIF SQLCA.SQLCODE = 0 THEN
			IF IsNull(dOriActu) THEN dOriActu = 0
			IF IsNull(dOriPlan) THEN dOriPlan = 0
			
			UPDATE "KFM12OT0"  
     			SET "PLAN_AMT"   = :dOriPlan + :dNewPlan,
				  	 "ACTUAL_AMT" = :dOriActu + :dNewActu  
   			WHERE ( "KFM12OT0"."FINANCE_CD" = :sFinCode ) AND ( "KFM12OT0"."FINANCE_YM" = :sCurYm )   ;
		ELSE
			F_Messagechk(13,'[월자금실적 - 조회]')
			Rollback;
			Return	
		END IF
		
		IF SQLCA.SQLCODE <> 0 THEN
			F_Messagechk(13,'[월자금실적 - 저장]')
			Rollback;
			Return
		END IF
	NEXT
	COMMIT;
	
	w_mdi_frame.sle_msg.text = '상위자금코드로 집계 중...'
	SetPointer(HourGlass!)
	iFunRtnVal = Sqlca.fun_calculation_upcross_month(sCurYm);
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
	iFunRtnVal = Sqlca.fun_calculation_auto_month(sCurYm);
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
NEXT
COMMIT;

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = "월자금실적 마감 집계 완료"

end event

type cb_exit from w_inherite`cb_exit within w_kfia29
boolean visible = false
integer x = 3223
integer y = 1932
integer width = 315
end type

type cb_mod from w_inherite`cb_mod within w_kfia29
boolean visible = false
integer x = 978
integer y = 2560
integer width = 293
end type

type cb_ins from w_inherite`cb_ins within w_kfia29
boolean visible = false
integer x = 649
integer y = 2560
integer width = 293
end type

type cb_del from w_inherite`cb_del within w_kfia29
boolean visible = false
integer x = 1303
integer y = 2560
integer width = 293
end type

type cb_inq from w_inherite`cb_inq within w_kfia29
boolean visible = false
integer y = 2560
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kfia29
boolean visible = false
integer x = 1952
integer y = 2560
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia29
boolean visible = false
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_kfia29
boolean visible = false
integer x = 2277
integer y = 2560
integer width = 293
end type

type cb_search from w_inherite`cb_search within w_kfia29
boolean visible = false
integer x = 2601
integer y = 2560
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia29
boolean visible = false
integer x = 2853
integer width = 741
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kfia29
boolean visible = false
integer x = 325
integer width = 2528
end type

type gb_10 from w_inherite`gb_10 within w_kfia29
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia29
boolean visible = false
integer x = 731
integer y = 2320
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia29
boolean visible = false
integer x = 2816
integer y = 1876
integer width = 754
end type

type dw_cond from datawindow within w_kfia29
event ue_pressenter pbm_dwnprocessenter
integer x = 1280
integer y = 572
integer width = 1047
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfia29_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type cb_6 from commandbutton within w_kfia29
event ue_sonik pbm_custom01
boolean visible = false
integer x = 2857
integer y = 1932
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

type gb_1 from groupbox within w_kfia29
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

type st_2 from statictext within w_kfia29
integer x = 997
integer y = 308
integer width = 1774
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
string text = "월자금수지를 집계합니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_lst from datawindow within w_kfia29
boolean visible = false
integer x = 370
integer y = 1380
integer width = 1691
integer height = 360
boolean bringtotop = true
boolean titlebar = true
string title = "처리대상  일자금"
string dataobject = "dw_kfia29_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

