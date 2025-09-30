$PBExportHeader$w_sal_04000.srw
$PBExportComments$���ݵ��
forward
global type w_sal_04000 from w_inherite
end type
type dw_misu from datawindow within w_sal_04000
end type
type dw_misu1 from datawindow within w_sal_04000
end type
type dw_display from datawindow within w_sal_04000
end type
type dw_hap_disp from datawindow within w_sal_04000
end type
type rr_2 from roundrectangle within w_sal_04000
end type
type p_newno from uo_picture within w_sal_04000
end type
type p_newseq from uo_picture within w_sal_04000
end type
type p_suno_inq from uo_picture within w_sal_04000
end type
type pb_1 from u_pb_cal within w_sal_04000
end type
end forward

global type w_sal_04000 from w_inherite
string title = "�� �� �� ��"
dw_misu dw_misu
dw_misu1 dw_misu1
dw_display dw_display
dw_hap_disp dw_hap_disp
rr_2 rr_2
p_newno p_newno
p_newseq p_newseq
p_suno_inq p_suno_inq
pb_1 pb_1
end type
global w_sal_04000 w_sal_04000

type variables
String is_SugumNo, &
          is_mode
String isSugumNo_old, &
          isIpgumType_old, &
          isIpgumCause_old, &
          isIpgumNo_old, &
          isIpgumDate_old, &
          isEmpId_old, &
          isCvCod_old, &
          isBmanDat_old, &
          isMisuDate_old
Integer iiSugumSeq_old
long   ilIpgumAmt_old
String isIpGumYN, sMagamil, isSaleSugum
end variables

forward prototypes
private function string wf_sugum_no (string stoday)
public function integer wf_sugum_seq (string ssugumno)
public function string wf_next_month (string arg_yymm)
public function boolean wf_sugumno_chk (string s1, string s2)
public function integer wf_ipgumpyo_update (string s1, string s2)
public function integer wf_ipgumpyo_insert (string s1, string s2, string s3)
public function integer wf_set_empid (ref string sempid, ref string sempname)
public function string wf_ipgum_no (string sipgumno)
public function integer wf_find_salescod (string arg_cvcod)
public function string wf_get_empid (string scvcod, ref string arg_saupj)
public function integer wf_longmisu_update (string s1, long s2, string s3, string s4)
public function integer wf_longmisu_insert (string s1, long s2, string s3, string s4)
public function integer wf_sugum_insert ()
public function integer wf_sugum_update ()
public function double wf_set_misugum (string arg_cvcod)
public function integer wf_check_key ()
public function integer wf_check_closing (string arg_yymm)
end prototypes

private function string wf_sugum_no (string stoday);//*************************************************************************************//
//**** ������ ���ݹ�ȣ ��������(wf_sugum_no)
// * argument : String sToday (���� ����(System����))
//
// * return   : String (�ű� ���� ��ȣ) 
//************************************************************************************//
String sSugum_No

Select Max(sugum_No) 
Into :sSugum_No 
From SUGUM 
Where Substr(sugum_No,1,8) = :stoday ; 

if (sSugum_No = '') or isNull(sSugum_No) then
	Return sToday + '001'
else
	Return String(double(sSugum_No) + 1)
end if
end function

public function integer wf_sugum_seq (string ssugumno);//*************************************************************************************//
//**** ������ ���ݹ�ȣ�� ���� �����׹���������(wf_sugum_seq)
// * argument : String sSugumNo (���ݹ�ȣ)
//
// * return   : Integer (�ű� �׹�) 
//************************************************************************************//
Integer iSugum_Seq

Select Max(sugum_Seq) 
Into :iSugum_Seq 
From SUGUM 
Where (sabu = :gs_sabu) and (sugum_No = :sSugumNo) ; 

if (iSugum_Seq = 0) or isNull(iSugum_Seq) then
	Return 1
else
	Return iSugum_Seq + 1
end if
end function

public function string wf_next_month (string arg_yymm);//*********************************************************************
// �Ϳ� ���ϱ�(wf_next_month)
//*********************************************************************
String sYear, sMonth
Int iNextM

sYear = Left(arg_yymm,4)
sMonth = Right(arg_yymm,2)
iNextM = Integer(sMonth) + 1

if iNextM > 12 then
	sYear = String(Integer(sYear) + 1)
	sMonth = '01'
else
	sMonth = Mid('0'+String(iNextM), Len(String(iNextM)),2)
end if

Return sYear + sMonth
end function

public function boolean wf_sugumno_chk (string s1, string s2);//*************************************************************************************//
//**** ���ݹ�ȣ �� �Ա�ǥ��ȣ ���� ���� ���� Check(wf_sugumno_chk)
// * argument : String s1(���ݹ�ȣ), s2(�Աݹ�ȣ)
//
// * return   : boolean (�����ϸ� : True, �������������� : False) 
//************************************************************************************//
Integer iCnt

Select Count(*)
Into :iCnt
From sugum
Where (sugum_no = :s1) and (ipgum_no = :s2); // ���ݹ�ȣ�� �����鼭 �Ա�ǥ��ȣ�� ������

if (iCnt = 0) or isNull(iCnt) then 
	Return False
else
	Return True
end if


end function

public function integer wf_ipgumpyo_update (string s1, string s2);//*********************************************************************************
// subject  : �Ա����°� ����,����,�����̸� �Ա�ǥ ������� ��� ���(Update)
// argument : s1(string) => Ipgum_Type(�Ա�����(OLD))
//            s2(string) => Ipgum_No(�Ա�ǥ��ȣ(OLD))
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
Integer cnt

/* if s1 < '4' then */
/* �Ա�ǥ��ȣ�� �ԷµǾ� ������ */
If Not IsNull(s2) and s2 <> '' Then 
	
   Select Count(*) Into :cnt
	From   sugum
	Where  ipgum_no = :s2;
	
	if cnt > 0 then
      Update ipgumpyo Set use_gu = '2'
      where ipgum_no = :s2;
	else
      Update ipgumpyo Set use_gu = '1', waste_date = ''
      where ipgum_no = :s2;
	end if
	
   if SQLCA.SQLCODE <> 0 THEN
	   MessageBox("Ȯ��","�Ա�ǥ ��뱸�� UPDATE ����!!!")
   	Return 1
   end if	
end if

return 0
end function

public function integer wf_ipgumpyo_insert (string s1, string s2, string s3);//*********************************************************************************
// subject  : �Ա����°� ����,����,�����̸� �Ա�ǥ ������� ���(Update)
// argument : s1(string) => Ipgum_Type(�Ա�����)
//            s2(string) => Ipgum_No(�Ա�ǥ��ȣ)
//            s3(string) => Ipgum_Date(�Ա�����)
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
/*if s1 < '4' then */

/* �Ա�ǥ��ȣ�� �ԷµǾ� ������ */
If Not IsNull(s2) and s2 <> '' Then 
 	Update ipgumpyo Set use_gu = '2', waste_date = :s3
   where ipgum_no = :s2;

   if SQLCA.SQLCODE <> 0 THEN
      MessageBox("Ȯ��", "�Ա�ǥ ��뱸�� UPDATE ����!!!")
      SetPointer(Arrow!)
     	Return 1
   end if	
end if

return 0
end function

public function integer wf_set_empid (ref string sempid, ref string sempname);/* ��������� id,�� */
If sEmpId <> '' Then
  SELECT "REFFPF"."RFNA1" INTO :sEmpName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND 
         ( "REFFPF"."RFCOD" = '47' ) AND  
         ( "REFFPF"."RFGUB" = :sEmpId )   ;
Else
  SELECT "REFFPF"."RFGUB" INTO :sEmpId
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND 
         ( "REFFPF"."RFCOD" = '47' ) AND  
         ( "REFFPF"."RFNA1" = :sEmpName )   ;
End If

Return 0
end function

public function string wf_ipgum_no (string sipgumno);//*************************************************************************************//
//**** �Ա�ǥ��ȣ ���� ���� Check(wf_ipgum_no)
// * argument : String sIpgumNo (�Աݹ�ȣ)
//
//************************************************************************************//
String sUseGu

Select use_gu
Into :sUseGu
From ipgumpyo
Where (ipgum_no = :sIpgumNo)  and  //������ �̻���ΰ�(1)
      not(rcv_date is Null);

If IsNull(sUseGu) Or Trim(sUseGu) = '' Then sUseGu = '0'

/* 1: �̻��,2:���,3:���,'0':������ */
Return sUseGu
end function

public function integer wf_find_salescod (string arg_cvcod);String sSaleCodnm, sSaleCod

SELECT CVCOD, CVNAS2 INTO :sSaleCod, :sSaleCodnm
  FROM VNDMST
 WHERE CVCOD = ( SELECT NVL(SALESCOD,CVCOD) FROM VNDMST WHERE CVCOD = :arg_cvcod );
 
dw_insert.SetItem(1,"salecod",   sSaleCod)
dw_insert.SetItem(1,"salecodnm", sSaleCodnm)

Return 1
end function

public function string wf_get_empid (string scvcod, ref string arg_saupj);/* �ŷ�ó�� ��������� */
String sEmpId

