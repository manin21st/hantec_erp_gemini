$PBExportHeader$w_qct_04000.srw
$PBExportComments$** A/Sȯ������ǵ��
forward
global type w_qct_04000 from w_inherite
end type
type dw_1 from u_key_enter within w_qct_04000
end type
end forward

global type w_qct_04000 from w_inherite
string title = "A/S ȯ�� �� ���� ���"
dw_1 dw_1
end type
global w_qct_04000 w_qct_04000

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ

dw_insert.object.sabu[1] = gs_sabu
dw_insert.object.docno[1] = dw_1.object.docno[1]

if Isnull(dw_insert.object.docno[1]) or dw_insert.object.docno[1] < 1 or &
   dw_insert.object.docno[1] > 999 then
	f_message_chk(1400,'[����]')
	dw_1.SetColumn('docno')
   dw_1.SetFocus()
	return -1
end if	

//if Isnull(Trim(dw_insert.object.docname[1])) or Trim(dw_insert.object.docname[1]) = "" then
//	f_message_chk(1400,'[���и�]')
//	dw_insert.SetColumn('docname')
//   dw_insert.SetFocus()
//	return -1
//end if	
//
//if Isnull(Trim(dw_insert.object.tesdoc[1])) or Trim(dw_insert.object.tesdoc[1]) = "" then
//	f_message_chk(1400,'[A/Sȯ�� �� ����]')
//	dw_insert.SetColumn('tesdoc')
//   dw_insert.SetFocus()
//	return -1
//end if	

return 1
end function

on w_qct_04000.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_04000.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_04000
integer x = 87
integer y = 156
integer width = 4503
integer height = 2132
integer taborder = 20
string dataobject = "d_qct_04000_02"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;ib_any_typing = True //�Է��ʵ� ���濩�� Yes
end event

event dw_insert::getfocus;if (IsNull(dw_1.object.docno[1]) or dw_1.object.docno[1] < 1 or dw_1.object.docno[1] > 999 )  then 
	dw_1.Setfocus()
end if

f_toggle_kor(Handle(this))
w_mdi_frame.sle_msg.Text = ""
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "tesdoc" then return

Send(Handle(this),256,9,0)
Return 1
end event

type p_delrow from w_inherite`p_delrow within w_qct_04000
boolean visible = false
integer x = 4398
integer y = 3424
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_04000
boolean visible = false
integer x = 4224
integer y = 3424
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_04000
boolean visible = false
integer x = 3529
integer y = 3424
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04000
boolean visible = false
integer x = 4050
integer y = 3424
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_04000
integer x = 4421
integer y = 4
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_qct_04000
integer x = 4247
integer y = 4
integer taborder = 50
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()

p_mod.Enabled = False
p_del.Enabled = False

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type p_print from w_inherite`p_print within w_qct_04000
boolean visible = false
integer x = 3703
integer y = 3424
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04000
boolean visible = false
integer x = 3877
integer y = 3424
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_qct_04000
integer x = 4073
integer y = 4
integer taborder = 40
end type

event p_del::clicked;call super::clicked;long 	lcRow

lcRow = dw_insert.GetRow()
if lcRow <= 0 then return
if f_msg_delete() = -1 then return
	
dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)
if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
 	dw_insert.ReSet()
	dw_insert.InsertRow(0) 
	
	dw_1.ReSet()
	dw_1.InsertRow(0) 
	dw_1.SetFocus()
else	
   ROLLBACK;
	f_message_chk(31,'[��������]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if
dw_insert.SetRedraw(True)
ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_mod from w_inherite`p_mod within w_qct_04000
integer x = 3899
integer y = 4
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if f_msg_update() = -1 then return  //���� Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"
	p_del.Enabled = True
	ib_any_typing = False //�Է��ʵ� ���濩�� No
else
	f_message_chk(32,'[�ڷ����� ����]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_qct_04000
boolean visible = false
integer x = 2807
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qct_04000
boolean visible = false
integer x = 1765
integer y = 3292
end type

type cb_ins from w_inherite`cb_ins within w_qct_04000
boolean visible = false
integer x = 562
integer y = 3292
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_04000
boolean visible = false
integer x = 2112
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_04000
boolean visible = false
integer x = 197
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_04000
boolean visible = false
integer x = 1417
integer y = 3288
end type

type st_1 from w_inherite`st_1 within w_qct_04000
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_qct_04000
boolean visible = false
integer x = 2459
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qct_04000
boolean visible = false
integer x = 914
integer y = 3288
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_04000
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_qct_04000
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_qct_04000
boolean visible = false
integer x = 9
integer y = 2960
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_04000
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04000
boolean visible = false
end type

type dw_1 from u_key_enter within w_qct_04000
integer x = 78
integer y = 24
integer width = 1362
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_04000_01"
boolean border = false
end type

event itemchanged;Integer ino

ino = integer(this.gettext())

if (IsNull(ino) or ino < 1 or ino > 999 )  then 
	MessageBox("���� Ȯ��", "������ Ȯ���ϼ���!(1 - 999)")
	this.Setfocus()
	return 1
end if

dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
	p_del.Enabled = False
   dw_insert.InsertRow(0)
else                                          //�ڷ� ���� ��
	p_del.Enabled = True
end if
dw_insert.SetRedraw(True)

dw_insert.SetColumn("docname")
dw_insert.Setfocus()

end event

event itemerror;return 1
end event

