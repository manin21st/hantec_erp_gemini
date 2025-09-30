$PBExportHeader$w_pip4011.srw
$PBExportComments$** 소급 계산내역 수정
forward
global type w_pip4011 from w_inherite_standard
end type
type rr_3 from roundrectangle within w_pip4011
end type
type dw_emp from u_key_enter within w_pip4011
end type
type gb_8 from groupbox within w_pip4011
end type
type dw_main from u_key_enter within w_pip4011
end type
type dw_1 from u_key_enter within w_pip4011
end type
type dw_2 from u_key_enter within w_pip4011
end type
type cb_append from commandbutton within w_pip4011
end type
type cb_erase from commandbutton within w_pip4011
end type
type cb_3 from commandbutton within w_pip4011
end type
type dw_cond from u_key_enter within w_pip4011
end type
type dw_5 from datawindow within w_pip4011
end type
type dw_4 from u_d_popup_sort within w_pip4011
end type
type cb_1 from commandbutton within w_pip4011
end type
type p_insert from uo_picture within w_pip4011
end type
type p_delete from uo_picture within w_pip4011
end type
type p_append from uo_picture within w_pip4011
end type
type p_erase from uo_picture within w_pip4011
end type
type st_2 from statictext within w_pip4011
end type
type st_3 from statictext within w_pip4011
end type
type rr_5 from roundrectangle within w_pip4011
end type
type rr_6 from roundrectangle within w_pip4011
end type
type rr_4 from roundrectangle within w_pip4011
end type
type rr_2 from roundrectangle within w_pip4011
end type
type rr_1 from roundrectangle within w_pip4011
end type
type rr_7 from roundrectangle within w_pip4011
end type
end forward

global type w_pip4011 from w_inherite_standard
integer width = 4667
integer height = 2400
string title = "소급 계산내역 수정"
rr_3 rr_3
dw_emp dw_emp
gb_8 gb_8
dw_main dw_main
dw_1 dw_1
dw_2 dw_2
cb_append cb_append
cb_erase cb_erase
cb_3 cb_3
dw_cond dw_cond
dw_5 dw_5
dw_4 dw_4
cb_1 cb_1
p_insert p_insert
p_delete p_delete
p_append p_append
p_erase p_erase
st_2 st_2
st_3 st_3
rr_5 rr_5
rr_6 rr_6
rr_4 rr_4
rr_2 rr_2
rr_1 rr_1
rr_7 rr_7
end type
global w_pip4011 w_pip4011

type variables
String iv_workym,iv_pbtag,iv_empno
long ettaxpay, yjtaxpay , gjtaxpay , no_stpay 
DataWindowChild dw_child
end variables

forward prototypes
public subroutine wf_calculation_tax (double dtotalpay, double dtaxtotpay, double detcsubamt)
public function integer wf_required_check (string sdataobj, integer ll_row)
public subroutine wf_calc_editdata ()
public subroutine wf_magancheck ()
end prototypes

