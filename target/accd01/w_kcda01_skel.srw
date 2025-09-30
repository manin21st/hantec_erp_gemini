$PBExportHeader$w_kcda01_skel.srw
$PBExportComments$계정과목 등록
forward
global type w_kcda01_skel from w_inherite
end type
type cbx_1 from checkbox within w_kcda01_skel
end type
type cbx_2 from checkbox within w_kcda01_skel
end type
type dw_1 from datawindow within w_kcda01_skel
end type
type dw_list from datawindow within w_kcda01_skel
end type
type st_2 from statictext within w_kcda01_skel
end type
type sle_1 from singlelineedit within w_kcda01_skel
end type
type p_copy from uo_picture within w_kcda01_skel
end type
type dw_copy from datawindow within w_kcda01_skel
end type
end forward

global type w_kcda01_skel from w_inherite
int Width=4736, Height=2524
string title = "계정과목 등록 (Skeleton)"
cbx_1 cbx_1
cbx_2 cbx_2
dw_1 dw_1
dw_list dw_list
st_2 st_2
sle_1 sle_1
p_copy p_copy
dw_copy dw_copy
end type
global w_kcda01_skel w_kcda01_skel

type variables
end variables

forward prototypes
public subroutine wf_find_row (string sacc1, string sacc2)
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_init ()
public subroutine wf_set_openwindow (string acc1, string acc2)
public subroutine wf_control_kfz01ot1 (string sacc1_cd, string sacc2_cd)
public subroutine wf_acccode_accross ()
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public subroutine wf_find_row (string sacc1, string sacc2)
// Empty Body
end subroutine

public function integer wf_requiredchk (integer ll_row)
// Empty Body
Return 1
end function

public subroutine wf_init ()
// Empty Body
end subroutine

public subroutine wf_set_openwindow (string acc1, string acc2)
// Empty Body
end subroutine

public subroutine wf_control_kfz01ot1 (string sacc1_cd, string sacc2_cd)
// Empty Body
end subroutine

public subroutine wf_acccode_accross ()
// Empty Body
end subroutine

public subroutine wf_setting_retrievemode (string mode)
// Empty Body
end subroutine

event open;call super::open;
end event

on w_kcda01_skel.create
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.dw_1=create dw_1
this.dw_list=create dw_list
this.st_2=create st_2
this.sle_1=create sle_1
this.p_copy=create p_copy
this.dw_copy=create dw_copy

int iCurrent
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.p_copy
this.Control[iCurrent+8]=this.dw_copy
end on

on w_kcda01_skel.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.p_copy)
destroy(this.dw_copy)
end on

// Inherited controls
type p_mod from w_inherite`p_mod within w_kcda01_skel
    visible = false
    x = 2727
    y = 1500
end type

type dw_insert from w_inherite`dw_insert within w_kcda01_skel
boolean visible = false
end type

type p_delrow from w_inherite`p_delrow within w_kcda01_skel
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_kcda01_skel
boolean visible = false
end type

type p_search from w_inherite`p_search within w_kcda01_skel
end type

type p_ins from w_inherite`p_ins within w_kcda01_skel
end type

type p_exit from w_inherite`p_exit within w_kcda01_skel
end type

type p_can from w_inherite`p_can within w_kcda01_skel
end type

type p_print from w_inherite`p_print within w_kcda01_skel
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_kcda01_skel
end type

type p_del from w_inherite`p_del within w_kcda01_skel
end type

// Local Controls
type cbx_1 from checkbox within w_kcda01_skel
integer x = 1641
integer y = 80
integer width = 640
integer height = 64
string text = "계정과목 일괄 등록"
end type

type cbx_2 from checkbox within w_kcda01_skel
integer x = 2450
integer y = 80
integer width = 553
integer height = 76
string text = "관리항목 등록"
end type

type dw_1 from datawindow within w_kcda01_skel
integer x = 1303
integer y = 196
integer width = 3319
integer height = 2064
string dataobject = "dw_kcda01_1"
end type

type dw_list from datawindow within w_kcda01_skel
integer x = 55
integer y = 212
integer width = 1221
integer height = 2020
string dataobject = "dw_kcda01_4"
end type

type st_2 from statictext within w_kcda01_skel
integer x = 73
integer y = 92
integer width = 366
integer height = 48
string text = "계정과목"
end type

type sle_1 from singlelineedit within w_kcda01_skel
integer x = 347
integer y = 84
integer width = 567
integer height = 64
end type

type p_copy from uo_picture within w_kcda01_skel
integer x = 3387
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\복사_up.gif"
end type

type dw_copy from datawindow within w_kcda01_skel
boolean visible = false
integer x = 2917
integer y = 2304
integer width = 398
integer height = 332
string dataobject = "dw_kcda01_1"
end type
