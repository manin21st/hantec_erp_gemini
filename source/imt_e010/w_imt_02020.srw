$PBExportHeader$w_imt_02020.srw
$PBExportComments$** 발주검토(담당자별)
forward
global type w_imt_02020 from w_inherite
end type
type rr_descr from roundrectangle within w_imt_02020
end type
type dw_1 from datawindow within w_imt_02020
end type
type dw_detail from datawindow within w_imt_02020
end type
type dw_hidden from datawindow within w_imt_02020
end type
type st_3 from statictext within w_imt_02020
end type
type sle_bal from singlelineedit within w_imt_02020
end type
type st_2 from statictext within w_imt_02020
end type
type pb_1 from u_pb_cal within w_imt_02020
end type
type pb_2 from u_pb_cal within w_imt_02020
end type
type pb_3 from u_pb_cal within w_imt_02020
end type
type p_2 from picture within w_imt_02020
end type
type rr_1 from roundrectangle within w_imt_02020
end type
type ln_balju from line within w_imt_02020
end type
end forward

global type w_imt_02020 from w_inherite
integer height = 3772
string title = "발주검토(담당자별)"
rr_descr rr_descr
dw_1 dw_1
dw_detail dw_detail
dw_hidden dw_hidden
st_3 st_3
sle_bal sle_bal
st_2 st_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
p_2 p_2
rr_1 rr_1
ln_balju ln_balju
end type
global w_imt_02020 w_imt_02020

type variables
string   ls_auto    //자동채번여부
string   is_pspec,  is_jijil
string   isCnvgu    //발주 단위 사용여부
String   is_cvcod		// 자사거래처 코드

String   is_gwgbn   // 그룹웨어 연동여부
Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00022'	// 그룹웨어 문서번호

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_create_gwdoc ()
end prototypes

public function integer wf_required_chk (integer i);string s_blynd, sToday

if dw_insert.AcceptText() = -1 then return -1

stoday  = f_today()
s_blynd = dw_insert.GetItemString(i,'blynd')  //발주상태

if s_blynd <> '2' then return 1 //발주상태가 검토가 아니면 필수입력체크 하지 않음

if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
	dw_insert.GetItemNumber(i,'vnqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 발주예정량]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('vnqty')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemNumber(i,'unprc')) or &
//	dw_insert.GetItemNumber(i,'unprc') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' 행 발주단가]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('unprc')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 발주처]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemString(i,'ipdpt')) or &
//	dw_insert.GetItemString(i,'ipdpt') = "" then
//	f_message_chk(1400,'[ '+string(i)+' 행 창고]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('ipdpt')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if isnull(dw_insert.GetItemString(i,'plncrt')) or &
	dw_insert.GetItemString(i,'plncrt') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 작성구분]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('plncrt')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'suipgu')) or &
	dw_insert.GetItemString(i,'suipgu') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 수입구분]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('suipgu')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'sakgu')) or &
	dw_insert.GetItemString(i,'sakgu') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 사후관리여부]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('sakgu')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'choyo')) or &
	dw_insert.GetItemString(i,'choyo') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 첨부유무]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('choyo')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'yodat')) or &
	dw_insert.GetItemString(i,'yodat') = '' or &
	f_datechk(dw_insert.GetItemString(i,'yodat')) = -1 then
	Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('yodat')
	dw_insert.SetFocus()
	return -1		
end if	

//발주 지시인 경우만 납기요구일 체크
//IF dw_insert.GetItemString(i,'baljugu') = 'Y' THEN 
//	if	dw_insert.GetItemString(i,'yodat') < sToday  then
//		MessageBox("확인", "납기요구일은 현재일자보다 작을 수 없습니다.", stopsign!)	
//		dw_insert.ScrollToRow(i)
//		dw_insert.SetColumn('yodat')
//		dw_insert.SetFocus()
//		return -1		
//	end if	
//END IF
//
return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_detail.setredraw(false)
dw_insert.setredraw(false)
dw_1.setredraw(false)

if isCnvgu = 'Y' then // 발주단위 사용시
	dw_insert.dataobject = 'd_imt_02020_1_1'
Else						// 발주단위 사용안함
	dw_insert.dataobject = 'd_imt_02020_1'
End if	
dw_insert.settransobject(sqlca)

dw_insert.reset()
dw_detail.reset()
dw_1.reset()

dw_1.insertrow(0)

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;
dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅

IF f_change_name('1') = 'Y' then 
	dw_insert.object.ispec_t.text = is_pspec
	dw_insert.object.jijil_t.text = is_jijil
END IF

dw_1.setredraw(true)
dw_insert.setredraw(true)
dw_detail.setredraw(true)

p_search.enabled = true


end subroutine

public function integer wf_create_gwdoc ();String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html, irow
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus, sCurr, sDisCurr, sYodat
long   ll_FLength, dgwSeq, lRow
Dec    dTotAmt, dUnprc, dVnQty, dAmt

