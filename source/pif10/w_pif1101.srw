$PBExportHeader$w_pif1101.srw
$PBExportComments$** 개인정보 등록
forward
global type w_pif1101 from w_inherite_standard
end type
type p_1 from picture within w_pif1101
end type
type pb_1 from picturebutton within w_pif1101
end type
type pb_2 from picturebutton within w_pif1101
end type
type pb_3 from picturebutton within w_pif1101
end type
type pb_4 from picturebutton within w_pif1101
end type
type gb_4 from groupbox within w_pif1101
end type
type rb_1 from radiobutton within w_pif1101
end type
type rb_2 from radiobutton within w_pif1101
end type
type gb_5 from groupbox within w_pif1101
end type
type rb_3 from radiobutton within w_pif1101
end type
type rb_4 from radiobutton within w_pif1101
end type
type rb_5 from radiobutton within w_pif1101
end type
type rb_6 from radiobutton within w_pif1101
end type
type rb_7 from radiobutton within w_pif1101
end type
type rb_8 from radiobutton within w_pif1101
end type
type rb_10 from radiobutton within w_pif1101
end type
type rb_11 from radiobutton within w_pif1101
end type
type rb_12 from radiobutton within w_pif1101
end type
type rb_13 from radiobutton within w_pif1101
end type
type rb_14 from radiobutton within w_pif1101
end type
type rb_15 from radiobutton within w_pif1101
end type
type rb_16 from radiobutton within w_pif1101
end type
type rb_17 from radiobutton within w_pif1101
end type
type rb_19 from radiobutton within w_pif1101
end type
type dw_1 from u_key_enter within w_pif1101
end type
type rb_18 from radiobutton within w_pif1101
end type
type rb_9 from radiobutton within w_pif1101
end type
type rb_20 from radiobutton within w_pif1101
end type
type rb_21 from radiobutton within w_pif1101
end type
type cb_kunmuil from commandbutton within w_pif1101
end type
type dw_main from u_key_enter within w_pif1101
end type
type dw_main_s1 from u_key_enter within w_pif1101
end type
type dw_main_s2 from u_key_enter within w_pif1101
end type
type rb_22 from radiobutton within w_pif1101
end type
type rb_23 from radiobutton within w_pif1101
end type
type dw_5 from datawindow within w_pif1101
end type
type dw_4 from u_d_popup_sort within w_pif1101
end type
type cbx_1 from checkbox within w_pif1101
end type
type dw_up from datawindow within w_pif1101
end type
type rr_1 from roundrectangle within w_pif1101
end type
type rr_2 from roundrectangle within w_pif1101
end type
type rr_3 from roundrectangle within w_pif1101
end type
end forward

global type w_pif1101 from w_inherite_standard
string title = "개인정보 등록"
event ue_dwtoggle pbm_custom40
p_1 p_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
gb_5 gb_5
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
rb_10 rb_10
rb_11 rb_11
rb_12 rb_12
rb_13 rb_13
rb_14 rb_14
rb_15 rb_15
rb_16 rb_16
rb_17 rb_17
rb_19 rb_19
dw_1 dw_1
rb_18 rb_18
rb_9 rb_9
rb_20 rb_20
rb_21 rb_21
cb_kunmuil cb_kunmuil
dw_main dw_main
dw_main_s1 dw_main_s1
dw_main_s2 dw_main_s2
rb_22 rb_22
rb_23 rb_23
dw_5 dw_5
dw_4 dw_4
cbx_1 cbx_1
dw_up dw_up
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pif1101 w_pif1101

type variables
Int il_select_dw
String is_empno
u_ds_standard ds_1

//변경자료 저장시 flag
Boolean ib_ischanged

//현재 선택 버튼표시
String  sCurButton

//등록,수정 mode
String  is_status, is_new

//사업장 code
string is_saup

end variables

forward prototypes
public function integer wf_delete_check (string ls_empno)
public function integer wf_betch_update (string as_dataobj)
public function integer wf_delete_row (integer ll_currow)
public function string wf_sqlsyntax (string sjikjong)
public subroutine wf_update_master1 (string sempno)
public function long wf_dataobject_change (string as_dataobject1, string as_dataobject2)
public function string wf_levelup (string level, string salary, string upday)
public subroutine wf_update_master (string sempno)
public function string wf_set_radiobutton (string sflag)
public function integer wf_itemchanged_check (string as_columnname, string as_data)
public function long wf_change_dataobj (string as_dataobject)
public function integer wf_required_check (string as_dataobj, integer al_row)
public function integer wf_betch_delete (string as_dataobj)
public subroutine wf_get_image (string sempno)
end prototypes

public function integer wf_delete_check (string ls_empno);// 기본 마스타 자료 삭제시 하위 자료 전체 삭제

delete from p1_affiliates
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_careers
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_educations
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_families
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_foreignlicense
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_guarantee
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_language
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_license
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_military
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_orderno
 where companycode = :gs_company and orderno = :ls_empno ;

delete from p1_orders
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_passports
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_physique
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_retire
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_rewards
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_schooling
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_visa
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_wealth
 where companycode = :gs_company and empno = :ls_empno ;

delete from p1_etc
 where companycode = :gs_company and empno = :ls_empno ;

delete from p3_circledata
 where companycode = :gs_company and empno = :ls_empno ;

delete from p4_hujikhst
 where companycode = :gs_company and empno = :ls_empno ;
 
delete from p4_perkunmu
 where companycode = :gs_company and empno = :ls_empno ; 

commit using sqlca ;

return 0
end function

public function integer wf_betch_update (string as_dataobj);
/****************************************************************************************/
/* 발령 사항 저장시 기본 마스타에 자료 저장('시행일자'가 현재일자(시스템일자) 이면 갱신)*/
/* 1. 발령구분에 따른 처리																					 */
/*   1-1. 입사발령 : 시행일자로 인사 마스타의 입퇴구분 ='재직', 입사일자 = '시행일자'	 */
/*   1-2. 승진발령 : 시행일자로 인사 마스타의 승진일자 = '시행일자'							 */
/*   1-3. 승급발령 : 시행일자로 인사 마스타의 승급일자 = '시행일자'							 */
/*   1-4. 퇴직발령 : 시행일자로 인사 마스타의 입퇴구분 = '퇴사', 퇴직일자 = '시행일자', */
/*                   퇴직사유 = '사유'																	 */
/* 2. 입력한 소속부서,직위,직급,직무,직책,호봉 갱신															 */
/****************************************************************************************/
String ls_empno,sDept,sGrade,sLevel,sSalary,sJkCode,sJikMu,ls_date

//IF as_dataObj = "d_pif1101_16" THEN
//	ls_empno = dw_1.getitemstring(1, "empno")
//	
//	IF dw_main.RowCount() <=0 THEN
//		SetNull(sDept);	SetNull(sGrade);	SetNull(sLevel);	SetNull(sSalary);
//		SetNull(sJkCode);	SetNull(sJikMu);
//	ELSE
//		sDept   = dw_main.getitemstring(dw_main.rowcount(), "deptcode")   	// 부서
//		sGrade  = dw_main.getitemstring(dw_main.rowcount(), "gradecode")   	// 직위
//		sLevel  = dw_main.getitemstring(dw_main.rowcount(), "levelcode")   	// 직급
//		sJkCode = dw_main.getitemstring(dw_main.rowcount(), "jobkindcode")   // 직책
//		sSalary = dw_main.getitemstring(dw_main.rowcount(), "salary")   		// 호봉
//		sJikMu  = dw_main.getitemstring(dw_main.rowcount(), "jikmugubn") 		// 직부구분
//	END IF
//	
//	UPDATE "P1_MASTER"
//		SET "DEPTCODE" = :sDept,
//			 "GRADECODE" = :sGrade,
//			 "LEVELCODE" = :sLevel,
//			 "SALARY"    = :sSalary,
//			 "JOBKINDCODE" = :sJkCode,
//			 "JIKMUGUBN" = :sJikMu
//		WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :ls_empno ;
//	COMMIT;
//end if

/***************************************************************************************/
/* 경력 사항 저장시 전직경력,인정경력,총경력 갱신                                      */
/***************************************************************************************/
IF as_dataObj = "d_pif1101_8" THEN
	Long lLastYear,lServiceYear,lTotalYear
	
	ls_empno = dw_1.GetItemString(1,"empno")
	
	IF dw_main.RowCount() <=0 THEN
		SetNull(lLastYear);	SetNull(lSerViceYear);	SetNull(lTotalYear);
	ELSE
		lLastYear    = dw_main.GetItemNumber(dw_main.RowCount(),"sum_lastyear")
		lServiceYear = dw_main.GetItemNumber(dw_main.RowCount(),"sum_serviceyear")
		lTotalYear   = dw_main.GetItemNumber(dw_main.RowCount(),"sum_totalyear")
	END IF
	
	UPDATE "P1_MASTER"  
   	SET "OLDCAREER" = :lLastYear,   
          "SAVECAREER" = :lServiceYear,   
          "TOTALCAREER" = :lTotalYear  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
   	      ( "P1_MASTER"."EMPNO" = :ls_empno )   ;
	COMMIT;
END IF

String sTag,sMaxTo
/************************************************************************************/
/* 휴직 사항 저장시 기본 마스타에 자료 저장(휴직기간(from~to)이 현재일자 사이이면)  */
/************************************************************************************/
if as_dataObj = "d_pif1101_21" then
	ls_empno = dw_1.getitemstring(1, "empno")
	
	IF dw_main.RowCount() <=0 THEN
		SetNull(ls_date)
		sTag = '1'
	ELSE
		ls_date = dw_main.getitemstring(dw_main.rowcount(), "max_fr")   // 휴직최종일자(fr)
		sMaxTo  = dw_main.getitemstring(dw_main.rowcount(), "max_to")   // 휴직최종일자(to)
		IF ls_date <= gs_today AND gs_today <= sMaxTo THEN
			sTag = '2'
		ELSE
			sTag = '1'
			SetNull(ls_date)
		END IF
	END IF
	
	UPDATE "P1_MASTER"
		SET "TEMPRESTDATE" = :ls_date,
			 "SERVICEKINDCODE" = :sTag
		WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :ls_empno ;
	COMMIT;
end if

Return 1

end function

public function integer wf_delete_row (integer ll_currow);String sUpdateTag

IF dw_main.DataObject = 'd_pif1101_16' THEN
//	sUpdateTag = dw_main.GetItemString(ll_currow,"updatetag")
//	
//	IF sUpdateTag = '1' THEN
//		MessageBox("확 인","입사관련 발령사항이므로 삭제할 수 없습니다!!",StopSign!)
//		Return -1
//	END IF
END IF

Return 1
end function

public function string wf_sqlsyntax (string sjikjong);
String sGetSqlSyntax

sGetSqlSyntax = ' SELECT "EMPNO","ENTERDATE","RETIREDATE","JIKJONGGUBN","BIRTHDAY"  FROM "P1_MASTER" '

sGetSqlSyntax = sGetSqlSyntax + 'WHERE ("EMPNO" =' + "'"+ is_empno +"') AND "
sGetSqlSyntax = sGetSqlSyntax + ' ("COMPANYCODE" = ' + "'" + gs_company +"'"+")"

Return sGetSqlSynTax

end function

public subroutine wf_update_master1 (string sempno);Int il_Count
String sdate, gubn, fdate, tdate, stodate  ,sretdate

stodate = gs_today

SELECT "P1_MASTER"."TEMPRESTDATE",   
       "P1_MASTER"."SERVICEKINDCODE" , 
		 "P1_MASTER"."RETIREDATE"
  INTO :sdate,  :gubn  ,:sretdate
  FROM "P1_MASTER"  
 WHERE "P1_MASTER"."EMPNO" = :sEmpNo   ;

sle_msg.text = '휴직 사항 저장 중...'

il_Count = dw_main.RowCount()

SELECT max("P4_HUJIKHST"."FDATE")
 INTO :fdate
 FROM "P4_HUJIKHST"  
WHERE "P4_HUJIKHST"."EMPNO" = :sempno and
		"P4_HUJIKHST"."FDATE" <= :stodate ;

IF SQLCA.SQLCODE <> 0 OR fdate = '' OR ISNULL(fdate) THEN
	
ELSE			
	SELECT "P4_HUJIKHST"."TDATE"
	 INTO :tdate
	 FROM "P4_HUJIKHST"  
	WHERE "P4_HUJIKHST"."EMPNO" = :sempno and
			"P4_HUJIKHST"."FDATE" = :fdate ;
	IF tdate = '' or isnull(tdate)  THEN
		tdate = '99999999'
	END IF	
	IF stodate >= fdate and stodate <= tdate  then
		IF sretdate = '' or IsNull(sretdate) then
			gubn = '2' 
			sdate = fdate
		ELSE
			gubn = '3' 
			sdate = fdate
		END IF	
	ELSE	
		IF sretdate = '' or IsNull(sretdate) then
			gubn = '1' 
			setnull(sdate)
		ELSE
			gubn = '3' 
			setnull(sdate)
		END IF
	END IF	
			
END IF

IF il_Count <=0 THEN
	setnull(sdate)
END IF	

UPDATE "P1_MASTER"  
	SET  "TEMPRESTDATE" = :sdate ,
        "SERVICEKINDCODE"   = :gubn
 WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
		 ( "P1_MASTER"."EMPNO" = :sEmpNo )   ;		
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","휴직 사항 갱신 실패!!")
	Rollback;
	Return
END IF
COMMIT;


end subroutine

public function long wf_dataobject_change (string as_dataobject1, string as_dataobject2);integer li_rt

IF is_empno ="" OR IsNull(is_empno) THEN
ELSE
	IF IsNull(wf_exiting_data("empno",is_empno,"0")) THEN
		Messagebox("확 인","등록된 사원이 아니므로 세부사항을 등록할 수 없습니다!!")
		Return -1
	END IF
END IF

If ib_any_typing = True Then
	If dw_main.AcceptText() = 1 Then
		If f_ischanged(dw_main) Then
			ib_ischanged = True
			IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
				cb_update.TriggerEvent(Clicked!)
				IF ib_any_typing =True THEN RETURN 2
			ELSE
				ib_any_typing = False
			END IF
		End If
	Else	// Data Error
		Message.ReturnValue = 1
	End If
	
   If f_ischanged(dw_main_s1) or f_ischanged(dw_main_s1) then
		ib_ischanged = True
		IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
			cb_update.TriggerEvent(Clicked!)
			IF ib_any_typing =True THEN RETURN 2
		ELSE
			ib_any_typing = False
		END IF
	Else	// Data Error
		Message.ReturnValue = 1
	End If
End If

dw_main_s1.Dataobject = as_dataobject1
dw_main_s1.SetTransObject(SQLCA)

dw_main_s2.Dataobject = as_dataobject2
dw_main_s2.SetTransObject(SQLCA)

IF dw_main_s1.Retrieve(gs_company,is_EmpNo) <= 0 THEN
	IF rb_15.Checked = True THEN
		dw_main_s1.InsertRow(0)
		dw_main_s1.SetItem(dw_main_s1.GetRow(),"companycode",gs_company)
		dw_main_s1.SetItem(dw_main_s1.GetRow(),"empno",is_empno)
	END IF
END IF

IF dw_main_s2.Retrieve(gs_company,is_EmpNo) <= 0 THEN
	
END IF

return 1

end function

public function string wf_levelup (string level, string salary, string upday);string sdate
//
//if level = '16' or level = '15' then      //관리직 2급 3급
//   sdate = sqlca.fun_get_addday(upday, 48);
//elseif level = '14' or level = '13' then  //관리직 3급 4급
//	sdate = sqlca.fun_get_addday(upday, 60)
//elseif level = '56' then                  //일반직 1급
//	sdate = sqlca.fun_get_addday(upday, 24)
//elseif level = '55' or level = '54' or level = '53' or level = '52'then  //일반직 2,3,4,5급
//	sdate = sqlca.fun_get_addday(upday, 36)
//elseif level = '51' then                  //일반직 1급
//	sdate = sqlca.fun_get_addday(upday, 48)
//elseif level = '43' or level = '32' then  //C0, B1급
//	sdate = sqlca.fun_get_addday(upday, 33)	
//elseif level = '42' or level = '41' or level = '31' then   //C1,C2, B2 급
//	sdate = sqlca.fun_get_addday(upday, 36)	
//end if
return sdate
end function

public subroutine wf_update_master (string sempno);Int il_Count
String sEnterGbn,sJikGbn

SELECT "P1_MASTER"."JIKJONGGUBN",   "P1_MASTER"."NEWFACEKIND"  
	INTO :sJikGbn,   						:sEnterGbn  
   FROM "P1_MASTER"  
   WHERE "P1_MASTER"."EMPNO" = :sEmpNo   ;

w_mdi_frame.sle_msg.text = '발령 사항 저장 중...'

DECLARE start_sp_update_master procedure for sp_update_master(:gs_company,:sempno,:gs_today) ;
execute start_sp_update_master ;

il_Count = dw_main.RowCount()

IF il_Count <=0 THEN
	UPDATE "P1_MASTER"  
		SET "DEPTCODE" = NULL,   
		 	 "GRADECODE" = NULL,   
			 "LEVELCODE" = NULL,   
			 "SALARY" = NULL,   
			 "JOBKINDCODE" = NULL,   
			 "ENTERDATE" = NULL,
			 "RETIREDATE" = NULL,   
			 "TEMPRESTDATE" = NULL,    
			 "SERVICEKINDCODE" = '1',
			 "SSFDATE" = NULL,
			 "SSTDATE" = NULL,
			 "LEVELUPDATE" = NULL,   
			 "PROMOTIONDATE" = NULL,
			 "PRTDEPT" = NULL
		WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
				( "P1_MASTER"."EMPNO" = :sEmpNo )   ;		
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","발령 사항 갱신 실패!!")
		Rollback;
		Return
	END IF
	COMMIT;
END IF

end subroutine

public function string wf_set_radiobutton (string sflag);String sButtonNumber

IF sflag = 'BEFORE' THEN										/*이전선택 버튼 가져오기*/
	IF rb_3.Checked = True THEN
		sButtonNumber = '3'
	END IF
	
	IF rb_4.Checked = True THEN
		sButtonNumber = '4'
	END IF
	
	IF rb_5.Checked = True THEN
		sButtonNumber = '5'
	END IF
	
	IF rb_6.Checked = True THEN
		sButtonNumber = '6'
	END IF
	
	IF rb_7.Checked = True THEN
		sButtonNumber = '7'
	END IF
	
	IF rb_8.Checked = True THEN
		sButtonNumber = '8'
	END IF
	
	IF rb_9.Checked = True THEN
		sButtonNumber = '9'
	END IF
	
	IF rb_10.Checked = True THEN
		sButtonNumber = '10'
	END IF
	
	IF rb_11.Checked = True THEN
		sButtonNumber = '11'
	END IF
	
	IF rb_12.Checked = True THEN
		sButtonNumber = '12'
	END IF
	
	IF rb_13.Checked = True THEN
		sButtonNumber = '13'
	END IF
	
	IF rb_14.Checked = True THEN
		sButtonNumber = '14'
	END IF
	
	IF rb_15.Checked = True THEN
		sButtonNumber = '15'
	END IF
	
	IF rb_16.Checked = True THEN
		sButtonNumber = '16'
	END IF
	
	IF rb_17.Checked = True THEN
		sButtonNumber = '17'
	END IF
	
	IF rb_18.Checked = True THEN
		sButtonNumber = '18'
	END IF
	
	IF rb_19.Checked = True THEN
		sButtonNumber = '19'
	END IF
	
	IF rb_20.Checked = True THEN
		sButtonNumber = '20'
	END IF
	
	IF rb_21.Checked = True THEN
		sButtonNumber = '21'
	END IF
	
	Return sButtonNumber	
ELSEIF sflag = 'CURRENT' THEN									/*버튼 SETTING*/
	CHOOSE CASE sCurButton
		CASE '3'
			rb_3.Checked = True
		CASE '4'
			rb_4.Checked = True
		CASE '5'
			rb_5.Checked = True
		CASE '6'	
			rb_6.Checked = True
		CASE '7'
			rb_7.Checked = True
		CASE '8'
			rb_8.Checked = True
		CASE '9'
			rb_9.Checked = True
		CASE '10'	
			rb_10.Checked = True	
		CASE '11'
			rb_11.Checked = True
		CASE '12'
			rb_12.Checked = True
		CASE '13'
			rb_13.Checked = True
		CASE '14'	
			rb_14.Checked = True
		CASE '15'
			rb_15.Checked = True
		CASE '16'
			rb_16.Checked = True
		CASE '17'
			rb_9.Checked = True
		CASE '18'	
			rb_18.Checked = True	
		CASE '19'
			rb_19.Checked = True
		CASE '20'
			rb_20.Checked = True
		CASE '21'	
			rb_21.Checked = True	
	END CHOOSE
	Return ' '
END IF


end function

public function integer wf_itemchanged_check (string as_columnname, string as_data);String snull,sCodeName,sCmpDate,sCmpZip
Int    il_currow,lnull,lReturnRow ,iOrderSeq
long   sAmt

