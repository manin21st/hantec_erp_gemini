$PBExportHeader$w_kcda09a.srw
$PBExportComments$원가손익부서 조회선택
forward
global type w_kcda09a from window
end type
type dw_1 from u_d_popup_sort within w_kcda09a
end type
type cb_1 from commandbutton within w_kcda09a
end type
type cb_can from commandbutton within w_kcda09a
end type
type cb_return from commandbutton within w_kcda09a
end type
type st_1 from statictext within w_kcda09a
end type
type sle_name from singlelineedit within w_kcda09a
end type
type sle_1 from singlelineedit within w_kcda09a
end type
end forward

global type w_kcda09a from window
integer x = 1234
integer y = 12
integer width = 2418
integer height = 2372
boolean titlebar = true
string title = "손익부서조회"
windowtype windowtype = response!
long backcolor = 12632256
dw_1 dw_1
cb_1 cb_1
cb_can cb_can
cb_return cb_return
st_1 st_1
sle_name sle_name
sle_1 sle_1
end type
global w_kcda09a w_kcda09a

type variables
long rownum

end variables

event open;f_window_center_response(this)
String ls_saup,saup_nm,ls_saupgu

sle_1.text=Left(gs_code,6)
ls_saup =Trim(sle_1.text)+"%"

sle_name.text =gs_codename
saup_nm =Trim(sle_name.text)+"%"

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_1.retrieve(ls_saup,saup_nm)
dw_1.Setfocus()





end event

on w_kcda09a.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_can=create cb_can
this.cb_return=create cb_return
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.Control[]={this.dw_1,&
this.cb_1,&
this.cb_can,&
this.cb_return,&
this.st_1,&
this.sle_name,&
this.sle_1}
end on

on w_kcda09a.destroy
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_can)
destroy(this.cb_return)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
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

type dw_1 from u_d_popup_sort within w_kcda09a
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 112
integer width = 2304
integer height = 2040
integer taborder = 30
string dataobject = "dw_kcda09a"
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

event ue_enterkey;cb_1.TriggerEvent(Clicked!)
end event

event doubleclicked;
IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(row, "cost_cd")
gs_codename = dw_1.GetItemString(row,"cost_nm")

Close(Parent)

end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

	sle_1.text =dw_1.GetItemString(Row,"cost_cd")
	sle_name.text =dw_1.GetItemString(Row,"cost_nm")
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type cb_1 from commandbutton within w_kcda09a
integer x = 1431
integer y = 2176
integer width = 293
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;Long  row

Row = dw_1.GetSelectedRow(0)

IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(row, "cost_cd")
gs_codename = dw_1.GetItemString(row,"cost_nm")


Close(Parent)

end event

type cb_can from commandbutton within w_kcda09a
integer x = 2053
integer y = 2176
integer width = 293
integer height = 96
integer taborder = 60
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
SetNull(gs_codename)

Close(Parent)
end event

type cb_return from commandbutton within w_kcda09a
integer x = 1742
integer y = 2176
integer width = 293
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
boolean default = true
end type

event clicked;String ls_saup_no,ls_saupnm,s_sgu,s_tgu

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_name.text)+"%"

IF dw_1.Retrieve(ls_saup_no,ls_saupnm,s_sgu,s_tgu) <=0 THEN
	MessageBox("확  인","해당하는 부서가 존재하지 않습니다.!!!")
	Return
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type st_1 from statictext within w_kcda09a
integer x = 55
integer y = 36
integer width = 229
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "부  서"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kcda09a
integer x = 521
integer y = 20
integer width = 818
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
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

type sle_1 from singlelineedit within w_kcda09a
integer x = 297
integer y = 20
integer width = 224
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
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

