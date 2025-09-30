$PBExportHeader$w_pdm_11520.srw
$PBExportComments$** 거래처별 이력 현황
forward
global type w_pdm_11520 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11520
end type
end forward

global type w_pdm_11520 from w_standard_print
string title = "거래처별 이력 현황"
rr_1 rr_1
end type
global w_pdm_11520 w_pdm_11520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String scodef, scodet
		 
IF dw_ip.AcceptText() = -1 THEN RETURN -1

scodef =dw_ip.GetItemString(1,"scvcod")
scodet =dw_ip.GetItemString(1,"ecvcod")

IF scodef ="" OR IsNull(scodef) THEN
	scodef = '.'
END IF
IF scodet ="" OR IsNull(scodet) THEN
	scodet = 'zzzzzz'
END IF

if scodef > scodet then 
	f_message_chk(34,'[거래처코드]')
	dw_ip.Setcolumn('scvcod')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(scodef,scodet) <=0 THEN
	f_message_chk(50,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_pdm_11520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sort_gu","1")
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_pdm_11520
end type

type p_exit from w_standard_print`p_exit within w_pdm_11520
end type

type p_print from w_standard_print`p_print within w_pdm_11520
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11520
end type







type st_10 from w_standard_print`st_10 within w_pdm_11520
end type



type dw_print from w_standard_print`dw_print within w_pdm_11520
string dataobject = "d_pdm_11520_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11520
integer x = 27
integer width = 3433
integer height = 172
string dataobject = "d_pdm_11520_a"
end type

event dw_ip::itemchanged;String ssort_gu, scode, sname, sname2
Int ireturn

IF this.GetColumnName() = "scvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V0', 'N', scode, sname, sname2)
	dw_ip.SetItem(1,"scvcod",scode)
	dw_ip.SetItem(1,"snamef",sname)
   return ireturn 
ELSEIF this.GetColumnName() = "ecvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V0', 'N', scode, sname, sname2)
	dw_ip.SetItem(1,"ecvcod",scode)
	dw_ip.SetItem(1,"snamet",sname)
   return ireturn 
ELSEIF this.GetColumnName() = "sort_gu" THEN 
	
	ssort_gu = this.GetText()
	
	dw_list.SetRedraw(False)
	IF ssort_gu ="1" THEN
		dw_list.SetSort("vndmst_cvcod A")
	ELSE
		dw_list.SetSort("vndmst_cvnas2 A")
	END IF
	dw_list.Sort()
	dw_list.SetRedraw(True)
END IF
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <> "scvcod" AND this.GetColumnName() <> "ecvcod" THEN RETURN

gs_gubun =""

IF this.GetColumnName() ="scvcod" THEN
	gs_code =dw_ip.GetItemString(1,"scvcod")
ELSE
	gs_code =dw_ip.GetItemString(1,"ecvcod")
END IF

OPEN(W_VNDMST_POPUP)

IF this.GetColumnName() ="scvcod" THEN
	dw_ip.SetItem(1,"scvcod",gs_code)
	dw_ip.SetItem(1,"snamef",gs_codename)
ELSE
	dw_ip.SetItem(1,"ecvcod",gs_code)
	dw_ip.SetItem(1,"snamet",gs_codename)
END IF

dw_ip.SetFocus()


end event

event dw_ip::ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
Return 1
end event

type dw_list from w_standard_print`dw_list within w_pdm_11520
integer y = 208
integer width = 4553
integer height = 2108
string dataobject = "d_pdm_11520"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 200
integer width = 4581
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 55
end type

