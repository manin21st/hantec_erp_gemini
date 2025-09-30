$PBExportHeader$w_kifa31.srw
$PBExportComments$자동전표 관리 : 감가상각비
forward
global type w_kifa31 from w_inherite
end type
type dw_junpoy from datawindow within w_kifa31
end type
type dw_sungin from datawindow within w_kifa31
end type
type dw_list_cha from datawindow within w_kifa31
end type
type dw_print from datawindow within w_kifa31
end type
type dw_ip from u_key_enter within w_kifa31
end type
type dw_list_dae from datawindow within w_kifa31
end type
end forward

global type w_kifa31 from w_inherite
string title = "감가상각비전표 처리"
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_list_cha dw_list_cha
dw_print dw_print
dw_ip dw_ip
dw_list_dae dw_list_dae
end type
global w_kifa31 w_kifa31

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

forward prototypes
public subroutine wf_baebu (string sfrom, string sto, string saupj)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode, string ssawon, string scostcd)
end prototypes

public subroutine wf_baebu (string sfrom, string sto, string saupj);//Integer    iRowCount,iLoopCnt,k,i
//DataStore  Ids_Baebu
//Double     dAmount,dBabuAmount = 0,dTmpAmount =0,dCurAmt,dTotalCha
//
//iRowCount = dw_list_cha.RowCount()
//IF iRowCount <=0 THEN Return
//
//Ids_Baebu = Create DataStore
//Ids_Baebu.DataObject = "d_kifa314"
//Ids_Baebu.SetTransObject(Sqlca)
//
//IF Ids_Baebu.Retrieve(sfrom,sto,saupj) <=0 THEN Return
//iLoopCnt = Ids_Baebu.RowCount()
//
//FOR k = 1 TO iLoopCnt
//	dAmount = Ids_Baebu.GetItemNumber(k,"amt")
//	IF Isnull(dAmount) OR dAmount = 0 THEN Continue
//	
//	dTmpAmount = dAmount
//	FOR i = 1 TO iRowCount
//		dTotalCha = dw_list_cha.GetItemNumber(i,"total_cha") 
//		dCurAmt   = dw_list_cha.GetItemNumber(i,"samt")
//		IF IsNull(dTotalCha) THEN dTotalCha = 0
//		IF IsNull(dCurAmt) THEN dCurAmt = 0
//		
//		dBabuAmount = Round((dCurAmt / dTotalCha) * dAmount,0)
//		
//		IF i = iRowcount THEN							/*마지막이면*/
//			dw_list_cha.SetItem(i,"samt",dCurAmt + dTmpAmount)	
//		ELSE
//			dw_list_cha.SetItem(i,"samt",dCurAmt + dBabuAmount)	
//			dTmpAmount = dTmpAmount - dBabuAmount
//		END IF
//	NEXT
//	dTmpAmount = 0
//NEXT
//
//
//
//
//
//
end subroutine

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode, string ssawon, string scostcd);/******************************************************************************************/
/* 월 감가상각 자료를 자동으로 전표 처리한다.															*/
/* 월별감가상각이력을 읽어서 원가부문별 계정별로 상각비를 합산하여 전표로 분개한다. 		*/
/* 1. 차변 : 월별감가상각이력의 제조일반구분의 값으로 참조코드 'F2'에 있는 참조명(S)의 값 */
/* 2. 대변 : 월별감가상각이력의 고정자산구분의 값으로 참조코드 'F1'에 있는 참조명(S)의 값 */
/******************************************************************************************/
String   sAcc1,sAcc2,sDcGbn,sSdept,sYesanGbn,sChaDae,sCusGbn,sGbn1,sRemark1,sAccDate,sAlcGbn = 'N'
Integer  k,iCurRow
Long     lJunNo,lAccJunNo,lLinNo
Double   dAmount
		
sle_msg.text =""

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(28,'[발행일자]')
	Return -1
END IF

sle_msg.text ="감가상각비 자동전표 처리 중 ..."

dw_junpoy.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B', sSaupj, sUpmuGbn, sBalDate)

lLinNo  = 1

sDcGbn = '1'					/*차변*/

FOR k = 1 TO dw_list_cha.RowCount()
	
	sSdept  = dw_list_cha.GetItemString(k,"costcd")
	sAcc1   = Left(dw_list_cha.GetItemString(k,"cha_acc"),5)
	sAcc2   = Right(dw_list_cha.GetItemString(k,"cha_acc"),2)
	dAmount = dw_list_cha.GetItemNumber(k,"samt")
	
	IF IsNull(dAmount) THEN dAmount = 0
	
	 SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1",   	"REMARK1"     /*예산통제*/ 
		INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
		FROM "KFZ01OM0"  
		WHERE ("ACC1_CD" = :sAcc1) AND ("ACC2_CD" = :sAcc2);
				
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2)
	dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '감가상각비 전표')	
			
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
	END IF
	
	IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
	END IF
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	lLinNo = lLinNo + 1

NEXT
	
