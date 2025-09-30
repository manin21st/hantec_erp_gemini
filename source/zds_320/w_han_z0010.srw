$PBExportHeader$w_han_z0010.srw
$PBExportComments$유사 item 등록
forward
global type w_han_z0010 from w_inherite
end type
type dw_ret from datawindow within w_han_z0010
end type
type rr_1 from roundrectangle within w_han_z0010
end type
end forward

global type w_han_z0010 from w_inherite
string title = "유사 ITEM 등록"
dw_ret dw_ret
rr_1 rr_1
end type
global w_han_z0010 w_han_z0010

event open;call super::open;This.PostEvent('ue_open')
end event

on w_han_z0010.create
int iCurrent
call super::create
this.dw_ret=create dw_ret
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ret
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_z0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ret)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ret.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_han_z0010
integer x = 50
integer y = 212
integer width = 4553
integer height = 2020
integer taborder = 120
string dataobject = "d_han_z0010_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_han_z0010
boolean visible = false
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_han_z0010
boolean visible = false
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_han_z0010
boolean visible = false
integer taborder = 100
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_han_z0010
boolean visible = false
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_han_z0010
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_han_z0010
integer taborder = 80
end type

event p_can::clicked;call super::clicked;dw_ret.ReSet()
dw_insert.ReSet()

dw_ret.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_han_z0010
boolean visible = false
integer taborder = 110
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_han_z0010
end type

event p_inq::clicked;call super::clicked;dw_ret.AcceptText()

String   ls_itm
ls_itm = dw_ret.GetItemString(1, 'frmitem')
If Trim(ls_itm) = '' Or IsNull(ls_itm) Then
	ls_itm = '%'
Else
	ls_itm = ls_itm + '%'
End If

String   ls_vnd
ls_vnd = dw_ret.GetItemString(1, 'frmvnd')
If Trim(ls_vnd) = '' Or IsNull(ls_vnd) Then ls_vnd = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_itm, ls_vnd)
dw_insert.SetRedraw(True)


end event

type p_del from w_inherite`p_del within w_han_z0010
boolean visible = false
integer taborder = 70
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_han_z0010
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('확인', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('확인', '자료 저장 중 오류가 발생 했습니다.')
	Return
End If

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_han_z0010
end type

type cb_mod from w_inherite`cb_mod within w_han_z0010
end type

type cb_ins from w_inherite`cb_ins within w_han_z0010
end type

type cb_del from w_inherite`cb_del within w_han_z0010
end type

type cb_inq from w_inherite`cb_inq within w_han_z0010
end type

type cb_print from w_inherite`cb_print within w_han_z0010
end type

type st_1 from w_inherite`st_1 within w_han_z0010
end type

type cb_can from w_inherite`cb_can within w_han_z0010
end type

type cb_search from w_inherite`cb_search within w_han_z0010
end type







type gb_button1 from w_inherite`gb_button1 within w_han_z0010
end type

type gb_button2 from w_inherite`gb_button2 within w_han_z0010
end type

type dw_ret from datawindow within w_han_z0010
integer x = 23
integer y = 32
integer width = 2021
integer height = 156
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_z0010_ret"
boolean border = false
end type

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

If row < 1 Then Return

Choose Case dwo.name
	Case 'frmvnd'
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'frmvnd'   , gs_code    )
		This.SetItem(row, 'frmvndnam', gs_codename)
		
	Case 'frmitem'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' Or IsNull(gs_code) Then Return
		
		This.SetItem(row, 'frmitem', gs_code)

End Choose

end event

event itemchanged;If row < 1 Then Return

String  ls_nam

Choose Case dwo.name
	Case 'frmvnd'
		If Trim(data) = '' Or IsNull(data) Then
			This.SetItem(row, 'frmvndnam', '')
			Return
		End If
		
		SELECT CVNAS
		  INTO :ls_nam
		  FROM VNDMST
		 WHERE CVCOD = :data ;
		If SQLCA.SQLCODE <> 0 OR IsNull(ls_nam) OR Trim(ls_nam) = '' Then
			MessageBox('확인', '등록되지 않은 거래처 입니다.')
			Return
		End If
		
		This.SetItem(row, 'rfmvndnam', ls_nam)
		
	Case 'frmitem'
		If Trim(data) = '' Or IsNull(data) Then Return
		
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_nam
		  FROM ITEMAS
		 WHERE ITNBR = :data ;
		If SQLCA.SQLCODE <> 0 OR ls_nam <> 'Y' Then
			MessageBox('확인', '등록되지 않은 품번 입니다.')
			Return
		End If
End Choose
end event

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_han_z0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4576
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

