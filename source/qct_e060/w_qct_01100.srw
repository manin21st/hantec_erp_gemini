$PBExportHeader$w_qct_01100.srw
$PBExportComments$** �̻�߻�������
forward
global type w_qct_01100 from w_inherite
end type
type dw_ins from u_key_enter within w_qct_01100
end type
type cb_1 from commandbutton within w_qct_01100
end type
type p_1 from uo_picture within w_qct_01100
end type
type dw_1 from u_key_enter within w_qct_01100
end type
type st_2 from statictext within w_qct_01100
end type
type st_4 from statictext within w_qct_01100
end type
type cb_2 from commandbutton within w_qct_01100
end type
type cb_3 from commandbutton within w_qct_01100
end type
type p_2 from picture within w_qct_01100
end type
type p_3 from picture within w_qct_01100
end type
type dw_2 from datawindow within w_qct_01100
end type
type rr_1 from roundrectangle within w_qct_01100
end type
end forward

global type w_qct_01100 from w_inherite
integer width = 4626
integer height = 2460
string title = "�̻�߻� ������� ���"
dw_ins dw_ins
cb_1 cb_1
p_1 p_1
dw_1 dw_1
st_2 st_2
st_4 st_4
cb_2 cb_2
cb_3 cb_3
p_2 p_2
p_3 p_3
dw_2 dw_2
rr_1 rr_1
end type
global w_qct_01100 w_qct_01100

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
if dw_insert.AcceptText() = -1 then return -1
if dw_ins.AcceptText() = -1 then return -1
if dw_2.AcceptText() = -1 then return -1

if IsNull(dw_insert.object.woningu[1]) or  &
   dw_insert.object.woningu[1] < 0 and dw_insert.object.woningu[1] > 2 then
	f_message_chk(30, "[���α���]")
	return -1
end if	
	
if IsNull(Trim(dw_insert.object.wonin[1])) or Trim(dw_insert.object.wonin[1]) = "" then
	f_message_chk(30, "[����]")
	return -1
end if	


return 1
end function

on w_qct_01100.create
int iCurrent
call super::create
this.dw_ins=create dw_ins
this.cb_1=create cb_1
this.p_1=create p_1
this.dw_1=create dw_1
this.st_2=create st_2
this.st_4=create st_4
this.cb_2=create cb_2
this.cb_3=create cb_3
this.p_2=create p_2
this.p_3=create p_3
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.p_2
this.Control[iCurrent+10]=this.p_3
this.Control[iCurrent+11]=this.dw_2
this.Control[iCurrent+12]=this.rr_1
end on

on w_qct_01100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_ins.ReSet()
dw_ins.InsertRow(0)

dw_2.ReSet()
dw_2.InsertRow(0)

dw_insert.SetFocus()

dw_insert.object.occjpno[1] = gs_code

THIS.X = 0 
THIS.Y = 0 
//f_window_center(this)

p_inq.TriggerEvent(Clicked!) //��ȸ��ư

//dw_2.settransobject(sqlca)
//if dw_insert.retrieve(gs_sabu, gs_code) < 1 then
//	dw_insert.insertrow(0)
//	dw_insert.setitem(1, "sabu", gs_sabu)
//	dw_insert.setitem(1, "iojpno", gs_code)
//end if
end event

