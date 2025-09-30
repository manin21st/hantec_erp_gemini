$PBExportHeader$w_kifa32.srw
$PBExportComments$자동전표 관리 : 급여
forward
global type w_kifa32 from w_inherite
end type
type dw_junpoy from datawindow within w_kifa32
end type
type dw_sungin from datawindow within w_kifa32
end type
type dw_list from datawindow within w_kifa32
end type
type dw_print from datawindow within w_kifa32
end type
type dw_ip from u_key_enter within w_kifa32
end type
type dw_insert_fin from datawindow within w_kifa32
end type
type rr_1 from roundrectangle within w_kifa32
end type
end forward

global type w_kifa32 from w_inherite
integer width = 4690
integer height = 3064
string title = "급/상여전표 처리"
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_list dw_list
dw_print dw_print
dw_ip dw_ip
dw_insert_fin dw_insert_fin
rr_1 rr_1
end type
global w_kifa32 w_kifa32

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_kfz12ot0_rt (string ssaupj, string sbaldate, string sdeptcode, string ssawon)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode, string ssawon, string sworkym)
public function integer wf_insert_dae_detail (string ssaupj, string sbaldate, string supmugu, long ljunno, ref long ilinno, string saccd, string sdcgu)
end prototypes

public function integer wf_insert_kfz12ot0_rt (string ssaupj, string sbaldate, string sdeptcode, string ssawon);/******************************************************************************************/
/* 월 퇴직충당금자료를 자동으로 전표 처리한다.															*/
/* 1. 차변 : 퇴직급여(전입액)에 해당하는 계정과목(제조,일반구분).									*/
/* 2. 대변 : 퇴직충당금에 해당하는 계정과목.																*/
/******************************************************************************************/
String   sAcc1,sAcc2,sDcGbn,sSdept,sYesanGbn,sChaDae,sCusGbn,sGbn1,sRemark1,sAccDate,sAlcGbn = 'N'
Integer  k,iCurRow
Long     lJunNo,lAccJunNo,lLinNo
Double   dAmount
		
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="퇴직금 충당금 자동전표 처리 중 ..."

dw_junpoy.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)

lLinNo  = 1
FOR k = 1 TO dw_list.RowCount()
	sSdept  = dw_list.GetItemString(k,"sdept")
	sAcc1   = Left(dw_list.GetItemString(k,"accode"),5)
	sAcc2   = Right(dw_list.GetItemString(k,"accode"),2)
	dAmount = dw_list.GetItemNumber(k,"chai")
	IF IsNull(dAmount) THEN dAmount = 0
	
	sDcGbn  = '1'								/*차변*/
	
	SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1",		"REMARK1"
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
	dw_junpoy.SetItem(iCurRow,"descr",   '퇴직금 충당금 전표')	

	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
	END IF
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	lLinNo = lLinNo + 1
NEXT

sDcGbn = '2'													/* 퇴직충당금 계정*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),		SUBSTR("SYSCNFG"."DATANAME",6,2)
	INTO :sAcc1,										:sAcc2
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' AND "SYSCNFG"."SERIAL" = 27 AND "SYSCNFG"."LINENO" = '2') ;
	
dAmount = dw_list.GetItemNumber(1,"sum_chai")
IF IsNull(dAmount) THEN dAmount = 0
	
SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1"     /*예산통제*/ 
	INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sGbn1	
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
dw_junpoy.SetItem(iCurRow,"descr",   '퇴직충당금')	

//dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
	
IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
	dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
END IF
dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
IF dw_junpoy.RowCount() <=0 THEN 
	Return 1
ELSE
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		Return -1
	ELSE			
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
				Return -1
			END IF	
		END IF
	END IF
	dw_ip.SetItem(1,"junno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
	w_mdi_frame.sle_msg.text ="퇴직충당금 전표 처리 완료!!"
END IF

Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode, string ssawon, string sworkym);/******************************************************************************************/
/* 월 급/상여자료를 자동으로 전표 처리한다.																*/
/* 월 급여자료를 읽어서 원가부문별로 묶어서 처리.												 		*/
/* 1. 차변 : 급여자료 중 지급에 해당하는 계정과목.														*/
/* 2. 대변 : 급여자료 중 공제에 해당하는 계정과목.(고용보험은 -금액으로 차변에 표시)		*/
/****************************************************************************************/
String   sAcc1,sAcc2,sDcGbn,sSdept,sYesanGbn,sChaDae,sCusGbn,sGbn1,sAccDate,sAlcGbn = 'N',	sCashGbn,sFinCode,sCreateGbn,sGbn6
Integer  k,iCurRow,iFunVal
Long     lJunNo,lAccJunNo,lLinNo,iRow
Double   dAmount
		
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="급/상여 자동전표 처리 중 ..."

