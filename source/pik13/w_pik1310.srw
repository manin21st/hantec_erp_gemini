$PBExportHeader$w_pik1310.srw
$PBExportComments$** 일근태 생성 및 수정
forward
global type w_pik1310 from w_inherite_standard
end type
type cb_calc from commandbutton within w_pik1310
end type
type st_2 from statictext within w_pik1310
end type
type p_1 from uo_picture within w_pik1310
end type
type cbx_1 from checkbox within w_pik1310
end type
type p_calc from uo_picture within w_pik1310
end type
type dw_2 from u_d_select_sort within w_pik1310
end type
type p_2 from uo_picture within w_pik1310
end type
type gb_3 from groupbox within w_pik1310
end type
type rr_1 from roundrectangle within w_pik1310
end type
type dw_1 from u_key_enter within w_pik1310
end type
type cb_3 from commandbutton within w_pik1310
end type
type ddlb_1 from dropdownlistbox within w_pik1310
end type
type em_1 from editmask within w_pik1310
end type
type dw_3 from datawindow within w_pik1310
end type
type gb_5 from groupbox within w_pik1310
end type
end forward

global type w_pik1310 from w_inherite_standard
integer width = 4667
integer height = 2596
string title = "일근태계산 및 수정"
boolean resizable = false
event ue_postopen ( )
cb_calc cb_calc
st_2 st_2
p_1 p_1
cbx_1 cbx_1
p_calc p_calc
dw_2 dw_2
p_2 p_2
gb_3 gb_3
rr_1 rr_1
dw_1 dw_1
cb_3 cb_3
ddlb_1 ddlb_1
em_1 em_1
dw_3 dw_3
gb_5 gb_5
end type
global w_pik1310 w_pik1310

type variables
Boolean Ib_DetailFlag = False
string       ls_dkdeptcode, timegubn,il_filename,sProcFile
int time_row
Double    dYkTime

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false

integer  ii_fileid

double iyj, iyk, ihk, ihyj, ihyk

end variables

forward prototypes
public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag)
public function double wf_conv_hhmm (double dtime)
public subroutine wf_data_create (string sempno, string sdate, long stime, string lgubn)
public function integer wf_fileclose ()
public function integer wf_fileopen ()
public function integer wf_fileread ()
protected function integer wf_insert_dkentae (double cktime, double tgtime)
public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck)
public function string wf_proceduresql ()
public function string wf_proceduresql2 ()
public subroutine wf_reset ()
public subroutine wf_set_sqlsyntax (string sdate, string sdept)
public subroutine wf_init_clear (integer ll_currow, string ls_addgubn, string ls_ktcode)
end prototypes

event ue_postopen();string ls_chtime, ls_tgtime, ls_kdate, ls_deptcode, ls_jikjong, sSaup, sKunmu
int cnt



if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_jikjong = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong'))
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))

IF ls_kdate = ""		OR IsNull(ls_kdate)		THEN return
IF ls_deptCode = ""	OR IsNull(ls_deptCode)	THEN ls_DeptCode = '%'
IF ls_jikjong = ""	OR IsNull(ls_jikjong)	THEN ls_jikjong = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'
IF sKunmu = ""  		OR IsNull(sKunmu)			THEN sKunmu = '%'

select count(*) into :cnt
from   p4_dkentae a, p1_master b, p0_dept c
where  a.companycode = :gs_company and
       a.kdate = :ls_kdate and
		 a.deptcode like :ls_deptcode and
		 a.companycode = c.companycode and
		 a.deptcode = c.deptcode and
		 c.saupcd LIKE :sSaup and
		 a.jikjonggubn like :ls_jikjong and
		 a.empno = b.empno and
		 b.kunmugubn LIKE :sKunmu;
IF cnt > 0 THEN
	p_inq.TriggerEvent(Clicked!)
//ELSE
//	IF MessageBox('확인','생성된 근태 자료가 없습니다.~r~n근태자료를 생성하시겠습니까?',Question!,YesNo!) = 1 THEN
//		p_search.TriggerEvent(Clicked!)
//		p_can.Enabled = True
//		p_can.PictureName = "C:\erpman\image\취소_up.gif"
//	END IF
END IF
end event

public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag);String  sYearMonth,sSex,sFromDate,sToDate,snull, sentdate
Integer lYDay,lCnt

SetNull(snull)

sYearMonth = Left(sKDate, 4) + Mid(sKDate, 5, 2)
		
///* 월차 체크 */
//if sFlag = "1" then			
//	SELECT "P4_MONTHLIST"."YDAY" + "P4_MONTHLIST"."BDAY"				/*이월일수 + 발생일수*/
//		INTO :lYDay  
//	   FROM "P4_MONTHLIST"  
//	   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_MONTHLIST"."YYMM" = :sYearMonth ) AND  ( "P4_MONTHLIST"."EMPNO" = :sempno )   ;
//	IF sqlca.sqlcode <> 0 THEN
//		messagebox("확인", "월차를 사용할수 없습니다 (월차 생성 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1
//	END IF	  
//	
//	/*사용일수 = 일근태의 '월차'근태코드횟수(작업하고 있는 근태일자 제외)*/		
//	SELECT count("P4_DKENTAE"."KTCODE")  			
//		INTO :lCnt  
//		FROM "P4_DKENTAE"  
//		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
//				( substr("P4_DKENTAE"."KDATE",1,6) = :sYearMonth ) AND  
//				( "P4_DKENTAE"."KTCODE" = :scode )   AND
//				( "P4_DKENTAE"."KDATE" <> :sKDate) ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		lCnt = 0
//	ELSE
//		IF IsNull(lCnt) THEN lCnt =0
//	END IF
//	
//	IF lYDay - lCnt < 1 then					/*잔여일수*/
//		messagebox("확인", "월차를 사용할수 없습니다 (잔여월차 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1	
//	END IF
//END IF
//
///* 년차 확인 */
if sFlag = "2" then
	SELECT "P4_YEARLIST"."CDAY", 
			 "P4_YEARLIST"."KDATE", "P4_YEARLIST"."KDATETO"
		INTO :lYDay , :sFromDate, :sToDate 
		FROM "P4_YEARLIST"  
		WHERE ( "P4_YEARLIST"."COMPANYCODE" = :gs_company ) AND  
			   ( "P4_YEARLIST"."EMPNO" = :sempno ) AND 
				( "P4_YEARLIST"."KDATE" <= :sKDate ) AND
				( "P4_YEARLIST"."KDATETO" >= :sKDate ) and
				( "P4_YEARLIST"."YYMM" = (select max(yymm) from p4_yearlist
				                          where companycode = :gs_company and
												        empno = :sempno ));
				
	if sqlca.sqlcode <> 0 then
		messagebox("확인", "년차를 사용할수 없습니다. !! ~r(총무과에 년차생성을 의뢰하십시오.) ")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	END IF
			
	SELECT count("P4_DKENTAE"."KTCODE")  		/*사용일수*/
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( "P4_DKENTAE"."KDATE" >= :sFromDate ) AND  
				( "P4_DKENTAE"."KDATE" <= :sToDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode );
	if SQLCA.SqLCODE <> 0 THEN
		lCnt = 0
	ELSE
		IF IsNull(lCnt) THEN lCnt =0
	END IF

