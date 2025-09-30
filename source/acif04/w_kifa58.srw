$PBExportHeader$w_kifa58.srw
$PBExportComments$자동전표 관리 : 수출비용
forward
global type w_kifa58 from w_inherite
end type
type gb_1 from groupbox within w_kifa58
end type
type rb_1 from radiobutton within w_kifa58
end type
type rb_2 from radiobutton within w_kifa58
end type
type dw_junpoy from datawindow within w_kifa58
end type
type dw_sungin from datawindow within w_kifa58
end type
type dw_vat from datawindow within w_kifa58
end type
type dw_print from datawindow within w_kifa58
end type
type dw_ip from u_key_enter within w_kifa58
end type
type dw_sang from datawindow within w_kifa58
end type
type dw_detail from datawindow within w_kifa58
end type
type rr_1 from roundrectangle within w_kifa58
end type
type cbx_all from checkbox within w_kifa58
end type
type dw_rtv from datawindow within w_kifa58
end type
type dw_delete from datawindow within w_kifa58
end type
end forward

global type w_kifa58 from w_inherite
integer height = 2428
string title = "수출비용전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_vat dw_vat
dw_print dw_print
dw_ip dw_ip
dw_sang dw_sang
dw_detail dw_detail
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa58 w_kifa58

type variables

String sUpmuGbn = 'J',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate)
public function integer wf_create_vat (integer ilooprow, integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno)
end prototypes

public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount);/*반제 처리 = 반제전표번호를 읽어서 처리*/

String  sCrossNo, sSaupjS,sAccDateS,sUpmuGuS,sBalDateS
Long    lJunNoS,lLinNoS,lBJunNos
Integer iInsertrow

sCrossNo = dw_detail.GetItemString(icurrow,"crossno")
IF sCrossNo = "" OR IsNull(sCrossNo) THEN
	F_MessageChk(1,'[반제전표번호]')
	Return -1
END IF

sSaupjS   = Left(sCrossNo,2)
sAccDateS = Mid(sCrossNo,3,8)
sUpmuGuS  = Mid(sCrossNo,11,1)
lJunNoS   = Long(Mid(sCrossNo,12,4))
lLinNoS   = Integer(Mid(sCrossNo,16,3)) 
sBalDateS = Mid(sCrossNo,19,8)
lBJunNoS  = Long(Mid(sCrossNo,27,4)) 

iInsertRow = dw_sang.InsertRow(0)
	
dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuGuS)
dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
dw_sang.SetItem(iInsertRow,"lin_no",   lLinNoS)
dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
	
dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)

Return 1
end function

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
		
		/*수출비용자료 전표 발행 취소*/
		UPDATE "KIF06OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null
		WHERE ( "KIF06OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF06OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF06OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF06OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[수출비용자료]')
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
//	stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	전사로 집계('00'월)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate);/************************************************************************************/
/* 수출비용 자료를 자동으로 전표 처리한다.														*/
/* 1. 차변 : 수출비용코드(참조 '65'의 참조명(S)의 값)로 발생.								*/
/*           부가세가 있으면 선납부가세 계정으로 발생.(환경파일 A-1-2)					*/
/* 2. 대변 : 상대계정(참조 'EA'의 참조명(S)의 값)로 발생.									*/
/************************************************************************************/
String    sCostNo,sDcGbn,sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sBiYongCd,sChaDae,sYesanGbn,&
			 sVatGbn,sSangGbn,sCusGbn,sGbn1,sRemark1,sSaupNo,sSaupName,sDepotNo
Integer   k,lLinNo,iCurRow,iDetailCnt,i
Long      lJunNo,lAccJunNo
Double    dVatAmt

sle_msg.text =""

sle_msg.text ="수출비용 자동전표 처리 중 ..."

dw_rtv.AcceptText()

SetPointer(HourGlass!)
		
IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_junpoy.Reset()
		dw_vat.Reset()
		dw_sang.Reset()
		dw_sungin.Reset()

		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1

		sCostNo  = dw_rtv.GetItemString(k,"costno")						/*물류전표번호*/
		
		if dw_detail.Retrieve(sCostNo) <=0 then Continue
		
		dw_detail.SetFilter("gubun = '1'")									
		dw_detail.Filter()
		
		iDetailCnt = dw_detail.RowCount()
		IF iDetailCnt <=0 THEN Continue
		
		sDcGbn = '1'											/*차변 전표*/
			
		FOR i = 1 TO iDetailCnt
			sBiYongCd = dw_detail.GetItemString(i,"costcd")				 					/*비용코드*/
			sAcc1_Cha = dw_detail.GetItemString(i,"acc1")
			sAcc2_Cha = dw_detail.GetItemString(i,"acc2")
			
			SELECT "DC_GU", "YESAN_GU", "REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
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
				
			dw_junpoy.SetItem(iCurRow,"amt",     dw_detail.GetItemNumber(i,"costamt"))	
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(i,"costbigo"))	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_detail.GetItemString(i,"edept_cd"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"costvnd"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"costvndname"))
			
