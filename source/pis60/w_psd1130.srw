$PBExportHeader$w_psd1130.srw
$PBExportComments$고과등급환산등록
forward
global type w_psd1130 from w_inherite_standard
end type
type rr_2 from roundrectangle within w_psd1130
end type
type dw_1 from datawindow within w_psd1130
end type
end forward

global type w_psd1130 from w_inherite_standard
integer height = 2472
string title = "고과 등급 환산 등록"
rr_2 rr_2
dw_1 dw_1
end type
global w_psd1130 w_psd1130

on w_psd1130.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_1
end on

on w_psd1130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_1)
end on

event open;call super::open;DW_1.SETTRANSOBJECT(SQLCA)
DW_1.RETRIEVE()

DW_1.SCROLLTOROW(DW_1.ROWCOUNT())
DW_1.SETFOCUS()
end event

type p_mod from w_inherite_standard`p_mod within w_psd1130
end type

event p_mod::clicked;call super::clicked;string igrade
long getrow, ipoints

if dw_1.accepttext() = -1 then return -1

ib_any_typing = false
getrow = dw_1.getrow()

igrade = dw_1.getitemstring(getrow,"grade")
ipoints = dw_1.getitemdecimal(getrow,"points")

if igrade = "" or isnull(igrade) then 
	messagebox('확인','고과등급을 확인하세요')
	dw_1.setcolumn("grade")
	dw_1.setfocus()
	return 1
end if

if ipoints = 0 or isnull(ipoints) then 
	messagebox('확인','환산점수를 확인하세요')
	dw_1.setcolumn("points")
	dw_1.setfocus()
	return 1
end if

if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then

	if dw_1.update(true,false) = 1 then
		commit;
		w_mdi_frame.sle_msg.text = "저장되었습니다"
	else
		rollback;
		w_mdi_frame.sle_msg.text = "저장되지 않았습니다"
	end if

end if

cb_cancel.triggerevent(clicked!)
end event

type p_del from w_inherite_standard`p_del within w_psd1130
end type

event p_del::clicked;call super::clicked;long getrow
string igrade

getrow = dw_1.getrow()
igrade = dw_1.getitemstring(getrow,"grade")

if messagebox('확인','고과등급 ' + igrade + '을~r~n' + &
					'삭제하시겠습니까?', question!, yesno!) = 1 then
	
	delete from p6_meritexpnt where grade = :igrade ;
	commit;
	sle_msg.text = "삭제되었습니다."
end if

cb_cancel.triggerevent(clicked!)
	
					

end event

type p_inq from w_inherite_standard`p_inq within w_psd1130
integer x = 3205
integer y = 2672
end type

type p_print from w_inherite_standard`p_print within w_psd1130
integer x = 2981
integer y = 2848
end type

type p_can from w_inherite_standard`p_can within w_psd1130
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setcolumn("grade")
dw_1.setfocus()
end event

type p_exit from w_inherite_standard`p_exit within w_psd1130
end type

type p_ins from w_inherite_standard`p_ins within w_psd1130
integer x = 3685
end type

event p_ins::clicked;call super::clicked;string igrade
long getrow, ipoints

if dw_1.accepttext() = -1 then return -1

if dw_1.rowcount() <= 0 then

	dw_1.insertrow(0)
	dw_1.scrolltorow(dw_1.rowcount())
	dw_1.setcolumn("grade")
	dw_1.setfocus()
	
elseif dw_1.rowcount() >= 1 then
	
	getrow = dw_1.getrow()
	
	igrade = dw_1.getitemstring(getrow,"grade")
	ipoints = dw_1.getitemdecimal(getrow,"points")
	
	if ((igrade = "" or isnull(igrade)) or (ipoints = 0 or isnull(ipoints))) then
	
		if igrade = "" or isnull(igrade) then 
			messagebox('확인','고과등급을 확인하세요')
			dw_1.setcolumn("grade")
			dw_1.setfocus()
			return -1
		end if
		
		if ipoints = 0 or isnull(ipoints) then 
			messagebox('확인','환산점수를 확인하세요')
			dw_1.setcolumn("points")
			dw_1.setfocus()
			return -1
		end if
	else
		
		dw_1.insertrow(0)
		
		dw_1.scrolltorow(dw_1.rowcount())
		dw_1.setcolumn("grade")
		dw_1.setfocus()
		
	end if
	
end if
end event

type p_search from w_inherite_standard`p_search within w_psd1130
integer x = 2802
integer y = 2848
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1130
integer x = 3502
integer y = 2848
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1130
integer x = 3675
integer y = 2848
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1130
integer x = 201
integer y = 2808
end type

type st_window from w_inherite_standard`st_window within w_psd1130
integer x = 2094
integer y = 2608
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1130
integer x = 2528
integer y = 2916
end type

type cb_update from w_inherite_standard`cb_update within w_psd1130
integer x = 1157
integer y = 3036
end type

