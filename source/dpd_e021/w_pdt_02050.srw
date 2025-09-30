$PBExportHeader$w_pdt_02050.srw
$PBExportComments$�۾����� �����ð�������ȭ��
forward
global type w_pdt_02050 from window
end type
type p_mod from uo_picture within w_pdt_02050
end type
type p_del from uo_picture within w_pdt_02050
end type
type p_can from uo_picture within w_pdt_02050
end type
type dw_1 from datawindow within w_pdt_02050
end type
end forward

global type w_pdt_02050 from window
integer x = 142
integer y = 868
integer width = 3351
integer height = 1044
boolean titlebar = true
string title = "��������"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_mod p_mod
p_del p_del
p_can p_can
dw_1 dw_1
end type
global w_pdt_02050 w_pdt_02050

forward prototypes
public function integer wf_check (ref string scolumn)
end prototypes

public function integer wf_check (ref string scolumn);string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, spordno, stoday, sopcode
string   sdeopseq, spropseq
integer  ireturn
Decimal  {5} dunprc, dqty
long     lfind, lrow

sToday = f_today()

dw_1.accepttext()

setnull(snull)

spordno = dw_1.getitemstring(1, "morout_pordno")

/* �����ڵ� */
sopcode = dw_1.getitemstring(1, "morout_opseq")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[�����ڵ�]') 
	dw_1.setitem(1, "morout_opseq", '')
	scolumn = "morout_opseq"
	RETURN  -1
end if

/* ������ ������ check�Ͽ� ������ ������ �Է� ���� */
spropseq = dw_1.getitemstring(1, "morout_pr_opseq")
dqty = 0
select roqty into :dqty from morout where sabu = :gs_sabu and pordno = :spordno and opseq = :spropseq;
if dqty <> 0 then
	messagebox("������", "������ ������ �����մϴ�",stopsign!)
	dw_1.setitem(1, "morout_opseq", '')
	scolumn = "morout_opseq"
	RETURN  -1
end if

/* �İ��� ������ check�Ͽ� ������ ������ �Է� ���� */
sdeopseq = dw_1.getitemstring(1, "morout_de_opseq")
dqty = 0
select roqty into :dqty from morout where sabu = :gs_sabu and pordno = :spordno and opseq = :sdeopseq;
if dqty <> 0 then
	messagebox("�İ���", "�İ��� ������ �����մϴ�",stopsign!)
	dw_1.setitem(1, "morout_opseq", '')
	scolumn = "morout_opseq"
	RETURN  -1
end if

/* ������ */
sopcode = dw_1.getitemstring(1, "morout_opdsc")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[������]') 
	dw_1.setitem(1, "morout_opdsc", '')
	scolumn = "morout_opdsc"
	RETURN  -1
end if

/* �۾��ڵ� */
sopcode = dw_1.getitemstring(1, "morout_roslt")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[�۾��ڵ�]') 
	dw_1.setitem(1, "morout_roslt", '')
	scolumn = "morout_roslt"
	RETURN  -1
end if

/* �˻籸�� */
sopcode = dw_1.getitemstring(1, "morout_qcgub")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[�˻籸��]') 
	dw_1.setitem(1, "morout_qcgub", '')
	scolumn = "morout_qcgub"
	RETURN  -1
end if

/* �ð������� */
sopcode = dw_1.getitemstring(1, "morout_esgbn")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[�ð�������]') 
	dw_1.setitem(1, "morout_esgbn", '')
	scolumn = "morout_esgbn"
	RETURN  -1
end if

/* ���������*/
sreff = dw_1.getitemstring(1, "morout_esdat")
dw_1.setitem(1, "morout_fsdat", sreff)		
dw_1.setitem(1, "morout_system_str_date", sreff)
if isnull(sreff) or trim(sreff) = '' or f_datechk(sreff) = -1 then
	f_message_chk(35,'[���������(1)]') 
	dw_1.setitem(1, "morout_esdat", '')
	dw_1.setitem(1, "morout_fsdat", '')
	dw_1.setitem(1, "morout_system_str_date", '')	
	scolumn = "morout_esdat"
	RETURN  -1
