$PBExportHeader$w_suju_popup.srw
$PBExportComments$** 수주조회 선택
forward
global type w_suju_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_suju_popup
end type
type pb_2 from u_pb_cal within w_suju_popup
end type
type rr_1 from roundrectangle within w_suju_popup
end type
end forward

global type w_suju_popup from w_inherite_popup
integer x = 219
integer y = 124
integer width = 3323
string title = "수주 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_suju_popup w_suju_popup

on w_suju_popup.create
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

on w_suju_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_suju_popup
integer x = 27
integer y = 172
integer width = 3264
integer height = 208
string dataobject = "d_suju_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_suju_popup
integer x = 3095
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_suju_popup
integer x = 2747
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sbuyer,sdatef,sdatet, sitnbr, spangbn

if dw_jogun.AcceptText() = -1 then return 

sbuyer = dw_jogun.GetItemString(1,"vndcod")
sitnbr = dw_jogun.GetItemString(1,"itnbr")
sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))
spangbn = trim(dw_jogun.GetItemString(1,"pangbn"))

IF sbuyer ="" OR IsNull(sbuyer) THEN	sbuyer ='%'
IF sitnbr ="" OR IsNull(sitnbr) THEN	sitnbr ='%'
IF sdatef ="" OR IsNull(sdatef) THEN	sdatef ='10000101'
IF sdatet = "" OR IsNull(sdatet) THEN	sdatet ='99991231'
IF spangbn = "" OR IsNull(spangbn) THEN	spangbn ='%'

IF 	dw_1.Retrieve(gs_sabu, gs_saupj,  sbuyer, sitnbr, sdatef, sdatet, spangbn) <= 0 THEN
	dw_jogun.SetColumn("vndcod")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_suju_popup
integer x = 2921
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "order_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_suju_popup
integer x = 37
integer y = 384
integer width = 3232
integer height = 1540
integer taborder = 50
string dataobject = "d_suju_popup1"
boolean hscrollbar = true
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

gs_code= dw_1.GetItemString(Row, "order_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_suju_popup
boolean visible = false
integer x = 942
integer y = 2108
integer width = 1001
integer taborder = 40
end type

type cb_1 from w_inherite_popup`cb_1 within w_suju_popup
integer x = 2190
integer y = 2124
integer taborder = 60
end type

type cb_return from w_inherite_popup`cb_return within w_suju_popup
integer x = 2811
integer y = 2124
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_suju_popup
integer x = 2501
integer y = 2124
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_suju_popup
boolean visible = false
integer y = 2108
integer width = 425
integer taborder = 20
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_suju_popup
boolean visible = false
integer x = 9
integer y = 2128
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_suju_popup
integer x = 658
integer y = 276
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_suju_popup
integer x = 1106
integer y = 276
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_suju_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 380
integer width = 3255
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

