$PBExportHeader$w_kcda01a.srw
$PBExportComments$계정과목 일괄 수정
forward
global type w_kcda01a from window
end type
type p_exit from uo_picture within w_kcda01a
end type
type p_mod from uo_picture within w_kcda01a
end type
type p_inq from uo_picture within w_kcda01a
end type
type rr_1 from roundrectangle within w_kcda01a
end type
type p_1 from picture within w_kcda01a
end type
type cbx_1 from checkbox within w_kcda01a
end type
type sle_gaejname from singlelineedit within w_kcda01a
end type
type sle_gaej2 from singlelineedit within w_kcda01a
end type
type st_2 from statictext within w_kcda01a
end type
type st_1 from statictext within w_kcda01a
end type
type sle_gaej1 from singlelineedit within w_kcda01a
end type
type dw_1 from datawindow within w_kcda01a
end type
type gb_2 from groupbox within w_kcda01a
end type
type ln_1 from line within w_kcda01a
end type
type ln_2 from line within w_kcda01a
end type
type ln_3 from line within w_kcda01a
end type
type rr_2 from roundrectangle within w_kcda01a
end type
end forward

global type w_kcda01a from window
integer x = 59
integer y = 48
integer width = 4498
integer height = 2400
boolean titlebar = true
string title = "계정과목조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
event key pbm_keydown
p_exit p_exit
p_mod p_mod
p_inq p_inq
rr_1 rr_1
p_1 p_1
cbx_1 cbx_1
sle_gaejname sle_gaejname
sle_gaej2 sle_gaej2
st_2 st_2
st_1 st_1
sle_gaej1 sle_gaej1
dw_1 dw_1
gb_2 gb_2
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
rr_2 rr_2
end type
global w_kcda01a w_kcda01a

type variables
long ll_scale

w_preview  iw_preview

end variables

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

event open;
F_Window_Center_Response(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sle_gaej1.SetFocus()

open( iw_preview, this)



end event

on w_kcda01a.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_inq=create p_inq
this.rr_1=create rr_1
this.p_1=create p_1
this.cbx_1=create cbx_1
this.sle_gaejname=create sle_gaejname
this.sle_gaej2=create sle_gaej2
this.st_2=create st_2
this.st_1=create st_1
this.sle_gaej1=create sle_gaej1
this.dw_1=create dw_1
this.gb_2=create gb_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_mod,&
this.p_inq,&
this.rr_1,&
this.p_1,&
this.cbx_1,&
this.sle_gaejname,&
this.sle_gaej2,&
this.st_2,&
this.st_1,&
this.sle_gaej1,&
this.dw_1,&
this.gb_2,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.rr_2}
end on

on w_kcda01a.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.rr_1)
destroy(this.p_1)
destroy(this.cbx_1)
destroy(this.sle_gaejname)
destroy(this.sle_gaej2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_gaej1)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.rr_2)
end on

type p_exit from uo_picture within w_kcda01a
integer x = 4238
integer y = 4
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_mod from uo_picture within w_kcda01a
integer x = 4064
integer y = 8
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;
IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","변경한 자료 저장 실패 !!")
	ROLLBACK;
	RETURN
END IF
commit;
P_inq.TriggerEvent(Clicked!)



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_kcda01a
integer x = 3890
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String ls_gaejung1,ls_gaejung2,ls_name,ls_colx

ls_gaejung1 = sle_gaej1.text + "%"
ls_name     = "%" + Trim(sle_gaejname.text) + "%"

dw_1.Reset()
IF dw_1.Retrieve(ls_gaejung1,ls_name) <= 0 THEN
	MessageBox("확  인","조회한 자료가 없습니다.!!!")
	Return
ELSE
	dw_1.SetTabOrder("acc1_cd",0)
	dw_1.SetTabOrder("acc2_cd",0)
END IF

//h split scrollbar
ls_colx = dw_1.Object.dc_gu.x

// Set the position of the horizontal split scroll point.
dw_1.Object.datawindow.horizontalscrollsplit = ls_colx


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type rr_1 from roundrectangle within w_kcda01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 24
integer width = 1810
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from picture within w_kcda01a
integer x = 311
integer y = 56
integer width = 59
integer height = 56
boolean originalsize = true
string picturename = "C:\erpman\image\pop_3.jpg"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_kcda01a
boolean visible = false
integer x = 3241
integer y = 76
integer width = 603
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "계정과목 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '계정과목 출력'
iw_preview.dw_preview.dataobject = 'dw_kcda01a_2'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=1 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve('%','%') <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type sle_gaejname from singlelineedit within w_kcda01a
integer x = 750
integer y = 56
integer width = 1051
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
boolean autohscroll = false
end type

