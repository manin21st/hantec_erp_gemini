$PBExportHeader$w_sal_04000.srw
$PBExportComments$수금등록
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
string title = "수 금 등 록"
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
//**** 당일의 수금번호 가져오기(wf_sugum_no)
// * argument : String sToday (당일 일자(System일자))
//
// * return   : String (신규 수금 번호) 
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
//**** 당일의 수금번호의 최종 수금항번가져오기(wf_sugum_seq)
// * argument : String sSugumNo (수금번호)
//
// * return   : Integer (신규 항번) 
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
// 익월 구하기(wf_next_month)
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
//**** 수금번호 및 입금표번호 동시 존재 유무 Check(wf_sugumno_chk)
// * argument : String s1(수금번호), s2(입금번호)
//
// * return   : boolean (존재하면 : True, 존재하지않으면 : False) 
//************************************************************************************//
Integer iCnt

Select Count(*)
Into :iCnt
From sugum
Where (sugum_no = :s1) and (ipgum_no = :s2); // 수금번호가 같으면서 입금표번호도 같은것

if (iCnt = 0) or isNull(iCnt) then 
	Return False
else
	Return True
end if


end function

public function integer wf_ipgumpyo_update (string s1, string s2);//*********************************************************************************
// subject  : 입금형태가 어음,예금,현금이면 입금표 사용으로 등록 취소(Update)
// argument : s1(string) => Ipgum_Type(입금형태(OLD))
//            s2(string) => Ipgum_No(입금표번호(OLD))
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
Integer cnt

/* if s1 < '4' then */
/* 입금표번호가 입력되어 있으면 */
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
	   MessageBox("확인","입금표 사용구분 UPDATE 실패!!!")
   	Return 1
   end if	
end if

return 0
end function

public function integer wf_ipgumpyo_insert (string s1, string s2, string s3);//*********************************************************************************
// subject  : 입금형태가 어음,예금,현금이면 입금표 사용으로 등록(Update)
// argument : s1(string) => Ipgum_Type(입금형태)
//            s2(string) => Ipgum_No(입금표번호)
//            s3(string) => Ipgum_Date(입금일자)
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
/*if s1 < '4' then */

/* 입금표번호가 입력되어 있으면 */
If Not IsNull(s2) and s2 <> '' Then 
 	Update ipgumpyo Set use_gu = '2', waste_date = :s3
   where ipgum_no = :s2;

   if SQLCA.SQLCODE <> 0 THEN
      MessageBox("확인", "입금표 사용구분 UPDATE 실패!!!")
      SetPointer(Arrow!)
     	Return 1
   end if	
end if

return 0
end function

public function integer wf_set_empid (ref string sempid, ref string sempname);/* 영업담당자 id,명 */
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
//**** 입금표번호 존재 유무 Check(wf_ipgum_no)
// * argument : String sIpgumNo (입금번호)
//
//************************************************************************************//
String sUseGu

Select use_gu
Into :sUseGu
From ipgumpyo
Where (ipgum_no = :sIpgumNo)  and  //구분이 미사용인것(1)
      not(rcv_date is Null);

If IsNull(sUseGu) Or Trim(sUseGu) = '' Then sUseGu = '0'

/* 1: 미사용,2:사용,3:폐기,'0':미존재 */
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

public function string wf_get_empid (string scvcod, ref string arg_saupj);/* 거래처의 영업담당자 */
String sEmpId

SELECT "VNDMST"."SALE_EMP", "SAREA"."SAUPJ"
  INTO :sEmpId, :arg_saupj
  FROM "VNDMST", "SAREA"
 WHERE "VNDMST"."CVCOD" = :sCvcod AND
       "VNDMST"."SAREA" = "SAREA"."SAREA"(+);
 

Return sEmpId
end function

public function integer wf_longmisu_update (string s1, long s2, string s3, string s4);//*********************************************************************************
// subject  : 입금사유가 장기미수 또는 장기미수이자일 경우 장기미수 테이블에서 차감
// argument : s1(string) => Ipgum_Cause(입금사유(OLD))
//            s2(long)   => Ipgum_Amt(입금액(OLD))
//            s3(string) => Cvcod(거래처(OLD))
//            s4(string) => long_misu_date(장기미수책정일자(OLD))
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
if s1 = '3' then
   sle_msg.Text = '장기미수이력 테이블에 수금분 차감처리'
   Update longmisu_h Set sugum_sum = sugum_sum - :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
   	Return 1
   end if	
elseif s1 = 'A' then
   sle_msg.Text = '장기미수이력 테이블에 이자수금분 차감처리'
   Update longmisu_h Set ija_sum = ija_sum - :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
   	Return 1
   end if	
end if

return 0
end function

public function integer wf_longmisu_insert (string s1, long s2, string s3, string s4);//*********************************************************************************
// subject  : 입금사유가 장기미수 또는 장기미수이자일 경우 장기미수 테이블에서 누계
// argument : s1(string) => Ipgum_Cause(입금사유)
//            s2(long)   => Ipgum_Amt(입금액)
//            s3(string) => Cvcod(거래처)
//            s4(string) => long_misu_date(장기미수책정일자)
// return   : Integer (0 : Success, 1 : fail)
//*********************************************************************************
if s1 = '3' then
   sle_msg.Text = '장기미수이력 테이블에 수금처리'
  
  	Update longmisu_h Set sugum_sum = sugum_sum + :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
      f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
      Return 1
   end if	
