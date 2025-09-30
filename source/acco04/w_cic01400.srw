$PBExportHeader$w_cic01400.srw
$PBExportComments$���� ��������
forward
global type w_cic01400 from w_inherite
end type
type dw_2 from datawindow within w_cic01400
end type
type gb_4 from groupbox within w_cic01400
end type
type dw_1 from datawindow within w_cic01400
end type
type rr_1 from roundrectangle within w_cic01400
end type
end forward

global type w_cic01400 from w_inherite
string title = "���� ��������"
dw_2 dw_2
gb_4 gb_4
dw_1 dw_1
rr_1 rr_1
end type
global w_cic01400 w_cic01400

type variables
Boolean itemerr =False
String     LsIttyp
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
public subroutine wf_button_chk (string as_gubun, long al_rowcnt)
public function integer wf_procedure (string as_workym, string as_itemclass, string as_prcid)
public function boolean wf_isnumber (string ar_code)
end prototypes

public function integer wf_requiredchk (integer ll_row);//String sWorkym, sMat
//
//dw_2.AcceptText()
//sWorkym = dw_2.GetItemString(ll_row, 'workym')
//sMat  = dw_2.GetItemString(ll_row, 'mat')
//
//If sWorkym = "" Or IsNull(sWorkym) Then
//	f_messagechk(1, '[���ҳ��]')
//	dw_1.SetColumn('workym')
//	dw_1.SetFocus()
//	Return -1
//End If
//
//If sMat = "" Or IsNull(sMat) Then
//	f_messagechk(1, '[�����]')
//	dw_2.SetColumn('ip_qty')
//	dw_2.SetFocus()
//	Return -1
//End If
Return 1
end function

public function integer wf_dup_chk (integer ll_row);Return 1
end function

public subroutine wf_button_chk (string as_gubun, long al_rowcnt);Choose Case as_gubun
	//�ʱ�ȭ	
	Case 'C'
		p_search.Enabled = True //
		p_search.PictureName =  'C:\erpman\image\����_d.gif'
		p_ins.enabled = False
		p_ins.PictureName = 'C:\erpman\image\��ü����_d.gif'
	//��ȸ
	Case 'Q'
		If al_Rowcnt > 0 Then
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\����_d.gif'
			p_ins.enabled = True
			p_ins.PictureName = 'C:\erpman\image\��ü����_up.gif'
		Else	
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\����_up.gif'
			p_ins.enabled = False
			p_ins.PictureName = 'C:\erpman\image\��ü����_d.gif'
		End If	
	//����
	Case 'S'
			p_search.Enabled = True //
			p_search.PictureName =  'C:\erpman\image\����_d.gif'
			p_ins.enabled = True
			p_ins.PictureName = 'C:\erpman\image\��ü����_up.gif'
	//����
	Case 'D'
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\����_up.gif'
			p_ins.enabled = False
			p_ins.PictureName = 'C:\erpman\image\��ü����_d.gif'
	Case Else
End Choose
		
end subroutine

public function integer wf_procedure (string as_workym, string as_itemclass, string as_prcid);// Stored Procedure ó������
// ó�� ����:���
// ó��Return ����:ó�����
String sPrcRtn //ó�����
// ó����� �޽��� ó������(�޽�������, �޽���, ó�� PROCEDURE)
String sRtnGbn, sRtnMsg, sRtnPrcName

// Stored Procedure call
Choose Case as_prcid
	// ����⸻��� �̿�(������� ����(CIC0140) (����:�⸻��� ����/�ݾ�)
	//                -> ������� ����(CIC0140) (���:������� ����/�ݾ�))
	Case 'CIC08014' //�����
      // 1.������� ����(CIC0140): ��� ������� ����/�ݾ� �ʱ�ȭ
      // 2.������� ����(CIC0140): ��� �ڷ� ����� UPDATE, ������� INSERT
		DECLARE SP_CREATE_CIC08014 PROCEDURE FOR CIC08014 (:as_workym) USING SQLCA;
	// ��� ��������(CIC0140) (���: ����԰�/������/�⸻��� ����/�ݾ�)
	Case 'CIC09014' //������
		DECLARE SP_CREATE_CIC09014 PROCEDURE FOR CIC09014 (:as_workym) USING SQLCA;
	Case 'CIC05013GG' //�����-������ ��ǰ��ü������ ��ǰ���Һ� �԰� ���� ó�� �߰� 2007.7.10
		DECLARE SP_CREATE_CIC05013GG PROCEDURE FOR CIC05013GG (:as_workym) USING SQLCA;		
	Case Else
