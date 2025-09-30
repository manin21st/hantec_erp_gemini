$PBExportHeader$w_han_34010.srw
$PBExportComments$�ŷ�ó �ϰ�����(����/����-����)
forward
global type w_han_34010 from w_inherite
end type
type rr_1 from roundrectangle within w_han_34010
end type
type rr_2 from roundrectangle within w_han_34010
end type
type p_1 from uo_picture within w_han_34010
end type
type pb_1 from u_pb_cal within w_han_34010
end type
type pb_2 from u_pb_cal within w_han_34010
end type
type rb_1 from radiobutton within w_han_34010
end type
type rb_2 from radiobutton within w_han_34010
end type
end forward

global type w_han_34010 from w_inherite
string title = "����/���� �ŷ�ó �ϰ�����"
rr_1 rr_1
rr_2 rr_2
p_1 p_1
pb_1 pb_1
pb_2 pb_2
rb_1 rb_1
rb_2 rb_2
end type
global w_han_34010 w_han_34010

forward prototypes
public function integer wf_chg_maip (string as_saupj, string as_scvcod, string as_ecvcod, string as_sdate, string as_edate)
public function integer wf_chg_mach (string as_saupj, string as_scvcod, string as_ecvcod, string as_sdate, string as_edate)
end prototypes