SELECT "VNDMST"."SALE_EMP", "SAREA"."SAUPJ"
  INTO :sEmpId, :arg_saupj
  FROM "VNDMST", "SAREA"
 WHERE "VNDMST"."CVCOD" = :sCvcod AND
       "VNDMST"."SAREA" = "SAREA"."SAREA"(+);
 

Return sEmpId
end function

public function integer wf_longmisu_update (string s1, long s2, string s3, string s4);//*********************************************************************************
// subject  : �Աݻ����� ���̼� �Ǵ� ���̼������� ��� ���̼� ���̺��� ����
// argument : s1(string) => Ipgum_Cause(�Աݻ���(OLD))
//            s2(long)   => Ipgum_Amt(�Աݾ�(OLD))
//            s3(string) => Cvcod(�ŷ�ó(OLD))
//            s4(string) => long_misu_date(���̼�å������(OLD))
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
if s1 = '3' then
   sle_msg.Text = '���̼��̷� ���̺� ���ݺ� ����ó��'
   Update longmisu_h Set sugum_sum = sugum_sum - :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
   	Return 1
   end if	
elseif s1 = 'A' then
   sle_msg.Text = '���̼��̷� ���̺� ���ڼ��ݺ� ����ó��'
   Update longmisu_h Set ija_sum = ija_sum - :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
   	Return 1
   end if	
end if

return 0
end function

public function integer wf_longmisu_insert (string s1, long s2, string s3, string s4);//*********************************************************************************
// subject  : �Աݻ����� ���̼� �Ǵ� ���̼������� ��� ���̼� ���̺��� ����
// argument : s1(string) => Ipgum_Cause(�Աݻ���)
//            s2(long)   => Ipgum_Amt(�Աݾ�)
//            s3(string) => Cvcod(�ŷ�ó)
//            s4(string) => long_misu_date(���̼�å������)
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
if s1 = '3' then
   sle_msg.Text = '���̼��̷� ���̺� ����ó��'
  
  	Update longmisu_h Set sugum_sum = sugum_sum + :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
      f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
      Return 1
   end if	
elseif s1 = 'A' then
   sle_msg.Text = '���̼��̷� ���̺� ���ڼ���ó��'
	
   Update longmisu_h Set ija_sum = ija_sum + :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
      f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
      Return 1
   end if	
end if

return 0
end function

public function integer wf_sugum_insert ();Integer i, iSugumSeq, cnt
string  sSugumNo, sIpgumType, sIpgumCause, sIpgumNo, sIpgumEmp, sIpgumDate, sMisuDate, &
        sEmpId, sEmpName, sCvCod, sCvnas2, sBmanDat, sDay1, sDay2, sMisuYm, sToday, &
		  sSugumdate, sLastDate, sNextDate, sSaupj
Long    lBaseRate, lBaseDaySu, lIpgumAmt, lDaySu, lChack, lJiyonSu, &
        lSunSu, lJukSu, lIjaAmt, lBillIl

If dw_Insert.AcceptText() <> 1 Then Return 0

sSugumNo    = dw_Insert.GetItemString(1,"sugum_no")      // ���ݹ�ȣ
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")     // �����׹�
sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // �Ա�����
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // �Աݻ���
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // �Աݹ�ȣ
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // �Ա�����
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // �Աݴ����
sEmpName    = dw_Insert.GetItemString(1,"ipgum_emp_name")  // �Աݴ���ڸ�
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // ���ݾ�
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // �ŷ�ó�ڵ�
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // �ŷ�ó��
sBmanDat    = dw_Insert.GetItemString(1,"bman_dat")      // ���� ��������
sMisuDate   = dw_Insert.GetItemString(1,"long_misu_date")// ���̼�å������
sToday      = f_today()
sSaupj      = dw_Insert.GetItemString(1,"saupj")      // �ΰ������

lBillIl     = dw_Insert.GetItemNumber(1,"bill_il")      // ����ȸ����

//*****************************************************************************
// ���� ����
//*****************************************************************************
sle_msg.Text = '�������� �� �Ա�ǥ ��뱸�� ����'
if dw_Insert.Update() = -1 then  
   f_message_Chk(32, '[��������Ȯ��]')
	Rollback;
	return 1
end if

//*****************************************************************************
// �Ա����°� �ܻ���Ի�� or �������� �ƴϸ� �Ա�ǥ ������� ���(Update)
//*****************************************************************************
if wf_ipgumpyo_insert(sIpgumType, sIpgumNo, sIpgumDate) = 1 then
   Rollback;
	return 1
end if

//*****************************************************************************
// �Աݻ����� ���̼� �Ǵ� ���̼������� ��� ���̼� ���̺� �������� ó��
//*****************************************************************************
if wf_longmisu_insert(sIpgumCause, lIpgumAmt, sCvCod, sMisuDate) = 1 then
	Rollback;
	return 1
end if	

//COMMIT;

dw_Insert.Reset()
dw_Insert.InsertRow(0)
dw_insert.SetItem(1, "sabu", gs_sabu)
dw_Insert.SetItem(1, "sugum_no", is_SugumNo)
dw_Insert.SetItem(1, "sugum_seq", wf_Sugum_seq(is_SugumNo))
dw_Insert.SetItem(1, "ipgum_type", '1')
dw_Insert.SetItem(1, "ipgum_cause", sIpgumCause)
dw_Insert.SetItem(1, "ipgum_no", sIpgumNo)
dw_Insert.SetItem(1, "ipgum_date", sIpgumDate)
dw_Insert.SetItem(1, "ipgum_emp_id", sEmpId)
dw_Insert.SetItem(1, "ipgum_emp_name", sEmpName)
dw_Insert.SetItem(1, "cvcod", sCvCod)
dw_Insert.SetItem(1, "cvnas2", sCvnas2)
dw_Insert.SetItem(1, "saupj", ssaupj)
dw_Insert.SetItem(1, "bill_il", lBillIl)

dw_display.retrieve(gs_sabu, is_SugumNo)
dw_Hap_Disp.retrieve(is_SugumNo)

return 0
end function

public function integer wf_sugum_update ();Integer i, iSugumSeq, cnt
string  sSugumNo, sIpgumType, sIpgumCause, sIpgumNo, sIpgumEmp, sIpgumDate, sMisuDate, &
        sEmpId, sCvCod, sCvnas2, sBmanDat, sDay1, sDay2, sMisuYm, sToday, &
		  sSugumdate, sLastDate, sNextDate
Long    lBaseRate, lBaseDaySu, lIpgumAmt, lDaySu, lChack, lJiyonSu, &
        lSunSu, lJukSu, lIjaAmt

If dw_Insert.AcceptText() <> 1 Then Return 1

sSugumNo    = dw_Insert.GetItemString(1,"sugum_no")      // ���ݹ�ȣ
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")     // �����׹�
sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // �Ա�����
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // �Աݻ���
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // �Աݹ�ȣ
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // �Ա�����
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // �Աݴ����
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // ���ݾ�
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // �ŷ�ó�ڵ�
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // �ŷ�ó��
sBmanDat    = dw_Insert.GetItemString(1,"bman_dat")      // ���� ��������
sMisuDate   = dw_Insert.GetItemString(1,"long_misu_date")// ���̼�å������
sToday      = f_today()

/* old value */
isIpgumType_old = dw_Insert.GetItemString(1,"ipgum_type",Primary!, True)
isIpgumNo_old = dw_Insert.GetItemString(1,"ipgum_no",Primary!, True)


//*******************************************************************************
//***  ���̼� ���� DATA FIELD�� MODIFY �Ǿ��� ���                          ***
//*******************************************************************************
if (dw_insert.GetItemStatus(1, 'ipgum_cause', Primary!) = DataModified!) or &
   (dw_insert.GetItemStatus(1, 'ipgum_amt', Primary!) = DataModified!) or &
   (dw_insert.GetItemStatus(1, 'cvcod', Primary!) = DataModified!) or &	
	(dw_insert.GetItemStatus(1, 'long_misu_date', Primary!) = DataModified!) then
	// ���̼� ���̺� OLD �Աݾ� ���
   if wf_longmisu_update(isIpgumCause_old, ilIpgumAmt_old, isCvCod_old, isMisuDate_old) = 1 then
		Rollback;
		return 1
	end if
   // ���̼� ���̺� NEW �Աݾ� ����
   if wf_longmisu_insert(sIpgumCause, lIpgumAmt, sCvCod, sMisuDate) = 1 then
		Rollback;
		return 1
	end if	
end if

//*****************************************************************************
// ���� ���� ���� ����
//*****************************************************************************
sle_msg.Text = '���� ���� ���� ����'
if dw_Insert.Update() = -1 then  
   f_message_Chk(32, '[��������Ȯ��]')
	Rollback;
	return 1
end if

//*******************************************************************************
//***  �Ա�ǥ ���� DATA FIELD�� MODIFY �Ǿ��� ���                            ***
//*******************************************************************************
If isIpgumType_old <> sIpgumType or  isIpgumNo_old <> sIpgumNo Then
	// �Ա�ǥ ���̺� OLD �Աݹ�ȣ ���
	MessageBox(isIpgumType_old, isIpgumNo_old)
   if wf_ipgumpyo_update(isIpgumType_old, isIpgumNo_old) = 1 then
		Rollback;
		return 1
	end if
	
   // �Ա�ǥ ���̺� NEW �Աݹ�ȣ ����
   if wf_ipgumpyo_insert(sIpgumType, sIpgumNo, sIpgumDate) = 1 then
		Rollback;
		return 1
	end if
