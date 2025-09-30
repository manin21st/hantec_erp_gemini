$PBExportHeader$w_pig3002.srw
$PBExportComments$�������೻�����
forward
global type w_pig3002 from w_inherite_standard
end type
type dw_2 from datawindow within w_pig3002
end type
type dw_1 from datawindow within w_pig3002
end type
type st_2 from statictext within w_pig3002
end type
type em_frdate from editmask within w_pig3002
end type
type st_3 from statictext within w_pig3002
end type
type em_todate from editmask within w_pig3002
end type
type rr_1 from roundrectangle within w_pig3002
end type
type rr_3 from roundrectangle within w_pig3002
end type
end forward

global type w_pig3002 from w_inherite_standard
string title = "�������೻�� ���"
dw_2 dw_2
dw_1 dw_1
st_2 st_2
em_frdate em_frdate
st_3 st_3
em_todate em_todate
rr_1 rr_1
rr_3 rr_3
end type
global w_pig3002 w_pig3002

type variables
string is_empno,is_empname
end variables

forward prototypes
public function integer wf_carinfo (string carno)
end prototypes

public function integer wf_carinfo (string carno);// -------------------------------------------------//
// ���� ���� select �� ���س⵵ ��Ģ�� ����Ƚ���� �ݾ� ���  //
// -------------------------------------------------//
string ls_driver,this_year,fr_date,to_date
long   row,ll_cnt,ll_nuk

row = dw_1.RowCount()

If row = 0 Then Return 1

select to_char(sysdate,'yyyy') 
  into :this_year
  from dual;

fr_date = this_year + '0101'
to_date = this_year + '1231'

 SELECT a.driver,nvl(b.cnt,0) , nvl(b.nuk,0 )
   INTO :ls_driver,   :ll_cnt,:ll_nuk  
   FROM "P5_CARMST"  a,
     ( SELECT CARNO,COUNT(CARNO) AS cnt, SUM(ETCFEE) as nuk
         FROM "P5_CARHST"  
        WHERE COSTGBN = '100' AND              // ��Ģ�� �ڵ�
		        ETCFEE  <> 0    AND
		        DRVDATE BETWEEN :fr_date AND :to_date
        GROUP BY  CARNO) b
  WHERE ( a.CARNO = b.CARNO(+) and
	       a.CARNO = :carno ) ;
	 
If Sqlca.sqlcode <> 0 Then
   f_message_chk(33,' ������ȣ')
  Return -1
End If	  
	  
dw_1.SetItem(row,"driver",ls_driver)
dw_1.SetItem(row,"pcnt",ll_cnt)
dw_1.SetItem(row,"pacc",ll_nuk)
			
Return 1

end function

on w_pig3002.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.st_2=create st_2
this.em_frdate=create em_frdate
this.st_3=create st_3
this.em_todate=create em_todate
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_frdate
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_todate
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_3
end on

on w_pig3002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.em_frdate)
destroy(this.st_3)
destroy(this.em_todate)
destroy(this.rr_1)
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

type p_mod from w_inherite_standard`p_mod within w_pig3002
integer x = 3895
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;int row
string carno,drvdate
long   seqno, maxseq

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
If row < 1 Then Return

carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

drvdate = Trim(dw_1.GetItemString(row,"drvdate"))
If drvdate = '' Or IsNull(drvdate) Then                 // key input check
   f_message_chk(1400,' ��������')
	Return 
End If

seqno = dw_1.GetItemNumber(row,"seqno")
If seqno = 0 Or IsNull(seqno) Then                 // key ���� �ڵ��ο�
  SELECT max(seqno)  
    INTO :maxseq  
    FROM "P5_CARHST"  
   WHERE ( "P5_CARHST"."CARNO" = :carno ) AND  
         ( "P5_CARHST"."DRVDATE" = :drvdate )   ;
  if sqlca.sqlcode = 0 then
	  if isnull(maxseq) then
		  maxseq = 1
	  else
	     maxseq = maxseq + 1
	  end if
  else
	  maxseq = 1
  end if
  dw_1.SetItem(row,"seqno",maxseq)
End If

If dw_1.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
   p_inq.PostEvent(Clicked!)
	dw_1.reset()
	dw_1.insertrow(0)
	dw_1.setitem(dw_1.getrow(),"carno",carno)
	dw_1.setfocus()
	dw_1.setcolumn("drvdate")
// 	cb_cancel.PostEvent(Clicked!)
Else
//   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If
end event

type p_del from w_inherite_standard`p_del within w_pig3002
integer x = 4069
integer taborder = 120
end type

event p_del::clicked;call super::clicked;int row 
string carno, drvdate

row = dw_2.GetRow()
If row = 0 Then Return

If dw_2.Object.gacfm[row] = 'Y' Then
   MessageBox("Ȯ ��"," �� �� ��  : ���� �Ұ�~n~n" +&
                      " ó�����  : �ѹ�Ȯ�ε� ������ ������ �Ұ����մϴ�", Exclamation! )
   Return
End If