/*경력 계산 변수*/
Double dTotalYearMonth,dAcceptYearMonth
Long   lPerCent
String sDatef,sDatet

SetNull(snull)
SetNull(lnull)

il_currow = dw_main.GetRow()

IF TRIM(as_data) ="" OR IsNull(as_data) THEN RETURN 1

CHOOSE CASE as_ColumnName
	CASE "deptcode"																		//기본//
		sCodeName = f_code_select('부서',as_data)
		IF IsNull(sCodeName) THEN
			MessageBox("확 인","등록되지 않은 부서입니다!!")
			dw_main.SetItem(il_currow,"deptcode",snull)
			dw_main.SetItem(il_currow,"p0_dept_deptname2",snull)
			Return -1
		ELSE
			dw_main.SetItem(il_currow,"p0_dept_deptname2",sCodeName)
			dw_main.SetItem(il_currow,"prtdeptname",sCodeName)
			Return 1
		END IF
		IF dw_main.DataObject = "d_pif1101_16" THEN			//발령이면
			String sSaupcd
			select saupcd into :sSaupcd from p0_dept where deptcode = :as_data ;
			dw_main.setitem(il_currow ,'saupcd',sSaupcd)		
		end if
	CASE "gradecode"
		IF IsNull(f_code_select('직위',as_data)) THEN
			MessageBox("확 인","등록되지 않은 직위입니다!!")
			dw_main.SetItem(il_currow,"gradecode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "jobkindcode"
		IF IsNull(f_code_select('직책',as_data)) THEN
			MessageBox("확 인","등록되지 않은 직책입니다!!")
			dw_main.SetItem(il_currow,"jobkindcode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "levelcode"
		IF IsNull(f_code_select('직급',as_data)) THEN
			MessageBox("확 인","등록되지 않은 직급입니다!!")
			dw_main.SetItem(il_currow,"levelcode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "employmentcode"
		IF IsNull(f_code_select('채용',as_data)) THEN
			MessageBox("확 인","등록되지 않은 채용구분입니다!!")
			dw_main.SetItem(il_currow,"employmentcode",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "kunmugubn"
		IF IsNull(f_code_select('근무',as_data)) THEN
			MessageBox("확 인","등록되지 않은 근무구분입니다!!")
			dw_main.SetItem(il_currow,"kumnugubn",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "enterdate"																		//기본,경력//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","입사일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"enterdate",snull)
			Return -1
		ELSE
			IF dw_main.DataObject = "d_pif1101_8" THEN
				sCmpDate = Trim(dw_main.GetItemString(il_currow,"retiredate"))
				IF sCmpDate = "" OR IsNull(sCmpDate) THEN
					dw_main.SetItem(il_currow,"lastyear",lnull)
				ELSE
					dTotalYearMonth = (f_calc_year_cnt(as_data,sCmpDate,'Y') * 12) + f_calc_year_cnt(as_data,sCmpDate,'M')
					dw_main.SetItem(il_currow,"lastyear",&
								Truncate(dTotalYearMonth / 12,0) + (Mod(dTotalYearMonth,12) / 100))
								
					lPerCent = dw_main.GetItemNumber(il_currow,"serviceper")
					IF lPerCent = 0 OR IsNull(lPerCent) THEN
						
						dw_main.SetItem(il_currow,"serviceyears",lnull)
					ELSE
						dAcceptYearMonth = Truncate(dTotalYearMonth * (lPerCent / 100),0)
						dw_main.SetItem(il_currow,"serviceyears",&
								Truncate(dAcceptYearMonth / 12,0) + (Mod(dAcceptYearMonth,12) / 100))
					END IF
				END IF
			ELSEIF dw_main.DataObject = "d_pif1101_2" THEN
				dw_main.SetItem(dw_main.GetRow(),"groupenterdate",as_data)
				dw_main.SetItem(dw_main.GetRow(),"ssfdate",as_data)			/*수습일자FR*/
				IF Integer(Mid(as_data,5,2)) + 3 > 12 THEN						/*수습일자TO*/
					dw_main.SetItem(dw_main.GetRow(),"sstdate",&
					String(Integer(Left(as_data,4)) + 1) + String(Integer(Mid(as_data,5,2)) + 3 - 12,'00')+ Right(as_data,2))
				ELSE
					IF Integer(Mid(as_data,5,2)) + 3 < 10 THEN									
						dw_main.SetItem(dw_main.GetRow(),"sstdate",&
							Left(as_data,4) + String(Integer(Mid(as_data,5,2)) + 3,'00')+ Right(as_data,2))
					ELSE
						dw_main.SetItem(dw_main.GetRow(),"sstdate",&
							Left(as_data,4) + String(Integer(Mid(as_data,5,2)) + 3)+ Right(as_data,2))
					END IF
				END IF
				Return 1
			END IF
		END IF
	CASE "retiredate"																			//기본,경력//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","퇴사일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"retiredate",snull)
			Return -1
		ELSE
			IF dw_main.DataObject = "d_pif1101_8" THEN
				sCmpDate = Trim(dw_main.GetItemString(il_currow,"enterdate"))
				IF sCmpDate = "" OR IsNull(sCmpDate) THEN
					dw_main.SetItem(il_currow,"lastyear",lnull)
				ELSE
					dTotalYearMonth = (f_calc_year_cnt(sCmpDate,as_data,'Y') * 12) + f_calc_year_cnt(sCmpDate,as_data,'M')
					dw_main.SetItem(il_currow,"lastyear",&
								Truncate(dTotalYearMonth / 12,0) + (Mod(dTotalYearMonth,12) / 100))
						
					lPerCent = dw_main.GetItemNumber(il_currow,"serviceper")
					IF lPerCent = 0 OR IsNull(lPerCent) THEN
						
						dw_main.SetItem(il_currow,"serviceyears",lnull)
					ELSE
						dAcceptYearMonth = Truncate(dTotalYearMonth * (lPerCent / 100),0)
						dw_main.SetItem(il_currow,"serviceyears",&
								Truncate(dAcceptYearMonth / 12,0) + (Mod(dAcceptYearMonth,12) / 100))
					END IF
				END IF
			ELSEIF dw_main.DataObject = "d_pif1101_2" THEN
				dw_main.SetItem(dw_main.GetRow(),"servieckindcode",'3')
				Return 1
			END IF
		END IF
	CASE "promotiondate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","승진일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"promotiondate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "levelupdate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","승급일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"levelupdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "temprestdate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","휴직일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"temprestdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "groupenterdate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","그룹입사일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"groupenterdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "p1_master_projectcode"																		//기본//
		sCodeName = f_code_select('원가부서',as_data)
		IF IsNull(sCodeName) THEN
			MessageBox("확 인","등록되지 않은 원가부서입니다!!")
			dw_main.SetItem(il_currow,"p1_master_projectcode",snull)
			dw_main.SetItem(il_currow,"costdept_name",snull)
			Return -1
		ELSE
			dw_main.SetItem(il_currow,"costdept_name",sCodeName)
			Return 1
		END IF
	CASE "adddeptcode"																		//기본//
		sCodeName = f_code_select('부서',as_data)
		IF IsNull(sCodeName) THEN
			MessageBox("확 인","등록되지 않은 부서입니다!!")
			dw_main.SetItem(il_currow,"adddeptcode",snull)
			dw_main.SetItem(il_currow,"prt_dept",snull)
			Return -1
		ELSE
			dw_main.SetItem(il_currow,"prt_dept",sCodeName)
			Return 1
		END IF
	CASE "ssfdate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","수습일자(FR)을 확인하십시요!!")
			dw_main.SetItem(il_currow,"ssfdate",snull)
			Return -1
		ELSE
			sCmpDate = Trim(dw_main.GetItemString(il_currow,"sstdate"))

			IF Integer(Mid(as_data,5,2)) + 3 > 12 THEN						/*수습일자TO*/
				dw_main.SetItem(dw_main.GetRow(),"sstdate",&
					String(Integer(Left(as_data,4)) + 1) + String(Integer(Mid(as_data,5,2)) + 3 - 12,'00')+ Right(as_data,2))
			ELSE
				IF Integer(Mid(as_data,5,2)) + 3 < 10 THEN									
					dw_main.SetItem(dw_main.GetRow(),"sstdate",&
						Left(as_data,4) + String(Integer(Mid(as_data,5,2)) + 3,'00')+ Right(as_data,2))
				ELSE
					dw_main.SetItem(dw_main.GetRow(),"sstdate",&
						Left(as_data,4) + String(Integer(Mid(as_data,5,2)) + 3)+ Right(as_data,2))
				END IF
			END IF
				
			Return 1
		END IF
	CASE "sstdate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","수습일자(TO)을 확인하십시요!!")
			dw_main.SetItem(il_currow,"sstdate",snull)
			Return -1
		ELSE
			sCmpDate = Trim(dw_main.GetItemString(il_currow,"ssfdate"))
			IF sCmpDate ="" OR IsNull(sCmpDate) THEN
			ELSE
				IF sCmpDate > as_data THEN
					MessageBox("확 인","수습일자 범위를 확인하세요!!")
					dw_main.SetItem(il_currow,"ssfdate",snull)
					dw_main.SetColumn("ssfdate")
					dw_main.SetFocus()
					Return -1
				END IF
			END IF
			Return 1
		END IF	
	CASE "zipcode1"																		//기타,보증//
		sCodeName = f_code_select('우편번호',as_data)
		
		sCmpZip = Trim(dw_main.GetItemString(il_currow,"zipcode1"))
		
		IF Not IsNull(sCodeName) THEN
			dw_main.SetItem(il_currow,"address11",sCodeName)
			
			IF sCmpZip ="" OR IsNull(sCmpZip) THEN
				dw_main.SetItem(il_currow,"zipcode1",as_data)
				dw_main.SetItem(il_currow,"address21",sCodeName)
			END IF
			
			dw_main.SetColumn("address12")
			dw_main.SetFocus()
			Return 1
		END IF
	CASE "zipcode2"
		sCodeName = f_code_select('우편번호',as_data)
		IF Not IsNull(sCodeName) THEN
			dw_main.SetItem(il_currow,"address21",sCodeName)
			dw_main.SetColumn("address22")
			dw_main.SetFocus()
			Return 1
		END IF
	CASE "borncode"
		IF IsNull(f_code_select('본적',as_data)) THEN
			MessageBox("확 인","등록되지 않은 본적입니다!!")
			dw_main.SetItem(il_currow,"borncode",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "medicaldate"															//신체사항//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","신검일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"medicaldate",snull)
			Return -1
		ELSE
			lReturnRow = dw_main.Find("medicaldate = '"+as_data+"' ", 1, dw_main.RowCount())
	
			IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
				MessageBox("확 인","이미 등록된 신검일자입니다!!")
				dw_main.SetItem(il_currow, "medicaldate", sNull)
				RETURN  -1
			END IF
			Return 1
		END IF
	CASE "reservecode" 																//병역사항//
		IF as_data <> '5' THEN
			dw_main.SetItem(il_currow,"specialenrolldate",snull)
			dw_main.SetItem(il_currow,"specialenddate",snull)
		END IF
	CASE "specialenrolldate"															
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","편입일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"specialenrolldate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "specialenddate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","만료일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"specialenddate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "graduatedate"																	//학력사항//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","졸업일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"graduatedate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "enterdate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","입학일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"enterdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "serviceper"																		//경력사항//
		sDatef = Trim(dw_main.GetItemString(il_currow,"enterdate"))
		sDatet = Trim(dw_main.GetItemString(il_currow,"retiredate"))
		
		IF sDatef = "" OR IsNull(sDatef) OR sDatet ="" OR IsNull(sDatet) THEN Return 1
		
		dTotalYearMonth = (f_calc_year_cnt(sDatef,sDatet,'Y') * 12) + f_calc_year_cnt(sDatef,sDatet,'M')
		dw_main.SetItem(il_currow,"lastyear",&
								Truncate(dTotalYearMonth / 12,0) + (Mod(dTotalYearMonth,12) / 100))
						
		lPerCent = Double(as_data)
		IF lPerCent = 0 OR IsNull(lPerCent) THEN						
			dw_main.SetItem(il_currow,"serviceyears",lnull)
		ELSE
			dAcceptYearMonth = Truncate(dTotalYearMonth * (lPerCent / 100),0)
			dw_main.SetItem(il_currow,"serviceyears",&
						Truncate(dAcceptYearMonth / 12,0) + (Mod(dAcceptYearMonth,12) / 100))
		END IF
	CASE "relationcode"																//가족사항//
		IF IsNull(f_code_select('관계',as_data)) THEN
			MessageBox("확 인","등록되지 않은 관계코드입니다!!")
			dw_main.SetItem(il_currow,"relationcode",snull)
			Return -1
		ELSE
         sAmt = dw_main.GetItemNumber(il_currow,"allowamt")
			IF sAmt = 0 or isnull(sAmt) then														
				SELECT "P0_RELATION"."FAMT" INTO :sAmt 
    			FROM "P0_RELATION"  
  				WHERE "P0_RELATION"."RELATIONCODE" =:as_data   ;
				IF SQLCA.SQLCODE = 0 THEN
					dw_main.SetItem(il_currow,"allowamt",sAmt)
				END IF	
			END IF
			Return 1
		END IF	
	CASE "schoolingcode"
		IF IsNull(f_code_select('학력',as_data)) THEN
			MessageBox("확 인","등록되지 않은 학력코드입니다!!")
			dw_main.SetItem(il_currow,"schoolingcode",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "acqdate"																	//면허//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","취득일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"acqdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "updatedate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","갱신일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"updatedate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "updateindat"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","유효일자(FR)를 확인하십시요!!")
			dw_main.SetItem(il_currow,"updateindat",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "updateenddat"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","유효일자(TO)를 확인하십시요!!")
			dw_main.SetItem(il_currow,"updateenddat",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "indate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","선임일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"indate",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "licensegrade"
		IF IsNull(f_code_select('면허등급',as_data)) THEN
			MessageBox("확 인","등록되지 않은 면허등급입니다!!")
			dw_main.SetItem(il_currow,"licensegrade",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "licensecode"
		IF IsNull(f_code_select('면허',as_data)) THEN
			MessageBox("확 인","등록되지 않은 면허입니다!!")
			dw_main.SetItem(il_currow,"licensecode",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "rpcode"																		//상벌
		IF IsNull(f_code_select('상벌',as_data)) THEN
			MessageBox("확 인","등록되지 않은 상벌코드입니다!!")
			dw_main.SetItem(il_currow,"rpcode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "rpoccurdate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","상벌일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"rpoccurdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "relationcode1"																//보증//
		IF IsNull(f_code_select('관계',as_data)) THEN
			MessageBox("확 인","등록되지 않은 관계코드입니다!!")
			dw_main.SetItem(il_currow,"relationcode1",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "relationcode2"																//가족사항//
		IF IsNull(f_code_select('관계',as_data)) THEN
			MessageBox("확 인","등록되지 않은 관계코드입니다!!")
			dw_main.SetItem(il_currow,"relationcode2",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "affiliatecode"
		IF IsNull(f_code_select('관계처',as_data)) THEN
			MessageBox("확 인","등록되지 않은 관계처코드입니다!!")
			dw_main.SetItem(il_currow,"affiliatecode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "orderdate"																	//발령
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","발령일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"orderdate",snull)
			Return -1
		ELSE
			iOrderSeq = f_get_order_Seq(gs_company,is_EmpNo,as_data)
			dw_main.SetItem(il_currow,"seq",iOrderSeq)
		END IF
	CASE "ordercode"						
		String sTag
		
		IF IsNull(f_code_select('발령',as_data)) THEN
			MessageBox("확 인","등록되지 않은 발령코드입니다!!")
			dw_main.SetItem(il_currow,"ordercode",snull)
			Return -1
		ELSE
			SELECT "P0_ORDER"."UPDATETAG"  
    			INTO :sTag  
    			FROM "P0_ORDER"  
   			WHERE "P0_ORDER"."ORDERCODE" = :as_data   ;

//			lReturnRow = dw_main.Find("updatetag = '"+sTag+"' ", 1, dw_main.RowCount())
//			
//			IF (il_currow <> lReturnRow) and (lReturnRow <> 0) AND sTag = '1' THEN
//				MessageBox("확 인","입사 관련 발령사항은 한번만 등록할 수 있습니다.!!")
//				dw_main.SetItem(il_currow, "ordercode", sNull)
//				RETURN  -1
//			END IF
			
			dw_main.SetItem(il_currow,"updatetag",sTag)
			Return 1
		END If
	CASE "jikmugubn"																	
		IF IsNull(f_code_select('직무',as_data)) THEN
			MessageBox("확 인","등록되지 않은 직무구분입니다!!")
			dw_main.SetItem(il_currow,"jikmugubn",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "prtdept"																		/*발령*/
		sCodeName = f_code_select('부서',as_data)
		IF IsNull(sCodeName) THEN
			MessageBox("확 인","등록되지 않은 부서입니다!!")
			dw_main.SetItem(il_currow,"prtdept",snull)
			dw_main.SetItem(il_currow,"prtdeptname",snull)
			Return -1
		ELSE
			dw_main.SetItem(il_currow,"prtdeptname",sCodeName)
			Return 1
		END IF
	CASE "realorddatefrom"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","시행일자(from)를 확인하십시요!!")
			dw_main.SetItem(il_currow,"realorddatefrom",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "ssgubn"
		IF as_data <> 'Y' AND as_data <> 'N' THEN
			MessageBox("확 인","수습은 Y 또는 N입니다!!")
			dw_main.SetItem(il_currow,"ssgubn",'N')
			Return -1
		END IF
	CASE "realorddateto"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","시행일자(to)를 확인하십시요!!")
			dw_main.SetItem(il_currow,"realorddateto",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "circlecode"																	//동호회
		IF IsNull(f_code_select('동호회',as_data)) THEN
			MessageBox("확 인","등록되지 않은 동호회코드입니다!!")
			dw_main.SetItem(il_currow,"circlecode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "circleindate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","가입일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"circleindate",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "circleenddate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","탈퇴일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"circleenddate",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "ccggubn"
		dw_main.SetItem(il_currow,"amt",lnull)
		dw_main.SetItem(il_currow,"ccgpgubn",snull)
		dw_main.SetItem(il_currow,"ccgper",lnull)
	CASE "educationcode"																	//교육
		IF IsNull(f_code_select('교육',as_data)) THEN
			MessageBox("확 인","등록되지 않은 교육코드입니다!!")
			dw_main.SetItem(il_currow,"educationcode",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "startdate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","시작일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"startdate",snull)
			Return -1
		ELSE
			Return 1
		END IF	
	CASE "enddate"	
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","종료일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"enddate",snull)
			Return -1
		ELSE
			Return 1
		END IF			
	CASE "Fdate"																	//휴직사항//
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","휴직일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"Fdate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "lenddate"																/*개인지급품*/
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","지급일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"lenddate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "item"		
		IF IsNull(f_code_select('품목',as_data)) THEN
			MessageBox("확 인","등록되지 않은 품목입니다!!")
			dw_main.SetItem(il_currow,"item",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "returndate"
		IF f_datechk(as_data) = -1 THEN
			MessageBox("확 인","반납일자를 확인하십시요!!")
			dw_main.SetItem(il_currow,"returndate",snull)
			Return -1
		ELSE
			Return 1
		END IF
	CASE "sizegubn"		
		IF IsNull(f_code_select('규격',as_data)) THEN
			MessageBox("확 인","등록되지 않은 규격입니다!!")
			dw_main.SetItem(il_currow,"sizegubn",snull)
			Return -1
		ELSE
			Return 1
		END IF		
END CHOOSE

Return 1

end function

public function long wf_change_dataobj (string as_dataobject);integer li_rt

IF is_empno ="" OR IsNull(is_empno) THEN
ELSE
	IF IsNull(wf_exiting_data("empno",is_empno,"0")) THEN
		Messagebox("확 인","등록된 사원이 아니므로 세부사항을 등록할 수 없습니다!!")
		Return -1
	END IF
END IF

IF ib_any_typing =True THEN
	If dw_main.AcceptText() = 1 Then
		If f_ischanged(dw_main) Then
			ib_ischanged = True
			IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN 
				cb_update.TriggerEvent(Clicked!)	
				IF ib_any_typing = True THEN RETURN 2
			ELSE
				ib_any_typing = False
				ib_ischanged  = False
			END IF
		End If
	Else	// Data Error
		Message.ReturnValue = 1
	End If
	If dw_main_s1.AcceptText() = 1 or dw_main_s2.AcceptText() = 1 Then
		If f_ischanged(dw_main_s1) or f_ischanged(dw_main_s2) Then
			ib_ischanged = True
			IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN 
				cb_update.TriggerEvent(Clicked!)		
				IF ib_any_typing = True THEN RETURN 2
			ELSE
				ib_any_typing = False
				ib_ischanged  = False
			END IF
		End If
	Else	// Data Error
		Message.ReturnValue = 1
	End If
End If

dw_main.Dataobject = as_dataobject
dw_main.SetTransObject(SQLCA)

IF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :is_empno )   ;
	IF sEnterDate ="" OR IsNull(sEnterDate) THEN 
		lYearCnt = 0
	ELSE
		lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	END IF
	dw_main.Retrieve(gs_company,is_empno,lYearCnt) 
	
ELSE
	IF dw_main.Retrieve(gs_company,is_EmpNo,'%') <= 0 THEN
		IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
					rb_22.Checked = True OR	rb_7.Checked = True OR rb_14.Checked = True THEN
			dw_main.InsertRow(0)
			dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
			dw_main.SetItem(dw_main.GetRow(),"empno",is_empno)
			IF rb_22.Checked =True THEN
				dw_main.SetItem(dw_main.GetRow(),'trusteename',f_get_empname(is_empno)) /*계좌의 예금주를 사원명으로 자동 셋팅*/
			END IF
			is_status = '1'														/*등록*/
		END IF
	ELSE
		is_status = '2'
	End If
END IF

IF rb_19.Checked = True or rb_23.Checked = True THEN
	cb_insert.Enabled = False
	cb_update.Enabled = False
	cb_delete.Enabled = False
ELSE
	cb_insert.Enabled = True
	cb_update.Enabled = True
	cb_delete.Enabled = True	
END IF

Return 1
end function

public function integer wf_required_check (string as_dataobj, integer al_row);string ls_code, ls_relation, ls_name, ls_date, ls_educ, ls_saupcd, ls_paygubn, ls_kmgubn, ls_kunmugubn
string sDept, sGrade, sLevel, sJkCode, ls_EmpNo, sSalary,sJikMu
integer li_seq

IF (dw_main_s1.DataObject = "d_pif1101_11" OR dw_main_s1.DataObject = "d_pif1101_14") AND il_select_dw = 1 THEN
	ls_code   = dw_main_s1.GetItemString(al_row,"empno")
ELSEIF (dw_main_s2.DataObject = "d_pif1101_19" OR dw_main_s2.DataObject = "d_pif1101_20") AND il_select_dw = 0 THEN
	ls_code   = dw_main_s2.GetItemString(al_row,"empno")
ELSE
	ls_code   = dw_1.GetItemString(1,"empno")
END IF
IF ls_code ="" OR IsNull(ls_code) THEN
	MessageBox("확 인","사번은 필수입력항목입니다!!")
	w_mdi_frame.sle_msg.text ="작업을 취소하시고 다시 작업하십시요!!"
	dw_1.SetFocus()
	Return -1
END IF
	
dw_main.AcceptText()
IF as_dataObj = "d_pif1101_2" THEN   // 기본
	String sres_no1,sres_no2,senterdate,ssfdate,sstdate,sMidinNo
		
	sres_no1   = dw_main.GetItemString(al_row, "residentno1")
	sres_no2   = dw_main.GetItemString(al_row, "residentno2")
	
	sLevel     = dw_main.GetItemString(al_row, "levelcode")
	sSalary    = dw_main.GetItemString(al_row, "salary")
	senterdate = dw_main.GetItemString(al_row, "enterdate")
	
	sMidinNo   = dw_main.GetItemString(al_row, "medinsuranceno")
	
	sstdate = dw_main.GetItemString(al_row, "ssfdate")
	ssfdate = dw_main.GetItemString(al_row, "sstdate")
	
	IF sres_no1 ="" OR IsNull(sres_no1) THEN
		MessageBox("확 인","주민등록번호를 입력하십시요!!")
		dw_main.SetColumn("residentno1")
		dw_main.SetFocus()
		Return -1
	END IF
	IF sres_no2 ="" OR IsNull(sres_no2) THEN
		MessageBox("확 인","주민등록번호를 입력하십시요!!")
		dw_main.SetColumn("residentno2")
		dw_main.SetFocus()
		Return -1
	END IF	

ELSEIF as_dataObj = "d_pif1101_3" THEN   // 주소
	String saddress
		
	saddress = dw_main.GetItemString(al_row,"address11")
	IF saddress ="" OR IsNull(saddress) THEN
		MessageBox("확 인","주소를 입력하십시요!!")
		dw_main.SetColumn("address11")
		dw_main.SetFocus()
		Return -1
	END If

elseif as_dataobj = "d_pif1101_5" then   // 신체
	String sMedicalDate
	
	sMedicalDate = Trim(dw_main.GetItemString(al_row,"medicaldate"))
	
	IF sMedicalDate ="" OR IsNull(sMedicalDate) THEN
		MessageBox("확 인","신검일자를 입력하십시요!!")
		dw_main.SetColumn("medicaldate")
		dw_main.SetFocus()
		Return -1
	END IF
	
elseif as_dataobj = "d_pif1101_6" then   // 병역
ELSEIF as_dataObj = "d_pif1101_7" THEN   // 학력
	li_seq  = dw_main.GetItemNumber(al_row,"seq")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
elseif as_dataObj = "d_pif1101_8"  THEN   // 경력
	li_seq  = dw_main.GetItemNumber(al_row,"seq")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_9" THEN   // 가족
	
	li_seq  = dw_main.GetItemNumber(al_row,"seq")
	ls_relation = dw_main.GetItemString(al_row,"relationcode")
	ls_name = dw_main.GetItemString(al_row,"familyname")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_relation ="" OR IsNull(ls_relation) THEN
		MessageBox("확 인","관계를 입력하십시요!!")
		dw_main.SetColumn("relationcode")
		dw_main.SetFocus()
		Return -1
	END IF
	IF ls_name ="" OR IsNull(ls_name) THEN
		MessageBox("확 인","성명을 입력하십시요!!")
		dw_main.SetColumn("familyname")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataobj ="d_pif1101_10" THEN   // 면허
	
	ls_name = dw_main.GetItemString(al_row,"licensecode")
	IF ls_name ="" OR IsNull(ls_name) THEN
		MessageBox("확 인","면허종류를 입력하십시요!!")
		dw_main.SetColumn("licensecode")
		dw_main.SetFocus()
		Return -1
	END IF
   
	ls_name = dw_main.GetItemString(al_row,"licensegrade")
	IF ls_name ="" OR IsNull(ls_name) THEN
		MessageBox("확 인","면허등급을 입력하십시요!!")
		dw_main.SetColumn("licensegrade")
		dw_main.SetFocus()
		Return -1
	END IF
elseif as_dataobj ="d_pif1101_11" then   // 외국어
	String sLangCode
	
	sLangCode = dw_main_s1.GetItemString(1,"languagecode")
	IF sLangCode ="" OR IsNull(sLangCode) THEN
		MessageBox("확 인","외국어코드를 입력하십시요!!")
		dw_main_s1.SetColumn("languagecode")
		dw_main_s1.SetFocus()
		Return -1
	END IF
	
ELSEIF as_dataObj = 	"d_pif1101_12" THEN   // 상벌
	String srpcode
	
	ls_date = dw_main.GetItemString(al_row,"rpoccurdate")
	srpcode = dw_main.GetItemString(al_row,"rpcode")
	
	IF srpcode ="" OR IsNull(srpcode) THEN
		MessageBox("확 인","상벌코드를 입력하십시요!!")
		dw_main.SetColumn("rpcode")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_date ="" OR IsNull(ls_date) THEN
		MessageBox("확 인","시행일자를 입력하십시요!!")
		dw_main.SetColumn("rpoccurdate")
		dw_main.SetFocus()
		Return -1
	END IF
elseif as_dataobj = "d_pif1101_14" then   // 여권
ELSEIF as_dataObj = "d_pif1101_15" THEN   // 지인
	li_seq  = dw_main.GetItemNumber(al_row,"seq")
	ls_relation = dw_main.GetItemString(al_row,"affiliatecode")
	ls_name = dw_main.GetItemString(al_row,"name")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_relation ="" OR IsNull(ls_relation) THEN
		MessageBox("확 인","관계처를 입력하십시요!!")
		dw_main.SetColumn("affiliatecode")
		dw_main.SetFocus()
		Return -1
	END IF
	IF ls_name ="" OR IsNull(ls_name) THEN
		MessageBox("확 인","관계자를 입력하십시요!!")
		dw_main.SetColumn("name")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_16" THEN   // 발령
	String sOrdDate,sOrdCode,sOrdNo,sReOrdDate, sjik
	Int    iSeq
	
	sOrdDate   = dw_main.GetItemString(al_row,"orderdate")
	iseq       = dw_main.GetItemNumber(al_row,"seq")
	sOrdCode   = dw_main.GetItemString(al_row,"ordercode")
	sLevel     = dw_main.GetItemString(al_row, "levelcode")
	sSalary    = dw_main.GetItemString(al_row, "salary")
	sReOrdDate = Trim(dw_main.GetItemString(al_row,"realorddatefrom"))
	sjik       = dw_main.GetItemString(al_row, "jikjonggubn")
	ls_saupcd  = dw_main.GetItemString(al_row, "saupcd")
	ls_paygubn = dw_main.GetItemString(al_row, "paygubn")
	ls_kmgubn  = dw_main.GetItemString(al_row, "kmgubn")
	ls_kunmugubn = dw_main.GetItemString(al_row, "kunmugubn")
		
	IF sOrdDate ="" OR IsNull(sOrdDate) THEN
		MessageBox("확 인","발령일자를 입력하십시요!!")
		dw_main.SetColumn("orderdate")
		dw_main.SetFocus()
		Return -1
	END IF
	IF iSeq =0 OR IsNull(iSeq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
	IF sOrdCode ="" OR IsNull(sOrdCode) THEN
		MessageBox("확 인","발령구분을 입력하십시요!!")
		dw_main.SetColumn("ordercode")
		dw_main.SetFocus()
		Return -1
	END IF

	IF sLevel ="" OR IsNull(sLevel) THEN
		MessageBox("확 인","직급을 입력하십시요!!")
		dw_main.SetColumn("levelcode")
		dw_main.SetFocus()
		Return -1
	END IF	
	
	IF sjik ="" OR IsNull(sjik) THEN
		MessageBox("확 인","직종을 입력하십시요!!")
		dw_main.SetColumn("jikjonggubn")
		dw_main.SetFocus()
		Return -1
	END IF	
	
	IF sReOrdDate ="" OR IsNull(sReOrdDate) THEN
		MessageBox("확 인","시행일자를 입력하십시요!!")
		dw_main.SetColumn("realorddatefrom")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_paygubn ="" OR IsNull(ls_paygubn) THEN
		MessageBox("확 인","급여구분을 입력하십시요!!")
		dw_main.SetColumn("paygubn")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_kmgubn ="" OR IsNull(ls_kmgubn) THEN
		MessageBox("확 인","세금적용구분을 입력하십시요!!")
		dw_main.SetColumn("kmgubn")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_kunmugubn ="" OR IsNull(ls_kunmugubn) THEN
		MessageBox("확 인","근무구분을 입력하십시요!!")
		dw_main.SetColumn("kunmugubn")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_17" THEN   // 동호회
	String scircle

	scircle = dw_main.GetItemString(al_row,"circlecode")
	
	IF scircle ="" OR IsNull(scircle) THEN
		MessageBox("확 인","동호회코드를 입력하십시요!!")
		dw_main.SetColumn("circlecode")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_18" THEN   // 교육
	li_seq  = dw_main.GetItemNumber(al_row,"seq")
	ls_educ = dw_main.GetItemString(al_row,"educationcode")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main.SetColumn("seq")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_educ ="" OR IsNull(ls_educ) THEN
		MessageBox("확 인","교육코드를 입력하십시요!!")
		dw_main.SetColumn("educationcode")
		dw_main.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_11" THEN   // 외국어
	ls_educ = dw_main_s1.GetItemString(al_row,"languagecode")
	
	IF ls_educ ="" OR IsNull(ls_educ) THEN
		MessageBox("확 인","외국어코드를 입력하십시요!!")
		dw_main_s1.SetColumn("languagecode")
		dw_main_s1.SetFocus()
		Return -1
	END IF
	
ELSEIF as_dataObj = "d_pif1101_19" THEN   // 외국어
	ls_educ = dw_main_s2.GetItemString(al_row,"flicensecode")
	
	IF ls_educ ="" OR IsNull(ls_educ) THEN
		MessageBox("확 인","자격코드를 입력하십시요!!")
		dw_main_s2.SetColumn("flicensecode")
		dw_main_s2.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_20" THEN   // 여권
	li_seq  = dw_main_s2.GetItemNumber(al_row,"seq")
	
	IF IsNull(li_seq) THEN
		MessageBox("확 인","순번을 입력하십시요!!")
		dw_main_s2.SetColumn("seq")
		dw_main_s2.SetFocus()
		Return -1
	END IF
ELSEIF as_dataObj = "d_pif1101_21" THEN   // 휴직
	String ls_dateto
	
	ls_date = dw_main.GetItemString(al_row,"Fdate")
	ls_Dateto = dw_main.GetItemString(al_row,"Tdate")	
	
	IF ls_date ="" OR IsNull(ls_date) THEN
		MessageBox("확 인","휴직일자FROM를 입력하십시요!!")
		dw_main.SetColumn("Fdate")
		dw_main.SetFocus()
		Return -1
	END IF
	IF ls_DateTo <> "" or NOT IsNull(ls_Dateto) THEN
		IF f_datechk(ls_dateto) = -1 THEN
			MessageBox("확 인","휴직일자TO를 확인하십시요!!")
         dw_main.SetColumn("Tdate")
		   dw_main.SetFocus()
			Return -1
		ELSE
			IF ls_date > ls_dateto then
				MessageBox("확 인","휴직일자FROM > 휴직일자TO !!")
   	      dw_main.SetColumn("Fdate")
			   dw_main.SetFocus()
				Return -1
			END IF	
		END IF
	END IF    
ELSEIF as_dataObj = "d_pif1101_22" THEN   // 개인 지급품
	String sLendDate,sItem
	
	sLendDate = Trim(dw_main.GetItemString(al_row,"lenddate"))
	sItem     = dw_main.GetItemString(al_row,"item")
	
	IF sLendDate ="" OR IsNull(sLendDate) THEN
		MessageBox("확 인","지급일자를 입력하십시요!!")
		dw_main.SetColumn("lenddate")
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF sItem ="" OR IsNull(sItem) THEN
		MessageBox("확 인","품목을 입력하십시요!!")
		dw_main.SetColumn("item")
		dw_main.SetFocus()
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_betch_delete (string as_dataobj);
String ls_empno,sDept,sGrade,sLevel,sSalary,sJkCode,sJikMu,ls_date,sMaxDate
Int    iMaxSeq

// 발령 사항 삭제시 기본 마스타에 자료 저장
//IF as_dataObj = "d_pif1101_16" THEN
//	ls_empno = dw_1.getitemstring(1, "empno")
//	
//	IF dw_main.RowCount() <=0 THEN
//		SetNull(sDept);	SetNull(sGrade);	SetNull(sLevel);	SetNull(sSalary);
//		SetNull(sJkCode);	SetNull(sJikMu);
//	ELSE
//		sMaxDate = dw_main.getitemstring(dw_main.rowcount(), "max_orderdate")	/*최근 발령일자*/
//		
//		SELECT MAX("P1_ORDERS"."SEQ")
//			INTO :iMaxSeq
//		   FROM "P1_ORDERS"  
//   		WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND  
//         		( "P1_ORDERS"."EMPNO" = :ls_empno ) AND  
//         		( "P1_ORDERS"."ORDERDATE" = :sMaxDate ) ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			SetNull(sDept);	SetNull(sGrade);	SetNull(sLevel);	SetNull(sSalary);
//			SetNull(sJkCode);	SetNull(sJikMu);			
//		ELSE
//			SELECT "P1_ORDERS"."DEPTCODE",   "P1_ORDERS"."GRADECODE", "P1_ORDERS"."JOBKINDCODE",   
// 					 "P1_ORDERS"."LEVELCODE",  "P1_ORDERS"."SALARY",    "P1_ORDERS"."JIKMUGUBN"  
//				INTO :sDept,						:sGrade,						 :sJkCode,
//					  :sLevel,						:sSalary,					 :sJikMu
//				FROM "P1_ORDERS"  
//   			WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND  
//         			( "P1_ORDERS"."EMPNO" = :ls_empno ) AND  
//         			( "P1_ORDERS"."ORDERDATE" = :sMaxDate ) AND
//						( "P1_ORDERS"."SEQ" = :iMaxSeq) ;
//		END IF
//	END IF
//	
//	UPDATE "P1_MASTER"
//		SET "DEPTCODE" = :sDept,
//			 "GRADECODE" = :sGrade,
//			 "LEVELCODE" = :sLevel,
//			 "SALARY"    = :sSalary,
//			 "JOBKINDCODE" = :sJkCode,
//			 "JIKMUGUBN" = :sJikMu
//		WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :ls_empno ;
//end if

/*경력 사항 삭제시 전직경력,인정경력,총경력 갱신*/
IF as_dataObj = "d_pif1101_8" THEN
	Long lLastYear,lServiceYear,lTotalYear
	
	ls_empno = dw_1.GetItemString(1,"empno")
	
	IF dw_main.RowCount() <=0 THEN
		SetNull(lLastYear);	SetNull(lSerViceYear);	SetNull(lTotalYear);
	ELSE
		lLastYear    = dw_main.GetItemNumber(dw_main.RowCount(),"sum_lastyear")
		lServiceYear = dw_main.GetItemNumber(dw_main.RowCount(),"sum_serviceyear")
		lTotalYear   = dw_main.GetItemNumber(dw_main.RowCount(),"sum_totalyear")
	END IF
	
	UPDATE "P1_MASTER"  
   	SET "OLDCAREER" = :lLastYear,   
          "SAVECAREER" = :lServiceYear,   
          "TOTALCAREER" = :lTotalYear  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
   	      ( "P1_MASTER"."EMPNO" = :ls_empno )   ;
END IF

// 휴직 사항 삭제시 기본 마스타에 자료 저장
String sTag,sMaxTo

if as_dataObj = "d_pif1101_21" then
	ls_empno = dw_1.getitemstring(1, "empno")
	
	IF dw_main.RowCount() <=0 THEN
		SetNull(ls_date)
		sTag = '1'
	ELSE
		ls_date = dw_main.getitemstring(dw_main.rowcount(), "max_fr")   // 휴직최종일자(fr)
		sMaxTo  = dw_main.getitemstring(dw_main.rowcount(), "max_to")   // 휴직최종일자(to)
		IF ls_date <= gs_today AND gs_today <= sMaxTo THEN
			sTag = '2'
		ELSE
			sTag = '1'
			SetNull(ls_date)
		END IF
	END IF
	
	UPDATE "P1_MASTER"
		SET "TEMPRESTDATE" = :ls_date,
			 "SERVICEKINDCODE" = :sTag
		WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :ls_empno ;
end if

Return 1
end function

public subroutine wf_get_image (string sempno);blob imagedata, b
int li_FileNum,loops, i
long flen, bytes_write, new_pos, ll_rctn
String ls_filename
Constant Long LENGTH = 32765

imagedata = Blob(Space(0))

selectblob image into :imagedata
from p1_master_pic
WHERE empno = :sempno	;

ls_filename = gs_picpath + sempno + ".jpg"

If SQLCA.SQLCode < 0 Then
   filedelete(ls_filename)    
	return
Elseif SQLCA.SQLCode = 100 Then
   filedelete(ls_filename)
	return
Elseif IsNull(imagedata) or len(imagedata) = 0 Then
   filedelete(ls_filename)
	return
End If


flen = Len(imagedata)
if len(imagedata) >= LENGTH then
//	li_FileNum = FileOpen(ls_filename, StreamMode!, Write!, Shared!, append!)
	li_FileNum = FileOpen(ls_filename, StreamMode!, Write!, LockWrite!, Replace!)
	IF Mod(flen, LENGTH) = 0 THEN
		loops = flen/LENGTH
	ELSE
	  loops = (flen/LENGTH) + 1
	END IF
ELSE
	li_FileNum = FileOpen(ls_filename, StreamMode!, Write!, LockWrite!, Replace!)
	loops = 1
end if		


// Write the file
new_pos = 0
FOR i = 1 to loops
    b = BlobMid(imagedata, new_pos + 1, LENGTH)
	 new_pos += LENGTH
    FileWrite(li_FileNum, b)
NEXT

FileClose(li_FileNum)

p_1.SetPicture(imagedata)

end subroutine

on w_pif1101.create
int iCurrent
call super::create
this.p_1=create p_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_5=create gb_5
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.rb_10=create rb_10
this.rb_11=create rb_11
this.rb_12=create rb_12
this.rb_13=create rb_13
this.rb_14=create rb_14
this.rb_15=create rb_15
this.rb_16=create rb_16
this.rb_17=create rb_17
this.rb_19=create rb_19
this.dw_1=create dw_1
this.rb_18=create rb_18
this.rb_9=create rb_9
this.rb_20=create rb_20
this.rb_21=create rb_21
this.cb_kunmuil=create cb_kunmuil
this.dw_main=create dw_main
this.dw_main_s1=create dw_main_s1
this.dw_main_s2=create dw_main_s2
this.rb_22=create rb_22
this.rb_23=create rb_23
this.dw_5=create dw_5
this.dw_4=create dw_4
this.cbx_1=create cbx_1
this.dw_up=create dw_up
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.gb_4
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.gb_5
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.rb_4
this.Control[iCurrent+12]=this.rb_5
this.Control[iCurrent+13]=this.rb_6
this.Control[iCurrent+14]=this.rb_7
this.Control[iCurrent+15]=this.rb_8
this.Control[iCurrent+16]=this.rb_10
this.Control[iCurrent+17]=this.rb_11
this.Control[iCurrent+18]=this.rb_12
this.Control[iCurrent+19]=this.rb_13
this.Control[iCurrent+20]=this.rb_14
this.Control[iCurrent+21]=this.rb_15
this.Control[iCurrent+22]=this.rb_16
this.Control[iCurrent+23]=this.rb_17
this.Control[iCurrent+24]=this.rb_19
this.Control[iCurrent+25]=this.dw_1
this.Control[iCurrent+26]=this.rb_18
this.Control[iCurrent+27]=this.rb_9
this.Control[iCurrent+28]=this.rb_20
this.Control[iCurrent+29]=this.rb_21
this.Control[iCurrent+30]=this.cb_kunmuil
this.Control[iCurrent+31]=this.dw_main
this.Control[iCurrent+32]=this.dw_main_s1
this.Control[iCurrent+33]=this.dw_main_s2
this.Control[iCurrent+34]=this.rb_22
this.Control[iCurrent+35]=this.rb_23
this.Control[iCurrent+36]=this.dw_5
this.Control[iCurrent+37]=this.dw_4
this.Control[iCurrent+38]=this.cbx_1
this.Control[iCurrent+39]=this.dw_up
this.Control[iCurrent+40]=this.rr_1
this.Control[iCurrent+41]=this.rr_2
this.Control[iCurrent+42]=this.rr_3
end on

on w_pif1101.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_5)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.rb_10)
destroy(this.rb_11)
destroy(this.rb_12)
destroy(this.rb_13)
destroy(this.rb_14)
destroy(this.rb_15)
destroy(this.rb_16)
destroy(this.rb_17)
destroy(this.rb_19)
destroy(this.dw_1)
destroy(this.rb_18)
destroy(this.rb_9)
destroy(this.rb_20)
destroy(this.rb_21)
destroy(this.cb_kunmuil)
destroy(this.dw_main)
destroy(this.dw_main_s1)
destroy(this.dw_main_s2)
destroy(this.rb_22)
destroy(this.rb_23)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.cbx_1)
destroy(this.dw_up)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;il_select_dw = 9

dw_1.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_main_s1.SetTransObject(SQLCA)
dw_main_s2.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()

ib_any_typing	= False													/*항목변경*/
ib_ischanged   = False													/*변경여부*/

dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_5.insertrow(0)
dw_5.setitem(1,'sdate', gs_today)

f_set_saupcd(dw_5, 'saup', '1')
is_saupcd = gs_saupcd

IF dw_4.retrieve(gs_company,'%','%',gs_today, is_saupcd, '%') < 1 THEN
	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(1,"companycode",gs_company)
END IF

is_new = 'N'
is_status = '1'															/*등록*/
end event

type p_mod from w_inherite_standard`p_mod within w_pif1101
integer x = 3886
integer taborder = 120
end type

event p_mod::clicked;Int il_currow
String snull, ls_empno, ls_deptcode, ls_saupcd

setpointer(hourglass!)

SetNull(snull)

dw_1.Accepttext()
ls_empno = dw_1.GetitemString(1,'empno')
ls_deptcode = dw_1.GetItemString(1, 'deptcode')

// 이렇게 하면 발령에 이전 사업장이 들어가니까 안되지!! <이정경>
//IF dw_main.DataObject = "d_pif1101_16" THEN
//	SELECT saupcd INTO :ls_saupcd
//	FROM p0_dept WHERE companycode = :gs_company AND deptcode = :ls_deptcode;
//	IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN ls_saupcd = '10'
//	
//	dw_main.Setitem(dw_main.Getrow(), 'saupcd', ls_saupcd)
//END IF

IF rb_12.Checked = True OR rb_15.Checked =True THEN
	IF dw_main_s1.Accepttext() = -1 THEN 	RETURN
	
	IF ib_ischanged = False THEN
		IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	END IF
	
	IF dw_main_s1.RowCount() > 0 AND rb_12.Checked = True THEN
		IF wf_required_check(dw_main_s1.DataObject,dw_main_s1.GetRow()) = -1 THEN RETURN
		
		IF dw_main_s1.Update() > 0 THEN			
			ib_any_typing = False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
		ELSE
			ROLLBACK USING sqlca;
			ib_any_typing = True
			ib_ischanged  = True
			Return
		END IF
	ELSEIF rb_15.Checked = True AND dw_main_s1.DataObject ='d_pif1101_14' THEN
		IF dw_main_s1.GetItemString(1,"passportno") <> "" AND &
												Not IsNull(dw_main_s1.GetItemString(1,"passportno")) THEN
			IF dw_main_s1.Update() > 0 THEN			
				ib_any_typing =False
				ib_ischanged  = False
				w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
			ELSE
				ROLLBACK USING sqlca;
				ib_any_typing = True
				ib_ischanged  = True
				Return
			END IF
		END IF
	ELSE
		IF dw_main_s1.Update() > 0 THEN			
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
		ELSE
			ROLLBACK USING sqlca;
			ib_any_typing = True
			ib_ischanged  = True
			Return
		END IF
	END IF
	dw_main_s1.SetFocus()

	IF dw_main_s2.Accepttext() = -1 THEN 	RETURN

	IF dw_main_s2.RowCount() > 0 THEN
		IF wf_required_check(dw_main_s2.DataObject,dw_main_s2.GetRow()) = -1 THEN RETURN
	END IF
	IF dw_main_s2.Update() > 0 THEN			
		COMMIT USING sqlca;
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	ELSE
		ROLLBACK USING sqlca;
		ib_any_typing = True
		ib_ischanged  = True
		Return
	END IF
	dw_main_s2.SetFocus()
ELSE
	IF dw_main.Accepttext() = -1 THEN 	RETURN

	IF dw_main.RowCount() > 0 THEN
		IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
	END IF

	IF ib_ischanged = False THEN
		IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	END IF
	
	IF dw_main.Update() > 0 THEN			
		COMMIT USING sqlca;
		ib_any_typing =False
		ib_ischanged  = False
		
		/*발령사항 저장 시 인사 마스타 갱신*/
		IF rb_17.Checked = True THEN
			wf_update_master(is_empno)
		END IF
		IF rb_3.Checked = True AND is_status = '1' THEN		/*신입사원 등록시 근무일 생성*/
//			cb_kunmuil.TriggerEvent(Clicked!)
		END IF
			
		IF rb_3.Checked = True THEN
			IF dw_1.Retrieve(gs_company,ls_empno,'%') < 1 THEN
				dw_1.InsertRow(0)
				MessageBox('','사원 자료가 저장되지 않았습니다!')
			END IF

		ELSEIF rb_17.Checked = True THEN
			long ll_foundrow

			dw_1.SetRedraw(false)
			dw_4.SetRedraw(false)
			dw_main.SetREdraw(false)
			ll_foundrow = dw_4.Find( "empno = '" + ls_empno + "'", 1, dw_4.RowCount())
			if ll_foundrow > 0 then
				p_inq.Triggerevent(Clicked!)
			else
				dw_5.Event ue_retrieve()
				ll_foundrow = dw_4.Find( "empno = '" + ls_empno + "'", 1, dw_4.RowCount())
				if ll_foundrow > 0 then
					dw_5.Event rowfocuschanged(ll_foundrow)
				end if
  		   end if  
			
			dw_4.ScrollToRow(ll_foundrow)
			
			dw_1.SetRedraw(true)
			dw_4.SetRedraw(true)
			dw_main.SetREdraw(true)
	END IF
		/*휴직사항 저장 시 인사 마스타 갱신*/
		IF rb_20.Checked = True THEN
			wf_update_master1(is_empno)
		END IF
		
		w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	ELSE
		ROLLBACK USING sqlca;
		ib_any_typing = True
		ib_ischanged  = True
		Return
	END IF
	
	dw_main.Setfocus()
END IF

setpointer(arrow!)
end event

type p_del from w_inherite_standard`p_del within w_pif1101
integer x = 4059
integer taborder = 140
end type

event p_del::clicked;Int il_currow ,count
String ls_empno

IF rb_3.Checked = True THEN
	dw_1.accepttext()
	
	ls_empno = dw_1.getitemstring(1, "empno")
	// 급여기본자료 확인
	SELECT count(*)  
   	INTO :count  
      FROM "P3_PERSONAL"  
      WHERE ( "P3_PERSONAL"."COMPANYCODE" = :gs_company ) AND ( "P3_PERSONAL"."EMPNO" = :ls_empno )   ;

   if sqlca.sqlcode >= 0 and count >= 1 then
		if messagebox("확인","급여기본자료가 존재합니다. 계속하시겠습니까?", question!, yesno!) = 2 then Return
   end if

	IF Messagebox("삭제 확인", "사원 : ["+dw_1.getitemstring(1, "empname")+"] 의 ~n"+&
					"인사자료가 모두 삭제됩니다. 계속하시겠습니까?", question!, yesno!) = 2 then Return

	delete from p1_master
	      where companycode = :gs_company and empno = :ls_empno ;
	
	commit using sqlca ;

	IF wf_delete_check(ls_empno) = 0 THEN 
		commit using sqlca ;
		ib_any_typing = false
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
//		cb_insert.TriggerEvent(Clicked!)
	ELSE
		rollback using sqlca ;
		f_rollback()
		ib_any_typing = true
		ib_ischanged  = True
	
		return
	END IF
	dw_5.Event ue_retrieve()
	dw_4.ScrollToRow(1)

ELSEIF rb_4.Checked =True OR rb_5.Checked =True OR &
							rb_6.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN

	il_currow = dw_main.GetRow()
	IF il_currow <=0 Then Return

	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
	dw_main.DeleteRow(il_currow)
	
	IF dw_main.Update() > 0 THEN
		commit;
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	ELSE
		rollback;
		ib_any_typing =True
		ib_ischanged  = True
		
		Return
	END IF
	
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN
	IF dw_main_s1.DataObject = "d_pif1101_14" AND il_select_dw = 1 THEN
		
		il_currow = dw_main_s1.GetRow()
		IF il_currow <=0 Then Return

		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s1.DeleteRow(il_currow)
		
		IF dw_main_s1.Update() > 0 THEN
			commit;
			ib_any_typing =False
			ib_ischanged  = False
			dw_main_s1.SetFocus()
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
		
			Return
		END IF
	
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 1 THEN
		il_currow = dw_main_s1.GetRow()
		IF il_currow <=0 Then Return
			
		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s1.DeleteRow(il_currow)
			
		IF dw_main_s1.Update() > 0 THEN
			commit;
			IF il_currow = 1 OR il_currow <= dw_main_s1.RowCount() THEN
			ELSE
				dw_main_s1.ScrollToRow(il_currow - 1)
				dw_main_s1.SetColumn(1)
				dw_main_s1.SetFocus()
			END IF
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
			Return
		END IF
	ELSE
		il_currow = dw_main_s2.GetRow()
		IF il_currow <=0 Then Return
			
		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s2.DeleteRow(il_currow)
			
		IF dw_main_s2.Update() > 0 THEN
			commit;
			IF il_currow = 1 OR il_currow <= dw_main_s2.RowCount() THEN
			ELSE
				dw_main_s2.ScrollToRow(il_currow - 1)
				dw_main_s2.SetColumn(1)
				dw_main_s2.SetFocus()
			END IF
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
			Return
		END IF
	END IF
ELSE
	il_currow = dw_main.GetRow()
	IF il_currow <=0 Then Return
	
	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
	IF Wf_Delete_Row(il_currow) = -1 THEN RETURN
	
	dw_main.DeleteRow(il_currow)
	
	IF dw_main.Update() > 0 THEN
		IF Wf_Betch_Delete(dw_main.DataObject) = -1 THEN 
			ROLLBACK;
			Return
		END IF
		COMMIT;
		
		/*발령사항 저장 시 인사 마스타 갱신*/
		IF rb_17.Checked = True THEN
			wf_update_master(is_empno)
		END IF
		IF rb_3.Checked = True OR rb_17.Checked = True THEN
		
			dw_1.Retrieve(gs_company,is_empno,'%')	
	
		END IF
		
		IF il_currow = 1 OR il_currow <= dw_main.RowCount() THEN
		ELSE
			dw_main.ScrollToRow(il_currow - 1)
			dw_main.SetColumn(1)
			dw_main.SetFocus()
		END IF
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	ELSE
		rollback;
		ib_any_typing =True
		ib_ischanged  = True
		Return
	END IF
End If
end event

type p_inq from w_inherite_standard`p_inq within w_pif1101
integer x = 3538
integer taborder = 30
end type

event p_inq::clicked;String 	sEmpNo,sEmpName,sColumnName
Int      il_RowCount, row

dw_1.AcceptText()

sempno   = dw_1.GetItemString(1,"empno")
is_empno = sempno
sempname = dw_1.GetItemString(1,"empname") 



//IF IsNull(sempname) OR sempname ="" THEN 
//	sempname =""	
//ELSE
//	sColumnName = "empname"
//	sempno = wf_exiting_data(sColumnName,sempname,"0")
//	IF IsNull(sempno) THEN
//		MessageBox("확 인","등록되지 않은 사원입니다!!")
//		Return
//	END IF
//END IF

IF (sempno ="" OR IsNull(sempno)) AND (sempname ="" OR IsNull(sempname)) THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_1.SetColumn("empname")
	dw_1.SetFocus()
	Return 
END IF



IF dw_1.Retrieve(gs_company,sempno +'%',sempname +'%') < 1 THEN
	dw_1.InsertRow(0)
	dw_main.dataobject = "d_pif1101_2"
	dw_main.SetTransObject(SQLCA)
	dw_main.InsertRow(0)
	w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
	RETURN
END IF


IF rb_12.Checked =True THEN
	il_RowCount = dw_main_s1.Retrieve(gs_company,sempno)
	IF il_RowCount <=0 THEN
		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
		dw_main_s1.InsertRow(0)
		dw_main_s1.setfocus()
	END IF
ELSEIF rb_15.Checked =True THEN
	il_RowCount = dw_main_s2.Retrieve(gs_company,sempno)
	IF il_RowCount <=0 THEN
		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
		dw_main_s2.InsertRow(0)
		dw_main_s2.setfocus()
	END IF
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,sempno,'%')
	p_1.PictureName = gs_picpath + sempno + ".jpg"		
	dw_main.Object.empname.protect = 1	
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
	
	lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	IF dw_main.Retrieve(gs_company,sempno,lYearCnt) <=0 THEN
		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
		dw_main.setfocus()
	END IF
ELSEIF rb_19.Checked = True THEN
	IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
	END IF
ELSE
	IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
		w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!!"
		IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
										rb_22.Checked =True OR rb_7.Checked = True OR rb_14.Checked = True THEN
			dw_main.Reset()
			dw_main.InsertRow(0)
			dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
			dw_main.SetItem(dw_main.GetRow(),"empno",is_empno)
		END IF
		dw_main.setfocus()
	END IF
END IF


is_status = '2'																			/*수정*/
end event

type p_print from w_inherite_standard`p_print within w_pif1101
boolean visible = false
integer x = 3867
integer y = 2772
integer taborder = 230
end type

type p_can from w_inherite_standard`p_can within w_pif1101
integer x = 4233
integer taborder = 160
end type

event p_can::clicked;call super::clicked;
Int il_currow

SetNull(is_empno)

ib_any_typing = False
il_select_dw =9

is_status = '1'								/*등록*/

p_1.PictureName =  " "



dw_1.Reset()
dw_main.Reset()
dw_main_s1.Reset()
dw_main_s2.Reset()
	
IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
   if rb_3.Checked = True then
		is_new = 'Y'
	else
		is_new = 'N'
	end if
	dw_main.InsertRow(0)
	dw_main.SetItem(1,"companycode",gs_company)
	dw_main.SetFocus()
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN

	IF dw_main_s1.dataObject = "d_pif1101_14" THEN
		if il_select_dw = 1 then 
			dw_main_s1.InsertRow(0)
			dw_main_s1.SetItem(1,"companycode",gs_company)	
			dw_main_s1.SetFocus()
		end if
	END IF
END IF
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()



IF rb_19.Checked = True THEN
	cb_insert.Enabled = False
	cb_update.Enabled = False
	cb_delete.Enabled = False
ELSE
	cb_insert.Enabled = True
	cb_update.Enabled = True
	cb_delete.Enabled = True	
END IF
	

end event

type p_exit from w_inherite_standard`p_exit within w_pif1101
integer x = 4407
integer taborder = 190
end type

type p_ins from w_inherite_standard`p_ins within w_pif1101
integer x = 3712
integer taborder = 70
end type

event p_ins::clicked;Int il_currow,il_insrow
double totpay
dw_1.AcceptText()
is_empno = dw_1.GetItemString(1,"empno")

IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
   if rb_3.Checked = True then
		is_new = 'Y'
	else
		is_new = 'N'
	end if														
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF

	
		
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.Setcolumn("empno")
	dw_1.SetFocus()

	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
	dw_main.SetItem(dw_main.GetRow(),"empno",is_empno)
	dw_main.VScrollBar = False
	
	
	
	SetNull(is_empno)
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN

	IF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 9 THEN
		MessageBox("확 인","작업을 선택하지 않았습니다!!")
		w_mdi_frame.sle_msg.text ="작업영역을 클릭하므로써 작업을 선택합니다!!"
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 1 THEN
		il_currow = dw_main_s1.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s1.dataObject,il_currow) <> 1 THEN RETURN
		END IF
			
	
		
		il_insrow = dw_main_s1.InsertRow(0)
		dw_main_s1.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s1.SetItem(il_insrow,"empno",is_empno)
		dw_main_s1.ScrollToRow(il_insrow)
		dw_main_s1.VScrollBar = True
		
		
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 0 THEN
		il_currow = dw_main_s2.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s2.dataObject,il_currow) <> 1 THEN RETURN
		END IF
		
		
	
		il_insrow = dw_main_s2.InsertRow(0)
		dw_main_s2.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s2.SetItem(il_insrow,"empno",is_empno)
		dw_main_s2.ScrollToRow(il_insrow)
		dw_main_s2.VScrollBar = True
			
	
	ELSEIF dw_main_s1.dataObject = "d_pif1101_14" AND il_select_dw = 1 THEN
//		MessageBox("확 인","작업을 선택하지 않았습니다!!")
//		w_mdi_frame.sle_msg.text ="작업영역을 클릭하므로써 작업을 선택합니다!!"
		
		il_currow = dw_main_s1.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s1.dataObject,il_currow) <> 1 THEN Return
		END IF
		
		
		
		il_insrow = dw_main_s1.InsertRow(0)
		dw_main_s1.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s1.SetItem(il_insrow,"empno",is_empno)
		IF rb_15.Checked = True AND dw_main_s1.DataObject ="d_pif1101_14" THEN
			dw_main_s1.SetItem(il_insrow,"seq",il_insrow)
			dw_main_s1.SetColumn(2)
		ELSE
			dw_main_s1.SetColumn(1)
		END IF
	
		dw_main_s1.ScrollToRow(il_insrow)
		dw_main_s1.VScrollBar = True
		
		
		
		
	ELSE
		if il_select_dw = 1 then return
		
		il_currow = dw_main_s2.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s2.dataObject,il_currow) <> 1 THEN Return
		END IF
		
	
		
		il_insrow = dw_main_s2.InsertRow(0)
		dw_main_s2.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s2.SetItem(il_insrow,"empno",is_empno)
		IF rb_15.Checked = True AND dw_main_s2.DataObject ="d_pif1101_20" THEN
			dw_main_s2.SetItem(il_insrow,"seq",il_insrow)
			dw_main_s2.SetColumn(2)
		ELSE
			dw_main_s2.SetColumn(1)
		END IF
	
		dw_main_s2.ScrollToRow(il_insrow)
		dw_main_s2.VScrollBar = True
		
		
	END IF
ELSEIF rb_17.Checked = True THEN
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF
	

	il_insrow = dw_main.InsertRow(0)
	dw_main.SetItem(il_insrow,"companycode",gs_company)
	dw_main.SetItem(il_insrow,"empno",is_empno)
	
	String sDept,sDeptName,sGrade,sLevel,sSalary,sJkCode,sJikMu,sPrtdept, ls_calcdate, ls_paygubn, ls_kmgubn, ls_kunmugubn
	string sprodept,sPrtdeptname, sjik, sSaupcd,ls_sitetag
	long ll_basepay, li_calcseq
	
	SELECT "P1_MASTER"."DEPTCODE",   	"P1_MASTER"."GRADECODE",   "P1_MASTER"."LEVELCODE",
			 "P1_MASTER"."SALARY",   		"P1_MASTER"."JOBKINDCODE", "P1_MASTER"."JIKMUGUBN",
			 "P0_DEPT_A"."DEPTNAME2",     "P1_MASTER"."ADDDEPTCODE", "P0_DEPT_B"."DEPTNAME2",
			 "P1_MASTER"."BASEPAY",       "P1_MASTER"."PROJECTCODE", "P1_MASTER"."JIKJONGGUBN",
			 "P0_DEPT_A"."SAUPCD"
	   INTO :sDept,   						:sGrade,   						:sLevel,   
	        :sSalary,   						:sJkCode,   					:sJikMu,   
           :sDeptName,						:sPrtdept,						:sPrtDeptName,
			  :ll_basepay,                :sprodept,                 :sjik,
			  :sSaupcd
   	FROM "P1_MASTER",   "P0_DEPT" "P0_DEPT_A", "P0_DEPT" "P0_DEPT_B"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT_A"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT_A"."DEPTCODE" ) and 
				( "P1_MASTER"."COMPANYCODE" = "P0_DEPT_B"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."ADDDEPTCODE" = "P0_DEPT_B"."DEPTCODE" ) and 
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :is_EmpNo ) )   ;
				
	dw_main.SetItem(il_insrow,"deptcode",   sDept)
	dw_main.SetItem(il_insrow,"p0_dept_deptname2",sDeptName)
	dw_main.SetItem(il_insrow,"gradecode",  sGrade)
	dw_main.SetItem(il_insrow,"levelcode",  sLevel)
	dw_main.SetItem(il_insrow,"salary",     sSalary)
	dw_main.SetItem(il_insrow,"saupcd",     sSaupcd)
	
		SELECT   "P3_BASEPAY"."TOTBASEPAY"
			INTO  :totpay
			FROM "P3_BASEPAY"  
			WHERE ( "P3_BASEPAY"."COMPANYCODE" = :gs_company ) AND  
					( "P3_BASEPAY"."LEVELCODE" = :sLevel ) AND  
					( "P3_BASEPAY"."SALARY" = :sSalary)   ;
		dw_main.SetItem(il_insrow,"yearpay",totpay)
	dw_main.SetItem(il_insrow,"basepay",ll_basepay)
	dw_main.SetItem(il_insrow,"jobkindcode",sJkCode)
	dw_main.SetItem(il_insrow,"jikmugubn",  sJikMU)
	dw_main.SetItem(il_insrow,"prtdept",    sPrtdept)
	dw_main.SetItem(il_insrow,"prtdeptname",sPrtdeptName)
	
	dw_main.SetItem(il_insrow,"olddeptcode",sDept)
	dw_main.SetItem(il_insrow,"oldgradecode",sGrade)
	dw_main.SetItem(il_insrow,"oldlevelcode",sLevel)
	dw_main.SetItem(il_insrow,"oldsalary",sSalary)
	dw_main.SetItem(il_insrow,"oldjobkindcode",sJkCode)
	dw_main.SetItem(il_insrow,"oldjikmugubn",sJikMU)
	dw_main.SetItem(il_insrow,"oldprtdept",  sPrtdept)
	dw_main.SetItem(il_insrow,"projectcode",  sprodept)
	dw_main.SetItem(il_insrow,"jikjonggubn",  sjik)
	dw_main.SetItem(il_insrow,"oldjikjonggubn",  sjik)
	
	SELECT MAX("REALORDDATEFROM"), MAX("P1_ORDERS"."SEQ")
	  INTO :ls_calcdate, :li_calcseq
	  FROM "P1_ORDERS"
	 WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :is_EmpNo ;
			
	IF ls_calcdate = '' OR IsNull(ls_calcdate) THEN
		ls_calcdate = ''
	END IF
	
	IF String(li_calcseq) = '' OR IsNull(li_calcseq) THEN
		li_calcseq = 0
	END IF
			
	/*급여적용일 기준 최근 발령사항의 직위,직급,호봉,부서 구하기*/
	SELECT "P1_ORDERS"."PAYGUBN",                "P1_ORDERS"."SITETAG",
			 "P1_ORDERS"."KMGUBN",                  "P1_ORDERS"."KUNMUGUBN"
	  INTO :ls_paygubn,   :ls_sitetag,
			 :ls_kmgubn,  :ls_kunmugubn
	  FROM "P1_ORDERS"
	 WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND
			 ( "P1_ORDERS"."EMPNO" = :is_EmpNo ) AND
			 ( "P1_ORDERS"."REALORDDATEFROM" = :ls_calcdate ) AND
			 ("P1_ORDERS"."SEQ" = :li_calcseq) ;

  IF ls_paygubn = '' OR IsNull(ls_paygubn) THEN
	  ls_paygubn = '1'
  END IF
  
  IF ls_kmgubn = '' OR IsNull(ls_kmgubn) THEN
	  ls_kmgubn = '1'
  END IF
  
  IF ls_kunmugubn = '' OR IsNull(ls_kunmugubn) THEN
	  ls_kunmugubn = '10'
  END IF
   IF ls_sitetag = '' OR IsNull(ls_sitetag) THEN
	  ls_sitetag = '1'
  END IF
	
  
	dw_main.SetItem(il_insrow,"paygubn",  ls_paygubn)
	dw_main.SetItem(il_insrow,"kmgubn",  ls_kmgubn)
	dw_main.SetItem(il_insrow,"kunmugubn",  ls_kunmugubn)
	dw_main.SetItem(il_insrow,"sitetag",  ls_sitetag)
	
	dw_main.ScrollToRow(il_insrow)
	dw_main.SetColumn("orderdate")
	dw_main.Setfocus()
	
	dw_main.VScrollBar = True
	dw_main.HScrollBar = True	
	
	
ELSE
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF
	

	il_insrow = dw_main.InsertRow(0)
	dw_main.SetItem(il_insrow,"companycode",gs_company)
	dw_main.SetItem(il_insrow,"empno",is_empno)
	dw_main.ScrollToRow(il_insrow)
	dw_main.VScrollBar = True
	dw_main.HScrollBar = True
	
	IF rb_8.Checked = True OR rb_9.Checked =True OR rb_10.Checked =True OR rb_16.Checked = True OR rb_19.Checked = True THEN
		dw_main.SetItem(il_insrow,"seq",il_insrow)
		dw_main.SetColumn(2)
	ELSE
		dw_main.SetColumn(1)
	END IF
	dw_main.Setfocus()
	
END IF


end event

type p_search from w_inherite_standard`p_search within w_pif1101
boolean visible = false
integer x = 3694
integer y = 2772
integer taborder = 210
end type

type p_addrow from w_inherite_standard`p_addrow within w_pif1101
boolean visible = false
integer x = 4055
integer y = 2764
integer taborder = 80
end type

type p_delrow from w_inherite_standard`p_delrow within w_pif1101
boolean visible = false
integer x = 4229
integer y = 2764
integer taborder = 100
end type

type dw_insert from w_inherite_standard`dw_insert within w_pif1101
boolean visible = false
integer x = 165
integer y = 2612
integer taborder = 40
end type

type st_window from w_inherite_standard`st_window within w_pif1101
boolean visible = false
integer taborder = 170
end type

type cb_exit from w_inherite_standard`cb_exit within w_pif1101
boolean visible = false
integer x = 3255
integer y = 2624
integer taborder = 200
end type

type cb_update from w_inherite_standard`cb_update within w_pif1101
boolean visible = false
integer x = 2153
integer y = 2624
integer taborder = 130
end type

event cb_update::clicked;Int il_currow
String snull

setpointer(hourglass!)

SetNull(snull)

IF rb_12.Checked = True OR rb_15.Checked =True THEN
	IF dw_main_s1.Accepttext() = -1 THEN 	RETURN
	
	IF ib_ischanged = False THEN
		IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	END IF
	
	IF dw_main_s1.RowCount() > 0 AND rb_12.Checked = True THEN
		IF wf_required_check(dw_main_s1.DataObject,dw_main_s1.GetRow()) = -1 THEN RETURN
		
		IF dw_main_s1.Update() > 0 THEN			
			ib_any_typing = False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
		ELSE
			ROLLBACK USING sqlca;
			ib_any_typing = True
			ib_ischanged  = True
			Return
		END IF
	ELSEIF rb_15.Checked = True AND dw_main_s1.DataObject ='d_pif1101_14' THEN
		IF dw_main_s1.GetItemString(1,"passportno") <> "" AND &
												Not IsNull(dw_main_s1.GetItemString(1,"passportno")) THEN
			IF dw_main_s1.Update() > 0 THEN			
				ib_any_typing =False
				ib_ischanged  = False
				w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
			ELSE
				ROLLBACK USING sqlca;
				ib_any_typing = True
				ib_ischanged  = True
				Return
			END IF
		END IF
	ELSE
		IF dw_main_s1.Update() > 0 THEN			
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
		ELSE
			ROLLBACK USING sqlca;
			ib_any_typing = True
			ib_ischanged  = True
			Return
		END IF
	END IF
	dw_main_s1.SetFocus()

	IF dw_main_s2.Accepttext() = -1 THEN 	RETURN

	IF dw_main_s2.RowCount() > 0 THEN
		IF wf_required_check(dw_main_s2.DataObject,dw_main_s2.GetRow()) = -1 THEN RETURN
	END IF
	IF dw_main_s2.Update() > 0 THEN			
		COMMIT USING sqlca;
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	ELSE
		ROLLBACK USING sqlca;
		ib_any_typing = True
		ib_ischanged  = True
		Return
	END IF
	dw_main_s2.SetFocus()
ELSE
	IF dw_main.Accepttext() = -1 THEN 	RETURN

	IF dw_main.RowCount() > 0 THEN
		IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
	END IF

	IF ib_ischanged = False THEN
		IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	END IF
	
	IF dw_main.Update() > 0 THEN			
		COMMIT USING sqlca;
		ib_any_typing =False
		ib_ischanged  = False
		
		/*발령사항 저장 시 인사 마스타 갱신*/
		IF rb_17.Checked = True THEN
			wf_update_master(is_empno)
		END IF
		IF rb_3.Checked = True AND is_status = '1' THEN		/*신입사원 등록시 근무일 생성*/
			cb_kunmuil.TriggerEvent(Clicked!)
		END IF
			
		IF rb_3.Checked = True OR rb_17.Checked = True THEN
		
			dw_1.Retrieve(gs_company,is_empno,'%')	

		END IF
		/*휴직사항 저장 시 인사 마스타 갱신*/
		IF rb_20.Checked = True THEN
			wf_update_master1(is_empno)
		END IF
		
		w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	ELSE
		ROLLBACK USING sqlca;
		ib_any_typing = True
		ib_ischanged  = True
		Return
	END IF
	
	dw_main.Setfocus()
END IF

setpointer(arrow!)
end event

type cb_insert from w_inherite_standard`cb_insert within w_pif1101
boolean visible = false
integer x = 512
integer y = 2624
integer taborder = 110
end type

event cb_insert::clicked;Int il_currow,il_insrow
double totpay
dw_1.AcceptText()
is_empno = dw_1.GetItemString(1,"empno")

IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF

	
		
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.Setcolumn("empno")
	dw_1.SetFocus()

	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
	dw_main.SetItem(dw_main.GetRow(),"empno",is_empno)
	dw_main.VScrollBar = False
	
	
	
	SetNull(is_empno)
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN

	IF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 9 THEN
		MessageBox("확 인","작업을 선택하지 않았습니다!!")
		w_mdi_frame.sle_msg.text ="작업영역을 클릭하므로써 작업을 선택합니다!!"
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 1 THEN
		il_currow = dw_main_s1.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s1.dataObject,il_currow) <> 1 THEN RETURN
		END IF
			
	
		
		il_insrow = dw_main_s1.InsertRow(0)
		dw_main_s1.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s1.SetItem(il_insrow,"empno",is_empno)
		dw_main_s1.ScrollToRow(il_insrow)
		dw_main_s1.VScrollBar = True
		
		
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 0 THEN
		il_currow = dw_main_s2.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s2.dataObject,il_currow) <> 1 THEN RETURN
		END IF
		
		
	
		il_insrow = dw_main_s2.InsertRow(0)
		dw_main_s2.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s2.SetItem(il_insrow,"empno",is_empno)
		dw_main_s2.ScrollToRow(il_insrow)
		dw_main_s2.VScrollBar = True
			
	
	ELSEIF dw_main_s1.dataObject = "d_pif1101_14" AND il_select_dw = 1 THEN
//		MessageBox("확 인","작업을 선택하지 않았습니다!!")
//		w_mdi_frame.sle_msg.text ="작업영역을 클릭하므로써 작업을 선택합니다!!"
		
		il_currow = dw_main_s1.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s1.dataObject,il_currow) <> 1 THEN Return
		END IF
		
		
		
		il_insrow = dw_main_s1.InsertRow(0)
		dw_main_s1.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s1.SetItem(il_insrow,"empno",is_empno)
		IF rb_15.Checked = True AND dw_main_s1.DataObject ="d_pif1101_14" THEN
			dw_main_s1.SetItem(il_insrow,"seq",il_insrow)
			dw_main_s1.SetColumn(2)
		ELSE
			dw_main_s1.SetColumn(1)
		END IF
	
		dw_main_s1.ScrollToRow(il_insrow)
		dw_main_s1.VScrollBar = True
		
		
		
		
	ELSE
		if il_select_dw = 1 then return
		
		il_currow = dw_main_s2.GetRow()
		IF il_currow > 0 THEN
			IF wf_required_check(dw_main_s2.dataObject,il_currow) <> 1 THEN Return
		END IF
		
	
		
		il_insrow = dw_main_s2.InsertRow(0)
		dw_main_s2.SetItem(il_insrow,"companycode",gs_company)
		dw_main_s2.SetItem(il_insrow,"empno",is_empno)
		IF rb_15.Checked = True AND dw_main_s2.DataObject ="d_pif1101_20" THEN
			dw_main_s2.SetItem(il_insrow,"seq",il_insrow)
			dw_main_s2.SetColumn(2)
		ELSE
			dw_main_s2.SetColumn(1)
		END IF
	
		dw_main_s2.ScrollToRow(il_insrow)
		dw_main_s2.VScrollBar = True
		
		
	END IF
ELSEIF rb_17.Checked = True THEN
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF
	

	il_insrow = dw_main.InsertRow(0)
	dw_main.SetItem(il_insrow,"companycode",gs_company)
	dw_main.SetItem(il_insrow,"empno",is_empno)
	
	String sDept,sDeptName,sGrade,sLevel,sSalary,sJkCode,sJikMu,sPrtdept,sPrtdeptname
	
	SELECT "P1_MASTER"."DEPTCODE",   	"P1_MASTER"."GRADECODE",   "P1_MASTER"."LEVELCODE",
			 "P1_MASTER"."SALARY",   		"P1_MASTER"."JOBKINDCODE", "P1_MASTER"."JIKMUGUBN",
			 "P0_DEPT_A"."DEPTNAME2",     "P1_MASTER"."ADDDEPTCODE", "P0_DEPT_B"."DEPTNAME2"  
	   INTO :sDept,   						:sGrade,   						:sLevel,   
	        :sSalary,   						:sJkCode,   					:sJikMu,   
           :sDeptName,						:sPrtdept,						:sPrtDeptName  
   	FROM "P1_MASTER",   "P0_DEPT" "P0_DEPT_A", "P0_DEPT" "P0_DEPT_B"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT_A"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT_A"."DEPTCODE" ) and 
				( "P1_MASTER"."COMPANYCODE" = "P0_DEPT_B"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."ADDDEPTCODE" = "P0_DEPT_B"."DEPTCODE" ) and 
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :is_EmpNo ) )   ;
				
	dw_main.SetItem(il_insrow,"deptcode",   sDept)
	dw_main.SetItem(il_insrow,"p0_dept_deptname2",sDeptName)
	dw_main.SetItem(il_insrow,"gradecode",  sGrade)
	dw_main.SetItem(il_insrow,"levelcode",  sLevel)
	dw_main.SetItem(il_insrow,"salary",     sSalary)
	
		SELECT   "P3_BASEPAY"."TOTBASEPAY"
			INTO  :totpay
			FROM "P3_BASEPAY"  
			WHERE ( "P3_BASEPAY"."COMPANYCODE" = :gs_company ) AND  
					( "P3_BASEPAY"."LEVELCODE" = :sLevel ) AND  
					( "P3_BASEPAY"."SALARY" = :sSalary)   ;
		dw_main.SetItem(il_insrow,"yearpay",totpay)
	
	dw_main.SetItem(il_insrow,"jobkindcode",sJkCode)
	dw_main.SetItem(il_insrow,"jikmugubn",  sJikMU)
	dw_main.SetItem(il_insrow,"prtdept",    sPrtdept)
	dw_main.SetItem(il_insrow,"prtdeptname",sPrtdeptName)
	
	dw_main.SetItem(il_insrow,"olddeptcode",sDept)
	dw_main.SetItem(il_insrow,"oldgradecode",sGrade)
	dw_main.SetItem(il_insrow,"oldlevelcode",sLevel)
	dw_main.SetItem(il_insrow,"oldsalary",sSalary)
	dw_main.SetItem(il_insrow,"oldjobkindcode",sJkCode)
	dw_main.SetItem(il_insrow,"oldjikmugubn",sJikMU)
	dw_main.SetItem(il_insrow,"oldprtdept",  sPrtdept)
	
	dw_main.ScrollToRow(il_insrow)
	dw_main.SetColumn("orderdate")
	dw_main.Setfocus()
	
	dw_main.VScrollBar = True
	dw_main.HScrollBar = True	
	
	
ELSE
	il_currow = dw_main.GetRow()
	
	IF il_currow > 0 THEN
		IF wf_required_check(dw_main.dataObject,il_currow) <> 1 THEN RETURN
	END IF
	

	il_insrow = dw_main.InsertRow(0)
	dw_main.SetItem(il_insrow,"companycode",gs_company)
	dw_main.SetItem(il_insrow,"empno",is_empno)
	dw_main.ScrollToRow(il_insrow)
	dw_main.VScrollBar = True
	dw_main.HScrollBar = True
	
	IF rb_8.Checked = True OR rb_9.Checked =True OR rb_10.Checked =True OR rb_16.Checked = True OR rb_19.Checked = True THEN
		dw_main.SetItem(il_insrow,"seq",il_insrow)
		dw_main.SetColumn(2)
	ELSE
		dw_main.SetColumn(1)
	END IF
	dw_main.Setfocus()
	
END IF


end event

type cb_delete from w_inherite_standard`cb_delete within w_pif1101
boolean visible = false
integer x = 2519
integer y = 2624
integer taborder = 150
end type

event cb_delete::clicked;call super::clicked;Int il_currow ,count
String ls_empno

IF rb_3.Checked = True THEN
	dw_1.accepttext()
	
	ls_empno = dw_1.getitemstring(1, "empno")
	// 급여기본자료 확인
	SELECT count(*)  
   	INTO :count  
      FROM "P3_PERSONAL"  
      WHERE ( "P3_PERSONAL"."COMPANYCODE" = :gs_company ) AND ( "P3_PERSONAL"."EMPNO" = :ls_empno )   ;

   if sqlca.sqlcode >= 0 and count >= 1 then
		if messagebox("확인","급여기본자료가 존재합니다. 계속하시겠습니까?", question!, yesno!) = 2 then Return
   end if

	IF Messagebox("삭제 확인", "사원 : ["+dw_1.getitemstring(1, "empname")+"] 의 ~n"+&
					"인사자료가 모두 삭제됩니다. 계속하시겠습니까?", question!, yesno!) = 2 then Return

	
	
	delete from p1_master
	      where companycode = :gs_company and empno = :ls_empno ;
	
	commit using sqlca ;

	IF wf_delete_check(ls_empno) = 0 THEN 
		commit using sqlca ;
		ib_any_typing = false
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		cb_insert.TriggerEvent(Clicked!)
	ELSE
		rollback using sqlca ;
		f_rollback()
		ib_any_typing = true
		ib_ischanged  = True
	
		return
	END IF
	
ELSEIF rb_4.Checked =True OR rb_5.Checked =True OR &
							rb_6.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN

	il_currow = dw_main.GetRow()
	IF il_currow <=0 Then Return

	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
	dw_main.DeleteRow(il_currow)
	
	IF dw_main.Update() > 0 THEN
		commit;
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	ELSE
		rollback;
		ib_any_typing =True
		ib_ischanged  = True
		
		Return
	END IF
	
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN
	IF dw_main_s1.DataObject = "d_pif1101_14" AND il_select_dw = 1 THEN
		
		il_currow = dw_main_s1.GetRow()
		IF il_currow <=0 Then Return

		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s1.DeleteRow(il_currow)
		
		IF dw_main_s1.Update() > 0 THEN
			commit;
			ib_any_typing =False
			ib_ischanged  = False
			dw_main_s1.SetFocus()
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
		
			Return
		END IF
	
	ELSEIF dw_main_s1.DataObject = "d_pif1101_11" AND il_select_dw = 1 THEN
		il_currow = dw_main_s1.GetRow()
		IF il_currow <=0 Then Return
			
		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s1.DeleteRow(il_currow)
			
		IF dw_main_s1.Update() > 0 THEN
			commit;
			IF il_currow = 1 OR il_currow <= dw_main_s1.RowCount() THEN
			ELSE
				dw_main_s1.ScrollToRow(il_currow - 1)
				dw_main_s1.SetColumn(1)
				dw_main_s1.SetFocus()
			END IF
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
			Return
		END IF
	ELSE
		il_currow = dw_main_s2.GetRow()
		IF il_currow <=0 Then Return
			
		IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
			
		dw_main_s2.DeleteRow(il_currow)
			
		IF dw_main_s2.Update() > 0 THEN
			commit;
			IF il_currow = 1 OR il_currow <= dw_main_s2.RowCount() THEN
			ELSE
				dw_main_s2.ScrollToRow(il_currow - 1)
				dw_main_s2.SetColumn(1)
				dw_main_s2.SetFocus()
			END IF
			ib_any_typing =False
			ib_ischanged  = False
			w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		ELSE
			rollback;
			ib_any_typing =True
			ib_ischanged  = True
			Return
		END IF
	END IF
ELSE
	il_currow = dw_main.GetRow()
	IF il_currow <=0 Then Return
	
	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
	IF Wf_Delete_Row(il_currow) = -1 THEN RETURN
	
	dw_main.DeleteRow(il_currow)
	
	IF dw_main.Update() > 0 THEN
		IF Wf_Betch_Delete(dw_main.DataObject) = -1 THEN 
			ROLLBACK;
			Return
		END IF
		COMMIT;
		
		/*발령사항 저장 시 인사 마스타 갱신*/
		IF rb_17.Checked = True THEN
			wf_update_master(is_empno)
		END IF
		IF rb_3.Checked = True OR rb_17.Checked = True THEN
		
			dw_1.Retrieve(gs_company,is_empno,'%')	
	
		END IF
		
		IF il_currow = 1 OR il_currow <= dw_main.RowCount() THEN
		ELSE
			dw_main.ScrollToRow(il_currow - 1)
			dw_main.SetColumn(1)
			dw_main.SetFocus()
		END IF
		ib_any_typing =False
		ib_ischanged  = False
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	ELSE
		rollback;
		ib_any_typing =True
		ib_ischanged  = True
		Return
	END IF
End If
end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pif1101
string tag = ""
boolean visible = false
integer x = 146
integer y = 2624
integer taborder = 90
end type

event cb_retrieve::clicked;call super::clicked;String 	sEmpNo,sEmpName,sColumnName
Int      il_RowCount

dw_1.AcceptText()

sempno   = dw_1.GetItemString(1,"empno")
sempname = dw_1.GetItemString(1,"empname") 

//IF IsNull(sempno) OR sempno ="" THEN 
//	sempno =""
//ELSE
//	sColumnName = "empno"
//	IF IsNull(wf_exiting_data(sColumnName,sempno,"0")) THEN
//		MessageBox("확 인","등록되지 않은 사원입니다!!")
//		Return
//	END IF
//END IF

//IF IsNull(sempname) OR sempname ="" THEN 
//	sempname =""	
//ELSE
//	sColumnName = "empname"
//	sempno = wf_exiting_data(sColumnName,sempname,"0")
//	IF IsNull(sempno) THEN
//		MessageBox("확 인","등록되지 않은 사원입니다!!")
//		Return
//	END IF
//END IF

IF (sempno ="" OR IsNull(sempno)) AND (sempname ="" OR IsNull(sempname)) THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_1.SetColumn("empname")
	dw_1.SetFocus()
	Return 
END IF



dw_1.Retrieve(gs_company,sempno +'%',sempname +'%')

IF rb_12.Checked =True THEN
	il_RowCount = dw_main_s1.Retrieve(gs_company,sempno)
	IF il_RowCount <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_main_s1.InsertRow(0)
		dw_main_s1.setfocus()
	END IF
ELSEIF rb_15.Checked =True THEN
	il_RowCount = dw_main_s2.Retrieve(gs_company,sempno)
	IF il_RowCount <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_main_s2.InsertRow(0)
		dw_main_s2.setfocus()
	END IF
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,sempno,'%')
	p_1.PictureName = gs_picpath + sempno + ".jpg"		
	dw_main.Object.empname.protect = 1	
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
	
	lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	IF dw_main.Retrieve(gs_company,sempno,lYearCnt) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_main.setfocus()
	END IF
ELSEIF rb_19.Checked = True THEN
	IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
	END IF
ELSE
	IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
			dw_main.Reset()
			dw_main.InsertRow(0)
			dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
		END IF
		dw_main.setfocus()
	END IF
END IF


is_status = '2'																			/*수정*/
end event

type st_1 from w_inherite_standard`st_1 within w_pif1101
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pif1101
boolean visible = false
integer x = 2885
integer y = 2624
integer taborder = 180
end type

event cb_cancel::clicked;call super::clicked;
Int il_currow

SetNull(is_empno)

ib_any_typing = False
il_select_dw =9

is_status = '1'								/*등록*/

p_1.PictureName =  " "



dw_1.Reset()
dw_main.Reset()
dw_main_s1.Reset()
dw_main_s2.Reset()
	
IF rb_3.Checked = True OR rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
	dw_main.InsertRow(0)
	dw_main.SetItem(1,"companycode",gs_company)
	dw_main.SetFocus()
ELSEIF rb_12.Checked = True OR rb_15.Checked =True THEN

	IF dw_main_s1.dataObject = "d_pif1101_14" THEN
		if il_select_dw = 1 then 
			dw_main_s1.InsertRow(0)
			dw_main_s1.SetItem(1,"companycode",gs_company)	
			dw_main_s1.SetFocus()
		end if
	END IF
END IF
dw_1.InsertRow(0)
dw_1.SetColumn("empno")
dw_1.SetFocus()



IF rb_19.Checked = True THEN
	cb_insert.Enabled = False
	cb_update.Enabled = False
	cb_delete.Enabled = False
ELSE
	cb_insert.Enabled = True
	cb_update.Enabled = True
	cb_delete.Enabled = True	
END IF
	

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pif1101
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pif1101
boolean visible = false
integer x = 379
end type

type gb_2 from w_inherite_standard`gb_2 within w_pif1101
boolean visible = false
integer x = 2112
integer y = 2584
integer height = 168
end type

type gb_1 from w_inherite_standard`gb_1 within w_pif1101
boolean visible = false
integer x = 110
integer y = 2584
integer height = 168
end type

type gb_10 from w_inherite_standard`gb_10 within w_pif1101
boolean visible = false
end type

type p_1 from picture within w_pif1101
integer x = 1230
integer y = 184
integer width = 512
integer height = 552
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer fh, ret, cnt
string il_filename
blob Emp_pic
string txtname 
string defext = "jpg"
string Filter = "jpg files (*.*), *.jpg"

string sempno

if dw_1.Accepttext() = -1 then return
sempno = dw_1.getitemstring(1,'empno')

if messagebox("확인","사진을 저장하시겠습니까?",Question!,YesNo!) = 2 then return
//SELECTBLOB image
//INTO :Emp_pic 
//FROM p1_master
//WHERE companycode = :gs_company and
//      empno = :sempno ;
//
//int i_num
//integer li_FileNum
//
//li_FileNum = FileOpen("C:\temp.jpg", StreamMode!, Write!, Shared!, append!)
//
//filewrite(li_filenum, emp_pic)
//fileclose(li_filenum)
//
//p_1.SetPicture(Emp_pic)
//
	
	ret = GetFileOpenName("Open Text", txtname, il_filename, defext, filter)
	
IF ret = 1 THEN	


string	filename, filepath, temp_date
long		filelength, loops
Int		li_ItemTotal, li_ItemCount, fnum, i


	filepath   = txtname
	filename   = il_filename
	filelength = FileLength(filepath)

// 스트림모드로 파일을 연다.
fnum = FileOpen(filepath,StreamMode!, Read!, LockRead!)
IF fnum = -1 THEN
  MessageBox('알림', '파일열기 에러입니다.')
  return
END IF


long bytes_read, lgth
blob b, imagedata,imagedata2

imagedata = Blob(Space(0))


// 파일이 32765 byte보다 클시에 몇번을 나누어 읽을 것인지 결정한다.
IF filelength > 32765 THEN
	IF Mod(filelength, 32765) = 0 THEN
	   loops = filelength/32765
	ELSE
	   loops = (filelength/32765) + 2
	END IF
ELSE
   loops = 1
END IF

// loop 수만큼 파일을 읽는다.
FOR i = 1 to loops
    bytes_read = FileRead(fnum, b)
    imagedata = imagedata + b
NEXT


//파일을 닫는다.
FileClose(fnum)

//테이블에 저장한다.
select count(*) into :cnt
from p1_master_pic
where empno = :sempno;
if IsNull(cnt) then cnt = 0

if cnt = 0 then		
   insert into p1_master_pic
	      (empno)
   values(:sempno);
	commit;
end if
	
	

UPDATEBLOB p1_master_pic
		 SET image    = :imagedata
	  WHERE empno = :sempno	;

IF sqlca.sqlCode = 0 and sqlca.sqldbcode = 0 THEN
	commit;
	p_1.SetPicture(imagedata)
ELSE
	MessageBox("DB ERROR", String(Sqlca.SqlCode) + '/' + String(Sqlca.SqlDbCode) + '/' +&
					Sqlca.SqlErrText)
	rollback;
	return -1
END IF

END IF
end event

event rbuttondown;string sempno,ls_filename

if messagebox("확인","사진을 삭제하시겠습니까?",Question!,YesNo!) = 2 then return

if dw_1.rowcount() > 0 then
  if dw_1.Accepttext() = -1 then return
  sempno = dw_1.GetitemString(1,'empno')

  
ls_filename = gs_picpath + sempno + ".jpg"
filedelete(ls_filename)  

update p1_master_pic
SET image    = null
WHERE empno = :sempno	;
		
	if sqlca.sqlcode = 0 then
      commit;
   	p_1.PictureName =  " "
	else
		rollback;
	end if
		
		
end if
end event

type pb_1 from picturebutton within w_pif1101
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2089
integer y = 76
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\Erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;string scode,sname,sMin_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If


IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF
p_1.PictureName = gs_picpath + is_empno + ".jpg"	


IF rb_15.Checked =True OR rb_12.Checked = True THEN
	dw_main_s1.Retrieve(gs_company,is_empno)
	dw_main_s2.Retrieve(gs_company,is_empno)
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,is_empno,'%')
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :is_empno )   ;
	IF sEnterDate ="" OR IsNull(sEnterDate) THEN 
		lYearCnt = 0
	ELSE
		lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	END IF
	dw_main.Retrieve(gs_company,is_empno,lYearCnt) 
ELSE
	dw_main.Retrieve(gs_company,is_empno)
END IF

IF rb_4.Checked = True OR rb_5.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN
	IF dw_main.RowCount() = 0 THEN
		dw_main.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
ELSEIF rb_15.Checked = True THEN
	IF dw_main_s1.RowCount() = 0 THEN
		dw_main_s1.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
END IF



is_status = '2'																			/*수정*/
end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_2 from picturebutton within w_pif1101
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2213
integer y = 76
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\Erpman\image\prior.gif"
end type

event clicked;string scode,sname,sMax_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sname	;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If


IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF
p_1.PictureName = gs_picpath + is_empno + ".jpg"


IF rb_15.Checked =True OR rb_12.Checked = True THEN
	dw_main_s1.Retrieve(gs_company,is_empno)
	dw_main_s2.Retrieve(gs_company,is_empno)
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,is_empno,'%')
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :is_empno )   ;
	IF sEnterDate ="" OR IsNull(sEnterDate) THEN 
		lYearCnt = 0
	ELSE
		lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	END IF
	dw_main.Retrieve(gs_company,is_empno,lYearCnt) 
ELSE
	dw_main.Retrieve(gs_company,is_empno)
END IF

IF rb_4.Checked = True OR rb_5.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN
	IF dw_main.RowCount() = 0 THEN
		dw_main.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
ELSEIF rb_15.Checked = True THEN
	IF dw_main_s1.RowCount() = 0 THEN
		dw_main_s1.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
END IF



is_status = '2'																			/*수정*/



end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_3 from picturebutton within w_pif1101
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2327
integer y = 76
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\Erpman\image\next.gif"
end type

event clicked;string scode,sname,sMin_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sname	;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If


IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF
p_1.PictureName = gs_picpath + is_empno + ".jpg"


IF rb_15.Checked =True OR rb_12.Checked = True THEN
	dw_main_s1.Retrieve(gs_company,is_empno)
	dw_main_s2.Retrieve(gs_company,is_empno)
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,is_empno,'%')
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :is_empno )   ;
	IF sEnterDate ="" OR IsNull(sEnterDate) THEN 
		lYearCnt = 0
	ELSE
		lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	END IF
	dw_main.Retrieve(gs_company,is_empno,lYearCnt) 
ELSE
	dw_main.Retrieve(gs_company,is_empno)
END IF

IF rb_4.Checked = True OR rb_5.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN
	IF dw_main.RowCount() = 0 THEN
		dw_main.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
ELSEIF rb_15.Checked = True THEN
	IF dw_main_s1.RowCount() = 0 THEN
		dw_main_s1.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
END IF



is_status = '2'																			/*수정*/



end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_4 from picturebutton within w_pif1101
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 2441
integer y = 76
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\Erpman\image\last.gif"
end type

event clicked;string scode,sname,sMax_name

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_1.getitemstring(1, "empno")

	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_1.GetItemString(1,"empname")
	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If


IF dw_1.Retrieve(gs_company,is_empno,'%') > 0 then
	pb_1.Enabled = False
	pb_2.Enabled = False
	pb_3.Enabled = False
	pb_4.Enabled = False
END IF
p_1.PictureName = gs_picpath + is_empno + ".jpg"


IF rb_15.Checked =True OR rb_12.Checked = True THEN
	dw_main_s1.Retrieve(gs_company,is_empno)
	dw_main_s2.Retrieve(gs_company,is_empno)
ELSEIF rb_3.Checked = True THEN
	dw_main.Retrieve(gs_company,is_empno,'%')
ELSEIF rb_9.Checked = True THEN
	Double lYearCnt
	String sEnterDate
	
	SELECT "P1_MASTER"."ENTERDATE"  
   	INTO :sEnterDate  
    	FROM "P1_MASTER"  
   	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P1_MASTER"."EMPNO" = :is_empno )   ;
	IF sEnterDate ="" OR IsNull(sEnterDate) THEN 
		lYearCnt = 0
	ELSE
		lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
	END IF
	dw_main.Retrieve(gs_company,is_empno,lYearCnt) 
ELSE
	dw_main.Retrieve(gs_company,is_empno)
END IF

IF rb_4.Checked = True OR rb_5.Checked = True OR rb_7.Checked = True OR rb_14.Checked = True THEN
	IF dw_main.RowCount() = 0 THEN
		dw_main.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
ELSEIF rb_15.Checked = True THEN
	IF dw_main_s1.RowCount() = 0 THEN
		dw_main_s1.InsertRow(0)
		dw_main.SetItem(1,"companycode",gs_company)
		dw_main.SetItem(1,"empno",is_empno)
	END IF
END IF



is_status = '2'																			/*수정*/


end event

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type gb_4 from groupbox within w_pif1101
boolean visible = false
integer x = 1234
integer y = 8
integer width = 695
integer height = 168
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type rb_1 from radiobutton within w_pif1101
boolean visible = false
integer x = 1285
integer y = 68
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_pif1101
boolean visible = false
integer x = 1591
integer y = 68
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명순"
end type

type gb_5 from groupbox within w_pif1101
boolean visible = false
integer x = 2043
integer y = 12
integer width = 530
integer height = 164
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type rb_3 from radiobutton within w_pif1101
integer x = 1266
integer y = 788
integer width = 265
integer height = 76
integer taborder = 220
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "기본"
boolean checked = true
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_2" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_2")
	IF il_rtnvalue = -1 THEN 
		Return 
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = false
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_4 from radiobutton within w_pif1101
integer x = 2267
integer y = 788
integer width = 265
integer height = 76
integer taborder = 250
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "주소"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_3" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_3")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = false
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_5 from radiobutton within w_pif1101
integer x = 3936
integer y = 788
integer width = 265
integer height = 76
integer taborder = 260
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "재산"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_4" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_4")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = false
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_6 from radiobutton within w_pif1101
integer x = 2267
integer y = 856
integer width = 265
integer height = 76
integer taborder = 400
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "신체"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_5" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_5")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_7 from radiobutton within w_pif1101
integer x = 2601
integer y = 788
integer width = 265
integer height = 76
integer taborder = 280
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "병역"
end type

event clicked;call super::clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_6" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_6")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = false
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true



dw_main.SetRedraw(True)


end event

type rb_8 from radiobutton within w_pif1101
integer x = 2935
integer y = 788
integer width = 265
integer height = 76
integer taborder = 270
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "학력"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_7" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_7")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = False
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_10 from radiobutton within w_pif1101
integer x = 1266
integer y = 856
integer width = 265
integer height = 76
integer taborder = 330
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "가족"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_9" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_9")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_11 from radiobutton within w_pif1101
integer x = 2935
integer y = 856
integer width = 265
integer height = 76
integer taborder = 300
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "면허"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_10" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_10")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_12 from radiobutton within w_pif1101
integer x = 3269
integer y = 856
integer width = 265
integer height = 76
integer taborder = 320
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "외국어"
end type

