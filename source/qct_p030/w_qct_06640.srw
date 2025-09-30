$PBExportHeader$w_qct_06640.srw
$PBExportComments$** 생산팀별 불량현황
forward
global type w_qct_06640 from w_standard_print
end type
end forward

global type w_qct_06640 from w_standard_print
boolean TitleBar=true
string Title=" 생산팀별 불량현황"
end type
global w_qct_06640 w_qct_06640

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string yyyy

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	


yyyy = Trim(dw_ip.object.yyyy[1])

if (IsNull(yyyy) or yyyy = "")  then 
	f_message_chk(30, "[기준년도]")
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if

dw_list.object.txt_title.text = String(yyyy,"@@@@년 생산팀별 불량현황")

if dw_list.Retrieve(gs_sabu, yyyy) <= 0 then
	f_message_chk(50,'[생산팀별 불량현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_qct_06640.create
call super::create
end on

on w_qct_06640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_ip from w_standard_print`dw_ip within w_qct_06640
int X=105
int Y=152
int Width=594
int Height=136
string DataObject="d_qct_06640_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "yyyy" then
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.yyyy[1] = ""
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06640
string DataObject="d_qct_06640_02"
end type

