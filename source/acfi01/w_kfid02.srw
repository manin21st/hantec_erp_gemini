$PBExportHeader$w_kfid02.srw
$PBExportComments$받을어음 인수 전표 처리
forward
global type w_kfid02 from w_inherite
end type
type gb_1 from groupbox within w_kfid02
end type
type rb_1 from radiobutton within w_kfid02
end type
type rb_2 from radiobutton within w_kfid02
end type
type dw_ip from u_key_enter within w_kfid02
end type
type dw_junpoy from datawindow within w_kfid02
end type
type dw_sungin from datawindow within w_kfid02
end type
type dw_print from datawindow within w_kfid02
end type
type dw_bill from datawindow within w_kfid02
end type
type st_2 from statictext within w_kfid02
end type
type st_3 from statictext within w_kfid02
end type
type dw_find from u_key_enter within w_kfid02
end type
type rr_1 from roundrectangle within w_kfid02
end type
type dw_rtv from u_d_popup_sort within w_kfid02
end type
type dw_delete from datawindow within w_kfid02
end type
end forward

global type w_kfid02 from w_inherite
string title = "받을어음 인수 전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_bill dw_bill
st_2 st_2
st_3 st_3
dw_find dw_find
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kfid02 w_kfid02

type variables

String sUpmuGbn = 'A',LsAutoSungGbn,LsCreateGbn
end variables

forward prototypes
public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0_2 (string ssaupj, string sempno, string sbaldate)
public function integer wf_insert_kfz12ot0_1 (string ssaupj, string sempno, string sbaldate)
end prototypes

public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno);Integer iCurRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+&
					       String(lJunNo,'0000')+String(lLinNo,'000')
					 
iCurRow = dw_bill.InsertRow(0)

dw_bill.SetItem(iCurRow,"saupj",			sSaupj)
dw_bill.SetItem(iCurRow,"bal_date",		sBalDate)
dw_bill.SetItem(iCurRow,"upmu_gu",		sUpmuGbn)
dw_bill.SetItem(iCurRow,"bjun_no",		lJunNo)
dw_bill.SetItem(iCurRow,"lin_no",		lLinNo)
dw_bill.SetItem(iCurRow,"full_junno",	sFullJunNo)

//dw_bill.SetItem(iCurRow,"mbal_date",	sBalDate)
//dw_bill.SetItem(iCurRow,"mupmu_gu",		sUpmuGbn)
//dw_bill.SetItem(iCurRow,"mjun_no",		lJunNo)
//dw_bill.SetItem(iCurRow,"mlin_no",		lLinNo)
	
dw_bill.SetItem(iCurRow,"bill_no",				dw_rtv.GetItemString(iRow,"bill_no"))
dw_bill.SetItem(iCurRow,"saup_no",				dw_rtv.GetItemString(iRow,"saup_no"))
dw_bill.SetItem(iCurRow,"bnk_cd",				dw_rtv.GetItemString(iRow,"bnk_cd"))
dw_bill.SetItem(iCurRow,"bbal_dat",				dw_rtv.GetItemString(iRow,"bbal_dat"))
dw_bill.SetItem(iCurRow,"bman_dat",				dw_rtv.GetItemString(iRow,"bman_dat"))
dw_bill.SetItem(iCurRow,"bill_amt",				dw_rtv.GetItemNumber(iRow,"bill_amt"))
dw_bill.SetItem(iCurRow,"bill_nm",				dw_rtv.GetItemString(iRow,"bill_nm"))
dw_bill.SetItem(iCurRow,"bill_ris",				dw_rtv.GetItemString(iRow,"bill_ris"))
dw_bill.SetItem(iCurRow,"bill_gu",				dw_rtv.GetItemString(iRow,"bill_gu"))
dw_bill.SetItem(iCurRow,"bill_jigu",			dw_rtv.GetItemString(iRow,"bill_jigu"))
dw_bill.SetItem(iCurRow,"chu_ymd",				dw_rtv.GetItemString(iRow,"chu_ymd"))
dw_bill.SetItem(iCurRow,"chu_bnk",				dw_rtv.GetItemString(iRow,"chu_bnk"))
dw_bill.SetItem(iCurRow,"status",				'8')
dw_bill.SetItem(iCurRow,"bill_ntinc",			dw_rtv.GetItemString(iRow,"bill_ntinc"))
dw_bill.SetItem(iCurRow,"budo_amt",				dw_rtv.GetItemNumber(iRow,"budo_amt"))
dw_bill.SetItem(iCurRow,"bill_change_date",	sBalDate)
dw_bill.SetItem(iCurRow,"temp_bill_yn",		dw_rtv.GetItemString(iRow,"temp_bill_yn"))
dw_bill.SetItem(iCurRow,"limit_aplgbn",		dw_rtv.GetItemString(iRow,"limit_aplgbn"))

