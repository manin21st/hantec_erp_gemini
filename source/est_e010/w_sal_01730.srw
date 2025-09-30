$PBExportHeader$w_sal_01730.srw
$PBExportComments$견적서
forward
global type w_sal_01730 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01730
end type
end forward

global type w_sal_01730 from w_standard_print
string title = "견적서"
rr_1 rr_1
end type
global w_sal_01730 w_sal_01730

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_ofno, sSaupj, sGijun

if dw_ip.accepttext() <> 1 then return -1

ls_ofno = dw_ip.getitemstring(1,"ofno")
sSaupj  = dw_ip.getitemstring(1,"saupj")
sGijun  = dw_ip.getitemstring(1,"gijun")

If IsNull(sSaupj) Then
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

if ls_ofno="" or isnull(ls_ofno) then
	f_message_chk(30,'[견적번호]')
	dw_ip.SetColumn("ofno")
	dw_ip.SetFocus()
	Return -1
END IF

if dw_list.retrieve(gs_sabu, ls_ofno, sSaupj, sgijun)< 1 then 
	f_message_chk(50,'')
   dw_ip.setcolumn('ofno')
	dw_ip.SetFocus()
	return -1
else
	return 1
end if
end function

on w_sal_01730.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01730.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.object.gijun[1]='1'
end event

type p_preview from w_standard_print`p_preview within w_sal_01730
end type

type p_exit from w_standard_print`p_exit within w_sal_01730
end type

type p_print from w_standard_print`p_print within w_sal_01730
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01730
end type







type st_10 from w_standard_print`st_10 within w_sal_01730
end type



type dw_print from w_standard_print`dw_print within w_sal_01730
string dataobject = "d_sal_01730_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01730
integer x = 59
integer y = 24
integer width = 1911
integer height = 204
string dataobject = "d_sal_01730_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_gijun,ls_ofno
 
//if dw_ip.accepttext() <> 1 then return

ls_gijun = Trim(this.GetText())


if this.getcolumnName()="ofno" then
	ls_ofno= Trim(GetText())
	if ls_ofno="" or isnull(ls_ofno) then
		f_message_chk(30, "[견적번호]")
		dw_ip.setcolumn("ofno")
		return 1
	end if
end if


end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string ls_column

setnull(gs_code)
setnull(gs_codename)

if this.getcolumnName()="ofno" then
	gs_gubun = ' 1' 

	open(w_sal_01700_popup)
		
	this.setitem(1,"ofno",gs_code)
end if

end event

type dw_list from w_standard_print`dw_list within w_sal_01730
integer x = 73
integer y = 260
integer width = 3314
integer height = 2068
string dataobject = "d_sal_01730"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_01730
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 248
integer width = 3342
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

