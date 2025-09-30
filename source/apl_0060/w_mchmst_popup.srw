$PBExportHeader$w_mchmst_popup.srw
$PBExportComments$설비마스터 조회
forward
global type w_mchmst_popup from w_inherite_popup
end type
type st_2 from statictext within w_mchmst_popup
end type
type rb_1 from radiobutton within w_mchmst_popup
end type
type rb_2 from radiobutton within w_mchmst_popup
end type
type rb_3 from radiobutton within w_mchmst_popup
end type
type st_3 from statictext within w_mchmst_popup
end type
type st_4 from statictext within w_mchmst_popup
end type
type rr_1 from roundrectangle within w_mchmst_popup
end type
type rr_2 from roundrectangle within w_mchmst_popup
end type
end forward

global type w_mchmst_popup from w_inherite_popup
integer x = 539
integer y = 248
integer width = 3255
integer height = 1816
string title = "설비마스타 조회 선택"
st_2 st_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_3 st_3
st_4 st_4
rr_1 rr_1
rr_2 rr_2
end type
global w_mchmst_popup w_mchmst_popup

type variables
string  is_wkctr   //작업장
end variables

on w_mchmst_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_3=create st_3
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_mchmst_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;if gs_gubun = '' or isnull(gs_gubun) then  //작업장 코드
	is_wkctr  = '%' 
   st_4.text = '전체' 	
else
	is_wkctr  = gs_gubun
	IF ISNULL(gs_codename) THEN gs_codename = ' '	 	
   st_4.text = gs_gubun + ' ' + gs_codename	
end if

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mchmst_popup
boolean visible = false
integer x = 0
integer y = 1888
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_mchmst_popup
integer x = 3067
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mchmst_popup
integer x = 2720
end type

event p_inq::clicked;call super::clicked;
String scode,sname, sgubun

scode = sle_1.text
sname = sle_2.text

IF IsNull(scode) THEN scode =""
IF IsNull(sname) THEN sname = ""

IF scode ="" AND sname ="" THEN 
	scode = '%'
	sname = '%'
ELSEIF scode <> "" AND sname ="" THEN
	scode = scode +'%'
	sname = '%'
ELSEIF sname <> "" AND scode ="" THEN
	sname = sname + '%'
	scode = '%'
ELSEIF sname <> "" AND scode <>"" THEN
	sname = sname + '%'
	scode = scode + '%'
END IF


IF rb_1.Checked then 
	sgubun = '%'
ELSEIF rb_2.Checked then 	
	sgubun = 'Y'
ELSE
	sgubun = 'N'
END IF	

dw_1.Retrieve(gs_sabu, scode, sname, sgubun, is_wkctr)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_mchmst_popup
integer x = 2894
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "mchno")
gs_codename= dw_1.GetItemString(ll_row,"mchnam")

s_us_in	lstr_mchmst

lstr_mchmst.schk_bnk = dw_1.GetItemString(ll_Row, "mchno")
lstr_mchmst.schk_bnk2 = dw_1.GetItemString(ll_Row,"mchnam")
lstr_mchmst.spur_date = dw_1.GetItemString(ll_Row,"wrkctr_wcdsc")
lstr_mchmst.spur_date2 = dw_1.GetItemString(ll_Row,"mchmst_mdlnm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mchmst_popup
integer x = 32
integer y = 256
integer width = 3177
integer height = 1456
integer taborder = 30
string dataobject = "d_mchmst_popup"
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

gs_code= dw_1.GetItemString(Row, "mchno")
gs_codename= dw_1.GetItemString(row,"mchnam")

s_us_in	lstr_mchmst

lstr_mchmst.schk_bnk = dw_1.GetItemString(Row, "mchno")
lstr_mchmst.schk_bnk2 = dw_1.GetItemString(row,"mchnam")
lstr_mchmst.spur_date = dw_1.GetItemString(row,"wrkctr_wcdsc")
lstr_mchmst.spur_date2 = dw_1.GetItemString(row,"mchmst_mdlnm")
//lstr_mchmst.schk_gu = dw_1.GetItemString(row,"mchmst_spec")
//lstr_mchmst.schk_no1 = dw_1.GetItemString(row,"mchmst_jenam")
//lstr_mchmst.schk_no2 = dw_1.GetItemString(row,"mchmst_dptno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mchmst_popup
integer x = 759
integer y = 48
integer width = 672
boolean border = true
end type

event sle_2::getfocus;//IF dw_2.GetItemString(1,"rfgub") = '1' THEN
//	f_toggle_kor(Handle(this))
//ELSE
//	f_toggle_eng(Handle(this))
//END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_mchmst_popup
integer x = 2043
integer y = 1776
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_mchmst_popup
integer x = 2665
integer y = 1776
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_mchmst_popup
integer x = 2354
integer y = 1776
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mchmst_popup
integer x = 329
integer y = 48
integer width = 425
boolean border = true
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_mchmst_popup
integer x = 50
integer y = 60
integer width = 247
long backcolor = 33027312
string text = "설비코드"
alignment alignment = left!
end type

type st_2 from statictext within w_mchmst_popup
integer x = 50
integer y = 148
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "집계여부"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_mchmst_popup
integer x = 334
integer y = 148
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "ALL"
boolean checked = true
end type

type rb_2 from radiobutton within w_mchmst_popup
integer x = 594
integer y = 148
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "YES"
end type

type rb_3 from radiobutton within w_mchmst_popup
integer x = 869
integer y = 148
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "NO"
end type

type st_3 from statictext within w_mchmst_popup
integer x = 1435
integer y = 60
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "작업장"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_mchmst_popup
integer x = 1701
integer y = 52
integer width = 773
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_mchmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 28
integer width = 2578
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mchmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 252
integer width = 3200
integer height = 1468
integer cornerheight = 40
integer cornerwidth = 55
end type

