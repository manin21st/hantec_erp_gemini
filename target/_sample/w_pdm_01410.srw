$PBExportHeader$w_pdm_01410.srw
$PBExportComments$** ���� �ο�����
forward
global type w_pdm_01410 from w_inherite
end type
type dw_pdt from datawindow within w_pdm_01410
end type
type gb_1 from groupbox within w_pdm_01410
end type
type dw_jo from datawindow within w_pdm_01410
end type
type dw_ins from datawindow within w_pdm_01410
end type
type st_2 from statictext within w_pdm_01410
end type
type st_3 from statictext within w_pdm_01410
end type
type pb_1 from picturebutton within w_pdm_01410
end type
type dw_update from u_d_select_sort within w_pdm_01410
end type
type r_jo from rectangle within w_pdm_01410
end type
end forward

global type w_pdm_01410 from w_inherite
integer width = 4686
integer height = 2500
string title = "���� �ο�����"
dw_pdt dw_pdt
gb_1 gb_1
dw_jo dw_jo
dw_ins dw_ins
st_2 st_2
st_3 st_3
pb_1 pb_1
dw_update dw_update
r_jo r_jo
end type
global w_pdm_01410 w_pdm_01410

type variables
long oldrow, ctrl_count=0, target_row, min_row
int flag=0 

string is_update = 'N', is_delete = 'N'
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
Long i

for i = 1 to dw_insert.RowCount()
	if Isnull(dw_insert.object.jocod[i]) or dw_insert.object.jocod[i] =  "" then
	   f_message_chk(1400,'[���ڵ�]')
	   dw_insert.SetColumn('jocod')
	   dw_insert.SetFocus()
	   return -1
   end if	
	
	if Isnull(dw_insert.object.jonam[i]) or dw_insert.object.jonam[i] =  "" then
	   f_message_chk(1400,'[����]')
	   dw_insert.SetColumn('jonam')
	   dw_insert.SetFocus()
	   return -1
   end if
	
	if Isnull(dw_insert.object.dptno[i]) or dw_insert.object.dptno[i] =  "" then
	   f_message_chk(1400,'[������]')
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

on w_pdm_01410.create
int iCurrent
call super::create
this.dw_pdt=create dw_pdt
this.gb_1=create gb_1
this.dw_jo=create dw_jo
this.dw_ins=create dw_ins
this.st_2=create st_2
this.st_3=create st_3
this.pb_1=create pb_1
this.dw_update=create dw_update
this.r_jo=create r_jo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pdt
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_jo
this.Control[iCurrent+4]=this.dw_ins
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_update
this.Control[iCurrent+9]=this.r_jo
end on

on w_pdm_01410.destroy
call super::destroy
destroy(this.dw_pdt)
destroy(this.gb_1)
destroy(this.dw_jo)
destroy(this.dw_ins)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.dw_update)
destroy(this.r_jo)
end on

event open;call super::open;dw_update.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_jo.SetTransObject(SQLCA)
dw_pdt.SetTransObject(SQLCA)


dw_update.Reset()

dw_ins.Setredraw(False)
dw_ins.ReSet()
dw_ins.Retrieve()
dw_ins.Setredraw(True)

dw_jo.Setredraw(False)
dw_jo.ReSet()
dw_jo.Retrieve()
dw_jo.Setredraw(True)

dw_pdt.Setredraw(False)
dw_pdt.ReSet()
dw_pdt.InsertRow(0)
dw_pdt.Setredraw(True)

dw_pdt.SetFocus()

p_inq.TriggerEvent(Clicked!)
end event

event resize;r_detail.height = this.height - r_detail.y - 65
dw_update.height = this.height - dw_update.y - 70

r_jo.width = this.width - 2900
r_jo.height = this.height - r_jo.y - 65
dw_jo.width = this.width - 2910
dw_jo.height = this.height - dw_jo.y - 70
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
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
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = true  //// ����
m_main2.m_window.m_save.enabled = true //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = false  //// ã��
m_main2.m_window.m_filter.enabled = false //// ����
m_main2.m_window.m_excel.enabled = false //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01410
integer x = 5170
integer y = 3376
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01410
integer x = 5362
integer y = 3192
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01410
integer x = 5362
integer y = 3192
end type

type st_1 from w_inherite`st_1 within w_pdm_01410
integer y = 3344
end type

type p_search from w_inherite`p_search within w_pdm_01410
integer x = 5358
integer y = 3196
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01410
integer x = 5358
integer y = 3196
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01410
integer x = 5358
integer y = 3196
end type