// HTML 문서를 읽어들인다
ll_FLength = FileLength("EAFolder_00022.html")
li_FileNum = FileOpen("EAFolder_00022.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 존재하지 않습니다.!!')
	Return -1
End If

// 그룹웨어 문서 번호 
SetNull(sGwNo)

sDate = f_today()
// 그룹웨어 연동시 문서번호 채번...필요한 경우 함
If IsNull(sGwNo) Then
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[전자결재]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// 반복행을 찾는다
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail에 대해서 반복해서 값을 setting한다
	ix = 1
	irow = 1
	dTotAmt = 0
	do 
		if dw_insert.GetItemString(ix, 'chk') = 'Y' Then
			
			// 원화금액으로 환산하여 총금액을 산출
			dVnQty = dw_insert.GetItemNumber(ix,'vnqty')
			dUnPrc = dw_insert.GetItemNumber(ix,'unprc')
			sCurr  = dw_insert.GetItemString(ix, 'tuncu')
			sDisCurr = dw_insert.Describe("evaluate('lookupdisplay(tuncu)'," + string(ix) + ")")
			
			SELECT erp000000090(:sDate, :sCurr, :dUnPrc * :dVnQty, '2','3', 'Y') INTO :dAmt FROM DUAL;
			If IsnUll(dAmt) Then dAmt = 0
			dTotAmt = dTotAmt + dAmt
			
			nPos = Pos(sRepeat, '(_ROW_)')  
			If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, string(irow))	
			
			nPos = Pos(sDetRow, '(_IDTSC_)')
			sValue = dw_insert.GetItemString(ix,'itemas_itdsc')
			If IsnUll(sValue) Then sValue = ''
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
			
			nPos = Pos(sDetRow, '(_ISPEC_)')
			sValue = dw_insert.GetItemString(ix,'itemas_ispec')
			If IsnUll(sValue) Then sValue = ''
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue )
			
			nPos = Pos(sDetRow, '(_UNMSR_)')
			sValue = dw_insert.GetItemString(ix,'itemas_pumsr')
			If IsnUll(sValue) Then sValue = ''
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
			
			nPos = Pos(sDetRow, '(_QTY_)')
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, String(dw_insert.GetItemNumber(ix,'vnqty'),'#,##0.00'))
			
			nPos = Pos(sDetRow, '(_PRC_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sDisCurr + String(dw_insert.GetItemNumber(ix,'unprc'),'#,##0.00'))
			
			nPos = Pos(sDetRow, '(_AMT_)')  
			sValue  = String( dw_insert.GetItemNumber(ix,'vnqty') * dw_insert.GetItemNumber(ix,'unprc') , '#,##0.00')
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sValue)
			
			nPos = Pos(sDetRow, '(_CVNAS_)')
			sValue = dw_insert.GetItemString(ix,'vndmst_cvnas2')
			If IsnUll(sValue) Then sValue = ''
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
			
			nPos = Pos(sDetRow, '(_BIGO_)')
			sValue = dw_insert.GetItemString(ix,'gurmks')
			If IsnUll(sValue) Then sValue = ''
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, sValue)
			
			// 납기요구일
			sYodat = Trim(dw_insert.GetItemString(ix,'yodat'))
			
			sDetail = sDetail + sDetRow
			irow += 1
		End If
		
		ix = ix + 1
	loop while (ix <= dw_insert.RowCount() )

	/* Footer */
	nPos = Pos(sFooter, '(_TOTAMT_)')  
	sValue  = String( dTotAmt , '#,##0.00')
	If nPos > 0 Then sFooter = Replace(sFooter, nPos, 10, sValue)
	
	nPos = Pos(sFooter, '(_RMK_)')
	sValue = Trim(dw_1.GetItemString(1,'remark'))
	If IsnUll(sValue) Then sValue = ''
	If nPos > 0 Then sFooter = Replace(sFooter, nPos, 7, sValue)

	sCall = sHeader + sDetail + sFooter
End If

// Detail외 매크로 내역을 치환한다
nPos = Pos(sCall, '(_SDATE_)')
sValue = String(sDate,'@@@@.@@.@@')
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)
		
nPos = Pos(sCall, '(_ESTNO_)')
sValue = sEstNo
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_YODAT_)')
sValue = sYodat
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

///////////////////////////////////////////////

If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 생성되지 않았습니다.!!')
	Return -1
End If

//EAERPHTML에 등록되었는지 확인
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// 기존 미상신 내역이 있으면 삭제
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// 그룹웨어 EAERPHTML TABLE에 기안내용을 INSERT한다
	INSERT INTO EAERPHTML
			  ( CSCODE, KEY1,  ERPEMPCODE, GWDOCGUBUN, SENDINGGUBUN, HTMLCONTENT, STATUS)
	 VALUES ( 'BDS',  :sGWno, Lower(:gs_userid),:isHtmlNo,    '1',   :sCall, '0') using sqlca1;
	If sqlca1.sqlcode <> 0 Then
		MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
		RollBack USING SQLCA1;
		Return -1
	End If
	
	COMMIT USING SQLCA1;
Else
	MessageBox('확인','기상신된 내역입니다.!!')
	Return 0
End If
 
// 기안서 상신
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//그룹웨어 문서번호
SetNull(gs_codename)		 			//제목입력받음(erptitle)
Open(w_groupware_browser)

//EAERPHTML에 상신되었는지 확인
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00022_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('결재상신','결재가 상신되었습니다.')
Else
	MessageBox('결재상신','결재가 상신되지 않았습니다.')
	Return -1
End If

// 그룹웨어 문서번호를 구매의뢰 테이블에 저장한다
For ix = 1 To dw_insert.RowCount()
	if dw_insert.GetItemString(ix, 'chk') = 'Y' Then
		dw_insert.SetItem(ix, 'yebi2', '0')
		dw_insert.SetItem(ix, 'gwno', sGwno)
	End If
Next

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end function

on w_imt_02020.create
int iCurrent
call super::create
this.rr_descr=create rr_descr
this.dw_1=create dw_1
this.dw_detail=create dw_detail
this.dw_hidden=create dw_hidden
this.st_3=create st_3
this.sle_bal=create sle_bal
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.p_2=create p_2
this.rr_1=create rr_1
this.ln_balju=create ln_balju
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_descr
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_hidden
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_bal
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.p_2
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.ln_balju
end on

on w_imt_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_descr)
destroy(this.dw_1)
destroy(this.dw_detail)
destroy(this.dw_hidden)
destroy(this.st_3)
destroy(this.sle_bal)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.p_2)
destroy(this.rr_1)
destroy(this.ln_balju)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;		 
		 
dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅
dw_1.setitem(1, 'baldate', is_today) //발주일자 기본 셋팅

// 전자결재 여동유무(발주검토)
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_gwgbn
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'W' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '3' )   ;
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server 접속
	SQLCA1 = Create Transaction
	
	select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
	select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
	select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
	select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
	select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
	select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';
	
	ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 
	
	SetNull(ls_reg_cnn)
	RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 
	
	If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
		( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
		RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
						ls_host, RegString!, ls_conn_str)
	End If
	
	SQLCA1.DBMS = ls_dbms
	SQLCA1.Database = ls_database
	SQLCA1.LogPass = ls_pwd
	SQLCA1.ServerName = ls_host
	SQLCA1.LogId =ls_id
	SQLCA1.AutoCommit = False
	SQLCA1.DBParm = ""
	
	CONNECT USING SQLCA1;
	If sqlca1.sqlcode <> 0 Then
		messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
		MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
		is_gwgbn = 'N'
	End If