//	  select substr(enterdate,1,4) into :sentdate
//	  from p1_master
//	  where companycode = :gs_company and
//	        empno = :sempno;
//			  
//	if string(long(sentdate) + 1) = Left(sKDate, 4) and lYday  = 1 and lCnt = 0 then
//		messagebox("확인", "년차를 사용할수 없습니다 (1년미만자) !!")
//		return -1
//	end if
	  
	IF lYDay - lCnt < 1 then								//잔여일수
		messagebox("확인", "년차를 사용할수 없습니다 (잔여년차확인) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
END IF

/* 생리일수 체크 */
if sFlag = "3" then
	sSex = dw_2.getitemstring(iCurRow , "sex")	
	if sSex = '1' then  										//남자사원 생리사용 check
		messagebox("확인","여직원만 생리휴가 사용이 가능합니다.!!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if					
   
	SELECT count("P4_DKENTAE"."KTCODE")  					//사용일수
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( substr("P4_DKENTAE"."KDATE",1,6) = :sYearMonth ) AND  
				( "P4_DKENTAE"."KDATE" <> :sKDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode )   ;
	IF lCnt > 0  then
		messagebox("확인", "생리를 사용할수 없습니다 (이미사용) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
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

public subroutine wf_data_create (string sempno, string sdate, long stime, string lgubn);
string eData, sKTCode ,sDeptCode, sKMGubn,sAddDept,sHDayGubn,sJKGubn, sJTGubn 

long sJKTime ,sOCcnt ,sOCFromTime,sOCToTime,sJTTime, sFromTime

			

	  
SELECT "P4_PERKUNMU"."KMGUBN"
 INTO :sKMGubn 
 FROM "P4_PERKUNMU"
WHERE ( "P4_PERKUNMU"."COMPANYCODE" = :gs_company ) AND
      ( "P4_PERKUNMU"."KDATE" = :sdate ) AND
		( "P4_PERKUNMU"."EMPNO" = :sEmpno ) ;
			  
IF SQLCA.SQLCODE <> 0 THEN
   sKMGubn    = '1'
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
                  ( "COMPANYCODE", "DEPTCODE",   "EMPNO",    "KDATE",
						  "KMGUBN",      "HDAYGUBN",   "TKTIME" )  
			  VALUES ( :gs_company,   :sDeptCode,   :sEmpno,    :sdate,
			           :sKMGubn,      :sHDayGubn,   :sTime )  ;
		ELSE
			UPDATE "P4_DKENTAE"  
			   SET "TKTIME" = :sTime 
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF			 
ELSEIF lgubn= '1' THEN /* 출근시간갱신 */	
	  
		IF eData = '' OR  IsNull(eData) THEN 	
			
            INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE", "DEPTCODE",   "EMPNO",    "KDATE",
						  "KMGUBN",      "HDAYGUBN",   "CKTIME" )  
			  VALUES ( :gs_company,   :sDeptCode,   :sEmpno,    :sdate,
			           :sKMGubn,      :sHDayGubn,   :sTime )  ;
		ELSE
			 UPDATE "P4_DKENTAE"  
				 SET "KMGUBN" = :skmgubn,"HDAYGUBN" = :shdaygubn,   
			        "CKTIME" = :sTime   
		    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
      	       ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
            	 ( "P4_DKENTAE"."KDATE" = :sdate )   ;
		END IF	
		
ELSEIF lgubn= '2' THEN /* 외출(from)시간갱신 */	
		IF eData = '' OR  IsNull(eData) THEN 	
			 INSERT INTO "P4_DKENTAE"  
                  ( "COMPANYCODE", "DEPTCODE",   "EMPNO",    "KDATE", "OCCNT", 
						  "KMGUBN",      "HDAYGUBN",   "OCFROMTIME" )  
			  VALUES ( :gs_company,   :sDeptCode,   :sEmpno,    :sdate,  1,
			           :sKMGubn,      :sHDayGubn,   :sTime )  ;
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
                  ( "COMPANYCODE", "DEPTCODE",   "EMPNO",    "KDATE", "OCCNT",
						  "KMGUBN",      "HDAYGUBN",   "OCTOTIME" )  
			  VALUES ( :gs_company,   :sDeptCode,   :sEmpno,    :sdate, 1,
			           :sKMGubn,      :sHDayGubn,   :sTime )  ;
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
                  ( "COMPANYCODE", "DEPTCODE",   "EMPNO",    "KDATE", "JTGUBN"
						  "KMGUBN",      "HDAYGUBN",   "JTTIME",   "TKTIME" )  
			  VALUES ( :gs_company,   :sDeptCode,   :sEmpno,    :sdate, '1',
			           :sKMGubn,      :sHDayGubn,   :sTime,      :sTime )  ;
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

public function integer wf_fileclose ();ii_fileID = FileOpen(sprocfile, LineMode!)
FileClose(ii_fileID)


FileClose(1)


return 1
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

public function integer wf_fileread ();//string  il_Input_Data , sCode,sYymmdd, stime, sEmpno,sTimeS,sTimeE ,MaxDate , sYy
//String sabu, stag,squens,sno
//integer li_bytes, Return_Value, il_count
//
//dw_1.Accepttext()
//
//sabu = dw_1.GetitemString(1,'saup')
//
//Return_Value = FileRead( ii_fileid, il_Input_Data)
//DO WHILE Return_Value > 0
//      sEmpno  = mid(il_input_data,15,4)	  	                  /*사번*/
//		squens  = mid(il_input_data,7,1)                         /*바코드 seq*/
//		sCode   = mid(il_input_data,20,1)                        /*출퇴근구분 */
//		sYymmdd = mid(il_input_data,1,8)      					      /*일자*/		
//		stime   = mid(il_input_data,9,4)									/*시간*/
//		
////select johapno into :sno
////from p1_master
////where companycode = :gs_company and empno = :sEmpno;
//
////if IsNull(sno) or sno = '' then sno = '0'
////if sno <> squens then
////else	
//if left(stime,2) = '24' then
//   stime = '00'+right(stime,2)
//end if
//		
////'0' :출근, '1' :퇴근, '2',:외출, '3':귀사
///*'5','6','7' 코드는 조식,중식,석식 코드*/
//	CHOOSE CASE sCode
//			CASE '1'  /*퇴근*/
//					IF stime = '0000' THEN
//						sTime = '0001'
//					END IF	
//					IF sTime <= '0800' THEN    /*전일퇴근시간 */
//						SELECT MAX("P4_DKENTAE"."KDATE")  
//    					  INTO :MaxDate  
//					     FROM "P4_DKENTAE"  
//					    WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//							    ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
//					          ( "P4_DKENTAE"."KDATE" < :sYymmdd )   ;
// 						 IF SQLCA.SQLCODE <> 0 OR IsNull(MaxDate)  THEN
//							 MaxDate =  sYymmdd 	
//						 END IF
//						 wf_data_create(sEmpno, MaxDate,long(sTime), '0')	
//					ELSE	 
//						 wf_data_create(sEmpno, sYymmdd,long(sTime), '0')	 						 
//					END IF	 
//			 CASE '0'  /*출근*/
//						 wf_data_create(sEmpno, sYymmdd,long(sTime), '1')
//			 CASE '2'  /*외출*/
//						 wf_data_create(sEmpno, sYymmdd,long(sTime), '2')				
//			 CASE '3'  /*귀사*/
//						 wf_data_create(sEmpno, sYymmdd,long(sTime), '3')								
////			 CASE '4'  /*조퇴*/	
////						 wf_data_create(sEmpno, sYymmdd,long(sTime), '4')		
////end if						 
//			 		 
//END CHOOSE
//il_count = il_count + 1	
//Return_Value = FileRead( ii_fileid, il_Input_Data)
//LOOP
//
return 1

end function

protected function integer wf_insert_dkentae (double cktime, double tgtime);//string ls_kdate, ls_deptcode, sdaygbn,shday, ls_jikjong, ls_type, ls_saup, ls_kunmu
//int cnt
//
//if dw_1.accepttext() = -1 then return -1
//
//ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
//ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
//ls_jikjong = dw_1.Getitemstring(dw_1.getrow(),'jjong')
//ls_type = dw_1.Getitemstring(dw_1.getrow(),'ktype')
//ls_saup = dw_1.Getitemstring(dw_1.getrow(),'saup')
//ls_kunmu = dw_1.Getitemstring(dw_1.getrow(),'kunmu')
//
//IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'
//IF ls_jikjong = ""  OR IsNull(ls_jikjong)  THEN ls_jikjong = '%'
//IF ls_type = ""  OR IsNull(ls_type)  THEN ls_type = '%'
//IF ls_saup = ""  OR IsNull(ls_saup)  THEN ls_saup = '%'
//IF ls_kunmu = ""  OR IsNull(ls_kunmu)  THEN ls_kunmu = '%'
//
//select count(*) into :cnt
//from	 p4_dkentae a, p1_master b, p0_dept c
//where  a.companycode = :gs_company and
//		 a.companycode = b.companycode and
//		 a.companycode = c.companycode and
//		 a.empno = b.empno and
//       a.kdate = :ls_kdate and
//		 a.deptcode like :ls_deptcode and
//		 a.jikjonggubn like :ls_jikjong and
//		 b.kunmugubn like :ls_kunmu and
//		 b.deptcode = c.deptcode and
//		 c.saupcd like :ls_saup	 ;
//		
//select daygubn, hdaygubn into :sdaygbn, :shday
//from p4_calendar
//where companycode = :gs_company and
//      cldate = :ls_kdate;
//		
//
//
//if cnt > 0 then
//
////	UPDATE p4_dkentae
////		SET cktime = :cktime,
////	   	 tktime = :tgtime,
////			 kmgubn = :ls_ktype,
////			 KLGTIME = (select kltime from p0_ktype where ktype = :ls_ktype),
////			 YJGTIME = (select yjtime from p0_ktype where ktype = :ls_ktype),
////	 		 YKGTIME = (select yktime from p0_ktype where ktype = :ls_ktype),
////			 HKGTIME = (select hktime from p0_ktype where ktype = :ls_ktype),
////			 HKGTIME2 = (select hltime from p0_ktype where ktype = :ls_ktype),
////			 JCHGTIME = (select jctime from p0_ktype where ktype = :ls_ktype),
////			 LUNGTIME = (select jstime from p0_ktype where ktype = :ls_ktype),
////			 HKYJGTIME = (select hyjtime from p0_ktype where ktype = :ls_ktype)
////	WHERE  companycode = :gs_company and
////			 kdate = :ls_kdate and
////			 deptcode like :ls_deptcode and
////			 jikjonggubn like :ls_jikjong;
//
////DELETE FROM P4_DKENTAE
////		WHERE	companycode = :gs_company and
////				kdate = :ls_kdate and
////				deptcode like :ls_deptcode and
////				jikjonggubn like :ls_jikjong;
//
//
//DELETE FROM P4_DKENTAE A
//where  A.companycode = :gs_company and
//       A.kdate = :ls_kdate and
//		 A.deptcode like :ls_deptcode and
//		 A.jikjonggubn like :ls_jikjong and
//		 A.empno in (select A.empno
//						   from P4_DKENTAE A, p1_master B, p0_dept C
//						  where A.companycode = B.companycode and
//						 		  A.empno = B.empno and
//						 		  B.kunmugubn like :ls_kunmu and
//						 		  A.companycode = C.companycode and
//						 		  B.deptcode = C.deptcode and
//					   		  C.saupcd like :ls_saup) ;
//		
////messagebox("UPDATE","존재하는 자료를 수정합니다.")
////else
////messagebox("INSERT","존재하지 않는 자료를 생성합니다.")	
//end if
//
//if sdaygbn = '1' then //일요일
//   INSERT INTO "P4_DKENTAE"
//         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
//			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
//				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
// SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
// 			    	  c.cktime,       c.tktime,    b.stype   , c.kltime,		 c.yjtime,		 c.yktime,
//					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
// FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
// WHERE	a.companycode = :gs_company and
//       	a.deptcode like :ls_deptcode and
//		 	//a.servicekindcode <> '2' and
//		 	a.enterdate  <= :ls_kdate  AND
//      	(a.retiredate  >= :ls_kdate  OR
//       	a.retiredate is null OR
//       	a.retiredate = ' ') and
//			a.empno = d.empno(+) and
//         d.kdate(+) = :ls_kdate and 
//		 	a.empno = b.empno and
//		 	b.stype = c.ktype and
//			a.kunmugubn like :ls_kunmu and
//			a.jikjonggubn like :ls_jikjong and
//			a.companycode = e.companycode and
//			a.deptcode = e.deptcode and
//			e.saupcd like :ls_saup and
//			a.LEVELCODE = f.LEVELCODE AND
//			f.GUBUN <> '0';
//elseif sdaygbn <> '1' and shday <> '0' then  //공휴일
//	    INSERT INTO "P4_DKENTAE"
//         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
//			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
//				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
// SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
// 			    	  c.cktime,       c.tktime,    b.htype   , c.kltime,		 c.yjtime,		 c.yktime,
//					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
// FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
// WHERE	a.companycode = :gs_company and
//       	a.deptcode like :ls_deptcode and
//		 	//a.servicekindcode <> '2' and
//		 	a.enterdate  <= :ls_kdate  AND
//      	(a.retiredate  >= :ls_kdate  OR
//       	a.retiredate is null OR
//       	a.retiredate = ' ') and
//			a.empno = d.empno(+) and
//         d.kdate(+) = :ls_kdate and 
//		 	a.empno = b.empno and
//		 	b.htype = c.ktype and
//			a.kunmugubn like :ls_kunmu and
//			a.jikjonggubn like :ls_jikjong and
//			a.companycode = e.companycode and
//			a.deptcode = e.deptcode and
//			e.saupcd like :ls_saup and
//			a.LEVELCODE = f.LEVELCODE AND
//			f.GUBUN <> '0';
//elseif sdaygbn = '7' and shday = '0' then  //토요일
//	     INSERT INTO "P4_DKENTAE"
//         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
//			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
//				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
// SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
// 			    	  c.cktime,       c.tktime,    b.satype   , c.kltime,		 c.yjtime,		 c.yktime,
//					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
// FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
// WHERE	a.companycode = :gs_company and
//       	a.deptcode like :ls_deptcode and
//		 	//a.servicekindcode <> '2' and
//		 	a.enterdate  <= :ls_kdate  AND
//      	(a.retiredate  >= :ls_kdate  OR
//       	a.retiredate is null OR
//       	a.retiredate = ' ') and
//			a.empno = d.empno(+) and
//         d.kdate(+) = :ls_kdate and 
//		 	a.empno = b.empno and
//		 	b.satype = c.ktype and
//			a.kunmugubn like :ls_kunmu and
//			a.jikjonggubn like :ls_jikjong and
//			a.companycode = e.companycode and
//			a.deptcode = e.deptcode and
//			e.saupcd like :ls_saup and
//			a.LEVELCODE = f.LEVELCODE AND
//			f.GUBUN <> '0';
//else                                       //평일
//	      INSERT INTO "P4_DKENTAE"
//         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
//			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
//				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
// SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
// 			    	  c.cktime,       c.tktime,    b.ktype   , c.kltime,		 c.yjtime,		 c.yktime,
//					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
// FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
// WHERE	a.companycode = :gs_company and
//       	a.deptcode like :ls_deptcode and
//		 	//a.servicekindcode <> '2' and
//		 	a.enterdate  <= :ls_kdate  AND
//      	(a.retiredate  >= :ls_kdate  OR
//       	a.retiredate is null OR
//       	a.retiredate = ' ') and
//			a.empno = d.empno(+) and
//         d.kdate(+) = :ls_kdate and 
//		 	a.empno = b.empno and
//		 	b.ktype = c.ktype and
//			a.kunmugubn like :ls_kunmu and
//			a.jikjonggubn like :ls_jikjong and
//			a.companycode = e.companycode and
//			a.deptcode = e.deptcode and
//			e.saupcd like :ls_saup and
//			a.LEVELCODE = f.LEVELCODE AND
//			f.GUBUN <> '0';
//end if
//
//if sqlca.sqlcode <> 0 then
//	rollback;
//	messagebox("에러","생성실패!~r" + sqlca.sqlErrText)
//	return -1
//end if
//
//IF sqlca.SQLNRows > 0 THEN
//	int li_ref
//	li_ref = SQLCA.FUN_CREATE_HOLIKUNTAE(ls_kdate);
////	Messagebox('실행결과',string(li_ref))
//END IF
//
return 1
//
end function

public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck);String	ls_KtCode, ls_AttTime
Double	ld_Cktime, ld_Tktime, ld_col[8]

ls_KtCode	= dw_2.GetItemString(ll_row,'ktcode')
ls_AttTime	= dw_2.GetItemString(ll_row,'attendancetime')



SELECT	kltime, yjtime, yktime, hktime, hltime, jctime, jstime, hyjtime
  INTO	:ld_col[1], :ld_col[2], :ld_col[3], :ld_col[4], :ld_col[5], :ld_col[6], :ld_col[7], :ld_col[8]
  FROM 	p0_ktype
  WHERE	ktype = :ls_ktype;

IF isnull(ls_KtCode) OR trim(ls_KtCode) = '' OR ls_AttTime = '1' THEN
	dw_2.SetItem(ll_row,'KMGUBN',ls_ktype)
	dw_2.SetItem(ll_row,'CKTIME',ld_Cktime)
	dw_2.SetItem(ll_row,'TKTIME',ld_Tktime)
	dw_2.SetItem(ll_row,'KLGTIME',ld_col[1])
	dw_2.SetItem(ll_row,'YJGTIME',ld_col[2])
	dw_2.SetItem(ll_row,'YKGTIME',ld_col[3])
	dw_2.SetItem(ll_row,'HKGTIME',ld_col[4])
	dw_2.SetItem(ll_row,'HKGTIME2',ld_col[5])
	dw_2.SetItem(ll_row,'JCHGTIME',ld_col[6])
	dw_2.SetItem(ll_row,'LUNGTIME',ld_col[7])
	dw_2.SetItem(ll_row,'HKYJGTIME',ld_col[8])
	ib_any_typing = TRUE
	Return 1
ELSEIF lb_codecheck = TRUE THEN
	MessageBox('확인','시간 입력이 불가능한 근태입니다!~r~r타입을 등록하려면 먼저 근태를 삭제하세요.')
END IF

Return -1
end function

public function string wf_proceduresql ();
Int    k 
String sGetSqlSyntax,sEmpNo,sSpace,ls_kdate,ls_deptcode
Long   lSyntaxLength

dw_1.AcceptText()

sSpace = ' '
sGetSqlSyntax = 'select p1_master.empno,p1_master.jikjonggubn, p1_master.paygubn from p1_master WHERE '


dw_2.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' ('

	FOR k = 1 TO dw_2.RowCount()
		
		if dw_2.GetitemString(k,'calccheck') = 'Y' then
 		   sEmpNo = dw_2.GetItemString(k,"empno")		
   		sGetSqlSyntax = sGetSqlSyntax + ' ("P1_MASTER"."EMPNO" =' + "'"+ sEmpNo +"')"+ ' OR'
		end if	
		
	NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

//sGetSqlSyntax = sGetSqlSyntax + 'AND ("P1_MASTER"."COMPANYCODE" = ' + "'" + gs_company +"'"+")"

Return sGetSqlSynTax


end function

public function string wf_proceduresql2 ();
Int    k 
String sGetSqlSyntax,sEmpNo,sSpace,ls_kdate,ls_deptcode
Long   lSyntaxLength

dw_1.AcceptText()

sSpace = ' '
sGetSqlSyntax = 'select p1_master.empno,p1_master.jikjonggubn, p1_master.paygubn from p1_master WHERE '


dw_2.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' ('

	FOR k = 1 TO dw_2.RowCount()	
	
 		   sEmpNo = dw_2.GetItemString(k,"empno")		
   		sGetSqlSyntax = sGetSqlSyntax + ' ("P1_MASTER"."EMPNO" =' + "'"+ sEmpNo +"')"+ ' OR'
		
	NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"


Return sGetSqlSynTax


end function

public subroutine wf_reset ();String sHdayName,sDayName,snull,sabu, smessage
double sStartTime, sEndTime


dw_1.setitem(dw_1.getrow(),"kdate",gs_today)
f_daygubun(gs_today,sDayName, sHdayName)


dw_1.setitem(1,"kweek",sDayName)
dw_1.setitem(1,"kgubun",sHdayName)

f_set_saupcd(dw_1, 'saup','1')
is_saupcd = gs_saupcd
	
//// 환경변수 근태담당부서 
//Smessage = sqlca.fun_get_authority(gs_dept)
//
//if Smessage = 'ALL'  then
//	dw_1.setitem(1,'saup', sabu)
//	dw_1.modify("saup.protect= 0")
//	ls_dkdeptcode = gs_dept
//else
//	dw_1.setitem(1,'saup', sabu)
//	dw_1.modify("saup.protect= 1")
//	
//end if	

iyj = double(f_get_p0_syscnfg(6,'1')) / 100
iyk = double(f_get_p0_syscnfg(6,'2')) / 100
ihk = double(f_get_p0_syscnfg(6,'3')) / 100
ihyj = double(f_get_p0_syscnfg(6,'4')) / 100
ihyk = double(f_get_p0_syscnfg(6,'5')) / 100



w_mdi_frame.sle_msg.text =""

ib_any_typing = False
ib_detailflag = False


end subroutine

public subroutine wf_set_sqlsyntax (string sdate, string sdept);
String sGetSqlSyntax,sGbn1,sGbn2
Long   lSyntaxLength


sGetSqlSyntax = dw_2.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KDATE" = ' + "'" + sdate +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."DEPTCODE" LIKE ' + "'" + sdept +"'"+")"


dw_2.SetSQLSelect(sGetSqlSyntax)	





end subroutine

public subroutine wf_init_clear (integer ll_currow, string ls_addgubn, string ls_ktcode);String ls_null

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
	if ls_ktcode = '09' then
		dw_2.SetItem(ll_currow,"klgtime",5.37)
	else
		dw_2.SetItem(ll_currow,"klgtime",8)
	end if
ELSE
	dw_2.SetItem(ll_currow,"klgtime",0)
END IF

dw_2.SetItem(ll_currow,"yjgtime",0)
dw_2.SetItem(ll_currow,"ykgtime",0)
dw_2.SetItem(ll_currow,"hkgtime",0)
dw_2.SetItem(ll_currow,"hkyjgtime",0)
dw_2.SetItem(ll_currow,"hkgtime2",0)
dw_2.SetItem(ll_currow,"jchgtime",0)
dw_2.SetItem(ll_currow,"lungtime",0)

end subroutine

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

dw_1.insertrow(0)

f_set_saupcd(dw_1, 'saup', '1')
is_saupcd = gs_saupcd

w_mdi_frame.sle_msg.text =""

ib_any_typing=False

Wf_Reset()

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"



event ue_postopen()
end event

on w_pik1310.create
int iCurrent
call super::create
this.cb_calc=create cb_calc
this.st_2=create st_2
this.p_1=create p_1
this.cbx_1=create cbx_1
this.p_calc=create p_calc
this.dw_2=create dw_2
this.p_2=create p_2
this.gb_3=create gb_3
this.rr_1=create rr_1
this.dw_1=create dw_1
this.cb_3=create cb_3
this.ddlb_1=create ddlb_1
this.em_1=create em_1
this.dw_3=create dw_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_calc
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.p_calc
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.ddlb_1
this.Control[iCurrent+13]=this.em_1
this.Control[iCurrent+14]=this.dw_3
this.Control[iCurrent+15]=this.gb_5
end on

on w_pik1310.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_calc)
destroy(this.st_2)
destroy(this.p_1)
destroy(this.cbx_1)
destroy(this.p_calc)
destroy(this.dw_2)
destroy(this.p_2)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.cb_3)
destroy(this.ddlb_1)
destroy(this.em_1)
destroy(this.dw_3)
destroy(this.gb_5)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1310
integer x = 3886
integer y = 148
end type

