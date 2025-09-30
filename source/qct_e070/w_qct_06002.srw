$PBExportHeader$w_qct_06002.srw
$PBExportComments$������ ����Ÿ ���
forward
global type w_qct_06002 from w_inherite
end type
type gb_3 from groupbox within w_qct_06002
end type
type dw_ins1 from u_key_enter within w_qct_06002
end type
type cb_tdel from commandbutton within w_qct_06002
end type
type cb_add from commandbutton within w_qct_06002
end type
type st_2 from statictext within w_qct_06002
end type
type cb_1 from commandbutton within w_qct_06002
end type
type p_3 from uo_picture within w_qct_06002
end type
type dw_insp from u_key_enter within w_qct_06002
end type
type rr_1 from roundrectangle within w_qct_06002
end type
end forward

global type w_qct_06002 from w_inherite
integer x = 5
integer y = 4
integer width = 4663
string title = "������� ������ ���"
gb_3 gb_3
dw_ins1 dw_ins1
cb_tdel cb_tdel
cb_add cb_add
st_2 st_2
cb_1 cb_1
p_3 p_3
dw_insp dw_insp
rr_1 rr_1
end type
global w_qct_06002 w_qct_06002

forward prototypes
public function integer wf_required_chk ()
public function integer wf_delete_chk (string smchno)
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ + Fill
Long i, ll_found, inull
String s_itnbr, sLisGu, sDate, stopdat, pedat, sBuncd, sMchno, smax
Int  imax

setnull(inull)

if dw_insert.AcceptText() = -1 then return -1

if Isnull(Trim(dw_insert.object.sabu[1])) or Trim(dw_insert.object.sabu[1]) = "" then
	dw_insert.object.sabu[1] = gs_sabu
	dw_insp.object.sabu[1] = gs_sabu
end if	

if Isnull(Trim(dw_insert.object.mchnam[1])) or Trim(dw_insert.object.mchnam[1]) = "" then
  	f_message_chk(1400,'[����]')
	dw_insert.SetColumn('mchnam')
	dw_insert.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.grpcod[1])) or Trim(dw_insert.object.grpcod[1]) = "" then
  	f_message_chk(1400,'[�׷��ڵ�]')
	dw_insert.SetColumn('grpcod')
	dw_insert.SetFocus()
	return -1
end if

sBuncd = Trim(dw_insert.object.buncd[1])
if Isnull(Trim(dw_insert.object.buncd[1])) or Trim(dw_insert.object.buncd[1]) = "" then
  	f_message_chk(1400,'[�з��ڵ�]')
	dw_insert.SetColumn('buncd')
	dw_insert.SetFocus()
	return -1
end if

sMchno = Trim(dw_insert.object.mchno[1])
If IsNull(sMchno) Or sMchNo = '' Then
	SELECT MAX(MCHNO) INTO :smax FROM MCHMST WHERE KEGBN = 'Y';
	If IsNull(sMax) Or Trim(sMax) ='' Then
		imax = 1
	Else
		imax = integer(mid(smax,2,5)) + 1
	End If
	
	sMchno = 'G' + string(imax,'00000')
	dw_insert.Setitem(1, 'mchno', smchno)
	dw_insp.Setitem(1, 'mchno', smchno)
	MessageBox('Ȯ��','�ű� ����ȣ�� ' + smchno + ' �Դϴ�.!!')
End If

if Isnull(Trim(dw_insert.object.jenam[1])) or Trim(dw_insert.object.jenam[1]) = "" then
  	f_message_chk(1400,'[����ȸ��]')
	dw_insert.SetColumn('jenam')
	dw_insert.SetFocus()
	return -1
end if	

//�ڻ��ȣ : ���񱸺��� '1'(�ڻ�)�̸� �ʼ�, '2'(���ڻ�)�̸� Blank
if Trim(dw_insert.object.gubun[1]) = "1" and &
   ( Isnull(Trim(dw_insert.object.kfcod1[1])) or Trim(dw_insert.object.kfcod1[1]) = "") then
  	f_message_chk(1400,'[�ڻ��ȣ]')
	dw_insert.SetColumn('kfcod1')
	dw_insert.SetFocus()
	return -1
