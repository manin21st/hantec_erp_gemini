$PBExportHeader$w_mitnct_s_popup.srw
$PBExportComments$** 설비/계측기 소분류코드 조회 선택
forward
global type w_mitnct_s_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_mitnct_s_popup
end type
type rr_1 from roundrectangle within w_mitnct_s_popup
end type
type rr_2 from roundrectangle within w_mitnct_s_popup
end type
end forward

global type w_mitnct_s_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 1586
integer height = 1868
string title = "설비/계측기 소분류 코드 조회 선택(POPUP)"
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
end type
global w_mitnct_s_popup w_mitnct_s_popup

on w_mitnct_s_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_mitnct_s_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)

IF IsNull(gs_gubun) THEN
	gs_gubun ="%"
ELSE   
	dw_2.setitem(1, 'kegbn' , gs_gubun)	
END IF

dw_1.Retrieve(gs_gubun)
dw_2.enabled = false

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mitnct_s_popup
boolean visible = false
integer x = 1806
integer y = 1152
integer width = 393
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_mitnct_s_popup
integer x = 1371
integer y = 4
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mitnct_s_popup
end type

type p_choose from w_inherite_popup`p_choose within w_mitnct_s_popup
integer x = 1198
integer y = 4
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun    = dw_1.GetItemString(ll_Row, "kegbn")

gs_code     = dw_1.GetItemString(ll_Row, "buncd")
gs_codename = dw_1.GetItemString(ll_Row, "bunnam")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mitnct_s_popup
integer x = 50
integer y = 212
integer width = 1486
integer height = 1524
integer taborder = 20
string dataobject = "d_mitnct_s_popup"
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

gs_gubun    = dw_1.GetItemString(Row, "kegbn")
gs_code     = dw_1.GetItemString(Row, "buncd")
gs_codename = dw_1.GetItemString(Row, "bunnam")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mitnct_s_popup
boolean visible = false
integer x = 997
integer y = 1968
integer width = 293
end type

type cb_1 from w_inherite_popup`cb_1 within w_mitnct_s_popup
integer x = 1627
integer y = 1968
integer width = 293
end type

event cb_1::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun    = dw_1.GetItemString(ll_Row, "kegbn")

gs_code     = dw_1.GetItemString(ll_Row, "buncd")
gs_codename = dw_1.GetItemString(ll_Row, "bunnam")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_mitnct_s_popup
integer x = 1943
integer y = 1968
integer taborder = 40
end type

event cb_return::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_mitnct_s_popup
boolean visible = false
integer x = 1312
integer y = 1968
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mitnct_s_popup
boolean visible = false
integer x = 681
integer y = 1968
integer width = 293
integer height = 92
end type

type st_1 from w_inherite_popup`st_1 within w_mitnct_s_popup
boolean visible = false
end type

type dw_2 from datawindow within w_mitnct_s_popup
integer x = 59
integer y = 48
integer width = 1074
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mitemas_ittyp"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, s_name, s_cdchk

setnull(snull)

IF this.GetColumnName() = 'kegbn' THEN
	s_name = this.gettext()

	dw_1.Retrieve(s_name)
		
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
END IF
end event

event itemerror;RETURN 1
end event

type rr_1 from roundrectangle within w_mitnct_s_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 24
integer width = 1134
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mitnct_s_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 156
integer width = 1504
integer height = 1588
integer cornerheight = 40
integer cornerwidth = 55
end type

