$PBExportHeader$w_kgla03.srw
$PBExportComments$기초자료관리: 부가세 등록
forward
global type w_kgla03 from w_inherite
end type
type dw_1 from u_key_enter within w_kgla03
end type
type dw_mvat from datawindow within w_kgla03
end type
type rr_1 from roundrectangle within w_kgla03
end type
end forward

global type w_kgla03 from w_inherite
string title = "부가세 등록"
dw_1 dw_1
dw_mvat dw_mvat
rr_1 rr_1
end type
global w_kgla03 w_kgla03

type variables

end variables

forward prototypes
public function integer wf_exiting_chk (string saupj, string baldate, string upmugu, integer bjunno, integer linno, integer seqno)
public subroutine wf_init ()
public function integer wf_change_junpoy (string sflag, string ssaupj, string sbaldate, string supmugu, long lbjunno, integer llinno, integer lseqno)
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_exiting_chk (string saupj, string baldate, string upmugu, integer bjunno, integer linno, integer seqno);Integer iMaxSeq

IF SEQNO = 0 OR IsNull(SEQNO) THEN
	SELECT MAX("KFZ17OT0"."SEQ_NO")  
		INTO :iMaxSeq  
   	FROM "KFZ17OT0"  
   	WHERE ( "KFZ17OT0"."SAUPJ" = :SAUPJ  ) AND  
      	   ( "KFZ17OT0"."BAL_DATE" = :BALDATE  ) AND  
         	( "KFZ17OT0"."UPMU_GU" = :UPMUGU  ) AND  
	         ( "KFZ17OT0"."BJUN_NO" = :BJUNNO  ) AND  
   	      ( "KFZ17OT0"."LIN_NO" = :LINNO )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
		iMaxSeq = 0
	ELSE
		If IsNull(iMaxSeq) THEN iMaxSeq = 0
	END IF
	
ELSE
	
	IF IsNull(SAUPJ) OR SAUPJ = "" then Return 1
	
	IF IsNull(BALDATE) OR BALDATE = "" then Return 1
	
	IF IsNull(UPMUGU) OR UPMUGU = "" then Return 1
	
	IF IsNull(BJUNNO) OR BJUNNO = 0 then Return 1
	
	IF IsNull(LINNO) OR LINNO = 0 then Return 1
	
	IF IsNull(SEQNO) OR SEQNO = 0 then Return 1
	
	SELECT "KFZ17OT0"."SEQ_NO"  
		INTO :iMaxSeq  
   	FROM "KFZ17OT0"  
   	WHERE ( "KFZ17OT0"."SAUPJ" = :SAUPJ  ) AND  
      	   ( "KFZ17OT0"."BAL_DATE" = :BALDATE  ) AND  
         	( "KFZ17OT0"."UPMU_GU" = :UPMUGU  ) AND  
	         ( "KFZ17OT0"."BJUN_NO" = :BJUNNO  ) AND  
   	      ( "KFZ17OT0"."LIN_NO" = :LINNO ) AND
				( "KFZ17OT0"."SEQ_NO" = :SEQNO ) ;
	IF SQLCA.SQLCODE <> 0 THEN
		Return 1
	ELSE
		Return -1
	END IF
END IF
Return iMaxSeq

end function

public subroutine wf_init ();String           sJasa
DataWindowChild  Dw_Child
Integer          iVal

select rfna2	into :sJasa from reffpf where rfcod = 'AD' and rfgub = :Gs_Saupj ;

w_mdi_frame.sle_msg.Text = ""

ib_any_typing = False

dw_1.SetRedraw(False)
dw_1.Reset()

