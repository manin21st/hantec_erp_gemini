$PBExportHeader$w_kifa15.srw
$PBExportComments$자동전표 관리 : NEGO
forward
global type w_kifa15 from w_inherite
end type
type gb_1 from groupbox within w_kifa15
end type
type rb_1 from radiobutton within w_kifa15
end type
type rb_2 from radiobutton within w_kifa15
end type
type dw_junpoy from datawindow within w_kifa15
end type
type dw_sungin from datawindow within w_kifa15
end type
type dw_print from datawindow within w_kifa15
end type
type dw_group_detail from datawindow within w_kifa15
end type
type dw_sang from datawindow within w_kifa15
end type
type dw_detail from datawindow within w_kifa15
end type
type dw_ip from u_key_enter within w_kifa15
end type
type dw_ipgum from datawindow within w_kifa15
end type
type rr_1 from roundrectangle within w_kifa15
end type
type cbx_all from checkbox within w_kifa15
end type
type dw_rtv from datawindow within w_kifa15
end type
type dw_delete from datawindow within w_kifa15
end type
end forward

global type w_kifa15 from w_inherite
integer height = 2420
string title = "NEGO전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_group_detail dw_group_detail
dw_sang dw_sang
dw_detail dw_detail
dw_ip dw_ip
dw_ipgum dw_ipgum
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa15 w_kifa15

type variables

String     sUpmuGbn = 'N',LsAutoSungGbn

end variables

