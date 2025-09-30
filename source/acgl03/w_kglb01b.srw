$PBExportHeader$w_kglb01b.srw
$PBExportComments$전표 등록 : 부가세 등록
forward
global type w_kglb01b from window
end type
type cb_c from commandbutton within w_kglb01b
end type
type cb_s from commandbutton within w_kglb01b
end type
type p_exit from uo_picture within w_kglb01b
end type
type p_can from uo_picture within w_kglb01b
end type
type dw_ins from datawindow within w_kglb01b
end type
type dw_disp from u_key_enter within w_kglb01b
end type
type rr_1 from roundrectangle within w_kglb01b
end type
end forward

global type w_kglb01b from window
integer x = 183
integer y = 36
integer width = 3479
integer height = 2300
boolean titlebar = true
string title = "부가세내역 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_s cb_s
p_exit p_exit
p_can p_can
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01b w_kglb01b

type variables
Boolean ib_changed
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sGeyDate,sVatGisu,sJasaCode,sIoGbn,sTaxGbn,sCvname,sSaNo,sOwnam,sUptae,sUpjong,&
		  sVoucGbn,sAddr,sExpNo,sBalGup,sCurr,sRfna3,sRfna2,sResi,sJasanGbn,sCardNo,sVatGbn,sBdsNo,&
		  sSunDate,sCashNo,sTax14cd
Integer iSeqNo
Double  dVatAmt,dGonAmt

dw_ins.AcceptText()
sGeyDate  = dw_ins.GetItemString(icurrow,"gey_date")
sVatGisu  = dw_ins.GetItemString(icurrow,"vatgisu")
sJasaCode = dw_ins.GetItemString(icurrow,"jasa_cd") 

sCvname   = dw_ins.GetItemString(icurrow,"cvnas") 
sSaNo     = Trim(dw_ins.GetItemString(icurrow,"saup_no2"))
sOwnam    = dw_ins.GetItemString(icurrow,"ownam")
sResi     = Trim(dw_ins.GetItemString(icurrow,"resident"))
sUptae    = dw_ins.GetItemString(icurrow,"uptae") 
sUpjong   = dw_ins.GetItemString(icurrow,"jongk") 
sAddr     = dw_ins.GetItemString(icurrow,"addr1")
sVatGbn   = dw_ins.GetItemString(icurrow,"vatgbn")

sIoGbn    = dw_ins.GetItemString(icurrow,"io_gu") 
sTaxGbn   = dw_ins.GetItemString(icurrow,"tax_no") 
sVoucGbn  = dw_ins.GetItemString(icurrow,"vouc_gu") 
dVatAmt   = dw_ins.GetItemNumber(icurrow,"vat_amt") 
dGonAmt   = dw_ins.GetItemNumber(icurrow,"gon_amt") 

sCurr     = dw_ins.GetItemString(iCurRow,"curr")
sExpNo    = dw_ins.GetItemString(iCurRow,"expno")
sSunDate  = dw_ins.GetItemString(iCurRow,"sunjukil")
sBalGup   = dw_ins.GetItemString(iCurRow,"ownplace")
sJasanGbn = dw_ins.GetItemString(icurrow,"addr2") 
sCardNo   = dw_ins.GetItemString(icurrow,"cardno") 
sBdsNo    = dw_ins.GetItemString(icurrow,"bu_code")
sCashNo   = dw_ins.GetItemString(iCurRow,"cash_sno")  //2009.04.29 조성원 주석되어 있는것 품
sTax14Cd  = dw_ins.GetItemString(iCurRow,"tax14_cd")

IF sGeyDate = "" OR IsNull(sGeyDate) THEN 
	F_MessageChk(1,'[영수일자]')
	dw_ins.SetColumn("gey_date")
	dw_ins.SetFocus()
	Return -1
END IF

IF sVatGisu = "" OR IsNull(sVatGisu) THEN 
	F_MessageChk(1,'[부가세기수]')
	dw_ins.SetColumn("vatgisu")
	dw_ins.SetFocus()
	Return -1
END IF

IF sJasaCode = "" OR IsNull(sJasaCode) THEN 
	F_MessageChk(1,'[자사코드]')
	dw_ins.SetColumn("jasa_cd")
	dw_ins.SetFocus()
	Return -1
END IF

IF sCvname = "" OR IsNull(sCvname) THEN 
	F_MessageChk(1,'[거래처명]')
	dw_ins.SetColumn("cvnas")
	dw_ins.SetFocus()
	Return -1
END IF

//IF sOwnam = "" OR IsNull(sOwnam) THEN 
//	F_MessageChk(1,'[대표자명]')
//	dw_ins.SetColumn("ownam")
//	dw_ins.SetFocus()
//	Return -1
//END IF

