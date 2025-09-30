$PBExportHeader$wp_pip65.srw
$PBExportComments$** 인건비현황
forward
global type wp_pip65 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pip65
end type
type rr_1 from roundrectangle within wp_pip65
end type
type st_2 from statictext within wp_pip65
end type
type rb_1 from radiobutton within wp_pip65
end type
type rb_2 from radiobutton within wp_pip65
end type
type rb_3 from radiobutton within wp_pip65
end type
type rb_4 from radiobutton within wp_pip65
end type
type rb_5 from radiobutton within wp_pip65
end type
type rb_6 from radiobutton within wp_pip65
end type
type rr_3 from roundrectangle within wp_pip65
end type
end forward

global type wp_pip65 from w_standard_print
integer x = 0
integer y = 0
string title = "인건비현황"
rr_2 rr_2
rr_1 rr_1
st_2 st_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rr_3 rr_3
end type
global wp_pip65 wp_pip65

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_year, s_pbtag

setpointer(hourglass!)
dw_ip.AcceptText()

s_pbtag = dw_ip.GetItemString(1,"s_pbtag")

IF s_pbtag = '' or Isnull(s_pbtag) then s_pbtag = '%'

ls_year = dw_ip.GetItemString(1,"syear")

if ls_year = '' or ls_year = '0000' then
	messagebox("확 인", "해당년도를 입력하세요.!", information!)
	dw_ip.Setcolumn('syear')
	dw_ip.setfocus()
	return -1
end if

if dw_print.retrieve(gs_company, ls_year, s_pbtag) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.Setcolumn('syear')
	dw_ip.setfocus()
	return -1
end if
  
  dw_print.sharedata(dw_list)
setpointer(arrow!)
return 1
end function

on wp_pip65.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.rb_5
this.Control[iCurrent+9]=this.rb_6
this.Control[iCurrent+10]=this.rr_3
end on

on wp_pip65.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rr_3)
end on

event open;call super::open;
dw_ip.insertrow(0)

dw_ip.Setitem(1,'syear',left(f_today(),4))


end event

type p_xls from w_standard_print`p_xls within wp_pip65
end type

type p_sort from w_standard_print`p_sort within wp_pip65
end type

type p_preview from w_standard_print`p_preview within wp_pip65
integer y = 20
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within wp_pip65
integer y = 20
end type

type p_print from w_standard_print`p_print within wp_pip65
integer y = 20
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip65
integer y = 20
end type

type st_window from w_standard_print`st_window within wp_pip65
boolean visible = false
integer x = 2505
integer y = 2876
end type

type sle_msg from w_standard_print`sle_msg within wp_pip65
boolean visible = false
integer x = 521
integer y = 2872
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip65
boolean visible = false
integer x = 2990
integer y = 2872
end type

type st_10 from w_standard_print`st_10 within wp_pip65
boolean visible = false
integer x = 160
integer y = 2872
end type

type gb_10 from w_standard_print`gb_10 within wp_pip65
boolean visible = false
integer x = 146
integer y = 2820
end type

type dw_print from w_standard_print`dw_print within wp_pip65
integer x = 3781
string dataobject = "dp_pip65_4_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip65
integer x = 219
integer y = 72
integer width = 1326
integer height = 88
string dataobject = "dp_pip65_0"
end type

type dw_list from w_standard_print`dw_list within wp_pip65
integer x = 23
integer y = 236
integer width = 4571
integer height = 2060
string dataobject = "dp_pip65_4"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pip65
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1646
integer y = 12
integer width = 1486
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within wp_pip65
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 142
integer y = 32
integer width = 1449
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within wp_pip65
integer x = 1723
integer y = 56
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within wp_pip65
integer x = 2016
integer y = 44
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "부서별"
boolean checked = true
end type

event clicked;dw_list.Dataobject = "dp_pip65_4"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_4_p"
dw_print.SetTransobject(sqlca)
end event

type rb_2 from radiobutton within wp_pip65
integer x = 2016
integer y = 128
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "직급별"
end type

event clicked;dw_list.Dataobject= "dp_pip65_1"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_1_p"
dw_print.SetTransobject(sqlca)
end event

type rb_3 from radiobutton within wp_pip65
integer x = 2336
integer y = 44
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "개인별"
end type

event clicked;dw_list.Dataobject= "dp_pip65_2"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_2_p"
dw_print.SetTransobject(sqlca)
end event

type rb_4 from radiobutton within wp_pip65
integer x = 2336
integer y = 128
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "사업장별"
end type

event clicked;dw_list.Dataobject= "dp_pip65_3"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_3_p"
dw_print.SetTransobject(sqlca)
end event

type rb_5 from radiobutton within wp_pip65
integer x = 2679
integer y = 44
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "근무구분별"
end type

event clicked;dw_list.Dataobject = "dp_pip65_5"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_5_p"
dw_print.SetTransobject(sqlca)
end event

type rb_6 from radiobutton within wp_pip65
integer x = 2679
integer y = 124
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "급여형태별"
end type

event clicked;dw_list.Dataobject = "dp_pip65_6"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "dp_pip65_6_p"
dw_print.SetTransobject(sqlca)
end event

type rr_3 from roundrectangle within wp_pip65
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 232
integer width = 4590
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

