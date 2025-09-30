$PBExportHeader$w_kifa42.srw
$PBExportComments$�ڵ���ǥ ���� : ����(��꼭����)
forward
global type w_kifa42 from w_inherite
end type
type gb_1 from groupbox within w_kifa42
end type
type rb_1 from radiobutton within w_kifa42
end type
type rb_2 from radiobutton within w_kifa42
end type
type dw_ip from u_key_enter within w_kifa42
end type
type dw_junpoy from datawindow within w_kifa42
end type
type dw_sungin from datawindow within w_kifa42
end type
type dw_detail from datawindow within w_kifa42
end type
type dw_group_detail from datawindow within w_kifa42
end type
type dw_vat from datawindow within w_kifa42
end type
type dw_print from datawindow within w_kifa42
end type
type rr_1 from roundrectangle within w_kifa42
end type
type cbx_all from checkbox within w_kifa42
end type
type dw_rtv from datawindow within w_kifa42
end type
type dw_delete from datawindow within w_kifa42
end type
end forward

global type w_kifa42 from w_inherite
integer height = 2424
string title = "������ǥ ó��"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_detail dw_detail
dw_group_detail dw_group_detail
dw_vat dw_vat
dw_print dw_print
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa42 w_kifa42

type variables

String sUpmuGbn = 'D',LsAutoSungGbn,LsJpyCreateGbn
end variables

forward prototypes
public function integer wf_chk_validdata (integer i)
public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj)
public function integer wf_insert_kfz12ot0_1 (string ssaupj)
end prototypes

public function integer wf_chk_validdata (integer i);String  sCheckNo
Integer iCount

sCheckNo = dw_rtv.GetItemString(i,"kif03ot0_checkno")
		
SELECT Count(*)     INTO :iCount  
   FROM "KIF03OT1"  
	WHERE ( "KIF03OT1"."IP_JPNO" = :sCheckNo ) AND  
     		( "KIF03OT1"."ACCODE" is null OR "KIF03OT1"."ACCODE" = '');
IF SQLCA.SQLCODE <> 0 THEN
	iCount = 0
ELSE
	IF IsNull(iCount) THEN iCount = 0
END IF
	
IF iCount > 0 THEN
	F_MessageChk(1,'[ǰ�� ��������]')
	Return -1
END IF

Return 1
end function

public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno);String  sExpGbn,sAcc1_Vat,sAcc2_Vat,sSaupNo,sAcc1_Cha,sAcc2_Cha,sDcGbn,sVatGbn
Integer iAddRow,iCurRow

dw_vat.Reset()
sVatGbn = dw_rtv.GetItemString(iRow,"kif03ot0_tax_no")
IF sVatGbn = "" OR IsNull(sVatGbn) OR sVatGbn = '25' THEN Return 1

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*�����ΰ���*/
	INTO :sAcc1_Vat,  						  :sAcc2_Vat	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '19' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[�ΰ���������(A-1-19)]')
	RETURN -1
END IF

IF sVatGbn <> '29' AND sVatGbn <> '24' THEN 
	/*��ǥ �߰�*/
	sDcGbn = '2'
	
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(iRow,"kif03ot0_sale_dept"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(iRow,"kif03ot0_vat_amt"))	
	dw_junpoy.SetItem(iCurRow,"descr",   '�����ΰ���')	
				
	dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"cost_cd"))
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"kif03ot0_cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"kif03ot0_cvnas"))
	
	dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
	
	dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
END IF