type p_mod from w_inherite`p_mod within w_pdm_01410
integer y = 3376
end type

event p_mod::clicked;call super::clicked;String s_jocod, s_jonam, s_empno
Long i, j

//s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
//s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]
//for i = 1 to dw_update.RowCount()
//	if dw_update.IsSelected (i) then
//		dw_update.object.jocod[i] = s_jocod
//		dw_update.object.jonam[i] = s_jonam
//	end if	
//next	

if f_msg_update() = -1 then return  //���� Yes/No ?

dw_jo.AcceptText()
dw_update.AcceptText()

s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]
dw_ins.Setredraw(False)
for i = 1 to dw_update.RowCount()
//	if dw_update.IsSelected(i) then
	if dw_update.object.upd[i] = "UPD" then
		if IsNull(dw_update.object.jocod[i]) or dw_update.object.jocod[i] = "" then
			MessageBox("���ڵ� ����", + &
			"���ڵ尡 ���õ��� ���� ����� �ֽ��ϴ�![" + String(dw_update.object.empname[i]) + "]")
    	   return
		end if	
		if IsNull(dw_update.object.drtim[i]) or dw_update.object.drtim[i] = "" then
			
			MessageBox("�ð����뱸�� ����", + &
			"�ð����뱸���� ���õ��� ���� ����� �ֽ��ϴ�![" + String(dw_update.object.empname[i]) + "]")
    	   dw_update.SetRow(i)
			dw_update.SetColumn("drtim")
			dw_update.SetFocus() 
			return
		end if	
		

		s_empno = dw_update.object.mempno[i]
		j = dw_ins.Find("empno = '" + s_empno + "'", 1, dw_ins.RowCount())
		if IsNull(j) or j < 1 then
			dw_ins.InsertRow(0)
			j = dw_ins.RowCount()
		end if					
		dw_ins.object.jocod[j] = dw_update.object.jocod[i]
		dw_ins.object.empno[j] = s_empno
		dw_ins.object.josts[j] = dw_update.object.josts[i]
		dw_ins.object.drtim[j] = dw_update.object.drtim[i]
		
		dw_ins.object.sub_jocod[j] = dw_update.object.sub_jocod[i]
		
		dw_ins.AcceptText()
	end if	
next	
dw_ins.Setredraw(True)

if dw_ins.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"	
	//ib_any_typing = False //�Է��ʵ� ���濩�� No
else
	f_message_chk(32,'[�ڷ����� ����]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

p_inq.TriggerEvent(Clicked!)

dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False) 
ib_any_typing = False


end event

type p_del from w_inherite`p_del within w_pdm_01410
integer y = 3376
end type

event p_del::clicked;call super::clicked;String s_jocod, s_jonam, s_empno
Long i, j

if f_msg_delete() = -1 then return  //���� Yes/No ?

dw_jo.AcceptText()
dw_update.AcceptText()

//s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
//s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected(i) then
		s_empno = dw_update.object.empname[i]
		if IsNull(dw_update.object.jocod[i]) or dw_update.object.jocod[i] = "" then
			MessageBox("���ڵ� ����", + &
			"���ڵ尡 ���õ��� ���� ����� �ֽ��ϴ�![" + s_empno + "]")
    	   return
		end if	
	end if
next

dw_ins.Setredraw(False)
for i = dw_update.RowCount() to 1 step -1
	if dw_update.IsSelected(i) then
		s_empno = dw_update.object.empno[i]
		j = dw_ins.Find("empno = '" + s_empno + "'", 1, dw_ins.RowCount())
		if not (IsNull(j) or j < 1) then
			dw_ins.DeleteRow(j)
		end if					
	end if	
next	
dw_ins.SetRedraw(True)
dw_ins.AcceptText()

if dw_ins.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
else	
   ROLLBACK;
	f_message_chk(31,'[��������]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if

p_inq.TriggerEvent(Clicked!)

dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False) 
ib_any_typing = False

end event

