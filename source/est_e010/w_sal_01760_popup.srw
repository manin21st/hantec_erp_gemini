$PBExportHeader$w_sal_01760_popup.srw
$PBExportComments$견적원가 계산 POPUP
forward
global type w_sal_01760_popup from w_inherite_popup
end type
type dw_ip from u_key_enter within w_sal_01760_popup
end type
type rr_1 from roundrectangle within w_sal_01760_popup
end type
end forward

global type w_sal_01760_popup from w_inherite_popup
integer x = 5
integer y = 288
integer width = 3616
integer height = 2064
string title = "견적계산 조회 POPUP"
dw_ip dw_ip
rr_1 rr_1
end type
global w_sal_01760_popup w_sal_01760_popup

on w_sal_01760_popup.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_01760_popup.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;String sToday

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_ip.SetFocus()

sToday = f_today()
dw_ip.SetItem(1,'sdatet', sToday)
dw_ip.SetItem(1,'sdatef', Left(stoday,6)+'01')

dw_ip.SetColumn('sdatef')

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_01760_popup
integer x = 59
integer y = 2352
end type

type p_exit from w_inherite_popup`p_exit within w_sal_01760_popup
integer x = 3383
integer y = 16
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_01760_popup
integer x = 3035
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sPdm, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sJijil, sIspecCode

If dw_ip.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sPdm	 = Trim(dw_ip.GetItemString(1,'pdm'))
sIttyp	= Trim(dw_ip.GetItemString(1,'ittyp'))
sItcls	= Trim(dw_ip.GetItemString(1,'itcls'))
sItnbr	= Trim(dw_ip.GetItemString(1,'itnbr'))
sItdsc	= Trim(dw_ip.GetItemString(1,'itdsc'))
sIspec	= Trim(dw_ip.GetItemString(1,'ispec'))
sJijil	= Trim(dw_ip.GetItemString(1,'jijil'))
sIspecCode	= Trim(dw_ip.GetItemString(1,'ispec_code'))

If IsNull(sPdm) Then sPdm = ''
If IsNull(sIttyp) Then sIttyp = ''
If IsNull(sItcls) Then sItcls = ''
If IsNull(sItnbr) Then sItnbr = ''
If IsNull(sItdsc) Then sItdsc = ''
If IsNull(sIspec) Then sIspec = ''
If IsNull(sJijil) Then sJijil = ''
If IsNull(sIspecCode) Then sIspecCode = ''

dw_ip.SetFocus()
If f_datechk(sDatef) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatef')
	Return 
End If

If f_datechk(sDatet) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatet')
	Return 
End If

dw_1.Retrieve(gs_sabu,sDatef, sDatet, sPdm+'%', sIttyp+'%', sItcls+'%', sItnbr+'%', sItdsc+'%', sIspec+'%', sJijil+'%', sIspecCode+'%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sal_01760_popup
integer x = 3209
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code  = dw_1.GetItemString(ll_Row, "cstno")
gs_gubun = dw_1.GetItemString(ll_Row, "cstseq")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_01760_popup
integer x = 46
integer y = 420
integer width = 3511
integer height = 1516
integer taborder = 20
string dataobject = "d_sal_01760_popup"
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

gs_code  = dw_1.GetItemString(Row, "cstno")
gs_gubun = dw_1.GetItemString(Row, "cstseq")

Close(Parent)
end event

event dw_1::constructor;call super::constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_01760_popup
boolean visible = false
integer x = 1262
integer y = 2540
integer width = 1138
integer taborder = 0
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_sal_01760_popup
boolean visible = false
integer x = 2464
integer y = 2680
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code  = dw_1.GetItemString(ll_Row, "cstno")
//gs_gubun = dw_1.GetItemString(ll_Row, "cstseq")
//
//Close(Parent)
//
end event

type cb_return from w_inherite_popup`cb_return within w_sal_01760_popup
boolean visible = false
integer x = 3095
integer y = 2680
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_01760_popup
boolean visible = false
integer x = 2784
integer y = 2680
boolean default = false
end type

