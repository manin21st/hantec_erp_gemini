$PBExportHeader$w_cia30340.srw
$PBExportComments$생산팀간 지원이력 명세서
forward
global type w_cia30340 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30340
end type
end forward

global type w_cia30340 from w_standard_print
string title = "생산팀간 지원이력 명세서"
boolean maxbox = true
rr_1 rr_1
end type
global w_cia30340 w_cia30340

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_fr_costcd, s_to_costcd, s_ym,s_ymt

if dw_ip.AcceptText() = -1 then
   dw_ip.SetFocus()
	return -1
end if	

s_ym  = trim(dw_ip.object.ym[1])
s_ymt = trim(dw_ip.object.ymt[1])
s_fr_costcd = trim(dw_ip.object.fr_costcd[1])
s_to_costcd = trim(dw_ip.object.to_costcd[1])

if (IsNull(s_ym) or s_ym = "")  then 
	f_message_chk(30, "[원가계산년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(s_ymt) or s_ymt = "")  then 
	f_message_chk(30, "[원가계산년월]")
	dw_ip.SetColumn("ymt")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(s_fr_costcd) or s_fr_costcd = "")  then 
	s_fr_costcd = '%'
end if
if (IsNull(s_to_costcd) or s_to_costcd = "")  then 
	s_to_costcd = '%'
end if

if dw_print.Retrieve(s_ym, s_ymt,s_fr_costcd, s_to_costcd) <= 0 then
	f_message_chk(50,'[사업부간 지원이력 명세]')
	return -1
	dw_ip.Setfocus()
	
end if
   dw_print.sharedata(dw_list)
return 1
end function

on w_cia30340.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30340.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "ym", left(f_today(), 6))
dw_ip.setitem(1, "ymt", left(f_today(), 6))

end event

type p_preview from w_standard_print`p_preview within w_cia30340
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_cia30340
integer y = 8
end type

type p_print from w_standard_print`p_print within w_cia30340
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30340
integer y = 8
end type







type st_10 from w_standard_print`st_10 within w_cia30340
end type



type dw_print from w_standard_print`dw_print within w_cia30340
string dataobject = "dw_cia30340_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30340
integer x = 27
integer y = 12
integer width = 3557
integer height = 152
string dataobject = "dw_cia30340"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_cia30340
integer x = 55
integer y = 172
integer width = 4549
integer height = 2036
string dataobject = "dw_cia30340_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30340
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 168
integer width = 4576
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