end if

/* ���������� */
sreff1 = dw_1.getitemstring(1, "morout_eedat")	
dw_1.setitem(1, "morout_fedat", sreff1)
dw_1.setitem(1, "morout_system_end_date", sreff1)
if isnull(sreff1) or trim(sreff1) = '' or f_datechk(sreff1) = -1 then
	f_message_chk(35,'[����������(2)]') 
	dw_1.setitem(1, "morout_eedat", '')
	dw_1.setitem(1, "morout_fedat", '')		
	dw_1.setitem(1, "morout_system_end_date", '')
	scolumn = "morout_eedat"			
	RETURN  -1			
end if

if sreff > sreff1 then
	f_message_chk(35,'[����������(3)]') 
	dw_1.setitem(1, "morout_eedat", '')
	dw_1.setitem(1, "morout_fedat", '')
	scolumn = "morout_eedat"
	RETURN  -1			
end if

/* �۾��� */
ireturn = 0
sreff = dw_1.getitemstring(1, "morout_wkctr")
select a.wkctr, a.wcdsc, b.jocod, b.jonam
  into :sitnbr, :sreff, :sitdsc, :sispec
  from wrkctr a, jomast b
 where a.wkctr = :sreff and a.jocod = b.jocod (+);
if sqlca.sqlcode <> 0 then
	f_message_chk(90,'[�۾���]')
	setnull(sreff)		
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
if not isnull(sreff)  and isnull(sitdsc) then
	f_message_chk(91,'[��]')
	setnull(sreff)
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
dw_1.setitem(1, "morout_wkctr", sitnbr)
dw_1.setitem(1, "wrkctr_wcdsc", sreff)
dw_1.setitem(1, "morout_jocod", sitdsc)
dw_1.setitem(1, "jomast_jonam", sispec)
if ireturn = -1 then
	scolumn = "morout_wkctr"
	return -1
end if

/* ���� */
ireturn = 0
sreff = dw_1.getitemstring(1, "morout_mchcod")
if not isnull(sreff) then
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[����]')
		setnull(sreff)
		setnull(sreff1)		
		ireturn = -1
	end if
	dw_1.setitem(1, "mchmst_mchnam", sreff1)
	if ireturn = -1 then
		scolumn = "morout_mchcod"
		return -1
	end if
end if
/* �������� */
sreff = dw_1.getitemstring(1, "morout_purgc")
if sreff = 'Y' then
	Setnull(sCvcod)
	scvcod = dw_1.getitemstring(1, "morout_wicvcod")
	sopseq = dw_1.getitemstring(1, "morout_opseq")
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	if ireturn = 0 then
		if lfind > 0 then				
			sitnbr = dw_1.getitemstring(lfind, "morout_itnbr")
		else
			setnull(sitnbr)
		end if
		select unprc into :dunprc from danmst
			 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq;
		 if sqlca.sqlcode <> 0 then
			 f_message_chk(82,'[ ' + sitdsc + ' ]')
		 end if
	end if	
	dw_1.setitem(1, "morout_wicvcod", scvcod)	
	dw_1.setitem(1, "vndmst_cvnas2",  sitdsc)
	if ireturn  = 1 then
		f_message_chk(30,'[���ְŷ�ó]')
		scolumn = "morout_wicvcod"
		RETURN -1
	end if
	
	if dw_1.getitemdecimal(1, "morout_wiunprc") < 1 then
		f_message_chk(80,'[���ִܰ�]') 
		scolumn = "morout_wiunprc"
		RETURN  -1	
	end if	
	
end if

