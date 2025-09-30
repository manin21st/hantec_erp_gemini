$PBExportHeader$w_kfz04om0_popup_kwan.srw
$PBExportComments$인명거래처 조회선택(거래처,은행,부서,사원,예적금 등)(POPUP)
forward
global type w_kfz04om0_popup_kwan from window
end type
type rb_1 from radiobutton within w_kfz04om0_popup_kwan
end type
type rb_2 from radiobutton within w_kfz04om0_popup_kwan
end type
type rb_3 from radiobutton within w_kfz04om0_popup_kwan
end type
type cb_3 from commandbutton within w_kfz04om0_popup_kwan
end type
type cb_2 from commandbutton within w_kfz04om0_popup_kwan
end type
type cb_1 from commandbutton within w_kfz04om0_popup_kwan
end type
type sle_sano from singlelineedit within w_kfz04om0_popup_kwan
end type
type st_23 from statictext within w_kfz04om0_popup_kwan
end type
type cbx_acgbn from checkbox within w_kfz04om0_popup_kwan
end type
type sle_2 from singlelineedit within w_kfz04om0_popup_kwan
end type
type st_2 from statictext within w_kfz04om0_popup_kwan
end type
type p_exit from uo_picture within w_kfz04om0_popup_kwan
end type
type p_choose from uo_picture within w_kfz04om0_popup_kwan
end type
type p_inq from uo_picture within w_kfz04om0_popup_kwan
end type
type st_5 from statictext within w_kfz04om0_popup_kwan
end type
type dw_1 from u_d_popup_sort within w_kfz04om0_popup_kwan
end type
type st_1 from statictext within w_kfz04om0_popup_kwan
end type
type sle_name from singlelineedit within w_kfz04om0_popup_kwan
end type
type sle_1 from singlelineedit within w_kfz04om0_popup_kwan
end type
type gb_1 from groupbox within w_kfz04om0_popup_kwan
end type
type rr_1 from roundrectangle within w_kfz04om0_popup_kwan
end type
type rr_2 from roundrectangle within w_kfz04om0_popup_kwan
end type
type ln_1 from line within w_kfz04om0_popup_kwan
end type
type ln_2 from line within w_kfz04om0_popup_kwan
end type
type ln_3 from line within w_kfz04om0_popup_kwan
end type
type ln_4 from line within w_kfz04om0_popup_kwan
end type
end forward

global type w_kfz04om0_popup_kwan from window
integer x = 407
integer y = 4
integer width = 3703
integer height = 2272
boolean titlebar = true
string title = "거래처 조회"
windowtype windowtype = response!
long backcolor = 32106727
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
sle_sano sle_sano
st_23 st_23
cbx_acgbn cbx_acgbn
sle_2 sle_2
st_2 st_2
p_exit p_exit
p_choose p_choose
p_inq p_inq
st_5 st_5
dw_1 dw_1
st_1 st_1
sle_name sle_name
sle_1 sle_1
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_kfz04om0_popup_kwan w_kfz04om0_popup_kwan

type variables
String sCusGbn

end variables

event open;String ls_saup,saup_nm, ls_string,sFocusCd

F_Window_Center_Response(This)

sCusGbn = Message.StringParm

sFocusCd = lstr_custom.code
if IsNull(sFocusCd) then sFocusCd = ''

ls_string = f_nvl(lstr_custom.code, "")

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

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

p_inq.triggerevent(clicked!)

if sFocusCd = '' then
	sle_name.SetFocus()	
end if

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if







end event

on w_kfz04om0_popup_kwan.create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_sano=create sle_sano
this.st_23=create st_23
this.cbx_acgbn=create cbx_acgbn
this.sle_2=create sle_2
this.st_2=create st_2
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.st_5=create st_5
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.Control[]={this.rb_1,&
this.rb_2,&
this.rb_3,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.sle_sano,&
this.st_23,&
this.cbx_acgbn,&
this.sle_2,&
this.st_2,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.st_5,&
this.dw_1,&
this.st_1,&
this.sle_name,&
this.sle_1,&
this.gb_1,&
this.rr_1,&
this.rr_2,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.ln_4}
end on

