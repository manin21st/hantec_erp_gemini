$PBExportHeader$w_kfic10_popup1.srw
$PBExportComments$리스회사 popup
forward
global type w_kfic10_popup1 from w_inherite_popup
end type
type st_2 from statictext within w_kfic10_popup1
end type
type gb_1 from groupbox within w_kfic10_popup1
end type
type rr_1 from roundrectangle within w_kfic10_popup1
end type
type rr_2 from roundrectangle within w_kfic10_popup1
end type
type ln_1 from line within w_kfic10_popup1
end type
type ln_2 from line within w_kfic10_popup1
end type
end forward

global type w_kfic10_popup1 from w_inherite_popup
integer x = 1879
integer y = 16
integer width = 1993
integer height = 1948
string title = "리스회사 조회"
st_2 st_2
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
end type
global w_kfic10_popup1 w_kfic10_popup1

on w_kfic10_popup1.create
int iCurrent
call super::create
this.st_2=create st_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.ln_2
end on

on w_kfic10_popup1.destroy
call super::destroy
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;call super::open;String ls_saup,saup_nm, ls_string

F_Window_Center_Response(This)

ls_string = f_nvl(gs_code, "")

If Len(ls_string) > 0 Then
	Choose Case Asc(ls_string)
		//숫자 - 코드
		Case is < 127
			sle_1.text = ls_string

		//문자 - 명칭
		Case is >= 127
			sle_2.text = ls_string

	End Choose
End If

//sle_1.text=Left(lstr_custom.code,20)
//ls_saup =Trim(sle_1.text)+"%"
//
//sle_name.text =lstr_custom.name
//saup_nm =Trim(sle_name.text)+"%"

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

sle_2.SetFocus()

p_inq.triggerevent(clicked!)

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if



end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kfic10_popup1
boolean visible = false
integer x = 224
integer y = 1940
integer width = 142
integer height = 56
end type

type p_exit from w_inherite_popup`p_exit within w_kfic10_popup1
integer x = 1797
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kfic10_popup1
integer x = 1449
integer y = 24
end type

event p_inq::clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"
sname  = "%" + Trim(sle_2.text) + "%"

IF dw_1.Retrieve(scode,sname) <= 0 THEN
	MessageBox("확 인","조회할 자료가 없습니다.!!!")
	sle_1.SetFocus()
	Return
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_kfic10_popup1
integer x = 1623
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "person_cd")
gs_codename= dw_1.GetItemString(ll_row,"person_nm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_kfic10_popup1
integer x = 32
integer y = 188
integer width = 1888
integer height = 1636
string dataobject = "d_kfic10_popup1"
end type

event dw_1::clicked;String ls_dwo

ls_dwo = dwo.name

If Isnull(ls_dwo) then return 

If Right(ls_dwo, 2) = "_t" then
	uf_sort(ls_dwo)
End If

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(row,True)

	sle_1.text =dw_1.GetItemString(Row,"person_cd")
	sle_2.text =dw_1.GetItemString(Row,"person_nm")

	b_flag = False
END IF

call super ::clicked
end event

event dw_1::doubleclicked;call super::doubleclicked;IF row <=0 THEN RETURN

gs_code= dw_1.GetItemString(Row, "person_cd")
gs_codename= dw_1.GetItemString(row,"person_nm")

Close(Parent)

end event

event dw_1::ue_pressenter;p_choose.triggerevent(clicked!)
end event

type sle_2 from w_inherite_popup`sle_2 within w_kfic10_popup1
integer x = 658
integer y = 56
integer width = 750
end type

event sle_2::modified;call super::modified;String ls_saup_no,ls_saupnm

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_2.text)+"%"

if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve(ls_saup_no,ls_saupnm)
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   end if
end if

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type cb_1 from w_inherite_popup`cb_1 within w_kfic10_popup1
boolean visible = false
integer x = 667
integer y = 1940
end type

event cb_1::clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "person_cd")
gs_codename= dw_1.GetItemString(ll_row,"person_nm")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_kfic10_popup1
boolean visible = false
integer x = 1303
integer y = 1940
end type

event cb_return::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_kfic10_popup1
boolean visible = false
integer x = 987
integer y = 1940
end type

event cb_inq::clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"
sname  = "%" + Trim(sle_2.text) + "%"

IF dw_1.Retrieve(scode,sname) <= 0 THEN
	MessageBox("확 인","조회할 자료가 없습니다.!!!")
	sle_1.SetFocus()
	Return
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type sle_1 from w_inherite_popup`sle_1 within w_kfic10_popup1
integer x = 306
integer y = 60
integer width = 338
end type

event sle_1::modified;call super::modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( sle_1.TEXT + "%", "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

type st_1 from w_inherite_popup`st_1 within w_kfic10_popup1
string text = "리스회사"
end type

type st_2 from statictext within w_kfic10_popup1
integer x = 46
integer y = 76
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "리스회사"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_kfic10_popup1
boolean visible = false
integer x = 631
integer y = 1892
integer width = 1001
integer height = 188
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

type rr_1 from roundrectangle within w_kfic10_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 184
integer width = 1915
integer height = 1652
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfic10_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 36
integer width = 1417
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfic10_popup1
integer linethickness = 1
integer beginx = 315
integer beginy = 140
integer endx = 645
integer endy = 140
end type

type ln_2 from line within w_kfic10_popup1
integer linethickness = 1
integer beginx = 672
integer beginy = 140
integer endx = 1408
integer endy = 140
end type

