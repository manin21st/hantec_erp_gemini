$PBExportHeader$w_kgla20.srw
$PBExportComments$부가세 등록II
forward
global type w_kgla20 from w_inherite
end type
type dw_cond from u_key_enter within w_kgla20
end type
type dw_lst from u_d_popup_sort within w_kgla20
end type
type dw_detail from u_key_enter within w_kgla20
end type
type dw_mvat from datawindow within w_kgla20
end type
type rr_1 from roundrectangle within w_kgla20
end type
end forward

global type w_kgla20 from w_inherite
integer height = 2564
string title = "부가세 등록"
dw_cond dw_cond
dw_lst dw_lst
dw_detail dw_detail
dw_mvat dw_mvat
rr_1 rr_1
end type
global w_kgla20 w_kgla20

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_change_junpoy (string smod, string ssaupj, string sbaldate, string supmugu, long lbjunno, integer ilinno, string saccdate, long ljunno)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sGeyDate,sVatGisu,sJasaCode,sIoGbn,sTaxGbn,sCvname,sSano,sOwnam,sUptae,sUpjong,sAddr,sExpNo,sBalNm,&
		  sRfna3,sRfna2,sResi,sJasanGbn,sVatGbn,sTax14Cd
Double  dVatAmt,dGonAmt

String sAcc1,sAcc2,sSaupNo,sAlcGbn,sAccDate,sVoucGbn,sBdsNo
Long   lSeqNo

dw_detail.AcceptText()
//lSeqNo   = dw_detail.GetItemNumber(dw_detail.GetRow(),"seq_no")

sGeyDate  = dw_detail.GetItemString(icurrow,"gey_dd")
sVatGisu  = dw_detail.GetItemString(icurrow,"vatgisu")
sJasaCode = dw_detail.GetItemString(icurrow,"jasa_cd") 
sVatGbn   = dw_detail.GetItemString(icurrow,"vatgbn")

sAcc1     = dw_detail.GetItemString(icurrow,"acc1_cd") 
sAcc2     = dw_detail.GetItemString(icurrow,"acc2_cd") 

sSaupNo   = dw_detail.GetItemString(icurrow,"saup_no") 

sCvname   = dw_detail.GetItemString(icurrow,"cvnas") 
sSano     = dw_detail.GetItemString(icurrow,"saup_no2") 
sOwnam    = dw_detail.GetItemString(icurrow,"ownam")
sResi     = Trim(dw_detail.GetItemString(icurrow,"resident"))
sUptae    = dw_detail.GetItemString(icurrow,"uptae") 
sUpjong   = dw_detail.GetItemString(icurrow,"jongk") 
sAddr     = dw_detail.GetItemString(icurrow,"addr1") 

sIoGbn    = dw_detail.GetItemString(icurrow,"io_gu") 
sTaxGbn   = dw_detail.GetItemString(icurrow,"tax_no") 

sExpNo    = dw_detail.GetItemString(icurrow,"expno") 
sVoucGbn  = dw_detail.GetItemString(icurrow,"vouc_gu") 
sBalNm    = dw_detail.GetItemString(icurrow,"ownplace") 
dVatAmt   = dw_detail.GetItemNumber(icurrow,"vat_amt") 
dGonAmt   = dw_detail.GetItemNumber(icurrow,"gon_amt")
sJasanGbn = dw_detail.GetItemString(icurrow,"addr2") 

sBdsNo    = dw_detail.GetItemString(icurrow,"bu_code")
sTax14Cd  = dw_detail.GetItemString(icurrow,"tax14_cd")

//IF lSeqNo = 0 OR IsNull(lSeqNo) THEN 
//	F_MessageChk(1,'[계산서번호]')
//	dw_detail.SetColumn("seq_no")
//	dw_detail.SetFocus()
//	Return -1
//END IF

IF sGeyDate = "" OR IsNull(sGeyDate) THEN 
	F_MessageChk(1,'[계산서일자]')
	dw_detail.SetColumn("gey_dd")
	dw_detail.SetFocus()
	Return -1
END IF

IF sVatGisu = "" OR IsNull(sVatGisu) THEN 
	F_MessageChk(1,'[부가세기수]')
	dw_detail.SetColumn("vatgisu")
	dw_detail.SetFocus()
	Return -1
END IF

IF sJasaCode = "" OR IsNull(sJasaCode) THEN 
	F_MessageChk(1,'[자사코드]')
	dw_detail.SetColumn("jasa_cd")
	dw_detail.SetFocus()
	Return -1
END IF

IF sAcc1 = "" OR IsNull(sAcc1) THEN 
	F_MessageChk(1,'[계정과목]')
	dw_detail.SetColumn("acc1_cd")
	dw_detail.SetFocus()
	Return -1
END IF

IF sAcc2 = "" OR IsNull(sAcc2) THEN 
	F_MessageChk(1,'[계정과목]')
	dw_detail.SetColumn("acc2_cd")
	dw_detail.SetFocus()
	Return -1
END IF

IF sSaupNo = "" OR IsNull(sSaupNo) THEN 
	F_MessageChk(1,'[거래처]')
	dw_detail.SetColumn("saup_no")
	dw_detail.SetFocus()
	Return -1
END IF

IF sCvname = "" OR IsNull(sCvname) THEN 
	F_MessageChk(1,'[거래처명]')
	dw_detail.SetColumn("cvnas")
	dw_detail.SetFocus()
	Return -1
