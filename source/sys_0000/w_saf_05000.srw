$PBExportHeader$w_saf_05000.srw
$PBExportComments$** 안전재고계산현황
forward
global type w_saf_05000 from w_standard_print
end type
end forward

global type w_saf_05000 from w_standard_print
string title = "안전재고 계산 현황"
end type
global w_saf_05000 w_saf_05000

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, ym, ittyp
Long i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = Trim(dw_ip.object.gubun[1])
ym = Trim(dw_ip.object.ym[1])
ittyp = Trim(dw_ip.object.ittyp[1])

if (IsNull(ym) or ym = "") then 
   f_message_chk(30, "[기준년월]")
   dw_ip.SetColumn("ym")
   dw_ip.Setfocus()
   return -1
end if
if (IsNull(ittyp) or ittyp = "") then ittyp = "%"
	
dw_list.object.txt_ym.text = String(ym, "@@@@년@@월")	
if gubun = "2" then
   i_rtn = dw_list.Retrieve(gs_sabu, ym)
else
	i_rtn = dw_list.Retrieve(gs_sabu, ym, ittyp)
end if

if i_rtn <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_saf_05000.create
call super::create
end on

on w_saf_05000.destroy
call super::destroy
end on

type p_preview from w_standard_print`p_preview within w_saf_05000
end type

type p_exit from w_standard_print`p_exit within w_saf_05000
end type

type p_print from w_standard_print`p_print within w_saf_05000
end type

type p_retrieve from w_standard_print`p_retrieve within w_saf_05000
end type







type st_10 from w_standard_print`st_10 within w_saf_05000
end type



type dw_print from w_standard_print`dw_print within w_saf_05000
end type

type dw_ip from w_standard_print`dw_ip within w_saf_05000
integer x = 73
integer y = 84
integer width = 681
integer height = 1036
string dataobject = "d_saf_05000_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "gubun" then
	dw_list.SetRedraw(False)
	if s_cod = "1" then
		dw_list.DataObject = "d_saf_05000_02"
	elseif s_cod = "2" then
		dw_list.DataObject = "d_saf_05000_03"
	elseif s_cod = "3" then
		dw_list.DataObject = "d_saf_05000_04"
	end if	
	dw_list.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)

	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	
elseif this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_saf_05000
string dataobject = "d_saf_05000_02"
end type