event clicked;long current_row,il_rtnvalue

IF dw_main_s1.dataobject <> "d_pif1101_11" OR dw_main_s1.visible = false THEN
	il_rtnvalue =wf_dataobject_change("d_pif1101_11", "d_pif1101_19")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
		Return 
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
//	st_3.Move(This.x - 8, This.y - 9)
END IF

dw_main_s1.Title = "외국어"
dw_main_s2.Title = "외국어 자격"

il_select_dw = 1

dw_main_s1.visible = true
dw_main_s2.visible = true
dw_main.visible = false

dw_main_s1.vscrollbar = True
dw_main_s1.hscrollbar = False
	
dw_main_s2.vscrollbar = True
dw_main_s2.hscrollbar = False

dw_main_s1.TabOrder = 21
dw_main_s2.TabOrder = 22

dw_main_s1.setfocus()
dw_main_s1.SetRedraw(True)
dw_main_s2.SetRedraw(True)

end event

type rb_13 from radiobutton within w_pif1101
integer x = 3602
integer y = 788
integer width = 265
integer height = 76
integer taborder = 310
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "상벌"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_12" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_12")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_14 from radiobutton within w_pif1101
integer x = 1600
integer y = 856
integer width = 265
integer height = 76
integer taborder = 340
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "보증"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_13" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_13")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = false
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_15 from radiobutton within w_pif1101
integer x = 3602
integer y = 856
integer width = 265
integer height = 76
integer taborder = 380
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "여권"
end type

