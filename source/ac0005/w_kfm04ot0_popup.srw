$PBExportHeader$w_kfm04ot0_popup.srw
$PBExportComments$예적금조회선택(POPUP)
forward
global type w_kfm04ot0_popup from window
end type
type cb_3 from commandbutton within w_kfm04ot0_popup
end type
type cb_2 from commandbutton within w_kfm04ot0_popup
end type
type cb_1 from commandbutton within w_kfm04ot0_popup
end type
type p_inq from uo_picture within w_kfm04ot0_popup
end type
type p_choose from uo_picture within w_kfm04ot0_popup
end type
type p_exit from uo_picture within w_kfm04ot0_popup
end type
type dw_1 from u_d_popup_sort within w_kfm04ot0_popup
end type
type st_1 from statictext within w_kfm04ot0_popup
end type
type sle_name from singlelineedit within w_kfm04ot0_popup
end type
type sle_1 from singlelineedit within w_kfm04ot0_popup
end type
type rr_1 from roundrectangle within w_kfm04ot0_popup
end type
type ln_2 from line within w_kfm04ot0_popup
end type
type ln_1 from line within w_kfm04ot0_popup
end type
type rr_2 from roundrectangle within w_kfm04ot0_popup
end type
end forward

global type w_kfm04ot0_popup from window
integer x = 1394
integer y = 4
integer width = 2459
integer height = 2272
boolean titlebar = true
string title = "예적금 조회 선택"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_inq p_inq
p_choose p_choose
p_exit p_exit
dw_1 dw_1
st_1 st_1
sle_name sle_name
sle_1 sle_1
rr_1 rr_1
ln_2 ln_2
ln_1 ln_1
rr_2 rr_2
end type
global w_kfm04ot0_popup w_kfm04ot0_popup

type variables
long rownum
end variables

event open;String scode,sname, ls_string

F_Window_Center_Response(This)

//sle_1.text = gs_code
//sname =Trim(sle_name.text)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

ls_string = f_nvl(gs_code, "")

If Len(ls_string) > 0 Then
	Choose Case Asc(ls_string)
		//숫자 - 코드
		Case is < 65
			sle_1.text = ls_string

		//문자 - 명칭
		Case is >= 65
			sle_name.text = ls_string

	End Choose
End If

p_inq.triggerevent(clicked!)

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if
end event

on w_kfm04ot0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_inq=create p_inq
this.p_choose=create p_choose
this.p_exit=create p_exit
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.rr_1=create rr_1
this.ln_2=create ln_2
this.ln_1=create ln_1
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_inq,&
this.p_choose,&
this.p_exit,&
this.dw_1,&
this.st_1,&
this.sle_name,&
this.sle_1,&
this.rr_1,&
this.ln_2,&
this.ln_1,&
this.rr_2}
end on

on w_kfm04ot0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_inq)
destroy(this.p_choose)
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.ln_2)
destroy(this.ln_1)
destroy(this.rr_2)
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

type cb_3 from commandbutton within w_kfm04ot0_popup
integer x = 3003
integer y = 588
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_kfm04ot0_popup
integer x = 3003
integer y = 488
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_choose.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_kfm04ot0_popup
integer x = 2999
integer y = 388
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_inq from uo_picture within w_kfm04ot0_popup
integer x = 1915
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"
sname  = "%" + Trim(sle_name.text) + "%"

dw_1.SetRedraw(False)
IF dw_1.Retrieve(scode,sname) <= 0 THEN
	MessageBox("확 인","조회할 자료가 없습니다.!!!")
	sle_1.SetFocus()
	dw_1.SetRedraw(True)
	Return
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type p_choose from uo_picture within w_kfm04ot0_popup
integer x = 2089
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "ab_dpno")
gs_codename = dw_1.GetItemString(ll_row,"ab_name")
gs_gubun    = dw_1.GetItemString(ll_row,"ab_no")
Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_exit from uo_picture within w_kfm04ot0_popup
integer x = 2263
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfm04ot0_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 55
integer y = 168
integer width = 2354
integer height = 1896
integer taborder = 40
string dataobject = "dw_kfm04ot0_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_keyenter;p_choose.triggerEvent(Clicked!)
end event

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

event doubleclicked;IF row <=0 THEN RETURN

gs_code     = dw_1.GetItemString(Row, "ab_dpno")
gs_codename = dw_1.GetItemString(row,"ab_name")
gs_gubun    = dw_1.GetItemString(row,"ab_no")
Close(Parent)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text =dw_1.GetItemString(Row,"ab_dpno")
	sle_name.text =dw_1.GetItemString(Row,"ab_name")

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type st_1 from statictext within w_kfm04ot0_popup
integer x = 59
integer y = 64
integer width = 325
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "예적금코드"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kfm04ot0_popup
event ue_key pbm_keydown
integer x = 645
integer y = 52
integer width = 1015
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( "%" , "%" + sle_name.TEXT + "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

event getfocus;
f_toggle_kor(Handle(this))
end event

type sle_1 from singlelineedit within w_kfm04ot0_popup
event ue_key pbm_keydown
integer x = 393
integer y = 52
integer width = 233
integer height = 72
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( sle_1.TEXT + "%" ,  "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type rr_1 from roundrectangle within w_kfm04ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 16
integer width = 1659
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_2 from line within w_kfm04ot0_popup
integer linethickness = 1
integer beginx = 645
integer beginy = 124
integer endx = 1655
integer endy = 124
end type

type ln_1 from line within w_kfm04ot0_popup
integer linethickness = 1
integer beginx = 393
integer beginy = 128
integer endx = 626
integer endy = 128
end type

type rr_2 from roundrectangle within w_kfm04ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 164
integer width = 2386
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

