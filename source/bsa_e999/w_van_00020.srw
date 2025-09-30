$PBExportHeader$w_van_00020.srw
$PBExportComments$�˼��ڷ� ���- VAN
forward
global type w_van_00020 from w_inherite
end type
type dw_ip from u_key_enter within w_van_00020
end type
type dw_chulgo from u_key_enter within w_van_00020
end type
type dw_imhist from datawindow within w_van_00020
end type
type st_msg from statictext within w_van_00020
end type
type lb_1 from listbox within w_van_00020
end type
type cb_1 from commandbutton within w_van_00020
end type
type gb_2 from groupbox within w_van_00020
end type
type gb_3 from groupbox within w_van_00020
end type
type gb_4 from groupbox within w_van_00020
end type
type gb_5 from groupbox within w_van_00020
end type
type rr_1 from roundrectangle within w_van_00020
end type
end forward

global type w_van_00020 from w_inherite
string title = " ��ǰ�˼� ���"
dw_ip dw_ip
dw_chulgo dw_chulgo
dw_imhist dw_imhist
st_msg st_msg
lb_1 lb_1
cb_1 cb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
rr_1 rr_1
end type
global w_van_00020 w_van_00020

type variables
Boolean ib_update = true
end variables

forward prototypes
public function decimal wf_num (string arg_num)
public function integer wf_create_imhist (long nrow, string siojpno, decimal dioqty, string gdate, string lcgb, decimal dvatamt)
public function integer wf_chk (integer nrow)
end prototypes

public function decimal wf_num (string arg_num);Dec dNum
String sChk

Choose Case Right(arg_num,1)
	Case '{'
		sChk = '0'
	Case 'A'
		sChk = '1'
	Case 'B'
		sChk = '2'
	Case 'C'
		sChk = '3'
	Case 'D'
		sChk = '4'
	Case 'E'
		sChk = '5'
	Case 'F'
		sChk = '6'
	Case 'G'
		sChk = '7'
	Case 'H'
		sChk = '8'
	Case 'I'
		sChk = '9'
	Case Else
		sChk = '0'
End Choose

dNum = Dec(Left(arg_num, Len(arg_num) -1) + sChk)

Return dNum
end function

public function integer wf_create_imhist (long nrow, string siojpno, decimal dioqty, string gdate, string lcgb, decimal dvatamt);String soldiojpno
Long 	 iCurRow

soldiojpno = dw_chulgo.GetItemString(nRow, 'iojpno')
If IsNull(sOldIojpNo) Then Return -1

iCurRow = dw_imhist.InsertRow(0)