dw_bill.SetItem(iCurRow,"owner_saupj",			sSaupj)

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i
String  sSaupj,sBalDate,sUpmuGu
Long    lJunNo

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
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
		
		DELETE FROM "KFZ12OT3"  										/*전표송부내역 삭제*/
			WHERE ( "KFZ12OT3"."SAUPJ"    = :sSaupj ) AND  
					( "KFZ12OT3"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT3"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT3"."JUN_NO"   = :lJunNo )   ;
	END IF
NEXT

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
//	//stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0_2 (string ssaupj, string sempno, string sbaldate);/************************************************************************************/
/* 받을어음 중 인수할 자료를 읽어서 인수 처리하고 전표 처리한다.(전표를 하나로 묶어서)*/
/* 1. 대변 : 본지점계정으로 발생.(환경파일 A-1-68)												*/
/* 2. 차변 : 대상사업장의 어음 계정으로 발생.													*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sDeptCode,sCusGbn,sChaDae,sSangGbn,&
			sAccDate,sAlcGbn,sGbn1,sFromSaupj
Integer  k,lLinNo,iCurRow
Long     lJunNo,lAccJunNo
Double   dAmount

SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2)						/*받을어음*/
	INTO :sAcc1_Cha,  				:sAcc2_Cha	
   FROM "SYSCNFG"  
   WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND  ( "LINENO" = '23' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[받을어음 계정]')
	Return -1
END IF
IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

/*부서*/
select deptcode into :sDeptCode from p1_master where empno = :sEmpNo ;
IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(sDeptCode) OR sDeptCode = '' then
		F_MessageChk(20,'[작성자-소속부서]')
		Return -1
	END IF
ELSE
	F_MessageChk(20,'[작성자-소속부서]')
	Return -1
END IF

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

w_mdi_frame.sle_msg.text ="받을어음 인수 전표 처리 중 ..."

SetPointer(HourGlass!)

dw_junpoy.Reset()
dw_bill.Reset()

FOR k = 1 TO dw_rtv.RowCount()	
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN			
		dAmount   = dw_rtv.GetItemNumber(k,"bill_amt")
		IF IsNull(dAmount) THEN dAmount = 0	
					
		/*반제처리 여부,차대*/
		SELECT "CUS_GU",	"GBN1",		"DC_GU"      
			INTO :sCusGbn,	:sGbn1,		:sChaDae	
			FROM "KFZ01OM0"  
			WHERE ("ACC1_CD" = :sAcc1_Cha) AND ("ACC2_CD" = :sAcc2_Cha) ;
				
		sDcGbn = '1'											
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
		dw_junpoy.SetItem(iCurRow,"descr",   '어음 인수')	
		
		IF sCusGbn = 'Y' THEN
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupname"))
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no",    dw_rtv.GetItemString(k,"bill_no"))
		dw_junpoy.SetItem(iCurRow,"k_eymd",     dw_rtv.GetItemString(k,"bman_dat"))
		
		IF Wf_Insert_Kfz12otd(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'N')
			Return -1
		ELSE
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y')
		END IF
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		lLinNo = lLinNo + 1
		
		sFromSaupj = dw_rtv.GetItemString(k,"saupj")
		
		sDcGbn = '2'											/*대변 전표*/
				
		select substr(a.rfna3,1,5), 	substr(a.rfna3,6,2),	b.cus_gu, 	b.gbn1, 		b.dc_gu
			into :sAcc1_Dae,		  	 	:sAcc2_Dae,				:sCusGbn,	:sGbn1,		:sChaDae	
			from reffpf a, kfz01om0 b
			where a.rfcod = 'AD' and a.rfgub = :sFromSaupj and
					substr(a.rfna3,1,5) = b.acc1_cd and
					substr(a.rfna3,6,2) = b.acc2_cd ;
		
		iCurRow = dw_junpoy.InsertRow(0)

		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
		dw_junpoy.SetItem(iCurRow,"descr",   '어음 인수')	
		
		IF sCusGbn = 'Y' THEN
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupname"))
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1
		
		dw_rtv.SetItem(k,"new_junno", sSaupj+'-'+String(sBalDate,'@@@@.@@.@@')+'-'+sUpmuGbn+'-'+String(lJunNo,'0000'))
	END IF
NEXT
IF dw_bill.Update() <> 1 THEN
	F_MessageChk(13,'[받을어음]')
	SetPointer(Arrow!)
	Return -1
ELSE
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		Return -1
	END IF
	/*자동 승인 처리*/
	IF LsAutoSungGbn = 'Y' THEN
		w_mdi_frame.sle_msg.text = '승인 처리 중...'
		F_Insert_SungIn(dw_junpoy,dw_sungin)
	END IF
END IF

w_mdi_frame.sle_msg.text ="받을어음 인수 전표 처리 완료!!"

Return 1
end function

public function integer wf_insert_kfz12ot0_1 (string ssaupj, string sempno, string sbaldate);/************************************************************************************/
/* 받을어음 중 인수할 자료를 읽어서 인수 처리하고 전표 처리한다.(어음하나=전표하나) */
/* 1. 대변 : 본지점계정으로 발생.(환경파일 A-1-68)												*/
/* 2. 차변 : 대상사업장의 어음 계정으로 발생.													*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sDeptCode,sCusGbn,sChaDae,sSangGbn,&
			sAccDate,sAlcGbn,sGbn1,sRemark1,sFromSaupj
Integer  k,lLinNo,iCurRow
Long     lJunNo,lAccJunNo
Double   dAmount

SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2)						/*받을어음*/
	INTO :sAcc1_Cha,  				:sAcc2_Cha	
   FROM "SYSCNFG"  
   WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND  ( "LINENO" = '23' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[받을어음 계정]')
	Return -1
END IF

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

/*부서*/
select deptcode into :sDeptCode from p1_master where empno = :sEmpNo ;
IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(sDeptCode) OR sDeptCode = '' then
		F_MessageChk(20,'[작성자-소속부서]')
		Return -1
	END IF
ELSE
	F_MessageChk(20,'[작성자-소속부서]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="받을어음 인수 전표 처리 중 ..."

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()	
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN			
		dw_junpoy.Reset()
		dw_bill.Reset()
		
		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1

		dAmount    = dw_rtv.GetItemNumber(k,"bill_amt")
		IF IsNull(dAmount) THEN dAmount = 0	
		
		/*반제처리 여부,차대*/
		SELECT "CUS_GU",	"GBN1",		"DC_GU"    
			INTO :sCusGbn,	:sGbn1,		:sChaDae
			FROM "KFZ01OM0"  
			WHERE ("ACC1_CD" = :sAcc1_Cha) AND ("ACC2_CD" = :sAcc2_Cha) ;
				
		sDcGbn = '1'											
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)	
		dw_junpoy.SetItem(iCurRow,"descr",   '어음 인수')	
		
		IF sCusGbn = 'Y' THEN
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupname"))
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no",    dw_rtv.GetItemString(k,"bill_no"))
		dw_junpoy.SetItem(iCurRow,"k_eymd",     dw_rtv.GetItemString(k,"bman_dat"))
		
		IF Wf_Insert_Kfz12otd(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'N')
			Return -1
		ELSE
			dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y')
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		lLinNo = lLinNo + 1
		
		sFromSaupj = dw_rtv.GetItemString(k,"saupj")
		
		sDcGbn = '2'											/*대변 전표*/
				
		select substr(a.rfna3,1,5), 	substr(a.rfna3,6,2),	b.cus_gu, 	b.gbn1, 		b.dc_gu
			into :sAcc1_Dae,		  	 	:sAcc2_Dae,				:sCusGbn,	:sGbn1,		:sChaDae	
			from reffpf a, kfz01om0 b
			where a.rfcod = 'AD' and a.rfgub = :sFromSaupj and
					substr(a.rfna3,1,5) = b.acc1_cd and
					substr(a.rfna3,6,2) = b.acc2_cd ;	
	
		iCurRow = dw_junpoy.InsertRow(0)

		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
		dw_junpoy.SetItem(iCurRow,"descr",   '어음 인수 ['+f_get_refferance('AD',sFromSaupj)+']')	
		
		IF sCusGbn = 'Y' THEN
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupname"))
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1
			
		dw_rtv.SetItem(k,"new_junno", sSaupj+'-'+String(sBalDate,'@@@@.@@.@@')+'-'+sUpmuGbn+'-'+String(lJunNo,'0000'))
		
		IF dw_bill.Update() <> 1 THEN
			F_MessageChk(13,'[받을어음]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_junpoy.Update() <> 1 THEN
				F_MessageChk(13,'[미승인전표]')
				SetPointer(Arrow!)
				Return -1
			END IF
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				F_Insert_SungIn(dw_junpoy,dw_sungin)
			END IF
			
		END IF
	END IF
NEXT

w_mdi_frame.sle_msg.text ="받을어음 인수 전표 처리 완료!!"

Return 1
end function

on w_kfid02.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_bill=create dw_bill
this.st_2=create st_2
this.st_3=create st_3
this.dw_find=create dw_find
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_bill
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.dw_find
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.dw_rtv
this.Control[iCurrent+14]=this.dw_delete
end on

on w_kfid02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_bill)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_find)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"from_saupj",gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"empno",     gs_empno)
dw_ip.SetItem(dw_ip.Getrow(),"empname",   F_Get_PersonLst('4',gs_empno,'%'))
dw_ip.SetItem(dw_ip.Getrow(),"baldate",   f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_bill.SetTransObject(SQLCA)

dw_find.SetTransObject(SQLCA)
dw_find.Reset()
dw_find.InsertRow(0)

P_mod.Enabled =False
p_mod.PictureName = 'c:\erpman\image\처리_d.gif'

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 22 ) AND  
         ( "SYSCNFG"."LINENO" = '02' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

SELECT substr("SYSCNFG"."DATANAME",1,1)      INTO :LsCreateGbn  		/*전표번호 생성 방법*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 22 ) AND  
         ( "SYSCNFG"."LINENO" = '03' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsCreateGbn = '1'
ELSE
	IF IsNull(LsCreateGbn) THEN LsCreateGbn = '1'
END IF

IF F_Authority_Fund_Chk(Gs_Dept)	 = -1 THEN							/*권한 체크- 현업 여부*/	
	dw_ip.Modify("from_saupj.protect = 1")
ELSE
	dw_ip.Modify("from_saupj.protect = 0")
END IF	

dw_ip.SetColumn("baldate")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kfid02
boolean visible = false
integer x = 1518
integer y = 2668
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfid02
boolean visible = false
integer x = 3593
integer y = 3200
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfid02
boolean visible = false
integer x = 3419
integer y = 3200
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfid02
boolean visible = false
integer x = 2889
integer y = 3208
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfid02
boolean visible = false
integer x = 3246
integer y = 3200
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfid02
integer x = 4453
integer y = 0
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kfid02
boolean visible = false
integer x = 3945
integer y = 3204
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfid02
boolean visible = false
integer x = 3063
integer y = 3208
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfid02
integer x = 4105
integer y = 0
integer height = 140
end type

event p_inq::clicked;call super::clicked;String sFromSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN

sFromSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"from_saupj")
IF sFromsaupj ="" OR IsNull(sFromsaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("from_saupj")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sFromSaupj,'6') <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sFromSaupj,'8') <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_mod.PictureName = 'c:\erpman\image\처리_up.gif'