forward prototypes
public subroutine wf_calculation_chaik (integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik)
public function integer wf_delete_kfz12ot0 ()
public function double wf_get_rate (string sbasedate, string scurr)
public function integer wf_insert_dae (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik)
public function integer wf_insert_kfz12ot0 (string ssaupj)
public function integer wf_insert_sang (integer irow, string sngno, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
end prototypes

public subroutine wf_calculation_chaik (integer icurrow, string sngno, integer iweight, ref double dchason, ref double dchaik);/************************************************************************/
/**           					외환차손/익 결정  	            			  **/
/*  A = SUM((KIF08OT0의 WRATE - KIF08OT1의 CIWRATE) * KIF08OT1의 UAMT) **/
/*  IF A > 0 THEN 외환차익 RETURN '1'											  **/
/*  ELSEIF A < 0 THEN 외환차익 RETURN '0'										  **/
/*  ELSE                       RETURN '-1' 									  **/
/************************************************************************/
Double  dWrate,dCiwRate,dUamt,dRate2,dIpGum,dBiYong,dMaiChul,dSunSuAmt
Integer iCount,k

iCount = dw_detail.Retrieve(sNgno,iweight,dw_rtv.GetItemString(icurrow,"icurr"),'')
IF iCount <=0 THEN 
	dchason = 0
	dchaik = 0	
	Return	
ELSE
	dMaiChul = dw_detail.GetItemNumber(1,"maichul")
	IF IsNull(dMaiChul) THEN dMaiChul = 0
END IF

IF dw_Ipgum.RowCount() <=0 THEN
	dIpGum = 0
ELSE
	dIpGum = dw_ipgum.GetItemNumber(1,"total_ipgum")	
	IF IsNull(dIpGum) THEN dIpGum = 0
END IF

IF dw_group_detail.RowCount() <=0 THEN
	dBiYong = 0
ELSE
	dBiYong = dw_group_detail.GetItemNumber(1,"sumconsamt")	
	IF IsNull(dBiYong) THEN dBiYong = 0
END IF

dSunSuAmt = dw_rtv.GetItemNumber(icurrow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

dWrate   = dw_rtv.GetItemNumber(icurrow,"wrate")
IF IsNull(dWrate) THEN dWrate = 0

IF dMaiChul + dSunSuAmt > dIpGum + dBiYong THEN							/*외상매출 > 입금 + 비용=외환차손*/
	dChaSon = dChaSon + ((dMaiChul + dSunSuAmt) - (dIpGum + dBiYong))
ELSEIF dMaiChul + dSunSuAmt < dIpGum + dBiYong THEN							/*외상매출 < 입금 + 비용=외환차익*/
	dChaIk  = dChaIk + ((dIpGum + dBiYong) - (dMaiChul + dSunSuAmt))
END IF

//FOR k = 1 TO iCount
//	dRate2   = dw_detail.GetItemNumber(k,"drate2")
//	dCiwRate = dw_detail.GetItemNumber(k,"ciwrate")
//	IF IsNull(dRate2) THEN dRate2 = 0
//	IF IsNull(dCiwRate) THEN dCiwRate = 0
//	
//	dUamt    = dw_detail.GetItemNumber(k,"uamt")
//	IF IsNull(dUamt) THEN dUamt = 0
//	
//NEXT



end subroutine

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		END IF

		DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
		/*nego자료 전표 발행 취소*/
		UPDATE "KIF08OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null
		WHERE ( "KIF08OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF08OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF08OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF08OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[NEGO자료]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
//	FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
//         ( "SYSCNFG"."LINENO" = '1' )   ;
//IF SQLCA.SQLCODE <> 0 THEN 
//	sJipFlag = 'N'
//ELSE
//	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
//END IF
//
//IF sJipFlag = 'Y' THEN
//	sJipFrom = dw_delete.GetItemString(1,"min_ym")
//	sJipTo   = dw_delete.GetItemString(1,"max_ym")
//	
//	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//전사로 집계('00'월)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function double wf_get_rate (string sbasedate, string scurr);Double  dRate = 0
String  sMaxDate

SELECT MAX("KFZ34OT1"."CLOSING_DATE")  
	INTO :sMaxDate  
   FROM "KFZ34OT1"  
   WHERE ( "KFZ34OT1"."Y_CURR" = :sCurr ) AND ( NVL("KFZ34OT1"."Y_RATE",0) <> 0 );
IF SQLCA.SQLCODE <> 0 THEN
	sMaxDate = '00000000'
ELSE
	IF IsNull(sMaxDate) THEN sMaxDate = '00000000'
END IF

IF sMaxDate = '00000000' THEN
	dRate = 0
ELSE
	IF sMaxDate >= sBaseDate THEN
		SELECT "KFZ34OT1"."Y_RATE"  
    		INTO :dRate  
    		FROM "KFZ34OT1"  
   		WHERE ( "KFZ34OT1"."CLOSING_DATE" = :sMaxDate ) AND ( "KFZ34OT1"."Y_CURR" = :sCurr ) ;
		IF SQLCA.SQLCODE <> 0 THEN
			dRate = 0
		ELSE
			IF IsNull(dRate) THEN dRate = 0
		END IF
	ELSE
		dRate = 0
	END IF
END IF

Return dRate
end function

public function integer wf_insert_dae (integer irow, string sngno, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik);/********************************************************************************/
/** 외환차손/익 생성 및 대변 전표 생성	  	     					       			    **/
/*  1. 외환차손/익 생성																			 **/
/*     A = SUM((KIF08OT0의 WRATE - KIF08OT1의 CIWRATE) * KIF08OT1의 UAMT) 		 **/
/*     IF A > 0 THEN 외환차익 																 **/
/*     ELSEIF A < 0 THEN 외환차손 							  								 **/
/*  2. 대변 전표 생성(외화외상매출금)														 **/
/*  3. 대변 전표 생성(선수금(수출)):선수금액 <> 0										 **/
/********************************************************************************/
Double  dWrate,dCiwRate,dUamt,dAmount = 0,dMaiChulAmt,dSunSuAmt,dCurMaichul
Integer iCount,iCurRow,k
String  sAcc_ChaSon,sDcGbn,sAcc1_Dae,sAcc2_Dae,sChaDae,sYesanGbn,sSangGbn,sAccDcr,&
        sAcc1_SonIk,sAcc2_SonIk,sSonIkGbn,sRemark1
Double  dTmpSonIk = 0,dTotalSonIk,dInsAmount = 0

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*외환차익/손*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;

dWrate   = dw_rtv.GetItemNumber(irow,"wrate")
IF IsNull(dWrate) THEN dWrate = 0

IF dChaSon <> 0 OR dChaIk <> 0 THEN
	IF dChaSon <> 0 THEN										/*외환차손*/
		sSonIkGbn = '1';			sDcGbn = '1';
		
		dTotalSonIk = dChaSon
		
		sAcc1_SonIk = Mid(sAcc_ChaSon,8,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,13,2)
	ELSEIF dChaIk <> 0 THEN									/*외환차익*/	
		sSonIkGbn = '2';			sDcGbn = '2';
	
		dTotalSonIk = dChaIk
		
		sAcc1_SonIk = Left(sAcc_ChaSon,5)
		sAcc2_SonIk = Mid(sAcc_ChaSon,6,2)
	END IF
			

		SELECT "DC_GU",	"YESAN_GU",	"REMARK1"   INTO :sChaDae,	:sYesanGbn,	:sRemark1
			FROM "KFZ01OM0"  
			WHERE ( "ACC1_CD" = :sAcc1_SonIk) AND ( "ACC2_CD" = :sAcc2_SonIk);

		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
							
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_SonIk)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_SonIk)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dTotalSonIk)	
		dw_junpoy.SetItem(iCurRow,"descr",   '환 차' )	
		
		IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN		
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
		END IF			
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))
//		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(k,"chai_uamt"))
//		
//		dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"chai_rate"))
		
	//	dw_junpoy.SetItem(iCurRow,"k_qty",   dw_rtv.GetItemNumber(iRow,"svwrate"))
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(iRow,"exdept_cd"))
		END IF
				
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		lLinNo = lLinNo + 1		
//		
//		dTmpSonIk = dTmpSonIk + dAmount
//	NEXT
END IF

