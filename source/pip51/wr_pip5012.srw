$PBExportHeader$wr_pip5012.srw
$PBExportComments$** 개인별 세액 명세서
forward
global type wr_pip5012 from w_standard_print
end type
type rr_2 from roundrectangle within wr_pip5012
end type
end forward

global type wr_pip5012 from w_standard_print
integer x = 0
integer y = 0
string title = "개인별 세액 명세서"
rr_2 rr_2
end type
global wr_pip5012 wr_pip5012

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_year, sSaup, sKunmu, ls_tag

setpointer(hourglass!)

if dw_ip.Accepttext() = -1 then return -1

ls_year = dw_ip.GetitemString(1,'syear')
sSaup = trim(dw_ip.GetItemString(1,"saup"))
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
ls_tag = trim(dw_ip.GetitemString(1,'stag'))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF ls_tag = '' OR IsNull(ls_tag) THEN ls_tag = '%'

if isnull(ls_year) or ls_year = '' then
	messagebox("기준일자(FROM)", "기준 일자가 부정확합니다.!", information!)
	dw_ip.setfocus()
	return -1
end if

if dw_print.retrieve(gs_company, ls_year, sSaup, sKunmu, ls_tag) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.setfocus()
	return -1
end if
   dw_print.sharedata(dw_list)

setpointer(arrow!)

return 1
end function

on wr_pip5012.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wr_pip5012.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.insertrow(0)
dw_ip.Setitem(1,'syear', left(f_today(),6))

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd





end event

type p_preview from w_standard_print`p_preview within wr_pip5012
end type

type p_exit from w_standard_print`p_exit within wr_pip5012
end type

type p_print from w_standard_print`p_print within wr_pip5012
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pip5012
end type

type st_window from w_standard_print`st_window within wr_pip5012
integer x = 1842
integer y = 3168
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5012
boolean visible = false
integer y = 3176
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5012
boolean visible = false
integer y = 3176
end type

type st_10 from w_standard_print`st_10 within wr_pip5012
boolean visible = false
integer y = 3176
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5012
boolean visible = false
integer y = 3124
end type

type dw_print from w_standard_print`dw_print within wr_pip5012
string dataobject = "d_pip5012_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5012
integer x = 46
integer y = 12
integer width = 3447
integer height = 180
string dataobject = "d_pip5012_1"
end type

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF
end event

type dw_list from w_standard_print`dw_list within wr_pip5012
integer x = 55
integer y = 212
integer width = 4544
integer height = 2112
integer taborder = 20
string dataobject = "d_pip5012"
boolean border = false
end type

type rr_2 from roundrectangle within wr_pip5012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 204
integer width = 4576
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 46
end type