type p_inq from w_inherite`p_inq within w_pdm_01410
integer y = 3376
end type

event p_inq::clicked;call super::clicked;String pdtgu, gu
Long l_rcnt

dw_pdt.AcceptText()

//pdtgu = dw_pdt.object.pdtgu[1]
gu = dw_pdt.object.gu[1]

//if IsNull(pdtgu) or pdtgu = "" then
//	f_message_chk(30, "[������]")
//	dw_pdt.SetColumn("pdtgu")
//	dw_pdt.SetFocus()
//	return
//end if
//
dw_update.Setredraw(False)
//l_rcnt = dw_update.Retrieve(pdtgu, gu)  //���������� ����
l_rcnt = dw_update.Retrieve(gu)
if l_rcnt < 1 then
	dw_update.Reset()
	dw_update.Setredraw(True)
	f_message_chk(50, "[���]")
//	p_mod.Enabled = False
//	p_del.Enabled = False
//	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
//	p_del.PictureName = 'C:\erpman\image\����_d.gif'
	is_update = 'N'
	is_delete = 'N'
	return
end if	
dw_update.Setredraw(True)

dw_jo.SelectRow(0, False)
if gu = '1' then 
//	p_mod.Enabled = True
//	p_del.Enabled = True
//	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
//	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	is_update = 'Y'
	is_delete = 'Y'
else	
//	p_mod.Enabled = true   //lsh  False
//	p_del.Enabled = True
//	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
//	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	is_update = 'N'
	is_delete = 'Y'
end if	

dw_update.SetFocus()
ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_pdm_01410
integer y = 3376
end type

type p_can from w_inherite`p_can within w_pdm_01410
integer y = 3376
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type p_exit from w_inherite`p_exit within w_pdm_01410
integer y = 3376
end type

type p_ins from w_inherite`p_ins within w_pdm_01410
integer y = 3376
end type

type p_new from w_inherite`p_new within w_pdm_01410
integer y = 3376
end type

type dw_input from w_inherite`dw_input within w_pdm_01410
boolean visible = false
integer y = 2976
end type

type cb_delrow from w_inherite`cb_delrow within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_addrow from w_inherite`cb_addrow within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type dw_insert from w_inherite`dw_insert within w_pdm_01410
boolean visible = false
integer x = 23
integer y = 692
integer width = 2597
integer height = 880
integer taborder = 40
string dataobject = "d_pdm_01410_01"
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sCol, ls_deptcode, ls_joname

sCol = this.GetColumnName()
if sCol = "drtim" then
	dw_insert.object.upd[row] = "UPD"
end if	

if sCol = "jocod" then
	ls_deptcode = this.getitemstring( row, 'deptcode')
	
	SELECT JONAM
	INTO	 :ls_joname
	FROM JOMAST
	WHERE JOCOD = :data
	AND	DPTNO = :ls_deptcode 
	USING SQLCA ;
	
	IF isnull(ls_joname) or ls_joname = "" then
		dw_insert.object.jonam[row] = ""
		return 2
	end if
	dw_insert.object.jonam[row] = ls_joname
	
	
	dw_insert.object.upd[row] = "UPD"
end if	


end event

event dw_insert::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event dw_insert::clicked;//IF row <= 0	then RETURN									
//this.selectrow(row, True)


// �輺�� 2004.12.17
// ���� ���� ���� ���μ����� ó��...

integer li_row, r_count 


if KeyDown(keyshift!) then // shift key�� ������ ���¶�� 
  if row > oldrow then 
	// row�� �ĺ����� �����ϴ� ���� ��ť��Ʈ�μ� �������ȣ�� ������?�ִ�.
		for li_row = oldrow to row 
			SelectRow(li_row, true) 
		next 
		r_count = (row - oldrow) + 1 
	  st_1.text = string(r_count) + & 
		" ���� ���� ���õǾ����ϴ�." 
		target_row = r_count 
		min_row = oldrow 
		flag = 1
		ctrl_count = 0
		// ���õ� ���� oldrow���� ũ�� oldrow���� ��������� for ������ ���鼭 
		// ���� ���ý�Ų��. r_count�� ���õ� ����� ����Ͽ� �ְ� st_1�� ����Ѵ�.
 else
		for li_row = oldrow to row step -1 
			 SelectRow(li_row, true)
		next 
		r_count = (oldrow - row ) + 1
		st_1.text = string(r_count) + &
		" ���� ���� ���õǾ����ϴ�." 
		target_row = r_count 
		min_row = row
		flag = 1
		ctrl_count = 0 
  end if
	// ���õ� ���� oldrow���� ���� ���� ��������� for ������ �������� -1���ؼ�
	// ������ ������ ������.
elseif KeyDown(keycontrol!) then 
  if IsSelected(row) then 
		 SelectRow(row, false) 
		 ctrl_count = ctrl_count - 1 
	// ctrlŰ�� �������� ��� �������� ���õǾ� �ִ� ���̶�� ������ ��ҽ�Ű�� 
	// ��Ʈ��Ű�� ���õ� ���� ������ �ϳ� ���δ�.
  else 
		 SelectRow(row, true)
		 ctrl_count++ 
  end if
	// ���õǾ� ���� �ʴٸ� �������� �����ϰ� �ళ���� ������Ų��.
  st_1.text = string(ctrl_count) + &
  " ���� ���� ���õǾ����ϴ�." 
	flag = 2
else // �ƹ�Ű�� �������� �ʾ��� ���
	SelectRow(0, false)
	SelectRow(row, true) 
	// ������� ������ �������� �����ุ �����Ѵ�.
	oldrow = row 
	ctrl_count = 1
	st_1.text = "1 ���� ���� ���õǾ����ϴ�." 
	flag = 3
	target_row = row 
end if 

end event

event dw_insert::doubleclicked;if this.IsSelected(row) then
   this.selectrow(row, False)
else	
   this.selectrow(row, True)
end if	

end event

type cb_mod from w_inherite`cb_mod within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_del from w_inherite`cb_del within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_print from w_inherite`cb_print within w_pdm_01410
boolean visible = false
integer y = 3380
end type