public subroutine wf_calculation_tax (double dtotalpay, double dtaxtotpay, double detcsubamt);///*------------------------------------------------------------------*/
///*                 세  금  계  산   시  작                          */
///*------------------------------------------------------------------*/
//
//Double  dTotalAmount,dWorkInComeAmt,dTaxStandardAmt,dIncomeTax,dWorkIncomeTaxSub,dResidentTax
//String  sWifeTag,sWorkCoupleTag,sWomenHouse,sUseGbn
//Integer iDepend20,iDepend60,iRespect,iRubber,iChildCount,iFamilySudangInWon
//
//dTotalAmount = dTaxTotPay * 12				/* 근로소득금액 = 과세합계 * 12*/
//
///*예외 자료 읽기*/
//SELECT "P3_EXCEPTDATA"."USEREC"
//	INTO :sUseGbn
//    FROM "P3_EXCEPTDATA"  
//   WHERE ( "P3_EXCEPTDATA"."COMPANYCODE" = :Gs_company ) AND  
//         ( "P3_EXCEPTDATA"."EMPNO" = :iv_empno ) AND  
//         ( "P3_EXCEPTDATA"."PBTAG" = :iv_pbtag )   ;
//IF SQLCA.SQLCODE <> 0 THEN
//	sUseGbn = '0'								/*예외자료 없슴*/
//END IF
//
///*급여 기본 자료 읽기*/
//SELECT "P3_PERSONAL"."WIFETAG",   									/*배우자유무*/
//       "P3_PERSONAL"."DEPENDENT20",   								/*부양가족20*/
//       "P3_PERSONAL"."DEPENDENT60", 			  					/*부양가족60*/
//       "P3_PERSONAL"."RESPECT",   									/*경로우대*/
//       "P3_PERSONAL"."RUBBER",				   					/*장애자*/
//       "P3_PERSONAL"."WORKCOUPLETAG",   							/*맞벌이부부*/
//       "P3_PERSONAL"."WOMENHOUSE",   								/*부녀자*/
//       "P3_PERSONAL"."CHILDCOUNT",			   					/*자녀양육인원*/
//       "P3_PERSONAL"."FAMILYSUDANGINWON"  						/*가족수수당인원*/
//	INTO :sWifeTag,   
//        :iDepend20,   
//        :iDepend60,   
//        :iRespect,   
//        :iRubber,   
//        :sWorkCoupleTag,   
//        :sWomenHouse,   
//        :iChildCount,   
//        :iFamilysudangInwon
//   FROM "P3_PERSONAL"  
//   WHERE ( "P3_PERSONAL"."COMPANYCODE" = :gs_company ) AND  
//         ( "P3_PERSONAL"."EMPNO" = :iv_empno )   ;
//IF SQLCA.SQLCODE <> 0 THEN
//	iDepend20 =0;		iDepend60 =0;		iRespect =0;	iRubber =0;  iChildCount =0;  iFamilySudangInwon =0;	
//	
//ELSE
//	IF IsNull(iDepend20)   THEN iDepend20 =0
//	IF IsNull(iDepend60)   THEN iDepend60 =0
//	IF IsNull(iRespect)    THEN iRespect =0
//	IF IsNull(iRubber)     THEN iRubber =0
//	IF IsNull(iChildCount) THEN iChildCount =0
//	IF IsNull(iFamilySudangInwon) THEN iFamilySudangInwon =0
//END IF
//
///*근로소득공제,기본공제,추가공제,특별공제								*/
///*function argument : 급여/상여구분,1년 총금액, 					*/
///*                    급여마스타의 wifetag,depend20,depend60,rubber,respect,맞벌이,부녀자.자녀양육비,*/
///*                ref 근로소득공제, 과세표준 						*/
//
//F_Calculation_Sub_Soduck('P',dTotalAmount,		sWifeTag,			iDepend20,&
//								 iDepend60,     			iRubber,  			iRespect,&
//								 sWorkCoupleTag,			sWomenHouse,&
//								 iChildCount,   			dWorkIncomeAmt,	dTaxStandardAmt)
//
///*기본세율*/
//F_Calculation_Sub_StandardTax(dTaxStandardAmt,dIncomeTax,dWorkIncomeTaxSub)
//
///*소득세,주민세 계산*/
//IF dIncomeTax > 0 THEN
//	dIncomeTax   =  dIncomeTax / 12
//		
//	dResidentTax = truncate(dIncomeTax * 0.01,0) * 10		/*주민세*/
//	dResidentTax = Truncate((dResidentTax / 10),0) * 10	
//	
//	dIncomeTax   = Truncate((dIncomeTax / 10),0) * 10			/*소득세*/
//END IF
//
//IF sUseGbn ='3' THEN
//	dIncomeTax = 0 
//	dResidentTax =0
//END IF
//
//dw_main.SetItem(1,"workincomeamt",dWorkIncomeAmt)
//dw_main.SetItem(1,"taxstandardamt",dTaxStandardAmt)
//dw_main.SetItem(1,"workincometaxsub",dWorkIncomeTaxSub)
//dw_main.SetItem(1,"incometax",dIncomeTax)
//dw_main.SetItem(1,"residenttax",dResidentTax)
//
//
//
end subroutine

public function integer wf_required_check (string sdataobj, integer ll_row);String sempno,scode
Double damount, dpay,dsub

IF sdataobj ="d_pip4011_2" THEN								//급여자료
	dw_main.AcceptText()
	sempno = dw_main.GetItemString(1,"empno")
	dpay   = dw_main.GetItemNumber(1,"bstotpayamt")
	dsub   = dw_main.GetItemNumber(1,"totsubamt")
	
	IF sempno ="" OR IsNull(sempno) THEN
		MessageBox("확 인","사번을 입력하세요!!")
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		Return -1
	END IF
	IF dpay =0 AND dsub =0 THEN
		Messagebox("확 인","지급총액과 공제총액이 모두 '0'입니다!!")
		
		Return -1
	END IF
		
ELSEIF sdataobj ="d_pip4011_3" THEN							//급여자료 CHILD(지급수당)
	
	dw_1.AcceptText()
	scode   = dw_1.GetItemString(ll_row,"allowcode")
	damount = dw_1.GetItemNumber(ll_row,"p8_eeditdatachild_btamt") 
	
	IF scode ="" OR IsNull(scode) THEN
		MessageBox("확 인","수당을 입력하세요!!")
		dw_1.SetColumn("allowcode")
		dw_1.SetFocus()
		Return -1
	END IF
	
	IF damount = 0 OR IsNull(damount) THEN
		MessageBox("확 인","금액을 입력하세요!!")
		dw_1.SetColumn("p8_eeditdatachild_btamt")
		dw_1.SetFocus()
		Return -1
	END IF
ELSEIF sdataobj ="d_pip4011_4" THEN							//급여자료 CHILD(공제수당)

	dw_2.AcceptText()
	scode   = dw_2.GetItemString(ll_row,"allowcode")
	damount = dw_2.GetItemNumber(ll_row,"p8_eeditdatachild_btamt") 
	
	IF scode ="" OR IsNull(scode) THEN
		MessageBox("확 인","수당을 입력하세요!!")
		dw_2.SetColumn("allowcode")
		dw_2.SetFocus()
		Return -1
	END IF
	
	IF damount = 0 OR IsNull(damount) THEN
		MessageBox("확 인","금액을 입력하세요!!")
		dw_2.SetColumn("p8_eeditdatachild_btamt")
		dw_2.SetFocus()
		Return -1
	END IF

END IF
Return 1
end function

public subroutine wf_calc_editdata ();//
//Double  dNoTaxSub,dNoTaxPay,dNoTaxPay_Yj,dNoTaxPay_Gita,dAllowAmt
//Integer i
//String  sTaxGbn,sNoTaxGbn,sAllowCode,&
//		  SysCnfg_sNoTax1,SysCnfg_sNoTax2,SysCnfg_sNoTax3,SysCnfg_sStandardPay  
//

