$PBExportHeader$w_kglc01.srw
$PBExportComments$전표 승인 처리
forward
global type w_kglc01 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc01
end type
type dw_rtv from datawindow within w_kglc01
end type
type dw_2 from u_d_select_sort within w_kglc01
end type
type dw_1 from datawindow within w_kglc01
end type
type rr_1 from roundrectangle within w_kglc01
end type
type rr_2 from roundrectangle within w_kglc01
end type
end forward

global type w_kglc01 from w_inherite
string title = "전표 승인 처리"
dw_cond dw_cond
dw_rtv dw_rtv
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc01 w_kglc01

type variables
String sJunpoyGbn = 'A'
end variables

forward prototypes
public function integer wf_check_standarddate (string saccdate)
public function integer wf_junpoyno (string ssaupj, string supmugbn, string syearmonthday)
public function integer wf_check_junno (string ssaupj, string saccym, string supmugbn, long ljunno)
end prototypes

public function integer wf_check_standarddate (string saccdate);Int    iRtnVal
String sFrom, sTo

SELECT "KFZ06OM0"."ACCYMD1",   "KFZ06OM0"."ACCYMD2"  
	INTO :sFrom,   				:sTo  
   FROM "KFZ06OM0"  ;

IF SQLCA.SQLCODE <> 0 THEN
	sFrom = '00000000'
	sTo   = '00000000'
ELSE
	IF sFrom = "" OR IsNull(sFrom) THEN	sFrom = '00000000'
	IF sTo   = "" OR IsNull(sTo)   THEN	sTo   = '00000000'
END IF

iRtnVal = F_Authority_Chk(Gs_Dept)
// 노상호 부장이랑 통화 ( 담당자 김은식 )  회계 권한 유무에 상관 없이  회계기준일로만 통제 
//IF iRtnVal = -1 THEN
	IF sFrom <= sAccDate AND sAccDate <= sTo THEN
		Return 1	
	ELSE
		Return -1
	END IF
//END IF

//Return 1

end function

public function integer wf_junpoyno (string ssaupj, string supmugbn, string syearmonthday);Long iJunNo

iJunNo = Sqlca.Fun_Calc_JunNo(sJunpoyGbn,sSaupj,sUpmuGbn,sYearMonthDay)

IF iJunNo > 0 THEN
ELSE
	IF iJunNo = -1 THEN
		f_MessageChk(34,'')
	ELSEIF iJunNo = -2 THEN
		f_MessageChk(1,'[사업장]')
	ELSEIF iJunNo = -3 THEN
		f_MessageChk(1,'[전표구분]')
	ELSEIF iJunNo = -4 THEN
		f_MessageChk(1,'[회계일자]')
	END IF
END IF

Return iJunNo

end function

public function integer wf_check_junno (string ssaupj, string saccym, string supmugbn, long ljunno);//Long lJunNo

SELECT "KFZ10OT1"."JUN_NO"  	INTO :lJunNo  
	FROM "KFZ10OT1"  
   WHERE ( "KFZ10OT1"."SAUPJ" = :sSaupj ) AND  ( "KFZ10OT1"."ACCYM" = :sAccYm ) AND  
         ( "KFZ10OT1"."UPMU_GU" = :sUpmuGbn ) AND ("KFZ10OT1"."JUN_NO" = :lJunNo)   ;
IF SQLCA.SQLCODE <> 0 THEN
	Return -1
END IF

Return 1
end function

on w_kglc01.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_rtv=create dw_rtv
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_rtv
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_kglc01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_rtv)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_insert.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"saupj",     gs_saupj)
//dw_cond.SetItem(dw_cond.GetRow(),"dept_cd",   gs_dept)
dw_cond.SetItem(dw_cond.GetRow(),"fromdate",  Left(f_today(),6)+'01')
dw_cond.SetItem(dw_cond.GetRow(),"todate",    f_today())

//dw_cond.SetItem(dw_cond.GetRow(),"accdate",    f_today())

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
	dw_cond.Modify("dept_cd.protect = 1")	
	
ELSE
	dw_cond.Modify("saupj.protect = 0")
	dw_cond.Modify("dept_cd.protect = 0")	
END IF	

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

ib_any_typing = False

