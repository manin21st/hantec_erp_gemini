$PBExportHeader$w_pip1015.srw
$PBExportComments$** 급여 고정/변동금액일괄등록
forward
global type w_pip1015 from w_inherite_multi
end type
type gb_9 from groupbox within w_pip1015
end type
type gb_6 from groupbox within w_pip1015
end type
type gb_8 from groupbox within w_pip1015
end type
type gb_3 from groupbox within w_pip1015
end type
type uo_progress from u_progress_bar within w_pip1015
end type
type rb_1 from radiobutton within w_pip1015
end type
type st_2 from statictext within w_pip1015
end type
type rb_2 from radiobutton within w_pip1015
end type
type st_3 from statictext within w_pip1015
end type
type em_ym from editmask within w_pip1015
end type
type dw_allow from datawindow within w_pip1015
end type
type pb_1 from picturebutton within w_pip1015
end type
type pb_2 from picturebutton within w_pip1015
end type
type dw_total from u_d_select_sort within w_pip1015
end type
type dw_1 from datawindow within w_pip1015
end type
type rb_pstag1 from radiobutton within w_pip1015
end type
type rb_pstag2 from radiobutton within w_pip1015
end type
type dw_personal from u_d_select_sort within w_pip1015
end type
type gb_7 from groupbox within w_pip1015
end type
type rb_5 from radiobutton within w_pip1015
end type
type rb_6 from radiobutton within w_pip1015
end type
type cb_1 from commandbutton within w_pip1015
end type
type p_allcreate from uo_picture within w_pip1015
end type
type p_alldel from uo_picture within w_pip1015
end type
type st_20 from statictext within w_pip1015
end type
type st_4 from statictext within w_pip1015
end type
type dw_saup from datawindow within w_pip1015
end type
type gb_4 from groupbox within w_pip1015
end type
type rr_1 from roundrectangle within w_pip1015
end type
type rr_2 from roundrectangle within w_pip1015
end type
type rr_6 from roundrectangle within w_pip1015
end type
type rr_3 from roundrectangle within w_pip1015
end type
end forward

global type w_pip1015 from w_inherite_multi
string title = "급여고정/변동금액 일괄 생성"
gb_9 gb_9
gb_6 gb_6
gb_8 gb_8
gb_3 gb_3
uo_progress uo_progress
rb_1 rb_1
st_2 st_2
rb_2 rb_2
st_3 st_3
em_ym em_ym
dw_allow dw_allow
pb_1 pb_1
pb_2 pb_2
dw_total dw_total
dw_1 dw_1
rb_pstag1 rb_pstag1
rb_pstag2 rb_pstag2
dw_personal dw_personal
gb_7 gb_7
rb_5 rb_5
rb_6 rb_6
cb_1 cb_1
p_allcreate p_allcreate
p_alldel p_alldel
st_20 st_20
st_4 st_4
dw_saup dw_saup
gb_4 gb_4
rr_1 rr_1
rr_2 rr_2
rr_6 rr_6
rr_3 rr_3
end type
global w_pip1015 w_pip1015

type variables
String                sProcYearMonth, sPayGbn,sPTag,sBTag,sProcGbn
DataWindow    dw_Process
Integer              il_rowcount
string iv_pbtag, iv_pstag
end variables

forward prototypes
public function string wf_sqlsyntax ()
public subroutine wf_insert ()
public function integer wf_reqchk ()
public function integer wf_changedata ()
public function integer wf_fixupdate ()
public function integer wf_allowcodechk ()
end prototypes

public function string wf_sqlsyntax ();
String  sSqlSyntax,sEmpNo,sSpace
//Integer k,lSyntaxLength
//
//sSpace = ' '
//
//IF rb_5.Checked = True THEN
//	sSqlSyntax = ' SELECT "P1_MASTER"."EMPNO","P1_MASTER"."DEPTCODE","P1_MASTER"."ENTERDATE","P1_MASTER"."RETIREDATE","P1_MASTER"."LEVELCODE","P1_MASTER"."SALARY","P1_MASTER"."JIKJONGGUBN" FROM "P1_MASTER" ' 
//ELSEIF rb_6.Checked = True THEN
//	sSqlSyntax = ' SELECT "P1_MASTER"."EMPNO" FROM "P1_MASTER" ' 
//ELSEIF rb_7.Checked = True THEN
//	sSqlSyntax = ' SELECT "P1_MASTER"."EMPNO","P1_MASTER"."ENTERDATE","P1_MASTER"."RETIREDATE","P1_MASTER"."SSFDATE","P1_MASTER"."SSTDATE" FROM "P1_MASTER" '  	
//	
//END IF
//
////sSqlSyntax = sSqlSyntax + ' ("P1_MASTER"."RETIREDATE" = '+ "'"+sSpace +"'"+" ) OR "
////sSqlSyntax = sSqlSyntax + ' (SUBSTR("P1_MASTER"."RETIREDATE",1,6) >= '+ "'"+sprocyearmonth +"'"+" )) AND "
////
//sSqlSyntax = sSqlSyntax + 'WHERE ('
//
//FOR k = 1 TO il_rowcount
//	
//	sEmpNo = dw_Process.GetItemString(k,"empno")
//	
//	sSqlSyntax = sSqlSyntax + ' ("P1_MASTER"."EMPNO" =' + "'"+ sEmpNo +"' )"+' OR'
//	
//NEXT
//
//lSyntaxLength = len(sSqlSyntax)
//sSqlSyntax    = Mid(sSqlSyntax,1,lSyntaxLength - 2)
//
//sSqlSyntax = sSqlSyntax + ")"
//
////sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."COMPANYCODE" = ' + "'" + gs_company +"'"+") "
////sSqlSyntax = sSqlSyntax + ' AND ( SUBSTR("P1_MASTER"."ENTERDATE",1,6) <= ' + "'"+sprocyearmonth +"'"+" )"  
//
//IF rb_7.Checked = True THEN
//	String sJikGbn = '2'
//	
////	sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."JIKJONGGUBN" <> ' + "'"+sJikGbn +"'"+")"
////	+' ORDER BY "P1_MASTER"."RETIREDATE" DSC'  
//END IF
//
Return sSqlSyntax
//
end function

public subroutine wf_insert ();/******************************************************************************************/
/*** 급여 고정자료 생성																							*/
/*** 1. 급여항목 table을 읽어서 처리한다.																	*/
/*** 2. 지급/공제를 구분하여 생성한다.(급여항목 table의 구분에 따라서)							*/
/*** 3. 급여자료를 생성한다.(급여항목 table의 급여적용 = 'Y')										*/
/*** 4. 상여자료를 생성한다.(급여항목 table의 상여적용 = 'Y')										*/
/*** 5. 항목 코드																									*/
/***    5-1.  기본급(01)																						*/
/***    5-2.  직책수당(03)																						*/
/***    5-3.  관리직연장수당(02)																				*/
/***    5-3_1. 직무수당, 안전수당			   															*/
/***    5-4.  근속수당(05)																						*/
/***    5-5.  가족수당(06)																						*/
/***    5-6.  지역수당(07)																						*/
/***    5-7.  영업보조수당(08)																				*/
/***    5-8.  식대보조수당(09)																				*/
/***    5-9.  월차수당(13)																						*/
/***    5-10. 생리수당(14)																						*/
/***    5-11. 년차수당(15)																						*/
/***    5-12. 주휴수당(16)																						*/
/***    5-13. 야간수당(17)																						*/
/***    5-14. 휴일수당(18)																						*/
/***    5-15. 연장수당(04)																						*/
/***    5-16. 생산장려수당(11)																				*/
/***    5-17. 지각공제(06),외출공제(08),조퇴공제(07)													*/
/***    5-18. 의료보험공제(05)																				*/
/***    5-19. 국민연금공제(04)																				*/
/***    5-20. 퇴직전환금()																						*/
/******************************************************************************************/

