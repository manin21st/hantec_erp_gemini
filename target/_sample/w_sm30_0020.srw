$PBExportHeader$w_sm30_0020.srw
$PBExportComments$�� �ǸŰ�ȹ Ȯ��
forward
global type w_sm30_0020 from w_inherite
end type
type dw_1 from u_key_enter within w_sm30_0020
end type
type rr_1 from roundrectangle within w_sm30_0020
end type
end forward

global type w_sm30_0020 from w_inherite
integer width = 4667
integer height = 2488
string title = "�� �ǸŰ�ȹ Ȯ��"
dw_1 dw_1
rr_1 rr_1
end type
global w_sm30_0020 w_sm30_0020

forward prototypes
public function integer wf_protect (string arg_year, integer arg_chasu)
public function integer wf_danga (integer arg_row)
end prototypes

public function integer wf_protect (string arg_year, integer arg_chasu);String sSaupj
Long   nCnt

sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))

SELECT COUNT(*) INTO :nCnt FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :sSaupj 
	AND YYYY = :arg_year
	AND CHASU = :arg_chasu
	AND CNFIRM IS NOT NULL;
If nCnt > 0 Then
	MessageBox('Ȯ ��','�� �ǸŰ�ȹ�� ����ó�� �Ǿ��ֽ��ϴ�.!!')
	p_search.Enabled = False
	p_print.Enabled = False
	p_mod.Enabled = False
	p_addrow.Enabled = False
	p_delrow.Enabled = False
	p_del.Enabled = False
	p_search.PictureName = 'C:\erpman\image\����_d.gif'
	p_print.PictureName = 'C:\erpman\image\�ҿ䷮���_d.gif'
	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
	p_addrow.PictureName = 'C:\erpman\image\���߰�_d.gif'
	p_delrow.PictureName = 'C:\erpman\image\�����_d.gif'
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_search.Enabled = True
	p_print.Enabled = True
	p_mod.Enabled = True
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	p_del.Enabled = True
	p_search.PictureName = 'C:\erpman\image\����_up.gif'
	p_print.PictureName = 'C:\erpman\image\�ҿ䷮���_up.gif'
	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
	p_addrow.PictureName = 'C:\erpman\image\���߰�_up.gif'
	p_delrow.PictureName = 'C:\erpman\image\�����_up.gif'
	p_del.PictureName = 'C:\erpman\image\����_up.gif'
End If

Return 1
end function

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate, sSaupj, sYear, sStrmm , ls_curr
Double	 dDanga, nChasu
Long ll_rtn 

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'0101'	// �ܰ���������
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dDanga = SQLCA.fun_erp100000012_1(is_today , sCVCOD ,sITNBR ,'1' ) ;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'plan_prc', dDanga)

