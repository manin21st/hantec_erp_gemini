$PBExportHeader$w_st22_00010_popup.srw
$PBExportComments$계측기기 그룹 조회 선택
forward
global type w_st22_00010_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_st22_00010_popup
end type
end forward

global type w_st22_00010_popup from w_inherite_popup
integer width = 2071
integer height = 2056
string title = "계측기기 그룹 조회 선택"
rr_1 rr_1
end type
global w_st22_00010_popup w_st22_00010_popup

on w_st22_00010_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_st22_00010_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.insertrow(0)
dw_jogun.setfocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_st22_00010_popup
integer y = 20
integer width = 960
integer height = 176
string dataobject = "d_st22_00010_popup_0"
end type

type p_exit from w_inherite_popup`p_exit within w_st22_00010_popup
integer x = 1865
integer y = 24
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_st22_00010_popup
integer x = 1518
integer y = 24
end type

event p_inq::clicked;call super::clicked;string	scode, sname

dw_jogun.accepttext()

//scode = Trim(dw_jogun.Object.grgrco[1])
scode = Trim(dw_jogun.Object.gubun[1])
sname = Trim(dw_jogun.Object.grname[1])

If scode = '' Or isNull(scode) Then 
	scode = '%'
else
	scode = scode + '%'
end if

If sname = '' Or isNull(sname) Then 
	sname = '%'
else
	sname = '%' + sname + '%'
end if

dw_1.SetRedraw(False)
dw_1.Retrieve(gs_sabu,scode,sname)
dw_1.SetRedraw(True)
end event

type p_choose from w_inherite_popup`p_choose within w_st22_00010_popup
integer x = 1691
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = dw_1.GetItemString(ll_Row, "grgrco")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_st22_00010_popup
integer x = 46
integer y = 232
integer width = 1970
integer height = 1704
string dataobject = "d_st22_00010_popup_1"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = dw_1.GetItemString(Row, "grgrco")

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

type sle_2 from w_inherite_popup`sle_2 within w_st22_00010_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_st22_00010_popup
end type

type cb_return from w_inherite_popup`cb_return within w_st22_00010_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_st22_00010_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_st22_00010_popup
end type

type st_1 from w_inherite_popup`st_1 within w_st22_00010_popup
end type

type rr_1 from roundrectangle within w_st22_00010_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 224
integer width = 2002
integer height = 1724
integer cornerheight = 40
integer cornerwidth = 55
end type