/* �۾�����ð� */
dunprc = dw_1.getitemdecimal(1, "morout_estim")
if dunprc < 0 then
	f_message_chk(93,'[�۾�����ð�]') 
	scolumn = "morout_estim"
	RETURN  -1
end if

if dw_1.update() = 1 then
Else
	Rollback;
	Messagebox("��������", "�������忡 �����Ͽ����ϴ�", stopsign!)
	return -1
end if

// �������� �� ������ �� �İ��� ����(�� �����߰��� ��쿡�� �Է�),
if dw_1.getitemstring(1, "uptgbn") = 'N' then
	datastore ds
	ds = create datastore
	ds.dataobject = 'd_pdt_02050_1'
	ds.settransobject(sqlca)
	ds.retrieve(gs_sabu, spordno)
	

	// ���� ������ �������� ����
	if ds.rowcount() > 1 then
		For Lrow = 1 to ds.rowcount()
			
			 // ��������
			 if Lrow = 1 then
				 ds.setitem(Lrow, "morout_lastc", '1')
			 Elseif Lrow = ds.rowcount() then
				 ds.setitem(Lrow, "morout_lastc", '3')
			 Else
				 ds.setitem(Lrow, "morout_lastc", '0')
			 End if
			
			 //������ ���� check
			 if Lrow = ds.rowcount() then
				 ds.setitem(Lrow, 		"morout_de_opseq", snull)				
			 Else
				 ds.setitem(Lrow - 1, "morout_de_opseq", ds.getitemstring(Lrow, "morout_opseq"))
			 End if	
	
			 //������ ���� check
			 if Lrow = 1 then 
				 ds.setitem(Lrow, "morout_pr_opseq", '0000')
			 Else
				 ds.setitem(Lrow, "morout_pr_opseq", ds.getitemstring(Lrow - 1, "morout_opseq"))
			 End if		 
	
		Next
	else
		ds.setitem(1, "morout_lastc", '9')	
		ds.setitem(1, "morout_pr_opseq", '0000')	
		ds.setitem(1, "morout_de_opseq", snull)	
	end if
	
	if ds.update() = 1 then
	Else
		Rollback;
		Messagebox("��������", "�������忡 �����Ͽ����ϴ�", stopsign!)
		return -1
	end if
	
	destroy ds
end if
		
	
return 1
end function

on w_pdt_02050.create
this.p_mod=create p_mod
this.p_del=create p_del
this.p_can=create p_can
this.dw_1=create dw_1
this.Control[]={this.p_mod,&
this.p_del,&
this.p_can,&
this.dw_1}
end on

on w_pdt_02050.destroy
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_can)
destroy(this.dw_1)
end on

event open;f_window_center_response(this)

datawindowchild ds_deopseq, ds_propseq
dw_1.GetChild("morout_de_opseq", ds_deopseq)
ds_deopseq.settransobject(sqlca)
if ds_deopseq.retrieve(gs_sabu, gs_code) < 1 then
	ds_deopseq.insertrow(0)
end if

dw_1.GetChild("morout_pr_opseq", ds_propseq)
ds_propseq.settransobject(sqlca)
ds_propseq.retrieve(gs_sabu, gs_code)	
if ds_propseq.retrieve(gs_sabu, gs_code) < 1 then
	ds_propseq.insertrow(0)
end if

dw_1.settransobject(sqlca)

String sitnbr, spspec, ls_master_no

If Not isnull(gs_codename) then
	dw_1.retrieve(gs_sabu, gs_code, gs_codename)
	dw_1.setitem(1, "uptgbn", 'Y')
	dw_1.setcolumn("morout_watims")
	dw_1.setfocus()
	p_del.enabled = true
