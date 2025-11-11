forward
global type w_adt_00290 from w_inherite
type dw_insert from w_inherite`dw_insert within w_adt_00290
end type
type p_delrow from w_inherite`p_delrow within w_adt_00290
end type
type p_addrow from w_inherite`p_addrow within w_adt_00290
end type
type p_search from w_inherite`p_search within w_adt_00290
end type
type p_ins from w_inherite`p_ins within w_adt_00290
end type
type p_exit from w_inherite`p_exit within w_adt_00290
end type
type p_can from w_inherite`p_can within w_adt_00290
end type
type p_print from w_inherite`p_print within w_adt_00290
end type
type p_inq from w_inherite`p_inq within w_adt_00290
end type
type p_del from w_inherite`p_del within w_adt_00290
end type
type p_mod from w_inherite`p_mod within w_adt_00290
end type
type cb_exit from w_inherite`cb_exit within w_adt_00290
end type
type cb_mod from w_inherite`cb_mod within w_adt_00290
end type
type cb_ins from w_inherite`cb_ins within w_adt_00290
end type
type cb_del from w_inherite`cb_del within w_adt_00290
end type
type cb_inq from w_inherite`cb_inq within w_adt_00290
end type
type cb_print from w_inherite`cb_print within w_adt_00290
end type
type st_1 from w_inherite`st_1 within w_adt_00290
end type
type cb_can from w_inherite`cb_can within w_adt_00290
end type
type cb_search from w_inherite`cb_search within w_adt_00290
end type
type gb_10 from w_inherite`gb_10 within w_adt_00290
end type
type gb_button1 from w_inherite`gb_button1 within w_adt_00290
end type
type gb_button2 from w_inherite`gb_button2 within w_adt_00290
end type
end type
end forward

global type w_adt_00290 from w_inherite
end type
global w_adt_00290 w_adt_00290

type dw_insert from w_inherite`dw_insert
boolean visible = false
integer x = 155
integer y = 2424
integer width = 517
integer height = 200
integer taborder = 0
boolean enabled = false
string dataobject = "d_pdt_02030_1"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type p_delrow from w_inherite`p_delrow
boolean visible = false
integer x = 3333
integer y = 2476
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow
boolean visible = false
integer x = 3159
integer y = 2476
integer taborder = 50
end type

type p_search from w_inherite`p_search
boolean visible = false
integer x = 2464
integer y = 2476
integer taborder = 150
end type

type p_ins from w_inherite`p_ins
boolean visible = false
integer x = 2985
integer y = 2476
integer taborder = 30
end type

type p_exit from w_inherite`p_exit
boolean visible = false
integer x = 4027
integer y = 2476
integer taborder = 140
end type

type p_can from w_inherite`p_can
boolean visible = false
integer x = 3854
integer y = 2476
integer taborder = 130
end type

type p_print from w_inherite`p_print
boolean visible = false
integer x = 2638
integer y = 2476
integer taborder = 160
end type

type p_inq from w_inherite`p_inq
boolean visible = false
integer x = 2811
integer y = 2476
end type

type p_del from w_inherite`p_del
boolean visible = false
integer x = 3680
integer y = 2476
integer taborder = 120
end type

type p_mod from w_inherite`p_mod
boolean visible = false
integer x = 3506
integer y = 2476
integer taborder = 100
end type

type cb_exit from w_inherite`cb_exit
integer x = 1650
integer y = 2708
boolean enabled = false
string text = "종료"
end type

type cb_mod from w_inherite`cb_mod
integer x = 955
integer y = 2708
boolean enabled = false
string text = "계산"
end type

type cb_ins from w_inherite`cb_ins
integer x = 261
integer y = 2956
boolean enabled = false
string text = "추가"
end type

event cb_ins::clicked;
call super::clicked;//if tab_1.tabpage_2.dw_item.rowcount() = 0 then
//	if wf_reset() = -1 then
//		return
//	end if
//end if
//
//Long Lrow
//
//Lrow = 	tab_1.tabpage_2.dw_item.insertrow(0)
//		 	tab_1.tabpage_2.dw_item.setitem(Lrow, "momast_sabu", gs_sabu)
//			tab_1.tabpage_2.dw_item.setitem(Lrow, "momast_jidat", f_today())
//			tab_1.tabpage_2.dw_item.setitem(Lrow, "momast_pdsts", '1')
//			tab_1.tabpage_2.dw_item.setitem(Lrow, "momast_purgc", 'N')
//			tab_1.tabpage_2.dw_item.setitem(Lrow, "pagbn", 'N')
//
//post function wf_focus(Lrow, "momast_porgu")
end event

type cb_del from w_inherite`cb_del
integer x = 613
integer y = 2956
boolean enabled = false
string text = "삭제"
end type

event cb_del::clicked;
call super::clicked;//if tab_1.tabpage_2.dw_item.getrow() > 0 then
//	tab_1.tabpage_2.dw_item.deleterow(0)
//	tab_1.tabpage_2.dw_item.setfocus()
//else
//	f_message_chk(81,'[작업지시]') 	
//	cb_ins.setfocus()
//end if
end event

type cb_inq from w_inherite`cb_inq
integer x = 965
integer y = 2956
boolean enabled = false
string text = "조회"
end type

type cb_print from w_inherite`cb_print
integer x = 1303
integer y = 2952
boolean enabled = false
string text = "출력"
end type

type st_1 from w_inherite`st_1
integer x = 37
end type

type cb_can from w_inherite`cb_can
integer x = 1298
integer y = 2708
boolean enabled = false
string text = "취소"
end type

type cb_search from w_inherite`cb_search
integer x = 1669
integer y = 2956
boolean enabled = false
string text = "자료조회"
end type

type gb_10 from w_inherite`gb_10
integer x = 27
end type

type gb_button1 from w_inherite`gb_button1

end type

type gb_button2 from w_inherite`gb_button2

end type