IF dw_1.RowCount() <=0 THEN
	dw_main.SetItem(1,"bstotpayamt",0)	/*총수당지급액*/
ELSE
	dw_main.SetItem(1,"bstotpayamt",dw_1.GetItemNumber(1,"ctotal"))	/*총수당지급액*/
	
END IF

IF dw_2.RowCount() <=0 THEN
	dw_main.SetItem(1,"totsubamt",0)	/*총수당공제액*/
ELSE
	dw_main.SetItem(1,"totsubamt",dw_2.GetItemNumber(1,"ctotal"))		/*총수당공제액*/
END IF

//Double  dTotPayAmt,dEmployeeInsurance,dTotSubAmt,dTaxTotPay,dEtcSubAmt


//Wf_Calculation_Tax(dTotPayAmt,dTaxTotPay,dEtcSubAmt)

dw_main.SetItem(1,"bstotpayamt",dw_1.GetItemNumber(1,"ctotal"))
dw_main.SetItem(1,"totsubamt",dw_2.GetItemNumber(1,"ctotal"))
dw_main.SetItem(1,"netpayamt", (dw_1.GetItemNumber(1,"ctotal") - dw_2.GetItemNumber(1,"ctotal")))


				


end subroutine

public subroutine wf_magancheck ();String sPayMagamGbn

SELECT "P8_PAYFLAG"."CLYN"  		INTO :sPayMagamGbn  
	FROM "P8_PAYFLAG"  
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :Gs_Company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :Iv_WorkYm) AND ( "P8_PAYFLAG"."CLGUBN" = 'C' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sPayMagamGbn = 'N'
ELSE
	IF IsNull(sPayMaGamGbn) THEN sPayMagamGbn = 'N'
END IF

IF sPayMagamGbn = 'Y' THEN
	sle_msg.text = "이미 마감 처리되었습니다. 마감 취소 후 작업하세요!!"
	
	cb_insert.Enabled = False
	cb_delete.Enabled = False
	cb_append.Enabled = False
	cb_erase.Enabled  = False
	
	cb_update.Enabled = False
	cb_3.Enabled      = False
ELSE
	cb_insert.Enabled = True
	cb_delete.Enabled = True
	cb_append.Enabled = True
	cb_erase.Enabled  = True
	
	cb_update.Enabled = True
	cb_3.Enabled      = True
END IF

end subroutine

on w_pip4011.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_emp=create dw_emp
this.gb_8=create gb_8
this.dw_main=create dw_main
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_append=create cb_append
this.cb_erase=create cb_erase
this.cb_3=create cb_3
this.dw_cond=create dw_cond
this.dw_5=create dw_5
this.dw_4=create dw_4
this.cb_1=create cb_1
this.p_insert=create p_insert
this.p_delete=create p_delete
this.p_append=create p_append
this.p_erase=create p_erase
this.st_2=create st_2
this.st_3=create st_3
this.rr_5=create rr_5
this.rr_6=create rr_6
this.rr_4=create rr_4
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_7=create rr_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_emp
this.Control[iCurrent+3]=this.gb_8
this.Control[iCurrent+4]=this.dw_main
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.cb_append
this.Control[iCurrent+8]=this.cb_erase
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.dw_cond
this.Control[iCurrent+11]=this.dw_5
this.Control[iCurrent+12]=this.dw_4
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.p_insert
this.Control[iCurrent+15]=this.p_delete
this.Control[iCurrent+16]=this.p_append
this.Control[iCurrent+17]=this.p_erase
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.rr_5
this.Control[iCurrent+21]=this.rr_6
this.Control[iCurrent+22]=this.rr_4
this.Control[iCurrent+23]=this.rr_2
this.Control[iCurrent+24]=this.rr_1
this.Control[iCurrent+25]=this.rr_7
end on

on w_pip4011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_emp)
destroy(this.gb_8)
destroy(this.dw_main)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_append)
destroy(this.cb_erase)
destroy(this.cb_3)
destroy(this.dw_cond)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.cb_1)
destroy(this.p_insert)
destroy(this.p_delete)
destroy(this.p_append)
destroy(this.p_erase)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_5)
destroy(this.rr_6)
destroy(this.rr_4)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_7)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_emp.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_5.insertrow(0)

dw_5.setitem(1,'sdate', left(f_today(),6)+'01')
dw_4.retrieve(gs_company, '%','%',left(f_today(),6)+'01',gs_saupcd, '%')

f_set_saupcd(dw_5, 'saup', '1')
is_saupcd = gs_saupcd

dw_cond.Reset()

iv_workym = Left(gs_today,6)
iv_pbtag  = 'P'

dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

 
IF dw_cond.GetChild("pbtag",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('PB') <=0 THEN RETURN 
END IF

dw_cond.setitem(1,"pbtag",'P')
iv_pbtag  = 'P'

dw_cond.Insertrow(0)

dw_emp.Reset()
dw_emp.Insertrow(0)

dw_main.Reset()
dw_main.InsertRow(0)

dw_1.Reset()
dw_2.Reset()

dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)


dw_cond.SetItem(1,"workym",Left(gs_today,6))
dw_5.SetFocus()

end event

