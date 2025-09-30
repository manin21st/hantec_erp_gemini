$PBExportHeader$w_pdt_02030_2.srw
$PBExportComments$작업지시등록(품목별 공정가용내역 조회)
forward
global type w_pdt_02030_2 from w_inherite_popup
end type
type st_itnbr from statictext within w_pdt_02030_2
end type
type st_itdsc from statictext within w_pdt_02030_2
end type
type rr_1 from roundrectangle within w_pdt_02030_2
end type
type rr_2 from roundrectangle within w_pdt_02030_2
end type
end forward

global type w_pdt_02030_2 from w_inherite_popup
integer x = 814
integer y = 664
integer width = 2752
integer height = 1140
string title = "품목별 공정내역 조회"
st_itnbr st_itnbr
st_itdsc st_itdsc
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02030_2 w_pdt_02030_2

on w_pdt_02030_2.create
int iCurrent
call super::create
this.st_itnbr=create st_itnbr
this.st_itdsc=create st_itdsc
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_itnbr
this.Control[iCurrent+2]=this.st_itdsc
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_pdt_02030_2.destroy
call super::destroy
destroy(this.st_itnbr)
destroy(this.st_itdsc)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;f_window_center_response(this)

if dw_1.Retrieve(gs_sabu, gs_code) = 0 then
	f_message_chk(87,'[품목별 공정내역 조회]') 
	setnull(gs_code)
	setnull(gs_codename)
	setnull(gs_gubun)
	close(this)
	return
end if

st_itnbr.text = gs_code
st_itdsc.text = gs_gubun

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_02030_2
integer x = 0
integer y = 1312
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_02030_2
integer x = 2523
integer y = 4
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_02030_2
integer x = 416
integer y = 1196
end type

type p_choose from w_inherite_popup`p_choose within w_pdt_02030_2
integer x = 2350
integer y = 4
boolean originalsize = true
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "pordno")
gs_codename = dw_1.GetItemString(ll_Row, "opseq")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_02030_2
integer x = 37
integer y = 168
integer width = 2656
integer height = 844
integer taborder = 10
string dataobject = "d_pdt_02030_2"
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

gs_code = dw_1.GetItemString(Row, "pordno")
gs_codename = dw_1.GetItemString(Row, "opseq")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_02030_2
boolean visible = false
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_02030_2
boolean visible = false
integer x = 640
integer y = 1300
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_02030_2
boolean visible = false
integer x = 960
integer y = 1300
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_02030_2
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_02030_2
boolean visible = false
integer taborder = 0
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_02030_2
boolean visible = false
end type

type st_itnbr from statictext within w_pdt_02030_2
integer x = 50
integer y = 48
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = " "
boolean focusrectangle = false
end type

type st_itdsc from statictext within w_pdt_02030_2
integer x = 581
integer y = 48
integer width = 1664
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02030_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 28
integer width = 2263
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02030_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 160
integer width = 2683
integer height = 868
integer cornerheight = 40
integer cornerwidth = 55
end type