dw_cond.SetColumn("fromdate")
dw_cond.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kglc01
boolean visible = false
integer x = 485
integer y = 2716
integer width = 1061
integer height = 100
integer taborder = 0
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type p_delrow from w_inherite`p_delrow within w_kglc01
boolean visible = false
integer x = 4037
integer y = 2544
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc01
boolean visible = false
integer x = 3781
integer y = 2520
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc01
integer x = 4096
integer taborder = 40
boolean originalsize = true
string picturename = "C:\Erpman\image\승인저장_up.gif"
end type

event p_search::clicked;//*************************************************************************************//
//   전표승인처리																								//																															
// 1. 미승인 TABLE(KFZ12OT0) --> 승인 TABLE(KFZ10OT0)로  DATA TRANSFER						//
//    # 승인전표 TABLE의 전표번호는 년월로 채번한다.												//
// 2. KFZ12OT0(미승인 TABLE)의 승인구분을 "Y"로 update 											//
// 3. KFZ12OT0의 지급어음구분,받을어음구분,접대비유무,부가세유무,차입금구분				//
//					   															유가증권구분이 "Y" 이면 //
//    지급어음 TABLE,받을어음 TABLE,접대비 TABLE,부가세 TABLE,차입금 TABLE					//
//		유가증권 TABLE에 승인구분은 "Y",회계일자,전표번호를 부여									// 
//*************************************************************************************//
String  sAccDate,sBalDate,sSaupj,sUpmuGbn,sAlcGbn = 'Y',sProcDate,sJunGu,sJunpoyNoMode,sBalNoMode
Integer iSelectedRow,iCurRow,lJunNo,lBJunNo,iRowCount,k,i,iInsRow
Double  dGetData,dChaAmt,dDaeAmt

String lbae_val[54]
String lbae_col[54]={"saupj"    ,"bal_date" ,"upmu_gu"   ,"bjun_no"  ,"lin_no"     ,"jun_gu"   ,&
							"dept_cd"  ,"acc1_cd"  ,"acc2_cd"   ,"sawon"    ,"dcr_gu"     ,"amt"      ,&
							"vatamt"   ,"descr"    ,"cdept_cd"  ,"sdept_cd" ,"yesan_amt"  ,"yesan_jan",&
							"yesan_no" ,"k_amt"    ,"k_rate"    ,"k_qty"    ,"k_uprice"   ,"k_symd"   ,&
							"k_eymd"   ,"y_amt"    ,"y_rate"    ,"y_curr"   ,"in_cd"      ,"in_nm"    ,&
							"gyul_date","send_bank","send_dep"  ,"send_nm"  ,"cr_cd"      ,"jub_gu"   ,&
							"jbill_gu" ,"rbill_gu" ,"vat_gu"    ,"chaip_gu" ,"secu_gu"    ,"exp_gu"   ,&
							"fsang_gu" ,"cross_gu" ,"kwan_no"   ,"pjt_no"   ,"itm_gu"     ,"saup_no"  ,&
							"gyul_method","kwan_no2","kwan_no3" ,"aset_gu"  ,"taxgbn"     ,"gita1" }                                            							
Integer iSaveFlag12,iSaveFlag10

dw_cond.AcceptText()
sProcDate = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"accdate"))
	
iSelectedRow =	dw_2.GetSelectedRow(0)
If iSelectedRow = 0 then
   MessageBox("확 인", "승인할 자료를 선택후 승인버튼을 누르십시오 !")
   Return
END IF

/*승인전표번호 채번 방식 :2004.02.06*/
select substr(dataname,1,1)	into :sJunpoyNoMode			/*1:신규 2:이전번호*/
	from syscnfg 
	where sysgu = 'A' and serial = 20 and lineno = '1';
if sqlca.sqlcode = 0 then
	if IsNull(sJunPoyNoMode) then sJunPoyNoMode = '1'
else
	sJunPoyNoMode = '1'
end if

/*전표번호 채번 방식 :2004.02.06*/
select substr(dataname,1,1)	into :sBalNoMode			/*1:무순위순차적 2:전표종류별*/
	from syscnfg 
	where sysgu = 'A' and serial = 20 and lineno = '2';
if sqlca.sqlcode = 0 then
	if IsNull(sBalNoMode) then sBalNoMode = '1'
else
	sBalNoMode = '1'
end if

DO WHILE true
	iCurRow = 	dw_2.GetSelectedRow(0)
	If iCurRow = 0 then EXIT
	
	sJunGu = dw_2.GetItemString(iCurRow,"jungu")					/*전표종류*/
	
	IF dw_2.GetItemString(iCurRow,"acc_no") <> "" AND Not IsNull(dw_2.GetItemString(iCurRow,"acc_no")) THEN
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	sSaupj   = dw_2.GetItemString(iCurRow,"saupj")
	sBalDate = dw_2.GetItemString(iCurRow,"bal_date") 
	sUpmuGbn = dw_2.GetItemString(iCurRow,"upmu_gu") 
	lBJunNo  = dw_2.GetItemNumber(iCurRow,"bjun_no") 
	lJunNo   = dw_2.GetItemNumber(iCurRow,"jun_no") 
	
	IF sProcDate = "" OR IsNull(sProcDate) THEN 	/*승인일자 없으면 발행일자를 승인일자로*/
		sAccDate   = sBalDate
	ELSE
		sAccDate   = sProcDate
	END IF
	
	if sJunGu = '3' then
		dChaAmt = dw_2.GetItemNumber(iCurRow,"cha") 
		dDaeAmt = dw_2.GetItemNumber(iCurRow,"dae")  
		
		IF dChaAmt <> dDaeAmt THEN
			F_MessageChk(45,'')
			dw_2.SelectRow(iCurRow,FALSE)
			Continue
		END IF
	end if
	
	/*승인기준일자 체크*/
	IF Wf_Check_StandardDate(sAccDate) <> 1 THEN		
		F_MessageChk(29,'[승인일자]')
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	/*마감 체크*/
	IF F_Magam_Check("2", sSaupj,sAccDate) <> 1 THEN		
		F_MessageChk(61,'[승인일자]')
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	if sJunPoyNoMode = '1' then				/*신규로*/
		if sBalNoMode = '1' then
			lJunNo = Wf_JunPoyNo(sSaupj,sUpmuGbn,sAccDate)
		else
			lJunNo = Wf_JunPoyNo(sSaupj,sJunGu,sAccDate)
		end if
	else
		/*전표 채번:결번 전표번호를 먼저 체크 후 채번(2003.07.03)*/
		select max(jun_no)	into :lJunNo
			from kfz10ot1
			where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGbn and 
					bjun_no = :lBJunNo and acc_date = :sAccDate ;
		if sqlca.sqlcode <> 0 or IsNull(lJunNo) or lJunNo = 0 then
			if sBalNoMode = '1' then
				lJunNo = Wf_JunPoyNo(sSaupj,sUpmuGbn,sAccDate)
			else
				lJunNo = Wf_JunPoyNo(sSaupj,sJunGu,sAccDate)
			end if
		end if
	end if
	
	IF lJunNo <= 0 THEN								/*전표 채번 실패*/
		F_MessageChk(34,'')
		continue
	END IF
	
	dw_rtv.Reset()
	dw_insert.Reset()									
	
	iRowCount = dw_rtv.Retrieve(sSaupj,sBalDate,sUpmuGbn,lBJunNo)
	FOR k = 1 TO iRowCount					
		FOR i = 1 TO 54					/*미승인 전표의 자료 가져오기*/
			IF i = 4 or  i = 5 or  i = 12 or i = 13  OR i = 17 OR i =18 OR i = 19 OR i = 20 OR &
				i = 21 OR i = 22 OR i = 23 OR i = 26 OR  i = 27 THEN
				dGetData = dw_rtv.GetItemNumber(k, lbae_col[i])
				lbae_val[i] = String(dGetData)
			ELSE
				lbae_val[i] = dw_rtv.GetItemString(k, lbae_col[i])
			END IF
		NEXT					
		dw_rtv.SetItem(k, "alc_gu", sAlcGbn)
						
		iInsRow = dw_insert.InsertRow(0)
		FOR i = 1 TO 54					/*승인 전표에 setting*/
			 IF i = 4 or  i = 5 or  i = 12 or i = 13  OR i = 17 OR i =18 OR i = 19 OR i = 20 OR &
				 i = 21 OR i = 22 OR i = 23 OR i = 26 OR  i = 27 THEN
				 dw_insert.SetItem(iInsRow, lbae_col[i], Double(lbae_val[i]))
			 ELSE
				 dw_insert.SetItem(iInsRow, lbae_col[i], lbae_val[i])
			 END IF
		NEXT
		dw_insert.SetItem(iInsRow, "acc_date",sAccDate)
		dw_insert.SetItem(iInsRow, "jun_no",  lJunNo)
		dw_insert.SetItem(iInsRow, "indat",   f_today())
	NEXT
	
	if sJunGu = '1' or sJunGu = '2' then
		/*입/출금전표이면 현금계정 추가:2003.07.04*/
		iInsRow = dw_insert.InsertRow(0)
				
		FOR i = 1 TO 12					/*승인 전표에 setting*/
			 IF i = 4 or  i = 5 THEN
				 dw_insert.SetItem(iInsRow, lbae_col[i], Double(lbae_val[i]))
			ELSEIF i = 5 or  i = 8 or  i = 9 or i = 11 or i = 12 THEN
			 ELSE
				 dw_insert.SetItem(iInsRow, lbae_col[i], lbae_val[i])
			 END IF
		NEXT
		
		F_Insert_CashAcc(dw_insert,iInsRow,lbae_val[1], lBae_Val[2], lBae_Val[3], &
								Double(lbae_val[4]), Double(lbae_val[5]), lBae_Val[6])
		
		dw_insert.SetItem(iInsRow, "acc_date",sAccDate)
		dw_insert.SetItem(iInsRow, "jun_no",  lJunNo)
		dw_insert.SetItem(iInsRow, "indat",   f_today())
		
	end if
	
	If F_Ilgye_Add(dw_insert) < 0 Then
		Rollback;
		Return
	End if
		
	iSaveFlag12 = dw_rtv.Update()
	iSaveFlag10 = dw_insert.Update()
	
	IF iSaveFlag12 <> 1 THEN		
		ROLLBACK;		
		F_MessageChk(13,'[미승인전표]')		
		return
	END IF
	IF iSaveFlag10 <> 1 THEN
//		F_MessageChk(13,'[승인전표]')
		ROLLBACK;
		
		return
	END IF	
	
	IF F_Control_Junpoy_History('I',	sSaupj, sAccDate,	sUpmuGbn, lJunNo, sBalDate, &
										 dw_rtv.GetItemString(1,"dept_cd"),  &
										 dw_rtv.GetItemString(1,"sawon"),   'A') = -1  THEN
		F_MessageChk(13,'[전표 승인 이력]')
		Rollback;
		Return
	END IF

	dw_2.SetItem(iCurRow,"acc_date",sAccDate)
	dw_2.SetItem(iCurRow,"jun_no",  lJunNo)
	dw_2.SelectRow(iCurRow,FALSE)
LOOP

COMMIT;

w_mdi_frame.SLE_MSG.TEXT ="승인 처리 완료!!"

//cb_inq.TriggerEvent(Clicked!)



end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\승인저장_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\승인저장_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kglc01
boolean visible = false
integer x = 3621
integer y = 2488
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc01
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kglc01
integer taborder = 50
end type

type p_print from w_inherite`p_print within w_kglc01
boolean visible = false
integer x = 3991
integer y = 2732
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc01
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;
Long   lJunNoFrom,lJunNoTo  
String sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,sUpmuGbn

