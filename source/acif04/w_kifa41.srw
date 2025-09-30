$PBExportHeader$w_kifa41.srw
$PBExportComments$자동전표 관리 : 매입(계산서기준)
forward
global type w_kifa41 from w_inherite
end type
type gb_1 from groupbox within w_kifa41
end type
type rb_1 from radiobutton within w_kifa41
end type
type rb_2 from radiobutton within w_kifa41
end type
type dw_ip from u_key_enter within w_kifa41
end type
type dw_junpoy from datawindow within w_kifa41
end type
type dw_sungin from datawindow within w_kifa41
end type
type dw_detail from datawindow within w_kifa41
end type
type dw_vat from datawindow within w_kifa41
end type
type dw_print from datawindow within w_kifa41
end type
type dw_group_detail from datawindow within w_kifa41
end type
type dw_sang from datawindow within w_kifa41
end type
type rr_1 from roundrectangle within w_kifa41
end type
type cbx_all from checkbox within w_kifa41
end type
type dw_rtv from datawindow within w_kifa41
end type
type dw_delete from datawindow within w_kifa41
end type
end forward

global type w_kifa41 from w_inherite
integer height = 2420
string title = "매입전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_detail dw_detail
dw_vat dw_vat
dw_print dw_print
dw_group_detail dw_group_detail
dw_sang dw_sang
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa41 w_kifa41

type variables

String sUpmuGbn = 'B',LsAutoSungGbn,LsJpyCreateGbn
end variables

forward prototypes
public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0_1 (string ssaupj)
public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount)
public function integer wf_chk_validdata (integer i)
public function integer wf_insert_kfz12ot0 (string ssaupj)
end prototypes

public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno);String  sAcc1_Vat,sAcc2_Vat,sSaupNo,sVatGbn
Integer iAddRow,iCurRow

sVatGbn = dw_rtv.GetItemString(iRow,"tax_no")
IF sVatGbn = "" OR IsNull(sVatGbn) OR sVatGbn = '15' then Return 1

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*선급부가세*/
	INTO :sAcc1_Vat,  						  :sAcc2_Vat	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[선급부가세(A-1-2)]')
	RETURN -1
END IF

IF sVatGbn <> '19' THEN 
	/*전표 추가*/
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"buy_dept"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  '1')
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(iRow,"vat_amt"))	
	dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(iRow,"descr")+'[부가세]')	
				
	dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"sdept_cd"))
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvnas"))
	
	dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
	
	dw_junpoy.SetItem(iCurRow,"gita2", dw_ip.GetItemString(1,"gita2"))
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
END IF

/*부가세 자료 생성*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)

IF sVatGbn <> '19' THEN 
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo)
ELSE
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo - 1)
END IF

dw_vat.SetItem(iAddRow,"gey_date",dw_rtv.GetItemString(iRow,"buydt"))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))

IF dw_group_detail.RowCount() <=0 THEN
	dw_vat.SetItem(iAddRow,"gon_amt", dw_rtv.GetItemNumber(iRow,"gon_amt"))
ELSE
	dw_vat.SetItem(iAddRow,"gon_amt", dw_group_detail.GetItemNumber(1,"total_amt"))
END IF

dw_vat.SetItem(iAddRow,"vat_amt", dw_rtv.GetItemNumber(iRow,"vat_amt"))
dw_vat.SetItem(iAddRow,"for_amt", dw_rtv.GetItemNumber(iRow,"for_amt"))
dw_vat.SetItem(iAddRow,"tax_no",  dw_rtv.GetItemString(iRow,"tax_no"))
dw_vat.SetItem(iAddRow,"io_gu",   '1')										/*매입*/
dw_vat.SetItem(iAddRow,"saup_no2",dw_rtv.GetItemString(iRow,"sano"))
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   dw_rtv.GetItemString(iRow,"descr"))
dw_vat.SetItem(iAddRow,"jasa_cd", dw_rtv.GetItemString(iRow,"jasa_cd"))
dw_vat.SetItem(iAddRow,"vouc_gu", dw_rtv.GetItemString(iRow,"vouc_gu"))
dw_vat.SetItem(iAddRow,"lc_no",   dw_rtv.GetItemString(iRow,"lcno"))
dw_vat.SetItem(iAddRow,"cvnas",   dw_rtv.GetItemString(iRow,"cvnas"))
dw_vat.SetItem(iAddRow,"ownam",   dw_rtv.GetItemString(iRow,"ownam"))
dw_vat.SetItem(iAddRow,"resident",dw_rtv.GetItemString(iRow,"resident"))
dw_vat.SetItem(iAddRow,"uptae",   dw_rtv.GetItemString(iRow,"uptae"))
dw_vat.SetItem(iAddRow,"jongk",   dw_rtv.GetItemString(iRow,"jongk"))
dw_vat.SetItem(iAddRow,"addr1",   dw_rtv.GetItemString(iRow,"addr1"))
dw_vat.SetItem(iAddRow,"addr2",   dw_rtv.GetItemString(iRow,"addr2"))
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))
dw_vat.SetItem(iAddRow,"exc_rate",dw_rtv.GetItemNumber(iRow,"exc_rate"))
dw_vat.SetItem(iAddRow,"elegbn", dw_rtv.GetItemString(iRow,"elegbn"))