event p_mod::clicked;call super::clicked;string skmgubn, sempno
int i

IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_2.RowCount() < 0 THEN RETURN


IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
SetPointer(HourGlass!)
IF dw_2.Update() <> 1 THEN
	MessageBox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

COMMIT;

//for i = 1 to dw_2.Rowcount()
//	skmgubn = dw_2.GetitemString(i,'kmgubn')
//	sEmpno  = dw_2.GetitemString(i,'empno')
//	
////	 update p1_kunmu
////	set kunmu = :skmgubn
////	where empno = :sEmpNo;
//Next
//
//if sqlca.sqlcode = 0 then
//	commit;
//else
//	rollback;
//end if

SetPointer(Arrow!)
p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

ib_any_typing = false
w_mdi_frame.sle_msg.text ="자료가 저장되었습니다!"


end event

type p_del from w_inherite_standard`p_del within w_pik1310
integer x = 4059
integer y = 148
end type

event p_del::clicked;call super::clicked;Int iSelectedRow, li_Cnt, i
string ls_kjgubn1 ,ls_kjgubn2

li_Cnt = dw_2.RowCount()
IF li_Cnt <=0 THEN RETURN

iSelectedRow = dw_2.GetRow()
IF iSelectedRow <=0 THEN
	MessageBox("확 인","삭제할 자료를 선택하십시요!!")
	Return
END IF

IF MessageBox("확 인","삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

FOR i = li_Cnt TO 1 STEP -1
	IF dw_2.IsSelected(i) THEN
		dw_2.DeleteRow(i)
	END IF
NEXT

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"

//IF dw_2.Update() <>  1 THEN
//	MessageBox("확 인","자료 삭제를 실패하였습니다!!")
//	Rollback;
//	Return
//END IF
//
//COMMIT;
//
//sle_msg.text ='자료를 삭제하였습니다!!'
//


end event

type p_inq from w_inherite_standard`p_inq within w_pik1310
integer x = 4233
integer y = 8
end type

