$PBExportHeader$w_kbgc03b.srw
$PBExportComments$과목별예실차이분석조회(부서)(완료)
forward
global type w_kbgc03b from window
end type
type p_exit from uo_picture within w_kbgc03b
end type
type dw_jonwol from datawindow within w_kbgc03b
end type
type dw_jonyen from datawindow within w_kbgc03b
end type
type dw_nugey from datawindow within w_kbgc03b
end type
type dw_dang from datawindow within w_kbgc03b
end type
type dw_ret from datawindow within w_kbgc03b
end type
type rr_1 from roundrectangle within w_kbgc03b
end type
end forward

global type w_kbgc03b from window
integer x = 133
integer y = 288
integer width = 4718
integer height = 2440
boolean titlebar = true
string title = "과목별 예실차이분석(부서)  조회"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_jonwol dw_jonwol
dw_jonyen dw_jonyen
dw_nugey dw_nugey
dw_dang dw_dang
dw_ret dw_ret
rr_1 rr_1
end type
global w_kbgc03b w_kbgc03b

event open;dw_ret.settransobject(sqlca)

string ls_saupj,ls_acc_yy,ls_acc_mm,ls_bef_yy,ls_bef_mm,ls_acc1_cd,ls_acc2_cd,srtn_parm
Int rowno,ll_bef_yy,ll_bef_mm

//F_Window_Center_ResPonse(This)
THIS.X = 20
THIS.Y = 1000

srtn_parm =Message.StringParm

ls_saupj   = Left(srtn_parm,2)
ls_acc_yy  = Mid(srtn_parm,3,4)
ls_acc_mm  = Mid(srtn_parm,7,2)
ls_acc1_cd = Mid(srtn_parm,9,5)
ls_acc2_cd = Mid(srtn_parm,14,2)

//전월//
ll_bef_mm =Integer(ls_acc_mm) - 1
ll_bef_yy = Integer(ls_acc_yy) - 1
IF ll_bef_mm > 9 THEN
	ls_bef_yy = String(ll_bef_yy)
	ls_bef_mm = String(ll_bef_mm)
ELSE
	ls_bef_mm ='0'+String(ll_bef_mm)
END IF

rowno = dw_ret.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm,ls_bef_yy,ls_bef_mm,ls_acc1_cd,ls_acc2_cd)
if rowno < 1 then
   messagebox("확인","조회한 자료가 없습니다!")
   close(w_kbgc03b)
end if
end event

on w_kbgc03b.create
this.p_exit=create p_exit
this.dw_jonwol=create dw_jonwol
this.dw_jonyen=create dw_jonyen
this.dw_nugey=create dw_nugey
this.dw_dang=create dw_dang
this.dw_ret=create dw_ret
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_jonwol,&
this.dw_jonyen,&
this.dw_nugey,&
this.dw_dang,&
this.dw_ret,&
this.rr_1}
end on

on w_kbgc03b.destroy
destroy(this.p_exit)
destroy(this.dw_jonwol)
destroy(this.dw_jonyen)
destroy(this.dw_nugey)
destroy(this.dw_dang)
destroy(this.dw_ret)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kbgc03b
integer x = 4494
integer y = 8
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type dw_jonwol from datawindow within w_kbgc03b
boolean visible = false
integer x = 1979
integer y = 2496
integer width = 494
integer height = 84
boolean titlebar = true
string title = "부서전월자료"
string dataobject = "dw_kbgc03b_5"
boolean livescroll = true
end type

type dw_jonyen from datawindow within w_kbgc03b
boolean visible = false
integer x = 1435
integer y = 2496
integer width = 494
integer height = 84
boolean titlebar = true
string title = "부서전년자료"
string dataobject = "dw_kbgc03b_4"
boolean livescroll = true
end type

type dw_nugey from datawindow within w_kbgc03b
boolean visible = false
integer x = 891
integer y = 2496
integer width = 494
integer height = 84
boolean titlebar = true
string title = "부서누계자료"
string dataobject = "dw_kbgc03b_3"
boolean livescroll = true
end type

type dw_dang from datawindow within w_kbgc03b
boolean visible = false
integer x = 338
integer y = 2492
integer width = 494
integer height = 84
boolean titlebar = true
string title = "부서당월자료"
string dataobject = "dw_kbgc03b_2"
boolean livescroll = true
end type

type dw_ret from datawindow within w_kbgc03b
integer x = 55
integer y = 168
integer width = 4585
integer height = 2120
string dataobject = "dw_kbgc03b_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kbgc03b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 4617
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

