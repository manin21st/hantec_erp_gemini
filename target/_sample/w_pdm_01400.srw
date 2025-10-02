$PBExportHeader$w_pdm_01400.srw
$PBExportComments$** �� �ڵ� ���
forward
global type w_pdm_01400 from w_inherite
end type
end forward

global type w_pdm_01400 from w_inherite
string title = "�� �ڵ� ���"
end type
global w_pdm_01400 w_pdm_01400

forward prototypes
public function integer wf_required_chk ()
public function boolean wf_duplication_chk (integer crow)
public function integer wf_delete_chk (string sjocod)
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
	
	if Isnull(dw_insert.object.pdtgu[i]) or dw_insert.object.pdtgu[i] =  "" then
	   f_message_chk(1400,'[������]')
	   dw_insert.SetColumn('pdtgu')
	   dw_insert.SetFocus()
	   return -1
   end if
	if Isnull(dw_insert.object.dptno[i]) or dw_insert.object.dptno[i] =  "" then
	   f_message_chk(1400,'[�μ�]')
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

public function boolean wf_duplication_chk (integer crow);String s1
long   ll_frow

dw_insert.AcceptText()

s1 = dw_insert.object.jocod[crow]

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " ��°ROW]")
	return False
end if

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", crow + 1, dw_insert.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " ��°ROW]")
	return False
end if

return true
end function

public function integer wf_delete_chk (string sjocod);long  l_cnt

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM JODETL
 WHERE JOCOD = :sjocod;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[�����ο�]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM WRKCTR  
 WHERE JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[�۾��帶��Ÿ]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM MOROUT
 WHERE SABU = :gs_sabu AND JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[�۾�����]')
	return -1
end if

return 1
end function

on w_pdm_01400.create
call super::create
end on

on w_pdm_01400.destroy
call super::destroy
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)
dw_insert.SetFocus()
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", false) //// ��ȸ
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", true) //// �߰�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", false) //// ã��
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", true) //// �����ٿ�
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = false //// ��ȸ
m_main2.m_window.m_add.enabled = true //// �߰�
m_main2.m_window.m_del.enabled = true  //// ����
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

type cb_exit from w_inherite`cb_exit within w_pdm_01400
integer y = 3400
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01400
integer y = 3216
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01400
integer y = 3216
end type

type st_1 from w_inherite`st_1 within w_pdm_01400
integer y = 3188
end type

type p_search from w_inherite`p_search within w_pdm_01400
integer y = 3220
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01400
integer y = 3220
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01400
integer y = 3220
end type

type p_mod from w_inherite`p_mod within w_pdm_01400
integer y = 3220
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if f_msg_update() = -1 then return  //���� Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"	
	ib_any_typing = False //�Է��ʵ� ���濩�� No
else
	f_message_chk(32,'[�ڷ����� ����]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if
 
end event

type p_del from w_inherite`p_del within w_pdm_01400
integer y = 3220
end type

event p_del::clicked;call super::clicked;long 	lcRow
String s_jocod

IF dw_insert.accepttext() = -1 then return 

lcRow = dw_insert.GetRow()
if lcRow <= 0 then return

s_jocod = dw_insert.object.jocod[lcRow]

if wf_delete_chk(s_jocod) = -1 then return 

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)
IF dw_insert.Update() = 1 THEN
	COMMIT;
	w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
ELSE
	ROLLBACK;
	f_message_chk(31,'[��������]') 
	dw_insert.SetRedraw(True)
	Return
END IF

dw_insert.SetRedraw(True)
ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_inq from w_inherite`p_inq within w_pdm_01400
integer y = 3220
end type

type p_print from w_inherite`p_print within w_pdm_01400
integer y = 3220
end type

type p_can from w_inherite`p_can within w_pdm_01400
integer y = 3220
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)

dw_insert.SetFocus()
w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type p_exit from w_inherite`p_exit within w_pdm_01400
integer y = 3220
end type

type p_ins from w_inherite`p_ins within w_pdm_01400
integer y = 3220
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("jocod") 
dw_insert.SetFocus()

end event

type p_new from w_inherite`p_new within w_pdm_01400
integer y = 3220
end type

type dw_input from w_inherite`dw_input within w_pdm_01400
boolean visible = false
integer y = 3252
end type

type cb_delrow from w_inherite`cb_delrow within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_addrow from w_inherite`cb_addrow within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type dw_insert from w_inherite`dw_insert within w_pdm_01400
integer x = 37
integer y = 56
integer width = 3488
integer height = 1964
integer taborder = 20
string dataobject = "d_pdm_01400_01"
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sCol, s_dptno, s_name, s_name2
int    ireturn

sCol = this.GetColumnName()
if sCol = "jocod" then
	if wf_duplication_chk(row) = False then
		this.object.jocod[row] = ""
		this.object.jonam[row] = ""
		this.SetColumn("jocod")
		return 1
	end if	
//elseif sCol = "pdtgu" then
//	String  s_pdtgu, s_bucod, s_bunam
//		
//	s_pdtgu = this.object.pdtgu[row]
//	
//	SELECT R.RFNA2, V.CVNAS
//	INTO   :s_bucod, :s_bunam
//   FROM   REFFPF R, VNDMST V
//   WHERE  R.RFCOD = '03'
//   AND    R.RFGUB = :s_pdtgu
//   AND    R.RFNA2 = V.CVCOD (+); 
//
//   if sqlca.sqlcode <> -1 then
//		this.object.dptno[row] = s_bucod
//		this.object.cvnas[row] = s_bunam
//	else	
//		this.object.dptno[row] = " "
//		this.object.cvnas[row] = " "
//	end if	
//	this.AcceptText()
elseif sCol = "dptno" then
	s_dptno = this.gettext()
 
   ireturn = f_get_name2('�μ�', 'Y', s_dptno, s_name, s_name2)
	this.SetItem(Row, "dptno", s_dptno)
	this.SetItem(Row, "cvnas", s_name)
  	return ireturn 
end if	

end event

event dw_insert::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event dw_insert::itemfocuschanged;String ColName

ColName = this.GetColumnName()
if (ColName = "jocod") Then
	f_toggle_eng(this)
elseif (ColName = "jonam") Then
	f_toggle_kor(this)
end if	
end event

event dw_insert::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "dptno" THEN
	
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "dptno", gs_Code)
	this.SetItem(this.getrow(), "cvnas", gs_Codename)
END IF
end event

event dw_insert::updatestart;/* Update() function ȣ��� user ���� */
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

type cb_mod from w_inherite`cb_mod within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_del from w_inherite`cb_del within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_print from w_inherite`cb_print within w_pdm_01400
boolean visible = false
integer y = 3224
end type

type cb_can from w_inherite`cb_can within w_pdm_01400
boolean visible = false
integer y = 3236
end type

type cb_search from w_inherite`cb_search within w_pdm_01400
boolean visible = false
integer y = 3220
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01400
integer x = 0
integer y = 2984
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01400
integer y = 3216
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01400
integer y = 3216
end type

type r_head from w_inherite`r_head within w_pdm_01400
boolean visible = false
integer y = 3240
end type

type r_detail from w_inherite`r_detail within w_pdm_01400
integer y = 52
end type

