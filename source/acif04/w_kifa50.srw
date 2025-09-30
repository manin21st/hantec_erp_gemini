$PBExportHeader$w_kifa50.srw
$PBExportComments$자동전표 관리 : 수입비용
forward
global type w_kifa50 from w_inherite
end type
type gb_1 from groupbox within w_kifa50
end type
type rb_1 from radiobutton within w_kifa50
end type
type rb_2 from radiobutton within w_kifa50
end type
type dw_junpoy from datawindow within w_kifa50
end type
type dw_sungin from datawindow within w_kifa50
end type
type dw_vat from datawindow within w_kifa50
end type
type dw_print from datawindow within w_kifa50
end type
type dw_ip from u_key_enter within w_kifa50
end type
type dw_sang from datawindow within w_kifa50
end type
type dw_kfz12ote from datawindow within w_kifa50
end type
type dw_dae from datawindow within w_kifa50
end type
type rr_1 from roundrectangle within w_kifa50
end type
type dw_rtv from datawindow within w_kifa50
end type
type cbx_all from checkbox within w_kifa50
end type
type gb_detail from groupbox within w_kifa50
end type
type dw_list from datawindow within w_kifa50
end type
type gb_list from groupbox within w_kifa50
end type
type dw_delete from datawindow within w_kifa50
end type
type dw_sang_detail from datawindow within w_kifa50
end type
end forward

global type w_kifa50 from w_inherite
integer height = 2416
string title = "수입비용전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_vat dw_vat
dw_print dw_print
dw_ip dw_ip
dw_sang dw_sang
dw_kfz12ote dw_kfz12ote
dw_dae dw_dae
rr_1 rr_1
dw_rtv dw_rtv
cbx_all cbx_all
gb_detail gb_detail
dw_list dw_list
gb_list gb_list
dw_delete dw_delete
dw_sang_detail dw_sang_detail
end type
global w_kifa50 w_kifa50

type variables
String sUpmuGbn = 'K',sSdeptCode,LsAutoSungGbn,LsExceptCode
end variables

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_delete_kfz12ot0 ()
public function string wf_exceptcode_chk (string sbiyongcode)
public function integer wf_insert_kfz12ote (integer irow, string schgbn, string ssaupj, string sbaldate, long lbjunno, integer llinno, double damount, ref string schaipno, ref string schaipname)
public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount)
public function integer wf_insert_sang_cha (string sacc1, string sacc2, string saupno, double damount, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, boolean ssangchk)
public function string wf_chaip_no (string sgisandate)
public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno, string ssawon)
public function integer wf_insert_kfz12ot0 (string sbaldate, string sdeptcode)
end prototypes

public function integer wf_requiredchk ();String  sWonGaDept
Integer i

dw_rtv.AcceptText()
for i = 1 to dw_rtv.RowCount()
	sWonGaDept = dw_rtv.GetItemString(i,"sdept_cd") 
	IF sWonGaDept = "" OR IsNull(sWonGaDept) THEN
		F_MessageChk(1,'[원가부문]')
		dw_rtv.SetColumn("sdept_cd")
		dw_rtv.SetFocus()
		Return -1
	END IF
next

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		END IF

		/*수입비용자료 전표 발행 취소*/
//		dw_delete.SetItem(k,"saupj",   sNull)
		UPDATE "KIF07OT0"  
     		SET "BAL_DATE" = null,   		"UPMU_GU" = null,   		"BJUN_NO" = 0,   	"LIN_NO" = 0
		   WHERE ( "KIF07OT0"."SAUPJ" = :sSaupj ) AND  ( "KIF07OT0"."BAL_DATE" = :sBalDate ) AND  
					( "KIF07OT0"."UPMU_GU" = :sUpmuGu ) AND ( "KIF07OT0"."BJUN_NO" = :lJunNo );
		IF sqlca.sqlcode <> 0 THEN
			F_MessageChk(13,'[수입비용자료]')
			SetPointer(Arrow!)	
			RETURN -1
		END IF

	END IF
NEXT

COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
//	FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
//         ( "SYSCNFG"."LINENO" = '1' )   ;
//IF SQLCA.SQLCODE <> 0 THEN 
//	sJipFlag = 'N'
//ELSE
//	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
//END IF

//IF sJipFlag = 'Y' THEN
//	sJipFrom = dw_delete.GetItemString(1,"min_ym")
//	sJipTo   = dw_delete.GetItemString(1,"max_ym")
//	
//	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//전사로 집계('00'월)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	//stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF

SetPointer(Arrow!)
Return 1

end function

public function string wf_exceptcode_chk (string sbiyongcode);String sExceptcode

sExceptcode = 'N'

DECLARE Cur_ValidExceptcode CURSOR FOR  
	SELECT "SYSCNFG"."DATANAME"
   	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 13 ) AND  
         ( "SYSCNFG"."LINENO" <> '00' )   
	ORDER BY "SYSCNFG"."LINENO" ASC  ;

Open Cur_ValidExceptcode;

DO WHILE True
	Fetch Cur_ValidExceptcode INTO :LsExceptCode;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	IF  sbiyongcode = LsExceptCode THEN
		sExceptcode = 'Y'
		Exit
	END IF
Loop
Close Cur_ValidExceptcode;

Return sExceptcode
end function

public function integer wf_insert_kfz12ote (integer irow, string schgbn, string ssaupj, string sbaldate, long lbjunno, integer llinno, double damount, ref string schaipno, ref string schaipname);String   sJpyNo,sSetNo,sBnkCd,sFrom,sTo,sCurr
Double   dAmtF,dIlRate,dExpRate

sJpyNo = dw_rtv.GetItemString(iRow,"expjpno")

select a.setno,				a.gipdat,				a.mandat,		
		 nvl(a.ilrate,0),		nvl(a.grate,0),		nvl(a.kumusd,0)
	into :sSetNo,				:sFrom,					:sTo,
		  :dIlRate,				:dExpRate,				:dAmtF
	from polcsethd a
	where a.sabu = '1' and a.sujpno = :sJpyNo;
