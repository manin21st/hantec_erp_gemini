$PBExportHeader$w_kifa80.srw
$PBExportComments$자동전표 관리 : 고정자산
forward
global type w_kifa80 from w_inherite
end type
type dw_junpoy from datawindow within w_kifa80
end type
type dw_sungin from datawindow within w_kifa80
end type
type dw_list_cha from datawindow within w_kifa80
end type
type dw_print from datawindow within w_kifa80
end type
type dw_ip from u_key_enter within w_kifa80
end type
type dw_list_dae from datawindow within w_kifa80
end type
type dw_list_chg from datawindow within w_kifa80
end type
end forward

global type w_kifa80 from w_inherite
string title = "고정자산 전표 처리"
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_list_cha dw_list_cha
dw_print dw_print
dw_ip dw_ip
dw_list_dae dw_list_dae
dw_list_chg dw_list_chg
end type
global w_kifa80 w_kifa80

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode, string ssawon, string scostcd)
public subroutine wf_baebu (string sfrom, string sto, string saupj)
public function integer wf_insert_kfz12ot0_chg (string ssaupj, string sjbaldate, string sdeptcode, string ssawon, string scostcd, string saccode)
end prototypes

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
		
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(28,'[발행일자]')
	Return -1
END IF

w_mdi_frame.sle_msg.text ="감가상각비 자동전표 처리 중 ..."

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
		w_mdi_frame.sle_msg.text ="감가상각비 자동전표 처리 중 에러 발생"
		Return -1
	ELSE
		Commit;
		
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
//				Return -1
			END IF	
		END IF
	END IF
	
	dw_ip.SetItem(1,"junno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
	w_mdi_frame.sle_msg.text ="감가상각비 전표 처리 완료!!"
END IF

Return 1
end function

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

public function integer wf_insert_kfz12ot0_chg (string ssaupj, string sjbaldate, string sdeptcode, string ssawon, string scostcd, string saccode);/******************************************************************************************/
/* 월변동이력 중 매각/폐기분을 읽어서 자동으로 전표 처리한다.										*/
/* 1. 차변 : 처리대상 자산의 상각누계액 																	*/
/*           처리대상 자산의 처분시 발생한 이익의 처리계정											*/
/*           처리대상 자산의 처분 시 부가세(예수부가세)												*/ 
/*           (유형자산처분손실)																				*/
/* 2. 대변 : 처리대상 자산의 계정																			*/
/*           (유형자산처분이익)																				*/
/******************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sSdept,sYesanGbn,sChaDae,sCusGbn,sGbn1,sRemark1,&
			sAccDate,sAlcGbn = 'N',sChGbn,sDescr,sBalDate
Integer  k,iCurRow
Long     lJunNo,lAccJunNo,lLinNo
Double   dSellAmt, dIkSonAmt, dKfDeAmt, dRptAmt,dVatAmt,dMisuAmt
		
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.text ="고정자산처분내역 전표 처리 중 ..."

FOR k = 1 TO dw_list_chg.RowCount()
	sChGbn     = dw_list_chg.GetItemString(k,"kfa03ot0_kfchgb")
	sBalDate   = dw_list_chg.GetItemString(k,"kfacdat")
	sSdept     = dw_list_chg.GetItemString(k,"costcd")
	
	IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
		F_MessageChk(29,'[발행일자]')
		Return -1
	END IF

	/*전표번호 채번*/
	lJunNo = Sqlca.Fun_Calc_JunNo('B', sSaupj, sUpmuGbn, sBalDate)
	lLinNo  = 1
	
	dw_junpoy.Reset()

	dRptAmt    = dw_list_chg.GetItemNumber(k,"kfa03ot0_kfcamt")				/*처분자산가액*/
	dIkSonAmt  = dw_list_chg.GetItemNumber(k,"ikson")							/*처분손익*/
	dKfDeamt	  = dw_list_chg.GetItemNumber(k,"kfa03ot0_kfrde03")			/*충당금누계액*/ 
	dMisuAmt   = dw_list_chg.GetItemNumber(k,"kfa03ot0_kfdamt")				/*처분가액*/
	
	IF IsNull(dRptAmt) THEN dRptAmt = 0
	IF IsNull(dIkSonAmt) THEN dIkSonAmt = 0
	IF IsNull(dKfDeamt) THEN  dKfDeamt = 0
	IF IsNull(dMisuAmt) THEN  dMisuAmt = 0
	
	if sChGbn = 'F' or sChGbn = 'H' then
		sDescr = ' 매각 시 '
	else
		sDescr = ' 폐기 시 '
	end if
	
//	dMisuAmt = dRptAmt + dIkSonAmt - dKfDeAmt
//	
//	if dMisuAmt < 0 then
//		dMisuAmt = 0
//	end if
	
	sDcGbn = '1'																/*차변*/
	
	if dMisuAmt > 0 then														/*상대계정*/
		sAcc1_Cha  = Left(sAcCode,5)
		sAcc2_Cha  = Right(sAcCode,2)
		
		select dc_gu,		yesan_gu,		cus_gu,			gbn1,			remark1
			into :sChaDae,	:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
			from kfz01om0
			where acc1_cd = :sAcc1_Cha and acc2_cd = :sAcc2_Cha;
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dMisuAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + sDescr + '미수금')	
		
		if sCusGbn = 'Y' then
			if sGbn1 = '95' then
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
			else
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list_chg.GetItemString(k,"kfcust"))
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_list_chg.GetItemString(k,"kfcustname"))
			end if
		end if
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		
		IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1
	end if
	 
	if dKfDeamt > 0 then												/*상각누계액*/
		sAcc1_Cha  = dw_list_chg.GetItemString(k,"sangnu_acc1")
		sAcc2_Cha  = dw_list_chg.GetItemString(k,"sangnu_acc2")
		
		select dc_gu,		yesan_gu,		cus_gu,			gbn1,			remark1
			into :sChaDae,	:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
			from kfz01om0
			where acc1_cd = :sAcc1_Cha and acc2_cd = :sAcc2_Cha;
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dKfDeAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + sDescr + '상각누계액 대체')	
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		
		IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1	
	end if
	
	if dIkSonAmt < 0 then												/*유형처분손실(A-1-87 뒤7자리)*/
		select acc1_cd,		acc2_cd,		dc_gu,		yesan_gu,		cus_gu,			gbn1,			remark1
			into :sAcc1_Cha,  :sAcc2_Cha, :sChaDae,	:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
			from kfz01om0
			where acc1_cd||acc2_cd = (select substr(dataname,8,7) from syscnfg where sysgu = 'A' and serial = 1 and lineno = '87');
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     Abs(dIkSonAmt))
		dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + sDescr + '처분손실')	
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		
		IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1		
	end if
	
	sDcGbn = '2'																/*대변*/
	if dRptAmt > 0 then														/*처분자산가액*/
		sAcc1_Dae  = dw_list_chg.GetItemString(k,"jasan_acc1")
		sAcc2_Dae  = dw_list_chg.GetItemString(k,"jasan_acc2")
		
		select dc_gu,		yesan_gu,		cus_gu,			gbn1,			remark1
			into :sChaDae,	:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
			from kfz01om0
			where acc1_cd = :sAcc1_Dae and acc2_cd = :sAcc2_Dae;
			
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dRptAmt)
		
		if sChGbn = 'F' or sChGbn = 'H' then			/*매각*/
			dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + ' '+ dw_list_chg.GetItemString(k,"kfcustname")+'에 매각')	
		else
			dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + ' 폐기처분')	
		end if
		
		if sCusGbn = 'Y' then
			if sGbn1 = '95' then
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
			else
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_list_chg.GetItemString(k,"kfcust"))
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_list_chg.GetItemString(k,"kfcustname"))
			end if
		end if
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		
		IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1		
	end if

	if dIkSonAmt > 0 then												/*유형처분이익(A-1-87 앞7자리)*/
		select acc1_cd,		acc2_cd,		dc_gu,		yesan_gu,		cus_gu,			gbn1,			remark1
			into :sAcc1_Dae,  :sAcc2_Dae, :sChaDae,	:sYesanGbn,		:sCusGbn,		:sGbn1,		:sRemark1	
			from kfz01om0
			where acc1_cd||acc2_cd = (select substr(dataname,1,7) from syscnfg where sysgu = 'A' and serial = 1 and lineno = '87');
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
		dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dIkSonAmt)
		dw_junpoy.SetItem(iCurRow,"descr",   dw_list_chg.GetItemString(k,"kfa02om0_kfname") + sDescr + '처분이익')	
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
		END IF
		
		IF sRemark1 = 'Y'  and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		END IF
		dw_junpoy.SetItem(iCurRow,"kwan_no", dw_list_chg.GetItemString(k,"kfa02om0_gubun1"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1		
	end if

	IF dw_junpoy.RowCount() <= 0 THEN 
		Return 1
	ELSE
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[미승인전표]')
			SetPointer(Arrow!)
			
			w_mdi_frame.sle_msg.text ="고정자산처분내역 전표 처리 중 에러 발생"
			Return -1
		ELSE
			Commit;
			
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
	//				Return -1
				END IF	
			END IF
		END IF
		
		w_mdi_frame.sle_msg.text ="고정자산처분내역 전표 처리 완료!!"
	END IF
NEXT

Return 1
end function

on w_kifa80.create
int iCurrent
call super::create
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_list_cha=create dw_list_cha
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_list_dae=create dw_list_dae
this.dw_list_chg=create dw_list_chg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_junpoy
this.Control[iCurrent+2]=this.dw_sungin
this.Control[iCurrent+3]=this.dw_list_cha
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_ip
this.Control[iCurrent+6]=this.dw_list_dae
this.Control[iCurrent+7]=this.dw_list_chg
end on

on w_kifa80.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_list_cha)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_list_dae)
destroy(this.dw_list_chg)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1,"yearmonf", Left(F_Today(),6))
dw_ip.SetItem(1,"yearmont", Left(F_Today(),6))

