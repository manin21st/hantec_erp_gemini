$PBExportHeader$w_pip5010_popup.srw
$PBExportComments$** 갑근 신고 자료 생성 - 법인정보 팝업
forward
global type w_pip5010_popup from w_inherite_standard
end type
type pb_1 from picturebutton within w_pip5010_popup
end type
type pb_2 from picturebutton within w_pip5010_popup
end type
type pb_3 from picturebutton within w_pip5010_popup
end type
type pb_4 from picturebutton within w_pip5010_popup
end type
type gb_7 from groupbox within w_pip5010_popup
end type
type gb_4 from groupbox within w_pip5010_popup
end type
type rb_1 from radiobutton within w_pip5010_popup
end type
type rb_2 from radiobutton within w_pip5010_popup
end type
type gb_5 from groupbox within w_pip5010_popup
end type
type gb_3 from groupbox within w_pip5010_popup
end type
type cb_kunmuil from commandbutton within w_pip5010_popup
end type
type dw_main from u_key_enter within w_pip5010_popup
end type
type sle_1 from singlelineedit within w_pip5010_popup
end type
type st_2 from statictext within w_pip5010_popup
end type
end forward

global type w_pip5010_popup from w_inherite_standard
integer width = 1787
integer height = 1112
string title = "법인정보 수정"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_dwtoggle pbm_custom40
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
gb_7 gb_7
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
gb_5 gb_5
gb_3 gb_3
cb_kunmuil cb_kunmuil
dw_main dw_main
sle_1 sle_1
st_2 st_2
end type
global w_pip5010_popup w_pip5010_popup

type variables
Int il_select_dw
String is_empno
u_ds_standard ds_1

//변경자료 저장시 flag
Boolean ib_ischanged

//현재 선택 버튼표시
String  sCurButton

//등록,수정 mode
String  is_status

St_Saupinfo sainfo //파라미터 오브젝트
end variables

on w_pip5010_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.gb_7=create gb_7
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_5=create gb_5
this.gb_3=create gb_3
this.cb_kunmuil=create cb_kunmuil
this.dw_main=create dw_main
this.sle_1=create sle_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.gb_7
this.Control[iCurrent+6]=this.gb_4
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.gb_5
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.cb_kunmuil
this.Control[iCurrent+12]=this.dw_main
this.Control[iCurrent+13]=this.sle_1
this.Control[iCurrent+14]=this.st_2
end on

on w_pip5010_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.gb_7)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_5)
destroy(this.gb_3)
destroy(this.cb_kunmuil)
destroy(this.dw_main)
destroy(this.sle_1)
destroy(this.st_2)
end on

event open;call super::open;f_window_center_response(this)

sainfo = Message.PowerObjectParm

dw_main.SetTransObject(SQLCA)
dw_main.InsertRow(0)

dw_main.SetItem(1,'saupno', sainfo.saupno)
dw_main.SetItem(1,'jurno', sainfo.jurno)
dw_main.SetItem(1,'jurname', sainfo.jurname)
dw_main.SetItem(1,'president', sainfo.president)
//dw_main.SetItem(1,'zip', sainfo.zip)
//dw_main.SetItem(1,'addr', sainfo.addr)
end event

type p_mod from w_inherite_standard`p_mod within w_pip5010_popup
boolean visible = false
integer x = 4037
integer y = 2708
end type

type p_del from w_inherite_standard`p_del within w_pip5010_popup
boolean visible = false
integer x = 4210
integer y = 2708
end type

type p_inq from w_inherite_standard`p_inq within w_pip5010_popup
boolean visible = false
integer x = 3342
integer y = 2708
end type

type p_print from w_inherite_standard`p_print within w_pip5010_popup
boolean visible = false
integer x = 3168
integer y = 2708
end type

type p_can from w_inherite_standard`p_can within w_pip5010_popup
boolean visible = false
integer x = 4384
integer y = 2708
end type

type p_exit from w_inherite_standard`p_exit within w_pip5010_popup
integer x = 1509
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_exit::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event p_exit::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

event p_exit::clicked;sainfo.saupno    = dw_main.GetItemString(1,'saupno')
sainfo.jurno     = dw_main.GetItemString(1,'jurno')
sainfo.jurname   = dw_main.GetItemString(1,'jurname')
sainfo.president = dw_main.GetItemString(1,'president')
//sainfo.zip       = dw_main.GetItemString(1,'zip')
//sainfo.addr      = dw_main.GetItemString(1,'addr')

