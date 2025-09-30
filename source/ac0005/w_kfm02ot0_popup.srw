$PBExportHeader$w_kfm02ot0_popup.srw
$PBExportComments$받을어음 조회선택(POPUP)
forward
global type w_kfm02ot0_popup from window
end type
type cb_3 from commandbutton within w_kfm02ot0_popup
end type
type cb_2 from commandbutton within w_kfm02ot0_popup
end type
type cb_1 from commandbutton within w_kfm02ot0_popup
end type
type p_exit from uo_picture within w_kfm02ot0_popup
end type
type p_choose from uo_picture within w_kfm02ot0_popup
end type
type p_inq from uo_picture within w_kfm02ot0_popup
end type
type dw_1 from u_d_popup_sort within w_kfm02ot0_popup
end type
type sle_no from singlelineedit within w_kfm02ot0_popup
end type
type st_2 from statictext within w_kfm02ot0_popup
end type
type em_date from editmask within w_kfm02ot0_popup
end type
type st_1 from statictext within w_kfm02ot0_popup
end type
type rr_1 from roundrectangle within w_kfm02ot0_popup
end type
type ln_2 from line within w_kfm02ot0_popup
end type
type ln_1 from line within w_kfm02ot0_popup
end type
type rr_3 from roundrectangle within w_kfm02ot0_popup
end type
end forward

global type w_kfm02ot0_popup from window
integer x = 951
integer y = 4
integer width = 2962
integer height = 2432
boolean titlebar = true
string title = "받을어음 조회 선택"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
sle_no sle_no
st_2 st_2
em_date em_date
st_1 st_1
rr_1 rr_1
ln_2 ln_2
ln_1 ln_1
rr_3 rr_3
end type
global w_kfm02ot0_popup w_kfm02ot0_popup

type variables
long    rownum
String sStatus,sCust
end variables

event open;String sbill_no

F_Window_Center_Response(This)

em_date.text = String(f_today(),"@@@@.@@.@@")

sStatus = Message.StringParm
IF sStatus = '' or IsNull(sStatus) THEN sStatus = '%'

//sCust = Gs_Code
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'

//sle_no.text = gs_code

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

//p_inq.triggerevent(clicked!)

//if dw_1.rowcount() = 1 then
//	p_choose.triggerevent(clicked!)
//end if
//

end event

on w_kfm02ot0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.sle_no=create sle_no
this.st_2=create st_2
this.em_date=create em_date
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_2=create ln_2
this.ln_1=create ln_1
this.rr_3=create rr_3
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.sle_no,&
this.st_2,&
this.em_date,&
this.st_1,&
this.rr_1,&
this.ln_2,&
this.ln_1,&
this.rr_3}
end on

on w_kfm02ot0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.sle_no)
destroy(this.st_2)
destroy(this.em_date)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_2)
destroy(this.ln_1)
destroy(this.rr_3)
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

type cb_3 from commandbutton within w_kfm02ot0_popup
integer x = 3497
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

type cb_2 from commandbutton within w_kfm02ot0_popup
integer x = 3497
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

type cb_1 from commandbutton within w_kfm02ot0_popup
integer x = 3493
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

type p_exit from uo_picture within w_kfm02ot0_popup
integer x = 2743
integer y = 8
integer width = 178
integer taborder = 60
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

type p_choose from uo_picture within w_kfm02ot0_popup
integer x = 2569
integer y = 8
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code=dw_1.GetItemString(ll_row,"bill_no")

Close(Parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfm02ot0_popup
integer x = 2395
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;
String sdate,sbill_no

sdate =Left(em_date.text,4)+Mid(em_date.text,6,2)+Right(em_date.text,2)
sbill_no =Trim(sle_no.text)

IF sbill_no ="" OR IsNull(sbill_no) THEN
	sbill_no ="%"
END IF

IF dw_1.Retrieve(sdate,sbill_no+'%',sStatus,sCust) <= 0 THEN
	MessageBox("확 인","조회할 자료가 없습니다.!!!")
	em_date.SetFocus()
else
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.SetFocus()
END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfm02ot0_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 37
integer y = 180
integer width = 2866
integer height = 2032
integer taborder = 40
string dataobject = "dw_kfm02om0_popup"
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

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	em_date.text = string(dw_1.GetItemString(Row,"bman_dat"), '@@@@.@@.@@')
	sle_no.text =dw_1.GetItemString(Row,"bill_no")

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;call super::doubleclicked;IF row <=0 THEN RETURN

gs_code =dw_1.GetItemString(row,"bill_no")

Close(Parent)

end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type sle_no from singlelineedit within w_kfm02ot0_popup
event ue_key pbm_keydown
integer x = 1166
integer y = 48
integer width = 320
integer height = 64
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
integer limit = 10
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type st_2 from statictext within w_kfm02ot0_popup
integer x = 873
integer y = 56
integer width = 279
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "어음번호"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type em_date from editmask within w_kfm02ot0_popup
event ue_key pbm_keydown
integer x = 329
integer y = 48
integer width = 343
integer height = 64
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

type st_1 from statictext within w_kfm02ot0_popup
integer x = 37
integer y = 56
integer width = 279
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "만기일자"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfm02ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 12
integer width = 1605
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_2 from line within w_kfm02ot0_popup
integer linethickness = 1
integer beginx = 1170
integer beginy = 116
integer endx = 1486
integer endy = 116
end type

type ln_1 from line within w_kfm02ot0_popup
integer linethickness = 1
integer beginx = 334
integer beginy = 116
integer endx = 672
integer endy = 116
end type

type rr_3 from roundrectangle within w_kfm02ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 2889
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