dw_junpoy.Reset()
dw_insert_fin.Reset()
// 2007.3.7 급여자동전표처리시 급여,상여,특상등 구분값 설정 처리용 //
String sPbtag, sPbname
dw_ip.accepttext()
sPbtag = dw_ip.getitemstring(dw_ip.getrow(),'pbtag')
 SELECT "P0_REF"."CODENM"  
    INTO :sPbName
    FROM "P0_REF"  
   WHERE ( "P0_REF"."CODEGBN" = 'PB' ) AND  
         ( "P0_REF"."CODE" = :sPbtag )   ;

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)

lLinNo  = 1
FOR k = 1 TO dw_list.RowCount()
	sSdept  = dw_list.GetItemString(k,"sdept")
	sAcc1   = Left(dw_list.GetItemString(k,"accode"),5)
	sAcc2   = Right(dw_list.GetItemString(k,"accode"),2)
	dAmount = dw_list.GetItemNumber(k,"amt")
	IF IsNull(dAmount) THEN dAmount = 0
	
	sDcGbn  = dw_list.GetItemString(k,"dc_gu")								/*차변*/
	
	SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1",  	"GBN6"
		INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sGbn1,	:sGbn6	
		FROM "KFZ01OM0"  
		WHERE ("ACC1_CD" = :sAcc1) AND ("ACC2_CD" = :sAcc2);
	
	if sCusGbn = 'Y'  and sGbn6 = 'Y' then
		iFunVal = Wf_Insert_dae_detail(sSaupj, sBalDate, sUpmuGbn, lJunNo, lLinNo, sAcc1+sAcc2, sDcGbn)		
	else
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
//		dw_junpoy.SetItem(iCurRow,"descr",   Left(sWorkYm,4)+'년 '+Mid(sWorkYm,5,2)+'월 급여 지급')	
		dw_junpoy.SetItem(iCurRow,"descr",   Left(sWorkYm,4)+'년 '+Mid(sWorkYm,5,2)+'월 '+ sPbname)	
		
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_list.GetItemString(k,"kwanno"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_list.GetItemString(k,"kwanname"))
		
		dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
			
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1
	end if
NEXT

/* 차액의 처리 : 금액 = 차변금액 - 대변금액, 계정 = '입력한 상대계정', 위치 = 대변*/
sDcGbn = '2'	
sAcc1   = Left(dw_ip.GetItemString(1,"accode"),5)							/*상대계정*/
sAcc2   = Right(dw_ip.GetItemString(1,"accode"),2)
dAmount = dw_list.GetItemNumber(1,"chai")
IF IsNull(dAmount) THEN dAmount = 0
	
SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"GBN1",		"CASHGBN"
	INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sGbn1,		:sCashGbn	
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
dw_junpoy.SetItem(iCurRow,"descr",   '미지급 급여')	

IF sCusGbn = 'Y' THEN
	IF sGbn1 = '5' THEN						/*예적금*/
		dw_junpoy.SetItem(iCurRow,"saup_no",dw_ip.GetItemString(1,"dptno"))
		dw_junpoy.SetItem(iCurRow,"in_nm",  dw_ip.GetItemString(1,"dptname"))
	ELSE
		dw_junpoy.SetItem(iCurRow,"saup_no",sSawon)
	END IF
END IF
//dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
	
IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
	dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
END IF

IF sCashGbn = 'Y' THEN															/*현금유관계정의 자금수지 자료 생성. 2001.06.21*/
	select nvl(substr(dataname,1,1),'0')	into :sCreateGbn									/*전표에서 자금 자료 생성 여부*/
		from syscnfg 
		where sysgu = 'A' and serial = 30 and lineno = '1';					
	if sCreateGbn = '1' then
		select nvl(substr(dataname,1,5),'0')	into :sFinCode										/*현금유관계정-자금코드*/
			from syscnfg 
			where sysgu = 'A' and serial = 30 and lineno = 'A';					
		
		iRow = dw_insert_fin.InsertRow(0)
		
		dw_insert_fin.SetItem(iRow,"saupj",     	sSaupj)
		dw_insert_fin.SetItem(iRow,"bal_date",  	sBalDate)
		dw_insert_fin.SetItem(iRow,"upmu_gu",   	sUpmuGbn)
		dw_insert_fin.SetItem(iRow,"bjun_no",  	lJunNo)
		dw_insert_fin.SetItem(iRow,"lin_no",  	  	lLinNo)
		dw_insert_fin.SetItem(iRow,"finance_cd",  sFinCode)
		dw_insert_fin.SetItem(iRow,"amount",  		dAmount)
	end if