/*�ΰ��� �ڷ� ����*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)

IF sVatGbn <> '29' AND sVatGbn <> '24' THEN 
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo)
ELSE
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo - 1)
END IF

dw_vat.SetItem(iAddRow,"gey_date",dw_rtv.GetItemString(iRow,"kif03ot0_saledt"))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_rtv.GetItemString(iRow,"kif03ot0_cvcod"))

IF dw_group_detail.RowCount() <=0 THEN
	dw_vat.SetItem(iAddRow,"gon_amt", dw_rtv.GetItemNumber(iRow,"kif03ot0_gon_amt"))
ELSE
	dw_vat.SetItem(iAddRow,"gon_amt", dw_group_detail.GetItemNumber(1,"total_amt"))
END IF

dw_vat.SetItem(iAddRow,"vat_amt", dw_rtv.GetItemNumber(iRow,"kif03ot0_vat_amt"))
dw_vat.SetItem(iAddRow,"for_amt", dw_rtv.GetItemNumber(iRow,"kif03ot0_for_amt"))
dw_vat.SetItem(iAddRow,"tax_no",  dw_rtv.GetItemString(iRow,"kif03ot0_tax_no"))
dw_vat.SetItem(iAddRow,"io_gu",   '2')										/*����*/
dw_vat.SetItem(iAddRow,"saup_no2",dw_rtv.GetItemString(iRow,"kif03ot0_sano"))
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   dw_rtv.GetItemString(iRow,"kif03ot0_descr"))
dw_vat.SetItem(iAddRow,"jasa_cd", dw_rtv.GetItemString(iRow,"kif03ot0_jasa"))
dw_vat.SetItem(iAddRow,"vouc_gu", dw_rtv.GetItemString(iRow,"kif03ot0_vouc_gu"))
dw_vat.SetItem(iAddRow,"lc_no",   dw_rtv.GetItemString(iRow,"kif03ot0_lcno"))
dw_vat.SetItem(iAddRow,"cvnas",   dw_rtv.GetItemString(iRow,"kif03ot0_cvnas"))
dw_vat.SetItem(iAddRow,"ownam",   dw_rtv.GetItemString(iRow,"kif03ot0_ownam"))
dw_vat.SetItem(iAddRow,"resident",dw_rtv.GetItemString(iRow,"kif03ot0_resident"))
dw_vat.SetItem(iAddRow,"uptae",   dw_rtv.GetItemString(iRow,"kif03ot0_uptae"))
dw_vat.SetItem(iAddRow,"jongk",   dw_rtv.GetItemString(iRow,"kif03ot0_jongk"))
dw_vat.SetItem(iAddRow,"addr1",   dw_rtv.GetItemString(iRow,"kif03ot0_addr1"))
dw_vat.SetItem(iAddRow,"addr2",   dw_rtv.GetItemString(iRow,"kif03ot0_addr2"))
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))
dw_vat.SetItem(iAddRow,"exc_rate",dw_rtv.GetItemNumber(iRow,"exchrate"))
dw_vat.SetItem(iAddRow,"elegbn", dw_rtv.GetItemString(iRow,"v_elegbn"))

dw_vat.SetItem(iAddRow,"vatgbn",  dw_rtv.GetItemString(iRow,"kif03ot0_vatgbn"))

IF sVatGbn <> '29' AND sVatGbn <> '24' THEN 
	lLinNo = lLinNo + 1
END IF

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull,sCheckNo
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sCheckNo   = dw_delete.GetItemString(k,"kif03ot0_checkno")
		
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
	
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
		
					
//		dw_delete.SetItem(k,"saupj",    snull)
		dw_delete.SetItem(k,"bal_date", snull)
		dw_delete.SetItem(k,"upmu_gu",  snull)
		dw_delete.SetItem(k,"bjun_no",  lnull)
	END IF
NEXT
IF dw_delete.Update() <> 1 THEN
	F_MessageChk(12,'[�����ڷ�]')
	SetPointer(Arrow!)
	Return -1
END IF

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