//			dw_junpoy.SetItem(iCurRow,"in_cd",   sBiYongCd)
						
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_detail.GetItemString(i,"curr"))		
			dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(i,"costforamt"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_detail.GetItemNumber(i,"exchrate"))
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_detail.GetItemString(i,"cdept_cd"))
			END IF
			
			if dw_detail.GetItemString(i,"vatgu") = '13' then
				dw_junpoy.SetItem(iCurRow,"vat_gu", 'Y')	
			end if
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1		
			
			if dw_detail.GetItemString(i,"vatgu") <> '15' and dw_detail.GetItemString(i,"vatgu") <> '19' then
				IF dw_detail.GetItemString(i,"vatgu") = '13' THEN					/*영세율*/ 
					IF Wf_Create_Vat(k,i,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
						SetPointer(Arrow!)
						Return -1
					END If
				END IF
			end if				
		NEXT
		
		dw_detail.SetFilter("gubun = '2'")									
		dw_detail.Filter()
		
		iDetailCnt = dw_detail.RowCount()
		IF iDetailCnt > 0 THEN 
			
			sDcGbn = '1'											
			FOR i = 1 TO iDetailCnt			
				IF Wf_Create_Vat(k,i,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
					SetPointer(Arrow!)
					Return -1
				END If
	
			NEXT
		END IF
				
		dw_detail.SetFilter("gubun = '3'")									
		dw_detail.Filter()
		
		iDetailCnt = dw_detail.RowCount()
		IF iDetailCnt <=0 THEN Continue
		
		sDcGbn = '2'											/*대변 전표*/

		FOR i = 1 TO iDetailCnt
			sAcc1_Dae = dw_detail.GetItemString(i,"acc1")
			sAcc2_Dae = dw_detail.GetItemString(i,"acc2")
			
			SELECT "SANG_GU",		"CUS_GU",	"GBN1",	"DC_GU",	 "REMARK1"
				INTO :sSangGbn,	:sCusGbn,	:sGbn1,	:sChaDae, :sRemark1  
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae);
			IF IsNull(sCusGbn) THEN sCusGbn = 'N'
			
			IF sCusGbn = 'N' THEN
				SetNull(sSaupNo);		SetNull(sSaupName);	
			ELSE
				IF sGbn1 = '3' THEN
					sSaupNo   = dw_rtv.GetItemString(k,"exdept_cd")
					sSaupName = F_Get_PersonLst('3',dw_rtv.GetItemString(k,"exdept_cd"),'1')		
				ELSEIF sGbn1 = '5' THEN
					sSaupNo  = dw_detail.GetItemString(i,"costvnd")
					
					SELECT "KFZ04OM0_V5"."PERSON_NM",      "KFZ04OM0_V5"."PERSON_NO"  
						INTO :sSaupName,   			         :sDepotNo  
						FROM "KFZ04OM0_V5"  
						WHERE "KFZ04OM0_V5"."PERSON_CD" = :sSaupNo   ;
					sSaupName = sSaupName + '['+ sDepotNo + ']'	
				ELSE
					sSaupNo   = dw_rtv.GetItemString(k,"costvnd")
					sSaupName = dw_rtv.GetItemString(k,"costvndname")		
				END IF
			END IF
											
			iCurRow = dw_junpoy.InsertRow(0)
				
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"exdept_cd"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
			dw_junpoy.SetItem(iCurRow,"amt",     dw_detail.GetItemNumber(i,"costamt") + &
																			 dw_detail.GetItemNumber(i,"costvat"))
			dw_junpoy.SetItem(iCurRow,"descr",   '수출비용 전표')		
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_detail.GetItemString(i,"edept_cd"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
			dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupName)
			
			IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
				IF Wf_Insert_Sang(i,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,&
										dw_detail.GetItemNumber(i,"costamt") + dw_detail.GetItemNumber(i,"costvat")) = 1 THEN	
					dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
				ELSE
					Return -1
				END IF
			ELSE
				dw_junpoy.SetItem(iCurRow,"cross_gu",'N')
			END IF
			dw_junpoy.SetItem(iCurRow,"y_curr",  	  dw_detail.GetItemString(i,"curr"))		
			dw_junpoy.SetItem(iCurRow,"y_amt",       dw_detail.GetItemNumber(i,"costforamt"))
			dw_junpoy.SetItem(iCurRow,"y_rate",      dw_detail.GetItemNumber(i,"exchrate"))
			
			dw_junpoy.SetItem(iCurRow,"gyul_date",   dw_detail.GetItemString(i,"gyul_date")) 
			dw_junpoy.SetItem(iCurRow,"gyul_method", dw_detail.GetItemString(i,"gyul_method")) 
			dw_junpoy.SetItem(iCurRow,"send_dep",    dw_detail.GetItemString(i,"send_dep")) 
			dw_junpoy.SetItem(iCurRow,"send_bank",   dw_detail.GetItemString(i,"send_bank")) 
			dw_junpoy.SetItem(iCurRow,"send_nm",     dw_detail.GetItemString(i,"send_nm")) 
							
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
			lLinNo = lLinNo + 1	
		NEXT
		
		dw_rtv.SetItem(k,"saupj",   sSaupj)
		dw_rtv.SetItem(k,"bal_date",sBalDate)
		dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
		dw_rtv.SetItem(k,"bjun_no", lJunNo)

		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[반제처리]')
				Return -1
			END IF
			IF dw_vat.Update() <> 1 THEN
				F_MessageChk(13,'[부가세]')
				Return -1
			END IF
			
			update kif06ot0
				set bal_date = :sBalDate,		upmu_gu = :sUpmuGbn,		bjun_no = :lJunNo,		alc_gu = 'N'
				where sabu = '1' and costno = :sCostNo;
			if sqlca.sqlcode <> 0 then
				F_MessageChk(13,'[수출비용]')
				SetPointer(Arrow!)
				Return -1
			end if
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				sle_msg.text = '승인 처리 중...'
				F_Insert_SungIn(dw_junpoy,dw_sungin) 
			END IF			
		END IF
	END IF
NEXT

sle_msg.text ="수출비용 전표 처리 완료!!"

Return 1
end function

public function integer wf_create_vat (integer ilooprow, integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno);String  sAcc1_Vat,sAcc2_Vat,sSaupNo
Integer iAddRow,iCurRow

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*선급부가세*/
	INTO :sAcc1_Vat,  						  :sAcc2_Vat	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[선급부가세(A-1-2)]')
	RETURN -1
END IF

IF dw_detail.GetItemString(irow,"vatgu") <> '13' THEN
	/*전표 추가*/
	iCurRow = dw_junpoy.InsertRow(0)
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iLoopRow,"exdept_cd"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  '1')
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_detail.GetItemNumber(iRow,"costvat"))	
	dw_junpoy.SetItem(iCurRow,"descr",   '부가세')	
				
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iLoopRow,"costvnd"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iLoopRow,"costvndname"))
	
	dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
