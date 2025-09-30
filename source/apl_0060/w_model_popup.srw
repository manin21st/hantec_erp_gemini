$PBExportHeader$w_model_popup.srw
$PBExportComments$* 적용 모델 조회 Pop Up
forward
global type w_model_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_model_popup
end type
end forward

global type w_model_popup from w_inherite_popup
integer width = 1865
integer height = 1820
string title = "모델코드 조회"
rr_2 rr_2
end type
global w_model_popup w_model_popup

type variables
string is_itcls
end variables

on w_model_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_model_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)
dw_jogun.SetFocus()

//dw_jogun.setitem(1, 'ittyp', gs_gubun)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_model_popup
integer x = 14
integer y = 32
integer width = 1239
integer height = 152
string dataobject = "d_model_popup_h"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'econo' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
//	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[ECO No]')
		this.SetItem(1,'econo', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_model_popup
integer x = 1664
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_model_popup
integer x = 1317
integer y = 16
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_rfna1

if dw_jogun.AcceptText() = -1 then return 

ls_rfna1 = dw_jogun.GetItemString(1,'rfna1')

if IsNull(ls_rfna1 ) or ls_rfna1 = "" Then
	ls_rfna1 = '%'
Else
	ls_rfna1 = '%' + ls_rfna1 + '%'
End If

If dw_1.Retrieve(ls_rfna1) = 0 Then
	f_message_chk(50, ' 차종코드 ')
	return
End If
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_model_popup
integer x = 1490
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "rfgub")
gs_codename = dw_1.GetItemString(ll_row,"reffpf_rfna1")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_model_popup
integer x = 32
integer y = 248
integer width = 1783
integer height = 1452
integer taborder = 100
string dataobject = "d_model_popup_d"
boolean hscrollbar = true
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

gs_code = dw_1.GetItemString(Row, "rfgub")
gs_codename = dw_1.GetItemString(Row,"reffpf_rfna1")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_model_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_model_popup
end type

type cb_return from w_inherite_popup`cb_return within w_model_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_model_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_model_popup
end type

type st_1 from w_inherite_popup`st_1 within w_model_popup
end type

type rr_2 from roundrectangle within w_model_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 244
integer width = 1819
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