public function integer wf_insert_kfz12ot0 (string ssaupj);/************************************************************************************/
/* �����ڷḦ �ڵ����� ��ǥ ó���Ѵ�.(�Ǻ� ��ǥ)												*/
/* 1. ���� : �ܻ����� ������������ �߻�.(ȯ������ A-1-51)									*/
/* 2. �뺯 : �Ǻ� ���� ǰ�� ���� ������������ �߻�.										*/
/*           �����ΰ��� �������� �߻�.(ȯ������ A-1-19)										*/
/* ** ǰ���� �󼼳����� �������� ��Ƽ� ��ǥ�� ������ �����Ѵ�.							*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sChkNo,sExpGbn,sBalDate,sChaDae,&
			sYesanGbn,sAccDate,sAlcGbn,sRemark1,sSaleGbn
Integer  k,iCnt,lLinNo,iCurRow,iLoopCnt,iItemDetailCnt
Long     lJunNo,lAccJunNo
Double   dAmount,dGonAmt,dTmpAmount

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="���� �ڵ���ǥ ó�� �� ..."

SetPointer(HourGlass!)

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		dw_sungin.Reset()
		dw_junpoy.Reset()
		dw_vat.Reset()

//		sSaupj   = dw_rtv.GetItemString(k,"kif03ot0_sabu")
		sChkNo   = dw_rtv.GetItemString(k,"kif03ot0_checkno")
		sBalDate = dw_rtv.GetItemString(k,"kif03ot0_saledt")
		
		

		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[��������]')
			continue
		END IF
		  
		
		sExpGbn  = dw_rtv.GetItemString(k,"expgu")
		
		iLoopCnt = dw_group_detail.Retrieve(sChkNo)								/*ó���� ��ǰ �Ǽ�*/
		dw_group_detail.SetFilter("chgbn = '2'")
		dw_group_detail.Filter()
		
		iLoopCnt = dw_group_detail.RowCount()
		/*��ǥ��ȣ ä��*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1	

		sDcGbn = '2'																		/*�뺯 ��ǥ*/
		FOR iCnt = 1 TO iLoopCnt
			sAcc1_Dae = Left(dw_group_detail.GetItemString(iCnt,"accode"),5)
			sAcc2_Dae = Right(dw_group_detail.GetItemString(iCnt,"accode"),2)
			dAmount   = dw_group_detail.GetItemNumber(iCnt,"pumamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iItemDetailCnt = dw_detail.Retrieve(sChkNo,sAcc1_Dae+sAcc2_Dae)		/*��ǰ �Ǽ�*/
						
			SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae,:sYesanGbn,:sRemark1
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae);
						
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itdsc") + ' ��')	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"exchrate"))
				
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))
			END IF
			dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			lLinNo = lLinNo + 1
		NEXT
		IF dw_rtv.GetItemString(k,"kif03ot0_tax_no") = '29' OR dw_rtv.GetItemString(k,"kif03ot0_tax_no") = '24' THEN
			dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 	
		END IF
		/*�����ΰ��� ���� ����(�뺯)*/
		IF Wf_Create_Vat(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			SetPointer(Arrow!)
			Return -1
		END IF
		
		IF iLoopCnt = 0 OR IsNull(iLoopCnt) THEN
			dGonAmt = dw_rtv.GetItemNumber(k,"kif03ot0_vat_amt")
		ELSE
			dGonAmt = dw_group_detail.GetItemNumber(1,"total_amt") + dw_rtv.GetItemNumber(k,"kif03ot0_vat_amt")
		END IF
			
		sDcGbn = '1'										
		dw_group_detail.SetFilter("chgbn = '1'")						/*����-��������(�ܻ�����,�̼���)*/
		dw_group_detail.Filter()
		
		iLoopCnt = dw_group_detail.RowCount()
		IF iLoopCnt <=0 THEN
			IF sExpGbn = '1' THEN								/*����-��������(�ܻ�����)*/
				SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
					INTO :sAcc1_Cha,								:sAcc2_Cha
					FROM "SYSCNFG"
					WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
							( "SYSCNFG"."LINENO" = '51' ) ;
				IF SQLCA.SQLCODE <> 0 THEN
					F_MessageChk(56,'[��������(A-1-51)]')
					RETURN -1
				END IF
			ELSE														/*����-��������(��ȭ�ܻ�����)*/
				SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
					INTO :sAcc1_Cha,								:sAcc2_Cha
					FROM "SYSCNFG"
					WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
							( "SYSCNFG"."LINENO" = '25' ) ;
				IF SQLCA.SQLCODE <> 0 THEN
					F_MessageChk(56,'[��������(A-1-25)]')
					RETURN -1
				END IF				
			END IF	
			
			iCurRow = dw_junpoy.InsertRow(0)
				
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
			dw_junpoy.SetItem(iCurRow,"descr",   '��ǰ���� ��')	
			
	//		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
			
			dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		ELSE
			dTmpAmount = dGonAmt
			
			FOR iCnt = 1 TO iLoopCnt
				sSaleGbn  = dw_group_detail.GetItemString(iCnt,"salegu")
				IF sSaleGbn = '1' OR sSaleGbn = '2' OR sSaleGbn = '3' THEN									/*�Ϲݸ���*/
					IF sExpGbn = '1' THEN								/*����-��������(�ܻ�����)*/
						SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
							INTO :sAcc1_Cha,								:sAcc2_Cha
							FROM "SYSCNFG"
							WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
									( "SYSCNFG"."LINENO" = '51' ) ;
						IF SQLCA.SQLCODE <> 0 THEN
							F_MessageChk(56,'[��������(A-1-51)]')
							RETURN -1
						END IF
					ELSE														/*����-��������(�ܻ�����)*/
						SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
							INTO :sAcc1_Cha,								:sAcc2_Cha
							FROM "SYSCNFG"
							WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
									( "SYSCNFG"."LINENO" = '25' ) ;
						IF SQLCA.SQLCODE <> 0 THEN
							F_MessageChk(56,'[��������(A-1-25)]')
							RETURN -1
						END IF				
					END IF	
				ELSE
					sAcc1_Cha = Left(dw_group_detail.GetItemString(iCnt,"accode"),5)
					sAcc2_Cha = Right(dw_group_detail.GetItemString(iCnt,"accode"),2)				
				END IF
				dAmount   = dw_group_detail.GetItemNumber(iCnt,"pumamt")
				IF IsNull(dAmount) THEN dAmount = 0
			
				if iCnt = iLoopcnt then
					dGonAmt = dTmpAmount	
				else
					dGonAmt = dAmount
					dTmpAmount = dTmpAmount - dAmount
				end if
				
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
				dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '��ǰ���� ��')	
				
		//		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
				
				dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[�̽�����ǥ]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_vat.Update() <> 1 THEN
				F_MessageChk(13,'[�ΰ���]')
				SetPointer(Arrow!)
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
				SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn ='N';
			END IF
			
			dw_rtv.SetItem(k,"kif03ot0_saupj",   sSaupj)
			dw_rtv.SetItem(k,"kif03ot0_bal_date",sBalDate)
			dw_rtv.SetItem(k,"kif03ot0_upmu_gu", sUpmuGbn)
			dw_rtv.SetItem(k,"kif03ot0_bjun_no", lJunNo)
			dw_rtv.SetItem(k,"kif03ot0_alc_gu",  sAlcGbn)
			dw_rtv.SetItem(k,"kif03ot0_acc_date",sAccDate)
			dw_rtv.SetItem(k,"kif03ot0_jun_no",  lAccJunNo)
			
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