elseif s1 = 'A' then
   sle_msg.Text = '장기미수이력 테이블에 이자수금처리'
	
   Update longmisu_h Set ija_sum = ija_sum + :s2
   where cvcod = :s3 and long_misu_date = :s4;
	
   if SQLCA.SQLCODE <> 0 THEN
      f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
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

sSugumNo    = dw_Insert.GetItemString(1,"sugum_no")      // 수금번호
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")     // 수금항번
sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // 입금형태
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // 입금사유
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // 입금번호
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // 입금일자
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // 입금담당자
sEmpName    = dw_Insert.GetItemString(1,"ipgum_emp_name")  // 입금담당자명
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // 수금액
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // 거래처코드
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // 거래처명
sBmanDat    = dw_Insert.GetItemString(1,"bman_dat")      // 어음 만기일자
sMisuDate   = dw_Insert.GetItemString(1,"long_misu_date")// 장기미수책정일자
sToday      = f_today()
sSaupj      = dw_Insert.GetItemString(1,"saupj")      // 부가사업장

lBillIl     = dw_Insert.GetItemNumber(1,"bill_il")      // 어음회전일

//*****************************************************************************
// 수금 저장
//*****************************************************************************
sle_msg.Text = '수금저장 및 입금표 사용구분 수정'
if dw_Insert.Update() = -1 then  
   f_message_Chk(32, '[수금저장확인]')
	Rollback;
	return 1
end if

//*****************************************************************************
// 입금형태가 외상매입상계 or 가수금이 아니면 입금표 사용으로 등록(Update)
//*****************************************************************************
if wf_ipgumpyo_insert(sIpgumType, sIpgumNo, sIpgumDate) = 1 then
   Rollback;
	return 1
end if

//*****************************************************************************
// 입금사유가 장기미수 또는 장기미수이자일 경우 장기미수 테이블에 수금으로 처리
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

sSugumNo    = dw_Insert.GetItemString(1,"sugum_no")      // 수금번호
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")     // 수금항번
sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // 입금형태
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // 입금사유
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // 입금번호
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // 입금일자
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // 입금담당자
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // 수금액
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // 거래처코드
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // 거래처명
sBmanDat    = dw_Insert.GetItemString(1,"bman_dat")      // 어음 만기일자
sMisuDate   = dw_Insert.GetItemString(1,"long_misu_date")// 장기미수책정일자
sToday      = f_today()

/* old value */
isIpgumType_old = dw_Insert.GetItemString(1,"ipgum_type",Primary!, True)
isIpgumNo_old = dw_Insert.GetItemString(1,"ipgum_no",Primary!, True)


//*******************************************************************************
//***  장기미수 관련 DATA FIELD가 MODIFY 되었을 경우                          ***
//*******************************************************************************
if (dw_insert.GetItemStatus(1, 'ipgum_cause', Primary!) = DataModified!) or &
   (dw_insert.GetItemStatus(1, 'ipgum_amt', Primary!) = DataModified!) or &
   (dw_insert.GetItemStatus(1, 'cvcod', Primary!) = DataModified!) or &	
	(dw_insert.GetItemStatus(1, 'long_misu_date', Primary!) = DataModified!) then
	// 장기미수 테이블에 OLD 입금액 취소
   if wf_longmisu_update(isIpgumCause_old, ilIpgumAmt_old, isCvCod_old, isMisuDate_old) = 1 then
		Rollback;
		return 1
	end if
   // 장기미수 테이블에 NEW 입금액 갱신
   if wf_longmisu_insert(sIpgumCause, lIpgumAmt, sCvCod, sMisuDate) = 1 then
		Rollback;
		return 1
	end if	
end if

//*****************************************************************************
// 수금 변동 내역 저장
//*****************************************************************************
sle_msg.Text = '수금 변동 내역 저장'
if dw_Insert.Update() = -1 then  
   f_message_Chk(32, '[수금저장확인]')
	Rollback;
	return 1
end if

//*******************************************************************************
//***  입금표 관련 DATA FIELD가 MODIFY 되었을 경우                            ***
//*******************************************************************************
If isIpgumType_old <> sIpgumType or  isIpgumNo_old <> sIpgumNo Then
	// 입금표 테이블에 OLD 입금번호 취소
	MessageBox(isIpgumType_old, isIpgumNo_old)
   if wf_ipgumpyo_update(isIpgumType_old, isIpgumNo_old) = 1 then
		Rollback;
		return 1
	end if
	
   // 입금표 테이블에 NEW 입금번호 갱신
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
	MessageBox("확 인", " 메 세 지 : 수금번호는 필수항목이므로 반드시 입력해야 합니다." + "~n~n" +&
							  " 처리방안 : 신규수금번호를 채번하여 등록하세요.", Exclamation! )
	return -1
