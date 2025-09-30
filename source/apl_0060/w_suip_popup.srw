$PBExportHeader$w_suip_popup.srw
$PBExportComments$수입비용
forward
global type w_suip_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_suip_popup
end type
end forward

global type w_suip_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3694
integer height = 1908
string title = "수입비용전표번호 조회"
rr_1 rr_1
end type
global w_suip_popup w_suip_popup

type variables
string isgbn	// 비용일괄등록 여부
end variables

on w_suip_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_suip_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

isgbn = gs_gubun

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_suip_popup
integer x = 23
integer y = 36
integer width = 3022
integer height = 132
string dataobject = "d_suip_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_suip_popup
integer x = 3483
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_suip_popup
integer x = 3136
integer y = 24
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sgub, sno

if dw_jogun.AcceptText() = -1 then return 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))
sgub   = trim(dw_jogun.GetItemString(1,"sgub"))
sno    = trim(dw_jogun.GetItemString(1,"sno"))

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

If isgbn = 'Y' Then
	if isnull(sno) or trim(sno) = '' then
		dw_1.setfilter("not isnull(ac_confirm)")
		dw_1.filter()
	Else
		sno = sno + '%'
		if sgub = '1' then
			dw_1.setfilter("not isnull(ac_confirm) and impexp_polcno like '"+ sno +"'" )		// L/C no로 검색
			dw_1.filter()
		else
			dw_1.setfilter("not isnull(ac_confirm) and impexp_poblno like '"+ sno +"'" )		// B/L no로 검색
			dw_1.filter()
		end if	
	end if
Else
	if isnull(sno) or trim(sno) = '' then
		dw_1.setfilter("isnull(ac_confirm)")
		dw_1.filter()
	Else
		sno = sno + '%'
		if sgub = '1' then
			dw_1.setfilter("isnull(ac_confirm) and impexp_polcno like '"+ sno +"'" )		// L/C no로 검색
			dw_1.filter()
		else
			dw_1.setfilter("isnull(ac_confirm) and impexp_poblno like '"+ sno +"'" )		// B/L no로 검색
			dw_1.filter()
		end if	
	end if
End If

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet) <= 0 THEN
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

type p_choose from w_inherite_popup`p_choose within w_suip_popup
integer x = 3310
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "impexp_expjpno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_suip_popup
integer x = 37
integer y = 192
integer width = 3611
integer height = 1592
string dataobject = "d_suip_popup1"
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

gs_code= dw_1.GetItemString(Row, "impexp_expjpno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_suip_popup
boolean visible = false
integer x = 946
integer y = 2104
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_suip_popup
integer x = 1975
integer y = 2080
end type

type cb_return from w_inherite_popup`cb_return within w_suip_popup
integer x = 2597
integer y = 2080
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_suip_popup
integer x = 2286
integer y = 2080
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_suip_popup
boolean visible = false
integer x = 283
integer y = 2104
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_suip_popup
boolean visible = false
integer x = 14
integer y = 2124
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_suip_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 188
integer width = 3630
integer height = 1608
integer cornerheight = 40
integer cornerwidth = 55
end type

