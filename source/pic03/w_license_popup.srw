$PBExportHeader$w_license_popup.srw
$PBExportComments$** �ڰ� / ���� ��ȸ
forward
global type w_license_popup from w_inherite_popup
end type
type sle_find from singlelineedit within w_license_popup
end type
type st_2 from statictext within w_license_popup
end type
type rr_1 from roundrectangle within w_license_popup
end type
end forward

global type w_license_popup from w_inherite_popup
integer x = 1925
integer y = 84
integer width = 1650
integer height = 1676
string title = "�ڰ� / ���� ��ȸ ����"
boolean controlmenu = true
sle_find sle_find
st_2 st_2
rr_1 rr_1
end type
global w_license_popup w_license_popup

event open;call super::open;
dw_1.Retrieve("%")

sle_find.SetFocus()

end event

event key;call super::key;choose case key
	case keyenter!
		sle_find.TriggerEvent(Modified!)
end choose

end event

on w_license_popup.create
int iCurrent
call super::create
this.sle_find=create sle_find
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_find
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_license_popup.destroy
call super::destroy
destroy(this.sle_find)
destroy(this.st_2)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_license_popup
boolean visible = false
integer x = 0
integer y = 2760
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_license_popup
integer x = 1454
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_license_popup
boolean visible = false
integer x = 1723
integer y = 2612
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_license_popup
integer x = 1280
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "licensecode")
gs_codename = dw_1.GetItemString(ll_Row, "licensename")

Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_license_popup
integer x = 37
integer y = 184
integer width = 1563
integer height = 1368
string dataobject = "d_license_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
   dw_1.setfocus()
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "licensecode")
gs_codename = dw_1.GetItemString(Row, "licensename")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_license_popup
boolean visible = false
integer y = 2628
end type

type cb_1 from w_inherite_popup`cb_1 within w_license_popup
boolean visible = false
integer y = 2376
end type

type cb_return from w_inherite_popup`cb_return within w_license_popup
boolean visible = false
integer y = 2376
end type

type cb_inq from w_inherite_popup`cb_inq within w_license_popup
boolean visible = false
integer y = 2376
end type

type sle_1 from w_inherite_popup`sle_1 within w_license_popup
boolean visible = false
integer y = 2628
end type

type st_1 from w_inherite_popup`st_1 within w_license_popup
boolean visible = false
integer y = 2640
end type

type sle_find from singlelineedit within w_license_popup
integer x = 389
integer y = 56
integer width = 773
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;
f_toggle_kor(Handle(this))
end event

event modified;string sname

sname = Trim(sle_find.Text)

IF IsNull(sname) THEN
	sname =""
END IF

IF dw_1.Retrieve('%' + sname + '%') <=0 THEN
	MessageBox("Ȯ ��","��ȸ�� �ڷᰡ �����ϴ�!!")
	sle_find.SetFocus()
	Return
END IF
end event

type st_2 from statictext within w_license_popup
integer x = 37
integer y = 72
integer width = 352
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean enabled = false
string text = "�ڰ�/�����"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_license_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 1582
integer height = 1388
integer cornerheight = 40
integer cornerwidth = 46
end type

