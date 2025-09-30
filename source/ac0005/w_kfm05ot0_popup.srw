$PBExportHeader$w_kfm05ot0_popup.srw
$PBExportComments$유가증권 조회선택(POPUP)
forward
global type w_kfm05ot0_popup from window
end type
type cb_3 from commandbutton within w_kfm05ot0_popup
end type
type cb_2 from commandbutton within w_kfm05ot0_popup
end type
type cb_1 from commandbutton within w_kfm05ot0_popup
end type
type p_exit from uo_picture within w_kfm05ot0_popup
end type
type p_choose from uo_picture within w_kfm05ot0_popup
end type
type p_inq from uo_picture within w_kfm05ot0_popup
end type
type dw_1 from u_d_popup_sort within w_kfm05ot0_popup
end type
type st_1 from statictext within w_kfm05ot0_popup
end type
type sle_name from singlelineedit within w_kfm05ot0_popup
end type
type sle_1 from singlelineedit within w_kfm05ot0_popup
end type
type rr_1 from roundrectangle within w_kfm05ot0_popup
end type
type ln_1 from line within w_kfm05ot0_popup
end type
type ln_2 from line within w_kfm05ot0_popup
end type
type rr_2 from roundrectangle within w_kfm05ot0_popup
end type
end forward

global type w_kfm05ot0_popup from window
integer x = 1467
integer y = 12
integer width = 2478
integer height = 2272
boolean titlebar = true
string title = "유가증권 조회 선택"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
st_1 st_1
sle_name sle_name
sle_1 sle_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_kfm05ot0_popup w_kfm05ot0_popup

type variables
long rownum
end variables

event open;String scode,sname

F_Window_Center_Response(This)

sle_1.text = gs_code
sname =Trim(sle_name.text)+"%"

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

p_inq.triggerevent(clicked!)



end event

on w_kfm05ot0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.st_1,&
this.sle_name,&
this.sle_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.rr_2}
end on

on w_kfm05ot0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
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

type cb_3 from commandbutton within w_kfm05ot0_popup
integer x = 2894
integer y = 552
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

type cb_2 from commandbutton within w_kfm05ot0_popup
integer x = 2894
integer y = 452
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

type cb_1 from commandbutton within w_kfm05ot0_popup
integer x = 2889
integer y = 352
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

type p_exit from uo_picture within w_kfm05ot0_popup
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

type p_choose from uo_picture within w_kfm05ot0_popup
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

gs_code= dw_1.GetItemString(ll_Row, "jz_illd")
gs_codename= dw_1.GetItemString(ll_row,"jz_name")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfm05ot0_popup
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

type dw_1 from u_d_popup_sort within w_kfm05ot0_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 41
integer y = 160
integer width = 2382
integer height = 1876
integer taborder = 40
string dataobject = "dw_kfm05ot0_popup"
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

gs_code= dw_1.GetItemString(Row, "jz_illd")
gs_codename= dw_1.GetItemString(row,"jz_name")

Close(Parent)

end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text =dw_1.GetItemString(Row,"jz_illd")
	sle_name.text =dw_1.GetItemString(Row,"jz_name")

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

type st_1 from statictext within w_kfm05ot0_popup
integer x = 50
integer y = 48
integer width = 361
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "유가증권코드"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kfm05ot0_popup
event ue_key pbm_keydown
integer x = 658
integer y = 40
integer width = 1006
integer height = 68
integer taborder = 20
integer textsize = -9
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

type sle_1 from singlelineedit within w_kfm05ot0_popup
event ue_key pbm_keydown
integer x = 411
integer y = 40
integer width = 233
integer height = 68
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 6
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

type rr_1 from roundrectangle within w_kfm05ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 12
integer width = 1673
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfm05ot0_popup
integer linethickness = 1
integer beginx = 411
integer beginy = 108
integer endx = 645
integer endy = 108
end type

type ln_2 from line within w_kfm05ot0_popup
integer linethickness = 1
integer beginx = 663
integer beginy = 108
integer endx = 1664
integer endy = 108
end type

type rr_2 from roundrectangle within w_kfm05ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 152
integer width = 2409
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

