$PBExportHeader$w_js_10010.srw
$PBExportComments$�ڻ����
forward
global type w_js_10010 from w_inherite
end type
type dw_1 from datawindow within w_js_10010
end type
type dw_print from datawindow within w_js_10010
end type
type dw_2 from datawindow within w_js_10010
end type
type cb_1 from commandbutton within w_js_10010
end type
type cb_3 from commandbutton within w_js_10010
end type
type cbx_1 from checkbox within w_js_10010
end type
type rr_1 from roundrectangle within w_js_10010
end type
type rr_2 from roundrectangle within w_js_10010
end type
end forward

global type w_js_10010 from w_inherite
boolean visible = false
integer width = 4677
integer height = 2752
string title = "�ڻ��������"
dw_1 dw_1
dw_print dw_print
dw_2 dw_2
cb_1 cb_1
cb_3 cb_3
cbx_1 cbx_1
rr_1 rr_1
rr_2 rr_2
end type
global w_js_10010 w_js_10010

type variables
String is_com
end variables

forward prototypes
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end subroutine

on w_js_10010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_print=create dw_print
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_js_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetItem(1, 'yymm', String(TODAY(), 'yyyymm'))
end event

type dw_insert from w_inherite`dw_insert within w_js_10010
integer x = 50
integer y = 200
integer width = 4526
integer height = 2032
string dataobject = "d_js_10010_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_js_10010
boolean visible = false
integer x = 2112
integer y = 32
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_js_10010
boolean visible = false
integer x = 1938
integer y = 32
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_js_10010
integer x = 3520
string picturename = "C:\ERPMAN\image\from_excel.gif"
end type

event p_search::clicked;call super::clicked;String ls_yymm

ls_yymm = dw_1.GetItemString(1, 'yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���س� Ȯ��', '���س��� �Է��Ͻʽÿ�.')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	Return
End If

String ls_gbn

ls_gbn = dw_1.GetItemString(1, 'gubun')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = '%'

String ls_name

Choose Case ls_gbn
	Case 'P'
		ls_name = '����'
	Case 'O'
		ls_name = '�ؿܰ���'
	Case 'T'
		ls_name = '���������'
	Case 'D'
		ls_name = '��ǰ����'
	Case 'R'
		ls_name = '����'
	Case 'M'
		ls_name = '����'
	Case 'S'
		ls_name = '����'
	Case 'Q'
		ls_name = 'ǰ��'
	Case '%'
		ls_name = '��ü'
End Choose

//�����ڷ� ����
If MessageBox('�����ڷ� ���� ����', '���� �ڷᰡ ������ ��� �����ϰ� �����մϴ�.~r~n' + ls_name + &
                                    ' �� ������ ��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return

DELETE FROM JASAN
 WHERE YYMM               =    :ls_yymm
   AND SUBSTR(JSNO, 3, 1) LIKE :ls_gbn  ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('�ڷ� ���� ����', '���� �ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If

// �׼� IMPORT *******************************************************************************
Long   lValue
String sDocname
String sNamed
lValue = GetFileOpenName('���ϼ���', sDocname, sNamed, 'XLS', 'XLS Files (*.XLS),*.XLS')
If lValue <> 1 Then Return -1         

Setpointer(Hourglass!)

////===========================================================================================
////UserObject ����
uo_xlobject		uo_xl

w_mdi_frame.sle_msg.text = 'Excel Upload Reading...'
uo_xl = create uo_xlobject

//������ ����
uo_xl.uf_excel_connect(sDocname, False , 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting (��)
//Excel ���� A: 1 , B :2 �� ����
SetNull(gs_code)

Open(w_js_10010_pop)
If gs_code = 'x' Then
	MessageBox('Excel Row Select', '�������� �����Ͻʽÿ�.')
	Return
ElseIf gs_code = 'z' Then
	Return
End If

Long   lXlrow
lXlrow = Long(gs_code)		// 2��° �� ���� ����

Long   iNotNullCnt
Long   i
Long   ll_ins
Long   lCnt
Long   ll_dup
String ls_jsno, ls_itdsc, ls_spec, ls_cvnas, ls_gudat, ls_dyear, ls_jung, ls_boo, ls_bigo

Do While(True)
	
	iNotNullCnt = 0
	
	// ����� ID(A,1)
	// Data�� ���� ��� �ش��ϴ� �������� �����ؾ߸� ���ڰ� ������ ����....������ �𸣰���....
	// �� 36�� ���� ����
	For i =1 To 10
		uo_xl.uf_set_format(lXlrow, i, '@' + space(50))
	Next
	
	ls_jsno  = Trim(uo_xl.uf_gettext(lXlrow, 2) )  //�ڻ��ȣ
	ls_itdsc = Trim(uo_xl.uf_gettext(lXlrow, 3) )  //ǰ��
	ls_spec  = Trim(uo_xl.uf_gettext(lXlrow, 4) )  //�԰�
	ls_cvnas = Trim(uo_xl.uf_gettext(lXlrow, 5) )  //����ó
	ls_gudat = Trim(uo_xl.uf_gettext(lXlrow, 6) )  //��������
	ls_dyear = Trim(uo_xl.uf_gettext(lXlrow, 7) )  //������
	ls_jung  = Trim(uo_xl.uf_gettext(lXlrow, 8) )  //����å����(��)
	ls_boo   = Trim(uo_xl.uf_gettext(lXlrow, 9) )  //����å����(��)
	ls_bigo  = Trim(uo_xl.uf_gettext(lxlrow, 10))  //���
	
	/* �ڻ��ȣ �������� - (X-X-XXX) */
	SELECT REPLACE(:ls_jsno, ' ', '')
	  INTO :ls_jsno
	  FROM DUAL ;
	  
	/* �������� ���� - (yyyymmdd) */
	SELECT REPLACE(:ls_gudat, '.', '')
	  INTO :ls_gudat
	  FROM DUAL ;
	  
	/* ��, �� �̸��� �������� */
	SELECT REPLACE(:ls_jung, ' ', ''), REPLACE(:ls_boo, ' ', '')
	  INTO :ls_jung                  , :ls_boo
	  FROM DUAL ;
	 
	If Trim(ls_jsno) = '' OR IsNull(ls_jsno) Then
		Exit
	Else
		SELECT COUNT('X')
		  INTO :ll_dup
		  FROM JASAN
		 WHERE YYMM = :ls_yymm
		   AND JSNO = :ls_jsno ;
		If ll_dup > 0 Then
			MessageBox('�ߺ�Ȯ��', LEFT(ls_yymm, 4) + '�� ' + ls_jsno + '�� �ڻ��ȣ�� �ߺ��Դϴ�.~r~n' + &
			                       '�ش� �ڻ��ڷ�� ���� �ǰ� ��� �����մϴ�.')
		Else
				
			iNotNullCnt++
			ll_ins = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_ins, 'yymm'  , ls_yymm )  //�ۼ��⵵
			dw_insert.SetItem(ll_ins, 'jsno'  , ls_jsno )  //�ڻ��ȣ
			dw_insert.SetItem(ll_ins, 'itdsc' , ls_itdsc)  //�ڻ��
			dw_insert.SetItem(ll_ins, 'spec'  , ls_spec )  //�ڻ�԰�
			dw_insert.SetItem(ll_ins, 'cvnas' , ls_cvnas)  //����ó
			dw_insert.SetItem(ll_ins, 'gudat' , ls_gudat)  //������
			dw_insert.SetItem(ll_ins, 'dyear' , ls_dyear)  //���뿬��
			dw_insert.SetItem(ll_ins, 'adminj', ls_jung )  //������-��
			dw_insert.SetItem(ll_ins, 'adminb', ls_boo  )  //������-��
			dw_insert.SetItem(ll_ins, 'bigo'  , ls_bigo )  //���
			
			lCnt++
		End If
	End If
	
	// �ش� ���� � ������ ���� �������� �ʾҴٸ� ���� ������ �ν��ؼ� ����Ʈ ����
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()

//// IMPORT  END ***************************************************************
dw_insert.AcceptText()

MessageBox('Ȯ��', String(lCnt) + ' ���� DATA IMPORT�� �Ϸ��Ͽ����ϴ�.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl

p_mod.PostEvent('Clicked')
end event

event p_search::ue_lbuttondown;//

end event

event p_search::ue_lbuttonup;//

end event

type p_ins from w_inherite`p_ins within w_js_10010
boolean visible = false
integer x = 1765
integer y = 32
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_js_10010
integer x = 4389
end type

