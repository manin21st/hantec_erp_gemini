$PBExportHeader$w_asrslno_popup.srw
$PBExportComments$** A/Só����ȣ ����
forward
global type w_asrslno_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_asrslno_popup
end type
end forward

global type w_asrslno_popup from w_inherite_popup
integer x = 1120
integer y = 276
integer width = 2002
integer height = 1968
string title = "���� ó����ȣ ����"
rr_1 rr_1
end type
global w_asrslno_popup w_asrslno_popup

on w_asrslno_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_asrslno_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.ReSet()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'sdate', left(f_today(), 6) + '01')
dw_jogun.setitem(1, 'edate', f_today())
dw_jogun.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_asrslno_popup
integer x = 9
integer y = 176
integer width = 1961
integer height = 212
string dataobject = "d_asrslno_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn 

if this.GetColumnName() = "sdate" then
	s_cod = this.gettext()
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[��������]")
	   this.object.sdate[1] = ""
	   return 1
	end if	
elseif this.GetColumnName() = "edate" then
	s_cod = this.gettext()
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[������]")
	   this.object.edate[1] = ""
	   return 1
	end if	
end if

end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_asrslno_popup
integer x = 1774
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_asrslno_popup
integer x = 1426
integer y = 16
end type

event p_inq::clicked;call super::clicked;string sdate, edate, cod, jpno

if dw_jogun.accepttext() = -1 then return 

sdate = trim(dw_jogun.object.sdate[1])
edate = trim(dw_jogun.object.edate[1])
cod   = trim(dw_jogun.object.cod[1])
jpno  = trim(dw_jogun.object.jpno[1])

if IsNull(sdate) or sdate = "" THEN sdate = "10000101"
if IsNull(edate) or edate = "" THEN edate = "99991231"
if IsNull(cod) or cod = "" THEN 
	cod = "%"
else
	cod = cod + "%"
end if
if IsNull(jpno) or jpno = "" THEN 
	jpno = "%"
else
	jpno = jpno + "%"
end if

dw_1.Retrieve(gs_sabu, sdate, edate, cod, jpno)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_asrslno_popup
integer x = 1600
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "rsl_jpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_asrslno_popup
integer x = 27
integer y = 408
integer width = 1925
integer height = 1452
integer taborder = 40
string dataobject = "d_asrslno_popup2"
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

gs_code= dw_1.GetItemString(Row, "rsl_jpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_asrslno_popup
boolean visible = false
integer x = 658
integer width = 1138
integer taborder = 60
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_asrslno_popup
integer x = 215
integer y = 1948
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_asrslno_popup
integer x = 837
integer y = 1948
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_asrslno_popup
integer x = 526
integer y = 1948
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_asrslno_popup
boolean visible = false
integer x = 357
integer width = 302
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_asrslno_popup
boolean visible = false
integer x = 151
integer y = 1948
integer width = 315
string text = "A/S ��Ÿ"
end type

type rr_1 from roundrectangle within w_asrslno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 396
integer width = 1943
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 55
end type