if sqlca.sqlcode <> 0 then
	F_MessageChk(16,'[구매결제내역 없슴]')
	Return -1
end if

dw_kfz12ote.InsertRow(0)

if schaipno = '' or IsNull(schaipno) then
	schaipno   = Wf_ChaIp_No(sBalDate)
	schaipname = '구매결제 차입'
end if

dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_cd",      sChaipNo)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_name",    sChaipName)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_bnkno",   sSetNo)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"acc1_cd",    Left(dw_rtv.GetItemString(iRow,"saccod"),5))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"acc2_cd",    Right(dw_rtv.GetItemString(iRow,"saccod"),2))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_bnkcd",   sBnkCd)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_afdt",    sFrom)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_atdt",    sTo)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_rat",     dIlRate)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_excrat",  dExpRate)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_camt",    dAmount)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_ycamt",   dAmtF)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_aday",    Right(sBalDate,2))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_curr",    dw_rtv.GetItemString(iRow,"forcur"))
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lo_sgbn",    '1')

dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"saupj",      sSaupj)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"bal_date",   sBalDate)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"upmu_gu",    sUpmuGbn)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"bjun_no",    lBJunNo)
dw_kfz12ote.SetItem(dw_kfz12ote.GetRow(),"lin_no",     lLinNo)

Return 1
end function

public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount);
///*반제 처리 화면 띄워서 처리 (99.10.13 수정)*/
//lstr_jpra.saupjang = ssaupj
//lstr_jpra.baldate  = sbaldate
//lstr_jpra.upmugu   = supmugu
//lstr_jpra.bjunno   = ljunno
//lstr_jpra.sortno   = llinno
//lstr_jpra.saupno   = saupno
//lstr_jpra.acc1     = sacc1
//lstr_jpra.acc2     = sacc2
//lstr_jpra.money    = damount
//				
//OpenWithParm(W_kglb01g,'')
//IF Message.StringParm = '0' THEN		/*반제처리 안함*/
//	F_MessageChk(17,'[반제 처리]')
//	Return -1
//END IF			

///*반제 처리 = 반제전표번호를 읽어서 처리*/
//
//String  sCrossNo, sSaupjS,sAccDateS,sUpmuGuS,sBalDateS
//Long    lJunNoS,lLinNoS,lBJunNos
//Integer iInsertrow
//
//sCrossNo = dw_rtv.GetItemString(icurrow,"crossno")
//IF sCrossNo = "" OR IsNull(sCrossNo) THEN
//	F_MessageChk(1,'[반제전표번호]')
//	Return -1
//END IF
//
//sSaupjS   = Left(sCrossNo,2)
//sAccDateS = Mid(sCrossNo,3,8)
//sUpmuGuS  = Mid(sCrossNo,11,1)
//lJunNoS   = Long(Mid(sCrossNo,12,4))
//lLinNoS   = Integer(Mid(sCrossNo,16,3)) 
//sBalDateS = Mid(sCrossNo,19,8)
//lBJunNoS  = Long(Mid(sCrossNo,27,4)) 
//
//iInsertRow = dw_sang.InsertRow(0)
//	
//dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
//dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
//dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuGuS)
//dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
//dw_sang.SetItem(iInsertRow,"lin_no",   lLinNoS)
//dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
//dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
//	
//dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
//dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
//dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
//dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
//dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
//dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)

Return 1
end function

public function integer wf_insert_sang_cha (string sacc1, string sacc2, string saupno, double damount, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, boolean ssangchk);
Integer iCount,iInsertRow,k
Double  dRemainAmt,dCurAmt,dTempAmt

IF sSangChk = True THEN Return 1

/*반제 처리 화면 띄워서 처리 (99.10.13 수정)*/
lstr_jpra.saupjang = ssaupj
lstr_jpra.baldate  = sbaldate
lstr_jpra.upmugu   = supmugu
lstr_jpra.bjunno   = ljunno
lstr_jpra.sortno   = llinno
lstr_jpra.saupno   = saupno
lstr_jpra.acc1     = sacc1
lstr_jpra.acc2     = sacc2
lstr_jpra.money    = damount
				
OpenWithParm(W_kglb01g,'')
IF Message.StringParm = '0' THEN		/*반제처리 안함*/
	F_MessageChk(17,'[반제 처리]')
	Return -1
END IF			

Return 1
end function

public function string wf_chaip_no (string sgisandate);String   sChaipNo
Integer  iMaxNo

SELECT MAX(TO_NUMBER(SUBSTR(A.LOCD,5,3)))
	INTO :iMaxNo  
	FROM(SELECT "KFM03OT0"."LO_CD" AS LOCD
		   FROM "KFM03OT0"  
   		WHERE SUBSTR("KFM03OT0"."LO_AFDT",1,4) = SUBSTR(:sGisanDate,1,4) 
		  UNION ALL
		  SELECT "KFZ12OTE"."LO_CD" AS LOCD
		   FROM "KFZ12OTE"  
   		WHERE SUBSTR("KFZ12OTE"."LO_AFDT",1,4) = SUBSTR(:sGisanDate,1,4) 
		  UNION ALL
		  SELECT "KFZ19OT5"."CHAIP_NO" AS LOCD
		  	FROM "KFZ19OT5"  
   		WHERE SUBSTR("KFZ19OT5"."GISAN_DATE",1,4) = SUBSTR(:sGisanDate,1,4) ) A;
			
IF SQLCA.SQLCODE <> 0 THEN
	iMaxNo = 0
ELSE
	IF IsNull(iMaxNo) THEN iMaxNo = 0
END IF

iMaxNo = iMaxNo + 1

sChaipNo = Left(sGisanDate,4) + String(iMaxNo,'000')

Return sChaipNo
end function

public function integer wf_create_vat (integer irow, string ssaupj, string sbaldate, long ljunno, ref integer llinno, string ssawon);String  sAcc1_Vat,sAcc2_Vat,sSaupNo,sJasaCode
Integer iAddRow,iCurRow