IF dw_ins.GetItemString(iCurRow,"custflag") = 'N' THEN
	IF sVoucGbn = "" OR IsNull(sVoucGbn) THEN
		IF (sSaNo = "" OR IsNull(sSaNo)) AND sTaxGbn <> '22' THEN 
			F_MessageChk(1,'[사업자등록번호]')
			dw_ins.SetColumn("saup_no2")
			dw_ins.SetFocus()
			Return -1
		END IF
	END IF
END IF


IF sTaxGbn = '14' AND ( sTax14Cd = '' OR IsNull(sTax14Cd) ) THEN
	F_MessageChk(1,'[불공제구분]')
	dw_ins.SetColumn("tax14_cd")
	dw_ins.SetFocus()
	Return -1
END IF

//IF sUptae = "" OR IsNull(sUptae) THEN 
//	F_MessageChk(1,'[업태]')
//	dw_ins.SetColumn("uptae")
//	dw_ins.SetFocus()
//	Return -1
//END IF
//
//IF sUpjong = "" OR IsNull(sUpjong) THEN 
//	F_MessageChk(1,'[업종]')
//	dw_ins.SetColumn("jongk")
//	dw_ins.SetFocus()
//	Return -1
//END IF
//IF sAddr = "" OR IsNull(sAddr) THEN 
//	F_MessageChk(1,'[주소]')
//	dw_ins.SetColumn("addr1")
//	dw_ins.SetFocus()
//	Return -1
//END IF

IF sIoGbn = "" OR IsNull(sIoGbn) THEN 
	F_MessageChk(1,'[매입매출구분]')
	dw_ins.SetColumn("io_gu")
	dw_ins.SetFocus()
	Return -1
END IF

IF sTaxGbn = "" OR IsNull(sTaxGbn) THEN 
	F_MessageChk(1,'[부가세구분]')
	dw_ins.SetColumn("tax_no")
	dw_ins.SetFocus()
	Return -1
END IF

IF sTaxGbn = '23' THEN 			/*수출면장 이면 '수출신고번호'필수*/
	IF sCurr <> 'WON' and (dw_ins.GetItemNumber(icurrow,"for_amt") = 0 or IsNull(dw_ins.GetItemNumber(icurrow,"for_amt"))) then
		F_MessageChk(1,'[외화금액]')
		dw_ins.SetColumn("for_amt")
		dw_ins.SetFocus()
		Return -1
	end if
	IF sCurr = '' or IsNull(sCurr) THEN	
		F_MessageChk(1,'[통화단위]')
		dw_ins.SetColumn("curr")
		dw_ins.SetFocus()
		Return -1
	END IF
	
	IF sCurr <> 'WON' and (dw_ins.GetItemNumber(icurrow,"exc_rate") = 0 or IsNull(dw_ins.GetItemNumber(icurrow,"exc_rate"))) then
		F_MessageChk(1,'[적용환율]')
		dw_ins.SetColumn("exc_rate")
		dw_ins.SetFocus()
		Return -1
	end if
	IF sExpNo = '' or IsNull(sExpNo) THEN	
		F_MessageChk(1,'[수출신고번호]')
		dw_ins.SetColumn("expno")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sVoucGbn = '' or IsNull(sVoucGbn) THEN
		F_MessageChk(1,'[영세율증빙]')
		dw_ins.SetColumn("vouc_gu")
		dw_ins.SetFocus()
		Return -1	
	END IF
END IF

if sTaxGbn = '24' then																/*매출영세율*/
	IF sCurr <> 'WON' and (dw_ins.GetItemNumber(icurrow,"for_amt") = 0 or IsNull(dw_ins.GetItemNumber(icurrow,"for_amt"))) then
		F_MessageChk(1,'[외화금액]')
		dw_ins.SetColumn("for_amt")
		dw_ins.SetFocus()
		Return -1
	end if
	IF sCurr = '' or IsNull(sCurr) THEN	
		F_MessageChk(1,'[통화단위]')
		dw_ins.SetColumn("curr")
		dw_ins.SetFocus()
		Return -1
	END IF
	
	IF sCurr <> 'WON' and (dw_ins.GetItemNumber(icurrow,"exc_rate") = 0 or IsNull(dw_ins.GetItemNumber(icurrow,"exc_rate"))) then
		F_MessageChk(1,'[적용환율]')
		dw_ins.SetColumn("exc_rate")
		dw_ins.SetFocus()
		Return -1
	end if
	
	IF sVoucGbn = '' or IsNull(sVoucGbn) THEN
		F_MessageChk(1,'[영세율증빙]')
		dw_ins.SetColumn("vouc_gu")
		dw_ins.SetFocus()
		Return -1	
	END IF

	IF sBalGup = '' OR IsNull(sBalGup) THEN
		F_MessageChk(1,'[증빙발급자]')
		dw_ins.SetColumn("ownplace")
		dw_ins.SetFocus()
		Return -1	
	END IF
	