dw_imhist.SetItem(iCurRow, "SABU", 		dw_chulgo.GetItemString(nRow, "SABU"))
dw_imhist.SetItem(iCurRow, "IOGBN", 	dw_chulgo.GetItemString(nRow, "IOGBN"))
dw_imhist.SetItem(iCurRow, "SUDAT", 	dw_chulgo.GetItemString(nRow, "SUDAT"))
dw_imhist.SetItem(iCurRow, "ITNBR", 	dw_chulgo.GetItemString(nRow, "ITNBR"))
dw_imhist.SetItem(iCurRow, "PSPEC", 	dw_chulgo.GetItemString(nRow, "PSPEC"))
dw_imhist.SetItem(iCurRow, "OPSEQ", 	dw_chulgo.GetItemString(nRow, "OPSEQ"))
dw_imhist.SetItem(iCurRow, "DEPOT_NO", dw_chulgo.GetItemString(nRow, "DEPOT_NO"))
dw_imhist.SetItem(iCurRow, "CVCOD", 	dw_chulgo.GetItemString(nRow, "CVCOD"))
dw_imhist.SetItem(iCurRow, "SAREA", 	dw_chulgo.GetItemString(nRow, "SAREA"))
dw_imhist.SetItem(iCurRow, "PDTGU", 	dw_chulgo.GetItemString(nRow, "PDTGU"))
dw_imhist.SetItem(iCurRow, "CUST_NO",  dw_chulgo.GetItemString(nRow, "CUST_NO"))
dw_imhist.SetItem(iCurRow, "IOPRC"	,  dw_chulgo.GetItemNumber(nRow, "IOPRC"))
dw_imhist.SetItem(iCurRow, "INSDAT"	,  dw_chulgo.GetItemString(nRow, "INSDAT"))
dw_imhist.SetItem(iCurRow, "INSEMP"	,  dw_chulgo.GetItemString(nRow, "INSEMP"))
dw_imhist.SetItem(iCurRow, "QCGUB"	,  dw_chulgo.GetItemString(nRow, "QCGUB"))
dw_imhist.SetItem(iCurRow, "IOFAQTY",  dw_chulgo.GetItemNumber(nRow, "IOFAQTY"))
dw_imhist.SetItem(iCurRow, "IOPEQTY",  dw_chulgo.GetItemNumber(nRow, "IOPEQTY"))
dw_imhist.SetItem(iCurRow, "IOSPQTY",  dw_chulgo.GetItemNumber(nRow, "IOSPQTY"))
dw_imhist.SetItem(iCurRow, "IOCDQTY",  dw_chulgo.GetItemNumber(nRow, "IOCDQTY"))
dw_imhist.SetItem(iCurRow, "IO_CONFIRM", dw_chulgo.GetItemString(nRow, "IO_CONFIRM"))
dw_imhist.SetItem(iCurRow, "IO_DATE", 	  dw_chulgo.GetItemString(nRow, "IO_DATE"))
dw_imhist.SetItem(iCurRow, "IO_EMPNO",   dw_chulgo.GetItemString(nRow, "IO_EMPNO"))
dw_imhist.SetItem(iCurRow, "LOTSNO"	, 	  dw_chulgo.GetItemString(nRow, "LOTSNO"))
dw_imhist.SetItem(iCurRow, "LOTENO"	, 	  dw_chulgo.GetItemString(nRow, "LOTENO"))
dw_imhist.SetItem(iCurRow, "HOLD_NO", 	  dw_chulgo.GetItemString(nRow, "HOLD_NO"))
dw_imhist.SetItem(iCurRow, "ORDER_NO",   dw_chulgo.GetItemString(nRow, "ORDER_NO"))
dw_imhist.SetItem(iCurRow, "INV_NO",	  dw_chulgo.GetItemString(nRow, "INV_NO"))   
dw_imhist.SetItem(iCurRow, "INV_SEQ", 	  dw_chulgo.GetItemNumber(nRow, "INV_SEQ"))
dw_imhist.SetItem(iCurRow, "FILSK", 	  dw_chulgo.GetItemString(nRow, "FILSK"))
dw_imhist.SetItem(iCurRow, "BIGO", 		  dw_chulgo.GetItemString(nRow, "BIGO"))
dw_imhist.SetItem(iCurRow, "BOTIMH",	  dw_chulgo.GetItemString(nRow, "BOTIMH"))
dw_imhist.SetItem(iCurRow, "IP_JPNO",	  dw_chulgo.GetItemString(nRow, "IP_JPNO"))
dw_imhist.SetItem(iCurRow, "ITGU",		  dw_chulgo.GetItemString(nRow, "ITGU"))
dw_imhist.SetItem(iCurRow, "INPCNF",	  dw_chulgo.GetItemString(nRow, "INPCNF"))
dw_imhist.SetItem(iCurRow, "JNPCRT",	  dw_chulgo.GetItemString(nRow, "JNPCRT"))
dw_imhist.SetItem(iCurRow, "OUTCHK",	  dw_chulgo.GetItemString(nRow, "OUTCHK"))
dw_imhist.SetItem(iCurRow, "MAYYSQ",	  dw_chulgo.GetItemNumber(nRow, "MAYYSQ"))
dw_imhist.SetItem(iCurRow, "IOREDEPT",   dw_chulgo.GetItemString(nRow, "IOREDEPT"))
dw_imhist.SetItem(iCurRow, "IOREEMP",	  dw_chulgo.GetItemString(nRow, "IOREEMP"))
dw_imhist.SetItem(iCurRow, "DCRATE",	  dw_chulgo.GetItemNumber(nRow, "DCRATE"))
dw_imhist.SetItem(iCurRow, "CHECKNO", 	  dw_chulgo.GetItemString(nRow, "CHECKNO"))   
dw_imhist.SetItem(iCurRow, "PJT_CD", 	  dw_chulgo.GetItemString(nRow, "PJT_CD"))
dw_imhist.SetItem(iCurRow, "SAUPJ", 	  dw_chulgo.GetItemString(nRow, "SAUPJ" ))

/* ���ҳ��� */
dw_imhist.SetItem(iCurRow, "IOJPNO",	sIojpno)	/* ��ǥ��ȣ */
dw_imhist.SetItem(iCurRow, "IOQTY"	,  dioqty)	/* ���Ҽ��� */
dw_imhist.SetItem(iCurRow, "IOAMT"	,  Truncate(dw_chulgo.GetItemNumber(nRow, "IOPRC") * dIoQty,0))
dw_imhist.SetItem(iCurRow, "IOREQTY",  dioqty)
dw_imhist.SetItem(iCurRow, "IOSUQTY" , dIoQty)
dw_imhist.SetItem(iCurRow, "CRT_USER", gs_userid) 
dw_imhist.SetItem(iCurRow, "YEBI1", 	gdate)	/* �˼����� */
dw_imhist.SetItem(iCurRow, "AREA_CD", 	lcgb)	

dw_imhist.SetItem(iCurRow, "DYEBI3", 	dVatAmt)	/* �ΰ��� */
				
Return 1
end function

public function integer wf_chk (integer nrow);Long nSel, nCnt
String sNull, sDate, sChk
Dec	 dvQty, dOqty

SetNull(sNull)

nSel = dw_insert.GetSelectedRow(0)
If nSel <= 0 Then Return -1

If dw_ip.GetItemString(1, 'crtgu') <> '3' Then Return -1

sChk = dw_ip.GetItemString(1, 'chk')	// ����ó��

// �˼�����
sDate = Trim(dw_insert.GetItemString(nSel, 'gumdate'))
If f_datechk(sdate) <> 1 Then Return -1

// ����ó�� �� ���
If sChk = 'Y' Then
	// �˼����� 
	dvQty = dw_insert.GetItemNumber(nSel, 'vqty')
	//dvQty = dw_insert.GetItemNumber(nSel, 'sum_vqty')
	If IsNull(dvQty) Then dvQty = 0
	
	// ������ 
	dOqty = dw_chulgo.GetItemNumber(1, 'sum_ioqty')
	If IsNull(dOqty) Then dOqty = 0
	
	If dvqty < doqty then
		MessagebOX('Ȯ ��', '�˼��������� �������� �����ϴ�.!!')
		dw_chulgo.SetItem(nRow, 'chk', 'N')
		return -1
	End If
	
	dw_insert.SetItem(nSel, 'oqty', dOqty)