event cb_update::clicked;string igrade
long getrow, ipoints

if dw_1.accepttext() = -1 then return -1

ib_any_typing = false
getrow = dw_1.getrow()

igrade = dw_1.getitemstring(getrow,"grade")
ipoints = dw_1.getitemdecimal(getrow,"points")

if igrade = "" or isnull(igrade) then 
	messagebox('확인','고과등급을 확인하세요')
	dw_1.setcolumn("grade")
	dw_1.setfocus()
	return 1
end if

if ipoints = 0 or isnull(ipoints) then 
	messagebox('확인','환산점수를 확인하세요')
	dw_1.setcolumn("points")
	dw_1.setfocus()
	return 1
end if

if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then

	if dw_1.update(true,false) = 1 then
		commit;
		sle_msg.text = "저장되었습니다"
	else
		rollback;
		sle_msg.text = "저장되지 않았습니다"
	end if

end if

cb_cancel.triggerevent(clicked!)
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1130
integer x = 727
integer y = 3036
integer width = 361
string text = "추가(&A)"
end type

event cb_insert::clicked;call super::clicked;string igrade
long getrow, ipoints

if dw_1.accepttext() = -1 then return -1

if dw_1.rowcount() <= 0 then

	dw_1.insertrow(0)
	dw_1.scrolltorow(dw_1.rowcount())
	dw_1.setcolumn("grade")
	dw_1.setfocus()
	
elseif dw_1.rowcount() >= 1 then
	
	getrow = dw_1.getrow()
	
	igrade = dw_1.getitemstring(getrow,"grade")
	ipoints = dw_1.getitemdecimal(getrow,"points")
	
	if ((igrade = "" or isnull(igrade)) or (ipoints = 0 or isnull(ipoints))) then
	
		if igrade = "" or isnull(igrade) then 
			messagebox('확인','고과등급을 확인하세요')
			dw_1.setcolumn("grade")
			dw_1.setfocus()
			return -1
		end if
		
		if ipoints = 0 or isnull(ipoints) then 
			messagebox('확인','환산점수를 확인하세요')
			dw_1.setcolumn("points")
			dw_1.setfocus()
			return -1
		end if
	else
		
		dw_1.insertrow(0)
		
		dw_1.scrolltorow(dw_1.rowcount())
		dw_1.setcolumn("grade")
		dw_1.setfocus()
		
	end if
	
end if
end event

type cb_delete from w_inherite_standard`cb_delete within w_psd1130
integer x = 1472
integer y = 3020
end type

event cb_delete::clicked;call super::clicked;long getrow
string igrade

getrow = dw_1.getrow()
igrade = dw_1.getitemstring(getrow,"grade")

if messagebox('확인','고과등급 ' + igrade + '을~r~n' + &
					'삭제하시겠습니까?', question!, yesno!) = 1 then
	
	delete from p6_meritexpnt where grade = :igrade ;
	commit;
	sle_msg.text = "삭제되었습니다."
end if

cb_cancel.triggerevent(clicked!)
	
					

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1130
integer x = 553
integer y = 2732
end type

type st_1 from w_inherite_standard`st_1 within w_psd1130
integer x = 0
integer y = 2608
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1130
integer x = 1806
integer y = 3040
end type

event cb_cancel::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setcolumn("grade")
dw_1.setfocus()
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1130
integer x = 2738
integer y = 2596
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1130
integer x = 411
integer y = 2608
integer width = 1728
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1130
integer x = 1001
integer y = 2564
integer width = 1947
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1130
integer x = 517
integer y = 2672
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1130
integer x = 3456
integer y = 2564
integer width = 3493
long backcolor = 80269524
end type

type rr_2 from roundrectangle within w_psd1130
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 220
integer width = 4558
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_psd1130
event ue_enter pbm_dwnprocessenter
integer x = 389
integer y = 288
integer width = 2240
integer height = 1772
integer taborder = 10
string title = "none"
string dataobject = "d_psd1130"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;if dw_1.GetColumnName() = "points" then
	
	if ib_any_typing = true then
		cb_update.triggerevent(clicked!)
		return
	end if
	
	if dw_1.getrow() = dw_1.rowcount() then
		cb_insert.triggerevent(clicked!)
 		return 
	end if
end if

send(handle(this),256,9,0)
return 1
end event

event rowfocuschanged;DW_1.SetRowFocusIndicator(hand!)
end event

event itemchanged;string igrade, igrade_s

if dw_1.GetColumnName() = "grade" then
	igrade = dw_1.gettext()
	
	select grade into :igrade_s 
	from p6_meritexpnt
	where grade = :igrade ;
	
	if sqlca.sqlcode = 0 then
		messagebox('확인','고과등급이 존재합니다')
		dw_1.setcolumn("grade")
		dw_1.selecttextall()
		dw_1.setfocus()
		return 1
	end if
end if
end event

event itemerror;return 1
end event

event editchanged;ib_any_typing = true
end event

