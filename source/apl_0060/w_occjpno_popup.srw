$PBExportHeader$w_occjpno_popup.srw
$PBExportComments$** 이상발생문서번호- 선택
forward
global type w_occjpno_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_occjpno_popup
end type
type dw_ip from u_key_enter within w_occjpno_popup
end type
end forward

global type w_occjpno_popup from w_inherite_popup
integer x = 1120
integer y = 276
integer width = 2574
integer height = 2156
string title = "이상발생 번호 선택"
rr_1 rr_1
dw_ip dw_ip
end type
global w_occjpno_popup w_occjpno_popup

on w_occjpno_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_ip
end on

on w_occjpno_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_ip)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_ip.InsertRow(0)

dw_ip.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_occjpno_popup
boolean visible = false
integer x = 59
integer y = 1280
integer width = 151
integer taborder = 60
end type

type p_exit from w_inherite_popup`p_exit within w_occjpno_popup
integer x = 2373
integer y = 8
integer taborder = 50
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_occjpno_popup
integer x = 2025
integer y = 8
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;string sdate, edate, gubun

dw_ip.accepttext()
sdate = dw_ip.object.sdate[1]
edate = dw_ip.object.edate[1]
gubun = dw_ip.object.gubun[1]

if IsNull(sdate) or sdate = "" THEN sdate = "11111111"
if IsNull(edate) or edate = "" THEN edate = "99999999"

if dw_1.Retrieve(gs_sabu, sdate, edate, gubun) < 1 then return
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_occjpno_popup
integer x = 2199
integer y = 8
integer taborder = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "occjpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_occjpno_popup
integer x = 50
integer y = 168
integer width = 2482
integer height = 1880
integer taborder = 30
string dataobject = "d_occjpno_popup2"
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

gs_code= dw_1.GetItemString(Row, "occjpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_occjpno_popup
boolean visible = false
integer x = 658
integer width = 1138
integer taborder = 80
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_occjpno_popup
integer x = 1367
integer y = 1676
end type

type cb_return from w_inherite_popup`cb_return within w_occjpno_popup
integer x = 1998
integer y = 1676
end type

type cb_inq from w_inherite_popup`cb_inq within w_occjpno_popup
integer x = 1687
integer y = 1676
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_occjpno_popup
boolean visible = false
integer x = 357
integer width = 302
integer taborder = 70
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_occjpno_popup
boolean visible = false
integer y = 0
integer width = 46
string text = "A/S 센타"
end type

type rr_1 from roundrectangle within w_occjpno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 160
integer width = 2505
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_occjpno_popup
integer x = 23
integer y = 20
integer width = 1943
integer height = 136
integer taborder = 10
string dataobject = "d_occjpno_popup1"
boolean border = false
end type

event itemchanged;String s_cod

if this.GetColumnName() = "sdate" then
	s_cod = Trim(this.object.sdate[1])
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[시작일자]")
	   this.object.sdate[1] = ""
	   return 1
	end if	
elseif this.GetColumnName() = "edate" then
	s_cod = Trim(this.object.edate[1])
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[끝일자]")
	   this.object.edate[1] = ""
	   return 1
	end if	
end if
end event

event itemerror;return 1
end event

