$PBExportHeader$w_shpact_popup.srw
$PBExportComments$** 작업실적 조회 선택
forward
global type w_shpact_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_shpact_popup
end type
type pb_2 from u_pb_cal within w_shpact_popup
end type
type rr_1 from roundrectangle within w_shpact_popup
end type
end forward

global type w_shpact_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3387
integer height = 2116
string title = "작업실적 조회 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_shpact_popup w_shpact_popup

on w_shpact_popup.create
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

on w_shpact_popup.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_shpact_popup
integer width = 3337
integer height = 140
string dataobject = "d_shpact_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_shpact_popup
integer x = 3159
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_shpact_popup
integer x = 2811
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sgub

if dw_jogun.AcceptText() = -1 then return 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))
sgub   = dw_jogun.GetItemString(1,"sgub")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sgub ="1" THEN  //전체
	sgub ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet,sgub) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_shpact_popup
integer x = 2985
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "shpjpno")
//gs_codename= string(dw_1.GetItemNumber(ll_Row, "poblkt_balseq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_shpact_popup
integer x = 37
integer y = 316
integer width = 3291
integer height = 1672
string dataobject = "d_shpact_popup1"
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

gs_code= dw_1.GetItemString(Row, "shpjpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_shpact_popup
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_shpact_popup
integer x = 1883
integer y = 2408
end type

type cb_return from w_inherite_popup`cb_return within w_shpact_popup
integer x = 2505
integer y = 2408
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_shpact_popup
integer x = 2194
integer y = 2408
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_shpact_popup
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_shpact_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_shpact_popup
integer x = 686
integer y = 196
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_shpact_popup
integer x = 1134
integer y = 196
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rr_1 from roundrectangle within w_shpact_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 312
integer width = 3314
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