iVal = dw_1.GetChild("vatgbn",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve(sJasa) <=0 then
		dw_child.InsertRow(0)
	end if
END IF

dw_1.InsertRow(0)

dw_1.SetItem(dw_1.GetRow(),"saupj"   ,gs_saupj)
dw_1.SetItem(dw_1.GetRow(),"bal_date",f_today())
dw_1.SetItem(dw_1.GetRow(),"gey_date",f_today())

dw_1.SetItem(dw_1.GetRow(),"vatgisu",  F_Get_VatGisu(gs_saupj,f_today()))
dw_1.SetItem(dw_1.GetRow(),"jasa_cd",	sJasa)
dw_1.SetItem(dw_1.GetRow(),"custflag", 'N')

dw_1.Modify("saupj.protect = 0")
dw_1.Modify("bal_date.protect = 0")
dw_1.Modify("upmu_gu.protect = 0")
dw_1.Modify("bjun_no.protect = 0")
dw_1.Modify("lin_no.protect = 0")
dw_1.Modify("seq_no.protect = 0")

dw_1.SetRedraw(True)

dw_1.SetColumn("saupj")
dw_1.SetFocus()
end subroutine

public function integer wf_change_junpoy (string sflag, string ssaupj, string sbaldate, string supmugu, long lbjunno, integer llinno, integer lseqno);Integer inumrows,iVatCnt
String  sAlcGbn,sVatGbn

iVatCnt = dw_mvat.Retrieve(sSaupj,sBalDate,sUpmuGu,lBJunNo,lLinNo,lSeqNo)		/*미결부가세 여부*/
IF iVatCnt <=0 THEN Return 1

select count(*), 	min(kfz12ot0.alc_gu), kfz01om0.vat_gu		
	into :inumrows,	:sAlcGbn,				 :sVatGbn	
	from kfz12ot0,kfz01om0
	where kfz12ot0.acc1_cd = kfz01om0.acc1_cd and
			kfz12ot0.acc2_cd = kfz01om0.acc2_cd and
			kfz12ot0.saupj    = :ssaupj    and kfz12ot0.bal_date = :sbaldate and 
			kfz12ot0.upmu_gu  = :supmugu and kfz12ot0.bjun_no = :lbjunno and 
			kfz12ot0.lin_no   = :llinno 
	group by kfz01om0.vat_gu;
if sqlca.sqlcode <> 0 then
	inumrows = 0
else
	if isNull(inumrows) then inumrows = 0
end if

if sFlag = 'I' or sFlag = 'U' then
	IF iVatCnt > 0 THEN							/*미결부가세 있으면*/
	ELSE
		iVatCnt = dw_mvat.InsertRow(0)
		
		dw_mvat.SetItem(iVatCnt,"saupj",       dw_1.GetItemString(dw_1.GetRow(),"saupj"))
		dw_mvat.SetItem(iVatCnt,"bal_date",    dw_1.GetItemString(dw_1.GetRow(),"bal_date"))
		dw_mvat.SetItem(iVatCnt,"upmu_gu",     dw_1.GetItemString(dw_1.GetRow(),"upmu_gu"))
		dw_mvat.SetItem(iVatCnt,"bjun_no",     dw_1.GetItemNumber(dw_1.GetRow(),"bjun_no"))
		dw_mvat.SetItem(iVatCnt,"lin_no",      dw_1.GetItemNumber(dw_1.GetRow(),"lin_no"))
		dw_mvat.SetItem(iVatCnt,"seq_no",      dw_1.GetItemNumber(dw_1.GetRow(),"seq_no"))		 
	END IF
	
	dw_mvat.SetItem(iVatCnt,"gey_date",    dw_1.GetItemString(dw_1.GetRow(),"gey_date"))
	dw_mvat.SetItem(iVatCnt,"saup_no",     dw_1.GetItemString(dw_1.GetRow(),"saup_no"))
	dw_mvat.SetItem(iVatCnt,"gon_amt",     dw_1.GetItemNumber(dw_1.GetRow(),"gon_amt"))
	dw_mvat.SetItem(iVatCnt,"vat_amt",     dw_1.GetItemNumber(dw_1.GetRow(),"vat_amt"))
	dw_mvat.SetItem(iVatCnt,"tax_no",      dw_1.GetItemString(dw_1.GetRow(),"tax_no"))
	dw_mvat.SetItem(iVatCnt,"io_gu",       dw_1.GetItemString(dw_1.GetRow(),"io_gu"))
	dw_mvat.SetItem(iVatCnt,"saup_no2",    dw_1.GetItemString(dw_1.GetRow(),"saup_no2"))
	dw_mvat.SetItem(iVatCnt,"alc_gu",      dw_1.GetItemString(dw_1.GetRow(),"alc_gu"))
	dw_mvat.SetItem(iVatCnt,"acc_date",    dw_1.GetItemString(dw_1.GetRow(),"acc_date"))
	dw_mvat.SetItem(iVatCnt,"jun_no",      dw_1.GetItemNumber(dw_1.GetRow(),"jun_no"))
	dw_mvat.SetItem(iVatCnt,"acc1_cd",     dw_1.GetItemString(dw_1.GetRow(),"acc1_cd"))
	dw_mvat.SetItem(iVatCnt,"acc2_cd",     dw_1.GetItemString(dw_1.GetRow(),"acc2_cd"))
	dw_mvat.SetItem(iVatCnt,"descr",       dw_1.GetItemString(dw_1.GetRow(),"descr"))
	dw_mvat.SetItem(iVatCnt,"jasa_cd",     dw_1.GetItemString(dw_1.GetRow(),"jasa_cd"))
	dw_mvat.SetItem(iVatCnt,"vouc_gu",     dw_1.GetItemString(dw_1.GetRow(),"vouc_gu"))
	dw_mvat.SetItem(iVatCnt,"lc_no",       dw_1.GetItemString(dw_1.GetRow(),"lc_no"))
	dw_mvat.SetItem(iVatCnt,"for_amt",     dw_1.GetItemNumber(dw_1.GetRow(),"for_amt"))

	dw_mvat.SetItem(iVatCnt,"mmdd1",       dw_1.GetItemString(dw_1.GetRow(),"mmdd1"))
	dw_mvat.SetItem(iVatCnt,"pum1",        dw_1.GetItemString(dw_1.GetRow(),"pum1"))
	dw_mvat.SetItem(iVatCnt,"size1",       dw_1.GetItemString(dw_1.GetRow(),"size1"))
	dw_mvat.SetItem(iVatCnt,"qty1",        dw_1.GetItemNumber(dw_1.GetRow(),"qty1"))
	dw_mvat.SetItem(iVatCnt,"uprice1",     dw_1.GetItemNumber(dw_1.GetRow(),"uprice1"))
	dw_mvat.SetItem(iVatCnt,"gonamt1",     dw_1.GetItemNumber(dw_1.GetRow(),"gonamt1"))
	dw_mvat.SetItem(iVatCnt,"vatamt1",     dw_1.GetItemNumber(dw_1.GetRow(),"vatamt1"))

	dw_mvat.SetItem(iVatCnt,"mmdd2",       dw_1.GetItemString(dw_1.GetRow(),"mmdd2"))
	dw_mvat.SetItem(iVatCnt,"pum2",        dw_1.GetItemString(dw_1.GetRow(),"pum2"))
	dw_mvat.SetItem(iVatCnt,"size2",       dw_1.GetItemString(dw_1.GetRow(),"size2"))
	dw_mvat.SetItem(iVatCnt,"qty2",        dw_1.GetItemNumber(dw_1.GetRow(),"qty2"))
	dw_mvat.SetItem(iVatCnt,"uprice2",     dw_1.GetItemNumber(dw_1.GetRow(),"uprice2"))
	dw_mvat.SetItem(iVatCnt,"gonamt2",     dw_1.GetItemNumber(dw_1.GetRow(),"gonamt2"))
	dw_mvat.SetItem(iVatCnt,"vatamt2",     dw_1.GetItemNumber(dw_1.GetRow(),"vatamt2"))

	dw_mvat.SetItem(iVatCnt,"mmdd3",       dw_1.GetItemString(dw_1.GetRow(),"mmdd3"))
	dw_mvat.SetItem(iVatCnt,"pum3",        dw_1.GetItemString(dw_1.GetRow(),"pum3"))
	dw_mvat.SetItem(iVatCnt,"size3",       dw_1.GetItemString(dw_1.GetRow(),"size3"))
	dw_mvat.SetItem(iVatCnt,"qty3",        dw_1.GetItemNumber(dw_1.GetRow(),"qty3"))
	dw_mvat.SetItem(iVatCnt,"uprice3",     dw_1.GetItemNumber(dw_1.GetRow(),"uprice3"))
	dw_mvat.SetItem(iVatCnt,"gonamt3",     dw_1.GetItemNumber(dw_1.GetRow(),"gonamt3"))
	dw_mvat.SetItem(iVatCnt,"vatamt3",     dw_1.GetItemNumber(dw_1.GetRow(),"vatamt3"))

	dw_mvat.SetItem(iVatCnt,"mmdd4",       dw_1.GetItemString(dw_1.GetRow(),"mmdd4"))
	dw_mvat.SetItem(iVatCnt,"pum4",        dw_1.GetItemString(dw_1.GetRow(),"pum4"))
	dw_mvat.SetItem(iVatCnt,"size4",       dw_1.GetItemString(dw_1.GetRow(),"size4"))
	dw_mvat.SetItem(iVatCnt,"qty4",        dw_1.GetItemNumber(dw_1.GetRow(),"qty4"))
	dw_mvat.SetItem(iVatCnt,"uprice4",     dw_1.GetItemNumber(dw_1.GetRow(),"uprice4"))
	dw_mvat.SetItem(iVatCnt,"gonamt4",     dw_1.GetItemNumber(dw_1.GetRow(),"gonamt4"))
	dw_mvat.SetItem(iVatCnt,"vatamt4",     dw_1.GetItemNumber(dw_1.GetRow(),"vatamt4"))

	dw_mvat.SetItem(iVatCnt,"bill_gu",     dw_1.GetItemString(dw_1.GetRow(),"bill_gu"))
	dw_mvat.SetItem(iVatCnt,"mcash",       dw_1.GetItemNumber(dw_1.GetRow(),"mcash"))
	dw_mvat.SetItem(iVatCnt,"mcheck",      dw_1.GetItemNumber(dw_1.GetRow(),"mcheck"))
	dw_mvat.SetItem(iVatCnt,"mbill",       dw_1.GetItemNumber(dw_1.GetRow(),"mbill"))
	dw_mvat.SetItem(iVatCnt,"mrcv",        dw_1.GetItemNumber(dw_1.GetRow(),"mrcv"))
	
	dw_mvat.SetItem(iVatCnt,"sano",        dw_1.GetItemString(dw_1.GetRow(),"sano"))
	dw_mvat.SetItem(iVatCnt,"cvnas",       dw_1.GetItemString(dw_1.GetRow(),"cvnas"))
	dw_mvat.SetItem(iVatCnt,"ownam",       dw_1.GetItemString(dw_1.GetRow(),"ownam"))
	dw_mvat.SetItem(iVatCnt,"resident",    dw_1.GetItemString(dw_1.GetRow(),"resident"))
	dw_mvat.SetItem(iVatCnt,"uptae",       dw_1.GetItemString(dw_1.GetRow(),"uptae"))
	dw_mvat.SetItem(iVatCnt,"jongk",       dw_1.GetItemString(dw_1.GetRow(),"jongk"))
	dw_mvat.SetItem(iVatCnt,"addr1",       dw_1.GetItemString(dw_1.GetRow(),"addr1"))
	dw_mvat.SetItem(iVatCnt,"addr2",       dw_1.GetItemString(dw_1.GetRow(),"addr2"))
	dw_mvat.SetItem(iVatCnt,"vatgisu",     dw_1.GetItemString(dw_1.GetRow(),"vatgisu"))
	dw_mvat.SetItem(iVatCnt,"exc_rate",    dw_1.GetItemNumber(dw_1.GetRow(),"exc_rate"))
	dw_mvat.SetItem(iVatCnt,"vatgbn",      dw_1.GetItemString(dw_1.GetRow(),"vatgbn"))
	dw_mvat.SetItem(iVatCnt,"taxgbn",      dw_1.GetItemString(dw_1.GetRow(),"taxgbn"))
	
	if inumrows > 0 then
		update kfz12ot0
			set vat_gu = 'Y'
			where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
					bjun_no = :lbjunno and lin_no   = :llinno ;
		if sAlcGbn = 'Y' then
			update kfz10ot0
				set vat_gu = 'Y'
				where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
						bjun_no = :lbjunno and lin_no   = :llinno ;
		end if
	end if
elseif sFlag = 'D' then
	IF sVatGbn = 'Y' AND inumrows > 0 THEN
		MessageBox("확 인","전표가 존재하므로 삭제할 수 없습니다.!!")
		Return -1
	else
		dw_mvat.DeleteRow(iVatCnt)
		
		update kfz12ot0
			set vat_gu = 'N'
			where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
					bjun_no = :lbjunno and lin_no   = :llinno ;
		if sAlcGbn = 'Y' then
			update kfz10ot0
				set vat_gu = 'N'
				where saupj = :ssaupj     and bal_date = :sbaldate and upmu_gu = :supmugu and
						bjun_no = :lbjunno and lin_no   = :llinno ;
		end if
	end if
end if
					
Return 1
end function

public function integer wf_requiredchk (integer icurrow);String  sGeyDate,sVatGisu,sJasaCode,sIoGbn,sTaxGbn,sCvname,sSano,sOwnam,sUptae,sUpjong,sAddr,sExpNo,sBalNm,&
		  sRfna3,sRfna2,sResi,sJasanGbn,sVatGbn,sBdsNo,sCardNo,sSunDate,sCashNo
Integer iSeqNo
Double  dVatAmt,dGonAmt

String sSaupj,sBalDate,sUpmuGbn,sAcc1,sAcc2,sSaupNo,sAlcGbn,sAccDate,sVoucGbn
Long   lJunNo,lLinNo,lSeqNo,lBJunno

dw_1.AcceptText()
sSaupj   = dw_1.GetItemString(dw_1.GetRow(),"saupj")
sBalDate = dw_1.GetItemString(dw_1.GetRow(),"bal_date")
sUpmuGbn = dw_1.GetItemString(dw_1.GetRow(),"upmu_gu")

lBJunNo  = dw_1.GetItemNumber(dw_1.GetRow(),"bjun_no")
lLinNo   = dw_1.GetItemNumber(dw_1.GetRow(),"lin_no")

lSeqNo   = dw_1.GetItemNumber(dw_1.GetRow(),"seq_no")

sAlcGbn  = dw_1.GetItemString(dw_1.GetRow(),"alc_gu") 
sAccDate = dw_1.GetItemString(dw_1.GetRow(),"acc_date") 
lJunNo   = dw_1.GetItemNumber(dw_1.GetRow(),"jun_no") 

sGeyDate  = dw_1.GetItemString(icurrow,"gey_date")
sVatGisu  = dw_1.GetItemString(icurrow,"vatgisu")
sJasaCode = dw_1.GetItemString(icurrow,"jasa_cd") 
sVatGbn   = dw_1.GetItemString(icurrow,"vatgbn") 

sAcc1     = dw_1.GetItemString(icurrow,"acc1_cd") 
sAcc2     = dw_1.GetItemString(icurrow,"acc2_cd") 

sSaupNo   = dw_1.GetItemString(icurrow,"saup_no") 

sCvname   = dw_1.GetItemString(icurrow,"cvnas") 
sSano     = dw_1.GetItemString(icurrow,"saup_no2") 
sOwnam    = dw_1.GetItemString(icurrow,"ownam")
sResi     = Trim(dw_1.GetItemString(icurrow,"resident"))
sUptae    = dw_1.GetItemString(icurrow,"uptae") 
sUpjong   = dw_1.GetItemString(icurrow,"jongk") 
sAddr     = dw_1.GetItemString(icurrow,"addr1") 

sIoGbn    = dw_1.GetItemString(icurrow,"io_gu") 
sTaxGbn   = dw_1.GetItemString(icurrow,"tax_no") 

sExpNo    = dw_1.GetItemString(icurrow,"expno") 
sSunDate  = dw_1.GetItemString(icurrow,"sunjukil")
sVoucGbn  = dw_1.GetItemString(icurrow,"vouc_gu") 
sBalNm    = dw_1.GetItemString(icurrow,"ownplace") 
dVatAmt   = dw_1.GetItemNumber(icurrow,"vat_amt") 
dGonAmt   = dw_1.GetItemNumber(icurrow,"gon_amt")
sJasanGbn = dw_1.GetItemString(icurrow,"addr2")
sCardNo   = dw_1.GetItemString(icurrow,"cardno")
sBdsNo    = dw_1.GetItemString(icurrow,"bu_code")
sCashNo   = dw_1.GetItemString(icurrow,"cash_sno")

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

IF sBalDate = "" OR IsNull(sBalDate) THEN 
	F_MessageChk(1,'[발행일자]')
	dw_1.SetColumn("bal_date")
	dw_1.SetFocus()
	Return -1
END IF

IF lJunNo = 0 OR IsNull(lJunNo) THEN 
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("bjun_no")
	dw_1.SetFocus()
	Return -1
END IF

IF lLinNo = 0 OR IsNull(lLinNo) THEN 
	F_MessageChk(1,'[라인번호]')
	dw_1.SetColumn("lin_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN 
	F_MessageChk(1,'[전표구분]')
	dw_1.SetColumn("upmu_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sAlcGbn = 'Y' THEN
	IF sAccDate = "" OR IsNull(sAccDate) THEN 
		F_MessageChk(1,'[승인일자]')
		dw_1.SetColumn("acc_date")
		dw_1.SetFocus()
		Return -1
	END IF
	IF lJunNo = 0 OR IsNull(lJunNo) THEN 
		F_MessageChk(1,'[승인번호]')
		dw_1.SetColumn("jun_no")
		dw_1.SetFocus()
		Return -1
	END IF
END IF
IF lSeqNo = 0 OR IsNull(lSeqNo) THEN 
	F_MessageChk(1,'[계산서번호]')
	dw_1.SetColumn("seq_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sGeyDate = "" OR IsNull(sGeyDate) THEN 
	F_MessageChk(1,'[영수일자]')
	dw_1.SetColumn("gey_date")
	dw_1.SetFocus()
	Return -1
END IF

IF sVatGisu = "" OR IsNull(sVatGisu) THEN 
	F_MessageChk(1,'[부가세기수]')
	dw_1.SetColumn("vatgisu")
	dw_1.SetFocus()
	Return -1
END IF

IF sJasaCode = "" OR IsNull(sJasaCode) THEN 
	F_MessageChk(1,'[자사코드]')
	dw_1.SetColumn("jasa_cd")
	dw_1.SetFocus()
	Return -1
END IF

//IF sAcc1 = "" OR IsNull(sAcc1) THEN 
//	F_MessageChk(1,'[계정과목]')
//	dw_1.SetColumn("acc1_cd")
//	dw_1.SetFocus()
//	Return -1
//END IF
//
//IF sAcc2 = "" OR IsNull(sAcc2) THEN 
//	F_MessageChk(1,'[계정과목]')
//	dw_1.SetColumn("acc2_cd")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF sSaupNo = "" OR IsNull(sSaupNo) THEN 
	F_MessageChk(1,'[거래처]')
	dw_1.SetColumn("saup_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sCvname = "" OR IsNull(sCvname) THEN 
	F_MessageChk(1,'[거래처명]')
	dw_1.SetColumn("cvnas")
	dw_1.SetFocus()
	Return -1
END IF
//IF sOwnam = "" OR IsNull(sOwnam) THEN 
//	F_MessageChk(1,'[대표자명]')
//	dw_1.SetColumn("ownam")
//	dw_1.SetFocus()
//	Return -1
//END IF
IF (sSano = "" OR IsNull(sSano)) AND sTaxGbn <> '22' AND sTaxGbn <> '23' AND sTaxGbn <> '24' THEN  
	F_MessageChk(1,'[사업자등록번호]')
	dw_1.SetColumn("saup_no2")
	dw_1.SetFocus()
	Return -1
END IF

//IF sUptae = "" OR IsNull(sUptae) THEN 
//	F_MessageChk(1,'[업태]')
//	dw_1.SetColumn("uptae")
//	dw_1.SetFocus()
//	Return -1
//END IF
//
//IF sUpjong = "" OR IsNull(sUpjong) THEN 
//	F_MessageChk(1,'[업종]')
//	dw_1.SetColumn("jongk")
//	dw_1.SetFocus()
//	Return -1
//END IF
//IF sAddr = "" OR IsNull(sAddr) THEN 
//	F_MessageChk(1,'[주소]')
//	dw_1.SetColumn("addr1")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF sIoGbn = "" OR IsNull(sIoGbn) THEN 
	F_MessageChk(1,'[매입매출구분]')
	dw_1.SetColumn("io_gu")
	dw_1.SetFocus()
	Return -1
END IF
IF sTaxGbn = "" OR IsNull(sTaxGbn) THEN 
	F_MessageChk(1,'[부가세구분]')
	dw_1.SetColumn("tax_no")
	dw_1.SetFocus()
	Return -1
ELSE
	IF sTaxGbn = '23' THEN					/*수출면장*/
		if sExpNo = '' or IsNull(sExpNo) then
			F_MessageChk(1,'[수출신고번호]')
			dw_1.SetColumn("expno")
			dw_1.SetFocus()
			Return -1
		end if
		if sVoucGbn = '' or IsNull(sVoucGbn) then
			F_MessageChk(1,'[영세율증빙]')
			dw_1.SetColumn("vouc_gu")
			dw_1.SetFocus()
			Return -1
		end if
	ELSEIF sTaxGbn = '24' THEN
		if sVoucGbn = '' or IsNull(sVoucGbn) then
			F_MessageChk(1,'[영세율증빙]')
			dw_1.SetColumn("vouc_gu")
			dw_1.SetFocus()
			Return -1
		end if
		if sBalNm = '' or IsNull(sBalNm) then
			F_MessageChk(1,'[증빙발급자]')
			dw_1.SetColumn("ownplace")
			dw_1.SetFocus()
			Return -1
		end if
		if sSunDate = '' or IsNull(sSunDate) then
			F_MessageChk(1,'[선적일자]')
			dw_1.SetColumn("sunjukil")
			dw_1.SetFocus()
			Return -1
		end if
	END IF
END IF

IF sTaxGbn = '16' AND (sCardNo = '' or IsNull(sCardNo)) then
	F_MessageChk(1,'[카드번호]')
	dw_1.SetColumn("cardno")
	dw_1.SetFocus()
	Return -1
END IF

IF sTaxGbn = '18' AND (sCashNo = '' or IsNull(sCashNo)) then
	F_MessageChk(1,'[승인번호]')
	dw_1.SetColumn("cash_sno")
	dw_1.SetFocus()
	Return -1
END IF

IF sVatGbn = "3" AND (sBdsNo = '' or IsNull(sBdsNo)) then
	F_MessageChk(1,'[임대부동산 번호]')
	dw_1.SetColumn("bu_code")
	dw_1.SetFocus()
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
		dw_1.SetColumn("vat_amt")
		dw_1.SetFocus()
		Return -1
	END IF
	
	IF sRfna3 <> "Y" THEN
		F_MessageChk(1,'[세액]')
		dw_1.SetColumn("vat_amt")
		dw_1.SetFocus()
		Return -1
	END IF
END IF

IF dGonAmt = 0 OR IsNull(dGonAmt) THEN
	F_MessageChk(1,'[공급가액]')
	dw_1.SetColumn("gon_amt")
	dw_1.SetFocus()
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
		dw_1.SetColumn("saup_no")
		dw_1.SetFocus()
		Return -1
	END IF
	
	IF sTaxGbn = "22" THEN
		IF Isnull(sResi) Or Len(sResi) = 0 Then
			F_MessageChk(1,'[주민등록번호]')
			dw_1.SetColumn("saup_no")
			dw_1.SetFocus()
			Return -1
		END IF
	ELSE
		IF sRfna2 = "1" THEN
			F_MessageChk(1,'[사업자번호]')
			dw_1.SetColumn("saup_no")
			dw_1.SetFocus()
			Return -1
		END IF
	END IF
	
END IF

Return 1
end function

on w_kgla03.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_mvat=create dw_mvat
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_mvat
this.Control[iCurrent+3]=this.rr_1
end on

on w_kgla03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_mvat)
destroy(this.rr_1)
end on

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_mvat.SetTransObject(SQLCA)

Wf_Init()


end event

type dw_insert from w_inherite`dw_insert within w_kgla03
boolean visible = false
integer x = 27
integer y = 1876
integer taborder = 70
end type

type p_delrow from w_inherite`p_delrow within w_kgla03
boolean visible = false
integer x = 4462
integer y = 3308
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgla03
boolean visible = false
integer x = 4288
integer y = 3308
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgla03
integer x = 3717
integer y = 0
integer taborder = 60
string picturename = "C:\erpman\image\자료조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = 'C:\erpman\image\자료조회_dn.gif'
end event

event p_search::ue_lbuttonup;PictureName = 'C:\erpman\image\자료조회_up.gif'
end event

event p_search::clicked;call super::clicked;s_JunPoy str_kfz17ot0

SetNull(str_kfz17ot0.saupjang)
SetNull(str_kfz17ot0.baldate)
SetNull(str_kfz17ot0.upmugu)
SetNull(str_kfz17ot0.bjunno)
SetNull(str_kfz17ot0.linno)
SetNull(str_kfz17ot0.seqno)

OpenWithParm(w_kgla03a,Str_Kfz17ot0)

Str_Kfz17ot0 = Message.PowerObjectParm
IF Str_kfz17ot0.SeqNo = 0 OR IsNull(Str_kfz17ot0.seqno) THEN Return

dw_1.SetItem(1,"saupj",Str_kfz17ot0.saupjang)
dw_1.SetItem(1,"bal_date",Str_kfz17ot0.baldate)
dw_1.SetItem(1,"upmu_gu",Str_kfz17ot0.upmugu)
dw_1.SetItem(1,"bjun_no",Str_kfz17ot0.bjunno)
dw_1.SetItem(1,"lin_no",Str_kfz17ot0.linno)
dw_1.SetItem(1,"seq_no",Str_kfz17ot0.seqno)

p_inq.TriggerEvent(Clicked!)




end event

type p_ins from w_inherite`p_ins within w_kgla03
boolean visible = false
integer x = 3950
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgla03
integer x = 4416
integer y = 0
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kgla03
integer x = 4242
integer y = 0
integer taborder = 40
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_kgla03
boolean visible = false
integer x = 3767
integer y = 3308
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgla03
integer x = 3890
integer y = 0
end type

event p_inq::clicked;call super::clicked;String sSaupj,sBalDate,sUpmuGbn
Long   lJunNo,lLinNo,lSeqNo

dw_1.AcceptText()
sSaupj   = dw_1.GetItemString(dw_1.GetRow(),"saupj")
sBalDate = dw_1.GetItemString(dw_1.GetRow(),"bal_date")
sUpmuGbn = dw_1.GetItemString(dw_1.GetRow(),"upmu_gu")

lJunNo   = dw_1.GetItemNumber(dw_1.GetRow(),"bjun_no")
lLinNo   = dw_1.GetItemNumber(dw_1.GetRow(),"lin_no")

lSeqNo   = dw_1.GetItemNumber(dw_1.GetRow(),"seq_no")

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[회계단위]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

IF sBalDate = "" OR IsNull(sBalDate) THEN 
	F_MessageChk(1,'[발행일자]')
	dw_1.SetColumn("bal_date")
	dw_1.SetFocus()
	Return -1
END IF

IF lJunNo = 0 OR IsNull(lJunNo) THEN 
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("bjun_no")
	dw_1.SetFocus()
	Return -1
END IF

IF lLinNo = 0 OR IsNull(lLinNo) THEN 
	F_MessageChk(1,'[라인번호]')
	dw_1.SetColumn("lin_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN 
	F_MessageChk(1,'[전표구분]')
	dw_1.SetColumn("upmu_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF lSeqNo = 0 OR IsNull(lSeqNo) THEN 
	F_MessageChk(1,'[계산서번호]')
	dw_1.SetColumn("seq_no")
	dw_1.SetFocus()
	Return -1
END IF

IF Wf_Exiting_Chk(sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,lSeqNo) = 1 THEN
	F_MessageChk(14,'')
	dw_1.SetColumn("seq_no")
	dw_1.SetFocus()
	Return
END IF

dw_1.SetRedraw(False)
dw_1.Retrieve(sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,lSeqNo)

dw_1.Modify("saupj.protect = 1")
dw_1.Modify("bal_date.protect = 1")
dw_1.Modify("upmu_gu.protect = 1")
dw_1.Modify("bjun_no.protect = 1")
dw_1.Modify("lin_no.protect = 1")
dw_1.Modify("seq_no.protect = 1")

//dw_1.Modify("saupj.background.color = '"+ String(Rgb(192,192,192)) +"'")
//dw_1.Modify("bal_date.background.color = '"+ String(Rgb(192,192,192)) +"'")
//dw_1.Modify("upmu_gu.background.color = '"+ String(Rgb(192,192,192)) +"'")
//dw_1.Modify("bjun_no.background.color = '"+ String(Rgb(192,192,192)) +"'")
//dw_1.Modify("lin_no.background.color = '"+ String(Rgb(192,192,192)) +"'")
//dw_1.Modify("seq_no.background.color = '"+ String(Rgb(192,192,192)) +"'") 

dw_1.SetRedraw(True)

dw_1.SetColumn("alc_gu")
dw_1.SetFocus()
end event

type p_del from w_inherite`p_del within w_kgla03
boolean visible = false
integer x = 2405
integer y = 8
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Double dGong,dSumAmount,dPumGong,dPumVat

IF dw_1.GetRow() <=0 THEN Return

IF F_DbConFirm("삭제") = 2 THEN Return

IF Wf_Change_JunPoy('D',														&
						dw_1.GetItemString(dw_1.GetRow(),"saupj"),		&
						dw_1.GetItemString(dw_1.GetRow(),"bal_date"),	&
						dw_1.GetItemString(dw_1.GetRow(),"upmu_gu"),		&
						dw_1.GetItemNumber(dw_1.GetRow(),"bjun_no"),		&
						dw_1.GetItemNUmber(dw_1.GetRow(),"lin_no"),     &
						dw_1.GetItemNUmber(dw_1.GetRow(),"seq_no")) = -1 THEN
	Rollback;
	Return
END IF

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() <> 1 THEN
	F_MessageChk(12,'')
	Rollback;
	dw_1.SetRedraw(True)
	Return
else
	IF dw_mvat.Update() <> 1 THEN
		F_MessageChk(12,'[미결부가세]')
		Rollback;
		Return
	END IF
END IF

commit;
Wf_Init()

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'



end event

type p_mod from w_inherite`p_mod within w_kgla03
integer x = 4069
integer y = 0
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;Double dGong,dSumAmount,dPumGong,dPumVat

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

IF Wf_Change_JunPoy('I',														&
						dw_1.GetItemString(dw_1.GetRow(),"saupj"),		&
						dw_1.GetItemString(dw_1.GetRow(),"bal_date"),	&
						dw_1.GetItemString(dw_1.GetRow(),"upmu_gu"),		&
						dw_1.GetItemNumber(dw_1.GetRow(),"bjun_no"),		&
						dw_1.GetItemNUmber(dw_1.GetRow(),"lin_no"),     &
						dw_1.GetItemNUmber(dw_1.GetRow(),"seq_no")) = -1 THEN
	Rollback;
	Return
END IF

dGong      = dw_1.GetItemNumber(dw_1.GetRow(),"gon_amt")
dSumAmount = dw_1.GetItemNumber(dw_1.GetRow(),"vat_amt")
	
dPumGong   = dw_1.GetItemNumber(dw_1.GetRow(),"sum_gonamt")
dPumVat    = dw_1.GetItemNumber(dw_1.GetRow(),"sum_vatamt")
	
IF IsNull(dGong) THEN dGong = 0
IF IsNull(dSumAmount) THEN dSumAmount = 0
IF IsNull(dPumGong) THEN dPumGong = 0
IF IsNull(dPumVat) THEN dPumVat = 0

IF dPumGong <> 0 OR dPumVat <> 0 THEN
	IF dGong <> dPumGong OR dSumAmount <> dPumVat THEN
		MessageBox("확 인","입력하신 금액과 품목의 합계가 다릅니다.!!")
		Return
	END IF
END IF
	
IF F_DbConFirm("저장") = 2 THEN Return

IF dw_1.Update() <> 1 THEN
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

Wf_Init()

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'



end event

type cb_exit from w_inherite`cb_exit within w_kgla03
integer x = 3433
integer y = 3228
integer height = 104
end type

type cb_mod from w_inherite`cb_mod within w_kgla03
integer x = 2363
integer y = 3228
end type

type cb_ins from w_inherite`cb_ins within w_kgla03
integer x = 1134
integer y = 3352
end type

type cb_del from w_inherite`cb_del within w_kgla03
integer x = 2720
integer y = 3228
end type

type cb_inq from w_inherite`cb_inq within w_kgla03
integer x = 1504
integer y = 3232
end type

type cb_print from w_inherite`cb_print within w_kgla03
end type

type st_1 from w_inherite`st_1 within w_kgla03
end type

type cb_can from w_inherite`cb_can within w_kgla03
integer x = 3077
integer y = 3228
end type

type cb_search from w_inherite`cb_search within w_kgla03
integer x = 1870
integer y = 3232
end type







type gb_button1 from w_inherite`gb_button1 within w_kgla03
integer x = 37
integer y = 3276
integer width = 901
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla03
integer x = 2277
integer y = 3296
end type

type dw_1 from u_key_enter within w_kgla03
event ue_key pbm_dwnkey
integer x = 361
integer y = 184
integer width = 3890
integer height = 1952
integer taborder = 20
string dataobject = "dw_kgla031"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_any_typing = True
end event

event itemerror;Return 1
end event

event itemfocuschanged;
IF this.GetColumnName() = "cvnam" OR this.GetColumnName() = "ownam" OR &
	this.GetColumnName() = "uptae" OR this.GetColumnName() = "jongk" OR &
	this.GetColumnName() = "addr1" OR this.GetColumnName() = "descr" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event itemchanged;String  sSaupj,sBalDate,sUpmuGbn,sAccDate,sAlcGbn,sGeyDate,sVatGisu,sJasaCode,sAcc1_cd,&
		  sAcc2_cd,sAccName,sSaupNo,sCvName,sCustGbn,sSano,sUpTae,sUpJong,sOwnam,sResident,&
		  sAddr,sIoGbn,sTaxGbn,sVocuGbn,snull,sVatGbn,sGetJong,sCardNo,sOwner
Integer iCurRow,lJunNo,lLinNo,lBJunNo,lSeqNo,lnull
Double  dVatAmt,dQty,dUprice

SetNull(snull)
SetNull(lnull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
	
	IF Wf_Exiting_Chk(sSaupj,	&
						this.GetItemString(iCurRow,"bal_date"),	&
						this.GetItemString(iCurRow,"upmu_gu"),		&
						this.GetItemNumber(iCurRow,"bjun_no"),		&
						this.GetItemNUmber(iCurRow,"lin_no"),		&
						this.GetItemNUmber(iCurRow,"seq_no")) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
	
END IF

IF this.GetColumnName() = "bal_date" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(iCurRow,"bal_date",snull)
		Return 1
	END IF
	
	IF Wf_Exiting_Chk(this.GetItemString(iCurRow,"saupj"),	&
						sBalDate,	&
						this.GetItemString(iCurRow,"upmu_gu"),		&
						this.GetItemNumber(iCurRow,"bjun_no"),		&
						this.GetItemNUmber(iCurRow,"lin_no"),		&
						this.GetItemNUmber(iCurRow,"seq_no")) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "upmu_gu" THEN
	sUpmuGbn = this.GetText()
	IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AG',sUpmuGbn)) THEN
		F_MessageChk(20,'[전표구분]')
		this.SetItem(iCurRow,"upmu_gu",sNull)
		Return 1
	END IF
	IF Wf_Exiting_Chk(this.GetItemString(iCurRow,"saupj"),	&
						this.GetItemString(iCurRow,"bal_date"),	&
						sUpmuGbn,		&
						this.GetItemNumber(iCurRow,"bjun_no"),		&
						this.GetItemNUmber(iCurRow,"lin_no"),		&
						this.GetItemNUmber(iCurRow,"seq_no")) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "bjun_no" THEN
	lBjunNo = Double(this.GetText())
	IF lBjunNo = 0 OR IsNull(lBjunNo) THEN RETURN
	
	IF Wf_Exiting_Chk(this.GetItemString(iCurRow,"saupj"),	&
						this.GetItemString(iCurRow,"bal_date"),	&
						this.GetItemString(iCurRow,"upmu_gu"),		&
						lBJunNo,		&
						this.GetItemNUmber(iCurRow,"lin_no"),		&
						this.GetItemNUmber(iCurRow,"seq_no")) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "lin_no" THEN
	lLinNo = Double(this.GetText())
	IF lLinNo = 0 OR IsNull(lLinNo) THEN RETURN
	
	IF Wf_Exiting_Chk(this.GetItemString(iCurRow,"saupj"),	&
						this.GetItemString(iCurRow,"bal_date"),	&
						this.GetItemString(iCurRow,"upmu_gu"),		&
						this.GetItemNUmber(iCurRow,"bjun_no"),		&
						lLinNo,		&
						this.GetItemNUmber(iCurRow,"seq_no")) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "alc_gu" THEN
	sAlcGbn = this.GetText()
	IF sAlcGbn = "" OR IsNull(sAlcGbn) THEN RETURN
	
	IF sAlcGbn <> 'Y' AND sAlcGbn <> 'N' THEN
		F_MessageChk(20,'[승인구분]')
		this.SetItem(iCurRow,"alc_gu",sNull)
		Return 1
	ELSE
		IF sAlcGbn = 'N' THEN
			this.SetItem(iCurRow,"acc_date",snull)
			this.SetItem(iCurRow,"jun_no"  ,lnull)
		END IF
	END IF
END IF

IF this.GetColumnName() = "acc_date" THEN
	sAccDate = Trim(this.GetText())
	IF sAccDate = "" OR IsNull(sAccDate) THEN RETURN
	
	IF F_DateChk(sAccDate) = -1 THEN
		F_MessageChk(21,'[승인일자]')
		this.SetItem(iCurRow,"acc_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "seq_no" THEN
	lSeqNo = Double(this.GetText())
	IF lSeqNo = 0 OR IsNull(lSeqNo) THEN RETURN
	
	IF Wf_Exiting_Chk(this.GetItemString(iCurRow,"saupj"),	&
						this.GetItemString(iCurRow,"bal_date"),	&
						this.GetItemString(iCurRow,"upmu_gu"),		&
						this.GetItemNUmber(iCurRow,"bjun_no"),		&
						this.GetItemNUmber(iCurRow,"lin_no"),		&
						lSeqNo) = 1 THEN Return 
						
	p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() ="gey_date" THEN
	sGeyDate = Trim(this.GetText())
	IF sGeyDate = "" OR IsNull(sGeyDate) THEN RETURN
	
	IF F_DateChk(sGeyDate) = -1 THEN 
		F_MessageChk(21,'[계산서일자]')
		dw_1.SetItem(iCurRow,"gey_date",snull)
		Return 1
	END IF
	
	this.SetItem(iCurRow,"vatgisu", F_Get_VatGisu(gs_saupj,sGeyDate))
END IF

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		dw_1.SetItem(iCurRow,"vatgisu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jasa_cd" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN Return
	
	IF IsNull(F_Get_Refferance('JA',sJasaCode)) THEN
		F_MessageChk(20,'[자사코드]')
		dw_1.SetItem(iCurRow,"jasa_cd",snull)
		Return 1
	END IF
	
	DataWindowChild  Dw_Child
	Integer          iVal

	iVal = dw_1.GetChild("vatgbn",Dw_Child)
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
		this.SetItem(iCurRow,"vatgbn",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
	END IF
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
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

IF this.GetColumnName() ="io_gu" THEN
	sIoGbn = this.GetText()
	IF sIoGbn = "" OR IsNull(sIoGbn) THEN Return
	
	IF sIoGbn <> '1' AND sIoGbn <> '2' THEN
		F_MessageChk(20,'[매입매출구분]')
		dw_1.SetItem(iCurRow,"io_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="tax_no" THEN
	sTaxGbn = this.GetText()
	IF sTaxGbn ="" OR IsNull(sTaxGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sTaxGbn)) THEN
		F_MessageChk(20,'[부가세구분]')
		dw_1.SetItem(iCurRow,"tax_no",snull)
		Return 1
	END IF
	dw_1.SetItem(iCurRow,"io_gu",Left(sTaxGbn,1))
	
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
		dw_1.SetItem(iCurRow,"vouc_gu",snull)
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
		this.SetItem(iCurRow,"vat_amt",lnull)
		Return 1
	ELSEIF this.GetItemString(iCurRow,"tax_no") = '03' AND dVatAmt <> 0 THEN
		this.SetItem(iCurRow,"vat_amt",0)
		Return 2
	END IF
	
	this.SetItem(iCurRow,"gon_amt",dVatAmt * 10)
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
ib_any_typing = True

end event

event rbuttondown;String snull

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
	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
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

event getfocus;this.AcceptText()
end event

type dw_mvat from datawindow within w_kgla03
boolean visible = false
integer x = 622
integer y = 2452
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

type rr_1 from roundrectangle within w_kgla03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 201
integer y = 164
integer width = 4238
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

