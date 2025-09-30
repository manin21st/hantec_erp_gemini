$PBExportHeader$w_kifa85.srw
$PBExportComments$본지점전표 등록
forward
global type w_kifa85 from w_inherite
end type
type dw_cond from u_key_enter within w_kifa85
end type
type dw_detail from u_key_enter within w_kifa85
end type
type dw_lst from datawindow within w_kifa85
end type
type dw_vat from datawindow within w_kifa85
end type
type dw_junpoy from datawindow within w_kifa85
end type
type dw_print from datawindow within w_kifa85
end type
type gb_1 from groupbox within w_kifa85
end type
type gb_2 from groupbox within w_kifa85
end type
type rr_1 from roundrectangle within w_kifa85
end type
type rr_2 from roundrectangle within w_kifa85
end type
end forward

global type w_kifa85 from w_inherite
string title = "본지점전표 등록"
dw_cond dw_cond
dw_detail dw_detail
dw_lst dw_lst
dw_vat dw_vat
dw_junpoy dw_junpoy
dw_print dw_print
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kifa85 w_kifa85

forward prototypes
public function integer wf_requiredchk (string sflag, integer ll_row)
public subroutine wf_init ()
public function integer wf_insert_vat (string ssaupj, string sbaldate, string supmugbn, long ljunno, ref integer ilinno)
public function integer wf_create_kfz12ot0_r (integer irow, string ssaupj, string sbaldate, ref long ljunno)
public function integer wf_create_kfz12ot0_b (string ssaupj, string sbaldate, ref long ljunno)
end prototypes

public function integer wf_requiredchk (string sflag, integer ll_row);
String sDate,sSaupNo,sAcc1,sAcc2,sAcCd_D

IF sFlag = 'H' THEN
	dw_detail.AcceptText()
	sDate   = Trim(dw_detail.GetItemString(ll_row,"checkno"))
	sSaupNo = dw_detail.GetItemString(ll_row,"saup_no")
	sAcc1   = dw_detail.GetItemString(ll_row,"acc1_cd")
	sAcc2   = dw_detail.GetItemString(ll_row,"acc2_cd")
	sAcCd_D = dw_detail.GetItemString(ll_row,"saccd")
	
	IF sDate = "" OR IsNull(sDate) THEN
		f_messagechk(1,'[계산서일자]')
		dw_detail.SetColumn("checkno")
		dw_detail.SetFocus()
		Return -1
	END IF
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		f_messagechk(1,'[거래처]')
		dw_detail.SetColumn("saup_no")
		dw_detail.SetFocus()
		Return -1
	END IF
	IF sAcc1 = "" OR IsNull(sAcc1) THEN
		f_messagechk(1,'[계정과목]')
		dw_detail.SetColumn("acc1_cd")
		dw_detail.SetFocus()
		Return -1
	END IF
	IF sAcc2 = "" OR IsNull(sAcc2) THEN
		f_messagechk(1,'[계정과목]')
		dw_detail.SetColumn("acc2_cd")
		dw_detail.SetFocus()
		Return -1
	END IF
	IF sAcCd_D = "" OR IsNull(sAcCd_D) THEN
		f_messagechk(1,'[상대계정]')
		dw_detail.SetColumn("saccd")
		dw_detail.SetFocus()
		Return -1
	END IF
ELSE
	String sSaupj
	Double dAmount
	
	dw_insert.AcceptText()
	sSaupj  = dw_insert.GetItemString(ll_row,"saupj_out")
	dAmount = dw_insert.GetItemNumber(ll_row,"amount")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		f_messagechk(1,'[사업장]')
		dw_insert.SetColumn("saupj_out")
		dw_insert.SetFocus()
		dw_insert.ScrollToRow(ll_row)
		Return -1
	END IF
	IF dAmount = 0 OR IsNull(dAmount) THEN
		f_messagechk(1,'[금액]')
		dw_insert.SetColumn("amount")
		dw_insert.SetFocus()
		dw_insert.ScrollToRow(ll_row)
		Return -1
	END IF
END IF
Return 1
end function

public subroutine wf_init ();dw_detail.SetRedraw(False)
dw_detail.Reset()
dw_detail.InsertRow(0)
dw_detail.SetItem(1,"checkno", F_Today())
dw_detail.SetItem(1,"saupj",   dw_cond.GetItemString(1,"saupj"))
dw_detail.SetRedraw(True)