dw_ip.SetItem(dw_ip.GetRow(),"chose",'2')
end event

type p_del from w_inherite`p_del within w_kfid02
boolean visible = false
integer x = 3771
integer y = 3204
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfid02
integer x = 4279
integer y = 0
integer taborder = 60
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;
IF rb_1.Checked =True THEN
	String sFromSaupj,sEmpNo,sBalDate

	dw_ip.AcceptText()
	sFromSaupj = dw_ip.GetItemString(dw_ip.GetRow(),"from_saupj")
	sEmpNo     = dw_ip.GetItemString(dw_ip.GetRow(),"empno")
	sBalDate   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"baldate"))
	
	IF sFromsaupj ="" OR IsNull(sFromsaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("from_saupj")
		dw_ip.SetFocus()
		Return 
	END IF
	IF sEmpNo ="" OR IsNull(sEmpNo) THEN
		F_MessageChk(1,'[작성자]')	
		dw_ip.SetColumn("empno")
		dw_ip.SetFocus()
		Return 
	END IF
	IF sBaldate ="" OR IsNull(sBaldate) THEN
		F_MessageChk(1,'[처리일자]')	
		dw_ip.SetColumn("baldate")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_rtv.RowCount() <=0 THEN Return
	IF dw_rtv.GetItemNumber(1,"yescnt") <=0 THEN Return
	
	IF LsCreateGbn = '1' THEN											/*어음1개 = 전표번호 1개*/
		IF Wf_Insert_Kfz12ot0_1(sFromSaupj,sEmpNo,sBalDate) = -1 THEN
			Rollback;
			Return
		END IF
	ELSE																		/*전표에 묶어서*/
		IF Wf_Insert_Kfz12ot0_2(sFromSaupj,sEmpNo,sBalDate) = -1 THEN
			Rollback;
			Return
		END IF
	END IF
	Commit;
	
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

type cb_exit from w_inherite`cb_exit within w_kfid02
boolean visible = false
integer x = 2711
integer y = 2776
end type

