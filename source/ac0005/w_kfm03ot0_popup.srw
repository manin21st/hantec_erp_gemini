$PBExportHeader$w_kfm03ot0_popup.srw
$PBExportComments$���Ա� ��ȸ����(POPUP)
forward
global type w_kfm03ot0_popup from window
end type
type cb_3 from commandbutton within w_kfm03ot0_popup
end type
type cb_2 from commandbutton within w_kfm03ot0_popup
end type
type cb_1 from commandbutton within w_kfm03ot0_popup
end type
type p_exit from uo_picture within w_kfm03ot0_popup
end type
type p_choose from uo_picture within w_kfm03ot0_popup
end type
type p_inq from uo_picture within w_kfm03ot0_popup
end type
type dw_1 from u_d_popup_sort within w_kfm03ot0_popup
end type
type st_1 from statictext within w_kfm03ot0_popup
end type
type sle_name from singlelineedit within w_kfm03ot0_popup
end type
type sle_1 from singlelineedit within w_kfm03ot0_popup
end type
type rr_1 from roundrectangle within w_kfm03ot0_popup
end type
type ln_1 from line within w_kfm03ot0_popup
end type
type ln_2 from line within w_kfm03ot0_popup
end type
type rr_2 from roundrectangle within w_kfm03ot0_popup
end type
end forward

global type w_kfm03ot0_popup from window
integer x = 329
integer y = 4
integer width = 3342
integer height = 2272
boolean titlebar = true
string title = "���Ա� ��ȸ ����"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_1 dw_1
st_1 st_1
sle_name sle_name
sle_1 sle_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_kfm03ot0_popup w_kfm03ot0_popup

type variables
long rownum
end variables

event open;String scode,sname, ls_string

F_Window_Center_Response(This)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

//sle_1.text = gs_code
//sname =Trim(sle_name.text)+"%"

ls_string = f_nvl(gs_code, "")

If Len(ls_string) > 0 Then
	Choose Case Asc(ls_string)
		//���� - �ڵ�
		Case is < 65
			sle_1.text = ls_string

		//���� - ��Ī
		Case is >= 65
			sle_name.text = ls_string

	End Choose
End If

p_inq.triggerevent(clicked!)

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if
end event

on w_kfm03ot0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_1,&
this.st_1,&
this.sle_name,&
this.sle_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.rr_2}
end on

on w_kfm03ot0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
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

type cb_3 from commandbutton within w_kfm03ot0_popup
integer x = 3749
integer y = 600
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_kfm03ot0_popup
integer x = 3749
integer y = 500
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&V)"
end type

event clicked;p_choose.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_kfm03ot0_popup
integer x = 3744
integer y = 400
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kfm03ot0_popup
integer x = 3131
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\���_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\���_up.gif'
end event

type p_choose from uo_picture within w_kfm03ot0_popup
integer x = 2958
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ok ��ư�� �����ʽÿ� !")
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "lo_cd")
gs_codename= dw_1.GetItemString(ll_row,"lo_name")

Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\����_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\����_up.gif'
end event

type p_inq from uo_picture within w_kfm03ot0_popup
integer x = 2784
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"
sname  = "%" + Trim(sle_name.text) + "%"

IF dw_1.Retrieve(scode,sname) <= 0 THEN
	MessageBox("Ȯ ��","��ȸ�� �ڷᰡ �����ϴ�.!!!")
	sle_1.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\��ȸ_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\��ȸ_up.gif'
end event

type dw_1 from u_d_popup_sort within w_kfm03ot0_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 50
integer y = 168
integer width = 3241
integer height = 1880
integer taborder = 40
string dataobject = "dw_kfm03ot0_popup"
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
	sle_1.text =dw_1.GetItemString(Row,"lo_cd")
	sle_name.text =dw_1.GetItemString(Row,"lo_name")

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;IF row <=0 THEN RETURN

gs_code= dw_1.GetItemString(Row, "lo_cd")
gs_codename= dw_1.GetItemString(row,"lo_name")

Close(Parent)

end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type st_1 from statictext within w_kfm03ot0_popup
integer x = 59
integer y = 48
integer width = 306
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean enabled = false
string text = "���Ա��ڵ�"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_name from singlelineedit within w_kfm03ot0_popup
event ue_key pbm_keydown
integer x = 992
integer y = 36
integer width = 777
integer height = 68
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( "%" , "%" + sle_name.TEXT + "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("Ȯ ��","��ȸ�� �ڷᰡ �����ϴ�.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

event getfocus;
f_toggle_kor(Handle(this))
end event

type sle_1 from singlelineedit within w_kfm03ot0_popup
event ue_key pbm_keydown
integer x = 389
integer y = 36
integer width = 594
integer height = 68
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( sle_1.TEXT + "%" ,  "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("Ȯ ��","��ȸ�� �ڷᰡ �����ϴ�.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type rr_1 from roundrectangle within w_kfm03ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 12
integer width = 1787
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfm03ot0_popup
integer linethickness = 1
integer beginx = 393
integer beginy = 104
integer endx = 978
integer endy = 104
end type

type ln_2 from line within w_kfm03ot0_popup
integer linethickness = 1
integer beginx = 992
integer beginy = 104
integer endx = 1774
integer endy = 104
end type

type rr_2 from roundrectangle within w_kfm03ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 3273
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

