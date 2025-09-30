$PBExportHeader$w_imt_03740.srw
$PBExportComments$기준시점 발주/입고 현황
forward
global type w_imt_03740 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_03740
end type
type pb_2 from u_pb_cal within w_imt_03740
end type
type p_gwins from uo_picture within w_imt_03740
end type
type rr_1 from roundrectangle within w_imt_03740
end type
end forward

global type w_imt_03740 from w_standard_print
string title = "기준시점 발주/입고 현황"
pb_1 pb_1
pb_2 pb_2
p_gwins p_gwins
rr_1 rr_1
end type
global w_imt_03740 w_imt_03740

type variables
String     is_gwgbn            // 그룹웨어 연동여부
Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00019'	// 그룹웨어 문서번호
dec        idsaleamt
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_fcvcod, s_tcvcod, sdate, edate, s_saupj
Dec    dSaleAmt

if dw_ip.AcceptText() = -1 then return -1

s_fcvcod = trim(dw_ip.GetItemString(1, "scvcod"))
s_tcvcod = trim(dw_ip.GetItemString(1, "ecvcod"))
s_saupj  = trim(dw_ip.GetItemString(1, "saupj" ))
sdate    = trim(dw_ip.GetItemString(1, "sdate" ))
edate    = trim(dw_ip.GetItemString(1, "edate" )) 

IF s_saupj = "" OR IsNull(s_saupj) THEN 
	f_message_chk(30,'[사업장]')
	dw_ip.Setcolumn('saupj')
	dw_ip.SetFocus()
	return -1
END IF

if sdate = "" or IsNull(sdate) then	sdate = '10000101'
if edate = "" or IsNull(edate) then	edate = '99991231'
IF s_fcvcod = "" OR IsNull(s_fcvcod) THEN s_fcvcod = '.'
IF s_tcvcod = "" OR IsNull(s_tcvcod) THEN s_tcvcod = 'zzzzzz'

IF dw_print.Retrieve(gs_sabu, s_saupj, s_fcvcod, s_tcvcod, sdate, edate) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
ELSE
	dw_print.ShareData(dw_list)
end if

If trim(dw_ip.GetItemString(1, "gub" )) = '1' Then
	// 영업실적
	select sum(a.ioqty * ( a.ioprc - nvl(a.pacprc,0) ) *b.calvalue) into :dSaleAmt
	  from imhist a, iomatrix b
	 where a.sabu = '1'
		and a.io_date between :sdate and :edate
		and a.iogbn = b.iogbn
		and b.salegu = 'Y'
		and a.iogbn <> 'OY2';
	
	idsaleamt = dSaleAmt
	dw_list.Modify("t_sale.text = '" + '영업실적 : ' + string(dsaleamt,'#,##0')+"'")
	dw_print.Modify("t_sale.text = '" + '영업실적 : ' + string(dsaleamt,'#,##0')+"'")
End If

return 1

end function

on w_imt_03740.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_gwins=create p_gwins
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.p_gwins
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_03740.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_gwins)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'saupj')

dw_ip.SetItem(1, 'sdate', left(is_today,6)+'01')
dw_ip.SetItem(1, 'edate', is_today)

//그룹웨어 연동구분
//Select dataname into :is_gwgbn
//  from syscnfg
// where sysgu = 'W' and
//       serial = 1 and
//		 lineno = '2';
is_gwgbn = 'Y'

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

end event

event closequery;call super::closequery;// 그룹웨어 접속정보 해제
If is_gwgbn = 'Y' Then
	disconnect	using	sqlca1 ;
	destroy	sqlca1
End If
end event

type p_preview from w_standard_print`p_preview within w_imt_03740
end type

type p_exit from w_standard_print`p_exit within w_imt_03740
end type

type p_print from w_standard_print`p_print within w_imt_03740
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03740
end type







type st_10 from w_standard_print`st_10 within w_imt_03740
end type



type dw_print from w_standard_print`dw_print within w_imt_03740
integer x = 3003
integer y = 40
string dataobject = "d_imt_03740_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03740
integer x = 18
integer y = 24
integer width = 2985
integer height = 268
string dataobject = "d_imt_03740_a"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string  snull, svndcod, svndnm, svndnm2, sdate 
int     ireturn 
setnull(snull)

IF this.GetColumnName() = "scvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "scvcod", svndcod)	
	this.setitem(1, "scvnam", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ecvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "ecvcod", svndcod)	
	this.setitem(1, "ecvnam", svndnm)	
	RETURN ireturn
//ELSEIF this.GetColumnName() = "sitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
//	this.setitem(1, "sitnbr", svndcod)	
//	this.setitem(1, "sitdsc", svndnm)	
//	RETURN ireturn	
//ELSEIF this.GetColumnName() = "eitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
//	this.setitem(1, "eitnbr", svndcod)	
//	this.setitem(1, "eitdsc", svndnm)	
//	RETURN ireturn		
ELSEIF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "gub"	THEN
	If trim(this.GetText()) = '2' Then
		dw_list.DataObject = 'd_imt_03740_1'
		dw_print.DataObject = 'd_imt_03740_1_p'
		p_gwins.Visible = False
	Else
		dw_list.DataObject = 'd_imt_03740_2_p'
		dw_print.DataObject = 'd_imt_03740_2_p'
		p_gwins.Visible = True
	End If
	dw_list.SetTransObject(sqlca)
	dw_print.SetTransObject(sqlca)
end if
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'scvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"scvcod",gs_code)
	this.SetItem(1,"scvnam",gs_codename)
elseif this.GetColumnName() = 'ecvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"ecvcod",gs_code)
	this.SetItem(1,"ecvnam",gs_codename)
//elseif this.GetColumnName() = 'sitnbr' then
//	gs_gubun = '3'
//	open(w_itemas_popup)
//	if isnull(gs_code) or gs_code = "" then return
//	this.SetItem(1,"sitnbr",gs_code)
////	this.setitem(1,"sitdsc",gs_codename)
//elseif this.GetColumnName() = 'eitnbr' then
//	gs_gubun = '3'
//	open(w_itemas_popup)
//	if isnull(gs_code) or gs_code = "" then return
//	this.SetItem(1,"eitnbr",gs_code)
////	this.setitem(1,"eitdsc",gs_codename)
end if	



end event

type dw_list from w_standard_print`dw_list within w_imt_03740
integer y = 308
integer width = 4539
string dataobject = "d_imt_03740_2_p"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_03740
integer x = 1687
integer y = 52
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03740
integer x = 2121
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type p_gwins from uo_picture within w_imt_03740
integer x = 2990
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\결재상신_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\결재상신_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\결재상신_dn.gif'
end event

