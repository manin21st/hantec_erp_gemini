$PBExportHeader$w_cfm_input.srw
$PBExportComments$수주확정일 입력 박스
forward
global type w_cfm_input from window
end type
type cb_2 from commandbutton within w_cfm_input
end type
type cb_1 from commandbutton within w_cfm_input
end type
type em_1 from editmask within w_cfm_input
end type
type gb_1 from groupbox within w_cfm_input
end type
end forward

global type w_cfm_input from window
integer x = 1097
integer y = 916
integer width = 736
integer height = 536
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 80859087
cb_2 cb_2
cb_1 cb_1
em_1 em_1
gb_1 gb_1
end type
global w_cfm_input w_cfm_input

on w_cfm_input.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_1=create em_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.em_1,&
this.gb_1}
end on

on w_cfm_input.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.gb_1)
end on

event open;f_window_center_response(this)

If gs_gubun = '2' then
	this.Title = '출고 확정일 입력'
	gb_1.text = '출고 확정일'
Else
	this.Title = '수주 확정일 입력'
	gb_1.text = '수주 확정일'
End If

em_1.Text = f_today()
end event

type cb_2 from commandbutton within w_cfm_input
integer x = 375
integer y = 312
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소"
end type

event clicked;Closewithreturn(Parent,'')
	
end event

type cb_1 from commandbutton within w_cfm_input
integer x = 91
integer y = 312
integer width = 247
integer height = 108
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인"
end type

event clicked;string sdate

sdate = Trim(em_1.text)
sdate = Left(sdate,4) + Mid(sdate,6,2) + Right(sdate,2)
If f_datechk(sdate) <> 1 Then
	f_message_chk(35,sdate)
	em_1.setFocus()
	Return
END IF
	
Closewithreturn(Parent,sdate)

	
end event

type em_1 from editmask within w_cfm_input
integer x = 119
integer y = 156
integer width = 425
integer height = 76
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type gb_1 from groupbox within w_cfm_input
integer x = 91
integer y = 56
integer width = 539
integer height = 228
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 80859087
string text = "수주 확정일"
borderstyle borderstyle = stylelowered!
end type