End If

// 구매의뢰된 내역중 '의뢰'상태/결재상태가 완료가 아닌 내역을 조회하여 전자결재 상태를 update한다
DataStore ds
Long  ix
String sEstno, sGwNo, sGwStatus

ds = create datastore
ds.dataobject = 'd_imt_02020_ds'
ds.SetTransObject(sqlca)
ds.Retrieve()
For ix = 1 To ds.RowCount()
	sEstno = ds.GetItemString(ix, 'estno')
	sGwNo  = ds.GetItemString(ix, 'shpjpno')
	
	If is_gwgbn = 'Y' Then
		select approvalstatus into :sGwStatus
		  from eafolder_00021_erp a, approvaldocinfo b
		 where a.macro_field_1 = :sgwno
			and a.reporterid 	 = b.reporterid
			and a.reportnum	 = b.reportnum	using sqlca1 ;
	End If

	// 보류나 반려인 경우 '취소'로 변경한다
	If sGwStatus = '2' Or sGwStatus = '5' Then
		UPDATE ESTIMA SET BLYND = '4', GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sEstno||'%';
	Else
		UPDATE ESTIMA SET GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sEstno||'%';
	End If
		
Next
COMMIT;

///////////////////////////////////////////////////////////////////////////////////

// 발주단위 사용에 따른 화면 변경

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :isCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
 
If isNull(isCnvgu) or Trim(isCnvgu) = '' then
	isCnvgu = 'N'
End if

if isCnvgu = 'Y' then // 발주단위 사용시
	dw_insert.dataobject = 'd_imt_02020_1_1'
Else						// 발주단위 사용안함
	dw_insert.dataobject = 'd_imt_02020_1'
End if	

/* 발주번호 자동채번여부를 환경설정에서 검색함 */
select dataname
  into :ls_auto
  from syscnfg
 where sysgu = 'S' and serial = 6 and lineno = '60';
 
If isNull(ls_auto) or Trim(ls_auto) = '' then
	ls_auto = 'Y'
End if

if ls_auto = 'Y' then 
	sle_bal.Visible = false
	st_2.Visible = false
	ln_balju.Visible = False
end if