End If

nCnt = dw_chulgo.GetItemNumber(1, 'sum_chk')
If IsNull(nCnt) Then nCnt = 0

If nCnt > 0 Then
	If IsNull(sDate) Or sdate = '' Then
		dw_insert.SetItem(nSel, 'cnfirm', 'N')
		dw_insert.SetItem(nSel, 'bigo',   '�˼����� ����')
		
	Else
		// ����ó�� �� ���
		If sChk = 'Y' Then
			If dvqty = doqty Then
				dw_insert.SetItem(nSel, 'cnfirm', 'Y')
				dw_insert.SetItem(nSel, 'bigo',   '�˼��Ϸ�')
			Else
				dw_insert.SetItem(nSel, 'cnfirm', 'N')
				dw_insert.SetItem(nSel, 'bigo',   '���Ұ˼�')
				
			End If
			
		Else
			dw_insert.SetItem(nSel, 'cnfirm', 'Y')
			dw_insert.SetItem(nSel, 'bigo',   '�˼��Ϸ�')
		End If
		
		ib_update = false
	End If
Else
	dw_insert.SetItem(nSel, 'cnfirm', 'N')
	dw_insert.SetItem(nSel, 'bigo',   dw_insert.GetItemString(nSel, 'bigo', Primary!, True))
	
	ib_update = true
End If

// ����ڷ� ERP Ȯ��
If dw_chulgo.GetItemString(nRow, 'chk') = 'Y' Then
	If IsNull(sDate) Or sdate = '' Then
		dw_chulgo.SetItem(nRow, 'yebi1',   sNull)
		dw_chulgo.SetItem(nRow, 'area_cd', sNull)
		dw_chulgo.SetItem(nRow, 'loteno', dw_chulgo.GetItemString(nRow, 'loteno', Primary!, True))
	Else
		dw_chulgo.SetItem(nRow, 'yebi1',   sDate)
		dw_chulgo.SetItem(nRow, 'area_cd', dw_insert.GetItemString(nSel, 'localyn'))
		dw_chulgo.SetItem(nRow, 'loteno', dw_insert.GetItemString(nSel, 'baljuno'))
	End If
Else
	dw_chulgo.SetItem(nRow, 'yebi1',   sNull)
	dw_chulgo.SetItem(nRow, 'area_cd', sNull)
	dw_chulgo.SetItem(nRow, 'loteno', dw_chulgo.GetItemString(nRow, 'loteno', Primary!, True))
End If

Return 0
end function

on w_van_00020.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_chulgo=create dw_chulgo
this.dw_imhist=create dw_imhist
this.st_msg=create st_msg
this.lb_1=create lb_1
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_chulgo
this.Control[iCurrent+3]=this.dw_imhist
this.Control[iCurrent+4]=this.st_msg
this.Control[iCurrent+5]=this.lb_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_4
this.Control[iCurrent+10]=this.gb_5
this.Control[iCurrent+11]=this.rr_1
end on

on w_van_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_chulgo)
destroy(this.dw_imhist)
destroy(this.st_msg)
destroy(this.lb_1)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_chulgo.SetTransObject(sqlca)
dw_imhist.SetTransObject(sqlca)

dw_ip.InsertRow(0)

String sDate
select to_char(sysdate - 5,'yyyymmdd') into :sdate from dual;

dw_ip.SetItem(1, 'order_date', sDate)
dw_ip.SetItem(1, 'end_date', is_today)
end event

type dw_insert from w_inherite`dw_insert within w_van_00020
integer x = 59
integer y = 368
integer width = 4434
integer height = 1216
string dataobject = "d_van_00020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;String sBalNo, sPlnt, sDate, sSeq, sCvcod

If Row <= 0 Then 
	selectrow(row, false)
	Return
End If

// �˼��̿Ϸ�
If dw_ip.GetItemString(1, 'crtgu') = '3' Then
	sBalNo = Trim(GetItemString(Row,'partno'))
	sPlnt  = Trim(GetItemString(Row,'plnt'))
	sDate  = Trim(GetItemString(Row,'gumdate'))
	sCvcod  = Trim(GetItemString(Row,'rfna2'))
	If IsNull(sDate) Or sDate = '' Then sDate = '99999999'
	
	If ib_update = false Then
		MessageBox('Ȯ��','����� ������ �ֽ��ϴ�.!!')
		Return 1
	End If
	
	dw_chulgo.Retrieve(gs_sabu, sBalNo, sCvcod, sDate)
Else
	sBalNo = Trim(GetItemString(Row,'baljuno'))
	sSeq = Trim(dw_insert.GetItemString(Row, 'regseq'))
	If IsNull(sSeq) Or sSeq = '' Then sSeq = '0000'
	
	dw_chulgo.Retrieve(gs_sabu, sBalNo, sSeq)
End If

selectrow(0, false)
selectrow(row, true)
end event

type p_delrow from w_inherite`p_delrow within w_van_00020
integer x = 3918
end type

event p_delrow::clicked;call super::clicked;Long   iRowCount,k,iImhistRow,iAryCnt, nCnt, dInvQty
String sHoldNo,sSelectedOrder[], sIoJpNo, sIpno, sOutNo
String sSaupj

