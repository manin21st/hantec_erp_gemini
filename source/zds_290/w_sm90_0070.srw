$PBExportHeader$w_sm90_0070.srw
$PBExportComments$≥≥«∞√≥ ¿Á∞Ì«ˆ»≤
forward
global type w_sm90_0070 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm90_0070
end type
end forward

global type w_sm90_0070 from w_standard_print
string title = "≥≥«∞√≥ ∞Ë»π¿‹∑Æ «ˆ»≤"
boolean controlmenu = false
rr_2 rr_2
end type
global w_sm90_0070 w_sm90_0070

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_name ,ls_itnbr, ls_gbn

dw_ip.AcceptText() 

ls_name 	= Trim(dw_ip.Object.plant[1])
ls_itnbr = Trim(dw_ip.Object.itnbr[1])

If ls_name = '.' or ls_name = '' or isNull(ls_name) Then ls_name = '%'
If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = '%'

dw_list.Retrieve(ls_name, ls_itnbr)

Return 1

end function

on w_sm90_0070.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_sm90_0070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_xls from w_standard_print`p_xls within w_sm90_0070
boolean visible = true
integer x = 3922
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_sm90_0070
end type

type p_preview from w_standard_print`p_preview within w_sm90_0070
end type

type p_exit from w_standard_print`p_exit within w_sm90_0070
end type

type p_print from w_standard_print`p_print within w_sm90_0070
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm90_0070
integer x = 3749
end type







type st_10 from w_standard_print`st_10 within w_sm90_0070
end type



type dw_print from w_standard_print`dw_print within w_sm90_0070
string dataobject = "d_sm90_0070_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm90_0070
integer x = 14
integer y = 20
integer width = 3022
integer height = 164
string dataobject = "d_sm90_0070_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_sm90_0070
integer x = 27
integer y = 208
integer width = 4549
integer height = 2032
string dataobject = "d_sm90_0070_2"
boolean hscrollbar = false
boolean border = false
end type

type rr_2 from roundrectangle within w_sm90_0070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 200
integer width = 4581
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