END IF
//IF sOwnam = "" OR IsNull(sOwnam) THEN 
//	F_MessageChk(1,'[대표자명]')
//	dw_detail.SetColumn("ownam")
//	dw_detail.SetFocus()
//	Return -1
//END IF
IF (sSano = "" OR IsNull(sSano)) AND sTaxGbn <> '22' AND sTaxGbn <> '23' AND sTaxGbn <> '24' THEN  
	F_MessageChk(1,'[사업자등록번호]')
	dw_detail.SetColumn("saup_no2")
	dw_detail.SetFocus()
	Return -1
END IF

//IF sUptae = "" OR IsNull(sUptae) THEN 
//	F_MessageChk(1,'[업태]')
//	dw_detail.SetColumn("uptae")
//	dw_detail.SetFocus()
//	Return -1
//END IF
//
//IF sUpjong = "" OR IsNull(sUpjong) THEN 
//	F_MessageChk(1,'[업종]')
//	dw_detail.SetColumn("jongk")
//	dw_detail.SetFocus()
//	Return -1
//END IF
//IF sAddr = "" OR IsNull(sAddr) THEN 
//	F_MessageChk(1,'[주소]')
//	dw_detail.SetColumn("addr1")
//	dw_detail.SetFocus()
//	Return -1
//END IF

IF sIoGbn = "" OR IsNull(sIoGbn) THEN 
	F_MessageChk(1,'[매입매출구분]')
	dw_detail.SetColumn("io_gu")
	dw_detail.SetFocus()
	Return -1
END IF
IF sTaxGbn = "" OR IsNull(sTaxGbn) THEN 
	F_MessageChk(1,'[부가세구분]')
	dw_detail.SetColumn("tax_no")
	dw_detail.SetFocus()
	Return -1
ELSE
	IF sTaxGbn = '23' THEN					/*수출면장*/
		if sExpNo = '' or IsNull(sExpNo) then
			F_MessageChk(1,'[수출신고번호]')
			dw_detail.SetColumn("expno")
			dw_detail.SetFocus()
			Return -1
		end if
		if sVoucGbn = '' or IsNull(sVoucGbn) then
			F_MessageChk(1,'[영세율증빙]')
			dw_detail.SetColumn("vouc_gu")
			dw_detail.SetFocus()
			Return -1
		end if
	ELSEIF sTaxGbn = '24' THEN
		if sVoucGbn = '' or IsNull(sVoucGbn) then
			F_MessageChk(1,'[영세율증빙]')
			dw_detail.SetColumn("vouc_gu")
			dw_detail.SetFocus()
			Return -1
		end if
		if sBalNm = '' or IsNull(sBalNm) then
			F_MessageChk(1,'[증빙발급자]')
			dw_detail.SetColumn("ownplace")
			dw_detail.SetFocus()
			Return -1
		end if
	END IF
	
	if sTaxGbn = '14' AND (sTax14Cd = '' or IsNull(sTax14Cd)) then
		F_MessageChk(1,'[불공제구분]')
		dw_detail.SetColumn("tax14_cd")
		dw_detail.SetFocus()
		Return -1
	end if
		
END IF

IF sVatGbn = "3" AND (sBdsNo = '' or IsNull(sBdsNo)) then
	F_MessageChk(1,'[부동산번호]')
	dw_detail.SetColumn("bu_code")
	dw_detail.SetFocus()
	Return -1
END IF

IF dVatAmt = 0 OR IsNull(dVatAmt) THEN
	Select NVL(rfna3,'N')
	  Into :sRfna3
	  From reffpf
	 Where rfcod = 'AT'
	   And rfgub = :sTaxGbn;
	IF SQLCA.sqlcode <> 0 THEN
		Messagebox("확인", "세액=0 허용여부를 알수 없습니다")
		dw_detail.SetColumn("vat_amt")
		dw_detail.SetFocus()
		Return -1
	END IF
	
	IF sRfna3 <> "Y" THEN
		F_MessageChk(1,'[세액]')
		dw_detail.SetColumn("vat_amt")
		dw_detail.SetFocus()
		Return -1
	END IF
END IF

IF dGonAmt = 0 OR IsNull(dGonAmt) THEN
	F_MessageChk(1,'[공급가액]')
	dw_detail.SetColumn("gon_amt")
	dw_detail.SetFocus()
	Return -1
END IF

//참조코드 Table의 rfna2가 1인 경우 사업자번호 필수
IF f_vendcode_check(sSano) = False THEN
	Select rfna2
	  Into :sRfna2
	  From reffpf
	 Where rfcod = 'AT'
	   And rfgub <> '00'
		And rfgub = :sTaxGbn;

	IF SQLCA.sqlcode <> 0 THEN
		Messagebox("확인", "사업자번호 필수입력 여부 검색 오류입니다")
		dw_detail.SetColumn("saup_no")
		dw_detail.SetFocus()
		Return -1
	END IF
	
	IF sTaxGbn = "22" THEN
		IF Isnull(sResi) Or Len(sResi) = 0 Then
			F_MessageChk(1,'[주민등록번호]')
			dw_detail.SetColumn("saup_no")
			dw_detail.SetFocus()
			Return -1
		END IF
	ELSE
		IF sRfna2 = "1" THEN
			F_MessageChk(1,'[사업자번호]')
			dw_detail.SetColumn("saup_no")
			dw_detail.SetFocus()
			Return -1
		END IF
	END IF
	
END IF

Return 1
end function

public function integer wf_change_junpoy (string smod, string ssaupj, string sbaldate, string supmugu, long lbjunno, integer ilinno, string saccdate, long ljunno);Integer inumrows,iVatCnt,iLin
Long    lJpyNo,lTmpNo,lAcNo
String  sAlcGbn,sVatGbn,sAcDt

iLin = iLinNo
sAcDt = sAccDate
lAcNo = lJunNo
lJpyNo = lbjunno

