$PBExportHeader$w_st22_00020_popup.srw
$PBExportComments$계측기기 조회 선택
forward
global type w_st22_00020_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_st22_00020_popup
end type
end forward

global type w_st22_00020_popup from w_inherite_popup
integer width = 3502
integer height = 2056
string title = "계측기기 조회 선택"
rr_1 rr_1
end type
global w_st22_00020_popup w_st22_00020_popup

on w_st22_00020_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_st22_00020_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.insertrow(0)
dw_jogun.setfocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_st22_00020_popup
integer y = 20
integer width = 2825
integer height = 176
integer taborder = 20
string dataobject = "d_st22_00020_popup_1"
end type

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose Case this.GetColumnName()
	Case	'grgrco' 		
		open(w_st22_00010_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'grgrco',gs_code)
//		this.triggerevent(itemchanged!)
		this.Trigger Event itemchanged(row,dwo,gs_code)
End Choose
end event

event dw_jogun::itemchanged;call super::itemchanged;String	ls_code,ls_name,ls_null

SetNull(ls_null)

If this.AcceptText() = -1 Then Return 1

If this.GetColumnName() = 'grgrco' Then
	ls_code = this.gettext()
	
	if isnull(ls_code) or ls_code = '' then
		This.SetItem(1,'grname', ls_null)
		return
	End IF
	
	select grname
	  into :ls_name
	  from lw_mesgrp
	 where sabu = :gs_sabu and grgrco = :ls_code ;
	 
	if sqlca.sqlcode = 0 then		
		This.SetItem(1, 'grname', ls_name)
	else
//		This.SetItem(1, 'grgrco', ls_null)
		This.SetItem(1,'grname', ls_null)
//		return 1
	end if
End If
end event

type p_exit from w_inherite_popup`p_exit within w_st22_00020_popup
integer x = 3296
integer taborder = 50
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_st22_00020_popup
integer x = 2949
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string	scode, sname, sgrgrco

dw_jogun.accepttext()

scode = Trim(dw_jogun.Object.code[1])
sname = Trim(dw_jogun.Object.name[1])
sgrgrco = Trim(dw_jogun.Object.grgrco[1])

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

If sgrgrco = '' Or isNull(sgrgrco) Then 
	sgrgrco = '%'
else
	sgrgrco = sgrgrco + '%'
end if

dw_1.SetRedraw(False)
if dw_1.Retrieve(gs_sabu,scode,sname,sgrgrco) < 1 then
	f_message_chk(50,'계측기기')
	dw_jogun.Setcolumn('code')
	dw_jogun.SetFocus()
	return 
end if
	
dw_1.SetRedraw(True)
end event

type p_choose from w_inherite_popup`p_choose within w_st22_00020_popup
integer x = 3122
integer taborder = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = dw_1.GetItemString(ll_Row, "mchno")
gs_codename = dw_1.GetItemString(ll_Row, "mchnam")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_st22_00020_popup
integer x = 46
integer y = 232
integer width = 3406
integer height = 1704
integer taborder = 10
string dataobject = "d_st22_00020_popup_2"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = dw_1.GetItemString(Row, "mchno")

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

type sle_2 from w_inherite_popup`sle_2 within w_st22_00020_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_st22_00020_popup
end type

type cb_return from w_inherite_popup`cb_return within w_st22_00020_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_st22_00020_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_st22_00020_popup
end type

type st_1 from w_inherite_popup`st_1 within w_st22_00020_popup
end type

type rr_1 from roundrectangle within w_st22_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 224
integer width = 3438
integer height = 1724
integer cornerheight = 40
integer cornerwidth = 55
end type

