$PBExportHeader$w_kfz01om0_popup_cost.srw
$PBExportComments$계정과목조회선택(POPUP):전표발행계정만
forward
global type w_kfz01om0_popup_cost from window
end type
type cb_3 from commandbutton within w_kfz01om0_popup_cost
end type
type cb_2 from commandbutton within w_kfz01om0_popup_cost
end type
type cb_1 from commandbutton within w_kfz01om0_popup_cost
end type
type ddlb_gb from dropdownlistbox within w_kfz01om0_popup_cost
end type
type st_22 from statictext within w_kfz01om0_popup_cost
end type
type p_exit from uo_picture within w_kfz01om0_popup_cost
end type
type p_choose from uo_picture within w_kfz01om0_popup_cost
end type
type p_inq from uo_picture within w_kfz01om0_popup_cost
end type
type st_2 from statictext within w_kfz01om0_popup_cost
end type
type dw_1 from u_d_popup_sort within w_kfz01om0_popup_cost
end type
type sle_4 from singlelineedit within w_kfz01om0_popup_cost
end type
type sle_3 from singlelineedit within w_kfz01om0_popup_cost
end type
type sle_2 from singlelineedit within w_kfz01om0_popup_cost
end type
type sle_1 from singlelineedit within w_kfz01om0_popup_cost
end type
type st_1 from statictext within w_kfz01om0_popup_cost
end type
type rr_1 from roundrectangle within w_kfz01om0_popup_cost
end type
type ln_1 from line within w_kfz01om0_popup_cost
end type
type ln_2 from line within w_kfz01om0_popup_cost
end type
type ln_3 from line within w_kfz01om0_popup_cost
end type
type ln_4 from line within w_kfz01om0_popup_cost
end type
type rr_2 from roundrectangle within w_kfz01om0_popup_cost
end type
end forward

global type w_kfz01om0_popup_cost from window
integer x = 82
integer y = 12
integer width = 3781
integer height = 2268
boolean titlebar = true
string title = "계정과목조회선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
ddlb_gb ddlb_gb
st_22 st_22
p_exit p_exit
p_choose p_choose
p_inq p_inq
st_2 st_2
dw_1 dw_1
sle_4 sle_4
sle_3 sle_3
sle_2 sle_2
sle_1 sle_1
st_1 st_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
rr_2 rr_2
end type
global w_kfz01om0_popup_cost w_kfz01om0_popup_cost

event open;string ls_string, ls_string1,sFocusCd1,sFocusCd2

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

F_Window_Center_Response(This)

sFocusCd1 = lstr_account.acc1_cd
sFocusCd2 = lstr_account.acc2_cd
if IsNull(sFocusCd1) then sFocusCd1 = ''
if IsNull(sFocusCd2) then sFocusCd2 = ''

sle_1.text = lstr_account.acc1_cd
sle_2.text = lstr_account.acc2_cd

ls_string = f_nvl(lstr_account.acc1_cd, "")
ls_string1 = f_nvl(lstr_account.acc2_cd, "")

If Len(ls_string) > 0 Then
	Choose Case Asc(ls_string)
		//숫자 - 코드
		Case is < 65
			sle_1.text = ls_string
			sle_2.text = ls_string1

		//문자 - 명칭
		Case is >= 65
			sle_1.text = ""
			sle_4.text = ls_string

	End Choose
End If

ddlb_gb.selectitem(1)

p_inq.triggerevent(clicked!)

if sFocusCd1 = '' and sFocusCd2 = '' then
	sle_4.SetFocus()	
end if

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if




end event

on w_kfz01om0_popup_cost.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.ddlb_gb=create ddlb_gb
this.st_22=create st_22
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.st_2=create st_2
this.dw_1=create dw_1
this.sle_4=create sle_4
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_1=create sle_1
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.ddlb_gb,&
this.st_22,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.st_2,&
this.dw_1,&
this.sle_4,&
this.sle_3,&
this.sle_2,&
this.sle_1,&
this.st_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.ln_4,&
this.rr_2}
end on

on w_kfz01om0_popup_cost.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.ddlb_gb)
destroy(this.st_22)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.sle_4)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
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
	case keyenter!	
		p_inq.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyV!
		p_choose.TriggerEvent(Clicked!)	
	Case KeyC!
		p_exit.TriggerEvent(Clicked!)
end choose
end event

type cb_3 from commandbutton within w_kfz01om0_popup_cost
integer x = 4443
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

type cb_2 from commandbutton within w_kfz01om0_popup_cost
integer x = 4443
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

type cb_1 from commandbutton within w_kfz01om0_popup_cost
integer x = 4439
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

type ddlb_gb from dropdownlistbox within w_kfz01om0_popup_cost
integer x = 2437
integer y = 44
integer width = 402
integer height = 288
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
boolean sorted = false
string item[] = {"전체","사용","미사용"}
end type

type st_22 from statictext within w_kfz01om0_popup_cost
integer x = 2176
integer y = 60
integer width = 256
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "조회구분"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kfz01om0_popup_cost
integer x = 3561
integer y = 4
integer width = 178
integer taborder = 90
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)
SetNull(lstr_account.acc1_nm)
SetNull(lstr_account.acc2_nm)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfz01om0_popup_cost
integer x = 3387
integer y = 4
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

