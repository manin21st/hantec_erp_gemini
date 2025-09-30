$PBExportHeader$w_kfic10_popup.srw
$PBExportComments$리스조회popup
forward
global type w_kfic10_popup from w_inherite_popup
end type
type sle_3 from singlelineedit within w_kfic10_popup
end type
type gb_1 from groupbox within w_kfic10_popup
end type
type rr_1 from roundrectangle within w_kfic10_popup
end type
type rr_2 from roundrectangle within w_kfic10_popup
end type
type ln_1 from line within w_kfic10_popup
end type
end forward

global type w_kfic10_popup from w_inherite_popup
integer x = 1783
integer y = 4
integer height = 1796
string title = "리스조회"
sle_3 sle_3
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
end type
global w_kfic10_popup w_kfic10_popup

on w_kfic10_popup.create
int iCurrent
call super::create
this.sle_3=create sle_3
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_3
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.ln_1
end on

on w_kfic10_popup.destroy
call super::destroy
destroy(this.sle_3)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
end on

event open;call super::open;
F_Window_Center_Response(This)

IF IsNull(gs_code) THEN gs_code =""

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sle_1.text = gs_code

gs_code = sle_1.text +'%'

dw_1.Retrieve(gs_code)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kfic10_popup
boolean visible = false
integer x = 1061
integer y = 88
integer width = 663
integer height = 84
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_kfic10_popup
integer taborder = 70
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kfic10_popup
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String scode
scode = sle_3.text +'%'

IF dw_1.Retrieve(scode) <=0 THEN
	messagebox("확인", "조회할 자료가 없습니다.!!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_kfic10_popup
integer taborder = 50
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "lsno")


Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_kfic10_popup
integer y = 200
integer width = 2203
integer height = 1464
string dataobject = "d_kfic10_popup"
end type

event dw_1::clicked;//String ls_dwo
//
//ls_dwo = dwo.name
//
//If Isnull(ls_dwo) then return 
//
//If Right(ls_dwo, 2) = "_t" then
//	uf_sort(ls_dwo)
//End If

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text =dw_1.GetItemString(Row,"lsno")
	
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF


int li_idx,li_loc, li_i
long ll_clickedrow, ll_cur_row
String ls_raised = '6' , ls_lowered = '5' 
string ls_keydowntype,ls_dwobject, ls_tabkey = '~t', ls_dwobject_name
String ls_modify, ls_setsort, ls_rc, ls_sort_title, ls_col_no
DataWindow dw_sort

SetPointer(HourGlass!)

ls_dwobject = GetObjectAtPointer()
li_loc = Pos(ls_dwobject, ls_tabkey)
If li_loc = 0 Then Return
ls_dwobject_name = Left(ls_dwobject, li_loc - 1)

if Right(ls_dwobject_name,2) <> '_t' then return
   
IF b_flag =False THEN 
	b_flag =True
	RETURN
END IF 

If ls_dwobject_name = 'type'  Then
	If Describe(ls_dwobject_name + ".border") = ls_lowered Then
		ls_modify = ls_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'오름차순'"
	Else
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'내림차순'"
	End If

	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If
	uf_sort(is_old_dwobject_name)
	Return
End If

If is_old_dwobject_name <> ls_dwobject_name Then 
	If uf_sort(ls_dwobject_name) = -1 Then Return
	If is_old_dwobject_name = "" Then
		ls_col_no = String(Describe("datawindow.column.count"))
		For li_i = 1 To Integer(ls_col_no)
			If Describe("#" + ls_col_no + ".border") = ls_lowered Then
				is_old_dwobject_name = Describe("#" + ls_col_no + &
				 + ".name") + "_t"
				is_old_color = Describe(is_old_dwobject_name + ".color")
				Exit
			End If
		Next
	End If
	If is_old_dwobject_name <> "" Then
		ls_modify = is_old_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + &
		 is_old_dwobject_name + ".color=" + is_old_color
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
	End If
	is_old_color = Describe(ls_dwobject_name + ".color")
	ls_modify = ls_dwobject_name + ".border=" + ls_lowered
	ls_modify = ls_modify + " " + &
	 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("Modify", ls_rc + " : " + ls_modify)
		Return
	End If

	is_old_dwobject_name = ls_dwobject_name
End If

end event

event dw_1::doubleclicked;call super::doubleclicked;IF row <=0 THEN RETURN -1

gs_code= dw_1.GetItemString(Row, "lsno")

Close(Parent)
end event

event dw_1::itemerror;call super::itemerror;RETURN 1
end event

event dw_1::ue_pressenter;p_choose.triggerEvent(clicked!)
end event

type sle_2 from w_inherite_popup`sle_2 within w_kfic10_popup
boolean visible = false
integer x = 887
integer width = 914
integer taborder = 60
end type

event sle_2::modified;call super::modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( "%" , "%" + sle_2.TEXT + "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

type cb_1 from w_inherite_popup`cb_1 within w_kfic10_popup
boolean visible = false
integer x = 731
integer y = 2180
integer taborder = 80
end type

event cb_1::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "lsno")


Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_kfic10_popup
boolean visible = false
integer x = 1367
integer y = 2180
integer taborder = 110
end type

event cb_return::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_kfic10_popup
boolean visible = false
integer x = 1051
integer y = 2180
integer taborder = 90
end type

event cb_inq::clicked;call super::clicked;String scode
scode = sle_1.text +'%'

IF dw_1.Retrieve(scode) <=0 THEN
	messagebox("확인", "조회할 자료가 없습니다.!!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type sle_1 from w_inherite_popup`sle_1 within w_kfic10_popup
integer x = 407
integer width = 581
integer taborder = 40
integer limit = 20
end type

event sle_1::modified;call super::modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( sle_1.TEXT + "%" ,  "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

type st_1 from w_inherite_popup`st_1 within w_kfic10_popup
integer width = 375
integer taborder = 10
string text = "자사리스번호"
end type

type sle_3 from singlelineedit within w_kfic10_popup
integer x = 37
integer y = 72
integer width = 663
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
textcase textcase = lower!
integer limit = 5
end type

type gb_1 from groupbox within w_kfic10_popup
boolean visible = false
integer x = 699
integer y = 2128
integer width = 1001
integer height = 188
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfic10_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 196
integer width = 2235
integer height = 1480
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfic10_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 40
integer width = 718
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfic10_popup
integer linethickness = 1
integer beginx = 41
integer beginy = 144
integer endx = 695
integer endy = 144
end type

