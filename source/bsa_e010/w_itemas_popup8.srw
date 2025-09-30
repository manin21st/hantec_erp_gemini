$PBExportHeader$w_itemas_popup8.srw
$PBExportComments$** 품목코드 조회 선택(완제품,부품,상품)완료처리된 품목
forward
global type w_itemas_popup8 from w_inherite_popup
end type
type sle_ispec from singlelineedit within w_itemas_popup8
end type
type sle_jijil from singlelineedit within w_itemas_popup8
end type
type sle_ispec_code from singlelineedit within w_itemas_popup8
end type
type st_ispec from statictext within w_itemas_popup8
end type
type st_jijil from statictext within w_itemas_popup8
end type
type st_ispeccode from statictext within w_itemas_popup8
end type
type cb_2 from commandbutton within w_itemas_popup8
end type
type rr_1 from roundrectangle within w_itemas_popup8
end type
end forward

global type w_itemas_popup8 from w_inherite_popup
integer x = 174
integer y = 752
integer width = 2967
integer height = 740
boolean titlebar = false
sle_ispec sle_ispec
sle_jijil sle_jijil
sle_ispec_code sle_ispec_code
st_ispec st_ispec
st_jijil st_jijil
st_ispeccode st_ispeccode
cb_2 cb_2
rr_1 rr_1
end type
global w_itemas_popup8 w_itemas_popup8

on w_itemas_popup8.create
int iCurrent
call super::create
this.sle_ispec=create sle_ispec
this.sle_jijil=create sle_jijil
this.sle_ispec_code=create sle_ispec_code
this.st_ispec=create st_ispec
this.st_jijil=create st_jijil
this.st_ispeccode=create st_ispeccode
this.cb_2=create cb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ispec
this.Control[iCurrent+2]=this.sle_jijil
this.Control[iCurrent+3]=this.sle_ispec_code
this.Control[iCurrent+4]=this.st_ispec
this.Control[iCurrent+5]=this.st_jijil
this.Control[iCurrent+6]=this.st_ispeccode
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_itemas_popup8.destroy
call super::destroy
destroy(this.sle_ispec)
destroy(this.sle_jijil)
destroy(this.sle_ispec_code)
destroy(this.st_ispec)
destroy(this.st_jijil)
destroy(this.st_ispeccode)
destroy(this.cb_2)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

string swhere_clause, sold_sql, snew_sql
Long   nRow

/* 입력가능한 품번은 참조코드(05)의 참조명2가 'Y' */
swhere_clause = " AND ITTYP in ( SELECT RFGUB FROM REFFPF  " + &
			       "                 WHERE RFCOD = '05' AND RFGUB <> '00' AND " + &
					 "                       RFNA2 = 'Y' ) "

If gs_gubun = '%' Then
  IF gs_codename = "품명"  THEN
	  swhere_clause +=" AND ITDSC LIKE '"+ gs_code +"%' "
  ELSEIF gs_codename = "규격"  THEN
	  swhere_clause +=" AND ISPEC LIKE '"+ gs_code +"%' "
  ELSEIF gs_codename = "재질"  THEN
	  swhere_clause +=" AND JIJIL LIKE '"+ gs_code +"%' "
  ELSE
	  swhere_clause +=" AND ISPEC_CODE LIKE '"+ gs_code +"%' "
  END IF
Else
  IF gs_codename = "품명"  THEN
	  swhere_clause +=" AND ITDSC = '"+ gs_code +"' "
  ELSEIF gs_codename = "규격"  THEN
	  swhere_clause +=" AND ISPEC = '"+ gs_code +"' "
  ELSEIF gs_codename = "재질"  THEN
	  swhere_clause +=" AND JIJIL = '"+ gs_code +"' "
  ELSE
	  swhere_clause +=" AND ISPEC_CODE = '"+ gs_code +"' "
  END IF
End If