IF sVatGbn <> '19' THEN 
	lLinNo = lLinNo + 1
END IF

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull,sCvcod,sMaYm
Long    lJunNo,lNull,lSeqNo

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sCvcod   = dw_delete.GetItemString(k,"cvcod")
		sMaYm    = dw_delete.GetItemString(k,"mayymm")
		lSeqNo   = dw_delete.GetItemNumber(k,"mayyseq")
		
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Continue
		
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
		
		dw_delete.SetItem(k,"bal_date", snull)
		dw_delete.SetItem(k,"upmu_gu",  snull)
		dw_delete.SetItem(k,"bjun_no",  lnull)
	END IF
NEXT
IF dw_delete.Update() <> 1 THEN
	F_MessageChk(12,'[매입자료]')
	SetPointer(Arrow!)
	Return -1
END IF

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0_1 (string ssaupj);/************************************************************************************/
/* 매입자료를 자동으로 전표 처리한다.(전표를 하나로)											*/
/* 1. 차변 : 건별 상세의 품목에 대한 계정코드별로 발생.										*/
/*           선급부가세 계정으로 발생.(환경파일 A-1-2)										*/
/* 2. 대변 : 상대계정으로 발생.																		*/
/* ** 품목의 상세내역은 계정별로 모아서 전표로 만든다.										*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sIpDate,sBalDate,sCvcod,&
			sYesanGbn,sChaDae,sSangGbn,sAccDate,sAlcGbn,sGbn1,sRemark1,sItCls, sTaxGbn
Integer  k,iCnt,i,lLinNo,iCurRow,iLoopCnt,iItemDetailCnt,iIpSeq,iCreateRow,j
Long     lJunNo,lAccJunNo
Double   dAmount,dGonAmt

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="매입 자동전표 처리 중 ..."

dw_ip.AcceptText()
sBalDate = dw_ip.GetitemString(1,"saledtf")								/*발행일자 = 입력한 계산서일자*/
IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

SetPointer(HourGlass!)

