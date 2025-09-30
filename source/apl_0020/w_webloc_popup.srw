$PBExportHeader$w_webloc_popup.srw
$PBExportComments$인터넷 즐겨찾기 조회
forward
global type w_webloc_popup from w_inherite_popup
end type
type p_1 from picture within w_webloc_popup
end type
end forward

global type w_webloc_popup from w_inherite_popup
integer width = 1280
integer height = 1680
boolean titlebar = false
event ue_del pbm_custom01
p_1 p_1
end type
global w_webloc_popup w_webloc_popup

type variables
string is_data, is_label
end variables

event ue_del;Long	ll_Row

IF is_data = '' Or IsNull(is_data) THEN REturn

ll_Row = dw_1.Find("window_name = '" + is_data + "'", 1, dw_1.RowCount())

dw_1.DeleteRow(ll_Row)

IF dw_1.Update() = -1 THEN
	Rollback ;
	MessageBox('확인', '삭제실패!!!')
	Return
END IF

Commit ;
end event

on w_webloc_popup.create
int iCurrent
call super::create
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
end on

on w_webloc_popup.destroy
call super::destroy
destroy(this.p_1)
end on

event open;call super::open;This.x = Long(gs_code) + 10
This.y = Long(gs_codename) + 75

dw_1.SetTransObject(sqlca)

dw_1.Retrieve(gs_userid)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_webloc_popup
boolean visible = false
integer x = 485
integer y = 1744
integer width = 73
integer height = 152
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_webloc_popup
boolean visible = false
integer x = 997
integer y = 1732
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_webloc_popup
boolean visible = false
integer x = 649
integer y = 1732
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_webloc_popup
boolean visible = false
integer x = 823
integer y = 1732
end type

event p_choose::clicked;call super::clicked;Long		ll_id
String	ls_path, ls_fullpath

select  dataname into :ls_path from syscnfg where sysgu = 'W' and  serial = 1 and lineno = 6 ;

Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row > 0 THEN
	
	
	ls_fullpath = dw_1.GetItemString(ll_Row, 'sub2_name')
	
	w_mdi_frame.sle_addr.text = ls_fullpath
	w_mdi_frame.sle_addr.PostEvent(Modified!)
END IF

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_webloc_popup
integer y = 16
integer width = 1243
integer height = 1516
string dataobject = "d_webloc_popup1"
end type

event dw_1::rbuttondown;Long					ll_Parent
m_popup2				lm_PopMenu
TreeViewItem		ltvi_Parent

lm_PopMenu = CREATE m_popup2

If row <= 0 Then
	lm_PopMenu.m_acction.m_add.Enabled = False
	lm_PopMenu.m_acction.m_open.Enabled = False
ELSE
	is_data = GetItemString(row, 'window_name')
	is_label = GetItemString(row, 'sub2_name')
	lm_PopMenu.is_window = is_data
End If

lm_PopMenu.m_acction.PopMenu(Parent.PointerX(), Parent.PointerY() )
end event

event dw_1::clicked;call super::clicked;Long		ll_id
String	ls_path, ls_fullpath

select  dataname into :ls_path from syscnfg where sysgu = 'W' and  serial = 1 and lineno = 6 ;

IF Row > 0 THEN
	ls_fullpath = dw_1.GetItemString(Row, 'web_url')
	
	w_mdi_frame.sle_addr.text = ls_fullpath
	w_mdi_frame.sle_addr.PostEvent(Modified!)
END IF

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_webloc_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_webloc_popup
end type

type cb_return from w_inherite_popup`cb_return within w_webloc_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_webloc_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_webloc_popup
end type

type st_1 from w_inherite_popup`st_1 within w_webloc_popup
end type

type p_1 from picture within w_webloc_popup
integer x = 18
integer y = 1552
integer width = 270
integer height = 80
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\닫기.gif"
boolean focusrectangle = false
end type

event clicked;Close(Parent)
end event