type p_mod from w_inherite_standard`p_mod within w_pip4011
integer x = 3909
end type

event p_mod::clicked;call super::clicked;Int k


IF dw_main.Accepttext() = -1 THEN 	RETURN
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
END IF

IF dw_1.RowCount() > 0 THEN
	IF wf_required_check(dw_1.DataObject,dw_1.GetRow()) = -1 THEN RETURN
END IF

IF dw_2.RowCount() > 0 THEN
	IF wf_required_check(dw_2.DataObject,dw_2.GetRow()) = -1 THEN RETURN
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_main.Accepttext()

Wf_Calc_EditData()


IF dw_main.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 계산자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_1.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 지급수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_2.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 공제수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

COMMIT;
p_inq.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.Setfocus()
		

end event

type p_del from w_inherite_standard`p_del within w_pip4011
integer x = 4082
end type

event p_del::clicked;call super::clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 급여자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_main.SetRedraw(False)

dw_main.DeleteRow(il_currow)

IF dw_main.Update() <> 1 THEN
	MessageBox("확 인","급여자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF

dw_1.SetRedraw(False)
il_rowcount = dw_1.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_1.DeleteRow(k)
	NEXT
	IF dw_1.Update() <> 1 THEN
		MessageBox("확 인","급여자료(지급수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_1.SetRedraw(True)
		Return
	END IF
END IF

dw_2.SetRedraw(False)
il_rowcount = dw_2.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_2.DeleteRow(k)
	NEXT
	IF dw_2.Update() <> 1 THEN
		MessageBox("확 인","급여자료(공제수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_2.SetRedraw(True)
		Return
	END IF
END IF
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

commit;
cb_cancel.TriggerEvent(Clicked!)
ib_any_typing =False
sle_msg.text ="자료를 삭제하였습니다!!"
	





end event

type p_inq from w_inherite_standard`p_inq within w_pip4011
integer x = 3735
end type

event p_inq::clicked;call super::clicked;String sname,sgubun

dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")

iv_empno = dw_emp.GetItemString(1,"empno") 

IF iv_workym = "" OR IsNull(iv_workym) THEN
	MessageBox("확 인","작업년월을 입력하세요!!")
	dw_cond.SetColumn("workym")
	dw_cond.SetFocus()
	Return
END IF
IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_cond.SetColumn("pbtag")
	dw_cond.SetFocus()
	Return
END IF
IF dw_4.GetSelectedRow(0) > 0 THEN
	iv_empno = dw_4.GetItemString(dw_4.GetSelectedRow(0),"empno")
END IF
IF dw_emp.Retrieve(gs_company,iv_empno,'%') <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")
	p_can.TriggerEvent(Clicked!)
	Return 
END IF


sgubun = '1'


dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

IF dw_main.Retrieve(gs_company,iv_workym,iv_pbtag,iv_empno,sgubun) <=0 THEN	
	dw_1.reset()
	dw_2.reset()
ELSE
	dw_1.Retrieve(gs_company,iv_empno,iv_pbtag,'1',iv_workym, sgubun)
	dw_2.Retrieve(gs_company,iv_empno,iv_pbtag,'2',iv_workym, sgubun)
	
	cb_insert.Enabled =True
	cb_delete.Enabled =True
	cb_append.Enabled =True
	cb_erase.Enabled =True
		
	sle_msg.text =""
END IF

dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

wf_magancheck()
end event

type p_print from w_inherite_standard`p_print within w_pip4011
boolean visible = false
integer x = 4937
integer y = 388
end type

type p_can from w_inherite_standard`p_can within w_pip4011
integer x = 4256
end type

event p_can::clicked;call super::clicked;dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.Insertrow(0)

dw_1.Reset()
dw_2.Reset()

cb_insert.Enabled =False
cb_delete.Enabled =False
cb_append.Enabled =False
cb_erase.Enabled =False

dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

type p_exit from w_inherite_standard`p_exit within w_pip4011
integer x = 4430
end type

type p_ins from w_inherite_standard`p_ins within w_pip4011
boolean visible = false
integer x = 4672
integer y = 228
end type

type p_search from w_inherite_standard`p_search within w_pip4011
boolean visible = false
integer x = 4087
integer y = 176
end type

event p_search::clicked;call super::clicked;string sdate, sdept, sgrade, ssaup, sjik

if dw_5.Accepttext() = -1 then return

sdate = dw_5.getitemstring(1,'sdate')
sdept = dw_5.getitemstring(1,'deptcode')
sgrade = dw_5.getitemstring(1,'grade')
ssaup = dw_5.getitemstring(1,'saup')
sjik = dw_5.getitemstring(1,'sjik')

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'
if IsNull(ssaup) or ssaup = '' then ssaup = '%'
if IsNull(sjik) or sjik = '' then sjik = '%'

if dw_4.retrieve(gs_company, sdept, sgrade,sdate,ssaup,sjik) < 1 then
	messagebox("조회","조회자료가 없습니다!")
	return
	dw_5.setcolumn('sdate')
	dw_5.setfocus()
end if
end event

type p_addrow from w_inherite_standard`p_addrow within w_pip4011
boolean visible = false
integer x = 4846
integer y = 228
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip4011
boolean visible = false
integer x = 5019
integer y = 228
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip4011
boolean visible = false
integer y = 2392
end type

type st_window from w_inherite_standard`st_window within w_pip4011
integer taborder = 90
long backcolor = 67108864
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip4011
boolean visible = false
integer x = 2345
integer y = 2520
integer taborder = 180
end type

type cb_update from w_inherite_standard`cb_update within w_pip4011
boolean visible = false
integer x = 1262
integer y = 2520
integer taborder = 100
end type

event cb_update::clicked;call super::clicked;Int k


IF dw_main.Accepttext() = -1 THEN 	RETURN
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
END IF

IF dw_1.RowCount() > 0 THEN
	IF wf_required_check(dw_1.DataObject,dw_1.GetRow()) = -1 THEN RETURN
END IF

IF dw_2.RowCount() > 0 THEN
	IF wf_required_check(dw_2.DataObject,dw_2.GetRow()) = -1 THEN RETURN
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_main.Accepttext()

Wf_Calc_EditData()


IF dw_main.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 계산자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_1.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 지급수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_2.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 공제수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

COMMIT;
cb_retrieve.TriggerEvent(Clicked!)
sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.Setfocus()
		

end event

type cb_insert from w_inherite_standard`cb_insert within w_pip4011
boolean visible = false
integer x = 50
integer y = 2520
integer width = 361
integer taborder = 130
boolean enabled = false
string text = "추가(&I)"
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_1.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_1.DataObject,dw_1.GetRow())
	
	il_currow = dw_1.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_1.InsertRow(il_currow)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_companycode",gs_company)	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_workym",iv_workym)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_empno",iv_empno)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_pbtag",iv_pbtag)	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_gubun",'1')	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_calc_gubun",'1')	

	dw_1.ScrollToRow(il_currow)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
	
