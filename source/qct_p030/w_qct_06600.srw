$PBExportHeader$w_qct_06600.srw
$PBExportComments$** ���Ҹ�ó����Ȳ
forward
global type w_qct_06600 from w_standard_print
end type
end forward

global type w_qct_06600 from w_standard_print
string title = "�� �Ҹ� ó�� ��Ȳ"
end type
global w_qct_06600 w_qct_06600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[���س��]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_title.text = String(ym,"@@@@�� @@�� �� �Ҹ� ó�� ��Ȳ")
//
//if dw_list.Retrieve(gs_sabu, ym) <= 0 then
//	f_message_chk(50,'[�� �Ҹ� ó�� ��Ȳ]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ym) <= 0 then
	f_message_chk(50,'[�� �Ҹ� ó�� ��Ȳ]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_title.text = String(ym,"@@@@�� @@�� �� �Ҹ� ó�� ��Ȳ")
dw_print.ShareData(dw_list)

return 1

end function

on w_qct_06600.create
call super::create
end on

on w_qct_06600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06600
end type

type p_exit from w_standard_print`p_exit within w_qct_06600
end type

type p_print from w_standard_print`p_print within w_qct_06600
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06600
end type







type st_10 from w_standard_print`st_10 within w_qct_06600
end type



type dw_print from w_standard_print`dw_print within w_qct_06600
string dataobject = "d_qct_06600_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06600
integer x = 78
integer y = 0
integer width = 585
integer height = 148
string dataobject = "d_qct_06600_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[���س��]")
		this.object.ym[1] = ""
		return 1
	end if
end if



end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06600
string dataobject = "d_qct_06600_02"
end type