END IF
dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
IF dw_junpoy.RowCount() <=0 THEN 
	Return 1
ELSE
	IF dw_insert_fin.Update() <> 1 THEN
		F_MessageChk(13,'[자금수지상세]')
		SetPointer(Arrow!)
		Return -1
	END IF
		
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		Return -1
	ELSE				
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
				Return -1
			END IF	
		END IF
	END IF
	dw_ip.SetItem(1,"junno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
	w_mdi_frame.sle_msg.text ="급/상여 전표 처리 완료!!"
END IF

Return 1
end function

public function integer wf_insert_dae_detail (string ssaupj, string sbaldate, string supmugu, long ljunno, ref long ilinno, string saccd, string sdcgu);/******************************************************************************************/
/*  단기 대여금 계정은 사원별로 상세 전표를 만든다*/
/****************************************************************************************/
DataStore  Idw_Empno
String        sInsaSaupj,sWorkYm,sPbTag,sEmpNo,sEmpNm
Integer      iRowCount,i, iCurRow
Double      dAmount

dw_ip.AcceptText()
sInSaSaupj = dw_ip.GetItemString(1,"insasaup")
sWorkYm    = Trim(dw_ip.GetItemString(1,"yearmonf"))
sPbTag       = dw_ip.GetItemString(1,"pbtag")

Idw_Empno    = Create DataStore

Idw_Empno.DataObject = 'd_kifa325'
Idw_Empno.SetTransObject(Sqlca)
Idw_Empno.Reset()

IF Idw_Empno.Retrieve(sInSaSaupj, sWorkYm, sPbTag, sAccd) > 0 THEN
	iRowCount = Idw_Empno.RowCount()
	
	For i = 1 TO iRowCount
		sEmpNo  = Idw_Empno.GetItemString(i, "empno")
		sEmpNm = Idw_Empno.GetItemString(i,"empnm")
		
		dAmount = Idw_Empno.GetItemNumber(i,"amount")
		if IsNull(dAmount) then dAmount = 0
		
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",      sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date", sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGu)
		dw_junpoy.SetItem(iCurRow,"bjun_no",  lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",     iLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", dw_ip.GetItemString(1,"dept_cd"))	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAccd,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(sAccd,6,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   dw_ip.GetItemString(1,"sawon"))
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcgu)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
		dw_junpoy.SetItem(iCurRow,"descr",   Left(sWorkYm,4)+'년 '+Mid(sWorkYm,5,2)+'월 대여금 공제')	
		
		dw_junpoy.SetItem(iCurRow,"saup_no", sEmpNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",    sEmpNm)
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		iLinNo = iLinNo + 1
	NEXT
END IF

Destroy Idw_Empno

return iCurRow

end function

on w_kifa32.create
int iCurrent
call super::create
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_list=create dw_list
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_insert_fin=create dw_insert_fin
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_junpoy
this.Control[iCurrent+2]=this.dw_sungin
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_ip
this.Control[iCurrent+6]=this.dw_insert_fin
this.Control[iCurrent+7]=this.rr_1
end on

on w_kifa32.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_list)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_insert_fin)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(1,"yearmonf",   Left(F_Today(),6))
//dw_ip.SetItem(1,"yearmont", Left(F_Today(),6))

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_insert_fin.SetTransObject(SQLCA)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '21' ) ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

p_mod.Enabled = False

dw_ip.SetColumn("insasaup")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa32
boolean visible = false
integer x = 2171
integer y = 2816
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa32
boolean visible = false
integer x = 2235
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa32
boolean visible = false
integer x = 2062
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa32
integer x = 3790
integer width = 306
integer taborder = 50
string pointer = "c:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\급여항목별계정등록_up.gif"
end type

event p_search::clicked;call super::clicked;Open(w_kifa32a)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\급여항목별계정등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\급여항목별계정등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa32
boolean visible = false
integer x = 1888
integer taborder = 0
string pointer = "C:\erpman\cur\new.cur"
end type