type p_can from w_inherite`p_can within w_js_10010
integer x = 4215
end type

type p_print from w_inherite`p_print within w_js_10010
integer x = 3694
end type

event p_print::clicked;//
OpenWithParm(w_print_preview, dw_print)
end event

type p_inq from w_inherite`p_inq within w_js_10010
integer x = 3867
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

String ls_yymm

ls_yymm = dw_1.GetItemString(1, 'yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���س�� Ȯ��', '���س���� �Է��Ͻʽÿ�.')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	Return
End If

String ls_gub

ls_gub = dw_1.GetItemString(1, 'gubun')
If Trim(ls_gub) = '' OR IsNull(ls_gub) Then ls_gub = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_yymm, ls_gub)
dw_insert.setRedraw(True)

If dw_insert.RowCount() > 0 Then
	dw_insert.ShareData(dw_print)
End If

end event

type p_del from w_inherite`p_del within w_js_10010
boolean visible = false
integer x = 2459
integer y = 32
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_js_10010
integer x = 4041
end type

event p_mod::clicked;call super::clicked;If f_msg_update() <> 1 Then Return

dw_insert.AcceptText()

Long   i
String ls_yymm
String ls_jsno

For i = 1 To dw_insert.RowCount()
	ls_yymm = dw_insert.GetItemString(i, 'yymm')
	If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
		MessageBox('�ʼ� Ȯ��', '���س� Ȯ�� �ٶ��ϴ�.' + '~r~n' + String(i) + '���� ���س� �� ����')
		dw_insert.SetColumn('yymm')
		dw_insert.SetFocus()
		dw_insert.SetRow(i)
		Return
	End If
	
	ls_jsno = dw_insert.GetItemString(i, 'jsno')
	If Trim(ls_jsno) = '' OR IsNull(ls_jsno) Then
		MessageBox('�ʼ� Ȯ��', '�ڻ��ȣ Ȯ�� �ٶ��ϴ�.' + '~r~n' + String(i) + '���� �ڻ��ȣ �� ����')
		dw_insert.SetColumn('jsno')
		dw_insert.SetFocus()
		dw_insert.SetRow(i)
		Return
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('���� ����', '�ڷ� ���忡 ���� �߽��ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('���� ����', '�ڷ� ������ ������ �߻��߽��ϴ�.')
	Return
End If

end event

type cb_exit from w_inherite`cb_exit within w_js_10010
end type

type cb_mod from w_inherite`cb_mod within w_js_10010
end type

type cb_ins from w_inherite`cb_ins within w_js_10010
end type

type cb_del from w_inherite`cb_del within w_js_10010
end type

type cb_inq from w_inherite`cb_inq within w_js_10010
end type

type cb_print from w_inherite`cb_print within w_js_10010
end type

type st_1 from w_inherite`st_1 within w_js_10010
end type

type cb_can from w_inherite`cb_can within w_js_10010
end type

type cb_search from w_inherite`cb_search within w_js_10010
end type







type gb_button1 from w_inherite`gb_button1 within w_js_10010
end type

type gb_button2 from w_inherite`gb_button2 within w_js_10010
end type

type dw_1 from datawindow within w_js_10010
integer x = 73
integer y = 52
integer width = 1129
integer height = 100
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_js_10010_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type dw_print from datawindow within w_js_10010
boolean visible = false
integer x = 2747
integer y = 32
integer width = 114
integer height = 88
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_js_10010_005"
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_js_10010
boolean visible = false
integer x = 50
integer y = 200
integer width = 4475
integer height = 2028
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "�����ȹ ����"
string dataobject = "bom"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_js_10010
boolean visible = false
integer x = 1312
integer y = 48
integer width = 279
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ret"
end type

event clicked;dw_2.SetTransObject(SQLCA)

dw_2.SetRedraw(False)
dw_2.Retrieve()
dw_2.SetRedraw(True)

Long   i, ll_lev, ll_mmqty, s, l, ll_upqty, ll_find, ll_cnt, ss
String ls_itnbr, ls_pinbr, ls_cinbr, ls_getp, ls_getc
Dec    ldc_qtypr

String ls_null
Long   ll_null
SetNull(ls_null)
SetNull(ll_null)

ll_cnt = dw_2.RowCount()

For i = 1 To ll_cnt
	ls_itnbr = dw_2.GetItemString(i, 'itnbr')
	ls_pinbr = dw_2.GetItemString(i, 'pinbr')
	ls_cinbr = dw_2.GetItemString(i, 'cinbr')
	ll_lev  = dw_2.GetItemNumber(i, 'level')
	ll_mmqty  = dw_2.GetItemNumber(i, 'mmqty')
	ldc_qtypr = dw_2.GetItemDecimal(i, 'qtypr')
	
	l = i - 1
	
	ll_find = dw_2.Find("cinbr='" + ls_cinbr + "'", 1, l)
	If ll_find < 1 Then
	Else
		dw_2.SetItem(i, 'safc', ll_null)
		dw_2.SetItem(i, 'cjgo', ll_null)
	End If
		
	If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	Else
		s = i
	End If
	
	If ll_lev = 1 Then
		dw_2.SetItem(i, 'pnqty', ldc_qtypr * ll_mmqty)
		
		l  = i - 1
		If i = 1 Then
			Continue
		Else
			ss = 1
		End If
		
		ll_find = dw_2.Find("itnbr='" + ls_itnbr + "'", ss, l)
		If ll_find < 1 Then Continue
		
		dw_2.SetItem(i, 'itnbr', ls_null)
		dw_2.SetItem(i, 'mmqty', ll_null)
		dw_2.SetItem(i, 'prcw' , ll_null)
		dw_2.SetItem(i, 'safp' , ll_null)
		dw_2.SetItem(i, 'pjgo' , ll_null)
	Else
		l = i
		
		ll_find = dw_2.Find("cinbr='" + ls_pinbr + "'", s, l - 1)
		If ll_find < 1 Then Continue
		
		ll_upqty = dw_2.GetItemNumber(ll_find, 'pnqty')
		
		dw_2.SetItem(i, 'pnqty', ldc_qtypr * ll_upqty)
	End If
Next


end event

type cb_3 from commandbutton within w_js_10010
boolean visible = false
integer x = 2368
integer y = 92
integer width = 402
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "xls"
end type

event clicked;If this.Enabled Then wf_excel_down(dw_2)
end event

type cbx_1 from checkbox within w_js_10010
boolean visible = false
integer x = 2976
integer y = 60
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
string text = "�����ȹ ����"
end type

event constructor;If gs_empno = '1296' Then
	This.Visible = True
End If

end event

event clicked;If This.Checked Then	
	cb_1.Visible = True
	cb_3.Visible = True
	dw_2.Visible = True
Else	
	cb_1.Visible = False
	cb_3.Visible = False
	dw_2.Visible = False
End If
end event

type rr_1 from roundrectangle within w_js_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 188
integer width = 4553
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_js_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 28
integer width = 1225
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