type dw_insert from w_inherite`dw_insert within w_qct_01100
integer x = 96
integer y = 196
integer width = 4494
integer height = 872
integer taborder = 20
string dataobject = "d_qct_01100_01"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2, snull
Integer i_rtn

ib_any_typing = True //�Է��ʵ� ���濩�� Yes

s_col = this.GetColumnName()
s_cod = Trim(this.GetText())

s_nam1 = ""
s_nam2 = ""  

setnull(snull)
CHOOSE CASE s_col
	CASE "occjpno" //������ȣ
		if IsNull(s_cod) or s_cod = "" then return
		select occjpno
		  into :s_nam1
		  from occrpt
		 where occjpno = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[������ȣ]")
		   this.object.occjpno[1] = ""
			return 1
		end if	
		p_inq.TriggerEvent(Clicked!) //��ȸ��ư 
	CASE "comdpt" //��ġ�μ�
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.comdpt[1] = s_cod
		this.object.comdptnm[1] = s_nam1
		return i_rtn
	CASE "comdpt2" //��ġ�μ�2
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.comdpt2[1] = s_cod
		this.object.comdptnm2[1] = s_nam1
		return i_rtn
	CASE "comdpt3" //��ġ�μ�3
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.comdpt3[1] = s_cod
		this.object.comdptnm3[1] = s_nam1
		return i_rtn
	CASE "comdpt4" //��ġ�μ�4
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.comdpt4[1] = s_cod
		this.object.comdptnm4[1] = s_nam1
		return i_rtn		
	CASE "jochdat" //��ġ����
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ����]")
		   this.object.jochdat[1] = ""
		   return 1
	   end if
	CASE "jochdat2" //��ġ����2
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ����]")
		   this.object.jochdat2[1] = ""
		   return 1
	   end if
	CASE "jochdat3" //��ġ����3
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ����]")
		   this.object.jochdat3[1] = ""
		   return 1
	   end if
	CASE "jochdat4" //��ġ����4
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ����]")
		   this.object.jochdat4[1] = ""
		   return 1
	   end if		
	CASE "joydat" //��ġ������
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ������]")
		   this.object.joydat[1] = ""
		   return 1
	   end if
	CASE "joydat2" //��ġ������2
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ������]")
		   this.object.joydat2[1] = ""
		   return 1
	   end if
	CASE "joydat3" //��ġ������3
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ������]")
		   this.object.joydat3[1] = ""
		   return 1
	   end if
	CASE "joydat4" //��ġ������4
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��ġ������]")
		   this.object.joydat4[1] = ""
		   return 1
	   end if		
	CASE "balvnd" //�߻���ü
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.balvnd[1] = s_cod
		this.object.balvndnm[1] = s_nam1
		return i_rtn
	CASE "joemp" //��ġ�����1
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.joemp[1] = s_cod
		this.object.joempnm[1] = s_nam1
		return i_rtn
	CASE "joemp2" //��ġ�����2
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.joemp2[1] = s_cod
		this.object.joemp2nm[1] = s_nam1
		return i_rtn
	CASE "joemp3" //��ġ�����3
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.joemp3[1] = s_cod
		this.object.joemp3nm[1] = s_nam1
		return i_rtn
	CASE "joemp4" //��ġ�����4
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.joemp4[1] = s_cod
		this.object.joemp4nm[1] = s_nam1
		return i_rtn		
	CASE "jangidae" //����å����
		if s_cod <> "Y" then
		   this.object.jangemp[1] = ""
		   this.object.jangempnm[1] = ""
			this.object.jangjdat[1] = ""
		end if	
	CASE "jangemp" //����å������
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.jangemp[1] = s_cod
		this.object.jangempnm[1] = s_nam1
		return i_rtn
	CASE "jangjdat" //����å��������
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[����å��������]")
		   this.object.jangjdat[1] = ""
		   return 1
	   end if
	CASE "guempno" //�˻�����
		SELECT RFNA1 INTO :s_nam1 from reffpf where rfcod = '45' and rfgub = :s_cod;
		if sqlca.sqlcode <> 0 then
			this.object.guempno[1] = snull
			this.object.guempname[1] = snull
		   f_message_chk(33,"[�˻�����]")
			return 1
		else
			this.object.guempno[1] = s_cod
			this.object.guempname[1] = s_nam1			
		end if
END CHOOSE

return

end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "occjpno" then //������ȣ
	open(w_occjpno_popup)
   this.object.occjpno[1] = gs_code
	p_inq.TriggerEvent(Clicked!) //��ȸ��ư
elseif this.getcolumnname() = "comdpt" then //��ġ�μ�
	open(w_vndmst_4_popup)
   this.object.comdpt[1] = gs_code
	this.object.comdptnm[1] = gs_codename
elseif this.getcolumnname() = "comdpt2" then //��ġ�μ�2
	open(w_vndmst_4_popup)
   this.object.comdpt2[1] = gs_code
	this.object.comdptnm2[1] = gs_codename
elseif this.getcolumnname() = "comdpt3" then //��ġ�μ�3
	open(w_vndmst_4_popup)
   this.object.comdpt3[1] = gs_code
	this.object.comdptnm3[1] = gs_codename
elseif this.getcolumnname() = "comdpt4" then //��ġ�μ�4
	open(w_vndmst_4_popup)
   this.object.comdpt4[1] = gs_code
	this.object.comdptnm4[1] = gs_codename	
elseif this.getcolumnname() = "balvnd" then //�߻���ü
	open(w_vndmst_popup)
   this.object.balvnd[1] = gs_code
	this.object.balvndnm[1] = gs_codename
elseif this.getcolumnname() = "joemp" then //��ġ���1
	open(w_sawon_popup)
   this.object.joemp[1] = gs_code
	this.object.joempnm[1] = gs_codename
elseif this.getcolumnname() = "joemp2" then //��ġ���2
	open(w_sawon_popup)
   this.object.joemp2[1] = gs_code
	this.object.joemp2nm[1] = gs_codename
elseif this.getcolumnname() = "joemp3" then //��ġ���3
	open(w_sawon_popup)
   this.object.joemp3[1] = gs_code
	this.object.joemp3nm[1] = gs_codename
elseif this.getcolumnname() = "joemp4" then //��ġ���4
	open(w_sawon_popup)
   this.object.joemp4[1] = gs_code
	this.object.joemp4nm[1] = gs_codename	
elseif this.getcolumnname() = "jangemp" then 
	open(w_sawon_popup)
   this.object.jangemp[1] = gs_code
	this.object.jangempnm[1] = gs_codename	
end if

return
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;if this.GetColumnName() = "jangdae" or this.GetColumnName() = "occrpt_emrrmks" then
	f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	
end event

event dw_insert::ue_pressenter;//Disable Accestor Script 
end event

type p_delrow from w_inherite`p_delrow within w_qct_01100
boolean visible = false
integer x = 4201
integer y = 3272
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_01100
boolean visible = false
integer x = 4027
integer y = 3272
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_01100
boolean visible = false
integer x = 3333
integer y = 3272
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_01100
boolean visible = false
integer x = 3854
integer y = 3272
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_01100
integer x = 4398
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_qct_01100
integer x = 4224
integer taborder = 80
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_ins.ReSet()
dw_ins.InsertRow(0)

