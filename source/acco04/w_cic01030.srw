$PBExportHeader$w_cic01030.srw
$PBExportComments$����������� ����
forward
global type w_cic01030 from w_inherite
end type
type dw_2 from datawindow within w_cic01030
end type
type gb_4 from groupbox within w_cic01030
end type
type dw_1 from datawindow within w_cic01030
end type
type dw_print from datawindow within w_cic01030
end type
type rr_1 from roundrectangle within w_cic01030
end type
end forward

global type w_cic01030 from w_inherite
integer width = 4654
integer height = 3256
string title = "����������� ����"
dw_2 dw_2
gb_4 gb_4
dw_1 dw_1
dw_print dw_print
rr_1 rr_1
end type
global w_cic01030 w_cic01030

type variables
Boolean itemerr =False
String     LsIttyp

datawindowchild idwc_exp_gbn //��뱸��
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
public subroutine wf_button_chk (string as_gubun, long al_rowcnt)
public function integer wf_procedure (string as_workym, string as_exp_gbn, string as_gubun, string as_prcid)
end prototypes

public function integer wf_requiredchk (integer ll_row);//String sItnbr, sPur_qty, sPur_amt
//
//dw_2.AcceptText()
//sItnbr = dw_2.Object.itnbr[ll_row]
//sPur_qty = String(dw_2.Object.Pur_qty[ll_row])
//sPur_amt = String(dw_2.Object.Pur_amt[ll_row])
//
//If sItnbr = "" Or IsNull(sItnbr) Then
//	f_messagechk(1, '[ǰ��]')
//	dw_2.ScrollToRow(ll_row)
//	dw_2.SetColumn('itnbr')
//	dw_2.SetFocus()
//	Return -1
//End If
//
//If sPur_qty = "" Or IsNull(sPur_qty) Then
//	f_messagechk(1, '[���Լ���]')
//	dw_2.ScrollToRow(ll_row)
//	dw_2.SetColumn('Pur_qty')
//	dw_2.SetFocus()
//	Return -1
//End If
//
//If sPur_amt = "" Or IsNull(sPur_amt) Then
//	f_messagechk(1, '[���Աݾ�]')
//	dw_2.ScrollToRow(ll_row)
//	dw_2.SetColumn('Pur_amt')
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
		p_search.Enabled = False
		p_search.PictureName =  'C:\erpman\image\����_d.gif'
		p_ins.enabled = False
		p_ins.PictureName = 'C:\erpman\image\��ü����_d.gif'
	//��ȸ
	Case 'Q'
		If al_Rowcnt > 0 Then
			p_search.Enabled = False
			p_search.PictureName =  'C:\erpman\image\����_d.gif'
			p_ins.enabled = True
			p_ins.PictureName = 'C:\erpman\image\��ü����_up.gif'
			//p_print.PictureName = 'C:\erpman\image\�μ�_up.gif'
		Else	
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\����_up.gif'
			p_ins.enabled = False
			p_ins.PictureName = 'C:\erpman\image\��ü����_d.gif'
		End If	
	//����
	Case 'S'
			p_search.Enabled = False
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

public function integer wf_procedure (string as_workym, string as_exp_gbn, string as_gubun, string as_prcid);// Stored Procedure ó������
// ó�� ����:���
// ó��Return ����:ó�����
String sPrcRtn //ó�����
// ó����� �޽��� ó������(�޽�������, �޽���, ó�� PROCEDURE)
String sRtnGbn, sRtnMsg, sRtnPrcName

