$PBExportHeader$w_qct_04010.srw
$PBExportComments$** A/S�Ƿڵ��
forward
global type w_qct_04010 from w_inherite
end type
type dw_1 from u_key_enter within w_qct_04010
end type
type dw_ins1 from u_key_enter within w_qct_04010
end type
type dw_ins2 from u_key_enter within w_qct_04010
end type
type rb_new from radiobutton within w_qct_04010
end type
type rb_mod from radiobutton within w_qct_04010
end type
type cb_1 from commandbutton within w_qct_04010
end type
type cb_2 from commandbutton within w_qct_04010
end type
type st_2 from statictext within w_qct_04010
end type
type rr_1 from roundrectangle within w_qct_04010
end type
type rr_2 from roundrectangle within w_qct_04010
end type
end forward

global type w_qct_04010 from w_inherite
string title = "���� �Ƿ� ���"
dw_1 dw_1
dw_ins1 dw_ins1
dw_ins2 dw_ins2
rb_new rb_new
rb_mod rb_mod
cb_1 cb_1
cb_2 cb_2
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_04010 w_qct_04010

type variables
string   is_status 
end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_initial ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
String sdate, jpno, sitnbr, silotno, siodate
Long i

if dw_insert.AcceptText() = -1 then return -1
if dw_ins1.AcceptText() = -1 then return -1
if dw_ins2.AcceptText() = -1 then return -1

if IsNull(Trim(dw_insert.object.rcvdat[1])) or Trim(dw_insert.object.rcvdat[1]) = "" then
	f_message_chk(30, "[��������]")
	dw_insert.setcolumn('rcvdat')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.snddat[1])) or Trim(dw_insert.object.snddat[1]) = "" then
	f_message_chk(30, "[�Ƿ�����]")
	dw_insert.setcolumn('snddat')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.agecod[1])) or Trim(dw_insert.object.agecod[1]) = "" then
	f_message_chk(30, "[�븮��]")
	dw_insert.setcolumn('agecod')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.rcvdpt[1])) or Trim(dw_insert.object.rcvdpt[1]) = "" then
	f_message_chk(30, "[�Ƿںμ�]")
	dw_insert.setcolumn('rcvdpt')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.rcvemp[1])) or Trim(dw_insert.object.rcvemp[1]) = "" then
	f_message_chk(30, "[�Ƿڴ����]")
	dw_insert.setcolumn('rcvemp')
	dw_insert.setfocus()
	return -1
end if	
//if IsNull(Trim(dw_insert.object.rcvlog[1])) or Trim(dw_insert.object.rcvlog[1]) = "" then
//	f_message_chk(30, "[A/S��Ÿ]")
//	dw_insert.setcolumn('rcvlog')
//	dw_insert.setfocus()
//	return -1
//end if	
if IsNull(Trim(dw_insert.object.rcvgu[1])) or Trim(dw_insert.object.rcvgu[1]) = "" then
	f_message_chk(30, "[��������]")
	dw_insert.setcolumn('rcvgu')
	dw_insert.setfocus()
	return -1
end if	

dw_insert.AcceptText()
dw_ins1.AcceptText()
dw_ins2.AcceptText()

return 1
end function

public function integer wf_initial ();
if is_status = '1' then
		dw_1.Visible = False
		
		rb_mod.Checked = False
		rb_new.Checked = True
		
		p_mod.Enabled = True
		p_mod.PictureName  = 'c:\erpman\image\����_up.gif'
			
		p_del.Enabled = False
		p_del.PictureName = 'c:\erpman\image\����_d.gif'
			
		dw_ins1.SetRedraw(False)
		dw_ins1.Reset()
		dw_ins1.InsertRow(0)
		dw_ins1.SetRedraw(True)
		
		dw_ins2.SetRedraw(False)
		dw_ins2.Reset()
		dw_ins2.InsertRow(0)
		dw_ins2.SetRedraw(True)
		
		dw_insert.SetRedraw(False)
		dw_insert.Reset()
		dw_insert.InsertRow(0)
		dw_insert.SetColumn("cl_jpno")
		dw_insert.Setfocus()
		dw_insert.SetRedraw(True)

