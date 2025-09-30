$PBExportHeader$w_claimno_popup.srw
$PBExportComments$**크레임번호 선택
forward
global type w_claimno_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_claimno_popup
end type
type pb_2 from u_pb_cal within w_claimno_popup
end type
type rr_1 from roundrectangle within w_claimno_popup
end type
end forward

global type w_claimno_popup from w_inherite_popup
integer x = 1120
integer y = 276
integer width = 2167
integer height = 1896
string title = "VOC 번호 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_claimno_popup w_claimno_popup

on w_claimno_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_claimno_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.ReSet()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'sdate', left(f_today(), 6) + '01')
dw_jogun.setitem(1, 'edate', f_today())

dw_jogun.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_claimno_popup
integer x = 14
integer y = 172
integer width = 2153
integer height = 144
string dataobject = "d_claimno_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String s_cod

if this.GetColumnName() = "sdate" then
	s_cod = this.gettext()
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[시작일자]")
	   this.object.sdate[1] = ""
	   return 1
	end if	
elseif this.GetColumnName() = "edate" then
	s_cod = this.gettext()
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

type p_exit from w_inherite_popup`p_exit within w_claimno_popup
integer x = 1970
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_claimno_popup
integer x = 1623
end type

event p_inq::clicked;call super::clicked;string sdate, edate, clsts

if dw_jogun.accepttext() = -1 then return 

clsts = trim(dw_jogun.object.clsts[1])
sdate = trim(dw_jogun.object.sdate[1])
edate = trim(dw_jogun.object.edate[1])

if IsNull(sdate) or sdate = "" THEN sdate = "10000101"
if IsNull(edate) or edate = "" THEN edate = "99991231"

dw_1.Retrieve(gs_sabu, clsts, sdate, edate)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_claimno_popup
integer x = 1797
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "cl_jpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_claimno_popup
integer x = 27
integer y = 332
integer width = 2107
integer height = 1444
integer taborder = 70
string dataobject = "d_claimno_popup2"
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

gs_code= dw_1.GetItemString(Row, "cl_jpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_claimno_popup
boolean visible = false
integer x = 658
integer width = 1138
integer taborder = 40
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_claimno_popup
integer x = 169
integer y = 1912
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_claimno_popup
integer x = 800
integer y = 1912
integer taborder = 60
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_claimno_popup
integer x = 489
integer y = 1912
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_claimno_popup
boolean visible = false
integer x = 357
integer width = 302
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_claimno_popup
integer x = 233
integer y = 1912
integer width = 315
boolean enabled = true
string text = "A/S 센타"
end type

type pb_1 from u_pb_cal within w_claimno_popup
integer x = 1353
integer y = 200
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_claimno_popup
integer x = 1797
integer y = 200
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_claimno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 328
integer width = 2126
integer height = 1456
integer cornerheight = 40
integer cornerwidth = 55
end type