Else
	dw_1.insertrow(0)	
	
	// �۾������� �⺻���� ������ Move
	Select itnbr, pspec, master_no into :sitnbr, :spspec, :ls_master_no
	  From Momast
	 Where Sabu = :gs_sabu And Pordno = :gs_code;
	 
	dw_1.setitem(1, "morout_sabu", 		gs_sabu)
	dw_1.setitem(1, "morout_pordno", 	gs_code)
	dw_1.setitem(1, "morout_master_no", ls_master_no)	
	dw_1.setitem(1, "morout_itnbr", 		sItnbr)
	dw_1.setitem(1, "morout_pspec", 		sPspec)
	dw_1.setitem(1, "uptgbn", 'N')
	dw_1.setcolumn("morout_opseq")
	dw_1.setfocus()	
   p_del.enabled = false
End if
end event

type p_mod from uo_picture within w_pdt_02050
integer x = 2674
integer y = 724
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;if dw_1.accepttext() = -1 then return

string scolumn

if wf_check(scolumn) = -1 then
	dw_1.setcolumn(scolumn)
	dw_1.setfocus()
	return
else
	Commit;
	Closewithreturn(parent, 'Y')	
end if


end event

type p_del from uo_picture within w_pdt_02050
integer x = 2848
integer y = 724
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;Long Lrow,Lcnt
String sOpdsc, sOpseq, sLastc, sDpseq, sLpseq, sNull, sColumn,spropseq
decimal {2} dqty

Setnull(snull)
Lrow = 1
Lcnt = 0

sOpdsc 	= dw_1.getitemstring(Lrow, "morout_opdsc")
sOpseq	= dw_1.getitemstring(Lrow, "morout_opseq")
sLastc	= dw_1.getitemstring(Lrow, "morout_lastc")
sColumn  = dw_1.getitemstring(Lrow, "morout_pordno")

select count(*) into :lcnt from morout
 where sabu = :gs_sabu And pordno = :sColumn;

if lcnt < 2 then
	Messagebox("����Ȯ��", "1���� �̻��� ������ �ʿ��մϴ�", stopsign!)
	dw_1.setfocus()
	return
end if

/* ������ ������ check�Ͽ� ������ ������ �Է� ���� */
spropseq = dw_1.getitemstring(1, "morout_pr_opseq")
dqty = 0
select roqty into :dqty from morout where sabu = :gs_sabu and pordno = :scolumn and opseq = :spropseq;
if dqty <> 0 then
	messagebox("������", "������ ������ �����մϴ�",stopsign!)
	scolumn = "morout_opseq"
	RETURN  -1
end if

if Messagebox("����Ȯ��", sOpdsc + " ������ �����Ͻð����ϱ�?", question!, yesno!) = 2 then
	dw_1.setfocus()
	return	
end if

SEtpointer(hourglass!)

lcnt = 0
select count(*) into :lcnt from morout
 where sabu = :gs_sabu And pordno = :sColumn and do_opseq = :sopseq;

// ���ð����� ������ ������ �� ����
if lcnt > 0 then
   MessageBox("���ð���", "���ð����� �����ϹǷ� ������ �� �����ϴ�", stopsign!)
	return
end if

// ���� 
dw_1.setredraw(false)
dw_1.deleterow(Lrow)

if dw_1.update() <> 1 then
	rollback;
 	dw_1.retrieve(gs_sabu, scolumn, sopseq)
	f_rollback()
	dw_1.setredraw(true)	
	return
end if

// �������� �� ������ �� �İ��� ����
datastore ds
ds = create datastore
ds.dataobject = 'd_pdt_02050_1'
ds.settransobject(sqlca)
ds.retrieve(gs_sabu, scolumn)


