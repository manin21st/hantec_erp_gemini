$PBExportHeader$w_qct_06550.srw
$PBExportComments$** ����ǰ A/S��Ȳ(��������)
forward
global type w_qct_06550 from w_standard_print
end type
end forward

global type w_qct_06550 from w_standard_print
boolean TitleBar=true
string Title="����ǰ A/S��Ȳ(��������)"
end type
global w_qct_06550 w_qct_06550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, pymd, temp
Integer i

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
i = dw_ip.object.pymd[1]

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[A/Só�� ���س��]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

temp = f_today()

if i < 0 or i > 9 then
	messagebox("����ǰ ���� ��� ���� Ȯ��", "����ǰ ���� ��� ������ 1 - 9�� �Դϴ�!")
	dw_ip.SetColumn("pymd")
	dw_ip.Setfocus()
	return -1
end if	
pymd = f_aftermonth(Mid(temp,1,6), - (i * 12)) + Mid(temp,7,2)

dw_list.object.txt_pymd.text = String(i) + " ��"
dw_list.object.txt_title.text = String(ym,"@@@@�� @@�� ����ǰ A/S��Ȳ")

if dw_list.Retrieve(gs_sabu, ym, pymd) <= 0 then
	f_message_chk(50,'[����ǰ A/S��Ȳ]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_qct_06550.create
call super::create
end on

on w_qct_06550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_ip from w_standard_print`dw_ip within w_qct_06550
int Y=104
int Width=704
int Height=460
string DataObject="d_qct_06550_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[A/Só�� ���س��]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "pymd" then
	if s_cod < "1" or s_cod > "9" then
		messagebox("����ǰ ���� ��� ���� Ȯ��", "����ǰ ���� ��� ������ 1 - 9�� �Դϴ�!")
		return 1
	end if
end if
return

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06550
string DataObject="d_qct_06550_02"
end type