IF dw_rtv.GetItemString(iRow,"vatgu") = '15' then Return 1

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*선급부가세*/
	INTO :sAcc1_Vat,  						  :sAcc2_Vat	
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[선급부가세(A-1-2)]')
	RETURN -1
END IF

/*자사코드*/
SELECT "REFFPF"."RFNA2"      INTO :sJasaCode  
	FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;

if dw_rtv.GetItemNumber(irow,"vatamt") <> 0 OR Wf_ExceptCode_Chk(dw_rtv.GetItemString(iRow,"acccod")) = 'Y' then
	/*전표 추가*/
	iCurRow = dw_junpoy.InsertRow(0)
	
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_ip.GetItemString(1,"deptcd"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Vat)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Vat)
	dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  '1')
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(irow,"vatamt"))	
	dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(iRow,"polcno") +'[부가세]')	
				
	dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(iRow,"sdept_cd"))
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(iRow,"cvname"))
	
	dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
END IF

/*부가세 자료 생성*/
iAddRow = dw_vat.InsertRow(0)
dw_vat.SetItem(iAddRow,"saupj",   sSaupj)
dw_vat.SetItem(iAddRow,"bal_date",sBalDate)
dw_vat.SetItem(iAddRow,"upmu_gu", sUpmuGbn)
dw_vat.SetItem(iAddRow,"bjun_no", lJunNo)

if dw_rtv.GetItemNumber(irow,"vatamt") <> 0 OR Wf_ExceptCode_Chk(dw_rtv.GetItemString(iRow,"acccod")) = 'Y' then
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo)
else
	dw_vat.SetItem(iAddRow,"lin_no",  lLinNo - 1)
end if

dw_vat.SetItem(iAddRow,"gey_date",dw_rtv.GetItemString(iRow,"accdat"))
dw_vat.SetItem(iAddRow,"seq_no",  1)
dw_vat.SetItem(iAddRow,"saup_no", dw_rtv.GetItemString(iRow,"cvcod"))
dw_vat.SetItem(iAddRow,"gon_amt", dw_rtv.GetItemNumber(irow,"wonamt"))
dw_vat.SetItem(iAddRow,"vat_amt", dw_rtv.GetItemNumber(irow,"vatamt"))	

dw_vat.SetItem(iAddRow,"for_amt", dw_rtv.GetItemNumber(iRow,"format"))
dw_vat.SetItem(iAddRow,"tax_no",  dw_rtv.GetItemString(iRow,"vatgu"))
dw_vat.SetItem(iAddRow,"io_gu",   '1')										/*매입*/
dw_vat.SetItem(iAddRow,"saup_no2",dw_rtv.GetItemString(iRow,"vndmst_sano"))
dw_vat.SetItem(iAddRow,"acc1_cd", sAcc1_Vat)
dw_vat.SetItem(iAddRow,"acc2_cd", sAcc2_Vat)
dw_vat.SetItem(iAddRow,"descr",   dw_rtv.GetItemString(iRow,"descr")+'[부가세]')	
dw_vat.SetItem(iAddRow,"jasa_cd", sJasaCode)
dw_vat.SetItem(iAddRow,"lc_no",   dw_rtv.GetItemString(iRow,"polcno"))
dw_vat.SetItem(iAddRow,"cvnas",   dw_rtv.GetItemString(iRow,"cvname"))
dw_vat.SetItem(iAddRow,"ownam",   dw_rtv.GetItemString(iRow,"vndmst_ownam"))
dw_vat.SetItem(iAddRow,"resident",dw_rtv.GetItemString(iRow,"vndmst_resident"))
dw_vat.SetItem(iAddRow,"uptae",   dw_rtv.GetItemString(iRow,"vndmst_uptae"))
dw_vat.SetItem(iAddRow,"jongk",   dw_rtv.GetItemString(iRow,"vndmst_jongk"))
dw_vat.SetItem(iAddRow,"addr1",   dw_rtv.GetItemString(iRow,"vndmst_addr1"))
//dw_vat.SetItem(iAddRow,"addr2",   dw_rtv.GetItemString(iRow,"vndmst_addr2"))
dw_vat.SetItem(iAddRow,"vatgisu", F_Get_VatGisu(sSaupj,sBalDate))
dw_vat.SetItem(iAddRow,"exc_rate",dw_rtv.GetItemNumber(iRow,"forrat"))
dw_vat.SetItem(iAddRow,"curr",    dw_rtv.GetItemString(iRow,"forcur"))

if dw_rtv.GetItemNumber(irow,"vatamt") <> 0 OR Wf_ExceptCode_Chk(dw_rtv.GetItemString(iRow,"acccod")) = 'Y' then
	lLinNo = lLinNo + 1
end if

Return 1
end function

public function integer wf_insert_kfz12ot0 (string sbaldate, string sdeptcode);/************************************************************************************/
/* 수입비용 자료를 자동으로 전표 처리한다.														*/
/* 1. 차변 : 수입비용코드(참조 '55'의 참조명(S)의 값)로 발생.								*/
/*           선급부가세 계정으로 발생.(환경파일 A-1-2)										*/
/* 2. 대변 : 상대계정(참조 '1D'의 참조명(S)의 값)로 발생.									*/
/************************************************************************************/

String    sSaupj,sExpNo,sBiYongCd,sSawon,sAcc1_Cha,sAcc2_Cha,sBiYongName,sRemark1,&
			 sChaDae,sCusGbn,sGbn1,sDcGbn,sSaupNo,sVatGbn,sAcc1_Dae,sAcc2_Dae,sMulGbn,&
			 sSangFlag,sChGbn,sSaupName,sDescr,sIjaAcc1,sIjaAcc2,sChaipNo,sDptNo,sYesanGbn,&
			 sPolcNo,sLocalYn
Integer   iDetailCnt,k,i,lLinNo,iCurRow,iFindRow,j,iSangcnt
Long      lJunNo
Double    dVatAmt,dAmount,dChaIpWon,dMiChaAmt,dChIjaAmt,dDpAmt,dCashAmt

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="수입비용 자동전표 처리 중 ..."

