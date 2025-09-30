$PBExportHeader$w_nsh_convert.srw
$PBExportComments$���ȣ ����� �ڷ� ��ȯȭ��
forward
global type w_nsh_convert from w_standard_print
end type
type cb_1 from commandbutton within w_nsh_convert
end type
type cb_2 from commandbutton within w_nsh_convert
end type
type dw_1 from datawindow within w_nsh_convert
end type
type rr_1 from roundrectangle within w_nsh_convert
end type
end forward

global type w_nsh_convert from w_standard_print
string title = "�ڷắȯ"
cb_1 cb_1
cb_2 cb_2
dw_1 dw_1
rr_1 rr_1
end type
global w_nsh_convert w_nsh_convert

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_list.SetRedraw(False)
dw_list.Retrieve()
dw_list.SetRedraw(True)

Return 1
end function

on w_nsh_convert.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_nsh_convert.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_nsh_convert
integer x = 3447
integer y = 28
boolean enabled = false
end type

type p_sort from w_standard_print`p_sort within w_nsh_convert
integer x = 3264
integer y = 24
boolean enabled = false
end type

type p_preview from w_standard_print`p_preview within w_nsh_convert
boolean visible = false
integer x = 4000
end type

type p_exit from w_standard_print`p_exit within w_nsh_convert
integer x = 4347
end type

type p_print from w_standard_print`p_print within w_nsh_convert
boolean visible = false
integer x = 4174
end type

type p_retrieve from w_standard_print`p_retrieve within w_nsh_convert
integer x = 3826
end type







type st_10 from w_standard_print`st_10 within w_nsh_convert
end type



type dw_print from w_standard_print`dw_print within w_nsh_convert
integer x = 3634
string dataobject = "d_nsh_convert02"
end type

type dw_ip from w_standard_print`dw_ip within w_nsh_convert
integer x = 37
integer width = 1883
integer height = 152
string dataobject = "d_nsh_convert01"
end type

