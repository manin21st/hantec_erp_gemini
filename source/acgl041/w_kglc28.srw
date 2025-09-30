$PBExportHeader$w_kglc28.srw
$PBExportComments$지급결제 처리(전표 처리)
forward
global type w_kglc28 from w_inherite
end type
type rb_ins from radiobutton within w_kglc28
end type
type rb_del from radiobutton within w_kglc28
end type
type dw_junpoy from datawindow within w_kglc28
end type
type dw_sungin from datawindow within w_kglc28
end type
type dw_list from u_d_select_sort within w_kglc28
end type
type dw_cond from u_key_enter within w_kglc28
end type
type cbx_1 from checkbox within w_kglc28
end type
type dw_jbill from datawindow within w_kglc28
end type
type dw_bill_detail from datawindow within w_kglc28
end type
type rr_1 from roundrectangle within w_kglc28
end type
type rr_2 from roundrectangle within w_kglc28
end type
end forward

global type w_kglc28 from w_inherite
integer x = 27
integer y = 16
integer width = 4302
integer height = 2272
string title = "지급결제  전표발행 처리"
boolean minbox = false
windowtype windowtype = response!
rb_ins rb_ins
rb_del rb_del
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_list dw_list
dw_cond dw_cond
cbx_1 cbx_1
dw_jbill dw_jbill
dw_bill_detail dw_bill_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc28 w_kglc28

type variables
String sBaseDate,LsAutoSungGbn,sWCAcc,sWIAcc,sMJAcc,sSGAcc,sJAAcc,sJGAcc,sJYAcc,sYeCode,sJunMm
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_delete_kfz12ot0 ()
public subroutine wf_accset ()
public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, long llinno, string sbillgbn)
public function integer wf_create_kfz12ot0 (string ssaupj, string sbaldate, string supmugbn)
end prototypes

public subroutine wf_init ();dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"baldate",sBaseDate)
dw_cond.SetRedraw(True)

dw_list.Reset()

dw_list.SetRedraw(False)

IF sModStatus = 'I' THEN
	dw_list.DataObject = 'd_kglc282'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
ELSE
	dw_list.DataObject = 'd_kglc283'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()	
END IF

dw_list.SetRedraw(True)
end subroutine

public function integer wf_delete_kfz12ot0 ();Int    i,k,iCount,iRowCount
Long   lJunNo
String sSaupj,sBalDate,sUpmuGu,sAccNo

dw_junpoy.Reset()

iCount = dw_list.RowCount()

FOR i = 1 TO iCount

	IF dw_list.GetItemString(i,"chkflag") = "N" THEN Continue
	
	sAccNo   = dw_list.GetItemString(i,"accjunno")
	sSaupj   = Mid(dw_list.GetItemString(i,"accjunno"),1,2)
	sBalDate = Mid(dw_list.GetItemString(i,"accjunno"),3,8)
	sUpmuGu  = Mid(dw_list.GetItemString(i,"accjunno"),11,1)
	lJunNo   = Long(Mid(dw_list.GetItemString(i,"accjunno"),12,4))
	
	iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
	IF iRowCount > 0 THEN 			
		FOR k = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(k)		
		NEXT
	END IF

	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(12,'[미승인전표]')
		Return -1
	END IF

	/*결제내역에 전표관련 자료 갱신*/
	Update kfz19ota
		Set accjunno = NULL
		Where accjunno = :sAccNo;
	
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(12,'[결제내역 갱신]')
		Return -1
	END IF
NEXT

Return 1
end function

public subroutine wf_accset ();//외상매출금
Select substr(dataname,1,7)
  Into :sWCAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 85;

//외상매입금
Select substr(dataname,1,7)
  Into :sWIAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 10;

//미지급금
Select substr(dataname,1,7)
  Into :sMJAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 86;

//선급금
Select substr(dataname,43,7)
  Into :sSGAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 9;

//잡이익
Select substr(dataname,1,7)
  Into :sJAAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 7;

//지급어음
Select substr(dataname,15,7)
  Into :sJGAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 10;

//제예금
Select substr(dataname,1,7)
  Into :sJYAcc
  From syscnfg
 Where sysgu = 'A' And serial = 1 And lineno = 8;

//제예금 예적금코드
Select dataname
  Into :sYeCode
  From syscnfg
 Where sysgu = 'A' And serial = 17 And lineno = 7;

