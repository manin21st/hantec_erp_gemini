$PBExportHeader$w_pdt_t_10240.srw
$PBExportComments$**부적합품 사용현황
forward
global type w_pdt_t_10240 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_t_10240
end type
end forward

global type w_pdt_t_10240 from w_standard_print
string title = "부적합 제품 사용현황"
rr_1 rr_1
end type
global w_pdt_t_10240 w_pdt_t_10240

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   ls_porgu, ls_depot, ls_fromDate, ls_toDate

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_porgu = dw_ip.GetItemString(1, 'porgu')

IF IsNull(ls_porgu) OR ls_porgu = "" THEN
   f_message_chk(30," [사업장] ")
	dw_ip.setcolumn('porgu')
	dw_ip.SetFocus()
	return -1
END IF

If ls_porgu = '10' Then
	ls_depot = 'Z01'
Else 
	ls_depot = 'Z13'
End If

ls_fromDate = dw_ip.GetItemString(1, 'from_date')

IF IsNull(ls_fromDate) OR ls_fromDate = "" THEN
   f_message_chk(30," [기준시작일] ")
	dw_ip.setcolumn('from-date')
	dw_ip.SetFocus()
	return -1
END IF

ls_toDate = dw_ip.GetItemString(1, 'to_date')

IF IsNull(ls_toDate) OR ls_toDate = "" THEN
   f_message_chk(30," [기준종료일] ")
	dw_ip.setcolumn('to_date')
	dw_ip.SetFocus()
	return -1
END IF

IF dw_print.Retrieve(gs_sabu, ls_fromDate, ls_toDate, ls_depot ) < 1 THEN
	f_message_chk(50," [부적합제품 사용현황] ")
	dw_ip.SetColumn('porgu')
	dw_ip.SetFocus()
	return -1
END IF

dw_print.Object.t_porgu.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(porgu) ', 1)"))

dw_print.ShareData(dw_list)
Return 1
end function

on w_pdt_t_10240.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_t_10240.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;//string  s_null
//SetNull(s_null)
//dw_ip.SetItem(1, 'depot_cod', s_null)

dw_ip.SetItem(1,'from_date',Left(f_today(),6) + '01')
dw_ip.SetItem(1,'to_date',f_today())
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10240
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10240
end type

type p_print from w_standard_print`p_print within w_pdt_t_10240
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10240
end type







type st_10 from w_standard_print`st_10 within w_pdt_t_10240
end type



type dw_print from w_standard_print`dw_print within w_pdt_t_10240
string dataobject = "d_pdt_t_10240_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10240
integer x = 0
integer y = 32
integer width = 3077
integer height = 160
string dataobject = "d_pdt_t_10240_h"
end type

event itemerror;return 1
end event

event dw_ip::rbuttondown;//str_itnct lstr_sitnct
//string sIttyp
//
//IF	this.GetColumnName() = "itcls_cod1"	THEN		
//	sIttyp = this.GetItemString(1, 'ittyp_cod')
//	OpenWithParm(w_ittyp_popup, sIttyp)
//   lstr_sitnct = Message.PowerObjectParm	
//	
//	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
//	
//	this.SetItem(1,"itcls_cod1", lstr_sitnct.s_sumgub)
//ELSEIF this.GetColumnName() = "itcls_cod2" THEN		
//	sIttyp = this.GetItemString(1, 'ittyp_cod')
//	OpenWithParm(w_ittyp_popup, sIttyp)
//   lstr_sitnct = Message.PowerObjectParm	
//	
//	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
//	
//	this.SetItem(1,"itcls_cod2", lstr_sitnct.s_sumgub)
//END IF
//

end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10240
integer x = 50
integer y = 228
integer width = 4553
integer height = 2080
string dataobject = "d_pdt_t_10240_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_t_10240
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

