$PBExportHeader$w_sal_02140.srw
$PBExportComments$ǰ��з��� ���� ���
forward
global type w_sal_02140 from w_inherite
end type
type gb_5 from groupbox within w_sal_02140
end type
type gb_4 from groupbox within w_sal_02140
end type
end forward

global type w_sal_02140 from w_inherite
integer height = 2532
string title = "ǰ��з��� ���� ���"
gb_5 gb_5
gb_4 gb_4
end type
global w_sal_02140 w_sal_02140

type variables

end variables

forward prototypes
public function integer wf_update_middle ()
end prototypes

public function integer wf_update_middle ();Long ix
String sIttyp, sItcls, sKacc, sFacc, sLacc

If dw_insert.RowCount() <= 0 Then Return 0

SetPointer(HourGlass!)

For ix = 1 To dw_insert.RowCount()
	sIttyp = Trim(dw_insert.GetItemString(ix,'ittyp'))
	sItcls = Trim(dw_insert.GetItemString(ix,'itcls'))
	sKacc  = Trim(dw_insert.GetItemString(ix,'kacc_cd'))
	sFacc  = Trim(dw_insert.GetItemString(ix,'facc_cd'))
	sLacc  = Trim(dw_insert.GetItemString(ix,'lacc_cd'))

	If IsNull(sIttyp) Then continue
	If IsNull(sItcls) Then continue
	
	If IsNull(sKacc) Then sKacc = ''
	If IsNull(sFacc) Then sFacc = ''
	If IsNull(sLacc) Then sLacc = ''
	
	/* �ߺз� update */
	update itnacc
		set kacc_cd = :sKacc,
			 facc_cd = :sFacc,
			 lacc_cd = :sLacc
	 where ittyp = :sIttyp and
			 itcls like :sItcls||'%' ;

//			 exists ( select * from itnct 
//						  where ittyp = a.ittyp and
//								  itcls = a.itcls and
//								  lmsgu = 'M' );

	If sqlca.sqlcode <> 0 Then
		rollback;
		MessageBox('Ȯ ��','�ߺз� update�� �����Ͽ����ϴ�')
		Return -1
	End If
Next

Commit;

w_mdi_frame.sle_msg.Text = '�ߺз��� �����Ͽ����ϴ�.!!'

Return 1
end function

on w_sal_02140.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
end on

on w_sal_02140.destroy
call super::destroy
destroy(this.gb_5)
destroy(this.gb_4)
end on

event open;call super::open;dw_input.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_input.InsertRow(0)

f_mod_saupj(dw_input, 'dcomp')

p_can.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", false) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", true) //// ã��
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", true) //// �����ٿ�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)


//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = false  //// ����
m_main2.m_window.m_save.enabled = true //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = true  //// ã��
m_main2.m_window.m_filter.enabled = true //// ����
m_main2.m_window.m_excel.enabled = true //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_02140
integer y = 3324
end type

type sle_msg from w_inherite`sle_msg within w_sal_02140
integer y = 3140
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_02140
integer y = 3140
end type

type st_1 from w_inherite`st_1 within w_sal_02140
integer y = 3112
end type

type p_search from w_inherite`p_search within w_sal_02140
integer y = 3144
end type

type p_addrow from w_inherite`p_addrow within w_sal_02140
integer y = 3144
end type

type p_delrow from w_inherite`p_delrow within w_sal_02140
integer y = 3144
end type

type p_mod from w_inherite`p_mod within w_sal_02140
integer y = 3144
end type

event p_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls
Long   nRow

If dw_input.AcceptText() <> 1 Then return 

sSalegu = Trim(dw_input.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_input.GetItemString(1,'ittyp'))
If sSaleGu = '2' then
	sItcls  = Trim(dw_input.GetItemString(1,'itcls'))
End If

If sSalegu = '1' Then
	/* ��з� ���� */
	If dw_insert.AcceptText() <> 1 Then Return
	
	If dw_insert.update() > 0 then
		commit using sqlca;
	Else
		rollback using sqlca ;
		f_message_chk(32,'')
		Return
	End If
	
	/* �ߺз� �ϰ� ���� */
 	If wf_update_middle() < 0 Then Return
