$PBExportHeader$w_employee_popup_pis2020.srw
$PBExportComments$** ��� ��ȸ ����
forward
global type w_employee_popup_pis2020 from w_inherite_popup
end type
type st_2 from statictext within w_employee_popup_pis2020
end type
type sle_find from singlelineedit within w_employee_popup_pis2020
end type
type rb_3 from radiobutton within w_employee_popup_pis2020
end type
type rb_4 from radiobutton within w_employee_popup_pis2020
end type
type rb_5 from radiobutton within w_employee_popup_pis2020
end type
type rb_6 from radiobutton within w_employee_popup_pis2020
end type
type rb_1 from radiobutton within w_employee_popup_pis2020
end type
type rb_2 from radiobutton within w_employee_popup_pis2020
end type
type gb_1 from groupbox within w_employee_popup_pis2020
end type
type gb_2 from groupbox within w_employee_popup_pis2020
end type
type rr_1 from roundrectangle within w_employee_popup_pis2020
end type
end forward

global type w_employee_popup_pis2020 from w_inherite_popup
integer width = 2725
integer height = 2280
string title = "��������ȸ����"
st_2 st_2
sle_find sle_find
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_employee_popup_pis2020 w_employee_popup_pis2020

type variables
String  sService,sDate_title
end variables

forward prototypes
public subroutine wf_retrieve ()
end prototypes

public subroutine wf_retrieve ();String scode,sname

setnull(gs_code)
setnull(gs_codename)

scode = Gs_code
sname = Gs_codeName

IF IsNull(scode) AND IsNull(sname)THEN
	sle_find.text = ""
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,'%','%',sSerVice,sDate_title)
ELSEIF Not IsNull(scode) AND IsNull(sname)THEN
	sle_find.Text = scode
	rb_1.Checked = True
	dw_1.Retrieve(gs_company,scode + '%','%',sSerVice,sDate_title)
ELSEIF IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text = sname
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,'%',sname + '%',sSerVice,sDate_title)
ELSEIF Not IsNull(scode) AND Not IsNull(sname)THEN
	sle_find.Text =""
	rb_2.Checked = True
	dw_1.Retrieve(gs_company,scode + '%',sname + '%',sSerVice,sDate_title)
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
end subroutine

event open;call super::open;f_window_center_response(this)
String scode,sname

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sSerVice = '1'
sDate_title = '�Ի�����'

rb_3.Checked = True

wf_retrieve()

//sle_find.SetFocus()
dw_1.SetFocus()
end event

on w_employee_popup_pis2020.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_find=create sle_find
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_find
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.rr_1
end on

on w_employee_popup_pis2020.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_find)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_employee_popup_pis2020
boolean visible = false
integer x = 2857
integer y = 268
integer width = 87
integer height = 48
end type

type p_exit from w_inherite_popup`p_exit within w_employee_popup_pis2020
integer x = 2482
integer y = 0
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)



end event

type p_inq from w_inherite_popup`p_inq within w_employee_popup_pis2020
boolean visible = false
integer x = 2738
integer y = 172
end type

type p_choose from w_inherite_popup`p_choose within w_employee_popup_pis2020
integer x = 2309
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_employee_popup_pis2020
integer x = 37
integer y = 160
integer width = 2619
integer height = 1996
string dataobject = "d_employee_popup_pis2020"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_employee_popup_pis2020
end type

type cb_1 from w_inherite_popup`cb_1 within w_employee_popup_pis2020
integer y = 2248
end type

type cb_return from w_inherite_popup`cb_return within w_employee_popup_pis2020
integer y = 2248
end type

type cb_inq from w_inherite_popup`cb_inq within w_employee_popup_pis2020
integer y = 2248
end type

type sle_1 from w_inherite_popup`sle_1 within w_employee_popup_pis2020
end type

type st_1 from w_inherite_popup`st_1 within w_employee_popup_pis2020
end type

type st_2 from statictext within w_employee_popup_pis2020
integer x = 27
integer y = 56
integer width = 169
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
string text = "ã��"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_find from singlelineedit within w_employee_popup_pis2020
integer x = 192
integer y = 36
integer width = 338
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event getfocus;
IF rb_1.Checked = True THEN
	f_toggle_eng(handle(this))
ELSE
	f_toggle_kor(handle(this))
END IF
end event

event modified;string ls_findcol
long ll_findrow

dw_1.SetRedraw(False)
if rb_1.checked = True then
	ls_findcol = "#1"
else
	ls_findcol = "#2"
end if

IF sle_find.Text = "" OR IsNull(sle_find.text) THEN
	dw_1.Retrieve(gs_company,'%','%',sSerVice,sDate_title)
ELSE
	if rb_1.checked = true then             //����˻�
		dw_1.retrieve(gs_company,'%'+trim(sle_find.text)+'%','%',sSerVice,sDate_title)
	else                                    //����˻�
		dw_1.retrieve(gs_company,'%','%'+trim(sle_find.text)+'%',sSerVice,sDate_title)
	end if
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

type rb_3 from radiobutton within w_employee_popup_pis2020
integer x = 608
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "����"
boolean checked = true
end type

event clicked;sSerVice = '1'
sDate_title = '�Ի�����'

wf_retrieve()
end event

type rb_4 from radiobutton within w_employee_popup_pis2020
integer x = 855
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "����"
end type

event clicked;sSerVice = '2'
sDate_title = '��������'

wf_retrieve()
end event

type rb_5 from radiobutton within w_employee_popup_pis2020
integer x = 1111
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "����"
end type

event clicked;sSerVice = '3'
sDate_title = '�������'

wf_retrieve()
end event

type rb_6 from radiobutton within w_employee_popup_pis2020
integer x = 1344
integer y = 44
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "��ü"
end type

event clicked;sSerVice = '%'
sDate_title = '����'

wf_retrieve()
end event

type rb_1 from radiobutton within w_employee_popup_pis2020
integer x = 1701
integer y = 44
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "�ڵ�"
end type

type rb_2 from radiobutton within w_employee_popup_pis2020
integer x = 1943
integer y = 44
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "����"
boolean checked = true
end type

type gb_1 from groupbox within w_employee_popup_pis2020
integer x = 1646
integer width = 590
integer height = 132
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
end type

type gb_2 from groupbox within w_employee_popup_pis2020
integer x = 549
integer width = 1079
integer height = 132
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_employee_popup_pis2020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 152
integer width = 2651
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