end if

//Commit;

return 0
end function

public function double wf_set_misugum (string arg_cvcod);String sIpGumDate
Double dMisu

sIpGumDate = Left(Trim(dw_insert.GetItemString(1,'ipgum_date')),6)
If f_datechk(sIpGumDate+'01') <> 1 Then Return 0

select nvl(iwol_credit_amt,0) - ( nvl(sugum_bill,0) + nvl(sugum_save,0) + nvl(sugum_cash,0) + nvl(sugum_gita,0) )
  into :dMisu
  from vndjan
 where sabu = :gs_sabu and
       base_yymm = :sIpGumDate and
		 cvcod = :arg_cvcod and
		 silgu = (select substr(dataname,1,1) from syscnfg 
                               where sysgu = 'S' and
                                     serial = 8 and
                                     lineno = '40' );

If IsNull(dMisu) Then dMisu = 0

dw_insert.SetItem(1,'misugum',dMisu)

Return dMisu
end function

public function integer wf_check_key ();String sSugumNo,sIpgumDate,sIpgumtype,sCvcod,sIpgumNo, sIpGumCause, sRecvBigo, sLongMisuDate, sSaupj
String sBillNo, sBmanDat, sSaveCode, sSaleCod, sGb, sCustNo, sNull, sbill_nm, sbill_bank, sbbal_dat
Double dIpGumAmt, dBillAmt, dMisuGum

SetNull(sNull)

SetPointer(HourGlass!)
If dw_Insert.AcceptText() <> 1 then Return -1

sSugumNo   = Trim(dw_Insert.GetItemString(1, 'sugum_no'))
sIpGumDate = Trim(dw_Insert.GetItemString(1, 'ipgum_date'))
sIpGumType = Trim(dw_Insert.GetItemString(1, 'ipgum_type'))
sIpGumCause= Trim(dw_Insert.GetItemString(1, 'ipgum_cause'))
sRecvBigo  = Trim(dw_Insert.GetItemString(1, 'recv_bigo'))
sCvcod     = Trim(dw_Insert.GetItemString(1, 'cvcod'))
sSaleCod   = Trim(dw_Insert.GetItemString(1, 'salecod'))
sIpGumNo   = Trim(dw_Insert.GetItemString(1, 'ipgum_no'))
dIpGumAmt  = dw_Insert.GetItemNumber(1, 'ipgum_amt')
dBillAmt   = dw_Insert.GetItemNumber(1, 'bill_amt')

sBillNo   	 = Trim(dw_Insert.GetItemString(1, 'bill_no'))
sBill_nm   	 = Trim(dw_Insert.GetItemString(1, 'bill_nm'))
sBill_bank   = Trim(dw_Insert.GetItemString(1, 'bill_bank'))
sbbal_dat    = Trim(dw_Insert.GetItemString(1, 'bbal_dat'))
sBmanDat  = Trim(dw_Insert.GetItemString(1, 'bman_dat'))
sSaveCode = Trim(dw_Insert.GetItemString(1, 'save_code'))

sLongMisuDate = Trim(dw_Insert.GetItemString(1, 'long_misu_date')) 

sSaupj     = Trim(dw_Insert.GetItemString(1, 'saupj'))

dw_insert.SetFocus()
dw_insert.SetRow(1)

If sSugumNo = '' or isNull(sSugumNo) then
	MessageBox("Ȯ ��", " �� �� �� : ���ݹ�ȣ�� �ʼ��׸��̹Ƿ� �ݵ�� �Է��ؾ� �մϴ�." + "~n~n" +&
							  " ó����� : �űԼ��ݹ�ȣ�� ä���Ͽ� ����ϼ���.", Exclamation! )
	return -1
end if

If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(1400,'[�ΰ������]')
	dw_insert.SetColumn('saupj')
	Return -1
End If

If f_datechk(sIpgumDate) <> 1 Then 
	f_message_chk(1400,'[�Ա�����]')
	dw_insert.SetColumn('ipgum_date')
	Return -1
End If

If IsNull(sIpGumType) or sIpGumType = '' Then
	f_message_chk(1400,'[�Ա�����]')
	dw_insert.SetColumn('ipgum_type')
	Return -1
End If

/* �Ա�ǥ��ȣ �ʼ��Է� ���� check */
If isIpGumYN = 'Y' and sIpGumType <= '3' and ( IsNull(sIpgumNo) or sIpgumNo = '' ) Then
	f_message_chk(1400,'[�Ա�ǥ��ȣ]')
	dw_insert.SetColumn('ipgum_no')
	Return -1
End If

If IsNull(sCvcod) or sCvcod = '' Then
	f_message_chk(1400,'[�ŷ�ó]')
	dw_insert.SetColumn('cvcod')
	Return -1
End If

If IsNull(sSaleCod) or sSaleCod = '' Then
	f_message_chk(1400,'[�����ŷ�ó]')
	dw_insert.SetColumn('salecod')
	Return -1
End If

If IsNull(dIpGumamt) or dIpGumamt = 0 Then
	f_message_chk(1400,'[�Աݱݾ�]')
	dw_insert.SetColumn('ipgum_amt')
	Return -1
End If


/* ���� ���ŷ�ó �Է� ���� */
SELECT RFNA3 INTO :sGb FROM REFFPF WHERE RFCOD = '38' AND RFGUB = :sIpGumType;

If IsNull(sGb) Or sGb <> 'Y' Then sGb = 'N'

If sGb = 'Y' Then
	sCustNo = Trim(dw_Insert.GetItemString(1, 'cust_no'))
	
	If IsNull(sCustNo) or sCustNo = '' Then
		f_message_chk(1400,'[���ŷ�ó]')
		dw_insert.SetColumn('cust_no')
		Return -1
	End If
Else
	dw_insert.SetItem(1, 'cust_no', sNull)
	dw_insert.SetItem(1, 'custnm', sNull)
End If
		
/* �Աݻ����� ���̼�,���̼������ϰ�� ���̼�å���� �Է� */
If sIpGumCause = '3' Then
	If IsNull(sLongMisuDate) or f_datechk(sLongMisuDate) <> 1 Then
	  f_message_chk(1400,'[���̼�å����]')
	  dw_insert.SetColumn('long_misu_date')
	  Return -1
   End If
End If
		
/* �Ա����°� ������ ��� �����ݾ�,������ȣ,���������� Ȯ�� */
If sIpGumType = '1' or sIpGumType = '9' Then
	
	If IsNull(sbill_nm) or sbill_nm = '' Then
		f_message_chk(1400,'[����������]')
		dw_insert.SetColumn('bill_nm')
		Return -1
	End If
	
	If IsNull(sbill_bank) or sbill_bank = '' Then
		f_message_chk(1400,'[���ް�������]')
		dw_insert.SetColumn('bill_bank')
		Return -1
	End If
	
	If IsNull(sbbal_dat) or sbbal_dat = '' Then
		f_message_chk(1400,'[��������]')
		dw_insert.SetColumn('bbal_dat')
		Return -1
	End If	
	
	If IsNull(dBillAmt) or dBillAmt = 0 Then
	  f_message_chk(1400,'[�����ݾ�]')
	  dw_insert.SetColumn('bill_amt')
	  Return -1
   End If

	If IsNull(sBmanDat) or sBmanDat = '' Then
	  f_message_chk(1400,'[����������]')
	  dw_insert.SetColumn('bman_dat')
	  Return -1
   End If

	If IsNull(sBillNo) or sBillNo = '' Then
	  f_message_chk(1400,'[������ȣ]')
	  dw_insert.SetColumn('bill_no')
	  Return -1
   End If
End If

/* �Ա����°� ������ ��� ���� Ȯ�� */
If sIpGumType = '2' Then
	If IsNull(sSaveCode) or sSaveCode = '' Then
	  f_message_chk(1400,'[�����ڵ�]')
	  dw_insert.SetColumn('save_code')
	  Return -1
   End If
End If

/* �ε������� ��� �Աݺ�� Ȯ�� */
If sIpGumCause = '2' Then
	If IsNull(sRecvBiGo) or sRecvBiGo = '' Then
	  f_message_chk(1400,'[�Աݺ��]')
	  dw_insert.SetColumn('recv_bigo')
	Return -1
   End If
End If

Return 1
end function

public function integer wf_check_closing (string arg_yymm);Int iCount

SELECT COUNT(*)  
 INTO :icount  
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G1' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= :arg_yymm )   ;

If iCount >= 1 then
	f_Message_Chk(60, '')
	return 1
End if

Return 0
		
end function

on w_sal_04000.create
int iCurrent
call super::create
this.dw_misu=create dw_misu
this.dw_misu1=create dw_misu1
this.dw_display=create dw_display
this.dw_hap_disp=create dw_hap_disp
this.rr_2=create rr_2
this.p_newno=create p_newno
this.p_newseq=create p_newseq
this.p_suno_inq=create p_suno_inq
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_misu
this.Control[iCurrent+2]=this.dw_misu1
this.Control[iCurrent+3]=this.dw_display
this.Control[iCurrent+4]=this.dw_hap_disp
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.p_newno
this.Control[iCurrent+7]=this.p_newseq
this.Control[iCurrent+8]=this.p_suno_inq
this.Control[iCurrent+9]=this.pb_1
end on