event p_inq::clicked;call super::clicked;string   ls_kdate, ls_deptcode, ls_jikjong, ls_jikjong2, ls_jikjong3, ls_jikjong4, ls_ktype, sflag, sGbn = 'N'
string   sSaup, sKunmu, sKunmu2, sKunmu3, sKunmu4
Int       k,il_SearchRow, cnt

//ROLLBACK;
cbx_1.checked = false

dw_1.accepttext()
ls_kdate = trim(dw_1.Getitemstring(dw_1.getrow(),'kdate'))
ls_deptcode = trim(dw_1.Getitemstring(dw_1.getrow(),'deptcode'))
ls_jikjong = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong'))
ls_jikjong2 = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong2'))
ls_jikjong3 = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong3'))
ls_jikjong4 = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong4'))

ls_ktype = trim(dw_1.Getitemstring(dw_1.getrow(),'ktype'))
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))
sKunmu2 = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu2'))
sKunmu3 = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu3'))
sKunmu4 = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu4'))

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF


IF ls_deptcode = ""	OR IsNull(ls_deptcode)	THEN ls_deptcode = '%'
IF ls_ktype = ""		OR IsNull(ls_ktype)		THEN ls_ktype = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'


int ls_row, li_row
ls_row = integer(dw_2.Object.DataWindow.FirstRowOnPage)
li_row = dw_2.GetSelectedRow(0)
if li_row = 0 then li_row = ls_row