//Int    il_meterPosition,k,il_CurRow,il_Count,i
//String sEmpNo,sEmpNoSql,sAllowCode
//
//IF rb_1.Checked = True THEN										//전체
//	dw_Process = dw_total
//	il_RowCount = dw_total.RowCount()
//ELSEIF rb_2.Checked = True THEN									//개인
//	dw_Process = dw_personal
//	il_RowCount = dw_personal.RowCount()
//END IF
//
//IF il_RowCount <=0 THEN 
//	MessageBox("확 인","처리할 자료가 없습니다!!")
//	Return
//END IF
//
//IF dw_allow.AcceptText() = -1 THEN RETURN
//
//sAllowCode = dw_allow.GetItemString(1,"allowcode")
//IF sAllowCode = "" OR IsNull(sAllowCode) THEN
//	sAllowCode = '%'
//END IF
//
//sEmpNoSql = Wf_SqlSyntax()												/*처리대상 인원 sql*/
//
//IF cbx_add.Checked = True AND cbx_sub.Checked = True THEN
//	sPayGbn = '%'
//END IF
//
//IF cbx_1.Checked = True AND cbx_2.Checked = True THEN
//	sPTag = '%'
//	sBTag = '%'
//END IF
//
//IF sProcGbn = 'FIX' THEN								/*고정자료  생성*/
//	sle_msg.text = '급여 고정자료 생성 중......'
//	SetPointer(HourGlass!)
//	
//	DECLARE start_sp_create_fixdata procedure for sp_create_fixdata(:sProcYearMonth,:sPayGbn,&
//					:sPTag,:sBTag,:sAllowCode,:sEmpNoSql, :gs_company) ;
//	execute start_sp_create_fixdata ;
//
//	SetPointer(Arrow!)
//	sle_msg.text ='급여 고정자료 생성 완료!!'
//ELSEIF sProcGbn = 'EXCEPT'	THEN						/*예외자료 생성*/
//	sle_msg.text = '급여 예외자료 생성 중......'
//	SetPointer(HourGlass!)
//	
//	DECLARE start_sp_create_exceptdata procedure for sp_create_exceptdata(:sProcYearMonth,:sEmpNoSql, :gs_company);
//	execute start_sp_create_exceptdata ;
//	
//	SetPointer(Arrow!)
//	sle_msg.text ='급여 예외자료 생성 완료!!'
//ELSE
//	sle_msg.text = '급여 인적 공제 자료 갱신 중......'
//	SetPointer(HourGlass!)
//	
//	DECLARE start_sp_update_personal procedure for sp_update_personal(:sProcYearMonth,:sEmpNoSql, :gs_company);
//	execute start_sp_update_personal ;
//	
//	SetPointer(Arrow!)
//	sle_msg.text ='급여 인적 공제 자료 갱신 완료!!'
//END IF
//
//
end subroutine

public function integer wf_reqchk ();String sCode
Long sAmt

dw_allow.AcceptText()

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
sCode  = dw_allow.GetItemString(1,"allowcode")   /*수당항목*/
sAmt   = dw_allow.GetItemNumber(1,"allowamt")    /*수당금액*/

IF sProcYearMonth = '000000' OR ISNULL(sProcYearMonth) THEN
	MessageBox("확 인","처리년월을 입력하세요!!",StopSign!)
	em_ym.SetFocus()
	Return -1
END IF	

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","항목을 입력하세요")
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return -1
END IF	

IF sAmt = 0 OR ISNULL(sAmt) THEN
	MessageBox("확인","금액을 입력하세요")
	dw_allow.SetColumn("allowamt")
	dw_allow.SetFocus()
	Return -1
END IF	


Return 1
end function

public function integer wf_changedata ();/*변동금액 생성 */

  Long K,sAmt,sCount
  String gAllowCode,jg_tag,sPbtag,sEmpno
  
  dw_allow.AcceptText()
  
  sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
  gAllowCode = dw_allow.GetItemString(1,"allowcode")   /*수당항목*/
  sAmt       = dw_allow.GetItemNumber(1,"allowamt")    /*수당금액*/

  IF WF_REQCHK() = -1 THEN
	Return -1
  END IF	

IF dw_personal.RowCount() = 0 THEN
	dw_Process = dw_total
ELSE
	dw_Process = dw_personal
END IF	
  
/*지급,공제구분*/
IF rb_pstag1.Checked = True  THEN
	jg_tag = '1'
ELSEIF rb_pstag2.Checked = True  THEN
	jg_tag = '2'
END IF	

/*급여,상여 구분*/
 sPbtag = dw_1.GetItemString(1,"code")

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="변동금액 저장중입이다. 잠시만 기다리세요 !!"

  FOR  K = 1  TO dw_Process.RowCount()	
		 
		   sAmt   = dw_Process.GetItemNumber(K,"amt")
			sEmpno = dw_Process.GetItemString(K,"empno")
	  		       
			  SELECT COUNT(*)  
             INTO :sCount  
				 FROM "P3_MONTHCHGDATA"  
				 WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND  
                 ( "P3_MONTHCHGDATA"."WORKYM" =:sProcYearMonth) AND      				      
						 ( "P3_MONTHCHGDATA"."EMPNO" =:sEmpno) AND 
						 ( "P3_MONTHCHGDATA"."PBTAG" =:sPbtag) AND  
						 ( "P3_MONTHCHGDATA"."ALLOWCODE" =:gAllowCode) AND
					    ( "P3_MONTHCHGDATA"."GUBUN" =:jg_tag) ;
				 IF sCount = 0 THEN
					  INSERT INTO "P3_MONTHCHGDATA"  
    						     ( "COMPANYCODE",  "WORKYM",       "EMPNO",  "PBTAG",   
                             "ALLOWCODE",    "ALLOWAMT",     "GUBUN" )   
								 
	                VALUES ( :gs_company,      :sProcYearMonth,  :sEmpno,  :sPbtag,   
	                         :gAllowCode,      :sAmt,            :jg_tag)  ;        
						IF SQLCA.SQLCODE = 0 THEN
							//COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF	
				ELSE
					  UPDATE "P3_MONTHCHGDATA"  
						  SET "ALLOWAMT" =:sAmt  
						WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND  
                      ( "P3_MONTHCHGDATA"."WORKYM" =:sProcYearMonth) AND      				      
						      ( "P3_MONTHCHGDATA"."EMPNO"  =:sEmpno) AND 
						      ( "P3_MONTHCHGDATA"."PBTAG"  =:sPbtag) AND  
						      ( "P3_MONTHCHGDATA"."ALLOWCODE" =:gAllowCode) AND
					         ( "P3_MONTHCHGDATA"."GUBUN" =:jg_tag) ;
					   IF SQLCA.SQLCODE = 0 THEN
							//COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF					 
               	
				END IF

    NEXT
   COMMIT ; 
	w_mdi_frame.sle_msg.text ="자료 저장완료!!"
