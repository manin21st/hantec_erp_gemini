$PBExportHeader$w_kglc09.srw
$PBExportComments$전표 승인 처리(전표번호 입력)
forward
global type w_kglc09 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc09
end type
type dw_rtv from datawindow within w_kglc09
end type
type dw_2 from u_d_select_sort within w_kglc09
end type
type dw_junpyo from datawindow within w_kglc09
end type
type dw_1 from u_d_select_sort within w_kglc09
end type
type rr_1 from roundrectangle within w_kglc09
end type
type rr_2 from roundrectangle within w_kglc09
end type
end forward

global type w_kglc09 from w_inherite
string title = "전표 승인 처리(전표번호 입력)"
dw_cond dw_cond
dw_rtv dw_rtv
dw_2 dw_2
dw_junpyo dw_junpyo
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc09 w_kglc09

type variables
String sJunpoyGbn = 'A'
end variables

forward prototypes
public function integer wf_check_standarddate (string saccdate)
public function integer wf_junpoyno (string ssaupj, string supmugbn, string syearmonthday)
public function integer wf_check_junno (string ssaupj, string saccym, string supmugbn, long ljunno)
public function integer wf_dup_check (datawindow ag_dw, integer ag_row, string ag_mmdd, integer ag_no)
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

IF iRtnVal = -1 THEN
	IF sFrom <= sAccDate AND sAccDate <= sTo THEN
		Return 1	
	ELSE
		Return -1
	END IF
END IF

Return 1

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

public function integer wf_dup_check (datawindow ag_dw, integer ag_row, string ag_mmdd, integer ag_no);Integer i

ag_dw.accepttext()

For i = 1 To ag_dw.rowcount()
	If i <> ag_row Then
		If ag_dw.getitemstring(i, "bal_mmdd")+String(ag_dw.getitemnumber(i, "bjun_no")) = ag_mmdd+String(ag_no) Then Return -1
	End if
Next

Return 0
end function

on w_kglc09.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_rtv=create dw_rtv
this.dw_2=create dw_2
this.dw_junpyo=create dw_junpyo
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_rtv
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_junpyo
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_kglc09.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_rtv)
destroy(this.dw_2)
destroy(this.dw_junpyo)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_insert.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_junpyo.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"saupj", gs_saupj)
dw_cond.SetItem(dw_cond.GetRow(),"year", Left(f_today(),4))

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
ELSE
	dw_cond.Modify("saupj.protect = 0")
END IF

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

ib_any_typing = False

dw_cond.SetColumn("year")
dw_cond.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_kglc09
boolean visible = false
integer x = 489
integer y = 2704
integer width = 1061
integer height = 100
integer taborder = 0
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc094"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type p_delrow from w_inherite`p_delrow within w_kglc09
boolean visible = false
integer x = 4037
integer y = 2544
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc09
boolean visible = false
integer x = 3781
integer y = 2520
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc09
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
String  sProcDate,sAccDate,sBalDate,sSaupj,sUpmuGbn,sAlcGbn = 'Y',sJunGu,sJunpoyNoMode,sBalNoMode
Integer iCurRow,lJunNo,lBJunNo,iRowCount,k,i,iInsRow
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
dw_2.AcceptText()

sProcDate = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"accdate"))

/*승인전표번호 채번 방식 :2004.02.06*/
select substr(dataname,1,1)	into :sJunpoyNoMode		/*1:신규 2:이전번호*/
	from syscnfg
	where sysgu = 'A' and serial = 20 and lineno = '1';
IF sqlca.sqlcode = 0 THEN
	IF IsNull(sJunPoyNoMode) THEN sJunPoyNoMode = '1'
ELSE
	sJunPoyNoMode = '1'
END IF

/*전표번호 채번 방식 :2004.02.06*/
select substr(dataname,1,1)	into :sBalNoMode			/*1:무순위순차적 2:전표종류별*/
	from syscnfg
	where sysgu = 'A' and serial = 20 and lineno = '2';
IF sqlca.sqlcode = 0 THEN
	IF IsNull(sBalNoMode) THEN sBalNoMode = '1'
