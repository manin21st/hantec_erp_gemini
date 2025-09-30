$PBExportHeader$w_pdt_t_10040.srw
$PBExportComments$품목별 출하검사 불량현황
forward
global type w_pdt_t_10040 from w_standard_print
end type
type rr_2 from roundrectangle within w_pdt_t_10040
end type
type rr_3 from roundrectangle within w_pdt_t_10040
end type
end forward

global type w_pdt_t_10040 from w_standard_print
string title = "품목별 출하검사 불량현황"
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_t_10040 w_pdt_t_10040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_yymm, ls_sman, ls_eman, sfilter, ls_saupj

if dw_ip.AcceptText() = -1 then return -1

ls_yymm = trim(dw_ip.GetItemString(1, 'yymm'))
ls_sman = dw_ip.GetItemString(1, 'fr_man')
ls_eman = dw_ip.GetItemString(1, 'to_man')

ls_saupj = dw_ip.GetItemString(1, 'saupj')

if IsNull(ls_sman) or ls_sman = "" then ls_sman = '.'
if IsNull(ls_eman) or ls_eman = "" then ls_eman = 'zzzzzz'

if IsNull(ls_saupj) or ls_saupj = "" then ls_saupj = '%'

if ls_sman > ls_eman then
   f_message_chk(34, '[검사담당자]')
   dw_ip.setcolumn('fr_man')
   dw_ip.Setfocus()
	return -1
end if

dw_list.setredraw(false)

IF dw_print.Retrieve(gs_sabu,ls_saupj, ls_yymm, ls_sman, ls_eman) <= 0 then
	f_message_chk(50,'[품목별 출하검사 불량현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

//sfilter = ''
//dw_print.SetFilter(sfilter)
//dw_print.Filter( )
//
//if rb_1.checked then
//	sfilter = "decision_yn = 'Y'"
//	dw_print.SetFilter(sfilter)
//	dw_print.Filter( )	
//elseif rb_2.checked then
//	sfilter = "decision_yn = 'N'"
//	dw_print.SetFilter(sfilter)
//	dw_print.Filter( )		
//end if

dw_print.ShareData(dw_list)

dw_list.setredraw(True)

return 1

end function

on w_pdt_t_10040.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
end on

on w_pdt_t_10040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')

dw_ip.setitem(1, 'yymm', left(f_today(), 6))
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10040
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10040
end type

type p_print from w_standard_print`p_print within w_pdt_t_10040
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10040
end type







type st_10 from w_standard_print`st_10 within w_pdt_t_10040
end type



type dw_print from w_standard_print`dw_print within w_pdt_t_10040
string dataobject = "d_pdt_t_10040_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10040
integer x = 82
integer y = 56
integer width = 3749
integer height = 100
string dataobject = "d_pdt_t_10040_h"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string s_colname, snull, s_code

s_colname = this.GetColumnName()
if (s_colname = "fr_date") then 
	s_code = Trim(GetTEXT())
   if IsNUll(s_code) or s_code = "" then return 
   if f_datechk(s_code) = -1 then //날짜체크
	   f_message_chk(35,"[검사일자]")
	   this.SetItem(1, s_colname, snull)
	   return 1
   end if
ELSEif (s_colname = "to_date") then
	s_code = Trim(GetTEXT())
   if IsNUll(s_code) or s_code = "" then return 
   if f_datechk(s_code) = -1 then //날짜체크
	   f_message_chk(35,"[검사일자]")
	   this.SetItem(1, s_colname, snull)
	   return 1
   end if
end if	

end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10040
integer x = 59
integer y = 204
integer width = 4539
integer height = 2108
string dataobject = "d_pdt_t_10040_d"
boolean border = false
end type

type rr_2 from roundrectangle within w_pdt_t_10040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 36
integer width = 3785
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_t_10040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 192
integer width = 4571
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