type dw_list from w_standard_print`dw_list within w_nsh_convert
integer x = 50
integer y = 204
integer width = 4517
integer height = 2040
string dataobject = "d_nsh_convert02"
boolean border = false
end type

type cb_1 from commandbutton within w_nsh_convert
integer x = 1938
integer y = 28
integer width = 489
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȯ�ڷ� ����"
end type

event clicked;//Long		lXlrow, lCnt, lQty[], lTotal, lRow
//String		sPspec, sdepot, slotsno
//String		sWcdsc,  sItemnum, sItemname, sIspec, sOpdsc, sKumno, sQty, sTotal, sayu		// ȣ��-ǰ��-ǰ��-����-����-����...
//Integer 	i, j, k, iNotNullCnt
//Decimal{3} dQty
//string s_depot, s_crdate
//int    iseq

// Excel IMPORT ***************************************************************
Long   lValue
String sDocname
String sNamed
lValue = GetFileOpenName("�����ڷ� ��������", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

if dw_ip.AcceptText() = -1 then return  

//===========================================================================================
// UserObject ����
w_mdi_frame.sle_msg.text = "Now Excel File Uploading..."

uo_xlobject uo_xl
uo_xl = create uo_xlobject

// Excel Connecting
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

// Data ���� Row Setting (��)
// Excel ���� A:1 , B:2 �� ����
Long   lXlrow
Long   lCnt
lXlrow = dw_ip.GetItemNumber(1, 'rowno') // ����ڰ� ������ ��ġ���� ���� �о� ��.
lCnt   = 0

Long    i
Long    iNotNullCnt
Long    lInst
String  sSer
String  sItnbr
String  sQty
String  sAmt
String  sItn
Decimal dQty
Decimal dAmt

If MessageBox('���!', '���� �ڷ�� ���� �˴ϴ�.~r~n~r~n��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return

DELETE FROM DUMP_CONVERT ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	MessageBox('Error Return Code - ' + String(SQLCA.SQLCODE), 'Error Message~r~n~r~n' + SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA;
	MessageBox('����!', '���� �ڷ� ������ ���� �߽��ϴ�.')
	Return
End If

dw_list.SetRedraw(False)

Do While(True)
	
	// ����� ID(A,1)
	// Data�� ���� ��� �ش��ϴ� �������� �����ؾ߸� ���ڰ� ������ ����....������ �𸣰���....
	// �� 20�� ���� ����
	For i = 1 To 20
		uo_xl.uf_set_format(lXlrow, i, '@' + space(50))
	Next
	
	iNotNullCnt = 0		// �о���� ��(ǰ�� or ����)�� NULL �̸� Import ����
	
	sSer     = Trim(uo_xl.uf_gettext(lXlrow, 1))   //����
	sItnbr   = Trim(uo_xl.uf_gettext(lXlrow, 2))   //ǰ��
	sQty     = Trim(uo_xl.uf_gettext(lXlrow, 3))   //����
	sAmt     = Trim(uo_xl.uf_gettext(lXlrow, 4))   //�ݾ�
	
	if sItnbr > '.' then 
		iNotNullCnt++

		SELECT MAX(ITNBR)
		  INTO :sItn
		  FROM ITEMAS
		 WHERE REPLACE(ITNBR, '-', '') = REPLACE(:sItnbr, '-', '');
		if Isnull(sItn) then
			sItn = sItnbr
		end if
//		if sqlca.sqlcode <> 0 then
//			Messagebox('Ȯ��', sItnbr+' �� ��ϵ��� ���� ǰ���Դϴ�!!!')
//			uo_xl.uf_excel_Disconnect()
//			DESTROY uo_xl
//			return
//		end if
		
		w_mdi_frame.sle_msg.text = "Now Excel File Uploading... ("+String(lCnt)+") ..." + sItnbr
		
		dQty = Dec(sQty)
		dAmt = Dec(sAmt)
		
		lInst = dw_list.InsertRow(0)
		
		lCnt++
//		dw_list.SetItem(lInst, 'ser'  , sSer)
		dw_list.SetItem(lInst, 'ser'  , String(lCnt))
		dw_list.SetItem(lInst, 'itnbr', sItn)
		dw_list.SetItem(lInst, 'qty'  , dQty)
		dw_list.SetItem(lInst, 'amt'  , dAmt)
		
	end if
	
	// �ش� ���� � ������ ���� �������� �ʾҴٸ� ���� ������ �ν��ؼ� ����Ʈ ����
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()

// Excel IMPORT End ***************************************************************
dw_list.AcceptText()

DESTROY uo_xl

If dw_list.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('Sucess!', '�ڷ� ���� ����')
	
	MessageBox('Ȯ��',String(lCnt)+' ���� Data�� Import �Ͽ����ϴ�.')
	w_mdi_frame.sle_msg.text = ""
Else
	ROLLBACK USING SQLCA;
	MessageBox('Fail!', '�ڷ� ���� ����')
	Return
End If

dw_list.SetRedraw(True)
end event

type cb_2 from commandbutton within w_nsh_convert
integer x = 2523
integer y = 28
integer width = 603
integer height = 128
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ջ� �ڷ� �����ޱ�"
end type

event clicked;dw_1.SetRedraw(False)
dw_1.Retrieve()
dw_1.SetRedraw(True)

If dw_1.RowCount() < 1 Then
	MessageBox('�ڷ�Ȯ��', '��ȯ ��ų �ڷᰡ �����ϴ�.')
	Return
End If

If this.Enabled Then wf_excel_down(dw_1)

MessageBox('�ڷ�Ȯ��', '�ڷ� ��ȯ ����!')

end event

type dw_1 from datawindow within w_nsh_convert
boolean visible = false
integer x = 3858
integer y = 1816
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_nsh_convert03"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_nsh_convert
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 192
integer width = 4544
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