public function integer wf_insert_kfz12ot0_1 (string ssaupj);/************************************************************************************/
/* �����ڷḦ �ڵ����� ��ǥ ó���Ѵ�.(��ǥ �ϳ�)												*/
/* 1. ���� : �ܻ����� ������������ �߻�.(ȯ������ A-1-51)									*/
/* 2. �뺯 : �Ǻ� ���� ǰ�� ���� ������������ �߻�.										*/
/*           �����ΰ��� �������� �߻�.(ȯ������ A-1-19)										*/
/* ** ǰ���� �󼼳����� �������� ��Ƽ� ��ǥ�� ������ �����Ѵ�.							*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sChkNo,sExpGbn,sBalDate,sChaDae,&
			sYesanGbn,sAccDate,sAlcGbn,sRemark1,sSaleGbn
Integer  k,iCnt,lLinNo,iCurRow,iLoopCnt,iItemDetailCnt
Long     lJunNo,lAccJunNo
Double   dAmount,dGonAmt,dTmpAmount

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()
sBalDate = dw_ip.GetitemString(1,"saledtf")								/*�������� = �Է��� ��꼭����*/
IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[��������]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="���� �ڵ���ǥ ó�� �� ..."

SetPointer(HourGlass!)

dw_sungin.Reset()
dw_junpoy.Reset()
dw_vat.Reset()