END IF

end event

type cb_delete from w_inherite_standard`cb_delete within w_pip4011
boolean visible = false
integer x = 439
integer y = 2520
integer taborder = 140
boolean enabled = false
end type

event cb_delete::clicked;call super::clicked;Int il_currow

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_1.DeleteRow(il_currow)

IF dw_1.RowCount() <=0 THEN
	dw_main.SetItem(1,"bsetcallowamt",0)
//	dw_main.SetItem(1,"etctaxfree", 0)	
ELSE
	dw_main.SetItem(1,"bsetcallowamt",dw_1.GetItemNumber(1,"ctotal"))
END IF

IF il_currow = 1 THEN
ELSE
	dw_1.ScrollToRow(il_currow - 1)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
END IF
sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =True

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip4011
boolean visible = false
integer x = 914
integer y = 2520
integer taborder = 70
end type

event cb_retrieve::clicked;call super::clicked;String sname,sgubun

dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")

iv_empno = dw_emp.GetItemString(1,"empno") 

IF iv_workym = "" OR IsNull(iv_workym) THEN
	MessageBox("확 인","작업년월을 입력하세요!!")
	dw_cond.SetColumn("workym")
	dw_cond.SetFocus()
	Return
END IF
IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_cond.SetColumn("pbtag")
	dw_cond.SetFocus()
	Return
END IF
IF dw_4.GetSelectedRow(0) > 0 THEN
	iv_empno = dw_4.GetItemString(dw_4.GetSelectedRow(0),"empno")
END IF
IF dw_emp.Retrieve(gs_company,iv_empno,'%') <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")
	cb_cancel.TriggerEvent(Clicked!)
	Return 
END IF


sgubun = '1'


dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

IF dw_main.Retrieve(gs_company,iv_workym,iv_pbtag,iv_empno,sgubun) <=0 THEN	
	dw_1.reset()
	dw_2.reset()
ELSE
	dw_1.Retrieve(gs_company,iv_empno,iv_pbtag,'1',iv_workym, sgubun)
	dw_2.Retrieve(gs_company,iv_empno,iv_pbtag,'2',iv_workym, sgubun)
	
	cb_insert.Enabled =True
	cb_delete.Enabled =True
	cb_append.Enabled =True
	cb_erase.Enabled =True
		
	sle_msg.text =""
END IF

dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

wf_magancheck()
end event

type st_1 from w_inherite_standard`st_1 within w_pip4011
long backcolor = 67108864
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip4011
boolean visible = false
integer x = 1993
integer y = 2520
integer taborder = 120
end type

event cb_cancel::clicked;call super::clicked;dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.Insertrow(0)

dw_1.Reset()
dw_2.Reset()

cb_insert.Enabled =False
cb_delete.Enabled =False
cb_append.Enabled =False
cb_erase.Enabled =False

dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pip4011
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip4011
long backcolor = 67108864
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip4011
integer x = 882
integer width = 1838
integer height = 176
long backcolor = 32106727
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip4011
integer x = 2784
integer width = 805
integer height = 176
long backcolor = 32106727
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip4011
boolean visible = false
integer y = 2648
long backcolor = 32106727
end type

type rr_3 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 384
integer y = 468
integer width = 3826
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_emp from u_key_enter within w_pip4011
event ue_key ( )
integer x = 1659
integer y = 188
integer width = 1998
integer height = 240
integer taborder = 20
string dataobject = "d_pip4011_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sEmpName,snull,sgubun
Int il_RowCount

SetNull(snull)

IF ib_any_typing =True THEN
	MessageBox("확 인","저장하지 않은 자료가 있습니다.!!")
	sle_msg.text = "자료를 저장하지 않으려면 취소를 누르십시요!!"
	Return 1
END IF

dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")

dw_main.SetRedraw(False)
dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

