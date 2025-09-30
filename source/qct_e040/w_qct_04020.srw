$PBExportHeader$w_qct_04020.srw
$PBExportComments$** A/Só��������
forward
global type w_qct_04020 from w_inherite
end type
type dw_jo from u_key_enter within w_qct_04020
end type
type dw_ins1 from u_key_enter within w_qct_04020
end type
type dw_ins2 from u_key_enter within w_qct_04020
end type
type rb_new from radiobutton within w_qct_04020
end type
type rb_mod from radiobutton within w_qct_04020
end type
type cb_item from commandbutton within w_qct_04020
end type
type cb_1 from commandbutton within w_qct_04020
end type
type cb_2 from commandbutton within w_qct_04020
end type
type dw_imhist from datawindow within w_qct_04020
end type
type p_item from uo_picture within w_qct_04020
end type
type p_1 from uo_picture within w_qct_04020
end type
type rr_1 from roundrectangle within w_qct_04020
end type
type rr_2 from roundrectangle within w_qct_04020
end type
end forward

global type w_qct_04020 from w_inherite
string title = "���� ó����� ���"
dw_jo dw_jo
dw_ins1 dw_ins1
dw_ins2 dw_ins2
rb_new rb_new
rb_mod rb_mod
cb_item cb_item
cb_1 cb_1
cb_2 cb_2
dw_imhist dw_imhist
p_item p_item
p_1 p_1
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_04020 w_qct_04020

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
String sdate, jpno, itnbr, itdsc, sRslgu
Long i, j
Real asqty, okqty, nqty

if dw_insert.AcceptText() = -1 then return -1
if dw_ins1.AcceptText() = -1 then return -1
if dw_ins2.AcceptText() = -1 then return -1

sdate = f_today() //�ý�������

if rb_new.Checked = True then
	jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'F1'), "0000") // A/S ó����ȣ	
	jpno = sdate + jpno
else
	jpno = Trim(dw_insert.object.rsl_jpno[1])
end if

if IsNull(jpno) or jpno = "" then
	rollback;	
	f_message_chk(30, "[���� ó����ȣ]")
	return -1
end if	

commit;

//�Ϲ����� �׸� üũ
dw_insert.object.sabu[1] = gs_sabu
dw_insert.object.rsl_jpno[1] = jpno
if IsNull(Trim(dw_insert.object.rsldat[1])) or Trim(dw_insert.object.rsldat[1]) = "" then
	f_message_chk(30, "[ó������]")
	return -1
end if	
if IsNull(Trim(dw_insert.object.as_jpno[1])) or Trim(dw_insert.object.as_jpno[1]) = "" then
	f_message_chk(30, "[�Ƿڹ�ȣ]")
	return -1
end if	
if IsNull(Trim(dw_insert.object.rslemp[1])) or Trim(dw_insert.object.rslemp[1]) = "" then
	f_message_chk(30, "[�����]")
	return -1
end if	
if IsNull(Trim(dw_insert.object.rslgu[1])) or Trim(dw_insert.object.rslgu[1]) = "" then
	f_message_chk(30, "[����]")
	return -1
end if	

if IsNUll(dw_insert.object.rslmtr[1]) then dw_insert.object.rslmtr[1] = 0
if IsNUll(dw_insert.object.rslgon[1]) then dw_insert.object.rslgon[1] = 0

sRslgu = dw_insert.GetItemString(1, 'rslgu')

if sRslgu = "1" then //����
   dw_insert.object.rslamt[1] = dw_insert.object.rslmtr[1] + dw_insert.object.rslgon[1]
	
//	Dec dSumamt
//	
//	If dw_ins2.RowCount() > 0 Then
//		dSumAmt = dw_ins2.GetItemNumber(1, 'sum_rslamt')
//		If IsNull(dSumAmt) Then dSumAmt = 0
//		
//		If dw_insert.GetItemNumber(1, 'rslamt') <> dSumAmt Then
//			f_message_chk(30, "[�ѱݾװ� ǰ�� �ݾ��� ���� Ʋ���ϴ�.!!]")
//			return -1
//		End If
//	End If
Else  //����
	dw_insert.object.rslamt[1] = 0
End If	

//ȯ�� �� ���� �׸�üũ
dw_ins1.object.sabu[1] = gs_sabu
dw_ins1.object.rsl_jpno[1] = jpno
		