event clicked;long current_row,il_rtnvalue

IF dw_main_s1.dataobject <> "d_pif1101_14" OR dw_main_s1.visible = false THEN
	il_rtnvalue = wf_dataobject_change("d_pif1101_14", "d_pif1101_20") 
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
		Return
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
END IF

dw_main_s1.Title = "여권사항"
dw_main_s2.Title = "비자내역"

il_select_dw = 1

dw_main_s1.visible = true
dw_main_s2.visible = true
dw_main.visible = false

dw_main_s1.vscrollbar = False
dw_main_s1.hscrollbar = False

dw_main_s2.vscrollbar = True
dw_main_s2.hscrollbar = False

dw_main_s1.TabOrder = 21
dw_main_s2.TabOrder = 22

dw_main_s1.setfocus()
dw_main_s1.SetRedraw(True)
dw_main_s2.SetRedraw(True)

end event

type rb_16 from radiobutton within w_pif1101
integer x = 4270
integer y = 788
integer width = 265
integer height = 76
integer taborder = 350
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "지인"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_15" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_15")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_17 from radiobutton within w_pif1101
integer x = 1600
integer y = 788
integer width = 265
integer height = 76
integer taborder = 240
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "발령"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_16" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_16")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_19 from radiobutton within w_pif1101
boolean visible = false
integer x = 82
integer y = 2412
integer width = 251
integer height = 76
integer taborder = 390
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "교육"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_18" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_18")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type dw_1 from u_key_enter within w_pif1101
event ue_key pbm_dwnkey
integer x = 1801
integer y = 208
integer width = 2711
integer height = 532
integer taborder = 50
string dataobject = "d_pif1101_1"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String 	sEmpNo,sEmpName,sEnterDate,snull, kempno, sTemp, tempno
Int      il_RowCount
Double   lYearCnt
			
