$PBExportHeader$w_kifa14.srw
$PBExportComments$�ڵ���ǥ ���� : ����
forward
global type w_kifa14 from w_inherite
end type
type gb_1 from groupbox within w_kifa14
end type
type rb_1 from radiobutton within w_kifa14
end type
type rb_2 from radiobutton within w_kifa14
end type
type dw_junpoy from datawindow within w_kifa14
end type
type dw_sungin from datawindow within w_kifa14
end type
type dw_vat from datawindow within w_kifa14
end type
type dw_print from datawindow within w_kifa14
end type
type dw_detail from datawindow within w_kifa14
end type
type dw_ip from u_key_enter within w_kifa14
end type
type dw_sunsulst from datawindow within w_kifa14
end type
type dw_sang from datawindow within w_kifa14
end type
type rr_1 from roundrectangle within w_kifa14
end type
type cbx_all from checkbox within w_kifa14
end type
type dw_rtv from datawindow within w_kifa14
end type
type dw_delete from datawindow within w_kifa14
end type
end forward

global type w_kifa14 from w_inherite
integer height = 2416
string title = "������ǥ ó��"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_vat dw_vat
dw_print dw_print
dw_detail dw_detail
dw_ip dw_ip
dw_sunsulst dw_sunsulst
dw_sang dw_sang
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa14 w_kifa14

type variables
Long       lDbErrCode =0                      /*db error�� ���� üũ*/
String sUpmuGbn = 'L',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_sang (string ssabu, string scino, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno)
public subroutine wf_calculation_chaik (integer icurrow, string ssaupj, string sngno, ref double dchasonamt, ref double dchaikamt)
public function integer wf_insert_kfz12ot0 (string ssaupj)
public function integer wf_insert_cha (integer irow, string scino, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik)
public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno)
end prototypes

public function integer wf_requiredchk (integer irow);String sAcCode,sVatGbn,sChkGbn

dw_rtv.AcceptText()
sChkGbn = dw_rtv.GetItemString(iRow,"chk")
sAcCode = dw_rtv.GetItemString(iRow,"saccod")
sVatGbn = dw_rtv.GetItemString(iRow,"vatgu")

IF sChkGbn = '1' THEN										/*ó������*/
	IF sAcCode = "" OR IsNull(sAcCode) THEN
		F_MessageChk(1,'[������]')
		dw_rtv.ScrollToRow(iRow)
		dw_rtv.SetColumn("saccod")
		dw_rtv.SetFocus()
		Return -1
	END IF
	
	IF sVatGbn = "" OR IsNull(sVatGbn) THEN
		F_MessageChk(1,'[�ΰ�������]')
		dw_rtv.ScrollToRow(iRow)
		dw_rtv.SetColumn("vatgu")
		dw_rtv.SetFocus()
		Return -1
	END IF
