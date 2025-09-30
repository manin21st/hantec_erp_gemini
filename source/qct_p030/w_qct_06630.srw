$PBExportHeader$w_qct_06630.srw
$PBExportComments$** 월생산팀별 불량율
forward
global type w_qct_06630 from w_standard_print
end type
end forward

global type w_qct_06630 from w_standard_print
string title = "월 생산팀별 불량율"
end type
global w_qct_06630 w_qct_06630

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, ym1

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	


ym = Trim(dw_ip.object.ym[1])
ym1 = f_aftermonth(ym, -11)

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 생산팀별 불량율")
//
//if dw_list.Retrieve(gs_sabu, ym, ym1) <= 0 then
//	f_message_chk(50,'[월 생산팀별 불량율]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ym, ym1) <= 0 then
	f_message_chk(50,'[월 생산팀별 불량율]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 생산팀별 불량율")
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06630.create
call super::create
end on

on w_qct_06630.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06630
end type

type p_exit from w_standard_print`p_exit within w_qct_06630
end type

type p_print from w_standard_print`p_print within w_qct_06630
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06630
end type







type st_10 from w_standard_print`st_10 within w_qct_06630
end type



type dw_print from w_standard_print`dw_print within w_qct_06630
string dataobject = "d_qct_06630_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06630
integer x = 69
integer y = 96
integer width = 626
integer height = 184
string dataobject = "d_qct_06630_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
end if
return

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06630
string dataobject = "d_qct_06630_02"
end type