dw_2.ReSet()
dw_2.InsertRow(0)

dw_insert.SetFocus()

end event

type p_print from w_inherite`p_print within w_qct_01100
boolean visible = false
integer x = 3506
integer y = 3272
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_01100
integer x = 3698
end type

event p_inq::clicked;call super::clicked;String ino, ls_finish_yn
Long   i

if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return -1
end if

ino = dw_insert.object.occjpno[1]

if (IsNull(ino) or ino = "")  then 
	f_message_chk(30, "[������ȣ]")
	return 1
end if

dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
   f_message_chk(50, "[������ȣ]")
	p_mod.Enabled = False
	p_mod.PictureName = 'c:\erpman\image\����_d.gif'
		
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\����_d.gif'

	dw_ins.SetRedraw(False)
	dw_ins.Reset()
	dw_ins.InsertRow(0)
	dw_ins.SetRedraw(True)

	dw_insert.SetRedraw(False)
	dw_insert.Reset()
	dw_insert.InsertRow(0)
   dw_insert.SetColumn("occdat")
   dw_insert.Setfocus()
	dw_insert.SetRedraw(True)
	
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetRedraw(True)
	
	return
end if

if dw_ins.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
	dw_ins.SetRedraw(False)
	dw_ins.Reset()
	dw_ins.InsertRow(0)
	dw_ins.SetRedraw(True)
end if

//����Ʈ ��ȸ
if dw_2.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
	dw_2.SetRedraw(False)
	dw_2.Reset()
	dw_2.InsertRow(0)
	dw_2.SetRedraw(True)
end if


// ����å ������ ���� ��쿡�� Default�� 'N'�� �Է��Ѵ�.
if isnull(dw_insert.getitemstring(1, "jangidae")) or &
   trim(dw_insert.getitemstring(1, "jangidae")) = '' then
	dw_insert.setitem(1, "jangidae", 'N')
end if

p_mod.Enabled = True
p_mod.PictureName = 'c:\erpman\image\����_up.gif'
	
p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\����_up.gif'
	
dw_insert.SetColumn("woningu")
dw_insert.Setfocus()
dw_insert.SetRedraw(True)

ls_finish_yn = dw_insert.object.finish_yn[1] 

if trim(ls_finish_yn) = '' or isnull(ls_finish_yn) then 
	dw_insert.object.finish_yn[1] = 'N' 
End if 


return
end event

type p_del from w_inherite`p_del within w_qct_01100
integer x = 4050
integer taborder = 70
end type

