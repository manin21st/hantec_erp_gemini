$PBExportHeader$w_sm90_0060.srw
$PBExportComments$차종정보 현황
forward
global type w_sm90_0060 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm90_0060
end type
end forward

global type w_sm90_0060 from w_standard_print
string title = "차종정보 현황"
boolean controlmenu = false
rr_2 rr_2
end type
global w_sm90_0060 w_sm90_0060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String ls_name ,ls_code , ls_itnbr ,ls_itdsc , ls_ittyp

dw_ip.AcceptText() 

ls_itnbr = Trim(dw_ip.Object.carname[1])
ls_ittyp = Trim(dw_ip.Object.ittyp[1])
ls_code  = Trim(dw_ip.Object.carcode[1])

If ls_code = '' or isNull(ls_code) Then ls_code = '%'
If ls_ittyp = '' or isNull(ls_ittyp) Then ls_ittyp = '%'
If ls_itnbr = '' or isNull(ls_itnbr) Then 
	ls_itnbr = '%'
ELSE
	ls_itnbr = ls_itnbr + '%'
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_code, ls_itnbr, ls_ittyp)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1

end function

on w_sm90_0060.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_sm90_0060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_xls from w_standard_print`p_xls within w_sm90_0060
boolean visible = true
integer x = 3922
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_sm90_0060
end type

type p_preview from w_standard_print`p_preview within w_sm90_0060
end type

type p_exit from w_standard_print`p_exit within w_sm90_0060
end type

type p_print from w_standard_print`p_print within w_sm90_0060
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm90_0060
integer x = 3749
end type







type st_10 from w_standard_print`st_10 within w_sm90_0060
end type



type dw_print from w_standard_print`dw_print within w_sm90_0060
integer x = 3602
integer y = 44
string dataobject = "d_sm90_0060_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm90_0060
integer x = 14
integer y = 36
integer width = 3575
integer height = 152
string dataobject = "d_sm90_0060_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_sm90_0060
integer x = 27
integer y = 216
integer width = 4549
integer height = 2032
string dataobject = "d_sm90_0060_2"
boolean hscrollbar = false
boolean border = false
end type

type rr_2 from roundrectangle within w_sm90_0060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 208
integer width = 4581
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