// ���� ������ �������� ����
if ds.rowcount() > 1 then
	For Lrow = 1 to ds.rowcount()
		
		 // ��������
		 if 	  Lrow = 1 then
			 ds.setitem(Lrow, "morout_lastc", '1')
		 Elseif Lrow = ds.rowcount() then
			 ds.setitem(Lrow, "morout_lastc", '3')
		 Else
			 ds.setitem(Lrow, "morout_lastc", '0')
		 End if
		
		 //������ ���� check
		 if Lrow = ds.rowcount() then
			 ds.setitem(Lrow, 		"morout_de_opseq", snull)				
		 Else
			 ds.setitem(Lrow - 1, "morout_de_opseq", ds.getitemstring(Lrow, "morout_opseq"))
		 End if	

		 //������ ���� check
		 if Lrow = 1 then 
			 ds.setitem(Lrow, "morout_pr_opseq", '0000')
		 Else
			 ds.setitem(Lrow, "morout_pr_opseq", ds.getitemstring(Lrow - 1, "morout_opseq"))
		 End if		 

	Next
else
	ds.setitem(1, "morout_lastc", '9')	
	ds.setitem(1, "morout_pr_opseq", '0000')	
	ds.setitem(1, "morout_de_opseq", snull)	
end if

if ds.update() = 1 then
Else
	Rollback;
	Messagebox("��������", "�������忡 �����Ͽ����ϴ�", stopsign!)
	dw_1.retrieve(gs_sabu, scolumn, sopseq)
	dw_1.setredraw(true)		
	return
end if

destroy ds

// �Ҵ������ ����
// 1. �������� ���Ŀ� Min������ ����
// 2. �������� ������ Max������ ����
// 1,2�� �ش���� ������ Erroró��
Setnull(sDpseq)
Select Min(opseq) Into :sDpseq From morout
 where sabu = :gs_sabu And pordno = :sColumn And opseq > :sOpseq;
if Isnull( sDpseq ) then
	Select Max(opseq) Into :sDpseq From morout
	 where sabu = :gs_sabu And pordno = :sColumn And opseq < :sOpseq;
end if

if Isnull( sDpseq ) then
	rollback;
 	dw_1.retrieve(gs_sabu, scolumn,sopseq)
	Messagebox("�����˻�", "�۾����ÿ� ���� ������ �˻��� �� �����ϴ�", stopsign!)
	return
end if	

if MessageBox("����Ȯ��", "���縦 �����Ͻð����ϱ�?", question!, yesno!) = 1 then
	Delete
	  From holdstock
	 Where sabu = :gs_sabu And Pordno = :sColumn And Opseq = :sOpseq;
else
	Update holdstock
		Set opseq = :sDpseq
	 Where sabu = :gs_sabu And Pordno = :sColumn And Opseq = :sOpseq;
end if

SEtpointer(Arrow!)

Commit;

Messagebox("�����Ϸ�", sOpdsc + " ������ �����Ǿ����ϴ�", information!)	

closewithreturn(parent, 'Y')
end event

type p_can from uo_picture within w_pdt_02050
integer x = 3022
integer y = 724
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;Closewithreturn(parent, 'N')
end event

type dw_1 from datawindow within w_pdt_02050
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer width = 3291
integer height = 940
integer taborder = 10
string dataobject = "d_pdt_02050"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;if key  = keyf1! then
	this.triggerevent(rbuttondown!)
end if
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, stoday, sPordno, stropseq, srtnggu, &
			sIogbn, sDptno, sOpdsc, sPurgc, stuncu, scvnas, sroslt, spropseq, sdeopseq, stimegu, sqcgub, sbasic, swkctr, swcdsc
long     lrow,  lcnt
integer  ireturn
Decimal {5} dunprc, dstdst, dstdmc, dmanhr, dmchr, dpqty 
String 		ls_pspec

setnull(snull)

lrow   = 1

if accepttext() = -1 then
	Messagebox("�ڷ�Ȯ��", "�ڷ�Ȯ�ν� ���� �߻�", stopsign!)
	return 1
end if

