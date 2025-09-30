$PBExportHeader$w_imt_04650.srw
$PBExportComments$금형/치공구 사용 현황
forward
global type w_imt_04650 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04650
end type
end forward

global type w_imt_04650 from w_standard_print
string title = "금형/치공구 사용 현황"
rr_1 rr_1
end type
global w_imt_04650 w_imt_04650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Dec	dUseRate
String sGubun

If dw_ip.accepttext() <> 1 Then Return -1

dUseRate = dw_ip.GetItemNumber(1, 'userate')
If IsNull(dUseRate) Then dUseRate = 0

sGubun = dw_ip.GetItemString(1, 'gubun')
If IsNull(sGubun) Then sGubun = ''

If dw_print.retrieve(gs_sabu, sGubun+'%', duserate) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('userate')
	dw_ip.setfocus()
	Return -1
ELSE
	dw_print.ShareData(dw_list)
End if

Return 1
end function

on w_imt_04650.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_imt_04650
end type

type p_exit from w_standard_print`p_exit within w_imt_04650
end type

type p_print from w_standard_print`p_print within w_imt_04650
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04650
end type







type st_10 from w_standard_print`st_10 within w_imt_04650
end type



type dw_print from w_standard_print`dw_print within w_imt_04650
string dataobject = "d_imt_04650_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04650
integer x = 69
integer y = 40
integer width = 2080
integer height = 152
string dataobject = "d_imt_04650_1"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_04650
integer x = 78
integer y = 204
integer width = 4507
integer height = 2084
string dataobject = "d_imt_04650"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_imt_04650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 196
integer width = 4535
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

