$PBExportHeader$w_kfz04om0_popup_all.srw
$PBExportComments$인명거래처 조회선택(전체)(POPUP)
forward
global type w_kfz04om0_popup_all from window
end type
type dw_gbn from u_key_enter within w_kfz04om0_popup_all
end type
type rb_1 from radiobutton within w_kfz04om0_popup_all
end type
type rb_2 from radiobutton within w_kfz04om0_popup_all
end type
type rb_3 from radiobutton within w_kfz04om0_popup_all
end type
type cb_3 from commandbutton within w_kfz04om0_popup_all
end type
type cb_2 from commandbutton within w_kfz04om0_popup_all
end type
type cb_1 from commandbutton within w_kfz04om0_popup_all
end type
type p_inq from uo_picture within w_kfz04om0_popup_all
end type
type p_choose from uo_picture within w_kfz04om0_popup_all
end type
type p_exit from uo_picture within w_kfz04om0_popup_all
end type
type dw_1 from u_d_popup_sort within w_kfz04om0_popup_all
end type
type gb_1 from groupbox within w_kfz04om0_popup_all
end type
type rr_2 from roundrectangle within w_kfz04om0_popup_all
end type
end forward

global type w_kfz04om0_popup_all from window
integer x = 407
integer y = 4
integer width = 3456
integer height = 2380
boolean titlebar = true
string title = "거래처 조회"
windowtype windowtype = response!
long backcolor = 32106727
dw_gbn dw_gbn
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_inq p_inq
p_choose p_choose
p_exit p_exit
dw_1 dw_1
gb_1 gb_1
rr_2 rr_2
end type
global w_kfz04om0_popup_all w_kfz04om0_popup_all

type variables
String sCusGbn

end variables

event open;String ls_saup,saup_nm, ls_string,sFocusCd

F_Window_Center_Response(This)

//sFocusCd = lstr_custom.code
//if IsNull(sFocusCd) then sFocusCd = ''

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_gbn.SetTransObject(SQLCA)
dw_gbn.Reset()
dw_gbn.InsertRow(0)
dw_gbn.SetColumn("rfgub")
dw_gbn.SetFocus()

//p_inq.triggerevent(clicked!)




end event

on w_kfz04om0_popup_all.create
this.dw_gbn=create dw_gbn
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_inq=create p_inq
this.p_choose=create p_choose
this.p_exit=create p_exit
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_2=create rr_2
this.Control[]={this.dw_gbn,&
this.rb_1,&
this.rb_2,&
this.rb_3,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_inq,&
this.p_choose,&
this.p_exit,&
this.dw_1,&
this.gb_1,&
this.rr_2}
end on

on w_kfz04om0_popup_all.destroy
destroy(this.dw_gbn)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_inq)
destroy(this.p_choose)
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.gb_1)
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

type dw_gbn from u_key_enter within w_kfz04om0_popup_all
event ue_key pbm_dwnkey
integer x = 37
integer y = 4
integer width = 2043
integer height = 156
integer taborder = 50
string dataobject = "dw_kfz04om0_popup_all"
boolean border = false
end type

event ue_key;choose case key
	Case KeyEnter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event itemfocuschanged;call super::itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="codename" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type rb_1 from radiobutton within w_kfz04om0_popup_all
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

type rb_2 from radiobutton within w_kfz04om0_popup_all
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

type rb_3 from radiobutton within w_kfz04om0_popup_all
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

type cb_3 from commandbutton within w_kfz04om0_popup_all
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

type cb_2 from commandbutton within w_kfz04om0_popup_all
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

type cb_1 from commandbutton within w_kfz04om0_popup_all
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

type p_inq from uo_picture within w_kfz04om0_popup_all
integer x = 2894
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sCode,sCodeNm

dw_gbn.AcceptText()
sCusGbn = dw_gbn.GetItemString(1,"rfgub")
sCode   = dw_gbn.GetItemString(1,"code")
sCodeNm = dw_gbn.GetItemString(1,"codename") 

if sCusGbn = '' or IsNull(sCusGbn) then sCusGbn = '%'
if IsNull(sCode) then sCode = ''
sCode = '%' + sCode + '%'
if IsNull(sCodeNm) then sCodeNm = ''
sCodeNm = '%' + sCodeNm + '%'

dw_1.SetRedraw(False)

rb_1.TriggerEvent(Clicked!)

IF dw_1.Retrieve(sCode,sCodeNm,scusgbn,'%') <=0 THEN
//	F_MessageChk(14,'')
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

type p_choose from uo_picture within w_kfz04om0_popup_all
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

type p_exit from uo_picture within w_kfz04om0_popup_all
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

type dw_1 from u_d_popup_sort within w_kfz04om0_popup_all
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

	b_Flag = False
END IF

call super ::clicked
end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type gb_1 from groupbox within w_kfz04om0_popup_all
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

type rr_2 from roundrectangle within w_kfz04om0_popup_all
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