for i = 1 to dw_ins2.RowCount()
	dw_ins2.object.sabu[i] = gs_sabu
	dw_ins2.object.rsl_jpno[i] = jpno
	dw_ins2.object.aschno[i]	= i
	dw_ins2.object.as_jpno[i] = dw_insert.object.as_jpno[1]
	dw_ins2.object.rsldat[i] = dw_insert.object.rsldat[1] //ó������
	dw_ins2.object.rcvdat[i] = dw_jo.object.rcvdat[1]     //��������
	
	if dw_ins2.object.okqty[i] < 1 then
		Messagebox("ó������" ,"ó�������� �ʼ��Դϴ�")
		return -1
	end if

	if IsNull(Trim(dw_ins2.object.ascau[i])) or Trim(dw_ins2.object.ascau[i]) = "" then
		f_message_chk(30, "[A/S����]")
		dw_ins2.SetColumn("ascau")
		dw_ins2.SetRow(i)
		dw_ins2.scrolltorow(i)
		dw_ins2.SetFocus()
		return -1
	end if
	
next

dw_insert.AcceptText()
dw_ins1.AcceptText()
dw_ins2.AcceptText()

return 1
end function

on w_qct_04020.create
int iCurrent
call super::create
this.dw_jo=create dw_jo
this.dw_ins1=create dw_ins1
this.dw_ins2=create dw_ins2
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.cb_item=create cb_item
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_imhist=create dw_imhist
this.p_item=create p_item
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jo
this.Control[iCurrent+2]=this.dw_ins1
this.Control[iCurrent+3]=this.dw_ins2
this.Control[iCurrent+4]=this.rb_new
this.Control[iCurrent+5]=this.rb_mod
this.Control[iCurrent+6]=this.cb_item
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.dw_imhist
this.Control[iCurrent+10]=this.p_item
this.Control[iCurrent+11]=this.p_1
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_2
end on

on w_qct_04020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jo)
destroy(this.dw_ins1)
destroy(this.dw_ins2)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.cb_item)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_imhist)
destroy(this.p_item)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
//dw_ip.SetTransObject(SQLCA)

dw_ins1.SetTransObject(SQLCA)
dw_ins2.SetTransObject(SQLCA)
dw_jo.SetTransObject(SQLCA)
dw_imhist.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_ins1.ReSet()
dw_ins1.InsertRow(0)
//dw_ip.InsertRow(0)

dw_ins2.ReSet()

dw_jo.ReSet()
dw_jo.InsertRow(0)

dw_insert.SetFocus()

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_ins2.object.ispec_t.text = is_ispec
	dw_ins2.object.jijil_t.text = is_jijil
END IF

rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)


end event

type dw_insert from w_inherite`dw_insert within w_qct_04020
integer x = 73
integer y = 180
integer width = 4526
integer height = 232
integer taborder = 10
string dataobject = "d_qct_04020_01"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2
Integer i_rtn

s_col  = this.GetColumnName()
s_cod  = Trim(this.GetText())

CHOOSE CASE s_col
	CASE "rsl_jpno" // A/S ó����ȣ
		p_inq.TriggerEvent(Clicked!)
	CASE "rsldat" //ó������
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[ó������]")
		   this.object.rsldat[1] = ""
		   return 1
	   end if
	CASE "rslgu" //������ ����
		if s_cod = "1" then 
		   this.object.zipyn[1] = ""
	   end if
	CASE "as_jpno" // A/S �Ƿڹ�ȣ
		if IsNull(s_cod) or s_cod = "" then return
		select as_jpno
		  into :s_nam1
		  from asreqm
		 where sabu = :gs_sabu and as_jpno = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[A/S �Ƿڹ�ȣ]")
		   this.object.as_jpno[1] = ""
			dw_jo.SetRedraw(False)
			dw_jo.ReSet()
			dw_jo.InsertRow(0)
			dw_jo.SetRedraw(True)
			
			return 1
		else  //ǰ������ �о��
			if dw_jo.Retrieve(gs_sabu, s_cod) < 1 then //�ڷ� ���� ��
			   MessageBox("�Ƿڳ��� Ȯ��","A/S�Ƿڵ� ������ �����ϴ�. [Ȯ���ϼ���]")
				
	         p_mod.Enabled = False
				p_mod.PictureName = 'c:\erpman\image\����_d.gif'

				p_del.Enabled = False
				p_del.PictureName = 'c:\erpman\image\����_d.gif'

	         this.object.as_jpno[1] = ""
				return 1
         end if 
		end if	
END CHOOSE


end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "rsl_jpno" then // A/S ó����ȣ
	open(w_asrslno_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
   this.object.rsl_jpno[1] = gs_code
	this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "as_jpno" then // A/S �Ƿڹ�ȣ
	open(w_asno_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.as_jpno[1] = gs_code
	this.TriggerEvent(itemchanged!)
end if	

end event

event dw_insert::editchanged;return 1
end event

type p_delrow from w_inherite`p_delrow within w_qct_04020
integer x = 3552
end type

