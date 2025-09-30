$PBExportHeader$w_sorder_popup.srw
$PBExportComments$수주 관리 : 수주 내역 조회 선택
forward
global type w_sorder_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sorder_popup
end type
type cbx_1 from checkbox within w_sorder_popup
end type
type pb_1 from u_pb_cal within w_sorder_popup
end type
type pb_2 from u_pb_cal within w_sorder_popup
end type
type rr_2 from roundrectangle within w_sorder_popup
end type
end forward

global type w_sorder_popup from w_inherite_popup
integer x = 160
integer y = 124
integer width = 3415
integer height = 2332
rr_1 rr_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_sorder_popup w_sorder_popup

type variables
String sOrderGbn
end variables

on w_sorder_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_2
end on

on w_sorder_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;String sDatef, sDateT

sOrderGbn = Message.StringParm

dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

select to_char(sysdate,'yyyymmdd'),to_char(sysdate-7,'yyyymmdd')
  into :sDateT, :sDateF
  from dual;

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If

dw_jogun.SetItem(1, 'sarea', sarea)
dw_jogun.SetItem(1,'fr_date',sDatef)
dw_jogun.SetItem(1,'to_date',sDatet)

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')


/* 판매출고 */
IF sOrderGbn = '1' THEN
	this.Title = '수주내역 조회 선택'
	dw_jogun.Modify("fr_date_t.text = '수주기간'")
	
	dw_1.DataObject = 'd_sorder_popup2'
ELSEIF sOrderGbn = '2' THEN
/* 무상출고 */
	this.Title = '무상출고 의뢰내역 조회 선택'
	dw_jogun.Modify("fr_date_t.text = '출고의뢰'")
	
	dw_1.DataObject = 'd_sorder_popup3'
/* 부서수주출고 */
ELSEIF sOrderGbn = '3' THEN	
	this.Title = '부서수주출고 의뢰내역 조회 선택'
	dw_jogun.Modify("fr_date_t.text = '출고의뢰'")
	
	dw_1.DataObject = 'd_sorder_popup4'
END IF

dw_1.SetTransObject(SQLCA)
p_inq.TriggerEvent(Clicked!)	

dw_jogun.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sorder_popup
integer y = 180
integer width = 3163
integer height = 236
string dataobject = "d_sorder_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sNull, sItnbr, sItdsc, sIspec, sIspecCode, sJijil
Int    iReturn
long   lcount

SetNull(snull)
SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "fr_date"
		IF f_datechk(trim(gettext())) = -1	then
			SetItem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(gettext())) = -1	then
			SetItem(1, "to_date", sNull)
			return 1
		END IF
	Case "sarea"
		SetItem(1,"vndcod",sNull)
		SetItem(1,"vndnm",sNull)
	/* 거래선 */
	Case "vndcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'vndcod', sNull)
			SetItem(1, 'vndnm', snull)
			Return 1
		ELSE		
			SetItem(1,"vndnm", scvnas)
			SetItem(1,"sarea",   sarea)
		END IF

		cb_inq.PostEvent(Clicked!)
	/* 거래선명 */
	Case "vndnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"vndcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'vndcod', sNull)
			SetItem(1, 'vndnm', snull)
			Return 1
		ELSE
			SetItem(1,'vndcod', sCvcod)
			SetItem(1,"vndnm",  scvnas)
			SetItem(1,"sarea",   sarea)
		END IF
		
		cb_inq.PostEvent(Clicked!)
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "vndcod", "vndnm"
		gs_gubun = '1'
		If GetColumnName() = "vndnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"vndcod",gs_code)
		SetColumn("vndcod")
		TriggerEvent(ItemChanged!)		
	Case "itnbr"
		gs_code = GetText()
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then 
			return
		end if
		SetItem(1, "itnbr", gs_code)
		SetItem(1, "itdsc", gs_codename)
		SetItem(1, "ispec", gs_gubun)
END Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sorder_popup
integer x = 3195
integer y = 12
integer taborder = 60
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sorder_popup
integer x = 2848
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sbuyer,sdatef,sdatet, sitnbr, sarea, sSts, sSaupj
String sItdsc, sIspec, sJijil, sPspec, sIspecCode

If dw_jogun.AcceptText() <> 1 Then Return -1