END IF

/*부가세 자료 생성*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)

IF dw_detail.GetItemString(irow,"vatgu") <> '13' THEN 
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo)
ELSE
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo - 1)
END IF

dw_vat.SetItem(iAddRow,"gey_date",Left(dw_rtv.GetItemString(iLoopRow,"costno"),8))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_rtv.GetItemString(iLoopRow,"costvnd"))
dw_vat.SetItem(iAddRow,"gon_amt", dw_detail.GetItemNumber(iRow,"costamt"))
dw_vat.SetItem(iAddRow,"vat_amt", dw_detail.GetItemNumber(iRow,"costvat"))

dw_vat.SetItem(iAddRow,"for_amt", dw_detail.GetItemNumber(iRow,"costforamt"))
dw_vat.SetItem(iAddRow,"tax_no",  dw_detail.GetItemString(iRow,"vatgu"))
dw_vat.SetItem(iAddRow,"io_gu",   '1')										/*매입*/
dw_vat.SetItem(iAddRow,"saup_no2",dw_rtv.GetItemString(iLoopRow,"vndmst_sano"))
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   '부가세')	
dw_vat.SetItem(iAddRow,"jasa_cd", dw_rtv.GetItemString(iLoopRow,"jacod"))	
dw_vat.SetItem(iAddRow,"lc_no",   dw_rtv.GetItemString(iLoopRow,"blno"))
dw_vat.SetItem(iAddRow,"cvnas",   dw_rtv.GetItemString(iLoopRow,"costvndname"))
dw_vat.SetItem(iAddRow,"ownam",   dw_rtv.GetItemString(iLoopRow,"vndmst_ownam"))
dw_vat.SetItem(iAddRow,"resident",dw_rtv.GetItemString(iLoopRow,"vndmst_resident"))
dw_vat.SetItem(iAddRow,"uptae",   dw_rtv.GetItemString(iLoopRow,"vndmst_uptae"))
dw_vat.SetItem(iAddRow,"jongk",   dw_rtv.GetItemString(iLoopRow,"vndmst_jongk"))
dw_vat.SetItem(iAddRow,"addr1",   dw_rtv.GetItemString(iLoopRow,"vndmst_addr1"))
//dw_vat.SetItem(iAddRow,"addr2",   dw_rtv.GetItemString(iLoopRow,"vndmst_addr2"))
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))
dw_vat.SetItem(iAddRow,"exc_rate",dw_detail.GetItemNumber(iRow,"exchrate"))
dw_vat.SetItem(iAddRow,"curr",    dw_detail.GetItemString(iRow,"curr"))

