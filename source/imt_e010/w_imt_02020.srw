$PBExportHeader$w_imt_02020.srw
$PBExportComments$** ���ְ���(����ں�)
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
string title = "���ְ���(����ں�)"
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
string   ls_auto    //�ڵ�ä������
string   is_pspec,  is_jijil
string   isCnvgu    //���� ���� ��뿩��
String   is_cvcod		// �ڻ�ŷ�ó �ڵ�

String   is_gwgbn   // �׷���� ��������
Transaction SQLCA1				// �׷���� ���ӿ�
String     isHtmlNo = '00022'	// �׷���� ������ȣ

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_create_gwdoc ()
end prototypes

public function integer wf_required_chk (integer i);string s_blynd, sToday

if dw_insert.AcceptText() = -1 then return -1

stoday  = f_today()
s_blynd = dw_insert.GetItemString(i,'blynd')  //���ֻ���

if s_blynd <> '2' then return 1 //���ֻ��°� ���䰡 �ƴϸ� �ʼ��Է�üũ ���� ����

if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
	dw_insert.GetItemNumber(i,'vnqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' �� ���ֿ�����]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('vnqty')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemNumber(i,'unprc')) or &
//	dw_insert.GetItemNumber(i,'unprc') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' �� ���ִܰ�]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('unprc')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ����ó]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemString(i,'ipdpt')) or &
//	dw_insert.GetItemString(i,'ipdpt') = "" then
//	f_message_chk(1400,'[ '+string(i)+' �� â��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('ipdpt')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if isnull(dw_insert.GetItemString(i,'plncrt')) or &
	dw_insert.GetItemString(i,'plncrt') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� �ۼ�����]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('plncrt')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'suipgu')) or &
	dw_insert.GetItemString(i,'suipgu') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ���Ա���]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('suipgu')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'sakgu')) or &
	dw_insert.GetItemString(i,'sakgu') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ���İ�������]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('sakgu')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'choyo')) or &
	dw_insert.GetItemString(i,'choyo') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ÷������]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('choyo')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'yodat')) or &
	dw_insert.GetItemString(i,'yodat') = '' or &
	f_datechk(dw_insert.GetItemString(i,'yodat')) = -1 then
	Messagebox("Ȯ��", "��ȿ�� ���ڸ� �Է��Ͻʽÿ�", stopsign!)
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('yodat')
	dw_insert.SetFocus()
	return -1		
end if	

//���� ������ ��츸 ����䱸�� üũ
//IF dw_insert.GetItemString(i,'baljugu') = 'Y' THEN 
//	if	dw_insert.GetItemString(i,'yodat') < sToday  then
//		MessageBox("Ȯ��", "����䱸���� �������ں��� ���� �� �����ϴ�.", stopsign!)	
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

if isCnvgu = 'Y' then // ���ִ��� ����
	dw_insert.dataobject = 'd_imt_02020_1_1'
Else						// ���ִ��� ������
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
dw_1.setitem(1, 'sempno', get_name) //���� ����� �⺻ ����

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

// HTML ������ �о���δ�
ll_FLength = FileLength("EAFolder_00022.html")
li_FileNum = FileOpen("EAFolder_00022.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('Ȯ ��','HTML ������ �������� �ʽ��ϴ�.!!')
	Return -1
End If

// �׷���� ���� ��ȣ 
SetNull(sGwNo)

sDate = f_today()
// �׷���� ������ ������ȣ ä��...�ʿ��� ��� ��
If IsNull(sGwNo) Then
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
	irow = 1
	dTotAmt = 0
	do 
		if dw_insert.GetItemString(ix, 'chk') = 'Y' Then
			
			// ��ȭ�ݾ����� ȯ���Ͽ� �ѱݾ��� ����
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
			
			// ����䱸��
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

// Detail�� ��ũ�� ������ ġȯ�Ѵ�
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
  from eafolder_00022_erp a, approvaldocinfo b
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

event key;// Page Up & Page Down & Home & End Key ��� ����
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
		 
dw_1.setitem(1, 'sempno', get_name) //���� ����� �⺻ ����
dw_1.setitem(1, 'baldate', is_today) //�������� �⺻ ����

// ���ڰ��� ��������(���ְ���)
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_gwgbn
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'W' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '3' )   ;
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

