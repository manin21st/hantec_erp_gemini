$PBExportHeader$w_mat_03530_han.srw
$PBExportComments$������-ȸ�����
forward
global type w_mat_03530_han from w_inherite
end type
type dw_1 from datawindow within w_mat_03530_han
end type
type dw_2 from datawindow within w_mat_03530_han
end type
type cb_1 from commandbutton within w_mat_03530_han
end type
type rr_1 from roundrectangle within w_mat_03530_han
end type
end forward

global type w_mat_03530_han from w_inherite
string title = "������"
dw_1 dw_1
dw_2 dw_2
cb_1 cb_1
rr_1 rr_1
end type
global w_mat_03530_han w_mat_03530_han

on w_mat_03530_han.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_mat_03530_han.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_yymm', String(TODAY(), 'yyyymm'))
end event

event open;call super::open;This.PostEvent('ue_open')
end event

type dw_insert from w_inherite`dw_insert within w_mat_03530_han
integer x = 46
integer y = 308
integer width = 4530
integer height = 1928
string dataobject = "d_mat_03530_han_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;Long   ll_row
If ll_row < 1 Then Return

Choose Case This.GetColumnName()
	Case 'stockmonth_han_gqty', 'stockmonth_han_iqty', 'stockmonth_han_oqty'
		Double ldb_gqty
		Double ldb_iqty
		Double ldb_oqty
		Double ldb_jqty
		
		ldb_gqty = This.GetItemNumber(ll_row, 'stockmonth_han_gqty')
		ldb_iqty = This.GetItemNumber(ll_row, 'stockmonth_han_iqty')
		ldb_oqty = This.GetItemNumber(ll_row, 'stockmonth_han_oqty')
		ldb_jqty = (ldb_gqty + ldb_iqty) - ldb_oqty
		
	Case 'gamt', 'iamt', 'oamt'
		Double ldb_gamt
		Double ldb_iamt
		Double ldb_oamt
		Double ldb_jamt
		
		ldb_gamt = This.GetItemNumber(ll_row, 'gamt')
		ldb_iamt = This.GetItemNumber(ll_row, 'iamt')
		ldb_oamt = This.GetItemNumber(ll_row, 'oamt')
		ldb_jamt = (ldb_gamt + ldb_iamt) - ldb_oamt
End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
end event

type p_delrow from w_inherite`p_delrow within w_mat_03530_han
boolean visible = false
integer x = 3515
integer y = 156
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_03530_han
boolean visible = false
integer x = 3342
integer y = 156
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_03530_han
integer x = 3442
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::ue_lbuttondown;//
PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;//
PictureName = "C:\erpman\image\����_up.gif"
end event

event p_search::clicked;call super::clicked;Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_yymm

ls_yymm = dw_1.GetItemString(row, 'd_yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���� �� Ȯ��', '���� ���� �ʼ� �׸��Դϴ�.')
	dw_1.SetColumn('d_yymm')
	dw_1.SetFocus()
	Return
End If

Long   ll_chk
SELECT COUNT('X')
  INTO :ll_chk
  FROM STOCKMONTH_HAN
 WHERE STOCK_YYMM = :ls_yymm ;