if  	 this.getcolumnname() = "morout_opseq" then
		sopseq  = gettext()
		sitnbr  = getitemstring(1, "morout_itnbr")
		spordno = getitemstring(1, "morout_pordno")
		
		// ������ ������ȣ�� �ִ� �� �˻�
		Lcnt = 0
		Select count(*) into :lcnt from morout
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq = :sopseq;		
		if Lcnt > 0 then
			Messagebox("������ȣ", "������ ������ȣ�� �����մϴ�", stopsign!)
			setitem(1, "morout_opdsc", sopseq)
			setitem(1, "morout_opdsc", snull) 
			setitem(1, "morout_roslt", snull)	
			setitem(1, "morout_de_opseq", snull) 
			setitem(1, "morout_pr_opseq", snull)
			return 1
		end if
		
		// �������� �˻�
		Select pdqty into :dpqty from momast where sabu = :gs_sabu And pordno = :spordno;
		if isnull( dpqty ) then dpqty = 0
		
		/* �ð����� ������ ȯ�漳������ �˻� (1:ǥ�ؽð�, 2:��սð�) */
		select dataname
		  into :stimegu
		  from syscnfg
		 where sysgu = 'Y' and serial = '15' and lineno = '3';
		 
		if isnull( stimegu ) or trim( stimegu ) = '' or ( stimegu <> '1' And stimegu <> '2' ) Then
			stimegu = '2'
		End if
		
		/* �������� ������ ȯ�漳������ �˻� (1:��������� ����, 2:��ü����)*/
		select dataname
		  into :srtnggu
		  from syscnfg
		 where sysgu = 'Y' and serial = '15' and lineno = '6';
	
		/* ���������� ����� ��쿡�� ������ϴ� ������ �ջ��Ѵ� */
		if srtnggu = '1' then
			select Max(decode(uptgu, 'Y', opseq, '')) into :stropseq
			  from routng
			 where itnbr = :sitnbr and opseq < :sopseq;
		else
			stropseq = sopseq
		End if;
		 
		if isnull( stropseq ) then stropseq = '0000' 
		
		setnull(sopdsc)
		setnull(sroslt)
		Select a.opdsc, a.roslt, a.qcgub, b.wkctr, b.wcdsc, b.basic, 
				 nvl(c.stdst, 0), nvl(c.stdmc, 0), nvl(c.manhr, 0), nvl(c.mchr, 0)		
		  into :sopdsc, :sroslt, :sqcgub, :swkctr, :swcdsc, :sbasic, :dstdst, :dstdmc, :dmanhr, :dmchr 
		  from routng a, wrkctr b,
		  		(select nvl(sum(a.stdst), 0) as stdst, nvl(sum(a.stdmc), 0)   as stdmc,
						  nvl(sum(decode(:stimegu, '1', a.manhr, a.manhr1)), 0) as manhr,
				 		  nvl(sum(decode(:stimegu, '1', a.mchr,  a.mchr1)), 0)  as mchr
				  	from routng a, wrkctr b
				  Where a.itnbr = :sitnbr And a.opseq > :stropseq And a.opseq <= :sopseq
		 			 and a.wkctr = b.wkctr) c
		 Where a.itnbr = :sitnbr And a.opseq = :sopseq
		 	and a.wkctr = b.wkctr;
			 
		if isnull( dstdst ) then dstdst = 0
		if isnull( dstdmc ) then dstdmc = 0
		if isnull( dmanhr ) then dmanhr = 0
		if isnull( dmchr  ) then dmchr  = 0
		
		dmanhr = dmanhr * dpqty;
		dmchr  = dmchr  * dpqty;
		 
		setitem(1, "morout_opdsc", sopdsc) 
		setitem(1, "morout_roslt", sroslt)
		setitem(1, "morout_esinw", dstdmc)
		setitem(1, "morout_estim", dstdst + dmanhr + dmchr)
		setitem(1, "morout_esset", dstdst)
		setitem(1, "morout_esman", dmanhr)
		setitem(1, "morout_esmch", dmchr)		
		setitem(1, "morout_esgbn", sBasic)
		setitem(1, "morout_wkctr", swkctr)
		setitem(1, "wrkctr_wcdsc", swcdsc)		
		
		// �Էµ� �����ڵ� ������ �������� �����ڵ带 �˻�
		setnull(spropseq)
		Select Max(opseq) into :spropseq From morout
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq < :sopseq;
		 
		if isnull( spropseq ) then spropseq = '0000'
		
		// �Էµ� �����ڵ� ������ �������� �����ڵ带 �˻�
		setnull(sdeopseq)
		Select Min(opseq) into :sdeopseq From morout
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq > :sopseq;
		 
		setitem(1, "morout_de_opseq", sdeopseq) 
		setitem(1, "morout_pr_opseq", spropseq)	
	