else 
		
		rb_new.Checked = False
		//cb_mod.Enabled = False
		p_del.Enabled = False
		p_del.PictureName = 'c:\erpman\image\����_d.gif'
		
		dw_ins1.SetRedraw(False)
		dw_ins1.Reset()
		dw_ins1.InsertRow(0)
		dw_ins1.SetRedraw(True)
		
		dw_ins2.SetRedraw(False)
		dw_ins2.Reset()
		dw_ins2.InsertRow(0)
		dw_ins2.SetRedraw(True)
		
		dw_insert.SetRedraw(False)
		dw_insert.Reset()
		dw_insert.InsertRow(0)
		dw_insert.SetRedraw(True)
		
		dw_1.SetRedraw(False)
		dw_1.Reset()
		dw_1.InsertRow(0)
		dw_1.Visible = True
		dw_1.Setfocus()
		dw_1.SetRedraw(True)
	
end if

return 1
end function

on w_qct_04010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_ins1=create dw_ins1
this.dw_ins2=create dw_ins2
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_ins1
this.Control[iCurrent+3]=this.dw_ins2
this.Control[iCurrent+4]=this.rb_new
this.Control[iCurrent+5]=this.rb_mod
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_qct_04010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_ins1)
destroy(this.dw_ins2)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins1.SetTransObject(SQLCA)
dw_ins2.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)


rb_new.Checked = True
is_status = '1' 
wf_initial()

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_ins2.object.ispec_t.text = is_ispec
	dw_ins2.object.jijil_t.text = is_jijil
END IF

rb_new.TriggerEvent(Clicked!) 
end event

type dw_insert from w_inherite`dw_insert within w_qct_04010
integer x = 96
integer y = 188
integer width = 4471
integer height = 996
integer taborder = 30
string dataobject = "d_qct_04010_02"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2, s_nam3, s_nam4
Integer i_rtn

s_col = this.GetColumnName()
s_nam1 = ""
s_nam2 = ""  
s_nam3 = ""
s_nam4 = "" 
s_cod = Trim(this.GetText())
CHOOSE CASE s_col
	CASE "cl_jpno" //ũ���ӹ�ȣ
		if IsNull(s_cod) or s_cod = "" then return
		select cl_jpno
		  into :s_nam1
		  from clamst
		 where cl_jpno = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[ũ���ӹ�ȣ]")
		   this.object.cl_jpno[1] = ""
			return 1
		end if	
	CASE "cust_no" //����ȣ
		if IsNull(s_cod) or s_cod = "" then 
			this.object.cust_no[1] = ""
			this.object.cust_name[1] = ""
			this.object.cust_buseo[1] = ""
			this.object.cust_dam[1] = ""
			this.object.cust_jikwi[1] = ""
			this.object.cust_telno[1] = ""
			this.object.cust_faxno[1] = ""
			return
		end if
		select cvnas, cvpln, telddd||'-'||telno1||'-'telno2,
		       faxddd||'-'||faxno1||'-'faxno2
		  into :s_nam1, :s_nam2, :s_nam3, :s_nam4
		  from vndmst
		 where cvcod = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[����ȣ]")
		   this.object.cust_no[1] = ""
			this.object.cust_name[1] = ""
			this.object.cust_buseo[1] = ""
			this.object.cust_dam[1] = ""
			this.object.cust_jikwi[1] = ""
			this.object.cust_telno[1] = ""
			this.object.cust_faxno[1] = ""
			return 1
		else
			this.object.cust_name[1] = s_nam1
			this.object.cust_buseo[1] = ""
			this.object.cust_dam[1] = s_nam2
			this.object.cust_jikwi[1] = ""
			this.object.cust_telno[1] = s_nam3
			this.object.cust_faxno[1] = s_nam4
		end if
		
		// �����ý� �븮���� ���� �����Ѵ�
		SetItem(1, 'agecod', s_cod)
	CASE "agecod" //�븮��
		i_rtn = f_get_name2("�븮��", "Y", s_cod, s_nam1, s_nam2)
		this.object.agecod[1] = s_cod
		this.object.agenam[1] = s_nam1
		return i_rtn
	CASE "rcvdat" //��������
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[��������]")
			this.object.rcvdat[1] = ""
		   return 1
	   end if
	CASE "snddat" //�Ƿ�����
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[�Ƿ�����]")
		   this.object.snddat[1] = ""
			return 1
	   end if
	CASE "rcvdpt" //�Ƿںμ�
		i_rtn = f_get_name2("�μ�", "Y", s_cod, s_nam1, s_nam2)
		this.object.rcvdpt[1] = s_cod
		this.object.dptnam[1] = s_nam1
		return i_rtn
	CASE "rcvemp" //�Ƿ���
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.object.rcvemp[1] = s_cod
		this.object.rcvempnam[1] = s_nam1
		return i_rtn
	CASE "balgu" //�߼�ó
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.balgu[1] = s_cod
		this.object.balnam[1] = s_nam1
		return i_rtn
END CHOOSE


end event

event dw_insert::rbuttondown;String Sapply_rdate, Sapply_cdate, Sisir_rdate

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "cl_jpno" then //ũ���ӹ�ȣ
	open(w_claimno_popup)
   this.object.cl_jpno[1] = gs_code
elseif this.getcolumnname() = "cust_no" then //����ȣ
	open(w_vndmst_popup)
   this.object.cust_no[1] = gs_code
   this.object.cust_name[1] = gs_codename
	this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "agecod" then //�븮�� 
   gi_page = -1	
	open(w_agent_popup)
	this.object.agecod[1] = gs_code
	this.object.agenam[1] = gs_codename
   gi_page = 0
elseif this.getcolumnname() = "rcvdpt" then //�Ƿںμ�
	open(w_vndmst_4_popup)
	this.object.rcvdpt[1] = gs_code
	this.object.dptnam[1] = gs_codename
elseif this.getcolumnname() = "rcvemp" then //�Ƿ���
	open(w_sawon_popup)
	this.object.rcvemp[1] = gs_code
	this.object.rcvempnam[1] = gs_codename
elseif this.getcolumnname() = "balgu" then //�߼�ó
	open(w_vndmst_popup)
	this.object.balgu[1] = gs_code
	this.object.balnam[1] = gs_codename
elseif this.getcolumnname() = "eco_no" then //ECO_NO
	open(w_ecomst_popup)
	this.object.balgu[1]  = gs_code        /* ECO_NO */
	this.object.balnam[1] = gs_codename    /* ��ǰ ��ȣ */ 
	
	/* ISIR������, ������, ���뿹���� ���� */
	Select NVL(apply_rdate, ''), NVL(apply_cdate, ''), NVL(isir_rdate, '')
	  Into :Sapply_rdate, :Sapply_cdate, :Sisir_rdate
	  From ecomst
	 Where eco_no  = :gs_code
	   And itnbr   = :gs_codename
	 Using sqlca;
	    if sqlca.sqlcode = 0 then
			 dw_insert.SetItem(1, "isir_ymd" , Sisir_rdate) /* ISIR �������� */
			 dw_insert.SetItem(1, "app_ymd"  , Sisir_rdate) /* ���� ����     */
			 dw_insert.SetItem(1, "apply_ymd", Sisir_rdate) /* ���� �������� */
		 end if
	 
end if	
return
end event

event dw_insert::itemfocuschanged;if this.GetColumnName() = "cust_buseo" or &
   this.GetColumnName() = "cust_dam" or &
	this.GetColumnName() = "cust_jikwi" or &
	this.GetColumnName() = "ageemp" then
   f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	
w_mdi_frame.sle_msg.Text = ""

end event

type p_delrow from w_inherite`p_delrow within w_qct_04010
boolean visible = false
integer x = 4407
integer y = 3468
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_04010
boolean visible = false
integer x = 4233
integer y = 3468
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_04010
boolean visible = false
integer x = 3538
integer y = 3468
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04010
integer x = 3698
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;Long crow

