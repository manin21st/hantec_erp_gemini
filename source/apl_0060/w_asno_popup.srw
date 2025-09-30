$PBExportHeader$w_asno_popup.srw
$PBExportComments$** A/S의뢰번호 선택
forward
global type w_asno_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_asno_popup
end type
end forward

global type w_asno_popup from w_inherite_popup
integer x = 96
integer y = 12
integer width = 2615
integer height = 1856
string title = "샘플 의뢰번호 선택"
rr_1 rr_1
end type
global w_asno_popup w_asno_popup

on w_asno_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_asno_popup.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_asno_popup
integer x = 37
integer y = 68
integer width = 1083
integer height = 140
string dataobject = "d_asno_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String s_cod

if this.GetColumnName() = "sdate" then
	s_cod = gettext()
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[시작일자]")
	   this.object.sdate[1] = ""
	   return 1
	end if	
elseif this.GetColumnName() = "edate" then
	s_cod = gettext()
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[끝일자]")
	   this.object.edate[1] = ""
	   return 1
	end if	
end if
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_asno_popup
integer x = 2414
integer y = 52
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_asno_popup
integer x = 2066
integer y = 52
end type

event p_inq::clicked;call super::clicked;string sdate, edate, s_cod

IF dw_jogun.accepttext() = -1 then return 

s_cod = trim(dw_jogun.object.cod[1])
sdate = trim(dw_jogun.object.sdate[1])
edate = trim(dw_jogun.object.edate[1])

IF IsNull(s_cod) or s_cod = "" THEN 
	s_cod = "%"
ELSE
	s_cod = s_cod + '%'
END IF	

if IsNull(sdate) or sdate = "" THEN sdate = "10000101"
if IsNull(edate) or edate = "" THEN edate = "99991231"

dw_1.Retrieve(gs_sabu, s_cod, sdate, edate)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_asno_popup
integer x = 2240
integer y = 52
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "as_jpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_asno_popup
integer x = 46
integer y = 236
integer width = 2533
integer height = 1524
integer taborder = 70
string dataobject = "d_asno_popup2"
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
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "as_jpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_asno_popup
boolean visible = false
integer x = 658
integer width = 1138
integer taborder = 40
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_asno_popup
integer x = 0
integer y = 1888
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_asno_popup
integer x = 622
integer y = 1888
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_asno_popup
integer x = 311
integer y = 1888
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_asno_popup
boolean visible = false
integer x = 357
integer width = 302
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_asno_popup
integer x = 197
integer y = 1888
integer width = 315
boolean enabled = true
string text = "A/S 센타"
end type

type rr_1 from roundrectangle within w_asno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 232
integer width = 2551
integer height = 1532
integer cornerheight = 40
integer cornerwidth = 55
end type

