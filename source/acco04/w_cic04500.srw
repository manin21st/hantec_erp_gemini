$PBExportHeader$w_cic04500.srw
$PBExportComments$����������
forward
global type w_cic04500 from w_inherite
end type
type dw_c from datawindow within w_cic04500
end type
type shl_1 from statichyperlink within w_cic04500
end type
type rr_1 from roundrectangle within w_cic04500
end type
end forward

global type w_cic04500 from w_inherite
integer width = 4667
integer height = 2600
string title = "����������"
dw_c dw_c
shl_1 shl_1
rr_1 rr_1
end type
global w_cic04500 w_cic04500

on w_cic04500.create
int iCurrent
call super::create
this.dw_c=create dw_c
this.shl_1=create shl_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_c
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_cic04500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_c)
destroy(this.shl_1)
destroy(this.rr_1)
end on

event open;call super::open;ib_any_typing = false

dw_c.InsertRow(0)

// 2007.4.19 ���� kwy, id 'BDS'�� �ƴϸ� ó������ ���ø��ϵ��� �� ����
//if gs_userid = "BDS" then
//
//else
//	dw_c.object.traceyn_t.visible	= False
//	dw_c.object.traceyn.visible	= False
//	dw_c.Width	= 613
//	rr_1.Width	= 681
//end if


string	ls_yymm, ls_colx
ls_yymm = f_aftermonth(string(Today(), "YYYYMM"), -1)
dw_c.object.workym[1] = ls_yymm

ls_colx = dw_insert.object.opdesc.X
dw_insert.object.datawindow.horizontalscrollsplit = ls_colx


p_inq.Post Event Clicked()

end event

event resize;call super::resize;//rr_2.Width 			= NewWidth - 70
//dw_insert.Width	= NewWidth - 120
//
//rr_2.Height 		= NewHeight - 240
//dw_insert.Height	= NewHeight - 270

end event

type dw_insert from w_inherite`dw_insert within w_cic04500
boolean visible = false
integer x = 859
integer y = 2556
integer width = 1266
integer height = 108
integer taborder = 0
string dataobject = "d_cic04500_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

end event

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then This.Event RowFocusChanged(1)

end event

event dw_insert::doubleclicked;call super::doubleclicked;// Datawindow �����ϱ�.
//f_sort(This)

end event

event dw_insert::constructor;call super::constructor;This.SetTransObject(sqlca)

end event

type p_delrow from w_inherite`p_delrow within w_cic04500
boolean visible = false
integer x = 3922
integer y = 2664
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;dw_insert.Deleterow(0)

if dw_insert.RowCount() <> 0 Then
	dw_insert.SelectRow(0, FALSE)
	dw_insert.SelectRow(dw_insert.getrow(), TRUE)
end if

end event

type p_addrow from w_inherite`p_addrow within w_cic04500
boolean visible = false
integer x = 3749
integer y = 2664
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;dw_insert.Object.workym.Initial	= dw_c.object.workym[1]

If dw_insert.RowCount() < 1 Then
	dw_insert.Insertrow(1)
Else
	dw_insert.Insertrow(dw_insert.GetRow())
End If

end event

type p_search from w_inherite`p_search within w_cic04500
integer x = 4242
integer y = 16
integer taborder = 20
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_search::clicked;call super::clicked;string	ls_ftime, ls_ttime, ls_sparam="<PARAM>", ls_eparam="</PARAM>", ls_param, ls_rtn, ls_traceyn
string	ls_workym, ls_minym, ls_date_val, ls_cbgbn
ls_ftime = String(Today(), "hh:mm:ss")


ls_workym	= dw_c.object.workym[1]
ls_cbgbn	= dw_c.object.cbgbn[1]

if IsNull(ls_workym) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ �����Ͻʽÿ�.")
	Return
end if

if IsNull(ls_cbgbn) then
	MessageBox("ó����⼱��", "������ΰ�� ó������� �����Ͻʽÿ�.")
	Return
end if

ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ Ȯ���Ͻʽÿ�.")
	Return
end if