sarea  = dw_jogun.GetItemString(1,"sarea")
sbuyer = dw_jogun.GetItemString(1,"vndcod")
sitnbr = dw_jogun.GetItemString(1,"itnbr")
sdatef = dw_jogun.GetItemString(1,"fr_date")
sdatet = dw_jogun.GetItemString(1,"to_date")
sSaupj = dw_jogun.GetItemString(1,"saupj")

sItdsc	= Trim(dw_jogun.GetItemString(1,"itdsc"))
sIspec	= Trim(dw_jogun.GetItemString(1,"ispec"))
sJijil	= Trim(dw_jogun.GetItemString(1,"jijil"))
sPspec	= Trim(dw_jogun.GetItemString(1,"order_spec"))
sIspecCode = Trim(dw_jogun.GetItemString(1,"ispec_code"))

If IsNull(sItdsc) Then sItdsc = ''
If IsNull(sIspec) Then sIspec = ''
If IsNull(sJijil) Then sJijil = ''
If IsNull(sPspec) Then sPspec = ''
If IsNull(sIspecCode) Then sIspecCode = ''

If cbx_1.Checked Then
	sSts = '8' 
Else
	sSts = '4'
End If

IF sbuyer ="" OR IsNull(sbuyer) THEN	sbuyer = ''

IF sitnbr ="" OR IsNull(sitnbr) THEN	sitnbr = ''

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='00000000'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sarea = '' Or IsNull(sarea) THEN	sarea = ''

IF sdatet < sdatef THEN
	f_message_chk(34,'[수주일자]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SetRedraw(False)
IF sOrderGbn = '1' then									/*출고구분 = O02(판매출고)*/
	IF dw_1.Retrieve(gs_sabu,sSaupj, sarea+'%',sbuyer+'%',sitnbr+'%',sdatef, sdatet, sSts, sItdsc+'%', sIspec+'%', sJijil+'%', sPspec+'%', sIspecCode+'%') <= 0 THEN
		f_message_chk(50,'')
		dw_jogun.SetColumn("vndcod")
		dw_jogun.SetFocus()
		Return
	END IF
ELSE
	/* 출고의뢰 'O18', 'O19','O17','O12','O08','O05', 'O10' (무상출고)*/
   IF dw_1.Retrieve(gs_sabu, sSaupj, sbuyer+'%',sitnbr+'%', sdatef, sdatet, sSts, sItdsc+'%', sIspec+'%', sJijil+'%', sPspec+'%', sIspecCode+'%') <= 0 THEN
	  f_message_chk(50,'')
	  dw_jogun.SetColumn("vndcod")
	  dw_jogun.SetFocus()
	  Return
   END IF
END IF

dw_1.SetRedraw(True)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sorder_popup
integer x = 3022
integer y = 12
integer taborder = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "order_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sorder_popup
integer y = 448
integer width = 3346
integer height = 1748
integer taborder = 30
string dataobject = "d_sorder_popup2"
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

gs_code= dw_1.GetItemString(Row, "order_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sorder_popup
boolean visible = false
integer x = 969
integer y = 2364
integer width = 1001
textcase textcase = anycase!
end type

type cb_1 from w_inherite_popup`cb_1 within w_sorder_popup
integer x = 827
integer y = 2516
end type

type cb_return from w_inherite_popup`cb_return within w_sorder_popup
integer x = 1477
integer y = 2516
end type

type cb_inq from w_inherite_popup`cb_inq within w_sorder_popup
integer x = 1152
integer y = 2516
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sorder_popup
boolean visible = false
integer x = 539
integer y = 2348
integer width = 425
textcase textcase = anycase!
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_sorder_popup
boolean visible = false
integer x = 270
integer y = 2368
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_sorder_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 9
integer y = 172
integer width = 3369
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_1 from checkbox within w_sorder_popup
integer x = 2190
integer y = 84
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "완료제외"
end type

type pb_1 from u_pb_cal within w_sorder_popup
integer x = 695
integer y = 212
integer height = 72
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('fr_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'fr_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sorder_popup
integer x = 1147
integer y = 208
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('to_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'to_date', gs_code)

end event

type rr_2 from roundrectangle within w_sorder_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 440
integer width = 3369
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