crow = dw_ins2.GetRow()

dw_ins2.InsertRow(crow + 1)
dw_ins2.ScrollToRow(crow + 1)
dw_ins2.SetColumn("itnbr") 

p_mod.Enabled = True
p_mod.PictureName  = 'c:\erpman\image\����_up.gif'

dw_ins2.SetFocus()




end event

type p_exit from w_inherite`p_exit within w_qct_04010
integer x = 4393
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_qct_04010
integer x = 4219
integer taborder = 90
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

//rb_mod.checked = true 
//rb_mod.TriggerEvent(Clicked!)
is_status = '1' 
wf_initial()

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type p_print from w_inherite`p_print within w_qct_04010
boolean visible = false
integer x = 3712
integer y = 3468
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04010
integer x = 3525
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String ino
Long   i

p_mod.Enabled = True
p_mod.PictureName  = 'c:\erpman\image\����_up.gif'

if dw_1.AcceptText() = -1 then 
	dw_1.SetFocus()
	return
end if	

if rb_mod.checked = true then  // ������� 

		ino = Trim(dw_1.object.as_jpno[1])
		
		if (IsNull(ino) or ino = "")  then 
			f_message_chk(30, "[�Ƿڹ�ȣ]")
			dw_1.Visible = True
			dw_1.Setfocus()
			return 1
		end if

		dw_insert.SetRedraw(False)
		if dw_insert.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
			MessageBox("�űԵ��", "�ڷᰡ �����ϴ�. �űԷ� ����ϼ���!")
			dw_1.Visible = False
			
			p_del.Enabled = False
			p_del.PictureName = 'c:\erpman\image\����_d.gif'
		
			rb_new.Checked = True
			rb_mod.Checked = False
			
			dw_ins1.SetRedraw(False)
			dw_ins1.Reset()
			dw_ins1.InsertRow(0)
			dw_ins1.SetRedraw(True)
			
			dw_ins2.SetRedraw(False)
			dw_ins2.Reset()
			dw_ins2.InsertRow(0)
			dw_ins2.SetRedraw(True)
			
			dw_insert.SetRedraw(False)
			dw_insert.Reset()
			dw_insert.InsertRow(0)
			dw_insert.SetColumn("cl_jpno")
			dw_insert.Setfocus()
			dw_insert.SetRedraw(True)
			return
		end if
		
		if dw_ins1.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
			dw_ins1.SetRedraw(False)
			dw_ins1.Reset()
			dw_ins1.InsertRow(0)
			dw_ins1.SetRedraw(True)
		end if
		
		w_mdi_frame.sle_msg.Text = ""
		if dw_ins2.Retrieve(gs_sabu, ino) < 1 then //�ڷ� ���� ��
			dw_ins2.SetRedraw(False)
			dw_ins2.Reset()
			dw_ins2.InsertRow(0)
			dw_ins2.SetRedraw(True)
			
			p_mod.Enabled = True
			p_mod.PictureName  = 'c:\erpman\image\����_up.gif'
			
			p_del.Enabled = False
			p_del.PictureName = 'c:\erpman\image\����_d.gif'
			
		else
			dw_ins2.AcceptText()
			//ǰ���� ó�� ������ �� �� �̶� ������ => ���� �Ұ�
			p_del.Enabled = True
			p_del.PictureName = 'c:\erpman\image\����_up.gif'
			
			for i = 1 to dw_ins2.RowCount()
				if dw_ins2.object.as_sts[i] = "2" then
					p_del.Enabled = False
					p_del.PictureName = 'c:\erpman\image\����_d.gif'
					
					w_mdi_frame.sle_msg.Text = "ǰ���� ó�� ������ �� �� �̻� ���� => ���� �Ұ���"
					exit
				end if	
			next	
			
		//	//ǰ�� ��ü�� ó���� ���� �� => ���� �Ұ�
		//	cb_mod.enabled = False
		//	for i = 1 to dw_ins2.RowCount()
		//		if dw_ins2.object.as_sts[i] <> "2" then
		//			cb_mod.enabled = True
		//			exit
		//		end if	
		//	next
		// if cb_mod.enabled = False then sle_msg.Text = "ǰ�� ��ü�� ó���� �� => ���� �Ұ���"
			dw_ins2.AcceptText()
		end if
		
		//ó���� �� ���� �� �� �ְ� ��ư Ȱ��ȭ
		//cb_mod.enabled = true
		
		rb_new.Checked = False
		rb_mod.Checked = True
		
		dw_insert.SetColumn("cl_jpno")
		dw_insert.Setfocus()
		dw_insert.SetRedraw(True)

