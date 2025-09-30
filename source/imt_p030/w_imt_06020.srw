$PBExportHeader$w_imt_06020.srw
$PBExportComments$** 협력업체 평가현황
forward
global type w_imt_06020 from w_standard_print
end type
end forward

global type w_imt_06020 from w_standard_print
string title = "협력업체 평가현황"
end type
global w_imt_06020 w_imt_06020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, sgub, sgijun, sitgu1, sitgu2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate 	= trim(dw_ip.object.sdate[1])
sgub  	= trim(dw_ip.object.gub[1])
sgijun  	= trim(dw_ip.object.gijun[1])

if IsNull(sdate) or sdate = ""  then 
	f_message_chk(30, "[평가년월]")
	dw_ip.SetColumn("sdate")
	dw_ip.Setfocus()
	return -1
else
	edate = sdate + '31' 
end if

dw_print.SetTransObject(SQLCA)

if sgub = '1' then
	sitgu1 = '2'
	sitgu2 = '4'
	if sgijun = '1' then
		dw_print.object.txt_date.text = String(sdate, "@@@@.@@ (구매-주요)") 
	else
		dw_print.object.txt_date.text = String(sdate, "@@@@.@@ (구매-협력업체)") 		
	end if
else
	sitgu1 = '1'
	sitgu2 = '3'	
	if sgijun = '1' then
		dw_print.object.txt_date.text = String(sdate, "@@@@.@@ (외주-주요)")
	else
		dw_print.object.txt_date.text = String(sdate, "@@@@.@@ (외주-협력업체)")
	end if
end if

if dw_print.Retrieve(gs_sabu, sdate, edate, sgijun, sitgu1, sitgu2) <= 0 then
	f_message_chk(50,'[협력업체 평가현황]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

on w_imt_06020.create
call super::create
end on

on w_imt_06020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', left(is_today, 6))
end event

type p_preview from w_standard_print`p_preview within w_imt_06020
end type

type p_exit from w_standard_print`p_exit within w_imt_06020
end type

type p_print from w_standard_print`p_print within w_imt_06020
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_06020
end type







type st_10 from w_standard_print`st_10 within w_imt_06020
end type



type dw_print from w_standard_print`dw_print within w_imt_06020
string dataobject = "d_imt_06020_02"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_06020
integer x = 105
integer width = 736
integer height = 524
string dataobject = "d_imt_06020_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,"[시작일자]")
		this.SetItem(1,"sdate","")
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_06020
string dataobject = "d_imt_06020_02"
end type

