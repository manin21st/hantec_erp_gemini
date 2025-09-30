$PBExportHeader$w_sm10_0053.srw
$PBExportComments$VAN ����(M1 �����ϼ���)
forward
global type w_sm10_0053 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0053
end type
type pb_1 from u_pb_cal within w_sm10_0053
end type
type pb_2 from u_pb_cal within w_sm10_0053
end type
type rr_1 from roundrectangle within w_sm10_0053
end type
end forward

global type w_sm10_0053 from w_inherite
string title = "MOBIS AUTO VAN ��ǰ�� ����"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sm10_0053 w_sm10_0053

on w_sm10_0053.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm10_0053.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetItem(1, 'jisi_date', String(TODAY(), 'yyyymmdd'))
dw_1.SetItem(1, 'jisi_date2', String(TODAY(), 'yyyymmdd'))

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0053
integer x = 41
integer y = 304
integer width = 4558
integer height = 1944
string dataobject = "d_sm10_0053_ckd_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0053
boolean visible = false
integer x = 4229
integer y = 188
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0053
boolean visible = false
integer x = 4055
integer y = 188
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm10_0053
boolean visible = false
integer x = 3534
integer y = 188
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0053
boolean visible = false
integer x = 3881
integer y = 188
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0053
integer x = 4389
end type

type p_can from w_inherite`p_can within w_sm10_0053
integer x = 4215
end type

type p_print from w_inherite`p_print within w_sm10_0053
boolean visible = false
integer x = 3707
integer y = 188
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0053
integer x = 3867
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

String ls_fac
String ls_itn
String ls_st
String ls_ed

ls_fac = dw_1.GetItemString(1, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = 'M1'

ls_itn = dw_1.GetItemString(1, 'itnbr')
If Trim(ls_itn) = '' OR IsNull(ls_itn) Then ls_itn = '%'

ls_st = dw_1.GetItemString(1, 'jisi_date')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '20000101'

ls_ed = dw_1.GetItemString(1, 'jisi_date2')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '29991231'

If ls_st > ls_ed Then
	MessageBox('�ⰣȮ��', '������ ���� �������� �����ϴ�.')
	Return
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_saupj, ls_st, ls_ed, ls_itn, ls_fac)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0053
boolean visible = false
integer x = 4407
integer y = 188
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm10_0053
integer x = 4041
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   i
String ls_yodate

For i = 1 To dw_insert.RowCount()
	ls_yodate = dw_insert.GetItemString(i, 'yodate')
	If Trim(ls_yodate) = '' OR IsNull(ls_yodate) Then
		MessageBox('���� �Է�', '�������ڸ� �Է� �Ͻʽÿ�.')
		Return
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('����', '�ڷᰡ ���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('����', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
End If
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0053
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0053
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0053
end type

type cb_del from w_inherite`cb_del within w_sm10_0053
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0053
end type

type cb_print from w_inherite`cb_print within w_sm10_0053
end type

type st_1 from w_inherite`st_1 within w_sm10_0053
end type

type cb_can from w_inherite`cb_can within w_sm10_0053
end type

type cb_search from w_inherite`cb_search within w_sm10_0053
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0053
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0053
end type

type dw_1 from datawindow within w_sm10_0053
integer x = 23
integer y = 28
integer width = 2382
integer height = 268
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0053_1"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type pb_1 from u_pb_cal within w_sm10_0053
integer x = 809
integer y = 156
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('jisi_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sm10_0053
integer x = 1312
integer y = 156
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('jisi_date2')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'jisi_date2', gs_code)

end event

type rr_1 from roundrectangle within w_sm10_0053
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 296
integer width = 4576
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