If dw_emp.GetColumnName() = "empno" Then

	iv_empno = this.GetText()
	
	IF iv_empno ="" OR IsNull(iv_empno) THEN RETURN
	
	IF IsNull(wf_exiting_data("empno",iv_empno,"1")) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		
		Return 1
	END IF
	
	dw_emp.SetRedraw(False)
	IF dw_emp.Retrieve(gs_company,iv_empno,'%') <=0 THEN
		Messagebox("확 인","계산처리 않된 사원이므로 수정할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	END IF
	dw_emp.SetRedraw(True)
	

sgubun = '1'
	
	IF dw_main.Retrieve(gs_company,iv_workym,iv_pbtag,iv_empno,sgubun) <=0 THEN
	ELSE
		dw_1.Retrieve(gs_company, iv_empno, iv_pbtag, '1', iv_workym, sgubun)
		dw_2.Retrieve(gs_company, iv_empno, iv_pbtag, '2', iv_workym, sgubun)
		
		cb_insert.Enabled =True
		cb_delete.Enabled =True
		cb_append.Enabled =True
		cb_erase.Enabled =True
	END IF
END IF

If dw_emp.GetColumnName() = "empname" Then
	sempname = this.GetText()
	
	IF sempname ="" OR IsNull(sempname) THEN RETURN
	
	iv_empno = wf_exiting_data("empname",sempname,"1")
	IF IsNull(iv_empno) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empname")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		
		Return 1
	END IF
	dw_emp.Retrieve(gs_company,iv_empno,'%')
				
	IF dw_main.Retrieve(gs_company,iv_workym,iv_pbtag,iv_empno,sgubun) <=0 THEN
		Messagebox("확 인","계산처리 않된 사원이므로 수정할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empname")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	ELSE
		dw_1.Retrieve(gs_company, iv_empno, iv_pbtag, '1', iv_workym, sgubun)
		dw_2.Retrieve(gs_company, iv_empno, iv_pbtag, '2', iv_workym, sgubun)		
		cb_insert.Enabled = True
		cb_delete.Enabled = True
		cb_append.Enabled = True
		cb_erase.Enabled = True

	END IF
end if


dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;call super::rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF dwo.name = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

IF dwo.name = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;return 1
end event

type gb_8 from groupbox within w_pip4011
boolean visible = false
integer x = 9
integer y = 2472
integer width = 805
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type dw_main from u_key_enter within w_pip4011
event ue_key ( )
integer x = 1701
integer y = 2092
integer width = 2395
integer height = 84
integer taborder = 30
string dataobject = "d_pip4011_2"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemchanged;call super::itemchanged;
Int il_currow,lnull
String snull,slevel
Double damount

SetNull(snull)
SetNull(lnull)

il_currow = this.GetRow()

IF this.GetColumnName() = "aa" THEN
	slevel = this.GetText()
	
	IF slevel ="" OR IsNull(slevel) THEN RETURN
	
	SELECT "P3_MEDINSURANCETABLE"."MEDSELFFINE"  
	   INTO :dAmount  
	   FROM "P3_MEDINSURANCETABLE"  
   	WHERE ( "P3_MEDINSURANCETABLE"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P3_MEDINSURANCETABLE"."MEDDEGREE" = :slevel )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 의료보험 등급이 아닙니다!!")
		this.SetItem(il_currow,"meddegree",snull)
		this.SetItem(il_currow,"a2",lnull)
		Return 1
	END IF
	this.SetItem(il_currow,"a2",0)
		
END IF

IF this.GetColumnName() = "bb" THEN
	slevel = this.GetText()
	
	IF slevel ="" OR IsNull(slevel) THEN RETURN
	
	SELECT "P3_PENSIONTABLE"."PENSELFFINE"  
	   INTO :dAmount  
	   FROM "P3_PENSIONTABLE"  
   	WHERE "P3_PENSIONTABLE"."PENDEGREE" = :slevel   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 국민연금 등급이 아닙니다!!")
		this.SetItem(il_currow,"pendegree",snull)
		this.SetItem(il_currow,"a5",lnull)
		Return 1
	END IF
	this.SetItem(il_currow,"a5",0)		
END IF

end event

event rbuttondown;call super::rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF dwo.name = "aa" THEN
	
	open(w_medde_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"aa",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

IF dwo.name = "bb" THEN
	
	open(w_pende_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"bb",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

type dw_1 from u_key_enter within w_pip4011
integer x = 1719
integer y = 676
integer width = 1001
integer height = 1296
integer taborder = 40
string dataobject = "d_pip4011_3"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;call super::editchanged;this.AcceptText()

IF dw_1.RowCount() > 0 THEN
	dw_main.SetItem(1,"bstotpayamt",dw_1.GetItemNumber(1,"ctotal"))	/*총수당지급액*/
//	dw_main.SetItem(1,"mstpay",&
//				dw_main.GetItemNumber(1,"sum_basepay") + dw_1.GetItemNumber(1,"no_stpay"))		/*월정급여액*/
END IF
end event

event retrievestart;call super::retrievestart;

Int il_rtn

il_rtn = dw_1.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('1') <=0 THEN 
		Messagebox("확 인","등록된 수당이 없습니다!!")
		Return 1
	END IF
END IF
end event

event itemchanged;String sname,snull,sTaxGbn,sNoTaxGbn,sStandPayGbn
Int il_currow,lReturnRow

SetNull(snull)

IF dwo.name ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
		lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
			this.SetItem(row,"allowcode",snull)
			this.SetItem(row,"p3_allowance_backpaytag",snull)
			this.SetItem(row,"p3_allowance_daycalctag",snull)
			this.SetItem(row,"p3_allowance_taxpaytag", snull)
			RETURN  1	
		END IF

     SELECT "P3_ALLOWANCE"."ALLOWNAME",  "P3_ALLOWANCE"."BACKPAYTAG",
	  			"P3_ALLOWANCE"."DAYCALCTAG", "P3_ALLOWANCE"."TAXPAYTAG"
   	 INTO :sname,							  :sTaxGbn,
		 		:sNoTaxGbn,						  :sStandPayGbn
	    FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = '1' AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		this.SetItem(row,"p3_allowance_backpaytag",snull)
		this.SetItem(row,"p3_allowance_daycalctag",snull)
		this.SetItem(row,"p3_allowance_taxpaytag", snull)
		Return 1
	ELSE
		this.SetItem(row,"p3_allowance_backpaytag",sTaxGbn)
		this.SetItem(row,"p3_allowance_daycalctag",sNoTaxGbn)
		this.SetItem(row,"p3_allowance_taxpaytag", sStandPayGbn)
		
	END IF
END IF

end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

type dw_2 from u_key_enter within w_pip4011
integer x = 2999
integer y = 680
integer width = 1051
integer height = 1288
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip4011_4"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_any_typing =True

this.AcceptText()

IF dw_2.RowCount() > 0 THEN
	dw_main.SetItem(1,"totsubamt",dw_2.GetItemNumber(1,"ctotal"))
END IF
end event

event retrievestart;call super::retrievestart;

Int il_rtn

il_rtn = dw_2.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('2') <=0 THEN 
		Messagebox("확 인","등록된 수당이 없습니다!!")
		Return 1
	END IF
END IF
end event

event itemchanged;String sname,snull,sTaxGbn
Int il_currow,lReturnRow


SetNull(snull)

IF dwo.name ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
		lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
			this.SetItem(row,"allowcode",snull)
			this.SetItem(row,"p3_allowance_daycalctag",snull)
			RETURN  1	
		END IF

     SELECT "P3_ALLOWANCE"."ALLOWNAME",  "P3_ALLOWANCE"."DAYCALCTAG"
   	 INTO :sname,							  :sTaxGbn
	    FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = '2' AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		this.SetItem(row,"p3_allowance_daycalctag",snull)
		Return 1
	ELSE
		this.SetItem(row,"p3_allowance_daycalctag",sTaxGbn)
		
	END IF
END IF
end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

type cb_append from commandbutton within w_pip4011
boolean visible = false
integer x = 2839
integer y = 2520
integer width = 334
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "추가(&A)"
end type

event clicked;Int il_currow,il_functionvalue

IF dw_2.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_2.DataObject,dw_2.GetRow())
	
	il_currow = dw_2.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_2.InsertRow(il_currow)
	dw_2.SetItem(il_currow,"p8_eeditdatachild_companycode",gs_company)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_workym",iv_workym)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_empno",iv_empno)
	dw_2.SetItem(il_currow,"p8_eeditdatachild_pbtag",iv_pbtag)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_gubun",'2')	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_calc_gubun",'1')	

	dw_2.ScrollToRow(il_currow)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
	