dw_1.settransobject(sqlca)
sold_sql = dw_1.Getsqlselect()
snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
dw_1.settransobject(sqlca)

if dw_1.Retrieve() < 1 then 
	f_message_chk(33, "[자료확인]")
	setnull(gs_code)
	setnull(gs_codename)
	setnull(gs_gubun)
	Close(this)
	return 
end if	

If gs_codename = "품명" Then
  nRow = dw_1.Find("useyn = '0' and itdsc = '" + gs_code +"'",1,dw_1.RowCount())
ElseIf gs_codename = "규격" Then
  nRow = dw_1.Find("useyn = '0' and ispec = '" + gs_code +"'",1,dw_1.RowCount())
ElseIf gs_codename = "재질" Then
  nRow = dw_1.Find("useyn = '0' and jijil = '" + gs_code +"'",1,dw_1.RowCount())
Else
  nRow = dw_1.Find("useyn = '0' and ispec_code = '" + gs_code +"'",1,dw_1.RowCount())
End If
If nRow <=0 Then nRow = 1

dw_1.SelectRow(0,False)
dw_1.SelectRow(nRow,True)
dw_1.ScrollToRow(nRow)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup8
integer x = 466
integer y = 908
integer width = 1088
integer height = 76
end type

type p_exit from w_inherite_popup`p_exit within w_itemas_popup8
integer x = 2071
integer y = 568
end type

event p_exit::clicked;call super::clicked;cb_return.triggerevent(clicked!)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup8
integer x = 1723
integer y = 568
end type

event p_inq::clicked;call super::clicked;cb_2.triggerevent(clicked!)
end event

type p_choose from w_inherite_popup`p_choose within w_itemas_popup8
integer x = 1897
integer y = 568
end type

event p_choose::clicked;call super::clicked;cb_1.triggerevent(clicked!)
end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup8
integer y = 24
integer width = 2894
integer height = 532
integer taborder = 10
string dataobject = "d_itemas_popup8"
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

IF dw_1.GetItemString(Row, "useyn") = '1' then
	f_message_chk(53, "[품번]")
	Return 
