$PBExportHeader$w_piz1100.srw
$PBExportComments$인원현황 MAIN
forward
global type w_piz1100 from w_inherite_standard
end type
type cb_1 from commandbutton within w_piz1100
end type
type cb_26 from commandbutton within w_piz1100
end type
type cb_11 from commandbutton within w_piz1100
end type
type cb_12 from commandbutton within w_piz1100
end type
type cb_21 from commandbutton within w_piz1100
end type
type cb_22 from commandbutton within w_piz1100
end type
type cb_23 from commandbutton within w_piz1100
end type
type cb_13 from commandbutton within w_piz1100
end type
type cb_14 from commandbutton within w_piz1100
end type
type cb_15 from commandbutton within w_piz1100
end type
type cb_16 from commandbutton within w_piz1100
end type
type cb_35 from commandbutton within w_piz1100
end type
type cb_34 from commandbutton within w_piz1100
end type
type cb_41 from commandbutton within w_piz1100
end type
type cb_42 from commandbutton within w_piz1100
end type
type cb_43 from commandbutton within w_piz1100
end type
type cb_25 from commandbutton within w_piz1100
end type
type cb_24 from commandbutton within w_piz1100
end type
type cb_31 from commandbutton within w_piz1100
end type
type cb_32 from commandbutton within w_piz1100
end type
type cb_33 from commandbutton within w_piz1100
end type
type cb_2 from commandbutton within w_piz1100
end type
type gb_3 from groupbox within w_piz1100
end type
type gb_4 from groupbox within w_piz1100
end type
type gb_5 from groupbox within w_piz1100
end type
type gb_6 from groupbox within w_piz1100
end type
type gb_7 from groupbox within w_piz1100
end type
end forward

global type w_piz1100 from w_inherite_standard
string title = "인원 현황"
cb_1 cb_1
cb_26 cb_26
cb_11 cb_11
cb_12 cb_12
cb_21 cb_21
cb_22 cb_22
cb_23 cb_23
cb_13 cb_13
cb_14 cb_14
cb_15 cb_15
cb_16 cb_16
cb_35 cb_35
cb_34 cb_34
cb_41 cb_41
cb_42 cb_42
cb_43 cb_43
cb_25 cb_25
cb_24 cb_24
cb_31 cb_31
cb_32 cb_32
cb_33 cb_33
cb_2 cb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
end type
global w_piz1100 w_piz1100

type variables

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false


char c_status


end variables

on w_piz1100.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_26=create cb_26
this.cb_11=create cb_11
this.cb_12=create cb_12
this.cb_21=create cb_21
this.cb_22=create cb_22
this.cb_23=create cb_23
this.cb_13=create cb_13
this.cb_14=create cb_14
this.cb_15=create cb_15
this.cb_16=create cb_16
this.cb_35=create cb_35
this.cb_34=create cb_34
this.cb_41=create cb_41
this.cb_42=create cb_42
this.cb_43=create cb_43
this.cb_25=create cb_25
this.cb_24=create cb_24
this.cb_31=create cb_31
this.cb_32=create cb_32
this.cb_33=create cb_33
this.cb_2=create cb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_26
this.Control[iCurrent+3]=this.cb_11
this.Control[iCurrent+4]=this.cb_12
this.Control[iCurrent+5]=this.cb_21
this.Control[iCurrent+6]=this.cb_22
this.Control[iCurrent+7]=this.cb_23
this.Control[iCurrent+8]=this.cb_13
this.Control[iCurrent+9]=this.cb_14
this.Control[iCurrent+10]=this.cb_15
this.Control[iCurrent+11]=this.cb_16
this.Control[iCurrent+12]=this.cb_35
this.Control[iCurrent+13]=this.cb_34
this.Control[iCurrent+14]=this.cb_41
this.Control[iCurrent+15]=this.cb_42
this.Control[iCurrent+16]=this.cb_43
this.Control[iCurrent+17]=this.cb_25
this.Control[iCurrent+18]=this.cb_24
this.Control[iCurrent+19]=this.cb_31
this.Control[iCurrent+20]=this.cb_32
this.Control[iCurrent+21]=this.cb_33
this.Control[iCurrent+22]=this.cb_2
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.gb_5
this.Control[iCurrent+26]=this.gb_6
this.Control[iCurrent+27]=this.gb_7
end on

