$PBExportHeader$w_kbgb10.srw
$PBExportComments$예산 월마감 집계처리
forward
global type w_kbgb10 from w_inherite
end type
type cb_2 from commandbutton within w_kbgb10
end type
type dw_ip from datawindow within w_kbgb10
end type
type dw_ret from datawindow within w_kbgb10
end type
type dw_ret2 from datawindow within w_kbgb10
end type
end forward

global type w_kbgb10 from w_inherite
string title = "예산실적 집계"
cb_2 cb_2
dw_ip dw_ip
dw_ret dw_ret
dw_ret2 dw_ret2
end type
global w_kbgb10 w_kbgb10

type variables

end variables

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ret.SetTransObject(SQLCA)
dw_ret.Reset()
dw_ret2.SetTransObject(SQLCA)
dw_ret2.Reset()

dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"syymm",String(today(),"yyyymm"))
dw_ip.SetItem(dw_ip.GetRow(),"eyymm",String(today(),"yyyymm"))
dw_ip.SetFocus()

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")			
ELSE
	dw_ip.Modify("saupj.protect = 1")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")				
END IF



end event

on w_kbgb10.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.dw_ip=create dw_ip
this.dw_ret=create dw_ret
this.dw_ret2=create dw_ret2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_ret
this.Control[iCurrent+4]=this.dw_ret2
end on

on w_kbgb10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.dw_ip)
destroy(this.dw_ret)
destroy(this.dw_ret2)
end on

type dw_insert from w_inherite`dw_insert within w_kbgb10
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgb10
boolean visible = false
integer x = 3113
integer y = 2200
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgb10
boolean visible = false
integer x = 2939
integer y = 2200
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgb10
boolean visible = false
integer x = 2245
integer y = 2200
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgb10
boolean visible = false
integer x = 2766
integer y = 2200
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgb10
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kbgb10
boolean visible = false
integer x = 3634
integer y = 2200
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbgb10
boolean visible = false
integer x = 2418
integer y = 2200
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbgb10
boolean visible = false
integer x = 2592
integer y = 2200
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kbgb10
boolean visible = false
integer x = 3461
integer y = 2200
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgb10
integer x = 4270
integer taborder = 20
end type

event p_mod::clicked;call super::clicked;String  ls_saupj, ls_syymm, ls_eyymm, &
        ls_dept_cd, ls_acc_yy, ls_acc_mm, ls_acc1_cd, ls_acc2_cd
long    i
Double  ldb_amt 

w_mdi_frame.sle_msg.text =""

if dw_ip.AcceptText() = -1 then return 

ls_saupj = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
ls_syymm = dw_ip.GetItemString(dw_ip.GetRow(),"syymm")
ls_eyymm = dw_ip.GetItemString(dw_ip.GetRow(),"eyymm")

//IF IsNull(ls_saupj) OR ls_saupj ="" THEN
//	MessageBox("확인","사업장을 입력하세요.!!!")
//   dw_ip.SetColumn("saupj")
//	dw_ip.SetFocus()
//	Return
//END IF

IF IsNull(ls_syymm) OR IsNull(ls_eyymm) THEN
	MessageBox("확인","회계년월 범위를 입력하십시오!")
   dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return
END IF
IF ls_syymm > ls_eyymm THEN
	MessageBox("확인","회계년월 범위를 확인하십시오!")
   dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text =" 예산 자료 복구 처리 중......!"

IF f_budget_sum(ls_syymm,ls_eyymm) = 2 THEN
	MessageBox("확 인","처리할 자료가 없습니다.!!")
	ROLLBACK;
	RETURN
END IF


w_mdi_frame.sle_msg.text ="예산 월마감실적 집계가 완료되었습니다!"
SetPointer(Arrow!)

end event

type cb_exit from w_inherite`cb_exit within w_kbgb10
boolean visible = false
integer x = 3182
integer y = 1884
end type

type cb_mod from w_inherite`cb_mod within w_kbgb10
boolean visible = false
integer x = 1362
integer y = 3172
integer width = 293
end type

type cb_ins from w_inherite`cb_ins within w_kbgb10
boolean visible = false
integer x = 1038
integer y = 3172
integer width = 293
end type

type cb_del from w_inherite`cb_del within w_kbgb10
boolean visible = false
integer x = 1687
integer y = 3172
integer width = 293
end type

type cb_inq from w_inherite`cb_inq within w_kbgb10
boolean visible = false
integer x = 2011
integer y = 3172
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kbgb10
integer x = 3113
integer y = 3172
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kbgb10
boolean visible = false
integer y = 2088
integer width = 288
end type

type cb_can from w_inherite`cb_can within w_kbgb10
boolean visible = false
integer x = 2327
integer y = 3172
integer width = 293
end type

type cb_search from w_inherite`cb_search within w_kbgb10
integer x = 2656
integer y = 3176
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kbgb10
boolean visible = false
integer y = 2088
end type

type sle_msg from w_inherite`sle_msg within w_kbgb10
boolean visible = false
integer x = 320
integer y = 2088
integer width = 2514
end type

type gb_10 from w_inherite`gb_10 within w_kbgb10
boolean visible = false
integer y = 2036
end type

type gb_button1 from w_inherite`gb_button1 within w_kbgb10
boolean visible = false
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb10
boolean visible = false
integer x = 2779
integer y = 1828
integer width = 782
end type

type cb_2 from commandbutton within w_kbgb10
boolean visible = false
integer x = 2825
integer y = 1884
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "마감(&U)"
end type

type dw_ip from datawindow within w_kbgb10
event ue_pressenter pbm_dwnprocessenter
integer x = 704
integer y = 388
integer width = 3168
integer height = 1216
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbgb10_0"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type dw_ret from datawindow within w_kbgb10
boolean visible = false
integer x = 137
integer y = 2508
integer width = 1541
integer height = 360
boolean bringtotop = true
boolean titlebar = true
string title = "미승인전표를 배정부서별 집계"
string dataobject = "dw_kbgb10_1"
boolean livescroll = true
end type

type dw_ret2 from datawindow within w_kbgb10
boolean visible = false
integer x = 1723
integer y = 2500
integer width = 1307
integer height = 360
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표를 배정부서별 집계"
string dataobject = "dw_kbgb10_2"
boolean livescroll = true
end type