// Stored Procedure call
If as_gubun = '1' Then //����(����/�Ⱥ�)
	Choose Case as_prcid
		// �� �빫�� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC20021' //�����-�빫�� 21 
			DECLARE SP_CREATE_CIC20021 PROCEDURE FOR CIC20021 (:as_workym) USING SQLCA;
		// �� ���º� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC21021' //�����-���º� 31 
			DECLARE SP_CREATE_CIC21021 PROCEDURE FOR CIC21021 (:as_workym) USING SQLCA;
		// �� ����� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC22021' //�����-����� 32 
			DECLARE SP_CREATE_CIC22021 PROCEDURE FOR CIC22021 (:as_workym) USING SQLCA;
		// �� �Ҹ�ǰ�� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC23021' //�����-�Ҹ�ǰ�� 33  
			DECLARE SP_CREATE_CIC23021 PROCEDURE FOR CIC23021 (:as_workym) USING SQLCA;
		// �� ������ ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC24021' //�����-������ 34   
			DECLARE SP_CREATE_CIC24021 PROCEDURE FOR CIC24021 (:as_workym) USING SQLCA;
		// �� �����󰢺� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC25021' //�����-�����󰢺� 35   
			DECLARE SP_CREATE_CIC25021 PROCEDURE FOR CIC25021 (:as_workym) USING SQLCA;
		// �� ��Ÿ��� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC26021' //�����-��Ÿ��� 36   
			DECLARE SP_CREATE_CIC26021 PROCEDURE FOR CIC26021 (:as_workym) USING SQLCA;
		// �� �ǰ��� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC27021' //�����-�ǰ��� 41   
			DECLARE SP_CREATE_CIC27021 PROCEDURE FOR CIC27021 (:as_workym) USING SQLCA;
		// �� ����ȯ�ޱ� ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC28021' //�����-����ȯ�ޱ� 51   
			DECLARE SP_CREATE_CIC28021 PROCEDURE FOR CIC28021 (:as_workym) USING SQLCA;
		// �� �λ깰 ���� �� ��� ����(�������(CIC0210) (���))
		Case 'CIC29021' //�����-�λ깰 52    
			DECLARE SP_CREATE_CIC29021 PROCEDURE FOR CIC29021 (:as_workym) USING SQLCA;
		Case Else
	End Choose
	
	Choose Case as_prcid
		Case 'CIC20021'	
			EXECUTE SP_CREATE_CIC20021;
		Case 'CIC21021'	
			EXECUTE SP_CREATE_CIC21021;
		Case 'CIC22021'	
			EXECUTE SP_CREATE_CIC22021;
		Case 'CIC23021'	
			EXECUTE SP_CREATE_CIC23021;
		Case 'CIC24021'	
			EXECUTE SP_CREATE_CIC24021;
		Case 'CIC25021'	
			EXECUTE SP_CREATE_CIC25021;
		Case 'CIC26021'	
			EXECUTE SP_CREATE_CIC26021;
		Case 'CIC27021'	
			EXECUTE SP_CREATE_CIC27021;
		Case 'CIC28021'	
			EXECUTE SP_CREATE_CIC28021;
		Case 'CIC29021'	
			EXECUTE SP_CREATE_CIC29021;
		Case Else
	End Choose