event clicked;call super::clicked;String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus
long ll_FLength, dgwSeq, lRow

// HTML 문서를 읽어들인다
ll_FLength = FileLength("EAFolder_00019.html")
li_FileNum = FileOpen("EAFolder_00019.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 존재하지 않습니다.!!')
	Return -1
End If

// 그룹웨어 연동시 문서번호 채번...필요한 경우 함
If IsNull(sGwNo) Or Trim(sGwNo) = '' Then
	sDate = f_today()
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
	do 
		nPos = Pos(sRepeat, '(_ROW_)')  
		If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, string(ix))	
		
		nPos = Pos(sDetRow, '(_CVNAS_)')
		sValue = dw_list.GetItemString(ix,'cvnas2')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_GBN_)')
		sValue = dw_list.Describe("evaluate('lookupdisplay(ittyp)'," + string(ix) + ")")
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sValue )
		
		nPos = Pos(sDetRow, '(_BALAMT_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'wbalamt'),'#,##0'))

		nPos = Pos(sDetRow, '(_IPAMT_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, String(dw_list.GetItemNumber(ix,'wipamt'),'#,##0'))

		nPos = Pos(sDetRow, '(_RATE_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, String(dw_list.GetItemNumber(ix,'rate'),'#,##0 %'))
		
		nPos = Pos(sDetRow, '(_SAGUM_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, String(dw_list.GetItemNumber(ix,'saamt'),'#,##0'))

		nPos = Pos(sDetRow, '(_BIGO_)')  
		sValue = ''
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, sValue)
		
		sDetail = sDetail + sDetRow
		ix = ix + 1
	loop while (ix <= dw_list.RowCount() )

	// 합계 표시 시작--------
	ix = dw_list.RowCount()
	nPos = Pos(sRepeat, '(_ROW_)')  
	If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, '')	
	
	nPos = Pos(sDetRow, '(_CVNAS_)')
	sValue = ''
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
	
	nPos = Pos(sDetRow, '(_GBN_)')
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, '[합 계]' )
	
	nPos = Pos(sDetRow, '(_BALAMT_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'sum_wbalamt'),'#,##0'))

	nPos = Pos(sDetRow, '(_IPAMT_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, String(dw_list.GetItemNumber(ix,'sum_wipamt'),'#,##0'))

	nPos = Pos(sDetRow, '(_RATE_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, String(dw_list.GetItemNumber(ix,'sum_rate'),'#,##0 %'))
	
	nPos = Pos(sDetRow, '(_SAGUM_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, String(dw_list.GetItemNumber(ix,'sum_saamt'),'#,##0'))

	nPos = Pos(sDetRow, '(_BIGO_)')  
	sValue = ''
	If IsnUll(sValue) Then sValue = ''
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, sValue)
	
	sDetail = sDetail + sDetRow
	// 합계 표시 끝--------		

	nPos = Pos(sFooter, '(_RMK_)')
	sValue = ''
	If IsnUll(sValue) Then sValue = ''
	If nPos > 0 Then sFooter = Replace(sFooter, nPos, 7, sValue)
	
	sCall = sHeader + sDetail + sFooter
End If

// Detail외 매크로 내역을 치환한다
nPos = Pos(sCall, '(_DATE_)')
sValue = string(dw_ip.GetItemString(1,'sdate'),'@@@@.@@.@@') + ' - ' + string(dw_ip.GetItemString(1,'edate'),'@@@@.@@.@@')
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 8, sValue)
		
nPos = Pos(sCall, '(_SALE_)')
sValue = String(idSaleAmt, '#,##0')
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 8, sValue)

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
  from eafolder_00019_erp a, approvaldocinfo b
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
//For ix = 1 To dw_list.RowCount()
//	dw_list.SetItem(ix, 'shpjpno', sGwno)
//Next

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end event

type rr_1 from roundrectangle within w_imt_03740
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 300
integer width = 4581
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