event p_del::clicked;call super::clicked;long i, lcRow

if f_msg_delete() = -1 then return

lcRow = dw_insert.GetRow()
dw_insert.SetRedraw(False)
//��������� CLEAR
dw_insert.object.woningu[1] = 0
dw_insert.object.siloi[1] = ""
dw_insert.object.wonin[1] = ""
dw_insert.object.jajaesa[1] = ""
dw_insert.object.comdpt[1] = ""
dw_insert.object.comdptnm[1] = ""
dw_insert.object.jochdat[1] = ""
dw_insert.object.balvnd[1] = ""
dw_insert.object.balvndnm[1] = ""
dw_insert.object.joemp[1] = ""
dw_insert.object.joempnm[1] = ""
dw_insert.object.jangdae[1] = ""
dw_insert.AcceptText()
if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[��������]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if
	
lcRow = dw_ins.GetRow()
dw_ins.SetRedraw(False)
dw_ins.DeleteRow(lcRow)
if dw_ins.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : Document]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if

lcRow = dw_ins.GetRow()
dw_2.SetRedraw(False)
dw_2.DeleteRow(lcRow)
if dw_2.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[��������]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if

COMMIT;

dw_insert.ReSet()
dw_insert.InsertRow(0) 
dw_insert.SetRedraw(True)
	
dw_ins.ReSet()
dw_ins.InsertRow(0) 
dw_ins.SetRedraw(True)

dw_2.ReSet()
dw_2.InsertRow(0) 
dw_2.SetRedraw(True)

dw_insert.SetFocus()

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_mod from w_inherite`p_mod within w_qct_01100
integer x = 3877
end type

event p_mod::clicked;call super::clicked;Long ll_i, ll_count 
String ls_deptcode

if f_msg_update() = -1 then return  //���� Yes/No ?
if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if dw_insert.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ����]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

dw_ins.object.sabu[1] = gs_sabu
dw_ins.object.occjpno[1] = dw_insert.object.occjpno[1]
dw_ins.AcceptText()
if dw_ins.Update() <> 1 then
  	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ���� : Document]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

dw_2.object.sabu[1] = gs_sabu
dw_2.object.occjpno[1] = dw_insert.object.occjpno[1]
dw_2.AcceptText()
if dw_2.Update() <> 1 then
  	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ���� : Document]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

COMMIT;

w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"
	
p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\����_up.gif'


ib_any_typing = False //�Է��ʵ� ���濩�� No
 
end event

type cb_exit from w_inherite`cb_exit within w_qct_01100
integer x = 2848
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qct_01100
integer x = 1801
integer y = 3288
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_01100
integer x = 1006
integer y = 2944
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_01100
integer x = 2149
integer y = 3288
boolean enabled = false
string text = " ����(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_qct_01100
integer x = 1449
integer y = 3284
end type

