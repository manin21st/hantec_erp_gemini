$PBExportHeader$w_pu91_00350.srw
$PBExportComments$소모품 마스터 현황
forward
global type w_pu91_00350 from w_standard_print
end type
type rr_1 from roundrectangle within w_pu91_00350
end type
type rr_2 from roundrectangle within w_pu91_00350
end type
end forward

global type w_pu91_00350 from w_standard_print
string title = "소모품 마스터 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pu91_00350 w_pu91_00350

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long		ll_cnt
String	ls_ittyp

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_ittyp	= Trim(dw_ip.Object.ittyp[1])

If ls_ittyp = '5'  or ls_ittyp = '6' then
Else
	dw_ip.SetItem(1, "ittyp",'5')
	ls_ittyp = '5'
end If

String ls_itcls

ls_itcls = dw_ip.GetItemString(1, 'itcls')
If Trim(ls_itcls) = '' OR IsNull(ls_itcls) Then ls_itcls = '%'

if dw_list.Retrieve(ls_ittyp, ls_itcls) <= 0 then
	f_message_chk(50,'[소모품 마스터]')
	dw_ip.Setfocus()
	return -1
end if

Return 1
end function

on w_pu91_00350.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pu91_00350.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;//dw_ip.Object.date1[1] = left(f_today(),6)+'01'
//dw_ip.Object.date2[1] = f_today()
//
//string	sempname, sdept, sdeptname 
//
//select empname, deptcode, fun_get_dptno(deptcode) 
//  into :sempname, :sdept, :sdeptname 
//  from p1_master
// where empno = :gs_empno ;
//
//dw_ip.Object.cvcod2[1] = sdept
//dw_ip.Object.cvnas2[1] = sdeptname
//dw_ip.Object.empno[1] = gs_empno
//dw_ip.Object.empnm[1] = sempname
//
/////* User별 사업장 Setting Start */
////String saupj
////
////If f_check_saupj(saupj) = 1 Then
////	dw_ip.Modify("saupj.protect=1")
////End If
////dw_ip.SetItem(1, 'saupj', saupj)
/////* ---------------------- End  */
//f_mod_saupj(dw_ip, 'saupj')
end event

type p_xls from w_standard_print`p_xls within w_pu91_00350
integer y = 20
end type

type p_sort from w_standard_print`p_sort within w_pu91_00350
integer y = 20
end type

type p_preview from w_standard_print`p_preview within w_pu91_00350
end type

type p_exit from w_standard_print`p_exit within w_pu91_00350
end type

type p_print from w_standard_print`p_print within w_pu91_00350
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu91_00350
end type







type st_10 from w_standard_print`st_10 within w_pu91_00350
end type



type dw_print from w_standard_print`dw_print within w_pu91_00350
integer x = 3415
integer y = 152
integer height = 76
string dataobject = "d_pu91_00350_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pu91_00350
integer x = 59
integer y = 52
integer width = 2441
integer height = 128
string dataobject = "d_pu91_00350"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

String sname

str_itnct lstr_sitnct

Choose Case dwo.name
	Case 'itcls'
		sname = this.GetItemString(1, 'ittyp')
		OpenWithParm(w_ittyp_popup, sname)
		
		lstr_sitnct = Message.PowerObjectParm	
		
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
//		this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
		
		this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
		this.SetItem(1,"titnm", lstr_sitnct.s_titnm)
//		if ls_gub = 'Y' then 	this.SetItem(1, "itdsc", lstr_sitnct.s_titnm)
//		this.SetItem(1,"seqno", str_sitnct.l_seqno)
		this.SetColumn('itcls')
		this.SetFocus()
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_pu91_00350
integer x = 46
integer y = 252
integer width = 4562
integer height = 2012
string dataobject = "d_pu91_00350_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pu91_00350
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 2496
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu91_00350
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 4581
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