If ll_chk > 0 Then
	If MessageBox('�ڷ� Ȯ��', '�ش� ���� �ڷ�� �̹� �����Ǿ� �ֽ��ϴ�.~r~n~n����Ͻø� ���� �ڷ�� �����˴ϴ�. ��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return
	DELETE STOCKMONTH_HAN
	 WHERE STOCK_YYMM = :ls_yymm ;
	If SQLCA.SQLCODE = 0 Then 
		COMMIT USING SQLCA;
	Else
		ROLLBACK USING SQLCA;
		MessageBox('�ڷ� ���� Ȯ��', '���� �ڷ� ���� �� ������ �߻��߽��ϴ�.')
		Return
	End If 
Else
	If MessageBox('�ڷ� ���� ����', '�ش� ���� �ڷḦ ���� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return
End If

dw_2.SetRedraw(False)
dw_2.Retrieve(ls_yymm)
dw_2.SetRedraw(True)

Long   ll_cnt

ll_cnt = dw_2.RowCount()
If ll_cnt < 1 Then Return

Long   i

String ls_depot
String ls_itnbr
String ls_pspec

Double ldb_sdan
Double ldb_edan
Double ldb_jqty
Double ldb_iqty
Double ldb_oqty
Double ldb_jjqty
Double ldb_jamt
Double ldb_iamt
Double ldb_oamt
Double ldb_jjamt

Double ldb_jqty_re
Double ldb_jamt_re

String ls_yymm_re
//������ ���� ������ �������� ����
ls_yymm_re = String(RelativeDate(Date(LEFT(ls_yymm, 4) + '.' + RIGHT(ls_yymm, 2) + '.' + '01'), -1), 'yyyymm')

SetNull(ll_chk)
SELECT COUNT('X')
  INTO :ll_chk
  FROM STOCKMONTH_HAN
 WHERE STOCK_YYMM = :ls_yymm_re ;

String ls_chk

For i = 1 To ll_cnt
	ls_depot  = dw_2.GetItemString(i, 'depot_no') //â��
	ls_itnbr  = dw_2.GetItemString(i, 'itnbr'   ) //ǰ��
	ls_pspec  = dw_2.GetItemString(i, 'pspec'   ) //���
	
	ldb_sdan  = dw_2.GetItemNumber(i, 'sdanga'  ) //�ܰ�
	ldb_edan  = dw_2.GetItemNumber(i, 'edanga'  ) //�ܰ�
	
	If ll_chk > 0 Then
		
		/* ���� ���� ���� ������, ���ݾ� */
		SELECT 'Y'    , JQTY        , JAMT
		  INTO :ls_chk, :ldb_jqty_re, :ldb_jamt_re
		  FROM STOCKMONTH_HAN
		 WHERE STOCK_YYMM = :ls_yymm_re
			AND DEPOT_NO   = :ls_depot
			AND ITNBR      = :ls_itnbr
			AND PSPEC      = :ls_pspec ;
		
		/* ����� */
		/* ���� ���� �˻��ؼ� ���� �� �ڷᰡ ���� ��� �ش� ���� �̿��ݾ� �� �̿��������� ���� */
		/* ���� ���� �˻��ؼ� �ڷᰡ ���� ��� �ش� ���� ����(������-NEW ����)�ڷ�� ���� */
		
		If ls_chk = 'Y' Then
			ldb_jqty = ldb_jqty_re
			ldb_jamt = ldb_jamt_re
		Else
			ldb_jqty = 0
			ldb_jamt = 0
		End If
		
	Else
		ldb_jqty  = dw_2.GetItemNumber(i, 'jqty'    ) //�̿�
		ldb_jamt  = ldb_jqty  * ldb_sdan  //�̿���
	End If	
	
	ldb_iqty  = dw_2.GetItemNumber(i, 'iqty'    ) //�԰�
	ldb_oqty  = dw_2.GetItemNumber(i, 'oqty'    ) //���
//	ldb_jjqty = dw_2.GetItemNumber(i, 'jjqty'   ) //���
	ldb_jjqty = (ldb_jqty + ldb_iqty) - ldb_oqty //���
	ldb_iamt  = ldb_iqty  * ldb_edan  //�԰��
	ldb_oamt  = ldb_oqty  * ldb_edan  //����
//	ldb_jjamt = ldb_jjqty * ldb_edan  //����
	ldb_jjamt = (ldb_jamt + ldb_iamt) - ldb_oamt //����
	
	INSERT INTO STOCKMONTH_HAN
	       ( STOCK_YYMM, DEPOT_NO, ITNBR, PSPEC, GQTY, GAMT,
			   IQTY      , IAMT    , OQTY , OAMT , JQTY, JAMT )
	VALUES ( :ls_yymm , :ls_depot, :ls_itnbr, :ls_pspec, :ldb_jqty , :ldb_jamt ,
	         :ldb_iqty, :ldb_iamt, :ldb_oqty, :ldb_oamt, :ldb_jjqty, :ldb_jjamt ) ;
   If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('�ڷ� ���� Ȯ��', '�ڷ� ���� �� ������ �߻��߽��ϴ�.~r~n~n����Ƿ� ���� �Ͻʽÿ�.')
		Return
	End If
	
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('�ڷ� ����', '�ڷᰡ ���������� ���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('�ڷ� ���� Ȯ��', '�ڷ� ���� �� ������ �߻��߽��ϴ�.~r~n~n����Ƿ� ���� �Ͻʽÿ�.')
	Return
End If

end event

type p_ins from w_inherite`p_ins within w_mat_03530_han
boolean visible = false
integer x = 3168
integer y = 156
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mat_03530_han
integer x = 4416
end type

type p_can from w_inherite`p_can within w_mat_03530_han
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_2.ReSet()
dw_insert.ReSet()

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_mat_03530_han
boolean visible = false
integer x = 2994
integer y = 156
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mat_03530_han
integer x = 3721
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return -1

String ls_yymm

ls_yymm = dw_1.GetItemString(row, 'd_yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���� �� Ȯ��', '���� ���� �ʼ� �׸��Դϴ�.')
	dw_1.SetColumn('d_yymm')
	dw_1.SetFocus()
	Return -1
End If

String ls_sitn
String ls_eitn

ls_sitn = dw_1.GetItemString(row, 'sitnbr')
If Trim(ls_sitn) = '' OR IsNull(ls_sitn) Then ls_sitn = '.'

ls_eitn = dw_1.GetItemString(row, 'eitnbr')
If Trim(ls_eitn) = '' OR IsNull(ls_eitn) Then ls_eitn = 'ZZZZZZZZZZZZZZZZZZZZ'

String ls_ittyp

ls_ittyp = dw_1.GetItemString(row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

String ls_depot

ls_depot = dw_1.GetItemString(row, 'scvcod')
If Trim(ls_depot) = '' OR IsNull(ls_depot) Then ls_depot = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_yymm, ls_depot, ls_sitn, ls_eitn, ls_ittyp)
dw_insert.SetRedraw(True)

If dw_insert.RowCount() < 1 Then
	MessageBox('�ڷ���ȸ Ȯ��', '��ȸ�� �ڷᰡ �����ϴ�.')
	Return -1
End If

end event

type p_del from w_inherite`p_del within w_mat_03530_han
integer x = 4069
end type

event p_del::clicked;call super::clicked;dw_1.AcceptText()

Long   row
row = dw_1.GetRow()
If row < 1 Then Return

String ls_yymm

ls_yymm = dw_1.GetItemString(row, 'd_yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���� �� Ȯ��', '���� ���� �ʼ� �׸� �Դϴ�.')
	dw_1.SetColumn('d_yymm')
	dw_1.SetFocus()
	Return
End If

If f_msg_delete() <> 1 Then Return

Long   ll_cnt
SELECT COUNT('X')
  INTO :ll_cnt
  FROM STOCKMONTH_HAN
 WHERE STOCK_YYMM = :ls_yymm ;
If ll_cnt < 1 OR IsNull(ll_cnt) Then
	MessageBox('���� �ڷ� Ȯ��', '�ش� ���� ���� �� �ڷᰡ �����ϴ�.')
	Return
End If

DELETE STOCKMONTH_HAN
 WHERE STOCK_YYMM = :ls_yymm ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('���� ����', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If
end event

type p_mod from w_inherite`p_mod within w_mat_03530_han
integer x = 3895
end type

event p_mod::clicked;call super::clicked;If f_msg_update() <> 1 Then Return

If dw_insert.ModifiedCount() < 1 Then Return

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('���� ����', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.')
	Return
End If

end event

type cb_exit from w_inherite`cb_exit within w_mat_03530_han
end type

type cb_mod from w_inherite`cb_mod within w_mat_03530_han
end type

type cb_ins from w_inherite`cb_ins within w_mat_03530_han
end type

type cb_del from w_inherite`cb_del within w_mat_03530_han
end type

type cb_inq from w_inherite`cb_inq within w_mat_03530_han
end type

type cb_print from w_inherite`cb_print within w_mat_03530_han
end type

type st_1 from w_inherite`st_1 within w_mat_03530_han
end type

type cb_can from w_inherite`cb_can within w_mat_03530_han
end type

type cb_search from w_inherite`cb_search within w_mat_03530_han
end type







type gb_button1 from w_inherite`gb_button1 within w_mat_03530_han
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03530_han
end type

type dw_1 from datawindow within w_mat_03530_han
integer x = 32
integer y = 28
integer width = 2299
integer height = 268
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03530_han_001"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'sitnbr'
		Open(w_itemas_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'sitnbr', gs_code)
		This.SetItem(row, 'eitnbr', gs_code)
		
	Case 'eitnbr'
		Open(w_itemas_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'eitnbr', gs_code)
		
End Choose
end event

event itemchanged;If row < 1 Then Return

Long   ll_chk

Choose Case dwo.name
	Case 'sitnbr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'eitnbr', data)
			Return
		End If
		
		SELECT COUNT('X')
		  INTO :ll_chk
		  FROM ITEMAS
		 WHERE SABU  = '1'
		   AND ITNBR = :data ;
		If ll_chk < 1 OR IsNull(ll_chk) Then
			MessageBox('ǰ��Ȯ��', '�� ��ϵ� ǰ���Դϴ�.')
			Return
		End If
		
		This.SetItem(row, 'eitnbr', data)
		
	Case 'eitnbr'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		SELECT COUNT('X')
		  INTO :ll_chk
		  FROM ITEMAS
		 WHERE SABU  = '1'
		   AND ITNBR = :data ;
		If ll_chk < 1 OR IsNull(ll_chk) Then
			MessageBox('ǰ��Ȯ��', '�� ��ϵ� ǰ���Դϴ�.')
			Return
		End If
End Choose
end event

type dw_2 from datawindow within w_mat_03530_han
boolean visible = false
integer x = 3735
integer y = 172
integer width = 146
integer height = 108
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03530_han_003"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_mat_03530_han
integer x = 2354
integer y = 32
integer width = 485
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "Excel Up-Load"
end type

event clicked;dw_1.AcceptText()

Long   row
row = dw_1.GetRow()
If row < 1 Then Return

String ls_day

ls_day = dw_1.GetItemString(row, 'd_yymm')
If Trim(ls_day) = '' OR IsNull(ls_day) Then
	MessageBox('���� �� Ȯ��', '���� ���� Ȯ�� �Ͻʽÿ�.')
	dw_1.Setcolumn('d_yymm')
	dw_1.SetFocus()
	Return
End If

Long   ll_rowcnt

ll_rowcnt = dw_insert.RowCount()

Long   ll_dbchk
SELECT COUNT('X')
  INTO :ll_dbchk
  FROM STOCKMONTH_HAN A,
       ITEMAS         B
 WHERE A.STOCK_YYMM =  :ls_day
   AND A.ITNBR      <> '������'
   AND A.ITNBR      =  B.ITNBR ;
If ll_dbchk <> ll_rowcnt Then
	MessageBox('�ڷ�Ȯ��' , '�ڷ� ��ȸ �� ���� �Ͻʽÿ�.')
	Return 
End If

// �׼� IMPORT *****************************************************************************************
Long   ll_value

String ls_doc
String ls_file

ll_value = GetFileOpenName('�����ڷ� ��������', ls_doc, ls_file, 'XLS', 'XLS Files (*.XLS), *.XLS,')
If ll_value <> 1 Then Return

Setpointer(Hourglass!)

//UserObject ����
w_mdi_frame.sle_msg.text = 'Excel Up-Load �غ� ��...'

uo_xlobject uo_xl
uo_xl = create uo_xlobject

//������ ����
uo_xl.uf_excel_connect(ls_doc, False , 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting (��)
//Excel ���� A: 1 , B :2 �� ����
Long   ll_xrow
Long   ll_cnt
ll_xrow = 2 // ù ��带 �����ϰ� �� ��° �� ���� ����
ll_cnt  = 0

Long   i
Long   ll_chk
Long   ll_true
Long   ll_find
Long   ll_ins

String ls_itnbr
String ls_depot
String ls_date
String ls_pspec

Double ldb_gqty
Double ldb_gamt

Do While(True)
	/* ����� ID(A, 1)
	   Data�� ���� ��� �ش��ϴ� �� ������ �����ؾ߸� Font�� ������ ����
	   �� 13�� ���� ���� */
	For i = 1 To 13
		uo_xl.uf_set_format(ll_xrow, i, '@' + Space(50))
	Next
	
	ll_chk = 0
	
	ls_itnbr = UPPER(Trim(uo_xl.uf_gettext(ll_xrow, 3)))  //ǰ��
	
	//ǰ���Է��� �Ǹ� ����
	If Trim(ls_itnbr) > '.' Then
		ll_chk++
		
		SELECT COUNT('x')
		  INTO :ll_true
		  FROM ITEMAS
		 WHERE SABU  = '1'
		   AND ITNBR = :ls_itnbr ;
		If ll_true < 1 OR IsNull(ll_true) Then
			MessageBox('ǰ�� Ȯ��', ls_itnbr + ' ǰ���� ��� ���� ���� ǰ�� �Դϴ�!')
			Return
		End If
		
		w_mdi_frame.sle_msg.text = 'Excel Up-Load ���� ��.. (' + String(ll_cnt) + ')...' + ls_itnbr
	
		ls_date  = Trim(uo_xl.uf_gettext(ll_xrow, 1))         //���� ��
		ls_depot = UPPER(Trim(uo_xl.uf_gettext(ll_xrow, 2)))  //â��
		ls_pspec = Trim(uo_xl.uf_gettext(ll_xrow, 5))         //���
		
		ldb_gqty = Long(Trim(uo_xl.uf_gettext(ll_xrow, 6))) //�̿�����
		ldb_gamt = Long(Trim(uo_xl.uf_gettext(ll_xrow, 7))) //�̿��ݾ�
		
		If Trim(ls_date) = '' OR IsNull(ls_date) Then
			MessageBox('���� �� Ȯ��', '���� ���� ���� �Ǿ����ϴ�.')
			Return
		End If
		
		If Trim(ls_depot) = '' OR IsNull(ls_depot) Then
			MessageBox('â�� Ȯ��', 'â�� ���� �Ǿ����ϴ�.')
			Return
		End If
		
		If Trim(ls_pspec) = '' OR IsNull(ls_pspec) Then ls_pspec = '.'
		
		ll_find = dw_insert.FIND("stockmonth_han_stock_yymm = '" + ls_date  + "' and " + &
		                         "stockmonth_han_depot_no = '"   + ls_depot + "' and " + &
										 "stockmonth_han_itnbr = '"      + ls_itnbr + "' and " + &
										 "stockmonth_han_pspec = '"      + ls_pspec + "'", 1, dw_insert.RowCount())
		If ll_find < 1 Then
			ll_find = dw_insert.InsertRow(0)
			dw_insert.SetItem(ll_find, 'stockmonth_han_stock_yymm', ls_date )  //���ؿ�
			dw_insert.SetItem(ll_find, 'stockmonth_han_depot_no'  , ls_depot)  //â��
			dw_insert.SetItem(ll_find, 'stockmonth_han_itnbr'     , ls_itnbr)  //ǰ��
			dw_insert.SetItem(ll_find, 'stockmonth_han_pspec'     , ls_pspec)  //���
			dw_insert.SetItem(ll_find, 'stockmonth_han_gqty'      , ldb_gqty)  //�̿� ����
			dw_insert.SetItem(ll_find, 'gamt'                     , ldb_gamt)  //�̿� �ݾ�
			dw_insert.SetItem(ll_find, 'stockmonth_han_iqty'      , 0       )  //�԰�
			dw_insert.SetItem(ll_find, 'iamt'                     , 0       )  //�ݾ�
			dw_insert.SetItem(ll_find, 'stockmonth_han_oqty'      , 0       )  //���
			dw_insert.SetItem(ll_find, 'oamt'                     , 0       )  //�ݾ�
		End If
		
		dw_insert.SetItem(ll_find, 'stockmonth_han_gqty', ldb_gqty)  //�̿� ����
		dw_insert.SetItem(ll_find, 'gamt'               , ldb_gamt)  //�̿� �ݾ�
		dw_insert.ScrollToRow(ll_find)
		
		dw_insert.TriggerEvent(ItemChanged!)
		
		ll_cnt++
	End If
	
	//�ش� �Ǽ� ������ ����
	If ll_chk < 1 Then Exit
	
	ll_xrow++
Loop

uo_xl.uf_excel_Disconnect()

MessageBox('Ȯ��', String(ll_cnt) + ' ���� ��� DATA IMPORT �� �Ϸ��Ͽ����ϴ�.')
w_mdi_frame.sle_msg.text = ''

DESTROY uo_xl
end event

type rr_1 from roundrectangle within w_mat_03530_han
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 296
integer width = 4558
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