event p_delrow::clicked;call super::clicked;
dw_ins2.accepttext()

long Lrow

For Lrow = 1 to dw_ins2.rowcount()
	
	 if dw_ins2.getitemstring(Lrow, "delgu") = 'Y' then
		 dw_ins2.deleterow(Lrow)
		 Lrow = Lrow - 1
	 End if
Next
end event

type p_addrow from w_inherite`p_addrow within w_qct_04020
integer x = 3378
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;IF dw_insert.accepttext() = -1 then return 

gs_code = dw_insert.object.as_jpno[1]
if isnull(gs_code) or trim(gs_code) = '' then
	Messagebox("�Ƿڹ�ȣ", "�Ƿڹ�ȣ�� �Է��Ͻʽÿ�", stopsign!)
	return
end if

dw_ins2.setredraw(false)
openwithparm(w_qct_04020_as, dw_ins2)

dw_ins2.setredraw(True)
setnull(gs_code)


end event

type p_search from w_inherite`p_search within w_qct_04020
boolean visible = false
integer x = 3703
integer y = 3340
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04020
boolean visible = false
integer x = 4224
integer y = 3340
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_04020
integer x = 4421
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_qct_04020
integer x = 4247
integer taborder = 80
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

rb_mod.checked = true 
rb_mod.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"



end event

type p_print from w_inherite`p_print within w_qct_04020
integer x = 3881
integer y = 3356
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04020
integer x = 3726
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String jpno, asno
Long   i

if dw_insert.AcceptText() = -1 then return -1
	
jpno = dw_insert.object.rsl_jpno[1]

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_jo.SetRedraw(False)
dw_jo.ReSet()
dw_jo.InsertRow(0)
dw_jo.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.ReSet()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)

dw_ins2.SetRedraw(False)
dw_ins2.ReSet()
dw_ins2.InsertRow(0)
dw_ins2.SetRedraw(True)

if (IsNull(jpno) or jpno = "")  then 
	f_message_chk(30, "[A/S ó����ȣ]")
	dw_insert.SetColumn("rsl_jpno")
	dw_insert.Setfocus()
	return 1
end if

if dw_insert.Retrieve(gs_sabu, jpno) < 1 then //�ڷ� ���� ��
   dw_insert.SetRedraw(False)
   dw_insert.ReSet()
   dw_insert.InsertRow(0)
   dw_insert.SetRedraw(True)

	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\����_up.gif'

	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\����_d.gif'

	rb_new.Checked = True
	rb_mod.Checked = False
	dw_insert.object.gubun[1] = 0 //ó����ȣ Visible False
	dw_insert.object.asgub[1] = 0 //�Ƿڹ�ȣ Protect False
   MessageBox("�űԵ��", "�ڷᰡ �����ϴ�. �űԷ� ����ϼ���!")

	return
else
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\����_up.gif'

	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\����_up.gif'

	rb_new.Checked = False
	rb_mod.Checked = True
	dw_insert.object.gubun[1] = 1 //ó����ȣ Visible True
	dw_insert.object.asgub[1] = 1 //�Ƿڹ�ȣ Protect True
end if
dw_insert.AcceptText()

asno = dw_insert.object.as_jpno[1]
if not(IsNull(asno) or asno = "") then
   dw_jo.Retrieve(gs_sabu, asno)	
end if

if dw_ins1.Retrieve(gs_sabu, jpno) < 1 then //�ڷ� ���� ��
	dw_ins1.SetRedraw(False)
	dw_ins1.Reset()
	dw_ins1.InsertRow(0)
	dw_ins1.SetRedraw(True)
end if

if dw_ins2.Retrieve(gs_sabu, jpno, asno) < 1 then //�ڷ� ���� ��
	MessageBox("ǰ��Ȯ��","A/Só���� ǰ���� �����ϴ�. [Ȯ���ϼ���]")
//	cb_mod.Enabled = False
//	cb_del.Enabled = False
	return
end if

/* A/S ���⳻�� ��ȸ */
//If dw_imhist.Retrieve(gs_sabu, jpno, asno) < 1 Then
//	cb_print.Text = 'A/S�������(&P)'
//	
//	dw_insert.Modify("rslgu.protect = 0")
//   dw_insert.Modify("rslgu.Background.Color= 12639424")
//Else
//	cb_print.Text = 'A/S�������(&P)'
//	
//	dw_insert.Modify("rslgu.protect = 1")
//   dw_insert.Modify("rslgu.Background.Color= 79741120")
//	
//	cb_2.Enabled = False
//	cb_mod.Enabled = False
//	cb_del.Enabled = False
//End If

rb_new.Checked = False
rb_mod.Checked = True
dw_insert.SetColumn("rsl_jpno")
dw_insert.Setfocus()

return
end event

type p_del from w_inherite`p_del within w_qct_04020
integer x = 4073
integer taborder = 70
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;String rsljpno, asjpno
long i, lcRow