Elseif this.getcolumnname() = "morout_esdat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[���������]') 
		this.setitem(lrow, "morout_esdat", '')
		this.setitem(lrow, "morout_fsdat", '')
		RETURN  1
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[���������]') 
		this.setitem(lrow, "morout_esdat", '')
		this.setitem(lrow, "morout_fsdat", '')		
		RETURN  1			
	end if
	this.setitem(lrow, "morout_fsdat", this.gettext())
elseif this.getcolumnname() = "morout_eedat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_esdat", '')
		this.setitem(lrow, "morout_eedat", '')
		this.setitem(lrow, "morout_fsdat", '')
		this.setitem(lrow, "morout_fedat", '')		
		RETURN  1			
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_esdat", '')
		this.setitem(lrow, "morout_eedat", '')
		this.setitem(lrow, "morout_fsdat", '')
		this.setitem(lrow, "morout_fedat", '')		
		RETURN  1			
	end if
	if this.getitemstring(lrow, "morout_esdat") > this.gettext() then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_esdat", '')
		this.setitem(lrow, "morout_eedat", '')
		this.setitem(lrow, "morout_fsdat", '')
		this.setitem(lrow, "morout_fedat", '')
		RETURN  1			
	end if
	this.setitem(lrow, "morout_fedat", this.gettext())
elseif this.getcolumnname() = "morout_wkctr" then
	ireturn = 0
	sreff = this.gettext()
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[�۾���]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[��]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	this.setitem(lrow, "morout_wkctr", sitnbr)
	this.setitem(lrow, "wrkctr_wcdsc", sreff1)
	this.setitem(lrow, "morout_jocod", sitdsc)
	this.setitem(lrow, "jomast_jonam", sispec)
	return ireturn
elseif this.getcolumnname() = "morout_mchcod" then
	ireturn = 0
	sreff = this.getitemstring(lrow, "morout_mchcod")
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[����]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(lrow, "mchmst_mchnam", sreff1)
	return ireturn	
elseif this.getcolumnname() = "morout_purgc"  then	
	this.setitem(lrow, "morout_wicvcod", '')
	this.setitem(lrow, "vndmst_cvnas2", '')
	this.setitem(lrow, "morout_wiunprc", 0)
	
	sPordno = getitemstring(lrow, "morout_pordno")
	sopseq  = getitemstring(lrow, "morout_opseq")	
	sopdsc  = getitemstring(lrow, "morout_opdsc")	
	sPurgc  = this.gettext()
	
	if sPurgc = 'N' then
		// ���ְ� �ƴ� ��쿡�� ���� ��� ������ �ڵ���� ������ Setting�Ѵ�.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autpdt = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("�������", "�ڵ����� ���ұ����� �˻��� �� �����ϴ�", stopsign!)
			return 1
		end if
		
		select pdtgu into :sdptno from momast
		 where sabu = :gs_sabu and pordno = :spordno;
		
		select cvcod   into :sCvcod
		  from vndmst where cvgu = '5' and jumaeip = :sDptno;
			
		Update Holdstock
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '1',
				 naougu	  = '1' 				 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
			
		Commit;	
		
	Else
			
		sitnbr 		= getitemstring(1, "morout_itnbr")
		ls_pspec 	= getitemstring(1, "morout_pspec")
		
		f_buy_unprc(sitnbr, ls_pspec, sopseq, scvcod, scvnas, dUnprc, sTuncu)				
		
