$PBExportHeader$w_sal_02130.srw
$PBExportComments$�ŷ�ó ���� �ϰ�����
forward
global type w_sal_02130 from w_inherite
end type
type st_2 from statictext within w_sal_02130
end type
type st_3 from statictext within w_sal_02130
end type
type st_4 from statictext within w_sal_02130
end type
type pb_1 from u_pic_cal within w_sal_02130
end type
type pb_2 from u_pic_cal within w_sal_02130
end type
type gb_2 from groupbox within w_sal_02130
end type
type gb_1 from groupbox within w_sal_02130
end type
end forward

global type w_sal_02130 from w_inherite
integer width = 4686
integer height = 2388
string title = "���� �ܰ� �ϰ� ����"
st_2 st_2
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_sal_02130 w_sal_02130

forward prototypes
public function integer wf_junpyo_closing (string syymm)
end prototypes

public function integer wf_junpyo_closing (string syymm);/* ���� ��������                  */
/* Return : 0(������), > 0 (����) */
Long nCnt

  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sYYmm )   ;

If nCnt > 0 Then
	f_message_chk(60,'[���������]')
	Return nCnt
End If

Return 0

end function

on w_sal_02130.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_sal_02130.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_insert.InsertRow(0)


// �ΰ��� ����� ����
f_mod_saupj(dw_insert, 'saupj')

end event

event resize;//
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", false) //// ��ȸ
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", false) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", false) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", false) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", false) //// ã��
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 false) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", false) //// �����ٿ�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = false //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = false  //// ����
m_main2.m_window.m_save.enabled = false //// ����
m_main2.m_window.m_cancel.enabled = false //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = false  //// ã��
m_main2.m_window.m_filter.enabled = false //// ����
m_main2.m_window.m_excel.enabled = false //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_02130
integer x = 2405
integer y = 5000
integer width = 443
end type

type sle_msg from w_inherite`sle_msg within w_sal_02130
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_02130
end type

type st_1 from w_inherite`st_1 within w_sal_02130
integer x = 485
integer y = 1972
end type

type p_search from w_inherite`p_search within w_sal_02130
boolean visible = true
integer x = 2907
integer y = 416
boolean enabled = true
string picturename = "..\image\ó��_up.gif"
end type

event p_search::ue_lbuttonup;pictureName = "..\image\ó��_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;pictureName = "..\image\ó��_dn.gif"
end event

event p_search::clicked;call super::clicked;string sDatef, sDatet, sNull, sCvcod1, sCvcod2, sIoJpno, smsg, sSaupj
Long   nRow, nCnt

SetNull(sNull)

If dw_insert.AcceptText() <> 1 then Return

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

sSaupj  = Trim(dw_insert.GetItemString(nRow,'saupj'))
sDatef  = Trim(dw_insert.GetItemString(nRow,'sdatef'))
sDatet  = Trim(dw_insert.GetItemString(nRow,'sdatet'))
sCvcod1 = Trim(dw_insert.GetItemString(nRow,'cvcod1'))
sCvcod2 = Trim(dw_insert.GetItemString(nRow,'cvcod2'))

dw_insert.SetFocus()
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(1400,'[�ΰ������]')
	dw_insert.SetColumn('saupj')
	Return
End If

//If IsNull(sCvcod1) or sCvcod1 = '' Then 
//	f_message_chk(1400,'[������ �ŷ�ó]')
//	dw_insert.SetColumn('cvcod1')
//	Return
//End If
//
//If IsNull(sCvcod2) or sCvcod2 = '' Then
//	f_message_chk(1400,'[������ �ŷ�ó]')
//	dw_insert.SetColumn('cvcod2')
//	Return
//End If

If IsNull(sdatef) Or sdatef = '' Then
  f_message_chk(1400,'[���Ⱓ]')
	dw_insert.SetColumn('sdatef')
	Return 
End If

If IsNull(sdatet) Or sdatet = '' Then
  f_message_chk(1400,'[���Ⱓ]')
	dw_insert.SetColumn('sdatet')
	Return 
End If

/* ���⸶������ Ȯ�� */
If wf_junpyo_closing(Left(sDatef,6)) > 0 Then
	dw_insert.SetItem(1,'sdatef',sNull)
	dw_insert.SetColumn('sdatef')
	return 1
End If

If wf_junpyo_closing(Left(sDatet,6)) > 0 Then
	dw_insert.SetItem(1,'sdatet',sNull)
	dw_insert.SetColumn('sdatet')
	return 1
End If

IF MessageBox("���ó ����","�ش� �Ⱓ���� ���� �ŷ�ó�� �ϰ������մϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

nCnt = sqlca.FUN_ERP100000018(gs_sabu, sdatef, sdatet, scvcod1, scvcod2, sSaupj)
If sqlca.sqlcode = 0 then
  commit;
  f_message_chk(202,'[ó���Ǽ� : ' +String(nCnt) + ']')
Else
	smsg = sqlca.sqlerrtext
	RollBack;
	f_message_chk(57,smsg)
	Return	
End If

dw_insert.Reset()
dw_insert.InsertRow(0)
ib_any_typing = false
end event

type p_addrow from w_inherite`p_addrow within w_sal_02130
integer y = 5000
end type