dw_rtv.AcceptText()

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
			
SetPointer(HourGlass!)

FOR k = 1 TO dw_list.RowCount()
	IF dw_list.GetItemString(k,"chk") = '1' THEN	
		dw_junpoy.Reset()
		dw_vat.Reset()
		dw_sang.Reset()
		dw_kfz12ote.Reset()
		dw_dae.Reset()
		
		sExpNo    = dw_list.GetItemString(k,"expno")
		
		iDetailCnt = dw_rtv.Retrieve('1',sExpNo)
		IF iDetailCnt <=0 THEN Continue
		
		sSaupj    = dw_list.GetItemString(k,"saupj")
		
		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		sSawon = dw_list.GetItemString(k,"sawon")	//정산신청자
		
		FOR i = 1 TO iDetailCnt
			sBiYongCd = dw_rtv.GetItemString(i,"acccod") 												/*비용코드*/
			sPolcNo   = dw_rtv.GetItemString(i,"polcno")
			sDescr    = dw_rtv.GetItemString(i,"descr")
			IF sDescr = '' OR IsNull(sDescr) THEN sDescr = ''
						
			dChaIpWon = dw_rtv.GetItemNumber(i,"chaipwon")
			if IsNull(dChaIpWon) then dChaipWon = 0
			
			if sPolcNo = '' or IsNull(sPolcNo) then
				sLocalYn = 'N'
			else
				select nvl(localyn,'N')	into :sLocalYn	from polchd	where sabu = '1' and polcno = :sPolcNo;
			end if
			
			sDcGbn = '1'											/*차변 전표-미착원재료*/
				
			/*부가세만 발생 코드*/					
			IF Wf_ExceptCode_Chk(sBiYongCd) = 'N' THEN								
				if sLocalYn = 'N' then							/*direct*/
					SELECT SUBSTR("REFFPF"."RFNA2",1,5),  	SUBSTR("REFFPF"."RFNA2",6,2),
							 "REFFPF"."RFNA1",					"KFZ01OM0"."REMARK1",	"KFZ01OM0"."DC_GU",
							 "KFZ01OM0"."CUS_GU",				"KFZ01OM0"."GBN1",		"KFZ01OM0"."YESAN_GU"
						INTO :sAcc1_Cha,							:sAcc2_Cha,
							  :sBiYongName,						:sReMark1,					:sChaDae,
							  :sCusGbn,								:sGbn1,						:sYesanGbn
						FROM "REFFPF", "KFZ01OM0"  
						WHERE ( "REFFPF"."RFCOD" = '55' ) AND ( "REFFPF"."RFGUB" = :sBiyongCd ) AND
								SUBSTR("REFFPF"."RFNA2",1,5) = "KFZ01OM0"."ACC1_CD" AND
								SUBSTR("REFFPF"."RFNA2",6,2) = "KFZ01OM0"."ACC2_CD" ;
								
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
						
					dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(i,"wonamt"))	
					dw_junpoy.SetItem(iCurRow,"descr",   sDescr)
					
					IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN
						dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(i,"sdept_cd"))
					END IF
					
					IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
						dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
					END IF
				
					IF sCusGbn = 'Y' THEN					
						IF sGbn1 = '9' THEN
							sSaupNo = dw_rtv.GetItemString(i,"polcno")
						ELSE
							sSaupNo = dw_rtv.GetItemString(i,"cvcod")
							dw_junpoy.SetItem(iCurRow,"in_nm",  dw_rtv.GetItemString(i,"cvname"))
						END IF
						
						dw_junpoy.SetItem(iCurRow,"saup_no",   sSaupNo)
					ELSE
						SetNull(sSaupNo)
						dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
						dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNo)
					END IF
					
					dw_junpoy.SetItem(iCurRow,"in_cd",   dw_rtv.GetItemString(i,"acccod"))
						
					dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(i,"forcur"))		
					dw_junpoy.SetItem(iCurRow,"y_amt",   dw_rtv.GetItemNumber(i,"format"))
					dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(i,"forrat"))
					
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
					lLinNo = lLinNo + 1					
				else													/*local*/
					SELECT "KFZ01OM0"."ACC1_CD",  			"KFZ01OM0"."ACC2_CD",
							 "KFZ01OM0"."REMARK1",				"KFZ01OM0"."DC_GU",		"KFZ01OM0"."SANG_GU",
							 "KFZ01OM0"."CUS_GU",				"KFZ01OM0"."GBN1",		"KFZ01OM0"."YESAN_GU"
						INTO :sAcc1_Cha,							:sAcc2_Cha,				
							  :sReMark1,							:sChaDae,					:sSangFlag,
							  :sCusGbn,								:sGbn1,						:sYesanGbn
						FROM "SYSCNFG", "KFZ01OM0"  
						WHERE ( "SYSCNFG"."SYSGU" = 'A' AND "SYSCNFG"."SERIAL" = 1 AND "SYSCNFG"."LINENO" = '13') AND
								SUBSTR("SYSCNFG"."DATANAME",8,5) = "KFZ01OM0"."ACC1_CD" AND
								SUBSTR("SYSCNFG"."DATANAME",13,2) = "KFZ01OM0"."ACC2_CD" ;

					iSangCnt = dw_sang_detail.Retrieve('1',sExpNo)
					for j = 1 to iSangCnt
						
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
							
						dw_junpoy.SetItem(iCurRow,"amt",     dw_sang_detail.GetItemNumber(j,"wonamt"))	
						dw_junpoy.SetItem(iCurRow,"descr",   sDescr)
						
						IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN
							dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(i,"sdept_cd"))
						END IF
						
						IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
							dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
						END IF
					
						IF sCusGbn = 'Y' THEN					
							IF sGbn1 = '9' THEN
								sSaupNo = dw_rtv.GetItemString(i,"polcno")
							ELSE
								sSaupNo = dw_sang_detail.GetItemString(j,"cvcod")
								dw_junpoy.SetItem(iCurRow,"in_nm",  dw_sang_detail.GetItemString(j,"cvname"))
							END IF
							
							dw_junpoy.SetItem(iCurRow,"saup_no",   sSaupNo)
						ELSE
							SetNull(sSaupNo)
							dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
							dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNo)
						END IF
						
						dw_junpoy.SetItem(iCurRow,"in_cd",   dw_rtv.GetItemString(i,"acccod"))
						
						IF sDcGbn <> sChaDae and sSangFlag = 'Y' THEN				/*반제처리 계정이면*/
							IF Wf_Insert_Sang_Cha(sAcc1_Cha,sAcc2_Cha,sSaupNo,dw_sang_detail.GetItemNumber(j,"wonamt"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,False) = 1 THEN	
								dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
							ELSE
								Return -1
							END IF				
						END IF
							
						dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(i,"forcur"))		
						dw_junpoy.SetItem(iCurRow,"y_amt",   dw_rtv.GetItemNumber(i,"format"))
						dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(i,"forrat"))
						
						dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
						lLinNo = lLinNo + 1		
					next
				end if
			END IF

			dw_rtv.SetItem(i,"saupj",   			sSaupj)
			dw_rtv.SetItem(i,"bal_date",			sBalDate)
			dw_rtv.SetItem(i,"upmu_gu", 			sUpmuGbn)
			dw_rtv.SetItem(i,"bjun_no", 			lJunNo)		
			
			dVatAmt = dw_rtv.GetItemNumber(i,"vatamt")
			sVatGbn = dw_rtv.GetItemString(i,"vatgu")
			IF IsNull(dVatAmt) THEN dVatAmt = 0
			
			/*선급부가세 계정 생성(차변)*/
			IF dVatAmt = 0 and (sVatGbn = '' or IsNull(sVatGbn)) THEN 
			ELSE			
				if dVatAmt = 0 then
					dw_junpoy.SetItem(iCurRow,"vat_gu",  'Y') 
				end if
					
				IF Wf_Create_Vat(i,sSaupj,sBalDate,lJunNo,lLinNo,sSawon) = -1 THEN
					SetPointer(Arrow!)
					Return -1
				END IF
			END IF
			
			/*구매자금결제일 경우 미착타발금 비용 계정 생성 : 2004.01.31*/
			dMiChaAmt = dw_rtv.GetItemNumber(i,"michamt")
			if IsNull(dMiChaAmt) then dMiChaAmt = 0
			if dMiChaAmt <> 0 then
				
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
					
				dw_junpoy.SetItem(iCurRow,"amt",     dMiChaAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '타발 추심료')
				
				IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(i,"sdept_cd"))
				END IF
				
				IF sCusGbn = 'Y' THEN
					IF sGbn1 = '9' THEN
						dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(i,"polcno"))
					ELSE
						dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(i,"cvcod"))
						dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(i,"cvname"))
					END IF
				ELSE
					SetNull(sSaupNo)
					dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
					dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNo)
				END IF
				
				dw_junpoy.SetItem(iCurRow,"in_cd",   dw_rtv.GetItemString(i,"acccod"))
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			end if
			
			/*구매자금결제일 경우 이자비용 생성 : 2004.01.31*/
			dChIjaAmt = dw_rtv.GetItemNumber(i,"ijaamt")
			if IsNull(dChIjaAmt) then dChIjaAmt = 0
			if dChIjaAmt <> 0 then			
				sIjaAcc1 = dw_rtv.GetItemString(i,"ija_accod1")
				sIjaAcc2 = dw_rtv.GetItemString(i,"ija_accod2")
				
				select dc_gu,		cus_gu,		gbn1, 	remark1, 	yesan_gu 
					into :sChaDae, :sCusGbn,	:sGbn1,  :sRemark1,	:sYesanGbn
					from kfz01om0 
					where acc1_cd = :sIjaAcc1 and acc2_cd = :sIjaAcc2 ;
				
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sIjaAcc1)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sIjaAcc2)
				dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dChIjaAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '무역금융비용')
				
				IF sRemark1 = 'Y' AND sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(i,"sdept_cd"))
				END IF
				
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
				END IF
			
				IF sCusGbn = 'Y' THEN
					IF sGbn1 = '9' THEN						/*LC번호*/
						dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(i,"polcno"))
					ELSEIF sGbn1 = '6' THEN					/*차입금*/
						dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(i,"depotno"))
						dw_junpoy.SetItem(iCurRow,"in_nm",   f_get_personlst('6',dw_rtv.GetItemString(i,"depotno"),'%'))
					ELSE

						dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(i,"cvcod"))
						dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(i,"cvname"))
					END IF
				ELSE
					SetNull(sSaupNo)
					dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
					dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNo)
				END IF
				
				dw_junpoy.SetItem(iCurRow,"in_cd",   dw_rtv.GetItemString(i,"acccod"))
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			end if
		NEXT		
		
		/*대변*/
		sDcGbn = '2'											/*대변 전표(1)*/		
		iDetailCnt = dw_dae.Retrieve('1',sExpNo,sDeptCode)
		IF iDetailCnt <=0 THEN Continue
				
		FOR i = 1 TO iDetailCnt
			sAcc1_Dae = Left(dw_dae.GetItemString(i,"saccod"),5)
			sAcc2_Dae = Right(dw_dae.GetItemString(i,"saccod"),2)
			
			SELECT "KFZ01OM0"."CUS_GU",	"KFZ01OM0"."GBN1",		"KFZ01OM0"."SANG_GU", 	
					 "KFZ01OM0"."DC_GU",		"KFZ01OM0"."REMARK1",   "KFZ01OM0"."CH_GU"
				INTO :sCusGbn,					:sGbn1,						:sSangFlag,
					  :sChaDae,					:sRemark1,					:sChGbn
				FROM "KFZ01OM0"  
				WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Dae) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Dae);
			IF IsNull(sCusGbn) THEN sCusGbn = 'N'
		
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
			
			IF sReMark1 = 'Y' AND sDcGbn = sChaDae THEN			/*현금-작성부서의 소속원가부문*/
				dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_dae.GetItemString(i,"sdeptcode"))
			END IF
			
			IF sCusGbn = 'Y' THEN
				IF sGbn1 = '6' THEN				/*차입금*/				
					IF sDcGbn = sChaDae AND sChGbn = 'Y' THEN				/*차입금 관리 계정이면*/
						if dChIjaAmt <> 0 then
							sSaupNo = sChaipNo
							sSaupName = '구매결제 차입'	
						else
							SetNull(sSaupNo);		SetNull(sSaupName);
						end if
						
						dAmount = dChaIpWon
						dw_junpoy.SetItem(iCurRow,"amt",  dAmount)
					
						IF Wf_Insert_Kfz12ote(i,'Y',sSaupj,sBalDate,lJunNo,lLinNo,dAmount,sSaupNo,sSaupName) = -1 THEN Return -1	
						dw_junpoy.SetItem(iCurRow,"chaip_gu",'Y')
						
						dw_junpoy.SetItem(iCurRow,"descr",   '무역금융')
					ELSE
						sSaupNo   = dw_dae.GetItemString(i,"cust")
						sSaupName = dw_dae.GetItemString(i,"custname")	
						
						dw_junpoy.SetItem(iCurRow,"amt",     dChaIpWon)
						dw_junpoy.SetItem(iCurRow,"descr",   '무역금융')
					END IF
				ELSE
					sSaupNo   = dw_dae.GetItemString(i,"cust")
					sSaupName = dw_dae.GetItemString(i,"custname")
					
					dAmount = dw_dae.GetItemNumber(i,"wonamt") + dw_dae.GetItemNumber(i,"vatamt")
					dw_junpoy.SetItem(iCurRow,"amt",  dAmount)
					
					dw_junpoy.SetItem(iCurRow,"descr",   '수입비용 정산')
			
				END IF
				
				dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
				dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupName)
				
				IF sDcGbn <> sChaDae and sSangFlag = 'Y' THEN				/*반제처리 회계에서*/
					IF Wf_Insert_Sang_Cha(sAcc1_Dae,sAcc2_Dae,sSaupNo,dAmount,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,False) = 1 THEN	
						dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
					ELSE
						Return -1
					END IF
							