event cb_inq::clicked;call super::clicked;//String sDatef, sDatet, sPdm, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sJijil, sIspecCode
//
//If dw_ip.AcceptText() <> 1 Then Return 1
//
//sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
//sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
//sPdm	 = Trim(dw_ip.GetItemString(1,'pdm'))
//sIttyp	= Trim(dw_ip.GetItemString(1,'ittyp'))
//sItcls	= Trim(dw_ip.GetItemString(1,'itcls'))
//sItnbr	= Trim(dw_ip.GetItemString(1,'itnbr'))
//sItdsc	= Trim(dw_ip.GetItemString(1,'itdsc'))
//sIspec	= Trim(dw_ip.GetItemString(1,'ispec'))
//sJijil	= Trim(dw_ip.GetItemString(1,'jijil'))
//sIspecCode	= Trim(dw_ip.GetItemString(1,'ispec_code'))
//
//If IsNull(sPdm) Then sPdm = ''
//If IsNull(sIttyp) Then sIttyp = ''
//If IsNull(sItcls) Then sItcls = ''
//If IsNull(sItnbr) Then sItnbr = ''
//If IsNull(sItdsc) Then sItdsc = ''
//If IsNull(sIspec) Then sIspec = ''
//If IsNull(sJijil) Then sJijil = ''
//If IsNull(sIspecCode) Then sIspecCode = ''
//
//dw_ip.SetFocus()
//If f_datechk(sDatef) <> 1  then
//	f_message_chk(35,'')
//	dw_ip.SetColumn('sdatef')
//	Return 
//End If
//
//If f_datechk(sDatet) <> 1  then
//	f_message_chk(35,'')
//	dw_ip.SetColumn('sdatet')
//	Return 
//End If
//
//dw_1.Retrieve(gs_sabu,sDatef, sDatet, sPdm+'%', sIttyp+'%', sItcls+'%', sItnbr+'%', sItdsc+'%', sIspec+'%', sJijil+'%', sIspecCode+'%')
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_sal_01760_popup
boolean visible = false
integer x = 773
integer y = 2540
integer width = 471
integer taborder = 0
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_sal_01760_popup
boolean visible = false
integer x = 251
integer y = 2556
integer width = 494
string text = "C.INVOICE No."
end type

type dw_ip from u_key_enter within w_sal_01760_popup
integer x = 27
integer y = 172
integer width = 3543
integer height = 224
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01760_popup1"
boolean border = false
end type

event itemchanged;String  sNull, sitnbr, sitdsc, sispec, sjijil, sispeccode
Integer ireturn

SetNull(sNull)

Choose Case GetColumnName()
   // 시작일자 유효성 Check
	Case "sdatef"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "sdatef", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "sdatet"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "sdatet", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
	Case "itnbr"
		sItnbr = trim(GetText())
		ireturn = f_get_name4('품번', 'N', sitnbr, sitdsc, sispec, sjijil, sispeccode)    //1이면 실패, 0이 성공	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)
		setitem(1, "ispec", sispec)
		setitem(1, "jijil", sJijil)
					
		RETURN ireturn
	Case 'itcls'
		sItnbr = GetText()
		sispec = getitemstring(1, 'ittyp')
		
		if sitnbr = '' or isnull(sitnbr) then 
			setitem(1, "ittyp", sNull)	
			setitem(1, "titnm", sNull)	
			return
		end if	
		
		ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
		setitem(1, "itcls", sitnbr)
		setitem(1, "titnm", sitdsc)
		
		RETURN ireturn
End Choose
end event

event itemerror;return 1
end event

event rbuttondown;String sIttyp
str_itnct lstr_sitnct

Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case 'itcls'
		sIttyp = GetItemString(nRow, 'ittyp')
		OpenWithParm(w_ittyp_popup, sIttyp)
		
		lstr_sitnct = Message.PowerObjectParm	
		
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		SetItem(nRow, "ittyp", lstr_sitnct.s_ittyp)
		SetItem(nRow, "itcls", lstr_sitnct.s_sumgub)
		SetItem(nRow, "titnm", lstr_sitnct.s_titnm)	
END Choose
end event

type rr_1 from roundrectangle within w_sal_01760_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 412
integer width = 3534
integer height = 1536
integer cornerheight = 40
integer cornerwidth = 55
end type

