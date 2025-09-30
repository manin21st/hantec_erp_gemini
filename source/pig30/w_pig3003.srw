$PBExportHeader$w_pig3003.srw
$PBExportComments$������ ������� ���
forward
global type w_pig3003 from w_inherite_standard
end type
type dw_2 from datawindow within w_pig3003
end type
type dw_1 from datawindow within w_pig3003
end type
type st_2 from statictext within w_pig3003
end type
type em_frdate from editmask within w_pig3003
end type
type st_3 from statictext within w_pig3003
end type
type em_todate from editmask within w_pig3003
end type
type rr_1 from roundrectangle within w_pig3003
end type
type rr_2 from roundrectangle within w_pig3003
end type
type rr_3 from roundrectangle within w_pig3003
end type
end forward

global type w_pig3003 from w_inherite_standard
string title = "������ ������� ���"
dw_2 dw_2
dw_1 dw_1
st_2 st_2
em_frdate em_frdate
st_3 st_3
em_todate em_todate
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pig3003 w_pig3003

type variables
string is_empno,is_empname
end variables

forward prototypes
public function integer wf_carinfo (string carno)
end prototypes

public function integer wf_carinfo (string carno);// -------------------------------------------------//
// ȸ�������ΰ� Ȯ��  //
// -------------------------------------------------//
long   row,cnt

row = dw_1.GetRow()
If row = 0 Then Return 1

  SELECT COUNT(*)
    INTO :cnt  
    FROM "P5_CARMST"  
   WHERE ( "P5_CARMST"."CARNO" = :carno ) AND  
         ( "P5_CARMST"."CARGBN" = '1' )   ;

If cnt = 0 Then
   f_message_chk(33,' ȸ������ Ȯ��')
  Return -1
End If	  
	  
			
Return 1

end function

on w_pig3003.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.st_2=create st_2
this.em_frdate=create em_frdate
this.st_3=create st_3
this.em_todate=create em_todate
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_frdate
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_todate
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
end on

on w_pig3003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.em_frdate)
destroy(this.st_3)
destroy(this.em_todate)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;long row
string first_day,last_day

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

row = dw_1.InsertRow(0)
dw_1.SetFocus()
dw_1.SetRow(row)
dw_1.SetColumn("carno")


// �������� �ʱ�ȭ ����� ù�ϰ� ���������ڷ�..
select to_char(sysdate,'yyyymm') || '01', 
       to_char(last_day(sysdate),'yyyymmdd')
  into :first_day,:last_day		 
  from dual;
  
em_frdate.Text = first_day
em_todate.Text = last_day

ib_any_typing = False

end event

type p_mod from w_inherite_standard`p_mod within w_pig3003
integer x = 3895
end type

event p_mod::clicked;call super::clicked;int row,rtn
string carno,drvdayfr,driver

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

driver = Trim(dw_1.GetItemString(row,"driver"))
If driver = '' Or IsNull(driver) Then                 // key input check
   f_message_chk(1400,' �̿���')
	Return 
End If

drvdayfr = Trim(dw_1.GetItemString(row,"drvdayfr"))
If drvdayfr = '' Or IsNull(drvdayfr) Then                 // key input check
   f_message_chk(1400,' �������')
	Return 
End If

rtn = dw_1.Update()
If rtn = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
   p_inq.Post TriggerEvent(Clicked!)
Else
//	MessageBox(string(rtn),string(sqlca.sqlcode))
   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If

end event

type p_del from w_inherite_standard`p_del within w_pig3003
integer x = 4069
end type

event p_del::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

If dw_2.Object.gacfm[row] = 'Y' Then
   MessageBox("Ȯ ��"," �� �� ��  : ���� �Ұ�~n~n" +&
                      " ó�����  : �ѹ�Ȯ�ε� ������ ������ �Ұ����մϴ�", Exclamation! )
   Return
End If