on w_sal_04000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_misu)
destroy(this.dw_misu1)
destroy(this.dw_display)
destroy(this.dw_hap_disp)
destroy(this.rr_2)
destroy(this.p_newno)
destroy(this.p_newseq)
destroy(this.p_suno_inq)
destroy(this.pb_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_Insert.Settransobject(sqlca)
dw_Display.Settransobject(sqlca)
dw_Hap_Disp.Settransobject(sqlca)
dw_misu.Settransobject(sqlca)
dw_misu1.Settransobject(sqlca)

/* ��꼭�� ���ݰ��� ���� ���� */
select substr(dataname,1,1) into :isSaleSugum
  from syscnfg
 where sysgu = 'S' and
		 serial = 3 and
		 lineno = 50;
If IsNull(isSaleSugum) Then isSaleSugum = '1'

/* �Ա�ǥ��ȣ �ʼ��Է¿���  */
select substr(dataname,1,1) into :isIpGumYn
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 40;

/* ���ݸ�����  */
select rtrim(dataname) into :sMagamIl
  from syscnfg
 where sysgu = 'S' and
       serial = 3 and
       lineno = 30;

If IsNull(sMagamIl) Or Not isNumber(sMagamIl) Then
	MessageBox('Ȯ ��','���ݸ������ڰ� �������� �ʾҽ��ϴ�~n~n������ ���� ȸ������ ������ �ʽ��ϴ�.!!')
End If

p_can.TriggerEvent(Clicked!)


end event

type dw_insert from w_inherite`dw_insert within w_sal_04000
integer x = 78
integer y = 192
integer width = 4507
integer height = 1016
string dataobject = "d_sal_04000"
boolean border = false
end type

event dw_insert::itemchanged;String  sNull,   sSugumNo, sCvCod, scvnas, sEmpId, sEmpName, sIpgumNo, sOldIpgumNo
String  sBillNo, sBillGu, sBmanDat, sBbalDat, sBillBank, sBillNm, sBillOwner, sTempBill, &
          sSave,   sSaveName, sSaveNo,  sIpGumType, sDate, sIpgumCause, sNewBillNo
Long    lBillAmt,lIpGumAmt, lBillIl
Integer iSugumSeq, ists
String  sCvstatus,syyyymm, sLongMisuDate,ls_cust_no,ls_cust_name, sarea, sSaupj, sGb, ls_sts
String  chk_sarea, chk_steam, chk_saupj
Double  dMisugum

SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	// ���ݹ�ȣ �Է½� �ڷ� ���� check(�����ϸ� ȭ�鿡 ����)
   Case "sugum_no"
		is_SugumNo = GetText()
		cb_inq.TriggerEvent(Clicked!)
		
	// �����׹� �Է½� �ڷ� ���� Check(�����ϸ� ȭ�鿡 ����)
	Case "sugum_seq"
		iSugumSeq = Integer(GetText())
   	if retrieve(gs_sabu, is_SugumNo, iSugumSeq) < 1 then 
			Reset()
			InsertRow(0)
			SetItem(1,"sabu", gs_sabu)
			SetItem(1,"sugum_no", is_SugumNo)
			SetItem(1,"sugum_seq", iSugumSeq)
			return 1
		end if

   // �Ա����� ��ȿ�� Check
	Case "ipgum_date"  
      // ���ݹ�ȣ ä�� Check
      sSugumNo = dw_Insert.GetItemString(1, 'sugum_no')
      if sSugumNo = '' or isNull(sSugumNo) then
      	MessageBox("Ȯ ��", " �� �� �� : ���ݹ�ȣ�� �ʼ��׸��̹Ƿ� �ݵ�� �Է��ؾ� �մϴ�." + "~n~n" +&
							  " ó����� : �űԼ��ݹ�ȣ�� ä���Ͽ� ����ϼ���.", Exclamation! )
      	return 1
      end if		
		
		if f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(35, '[�Ա�����]')
			SetItem(1, "ipgum_date", sNull)
			return 1
		end if	
		
	// �Աݴ�����ڵ� �Է½�	
	Case "ipgum_emp_id"
		sEmpId = Trim(Gettext())
		sEmpName = ''
      wf_set_empid(sEmpId,sEmpName)
      SetItem(1,"ipgum_emp_id",sEmpId)
      SetItem(1,"ipgum_emp_name",sEmpName)

	Case "ipgum_emp_name"
		sEmpName = Trim(Gettext())
		sEmpId = ''
      wf_set_empid(sEmpId,sEmpName)

      SetItem(1,"ipgum_emp_id",sEmpId)
      SetItem(1,"ipgum_emp_name",sEmpName)
		
	// �Ա�ǥ��ȣ ���� ���� Check	
	Case "ipgum_no"
		sIpGumType = GetItemString(1,'ipgum_type')
		If sIpGumType > '3' Then Return

		sIpgumNo = Trim(GetText())
		If IsNull(sIpgumNo) or sIpgumNo = '' Then Return
			
		// ���� �Ա�ǥ ��ȣ�� ������		
		Choose Case wf_ipgum_no(sIpgumNo) 
			Case '0'
				f_Message_Chk(33, '[�Աݹ�ȣ]')
				SetItem(1, "ipgum_no", sNull)
				return 1
			Case '2'
			// ���ݹ�ȣ�� �����鼭 �Ա�ǥ��ȣ�� �������� ������
			if wf_sugumno_chk(is_SugumNo, sIpgumNo) = False then
				f_Message_Chk(97, '[�Աݹ�ȣ]')
				SetItem(1, "ipgum_no", sNull)
				return 1
			End if
		End Choose
	
		SetColumn('ipgum_amt')
		SetFocus()
//		return 2
	/* �ŷ��� */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			SetItem(1,"salecod",snull)
			SetItem(1,"salecodnm",snull)
			SetItem(1,"ipgum_emp_id",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD",    "VNDMST"."CVNAS2", "VNDMST"."SALE_EMP",
		       "VNDMST"."CVSTATUS", "SAREA"."SAUPJ",   "SAREA"."SAREA"
		  INTO :sCvcod, :scvnas, :sEmpId , :sCvStatus, :sSaupj, :sarea
		  FROM "VNDMST", "SAREA"
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA"(+) AND
		       "VNDMST"."CVCOD" = :sCvcod;
	
	  /* �ŷ�ó�� ���ų� �ŷ������� ��� */
		IF sqlca.sqlcode <> 0 or IsNull(sCvcod) or sCvcod = '' Or sCvstatus = '2' THEN
			 TriggerEvent(rbuttondown!)
			 return 2
		End If
	
	  /* �ŷ������ϰ��  */
		IF sCvstatus = '1'  THEN
		 IF MessageBox("Ȯ  ��","�ŷ������� �ŷ�ó�Դϴ�." +"~n~n" +&
					 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN 
				cb_can.PostEvent(Clicked!)
				Return
			End If
		End If

		/* User�� ���ұ��� ���� üũ */
		If f_check_sarea(chk_sarea, chk_steam, chk_saupj)  = 1 And chk_sarea <> sarea Then
			f_message_chk(114,'')
			SetItem(1, "cvcod",  snull)
			SetItem(1, "cvnas2", snull)
			SetItem(1,"salecod",snull)
			SetItem(1,"salecodnm",snull)
			SetItem(1, "ipgum_emp_id", snull)
			Return 1
		End If
	
		SetItem(1, "cvnas2", scvnas)
		
		/* �����ŷ�ó ���� */
		wf_find_salescod(sCvcod)
		
		/* ���̼��� ���� */
		wf_set_misugum(sCvcod)
		
		/* ��������� ���� */
		wf_set_empid(sEmpId,sEmpName)
		
		SetItem(1,"ipgum_emp_id",sEmpId)
		SetItem(1,"ipgum_emp_name",sEmpName)
	/* �ŷ�ó�� */
	Case "cvnas2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, chk_steam, sSaupj, sEmpId) <> 1 Then
			SetItem(1, 'cvcod', 		sNull)
			SetItem(1, 'cvnas2',    snull)
			SetItem(1, "salecod",  snull)
			SetItem(1, "salecodnm",snull)
			Return 1
		ELSE
			SetItem(1,'cvcod', sCvcod)
			SetColumn('cvcod')
			TriggerEvent(ItemChanged!)
			Return 1
		END IF
	/* �����ŷ��� */
	Case "salecod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"salecodnm",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2", "VNDMST"."SALE_EMP", "VNDMST"."CVSTATUS"
		  INTO :sCvcod, :scvnas, :sEmpId , :sCvStatus
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sCvcod;
	
	  /* �ŷ�ó�� ���ų� �ŷ������� ��� */
		IF sqlca.sqlcode <> 0 or IsNull(sCvcod) or sCvcod = '' Or sCvstatus = '2' THEN
			 TriggerEvent(rbuttondown!)
			 return 2
		End If
	
	  /* �ŷ������ϰ��  */
		IF sCvstatus = '1'  THEN
		 IF MessageBox("Ȯ  ��","�ŷ������� �ŷ�ó�Դϴ�." +"~n~n" +&
					 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN 
				cb_can.PostEvent(Clicked!)
				Return
			End If
		End If
	
		SetItem(1,"salecodnm",scvnas)
   // �Ա����� ���ý�
	Case "ipgum_type"  
		sIpGumType = GetText()
		
		/* ���� ���ŷ�ó �Է� ���� */
//             SELECT RFNA3 , RFNA4      INTO :sGb    :iSTS    
//		   FROM REFFPF    WHERE RFCOD like '38' AND RFGUB like :sIpGumType ;
		
		select fun_get_reffpf_value('38' , :sIpGumType, '2') into :sGb  from dual;

		select fun_get_reffpf_value('38' , :sIpGumType, '3') into :ls_sts  from dual;
		If 	SQLCA.SqlCode <> 0 Then
			sGb	= 'N'
			iSts	= 1
		End If
		If IsNull(sGb) Or sGb <> 'Y' Then sGb = 'N'
		
		
		If sGb = 'Y' Then
			Modify("p_4.visible = 1")
			Modify("t_cust_no.visible = 1")
			Modify("cust_no.visible = 1")
			Modify("custnm.visible = 1")
		Else
			Modify("p_4.visible = 0")
			Modify("t_cust_no.visible = 0")
			Modify("cust_no.visible = 0")
			Modify("custnm.visible = 0")
			SetItem(1, 'cust_no', sNull)
			SetItem(1, 'custnm', sNull)
		End If
		
		SetItem(1, "bill_no", sNull)
		SetItem(1, "bill_amt", 0)
		SetItem(1, "bman_dat", sNull)
		SetItem(1, "bbal_dat", sNull)
		SetItem(1, "bill_bank", sNull)
		SetItem(1, "bill_nm", sNull)
		SetItem(1, "temp_bill_yn", sNull)
		SetItem(1, "save_code", sNull)
		SetItem(1, "change_yn", sNull)
		SetItem(1, "ab_name", sNull)
		SetItem(1, "ab_no", sNull)
		SetItem(1, "sendfee", 0)

//		SetItem(1, "ipgum_sts", char(iSts))
		SetItem(1, "ipgum_sts", ls_sts)
	
		If sIpgumType = '1' Then
			SetItem(1, "bill_gu", '1')
			SetItem(1, "bill_owner_gu", '2')
		Else
			SetItem(1, "bill_gu", sNull)
			SetItem(1, "bill_owner_gu", sNull)
		End If
		
		/* �Ա����°� ���� ���ں��̸� �Աݹ�ȣ�� '999999' ���� */
		If sIpGumType = 'A' Or sIpGumType = 'B' Then
			SetItem(1,'ipgum_no', '999999')
		Else
//			SetItem(1,'ipgum_no', sNull)
		End If
		
   // �Աݻ��� ���ý�
	Case "ipgum_cause"  
		SetItem(1, "budo_bill_no", sNull)
		SetItem(1, "long_misu_date", sNull)		
		SetItem(1, "ija_gubun", 'N')		
		if getText() = '1' then
			SetItem(1, "ija_gubun", 'Y')
		elseif getText() = '2' then

		elseif (getText() = '3') or (getText() = 'A') then
		else
		end if
		
   // ������ȣ �Է½�
	Case "bill_no"  
		sBillNo  = Trim(GetText())
		sSugumNo = Trim(GetItemString(1, "sugum_no"))
		
      Select bill_gu,bill_amt,bman_dat,bbal_dat,bill_bank,bill_nm,bill_owner_gu,temp_bill_yn
		  Into :sBillGu,:lBillAmt,:sBmanDat,:sBbalDat,:sBillBank,:sBillNm,:sBillOwner,:sTempBill
		  From sugum
		 Where bill_no = :sBillNo and sugum_no = :sSugumNo and
		       rownum = 1;
		
		If SQLCA.SqlCode = 0 Then
			/* ���� ���� */
			SetItem(1, 'ipgum_type', '9')
		Else
			/* ������ ��ϵǾ����� Ȯ�� */
			Select max(bill_il),   max(bill_gu), max(bill_amt), 		max(bman_dat), max(bbal_dat),
			       max(bill_bank), max(bill_nm), max(bill_owner_gu), max(temp_bill_yn)
			  Into :lBillIl, :sBillGu,:lBillAmt,:sBmanDat,:sBbalDat,:sBillBank,
			       :sBillNm,:sBillOwner,:sTempBill
			  From sugum
			 Where bill_no = :sBillNo ;
			 
			If Not IsNull(sBmanDat)  Then
				MessageBox('Ȯ ��','������ ��ϵ� ������ȣ�Դϴ�')
				If IsNull(lBillIl) Then lBillIl = 0
				
				lBillIl += 1
			End If
		End If
		
		SetItem(1, 'bill_gu', sBillGu)
		
		If IsNull(lBillAmt) Then
			SetItem(1, 'bill_amt', GetItemNumber(1, 'ipgum_amt'))
		Else
			SetItem(1, 'bill_amt', lBillAmt)
		End If
		
		SetItem(1, 'bman_dat', sBmanDat)
		SetItem(1, 'bbal_dat', sBbalDat)
		SetItem(1, 'bill_bank', sBillBank)
		SetItem(1, 'bill_nm', sBillNm)
		SetItem(1, 'bill_owner_gu', sBillOwner)
		SetItem(1, 'temp_bill_yn', sTempBill)

		If IsNull(lBillIl) Then lBillIl = 0
		SetItem(1, 'bill_il', lBillIl)
// �������� �Է½�	
	Case "bill_gu"
		
	// ������������ ��ȿ�� Check
   Case "bbal_dat"
		sDate = Trim(GetText())
		If IsNull(sDate) or sDate = '' Then Return
			
		if f_DateChk(sDate) = -1 then
			SetItem(1, "bbal_dat", sNull)
			f_Message_Chk(35, '[������������]')
			return 1
		end if

	// ������������ ��ȿ�� Check
   Case "bman_dat"
		sDate = Trim(GetText())
		If IsNull(sDate) or sDate = '' Then Return
		
		If f_DateChk(sDate) = -1 then
			SetItem(1, "bman_dat", sNull)
			f_Message_Chk(35, '[������������]')
			return 1
		End If		

	// �����ڵ� �Է½�	
	Case "save_code"
		sSave = GetText()
		//************************************************
		Select ab_name, ab_no Into :sSaveName, :sSaveNo
		From   kfm04ot0
		Where  ab_dpno = :sSave;
		//************************************************
		if sSaveName = '' or isNull(sSaveName) then
 			f_Message_Chk(33, '[�������ڵ�]')
			SetItem(1, "save_code", sNull)
			SetItem(1, "ab_name",   sNull)
			SetItem(1, "ab_no",     sNull)
			SetItem(1, "sendfee",   0)
			return 1
		else
			SetItem(1, "ab_name", sSaveName)
			SetItem(1, "ab_no", sSaveNo)
		end if
   /* �Աݱݾ� */
	Case "ipgum_amt"
      lIpGumAmt = Double(GetText())
		If IsNull(lIpGumAmt) Then lIpGumAmt = 0
		
		/* �Ա����°� �����̸� �Աݱݾ� => �����ݾ� */
      sIpGumType = Trim(GetItemString(1,'ipgum_type'))
		If sIpgumType = '1' Then
			SetItem(1,'bill_amt',lIpGumAmt)
		End If
	/* ���̼�å������ */
	Case "long_misu_date"
		sLongMisuDate = Trim(GetText())
		If f_DateChk(sLongMisuDate) = -1 then
			SetItem(1, "long_misu_date", sNull)
			Return 1
		End If
		
		sCvcod = GetItemString(1, 'cvcod')
		
		select long_misu_date into :sLongMisuDate
		  from longmisu_h
		 where cvcod = :scvcod and
		       long_misu_date = :sLongMisuDate;
				 
		If sqlca.sqlcode <> 0 Then
			SetItem(1, "long_misu_date", sNull)
			f_Message_Chk(33, '[���̼�å����]')
			Return 1
		End If
	CASE 'cust_no'
		ls_cust_no = trim(gettext())
		if isnull(ls_cust_no) OR ls_cust_no = "" then
			setitem(1,'cust_no',snull)
			setitem(1,'custnm',snull)
			return 
		end if
		
		select cvnas2
		into :ls_cust_name
		from vndmst
		where cvcod = :ls_cust_no ;
		
		if sqlca.sqlcode <> 0 then
			setitem(1,'cust_no',snull)
			triggerevent(rbuttondown!)
			return 1
		else
			setitem(1,'custnm',ls_cust_name)
			
		end if
		
end Choose
end event

event dw_insert::rbuttondown;String sCol_Name,sEmpId, sEmpName, sIpGumType, sSaupj

sCol_Name = GetColumnName()
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
/* �Ա�ǥ��ȣ�� Right ����Ŭ���� Popup ȭ�� */
	Case "ipgum_no"
		sIpGumType = GetItemString(1,'ipgum_type')
		If sIpGumType > '3' Then Return
		
		gs_code = GetItemString(1, 'ipgum_emp_id')
		if gs_code = '' or isNull(gs_code) then gs_code = '%'
		Open(w_ipgumpyo_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, 'ipgum_no', gs_code)
		SetColumn('ipgum_amt')
		SetFocus()
		return 1		

	/* �ŷ�ó */
	Case "cvcod", "cvnas2"
		gs_gubun = '1'
		If GetColumnName() = "cvnas2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	/* �����ŷ�ó */
	Case "salecod"
		gs_gubun = '1'
		Open(w_agent_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1,"salecodnm", gs_codename)
		SetItem(1,"salecod",   gs_code)
		
		SetFocus()
		SetColumn('ipgum_date')

/* �Աݴ���� */
Case 'ipgum_emp_id','ipgum_emp_name'
	Open(w_sale_emp_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
	
   SetItem(1,"ipgum_emp_id",gs_code)
   SetItem(1,"ipgum_emp_name",gs_codename)

/* ���̼�å�����ڿ� Right ����Ŭ���� Popup ȭ�� */
Case "long_misu_date"
		gs_code = GetItemString(1, 'cvcod')
		gs_codename = GetItemString(1, 'cvnas2')
		Open(w_longmisu_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, 'long_misu_date', gs_code)
		SetColumn('ipgum_amt')
		SetFocus()
		return 1		
		
   // �ε�������ȣ�� Right ����Ŭ���� Popup ȭ��
	Case "budo_bill_no"
		gs_code = GetItemString(1, 'cvcod')

		Open(w_budo_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, 'budo_bill_no', gs_code)
		SetColumn('ipgum_amt')
		SetFocus()
		return 1				
		
   // �������ڵ忡 Right ����Ŭ���� Popup ȭ��
	Case "save_code"
		gs_code = GetText()
		Open(w_kfm04ot0_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, "save_code", gs_code)
		SetItem(1, "ab_name", gs_codename)
		SetItem(1, "ab_no", gs_gubun)
		SetItem(1, "sendfee", 0)
		cb_mod.SetFocus()
		return 1	
		
   /* ���ŷ�ó */
	Case "cust_no"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1,"custnm",gs_codename)
		SetItem(1,"cust_no",gs_code)
end Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemfocuschanged;if (this.GetColumnName() = "bill_bank") or &
   (this.GetColumnName() = "bill_nm") or &
	(this.GetColumnName() = "recv_bigo") then
	f_toggle_kor(handle(parent))		// �ѱ� ���
else
	f_toggle_eng(handle(parent))		// ���� ���
end if

end event

event dw_insert::ue_pressenter;/* Ŀ�� ���� */
Choose Case this.getcolumnname() 
	Case "cvcod"
    SetColumn('ipgum_date')
    return 1
	Case "bill_amt"
    SetColumn('bill_no')
    return 1
End Choose
	
Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event dw_insert::retrieveend;/* ��ȸ�� �̼��� ��Ȳ�� ��ȸ */
If rowcount > 0 Then
	wf_set_misugum(GetItemString(rowcount,'cvcod'))
End If
end event

type p_delrow from w_inherite`p_delrow within w_sal_04000
integer x = 3657
integer y = 2756
end type

type p_addrow from w_inherite`p_addrow within w_sal_04000
integer x = 3483
integer y = 2756
end type

type p_search from w_inherite`p_search within w_sal_04000
integer x = 3886
integer y = 2712
end type

type p_ins from w_inherite`p_ins within w_sal_04000
integer x = 3419
integer y = 2664
end type

type p_exit from w_inherite`p_exit within w_sal_04000
end type

type p_can from w_inherite`p_can within w_sal_04000
end type

event p_can::clicked;call super::clicked;Parent.SetRedraw(False)

dw_Insert.Reset()
dw_Display.Reset()
dw_Hap_Disp.Reset()
dw_Insert.Insertrow(0)

dw_Hap_Disp.Insertrow(0)

dw_insert.SetItem(1, "sabu", gs_sabu)

// �ΰ��� ����� ����
f_mod_saupj(dw_insert, 'saupj')

sle_msg.Text = '�ű� ��Ͻô� ���ݹ�ȣ�� ä���Ͻð�, ����,��ȸ�ô� ���ݹ�ȣ��ȸ�� ��������.'

p_newno.SetFocus()

p_del.Enabled = True
p_mod.Enabled = True

ib_any_typing = False

isIpgumType_old = ''
isIpgumNo_old = ''

Parent.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_sal_04000
integer x = 4059
integer y = 2712
end type

type p_inq from w_inherite`p_inq within w_sal_04000
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String sNull,syyyymm, sBalDate
Integer iSugumSeq,nrow,iCount

SetNull(sNull)

If dw_Insert.AcceptText() = -1 Then Return

If (dw_Insert.GetItemString(1,"sugum_no") = '') Or &
	isNull(dw_Insert.GetItemString(1,"sugum_no")) Then // KEY�� SPACE �̰ų� NULL �϶�
	f_Message_Chk(30, '[���ݹ�ȣ]')
	dw_Insert.SetItem(1, "sugum_no", sNull)
	dw_Insert.SetFocus()
	Return 1	
Else
   dw_insert.SetItem(1, "sabu", gs_sabu)
   is_SugumNo = dw_Insert.GetItemString(1, "sugum_no")
   iSugumSeq  = dw_Insert.GetItemNumber(1, "sugum_seq")
	
   If dw_Insert.retrieve(gs_sabu, is_SugumNo, iSugumSeq) < 1 THEN
		MessageBox("Ȯ��","�ش��ڷᰡ �����ϴ�")
		is_mode = ""
		dw_Insert.Reset()
		dw_Insert.InsertRow(0)
		dw_Display.Setfocus()
		Return
   End if

	dw_display.retrieve(gs_sabu, is_SugumNo)
	dw_Hap_Disp.retrieve(is_SugumNo)	
	
 	dw_Insert.AcceptText()
   isSugumNo_old    = dw_Insert.GetItemString(1,"sugum_no")      // ���ݹ�ȣ
   iiSugumSeq_old   = dw_Insert.GetItemNumber(1,"sugum_seq")     // �����׹�
   isIpgumType_old  = dw_Insert.GetItemString(1,"ipgum_type")    // �Ա�����
   isIpgumCause_old = dw_Insert.GetItemString(1,"ipgum_cause")   // �Աݻ���
   isIpgumNo_old    = dw_Insert.GetItemString(1,"ipgum_no")      // �Աݹ�ȣ
   isIpgumDate_old  = dw_Insert.GetItemString(1,"ipgum_date")    // �Ա�����
   isEmpId_old      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // �Աݴ����
   ilIpgumAmt_old   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // ���ݾ�
   isCvCod_old      = dw_Insert.GetItemString(1,"cvcod")         // �ŷ�ó�ڵ�
   isBmanDat_old    = dw_Insert.GetItemString(1,"bman_dat")      // ���� ��������	
   isMisuDate_old   = dw_Insert.GetItemString(1, "long_misu_date")// ���̼�å������
	 is_mode = 'U'
	
   ib_any_typing = False	
	
	dw_Insert.SetColumn("ipgum_date")
	dw_insert.SetFocus()
End If

/* ��ȸ�� row�� ã�� ���� */
nRow = dw_display.Find('sugum_seq = ' + string(iSugumSeq) ,1, dw_display.Rowcount())

If nRow > 0 Then
	dw_display.ScrollToRow(nRow)
	dw_display.SetRow(nRow)
	dw_Display.SelectRow(0,False)
	dw_Display.SelectRow(nRow,True)
End If

/* ������ üũ �Ͽ� ����,������ư ����  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	w_mdi_frame.sle_msg.Text = '����ó���� ���ݳ��� �Դϴ�. ���� �� ������ �� �� �����ϴ�.'
	
	Return
End If

/* ����ǥ���� Ȯ�� */
If nRow > 0 Then
	sBalDate = Trim(dw_Display.GetItemString(nRow, "bal_date"))
	If IsNull(sBalDate) or sBalDate = '' Then
		p_del.Enabled = True
		p_mod.Enabled = True
	Else
		p_del.Enabled = False
		p_mod.Enabled = False
		w_mdi_frame.sle_msg.Text = '����ǥ ����� �ڷ��Դϴ�. �����̳� ������ �Ұ����մϴ�.!!'
		Return
	End If
Else
	p_del.Enabled = True
	p_mod.Enabled = True
End If

w_mdi_frame.sle_msg.Text = '���� ��ϵ� ���ݳ��� �Դϴ�. ���� �� ������ �� �� �ֽ��ϴ�.'	

end event

type p_del from w_inherite`p_del within w_sal_04000
end type

event p_del::clicked;call super::clicked;Integer i, iSugumSeq, cnt
string  sSugumNo, sIpgumType, sIpgumCause, sIpgumNo, sCvCod, sMisuYm, sToday, sMisuDate
Long    lIpgumAmt, lChack

Beep (1)

If dw_Insert.AcceptText() <> 1 Then Return 1

/* ������ üũ �Ͽ� ����,������ư ����  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	w_mdi_frame.sle_msg.Text = '����ó���� ���ݳ��� �Դϴ�. ���� �� ������ �� �� �����ϴ�.'
	
	Return
End If

sSugumNo    = Trim(dw_Insert.GetItemString(1,"sugum_no"))      // ���ݹ�ȣ
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")           // �����׹�

If IsNull(sSugumNo) Or sSugumNo = '' Then Return 
If IsNull(iSugumSeq) Or iSugumSeq = 0 Then Return 

if MessageBox("�� ��", "�����׹� "+String(iSugumSeq,'00') +"�� �����մϴ�." + "~r~r" + &
                       "������ �����ϸ�, �Ա�ǥ��뿩��, ���̼��� �����ڷᰡ" + "~r" + &
							  "�ϰ� ���� ó���˴ϴ�." + "~r~r" + &
							  "������ ���� �Ͻðڽ��ϱ�?",question!,yesno!, 2) = 2 THEN Return
								
w_mdi_frame.sle_msg.Text = '���� ������......'
SetPointer(HourGlass!)

sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // �Ա�����
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // �Աݻ���
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // �Աݹ�ȣ
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // ���ݾ�
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // �ŷ�ó�ڵ�
sMisuDate   = dw_Insert.GetItemString(1, "long_misu_date")// �̼�å������	
sToday      = f_today()

dw_misu1.Reset()
dw_misu1.Retrieve(sCvCod)
dw_insert.SetRedraw(False)

//*****************************************************************************
// ���� ����
//*****************************************************************************
dw_insert.DeleteRow(0)
if dw_insert.Update() < 0 THEN
	f_Message_Chk(31, '[����Ȯ��]')
	Rollback;
	Return
end if

//*****************************************************************************
// �Ա����°� ��Ÿ�� �ƴϸ� �Ա�ǥ ������� ��� ���(Update)
//*****************************************************************************
if sIpgumtype < '4' then
   Select Count(*) Into :cnt
	From   sugum
	Where  ipgum_no = :sIpgumNo;
	
	if cnt > 0 then
      Update ipgumpyo Set use_gu = '2'
      where ipgum_no = :sIpgumNo;
	else
      Update ipgumpyo Set use_gu = '1', waste_date = ''
      where ipgum_no = :sIpgumNo;
	end if
	
   if SQLCA.SQLCODE <> 0 THEN
	   MessageBox("Ȯ��","�Ա�ǥ ��뱸�� UPDATE ����!!!")
	   Rollback;
   	Return
   end if	
end if

//*****************************************************************************
// �Աݻ����� ���̼� �Ǵ� ���̼������� ��� ���̼� ���̺��� ����
//*****************************************************************************
if sIpgumCause = '3' then
   w_mdi_frame.sle_msg.Text = '���̼��̷� ���̺� ���ݺ� ����ó��'
   Update longmisu_h Set sugum_sum = sugum_sum - :lIpgumAmt
   where cvcod = :sCvCod and long_misu_date = :sMisuDate;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
	   Rollback;
		SetPointer(Arrow!)
   	Return
   end if	
elseif sIpgumCause = 'A' then
   w_mdi_frame.sle_msg.Text = '���̼��̷� ���̺� ���ڼ��ݺ� ����ó��'
   Update longmisu_h Set ija_sum = ija_sum - :lIpgumAmt
   where cvcod = :sCvCod and long_misu_date = :sMisuDate;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[���̼��̷� ���̺� UPDATE]')
	   Rollback;
		SetPointer(Arrow!)
   	Return
   end if	
end if


Commit;
MessageBox('Ȯ��','���� ���� ó�� �Ϸ�') 
w_mdi_frame.sle_msg.Text = '�ű� ����� ���ݹ�ȣ�� ä���ϼ���'

//********************************************************************************

dw_insert.SetRedraw(true)
dw_Insert.InsertRow(0)
p_newno.SetFocus()

dw_display.retrieve(gs_sabu, is_SugumNo)
dw_Hap_Disp.retrieve(is_SugumNo)

SetPointer(Arrow!)

ib_any_typing = False
end event

type p_mod from w_inherite`p_mod within w_sal_04000
end type

event p_mod::clicked;Long nRow
String sIpgumtype, sIpgumCause, sAcccdtype, sSanggu, sDcgu1, sAcccdcause, sdcgu2, sbill_nm, sbill_bank, sbbal_dat
SetPointer(HourGlass!)

If wf_check_key() <> 1 then Return

/* ������ üũ �Ͽ� ����,������ư ����  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	sle_msg.Text = '����ó���� ���ݳ��� �Դϴ�. ���� �� ������ �� �� �����ϴ�.'
	
	Return
End If

/* ����ó���� ���� ���� �ڷ� */
sIpgumType	= dw_insert.GetItemString(1, 'ipgum_type')
sIpgumCause	= dw_insert.GetItemString(1, 'ipgum_cause')
gs_code 		= dw_insert.GetItemString(1, 'sugum_no')
gs_gubun		= String(dw_insert.GetItemNumber(1, 'sugum_seq'))

Choose Case is_mode
	Case 'I'
		if wf_sugum_insert() = 0 then
			ib_any_typing = False
			w_mdi_frame.sle_msg.Text = '���� �ű� ���� �Ϸ�'
			
			dw_Insert.SetColumn("ipgum_amt")
			dw_Insert.SetFocus()	
		end if
	Case 'U'
		if wf_sugum_update() = 0 then
			ib_any_typing = False
			w_mdi_frame.sle_msg.Text = '���� ���� ���� �Ϸ�'
			
			p_newno.SetFocus()	
		end if		
end Choose

///* ����ó�� ------------------------------------------ */
//
/* �Ա����� : ��������, �������� */
SELECT RFNA2 INTO :sAccCdType FROM REFFPF WHERE RFCOD = '38' AND RFGUB = :sIpgumType;

SELECT SANG_GU, DC_GU INTO :sSanggu, :sDcgu1 FROM KFZ01OM0 
 WHERE ACC1_CD||ACC2_CD = :sAccCdType;
If sqlca.sqlcode <> 0 Then sSAnggu = 'N'

If IsNull(sSanggu) Or sSAnggu = 'N' Then	SetNull(sAccCdType)

/* �Ա޻��� : ��������, �������� */
SELECT RFNA2 INTO :sAccCdCause FROM REFFPF WHERE RFCOD = '39' AND RFGUB = :sIpgumCause;

SELECT SANG_GU, DC_GU INTO :sSanggu, :sDcgu2 FROM KFZ01OM0 
 WHERE ACC1_CD||ACC2_CD = :sAccCdCause;
If sqlca.sqlcode <> 0 Then sSAnggu = 'N'

If IsNull(sSanggu) Or sSAnggu = 'N' Then	SetNull(sAccCdCause)

//Messagebox('type',sAccCdType)
//Messagebox('cause',sAcccdCause)

If Not IsNull(sAccCdType) And Not IsNull(sAcccdCause) Then
	gs_codename = sAccCdType	/* �Ա�����,������ ���� */
	openwithparm(w_kfz19ot0_sugum_popup, '3')
ElseIf Not IsNull(sAccCdType) Then
	gs_codename = sAccCdType	/* �Ա����·� ���� */
	openwithparm(w_kfz19ot0_sugum_popup, '1')
ElseIf Not IsNull(sAcccdCause) Then
	gs_codename = sAccCdCause	/* �Աݻ����� ���� */
	openwithparm(w_kfz19ot0_sugum_popup, '2')
Else
	gs_code = 'Y'
End If

/* ������ǥ�� �������� ���� ��� reject */
If gs_code = 'N' Then
	RollBack;
	p_can.TriggerEvent(Clicked!)
	Return
End If

/* ����ó�� ------------------------------------------ */

COMMIT;

/* ��ȸ */
dw_Hap_Disp.retrieve(is_SugumNo)

/* �����ŷ�ó ���� */
wf_find_salescod(dw_insert.GetItemString(1,'cvcod'))
		
wf_set_misugum(dw_insert.GetItemString(1,'cvcod'))

nRow = dw_display.retrieve(gs_sabu, is_SugumNo)
If nRow > 0 Then
	dw_display.ScrollToRow(nRow)
	dw_display.SetRow(nRow)
End If
end event

type cb_exit from w_inherite`cb_exit within w_sal_04000
integer x = 3177
integer y = 2764
integer taborder = 50
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_04000
integer x = 2112
integer y = 2764
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_04000
integer x = 1696
integer y = 2484
integer taborder = 100
end type

type cb_del from w_inherite`cb_del within w_sal_04000
integer x = 2464
integer y = 2764
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_04000
integer x = 9
integer y = 2760
integer width = 379
integer taborder = 120
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_04000
integer x = 2080
integer y = 2476
integer taborder = 130
end type

type st_1 from w_inherite`st_1 within w_sal_04000
end type

type cb_can from w_inherite`cb_can within w_sal_04000
integer x = 2825
integer y = 2764
integer taborder = 40
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_04000
integer x = 2875
integer y = 2764
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_04000
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_04000
end type

type dw_misu from datawindow within w_sal_04000
boolean visible = false
integer x = 137
integer y = 2532
integer width = 1312
integer height = 388
integer taborder = 150
boolean bringtotop = true
string dataobject = "d_sal_04000_03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_misu1 from datawindow within w_sal_04000
boolean visible = false
integer x = 1527
integer y = 2528
integer width = 1294
integer height = 384
integer taborder = 160
boolean bringtotop = true
string dataobject = "d_sal_04000_04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_display from datawindow within w_sal_04000
integer x = 105
integer y = 1220
integer width = 4407
integer height = 832
integer taborder = 60
string dataobject = "d_sal_04000_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;// ���õ�(CLICK) ROW�� �Ķ������� ǥ��
if row > 0 then
   dw_Display.SelectRow(0,False)
   dw_Display.SelectRow(row,true)
else 
	return
end if

integer iSugumSeq
String sSabu, sSugumNo, sBal_Date, sIja_gubun
long lrow

sSabu = dw_Display.GetItemString(row, "sabu")
is_SugumNo = dw_Display.GetItemString(row, "sugum_no")
iSugumSeq = dw_Display.GetItemNumber(row, "sugum_seq")

IF dw_Insert.retrieve(sSabu, is_SugumNo, iSugumSeq) < 1 THEN
	MessageBox("Ȯ��","�ش��ڷᰡ �����ϴ�")
	dw_Insert.Reset()
	dw_Insert.InsertRow(0)
	dw_Display.Setfocus()
  return
END IF
ib_any_typing = False

/* ����ǥ���� Ȯ�� */
sBal_date = Trim(dw_Display.GetItemString(row, "bal_date"))
If IsNull(sBal_date) or sBal_date = '' Then
	cb_del.Enabled = True
	cb_mod.Enabled = True
	sle_msg.Text = ''
Else
	cb_del.Enabled = False
	cb_mod.Enabled = False
	sle_msg.Text = '����ǥ ����� �ڷ��Դϴ�. �����̳� ������ �Ұ����մϴ�.!!'
End If

sIja_gubun = Trim(dw_Display.GetItemString(row, "sugum_ija_gubun"))
If sIja_gubun = 'Y' Then
	sle_msg.Text = '�ŷ�ó�� ���� ���������� �ϼž� �մϴ�.'
End If

dw_Insert.SetFocus()
dw_insert.SetColumn('ipgum_amt')
end event

event doubleclicked;//integer iSugumSeq
//String sSabu, sSugumNo
//long lrow
//
//lrow = dw_Display.GetRow()
//
//dw_Display.SelectRow(0,False)
//dw_Display.SelectRow(row,true)
//
//dw_Display.Accepttext()
//sSabu = dw_Display.GetItemString(lrow, "sabu")
//is_SugumNo = dw_Display.GetItemString(lrow, "sugum_no")
//iSugumSeq = dw_Display.GetItemNumber(lrow, "sugum_seq")
//
//IF dw_Insert.retrieve(sSabu, is_SugumNo, iSugumSeq) < 1 THEN
//	MessageBox("Ȯ��","�ش��ڷᰡ �����ϴ�")
//	dw_Insert.Reset()
//   dw_Insert.InsertRow(0)
//	dw_Display.Setfocus()
//   return
//END IF
//
////dw_Insert.SetColumn("sugum_type")
//dw_Insert.SetFocus()
end event

type dw_hap_disp from datawindow within w_sal_04000
integer x = 105
integer y = 2076
integer width = 4421
integer height = 104
string dataobject = "d_sal_04000_02"
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_sal_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 1212
integer width = 4448
integer height = 992
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_newno from uo_picture within w_sal_04000
integer x = 91
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\��ȣä��_up.gif"
end type

event clicked;call super::clicked;String sSugumNo

dw_Insert.Reset()
dw_Insert.Insertrow(0)
dw_insert.SetItem(1, "sabu", gs_sabu)

// �ΰ��� ����� ����
f_mod_saupj  (dw_insert, 'saupj')

// ��ǥ���к� ������ȣ ���� ���̺��� ����(G1)������ǥ ��ȣ�� ä��
sSugumNo = String(SQLCA.fun_junpyo(gs_sabu, f_today(), 'G1'))
commit;

is_SugumNo = f_today() + Mid('00' + sSugumNo, Len(sSugumNo), 3)
//is_SugumNo = wf_sugum_no(f_today())

dw_Insert.SetItem(1, "Sugum_No", is_SugumNo)
dw_Insert.SetItem(1, "Sugum_Seq", 1)

dw_Insert.SetItem(1, "ipgum_date", f_today())
	
dw_display.retrieve(gs_sabu, is_SugumNo)
dw_Hap_Disp.retrieve(is_SugumNo)

is_mode = 'I'

w_mdi_frame.sle_msg.Text = '�ű� ���ݹ�ȣ �� �׹��Դϴ�. ���ݳ����� �Է��ϼ���.'

p_mod.enabled = true
p_del.enabled = true			

p_mod.PictureName = 'C:\erpman\image\����_up.gif'
p_del.PictureName = 'C:\erpman\image\����_up.gif'

dw_Insert.setcolumn("saupj")
dw_Insert.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\��ȣä��_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\��ȣä��_up.gif'
end event

type p_newseq from uo_picture within w_sal_04000
integer x = 265
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\�׹�ä��_up.gif"
end type

event clicked;call super::clicked;String sIpgumType, sIpgumCause, sIpgumNo, sIpgumDate, sEmpId, sEmpName
String sCvcod, sCvnas2, sSalecod, sSaleCodnm, sSaupj

if dw_insert.AcceptText() = -1 then
	MessageBox('Error', '���ݹ�ȣ�� �ԷµǾ����� �ʽ��ϴ�.' + "~r~r" + &
	                    '���� ���ݹ�ȣ ä���� �ϴ���, ���ݹ�ȣ�� ��ȸ�� �Ŀ�' + "~r" + &
							  '�����׹��� ä���ϼ���')
	return 1
end if

is_SugumNo = dw_insert.GetItemString(1, "sugum_no")
if is_SugumNo = '' or isNull(is_SugumNo) then
	MessageBox('Ȯ��', '���ݹ�ȣ�� �ԷµǾ����� �ʽ��ϴ�.' + "~r~r" + &
	                    '���� ���ݹ�ȣ ä���� �ϴ���, ���ݹ�ȣ�� ��ȸ�� �Ŀ�' + "~r" + &
							  '�����׹��� ä���ϼ���')
	return 1
end if

sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // �Ա�����
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // �Աݻ���
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // �Աݹ�ȣ
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // �Ա�����
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // �Աݴ����
sEmpName    = dw_Insert.GetItemString(1,"ipgum_emp_name")  // �Աݴ���ڸ�

sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // �ŷ�ó�ڵ�
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // �ŷ�ó��
sSaleCod    = dw_Insert.GetItemString(1,"salecod")         // �ŷ�ó�ڵ�
sSaleCodnm  = dw_Insert.GetItemString(1,"salecodnm")        // �ŷ�ó��
sSaupj		= dw_Insert.GetItemString(1,"saupj")

dw_insert.SetRedraw(False)
dw_Insert.Reset()
dw_Insert.Insertrow(0)

dw_insert.SetItem(1, "sabu", gs_sabu)
dw_Insert.SetItem(1, "sugum_no", is_SugumNo)
dw_Insert.SetItem(1, "sugum_seq", wf_Sugum_seq(is_SugumNo))
dw_Insert.SetItem(1, "ipgum_type", sIpgumType)
dw_Insert.SetItem(1, "ipgum_cause", sIpgumCause)
dw_Insert.SetItem(1, "ipgum_no", sIpgumNo)
dw_Insert.SetItem(1, "ipgum_date", sIpgumDate)
dw_Insert.SetItem(1, "ipgum_emp_id", sEmpId)
dw_Insert.SetItem(1, "ipgum_emp_name", sEmpName)
dw_Insert.SetItem(1, "cvcod", sCvCod)
dw_Insert.SetItem(1, "cvnas2", sCvnas2)
dw_Insert.SetItem(1, "salecod", sSaleCod)
dw_Insert.SetItem(1, "salecodnm", sSaleCodnm)
dw_Insert.SetItem(1, "saupj", sSaupj)

//dw_insert.Modify('saupj.protect = 1')
//dw_insert.Modify("saupj.background.color = 80859087")

wf_set_misugum(sCvcod) // �̼���

is_mode = 'I'

sle_msg.Text = '�ش���ݹ�ȣ�� �ű��׹��Դϴ�. ���ݳ����� �Է��ϼ���.'

dw_Display.SelectRow(0,False)
dw_Display.ScrollToRow(dw_Display.RowCount())

dw_insert.SetRedraw(True)

dw_Insert.setcolumn("ipgum_amt")
dw_Insert.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�׹�ä��_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\�׹�ä��_up.gif'
end event

type p_suno_inq from uo_picture within w_sal_04000
integer x = 439
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\��ȣ��ȸ_up.gif"
end type

event clicked;call super::clicked;Long nRow

open(w_sugumno_popup)

if gs_code = "" or isnull(gs_code) then
	return
else
  dw_insert.SetItem(1, 'sugum_no', gs_code)
  dw_insert.SetItem(1, 'sugum_seq', Integer(gs_codename))
	
	p_inq.TriggerEvent(Clicked!)
	
  dw_display.SetFocus()
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\��ȣ��ȸ_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\��ȣ��ȸ_up.gif'
end event

type pb_1 from u_pb_cal within w_sal_04000
integer x = 1024
integer y = 476
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('ipgum_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'ipgum_date', gs_code)

end event