type cb_print from w_inherite`cb_print within w_qct_01100
integer x = 1938
integer y = 2948
end type

type st_1 from w_inherite`st_1 within w_qct_01100
end type

type cb_can from w_inherite`cb_can within w_qct_01100
integer x = 2496
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qct_01100
integer x = 1435
integer y = 2948
end type





type gb_10 from w_inherite`gb_10 within w_qct_01100
integer x = 9
integer y = 2952
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_01100
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01100
end type

type dw_ins from u_key_enter within w_qct_01100
integer x = 480
integer y = 1792
integer width = 4023
integer height = 388
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_qct_01100_02"
boolean border = false
boolean livescroll = false
end type

event itemchanged;this.AcceptText()
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //�Է��ʵ� ���濩�� Yes

end event

event itemerror;return 1
end event

event getfocus;call super::getfocus;f_toggle_kor(Handle(this))
end event

event losefocus;call super::losefocus;f_toggle_eng(Handle(this))
end event

event ue_pressenter;if this.GetColumnName() = "occaft" then return 

Send(Handle(this),256,9,0)
Return 1

end event

type cb_1 from commandbutton within w_qct_01100
boolean visible = false
integer x = 859
integer y = 3284
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "BOM��볻�� ��ȸ"
end type

type p_1 from uo_picture within w_qct_01100
boolean visible = false
integer x = 3392
integer y = 24
integer width = 306
integer taborder = 90
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\BOM��볻��_up.gif"
end type

event clicked;call super::clicked;integer ireturn
String sItnbr, sItdsc

ireturn = MessageBox("BOM��볻��", "������ �����Ͻʽÿ�(��:����ǰ, �ƴϿ�:��ǰ)?", &
											question!, yesnocancel!)
											
if ireturn = 3 then return
if ireturn = 1 then
	sItnbr = dw_insert.getitemstring(1, "banpum")
	sItdsc = dw_insert.getitemstring(1, "banpumnm")
	if isnull(sitdsc) or trim(sitdsc) = '' then
		Messagebox("ǰ��", "����ǰ ǰ���� �Էµ��� �ʾ����ϴ�", stopsign!)
		return
	end if
else
	sItnbr = dw_insert.getitemstring(1, "bupum")
	sItdsc = dw_insert.getitemstring(1, "bupumnm")	
	if isnull(sitdsc) or trim(sitdsc) = '' then
		Messagebox("ǰ��", "��ǰ ǰ���� �Էµ��� �ʾ����ϴ�", stopsign!)
		return
	end if	
end if

openwithparm(w_qct_01100_01, sitnbr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'c:\erpman\image\BOM��볻��_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'c:\erpman\image\BOM��볻��_up.gif'
end event

type dw_1 from u_key_enter within w_qct_01100
boolean visible = false
integer x = 1957
integer y = 24
integer width = 293
integer height = 124
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_qct_01100_04"
boolean border = false
boolean livescroll = false
end type

event rbuttondown;call super::rbuttondown;String ls_emp_id 

if row < 1 then return 
ls_emp_id = dw_1.object.emp_id[row] 

if trim(ls_emp_id) <> '' and isnull(ls_emp_id) = false then return 

IF GetColumnName() = 'deptname' or GetColumnName() = 'deptcode' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'deptcode', gs_code)
	SetItem(row, 'deptname', gs_codename)

End if 
end event

event itemchanged;call super::itemchanged;String ls_deptcode, ls_deptname