if f_msg_delete() = -1 then return

dw_insert.AcceptText()
dw_ins1.AcceptText()
dw_ins2.AcceptText()

lcRow = dw_insert.GetRow()
rsljpno = dw_insert.object.rsl_jpno[1]
asjpno = dw_insert.object.as_jpno[1]

select count(*) into :i from aspart
 where sabu = :gs_sabu and rsljpno = :rsljpno; 
if sqlca.sqlcode <> 0 or i >= 1 then
	MessageBox("A/S ó�� �ҿ����� Ȯ��", "A/Só�� �ҿ����簡 ��ϵ� �ڷ�� ���� �Ұ��� �մϴ�!" + &
	                                     "�ҿ����縦 ���� ���� �ϼ���!!")
	return 
end if
 

dw_insert.DeleteRow(lcRow)
if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : A/Só�� �Ϲ�����]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if
	
lcRow = dw_ins1.GetRow()
dw_ins1.DeleteRow(lcRow)
if dw_ins1.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : A/Só�� ó������]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if

for i = dw_ins2.RowCount() to 1 Step -1
	   dw_ins2.DeleteRow(i)
next
if dw_ins2.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : A/Só�� ǰ��]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if


COMMIT;

ib_any_typing = False //�Է��ʵ� ���濩�� No
rb_mod.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"

end event

type p_mod from w_inherite`p_mod within w_qct_04020
integer x = 3899
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_mod::clicked;call super::clicked;Long i

if f_msg_update() = -1 then return  //���� Yes/No ?
if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if dw_insert.Update(True,False) <> 1 then
	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ���� : A/Só�� �Ϲ�����]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

if (IsNull(dw_ins1.object.rslmemo_a[1]) or dw_ins1.object.rslmemo_a[1] = "") and &
   (IsNull(dw_ins1.object.rslmemo_b[1]) or dw_ins1.object.rslmemo_b[1] = "") then
else
   if dw_ins1.Update(True,False) <> 1 then
  	   ROLLBACK;
	   f_message_chk(32,'[�ڷ����� ���� : A/Só�� ó������]') 
	   w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	   return 
	end if	
end if

if dw_ins2.Update(True,False) <> 1 then
	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ���� : A/Só�� ǰ��]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

dw_insert.ResetUpdate()
dw_ins1.ResetUpdate()
dw_ins2.ResetUpdate()

COMMIT;

w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"
//cb_del.Enabled = True
//rb_mod.checked = True
//
//dw_insert.object.gubun[1] = 1 //ó����ȣ Visible True
//dw_insert.object.asgub[1] = 1 //�Ƿڹ�ȣ Protect True
//
//dw_insert.AcceptText()
//
ib_any_typing = False //�Է��ʵ� ���濩�� No
 
p_can.triggerevent(clicked!) 
end event

type cb_exit from w_inherite`cb_exit within w_qct_04020
integer x = 2834
integer y = 3288
integer width = 320
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_qct_04020
integer x = 1833
integer y = 3288
integer width = 320
integer textsize = -9
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_04020
integer x = 2441
integer y = 2812
integer width = 325
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_04020
integer x = 2167
integer y = 3288
integer width = 320
integer textsize = -9
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_04020
integer x = 1499
integer y = 3288
integer width = 320
integer textsize = -9
end type