Else	//����(�Ⱥ�)
	Choose Case as_prcid
		// �� �빫�� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC20021_21' //�����-�빫�� 21 
			DECLARE SP_CREATE_CIC20021_21 PROCEDURE FOR CIC20021_21 (:as_workym) USING SQLCA;
		// �� ���º� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC21021_31' //�����-���º� 31 
			DECLARE SP_CREATE_CIC21021_31 PROCEDURE FOR CIC21021_31 (:as_workym) USING SQLCA;
		// �� ����� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC22021_32' //�����-����� 32 
			DECLARE SP_CREATE_CIC22021_32 PROCEDURE FOR CIC22021_32 (:as_workym) USING SQLCA;
		// �� �Ҹ�ǰ�� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC23021_33' //�����-�Ҹ�ǰ�� 33  
			DECLARE SP_CREATE_CIC23021_33 PROCEDURE FOR CIC23021_33 (:as_workym) USING SQLCA;
		// �� ������ ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC24021_34' //�����-������ 34   
			DECLARE SP_CREATE_CIC24021_34 PROCEDURE FOR CIC24021_34 (:as_workym) USING SQLCA;
		// �� �����󰢺� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC25021_35' //�����-�����󰢺� 35   
			DECLARE SP_CREATE_CIC25021_35 PROCEDURE FOR CIC25021_35 (:as_workym) USING SQLCA;
		// �� ��Ÿ��� ���� �ż�����, ��������� ���(�������(CIC0210) (���))
		Case 'CIC26021_36' //�����-��Ÿ��� 36   
			DECLARE SP_CREATE_CIC26021_36 PROCEDURE FOR CIC26021_36 (:as_workym) USING SQLCA;
		Case Else
	End Choose
	
	Choose Case as_prcid
		Case 'CIC20021_21'	
			EXECUTE SP_CREATE_CIC20021_21;
		Case 'CIC21021_31'	
			EXECUTE SP_CREATE_CIC21021_31;
		Case 'CIC22021_32'	
			EXECUTE SP_CREATE_CIC22021_32;
		Case 'CIC23021_33'	
			EXECUTE SP_CREATE_CIC23021_33;
		Case 'CIC24021_34'	
			EXECUTE SP_CREATE_CIC24021_34;
		Case 'CIC25021_35'	
			EXECUTE SP_CREATE_CIC25021_35;
		Case 'CIC26021_36'	
			EXECUTE SP_CREATE_CIC26021_36;
		Case Else
	End Choose
