$PBExportHeader$w_kbgc03a.srw
$PBExportComments$과목별예실차이분석조회(조정)(완료)
forward
global type w_kbgc03a from window
end type
type p_exit from uo_picture within w_kbgc03a
end type
type dw_ret from datawindow within w_kbgc03a
end type
type rr_1 from roundrectangle within w_kbgc03a
end type
end forward

global type w_kbgc03a from window
integer x = 329
integer y = 336
integer width = 3374
integer height = 1936
boolean titlebar = true
string title = "과목별 예실차이분석(조정) 조회"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_ret dw_ret
rr_1 rr_1
end type
global w_kbgc03a w_kbgc03a

event open;dw_ret.SetTransObject(sqlca)

string ls_saupj, ls_acc_yy, ls_acc_mm, ls_acc1_cd, ls_acc2_cd,srtn_parm
long   rowno

F_Window_Center_ResPonse(This)

srtn_parm =Message.StringParm

ls_saupj   = Left(srtn_parm,2)
ls_acc_yy  = Mid(srtn_parm,3,4)
ls_acc_mm  = Mid(srtn_parm,7,2)
ls_acc1_cd = Mid(srtn_parm,9,5)
ls_acc2_cd = Mid(srtn_parm,14,2)

rowno = dw_ret.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm,ls_acc1_cd,ls_acc2_cd)
if rowno < 1 then
   messagebox("확인","조정처리한 자료가 없습니다!")
   close(w_kbgc03a)
end if
end event

on w_kbgc03a.create
this.p_exit=create p_exit
this.dw_ret=create dw_ret
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_ret,&
this.rr_1}
end on

on w_kbgc03a.destroy
destroy(this.p_exit)
destroy(this.dw_ret)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kbgc03a
integer x = 3168
integer y = 4
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type dw_ret from datawindow within w_kbgc03a
integer x = 46
integer y = 160
integer width = 3269
integer height = 1640
string dataobject = "dw_kbgc03a_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kbgc03a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 156
integer width = 3296
integer height = 1656
integer cornerheight = 40
integer cornerwidth = 55
end type