END IF

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
		IF iRowCount <=0 THEN 
			MessageBox("Ȯ ��", "������ ��ǥ�� �������� �ʽ��ϴ�.")
			Return -1
		END IF
		
		FOR i = iRowCount TO 1 STEP -1							/*��ǥ ����*/
			dw_junpoy.DeleteRow(i)	
		NEXT
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		END IF
			
		DELETE FROM "KFZ12OT1"  										/*��ǥǰ�ǳ��� ����*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
		/*�����ڷ� ��ǥ ���� ���*/
		UPDATE "KIF05OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null,
				 "DOCGU" = null
		WHERE ( "KIF05OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF05OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF05OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF05OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[�����ڷ�]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*���� ����*/
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
//	//stored procedure�� ������,�ŷ�ó�� ���� ���� ó��(���۳��,������)
//	sle_msg.text ="������,�ŷ�ó�� ������ ����ó�� ���Դϴ�..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//����� ����('00'��)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure�� ����ι��� ���� ���� ó��(���۳��,������)
//	sle_msg.text ="����ι��� ������ ����ó�� ���Դϴ�..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	//stored procedure�� ����ι��� �ŷ�ó�� ���� ó��(���۳��,������)
//	sle_msg.text ="����ι��� �ŷ�ó�� ������ ����ó�� ���Դϴ�..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_sang (string ssabu, string scino, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno);Integer iCount,iInsertRow,k,iLinNoS
Double  dAmount
String  sNgNo,sAcc1,sAcc2,sDcGbn,sSaupjS,sAccDateS,sUpmuS,sBalDateS
Long    lJunNoS,lBJunNoS

dw_sang.Reset()

iCount = dw_sunsulst.Retrieve(sSabu,sCino)
IF iCount <=0 THEN 
	Return -1
END IF

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),"KFZ01OM0"."DC_GU"
	INTO :sAcc1,								 :sAcc2,									 :sDcGbn
	FROM "SYSCNFG","KFZ01OM0"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			( "SYSCNFG"."LINENO" = '62' ) AND
			(SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD") AND
			(SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD") ;
			
FOR k = 1 TO iCount
	sNgNo   = dw_sunsulst.GetItemString(k,"ngno")
	dAmount = dw_sunsulst.GetItemNumber(k,"wamt")
	IF IsNull(dAmount) THEN dAmount = 0
	
	SELECT "KFZ10OT0"."SAUPJ",            "KFZ10OT0"."ACC_DATE",      "KFZ10OT0"."UPMU_GU",   
          "KFZ10OT0"."JUN_NO",           "KFZ10OT0"."LIN_NO",        "KFZ10OT0"."BAL_DATE",   
          "KFZ10OT0"."BJUN_NO"  
		INTO :sSaupjS,   						  :sAccDateS,   			      :sUpmuS,   
           :lJunNoS,   				        :iLinNoS,							:sBalDateS,   
           :lBJunNoS  
		FROM "KIF08OT0",            "KFZ10OT0"  
	   WHERE ( "KIF08OT0"."SABU"     = :sSabu ) AND  
      	   ( "KIF08OT0"."NGNO"     = :snGNo ) AND  
				( "KIF08OT0"."SAUPJ"    = "KFZ10OT0"."SAUPJ" ) and  
   	      ( "KIF08OT0"."BAL_DATE" = "KFZ10OT0"."BAL_DATE" ) and  
      	   ( "KIF08OT0"."UPMU_GU"  = "KFZ10OT0"."UPMU_GU" ) and  
         	( "KIF08OT0"."BJUN_NO"  = "KFZ10OT0"."BJUN_NO" ) and  
//	         ( "KIF08OT0"."LIN_NO"   = "KFZ10OT0"."LIN_NO" ) and  
         	( "KIF08OT0"."ALC_GU"   = 'Y' ) AND  
	         ( "KFZ10OT0"."ACC1_CD"  = :sAcc1  ) AND  
   	      ( "KFZ10OT0"."ACC2_CD"  = :sAcc2 ) AND  
      	   ( "KFZ10OT0"."DCR_GU"   = :sDcGbn ) ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(16,'[�����߻��ڷ� ����]')
		Return -1
	END IF
	
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
NEXT

Return 1

//Integer iCount,iInsertRow,k
//Double  dRemainAmt,dCurAmt,dTempAmt
//
//IF sSangChk = True THEN Return 1
//
///*���� ó�� ȭ�� ����� ó�� (99.10.13 ����)*/
//lstr_jpra.saupjang = ssaupj
//lstr_jpra.baldate  = sbaldate
//lstr_jpra.upmugu   = supmugu
//lstr_jpra.bjunno   = ljunno
//lstr_jpra.sortno   = llinno
//lstr_jpra.saupno   = saupno
//lstr_jpra.acc1     = sacc1
//lstr_jpra.acc2     = sacc2
//lstr_jpra.money    = damount
//				
//OpenWithParm(W_KIFA15A,'')
//IF Message.StringParm = '0' THEN		/*����ó�� ����*/
//	F_MessageChk(17,'[���� ó��]')
//	Return -1
//END IF		
//Return 1
end function

public subroutine wf_calculation_chaik (integer icurrow, string ssaupj, string sngno, ref double dchasonamt, ref double dchaikamt);/************************************************************************/
/**           					��ȯ����/�� ����  	            			  **/
/** 1. ����� > ������																  **/
/**    �ܻ����ݾ� = (�����ȭ - ������ȭ) * ����ȯ��					  **/
/**    ��ȯ���� = ����� - �ܻ����ݾ� - �����ݾ�							  **/
/** 2. ����� < ������																  **/
/**    ��ȯ���� = ����� - ������												  **/
/** 3. ����� = ������																  **/
/**    ��ȯ����,��ȯ���� ����														  **/
/************************************************************************/
Double dMaiChul,dSunSu,dWuiMaiChul,dMaiChulFor,dUAmt,dWrate,dAmount
Integer iCount,k

dMaiChul    = dw_rtv.GetItemNumber(iCurRow,"wamt")										/*����ݾ�*/
IF IsNull(dMaiChul) THEN dMaiChul = 0
dMaiChulFor = dw_rtv.GetItemNumber(iCurRow,"expamt")									/*����ݾ�(��ȭ)*/ 
IF IsNull(dMaiChulFor) THEN dMaiChulFor = 0

iCount = dw_sunsulst.RowCount()
IF iCount > 0 then
	dSunSu = dw_sunsulst.GetItemNumber(1,"sum_wamt")
ELSE
	dSunSu = 0
END IF
IF dMaiChul > dSunSu THEN				
	dWrate   = dw_rtv.GetItemNumber(icurrow,"wrate")
	IF IsNull(dWrate) THEN dWrate = 0
	
	IF iCount > 0 THEN
		dUamt = dw_sunsulst.GetItemNumber(1,"sum_uamt")
		
		dAmount = (dMaiChulFor - dUAmt) * dWRate
		dWuiMaiChul = dWuiMaiChul + dAmount
		dWuiMaiChul = Truncate((dWuiMaiChul + 0.9) / 10 * 10,0)
	ELSE
		dWuiMaiChul = 0
	END IF
	dChaSonAmt = dMaiChul - dWuiMaiChul - dSunSu;			dChaIkAmt = 0;
ELSEIF dMaiChul < dSunSu THEN
	dChaIkAmt = dMaiChul - dSunSu;								dChaSonAmt = 0;
ELSE
	dChaIkAmt = 0;		dChaSonAmt = 0;
END IF

end subroutine

public function integer wf_insert_kfz12ot0 (string ssaupj);/************************************************************************************/
/* �����ڷḦ �ڵ����� ��ǥ ó���Ѵ�.																*/
/* 1. ���� : ������(���� 'EB'�� ������(S)�� ������ �߻�.									*/
/*           ��ȯ�������� �߻�.(�����(C)�� 0���� ������)							 		*/															
/*           	���� - ȯ�������� A-1-16�� 8���� 7�ڸ�											*/
/* 2. �뺯 : ǰ���� �������� �߻�.																	*/
/*           �����ΰ��� �������� �߻�.(ȯ������ A-1-19)										*/
/*           ��ȯ�������� �߻�.(�����(C)�� 0���� ũ��)									*/
/*             ���� - ȯ�������� A-1-16�� 1���� 7�ڸ�											*/
/* * �����ι��� ȯ������(A-20-1)�� �����ι�														*/
/* * ǰ���� �������� ��Ƽ� ó���Ѵ�.																*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sAcCode,sBalDate,sCino,&
			sYesanGbn,sChaDae,sRemark1,sAccDate,sAlcGbn,sSangGbn
Integer  k,iCnt,i,lLinNo,iCurRow,iDetailCnt,iSunSuCnt
Long     lJunNo,lAccJunNo
Double   dAmount,dWuiChaSonAmt,dWuiChaIkAmt

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="���� �ڵ���ǥ ó�� �� ..."

dw_rtv.AcceptText()

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_junpoy.Reset()
		dw_vat.Reset()
		dw_sungin.Reset()

//		sSaupj   = dw_rtv.GetItemString(k,"sabu")
		sCino    = dw_rtv.GetItemString(k,"cino")
		sBalDate = dw_rtv.GetItemString(k,"cidate") 
		sAcCode  = dw_rtv.GetItemString(k,"saccod")
		
		iDetailCnt = dw_detail.Retrieve(sSaupj,sCino)	
		IF iDetailCnt <=0 THEN Continue
		
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(28,'[��������]')
			Continue
		END IF

		/*��ǥ��ȣ ä��*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		FOR i = 1 TO iDetailCnt
			sAcc1_Dae = Left(dw_detail.GetItemString(i,"accod"),5)
			sAcc2_Dae = Right(dw_detail.GetItemString(i,"accod"),2)
			
			sDcGbn = '2'													/*�뺯 ��ǥ*/	
			
			SELECT "DC_GU",			"YESAN_GU",			"REMARK1"
				INTO :sChaDae,			:sYesanGbn,			:sRemark1
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae);
				
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
			dw_junpoy.SetItem(iCurRow,"amt",     dw_detail.GetItemNumber(i,"wonamt"))
			
			//24.12.26_SBH_����� ���� ���� �������� ����
//			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(i,"itdsc") + ' �� '+&
//															 String(dw_detail.GetItemNumber(i,"itemcnt")) + '��' )	
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(i,"descr"))	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvname"))
	
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"curr"))		
			dw_junpoy.SetItem(iCurRow,"y_amt",   dw_detail.GetItemNumber(i,"foramt"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"wrate"))
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",gs_dept)
			END IF
			
			IF i = iDetailCnt THEN
				/*�����ΰ��� ���� ����(�뺯)*/
				IF Wf_Create_Vat(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
					SetPointer(Arrow!)
					Return -1
				ELSE
					dw_junpoy.SetItem(iCurRow,"vat_gu", 'Y') 	
				END IF		
			END IF
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
			lLinNo = lLinNo + 1
		NEXT
	
		iSunSuCnt = dw_sunsulst.Retrieve(sSaupj,sCino)					/*������ ����*/
		IF iSunSuCnt > 0 THEN													/*���� ��ǥ-������(����)*/
			Wf_Calculation_ChaIk(k,sSaupj,sCiNo,dWuiChaSonAmt,dWuiChaIkamt)	/*��ȯ����/�� ���*/
		ELSE
			dWuiChaSonAmt = 0; dWuiChaIkamt = 0;	
		END IF

		/*��ȯ����/�� �߻� �� ������ǥ �߻�*/
		IF Wf_Insert_Cha(k,sCiNo,sSaupj,sBalDate,lJunNo,lLinNo,dWuiChaSonAmt,dWuiChaIkamt) = -1 then 
			Return -1
		END IF
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[����ó�����]')
				Return -1
			END IF			
			
			IF dw_vat.Update() <> 1 THEN
				F_MessageChk(13,'[�ΰ���]')
				Return -1
			END IF		
			
			/*�ڵ� ���� ó��*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '���� ó�� ��...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn = 'N';
				ELSE
					sAccDate  = dw_sungin.GetItemString(1,"acc_date")
					lAccJunNo = dw_sungin.GetItemNumber(1,"jun_no")
					sAlcGbn   = 'Y'
				END IF
			ELSE
				SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn = 'N';
			END IF
			dw_rtv.SetItem(k,"saupj",   sSaupj)
			dw_rtv.SetItem(k,"bal_date",sBalDate)
			dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
			dw_rtv.SetItem(k,"bjun_no", lJunNo)

			dw_rtv.SetItem(k,"acc_date",sAccDate)
			dw_rtv.SetItem(k,"jun_no",  lAccJunNo)
			dw_rtv.SetItem(k,"alc_gu",  sAlcGbn)
		END IF
	END IF
NEXT
			
IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[�����ڷ�]')
	SetPointer(Arrow!)	
	RETURN -1
END IF
COMMIT;

w_mdi_frame.sle_msg.text ="���� ��ǥ ó�� �Ϸ�!!"

Return 1
end function

public function integer wf_insert_cha (integer irow, string scino, string ssaupj, string sbaldate, long ljunno, ref integer llinno, double dchason, double dchaik);/********************************************************************************/
/** ��ȯ����/�� ���� �� ���� ��ǥ ����	  	     					       			    **/
/*  1. ��ȯ����/�� ����																			 **/
/*  2. ���� ��ǥ ����(������):�����ݳ��� <> 0								 			 **/
/*  3. ���� ��ǥ ����(��ȭ�ܻ���߱�):��ȭ�ܻ����ݾ� <> 0							 **/
/********************************************************************************/
Double  dWrate,dCiwRate,dUamt,dAmount = 0,dSunSuAmt,dMaiChulAmt,dSunSuAmtU
Integer iCount,k,iCurRow
String  sAcc_ChaSon,sDcGbn,sAcc1_Cha,sAcc2_Cha,sChaDae,sYesanGbn,sSangGbn,sAccDcr,sRemark1

SELECT "SYSCNFG"."DATANAME"		INTO :sAcc_ChaSon								/*��ȯ����/��*/
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )  ;