type p_exit from w_inherite`p_exit within w_kifa32
integer taborder = 40
end type

type p_can from w_inherite`p_can within w_kifa32
boolean visible = false
integer x = 2757
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa32
boolean visible = false
integer x = 1541
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn ='0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF dw_junpoy.RowCount() <=0 THEN Return

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

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

type p_inq from w_inherite`p_inq within w_kifa32
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sInsaSaupj,sWorkYm,sPbTag

dw_ip.AcceptText()
sInSaSaupj = dw_ip.GetItemString(1,"insasaup")
sWorkYm    = Trim(dw_ip.GetItemString(1,"yearmonf"))
sPbTag     = dw_ip.GetItemString(1,"pbtag")

IF sInSaSaupj = "" OR IsNull(sInSaSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("insasaup")
	dw_ip.SetFocus()
	Return 
END IF
IF sWorkYm = "" OR IsNull(sWorkYm) THEN
	F_MessageChk(1,'[대상년월]')	
	dw_ip.SetColumn("yearmonf")
	dw_ip.SetFocus()
	Return 
END IF

IF sPbTag = 'R' THEN						/*퇴직충당금*/
	dw_list.DataObject = 'd_kifa323'
	dw_list.SetTransObject(Sqlca)
	IF dw_list.Retrieve(sInSaSaupj,sWorkYm) <=0 THEN
		F_MessageChk(14,'')
		Return
	END IF
ELSE
	dw_list.DataObject = 'd_kifa322'
	dw_list.SetTransObject(Sqlca)
	IF dw_list.Retrieve(sInSaSaupj,sWorkYm,sPbTag) <=0 THEN
		F_MessageChk(14,'')
		Return
	END IF	
END IF

p_mod.Enabled = True

end event

type p_del from w_inherite`p_del within w_kifa32
boolean visible = false
integer x = 2583
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa32
integer x = 4270
integer taborder = 30
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;String sInsaSaupj,sSaupj,sWorkYm,sPbTag,sDept,sSawon,sBalDate

dw_ip.AcceptText()
sInSaSaupj = dw_ip.GetItemString(1,"insasaup")
sWorkYm    = Trim(dw_ip.GetItemString(1,"yearmonf"))
sPbTag     = dw_ip.GetItemString(1,"pbtag")
sDept    = dw_ip.GetItemString(1,"dept_cd")
sSaupj   = dw_ip.GetItemString(1,"saupj")
sSawon   = dw_ip.GetItemString(1,"sawon") 
sBalDate = Trim(dw_ip.GetItemString(1,"baldate"))

IF sInSaSaupj = "" OR IsNull(sInSaSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("insasaup")
	dw_ip.SetFocus()
	Return 
END IF
IF sWorkYm = "" OR IsNull(sWorkYm) THEN
	F_MessageChk(1,'[대상년월]')	
	dw_ip.SetColumn("yearmonf")
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
	F_MessageChk(1,'[사업장]')	
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

IF sPbTag = 'R' THEN						/*퇴직충당금*/
//	dw_list.DataObject = 'd_kifa323'
//	dw_list.SetTransObject(Sqlca)
//	IF dw_list.Retrieve(sSaupj,sWorkYm) <=0 THEN
//		F_MessageChk(14,'')
//		Return
//	END IF
	IF Wf_Insert_Kfz12ot0_Rt(sSaupj,sBalDate,sDept,sSawon) = -1 THEN
		Rollback;
		Return
	END IF	
ELSE
//	dw_list.DataObject = 'd_kifa322'
//	dw_list.SetTransObject(Sqlca)
//	IF dw_list.Retrieve(sSaupj,sWorkYm,sPbTag) <=0 THEN
//		F_MessageChk(14,'')
//		Return
//	END IF	
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate,sDept,sSawon,sWorkYm) = -1 THEN
		Rollback;
		Return
	END IF
END IF
Commit;
	
p_print.TriggerEvent(Clicked!)

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa32
integer x = 3127
end type

type cb_mod from w_inherite`cb_mod within w_kifa32
integer x = 2779
integer y = 2784
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa32
integer x = 3136
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa32
integer x = 2395
integer y = 2788
end type

type cb_inq from w_inherite`cb_inq within w_kifa32
integer x = 2939
integer y = 2420
end type

type cb_print from w_inherite`cb_print within w_kifa32
integer x = 3282
integer y = 2416
end type

type st_1 from w_inherite`st_1 within w_kifa32
end type