on w_kfz04om0_popup_kwan.destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_sano)
destroy(this.st_23)
destroy(this.cbx_acgbn)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.st_5)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
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

type rb_1 from radiobutton within w_kfz04om0_popup_kwan
integer x = 2377
integer y = 56
integer width = 206
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사용"
boolean checked = true
end type

event clicked;IF THIS.Checked = True then
	dw_1.SetFilter("person_sts = '1'")
	dw_1.Filter()
end if
end event

type rb_2 from radiobutton within w_kfz04om0_popup_kwan
integer x = 2597
integer y = 56
integer width = 270
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미사용"
end type

event clicked;IF THIS.Checked = True then
	dw_1.SetFilter("person_sts = '2'")
	dw_1.Filter()
end if
end event

type rb_3 from radiobutton within w_kfz04om0_popup_kwan
integer x = 2880
integer y = 56
integer width = 206
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
end type

event clicked;IF THIS.Checked = True then
	dw_1.SetFilter("person_sts LIKE '%'")
	dw_1.Filter()
end if
end event

type cb_3 from commandbutton within w_kfz04om0_popup_kwan
integer x = 4293
integer y = 576
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

type cb_2 from commandbutton within w_kfz04om0_popup_kwan
integer x = 4293
integer y = 476
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

type cb_1 from commandbutton within w_kfz04om0_popup_kwan
integer x = 4288
integer y = 376
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

type sle_sano from singlelineedit within w_kfz04om0_popup_kwan
event ue_key pbm_keydown
integer x = 1509
integer y = 128
integer width = 585
integer height = 68
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

type st_23 from statictext within w_kfz04om0_popup_kwan
integer x = 1179
integer y = 128
integer width = 311
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업자번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_acgbn from checkbox within w_kfz04om0_popup_kwan
integer x = 3310
integer y = 168
integer width = 334
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "계정무시"
end type

event clicked;
if cbx_acgbn.Checked = True then
	dw_1.dataobject = 'dw_kfz04om0_popup'	
else
	dw_1.dataobject = 'dw_kfz04om0_popup_kwan'		
end if
dw_1.SetTransObject(Sqlca)

p_inq.triggerevent(clicked!)
end event

type sle_2 from singlelineedit within w_kfz04om0_popup_kwan
event ue_key pbm_keydown
integer x = 375
integer y = 128
integer width = 585
integer height = 68
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

type st_2 from statictext within w_kfz04om0_popup_kwan
integer x = 82
integer y = 128
integer width = 283
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "관리번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kfz04om0_popup_kwan
integer x = 3497
integer y = 8
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)
SetNull(lstr_custom.gubun)
SetNull(lstr_custom.sano)
SetNull(lstr_custom.bnk)
SetNull(lstr_custom.status)
SetNull(lstr_custom.acc1)
SetNull(lstr_custom.acc2)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfz04om0_popup_kwan
integer x = 3323
integer y = 8
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

lstr_custom.code   = dw_1.GetItemString(ll_Row, "person_cd")
lstr_custom.name   = dw_1.GetItemString(ll_row,"person_nm")
lstr_custom.gubun  = dw_1.GetItemString(ll_row,"person_gu")
lstr_custom.sano   = dw_1.GetItemString(ll_row,"person_no")
lstr_custom.bnk    = dw_1.GetItemString(ll_row,"person_bnk")
lstr_custom.status = dw_1.GetItemString(ll_row,"person_sts")
lstr_custom.acc1   = dw_1.GetItemString(ll_row,"person_ac1")
lstr_custom.acc2   = dw_1.GetItemString(ll_row,"person_cd2")

IF lstr_custom.status ='2' THEN
	MessageBox("확 인","선택하신 자료는 사용불가 자료입니다.!!!")
	Return
END IF

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfz04om0_popup_kwan
integer x = 3150
integer y = 8
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String   ls_saup_no,ls_saupnm,ls_person,ls_sano
Integer  iRowCount

ls_saup_no = sle_1.text + "%"
ls_person = sle_2.text + "%"
ls_saupnm = "%"+Trim(sle_name.text)+"%"

If scusgbn = "1" Then
	ls_sano = "%"+Trim(sle_sano.text)+"%"
Else
	ls_sano = "%"
End if