sDcGbn = '2'											/*대변 전표-외화외상매출금*/

dMaiChulAmt = dw_rtv.GetItemNumber(iRow,"wuihaw_maichul")
IF IsNull(dMaiChulAmt) THEN dMaiChulAmt = 0

IF dMaiChulAmt <> 0 THEN
	
	iCount = dw_detail.Retrieve(sNgno,dw_rtv.GetItemNumber(iRow,"weight"),dw_rtv.GetItemString(irow,"icurr"),'')
	IF iCount <=0 THEN 
		F_MessageChk(14,'[NEGO 상세]')
		Return -1
	END IF

	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU",				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1  
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '25' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
	dw_sang.Reset()
	
//	FOR k = 1 TO iCount
//		dCurMaichul = dw_detail.GetItemNumber(k,'calc_wonamt')
		dCurMaichul = dw_detail.GetItemNumber(1,'maichul')
		IF IsNull(dCurMaichul) THEN dCurMaichul = 0
		
		iCurRow = dw_junpoy.InsertRow(0)
			
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
		dw_junpoy.SetItem(iCurRow,"amt",     dCurMaichul)
		dw_junpoy.SetItem(iCurRow,"descr",   '외화외상매출금 상계' + dw_rtv.GetItemString(iRow,"explcno") + '(' + &
														 dw_rtv.GetItemString(iRow,"curr") + ')')	
		IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN				
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
		END IF
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
			
		IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
			IF Wf_Insert_Sang(iRow,sNgNo,dw_rtv.GetItemString(iRow,"cvcod"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo) > 0 THEN							
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*반제 처리*/
			ELSE
				Return -1
			END IF
		ELSE
			dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*반제 처리 안함*/
		END IF
		
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))		
		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(1,"sum_uamt"))
		
//		if dw_detail.GetItemNumber(k,"drate2") = 0 OR IsNull(dw_detail.GetItemNumber(k,"drate2")) then
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"ciwrate"))
//		else
//			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(k,"drate2"))
//		end if
		dw_junpoy.SetItem(iCurRow,"k_qty",  	dw_rtv.GetItemNumber(iRow,"wrate"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
		lLinNo = lLinNo + 1	
//	NEXT
END IF

/*대변 전표 - 선수금*/
dSunSuAmt = dw_rtv.GetItemNumber(iRow,"wsunsuamt")
IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

IF dSunSuAmt <> 0 THEN
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU" ,				 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Dae,							 :sAcc2_Dae,
			  :sSangGbn,							 :sAccDcr,					:sRemark1 
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '62' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;
				
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"exdept_cd"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
	dw_junpoy.SetItem(iCurRow,"amt",     dSunSuAmt)
	dw_junpoy.SetItem(iCurRow,"descr",   '선수금 발생' + dw_rtv.GetItemString(iRow,"explcno"))	
	
	IF sRemark1 = 'Y' AND sDcGbn = sAccDcr THEN			
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF
	
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
		
	IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
//		IF Wf_Insert_Sang(dw_rtv.GetItemString(iRow,"sabu"),	&
//								dw_rtv.GetItemString(iRow,"ngno"),&
//								dw_rtv.GetItemNumber(iRow,"weight"),&									
//								sSaupj,		sBalDate,	sUpmuGbn,	lJunNo,	lLinNo) > 0 THEN							
//			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*반제 처리*/
//		ELSE
//			Return -1
//		END IF
	ELSE
		dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*반제 처리 안함*/
	END IF
	
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))		
	dw_junpoy.SetItem(iCurRow,"y_amt",   dw_rtv.GetItemNumber(iRow,"usunsuamt"))
	dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(iRow,"wrate"))
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
	lLinNo = lLinNo + 1	
END IF

Return 1


end function