/*��ǥ��ȣ ä��*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN
		sChkNo   = dw_rtv.GetItemString(k,"kif03ot0_checkno")
		sBalDate = dw_rtv.GetItemString(k,"kif03ot0_saledt")
		sExpGbn  = dw_rtv.GetItemString(k,"expgu")
		
		iLoopCnt = dw_group_detail.Retrieve(sChkNo)								/*ó���� ��ǰ �Ǽ�*/
		dw_group_detail.SetFilter("chgbn = '2'")
		dw_group_detail.Filter()
			
		sDcGbn = '2'																	/*�뺯 ��ǥ*/
		FOR iCnt = 1 TO iLoopCnt
			sAcc1_Dae = Left(dw_group_detail.GetItemString(iCnt,"accode"),5)
			sAcc2_Dae = Right(dw_group_detail.GetItemString(iCnt,"accode"),2)
			dAmount   = dw_group_detail.GetItemNumber(iCnt,"pumamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iItemDetailCnt = dw_detail.Retrieve(sChkNo,sAcc1_Dae+sAcc2_Dae)		/*��ǰ �Ǽ�*/
						
			SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae,:sYesanGbn,:sRemark1
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae);
						
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itdsc") + ' ��')	
			
			IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN				
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"exchrate"))
				
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))
			END IF
			
			dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			lLinNo = lLinNo + 1
		NEXT
		IF dw_rtv.GetItemString(k,"kif03ot0_tax_no") = '29' THEN
			dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 	
		END IF
		/*�����ΰ��� ���� ����(�뺯)*/
		IF Wf_Create_Vat(k,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
			SetPointer(Arrow!)
			Return -1
		END IF
		
		IF iLoopCnt = 0 OR IsNull(iLoopCnt) THEN
			dGonAmt = dw_rtv.GetItemNumber(k,"kif03ot0_vat_amt")
		ELSE
			dGonAmt = dw_group_detail.GetItemNumber(1,"total_amt") + dw_rtv.GetItemNumber(k,"kif03ot0_vat_amt")
		END IF
		
		sDcGbn = '1'										
		dw_group_detail.SetFilter("chgbn = '1'")						/*����-��������(�ܻ�����,�̼���)*/
		dw_group_detail.Filter()
		
		iLoopCnt = dw_group_detail.RowCount()
		IF iLoopCnt <=0 THEN
			IF sExpGbn = '1' THEN								/*����-��������(�ܻ�����)*/
				SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
					INTO :sAcc1_Cha,								:sAcc2_Cha
					FROM "SYSCNFG"
					WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
							( "SYSCNFG"."LINENO" = '51' ) ;
				IF SQLCA.SQLCODE <> 0 THEN
					F_MessageChk(56,'[��������(A-1-51)]')
					RETURN -1
				END IF
			ELSE														/*����-��������(��ȭ�ܻ�����)*/
				SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
					INTO :sAcc1_Cha,								:sAcc2_Cha
					FROM "SYSCNFG"
					WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
							( "SYSCNFG"."LINENO" = '25' ) ;
				IF SQLCA.SQLCODE <> 0 THEN
					F_MessageChk(56,'[��������(A-1-25)]')
					RETURN -1
				END IF				
			END IF	
			
			iCurRow = dw_junpoy.InsertRow(0)
				
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
			dw_junpoy.SetItem(iCurRow,"descr",   '��ǰ���� ��')	
			
	//		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
			
			dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		ELSE
			dTmpAmount = dGonAmt
			
			FOR iCnt = 1 TO iLoopCnt
				sSaleGbn  = dw_group_detail.GetItemString(iCnt,"salegu")
				IF sSaleGbn = '1' THEN									/*�Ϲݸ���*/
					IF sExpGbn = '1' THEN								/*����-��������(�ܻ�����)*/
						SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
							INTO :sAcc1_Cha,								:sAcc2_Cha
							FROM "SYSCNFG"
							WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
									( "SYSCNFG"."LINENO" = '51' ) ;
						IF SQLCA.SQLCODE <> 0 THEN
							F_MessageChk(56,'[��������(A-1-51)]')
							RETURN -1
						END IF
					ELSE														/*����-��������(��ȭ�ܻ�����)*/
						SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)
							INTO :sAcc1_Cha,								:sAcc2_Cha
							FROM "SYSCNFG"
							WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
									( "SYSCNFG"."LINENO" = '25' ) ;
						IF SQLCA.SQLCODE <> 0 THEN
							F_MessageChk(56,'[��������(A-1-25)]')
							RETURN -1
						END IF				
					END IF	
				ELSE
					sAcc1_Cha = Left(dw_group_detail.GetItemString(iCnt,"accode"),5)
					sAcc2_Cha = Right(dw_group_detail.GetItemString(iCnt,"accode"),2)				
				END IF
				dAmount   = dw_group_detail.GetItemNumber(iCnt,"pumamt")
				IF IsNull(dAmount) THEN dAmount = 0
			
				if iCnt = iLoopcnt then
					dGonAmt = dTmpAmount	
				else
					dGonAmt = dAmount
					dTmpAmount = dTmpAmount - dAmount
				end if
				
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", dw_rtv.GetItemString(k,"kif03ot0_sale_dept"))	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
				dw_junpoy.SetItem(iCurRow,"amt",     dGonAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '��ǰ���� ��')	
				
		//		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"cost_cd"))
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kif03ot0_cvcod"))
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kif03ot0_cvnas"))
				
				dw_junpoy.SetItem(iCurRow,"gita2",   dw_ip.GetItemString(1,"gita2")) 
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			NEXT
		END IF
		
		dw_rtv.SetItem(k,"kif03ot0_saupj",   sSaupj)
		dw_rtv.SetItem(k,"kif03ot0_bal_date",sBalDate)
		dw_rtv.SetItem(k,"kif03ot0_upmu_gu", sUpmuGbn)
		dw_rtv.SetItem(k,"kif03ot0_bjun_no", lJunNo)
		dw_rtv.SetItem(k,"kif03ot0_alc_gu",  sAlcGbn)
		dw_rtv.SetItem(k,"kif03ot0_acc_date",sAccDate)
		dw_rtv.SetItem(k,"kif03ot0_jun_no",  lAccJunNo)
	
	END IF