//					IF Wf_Insert_Sang(k,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,dAmount) = 1 THEN	/*반제물류에서*/
//						dw_junpoy.SetItem(iCurRow,"cross_gu",'Y')
//					ELSE
//						Return -1
//					END IF				
				END IF
			ELSE
				SetNull(sSaupNo)
				dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
				dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupNo)
				
				dAmount = dw_dae.GetItemNumber(i,"wonamt") + dw_dae.GetItemNumber(i,"vatamt")
				dw_junpoy.SetItem(iCurRow,"amt",  dAmount)
					
				dw_junpoy.SetItem(iCurRow,"descr",   '수입비용 정산')
			END IF
			sMulGbn   = dw_dae.GetItemString(i,"mulgu")																	/*물품대 여부*/
		
			dw_junpoy.SetItem(iCurRow,"kwan_no", dw_dae.GetItemString(i,"polcno"))		
			dw_junpoy.SetItem(iCurRow,"y_curr",  dw_dae.GetItemString(i,"forcur"))		
			dw_junpoy.SetItem(iCurRow,"y_amt",   dw_dae.GetItemNumber(i,"format"))
			dw_junpoy.SetItem(iCurRow,"y_rate",  dw_dae.GetItemNumber(i,"forrat"))
						
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 	
			lLinNo = lLinNo + 1
			
			/*구매결제차입에서 차액 및 비용발생 금액의 상대계정 처리-예금인출시 : 2004.01.31*/
			dDpAmt = dw_dae.GetItemNumber(i,"dpamt")
			if IsNull(dDpAmt) then dDpAmt = 0
			if dDpAmt <> 0 then
				String sDpAcc1, sDpAcc2,sDepotNo
				
				sDptNo = dw_dae.GetItemString(i,"dp_no")	
				
				SELECT "KFM04OT0"."ACC1_CD", "KFM04OT0"."ACC2_CD","KFM04OT0"."AB_NO"		
					INTO :sDpAcc1,   		  	  :sDpAcc2,			  :sDepotNo
					FROM "KFM04OT0"  
					WHERE "KFM04OT0"."AB_DPNO" = :sDptNo   ;
				
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sDpAcc1)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sDpAcc2)
				dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dDpAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '인출(무역금융 이자 외)')
				
				dw_junpoy.SetItem(iCurRow,"saup_no", sDptNo)
				dw_junpoy.SetItem(iCurRow,"in_nm",   f_get_personlst('5',sDptNo,'%'))
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			end if
			
			/*구매결제차입에서 차액 및 비용발생 금액의 상대계정 처리-현금 지급 시 : 2004.01.31*/
			dCashAmt = dw_dae.GetItemNumber(i,"cashamt")
			if IsNull(dCashAmt) then dCashAmt = 0
			if dCashAmt <> 0 then
				String sCashAcc1, sCashAcc2
				
				select substr(dataname,1,5),		substr(dataname,6,2)
					into :sCashAcc1,					:sCashAcc2
					from syscnfg
					where sysgu = 'A' and serial = 1 and lineno = '1' ;
					
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sCashAcc1)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sCashAcc2)
				dw_junpoy.SetItem(iCurRow,"sawon",   sSawon)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
				dw_junpoy.SetItem(iCurRow,"amt",     dCashAmt)	
				dw_junpoy.SetItem(iCurRow,"descr",   '현금 인출')
				
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			end if
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[반제]')
				Return -1
			END IF
			IF dw_kfz12ote.Update() <> 1 THEN
				F_MessageChk(13,'[차입금]')
				Return -1
			END IF
			IF dw_vat.Update() <> 1 THEN
				F_MessageChk(13,'[부가세]')
				Return -1
			END IF
			IF dw_rtv.Update() <> 1 THEN
				F_MessageChk(13,'[수입비용자료]')
				SetPointer(Arrow!)	
				RETURN -1
			END IF

			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
				END IF
			END IF
		END IF
		
		dw_list.SetItem(k,"saupj",   			sSaupj)
		dw_list.SetItem(k,"bal_date",			sBalDate)
		dw_list.SetItem(k,"bjun_no", 			lJunNo)			
	END IF