End If	

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[EXECUTE SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
	If as_gubun = '1' Then //����(����/�Ⱥ�)
		Choose Case as_prcid
			Case 'CIC20021'	
				CLOSE SP_CREATE_CIC20021;
			Case 'CIC21021'	
				CLOSE SP_CREATE_CIC21021;
			Case 'CIC22021'	
				CLOSE SP_CREATE_CIC22021;
			Case 'CIC23021'	
				CLOSE SP_CREATE_CIC23021;
			Case 'CIC24021'	
				CLOSE SP_CREATE_CIC24021;
			Case 'CIC25021'	
				CLOSE SP_CREATE_CIC25021;
			Case 'CIC26021'	
				CLOSE SP_CREATE_CIC26021;
			Case 'CIC27021'	
				CLOSE SP_CREATE_CIC27021;
			Case 'CIC28021'	
				CLOSE SP_CREATE_CIC28021;
			Case 'CIC29021'	
				CLOSE SP_CREATE_CIC29021;
			Case Else
		End Choose
	Else	//����(�Ⱥ�)
		Choose Case as_prcid
			Case 'CIC20021_21'	
				CLOSE SP_CREATE_CIC20021_21;
			Case 'CIC21021_31'	
				CLOSE SP_CREATE_CIC21021_31;
			Case 'CIC22021_32'	
				CLOSE SP_CREATE_CIC22021_32;
			Case 'CIC23021_33'	
				CLOSE SP_CREATE_CIC23021_33;
			Case 'CIC24021_34'	
				CLOSE SP_CREATE_CIC24021_34;
			Case 'CIC25021_35'	
				CLOSE SP_CREATE_CIC25021_35;
			Case 'CIC26021_36'	
				CLOSE SP_CREATE_CIC26021_36;
			Case Else
		End Choose
	End If	
		
	RollBack;
	Return -1
End If

If as_gubun = '1' Then //����(����/�Ⱥ�)
	Choose Case as_prcid
		Case 'CIC20021'	
			FETCH SP_CREATE_CIC20021 INTO :sPrcRtn ;
		Case 'CIC21021'	
			FETCH SP_CREATE_CIC21021 INTO :sPrcRtn ;
		Case 'CIC22021'	
			FETCH SP_CREATE_CIC22021 INTO :sPrcRtn ;
		Case 'CIC23021'	
			FETCH SP_CREATE_CIC23021 INTO :sPrcRtn ;
		Case 'CIC24021'	
			FETCH SP_CREATE_CIC24021 INTO :sPrcRtn ;
		Case 'CIC25021'	
			FETCH SP_CREATE_CIC25021 INTO :sPrcRtn ;
		Case 'CIC26021'	
			FETCH SP_CREATE_CIC26021 INTO :sPrcRtn ;
		Case 'CIC27021'	
			FETCH SP_CREATE_CIC27021 INTO :sPrcRtn ;
		Case 'CIC28021'	
			FETCH SP_CREATE_CIC28021 INTO :sPrcRtn ;
		Case 'CIC29021'	
			FETCH SP_CREATE_CIC29021 INTO :sPrcRtn ;
		Case Else
	End Choose
Else	//����(�Ⱥ�)
	Choose Case as_prcid
		Case 'CIC20021_21'	
			FETCH SP_CREATE_CIC20021_21 INTO :sPrcRtn ;
		Case 'CIC21021_31'	
			FETCH SP_CREATE_CIC21021_31 INTO :sPrcRtn ;
		Case 'CIC22021_32'	
			FETCH SP_CREATE_CIC22021_32 INTO :sPrcRtn ;
		Case 'CIC23021_33'	
			FETCH SP_CREATE_CIC23021_33 INTO :sPrcRtn ;
		Case 'CIC24021_34'	
			FETCH SP_CREATE_CIC24021_34 INTO :sPrcRtn ;
		Case 'CIC25021_35'	
			FETCH SP_CREATE_CIC25021_35 INTO :sPrcRtn ;
		Case 'CIC26021_36'	
			FETCH SP_CREATE_CIC26021_36 INTO :sPrcRtn ;
		Case Else
	End Choose
End If	

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[FETCH SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
	If as_gubun = '1' Then //����(����/�Ⱥ�)
		Choose Case as_prcid
			Case 'CIC20021'	
				CLOSE SP_CREATE_CIC20021;
			Case 'CIC21021'	
				CLOSE SP_CREATE_CIC21021;
			Case 'CIC22021'	
				CLOSE SP_CREATE_CIC22021;
			Case 'CIC23021'	
				CLOSE SP_CREATE_CIC23021;
			Case 'CIC24021'	
				CLOSE SP_CREATE_CIC24021;
			Case 'CIC25021'	
				CLOSE SP_CREATE_CIC25021;
			Case 'CIC26021'	
				CLOSE SP_CREATE_CIC26021;
			Case 'CIC27021'	
				CLOSE SP_CREATE_CIC27021;
			Case 'CIC28021'	
				CLOSE SP_CREATE_CIC28021;
			Case 'CIC29021'	
				CLOSE SP_CREATE_CIC29021;
			Case Else
		End Choose
	Else	//����(�Ⱥ�)
		Choose Case as_prcid
			Case 'CIC20021_21'	
				CLOSE SP_CREATE_CIC20021_21;
			Case 'CIC21021_31'	
				CLOSE SP_CREATE_CIC21021_31;
			Case 'CIC22021_32'	
				CLOSE SP_CREATE_CIC22021_32;
			Case 'CIC23021_33'	
				CLOSE SP_CREATE_CIC23021_33;
			Case 'CIC24021_34'	
				CLOSE SP_CREATE_CIC24021_34;
			Case 'CIC25021_35'	
				CLOSE SP_CREATE_CIC25021_35;
			Case 'CIC26021_36'	
				CLOSE SP_CREATE_CIC26021_36;
			Case Else
		End Choose
	End If	

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

If as_gubun = '1' Then //����(����/�Ⱥ�)
	Choose Case as_prcid
		Case 'CIC20021'	
			CLOSE SP_CREATE_CIC20021;
		Case 'CIC21021'	
			CLOSE SP_CREATE_CIC21021;
		Case 'CIC22021'	
			CLOSE SP_CREATE_CIC22021;
		Case 'CIC23021'	
			CLOSE SP_CREATE_CIC23021;
		Case 'CIC24021'	
			CLOSE SP_CREATE_CIC24021;
		Case 'CIC25021'	
			CLOSE SP_CREATE_CIC25021;
		Case 'CIC26021'	
			CLOSE SP_CREATE_CIC26021;
		Case 'CIC27021'	
			CLOSE SP_CREATE_CIC27021;
		Case 'CIC28021'	
			CLOSE SP_CREATE_CIC28021;
		Case 'CIC29021'	
			CLOSE SP_CREATE_CIC29021;
		Case Else
	End Choose
Else	//����(�Ⱥ�)
	Choose Case as_prcid
		Case 'CIC20021_21'	
			CLOSE SP_CREATE_CIC20021_21;
		Case 'CIC21021_31'	
			CLOSE SP_CREATE_CIC21021_31;
		Case 'CIC22021_32'	
			CLOSE SP_CREATE_CIC22021_32;
		Case 'CIC23021_33'	
			CLOSE SP_CREATE_CIC23021_33;
		Case 'CIC24021_34'	
			CLOSE SP_CREATE_CIC24021_34;
		Case 'CIC25021_35'	
			CLOSE SP_CREATE_CIC25021_35;
		Case 'CIC26021_36'	
			CLOSE SP_CREATE_CIC26021_36;
		Case Else
	End Choose
End If	

Return 1
end function

on w_cic01030.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_4=create gb_4
this.dw_1=create dw_1
this.dw_print=create dw_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.rr_1
end on

on w_cic01030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.rr_1)
end on

event open;call super::open;
string vWorkym
//��뱸�� Datawindows Child
dw_1.getChild('exp_gbn', idwc_exp_gbn)
idwc_exp_gbn.SettransObject(sqlca)
idwc_exp_gbn.Retrieve()
dw_1.SetTransObject(sqlca)
dw_1.Reset()
dw_1.InsertRow(0)
idwc_exp_gbn.InsertRow(1)
idwc_exp_gbn.SetItem(1,'rfna1','') //''�� �����ϸ� ��ü��ȸ�� ��ų ����
idwc_exp_gbn.SetItem(1,'rfgub','')

SELECT nvl(fun_get_aftermonth(max(workym), 1),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO :vWorkym
   FROM CIC0010
 WHERE  end_yn = 'Y';


dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

//dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
dw_1.SetItem(1, 'workym', vWorkym)
dw_1.SetFocus()

dw_1.SetItem(1, 'saupj', '10')

dw_2.SetTransObject(SQLCA)
//
//dw_2.ShareData(dw_print)
//dw_2.Reset()

wf_button_chk('C', 0)

//p_inq.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_cic01030
boolean visible = false
integer x = 41
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic01030
boolean visible = false
integer x = 5202
integer y = 184
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic01030
boolean visible = false
integer x = 5029
integer y = 184
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic01030
integer x = 3566
integer taborder = 20
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event p_search::clicked;call super::clicked;String sWorkym, sExp_gbn, snull 
Long   lRecCnt
SetNull(snull)
SetPointer(HourGlass!)


If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1,'[���س��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If



DECLARE SP_CREATE_CIC0100_SP PROCEDURE FOR CIC0100_SP (:sWorkym) USING SQLCA;
EXECUTE SP_CREATE_CIC0100_SP;
//STRING sPrcRtn
//FETCH SP_CREATE_CIC0100_SP INTO :sPrcRtn ;
CLOSE SP_CREATE_CIC0100_SP;
If SQLCA.SQLCODE < 0 Then
   f_message_chk(57, "~r~n~r~n[EXECUTE SP_CREATE_CIC0100_SP]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
else
   w_mdi_frame.sle_msg.text = "����ó���� �Ϸ��Ͽ����ϴ�."   
END IF

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_cic01030
integer x = 4087
integer taborder = 60
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\��ü����_d.gif"
end type

event p_ins::clicked;call super::clicked;String sWorkym, sSaupj, snull
Long	 lRowcnt, lRecCnt
SetNull(snull)

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���س��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

dw_1.Object.Saupj[1]
sSaupj = f_nvl(sSaupj, '%') 

String ls_workym, ls_workym_format
ls_workym = dw_1.Object.workym[1]
ls_workym_format = LEFT(dw_1.Object.workym[1],4) + '.' + RIGHT(dw_1.Object.workym[1],2)
IF MessageBox("�����Ȯ��", "���س��:" + ls_workym_format + "�� �ش� �ϴ� ��� �����͸� ���� �Ͻ� �ڽ��ϱ�? ", Question!, YesNo!,2) = 2 THEN
	RETURN
END IF


DELETE FROM CIC0100 WHERE workym = :ls_workym;
IF SQLCA.SQLCODE = 0 THEN
	COMMIT;
	dw_2.Retrieve(sWorkym, sSaupj)
	wf_button_chk('Q', lRowcnt)
	w_mdi_frame.sle_msg.text = "��ü���� �Ͽ����ϴ�.!!!"
ELSE
	ROLLBACK;
	w_mdi_frame.sle_msg.text = "���� ó���� ������ �߻��Ͽ����ϴ�.!!!"
   RETURN
END IF


end event

event p_ins::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ü����_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ü����_up.gif"
end event

type p_exit from w_inherite`p_exit within w_cic01030
integer x = 4434
end type

type p_can from w_inherite`p_can within w_cic01030
integer x = 4261
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
dw_1.SetFocus()

dw_2.Reset()
wf_button_chk('C', 0)

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_cic01030
boolean visible = false
integer x = 3397
integer taborder = 0
end type

event p_print::clicked;call super::clicked;iF dw_2.rowcount() > 0 then 

OpenWithParm(w_print_preview, dw_print)
end if
end event

type p_inq from w_inherite`p_inq within w_cic01030
integer x = 3739
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String sWorkym, sSaupj
Long	 lRowcnt

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If


sSaupj = dw_1.Object.Saupj[1]
sSaupj = f_nvl(sSaupj, '%') 

w_mdi_frame.sle_msg.Text = "��ȸ ���Դϴ�.!!!"
SetPointer(HourGlass!)
dw_2.SetRedraw(False)
lRowcnt = dw_2.Retrieve(sWorkym, sSaupj)
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
	
//	dw_2.sharedata(dw_print)
//	//dw_2.SetColumn('scr_amt')
//	dw_2.SetFocus()
	
End If

dw_2.SetRedraw(True)
w_mdi_frame.sle_msg.text = "��ȸ�� �Ϸ�Ǿ����ϴ�.!!!"
ib_any_typing = False
wf_button_chk('Q', lRowcnt)
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cic01030
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

type p_mod from w_inherite`p_mod within w_cic01030
integer x = 3913
end type

event p_mod::clicked;call super::clicked;String sWorkym, sSaupj, sIttyp, sItnbr

If dw_1.Accepttext() = -1 Then Return
If dw_2.AcceptText() = -1 Then Return

sWorkym   = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[���س��]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sSaupj = dw_1.GetItemString(1, 'saupj')

If dw_2.RowCount() <= 0 Then 
	w_mdi_frame.sle_msg.text = "ó���� �����Ͱ� �����ϴ�."
	Return
end if

If ib_any_typing = False Then
	MessageBox("�˸�", "����� �ڷᰡ �����ϴ�.!!!")
	Return 
End If	

////�ʼ��׸� üũ
//Integer  i
//w_mdi_frame.sle_msg.text =""
//FOR i = 1 TO dw_2.RowCount()
//	IF Wf_RequiredChk(i) = -1 THEN Return
//NEXT





long ll_iwol_amt, ll_iwol_qty //���ʱݾ�, ���ʼ���
long ll_ip_amt,   ll_ip_qty   //�԰�ݾ�, �԰����

long ll_wp_amt,   ll_wp_qty   //���ݾ�, ������
long ll_op_amt,   ll_op_qty   //���ݾ�, ������
long ll_ot_amt,   ll_ot_qty   //Ÿ��ݾ�, Ÿ�����
                     
dw_2.AcceptText()



long ll_x
FOR ll_x = 1 to dw_2.Rowcount()
    sIttyp = dw_2.Object.ittyp[ll_x]
    sItnbr = dw_2.Object.Itnbr[ll_x]
	 
    ll_iwol_amt = dw_2.Object.iwol_amt[ll_x]   //���ʱݾ�
    ll_iwol_qty = dw_2.Object.iwol_qty[ll_x]   //���ʼ���
    ll_ip_amt   = dw_2.Object.ip_amt  [ll_x]   //�԰�ݾ�
    ll_ip_qty   = dw_2.Object.ip_qty  [ll_x]   //�԰����                            
    ll_wp_amt   = dw_2.Object.wp_amt  [ll_x]   //���ݾ�
    ll_wp_qty   = dw_2.Object.wp_qty  [ll_x]   //������
    ll_op_amt   = dw_2.Object.op_amt  [ll_x]   //���ݾ�
    ll_op_qty   = dw_2.Object.op_qty  [ll_x]   //������
    ll_ot_amt   = dw_2.Object.ot_amt  [ll_x]   //Ÿ��ݾ�
    ll_ot_qty   = dw_2.Object.ot_qty  [ll_x]   //Ÿ�����
	 
    UPDATE CIC0100
    SET    IWOL_QTY = :LL_IWOL_QTY,
           IWOL_AMT = :LL_IWOL_AMT,
           IP_QTY   = :LL_IP_QTY,
           IP_AMT   = :LL_IP_AMT,
           OP_QTY   = :LL_OP_QTY,
           OP_AMT   = :LL_OP_AMT,
           WP_QTY   = :LL_WP_QTY,
           WP_AMT   = :LL_WP_AMT,
           OT_QTY   = :LL_OT_QTY,
           OT_AMT   = :LL_OT_AMT
    WHERE  WORKYM   = :sWorkym
    AND    SAUPJ    = :sSaupj
    AND    ITTYP    = :sIttyp
    AND    ITNBR    = :sItnbr;

	 IF SQLCA.SQLCODE <> 0 THEN 
		 ROLLBACK;
		 f_messagechk(13, '')
		 RETURN
	 END IF
NEXT
COMMIT;
ib_any_typing = False
wf_button_chk('S', 0)
w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�.!!!"


end event

type cb_exit from w_inherite`cb_exit within w_cic01030
integer x = 3026
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_cic01030
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

type cb_ins from w_inherite`cb_ins within w_cic01030
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

type cb_del from w_inherite`cb_del within w_cic01030
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

type cb_inq from w_inherite`cb_inq within w_cic01030
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

type cb_print from w_inherite`cb_print within w_cic01030
integer x = 1650
integer y = 2424
end type

type st_1 from w_inherite`st_1 within w_cic01030
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cic01030
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

type cb_search from w_inherite`cb_search within w_cic01030
integer x = 2053
integer y = 2432
end type

type dw_datetime from w_inherite`dw_datetime within w_cic01030
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cic01030
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cic01030
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cic01030
integer x = 110
integer y = 2696
end type

type gb_button2 from w_inherite`gb_button2 within w_cic01030
integer x = 2153
integer y = 2696
end type

type dw_2 from datawindow within w_cic01030
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 200
integer width = 4549
integer height = 2040
integer taborder = 90
string title = "����������� ����"
string dataobject = "dw_cic01030_20"
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

event editchanged;ib_any_typing = True
end event

event itemchanged;w_mdi_frame.sle_msg.text = ""
ib_any_typing = True


long ll_iwol_amt, ll_iwol_qty //���ʱݾ�, ���ʼ���
long ll_ip_amt,   ll_ip_qty   //�԰�ݾ�, �԰����

long ll_wp_amt,   ll_wp_qty   //���ݾ�, ������
long ll_op_amt,   ll_op_qty   //���ݾ�, ������
long ll_ot_amt,   ll_ot_qty   //Ÿ��ݾ�, Ÿ�����
                     
dw_2.AcceptText()

ll_iwol_amt = dw_2.Object.iwol_amt[row]   //���ʱݾ�
ll_iwol_qty = dw_2.Object.iwol_qty[row]   //���ʼ���
ll_ip_amt   = dw_2.Object.ip_amt  [row]   //�԰�ݾ�
ll_ip_qty   = dw_2.Object.ip_qty  [row]   //�԰����                            
ll_wp_amt   = dw_2.Object.wp_amt  [row]   //���ݾ�
ll_wp_qty   = dw_2.Object.wp_qty  [row]   //������
ll_op_amt   = dw_2.Object.op_amt  [row]   //���ݾ�
ll_op_qty   = dw_2.Object.op_qty  [row]   //������
ll_ot_amt   = dw_2.Object.ot_amt  [row]   //Ÿ��ݾ�
ll_ot_qty   = dw_2.Object.ot_qty  [row]   //Ÿ�����

if dwo.name='ip_amt' or dwo.name='ip_qty' then
	 ll_op_amt = ((ll_iwol_amt+ll_ip_amt) / (ll_iwol_qty+ll_ip_qty))  *  ll_op_qty  //���ݾ�
	 dw_2.Object.op_amt[row] = ll_op_amt
	 
	 ll_wp_amt = ll_iwol_amt + ll_ip_amt - ll_ot_amt                               //���ݾ�
	 dw_2.Object.wp_amt[row] = ll_wp_amt
	 
	 ll_wp_qty = ll_iwol_qty + ll_ip_qty - ll_ot_qty                               //������	 	 
	 dw_2.Object.wp_qty[row] = ll_wp_qty	 
	 
elseif dwo.name='wp_qty' then
	 ll_op_qty = ll_iwol_qty + ll_ip_qty - ll_ot_qty - ll_wp_qty                   //������
	 dw_2.Object.op_qty[row] = ll_op_qty
	 
	 ll_wp_amt = ((ll_iwol_amt+ll_ip_amt) / (ll_iwol_qty+ll_ip_qty))  *  ll_wp_qty //���ݾ�
	 dw_2.Object.wp_amt[row] = ll_wp_amt
	 
	 ll_op_amt = ll_iwol_amt + ll_ip_amt - ll_ot_amt - ll_wp_amt                   //���ݾ�
	 dw_2.Object.op_amt[row] = ll_op_amt
end if


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

//��ȸ�� ������ ������ ���� ��ư Ȱ��ȭ ��Ŵ
IF ROWCOUNT < 1 THEN 
	p_search.enabled = true
END IF

end event

event itemerror;Return 1
end event

event getfocus;This.AcceptText()
end event

event constructor;Object.DataWindow.HorizontalScrollSplit = 2126
end event

type gb_4 from groupbox within w_cic01030
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

type dw_1 from datawindow within w_cic01030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 20
integer width = 2299
integer height = 156
integer taborder = 10
string dataobject = "dw_cic01030_10"
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
		
//		If f_datechk(sWorkym + '01') = -1 Then 
//			f_messagechk(21, '[���]')
//			dw_1.SetItem(1, 'workym', snull)
//			Return 1
//		End If
	Case Else
		p_inq.TriggerEvent(Clicked!)
End Choose

end event

event itemerror;Return 1

end event

event getfocus;This.AcceptText()
end event

type dw_print from datawindow within w_cic01030
boolean visible = false
integer x = 2985
integer y = 28
integer width = 197
integer height = 120
integer taborder = 40
boolean bringtotop = true
string title = "������� ����"
string dataobject = "d_cic02100_1_p"
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cic01030
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