type cb_can from w_inherite`cb_can within w_kifa32
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kifa32
integer x = 3515
integer y = 44
integer width = 142
string text = "급여항목별 계정 등록(&I)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa32
integer x = 110
integer y = 2728
integer width = 974
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa32
integer x = 2725
integer y = 2728
integer width = 768
end type

type dw_junpoy from datawindow within w_kifa32
boolean visible = false
integer x = 64
integer y = 2728
integer width = 1029
integer height = 112
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

type dw_sungin from datawindow within w_kifa32
boolean visible = false
integer x = 64
integer y = 2836
integer width = 1029
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

type dw_list from datawindow within w_kifa32
integer x = 2304
integer y = 188
integer width = 2286
integer height = 2104
boolean bringtotop = true
string title = "전표처리대상"
string dataobject = "d_kifa322"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa32
boolean visible = false
integer x = 1097
integer y = 2720
integer width = 1029
integer height = 100
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

type dw_ip from u_key_enter within w_kifa32
event ue_key pbm_dwnkey
integer x = 32
integer y = 164
integer width = 2249
integer height = 1564
integer taborder = 10
string dataobject = "d_kifa321"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,sAcCode,sBalGbn,sYearMonth,sSaupj,sDate,sDeptCode,sDeptNm,sSawon,sSawonNm,&
		  sGbn1,sDptNo,sDptName,sAccName
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
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	sDeptNm = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptNm) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(this.GetRow(),"dept_cd",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"deptname",sDeptNm)
		
		SELECT "P0_DEPT"."ESTABLISHMENTCODE"      INTO :sSaupj  
			FROM "P0_DEPT"  
   		WHERE "P0_DEPT"."DEPTCODE" = :sDeptCode ;
			
		this.SetItem(this.GetRow(),"saupj",sSaupj)
	END IF
END IF

IF this.GetColumnName() ="sawon" THEN
	sSawon = this.GetText()
	IF sSawon = "" OR IsNull(sSawon) THEN Return
	
	sSawonNm = F_Get_PersonLst('4',sSawon,'1')
	IF IsNull(sSawonNm) THEN
		F_MessageChk(20,'[작성자]')
		this.SetItem(this.GetRow(),"sawon",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"sawonname",sSawonNm)
	END IF
END IF

IF this.GetColumnName() = "accode" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "BAL_GU", "GBN1", "ACC2_NM"	INTO :sBalGbn,	:sGbn1,	:sAccName
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode", snull)
			this.Setitem(this.getrow(),"accname",snull)
			Return 1
		END IF
		IF sGbn1 = '5' THEN
			this.Modify("dptno.protect = 0")
//			this.Modify("dptno.background.color =65535'")
		ELSE
			this.Modify("dptno.protect = 1")
//			this.Modify("dptno.background.color ='"+String(RGB(192,192,192))+"'")
		END IF
		this.Setitem(this.getrow(),"accname",sAccName)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode", snull)
		this.Setitem(this.getrow(),"accname",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() ="dptno" THEN
	sDptNo = this.GetText()
	IF sDptNo = "" OR IsNull(sDptNo) THEN 
		this.SetItem(1,"dptname",snull)
		Return
	END IF
	
	SELECT "KFM04OT0"."AB_NAME"  INTO :sDptName  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sDptNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"출금계좌")
		this.SetItem(1,"dptno",snull)
		this.SetItem(1,"dptname",snull)
		Return 1
	ELSE
		this.SetItem(1,"dptname",sDptName)
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="dept_cd" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"dept_cd", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname",lstr_custom.name)
	
	this.TriggerEvent(ItemChanged!)
	
END IF

IF this.GetColumnName() ="sawon" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"sawonname",lstr_custom.name)
	
END IF

IF this.GetColumnName() = "accode" THEN
	SetNull(lstr_account.acc1_cd);	SetNull(lstr_account.acc2_cd);
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN Return
	
	this.SetItem(this.GetRow(),"accode",lstr_account.acc1_cd+lstr_account.acc2_cd)
	this.TriggerEvent(ItemChanged!)
END IF	

IF this.GetColumnName() ="dptno" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	this.SetItem(this.GetRow(),"dptno",		lstr_custom.code)
	this.SetItem(this.GetRow(),"dptname",  lstr_custom.name)
	
END IF


end event

event getfocus;this.AcceptText()
end event

type dw_insert_fin from datawindow within w_kifa32
boolean visible = false
integer x = 1093
integer y = 2816
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "자금수지내역 저장"
string dataobject = "d_kifa324"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa32
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2290
integer y = 180
integer width = 2313
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