dw_1.Reset()

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDeptCode    = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
lJunNoFrom   = dw_cond.GetItemNumber(dw_cond.GetRow(),"fromno") 
lJunNoTo     = dw_cond.GetItemNumber(dw_cond.GetRow(),"tono") 
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"fromdate") 
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"todate") 
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu")

IF sSaupj = "" or IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
END IF
IF sDeptCode = "" or IsNull(sDeptCode) THEN sDeptCode = '%'

IF lJunNoFrom = 0 OR IsNull(lJunNoFrom) THEN	lJunNoFrom = 1
IF lJunNoTo = 0 OR IsNull(lJunNoTo) THEN	lJunNoTo = 1

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
	F_MessageChk(1,'[작성일자]')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	return
END IF
	
IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
	F_MessageChk(1,'[작성일자]')
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateTo THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 작성일자를 확인하십시오")
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF


IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN	sUpmuGbn = '%'

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,lJunNoFrom,lJunNoTo,sUpmuGbn) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_1.Reset()

w_mdi_frame.sle_msg.text ="미승인 전표를 조회하였습니다.!!"




end event

type p_del from w_inherite`p_del within w_kglc01
boolean visible = false
integer x = 3767
integer y = 2680
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc01
boolean visible = false
integer x = 3570
integer y = 2668
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kglc01
integer x = 3150
integer y = 2668
end type

type cb_mod from w_inherite`cb_mod within w_kglc01
integer x = 2811
integer y = 2672
string text = "승인(&S)"
end type