dw_detail.SetColumn("checkno")
dw_detail.SetFocus()

dw_insert.Reset()

p_search.Enabled = False
p_search.PictureName = 'C:\erpman\image\전표처리_d.gif'

end subroutine

public function integer wf_insert_vat (string ssaupj, string sbaldate, string supmugbn, long ljunno, ref integer ilinno);String  sAcc1_Vat,sAcc2_Vat,sSaupNo,sVatGbn,sCvcod,sSano,sOwnam,sResident,sUptae,sJongk,sAddr,sJasaCode
Integer iAddRow,iCurRow
Double  dGonAmt,dVatAmt

dw_detail.AcceptText()
dGonAmt = dw_detail.GetItemNumber(1,"gonamt")
dVatAmt = dw_detail.GetItemNumber(1,"vatamt")
sCvcod  = dw_detail.GetItemString(1,"saup_no")

if IsNull(dGonAmt) then dGonAmt = 0
if IsNull(dVatAmt) then dVatAmt = 0
/*거래처*/
select sano,		uptae,	jongk,		ownam,		resident,	addr1
	into :sSano,	:sUptae,	:sJongK,		:sOwnam,		:sResident,	:sAddr
   from vndmst
	where cvcod = :sCvcod;
/*부가세계정*/	
select substr(dataname,1,5),	substr(dataname,6,2)
	into :sAcc1_Vat,				:sAcc2_Vat
	from syscnfg
	where sysgu = 'A' and serial = 1 and lineno = '2' ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[선급부가세(A-1-2)]')
	RETURN -1
END IF
/*자사코드*/
select rfna2	into :sJasaCode	from reffpf where rfcod = 'AD' and rfgub = :sSaupj;

/*전표 추가*/
iCurRow = dw_junpoy.InsertRow(0)

dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
			
dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
dw_junpoy.SetItem(iCurRow,"dcr_gu",  '1')
		
dw_junpoy.SetItem(iCurRow,"amt",     dVatAmt)	
dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"saupname")+' [부가세]')	

dw_junpoy.SetItem(iCurRow,"saup_no", sCvcod)
dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))

dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 

/*부가세 자료 생성*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)
dw_vat.SetItem(iAddRow,"lin_no",  iLinNo)

dw_vat.SetItem(iAddRow,"gey_date",dw_detail.GetItemString(1,"checkno"))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))

dw_vat.SetItem(iAddRow,"gon_amt", dGonAmt)
dw_vat.SetItem(iAddRow,"vat_amt", dVatAmt)

dw_vat.SetItem(iAddRow,"for_amt", 0)
if dVatAmt = 0 then
	sVatGbn = '19'
else
	sVatGbn = '11'
end if
dw_vat.SetItem(iAddRow,"tax_no",  sVatGbn)
dw_vat.SetItem(iAddRow,"io_gu",   '1')										/*매입*/
dw_vat.SetItem(iAddRow,"saup_no2",sSano)
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   dw_detail.GetItemString(1,"saupname")+' [부가세]')	
dw_vat.SetItem(iAddRow,"jasa_cd", sJasaCode)

dw_vat.SetItem(iAddRow,"cvnas",   dw_detail.GetItemString(1,"saupname"))
dw_vat.SetItem(iAddRow,"ownam",   sOwnam)
dw_vat.SetItem(iAddRow,"resident",sResident)
dw_vat.SetItem(iAddRow,"uptae",   sUptae)
dw_vat.SetItem(iAddRow,"jongk",   sJongk)
dw_vat.SetItem(iAddRow,"addr1",   sAddr)
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))

iLinNo = iLinNo + 1

Return 1
end function

public function integer wf_create_kfz12ot0_r (integer irow, string ssaupj, string sbaldate, ref long ljunno);/************************************************************************************/
/* 본지점자료를 자동으로 전표 처리한다.															*/
/* 2. 본지점사업장 : 차변 - 계정과목																*/
/* 				      대변 - 참조코드('BR')의 계정(본/지점)									*/
/************************************************************************************/
String    sUpmuGbn = 'A',sAcc1C,sAcc2C,sAcc1D,sAcc2D,sSaupNo,sDcGbn,sChaDae,sGbn1,&
			 sYesanGbn,sRemark1,sSaupjBr,sBrGbnFrom,sBrGbnTo