sDcGbn = '2'				/*대변*/

FOR k = 1 TO dw_list_dae.RowCount()
	sSdept  = dw_list_dae.GetItemString(k,"costcd")
	sAcc1   = Left(dw_list_dae.GetItemString(k,"acc_dae"),5)
	sAcc2   = Right(dw_list_dae.GetItemString(k,"acc_dae"),2)
		
	dAmount = dw_list_dae.GetItemNumber(k,"samt")
	IF IsNull(dAmount) THEN dAmount = 0
	
	SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1",		"REMARK1"     /*예산통제*/ 
		INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
		FROM "KFZ01OM0"  
		WHERE ("ACC1_CD" = :sAcc1) AND ("ACC2_CD" = :sAcc2);
				
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2)
	dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '감가상각비 전표')	
			
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
	END IF
	
	IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
	END IF
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	lLinNo = lLinNo + 1

NEXT

IF dw_junpoy.RowCount() <= 0 THEN 
	Return 1
ELSE
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		sle_msg.text ="감가상각비 자동전표 처리 중 에러 발생"
		Return -1
	ELSE
		Commit;
		
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
//				Return -1
			END IF	
		END IF
	END IF
	
	dw_ip.SetItem(1,"junno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
	sle_msg.text ="감가상각비 전표 처리 완료!!"
END IF

Return 1
end function

on w_kifa31.create
int iCurrent
call super::create
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_list_cha=create dw_list_cha
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_list_dae=create dw_list_dae
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_junpoy
this.Control[iCurrent+2]=this.dw_sungin
this.Control[iCurrent+3]=this.dw_list_cha
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_ip
this.Control[iCurrent+6]=this.dw_list_dae
end on

on w_kifa31.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_list_cha)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_list_dae)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1,"yearmonf", Left(F_Today(),6))
dw_ip.SetItem(1,"yearmont", Left(F_Today(),6))