NEXT
COMMIT;

//MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))
//
w_mdi_frame.sle_msg.text ="수입비용 전표 처리 완료!!"

Return 1
end function

on w_kifa50.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_vat=create dw_vat
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_sang=create dw_sang
this.dw_kfz12ote=create dw_kfz12ote
this.dw_dae=create dw_dae
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.cbx_all=create cbx_all
this.gb_detail=create gb_detail
this.dw_list=create dw_list
this.gb_list=create gb_list
this.dw_delete=create dw_delete
this.dw_sang_detail=create dw_sang_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_sungin
this.Control[iCurrent+6]=this.dw_vat
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_ip
this.Control[iCurrent+9]=this.dw_sang
this.Control[iCurrent+10]=this.dw_kfz12ote
this.Control[iCurrent+11]=this.dw_dae
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.dw_rtv
this.Control[iCurrent+14]=this.cbx_all
this.Control[iCurrent+15]=this.gb_detail
this.Control[iCurrent+16]=this.dw_list
this.Control[iCurrent+17]=this.gb_list
this.Control[iCurrent+18]=this.dw_delete
this.Control[iCurrent+19]=this.dw_sang_detail
end on

on w_kifa50.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_vat)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_sang)
destroy(this.dw_kfz12ote)
destroy(this.dw_dae)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.cbx_all)
destroy(this.gb_detail)
destroy(this.dw_list)
destroy(this.gb_list)
destroy(this.dw_delete)
destroy(this.dw_sang_detail)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())
dw_ip.SetItem(dw_ip.Getrow(),"accdate",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_list.SetTransObject(Sqlca)
dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)
dw_kfz12ote.SetTransObject(SQLCA)
dw_sang_detail.SetTransObject(SQLCA)

