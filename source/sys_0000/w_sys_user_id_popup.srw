$PBExportHeader$w_sys_user_id_popup.srw
$PBExportComments$ USER ID 출력 PopUp
forward
global type w_sys_user_id_popup from w_inherite_popup
end type
type sle_name from singlelineedit within w_sys_user_id_popup
end type
type st_2 from statictext within w_sys_user_id_popup
end type
type rr_1 from roundrectangle within w_sys_user_id_popup
end type
end forward

global type w_sys_user_id_popup from w_inherite_popup
integer x = 960
integer y = 236
integer width = 1582
integer height = 1768
string title = "USER_ID 조회 선택"
sle_name sle_name
st_2 st_2
rr_1 rr_1
end type
global w_sys_user_id_popup w_sys_user_id_popup

type variables
String is_empname='%'
end variables

on w_sys_user_id_popup.create
int iCurrent
call super::create
this.sle_name=create sle_name
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_name
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sys_user_id_popup.destroy
call super::destroy
destroy(this.sle_name)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.Retrieve(is_empname)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sys_user_id_popup
boolean visible = false
integer x = 192
integer y = 1744
integer width = 265
integer height = 72
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_sys_user_id_popup
integer x = 1353
integer y = 8
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sys_user_id_popup
boolean visible = false
integer x = 672
integer y = 1680
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_sys_user_id_popup
integer x = 1179
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "login_t_l_userid")
gs_codename = dw_1.GetItemString(ll_Row, "l_password")
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sys_user_id_popup
integer x = 37
integer y = 180
integer width = 1495
integer height = 1456
integer taborder = 10
string dataobject = "d_sys_user_id_popup"
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

gs_code = dw_1.GetItemString(Row, "login_t_l_userid")
gs_codename = dw_1.GetItemString(Row, "l_password")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sys_user_id_popup
boolean visible = false
integer x = 2007
integer y = 1388
integer width = 370
end type

type cb_1 from w_inherite_popup`cb_1 within w_sys_user_id_popup
boolean visible = false
integer x = 887
integer y = 1680
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sys_user_id_popup
boolean visible = false
integer x = 1202
integer y = 1680
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sys_user_id_popup
boolean visible = false
integer x = 658
integer y = 1736
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sys_user_id_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_sys_user_id_popup
boolean visible = false
end type

type sle_name from singlelineedit within w_sys_user_id_popup
integer x = 343
integer y = 56
integer width = 443
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;is_empname = Trim(this.Text)

If isNull(is_empname) Or is_empname = '' Then
	is_empname = '%'
Else
	is_empname = is_empname + '%'
End If

dw_1.Retrieve(is_empname)
end event

type st_2 from statictext within w_sys_user_id_popup
integer x = 78
integer y = 72
integer width = 251
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사원명"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_user_id_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 168
integer width = 1513
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 55
end type

