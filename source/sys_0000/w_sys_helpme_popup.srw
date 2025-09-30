$PBExportHeader$w_sys_helpme_popup.srw
$PBExportComments$A/S요청접수조회
forward
global type w_sys_helpme_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_sys_helpme_popup
end type
type p_retrieve from picture within w_sys_helpme_popup
end type
type rr_1 from roundrectangle within w_sys_helpme_popup
end type
type rr_2 from roundrectangle within w_sys_helpme_popup
end type
end forward

global type w_sys_helpme_popup from w_inherite_popup
integer width = 3232
integer height = 1776
string title = "부서 조회 선택"
dw_2 dw_2
p_retrieve p_retrieve
rr_1 rr_1
rr_2 rr_2
end type
global w_sys_helpme_popup w_sys_helpme_popup

type variables
String is_today, isAdmin


end variables

on w_sys_helpme_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.p_retrieve=create p_retrieve
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.p_retrieve
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_sys_helpme_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.p_retrieve)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)

is_today = f_today()

dw_2.SetItem(1,'fdate',Left(is_today,6)+'01')
dw_2.SetItem(1,'tdate',is_today)

SELECT NVL(DATANAME,'N') INTO :isAdmin
	FROM SYSCNFG
	WHERE SYSGU = 'C' AND SERIAL = 99 AND LINENO <> '00' 
	AND DATANAME = :gs_userid;
	
If SQLCA.SQLCODE <> 0 Then 
	dw_2.SetItem(1,'userid', gs_userid)
End IF

If dw_1.Retrieve(Left(is_today,6)+'01', is_today, gs_userid) >= 1 Then
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
End If

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sys_helpme_popup
integer x = 654
integer y = 1788
integer width = 55
integer height = 36
end type

type p_exit from w_inherite_popup`p_exit within w_sys_helpme_popup
integer x = 2976
integer y = 32
end type

event clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sys_helpme_popup
integer x = 2610
integer y = 32
end type

event p_inq::clicked;call super::clicked;String sfdate, stdate, suserid

If dw_2.AcceptText() <> 1 Then return

sfdate = dw_2.GetItemString(1, 'fdate')
stdate = dw_2.GetItemString(1, 'tdate')
suserid = Trim(dw_2.GetItemString(1, 'userid'))

If isNull(sfdate) Or sfdate = '' Or f_datechk(sfdate) <> 1 Then
	messagebox('확인','의뢰일자가 입력되지 않았거나 잘못되었습니다!')
	dw_2.SetColumn('fdate')
	dW_2.SetFocus()
	Return
End If
If isNull(stdate) Or stdate = '' Or f_datechk(stdate) <> 1 Then
	messagebox('확인','의뢰일자가 입력되지 않았거나 잘못되었습니다!')
	dw_2.SetColumn('tdate')
	dW_2.SetFocus()
	Return
End If

If isNull(suserid) Or suserid = '' Then
	suserid = '%'
End If

If dw_1.Retrieve(sfdate, stdate, suserid) <= 0 Then
	messagebox('확인','등록된 자료가 없습니다!')
End If
end event

type p_choose from w_inherite_popup`p_choose within w_sys_helpme_popup
integer x = 2793
integer y = 32
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "call_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sys_helpme_popup
integer x = 37
integer y = 216
integer width = 3159
integer height = 1432
integer taborder = 10
string dataobject = "d_sys_helpme_popup"
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
   Return
END IF

gs_code = dw_1.GetItemString(Row, "call_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sys_helpme_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_sys_helpme_popup
boolean visible = false
integer x = 325
integer y = 1808
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sys_helpme_popup
boolean visible = false
integer x = 974
integer y = 1820
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sys_helpme_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sys_helpme_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_sys_helpme_popup
boolean visible = false
end type

type dw_2 from datawindow within w_sys_helpme_popup
integer x = 105
integer y = 56
integer width = 2235
integer height = 124
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sys_helpme_popup_con"
boolean border = false
boolean livescroll = true
end type

type p_retrieve from picture within w_sys_helpme_popup
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 3598
integer y = 32
integer width = 178
integer height = 144
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_helpme_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 204
integer width = 3182
integer height = 1448
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_helpme_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 3182
integer height = 168
integer cornerheight = 10
integer cornerwidth = 55
end type

