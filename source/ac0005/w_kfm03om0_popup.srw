$PBExportHeader$w_kfm03om0_popup.srw
$PBExportComments$약정번호 조회 선택
forward
global type w_kfm03om0_popup from window
end type
type dw_1 from u_d_popup_sort within w_kfm03om0_popup
end type
type cb_1 from commandbutton within w_kfm03om0_popup
end type
type cb_can from commandbutton within w_kfm03om0_popup
end type
type cb_return from commandbutton within w_kfm03om0_popup
end type
type st_1 from statictext within w_kfm03om0_popup
end type
type sle_1 from singlelineedit within w_kfm03om0_popup
end type
type gb_1 from groupbox within w_kfm03om0_popup
end type
end forward

global type w_kfm03om0_popup from window
integer x = 293
integer y = 4
integer width = 3360
integer height = 2352
boolean titlebar = true
string title = "약정번호 조회 선택"
windowtype windowtype = response!
long backcolor = 12632256
dw_1 dw_1
cb_1 cb_1
cb_can cb_can
cb_return cb_return
st_1 st_1
sle_1 sle_1
gb_1 gb_1
end type
global w_kfm03om0_popup w_kfm03om0_popup

type variables
long    rownum
String  sProcGbn
end variables

event open;String scode,sname

F_Window_Center_Response(This)

sProcGbn = Message.StringParm

scode = gs_code

sle_1.text = gs_code

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Retrieve(sCode+'%')

dw_1.SetFocus()



end event

on w_kfm03om0_popup.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_can=create cb_can
this.cb_return=create cb_return
this.st_1=create st_1
this.sle_1=create sle_1
this.gb_1=create gb_1
this.Control[]={this.dw_1,&
this.cb_1,&
this.cb_can,&
this.cb_return,&
this.st_1,&
this.sle_1,&
this.gb_1}
end on

on w_kfm03om0_popup.destroy
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_can)
destroy(this.cb_return)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.gb_1)
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

type dw_1 from u_d_popup_sort within w_kfm03om0_popup
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 41
integer y = 128
integer width = 3273
integer height = 1936
integer taborder = 20
string dataobject = "dw_kfm03om0_popup"
boolean hscrollbar = true
boolean vscrollbar = true
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

event ue_keyenter;cb_1.TriggerEvent(Clicked!)
end event

event doubleclicked;IF row <=0 THEN RETURN

gs_code= dw_1.GetItemString(Row, "lo_no")

Close(Parent)


end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text =dw_1.GetItemString(Row,"lo_no")

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type cb_1 from commandbutton within w_kfm03om0_popup
integer x = 2377
integer y = 2108
integer width = 288
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "lo_no")

Close(Parent)

end event

type cb_can from commandbutton within w_kfm03om0_popup
integer x = 2994
integer y = 2108
integer width = 288
integer height = 100
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

event clicked;SetNull(gs_code)

Close(Parent)
end event

type cb_return from commandbutton within w_kfm03om0_popup
integer x = 2688
integer y = 2108
integer width = 288
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;String scode

scode = sle_1.text + "%"

IF dw_1.Retrieve(scode) <= 0 THEN
	MessageBox("확 인","조회할 자료가 없습니다.!!!")
	sle_1.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end event

type st_1 from statictext within w_kfm03om0_popup
integer x = 46
integer y = 48
integer width = 288
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "약정번호"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfm03om0_popup
integer x = 338
integer y = 28
integer width = 864
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

type gb_1 from groupbox within w_kfm03om0_popup
integer x = 2341
integer y = 2060
integer width = 974
integer height = 168
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