SetNull(snull)

dw_1.Accepttext()

w_mdi_frame.sle_msg.text = ''

sempno = dw_1.getitemstring(1,"empno")
is_empno = sempno
w_mdi_frame.sle_msg.text = '자료 조회 중'
SetPointer(HourGlass!)

If dw_1.GetColumnName() = "empname"  Then
	sempname = this.GetText()
	sempno  = wf_exiting_saup_data(dw_1.GetColumnName(),sempname,"1",is_saup)	/*입력된 이름의 사원번호*/
	kempno = wf_exiting_saup_data('empno',is_empno,"1",is_saup) 					/*이전 조회된 사원번호*/
 if IsNull(is_empno) then 
	  tempno = '000000'
 else
	  tempno = kempno
 end if

	/*기조회된 사번이 없고, 입력된 이름에 대한 사번이 존재할 경우 retrieve(조회)한다. */
	IF (IsNull(kempno) And Not IsNull(sempno) and is_new = 'N') OR (tempno <> sempno) THEN	
		dw_1.Retrieve(gs_company,sempno,'%')
		p_1.PictureName = gs_picpath + sempno + ".jpg"		
		
		dw_main.Modify("empname.protect = 0")
		IF rb_15.Checked =True THEN
			dw_main_s1.Retrieve(gs_company,sempno)
			IF dw_main_s1.DataObject ="d_pif1101_14" AND dw_main_s1.RowCount() <=0 THEN
				dw_main_s1.Reset()
				dw_main_s1.InsertRow(0)
				dw_main_s1.setitem(1,'companycode',gs_company)
				dw_main_s1.SetItem(dw_main_s1.GetRow(),"empno",sempno)
			END IF
			dw_main_s2.Retrieve(gs_company,sempno)
			
		ELSEIF rb_12.Checked =True THEN
			
			dw_main_s1.Retrieve(gs_company,sempno)
			dw_main_s2.Retrieve(gs_company,sempno)
			
		ELSEIF rb_3.Checked = True THEN
			IF dw_main.Retrieve(gs_company,sempno,'%') <=0 THEN
				is_status = '1'														/*등록*/
			ELSE
				is_status = '2'
			END IF
			dw_main.Modify("empname.protect = 1")
			dw_main.SetColumn("empnamechinese")
			dw_main.SetFocus()
		ELSEIF rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
			IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
				dw_main.Reset()
				dw_main.InsertRow(0)
				dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
				dw_main.SetItem(dw_main.GetRow(),"empno",sempno)
				dw_main.SetColumn(1)
				dw_main.SetFocus()
			END IF
		ELSEIF rb_9.Checked = True THEN
			SELECT "P1_MASTER"."ENTERDATE"  
				INTO :sEnterDate  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
			
			lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
			dw_main.Retrieve(gs_company,sempno,lYearCnt)
	
		ELSE
			dw_main.Retrieve(gs_company,sempno)
		END IF
	ELSE
		IF rb_3.Checked = True THEN
			dw_main.SetItem(dw_main.GetRow(),"empname",sempname)
			dw_main.Modify("empname.protect = 1")
			dw_main.SetColumn("empnamechinese")
			dw_main.setitem(1,'companycode',gs_company)
			rb_3.Checked =True
			rb_3.TriggerEvent(Clicked!)
		ELSE
			dw_main.Modify("empname.protect = 0")
			MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
			dw_1.SetItem(1,"empno",snull)
			dw_1.SetItem(1,"empname",snull)
			Return 1
		END IF
	END IF