end if			
			
return
end event

type p_del from w_inherite`p_del within w_qct_04010
integer x = 4046
integer taborder = 80
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;long i, lcRow

if f_msg_delete() = -1 then return

lcRow = dw_insert.GetRow()
dw_insert.DeleteRow(lcRow)
if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : �� + ����]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if
	
lcRow = dw_ins1.GetRow()
dw_ins1.DeleteRow(lcRow)
if dw_ins1.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : ȯ�� �� ����]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if

for i = 1 to dw_ins2.RowCount() 
	if dw_ins2.object.as_sts[i] = "2" then
		ROLLBACK;
	   f_message_chk(31,'[�������� : A/S ó���� ǰ�� ������]') 
	   w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	   Return
   end if
next

for i = dw_ins2.RowCount() to 1 Step -1
	   dw_ins2.DeleteRow(i)
next
if dw_ins2.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : ǰ��]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
end if
	
COMMIT;
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0) 
dw_insert.SetRedraw(True)
	
dw_ins1.SetRedraw(False)
dw_ins1.ReSet()
dw_ins1.InsertRow(0) 
dw_ins1.SetRedraw(True)

dw_ins2.SetRedraw(False)
dw_ins2.ReSet()
dw_ins2.InsertRow(0) 
dw_ins2.SetRedraw(True)

dw_1.ReSet()
dw_1.insertRow(0)
dw_1.setfocus()

rb_new.Checked = False
rb_mod.Checked = True

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_mod from w_inherite`p_mod within w_qct_04010
integer x = 3872
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;string sdate, jpno, ls_yn, ls_as_jpno , sitnbr , silotno, siodate
long i , li_asseq, dSeq , lrow , li_temp