event getfocus;Long wnd

wnd =Handle(this)

f_toggle_kor(wnd)

end event

event losefocus;Long wnd

wnd =Handle(this)

f_toggle_eng(wnd)

end event

type sle_gaej2 from singlelineedit within w_kcda01a
event ue_key pbm_keydown
integer x = 635
integer y = 56
integer width = 91
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
textcase textcase = upper!
integer limit = 2
end type

event ue_key;IF key = KeyF1! THEN
	this.TriggerEvent(RbuttonDown!)		
END IF
end event

event rbuttondown;//String ls_gj1,ls_gj2,rec_acc1,rec_acc2
//
//ls_gj1 =sle_gaej1.text
//ls_gj2 =sle_gaej2.text
//
//IF IsNull(ls_gj1) then
//   ls_gj1 = ""
//end if
//IF IsNull(ls_gj2) then
//   ls_gj2 = ""
//end if
//
// lstr_account.acc1_cd = Trim(ls_gj1)
//lstr_account.acc2_cd = Trim(ls_gj2)
//
//Open(W_KFZ01OM0_POPUP)
//
//IF IsNull(lstr_account.acc1_cd) OR IsNull(lstr_account.acc2_cd) THEN RETURN
//
//sle_gaej1.SetFocus()
//sle_gaej1.text = lstr_account.acc1_cd
//sle_gaej2.text = lstr_account.acc2_cd
//
//sle_gaejname.text = lstr_account.acc1_nm+"--"+lstr_account.acc2_nm
end event

type st_2 from statictext within w_kcda01a
integer x = 585
integer y = 60
integer width = 46
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long backcolor = 32106727
boolean enabled = false
string text = "-"
alignment alignment = center!
long bordercolor = 12632256
boolean focusrectangle = false
end type

type st_1 from statictext within w_kcda01a
integer x = 64
integer y = 64
integer width = 329
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "계정코드"
boolean focusrectangle = false
end type

type sle_gaej1 from singlelineedit within w_kcda01a
event ue_key pbm_keydown
integer x = 402
integer y = 56
integer width = 178
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
textcase textcase = upper!
integer limit = 5
end type

event ue_key;IF key = KeyF1! or key = keytab! THEN
	this.TriggerEvent(RbuttonDown!)		
END IF
end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

ls_gj1 =sle_gaej1.text
ls_gj2 =sle_gaej2.text

IF IsNull(ls_gj1) then
   ls_gj1 = ""
end if
IF IsNull(ls_gj2) then
   ls_gj2 = ""
end if

lstr_account.acc1_cd = Trim(ls_gj1)
lstr_account.acc2_cd = Trim(ls_gj2)

Open(W_KFZ01OM0_POPUP)

IF IsNull(lstr_account.acc1_cd) OR IsNull(lstr_account.acc2_cd) THEN RETURN

sle_gaej1.SetFocus()
sle_gaej1.text = lstr_account.acc1_cd
sle_gaej2.text = lstr_account.acc2_cd

sle_gaejname.text = lstr_account.acc2_nm

end event

type dw_1 from datawindow within w_kcda01a
event ue_keyenter pbm_dwnprocessenter
integer x = 55
integer y = 188
integer width = 4343
integer height = 2048
integer taborder = 50
string dataobject = "dw_kcda01a_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)

Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="acc1_nm" OR dwo.name ="acc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type gb_2 from groupbox within w_kcda01a
boolean visible = false
integer x = 3200
integer y = 28
integer width = 672
integer height = 124
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type ln_1 from line within w_kcda01a
integer linethickness = 1
integer beginx = 402
integer beginy = 128
integer endx = 581
integer endy = 128
end type

type ln_2 from line within w_kcda01a
integer linethickness = 1
integer beginx = 635
integer beginy = 128
integer endx = 731
integer endy = 128
end type

type ln_3 from line within w_kcda01a
integer linethickness = 1
integer beginx = 750
integer beginy = 128
integer endx = 1806
integer endy = 128
end type

type rr_2 from roundrectangle within w_kcda01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 184
integer width = 4375
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