SetPointer(Arrow!)
Return  1
end function

public function integer wf_fixupdate ();String  sEmpno,Pbtag,Gubn,gAllowCode,jg_tag,sPbtag
Long K,sAmt,sCount

dw_allow.AcceptText()
sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
gAllowCode = dw_allow.GetItemString(1,"allowcode")   /*수당항목*/
sAmt       = dw_allow.GetItemNumber(1,"allowamt")    /*수당금액*/

IF WF_REQCHK() = -1 THEN
	Return -1
END IF	

IF dw_personal.RowCount() = 0 THEN
	dw_Process = dw_total
ELSE
	dw_Process = dw_personal
END IF	


/*지급,공제구분*/
IF rb_pstag1.Checked = True  THEN
	jg_tag = '1'
ELSEIF rb_pstag2.Checked = True  THEN
	jg_tag = '2'
END IF	

/*급여,상여 구분*/
 sPbtag = dw_1.GetItemString(1,"code")

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="고정금액 저장중입이다. 잠시만 기다리세요 !!"
  FOR  K = 1  TO dw_Process.RowCount()	
	
		   sEmpno = dw_Process.GetItemString(K,"empno")
		   sAmt  =  dw_Process.GetItemNumber(K,"amt")
	       
			  SELECT COUNT(*)  
             INTO :sCount  
				 FROM "P3_FIXEDDATA"  
				 WHERE ( "P3_FIXEDDATA"."PBTAG"     =:sPbtag) AND  
					    ( "P3_FIXEDDATA"."GUBUN"     =:jg_tag ) AND  
						 ( "P3_FIXEDDATA"."ALLOWCODE" =:gAllowCode) AND
						 ( "P3_FIXEDDATA"."EMPNO"     =:sEmpno )  ;
				 IF sCount = 0 THEN
					  INSERT INTO "P3_FIXEDDATA"  
	                    ( "COMPANYCODE", "ALLOWCODE",  "EMPNO",  "PBTAG",   
	                      "ALLOWAMT",    "GUBUN" )  
	              VALUES ( :gs_company,   :gAllowCode,  :sEmpno, :sPbtag,   
	                       :sAmt,         :jg_tag )  ;        
						IF SQLCA.SQLCODE = 0 THEN
							//COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF	
				ELSE
					  UPDATE "P3_FIXEDDATA"  
						  SET "ALLOWAMT" =:sAmt  
						WHERE ( "P3_FIXEDDATA"."ALLOWCODE" =:gAllowCode ) AND  
								( "P3_FIXEDDATA"."PBTAG" =:sPbtag ) AND  
								( "P3_FIXEDDATA"."GUBUN" =:jg_tag ) AND
								( "P3_FIXEDDATA"."EMPNO" =:sEmpno )   ;
					   IF SQLCA.SQLCODE = 0 THEN
							//COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF					 
               	
				END IF
		
    NEXT
	COMMIT ; 
   w_mdi_frame.sle_msg.text ="자료 저장완료!!"
	SetPointer(Arrow!)
Return 1
end function

public function integer wf_allowcodechk ();String sCode,SetNull,GO_Change,PYesNo,BYesNo,JIGOJNG_Gubn,PbTag
Long sCount,GetCode

dw_allow.AcceptText()

sCode = dw_allow.GetItemString(1,"allowcode")

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return -1
END IF
//IF rb_pstag1.Checked = True THEN  /*지급*/
//	  SELECT COUNT(*)
//      INTO :sCount  
//      FROM "P3_ALLOWANCE" 
//	  WHERE "P3_ALLOWANCE"."PAYSUBTAG" ='1'AND
//	        "P3_ALLOWANCE"."ALLOWCODE" = :sCode ;
//	  
//	  IF sCount = 0 THEN
//		  MessageBox("수당확인","수당항목을 확인하세요")
//		  dw_allow.SetItem(1,"allowcode",SetNull)
//		  dw_allow.SetColumn("allowcode")
//		  dw_allow.SetFocus()
//		  Return -1
//	  END IF
//ELSEIF rb_pstag2.Checked = True THEN /*공제*/
//	 SELECT COUNT(*)
//      INTO :sCount  
//      FROM "P3_ALLOWANCE" 
//	  WHERE "P3_ALLOWANCE"."PAYSUBTAG" ='2' AND
//	        "P3_ALLOWANCE"."ALLOWCODE" =:sCode ;
//	  
//	  IF sCount = 0 THEN
//		  MessageBox("수당확인","수당항목을 확인하세요")
//		  dw_allow.SetColumn("allowcode")
//		  dw_allow.SetFocus()
//		  Return -1
//	  END IF
//END IF	

dw_1.AcceptText()

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
 IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
 IF rb_5.Checked = True THEN
	 GO_Change = '1'
 ELSEIF rb_6.Checked = True THEN	 
	 GO_Change = '2'
 END IF	
  
 SELECT COUNT("P3_ALLOWANCE"."ALLOWCODE")  
 	INTO :GetCode  
   FROM "P3_ALLOWANCE"  
   WHERE ( "P3_ALLOWANCE"."PAYSUBTAG" =:JIGOJNG_Gubn ) AND  
         ( "P3_ALLOWANCE"."TAG1" like :PYesNo ) AND  
			( "P3_ALLOWANCE"."TAG1" like :BYesNo ) AND  
         ( "P3_ALLOWANCE"."REFERENCETABLE" =:GO_Change ) AND
			( "P3_ALLOWANCE"."ALLOWCODE" =:sCode)   ;
   
   IF GetCode = 0 THEN
		MessageBox("수당확인","수당항목을 확인하세요")
		dw_allow.SetItem(1,"allowcode",SetNull)
	   dw_allow.SetColumn("allowcode")
		dw_allow.SetFocus()
		Return -1
	END IF	

Return 1
end function