if dw_ins2.Accepttext() = -1 then return
if f_msg_update() = -1 then return  //���� Yes/No ?
if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

//ȯ�� �� ���� �׸�üũ
//dw_ins1.object.sabu[1] = gs_sabu
//dw_ins1.object.as_jpno[1] = jpno

//ǰ���� ���� �ڷ�� �����Ѵ�.
for i = dw_ins2.RowCount() to 1 step -1
	if IsNull(Trim(dw_ins2.object.itnbr[i])) or Trim(dw_ins2.object.itnbr[i]) = "" then
	   dw_ins2.DeleteRow(i)
		continue
	end if
next

//ǰ�� �׸�üũ
if dw_ins2.RowCount() < 1 then
	MessageBox("[ǰ��Ȯ��]","ǰ���� �ݵ�� �� �� �̻� ��� �Ǿ�� �մϴ�.")
	dw_ins2.SetFocus()
	return -1
end if	

for i = 1 to dw_ins2.RowCount()
		dw_ins2.object.rcvdat[i] = Trim(dw_insert.object.rcvdat[1])    //��������
		
		if dw_ins2.object.as_sts[i] = "2" then  					         //����
			dw_ins2.object.as_sts[i] = "2"
		else	
			dw_ins2.object.as_sts[i] = "1"
		end if
				
	
//		if IsNull(Trim(dw_ins2.object.ilotno[i])) or Trim(dw_ins2.object.ilotno[i]) = "" then
//			f_message_chk(30, "[LOT NO]")
//			dw_ins2.SetColumn("ilotno")
//			dw_ins2.ScrollToRow(i)
//			dw_ins2.SetFocus()
//			return -1
//		end if
//	
//		if dw_ins2.object.ilotno[i] < "." OR dw_ins2.object.ilotno[i] > "zzzzzz" then
//			MessageBox('Ȯ ��', "LOT NO�� ���ڳ� ���ڸ� �Է��ϼ���!")
//			dw_ins2.SetColumn("ilotno")
//			dw_ins2.ScrollToRow(i)
//			dw_ins2.SetFocus()
//			return -1
//		end if
		
		if IsNull(Trim(dw_ins2.object.itnbr[i])) or Trim(dw_ins2.object.itnbr[i]) = "" then
			f_message_chk(30, "[ǰ��]")
			dw_ins2.SetColumn("itnbr")
			dw_ins2.ScrollToRow(i)
			dw_ins2.SetFocus()
			return -1
		end if
		
		if IsNull(dw_ins2.object.asqty[i]) or dw_ins2.object.asqty[i] < 1 then
			f_message_chk(30, "[����]")
			dw_ins2.SetColumn("asqty")
			dw_ins2.ScrollToRow(i)
			dw_ins2.SetFocus()
			return -1
		end if
		
		// Lot�� ���� �����԰����� �˻�
		w_mdi_frame.sle_msg.text = '�԰����� �˻���'
		
		sitnbr = dw_ins2.getitemstring(i, "itnbr")
		silotno = dw_ins2.getitemstring(i, "ilotno")	
		siodate = ''
		Select fun_get_asiodate(:gs_sabu, :sitnbr, :silotno) into :siodate
		  From dual;
		dw_ins2.setitem(1, "asipdt", siodate)
		w_mdi_frame.sle_msg.text = ''
		
next

///////////////////////////////////////////////////////////////////////
/* ��ǥä�� */
sdate = f_today() //�ý�������

if rb_new.Checked = True then  //-- ��� ��� 
		dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'F0') // ���� �Ƿڹ�ȣ ä�� 
		 
		if dSeq < 1  or dSeq > 9999 then 
			Rollback;
			f_message_chk(51,'')
			return -1 
		end if
		
		commit;
		
		jpno = sdate + string(dSeq, "0000" ) 

		for lRow = 1 to dw_ins2.Rowcount()
			dw_ins2.setitem( lRow, "sabu" , gs_sabu )
		   dw_ins2.setitem( lRow, "as_jpno", jpno )
			dw_ins2.setitem( lRow, "asseq" , lrow )
		next
		
		dw_insert.setitem( 1 , "sabu" , gs_sabu ) // ����� 
		dw_insert.setitem( 1 , "as_jpno" , jpno  )  // ��ǥ��ȣ 
		
		dw_ins1.setitem( 1 , "sabu" , gs_sabu )   // ����� 
		dw_ins1.setitem( 1 , "as_jpno" , jpno  )  // ��ǥ��ȣ 
		