public function integer wf_insert_kfz12ot0 (string ssaupj);/******************************************************************************************/
/* NEGO자료를 자동으로 전표 처리한다.																		*/
/* 1. 차변 : 1.외화예금(당좌예금)으로 발생(두 개 이상)												*/
/*             계정 - 입금계좌코드의 계정과목															*/
/*             금액 - 입금액																			 		*/
/*           2.수출제비용으로 발생.(건별로 발생)														*/
/*             계정 - KIF08OT2의 COSTCD로 참조코드('65')의 참조명(S)의 7자리					*/
/*             금액 - KIF08OT2의 COSTAMT의 합															*/
/*           3.외환차손으로 발생.(외상매출금액 > 입금액 + 수출비용)					 			*/															
/*             계정 - 환경파일의 A-1-16의 8에서 7자리													*/
/*             금액 - ((KIF08OT0의 WRATE - KIF08OT1의 CIWRATE) * KIF08OT1의 UAMT) 합(C)	*/
/* 2. 대변 : 1.외화외상매출금 계정으로 발생.(환경파일의 A-1-25)									*/
/*             금액 - KIF08OT1의 (UAMT * CIWRATE)의 합												*/
/*             반제 처리 - 																					*/
/*           2.외환차익으로 발생.(계산결과(C)가 0보다 크면)											*/
/*             계정 - 환경파일의 A-1-16의 1에서 7자리													*/
/*             금액 - ((KIF08OT0의 WRATE - KIF08OT1의 CIWRATE) * KIF08OT1의 UAMT) 합(C)	*/
/*           3.선수금(수출) 계정으로 발생(환경파일의 A-1-62)									   */
/*             금액 - KIF08OT0의 선수금액(SUNSUAMT)													*/
/*             계정 - 환경파일의 A-1-62																	*/
/******************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sDcGbn,sAcCode,sDepot,sNgNo,sWuiChaGbn,sYesanGbn,sChaDae,&
			sDepotNo,sBalDate,sAcc_ChaSon,sICurr,sRemark1
Integer  k,iCnt,i,lLinNo,iCurRow,iDetailCnt,iMaiChulCnt,iWeight,iIpGumCnt
Long     lJunNo
Double   dAmount,dMaiChul,dWuiChaSonAmt = 0, dWuiChaIkamt = 0

w_mdi_frame.sle_msg.text =""

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*외환차익/손*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[외환차손/익 계정]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="NEGO 자동전표 처리 중 ..."

dw_rtv.AcceptText()

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_junpoy.Reset()
		dw_sungin.Reset()

		sBalDate = dw_rtv.GetItemString(k,"ngdt")
		sNgNo    = dw_rtv.GetItemString(k,"ngno")								/*nego번호*/
		sICurr   = dw_rtv.GetItemString(k,"icurr")
		
		dMaiChul = dw_rtv.GetItemNumber(k,"wuihaw_maichul")							
		IF IsNull(dMaiChul) THEN dMaiChul = 0
		
		iWeight  = dw_rtv.GetItemNumber(k,"weight")
		IF IsNull(iWeight) THEN iWeight = 1
		
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(28,'[발행일자]')
			Continue
		END IF
		
		iMaiChulCnt = dw_detail.Retrieve(sNgno,iWeight,sICurr,'')						/*nego상세*/
			
		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		iIpGumCnt = dw_ipgum.Retrieve(sNgNo)
		FOR i = 1 TO iIpGumCnt
			sDepot  = dw_ipgum.GetItemString(i,"dptno")										/*입금계좌코드*/
			IF sDepot = '' OR IsNull(sDepot) THEN Continue
			
			SELECT "ACC1_CD", 	"ACC2_CD",		"AB_NO"		/*차변계정*/
				INTO :sAcc1_Cha,  :sAcc2_Cha,		:sDepotNo
				FROM "KFM04OT0"  
				WHERE "KFM04OT0"."AB_DPNO" = :sDepot   ;
			
			sDcGbn = '1'											/*차변 전표-예금*/
			
			SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
				FROM "KFZ01OM0"  
				WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
							
			dAmount = dw_ipgum.GetItemNumber(i,"wonamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
			dw_junpoy.SetItem(iCurRow,"descr",   '입금')	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN			
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			END IF
			dw_junpoy.SetItem(iCurRow,"saup_no", sDepot)
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_ipgum.GetItemString(i,"dptname"))
			dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo)
			
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"icurr"))
			dw_junpoy.SetItem(iCurRow,"y_amt",   dw_ipgum.GetItemNumber(i,"foramt"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_ipgum.GetItemNumber(1,"svwrate"))
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
			END IF
				
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1
		NEXT
		
		iDetailCnt = dw_group_detail.Retrieve(sNgNo)						/*수출제비용*/
		IF iDetailCnt > 0 THEN
			FOR i = 1 TO iDetailCnt
				
				sDcGbn = '1'	
				
				dAmount   = dw_group_detail.GetItemNumber(i,"costamt")
				IF IsNull(dAmount) OR dAmount = 0 THEN Continue
				
				sAcc1_Cha = Left(dw_group_detail.GetItemString(i,"reffpf_rfna2"),5)
				sAcc2_Cha = Mid(dw_group_detail.GetItemString(i,"reffpf_rfna2"),6,2)
				
				SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      
					INTO :sChaDae,	:sYesanGbn,	:sRemark1
					FROM "KFZ01OM0"  
					WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);
			
				iCurRow = dw_junpoy.InsertRow(0)
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
				dw_junpoy.SetItem(iCurRow,"descr",   dw_group_detail.GetItemString(i,"reffpf_rfna1") + &
																 dw_rtv.GetItemString(k,"explcno") + '(' + &
																 String(dw_group_detail.GetItemNumber(i,"costforamt"),'###,###,###,##0.00') + ')')	
																 
				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				END IF
				
				dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"curr"))
				dw_junpoy.SetItem(iCurRow,"y_amt",   dw_group_detail.GetItemNumber(i,"costforamt"))
				dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"wrate"))
		
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"exdept_cd"))
				END IF
		
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		Wf_Calculation_ChaIk(k,sNgNo,iWeight,dWuiChaSonAmt,dWuiChaIkamt)			/*외환차손/익*/
		
		/*외환차손/익 발생 및 대변전표 발생*/
		IF Wf_Insert_Dae(k,sNgNo,sSaupj,sBalDate,lJunNo,lLinNo,dWuiChaSonAmt,dWuiChaIkamt) = -1 then 
			Return -1
		END IF
		dWuiChaSonAmt = 0; 		dWuiChaIkamt = 0;
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[반제결과]')
				SetPointer(Arrow!)
				Return -1		
			END IF
			
			dw_rtv.SetItem(k,"saupj",   sSaupj)
			dw_rtv.SetItem(k,"bal_date",sBalDate)
			dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
			dw_rtv.SetItem(k,"bjun_no", lJunNo)
			
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
//					Return -1
				END IF	
				dw_rtv.SetItem(k,"acc_date",dw_sungin.GetItemString(1,"acc_date"))
				dw_rtv.SetItem(k,"jun_no",  dw_sungin.GetItemNumber(1,"jun_no"))
				dw_rtv.SetItem(k,"alc_gu",  'Y')
			END IF
		END IF
	END IF
