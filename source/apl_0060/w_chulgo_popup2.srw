$PBExportHeader$w_chulgo_popup2.srw
$PBExportComments$출고번호 조회(할당)
forward
global type w_chulgo_popup2 from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_chulgo_popup2
end type
type pb_2 from u_pb_cal within w_chulgo_popup2
end type
type rr_1 from roundrectangle within w_chulgo_popup2
end type
end forward

global type w_chulgo_popup2 from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3214
integer height = 2156
string title = "출고번호 조회(할당)"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_chulgo_popup2 w_chulgo_popup2

type variables
String  is_gub
end variables

on w_chulgo_popup2.create
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

on w_chulgo_popup2.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

is_gub = gs_gubun

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_chulgo_popup2
integer y = 176
integer width = 3177
integer height = 236
string dataobject = "d_chulgo_popup2_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull, sitnbr, sitdsc, sispec, sdate
Int    ireturn

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN
	sdate = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sdate) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN
	sdate = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sdate) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
END IF

end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "itnbr"	THEN
	gs_gubun = '1'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF	this.getcolumnname() = "fr_jisi"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_jisi", gs_code)
ELSEIF	this.getcolumnname() = "to_jisi"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_jisi", gs_code)
END IF
end event

type p_exit from w_inherite_popup`p_exit within w_chulgo_popup2
integer x = 2994
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_chulgo_popup2
integer x = 2647
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sfpordno, stpordno, sitnbr, sdepot

if dw_jogun.AcceptText() = -1 then return 

sdatef   		= trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet   		= trim(dw_jogun.GetItemString(1,"to_date"))
sFpordno 	= trim(dw_jogun.GetItemString(1,"fr_jisi"))
sTpordno 	= trim(dw_jogun.GetItemString(1,"to_jisi"))
sitnbr   		= trim(dw_jogun.GetItemString(1,"itnbr"))
sdepot   		= trim(dw_jogun.GetItemString(1,"depot"))

IF sdatef ="" OR IsNull(sdatef) THEN	sdatef ='.'
IF sdatet = "" OR IsNull(sdatet) THEN sdatet ='99999999'

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF sFpordno = "" OR IsNull(sFpordno) THEN	sFpordno = '.'
IF sTpordno = "" OR IsNull(sTpordno) THEN sTpordno = '9999999999999999'

IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = '%'
IF sDepot = "" OR IsNull(sDepot) THEN sDepot = '%'

IF dw_1.Retrieve(gs_sabu, gs_saupj, sdatef, sdatet, is_gub, sfpordno, stpordno, sitnbr, sdepot) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_chulgo_popup2
integer x = 2821
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "imhist_iojpno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_chulgo_popup2
integer x = 37
integer y = 424
integer width = 3127
integer height = 1624
string dataobject = "d_chulgo_popup2"
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

gs_code= dw_1.GetItemString(Row, "imhist_iojpno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_chulgo_popup2
boolean visible = false
integer x = 1111
integer y = 2132
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_chulgo_popup2
integer x = 160
integer y = 2100
end type

type cb_return from w_inherite_popup`cb_return within w_chulgo_popup2
integer x = 782
integer y = 2100
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_chulgo_popup2
integer x = 471
integer y = 2100
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_chulgo_popup2
boolean visible = false
integer x = 448
integer y = 2132
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_chulgo_popup2
boolean visible = false
integer x = 178
integer y = 2152
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_chulgo_popup2
integer x = 722
integer y = 204
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_chulgo_popup2
integer x = 1170
integer y = 204
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_chulgo_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 420
integer width = 3154
integer height = 1636
integer cornerheight = 40
integer cornerwidth = 55
end type