//	IF s = '' or IsNull(sSunDate) THEN
//		F_MessageChk(1,'[선적일자]')
//		dw_ins.SetColumn("sunjukil")
//		dw_ins.SetFocus()
//		Return -1
//	END IF
end if

IF sTaxGbn = '16' AND (sCardNo = '' or IsNull(sCardNo)) then
	F_MessageChk(1,'[카드번호]')
	dw_ins.SetColumn("cardno")
	dw_ins.SetFocus()
	Return -1
END IF

/* 2009.04.29 법이 변경되어서 현금영수증의 승인번호를 입력 안해도 된다고 함
IF sTaxGbn = '18' AND (sCashNo = '' or IsNull(sCashNo)) then
	F_MessageChk(1,'[승인번호]')
	dw_ins.SetColumn("cash_sno")
	dw_ins.SetFocus()
	Return -1
END IF
*/

IF sVatGbn = "3" AND (sBdsNo = '' or IsNull(sBdsNo)) then
	F_MessageChk(1,'[임대부동산 번호]')
	dw_ins.SetColumn("bu_code")
	dw_ins.SetFocus()
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
		dw_ins.SetColumn("vat_amt")
		dw_ins.SetFocus()
		Return -1
	END IF
	
	IF sRfna3 <> "Y" THEN
		F_MessageChk(1,'[세액]')
		dw_ins.SetColumn("vat_amt")
		dw_ins.SetFocus()
		Return -1
	END IF
END IF

IF dGonAmt = 0 OR IsNull(dGonAmt) THEN
	F_MessageChk(1,'[공급가액]')
	dw_ins.SetColumn("gon_amt")
	dw_ins.SetFocus()
	Return -1
END IF

//참조코드 Table의 rfna2가 1인 경우 사업자번호 필수
IF sSaNo = "" Or Isnull(sSaNo) THEN
	Select rfna2
	  Into :sRfna2
	  From reffpf
	 Where rfcod = 'AT'
	   And rfgub <> '00'
		And rfgub = :sTaxGbn;

	IF SQLCA.sqlcode <> 0 THEN
		Messagebox("확인", "사업자번호 필수입력 여부 검색 오류입니다")
		dw_ins.SetColumn("saup_no")
		dw_ins.SetFocus()
		Return -1
	END IF
	
	IF sTaxGbn = "22" THEN
		IF Isnull(sResi) Or Len(sResi) = 0 Then
			F_MessageChk(1,'[주민등록번호]')
			dw_ins.SetColumn("saup_no")
			dw_ins.SetFocus()
			Return -1
		END IF
	ELSE
		IF sRfna2 = "1" THEN
			F_MessageChk(1,'[사업자번호]')
			dw_ins.SetColumn("saup_no")
			dw_ins.SetFocus()
			Return -1
		END IF
	END IF
	
END IF

Return 1
end function

event open;String             sCvName,sSano,sOwnam,sResident,sUpTae,sUpJong,sAddr,sCustGbn,sJaSaCode,sVatGbn
Long               iRowCount,iCurRow
DataWindowChild    Dwc_VatGbn,Dw_Child

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()

dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()

/*자사코드*/
//select rfgub	into :sJaSaCode from reffpf where rfcod = 'JA' and rfna3 = :lstr_jpra.saupjang;
select rfna2 into :sJaSaCode from reffpf where rfcod = 'AD' and rfgub = :lstr_jpra.saupjang;

select nvl(vat_gu,'N')	into :sVatGbn from kfz01om0 
	where acc1_cd = :lstr_jpra.acc1 and acc2_cd = :lstr_jpra.acc2;

iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																						lstr_jpra.bjunno,lstr_jpra.sortno)
																		
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	dw_ins.GetChild("tax_no",Dwc_VatGbn)
	Dwc_VatGbn.SetTransObject(Sqlca)
	Dwc_VatGbn.Retrieve(lstr_jpra.chadae)
	
	dw_ins.GetChild("vatgbn",Dw_Child)
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sJaSaCode) <=0 then
		dw_child.InsertRow(0)
	end if

	iCurRow = dw_ins.InsertRow(0)

   dw_ins.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
   dw_ins.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
   dw_ins.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
   dw_ins.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
   dw_ins.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)

   dw_ins.SetItem(iCurRow,"vatgisu",  F_Get_VatGisu(gs_saupj,lstr_jpra.baldate))
	
	dw_ins.SetItem(iCurRow,"gey_date", lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"saup_no",  Left(lstr_jpra.saupno,6))
	dw_ins.SetItem(iCurRow,"seq_no",   1)
	
	dw_ins.setItem(iCurRow,"vat_amt",  lstr_jpra.money)
	
	IF lstr_jpra.ymoney = 0 OR IsNull(lstr_jpra.ymoney) THEN 
		dw_ins.setItem(iCurRow,"gon_amt",  lstr_jpra.money * 10)
	ELSE
		dw_ins.setItem(iCurRow,"gon_amt",  lstr_jpra.ymoney)
	END IF
	
	dw_ins.setItem(iCurRow,"descr",    lstr_jpra.desc)
	dw_ins.setItem(iCurRow,"acc1_cd",  lstr_jpra.acc1_vat)
	dw_ins.setItem(iCurRow,"acc2_cd",  lstr_jpra.acc2_vat)
	dw_ins.setItem(iCurRow,"accname",  lstr_jpra.accname)
	dw_ins.setItem(iCurRow,"io_gu",    lstr_jpra.chadae)
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_GU",	"VNDMST"."CVNAS",     	"VNDMST"."SANO", 
			 "VNDMST"."UPTAE",   		"VNDMST"."JONGK",   		"VNDMST"."OWNAM",
			 "VNDMST"."RESIDENT",   	NVL("VNDMST"."ADDR1",'')||NVL("VNDMST"."ADDR2",'')  
	   INTO :sCustGbn,					:sCvName,   				:sSano,
		     :sUptae,   					:sUpJong,   				:sOwnam,   
			  :sResident,   				:sAddr 
	   FROM "KFZ04OM0","VNDMST"  
   	WHERE ("KFZ04OM0"."PERSON_CD" = "VNDMST"."CVCOD"(+)) AND
				( "KFZ04OM0"."PERSON_CD" = SUBSTR(:lstr_jpra.saupno,1,6) );
	IF SQLCA.SQLCODE = 0 THEN
		IF sCustGbn = '99' OR sVatGbn = 'N' THEN
			dw_ins.SetItem(iCurRow,"custflag",'Y')
			dw_ins.Modify("saup_no.protect = 0")
		ELSE
			dw_ins.SetItem(iCurRow,"custflag",'N')
			dw_ins.Modify("saup_no.protect = 1")
		END IF
		
		dw_ins.SetItem(iCurRow,"cvnas",   sCvName)
		dw_ins.SetItem(iCurRow,"saup_no2",sSano)
		dw_ins.SetItem(iCurRow,"ownam",  sOwNam)
		dw_ins.SetItem(iCurRow,"uptae",   sUptae)
		dw_ins.SetItem(iCurRow,"jongk",   sUpjong)
		dw_ins.SetItem(iCurRow,"addr1",   sAddr)
		dw_ins.SetItem(iCurRow,"resident",sResident)
	ELSE
		dw_ins.SetItem(iCurRow,"custflag",'Y')
		dw_ins.Modify("saup_no.protect = 0")
	END IF
	
	dw_ins.SetItem(iCurRow,"jasa_cd",sJaSacode)
	ib_changed = True
ELSE
	dw_ins.GetChild("tax_no", Dwc_VatGbn)
	Dwc_VatGbn.SetTransObject(Sqlca)
	Dwc_VatGbn.Retrieve(dw_disp.GetItemString(1,"io_gu"))
	
	dw_ins.GetChild("vatgbn",Dw_Child)
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(dw_disp.GetItemString(1,"jasa_cd")) <=0 then
		dw_child.InsertRow(0)
	end if
	
	iCurRow = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																			lstr_jpra.bjunno,lstr_jpra.sortno)	
   
	if lstr_jpra.saupno = "" or isnull(lstr_jpra.saupno) then
		lstr_jpra.saupno = dw_ins.GetItemString(iCurRow,"saup_no")
	end if
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_GU",	"VNDMST"."CVNAS",     	"VNDMST"."SANO", 
			 "VNDMST"."UPTAE",   		"VNDMST"."JONGK",   		"VNDMST"."OWNAM",
			 "VNDMST"."RESIDENT",   	NVL("VNDMST"."ADDR1",'')||NVL("VNDMST"."ADDR2",'')  
	   INTO :sCustGbn,					:sCvName,   				:sSano,
		     :sUptae,   					:sUpJong,   				:sOwnam,   
			  :sResident,   				:sAddr 
	   FROM "KFZ04OM0","VNDMST"  
   	WHERE ("KFZ04OM0"."PERSON_CD" = "VNDMST"."CVCOD"(+)) AND
				( "KFZ04OM0"."PERSON_CD" = SUBSTR(:lstr_jpra.saupno,1,6) );
	IF SQLCA.SQLCODE = 0 THEN
		IF sCustGbn = '99' OR sVatGbn = 'N' THEN
			dw_ins.SetItem(iCurRow,"custflag",'Y')
			dw_ins.Modify("saup_no.protect = 0")
		ELSE
			dw_ins.SetItem(iCurRow,"custflag",'N')
			dw_ins.Modify("saup_no.protect = 1")
		
			dw_ins.SetItem(iCurRow,"cvnas",   sCvName)
			dw_ins.SetItem(iCurRow,"saup_no2",sSano)
			dw_ins.SetItem(iCurRow,"ownam",  sOwNam)
			dw_ins.SetItem(iCurRow,"uptae",   sUptae)
			dw_ins.SetItem(iCurRow,"jongk",   sUpjong)
			dw_ins.SetItem(iCurRow,"addr1",   sAddr)
			dw_ins.SetItem(iCurRow,"resident",sResident)
			dw_ins.SetItem(iCurRow,"saup_no", lstr_jpra.saupno)
		END IF
		
	END IF
