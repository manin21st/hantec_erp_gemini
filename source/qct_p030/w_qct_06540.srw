$PBExportHeader$w_qct_06540.srw
$PBExportComments$** 신제품 A/S현황
forward
global type w_qct_06540 from w_standard_print
end type
end forward

global type w_qct_06540 from w_standard_print
string title = "신제품 A/S현황"
end type
global w_qct_06540 w_qct_06540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, ym, pymd, ym1, ym2, temp
Integer i

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
gubun = Trim(dw_ip.object.gubun[1])
i = dw_ip.object.pymd[1]

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[A/S처리 기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

temp = f_today()

if i < 0 or i > 9 then
	messagebox("신제품 개발 년수 기준 확인", "신제품 개발 년수 기준은 1 - 9년 입니다!")
	dw_ip.SetColumn("pymd")
	dw_ip.Setfocus()
	return -1
end if	
pymd = f_aftermonth(Mid(temp,1,6), - (i * 12)) + Mid(temp,7,2)

ym2 = Mid(temp,1,6)
ym1 = f_aftermonth(ym2, -5)

//dw_list.object.txt_pymd.text = String(i) + " 년"
//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 신제품 A/S현황")
//
//if dw_list.Retrieve(gs_sabu, gubun, ym, pymd, ym1, ym2) <= 0 then
//	f_message_chk(50,'[신제품 A/S현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, gubun, ym, pymd, ym1, ym2) <= 0 then
	f_message_chk(50,'[신제품 A/S현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_pymd.text = String(i) + " 년"
dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 신제품 A/S현황")
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06540.create
call super::create
end on

on w_qct_06540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06540
end type

type p_exit from w_standard_print`p_exit within w_qct_06540
end type

type p_print from w_standard_print`p_print within w_qct_06540
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06540
end type







type st_10 from w_standard_print`st_10 within w_qct_06540
end type



type dw_print from w_standard_print`dw_print within w_qct_06540
string dataobject = "d_qct_06540_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06540
integer x = 69
integer y = 0
integer width = 2135
integer height = 184
string dataobject = "d_qct_06540_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[A/S처리 기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "pymd" then
	if s_cod < "1" or s_cod > "9" then
		messagebox("신제품 개발 년수 기준 확인", "신제품 개발 년수 기준은 1 - 9년 입니다!")
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06540
string dataobject = "d_qct_06540_02"
end type

