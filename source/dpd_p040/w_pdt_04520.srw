$PBExportHeader$w_pdt_04520.srw
$PBExportComments$**재고현황(출력)
forward
global type w_pdt_04520 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_04520
end type
end forward

global type w_pdt_04520 from w_standard_print
string title = "재고 현황"
rr_1 rr_1
end type
global w_pdt_04520 w_pdt_04520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_depot, s_ittyp, s_itcls_cod1, s_itcls_cod2, s_null, s_temp 

SetNull(s_null)
IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_depot = dw_ip.GetItemString(1, 'depot_cod')
IF IsNull(s_depot) OR s_depot = "" THEN
   f_message_chk(30,"[창고]")
	dw_ip.setcolumn('depot_cod')
	dw_ip.SetFocus()
	return -1
END IF

s_ittyp      = dw_ip.GetItemString(1, 'ittyp_cod')
IF IsNull(s_ittyp) OR s_ittyp = "" THEN s_ittyp = '%'

s_itcls_cod1 = dw_ip.GetItemString(1, 'itcls_cod1')
s_itcls_cod2 = dw_ip.GetItemString(1, 'itcls_cod2')

IF (IsNull(s_itcls_cod1) OR s_itcls_cod1 = "" ) THEN s_itcls_cod1 = "."
IF (IsNull(s_itcls_cod2) OR s_itcls_cod2 = "" ) THEN s_itcls_cod2 = "zzzzzzz"

IF dw_print.Retrieve(s_depot, s_ittyp, s_itcls_cod1, s_itcls_cod2 ) < 1 THEN
	f_message_chk(50,"")
	dw_ip.SetColumn('depot_cod')
	dw_ip.SetFocus()
	return -1
END IF

   dw_print.ShareData(dw_list)
Return 1
end function

on w_pdt_04520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_04520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string  s_null

SetNull(s_null)
dw_ip.SetItem(1, 'depot_cod', s_null)
dw_ip.SetItem(1, 'ittyp_cod', s_null)
end event

type p_preview from w_standard_print`p_preview within w_pdt_04520
end type

type p_exit from w_standard_print`p_exit within w_pdt_04520
end type

type p_print from w_standard_print`p_print within w_pdt_04520
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_04520
end type







type st_10 from w_standard_print`st_10 within w_pdt_04520
end type



type dw_print from w_standard_print`dw_print within w_pdt_04520
string dataobject = "d_pdt_04523_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_04520
integer x = 73
integer y = 32
integer width = 3077
integer height = 160
string dataobject = "d_pdt_04520"
end type

event itemerror;return 1
end event

event dw_ip::rbuttondown;str_itnct lstr_sitnct
string sIttyp

IF	this.GetColumnName() = "itcls_cod1"	THEN		
	sIttyp = this.GetItemString(1, 'ittyp_cod')
	OpenWithParm(w_ittyp_popup, sIttyp)
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls_cod1", lstr_sitnct.s_sumgub)
ELSEIF this.GetColumnName() = "itcls_cod2" THEN		
	sIttyp = this.GetItemString(1, 'ittyp_cod')
	OpenWithParm(w_ittyp_popup, sIttyp)
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls_cod2", lstr_sitnct.s_sumgub)
END IF


end event

type dw_list from w_standard_print`dw_list within w_pdt_04520
integer x = 50
integer y = 228
integer width = 4553
integer height = 2080
string dataobject = "d_pdt_04523"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_04520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 220
integer width = 4590
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

