$PBExportHeader$w_kfz02wk2_popup.srw
$PBExportComments$년도별재무제표 선택
forward
global type w_kfz02wk2_popup from window
end type
type cb_3 from commandbutton within w_kfz02wk2_popup
end type
type cb_2 from commandbutton within w_kfz02wk2_popup
end type
type cb_1 from commandbutton within w_kfz02wk2_popup
end type
type p_exit from uo_picture within w_kfz02wk2_popup
end type
type p_choose from uo_picture within w_kfz02wk2_popup
end type
type p_inq from uo_picture within w_kfz02wk2_popup
end type
type st_2 from statictext within w_kfz02wk2_popup
end type
type dw_1 from u_d_popup_sort within w_kfz02wk2_popup
end type
type st_1 from statictext within w_kfz02wk2_popup
end type
type sle_1 from singlelineedit within w_kfz02wk2_popup
end type
type rr_1 from roundrectangle within w_kfz02wk2_popup
end type
type ln_2 from line within w_kfz02wk2_popup
end type
type rr_2 from roundrectangle within w_kfz02wk2_popup
end type
end forward

global type w_kfz02wk2_popup from window
integer x = 1518
integer y = 4
integer width = 1202
integer height = 2256
boolean titlebar = true
string title = "년도별 재무제표 조회 선택"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
st_2 st_2
dw_1 dw_1
st_1 st_1
sle_1 sle_1
rr_1 rr_1
ln_2 ln_2
rr_2 rr_2
end type
global w_kfz02wk2_popup w_kfz02wk2_popup

type variables

String sSaupj
end variables

event open;String scode,sname

F_Window_Center_Response(This)

sle_1.text = gs_code

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Retrieve(sle_1.Text+'%')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

on w_kfz02wk2_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.st_2=create st_2
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_1=create sle_1
this.rr_1=create rr_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.st_2,&
this.dw_1,&
this.st_1,&
this.sle_1,&
this.rr_1,&
this.ln_2,&
this.rr_2}
end on

on w_kfz02wk2_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.rr_1)
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

type cb_3 from commandbutton within w_kfz02wk2_popup
integer x = 1678
integer y = 600
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

type cb_2 from commandbutton within w_kfz02wk2_popup
integer x = 1678
integer y = 500
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

type cb_1 from commandbutton within w_kfz02wk2_popup
integer x = 1673
integer y = 400
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

type p_exit from uo_picture within w_kfz02wk2_popup
integer x = 997
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfz02wk2_popup
integer x = 823
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code    = String(dw_1.GetItemNumber(ll_Row, "acyear"),'000') + &
				 dw_1.GetItemString(ll_Row, "acymf") + &
				 dw_1.GetItemString(ll_Row, "acymt")
Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfz02wk2_popup
integer x = 649
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"

dw_1.SetRedraw(False)
IF dw_1.Retrieve(scode) <= 0 THEN
	F_MessageChk(14,'')
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

type st_2 from statictext within w_kfz02wk2_popup
integer x = 379
integer y = 72
integer width = 110
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "기"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_kfz02wk2_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 37
integer y = 192
integer width = 1115
integer height = 1844
integer taborder = 30
string dataobject = "dw_kfz02wk2_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_keyenter;p_choose.TriggerEvent(Clicked!)
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

event doubleclicked;
IF row <=0 THEN RETURN

gs_code    = String(dw_1.GetItemNumber(Row, "acyear"),'000') + &
				 dw_1.GetItemString(Row, "acymf") + &
				 dw_1.GetItemString(Row, "acymt")

Close(Parent)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text = String(dw_1.GetItemNumber(Row,"acyear"))
	
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

type st_1 from statictext within w_kfz02wk2_popup
integer x = 55
integer y = 72
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
string text = "회기"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfz02wk2_popup
event ue_key pbm_keydown
integer x = 224
integer y = 60
integer width = 155
integer height = 68
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

event getfocus;
f_toggle_eng(Handle(this))
end event

type rr_1 from roundrectangle within w_kfz02wk2_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 16
integer width = 526
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_2 from line within w_kfz02wk2_popup
integer linethickness = 1
integer beginx = 219
integer beginy = 132
integer endx = 379
integer endy = 132
end type

type rr_2 from roundrectangle within w_kfz02wk2_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 184
integer width = 1134
integer height = 1864
integer cornerheight = 40
integer cornerwidth = 55
end type

