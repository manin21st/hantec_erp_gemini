$PBExportHeader$w_kcda03c.srw
$PBExportComments$구분코드명칭 등록
forward
global type w_kcda03c from window
end type
type p_1 from uo_picture within w_kcda03c
end type
type p_exit from uo_picture within w_kcda03c
end type
type dw_insert from datawindow within w_kcda03c
end type
type st_2 from statictext within w_kcda03c
end type
type cb_2 from commandbutton within w_kcda03c
end type
type cb_1 from commandbutton within w_kcda03c
end type
type rr_1 from roundrectangle within w_kcda03c
end type
end forward

global type w_kcda03c from window
integer x = 837
integer y = 672
integer width = 1541
integer height = 716
boolean titlebar = true
string title = "구분코드 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
event key pbm_keydown
p_1 p_1
p_exit p_exit
dw_insert dw_insert
st_2 st_2
cb_2 cb_2
cb_1 cb_1
rr_1 rr_1
end type
global w_kcda03c w_kcda03c

type variables
string sGucode
end variables

event key;Choose Case key
	Case KeyZ!
		p_1.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

event open;dw_insert.SetTransObject(sqlca)
dw_insert.Reset()
dw_insert.Insertrow(0)

dw_insert.SetFocus()
end event

on w_kcda03c.create
this.p_1=create p_1
this.p_exit=create p_exit
this.dw_insert=create dw_insert
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.p_exit,&
this.dw_insert,&
this.st_2,&
this.cb_2,&
this.cb_1,&
this.rr_1}
end on

on w_kcda03c.destroy
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.dw_insert)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rr_1)
end on

type p_1 from uo_picture within w_kcda03c
integer x = 1093
integer y = 20
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;String sRfCod,sRfname

if dw_insert.AcceptText() = -1 then return
sRfCod  = dw_insert.GetItemString(1,"rfcod")
sRfName = dw_insert.GetItemString(1,"rfna1")

IF sRfCod = '' OR IsNull(sRfCod) THEN
	F_MessageChk(1,'[구분코드]')
	dw_insert.Setcolumn("rfcod")
	dw_insert.Setfocus()
	Return
END IF
IF sRfName = '' OR IsNull(sRfName) THEN
	F_MessageChk(1,'[구분명칭]')
	dw_insert.Setcolumn("rfna1")
	dw_insert.Setfocus()
	Return
END IF
IF dw_insert.Update() <> 1 then
	F_MessageChk(13,'')
	Rollback;
	Return
END IF
Commit;

CloseWithReturn(parent,'1')
end event

type p_exit from uo_picture within w_kcda03c
integer x = 1271
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;CloseWithReturn(PARENT,'0')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_insert from datawindow within w_kcda03c
event ue_enter pbm_dwnprocessenter
integer x = 137
integer y = 208
integer width = 1289
integer height = 348
integer taborder = 10
string dataobject = "dw_kcda03c_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event itemchanged;String   sRfCod,sNull
Integer  iDbCnt

SetNull(sNull)

IF this.GetColumnName() = "rfcod" THEN
	sRfCod = this.GetText()
	IF sRfCod = '' OR IsNull(sRfCod) THEN Return
	
	select Count(*) 	into :iDbCnt  from reffpf where rfcod = :sRfCod and rfgub = '00';
	if sqlca.sqlcode = 0 and iDbCnt > 0 then
		F_MessageChk(10,'')
		this.SetItem(this.GetRow(),"rfcod",sNull)
		Return 1
	end if
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rfna1" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type st_2 from statictext within w_kcda03c
integer x = 247
integer y = 208
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_kcda03c
integer x = 800
integer y = 1020
integer width = 590
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;CloseWithReturn(PARENT,'0')
end event

type cb_1 from commandbutton within w_kcda03c
integer x = 105
integer y = 1028
integer width = 590
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&O)"
end type

event clicked;String sRfCod,sRfname

if dw_insert.AcceptText() = -1 then return
sRfCod  = dw_insert.GetItemString(1,"rfcod")
sRfName = dw_insert.GetItemString(1,"rfna1")

IF sRfCod = '' OR IsNull(sRfCod) THEN
	F_MessageChk(1,'[구분코드]')
	dw_insert.Setcolumn("rfcod")
	dw_insert.Setfocus()
	Return
END IF
IF sRfName = '' OR IsNull(sRfName) THEN
	F_MessageChk(1,'[구분명칭]')
	dw_insert.Setcolumn("rfna1")
	dw_insert.Setfocus()
	Return
END IF
IF dw_insert.Update() <> 1 then
	F_MessageChk(13,'')
	Rollback;
	Return
END IF
Commit;

CloseWithReturn(parent,'1')
end event

type rr_1 from roundrectangle within w_kcda03c
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 184
integer width = 1394
integer height = 388
integer cornerheight = 40
integer cornerwidth = 46
end type

