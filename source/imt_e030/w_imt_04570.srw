$PBExportHeader$w_imt_04570.srw
$PBExportComments$매입구분별 매입금액 현황(출력)
forward
global type w_imt_04570 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04570
end type
end forward

global type w_imt_04570 from w_standard_print
integer height = 2396
string title = "매입구분별 매입금액 현황"
rr_1 rr_1
end type
global w_imt_04570 w_imt_04570

type variables
boolean  b_msg = FALSE
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_stdy, swaigu , s_saupj
Int      iRtn1, iRtn2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_saupj  =  dw_ip.GetItemString(1, "saupj")
s_stdy   = TRIM(dw_ip.GetItemString(1,"stdy"))
swaigu   = TRIM(dw_ip.GetItemString(1,"maip"))

IF (IsNull(s_stdy) OR s_stdy = "") THEN
   f_message_chk(30, "[기준년도]")
	dw_ip.SetColumn('stdy')
	dw_ip.SetFocus()
	return -1
END IF

if (IsNull(s_saupj) or s_saupj = "" ) then
	f_message_chk(30, "[사업장]") 
	dw_ip.SetColumn('saupj')
	dw_ip.Setfocus()
	return -1
end if

dw_print.ShareDataOff()
iRtn1 = dw_list.Retrieve(gs_sabu, s_stdy, swaigu , s_saupj )
iRtn2 = dw_print.Retrieve(gs_sabu, s_stdy, swaigu , s_saupj )

IF iRtn1 < 1 or iRtn2 < 1 THEN
	f_message_chk(50,"[매입구분별 매입금액 현황]")
	dw_ip.SetFocus()
	return -1
END IF

Return 1
end function

on w_imt_04570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string  s_stdy

s_stdy = Mid(f_today(),1,4)

//초기화
dw_ip.SetItem(1, "stdy", s_stdy)		

f_mod_saupj(dw_ip,'saupj')
end event

type p_preview from w_standard_print`p_preview within w_imt_04570
end type

type p_exit from w_standard_print`p_exit within w_imt_04570
end type

type p_print from w_standard_print`p_print within w_imt_04570
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04570
end type







type st_10 from w_standard_print`st_10 within w_imt_04570
end type



type dw_print from w_standard_print`dw_print within w_imt_04570
string dataobject = "d_imt_04571_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04570
integer y = 24
integer width = 2738
integer height = 156
string dataobject = "d_imt_04570"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//string snull, s_col, s_cod, s_nam
//
//SetNull(snull)
//
//s_col = this.GetColumnName()
//
//if s_col = 'stdy' then
//	s_cod = Trim(this.GetText())
//	if IsNull(s_cod) or s_cod = "" then
//		f_message_chk(40,"매입구분별 매입금액 현황")
//		b_msg = TRUE
//	   this.SetColumn('stdy')
//	   this.SetFocus()
//	end if
//end if
//
end event

type dw_list from w_standard_print`dw_list within w_imt_04570
integer x = 64
integer y = 212
integer width = 4521
integer height = 2076
string dataobject = "d_imt_04571"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_04570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 200
integer width = 4544
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