dWrate   = dw_rtv.GetItemNumber(irow,"wrate")
IF IsNull(dWrate) THEN dWrate = 0

IF dChaSon <> 0 OR dChaIk <> 0 THEN
	iCurRow = dw_junpoy.InsertRow(0)
	
	IF dChaSon <> 0 THEN										/*��ȯ����*/
		sDcGbn = '1'
					
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sAcc_ChaSon,8,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sAcc_ChaSon,13,2))
		
		SELECT "DC_GU", "YESAN_GU", "REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
			FROM "KFZ01OM0"  
			WHERE ( "ACC1_CD" = Substr(:sAcc_ChaSon,8,5) ) AND 
					( "ACC2_CD" = Substr(:sAcc_ChaSon,13,2));
			
		dAmount = dChaSon
	ELSEIF dChaIk <> 0 THEN									/*��ȯ����*/	
		sDcGbn = '2'
					
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_ChaSon,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sAcc_ChaSon,6,2))
		
		SELECT "DC_GU", "YESAN_GU", "REMARK1"      INTO :sChaDae, :sYesanGbn, :sRemark1
			FROM "KFZ01OM0"  
			WHERE ( "ACC1_CD" = Substr(:sAcc_ChaSon,1,5) ) AND 
					( "ACC2_CD" = Substr(:sAcc_ChaSon,6,2));
					
		dAmount = dChaIk
	END IF
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
						
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
						
	dw_junpoy.SetItem(iCurRow,"amt",     Abs(dAmount))	
	dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(iRow,"curr") + &
													 String(dw_sunsulst.GetItemNumber(1,"sum_uamt"),'###,###,###,##0.00') + '*' + &
													 '(' + String(dWrate,'##,##0.00') + '-' +&
													 String(dw_sunsulst.GetItemNumber(1,"avg_rate"),'##,##0.00')+')')	
	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN			
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF
	
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))
	dw_junpoy.SetItem(iCurRow,"y_amt",   dw_sunsulst.GetItemNumber(1,"sum_uamt"))
	dw_junpoy.SetItem(iCurRow,"y_rate",  dWrate)
	dw_junpoy.SetItem(iCurRow,"k_qty",   dw_sunsulst.GetItemNumber(1,"avg_rate"))
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(iRow,"dept_cd"))
	END IF
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	lLinNo = lLinNo + 1		
END IF