Elseif rb_mod.checked = True then //�������
	
		  ls_as_jpno = dw_1.getitemstring( 1, 'as_jpno' ) 
	

			select Max(asseq)           
			into :li_asseq
			from asmetr
			where sabu  = :gs_sabu
			and   as_jpno = :ls_as_jpno ;
			
			if sqlca.sqlcode <> 0 then
				MessageBox("Ȯ��", "�������� error")
				return
			end if
			
			li_asseq = li_asseq + 1    // max+1  �� ������.
			
			
			for lRow = 1  to dw_ins2.Rowcount()				
				  
				  dw_ins2.setitem( lRow, "as_jpno", ls_as_jpno ) // ��ǥ��ȣ -- �ʼ��Է� 
		        dw_ins2.setitem( lRow, "sabu" , gs_sabu )
				  
				  li_temp = dw_ins2.object.asseq[lRow]
				  
				  if  isnull(li_temp) or li_temp = 0 then
						dw_ins2.object.asseq[lRow] = li_asseq
				  end if
				 
				  li_asseq = li_asseq + 1 
			next

			dw_ins1.AcceptText()
			If IsNull(dw_ins1.object.asseq[1]) or dw_ins1.object.asseq[1] < 0 or &
				dw_ins1.object.asseq[1] > 999 Then
			Else
				If Isnull(dw_ins1.Object.sabu[1]) Or dw_ins1.Object.sabu[1] = '' Then    //���������� �űԷ� ����Ѵ�.
					dw_ins1.Object.sabu[1]    = gs_sabu
					dw_ins1.Object.as_jpno[1] = ls_as_jpno
				End IF	
			End IF
end if              
///////////////////////////////////////////////////////////////////////////////
/* ���� */
///////////////////////////////////////////////////////////////////////
dw_insert.AcceptText()
if dw_insert.Update() <> 1 then
		ROLLBACK;
		f_message_chk(32,'[�ڷ����� ���� : �� + ����]') 
		w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
		return 
end if

dw_ins1.AcceptText()
if IsNull(dw_ins1.object.asseq[1]) or dw_ins1.object.asseq[1] < 0 or &
   dw_ins1.object.asseq[1] > 999 then
else
   if dw_ins1.Update() <> 1 then
  	   ROLLBACK;
	   f_message_chk(32,'[�ڷ����� ���� : ȯ�� �� ����]') 
	   w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	   return 
	end if	
end if

dw_ins2.AcceptText()
if dw_ins2.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[�ڷ����� ���� : ǰ��]') 
	w_mdi_frame.sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if
	
COMMIT;

////////////////////////////////////////////////////////////////////////////////

w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"

p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\����_up.gif'

if rb_new.checked = true then
		rb_new.checked = False
		rb_mod.checked = True
		is_status = '2'
		wf_initial()
		dw_1.setitem(1, 'as_jpno', jpno ) 
		
		p_inq.triggerevent(clicked!)
end if

ib_any_typing = False //�Է��ʵ� ���濩�� No
 
end event

type cb_exit from w_inherite`cb_exit within w_qct_04010
integer x = 2830
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qct_04010
integer x = 1787
integer y = 3292
end type

type cb_ins from w_inherite`cb_ins within w_qct_04010
integer x = 983
integer y = 2804
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_04010
integer x = 2135
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_04010
integer x = 1079
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_04010
integer x = 1915
integer y = 2808
end type

type st_1 from w_inherite`st_1 within w_qct_04010
end type

type cb_can from w_inherite`cb_can within w_qct_04010
integer x = 2482
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qct_04010
integer x = 1413
integer y = 2808
end type





