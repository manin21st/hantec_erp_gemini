$PBExportHeader$w_kfz05om0_popup.srw
$PBExportComments$신용카드 조회 선택
forward
global type w_kfz05om0_popup from window
end type
type cb_3 from commandbutton within w_kfz05om0_popup
end type
type cb_2 from commandbutton within w_kfz05om0_popup
end type
type cb_1 from commandbutton within w_kfz05om0_popup
end type
type p_exit from uo_picture within w_kfz05om0_popup
end type
type p_choose from uo_picture within w_kfz05om0_popup
end type
type p_inq from uo_picture within w_kfz05om0_popup
end type
type dw_1 from u_d_popup_sort within w_kfz05om0_popup
end type
type sle_4 from singlelineedit within w_kfz05om0_popup
end type
type sle_3 from singlelineedit within w_kfz05om0_popup
end type
type st_1 from statictext within w_kfz05om0_popup
end type
type rr_1 from roundrectangle within w_kfz05om0_popup
end type
type rr_2 from roundrectangle within w_kfz05om0_popup
end type
type ln_1 from line within w_kfz05om0_popup
end type
type ln_2 from line within w_kfz05om0_popup
end type
end forward

global type w_kfz05om0_popup from window
integer x = 1243
integer y = 12
integer width = 2459
integer height = 2272
boolean titlebar = true
string title = "신용카드 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
sle_4 sle_4
sle_3 sle_3
st_1 st_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
end type
global w_kfz05om0_popup w_kfz05om0_popup

event open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()

F_Window_Center_Response(This)

sle_3.Text = Gs_Code
sle_4.SetFocus()

p_inq.TriggerEvent(Clicked!)

end event

on w_kfz05om0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.sle_4=create sle_4
this.sle_3=create sle_3
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.sle_4,&
this.sle_3,&
this.st_1,&
this.rr_1,&
this.rr_2,&
this.ln_1,&
this.ln_2}
end on

on w_kfz05om0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.sle_4)
destroy(this.sle_3)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.ln_2)
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

type cb_3 from commandbutton within w_kfz05om0_popup
integer x = 3127
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

type cb_2 from commandbutton within w_kfz05om0_popup
integer x = 3127
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

type cb_1 from commandbutton within w_kfz05om0_popup
integer x = 3122
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

type p_exit from uo_picture within w_kfz05om0_popup
integer x = 2249
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(Gs_Code)
SetNull(Gs_CodeName)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfz05om0_popup
integer x = 2075
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "card_no")
gs_codename = dw_1.GetItemString(ll_Row, "owner")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfz05om0_popup
integer x = 1902
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sCrNo,sOwner

sCrNo  = "%" + Trim(sle_3.text) +"%"
sOwner = "%" + Trim(sle_4.text) +"%"

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.Retrieve(sCrNo,sOwner)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfz05om0_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 46
integer y = 176
integer width = 2354
integer height = 1860
integer taborder = 40
string dataobject = "dw_kfz05om0_popup"
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

event doubleclicked;
IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(Row, "card_no")
gs_codename = dw_1.GetItemString(Row, "owner")

Close(Parent)

end event

event clicked;string acc1_cd, acc2_cd, acc_name1, acc_name2

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	b_flag = False
END IF

call super ::clicked
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type sle_4 from singlelineedit within w_kfz05om0_popup
event ue_key pbm_keydown
integer x = 919
integer y = 52
integer width = 439
integer height = 68
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
integer limit = 10
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_kor(Handle(this))
end event

type sle_3 from singlelineedit within w_kfz05om0_popup
event ue_key pbm_keydown
integer x = 206
integer y = 52
integer width = 699
integer height = 68
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
integer limit = 19
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type st_1 from statictext within w_kfz05om0_popup
integer x = 50
integer y = 60
integer width = 169
integer height = 56
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

type rr_1 from roundrectangle within w_kfz05om0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 24
integer width = 1371
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfz05om0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 168
integer width = 2382
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfz05om0_popup
integer linethickness = 1
integer beginx = 210
integer beginy = 120
integer endx = 910
integer endy = 120
end type

type ln_2 from line within w_kfz05om0_popup
integer linethickness = 1
integer beginx = 923
integer beginy = 120
integer endx = 1362
integer endy = 120
end type

