$PBExportHeader$w_pdt_04035_ip.srw
$PBExportComments$출고등록(직접출고) - 입고품 내역 선택 POP-UP
forward
global type w_pdt_04035_ip from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pdt_04035_ip
end type
type rr_2 from roundrectangle within w_pdt_04035_ip
end type
end forward

global type w_pdt_04035_ip from w_inherite_popup
integer width = 4672
integer height = 2732
string title = "입고품 내역 선택"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_04035_ip w_pdt_04035_ip

on w_pdt_04035_ip.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_04035_ip.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'd_st' , String(TODAY(), 'yyyymm') + '01')
dw_jogun.SetItem(1, 'd_ed' , String(TODAY(), 'yyyymmdd')     )
dw_jogun.SetItem(1, 'saupj', gs_saupj                        )

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_04035_ip
integer x = 55
integer y = 60
integer width = 4032
integer height = 116
string dataobject = "d_pdt_04035_ipjogun"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If This.GetColumnName() = 'cvcod' Then
	gs_gubun = '1'
	
	Open(w_vndmst_popup)
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(1, 'cvcod', gs_code    )
	This.SetItem(1, 'cvnas', gs_codename)
	
ElseIf This.GetColumnName() = 'itnbr' Then
	Open(w_itemas_popup)
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(1, 'itnbr', gs_code)
	
End If
end event

event dw_jogun::itemchanged;call super::itemchanged;If row < 1 Then Return

String  ls_name
Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		SELECT CVNAS2 INTO :ls_name FROM VNDMST WHERE CVCOD = :data ;
		If Trim(ls_name) = '' OR IsNull(ls_name) OR SQLCA.SQLCODE <> 0 Then
			MessageBox('거래처 확인', '해당 거래처 코드는 등록된 거래처 코드가 아닙니다.')
			This.SetFocus()
			This.SetColumn('cvcod')
			This.SetItem(row, 'cvcod', SetNull(ls_name))
			Return 1
		End If
		
		This.SetItem(row, 'cvnas', ls_name)
		
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END INTO :ls_name FROM ITEMAS WHERE ITNBR = :data ;
		If ls_name <> 'Y' OR IsNull(ls_name) OR SQLCA.SQLCODE <> 0 Then
			MessageBox('품번 확인', '해당 품번은 등록된 품번이 아닙니다.')
			This.SetFocus()
			This.SetColumn('itnbr')
			This.SetItem(row, 'itnbr', SetNull(ls_name))
			Return 1
		End If
		
End Choose
end event

event dw_jogun::itemerror;call super::itemerror;Return 1
end event

type p_exit from w_inherite_popup`p_exit within w_pdt_04035_ip
integer x = 4462
integer y = 36
end type

event p_exit::clicked;call super::clicked;str_code  lstr_code

lstr_code.code[1] = 'X'
CloseWithReturn(Parent, lstr_code)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_04035_ip
integer x = 4114
integer y = 36
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Integer row
row = dw_jogun.GetRow()
If row < 1 Then Return

String  ls_saupj
ls_saupj = dw_jogun.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

String  ls_st
ls_st = dw_jogun.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('시작일 확인', '시작일을 입력 하십시오.')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('d_st')
	Return
ElseIf IsDate(LEFT(ls_st, 4) + '/' + MID(ls_st, 5, 2) + '/' + RIGHT(ls_st, 2)) = False Then
	MessageBox('시작일 유형 확인', '시작일의 일자 형식이 맞지 않습니다.')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('d_st')
	Return
End If

String  ls_ed
ls_ed = dw_jogun.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	MessageBox('종료일 확인', '종료일을 입력 하십시오.')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('d_ed')
	Return
ElseIf IsDate(LEFT(ls_ed, 4) + '/' + MID(ls_ed, 5, 2) + '/' + RIGHT(ls_ed, 2)) = False Then
	MessageBox('시작일 유형 확인', '시작일의 일자 형식이 맞지 않습니다.')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('d_ed')
	Return
End If

String  ls_cvcod
ls_cvcod = dw_jogun.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String  ls_itnbr
ls_itnbr = dw_jogun.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' Or IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_cvcod, ls_itnbr, ls_saupj)
dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_pdt_04035_ip
integer x = 4288
integer y = 36
end type

event p_choose::clicked;call super::clicked;dw_1.AcceptText()

Integer li_cnt
li_cnt = dw_1.RowCount()
If li_cnt < 1 Then Return

str_code  lstr_code

Integer li_find
li_find = dw_1.Find("chk = 'Y'", 1, li_cnt)
If li_find < 1 Then
	MessageBox('선택 확인', '선택된 행이 없습니다.')
	Return
End If

SetNull(li_find)

Integer i
Integer l ; l = 0
For i = 1 To li_cnt
	li_find = dw_1.Find("chk = 'Y'", i, li_cnt)
	If li_find < 1 Then Exit
	
	l++
	
	lstr_code.code[l]    = dw_1.GetItemString(li_find, 'itnbr' )
	lstr_code.sgubun1[l] = dw_1.GetItemString(li_find, 'itdsc' )
	lstr_code.sgubun2[l] = dw_1.GetItemString(li_find, 'ispec' )
	lstr_code.sgubun3[l] = dw_1.GetItemString(li_find, 'lotsno')
	lstr_code.dgubun1[l] = dw_1.GetItemNumber(li_find, 'ioqty' )
	
	i = li_find
Next

CloseWithReturn(Parent, lstr_code)
end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_04035_ip
integer x = 50
integer y = 252
integer width = 4567
integer height = 2352
string dataobject = "d_pdt_04035_iplist"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_pdt_04035_ip
boolean visible = false
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_04035_ip
boolean visible = false
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_04035_ip
boolean visible = false
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_04035_ip
boolean visible = false
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_04035_ip
boolean visible = false
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_04035_ip
boolean visible = false
integer x = 55
end type

type rr_1 from roundrectangle within w_pdt_04035_ip
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 4594
integer height = 2376
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_04035_ip
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 28
integer width = 4064
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