lstr_account.acc1_cd   = dw_1.GetItemString(ll_Row, "acc1_cd")
lstr_account.acc2_cd   = dw_1.GetItemString(ll_Row, "acc2_cd")
lstr_account.acc1_nm   = dw_1.GetItemString(ll_Row, "acc1_nm")
lstr_account.acc2_nm   = dw_1.GetItemString(ll_Row, "acc2_nm")
lstr_account.gbn1 	  = dw_1.GetItemString(ll_Row, "gbn1")

lstr_account.ch_gu 	  = dw_1.GetItemString(ll_Row, "ch_gu")
lstr_account.yu_gu 	  = dw_1.GetItemString(ll_Row, "yu_gu")
lstr_account.remark4	  = dw_1.GetItemString(ll_Row, "remark4")

lstr_account.dcr_gu    = dw_1.GetItemString(ll_Row, "dc_gu")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfz01om0_popup_cost
integer x = 3214
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String ls_gaejung1, ls_gaejung2, name1, name2, ls_gb

ls_gaejung1 = sle_1.text + "%"
ls_gaejung2 = "%"
name1       = "%" + Trim(sle_3.text) +"%"
name2       = "%" + Trim(sle_4.text) +"%"

If ddlb_gb.text = "전체" Then
	ls_gb = "%"
Elseif ddlb_gb.text = "사용" Then
	ls_gb = "Y%"
Else
	ls_gb = "N%"
End if

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.Retrieve(ls_gaejung1, ls_gaejung2, name1, name2, ls_gb)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type st_2 from statictext within w_kfz01om0_popup_cost
integer x = 507
integer y = 56
integer width = 46
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long backcolor = 32106727
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_kfz01om0_popup_cost
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 50
integer y = 168
integer width = 3666
integer height = 1892
integer taborder = 70
string dataobject = "dw_kfz01om0_popup_cost"
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
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyV!
		p_choose.TriggerEvent(Clicked!)	
	Case KeyC!
		p_exit.TriggerEvent(Clicked!)
end choose
end event

event doubleclicked;
String ls_mapno


IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

lstr_account.acc1_cd   = dw_1.GetItemString(Row, "acc1_cd")
lstr_account.acc2_cd   = dw_1.GetItemString(Row, "acc2_cd")
lstr_account.acc1_nm   = dw_1.GetItemString(Row, "acc1_nm")
lstr_account.acc2_nm   = dw_1.GetItemString(Row, "acc2_nm")
lstr_account.gbn1 	  = dw_1.GetItemString(Row, "gbn1")
lstr_account.ch_gu 	  = dw_1.GetItemString(Row, "ch_gu")
lstr_account.yu_gu 	  = dw_1.GetItemString(Row, "yu_gu")
lstr_account.remark4	  = dw_1.GetItemString(Row, "remark4")

lstr_account.dcr_gu    = dw_1.GetItemString(Row, "dc_gu")

Close(Parent)

end event

event clicked;string acc1_cd, acc2_cd, acc_name1, acc_name2

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	acc1_cd =dw_1.GetItemString(Row,"acc1_cd")
	acc2_cd =dw_1.GetItemString(Row,"acc2_cd")
	acc_name1 =dw_1.GetItemString(Row,"acc1_nm")
	acc_name2 =dw_1.GetItemString(Row,"acc2_nm")

	sle_1.text =acc1_cd
	sle_2.text =acc2_cd
	sle_3.text =acc_name1
	sle_3.text =acc_name2

	b_flag = False
END IF

call super ::clicked
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type sle_4 from singlelineedit within w_kfz01om0_popup_cost
event ue_key pbm_keydown
integer x = 1088
integer y = 52
integer width = 965
integer height = 72
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_kor(Handle(this))
end event

event modified;p_inq.TriggerEvent(Clicked!)
end event

type sle_3 from singlelineedit within w_kfz01om0_popup_cost
event ue_key pbm_keydown
integer x = 654
integer y = 52
integer width = 425
integer height = 72
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_kor(Handle(this))
end event

type sle_2 from singlelineedit within w_kfz01om0_popup_cost
event ue_key pbm_keydown
integer x = 553
integer y = 52
integer width = 87
integer height = 72
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
integer limit = 2
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type sle_1 from singlelineedit within w_kfz01om0_popup_cost
event ue_key pbm_keydown
integer x = 325
integer y = 52
integer width = 178
integer height = 72
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
integer limit = 5
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type st_1 from statictext within w_kfz01om0_popup_cost
integer x = 50
integer y = 60
integer width = 270
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "계정코드"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfz01om0_popup_cost
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 16
integer width = 2848
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfz01om0_popup_cost
integer linethickness = 1
integer beginx = 329
integer beginy = 124
integer endx = 507
integer endy = 124
end type

type ln_2 from line within w_kfz01om0_popup_cost
integer linethickness = 1
integer beginx = 558
integer beginy = 124
integer endx = 645
integer endy = 124
end type

type ln_3 from line within w_kfz01om0_popup_cost
integer linethickness = 1
integer beginx = 654
integer beginy = 124
integer endx = 1079
integer endy = 124
end type

type ln_4 from line within w_kfz01om0_popup_cost
integer linethickness = 1
integer beginx = 1093
integer beginy = 124
integer endx = 2053
integer endy = 124
end type

type rr_2 from roundrectangle within w_kfz01om0_popup_cost
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 3694
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