type cb_mod from w_inherite`cb_mod within w_kfid02
boolean visible = false
integer x = 2350
integer y = 2776
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kfid02
boolean visible = false
integer x = 2464
integer y = 2588
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfid02
boolean visible = false
integer x = 2871
integer y = 2584
end type

type cb_inq from w_inherite`cb_inq within w_kfid02
boolean visible = false
integer x = 1989
integer y = 2776
end type

type cb_print from w_inherite`cb_print within w_kfid02
boolean visible = false
integer x = 2702
integer y = 2428
end type

event cb_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sCvcod,sMaYm,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lSeqNo
Integer i,iRtnVal

IF MessageBox("확 인", "출력하시겠습니까?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

IF LsCreateGbn = '1' THEN
	FOR i = 1 TO dw_rtv.RowCount()
		IF dw_rtv.GetItemString(i,"chk") = '1' THEN
			sSaupj   = dw_rtv.GetItemString(i,"saupj")
			sBalDate = dw_rtv.GetItemString(i,"bal_date") 
			sUpmuGu  = dw_rtv.GetItemString(i,"upmu_gu") 
			lBJunNo  = dw_rtv.GetItemNumber(i,"bjun_no") 
			
			iRtnVal = F_Call_JunpoyPrint(dw_print,LsAutoSungGbn,sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
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
ELSE
	sSaupj   = dw_junpoy.GetItemString(1,"saupj")
	sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
	sUpmuGu  = dw_junpoy.GetItemString(1,"upmu_gu") 
	lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 
			
	iRtnVal = F_Call_JunpoyPrint(dw_print,LsAutoSungGbn,sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
	IF iRtnVal = -1 THEN
		F_MessageChk(14,'')
		Return -1
	ELSEIF iRtnVal = -2 THEN
		Return 1
	ELSE	
		sPrtGbn = '1'
	END IF
END IF
end event

type st_1 from w_inherite`st_1 within w_kfid02
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfid02
boolean visible = false
integer x = 3218
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kfid02
boolean visible = false
integer x = 1947
integer y = 2588
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kfid02
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfid02
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfid02
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfid02
boolean visible = false
integer x = 2811
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kfid02
boolean visible = false
integer x = 1952
integer y = 2720
integer width = 1134
end type