ELSEIF dw_1.GetColumnName() = "empno" Then
	sempno = this.GetText()
	sTemp = wf_exiting_saup_data(dw_1.GetColumnName(),sempno,"1",is_saup)
	IF IsNull(sTemp) THEN
		IF rb_3.Checked = True THEN
			dw_main.reset()
			dw_1.reset()
			dw_main.insertrow(0)
			dw_1.insertrow(0)
			dw_1.setitem(1,'empno',sempno)
			dw_main.SetItem(dw_main.GetRow(),"empno",sempno)
			p_1.PictureName = gs_picpath + sempno + ".jpg"	
			dw_main.Modify("empname.protect = 1")
			dw_main.SetColumn("empnamechinese")
			dw_main.setitem(1,'companycode',gs_company)
		ELSE
			dw_main.Modify("empname.protect = 0")
			MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
			dw_1.SetItem(1,"empno",snull)
			dw_1.SetItem(1,"empname",snull)
			Return 1
		END IF
	ELSEIF sTemp = '' THEN
		dw_1.SetItem(1,"empno",snull)
		dw_1.SetItem(1,"empname",snull)
		dw_main.Reset()
		dw_main.InsertRow(0)
		Return 1
	ELSE
		dw_1.Retrieve(gs_company,sempno,'%')
		p_1.PictureName = gs_picpath + sempno + ".jpg"
		

		dw_main.Modify("empname.protect = 0")
		IF rb_15.Checked =True THEN
			dw_main_s1.Retrieve(gs_company,sempno)
			IF dw_main_s1.DataObject ="d_pif1101_14" AND dw_main_s1.RowCount() <=0 THEN
				dw_main_s1.Reset()
				dw_main_s1.InsertRow(0)
				dw_main_s1.setitem(1,'companycode',gs_company)
				dw_main_s1.SetItem(dw_main_s1.GetRow(),"empno",sempno)
			END IF
			dw_main_s2.Retrieve(gs_company,sempno)
			
		ELSEIF rb_12.Checked =True THEN
			
			dw_main_s1.Retrieve(gs_company,sempno)
			dw_main_s2.Retrieve(gs_company,sempno)
		ELSEIF rb_3.Checked = True THEN
			IF dw_main.Retrieve(gs_company,sempno,'%') <=0 then
				is_status = '1'													/*등록*/	
			ELSE
				is_status = '2'
			END IF
			
			dw_main.Modify("empname.protect = 1")
			dw_main.SetColumn("empnamechinese")
		ELSEIF rb_9.Checked = True THEN
			SELECT "P1_MASTER"."ENTERDATE"  
				INTO :sEnterDate  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
			
			lYearCnt = f_calc_year_cnt(sEnterDate,gs_today,'Y') + (Truncate(f_calc_year_cnt(sEnterDate,gs_today,'M') / 100,2))
			dw_main.Retrieve(gs_company,sempno,lYearCnt)
		ELSEIF rb_4.Checked =True OR rb_5.Checked =True OR &
														rb_7.Checked = True OR rb_14.Checked = True THEN
			IF dw_main.Retrieve(gs_company,sempno) <=0 THEN
				dw_main.Reset()
				dw_main.InsertRow(0)
				dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
				dw_main.SetItem(dw_main.GetRow(),"empno",sempno)
				dw_main.SetColumn(1)
				dw_main.SetFocus()
			END IF
		ELSE
			dw_main.Retrieve(gs_company,sempno)
		END IF
	END IF
