$PBExportHeader$wp_pip61.srw
$PBExportComments$** 의보 / 연금 TABLE
forward
global type wp_pip61 from w_standard_print
end type
type rb_1 from radiobutton within wp_pip61
end type
type rb_2 from radiobutton within wp_pip61
end type
type st_1 from statictext within wp_pip61
end type
type rr_1 from roundrectangle within wp_pip61
end type
type rr_2 from roundrectangle within wp_pip61
end type
end forward

global type wp_pip61 from w_standard_print
integer x = 0
integer y = 0
string title = "의보 / 연금 TABLE"
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_1 rr_1
rr_2 rr_2
end type
global wp_pip61 wp_pip61

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_list.reset()

setpointer(hourglass!)

if dw_print.retrieve() < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	rb_1.setfocus()
	return -1
end if
   dw_print.sharedata(dw_list)
setpointer(arrow!)

//cb_print.enabled = true
//
///* Last page 구하는 routine */
//long Li_row = 1, Ll_prev_row
//
//dw_list.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = dw_list.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop
//
//dw_list.scrolltorow(1)
//dw_list.setredraw(true)

return 1
end function

on wp_pip61.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on wp_pip61.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;//w_mdi_frame.sle_msg.text = ''
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_list.dataobject = "dp_pip61_1"   // 국민연금
dw_list.settransobject(sqlca)
dw_print.dataobject = "dp_pip61_1_p"   // 국민연금
dw_print.settransobject(sqlca)
	
p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wp_pip61
integer x = 4091
integer y = 12
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pip61
integer x = 4439
integer y = 12
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pip61
integer x = 4265
integer y = 12
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip61
integer x = 3918
integer y = 12
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pip61
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pip61
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip61
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pip61
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pip61
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pip61
integer x = 3762
integer y = 32
string dataobject = "dp_pip61_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip61
boolean visible = false
integer x = 539
integer y = 2408
end type

type dw_list from w_standard_print`dw_list within wp_pip61
integer x = 736
integer y = 184
integer width = 3259
integer height = 2076
string dataobject = "dp_pip61_1"
boolean border = false
end type

type rb_1 from radiobutton within wp_pip61
integer x = 1129
integer y = 68
integer width = 357
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "국민연금"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;	dw_list.dataobject = "dp_pip61_1"   // 국민연금
	dw_list.settransobject(sqlca)
	dw_print.dataobject = "dp_pip61_1_p"   // 국민연금
	dw_print.settransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within wp_pip61
integer x = 1454
integer y = 68
integer width = 357
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "건강보험"
borderstyle borderstyle = stylelowered!
end type

event clicked;	dw_list.dataobject = "dp_pip61_2"   // 건강보험
	dw_list.settransobject(sqlca)
	dw_print.dataobject = "dp_pip61_2_p"   // 건강보험보험
	dw_print.settransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)

end event

type st_1 from statictext within wp_pip61
integer x = 768
integer y = 68
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within wp_pip61
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 745
integer y = 32
integer width = 1070
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within wp_pip61
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 718
integer y = 176
integer width = 3301
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

