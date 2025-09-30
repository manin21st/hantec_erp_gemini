$PBExportHeader$w_pdm_01420_change.srw
$PBExportComments$** ��ü�۾��� ���
forward
global type w_pdm_01420_change from window
end type
type dw_2 from datawindow within w_pdm_01420_change
end type
type p_exit from uo_picture within w_pdm_01420_change
end type
type p_mod from uo_picture within w_pdm_01420_change
end type
type p_del from uo_picture within w_pdm_01420_change
end type
type p_ins from uo_picture within w_pdm_01420_change
end type
type dw_1 from datawindow within w_pdm_01420_change
end type
type rr_1 from roundrectangle within w_pdm_01420_change
end type
end forward

global type w_pdm_01420_change from window
integer x = 5
integer y = 148
integer width = 2030
integer height = 1652
boolean titlebar = true
string title = "��ü�۾��� ���"
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
dw_1 dw_1
rr_1 rr_1
end type
global w_pdm_01420_change w_pdm_01420_change

type variables
boolean ib_ItemError
string is_item
end variables

event open;String sWcDscr

f_window_center(this)

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_2.InsertRow(0)

is_Item = Message.StringParm

dw_2.SetItem(1,"wkctr",is_Item)

SELECT "WRKCTR"."WCDSC"  
	INTO :sWcDscr
   FROM "WRKCTR"  
   WHERE "WRKCTR"."WKCTR" = :is_Item  ;
dw_2.SetItem(1,"wcdsc",sWcDscr)

IF dw_1.Retrieve(is_Item) < 1		THEN
END IF


end event

on w_pdm_01420_change.create
this.dw_2=create dw_2
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.dw_1,&
this.rr_1}
end on

on w_pdm_01420_change.destroy
destroy(this.dw_2)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event key;// Page Up & Page Down & Home & End Key ��� ����
choose case key
//	case keypageup!
//		dw_list.scrollpriorpage()
//	case keypagedown!
//		dw_list.scrollnextpage()
//	case keyhome!
//		dw_list.scrolltorow(1)
//	case keyend!
//		dw_list.scrolltorow(dw_list.rowcount())
//	case KeyupArrow!
//		dw_list.scrollpriorrow()
//	case KeyDownArrow!
//		dw_list.scrollnextrow()
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
//	Case KeyQ!
//		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
//	Case KeyC!
//		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_2 from datawindow within w_pdm_01420_change
integer x = 32
integer y = 16
integer width = 1152
integer height = 132
string title = "none"
string dataobject = "d_pdm_01420_change_0"
boolean border = false
boolean livescroll = true
end type

type p_exit from uo_picture within w_pdm_01420_change
integer x = 1783
integer y = 8
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_mod from uo_picture within w_pdm_01420_change
integer x = 1609
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;
IF dw_1.Accepttext() = -1 THEN 	
	dw_1.setfocus()
	RETURN
END IF

// REQUIRED FIELD Ȯ��
IF f_CheckRequired(dw_1) = -1 THEN 	RETURN

//IF MessageBox("Ȯ��", "�����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

IF dw_1.Update() > 0	THEN
	COMMIT USING sqlca;															 
ELSE
	ROLLBACK USING sqlca;
END IF
		
/////////////////////////////////////////////////////////////////////////////////
p_exit.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_del from uo_picture within w_pdm_01420_change
integer x = 1435
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;
long	lRow
lRow = dw_1.GetRow()

IF lRow < 1		THEN	RETURN

IF	 MessageBox("���� Ȯ��", "�����Ͻðڽ��ϱ�? ", &
						         question!, yesno!, 2)  = 1		THEN
   dw_1.DeleteRow(lRow)

   IF dw_1.Update() > 0	 THEN
      COMMIT;
	ELSE
		ROLLBACK;
	END IF
   

END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_ins from uo_picture within w_pdm_01420_change
integer x = 1262
integer y = 8
integer width = 178
integer taborder = 10
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\�߰�_up.gif"
end type

