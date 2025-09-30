$PBExportHeader$w_carhead_popup.srw
forward
global type w_carhead_popup from w_inherite_popup
end type
type rb_2 from radiobutton within w_carhead_popup
end type
type rb_3 from radiobutton within w_carhead_popup
end type
type dw_2 from datawindow within w_carhead_popup
end type
type rr_4 from roundrectangle within w_carhead_popup
end type
end forward

global type w_carhead_popup from w_inherite_popup
integer width = 2117
integer height = 2076
string title = "차종정보 조회 POPUP"
rb_2 rb_2
rb_3 rb_3
dw_2 dw_2
rr_4 rr_4
end type
global w_carhead_popup w_carhead_popup

on w_carhead_popup.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_2=create dw_2
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.rr_4
end on

on w_carhead_popup.destroy
call super::destroy
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_2)
destroy(this.rr_4)
end on

event open;dw_2.InsertRow(0)
dw_2.SetItem(1, 'cargbn1', gs_codename)
dw_2.SetItem(1, 'cargbn2', gs_codename2)

dw_1.SetTransObject(sqlca)

cb_inq.PostEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_carhead_popup
boolean visible = false
end type

type p_exit from w_inherite_popup`p_exit within w_carhead_popup
integer x = 1897
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_carhead_popup
boolean visible = false
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_carhead_popup
integer x = 1723
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "carcode")
gs_codename  = dw_1.GetItemString(ll_row,"cargbn1")
gs_codename2 = dw_1.GetItemString(ll_row,"cargbn2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_carhead_popup
integer x = 23
integer y = 248
integer width = 2034
integer height = 1700
string dataobject = "d_carhead_popup_2"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "carcode")
gs_codename= dw_1.GetItemString(row,"cargbn1")
gs_codename2= dw_1.GetItemString(row,"cargbn2")

Close(Parent)

end event

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type sle_2 from w_inherite_popup`sle_2 within w_carhead_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_carhead_popup
end type

type cb_return from w_inherite_popup`cb_return within w_carhead_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_carhead_popup
end type

event cb_inq::clicked;call super::clicked;String sGbn1, sGbn2

If dw_2.AcceptText() <> 1 Then Return

sGbn1	= Trim(dw_2.GetItemString(1,'cargbn1'))
sGbn2	= Trim(dw_2.GetItemString(1,'cargbn2'))

dw_1.Retrieve(sGbn1, sGbn2)

end event

type sle_1 from w_inherite_popup`sle_1 within w_carhead_popup
end type

type st_1 from w_inherite_popup`st_1 within w_carhead_popup
end type

type rb_2 from radiobutton within w_carhead_popup
boolean visible = false
integer x = 1120
integer y = 148
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미션"
end type

event clicked;dw_1.Retrieve('T')

dw_1.Object.t_nm.text = '차종코드'
dw_1.Object.t_nm1.text = '차종명'
end event

type rb_3 from radiobutton within w_carhead_popup
boolean visible = false
integer x = 1403
integer y = 144
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "기타(LG)"
end type

event clicked;dw_1.Retrieve('0')

dw_1.Object.t_nm.text = '기종코드'
dw_1.Object.t_nm1.text = '기종명'
end event

type dw_2 from datawindow within w_carhead_popup
integer x = 14
integer y = 24
integer width = 1591
integer height = 216
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_carhead_popup_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long ix, nrow
String sCarcode, sCargbn1, sCargbn2, sCarnm, sTemp

Choose Case GetColumnName()
	Case 'cargbn1'
		sCargbn1 = Trim(GetText())
		
		// 차종이 아닌경우 '기타'로 설정
		If ( sCargbn1 <> 'E' Or sCargbn1 <> 'C' ) Then
			SetItem(1, 'cargbn2','9')
		Else
			SetItem(1, 'cargbn2','E')
		End If
End Choose

cb_inq.PostEvent(Clicked!)
end event

type rr_4 from roundrectangle within w_carhead_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 244
integer width = 2053
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