dw_list_cha.SetTransObject(SQLCA)
dw_list_dae.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '20' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("yearmonf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa31
boolean visible = false
integer x = 87
integer y = 2636
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa31
boolean visible = false
integer x = 2226
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa31
boolean visible = false
integer x = 2053
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa31
boolean visible = false
integer x = 1358
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kifa31
boolean visible = false
integer x = 1879
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa31
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kifa31
boolean visible = false
integer x = 2747
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa31
boolean visible = false
integer x = 1531
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn ='0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF dw_junpoy.RowCount() <=0 THEN Return

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

sSaupj   = dw_junpoy.GetItemString(1,"saupj")
sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
sUpmuGu  = dw_junpoy.GetItemString(1,"upmu_gu") 
lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 

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
end event

type p_inq from w_inherite`p_inq within w_kifa31
boolean visible = false
integer x = 1705
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kifa31
boolean visible = false
integer x = 2574
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa31
integer x = 4270
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sFrom, sTo, sDept, sSawon, sBalDate, sSaupj, sCostgbn, sCostcd

If dw_ip.AcceptText() = -1 then Return

sFrom    = Trim(dw_ip.GetItemString(1,"yearmonf"))		//대상년월(from)
sTo      = Trim(dw_ip.GetItemString(1,"yearmont"))		//대상년월(to)
sDept    = dw_ip.GetItemString(1,"dept_cd")				//부서
sSaupj   = dw_ip.GetItemString(1,"saupj")					//사업장
sSawon   = dw_ip.GetItemString(1,"sawon") 				//사원
sBalDate = Trim(dw_ip.GetItemString(1,"baldate"))		//전표작성 일자
sCostgbn = dw_ip.GetItemString(1, 'cost_gbn')			//원가부문 체트여부
sCostcd  = dw_ip.GetItemString(1, 'cost_cd')				//원가부문

IF sFrom = "" OR IsNull(sFrom) THEN
	F_MessageChk(1,'[대상년월]')	
	dw_ip.SetColumn("yearmonf")
	dw_ip.SetFocus()
	Return 
END IF
IF sTo = "" OR IsNull(sTo) THEN
	F_MessageChk(1,'[대상년월]')	
	dw_ip.SetColumn("yearmont")
	dw_ip.SetFocus()
	Return 
END IF

IF sDept = "" OR IsNull(sDept) THEN
	F_MessageChk(1,'[작성부서]')	
	dw_ip.SetColumn("dept_cd")
	dw_ip.SetFocus()
	Return 
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[회계단위]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sSawon = "" OR IsNull(sSawon) THEN
	F_MessageChk(1,'[작성자]')	
	dw_ip.SetColumn("sawon")
	dw_ip.SetFocus()
	Return 
END IF

IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[작성일자]')	
	dw_ip.SetColumn("baldate")
	dw_ip.SetFocus()
	Return 
END IF

IF sCostgbn = '1' then
	sCostcd = '%'
End IF

IF dw_list_cha.Retrieve(sFrom,sTo,sSaupj,sCostcd) <= 0 OR dw_list_dae.Retrieve(sFrom,sTo,sSaupj,sCostcd) <= 0 THEN
	F_MessageChk(14,'')
	Return
END IF

/*공통 배부처리*/
//Wf_BaeBu(sFrom,sTo,sSaupj)

/* 미승인전표자료를 생성하여, DW_JUNPYO에 데이터를 삽입시킨다 */
IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate,sDept,sSawon,sCostcd) = -1 THEN
	Rollback;
	Return
END IF
Commit;
	
cb_print.TriggerEvent(Clicked!)

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa31
boolean visible = false
integer x = 4073
integer y = 2980
end type

type cb_mod from w_inherite`cb_mod within w_kifa31
boolean visible = false
integer x = 3726
integer y = 2980
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa31
boolean visible = false
integer x = 3136
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa31
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kifa31
boolean visible = false
integer x = 2661
integer y = 2764
end type

type cb_print from w_inherite`cb_print within w_kifa31
boolean visible = false
integer x = 3003
integer y = 2760
end type

type st_1 from w_inherite`st_1 within w_kifa31
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa31
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kifa31
boolean visible = false
integer x = 2043
integer y = 2776
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa31
boolean visible = false
integer x = 2857
end type

type sle_msg from w_inherite`sle_msg within w_kifa31
boolean visible = false
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_kifa31
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa31
boolean visible = false
integer x = 1966
integer y = 2536
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa31
boolean visible = false
integer x = 3675
integer y = 2924
integer width = 768
end type

type dw_junpoy from datawindow within w_kifa31
boolean visible = false
integer x = 1102
integer y = 2392
integer width = 1029
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

event dberror;//MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
return 1
end event

event itemerror;Return 1
end event

type dw_sungin from datawindow within w_kifa31
boolean visible = false
integer x = 1102
integer y = 2296
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

type dw_list_cha from datawindow within w_kifa31
boolean visible = false
integer x = 69
integer y = 2296
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "전표처리대상-차변"
string dataobject = "d_kifa312"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa31
boolean visible = false
integer x = 59
integer y = 2500
integer width = 1029
integer height = 92
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

type dw_ip from u_key_enter within w_kifa31
event ue_key pbm_dwnkey
integer x = 549
integer y = 252
integer width = 3026
integer height = 1628
integer taborder = 10
string dataobject = "d_kifa311"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,sYearMonth,sSaupj,sDate,sDeptCode,sDeptNm,sSawon,sSawonNm
Integer i

SetNull(snull)

IF this.GetColumnName() ="yearmonf" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth ="" OR IsNull(sYearMonth) THEN RETURN 
	
	IF f_datechk(sYearMonth+'01') = -1 THEN
		f_messagechk(20,"대상년월")
		dw_ip.SetItem(1,"yearmonf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="yearmont" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth ="" OR IsNull(sYearMonth) THEN RETURN 
	
	IF f_datechk(sYearMonth+'01') = -1 THEN
		f_messagechk(20,"대상년월")
		dw_ip.SetItem(1,"yearmont",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"전표작성일자")
		dw_ip.SetItem(1,"baldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN 
		this.Setitem(this.Getrow(), 'deptname', snull)
		this.Setitem(this.Getrow(), 'saupj', snull)
		Return 
	End If
	
	sDeptNm = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptNm) THEN
//		F_MessageChk(20,'[작성부서]')
		this.SetItem(this.GetRow(),"dept_cd",snull)
		this.SetItem(this.GetRow(),"deptname",snull)
		Return 
	ELSE
		this.SetItem(this.GetRow(),"deptname",sDeptNm)
		
		SELECT "P0_DEPT"."SAUPCD"      INTO :sSaupj  
			FROM "P0_DEPT"  
   		WHERE "P0_DEPT"."DEPTCODE" = :sDeptCode ;
		
		If sqlca.sqlcode = 0 then
			this.Setitem(1,'saupj',ssaupj)
		End If
		
	END IF
END IF

IF this.GetColumnName() ="sawon" THEN
	sSawon = this.GetText()
	IF sSawon = "" OR IsNull(sSawon) THEN 
		this.SetItem(this.GetRow(),"sawonname",snull)
		Return
	END IF
	
	sSawonNm = F_Get_PersonLst('4',sSawon,'1')
	IF IsNull(sSawonNm) THEN
//		F_MessageChk(20,'[작성자]')
		this.SetItem(this.GetRow(),"sawon",snull)
		this.SetItem(this.GetRow(),"sawonname",snull)
		Return 
	ELSE
		this.SetItem(this.GetRow(),"sawonname",sSawonNm)
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="dept_cd" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "dept_cd")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"dept_cd", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname",lstr_custom.name)
	
//	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() ="sawon" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "sawon")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"sawonname",lstr_custom.name)
	
END IF
end event

event getfocus;this.AcceptText()
end event

type dw_list_dae from datawindow within w_kifa31
boolean visible = false
integer x = 64
integer y = 2392
integer width = 1029
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표처리대상-대변"
string dataobject = "d_kifa313"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