event clicked;call super::clicked;
IF dw_1.AcceptText() = -1		THEN	
	dw_1.SetFocus()
	RETURN
END IF

IF f_CheckRequired(dw_1) = -1 THEN 	RETURN

///////////////////////////////////////////////////////////////////////////////
long		lRow

lRow = dw_1.InsertRow(0)

dw_1.SetItem(lRow, "wrkchange_wkctr", 	is_Item)

dw_1.ScrollToRow(lRow)		
dw_1.SetFocus()							


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�߰�_up.gif"
end event

type dw_1 from datawindow within w_pdm_01420_change
event ue_key pbm_dwnkey
integer x = 55
integer y = 180
integer width = 1897
integer height = 1328
integer taborder = 20
string dataobject = "d_pdm_01420_change"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
////		* Error Message Handling  1
//////////////////////////////////////////////////////////////////////////////
//
////	1) ItemChanged -> Required Column �� �ƴ� Column ���� Error �߻��� 
//
//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF
//
//
//
////	2) Required Column  ���� Error �߻��� 
//
//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//st_status.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

RETURN 1
	
end event

event itemchanged;
long		lRow,lReturnRow, l_count	
string	sNull,sItem, sName
	
SetNull(sNull)

IF this.GetColumnName() = "wrkchange_change" THEN
	lRow  = this.GetRow()	
	
	sItem = THIS.GETTEXT()								
	
	lReturnRow = This.Find("wrkchange_change = '"+sItem+"' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("Ȯ��","��ϵ� �۾����ڵ��Դϴ�.~r����� �� �����ϴ�.")
		this.SetItem(lRow, "wrkchange_change", sNull)
		this.SetItem(lRow, "wrkctr_wcdsc", sNull)
		
		ib_itemerror = TRUE
		RETURN  1
		
	END IF
	
	////////////////////////////////////////////////////////////////////////////
	
	IF sItem = is_item	THEN	
		Messagebox("Ȯ ��","�۾��ϰ� �ִ� �۾���� ���� �۾������� ��ü�� �� �����ϴ�.!!") 
		this.setitem(lRow, "wrkchange_change", sNull)
		this.SetItem(lRow, "wrkctr_wcdsc", sNull)
		
		ib_ItemError = true
		return 1
	END IF
	
	////////////////////////////////////////////////////////////////////////////
	
//  SELECT COUNT("WRKCHANGE"."WKCTR")
//    INTO :l_count  
//    FROM "WRKCHANGE"  
//   WHERE "WRKCHANGE"."WKCTR" = :sItem   ;
//
//	IF l_count > 0 THEN
//		Messagebox("Ȯ ��","�����۾������� ��ϵ� �ڷ�� ��ü�۾������� ����� �� �����ϴ�.!!") 
//		this.setitem(lRow, "wrkchange_change", sNull)
//		this.SetItem(lRow, "wrkctr_wcdsc", sNull)
//		ib_ItemError = true
//		RETURN  1
//	END IF

	IF ISNULL(sItem) or  sItem = ''	THEN 	Return 1
	
	  SELECT "WCDSC"
		 INTO :sName
		 FROM "WRKCTR"  
		WHERE ("WKCTR" = :sItem )  ;
	
	if sqlca.sqlcode <> 0 	then
		messagebox("Ȯ��","��ϵ�  �۾����� �ƴմϴ�.")
		this.setitem(lRow, "wrkchange_change", sNull)
		this.SetItem(lRow, "wrkctr_wcdsc", sNull)
		
		ib_ItemError = true
		return 1
	end if
	
	this.Setitem(lRow,"wrkctr_wcdsc", sName)

END IF


end event

event rowfocuschanged;this.Setrowfocusindicator(hand!)
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "wrkchange_change"	THEN
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(row, "wrkchange_change", 	 gs_Code)
	
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

type rr_1 from roundrectangle within w_pdm_01420_change
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 164
integer width = 1925
integer height = 1360
integer cornerheight = 40
integer cornerwidth = 55
end type