type gb_1 from groupbox within w_kfid02
integer x = 4123
integer y = 132
integer width = 498
integer height = 156
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kfid02
integer x = 4210
integer y = 168
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "인수처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Visible =True
	dw_delete.Visible =False
	
	st_3.Visible = False
	
	dw_find.Visible = True
	dw_find.SetRedraw(False)
	dw_find.Reset()
	dw_find.InsertRow(0)
	dw_find.SetRedraw(True)
END IF
dw_rtv.Reset()

dw_ip.SetColumn("from_saupj")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kfid02
integer x = 4210
integer y = 224
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "인수취소"
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_2.Checked =True THEN
	dw_rtv.Visible =False
	
	IF LsCreateGbn = '1' THEN								/*어음1=전표1*/
		dw_delete.DataObject = 'd_kfid023'
		st_3.Visible = False
	ELSE
		dw_delete.DataObject = 'd_kfid024'
		st_3.Visible = True
	END IF
	dw_delete.SetTransObject(Sqlca)
	dw_delete.Reset()
	
	dw_delete.Visible =True
	
	dw_find.Visible = False
	
END IF
dw_delete.Reset()

dw_ip.SetColumn("from_saupj")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kfid02
event ue_key pbm_dwnkey
integer x = 55
integer y = 20
integer width = 2327
integer height = 284
integer taborder = 20
string dataobject = "d_kfid021"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sEmpNo,sChoose,sEmpName
Integer i

SetNull(snull)

sle_msg.text = ''