ELSE
	sBalNoMode = '1'
END IF

dw_2.setredraw(False)

For iCurRow = 1 To dw_2.rowcount()
	
	sJunGu = dw_2.GetItemString(iCurRow,"jungu")					/*전표종류*/
		
	sSaupj   = dw_2.GetItemString(iCurRow,"saupj")
	sBalDate = dw_2.GetItemString(iCurRow,"bal_year") + dw_2.GetItemString(iCurRow,"bal_mmdd")
	sUpmuGbn = dw_2.GetItemString(iCurRow,"upmu_gu")
	lBJunNo  = dw_2.GetItemNumber(iCurRow,"bjun_no")
	
	IF dw_2.GetItemNumber(iCurRow,"bjun_no") = 0 Or IsNull(dw_2.GetItemNumber(iCurRow,"bjun_no")) THEN Continue
	IF Len(Trim(dw_2.GetItemString(iCurRow,"acc_no"))) > 0 AND Not IsNull(Trim(dw_2.GetItemString(iCurRow,"acc_no"))) THEN Continue	//승인여부 Check
	
	IF sJunGu = '3' THEN
		dChaAmt = dw_2.GetItemNumber(iCurRow,"cha") 
		dDaeAmt = dw_2.GetItemNumber(iCurRow,"dae")  
		
		IF dChaAmt <> dDaeAmt THEN
			F_MessageChk(45,'')
			dw_2.SelectRow(iCurRow,FALSE)
			Continue
		END IF
	END IF
	
	//승인일자 미입력시는 작성월일을 승인일로 Set
	IF Isnull(sProcDate) Or Len(sProcDate) = 0 THEN
		sAccDate = Trim(dw_2.GetItemString(iCurRow,"bal_year")) + Trim(dw_2.GetItemString(iCurRow,"bal_mmdd"))
	ELSE
		sAccDate = sProcDate
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
	
	IF sJunPoyNoMode = '1' THEN				/*신규로*/
		IF sBalNoMode = '1' THEN
			lJunNo = Wf_JunPoyNo(sSaupj,sUpmuGbn,sAccDate)
		ELSE
			lJunNo = Wf_JunPoyNo(sSaupj,sJunGu,sAccDate)
		END IF
	ELSE
		/*전표 채번:결번 전표번호를 먼저 체크 후 채번(2003.07.03)*/
		select max(jun_no)	into :lJunNo
			from kfz10ot1
			where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGbn and 
					bjun_no = :lBJunNo and acc_date = :sAccDate ;
		IF sqlca.sqlcode <> 0 or IsNull(lJunNo) or lJunNo = 0 THEN
			IF sBalNoMode = '1' THEN
				lJunNo = Wf_JunPoyNo(sSaupj,sUpmuGbn,sAccDate)
			ELSE
				lJunNo = Wf_JunPoyNo(sSaupj,sJunGu,sAccDate)
			END IF
		END IF
	END IF
	
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
	
	IF sJunGu = '1' or sJunGu = '2' THEN
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
		
	END IF

	//대체전표 현금처리 포함 일집계
	If F_Ilgye_Add(dw_insert) < 0 Then
		Rollback;
		Return
	End if

	iSaveFlag12 = dw_rtv.Update()
	iSaveFlag10 = dw_insert.Update()
	
	IF iSaveFlag12 <> 1 THEN		
		ROLLBACK;		
		F_MessageChk(13,'[미승인전표]')
		dw_2.setredraw(True)
		return
	END IF
	IF iSaveFlag10 <> 1 THEN
		ROLLBACK;
		dw_2.setredraw(True)
		return
	END IF	
	
	IF F_Control_Junpoy_History('I',	sSaupj, sAccDate,	sUpmuGbn, lJunNo, sBalDate, &
										 dw_rtv.GetItemString(1,"dept_cd"),  &
										 dw_rtv.GetItemString(1,"sawon"),   'A') = -1  THEN
		F_MessageChk(13,'[전표 승인 이력]')
		Rollback;
		dw_2.setredraw(True)
		Return
	END IF

	dw_2.SetItem(iCurRow,"acc_no", String(lJunNo, "0000"))