Select to_char(add_months(:sBaseDate,-1),'YYYYMM')
  Into :sJunMm
  From dual;
end subroutine

public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, string supmugu, long ljunno, long llinno, string sbillgbn);Int    iFindRow
String sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGu+String(lJunNo,'0000')+String(lLinNo,'000')

dw_bill_detail.Reset()

IF dw_bill_detail.Retrieve(sBaseDate,dw_list.GetItemNumber(iRow,"seqno")) = 0 THEN
	MessageBox("1",sBaseDate)
	MessageBox("2",dw_list.GetItemNumber(iRow,"seqno"))
	Messagebox("확인","어음상세내역이 없습니다! ["+String(iRow)+"행]")
	Return -1
END IF

iFindRow = dw_jbill.InsertRow(0)

dw_jbill.SetItem(iFindRow,"saupj",		sSaupj)
dw_jbill.SetItem(iFindRow,"bal_date",	sBalDate)
dw_jbill.SetItem(iFindRow,"upmu_gu",	sUpmuGu)
dw_jbill.SetItem(iFindRow,"bjun_no",	lJunNo)
dw_jbill.SetItem(iFindRow,"lin_no",		lLinNo)
dw_jbill.SetItem(iFindRow,"full_junno",sFullJunNo)

dw_jbill.SetItem(iFindRow,"bill_no",	dw_bill_detail.GetItemString(1,"billno"))
dw_jbill.SetItem(iFindRow,"saup_no",	dw_list.GetItemString(iRow,"saup_no"))
dw_jbill.SetItem(iFindRow,"bnk_cd",		dw_bill_detail.GetItemString(1,"bank_cd"))
dw_jbill.SetItem(iFindRow,"bbal_dat",	dw_bill_detail.GetItemString(1,"bbaldate"))
dw_jbill.SetItem(iFindRow,"bman_dat",	dw_bill_detail.GetItemString(1,"bmandate"))
dw_jbill.SetItem(iFindRow,"bill_amt",	dw_bill_detail.GetItemNumber(1,"billamt"))
dw_jbill.SetItem(iFindRow,"bill_nm",	dw_bill_detail.GetItemString(1,"bill_nm"))
dw_jbill.SetItem(iFindRow,"status",		'1')

dw_jbill.SetItem(iFindRow,"owner_saupj",sSaupj)
dw_jbill.SetItem(iFindRow,"bill_gbn",	sBillGbn)

Return 1
end function

public function integer wf_create_kfz12ot0 (string ssaupj, string sbaldate, string supmugbn);Int    i,iLinNo,iRowCount,iCurRow,iSeqNo
LOng   lJunPoyNo
Double dCashAmt,dGeyAmt,dSaGAmt,dMiJiAmt,dGoAmt,dJanAmt,dMiAmt,dBillAmt
String sAccJunNo,sSaupNo,sSaupNm,sDcGbn,sYeName,sGb,sManDate,sBillNo,sAbName

dw_junpoy.Reset()

//외상매출금,외상매입금,미지급금,선급금,영업외수익(잡이익),지급어음,제예금 계정/예적금코드 Get
Wf_AccSet()

iRowCount = dw_list.RowCount()

