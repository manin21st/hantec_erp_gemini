$PBExportHeader$w_imt_04720.srw
$PBExportComments$제작/수리 의뢰현황
forward
global type w_imt_04720 from w_standard_print
end type
end forward

global type w_imt_04720 from w_standard_print
string title = "제작/수리 의뢰현황"
end type
global w_imt_04720 w_imt_04720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate ,ls_edate ,ls_kestgub ,ls_makgub ,ls_gubun ,tx_name

if dw_ip.accepttext() <> 1 then return -1

ls_sdate   = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate   = Trim(dw_ip.getitemstring(1,'edate'))
ls_kestgub = dw_ip.getitemstring(1,'kestgub')
ls_makgub  = dw_ip.getitemstring(1,'makgub')
ls_gubun   = dw_ip.getitemstring(1,'gubun')

if ls_sdate= "" or isnull(ls_sdate) then
	f_message_chk(30,'[의뢰일자 FROM]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

if ls_edate= "" or isnull(ls_edate) then
	f_message_chk(30,'[의뢰일자 FROM]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	return -1
end if

if ls_kestgub = "" or isnull(ls_kestgub) then ls_kestgub = '%'
if ls_makgub  = "" or isnull(ls_makgub)  then ls_makgub  = '%'
if ls_gubun  = "A"                       then ls_gubun  = '%'

if dw_list.retrieve(gs_sabu, ls_sdate, ls_edate, ls_kestgub ,ls_makgub ,ls_gubun) < 1 then
	f_message_chk(300,'')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

dw_list.object.tx_sdate.text = left(ls_sdate,4) +'.' +mid(ls_sdate,5,2) + '.' + mid(ls_sdate,7,2)
dw_list.object.tx_edate.text = left(ls_edate,4) +'.' +mid(ls_edate,5,2) + '.' + mid(ls_edate,7,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(kestgub) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_kestgub.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(makgub) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_makgub.text = '"+tx_name+"'")

if ls_gubun ='M' then
	dw_list.object.tx_gubun.text = '금형'
elseif ls_gubun = 'J' then
	dw_list.object.tx_gubun.text = '치공구'
else
	dw_list.object.tx_gubun.text = '전체'
end if

return 1

end function

on w_imt_04720.create
call super::create
end on

on w_imt_04720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) +'01')
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_imt_04720
end type

type p_exit from w_standard_print`p_exit within w_imt_04720
end type

type p_print from w_standard_print`p_print within w_imt_04720
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04720
end type







type dw_ip from w_standard_print`dw_ip within w_imt_04720
integer x = 59
integer y = 80
integer height = 996
string dataobject = "d_imt_04720_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_sdate ,ls_edate ,ls_data ,null

setnull(null)

ls_data  = Trim(dw_ip.getcolumnname())

Choose Case ls_data
	Case 'sdate'
		ls_sdate = Trim(Gettext())
		
		if ls_sdate = "" or isnull(ls_sdate) then return
		
		if f_datechk(ls_sdate) = -1 then
			f_message_chk(35,"[의뢰일자 FROM]")
			dw_ip.setitem(1,'sdate',null)
			dw_ip.setcolumn('sdate')
			dw_ip.setfocus()
		   return 1
	   end if
	Case 'edate'
	   ls_edate = Trim(Gettext())
		
		if ls_edate = "" or isnull(ls_edate) then return
		
		if f_datechk(ls_edate) = -1 then
			f_message_chk(35,"[의뢰일자 TO]")
			dw_ip.setitem(1,'edate',null)
			dw_ip.setcolumn('edate')
			dw_ip.setfocus()
		   return 1
	   end if
END CHOOSE
	
end event

type dw_list from w_standard_print`dw_list within w_imt_04720
string dataobject = "d_imt_04720"
end type