Integer   iLinNo,iFindRow,iCurRow,iLoopCnt,i
Double    dAmount

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="본지점 전표(본지점사업장) 처리 중 ..."

SetPointer(HourGlass!)

dw_detail.AcceptText()
sAcc1C   = dw_detail.GetItemString(1,"acc1_cd")
sAcc2C   = dw_detail.GetItemString(1,"acc2_cd")
sSaupjBr = dw_insert.GetItemString(iRow,"saupj_out")

/*본점여부*/
select nvl(rfna5,'N') into :sBrGbnFrom	from reffpf where rfcod = 'BR' and rfgub = :sSaupj;

/*본점여부*/
select nvl(rfna5,'N') into :sBrGbnTo	from reffpf where rfcod = 'BR' and rfgub = :sSaupjBr;

if sSaupj <> sSaupjBr then
	/*본지점 사업장 전표*/
	lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupjBr,sUpmuGbn,sBalDate)			/*전표번호 채번*/
	iLinNo = 1
		
	sDcGbn = '1'											/*차변*/
	
	dAmount = dw_insert.GetItemNumber(iRow,"amount")
	if IsNull(dAmount) then dAmount = 0
	
	select dc_gu,		gbn1,		yesan_gu,		remark1	
		into :sChaDae,	:sGbn1,	:sYesanGbn,		:sRemark1
		from kfz01om0
		where acc1_cd = :sAcc1C and acc2_cd = :sAcc2C ;
	
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupjBr)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1C)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2C)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   dw_insert.GetItemString(iRow,"descr"))	
	
	IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",Gs_Dept)
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
	END IF
	
	if sGbn1 = '5' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"depotno"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"depotname"))
	elseif sGbn1 = '1' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))
	end if
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	iLinNo = iLinNo + 1

	sDcGbn = '2'											/*대변*/
	
	if sBrGbnTo = 'N' and sBrGbnFrom ='Y' then							/*본점에서 지점으로*/
		select substr(rfna2,1,5),	substr(rfna2,6,2)	into :sAcc1D,	:sAcc2D  
			from reffpf
			where rfcod = 'BR' and rfgub = :sSaupjBr;
	elseif sBrGbnFrom = 'N' and sBrGbnTo = 'Y' then
		select substr(rfna3,1,5),	substr(rfna3,6,2)	into :sAcc1D,	:sAcc2D  
			from reffpf
			where rfcod = 'BR' and rfgub = :sSaupj;
	elseif sBrGbnFrom = 'N' and sBrGbnTo = 'N' then
		select substr(rfna3,1,5),	substr(rfna3,6,2)	into :sAcc1D,	:sAcc2D  
			from reffpf
			where rfcod = 'BR' and rfgub = :sSaupj;
	end if
	
	select dc_gu,		gbn1,		yesan_gu,		remark1	
		into :sChaDae,	:sGbn1,	:sYesanGbn,		:sRemark1
		from kfz01om0
		where acc1_cd = :sAcc1D and acc2_cd = :sAcc2D ;
	
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupjBr)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1D)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2D)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   dw_insert.GetItemString(iRow,"descr"))	
	
	IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",Gs_Dept)
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
	END IF
	
	if sGbn1 = '5' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"depotno"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"depotname"))
	elseif sGbn1 = '1' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))
	end if
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	iLinNo = iLinNo + 1
end if

w_mdi_frame.sle_msg.text ="본지점 전표(본지점사업장) 처리 완료!!"

Return 1
end function

public function integer wf_create_kfz12ot0_b (string ssaupj, string sbaldate, ref long ljunno);/************************************************************************************/
/* 본지점자료를 자동으로 전표 처리한다.															*/
/* 1. 사업장 :차변 - 계정과목/부가세(0이 아니면)/상세내역(본지점)의 금액				*/
/*            대변 - 상대계정																			*/
/************************************************************************************/

String    sUpmuGbn = 'A',sAcc1C,sAcc2C,sAcc1D,sAcc2D,sSaupNo,sDcGbn,sDescr,sChaDae,sGbn1,&
			 sYesanGbn,sRemark1,sSaupjBr