if this.getcolumnname() = 'deptcode' then 
	//Project Code
	ls_deptcode = gettext() 
	
	select deptname 
	  into :ls_deptname 
	  from p0_dept
	 where deptcode = :ls_deptcode; 
	if sqlca.sqlcode <> 0  then 
		messagebox('Ȯ��', '�߸��� �μ������� �Է��ϼ˽��ϴ�') 
		dw_1.setrow(row)
		dw_1.setcolumn('deptname')
		return
	end if 
	
	dw_1.object.deptcode[row] = 	ls_deptcode
	dw_1.object.deptname[row] = 	ls_deptname
elseif this.getcolumnname() = 'deptname' then 
	//Project Code
	ls_deptname = gettext() 
	
	select deptcode
	  into :ls_deptcode
	  from p0_dept
	 where deptname = :ls_deptname; 
	if sqlca.sqlcode <> 0  then 
		messagebox('Ȯ��', '�߸��� �μ������� �Է��ϼ˽��ϴ�') 
		dw_1.setrow(row)
		dw_1.setcolumn('deptname')
		return
	end if 
	
	dw_1.object.deptcode[row] = 	ls_deptcode
	dw_1.object.deptname[row] = 	ls_deptname
End if 	
end event

type st_2 from statictext within w_qct_01100
integer x = 183
integer y = 1780
integer width = 338
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[Document]"
boolean focusrectangle = false
end type

type st_4 from statictext within w_qct_01100
boolean visible = false
integer x = 1609
integer y = 36
integer width = 338
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[��ġ����]"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_qct_01100
boolean visible = false
integer x = 1289
integer y = 28
integer width = 302
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�߰�"
end type

event clicked;String ls_order_no 
Long   ll_i 

if dw_insert.rowcount() < 1 then return 
ls_order_no = dw_insert.object.occjpno[1] 

if trim(ls_order_no) = '' or isnull(ls_order_no) then return 

ll_i = dw_1.insertrow(0) 

dw_1.object.order_no[ll_i] = ls_order_no  
dw_1.object.seq[ll_i] = ll_i
end event

type cb_3 from commandbutton within w_qct_01100
boolean visible = false
integer x = 1294
integer y = 112
integer width = 302
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����"
end type

event clicked;Long ll_i, ll_i2 
String ls_finish_chk, ls_emp_id, ls_deptcode, ls_deptname

ll_i = dw_1.getrow() 
if ll_i < 1 then return 

ls_emp_id = dw_1.object.emp_id[ll_i] 

if trim(ls_emp_id) <> '' and isnull(ls_emp_id) = false then 
	ls_deptcode = dw_1.object.deptcode[ll_i] 
	ls_deptname = dw_1.object.deptname[ll_i]
	Messagebox('Ȯ��', ls_deptname + '[ '  + ls_deptcode + ' ]���� ��ġ������ ��� �߽��ϴ�. ~n ������ ���Ͻø� ���� ��ϵ� ��ġ������ �����ؾ� �մϴ�' ) 
	return 	
End if 


dw_1.deleterow(ll_i) 

if dw_1.rowcount() > 0 then 
	For ll_i2 = 1 to dw_1.rowcount() 
		 dw_1.object.seq[ll_i2] = ll_i2
	Next 
End if 

end event

type p_2 from picture within w_qct_01100
event ue_lbottondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3058
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�Ϸ�_up.gif"
boolean focusrectangle = false
end type

event ue_lbottondown;this.PictureName = 'c:\erpman\image\�Ϸ�_dn.gif' 

end event

event ue_lbuttonup;p_2.PictureName = 'c:\erpman\image\�Ϸ�_up.gif'
end event

event clicked;wstr_parm ls_str_parm 
String   ls_order_no 