dw_sungin.Reset()
dw_junpoy.Reset()
dw_vat.Reset()
dw_sang.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		sBalDate = dw_rtv.GetItemString(k,"buydt") 
		sIpDate  = dw_rtv.GetItemString(k,"mayymm")
		iIpSeq   = dw_rtv.GetItemNumber(k,"mayyseq")
		sCvcod   = dw_rtv.GetItemString(k,"cvcod")
		
		iLoopCnt = dw_group_detail.Retrieve(sIpDate+String(iIpSeq),sCvcod)		/*처리할 물품 건수*/
						
		FOR iCnt = 1 TO iLoopCnt
			sDcGbn = '1'											/*차변 전표*/
			
			sAcc1_Cha = Left(dw_group_detail.GetItemString(iCnt,"accod"),5)
			sAcc2_Cha = Right(dw_group_detail.GetItemString(iCnt,"accod"),2)
			sItcls    = dw_group_detail.GetItemString(iCnt,"itcls")
			
			/*물품 건수*/
			iItemDetailCnt = dw_detail.Retrieve(sIpDate+String(iIpSeq),sCvcod,sAcc1_Cha+sAcc2_Cha,sItcls+'%')	
			
			SELECT "DC_GU",  		"YESAN_GU",			"REMARK1",		"TAXGBN"      
				INTO :sChaDae,		:sYesanGbn,			:sRemark1,			:sTaxGbn					/*예산통제*/
				FROM "KFZ01OM0"  
				WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cha ) AND  
						( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cha  ) ;
							
			dAmount   = dw_group_detail.GetItemNumber(iCnt,"sum_ioamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
	
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"buy_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itemas_itdsc")+'외 '+&
															 String(dw_detail.GetItemNumber(1,"item_count")) +'종')	
			
			IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"sdept_cd"))
			END IF
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"buy_dept"))
			END IF
				
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvnas"))
			
			dw_junpoy.SetItem(iCurRow,"kwan_no", sItcls)
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"exc_rate"))
			
			IF sTaxGbn = 'Y' THEN
				dw_junpoy.SetItem(iCurRow,"taxgbn",  '03')	
			END IF
			
			dw_junpoy.SetItem(iCurRow,"gita2", dw_ip.GetItemString(1,"gita2"))
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			lLinNo = lLinNo + 1
			
		NEXT
		IF dw_rtv.GetItemString(k,"tax_no") = '19' THEN
			dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
		END IF
		/*선급부가세 계정 생성(차변)*/
		IF Wf_Create_Vat(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			SetPointer(Arrow!)
			Return -1
		END IF
		
		/*대변 전표-전표구분에 따라서 처리(가지급금,선급금,외상매입금 등)*/
		sAcc1_Dae = Left(dw_rtv.GetItemString(k,"saccod"),5)
		sAcc2_Dae = Right(dw_rtv.GetItemString(k,"saccod"),2)
			
		/*반제처리 여부,차대*/
		SELECT "DC_GU",	"SANG_GU",	"GBN1",	"REMARK1"
      	INTO :sChaDae,	:sSangGbn,	:sGbn1,	:sRemark1
			FROM "KFZ01OM0"  
			WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae) ;
				
		sDcGbn = '2'											
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"buy_dept"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		IF iLoopCnt = 0 OR IsNull(iLoopCnt) THEN
			dGonAmt = dw_rtv.GetItemNumber(k,"vat_amt")
		ELSE
			dGonAmt = dw_group_detail.GetItemNumber(1,"total_amt") + dw_rtv.GetItemNumber(k,"vat_amt")
		END IF
		
		dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
		dw_junpoy.SetItem(iCurRow,"descr",   '물품대')	
		IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN		
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"sdept_cd"))
		END IF
		
		IF sGbn1 = '3' THEN											/*부서*/
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"buy_dept"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   f_get_personlst('3',dw_rtv.GetItemString(k,"buy_dept"),'1'))
		ELSE
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvnas"))
		END IF
		
		dw_junpoy.SetItem(iCurRow,"y_amt",   dw_rtv.GetItemNumber(k,"for_amt"))	
		
		IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
			IF Wf_Insert_Sang(k,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,dGonAmt) = 1 THEN	
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
			ELSE
				Return -1
			END IF
		ELSE
			dw_junpoy.SetItem(iCurRow,"cross_gu",'N')
		END IF
		
		dw_junpoy.SetItem(iCurRow,"gyul_date",  dw_rtv.GetItemString(k,"gyul_date")) 
		dw_junpoy.SetItem(iCurRow,"gyul_method",dw_rtv.GetItemString(k,"gyul_method")) 
		dw_junpoy.SetItem(iCurRow,"send_dep",   dw_rtv.GetItemString(k,"send_dep")) 
		dw_junpoy.SetItem(iCurRow,"send_bank",  dw_rtv.GetItemString(k,"send_bank")) 
		dw_junpoy.SetItem(iCurRow,"send_nm",    dw_rtv.GetItemString(k,"send_nm")) 
		
		dw_junpoy.SetItem(iCurRow,"gita2", dw_ip.GetItemString(1,"gita2"))
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		lLinNo = lLinNo + 1	
		
		dw_rtv.SetItem(k,"saupj",   sSaupj)
		dw_rtv.SetItem(k,"bal_date",sBalDate)
		dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
		dw_rtv.SetItem(k,"bjun_no", lJunNo)
	END IF
NEXT

IF dw_junpoy.RowCount() > 0 THEN
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
		
		IF dw_rtv.Update() <> 1 THEN
			F_MessageChk(13,'[매입자료]')
			SetPointer(Arrow!)	
			RETURN -1
		END IF
		COMMIT;

		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN
				F_MessageChk(13,'[전표 승인]')
				Rollback;
//				Return -1
			END IF	
		END IF
		Commit;
	END IF	
END IF

w_mdi_frame.sle_msg.text ="매입 전표 처리 완료!!"

Return 1
end function

public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount);/*반제 처리 = 반제전표번호를 읽어서 처리*/

String  sCrossNo, sSaupjS,sAccDateS,sUpmuGuS,sBalDateS
Long    lJunNoS,lLinNoS,lBJunNos
Integer iInsertrow

sCrossNo = dw_rtv.GetItemString(icurrow,"crossno")
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

public function integer wf_chk_validdata (integer i);Integer iCount
String  sCust,sMaYm
Long    lSeq

sCust = dw_rtv.GetItemString(i,"cvcod")
sMaYm = dw_rtv.GetItemString(i,"mayymm")
lSeq  = dw_rtv.GetItemNumber(i,"mayyseq")