NEXT

IF dw_junpoy.RowCount() > 0 THEN
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[�̽�����ǥ]')
		SetPointer(Arrow!)
		Return -1
	ELSE
		IF dw_vat.Update() <> 1 THEN
			F_MessageChk(13,'[�ΰ���]')
			SetPointer(Arrow!)
			Return -1
		END IF
		IF dw_rtv.Update() <> 1 THEN
			F_MessageChk(13,'[�����ڷ�]')
			SetPointer(Arrow!)	
			RETURN -1
		END IF
		COMMIT;
	
		/*�ڵ� ���� ó��*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '���� ó�� ��...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				F_MessageChk(13,'[��ǥ ����]')
				Rollback;
//				Return -1
			END IF	
		END IF
		Commit;
	END IF			
END IF

w_mdi_frame.sle_msg.text ="���� ��ǥ ó�� �Ϸ�!!"

Return 1
end function

on w_kifa42.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_detail=create dw_detail
this.dw_group_detail=create dw_group_detail
this.dw_vat=create dw_vat
this.dw_print=create dw_print
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
this.Control[iCurrent+8]=this.dw_group_detail
this.Control[iCurrent+9]=this.dw_vat
this.Control[iCurrent+10]=this.dw_print
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.cbx_all
this.Control[iCurrent+13]=this.dw_rtv
this.Control[iCurrent+14]=this.dw_delete
end on

on w_kifa42.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_detail)
destroy(this.dw_group_detail)
destroy(this.dw_vat)
destroy(this.dw_print)
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

p_mod.Enabled =False

/*�ڵ� ���� ����,��ǥ�������(1:�Ǻ� ��ǥ,2:��ǥ�ϳ�) üũ*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1),		SUBSTR("SYSCNFG"."DATANAME",2,1)
	INTO :LsAutoSungGbn,								:LsJpyCreateGbn 
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9) AND  
         ( "SYSCNFG"."LINENO" = '03' )   ;
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

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa42
boolean visible = false
integer y = 2784
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa42
boolean visible = false
integer x = 3451
integer y = 2764
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa42
boolean visible = false
integer x = 3278
integer y = 2764
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa42
integer x = 3922
integer y = 12
integer taborder = 70
string picturename = "C:\erpman\image\����ȸ_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iSelectRow

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	IF dw_rtv.GetItemString(iSelectRow,"chk") = '1' THEN
		Gs_Gubun = 'Y'
	ELSE
		Gs_Gubun = 'N'
	END IF
	
	OpenWithParm(w_kifa42a,dw_rtv.GetItemString(iSelectRow,"kif03ot0_checkno"))
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	Gs_Gubun = 'D'
	OpenWithParm(w_kifa42a,dw_delete.GetItemString(iSelectRow,"kif03ot0_checkno"))
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����ȸ_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����ȸ_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa42
boolean visible = false
integer x = 3104
integer y = 2764
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa42
integer y = 12
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa42
boolean visible = false
integer x = 3973
integer y = 2764
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa42
boolean visible = false
integer x = 2757
integer y = 2764
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sCheckNo,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lSeqNo,lJunNo
Integer i,iRtnVal

IF MessageBox("Ȯ ��", "����Ͻðڽ��ϱ�?", Question!, OkCancel!, 2) = 2 THEN RETURN

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
		sCheckNo = dw_rtv.GetItemString(i,"kif03ot0_checkno")
		
		sSaupj   = dw_rtv.GetItemString(i,"kif03ot0_saupj")
		sBalDate = dw_rtv.GetItemString(i,"kif03ot0_bal_date") 
		sUpmuGu  = dw_rtv.GetItemString(i,"kif03ot0_upmu_gu") 
		lBJunNo  = dw_rtv.GetItemNumber(i,"kif03ot0_bjun_no") 
		
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

type p_inq from w_inherite`p_inq within w_kifa42
integer x = 4096
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,sSaleDtf,sSaleDtT,sChkNof,sChkNot,sCustf,sCustt,sDeptf,sDeptt

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")
sSaleDtf = dw_ip.GetItemString(dw_ip.GetRow(),"saledtf")
sSaleDtt = dw_ip.GetItemString(dw_ip.GetRow(),"saledtt")
sChkNof  = dw_ip.GetItemString(dw_ip.GetRow(),"checknof")
sChkNot  = dw_ip.GetItemString(dw_ip.GetRow(),"checknot")
sCustF   = dw_ip.GetItemString(dw_ip.GetRow(),"custf")
sCustT   = dw_ip.GetItemString(dw_ip.GetRow(),"custt")
sDeptF   = dw_ip.GetItemString(dw_ip.GetRow(),"deptf")
sDeptt   = dw_ip.GetItemString(dw_ip.GetRow(),"deptt")

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[�����]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[��꼭����]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[��꼭����]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF
IF sChkNof = "" OR IsNull(sChkNof) THEN	sChkNof = '0'
IF sChkNot = "" OR IsNull(sChkNot) THEN	sChkNot = 'zzzzzzzzzz'

IF sCustf = "" OR IsNull(sCustf) THEN	sCustf = '0'
IF sCustt = "" OR IsNull(sCustt) THEN	sCustt = 'zzzzzz'

IF sDeptf = "" OR IsNull(sDeptf) THEN	sDeptf = '0'
IF sDeptt = "" OR IsNull(sDeptt) THEN	sDeptt = 'zzzzzz'

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt,sChkNof,sChkNot,sCustf,sCustt,sDeptf,sDeptt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt,sChkNof,sChkNot,sCustf,sCustt,sDeptf,sDeptt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa42
boolean visible = false
integer x = 3799
integer y = 2764
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa42
integer x = 4270
integer y = 12
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::clicked;call super::clicked;String sSaupj

IF rb_1.Checked =True THEN
	IF dw_ip.AcceptText() = -1 THEN RETURN
	sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")
	IF ssaupj ="" OR IsNull(ssaupj) THEN
		F_MessageChk(1,'[�����]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF LsJpyCreateGbn = '1' THEN							/*�Ǻ� ��ǥ �߻�*/
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
	// 24.11.12_SBH_���� �׷���� ���ڰ��� ���� ����
	Long		i, ii
	String		ls_key, ls_keys[], ls_formno, ls_yn
	
	ls_formno = '41'		//��Ĺ�ȣ-41 : �����ڵ���ǥ
	ls_yn = f_get_syscnfg('G', 1, '1')
	If ls_yn = 'Y' Then

		For i = 1 To dw_rtv.RowCount()
			If dw_rtv.GetItemString(i, 'chk') = '1' Then
				// Unique ���ǰ�, 2���̻��̸� ������(|)�� ���ڿ� ���� => ex) ls_cvcod + '|' + ls_itnbr
				ls_key = dw_rtv.GetItemString(i, 'kif03ot0_sabu') + '|' + dw_rtv.GetItemString(i, 'kif03ot0_saledt') + '|' + String(dw_rtv.GetItemNumber(i, 'kif03ot0_saleno'))
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
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa42
integer x = 2345
integer y = 2816
end type

