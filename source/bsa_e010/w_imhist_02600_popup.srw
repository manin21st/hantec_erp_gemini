$PBExportHeader$w_imhist_02600_popup.srw
$PBExportComments$��ǰ���� ��ȸ popup
forward
global type w_imhist_02600_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_imhist_02600_popup
end type
type pb_2 from u_pb_cal within w_imhist_02600_popup
end type
type pb_1 from u_pb_cal within w_imhist_02600_popup
end type
type rr_1 from roundrectangle within w_imhist_02600_popup
end type
end forward

global type w_imhist_02600_popup from w_inherite_popup
integer x = 27
integer y = 4
integer width = 2999
integer height = 2004
string title = "��ǰ�Ƿ� ��ȸ ����"
dw_2 dw_2
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_imhist_02600_popup w_imhist_02600_popup

type variables
string isJuncrt1, isJuncrt2
end variables

on w_imhist_02600_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_imhist_02600_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;/* gs_code     : �ŷ�ó               */
/* gs_gubun    : ��ǥ��������         */
/* gs_codename : �˻�Ȯ����/�� (B/A)  */

dw_2.SetTransObject(SQLCA)
// ���ұ��� ����
f_child_saupj(dw_2, 'sarea', gs_saupj)

dw_2.InsertRow(0)

dw_2.SetItem(1, 'cvcod',gs_code)

If gs_codename = 'B' Then
	This.Title = '��ǰ�Ƿ� ��ȸ ����'
	dw_1.dataobject = 'd_imhist_02600_popup2'
ElseIf gs_codename = 'C' Then
	This.Title = '�����ǰ���� ��ȸ ����'
	dw_1.dataobject = 'd_imhist_02600_popup3'
Else
	This.Title = '��ǰ���� ��ȸ ����'
	dw_1.dataobject = 'd_imhist_02600_popup'
End If
dw_1.SetTransObject(Sqlca)

/* gs_gubun : ��ǥ�������� , 2���� ��쵵 ����*/
/* ������� (�Ҵ翡 ����,004) */
If Len(gs_gubun) = 3 Then
   dw_2.setitem(1, 'gub', gs_gubun )
	isJunCrt1 = gs_gubun
	isJunCrt2 = gs_gubun
Else
/* ������� (��Ÿ���⿡ ����,004,024) */
	dw_2.setitem(1, 'gub', Left(gs_gubun,3))
	isJunCrt1 = Left(gs_gubun,3)
	isJunCrt2 = Right(gs_gubun,3)
End If

/* User�� ���ұ��� Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_2.Modify("sarea.protect=1")
	//dw_2.Modify("sarea.background.color = 80859087")
End If
//dw_2.SetItem(1, 'saupj', saupj)
dw_2.SetItem(1, 'sarea', sarea)


// �ΰ��� ����� ����
f_mod_saupj(dw_2, 'saupj')

dw_2.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_2.setitem(1, 'to_date', f_today())
dw_2.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhist_02600_popup
integer x = 23
integer y = 2620
end type

type p_exit from w_inherite_popup`p_exit within w_imhist_02600_popup
integer x = 2757
integer y = 36
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imhist_02600_popup
integer x = 2409
integer y = 36
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet,sarea,scvcod,sItnbr, sSaupj

If dw_2.AcceptText() <> 1 Then Return 1

sdatef = dw_2.GetItemString(1,"fr_date")
sdatet = dw_2.GetItemString(1,"to_date")
sarea  = dw_2.GetItemString(1,"sarea")
scvcod = dw_2.GetItemString(1,"cvcod")
sSaupj = dw_2.GetItemString(1,"saupj")

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[�ΰ������]')
	Return
End If

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sarea  = "" OR IsNull(sarea) THEN	sarea =''
IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''

IF sdatet < sdatef THEN
	f_message_chk(34,'[�Ⱓ]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet, isJunCrt1,isJunCrt2,sarea+'%',scvcod+'%', sSaupj) <= 0 THEN
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF


dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_imhist_02600_popup
integer x = 2583
integer y = 36
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "iojpno")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_imhist_02600_popup
integer x = 87
integer y = 288
integer width = 2825
integer height = 1568
string dataobject = "d_imhist_02600_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "iojpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_imhist_02600_popup
boolean visible = false
integer x = 1015
integer y = 372
integer width = 1001
integer height = 40
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhist_02600_popup
integer x = 2048
integer y = 2296
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code= dw_1.GetItemString(ll_Row, "iojpno")
//
//Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_imhist_02600_popup
integer x = 2670
integer y = 2296
integer taborder = 40
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_imhist_02600_popup
integer x = 2359
integer y = 2296
integer taborder = 20
boolean default = false
end type

event cb_inq::clicked;call super::clicked;//String sdatef,sdatet,sarea,scvcod,sItnbr, sSaupj
//
//If dw_2.AcceptText() <> 1 Then Return 1
//
//sdatef = dw_2.GetItemString(1,"fr_date")
//sdatet = dw_2.GetItemString(1,"to_date")
//sarea  = dw_2.GetItemString(1,"sarea")
//scvcod = dw_2.GetItemString(1,"cvcod")
//sSaupj = dw_2.GetItemString(1,"saupj")
//
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400,'[�ΰ������]')
//	Return
//End If
//
//IF sdatef ="" OR IsNull(sdatef) THEN
//	sdatef ='.'
//END IF
//
//IF sdatet = "" OR IsNull(sdatet) THEN
//	sdatet ='99999999'
//END IF
//
//IF sarea  = "" OR IsNull(sarea) THEN	sarea =''
//IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''
//
//IF sdatet < sdatef THEN
//	f_message_chk(34,'[�Ⱓ]')
//	dw_2.SetColumn("fr_date")
//	dw_2.SetFocus()
//	Return
//END IF
//
//IF dw_1.Retrieve(gs_sabu,sdatef,sdatet, isJunCrt1,isJunCrt2,sarea+'%',scvcod+'%', sSaupj) <= 0 THEN
//	dw_2.SetColumn("fr_date")
//	dw_2.SetFocus()
//	Return
//END IF
//
//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_imhist_02600_popup
boolean visible = false
integer x = 352
integer y = 372
integer width = 425
integer height = 40
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imhist_02600_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "ǰ���ڵ�"
alignment alignment = left!
end type

type dw_2 from datawindow within w_imhist_02600_popup
event ue_processenter pbm_dwnprocessenter
integer x = 69
integer y = 44
integer width = 2322
integer height = 224
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imhist_02040"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String snull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow

SetNull(snull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
	Case "fr_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "to_date", sNull)
			return 1
		END IF
	/* ���ұ��� */
	Case 'sarea'
		SetItem(nRow,'cvcod',sNull)
		SetItem(nRow,'cvcodnm',sNull)
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
END Choose
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod", "cvcodnm"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type pb_2 from u_pb_cal within w_imhist_02600_popup
integer x = 759
integer y = 68
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_2.SetColumn('fr_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_2.SetItem(1, 'fr_date', gs_code)

end event

type pb_1 from u_pb_cal within w_imhist_02600_popup
integer x = 1216
integer y = 68
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_2.SetColumn('to_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_2.SetItem(1, 'to_date', gs_code)

end event

type rr_1 from roundrectangle within w_imhist_02600_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 280
integer width = 2843
integer height = 1592
integer cornerheight = 40
integer cornerwidth = 55
end type

