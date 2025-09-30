$PBExportHeader$w_pdt_02457.srw
$PBExportComments$치공구 현황
forward
global type w_pdt_02457 from w_standard_print
end type
end forward

global type w_pdt_02457 from w_standard_print
string title = "치공구 현황"
end type
global w_pdt_02457 w_pdt_02457

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gubun, makgub

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gubun = dw_ip.object.gubun[1]
makgub = dw_ip.object.makgub[1]

if (IsNull(sdate) or sdate = "") then sdate = "11110101"
if (IsNull(edate) or edate = "") then edate = "99991231"

//dw_list.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_list.SetReDraw(False)
if makgub = '1' and gubun = '1' then
	      dw_list.DataObject = "d_pdt_02457_5"
elseif makgub = '1' and gubun = '2' then
	      dw_list.DataObject = "d_pdt_02457_6"
elseif makgub = '1' and gubun = '3' then
	      dw_list.DataObject = "d_pdt_02457_7"
elseif makgub = '2' and gubun = '1' then
	      dw_list.DataObject = "d_pdt_02457_2"
elseif makgub = '2' and gubun = '2' then
	      dw_list.DataObject = "d_pdt_02457_3"
elseif makgub = '2' and gubun = '3' then
	      dw_list.DataObject = "d_pdt_02457_4"
end if
	dw_list.SetTransObject(SQLCA)
   dw_list.SetReDraw(true)

if dw_list.Retrieve(gs_sabu, sdate, edate) <= 0 then
	f_message_chk(50,'[치공구 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_pdt_02457.create
call super::create
end on

on w_pdt_02457.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_pdt_02457
end type

type p_exit from w_standard_print`p_exit within w_pdt_02457
end type

type p_print from w_standard_print`p_print within w_pdt_02457
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02457
end type







type dw_ip from w_standard_print`dw_ip within w_pdt_02457
integer x = 64
integer y = 64
integer height = 972
string dataobject = "d_pdt_02457_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string s_cod, s_nam1, s_nam2, gubun
integer i_rtn

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if





end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02457
string dataobject = "d_pdt_02457_2"
end type