IF Messagebox("���� Ȯ��", "�������������� �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
Else
	Rollback;
End If

end event

type p_inq from w_inherite_standard`p_inq within w_pig3003
integer x = 3547
end type

event p_inq::clicked;call super::clicked;string fr_date,to_date
string carno

fr_date = Left(em_frdate.Text,4) + Mid(em_frdate.Text,6,2) + Right(em_frdate.Text,2)
to_date = Left(em_todate.Text,4) + Mid(em_todate.Text,6,2) + Right(em_todate.Text,2)

If f_datechk(fr_date) = -1 or f_datechk(to_date) = -1 Then
   MessageBox("Ȯ ��"," �� �� ��  : �������� ����~n~n" +&
		                " ó�����  : �������ڸ� Ȯ���ϼ���", Exclamation! )
End If

If dw_1.GetRow() < 1 Then return

carno = Trim(dw_1.GetItemString(dw_1.GetRow(),"carno"))
If carno = '' Or IsNull(carno) Then 
   f_message_chk(40,' ������ȣ')
	Return
End If

dw_2.Retrieve(carno,fr_date,to_date)

end event

type p_print from w_inherite_standard`p_print within w_pig3003
integer x = 3419
integer y = 5928
end type

type p_can from w_inherite_standard`p_can within w_pig3003
integer x = 4242
end type

event p_can::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_1.SetFocus()
dw_1.SetRow(dw_1.InsertRow(0))
f_dwset_protect(dw_1,1,long(dw_1.Describe("datawindow.column.count")),'0')
dw_1.SetColumn("carno")

p_del.Enabled = True	

end event

type p_exit from w_inherite_standard`p_exit within w_pig3003
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig3003
integer x = 3721
end type

type p_search from w_inherite_standard`p_search within w_pig3003
integer x = 3246
integer y = 5928
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig3003
integer x = 3941
integer y = 5928
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig3003
integer x = 4114
integer y = 5928
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig3003
integer x = 297
integer y = 5548
end type

type st_window from w_inherite_standard`st_window within w_pig3003
integer x = 2391
integer y = 5760
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig3003
integer x = 3191
integer y = 5588
integer taborder = 80
end type

type cb_update from w_inherite_standard`cb_update within w_pig3003
integer x = 2089
integer y = 5588
integer taborder = 50
end type

event cb_update::clicked;call super::clicked;int row,rtn
string carno,drvdayfr,driver

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

driver = Trim(dw_1.GetItemString(row,"driver"))
If driver = '' Or IsNull(driver) Then                 // key input check
   f_message_chk(1400,' �̿���')
	Return 
End If

drvdayfr = Trim(dw_1.GetItemString(row,"drvdayfr"))
If drvdayfr = '' Or IsNull(drvdayfr) Then                 // key input check
   f_message_chk(1400,' �������')
	Return 
End If

rtn = dw_1.Update()
If rtn = 1 Then
   ib_any_typing = False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
   cb_retrieve.Post TriggerEvent(Clicked!)
Else
//	MessageBox(string(rtn),string(sqlca.sqlcode))
   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If

end event

type cb_insert from w_inherite_standard`cb_insert within w_pig3003
boolean visible = false
integer x = 1248
integer y = 5304
integer width = 361
integer taborder = 40
string text = "�߰�(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig3003
integer x = 2455
integer y = 5588
integer taborder = 60
end type

event cb_delete::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

If dw_2.Object.gacfm[row] = 'Y' Then
   MessageBox("Ȯ ��"," �� �� ��  : ���� �Ұ�~n~n" +&
                      " ó�����  : �ѹ�Ȯ�ε� ������ ������ �Ұ����մϴ�", Exclamation! )
   Return
End If


IF Messagebox("���� Ȯ��", "�������������� �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
Else
	Rollback;
End If

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig3003
integer x = 407
integer y = 5452
integer taborder = 90
end type

event cb_retrieve::clicked;call super::clicked;string fr_date,to_date
string carno

fr_date = Left(em_frdate.Text,4) + Mid(em_frdate.Text,6,2) + Right(em_frdate.Text,2)
to_date = Left(em_todate.Text,4) + Mid(em_todate.Text,6,2) + Right(em_todate.Text,2)

If f_datechk(fr_date) = -1 or f_datechk(to_date) = -1 Then
   MessageBox("Ȯ ��"," �� �� ��  : �������� ����~n~n" +&
		                " ó�����  : �������ڸ� Ȯ���ϼ���", Exclamation! )
End If

If dw_1.GetRow() < 1 Then return

carno = Trim(dw_1.GetItemString(dw_1.GetRow(),"carno"))
If carno = '' Or IsNull(carno) Then 
   f_message_chk(40,' ������ȣ')
	Return
End If

dw_2.Retrieve(carno,fr_date,to_date)

end event

type st_1 from w_inherite_standard`st_1 within w_pig3003
integer x = 224
integer y = 5760
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig3003
integer x = 2821
integer y = 5588
integer taborder = 70
end type

event cb_cancel::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_1.SetFocus()
dw_1.SetRow(dw_1.InsertRow(0))
f_dwset_protect(dw_1,1,long(dw_1.Describe("datawindow.column.count")),'0')
dw_1.SetColumn("carno")

cb_delete.Enabled = True	

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig3003
integer x = 3035
integer y = 5760
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig3003
integer x = 553
integer y = 5760
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig3003
integer x = 2025
integer y = 5528
integer width = 1550
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig3003
integer x = 320
integer y = 5400
integer width = 709
integer height = 180
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig3003
integer x = 206
integer y = 5708
end type

type dw_2 from datawindow within w_pig3003
integer x = 631
integer y = 724
integer width = 3355
integer height = 1564
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig1003_06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)



end event

event doubleclicked;int rtn,rcnt
string carno,drvdayfr,driver

If row < 1 Then Return

If ib_any_typing = True Then
   rtn = MessageBox("Ȯ��","����� ������ �ֽ��ϴ�~r��� �����Ͻðڽ��ϱ�?",Question!,YesNo!)	
   If rtn = 2 Then Return
End If

carno = This.Object.carno[row]
driver = This.Object.driver[row]
drvdayfr = This.Object.drvdayfr[row]

rcnt = dw_1.Retrieve(carno,driver,drvdayfr)
If rcnt > 0 Then 
	wf_carinfo(carno)
	ib_any_typing = false
End If




end event

type dw_1 from datawindow within w_pig3003
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 695
integer y = 236
integer width = 2139
integer height = 452
boolean bringtotop = true
string dataobject = "d_pig1003_05"
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
string ls_driver
long   ll_cnt,ll_nuk,stcumudst,arcumudst
string arg
int    cnt

arg = Trim(data)
If arg = '' Then Return

Choose Case dwo.name
	Case "carno"                        
      If wf_carinfo(arg) = -1 Then return 1  // ȸ�������ΰ� Ȯ��
   Case "drvdayfr" ,"drvdayto"
	  If f_datechk(data) = -1 Then return 1   // �������� check 
	Case "driver"                        // ���Ȯ��
			  
	  SELECT "P1_MASTER"."EMPNO",  "P1_MASTER"."EMPNAME",  "P1_MASTER"."DEPTCODE"  
       INTO :ls_empno,            :ls_empname,         :ls_deptcode
       FROM "P1_MASTER"  
      WHERE "P1_MASTER"."EMPNO" = :arg ;
		
	  If Sqlca.sqlcode <> 0 Then
		  f_message_chk(33,' �����')
		  Return 1
     End If	  
End Choose

ib_any_typing = true


end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() =  "carno"  THEN
	
	open(w_car_popup)
	If IsNull(gs_code) Or gs_code = '' Then return
   If wf_carinfo(gs_code) = -1 Then return 1  // ȸ�������ΰ� Ȯ��
	this.SetItem(getrow(),"carno",Gs_code)
END IF

IF This.GetColumnName() =  "driver"  THEN
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(getrow(),"driver",Gs_code)	
END IF


end event

event dberror;return 1
end event

event retrieveend;string ls_col_no
int    li_i

// ��ȸ�� key �κ��� ������ϵ��� �Ѵ�
If Not (rowcount > 0 ) Then Return

If This.Object.gacfm[rowcount] = 'Y' Then        // �ѹ��� Ȯ�ε� - ���� �Ұ�
   f_dwset_protect(this,1,long(Describe("datawindow.column.count")),'1')
	p_del.Enabled = False
Else
   f_dwset_protect(this,1,long(Describe("datawindow.column.count")),'0')
   Modify("carno.Protect=1")
   Modify("driver.Protect=1")	
   Modify("drvdayfr.Protect=1")
	p_del.Enabled = True	
End If	

end event

type st_2 from statictext within w_pig3003
integer x = 645
integer y = 96
integer width = 279
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "��������"
boolean focusrectangle = false
end type

type em_frdate from editmask within w_pig3003
integer x = 942
integer y = 96
integer width = 334
integer height = 52
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
long textcolor = 33554432
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type st_3 from statictext within w_pig3003
integer x = 1303
integer y = 96
integer width = 64
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_todate from editmask within w_pig3003
integer x = 1394
integer y = 96
integer width = 334
integer height = 52
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
long textcolor = 33554432
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type rr_1 from roundrectangle within w_pig3003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 622
integer y = 220
integer width = 2263
integer height = 484
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pig3003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 622
integer y = 720
integer width = 3383
integer height = 1576
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pig3003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 622
integer y = 40
integer width = 1179
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