end if

If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_insert.SetColumn('saupj')
	Return -1
End If

If f_datechk(sIpgumDate) <> 1 Then 
	f_message_chk(1400,'[입금일자]')
	dw_insert.SetColumn('ipgum_date')
	Return -1
End If

If IsNull(sIpGumType) or sIpGumType = '' Then
	f_message_chk(1400,'[입금형태]')
	dw_insert.SetColumn('ipgum_type')
	Return -1
End If

/* 입금표번호 필수입력 여부 check */
If isIpGumYN = 'Y' and sIpGumType <= '3' and ( IsNull(sIpgumNo) or sIpgumNo = '' ) Then
	f_message_chk(1400,'[입금표번호]')
	dw_insert.SetColumn('ipgum_no')
	Return -1
End If

If IsNull(sCvcod) or sCvcod = '' Then
	f_message_chk(1400,'[거래처]')
	dw_insert.SetColumn('cvcod')
	Return -1
End If

If IsNull(sSaleCod) or sSaleCod = '' Then
	f_message_chk(1400,'[실적거래처]')
	dw_insert.SetColumn('salecod')
	Return -1
End If

If IsNull(dIpGumamt) or dIpGumamt = 0 Then
	f_message_chk(1400,'[입금금액]')
	dw_insert.SetColumn('ipgum_amt')
	Return -1
End If


/* 상계시 상대거래처 입력 여부 */
SELECT RFNA3 INTO :sGb FROM REFFPF WHERE RFCOD = '38' AND RFGUB = :sIpGumType;

If IsNull(sGb) Or sGb <> 'Y' Then sGb = 'N'

If sGb = 'Y' Then
	sCustNo = Trim(dw_Insert.GetItemString(1, 'cust_no'))
	
	If IsNull(sCustNo) or sCustNo = '' Then
		f_message_chk(1400,'[상계거래처]')
		dw_insert.SetColumn('cust_no')
		Return -1
	End If
Else
	dw_insert.SetItem(1, 'cust_no', sNull)
	dw_insert.SetItem(1, 'custnm', sNull)
End If
		
/* 입금사유가 장기미수,장기미수이자일경우 장기미수책정일 입력 */
If sIpGumCause = '3' Then
	If IsNull(sLongMisuDate) or f_datechk(sLongMisuDate) <> 1 Then
	  f_message_chk(1400,'[장기미수책정일]')
	  dw_insert.SetColumn('long_misu_date')
	  Return -1
   End If
End If
		
/* 입금형태가 어음일 경우 어음금액,어음번호,어음만기일 확인 */
If sIpGumType = '1' or sIpGumType = '9' Then
	
	If IsNull(sbill_nm) or sbill_nm = '' Then
		f_message_chk(1400,'[어음발행인]')
		dw_insert.SetColumn('bill_nm')
		Return -1
	End If
	
	If IsNull(sbill_bank) or sbill_bank = '' Then
		f_message_chk(1400,'[지급결제은행]')
		dw_insert.SetColumn('bill_bank')
		Return -1
	End If
	
	If IsNull(sbbal_dat) or sbbal_dat = '' Then
		f_message_chk(1400,'[발행일자]')
		dw_insert.SetColumn('bbal_dat')
		Return -1
	End If	
	
	If IsNull(dBillAmt) or dBillAmt = 0 Then
	  f_message_chk(1400,'[어음금액]')
	  dw_insert.SetColumn('bill_amt')
	  Return -1
   End If

	If IsNull(sBmanDat) or sBmanDat = '' Then
	  f_message_chk(1400,'[어음만기일]')
	  dw_insert.SetColumn('bman_dat')
	  Return -1
   End If

	If IsNull(sBillNo) or sBillNo = '' Then
	  f_message_chk(1400,'[어음번호]')
	  dw_insert.SetColumn('bill_no')
	  Return -1
   End If
End If

/* 입금형태가 예금일 경우 계좌 확인 */
If sIpGumType = '2' Then
	If IsNull(sSaveCode) or sSaveCode = '' Then
	  f_message_chk(1400,'[계좌코드]')
	  dw_insert.SetColumn('save_code')
	  Return -1
   End If
End If

/* 부도어음일 경우 입금비고 확인 */
If sIpGumCause = '2' Then
	If IsNull(sRecvBiGo) or sRecvBiGo = '' Then
	  f_message_chk(1400,'[입금비고]')
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

/* 계산서와 수금과의 관계 여부 */
select substr(dataname,1,1) into :isSaleSugum
  from syscnfg
 where sysgu = 'S' and
		 serial = 3 and
		 lineno = 50;
If IsNull(isSaleSugum) Then isSaleSugum = '1'

/* 입금표번호 필수입력여부  */
select substr(dataname,1,1) into :isIpGumYn
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 40;

/* 수금마감일  */
select rtrim(dataname) into :sMagamIl
  from syscnfg
 where sysgu = 'S' and
       serial = 3 and
       lineno = 30;

