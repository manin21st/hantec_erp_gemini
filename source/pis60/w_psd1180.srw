$PBExportHeader$w_psd1180.srw
$PBExportComments$고과계산
forward
global type w_psd1180 from w_inherite_standard
end type
type dw_1 from datawindow within w_psd1180
end type
type rr_1 from roundrectangle within w_psd1180
end type
end forward

global type w_psd1180 from w_inherite_standard
integer height = 2492
string title = "고과계산"
dw_1 dw_1
rr_1 rr_1
end type
global w_psd1180 w_psd1180

on w_psd1180.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_psd1180.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1,"yymm", left(f_today(),6))
dw_1.setcolumn("yymm")
dw_1.setfocus()
end event

type p_mod from w_inherite_standard`p_mod within w_psd1180
integer x = 4210
integer taborder = 110
end type

event p_mod::clicked;call super::clicked;string is_ym 
long is_cnt,is_cnt_final, is_funmerit, is_funmerit_2, is_cnt_null, is_funmerit_3

dw_1.accepttext()

is_ym = dw_1.getitemstring(1,"yymm")

if is_ym = "" or isnull(is_ym) then
	messagebox('확인','고과실시년월을 입력하세요')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
elseif f_datechk(is_ym + "01") = -1 then
	messagebox('확인','고과실시년월을 확인하세요')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
end if

select count(*) into :is_cnt
from p6_meritgrade
where mryymm = :is_ym ;

if is_cnt = 0 or isnull(is_cnt) then
	messagebox('확인','고과실시년월에 해당하는 자료가 없습니다')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
end if


//select  count(*) into :is_cnt_null
//from p6_meritgrade
//where p6_meritgrade.empno like '%' and
//		p6_meritgrade.mryymm = :is_ym  and
//		(p6_meritgrade.grade1 is null or
//		p6_meritgrade.grade2 is null );
//		
//if not (is_cnt_null = 0 or isnull(is_cnt_null)) then
//	messagebox('확인','1,2차의 고과점수가 등록되어있는지 확인하세요.')
//	return -1
//end if
//

select count(*) into :is_cnt_final
from p6_meritfinal
where mryymm = :is_ym ;

if not (is_cnt_final = 0 or isnull(is_cnt_final)) then 
	if messagebox('확인','고과년월에 해당하는 자료가 있습니다. ~r~n 다시계산하시겠습니까?', question!, yesno! ) = 2 then
		return -1
	end if
end if
	
	setpointer(hourglass!)
	
//	is_funmerit = SQLCA.FUN_MERITRATING(is_ym);
	
	if is_funmerit = -1 then
		messagebox('확인','고과계산에 실패하였습니다.')
		rollback ;
		setpointer(arrow!)
		return -1
	else
		
		commit ;
		
	end if
	

	
w_mdi_frame.sle_msg.text = "고과계산에 성공하였습니다"
	
setpointer(arrow!)	
		


end event

type p_del from w_inherite_standard`p_del within w_psd1180
integer x = 4128
integer y = 2548
integer taborder = 130
boolean enabled = false
end type

type p_inq from w_inherite_standard`p_inq within w_psd1180
integer x = 3259
integer y = 2548
boolean enabled = false
end type

type p_print from w_inherite_standard`p_print within w_psd1180
integer x = 3086
integer y = 2548
integer taborder = 190
end type

type p_can from w_inherite_standard`p_can within w_psd1180
integer x = 3963
integer y = 2568
integer taborder = 150
boolean enabled = false
end type

type p_exit from w_inherite_standard`p_exit within w_psd1180
integer taborder = 170
end type

type p_ins from w_inherite_standard`p_ins within w_psd1180
integer x = 3433
integer y = 2548
integer taborder = 50
boolean enabled = false
end type

type p_search from w_inherite_standard`p_search within w_psd1180
integer x = 2907
integer y = 2548
integer taborder = 180
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1180
integer x = 3607
integer y = 2548
integer taborder = 70
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1180
integer x = 3781
integer y = 2548
integer taborder = 90
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1180
integer x = 1824
integer y = 2564
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_psd1180
integer x = 2190
integer y = 2372
integer width = 617
integer taborder = 160
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1180
integer x = 3346
integer y = 2716
integer taborder = 140
end type

type cb_update from w_inherite_standard`cb_update within w_psd1180
integer x = 2226
integer y = 2664
integer width = 357
integer taborder = 60
string text = "처리(&P)"
end type

event cb_update::clicked;call super::clicked;string is_ym 
long is_cnt,is_cnt_final, is_funmerit, is_funmerit_2, is_cnt_null, is_funmerit_3

dw_1.accepttext()

is_ym = dw_1.getitemstring(1,"yymm")

if is_ym = "" or isnull(is_ym) then
	messagebox('확인','고과실시년월을 입력하세요')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
elseif f_datechk(is_ym + "01") = -1 then
	messagebox('확인','고과실시년월을 확인하세요')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
end if

select count(*) into :is_cnt
from p6_meritgrade
where mryymm = :is_ym ;

if is_cnt = 0 or isnull(is_cnt) then
	messagebox('확인','고과실시년월에 해당하는 자료가 없습니다')
	dw_1.setcolumn("yymm")
	dw_1.setfocus()
	return -1
end if


//select  count(*) into :is_cnt_null
//from p6_meritgrade
//where p6_meritgrade.empno like '%' and
//		p6_meritgrade.mryymm = :is_ym  and
//		(p6_meritgrade.grade1 is null or
//		p6_meritgrade.grade2 is null );
//		
//if not (is_cnt_null = 0 or isnull(is_cnt_null)) then
//	messagebox('확인','1,2차의 고과점수가 등록되어있는지 확인하세요.')
//	return -1
//end if
//

select count(*) into :is_cnt_final
from p6_meritfinal
where mryymm = :is_ym ;

if not (is_cnt_final = 0 or isnull(is_cnt_final)) then 
	if messagebox('확인','고과년월에 해당하는 자료가 있습니다. ~r~n 다시계산하시겠습니까?', question!, yesno! ) = 2 then
		return -1
	end if
end if
	
	setpointer(hourglass!)
	
//	is_funmerit = SQLCA.FUN_MERITRATING(is_ym);
	
	if is_funmerit = -1 then
		messagebox('확인','고과계산에 실패하였습니다.')
		rollback ;
		setpointer(arrow!)
		return -1
	else
		
		commit ;
		
	end if
	

	
sle_msg.text = "고과계산에 성공하였습니다"
	
setpointer(arrow!)	
		


end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1180
integer x = 544
integer y = 2660
integer taborder = 30
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1180
integer x = 955
integer y = 2660
integer taborder = 80
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1180
integer x = 178
integer y = 2660
integer taborder = 120
end type

type st_1 from w_inherite_standard`st_1 within w_psd1180
integer x = 14
integer y = 2372
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1180
integer x = 1321
integer y = 2660
integer taborder = 100
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1180
integer x = 2811
integer y = 2360
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1180
integer x = 425
integer y = 2372
integer width = 1810
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1180
integer x = 2309
integer y = 2384
integer width = 841
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1180
integer x = 142
integer y = 2600
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1180
integer x = 3470
integer y = 2328
integer width = 3547
long backcolor = 80269524
end type

type dw_1 from datawindow within w_psd1180
integer x = 1522
integer y = 896
integer width = 1179
integer height = 148
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1180"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_psd1180
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1234
integer y = 816
integer width = 2135
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