on w_pip1015.create
int iCurrent
call super::create
this.gb_9=create gb_9
this.gb_6=create gb_6
this.gb_8=create gb_8
this.gb_3=create gb_3
this.uo_progress=create uo_progress
this.rb_1=create rb_1
this.st_2=create st_2
this.rb_2=create rb_2
this.st_3=create st_3
this.em_ym=create em_ym
this.dw_allow=create dw_allow
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_total=create dw_total
this.dw_1=create dw_1
this.rb_pstag1=create rb_pstag1
this.rb_pstag2=create rb_pstag2
this.dw_personal=create dw_personal
this.gb_7=create gb_7
this.rb_5=create rb_5
this.rb_6=create rb_6
this.cb_1=create cb_1
this.p_allcreate=create p_allcreate
this.p_alldel=create p_alldel
this.st_20=create st_20
this.st_4=create st_4
this.dw_saup=create dw_saup
this.gb_4=create gb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_6=create rr_6
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_9
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.gb_8
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.uo_progress
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.em_ym
this.Control[iCurrent+11]=this.dw_allow
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.pb_2
this.Control[iCurrent+14]=this.dw_total
this.Control[iCurrent+15]=this.dw_1
this.Control[iCurrent+16]=this.rb_pstag1
this.Control[iCurrent+17]=this.rb_pstag2
this.Control[iCurrent+18]=this.dw_personal
this.Control[iCurrent+19]=this.gb_7
this.Control[iCurrent+20]=this.rb_5
this.Control[iCurrent+21]=this.rb_6
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.p_allcreate
this.Control[iCurrent+24]=this.p_alldel
this.Control[iCurrent+25]=this.st_20
this.Control[iCurrent+26]=this.st_4
this.Control[iCurrent+27]=this.dw_saup
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.rr_1
this.Control[iCurrent+30]=this.rr_2
this.Control[iCurrent+31]=this.rr_6
this.Control[iCurrent+32]=this.rr_3
end on

on w_pip1015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_9)
destroy(this.gb_6)
destroy(this.gb_8)
destroy(this.gb_3)
destroy(this.uo_progress)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.rb_2)
destroy(this.st_3)
destroy(this.em_ym)
destroy(this.dw_allow)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_total)
destroy(this.dw_1)
destroy(this.rb_pstag1)
destroy(this.rb_pstag2)
destroy(this.dw_personal)
destroy(this.gb_7)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.cb_1)
destroy(this.p_allcreate)
destroy(this.p_alldel)
destroy(this.st_20)
destroy(this.st_4)
destroy(this.dw_saup)
destroy(this.gb_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_6)
destroy(this.rr_3)
end on

event open;call super::open;String SetNull

dw_allow.SetTransObject(SQLCA)
dw_allow.Retrieve()

dw_total.SetTransObject(SQLCA)
dw_total.Reset()

dw_personal.SetTransObject(SQLCA)

dw_saup.SetTransObject(sqlca)
dw_saup.InsertRow(0)

f_set_saupcd(dw_saup, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)
dw_1.Setitem(1,"code","P")

em_ym.text = String(f_aftermonth(left(f_today(),6),-1),'@@@@.@@')
em_ym.SetFocus()

p_allcreate.Enabled = False
p_mod.Enabled = False

uo_progress.Hide()

dw_allow.SetITem(1,"allowcode",SetNull)
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1015
boolean visible = false
integer x = 1486
integer y = 2896
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1015
boolean visible = false
integer x = 1312
integer y = 2896
end type

type p_search from w_inherite_multi`p_search within w_pip1015
boolean visible = false
integer x = 617
integer y = 2896
end type

type p_ins from w_inherite_multi`p_ins within w_pip1015
boolean visible = false
integer x = 1138
integer y = 2896
end type

type p_exit from w_inherite_multi`p_exit within w_pip1015
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1015
integer x = 4242
end type

event p_can::clicked;call super::clicked;String SetNull

uo_progress.Hide()

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
p_mod.Enabled  = False
p_allcreate.Enabled  = False
dw_allow.SetITem(1,"allowcode",SetNull)
dw_allow.SetITem(1,"allowamt",0)
dw_allow.SetColumn("allowcode")
dw_allow.SetFocus()
end event

type p_print from w_inherite_multi`p_print within w_pip1015
boolean visible = false
integer x = 791
integer y = 2896
end type

type p_inq from w_inherite_multi`p_inq within w_pip1015
integer x = 3547
end type

event p_inq::clicked;call super::clicked;String Pbtag,P_JGTAG,sAllowCode, ls_saup

dw_1.AcceptText()
dw_total.Reset()
dw_personal.Reset()
dw_saup.AcceptText()

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
Pbtag          = dw_1.GetItemString(1,"code") /*급여,상여구분*/
sAllowCode     = dw_allow.GetItemString(1,"allowcode")
ls_saup			= dw_saup.GetItemString(1,"saupcd")

IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'
			
/*지급,공제구분*/   
IF rb_pstag1.Checked = True THEN
	P_JGTAG = '1'
ELSEIF rb_pstag2.Checked = True THEN	
	P_JGTAG = '2'
END IF

IF sProcYearMonth = '000000' OR ISNULL(sProcYearMonth) THEN
	MessageBox("확 인","처리년월을 입력하세요!!",StopSign!)
	em_ym.SetFocus()
	Return
END IF	

/*항목코드 체크*/
IF sAllowCode = '' OR ISNULL(sAllowCode) THEN
	MessageBox("확 인","항목코드를 입력하세요!!",StopSign!)
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return
END IF	

SetPointer(HourGlass!)
dw_total.SetRedraw(False)
IF dw_total.Retrieve(gs_company,Pbtag,P_JGTAG,sAllowCode,sProcYearMonth,ls_saup) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	em_ym.SetFocus()
	p_allcreate.Enabled = False
  //cb_update.Enabled = False
	SetPointer(Arrow!)
	Return
END IF
dw_total.SetRedraw(True)
SetPointer(Arrow!)
p_allcreate.Enabled = True
//cb_update.Enabled = True






end event

type p_del from w_inherite_multi`p_del within w_pip1015
boolean visible = false
integer x = 1833
integer y = 2896
end type

type p_mod from w_inherite_multi`p_mod within w_pip1015
integer x = 3895
end type

event p_mod::clicked;call super::clicked;String sCode
Long sAmt


IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_personal.RowCount() = 0 THEN
	IF dw_total.RowCount() = 0 THEN
		Return
	END IF	
END IF	

IF dw_personal.RowCount() = 0 THEN
	dw_Process = dw_total
ELSE
	dw_Process = dw_personal
END IF	


IF rb_5.Checked = True THEN /*고정금액생성*/
	IF WF_FIXUPDATE() = -1 THEN
		Return 
	END IF
ELSEIF rb_6.Checked = True THEN	 /*변동금액 생성*/
 	IF WF_CHANGEDATA() = -1 THEN
		Return 
	END IF
END IF	
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1015
boolean visible = false
integer x = 73
integer y = 2776
end type

type st_window from w_inherite_multi`st_window within w_pip1015
integer y = 3724
end type

type cb_append from w_inherite_multi`cb_append within w_pip1015
boolean visible = false
integer x = 1966
integer y = 3392
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip1015
boolean visible = false
integer y = 2812
integer taborder = 80
end type

type cb_update from w_inherite_multi`cb_update within w_pip1015
boolean visible = false
integer x = 2007
integer y = 2812
integer taborder = 60
end type

event cb_update::clicked;call super::clicked;String sCode
Long sAmt


IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_personal.RowCount() = 0 THEN
	IF dw_total.RowCount() = 0 THEN
		Return
	END IF	
END IF	

IF dw_personal.RowCount() = 0 THEN
	dw_Process = dw_total
ELSE
	dw_Process = dw_personal
END IF	


IF rb_5.Checked = True THEN /*고정금액생성*/
	IF WF_FIXUPDATE() = -1 THEN
		Return 
	END IF
ELSEIF rb_6.Checked = True THEN	 /*변동금액 생성*/
 	IF WF_CHANGEDATA() = -1 THEN
		Return 
	END IF