// ������� �۾��� �����Ҷ� �۾���� ���� �ڷᰡ �������/������� �ԷµǾ��ٸ� �۾��� �ߴ���.
//select
//	min(workym) as workym
//into
//	:ls_minym
//from
//	(
//	/* ������� ���̺��� �Էµ� ���� ���� �۾���� */
//	select
//		min(workym) as workym
//	from
//		kuck_cic_rst_stockqty
//	where
//		input_yn = 'Y'
//	
//	/* ������� ���̺��� �Էµ� ���� ���� �۾���� */
//	union all
//	select
//		min(workym) as workym
//	from
//		cic_rst_prgsqty
//	where
//		input_yn = 'Y'
//	)
//;
//
//if isNull(ls_minym) or ls_minym < ls_workym then
//else
//	MessageBox("�������", "�۾���� ���� �ڷᰡ �������/������� �ԷµǾ��ֽ��ϴ�. �۾��� �� �����ϴ�.")
//	Return
//end if


// �������
If MessageBox("�������", "��������� ó���Ͻðڽ��ϱ�?", question!, yesno!, 2) = 2 Then Return

/*--------------------------------------------------------------------------------------------*/
// ������������ üũ
select fun_wonga_magam(:ls_workym) into :ls_rtn  from dual ;
if ls_rtn = 'Y' then
   messagebox('Ȯ��','���� ó���� ��������� �Դϴ�! ��������� �����Ͻʽÿ�!')
   Return
end if
/*--------------------------------------------------------------------------------------------*/
SetPointer(HourGlass!)

