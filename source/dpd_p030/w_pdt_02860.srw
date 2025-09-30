$PBExportHeader$w_pdt_02860.srw
$PBExportComments$** 년간 비가동 분석 현황
forward
global type w_pdt_02860 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02860
end type
end forward

global type w_pdt_02860 from w_standard_print
string title = "년간 비가동 분석 현황"
rr_1 rr_1
end type
global w_pdt_02860 w_pdt_02860

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_frTeam,s_toteam, s_year

dw_ip.AcceptText()
s_year = dw_ip.GetItemString(1,"syear")

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

IF s_year = "" OR IsNull(s_year) THEN
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("syear")
	dw_ip.SetFocus()
	Return -1
END IF
IF s_frteam = "" OR IsNull(s_frteam) THEN 
	s_frteam = '.'
END IF
IF s_toteam = "" OR IsNull(s_toteam) THEN 
	s_toteam = 'zzzzzz'
END IF

if s_frteam > s_toteam then 
	f_message_chk(34,'[생산팀]')
	dw_ip.Setcolumn('fr_team')
	dw_ip.SetFocus()
	return -1
end if	

String ls_jocod

ls_jocod = dw_ip.GetItemString(1, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then ls_jocod = '%'

IF dw_print.Retrieve(gs_sabu,s_year,s_frteam,s_toteam, ls_jocod) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

   dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_02860.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02860.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'syear', LEFT(f_today(),4))

dw_ip.SetColumn("syear")
dw_ip.Setfocus()


end event

type p_xls from w_standard_print`p_xls within w_pdt_02860
integer x = 3369
end type

type p_sort from w_standard_print`p_sort within w_pdt_02860
integer x = 3191
end type

type p_preview from w_standard_print`p_preview within w_pdt_02860
integer x = 4050
end type

type p_exit from w_standard_print`p_exit within w_pdt_02860
integer x = 4398
end type

type p_print from w_standard_print`p_print within w_pdt_02860
integer x = 4224
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02860
integer x = 3877
end type











type dw_print from w_standard_print`dw_print within w_pdt_02860
integer x = 3685
string dataobject = "d_pdt_02860_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02860
integer x = 37
integer y = 32
integer width = 1550
integer height = 160
string dataobject = "d_pdt_02860_a"
end type

type dw_list from w_standard_print`dw_list within w_pdt_02860
integer x = 46
integer y = 220
integer width = 4521
integer height = 2008
string dataobject = "d_pdt_02860_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_02860
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4549
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