iVatCnt = dw_mvat.Retrieve(sSaupj,sBalDate,sUpmuGu,lbJunNo,iLin,1)		/*미결부가세 여부*/

select count(*)	into :inumrows
	from kfz12ot0
	where saupj = :ssaupj and bal_date = :sbaldate and upmu_gu  = :supmugu and bjun_no = :lbjunno and lin_no = :iLin ; 

if sMod = 'I' then
	if inumrows <=0 then
		select max(bjun_no)	into :lTmpNo from kfz17ot0
			where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu ;
		if sqlca.sqlcode = 0 then
			if IsNull(lTmpNo) then lTmpNo = 0
		else
			lTmpNo = 0
		end if
		if lTmpNo = 0 or lTmpNo < 5000 then
			lTmpNo = 4999
		end if
		
		lJpyNo  = lTmpNo + 1
		iVatCnt = 0	
		iLin = 1
		sAcDt = sBalDate
		lAcNo = lJpyNo
		
		inumrows = 0
		sAlcGbn = 'N';		sVatGbn = 'N';		
	end if
else
	select count(*), 		min(kfz12ot0.alc_gu), kfz01om0.vat_gu		
		into :inumrows,	:sAlcGbn,				 :sVatGbn	
		from kfz12ot0,kfz01om0
		where kfz12ot0.acc1_cd = kfz01om0.acc1_cd and
				kfz12ot0.acc2_cd = kfz01om0.acc2_cd and
				kfz12ot0.saupj    = :ssaupj    and kfz12ot0.bal_date = :sbaldate and 
				kfz12ot0.upmu_gu  = :supmugu and kfz12ot0.bjun_no = :lbjunno and 
				kfz12ot0.lin_no   = :iLin
		group by kfz01om0.vat_gu;
	if sqlca.sqlcode <> 0 then
		inumrows = 0
	else
		if isNull(inumrows) then inumrows = 0
	end if
	
end if

if sMod = 'I' OR sMod = 'M' then
	if sMod = 'I' then
		dw_detail.SetItem(dw_detail.GetRow(), "bal_date", sBalDate)
		dw_detail.SetItem(dw_detail.GetRow(), "acc_date", sAcDt)
		dw_detail.SetItem(dw_detail.GetRow(), "bjun_no",  lJpyNo)
		dw_detail.SetItem(dw_detail.GetRow(), "lin_no",   iLin)
		dw_detail.SetItem(dw_detail.GetRow(), "seq_no",   1)
		dw_detail.SetItem(dw_detail.GetRow(), "jun_no",   lAcNo)
	end if
	
	if iVatCnt <= 0 then				/*미결부가세 있으면*/
		iVatCnt = dw_mvat.InsertRow(0)
		
		dw_mvat.SetItem(iVatCnt,"saupj",       sSaupj)
		dw_mvat.SetItem(iVatCnt,"bal_date",    sBalDate)
		dw_mvat.SetItem(iVatCnt,"upmu_gu",     'A')
		dw_mvat.SetItem(iVatCnt,"bjun_no",     lJpyNo)
		dw_mvat.SetItem(iVatCnt,"lin_no",      iLin)
		dw_mvat.SetItem(iVatCnt,"seq_no",      1)
		dw_mvat.SetItem(iVatCnt,"acc_date",    sAcDt)
		dw_mvat.SetItem(iVatCnt,"jun_no",      lAcNo)
	END IF
	
	dw_mvat.SetItem(iVatCnt,"gey_date",    dw_detail.GetItemString(dw_detail.GetRow(),"gey_date"))
	dw_mvat.SetItem(iVatCnt,"saup_no",     dw_detail.GetItemString(dw_detail.GetRow(),"saup_no"))
	dw_mvat.SetItem(iVatCnt,"gon_amt",     dw_detail.GetItemNumber(dw_detail.GetRow(),"gon_amt"))
	dw_mvat.SetItem(iVatCnt,"vat_amt",     dw_detail.GetItemNumber(dw_detail.GetRow(),"vat_amt"))
	dw_mvat.SetItem(iVatCnt,"tax_no",      dw_detail.GetItemString(dw_detail.GetRow(),"tax_no"))
	dw_mvat.SetItem(iVatCnt,"io_gu",       dw_detail.GetItemString(dw_detail.GetRow(),"io_gu"))
	dw_mvat.SetItem(iVatCnt,"saup_no2",    dw_detail.GetItemString(dw_detail.GetRow(),"saup_no2"))
	dw_mvat.SetItem(iVatCnt,"acc1_cd",     dw_detail.GetItemString(dw_detail.GetRow(),"acc1_cd"))
	dw_mvat.SetItem(iVatCnt,"acc2_cd",     dw_detail.GetItemString(dw_detail.GetRow(),"acc2_cd"))
	dw_mvat.SetItem(iVatCnt,"descr",       dw_detail.GetItemString(dw_detail.GetRow(),"descr"))
	dw_mvat.SetItem(iVatCnt,"jasa_cd",     dw_detail.GetItemString(dw_detail.GetRow(),"jasa_cd"))
	dw_mvat.SetItem(iVatCnt,"vouc_gu",     dw_detail.GetItemString(dw_detail.GetRow(),"vouc_gu"))
	dw_mvat.SetItem(iVatCnt,"lc_no",       dw_detail.GetItemString(dw_detail.GetRow(),"lc_no"))
	dw_mvat.SetItem(iVatCnt,"for_amt",     dw_detail.GetItemNumber(dw_detail.GetRow(),"for_amt"))

	dw_mvat.SetItem(iVatCnt,"sano",        dw_detail.GetItemString(dw_detail.GetRow(),"sano"))
	dw_mvat.SetItem(iVatCnt,"cvnas",       dw_detail.GetItemString(dw_detail.GetRow(),"cvnas"))
	dw_mvat.SetItem(iVatCnt,"ownam",       dw_detail.GetItemString(dw_detail.GetRow(),"ownam"))
	dw_mvat.SetItem(iVatCnt,"resident",    dw_detail.GetItemString(dw_detail.GetRow(),"resident"))
	dw_mvat.SetItem(iVatCnt,"uptae",       dw_detail.GetItemString(dw_detail.GetRow(),"uptae"))
	dw_mvat.SetItem(iVatCnt,"jongk",       dw_detail.GetItemString(dw_detail.GetRow(),"jongk"))
	dw_mvat.SetItem(iVatCnt,"addr1",       dw_detail.GetItemString(dw_detail.GetRow(),"addr1"))
	dw_mvat.SetItem(iVatCnt,"addr2",       dw_detail.GetItemString(dw_detail.GetRow(),"addr2"))
	dw_mvat.SetItem(iVatCnt,"vatgisu",     dw_detail.GetItemString(dw_detail.GetRow(),"vatgisu"))
	dw_mvat.SetItem(iVatCnt,"exc_rate",    dw_detail.GetItemNumber(dw_detail.GetRow(),"exc_rate"))
	dw_mvat.SetItem(iVatCnt,"vatgbn",      dw_detail.GetItemString(dw_detail.GetRow(),"vatgbn"))
	dw_mvat.SetItem(iVatCnt,"taxgbn",      dw_detail.GetItemString(dw_detail.GetRow(),"taxgbn"))
	dw_mvat.SetItem(iVatCnt,"tax14_cd",    dw_detail.GetItemString(dw_detail.GetRow(),"tax14_cd"))
	dw_mvat.SetItem(iVatCnt,"elegbn",    	dw_detail.GetItemString(dw_detail.GetRow(),"elegbn"))
	dw_mvat.SetItem(iVatCnt,"send_date",    dw_detail.GetItemString(dw_detail.GetRow(),"send_date"))
	
	if inumrows > 0 then
		update kfz12ot0
			set vat_gu = 'Y'
			where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
					bjun_no = :lbjunno   and lin_no   = :ilinno ;
		if sAlcGbn = 'Y' then
			update kfz10ot0
				set vat_gu = 'Y'
				where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
						bjun_no = :ljunno and lin_no   = :ilinno ;
		end if
	end if