If IsNull(sMagamIl) Or Not isNumber(sMagamIl) Then
	MessageBox('확 인','수금마감일자가 지정되지 않았습니다~n~n어음에 대한 회전일이 계산되지 않습니다.!!')
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
	// 수금번호 입력시 자료 유무 check(존재하면 화면에 송출)
   Case "sugum_no"
		is_SugumNo = GetText()
		cb_inq.TriggerEvent(Clicked!)
		
	// 수금항번 입력시 자료 유무 Check(존재하면 화면에 송출)
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

   // 입금일자 유효성 Check
	Case "ipgum_date"  
      // 수금번호 채번 Check
      sSugumNo = dw_Insert.GetItemString(1, 'sugum_no')
      if sSugumNo = '' or isNull(sSugumNo) then
      	MessageBox("확 인", " 메 세 지 : 수금번호는 필수항목이므로 반드시 입력해야 합니다." + "~n~n" +&
							  " 처리방안 : 신규수금번호를 채번하여 등록하세요.", Exclamation! )
      	return 1
      end if		
		
		if f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(35, '[입금일자]')
			SetItem(1, "ipgum_date", sNull)
			return 1
		end if	
		
	// 입금담당자코드 입력시	
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
		
	// 입금표번호 존재 유무 Check	
	Case "ipgum_no"
		sIpGumType = GetItemString(1,'ipgum_type')
		If sIpGumType > '3' Then Return

		sIpgumNo = Trim(GetText())
		If IsNull(sIpgumNo) or sIpgumNo = '' Then Return
			
		// 사용된 입금표 번호가 있으면		
		Choose Case wf_ipgum_no(sIpgumNo) 
			Case '0'
				f_Message_Chk(33, '[입금번호]')
				SetItem(1, "ipgum_no", sNull)
				return 1
			Case '2'
			// 수금번호가 같으면서 입금표번호가 같은것이 없으면
			if wf_sugumno_chk(is_SugumNo, sIpgumNo) = False then
				f_Message_Chk(97, '[입금번호]')
				SetItem(1, "ipgum_no", sNull)
				return 1
			End if
		End Choose
	
		SetColumn('ipgum_amt')
		SetFocus()