event cb_mod::clicked;call super::clicked;//*************************************************************************************//
//   전표승인처리																								//																															
// 1. 미승인 TABLE(KFZ12OT0) --> 승인 TABLE(KFZ10OT0)로  DATA TRANSFER						//
//    # 승인전표 TABLE의 전표번호는 년월로 채번한다.												//
// 2. KFZ12OT0(미승인 TABLE)의 승인구분을 "Y"로 update 											//
// 3. KFZ12OT0의 지급어음구분,받을어음구분,접대비유무,부가세유무,차입금구분				//
//					   															유가증권구분이 "Y" 이면 //
//    지급어음 TABLE,받을어음 TABLE,접대비 TABLE,부가세 TABLE,차입금 TABLE					//
//		유가증권 TABLE에 승인구분은 "Y",회계일자,전표번호를 부여									// 
//*************************************************************************************//
String  sAccDate,sBalDate,sSaupj,sUpmuGbn,sAlcGbn = 'Y',sProcDate
Integer iSelectedRow,iCurRow,lJunNo,lBJunNo,iRowCount,k,i,iInsRow
Double  dGetData,dChaAmt,dDaeAmt

String lbae_val[53]
String lbae_col[53]={"saupj"    ,"bal_date" ,"upmu_gu"   ,"bjun_no"  ,"lin_no"     ,"jun_gu"   ,&
							"dept_cd"  ,"acc1_cd"  ,"acc2_cd"   ,"sawon"    ,"dcr_gu"     ,"amt"      ,&
							"vatamt"   ,"descr"    ,"cdept_cd"  ,"sdept_cd" ,"yesan_amt"  ,"yesan_jan",&
							"yesan_no" ,"k_amt"    ,"k_rate"    ,"k_qty"    ,"k_uprice"   ,"k_symd"   ,&
							"k_eymd"   ,"y_amt"    ,"y_rate"    ,"y_curr"   ,"in_cd"      ,"in_nm"    ,&
							"gyul_date","send_bank","send_dep"  ,"send_nm"  ,"cr_cd"      ,"jub_gu"   ,&
							"jbill_gu" ,"rbill_gu" ,"vat_gu"    ,"chaip_gu" ,"secu_gu"    ,"exp_gu"   ,&
							"fsang_gu" ,"cross_gu" ,"kwan_no"   ,"pjt_no"   ,"itm_gu"     ,"saup_no"  ,&
							"gyul_method","kwan_no2","kwan_no3" ,"aset_gu"  ,"taxgbn" }                                            							