FOR i = 1 TO iRowCount
	
	sSaupNo  = dw_list.GetItemString(i,"saup_no")
	sSaupNm  = dw_list.GetItemString(i,"saup_nm")
	dSaGAmt  = dw_list.GetItemNumber(i,"sagub_amt")
	dGeyAmt  = dw_list.GetItemNumber(i,"gey_amt")
	dMiJiAmt = dw_list.GetItemNumber(i,"miji_amt")
	dGoAmt   = dw_list.GetItemNumber(i,"go_amt")
	dJanAmt  = dw_list.GetItemNumber(i,"jan_amt")
	dMiAmt   = dw_list.GetItemNumber(i,"mi_amt")
	dBillAmt = dw_list.GetItemNumber(i,"bill_amt")
	dCashAmt = dw_list.GetItemNumber(i,"cash_amt")

	sBillNo  = dw_list.GetItemString(i,"bill_no")
	sManDate = dw_list.GetItemString(i,"bman_date")
	
	IF IsNull(dSaGAmt)  THEN dSaGAmt  = 0
	IF IsNull(dGeyAmt)  THEN dGeyAmt  = 0
	IF IsNull(dMiJiAmt) THEN dMiJiAmt = 0
	IF IsNull(dGoAmt)   THEN dGoAmt   = 0
	IF IsNull(dJanAmt)  THEN dJanAmt  = 0
	IF IsNull(dMiAmt)   THEN dMiAmt   = 0
	IF IsNull(dBillAmt) THEN dBillAmt = 0
	IF IsNull(dCashAmt) THEN dCashAmt = 0
	
	IF dBillAmt = 0 AND dCashAmt = 0 THEN Continue	//어음,현금 모두 0인 경우 전표생성하지 않음(사급)
	
	lJunPoyNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
	iLinNo = 1
	
	sAccJunNo = sSaupj+sBalDate+sUpmuGbn+String(lJunPoyNo,"0000")
	
	//사급자재
	IF dSaGAmt > 0 THEN
		sDcGbn = "2"	/*대변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sWCAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sWCAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dSaGAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월분 사급자재비")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//차감계
	IF dGeyAmt > 0 THEN
		sDcGbn = "1"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sWIAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sWIAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dSaGAmt+dGeyAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월분 자재비")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//미지급금
	IF dMiJiAmt > 0 THEN
		sDcGbn = "1"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sMJAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sMJAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dMiJiAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월분 결제")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//고정자산
	IF dGoAmt > 0 THEN
		sDcGbn = "1"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sSGAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sSGAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dGoAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월 선급금 지급")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//잔금지급
	IF dJanAmt > 0 THEN
		sDcGbn = "1"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sMJAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sMJAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dJanAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월 잔금 결제")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//미결제
	IF dMiAmt <> 0 THEN
		sDcGbn = "2"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sJAAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sJAAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dMiAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월 공제")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//어음
	IF dBillAmt > 0 THEN
		sDcGbn = "2"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sJGAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sJGAcc,6,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dBillAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   "["+sSaupNo+"] "+sSaupNm+" "+Mid(sJunMm,5,2)+"월 외상대 결제")
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNm)
		
		IF Wf_Insert_Kfz12otc(i,sSaupj,sBaseDate,sUpmuGbn,lJunPoyNo,iLinNo,"2") = -1 THEN Return -1
		
		dw_junpoy.SetItem(iCurRow,"jbill_gu",'Y')
		dw_junpoy.SetItem(iCurRow,"kwan_no", sBillNo)
		dw_junpoy.SetItem(iCurRow,"k_eymd",  sManDate)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	//현금(제예금)
	IF dCashAmt > 0 THEN
		sDcGbn = "2"	/*차변*/
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunPoyNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		dw_junpoy.SetItem(iCurRow,"jun_gu",  "3")
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", gs_dept)
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Mid(sJYAcc,1,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sJYAcc,6,2))
		
		dw_junpoy.SetItem(iCurRow,"sawon",   gs_empno)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dCashAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   Mid(sJunMm,5,2)+"월분 결제")
		
		Select ab_name||'['||ab_no||']'
		  Into :sAbName
		  From kfm04ot0
       Where ab_dpno = :sYeCode;
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sYeCode)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sAbName)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		iLinNo = iLinNo + 1
	END IF
	
	iSeqNo = dw_list.GetItemNumber(i,"seqno")
		
	Update kfz19ota
		Set accjunno = :sAccJunNo
	 Where gyel_date = :sBaseDate
		And seqno = :iSeqNo;
	
NEXT

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	Return -1
END IF

IF dw_jbill.Update() <> 1 THEN
	F_MessageChk(13,'[지급어음]')
	Return -1
END IF

Return 1
end function

on w_kglc28.create
int iCurrent
call super::create
this.rb_ins=create rb_ins
this.rb_del=create rb_del
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_list=create dw_list
this.dw_cond=create dw_cond
this.cbx_1=create cbx_1
this.dw_jbill=create dw_jbill
this.dw_bill_detail=create dw_bill_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ins
this.Control[iCurrent+2]=this.rb_del
this.Control[iCurrent+3]=this.dw_junpoy
this.Control[iCurrent+4]=this.dw_sungin
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_cond
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.dw_jbill
this.Control[iCurrent+9]=this.dw_bill_detail
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
end on

on w_kglc28.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ins)
destroy(this.rb_del)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_list)
destroy(this.dw_cond)
destroy(this.cbx_1)
destroy(this.dw_jbill)
destroy(this.dw_bill_detail)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;F_Window_Center_Response(This)