Next

COMMIT;

dw_2.setredraw(True)

w_mdi_frame.SLE_MSG.TEXT ="승인 처리 완료!!"
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\승인저장_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\승인저장_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kglc09
integer x = 3922
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;String sSaupj,sYear,sAccDate

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sSaupj   = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sYear    = dw_cond.GetItemString(dw_cond.GetRow(),"year")

IF sSaupj = "" or IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
END IF

IF sYear = "" or IsNull(sYear) THEN
	F_MessageChk(1,'[회계년도]')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	return
END IF

dw_cond.modify("saupj.protect = '1'")
dw_cond.modify("year.protect = '1'")

dw_2.insertrow(0)

dw_2.setitem(dw_2.rowcount(), "saupj", sSaupj)
dw_2.setitem(dw_2.rowcount(), "bal_year", sYear)

dw_2.setcolumn("bal_mmdd")
dw_2.setrow(dw_2.rowcount())
dw_2.setfocus()
end event

type p_exit from w_inherite`p_exit within w_kglc09
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kglc09
integer taborder = 50
end type

event p_can::clicked;call super::clicked;IF F_Authority_Chk(Gs_Dept) <> -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 0")
END IF

dw_cond.modify("year.protect = '0'")

dw_cond.setitem(dw_cond.getrow(), "accdate", "")

dw_1.reset()
dw_2.reset()
end event

type p_print from w_inherite`p_print within w_kglc09
boolean visible = false
integer x = 3991
integer y = 2732
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc09
integer x = 3602
integer y = 2528
integer taborder = 20
end type

type p_del from w_inherite`p_del within w_kglc09
boolean visible = false
integer x = 3767
integer y = 2680
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc09
boolean visible = false
integer x = 3570
integer y = 2668
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kglc09
boolean visible = false
integer x = 3150
integer y = 2668
end type

type cb_mod from w_inherite`cb_mod within w_kglc09
boolean visible = false
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

type cb_ins from w_inherite`cb_ins within w_kglc09
boolean visible = false
integer x = 2117
integer y = 2464
end type

type cb_del from w_inherite`cb_del within w_kglc09
boolean visible = false
integer x = 2802
integer y = 2456
end type

type cb_inq from w_inherite`cb_inq within w_kglc09
boolean visible = false
integer x = 37
integer y = 2672
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_kglc09
boolean visible = false
integer x = 2455
integer y = 2464
end type

type st_1 from w_inherite`st_1 within w_kglc09
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc09
boolean visible = false
integer x = 3145
integer y = 2456
end type