SELECT Count(*)     INTO :iCount    
	FROM "KIF01OT1"  
	WHERE ( "KIF01OT1"."MAYYMM"  = :sMaYm ) AND ( "KIF01OT1"."MAYYSEQ" = :lSeq ) AND  
     		( "KIF01OT1"."CVCOD"   = :sCust ) AND
			( "KIF01OT1"."ACCODE" is null OR "KIF01OT1"."ACCODE" = '');
IF SQLCA.SQLCODE <> 0 THEN
	iCount = 0
ELSE
	IF IsNull(iCount) THEN iCount = 0
END IF

IF iCount > 0 THEN
	F_MessageChk(1,'[품목별 계정과목]')
	Return -1
END IF	
			
Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj);/************************************************************************************/
/* 매입자료를 자동으로 전표 처리한다.(건별 전표 발생)											*/
/* 1. 차변 : 건별 상세의 품목에 대한 계정코드별로 발생.										*/
/*           선급부가세 계정으로 발생.(환경파일 A-1-2)										*/
/* 2. 대변 : 상대계정으로 발생.																		*/
/* ** 품목의 상세내역은 계정별로 모아서 전표로 만든다.										*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sIpDate,sBalDate,sCvcod,&
			sYesanGbn,sChaDae,sSangGbn,sAccDate,sAlcGbn,sGbn1,sRemark1,sItcls, sTaxGbn
Integer  k,iCnt,i,lLinNo,iCurRow,iLoopCnt,iItemDetailCnt,iIpSeq,iCreateRow,j
Long     lJunNo,lAccJunNo
Double   dAmount,dGonAmt

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="매입 자동전표 처리 중 ..."

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_sungin.Reset()
		dw_junpoy.Reset()
		dw_vat.Reset()
		
//		sSaupj   = dw_rtv.GetItemString(k,"saup")
		sBalDate = dw_rtv.GetItemString(k,"buydt") 
		sIpDate  = dw_rtv.GetItemString(k,"mayymm")
		iIpSeq   = dw_rtv.GetItemNumber(k,"mayyseq")
		
		sCvcod   = dw_rtv.GetItemString(k,"cvcod")
		
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[발행일자]')
			continue
		END IF

		iLoopCnt = dw_group_detail.Retrieve(sIpDate+String(iIpSeq),sCvcod)		/*처리할 물품 건수*/