sle_msg.text =""

If dw_chulgo.Rowcount() <= 0 Then Return -1

//iRowCount = dw_chulgo.GetItemNumber(1,"yescount")
//IF iRowCount <=0 THEN
//	f_message_chk(36,'')
//	Return -1
//END IF

/* ����� üũ */
//sSaupj= Trim(dw_cond.GetItemString(1, 'saupj'))
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400, '[�����]')
//	dw_cond.SetFocus()
//	dw_cond.SetColumn('saupj')
//	Return -1
//End If

IF MessageBox("Ȯ ��","��� ��� ó���� �Ͻðڽ��ϱ�?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

iAryCnt = 1


iImhistRow = dw_chulgo.RowCount()
For k = iImhistRow TO 1 STEP -1
	IF dw_chulgo.GetItemString(k,"del") = 'Y' THEN
		
		SetNull(sIpNo)
		SetNull(sOutNo)
		
		/* ������ ��ǥ��ȣ */
		sIoJpNo = Trim(dw_chulgo.GetItemString(k,'iojpno'))
				
		// Ÿ���� ��ǥ ����
		DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If

		/* �Ҵ��ȣ�� ���� ��� �̵��԰�->�̵���� ��ǥ�� ã�´� */
		sHoldNo = Trim(dw_chulgo.GetItemString(k,"pjt_cd"))

		/* �������� ��� out_chk = '2' */
		select count( distinct substr(iojpno,1,12) ) into :dInvQty
		  from imhist
		 where sabu = :gs_sabu and
				 pjt_cd = :sHoldNo;
		If IsNull(dInvQty) Or dInvQty <= 0 Then 
			ROLLBACK;
			f_message_chk(32,'[����� ������ �����ϴ�]'+string(dinvqty))
			Return -1
		End If
			
		/* �Ҵ�->���� ���ҿ��ο� ���� */
		If dInvQty = 1 Then
			/* �������� '���'���� */
			UPDATE "MWAPI_ERP"
				SET "OUT_CHK" = '3'
			 WHERE ( "MWAPI_ERP"."SAUPJ" = :sSaupj ) AND ( "MWAPI_ERP"."HOLD_NO" = :sHoldNo );
		ElseIf dInvQty > 1 Then
			/* �������� '���������'���� */
			UPDATE "MWAPI_ERP"
				SET "OUT_CHK" = '2'
			 WHERE ( "MWAPI_ERP"."SAUPJ" = :gs_sabu ) AND ( "MWAPI_ERP"."HOLD_NO" = :sHoldNo );
		End If
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(32,'[������� ����]')
			ROLLBACK;
			Return -1
		ELSE
			dw_chulgo.DeleteRow(k)
		END IF
	END IF
Next

IF dw_chulgo.Update() <> 1 THEN											/*����� ����*/
	ROLLBACK;
	Return -1
END IF

COMMIT;

Return 1
end event

type p_addrow from w_inherite`p_addrow within w_van_00020
integer x = 3474
integer y = 172
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\�ϰ�����_up.gif"
end type

event p_addrow::ue_lbuttondown;//PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event p_addrow::ue_lbuttonup;//PictureName = "C:\erpman\image\���߰�_up.gif"
end event

event p_addrow::clicked;call super::clicked;sle_msg.text =""

IF MessageBox("Ȯ ��","VAN DATA �ϰ� ������ �Ͻðڽ��ϱ�?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

DELETE FROM "VAN_GUMSU"
 WHERE "VAN_GUMSU"."CNFIRM" = 'N' ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return -1
End If

COMMIT;

MessageBox('Ȯ  ��','VAN DATA �ϰ� ���� �Ϸ�!!')
p_inq.triggerevent(clicked!)
end event

type p_search from w_inherite`p_search within w_van_00020
integer x = 3296
string picturename = "C:\erpman\image\�ڷ����_up.gif"
end type

event p_search::clicked;call super::clicked;String sVndgu, docname, named, sLine, sOrderDate, senddate, sCvcod
string sPartNo, sItnbr, sPartNm, sSeq
integer li_FileNum, nRow, iSeqNo
integer value
Long    iMaxregno, ix
Dec     dVqty, dVprc, dVamt

If dw_ip.AcceptText() <> 1 Then Return

sOrderDate   = Trim(dw_ip.GetItemString(1, 'order_date'))
If IsNull(sOrderDate) Or sOrderDate = '' Then
	f_message_chk(1400, '[�˼�����FROM]')
	Return
End If

senddate   = Trim(dw_ip.GetItemString(1, 'end_date'))
If IsNull(senddate) Or senddate = '' Then
	f_message_chk(1400, '[�˼�����TO]')
	Return
End If


lb_1.DirList("C:\ERPMAN\GMDAT\*D1.TXT", 0)

For ix = 1 To lb_1.TotalItems()
	docname = 'c:\hkc\van\' + lb_1.text(ix)
	li_FileNum = FileOpen(docname)
	
	If dw_insert.RowCount() > 0 Then
		iMaxregno = dw_insert.GetItemNumber(1, 'max_regno')
		If IsNull(iMaxregno) Then iMaxregno = 0
	Else
		iMaxregno = 0
	End If
	
	DO WHILE FileRead(li_FileNum, sLine) > 0
		If Mid(sLine,1,2) <> 'D1' Then Return
		If Mid(sLine,34,8) < sOrderDate Then Continue	// �˼��Ⱓ �� �ڷḸ ���� - 2004.05.07 - ���ȣ
		If Mid(sLine,34,8) > senddate Then Continue
		
		nRow = dw_insert.InsertRow(0)
		
		st_msg.text = String(nrow)
		
		sPartNo = Trim(Mid(sLine,19,15))
		If IsNumber(Left(sPartNo,1)) Then
			sPartNo = Left(sPartNo,5) + '-' + Mid(sPartNo,6)
		End If
		
		dVqty = wf_num(Mid(sLine,56,7))
		dVamt = wf_num(Mid(sLine,63,11))
		If dvqty <> 0 Then
			dVprc = Round(dvamt / dvqty,2)
		Else
			dvprc = 0
		End If
		
		dw_insert.SetItem(nRow, "vqty",  	dvqty	)
		dw_insert.SetItem(nRow, "vprc",  	dvprc	)
		dw_insert.SetItem(nRow, "vamt", 		dvamt	)
		dw_insert.SetItem(nRow, "baljuno",  Mid(sLine,101,11))
		
		// Q���� ����
		sSeq = Trim(Mid(sLine,42,4))
		If IsNull(sSeq) Or sSeq = '' Then sSeq = '0000'
		
		dw_insert.SetItem(nRow, "regseq", sSeq  )
		dw_insert.SetItem(nRow, "localyn",  Mid(sLine,46,1))
		dw_insert.SetItem(nRow, "vtype",	   Mid(sLine,47,2))
		dw_insert.SetItem(nRow, "doccode",  Mid(sLine,1,12))
		dw_insert.SetItem(nRow, "gumdate",  Mid(sLine,34,8))		// �˼�����
		dw_insert.SetItem(nRow, "plnt",  	Trim(Mid(sLine,17,2)))
		
		dw_insert.SetItem(nRow, 'vndgu',   '1')
		dw_insert.SetItem(nRow, 'regdate', senddate)
		iMaxregno += 1 
		dw_insert.SetItem(nRow, 'regno',   iMaxregno)
			
		/* �系ǰ�� Ȯ�� */
		dw_insert.SetItem(nRow, "PARTNO",	sPartNo)
		
		dw_insert.SetItem(nRow, "CVCOD", 	sCvcod)
	
		dw_insert.SetItem(nRow, "CNFIRM",	'N')		// ó������ = 'N'
		dw_insert.SetItem(nRow, "oqty",		0)	// 
	LOOP
	
	FileClose(li_FileNum)
Next

dw_insert.SetSort('baljuno')
dw_insert.Sort()

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڷ����_up.gif"
end event

type p_ins from w_inherite`p_ins within w_van_00020
integer x = 3474
string picturename = "C:\erpman\image\�ϰ�Ȯ��_up.gif"
end type

event p_ins::clicked;/* ���� ó�� */
Long ix, iy, iCurRow=0,iMaxIoNo, nCnt
String sBalNo, sDate, sChDate, sNull, LsIoJpNo, sErrMsg, sIoJpno, sCnFirm, sLocalYn, sTemp, sSeq
Dec{3} dIoqty, dChoiceQty, dIoPrc
Dec{2} dVatAmt, dNewVatAmt
boolean lb_found
long sRow, eRow

setNull(sNull)

If dw_ip.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

// ���º���
dw_ip.SetItem(1, 'crtgu', '1')
dw_insert.SetFilter("")
dw_chulgo.DataObject = 'd_van_00020_3'
dw_chulgo.SetTransObject(sqlca)

dw_chulgo.Reset()
dw_imhist.Reset()

Setpointer(HourGlass!)

dw_insert.SetFilter("cnfirm = 'N'")
dw_insert.Filter()

dw_insert.SetSort('baljuno, regseq')
dw_insert.Sort()
dw_insert.GroupCalc()

/*�����ȣ ä��*/
iMaxIoNo = sqlca.fun_junpyo(gs_sabu, is_today, 'C0')
IF iMaxIoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF

COMMIT;

LsIoJpNo = is_today + String(iMaxIoNo,'0000')

/* ���� ���ֹ�ȣ ������ ó�� */
dw_chulgo.SetRedraw(False)
DO WHILE NOT (lb_found)
	sRow = dw_insert.FindGroupChange(sRow, 1)

	IF sRow <= 0 THEN EXIT

	eRow = dw_insert.FindGroupChange(sRow+1, 1) - 1
	If eRow <= 0 Then eRow = dw_insert.RowCount()
	
	/* �������ڴ� �˼����� */
	sDate   = Trim(dw_insert.GetItemString(sRow, 'gumdate'))
	
	/* �������� üũ */
	sErrMsg = ''

	/* ���ֹ�ȣ�� ������� ��ȸ , ���ֹ�ȣ, ������� ��ȸ�Ͽ� ������ skip */
	sBalNo = Trim(dw_insert.GetItemString(sRow, 'baljuno'))
	If IsNull(sBalNo) Or sBalNo = '' Then
		sRow = sRow + 1
		Continue
	End If

	sSeq = Trim(dw_insert.GetItemString(sRow, 'regseq'))
	If IsNull(sSeq) Or sSeq = '' Then sSeq = '0000'
	
	sCnFirm = 'N'
	
	If dw_chulgo.Retrieve(gs_sabu, sBalNo, sSeq) <= 0 Then
		sErrMsg = '���������'
	Else
		nCnt = dw_chulgo.RowCount()
		For ix = nCnt To 1 Step -1
			sTemp = Trim(dw_chulgo.GetItemString(ix, 'yebi1'))
			If Not IsNull(sTemp) And sTemp > '' Then
				sCnFirm = 'Y'
				sErrMsg = '�� ����Ϸ�'
				dw_chulgo.RowsDiscard(ix, ix, Primary!)
				
				continue
			End If
			
			sTemp = Trim(dw_chulgo.GetItemString(ix, 'io_date'))
			If IsNull(sTemp) Or sTemp = '' Then
				sErrMsg = '������ڷ�'
				dw_chulgo.RowsDiscard(ix, ix, Primary!)
				
				continue
			End If
		Next
	End If

	/* ǰ��, ����, �ݾ� �� ������ ��츸 �������� ó�� */
	If dw_chulgo.RowCount() > 0 Then
		If Trim(dw_insert.GetItemString(srow, 'partno')) <> Trim(dw_chulgo.GetItemString(1, 'itnbr')) Then
			sErrMsg = 'ǰ�� Ʋ��'
		ElseIf dw_insert.GetItemNumber(sRow, 'sum_vqty') <> dw_chulgo.GetItemNumber(1, 'sum_ioqty') Then
			sErrMsg = '���� Ʋ��'
		ElseIf dw_insert.GetItemNumber(sRow, 'sum_vamt') <> dw_chulgo.GetItemNumber(1, 'sum_ioamt') Then
			sErrMsg = '�ݾ� Ʋ��'
		End If
	End If

	If IsNull(sDate) or sDate = '' THEN
		sErrMsg = '�˼����� ����'
	End If

	If sErrMsg = '' Then
//		If sRow <> eRow and dw_chulgo.RowCount() > 1 Then
//			sErrMsg = '������'
		
		/* ���� �Ѱ��̰� ������ ����(����/local)�� ��� */
		If sRow <> eRow and dw_chulgo.RowCount() = 1 Then			
			sIojpno = dw_chulgo.GetItemString(1, 'iojpno')
			dIoPrc  = dw_chulgo.GetItemNumber(1, 'ioprc')
			For ix = sRow To eRow
				If dw_insert.GetItemString(ix, 'cnfirm') <> 'N' Then Continue
				
				dChoiceQty = dw_insert.GetItemNumber(ix, 'vqty')		/* ���Ҽ��� */
	
				/* Local�ϰ�� �ΰ��� ��� */
				sLocalYn   = dw_insert.GetItemString(ix, 'localyn')
				If sLocalYn = 'L' Then
					sLocalYn = 'LC'
					dNewVatAmt = 0
				Else
					SetNull(sLocalYn)
					dNewVatAmt = 0
//					dNewVatAmt = Truncate(dChoiceQty * dIoPrc,0)
				End If
				
				If ix = sRow Then
					dw_chulgo.SetItem(1, 'yebi1',   sDate)
					dw_chulgo.SetItem(1, 'area_cd', sLocalYn)
					dw_chulgo.SetItem(1, 'dyebi3',  dNewVatAmt)
				Else
					iCurRow += 1
					If wf_create_imhist(1, LsIoJpNo+String(iCurRow,'000'), dChoiceQty, sDate, sLocalYn, dNewVatAmt) <> 1 Then
						RollBack;
						f_message_chk(32,'[������ ����]')
						dw_chulgo.SetRedraw(True)
						Return
					End If
				End If
			Next
	
			/* Van �ڷ� ��� */
			If dw_chulgo.Update() <> 1 Then
				RollBack;
				MessageBox('Ȯ  ��','Van �ڷ� ��Ͻ� ������ �ֽ��ϴ�.!!')
				dw_chulgo.SetRedraw(True)
				Return
			End If

			sCnFirm = 'Y'
			sErrMsg = '����Ϸ�(����)'
		Else
			/* ����ó�� */
			For iy = 1 To dw_chulgo.RowCount()
				sIojpno = dw_chulgo.GetItemString(iy, 'iojpno')
				
				UPDATE IMHIST
					SET YEBI1 = :sDate
				 WHERE SABU = :gs_sabu
					AND IOJPNO = :sIojpno
					AND YEBI1 IS NULL;
				If SQLCA.SQLCODE <> 0 Then
//					MessageBox(sdate, siojpno)
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
					RollBack;
					f_message_chk(57,'')
					dw_chulgo.SetRedraw(True)
					dw_insert.Reset()
					dw_chulgo.Reset()
					Return
				End If
			Next
			
			sCnFirm = 'Y'
			sErrMsg = '����Ϸ�'
		End If
	End If
	
	For ix = sRow To eRow
		/* ��ó�� ������ ó���Ѵ� */
		If dw_insert.GetItemString(ix, 'cnfirm') <> 'N' Then Continue
		
		dw_insert.SetItem(ix, 'cnfirm', sCnFirm)
		dw_insert.SetItem(ix, 'bigo',   sErrMsg)
		dw_insert.SetItem(ix, 'oqty',   dw_insert.GetItemNumber(ix, 'vqty'))	// �Ϸ� ���� ���
	Next
		
	sRow = sRow + 1
Loop

/* Van �ڷ� ��� */
If dw_insert.Update() <> 1 Then
	RollBack;
	MessageBox('Ȯ  ��','Van �ڷ� ��Ͻ� ������ �ֽ��ϴ�.!!')
	dw_chulgo.SetRedraw(True)
	Return
End If


COMMIT;

dw_chulgo.ResetUpdate()
dw_insert.ResetUpdate()
dw_imhist.ResetUpdate()
dw_chulgo.SetRedraw(True)

sle_msg.Text = '�ڷḦ �����Ͽ����ϴ�.!!'
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\�ϰ�Ȯ��_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ϰ�Ȯ��_up.gif"
end event

type p_exit from w_inherite`p_exit within w_van_00020
end type

type p_can from w_inherite`p_can within w_van_00020
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
dw_chulgo.Reset()

ib_any_typing = false

cb_ins.Enabled = False
end event

type p_print from w_inherite`p_print within w_van_00020
boolean visible = false
integer x = 4430
integer y = 192
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ��_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ��_up.gif"
end event

type p_inq from w_inherite`p_inq within w_van_00020
integer x = 3744
end type

event p_inq::clicked;call super::clicked;String sOrderDate, sVndgu, sCvcod, senddate, sCrtgu, sItnbr

If dw_ip.AcceptText() <> 1 Then Return

sCrtgu   = Trim(dw_ip.GetItemString(1, 'crtgu'))

/* �ʼ�Ű üũ */
sOrderDate   = Trim(dw_ip.GetItemString(1, 'order_date'))
If IsNull(sOrderDate) Or sOrderDate = '' Then
	f_message_chk(1400, '[�˼�����]')
	Return
End If

senddate   = Trim(dw_ip.GetItemString(1, 'end_date'))
If IsNull(senddate) Or senddate = '' Then
	f_message_chk(1400, '[�˼�����]')
	Return
End If

sCvcod   = Trim(dw_ip.GetItemString(1, 'cvcod'))
If IsNull(sCvcod) Then sCvcod = ''

If sCrtgu = '3' Then
	sItnbr = Trim(dw_ip.GetItemString(1, 'itnbr'))
	If IsNull(sItnbr) Then sItnbr = ''
Else
	sItnbr = ''
End If

dw_chulgo.Reset()
If dw_insert.Retrieve('1', sOrderDate, senddate, sCvcod+'%', sItnbr+'%') <= 0 Then
	f_message_chk(50, '')
	cb_ins.Enabled = False
	Return
End If

cb_ins.Enabled = True
end event

type p_del from w_inherite`p_del within w_van_00020
boolean visible = false
integer x = 3982
integer y = 168
end type

type p_mod from w_inherite`p_mod within w_van_00020
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String sOrderDate, sVndgu, sItnbr, sDepotNo
Long   ix

If dw_ip.AcceptText() <> 1 Then Return

sOrderDate   = Trim(dw_ip.GetItemString(1, 'order_date'))
If IsNull(sOrderDate) Or sOrderDate = '' Then
	f_message_chk(1400, '[�������]')
	Return
End If

If dw_insert.Update() <> 1 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	MessageBox('Ȯ  ��','�ߺ��� �ڷᰡ �����մϴ�.!!')
	cb_ins.Enabled = False
	Return
End If

If dw_ip.GetItemString(1, 'crtgu') = '3' Then
	If dw_chulgo.Update() <> 1 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		MessageBox('Ȯ  ��','�˼�Ȯ�ν� ���� �߻�.!!')
		cb_ins.Enabled = False
		Return
	End If
End If

COMMIT;
ib_update = true

cb_ins.Enabled = True

sle_msg.Text = '����Ǿ����ϴ�.!!'
end event

type cb_exit from w_inherite`cb_exit within w_van_00020
integer x = 3182
integer y = 1924
end type

type cb_mod from w_inherite`cb_mod within w_van_00020
integer x = 2487
integer y = 1924
end type

type cb_ins from w_inherite`cb_ins within w_van_00020
integer x = 1413
integer y = 1924
boolean enabled = false
string text = "����(&I)"
end type

type cb_del from w_inherite`cb_del within w_van_00020
integer x = 933
integer y = 1924
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_van_00020
integer x = 549
integer y = 1924
end type

type cb_print from w_inherite`cb_print within w_van_00020
integer x = 997
integer y = 1924
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_van_00020
end type

type cb_can from w_inherite`cb_can within w_van_00020
integer x = 2834
integer y = 1924
end type

type cb_search from w_inherite`cb_search within w_van_00020
integer x = 105
integer y = 1924
integer width = 421
string text = "VAN��ȸ(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_van_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_van_00020
end type

type dw_ip from u_key_enter within w_van_00020
integer x = 50
integer y = 64
integer width = 3177
integer height = 184
integer taborder = 10
string dataobject = "d_van_00020_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String  sOrderDate,snull, scvcod, scvnas, sarea, steam, sSaupj, sname1, sitnbr, sitdsc, sispec, sjijil, sispec_code
Int     ireturn

SetNull(snull)

Choose Case GetColumnName() 
	Case "order_date", "end_date"
		sOrderDate = Trim(this.GetText())
		IF sOrderDate ="" OR IsNull(sOrderDate) THEN 
			f_message_chk(35,'[�˼�����]')
			SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[�˼�����]')
			SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
	Case "vndgu"
		cb_inq.PostEvent(Clicked!)
//	Case 'cvcod'
//		sCvcod = Trim(GetText())
//		
//		IF sCvcod ="" OR IsNull(sCvcod) THEN
//			dw_insert.SetFilter("")
//		Else
//			dw_insert.SetFilter("rfna2 = '" + sCvcod + "'")
//		End If
//		dw_insert.Filter()
//	/* �ŷ�ó */
//	Case "cvcod"
//		sCvcod = Trim(GetText())
//		IF sCvcod ="" OR IsNull(sCvcod) THEN
//			SetItem(1,"cvnas",snull)
//			Return
//		END IF
//
//		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
//			SetItem(1, 'cvcod', sNull)
//			SetItem(1, 'cvnas', snull)
//			Return 1
//		ELSE		
//			SetItem(1,"cvnas",	scvnas)
//		END IF
	Case 'crtgu'
		Choose Case GetText()
			Case '1'
				dw_insert.SetFilter("")
				dw_chulgo.DataObject = 'd_van_00020_3'
			Case '2'
				dw_insert.SetFilter("cnfirm = 'Y'")
				dw_chulgo.DataObject = 'd_van_00020_3'
			Case '3'
				dw_insert.SetFilter("cnfirm = 'N'")
				dw_chulgo.DataObject = 'd_van_00020_4'
		End Choose
		dw_insert.SetSort('plnt,partno,gumdate,baljuno')
		dw_insert.Sort()
		
		dw_insert.Filter()
		
		dw_chulgo.SetTransObject(sqlca)
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
	
		RETURN ireturn
END Choose
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)
//
Choose Case this.GetColumnName() 
//	/* �ŷ�ó */
//	Case "cvcod", "cvnas"
//		gs_gubun = '1'
//		If GetColumnName() = "cvnas" then
//			gs_codename = Trim(GetText())
//		End If
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		SetItem(1,"cvcod",gs_code)
//		SetItem(1,"cvnas",gs_codename)
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"itnbr",gs_code)
		this.SetItem(1,"itdsc",gs_codename)
		
		Return 1
