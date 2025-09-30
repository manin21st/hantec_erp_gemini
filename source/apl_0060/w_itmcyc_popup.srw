$PBExportHeader$w_itmcyc_popup.srw
$PBExportComments$주기실사 생성 조회 선택
forward
global type w_itmcyc_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_itmcyc_popup
end type
type cb_2 from commandbutton within w_itmcyc_popup
end type
type cb_3 from commandbutton within w_itmcyc_popup
end type
type cb_4 from commandbutton within w_itmcyc_popup
end type
type rr_1 from roundrectangle within w_itmcyc_popup
end type
end forward

global type w_itmcyc_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3177
integer height = 1812
string title = "주기실사 생성 조회"
dw_2 dw_2
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
rr_1 rr_1
end type
global w_itmcyc_popup w_itmcyc_popup

on w_itmcyc_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.rr_1
end on

on w_itmcyc_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)

dw_2.setitem(1, 'depot', gs_code )
dw_2.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_2.setitem(1, 'to_date', f_today())
dw_2.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmcyc_popup
boolean visible = false
integer x = 64
integer y = 1752
integer taborder = 50
end type

type p_exit from w_inherite_popup`p_exit within w_itmcyc_popup
integer x = 2976
integer y = 0
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmcyc_popup
integer x = 2629
integer y = 0
end type

event p_inq::clicked;call super::clicked;
String sdatef, sdatet, sdepot

if dw_2.AcceptText() = -1 then return 

sdatef = trim(dw_2.GetItemString(1,"fr_date"))
sdatet = trim(dw_2.GetItemString(1,"to_date"))
sdepot = trim(dw_2.GetItemString(1,"depot"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF
IF sdepot = "" OR IsNull(sdepot) THEN
	sdepot ='%'
END IF


IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, sdepot, sDatef, sDatet) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_2.SetColumn(1)
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_itmcyc_popup
integer x = 2802
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun = dw_1.GetItemString(ll_Row, "depot")  
gs_code  = dw_1.GetItemString(ll_Row, "sicdat")  
gs_codename  = string(dw_1.GetItemNumber(ll_Row, "siseq"))  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmcyc_popup
integer x = 46
integer y = 160
integer width = 3086
integer height = 1504
string dataobject = "d_itmcyc_popup1"
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

gs_gubun = dw_1.GetItemString(Row, "depot")  
gs_code  = dw_1.GetItemString(Row, "sicdat")  
gs_codename  = string(dw_1.GetItemNumber(Row, "siseq"))  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itmcyc_popup
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmcyc_popup
integer x = 2249
end type

type cb_return from w_inherite_popup`cb_return within w_itmcyc_popup
integer x = 2871
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmcyc_popup
integer x = 2560
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmcyc_popup
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itmcyc_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_itmcyc_popup
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 8
integer width = 2144
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_itmcyc_popup"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		RETURN 1
	End If
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "vndcod" THEN
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "vndcod", gs_Code)
	this.SetItem(1, "vndnm", gs_Codename)
//	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
END IF
end event

type cb_2 from commandbutton within w_itmcyc_popup
boolean visible = false
integer x = 2130
integer y = 4
integer width = 242
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "실사취소"
end type

event clicked;Long    ll_rowcnt, ll_cnt
ll_rowcnt = dw_1.RowCount()
If ll_rowcnt < 1 Then Return

IF Messagebox('확 인','취소 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN

Integer i
Integer iseq, lRtnValue
String  s_date, s_depot, s_crdate, s_cycsts

SetPointer(HourGlass!)
For i = 1 To ll_rowcnt
	dw_1.ScrollToRow(i)
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(i,True)

	s_cycsts = dw_1.GetItemString(i, 'cycsts')
	s_depot  = dw_1.GetItemString(i, 'depot')
	s_crdate = trim(dw_1.GetItemString(i, 'sicdat'))
	s_date   = trim(dw_1.GetItemString(i, 'wandat'))
	iseq     = dw_1.GetItemNumber(i, 'siseq')
	
	if s_cycsts <> '2' then continue
//		SetPointer(Arrow!)
//		messagebox("확인", "완료취소 처리를 할 수 없는 자료입니다.")
//		return 
//	end if
	
	if isnull(s_depot) or s_depot = "" then
		SetPointer(Arrow!)
		f_message_chk(30,'[창고]')
		dw_1.SetColumn('depot')
		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_crdate) or s_crdate = "" then
		SetPointer(Arrow!)
		f_message_chk(30,'[생성일자]')
		dw_1.SetColumn('sicdat')
		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_date) or s_date = "" then
		SetPointer(Arrow!)
		f_message_chk(30,'[완료일자]')
		dw_1.SetColumn('wandat')
		dw_1.SetFocus()
		return
	end if
	
	lRtnValue = sqlca.erp000000210_1(gs_sabu, s_depot, s_crdate, iseq)
	IF lRtnValue < 0 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(32,'[완료 취소실패] ' + string(lRtnValue) )
		Return
	Else
		commit using sqlca;
	end if	

	dw_1.setitem(i, "cycsts", "1")
	dw_1.setitem(i, "wandat", "")