Else
	/* �ߺз� ���� */
	If dw_insert.AcceptText() <> 1 Then 
		MessageBox('err','')
		Return
	End If
	
	If dw_insert.update() > 0 then
		commit using sqlca;
	Else
		rollback using sqlca ;
		f_message_chk(32,'')
		Return
	End If
End If

w_mdi_frame.sle_msg.text = "�����Ͽ����ϴ�!!"
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sal_02140
integer y = 3144
end type

type p_inq from w_inherite`p_inq within w_sal_02140
integer y = 3144
end type

event p_inq::clicked;call super::clicked;string salegu, sIttyp, sItcls, sDcomp

If dw_input.AcceptText() <> 1 Then Return

dw_input.SetFocus()
dw_input.SetRow(1)

salegu = Trim(dw_input.GetItemString(1,'salegu'))
If IsNull(salegu) Or salegu = '' Then
	f_message_chk(1400,'[�з�����]')
	dw_input.setColumn('salegu')
	Return 2
End If

sDcomp  = Trim(dw_input.GetItemString(1,'dcomp'))
If 	sDcomp <> '%' then
	sDcomp = sDcomp + '%'
End If

sittyp       = Trim(dw_input.GetItemString(1,'ittyp'))
If IsNull(sittyp) Or sittyp = '' Then
	f_message_chk(1400,'[ǰ�񱸺�]')
	dw_input.setColumn('ittyp')
	Return 2
End If

sitcls  = Trim(dw_input.GetItemString(1,'itcls'))
If SaleGu = '2' and ( IsNull(sitcls) Or sitcls = '' ) Then
	f_message_chk(1400,'[ǰ��з�]')
	dw_input.setColumn('itcls')
	Return 2
End If

If SaleGu = '1' Then /* ��з� ��ȸ */
	IF dw_insert.retrieve(sDcomp,sIttyp) <=0 THEN
		IF f_message_chk(50,'') = -1 THEN RETURN -1
   		dw_input.setcolumn('dcomp')
		dw_input.SetFocus()
		Return -1
	END IF
Else
	IF dw_insert.retrieve(sDcomp, sIttyp, sItcls+'%') <=0 THEN
		IF f_message_chk(50,'') = -1 THEN RETURN -1
   		dw_input.setcolumn('dcomp')
		dw_input.SetFocus()
		Return -1
	END IF
End If

/* Protect */
//dw_input.Modify('dcomp.protect = 1')
dw_input.Modify('salegu.protect = 1')
//dw_input.Modify("salegu.background.color = 80859087") 
dw_input.Modify('ittyp.protect = 1')
//dw_input.Modify("ittyp.background.color = 80859087") 


end event

type p_print from w_inherite`p_print within w_sal_02140
integer y = 3144
end type

type p_can from w_inherite`p_can within w_sal_02140
integer y = 3144
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

/* Protect */
//dw_input.Modify('dcomp.protect = 0')
dw_input.Modify('salegu.protect = 0')
//dw_input.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_input.Modify('ittyp.protect = 0')
//dw_input.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint

dw_input.SetFocus()
dw_input.SetColumn('ittyp')

ib_any_typing = false
end event

type p_exit from w_inherite`p_exit within w_sal_02140
integer y = 3144
end type

type p_ins from w_inherite`p_ins within w_sal_02140
integer y = 3144
end type

type p_new from w_inherite`p_new within w_sal_02140
integer y = 3144
end type

