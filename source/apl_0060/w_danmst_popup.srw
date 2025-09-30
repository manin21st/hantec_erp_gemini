$PBExportHeader$w_danmst_popup.srw
$PBExportComments$단가마스터 내역 조회
forward
global type w_danmst_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_danmst_popup
end type
end forward

global type w_danmst_popup from w_inherite_popup
integer x = 539
integer y = 664
integer width = 2528
integer height = 1152
string title = "거래처 단가 조회 선택"
rr_1 rr_1
end type
global w_danmst_popup w_danmst_popup

on w_danmst_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_danmst_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;
if dw_1.Retrieve(gs_code, gs_codename) = 0 then
	f_message_chk(50,'[거래처별 단가내역 조회]') 
	setnull(gs_code)
	setnull(gs_codename)
	close(this)
	return
end if

dw_jogun.settransobject(sqlca)
dw_jogun.retrieve(gs_code)

setnull(gs_code)
setnull(gs_codename)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_danmst_popup
integer x = 14
integer y = 24
integer width = 2075
integer height = 140
string dataobject = "d_danmst_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_danmst_popup
integer x = 2313
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_danmst_popup
boolean visible = false
integer x = 983
integer y = 1252
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_danmst_popup
integer x = 2139
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "danmst_cvcod")
gs_codename = String(dw_1.GetItemdecimal(ll_Row, "danmst_unprc"))
gs_codename2 = dw_1.GetItemstring(ll_Row, "vndmst_cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_danmst_popup
integer x = 27
integer y = 184
integer width = 2450
integer height = 848
integer taborder = 10
string dataobject = "d_danmst_popup"
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

gs_code = dw_1.GetItemString(Row, "danmst_cvcod")
gs_codename = String(dw_1.GetItemDecimal(Row, "danmst_unprc"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_danmst_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_danmst_popup
boolean visible = false
integer x = 1819
integer y = 1272
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_danmst_popup
boolean visible = false
integer x = 2139
integer y = 1272
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_danmst_popup
boolean visible = false
integer x = 1074
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_danmst_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_danmst_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_danmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 180
integer width = 2469
integer height = 860
integer cornerheight = 40
integer cornerwidth = 55
end type

