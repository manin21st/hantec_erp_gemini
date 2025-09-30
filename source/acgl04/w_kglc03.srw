$PBExportHeader$w_kglc03.srw
$PBExportComments$회계기준일 관리
forward
global type w_kglc03 from w_inherite
end type
type dw_ip from datawindow within w_kglc03
end type
type mle_1 from multilineedit within w_kglc03
end type
type rr_1 from roundrectangle within w_kglc03
end type
end forward

global type w_kglc03 from w_inherite
string title = "회계기준일 수정"
dw_ip dw_ip
mle_1 mle_1
rr_1 rr_1
end type
global w_kglc03 w_kglc03

on w_kglc03.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.mle_1=create mle_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.mle_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_kglc03.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.mle_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)

dw_ip.Reset()

if dw_ip.Retrieve() <= 0 then
   dw_ip.InsertRow(0)
   dw_ip.Setitem(dw_ip.Getrow(),"balymd1",String(Today(),'yyyymm') + "01" )
   dw_ip.Setitem(dw_ip.Getrow(),"balymd2",String(Today(),'yyyymmdd') )
   dw_ip.Setitem(dw_ip.Getrow(),"accymd1",String(Today(),'yyyymm') + "01" )
   dw_ip.Setitem(dw_ip.Getrow(),"accymd2",String(Today(),'yyyymmdd') )
else
   dw_ip.AcceptText()
end if 
end event

type dw_insert from w_inherite`dw_insert within w_kglc03
boolean visible = false
integer x = 123
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc03
boolean visible = false
integer x = 3269
integer y = 2648
end type

type p_addrow from w_inherite`p_addrow within w_kglc03
boolean visible = false
integer x = 3049
integer y = 2660
end type

type p_search from w_inherite`p_search within w_kglc03
boolean visible = false
integer x = 3067
integer y = 2500
end type

type p_ins from w_inherite`p_ins within w_kglc03
boolean visible = false
integer x = 3657
integer y = 2480
end type

type p_exit from w_inherite`p_exit within w_kglc03
integer x = 4421
end type

type p_can from w_inherite`p_can within w_kglc03
boolean visible = false
integer x = 3749
integer y = 2712
end type

type p_print from w_inherite`p_print within w_kglc03
boolean visible = false
integer x = 3255
integer y = 2484
end type

type p_inq from w_inherite`p_inq within w_kglc03
boolean visible = false
integer x = 3474
integer y = 2484
end type

type p_del from w_inherite`p_del within w_kglc03
boolean visible = false
integer x = 3497
integer y = 2688
end type

type p_mod from w_inherite`p_mod within w_kglc03
integer x = 4242
end type

event p_mod::clicked;if dw_ip.Update() = 1 then
   w_mdi_frame.sle_msg.Text = "회계시스템의 기준일자가 수정되었습니다!"
   commit ;
   dw_ip.SetFocus()
else
   messagebox("확인","회계시스템의 기준일자 수정이 실패하였습니다. 다시 작업하십시오!")
   rollback ;
   dw_ip.SetFocus()
   return
end if
end event

type cb_exit from w_inherite`cb_exit within w_kglc03
boolean visible = false
integer x = 2217
integer y = 2764
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_kglc03
boolean visible = false
integer x = 1847
integer y = 2768
integer taborder = 20
end type

event cb_mod::clicked;call super::clicked;if dw_ip.Update() = 1 then
   sle_msg.Text = "회계시스템의 기준일자가 수정되었습니다!"
   commit ;
   dw_ip.SetFocus()
else
   messagebox("확인","회계시스템의 기준일자 수정이 실패하였습니다. 다시 작업하십시오!")
   rollback ;
   dw_ip.SetFocus()
   return
end if
end event

type cb_ins from w_inherite`cb_ins within w_kglc03
boolean visible = false
integer x = 224
integer y = 2552
end type

type cb_del from w_inherite`cb_del within w_kglc03
boolean visible = false
integer x = 937
integer y = 2552
end type

type cb_inq from w_inherite`cb_inq within w_kglc03
boolean visible = false
integer x = 1294
integer y = 2552
end type

type cb_print from w_inherite`cb_print within w_kglc03
integer x = 1650
integer y = 2552
end type

type st_1 from w_inherite`st_1 within w_kglc03
end type

type cb_can from w_inherite`cb_can within w_kglc03
boolean visible = false
integer x = 2007
integer y = 2552
end type

type cb_search from w_inherite`cb_search within w_kglc03
integer x = 2363
integer y = 2552
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc03
integer x = 2843
integer width = 741
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kglc03
integer width = 2459
end type



type gb_button1 from w_inherite`gb_button1 within w_kglc03
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc03
boolean visible = false
integer x = 1801
integer y = 2708
integer width = 782
end type

type dw_ip from datawindow within w_kglc03
event ue_pressenter pbm_dwnprocessenter
integer x = 1225
integer y = 444
integer width = 1915
integer height = 360
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc03_0"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type mle_1 from multilineedit within w_kglc03
integer x = 1243
integer y = 976
integer width = 1929
integer height = 404
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "                                                     1. 회계시스템의 전표발행일 및 회계처리일의 범위를 지정     하여 오류전표의 발생을 방지할 목적으로 사용한다.                                                        2. 회계시스템의 제반업무를 월마감한 후 일자범위를 조정     해야 합니다."
boolean border = false
boolean displayonly = true
end type

type rr_1 from roundrectangle within w_kglc03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 946
integer y = 312
integer width = 2592
integer height = 1332
integer cornerheight = 40
integer cornerwidth = 46
end type