End Choose

Choose Case as_prcid
	Case 'CIC08014'	
		EXECUTE SP_CREATE_CIC08014;
	Case 'CIC09014'	
		EXECUTE SP_CREATE_CIC09014;
	Case 'CIC05013GG'	
		EXECUTE SP_CREATE_CIC05013GG;		
	Case Else
End Choose

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[EXECUTE SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
	Choose Case as_prcid
		Case 'CIC08014'	
			CLOSE SP_CREATE_CIC08014;
		Case 'CIC09014'	
			CLOSE SP_CREATE_CIC09014;
		Case 'CIC05013GG'	
			CLOSE SP_CREATE_CIC05013GG;			
		Case Else
	End Choose
	RollBack;
	Return -1
End If

Choose Case as_prcid
	Case 'CIC08014'	
		FETCH SP_CREATE_CIC08014 INTO :sPrcRtn ;
	Case 'CIC09014'	
		FETCH SP_CREATE_CIC09014 INTO :sPrcRtn ;
	Case 'CIC05013GG'	
		FETCH SP_CREATE_CIC05013GG INTO :sPrcRtn ;		
	Case Else
End Choose

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[FETCH SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
	Choose Case as_prcid
		Case 'CIC08014'	
			CLOSE SP_CREATE_CIC08014;
		Case 'CIC09014'	
			CLOSE SP_CREATE_CIC09014;
		Case 'CIC05013GG'	
			CLOSE SP_CREATE_CIC05013GG;			
		Case Else
	End Choose
	RollBack;
	Return -1
End If

sRtnGbn     = Left(Trim(sPrcRtn), 1)                          //�޽�������
sRtnMsg     = Mid(Trim(sPrcRtn), 3, Len(Trim(sPrcRtn)) - 11 ) //�޽���
sRtnPrcName = Right(Trim(sPrcRtn), 8)                         //ó�� Procedure
Choose Case sRtnGbn
	Case 'E' // ����
		f_message_chk(57, "~r~n~r~n[ó����� �޽������� = E(����)]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " ���ν���: " + sRtnPrcName
		RollBack;
		Return -1
	Case 'F' // �����Ϸ�
		f_message_chk(57, "~r~n~r~n[ó����� �޽������� = F(��������)]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " ���ν���: " + sRtnPrcName
		RollBack;
		Return -1
	Case 'R' // ����
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " ���ν���: " + sRtnPrcName
	Case Else
End Choose	

Choose Case as_prcid
	Case 'CIC08014'	
		CLOSE SP_CREATE_CIC08014;
	Case 'CIC09014'	
		CLOSE SP_CREATE_CIC09014;
	Case 'CIC05013GG'	
		CLOSE SP_CREATE_CIC05013GG;		
	Case Else
End Choose

Return 1
end function

public function boolean wf_isnumber (string ar_code);//**************************************************************************//
//   ����          : �Ŀ������� isnumber �� üũ �ȵǴ� ���ڰ� �־ �űԷ� ����  (��)  111,111 --> 111111�� ��ȯ , 111, --> 111�� ��ȯ
//                   ���̳ʽ��� ���ȵ�..
//   2007.04.24 �� : ���̷� �� ���ڴ�  isnumber --> f_isnumber�� ��ü�ؾ���
//   function name : f_isnumber 
//        argument : ����
//          return : Boolean (True/False)
//**************************************************************************//
Double  lnumber

select to_number(:ar_code)
  into :lnumber
  from dual ;

if sqlca.sqlcode < 0 then return false

if lnumber < 0 then return false

Return True

end function

on w_cic01400.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_4=create gb_4
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic01400.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;string vWorkym

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

SELECT nvl(fun_get_aftermonth(max(workym), 1),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO :vWorkym
   FROM CIC0010
 WHERE  end_yn = 'Y';

//dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))

dw_1.SetItem(1, 'workym', vWorkym)
dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

wf_button_chk('C', 0)
end event

type dw_insert from w_inherite`dw_insert within w_cic01400
boolean visible = false
integer x = 41
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic01400
boolean visible = false
integer x = 5202
integer y = 184
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic01400
boolean visible = false
integer x = 5029
integer y = 184
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic01400
integer x = 3566
integer taborder = 20
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event p_search::clicked;call super::clicked;String sWorkym, sMatclass, snull, ls_rtn
Long   lRecCnt
SetNull(snull)

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1,'[���ҳ��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sMatclass = Trim(dw_1.GetItemString(dw_1.GetRow(), 'matclass'))
If sMatclass = "" Or IsNull(sMatclass) Then
	sMatclass = '%'
Else	
	MessageBox("�˸�", "���ҳ���� ���� ��ü�� �������� �մϴ�.!!!")
	dw_1.SetItem(dw_1.GetRow(), 'matclass', snull)
	dw_1.SetColumn('matclass')
	dw_1.SetFocus()
	Return
End If

/*--------------------------------------------------------------------------------------------*/
// ������������ üũ
select fun_wonga_magam(:sWorkym) into :ls_rtn
  from dual ;
if ls_rtn = 'Y' then
   messagebox('Ȯ��','���� ó���� ��������� �Դϴ�! ��������� �����Ͻʽÿ�!')
   Return
end if

////ǰ�� �����ǥ
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('�˸�', '������� ó���� ����� ��������� ������ �� �����ϴ�.')
//	Return 
//End If

// ����⸻��� �̿�(������� ����(CIC0140) (����:�⸻��� ����/�ݾ�)
//                -> ������� ����(CIC0140) (���:������� ����/�ݾ�))
If wf_procedure(sWorkym, sMatclass, 'CIC08014') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If

//// ��� ��������(CIC0140) (���: ����԰�/������/�⸻��� ����/�ݾ�)
If wf_procedure(sWorkym, sMatclass, 'CIC09014') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_cic01400
integer x = 4087
integer taborder = 50
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\��ü����_d.gif"
end type

event p_ins::clicked;call super::clicked;String sWorkym, sMatclass, snull
Long	 lRowcnt, lRecCnt
SetNull(snull)

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���ҳ��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sMatclass = Trim(dw_1.GetItemString(dw_1.GetRow(), 'matclass'))
If Not (sMatclass = "" Or IsNull(sMatclass)) Then
	MessageBox("�˸�", "���ҳ���� ���� ��ü�� �������� �մϴ�.!!!")
	dw_1.SetItem(dw_1.GetRow(), 'matclass', snull)
	dw_1.SetColumn('matclass')
	dw_1.SetFocus()
	Return
End If

If dw_2.AcceptText() = -1 Then Return
If dw_2.RowCount() <= 0 Then
	MessageBox("�˸�", "��ȸ�� �����ϼ���.!!!")
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

////ǰ�� �����ǥ
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('�˸�', '������� ó���� ����� ��������� ������ �� �����ϴ�.')
//	Return 
//End If

////������� ����
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0140
// WHERE WORKYM > :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('�˸�', '������ ������� �ڷᰡ �����Ͽ� ����� ��������� ������ �� �����ϴ�.')
//	Return 
//End If

w_mdi_frame.sle_msg.text = ""
If f_msg_delete() = -1 Then Return

//������� ����(���ǰ�� �ƴҰ��)
UPDATE CIC0140
	SET IP_QTY = 0,
	    IP_AMT = 0,
		 OP_QTY = 0,
		 OP_AMT = 0,
		 WP_QTY = 0,
		 WP_AMT = 0
 WHERE WORKYM = :sWorkym
   AND MAT not in ('1140','1230') ;
  
If SQLCA.SQLCODE <> 0 Then 	  
	Rollback;
	Messagebox("��������", "�ڷῡ ���� ������ �����Ͽ����ϴ�.")
	w_mdi_frame.sle_msg.text = ""
	Return
End If

//������� ����(���ǰ�� ���)
//UPDATE CIC0140
//	SET IP_QTY = 0,
//	    IP_AMT = 0,
//		 WP_QTY = 0,
//		 WP_AMT = 0
// WHERE WORKYM = :sWorkym
//   AND MAT in ('1140','1230') ;
//  
//If SQLCA.SQLCODE <> 0 Then 	  
//	Rollback;
//	Messagebox("��������", "�ڷῡ ���� ������ �����Ͽ����ϴ�.")
//	w_mdi_frame.sle_msg.text = ""
//	Return
//End If

Commit;

ib_any_typing = False
w_mdi_frame.sle_msg.text = "�ڷḦ �����Ͽ����ϴ�."
dw_2.Reset()
wf_button_chk('D', 0)


end event

event p_ins::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ü����_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ü����_up.gif"
end event

type p_exit from w_inherite`p_exit within w_cic01400
integer x = 4434
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_cic01400
integer x = 4261
integer taborder = 60
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
dw_1.SetFocus()

dw_2.Reset()
wf_button_chk('C', 0)

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_cic01400
integer x = 5376
integer y = 184
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic01400
integer x = 3739
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String sWorkym, sMatclass
Long	 lRowcnt

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���ҳ��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sMatclass = Trim(dw_1.GetItemString(dw_1.GetRow(), 'matclass'))
If sMatclass = "" Or IsNull(sMatclass) Then sMatclass = '%'

w_mdi_frame.sle_msg.Text = "��ȸ ���Դϴ�.!!!"
SetPointer(HourGlass!)
dw_2.SetRedraw(False)

lRowcnt = dw_2.Retrieve(sWorkym, sMatclass)
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	ib_any_typing = False
	wf_button_chk('Q', lRowcnt)
	SetPointer(Arrow!)
	Return
Else
	dw_2.SetColumn('ip_qty')
	dw_2.SetFocus()
End If

dw_2.SetRedraw(True)
w_mdi_frame.sle_msg.text = "��ȸ�� �Ϸ�Ǿ����ϴ�.!!!"
ib_any_typing = False
wf_button_chk('Q', lRowcnt)
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cic01400
integer x = 4855
integer y = 184
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('����') = 2 THEN RETURN
ELSE
	IF MessageBox("Ȯ ��","�����Ͻ� �ڷῡ �̿� �̿��� �ڷ�(�԰�,���,���)�� �����մϴ�.~r"+&
								 "�����Ͻðڽ��ϱ�?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="�ڷᰡ �����Ǿ����ϴ�.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cic01400
integer x = 3913
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String sWorkym, sMatclass, ls_rtn

If dw_1.Accepttext() = -1 Then Return

sWorkym   = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���ҳ��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sMatclass = Trim(dw_1.GetItemString(dw_1.GetRow(), 'matclass'))
If sMatclass = "" Or IsNull(sMatclass) Then
	sMatclass = '%'
Else
	sMatclass = sMatclass + '%'
End If	

Long lRowCnt
Long lRecCnt

If dw_2.AcceptText() = -1 Then Return
If dw_2.RowCount() <= 0 Then Return

If ib_any_typing = False Then
	MessageBox("�˸�", "����� �ڷᰡ �����ϴ�.!!!")
	Return 
End If	

/*--------------------------------------------------------------------------------------------*/
// ������������ üũ
select fun_wonga_magam(:sWorkym) into :ls_rtn
  from dual ;
if ls_rtn = 'Y' then
   messagebox('Ȯ��','���� ó���� ��������� �Դϴ�! ��������� �����Ͻʽÿ�!')
   Return
end if


////ǰ�� �����ǥ
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('�˸�', '������� ó���� ����� ��������� ������ �� �����ϴ�.')
//	Return 
//End If

If dw_2.Update() = 1 Then
	Commit;
	
	For lRowCnt = 1 To dw_2.RowCount()
		dw_2.SetItem(lRowCnt, 'sflag', 'M')
	Next

	dw_2.SetColumn('ip_qty')
	dw_2.SetFocus()
	
	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�.!!!"
	ib_any_typing = False
	wf_button_chk('S', 0)
Else
	Rollback;
	f_messagechk(13, '')
End If

// 2007.7.10 �߰�����
// ������ ��ǰ���� ��ü��� ����,�ݾ��� ��ǰ���Һ� �԰� ����,�ݾ׿� ����ó����
If wf_procedure(sWorkym, sMatclass, 'CIC05013GG') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If
//CIC05013GG


end event

type cb_exit from w_inherite`cb_exit within w_cic01400
integer x = 3026
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_cic01400
integer x = 2199
integer y = 2752
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF dw_2.RowCount() > 0 THEN
	FOR k = 1 TO dw_2.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('����') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT

	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="�ڷᰡ ����Ǿ����ϴ�.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_cic01400
integer x = 503
integer y = 2752
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sYm

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sYm = Trim(dw_1.GetItemString(1,"io_ym"))
IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[���������]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_2.InsertRow(0)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'io_yymm',sYm)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("itnbr")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_cic01400
integer x = 2551
integer y = 2752
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('����') = 2 THEN RETURN
ELSE
	IF MessageBox("Ȯ ��","�����Ͻ� �ڷῡ �̿� �̿��� �ڷ�(�԰�,���,���)�� �����մϴ�.~r"+&
								 "�����Ͻðڽ��ϱ�?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="�ڷᰡ �����Ǿ����ϴ�.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_cic01400
integer x = 142
integer y = 2752
end type

event cb_inq::clicked;call super::clicked;String sYm

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
LsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[���������]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF LsIttyp = "" OR IsNull(LsIttyp) THEN LsIttyp = '%'

sle_msg.Text = '��ȸ ��...'
SetPointer(HourGlass!)
dw_2.SetRedraw(False)
IF dw_2.Retrieve(sYm,LsIttyp) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
END IF
dw_2.SetRedraw(True)

sle_msg.text = '��ȸ �Ϸ�'
SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_cic01400
integer x = 1650
integer y = 2424
end type

type st_1 from w_inherite`st_1 within w_cic01400
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cic01400
integer x = 2907
integer y = 2752
end type

event cb_can::clicked;call super::clicked;String sIttyp,sIoYm

sle_msg.text =""
sIoYm  = Trim(dw_1.GetItemString(1,"io_ym"))
sIttyp = dw_1.GetItemString(1,"ittyp")
IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = '%'

dw_2.SetRedraw(False)
IF dw_2.Retrieve(sIoYm,sIttyp) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_cic01400
integer x = 2053
integer y = 2432
end type

type dw_datetime from w_inherite`dw_datetime within w_cic01400
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cic01400
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cic01400
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cic01400
integer x = 110
integer y = 2696
end type

type gb_button2 from w_inherite`gb_button2 within w_cic01400
integer x = 2153
integer y = 2696
end type

type dw_2 from datawindow within w_cic01400
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
event ue_qty_setting ( long lrow )
integer x = 50
integer y = 200
integer width = 4549
integer height = 2040
integer taborder = 80
string title = "���� ������"
string dataobject = "dw_cic01400_30"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;If keydown(keyF1!) Then
	TriggerEvent(RbuttonDown!)
End If
end event

event ue_enterkey;Send(Handle(This),256,9,0)
Return 1
end event

event ue_qty_setting(long lrow);Double dIwol_qty, dIwol_amt  //������� ����/�ݾ�
Double dIp_qty,   dIp_amt    //����԰� ����/�ݾ�
Double dOp_qty,   dOp_amt    //������ ����/�ݾ�
Double dWp_qty,   dWp_amt    //�⸻��� ����/�ݾ�
String sMat						  //����з�
Long   lLRow
Long   lFRow
Double dTemp_qty, dTemp_amt  //�ӽ� ��� ����/�ݾ�

lLRow      = This.GetRow()
dTemp_qty  = 0
dTemp_amt  = 0
sMat          = This.Object.mat[lrow]
dIwol_qty   = This.Object.iwol_qty[lrow]
dIwol_amt  = This.Object.iwol_amt[lrow]
dIp_qty      = This.Object.ip_qty[lrow]
dIp_amt     = This.Object.ip_amt[lrow]
dOp_qty     = This.Object.op_qty[lrow]
dOp_amt    = This.Object.op_amt[lrow]
dWp_qty     = This.Object.wp_qty[lrow]
dWp_amt    = This.Object.wp_amt[lrow]

// ���� ������� �϶�, ������ Null�̸� 0���� ó�� �� ������ ���.
//            ���⵿             8mm ROD            BARLEY              CLOVE              BERRY                 CANDY               T/BIRCH             BIRCH                 COCOA               8mm ROD           AL-VG                 H-AL
If (sMat = '1110' or sMat = '1160' or sMat =  '1201' or sMat = '1202' or sMat = '1203' or  sMat = '1204' or  sMat = '1205' or sMat = '1206' or  sMat = '1207' or  sMat = '1220' or  sMat = '5110' or  sMat = '5210') Then	
	If IsNull(This.Object.iwol_qty[lrow]) Then
		dIwol_qty = 0
	Else
		dIwol_qty = Double(This.Object.iwol_qty[lrow])
		If IsNull(This.Object.ip_qty[lrow]) Then
			dIp_qty = 0
		Else
			dIp_qty = Double(This.Object.ip_qty[lrow])
			If IsNull(This.Object.wp_qty[lrow]) Then
				dWp_qty = 0
			Else
				dWp_qty = Double(This.Object.wp_qty[lrow])
			End If
		End If
	End If
	dTemp_qty = dIwol_qty + dIp_qty - dWp_qty
	This.object.op_qty[lrow] = dTemp_qty //������ ����
End If	


// ���� ������� �϶�, �ݾ��� Null�̸� 0���� ó�� �� ���ݾ� ���.
//If (sMat = '1110' OR sMat = '1160' OR sMat = '1220' OR sMat = '5110' OR sMat = '5210') Then
If (sMat = '1110' or sMat = '1160' or sMat =  '1201' or sMat = '1202' or sMat = '1203' or  sMat = '1204' or  sMat = '1205' or sMat = '1206' or  sMat = '1207' or  sMat = '1220' or  sMat = '5110' or  sMat = '5210') Then	
	If IsNull(This.Object.iwol_amt[lrow]) Then
		dIwol_amt = 0
	Else
		dIwol_amt = Double(This.Object.iwol_amt[lrow])
		If IsNull(This.Object.ip_amt[lrow]) Then
			dIp_amt = 0
		Else
			dIp_amt = Double(This.Object.ip_amt[lrow])
			If IsNull(This.Object.wp_amt[lrow]) Then
				dWp_amt = 0
			Else
				dWp_amt = Double(This.Object.wp_amt[lrow])
			End If
		End If
	End If
	dTemp_amt = dIwol_amt + dIp_amt - dWp_amt
	This.object.op_amt[lrow] = dTemp_amt //������ �ݾ�
End If	

// ���ǰ �϶�, ������ Null�̸� 0���� ó�� �� �԰���� ���.
If (sMat = '1140' OR sMat = '1150'  OR sMat = '1230' OR sMat = '1240' ) Then
	If IsNull(This.Object.wp_qty[lrow]) Then
		dWp_qty = 0
	Else
		dWp_qty = Double(This.Object.wp_qty[lrow])
	End If
	This.object.ip_qty[lrow] = dWp_qty //�⸻ ����
End If	

// ���ǰ �϶�, �ݾ��� Null�̸� 0���� ó�� �� �԰�ݾ� ���.
If (sMat = '1140' OR sMat = '1150'  OR sMat = '1230' OR sMat = '1240' ) Then
	If IsNull(This.Object.wp_amt[lrow]) Then
		dWp_amt = 0
	Else
		dWp_amt = Double(This.Object.wp_amt[lrow])
	End If
	This.object.ip_amt[lrow] = dWp_amt //�⸻ �ݾ�
End If	

Choose Case sMat
	//��ũ������ -> ���⵿����
	Case '1120'		
		lFRow = 0
		lFRow = This.Find( "mat = '1210' ", 1, This.RowCount() )
		This.object.op_qty[lFRow] = dIp_qty
		This.object.op_amt[lFRow] = dIp_amt
	//���⵿���� -> ��ũ������
	Case '1210'		
		lFRow = 0
		lFRow = This.Find( "mat = '1120' ", 1, This.RowCount() )
		This.object.ip_qty[lFRow] = dOp_qty
		This.object.ip_amt[lFRow] = dOp_amt
	//H-AL���� -> AL-VG����
	Case '5130'		
		lFRow = 0
		lFRow = This.Find( "mat = '5220' ", 1, This.RowCount() )
		This.object.op_qty[lFRow] = dIp_qty
		This.object.op_amt[lFRow] = dIp_amt
	//VG���� -> H-AL����
	Case '5220'		
		lFRow = 0
		lFRow = This.Find( "mat = '5130' ", 1, This.RowCount() )
		This.object.ip_qty[lFRow] = dOp_qty
		This.object.ip_amt[lFRow] = dOp_amt
	Case Else
End Choose

end event

event editchanged;ib_any_typing = True
end event

event itemchanged;String sCode, sName, sNull
Integer iReturn
Long    lRow

lRow = This.GetRow()
SetNull(sNull)

Choose Case This.GetColumnName()
	Case 'ip_qty'
		If Not wf_IsNumber(data) Then
			f_message_chk(30, '[�԰����]')
			This.setitem(lRow, 'ip_qty', sNull)
			Return 1
		End If
		Post Event ue_qty_setting(lRow)
	Case 'ip_amt'
		If Not wf_IsNumber(data) Then
			f_message_chk(30, '[�԰�ݾ�]')
			This.setitem(lRow, 'ip_amt', sNull)
			Return 1
		End If
		Post Event ue_qty_setting(lRow)
	Case 'wp_qty'
		If Not wf_IsNumber(data) Then
			f_message_chk(30, '[�⸻����]')
			This.setitem(lRow, 'wp_qty', sNull)
			Return 1
		End If
		Post Event ue_qty_setting(lRow)
	Case 'wp_amt'
		If Not wf_IsNumber(data) Then
			f_message_chk(30, '[�⸻�ݾ�]')
			This.setitem(lRow, 'wp_amt', sNull)
			Return 1
		End If
		Post Event ue_qty_setting(lRow)
	Case Else
End Choose

w_mdi_frame.sle_msg.text = ""
ib_any_typing = True
end event

event retrieverow;If row > 0 Then
	This.SetItem(row, 'sflag', 'M')
End If
end event

event rowfocuschanged;//This.SetRowFocusIndicator(Hand!)
end event

event retrieveend;Long lRowCnt

For lRowCnt = 1 To rowcount
	This.SetItem(lRowCnt, 'sflag', 'M')
Next
end event

event itemerror;Return 1
end event

event getfocus;This.AcceptText()
end event

type gb_4 from groupbox within w_cic01400
boolean visible = false
integer y = 2948
integer width = 3598
integer height = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 12632256
end type

type dw_1 from datawindow within w_cic01400
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 20
integer width = 1696
integer height = 156
integer taborder = 10
string dataobject = "dw_cic01400_10"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(This),256,9,0)
Return 1
end event

event ue_key;If keydown(keyF1!) Then
	TriggerEvent(RbuttonDown!)
End If
end event

event itemchanged;String snull, sWorkym

SetNull(snull)
w_mdi_frame.sle_msg.text =""

Choose Case This.GetColumnName()
	Case 'workym'
		sWorkym = Trim(This.GetText())
		If sWorkym = "" Or IsNull(sWorkym) Then Return
		
		If f_datechk(sWorkym + '01') = -1 Then 
			f_messagechk(21, '[���ҳ��]')
			dw_1.SetItem(1, 'workym', snull)
			Return 1
		End If
	Case Else
End Choose

end event

event itemerror;Return 1

end event

event getfocus;This.AcceptText()
end event

type rr_1 from roundrectangle within w_cic01400
string tag = "����"
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 188
integer width = 4576
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