END IF
IF dw_ins.GetItemString(iCurRow,"custflag") = 'Y' THEN
	dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.ymoney) 
ELSE
	dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 
END IF

dw_ins.SetColumn("jasa_cd")
dw_ins.SetFocus()
end event

on w_kglb01b.create
this.cb_c=create cb_c
this.cb_s=create cb_s
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_c,&
this.cb_s,&
this.p_exit,&
this.p_can,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01b.destroy
destroy(this.cb_c)
destroy(this.cb_s)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_c from commandbutton within w_kglb01b
integer x = 3927
integer y = 376
integer width = 251
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_s from commandbutton within w_kglb01b
integer x = 3927
integer y = 280
integer width = 251
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01b
integer x = 3259
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;Int    iDbCount
Double dAmount,dSumAmount,dGong,dPumGong,dPumVat
String sRtnValue,sVatGbn,sExceptVatGbn

IF ib_changed = True THEN
	lstr_jpra.k_amt = dw_ins.GetItemNumber(1,"gon_amt")
	
	IF Wf_RequiredChk(dw_ins.GetRow()) = -1 THEN Return
	
	sVatGbn    = dw_ins.GetItemString(dw_ins.GetRow(),"tax_no")
	
	dGong      = dw_ins.GetItemNumber(dw_ins.GetRow(),"gon_amt")
	dSumAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"vat_amt")
	
	dPumGong   = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_gonamt")
	dPumVat    = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_vatamt")
	
	IF IsNull(dGong) THEN dGong = 0
	IF IsNull(dSumAmount) THEN dSumAmount = 0
	IF IsNull(dPumGong) THEN dPumGong = 0
	IF IsNull(dPumVat) THEN dPumVat = 0
	
	SELECT "SYSCNFG"."DATANAME"  INTO :sExceptVatGbn  
	   FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         	( "SYSCNFG"."LINENO" = '50' );
	IF SQLCA.SQLCODE <> 0 THEN
		sExceptVatGbn = ''
	END IF
	
	IF dPumGong <> 0 OR dPumVat <> 0 THEN
		IF dGong <> dPumGong OR dSumAmount <> dPumVat THEN
			MessageBox("확 인","입력하신 금액과 품목의 합계가 다릅니다.!!")
			Return
		END IF
	END IF
		
//	IF sVatGbn = Left(sExceptVatGbn,2) OR sVatGbn = Mid(sExceptVatGbn,3,2) THEN
//	ELSE
//		IF dSumAmount <> lstr_jpra.money THEN
//			F_MessageChk(37,'')
//			Return	
//		END IF	
//	END IF
	
	IF F_DbConFirm('저장') = 2  then return
					
	IF dw_ins.Update() <> 1 THEN
		Rollback;
		F_messageChk(13,'')
		Return
	END IF
	sRtnValue = '1'
ELSE
	lstr_jpra.k_amt = dw_ins.GetItemNumber(1,"gon_amt")
	
	SELECT Count("KFZ12OTB"."GEY_DATE")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTB"  
   	WHERE ( "KFZ12OTB"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTB"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTB"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTB"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTB"."LIN_NO" = :lstr_jpra.sortno )   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		sRtnValue = '1'
		dw_ins.Update()
	ELSE
		sRtnValue = '0'
	END IF
END IF