Integer iSaveFlag12,iSaveFlag10

dw_cond.AcceptText()
sProcDate = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"accdate"))
	
iSelectedRow =	dw_2.GetSelectedRow(0)
If iSelectedRow = 0 then
   MessageBox("확 인", "승인할 자료를 선택후 승인버튼을 누르십시오 !")
   Return
END IF

DO WHILE true
	iCurRow = 	dw_2.GetSelectedRow(0)
	If iCurRow = 0 then EXIT
	
	IF dw_2.GetItemString(iCurRow,"acc_no") <> "" AND Not IsNull(dw_2.GetItemString(iCurRow,"acc_no")) THEN
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	sSaupj   = dw_2.GetItemString(iCurRow,"saupj")
	sBalDate = dw_2.GetItemString(iCurRow,"bal_date") 
	sUpmuGbn = dw_2.GetItemString(iCurRow,"upmu_gu") 
	lBJunNo  = dw_2.GetItemNumber(iCurRow,"bjun_no") 
	lJunNo   = dw_2.GetItemNumber(iCurRow,"jun_no") 
	
	IF sProcDate = "" OR IsNull(sProcDate) THEN 	/*승인일자 없으면 발행일자를 승인일자로*/
		sAccDate   = sBalDate
	ELSE
		sAccDate   = sProcDate
	END IF
	
	dChaAmt = dw_2.GetItemNumber(iCurRow,"cha") 
	dDaeAmt = dw_2.GetItemNumber(iCurRow,"dae")  
	
	IF dChaAmt <> dDaeAmt THEN
		F_MessageChk(45,'')
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF

	/*승인기준일자 체크*/
	IF Wf_Check_StandardDate(sAccDate) <> 1 THEN		
		F_MessageChk(29,'[승인일자]')
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	/*마감 체크*/
	IF F_Magam_Check("2",sSaupj,sAccDate) <> 1 THEN		
		F_MessageChk(61,'[승인일자]')
		dw_2.SelectRow(iCurRow,FALSE)
		Continue
	END IF
	
	/*전표 채번 여부(작성일자 <> 승인일자)99.07.19 */
	lJunNo = Wf_JunPoyNo(sSaupj,sUpmuGbn,sAccDate)
	IF lJunNo <= 0 THEN								/*전표 채번 실패*/
		F_MessageChk(34,'')
		continue
	END IF
	
	dw_rtv.Reset()
	dw_insert.Reset()									
	
	iRowCount = dw_rtv.Retrieve(sSaupj,sBalDate,sUpmuGbn,lBJunNo)
	FOR k = 1 TO iRowCount					
		FOR i = 1 TO 53					/*미승인 전표의 자료 가져오기*/
			IF i = 4 or  i = 5 or  i = 12 or i = 13  OR i = 17 OR i =18 OR i = 19 OR i = 20 OR &
				i = 21 OR i = 22 OR i = 23 OR i = 26 OR  i = 27 THEN
				dGetData = dw_rtv.GetItemNumber(k, lbae_col[i])
				lbae_val[i] = String(dGetData)
			ELSE
				lbae_val[i] = dw_rtv.GetItemString(k, lbae_col[i])
			END IF
		NEXT					
		dw_rtv.SetItem(k, "alc_gu", sAlcGbn)
						
		iInsRow = dw_insert.InsertRow(0)
		FOR i = 1 TO 53					/*승인 전표에 setting*/
			 IF i = 4 or  i = 5 or  i = 12 or i = 13  OR i = 17 OR i =18 OR i = 19 OR i = 20 OR &
				 i = 21 OR i = 22 OR i = 23 OR i = 26 OR  i = 27 THEN
				 dw_insert.SetItem(iInsRow, lbae_col[i], Double(lbae_val[i]))
			 ELSE
				 dw_insert.SetItem(iInsRow, lbae_col[i], lbae_val[i])
			 END IF
		NEXT
		dw_insert.SetItem(iInsRow, "acc_date",sAccDate)
		dw_insert.SetItem(iInsRow, "jun_no",  lJunNo)
		dw_insert.SetItem(iInsRow, "indat",   f_today())
	NEXT
	iSaveFlag12 = dw_rtv.Update()
	iSaveFlag10 = dw_insert.Update()
	
	IF iSaveFlag12 <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		
		ROLLBACK;
		
		return
	END IF
	IF iSaveFlag10 <> 1 THEN
