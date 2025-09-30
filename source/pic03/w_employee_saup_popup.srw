$PBExportHeader$w_employee_saup_popup.srw
$PBExportComments$** 사원 조회 선택 - 사업장별
forward
global type w_employee_saup_popup from w_inherite_popup
end type
type sle_find from singlelineedit within w_employee_saup_popup
end type
type st_2 from statictext within w_employee_saup_popup
end type
type gb_2 from groupbox within w_employee_saup_popup
end type
type gb_1 from groupbox within w_employee_saup_popup
end type
type rr_1 from roundrectangle within w_employee_saup_popup
end type
type rb_3 from radiobutton within w_employee_saup_popup
end type
type rb_4 from radiobutton within w_employee_saup_popup
end type
type rb_5 from radiobutton within w_employee_saup_popup
end type
type rb_6 from radiobutton within w_employee_saup_popup
end type
type rb_1 from radiobutton within w_employee_saup_popup
end type
type rb_2 from radiobutton within w_employee_saup_popup
end type
end forward

global type w_employee_saup_popup from w_inherite_popup
integer x = 626
integer y = 12
integer width = 2661
integer height = 2288
string title = "사원 조회 선택"
boolean controlmenu = true
sle_find sle_find
st_2 st_2
gb_2 gb_2
gb_1 gb_1
rr_1 rr_1
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_1 rb_1
rb_2 rb_2
end type
global w_employee_saup_popup w_employee_saup_popup

type variables
String  sService,sDate_title
String scode,sname,sgubun
end variables

forward prototypes
public subroutine wf_retrieve ()
end prototypes

public subroutine wf_retrieve ();setnull(gs_code)
setnull(gs_codename)

scode = Gs_code
sname = Gs_codeName
sgubun = Gs_gubun

IF IsNull(scode) AND IsNull(sname)THEN
	sle_find.text = ""
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,'%','%',sSerVice,sDate_title,gs_gubun)
ELSEIF Not IsNull(scode) AND IsNull(sname)THEN
	sle_find.Text = scode
	rb_1.Checked = True
	dw_1.Retrieve(gs_company,scode + '%','%',sSerVice,sDate_title,gs_gubun)
ELSEIF IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text = sname
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,'%',sname + '%',sSerVice,sDate_title,gs_gubun)
ELSEIF Not IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text =""
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,scode + '%',sname + '%',sSerVice,sDate_title,gs_gubun)
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end subroutine

event open;call super::open;sSerVice = '1'
sDate_title = '입사일자'

rb_3.Checked = True

String ls_name

ls_name= message.stringparm
if IsNull(ls_name) or ls_name = '' then
   wf_retrieve()
   sle_find.SetFocus()
else
	wf_retrieve()
	sle_find.text = ls_name
	sle_find.Triggerevent(modified!)
end if
//dw_1.SetFocus()
end event

on w_employee_saup_popup.create
int iCurrent
call super::create
this.sle_find=create sle_find
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_find
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.rb_5
this.Control[iCurrent+9]=this.rb_6
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
end on

on w_employee_saup_popup.destroy
call super::destroy
destroy(this.sle_find)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_1)
destroy(this.rb_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_employee_saup_popup
boolean visible = false
integer x = 0
integer y = 2356
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_employee_saup_popup
integer x = 2437
integer y = 4
integer taborder = 50
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_employee_saup_popup
boolean visible = false
integer x = 1723
integer y = 2228
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_employee_saup_popup
integer x = 2263
integer y = 4
integer taborder = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_employee_saup_popup
integer x = 37
integer y = 160
integer width = 2569
integer height = 1992
string dataobject = "d_employee_saup_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
   dw_1.Setfocus()
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

gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_employee_saup_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_employee_saup_popup
boolean visible = false
integer x = 1934
integer y = 2228
end type

type cb_return from w_inherite_popup`cb_return within w_employee_saup_popup
boolean visible = false
integer x = 2569
integer y = 2236
end type

type cb_inq from w_inherite_popup`cb_inq within w_employee_saup_popup
boolean visible = false
integer x = 2254
integer y = 2228
end type

type sle_1 from w_inherite_popup`sle_1 within w_employee_saup_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_employee_saup_popup
boolean visible = false
end type

type sle_find from singlelineedit within w_employee_saup_popup
integer x = 192
integer y = 36
integer width = 338
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event getfocus;
IF rb_1.Checked = True THEN
	f_toggle_eng(handle(this))
ELSE
	f_toggle_kor(handle(this))
END IF
end event

event modified;string ls_findcol
long ll_findrow

dw_1.SetRedraw(False)
if rb_1.checked = True then
	ls_findcol = "#1"
else
	ls_findcol = "#2"
end if

IF sle_find.Text = "" OR IsNull(sle_find.text) THEN
	dw_1.Retrieve(gs_company,'%','%',sSerVice,sDate_title,sgubun)
ELSE
	if rb_1.checked = true then             //사번검색
		dw_1.retrieve(gs_company,'%'+trim(sle_find.text)+'%','%',sSerVice,sDate_title,sgubun)
	else                                    //성명검색
		dw_1.retrieve(gs_company,'%','%'+trim(sle_find.text)+'%',sSerVice,sDate_title,sgubun)
	end if
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

type st_2 from statictext within w_employee_saup_popup
integer x = 27
integer y = 56
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "찾기"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_employee_saup_popup
integer x = 549
integer width = 1079
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_1 from groupbox within w_employee_saup_popup
integer x = 1646
integer width = 590
integer height = 132
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_employee_saup_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 152
integer width = 2578
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

type rb_3 from radiobutton within w_employee_saup_popup
integer x = 608
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "재직"
boolean checked = true
end type

event clicked;sSerVice = '1'
sDate_title = '입사일자'

wf_retrieve()
end event

type rb_4 from radiobutton within w_employee_saup_popup
integer x = 855
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "휴직"
end type

event clicked;sSerVice = '2'
sDate_title = '휴직일자'

wf_retrieve()
end event

type rb_5 from radiobutton within w_employee_saup_popup
integer x = 1111
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "퇴직"
end type

event clicked;sSerVice = '3'
sDate_title = '퇴사일자'

wf_retrieve()
end event

type rb_6 from radiobutton within w_employee_saup_popup
integer x = 1344
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
end type

event clicked;sSerVice = '%'
sDate_title = '일자'

wf_retrieve()
end event

type rb_1 from radiobutton within w_employee_saup_popup
integer x = 1701
integer y = 44
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "코드"
end type

type rb_2 from radiobutton within w_employee_saup_popup
integer x = 1943
integer y = 44
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명"
boolean checked = true
end type