//		IF iLoopcnt <=0 THEN Continue
				
		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		FOR iCnt = 1 TO iLoopCnt
			sDcGbn = '1'											/*차변 전표*/
			
			sAcc1_Cha = Left(dw_group_detail.GetItemString(iCnt,"accod"),5)
			sAcc2_Cha = Right(dw_group_detail.GetItemString(iCnt,"accod"),2)
			/*물품 건수*/
			iItemDetailCnt = dw_detail.Retrieve(sIpDate+String(iIpSeq),sCvcod,sAcc1_Cha+sAcc2_Cha,sItcls+'%')	
			SELECT "DC_GU",  		"YESAN_GU",			"REMARK1",			"TAXGBN"      
				INTO :sChaDae,		:sYesanGbn,			:sRemark1,				:sTaxGbn					/*예산통제*/
				FROM "KFZ01OM0"  
				WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cha ) AND  
						( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cha  ) ;
							
			dAmount   = dw_group_detail.GetItemNumber(iCnt,"sum_ioamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
	
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"buy_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itemas_itdsc")+'외 '+&
															 String(dw_detail.GetItemNumber(1,"item_count")) +'종')	
			
			IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"sdept_cd"))
			END IF
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"buy_dept"))
			END IF
				
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvnas"))
			
			dw_junpoy.SetItem(iCurRow,"kwan_no", sItcls)
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"exc_rate"))
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"y_curr"))
			
			IF sTaxGbn = 'Y' THEN
				dw_junpoy.SetItem(iCurRow,"taxgbn",  '03')	
			END IF
			dw_junpoy.SetItem(iCurRow,"gita2", dw_ip.GetItemString(1,"gita2"))
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			lLinNo = lLinNo + 1
			
		NEXT
		IF dw_rtv.GetItemString(k,"tax_no") = '19' THEN
			dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 	
		END IF
		/*선급부가세 계정 생성(차변)*/
		IF Wf_Create_Vat(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			SetPointer(Arrow!)
			Return -1
		END IF
		
		/*대변 전표-전표구분에 따라서 처리(가지급금,선급금,외상매입금 등)*/
		sAcc1_Dae = Left(dw_rtv.GetItemString(k,"saccod"),5)
		sAcc2_Dae = Right(dw_rtv.GetItemString(k,"saccod"),2)
			
		/*반제처리 여부,차대*/
		SELECT "DC_GU",	"SANG_GU",	"GBN1",	"REMARK1"
      	INTO :sChaDae,	:sSangGbn,	:sGbn1,	:sRemark1
			FROM "KFZ01OM0"  
			WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae) ;
				
		sDcGbn = '2'											
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"buy_dept"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		IF iLoopCnt = 0 OR IsNull(iLoopCnt) THEN
			dGonAmt = dw_rtv.GetItemNumber(k,"vat_amt")
		ELSE
			dGonAmt = dw_group_detail.GetItemNumber(1,"total_amt") + dw_rtv.GetItemNumber(k,"vat_amt")
		END IF
		
		dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
		dw_junpoy.SetItem(iCurRow,"descr",   '물품대')	
		IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN		
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"sdept_cd"))
		END IF
		
		IF sGbn1 = '3' THEN											/*부서*/
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"buy_dept"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   f_get_personlst('3',dw_rtv.GetItemString(k,"buy_dept"),'1'))
		ELSE
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvnas"))
		END IF
		
		dw_junpoy.SetItem(iCurRow,"y_amt",    dw_rtv.GetItemNumber(k,"for_amt"))	
		dw_junpoy.SetItem(iCurRow,"y_rate",   dw_rtv.GetItemNumber(k,"exc_rate"))
		dw_junpoy.SetItem(iCurRow,"y_curr",   dw_rtv.GetItemString(k,"y_curr"))
		
		IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
			IF Wf_Insert_Sang(k,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,dGonAmt) = 1 THEN	
				dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
			ELSE
				Return -1
			END IF
		ELSE
			dw_junpoy.SetItem(iCurRow,"cross_gu",'N')
		END IF
		
		dw_junpoy.SetItem(iCurRow,"gyul_date",  dw_rtv.GetItemString(k,"gyul_date")) 
		dw_junpoy.SetItem(iCurRow,"gyul_method",dw_rtv.GetItemString(k,"gyul_method")) 
		dw_junpoy.SetItem(iCurRow,"send_dep",   dw_rtv.GetItemString(k,"send_dep")) 
		dw_junpoy.SetItem(iCurRow,"send_bank",  dw_rtv.GetItemString(k,"send_bank")) 
		dw_junpoy.SetItem(iCurRow,"send_nm",    dw_rtv.GetItemString(k,"send_nm")) 
		
		dw_junpoy.SetItem(iCurRow,"gita2", dw_ip.GetItemString(1,"gita2"))
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
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
			
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn ='N';
				ELSE
					sAccDate  = dw_sungin.GetItemString(1,"acc_date")
					lAccJunNo = dw_sungin.GetItemNumber(1,"jun_no")
					sAlcGbn   = 'Y'
				END IF	
			ELSE
				SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn ='N';
			END IF
		END IF
		
		dw_rtv.SetItem(k,"saupj",   sSaupj)
		dw_rtv.SetItem(k,"bal_date",sBalDate)
		dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
		dw_rtv.SetItem(k,"bjun_no", lJunNo)
//		dw_rtv.SetItem(k,"alc_gu",  sAlcGbn)
//		dw_rtv.SetItem(k,"acc_date",sAccDate)
//		dw_rtv.SetItem(k,"jun_no",  lAccJunNo)
	END IF
NEXT
			
IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[매입자료]')
	SetPointer(Arrow!)	
	RETURN -1
END IF
COMMIT;

w_mdi_frame.sle_msg.text ="매입 전표 처리 완료!!"

Return 1
end function

on w_kifa41.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_detail=create dw_detail
this.dw_vat=create dw_vat
this.dw_print=create dw_print
this.dw_group_detail=create dw_group_detail
this.dw_sang=create dw_sang
this.rr_1=create rr_1
this.cbx_all=create cbx_all
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_detail
this.Control[iCurrent+8]=this.dw_vat
this.Control[iCurrent+9]=this.dw_print
this.Control[iCurrent+10]=this.dw_group_detail
this.Control[iCurrent+11]=this.dw_sang
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.cbx_all
this.Control[iCurrent+14]=this.dw_rtv
this.Control[iCurrent+15]=this.dw_delete
end on

on w_kifa41.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_detail)
destroy(this.dw_vat)
destroy(this.dw_print)
destroy(this.dw_group_detail)
destroy(this.dw_sang)
destroy(this.rr_1)
destroy(this.cbx_all)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"sabu",gs_saupj)

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_group_detail.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)

dw_vat.SetTransObject(SQLCA)
dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

p_mod.Enabled =False

