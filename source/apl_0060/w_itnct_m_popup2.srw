$PBExportHeader$w_itnct_m_popup2.srw
$PBExportComments$** 중분류코드 조회 선택(품목구분-제품,상품만)
forward
global type w_itnct_m_popup2 from w_inherite_popup
end type
type rb_1 from radiobutton within w_itnct_m_popup2
end type
type rb_2 from radiobutton within w_itnct_m_popup2
end type
type rr_1 from roundrectangle within w_itnct_m_popup2
end type
type rr_2 from roundrectangle within w_itnct_m_popup2
end type
end forward

global type w_itnct_m_popup2 from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 1915
integer height = 1840
string title = "중분류 코드 조회 선택"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_itnct_m_popup2 w_itnct_m_popup2

on w_itnct_m_popup2.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_itnct_m_popup2.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_itnct_m_popup2
boolean visible = false
integer x = 151
integer y = 1968
integer width = 59
integer height = 96
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_itnct_m_popup2
integer x = 1705
integer y = 8
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itnct_m_popup2
boolean visible = false
integer x = 416
integer y = 1968
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itnct_m_popup2
integer x = 1531
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun    = dw_1.GetItemString(ll_Row, "ittyp")
gs_code     = dw_1.GetItemString(ll_Row, "itcls")
gs_codename = dw_1.GetItemString(ll_Row, "titnm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itnct_m_popup2
integer x = 64
integer y = 184
integer width = 1815
integer height = 1556
integer taborder = 10
string dataobject = "d_itnct_m_popup2"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_gubun    = dw_1.GetItemString(Row, "ittyp")
gs_code     = dw_1.GetItemString(Row, "itcls")
gs_codename = dw_1.GetItemString(Row, "titnm")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itnct_m_popup2
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itnct_m_popup2
integer x = 887
integer y = 1872
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_itnct_m_popup2
integer x = 1202
integer y = 1880
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_itnct_m_popup2
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itnct_m_popup2
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_itnct_m_popup2
boolean visible = false
end type

type rb_1 from radiobutton within w_itnct_m_popup2
integer x = 110
integer y = 52
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "제품"
end type

event clicked;dw_1.Retrieve('1')   //품목구분이 제품
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type rb_2 from radiobutton within w_itnct_m_popup2
integer x = 462
integer y = 52
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "상품"
end type

event clicked;dw_1.Retrieve('6')   //품목구분이 상품
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type rr_1 from roundrectangle within w_itnct_m_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 20
integer width = 713
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_itnct_m_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 180
integer width = 1838
integer height = 1568
integer cornerheight = 40
integer cornerwidth = 55
end type