// �����Ƿڵ� ������ '�Ƿ�'����/������°� �Ϸᰡ �ƴ� ������ ��ȸ�Ͽ� ���ڰ��� ���¸� update�Ѵ�
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

	// ������ �ݷ��� ��� '���'�� �����Ѵ�
	If sGwStatus = '2' Or sGwStatus = '5' Then
		UPDATE ESTIMA SET BLYND = '4', GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sEstno||'%';
	Else
		UPDATE ESTIMA SET GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sEstno||'%';
	End If
		
Next
COMMIT;

///////////////////////////////////////////////////////////////////////////////////

// ���ִ��� ��뿡 ���� ȭ�� ����

/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
select dataname
  into :isCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
 
If isNull(isCnvgu) or Trim(isCnvgu) = '' then
	isCnvgu = 'N'
End if

if isCnvgu = 'Y' then // ���ִ��� ����
	dw_insert.dataobject = 'd_imt_02020_1_1'
Else						// ���ִ��� ������
	dw_insert.dataobject = 'd_imt_02020_1'
End if	

/* ���ֹ�ȣ �ڵ�ä�����θ� ȯ�漳������ �˻��� */
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

// �ڻ� �ŷ�ó������ �ڵ�
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

event closequery;call super::closequery;// �׷���� �������� ����
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
   
	IF sblynd = '3' then //����//����� ������ �� ����
      f_message_chk(71, '[���ֻ���]')
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
					MessageBox("Ȯ ��","�۾����ð� ��� �����Դϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
											 "���ֻ��¸� �����ų �� �����ϴ�.", StopSign! )
					this.SetItem(ll_row, "blynd", old_sblynd)
					Return 1
				end if
			else	
				MessageBox("Ȯ ��","�۾����ù�ȣ�� Ȯ���ϼ���" + "~n~n" +&
										 "���ֻ��¸� �����ų �� �����ϴ�.", StopSign! )
				this.SetItem(ll_row, "blynd", old_sblynd)
				Return 1
			end if	
		End if	
	END IF
// ����䱸��
ELSEIF this.GetColumnName() = 'yodat' THEN
	String sDate
	sDate  = trim(this.gettext())

	IF f_datechk(sDate) = -1	then
		this.setitem(ll_Row, "yodat", f_today())
		return 1
	END IF

	IF f_today() > sDate	THEN
		MessageBox("Ȯ��", "����䱸���� �������ں��� ���� �� �����ϴ�.")
		this.setitem(ll_Row, "yodat", f_today())
		return 1
	END IF
	
