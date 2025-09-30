$PBExportHeader$w_sm30_3010_popup2.srw
$PBExportComments$거래처 제품단가 팝업
forward
global type w_sm30_3010_popup2 from w_inherite_popup
end type
type cbx_1 from checkbox within w_sm30_3010_popup2
end type
type rr_2 from roundrectangle within w_sm30_3010_popup2
end type
end forward

global type w_sm30_3010_popup2 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3205
integer height = 1792
string title = "거래처별 품목(단가)"
cbx_1 cbx_1
rr_2 rr_2
end type
global w_sm30_3010_popup2 w_sm30_3010_popup2

type variables
string is_itcls

str_code istr_itnbr
end variables

on w_sm30_3010_popup2.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_sm30_3010_popup2.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.rr_2)
end on

event open;call super::open;Long i

For i=1 To UpperBound(istr_itnbr.code)
	SetNull(istr_itnbr.code[i])
	SetNull(istr_itnbr.codename[i])
Next


dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'cvcod', gs_code)
dw_jogun.setitem(1, 'cvnas', gs_codename)




end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm30_3010_popup2
integer y = 28
integer width = 1888
integer height = 252
string dataobject = "d_sm30_3010_popup2_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_sm30_3010_popup2
integer x = 2999
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Long i

For i=1 To UpperBound(istr_itnbr.code)
	SetNull(istr_itnbr.code[i])
	SetNull(istr_itnbr.codename[i])
Next

CloseWithReturn(Parent,istr_itnbr)
end event

type p_inq from w_inherite_popup`p_inq within w_sm30_3010_popup2
integer x = 2651
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_cvcod , ls_itnbr
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

ls_cvcod = dw_jogun.GetItemString(1,'cvcod')
ls_itnbr = dw_jogun.GetItemString(1,'itnbr')

If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = ''

dw_1.Retrieve(ls_cvcod , ls_itnbr)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sm30_3010_popup2
integer x = 2825
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
		
		istr_itnbr.code[ii]     = dw_1.Object.vnddan_itnbr[i]
		istr_itnbr.codename[ii] = dw_1.Object.itemas_itdsc[i]
		istr_itnbr.sgubun1[ii]  = dw_1.Object.itemas_ispec[i]
		istr_itnbr.sgubun2[ii]  = dw_1.Object.itemas_jijil[i]
		istr_itnbr.sgubun3[ii]  = dw_1.Object.itemas_unmsr[i]
		istr_itnbr.sgubun4[ii]  = dw_1.Object.vnddan_curr[i]
		
		istr_itnbr.dgubun1[ii]  = dw_1.Object.vnddan_sales_price[i]
		istr_itnbr.dgubun2[ii]  = dw_1.Object.vnddan_broad_price[i]
	
	End If
Next

CloseWithReturn(Parent , istr_itnbr)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sm30_3010_popup2
integer x = 37
integer y = 300
integer width = 3113
integer height = 1356
integer taborder = 100
string dataobject = "d_sm30_3010_popup2_2"
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

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

istr_itnbr.code[1]     = dw_1.Object.itemas_itnbr[Row]
istr_itnbr.codename[1] = dw_1.Object.itemas_itdsc[Row]
istr_itnbr.sgubun1[1]  = dw_1.Object.itemas_ispec[Row]
istr_itnbr.sgubun2[1]  = dw_1.Object.itemas_jijil[Row]
istr_itnbr.sgubun3[1]  = dw_1.Object.itemas_useyn[Row]

CloseWithReturn(Parent , istr_itnbr)

//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
////IF dw_1.GetItemString(Row, "itemas_useyn") = '1' then
////	f_message_chk(53, "[품번]")
////	Return 
//IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF
//
//gs_code= dw_1.GetItemString(Row, "itemas_itnbr")
//gs_codename= dw_1.GetItemString(row,"itemas_itdsc")
//gs_gubun= dw_1.GetItemString(row,"itemas_ispec")
//gs_codename2 = dw_1.GetItemString(row,"itemas_jijil")
//
//Close(Parent)
//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm30_3010_popup2
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm30_3010_popup2
end type

type cb_return from w_inherite_popup`cb_return within w_sm30_3010_popup2
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm30_3010_popup2
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm30_3010_popup2
end type

type st_1 from w_inherite_popup`st_1 within w_sm30_3010_popup2
end type

type cbx_1 from checkbox within w_sm30_3010_popup2
integer x = 46
integer y = 336
integer width = 105
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 28144969
boolean lefttext = true
end type

event clicked;Long i
If This.Checked Then
	For i = 1 To dw_1.RowCount()
		dw_1.Object.is_chek[i] = 'Y'
	Next
Else
	For i = 1 To dw_1.RowCount()
		dw_1.Object.is_chek[i] = 'N'
	Next
End If
end event

type rr_2 from roundrectangle within w_sm30_3010_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 292
integer width = 3145
integer height = 1384
integer cornerheight = 40
integer cornerwidth = 55
end type