sBaseDate = Message.StringParm

dw_cond.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_jbill.SetTransObject(SQLCA)
dw_bill_detail.SetTransObject(SQLCA)

rb_ins.Checked = True
rb_ins.TriggerEvent(Clicked!)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '15' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_cond.SetItem(1,"baldate",sBaseDate)
end event

type dw_insert from w_inherite`dw_insert within w_kglc28
boolean visible = false
integer x = 1934
integer y = 2724
integer height = 144
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc28
boolean visible = false
integer x = 3433
integer y = 2624
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc28
boolean visible = false
integer x = 3259
integer y = 2624
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc28
integer x = 3739
integer y = 20
integer taborder = 60
string pointer = "c:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_search::clicked;call super::clicked;Int    iSelRow
String sSaupj,sBalDate,sUpmuGbn = "T"

dw_cond.AcceptText()
dw_list.AcceptText()

sSaupj = gs_saupj
sBalDate = dw_cond.GetItemString(dw_cond.GetRow(),"baldate")

IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_cond.SetColumn("baldate")
	dw_cond.SetFocus()
	Return
END IF

iSelRow = dw_list.GetItemNumber(1,"yescnt")
IF iSelRow = 0 or IsNull(iSelRow) THEN
	MessageBox("확인","처리할 자료가 없습니다.")
	Return
END IF

SetPointer(HourGlass!)

IF sModStatus = 'I' THEN												/*전표발행시*/
	
	IF MessageBox("확인","전표를 발행하시겠습니까?",Question!,YesNo!) = 2 THEN Return

	IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
		F_MessageChk(29,'[발행일자]')
		SetPointer(Arrow!)
		Return -1
	END IF
	
	IF Wf_Create_Kfz12ot0(sSaupj,sBalDate,sUpmuGbn) = -1 THEN
		Rollback;
		Return
	END IF

	Commit;

	/*자동 승인 처리*/
	IF LsAutoSungGbn = 'Y' THEN
		w_mdi_frame.sle_msg.text = '승인 처리 중...'
		IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
			SetPointer(Arrow!)
			Return -1
		END IF	
	END IF
	
ELSE
	IF MessageBox("확인","전표를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN Return

	IF Wf_Delete_Kfz12ot0() = -1 then 
		Rollback;
		SetPointer(Arrow!)
		Return
	END IF
	
	Commit;

END IF

SetPointer(Arrow!)

Wf_Init()

p_inq.TriggerEvent(Clicked!)
end event

type p_ins from w_inherite`p_ins within w_kglc28
boolean visible = false
integer x = 3086
integer y = 2624
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc28
integer x = 4087
integer y = 20
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kglc28
integer x = 3913
integer y = 20
integer taborder = 40
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_kglc28
boolean visible = false
integer x = 2912
integer y = 2628
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc28
integer x = 3566
integer y = 20
end type

event p_inq::clicked;call super::clicked;String sBalDate

dw_cond.AcceptText()

sBalDate = dw_cond.GetItemString(1,"baldate")

IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_cond.SetColumn("baldate")
	dw_cond.SetFocus()
	Return
END IF

dw_list.SetRedraw(False)

IF dw_list.Retrieve(sBalDate) <=0 THEN
	F_MessageChk(14,"")
	dw_cond.SetColumn("baldate")
	dw_cond.SetFocus()
	dw_list.SetRedraw(True)
	Return
END IF

dw_list.SetRedraw(True)

cbx_1.Checked = False

w_mdi_frame.sle_msg.text = "조회되었습니다!"
end event

type p_del from w_inherite`p_del within w_kglc28
boolean visible = false
integer x = 3781
integer y = 2624
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc28
boolean visible = false
integer x = 3616
integer y = 2624
integer width = 169
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kglc28
integer x = 3703
integer y = 3276
end type

type cb_mod from w_inherite`cb_mod within w_kglc28
integer x = 2683
integer y = 3276
integer width = 640
string text = "전표발행(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_kglc28
integer x = 2382
integer y = 3012
string text = "추가&A)"
end type

type cb_del from w_inherite`cb_del within w_kglc28
integer x = 2720
integer y = 2896
end type

type cb_inq from w_inherite`cb_inq within w_kglc28
integer x = 2331
integer y = 3280
end type

