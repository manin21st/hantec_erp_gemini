$PBExportHeader$w_imt_01600.srw
$PBExportComments$�����ǰ��ȹ ��������Ƿ� ����
forward
global type w_imt_01600 from window
end type
type p_2 from uo_picture within w_imt_01600
end type
type p_1 from uo_picture within w_imt_01600
end type
type st_1 from statictext within w_imt_01600
end type
type dw_1 from datawindow within w_imt_01600
end type
type gb_1 from groupbox within w_imt_01600
end type
end forward

global type w_imt_01600 from window
integer x = 823
integer y = 360
integer width = 1403
integer height = 956
boolean titlebar = true
string title = "��������Ƿ� ����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
st_1 st_1
dw_1 dw_1
gb_1 gb_1
end type
global w_imt_01600 w_imt_01600

on w_imt_01600.create
this.p_2=create p_2
this.p_1=create p_1
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.p_2,&
this.p_1,&
this.st_1,&
this.dw_1,&
this.gb_1}
end on

on w_imt_01600.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;f_child_saupj(dw_1,'empno',gs_saupj)

dw_1.settransobject(sqlca)
dw_1.insertrow(0)

// �����ҿ��ȹ�� ���� ����
String 	sMyymm
Integer	iseq

Select Max(mtryymm)
  Into :sMyymm
  from mtrpln_sum
 where sabu = :gs_sabu;
  
if sqlca.sqlcode = 0 then
	Select Max(mrseq) Into :iSeq
	  from mtrpln_sum
	 Where sabu = :gs_sabu And mtryymm = :sMyymm;
else
	Messagebox("�����ҿ��ȹ", "�����ҿ��ȹ�� �����ϴ�", stopsign!)
	close(this)
	Return
end if

/* �ΰ� ����� */
f_mod_saupj(dw_1,'saupj')

dw_1.setitem(1, "gyymm", sMyymm)
dw_1.setitem(1, "gseq", iseq)
dw_1.setfocus()
end event

type p_2 from uo_picture within w_imt_01600
integer x = 1184
integer y = 588
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�ݱ�_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\�ݱ�_up.gif'
end event

type p_1 from uo_picture within w_imt_01600
integer x = 1024
integer y = 588
string picturename = "C:\erpman\image\�����Ƿ�_up.gif"
end type

event clicked;call super::clicked;String 	sYymm, sEmpno, sScvcod, sEcvcod, sCalgu, sDelgu, sError, ssaupj
integer	iSeq

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

sYymm 	= TRIM(dw_1.getitemstring(1, "gyymm"))
Iseq		= dw_1.getitemdecimal(1, "gseq")
sSaupj	= dw_1.getitemstring(1, "saupj")
sEmpno	= dw_1.getitemstring(1, "empno")
sScvcod	= dw_1.getitemstring(1, "scvcod")
sEcvcod  = dw_1.getitemstring(1, "ecvcod")
sCalgu	= dw_1.getitemstring(1, "calgu")
sDelgu	= dw_1.getitemstring(1, "Delgu")

IF isnull(sSaupj) or trim(ssaupj) = '' then 
	f_message_chk(30, "[�����]")
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or trim(sEmpno) = '' then 
	f_message_chk(30, "[�����]")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN
END IF

if isnull(sSCvcod) or trim(sSCvcod) = '' then sSCvcod = '.'
if isnull(sECvcod) or trim(sEcvcod) = '' then sEcvcod = 'ZZZZZZ'

sError = 'X'

St_1.text = '�����Ƿ��ڷḦ �������Դϴ�...!!'

sqlca.erp000000410(gs_sabu, syymm, iseq, sempno, sScvcod, sEcvcod, sCalgu, sDelgu, sSaupj, sError);

If sError = 'X' or sError = 'Y' then
	f_message_chk(41, '[��������Ƿ�]') 
Else
	Messagebox("�������", "���������� �����Ƿڰ� �Ǿ����ϴ�", information!)
	st_1.text = ''
	close(parent)
end if



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�����Ƿ�_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\�����Ƿ�_up.gif'
end event

type st_1 from statictext within w_imt_01600
integer x = 37
integer y = 764
integer width = 1307
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_01600
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 37
integer y = 16
integer width = 1339
integer height = 576
integer taborder = 10
string dataobject = "d_imt_01600_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "scvcod"	THEN //�ŷ�ó�ڵ�(FROM)		
	open(w_vndmst_popup)
   this.SetItem(1, "scvcod", gs_code)
	return
ELSEIF this.getcolumnname() = "ecvcod"	THEN //�ŷ�ó�ڵ�(TO)		
	open(w_vndmst_popup)
   this.SetItem(1, "ecvcod", gs_code)
	return
END IF
end event

event itemchanged;String	ls_data

IF GetColumnName() = 'saupj' THEN
	ls_data = GetText()
	
	IF ls_data = '' THEN Return
	f_child_saupj(dw_1,'empno',ls_data)
END IF
end event

type gb_1 from groupbox within w_imt_01600
integer x = 23
integer y = 732
integer width = 1339
integer height = 124
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
end type