dw_dae.SetTransObject(Sqlca)
dw_vat.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '10' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa50
boolean visible = false
integer x = 1061
integer y = 2768
integer height = 152
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa50
boolean visible = false
integer x = 3451
integer y = 2392
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa50
boolean visible = false
integer x = 3278
integer y = 2392
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa50
boolean visible = false
integer x = 3625
integer y = 2392
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kifa50
boolean visible = false
integer x = 3104
integer y = 2392
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa50
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kifa50
boolean visible = false
integer x = 3973
integer y = 2392
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa50
boolean visible = false
integer x = 2757
integer y = 2392
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

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

FOR i = 1 TO dw_list.RowCount()
	IF dw_list.GetItemString(i,"chk") = '1' THEN
		sSaupj   = dw_list.GetItemString(i,"saupj")
		sBalDate = dw_list.GetItemString(i,"bal_date") 
		sUpmuGu  = sUpmuGbn
		lBJunNo  = dw_list.GetItemNumber(i,"bjun_no") 
		
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
	
	END IF
NEXT

end event

type p_inq from w_inherite`p_inq within w_kifa50
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaleDtf,sSaleDtT,sSaupNo

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaleDtf = dw_ip.GetItemString(dw_ip.GetRow(),"saledtf")
sSaleDtt = dw_ip.GetItemString(dw_ip.GetRow(),"saledtt")
sSaupNo  = dw_ip.GetItemString(dw_ip.GetRow(),"saup_no")

IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[비용일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[비용일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaupNo = "" OR IsNull(sSaupNo) THEN
	sSaupNo = '%'
END IF

dw_list.SetRedraw(False)
dw_delete.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_list.Retrieve(sSaledtf,sSaledtt,sSaupNo) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaledtf,sSaledtt,sSaupNo) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_list.SetRedraw(True)
dw_delete.SetRedraw(True)

dw_rtv.Reset()

p_mod.Enabled =True
//cb_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa50
boolean visible = false
integer x = 3799
integer y = 2392
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa50
integer x = 4270
integer taborder = 60
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;Integer iYesCnt,k
String  sAccDate,sDeptCode

IF rb_1.Checked =True THEN
	IF dw_list.RowCount() <=0 THEN Return
	
	iYesCnt = dw_list.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF

	dw_ip.AcceptText()
	sAccDate  = dw_ip.GetItemString(1,"accdate")
	sDeptCode = dw_ip.GetItemString(1,"deptcd")
	
	IF sAccDate = "" OR IsNull(sAccDate) THEN
		F_MessageChk(1,'[회계일자]')	
		dw_ip.SetColumn("accdate")
		dw_ip.SetFocus()
		Return 
	else
		IF F_Check_LimitDate(sAccDate,'A') = -1 THEN
			F_MessageChk(28,'[회계일자]')
			dw_ip.SetColumn("accdate")
			dw_ip.SetFocus()
			Return
		END IF
	END IF
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		F_MessageChk(1,'[작성부서]')	
		dw_ip.SetColumn("deptcd")
		dw_ip.SetFocus()
		Return 
	END IF

	FOR k = 1 TO dw_list.RowCount()
		if dw_list.GetItemString(k,"chk") = '1' then
			
			IF Wf_RequiredChk() = -1 THEN Return	
		end if
	Next
	
	IF Wf_Insert_Kfz12ot0(sAccDate,sDeptCode) = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	iYesCnt = dw_delete.GetItemNumber(1,"yescnt")
	IF iYesCnt <=0 THEN 
		F_MessageChk(11,'')
		Return
	END IF
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa50
integer x = 3246
integer y = 2784
end type

type cb_mod from w_inherite`cb_mod within w_kifa50
integer x = 2889
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa50
integer x = 2112
integer y = 2716
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa50
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kifa50
integer x = 2528
end type

