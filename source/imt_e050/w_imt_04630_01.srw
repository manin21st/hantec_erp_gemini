$PBExportHeader$w_imt_04630_01.srw
$PBExportComments$����/ġ���� �����̷�(pop_up)
forward
global type w_imt_04630_01 from window
end type
type p_1 from uo_picture within w_imt_04630_01
end type
type p_2 from uo_picture within w_imt_04630_01
end type
type p_3 from uo_picture within w_imt_04630_01
end type
type p_4 from uo_picture within w_imt_04630_01
end type
type dw_1 from datawindow within w_imt_04630_01
end type
type rr_1 from roundrectangle within w_imt_04630_01
end type
end forward

global type w_imt_04630_01 from window
integer x = 517
integer y = 740
integer width = 3474
integer height = 1288
boolean titlebar = true
string title = "���� ġ���� �����̷�"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
dw_1 dw_1
rr_1 rr_1
end type
global w_imt_04630_01 w_imt_04630_01

type variables
string  iskumno    
end variables

on w_imt_04630_01.create
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.p_2,&
this.p_3,&
this.p_4,&
this.dw_1,&
this.rr_1}
end on

on w_imt_04630_01.destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code)
//ismchno = gs_code

iskumno = gs_code
end event

type p_1 from uo_picture within w_imt_04630_01
integer x = 2715
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\�߰�_up.gif"
end type

event clicked;call super::clicked;long lrow
lrow = dw_1.insertrow(0)
dw_1.setrow(lrow)
dw_1.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\�߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\�߰�_up.gif"

end event

type p_2 from uo_picture within w_imt_04630_01
integer x = 2889
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;long lrow

lrow = dw_1.getrow()

if lrow < 1 then return

if f_msg_delete() = 1 then
	if dw_1.getitemstring(lrow, 'ipdat') > '.' then 
		messagebox('Ȯ ��', '����ó���� �ڷ�� ������ �� �����ϴ�.')
		return 
	end if
	
	dw_1.deleterow(lrow)
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\����_up.gif"
end event

type p_3 from uo_picture within w_imt_04630_01
integer x = 3063
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;long  lCount, lrow, ll_found
string sfind

if dw_1.accepttext() = -1 then return

lCount = dw_1.rowcount()

for lrow = 1 to lCount
   if Isnull(Trim(dw_1.object.jidat[lRow])) or Trim(dw_1.object.jidat[lRow]) = "" then
  	   f_message_chk(1400,'[��������]')
		dw_1.SetRow(lRow)  
	   dw_1.SetColumn('jidat')
	   dw_1.SetFocus()
	   return 
   end if	
   if Isnull(Trim(dw_1.object.dptno[lRow])) or Trim(dw_1.object.dptno[lRow]) = "" then
  	   f_message_chk(1400,'[���޺μ�]')
		dw_1.SetRow(lRow)  
	   dw_1.SetColumn('dptno')
	   dw_1.SetFocus()
	   return 
   end if	
	
	if lrow < lCount then
		sfind = dw_1.object.jidat[lRow] + '||' + dw_1.object.dptno[lRow]
      ll_found = dw_1.Find("sfind = '" + sfind + "'", lrow + 1,  lcount) 
		if ll_found > 0 then
			MessageBox("Ȯ ��", String(ll_found) + " ��° Row�� ��������/�μ� �ߺ��Դϴ�!(��� �Ұ���!)")
			dw_1.SetRow(ll_found)  
			dw_1.SetColumn('jidat')
			dw_1.SetFocus()
			return
		end if	
   end if

   if Isnull(Trim(dw_1.object.sabu[lRow])) or Trim(dw_1.object.sabu[lRow]) = "" then
		dw_1.setitem(lrow, "sabu", gs_sabu)
		dw_1.setitem(lrow, "kumno", iskumno)
//		dw_1.setitem(lrow, "mchno", ismchno)
	end if
next

if dw_1.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if

end event

type p_4 from uo_picture within w_imt_04630_01
integer x = 3237
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\���_up.gif"
end type

event clicked;rollback;
CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\���_up.gif"
end event

type dw_1 from datawindow within w_imt_04630_01
event ue_key pbm_dwnkey
event us_pressenter pbm_dwnprocessenter
integer x = 69
integer y = 180
integer width = 3323
integer height = 968
integer taborder = 10
string dataobject = "d_imt_04630_01_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event us_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dptno" then
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(this.getrow(), "dptno", gs_code)
	this.SetItem(this.getrow(), "cvnas", gs_codename)
end if
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam1, s_nam2, sNull
Integer i_rtn
long    lrow

SetNull(sNull)

lrow = this.getrow()
s_cod = Trim(this.GetText())

if this.getcolumnname() = "dptno" then //�����μ�
	i_rtn = f_get_name2("�μ�", "Y", s_cod, s_nam1, s_nam2)
	this.object.dptno[lrow] = s_cod
	this.object.cvnas[lrow] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "jidat" then //��������
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.jidat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "hidat" then //ȸ������
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[ȸ������]")
		this.object.hidat[lrow] = ""
		return 1
	end if
End If


end event

type rr_1 from roundrectangle within w_imt_04630_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 176
integer width = 3355
integer height = 988
integer cornerheight = 40
integer cornerwidth = 55
end type

