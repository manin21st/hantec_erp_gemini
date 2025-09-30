$PBExportHeader$w_psd1240.srw
$PBExportComments$고과계산조정계수표
forward
global type w_psd1240 from w_standard_print
end type
type rr_1 from roundrectangle within w_psd1240
end type
type rr_2 from roundrectangle within w_psd1240
end type
end forward

global type w_psd1240 from w_standard_print
string title = "고과계산조정계수표"
rr_1 rr_1
rr_2 rr_2
end type
global w_psd1240 w_psd1240

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string is_ym//, is_saupcd

if dw_ip.accepttext() = -1 then return -1

is_ym = dw_ip.getitemstring(1,"ym")
is_saupcd = dw_ip.GetItemString(1,"saupcd")

if is_ym = "" or isnull(is_ym) then 
	messagebox('확인','고과년월을 입력하세요')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1
elseif f_datechk(is_ym + "01") = -1 then
	messagebox('확인','고과년월을 확인하세요')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1
end if

if is_saupcd = ""  or  isnull(is_saupcd) then
	is_saupcd = '%'
end if

if dw_list.retrieve(is_ym, is_saupcd) < 1 then 
	messagebox('확인','자료가 없습니다.')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1
end if

return 1
end function

on w_psd1240.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_psd1240.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

f_set_saupcd(dw_ip,'saupcd','1')
is_saupcd = gs_saupcd

dw_ip.setitem(1,"ym",left(f_today(),6))
dw_ip.setcolumn("ym")
dw_ip.setfocus()
end event

type p_xls from w_standard_print`p_xls within w_psd1240
end type

type p_sort from w_standard_print`p_sort within w_psd1240
end type

type p_preview from w_standard_print`p_preview within w_psd1240
end type

type p_exit from w_standard_print`p_exit within w_psd1240
end type

type p_print from w_standard_print`p_print within w_psd1240
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd1240
end type







type st_10 from w_standard_print`st_10 within w_psd1240
end type



type dw_print from w_standard_print`dw_print within w_psd1240
string dataobject = "d_psd1240_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_psd1240
integer x = 128
integer y = 32
integer width = 2203
integer height = 120
string dataobject = "d_psd1240_1"
end type

type dw_list from w_standard_print`dw_list within w_psd1240
integer x = 82
integer y = 276
integer width = 4457
integer height = 1952
string dataobject = "d_psd1240_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_psd1240
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 41
integer y = 16
integer width = 3502
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1240
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 252
integer width = 4517
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

