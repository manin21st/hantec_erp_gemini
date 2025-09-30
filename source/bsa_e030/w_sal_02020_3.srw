$PBExportHeader$w_sal_02020_3.srw
$PBExportComments$수주승인 처리(수주상태 선택:multi selected row)
forward
global type w_sal_02020_3 from window
end type
type p_1 from uo_picture within w_sal_02020_3
end type
type st_1 from statictext within w_sal_02020_3
end type
type p_exit from uo_picture within w_sal_02020_3
end type
type dw_memo from datawindow within w_sal_02020_3
end type
type rb_4 from radiobutton within w_sal_02020_3
end type
type rb_3 from radiobutton within w_sal_02020_3
end type
type rb_2 from radiobutton within w_sal_02020_3
end type
type rb_1 from radiobutton within w_sal_02020_3
end type
type gb_1 from groupbox within w_sal_02020_3
end type
type rr_1 from roundrectangle within w_sal_02020_3
end type
end forward

global type w_sal_02020_3 from window
integer x = 823
integer y = 360
integer width = 1527
integer height = 804
boolean titlebar = true
string title = "사유 입력"
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
st_1 st_1
p_exit p_exit
dw_memo dw_memo
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
rr_1 rr_1
end type
global w_sal_02020_3 w_sal_02020_3

on w_sal_02020_3.create
this.p_1=create p_1
this.st_1=create st_1
this.p_exit=create p_exit
this.dw_memo=create dw_memo
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.st_1,&
this.p_exit,&
this.dw_memo,&
this.rb_4,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.gb_1,&
this.rr_1}
end on

on w_sal_02020_3.destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.p_exit)
destroy(this.dw_memo)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;dw_memo.SetTransObject(sqlca)
dw_memo.InsertRow(0)

dw_memo.SetItem(1,'suju_sts', '2')

dw_memo.SetFocus()

f_window_center(this)

end event

type p_1 from uo_picture within w_sal_02020_3
integer x = 1070
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;int rtn
String sCancelCause, sSujuSts

SetNull(gs_code)
SetNull(gs_codename)

If dw_memo.AcceptText() <> 1 Then Return

sSujuSts     = dw_memo.GetItemString(1,'suju_sts')
sCancelCause = dw_memo.GetItemString(1,'ord_cancel_cause')

If IsNull(sSujuSts) Then sSujuSts = ''
If IsNull(sCancelCause) Then sCancelCause = ''

If rb_4.Checked = True Or rb_3.Checked = True Then
	If IsNull(sCancelCause) or sCancelCause = '' Then
		f_message_chk(1400,'[수주취소/보류 사유]')
		Return
	End If
Else
	sCancelCause = ''
End If

gs_code     = sCancelCause   /* 수주취소사유 코드 */
gs_gubun    = sSujuSts       /* 수주상태 */

CloseWithReturn(w_sal_02020_3,gs_gubun)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type st_1 from statictext within w_sal_02020_3
integer x = 78
integer y = 440
integer width = 503
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "수주사유"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_sal_02020_3
integer x = 1243
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;CloseWithReturn(w_sal_02020_3,'0')
end event

type dw_memo from datawindow within w_sal_02020_3
integer x = 69
integer y = 492
integer width = 1390
integer height = 184
integer taborder = 30
string dataobject = "d_sal_020205"
boolean border = false
boolean livescroll = true
end type

type rb_4 from radiobutton within w_sal_02020_3
integer x = 1102
integer y = 276
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "취소"
borderstyle borderstyle = stylelowered!
end type

event clicked;st_1.Text = '취소 사유 입력'

dw_memo.SetItem(1,'suju_sts', '4')

dw_memo.SetFocus()

end event

type rb_3 from radiobutton within w_sal_02020_3
integer x = 809
integer y = 276
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "보류"
borderstyle borderstyle = stylelowered!
end type

event clicked;st_1.Text = '보류 사유 입력'

dw_memo.SetItem(1,'suju_sts', '3')

dw_memo.SetFocus()

end event

type rb_2 from radiobutton within w_sal_02020_3
integer x = 526
integer y = 276
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "승인"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_memo.SetItem(1,'suju_sts', '2')

dw_memo.SetFocus()

end event

type rb_1 from radiobutton within w_sal_02020_3
integer x = 238
integer y = 276
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "접수"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_memo.SetItem(1,'suju_sts', '1')

dw_memo.SetFocus()

end event

type gb_1 from groupbox within w_sal_02020_3
integer x = 133
integer y = 216
integer width = 1257
integer height = 156
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 33027312
string text = "수주상태"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_02020_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 73
integer y = 184
integer width = 1362
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