type cb_print from w_inherite`cb_print within w_kglc28
integer x = 2496
integer y = 3248
end type

type st_1 from w_inherite`st_1 within w_kglc28
integer x = 142
integer y = 3240
end type

type cb_can from w_inherite`cb_can within w_kglc28
integer x = 3346
integer y = 3276
end type

type cb_search from w_inherite`cb_search within w_kglc28
integer x = 3072
integer y = 2896
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc28
integer x = 2912
integer y = 3236
end type

type sle_msg from w_inherite`sle_msg within w_kglc28
integer x = 494
integer y = 3240
integer width = 2418
end type

type gb_10 from w_inherite`gb_10 within w_kglc28
integer x = 123
integer y = 3188
integer width = 3547
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc28
integer x = 2807
integer y = 3028
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc28
integer x = 2615
integer y = 2660
integer width = 1417
end type

type rb_ins from radiobutton within w_kglc28
integer x = 910
integer y = 76
integer width = 347
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

event clicked;sModStatus = 'I'									

Wf_Init()

end event

type rb_del from radiobutton within w_kglc28
integer x = 1285
integer y = 72
integer width = 347
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

event clicked;sModStatus = 'M'									

Wf_Init()

end event

type dw_junpoy from datawindow within w_kglc28
boolean visible = false
integer x = 137
integer y = 2324
integer width = 1234
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kglc288"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_sungin from datawindow within w_kglc28
boolean visible = false
integer x = 137
integer y = 2432
integer width = 1234
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

type dw_list from u_d_select_sort within w_kglc28
integer x = 37
integer y = 224
integer width = 4206
integer height = 1856
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kglc282"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;//
//IF currentrow <=0 THEN Return
//
//dw_method.Retrieve(this.GetItemString(currentrow,"gyel_date"),this.GetItemNumber(currentrow,"seqno"))
//dw_method2.Retrieve(this.GetItemString(currentrow,"gyel_date"),this.GetItemNumber(currentrow,"seqno"))
//
//dw_cond.SetItem(1,"pcfee", dw_method.GetItemNumber(1,"sendfee"))

end event

event clicked;//
//If Row <= 0 then
//	b_flag =True
//ELSE
//	b_flag = False
//		
//	dw_method.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
////	dw_method2.Retrieve(this.GetItemString(row,"gyel_date"),this.GetItemNumber(row,"seqno"))
//	
//	dw_cond.SetItem(1,"pcfee", dw_method.GetItemNumber(1,"sendfee"))
//END IF
//
//CALL SUPER ::CLICKED
end event

event rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

type dw_cond from u_key_enter within w_kglc28
event ue_key pbm_dwnkey
integer x = 18
integer y = 36
integer width = 809
integer height = 160
integer taborder = 20
string dataobject = "d_kglc281"
boolean border = false
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sNull
Int    iCurRow

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "basedate" THEN
	sBaseDate = Trim(this.GetText())
	IF sBaseDate = "" OR IsNull(sBaseDate) THEN RETURN
	
	IF F_DateChk(sBaseDate) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(iCurRow,"basedate",sNull)
		Return 1
	END IF	
END IF
end event

type cbx_1 from checkbox within w_kglc28
integer x = 1705
integer y = 128
integer width = 352
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;
Integer iCount,i

iCount = dw_list.RowCount()
dw_list.SetRedraw(False)
w_mdi_frame.sle_msg.text = '처리 중...'
SetPointer(HourGlass!)

For i = 1 to iCount
	if cbx_1.Checked = True then
		dw_list.SetItem(i,"chkflag",'Y')
	else
		dw_list.SetItem(i,"chkflag",'N')
	end if
Next

dw_list.SetRedraw(True)
w_mdi_frame.sle_msg.text = '처리 완료!'
SetPointer(Arrow!)
end event

type dw_jbill from datawindow within w_kglc28
boolean visible = false
integer x = 1371
integer y = 2432
integer width = 1234
integer height = 100
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음 저장"
string dataobject = "d_kglc285"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_bill_detail from datawindow within w_kglc28
boolean visible = false
integer x = 1371
integer y = 2324
integer width = 1234
integer height = 108
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음 상세 조회"
string dataobject = "d_kglc286"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kglc28
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 864
integer y = 40
integer width = 791
integer height = 148
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kglc28
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 216
integer width = 4238
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