ls_param 	= ls_sparam + ls_workym + ls_eparam
ls_traceyn	= dw_c.object.traceyn[1]
//ls_rtn		= Sqlca.FUN_CIC_PROCESS00(ls_traceyn, ls_cbgbn, '10', 1, ls_param) ;
// ������ ������� �����(UE_CREATETRANSACTION�� �����ؾ���
	/*-------------------------------------------------------------------------------------------------
	  DB Function Call (������� ����)
	-------------------------------------------------------------------------------------------------*/
	DECLARE fun_cic_process00 PROCEDURE FOR FUN_CIC_PROCESS00(:ls_traceyn, :ls_cbgbn, '10', 1, :ls_param) USING SQLCA;
	EXECUTE fun_cic_process00;
	If SQLCA.SQLCODE < 0 Then
		f_message_chk(57, "~r~n~r~n[EXECUTE FUN_CIC_PROCESS00]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
		CLOSE fun_cic_process00;
		Return
	End If
	
	FETCH fun_cic_process00 INTO :ls_rtn;

	CLOSE fun_cic_process00;

ls_ttime = String(Today(), "hh:mm:ss")


MessageBox("�������", ls_rtn + "~r~n" + ls_ttime + " - " + ls_ftime)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type p_ins from w_inherite`p_ins within w_cic04500
boolean visible = false
integer x = 4027
integer y = 2836
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_cic04500
integer x = 4430
integer y = 16
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_cic04500
boolean visible = false
integer x = 4375
integer y = 2836
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_cic04500
boolean visible = false
integer x = 3854
integer y = 2836
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic04500
boolean visible = false
integer x = 4288
integer y = 2660
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;string	ls_date_val, ls_workym

dw_c.AcceptText()

ls_workym = dw_c.object.workym[1]


if IsNull(ls_workym) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ �����Ͻʽÿ�.")
	Return
end if
ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ Ȯ���Ͻʽÿ�.")
	Return
end if


dw_insert.retrieve()

end event

type p_del from w_inherite`p_del within w_cic04500
boolean visible = false
integer x = 4201
integer y = 2836
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_cic04500
boolean visible = false
integer x = 4096
integer y = 2664
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;IF dw_insert.Accepttext() = -1 THEN RETURN

if dw_insert.ModifiedCount() + dw_insert.DeletedCount() = 0 then Return

// ����޼��� function
IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cic04500
end type

type cb_mod from w_inherite`cb_mod within w_cic04500
end type

type cb_ins from w_inherite`cb_ins within w_cic04500
end type

type cb_del from w_inherite`cb_del within w_cic04500
end type

type cb_inq from w_inherite`cb_inq within w_cic04500
end type

type cb_print from w_inherite`cb_print within w_cic04500
end type

type st_1 from w_inherite`st_1 within w_cic04500
end type

type cb_can from w_inherite`cb_can within w_cic04500
end type

type cb_search from w_inherite`cb_search within w_cic04500
end type







type gb_button1 from w_inherite`gb_button1 within w_cic04500
end type

type gb_button2 from w_inherite`gb_button2 within w_cic04500
end type

type dw_c from datawindow within w_cic04500
integer x = 1568
integer y = 1096
integer width = 1573
integer height = 116
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic04500_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String	ls_date_val

Choose Case GetColumnName()
	Case "workym"

		if IsNull(data) then
			MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ �����Ͻʽÿ�.")
			Return 1
		end if

		ls_date_val = mid(data, 1, 4) + '-' + mid(data, 5, 2) + "-01"
		if Not IsDate(ls_date_val) then
			MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ Ȯ���Ͻʽÿ�.")
			Return 1
		end if

	Case Else

End Choose

end event

event itemerror;Return 1

end event

type shl_1 from statichyperlink within w_cic04500
boolean visible = false
integer x = 3904
integer y = 444
integer width = 677
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
boolean enabled = false
string text = "������� �۾�"
alignment alignment = center!
long bordercolor = 32106727
boolean focusrectangle = false
end type

event clicked;string	ls_ftime, ls_ttime, ls_sparam="<PARAM>", ls_eparam="</PARAM>", ls_param, ls_rtn, ls_traceyn
string	ls_workym, ls_minym, ls_date_val, ls_cbgbn
ls_ftime = String(Today(), "hh:mm:ss")


ls_workym	= dw_c.object.workym[1]
ls_cbgbn	= dw_c.object.cbgbn[1]

if IsNull(ls_workym) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ �����Ͻʽÿ�.")
	Return
end if

if IsNull(ls_cbgbn) then
	MessageBox("ó����⼱��", "������� ó������� �����Ͻʽÿ�.")
	Return
end if

ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("���س�� �Է�Ȯ��", "���س�� ��ȸ������ Ȯ���Ͻʽÿ�.")
	Return
end if


// ������� �۾��� �����Ҷ� �۾���� ���� �ڷᰡ �������/������� �ԷµǾ��ٸ� �۾��� �ߴ���.
//select
//	min(workym) as workym
//into
//	:ls_minym
//from
//	(
//	/* ������� ���̺��� �Էµ� ���� ���� �۾���� */
//	select
//		min(workym) as workym
//	from
//		kuck_cic_rst_stockqty
//	where
//		input_yn = 'Y'
//	
//	/* ������� ���̺��� �Էµ� ���� ���� �۾���� */
//	union all
//	select
//		min(workym) as workym
//	from
//		cic_rst_prgsqty
//	where
//		input_yn = 'Y'
//	)
//;
//
//if isNull(ls_minym) or ls_minym < ls_workym then
//else
//	MessageBox("�������", "�۾���� ���� �ڷᰡ �������/������� �ԷµǾ��ֽ��ϴ�. �۾��� �� �����ϴ�.")
//	Return
//end if


// �������
If MessageBox("�������", "������� ����(�ſ��۾�)�� ó���Ͻðڽ��ϱ�?", question!, yesno!, 2) = 2 Then Return


ls_param 	= ls_sparam + ls_workym + ls_eparam
ls_traceyn	= dw_c.object.traceyn[1]
//ls_rtn		= Sqlca.FUN_CIC_PROCESS00(ls_traceyn, ls_cbgbn, '10', 1, ls_param) ;
	/*-------------------------------------------------------------------------------------------------
	  DB Function Call (������� ����)
	-------------------------------------------------------------------------------------------------*/
	DECLARE fun_cic_process00 PROCEDURE FOR FUN_CIC_PROCESS00(:ls_traceyn, :ls_cbgbn, '10', 1, :ls_param) USING SQLCA;
	EXECUTE fun_cic_process00;
	If SQLCA.SQLCODE < 0 Then
		f_message_chk(57, "~r~n~r~n[EXECUTE FUN_CIC_PROCESS00]~r~n~r~n" + SQLCA.SQLERRTEXT)	// �ڷḦ ó���� �� �����ϴ�.
		CLOSE fun_cic_process00;
		Return
	End If
	
	FETCH fun_cic_process00 INTO :ls_rtn;

	CLOSE fun_cic_process00;

ls_ttime = String(Today(), "hh:mm:ss")


MessageBox("�������", ls_rtn + "~r~n" + ls_ttime + " - " + ls_ftime)

end event

type rr_1 from roundrectangle within w_cic04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1527
integer y = 944
integer width = 1687
integer height = 416
integer cornerheight = 40
integer cornerwidth = 55
end type