type cb_print from w_inherite`cb_print within w_kifa50
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kifa50
end type

type cb_can from w_inherite`cb_can within w_kifa50
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kifa50
integer x = 3141
integer y = 2580
integer width = 498
string text = "품목보기(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa50
integer x = 2048
integer y = 2524
integer width = 1102
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa50
integer x = 2478
integer y = 2728
integer width = 1143
end type

type gb_1 from groupbox within w_kifa50
integer x = 3163
integer width = 507
integer height = 276
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_kifa50
integer x = 3205
integer y = 64
integer width = 434
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행처리"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_list.Title ="수입비용 자동전표 발행"
	
	gb_list.Visible   = True
	gb_detail.Visible  = True
	
	dw_rtv.Visible    = True
	dw_list.Visible    = True
	
	dw_delete.Visible = False
END IF
dw_rtv.Reset()
dw_list.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa50
integer x = 3205
integer y = 160
integer width = 434
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제처리"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="수입비용 자동전표 삭제"
	
	dw_rtv.Visible    = False
	dw_list.Visible   = False
	gb_list.Visible   = False
	gb_detail.Visible  = False
	
	dw_delete.Visible = True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa50
boolean visible = false
integer x = 9
integer y = 2404
integer width = 1038
integer height = 124
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

type dw_sungin from datawindow within w_kifa50
boolean visible = false
integer x = 18
integer y = 2544
integer width = 1029
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
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

type dw_vat from datawindow within w_kifa50
boolean visible = false
integer x = 18
integer y = 2652
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
boolean resizable = true
boolean livescroll = true
end type

type dw_print from datawindow within w_kifa50
boolean visible = false
integer x = 18
integer y = 2756
integer width = 1029
integer height = 108
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

type dw_ip from u_key_enter within w_kifa50
event ue_key pbm_dwnkey
integer x = 37
integer y = 8
integer width = 2981
integer height = 280
integer taborder = 10
string dataobject = "d_kifa440"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sDeptCode,sChoose,sSaupNo,sSaupName
Integer i

SetNull(snull)

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"계산서발행일자")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"계산서발행일자")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="accdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"회계일자")
		dw_ip.SetItem(1,"accdate",snull)
		Return 1
	END IF
	IF F_Check_LimitDate(sDate,'B') = -1 THEN
		F_MessageChk(29,'[회계일자]')
		this.SetItem(1,"accdate",snull)
		this.SetColumn("accdate")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saup_no" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN 
		this.SetItem(this.GetRow(),"saupname",snull)
		Return
	END IF
	
	sSaupName = F_Get_PersonLst('1',sSaupNo,'1')
	IF IsNull(sSaupName) THEN
//		F_MessageChk(20,'[거래처]')
		this.SetItem(this.GetRow(),"saup_no",snull)
		this.SetItem(this.GetRow(),"saupname",snull)
		Return 
	ELSE
		this.SetItem(this.GetRow(),"saupname",sSaupName)
	END IF
	
END IF

IF this.GetColumnName() ="deptcd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	IF IsNull(F_Get_PersonLst('3',sDeptCode,'1')) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(this.GetRow(),"deptcd",snull)
		Return 1
	END IF
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  
   	INTO :sSdeptCode  
    	FROM "VW_CDEPT_CODE"  
   	WHERE "VW_CDEPT_CODE"."DEPT_CD" = :sDeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN SetNull(sSdeptCode)
	
END IF

IF this.GetColumnName() ="chose" THEN
	sChoose = this.GetText()
	
	IF rb_1.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_list.Rowcount()
				dw_list.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_list.Rowcount()
				dw_list.SetItem(i,"chk",'0')
			NEXT
		END IF
	ELSEIF rb_2.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'0')
			NEXT
		END IF
	END IF
END IF




end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="saup_no" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "saup_no")
	
	if lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"saup_no",   lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"saupname",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_sang from datawindow within w_kifa50
boolean visible = false
integer x = 1042
integer y = 2444
integer width = 992
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리대상 내역"
string dataobject = "d_kifa108"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_kfz12ote from datawindow within w_kifa50
boolean visible = false
integer x = 1042
integer y = 2552
integer width = 992
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "차입금 저장"
string dataobject = "d_kglc207"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_dae from datawindow within w_kifa50
boolean visible = false
integer x = 1042
integer y = 2656
integer width = 992
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "대변항목"
string dataobject = "d_kifa503"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa50
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 288
integer width = 4571
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kifa50
integer x = 1330
integer y = 344
integer width = 3237
integer height = 1848
integer taborder = 40
string dataobject = "d_kifa501"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//IF Row <=0 THEN Return
//
//SelectRow(0,False)
//SelectRow(Row,True)	

	
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sChk,sSdept,snull
Double sAmt

SetNull(snull)

IF this.GetColumnName() = "sdept_cd" THEN
	sSdept = this.GetText()	
	IF sSdept = "" OR IsNull(sSdept) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdept
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdept   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(this.GetRow(),"sdept_cd",snull)
		Return 1
	END IF
END IF
end event

type cbx_all from checkbox within w_kifa50
integer x = 3675
integer y = 212
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_list.Rowcount()
			dw_list.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_list.Rowcount()
			dw_list.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

type gb_detail from groupbox within w_kifa50
integer x = 1317
integer y = 300
integer width = 3278
integer height = 1912
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "상세조회"
end type

type dw_list from datawindow within w_kifa50
integer x = 78
integer y = 344
integer width = 1207
integer height = 1844
integer taborder = 30
string dataobject = "d_kifa502"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)

dw_rtv.Retrieve('1',this.GetItemString(row,"expno"))
end event

type gb_list from groupbox within w_kifa50
integer x = 64
integer y = 300
integer width = 1239
integer height = 1912
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "내역"
end type

type dw_delete from datawindow within w_kifa50
boolean visible = false
integer x = 64
integer y = 296
integer width = 4530
integer height = 1920
integer taborder = 50
string dataobject = "d_kifa504"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_sang_detail from datawindow within w_kifa50
integer x = 1042
integer y = 2768
integer width = 992
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "외상매입금상세"
string dataobject = "d_kifa505"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

