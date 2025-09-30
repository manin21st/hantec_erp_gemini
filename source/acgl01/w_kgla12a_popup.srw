$PBExportHeader$w_kgla12a_popup.srw
$PBExportComments$거래처 기초잔액 등록-거래처 선택
forward
global type w_kgla12a_popup from window
end type
type p_search from uo_picture within w_kgla12a_popup
end type
type p_can from uo_picture within w_kgla12a_popup
end type
type p_inq from uo_picture within w_kgla12a_popup
end type
type st_5 from statictext within w_kgla12a_popup
end type
type cb_1 from commandbutton within w_kgla12a_popup
end type
type cb_can from commandbutton within w_kgla12a_popup
end type
type cb_return from commandbutton within w_kgla12a_popup
end type
type st_1 from statictext within w_kgla12a_popup
end type
type sle_name from singlelineedit within w_kgla12a_popup
end type
type sle_1 from singlelineedit within w_kgla12a_popup
end type
type gb_2 from groupbox within w_kgla12a_popup
end type
type dw_1 from datawindow within w_kgla12a_popup
end type
type rr_1 from roundrectangle within w_kgla12a_popup
end type
type rr_2 from roundrectangle within w_kgla12a_popup
end type
type ln_1 from line within w_kgla12a_popup
end type
type ln_2 from line within w_kgla12a_popup
end type
end forward

global type w_kgla12a_popup from window
integer x = 407
integer y = 4
integer width = 3337
integer height = 2308
boolean titlebar = true
string title = "거래처 조회"
windowtype windowtype = response!
long backcolor = 32106727
p_search p_search
p_can p_can
p_inq p_inq
st_5 st_5
cb_1 cb_1
cb_can cb_can
cb_return cb_return
st_1 st_1
sle_name sle_name
sle_1 sle_1
gb_2 gb_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
end type
global w_kgla12a_popup w_kgla12a_popup

type variables
String          sCusGbn

end variables

event open;String       ls_saup,saup_nm

F_Window_Center_Response(This)

sCusGbn = Message.StringParm

sle_1.text=Left(lstr_custom.code,20)
ls_saup =Trim(sle_1.text)+"%"

sle_name.text =lstr_custom.name
saup_nm =Trim(sle_name.text)+"%"

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sle_name.SetFocus()

p_inq.triggerevent(clicked!)



end event

on w_kgla12a_popup.create
this.p_search=create p_search
this.p_can=create p_can
this.p_inq=create p_inq
this.st_5=create st_5
this.cb_1=create cb_1
this.cb_can=create cb_can
this.cb_return=create cb_return
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.gb_2=create gb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.p_search,&
this.p_can,&
this.p_inq,&
this.st_5,&
this.cb_1,&
this.cb_can,&
this.cb_return,&
this.st_1,&
this.sle_name,&
this.sle_1,&
this.gb_2,&
this.dw_1,&
this.rr_1,&
this.rr_2,&
this.ln_1,&
this.ln_2}
end on

on w_kgla12a_popup.destroy
destroy(this.p_search)
destroy(this.p_can)
destroy(this.p_inq)
destroy(this.st_5)
destroy(this.cb_1)
destroy(this.cb_can)
destroy(this.cb_return)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type p_search from uo_picture within w_kgla12a_popup
integer x = 2917
integer y = 12
integer width = 178
integer taborder = 90
boolean originalsize = true
string picturename = "C:\Erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;
dw_1.SetFilter("chk = 'Y'")
dw_1.Filter()

dw_1.SaveAs('',Clipboard!,False)
CloseWithReturn(Parent,'1')

end event

event ue_lbuttondown;PictureName = "C:\Erpman\image\선택_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\Erpman\image\선택_up.gif"
end event

type p_can from uo_picture within w_kgla12a_popup
integer x = 3095
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;
CloseWithReturn(Parent,'0')
end event

type p_inq from uo_picture within w_kgla12a_popup
integer x = 2738
integer y = 12
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String ls_saup_no,ls_saupnm

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_name.text)+"%"

dw_1.SetFilter('')
dw_1.Filter()

IF dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn) <=0 THEN
	MessageBox("확  인","해당하는 구분에 거래처가 존재하지 않습니다.!!!")
	Return
END IF

end event

type st_5 from statictext within w_kgla12a_popup
integer x = 791
integer y = 60
integer width = 137
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "명칭"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_kgla12a_popup
boolean visible = false
integer x = 2226
integer y = 2384
integer width = 293
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;
dw_1.SetFilter("chk = 'Y'")
dw_1.Filter()

dw_1.SaveAs('',Clipboard!,False)
CloseWithReturn(Parent,'1')

end event

type cb_can from commandbutton within w_kgla12a_popup
boolean visible = false
integer x = 2848
integer y = 2384
integer width = 293
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;
CloseWithReturn(Parent,'0')
end event

type cb_return from commandbutton within w_kgla12a_popup
boolean visible = false
integer x = 2533
integer y = 2384
integer width = 293
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
boolean default = true
end type

event clicked;String ls_saup_no,ls_saupnm

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_name.text)+"%"

dw_1.SetFilter('')
dw_1.Filter()

IF dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn) <=0 THEN
	MessageBox("확  인","해당하는 구분에 거래처가 존재하지 않습니다.!!!")
	Return
END IF

end event

type st_1 from statictext within w_kgla12a_popup
integer x = 87
integer y = 60
integer width = 146
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "코드"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kgla12a_popup
integer x = 937
integer y = 44
integer width = 1531
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

on modified;//if KeyDown(KeyEnter!)  = TRUE then 
//   dw_1.Retrieve( "%" , "%" + sle_name.TEXT + "%" )
//   if dw_1.RowCount() = 0 then
//      sle_message.SHOW()
//      sle_message.TEXT = "데이타가 존재하지 않음!"
//   else
//      sle_1.SetFocus()
//      sle_message.HIDE() 
//   end if
//end if

end on

event getfocus;f_toggle_kor(Handle(this))
end event

type sle_1 from singlelineedit within w_kgla12a_popup
integer x = 233
integer y = 44
integer width = 535
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
end type

on modified;//if KeyDown(KeyEnter!)  = TRUE then 
//   dw_1.Retrieve( sle_1.TEXT + "%" ,  "%" )
//   if dw_1.RowCount() = 0 then
//      sle_message.SHOW()
//      sle_message.TEXT = "데이타가 존재하지 않음!"
//   else
//      sle_1.SetFocus()
//      sle_message.HIDE()
//   end if
//end if

end on

event getfocus;
f_toggle_eng(Handle(this))
end event

type gb_2 from groupbox within w_kgla12a_popup
boolean visible = false
integer x = 2194
integer y = 2332
integer width = 983
integer height = 172
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kgla12a_popup
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 69
integer y = 192
integer width = 3186
integer height = 1996
string dataobject = "dw_kgla12a_popup"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event ue_enter;p_search.triggerEvent(clicked!)
end event

type rr_1 from roundrectangle within w_kgla12a_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 16
integer width = 2501
integer height = 144
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kgla12a_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 184
integer width = 3209
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kgla12a_popup
integer linethickness = 1
integer beginx = 242
integer beginy = 120
integer endx = 768
integer endy = 120
end type

type ln_2 from line within w_kgla12a_popup
integer linethickness = 1
integer beginx = 951
integer beginy = 120
integer endx = 2469
integer endy = 120
end type