END IF
IF rb_3.Checked = True THEN
	sempname = dw_1.getitemstring(1,"empname")
   dw_main.setitem(dw_main.GetRow(),"empname",sempname)
END IF


int rownum	 

rownum = dw_4.find("empno = '" + is_empno + "'", 1, dw_4.rowcount())

if rownum > 0 then
	dw_4.Selectrow(0, false)
	dw_4.setredraw(false)	

	dw_4.Scrolltorow(rownum)
	dw_4.SelectRow(rownum, true)
//	dw_4.event rowfocuschanged(rownum)		
	dw_4.setredraw(true)		
end if

IF rb_19.Checked = True THEN
	cb_insert.Enabled = False
	cb_update.Enabled = False
	cb_delete.Enabled = False
ELSE
	cb_insert.Enabled = True
	cb_update.Enabled = True
	cb_delete.Enabled = True	
END IF



w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

is_empno =sempno
ib_any_typing = False

il_select_dw = 9
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)

	Gs_Gubun = is_saup
	IF IsNull(Gs_Gubun) OR Gs_Gubun = '' THEN Gs_Gubun = '%'

IF this.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.SetItem(this.GetRow(),"empname",Gs_Codename)
	this.TriggerEvent(ItemChanged!)

ELSEIF this.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;
Return 1
end event

event editchanged;il_select_dw =9
ib_any_typing = True
end event

event retrieveend;call super::retrieveend;if rowcount > 0 then
	is_new = 'N'
else
	is_new = 'Y'
end if
end event

type rb_18 from radiobutton within w_pif1101
integer x = 2601
integer y = 856
integer width = 265
integer height = 76
integer taborder = 370
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "동호회"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_17" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_17")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_9 from radiobutton within w_pif1101
integer x = 3269
integer y = 788
integer width = 265
integer height = 76
integer taborder = 290
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "경력"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_8" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_8")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_20 from radiobutton within w_pif1101
integer x = 1934
integer y = 856
integer width = 265
integer height = 76
integer taborder = 410
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "휴직"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_21" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_21")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_21 from radiobutton within w_pif1101
boolean visible = false
integer x = 82
integer y = 2320
integer width = 439
integer height = 76
integer taborder = 360
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "개인별 지급품"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_22" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_22")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = false
	
//	st_3.Move(This.x - 9, This.y - 8)
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type cb_kunmuil from commandbutton within w_pif1101
boolean visible = false
integer x = 1774
integer y = 2536
integer width = 357
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "근무일 생성"
end type

event clicked;/******************************************************************************************/
/*** 근무일구분 일괄 생성																						*/
/*** 1. 처리년도 : 1년을 단위로 생성한다.																	*/
/*** 2. 근무구분 : 관리지,생산직,미성년자를 구분하여 생성한다.										*/
/*** 3. 작업대상 = '개인' 이면 '개인'만 처리.															*/
/*** 4. 주간 근무일 구분 : '월 ~ 토'까지의 근무일구분을 선택한다.									*/
/*** # 미성년자 : 주민번호 기준 처리일자까지 만 18세 미만											*/
/******************************************************************************************/

String  sJongKind,sMonDay,sTueDay,sWedDay,sThuDay,sFriDay,sSatDay,sSqlSynTax,sGbn,sFrom,sTo
Integer iYear

sFrom = Left(gs_today,6)+'01'														/*처리일자(from)*/
sTo   = Left(gs_today,4)+'1231'													/*처리일자(to)*/

sJongKind = dw_main.GetItemString(1,"jikjonggubn")							/*직종구분*/

iYear = f_calc_18('19'+dw_main.GetItemString(1,"residentno1"),Gs_today,'Y')
IF sJongKind = '1' THEN			             						/*관리직*/
	sGbn = '1'
ELSEIF sJongKind = '2' THEN                  					/*생산직*/
	sGbn = '2'
END IF

SELECT "P4_STKUNMUIL"."STMONDAY",   "P4_STKUNMUIL"."STTUESDAY",   
       "P4_STKUNMUIL"."STWEDNESDAY","P4_STKUNMUIL"."STTHURSDAY",   
       "P4_STKUNMUIL"."STFIRDAY",   "P4_STKUNMUIL"."STSATURDAY"  
	INTO :sMonDay,   						:sTueDay,   
        :sWedDay,   						:sThuDay,   
        :sFriDay,   						:sSatDay  
   FROM "P4_STKUNMUIL"  
   WHERE "P4_STKUNMUIL"."STGUBN" = :sGbn   ;

sSqlSyntax = wf_SqlSyntax(sJongKind)

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ='근무일 생성 중....'

DECLARE start_sp_create_kunmuil procedure for sp_create_kunmuil(:sFrom, :sTo, :sMonDay,&
					:sTueDay,:sWedDay,:sThuDay,:sFriDay,:sSatDay,:sGbn, :gs_company, :sSqlSyntax, :gs_today) ;
execute start_sp_create_kunmuil ;

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ='근무일 자동 생성 완료!!'











end event

type dw_main from u_key_enter within w_pif1101
event ue_key pbm_dwnkey
integer x = 1161
integer y = 1008
integer width = 3415
integer height = 1160
integer taborder = 60
string dataobject = "d_pif1101_2"
boolean hscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;//ib_any_typing =True
end event

event itemchanged;String sres_no1,sres_no2,snull,shobong,slevel,ssql,sBirthDay, sreserve, sdate, tdate
String sordercode, sorderdate, levelupdate,idate, sempno, gbn, s_salary,sdept
Double dBasePay,totpay,dnull,dstandard, samount, damount, ld_medaverage, ld_medamt, ld_medrate
string scode, sname, ls_saupcd
double ld_penaverage, ld_penamt, ld_penrate, ld_jmedrate, ld_jmedAMT

SetNull(snull)
SetNull(dnull)
dw_1.Accepttext()
THIS.ACCEPTTEXT()

sempno = dw_1.Getitemstring(1,'empno')

select jikjonggubn into :gbn
from p1_master 
where companycode =:gs_company and empno = :sempno;

if this.DataObject = "d_pif1101_25" then
	IF this.GetColumnName() = "meddegree" THEN
	slevel = this.GetText()	
	
	IF slevel ="" OR IsNull(slevel) THEN 
		this.SetItem(1,"meddegree",snull)
		this.SetItem(1,"medstandardwage",snull)
		this.SetItem(1,"medamt",snull)
		RETURN
	END IF
	
	SELECT "P3_MEDINSURANCETABLE"."MEDSTANDARDWAGE",   "P3_MEDINSURANCETABLE"."MEDSELFFINE"  
	   INTO :dStandard,   :dAmount  
	   FROM "P3_MEDINSURANCETABLE"  
   	WHERE ( "P3_MEDINSURANCETABLE"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P3_MEDINSURANCETABLE"."MEDDEGREE" = :slevel )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 의료보험 등급이 아닙니다!!")
		this.SetItem(1,"meddegree",snull)
		this.SetItem(1,"medstandardwage",snull)
		this.SetItem(1,"medamt",snull)
		Return 1
	END IF
	this.SetItem(1,"medstandardwage",dStandard)
	this.SetItem(1,"medamt",dAmount)
		
  END IF

IF this.GetColumnName() = "pendegree" THEN
	slevel = this.GetText()
	
	IF slevel ="" OR IsNull(slevel) THEN 
		this.SetItem(1,"pendegree",snull)
		this.SetItem(1,"penstandardwage",snull)
		this.SetItem(1,"penamt",snull)
		RETURN
	END IF
	
	SELECT "P3_PENSIONTABLE"."PENSTANDARDWAGE",   "P3_PENSIONTABLE"."PENSELFFINE"  
	   INTO :dStandard,   :dAmount  
	   FROM "P3_PENSIONTABLE"  
   	WHERE "P3_PENSIONTABLE"."PENDEGREE" = :slevel   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 국민연금 등급이 아닙니다!!")
		this.SetItem(1,"pendegree",snull)
		this.SetItem(1,"penstandardwage",snull)
		this.SetItem(1,"penamt",snull)
		Return 1
	END IF
	this.SetItem(1,"penstandardwage",dStandard)
	this.SetItem(1,"penamt",dAmount)		
 END IF
 IF this.GetColumnName() = "bankcode" THEN

	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN RETURN
	
	SELECT "P0_BANK"."BANKNAME"  
   	INTO :sname  
    	FROM "P0_BANK"  
	   WHERE "P0_BANK"."BANKCODE" = :scode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 은행코드가 아닙니다!!")
		this.SetItem(1,"bankcode",snull)
		this.SetItem(1,"p0_bank_bankname",snull)
		Return 1
	END IF
	this.SetItem(1,"p0_bank_bankname",sname)
		
  END IF
  
 IF this.GetColumnName() = "medstandardwage" THEN
	ld_medaverage = Double(This.Gettext())
	
	select to_number(dataname) into :ld_medrate
	from p0_syscnfg
	where sysgu = 'P' and serial = '19' and lineno = '2';
	if IsNull(ld_medrate) then ld_medrate = 5.08 	
	
	select to_number(dataname) into :ld_jmedrate
	from p0_syscnfg
	where sysgu = 'P' and serial = '19' and lineno = '3';
	if IsNull(ld_medrate) then ld_medrate = 4.05 	
	
	ld_medamt = truncate(ld_medaverage * ld_medrate / 100 / 2 / 10,0) * 10
   this.SetItem(1,"medamt",ld_medamt)
	
	ld_jmedamt = truncate(ld_medamt * ld_jmedrate / 100 / 10,0) * 10
   this.SetItem(1,"jmedamt",ld_jmedamt)
	
  END IF
  
  IF this.GetColumnName() = "penstandardwage" THEN
	ld_penaverage = Double(This.Gettext())
	
	select to_number(dataname) into :ld_penrate
	from p0_syscnfg
	where sysgu = 'P' and serial = '19' and lineno = '1';
	if IsNull(ld_penrate) then ld_penrate = 9 	
	
	ld_penamt = truncate(ld_penaverage * ld_penrate / 100 / 2 / 10,0) * 10
   this.SetItem(1,"penamt",ld_penamt)
	
  END IF
  
  
End if

IF this.DataObject = "d_pif1101_16" THEN
	IF this.GetcolumnName() = 'ordercode' THEN
		sordercode = this.Gettext()
		sorderdate = this.GetItemString(this.Getrow(),'orderdate')
		idate = string(RelativeDate(Date(Left(sorderdate,4)+"/"+Mid(sorderdate,5,2)+"/"+Right(sorderdate,2)), -1),'yyyymmdd')
		this.setitem(this.Getrow() - 1 ,'realorddateto',idate)		
	elseif this.GetcolumnName() = "orderdate" THEN	
      sorderdate = this.Gettext()
		this.Setitem(this.Getrow(), 'realorddatefrom', sorderdate)
	elseif this.GetcolumnName() = "deptcode" THEN	
		sdept = this.Gettext()
		
		this.Setitem(this.Getrow(), 'projectcode', sdept)
		this.Setitem(this.Getrow(), 'prtdept', sdept)	
		
		SELECT saupcd INTO :ls_saupcd
		FROM p0_dept WHERE companycode = :gs_company AND deptcode = :sdept;
		IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN ls_saupcd = '10'
		
		this.Setitem(this.Getrow(), 'saupcd', ls_saupcd)
	end if
END IF

IF this.GetcolumnName() = "levelcode" THEN
	sLevel = this.GetText()
  	this.SetItem(this.Getrow(),"salary",snull)  
	
END IF

IF this.GetcolumnName() = "salary" THEN
	shobong = this.GetText()

	IF IsNull(shobong) OR shobong ="" THEN RETURN

	slevel = this.GetItemString(this.Getrow(),"levelcode")

	IF this.DataObject = "d_pif1101_16" THEN
//		MessageBox('직급,직종구분',slevel+','+gbn);
	  if gbn = '1' then
		SELECT "P3_BASEPAY"."BASEPAY",  "P3_BASEPAY"."TOTBASEPAY"
			INTO :dBasePay ,           :totpay
			FROM "P3_BASEPAY"
			WHERE ( "P3_BASEPAY"."COMPANYCODE" = :gs_company ) AND  
					( "P3_BASEPAY"."LEVELCODE" = :slevel ) AND  
					( "P3_BASEPAY"."JIKJONGGUBN" = :gbn ) AND
					( "P3_BASEPAY"."SALARY" = :shobong ) ;
		else
				SELECT "P3_BASEPAY"."BASEPAY",  "P3_BASEPAY"."TOTBASEPAY"
			INTO :dBasePay ,           :totpay
			FROM "P3_BASEPAY"  
			WHERE ( "P3_BASEPAY"."COMPANYCODE" = :gs_company ) AND  
					( "P3_BASEPAY"."LEVELCODE" = :slevel ) AND  
					( "P3_BASEPAY"."JIKJONGGUBN" = :gbn ) AND
					( "P3_BASEPAY"."SALARY" = :shobong ) ;
		end if
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","등록된 급호가 아닙니다")
			this.SetItem(this.GetRow(),"salary",snull)
//			Return 1
		END IF
		sordercode = this.GetItemString(this.Getrow(),'ordercode')
		sorderdate = this.GetItemString(this.Getrow(),'orderdate')

		this.Setitem(this.GetRow(),"basepay",dBasePay)
		this.SetItem(this.GetRow(),"yearpay",totpay)
		
	END IF
END IF

IF this.GetColumnName() = "residentno1" THEN
	sres_no1 = this.GetText()
	sres_no2 = this.GetItemString(dw_main.GetRow(),"residentno2")
	
	IF sres_no1 = "" OR IsNull(sres_no1) THEN RETURN
	IF sres_no2 = "" OR IsNull(sres_no2) THEN RETURN
	
	sBirthDay = Trim(this.GetItemString(this.GetRow(),"birthday"))
	
	IF f_vendcode_check(sres_no1 + sres_no2) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"residentno1",snull)
			this.SetItem(this.GetRow(),"residentno2",snull)
			this.SetColumn("residentno1")
			Return 1
		END IF
	END IF
//	IF sBirthDay ="" OR IsNull(sBirthDay) THEN
		IF rb_10.Checked = True THEN
			this.SetItem(this.GetRow(),"birthday",Mid(sres_no1,3,4))
		ELSE
			this.SetItem(this.GetRow(),"birthday",'19'+sres_no1)
		END IF
//	END IF
END IF

IF this.GetColumnName() = "residentno2" THEN
	sres_no2 = this.GetText()
	sres_no1 = this.GetItemString(dw_main.GetRow(),"residentno1")
	
	IF sres_no1 = "" OR IsNull(sres_no1) THEN RETURN
	IF sres_no2 = "" OR IsNull(sres_no2) THEN RETURN
	if rb_3.checked = true then
	sBirthDay = Trim(this.GetItemString(this.GetRow(),"birthday"))
   end if
	IF f_vendcode_check(sres_no1 + sres_no2) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"residentno1",snull)
			this.SetItem(this.GetRow(),"residentno2",snull)
			this.SetColumn("residentno1")
			Return 1
		END IF
	END IF
	if rb_3.checked = true then
		IF sBirthDay ="" OR IsNull(sBirthDay) THEN
			IF rb_10.Checked = True THEN
				this.SetItem(this.GetRow(),"birthday",Mid(sres_no1,3,4))
			ELSE
				this.SetItem(this.GetRow(),"birthday",'19'+sres_no1)
			END IF
		END IF
		
		String ls_sexgbn
		IF mod(long(left(sres_no2,1)),2) = 0 THEN  /*주민번호 체크해서 성별 설정*/
			ls_sexgbn = '2'
		ELSE
			ls_sexgbn = '1'
		END IF
		SetItem(GetRow(),'sexgubn',ls_sexgbn)
   end if