sDcGbn = '1'											/*���� ��ǥ*/

/*���� ��ǥ - ������*/
IF dw_sunsulst.RowCount() <> 0 THEN
	dSunSuAmt = dw_sunsulst.GetItemNumber(1,"sum_wamt")
	IF IsNull(dSunSuAmt) THEN dSunSuAmt = 0

	dSunSuAmtU = dw_sunsulst.GetItemNumber(1,"sum_uamt")
	IF IsNull(dSunSuAmtU) THEN dSunSuAmt = 0
	
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU" ,				 "KFZ01OM0"."DC_GU",
			 "KFZ01OM0"."REMARK1"
		INTO :sAcc1_Cha,							 :sAcc2_Cha,
			  :sSangGbn,							 :sAccDcr,		:sRemark1
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
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
	dw_junpoy.SetItem(iCurRow,"amt",     dSunSuAmt)
	dw_junpoy.SetItem(iCurRow,"descr",   '������ ����' + dw_rtv.GetItemString(iRow,"expno"))	
	
	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN					
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
		
	IF sSangGbn = 'Y' AND sDcGbn <> sAccDcr THEN
		IF Wf_Insert_Sang(dw_rtv.GetItemString(iRow,"sabu"),	&
								dw_rtv.GetItemString(iRow,"cino"),&
								sSaupj,		sBalDate,	sUpmuGbn,	lJunNo,	lLinNo) > 0 THEN							
			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')								/*���� ó��*/
		ELSE
			Return -1
		END IF
	ELSE
		dw_junpoy.SetItem(iCurRow,"cross_gu",'N')									/*���� ó�� ����*/
	END IF
	
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))		
	dw_junpoy.SetItem(iCurRow,"y_amt",   dSunSuAmtU)
	dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(iRow,"wrate"))
	dw_junpoy.SetItem(iCurRow,"k_qty",   dw_sunsulst.GetItemNumber(1,"avg_rate"))
			
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
	lLinNo = lLinNo + 1	