END IF	
end event

type cb_insert from w_inherite_multi`cb_insert within w_pip1015
boolean visible = false
integer x = 2331
integer y = 3392
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1015
boolean visible = false
integer x = 2373
integer y = 2812
integer width = 443
integer taborder = 0
string text = "일괄삭제(&D)"
end type

event cb_delete::clicked;call super::clicked;String sCode,sPbtag,jigo_Tag,Get_Empno
Long sAmt,K

dw_allow.AcceptText()
dw_1.AcceptText()
dw_total.AcceptText()


IF dw_personal.RowCount() = 0 THEN
   IF dw_total.RowCount() = 0 THEN
		MessageBox("확인","삭제할 자료가 없습니다")
		Return 
	END IF
END IF	
		
sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2) /*처리년월*/
sCode  = dw_allow.GetItemString(1,"allowcode")   /*수당항목*/
sPbtag = dw_1.GetItemString(1,"code")	          /*급여,상여구분*/		

IF rb_6.Checked = True THEN
	IF sProcYearMonth = '000000' OR ISNULL(sProcYearMonth) THEN
		MessageBox("확인","처리년월을 입력하세요!!",StopSign!)
		em_ym.SetFocus()
		Return -1
	END IF	
END IF

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return -1
END IF	

/*지급,공제 여부*/
IF rb_pstag1.Checked = True THEN
	jigo_Tag = '1'
ELSEIF rb_pstag2.Checked = True THEN	
	jigo_Tag = '2'
END IF

IF dw_personal.RowCount() = 0 THEN  /*개인별로 삭제할 자료가 없으면 일괄삭제 */
		/*고정금액 삭제*/
		IF rb_5.Checked = True THEN 
			IF MessageBox("삭제확인", "고정금액을 일괄 삭제합니다.", question!, yesno!) = 2	THEN	RETURN 	
					 DELETE FROM "P3_FIXEDDATA"  
						WHERE ( "P3_FIXEDDATA"."COMPANYCODE" =:gs_company ) AND  
								( "P3_FIXEDDATA"."ALLOWCODE"   =:sCode ) AND  
								( "P3_FIXEDDATA"."PBTAG"       =:sPbtag ) AND  
								( "P3_FIXEDDATA"."GUBUN"       =:jigo_Tag )   ;
					 IF SQLCA.SQLCODE = 0 THEN
						 COMMIT ;	
						 SLE_MSG.TEXT = "고정금액 자료삭제 성공!!"
					 ELSE
						 ROLLBACK ; 
						 SLE_MSG.TEXT = "고정금액 자료삭제 실패"
						 RETURN
					 END IF	
						 
		ELSEIF rb_6.Checked = True THEN
		/*변동금액 삭제*/	
			   IF MessageBox("삭제확인", "변동금액을 일괄 삭제합니다.", question!, yesno!) = 2	THEN	RETURN 	
						DELETE FROM "P3_MONTHCHGDATA"  
						 WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company ) AND  
								 ( "P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth ) AND  
								 ( "P3_MONTHCHGDATA"."PBTAG"       =:sPbtag ) AND  
								 ( "P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode ) AND  
								 ( "P3_MONTHCHGDATA"."GUBUN"       =:jigo_Tag )   ;
		
						IF SQLCA.SQLCODE = 0	THEN		
							COMMIT ;	
							SLE_MSG.TEXT = "변동금액 자료삭제 성공!!"
						ELSE
							ROLLBACK ; 
							SLE_MSG.TEXT = "변동금액 자료삭제 실패"
							RETURN
						END IF	
		
		END IF	
	/*개인별로 삭제함 */
ELSE
      /*고정금액 삭제*/
		IF rb_5.Checked = True THEN 
		   FOR K = 1  TO  dw_personal.RowCount()
				 Get_Empno = dw_personal.GetItemString(K,"empno")
				 DELETE FROM "P3_FIXEDDATA"  
			  	 WHERE ( "P3_FIXEDDATA"."COMPANYCODE" =:gs_company ) AND  
					    ( "P3_FIXEDDATA"."ALLOWCODE"   =:sCode ) AND  
						 ( "P3_FIXEDDATA"."PBTAG"       =:sPbtag ) AND  
						 ( "P3_FIXEDDATA"."GUBUN"       =:jigo_Tag ) AND
						 ( "P3_FIXEDDATA"."EMPNO"       =:Get_Empno )  ;
				 IF SQLCA.SQLCODE = 0 THEN
					 //COMMIT ;	
					 SLE_MSG.TEXT = "고정금액 자료삭제 성공!!"
				 ELSE
					 ROLLBACK ; 
					 SLE_MSG.TEXT = "고정금액 자료삭제 실패"
					 EXIT
					 RETURN
				 END IF	
		  	NEXT
			    COMMIT ;	
		ELSEIF rb_6.Checked = True THEN /*변동금액 삭제*/	
			FOR K = 1  TO  dw_total.RowCount()
				 Get_Empno = dw_total.GetItemString(K,"empno")
				 DELETE FROM "P3_MONTHCHGDATA"  
				 WHERE ("P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company ) AND  
					    ("P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth ) AND  
						 ("P3_MONTHCHGDATA"."PBTAG"       =:sPbtag ) AND  
						 ("P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode ) AND  
						 ("P3_MONTHCHGDATA"."GUBUN"       =:jigo_Tag ) AND
						 ("P3_MONTHCHGDATA"."GUBUN"       =:Get_Empno ) ;
						 
				 IF SQLCA.SQLCODE = 0 THEN
					 //COMMIT ;	
					 SLE_MSG.TEXT = "변동금액 자료삭제 성공!!"
				 ELSE
					 ROLLBACK ; 
					 SLE_MSG.TEXT = "변동금액 자료삭제 실패"
					 EXIT
					 RETURN
				 END IF				
			 NEXT
			    COMMIT ;	
		END IF	
END IF		
cb_retrieve.TriggerEvent(Clicked!)
end event

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1015
boolean visible = false
integer x = 96
integer y = 2812
integer taborder = 40
end type

event cb_retrieve::clicked;String Pbtag,P_JGTAG,sAllowCode 

dw_1.AcceptText()
dw_total.Reset()
dw_personal.Reset()

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
Pbtag          = dw_1.GetItemString(1,"code") /*급여,상여구분*/
sAllowCode     = dw_allow.GetItemString(1,"allowcode")
			
/*지급,공제구분*/   
IF rb_pstag1.Checked = True THEN
	P_JGTAG = '1'
ELSEIF rb_pstag2.Checked = True THEN	
	P_JGTAG = '2'
END IF

IF sProcYearMonth = '000000' OR ISNULL(sProcYearMonth) THEN
	MessageBox("확 인","처리년월을 입력하세요!!",StopSign!)
	em_ym.SetFocus()
	Return
END IF	

/*항목코드 체크*/
IF sAllowCode = '' OR ISNULL(sAllowCode) THEN
	MessageBox("확 인","항목코드를 입력하세요!!",StopSign!)
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return
END IF	

SetPointer(HourGlass!)
dw_total.SetRedraw(False)
IF dw_total.Retrieve(gs_company,Pbtag,P_JGTAG,sAllowCode,sProcYearMonth) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	em_ym.SetFocus()
	cb_1.Enabled = False
  //cb_update.Enabled = False
	SetPointer(Arrow!)
	Return
END IF
dw_total.SetRedraw(True)
SetPointer(Arrow!)
cb_1.Enabled = True
//cb_update.Enabled = True






end event

type st_1 from w_inherite_multi`st_1 within w_pip1015
integer y = 3724
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1015
boolean visible = false
integer y = 2812
integer taborder = 70
end type

