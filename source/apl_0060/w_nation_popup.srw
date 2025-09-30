$PBExportHeader$w_nation_popup.srw
$PBExportComments$** 지역(국가) 조회 선택
forward
global type w_nation_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_nation_popup
end type
end forward

global type w_nation_popup from w_inherite_popup
integer x = 1454
integer y = 236
integer width = 1755
integer height = 1800
string title = "지역(국가) 조회 선택"
rr_1 rr_1
end type
global w_nation_popup w_nation_popup

on w_nation_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_nation_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String scode,sname

dw_jogun.InsertRow(0)

IF IsNull(gs_code) THEN gs_code =""
IF IsNull(gs_codename) THEN gs_codename =""

dw_jogun.SetItem(1, 'code', gs_code)
dw_jogun.SetItem(1, 'name', gs_codename)

scode = gs_code +'%'
sname = '%' + gs_codename + '%'

dw_1.Retrieve(scode,sname)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_nation_popup
integer x = 23
integer y = 160
integer width = 1701
integer height = 152
string dataobject = "d_nation_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_nation_popup
integer x = 1545
integer y = 8
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_nation_popup
integer x = 1198
integer y = 8
end type

event p_inq::clicked;call super::clicked;String scode,sname

IF dw_jogun.AcceptText() = -1 THEN Return

scode = Trim(dw_jogun.GetItemString(1, 'code'))
sname = Trim(dw_jogun.GetItemString(1, 'name'))

IF IsNull(scode) THEN scode = ''
IF IsNull(sname) THEN sname = ''

scode = scode + '%'
sname = '%' + sname + '%'

IF dw_1.Retrieve(scode,sname) <=0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_nation_popup
integer x = 1371
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "area_areacd")
gs_codename = dw_1.GetItemString(ll_Row, "area_areanm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_nation_popup
integer x = 50
integer y = 324
integer width = 1659
integer height = 1364
integer taborder = 30
string dataobject = "d_nation_popup"
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

gs_code = dw_1.GetItemString(Row, "area_areacd")
gs_codename = dw_1.GetItemString(Row, "area_areanm")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_nation_popup
boolean visible = false
integer x = 576
integer y = 2052
integer width = 562
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_nation_popup
integer x = 201
integer y = 1892
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_nation_popup
integer x = 814
integer y = 1892
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_nation_popup
integer x = 507
integer y = 1892
integer taborder = 50
end type

type sle_1 from w_inherite_popup`sle_1 within w_nation_popup
boolean visible = false
integer x = 370
integer y = 2052
integer width = 201
boolean enabled = false
integer limit = 4
end type

type st_1 from w_inherite_popup`st_1 within w_nation_popup
boolean visible = false
integer x = 169
integer y = 2068
integer width = 215
string text = "코드"
end type

type rr_1 from roundrectangle within w_nation_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 320
integer width = 1678
integer height = 1380
integer cornerheight = 40
integer cornerwidth = 55
end type