END IF

end event

type cb_erase from commandbutton within w_pip4011
boolean visible = false
integer x = 3205
integer y = 2520
integer width = 334
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&E)"
end type

event clicked;Int il_currow

il_currow = dw_2.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_2.DeleteRow(il_currow)
//IF dw_2.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcsubamt",0)
//ELSE
//	dw_main.SetItem(1,"etcsubamt",dw_2.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_2.ScrollToRow(il_currow - 1)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
END IF
sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =True

end event

type cb_3 from commandbutton within w_pip4011
boolean visible = false
integer x = 1614
integer y = 2520
integer width = 361
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&Z)"
end type

event clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 급여자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_main.SetRedraw(False)

dw_main.DeleteRow(il_currow)

IF dw_main.Update() <> 1 THEN
	MessageBox("확 인","급여자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF

dw_1.SetRedraw(False)
il_rowcount = dw_1.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_1.DeleteRow(k)
	NEXT
	IF dw_1.Update() <> 1 THEN
		MessageBox("확 인","급여자료(지급수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_1.SetRedraw(True)
		Return
	END IF
END IF

dw_2.SetRedraw(False)
il_rowcount = dw_2.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_2.DeleteRow(k)
	NEXT
	IF dw_2.Update() <> 1 THEN
		MessageBox("확 인","급여자료(공제수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_2.SetRedraw(True)
		Return
	END IF
END IF
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

commit;
cb_cancel.TriggerEvent(Clicked!)
ib_any_typing =False
sle_msg.text ="자료를 삭제하였습니다!!"
	





end event

type dw_cond from u_key_enter within w_pip4011
integer x = 1659
integer y = 108
integer width = 1998
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip4011_5"
boolean border = false
end type

event itemerror;
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String snull, scodename

SetNull(snull)

IF this.GetColumnName() = 'workym' THEN
	iv_workym = this.GetText()
	IF iv_workym = "" OR IsNull(iv_workym) THEN RETURN
	
	IF f_datechk(iv_workym+'01') = -1 THEN
		MessageBox("확 인","작업년월을 확인하세요!!")
		this.SetItem(1,"workym",snull)
		Return 1
	END IF
END IF

IF this.GetcolumnName() = 'pbtag' THEN
	iv_pbtag = this.GetText()
	IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN RETURN
	
	scodename = f_check_ref('PB', iv_pbtag)
	IF isnull(scodename) THEN
		this.SetItem(1,"pbtag",snull)
		MessageBox("확 인","구분을 확인하십시오!!")
		Return 1
	END IF
END IF
end event

type dw_5 from datawindow within w_pip4011
integer x = 361
integer width = 1221
integer height = 448
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip2111_7"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event itemchanged;string sdate, sdept, sgrade, snull, sdeptnm
setnull(snull)

if this.GetColumnName() = 'sdate' then
	sdate = this.gettext()
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'deptcode' then
	    sdept = this.Gettext()
	select deptname into :sdeptnm
	from p0_dept
	where deptcode = :sdept;
	
	 IF f_chk_saupemp(sdept, '2', is_saupcd) = False THEN
		  this.SetItem(1,'deptcode',snull)
		  this.SetColumn('deptcode')
		  this.SetFocus()
		  Return 1
	  END IF
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'deptname', sdeptnm)
	else
		messagebox("확인","없는 코드입니다")
		this.setitem(1,'deptcode',snull)
		this.setitem(1,'deptname',snull)
		return 1
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'grade' then
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'sjik' then
	p_search.Triggerevent(Clicked!)	
elseif this.GetColumnName() = 'saup' then
	is_saupcd = this.Gettext()
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
	p_search.Triggerevent(Clicked!)
	
end if
end event

type dw_4 from u_d_popup_sort within w_pip4011
integer x = 485
integer y = 508
integer width = 1097
integer height = 1640
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pip2111_6"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_4.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type cb_1 from commandbutton within w_pip4011
boolean visible = false
integer x = 946
integer y = 3144
integer width = 402
integer height = 112
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "retrieve"
end type

event clicked;string sdate, sdept, sgrade

if dw_5.Accepttext() = -1 then return

sdate = dw_5.getitemstring(1,'sdate')
sdept = dw_5.getitemstring(1,'sdept')
sgrade = dw_5.getitemstring(1,'grade')

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'

if dw_4.retrieve(gs_company, sdept, sgrade,sdate) < 1 then
	messagebox("조회","조회자료가 없습니다!")
	return
	dw_5.setcolumn('sdate')
	dw_5.setfocus()
end if
end event

type p_insert from uo_picture within w_pip4011
integer x = 2487
integer y = 496
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
boolean enabled = false
string picturename = "C:\erpman\Image\추가_d.gif"
end type

event clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_1.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_1.DataObject,dw_1.GetRow())
	
	il_currow = dw_1.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_1.InsertRow(il_currow)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_companycode",gs_company)	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_workym",iv_workym)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_empno",iv_empno)
	dw_1.SetItem(il_currow,"p8_eeditdatachild_pbtag",iv_pbtag)	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_gubun",'1')	
	dw_1.SetItem(il_currow,"p8_eeditdatachild_calc_gubun",'1')	

	dw_1.ScrollToRow(il_currow)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
	
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_delete from uo_picture within w_pip4011
integer x = 2661
integer y = 496
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;Int il_currow

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_1.DeleteRow(il_currow)