//		return 2
	/* 거래선 */
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
	
	  /* 거래처가 없거나 거래종료일 경우 */
		IF sqlca.sqlcode <> 0 or IsNull(sCvcod) or sCvcod = '' Or sCvstatus = '2' THEN
			 TriggerEvent(rbuttondown!)
			 return 2
		End If
	
	  /* 거래중지일경우  */
		IF sCvstatus = '1'  THEN
		 IF MessageBox("확  인","거래중지된 거래처입니다." +"~n~n" +&
					 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN 
				cb_can.PostEvent(Clicked!)
				Return
			End If
		End If

		/* User별 관할구역 권한 체크 */
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
		
		/* 실적거래처 설정 */
		wf_find_salescod(sCvcod)
		
		/* 월미수금 설정 */
		wf_set_misugum(sCvcod)
		
		/* 영업담당자 설정 */
		wf_set_empid(sEmpId,sEmpName)
		
		SetItem(1,"ipgum_emp_id",sEmpId)
		SetItem(1,"ipgum_emp_name",sEmpName)
	/* 거래처명 */
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
	/* 실적거래선 */
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
	
	  /* 거래처가 없거나 거래종료일 경우 */
		IF sqlca.sqlcode <> 0 or IsNull(sCvcod) or sCvcod = '' Or sCvstatus = '2' THEN
			 TriggerEvent(rbuttondown!)
			 return 2
		End If
	
	  /* 거래중지일경우  */
		IF sCvstatus = '1'  THEN
		 IF MessageBox("확  인","거래중지된 거래처입니다." +"~n~n" +&
					 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN 
				cb_can.PostEvent(Clicked!)
				Return
			End If
		End If
	
		SetItem(1,"salecodnm",scvnas)
   // 입금형태 선택시
	Case "ipgum_type"  
		sIpGumType = GetText()
		
		/* 상계시 상대거래처 입력 여부 */
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
		
		/* 입금형태가 수금 이자분이면 입금번호를 '999999' 설정 */
		If sIpGumType = 'A' Or sIpGumType = 'B' Then
			SetItem(1,'ipgum_no', '999999')
		Else
//			SetItem(1,'ipgum_no', sNull)
		End If
		
   // 입금사유 선택시
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
		
   // 어음번호 입력시
	Case "bill_no"  
		sBillNo  = Trim(GetText())
		sSugumNo = Trim(GetItemString(1, "sugum_no"))
		
      Select bill_gu,bill_amt,bman_dat,bbal_dat,bill_bank,bill_nm,bill_owner_gu,temp_bill_yn
		  Into :sBillGu,:lBillAmt,:sBmanDat,:sBbalDat,:sBillBank,:sBillNm,:sBillOwner,:sTempBill
		  From sugum
		 Where bill_no = :sBillNo and sugum_no = :sSugumNo and
		       rownum = 1;
		
		If SQLCA.SqlCode = 0 Then
			/* 동일 어음 */
			SetItem(1, 'ipgum_type', '9')
		Else
			/* 이전에 등록되었는지 확인 */
			Select max(bill_il),   max(bill_gu), max(bill_amt), 		max(bman_dat), max(bbal_dat),
			       max(bill_bank), max(bill_nm), max(bill_owner_gu), max(temp_bill_yn)
			  Into :lBillIl, :sBillGu,:lBillAmt,:sBmanDat,:sBbalDat,:sBillBank,
			       :sBillNm,:sBillOwner,:sTempBill
			  From sugum
			 Where bill_no = :sBillNo ;
			 
			If Not IsNull(sBmanDat)  Then
				MessageBox('확 인','기존에 등록된 어음번호입니다')
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
// 어음구분 입력시	
	Case "bill_gu"
		
	// 어음발행일자 유효성 Check
   Case "bbal_dat"
		sDate = Trim(GetText())
		If IsNull(sDate) or sDate = '' Then Return
			
		if f_DateChk(sDate) = -1 then
			SetItem(1, "bbal_dat", sNull)
			f_Message_Chk(35, '[어음발행일자]')
			return 1
		end if

	// 어음만기일자 유효성 Check
   Case "bman_dat"
		sDate = Trim(GetText())
		If IsNull(sDate) or sDate = '' Then Return
		
		If f_DateChk(sDate) = -1 then
			SetItem(1, "bman_dat", sNull)
			f_Message_Chk(35, '[어음만기일자]')
			return 1
		End If		

	// 예금코드 입력시	
	Case "save_code"
		sSave = GetText()
		//************************************************
		Select ab_name, ab_no Into :sSaveName, :sSaveNo
		From   kfm04ot0
		Where  ab_dpno = :sSave;
		//************************************************
		if sSaveName = '' or isNull(sSaveName) then
 			f_Message_Chk(33, '[예적금코드]')
			SetItem(1, "save_code", sNull)
			SetItem(1, "ab_name",   sNull)
			SetItem(1, "ab_no",     sNull)
			SetItem(1, "sendfee",   0)
			return 1
		else
			SetItem(1, "ab_name", sSaveName)
			SetItem(1, "ab_no", sSaveNo)
		end if
   /* 입금금액 */
	Case "ipgum_amt"
      lIpGumAmt = Double(GetText())
		If IsNull(lIpGumAmt) Then lIpGumAmt = 0
		
		/* 입금형태가 어음이면 입금금액 => 어음금액 */
      sIpGumType = Trim(GetItemString(1,'ipgum_type'))
		If sIpgumType = '1' Then
			SetItem(1,'bill_amt',lIpGumAmt)
		End If
	/* 장기미수책정일자 */
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
			f_Message_Chk(33, '[장기미수책정일]')
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
/* 입금표번호에 Right 버턴클릭시 Popup 화면 */
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

	/* 거래처 */
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
	/* 실적거래처 */
	Case "salecod"
		gs_gubun = '1'
		Open(w_agent_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1,"salecodnm", gs_codename)
		SetItem(1,"salecod",   gs_code)
		
		SetFocus()
		SetColumn('ipgum_date')

/* 입금담당자 */
Case 'ipgum_emp_id','ipgum_emp_name'
	Open(w_sale_emp_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
	
   SetItem(1,"ipgum_emp_id",gs_code)
   SetItem(1,"ipgum_emp_name",gs_codename)

/* 장기미수책정일자에 Right 버턴클릭시 Popup 화면 */
Case "long_misu_date"
		gs_code = GetItemString(1, 'cvcod')
		gs_codename = GetItemString(1, 'cvnas2')
		Open(w_longmisu_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, 'long_misu_date', gs_code)
		SetColumn('ipgum_amt')
		SetFocus()
		return 1		
		
   // 부도어음번호에 Right 버턴클릭시 Popup 화면
	Case "budo_bill_no"
		gs_code = GetItemString(1, 'cvcod')

		Open(w_budo_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, 'budo_bill_no', gs_code)
		SetColumn('ipgum_amt')
		SetFocus()
		return 1				
		
   // 예적금코드에 Right 버턴클릭시 Popup 화면
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
		
   /* 상계거래처 */
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
	f_toggle_kor(handle(parent))		// 한글 모드
else
	f_toggle_eng(handle(parent))		// 영문 모드
end if

end event

event dw_insert::ue_pressenter;/* 커서 제어 */
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

event dw_insert::retrieveend;/* 조회후 미수금 현황을 조회 */
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

// 부가세 사업장 설정
f_mod_saupj(dw_insert, 'saupj')

sle_msg.Text = '신규 등록시는 수금번호를 채번하시고, 수정,조회시는 수금번호조회를 누르세요.'

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
	isNull(dw_Insert.GetItemString(1,"sugum_no")) Then // KEY가 SPACE 이거나 NULL 일때
	f_Message_Chk(30, '[수금번호]')
	dw_Insert.SetItem(1, "sugum_no", sNull)
	dw_Insert.SetFocus()
	Return 1	
Else
   dw_insert.SetItem(1, "sabu", gs_sabu)
   is_SugumNo = dw_Insert.GetItemString(1, "sugum_no")
   iSugumSeq  = dw_Insert.GetItemNumber(1, "sugum_seq")
	
   If dw_Insert.retrieve(gs_sabu, is_SugumNo, iSugumSeq) < 1 THEN
		MessageBox("확인","해당자료가 없습니다")
		is_mode = ""
		dw_Insert.Reset()
		dw_Insert.InsertRow(0)
		dw_Display.Setfocus()
		Return
   End if

	dw_display.retrieve(gs_sabu, is_SugumNo)
	dw_Hap_Disp.retrieve(is_SugumNo)	
	
 	dw_Insert.AcceptText()
   isSugumNo_old    = dw_Insert.GetItemString(1,"sugum_no")      // 수금번호
   iiSugumSeq_old   = dw_Insert.GetItemNumber(1,"sugum_seq")     // 수금항번
   isIpgumType_old  = dw_Insert.GetItemString(1,"ipgum_type")    // 입금형태
   isIpgumCause_old = dw_Insert.GetItemString(1,"ipgum_cause")   // 입금사유
   isIpgumNo_old    = dw_Insert.GetItemString(1,"ipgum_no")      // 입금번호
   isIpgumDate_old  = dw_Insert.GetItemString(1,"ipgum_date")    // 입금일자
   isEmpId_old      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // 입금담당자
   ilIpgumAmt_old   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // 수금액
   isCvCod_old      = dw_Insert.GetItemString(1,"cvcod")         // 거래처코드
   isBmanDat_old    = dw_Insert.GetItemString(1,"bman_dat")      // 어음 만기일자	
   isMisuDate_old   = dw_Insert.GetItemString(1, "long_misu_date")// 장기미수책정일자
	 is_mode = 'U'
	
   ib_any_typing = False	
	
	dw_Insert.SetColumn("ipgum_date")
	dw_insert.SetFocus()
End If

/* 조회된 row를 찾아 반전 */
nRow = dw_display.Find('sugum_seq = ' + string(iSugumSeq) ,1, dw_display.Rowcount())

If nRow > 0 Then
	dw_display.ScrollToRow(nRow)
	dw_display.SetRow(nRow)
	dw_Display.SelectRow(0,False)
	dw_Display.SelectRow(nRow,True)
End If

/* 마감월 체크 하여 저장,삭제버튼 제어  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	w_mdi_frame.sle_msg.Text = '마감처리된 수금내역 입니다. 수정 및 삭제를 할 수 없습니다.'
	
	Return
End If

/* 기전표여부 확인 */
If nRow > 0 Then
	sBalDate = Trim(dw_Display.GetItemString(nRow, "bal_date"))
	If IsNull(sBalDate) or sBalDate = '' Then
		p_del.Enabled = True
		p_mod.Enabled = True
	Else
		p_del.Enabled = False
		p_mod.Enabled = False
		w_mdi_frame.sle_msg.Text = '기전표 발행된 자료입니다. 수정이나 삭제가 불가능합니다.!!'
		Return
	End If
Else
	p_del.Enabled = True
	p_mod.Enabled = True
End If

w_mdi_frame.sle_msg.Text = '기존 등록된 수금내역 입니다. 수정 및 삭제를 할 수 있습니다.'	

end event

type p_del from w_inherite`p_del within w_sal_04000
end type

event p_del::clicked;call super::clicked;Integer i, iSugumSeq, cnt
string  sSugumNo, sIpgumType, sIpgumCause, sIpgumNo, sCvCod, sMisuYm, sToday, sMisuDate
Long    lIpgumAmt, lChack

Beep (1)

If dw_Insert.AcceptText() <> 1 Then Return 1

/* 마감월 체크 하여 저장,삭제버튼 제어  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	w_mdi_frame.sle_msg.Text = '마감처리된 수금내역 입니다. 수정 및 삭제를 할 수 없습니다.'
	
	Return
End If

sSugumNo    = Trim(dw_Insert.GetItemString(1,"sugum_no"))      // 수금번호
iSugumSeq   = dw_Insert.GetItemNumber(1,"sugum_seq")           // 수금항번

If IsNull(sSugumNo) Or sSugumNo = '' Then Return 
If IsNull(iSugumSeq) Or iSugumSeq = 0 Then Return 

if MessageBox("경 고", "수금항번 "+String(iSugumSeq,'00') +"을 삭제합니다." + "~r~r" + &
                       "수금을 삭제하면, 입금표사용여부, 장기미수등 관련자료가" + "~r" + &
							  "일괄 삭제 처리됩니다." + "~r~r" + &
							  "수금을 삭제 하시겠습니까?",question!,yesno!, 2) = 2 THEN Return
								
w_mdi_frame.sle_msg.Text = '수금 삭제중......'
SetPointer(HourGlass!)

sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // 입금형태
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // 입금사유
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // 입금번호
lIpgumAmt   = dw_Insert.GetItemNumber(1,"ipgum_amt")     // 수금액
sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // 거래처코드
sMisuDate   = dw_Insert.GetItemString(1, "long_misu_date")// 미수책정일자	
sToday      = f_today()

dw_misu1.Reset()
dw_misu1.Retrieve(sCvCod)
dw_insert.SetRedraw(False)

//*****************************************************************************
// 수금 삭제
//*****************************************************************************
dw_insert.DeleteRow(0)
if dw_insert.Update() < 0 THEN
	f_Message_Chk(31, '[삭제확인]')
	Rollback;
	Return
end if

//*****************************************************************************
// 입금형태가 기타가 아니면 입금표 사용으로 등록 취소(Update)
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
	   MessageBox("확인","입금표 사용구분 UPDATE 실패!!!")
	   Rollback;
   	Return
   end if	
end if

//*****************************************************************************
// 입금사유가 장기미수 또는 장기미수이자일 경우 장기미수 테이블에서 차감
//*****************************************************************************
if sIpgumCause = '3' then
   w_mdi_frame.sle_msg.Text = '장기미수이력 테이블에 수금분 차감처리'
   Update longmisu_h Set sugum_sum = sugum_sum - :lIpgumAmt
   where cvcod = :sCvCod and long_misu_date = :sMisuDate;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
	   Rollback;
		SetPointer(Arrow!)
   	Return
   end if	
elseif sIpgumCause = 'A' then
   w_mdi_frame.sle_msg.Text = '장기미수이력 테이블에 이자수금분 차감처리'
   Update longmisu_h Set ija_sum = ija_sum - :lIpgumAmt
   where cvcod = :sCvCod and long_misu_date = :sMisuDate;
	
   if SQLCA.SQLCODE <> 0 THEN
	   f_Message_Chk(32,'[장기미수이력 테이블 UPDATE]')
	   Rollback;
		SetPointer(Arrow!)
   	Return
   end if	
end if


Commit;
MessageBox('확인','수금 삭제 처리 완료') 
w_mdi_frame.sle_msg.Text = '신규 등록할 수금번호를 채번하세요'

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

/* 마감월 체크 하여 저장,삭제버튼 제어  */
If wf_check_closing(MID(dw_Insert.GetItemString(1,"ipgum_date"),1,6 )	) = 1 then
	p_mod.enabled = false
	p_del.enabled = false
	
	sle_msg.Text = '마감처리된 수금내역 입니다. 수정 및 삭제를 할 수 없습니다.'
	
	Return
End If

/* 반제처리를 위한 기초 자료 */
sIpgumType	= dw_insert.GetItemString(1, 'ipgum_type')
sIpgumCause	= dw_insert.GetItemString(1, 'ipgum_cause')
gs_code 		= dw_insert.GetItemString(1, 'sugum_no')
gs_gubun		= String(dw_insert.GetItemNumber(1, 'sugum_seq'))

Choose Case is_mode
	Case 'I'
		if wf_sugum_insert() = 0 then
			ib_any_typing = False
			w_mdi_frame.sle_msg.Text = '수금 신규 저장 완료'
			
			dw_Insert.SetColumn("ipgum_amt")
			dw_Insert.SetFocus()	
		end if
	Case 'U'
		if wf_sugum_update() = 0 then
			ib_any_typing = False
			w_mdi_frame.sle_msg.Text = '수금 수정 저장 완료'
			
			p_newno.SetFocus()	
		end if		
end Choose

///* 반제처리 ------------------------------------------ */
//
/* 입급형태 : 반제여부, 대차구분 */
SELECT RFNA2 INTO :sAccCdType FROM REFFPF WHERE RFCOD = '38' AND RFGUB = :sIpgumType;

SELECT SANG_GU, DC_GU INTO :sSanggu, :sDcgu1 FROM KFZ01OM0 
 WHERE ACC1_CD||ACC2_CD = :sAccCdType;
If sqlca.sqlcode <> 0 Then sSAnggu = 'N'

If IsNull(sSanggu) Or sSAnggu = 'N' Then	SetNull(sAccCdType)

/* 입급사유 : 반제여부, 대차구분 */
SELECT RFNA2 INTO :sAccCdCause FROM REFFPF WHERE RFCOD = '39' AND RFGUB = :sIpgumCause;

SELECT SANG_GU, DC_GU INTO :sSanggu, :sDcgu2 FROM KFZ01OM0 
 WHERE ACC1_CD||ACC2_CD = :sAccCdCause;
If sqlca.sqlcode <> 0 Then sSAnggu = 'N'

If IsNull(sSanggu) Or sSAnggu = 'N' Then	SetNull(sAccCdCause)

//Messagebox('type',sAccCdType)
//Messagebox('cause',sAcccdCause)

If Not IsNull(sAccCdType) And Not IsNull(sAcccdCause) Then
	gs_codename = sAccCdType	/* 입금형태,사유로 반제 */
	openwithparm(w_kfz19ot0_sugum_popup, '3')
ElseIf Not IsNull(sAccCdType) Then
	gs_codename = sAccCdType	/* 입금형태로 반제 */
	openwithparm(w_kfz19ot0_sugum_popup, '1')
ElseIf Not IsNull(sAcccdCause) Then
	gs_codename = sAccCdCause	/* 입금사유로 반제 */
	openwithparm(w_kfz19ot0_sugum_popup, '2')
Else
	gs_code = 'Y'
End If

/* 반제전표를 선택하지 않을 경우 reject */
If gs_code = 'N' Then
	RollBack;
	p_can.TriggerEvent(Clicked!)
	Return
End If

/* 반제처리 ------------------------------------------ */

COMMIT;

/* 조회 */
dw_Hap_Disp.retrieve(is_SugumNo)

/* 실적거래처 설정 */
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

event clicked;// 선택된(CLICK) ROW에 파란색으로 표시
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
	MessageBox("확인","해당자료가 없습니다")
	dw_Insert.Reset()
	dw_Insert.InsertRow(0)
	dw_Display.Setfocus()
  return
END IF
ib_any_typing = False

/* 기전표여부 확인 */
sBal_date = Trim(dw_Display.GetItemString(row, "bal_date"))
If IsNull(sBal_date) or sBal_date = '' Then
	cb_del.Enabled = True
	cb_mod.Enabled = True
	sle_msg.Text = ''
Else
	cb_del.Enabled = False
	cb_mod.Enabled = False
	sle_msg.Text = '기전표 발행된 자료입니다. 수정이나 삭제가 불가능합니다.!!'
End If

sIja_gubun = Trim(dw_Display.GetItemString(row, "sugum_ija_gubun"))
If sIja_gubun = 'Y' Then
	sle_msg.Text = '거래처에 대한 이자정산을 하셔야 합니다.'
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
//	MessageBox("확인","해당자료가 없습니다")
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
string picturename = "C:\erpman\image\번호채번_up.gif"
end type

event clicked;call super::clicked;String sSugumNo

dw_Insert.Reset()
dw_Insert.Insertrow(0)
dw_insert.SetItem(1, "sabu", gs_sabu)

// 부가세 사업장 설정
f_mod_saupj  (dw_insert, 'saupj')

// 전표구분별 최종번호 보관 테이블에서 수금(G1)최종전표 번호를 채번
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

w_mdi_frame.sle_msg.Text = '신규 수금번호 및 항번입니다. 수금내역을 입력하세요.'

p_mod.enabled = true
p_del.enabled = true			

p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'

dw_Insert.setcolumn("saupj")
dw_Insert.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\번호채번_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\번호채번_up.gif'
end event

type p_newseq from uo_picture within w_sal_04000
integer x = 265
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\항번채번_up.gif"
end type

event clicked;call super::clicked;String sIpgumType, sIpgumCause, sIpgumNo, sIpgumDate, sEmpId, sEmpName
String sCvcod, sCvnas2, sSalecod, sSaleCodnm, sSaupj

if dw_insert.AcceptText() = -1 then
	MessageBox('Error', '수금번호가 입력되어있지 않습니다.' + "~r~r" + &
	                    '먼저 수금번호 채번을 하던지, 수금번호를 조회한 후에' + "~r" + &
							  '수금항번을 채번하세요')
	return 1
end if

is_SugumNo = dw_insert.GetItemString(1, "sugum_no")
if is_SugumNo = '' or isNull(is_SugumNo) then
	MessageBox('확인', '수금번호가 입력되어있지 않습니다.' + "~r~r" + &
	                    '먼저 수금번호 채번을 하던지, 수금번호를 조회한 후에' + "~r" + &
							  '수금항번을 채번하세요')
	return 1
end if

sIpgumType  = dw_Insert.GetItemString(1,"ipgum_type")    // 입금형태
sIpgumCause = dw_Insert.GetItemString(1,"ipgum_cause")   // 입금사유
sIpgumNo    = dw_Insert.GetItemString(1,"ipgum_no")      // 입금번호
sIpgumDate  = dw_Insert.GetItemString(1,"ipgum_date")    // 입금일자
sEmpId      = dw_Insert.GetItemString(1,"ipgum_emp_id")  // 입금담당자
sEmpName    = dw_Insert.GetItemString(1,"ipgum_emp_name")  // 입금담당자명

sCvCod      = dw_Insert.GetItemString(1,"cvcod")         // 거래처코드
sCvnas2     = dw_Insert.GetItemString(1,"cvnas2")        // 거래처명
sSaleCod    = dw_Insert.GetItemString(1,"salecod")         // 거래처코드
sSaleCodnm  = dw_Insert.GetItemString(1,"salecodnm")        // 거래처명
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

wf_set_misugum(sCvcod) // 미수금

is_mode = 'I'

sle_msg.Text = '해당수금번호의 신규항번입니다. 수금내역을 입력하세요.'

dw_Display.SelectRow(0,False)
dw_Display.ScrollToRow(dw_Display.RowCount())

dw_insert.SetRedraw(True)

dw_Insert.setcolumn("ipgum_amt")
dw_Insert.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\항번채번_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\항번채번_up.gif'
end event

type p_suno_inq from uo_picture within w_sal_04000
integer x = 439
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\번호조회_up.gif"
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\번호조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\번호조회_up.gif'
end event

type pb_1 from u_pb_cal within w_sal_04000
integer x = 1024
integer y = 476
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('ipgum_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'ipgum_date', gs_code)

end event