type dw_input from w_inherite`dw_input within w_sal_02140
integer y = 56
integer width = 3489
integer height = 212
string dataobject = "d_sal_02140_01"
end type

event dw_input::itemerror;RETURN 1
end event

event dw_input::itemchanged;Long nRow
String sNull, sItemCls, sItemGbn, sItemClsName, sPdtgu

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* ���� */
	Case 'salegu'
		/* ��з� ��ȸ */
		If GetText() = '1' Then
			dw_insert.dataobject     	= 'd_sal_021401'

			SetItem(nRow,'itcls',sNull)
			SetItem(nRow,'itclsnm',sNull)
		/* �ߺз� ��ȸ */
		Else
			dw_insert.dataobject     	= 'd_sal_021402'
			
			SetFocus()
			Post SetColumn('itcls')
		End If
      	dw_insert.settransobject(sqlca)
		
	/* ǰ��з� */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM" ,"ITNCT"."PDTGU"
			  INTO :sItemClsName  , :sPdtgu
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* ǰ��� */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
			sItemGbn = GetItemString(1,"ittyp")
			IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
				SELECT "ITNCT"."ITCLS","ITNCT"."PDTGU"
				  INTO :sItemCls, :sPdtgu
				  FROM "ITNCT"  
				 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					TriggerEvent(RButtonDown!)
					Return 2
				ELSE
					SetItem(1,"itcls",sItemCls)
			END IF
		END IF
End Choose
end event

event dw_input::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		gs_gubun = GetItemString(1,"ittyp")
		Open(w_itnct_l_popup)
		If IsNull(gs_code ) Then Return 2
		
		SetItem(1,"itcls", gs_code)
		SetItem(1,"itclsnm", gs_codename)
		SetItem(1,"ittyp",  gs_gubun)
	Case "itclsnm"
		gs_gubun = GetItemString(1,"ittyp")
		Open(w_itnct_l_popup)
		If IsNull(gs_code ) Then Return 2		
		
		SetItem(1,"itcls", gs_code)
		SetItem(1,"itclsnm", gs_codename)
		SetItem(1,"ittyp",  gs_gubun)
END Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_sal_02140
boolean visible = false
integer y = 3160
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_02140
boolean visible = false
integer y = 3160
end type

type dw_insert from w_inherite`dw_insert within w_sal_02140
event ue_pressenter pbm_dwnprocessenter
string tag = "this"
integer x = 37
integer y = 312
integer width = 3489
integer height = 2032
string dataobject = "d_sal_021401"
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;String sIttyp, sItcls
	
If row > 0 Then
	sIttyp  = Trim(GetItemString(row,'ittyp'))
	sItcls  = Trim(GetItemString(row,'itcls'))

	/* �ߺз� ��ȸ */
//	dw_2.Retrieve(sIttyp, sItcls+'%')
	
	ScrollToRow(row)
END If

end event

event itemerror;return 1
end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type cb_mod from w_inherite`cb_mod within w_sal_02140
boolean visible = false
integer y = 3160
end type

event cb_mod::clicked;call super::clicked;//String sSalegu, sIttyp, sItcls
//Long   nRow
//
//If dw_input.AcceptText() <> 1 Then return 
//
//sSalegu = Trim(dw_input.GetItemString(1,'salegu'))
//sIttyp  = Trim(dw_input.GetItemString(1,'ittyp'))
//If sSaleGu = '2' then
//	sItcls  = Trim(dw_input.GetItemString(1,'itcls'))
//End If
//
//If sSalegu = '1' Then
//	/* ��з� ���� */
//	If dw_insert.AcceptText() <> 1 Then Return
//	
//	If dw_insert.update() > 0 then
//		commit using sqlca;
//	Else
//		rollback using sqlca ;
//		f_message_chk(32,'')
//		Return
//	End If
//	
//	/* �ߺз� �ϰ� ���� */
// 	If wf_update_middle() < 0 Then Return
//Else
//	/* �ߺз� ���� */
//	If dw_2.AcceptText() <> 1 Then 
//		MessageBox('err','')
//		Return
//	End If
//	
//	If dw_2.update() > 0 then
//		commit using sqlca;
//	Else
//		rollback using sqlca ;
//		f_message_chk(32,'')
//		Return
//	End If
//End If
//
//sle_msg.text = "�����Ͽ����ϴ�!!"
//ib_any_typing = false
end event

type cb_ins from w_inherite`cb_ins within w_sal_02140
boolean visible = false
integer y = 3160
end type

