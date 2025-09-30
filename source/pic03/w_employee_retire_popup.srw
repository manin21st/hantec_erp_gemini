$PBExportHeader$w_employee_retire_popup.srw
$PBExportComments$** 사원 조회 선택
forward
global type w_employee_retire_popup from window
end type
type p_choose from uo_picture within w_employee_retire_popup
end type
type p_inq from uo_picture within w_employee_retire_popup
end type
type p_exit from uo_picture within w_employee_retire_popup
end type
type rb_6 from radiobutton within w_employee_retire_popup
end type
type rb_5 from radiobutton within w_employee_retire_popup
end type
type rb_4 from radiobutton within w_employee_retire_popup
end type
type rb_3 from radiobutton within w_employee_retire_popup
end type
type rb_2 from radiobutton within w_employee_retire_popup
end type
type rb_1 from radiobutton within w_employee_retire_popup
end type
type sle_find from singlelineedit within w_employee_retire_popup
end type
type st_1 from statictext within w_employee_retire_popup
end type
type cb_1 from commandbutton within w_employee_retire_popup
end type
type cb_return from commandbutton within w_employee_retire_popup
end type
type dw_1 from u_d_popup_sort within w_employee_retire_popup
end type
type gb_2 from groupbox within w_employee_retire_popup
end type
type gb_1 from groupbox within w_employee_retire_popup
end type
type rr_1 from roundrectangle within w_employee_retire_popup
end type
end forward

global type w_employee_retire_popup from window
integer x = 626
integer y = 12
integer width = 2661
integer height = 2272
boolean titlebar = true
string title = "퇴직정산자 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_choose p_choose
p_inq p_inq
p_exit p_exit
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
sle_find sle_find
st_1 st_1
cb_1 cb_1
cb_return cb_return
dw_1 dw_1
gb_2 gb_2
gb_1 gb_1
rr_1 rr_1
end type
global w_employee_retire_popup w_employee_retire_popup

type variables
String  sService,sDate_title
end variables

forward prototypes
public subroutine wf_retrieve ()
end prototypes

public subroutine wf_retrieve ();String scode,sname

setnull(gs_code)
setnull(gs_codename)

scode = Gs_code
sname = Gs_codeName

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

event open;f_window_center_response(this)
//String scode,sname

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sSerVice = '%'
sDate_title = '정산일자'

rb_6.Checked = True

wf_retrieve()

sle_find.SetFocus()
//dw_1.SetFocus()
end event

on w_employee_retire_popup.create
this.p_choose=create p_choose
this.p_inq=create p_inq
this.p_exit=create p_exit
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.sle_find=create sle_find
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_return=create cb_return
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.p_choose,&
this.p_inq,&
this.p_exit,&
this.rb_6,&
this.rb_5,&
this.rb_4,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.sle_find,&
this.st_1,&
this.cb_1,&
this.cb_return,&
this.dw_1,&
this.gb_2,&
this.gb_1,&
this.rr_1}
end on

on w_employee_retire_popup.destroy
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.p_exit)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event key;choose case key
	case keyenter!
		sle_find.TriggerEvent(Modified!)
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

type p_choose from uo_picture within w_employee_retire_popup
integer x = 2263
integer y = 4
integer width = 178
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

event clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)


end event

type p_inq from uo_picture within w_employee_retire_popup
boolean visible = false
integer x = 1929
integer y = 2352
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type p_exit from uo_picture within w_employee_retire_popup
integer x = 2437
integer y = 4
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type rb_6 from radiobutton within w_employee_retire_popup
integer x = 1344
integer y = 44
integer width = 251
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;sSerVice = '%'
sDate_title = '일자'

wf_retrieve()
end event

type rb_5 from radiobutton within w_employee_retire_popup
integer x = 1111
integer y = 44
integer width = 251
integer height = 76
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

type rb_4 from radiobutton within w_employee_retire_popup
integer x = 855
integer y = 44
integer width = 251
integer height = 76
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

type rb_3 from radiobutton within w_employee_retire_popup
integer x = 608
integer y = 44
integer width = 251
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "재직"
end type

event clicked;sSerVice = '1'
sDate_title = '입사일자'

wf_retrieve()
end event

type rb_2 from radiobutton within w_employee_retire_popup
integer x = 1943
integer y = 44
integer width = 247
integer height = 76
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

type rb_1 from radiobutton within w_employee_retire_popup
integer x = 1701
integer y = 44
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "코드"
end type

type sle_find from singlelineedit within w_employee_retire_popup
integer x = 192
integer y = 36
integer width = 338
integer height = 84
integer taborder = 10
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

event modified;string ls_findcol
long ll_findrow

dw_1.SetRedraw(False)
if rb_1.checked = True then
	ls_findcol = "#1"
else
	ls_findcol = "#2"
end if

IF sle_find.Text = "" OR IsNull(sle_find.text) THEN
	dw_1.Retrieve(gs_company,'%','%',sSerVice,sDate_title)
ELSE
	if rb_1.checked = true then             //사번검색
		dw_1.retrieve(gs_company,'%'+trim(sle_find.text)+'%','%',sSerVice,sDate_title)
	else                                    //성명검색
		dw_1.retrieve(gs_company,'%','%'+trim(sle_find.text)+'%',sSerVice,sDate_title)
	end if
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

event getfocus;
IF rb_1.Checked = True THEN
	f_toggle_eng(handle(this))
ELSE
	f_toggle_kor(handle(this))
END IF
end event

type st_1 from statictext within w_employee_retire_popup
integer x = 27
integer y = 56
integer width = 169
integer height = 60
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

type cb_1 from commandbutton within w_employee_retire_popup
boolean visible = false
integer x = 2135
integer y = 2324
integer width = 293
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)


end event

type cb_return from commandbutton within w_employee_retire_popup
boolean visible = false
integer x = 2464
integer y = 2324
integer width = 293
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type dw_1 from u_d_popup_sort within w_employee_retire_popup
event ue_key pbm_dwnkey
integer x = 37
integer y = 160
integer width = 2569
integer height = 1992
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_employee_retire_popup"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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
	case keyenter!
		p_choose.TriggerEvent(Clicked!)
end choose
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event ue_pressenter;p_choose.TriggerEvent(Clicked!)
end event

type gb_2 from groupbox within w_employee_retire_popup
integer x = 549
integer width = 1079
integer height = 132
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_1 from groupbox within w_employee_retire_popup
integer x = 1646
integer width = 590
integer height = 132
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_employee_retire_popup
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