on w_piz1100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_26)
destroy(this.cb_11)
destroy(this.cb_12)
destroy(this.cb_21)
destroy(this.cb_22)
destroy(this.cb_23)
destroy(this.cb_13)
destroy(this.cb_14)
destroy(this.cb_15)
destroy(this.cb_16)
destroy(this.cb_35)
destroy(this.cb_34)
destroy(this.cb_41)
destroy(this.cb_42)
destroy(this.cb_43)
destroy(this.cb_25)
destroy(this.cb_24)
destroy(this.cb_31)
destroy(this.cb_32)
destroy(this.cb_33)
destroy(this.cb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
end on

type p_mod from w_inherite_standard`p_mod within w_piz1100
boolean visible = false
integer x = 2130
integer y = 2380
end type

type p_del from w_inherite_standard`p_del within w_piz1100
boolean visible = false
integer x = 2304
integer y = 2380
end type

type p_inq from w_inherite_standard`p_inq within w_piz1100
boolean visible = false
integer x = 1435
integer y = 2380
end type

type p_print from w_inherite_standard`p_print within w_piz1100
boolean visible = false
integer x = 1262
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_piz1100
boolean visible = false
integer x = 2478
integer y = 2380
end type

type p_exit from w_inherite_standard`p_exit within w_piz1100
end type

type p_ins from w_inherite_standard`p_ins within w_piz1100
boolean visible = false
integer x = 1609
integer y = 2380
end type

type p_search from w_inherite_standard`p_search within w_piz1100
boolean visible = false
integer x = 1083
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_piz1100
boolean visible = false
integer x = 1783
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_piz1100
boolean visible = false
integer x = 1957
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_piz1100
boolean visible = false
integer x = 823
integer y = 2380
end type

type st_window from w_inherite_standard`st_window within w_piz1100
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_piz1100
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_piz1100
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_piz1100
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_piz1100
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_piz1100
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_piz1100
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_piz1100
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_piz1100
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_piz1100
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_piz1100
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_piz1100
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_piz1100
boolean visible = false
end type

type cb_1 from commandbutton within w_piz1100
integer x = 1422
integer y = 1220
integer width = 608
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직종별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_34"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_26 from commandbutton within w_piz1100
integer x = 2528
integer y = 948
integer width = 608
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "자격증별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_26"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_11 from commandbutton within w_piz1100
integer x = 1422
integer y = 520
integer width = 608
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직위별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_11"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_12 from commandbutton within w_piz1100
integer x = 1422
integer y = 660
integer width = 608
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직급별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_12"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_21 from commandbutton within w_piz1100
integer x = 2528
integer y = 516
integer width = 608
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "학력별   현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_21"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_22 from commandbutton within w_piz1100
integer x = 2528
integer y = 656
integer width = 608
integer height = 108
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "연도별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_22"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_23 from commandbutton within w_piz1100
integer x = 2528
integer y = 796
integer width = 608
integer height = 108
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "근속년수 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_23"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_13 from commandbutton within w_piz1100
integer x = 1422
integer y = 800
integer width = 608
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직책별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_13"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_14 from commandbutton within w_piz1100
integer x = 1422
integer y = 940
integer width = 608
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "연도별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_14"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_15 from commandbutton within w_piz1100
integer x = 1422
integer y = 1080
integer width = 608
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "학력별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_15"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_16 from commandbutton within w_piz1100
integer x = 1422
integer y = 1360
integer width = 608
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "근속년수 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_16"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_35 from commandbutton within w_piz1100
boolean visible = false
integer x = 1783
integer y = 2544
integer width = 608
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "본사/현장 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_44"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_34 from commandbutton within w_piz1100
boolean visible = false
integer x = 1339
integer y = 2772
integer width = 608
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "관리/기술 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_34"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_41 from commandbutton within w_piz1100
boolean visible = false
integer x = 265
integer y = 2520
integer width = 608
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직위별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_41"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_42 from commandbutton within w_piz1100
boolean visible = false
integer x = 265
integer y = 2660
integer width = 608
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직급별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_42"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_43 from commandbutton within w_piz1100
boolean visible = false
integer x = 265
integer y = 2800
integer width = 608
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직책별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_43"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type cb_25 from commandbutton within w_piz1100
boolean visible = false
integer x = 1760
integer y = 2288
integer width = 608
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "학교별   현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_25"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_24 from commandbutton within w_piz1100
boolean visible = false
integer x = 1783
integer y = 2424
integer width = 608
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출신지   현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_24"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_31 from commandbutton within w_piz1100
boolean visible = false
integer x = 2587
integer y = 2388
integer width = 608
integer height = 108
integer taborder = 180
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "학력별   현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_31"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_32 from commandbutton within w_piz1100
boolean visible = false
integer x = 2587
integer y = 2528
integer width = 608
integer height = 108
integer taborder = 190
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "연령별   현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_32"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_33 from commandbutton within w_piz1100
boolean visible = false
integer x = 2587
integer y = 2668
integer width = 608
integer height = 108
integer taborder = 200
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "근속년수 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_33"

OpenWithParm(w_piz1100_1, ls_dwname)

end event

type cb_2 from commandbutton within w_piz1100
integer x = 1422
integer y = 1500
integer width = 608
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "성별 현황"
end type

event clicked;string ls_dwname

ls_dwname = "dq_piz1100_17"

OpenWithParm(w_piz1100_1, ls_dwname)


end event

type gb_3 from groupbox within w_piz1100
integer x = 1349
integer y = 412
integer width = 745
integer height = 1284
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "부서별 현황"
end type

type gb_4 from groupbox within w_piz1100
integer x = 2464
integer y = 412
integer width = 745
integer height = 712
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "직급별 현황"
end type

type gb_5 from groupbox within w_piz1100
boolean visible = false
integer x = 1266
integer y = 2664
integer width = 745
integer height = 292
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
string text = "인원 비율 현황"
end type

type gb_6 from groupbox within w_piz1100
boolean visible = false
integer x = 201
integer y = 2412
integer width = 745
integer height = 568
integer taborder = 190
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 32768
long backcolor = 32106727
string text = "부문별 현황"
end type

type gb_7 from groupbox within w_piz1100
boolean visible = false
integer x = 2523
integer y = 2280
integer width = 745
integer height = 568
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "직책별 현황"
end type