END Choose
end event

type dw_chulgo from u_key_enter within w_van_00020
integer x = 59
integer y = 1700
integer width = 4434
integer height = 520
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_van_00020_3"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;long ix, nRow, nSel, nCnt
String sStatus, sDate, sNull
Double	dQty, dOldQty

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* �˼��̿Ϸ� �ڷῡ ���ؼ� ���۾����� �˼�ó�� �� ��� */
	Case 'chk'
		Post wf_chk(nRow)
//	Case 'chk'
//		If Trim(GetText()) = 'Y' Then		
//			sDate = is_today
//			Setitem(nRow, 'choiceqty', GetItemNumber(nRow,'ioqty'))
//		ELSE
//			SetNull(sDate )
//			SetItem(nRow, "bigo",snull)
//			Setitem(nRow, 'choiceqty', 0)
//		END IF
//
//		SetItem(row,'gdate',sDate)
//		SetItem(row,'chdate', GetItemString(row,'io_date'))
//	Case 'gdate', 'yebi1'
//		IF f_datechk(GetText()) = -1 THEN
//			f_message_chk(35,'[�˼�����]')
//			SetItem(nRow, GetColumnName(),sNull)
//			Return 1
//		End If
//	/* ������ ����*/
//	Case 'choiceqty'
//		dQty = Double(GetText())
//		If dQty <= 0 Then
//			MessageBox('Ȯ ��','[�˼������� 0���Ϸ� �� �� �����ϴ�]')
//			Return 1
//		End If
//		
//		dOldQty = GetItemNumber(nRow, 'ioqty', Primary!, True)
//	
//		If dQty > dOldQty Then
//			MessageBox('Ȯ ��','[�˼������� ����ܷ� �̻����� �� �� �����ϴ�]')
//			Return 1
//		End If
//	/* ������� ���� */
//	Case 'chdate'
//		sDate = Trim(GetText())
//		If f_datechk(sDate) <> 1 Then
//			f_message_chk(35,'')
//			Return 2
//		End If
//		
//		If sDate < GetItemString(nrow, 'sudat') Then
//			MessageBox('Ȯ��','����Ƿ����ں��� Ŀ���մϴ�')
//			Return 2
//		End If
End Choose
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_imhist from datawindow within w_van_00020
boolean visible = false
integer x = 1536
integer y = 92
integer width = 1934
integer height = 152
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_020402"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_msg from statictext within w_van_00020
boolean visible = false
integer x = 3017
integer y = 88
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type lb_1 from listbox within w_van_00020
boolean visible = false
integer x = 2057
integer y = 16
integer width = 718
integer height = 240
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
boolean border = false
end type

type cb_1 from commandbutton within w_van_00020
integer x = 4151
integer y = 208
integer width = 366
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ī����"
end type

event clicked;Open(w_van_00020_popup)
end event

type gb_2 from groupbox within w_van_00020
boolean visible = false
integer x = 69
integer y = 1868
integer width = 855
integer height = 188
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_van_00020
boolean visible = false
integer x = 2455
integer y = 1868
integer width = 1102
integer height = 188
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_van_00020
integer x = 41
integer y = 316
integer width = 4475
integer height = 1276
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 33027312
string text = "[VAN DATA]"
end type

type gb_5 from groupbox within w_van_00020
integer x = 41
integer y = 1628
integer width = 4475
integer height = 600
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "[���� ����]"
end type

type rr_1 from roundrectangle within w_van_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 3227
integer height = 252
integer cornerheight = 40
integer cornerwidth = 46
end type