type cb_print from w_inherite`cb_print within w_qct_04020
integer x = 1399
integer y = 2752
integer width = 466
integer textsize = -9
string text = "A/S�������(&P)"
end type

event clicked;call super::clicked;//String sRslgu, sToday, lsIojpno, sSaupj, sCvcod, sNull
//Int	 iMaxIoNo
//Long   k, nRcnt, nRow
//Double dAmt, dItemAmt 
//
//If dw_insert.AcceptText() <> 1 Then Return
//If dw_ins2.AcceptText() <> 1 Then Return
//If dw_ip.AcceptText() <> 1 Then Return
//
//SetNull(sNull)
//
//If This.Text = 'A/S�������(&P)' Then
//	If ib_any_typing = True Or rb_new.Checked = True Then
//		MessageBox('Ȯ ��','������ �����ϼ���.!!')
//		Return
//	End If
//	
//	/* ���� ���� */
//	sRslgu = dw_insert.GetItemString(1, 'rslgu')
//	If sRslgu <> '1' Then
//		MessageBox('Ȯ ��','������ ��츸 ���������մϴ�.!!')
//		Return
//	End If
//	
//	dAmt = dw_insert.GetItemNumber(1, 'amt')
//	If dAmt = 0 Then
//		MessageBox('Ȯ ��','������ �ݾ��� �����ϴ�.!!')
//		Return
//	End If
//	
//	sSaupj = Trim(dw_ip.GetItemString(1, 'saupj'))
//	If IsNull(sSaupj) Or sSaupj ='' Then
//		f_message_chk(30,'[�ΰ������]')
//		Return
//	End If
//	
//	sCvcod = Trim(dw_ip.GetItemString(1, 'cvcod'))
//	If IsNull(sCvcod) Or sCvcod ='' Then
//		f_message_chk(30,'[����ŷ�ó]')
//		Return
//	End If
//	
//	/*�����ȣ ä��*/
//	sToday = f_today()
//	
//	iMaxIoNo = sqlca.fun_junpyo(gs_saupj, sToday,'C0')
//	IF iMaxIoNo <= 0 THEN
//		f_message_chk(51,'')
//		ROLLBACK;
//		Return -1
//	END IF
//	commit;
//	
//	LsIoJpNo = sToday + String(iMaxIoNo,'0000')
//	
//	dw_imhist.Reset()
//	For k = 1 TO dw_ins2.RowCount()
//		dItemamt = dw_ins2.GetItemNumber(k,'rslamt') 
//		
//		if isnull(dItemamt) or dItemamt = 0 then continue  
//		
//		nRow = dw_imhist.InsertRow(0)
//		
//		dw_imhist.SetItem(nRow, "sabu",       gs_saupj )
//		dw_imhist.SetItem(nRow, "saupj",	     sSaupj )
//		dw_imhist.SetItem(nRow, "iojpno",     LsIoJpNo+String(k,'000'))
//		dw_imhist.SetItem(nRow, "sudat",      sToday)
//		dw_imhist.SetItem(nRow, "iogbn",      'O16')	/* ��Ÿ���� */
//	
//		dw_imhist.SetItem(nRow, "itnbr",      dw_ins2.GetItemString(k,'itnbr'))
//		dw_imhist.SetItem(nRow, "pspec",      '.')
//		dw_imhist.SetItem(nRow, "ioqty",      0)
//		dw_imhist.SetItem(nRow, "ioreqty",    0)
//		dw_imhist.SetItem(nRow, "ioprc",      0)
//		dw_imhist.SetItem(nRow, "ioamt",      dw_ins2.GetItemNumber(k,'rslamt'))
//		dw_imhist.SetItem(nRow, "cvcod",	     sCvcod)
//		  
//		dw_imhist.SetItem(nRow, "io_confirm", 'N') 
//		dw_imhist.SetItem(nRow, "io_date",    sToday) 
//		dw_imhist.SetItem(nRow, "filsk",   	  'N') 	/* ���������� */
//		dw_imhist.SetItem(nRow, "inpcnf",	  'O') 	/* ����� ���� */
//		dw_imhist.SetItem(nRow, "jnpcrt",     '029') /* ��ǥ�������� */
//		dw_imhist.SetItem(nRow, "opseq",      '9999')
//		dw_imhist.SetItem(nRow, "outchk",     'N')
//	
//		dw_imhist.SetItem(nRow, "yebi1",      sToday)
//		dw_imhist.SetItem(nRow, "dyebi3",     0)
//		
//		
//		dw_ins2.SetItem(k, "iojpno",     LsIoJpNo+String(k,'000'))
//	Next
//	
//	IF dw_ins2.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(32,'[A/Sǰ��]')
//		Return
//	END IF
//	
//	IF dw_imhist.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(32,'[����]')
//		Return
//	END IF
//	
//	COMMIT;
//	
//	This.Text = 'A/S�������(&P)'
//	dw_insert.Modify("rslgu.protect = 1")
//   dw_insert.Modify("rslgu.Background.Color= 79741120")
//	
//	cb_2.Enabled = False
//	cb_mod.Enabled = False
//	cb_del.Enabled = False
//	
//	sle_msg.Text = '������ �Ϸ�Ǿ����ϴ�.!!'
//Else
//	If dw_imhist.RowCount() <= 0 Then Return
//
//	IF MessageBox("�� ��","A/S���� �ڷᰡ �����˴ϴ�." +"~n~n" +&
//						"���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
//							
//	For k = 1 To dw_ins2.RowCount()
//		dw_ins2.SetItem(k, "iojpno",     sNull)
//	Next
//	IF dw_ins2.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(31,'[A/Sǰ��]')
//		Return
//	END IF
//	
//	dw_imhist.RowsMove(1, dw_imhist.RowCount(), Primary!, dw_imhist, 1, Delete!)
//	IF dw_imhist.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(31,'[����]')
//		Return
//	END IF
//	
//	COMMIT;
//	
//	This.Text = 'A/S�������(&P)'
//	dw_insert.Modify("rslgu.protect = 0")
//   dw_insert.Modify("rslgu.Background.Color= 12639424")
//	
//	cb_2.Enabled = True
//	cb_mod.Enabled = True
//	cb_del.Enabled = True
//	
//	sle_msg.Text = '���������� �����Ǿ����ϴ�.!!'
//End If
//
//cb_inq.TriggerEvent(Clicked!)
end event

type st_1 from w_inherite`st_1 within w_qct_04020
end type