public function integer wf_chg_maip (string as_saupj, string as_scvcod, string as_ecvcod, string as_sdate, string as_edate);UPDATE IMHIST
   SET CVCOD = :as_ecvcod
 WHERE EXISTS ( SELECT IOGBN
					  FROM IOMATRIX
					 WHERE IOGBN  = IMHIST.IOGBN
					   AND MAIPGU = 'Y')
  AND IMHIST.SABU 	                =       :gs_sabu
  AND NVL(IMHIST.IO_DATE, :as_sdate) BETWEEN :as_sdate AND :as_edate
  AND IMHIST.CVCOD                   =       :as_scvcod
  AND IMHIST.SAUPJ                   =       :as_saupj
  AND IMHIST.MAYYMM  IS NULL ; 

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('�ŷ�ó �ϰ�����', '�ŷ�ó ���� �۾��� �Ϸ�Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('�ŷ�ó �ϰ����� ����', '�ŷ�ó ���� �۾��� �����߽��ϴ�.')
	Return -1
End If

Return 1
end function

public function integer wf_chg_mach (string as_saupj, string as_scvcod, string as_ecvcod, string as_sdate, string as_edate);UPDATE IMHIST
   SET CVCOD = :as_ecvcod
 WHERE EXISTS ( SELECT IOGBN
  				      FROM IOMATRIX
				     WHERE IOGBN  = IMHIST.IOGBN
				       AND SALEGU = 'Y')
  AND IMHIST.SABU  =       :gs_sabu
  AND IMHIST.YEBI1 BETWEEN :as_sdate AND :as_edate
  AND IMHIST.CVCOD =       :as_scvcod
  AND IMHIST.SAUPJ =       :as_saupj
  AND NOT EXISTS ( SELECT 'X' FROM REFFPF WHERE RFCOD = '2A' AND RFNA2 = IMHIST.CVCOD AND RFGUB <> '.' ) ;
  
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('�ŷ�ó �ϰ�����', '�ŷ�ó ���� �۾��� �Ϸ�Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('�ŷ�ó �ϰ����� ����', '�ŷ�ó ���� �۾��� �����߽��ϴ�.')
	Return -1
End If

Return 1
end function

on w_han_34010.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
this.p_1=create p_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
end on

on w_han_34010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event open;call super::open;This.TriggerEvent('ue_open')
end event

event ue_open;call super::ue_open;/* �ΰ� ����� */
f_mod_saupj(dw_insert, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_han_34010
integer x = 1696
integer y = 756
integer width = 1499
integer height = 520
string dataobject = "d_han_34010_001"
boolean border = false
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event dw_insert::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'cvcod_old'		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod_old'  , gs_code    )
		This.SetItem(row, 'cvcod_oldnm', gs_codename)
		
	Case 'cvcod_new'		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod_new'  , gs_code    )
		This.SetItem(row, 'cvcod_newnm', gs_codename)	
End Choose
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

Long   	ll_data
String	ls_name

Choose Case dwo.name
	Case 'cvcod_old'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvcod_oldnm', '')
			Return
		End If
		
		SELECT CVNAS2
		  INTO :ls_name
		  FROM VNDMST
		 WHERE CVCOD = :data ;
//			AND CVSTATUS = '0' ;		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[�ŷ�ó]')
			this.setitem(row, "cvcod_old", '')
			this.setitem(row, "cvcod_oldnm", '')
			return 1
		end if
	
		This.SetItem(row, 'cvcod_oldnm', ls_name)
		
	Case 'cvcod_new'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvcod_newnm', '')
			Return
		End If
		
		SELECT CVNAS2
		  INTO :ls_name
		  FROM VNDMST
		 WHERE CVCOD = :data ;
//			AND CVSTATUS = '0' ;		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[�ŷ�ó]')
			this.setitem(row, "cvcod_new", '')
			this.setitem(row, "cvcod_newnm", '')
			return 1
		end if

		This.SetItem(row, 'cvcod_newnm', ls_name)

End Choose
end event

event dw_insert::itemerror;call super::itemerror;RETURN 1
end event

type p_delrow from w_inherite`p_delrow within w_han_34010
boolean visible = false
integer x = 2537
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_han_34010
boolean visible = false
integer x = 2363
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_han_34010
boolean visible = false
integer x = 1669
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_han_34010
boolean visible = false
integer x = 2190
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_han_34010
integer x = 4389
end type

type p_can from w_inherite`p_can within w_han_34010
integer x = 4215
end type

type p_print from w_inherite`p_print within w_han_34010
boolean visible = false
integer x = 1842
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_han_34010
boolean visible = false
integer x = 2016
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_han_34010
boolean visible = false
integer x = 2885
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_han_34010
boolean visible = false
integer x = 2711
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_han_34010
end type

type cb_mod from w_inherite`cb_mod within w_han_34010
end type

type cb_ins from w_inherite`cb_ins within w_han_34010
end type

type cb_del from w_inherite`cb_del within w_han_34010
end type

type cb_inq from w_inherite`cb_inq within w_han_34010
end type

type cb_print from w_inherite`cb_print within w_han_34010
end type

type st_1 from w_inherite`st_1 within w_han_34010
end type

type cb_can from w_inherite`cb_can within w_han_34010
end type

type cb_search from w_inherite`cb_search within w_han_34010
end type







type gb_button1 from w_inherite`gb_button1 within w_han_34010
end type

type gb_button2 from w_inherite`gb_button2 within w_han_34010
end type

type rr_1 from roundrectangle within w_han_34010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 192
integer width = 4544
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_han_34010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1582
integer y = 692
integer width = 1701
integer height = 652
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from uo_picture within w_han_34010
integer x = 4055
integer y = 24
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\�ϰ�����_up.gif"
end type

event clicked;call super::clicked;dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_saupj

ls_saupj = dw_insert.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('����� Ȯ��', '������� �ʼ� �Է� �׸��Դϴ�.')
	dw_insert.SetColumn('saupj')
	dw_insert.SetFocus()
	Return
End If

String ls_scvcod

ls_scvcod = dw_insert.GetItemString(row, 'cvcod_old')
If Trim(ls_scvcod) = '' OR IsNull(ls_scvcod) Then
	MessageBox('���� �ŷ�ó Ȯ��', '���� �ŷ�ó�� �ʼ� �Է� �׸� �Դϴ�.')
	dw_insert.SetColumn('cvcod_old')
	dw_insert.SetFocus()
	Return
End If

String ls_ecvcod

ls_ecvcod = dw_insert.GetItemString(row, 'cvcod_new')
If Trim(ls_ecvcod) = '' OR IsNull(ls_ecvcod) Then
	MessageBox('�ű� �ŷ�ó Ȯ��', '�ű� �ŷ�ó�� �ʼ� �Է� �׸� �Դϴ�.')
	dw_insert.SetColumn('cvcod_new')
	dw_insert.SetFocus()
	Return
End If

String ls_sdate

ls_sdate = dw_insert.GetItemString(row, 'io_date_st')
If Trim(ls_sdate) = '' OR IsNull(ls_sdate) Then
	MessageBox('���ұⰣ Ȯ��', '���ұⰣ�� �ʼ� �Է� �׸� �Դϴ�.')
	dw_insert.SetColumn('io_date_st')
	dw_insert.SetFocus()
	Return
End If

String ls_edate

ls_edate = dw_insert.GetItemString(row, 'io_date_ed')
If Trim(ls_edate) = '' OR IsNull(ls_edate) Then
	MessageBox('���ұⰣ Ȯ��', '���ұⰣ�� �ʼ� �Է� �׸� �Դϴ�.')
	dw_insert.SetColumn('io_date_ed')
	dw_insert.SetFocus()
	Return
End If

If ls_sdate > ls_edate Then
	MessageBox('���ұⰣ Ȯ��', '�������� ������ ���� �����ϴ�.')
	dw_insert.SetColumn('io_date_st')
	dw_insert.SetFocus()
	Return
End If

If rb_1.Checked = True Then
	If MessageBox('���� �ŷ�ó �ϰ�����', '���� �ŷ�ó�� �ϰ� ���� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return
	wf_chg_maip(ls_saupj, ls_scvcod, ls_ecvcod, ls_sdate, ls_edate)
Else
	If MessageBox('���� �ŷ�ó �ϰ�����', '���� �ŷ�ó�� �ϰ� ���� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return
	wf_chg_mach(ls_saupj, ls_scvcod, ls_ecvcod, ls_sdate, ls_edate)
End If

end event

type pb_1 from u_pb_cal within w_han_34010
integer x = 2482
integer y = 1140
integer width = 78
integer height = 72
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('io_date_st')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'io_date_st', gs_code)

end event

type pb_2 from u_pb_cal within w_han_34010
integer x = 2949
integer y = 1140
integer width = 82
integer height = 72
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('io_date_ed')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'io_date_ed', gs_code)

end event

type rb_1 from radiobutton within w_han_34010
integer x = 1623
integer y = 572
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "���� �ŷ�ó"
boolean checked = true
end type

type rb_2 from radiobutton within w_han_34010
integer x = 2075
integer y = 572
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "���� �ŷ�ó"
end type