NEXT
			
IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[NEGO자료]')
	SetPointer(Arrow!)	
	RETURN -1
END IF
COMMIT;

w_mdi_frame.sle_msg.text ="NEGO 전표 처리 완료!!"

Return 1
end function

public function integer wf_insert_sang (integer irow, string sngno, string ssaupno, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iInsertRow,iLinNoS
Double  dAmount,dAmountY
String  sCiNo,sAcc1,sAcc2,sDcGbn,sSaupjS,sAccDateS,sUpmuS,sBalDateS,sCrossNo
Long    lJunNoS,lBJunNoS

//dw_sang.Reset()

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),"KFZ01OM0"."DC_GU"
	INTO :sAcc1,								 :sAcc2,									 :sDcGbn
	FROM "SYSCNFG", "KFZ01OM0"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			( "SYSCNFG"."LINENO" = '25' ) AND
			(SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD") AND
			(SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD") ;
			
sCiNo   = dw_detail.GetItemString(iRow,"cino")
//dAmount = dw_detail.GetItemNumber(iRow,"calc_wonamt")
//IF IsNull(dAmount) THEN dAmount = 0
	
//SELECT "KFZ10OT0"."SAUPJ",            "KFZ10OT0"."ACC_DATE",      "KFZ10OT0"."UPMU_GU",   
//       "KFZ10OT0"."JUN_NO",           "KFZ10OT0"."LIN_NO",        "KFZ10OT0"."BAL_DATE",   
//       "KFZ10OT0"."BJUN_NO"  
//	INTO :sSaupjS,   						  :sAccDateS,   			      :sUpmuS,   
//   	  :lJunNoS,   				        :iLinNoS,							:sBalDateS,   
//     	  :lBJunNoS  
//	FROM "KIF05OT0",            "KFZ10OT0"  
//	WHERE ( "KIF05OT0"."SABU"   = '1' ) AND  
//     	   ( "KIF05OT0"."CINO"     = :sCiNo ) AND  
//			( "KIF05OT0"."SAUPJ"    = "KFZ10OT0"."SAUPJ" ) and  
//         ( "KIF05OT0"."BAL_DATE" = "KFZ10OT0"."BAL_DATE" ) and  
//     	   ( "KIF05OT0"."UPMU_GU"  = "KFZ10OT0"."UPMU_GU" ) and  
//        	( "KIF05OT0"."BJUN_NO"  = "KFZ10OT0"."BJUN_NO" ) and    
//        	( "KIF05OT0"."ALC_GU"(+)   = 'Y' ) AND  
//	      ( "KFZ10OT0"."ACC1_CD"  = :sAcc1  ) AND  
//         ( "KFZ10OT0"."ACC2_CD"  = :sAcc2 ) AND  
//     	   ( "KFZ10OT0"."DCR_GU"   = :sDcGbn ) ;
//IF SQLCA.SQLCODE <> 0 THEN
//	F_MessageChk(16,'[반제발생자료 없슴]')
//	Return -1
//END IF

DECLARE Cursor_BanJe CURSOR FOR  
	SELECT distinct "KIF08OT3"."CROSSNO",     NVL("KIF08OT3"."AMOUNT",0),      NVL("KIF08OT3"."AMOUNTY",0)  
		FROM "KIF08OT1",   "KIF08OT3"  
   	WHERE ( "KIF08OT1"."SABU" = "KIF08OT3"."SABU" ) and  
      	   ( "KIF08OT1"."NGNO" = "KIF08OT3"."NGNO" ) and 
         	( ( "KIF08OT1"."SABU" = '1' ) AND  ( "KIF08OT1"."NGNO" = :sNgNo ) AND  
         	( "KIF08OT1"."CINO" = :sCiNo ) AND ( "KIF08OT3"."ACCODE" = :sAcc1||:sAcc2 ) AND  
         	( "KIF08OT3"."SAUPNO" = :sSaupNo ) )   ;
				
Open Cursor_BanJe;
Do While True
	Fetch Cursor_BanJe INTO :sCrossNo,		:dAmount,					:dAmountY;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	sSaupjS   = Left(sCrossNo,2)
	sAccDateS = Mid(sCrossNo,3,8)
	sUpmuS    = Mid(sCrossNo,11,1)
	lJunNoS   = Long(Mid(sCrossNo,12,4))
	iLinNoS   = Integer(Mid(sCrossNo,16,3)) 
	sBalDateS = Mid(sCrossNo,19,8)
	lBJunNoS  = Long(Mid(sCrossNo,27,4)) 
	
	iInsertRow = dw_sang.InsertRow(0)
	
	dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
	dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
	dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuS)
	dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
	dw_sang.SetItem(iInsertRow,"lin_no",   iLinNoS)
	dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
	dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
		
	dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
	dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
	dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
	dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
	dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
	dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)
	dw_sang.SetItem(iInsertRow,"y_amt_s",  dAmountY)