type cb_can from w_inherite`cb_can within w_qct_04020
integer x = 2501
integer y = 3288
integer width = 320
integer textsize = -9
end type

type cb_search from w_inherite`cb_search within w_qct_04020
integer x = 2779
integer y = 2824
end type





type gb_10 from w_inherite`gb_10 within w_qct_04020
integer x = 9
integer y = 2956
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_04020
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04020
end type

type dw_jo from u_key_enter within w_qct_04020
integer x = 78
integer y = 412
integer width = 4526
integer height = 352
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_qct_04020_02"
boolean border = false
end type

type dw_ins1 from u_key_enter within w_qct_04020
integer x = 78
integer y = 760
integer width = 4526
integer height = 324
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_qct_04020_03"
boolean border = false
end type

event ue_pressenter;if this.GetColumnName() = "rslmemo_a" or &
   this.GetColumnName() = "rslmemo_b" then return

Send(Handle(this),256,9,0)
Return 1
end event

type dw_ins2 from u_key_enter within w_qct_04020
event ue_key pbm_dwnkey
integer x = 91
integer y = 1096
integer width = 4485
integer height = 1188
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_qct_04020_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemerror;return 1
end event

event rbuttondown;Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

crow = this.GetRow()
gs_code = this.object.itnbr[crow]
if	this.getcolumnname() = "buitnbr" then //ǰ��
	open(w_pstruc_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.buitnbr[crow] = gs_code
   this.object.buitdsc[crow] = gs_codename
end if	

end event

event itemchanged;Long crow
String  s_cod, s_nam1, s_nam2
Integer i_rtn

crow = this.GetRow()
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //�Է��ʵ� ���濩�� Yes

if (this.GetColumnName() = "okqty") Then //ó������
   this.AcceptText()
	if this.object.okqty[crow] = 0 then
		this.object.fattxt[crow] = ""
		this.object.reptxt[crow] = ""
		this.object.ascau[crow] = ""
		this.object.buitnbr[crow] = ""
		this.object.buitdsc[crow] = ""
		w_mdi_frame.sle_msg.text = "ó�� ������ ZERO�� ǰ���� ó������ �ʽ��ϴ�!"
	end if	
elseif (this.GetColumnName() = "buitnbr") Then //�ҷ���ǰ��ȣ
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
	this.object.buitnbr[crow] = s_cod
	this.object.buitdsc[crow] = s_nam1
	return i_rtn
end if

end event

type rb_new from radiobutton within w_qct_04020
integer x = 133
integer y = 56
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�� ��"
end type

event clicked;rb_mod.Checked = False

p_mod.Enabled = True
p_mod.PictureName = 'c:\erpman\image\����_up.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\����_d.gif'

dw_jo.SetRedraw(False)
dw_jo.Reset()
dw_jo.InsertRow(0)
dw_jo.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)

dw_ins2.SetRedraw(False)
dw_ins2.Reset()
dw_ins2.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_imhist.Reset()
dw_insert.InsertRow(0)

dw_insert.object.gubun[1] = 0 //ó����ȣ Visible False
dw_insert.object.asgub[1] = 0 //�Ƿڹ�ȣ Protect False

dw_insert.SetColumn("rsldat")
dw_insert.Setfocus()
dw_insert.SetRedraw(True)

dw_insert.Modify("rslgu.protect = 0")
//dw_insert.Modify("rslgu.Background.Color= 12639424")

//p_print.Text = 'A/S�������(&P)'

ib_any_typing = False //�Է��ʵ� ���濩�� No

end event

type rb_mod from radiobutton within w_qct_04020
integer x = 448
integer y = 56
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�� ��"
boolean checked = true
end type

event clicked;rb_new.Checked = False

p_mod.Enabled = False
p_mod.PictureName = 'c:\erpman\image\����_d.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\����_d.gif'

dw_jo.SetRedraw(False)
dw_jo.Reset()
dw_jo.InsertRow(0)
dw_jo.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)

dw_ins2.SetRedraw(False)
dw_ins2.Reset()
dw_ins2.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_imhist.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_insert.object.gubun[1] = 1 //ó����ȣ Visible True
dw_insert.object.asgub[1] = 1 //�Ƿڹ�ȣ Protect True

dw_insert.SetColumn("rsl_jpno")
dw_insert.SetFocus()

dw_insert.Modify("rslgu.protect = 0")
//dw_insert.Modify("rslgu.Background.Color= 12639424")

//p_print.Text = 'A/S�������(&P)'

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type cb_item from commandbutton within w_qct_04020
boolean visible = false
integer x = 325
integer y = 3288
integer width = 416
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ҿ�������"
end type

type cb_1 from commandbutton within w_qct_04020
boolean visible = false
integer x = 754
integer y = 3288
integer width = 416
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "A/S�Ƿ� ǰ��"
end type

type cb_2 from commandbutton within w_qct_04020
boolean visible = false
integer x = 1184
integer y = 3288
integer width = 302
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�� ����"
end type

type dw_imhist from datawindow within w_qct_04020
boolean visible = false
integer x = 78
integer y = 3108
integer width = 1641
integer height = 144
boolean bringtotop = true
string dataobject = "d_qct_04020_05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_item from uo_picture within w_qct_04020
boolean visible = false
integer x = 2917
integer y = 24
integer width = 306
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\�ҿ�������_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'c:\erpman\image\�ҿ�������_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'c:\erpman\image\�ҿ�������_up.gif'
end event

event clicked;String s_cod
Real   amt

IF dw_insert.accepttext() = -1 then return 

s_cod = Trim(dw_insert.object.rsl_jpno[1])
if IsNull(s_cod) or s_cod = "" then
	f_message_chk(30, "[A/S ó����ȣ]")
	return
end if	

//rb_mod.TriggerEvent(Clicked!)

OpenSheetWithParm(w_qct_04030, s_cod, w_mdi_frame,2,Layered!)

select sum(unamt) 
  into :amt
  from aspart
 where sabu = :gs_sabu and rsljpno = :s_cod;
 
if sqlca.sqlcode <> 0 then amt = 0
dw_insert.object.rslmtr[1] = amt
dw_insert.AcceptText()


end event

type p_1 from uo_picture within w_qct_04020
boolean visible = false
integer x = 1655
integer y = 20
integer width = 306
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\AS�Ƿ�ǰ��_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'c:\erpman\image\AS�Ƿ�ǰ��_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'c:\erpman\image\AS�Ƿ�ǰ��_up.gif'
end event

type rr_1 from roundrectangle within w_qct_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 20
integer width = 681
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 1084
integer width = 4507
integer height = 1208
integer cornerheight = 40
integer cornerwidth = 55
end type