Integer   iLinNo,iFindRow,iCurRow,iLoopCnt,i
Double    dAmount

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="본지점 전표 처리 중 ..."

SetPointer(HourGlass!)

dw_junpoy.Reset()
dw_vat.Reset()

dw_detail.AcceptText()
sAcc1C   = dw_detail.GetItemString(1,"acc1_cd")
sAcc2C   = dw_detail.GetItemString(1,"acc2_cd")
sDescr   = dw_detail.GetItemString(1,"descr")

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

/*자기 사업장 전표*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)			/*전표번호 채번*/
iLinNo = 1

sDcGbn = '1'
/*비용계정 항번 추가*/
iFindRow = dw_insert.Find("saupj_out = '"+sSaupj+"'",1,dw_insert.RowCount())
if iFindRow > 0 then
	sDcGbn = '1'
	
	dAmount = dw_insert.GetItemNumber(iFindRow,"amount")
	if IsNull(dAmount) then dAmount = 0
	
	select dc_gu,		gbn1,		yesan_gu,		remark1	
		into :sChaDae,	:sGbn1,	:sYesanGbn,		:sRemark1
		from kfz01om0
		where acc1_cd = :sAcc1C and acc2_cd = :sAcc2C ;
	
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1C)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2C)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   sDescr)	
	
	IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",Gs_Dept)
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
	END IF
	
	if sGbn1 = '5' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"depotno"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"depotname"))
	elseif sGbn1 = '1' then
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))
	end if
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	iLinNo = iLinNo + 1
end if

/*부가세 항번 추가*/
IF Wf_Insert_Vat(sSaupj,sBalDate,sUpmuGbn,lJunNo,iLinNo) = -1 THEN
	SetPointer(Arrow!)
	Return -1
END IF

/*본지점 항번 추가*/
iLoopCnt = dw_insert.RowCount()
sDcGbn = '1'
For i = 1 To iLoopCnt
	sSaupjBr = dw_insert.GetItemString(i,"saupj_out")
	if sSaupj <> sSaupjBr then
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(dw_insert.GetItemString(i,"accd"),5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Mid(dw_insert.GetItemString(i,"accd"),6,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dw_insert.GetItemNumber(i,"amount"))
		dw_junpoy.SetItem(iCurRow,"descr",   dw_insert.GetItemString(i,"descr"))	
		
		IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",Gs_Dept)
		END IF
		
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
		END IF
		
		if sGbn1 = '5' then
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"depotno"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"depotname"))
		elseif sGbn1 = '1' then
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))
		end if
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		iLinNo = iLinNo + 1
	end if
Next
/*상대계정 항번 추가*/
sDcGbn = '2'

sAcc1D  = Left(dw_detail.GetItemString(1,"saccd"),5)
sAcc2D  = Mid(dw_detail.GetItemString(1,"saccd"),6,2)
dAmount = dw_detail.GetItemNumber(1,"totamt")
if IsNull(dAmount) then dAmount = 0

select dc_gu,		gbn1,		yesan_gu,		remark1	
	into :sChaDae,	:sGbn1,	:sYesanGbn,		:sRemark1
	from kfz01om0
	where acc1_cd = :sAcc1D and acc2_cd = :sAcc2D ;

iCurRow = dw_junpoy.InsertRow(0)

dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
dw_junpoy.SetItem(iCurRow,"lin_no",  iLinNo)

dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1D)
dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2D)
dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)

dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"sacname"))	

IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
	dw_junpoy.SetItem(iCurRow,"sdept_cd",Gs_Dept)
END IF

IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
	dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
END IF

if sGbn1 = '5' then
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"depotno"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"depotname"))
elseif sGbn1 = '1' then
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_detail.GetItemString(1,"saup_no"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_detail.GetItemString(1,"saupname"))
end if

dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
iLinNo = iLinNo + 1

w_mdi_frame.sle_msg.text ="본지점 전표(자사사업장) 처리 완료!!"

Return 1
end function