elseif sMod = 'D' then
	IF sVatGbn = 'Y' AND inumrows > 0 THEN
		MessageBox("확 인","전표가 존재하므로 삭제할 수 없습니다.!!")
		Return -1
	else
		dw_mvat.DeleteRow(iVatCnt)
		
		update kfz12ot0
			set vat_gu = 'N'
			where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
					bjun_no = :lbjunno   and lin_no   = :ilinno ;
		if sAlcGbn = 'Y' then
			update kfz10ot0
				set vat_gu = 'N'
				where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
						bjun_no = :ljunno and lin_no   = :ilinno ;
		end if
	end if
end if
					
Return 1
end function

on w_kgla20.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_lst=create dw_lst
this.dw_detail=create dw_detail
this.dw_mvat=create dw_mvat
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_mvat
this.Control[iCurrent+5]=this.rr_1
end on

on w_kgla20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_lst)
destroy(this.dw_detail)
destroy(this.dw_mvat)
destroy(this.rr_1)
end on

event open;call super::open;String  sJasa
DataWindowChild  Dw_Child
Integer          iVal

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()

iVal = dw_cond.GetChild("tax_no",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve('1') <=0 then
		dw_child.InsertRow(0)
	end if
END IF

dw_cond.InsertRow(0)

select rfna2 into :sJasa from reffpf where rfcod = 'AD' and rfgub = :Gs_Saupj ;

dw_cond.SetItem(1,"saupj",  Gs_Saupj)
dw_cond.SetItem(1,"jasa_cd",sJasa)
dw_cond.SetItem(1,"gym",    Left(F_today(),6))

dw_lst.SetTransObject(SQLCA)
dw_lst.Reset()

dw_detail.SetTransObject(SQLCA)
dw_mvat.SetTransObject(SQLCA)

dw_detail.ShareData(dw_lst)

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_ins.Enabled = False

end event

type dw_insert from w_inherite`dw_insert within w_kgla20
boolean visible = false
integer x = 750
integer y = 2432
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla20
boolean visible = false
integer x = 3826
integer y = 3248
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgla20
boolean visible = false
integer x = 3643
integer y = 3244
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgla20
boolean visible = false
integer x = 3269
integer y = 3252
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgla20
integer x = 3712
integer y = 4
integer taborder = 50
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;Integer iCurRow

if dw_lst.GetRow() > 0 then
	if Wf_RequiredChk(dw_lst.GetRow()) = -1 then Return
end if

sModStatus = 'I'

dw_lst.SetRedraw(False)

iCurRow = dw_lst.InsertRow(0)

dw_lst.SetItem(iCurRow,"jasa_cd",   dw_cond.GetItemString(1,"jasa_cd"))
dw_lst.SetItem(iCurRow,"saupj",     dw_cond.GetItemString(1,"saupj"))
dw_lst.SetItem(iCurRow,"io_gu",     dw_cond.GetItemString(1,"io_gu"))
dw_lst.SetItem(iCurRow,"tax_no",    dw_cond.GetItemString(1,"tax_no"))
dw_lst.SetItem(iCurRow,"bill_gu",    dw_cond.GetItemString(1,"io_gu"))	

dw_lst.SetItem(iCurRow,"vatgisu",  F_Get_VatGisu(dw_cond.GetItemString(1,"saupj"),dw_cond.GetItemString(1,"gym")+'01'))

dw_lst.SetItem(iCurRow,"gey_dd",   Right(F_Today(),2))
dw_lst.SetItem(iCurRow,"gey_date", dw_cond.GetItemString(1,"gym")+Right(F_Today(),2))
dw_lst.SetItem(iCurRow,"bal_date", dw_cond.GetItemString(1,"gym")+Right(F_Today(),2))
dw_lst.SetItem(iCurRow,"acc_date", dw_cond.GetItemString(1,"gym")+Right(F_Today(),2))
dw_lst.SetItem(iCurRow,"sflag",    sModStatus)
dw_lst.ScrollToRow(iCurRow)

dw_lst.SetRedraw(True)

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(iCurRow,True)

dw_lst.ScrollToRow(iCurRow)

dw_detail.SetColumn("gey_dd")
dw_detail.SetFocus()

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_ins.Enabled = False





end event

type p_exit from w_inherite`p_exit within w_kgla20
integer x = 4411
integer y = 4
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kgla20
integer x = 4238
integer y = 4
integer taborder = 80
end type

event p_can::clicked;call super::clicked;String           sJasa,sIo,sSaupj,sGym,sTaxNo

sJasa  = dw_cond.GetItemString(1,"jasa_cd")
sIo    = dw_cond.GetItemString(1,"io_gu")
sSaupj = dw_cond.GetItemString(1,"saupj")
sGym   = Trim(dw_cond.GetItemString(1,"gym"))
sTaxNo = dw_cond.GetItemString(1,"tax_no")

dw_lst.Retrieve(sJasa,sIo,sGym,sTaxNo)

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_kgla20
boolean visible = false
integer x = 3465
integer y = 3240
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgla20
integer x = 3538
integer y = 4
end type

event p_inq::clicked;call super::clicked;String           sJasa,sIo,sSaupj,sGym,sTaxNo
DataWindowChild  Dw_Child
Integer          iVal

if dw_cond.AcceptText() = -1 then Return

sJasa  = dw_cond.GetItemString(1,"jasa_cd")
sIo    = dw_cond.GetItemString(1,"io_gu")
sSaupj = dw_cond.GetItemString(1,"saupj")
sGym   = Trim(dw_cond.GetItemString(1,"gym"))
sTaxNo = dw_cond.GetItemString(1,"tax_no")

if sJasa = '' or IsNull(sJasa) then
	F_MessageChk(1,'[자사]')
	dw_cond.SetColumn("jasa_cd")
	dw_cond.SetFocus()
	Return
end if

if sGym = '' or IsNull(sGym) then
	F_MessageChk(1,'[계산서년월]')
	dw_cond.SetColumn("gym")
	dw_cond.SetFocus()
	Return
end if
IF sTaxNo = '' or IsNull(sTaxNo) then sTaxNo = '%'

iVal = dw_lst.GetChild("vatgbn",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sJasa) <=0 then
		dw_child.InsertRow(0)
	end if
END IF

iVal = dw_lst.GetChild("tax_no",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sIo) <=0 then
		dw_child.InsertRow(0)
	end if
END IF
	
iVal = dw_detail.GetChild("vatgbn",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sJasa) <=0 then
		dw_child.InsertRow(0)
	end if
END IF

iVal = dw_detail.GetChild("tax_no",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sIo) <=0 then
		dw_child.InsertRow(0)
	end if
END IF

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_ins.Enabled = True

if dw_lst.Retrieve(sJasa,sIo,sGym,sTaxNo) <=0 then
	F_MessageChk(14,'')
	Return
end if

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(1,True)
dw_lst.ScrollToRow(1)

dw_detail.ScrollToRow(1)

dw_lst.SetFocus()
end event

type p_del from w_inherite`p_del within w_kgla20
integer x = 4064
integer y = 4
integer taborder = 70
end type

event p_del::clicked;call super::clicked;Integer iRow

iRow = dw_detail.GetRow()

IF iRow <=0 THEN Return

IF F_DbConFirm("삭제") = 2 THEN Return

IF Wf_Change_JunPoy('D',												&
						dw_detail.GetItemString(iRow,"saupj"),		&
						dw_detail.GetItemString(iRow,"bal_date"),	&
						dw_detail.GetItemString(iRow,"upmu_gu"),	&
						dw_detail.GetItemNumber(iRow,"bjun_no"),	&
						dw_detail.GetItemNUmber(iRow,"lin_no"),   &
						dw_detail.GetItemString(iRow,"acc_date"),	&
						dw_detail.GetItemNumber(iRow,"jun_no")) = -1 THEN
	Rollback;
	Return
END IF

dw_detail.SetRedraw(False)
dw_detail.DeleteRow(0)
IF dw_detail.Update() <> 1 THEN
	F_MessageChk(12,'')
	Rollback;
	dw_detail.SetRedraw(True)
	Return
else
	IF dw_mvat.Update() <> 1 THEN
		F_MessageChk(12,'[미결부가세]')
		Rollback;
		Return
	END IF
END IF
dw_detail.SetRedraw(True)
commit;

if iRow <> 1 then
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(iRow - 1,True)
	
	dw_detail.ScrollToRow(iRow - 1)
end if

dw_lst.SetFocus()

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_ins.Enabled = True

ib_any_typing = False

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'
end event

type p_mod from w_inherite`p_mod within w_kgla20
integer x = 3890
integer y = 4
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;
IF dw_detail.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_detail.GetRow()) = -1 THEN Return