ELSE
	dSunSuAmt = 0;	dSunSuAmtU =0;
END IF

/*���� ��ǥ - ��ȭ�ܻ�����*/
dMaiChulAmt = dw_rtv.GetItemNumber(iRow,"wamt") + Abs(dChaIk) - (dSunSuAmt + Abs(dChaSon)) 
IF IsNull(dMaiChulAmt) THEN dMaichulAmt = 0

IF dMaiChulAmt <> 0 THEN
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),SUBSTR("SYSCNFG"."DATANAME",6,2),
			 "KFZ01OM0"."SANG_GU" ,				 "KFZ01OM0"."DC_GU",			"KFZ01OM0"."REMARK1"
		INTO :sAcc1_Cha,							 :sAcc2_Cha,
			  :sSangGbn,							 :sAccDcr,						:sRemark1 
		FROM "SYSCNFG","KFZ01OM0"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '25' ) AND
				SUBSTR("SYSCNFG"."DATANAME",1,5) = "KFZ01OM0"."ACC1_CD" AND
				SUBSTR("SYSCNFG"."DATANAME",6,2) = "KFZ01OM0"."ACC2_CD" ;

	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
	dw_junpoy.SetItem(iCurRow,"amt",     dMaiChulAmt)	
	dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itdsc") + '�� [������ǥ]' )	

	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN			
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	END IF
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
		
	dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(iRow,"curr"))
	dw_junpoy.SetItem(iCurRow,"y_amt",   &
							dw_rtv.GetItemNumber(iRow,"expamt") - dSunSuAmtU)
	dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(iRow,"wrate"))
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	lLinNo = lLinNo + 1
END IF

Return 1


end function