IF dw_1.RowCount() <=0 THEN
	dw_main.SetItem(1,"bsetcallowamt",0)
//	dw_main.SetItem(1,"etctaxfree", 0)	
ELSE
	dw_main.SetItem(1,"bsetcallowamt",dw_1.GetItemNumber(1,"ctotal"))
END IF

IF il_currow = 1 THEN
ELSE
	dw_1.ScrollToRow(il_currow - 1)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
END IF
sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =True

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_append from uo_picture within w_pip4011
integer x = 3657
integer y = 496
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_2.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_2.DataObject,dw_2.GetRow())
	
	il_currow = dw_2.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_2.InsertRow(il_currow)
	dw_2.SetItem(il_currow,"p8_eeditdatachild_companycode",gs_company)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_workym",iv_workym)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_empno",iv_empno)
	dw_2.SetItem(il_currow,"p8_eeditdatachild_pbtag",iv_pbtag)	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_gubun",'2')	
	dw_2.SetItem(il_currow,"p8_eeditdatachild_calc_gubun",'1')	

	dw_2.ScrollToRow(il_currow)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
	
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_erase from uo_picture within w_pip4011
integer x = 3831
integer y = 496
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;Int il_currow

il_currow = dw_2.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_2.DeleteRow(il_currow)
//IF dw_2.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcsubamt",0)
//ELSE
//	dw_main.SetItem(1,"etcsubamt",dw_2.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_2.ScrollToRow(il_currow - 1)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
END IF
sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =True

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type st_2 from statictext within w_pip4011
integer x = 1797
integer y = 624
integer width = 274
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = " 지급수당"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pip4011
integer x = 3072
integer y = 624
integer width = 274
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = " 공제수당"
boolean focusrectangle = false
end type

type rr_5 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2469
integer y = 488
integer width = 384
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3643
integer y = 488
integer width = 379
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 475
integer y = 504
integer width = 1125
integer height = 1660
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1641
integer y = 88
integer width = 2062
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1714
integer y = 656
integer width = 1111
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip4011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2971
integer y = 656
integer width = 1102
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