event cb_cancel::clicked;call super::clicked;String SetNull

uo_progress.Hide()

sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
cb_update.Enabled  = False
cb_1.Enabled  = False
dw_allow.SetITem(1,"allowcode",SetNull)
dw_allow.SetITem(1,"allowamt",0)
dw_allow.SetColumn("allowcode")
dw_allow.SetFocus()
end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1015
integer y = 3724
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1015
integer x = 379
integer y = 3732
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1015
boolean visible = false
integer x = 1970
integer y = 2760
integer width = 1609
integer height = 188
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1015
boolean visible = false
integer x = 55
integer y = 2760
integer width = 878
integer height = 188
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1015
integer x = 0
integer y = 3680
integer width = 3630
end type

type gb_9 from groupbox within w_pip1015
integer x = 686
integer y = 1480
integer width = 1106
integer height = 276
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "처리구분"
end type

type gb_6 from groupbox within w_pip1015
integer x = 699
integer y = 1164
integer width = 1106
integer height = 276
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "급여/상여구분"
end type

type gb_8 from groupbox within w_pip1015
integer x = 695
integer y = 1812
integer width = 1106
integer height = 276
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "급여항목"
end type

type gb_3 from groupbox within w_pip1015
integer x = 699
integer y = 576
integer width = 1106
integer height = 276
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "조건"
end type

type uo_progress from u_progress_bar within w_pip1015
boolean visible = false
integer x = 626
integer y = 3636
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type rb_1 from radiobutton within w_pip1015
integer x = 1143
integer y = 760
integer width = 247
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "전체"
boolean checked = true
end type

type st_2 from statictext within w_pip1015
integer x = 832
integer y = 760
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "작업대상"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_pip1015
integer x = 1454
integer y = 760
integer width = 247
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "개인"
end type

type st_3 from statictext within w_pip1015
integer x = 832
integer y = 656
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "처리년월"
boolean focusrectangle = false
end type

type em_ym from editmask within w_pip1015
event ue_enter pbm_keydown
integer x = 1143
integer y = 656
integer width = 261
integer height = 52
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean autoskip = true
end type

event ue_enter;IF key = KeyEnter! THEN
   Send(Handle(this),256,9,0)
   Return 1
END IF	
end event

type dw_allow from datawindow within w_pip1015
event ue_enter pbm_dwnprocessenter
integer x = 782
integer y = 1892
integer width = 983
integer height = 176
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip1015_40"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event retrievestart;DataWindowChild state_child

dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
/*지급/공제구분,급여포함여부,지급구분*/
IF state_child.Retrieve("1","Y",'%',"1") <= 0 THEN
	Return 1
END IF	
end event

event itemerror;Return 1
end event

event itemchanged;/*수당체크*/
IF dw_allow.GetColumnName() = "allowcode" THEN
	IF WF_ALLOWCODECHK() = -1 THEN
	   Return 1
   END IF
END IF	

end event

type pb_1 from picturebutton within w_pip1015
integer x = 3013
integer y = 608
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long   totRow , sRow,rowcnt,sAmt
int i

totrow =dw_total.Rowcount()

dw_personal.SetRedraw(False)
dw_total.SetRedraw(False)
FOR i = 1 TO totrow 
	sRow = dw_total.GetselectedRow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_total.GetItemString(sRow, "empno")
   sEmpName    = dw_total.GetItemString(sRow, "empname")
	sAmt        = dw_total.GetItemNumber(sRow,"amt")
	    
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname", sEmpName)
	dw_personal.setitem(rowcnt, "empno", sEmpNo)
	dw_personal.setitem(rowcnt, "amt",sAmt)    
	dw_total.deleterow(sRow)
NEXT	
dw_personal.SetRedraw(True)
dw_total.SetRedraw(True)

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type pb_2 from picturebutton within w_pip1015
integer x = 3013
integer y = 704
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\prior.gif"
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long    rowcnt , totRow , sRow ,sAmt
int     i

totRow =dw_personal.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_personal.GetItemString(sRow, "empno")
   sEmpName    = dw_personal.GetItemString(sRow, "empname")
	sAmt        = dw_personal.GetItemNumber(sRow,"amt")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empno", sEmpNo)
	dw_total.setitem(rowcnt, "empname", sEmpName)
	dw_total.setitem(rowcnt, "amt", sAmt )
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type dw_total from u_d_select_sort within w_pip1015
integer x = 2135
integer y = 404
integer width = 786
integer height = 1632
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1015_10"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_1 from datawindow within w_pip1015
event ue_enter pbm_dwnprocessenter
integer x = 782
integer y = 1264
integer width = 841
integer height = 80
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip1015_30"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change,PbTag
DataWindowChild state_child

dw_1.accepttext()

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
  IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
 IF rb_5.Checked = True THEN
	 GO_Change = '1'
 ELSEIF rb_6.Checked = True THEN	 
	 GO_Change = '2'
 END IF	
 
dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset() 
IF state_child.Retrieve(JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change) <= 0 THEN
	Return 1
END IF	

end event

event itemerror;Return 1
end event

type rb_pstag1 from radiobutton within w_pip1015
integer x = 791
integer y = 1016
integer width = 302
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = " 지 급"
boolean checked = true
end type

event clicked;String JIGOJNG_Gubn ,PbTag,PYesNo,BYesNo,GO_Change,SetNull
DataWindowChild state_child

//If ib_any_typing = True Then
//	IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
//		//cb_update.TriggerEvent(Clicked!)
//	END IF
//END IF

//cb_retrieve.TriggerEvent(Clicked!)

dw_1.AcceptText()

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
 IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
 IF rb_5.Checked = True THEN
	 GO_Change = '1'
 ELSEIF rb_6.Checked = True THEN	 
	 GO_Change = '2'
 END IF	
 
dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()
IF state_child.Retrieve(JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change) <= 0 THEN
	Return 1
END IF	
dw_allow.SetItem(1,"allowcode",SetNull)
end event

type rb_pstag2 from radiobutton within w_pip1015
integer x = 1367
integer y = 1016
integer width = 279
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = " 공 제"
end type

event clicked;String JIGOJNG_Gubn,PbTag,PYesNo,BYesNo,GO_Change,SetNull

//If ib_any_typing = True Then
//	IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
//		//cb_update.TriggerEvent(Clicked!)
//	END IF
//END IF

//cb_retrieve.TriggerEvent(Clicked!)
dw_1.AcceptText()
DataWindowChild state_child

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
 IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
IF rb_5.Checked = True THEN
   GO_Change = '1'
ELSEIF rb_6.Checked = True THEN	 
   GO_Change = '2'
END IF	

dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset() 
IF state_child.Retrieve(JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change) <= 0 THEN
	Return 1