IF Messagebox("���� Ȯ��", "�������������� �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return
					
dw_1.AcceptText()
carno = Trim(dw_1.GetItemString(row,"carno"))

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
	dw_1.reset()
	dw_1.insertrow(0)
	dw_1.setitem(1,"carno",carno)
	dw_1.setfocus()
	dw_1.setcolumn("drvdate")
Else
	Rollback;
End If

end event

type p_inq from w_inherite_standard`p_inq within w_pig3002
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

carno = Trim(dw_1.GetItemString(dw_1.GetRow(),"carno"))
If carno = '' Or IsNull(carno) Then 
   f_message_chk(40,' ������ȣ')
	Return
End If

dw_2.Retrieve(carno,fr_date,to_date)

end event

type p_print from w_inherite_standard`p_print within w_pig3002
integer x = 3008
integer y = 7308
integer taborder = 210
end type

type p_can from w_inherite_standard`p_can within w_pig3002
integer x = 4242
integer taborder = 140
end type

event p_can::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_2.Reset()
dw_1.SetFocus()
dw_1.SetRow(dw_1.InsertRow(0))
f_dwset_protect(dw_1,1,long(dw_1.Describe("datawindow.column.count")),'0')
dw_1.SetColumn("carno")
p_del.Enabled = True
end event

type p_exit from w_inherite_standard`p_exit within w_pig3002
integer x = 4416
integer taborder = 170
end type

type p_ins from w_inherite_standard`p_ins within w_pig3002
integer x = 3721
integer taborder = 40
end type

type p_search from w_inherite_standard`p_search within w_pig3002
integer x = 2834
integer y = 7308
integer taborder = 190
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig3002
integer x = 3529
integer y = 7308
integer taborder = 50
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig3002
integer x = 3703
integer y = 7308
integer taborder = 80
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig3002
integer x = 512
integer y = 6240
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_pig3002
integer x = 2606
integer y = 6988
integer taborder = 150
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig3002
integer x = 3406
integer y = 6816
integer taborder = 180
end type

type cb_update from w_inherite_standard`cb_update within w_pig3002
integer x = 2304
integer y = 6816
integer taborder = 110
end type

event cb_update::clicked;call super::clicked;int row
string carno,drvdate
long   seqno, maxseq

dw_1.AcceptText()

If dw_1.ModifiedCount() < 1 Then Return

row = dw_1.GetRow()
If row < 1 Then Return

carno = Trim(dw_1.GetItemString(row,"carno"))
If carno = '' Or IsNull(carno) Then                 // key input check
   f_message_chk(1400,' ������ȣ')
	Return 
End If

drvdate = Trim(dw_1.GetItemString(row,"drvdate"))
If drvdate = '' Or IsNull(drvdate) Then                 // key input check
   f_message_chk(1400,' ��������')
	Return 
End If

seqno = dw_1.GetItemNumber(row,"seqno")
If seqno = 0 Or IsNull(seqno) Then                 // key ���� �ڵ��ο�
  SELECT max(seqno)  
    INTO :maxseq  
    FROM "P5_CARHST"  
   WHERE ( "P5_CARHST"."CARNO" = :carno ) AND  
         ( "P5_CARHST"."DRVDATE" = :drvdate )   ;
  if sqlca.sqlcode = 0 then
	  if isnull(maxseq) then
		  maxseq = 1
	  else
	     maxseq = maxseq + 1
	  end if
  else
	  maxseq = 1
  end if
  dw_1.SetItem(row,"seqno",maxseq)
End If

If dw_1.Update() = 1 Then
   ib_any_typing = False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	commit using sqlca;
   cb_retrieve.PostEvent(Clicked!)
	dw_1.reset()
	dw_1.insertrow(0)
	dw_1.setitem(dw_1.getrow(),"carno",carno)
	dw_1.setfocus()
	dw_1.setcolumn("drvdate")
// 	cb_cancel.PostEvent(Clicked!)
Else
//   f_message_chk(37,sqlca.sqlerrtext) //�����ڷ� �߻�
	Rollback;
end If
end event

type cb_insert from w_inherite_standard`cb_insert within w_pig3002
boolean visible = false
integer x = 1463
integer y = 6532
integer width = 361
integer taborder = 90
string text = "�߰�(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig3002
integer x = 2670
integer y = 6816
integer taborder = 130
end type

event cb_delete::clicked;call super::clicked;int row 
string carno, drvdate

row = dw_2.GetRow()
If row = 0 Then Return

If dw_2.Object.gacfm[row] = 'Y' Then
   MessageBox("Ȯ ��"," �� �� ��  : ���� �Ұ�~n~n" +&
                      " ó�����  : �ѹ�Ȯ�ε� ������ ������ �Ұ����մϴ�", Exclamation! )
   Return
End If


IF Messagebox("���� Ȯ��", "�������������� �����˴ϴ� ~n"+&
					"����Ͻðڽ��ϱ�?", question!, yesno!) = 2 then Return
					
dw_1.AcceptText()
carno = Trim(dw_1.GetItemString(row,"carno"))

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
	Commit;
	dw_1.reset()
	dw_1.insertrow(0)
	dw_1.setitem(1,"carno",carno)
	dw_1.setfocus()
	dw_1.setcolumn("drvdate")
Else
	Rollback;
End If

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig3002
integer x = 622
integer y = 6144
integer taborder = 200
end type

event cb_retrieve::clicked;call super::clicked;string fr_date,to_date
string carno

fr_date = Left(em_frdate.Text,4) + Mid(em_frdate.Text,6,2) + Right(em_frdate.Text,2)
to_date = Left(em_todate.Text,4) + Mid(em_todate.Text,6,2) + Right(em_todate.Text,2)

If f_datechk(fr_date) = -1 or f_datechk(to_date) = -1 Then
   MessageBox("Ȯ ��"," �� �� ��  : �������� ����~n~n" +&
		                " ó�����  : �������ڸ� Ȯ���ϼ���", Exclamation! )
End If

carno = Trim(dw_1.GetItemString(dw_1.GetRow(),"carno"))
If carno = '' Or IsNull(carno) Then 
   f_message_chk(40,' ������ȣ')
	Return
End If

dw_2.Retrieve(carno,fr_date,to_date)

end event

type st_1 from w_inherite_standard`st_1 within w_pig3002
integer x = 439
integer y = 6988
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig3002
integer x = 3035
integer y = 6816
integer taborder = 160
end type

event cb_cancel::clicked;call super::clicked;SetNull(is_empno)
SetNull(is_empname)

ib_any_typing = False

dw_1.Reset()
dw_2.Reset()
dw_1.SetFocus()
dw_1.SetRow(dw_1.InsertRow(0))
f_dwset_protect(dw_1,1,long(dw_1.Describe("datawindow.column.count")),'0')
dw_1.SetColumn("carno")
cb_delete.Enabled = True
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig3002
integer x = 3250
integer y = 6988
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig3002
integer x = 768
integer y = 6988
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig3002
integer x = 2240
integer y = 6756
integer width = 1550
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig3002
integer x = 535
integer y = 6092
integer width = 709
integer height = 180
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig3002
integer x = 421
integer y = 6936
end type

type dw_2 from datawindow within w_pig3002
integer x = 475
integer y = 988
integer width = 3616
integer height = 1308
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pig1003_04"
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


end event

event doubleclicked;int rtn,rcnt
string carno,drvdate
long   seqno

If row < 1 Then Return

If ib_any_typing = True Then
   rtn = MessageBox("Ȯ��","����� ������ �ֽ��ϴ�~r��� �����Ͻðڽ��ϱ�?",Question!,YesNo!)	
   If rtn = 2 Then Return
End If

carno = This.Object.carno[row]
drvdate = This.Object.drvdate[row]
seqno = This.Object.seqno[row]

rcnt = dw_1.Retrieve(carno,drvdate,seqno)
If rcnt > 0 Then wf_carinfo(carno)


end event

type dw_1 from datawindow within w_pig3002
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 439
integer y = 168
integer width = 3497
integer height = 816
boolean bringtotop = true
string dataobject = "d_pig1003_03"
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

AcceptText()

arg = Trim(data)
If arg = '' Then Return

Choose Case dwo.name
	Case "carno"                        
      If wf_carinfo(arg) = -1 Then return 1  // ���� ���� select �� ��Ģ�� ����Ƚ���� �ݾ� ��� 
		This.SetItem(row,'drvdate',String(Today(),'yyyymmdd'))
		return
   Case "drvdate"                          
	  If f_datechk(data) = -1 Then return 1   // �������� check 
   Case "arcumudst" ,'stcumudst'                         // ����Ÿ� ���
	  stcumudst = This.GetItemNumber(row,"stcumudst")
	  arcumudst = This.GetItemNumber(row,"arcumudst")
	  This.SetItem(row,"drvdst",arcumudst - stcumudst)
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
	this.SetItem(getrow(),"caruser",Gs_code)	
END IF

IF This.GetColumnName() =  "carno"  THEN
	open(w_car_popup)
	If IsNull(gs_code) Then Return
   If wf_carinfo(gs_code) = -1 Then return 1  // ���� ���� select �� ��Ģ�� ����Ƚ���� �ݾ� ��� 
	This.SetItem(getrow(),'drvdate',String(Today(),'yyyymmdd'))
	this.SetItem(getrow(),"carno",Gs_code)
END IF

end event

event dberror;//return 1
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
	This.Modify("carno.Protect=1")           // �ܼ���ȸ�ô� �������� (key ����)
   This.Modify("drvdate.Protect=1")
	p_del.Enabled = True	
End If	

end event

type st_2 from statictext within w_pig3002
integer x = 562
integer y = 64
integer width = 297
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

type em_frdate from editmask within w_pig3002
integer x = 805
integer y = 64
integer width = 334
integer height = 52
integer taborder = 60
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

type st_3 from statictext within w_pig3002
integer x = 1147
integer y = 64
integer width = 64
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
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_todate from editmask within w_pig3002
integer x = 1211
integer y = 64
integer width = 338
integer height = 52
integer taborder = 70
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

type rr_1 from roundrectangle within w_pig3002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 462
integer y = 984
integer width = 3639
integer height = 1324
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pig3002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 457
integer y = 16
integer width = 1179
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