public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno);String  sAcc1_Vat,sAcc2_Vat,sSaupNo,sJasaCode,sSdeptCode
Integer iAddRow,iCurRow

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*�����ΰ���*/
	INTO :sAcc1_Vat,  						  :sAcc2_Vat	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '19' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[�����ΰ���(A-1-19)]')
	RETURN -1
END IF

SELECT "SYSCNFG"."DATANAME"     INTO :sSdeptCode  							/*���� �����ι�*/
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 20 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
			
/*�ڻ��ڵ�*/
SELECT "REFFPF"."RFNA2"      INTO :sJasaCode  
	FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;

///*��ǥ �߰�*/
//iCurRow = dw_junpoy.InsertRow(0)
//
//dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
//dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
//dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
//dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
//dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
//			
//dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"dept_cd"))
//dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
//dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
//dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
//dw_junpoy.SetItem(iCurRow,"dcr_gu",  '2')
//		
//dw_junpoy.SetItem(iCurRow,"amt",     0)	
//dw_junpoy.SetItem(iCurRow,"descr",   '���� �ڵ���ǥ �ΰ���')	
//			
//dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdeptCode)
//dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
//dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
//
//dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
//dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
/*�ΰ��� �ڷ� ����*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)
dw_vat.SetItem(iAddRow,"lin_no",  lLinNo)

dw_vat.SetItem(iAddRow,"curr",    dw_rtv.GetItemString(iRow,"curr"))
dw_vat.SetItem(iAddRow,"gey_date",dw_rtv.GetItemString(iRow,"cidate"))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
dw_vat.SetItem(iAddRow,"gon_amt", dw_rtv.GetItemNumber(iRow,"wamt"))
dw_vat.SetItem(iAddRow,"vat_amt", 0)
dw_vat.SetItem(iAddRow,"for_amt", dw_rtv.GetItemNumber(iRow,"expamt"))
dw_vat.SetItem(iAddRow,"tax_no",  dw_rtv.GetItemString(iRow,"vatgu"))
dw_vat.SetItem(iAddRow,"io_gu",   '2')										/*����*/
dw_vat.SetItem(iAddRow,"saup_no2",dw_rtv.GetItemString(iRow,"vndmst_sano"))
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   '���� �ڵ���ǥ �ΰ���')
dw_vat.SetItem(iAddRow,"jasa_cd", sJasaCode)
dw_vat.SetItem(iAddRow,"vouc_gu", dw_rtv.GetItemString(iRow,"docgu"))
dw_vat.SetItem(iAddRow,"lc_no",   dw_rtv.GetItemString(iRow,"explcno"))
dw_vat.SetItem(iAddRow,"cvnas",   dw_rtv.GetItemString(iRow,"cvname"))
dw_vat.SetItem(iAddRow,"ownam",   dw_rtv.GetItemString(iRow,"vndmst_ownam"))
dw_vat.SetItem(iAddRow,"resident",dw_rtv.GetItemString(iRow,"vndmst_resident"))
dw_vat.SetItem(iAddRow,"uptae",   dw_rtv.GetItemString(iRow,"vndmst_uptae"))
dw_vat.SetItem(iAddRow,"jongk",   dw_rtv.GetItemString(iRow,"vndmst_jongk"))
dw_vat.SetItem(iAddRow,"addr1",   dw_rtv.GetItemString(iRow,"vndmst_addr1"))
//dw_vat.SetItem(iAddRow,"addr2",   dw_rtv.GetItemString(iRow,"vndmst_addr2"))
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))
dw_vat.SetItem(iAddRow,"exc_rate",dw_rtv.GetItemNumber(iRow,"wrate"))
dw_vat.SetItem(iAddRow,"curr",    dw_rtv.GetItemString(iRow,"curr"))
dw_vat.SetItem(iAddRow,"expno",   dw_rtv.GetItemString(iRow,"expno"))
//dw_vat.SetItem(iAddRow,"ownplace",   dw_rtv.GetItemString(iRow,"ownplace"))		//24.12.24_SBH_Invalid DataWindow row/column ���� �߻����� �ּ�ó����

//lLinNo = lLinNo + 1

Return 1
end function

on w_kifa14.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_vat=create dw_vat
this.dw_print=create dw_print
this.dw_detail=create dw_detail
this.dw_ip=create dw_ip
this.dw_sunsulst=create dw_sunsulst
this.dw_sang=create dw_sang
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
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.dw_ip
this.Control[iCurrent+10]=this.dw_sunsulst
this.Control[iCurrent+11]=this.dw_sang
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.cbx_all
this.Control[iCurrent+14]=this.dw_rtv
this.Control[iCurrent+15]=this.dw_delete
end on