Loop
Close Cursor_BanJe;

Return 1


end function

on w_kifa15.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_group_detail=create dw_group_detail
this.dw_sang=create dw_sang
this.dw_detail=create dw_detail
this.dw_ip=create dw_ip
this.dw_ipgum=create dw_ipgum
this.rr_1=create rr_1
this.cbx_all=create cbx_all
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_sungin
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.dw_group_detail
this.Control[iCurrent+8]=this.dw_sang
this.Control[iCurrent+9]=this.dw_detail
this.Control[iCurrent+10]=this.dw_ip
this.Control[iCurrent+11]=this.dw_ipgum
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.cbx_all
this.Control[iCurrent+14]=this.dw_rtv
this.Control[iCurrent+15]=this.dw_delete
end on

on w_kifa15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_group_detail)
destroy(this.dw_sang)
destroy(this.dw_detail)
destroy(this.dw_ip)
destroy(this.dw_ipgum)
destroy(this.rr_1)
destroy(this.cbx_all)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",  Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ipgum.SetTransObject(SQLCA)
dw_group_detail.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '13' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_kifa15
boolean visible = false
integer x = 256
integer y = 3092
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa15
boolean visible = false
integer x = 3163
integer y = 3140
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa15
boolean visible = false
integer x = 2990
integer y = 3140
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa15
boolean visible = false
integer x = 2281
integer y = 3144
integer taborder = 0
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa15
boolean visible = false
integer x = 2816
integer y = 3140
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa15
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa15
boolean visible = false
integer x = 3685
integer y = 3140
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa15
boolean visible = false
integer x = 2469
integer y = 3140
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