END IF	
dw_allow.SetItem(1,"allowcode",SetNull)
end event

type dw_personal from u_d_select_sort within w_pip1015
integer x = 3218
integer y = 404
integer width = 791
integer height = 1632
integer taborder = 0
string dataobject = "d_pip1015_20"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type gb_7 from groupbox within w_pip1015
integer x = 695
integer y = 904
integer width = 1106
integer height = 224
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "지급/공제구분"
end type

type rb_5 from radiobutton within w_pip1015
integer x = 777
integer y = 1596
integer width = 457
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "고정금액생성"
boolean checked = true
end type

event clicked;String JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change,PbTag,SetNull
DataWindowChild state_child

dw_total.DataObject = "d_pip1015_10"
dw_total.SetTransObject(sqlca)

dw_1.AcceptText()

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
  IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
 IF rb_5.Checked = True THEN
	 GO_Change = '1'
 ELSEIF rb_6.Checked = True THEN	 
	 GO_Change = '2'
 END IF	
 
dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()
IF state_child.Retrieve(JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change) <= 0 THEN
	Return 1
END IF	

dw_allow.SetItem(1,"allowcode",SetNull)
end event

type rb_6 from radiobutton within w_pip1015
integer x = 1294
integer y = 1596
integer width = 457
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "변동금액생성"
end type

event clicked;String JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change,PbTag,SetNull
DataWindowChild state_child

dw_total.DataObject = "d_pip1015_50"
dw_total.SetTransObject(sqlca)

dw_1.AcceptText()

IF rb_pstag1.Checked = True THEN      /*지급*/
	JIGOJNG_Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN  /*공제*/ 	
   JIGOJNG_Gubn = '2'
END IF
 /*급여적용여부*/
 PbTag = dw_1.GetItemString(1,"code")
  IF PbTag = 'P' THEN
	 PYesNo = 'Y';	 		BYesNo = '%';
 ELSE
	 PYesNo = '%';			BYesNo = 'Y';
 END IF	
 
 /*고정,변동구분*/
 IF rb_5.Checked = True THEN
	 GO_Change = '1'
 ELSEIF rb_6.Checked = True THEN	 
	 GO_Change = '2'
 END IF	
 
dw_allow.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()
IF state_child.Retrieve(JIGOJNG_Gubn,PYesNo,BYesNo,GO_Change) <= 0 THEN
	Return 1
END IF	
dw_allow.SetItem(1,"allowcode",SetNull)

end event

type cb_1 from commandbutton within w_pip1015
boolean visible = false
integer x = 457
integer y = 2812
integer width = 443
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄생성(L)"
end type

event clicked;String sCode,jg_tag,sPbtag
Long sAmt,sCount,K

dw_allow.AcceptText()
dw_1.AcceptText()

cb_update.Enabled = False
IF dw_personal.RowCount() = 0 THEN
	IF dw_total.RowCOunt() = 0 THEN
      MessageBox("확 인","생성할 사원을 선택하세요!!",StopSign!)
	   Return
	END IF	 
END IF

IF WF_REQCHK() = -1 THEN
	Return 
END IF	

/*금액*/
sAmt = dw_allow.GetitemNumber(1,"allowamt")

/*수당항목*/
sCode = dw_allow.GetitemString(1,"allowcode")

/*지급,공제구분*/
IF rb_pstag1.Checked = True  THEN
	jg_tag = '1'
ELSEIF rb_pstag2.Checked = True  THEN
	jg_tag = '2'
END IF	

/*급여,상여 구분*/
 sPbtag = dw_1.GetItemString(1,"code")

IF rb_5.Checked = True THEN
	 SELECT COUNT(*)  
    INTO :sCount  
    FROM "P3_FIXEDDATA"  
   WHERE ( "P3_FIXEDDATA"."PBTAG" = :sPbtag ) AND  
         ( "P3_FIXEDDATA"."GUBUN" = :jg_tag ) AND  
         ( "P3_FIXEDDATA"."ALLOWCODE" = :sCode) ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
	
