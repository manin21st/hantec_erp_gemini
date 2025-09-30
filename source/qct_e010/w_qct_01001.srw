$PBExportHeader$w_qct_01001.srw
$PBExportComments$검사기준등록(일괄지정)
forward
global type w_qct_01001 from w_inherite_popup
end type
type dw_2 from datawindow within w_qct_01001
end type
type p_mod from uo_picture within w_qct_01001
end type
type p_can from uo_picture within w_qct_01001
end type
end forward

global type w_qct_01001 from w_inherite_popup
integer x = 2235
integer y = 300
integer width = 1166
integer height = 784
string title = "일괄지정"
dw_2 dw_2
p_mod p_mod
p_can p_can
end type
global w_qct_01001 w_qct_01001

type variables
string  is_gubun // Y:특채담당자 처리
end variables

on w_qct_01001.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.p_mod=create p_mod
this.p_can=create p_can
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.p_mod
this.Control[iCurrent+3]=this.p_can
end on

on w_qct_01001.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.p_mod)
destroy(this.p_can)
end on

event open;call super::open;if gs_gubun = '2' then 
	is_gubun = 'N'
	dw_2.DataObject = 'd_qct_01001_21'
else
	is_gubun = 'Y'
	dw_2.DataObject = 'd_qct_01001_2'
end if
dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)
dw_2.SetFocus()

f_child_saupj(dw_2, 'empno', gs_saupj)
f_child_saupj(dw_2, 'empno2', gs_saupj)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qct_01001
boolean visible = false
integer x = 165
integer y = 904
integer width = 526
integer height = 152
end type

type p_exit from w_inherite_popup`p_exit within w_qct_01001
boolean visible = false
integer x = 850
integer y = 964
end type

type p_inq from w_inherite_popup`p_inq within w_qct_01001
boolean visible = false
integer x = 503
integer y = 964
end type

type p_choose from w_inherite_popup`p_choose within w_qct_01001
boolean visible = false
integer x = 677
integer y = 964
end type

type dw_1 from w_inherite_popup`dw_1 within w_qct_01001
boolean visible = false
integer x = 603
integer y = 1032
integer width = 361
integer height = 332
boolean hscrollbar = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_qct_01001
boolean visible = false
integer x = 407
integer y = 1056
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_qct_01001
boolean visible = false
integer x = 270
integer y = 800
integer width = 361
string text = "지정(&S)"
end type

type cb_return from w_inherite_popup`cb_return within w_qct_01001
boolean visible = false
integer x = 654
integer y = 800
integer width = 361
end type

type cb_inq from w_inherite_popup`cb_inq within w_qct_01001
boolean visible = false
integer x = 457
integer y = 888
end type

event cb_inq::clicked;
String sdatef,sdatet

dw_2.AcceptText()

sdatef = dw_2.GetItemString(1,"fr_date")
sdatet = dw_2.GetItemString(1,"to_date")


IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF


IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet, gs_gubun) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_qct_01001
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_qct_01001
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_qct_01001
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 5
integer y = 168
integer width = 1120
integer height = 488
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_01001_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

type p_mod from uo_picture within w_qct_01001
integer x = 745
integer y = 16
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;
if dw_2.AcceptText() = -1 then return 

gs_code		= dw_2.GetItemString(1, "gubun")
gs_codename = dw_2.GetItemString(1, "empno")

if is_gubun = 'Y' then 
	gs_gubun = dw_2.GetItemString(1, "empno2")
	gs_codename2 = dw_2.GetItemString(1, "grpno2")
end if

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_qct_01001
integer x = 919
integer y = 16
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

