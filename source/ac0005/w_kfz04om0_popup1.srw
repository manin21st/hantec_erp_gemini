$PBExportHeader$w_kfz04om0_popup1.srw
$PBExportComments$인명거래처 조회선택(거래처,은행,부서,사원,예적금 등: 사용불가 포함)(POPUP)
forward
global type w_kfz04om0_popup1 from window
end type
type rb_1 from radiobutton within w_kfz04om0_popup1
end type
type rb_2 from radiobutton within w_kfz04om0_popup1
end type
type rb_3 from radiobutton within w_kfz04om0_popup1
end type
type cb_3 from commandbutton within w_kfz04om0_popup1
end type
type cb_2 from commandbutton within w_kfz04om0_popup1
end type
type cb_1 from commandbutton within w_kfz04om0_popup1
end type
type sle_sano from singlelineedit within w_kfz04om0_popup1
end type
type st_6 from statictext within w_kfz04om0_popup1
end type
type p_inq from uo_picture within w_kfz04om0_popup1
end type
type p_choose from uo_picture within w_kfz04om0_popup1
end type
type p_exit from uo_picture within w_kfz04om0_popup1
end type
type sle_1 from singlelineedit within w_kfz04om0_popup1
end type
type sle_name from singlelineedit within w_kfz04om0_popup1
end type
type st_1 from statictext within w_kfz04om0_popup1
end type
type st_5 from statictext within w_kfz04om0_popup1
end type
type dw_1 from u_d_popup_sort within w_kfz04om0_popup1
end type
type gb_1 from groupbox within w_kfz04om0_popup1
end type
type rr_1 from roundrectangle within w_kfz04om0_popup1
end type
type ln_1 from line within w_kfz04om0_popup1
end type
type ln_2 from line within w_kfz04om0_popup1
end type
type rr_2 from roundrectangle within w_kfz04om0_popup1
end type
type ln_3 from line within w_kfz04om0_popup1
end type
end forward

global type w_kfz04om0_popup1 from window
integer x = 407
integer y = 4
integer width = 3456
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
st_6 st_6
p_inq p_inq
p_choose p_choose
p_exit p_exit
sle_1 sle_1
sle_name sle_name
st_1 st_1
st_5 st_5
dw_1 dw_1
gb_1 gb_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
ln_3 ln_3
end type
global w_kfz04om0_popup1 w_kfz04om0_popup1

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

on w_kfz04om0_popup1.create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_sano=create sle_sano
this.st_6=create st_6
this.p_inq=create p_inq
this.p_choose=create p_choose
this.p_exit=create p_exit
this.sle_1=create sle_1
this.sle_name=create sle_name
this.st_1=create st_1
this.st_5=create st_5
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.ln_3=create ln_3
this.Control[]={this.rb_1,&
this.rb_2,&
this.rb_3,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.sle_sano,&
this.st_6,&
this.p_inq,&
this.p_choose,&
this.p_exit,&
this.sle_1,&
this.sle_name,&
this.st_1,&
this.st_5,&
this.dw_1,&
this.gb_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.rr_2,&
this.ln_3}
end on

on w_kfz04om0_popup1.destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_sano)
destroy(this.st_6)
destroy(this.p_inq)
destroy(this.p_choose)
destroy(this.p_exit)
destroy(this.sle_1)
destroy(this.sle_name)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_2)
destroy(this.ln_3)
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

type rb_1 from radiobutton within w_kfz04om0_popup1
integer x = 2144
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

type rb_2 from radiobutton within w_kfz04om0_popup1
integer x = 2363
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

type rb_3 from radiobutton within w_kfz04om0_popup1
integer x = 2647
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

type cb_3 from commandbutton within w_kfz04om0_popup1
integer x = 4087
integer y = 624
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

type cb_2 from commandbutton within w_kfz04om0_popup1
integer x = 4087
integer y = 524
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

type cb_1 from commandbutton within w_kfz04om0_popup1
integer x = 4082
integer y = 424
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

type sle_sano from singlelineedit within w_kfz04om0_popup1
event ue_key pbm_keydown
integer x = 1632
integer y = 52
integer width = 384
integer height = 60
integer taborder = 30
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

type st_6 from statictext within w_kfz04om0_popup1
integer x = 1312
integer y = 64
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
string text = "사업자번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_inq from uo_picture within w_kfz04om0_popup1
integer x = 2894
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String ls_saup_no,ls_saupnm,ls_sano

ls_saup_no = sle_1.text + "%"
ls_saupnm = "%"+Trim(sle_name.text)+"%"

If scusgbn = "1" Then
	ls_sano = "%"+Trim(sle_sano.text)+"%"
Else
	ls_sano = "%"
End if

dw_1.SetRedraw(False)

rb_1.TriggerEvent(Clicked!)

IF dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn,ls_sano) <=0 THEN
	MessageBox("확  인","해당하는 구분에 거래처가 존재하지 않습니다.!!!")
	dw_1.SetRedraw(True)
	Return
//ELSE
//	if sCusGbn = '6' then
//		dw_1.SetFilter('custjan <> 0')
//	else
//		dw_1.SetFilter('')
//	end if
//	dw_1.Filter()	
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

type p_choose from uo_picture within w_kfz04om0_popup1
integer x = 3067
integer y = 8
integer width = 178
integer taborder = 60
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_exit from uo_picture within w_kfz04om0_popup1
integer x = 3241
integer y = 8
integer width = 178
integer taborder = 70
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

type sle_1 from singlelineedit within w_kfz04om0_popup1
event ue_key pbm_keydown
integer x = 192
integer y = 52
integer width = 343
integer height = 60
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

type sle_name from singlelineedit within w_kfz04om0_popup1
event ue_key pbm_keydown
integer x = 690
integer y = 52
integer width = 594
integer height = 60
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

type st_1 from statictext within w_kfz04om0_popup1
integer x = 46
integer y = 64
integer width = 146
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

type st_5 from statictext within w_kfz04om0_popup1
integer x = 553
integer y = 64
integer width = 137
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

type dw_1 from u_d_popup_sort within w_kfz04om0_popup1
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 46
integer y = 168
integer width = 3365
integer height = 1888
integer taborder = 50
string dataobject = "dw_kfz04om0_popup"
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

//IF lstr_custom.status ='2' THEN
//	MessageBox("확 인","선택하신 자료는 사용불가 자료입니다.!!!")
//	Return
//END IF

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
	
	b_Flag = False
END IF

call super ::clicked
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type gb_1 from groupbox within w_kfz04om0_popup1
integer x = 2107
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

type rr_1 from roundrectangle within w_kfz04om0_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 28
integer width = 2025
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfz04om0_popup1
integer linethickness = 1
integer beginx = 192
integer beginy = 116
integer endx = 535
integer endy = 116
end type

type ln_2 from line within w_kfz04om0_popup1
integer linethickness = 1
integer beginx = 704
integer beginy = 116
integer endx = 1294
integer endy = 116
end type

type rr_2 from roundrectangle within w_kfz04om0_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 3383
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_3 from line within w_kfz04om0_popup1
integer linethickness = 1
integer beginx = 1632
integer beginy = 116
integer endx = 2021
integer endy = 116
end type

