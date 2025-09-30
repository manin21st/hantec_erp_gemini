$PBExportHeader$w_pdt_06562.srw
$PBExportComments$설비가동시간
forward
global type w_pdt_06562 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06562
end type
end forward

global type w_pdt_06562 from w_standard_print
string title = "설비가동시간"
rr_1 rr_1
end type
global w_pdt_06562 w_pdt_06562

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_syymm, ls_eyymm, sGub

if dw_ip.Accepttext() = -1 then return -1

ls_syymm = dw_ip.getitemstring(1, "syymm" )
ls_eyymm = dw_ip.getitemstring(1, "eyymm" ) 
sGub     = dw_ip.getitemstring(1, "gub" ) 

if IsNull(ls_syymm) or ls_syymm = "" then  ls_syymm = '100001' 
if IsNull(ls_eyymm) or ls_eyymm = "" then  ls_eyymm = '999912' 

if sGub = '1' then 
   dw_list.dataobject = 'd_pdt_06562'  //생산팀별
	dw_print.dataobject = 'd_pdt_06562_p'  //생산팀별
else
   dw_list.dataobject = 'd_pdt_06562_02'  //부서별
	dw_print.dataobject = 'd_pdt_06562_02_p'  //부서별
end if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_print.ShareData(dw_list)

dw_print.object.syymm.text = string(ls_syymm , "@@@@.@@" ) 
dw_print.object.eyymm.text = string(ls_eyymm , "@@@@.@@" ) 

if dw_print.retrieve(gs_sabu, ls_syymm + '01', ls_eyymm  + '31') <= 0 then 
	f_message_chk(50, '')
	dw_list.insertrow(0)
	//return -1
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_06562.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06562.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'syymm', left(is_today, 6))
dw_ip.setitem(1, 'eyymm', left(is_today, 6))
end event

type p_preview from w_standard_print`p_preview within w_pdt_06562
end type

type p_exit from w_standard_print`p_exit within w_pdt_06562
end type

type p_print from w_standard_print`p_print within w_pdt_06562
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06562
end type







type st_10 from w_standard_print`st_10 within w_pdt_06562
end type



type dw_print from w_standard_print`dw_print within w_pdt_06562
string dataobject = "d_pdt_06562_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06562
integer x = 32
integer y = 24
integer width = 2194
integer height = 140
string dataobject = "d_pdt_06562_01"
end type

event dw_ip::itemchanged;call super::itemchanged;string s_cod

s_cod = trim(this.gettext())

if this.GetColumnName() = "syymm" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod+'01') = -1 then
		f_message_chk(35, "[시작월]")
		this.object.syymm[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "eyymm" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod+'01') = -1 then
		f_message_chk(35, "[종료월]")
		this.object.eyymm[1] = ""
		return 1
	end if	
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_06562
integer x = 41
integer y = 180
integer width = 4576
integer height = 2032
string dataobject = "d_pdt_06562"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06562
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 172
integer width = 4603
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

