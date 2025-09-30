$PBExportHeader$w_imt_03740.srw
$PBExportComments$���ؽ��� ����/�԰� ��Ȳ
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
string title = "���ؽ��� ����/�԰� ��Ȳ"
pb_1 pb_1
pb_2 pb_2
p_gwins p_gwins
rr_1 rr_1
end type
global w_imt_03740 w_imt_03740

type variables
String     is_gwgbn            // �׷���� ��������
Transaction SQLCA1				// �׷���� ���ӿ�
String     isHtmlNo = '00019'	// �׷���� ������ȣ
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
	f_message_chk(30,'[�����]')
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
	// ��������
	select sum(a.ioqty * ( a.ioprc - nvl(a.pacprc,0) ) *b.calvalue) into :dSaleAmt
	  from imhist a, iomatrix b
	 where a.sabu = '1'
		and a.io_date between :sdate and :edate
		and a.iogbn = b.iogbn
		and b.salegu = 'Y'
		and a.iogbn <> 'OY2';
	
	idsaleamt = dSaleAmt
	dw_list.Modify("t_sale.text = '" + '�������� : ' + string(dsaleamt,'#,##0')+"'")
	dw_print.Modify("t_sale.text = '" + '�������� : ' + string(dsaleamt,'#,##0')+"'")
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

//�׷���� ��������
//Select dataname into :is_gwgbn
//  from syscnfg
// where sysgu = 'W' and
//       serial = 1 and
//		 lineno = '2';
is_gwgbn = 'Y'

If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server ����
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
		MessageBox('Ȯ ��','�׷���� ������ �� �� �����ϴ�.!!')
		is_gwgbn = 'N'
	End If
End If

end event

event closequery;call super::closequery;// �׷���� �������� ����
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
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1�̸� ����, 0�� ����	
	this.setitem(1, "scvcod", svndcod)	
	this.setitem(1, "scvnam", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ecvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1�̸� ����, 0�� ����	
	this.setitem(1, "ecvcod", svndcod)	
	this.setitem(1, "ecvnam", svndnm)	
	RETURN ireturn
//ELSEIF this.GetColumnName() = "sitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('ǰ��', 'Y', svndcod, svndnm, svndnm2)    //1�̸� ����, 0�� ����	
//	this.setitem(1, "sitnbr", svndcod)	
//	this.setitem(1, "sitdsc", svndnm)	
//	RETURN ireturn	
//ELSEIF this.GetColumnName() = "eitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('ǰ��', 'Y', svndcod, svndnm, svndnm2)    //1�̸� ����, 0�� ����	
//	this.setitem(1, "eitnbr", svndcod)	
//	this.setitem(1, "eitdsc", svndnm)	
//	RETURN ireturn		
ELSEIF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[�������� FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[�������� TO]')
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
string picturename = "C:\erpman\image\������_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\������_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\������_dn.gif'
end event

event clicked;call super::clicked;String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus
long ll_FLength, dgwSeq, lRow

// HTML ������ �о���δ�
ll_FLength = FileLength("EAFolder_00019.html")
li_FileNum = FileOpen("EAFolder_00019.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('Ȯ ��','HTML ������ �������� �ʽ��ϴ�.!!')
	Return -1
End If

// �׷���� ������ ������ȣ ä��...�ʿ��� ��� ��
If IsNull(sGwNo) Or Trim(sGwNo) = '' Then
	sDate = f_today()
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[���ڰ���]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// �ݺ����� ã�´�
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail�� ���ؼ� �ݺ��ؼ� ���� setting�Ѵ�
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

	// �հ� ǥ�� ����--------
	ix = dw_list.RowCount()
	nPos = Pos(sRepeat, '(_ROW_)')  
	If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, '')	
	
	nPos = Pos(sDetRow, '(_CVNAS_)')
	sValue = ''
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
	
	nPos = Pos(sDetRow, '(_GBN_)')
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, '[�� ��]' )
	
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
	// �հ� ǥ�� ��--------		

	nPos = Pos(sFooter, '(_RMK_)')
	sValue = ''
	If IsnUll(sValue) Then sValue = ''
	If nPos > 0 Then sFooter = Replace(sFooter, nPos, 7, sValue)
	
	sCall = sHeader + sDetail + sFooter
End If

// Detail�� ��ũ�� ������ ġȯ�Ѵ�
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
	MessageBox('Ȯ ��','HTML ������ �������� �ʾҽ��ϴ�.!!')
	Return -1
End If

//EAERPHTML�� ��ϵǾ����� Ȯ��
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// ���� �̻�� ������ ������ ����
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// �׷���� EAERPHTML TABLE�� ��ȳ����� INSERT�Ѵ�
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
	MessageBox('Ȯ��','���ŵ� �����Դϴ�.!!')
	Return 0
End If

// ��ȼ� ���
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//�׷���� ������ȣ
SetNull(gs_codename)		 			//�����Է¹���(erptitle)
Open(w_groupware_browser)

//EAERPHTML�� ��ŵǾ����� Ȯ��
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00019_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('������','���簡 ��ŵǾ����ϴ�.')
Else
	MessageBox('������','���簡 ��ŵ��� �ʾҽ��ϴ�.')
	Return -1
End If

// �׷���� ������ȣ�� �����Ƿ� ���̺� �����Ѵ�
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