if dw_insert.rowcount() < 1 then return 
ls_order_no = dw_insert.OBJECT.occjpno[1] 
if trim(ls_order_no) = '' or isnull(ls_order_no) then 
	Messagebox('Ȯ��', '���� ��ȣ�� ���� �����Ͽ� �ֽʽÿ�') 
	Return 
End if 

dw_insert.object.finish_yn[1] = 'Y' 
dw_insert.object.findate[1] = f_today() 
dw_insert.update() 
commit; 	

ls_str_parm.s_parm[1] = dw_insert.OBJECT.occjpno[1]
ls_str_parm.s_parm[2] = dw_insert.OBJECT.vndmst_cvnas2[1] 
ls_str_parm.s_parm[3] = '�̻�߻�' 
ls_str_parm.s_parm[4] = '�̻�߻� ������ȣ [' +  dw_insert.OBJECT.occjpno[1] + ']' 
	
//openwithparm(w_voda_mailsend_popup, ls_str_parm)

end event

type p_3 from picture within w_qct_01100
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2885
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�Ϸ����_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'c:\erpman\image\�Ϸ�ó��_dn.gif' 

end event

event ue_lbuttonup;p_3.PictureName = 'c:\erpman\image\�Ϸ����_up.gif'
end event

event clicked;Long ll_return 

ll_return = Messagebox('Ȯ��', '�Ϸ�����Ͻðڽ��ϱ�?',Exclamation!, OKCancel!, 2 ) 
if ll_return = 2 then return 

dw_insert.object.finish_yn[1] = 'N' 
dw_insert.object.findate[1] = '' 
dw_insert.update() 
commit; 	
end event

type dw_2 from datawindow within w_qct_01100
integer x = 96
integer y = 1072
integer width = 4494
integer height = 676
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_qct_01100_05"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;String s_cod
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "f_emp" then //�߻��� �ٹ���
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.f_emp[1]   = gs_code
   this.object.f_empnm[1] = gs_codename
elseif this.getcolumnname() = "t_emp" then //�߻��� �ٹ���
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.t_emp[1]   = gs_code
   this.object.t_empnm[1] = gs_codename	
elseif this.getcolumnname() = "f_itnbr" then //�߻��� ǰ��
	open(w_pstruc_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.f_itnbr[1] = gs_code
   this.object.f_itdsc[1] = gs_codename
   this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "t_itnbr" then //�߻��� ǰ��
	open(w_pstruc_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.t_itnbr[1] = gs_code
   this.object.t_itdsc[1] = gs_codename
   this.TriggerEvent(itemchanged!)	
end if



end event

event itemchanged;String  s_col, s_cod, s_nam1, s_nam2, s_nam3, get_bucod, get_name, snull 
Integer i_rtn

ib_any_typing = True //�Է��ʵ� ���濩�� Yes

s_col = this.GetColumnName()
s_cod = Trim(this.GetText())   
CHOOSE CASE s_col
	CASE "f_emp" //�߻��� �ٹ���
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.f_emp[1]   = s_cod
		this.object.f_empnm[1] = s_nam1
		return i_rtn
	CASE "t_emp" //�߻��� �ٹ���
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.t_emp[1]   = s_cod
		this.object.t_empnm[1] = s_nam1
		return i_rtn	
	CASE "f_itnbr" //�߻��� ǰ��
		i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
		this.object.f_itnbr[1] = s_cod
		this.object.f_itdsc[1] = s_nam1
		return i_rtn	
	CASE "t_itnbr" //�߻��� ǰ��
		i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
		this.object.t_itnbr[1] = s_cod
		this.object.t_itdsc[1] = s_nam1
		return i_rtn		
END CHOOSE

return

end event

event itemfocuschanged;if this.GetColumnName() = "f_qcresult" or this.GetColumnName() = "t_qcresult" then
	f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	
end event

type rr_1 from roundrectangle within w_qct_01100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 1760
integer width = 4457
integer height = 444
integer cornerheight = 40
integer cornerwidth = 55
end type