//		F_MessageChk(13,'[승인전표]')
		ROLLBACK;
		
		return
	END IF	
	
	IF F_Control_Junpoy_History('I',	sSaupj, sAccDate,	sUpmuGbn, lJunNo, sBalDate, &
										 dw_rtv.GetItemString(1,"dept_cd"),  &
										 dw_rtv.GetItemString(1,"sawon"),   'A') = -1  THEN
		F_MessageChk(13,'[전표 승인 이력]')
		Rollback;
		Return
	END IF

	dw_2.SetItem(iCurRow,"acc_date",sAccDate)
	dw_2.SetItem(iCurRow,"jun_no",  lJunNo)
	dw_2.SelectRow(iCurRow,FALSE)
LOOP

String sJipFrom,sJipTo,sJipFlag

SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN 
	sJipFlag = 'N'
ELSE
	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
END IF

IF sJipFlag = 'Y' THEN
	IF dw_cond.GetItemString(1,"accdate") ="" OR IsNull(dw_cond.GetItemString(1,"accdate")) THEN
		sJipFrom = dw_2.GetItemString(1,"min_ym")
		sJipTo   = dw_2.GetItemString(1,"max_ym")
	ELSE
		sJipFrom = Left(dw_cond.GetItemString(1,"accdate"),6)
		sJipTo = Left(dw_cond.GetItemString(1,"accdate"),6)
	END IF
	
	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
	F_ACC_SUM(sJipFrom,sJipTo)
	
	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
	
	//stored procedure로 사업부문별 거래처별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