elseif dw_insert.object.gubun[1] = "2" then
	dw_insert.object.kfcod1[1] = ""
end if

if Trim(dw_insert.object.gubun[1]) = "1" and &
   Isnull(dw_insert.GetItemNumber(1, 'kfcod2'))  then
  	f_message_chk(1400,'[�ڻ��ȣ]')
	dw_insert.SetColumn('kfcod2')
	dw_insert.SetFocus()
	return -1
elseif dw_insert.object.gubun[1] = "2" then
	dw_insert.object.kfcod2[1] = inull
end if	

//�Ϻ������� : ������� ���� ���� �� ����
if Trim(dw_insert.GetItemString(1,'sum_yn')) = 'Y' Then
	If ((Isnull(dw_insert.object.dailyhr[1]) or dw_insert.object.dailyhr[1] <= 0)) then
		f_message_chk(1400,'[���� ��������]')
		dw_insert.SetColumn('dailyhr')
		dw_insert.SetFocus()
		return -1
	End If
else
	dw_insert.SetItem(1,'dailyhr', 0)
end if

if Isnull(Trim(dw_insert.object.dptno[1])) or Trim(dw_insert.object.dptno[1]) = "" then
  	f_message_chk(1400,'[���μ�]')
	dw_insert.SetColumn('dptno')
	dw_insert.SetFocus()
	return -1
end if	

//if Isnull(Trim(dw_insert.object.jedat[1])) or Trim(dw_insert.object.jedat[1]) = "" then
//  	f_message_chk(1400,'[��������]')
//	dw_insert.SetColumn('jedat')
//	dw_insert.SetFocus()
//	return -1
//end if	
//if Isnull(Trim(dw_insert.object.gunam[1])) or Trim(dw_insert.object.gunam[1]) = "" then
//  	f_message_chk(1400,'[����ó]')
//	dw_insert.SetColumn('gunam')
//	dw_insert.SetFocus()
//	return -1
//end if	
//if Isnull(Trim(dw_insert.object.gudat[1])) or Trim(dw_insert.object.gudat[1]) = "" then
//  	f_message_chk(1400,'[��������]')
//	dw_insert.SetColumn('gudat')
//	dw_insert.SetFocus()
//	return -1
//end if	
//���Աݾ� : ���񱸺��� '1'(�ڻ�)�̸� 100���� �̻�, '2'(���ڻ�)�̸� 100���� �̸�
//if Isnull(dw_insert.object.guamt[1]) or dw_insert.object.guamt[1] < 0 then
//  	f_message_chk(1400,'[���Աݾ�]')
//	dw_insert.SetColumn('guamt')
//	dw_insert.SetFocus()
//	return -1
//end if	

//if Isnull(Trim(dw_insert.object.kegbn[1])) or Trim(dw_insert.object.kegbn[1]) = "" then
//  	f_message_chk(1400,'[����/��������]')
//	dw_insert.SetColumn('kegbn')
//	dw_insert.SetFocus()
//	return -1
//end if	

/* ���� ������,������ */
sLisGu = dw_insert.GetItemString(1,'lisgu')
If sLisGu = 'Y' Then
	sDate = Trim(dw_insert.GetItemString(1,'lisstd'))

	If f_datechk(sDate) <> 1 Then
		f_message_chk(1400,'[����������]')
		dw_insert.SetColumn('lisstd')
		Return -1
	End If
	
	sDate = Trim(dw_insert.GetItemString(1,'lisetd'))

	If f_datechk(sDate) <> 1 Then
		f_message_chk(1400,'[����������]')
		dw_insert.SetColumn('lisetd')
		Return -1
	End If
End If

