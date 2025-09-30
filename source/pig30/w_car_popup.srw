$PBExportHeader$w_car_popup.srw
$PBExportComments$차량 popup
forward
global type w_car_popup from w_inherite_popup
end type
type rb_2 from radiobutton within w_car_popup
end type
type rb_1 from radiobutton within w_car_popup
end type
type gb_1 from groupbox within w_car_popup
end type
type rr_1 from roundrectangle within w_car_popup
end type
end forward

global type w_car_popup from w_inherite_popup
integer x = 1010
integer y = 24
integer width = 1422
integer height = 1832
string title = "차량 조회선택"
boolean controlmenu = true
event ue_open pbm_custom01
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
rr_1 rr_1
end type
global w_car_popup w_car_popup

type variables
String   sFlag
end variables

event ue_open;rb_1.Checked = True
rb_1.Post PostEvent(Clicked!)

end event

event open;call super::open;String schadae


This.TriggerEvent('ue_open')


end event

on w_car_popup.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_car_popup.destroy
call super::destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_car_popup
boolean visible = false
integer x = 0
integer y = 2356
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_car_popup
integer x = 1161
integer y = 1576
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_car_popup
boolean visible = false
integer x = 1614
integer y = 2196
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_car_popup
integer x = 987
integer y = 1576
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "carno")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_car_popup
integer x = 101
integer y = 216
integer width = 1166
integer height = 1332
string dataobject = "d_car_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "carno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_car_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_car_popup
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_car_popup
boolean visible = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_car_popup
boolean visible = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_car_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_car_popup
boolean visible = false
end type

type rb_2 from radiobutton within w_car_popup
integer x = 914
integer y = 84
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "개인"
end type

event clicked;sFlag = '2'

If dw_1.Retrieve(sflag) > 0 Then
	dw_1.SetFocus()
//	dw_1.SetRow(1)
	dw_1.SelectRow(1,TRUE)
End If

end event

type rb_1 from radiobutton within w_car_popup
integer x = 535
integer y = 84
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "회사"
boolean checked = true
end type

event clicked;sFlag = '1'

If dw_1.Retrieve(sflag) > 0 Then
	dw_1.SetFocus()
//	dw_1.SetRow(1)
	dw_1.SelectRow(1,TRUE)
End If

	
end event

type gb_1 from groupbox within w_car_popup
integer x = 55
integer y = 24
integer width = 1280
integer height = 160
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사용구분"
end type

type rr_1 from roundrectangle within w_car_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 212
integer width = 1280
integer height = 1364
integer cornerheight = 40
integer cornerwidth = 55
end type

