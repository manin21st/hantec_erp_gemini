$PBExportHeader$w_pig3001.srw
$PBExportComments$�������� ���
forward
global type w_pig3001 from w_inherite_standard
end type 
type dw_1 from datawindow within w_pig3001
end type
type dw_2 from datawindow within w_pig3001
end type
type rr_1 from roundrectangle within w_pig3001
end type
type rr_2 from roundrectangle within w_pig3001
end type
type rr_3 from roundrectangle within w_pig3001
end type
end forward

global type w_pig3001 from w_inherite_standard
string title = "�������� ���"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pig3001 w_pig3001

type variables
string is_empno,is_empname
end variables

on w_pig3001.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_3
end on

on w_pig3001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;long row

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

row = dw_1.InsertRow(0)
dw_1.SetFocus()
dw_1.SetRow(row)
dw_1.SetColumn("carno")
dw_2.Post Retrieve()
ib_any_typing = False
end event

type p_mod from w_inherite_standard`p_mod within w_pig3001
integer x = 3895
end type

event p_mod::clicked;call super::clicked;int row
string carno

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

If dw_1.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
	dw_2.Retrieve()
	p_can.Post TriggerEvent(Clicked!)
Else
   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If
end event

type p_del from w_inherite_standard`p_del within w_pig3001
integer x = 4069
end type

event p_del::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

IF Messagebox("���� Ȯ��", "�������� ������ �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
Else
	Rollback;
End If

end event

type p_inq from w_inherite_standard`p_inq within w_pig3001
integer x = 3547
string picturename = "C:\Erpman\image\��ȸ_up.gif"
end type

type p_print from w_inherite_standard`p_print within w_pig3001
integer x = 3269
integer y = 4920
end type

type p_can from w_inherite_standard`p_can within w_pig3001
integer x = 4242
end type

event p_can::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_1.SetFocus()

dw_1.SetRow(dw_1.InsertRow(0))
dw_1.SetColumn("carno")
dw_1.Modify("carno.Protect=0")
end event

type p_exit from w_inherite_standard`p_exit within w_pig3001
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig3001
integer x = 3721
string picturename = "C:\Erpman\image\�߰�_up.gif"
end type

type p_search from w_inherite_standard`p_search within w_pig3001
integer x = 3095
integer y = 4920
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig3001
integer x = 3790
integer y = 4920
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig3001
integer x = 3963
integer y = 4920
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig3001
integer x = 247
integer y = 4868
end type

type st_window from w_inherite_standard`st_window within w_pig3001
integer x = 2286
integer y = 4772
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig3001
integer x = 3282
integer y = 4600
end type

type cb_update from w_inherite_standard`cb_update within w_pig3001
integer x = 2181
integer y = 4600
integer taborder = 30
end type

event cb_update::clicked;call super::clicked;int row
string carno

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

If dw_1.Update() = 1 Then
   ib_any_typing = False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
	dw_2.Retrieve()
	cb_cancel.Post TriggerEvent(Clicked!)
Else
   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If
end event

type cb_insert from w_inherite_standard`cb_insert within w_pig3001
boolean visible = false
integer x = 1033
integer y = 4956
integer width = 361
integer taborder = 20
string text = "�߰�(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig3001
integer x = 2546
integer y = 4600
integer taborder = 40
end type

event cb_delete::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

IF Messagebox("���� Ȯ��", "�������� ������ �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
Else
	Rollback;
End If

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig3001
boolean visible = false
integer x = 174
integer y = 4600
integer taborder = 70
end type

type st_1 from w_inherite_standard`st_1 within w_pig3001
integer x = 119
integer y = 4772
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig3001
integer x = 2912
integer y = 4600
integer taborder = 50
end type

event cb_cancel::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_1.SetFocus()

dw_1.SetRow(dw_1.InsertRow(0))
dw_1.SetColumn("carno")
dw_1.Modify("carno.Protect=0")
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig3001
integer x = 2930
integer y = 4772
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig3001
integer x = 448
integer y = 4772
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig3001
integer x = 2153
integer y = 4540
integer width = 1536
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig3001
boolean visible = false
integer x = 137
integer y = 4540
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig3001
integer x = 101
integer y = 4720
end type

type dw_1 from datawindow within w_pig3001
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 581
integer y = 96
integer width = 2894
integer height = 608
boolean bringtotop = true
string dataobject = "d_pig1003_01"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;send(handle(this), 256, 9, 0)

return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_empno,ls_empname,ls_deptcode
string arg
int    cnt

arg = Trim(data)
If arg = '' Then Return

SetNull(is_empno)
SetNull(is_empname)

Choose Case dwo.name
//	Case "carno"                  // ������ȣ�� �¿� ������ �������� �����Ѵ�
//      SetItem(row,"carno",arg)			
	Case "caruser"                        // ���Ȯ��
			  
	  SELECT "P1_MASTER"."EMPNO",  "P1_MASTER"."EMPNAME",  "P1_MASTER"."DEPTCODE"  
       INTO :ls_empno,            :ls_empname,         :ls_deptcode
       FROM "P1_MASTER"  
      WHERE "P1_MASTER"."EMPNO" = :arg ;
		
	  If Sqlca.sqlcode <> 0 Then
		  f_message_chk(33,' �����')
		  Return 1
     End If	  
  Case "buydate","dischgdate"         // ��������,������� check
	  If f_datechk(data) = -1 Then return 1 // date���� �ƴϸ� discard
Case "insuend"

End Choose

ib_any_typing = true
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() =  "caruser"  THEN
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(row,"caruser",Gs_code)	
END IF


end event

event dberror;//MessageBox("Ȯ ��"," sql�� ��  : "+String(sqldbcode) +"~n"+&
//		 " �� �� ��  : " + sqlerrtext  + "~n~n" +&
//		 " ó�����  : ����Ƿ� ���ǹٶ��ϴ�", Exclamation! )

return 1
end event

type dw_2 from datawindow within w_pig3001
integer x = 553
integer y = 752
integer width = 3163
integer height = 1532
integer taborder = 10
boolean bringtotop = true
string title = "�������� ��Ȳ"
string dataobject = "d_pig1003_02"
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 then
	dw_2.SelectRow(0,False)
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF

end event

event doubleclicked;int rtn
string carno

If row < 1 Then Return

If ib_any_typing = True Then
   rtn = MessageBox("Ȯ��","����� ������ �ֽ��ϴ�~r��� �����Ͻðڽ��ϱ�?",Question!,YesNo!)	
   If rtn = 2 Then Return
End If

carno = This.Object.carno[row]
If carno = '' Or IsNull(carno) then Return

If dw_1.Retrieve(carno) > 0 Then
   dw_1.Modify("carno.Protect=1")
   ib_any_typing = false
End If

end event

type rr_1 from roundrectangle within w_pig3001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 535
integer y = 52
integer width = 2999
integer height = 668
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pig3001
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4151
integer y = 2628
integer width = 165
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pig3001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 535
integer y = 744
integer width = 3223
integer height = 1552
integer cornerheight = 40
integer cornerwidth = 55
end type

