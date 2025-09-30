$PBExportHeader$w_sal_02020_2.srw
$PBExportComments$수주관리 : 수주승인 처리(취소시 취소사유)
forward
global type w_sal_02020_2 from window
end type
type p_search from uo_picture within w_sal_02020_2
end type
type p_exit from uo_picture within w_sal_02020_2
end type
type dw_memo from datawindow within w_sal_02020_2
end type
end forward

global type w_sal_02020_2 from window
integer x = 823
integer y = 360
integer width = 1541
integer height = 516
boolean titlebar = true
string title = "사유 입력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_search p_search
p_exit p_exit
dw_memo dw_memo
end type
global w_sal_02020_2 w_sal_02020_2

on w_sal_02020_2.create
this.p_search=create p_search
this.p_exit=create p_exit
this.dw_memo=create dw_memo
this.Control[]={this.p_search,&
this.p_exit,&
this.dw_memo}
end on

on w_sal_02020_2.destroy
destroy(this.p_search)
destroy(this.p_exit)
destroy(this.dw_memo)
end on

event open;Long   nRow

f_window_center_response(this)

dw_memo.SetTransObject(sqlca)
nRow = dw_memo.InsertRow(0)

/* 수주취소(gs_gubun='4')일 경우 수주취소사유를 입력받는다 */
/* 수주보류(gs_gubun='3')일 경우 메모만 입력받는다 */
dw_memo.SetItem(nRow,'suju_sts', gs_gubun)
dw_memo.SetColumn('suju_sts')


end event

type p_search from uo_picture within w_sal_02020_2
integer x = 1079
integer y = 36
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;String sCancelCause

SetNull(gs_code)
SetNull(gs_codename)

If dw_memo.AcceptText() <> 1 Then Return

sCancelCause = dw_memo.GetItemString(1,'ord_cancel_cause')
If IsNull(sCancelCause) Then sCancelCause = ''

If IsNull(sCancelCause) or sCancelCause = '' Then
	f_message_chk(1400,'[수주취소/보류 사유]')
	Return
End If

gs_code     = sCancelCause
Close(w_sal_02020_2)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type p_exit from uo_picture within w_sal_02020_2
integer x = 1257
integer y = 36
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;CloseWithReturn(w_sal_02020_2,'cancel')
end event

type dw_memo from datawindow within w_sal_02020_2
integer x = 64
integer y = 196
integer width = 1394
integer height = 188
integer taborder = 10
string dataobject = "d_sal_020205"
boolean border = false
boolean livescroll = true
end type