//	IF messagebox("확인", "실사완료 취소를 계속 진행하시겠습니까?", Question!, YesNo!, 1) = 2 THEN
//		SetPointer(Arrow!)
//		Return
//	END IF
Next

SetPointer(Arrow!)
messagebox("확인", "주기실사 완료취소 처리되었습니다.")

end event

type cb_3 from commandbutton within w_itmcyc_popup
boolean visible = false
integer x = 2377
integer y = 4
integer width = 247
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "실사완료"
end type

event clicked;Long    ll_cnt
ll_cnt = dw_1.RowCount()
If ll_cnt < 1 Then Return

IF Messagebox('확 인','완료 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN

Integer i, j
Integer iseq, lRtnValue, iMaxOrderNo
String  s_date, s_depot, s_crdate, s_cycsts, sjpno, s_yymm, s_pyymm

SetPointer(HourGlass!)
For i = 1 To ll_cnt
	dw_1.ScrollToRow(i)
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(i,True)

	s_cycsts = dw_1.GetItemString(i, 'cycsts')
	s_depot  = dw_1.GetItemString(i, 'depot')
	s_crdate = trim(dw_1.GetItemString(i, 'sicdat'))
	s_date   = trim(dw_1.GetItemString(i, 'wandat'))
	iseq     = dw_1.GetItemNumber(i, 'siseq')

	if s_cycsts <> '1' then continue
//		SetPointer(Arrow!)
//		messagebox("확인", "실사완료처리를 할 수 없는 자료입니다.")
//		return 
//	end if
	
	if isnull(s_depot) or s_depot = "" then
		SetPointer(Arrow!)
		f_message_chk(30,'[창고]')
		dw_1.SetColumn('depot')
		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_crdate) or s_crdate = "" then
		SetPointer(Arrow!)
		f_message_chk(30,'[생성일자]')
		dw_1.SetColumn('sicdat')
		dw_1.SetFocus()
		return
	end if
	
	if isnull(iseq) or iseq = 0 then
		SetPointer(Arrow!)
		f_message_chk(30,'[순번]')
		dw_1.SetColumn('siseq')
		dw_1.SetFocus()
		return
	end if
	
	s_date = f_last_date(s_crdate)
	
	// 수불마감 처리(수동처리)를 위해 리턴
	s_yymm = Left(s_date, 6)
	if s_pyymm > '.' and s_pyymm <> s_yymm then
		Return
	end if
	
	iMaxOrderNo = sqlca.fun_junpyo(gs_sabu, s_Date, 'C0')
	IF iMaxOrderNo <= 0 THEN
	   w_mdi_frame.sle_msg.text = ""
		f_message_chk(51,'')
		ROLLBACK;
	END IF
	Commit;
	sjpno = s_Date + String(iMaxOrderNo,'0000')
	
	
	w_mdi_frame.sle_msg.text = "실사 차이에 의한 전표 생성 中 ........."
	
	lRtnValue = sqlca.erp000000210(gs_sabu, s_depot, s_crdate, iseq, s_date, sjpno)	
	IF lRtnValue = -1 THEN	
		SetPointer(Arrow!)
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[전표생성 실패]')
		Return
	ELSEIF lRtnValue = -3 THEN	
		SetPointer(Arrow!)
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(32,'[완료처리 실패]')
		Return
	ELSEIF lRtnValue = -9 THEN	
		SetPointer(Arrow!)
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[작업 실패]')
		Return
	ELSEIF lRtnValue = -6 THEN	
		SetPointer(Arrow!)
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[갱신 실패]')
		Return
	END IF	
	commit;
	
	dw_1.setitem(i, "cycsts", "2")
	dw_1.setitem(i, "wandat", s_Date)
//	IF messagebox("확인", "실사완료를 계속 진행하시겠습니까?", Question!, YesNo!, 1) = 2 THEN
//		SetPointer(Arrow!)
//		Return
//	END IF
	
	s_pyymm = s_yymm
Next
	
SetPointer(Arrow!)
messagebox("확인", "주기실사 완료 처리되었습니다.")
end event

type cb_4 from commandbutton within w_itmcyc_popup
boolean visible = false
integer x = 2185
integer y = 88
integer width = 402
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미완료필터"
end type

event clicked;//dw_1.SetFilter("if ( isnull(wandat), '.', wandat ) = '.'")
//dw_1.Filter()
dw_1.SetFilter("jego_gub = '2'")
dw_1.Filter()
end event

type rr_1 from roundrectangle within w_itmcyc_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 156
integer width = 3109
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