/* ������� ������ ����� �ʼ� */
pedat = trim(dw_insert.GetItemString(1,'pedat'))
If not (isnull(pedat) or pedat = '' ) Then
	if Isnull(Trim(dw_insert.object.pesau[1])) or Trim(dw_insert.object.pesau[1]) = "" then
		f_message_chk(1400,'[������]')
		dw_insert.SetColumn('pesau')
		dw_insert.SetFocus()
		return -1
	else
		stopdat = Trim(dw_insert.object.stopdat[1])
		if IsNull(stopdat) or stopdat = "" or stopdat > pedat then
			dw_insert.object.stopdat[1] = dw_insert.object.pedat[1]
		end if	
		
	end if	
End If

for i = 1 to dw_ins1.RowCount()
   dw_ins1.object.sabu[i] = gs_sabu
	dw_ins1.object.mchno[i] = dw_insert.object.mchno[1]
   if Isnull(Trim(dw_ins1.object.itnbr[i])) or Trim(dw_ins1.object.itnbr[i]) = "" then
  	   f_message_chk(1400,'[ǰ��]')
		dw_ins1.SetRow(i)  
	   dw_ins1.SetColumn('itnbr')
	   dw_ins1.SetFocus()
	   return -1
   end if	
   if Isnull(dw_ins1.object.qtypr[i]) or dw_ins1.object.qtypr[i] <= 0 then
  	   f_message_chk(1400,'[�ҿ����]')
		dw_ins1.SetRow(i)  
	   dw_ins1.SetColumn('qtypr')
	   dw_ins1.SetFocus()
	   return -1
   end if
   s_itnbr = dw_ins1.object.itnbr[i] 
	if i < dw_ins1.RowCount() then
      ll_found = dw_ins1.Find("itnbr = '" + s_itnbr + "'", i + 1, dw_ins1.RowCount())
		if ll_found > 0 then
			MessageBox("SPARE PART LIST �ߺ�", String(ll_found) + " ��° Row�� ǰ���� �ߺ��Դϴ�!(��� �Ұ���!)")
			return -1
		end if	
   end if
next

return 1
end function

public function integer wf_delete_chk (string smchno);Long icnt = 0

select count(*) into :icnt 
  from mesmst
 where sabu = :gs_sabu 
   and mchno = :smchno;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[�����⸶����]')
	return -1
end if

select count(*) into :icnt 
  from mchmst_insp
 where sabu  = :gs_sabu 
   and mchno = :smchno;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[���������˱���]')
	return -1
end if

select count(*) into :icnt 
  from shpact
 where sabu   = :gs_sabu 
   and mchcod = :smchno and rownum = 1 ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[�۾�����]')
	return -1
end if

select count(*) into :icnt 
  from morout
 where sabu   = :gs_sabu 
   and mchcod = :smchno  and rownum = 1 ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[�۾����� ������]')
	return -1
end if

select count(*) into :icnt 
  from kumest
 where sabu  = :gs_sabu 
   and mchno = :smchno  ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[����/ġ���� ����/���� �Ƿ�]')
	return -1
end if

select count(*) into :icnt 
  from mchmst_send
 where sabu  = :gs_sabu 
   and mchno = :smchno  ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[�����������̷�]')
	return -1
end if

return 1
end function

on w_qct_06002.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_ins1=create dw_ins1
this.cb_tdel=create cb_tdel
this.cb_add=create cb_add
this.st_2=create st_2
this.cb_1=create cb_1
this.p_3=create p_3
this.dw_insp=create dw_insp
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_ins1
this.Control[iCurrent+3]=this.cb_tdel
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.p_3
this.Control[iCurrent+8]=this.dw_insp
this.Control[iCurrent+9]=this.rr_1
end on

on w_qct_06002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.dw_ins1)
destroy(this.cb_tdel)
destroy(this.cb_add)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.p_3)
destroy(this.dw_insp)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins1.SetTransObject(SQLCA)
dw_insp.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insp.InsertRow(0)
dw_insert.Setredraw(True)

dw_ins1.Setredraw(False)
dw_ins1.ReSet()

dw_ins1.Setredraw(True)

dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_06002
integer x = 59
integer y = 168
integer width = 4562
integer height = 948
integer taborder = 10
string dataobject = "d_qct_06002_01"
boolean border = false
end type

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, sNull,  Sbuncd, ls_buncd, ls_mchnam, ls_mchno 
Integer i_rtn, iNull, count1, i_cnt
long    ll_cnt
Real    guamt

