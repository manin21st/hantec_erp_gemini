$PBExportHeader$w_kfaa02b.srw
$PBExportComments$고정자산 마스타 조회 popup
forward
global type w_kfaa02b from window
end type
type st_5 from statictext within w_kfaa02b
end type
type st_4 from statictext within w_kfaa02b
end type
type p_choose from uo_picture within w_kfaa02b
end type
type p_inq from uo_picture within w_kfaa02b
end type
type p_exit from uo_picture within w_kfaa02b
end type
type dw_2 from datawindow within w_kfaa02b
end type
type st_2 from statictext within w_kfaa02b
end type
type em_1 from editmask within w_kfaa02b
end type
type st_3 from statictext within w_kfaa02b
end type
type sle_1 from singlelineedit within w_kfaa02b
end type
type st_1 from statictext within w_kfaa02b
end type
type cb_return from commandbutton within w_kfaa02b
end type
type cb_inq from commandbutton within w_kfaa02b
end type
type cb_select from commandbutton within w_kfaa02b
end type
type dw_1 from datawindow within w_kfaa02b
end type
type gb_1 from groupbox within w_kfaa02b
end type
type rr_1 from roundrectangle within w_kfaa02b
end type
type rr_2 from roundrectangle within w_kfaa02b
end type
type ln_1 from line within w_kfaa02b
end type
type ln_2 from line within w_kfaa02b
end type
end forward

global type w_kfaa02b from window
integer x = 850
integer y = 24
integer width = 3058
integer height = 2332
boolean titlebar = true
string title = "고정자산마스타 조회"
windowtype windowtype = response!
long backcolor = 32106727
st_5 st_5
st_4 st_4
p_choose p_choose
p_inq p_inq
p_exit p_exit
dw_2 dw_2
st_2 st_2
em_1 em_1
st_3 st_3
sle_1 sle_1
st_1 st_1
cb_return cb_return
cb_inq cb_inq
cb_select cb_select
dw_1 dw_1
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
end type
global w_kfaa02b w_kfaa02b

event open;string DKFCOD1, ls_saupj
long DKFCOD2

F_Window_Center_Response(This)

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.Reset()
dw_2.Reset()
dw_2.insertrow(0)

sle_1.text = gs_code
em_1.text  = gs_codename
dw_2.Setitem(dw_2.GetRow(),"kfsacod",gs_saupj)
//dw_2.acceptText()
//ls_saupj = dw_2.getitemstring(dw_2.getrow(),"kfsacod")
//if ls_saupj = "" or Isnull(ls_saupj) or ls_saupj = '9' then
//	ls_saupj = '%'
//end if

dKfCod1 = Trim(sle_1.Text)
IF dkfcod1 ="" OR IsNull(dkfcod1) THEN
	dkfcod1 ="%"
END IF

DKFCOD2 = long(em_1.text)

dw_1.Retrieve(gs_saupj,DKFCOD1,DKFCOD2)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

on w_kfaa02b.create
this.st_5=create st_5
this.st_4=create st_4
this.p_choose=create p_choose
this.p_inq=create p_inq
this.p_exit=create p_exit
this.dw_2=create dw_2
this.st_2=create st_2
this.em_1=create em_1
this.st_3=create st_3
this.sle_1=create sle_1
this.st_1=create st_1
this.cb_return=create cb_return
this.cb_inq=create cb_inq
this.cb_select=create cb_select
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.st_5,&
this.st_4,&
this.p_choose,&
this.p_inq,&
this.p_exit,&
this.dw_2,&
this.st_2,&
this.em_1,&
this.st_3,&
this.sle_1,&
this.st_1,&
this.cb_return,&
this.cb_inq,&
this.cb_select,&
this.dw_1,&
this.gb_1,&
this.rr_1,&
this.rr_2,&
this.ln_1,&
this.ln_2}
end on

on w_kfaa02b.destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.cb_return)
destroy(this.cb_inq)
destroy(this.cb_select)
destroy(this.dw_1)
destroy(this.gb_1)
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

type st_5 from statictext within w_kfaa02b
integer x = 1120
integer y = 64
integer width = 64
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_kfaa02b
integer x = 59
integer y = 64
integer width = 64
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_choose from uo_picture within w_kfaa02b
integer x = 2661
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

event clicked;call super::clicked;long ll_row

ll_row = dw_1.GetSelectedRow(0)
if ll_row = 0 then
   messagebox("확인","조회한 자료중 하나를 선택하시오. !!!")
   return
end if

gs_code   = dw_1.GetItemString(ll_row,"kfcod1")
gs_codename = String(dw_1.GetItemNumber(ll_row,"kfcod2"))
gs_gubun = dw_1.GetItemString(ll_row,"kfname")

Close(parent)






end event

type p_inq from uo_picture within w_kfaa02b
integer x = 2487
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event clicked;call super::clicked;string dkfcod1, ls_saupj
LONG dkfcod2