dw_2.SetRedraw(False)

il_SearchRow = dw_2.retrieve(ls_kdate, ls_deptcode, sSaup, ls_jikjong,  ls_jikjong2,  ls_jikjong3,  ls_jikjong4, sKunmu,sKunmu2,sKunmu3,sKunmu4, ls_ktype)
IF il_SearchRow = 0 then 
	w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다! " 
	dw_1.setfocus()
	dw_2.SetRedraw(True)
	return 1
END IF

w_mdi_frame.sle_msg.text ="조회완료! " 

if ls_row > 0 then
	dw_2.Scrolltorow(li_row)
	dw_2.Scrolltorow(ls_row)
	dw_2.SelectRow(0, FALSE)
   dw_2.SelectRow(li_row, TRUE)
end if

ib_any_typing = False
ib_detailflag = False

dw_2.SetRedraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pik1310
boolean visible = false
integer x = 1861
integer y = 2364
end type

type p_can from w_inherite_standard`p_can within w_pik1310
integer x = 4233
integer y = 148
end type

event p_can::clicked;call super::clicked;ROLLBACK;

ib_any_typing = False
ib_detailflag = False

dw_2.reset()
dw_1.setcolumn("kdate")
dw_1.Setfocus()

Enabled = false
PictureName = "C:\erpman\image\취소_d.gif"

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_pik1310
integer x = 4407
integer y = 148
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	CHOOSE CASE MessageBox("확인 : 종료" , &
		 "저장하지 않은 값이 있습니다. ~r~r변경사항을 저장하시겠습니까?", &
		 question!, YesNoCancel!) 
	CASE 1
		IF dw_2.Update() <> 1 THEN
			MessageBox("확 인","자료 저장을 실패하였습니다!!")
			ROLLBACK;
			Return
		ELSE
			COMMIT;
		END IF
	CASE 3
		RETURN -1
	CASE ELSE
		ROLLBACK;
	END CHOOSE

END IF
					
				
close(parent)


end event

type p_ins from w_inherite_standard`p_ins within w_pik1310
integer x = 4407
integer y = 8
end type

event p_ins::clicked;call super::clicked;String  sMsgRtn,sflag, skDate , sDeptCode, snull
Integer il_SearchRow,k

SetNull(snull)
dw_1.accepttext()
skDate     = dw_1.GetItemString(1,"kdate")
sDeptCode = dw_1.GetItemString(1,"deptcode") 

IF skDate = '' OR Isnull(skDate) THEN
	 messagebox("확인","근태일자를 입력하십시오!")
	 dw_1.SetItem(1,"kdate",snull)
	 dw_1.setcolumn("kdate")
	 return 
END IF

dw_2.insertrow(0)
dw_2.setitem(dw_2.rowcount(),"companycode", gs_company)
dw_2.setitem(dw_2.rowcount(),"kdate", skdate)
//dw_2.setitem(dw_2.rowcount(),"deptcode", sdeptcode)
dw_2.setitem(dw_2.rowcount(),"eflag", '0')
dw_2.setcolumn("empno")
dw_2.scrolltorow(dw_2.rowcount())
dw_2.setfocus()
w_mdi_frame.sle_msg.text =''

ib_any_typing = TRUE
p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"

end event

type p_search from w_inherite_standard`p_search within w_pik1310
boolean visible = false
integer x = 1682
integer y = 2364
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1310
boolean visible = false
integer x = 2039
integer y = 2364
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1310
boolean visible = false
integer x = 2217
integer y = 2364
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1310
boolean visible = false
integer x = 1417
integer y = 2360
end type

type st_window from w_inherite_standard`st_window within w_pik1310
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1310
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1310
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1310
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1310
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1310
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1310
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1310
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1310
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1310
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1310
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1310
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1310
boolean visible = false
end type

type cb_calc from commandbutton within w_pik1310
boolean visible = false
integer x = 1440
integer y = 2512
integer width = 352
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "시간계산"
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
///*** 7. 등교시간 : wf_calc_jktime																			*/
///*** 8. 휴일(특근)시간 : wf_calc_htime																		*/
///******************************************************************************************/
//
//String ls_kdate,ls_deptcode,sMasterSql,sRtnValue
//
//dw_1.AcceptText()
//ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
//ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
//IF ls_deptcode ="" OR IsNull(ls_deptcode) THEN
//	ls_deptcode ="%"
//END IF
//
//// 마감 처리된 월은 수정 불가
//string ls_flag, ls_yymm
//ls_yymm  = left(ls_kdate, 6) 
//
//SELECT "P4_MFLAG"."GUBN"  
//  INTO :ls_flag  
//  FROM "P4_MFLAG" 
//  where companycode= :gs_company and myymm = :ls_yymm ;
//if ls_flag = '1' then
//	messagebox("확인","마감이 완료된 월 입니다.!!")
//	return
//end if	
//
//sMasterSql = wf_ProcedureSql()
//
//sle_msg.text = '일근태시간 계산 중......'
//SetPointer(HourGlass!)
//
//
//sRtnValue = sqlca.sp_calculation_dkentaetime(ls_kdate,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);
//
//IF Left(sRtnValue,2) <> 'OK' then
//	MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//else
//	commit;
//END IF
//
//SetPointer(Arrow!)
//sle_msg.text ='일근태시간 계산 완료!!'
//
//
end event

type st_2 from statictext within w_pik1310
boolean visible = false
integer x = 9
integer y = 2600
integer width = 1335
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 65535
long backcolor = 12632256
boolean enabled = false
string text = "※개인별 수정시 Double Click하십시오!"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_1 from uo_picture within w_pik1310
integer x = 2971
integer y = 132
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;string sday, stext,sMasterSql,sRtnValue, ls_saup
string sflag
String ls_kdate
int i, li_ref, li_rtnValue, rowcnt
	
if dw_1.Accepttext() = -1 then return

sProcFile = dw_1.GetItemString(1,"proc_file") 
ls_saup = dw_1.GetItemString(1,"saup") 
sflag = 'N'

IF sProcFile = "" OR IsNull(sProcFile) THEN
	MessageBox("확 인","처리자료는 필수입력입니다!!")
	if messagebox("확인","근태만 생성하시겠습니까?", Question!,YesNo!) = 2 then
   	dw_1.SetColumn("proc_file")
	   dw_1.SetFocus()
	   Return -1	
	else
		sflag = 'Y'
	end if	
END IF


if sflag = 'Y' then
	dw_1.AcceptText()
	ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')

	/*장기근태자 및 휴직자 근태코드 생성*/
	DECLARE SP_HOLIKUNTAE PROCEDURE FOR SP_CREATE_HOLIKUNTAE(:ls_saup, :ls_kdate);
	EXECUTE SP_HOLIKUNTAE;
	
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
	END IF
	
else	

	sday = dw_1.getitemstring(1,'kdate')

	w_mdi_frame.sle_msg.text ='일근태 자료 생성중........!!'

	DELETE FROM P4_DKENTAE_TEXT;
	COMMIT;

	dw_3.Reset()
	dw_3.ImportFile(sProcFile,1,10000,1,10,2)

	rowcnt = dw_3.RowCount()
	FOR i = 1 TO rowcnt
		dw_3.SetItem(i,"seq",i)
	NEXT

	IF dw_3.Update() <> 1 THEN
		ROLLBACK;
		MessageBox("확 인","TEXT자료 저장 실패!!")
	ELSE
		COMMIT;
	END IF

	DECLARE fun_gen_dkentae PROCEDURE FOR fun_generate_dkentae(:gs_company,:ls_saup,:sday,'Y');
	EXECUTE fun_gen_dkentae;
	FETCH fun_gen_dkentae INTO :li_rtnValue;
	CLOSE fun_gen_dkentae;

	IF li_rtnValue <>  1 THEN
		MessageBox("확 인","근태 생성 실패!!")
		Rollback;
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.text =''
		Return
	ELSE
		Commit;
	END IF

	p_inq.Triggerevent(Clicked!)
	w_mdi_frame.sle_msg.text ='일근태 자료 생성 완료!!'
	SetPointer(HourGlass!)
	
	sMasterSql = wf_ProcedureSql2()
	
	w_mdi_frame.sle_msg.text = '일근태시간 계산 중......!!'