type gb_10 from w_inherite`gb_10 within w_qct_04010
integer y = 2960
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_04010
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04010
end type

type dw_1 from u_key_enter within w_qct_04010
event ue_key pbm_dwnkey
integer x = 242
integer y = 264
integer width = 800
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_04010_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event getfocus;f_toggle_eng(Handle(this))

p_mod.Enabled = False
p_mod.PictureName  = 'c:\erpman\image\����_d.gif'
			
p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\����_d.gif'

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.ReSet()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)

dw_ins2.SetRedraw(False)
dw_ins2.ReSet()
dw_ins2.InsertRow(0)
dw_ins2.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

end event

event itemchanged;p_inq.TriggerEvent(Clicked!) 
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "as_jpno" then
	open(w_asno_popup)
   this.object.as_jpno[1] = gs_code
	this.TriggerEvent(itemchanged!)
end if	
end event

type dw_ins1 from u_key_enter within w_qct_04010
boolean visible = false
integer x = 489
integer y = 36
integer width = 1298
integer height = 116
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_qct_04010_03"
boolean border = false
end type

event itemchanged;String  s_cod, s_nam
Integer i_no

s_cod = Trim(this.GetText())
ib_any_typing = True //�Է��ʵ� ���濩�� Yes

if this.GetColumnName() = "asseq" then
   i_no = Integer(s_cod)
	select tesdoc into :s_nam 
	  from asdoc_st
	 where sabu = :gs_sabu and docno = :i_no;
	 
	if sqlca.sqlcode <> 0 then
      f_message_chk(50, "�׸��ȣ : " + String(i_no))	   
		this.SetRedraw(False)
		this.object.asseq[1] = 0
		this.object.tesdoc[1] = ""
		this.SetRedraw(True)
		return 1
	else
		this.SetRedraw(False)
	   this.object.tesdoc[1] = s_nam
		this.SetRedraw(True)
   end if
end if	
end event

event ue_pressenter;call super::ue_pressenter;if this.GetColumnName() = "tesdoc" then return

Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemfocuschanged;if this.GetColumnName() = "tesdoc" then
   f_toggle_kor(Handle(this))
elseif this.GetColumnName() = "asseq" then
	f_toggle_eng(Handle(this))
end if	
w_mdi_frame.sle_msg.Text = ""
end event

type dw_ins2 from u_key_enter within w_qct_04010
event ue_key pbm_dwnkey
integer x = 123
integer y = 1292
integer width = 4439
integer height = 996
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_qct_04010_04"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;if keydown(keyF1!) THEN
	this.TriggerEvent(rbuttondown!)
end if	
end event

event itemerror;return 1
end event

event rbuttondown;Long crow
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
crow = this.GetRow()

if this.object.as_sts[crow] = "2" then //ó���� ǰ��
   MessageBox("ó���� ǰ��", "ó���� ǰ���� ���� �Ұ��� �մϴ�!")
	return 1
end if	
if	this.getcolumnname() = "itnbr" then //ǰ��,ǰ��,�԰�
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	
   this.object.itnbr[crow] = gs_code
	this.triggerevent(itemchanged!)
end if	


end event

event itemchanged;String  s_cod, s_nam1, s_nam2, sjijil, sispec_code ,sitnbr, sitdsc,sispec
Integer i_rtn , ireturn
Long crow

s_cod = Trim(this.GetText())
crow = this.getRow()

if this.object.as_sts[crow] = "2" then //ó���� ǰ��
   MessageBox("ó���� ǰ��", "ó���� ǰ���� ���� �Ұ��� �մϴ�!")
	return 1
end if	
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //�Է��ʵ� ���濩�� Yes

if (this.GetColumnName() = "itnbr") Then //ǰ��
	i_rtn = f_get_name4("ǰ��", "Y", s_cod, s_nam1, s_nam2, sjijil, sispec_code)
	this.object.itnbr[crow] = s_cod
	this.object.itdsc[crow] = s_nam1
	this.object.ispec[crow] = s_nam2
	this.object.jijil[crow] = sjijil
	this.object.ispec_code[crow] = sispec_code
	return i_rtn
elseif (this.GetColumnName() = "itdsc") Then //ǰ��
	i_rtn = f_get_name4("ǰ��", "Y", s_nam1, s_cod, s_nam2, sjijil, sispec_code)
	this.object.itnbr[crow] = s_nam1
	this.object.itdsc[crow] = s_cod
	this.object.ispec[crow] = s_nam2
	this.object.jijil[crow] = sjijil
	this.object.ispec_code[crow] = sispec_code
	return i_rtn
elseif (this.GetColumnName() = "ispec") Then //�԰�
	i_rtn = f_get_name4("�԰�", "Y", s_nam1, s_nam2, s_cod, sjijil, sispec_code)
	this.object.itnbr[crow] = s_nam1
	this.object.itdsc[crow] = s_nam2
	this.object.ispec[crow] = s_cod
	this.object.jijil[crow] = sjijil
	this.object.ispec_code[crow] = sispec_code
	return i_rtn
ELSEIF this.GetColumnName() = "jijil"	THEN   // ���� 
	sjijil = trim(this.GetText())

	ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(crow, "itnbr", sitnbr)	
	this.setitem(crow, "itdsc", sitdsc)	
	this.setitem(crow, "ispec", sispec)
	this.setitem(crow, "ispec_code", sispec_code)
	this.setitem(crow, "jijil", sjijil)
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "ispec_code"	THEN  // �԰��ڵ� 
	
	sispec_code = trim(this.GetText())

	ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(crow, "itnbr", sitnbr)	
	this.setitem(crow, "itdsc", sitdsc)	
	this.setitem(crow, "ispec", sispec)
	this.setitem(crow, "ispec_code", sispec_code)
	this.setitem(crow, "jijil", sjijil)
	RETURN ireturn

end if
end event

event itemfocuschanged;if this.GetColumnName() = "as_issue" then
   f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	
w_mdi_frame.sle_msg.Text = ""
end event

event rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

event buttonclicked;long crow, nrow

this.AcceptText()
crow = row //dw_ins2.GetRow()
if crow <= 0 then 
	MessageBox("ROW ����","�ش� ROW �� ������ ���� �����ϼ���!")
	return
end if	

if dwo.name = "cb_new" then
	p_mod.Enabled = True
	p_mod.PictureName  = 'c:\erpman\image\����_up.gif'
		
	dw_ins2.Setredraw(False)
   nrow =crow + 1
   if IsNull(nrow) then 
	   dw_ins2.InsertRow(0)
	else
		dw_ins2.InsertRow(nrow)
   end if	
   dw_ins2.object.itnbr[nrow]  = dw_ins2.object.itnbr[crow]
	dw_ins2.object.itdsc[nrow]  = dw_ins2.object.itdsc[crow]
	dw_ins2.object.ispec[nrow]  = dw_ins2.object.ispec[crow]
	dw_ins2.object.jijil[nrow]  = dw_ins2.object.jijil[crow]
	dw_ins2.object.ispec_code[nrow]  = dw_ins2.object.ispec_code[crow]
	dw_ins2.object.asipdt[nrow] = dw_ins2.object.asipdt[crow]	
	dw_ins2.ScrollToRow(nrow)
   dw_ins2.Setredraw(True)
   dw_ins2.SetColumn("ilotno") 
   dw_ins2.SetFocus()
elseif dwo.name = "cb_del" then
   if dw_ins2.object.as_sts[crow] = "2" then
	   MessageBox("A/S ó���� �ڷ�","A/S ó���� �ڷ�� ���� �Ұ����մϴ�!")
	   return
   end if	
   if f_msg_delete() = -1 then return
   dw_ins2.SetRedraw(False)
   dw_ins2.DeleteRow(crow)
   dw_ins2.SetRedraw(True)

   ib_any_typing = True //�Է��ʵ� ���濩�� Yes
end if	

	
end event

event ue_pressenter;IF this.GetColumnName() = 'as_issue' THEN RETURN 

Send( Handle(this), 256, 9, 0 )
Return 1

end event

type rb_new from radiobutton within w_qct_04010
integer x = 2871
integer y = 64
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

event clicked;is_status = '1' // ��� 

wf_initial() 
end event

type rb_mod from radiobutton within w_qct_04010
integer x = 3173
integer y = 64
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

event clicked;is_status = '2' // ����  

wf_initial() 


end event

type cb_1 from commandbutton within w_qct_04010
boolean visible = false
integer x = 1426
integer y = 3296
integer width = 352
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ǰ���߰�"
end type

type cb_2 from commandbutton within w_qct_04010
boolean visible = false
integer x = 2267
integer y = 2812
integer width = 352
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ǰ�����"
end type

event clicked;//long 	lcRow
//
//if f_msg_delete() = -1 then return
//
//lcRow = dw_ins2.GetRow()
//if lcRow <= 0 then return
//if dw_ins2.object.as_sts[lcrow] = "2" then
//	MessageBox("A/S ó���� �ڷ�","A/S ó���� �ڷ�� ���� �Ұ����մϴ�!")
//	return
//end if	
//dw_ins2.SetRedraw(False)
//dw_ins2.DeleteRow(lcRow)
//dw_ins2.SetRedraw(True)
//
//ib_any_typing = True //�Է��ʵ� ���濩�� Yes
end event

type st_2 from statictext within w_qct_04010
integer x = 137
integer y = 1220
integer width = 1138
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "ǰ��(ó���� ǰ���� ���� �Ұ����մϴ�)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2821
integer y = 28
integer width = 672
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 1200
integer width = 4471
integer height = 1100
integer cornerheight = 40
integer cornerwidth = 55
end type