IF Wf_Change_JunPoy(dw_detail.GetItemString(dw_detail.GetRow(),"sflag"),	&
						dw_detail.GetItemString(dw_detail.GetRow(),"saupj"),		&
						dw_detail.GetItemString(dw_detail.GetRow(),"gey_date"),	&
						dw_detail.GetItemString(dw_detail.GetRow(),"upmu_gu"),		&
						dw_detail.GetItemNumber(dw_detail.GetRow(),"bjun_no"),		&
						dw_detail.GetItemNUmber(dw_detail.GetRow(),"lin_no"),   &
						dw_detail.GetItemString(dw_detail.GetRow(),"acc_date"),	&
						dw_detail.GetItemNumber(dw_detail.GetRow(),"jun_no")) = -1 THEN
	Rollback;
	Return
END IF
	
IF F_DbConFirm("저장") = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
ELSE
	IF dw_mvat.Update() <> 1 THEN
		F_MessageChk(13,'[미결부가세]')
		Rollback;
		Return
	END IF
END IF

commit;

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_ins.Enabled = True

ib_any_typing = False

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_kgla20
end type

type cb_mod from w_inherite`cb_mod within w_kgla20
end type

type cb_ins from w_inherite`cb_ins within w_kgla20
end type

type cb_del from w_inherite`cb_del within w_kgla20
end type

type cb_inq from w_inherite`cb_inq within w_kgla20
end type