on w_kifa14.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_vat)
destroy(this.dw_print)
destroy(this.dw_detail)
destroy(this.dw_ip)
destroy(this.dw_sunsulst)
destroy(this.dw_sang)
destroy(this.rr_1)
destroy(this.cbx_all)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)

dw_sang.SetTransObject(SQLCA)
dw_vat.SetTransObject(SQLCA)
dw_sunsulst.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*�ڵ� ���� ���� üũ*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '11' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_kifa14
boolean visible = false
integer x = 635
integer y = 3196
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa14
boolean visible = false
integer x = 3529
integer y = 2752
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa14
boolean visible = false
integer x = 3355
integer y = 2752
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa14
integer x = 3913
integer y = 0
integer taborder = 70
boolean originalsize = true
string picturename = "C:\erpman\image\����ȸ_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����ȸ_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����ȸ_up.gif"
end event

event p_search::clicked;call super::clicked;Integer iSelectRow

SetNull(Gs_Gubun)

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	IF dw_rtv.GetItemString(iSelectRow,"chk") = '1' THEN
		Gs_Gubun = 'Y'
	ELSE
		Gs_Gubun = 'N'
	END IF
	OpenWithParm(w_kifa14a,dw_rtv.GetItemString(iSelectRow,"cino"))
	
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	Gs_Gubun = 'D'
	OpenWithParm(w_kifa14a,dw_delete.GetItemString(iSelectRow,"cino"))
END IF


end event

type p_ins from w_inherite`p_ins within w_kifa14
boolean visible = false
integer x = 3182
integer y = 2752
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa14
integer x = 4434
integer y = 0
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa14
boolean visible = false
integer x = 4050
integer y = 2752
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa14
boolean visible = false
integer x = 2834
integer y = 2752
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF MessageBox("Ȯ ��", "����Ͻðڽ��ϱ� ?", Question!, OkCancel!, 2) = 2 THEN RETURN

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

type p_inq from w_inherite`p_inq within w_kifa14
integer x = 4087
integer y = 0
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaleDtf,sSaleDtT,sSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sSaleDtf = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtf"))
sSaleDtt = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtt"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[�����]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[��������]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[��������]')	
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

type p_del from w_inherite`p_del within w_kifa14
boolean visible = false
integer x = 3877
integer y = 2752
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa14
integer x = 4261
integer y = 0
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

event p_mod::clicked;call super::clicked;Integer iYesCnt,k
String  sSaupj

IF rb_1.Checked =True THEN
	
	IF dw_rtv.RowCount() <=0 THEN Return
	
	dw_ip.AcceptText()
	sSaupj = dw_ip.GetItemString(1,"saupj")
	
	iYesCnt = dw_rtv.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF
	
	FOR k = 1 TO dw_rtv.RowCount()
		IF Wf_RequiredChk(k) = -1 THEN Return	
	Next
	
	IF Wf_Insert_Kfz12ot0(sSaupj) = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
	//-------------------------------------------------------------------------------------------------------------
	// 24.11.12_SBH_���� �׷���� ���ڰ��� ���� ����
	Long		i, ii
	String		ls_key, ls_keys[], ls_formno, ls_yn
	
	ls_formno = '39'		//��Ĺ�ȣ-39 : �����ڵ���ǥ
	ls_yn = f_get_syscnfg('G', 1, '1')
	If ls_yn = 'Y' Then

		For i = 1 To dw_rtv.RowCount()
			If dw_rtv.GetItemString(i, 'chk') = '1' Then
				// Unique ���ǰ�, 2���̻��̸� ������(|)�� ���ڿ� ���� => ex) ls_cvcod + '|' + ls_itnbr
				ls_key = dw_rtv.GetItemString(i, 'sabu') + '|' + dw_rtv.GetItemString(i, 'cino')
				ii++
				ls_keys[ii] = ls_key
			End If
		Next

		// �׷���� ���ڰ��� ���
		f_gwif_approval(ls_formno, is_window_id, gs_empno, ls_keys)
	End If
	//-------------------------------------------------------------------------------------------------------------
	
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

type cb_exit from w_inherite`cb_exit within w_kifa14
integer x = 3255
integer y = 2576
end type

type cb_mod from w_inherite`cb_mod within w_kifa14
integer x = 2898
integer y = 2576
string text = "ó��(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa14
integer x = 1431
integer y = 2772
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa14
integer x = 1774
integer y = 2776
end type

type cb_inq from w_inherite`cb_inq within w_kifa14
integer x = 2537
integer y = 2576
end type

type cb_print from w_inherite`cb_print within w_kifa14
integer x = 2126
integer y = 2776
end type

type st_1 from w_inherite`st_1 within w_kifa14
end type

