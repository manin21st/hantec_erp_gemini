$PBExportHeader$w_sal_02120.srw
$PBExportComments$ ** ���ܰ� ����
forward
global type w_sal_02120 from window
end type
type pb_2 from u_pb_cal within w_sal_02120
end type
type pb_1 from u_pb_cal within w_sal_02120
end type
type p_can from uo_picture within w_sal_02120
end type
type p_exit from uo_picture within w_sal_02120
end type
type p_upd from uo_picture within w_sal_02120
end type
type dw_1 from u_key_enter within w_sal_02120
end type
end forward

global type w_sal_02120 from window
integer x = 677
integer y = 652
integer width = 2103
integer height = 584
boolean titlebar = true
string title = "���ܰ� ����"
windowtype windowtype = response!
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_can p_can
p_exit p_exit
p_upd p_upd
dw_1 dw_1
end type
global w_sal_02120 w_sal_02120

forward prototypes
public function integer wf_junpyo_closeing (string syymm)
public function double wf_calc_danga (string scvcod, string sitnbr)
end prototypes

public function integer wf_junpyo_closeing (string syymm);/* ���� ��������                  */
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

public function double wf_calc_danga (string scvcod, string sitnbr);String sMsgParm[7] = {'ǰ�񸶽�Ÿ','����ȯ��','Ư����ǰ ������','�ŷ�ó ������','��å ������','�ǸŴܰ� ����','�ܰ� = 0'}
int    iRtnValue
double ditemprice,ddcrate
String sToday

sToDay = f_today()
/* �ǸŴܰ��� ������ */
iRtnValue = sqlca.Fun_Erp100000010(sToday,sCvcod,sItnbr, '.', ' ','1',dItemPrice,dDcRate) 
If sqlca.sqlcode <> 0 Then
	MessageBox("Compile Error","Procedure[Fun_Erp100000010] invalid~r~n~r~n����Ƿ� �����ϼ���")
	RollBack;
	Return -1
End If
	
Choose Case abs(iRtnValue)
  Case 0 
	  f_message_chk(41,'[�ܰ� ���]')
	  Return -1
	Case 1	  
	  Return dItemPrice
	Case Else
	  f_message_chk(39,'['+sMsgParm[Abs(iRtnValue)]+']')
	  Return -1
End Choose

end function

on w_sal_02120.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_can=create p_can
this.p_exit=create p_exit
this.p_upd=create p_upd
this.dw_1=create dw_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_can,&
this.p_exit,&
this.p_upd,&
this.dw_1}
end on

on w_sal_02120.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.p_upd)
destroy(this.dw_1)
end on

event open;string sDatef, sDateT

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)

sDatet = f_today()
sDatef = Left(sDatet,6)+'01'

dw_1.SetItem(1,'sdatef',sDatef)
dw_1.SetItem(1,'sdatet',sDatet)
dw_1.SetItem(1,'cvcod',gs_code)
dw_1.SetItem(1,'cvcodnm',gs_codename)

f_window_center(this)
end event

type pb_2 from u_pb_cal within w_sal_02120
integer x = 713
integer y = 240
integer width = 73
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'sdatef', gs_code)

end event

type pb_1 from u_pb_cal within w_sal_02120
integer x = 1157
integer y = 240
integer width = 78
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('sdatet')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'sdatet', gs_code)

end event

type p_can from uo_picture within w_sal_02120
integer x = 1733
integer y = 24
string picturename = "c:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;Closewithreturn(Parent,'')
end event

type p_exit from uo_picture within w_sal_02120
integer x = 1893
integer y = 24
string picturename = "c:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_upd from uo_picture within w_sal_02120
integer x = 1559
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\�ܰ�����_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;This.PictureName = "c:\erpman\image\�ܰ�����_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;This.PictureName = "c:\erpman\image\�ܰ�����_dn.gif"

end event

event clicked;call super::clicked;String sDatef, sDatet, sCvcod, sNull
String sIojpNo, sFcvcod, sItnbr, smsg
Double dItmPrc
Long   nCnt

If dw_1.AcceptText() <> 1 then Return 

SetNull(sNull)

sDatef = Trim(dw_1.GetItemString(1,'sdatef'))
sDatet = Trim(dw_1.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''

dw_1.SetFocus()
If f_datechk(sDatef) <> 1 Then
	f_message_chk(35,'[�������]')
	dw_1.SetColumn('sdatef')
	Return 1
End If

If f_datechk(sDatet) <> 1 Then
	f_message_chk(35,'[�������]')
	dw_1.SetColumn('sdatet')
	Return 1
End If

/* ���⸶������ Ȯ�� */
If wf_junpyo_closeing(Left(sDatef,6)) > 0 Then
	dw_1.SetItem(1,'sdatef',sNull)
	return 1
End If

If wf_junpyo_closeing(Left(sDatet,6)) > 0 Then
	dw_1.SetItem(1,'sdatef',sNull)
	return 1
End If

IF MessageBox("���ܰ� ����","�ش� �Ⱓ���� ���� ǰ���� �ܰ��� �ϰ������մϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

nCnt = sqlca.FUN_ERP100000017(gs_sabu, sdatef, sdatet, scvcod)
Choose Case nCnt 
	Case -1
		rollback;
	  f_message_chk(60,'[���������]')
		Return
	Case -2
		rollback;
	  f_message_chk(60,'[�ܰ�����]')
		Return
End Choose
	
If sqlca.sqlcode = 0 then
  commit;
  f_message_chk(202,'[ó���Ǽ� : ' +String(nCnt) + ']')
Else
	smsg = sqlca.sqlerrtext
	RollBack;
	f_message_chk(57,smsg)
	Return	
End If
end event

type dw_1 from u_key_enter within w_sal_02120
integer x = 37
integer y = 184
integer width = 2039
integer height = 300
integer taborder = 10
string dataobject = "d_sal_02120_01"
boolean border = false
end type

event itemchanged;String  sNull, sDate
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "sdatef"  , "sdatet"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[�������]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
		
		/* ���⸶������ Ȯ�� */
		If wf_junpyo_closeing(Left(sDate,6)) > 0 Then
			SetItem(1,GetColumnName(),sNull)
			return 1
		End If
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvcodnm", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
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
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvcodnm", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcod", sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
End Choose

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod", "cvcodnm"
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

event itemerror;Return 1
end event

