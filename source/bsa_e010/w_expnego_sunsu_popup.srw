$PBExportHeader$w_expnego_sunsu_popup.srw
$PBExportComments$Nego ������ ��ȸ ����=========>�̻��
forward
global type w_expnego_sunsu_popup from w_inherite_popup
end type
type dw_ip from u_key_enter within w_expnego_sunsu_popup
end type
end forward

global type w_expnego_sunsu_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2432
integer height = 1900
string title = "Nego No. ����"
long backcolor = 80859087
dw_ip dw_ip
end type
global w_expnego_sunsu_popup w_expnego_sunsu_popup

on w_expnego_sunsu_popup.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
end on

on w_expnego_sunsu_popup.destroy
call super::destroy
destroy(this.dw_ip)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_ip.SetItem(1,'sdatef',Left(gs_gubun,8))
dw_ip.SetItem(1,'sdatet',Right(gs_gubun,8))

dw_ip.SetFocus()
dw_ip.SetItem(1,'custcode',gs_code)
dw_ip.SetColumn('custcode')
dw_ip.TriggerEvent(ItemChanged!)

dw_ip.SetColumn('sdatef')

/*  �Ⱓ�� ���� ��� ��ȸ */
If Not IsNull(gs_gubun) Then cb_inq.TriggerEvent(Clicked!)
end event

type dw_1 from w_inherite_popup`dw_1 within w_expnego_sunsu_popup
integer x = 18
integer y = 180
integer width = 2391
integer height = 1476
integer taborder = 20
string dataobject = "d_expnego_sunsu_popup"
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

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "ngno")
//gs_codename = String(dw_1.GetItemNumber(Row, "sunsu"))
//gs_gubun = dw_1.GetItemString(Row, "cvcod")
//
//Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_expnego_sunsu_popup
boolean visible = false
integer x = 1010
integer y = 1800
integer width = 1138
integer taborder = 0
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_expnego_sunsu_popup
integer x = 1463
integer y = 1688
end type

event cb_1::clicked;/* ���õ��� ���� ���� ���� */
dw_1.SetRedraw(False)
dw_1.SetFilter("chk = 'Y'")
dw_1.filter()

IF dw_1.RowCount() <= 0 THEN
   f_message_chk(36,'')
	dw_1.SetFilter("")
	dw_1.filter()
	dw_1.SetRedraw(True)
   return
END IF

/* Ŭ�����忡 ���� */
If dw_1.SaveAs("dummy",Clipboard!,false) = 1 Then
	gs_code     = Trim(dw_1.GetItemString(1, "cvcod"))      /* �ŷ�ó(6) */
	gs_gubun    = String(dw_1.RowCount())
Else
	f_message_chk(164,'')
	gs_gubun = '0'
End If

Close(Parent)
end event

type cb_return from w_inherite_popup`cb_return within w_expnego_sunsu_popup
integer x = 2094
integer y = 1688
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_expnego_sunsu_popup
integer x = 1783
integer y = 1688
boolean default = false
end type

event cb_inq::clicked;String sDatef, sDatet, sCvcod

If dw_ip.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))

dw_ip.SetFocus()
If f_datechk(sDatef) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatef')
	Return 
End If

If f_datechk(sDatet) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatet')
	Return 
End If

If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''

dw_1.Retrieve(gs_sabu,sDatef, sDatet, sCvcod+'%' )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_expnego_sunsu_popup
boolean visible = false
integer x = 521
integer y = 1800
integer width = 471
integer taborder = 0
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_expnego_sunsu_popup
boolean visible = false
integer y = 1816
integer width = 494
string text = "C.INVOICE No."
end type

type dw_ip from u_key_enter within w_expnego_sunsu_popup
integer x = 27
integer y = 44
integer width = 2153
integer height = 104
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_expcid_popup_1"
boolean border = false
end type

event itemchanged;String sNull, sIoCustArea, sDept, sIoCust, sIoCustName

SetNull(sNull)

Choose Case GetColumnName()
	// �������� ��ȿ�� Check
	Case "sdatef"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[��������]')
			this.SetItem(1, "sdatef", sNull)
			return 1
		end if
	// ������ ��ȿ�� Check
	Case "sdatet"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "sdatet", sNull)
			f_Message_Chk(35, '[��������]')
			return 1
		end if
	/* �ŷ�ó */
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"custname",  sIoCustName)
		END IF
	/* �ŷ�ó�� */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."custcode", "VNDMST"."CVNAS2"
		  INTO :sIoCust, :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			Return
		END IF
end Choose

end event

event rbuttondown;String sIoCustName, sIoCustArea, sDept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
/* �ŷ�ó */
Case "custcode"
	gs_gubun = '2'
	Open(w_agent_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"custcode",gs_code)
	
	SELECT "VNDMST"."CVNAS2"
		INTO :sIoCustName
	   FROM "VNDMST"
   	WHERE "VNDMST"."CVCOD" = :gs_code;
	IF SQLCA.SQLCODE = 0 THEN
	  this.SetItem(1,"custname",  sIoCustName)
	END IF
Case "custname"
	gs_codename = Trim(GetText())
	gs_gubun = '2'
	Open(w_agent_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"custcode",gs_code)
	
	SELECT "VNDMST"."CVNAS2"
		INTO :sIoCustName
	   FROM "VNDMST"
   	WHERE "VNDMST"."CVCOD" = :gs_code;
	IF SQLCA.SQLCODE = 0 THEN
	  this.SetItem(1,"custname",  sIoCustName)
	END IF
End Choose

end event

event itemerror;return 1
end event

