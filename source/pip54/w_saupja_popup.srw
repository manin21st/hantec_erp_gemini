$PBExportHeader$w_saupja_popup.srw
$PBExportComments$** 사원 조회 선택 - 사업장별
forward
global type w_saupja_popup from window
end type
type rb_unuse from radiobutton within w_saupja_popup
end type
type rb_use from radiobutton within w_saupja_popup
end type
type rb_all from radiobutton within w_saupja_popup
end type
type p_choose from uo_picture within w_saupja_popup
end type
type p_inq from uo_picture within w_saupja_popup
end type
type p_exit from uo_picture within w_saupja_popup
end type
type rb_2 from radiobutton within w_saupja_popup
end type
type rb_1 from radiobutton within w_saupja_popup
end type
type sle_find from singlelineedit within w_saupja_popup
end type
type st_1 from statictext within w_saupja_popup
end type
type cb_1 from commandbutton within w_saupja_popup
end type
type cb_return from commandbutton within w_saupja_popup
end type
type dw_1 from u_d_popup_sort within w_saupja_popup
end type
type gb_1 from groupbox within w_saupja_popup
end type
type gb_3 from groupbox within w_saupja_popup
end type
type rr_1 from roundrectangle within w_saupja_popup
end type
end forward

global type w_saupja_popup from window
integer x = 626
integer y = 12
integer width = 1545
integer height = 2308
boolean titlebar = true
string title = "사원 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
rb_unuse rb_unuse
rb_use rb_use
rb_all rb_all
p_choose p_choose
p_inq p_inq
p_exit p_exit
rb_2 rb_2
rb_1 rb_1
sle_find sle_find
st_1 st_1
cb_1 cb_1
cb_return cb_return
dw_1 dw_1
gb_1 gb_1
gb_3 gb_3
rr_1 rr_1
end type
global w_saupja_popup w_saupja_popup

type variables
String  sService,sDate_title
String scode,sname,sgubun
end variables

forward prototypes
public subroutine wf_retrieve ()
end prototypes

public subroutine wf_retrieve ();setnull(gs_code)
setnull(gs_codename)

IF gs_gubun = '' OR IsNull(gs_gubun) THEN gs_gubun = '%'

scode = Gs_code
sname = Gs_codeName
sgubun = Gs_gubun

IF IsNull(scode) AND IsNull(sname)THEN
	sle_find.text = ""
	rb_2.Checked = True
ELSEIF Not IsNull(scode) AND IsNull(sname)THEN
	sle_find.Text = scode
	rb_1.Checked = True
ELSEIF IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text = sname
	rb_2.Checked = True
ELSEIF Not IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text =""
	rb_2.Checked = True
END IF

dw_1.Retrieve(gs_gubun,sSerVice)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end subroutine

event open;f_window_center_response(this)
//String scode,sname

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sSerVice = '%'

rb_all.Checked = True

wf_retrieve()

sle_find.SetFocus()
//dw_1.SetFocus()
end event

on w_saupja_popup.create
this.rb_unuse=create rb_unuse
this.rb_use=create rb_use
this.rb_all=create rb_all
this.p_choose=create p_choose
this.p_inq=create p_inq
this.p_exit=create p_exit
this.rb_2=create rb_2
this.rb_1=create rb_1
this.sle_find=create sle_find
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_return=create cb_return
this.dw_1=create dw_1
this.gb_1=create gb_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.Control[]={this.rb_unuse,&
this.rb_use,&
this.rb_all,&
this.p_choose,&
this.p_inq,&
this.p_exit,&
this.rb_2,&
this.rb_1,&
this.sle_find,&
this.st_1,&
this.cb_1,&
this.cb_return,&
this.dw_1,&
this.gb_1,&
this.gb_3,&
this.rr_1}
end on

on w_saupja_popup.destroy
destroy(this.rb_unuse)
destroy(this.rb_use)
destroy(this.rb_all)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.p_exit)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.gb_3)
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

type rb_unuse from radiobutton within w_saupja_popup
integer x = 681
integer y = 164
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미근로"
end type

event clicked;sSerVice = 'N'

wf_retrieve()
end event

type rb_use from radiobutton within w_saupja_popup
integer x = 407
integer y = 164
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "근로"
end type

event clicked;sSerVice = 'Y'

wf_retrieve()
end event

type rb_all from radiobutton within w_saupja_popup
integer x = 137
integer y = 164
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
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

wf_retrieve()
end event

type p_choose from uo_picture within w_saupja_popup
integer x = 1175
integer y = 12
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

type p_inq from uo_picture within w_saupja_popup
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

type p_exit from uo_picture within w_saupja_popup
integer x = 1349
integer y = 12
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

type rb_2 from radiobutton within w_saupja_popup
integer x = 855
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

type rb_1 from radiobutton within w_saupja_popup
integer x = 613
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

type sle_find from singlelineedit within w_saupja_popup
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

if sle_find.Text = '' or isnull(sle_find.Text) then return

dw_1.SetRedraw(False)
if rb_1.checked = True then
	ls_findcol = "#1"
else
	ls_findcol = "#2"
end if

ll_findrow = dw_1.find(ls_findcol + "='" + sle_find.Text + "'",1,dw_1.RowCount())

dw_1.SelectRow(0,False)
dw_1.SelectRow(ll_findrow,True)
dw_1.ScrolltoRow(ll_findrow)
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

type st_1 from statictext within w_saupja_popup
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

type cb_1 from commandbutton within w_saupja_popup
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

type cb_return from commandbutton within w_saupja_popup
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

type dw_1 from u_d_popup_sort within w_saupja_popup
event ue_key pbm_dwnkey
integer x = 41
integer y = 272
integer width = 1426
integer height = 1848
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip5030_1"
boolean vscrollbar = true
boolean border = false
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

type gb_1 from groupbox within w_saupja_popup
integer x = 558
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

type gb_3 from groupbox within w_saupja_popup
integer x = 55
integer y = 120
integer width = 969
integer height = 132
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_saupja_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 264
integer width = 1445
integer height = 1872
integer cornerheight = 40
integer cornerwidth = 46
end type