type cb_del from w_inherite`cb_del within w_sal_02140
boolean visible = false
integer y = 3160
end type

event cb_del::clicked;call super::clicked;//String sSalegu, sIttyp, sItcls, sDate
//Long   nRow
//
//sSalegu = Trim(dw_input.GetItemString(1,'salegu'))
//sIttyp  = Trim(dw_input.GetItemString(1,'ittyp'))
//sDate   = Trim(dw_input.GetItemString(1,'start_date'))
//
///* ���� */
//If dw_insert.tag = 'this' Then
//	wf_delete(dw_insert)
//	
//	dw_insert.retrieve(sSalegu, sIttyp, sDate) // ��з� ��ȸ
//Else
//	nRow = dw_2.GetRow()
//	If nRow <= 0 Then Return
//	
//	sItcls  = Trim(dw_2.GetItemString(nRow,'itcls'))
//	
//	wf_delete(dw_2)
//	
//	dw_insert.retrieve(sSalegu, sIttyp, sDate ) // ��з� ��ȸ
//	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // �ߺз� ��ȸ
//End If
//dw_insert.ScrollToRow(nRow)
//
//ib_any_typing = false
end event

type cb_inq from w_inherite`cb_inq within w_sal_02140
boolean visible = false
integer y = 3160
end type

event cb_inq::clicked;call super::clicked;//string salegu, sIttyp, sItcls
//
//If dw_input.AcceptText() <> 1 Then Return
//
//dw_input.SetFocus()
//dw_input.SetRow(1)
//
//salegu = Trim(dw_input.GetItemString(1,'salegu'))
//If IsNull(salegu) Or salegu = '' Then
//	f_message_chk(1400,'[�з�����]')
//	dw_input.setColumn('salegu')
//	Return 2
//End If
//
//sittyp  = Trim(dw_input.GetItemString(1,'ittyp'))
//If IsNull(sittyp) Or sittyp = '' Then
//	f_message_chk(1400,'[ǰ�񱸺�]')
//	dw_input.setColumn('ittyp')
//	Return 2
//End If
//
//sitcls  = Trim(dw_input.GetItemString(1,'itcls'))
//If SaleGu = '2' and ( IsNull(sitcls) Or sitcls = '' ) Then
//	f_message_chk(1400,'[ǰ��з�]')
//	dw_input.setColumn('itcls')
//	Return 2
//End If
//
//If SaleGu = '1' Then /* ��з� ��ȸ */
//	dw_insert.retrieve(sIttyp)
//	dw_2.Reset()
//Else
//	dw_2.retrieve(sIttyp, sItcls+'%')
//	dw_insert.Reset()
//End If
//
///* Protect */
//dw_input.Modify('salegu.protect = 1')
//dw_input.Modify("salegu.background.color = 80859087") 
//dw_input.Modify('ittyp.protect = 1')
//dw_input.Modify("ittyp.background.color = 80859087") 
//
//
end event

type cb_print from w_inherite`cb_print within w_sal_02140
boolean visible = false
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_sal_02140
boolean visible = false
integer y = 3160
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
//dw_2.Reset()
//
//
///* Protect */
//dw_input.Modify('salegu.protect = 0')
//dw_input.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//dw_input.Modify('ittyp.protect = 0')
//dw_input.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//
//dw_input.SetFocus()
//dw_input.SetColumn('ittyp')
//
//ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_sal_02140
boolean visible = false
integer y = 3144
end type

type gb_10 from w_inherite`gb_10 within w_sal_02140
integer y = 3140
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02140
integer y = 3140
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02140
integer y = 3140
end type

type r_head from w_inherite`r_head within w_sal_02140
integer height = 220
end type

type r_detail from w_inherite`r_detail within w_sal_02140
integer y = 308
integer height = 2040
end type

type gb_5 from groupbox within w_sal_02140
boolean visible = false
integer x = 1847
integer y = 2732
integer width = 494
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_sal_02140
boolean visible = false
integer x = 2450
integer y = 2732
integer width = 1179
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