dw_ip.SetItem(1,"dept_cd",   Gs_Dept)
dw_ip.SetItem(1,"deptname",  F_Get_PersonLst('3',Gs_Dept,'%'))

dw_ip.SetItem(1,"sawon",      Gs_EmpNo)
dw_ip.SetItem(1,"sawonname",  F_Get_PersonLst('4',Gs_EmpNo,'%'))

dw_ip.SetItem(1,"saupj",      Gs_Saupj)

dw_list_cha.SetTransObject(SQLCA)
dw_list_dae.SetTransObject(SQLCA)
dw_list_chg.SetTransObject(SQLCA)

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

type dw_insert from w_inherite`dw_insert within w_kifa80
boolean visible = false
integer x = 87
integer y = 2636
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa80
boolean visible = false
integer x = 1280
integer y = 16
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa80
boolean visible = false
integer x = 1106
integer y = 16
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa80
boolean visible = false
integer x = 411
integer y = 16
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kifa80
boolean visible = false
integer x = 933
integer y = 16
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa80
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kifa80
boolean visible = false
integer x = 1801
integer y = 16
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa80
boolean visible = false
integer x = 585
integer y = 16
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

type p_inq from w_inherite`p_inq within w_kifa80
boolean visible = false
integer x = 759
integer y = 16
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kifa80
boolean visible = false
integer x = 1627
integer y = 16
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa80
integer x = 4270
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sFrom, sTo, sDept, sSawon, sBalDate, sSaupj, sGbn,sCostCd,sAcCd

