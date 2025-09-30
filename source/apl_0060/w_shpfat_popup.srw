$PBExportHeader$w_shpfat_popup.srw
$PBExportComments$** 공정검사 불량 조회 선택(17.06.21-한텍)
forward
global type w_shpfat_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_shpfat_popup
end type
type pb_2 from u_pb_cal within w_shpfat_popup
end type
type rr_1 from roundrectangle within w_shpfat_popup
end type
end forward

global type w_shpfat_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3753
integer height = 2116
string title = "공정검사 반품 조회 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_shpfat_popup w_shpfat_popup

type variables
str_code istr_itnbr
end variables

on w_shpfat_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_shpfat_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_shpfat_popup
integer y = 16
integer width = 1307
integer height = 132
string dataobject = "d_shpfat_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_shpfat_popup
integer x = 3502
integer y = 12
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

type p_inq from w_inherite_popup`p_inq within w_shpfat_popup
integer x = 3154
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sgub

if dw_jogun.AcceptText() = -1 then return 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_shpfat_popup
integer x = 3328
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row , i , ii=0

ll_Row = dw_1.RowCount()

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

For i = 1 To ll_row
	If dw_1.Object.is_chek[i] = 'Y' Then
		ii++
		
		istr_itnbr.code[ii]     = dw_1.Object.shpfat_rmks[i]
		istr_itnbr.sgubun1[ii]  = dw_1.Object.shpfat_scode2[i]	/* 귀책처 */
		istr_itnbr.sgubun2[ii]  = dw_1.Object.sname[i]				/* 귀책처명 */
		istr_itnbr.sgubun3[ii]  = dw_1.Object.shpfat_shpjpno[i]	/* 실적번호 */
//		istr_itnbr.sgubun4[ii]  = dw_1.Object.itemas_unmsr[i]
//		istr_itnbr.sgubun5[ii]  = dw_1.Object.itemas_pumsr[i]
//		istr_itnbr.sgubun6[ii]  = dw_1.Object.itemas_ittyp[i]
		istr_itnbr.dgubun1[ii]  = dw_1.Object.shpfat_guqty[i]
//		istr_itnbr.dgubun2[ii]  = dw_1.Object.itemas_waght[i]
	End If
Next

CloseWithReturn(Parent , istr_itnbr)

end event

type dw_1 from w_inherite_popup`dw_1 within w_shpfat_popup
integer x = 37
integer y = 188
integer width = 3634
integer height = 1800
string dataobject = "d_shpfat_popup1"
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

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//istr_itnbr.code[1]     = dw_1.Object.itemas_itnbr[Row]
//istr_itnbr.codename[1] = dw_1.Object.itemas_itdsc[Row]
//istr_itnbr.sgubun1[1]  = dw_1.Object.itemas_ispec[Row]
//istr_itnbr.sgubun2[1]  = dw_1.Object.itemas_jijil[Row]
//istr_itnbr.sgubun3[1]  = dw_1.Object.itemas_useyn[Row]
//
//CloseWithReturn(Parent , istr_itnbr)
//
end event

event dw_1::itemchanged;call super::itemchanged;long		lrow
string		scvcod

IF dwo.name = 'is_chek' THEN
	
	if data = 'N' or isnull(data) then return 
	
	scvcod = this.GetItemString(row, 'shpfat_scode2')
	
	lrow = this.Find("is_chek = 'Y' and shpfat_scode2 <> '"+scvcod+"'", 1, this.RowCount())
	
	IF lrow > 0	then
		MessageBox('확인','동일한 귀책처만 선택 가능합니다!!')
		this.setitem(row, 'is_chek', 'N')
		return 1
	END IF

END IF


end event

event dw_1::itemerror;call super::itemerror;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_shpfat_popup
boolean visible = false
integer x = 1015
integer y = 52
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_shpfat_popup
integer x = 1883
integer y = 2408
end type

type cb_return from w_inherite_popup`cb_return within w_shpfat_popup
integer x = 2505
integer y = 2408
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_shpfat_popup
integer x = 2194
integer y = 2408
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_shpfat_popup
boolean visible = false
integer x = 352
integer y = 52
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_shpfat_popup
boolean visible = false
integer x = 82
integer y = 72
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_shpfat_popup
integer x = 686
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_shpfat_popup
integer x = 1134
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rr_1 from roundrectangle within w_shpfat_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 180
integer width = 3666
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type