END IF

IF this.GetColumnName() = "reservecode" THEN
//	sreserve = this.GetText()
//	if sreserve <> '5' then
//		this.SetTabOrder("specialgbn", 0)
//		this.setitem(1,"specialgbn", snull)
//	else
//		this.SetTabOrder("specialgbn", 70)
//	end if
End if

IF this.GetcolumnName() = "tdate" THEN
	tdate = this.GetText()	
	
	IF this.DataObject = "d_pif1101_21" THEN
		sdate = this.GetItemString(this.Getrow(),"fdate")
		this.SetItem(this.GetRow(),"bigo",string(f_dayterm(sdate,tdate)+1))
	
	END IF
END IF
	
IF data ="" OR IsNull(data) THEN 
	IF this.GetColumnName() = "serviceper" THEN
	ELSE
		RETURN
	END IF
END IF

IF wf_Itemchanged_check(this.GetColumnName(),Trim(data)) = -1 THEN
	Return 1
END IF
ib_any_typing = True

end event

event itemerror;
String snull

SetNull(snull)

Beep(1)

IF this.GetColumnName() = 'insurancegubn' THEN
	this.SetItem(this.GetRow(),"insurancegubn",snull)	
END IF
IF this.GetColumnName() = 'taxgubn' THEN
	this.SetItem(this.GetRow(),"taxgubn",snull)	
END IF
IF this.GetColumnName() = 'respectgubn' THEN
	this.SetItem(this.GetRow(),"respectgubn",snull)		
END IF
IF this.GetColumnName() = 'rubbergubn' THEN
	this.SetItem(this.GetRow(),"rubbergubn",snull)			
END IF

Return 1
end event

event itemfocuschanged;IF dwo.name = "empnamechinese" OR dwo.name = "retirtext" OR dwo.name ="address11" OR dwo.name ="address12" OR &
	dwo.name ="address21" OR dwo.name ="address22" OR dwo.name ="hobby" OR dwo.name ="specialty" OR &
	dwo.name ="recommendername" OR dwo.name ="ancestralhome" OR dwo.name ="recommenderrelation" OR &
   dwo.name ="medicalocation" OR dwo.name ="recommenderjob" OR dwo.name ="recommendertitle" OR &	
	dwo.name ="issuer" OR dwo.name ="rpoffice" OR dwo.name ="dept" OR dwo.name ="grade" OR &
	dwo.name ="rptext" OR dwo.name ="rpname" OR dwo.name ="rpbigo" OR &
	dwo.name ="remark" OR dwo.name ="sponsorname1" OR dwo.name ="sponsorname2" OR dwo.name ="name" OR &
	dwo.name ="companyname" OR dwo.name ="title" OR dwo.name ="circlelevel" OR dwo.name ="duty" OR &
	dwo.name ="office" OR dwo.name ="educdesc" OR dwo.name ="notfinish" OR dwo.name ="familyname" OR dwo.name ="job" OR &
	dwo.name ="text" OR dwo.name ="bigo" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF
end event

event rbuttondown;String sCmpZip, sempno, gbn
double totpay,damount, samount

SetNull(gs_code)
SetNull(gs_codename)

dw_1.Accepttext()

sempno = dw_1.Getitemstring(1,'empno')

select jikjonggubn into :gbn
from p1_master 
where companycode =:gs_company and empno = :sempno;

IF this.GetColumnName() = "deptcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.SetItem(this.GetRow(),"prtdept",gs_code)
	this.SetItem(this.GetRow(),"p0_dept_deptname2",gs_codename)	
	this.SetItem(this.GetRow(),"prtdeptname",gs_codename)	
	
	this.Setitem(this.Getrow(), 'projectcode', gs_code)

	String ls_saupcd
	SELECT saupcd INTO :ls_saupcd
	FROM p0_dept WHERE companycode = :gs_company AND deptcode = :gs_code;
	IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN ls_saupcd = '10'
	
	this.Setitem(this.Getrow(), 'saupcd', ls_saupcd)
END IF

IF this.GetColumnName() ="prtdept" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"prtdept",gs_code)
	this.SetItem(this.GetRow(),"prtdeptname",gs_codename)	
	this.SetItem(this.GetRow(),"projectcode",gs_code)
END IF

IF this.GetColumnName() ="projectcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"projectcode",gs_code)
END IF

IF this.GetColumnName() ="p1_master_projectcode" THEN
	
	Open(w_kcda09a)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"p1_master_projectcode",gs_code)
	this.SetItem(this.GetRow(),"costdept_name",gs_codename)	
END IF

IF this.GetColumnName() ="adddeptcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"adddeptcode",gs_code)
	this.SetItem(this.GetRow(),"prt_dept",gs_codename)	
END IF
IF this.GetColumnName() = "meddegree" THEN

	open(w_medde_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"meddegree",Gs_code)
	SELECT "P3_MEDINSURANCETABLE"."MEDSELFFINE", "P3_MEDINSURANCETABLE"."MEDSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_MEDINSURANCETABLE"
   	WHERE ( "P3_MEDINSURANCETABLE"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P3_MEDINSURANCETABLE"."MEDDEGREE" = :gs_code )   ;
	IF SQLCA.SQLCODE = 0 THEN
	   this.SetItem(this.GetRow(),"meddegree",Gs_code)
		this.SetItem(this.GetRow(),"medamt",damount)
		this.SetItem(this.GetRow(),"medstandardwage",samount)
	end if
END IF

IF this.GetColumnName() = "pendegree" THEN

	open(w_pende_popup)
	damount = 0
	samount = 0
	IF IsNull(Gs_code) THEN RETURN
	
	SELECT "P3_PENSIONTABLE"."PENSELFFINE", "P3_PENSIONTABLE"."PENSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_PENSIONTABLE"  
   	WHERE "P3_PENSIONTABLE"."PENDEGREE" = :gs_code   ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"pendegree",Gs_code)
		this.SetItem(this.GetRow(),"penstandardwage",samount)
		this.SetItem(this.GetRow(),"penamt",damount)
	end if

END IF

IF this.GetColumnName() = "bankcode" THEN
	
	open(w_bank_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SELECT "P0_BANK"."BANKNAME"  
   	INTO :gs_codename  
    	FROM "P0_BANK"  
	   WHERE "P0_BANK"."BANKCODE" = :gs_code   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"p0_bank_bankname",gs_codename)
	   this.SetItem(this.GetRow(),"bankcode",Gs_code)
	end if
END IF
IF this.GetColumnName() = "salary" THEN
	gs_code = this.GetItemString(this.GetRow(),"levelcode")
	gs_codename = gbn
	
	IF gs_code ="" OR IsNull(gs_code) THEN 
		messagebox("확인","직급을 입력하십시요!")
		RETURN
	End if
	Open(w_level_salary_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.Getrow(),"salary",Gs_codename)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="p1_master_projectcode" THEN
	
	Open(w_kcda09a)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"p1_master_projectcode",gs_code)
	this.SetItem(this.GetRow(),"costdept_name",gs_codename)	
END IF

IF this.GetColumnName() ="zipcode1" THEN
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN

	this.SetItem(this.GetRow(),"zipcode1", Gs_code)
	this.SetItem(this.GetRow(),"address11",Gs_codename)

	IF rb_4.Checked = True THEN
		sCmpZip = Trim(this.GetItemSTring(this.GetRow(),"zipcode2"))
		
		IF sCmpZip ="" OR IsNull(sCmpZip) THEN
			this.SetItem(this.GetRow(),"zipcode2",Gs_code)
			this.SetItem(this.GetRow(),"address21",Gs_codename)
		END IF
	END IF
	
	this.SetColumn("address12")
	this.SetFocus()
END IF

IF this.GetColumnName() ="zipcode2" THEN
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN
	
	this.SetItem(this.GetRow(),"zipcode2",Gs_code)
	this.SetItem(this.GetRow(),"address21",Gs_codename)
	this.SetColumn("address22")
	this.SetFocus()
END IF

IF this.GetColumnName() ="schoolcode" THEN
	
	Open(w_school_popup)
	
	IF IsNull(Gs_Code) THEN RETURN
	
	this.SetItem(this.GetRow(),"schoolcode",Gs_code)
	this.SetItem(this.GetRow(),"schoolname",Gs_codename)
	this.SetFocus()
END IF

ib_any_typing = True
end event

event clicked;il_select_dw =9
end event

event retrieverow;
IF row > 0 AND this.DataObject ='d_pif1101_16' THEN
	this.SetItem(row,"flag",'1')
END IF
end event

event retrieveend;pb_1.Enabled = True
pb_2.Enabled = True
pb_3.Enabled = True
pb_4.Enabled = True
end event

event buttonclicked;call super::buttonclicked;string ls_gbn

if dwo.name = 'b_med' then
	
ls_gbn = dw_main.GetitemString(1, "gbn")

if ls_gbn = '1' then   /*건강보험*/
	dw_up.Dataobject = "d_pif1101_med"
	dw_up.SettransObject(sqlca)
	delete from p3_medamt;
	commit;
else                    /*국민연금*/
	dw_up.Dataobject = "d_pif1101_pen"
	dw_up.SettransObject(sqlca)
	delete from p3_penamt; 
	commit;
end if 

String ls_path , ls_filename , ls_save_file , ls_oledata , ls_conv_name,stext,txtname
Integer li_rtn , li_FileNum , Result , li_rv , a, cnt, ii_fileID
Long ll_import , ll_xls , ll_file_len

w_mdi_frame.sle_msg.text = ""

li_rv = GetFileOpenName('Select File to open' , ls_path, ls_filename, 'DOC', &
'Excel Files (*.xls), *.xls, ' + 'All Files (*.*), *.*')


if li_rv <> 1 then
messagebox('알림', '선택한 파일이 없습니다....!!!')
Return -1
end if 
//--------------------------------------------------------------------- 

if ls_gbn = '1' then
  if Messagebox("확인","건강보험 보수월액과 공제금액을 업로드하시겠습니까?", Question!, YesNo!) = 2 then return
else
  if Messagebox("확인","국민연금 보수월액과 공제금액을 업로드하시겠습니까?", Question!, YesNo!) = 2 then return
end if


SetPointer(HourGlass!) 
w_mdi_frame.sle_msg.text = "생성 중.................!!"

stext = ls_path	

delete from p3_medamt;

OleObject oleExcel 

oleExcel = Create OleObject 
li_rtn = oleExcel.connecttonewobject("excel.application") 

if li_rtn = 0 then
oleExcel.WorkBooks.Open(ls_path) 
else
Messagebox("!", "실패") 
Destroy oleExcel 
Return -1
end if
oleExcel.Application.Visible = False 

ll_xls = pos(ls_path, 'xls')
ls_save_file = stext + '.txt'
oleExcel.application.workbooks(1).SaveAs(ls_save_file, -4158) 

oleExcel.application.workbooks(1).Saved = True 
oleExcel.Application.Quit 
oleExcel.DisConnectObject() 
Destroy oleExcel

ll_import = dw_up.ImportFile(ls_save_file)

if dw_up.update() > 0 then
	commit;
else
   rollback;
end if


if ll_import < 1 Then
   messagebox('알림', '파일처리에 실패하였습니다.(' + ls_save_file + ')')
end if

FileDelete(ls_save_file)

//ii_fileID = FileOpen(ls_path, LineMode!)
//FileClose(ii_fileID)
//
//FileClose(1)

if ls_gbn = '1' then	
	update p3_personal a
	set medstandardwage  = (select med.medstandardwage from p3_medamt med, p1_master b
									where trim(med.residentno) = b.residentno1||b.residentno2 and b.empno = a.empno),
		 medamt = 	 (select med.medamt from p3_medamt med, p1_master b
									where trim(med.residentno) = b.residentno1||b.residentno2 and b.empno = a.empno)
	WHERE A.EMPNO in (SELECT EMPNO 
					FROM p3_medamt, P1_MASTER
					WHERE P1_MASTER.RESIDENTNO1||P1_MASTER.RESIDENTNO2 = trim(P3_MEDAMT.RESIDENTNO));	
else
	update p3_personal a
	set penstandardwage  = (select pen.penstandardwage from p3_penamt pen, p1_master b
									where trim(pen.residentno) = b.residentno1||b.residentno2 and b.empno = a.empno),
		 penamt = 	 (select pen.penamt from p3_penamt pen, p1_master b
									where trim(pen.residentno) = b.residentno1||b.residentno2 and b.empno = a.empno)
	WHERE A.EMPNO in (SELECT EMPNO 
					FROM p3_penamt, P1_MASTER
					WHERE P1_MASTER.RESIDENTNO1||P1_MASTER.RESIDENTNO2 = trim(p3_penamt.RESIDENTNO));	

end if

IF SQLCA.SQLCODE <> 0 THEN
	Rollback ;
	messagebox("생성에러","자료생성 실패!!")
	return
ELSE
	Commit ;
	messagebox("생성에러","자료생성 성공!!")
END IF	

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = "자료 생성 완료!!"	

return 1
	
end if
end event

type dw_main_s1 from u_key_enter within w_pif1101
integer x = 1161
integer y = 1008
integer width = 3415
integer height = 544
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pif1101_11"
boolean border = false
end type

event itemchanged;
String snull

IF dwo.name = "languagecode" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF IsNull(f_code_select('외국어',data)) THEN
		MessageBox("확 인","등록되지 않은 외국어코드입니다.!!")
		this.SetItem(this.GetRow(),"languagecode",snull)
		Return 1
	END IF
END IF

IF dwo.name = "validitystart" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN
		MessageBox("확 인","유효시작일자를 확인하십시요!!")
		this.SetItem(this.GetRow(),"validitystart",snull)
		Return -1
	END IF
END IF

IF dwo.name = "validityend" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN
		MessageBox("확 인","유효종료일자를 확인하십시요!!")
		this.SetItem(this.GetRow(),"validityend",snull)
		Return -1
	END IF
END IF

IF dwo.name = "testgubn" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF IsNull(f_code_select('평가',data)) THEN
		MessageBox("확 인","등록되지 않은 평가방법입니다.!!")
		this.SetItem(this.GetRow(),"testgubn",snull)
		Return 1
	END IF
END IF

			
end event

event itemerror;call super::itemerror;Return 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="remark" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	


end event

event clicked;call super::clicked;il_select_dw =1

IF this.DataObject ="d_pif1101_11" THEN
	w_mdi_frame.sle_msg.text ="[외국어] 작업 중......"
ELSE
	w_mdi_frame.sle_msg.text = "[여권사항] 작업 중......"
END IF
end event

type dw_main_s2 from u_key_enter within w_pif1101
integer x = 1161
integer y = 1548
integer width = 3415
integer height = 620
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pif1101_20"
boolean border = false
end type

event itemchanged;call super::itemchanged;String snull

IF dwo.name = "flicensecode" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF IsNull(f_code_select('자격',data)) THEN
		MessageBox("확 인","등록되지 않은 자격코드입니다.!!")
		this.SetItem(this.GetRow(),"flicensecode",snull)
		Return 1
	END IF
END IF

IF dwo.name = "issuedate" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN
		MessageBox("확 인","발행일자를 확인하십시요!!")
		this.SetItem(this.GetRow(),"issuedate",snull)
		Return -1
	END IF
END IF

IF dwo.name = "enddate" THEN
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN
		MessageBox("확 인","만료일자를 확인하십시요!!")
		this.SetItem(this.GetRow(),"enddate",snull)
		Return -1
	END IF
END IF

			
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemerror;call super::itemerror;Return 1
end event

event itemfocuschanged;IF dwo.name ="remark" OR dwo.name ="country" OR dwo.name = 'flicenseoffice' THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	


end event

event clicked;call super::clicked;il_select_dw =0

IF this.DataObject ="d_pif1101_19" THEN
	w_mdi_frame.sle_msg.text ="[외국어자격] 작업 중......"
ELSE
	w_mdi_frame.sle_msg.text = "[비자내역] 작업 중......"
END IF
end event

type rb_22 from radiobutton within w_pif1101
integer x = 1934
integer y = 788
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "급여"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_25" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_25")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True
	
	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type rb_23 from radiobutton within w_pif1101
integer x = 3936
integer y = 856
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "정산"
end type

event clicked;long current_row
Int il_rtnvalue

IF dw_main.dataobject <> "d_pif1101_26" OR dw_main.visible = false THEN
	il_rtnvalue = wf_change_dataobj("d_pif1101_26")
	
	IF il_rtnvalue = -1 THEN
		rb_3.Checked = True
		rb_3.TriggerEvent(Clicked!)
	ELSEIF il_rtnvalue = 2 THEN
		Wf_Set_RadioButton('CURRENT')
	ELSE
		sCurButton = Wf_Set_RadioButton('BEFORE')
	END IF
	
	dw_main.SetRedraw(False)
	dw_main_s1.SetRedraw(False)
	dw_main_s2.SetRedraw(False)
	
	dw_main.vscrollbar = True
	dw_main.hscrollbar = True

	dw_main.setfocus()
End If

dw_main_s1.visible = false
dw_main_s2.visible = false
dw_main.visible = true

dw_main.SetRedraw(True)


end event

type dw_5 from datawindow within w_pif1101
event ue_retrieve ( )
event ue_keydown pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer y = 36
integer width = 1143
integer height = 408
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pif1101_101"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_retrieve();string sdate, sdept, sgrade, sjicjong

if Accepttext() = -1 then return

sdate = trim(getitemstring(1,'sdate'))
sdept = trim(getitemstring(1,'deptcode'))
sgrade = trim(getitemstring(1,'grade'))
is_saup = trim(getitemstring(1,'saup'))
sjicjong = trim(getitemstring(1,'jicjong'))

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'
if IsNull(is_saup) or is_saup = '' then is_saup = '%'
if IsNull(sjicjong) or sjicjong = '' then sjicjong = '%'

if dw_4.retrieve(gs_company, sdept, sgrade, sdate, is_saup, sjicjong) < 1 then
	messagebox("조회","조회자료가 없습니다!")
	w_mdi_frame.sle_msg.text = "조회된 자료가 없습니다!"
	dw_1.SetRedraw(false)
	dw_main.SetRedraw(false)
	dw_1.reset()
	dw_main.reset()
	dw_1.InsertRow(0)
	dw_main.InsertRow(0)
	dw_1.SetRedraw(true)
	dw_main.SetRedraw(true)
	setcolumn('sdate')
	setfocus()
	return
end if
if dw_4.GetSelectedRow(0) < 1 then
   dw_4.event rowfocuschanged(1)
end if
end event

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string sdate, sDeptCode, sDeptName, sgrade, snull
setnull(snull)

w_mdi_frame.sle_msg.text = ""

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'sdate' then
	sdate = this.gettext()
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
end if

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"deptname",snull)
		EVENT ue_retrieve()
		Return 1
	END IF
	
	SELECT "P0_DEPT"."DEPTNAME"  
   	INTO :sDeptName
   	FROM "P0_DEPT"
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P0_DEPT"."DEPTCODE" = :sDeptCode );
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"deptname",sDeptName)
	ELSE
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"deptname",snull)
		Return 1
	END IF
END IF
Event ue_retrieve()
end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

IF this.GetColumnName() ="deptcode" THEN
	gs_gubun = is_saupcd
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"deptname",gs_codename)	
END IF

EVENT ue_retrieve()
end event

type dw_4 from u_d_popup_sort within w_pif1101
integer x = 18
integer y = 464
integer width = 1097
integer height = 1740
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pif1101_100"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow <= 0 then
	dw_4.SelectRow(0,False)
	b_flag =True
ELSE
	SelectRow(0, FALSE)
	SelectRow(CurrentRow,TRUE)	
  
	dw_1.SetItem(1,'empno',This.GetItemString(CurrentRow,'empno'))
	dw_1.SetItem(1,'empname',This.GetItemString(CurrentRow,'empname'))
	dw_1.SetItem(1,'deptname2',This.GetItemString(CurrentRow,'deptname2'))
	dw_1.SetItem(1,'deptcode',This.GetItemString(CurrentRow,'deptcode'))

	p_inq.TriggerEvent(Clicked!)
	p_1.PictureName = gs_picpath + GetItemString(CurrentRow,'empno') + ".jpg"
	wf_get_image(This.GetItemString(CurrentRow,'empno'))
	b_flag = False
END IF
end event

type cbx_1 from checkbox within w_pif1101
integer x = 3845
integer y = 272
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "신규등록"
end type

type dw_up from datawindow within w_pif1101
boolean visible = false
integer x = 137
integer y = 1600
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pif1101_med"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pif1101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1147
integer y = 756
integer width = 3442
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pif1101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1147
integer y = 1004
integer width = 3442
integer height = 1176
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pif1101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 456
integer width = 1120
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 46
end type