type cb_can from w_inherite`cb_can within w_kifa14
integer x = 2478
integer y = 2776
end type

type cb_search from w_inherite`cb_search within w_kifa14
integer x = 2011
integer y = 2580
integer width = 498
string text = "ǰ�񺸱�(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa14
integer x = 1390
integer y = 2716
integer height = 196
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa14
integer x = 1966
integer y = 2520
integer width = 1664
end type

type gb_1 from groupbox within w_kifa14
integer x = 2629
integer width = 905
integer height = 144
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "�۾�����"
end type

type rb_1 from radiobutton within w_kifa14
integer x = 2661
integer y = 52
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ǥ����ó��"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="���� �ڵ���ǥ ����"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa14
integer x = 3086
integer y = 52
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ǥ����ó��"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="���� �ڵ���ǥ ����"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa14
boolean visible = false
integer x = 69
integer y = 2300
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ ����"
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

type dw_sungin from datawindow within w_kifa14
boolean visible = false
integer x = 69
integer y = 2416
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "������ǥ ���κ� ����"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vat from datawindow within w_kifa14
boolean visible = false
integer x = 69
integer y = 2516
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "�ΰ��� ����"
string dataobject = "d_kifa037"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa14
boolean visible = false
integer x = 69
integer y = 2624
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "��ǥ �μ�"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_kifa14
boolean visible = false
integer x = 1106
integer y = 2296
integer width = 837
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "�Ǻ� ������ �հ�"
string dataobject = "d_kifa1422a"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_kifa14
event ue_key pbm_dwnkey
integer x = 46
integer y = 20
integer width = 2569
integer height = 132
integer taborder = 10
string dataobject = "d_kifa141"
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
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[�����]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��������")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��������")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
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

type dw_sunsulst from datawindow within w_kifa14
boolean visible = false
integer x = 1106
integer y = 2416
integer width = 837
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "�����ݳ���"
string dataobject = "d_kifa1423"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_sang from datawindow within w_kifa14
boolean visible = false
integer x = 1106
integer y = 2516
integer width = 837
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "����ó����� ����"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa14
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 156
integer width = 4553
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kifa14
integer x = 3557
integer y = 80
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ü����"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '�ڷ� ���� ��...'
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

type dw_rtv from datawindow within w_kifa14
integer x = 69
integer y = 164
integer width = 4521
integer height = 2060
integer taborder = 30
string dataobject = "d_kifa142"
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

event itemchanged;String  sChk,sVatGbn,sVoucGbn,sAccod,snull,sCiNo,sSangGbn,sChaDae,sAcc1,sAcc2
Integer iCount

SetNull(snull)

IF this.GetColumnName() = "chk" THEN
	sChk = this.GetText()
	IF sChk = "" OR IsNull(sChk) THEN Return
	
	IF sChk = '1' THEN
		sCiNo = this.GetItemString(this.GetRow(),"cino")
		
		SELECT Count(*)     INTO :iCount  
		   FROM "KIF05OT1"  
   		WHERE ( "KIF05OT1"."CINO" = :sCiNo ) AND  
         		( "KIF05OT1"."ACCOD" is null OR "KIF05OT1"."ACCOD" = '');
		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		
		IF iCount > 0 THEN
			F_MessageChk(1,'[ǰ�� ��������]')
			Return 1
		END IF
		
//		this.SetItem(this.GetRow(),"vatgu",'23')
	ELSE
//		this.SetItem(this.GetRow(),"vatgu",snull)
	END IF
END IF

IF this.GetColumnName() ="saccod" THEN
	sAcCod = this.GetText()
	IF sAcCod ="" OR IsNull(sAcCod) THEN RETURN 

	IF IsNull(F_Get_Refferance('EB',sAcCod)) THEN
		F_MessageChk(20,'[������]')
		this.SetItem(this.GetRow(),"saccod",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="vat_gu" THEN
	sVatGbn = this.GetText()
	IF sVatGbn ="" OR IsNull(sVatGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sVatGbn)) THEN
		F_MessageChk(20,'[�ΰ�������]')
		this.SetItem(this.GetRow(),"vat_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="docgu" THEN
	sVoucGbn = this.GetText()
	IF sVoucGbn ="" OR IsNull(sVoucGbn) THEN RETURN 
	
	IF IsNull(F_Get_Refferance('AU',sVoucGbn)) THEN
		F_MessageChk(20,'[��������]')
		this.SetItem(this.GetRow(),"docgu",snull)
		Return 1
	END IF
END IF

end event

type dw_delete from datawindow within w_kifa14
integer x = 69
integer y = 164
integer width = 4521
integer height = 2060
integer taborder = 40
string dataobject = "d_kifa143"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