dw_2.AcceptText()
ls_saupj = dw_2.Getitemstring(dw_2.Getrow(),'kfsacod')
if ls_saupj = "" or ls_saupj = '99' or Isnull(ls_saupj) then
	ls_saupj = '%'
end if

dkfcod1 = sle_1.text + "%"
dkfcod2 = LONG(em_1.text)

dw_1.Retrieve(ls_saupj, dkfcod1, dkfcod2)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end event

type p_exit from uo_picture within w_kfaa02b
integer x = 2834
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)

end event

type dw_2 from datawindow within w_kfaa02b
integer x = 311
integer y = 52
integer width = 690
integer height = 84
integer taborder = 10
string dataobject = "d_kfaa02b_2"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_kfaa02b
integer x = 119
integer y = 64
integer width = 187
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "사업장"
boolean focusrectangle = false
end type

type em_1 from editmask within w_kfaa02b
integer x = 1723
integer y = 60
integer width = 320
integer height = 64
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
string mask = "########"
end type

event modified;//char dkfcod1
//LONG dkfcod2
//
//dkfcod1 = sle_1.text
//dkfcod2 = LONG(em_1.text)
//
//dw_1.Retrieve(dkfcod1, dkfcod2)
end event

type st_3 from statictext within w_kfaa02b
integer x = 1655
integer y = 68
integer width = 55
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfaa02b
integer x = 1531
integer y = 60
integer width = 110
integer height = 64
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
integer limit = 1
end type

event modified;//char dkfcod1
//LONG dkfcod2
//
//dkfcod1 = sle_1.text
//dkfcod2 = LONG(em_1.text)
//
//dw_1.Retrieve(dkfcod1, dkfcod2)
end event

type st_1 from statictext within w_kfaa02b
integer x = 1179
integer y = 68
integer width = 352
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "고정자산번호"
boolean focusrectangle = false
end type

type cb_return from commandbutton within w_kfaa02b
boolean visible = false
integer x = 2373
integer y = 2700
integer width = 315
integer height = 104
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)

end event

type cb_inq from commandbutton within w_kfaa02b
boolean visible = false
integer x = 2039
integer y = 2700
integer width = 315
integer height = 104
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
boolean default = true
end type

event clicked;string dkfcod1, ls_saupj
LONG dkfcod2

dw_2.AcceptText()
ls_saupj = dw_2.Getitemstring(dw_2.Getrow(),'kfsacod')
if ls_saupj = "" or ls_saupj = '99' or Isnull(ls_saupj) then
	ls_saupj = '%'
end if

dkfcod1 = sle_1.text + "%"
dkfcod2 = LONG(em_1.text)

dw_1.Retrieve(ls_saupj, dkfcod1, dkfcod2)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end event

type cb_select from commandbutton within w_kfaa02b
boolean visible = false
integer x = 1705
integer y = 2700
integer width = 315
integer height = 104
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;long ll_row

ll_row = dw_1.GetSelectedRow(0)
if ll_row = 0 then
   messagebox("확인","조회한 자료중 하나를 선택하시오. !!!")
   return
end if

gs_code   = dw_1.GetItemString(ll_row,"kfcod1")
gs_codename = String(dw_1.GetItemNumber(ll_row,"kfcod2"))
gs_gubun = dw_1.GetItemString(ll_row,"kfname")

Close(parent)






end event

type dw_1 from datawindow within w_kfaa02b
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 216
integer width = 2976
integer height = 1968
integer taborder = 40
string dataobject = "d_kfaa02b"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

event clicked;integer li_row
char dkfcod1
long dkfcod2

li_row = GetClickedRow()

if li_row = 0 then return

dkfcod1 = dw_1.GetItemString(li_row, "kfcod1")
dkfcod2 = dw_1.GetItemNumber(li_row, "kfcod2")

sle_1.text = dkfcod1
em_1.text = string(dkfcod2,'00000000')

if GetSelectedRow( li_row - 1 ) = li_row then
   SelectRow(li_row, False)
else
   SelectRow(0, False)
   SelectRow(li_row, True)
end if
end event

event doubleclicked;
if row <= 0 then return

gs_code     = dw_1.GetItemString(row,"kfcod1")
gs_codename = String(dw_1.GetItemNumber(row,"kfcod2"))
gs_gubun = dw_1.GetItemString(row,"kfname")

Close(parent)





end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type gb_1 from groupbox within w_kfaa02b
boolean visible = false
integer x = 1655
integer y = 2648
integer width = 1061
integer height = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfaa02b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 212
integer width = 3003
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfaa02b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 28
integer width = 2075
integer height = 128
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfaa02b
integer linethickness = 1
integer beginx = 1531
integer beginy = 124
integer endx = 1637
integer endy = 124
end type

type ln_2 from line within w_kfaa02b
integer linethickness = 1
integer beginx = 1719
integer beginy = 124
integer endx = 2053
integer endy = 124
end type