Integer iCount
	
iCount = dw_ip.GetItemNumber(1,"empcnt")

if iCount = 1 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	
elseif iCount = 2 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 3 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 4 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 5 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible = 0")
end if

FOR i = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(i,"chk") = '1' THEN
		sSaupj   = dw_rtv.GetItemString(i,"saupj")
		sBalDate = dw_rtv.GetItemString(i,"bal_date") 
		sUpmuGu  = dw_rtv.GetItemString(i,"upmu_gu") 
		lBJunNo  = dw_rtv.GetItemNumber(i,"bjun_no") 
		
		select distinct jun_no into :lJunNo	from kfz10ot0 
			where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu and bjun_no = :lBJunNo;
		if sqlca.sqlcode = 0 then
			iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,sPrtGbn,'P')
		else
			iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
		end if
		
		IF iRtnVal = -1 THEN
			F_MessageChk(14,'')
			Return -1
		ELSEIF iRtnVal = -2 THEN
			Return 1
		ELSE	
			sPrtGbn = '1'
		END IF
	END IF
NEXT

end event

type p_inq from w_inherite`p_inq within w_kifa15
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaleDtf,sSaleDtT,sSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sSaleDtf = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtf"))
sSaleDtt = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtt"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[NEGO일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[NEGO일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa15
boolean visible = false
integer x = 3511
integer y = 3140
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa15
integer x = 4270
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;Integer iYesCnt,k
String  sSaupj

IF rb_1.Checked =True THEN
	IF dw_ip.AcceptText() = -1 THEN RETURN
	sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_rtv.RowCount() <=0 THEN Return
	iYesCnt = dw_rtv.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF
		
	IF Wf_Insert_Kfz12ot0(sSaupj) = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	iYesCnt = dw_delete.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_kifa15
integer x = 4233
integer y = 2812
end type

type cb_mod from w_inherite`cb_mod within w_kifa15
integer x = 3881
integer y = 2812
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa15
integer x = 1495
integer y = 2808
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa15
integer x = 2354
integer y = 2808
end type

type cb_inq from w_inherite`cb_inq within w_kifa15
integer x = 3520
integer y = 2812
end type

type cb_print from w_inherite`cb_print within w_kifa15
integer x = 2711
integer y = 2808
end type

type st_1 from w_inherite`st_1 within w_kifa15
end type

type cb_can from w_inherite`cb_can within w_kifa15
integer x = 3063
integer y = 2808
end type

