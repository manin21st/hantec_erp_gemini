$PBExportHeader$w_psd1200.srw
$PBExportComments$최종고과가감점등록
forward
global type w_psd1200 from w_inherite_standard
end type
type dw_detail from datawindow within w_psd1200
end type
type dw_list from datawindow within w_psd1200
end type
type rr_1 from roundrectangle within w_psd1200
end type
type rr_2 from roundrectangle within w_psd1200
end type
end forward

global type w_psd1200 from w_inherite_standard
integer height = 3208
string title = "최종고과 가감점 등록"
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_psd1200 w_psd1200

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);string ls_mainpoint, ls_pmpoint, snull

SetNull(snull)

if dw_list.accepttext() = -1 then return -1
	
ls_mainpoint = dw_list.GetItemString(icurrow,'p6_meritfinal_mrpoint')
ls_pmpoint = dw_list.GetItemString(icurrow,'p6_meritfinal_aspoint')
	
	if ls_mainpoint = ''  or IsNull(ls_mainpoint) then
		messagebox("확인","고과점수를 입력하세요.")
		dw_list.SetColumn('p6_meritfinal_mrpoint')
		dw_list.SetFocus()
		return -1
	end if
	
	if ls_pmpoint = ''  or  IsNull(ls_pmpoint) then
		messagebox("확인","가감점수를 입력하세요.")
		dw_list.SetColumn('p6_meritfinal_aspoint')
		dw_list.SetFocus()
		return -1
	end if

return 1
end function

on w_psd1200.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_psd1200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_detail.insertrow(0)
dw_detail.setitem(1,"yymm",left(f_today(),6))

f_set_saupcd(dw_detail, 'saupcd', '1')
is_saupcd = gs_saupcd
end event

type p_mod from w_inherite_standard`p_mod within w_psd1200
integer x = 4050
integer y = 28
end type

event p_mod::clicked;call super::clicked;long i, jumsu

if messagebox('확인','저장하시겠습니까?', question!, yesno!) = 1 then

	setpointer(hourglass!)
	
	for i = 1 to dw_list.rowcount() 
		jumsu = dw_list.getitemdecimal(i,"p6_meritfinal_aspoint")
		
		if isnull(jumsu) then jumsu = 0

	next
	
	if dw_list.update() = 1 then
		commit;
	else
		rollback;
	end if
	
end if

setpointer(arrow!)
cb_retrieve.triggerevent(clicked!)

w_mdi_frame.sle_msg.text = "저장되었습니다"
end event

type p_del from w_inherite_standard`p_del within w_psd1200
integer x = 133
integer y = 2444
end type

type p_inq from w_inherite_standard`p_inq within w_psd1200
integer x = 3872
integer y = 28
end type

event p_inq::clicked;call super::clicked;string is_dept, is_ym, saupcd

dw_detail.accepttext()

is_dept = dw_detail.getitemstring(1,"deptcode")
is_ym = dw_detail.getitemstring(1,"yymm")
saupcd = dw_detail.GetItemString(1,'saupcd')



if is_dept = "" or isnull(is_dept) then is_dept = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if is_ym = "" or isnull(is_ym) then 
	messagebox('확인','고과실시년월을 확인하세요')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
elseif f_datechk(is_ym + "01")  = -1 then
	messagebox('확인','고과실시년월을 확인하세요')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
end if


if dw_list.retrieve(is_dept, is_ym, saupcd) < 1 then
	messagebox('확인','자료가 없습니다')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
end if

return 1



end event

type p_print from w_inherite_standard`p_print within w_psd1200
integer x = 517
integer y = 2676
end type

type p_can from w_inherite_standard`p_can within w_psd1200
integer x = 4224
integer y = 28
end type

event p_can::clicked;call super::clicked;dw_detail.reset()
dw_list.reset()

dw_detail.insertrow(0)
dw_detail.setitem(1,"yymm",left(f_today(),6))
end event

type p_exit from w_inherite_standard`p_exit within w_psd1200
integer x = 4398
integer y = 28
end type

type p_ins from w_inherite_standard`p_ins within w_psd1200
integer x = 50
integer y = 2436
end type

type p_search from w_inherite_standard`p_search within w_psd1200
integer x = 338
integer y = 2676
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1200
integer x = 1038
integer y = 2676
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1200
integer x = 1211
integer y = 2676
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1200
integer x = 46
integer y = 2700
end type

type st_window from w_inherite_standard`st_window within w_psd1200
integer x = 1691
integer y = 2488
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1200
integer x = 1902
integer y = 2844
end type

type cb_update from w_inherite_standard`cb_update within w_psd1200
integer x = 3973
end type

event cb_update::clicked;call super::clicked;long i, jumsu

if messagebox('확인','저장하시겠습니까?', question!, yesno!) = 1 then

	setpointer(hourglass!)
	
	for i = 1 to dw_list.rowcount() 
		jumsu = dw_list.getitemdecimal(i,"p6_meritfinal_aspoint")
		
		if isnull(jumsu) then jumsu = 0

	next
	
	if dw_list.update() = 1 then
		commit;
	else
		rollback;
	end if
	
end if

setpointer(arrow!)
cb_retrieve.triggerevent(clicked!)

sle_msg.text = "저장되었습니다"
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1200
integer x = 914
integer y = 2540
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1200
integer x = 2286
integer y = 2676
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1200
integer x = 1326
integer y = 2880
end type

event cb_retrieve::clicked;call super::clicked;string is_dept, is_ym, saupcd

dw_detail.accepttext()

is_dept = dw_detail.getitemstring(1,"deptcode")
is_ym = dw_detail.getitemstring(1,"yymm")
saupcd = dw_detail.GetItemString(1,'saupcd')



if is_dept = "" or isnull(is_dept) then is_dept = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if is_ym = "" or isnull(is_ym) then 
	messagebox('확인','고과실시년월을 확인하세요')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
elseif f_datechk(is_ym + "01")  = -1 then
	messagebox('확인','고과실시년월을 확인하세요')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
end if


if dw_list.retrieve(is_dept, is_ym, saupcd) < 1 then
	messagebox('확인','자료가 없습니다')
	dw_detail.setcolumn("yymm")
	dw_detail.setfocus()
	return -1
end if

return 1



end event

type st_1 from w_inherite_standard`st_1 within w_psd1200
integer x = 265
integer y = 2488
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1200
integer x = 1719
integer y = 2856
end type

event cb_cancel::clicked;call super::clicked;dw_detail.reset()
dw_list.reset()

dw_detail.insertrow(0)
dw_detail.setitem(1,"yymm",left(f_today(),6))
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1200
integer x = 2487
integer y = 2476
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1200
integer x = 677
integer y = 2488
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1200
integer x = 2501
integer y = 2444
integer width = 1166
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1200
integer x = 407
integer y = 2452
integer width = 416
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1200
integer x = 3721
integer y = 2444
long backcolor = 80269524
end type

type dw_detail from datawindow within w_psd1200
integer x = 82
integer y = 68
integer width = 3026
integer height = 188
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1200_dept"
boolean border = false
boolean livescroll = true
end type

type dw_list from datawindow within w_psd1200
integer x = 82
integer y = 360
integer width = 3241
integer height = 1460
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1200_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;this.setrowfocusindicator(hand!)
end event

type rr_1 from roundrectangle within w_psd1200
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 41
integer y = 16
integer width = 3310
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1200
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 4553
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

