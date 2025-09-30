$PBExportHeader$w_pdt_02165.srw
$PBExportComments$** 일별 근무시간 대 실적시간 현황
forward
global type w_pdt_02165 from w_standard_print
end type
end forward

global type w_pdt_02165 from w_standard_print
boolean TitleBar=true
string Title="일별 근무시간 대 실적시간 현황"
end type
global w_pdt_02165 w_pdt_02165

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ymd

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ymd = trim(dw_ip.object.ymd[1])

if (IsNull(ymd) or ymd = "")  then 
	f_message_chk(30, "[기준일자]")
	dw_ip.SetColumn("ymd")
	dw_ip.Setfocus()
	return -1
end if

if dw_list.Retrieve(gs_sabu, ymd) <= 0 then
	f_message_chk(50,'[일별 근무시간 대 실적시간 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_pdt_02165.create
call super::create
end on

on w_pdt_02165.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;String ymd

f_toggle_eng(Handle(this))

ymd = Trim(Message.StringParm)
dw_ip.object.ymd[1] = ymd

if IsNull(ymd) or ymd = "" or ymd = "w_pdt_02165" then
	dw_ip.object.ymd[1] = ""
	dw_ip.SetFocus()	
else
	p_retrieve.TriggerEvent(Clicked!)
end if	
end event

type dw_ip from w_standard_print`dw_ip within w_pdt_02165
int X=87
int Y=204
int Width=677
int Height=160
string DataObject="d_pdt_02165_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ymd" then
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[기준일자]")
		this.object.ymd[1] = ""
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02165
string DataObject="d_pdt_02165_02"
end type