// 자사 거래처마스터 코드
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_cvcod
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
		 ( "SYSCNFG"."SERIAL" = 4 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' ) AND
		 ( "SYSCNFG"."RFCOD" = :gs_saupj );
end event

event open;call super::open;PostEvent("ue_open")
end event

event closequery;call super::closequery;// 그룹웨어 접속정보 해제
If is_gwgbn = 'Y' Then
	disconnect	using	sqlca1 ;
	destroy	sqlca1
End If
end event

type dw_insert from w_inherite`dw_insert within w_imt_02020
integer x = 82
integer y = 620
integer width = 4512
integer height = 1524
integer taborder = 30
string dataobject = "d_imt_02020_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String snull, scvcod, get_nm, get_nm2, sblynd, old_sblynd, spordno, get_pdsts, sPspec, sItnbr
long   ll_row
int    ireturn 
Decimal {5} dData
Decimal {5} dunprc

SetNull(snull)

ll_row = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	scvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(ll_row, "cvcod", scvcod)	
	this.setitem(ll_row, "vndmst_cvnas2", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "blynd" THEN
   old_sblynd = this.getitemstring(ll_row, 'old_blynd')
	sblynd = this.GetText()
   
	IF sblynd = '3' then //발주//결재는 선택할 수 없음
      f_message_chk(71, '[발주상태]')
		this.SetItem(ll_row, "blynd", old_sblynd)
      return 1  		
	ELSEIF old_sblynd = '4' then
		sPordno = this.getitemstring(row, 'pordno')
		If not ( sPordno = '' or isnull(sPordno) ) then 
		   SELECT PDSTS  
			  INTO :get_pdsts  
			  FROM MOMAST  
			 WHERE SABU = :gs_sabu AND PORDNO = :sPordno  ;
			 
         if sqlca.sqlcode = 0 then
				if get_pdsts = '6' then 
					MessageBox("확 인","작업지시가 취소 상태입니다. 자료를 확인하세요" + "~n~n" +&
											 "발주상태를 변경시킬 수 없습니다.", StopSign! )
					this.SetItem(ll_row, "blynd", old_sblynd)
					Return 1
				end if
			else	
				MessageBox("확 인","작업지시번호를 확인하세요" + "~n~n" +&
										 "발주상태를 변경시킬 수 없습니다.", StopSign! )
				this.SetItem(ll_row, "blynd", old_sblynd)
				Return 1
			end if	
		End if	
	END IF
// 납기요구일
ELSEIF this.GetColumnName() = 'yodat' THEN
	String sDate
	sDate  = trim(this.gettext())

	IF f_datechk(sDate) = -1	then
		this.setitem(ll_Row, "yodat", f_today())
		return 1
	END IF

	IF f_today() > sDate	THEN
		MessageBox("확인", "납기요구일은 현재일자보다 작을 수 없습니다.")
		this.setitem(ll_Row, "yodat", f_today())
		return 1
	END IF
	
ELSEIF this.GetColumnName() = "ipdpt" THEN
	scvcod = this.GetText()
	
	ireturn = f_get_name2('창고', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(ll_row, "ipdpt", scvcod)	
	this.setitem(ll_row, "ipdpt_name", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "baljugu" THEN
	scvcod = this.GetText()
   IF scvcod = 'Y' then 	
      IF this.getitemstring(ll_row, 'blynd') = '4' THEN 
			MessageBox("확 인","상태가 취소인 자료는 발주지시를 내릴 수 없습니다.", StopSign! )
			this.SetItem(ll_row, "baljugu", 'N')
			Return 1
		END IF	
	END IF	
END IF

IF this.GetColumnName() = "vnqty" THEN

	dData = Dec(this.GetText())
	if getitemdecimal(Ll_row, "cnvfat") = 1  then
		setitem(Ll_row, "cnvqty", dData)
	elseif getitemstring(Ll_row, "cnvart") = '/' then
		if dData = 0 then
			setitem(Ll_row, "cnvqty", 0)
		Else
			setitem(Ll_row, "cnvqty", round(dData / getitemdecimal(Ll_row, "cnvfat"), 3))		
		End if
	else
		setitem(Ll_row, "cnvqty", round(dData * getitemdecimal(Ll_row, "cnvfat"), 3))
	end if

	RETURN ireturn
ELSEIF this.getcolumnname() = 'unprc' then
   dData = dec(this.GetText())
	
	if isnull(dData) then dData = 0
   
	// 업체발주예정단가 변경
	if getitemdecimal(ll_row, "cnvfat") = 1   then
		setitem(LL_row, "cnvprc", dData)
	elseif getitemstring(LL_row, "cnvart") = '*'  then
		IF ddata = 0 then
			setitem(LL_row, "cnvprc", 0)			
		else
			setitem(LL_row, "cnvprc", ROUND(dData / getitemdecimal(LL_row, "cnvfat"),5))
		end if
	else
		setitem(LL_row, "cnvprc", ROUND(dData * getitemdecimal(LL_row, "cnvfat"),5))
	end if
//ELSEIF this.getcolumnname() = 'shpjpno' then    /* Maker 변경*/
//	sPspec 	= GetText()
//	sItnbr  	= GetItemString(LL_row,'itnbr')
//	scvcod 	= GetItemString(LL_row,'cvcod')
//	sDate		= GetItemString(LL_row,'rdate')
//	
//	If IsNull(sPspec) Or Trim(sPspec) = '' Then sPspec = '.'
//	
//	If 	Not IsNull(sItnbr) Then	
//		/* 사양별 매입단가*/
//		SELECT Fun_danmst_danga10(:sDate, :scvcod, :sitnbr, :sPspec) INTO :dunprc FROM DUAL;
//		
//		setitem(LL_row, "unprc", dunprc)
//		// 업체발주예정단가 변경
//		if 	getitemdecimal(LL_row, "cnvfat") =  1  then
//			setitem(LL_row, "cnvprc", dunprc)
//		elseif 	getitemstring(LL_row, "cnvart") = '*'  then
//			IF 	ddata = 0 then
//				setitem(LL_row, "cnvprc", 0)			
//			else
//				setitem(LL_row, "cnvprc", ROUND(dunprc / getitemdecimal(LL_row, "cnvfat"),5))
//			end if
//		else
//			setitem(LL_row, "cnvprc", ROUND(dunprc * getitemdecimal(LL_row, "cnvfat"),5))
//		end if	
//	End If
// 상신 클릭시 
ELSEIF this.getcolumnname() = 'chk' then
	If Trim(GetText()) = 'Y' Then
		If GetItemString(ll_row, 'cvcod') = is_cvcod Then
			f_message_chk(203,'[발주처]')
			Return 2
		End If
		If GetItemNumber(ll_row, 'unprc') <= 0 Or IsNull(GetItemNumber(ll_row, 'unprc')) Then
			f_message_chk(80,'[발주단가]')
			Return 2
		End If
	End If
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;string snull
long   ll_row

SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(snull)

ll_row = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(ll_row, "cvcod", snull)
		this.SetItem(ll_row, "vndmst_cvnas2", snull)
      return 1  		
   END IF
	this.SetItem(ll_row, "cvcod", gs_Code)
	this.SetItem(ll_row, "vndmst_cvnas2", gs_Codename)
ELSEIF this.GetColumnName() = "ipdpt" THEN
	Open(w_vndmst_46_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then return 
	this.SetItem(ll_row, "ipdpt", gs_Code)
	this.SetItem(ll_row, "ipdpt_name", gs_Codename)
ELSEIF this.GetColumnName() = "seqno" THEN
   this.accepttext()
	gs_code = this.getitemstring(ll_row, 'itnbr')
	gs_codename = this.getitemstring(ll_row, 'cvcod')
	
	Open(w_itmbuy_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then		return
	this.SetItem(ll_row, "seqno", integer(gs_Code))
END IF

end event

event dw_insert::ue_pressenter;IF this.GetColumnName() = "gurmks" THEN return

Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::clicked;string s_estno 

If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If

If Row <= 0 then return 

s_estno = this.GetItemString(row,"estno") 
s_estno = left(s_estno, 12)

if dw_detail.retrieve(gs_sabu, s_estno) < 1 then
	return
end if


end event

event dw_insert::rowfocuschanged;string s_estno 

If currentrow > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
Else
	this.SelectRow(0,false)
End If

IF this.rowcount() <= 0 THEN Return
IF currentrow <= 0 THEN Return

s_estno = this.GetItemString(currentrow,"estno") 
s_estno = left(s_estno, 12)

if dw_detail.retrieve(gs_sabu, s_estno) < 1 then
	return
end if
end event

event dw_insert::doubleclicked;//if dw_insert.AcceptText() = -1 Then Return 
//IF This.RowCount() < 1 THEN RETURN 
//IF Row < 1 THEN RETURN 
//
//string  sBlynd, sDate, sJpno, sEstno
//long    k, il_currow, lCount, lseq
//
//sblynd = this.getitemstring(Row, 'blynd')
//
//IF sblynd = '3' then //발주는 선택할 수 없음
//	f_message_chk(71, '[발주상태]')
//	return 1  		
//END IF
//
//gs_code   = this.getitemstring(Row, 'estno')
//sestno    = gs_code
//sDate     = this.getitemstring(Row, 'rdate')  //의뢰일자
//
//il_currow = row 
//
//OpenSheet(W_IMT_02010_POPUP,w_mdi_frame,2, Original!)
//
//if Isnull(gs_code) or Trim(gs_code) = "" then return
//dw_hidden.reset()
//dw_hidden.ImportClipboard()
//
//lCount = dw_hidden.rowcount()
//
//if lCount < 1 then 
//	SetPointer(Arrow!)
//	return 
//end if
//
//lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')
//
//IF lSeq < 0	 or lseq > 9999	THEN
//	f_message_chk(51, '')
//   RETURN 
//END IF
//
//COMMIT;
//
//sJpno = sDate + string(lSeq, "0000")
//
//FOR k = 1 TO lCount
//	dw_insert.rowscopy(il_currow, il_currow, primary!, dw_insert, il_currow + k, primary!)
//	dw_insert.setitem(il_currow + k, 'cvcod', dw_hidden.GetitemString(k, 'cvcod'))
//	dw_insert.setitem(il_currow + k, 'vndmst_cvnas2', dw_hidden.GetitemString(k, 'cvnm'))
//	dw_insert.setitem(il_currow + k, 'vnqty', dw_hidden.GetitemDecimal(k, 'vnqty'))
//	dw_insert.setitem(il_currow + k, 'cnvqty', dw_hidden.GetitemDecimal(k, 'cnvqty'))
//	dw_insert.setitem(il_currow + k, 'unprc', dw_hidden.GetitemDecimal(k, 'unprc'))
//	dw_insert.setitem(il_currow + k, 'cnvprc', dw_hidden.GetitemDecimal(k, 'cnvprc'))
//	dw_insert.setitem(il_currow + k, 'tuncu', dw_hidden.GetitemString(k, 'tuncu'))
//	dw_insert.setitem(il_currow + k, 'yodat', dw_hidden.GetitemString(k, 'nadate'))
//	dw_insert.SetItem(il_currow + k, "estno", sJpno + string(k, "000"))
//	dw_insert.SetItem(il_currow + k, "jestno", sEstno)
//NEXT
//
//dw_insert.setitem(il_currow, 'vnqty',  dw_insert.GetitemDecimal(il_currow, 'vnqty')  &
//												 - dw_hidden.GetitemDecimal(1, 'tot_qty'))
//
//dw_insert.setitem(il_currow, 'cnvqty', dw_insert.GetitemDecimal(il_currow, 'cnvqty')  &
//												 - dw_hidden.GetitemDecimal(1, 'tot_cnvqty'))
//
//
//
//dw_hidden.reset()
//
//
//MessageBox("전표번호 확인", "의뢰번호 : " +sDate+ '-' + string(lSeq,"0000")+		&
//									 "~r~r생성되었습니다.")
//
//if dw_insert.update() = 1 then
//	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	wf_reset()
//	ib_any_typing = FALSE
//	return 
//end if	
//
//dw_insert.ScrollToRow(il_currow + lCount)
//dw_insert.SetFocus()
//
//SetPointer(Arrow!)
//
end event

event dw_insert::buttonclicked;call super::buttonclicked;Long Lrow

Lrow = getrow()

if Lrow <  1 then return

gs_code 		= getitemstring(Lrow, "itnbr")
gs_codename = getitemstring(Lrow, "itemas_itdsc")

if isnull(gs_code) or trim(gs_code) = '' or isnull(gs_codename) or trim(gs_codename) = '' then
	return
end if


open(w_pdt_04000_1)

setnull(gs_code)
setnull(gs_codename)
end event

type p_delrow from w_inherite`p_delrow within w_imt_02020
integer x = 4087
integer y = 3116
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_02020
integer x = 3913
integer y = 3116
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_02020
boolean visible = false
integer x = 3447
integer y = 20
boolean originalsize = true
string picturename = "C:\erpman\image\발주_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\발주선택_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\발주선택_up.gif"
end event

event p_search::clicked;call super::clicked;long i, k, iRtnValue, lcount, lAdd, ltot, ll_count = 0 , ll_i
string s_daytime, s_empno, s_baljugu, sBaldate, sdate , sBlynd,sEstima_gu_pordno
datetime dttoday

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if 	lCount <= 0 then
	return 
end if	

if dw_insert.rowcount() < 1 then return 


if dw_1.object.blynd[1] <> '2' then
	Messagebox('확인' , '발주 상태를 확인하시오!.~n조건 : 발주상태 --> 결재')
	Return 
End if 

For i = 1 to dw_insert.rowcount() 
	 if dw_insert.object.blynd[i] = '2' and dw_insert.object.baljugu[i] = 'Y'  then 
	 	 ll_count = ll_count + 1 
	 end if 	
Next

if ll_count < 1 then 
	Messagebox('확인', '발주 할 내역을 확인하시오.~n상태-->발주, 발주-->체크') 
	Return
End if 

For ll_i = 1 to dw_insert.rowcount() 
	s_empno  = dw_insert.getitemstring(ll_i, 'sempno')  //구매담당자
	if 	isnull(s_empno) or trim(s_empno) = '' then
		Messagebox("구매담당자", "구매담당자를 입력하십시요")
		return
	end if
Next 


FOR i = 1 TO lCount
	w_mdi_frame.sle_msg.text = '자료 Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
w_mdi_frame.sle_msg.text = ''

if Messagebox('확 인','선택된 내역에 대해서 발주 하시겠습니까?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//발주지시가 'Y'인 자료만 현재일자와 시간 move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS')   //발주지시시간

//FOR k=1 TO dw_insert.rowcount()
//		sle_msg.text = '발주 Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
//    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //발주지시 유무
//		sBlynd  = dw_insert.getitemstring(k,'blynd') 
//		sestima_gu_pordno = dw_insert.getitemstring(k,'estima_gu_pordno') 
//
//		if 	s_baljugu = 'Y' and sBlynd = '2' then
//			if trim(sestima_gu_pordno) = '' or isnull(sestima_gu_pordno) then
//				Messagebox('확인', '사급자재 의뢰번호가 생성되지 않았습니다.~n의뢰번호를 먼저 생성한 후 발주처리 할 수 있습니다') 
//				return
//			End if 
// 		end if
//NEXT
//
lAdd = 0
FOR k=1 TO dw_insert.rowcount()
	sle_msg.text = '발주 Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //발주지시 유무
		sBlynd  = dw_insert.getitemstring(k,'blynd') 

    	if s_baljugu = 'Y' and sBlynd = '2' then
       	dw_insert.setitem(k, "baljutime", s_daytime)
			dw_insert.setitem(k, "blynd", '3')
		 	lAdd++
 		end if
NEXT
w_mdi_frame.sle_msg.text = ''

sDate   = dw_1.getitemstring(1, 'baldate')      //발주일자
if 	sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

IF 	ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF 	(sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("확 인", "생성할 발주번호를 입력하세요!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

if 	dw_insert.update() = 1 then
	
	IF lAdd > 0 then 
		iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
   	ELSE
		iRtnValue = 1
	END IF

	IF iRtnValue = 1 THEN
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	ELSE
		ROLLBACK;
		f_message_chk(41,'')
		Return
	END IF
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

SetPointer(Arrow!)

p_inq.TriggerEvent(Clicked!)



end event

type p_ins from w_inherite`p_ins within w_imt_02020
integer x = 3739
integer y = 3116
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_imt_02020
integer y = 16
end type

type p_can from w_inherite`p_can within w_imt_02020
integer x = 4261
integer y = 16
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02020
boolean visible = false
integer x = 3451
integer y = 156
integer width = 357
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\거래처등록_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\거래처등록_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\거래처등록_up.gif"
end event

event p_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = dw_1.GetItemString(1,'sempno') //구매담당자

openSheet(w_pdm_01045, w_mdi_frame,2, Original!)
end event

type p_inq from w_inherite`p_inq within w_imt_02020
integer x = 3895
integer y = 16
integer height = 140
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_blynd, s_estgu, s_frdept, s_todept, s_frdate, s_todate, s_empno, s_cvcod,	&
		 sIpdpt

if dw_1.AcceptText() = -1 then return 

s_blynd = dw_1.GetItemString(1,'blynd')  //발주상태 
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  //의뢰일자 from
s_todate= trim(dw_1.GetItemString(1,'todate'))  //의뢰일자 to
s_frdept= trim(dw_1.GetItemString(1,'frdept'))  //의뢰부서 from
s_todept= trim(dw_1.GetItemString(1,'todept'))  //의뢰부서 to
s_empno = dw_1.GetItemString(1,'sempno') //구매담당자
s_estgu = dw_1.GetItemString(1,'autcrt')  //생성구분
//s_itgu  = dw_1.GetItemString(1,'itgu')   //구입형태
s_cvcod = dw_1.GetItemString(1,'cvcod')  
sIpdpt = dw_1.GetItemString(1,'ipdpt')  

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[구매담당자]')
	dw_1.Setcolumn('sempno')
	dw_1.SetFocus()
	return
end if	

if isnull(s_estgu) or s_estgu = "" then
	f_message_chk(30,'[생성구분]')
	dw_1.Setcolumn('sestgu')
	dw_1.SetFocus()
	return
end if	

if isnull(sIpdpt) or sIpdpt = "" then sIpdpt = ''

//if isnull(sIpdpt) or sIpdpt = "" then
//	f_message_chk(30,'[입고예정창고]')
//	dw_1.Setcolumn('ipdpt')
//	dw_1.SetFocus()
//	return
//end if	

///////////////////////////////////////////////////////////////////////////////////
// 구매검토된 내역중 '의뢰'상태/결재상태가 완료가 아닌 내역을 조회하여 전자결재 상태를 update한다
DataStore ds
Long  ix
String sGwNo, sGwStatus

ds = create datastore
ds.dataobject = 'd_imt_02030_ds'
ds.SetTransObject(sqlca)
ds.Retrieve()
For ix = 1 To ds.RowCount()
	sGwNo  = Trim(ds.GetItemString(ix, 'gwno'))
	
	If is_gwgbn = 'Y' Then
		select approvalstatus into :sGwStatus
		  from eafolder_00022_erp a, approvaldocinfo b
		 where a.macro_field_1 = :sgwno
			and a.reporterid 	 = b.reporterid
			and a.reportnum	 = b.reportnum	using sqlca1 ;
	End If
	
	If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
		// 보류나 반려인 경우 취소로 상태 변경
		If sGwStatus = '2' Or sGwStatus = '5' Then
			UPDATE ESTIMA SET BLYND = '4' , YEBI2 = :sGwStatus WHERE SABU = :gs_sabu AND GWNO = :sGwno;
		Else
			UPDATE ESTIMA SET YEBI2 = :sGwStatus WHERE SABU = :gs_sabu AND GWNO = :sGwno;
		End If
	End If
Next
COMMIT;

///////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//if isnull(s_itgu) or s_itgu = "" then s_itgu = '%'
if isnull(s_frdept) or s_frdept = "" then s_frdept = '.'
if isnull(s_todept) or s_todept = "" then s_todept = 'zzzzzz'
if isnull(s_frdate) or s_frdate = "" then s_frdate = '00000101'
if isnull(s_todate) or s_todate = "" then s_todate = '99991231'

dw_insert.setredraw(false)
	
if isCnvgu = 'Y' then // 발주단위 사용시
	if s_estgu = 'Y' or s_estgu = 'O' then
		dw_insert.dataobject = 'd_imt_02020_3_1'
		p_search.enabled = False
	else
		dw_insert.dataobject = 'd_imt_02020_1_1'
		p_search.enabled = true
	end if
Else						// 발주단위 사용안함
	if s_estgu = 'Y' or s_estgu = 'O' then
		dw_insert.dataobject = 'd_imt_02020_3'
		p_search.enabled = False
	else
		dw_insert.dataobject = 'd_imt_02020_1'
		p_search.enabled = true
	end if		
End if	

dw_insert.settransobject(sqlca)

if s_cvcod = '' or isnull(s_cvcod) then 
	dw_insert.SetFilter("")
else
	dw_insert.SetFilter("cvcod = '"+ s_cvcod +" '")
end if
dw_insert.Filter()

if dw_insert.Retrieve(gs_sabu, s_blynd, s_frdate, s_todate, &
							 s_frdept, s_todept, s_empno, s_estgu, sIpdpt+'%') <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
end if	

dw_insert.SetFocus()

ib_any_typing = FALSE

dw_insert.setredraw(true)
end event

type p_del from w_inherite`p_del within w_imt_02020
integer x = 4434
integer y = 3116
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_imt_02020
integer x = 4078
integer y = 16
integer height = 140
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;long i, k, iRtnValue, lcount, lAdd
string s_daytime, s_empno, s_baljugu, sBaldate, sOpt, sDate /*발주일자 */, sBlynd 
datetime dttoday

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if lCount <= 0 then
	return 
end if	

///////////////////////////////////////////////////////////////////////////////////////////
FOR i = 1 TO lCount
//	dw_insert.SetItem(i, "ipdpt", dw_1.GetItemString(1, "ipdpt"))
	
	sBlynd = dw_insert.GetItemString(i, 'blynd')
	If is_gwgbn = 'N' and sBlynd = '2' then
		dw_insert.SetItem(i, 'yebi2', '4')			// 전자결재 연동 안할 경우
	Else
		dw_insert.SetItem(i, 'yebi2', '0')			// 전자결재 연동 할 경우
	End If
	
	IF wf_required_chk(i) = -1 THEN RETURN	
NEXT
///////////////////////////////////////////////////////////////////////////////////////////

//IF dw_1.getitemstring(1, 'autcrt') = 'N' then
//	if Messagebox('확 인','저장시 발주지시가 YES 이면 발주 확정됩니다.'  + &
//	                      '저장 하시겠습니까?',Question!,YesNo!,1) = 2 then return 
//ELSE
//	if Messagebox('확 인','저장 하시겠습니까?',Question!,YesNo!,1) = 2 then return 
//END IF

if Messagebox('확 인','저장 하시겠습니까?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//발주지시가 'Y'인 자료만 현재일자와 시간 move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS') //발주지시시간
s_empno = dw_insert.getitemstring(1, 'sempno')  //구매담당자

sDate   = dw_1.getitemstring(1, 'baldate')      //발주일자
if sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

FOR k=1 TO lCount
    s_baljugu = dw_insert.getitemstring(k, "baljugu")  //발주지시 유무
    if s_baljugu = 'Y' then
       dw_insert.setitem(k, "baljutime", s_daytime)
		 lAdd++
	 end if
NEXT

IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF (sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("확 인", "생성할 발주번호를 입력하세요!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

//// 발주검토 전자결재 연동시
//IF is_gwgbn = 'Y' then
//	wf_create_gwdoc()
//End If

// 발주검토 저장
if dw_insert.update() = 1 then
	
	IF lAdd > 0 then 
      sopt = dw_1.getitemstring(1, "opt")  //발주생성시 option
		
//		if sopt = '2' then //집계(이전방식)
//			iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
//		else //'1'이면 개별(의뢰1건에 발주 1건)
//			iRtnValue = sqlca.erp000000081(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
//		end if
   ELSE
		iRtnValue = 1
	END IF
	
	IF iRtnValue = 1 THEN
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	ELSE
		ROLLBACK;
		f_message_chk(41, STRING(iRtnValue) )
		Return
	END IF
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

SetPointer(Arrow!)

p_inq.TriggerEvent(Clicked!)
	
end event

type cb_exit from w_inherite`cb_exit within w_imt_02020
integer x = 1897
integer y = 2856
end type

type cb_mod from w_inherite`cb_mod within w_imt_02020
integer x = 1193
integer y = 2856
end type

type cb_ins from w_inherite`cb_ins within w_imt_02020
integer x = 1829
integer y = 2752
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_02020
integer x = 2181
integer y = 2752
end type

type cb_inq from w_inherite`cb_inq within w_imt_02020
integer x = 846
integer y = 2856
end type

type cb_print from w_inherite`cb_print within w_imt_02020
integer x = 434
integer y = 2864
integer width = 402
integer height = 100
string text = "거래처등록"
end type

type st_1 from w_inherite`st_1 within w_imt_02020
end type

type cb_can from w_inherite`cb_can within w_imt_02020
integer x = 1545
integer y = 2856
end type

type cb_search from w_inherite`cb_search within w_imt_02020
integer x = 14
integer y = 2864
integer width = 402
string text = "발주선택"
end type





type gb_10 from w_inherite`gb_10 within w_imt_02020
integer x = 5
integer y = 2740
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02020
end type

type rr_descr from roundrectangle within w_imt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 2172
integer width = 4530
integer height = 136
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_imt_02020
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 64
integer y = 28
integer width = 3401
integer height = 576
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02020_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Choose Case GetColumnName() 
	Case "remark"
		return 0
	Case Else
      Send(Handle(this),256,9,0)
      Return 1
End Choose		
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, s_estgu, s_name, s_date, scvcod, get_nm, get_nm2
int    ireturn 

setnull(snull)

IF this.GetColumnName() ="blynd" THEN  
	scvcod = this.GetText()
   if scvcod = '3' then 
		cb_search.enabled = false
		p_mod.enabled = false
	else	
		cb_search.enabled = true
		p_mod.enabled = true
	end if
   dw_insert.reset()	
ELSEIF this.GetColumnName() ="itgu" THEN   //구입형태구분
	s_estgu = this.gettext()
 
   IF s_estgu = "" OR IsNull(s_estgu) THEN RETURN
	
	s_name = f_get_reffer('28', s_estgu)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[구입형태구분]')
		this.SetItem(1,'itgu', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() ="frdate" THEN  //의뢰일자 FROM
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[의뢰일자]')
		this.SetItem(1,"frdate",snull)
		this.Setcolumn("frdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="todate" THEN  //의뢰일자 TO
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[의뢰일자]')
		this.SetItem(1,"todate",snull)
		this.Setcolumn("todate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="cvcod" THEN  
	scvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(1, "cvcod", scvcod)	
	this.setitem(1, "cvnas", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() ="baldate" THEN  
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[발주일자]')
		this.SetItem(1,"baldate",is_today)
		this.Setcolumn("baldate")
		this.SetFocus()
		Return 1
	END IF
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;string get_dptno, get_cvnm, get_date, s_estno

setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "frdept" THEN
	open(w_vndmst_4_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "frdept", gs_Code)
ELSEIF this.GetColumnName() = "todept" THEN
	open(w_vndmst_4_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "todept", gs_Code)
ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
END IF	
end event

type dw_detail from datawindow within w_imt_02020
integer x = 101
integer y = 2200
integer width = 3657
integer height = 96
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_imt_02020_2"
boolean border = false
boolean livescroll = true
end type

event editchanged;ib_any_typing =True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type dw_hidden from datawindow within w_imt_02020
boolean visible = false
integer x = 2551
integer y = 2748
integer width = 494
integer height = 116
boolean bringtotop = true
string dataobject = "d_imt_02010_popup2"
boolean livescroll = true
end type

type st_3 from statictext within w_imt_02020
boolean visible = false
integer x = 3264
integer y = 240
integer width = 1362
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[아래 자료를 DOUBLE CLICK시 의뢰자료를 분할]"
boolean focusrectangle = false
end type

type sle_bal from singlelineedit within w_imt_02020
event ue_key pbm_keydown
integer x = 4274
integer y = 2204
integer width = 265
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
end type

event ue_key;if key = KeyEnter! then
	p_mod.setfocus()
end if
end event

event modified;//string sBaljpno, sNull
//LonG   lCount
//
//setnull(snull)
//
//sBaljpno = trim(this.text)
//
//  SELECT COUNT(*)
//    INTO :lCount
//    FROM POMAST  
//   WHERE SABU    =    '1'   
//     AND BALJPNO LIKE :sBaljpno||'%' ;
//
//IF lCount > 0 THEN
//	MessageBox("확 인", "등록된 발주번호입니다. 생성할 발주번호를 확인하세요!")
//	this.text = sNull
//	return 1
//END IF	
//
end event

type st_2 from statictext within w_imt_02020
integer x = 3781
integer y = 2212
integer width = 485
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "*생성할 발주번호 "
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_imt_02020
boolean visible = false
integer x = 1792
integer y = 196
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('baldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'baldate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_02020
integer x = 2793
integer y = 40
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('frdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'frdate', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_02020
integer x = 3246
integer y = 40
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('todate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'todate', gs_code)



end event

type p_2 from picture within w_imt_02020
integer x = 3630
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\결재상신_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_1.AcceptText() <> 1 Then Return

// 발주검토 전자결재 연동시
IF is_gwgbn = 'Y' then
	wf_create_gwdoc()
	
	// 발주검토 저장
	if dw_insert.update() = 1 then	
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		return 
	end if	
	
	SetPointer(Arrow!)
	
	p_inq.TriggerEvent(Clicked!)
End If

//String sEstNo, ls_status , sYebi, ls_chk = 'N', ls_chk2 = 'N', ls_estno, ls_estno2
//long i, lCount, ll_i, ll_i2 = 0 
//
//dw_1.accepttext()
//if dw_insert.rowcount() < 1 then return 
//
//
//if dw_1.object.blynd[1] = '1' or dw_1.object.blynd[1] = '2' then
//ELSE 	
//	Messagebox('확인', '발주상태를 확인하시오.~n발주상태 : 의뢰, 검토') 
//	Return 
//end if 
//
////일관검토처리
//For ll_i = 1 to dw_insert.rowcount() 
//	if dw_insert.object.blynd[ll_i] = '1' and dw_insert.object.chk[ll_i] = 'Y' then 
// 		if messagebox('확인', '검토 되지 않은 내역이 존재합니다.~n검토 되지 않은 내역을 검토처리 하시겠습니까?', exclamation!, okcancel!, 2) = 2 then return
//		 	For ll_i2 = 1 to dw_insert.rowcount() 
//				if dw_insert.object.blynd[ll_i2] = '1' and dw_insert.object.chk[ll_i2] = 'Y' then 
//					ls_estno = dw_insert.object.blynd[ll_i2] 
//					
//					update estima 
//					   set blynd = '2'
//					where estno = :ls_estno ; 
//					
//					commit; 
//					
//					dw_insert.object.blynd[ll_i2] = '2'
//					
//				end if 	
//			Next
//	end if
//Next
//
////삭제
//ls_estno2 = ""
//For ll_i2 = 1 to dw_insert.rowcount() 
//	if dw_insert.object.blynd[ll_i2] = '2' and dw_insert.object.chk[ll_i2] = 'Y' then 
//		IF ls_estno2  = "" then 
//			ls_estno2 = dw_insert.object.estno[ll_i2]
//			
//			Delete from estima_ref where estno2 = :ls_estno2 ; 
//			commit; 
//			exit 			
//		End if 
//	end if 	
//Next 
//
////등록
//ls_estno2 = ""
//For ll_i2 = 1 to dw_insert.rowcount() 
//	if dw_insert.object.blynd[ll_i2] = '2' and dw_insert.object.chk[ll_i2] = 'Y' then 
//		IF ls_estno2  = "" then 
//			ls_estno2 = dw_insert.object.estno[ll_i2]
//			
//		End if 
//		
//		ls_estno = dw_insert.object.estno[ll_i2]
//		
//		insert into estima_ref values (:ls_estno, :ls_estno2 ) ;  
//		
//		commit; 
//		
//	end if 	
//Next 
//
//
//For ll_i = 1 to dw_insert.rowcount() 
//	 if  dw_insert.object.blynd[ll_i] = '2' and dw_insert.object.chk[ll_i] = 'Y' then 
//		  ls_chk = 'Y' 
//	 end if 
//Next 
//
//if ls_chk = 'N' then 
//	messagebox('확인', '결재상신 할 내역이 존재 하지 않습니다. 발주상태 정보를 확인하시오') 
//	return 
//End if 
	
//전표번호
//sEstno = " "
//For ll_i = 1 to dw_insert.rowcount() 
//	 if dw_insert.object.blynd[ll_i] = '2' and dw_insert.object.chk[ll_i] = 'Y' then 
//	 	sEstno = sEstno + "" + dw_insert.object.estno[ll_i] + ","
//	 end if 
//Next 
//sEstno = mid(sEstno, 1, len(sEstno) - 1 ) 


//ls_status  = dw_1.GetItemString(1, 'estgu')

//gs_code  = "%26SABU=1%26ESTNO="+ sEstNo + "%26ESTGU=" + ls_status		//수주번호
//gs_code  = "%26SABU=1%26ESTNO="+ sEstNo  //수주번호
//gs_gubun = '00049'										//그룹웨어 문서번호
//gs_codename = '구매발주검토(담당자별)'									//제목입력받음
//
//lcount = dw_insert.rowcount()


// 발주품의에 대한 전자결재 진행상태
//sYebi = dw_insert.GetItemString(1, 'yebi2')
//If IsNull(sYebi) Then sYebi = '0'
//
//If ls_chk = 'Y' Then
//	// 그룹웨어 문서번호
//	//SELECT TRIM(DATANAME) INTO :gs_gubun FROM SYSCNFG WHERE SYSGU = 'W' AND SERIAL = 1 AND LINENO = 'B';
//	
//	WINDOW LW_WINDOW
//	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
//	
//	lw_window.x = 0
//	lw_window.y = 0
//End If
end event

type rr_1 from roundrectangle within w_imt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 604
integer width = 4539
integer height = 1552
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_balju from line within w_imt_02020
integer linethickness = 1
integer beginx = 4274
integer beginy = 2276
integer endx = 4539
integer endy = 2276
end type