ELSEIF this.GetColumnName() = "ipdpt" THEN
	scvcod = this.GetText()
	
	ireturn = f_get_name2('â��', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(ll_row, "ipdpt", scvcod)	
	this.setitem(ll_row, "ipdpt_name", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "baljugu" THEN
	scvcod = this.GetText()
   IF scvcod = 'Y' then 	
      IF this.getitemstring(ll_row, 'blynd') = '4' THEN 
			MessageBox("Ȯ ��","���°� ����� �ڷ�� �������ø� ���� �� �����ϴ�.", StopSign! )
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
   
	// ��ü���ֿ����ܰ� ����
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
//ELSEIF this.getcolumnname() = 'shpjpno' then    /* Maker ����*/
//	sPspec 	= GetText()
//	sItnbr  	= GetItemString(LL_row,'itnbr')
//	scvcod 	= GetItemString(LL_row,'cvcod')
//	sDate		= GetItemString(LL_row,'rdate')
//	
//	If IsNull(sPspec) Or Trim(sPspec) = '' Then sPspec = '.'
//	
//	If 	Not IsNull(sItnbr) Then	
//		/* ��纰 ���Դܰ�*/
//		SELECT Fun_danmst_danga10(:sDate, :scvcod, :sitnbr, :sPspec) INTO :dunprc FROM DUAL;
//		
//		setitem(LL_row, "unprc", dunprc)
//		// ��ü���ֿ����ܰ� ����
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
// ��� Ŭ���� 
ELSEIF this.getcolumnname() = 'chk' then
	If Trim(GetText()) = 'Y' Then
		If GetItemString(ll_row, 'cvcod') = is_cvcod Then
			f_message_chk(203,'[����ó]')
			Return 2
		End If
		If GetItemNumber(ll_row, 'unprc') <= 0 Or IsNull(GetItemNumber(ll_row, 'unprc')) Then
			f_message_chk(80,'[���ִܰ�]')
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
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:����,4:�μ�,5:â��   
      f_message_chk(70, '[����ó]')
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
//IF sblynd = '3' then //���ִ� ������ �� ����
//	f_message_chk(71, '[���ֻ���]')
//	return 1  		
//END IF
//
//gs_code   = this.getitemstring(Row, 'estno')
//sestno    = gs_code
//sDate     = this.getitemstring(Row, 'rdate')  //�Ƿ�����
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
//MessageBox("��ǥ��ȣ Ȯ��", "�Ƿڹ�ȣ : " +sDate+ '-' + string(lSeq,"0000")+		&
//									 "~r~r�����Ǿ����ϴ�.")
//
//if dw_insert.update() = 1 then
//	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
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
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\���ּ���_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\���ּ���_up.gif"
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
	Messagebox('Ȯ��' , '���� ���¸� Ȯ���Ͻÿ�!.~n���� : ���ֻ��� --> ����')
	Return 
End if 

For i = 1 to dw_insert.rowcount() 
	 if dw_insert.object.blynd[i] = '2' and dw_insert.object.baljugu[i] = 'Y'  then 
	 	 ll_count = ll_count + 1 
	 end if 	
Next

if ll_count < 1 then 
	Messagebox('Ȯ��', '���� �� ������ Ȯ���Ͻÿ�.~n����-->����, ����-->üũ') 
	Return
End if 

For ll_i = 1 to dw_insert.rowcount() 
	s_empno  = dw_insert.getitemstring(ll_i, 'sempno')  //���Ŵ����
	if 	isnull(s_empno) or trim(s_empno) = '' then
		Messagebox("���Ŵ����", "���Ŵ���ڸ� �Է��Ͻʽÿ�")
		return
	end if
Next 


FOR i = 1 TO lCount
	w_mdi_frame.sle_msg.text = '�ڷ� Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
w_mdi_frame.sle_msg.text = ''

if Messagebox('Ȯ ��','���õ� ������ ���ؼ� ���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS')   //�������ýð�

//FOR k=1 TO dw_insert.rowcount()
//		sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
//    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
//		sBlynd  = dw_insert.getitemstring(k,'blynd') 
//		sestima_gu_pordno = dw_insert.getitemstring(k,'estima_gu_pordno') 
//
//		if 	s_baljugu = 'Y' and sBlynd = '2' then
//			if trim(sestima_gu_pordno) = '' or isnull(sestima_gu_pordno) then
//				Messagebox('Ȯ��', '������� �Ƿڹ�ȣ�� �������� �ʾҽ��ϴ�.~n�Ƿڹ�ȣ�� ���� ������ �� ����ó�� �� �� �ֽ��ϴ�') 
//				return
//			End if 
// 		end if
//NEXT
//
lAdd = 0
FOR k=1 TO dw_insert.rowcount()
	sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
		sBlynd  = dw_insert.getitemstring(k,'blynd') 

    	if s_baljugu = 'Y' and sBlynd = '2' then
       	dw_insert.setitem(k, "baljutime", s_daytime)
			dw_insert.setitem(k, "blynd", '3')
		 	lAdd++
 		end if
NEXT
w_mdi_frame.sle_msg.text = ''

sDate   = dw_1.getitemstring(1, 'baldate')      //��������
if 	sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

IF 	ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF 	(sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("Ȯ ��", "������ ���ֹ�ȣ�� �Է��ϼ���!") 
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
		w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
		commit ;
	ELSE
		ROLLBACK;
		f_message_chk(41,'')
		Return
	END IF
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
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
string picturename = "C:\erpman\image\�ŷ�ó���_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\�ŷ�ó���_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\�ŷ�ó���_up.gif"
end event

event p_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = dw_1.GetItemString(1,'sempno') //���Ŵ����

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

s_blynd = dw_1.GetItemString(1,'blynd')  //���ֻ��� 
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  //�Ƿ����� from
s_todate= trim(dw_1.GetItemString(1,'todate'))  //�Ƿ����� to
s_frdept= trim(dw_1.GetItemString(1,'frdept'))  //�Ƿںμ� from
s_todept= trim(dw_1.GetItemString(1,'todept'))  //�Ƿںμ� to
s_empno = dw_1.GetItemString(1,'sempno') //���Ŵ����
s_estgu = dw_1.GetItemString(1,'autcrt')  //��������
//s_itgu  = dw_1.GetItemString(1,'itgu')   //��������
s_cvcod = dw_1.GetItemString(1,'cvcod')  
sIpdpt = dw_1.GetItemString(1,'ipdpt')  

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[���Ŵ����]')
	dw_1.Setcolumn('sempno')
	dw_1.SetFocus()
	return
end if	

if isnull(s_estgu) or s_estgu = "" then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('sestgu')
	dw_1.SetFocus()
	return
end if	

if isnull(sIpdpt) or sIpdpt = "" then sIpdpt = ''

//if isnull(sIpdpt) or sIpdpt = "" then
//	f_message_chk(30,'[�԰���â��]')
//	dw_1.Setcolumn('ipdpt')
//	dw_1.SetFocus()
//	return
//end if	

///////////////////////////////////////////////////////////////////////////////////
// ���Ű���� ������ '�Ƿ�'����/������°� �Ϸᰡ �ƴ� ������ ��ȸ�Ͽ� ���ڰ��� ���¸� update�Ѵ�
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
		// ������ �ݷ��� ��� ��ҷ� ���� ����
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
	
if isCnvgu = 'Y' then // ���ִ��� ����
	if s_estgu = 'Y' or s_estgu = 'O' then
		dw_insert.dataobject = 'd_imt_02020_3_1'
		p_search.enabled = False
	else
		dw_insert.dataobject = 'd_imt_02020_1_1'
		p_search.enabled = true
	end if
Else						// ���ִ��� ������
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
string s_daytime, s_empno, s_baljugu, sBaldate, sOpt, sDate /*�������� */, sBlynd 
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
		dw_insert.SetItem(i, 'yebi2', '4')			// ���ڰ��� ���� ���� ���
	Else
		dw_insert.SetItem(i, 'yebi2', '0')			// ���ڰ��� ���� �� ���
	End If
	
	IF wf_required_chk(i) = -1 THEN RETURN	
NEXT
///////////////////////////////////////////////////////////////////////////////////////////

//IF dw_1.getitemstring(1, 'autcrt') = 'N' then
//	if Messagebox('Ȯ ��','����� �������ð� YES �̸� ���� Ȯ���˴ϴ�.'  + &
//	                      '���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 
//ELSE
//	if Messagebox('Ȯ ��','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 
//END IF

if Messagebox('Ȯ ��','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS') //�������ýð�
s_empno = dw_insert.getitemstring(1, 'sempno')  //���Ŵ����

sDate   = dw_1.getitemstring(1, 'baldate')      //��������
if sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

FOR k=1 TO lCount
    s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
    if s_baljugu = 'Y' then
       dw_insert.setitem(k, "baljutime", s_daytime)
		 lAdd++
	 end if
NEXT

IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF (sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("Ȯ ��", "������ ���ֹ�ȣ�� �Է��ϼ���!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

//// ���ְ��� ���ڰ��� ������
//IF is_gwgbn = 'Y' then
//	wf_create_gwdoc()
//End If

// ���ְ��� ����
if dw_insert.update() = 1 then
	
	IF lAdd > 0 then 
      sopt = dw_1.getitemstring(1, "opt")  //���ֻ����� option
		
//		if sopt = '2' then //����(�������)
//			iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
//		else //'1'�̸� ����(�Ƿ�1�ǿ� ���� 1��)
//			iRtnValue = sqlca.erp000000081(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
//		end if
   ELSE
		iRtnValue = 1
	END IF
	
	IF iRtnValue = 1 THEN
		w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
		commit ;
	ELSE
		ROLLBACK;
		f_message_chk(41, STRING(iRtnValue) )
		Return
	END IF
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
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
string text = "�߰�(&A)"
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
string text = "�ŷ�ó���"
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
string text = "���ּ���"
end type





type gb_10 from w_inherite`gb_10 within w_imt_02020
integer x = 5
integer y = 2740
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
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
ELSEIF this.GetColumnName() ="itgu" THEN   //�������±���
	s_estgu = this.gettext()
 
   IF s_estgu = "" OR IsNull(s_estgu) THEN RETURN
	
	s_name = f_get_reffer('28', s_estgu)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[�������±���]')
		this.SetItem(1,'itgu', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() ="frdate" THEN  //�Ƿ����� FROM
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[�Ƿ�����]')
		this.SetItem(1,"frdate",snull)
		this.Setcolumn("frdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="todate" THEN  //�Ƿ����� TO
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[�Ƿ�����]')
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
		f_message_chk(35,'[��������]')
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
	MESSAGEBOX("�ڷ�ó���� �����߻�", sMsg) */

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
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[�Ʒ� �ڷḦ DOUBLE CLICK�� �Ƿ��ڷḦ ����]"
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
string facename = "����ü"
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
//	MessageBox("Ȯ ��", "��ϵ� ���ֹ�ȣ�Դϴ�. ������ ���ֹ�ȣ�� Ȯ���ϼ���!")
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
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "*������ ���ֹ�ȣ "
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
string picturename = "C:\erpman\image\������_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_1.AcceptText() <> 1 Then Return

// ���ְ��� ���ڰ��� ������
IF is_gwgbn = 'Y' then
	wf_create_gwdoc()
	
	// ���ְ��� ����
	if dw_insert.update() = 1 then	
		w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
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
//	Messagebox('Ȯ��', '���ֻ��¸� Ȯ���Ͻÿ�.~n���ֻ��� : �Ƿ�, ����') 
//	Return 
//end if 
//
////�ϰ�����ó��
//For ll_i = 1 to dw_insert.rowcount() 
//	if dw_insert.object.blynd[ll_i] = '1' and dw_insert.object.chk[ll_i] = 'Y' then 
// 		if messagebox('Ȯ��', '���� ���� ���� ������ �����մϴ�.~n���� ���� ���� ������ ����ó�� �Ͻðڽ��ϱ�?', exclamation!, okcancel!, 2) = 2 then return
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
////����
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
////���
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
//	messagebox('Ȯ��', '������ �� ������ ���� ���� �ʽ��ϴ�. ���ֻ��� ������ Ȯ���Ͻÿ�') 
//	return 
//End if 
	
//��ǥ��ȣ
//sEstno = " "
//For ll_i = 1 to dw_insert.rowcount() 
//	 if dw_insert.object.blynd[ll_i] = '2' and dw_insert.object.chk[ll_i] = 'Y' then 
//	 	sEstno = sEstno + "" + dw_insert.object.estno[ll_i] + ","
//	 end if 
//Next 
//sEstno = mid(sEstno, 1, len(sEstno) - 1 ) 


//ls_status  = dw_1.GetItemString(1, 'estgu')

//gs_code  = "%26SABU=1%26ESTNO="+ sEstNo + "%26ESTGU=" + ls_status		//���ֹ�ȣ
//gs_code  = "%26SABU=1%26ESTNO="+ sEstNo  //���ֹ�ȣ
//gs_gubun = '00049'										//�׷���� ������ȣ
//gs_codename = '���Ź��ְ���(����ں�)'									//�����Է¹���
//
//lcount = dw_insert.rowcount()


// ����ǰ�ǿ� ���� ���ڰ��� �������
//sYebi = dw_insert.GetItemString(1, 'yebi2')
//If IsNull(sYebi) Then sYebi = '0'
//
//If ls_chk = 'Y' Then
//	// �׷���� ������ȣ
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

