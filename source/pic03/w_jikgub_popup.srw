$PBExportHeader$w_jikgub_popup.srw
$PBExportComments$** 직급 조회 선택
forward
global type w_jikgub_popup from w_inherite_popup
end type
type rb_1 from radiobutton within w_jikgub_popup
end type
type rb_2 from radiobutton within w_jikgub_popup
end type
type rb_3 from radiobutton within w_jikgub_popup
end type
type rr_1 from roundrectangle within w_jikgub_popup
end type
type rr_2 from roundrectangle within w_jikgub_popup
end type
end forward

global type w_jikgub_popup from w_inherite_popup
integer width = 1810
integer height = 2052
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rr_1 rr_1
rr_2 rr_2
end type
global w_jikgub_popup w_jikgub_popup

type variables
string sFlag
end variables

on w_jikgub_popup.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_jikgub_popup.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

event ue_ok;call super::ue_ok;long nRow
nRow = dw_1.getSelectedrow(0)

if nRow <= 0 then
	messagebox('확인','선택값이 없습니다. 다시 선택한후 버튼을 눌러 주세요.!')
	return
end if

gs_code = dw_1.getitemstring(nRow,'gradecode')
gs_codename = dw_1.getitemstring(nRow,'gradename')

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_jikgub_popup
boolean visible = false
integer x = 2235
integer y = 1816
integer width = 119
integer height = 80
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_jikgub_popup
integer x = 1591
integer y = 12
integer taborder = 20
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_jikgub_popup
boolean visible = false
integer x = 2235
integer y = 0
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_jikgub_popup
integer x = 1417
integer y = 12
integer taborder = 10
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
ELSE
	if dw_1.getitemstring(ll_Row,'gradetag') = '0' then
		messagebox('확인','사용되지 않는  직위 입니다.!!')
		return
	end if
end if

gs_code = dw_1.getitemstring(ll_Row,'gradecode')
gs_codename = dw_1.getitemstring(ll_Row,'gradename')

close(parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_jikgub_popup
integer x = 46
integer y = 168
integer width = 1719
integer height = 1744
string dataobject = "d_jikgub_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row <= 0 then 
	MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
ELSE
	if getitemstring(row,'gradetag') = '0' then
		messagebox('확인','사용되지 않는  직위 입니다.!!')
		return
	end if
end if

gs_code = dw_1.getitemstring(row,'gradecode')
gs_codename = dw_1.getitemstring(row,'gradename')

close(parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_jikgub_popup
integer x = 512
integer y = 2316
end type

type cb_1 from w_inherite_popup`cb_1 within w_jikgub_popup
integer x = 837
integer y = 2140
end type

event cb_1::clicked;call super::clicked;p_choose.Triggerevent(Clicked!)
end event

type cb_return from w_inherite_popup`cb_return within w_jikgub_popup
integer x = 1463
integer y = 2116
end type

event cb_return::clicked;call super::clicked;p_exit.Triggerevent(Clicked!)
end event

type cb_inq from w_inherite_popup`cb_inq within w_jikgub_popup
boolean visible = false
integer x = 1184
integer y = 2128
end type

type sle_1 from w_inherite_popup`sle_1 within w_jikgub_popup
integer x = 247
integer y = 2204
end type

type st_1 from w_inherite_popup`st_1 within w_jikgub_popup
integer x = 137
integer y = 2288
end type

type rb_1 from radiobutton within w_jikgub_popup
integer x = 91
integer y = 52
integer width = 279
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사용"
boolean checked = true
end type

event clicked;sFlag = '1'

dw_1.retrieve(sFlag)
end event

type rb_2 from radiobutton within w_jikgub_popup
integer x = 393
integer y = 60
integer width = 311
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "비사용"
end type

event clicked;sFlag = '0'

dw_1.retrieve(sFlag)
end event

type rb_3 from radiobutton within w_jikgub_popup
integer x = 727
integer y = 60
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체"
end type

event clicked;sFlag = '%'

dw_1.retrieve(sFlag)
end event

type rr_1 from roundrectangle within w_jikgub_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 28
integer width = 983
integer height = 120
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_jikgub_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 160
integer width = 1728
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 46
end type

