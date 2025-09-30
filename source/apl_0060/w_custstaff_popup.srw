$PBExportHeader$w_custstaff_popup.srw
$PBExportComments$**  �� ������ ��ȸ ����
forward
global type w_custstaff_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_custstaff_popup
end type
end forward

global type w_custstaff_popup from w_inherite_popup
integer x = 320
integer y = 172
integer width = 2962
integer height = 1840
string title = "�� ������ ��ȸ ����"
rr_2 rr_2
end type
global w_custstaff_popup w_custstaff_popup

on w_custstaff_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_custstaff_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;string scode, sname

dw_jogun.InsertRow(0)

dw_jogun.SetItem(1,'custcd',gs_code)
dw_jogun.SetItem(1,'custnm',gs_codename)

scode = gs_code
sname = gs_codename

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

IF IsNull(sname) or sname = "" THEN
	sname = "%"
ELSE
	sname = '%' + sname + '%'
END IF	

dw_1.Retrieve(scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_custstaff_popup
integer y = 28
integer width = 1655
string dataobject = "d_custstaff_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_custstaff_popup
integer x = 2743
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_custstaff_popup
integer x = 2395
integer y = 24
end type

event p_inq::clicked;call super::clicked;string scode, sname

IF dw_jogun.AcceptText() = -1 THEN Return

scode = dw_jogun.GetItemString(1, 'custcd')
sname = trim(dw_jogun.GetItemString(1, 'custnm'))

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

IF IsNull(sname) or sname = "" THEN
	sname = "%"
ELSE
	sname = '%' + sname + '%'
END IF	

dw_1.Retrieve(scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_custstaff_popup
integer x = 2569
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long row

row = dw_1.GetSelectedRow(0)

IF row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_1.GetItemString(Row, "custstaff_cust_no")       // ���ڵ�
gs_codename = dw_1.GetItemString(row,"custstaff_staffnm")        // ����������
gs_gubun    = String(dw_1.GetItemNumber(row,"custstaff_seq"))    // ����

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_custstaff_popup
integer x = 32
integer y = 192
integer width = 2894
integer height = 1532
integer taborder = 30
string dataobject = "d_custstaff_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code     = dw_1.GetItemString(Row, "custstaff_cust_no")       // ���ڵ�
gs_codename = dw_1.GetItemString(row,"custstaff_staffnm")        // ����������
gs_gubun    = String(dw_1.GetItemNumber(row,"custstaff_seq"))    // ����

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_custstaff_popup
boolean visible = false
integer x = 677
integer y = 2156
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_custstaff_popup
integer x = 722
integer y = 2168
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_custstaff_popup
integer x = 1353
integer y = 2168
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_custstaff_popup
integer x = 1042
integer y = 2168
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_custstaff_popup
boolean visible = false
integer x = 375
integer y = 2156
integer width = 302
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_custstaff_popup
boolean visible = false
integer x = 46
integer y = 2108
integer width = 315
string text = "�� �ڵ�"
end type

type rr_2 from roundrectangle within w_custstaff_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 188
integer width = 2912
integer height = 1544
integer cornerheight = 40
integer cornerwidth = 55
end type

