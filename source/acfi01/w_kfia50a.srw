$PBExportHeader$w_kfia50a.srw
$PBExportComments$차입금 상환계획 등록 - 조건
forward
global type w_kfia50a from window
end type
type dw_1 from u_key_enter within w_kfia50a
end type
type p_can from uo_picture within w_kfia50a
end type
type p_search from uo_picture within w_kfia50a
end type
type cb_cancel from commandbutton within w_kfia50a
end type
type cb_ok from commandbutton within w_kfia50a
end type
end forward

global type w_kfia50a from window
integer x = 1083
integer y = 752
integer width = 2254
integer height = 528
boolean titlebar = true
string title = "차입금 상환계획 이자율 변경"
windowtype windowtype = response!
long backcolor = 32106727
dw_1 dw_1
p_can p_can
p_search p_search
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_kfia50a w_kfia50a

on w_kfia50a.create
this.dw_1=create dw_1
this.p_can=create p_can
this.p_search=create p_search
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.dw_1,&
this.p_can,&
this.p_search,&
this.cb_cancel,&
this.cb_ok}
end on

on w_kfia50a.destroy
destroy(this.dw_1)
destroy(this.p_can)
destroy(this.p_search)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;String sLoCd,sLoName

sLoCd = Message.StringParm

F_Window_Center_Response(this)

dw_1.SetTransObject(Sqlca)
dw_1.Reset()

if dw_1.Retrieve(sLoCd,Left(f_today(),6)) <=0 then
	dw_1.InsertRow(0)
	
	select lo_name into :sLoName from kfm03ot0 where lo_cd = :sLoCd;
	
	dw_1.SetItem(1,"lo_cd",            sLoCd)
	dw_1.SetItem(1,"kfm03ot0_lo_name", sLoName)
	dw_1.SetItem(1,"rs_ym",            Left(f_today(),6))
end if

dw_1.SetColumn("lo_rate")
dw_1.SetFocus()

end event

type dw_1 from u_key_enter within w_kfia50a
integer x = 37
integer y = 156
integer width = 2194
integer height = 240
integer taborder = 10
string dataobject = "dw_kfia50a"
boolean border = false
end type

type p_can from uo_picture within w_kfia50a
integer x = 2025
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

CloseWithReturn(w_kfia50a,'0')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_search from uo_picture within w_kfia50a
integer x = 1851
integer y = 4
integer width = 178
integer taborder = 20
string picturename = "C:\Erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String sYm
Double dRate

dw_1.AcceptText()
sYm   = Trim(dw_1.GetItemString(1,"rs_ym"))
dRate = dw_1.GetItemNumber(1,"lo_rate")

IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[기준지급년월]')
	dw_1.SetColumn("rs_ym")
	dw_1.SetFocus()
	Return
END IF
IF dRate = 0 OR IsNull(dRate) THEN
	F_MessageChk(1,'[적용이율]')
	dw_1.SetColumn("lo_rate")
	dw_1.SetFocus()
	Return
END IF

if dw_1.Update() <> 1 then
	F_MessageChk(13,'')
	Rollback;
	Return
end if

CloseWithReturn(w_kfia50a,sYm+String(dRate,'000.00'))
end event

event ue_lbuttondown;PictureName = "C:\Erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\Erpman\image\확인_up.gif"
end event

type cb_cancel from commandbutton within w_kfia50a
integer x = 1664
integer y = 724
integer width = 274
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_ok from commandbutton within w_kfia50a
integer x = 1371
integer y = 724
integer width = 357
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Z)"
end type

event clicked;p_search.TriggerEvent(Clicked!)
end event