on w_kifa85.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_detail=create dw_detail
this.dw_lst=create dw_lst
this.dw_vat=create dw_vat
this.dw_junpoy=create dw_junpoy
this.dw_print=create dw_print
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_lst
this.Control[iCurrent+4]=this.dw_vat
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_kifa85.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_detail)
destroy(this.dw_lst)
destroy(this.dw_vat)
destroy(this.dw_junpoy)
destroy(this.dw_print)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"saupj", Gs_Saupj)

dw_junpoy.SetTransObject(Sqlca)
dw_vat.SetTransObject(Sqlca)

dw_lst.SetTransObject(Sqlca)
dw_lst.Reset()

dw_detail.SetTransObject(Sqlca)

dw_insert.SetTransObject(Sqlca)


Wf_Init()
end event

type dw_insert from w_inherite`dw_insert within w_kifa85
integer x = 2373
integer y = 1100
integer width = 2194
integer height = 612
integer taborder = 40
string dataobject = "d_kifa853"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::itemchanged;call super::itemchanged;String sNull

SetNull(sNull)
if this.GetColumnName() = 'saupj_out' then
	if this.GetText() = this.GetItemString(this.GetRow(),"saupj") then
		this.SetItem(this.GetRow(),"accd", snull)
	end if
end if
end event

type p_delrow from w_inherite`p_delrow within w_kifa85
integer x = 2551
integer y = 1736
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Integer iCurRow,rowno,i

iCurRow = dw_insert.GetRow()
IF iCurRow <=0 THEN
	messagebox("확인","삭제할 자료를 클릭하시오!")
  	dw_insert.SetFocus()
  	return
END IF

dw_insert.DeleteRow(0)

dw_insert.SetFocus()

ib_any_typing = True



end event

type p_addrow from w_inherite`p_addrow within w_kifa85
integer x = 2363
integer y = 1736
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iGetRow,iInsRow

w_mdi_frame.sle_msg.text =""

iCurRow = dw_lst.GetRow()

IF dw_insert.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk('D',dw_insert.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_insert.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iInsRow = iGetRow + 1
	
	dw_insert.InsertRow(iInsRow)

	dw_insert.ScrollToRow(iInsRow)
	dw_insert.SetItem(iInsRow,'sflag','I')
	dw_insert.SetItem(iInsRow,'saupj',dw_detail.GetItemString(1,"saupj"))
	dw_insert.SetColumn("saupj_out")
	dw_insert.SetFocus()
	
	ib_any_typing = True

END IF

end event

type p_search from w_inherite`p_search within w_kifa85
integer x = 3561
integer y = 8
integer taborder = 100
string picturename = "C:\erpman\image\전표처리_d.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\전표처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\전표처리_up.gif"
end event

event p_search::clicked;/************************************************************************************/
/* 본지점자료를 자동으로 전표 처리한다.															*/
/* 1. 자사사업장 :차변 - 계정과목/부가세(0이 아니면)/상세내역(본지점)의 금액			*/
/*                대변 - 상대계정																	*/
/* 2. 본지점내역 : 차변 - 계정과목																	*/
/* 				    대변 - 상대계정(본지점)														*/
/************************************************************************************/

String    sSaupj,sBalDate,sUpmuGbn = 'A'
Long      lJunNo = 0

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="본지점 전표 처리 중 ..."

SetPointer(HourGlass!)

dw_junpoy.Reset()
dw_vat.Reset()

dw_detail.AcceptText()
sSaupj   = dw_detail.GetItemString(1,"saupj")
sBalDate = Trim(dw_detail.GetItemString(1,"checkno"))

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return
END IF

lJunNo = 0
IF Wf_Create_Kfz12ot0_B(sSaupj,sBalDate,lJunNo) = -1 then
	Rollback;
	F_MessageChk(13,'[자사사업장전표]')
	Return
ELSE
	dw_detail.SetItem(1,"bal_date",sBalDate)
	dw_detail.SetItem(1,"upmu_gu", sUpmuGbn)
	dw_detail.SetItem(1,"bjun_no", lJunNo)
END IF

Integer iCount,k
iCount = dw_insert.RowCount()

For k = 1 To iCount
	lJunNo = 0
	IF Wf_Create_Kfz12ot0_R(k,sSaupj,sBalDate,lJunNo) = -1 then
		Rollback;
		F_MessageChk(13,'[본지점전표]')
		Return
	ELSE
		dw_insert.SetItem(k,"bal_date",sBalDate)
		dw_insert.SetItem(k,"upmu_gu", sUpmuGbn)
		dw_insert.SetItem(k,"bjun_no", lJunNo)
	END IF