/*2000.02.12 수정*/
//IF dw_ins.GetItemString(dw_ins.GetRow(),"tax_no") <> '' AND &
//									Not IsNull(dw_ins.GetItemString(dw_ins.GetRow(),"tax_no")) THEN
//	sRtnValue = sRtnValue + F_Get_Refferance('AT',dw_ins.GetItemString(dw_ins.GetRow(),"tax_no")) + ' '
//END IF
//IF dw_ins.GetItemNumber(dw_ins.GetRow(),"gon_amt") <> 0 AND &
//									Not IsNull(dw_ins.GetItemNumber(dw_ins.GetRow(),"gon_amt")) THEN
//	sRtnValue = sRtnValue + String(dw_ins.GetItemNumber(dw_ins.GetRow(),"gon_amt"),'###,###,###,###') + ' '
//END IF
//IF dw_ins.GetItemString(dw_ins.GetRow(),"jasa_cd") <> '' AND &
//									Not IsNull(dw_ins.GetItemString(dw_ins.GetRow(),"jasa_cd")) THEN
//	sRtnValue = sRtnValue + F_Get_Refferance('JA',dw_ins.GetItemString(dw_ins.GetRow(),"jasa_cd")) + ' '
//END IF
//IF dw_ins.GetItemString(dw_ins.GetRow(),"vouc_gu") <> '' AND &
//									Not IsNull(dw_ins.GetItemString(dw_ins.GetRow(),"vouc_gu")) THEN
//	sRtnValue = sRtnValue + F_Get_Refferance('AU',dw_ins.GetItemString(dw_ins.GetRow(),"vouc_gu"))
//END IF

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_kglb01b
integer x = 3086
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String sRtnValue

dw_ins.SetRedraw(False)
dw_ins.DeleteRow(0)
IF dw_ins.Update() <> 1 THEN
	F_MessageChk(12,'')
   ROLLBACK;
	Return
END IF
dw_ins.SetRedraw(True)

sRtnValue = '0'
CloseWithReturn(parent,sRtnValue)




end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_ins from datawindow within w_kglb01b
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 192
integer width = 3346
integer height = 1944
integer taborder = 10
string dataobject = "dw_kglb01b_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_changed = True
end event

event getfocus;this.AcceptText()


end event

event itemerror;Return 1
end event

event itemchanged;String  sGeyDate,sVatGisu,sJasaCode,sIoGbn,sTaxGbn,sVocuGbn,sSaupNo,sCustGbn,sCvName,&
		  sSano,sUptae,sUpjong,sOwnam,sResident,sAddr,snull,sVatGbn,sGetJong,sCardNo,sOwner
Integer iCurRow,lnull
Double  dVatAmt,dQty,dUprice

SetNull(snull)
SetNull(lnull)

this.AcceptText()

iCurRow = this.GetRow()
IF this.GetColumnName() ="gey_date" THEN
	sGeyDate = Trim(this.GetText())
	IF sGeyDate = "" OR IsNull(sGeyDate) THEN RETURN
	
	IF F_DateChk(sGeyDate) = -1 THEN 
		F_MessageChk(21,'[계산서일자]')
		dw_ins.SetItem(iCurRow,"gey_date",snull)
		Return 1
	END IF
	
	this.SetItem(iCurRow,"vatgisu", F_Get_VatGisu(gs_saupj,sGeyDate))
END IF

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		dw_ins.SetItem(iCurRow,"vatgisu",snull)
		Return 1
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
		this.SetItem(iCurRow,"vatgbn",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jasa_cd" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN Return
	
	IF IsNull(F_Get_Refferance('JA',sJasaCode)) THEN
		F_MessageChk(20,'[자사코드]')
		dw_ins.SetItem(iCurRow,"jasa_cd",snull)
		Return 1
	END IF
	
	DataWindowChild  Dw_Child
	Integer          iVal

	iVal = this.GetChild("vatgbn",Dw_Child)
	IF iVal = 1 THEN
		dw_child.SetTransObject(Sqlca)
		dw_child.Retrieve(sJasaCode)
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
   	WHERE ("KFZ04OM0"."PERSON_CD" = "VNDMST"."CVCOD"(+)) AND
				( "KFZ04OM0"."PERSON_CD" = :sSaupNo) AND
				( "KFZ04OM0"."PERSON_GU" = '1' OR  "KFZ04OM0"."PERSON_GU" = '99');
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(iCurRow,"cvnas",   sCvName)
		this.SetItem(iCurRow,"saup_no2",sSano)
		this.SetItem(iCurRow,"ownam",  sOwNam)
		this.SetItem(iCurRow,"uptae",   sUptae)
		this.SetItem(iCurRow,"jongk",   sUpjong)
		this.SetItem(iCurRow,"addr1",   sAddr)
		this.SetItem(iCurRow,"resident",sResident)
	ELSE
		F_MessageChk(20,'[거래처]')
		
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
	
	SELECT DISTINCT "CVNAS",   "OWNAM",      "RESIDENT",         "UPTAE",   
			          "JONGK",   "ADDR1"  
		INTO :sCvName,   			:sOwnam,   		:sResident,   		:sUptae,   
			  :sUpJong,   			:sAddr  
		FROM "KFZ12OTB"  
		WHERE "SAUP_NO2" = :sSano;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(iCurRow,"cvnas",   sCvName)
		this.SetItem(iCurRow,"resident",sResident)		
		this.SetItem(iCurRow,"ownam",   sOwNam)
		this.SetItem(iCurRow,"uptae",   sUptae)
		this.SetItem(iCurRow,"jongk",   sUpjong)
		this.SetItem(iCurRow,"addr1",   sAddr)
	END IF
END IF

IF this.GetColumnName() ="io_gu" THEN
	sIoGbn = this.GetText()
	IF sIoGbn = "" OR IsNull(sIoGbn) THEN Return
	
	IF sIoGbn <> '1' AND sIoGbn <> '2' THEN
		F_MessageChk(20,'[매입매출구분]')
		dw_ins.SetItem(iCurRow,"io_gu",snull)
		Return 1
	ELSE
		DataWindowChild Dwc_VatGbn
		
		this.GetChild("tax_no",Dwc_VatGbn)
		Dwc_VatGbn.SetTransObject(Sqlca)
		Dwc_VatGbn.Retrieve(sIoGbn)
	END IF
END IF

IF this.GetColumnName() ="tax_no" THEN
	sTaxGbn = this.GetText()
	IF sTaxGbn ="" OR IsNull(sTaxGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sTaxGbn)) THEN
		F_MessageChk(20,'[부가세구분]')
		dw_ins.SetItem(iCurRow,"tax_no",snull)
		Return 1
	ELSE
		sIoGbn = this.GetItemString(iCurRow,"io_gu")
		if sIoGbn = '' or IsNull(sIoGbn) then Return
		
		if Left(sTaxGbn,1) <> sIoGbn then
			F_MessageChk(16,'[부가세구분 <> 매입매출구분]')
			THIS.SetItem(iCurRow,"tax_no",snull)
			Return 1
		end if
	END IF
	