CloseWithReturn(parent,sainfo)
end event

type p_ins from w_inherite_standard`p_ins within w_pip5010_popup
boolean visible = false
integer x = 3515
integer y = 2708
end type

type p_search from w_inherite_standard`p_search within w_pip5010_popup
boolean visible = false
integer x = 2994
integer y = 2708
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5010_popup
boolean visible = false
integer x = 3689
integer y = 2708
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5010_popup
boolean visible = false
integer x = 3863
integer y = 2708
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5010_popup
integer x = 1271
integer y = 2884
end type

type st_window from w_inherite_standard`st_window within w_pip5010_popup
integer x = 2258
integer y = 3160
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5010_popup
boolean visible = false
integer x = 2542
integer y = 2768
integer width = 425
integer height = 116
integer taborder = 210
end type

type cb_update from w_inherite_standard`cb_update within w_pip5010_popup
integer x = 2144
integer y = 2940
integer taborder = 0
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5010_popup
integer x = 503
integer y = 2940
integer taborder = 0
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5010_popup
integer x = 2510
integer y = 2940
integer taborder = 0
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5010_popup
integer x = 137
integer y = 2940
integer taborder = 0
end type

type st_1 from w_inherite_standard`st_1 within w_pip5010_popup
integer x = 91
integer y = 3160
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5010_popup
integer x = 2875
integer y = 2940
integer taborder = 0
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5010_popup
integer x = 2903
integer y = 3160
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5010_popup
integer x = 453
integer y = 3160
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5010_popup
integer x = 2103
integer y = 2880
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5010_popup
integer x = 101
integer y = 2880
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5010_popup
integer x = 73
integer y = 3108
end type

type pb_1 from picturebutton within w_pip5010_popup
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 3831
integer y = 3084
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\first.gif"
alignment htextalign = left!
end type

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_2 from picturebutton within w_pip5010_popup
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 3945
integer y = 3084
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
end type

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_3 from picturebutton within w_pip5010_popup
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 4050
integer y = 3084
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
end type

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type pb_4 from picturebutton within w_pip5010_popup
event clicked pbm_bnclicked
event losefocus pbm_bnkillfocus
boolean visible = false
integer x = 4160
integer y = 3084
integer width = 101
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\last.gif"
end type

on losefocus;parent.SetMicroHelp('인사기본사항')
end on

type gb_7 from groupbox within w_pip5010_popup
boolean visible = false
integer x = 1595
integer y = 2916
integer width = 485
integer height = 176
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_pip5010_popup
boolean visible = false
integer x = 3803
integer y = 2744
integer width = 485
integer height = 256
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "정렬"
end type

type rb_1 from radiobutton within w_pip5010_popup
boolean visible = false
integer x = 3890
integer y = 2808
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_pip5010_popup
boolean visible = false
integer x = 3890
integer y = 2896
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "성명순"
end type

type gb_5 from groupbox within w_pip5010_popup
boolean visible = false
integer x = 3803
integer y = 3020
integer width = 485
integer height = 184
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "자료선택"
end type

type gb_3 from groupbox within w_pip5010_popup
boolean visible = false
integer x = 50
integer y = 2780
integer width = 2341
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

type cb_kunmuil from commandbutton within w_pip5010_popup
integer x = 887
integer y = 2984
integer width = 357
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "근무일 생성"
end type

type dw_main from u_key_enter within w_pip5010_popup
integer x = 73
integer y = 284
integer width = 1646
integer height = 624
integer taborder = 0
string dataobject = "d_pip5010_popup"
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;if dwo.name = 'jurname' or dwo.name = 'president' then
	f_toggle_kor(handle(parent))
else
	f_toggle_eng(handle(parent))
end if
end event

type sle_1 from singlelineedit within w_pip5010_popup
integer x = 96
integer y = 76
integer width = 1298
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 18114285
long backcolor = 32106727
string text = "모든 자료에는 ~'-~'가 포함되지 않아야 합니다."
boolean border = false
end type

type st_2 from statictext within w_pip5010_popup
integer x = 96
integer y = 148
integer width = 1298
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 18114285
long backcolor = 32106727
string text = "반드시 확인하고 수정하시기 바랍니다."
boolean focusrectangle = false
end type