If dw_ip.AcceptText() = -1 then Return

sFrom    = Trim(dw_ip.GetItemString(1,"yearmonf"))		//대상년월(from)
//sTo      = Trim(dw_ip.GetItemString(1,"yearmont"))		//대상년월(to)
sGbn     = Trim(dw_ip.GetItemString(1,"sgbn"))
sDept    = dw_ip.GetItemString(1,"dept_cd")				//부서
sSaupj   = dw_ip.GetItemString(1,"saupj")					//사업장
sSawon   = dw_ip.GetItemString(1,"sawon") 				//사원
sBalDate = Trim(dw_ip.GetItemString(1,"baldate"))		//전표작성 일자
sAcCd    = Trim(dw_ip.GetItemString(1,"accd"))
sCostcd  = dw_ip.GetItemString(1, 'cost_cd')				//원가부문

IF sFrom = "" OR IsNull(sFrom) THEN
	F_MessageChk(1,'[대상년월]')	
	dw_ip.SetColumn("yearmonf")
	dw_ip.SetFocus()
	Return 
else
	sTo = sFrom
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

if sGbn = '1' then			/*감가상각비*/
	IF sBalDate = "" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[작성일자]')	
		dw_ip.SetColumn("baldate")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_list_cha.Retrieve(sFrom,sTo,sSaupj,sCostCd) <= 0 OR dw_list_dae.Retrieve(sFrom,sTo,sSaupj,sCostCd) <= 0 THEN
		F_MessageChk(14,'')
		Return
	END IF
	
	/*공통 배부처리*/
	//Wf_BaeBu(sFrom,sTo,sSaupj)
	
	/* 미승인전표자료를 생성하여, DW_JUNPYO에 데이터를 삽입시킨다 */
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate,sDept,sSawon,sCostCd) = -1 THEN
		Rollback;
		Return
	END IF