type cb_mod from w_inherite`cb_mod within w_kifa42
integer x = 1989
integer y = 2812
string text = "ó��(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa42
integer x = 2080
integer y = 2604
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa42
integer x = 2450
integer y = 2608
end type

type cb_inq from w_inherite`cb_inq within w_kifa42
integer x = 1623
integer y = 2812
end type

type cb_print from w_inherite`cb_print within w_kifa42
integer x = 2725
integer y = 2632
end type

type st_1 from w_inherite`st_1 within w_kifa42
end type

type cb_can from w_inherite`cb_can within w_kifa42
integer x = 3154
integer y = 2608
end type

type cb_search from w_inherite`cb_search within w_kifa42
integer x = 1102
integer y = 2816
integer width = 498
string text = "ǰ�񺸱�(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa42
integer x = 2752
integer y = 2400
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa42
integer x = 1065
integer y = 2760
integer width = 1664
end type

type gb_1 from groupbox within w_kifa42
integer x = 3433
integer width = 407
integer height = 292
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

type rb_1 from radiobutton within w_kifa42
integer x = 3465
integer y = 72
integer width = 329
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
string text = "��ǥ����"
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

type rb_2 from radiobutton within w_kifa42
integer x = 3470
integer y = 176
integer width = 329
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
string text = "��ǥ����"
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

