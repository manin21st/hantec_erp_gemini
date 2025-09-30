$PBExportHeader$w_qa00_00010_popup.srw
$PBExportComments$** 품질 기준 정보 등록
forward
global type w_qa00_00010_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_qa00_00010_popup
end type
type p_mod from uo_picture within w_qa00_00010_popup
end type
type p_can from uo_picture within w_qa00_00010_popup
end type
end forward

global type w_qa00_00010_popup from w_inherite_popup
integer x = 2235
integer y = 300
integer width = 1253
integer height = 1040
string title = "일괄지정"
dw_2 dw_2
p_mod p_mod
p_can p_can
end type
global w_qa00_00010_popup w_qa00_00010_popup

type variables
string  is_gubun // Y:특채담당자 처리
end variables

on w_qa00_00010_popup.create
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

on w_qa00_00010_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.p_mod)
destroy(this.p_can)
end on

event open;call super::open;if gs_gubun = '1' then 
	dw_2.DataObject = 'd_qa00_00010_popup_02'
elseif gs_gubun = '2' then 
	dw_2.DataObject = 'd_qa00_00010_popup_03'
else
	dw_2.DataObject = 'd_qa00_00010_popup_01'
end if
dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)
dw_2.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa00_00010_popup
boolean visible = false
integer x = 165
integer y = 904
integer width = 526
integer height = 152
end type

type p_exit from w_inherite_popup`p_exit within w_qa00_00010_popup
boolean visible = false
integer x = 850
integer y = 964
end type

type p_inq from w_inherite_popup`p_inq within w_qa00_00010_popup
boolean visible = false
integer x = 503
integer y = 964
end type

type p_choose from w_inherite_popup`p_choose within w_qa00_00010_popup
boolean visible = false
integer x = 677
integer y = 964
end type

type dw_1 from w_inherite_popup`dw_1 within w_qa00_00010_popup
boolean visible = false
integer x = 603
integer y = 1032
integer width = 361
integer height = 332
boolean hscrollbar = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_qa00_00010_popup
boolean visible = false
integer x = 407
integer y = 1056
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa00_00010_popup
boolean visible = false
integer x = 270
integer y = 800
integer width = 361
string text = "지정(&S)"
end type

type cb_return from w_inherite_popup`cb_return within w_qa00_00010_popup
boolean visible = false
integer x = 654
integer y = 800
integer width = 361
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa00_00010_popup
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

type sle_1 from w_inherite_popup`sle_1 within w_qa00_00010_popup
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_qa00_00010_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_qa00_00010_popup
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 168
integer width = 1157
integer height = 752
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa00_00010_popup_01"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;
// 수입검사 일괄저정 시 무검사일 경우 담당자를 공백으로 지정하도록 수정 - 20210325 by shingoon
Choose Case dwo.name
	Case 'gubun'
		If gs_gubun <> '2' Then Return  // 수입검사가 아니면 종료
		
		If data = '1' Then
			This.SetItem(row, 'empno', '')
		End If
End Choose
end event

type p_mod from uo_picture within w_qa00_00010_popup
integer x = 823
integer y = 16
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;str_qa_standard lst_qa

if dw_2.AcceptText() = -1 then return 

lst_qa.s_gubun = dw_2.GetItemString(1, "gubun")
lst_qa.s_empno = dw_2.GetItemString(1, "empno")
lst_qa.s_gigan = dw_2.GetItemDecimal(1, "gigan")
lst_qa.s_range = dw_2.GetItemDecimal(1, "range")
lst_qa.s_share = dw_2.GetItemDecimal(1, "share")
lst_qa.s_allow = dw_2.GetItemDecimal(1, "allow")
lst_qa.s_gigan2 = dw_2.GetItemDecimal(1, "gigan2")
lst_qa.s_range2 = dw_2.GetItemDecimal(1, "range2")

CloseWithReturn(Parent , lst_qa)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_qa00_00010_popup
integer x = 997
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

