$PBExportHeader$w_psd1120.srw
$PBExportComments$직급별1,2차가중치등록
forward
global type w_psd1120 from w_inherite_standard
end type
type dw_1 from datawindow within w_psd1120
end type
type rr_2 from roundrectangle within w_psd1120
end type
end forward

global type w_psd1120 from w_inherite_standard
integer height = 2468
string title = "직급별 1,2차 가중치 등록"
dw_1 dw_1
rr_2 rr_2
end type
global w_psd1120 w_psd1120

on w_psd1120.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_psd1120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

dw_1.scrolltorow(dw_1.rowcount())
dw_1.setcolumn("levelcode")
dw_1.setfocus()


if dw_1.retrieve() <= 0 then 
	messagebox('확인','자료가 없습니다')
	dw_1.setfocus()
	return -1
end if
end event

type p_mod from w_inherite_standard`p_mod within w_psd1120
integer x = 4037
end type

event p_mod::clicked;call super::clicked;ib_any_typing = false

long is_weight1, is_weight2, is_cnt, i
string is_levelcd

if messagebox('확인','저장하시겠습니까?',question!, yesno!) = 1 then
	
setpointer(hourglass!)

for i = 1 to dw_1.rowcount()
	
	is_levelcd = dw_1.getitemstring(i,"levelcode")
	is_weight1 = dw_1.getitemdecimal(i,"weight1")
	is_weight2 = dw_1.getitemdecimal(i,"weight2")
	
	select count(*) into :is_cnt
	from 	p6_meritweight
	where	levelcode = :is_levelcd ;
	
	if is_cnt = 0 or isnull(is_cnt) then
		
		insert into p6_meritweight (levelcode, weight1, weight2, weight3 )
		values (:is_levelcd, :is_weight1, :is_weight2, 0 ) ;
	
	else
		
		update p6_meritweight set	weight1 = :is_weight1, weight2 = :is_weight2
		where	levelcode = :is_levelcd	;
	
	end if

next

commit ;

setpointer(arrow!)

end if

cb_cancel.triggerevent(clicked!)

w_mdi_frame.sle_msg.text = "저장되었습니다"
end event

type p_del from w_inherite_standard`p_del within w_psd1120
integer x = 2839
integer y = 2576
end type

type p_inq from w_inherite_standard`p_inq within w_psd1120
integer x = 3557
integer y = 2504
boolean enabled = false
end type

type p_print from w_inherite_standard`p_print within w_psd1120
integer x = 2688
integer y = 2884
end type

type p_can from w_inherite_standard`p_can within w_psd1120
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setcolumn("levelcode")
dw_1.setfocus()
end event

type p_exit from w_inherite_standard`p_exit within w_psd1120
end type

type p_ins from w_inherite_standard`p_ins within w_psd1120
integer x = 1911
integer y = 2596
boolean enabled = false
end type

type p_search from w_inherite_standard`p_search within w_psd1120
integer x = 2510
integer y = 2884
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1120
integer x = 3209
integer y = 2884
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1120
integer x = 3383
integer y = 2884
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1120
integer x = 1454
integer y = 2840
end type

type st_window from w_inherite_standard`st_window within w_psd1120
integer x = 1504
integer y = 2704
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1120
integer x = 2747
integer y = 2948
end type

type cb_update from w_inherite_standard`cb_update within w_psd1120
integer x = 1952
integer y = 2916
end type

event cb_update::clicked;call super::clicked;ib_any_typing = false

long is_weight1, is_weight2, is_cnt, i
string is_levelcd

if messagebox('확인','저장하시겠습니까?',question!, yesno!) = 1 then
	
setpointer(hourglass!)

for i = 1 to dw_1.rowcount()
	
	is_levelcd = dw_1.getitemstring(i,"levelcode")
	is_weight1 = dw_1.getitemdecimal(i,"weight1")
	is_weight2 = dw_1.getitemdecimal(i,"weight2")
	
	select count(*) into :is_cnt
	from 	p6_meritweight
	where	levelcode = :is_levelcd ;
	
	if is_cnt = 0 or isnull(is_cnt) then
		
		insert into p6_meritweight (levelcode, weight1, weight2, weight3 )
		values (:is_levelcd, :is_weight1, :is_weight2, 0 ) ;
	
	else
		
		update p6_meritweight set	weight1 = :is_weight1, weight2 = :is_weight2
		where	levelcode = :is_levelcd	;
	
	end if

next

commit ;

setpointer(arrow!)

end if

cb_cancel.triggerevent(clicked!)

sle_msg.text = "저장되었습니다"
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1120
integer x = 690
integer y = 2956
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1120
integer x = 1134
integer y = 2952
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1120
integer x = 325
integer y = 2956
end type

type st_1 from w_inherite_standard`st_1 within w_psd1120
integer x = 50
integer y = 2664
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1120
integer x = 2359
integer y = 2936
end type

event cb_cancel::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setcolumn("levelcode")
dw_1.setfocus()
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1120
integer x = 2267
integer y = 2612
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1120
integer x = 462
integer y = 2700
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1120
integer x = 2555
integer y = 2656
integer width = 1221
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1120
integer x = 288
integer y = 2896
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1120
integer x = 3621
integer y = 2396
long backcolor = 80269524
end type

type dw_1 from datawindow within w_psd1120
event ue_enter pbm_dwnprocessenter
integer x = 137
integer y = 300
integer width = 3442
integer height = 1748
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1120"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this),256,9,0)

return 1
end event

event rowfocuschanged;this.setrowfocusindicator(hand!)
end event

event editchanged;ib_any_typing = true
end event

event itemchanged;real is_we1, is_we2,is_we

if this.accepttext() = -1 then return -1

if this.getcolumnname() = "weight1" then

	is_we1 = this.getitemdecimal(this.getrow(),"weight1")
	is_we2 = this.getitemdecimal(this.getrow(),"weight2")
	
	if  not (is_we1 = 0 or isnull(is_we1)) and isnull(is_we2) then	
		this.setitem(this.getrow(),"weight2",0)
		return -1
	end if
	
elseif this.getcolumnname() = "weight2" then
	
	is_we1 = this.getitemdecimal(this.getrow(),"weight1")
	is_we2 = this.getitemdecimal(this.getrow(),"weight2")
	
	if not (is_we2 = 0 or isnull(is_we2)) and isnull(is_we1) then	
		this.setitem(this.getrow(),"weight1",0)
		return -1
	end if

end if
end event

type rr_2 from roundrectangle within w_psd1120
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 252
integer width = 4535
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