//	sRtnValue = sqlca.sp_calculation_dkentaetime(f_afterday(sday,-1),'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);
//	
//	IF Left(sRtnValue,2) <> 'OK' then
//		MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
//		Rollback;
//		SetPointer(Arrow!)
//		w_mdi_frame.sle_msg.text =''
//	else
//		commit;
//	END IF
	
	
	sRtnValue = sqlca.sp_calculation_dkentaetime(sday,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);
	
	IF Left(sRtnValue,2) <> 'OK' then
		MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
		Rollback;
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.text =''
	else
		commit;
	END IF

	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='일근태시간 계산 완료!!'

end if

p_inq.Triggerevent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type cbx_1 from checkbox within w_pik1310
integer x = 2011
integer y = 32
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체계산"
end type

event clicked;int i

if this.checked = true then
	For i = 1 to dw_2.Rowcount()
	    dw_2.Setitem(i,'calccheck','Y')
   Next
else
	For i = 1 to dw_2.Rowcount()
	    dw_2.Setitem(i,'calccheck','N')
   Next
end if
	

end event

type p_calc from uo_picture within w_pik1310
integer x = 3886
integer y = 8
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\계산_up.gif"
end type

event clicked;call super::clicked;int i, k
String ls_kdate,ls_saup,ls_deptcode,sMasterSql,sRtnValue
int li_ref

dw_1.AcceptText()
ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_saup = dw_1.Getitemstring(dw_1.getrow(),'saup')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
IF ls_deptcode ="" OR IsNull(ls_deptcode) THEN
	ls_deptcode ="%"
END IF


 /*장기근태자 및 휴직자 근태코드 생성*/
	DECLARE SP_HOLIKUNTAE PROCEDURE FOR SP_CREATE_HOLIKUNTAE(:ls_saup, :ls_kdate);
	EXECUTE SP_HOLIKUNTAE;
	
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
	END IF

if ib_any_typing = True then
	messagebox("확인","자료를 저장하시고 계산을 하세요!!")
	return
end if

k = 0
For i = 1 to dw_2.Rowcount()

	if dw_2.GetitemString(i,'calccheck') = 'Y' then
		k += 1
	end if	
	
Next

if k = 0 then
	messagebox("확인","계산할 사원을 체크하십시요!")
	return
end if
	



// 마감 처리된 월은 수정 불가
string ls_flag, ls_yymm
ls_yymm  = left(ls_kdate, 6) 

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = :ls_yymm ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	

sMasterSql = wf_ProcedureSql()

w_mdi_frame.sle_msg.text = '일근태시간 계산 중......'
SetPointer(HourGlass!)


sRtnValue = sqlca.sp_calculation_dkentaetime(ls_kdate,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);

IF Left(sRtnValue,2) <> 'OK' then
	MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
else
	commit;
END IF

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ='일근태시간 계산 완료!!'



p_inq.Triggerevent(Clicked!)



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

type dw_2 from u_d_select_sort within w_pik1310
event ue_key pbm_keydown
event ue_enter pbm_dwnprocessenter
event ue_pressenter pbm_dwnprocessenter
event ue_mousemove pbm_mousemove
integer x = 18
integer y = 304
integer width = 4558
integer height = 1952
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pik1310_2"
boolean border = false
boolean hsplitscroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_mousemove;long ll_pos
String dwobject
string ls_row

dwobject = dw_2.GetObjectAtPointer()
ll_pos = Pos(dwobject, "~t")
IF ll_pos > 0 THEN
ls_row = Mid(dwobject, ll_pos + 1)
END IF

IF Long(ls_row) = 0 THEN RETURN

dw_2.Modify("DataWindow.Detail.Color=~"553648127~tif ( getrow() = " + ls_row + ", rgb(255,240,240), rgb(255,255,255) )~"")

end event

event doubleclicked;call super::doubleclicked;//string ls_empno,ls_kdate, ls_parm
//
//muiltstr str_value
//
//str_value.s[1] = ''
//str_value.s[2] = ''
//
//
//ls_kdate = this.GetitemString(row, 'kdate')
//ls_empno = this.GetitemString(row,'empno')
//
//str_value.s[1] = ls_kdate
//str_value.s[2] = ls_empno
//
//OpenWithParm(w_pik1310_popup,str_value)
end event

event editchanged;ib_any_typing = True

end event

event itemchanged;
String snull, sdate, sabu, sempno, sname, sdept, sjikjong,shdaygubn, sdaygubn, &
       skmgubn, sktcode, sattendtime, sattname, sattendgbn, sattendadd, sktdate
double Calc_time		 
int lReturnRow, il_count, cnt
SetNull(snull)

w_mdi_frame.sle_msg.text =""


this.accepttext()

sDate    = this.GetItemString(1,"kdate")
sabu     = this.GetItemString(1,"saup") 
timegubn = '1'

IF this.getcolumnname() = "empno" THEN											/* 사원번호 */
	sEmpNo = this.Gettext()
	IF sEmpNo ="" OR IsNull(sEmpNo) THEN RETURN
	
	SELECT "P1_MASTER"."EMPNAME", "P1_MASTER"."DEPTCODE", "P1_MASTER"."JIKJONGGUBN" 
	   INTO :sname,  :sdept, :sJikjong
	   FROM "P1_MASTER"
	   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo)  ;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		this.SetItem(this.GetRow(),"deptcode",snull)
		Return 1
	END IF
	lReturnRow = This.Find("empno = '"+sempno+"' ", 1, This.RowCount())
	IF (this.GetRow() <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인","등록된 사원입니다.~r등록할 수 없습니다.")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		this.SetItem(this.GetRow(),"deptcode",snull)
		RETURN  1	
	ELSE
		  SELECT count("P4_DKENTAE"."EMPNO")  
    	    INTO :il_count  
	       FROM "P4_DKENTAE"  
		   WHERE ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
               ( "P4_DKENTAE"."KDATE" = :sdate )   ;
			IF il_count <> 0 THEN
				MessageBox("확인","등록된 사원입니다.~r등록할 수 없습니다.")
				this.SetItem(this.GetRow(),"empno",snull)
				this.SetItem(this.GetRow(),"empname",snull)
				this.SetItem(this.GetRow(),"deptcode",snull)
				RETURN  1	
			END IF	
	END IF
	
	SELECT "HDAYGUBN", "DAYGUBN"
    INTO :shdaygubn, :sdaygubn
    FROM "P4_CALENDAR_SAUP"
   WHERE ( "CLDATE" = :sdate ) AND
	      ( "SAUPCD" = :sabu );
	
//	SELECT "P1_KTYPE"."KTYPE"
//    INTO :skmgubn
//    FROM "P1_KTYPE"
//   WHERE ( "P1_KTYPE"."EMPNO" = :sempno ) ;	
//	
	this.SetItem(this.GetRow(),"hdaygubn",shdaygubn)
	this.SetItem(this.GetRow(),"kmgubn",skmgubn)
	this.SetItem(this.GetRow(),"empname",sname)
	this.SetItem(this.GetRow(),"deptcode",sdept)
	this.SetItem(this.GetRow(),"jikjonggubn",sJikjong)
//	wf_modify_ktype(this.GetRow(),skmgubn,TRUE)
	
	string sMaxDate ,sDeptCode, sPrtDept 
	int iMaxSeq
	
	SELECT MAX("REALORDDATEFROM")													/*최신발령일자*/
			INTO :sMaxDate
			FROM "P1_ORDERS"
			WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :sEmpNo and
					"REALORDDATEFROM" <= :sdate ;
	IF sqlca.sqlcode <> 0 then
		sMaxDate= ''
	END IF	

	SELECT MAX("P1_ORDERS"."SEQ")
     INTO :iMaxSeq
	  FROM "P1_ORDERS"  
	 WHERE ( "P1_ORDERS"."EMPNO" = :sEmpno ) AND  
			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) ;			
	IF sqlca.sqlcode <> 0 then
		iMaxSeq= 0
	END IF	

	/*소속부서,출력부서 구하기*/
	SELECT "P1_ORDERS"."DEPTCODE",   "P1_ORDERS"."PRTDEPT"  
	  INTO :sDeptCode,   			:sPrtDept  
	  FROM "P1_ORDERS"  
    WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND  
		    ( "P1_ORDERS"."EMPNO" = :sEmpNo ) AND  
			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) AND
			 ("P1_ORDERS"."SEQ" = :iMaxSeq) ;
	IF sqlca.sqlcode <> 0 then
		Messagebox("확 인","발령자료가 등록되지 않은 사원이므로 등록할 수 없습니다!!")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		Return 1
	ELSE
		this.setitem(this.GetRow(),'deptcode',sdeptcode)
		this.setitem(this.GetRow(),'p4_dkentae_prtdept',sprtdept)
	END IF	
	
	