/*자동 승인 여부,전표생성방법(1:건별 전표,2:전표하나) 체크*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1),		SUBSTR("SYSCNFG"."DATANAME",2,1)
	INTO :LsAutoSungGbn,								:LsJpyCreateGbn  			
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '02' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N';				LsJpyCreateGbn = '1';
ELSE
	IF IsNull(LsAutoSungGbn) THEN  LsAutoSungGbn = 'N'
	IF IsNull(LsJpyCreateGbn) THEN LsJpyCreateGbn = '1'
END IF

IF LsJpyCreateGbn = '1' THEN
	dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6) + "01")
	dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())
	
	dw_ip.Modify("saledtt.protect = 0")
//	dw_ip.Modify("saledtt.background.color ='"+String(RGB(190,225,184))+"'")
ELSE
	dw_ip.SetItem(dw_ip.Getrow(),"saledtf",f_today())
	dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())
	
	dw_ip.Modify("saledtt.protect = 1")
//	dw_ip.Modify("saledtt.background.color ='"+String(RGB(192,192,192))+"'")
END IF

//24.10.23_SBH_마감구분 지정
dw_ip.SetItem(dw_ip.Getrow(),"magbn","9")

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa41
boolean visible = false
integer x = 2821
integer y = 2896
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa41
boolean visible = false
integer x = 3840
integer y = 2792
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa41
boolean visible = false
integer x = 3666
integer y = 2792
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa41
integer x = 3922
integer y = 0
integer taborder = 70
boolean originalsize = true
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iSelectRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code  = dw_rtv.GetItemString(iSelectRow,"cvcod")
	IF dw_rtv.GetItemString(iSelectRow,"chk") = '1' THEN
		Gs_Gubun = 'Y'
	ELSE
		Gs_Gubun = 'N'
	END IF
	
	OpenWithParm(w_kifa41a,dw_rtv.GetItemString(iSelectRow,"mayymm") + &
								  String(dw_rtv.GetItemNumber(iSelectRow,"mayyseq")))
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	Gs_Code = dw_delete.GetItemString(iSelectRow,"cvcod")
	Gs_Gubun = 'D'
	OpenWithParm(w_kifa41a,dw_delete.GetItemString(iSelectRow,"mayymm") + &
								  String(dw_delete.GetItemNumber(iSelectRow,"mayyseq")))
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa41
boolean visible = false
integer x = 3493
integer y = 2792
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa41
integer y = 0
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa41
boolean visible = false
integer x = 4187
integer y = 2788
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa41
boolean visible = false
integer x = 3319
integer y = 2800
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sCvcod,sMaYm,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lSeqNo,lJunNo
Integer i,iRtnVal

IF MessageBox("확 인", "출력하시겠습니까?", Question!, OkCancel!, 2) = 2 THEN RETURN

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
		sCvcod   = dw_rtv.GetItemString(i,"cvcod")
		sMaYm    = dw_rtv.GetItemString(i,"mayymm")
		lSeqNo   = dw_rtv.GetItemNumber(i,"mayyseq")
		
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

type p_inq from w_inherite`p_inq within w_kifa41
integer x = 4096
integer y = 0
end type

event p_inq::clicked;call super::clicked;String sSaupj,sSaleDtf,sSaleDtT,sCustf,sCustt,sDeptf,sDeptt, sMagbn

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")
sSaleDtf = dw_ip.GetItemString(dw_ip.GetRow(),"saledtf")
sSaleDtt = dw_ip.GetItemString(dw_ip.GetRow(),"saledtt")
sCustF   = dw_ip.GetItemString(dw_ip.GetRow(),"custf")
sCustT   = dw_ip.GetItemString(dw_ip.GetRow(),"custt")
sDeptF   = dw_ip.GetItemString(dw_ip.GetRow(),"deptf")
sDeptt   = dw_ip.GetItemString(dw_ip.GetRow(),"deptt")
sMagbn  = dw_ip.GetItemString(dw_ip.GetRow(),"magbn")		//24.10.23_SBH_마감구분 추가

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[계산서일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[계산서일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF
IF sCustf = "" OR IsNull(sCustf) THEN 	sCustf = '0'
IF sCustt = "" OR IsNull(sCustt) THEN  sCustt = 'zzzzzz'
IF sDeptf = "" OR IsNull(sDeptf) THEN 	sDeptf = '0'
IF sDeptt = "" OR IsNull(sDeptt) THEN 	sDeptt = 'zzzzzz'

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt,sCustf,sCustt,sDeptf,sDeptt,sMagbn) <= 0 THEN		//24.10.23_SBH_마감구분 추가
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt,sCustf,sCustt,sDeptf,sDeptt,sMagbn) <= 0 THEN	//24.10.23_SBH_마감구분 추가
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa41
boolean visible = false
integer x = 4018
integer y = 2792
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa41
integer x = 4270
integer y = 0
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sSaupj

IF rb_1.Checked =True THEN
	IF dw_ip.AcceptText() = -1 THEN RETURN
	sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")
	IF ssaupj ="" OR IsNull(ssaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF
	
	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF LsJpyCreateGbn = '1' THEN							/*건별 전표 발생*/
		IF Wf_Insert_Kfz12ot0(sSaupj) = -1 THEN
			Rollback;
			Return
		END IF
	ELSE
		IF Wf_Insert_Kfz12ot0_1(sSaupj) = -1 THEN
			Rollback;
			Return
		END IF
	END IF
	Commit;
	

	//-------------------------------------------------------------------------------------------------------------
	// 24.10.10_SBH_다존 그룹웨어 전자결재 연동 여부
	Long		i, ii
	String		ls_key, ls_keys[], ls_formno, ls_yn
	
	ls_formno = '36'		//양식번호-36 : 매입자동전표
	ls_yn = f_get_syscnfg('G', 1, '1')
	If ls_yn = 'Y' Then

		For i = 1 To dw_rtv.RowCount()
			If dw_rtv.GetItemString(i, 'chk') = '1' Then
				// Unique 조건값, 2개이상이면 구분자(|)로 문자열 조합 => ex) ls_cvcod + '|' + ls_itnbr
				ls_key = dw_rtv.GetItemString(i, 'sabu') + '|' + dw_rtv.GetItemString(i, 'buydt') + '|' + String(dw_rtv.GetItemNumber(i, 'buyno'))
				ii++
				ls_keys[ii] = ls_key
			End If
		Next

		// 그룹웨어 전자결재 상신
		f_gwif_approval(ls_formno, is_window_id, gs_empno, ls_keys)
	End If
	//-------------------------------------------------------------------------------------------------------------

	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa41