if cbx_acgbn.Checked = True then
	dw_1.dataobject = 'dw_kfz04om0_popup'	
	dw_1.SetTransObject(Sqlca)
	
	rb_1.TriggerEvent(Clicked!)

	iRowCount = dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn,ls_person,ls_sano)
else
	dw_1.dataobject = 'dw_kfz04om0_popup_kwan'	
	dw_1.SetTransObject(Sqlca)
	
	rb_1.TriggerEvent(Clicked!)

	iRowCount = dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn,ls_person,Gs_Code,ls_sano)
end if

dw_1.SetRedraw(False)
IF iRowCount <=0 THEN
	MessageBox("확  인","해당하는 구분에 거래처가 존재하지 않습니다.!!!")
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

type st_5 from statictext within w_kfz04om0_popup_kwan
integer x = 1179
integer y = 56
integer width = 311
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "명칭"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_kfz04om0_popup_kwan
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 69
integer y = 264
integer width = 3589
integer height = 1784
integer taborder = 60
string dataobject = "dw_kfz04om0_popup_kwan"
boolean hscrollbar = true
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
IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

lstr_custom.code   = dw_1.GetItemString(Row, "person_cd")
lstr_custom.name   = dw_1.GetItemString(row,"person_nm")
lstr_custom.gubun  = dw_1.GetItemString(row,"person_gu")
lstr_custom.sano   = dw_1.GetItemString(row,"person_no")
lstr_custom.bnk    = dw_1.GetItemString(row,"person_bnk")
lstr_custom.status = dw_1.GetItemString(row,"person_sts")
lstr_custom.acc1   = dw_1.GetItemString(row,"person_ac1")
lstr_custom.acc2   = dw_1.GetItemString(row,"person_cd2")

IF lstr_custom.status ='2' THEN
	MessageBox("확 인","선택하신 자료는 사용불가 자료입니다.!!!")
	Return
END IF

//IF sCusGbn ='5' OR sCusGbn = '6' OR sCusGbn ='7' THEN
//	IF lstr_account.acc1_cd = lstr_custom.acc1 AND &
//										lstr_account.acc2_cd = lstr_custom.acc2 THEN
//	ELSE
//		MessageBox("확 인","입력하신 계정과목과 선택하신 계정과목이 다릅니다.!!")
//		Return
//	END IF
//END IF

Close(Parent)

end event

event clicked;string acc1_cd, acc2_cd, acc_name1, acc_name2

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	sle_1.text =dw_1.GetItemString(Row,"person_cd")
	sle_name.text =dw_1.GetItemString(Row,"person_nm")
	sle_2.text =dw_1.GetItemString(Row,"person_no")
	
	b_Flag = False
END IF

call super ::clicked
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type st_1 from statictext within w_kfz04om0_popup_kwan
integer x = 82
integer y = 64
integer width = 283
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "코드"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kfz04om0_popup_kwan
event ue_key pbm_keydown
integer x = 1509
integer y = 40
integer width = 690
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

event getfocus;f_toggle_kor(Handle(this))
end event

type sle_1 from singlelineedit within w_kfz04om0_popup_kwan
event ue_key pbm_keydown
integer x = 370
integer y = 48
integer width = 411
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
integer limit = 20
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type gb_1 from groupbox within w_kfz04om0_popup_kwan
integer x = 2341
integer y = 4
integer width = 782
integer height = 136
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kfz04om0_popup_kwan
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 24
integer width = 2190
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfz04om0_popup_kwan
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 252
integer width = 3616
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfz04om0_popup_kwan
integer linethickness = 1
integer beginx = 370
integer beginy = 116
integer endx = 782
integer endy = 116
end type

type ln_2 from line within w_kfz04om0_popup_kwan
integer linethickness = 1
integer beginx = 1509
integer beginy = 108
integer endx = 2203
integer endy = 108
end type

type ln_3 from line within w_kfz04om0_popup_kwan
integer linethickness = 1
integer beginx = 379
integer beginy = 200
integer endx = 955
integer endy = 200
end type

type ln_4 from line within w_kfz04om0_popup_kwan
integer linethickness = 1
integer beginx = 1509
integer beginy = 196
integer endx = 2089
integer endy = 196
end type