//		select cvcod, unprc into :sCvcod, :dUnprc from danmst
//			 where itnbr = :sitnbr and opseq = :sopseq and sltcd = 'Y';
//			 
//		 if sqlca.sqlcode <> 0 then
//	 		 f_message_chk(82,'[ ' + sOpdsc + ' ]')
//		 end if
		 
		setitem(Lrow, "morout_wicvcod", sCvcod)
		setitem(lrow, "morout_wiunprc", dunprc)
		ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����
		setitem(Lrow, "vndmst_cvnas2", sItdsc)		 
		
		// ������ ��쿡�� ���� ��� ������ ������� ������ Setting�Ѵ�.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autvnd = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("������", "������� ���ұ����� �˻��� �� �����ϴ�", stopsign!)
			return 1
		end if
		Update Holdstock
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '2',
				 naougu	  = '2' 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
		Commit;		
		
	end if	
	
elseif this.getcolumnname() = "morout_wicvcod"	then
	scvcod = this.getitemstring(lrow, "morout_wicvcod")
	sopseq = this.getitemstring(lrow, "morout_opseq")
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	if ireturn = 0 then
		sitnbr = getitemstring(1, "morout_itnbr")
		select unprc into :dunprc from danmst
			 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq and sltcd = 'Y';
		 if sqlca.sqlcode <> 0 then
	 		 f_message_chk(82,'[ ' + sitdsc + ' ]')
			 scvcod = ''
			 dunprc = 0
			 sitnbr = ''
			 sitdsc = ''
			 ireturn = 1
		 else
			 this.setitem(lrow, "morout_wiunprc", dunprc)
		 end if
	end if	
	
	sPordno = getitemstring(Lrow, "morout_pordno")
	sopseq  = getitemstring(lrow, "morout_opseq")		
	
	// �Ҵ��� ����ó�� ����
	Update Holdstock
		Set out_store = sCvcod
	 Where sabu = :gs_sabu and Pordno = :sPordno;
	Commit;			
	
	this.setitem(lrow, "morout_wicvcod", scvcod)	
	this.setitem(lrow, "vndmst_cvnas2",  sitdsc)
   this.setitem(lrow, "morout_wiunprc", dunprc)
	RETURN ireturn
elseif this.getcolumnname() = "morout_wiunprc"  then
	if dec(this.gettext()) < 1 then
		f_message_chk(80,'[���ִܰ�]') 
		RETURN  1	
	end if	
elseif this.getcolumnname() = "morout_esset"  then
	setitem(1, "morout_estim", getitemdecimal(1, "morout_esman") + getitemdecimal(1, "morout_esmch") + dec(gettext()))
elseif this.getcolumnname() = "morout_esman"  then
	setitem(1, "morout_estim", getitemdecimal(1, "morout_esset") + getitemdecimal(1, "morout_esmch") + dec(gettext()))	
elseif this.getcolumnname() = "morout_esmch"  then
	setitem(1, "morout_estim", getitemdecimal(1, "morout_esset") + getitemdecimal(1, "morout_esman") + dec(gettext()))		
end if
end event

event itemerror;return 1
end event

event rbuttondown;string colname
long   lrow

SETNULL(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

colname = this.getcolumnname()
lrow    = this.getrow()

if     colname = "morout_mchcod" then
		 gs_code = this.gettext()
		 gs_gubun    = this.getitemstring(lrow, "morout_wkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_wicvcod" then
		 gs_code = getitemstring(lrow, "morout_itnbr")
		 gs_codename = this.getitemstring(lrow, "morout_opseq")
		 open(w_danmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_wicvcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_wkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_wkctr", gs_code)
		 this.triggerevent(itemchanged!)
end if


end event