integer x = 2144
end type

type cb_mod from w_inherite`cb_mod within w_kifa41
integer x = 1797
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa41
integer x = 2455
integer y = 2760
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa41
integer x = 2871
integer y = 2584
end type

type cb_inq from w_inherite`cb_inq within w_kifa41
integer x = 1435
end type

type cb_print from w_inherite`cb_print within w_kifa41
integer x = 2871
integer y = 2700
end type

type st_1 from w_inherite`st_1 within w_kifa41
end type

type cb_can from w_inherite`cb_can within w_kifa41
integer x = 3218
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kifa41
integer x = 910
integer width = 498
string text = "품목보기(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa41
integer x = 2811
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa41
integer x = 855
integer y = 2724
integer width = 1664
end type

type gb_1 from groupbox within w_kifa41
integer x = 3429
integer width = 384
integer height = 224
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

type rb_1 from radiobutton within w_kifa41
integer x = 3465
integer y = 56
integer width = 320
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
string text = "전표발행"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="매입 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa41
integer x = 3465
integer y = 128
integer width = 320
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
string text = "전표삭제"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="매입 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kifa41
event ue_key pbm_dwnkey
integer x = 37
integer y = 8
integer width = 3365
integer height = 236
integer taborder = 20
string dataobject = "d_kifa411"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

w_mdi_frame.sle_msg.text = ''

IF this.GetColumnName() ="sabu" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[매입사업장]")
		dw_ip.SetItem(1,"sabu",snull)
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
	IF LsJpyCreateGbn = '2' THEN
		this.SetItem(1,"saledtt",sDate)
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
//		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"custf",    sNull)
		this.SetItem(1,"custfname",sNull)
		Return 
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
//		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"custt",    sNull)
		this.SetItem(1,"custtname",sNull)
		Return 
	ELSE
		this.SetItem(1,"custtname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "deptf" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN 
		this.SetItem(1,"deptfname",snull)
		RETURN
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[매입부서]')
		this.SetItem(1,"deptf",snull)
		this.SetItem(1,"deptfname",snull)
		Return 
	END IF
	this.SetItem(1,"deptfname",sDeptName)

	//24.10.23_SBH_to매입부서 자동 지정
	this.SetItem(1,"deptt",sdeptCode)
	this.SetItem(1,"depttname",sDeptName)
END IF

IF this.GetColumnName() = "deptt" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN 
		this.SetItem(1,"depttname",snull)
		RETURN
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[매입부서]')
		this.SetItem(1,"deptt",snull)
		this.SetItem(1,"depttname",snull)
		Return 
	END IF
	this.SetItem(1,"depttname",sDeptName)
END IF

//IF this.GetColumnName() ="chose" THEN
//	sChoose = this.GetText()
//	
//	IF rb_1.Checked =True THEN
//		IF sChoose ='1' THEN
//			sle_msg.text = '자료 선택 중...'
//			FOR i =1 TO dw_rtv.Rowcount()
//				IF Wf_Chk_ValidData(i) = -1 THEN 
//					dw_rtv.SetItem(i,"chk",'0')
//				ELSE
//					dw_rtv.SetItem(i,"chk",'1')	
//				END IF
//			NEXT
//		ELSEIF sChoose ='2' THEN
//			FOR i =1 TO dw_rtv.Rowcount()
//				dw_rtv.SetItem(i,"chk",'0')
//			NEXT
//		END IF
//	ELSEIF rb_2.Checked =True THEN
//		IF sChoose ='1' THEN
//			FOR i =1 TO dw_delete.Rowcount()
//				dw_delete.SetItem(i,"chk",'1')
//			NEXT
//		ELSEIF sChoose ='2' THEN
//			FOR i =1 TO dw_delete.Rowcount()
//				dw_delete.SetItem(i,"chk",'0')
//			NEXT
//		END IF
//	END IF
//END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="custf" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "custf")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custfname", lstr_custom.name)
ELSEIF this.GetColumnName() ="custt" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "custt")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custtname", lstr_custom.name)
ELSEIF this.GetColumnName() ="deptf" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "deptf")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"deptfname", lstr_custom.name)
	
	//24.10.23_SBH_to매입부서 자동 지정
	dw_ip.SetItem(dw_ip.GetRow(),"deptt", 		lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"depttname", lstr_custom.name)

ELSEIF this.GetColumnName() ="deptt" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "deptt")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"depttname", lstr_custom.name)
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kifa41
boolean visible = false
integer x = 114
integer y = 2544
integer width = 1033
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

type dw_sungin from datawindow within w_kifa41
boolean visible = false
integer x = 114
integer y = 2652
integer width = 1029
integer height = 96
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

type dw_detail from datawindow within w_kifa41
boolean visible = false
integer x = 1166
integer y = 2644
integer width = 1225
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "계정별 품목 상세"
string dataobject = "d_kifa415"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vat from datawindow within w_kifa41
boolean visible = false
integer x = 114
integer y = 2748
integer width = 1029
integer height = 96
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

type dw_print from datawindow within w_kifa41
boolean visible = false
integer x = 114
integer y = 2844
integer width = 1029
integer height = 96
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

type dw_group_detail from datawindow within w_kifa41
boolean visible = false
integer x = 1170
integer y = 2540
integer width = 1225
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "계정별 합"
string dataobject = "d_kifa414"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kifa41
boolean visible = false
integer x = 114
integer y = 2936
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

type rr_1 from roundrectangle within w_kifa41
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4562
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kifa41
integer x = 3840
integer y = 160
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

type dw_rtv from datawindow within w_kifa41
integer x = 64
integer y = 256
integer width = 4530
integer height = 1968
integer taborder = 30
string dataobject = "d_kifa412"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String  sChk,sCust,sMaYm
Integer iCount
Long    lseq

IF this.GetColumnName() = "chk" THEN
	sChk = this.GetText()
	IF sChk = "" OR IsNull(sChk) THEN Return
	
	IF sChk = '1' THEN
		sCust = this.GetItemString(this.GetRow(),"cvcod")
		sMaYm = this.GetItemString(this.GetRow(),"mayymm")
		lSeq  = this.GetItemNumber(this.GetRow(),"mayyseq")

		SELECT Count(*)     INTO :iCount    
    		FROM "KIF01OT1"  
   		WHERE ( "KIF01OT1"."MAYYMM"  = :sMaYm ) AND ( "KIF01OT1"."MAYYSEQ" = :lSeq ) AND  
         		( "KIF01OT1"."CVCOD"   = :sCust ) AND
					( "KIF01OT1"."ACCODE" is null OR "KIF01OT1"."ACCODE" = '');

		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		
		IF iCount > 0 THEN
			F_MessageChk(1,'[품목별 계정과목]')
			Return 1
		END IF
	END IF
END IF
end event

type dw_delete from datawindow within w_kifa41
integer x = 64
integer y = 256
integer width = 4530
integer height = 1968
integer taborder = 40
string dataobject = "d_kifa413"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

	
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String  sChk,sCust,sMaYm
Integer iCount
Long    lseq

IF this.GetColumnName() = "chk" THEN
	sChk = this.GetText()
	IF sChk = "" OR IsNull(sChk) THEN Return
	
	IF sChk = '1' THEN
		sCust = this.GetItemString(this.GetRow(),"cvcod")
		sMaYm = this.GetItemString(this.GetRow(),"mayymm")
		lSeq  = this.GetItemNumber(this.GetRow(),"mayyseq")

		select Count(*)	into :iCount    
			from kif01ot1
			where (mayymm =  :sMaYm and mayyseq = :lSeq and cvcod =  :sCust) and
					(accode is null or accode = '');
		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		
		IF iCount > 0 THEN
			F_MessageChk(1,'[품목별 계정과목]')
			Return 1
		END IF
	END IF
END IF
end event