ELSEIF dw_1.GetItemString(Row, "useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(Row, "itnbr")
gs_codename= dw_1.GetItemString(row,"itdsc")
gs_gubun= dw_1.GetItemString(row,"ispec")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup8
boolean visible = false
integer x = 782
integer y = 24
integer width = 1001
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup8
integer x = 2222
integer y = 784
integer taborder = 50
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

IF dw_1.GetItemString(ll_Row, "useyn") = '1' then
	f_message_chk(53, "[품번]")
	Return 
ELSEIF dw_1.GetItemString(ll_Row, "useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(ll_Row, "itnbr")
gs_codename= dw_1.GetItemString(ll_row,"itdsc")
gs_gubun= dw_1.GetItemString(ll_row,"ispec")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_itemas_popup8
integer x = 2519
integer y = 784
integer taborder = 60
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup8
boolean visible = false
integer x = 681
integer y = 760
integer taborder = 0
boolean default = false
end type

event cb_inq::clicked;//String scode,sname,sspec,sold_sql,swhere_clause,snew_sql,sgu
//Int    ipos
//
//dw_2.acceptText()
//sgu = dw_2.GetItemString(1,'ittyp')
//
//IF sgu ="" OR IsNull(sgu) THEN sgu ='%'
//
//IF IsNull(gs_code) THEN gs_code =""
//
//scode  = trim(sle_1.text)
//sname  = trim(sle_2.text)
//sspec  = trim(sle_3.text)
//
//IF IsNull(scode) THEN scode = ""
//IF IsNull(sname) THEN sname = ""
//IF IsNull(sspec) THEN sspec = ""
//
//sold_sql =  " SELECT ITNBR, ITDSC, ISPEC FROM ITEMAS WHERE GBWAN = 'Y' "  
//
//IF scode ="" AND sname ="" AND sspec = ""  THEN 
//	swhere_clause ="AND ITTYP LIKE'"+sgu+"'"
//	
//	snew_sql = sold_sql + swhere_clause
//	dw_1.SetSqlSelect(snew_sql)
//	
//	dw_1.Retrieve()
//	
//	dw_1.SelectRow(0,False)
//	dw_1.SelectRow(1,True)
//	dw_1.ScrollToRow(1)
//	dw_1.SetFocus()
//
//	RETURN
//END IF
//
//IF scode <> "" AND sname = "" AND sspec = "" THEN
//	scode = scode +'%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname <> "" AND sspec = "" THEN
//	sname = sname + '%'
//	swhere_clause ="AND ITDSC LIKE '"+ sname +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname = "" AND sspec <> "" THEN
//	sspec = sspec + '%'
//	swhere_clause ="AND ISPEC LIKE '"+ sspec +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode <> "" AND sname <> "" AND sspec = "" THEN
//	scode = scode +'%'
//	sname = sname + '%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ITDSC LIKE '"+sname+"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode <> "" AND sname = "" AND sspec <> "" THEN
//	scode = scode +'%'
//	sspec = sspec + '%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ISPEC LIKE '"+sspec+"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname <> "" AND sspec <> "" THEN
//	sname = sname + '%'
//	sspec = sspec + '%'
//	swhere_clause ="AND ITDSC LIKE '"+ sname +"' AND ISPEC LIKE '"+sspec+"' AND ITTYP LIKE '"+sgu+"'"
//END IF
//
//snew_sql = sold_sql + swhere_clause
//dw_1.SetSqlSelect(snew_sql)
//	
//IF dw_1.Retrieve() <= 0 THEN
//	f_message_chk(50,'')
//	sle_1.SetFocus()
//	Return
//END IF
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup8
boolean visible = false
integer x = 357
integer y = 24
integer width = 425
integer taborder = 0
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup8
boolean visible = false
integer x = 59
integer y = 36
integer width = 251
long backcolor = 12632256
string text = "품목코드"
alignment alignment = left!
end type

type sle_ispec from singlelineedit within w_itemas_popup8
integer x = 293
integer y = 612
integer width = 503
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_jijil from singlelineedit within w_itemas_popup8
integer x = 1001
integer y = 612
integer width = 503
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_ispec_code from singlelineedit within w_itemas_popup8
boolean visible = false
integer x = 1335
integer y = 760
integer width = 503
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_ispec from statictext within w_itemas_popup8
integer x = 114
integer y = 612
integer width = 178
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "규격"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_jijil from statictext within w_itemas_popup8
integer x = 823
integer y = 612
integer width = 178
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "재질"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ispeccode from statictext within w_itemas_popup8
boolean visible = false
integer x = 1033
integer y = 780
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "규격코드"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_itemas_popup8
integer x = 1897
integer y = 780
integer width = 293
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Find(&F)"
end type

event clicked;String sIspec, sJijil, sIspecCode, sFilter = ''
Long   lFind

sIspec		= Trim(sle_ispec.Text)
sJijil      = Trim(sle_jijil.Text)
sIspecCode  = Trim(sle_ispec_code.Text)

If Not IsNull(sIspec) And sIspec <> '' Then
	sFilter = "( ispec like '" + sIspec + "%' ) and"
End If

If Not IsNull(sJijil) And sJijil <> '' Then
	sFilter += "( jijil like '" + sJijil + "%' ) and"
End If

If Not IsNull(sIspecCode) And sIspecCode <> '' Then
	sFilter += "( ispec_code like '" + sIspecCode + "%' ) and"
End If

If sFilter <> '' Then
	sFilter = Mid(sFilter,1, Len(sFilter) -4)
End If

dw_1.SetFilter(sFilter)
dw_1.Filter()

end event

type rr_1 from roundrectangle within w_itemas_popup8
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 8
integer width = 2926
integer height = 560
integer cornerheight = 40
integer cornerwidth = 55
end type