type cb_can from w_inherite`cb_can within w_pdm_01410
boolean visible = false
integer y = 3392
end type

type cb_search from w_inherite`cb_search within w_pdm_01410
boolean visible = false
integer y = 3376
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01410
integer x = 46
integer y = 2540
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01410
integer x = 5070
integer y = 3192
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01410
integer x = 5070
integer y = 3192
end type

type r_head from w_inherite`r_head within w_pdm_01410
boolean visible = false
integer y = 2972
end type

type r_detail from w_inherite`r_detail within w_pdm_01410
long fillcolor = 16777215
integer y = 216
integer width = 2583
integer height = 2092
end type

type dw_pdt from datawindow within w_pdm_01410
integer x = 174
integer y = 56
integer width = 951
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01410_02"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if dw_update.Retrieve(data) < 1 then
	dw_update.Reset()
	f_message_chk(50, "[���]")
//	p_mod.Enabled = False
//	p_del.Enabled = False
	
//	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
//	p_del.PictureName = 'C:\erpman\image\����_d.gif'

	is_update = 'N'
	is_delete = 'N'
	
	return
end if	

dw_jo.SelectRow(0, False)
if data = '1' then 
//	p_mod.Enabled = True
//	p_del.Enabled = True
//	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
//	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	is_update = 'Y'
	is_delete = 'Y'
else	
//	p_mod.Enabled = False
//	p_del.Enabled = True
//	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
//	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	is_update = 'N'
	is_delete = 'Y'
end if	

dw_update.SetFocus()
ib_any_typing = False
end event

type gb_1 from groupbox within w_pdm_01410
integer x = 110
integer y = 12
integer width = 1042
integer height = 156
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
end type

type dw_jo from datawindow within w_pdm_01410
integer x = 2857
integer y = 260
integer width = 1595
integer height = 2044
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pdm_01410_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF row <= 0	then RETURN									

//if this.object.pdtgu[row] <> dw_pdt.object.pdtgu[dw_pdt.GetRow()] and &
//   dw_pdt.object.pdtgu[dw_pdt.GetRow()] <> '9' then
//   MessageBox("�μ� Ȯ��","�μ��� �ٸ� ���ڵ� �Դϴ�!")
//	return
//end if	

int i, k

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected (i) then
		if dw_update.object.deptcode[i] <> this.object.dptno[row] then
    		MessageBox("�μ� Ȯ��","�μ��� �ٸ� ���ڵ�� ������ �� �����ϴ�!")
			this.selectrow(0, false)
		   return
		end if	
      k = k + 1
   end if	
next	


this.selectrow(0, false)
if k > 0 then
	this.selectrow(Row, true)
else
   MessageBox("Ȯ��","FROM �ڷḦ ���� �����Ͻʽÿ�!")
end if	
end event

event itemchanged;this.AcceptText()
end event

type dw_ins from datawindow within w_pdm_01410
boolean visible = false
integer x = 46
integer y = 2792
integer width = 1376
integer height = 136
boolean bringtotop = true
string dataobject = "d_pdm_01410_04"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event updatestart;/* Update() function ȣ��� user ���� */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type st_2 from statictext within w_pdm_01410
integer x = 69
integer y = 192
integer width = 178
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 16777215
string text = "FROM"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_01410
integer x = 2898
integer y = 192
integer width = 110
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 16777215
string text = "TO"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pdm_01410
integer x = 2642
integer y = 288
integer width = 183
integer height = 164
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\blue33_back.gif"
alignment htextalign = left!
end type

event clicked;String s_jocod, s_jonam, s_empno, s_sub_jocod, s_sub_jonam
Long i, j, k

for i = 1 to dw_jo.RowCount()
	if dw_jo.IsSelected (i) then
		k = i
		EXIT
	end if	
next	

if IsNull(k) or k = 0 then 
	f_message_chk(36,"[���ڵ�]")
   return