ELSE
	sEmpNo = this.Getitemstring(this.GetRow(),'empno')
END IF	

IF this.getcolumnname() = "ktcode" THEN									/* 근태코드 */
	sKtCode = this.GetText()
	
	IF sKtCode = "" OR IsNull(sKtCode) THEN
		sAttendTime = '1'
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
//		Wf_Get_CtTime(this.GetItemString(this.GetRow(),"kmgubn"),lCkTime,lTkTime)
//		
//		this.SetItem(this.GetRow(),"cktime",lCkTime)
//		this.SetItem(this.GetRow(),"tktime",lTkTime)		
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
		wf_init_clear(this.GetRow(), sAttendAdd,sKtCode)
	END IF	
END IF

IF this.getcolumnname() = "kmgubn" THEN									/* 주야구분 */
	skmgubn = this.GetText()
	sEmpNo = this.GetitemString(this.Getrow(),'empno')
	
	select count(*) into :cnt
	from p4_perkunmu
	where kdate = :sDate and empno = :sEmpNo;
	if IsNull(cnt) then cnt = 0
	
	if cnt > 0 then
		update p4_perkunmu
		set kmgubn = :skmgubn
		where kdate = :sDate and empno = :sEmpNo;
		if sqlca.sqlcode = 0 then
			commit;
	   else		
   		rollback;
		end if	
	else
		insert into p4_perkunmu
		       ( companycode , empno , kdate , kmgubn )
		values (:gs_company, :sEmpno, :sdate, :skmgubn);
		
		if sqlca.sqlcode = 0 then
			commit;
	   else		
   		rollback;
		end if	
	end if	
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

double ld_yjtime, ld_yktime, ld_hktime, ld_hkyktime, ld_hyjgtime
if this.GetColumnName() = 'yjgtime' THEN   /*연장시간*/
	ld_yjtime = Double(Trim(this.Gettext()))
	if ld_yjtime = 0 then
		this.Setitem(this.Getrow(),'fyjgtime',0)
	else
		Calc_time = long(left(string(ld_yjtime,'00.00'),2)) * 60 + &
		                      long(right(string(ld_yjtime,'00.00'),2))
	   Calc_time = Calc_time * iyj
		Calc_time = wf_conv_hhmm(Calc_time)
		this.Setitem(this.Getrow(),'fyjgtime',Calc_time)
		
	end if		
	
end if

if this.GetColumnName() = 'ykgtime' THEN  /*야간시간*/
	ld_yktime = Double(Trim(this.Gettext()))
	if ld_yktime = 0 then
		this.Setitem(this.Getrow(),'fykgtime',0)
	else
		Calc_time = long(left(string(ld_yktime,'00.00'),2)) * 60 + &
		                      long(right(string(ld_yktime,'00.00'),2))
	   Calc_time = Calc_time * iyk
		Calc_time = wf_conv_hhmm(Calc_time)
		this.Setitem(this.Getrow(),'fykgtime',Calc_time)
		
	end if	
end if
                                                 /*휴일근로시간*/
if this.GetColumnName() = 'hkgtime' or this.GetColumnName() = 'hkgtime2' THEN
	ld_hktime = Double(Trim(this.Gettext()))
	if ld_yjtime = 0 then
		this.Setitem(this.Getrow(),'fhkgtime',0)
	else
		Calc_time = long(left(string(ld_hktime,'00.00'),2)) * 60 + &
		                      long(right(string(ld_hktime,'00.00'),2))
	   Calc_time = Calc_time * ihk
		Calc_time = wf_conv_hhmm(Calc_time)
		this.Setitem(this.Getrow(),'fhkgtime',Calc_time)
		
	end if		
	
end if

if this.GetColumnName() = 'hkcygtime' THEN   /*휴일야간시간*/
	ld_hkyktime = Double(Trim(this.Gettext()))
	if ld_yjtime = 0 then
		this.Setitem(this.Getrow(),'fhykgtime',0)
	else
		Calc_time = long(left(string(ld_hkyktime,'00.00'),2)) * 60 + &
		                      long(right(string(ld_hkyktime,'00.00'),2))
	   Calc_time = Calc_time * ihyk 
		Calc_time = wf_conv_hhmm(Calc_time)
		this.Setitem(this.Getrow(),'fhykgtime',Calc_time)
		
	end if
end if

if this.GetColumnName() = 'hkyjgtime' THEN    /*휴일연장시간*/
	ld_hyjgtime = Double(Trim(this.Gettext()))
	if ld_yjtime = 0 then
		this.Setitem(this.Getrow(),'fhyjgtime',0)
	else
		Calc_time = long(left(string(ld_hyjgtime,'00.00'),2)) * 60 + &
		                      long(right(string(ld_hyjgtime,'00.00'),2))
	   Calc_time = Calc_time * ihyj
		Calc_time = wf_conv_hhmm(Calc_time)
		this.Setitem(this.Getrow(),'fhyjgtime',Calc_time)
		
	end if
end if


ib_detailflag = True

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"
end event

event itemerror;call super::itemerror;
Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "empno"  THEN
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;//this.SetRowFocusIndicator(Hand!)

//this.SelectRow(0, FALSE)
//this.SelectRow(currentrow, TRUE)
end event

type p_2 from uo_picture within w_pik1310
integer x = 4059
integer y = 8
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;string ls_kdate, ls_deptcode

w_mdi_frame.sle_msg.text =""

if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'

if messagebox("전체삭제",string(ls_kdate,'@@@@.@@.@@')+"의 자료를 모두 삭제합니다", &
               Exclamation!, OKCancel!, 2) = 2 then return
					
delete from p4_dkentae
where companycode = :gs_company and kdate = :ls_kdate and
      empno in (select a.empno from p1_master a, p0_dept b
		          where a.deptcode = b.deptcode and
					       b.saupcd like :is_saupcd) ;

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("에러","전체삭제에 실패했습니다!")
	return
else
	commit;
	w_mdi_frame.sle_msg.text = "전체삭제 완료!"
	p_can.Enabled = false
	p_can.PictureName = "C:\erpman\image\취소_d.gif"