type p_delrow from w_inherite`p_delrow within w_sal_02130
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_02130
integer y = 5000
end type

type p_del from w_inherite`p_del within w_sal_02130
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_02130
integer y = 5000
end type

type p_print from w_inherite`p_print within w_sal_02130
integer y = 5000
end type

type p_can from w_inherite`p_can within w_sal_02130
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_02130
boolean visible = true
integer x = 3081
integer y = 416
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\�ݱ�_up.gif"
end type

event p_exit::ue_lbuttonup;PictureName = "..\image\�ݱ�_up.gif"
end event

event p_exit::ue_lbuttondown;PictureName = "..\image\�ݱ�_dn.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_02130
integer y = 5000
end type

type p_new from w_inherite`p_new within w_sal_02130
integer x = 2345
integer y = 2004
end type

type dw_input from w_inherite`dw_input within w_sal_02130
boolean visible = false
integer x = 59
integer y = 1696
integer width = 312
integer height = 200
end type

type cb_delrow from w_inherite`cb_delrow within w_sal_02130
boolean visible = false
integer x = 2382
integer y = 2020
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_02130
boolean visible = false
integer x = 2071
integer y = 2020
end type

type dw_insert from w_inherite`dw_insert within w_sal_02130
integer x = 1431
integer y = 620
integer width = 1806
integer height = 576
string dataobject = "d_sal_02130"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
end type

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod1", "cvcodnm1"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm1" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod1",gs_code)
		SetColumn("cvcod1")
		TriggerEvent(ItemChanged!)
	/* �ŷ�ó */
	Case "cvcod2", "cvcodnm2"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod2",gs_code)
		SetColumn("cvcod2")
		TriggerEvent(ItemChanged!)
End Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "sdatef"  , "sdatet"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[�������]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* �ŷ�ó */
	Case "cvcod1"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm1",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod1', sNull)
			SetItem(1, 'cvcodnm1', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm1",	scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "cvcodnm1"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod1",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod1', sNull)
			SetItem(1, 'cvcodnm1', snull)
			Return 1
		ELSE
			SetItem(1,'cvcod1', sCvcod)
			SetItem(1,"cvcodnm1", scvnas)
			Return 1
		END IF
	/* �ŷ�ó */
	Case "cvcod2"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod2', sNull)
			SetItem(1, 'cvcodnm2', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm2",	scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "cvcodnm2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod2",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod2', sNull)
			SetItem(1, 'cvcodnm2', snull)
			Return 1
		ELSE
			SetItem(1,'cvcod2', sCvcod)
			SetItem(1,"cvcodnm2", scvnas)
			Return 1
		END IF
End Choose

end event

event dw_insert::editchanged;Return
end event

event dw_insert::clicked;//
end event

event dw_insert::doubleclicked;//
end event

event dw_insert::rowfocuschanged;//
end event

event dw_insert::ue_leftbuttonup;//
end event

event dw_insert::ue_lbuttonup;//
end event

type cb_mod from w_inherite`cb_mod within w_sal_02130
boolean visible = false
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_02130
boolean visible = false
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_sal_02130
boolean visible = false
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02130
boolean visible = false
integer x = 1600
integer y = 2416
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_02130
boolean visible = false
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type cb_can from w_inherite`cb_can within w_sal_02130
boolean visible = false
integer x = 1449
integer y = 2380
integer width = 443
integer taborder = 30
boolean enabled = false
string text = "�������(&C)"
end type

type cb_search from w_inherite`cb_search within w_sal_02130
boolean visible = false
integer x = 1797
integer y = 5000
integer width = 498
integer taborder = 20
string text = "�ϰ�����(&P)"
end type

type gb_10 from w_inherite`gb_10 within w_sal_02130
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02130
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02130
end type

type r_head from w_inherite`r_head within w_sal_02130
boolean visible = false
integer x = 55
integer y = 1684
integer width = 312
integer height = 200
end type

type r_detail from w_inherite`r_detail within w_sal_02130
boolean visible = false
integer x = 55
integer y = 1912
integer width = 312
integer height = 200
end type

type st_2 from statictext within w_sal_02130
integer x = 1435
integer y = 1372
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "* �Ⱓ�� ���ܰ��� "
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_02130
integer x = 2021
integer y = 1372
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 16777215
boolean enabled = false
string text = "��ǰ�ܰ�����Ÿ"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_02130
integer x = 2459
integer y = 1372
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "�������� �ϰ� �����մϴ�."
boolean focusrectangle = false
end type

type pb_1 from u_pic_cal within w_sal_02130
integer x = 2400
integer y = 928
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_02130
integer x = 2926
integer y = 928
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('sdatet')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'sdatet', gs_code)

end event

type gb_2 from groupbox within w_sal_02130
integer x = 1403
integer y = 1260
integer width = 1861
integer height = 244
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_sal_02130
integer x = 1403
integer y = 560
integer width = 1861
integer height = 672
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 16777215
end type