else
	s_jocod = dw_jo.object.jocod[k]
	s_jonam = dw_jo.object.jonam[k]
	s_sub_jocod = dw_jo.object.sub_jocod[k]
	s_sub_jonam = dw_jo.object.sub_jonam[k]
end if

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected (i) then
		dw_update.object.jocod[i] = s_jocod
		dw_update.object.jonam[i] = s_jonam
		dw_update.object.sub_jocod[i] = s_sub_jocod
		dw_update.object.sub_jonam[i] = s_sub_jonam
		dw_update.object.upd[i] = "UPD"
	end if	
next	
dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False)
end event

type dw_update from u_d_select_sort within w_pdm_01410
integer x = 37
integer y = 260
integer width = 2574
integer height = 2044
integer taborder = 20
string dataobject = "d_pdm_01410_01"
boolean border = false
end type

event clicked;call super::clicked;//IF row <= 0	then RETURN									
//this.selectrow(row, True)


// �輺�� 2004.12.17
// ���� ���� ���� ���μ����� ó��...

integer li_row, r_count 


if KeyDown(keyshift!) then // shift key�� ������ ���¶�� 
  if row > oldrow then 
	// row�� �ĺ����� �����ϴ� ���� ��ť��Ʈ�μ� �������ȣ�� ������?�ִ�.
		for li_row = oldrow to row 
			SelectRow(li_row, true) 
		next 
		r_count = (row - oldrow) + 1 
	  st_1.text = string(r_count) + & 
		" ���� ���� ���õǾ����ϴ�." 
		target_row = r_count 
		min_row = oldrow 
		flag = 1
		ctrl_count = 0
		// ���õ� ���� oldrow���� ũ�� oldrow���� ��������� for ������ ���鼭 
		// ���� ���ý�Ų��. r_count�� ���õ� ����� ����Ͽ� �ְ� st_1�� ����Ѵ�.
 else
		for li_row = oldrow to row step -1 
			 SelectRow(li_row, true)
		next 
		r_count = (oldrow - row ) + 1
		st_1.text = string(r_count) + &
		" ���� ���� ���õǾ����ϴ�." 
		target_row = r_count 
		min_row = row
		flag = 1
		ctrl_count = 0 
  end if
	// ���õ� ���� oldrow���� ���� ���� ��������� for ������ �������� -1���ؼ�
	// ������ ������ ������.
elseif KeyDown(keycontrol!) then 
  if IsSelected(row) then 
		 SelectRow(row, false) 
		 ctrl_count = ctrl_count - 1 
	// ctrlŰ�� �������� ��� �������� ���õǾ� �ִ� ���̶�� ������ ��ҽ�Ű�� 
	// ��Ʈ��Ű�� ���õ� ���� ������ �ϳ� ���δ�.
  else 
		 SelectRow(row, true)
		 ctrl_count++ 
  end if
	// ���õǾ� ���� �ʴٸ� �������� �����ϰ� �ళ���� ������Ų��.
  st_1.text = string(ctrl_count) + &
  " ���� ���� ���õǾ����ϴ�." 
	flag = 2
else // �ƹ�Ű�� �������� �ʾ��� ���
	SelectRow(0, false)
	SelectRow(row, true) 
	// ������� ������ �������� �����ุ �����Ѵ�.
	oldrow = row 
	ctrl_count = 1
	st_1.text = "1 ���� ���� ���õǾ����ϴ�." 
	flag = 3
	target_row = row 
end if 

end event

event doubleclicked;call super::doubleclicked;if this.IsSelected(row) then
   this.selectrow(row, False)
else	
   this.selectrow(row, True)
end if	

end event

event getfocus;call super::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event itemchanged;call super::itemchanged;String sCol, ls_deptcode, ls_joname

sCol = this.GetColumnName()
if sCol = "drtim" then
	dw_insert.object.upd[row] = "UPD"
end if	

if sCol = "jocod" then
	ls_deptcode = this.getitemstring( row, 'deptcode')
	
	SELECT JONAM
	INTO	 :ls_joname
	FROM JOMAST
	WHERE JOCOD = :data
	AND	DPTNO = :ls_deptcode 
	USING SQLCA ;
	
	IF isnull(ls_joname) or ls_joname = "" then
		dw_insert.object.jonam[row] = ""
		return 2
	end if
	dw_insert.object.jonam[row] = ls_joname
	
	
	dw_insert.object.upd[row] = "UPD"
end if	


end event

event itemerror;call super::itemerror;RETURN 1
end event

type r_jo from rectangle within w_pdm_01410
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 16777215
integer x = 2853
integer y = 216
integer width = 1605
integer height = 2092
end type