else
	IF sAccd = "" OR IsNull(sAccd) THEN
		F_MessageChk(1,'[상대계정]')	
		dw_ip.SetColumn("accd")
		dw_ip.SetFocus()
		Return 
	END IF
	
	IF dw_list_chg.Retrieve(sFrom,sTo,sSaupj,sCostCd) <= 0 THEN
		F_MessageChk(14,'')
		Return
	END IF
	
	IF Wf_Insert_Kfz12ot0_chg(sSaupj,sBalDate,sDept,sSawon,sCostCd,sAccd) = -1 THEN
		Rollback;
		Return
	END IF
end if

Commit;
	
//p_print.TriggerEvent(Clicked!)

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa80
boolean visible = false
integer x = 4073
integer y = 2980
end type

type cb_mod from w_inherite`cb_mod within w_kifa80
boolean visible = false
integer x = 3726
integer y = 2980
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa80
boolean visible = false
integer x = 3717
integer y = 2756
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa80
boolean visible = false
integer x = 3918
integer y = 2596
end type

type cb_inq from w_inherite`cb_inq within w_kifa80
boolean visible = false
integer x = 2661
integer y = 2764
end type

type cb_print from w_inherite`cb_print within w_kifa80
boolean visible = false
integer x = 3003
integer y = 2760
end type

type st_1 from w_inherite`st_1 within w_kifa80
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa80
boolean visible = false
integer x = 3369
integer y = 2756
end type

type cb_search from w_inherite`cb_search within w_kifa80
boolean visible = false
integer x = 2043
integer y = 2776
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa80
boolean visible = false
integer x = 2857
end type

type sle_msg from w_inherite`sle_msg within w_kifa80
boolean visible = false
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_kifa80
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa80
boolean visible = false
integer x = 3799
integer y = 2552
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa80
boolean visible = false
integer x = 3675
integer y = 2924
integer width = 768
end type

type dw_junpoy from datawindow within w_kifa80
integer x = 1125
integer y = 2576
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

event dberror;//MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
return 1
end event

event itemerror;Return 1
end event

type dw_sungin from datawindow within w_kifa80
boolean visible = false
integer x = 1106
integer y = 2308
integer width = 1029
integer height = 112
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

type dw_list_cha from datawindow within w_kifa80
boolean visible = false
integer x = 78
integer y = 2568
integer width = 1029
integer height = 112
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

type dw_print from datawindow within w_kifa80
boolean visible = false
integer x = 73
integer y = 2308
integer width = 1029
integer height = 112
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

type dw_ip from u_key_enter within w_kifa80
event ue_key pbm_dwnkey
integer x = 571
integer y = 180
integer width = 3026
integer height = 1988
integer taborder = 10
string dataobject = "d_kifa801"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,sYearMonth,sSaupj,sDate,sDeptCode,sDeptNm,sSawon,sSawonNm,sAcCd,sAcName
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
		Return -1
	End If
	
	sDeptNm = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptNm) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(this.GetRow(),"dept_cd",snull)
		Return 1
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

IF this.GetColumnName() ="accd" THEN
	sAcCd = this.GetText()
	IF sAcCd = "" OR IsNull(sAcCd) THEN Return
	
	select acc2_nm	into :sAcName from kfz01om0 where acc1_cd||acc2_cd = :sAcCd and bal_gu <> '4';
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[상대계정]')
		this.SetItem(this.GetRow(),"accd",   snull)
		this.SetItem(this.GetRow(),"acname", snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"acname",sAcName)
	END IF
END IF


end event

event rbuttondown;

IF this.GetColumnName() ="dept_cd" THEN
	SetNull(lstr_custom.code);		SetNull(lstr_custom.name);
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"dept_cd", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname",lstr_custom.name)
	
	this.TriggerEvent(ItemChanged!)
	
END IF

IF this.GetColumnName() ="sawon" THEN
	SetNull(lstr_custom.code);		SetNull(lstr_custom.name);
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"sawonname",lstr_custom.name)
	
END IF

IF this.GetColumnName() ="accd" THEN
	SetNull(lstr_account.acc1_cd);		SetNull(lstr_account.acc2_cd);
	SetNull(lstr_account.acc2_nm);
	
	OpenWithParm(W_KFZ01OM0_POPUP,'%')
	
	IF lstr_account.acc1_cd = "" OR IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"accd",    lstr_account.acc1_cd + lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acname",  lstr_account.acc2_nm)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_list_dae from datawindow within w_kifa80
boolean visible = false
integer x = 73
integer y = 2424
integer width = 1029
integer height = 112
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

type dw_list_chg from datawindow within w_kifa80
boolean visible = false
integer x = 1125
integer y = 2424
integer width = 1029
integer height = 112
boolean bringtotop = true
boolean titlebar = true
string title = "고정자산 처분내역 조회"
string dataobject = "d_kifa804"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