END IF

IF this.GetColumnName() ="cardno" THEN
	sCardNo = this.GetText()
	IF sCardNo = "" OR IsNull(sCardNo) THEN Return
	
	SELECT "KFZ05OM0"."OWNER"   	INTO :sOwner
	  	FROM "KFZ05OM0"  
   	WHERE "KFZ05OM0"."CARD_NO" = :sCardNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[카드번호]')
		this.SetItem(iCurRow,"cardno",snull)
		Return 1
	END IF
END IF


IF this.GetColumnName() ="vouc_gu" THEN
	sVocuGbn = this.GetText()
	IF sVocuGbn ="" OR IsNull(sVocuGbn) THEN RETURN 
	
	IF IsNull(F_Get_Refferance('AU',sVocuGbn)) THEN
		F_MessageChk(20,'[영세율증빙구분]')
		dw_ins.SetItem(iCurRow,"vouc_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="vat_amt" THEN
	dVatAmt = Double(this.GetText())
	IF IsNull(dVatAmt) THEN 
		this.SetItem(iCurRow,"vat_amt",0)
		dVatAmt = 0
	END IF
	
	IF dw_ins.GetItemString(iCurRow,"tax_no") = '01' AND dVatAmt =0  THEN 
		F_MessageChk(20,'[세액]')
		dw_ins.SetItem(iCurRow,"vat_amt",lnull)
		Return 1
	ELSEIF dw_ins.GetItemString(iCurRow,"tax_no") = '03' AND dVatAmt <> 0 THEN
		dw_ins.SetItem(iCurRow,"vat_amt",0)
		Return 2
	END IF
END IF

IF this.GetColumnName() ="qty1" THEN
	dQty = Double(this.GetText())
	IF IsNull(dQty) THEN dQty = 0
	
	IF dQty = 0 THEN
		this.SetItem(iCurRow,"qty1",0)
		this.SetItem(iCurRow,"gonamt1",0)
	ELSE
		dUprice = this.GetItemNumber(iCurRow,"uprice1")
		IF IsNull(dUprice) THEN dUprice = 0
		
		IF dUprice = 0 THEN
			this.SetItem(iCurRow,"gonamt1",0)
		ELSE
			this.SetItem(iCurRow,"gonamt1",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="uprice1" THEN
	dUprice = Double(this.GetText())
	IF IsNull(dUprice) THEN dUprice = 0
	
	IF dUprice = 0 THEN
		this.SetItem(iCurRow,"uprice1",0)
		this.SetItem(iCurRow,"gonamt1",0)
	ELSE
		dQty = this.GetItemNumber(iCurRow,"qty1")
		IF IsNull(dQty) THEN dQty = 0
		
		IF dQty = 0 THEN
			this.SetItem(iCurRow,"gonamt1",0)
		ELSE
			this.SetItem(iCurRow,"gonamt1",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="qty2" THEN
	dQty = Double(this.GetText())
	IF IsNull(dQty) THEN dQty = 0
	
	IF dQty = 0 THEN
		this.SetItem(iCurRow,"qty2",0)
		this.SetItem(iCurRow,"gonamt2",0)
	ELSE
		dUprice = this.GetItemNumber(iCurRow,"uprice2")
		IF IsNull(dUprice) THEN dUprice = 0
		
		IF dUprice = 0 THEN
			this.SetItem(iCurRow,"gonamt2",0)
		ELSE
			this.SetItem(iCurRow,"gonamt2",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="uprice2" THEN
	dUprice = Double(this.GetText())
	IF IsNull(dUprice) THEN dUprice = 0
	
	IF dUprice = 0 THEN
		this.SetItem(iCurRow,"uprice2",0)
		this.SetItem(iCurRow,"gonamt2",0)
	ELSE
		dQty = this.GetItemNumber(iCurRow,"qty2")
		IF IsNull(dQty) THEN dQty = 0
		
		IF dQty = 0 THEN
			this.SetItem(iCurRow,"gonamt2",0)
		ELSE
			this.SetItem(iCurRow,"gonamt2",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="qty3" THEN
	dQty = Double(this.GetText())
	IF IsNull(dQty) THEN dQty = 0
	
	IF dQty = 0 THEN
		this.SetItem(iCurRow,"qty3",0)
		this.SetItem(iCurRow,"gonamt3",0)
	ELSE
		dUprice = this.GetItemNumber(iCurRow,"uprice3")
		IF IsNull(dUprice) THEN dUprice = 0
		
		IF dUprice = 0 THEN
			this.SetItem(iCurRow,"gonamt3",0)
		ELSE
			this.SetItem(iCurRow,"gonamt3",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="uprice3" THEN
	dUprice = Double(this.GetText())
	IF IsNull(dUprice) THEN dUprice = 0
	
	IF dUprice = 0 THEN
		this.SetItem(iCurRow,"uprice3",0)
		this.SetItem(iCurRow,"gonamt3",0)
	ELSE
		dQty = this.GetItemNumber(iCurRow,"qty3")
		IF IsNull(dQty) THEN dQty = 0
		
		IF dQty = 0 THEN
			this.SetItem(iCurRow,"gonamt3",0)
		ELSE
			this.SetItem(iCurRow,"gonamt3",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="qty4" THEN
	dQty = Double(this.GetText())
	IF IsNull(dQty) THEN dQty = 0
	
	IF dQty = 0 THEN
		this.SetItem(iCurRow,"qty4",0)
		this.SetItem(iCurRow,"gonamt4",0)
	ELSE
		dUprice = this.GetItemNumber(iCurRow,"uprice4")
		IF IsNull(dUprice) THEN dUprice = 0
		
		IF dUprice = 0 THEN
			this.SetItem(iCurRow,"gonamt4",0)
		ELSE
			this.SetItem(iCurRow,"gonamt4",dQty * dUprice)
		END IF
	END IF
END IF

IF this.GetColumnName() ="uprice4" THEN
	dUprice = Double(this.GetText())
	IF IsNull(dUprice) THEN dUprice = 0
	
	IF dUprice = 0 THEN
		this.SetItem(iCurRow,"uprice4",0)
		this.SetItem(iCurRow,"gonamt4",0)
	ELSE
		dQty = this.GetItemNumber(iCurRow,"qty4")
		IF IsNull(dQty) THEN dQty = 0
		
		IF dQty = 0 THEN
			this.SetItem(iCurRow,"gonamt4",0)
		ELSE
			this.SetItem(iCurRow,"gonamt4",dQty * dUprice)
		END IF
	END IF
END IF
ib_changed = True
end event

event itemfocuschanged;
IF this.GetColumnName() = "cvnam" OR this.GetColumnName() = "ownam" OR &
	this.GetColumnName() = "uptae" OR this.GetColumnName() = "jongk" OR &
	this.GetColumnName() = "addr1" OR this.GetColumnName() = "ownplace" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event rbuttondown;String snull

SetNull(snull)

SetNull(gs_code)
SetNull(gs_codename)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.AcceptText()

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
	
	this.SetItem(this.GetRow(),"lc_no",lstr_custom.code)
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

	Open(W_KFZ05OM0_POPUP)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"cardno",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type dw_disp from u_key_enter within w_kglb01b
integer x = 23
integer y = 12
integer width = 2857
integer height = 140
integer taborder = 0
string dataobject = "dw_kglb01b_1"
boolean border = false
end type

event itemchanged;//IF dwo.name ="bil_date" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_jigu" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_gu" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_amt" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF WF_DATA_CHK(dwo.name,data) = -1 THEN
//	itemerr = True
//	RETURN 1
//END IF
//
end event

type rr_1 from roundrectangle within w_kglb01b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 3397
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