Next
IF dw_junpoy.Update() <> 1 THEN
	Rollback;
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return 
ELSE
	IF dw_vat.Update() <> 1 THEN
		Rollback;
		F_MessageChk(13,'[부가세]')
		Return 
	END IF
	IF dw_detail.Update() <> 1 OR dw_insert.Update() <> 1 THEN
		Rollback;
		F_MessageChk(13,'[본지점내역]')
		Return 
	END IF
END IF
Commit;

w_mdi_frame.sle_msg.text ="본지점 전표 처리 완료!!"
SetPointer(Arrow!)

end event

type p_ins from w_inherite`p_ins within w_kifa85
boolean visible = false
integer x = 2597
integer y = 4
integer taborder = 0
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;Integer  iCurRow,iFunctionValue,iGetRow

w_mdi_frame.sle_msg.text =""

IF dw_lst.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk('H',dw_lst.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_lst.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iGetRow + 1
	
	dw_lst.InsertRow(iCurRow)

	dw_lst.ScrollToRow(iCurRow)
	dw_lst.SetItem(iCurRow,'saupj',dw_cond.GetItemString(1,"saupj"))
	dw_lst.SetItem(iCurRow,'sflag','I')
	
	dw_lst.SetColumn("checkno")
	dw_lst.SetFocus()
	
	dw_insert.Reset()
	
	ib_any_typing = True

END IF

end event

type p_exit from w_inherite`p_exit within w_kifa85
integer x = 4430
integer y = 8
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_kifa85
integer x = 4256
integer y = 8
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
p_inq.TriggerEvent(Clicked!)

end event

type p_print from w_inherite`p_print within w_kifa85
boolean visible = false
integer x = 1998
integer y = 12
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kifa85
integer x = 3735
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj

dw_cond.AcceptText()
sSaupj = dw_cond.GetItemString(1,"saupj")
if sSaupj = '' or IsNull(sSaupj) then
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return
end if

dw_lst.Retrieve(sSaupj)
dw_lst.SelectRow(0,False)

Wf_Init()

p_addrow.Enabled = True
p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'

p_delrow.Enabled = True
p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'

p_search.Enabled = False
p_search.PictureName = 'C:\erpman\image\전표처리_d.gif'

end event

type p_del from w_inherite`p_del within w_kifa85
integer x = 4082
integer y = 8
integer taborder = 80
end type

event p_del::clicked;call super::clicked;Integer k,iCount

IF dw_lst.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_detail.DeleteRow(dw_lst.GetRow())

iCount = dw_insert.RowCount()

FOR k = iCount TO 1 Step -1
	dw_insert.DeleteRow(k)
NEXT

IF dw_detail.Update() = 1 AND dw_insert.Update() = 1 THEN
	commit;	
	
	p_inq.TriggerEvent(Clicked!)
	
	Wf_Init()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kifa85
integer x = 3909
integer y = 8
integer taborder = 70
end type

event p_mod::clicked;Integer iRtnValue,k,iCurRow
Double  dGonAmt,dGonAmt_Detail

IF dw_detail.AcceptText() = -1 THEN Return
IF dw_insert.AcceptText() = -1 THEN Return

iCurRow = dw_detail.GetRow()
if iCurRow <=0 then Return

iRtnValue = Wf_RequiredChk('H',iCurRow)
IF iRtnValue = -1 THEN RETURN	
		
dGonAmt = dw_detail.GetItemNumber(iCurRow,"gonamt")
if IsNull(dGonAmt) then dGonAmt = 0
	
