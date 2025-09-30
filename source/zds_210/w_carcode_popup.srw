$PBExportHeader$w_carcode_popup.srw
$PBExportComments$* 차종코드 가져오기
forward
global type w_carcode_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_carcode_popup
end type
type rr_1 from roundrectangle within w_carcode_popup
end type
end forward

global type w_carcode_popup from w_inherite_popup
integer x = 1408
integer y = 260
integer width = 2149
integer height = 1656
string title = "차종모델 선택"
dw_2 dw_2
rr_1 rr_1
end type
global w_carcode_popup w_carcode_popup

type variables
str_code istr_car
end variables

on w_carcode_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_carcode_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)
dw_2.Object.carcode[1] = gs_code

dw_1.Retrieve(gs_code)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_carcode_popup
boolean visible = false
integer x = 27
integer y = 1908
integer width = 224
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_carcode_popup
integer x = 1915
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Long i

For i=1 To UpperBound(istr_car.code)
	SetNull(istr_car.code[i])
	SetNull(istr_car.sgubun1[i])
Next

CloseWithReturn(Parent,istr_car)
end event

type p_inq from w_inherite_popup`p_inq within w_carcode_popup
boolean visible = false
integer x = 215
integer y = 1908
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_carcode_popup
integer x = 1742
integer y = 24
end type

event p_choose::clicked;call super::clicked;
Long ll_row , i , ii=0

ll_Row = dw_1.RowCount()

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

For i = 1 To ll_row
	If dw_1.Object.is_chek[i] = 'Y' Then
	
		ii++
		
		istr_car.code[ii]    = dw_1.Object.carcode[i]
		istr_car.codename[ii]    = dw_1.Object.carname[i]
		//istr_car.sgubun1[ii]  = dw_1.Object.seq[i]
		

	End If
Next

CloseWithReturn(Parent , istr_car)


//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code = string(dw_1.GetItemString(ll_Row, "carcode"))
//gs_codename = string(dw_1.GetItemString(ll_Row, "seq"),'000')
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_carcode_popup
integer x = 32
integer y = 212
integer width = 2071
integer height = 1320
integer taborder = 10
string dataobject = "d_carcode_popup"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

istr_car.code[1]     = dw_1.Object.carcode[row]
istr_car.codename[1]     = dw_1.Object.carname[row]
istr_car.sgubun1[1]  = dw_1.Object.seq[row]

CloseWithReturn(Parent , istr_car)
end event

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

end event

type sle_2 from w_inherite_popup`sle_2 within w_carcode_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_carcode_popup
boolean visible = false
integer x = 402
integer y = 1848
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_carcode_popup
boolean visible = false
integer x = 722
integer y = 1848
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_carcode_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_carcode_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_carcode_popup
boolean visible = false
end type

type dw_2 from datawindow within w_carcode_popup
integer x = 23
integer y = 16
integer width = 1417
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_carcode_popup_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_col , ls_value
ls_col = Lower(GetColumnName())
ls_value = GetText()
Choose Case  ls_col
	Case 'carcode'
		If ls_value = '' Or isNull(ls_value) Then ls_value = ''
		dw_1.Retrieve(ls_value)
		
End Choose
		
end event

type rr_1 from roundrectangle within w_carcode_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 204
integer width = 2089
integer height = 1344
integer cornerheight = 40
integer cornerwidth = 55
end type