SetNull(sNull)
SetNull(iNull)

w_mdi_frame.sle_msg.text = ""
s_cod = Trim(this.GetText())

if this.GetColumnName() = "mchno" then // ������ȣ  
	
 	s_cod = Trim(GetText())
		
		select count(mchno) into :i_cnt from mchmst
 		where sabu = :gs_sabu and mchno = :s_cod and kegbn = 'Y';
 
 		If i_cnt > 0 Then
			p_inq.TriggerEvent(Clicked!)
		Else
			MessageBox('Ȯ��','�������ȣ�� �ڵ�ä���Դϴ�.!!')
			Return 2
		End If
	
	p_inq.triggerevent(clicked!)
	
elseif this.getcolumnname() = "wkctr" then //�۾���
	i_rtn = f_get_name2("�۾���", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr[1] = s_cod
	this.object.wcdsc[1] = s_nam1
	if IsNull(s_cod) or s_cod = "" then this.object.dailyhr[1] = 0
	return i_rtn
elseif this.getcolumnname() = "gubun" then //���񱸺�
	if s_cod = '2' then
		this.object.kfcod1[1] = snull
		this.object.kfcod2[1] = inull
	end if
elseif this.getcolumnname() = "dptno" then //�����μ�
	i_rtn = f_get_name2("�μ�", "Y", s_cod, s_nam1, s_nam2)
	this.object.dptno[1] = s_cod
	this.object.cvnas2[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "gunam" then //���Ժμ�
	i_rtn = f_get_name2("�μ�", "Y", s_cod, s_nam1, s_nam2)
	this.object.gunam[1] = s_cod
	this.object.gu_cvnas2[1] = s_nam1
	return i_rtn	
elseif this.getcolumnname() = "jedat" then //��������
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.jedat[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "gudat" then //��������
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.gudat[1] = ""
		return 1
	end if
//elseif this.getcolumnname() = "grpcod" then //�׷��ڵ�
//	select grpnam into :s_nam1 from mchgrp
//	 where grpcod = :s_cod;
//	if sqlca.sqlcode <> 0 then
//		f_message_chk(35, "[�׷��ڵ�]")
//		this.object.grpcod[1] = ""
//		return 1
//	end if	
//elseif this.getcolumnname() = "guamt" then //���Աݾ�
//	guamt = Real(s_cod)
//	if guamt < 0 then 
//		MessageBox("���Աݾ�", "���Աݾ��� �Է��ϼ���! (Zero�� �̻�!)")
//		this.object.gubun[1] = "1"
//		
//		SetItem(1, 'kfcod1', sNull)
//		SetItem(1, 'kfcod2', iNull)
//
//		this.object.guamt[1] = 0
//	elseif guamt < 1000000 then //100���� �̻� �ڻ�, �ƴϸ� ���ڻ�	
//		this.object.gubun[1] = "2"
//		SetItem(1, 'kfcod1', sNull)
//		SetItem(1, 'kfcod2', iNull)
//	else	
//		this.object.gubun[1] = "1"
//	end if	
elseif this.getcolumnname() = "pedat" then //�������	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�������]")
		this.object.pedat[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "stopdat" then //�����������	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�����������]")
		this.object.stopdat[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "lisstd" then //����������	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[����������]")
		this.object.lisstd[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "lisetd" then //����������	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[����������]")
		this.object.lisetd[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "jidate" then //����������	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.jidate[1] = ""
		return 1
	end if
/* Main CD */
ElseIf getcolumnname() = "maincd" then
	String sMainCd, sMainNam
	
	sMainCd = Trim(GetText())
	If IsNull(sMainCd) Or sMainCd = '' Then
		SetItem(1, 'maincd_nam', sNull)
	End If

	SELECT MCHNAM INTO :sMainNam
	  FROM MCHMST
	 WHERE SABU = :gs_sabu AND
	       MCHNO = :sMainCd;
	If sqlca.sqlcode <> 0 Then
		SetItem(1, 'maincd', sNull)
		SetItem(1, 'maincd_nam', sNull)
		Return 1
	End If
	
	SetItem(1, 'maincd_nam', sMainNam)


elseif Getcolumnname() = "buncd" then   // �з��ڵ� 
	Sbuncd = trim(GetText())
	if IsNull(Sbuncd) or Sbuncd = '' then return
	
	SELECT COUNT(*)  
	  INTO :ll_cnt
     FROM MITNCT
	 WHERE KEGBN = 'Y'
	   AND LMSGU = 'S'
	   AND BUNCD = :Sbuncd ; 
	
	if ll_cnt = 0 then
		MessageBox('Ȯ��' , '��ϵ������� ������ �з��ڵ� �Դϴ�(�Һз��� ����).')
		setitem(1,'buncd',snull)
		return 1
	end if 
		
end if 	
return
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "mchno" then
	gs_gubun = 'ALL'
	gs_code  = '������'
	open(w_mchno_popup)
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
	if not (IsNull(gs_code) or gs_codename = "") then
		p_inq.TriggerEvent(Clicked!)
	end if	
	return

elseif this.getcolumnname() = "wkctr" then
	open(w_workplace_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "wkctr", gs_code)
	this.SetItem(1, "wcdsc", gs_codename)
	return
elseif this.getcolumnname() = "dptno" then
	open(w_vndmst_4_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "dptno", gs_code)
	this.SetItem(1, "cvnas2", gs_codename)
	return
elseif this.getcolumnname() = "gunam" then
	open(w_vndmst_4_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "gunam", gs_code)
	this.SetItem(1, "gu_cvnas2", gs_codename)
	return	
elseif this.getcolumnname() = "kfcod2" then
	gs_code = this.getitemstring(1, 'kfcod1')
   gs_codename = '0'
	open(w_kfaa02b)
	If IsNull(gs_code) Or gs_code = '' Then Return
	SetItem(1,'kfcod1', gs_code)
	SetItem(1,'kfcod2', dec(gs_codename))
/* Main Cd */
Elseif	this.getcolumnname() = "maincd" then
	open(w_mchno_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	SetItem(1, "maincd", gs_code)
	SetItem(1, "maincd_nam", gs_codename)
Elseif this.GetColumnname() = "buncd" then
	gs_gubun = 'Y'
	Open(w_mittyp_popup)
	if IsNull(gs_code) or gs_code = '' then Return
	
	If gs_gubun <> 'S' Then
			MessageBox('Ȯ��','�Һз��� �����Ͻ� �� �ֽ��ϴ�.!!')
			Return 2
	End If
		
	SetItem(1, "buncd", gs_code)	
	
end if


end event

event dw_insert::doubleclicked;call super::doubleclicked;if this.getcolumnname() = "imgpath" then	
   p_search.TriggerEvent(Clicked!)	
end if
end event

event dw_insert::buttonclicked;call super::buttonclicked;string pathname, filename
integer value

if dwo.name <> "btn1" then return

this.AcceptText()
pathname = Trim(this.object.imgpath[1])
//if IsNull(pathname) or pathname = "" then
//	value = GetFileOpenName("����", pathname, filename, "BMP", "Image Files (*.BMP),*.BMP")
//   if value = 0 THEN return
//   if value <> 1 then
//	   MessageBox("���� ������ ����","����Ƿ� ���� �ϼ���!")
//      return
//   end if
//end if	
////�̹��� ��� ������ Call
OpenWithParm(w_pdt_06010, pathname)
pathname = Message.StringParm
if not (IsNull(pathname) or pathname = "") then
   dw_insert.object.imgpath[1] = Trim(pathname)
end if	

end event

type p_delrow from w_inherite`p_delrow within w_qct_06002
integer x = 3561
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\�����_d.gif"
end type

event p_delrow::clicked;call super::clicked;long lcRow
Boolean fg

if f_msg_delete() = -1 then return

lcRow = dw_ins1.GetRow()
if IsNull(dw_ins1.object.sabu[lcRow]) or dw_ins1.object.sabu[lcRow] = "" then
	fg = False
else
	fg = True
end if	
dw_ins1.DeleteRow(lcRow)

if fg = True then
   if dw_ins1.Update(false, true) <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[�������� : ���������� ���]') 
	   w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	   Return
   else
      COMMIT;		
		dw_ins1.ResetUpdate()
   end if
end if

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"

end event

type p_addrow from w_inherite`p_addrow within w_qct_06002
integer x = 3387
integer taborder = 40
end type

event p_addrow::clicked;Long crow

dw_ins1.Setredraw(False)
crow = dw_ins1.InsertRow(dw_ins1.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_ins1.InsertRow(0)
end if	
dw_ins1.ScrollToRow(crow)
dw_ins1.Setredraw(True)
dw_ins1.SetColumn("itnbr")
dw_ins1.SetFocus()
end event

type p_search from w_inherite`p_search within w_qct_06002
boolean visible = false
integer x = 3835
integer y = 3284
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_06002
boolean visible = false
integer x = 4357
integer y = 3284
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_06002
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qct_06002
integer taborder = 80
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.SetFocus()

dw_insp.SetRedraw(False)
dw_insp.Reset()
dw_insp.InsertRow(0)
dw_insp.SetRedraw(True)
dw_insp.SetFocus()

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_print from w_inherite`p_print within w_qct_06002
boolean visible = false
integer x = 4009
integer y = 3284
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_06002
integer x = 3749
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String s_mchno
Long   i_cnt

if dw_insert.AcceptText() = -1 then return

s_mchno = dw_insert.object.mchno[1]

if IsNull(s_mchno) or s_mchno = '' then
	w_mdi_frame.sle_msg.text = "����ȣ�� ���� �Է��� �� �����ϼ���!"
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
	return 
end if

//�����ȣ�� üũ�Ѵ�. (�űԷ� ������ ���� ������ ���ܳ��� ����) - �ӽ� 99.07.23
select count(mchno) into :i_cnt from mchmst
 where mchno = :s_mchno and kegbn = 'Y';
 
if sqlca.sqlcode <> 0 or i_cnt < 1 then
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\����_d.gif'

   dw_insert.object.gudat[1] = "" //�������� CLEAR
	
	dw_ins1.SetRedraw(False)
	dw_ins1.ReSet()
	dw_ins1.SetRedraw(True)
   
	dw_insert.SetRedraw(False)
	dw_insert.ReSet()
	dw_insert.insertrow(0)
	dw_insp.ReSet()
	dw_insp.insertrow(0)
	dw_insert.setitem( 1, "mchno", s_mchno )
	dw_insp.setitem( 1, "sabu", gs_sabu )
	dw_insp.setitem( 1, "mchno", s_mchno )
	dw_insert.SetRedraw(True)


   dw_insert.SetColumn("gubun")
   dw_insert.SetFocus() 

   dw_insert.SetItemStatus(1, 0, primary!, new!)

   MessageBox("�űԵ��", "�űԷ� ��� �մϴ�!")
	w_mdi_frame.sle_msg.text = "�űԷ� ��� �մϴ�!"
	return
end if	


dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, s_mchno) < 1 then
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\����_d.gif'
	
	dw_ins1.SetRedraw(False)
	dw_ins1.ReSet()
	dw_ins1.SetRedraw(True)
	
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.object.mchno[1] = s_mchno 
	
	dw_insp.ReSet()
	dw_insp.InsertRow(0)
	dw_insp.object.sabu[1] = gs_sabu
	dw_insp.object.mchno[1] = s_mchno 
	w_mdi_frame.sle_msg.text = "�űԷ� ��� �մϴ�!"
else
	/* Main CD */
	String sMainCd, sMainNam
	
	sMainCd = Trim(dw_insert.GetItemString(1,'maincd'))
	If IsNull(sMainCd) Or sMainCd = '' Then sMainNam = ''

	SELECT MCHNAM INTO :sMainNam
	  FROM MCHMST
	 WHERE SABU = :gs_sabu AND
	       MCHNO = :sMainCd;
	
	dw_insert.SetItem(1, 'maincd_nam', sMainNam)
	
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\����_up.gif'
	
	dw_ins1.Retrieve(gs_sabu, s_mchno)
	If dw_insp.Retrieve(gs_sabu, s_mchno) <= 0 Then
		dw_insp.InsertRow(0)
		dw_insp.object.sabu[1] = gs_sabu
		dw_insp.object.mchno[1] = s_mchno 
	End If
	
	w_mdi_frame.sle_msg.text = "�����۾��� �����ϼ���!!"
end if	
dw_insert.SetColumn("gubun")
dw_insert.SetFocus() 
dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_qct_06002
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;long lcRow
String mchno

if f_msg_delete() = -1 then return

mchno = dw_insert.object.mchno[1]

//���� ���ɿ��� üũ�� �־�� �� 
if wf_delete_chk(mchno) = -1 then return 

lcRow = dw_insp.GetRow()
dw_insp.DeleteRow(lcRow)

lcRow = dw_insert.GetRow()
dw_insert.DeleteRow(lcRow)

for lcRow = 1 to dw_ins1.RowCount()
	dw_ins1.DeleteRow(lcRow)
next	

if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[�������� : �����⸶����]') 
	w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	Return
else
   if dw_insp.Update() <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[�������� : ������ ����]') 
	   w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	   Return
   else
      COMMIT;		
   end if
	
   if dw_ins1.Update() <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[�������� : ����������]') 
	   w_mdi_frame.sle_msg.Text = "���� �۾� ����!"
	   Return
   else
      COMMIT;		
   end if
end if

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_insp.SetRedraw(False)
dw_insp.ReSet()
dw_insp.InsertRow(0)
dw_insp.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.ReSet()
dw_ins1.SetRedraw(True)

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\����_d.gif'

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type p_mod from w_inherite`p_mod within w_qct_06002
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;String pedat, stopdat, ls_no

if dw_insert.AcceptText() = -1 then return
if dw_ins1.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if f_msg_update() = -1 then return

ls_no = dw_insert.GetItemString(1,'mchno')

IF dw_insert.Update(true, false) > 0 THEN
	IF dw_insp.Update(true, false) > 0 THEN
	ELSE
	   ROLLBACK;
	   f_message_chk(32, "[�������2]")
	   w_mdi_frame.sle_msg.Text = "�����۾� ����!"
		Return
   END IF
	
	IF dw_ins1.Update(true, false) > 0 THEN
	ELSE
	   ROLLBACK;
	   f_message_chk(32, "[�������2]")
	   w_mdi_frame.sle_msg.Text = "�����۾� ����!"
		Return
   END IF
ELSE
	ROLLBACK;
	f_message_chk(32, "[�������3]")
	w_mdi_frame.sle_msg.Text = "�����۾� ����!"
	Return
END IF

COMMIT;

dw_insert.ResetUpdate()
dw_insp.ResetUpdate()
dw_ins1.ResetUpdate()

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\����_up.gif'		
		
//���������� UPDATE
update mchmst
	set msq_date = to_char(sysdate,'YYYYMMDD'),
		 msqyn    = to_char(sysdate,'hh24mi')
 where sabu     = :gs_sabu
	and mchno    = :ls_no;

commit;

ib_any_typing = False //�Է��ʵ� ���濩�� No

end event

type cb_exit from w_inherite`cb_exit within w_qct_06002
integer x = 2830
integer y = 3284
end type

type cb_mod from w_inherite`cb_mod within w_qct_06002
integer x = 1787
integer y = 3284
end type

type cb_ins from w_inherite`cb_ins within w_qct_06002
integer x = 983
integer y = 2832
end type

type cb_del from w_inherite`cb_del within w_qct_06002
integer x = 1051
integer y = 3284
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_06002
integer x = 1399
integer y = 3280
end type

type cb_print from w_inherite`cb_print within w_qct_06002
integer x = 1349
integer y = 2824
end type

type st_1 from w_inherite`st_1 within w_qct_06002
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_06002
integer x = 2482
integer y = 3284
end type

type cb_search from w_inherite`cb_search within w_qct_06002
integer x = 2898
integer y = 1924
integer width = 334
integer taborder = 100
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_qct_06002
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_06002
integer x = 5
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_06002
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_06002
end type

type gb_3 from groupbox within w_qct_06002
boolean visible = false
integer x = 1714
integer y = 2760
integer width = 411
integer height = 188
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_ins1 from u_key_enter within w_qct_06002
event ue_key pbm_dwnkey
integer x = 101
integer y = 1560
integer width = 4503
integer height = 728
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_06002_02"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

Choose Case GetColumnName()
	/* ǰ�� */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow, "itnbr", gs_code)
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
End Choose
end event

event itemerror;return 1
end event

event itemchanged;Long lRow , ireturn
String sItnbr, sItdsc, sIspec, sIspec_code, sJijil, sNull

lRow = GetRow()
If lRow <= 0 then Return

SetNull(sNull)


IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())

	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sitdsc = trim(this.GetText())

	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sispec = trim(this.GetText())

	ireturn = f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())

	ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(this.GetText())

	ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	RETURN ireturn
END IF

//
//Choose Case GetColumnName()
//	/* ǰ�� */
//	Case	"itnbr" 
//		sItnbr = Trim(GetText())
//		IF sItnbr ="" OR IsNull(sItnbr) THEN
//			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
//			SetItem(nRow,'jijil',sNull)
//			SetItem(nRow,'ispec_code',sNull)
//			Return
//		END IF
//		
//		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL", "ITEMAS"."ISPEC_CODE"
//		  INTO :sItdsc, :sIspec, :sJijil, :sIspec_code
//		  FROM "ITEMAS"
//		 WHERE "ITEMAS"."ITNBR" = :sItnbr;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			f_message_chk(33,'[ǰ��]') 
//			SetItem(nRow,'itnbr',sNull)
//			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
//			SetItem(nRow,'jijil',sNull)
//			SetItem(nRow,'ispec_code',sNull)
//			Return 1
//		END IF
//		
//		SetItem(nRow, "itdsc", sItdsc)
//		SetItem(nRow, "ispec", sIspec)
//		SetItem(nRow, "jijil", sJijil)
//		SetItem(nRow, "Ispec_code", sIspec_code)
//End Choose
end event

event clicked;call super::clicked;if row < 1 and row > this.RowCount() then
	p_delrow.Enabled = False
	p_delrow.PictureName = 'c:\erpman\image\�����_d.gif'
else
	p_delrow.Enabled = True
	p_delrow.PictureName = 'c:\erpman\image\�����_up.gif'
end if	

end event

type cb_tdel from commandbutton within w_qct_06002
boolean visible = false
integer x = 2135
integer y = 3284
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "��ü����"
end type

type cb_add from commandbutton within w_qct_06002
boolean visible = false
integer x = 704
integer y = 3284
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�߰�(&A)"
end type

type st_2 from statictext within w_qct_06002
integer x = 114
integer y = 1488
integer width = 722
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[SPARE PART LIST]"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_qct_06002
boolean visible = false
integer x = 1746
integer y = 2816
integer width = 352
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "�����̷�"
end type

event clicked;gs_code = dw_insert.getitemstring(1, "mchno")
open(w_pdt_06000_01)
end event

type p_3 from uo_picture within w_qct_06002
integer x = 2999
integer y = 20
integer width = 178
boolean bringtotop = true
string picturename = "c:\erpman\image\�������_up.gif"
end type

event clicked;call super::clicked;string ls_mchno

setnull(gs_gubun)
setnull(gs_code)
if dw_insert.accepttext() = -1 then return 

gs_gubun = 'Y'
Open(w_adt_01150_1)

end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\�������_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\�������_up.gif"
end event

type dw_insp from u_key_enter within w_qct_06002
integer x = 82
integer y = 1112
integer width = 4562
integer height = 360
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_qct_05000"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_06002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 87
integer y = 1472
integer width = 4526
integer height = 836
integer cornerheight = 40
integer cornerwidth = 55
end type

