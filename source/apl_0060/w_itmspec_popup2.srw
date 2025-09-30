$PBExportHeader$w_itmspec_popup2.srw
$PBExportComments$**작업사양 조회 선택(2017.06.18-한텍)
forward
global type w_itmspec_popup2 from w_inherite_popup
end type
type dw_2 from datawindow within w_itmspec_popup2
end type
type st_2 from statictext within w_itmspec_popup2
end type
type st_3 from statictext within w_itmspec_popup2
end type
type rr_1 from roundrectangle within w_itmspec_popup2
end type
type rr_2 from roundrectangle within w_itmspec_popup2
end type
end forward

global type w_itmspec_popup2 from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 3803
integer height = 1536
string title = "공장별 대체품번 조회 선택"
dw_2 dw_2
st_2 st_2
st_3 st_3
rr_1 rr_1
rr_2 rr_2
end type
global w_itmspec_popup2 w_itmspec_popup2

on w_itmspec_popup2.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_itmspec_popup2.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.setitem(1, 'itnbr' , gs_code)	

dw_2.SetTransObject(SQLCA)

dw_1.Retrieve(gs_code)
dw_2.Retrieve(gs_code)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmspec_popup2
integer x = 14
integer y = 12
integer width = 1911
integer height = 152
string dataobject = "d_itmspec_popup2_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_code, s_name

setnull(snull)

Choose Case GetColumnName() 
	Case 'itnbr'
		s_code = this.gettext()
	 
		IF s_code = "" OR IsNull(s_code) THEN 
			RETURN
		END IF

		dw_1.Retrieve(s_code)
		dw_2.Retrieve(s_code)

		SELECT ITDSC INTO :s_name FROM ITEMAS WHERE ITNBR = :s_code ;

		IF SQLCA.SQLCODE <> 0 THEN
			this.SetItem(1, 'itnbr', snull)
			this.SetItem(1, 'itdsc', snull)
			Return 1
		END IF

		this.SetItem(1, 'itdsc', s_name)

END Choose
end event

event dw_jogun::rbuttondown;call super::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

If this.GetColumnName() = "itnbr" then
	gs_gubun = '1' 
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	this.SetItem(1, 'itnbr', gs_code)
	this.SetItem(1, 'itdsc', gs_codename)

END IF
	



end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_itmspec_popup2
integer x = 3520
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmspec_popup2
boolean visible = false
integer x = 645
integer y = 2316
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itmspec_popup2
integer x = 3346
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long ll_row, ll_row2

ll_Row = dw_1.GetSelectedRow(0)
ll_Row2 = dw_2.GetSelectedRow(0)

IF ll_Row <= 0 Or ll_Row2 <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "bunbr")
gs_codename = dw_2.GetItemString(ll_Row2, "bunbr")

IF gs_code = gs_codename THEN
	messagebox('확인','대체품번으로 같은 품번을 선택할 수 없습니다!')
	return
END IF

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmspec_popup2
integer x = 32
integer y = 264
integer width = 1792
integer height = 1156
integer taborder = 20
string dataobject = "d_itmspec_popup2_21"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code = dw_1.GetItemString(Row, "sayang")
//Close(Parent)
//
end event

type sle_2 from w_inherite_popup`sle_2 within w_itmspec_popup2
boolean visible = false
integer x = 215
integer y = 2220
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmspec_popup2
integer x = 1381
integer y = 2288
end type

type cb_return from w_inherite_popup`cb_return within w_itmspec_popup2
integer x = 1701
integer y = 2288
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmspec_popup2
integer x = 887
integer y = 2308
integer height = 92
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmspec_popup2
boolean visible = false
integer y = 2268
end type

type st_1 from w_inherite_popup`st_1 within w_itmspec_popup2
boolean visible = false
integer y = 2280
end type

type dw_2 from datawindow within w_itmspec_popup2
integer x = 1934
integer y = 264
integer width = 1792
integer height = 1156
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_itmspec_popup2_21"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF

end event

type st_2 from statictext within w_itmspec_popup2
integer x = 27
integer y = 192
integer width = 535
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "<< 품목대체 전 >>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_itmspec_popup2
integer x = 1929
integer y = 196
integer width = 535
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "<< 품목대체 후 >>"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_itmspec_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 260
integer width = 1833
integer height = 1168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_itmspec_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1915
integer y = 260
integer width = 1833
integer height = 1168
integer cornerheight = 40
integer cornerwidth = 55
end type