IF dw_insert.RowCount() > 0 THEN
	For k = 1 To dw_insert.RowCount()
		iRtnValue = Wf_RequiredChk('D',k)
		IF iRtnValue = -1 THEN RETURN
		
		dw_insert.SetItem(k,"saupj",    dw_detail.GetItemString(iCurRow,"saupj"))
		dw_insert.SetItem(k,"checkno",  dw_detail.GetItemString(iCurRow,"checkno"))
		dw_insert.SetItem(k,"saup_no",  dw_detail.GetItemString(iCurRow,"saup_no"))
		dw_insert.SetItem(k,"acc1_cd",  dw_detail.GetItemString(iCurRow,"acc1_cd"))
		dw_insert.SetItem(k,"acc2_cd",  dw_detail.GetItemString(iCurRow,"acc2_cd"))
		dw_insert.SetItem(k,"seqno",    dw_detail.GetItemNumber(iCurRow,"seqno"))
	Next
	dGonAmt_Detail = dw_insert.GetItemNumber(1,"hapamt")
	IF IsNull(dGonAmt_Detail) then dGonAmt_Detail = 0
	
	if dGonAmt <> dGonAmt_Detail then
		F_MessageChk(20,'[공급가액 <> 사업장벼 배부상세]')
		Return
	end if
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_detail.Update() = 1 AND dw_insert.Update() = 1 THEN
	commit;

	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
	
	p_inq.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kifa85
end type

type cb_mod from w_inherite`cb_mod within w_kifa85
end type

type cb_ins from w_inherite`cb_ins within w_kifa85
end type

type cb_del from w_inherite`cb_del within w_kifa85
end type

type cb_inq from w_inherite`cb_inq within w_kifa85
end type

type cb_print from w_inherite`cb_print within w_kifa85
end type

type st_1 from w_inherite`st_1 within w_kifa85
end type

type cb_can from w_inherite`cb_can within w_kifa85
end type

type cb_search from w_inherite`cb_search within w_kifa85
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa85
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa85
end type

type dw_cond from u_key_enter within w_kifa85
integer x = 37
integer y = 28
integer width = 1175
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kifa851"
boolean border = false
end type

event itemchanged;call super::itemchanged;
if this.GetColumnName() = 'saupj' then
	this.GetText()
	p_inq.TriggerEvent(Clicked!)
end if
end event

type dw_detail from u_key_enter within w_kifa85
event ue_key pbm_dwnkey
integer x = 2391
integer y = 228
integer width = 2158
integer height = 744
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kifa852"
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String   sDate,sSaupNo,sSaupNm,sAcc1,sAcc2,sAccNm,sGbn1,sNull
Integer  iCurRow