IF this.GetColumnName() ="from_saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[대상사업장]")
		dw_ip.SetItem(1,"from_saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="to_saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[인수할사업장]")
		dw_ip.SetItem(1,"to_saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"처리일자")
		dw_ip.SetItem(1,"baldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "empno" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN 
		this.SetItem(1,"empname",snull)
		Return
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sEmpName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sEmpNo) AND ( "KFZ04OM0"."PERSON_GU" = '4');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[처리자]')
		this.SetItem(1,"empno",    sNull)
		this.SetItem(1,"empname",  sNull)
		Return 1
	ELSE
		this.SetItem(1,"empname",sEmpName)
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

IF this.GetColumnName() ="empno" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'4')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"empno",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"empname",   lstr_custom.name)
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kfid02
boolean visible = false
integer x = 123
integer y = 2260
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

type dw_sungin from datawindow within w_kfid02
boolean visible = false
integer x = 123
integer y = 2368
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

type dw_print from datawindow within w_kfid02
boolean visible = false
integer x = 123
integer y = 2464
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

type dw_bill from datawindow within w_kfid02
boolean visible = false
integer x = 1157
integer y = 2460
integer width = 818
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "어음내역 저장"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type st_2 from statictext within w_kfid02
boolean visible = false
integer x = 87
integer y = 1948
integer width = 1111
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 8421504
boolean enabled = false
string text = "* 상세한 자료를 보려면 더블클릭하세요..."
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_3 from statictext within w_kfid02
boolean visible = false
integer x = 279
integer y = 2772
integer width = 1111
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 8421504
boolean enabled = false
string text = "* 상세한 자료를 보려면 더블클릭하세요..."
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type dw_find from u_key_enter within w_kfid02
integer x = 2377
integer y = 52
integer width = 1696
integer height = 236
integer taborder = 40
string dataobject = "dw_kglb01d1_5"
boolean border = false
end type

event buttonclicked;String sBillNoF,sBillNoT,sFromDate,sToDate,sBillAmt,sFindString

IF dwo.name = 'dcb_find' THEN
	this.AcceptText()
	sBillNoF  = this.GetItemString(1,"from_billno")
	sBillNoT  = this.GetItemString(1,"to_billno")
	sFromDate = Trim(this.GetItemString(1,"from_mandate"))
	sToDate   = Trim(this.GetItemString(1,"to_mandate"))
	
	IF sBillNoF = '' OR IsNull(sBillNoF) THEN sBillNoF = '0'
	IF sBillNoT = '' OR IsNull(sBillNoT) THEN sBillNoT = 'z'
	IF sFromDate = '' OR IsNull(sFromDate) THEN sFromDate = '00000000'
	IF sToDate = '' OR IsNull(sToDate) THEN sToDate = '99999999'
	
	dw_rtv.SetRedraw(False)
	
	IF this.GetItemNumber(1,"billamt") = 0 OR IsNull(this.GetItemNumber(1,"billamt")) THEN
		sFindString = "bill_no >= '"+sBillNoF+"' and bill_no <= '"+sBillNoT +"' and bman_dat >= '"+sFromDate+"' and bman_dat <= '"+sToDate+"'" 
		dw_rtv.SetFilter(sFindString)
		dw_rtv.Filter()
	ELSE
		sBillAmt = String(this.GetItemNumber(1,"billamt"))
		
		sFindString = "bill_no >= '"+sBillNoF+"' and bill_no <= '"+sBillNoT +"' and bman_dat >= '"+sFromDate+"' and bman_dat <= '"+sToDate+"' and str_billamt = '"+sBillAmt+"'"
		dw_rtv.SetFilter(sFindString)
		dw_rtv.Filter()		
	END IF
	dw_rtv.SetRedraw(True)
END IF

end event

event rbuttondown;IF this.GetColumnName() ="from_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"from_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"from_billno",Gs_Code)
END IF

IF this.GetColumnName() ="to_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"to_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"to_billno",Gs_Code)
END IF
end event

type rr_1 from roundrectangle within w_kfid02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 308
integer width = 4549
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from u_d_popup_sort within w_kfid02
integer x = 82
integer y = 312
integer width = 4521
integer height = 1888
integer taborder = 30
string dataobject = "d_kfid022"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag = True
ELSe
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_delete from datawindow within w_kfid02
integer x = 82
integer y = 312
integer width = 4521
integer height = 1888
integer taborder = 50
string dataobject = "d_kfid023"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;
IF Row <=0 THEN Return

IF LsCreateGbn = '2' THEN
	OpenWithParm(w_kfid01a, String(Integer(this.GetItemString(row,"saupj")),'00')+&
								  this.GetItemString(row,"bal_date")+this.GetItemString(row,"upmu_gu")+&
								  String(this.GetItemNumber(row,"bjun_no"),'0000'))
END IF
end event