type cb_search from w_inherite`cb_search within w_kglc09
boolean visible = false
integer x = 2414
integer y = 2608
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc09
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglc09
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglc09
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc09
boolean visible = false
integer x = 0
integer y = 2616
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc09
boolean visible = false
integer x = 2770
integer y = 2616
integer width = 768
end type

type dw_cond from u_key_enter within w_kglc09
integer x = 55
integer y = 8
integer width = 2624
integer height = 256
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc091"
boolean border = false
end type

event getfocus;this.AcceptText()

end event

event itemerror;
Return 1
end event

event itemchanged;String  sSaupj,sBalDate,sNull
Integer iCurRow

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

type dw_rtv from datawindow within w_kglc09
boolean visible = false
integer x = 489
integer y = 2596
integer width = 1061
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "미승인전표 라인별 조회.저장"
string dataobject = "dw_kglc093"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_2 from u_d_select_sort within w_kglc09
event u_pressenter pbm_dwnprocessenter
integer x = 73
integer y = 280
integer width = 4453
integer height = 1212
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kglc092"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event u_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String ls_saupj,ls_year,ls_balmd

This.accepttext()

ls_saupj = Trim(This.getitemstring(row, "saupj"))
ls_year = Trim(This.getitemstring(row, "bal_year"))

If dwo.name = "bal_mmdd" Then
	
	This.setitem(row, "bjun_no", 0)
	This.setitem(row, "jungu", "")
	This.setitem(row, "dept_cd", "")
	This.setitem(row, "empname", "")
	This.setitem(row, "descr", "")
	This.setitem(row, "cha", 0)
	This.setitem(row, "dae", 0)
	This.setitem(row, "amount", 0)
	This.setitem(row, "acc_no", "")
	
	If Isnull(Trim(data)) Or Len(Trim(data)) = 0 Then Return
	
	IF F_DateChk(ls_year+Trim(data)) = -1 THEN
		F_MessageChk(21,'[작성월일]')
		This.setitem(row, dwo.name, "")
		Return 1
	END IF

Elseif dwo.name = "bjun_no" Then
	
	This.setitem(row, "jungu", "")
	This.setitem(row, "dept_cd", "")
	This.setitem(row, "empname", "")
	This.setitem(row, "descr", "")
	This.setitem(row, "cha", 0)
	This.setitem(row, "dae", 0)
	This.setitem(row, "amount", 0)
	This.setitem(row, "acc_no", "")
	
	If Isnull(Trim(data)) Or Len(Trim(data)) = 0 Then Return
	
	ls_balmd = Trim(This.getitemstring(row, "bal_mmdd"))
	
	If Isnull(ls_balmd) Or Len(ls_balmd) = 0 Then
		Messagebox("확인", "작성월일을 입력한후 전표번호를 입력하십시오")
		This.setitem(row, "bjun_no", 0)
		This.setcolumn("bal_mmdd")
		Return 1
	End if
	
	If Isnull(data) Or Integer(data) = 0 Then Return
	
	If wf_dup_check(This, row, ls_balmd, Integer(data)) < 0 Then
		Messagebox("확인", "이미 입력한 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	dw_junpyo.reset()
	
	If dw_junpyo.retrieve(ls_saupj, ls_year+ls_balmd, ls_year+ls_balmd, Integer(data), Integer(data), "%") = 0 Then
		Messagebox("확인", "존재하지 않는 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	If dw_junpyo.rowcount() > 1 Then
		Messagebox("확인", "전표번호가 1건 이상입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	IF dw_junpyo.GetItemString(1,"alc_gu") = "Y" AND NOT IsNull(dw_junpyo.GetItemString(1,"alc_gu")) THEN
		Messagebox("확인", "이미 승인처리된 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	This.setitem(row, "jungu", Trim(dw_junpyo.GetItemString(1,"jungu")))
	This.setitem(row, "dept_cd", Trim(dw_junpyo.GetItemString(1,"dept_cd")))
	This.setitem(row, "empname", Trim(dw_junpyo.GetItemString(1,"empname")))
	This.setitem(row, "descr", Trim(dw_junpyo.GetItemString(1,"descr")))
	This.setitem(row, "upmu_gu", Trim(dw_junpyo.GetItemString(1,"upmu_gu")))
	This.setitem(row, "cha", dw_junpyo.GetItemNumber(1,"cha"))
	This.setitem(row, "dae", dw_junpyo.GetItemNumber(1,"dae"))
	
End if
end event

event clicked;//Override

If Row <= 0 then Return

dw_1.reset()

IF Not Isnull(Trim(This.getitemstring(row, "bal_mmdd"))) And Len(Trim(This.GetItemString(Row, "bal_mmdd"))) > 0 And &
	Not IsNull(This.GetItemNumber(Row,"bjun_no")) And This.GetItemNumber(Row,"bjun_no") > 0 THEN
	lstr_jpra.saupjang  = This.GetItemString(Row, "saupj")
	lstr_jpra.baldate   = Trim(dw_cond.getitemstring(dw_cond.getrow(), "year")) + This.GetItemString(Row, "bal_mmdd")
	lstr_jpra.upmugu    = This.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno    = This.GetItemNumber(Row, "bjun_no")

	dw_1.Retrieve( lstr_jpra.saupjang, lstr_jpra.baldate, lstr_jpra.upmugu, lstr_jpra.bjunno )
END IF

This.setrow(row)
end event

type dw_junpyo from datawindow within w_kglc09
boolean visible = false
integer x = 489
integer y = 2492
integer width = 1056
integer height = 108
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "전표조회"
string dataobject = "dw_kglc095"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_1 from u_d_select_sort within w_kglc09
integer x = 73
integer y = 1532
integer width = 4453
integer height = 692
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kglc091_1"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;//Override
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String ls_saupj,ls_year,ls_alcgu,ls_jungu,ls_upmugu,ls_balmd

This.accepttext()

ls_saupj = Trim(This.getitemstring(row, "saupj"))
ls_year = Trim(This.getitemstring(row, "year"))

If dwo.name = "bal_mmdd" Then
	
	This.setitem(row, "bjun_no", 0)
	This.setitem(row, "jungu", "")
	This.setitem(row, "dept_cd", "")
	This.setitem(row, "empname", "")
	This.setitem(row, "descr", "")
	This.setitem(row, "cha", 0)
	This.setitem(row, "dae", 0)
	This.setitem(row, "amount", 0)
	This.setitem(row, "acc_no", "")
	
	If Isnull(Trim(data)) Or Len(Trim(data)) = 0 Then Return
	
	IF F_DateChk(ls_year+Trim(data)) = -1 THEN
		F_MessageChk(21,'[작성월일]')
		This.setitem(row, dwo.name, "")
		Return
	END IF

Elseif dwo.name = "bjun_no" Then
	
	This.setitem(row, "bjun_no", 0)
	This.setitem(row, "jungu", "")
	This.setitem(row, "dept_cd", "")
	This.setitem(row, "empname", "")
	This.setitem(row, "descr", "")
	This.setitem(row, "cha", 0)
	This.setitem(row, "dae", 0)
	This.setitem(row, "amount", 0)
	This.setitem(row, "acc_no", "")
	
	ls_balmd = Trim(This.getitemstring(row, "bal_mmdd"))
	
	If Isnull(ls_balmd) Or Len(ls_balmd) = 0 Then
		Messagebox("확인", "작성월일을 입력한후 전표번호를 입력하십시오")
		This.setitem(row, "bjun_no", 0)
		This.setcolumn("bal_mmdd")
		Return 1
	End if
	
	If Isnull(data) Or Integer(data) = 0 Then Return
	
	If wf_dup_check(This, row, ls_balmd, Integer(data)) < 0 Then
		Messagebox("확인", "이미 입력한 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	dw_junpyo.reset()
	
	If dw_junpyo.retrieve(ls_saupj, ls_year+ls_balmd, ls_year+ls_balmd, Integer(data), Integer(data), "%") = 0 Then
		Messagebox("확인", "존재하지 않는 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	If dw_junpyo.rowcount() > 1 Then
		Messagebox("확인", "전표번호가 1건 이상입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	IF dw_junpyo.GetItemString(1,"alc_gu") = "Y" AND NOT IsNull(dw_junpyo.GetItemString(1,"alc_gu")) THEN
		Messagebox("확인", "이미 승인처리된 전표번호입니다")
		This.setitem(row, "bjun_no", 0)
		Return 1
	End if
	
	dw_2.setitem(row, "jungu", Trim(dw_junpyo.GetItemString(1,"jungu")))
	dw_2.setitem(row, "dept_cd", Trim(dw_junpyo.GetItemString(1,"dept_cd")))
	dw_2.setitem(row, "empname", Trim(dw_junpyo.GetItemString(1,"empname")))
	dw_2.setitem(row, "descr", Trim(dw_junpyo.GetItemString(1,"descr")))
	dw_2.setitem(row, "upmu_gu", Trim(dw_junpyo.GetItemString(1,"upmu_gu")))
	dw_2.setitem(row, "cha", dw_junpyo.GetItemNumber(1,"cha"))
	dw_2.setitem(row, "dae", dw_junpyo.GetItemNumber(1,"dae"))
	
End if	
end event

event itemerror;Return 1
end event

type rr_1 from roundrectangle within w_kglc09
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 268
integer width = 4480
integer height = 1236
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kglc09
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