type dw_ip from u_key_enter within w_kifa42
event ue_key pbm_dwnkey
integer x = 50
integer width = 3387
integer height = 308
integer taborder = 10
string dataobject = "d_kifa421"
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
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[��������]")
		dw_ip.SetItem(1,"sabu",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��꼭����")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"��꼭����")
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
	
	/*�ŷ�ó�� ���� ó��*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[�ŷ�ó]')
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
	
	/*�ŷ�ó�� ���� ó��*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[�ŷ�ó]')
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
//		F_MessageChk(20,'[�����μ�]')
		this.SetItem(1,"deptf",snull)
		this.SetItem(1,"deptfname",snull)
		Return 
	END IF
	this.SetItem(1,"deptfname",sDeptName)
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
//		F_MessageChk(20,'[�����μ�]')
		this.SetItem(1,"deptt",snull)
		this.SetItem(1,"depttname",snull)
		Return 
	END IF
	this.SetItem(1,"depttname",sDeptName)
END IF

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

type dw_junpoy from datawindow within w_kifa42
boolean visible = false
integer x = 78
integer y = 2300
integer width = 1029
integer height = 104
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

type dw_sungin from datawindow within w_kifa42
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

type dw_detail from datawindow within w_kifa42
boolean visible = false
integer x = 1152
integer y = 2620
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "������ ǰ�� ��"
string dataobject = "d_kifa425"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_group_detail from datawindow within w_kifa42
boolean visible = false
integer x = 1152
integer y = 2520
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "������ �� ����Ʈ"
string dataobject = "d_kifa424"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vat from datawindow within w_kifa42
boolean visible = false
integer x = 69
integer y = 2516
integer width = 1029
integer height = 104
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

type dw_print from datawindow within w_kifa42
boolean visible = false
integer x = 73
integer y = 2624
integer width = 1019
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

type rr_1 from roundrectangle within w_kifa42
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 308
integer width = 4567
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kifa42
integer x = 3877
integer y = 228
integer width = 366
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

type dw_rtv from datawindow within w_kifa42
integer x = 64
integer y = 316
integer width = 4539
integer height = 1908
integer taborder = 30
string dataobject = "d_kifa422"
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

event itemchanged;String  sChk,sCheckNo
Integer iCount

IF this.GetColumnName() = "chk" THEN
	sChk = this.GetText()
	IF sChk = "" OR IsNull(sChk) THEN Return
	
	IF sChk = '1' THEN
		sCheckNo = this.GetItemString(this.GetRow(),"kif03ot0_checkno")
		
		SELECT Count(*)     INTO :iCount  
		   FROM "KIF03OT1"  
   		WHERE ( "KIF03OT1"."IP_JPNO" = :sCheckNo ) AND  
         		( "KIF03OT1"."ACCODE" is null OR "KIF03OT1"."ACCODE" = '');
		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		
		IF iCount > 0 THEN
			F_MessageChk(1,'[ǰ�� ��������]')
			Return 1
		END IF
	END IF
END IF
end event

type dw_delete from datawindow within w_kifa42
integer x = 64
integer y = 316
integer width = 4539
integer height = 1908
integer taborder = 40
string dataobject = "d_kifa423"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;IF row <=0 THEN return

SelectRow(0,  False)
SelectRow(Row,True)

OpenWithParm(w_kifa42a,this.GetItemString(row,"kif03ot0_checkno"))
end event

event clicked;IF Row <=0 THEN Return

//IF this.GetColumnName() = "chk" THEN
//	SelectRow(0,False)
//ELSE
	SelectRow(0,False)
	SelectRow(Row,True)	
//END IF
	
end event