type cb_search from w_inherite`cb_search within w_kifa15
integer x = 1842
integer y = 2808
integer width = 498
string text = "품목보기(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa15
integer x = 1463
integer y = 2756
integer width = 1970
integer height = 184
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa15
integer x = 3470
integer y = 2756
integer width = 1134
end type

type gb_1 from groupbox within w_kifa15
integer x = 2725
integer width = 887
integer height = 176
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_kifa15
integer x = 2752
integer y = 64
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행처리"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="NEGO 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa15
integer x = 3168
integer y = 64
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제처리"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="NEGO 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa15
boolean visible = false
integer x = 73
integer y = 2408
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_sungin from datawindow within w_kifa15
boolean visible = false
integer x = 73
integer y = 2516
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa15
boolean visible = false
integer x = 73
integer y = 2620
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_group_detail from datawindow within w_kifa15
boolean visible = false
integer x = 1175
integer y = 2420
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "수출제비용 상세"
string dataobject = "d_kifa154"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kifa15
boolean visible = false
integer x = 73
integer y = 2724
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리결과 저장"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_detail from datawindow within w_kifa15
boolean visible = false
integer x = 1175
integer y = 2628
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "NEGO금액 상세"
string dataobject = "d_kifa155"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_kifa15
event ue_key pbm_dwnkey
integer x = 64
integer width = 2610
integer height = 184
integer taborder = 10
string dataobject = "d_kifa151"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '99' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"계산서발행일자")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"계산서발행일자")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "custf" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(1,"custfname",snull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"custf",    sNull)
		this.SetItem(1,"custfname",sNull)
		Return 1
	ELSE
		this.SetItem(1,"custfname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "custt" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(1,"custtname",snull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"custt",    sNull)
		this.SetItem(1,"custtname",sNull)
		Return 1
	ELSE
		this.SetItem(1,"custtname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "deptf" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[영업부서]')
		this.SetItem(1,"deptf",snull)
		Return 1
	END IF
	this.SetItem(1,"deptfname",sDeptName)
END IF

IF this.GetColumnName() = "deptt" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[영업부서]')
		this.SetItem(1,"deptt",snull)
		Return 1
	END IF
	this.SetItem(1,"depttname",sDeptName)
END IF

IF this.GetColumnName() ="chose" THEN
	sChoose = this.GetText()
	
	IF rb_1.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_rtv.Rowcount()
				dw_rtv.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_rtv.Rowcount()
				dw_rtv.SetItem(i,"chk",'0')
			NEXT
		END IF
	ELSEIF rb_2.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'0')
			NEXT
		END IF
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_ipgum from datawindow within w_kifa15
boolean visible = false
integer x = 1175
integer y = 2524
integer width = 1010
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "입금내역 상세"
string dataobject = "d_kifa156"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kifa15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 192
integer width = 4539
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kifa15
integer x = 3625
integer y = 112
integer width = 357
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

type dw_rtv from datawindow within w_kifa15
integer x = 87
integer y = 200
integer width = 4512
integer height = 2028
integer taborder = 30
string dataobject = "d_kifa152"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()

end event

event itemerror;Return 1
end event

event itemchanged;Double dAmount,dSunSuAmt
String sGbn,sAcc1_Dae,sAcc2_Dae,snull

SetNull(snull)

IF this.GetcolumnName() = "chk" THEN
	sGbn = this.GetText()
	IF sGbn = "" OR IsNull(sGbn) THEN Return
	
	dAmount   = this.GetItemNumber(this.GetRow(),"wuihaw_maichul")
	IF Isnull(dAmount) THEN dAmount = 0
	
	dSunSuAmt = this.GetItemNumber(this.GetRow(),"wsunsuamt")
	IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0
	
	IF sGbn = '1' AND dAmount = 0 AND dSunSuAmt = 0 THEN
		F_MessageChk(16,'[외화외상매출금액 = 0 OR 선수금액 = 0]')
		this.SetItem(this.GetRow(),"chk",'N')
		Return 1
	END IF
END IF
end event

event retrieveend;Integer k
Double  dRate

this.SetRedraw(False)
FOR k = 1 TO rowcount
	IF dw_detail.Retrieve(this.GetItemString(k,"ngno"),this.GetItemNumber(k,"weight"),dw_rtv.GetItemString(k,"icurr"),'') > 0 THEN
		this.SetItem(k,"wuihaw_maichul",dw_detail.GetItemNumber(1,"maichul"))
	ELSE
		this.SetItem(k,"wuihaw_maichul",0)		
	END IF

	IF dw_group_detail.Retrieve(this.GetItemString(k,"ngno")) > 0 THEN
		this.SetItem(k,"bwonhaw",dw_group_detail.GetItemNumber(1,"sumconsamt"))
		this.SetItem(k,"bwuihaw",dw_group_detail.GetItemNumber(1,"sumconsforamt"))
	ELSE
		this.SetItem(k,"bwonhaw",0)
		this.SetItem(k,"bwuihaw",0)
	END IF
NEXT
this.SetRedraw(True)

end event

event doubleclicked;Double dWuiChaSonAmt,dWuiChaIkamt

IF row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

Wf_Calculation_ChaIk(row,this.GetItemString(row,"ngno"),&
								 this.GetItemNumber(row,"weight"),dWuiChaSonAmt,dWuiChaIkamt)			/*외환차손/익*/
IF dWuiChaSonAmt <> 0 AND dWuiChaIkamt = 0 THEN
	Gs_Gubun = '2'
ELSEIF  dWuiChaSonAmt = 0 AND dWuiChaIkamt <> 0 THEN
	Gs_Gubun = '1'
ELSE
	Gs_Gubun = ''
END IF

OpenWithParm(w_kifa15b,this.GetItemString(row,"ngno"))
end event

type dw_delete from datawindow within w_kifa15
integer x = 87
integer y = 200
integer width = 4512
integer height = 2028
integer taborder = 40
string dataobject = "d_kifa153"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;IF row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

OpenWithParm(w_kifa15b,this.GetItemString(row,"ngno"))
end event

event clicked;//IF Row <=0 THEN Return
//
////IF this.GetColumnName() = "chk" THEN
////	SelectRow(0,False)
////ELSE
//	SelectRow(0,False)
//	SelectRow(Row,True)	
////END IF
	
end event