dw_insert.SetItem(arg_row, 'amt_01', dw_insert.GetItemNumber(arg_row, 'qty_01') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_02', dw_insert.GetItemNumber(arg_row, 'qty_02') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_03', dw_insert.GetItemNumber(arg_row, 'qty_03') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_04', dw_insert.GetItemNumber(arg_row, 'qty_04') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_05', dw_insert.GetItemNumber(arg_row, 'qty_05') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_06', dw_insert.GetItemNumber(arg_row, 'qty_06') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_07', dw_insert.GetItemNumber(arg_row, 'qty_07') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_08', dw_insert.GetItemNumber(arg_row, 'qty_08') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_09', dw_insert.GetItemNumber(arg_row, 'qty_09') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_10', dw_insert.GetItemNumber(arg_row, 'qty_10') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_11', dw_insert.GetItemNumber(arg_row, 'qty_11') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_12', dw_insert.GetItemNumber(arg_row, 'qty_12') * dDanga) 

	
Return 0
end function

on w_sm30_0020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm30_0020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

Long ll_chasu


Select Max(chasu) Into :ll_chasu 
  from SM01_YEARPLAN
Where saupj   = :gs_code
  and YYYY = trim(to_char(to_number(substr(:is_today,1,4))+1 ,'0000'))
  and gubun = '1';
  
If isNull(ll_chasu) Then ll_chasu = 1
  
dw_1.Object.yymm[1] = String( Long ( Left(is_today,4)) + 1 ,'0000')
dw_1.Object.chasu[1] = ll_chasu
end event

type dw_insert from w_inherite`dw_insert within w_sm30_0020
integer x = 27
integer y = 276
integer width = 4558
integer height = 2024
integer taborder = 130
string dataobject = "d_sm30_0020_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_sm30_0020
boolean visible = false
integer x = 3922
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_sm30_0020
boolean visible = false
integer x = 3749
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_sm30_0020
boolean visible = false
integer x = 2766
integer taborder = 110
string picturename = "C:\erpman\image\��������_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\��������_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\��������_up.gif"
end event

event p_search::clicked;call super::clicked;String ls_window_id , ls_window_nm, syymm
Double   ll_sp = 0

syymm = dw_1.GetItemString(1, 'yymm')
If syymm = '' or isNull(syymm) Then
	messagebox('','��ȹ�⵵�� �Է��ϼ���.')
	return
End If


gs_code = '�� �ǸŰ�ȹ ����'
gs_codename = String(sYymm,'@@@@�� ') + '�ǸŰ�ȹ�� �����߽��ϴ�.'
//Open(w_mailsend_popup)
end event

type p_ins from w_inherite`p_ins within w_sm30_0020
integer x = 4096
integer taborder = 30
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ�����_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ�����_up.gif"
end event

event p_ins::clicked;call super::clicked;String sYymm
Long	 nCnt, nChasu
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

nChasu = dw_1.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[��ȹ����]')
	Return
End If

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

//SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL WHERE SABU = :gs_sabu AND MONYYMM = :syymm;
//If nCnt > 0 Then
//	MessageBox('Ȯ��','�̹� �����ȹ�� �����Ǿ� �ֽ��ϴ�.!!')
//	Return
//End If

If  MessageBox("Ȯ�����", '�� �ǸŰ�ȹ�� Ȯ����� ó�� �մϴ�', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE SM01_YEARPLAN
   SET CNFIRM = NULL
 WHERE SABU = :gs_sabu AND YYYY = :syymm AND SAUPJ = :ssaupj AND CHASU = :nChasu;
 
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('Ȯ��','���������� ���ó���Ǿ����ϴ�.!!')

ib_any_typing = FALSE

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite`p_exit within w_sm30_0020
integer taborder = 100
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_sm30_0020
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm30_0020
boolean visible = false
integer x = 3214
integer taborder = 120
string picturename = "C:\erpman\image\�ҿ䷮���_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\�ҿ䷮���_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\�ҿ䷮���_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm30_0020
integer x = 3749
end type

event p_inq::clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2
String scvcod
Long   nCnt, ix, nrow, nChasu
String sSaupj , ls_itnbr

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
nChasu = dw_1.getitemNumber(1, 'chasu')
scvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ls_itnbr = Trim(dw_1.Object.itnbr[1])

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[��ȹ�⵵]')
	Return
End If

If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[��ȹ����]')
	Return
End If

If IsNull(scvcod) Or scvcod = '.' or scvcod = '' Then scvcod = '%'
	
If IsNull(ls_itnbr) Or ls_itnbr = '' Then 
	ls_itnbr = '%'
else
	ls_itnbr = ls_itnbr + '%'
end if

	
If dw_insert.Retrieve(gs_sabu, sSaupj, sYear, nChasu, scvcod+'%',  ls_itnbr) <= 0 Then
	dw_1.Object.t_status.Text = "����"
Else
	If isNull(Trim(dw_insert.Object.cnfirm[1])) = False Then
		dw_1.Object.t_status.Text = "Ȯ��"
	Else
		dw_1.Object.t_status.Text = "����"
	End If
End If

end event

type p_del from w_inherite`p_del within w_sm30_0020
boolean visible = false
integer x = 3035
integer taborder = 80
boolean enabled = false
end type

event p_del::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc, tx_name, sCargbn1, sCargbn2, sYear
String sSaupj

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))
sYear = Trim(dw_1.GetItemString(1, 'yymm'))
tx_name = Trim(dw_1.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
sCargbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCargbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

IF MessageBox("Ȯ��", '������ ' + tx_name + ' �� �ڷḦ �����մϴ�. ~r~n~r~n����Ͻðڽ��ϱ�?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

// ������ ��ȹ�� ���
If dw_insert.DataObject = 'd_sm00_00010_2' Then
/* �����ڷ� ���� - ����,���� */
	DELETE FROM "SM01_YEARPLAN"
		WHERE SABU = :gs_sabu 
		  AND YYYY = :sYear
		  AND GUBUN = :sCargbn1||:sCargbn2
		  AND SAUPJ = :sSaupj;
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sm30_0020
integer taborder = 70
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_mod::ue_lbuttonup;//
end event

event p_mod::ue_lbuttondown;//
end event

event p_mod::clicked;call super::clicked;String syymm
Int	 lRtnValue, nChasu
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

sYymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

nChasu = dw_1.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[��ȹ����]')
	Return
End If

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If  MessageBox("Ȯ��ó��", '�� �ǸŰ�ȹ�� Ȯ��ó�� �մϴ�', Exclamation!, OKCancel!, 1) = 2 Then Return

// �ܰ��� TRIGGER���� �ϰ����� ó���Ѵ� 

UPDATE SM01_YEARPLAN
   SET CNFIRM = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE SABU = :gs_sabu AND YYYY = :syymm AND SAUPJ = :sSaupj AND CHASU = :nChasu;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('Ȯ��','���������� Ȯ�� ó���Ǿ����ϴ�.!!')

// E-Mail ����
//p_mod.TriggerEvent(Clicked!)

p_inq.TriggerEvent(Clicked!)
ib_any_typing = FALSE

end event

type cb_exit from w_inherite`cb_exit within w_sm30_0020
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm30_0020
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm30_0020
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm30_0020
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm30_0020
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm30_0020
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm30_0020
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm30_0020
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm30_0020
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm30_0020
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm30_0020
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm30_0020
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm30_0020
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm30_0020
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm30_0020
integer x = 23
integer y = 16
integer width = 2894
integer height = 244
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm30_0020_1"
boolean border = false
end type

event itemchanged;String s_cvcod, snull, get_nm, sItem, sCust,sDate
Long   nCnt, nChasu
String sSaupj

SetNull(sNull)


Choose Case GetColumnName()
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	
	Case 'itnbr'
		sItem = GetText()
	/* ��ȹ�⵵ */
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			// �ش�⵵�� �������� ���
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
			
			Post wf_protect(sDate, nChasu)
		End If
	/* ��ȹ���� */
	Case 'chasu'
		nChasu = Dec(GetText())
		If nChasu <= 0 Then Return
		
		sDate = GetitemString(1, 'yymm')
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			Post wf_protect(sDate, nChasu)
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type rr_1 from roundrectangle within w_sm30_0020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 272
integer width = 4585
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