type cb_print from w_inherite`cb_print within w_kgla20
end type

type st_1 from w_inherite`st_1 within w_kgla20
end type

type cb_can from w_inherite`cb_can within w_kgla20
end type

type cb_search from w_inherite`cb_search within w_kgla20
end type







type gb_button1 from w_inherite`gb_button1 within w_kgla20
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla20
end type

type dw_cond from u_key_enter within w_kgla20
integer x = 18
integer y = 12
integer width = 3483
integer height = 144
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kgla201"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String sJasa,sSaupj
DataWindowChild  Dw_Child
Integer          iVal

if this.GetColumnName() = 'jasa_cd' then
	sJasa = this.GetText()
	if sJasa = '' or IsNull(sJasa) then Return
	
	select rfna3 into :sSaupj from reffpf where rfcod = 'JA' and rfgub = :sJasa;
	
	this.SetItem(this.GetRow(),"saupj", sSaupj)
end if

if this.GetColumnName() = 'io_gu' then
	if this.GetText() = '' or IsNull(this.GetText()) then Return
	
	iVal = this.GetChild("tax_no",Dw_Child)
	IF iVal = 1 THEN
		dw_child.SetTransObject(Sqlca)
		if dw_child.Retrieve(this.GetText()) <=0 then
			dw_child.InsertRow(0)
		end if
	END IF
end if

dw_lst.Reset()

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_ins.Enabled = False
end event

type dw_lst from u_d_popup_sort within w_kgla20
integer x = 41
integer y = 172
integer width = 4530
integer height = 1456
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kgla202"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False

	SelectRow(0,False)
	SelectRow(row,True)
	
	dw_detail.ScrollToRow(row)
END IF

CALL SUPER ::CLICKED

dw_detail.ScrollToRow(this.GetSelectedRow(0))

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then Return

SelectRow(0,False)
SelectRow(currentrow,True)

dw_detail.ScrollToRow(currentrow)
end event

event retrieveend;call super::retrieveend;Integer k

if rowcount <=0 then return

for k = 1 to rowcount
	this.SetItem(k, "sflag", 'M')	
next
end event

type dw_detail from u_key_enter within w_kgla20
integer x = 27
integer y = 1648
integer width = 4581
integer height = 712
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgla203"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

event itemchanged;call super::itemchanged;String  sGeyDd,sVatGisu,sJasaCode,sAcc1_cd,sAcc2_cd,sAccName,sSaupNo,sCvName,sCustGbn,sSano,sUpTae,&
		  sUpJong,sOwnam,sResident,sAddr,sIoGbn,sTaxGbn,sVocuGbn,sNull,sVatGbn,sGetJong,sCardNo,sOwner
Integer iCurRow,lJunNo,lLinNo,lBJunNo,lSeqNo,lNull
Double  dVatAmt,dQty,dUprice
String  sGeyYm,sBuCode,sRentNm

SetNull(sNull)
SetNull(lNull)

iCurRow = this.GetRow()

IF this.GetColumnName() ="gey_dd" THEN
	sGeyDd = Trim(this.GetText())
	IF sGeyDd = "" OR IsNull(sGeyDd) THEN RETURN
	
	IF IsNumber(sGeyDd) = False THEN 
		F_MessageChk(21,'[계산서일자]')
		this.SetItem(iCurRow,"gey_dd",sNull)
		Return 1
	ELSE
		sGeyYm = dw_cond.GetItemString(1,"gym")
		
		IF F_DateChk(sGeyYm+sGeyDd) = -1 THEN 
			F_MessageChk(21,'[계산서일자]')
			this.SetItem(iCurRow,"gey_dd",sNull)
			Return 1
		END IF
		this.SetItem(iCurRow,"gey_date", sGeyYm+sGeyDd)
		this.SetItem(iCurRow,"vatgisu",  F_Get_VatGisu(dw_cond.GetItemString(1,"saupj"),sGeyYm+sGeyDd))
	END IF	
END IF

IF this.GetColumnName() ="send_date" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN RETURN	
	
	IF F_DateChk(data) = -1 THEN 
		F_MessageChk(21,'[전송일자]')
		this.SetItem(iCurRow,"send_date",sNull)
		Return 1
	END IF
		
END IF
IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		dw_detail.SetItem(iCurRow,"vatgisu",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jasa_cd" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN Return
	
	IF IsNull(F_Get_Refferance('JA',sJasaCode)) THEN
		F_MessageChk(20,'[자사코드]')
		dw_detail.SetItem(iCurRow,"jasa_cd",sNull)
		Return 1
	END IF
	
	DataWindowChild  Dw_Child
	Integer          iVal

	iVal = dw_detail.GetChild("vatgbn",Dw_Child)
	IF iVal = 1 THEN
		dw_child.SetTransObject(Sqlca)
		if dw_child.Retrieve(sJasaCode) <=0 then
			dw_child.InsertRow(0)
		end if
	END IF
END IF

IF this.GetColumnName() ="vatgbn" THEN
	sVatGbn = this.GetText()
	IF sVatGbn ="" OR IsNull(sVatGbn) THEN Return
	
	sJasaCode = this.GetItemString(iCurRow,"jasa_cd")
	IF sJasaCode ="" OR IsNull(sJasaCode) THEN Return
	
	select rfna1	into :sGetJong	from reffpf 
		where rfcod = 'AW' and substr(rfgub,3,1) = :sVatGbn and rfna5 = :sJasaCode;
	IF Sqlca.sqlcode <> 0 THEN
		F_MessageChk(20,'[업종구분]')
		this.SetItem(iCurRow,"vatgbn",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(iCurRow,"acc2_cd",sNull)
		this.SetItem(iCurRow,"acc2_nm",sNull)
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",sNull)
		this.SetItem(iCurRow,"acc2_cd",sNull)
		this.SetItem(iCurRow,"acc2_nm",sNull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"acc2_nm",sAccName)
	END IF
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(iCurRow,"acc1_cd",sNull)
		this.SetItem(iCurRow,"acc2_nm",sNull)
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",sNull)
		this.SetItem(iCurRow,"acc2_cd",sNull)
		this.SetItem(iCurRow,"acc2_nm",sNull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		this.SetItem(iCurRow,"acc2_nm",sAccName)
	END IF
END IF

IF this.GetColumnName() = "saup_no" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(iCurRow,"custflag",'N')						/*거래처 직접 입력 불가*/
		
		this.SetItem(iCurRow,"cvnas",   sNull)
		this.SetItem(iCurRow,"saup_no2",sNull)
		this.SetItem(iCurRow,"ownam",   sNull)
		this.SetItem(iCurRow,"uptae",   sNull)
		this.SetItem(iCurRow,"jongk",   sNull)
		this.SetItem(iCurRow,"addr1",   sNull)
		this.SetItem(iCurRow,"resident",sNull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_GU",	"VNDMST"."CVNAS",	   	"VNDMST"."SANO", 
			 "VNDMST"."UPTAE",   		"VNDMST"."JONGK",   		"VNDMST"."OWNAM",
			 "VNDMST"."RESIDENT",   	NVL("VNDMST"."ADDR1",'')||NVL("VNDMST"."ADDR2",'')  
	   INTO :sCustGbn,					:sCvName,   				:sSano,
		     :sUptae,   					:sUpJong,   				:sOwnam,   
			  :sResident,   				:sAddr 
	   FROM "KFZ04OM0","VNDMST"  
   	WHERE ("KFZ04OM0"."PERSON_CD" = "VNDMST"."CVCOD") AND
				( "KFZ04OM0"."PERSON_CD" = :sSaupNo);
	IF SQLCA.SQLCODE = 0 THEN
		IF sCustGbn = '99' THEN
			this.SetItem(iCurRow,"custflag",'Y')
		ELSE
			this.SetItem(iCurRow,"custflag",'N')
		END IF
		this.SetItem(iCurRow,"cvnas",   sCvName)
		this.SetItem(iCurRow,"saup_no2",sSano)
		this.SetItem(iCurRow,"ownam",  sOwNam)
		this.SetItem(iCurRow,"uptae",   sUptae)
		this.SetItem(iCurRow,"jongk",   sUpjong)
		this.SetItem(iCurRow,"addr1",   sAddr)
		this.SetItem(iCurRow,"resident",sResident)
	ELSE
		F_MessageChk(20,'[거래처]')
		
		this.SetItem(iCurRow,"custflag",'Y')						/*거래처 직접 입력 불가*/
		
		this.SetItem(iCurRow,"saup_no", sNull)
		this.SetItem(iCurRow,"cvnas",   sNull)
		this.SetItem(iCurRow,"saup_no2",sNull)
		this.SetItem(iCurRow,"ownam",   sNull)
		this.SetItem(iCurRow,"uptae",   sNull)
		this.SetItem(iCurRow,"jongk",   sNull)
		this.SetItem(iCurRow,"addr1",   sNull)
		this.SetItem(iCurRow,"resident",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "saup_no2" THEN					/*사업자번호 입력시 기존자료 가져오기*/
	sSano = this.GetText()
	IF sSano = "" OR IsNull(sSano) THEN Return
	
	SELECT DISTINCT "KFZ17OT0"."CVNAS",   "KFZ17OT0"."OWNAM",       "KFZ17OT0"."RESIDENT",         "KFZ17OT0"."UPTAE",   
			          "KFZ17OT0"."JONGK",   "KFZ17OT0"."ADDR1"  
		INTO :sCvName,   				        :sOwnam,   					 :sResident,   				        :sUptae,   
			  :sUpJong,   					     :sAddr  
		FROM "KFZ17OT0"  
		WHERE "KFZ17OT0"."SAUP_NO2" = :sSano;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(iCurRow,"cvnas",   sCvName)
		this.SetItem(iCurRow,"resident",sResident)		
		this.SetItem(iCurRow,"ownam",   sOwNam)
		this.SetItem(iCurRow,"uptae",   sUptae)
		this.SetItem(iCurRow,"jongk",   sUpjong)
		this.SetItem(iCurRow,"addr1",   sAddr)
	ELSE
		this.SetItem(iCurRow,"cvnas",   sNull)
		this.SetItem(iCurRow,"resident",sNull)		
		this.SetItem(iCurRow,"ownam",   sNull)
		this.SetItem(iCurRow,"uptae",   sNull)
		this.SetItem(iCurRow,"jongk",   sNull)
		this.SetItem(iCurRow,"addr1",   sNull)
	END IF
END IF

IF this.GetColumnName() ="tax_no" THEN
	sTaxGbn = this.GetText()
	IF sTaxGbn ="" OR IsNull(sTaxGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sTaxGbn)) THEN
		F_MessageChk(20,'[부가세구분]')
		dw_detail.SetItem(iCurRow,"tax_no",sNull)
		Return 1
	END IF
	dw_detail.SetItem(iCurRow,"io_gu",Left(sTaxGbn,1))
	
END IF

IF this.GetColumnName() ="cardno" THEN
	sCardNo = this.GetText()
	IF sCardNo = "" OR IsNull(sCardNo) THEN Return
	
	SELECT "KFZ05OM0"."OWNER"   	INTO :sOwner
	  	FROM "KFZ05OM0"  
   	WHERE "KFZ05OM0"."CARD_NO" = :sCardNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[카드번호]')
		this.SetItem(iCurRow,"cardno",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="vouc_gu" THEN
	sVocuGbn = this.GetText()
	IF sVocuGbn ="" OR IsNull(sVocuGbn) THEN RETURN 
	
	IF IsNull(F_Get_Refferance('AU',sVocuGbn)) THEN
		F_MessageChk(20,'[영세율증빙구분]')
		dw_detail.SetItem(iCurRow,"vouc_gu",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="vat_amt" THEN
	dVatAmt = Double(this.GetText())
	IF IsNull(dVatAmt) OR dVatAmt = 0 THEN 
		this.SetItem(iCurRow,"vat_amt",0)
		dVatAmt = 0
	END IF
	
	IF this.GetItemString(iCurRow,"tax_no") = '01' AND dVatAmt =0  THEN 
		F_MessageChk(20,'[세액]')
		this.SetItem(iCurRow,"vat_amt",lNull)
		Return 1
	ELSEIF this.GetItemString(iCurRow,"tax_no") = '03' AND dVatAmt <> 0 THEN
		this.SetItem(iCurRow,"vat_amt",0)
		Return 2
	END IF
	
	this.SetItem(iCurRow,"gon_amt",dVatAmt * 10)
END IF

IF this.GetColumnName() = "bu_code" THEN
	sBuCode = this.GetText()
	
	IF sBuCode = "" OR IsNull(sBuCode) THEN Return
	
	SELECT "KFZ17OT9"."RENT_NM"  INTO :sRentNm
   	FROM "KFZ17OT9"  
   	WHERE ( "KFZ17OT9"."CODE" = :sBuCode );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[부동산번호]')
		this.SetItem(iCurRow,"bu_code",sNull)
		Return 1
	END IF
END IF

ib_any_typing = True
end event

event rbuttondown;call super::rbuttondown;String snull

SetNull(snull)

SetNull(gs_code)
SetNull(gs_codename)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.AcceptText()
IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"acc1_cd"),1)
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
END IF

IF this.GetColumnName() ="saup_no" THEN
	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"saup_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="lc_no" THEN
	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"lc_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'9')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"lc_no",this.GetItemString(this.GetRow(),"saupj")+lstr_custom.code)
END IF

IF this.GetColumnName() = "addr1" THEN
	Open(W_Zip_PopUp)
	
	IF Gs_code = "" OR IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"addr1",gs_codename)
	this.Setfocus()
END IF

IF this.GetColumnName() = "cardno" THEN
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Gs_Code = Trim(this.GetItemString(this.GetRow(),"cardno"))
	
	IF IsNull(Gs_Code) THEN Gs_Code = ""

	OpenWithParm(W_KFZ05OM0_POPUP,this.GetItemString(this.GetRow(),"saupj"))
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"cardno",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() = "acc_date" THEN						/*부가세 누락 자료 조회*/
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Gs_Code     = Trim(this.GetItemString(this.GetRow(),"saupj"))
	Gs_CodeName = Trim(Mid(this.GetItemString(this.GetRow(),"gey_date"),1,6))
	
	IF IsNull(Gs_Code) THEN Gs_Code = ""

	Open(W_KGLA20_POPUP)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"acc_date",Left(Gs_Code,8))
	this.SetItem(this.GetRow(),"upmu_gu",Mid(Gs_Code,9,1))
	this.SetItem(this.GetRow(),"jun_no",Long(Mid(Gs_Code,10,4)))
	this.SetItem(this.GetRow(),"lin_no",Integer(Mid(Gs_Code,14,3)))
	this.SetItem(this.GetRow(),"bal_date",Mid(Gs_Code,17,8))
	this.SetItem(this.GetRow(),"bjun_no",Long(Mid(Gs_Code,25,4)))
	
	this.SetItem(this.GetRow(),"gey_date",Mid(Gs_Code,17,8))
	this.SetItem(this.GetRow(),"gey_dd", MID(Mid(Gs_Code,17,8),7,2))
END IF

IF this.GetColumnName() ="bu_code" THEN
	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"bu_code"))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'20')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bu_code",lstr_custom.code)
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then Return

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(currentrow,True)
end event

type dw_mvat from datawindow within w_kgla20
boolean visible = false
integer x = 2222
integer y = 2460
integer width = 1029
integer height = 116
boolean bringtotop = true
boolean titlebar = true
string title = "미결부가세 갱신"
string dataobject = "dw_kgla032"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgla20
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 160
integer width = 4558
integer height = 1480
integer cornerheight = 40
integer cornerwidth = 55
end type

