$PBExportHeader$w_cust_popup.srw
$PBExportComments$** 고객 조회 선택
forward
global type w_cust_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_cust_popup
end type
end forward

global type w_cust_popup from w_inherite_popup
integer x = 1120
integer y = 276
integer width = 2313
integer height = 2072
string title = "고객 조회 선택"
rr_2 rr_2
end type
global w_cust_popup w_cust_popup

on w_cust_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_cust_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;string scode, sname

dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'custcd', gs_code)
dw_jogun.SetItem(1, 'custnm', gs_codename)

sle_1.text = gs_code
sle_2.text = gs_codename

scode = gs_code
sname = gs_codename

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

IF IsNull(sname) or sname = "" THEN
	sname = "%"
ELSE
	sname = '%' + sname + '%'
END IF	

dw_1.Retrieve(scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
sle_2.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_cust_popup
integer x = 0
integer y = 36
integer width = 1746
integer height = 128
string dataobject = "d_cust_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_cust_popup
integer x = 2094
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_cust_popup
integer x = 1746
end type

event p_inq::clicked;call super::clicked;string scode, sname

scode = trim(dw_jogun.GetItemString(1, 'custcd'))
sname = trim(dw_jogun.GetItemString(1, 'custnm'))

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

IF IsNull(sname) or sname = "" THEN
	sname = "%"
ELSE
	sname = '%' + sname + '%'
END IF	

dw_1.Retrieve(scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_cust_popup
integer x = 1920
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "cust_no")
gs_codename= dw_1.GetItemString(ll_row,"cust_name")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_cust_popup
integer y = 184
integer height = 1760
integer taborder = 30
string dataobject = "d_cust_popup"
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

gs_code= dw_1.GetItemString(Row, "cust_no")
gs_codename= dw_1.GetItemString(row,"cust_name")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_cust_popup
integer x = 731
integer y = 2164
integer width = 1138
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_cust_popup
boolean visible = false
integer x = 654
integer y = 2264
integer taborder = 40
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_cust_popup
boolean visible = false
integer x = 1275
integer y = 2264
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_cust_popup
boolean visible = false
integer x = 965
integer y = 2264
integer taborder = 50
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_cust_popup
integer x = 430
integer y = 2156
integer width = 302
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_cust_popup
integer x = 146
integer y = 2212
integer width = 315
integer height = 100
string text = "고객 코드"
end type

type rr_2 from roundrectangle within w_cust_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 180
integer width = 2263
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