ELSEIF rb_6.Checked = True THEN	
   
	SELECT COUNT(*)  
    INTO :sCount  
    FROM "P3_MONTHCHGDATA"
   WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND 
	      ( "P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth) AND 
	      ( "P3_MONTHCHGDATA"."PBTAG"       =:sPbtag) AND  
         ( "P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode) AND
			( "P3_MONTHCHGDATA"."GUBUN"       =:jg_tag)  ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
END IF	

SetPointer(HourGlass!)
dw_personal.SetRedraw(False)
sle_msg.text ="자료 일괄생성중입니다. 잠시만 기다려주세요.!!"

IF dw_personal.RowCount() = 0 THEN
	dw_process = dw_total
ELSE
	dw_process = dw_personal
END IF	


FOR K = 1 TO dw_process.RowCount()
       dw_process.SetITem(K,"amt",sAmt)
NEXT
dw_personal.SetRedraw(True)
sle_msg.text ="자료 일괄생성 완료!!"
cb_update.Enabled = True
SetPointer(Arrow!)
end event

type p_allcreate from uo_picture within w_pip1015
integer x = 3721
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;String sCode,jg_tag,sPbtag
Long sAmt,sCount,K

dw_allow.AcceptText()
dw_1.AcceptText()

p_mod.Enabled = False
IF dw_personal.RowCount() = 0 THEN
	IF dw_total.RowCOunt() = 0 THEN
      MessageBox("확 인","생성할 사원을 선택하세요!!",StopSign!)
	   Return
	END IF	 
END IF

IF WF_REQCHK() = -1 THEN
	Return 
END IF	

/*금액*/
sAmt = dw_allow.GetitemNumber(1,"allowamt")

/*수당항목*/
sCode = dw_allow.GetitemString(1,"allowcode")

/*지급,공제구분*/
IF rb_pstag1.Checked = True  THEN
	jg_tag = '1'
ELSEIF rb_pstag2.Checked = True  THEN
	jg_tag = '2'
END IF	

/*급여,상여 구분*/
 sPbtag = dw_1.GetItemString(1,"code")

IF rb_5.Checked = True THEN
	 SELECT COUNT(*)  
    INTO :sCount  
    FROM "P3_FIXEDDATA"  
   WHERE ( "P3_FIXEDDATA"."PBTAG" = :sPbtag ) AND  
         ( "P3_FIXEDDATA"."GUBUN" = :jg_tag ) AND  
         ( "P3_FIXEDDATA"."ALLOWCODE" = :sCode) ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
	
ELSEIF rb_6.Checked = True THEN	
   
	SELECT COUNT(*)  
    INTO :sCount  
    FROM "P3_MONTHCHGDATA"
   WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND 
	      ( "P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth) AND 
	      ( "P3_MONTHCHGDATA"."PBTAG"       =:sPbtag) AND  
         ( "P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode) AND
			( "P3_MONTHCHGDATA"."GUBUN"       =:jg_tag)  ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
END IF	

SetPointer(HourGlass!)
dw_personal.SetRedraw(False)
w_mdi_frame.sle_msg.text ="자료 일괄생성중입니다. 잠시만 기다려주세요.!!"

IF dw_personal.RowCount() = 0 THEN
	dw_process = dw_total
ELSE
	dw_process = dw_personal
END IF	


FOR K = 1 TO dw_process.RowCount()
       dw_process.SetITem(K,"amt",sAmt)
NEXT
dw_personal.SetRedraw(True)
w_mdi_frame.sle_msg.text ="자료 일괄생성 완료!!"
p_mod.Enabled = True
SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_alldel from uo_picture within w_pip1015
integer x = 4069
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\일괄삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄삭제_up.gif"
end event

event clicked;call super::clicked;String sCode,sPbtag,jigo_Tag,Get_Empno
Long sAmt,K

dw_allow.AcceptText()
dw_1.AcceptText()
dw_total.AcceptText()


IF dw_personal.RowCount() = 0 THEN
   IF dw_total.RowCount() = 0 THEN
		MessageBox("확인","삭제할 자료가 없습니다")
		Return 
	END IF
END IF	
		
sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2) /*처리년월*/
sCode  = dw_allow.GetItemString(1,"allowcode")   /*수당항목*/
sPbtag = dw_1.GetItemString(1,"code")	          /*급여,상여구분*/		

IF rb_6.Checked = True THEN
	IF sProcYearMonth = '000000' OR ISNULL(sProcYearMonth) THEN
		MessageBox("확인","처리년월을 입력하세요!!",StopSign!)
		em_ym.SetFocus()
		Return -1
	END IF	
END IF

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_allow.SetColumn("allowcode")
	dw_allow.SetFocus()
	Return -1
END IF	

/*지급,공제 여부*/
IF rb_pstag1.Checked = True THEN
	jigo_Tag = '1'
ELSEIF rb_pstag2.Checked = True THEN	
	jigo_Tag = '2'
END IF

IF dw_personal.RowCount() = 0 THEN  /*개인별로 삭제할 자료가 없으면 일괄삭제 */
		/*고정금액 삭제*/
		IF rb_5.Checked = True THEN 
			IF MessageBox("삭제확인", "고정금액을 일괄 삭제합니다.", question!, yesno!) = 2	THEN	RETURN 	
					 DELETE FROM "P3_FIXEDDATA"  
						WHERE ( "P3_FIXEDDATA"."COMPANYCODE" =:gs_company ) AND  
								( "P3_FIXEDDATA"."ALLOWCODE"   =:sCode ) AND  
								( "P3_FIXEDDATA"."PBTAG"       =:sPbtag ) AND  
								( "P3_FIXEDDATA"."GUBUN"       =:jigo_Tag )   ;
					 IF SQLCA.SQLCODE = 0 THEN
						 COMMIT ;	
						 w_mdi_frame.SLE_MSG.TEXT = "고정금액 자료삭제 성공!!"
					 ELSE
						 ROLLBACK ; 
						 w_mdi_frame.SLE_MSG.TEXT = "고정금액 자료삭제 실패"
						 RETURN
					 END IF	
						 
		ELSEIF rb_6.Checked = True THEN
		/*변동금액 삭제*/	
			   IF MessageBox("삭제확인", "변동금액을 일괄 삭제합니다.", question!, yesno!) = 2	THEN	RETURN 	
						DELETE FROM "P3_MONTHCHGDATA"  
						 WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company ) AND  
								 ( "P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth ) AND  
								 ( "P3_MONTHCHGDATA"."PBTAG"       =:sPbtag ) AND  
								 ( "P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode ) AND  
								 ( "P3_MONTHCHGDATA"."GUBUN"       =:jigo_Tag )   ;
		
						IF SQLCA.SQLCODE = 0	THEN		
							COMMIT ;	
							w_mdi_frame.SLE_MSG.TEXT = "변동금액 자료삭제 성공!!"
						ELSE
							ROLLBACK ; 
							w_mdi_frame.SLE_MSG.TEXT = "변동금액 자료삭제 실패"
							RETURN
						END IF	
		
		END IF	
	/*개인별로 삭제함 */
ELSE
      /*고정금액 삭제*/
		IF rb_5.Checked = True THEN 
		   FOR K = 1  TO  dw_personal.RowCount()
				 Get_Empno = dw_personal.GetItemString(K,"empno")
				 DELETE FROM "P3_FIXEDDATA"  
			  	 WHERE ( "P3_FIXEDDATA"."COMPANYCODE" =:gs_company ) AND  
					    ( "P3_FIXEDDATA"."ALLOWCODE"   =:sCode ) AND  
						 ( "P3_FIXEDDATA"."PBTAG"       =:sPbtag ) AND  
						 ( "P3_FIXEDDATA"."GUBUN"       =:jigo_Tag ) AND
						 ( "P3_FIXEDDATA"."EMPNO"       =:Get_Empno )  ;
				 IF SQLCA.SQLCODE = 0 THEN
					 //COMMIT ;	
					 w_mdi_frame.SLE_MSG.TEXT = "고정금액 자료삭제 성공!!"
				 ELSE
					 ROLLBACK ; 
					 w_mdi_frame.SLE_MSG.TEXT = "고정금액 자료삭제 실패"
					 EXIT
					 RETURN
				 END IF	
		  	NEXT
			    COMMIT ;	
		ELSEIF rb_6.Checked = True THEN /*변동금액 삭제*/	
			FOR K = 1  TO  dw_total.RowCount()
				 Get_Empno = dw_total.GetItemString(K,"empno")
				 DELETE FROM "P3_MONTHCHGDATA"  
				 WHERE ("P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company ) AND  
					    ("P3_MONTHCHGDATA"."WORKYM"      =:sProcYearMonth ) AND  
						 ("P3_MONTHCHGDATA"."PBTAG"       =:sPbtag ) AND  
						 ("P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode ) AND  
						 ("P3_MONTHCHGDATA"."GUBUN"       =:jigo_Tag ) AND
						 ("P3_MONTHCHGDATA"."GUBUN"       =:Get_Empno ) ;
						 
				 IF SQLCA.SQLCODE = 0 THEN
					 //COMMIT ;	
					 w_mdi_frame.SLE_MSG.TEXT = "변동금액 자료삭제 성공!!"
				 ELSE
					 ROLLBACK ; 
					 w_mdi_frame.SLE_MSG.TEXT = "변동금액 자료삭제 실패"
					 EXIT
					 RETURN
				 END IF				
			 NEXT
			    COMMIT ;	
		END IF	
END IF		
p_inq.TriggerEvent(Clicked!)
end event

type st_20 from statictext within w_pip1015
integer x = 2176
integer y = 352
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pip1015
integer x = 3259
integer y = 352
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "개인"
boolean focusrectangle = false
end type

type dw_saup from datawindow within w_pip1015
integer x = 846
integer y = 420
integer width = 704
integer height = 80
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type gb_4 from groupbox within w_pip1015
integer x = 695
integer y = 344
integer width = 1106
integer height = 200
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사업장 구분"
end type

type rr_1 from roundrectangle within w_pip1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 658
integer y = 300
integer width = 1175
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2039
integer y = 304
integer width = 2075
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2126
integer y = 372
integer width = 809
integer height = 1676
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3209
integer y = 372
integer width = 809
integer height = 1676
integer cornerheight = 40
integer cornerwidth = 55
end type