END IF

COMMIT;

SLE_MSG.TEXT ="승인 처리 완료!!"

//cb_inq.TriggerEvent(Clicked!)



end event

type cb_ins from w_inherite`cb_ins within w_kglc01
integer x = 2117
integer y = 2464
end type

type cb_del from w_inherite`cb_del within w_kglc01
integer x = 2802
integer y = 2456
end type

type cb_inq from w_inherite`cb_inq within w_kglc01
integer x = 37
integer y = 2672
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;
Long   lJunNoFrom,lJunNoTo  
String sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,sUpmuGbn,sAllGbn,sAcRcvFlag

dw_1.Reset()

sle_msg.text =""

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDeptCode    = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
lJunNoFrom   = dw_cond.GetItemNumber(dw_cond.GetRow(),"fromno") 
lJunNoTo     = dw_cond.GetItemNumber(dw_cond.GetRow(),"tono") 
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"fromdate") 
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"todate") 
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu") 
sAllGbn      = dw_cond.GetItemString(dw_cond.GetRow(),"jungbn") 

IF sSaupj = "" or IsNull(sSaupj) THEN
	F_MessageChk(1,'[회계단위]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
ELSE
	IF sSaupj ='9' THEN sSaupj = '%'
END IF

IF sDeptCode = "" or IsNull(sDeptCode) THEN sDeptCode = '%'

IF lJunNoFrom = 0 OR IsNull(lJunNoFrom) THEN
	lJunNoFrom = 1
END IF

IF lJunNoTo = 0 OR IsNull(lJunNoTo) THEN
	lJunNoTo = 1
END IF

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
	F_MessageChk(1,'[작성일자]')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	return
END IF
	
IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
	F_MessageChk(1,'[작성일자]')
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateTo THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 작성일자를 확인하십시오")
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF


IF sAllGbn = "" OR IsNull(sAllGbn) OR sAllGbn = 'N' THEN
	IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN
		F_MessageChk(1,'[전표구분]')
		dw_cond.SetColumn("upmu_gu")
		dw_cond.SetFocus()
		return	
	END IF
ELSE
	sUpmuGbn = '%'
END IF

/*경리접수 여부 체크*/
SELECT "SYSCNFG"."DATANAME"      INTO :sAcRcvFlag  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 11 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sAcRcvFlag = '%'
ELSE
	IF IsNull(sAcRcvFlag) OR sAcRcvFlag = "" OR sAcRcvFlag = 'N' THEN sAcRcvFlag = '%'	
END IF

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,lJunNoFrom,lJunNoTo,sUpmuGbn,sAcRcvFlag) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_1.Reset()

sle_msg.text ="미승인 전표를 조회하였습니다.!!"




end event

type cb_print from w_inherite`cb_print within w_kglc01
integer x = 2455
integer y = 2464
end type

type st_1 from w_inherite`st_1 within w_kglc01
end type

type cb_can from w_inherite`cb_can within w_kglc01
integer x = 3145
integer y = 2456
end type

type cb_search from w_inherite`cb_search within w_kglc01
integer x = 2414
integer y = 2608
end type







type gb_button1 from w_inherite`gb_button1 within w_kglc01
integer x = 0
integer y = 2616
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc01
integer x = 2770
integer y = 2616
integer width = 768
end type

type dw_cond from u_key_enter within w_kglc01
integer x = 55
integer width = 3625
integer height = 316
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc011"
boolean border = false
end type