end if
p_inq.Triggerevent(Clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

type gb_3 from groupbox within w_pik1310
boolean visible = false
integer x = 1371
integer y = 2432
integer width = 485
integer height = 244
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_pik1310
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 300
integer width = 4581
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from u_key_enter within w_pik1310
event ue_setfilter ( long row )
event ue_key pbm_dwnkey
integer x = 46
integer y = 8
integer width = 3433
integer height = 276
integer taborder = 11
string dataobject = "d_pik1310_1"
boolean border = false
end type

event ue_setfilter(long row);String	ls_jikjong, ls_ktype, ls_saup, ls_kunmu, ls_FilterString

IF This.AcceptText() = -1 THEN return
ls_FilterString = ''

ls_jikjong	= trim(GetItemString(row, 'jjong'))
ls_ktype		= trim(GetItemString(row, 'ktype'))
ls_saup		= trim(GetItemString(row, 'saup'))
ls_kunmu		= trim(GetItemString(row, 'kunmu'))

IF IsNull(ls_jikjong) THEN ls_jikjong = ''
IF IsNull(ls_ktype)	 THEN ls_ktype = ''
IF IsNull(ls_saup)	 THEN ls_saup = ''
IF IsNull(ls_kunmu)	 THEN ls_kunmu = ''

IF ls_jikjong <> '' THEN ls_FilterString += "jikjonggubn = '"+ ls_jikjong +"'"

IF ls_ktype <> '' THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "p1_kunmu_kunmu = '"+ ls_ktype +"'"
END IF

IF ls_saup <> '' THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "saup = '"+ ls_saup +"'"
END IF

IF ls_kunmu <> ''		THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "kunmu = '"+ ls_kunmu +"'"
END IF

dw_2.SetFilter(ls_FilterString)
dw_2.Filter()

IF dw_2.RowCount() = 0 THEN
	w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다! " 
END IF
end event

event ue_key;//F1 key를 누르면 코드조회처리함	

IF KeyDown(KeyF1!) THEN
	TriggerEvent(RButtonDown!)
END IF
end event

event buttonclicking;call super::buttonclicking;integer fh, ret

blob Emp_pic
string txtname 
string defext = "TXT"
string Filter = "txt Files (*.txt), *.txt, All Files (*.*), *.*"


	ret = GetFileOpenName("Open Text", txtname, il_filename, defext, filter)
	
	IF ret = 1 THEN
      this.setitem(this.getrow(), 'proc_file', txtname)
	END IF


end event

event clicked;call super::clicked;string sdate, snull, ls_dayname, ls_hdayname, ls_saup
Long	ll_x, ll_y

ll_x = This.PointerX()
ll_y = This.PointerY()


dw_1.Accepttext()
ls_saup = this.GetitemString(1,'saup')
if ll_x >= 1175 AND ll_x <= (1175+69) AND ll_y >= 20 AND ll_y <= (20+64) THEN
	sdate = dw_1.GetitemString(1,'kdate')	
	sdate = f_afterday(sdate,-1)
	if f_daygubun_saupcd(sdate,ls_saup,ls_dayname, ls_hdayname) = -1 then
			messagebox("확인","달력일자와 요일명 및 휴무명 참조테이블을 확인하십시오!")
			this.SetItem(1,"kdate",snull)
			this.setcolumn("kdate")
			return 1
		else
		
			this.setitem(1,"kweek",ls_dayname)
			this.setitem(1,"kgubun",ls_hdayname)
		end if
	dw_1.Setitem(1,'kdate',sdate)
	
	p_inq.Triggerevent(Clicked!)	
elseif ll_x >= 1339 AND ll_x <= (1339+69) AND ll_y >= 20 AND ll_y <= (20+64) THEN
	sdate = dw_1.GetitemString(1,'kdate')	
	sdate = f_afterday(sdate,1)
	if f_daygubun_saupcd(sdate,ls_saup,ls_dayname, ls_hdayname) = -1 then
			messagebox("확인","달력일자와 요일명 및 휴무명 참조테이블을 확인하십시오!")
			this.SetItem(1,"kdate",snull)
			this.setcolumn("kdate")
			return 1
	else
	
		this.setitem(1,"kweek",ls_dayname)
		this.setitem(1,"kgubun",ls_hdayname)
	end if
	dw_1.Setitem(1,'kdate',sdate)
  
	p_inq.Triggerevent(Clicked!)	
end if

end event

event itemchanged;call super::itemchanged;String	ls_kdate, ls_deptcode, ls_dept, ls_dayname, ls_hdayname,snull, ls_saup

w_mdi_frame.sle_msg.text =""

SetNull(snull)

this.Accepttext()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kdate" THEN
	ls_kdate = this.GetText()
	
	IF ls_kdate ="" OR IsNull(ls_kdate) THEN 
	
		this.setitem(this.getrow(),"kweek",snull)
		Return
	END IF
	is_today = ls_kdate
	if F_datechk(ls_kdate) = -1 then
		 messagebox("확인","근태일자를 확인하십시오!")
		 this.SetItem(1,"kdate",snull)
		 this.setcolumn("kdate")
		 return 1
	else
		if f_daygubun_saupcd(ls_kdate,is_saupcd,ls_dayname, ls_hdayname) = -1 then
			messagebox("확인","달력일자와 요일명 및 휴무명 참조테이블을 확인하십시오!")
			this.SetItem(1,"kdate",snull)
			this.setcolumn("kdate")
			return 1
		else
		
			this.setitem(1,"kweek",ls_dayname)
			dw_1.setitem(1,"kgubun",ls_hdayname)
		end if
	end if
	p_inq.TriggerEvent(Clicked!)
	
END IF

IF this.GetColumnName() = 'deptcode' THEN
	ls_deptcode = this.GetText()
	
	IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN
		p_inq.TriggerEvent(Clicked!)
		return
	END IF
	
	//부서코드 검사
	SELECT "P0_DEPT"."DEPTCODE"  
		 INTO :ls_dept  
		 FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
	if sqlca.sqlcode <> 0 then
		messagebox("확인","부서코드를 확인하십시오!")
		this.SetItem(1,"deptcode",snull)
		this.setcolumn("deptcode")
		return 1
	end if
	p_inq.TriggerEvent(Clicked!)
END IF

if GetColumnName() = 'saup' then
	is_saupcd = this.GetText()
	ls_kdate = this.GetitemString(1,'kdate')
	if f_daygubun_saupcd(ls_kdate,is_saupcd,ls_dayname, ls_hdayname) = -1 then
			messagebox("확인","달력일자와 요일명 및 휴무명 참조테이블을 확인하십시오!")
			this.SetItem(1,"kdate",snull)
			this.setcolumn("kdate")
			return 1
		else
		
			this.setitem(1,"kweek",ls_dayname)
			this.setitem(1,"kgubun",ls_hdayname)
		end if
//	Event ue_setfilter(row)
  p_inq.TriggerEvent(Clicked!)
end if
//IF GetColumnName() = 'jjong' or GetColumnName() = 'ktype' or &
//	GetColumnName() = 'kunmu' THEN
//	Event ue_setfilter(row)
//END IF

if GetColumnName() = 'empname' then
   int rownum
	if object.gijun[1] = '1' then
		rownum = dw_2.find("empname = '" + GetText() + "'", 1, dw_2.rowcount())	
	else
		rownum = dw_2.find("empno = '" + GetText() + "'", 1, dw_2.rowcount())
	end if
	
	if rownum > 0 then
		dw_2.setredraw(false)
		
		dw_2.SelectRow(0,False)
		dw_2.SelectRow(rownum,True)
			
		dw_2.ScrollToRow(rownum)
		
		dw_2.setredraw(true)		
	end if
	
end if


end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() = "deptcode"  THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

type cb_3 from commandbutton within w_pik1310
integer x = 3173
integer y = 168
integer width = 265
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "입력"
end type

event clicked;int i, li_cktime, li_tktime
string ls_gubun, snull
SetNull(snull)

dw_1.Accepttext()

ls_gubun = dw_1.GetitemString(1,'ktcode')

if IsNull(ls_gubun) or ls_gubun = '' then 
	ls_gubun = snull
end if

FOR i = 1 to dw_2.rowcount()
	if dw_2.GetitemString(i,'calccheck') = 'Y' then
	   dw_2.SetItem(i, 'ktcode', ls_gubun)	 
   end if 
NEXT


end event

type ddlb_1 from dropdownlistbox within w_pik1310
integer x = 3511
integer y = 80
integer width = 347
integer height = 300
integer taborder = 170
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"출근시각","퇴근시각","근로시간","연장시간","야간시간","휴일근로","휴일연장","휴일야간"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;em_1.TriggerEvent(modified!)
end event

type em_1 from editmask within w_pik1310
integer x = 3511
integer y = 172
integer width = 242
integer height = 84
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
end type

event modified;int i

if ddlb_1.text = '' or dw_2.rowcount() <= 0 then
	return
end if

if ddlb_1.text = '출근시각' then
	for i = 1 to dw_2.rowcount()
		 dw_2.setitem(i,'cktime',double(em_1.text))		 
	next
elseif ddlb_1.text = '퇴근시각' then
	for i = 1 to dw_2.rowcount()
		 dw_2.setitem(i,'tktime',double(em_1.text))		 
	next	
elseif ddlb_1.text = '근로시간' then
	for i = 1 to dw_2.rowcount()
		 dw_2.setitem(i,'klgtime',double(em_1.text))		 
	next
elseif ddlb_1.text = '연장시간' then
	for i = 1 to dw_2.rowcount()
       dw_2.setitem(i,'yjgtime',double(em_1.text))		 
	next
elseif ddlb_1.text = '야간시간' then
	for i = 1 to dw_2.rowcount()
       dw_2.setitem(i,'ykgtime',double(em_1.text))		 
	next
elseif ddlb_1.text = '휴일근로' then	
   for i = 1 to dw_2.rowcount()
       dw_2.setitem(i,'hkgtime',double(em_1.text))		 
	next
elseif ddlb_1.text = '휴일연장' then	
   for i = 1 to dw_2.rowcount()
       dw_2.setitem(i,'hkyjgtime',double(em_1.text))		 
	next
elseif ddlb_1.text = '휴일야간' then	
   for i = 1 to dw_2.rowcount()
       dw_2.setitem(i,'hkcygtime',double(em_1.text))		 
	next	
end if	
end event

type dw_3 from datawindow within w_pik1310
boolean visible = false
integer x = 859
integer y = 456
integer width = 635
integer height = 428
integer taborder = 170
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_pik1310_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type gb_5 from groupbox within w_pik1310
integer x = 3493
integer y = 8
integer width = 389
integer height = 272
integer taborder = 31
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "일괄시간입력"
end type