SetNull(sNull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "checkno" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[계산서일자]')
		this.SetItem(iCurRow,"checkno",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "saup_no" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(iCurRow,"saupname",snull)
		Return
	END IF
	
	sSaupNm = F_Get_PersonLst('1',sSaupNo,'1')
	IF IsNull(sSaupNo) THEN
		F_MessageChk(20,'[거래처]')
		this.SetItem(iCurRow,"saup_no",snull)
		this.SetItem(iCurRow,"saupname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"saupname",sSaupNm)
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1 = this.GetText()
	if sAcc1 = '' or IsNull(sAcc1) then
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return	
	end if
	
	sAcc2 = this.GetItemString(iCurRow,"acc2_cd")
	if sAcc2 = '' or IsNull(sAcc2) then
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return	
	end if
	
	select acc2_nm	into :sAccNm	from kfz01om0
		where acc1_cd = :sAcc1 and acc2_cd = :sAcc2 and bal_gu <> '4' and
				bal_gu <> '2' ;
	if sqlca.sqlcode = 0 then
		this.SetItem(iCurRow,"acc2_nm",sAccNm)
	else
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2 = this.GetText()
	if sAcc2 = '' or IsNull(sAcc2) then
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return	
	end if
	
	sAcc1 = this.GetItemString(iCurRow,"acc1_cd")
	if sAcc1 = '' or IsNull(sAcc1) then
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return	
	end if
	
	select acc2_nm	into :sAccNm	from kfz01om0
		where acc1_cd = :sAcc1 and acc2_cd = :sAcc2 and bal_gu <> '4' and
				bal_gu <> '2' ;
	if sqlca.sqlcode = 0 then
		this.SetItem(iCurRow,"acc2_nm",sAccNm)
	else
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "gonamt" THEN
	if this.GetText() = '' or IsNull(this.GetText()) then Return 1
END IF
IF this.GetColumnName() = "vatamt" THEN
	if this.GetText() = '' or IsNull(this.GetText()) then Return 1
END IF	
IF this.GetColumnName() = "saccd" THEN
	sAcc2 = this.GetText()
	if sAcc2 = '' or IsNull(sAcc2) then
		this.SetItem(iCurRow,"sacname",snull)
		Return	
	end if
	
	select acc2_nm, gbn1	into :sAccNm, :sGbn1		from kfz01om0
		where acc1_cd||acc2_cd = :sAcc2 and bal_gu <> '4' and
				bal_gu <> '1' ;
	if sqlca.sqlcode = 0 then
		this.SetItem(iCurRow,"sacname",sAccNm)
		
		if sGbn1 = '5' then
			this.Modify("depotno.protect = 0")	
		else
			this.Modify("depotno.protect = 1")	
		end if
	else
		this.SetItem(iCurRow,"saccd",      snull)
		this.SetItem(iCurRow,"sacname",    snull)
		this.SetItem(iCurRow,"depotno",    snull)
		this.SetItem(iCurRow,"depotnamte", snull)		
		Return 1
	end if
END IF

IF this.GetColumnName() = "depotno" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(iCurRow,"depotname",snull)
		Return
	END IF
	
	sSaupNm = F_Get_PersonLst('5',sSaupNo,'1')
	IF IsNull(sSaupNo) THEN
		F_MessageChk(20,'[예적금]')
		this.SetItem(iCurRow,"depotno",snull)
		this.SetItem(iCurRow,"depotname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"depotname",sSaupNm)
	END IF
END IF




end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd); 	SetNull(lstr_account.acc2_cd);
	SetNull(lstr_account.acc1_nm); 	SetNull(lstr_account.acc2_nm);
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() ="saup_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"saup_no"),1))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	IF IsNull(lstr_custom.name) THEN lstr_custom.name = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "saccd" THEN	
	SetNull(lstr_account.acc1_cd); 	SetNull(lstr_account.acc2_cd);
	SetNull(lstr_account.acc1_nm); 	SetNull(lstr_account.acc2_nm);
	
	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"saccd"),1)
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"saccd",lstr_account.acc1_cd+lstr_account.acc2_cd)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() ="depotno" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"depotno"),1))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	IF IsNull(lstr_custom.name) THEN lstr_custom.name = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'5')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"depotno",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

type dw_lst from datawindow within w_kifa85
integer x = 50
integer y = 180
integer width = 2226
integer height = 2028
boolean bringtotop = true
string title = "none"
string dataobject = "d_kifa854"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;

if row <=0 then Return

SelectRow(0,False)
SelectRow(row,True)

dw_detail.Retrieve(this.GetItemString(row,"saupj"),&
						 this.GetItemString(row,"checkno"),&
						 this.GetItemString(row,"saup_no"),&
						 this.GetItemString(row,"acc1_cd"),&
						 this.GetItemString(row,"acc2_cd"),&
						 this.GetItemNumber(row,"seqno"))

dw_insert.Retrieve(this.GetItemString(row,"saupj"),&
						 this.GetItemString(row,"checkno"),&
						 this.GetItemString(row,"saup_no"),&
						 this.GetItemString(row,"acc1_cd"),&
						 this.GetItemString(row,"acc2_cd"),&
						 this.GetItemNumber(row,"seqno"))

p_addrow.Enabled = True
p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'

p_delrow.Enabled = True
p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'

p_search.Enabled = True
p_search.PictureName = 'C:\erpman\image\전표처리_up.gif'





end event

type dw_vat from datawindow within w_kifa85
boolean visible = false
integer x = 3456
integer y = 1944
integer width = 1029
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "부가세 저장"
string dataobject = "d_kifa037"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_junpoy from datawindow within w_kifa85
boolean visible = false
integer x = 2377
integer y = 1936
integer width = 1033
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

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_print from datawindow within w_kifa85
boolean visible = false
integer x = 3461
integer y = 2064
integer width = 1029
integer height = 96
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

type gb_1 from groupbox within w_kifa85
integer x = 2354
integer y = 1052
integer width = 2231
integer height = 680
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사업장별 배부 상세"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_kifa85
integer x = 2354
integer y = 184
integer width = 2226
integer height = 828
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa85
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 172
integer width = 2245
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kifa85
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2322
integer y = 180
integer width = 2286
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