event getfocus;this.AcceptText()

end event

event itemerror;
Return 1
end event

event itemchanged;String  sSaupj,  sBalDate,sDeptCode,sDeptName,sJpGbn,sUpmuGbn,sNull
Integer iCurRow
Long    lJunNo

SetNull(snull)

iCurRow = this.GetRow()

this.AcceptText()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	sDeptName = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "fromdate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"fromdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "todate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"todate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="upmu_gu" THEN
	sUpmuGbn = this.GetText()
	IF sUpmuGbn ="" OR IsNull(sUpmuGbn) THEN RETURN 
	
	IF IsNull(f_Get_Refferance('AG',sUpmuGbn)) THEN
		f_messagechk(20,"전표구분")
		this.SetItem(iCurRow,"upmu_gu",snull)
		this.SetColumn("upmu_gu")
		Return 1
	END IF
END IF

IF this.GetColumnName() = "accdate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[승인일자]')
		this.SetItem(iCurRow,"accdate",snull)
		Return 1
	END IF
END IF



end event

type dw_rtv from datawindow within w_kglc01
boolean visible = false
integer x = 485
integer y = 2604
integer width = 1061
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "미승인전표 라인별 조회.저장"
string dataobject = "dw_kglc013"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_2 from u_d_select_sort within w_kglc01
integer x = 73
integer y = 320
integer width = 4453
integer height = 1176
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kglc012"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.AcceptText()
end event

event rbuttondown;//
//String sSaupj,sBalDate,sAccDate,sUpmuGbn

IF Row <=0 THEN Return

SelectRow(Row,False)

//SetNull(Gs_Code)
//
//dw_cond.AcceptText()
//sAccDate = dw_cond.GetItemString(dw_cond.GetRow(),"accdate")
//
//IF this.GetColumnName() = "jun_no" THEN
//	sSaupj   = this.GetItemString(this.GetRow(),"saupj")
//	sBalDate = this.GetItemString(this.GetRow(),"bal_date") 
//	sUpmuGbn = this.GetItemString(this.GetRow(),"upmu_gu") 
//	
//	IF sAccDate = "" OR IsNull(sAccDate) THEN
//		sAccDate = sBalDate
//	END IF
//	
//	Gs_Code  = Left(sAccDate,6)
//	Gs_Gubun = sUpmuGbn
//	
//	OpenWithParm(W_Kfz10ot1_popup,sSaupj)
//	
//	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
//	
//	this.SetItem(this.GetRow(),"jun_no",Long(Gs_Code))
//	this.TriggerEvent(ItemChanged!)
//	Return 1
//END IF
end event

event itemerror;Return 1
end event

event clicked;
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
		
	lstr_jpra.saupjang  = dw_2.GetItemString(Row, "saupj")
	lstr_jpra.baldate   = dw_2.GetItemString(Row, "bal_date")
	lstr_jpra.upmugu    = dw_2.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno    = dw_2.GetItemNumber(Row, "bjun_no")
	
	dw_1.Retrieve( lstr_jpra.saupjang, lstr_jpra.baldate, lstr_jpra.upmugu, lstr_jpra.bjunno )
END IF

CALL SUPER ::CLICKED
end event

event buttonclicked;
IF dwo.name = 'dcb_junpoy' THEN										/*전표 조회*/
	lstr_jpra.saupjang  = dw_2.GetItemString(Row, "saupj")
	lstr_jpra.baldate   = dw_2.GetItemString(Row, "bal_date")
	lstr_jpra.upmugu    = dw_2.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno    = dw_2.GetItemNumber(Row, "bjun_no")
	lstr_jpra.jun_gu    = dw_2.GetItemString(Row, "jungu")
	
	lstr_jpra.flag  = True
	
	OpenSheetWithParm(w_kglc01b,'',w_mdi_frame,2,Layered!)
END IF
end event

type dw_1 from datawindow within w_kglc01
integer x = 73
integer y = 1532
integer width = 4462
integer height = 692
boolean bringtotop = true
string dataobject = "dw_kglc011_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglc01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 316
integer width = 4480
integer height = 1196
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kglc01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 1524
integer width = 4480
integer height = 712
integer cornerheight = 40
integer cornerwidth = 46
end type