IF dw_detail.GetItemString(irow,"vatgu") <> '13' THEN 
	lLinNo = lLinNo + 1
END IF

Return 1
end function

on w_kifa58.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_vat=create dw_vat
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_sang=create dw_sang
this.dw_detail=create dw_detail
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
this.Control[iCurrent+6]=this.dw_vat
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_ip
this.Control[iCurrent+9]=this.dw_sang
this.Control[iCurrent+10]=this.dw_detail
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.cbx_all
this.Control[iCurrent+13]=this.dw_rtv
this.Control[iCurrent+14]=this.dw_delete
end on

on w_kifa58.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_vat)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_sang)
destroy(this.dw_detail)
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
dw_ip.SetItem(dw_ip.Getrow(),"accdate",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_vat.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

dw_detail.SetTransObject(Sqlca)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '09' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa58
boolean visible = false
integer x = 2126
integer y = 2732
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa58
boolean visible = false
integer x = 3525
integer y = 3120
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa58
boolean visible = false
integer x = 3351
integer y = 3120
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa58
integer x = 3922
integer y = 8
integer taborder = 70
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

event p_search::clicked;call super::clicked;Integer iSelectRow

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	OpenWithParm(w_kifa58a,dw_rtv.GetItemString(iSelectRow,"costno"))
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	OpenWithParm(w_kifa58a,dw_delete.GetItemString(iSelectRow,"costno"))
END IF
end event

type p_ins from w_inherite`p_ins within w_kifa58
boolean visible = false
integer x = 3177
integer y = 3120
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa58
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa58
boolean visible = false
integer x = 3881
integer y = 3120
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa58
boolean visible = false
integer x = 3835
integer y = 2372
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

type p_inq from w_inherite`p_inq within w_kifa58
integer x = 4096
integer y = 8
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
	F_MessageChk(1,'[비용일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[비용일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(True)
dw_delete.SetRedraw(False)
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
dw_delete.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa58
boolean visible = false
integer x = 3707
integer y = 3120
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa58
integer x = 4270
integer y = 8
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;Integer iYesCnt,k
String  sAccDate,sSaupj

IF rb_1.Checked =True THEN
	iYesCnt = dw_rtv.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF

	dw_ip.AcceptText()
	sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sAccDate = dw_ip.GetItemString(1,"accdate")
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return
	END IF
		
	IF sAccDate = "" OR IsNull(sAccDate) THEN
		F_MessageChk(1,'[회계일자]')	
		dw_ip.SetColumn("accdate")
		dw_ip.SetFocus()
		Return
	ELSE
		IF F_Check_LimitDate(sAccDate,'A') = -1 THEN
			F_MessageChk(29,'[회계일자]')
			dw_ip.SetColumn("accdate")
			dw_ip.SetFocus()
			Return
		END IF
	END IF

	IF Wf_Insert_Kfz12ot0(sSaupj,sAccDate) = -1 THEN
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

type cb_exit from w_inherite`cb_exit within w_kifa58
integer x = 3781
integer y = 2792
end type

type cb_mod from w_inherite`cb_mod within w_kifa58
integer x = 3419
integer y = 2788
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa58
integer x = 3136
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa58
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kifa58
integer x = 3058
integer y = 2788
end type

type cb_print from w_inherite`cb_print within w_kifa58
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kifa58
end type

type cb_can from w_inherite`cb_can within w_kifa58
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kifa58
integer x = 2601
integer y = 2788
integer width = 430
string text = "비용보기(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa58
integer x = 2048
integer y = 2540
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa58
integer x = 2551
integer y = 2736
integer width = 1605
end type

type gb_1 from groupbox within w_kifa58
integer x = 3104
integer width = 485
integer height = 200
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

type rb_1 from radiobutton within w_kifa58
integer x = 3131
integer y = 44
integer width = 434
integer height = 80
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
	dw_rtv.Title ="수출비용 자동전표 발행"
	
	dw_rtv.Visible    = True
	dw_delete.Visible = False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa58
integer x = 3131
integer y = 108
integer width = 434
integer height = 80
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
	dw_delete.Title ="수출비용 자동전표 삭제"
	
	dw_rtv.Visible    = False
	dw_delete.Visible = True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa58
boolean visible = false
integer x = 1083
integer y = 2612
integer width = 1024
integer height = 108
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

type dw_sungin from datawindow within w_kifa58
boolean visible = false
integer x = 1083
integer y = 2720
integer width = 1024
integer height = 100
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

type dw_vat from datawindow within w_kifa58
boolean visible = false
integer x = 1083
integer y = 2816
integer width = 1024
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "부가세 저장"
string dataobject = "d_kifa037"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa58
boolean visible = false
integer x = 50
integer y = 2616
integer width = 1024
integer height = 100
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

type dw_ip from u_key_enter within w_kifa58
event ue_key pbm_dwnkey
integer x = 55
integer width = 2985
integer height = 208
integer taborder = 10
string dataobject = "d_kifa581"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sDeptCode,sChoose
Integer i

SetNull(snull)

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[회계단위]")
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

IF this.GetColumnName() ="accdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"회계일자")
		dw_ip.SetItem(1,"accdate",snull)
		Return 1
	END IF
	
	IF F_Check_LimitDate(sDate,'B') = -1 THEN
		F_MessageChk(29,'[회계일자]')
		this.SetItem(1,"accdate",snull)
		this.SetColumn("accdate")
		Return 1
	END IF
	
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

type dw_sang from datawindow within w_kifa58
boolean visible = false
integer x = 50
integer y = 2708
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리결과 저장"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_kifa58
boolean visible = false
integer x = 50
integer y = 2808
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "물류전표별 상세계정 조회"
string dataobject = "d_kifa585"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa58
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 212
integer width = 4553
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kifa58
integer x = 3598
integer y = 136
integer width = 334
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

type dw_rtv from datawindow within w_kifa58
integer x = 73
integer y = 220
integer width = 4526
integer height = 2004
integer taborder = 30
string dataobject = "d_kifa582"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

	
end event

type dw_delete from datawindow within w_kifa58
integer x = 73
integer y = 220
integer width = 4526
integer height = 2004
integer taborder = 40
string dataobject = "d_kifa583"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

