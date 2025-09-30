$PBExportHeader$w_imhist_02050_popup.srw
$PBExportComments$출고송장 조회 선택(반품출고송장)
forward
global type w_imhist_02050_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_imhist_02050_popup
end type
type rb_1 from radiobutton within w_imhist_02050_popup
end type
type rb_2 from radiobutton within w_imhist_02050_popup
end type
type rb_3 from radiobutton within w_imhist_02050_popup
end type
type pb_2 from u_pb_cal within w_imhist_02050_popup
end type
type pb_1 from u_pb_cal within w_imhist_02050_popup
end type
type gb_1 from groupbox within w_imhist_02050_popup
end type
type rr_1 from roundrectangle within w_imhist_02050_popup
end type
end forward

global type w_imhist_02050_popup from w_inherite_popup
integer x = 5
integer y = 272
integer width = 3552
integer height = 2064
string title = "출고송장 조회 선택"
dw_2 dw_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
pb_2 pb_2
pb_1 pb_1
gb_1 gb_1
rr_1 rr_1
end type
global w_imhist_02050_popup w_imhist_02050_popup

type variables
string isJuncrt1, isJuncrt2, is_saupj
end variables

on w_imhist_02050_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_1
end on

on w_imhist_02050_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;/* 반품의뢰등록시 출고송장 조회popup : 전표생성구분이 송장(004) 인것만 조회 */
/* gs_code     : 송장번호    */
/* gs_gubun    : 거래처      */
/* gs_codename : 부가사업장  */
String sCvcodnm

is_saupj = gs_codename

dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_2.Modify("sarea.protect=1")
	dw_2.Modify("sarea.background.color = 80859087")
End If

SELECT SAREA, CVNAS2 Into :sArea, :sCvcodNm
  FROM VNDMST
 WHERE CVCOD = :gs_gubun;

dw_2.SetItem(1, 'sarea', 	sArea)
dw_2.SetItem(1, 'cvcod', 	gs_gubun) 
dw_2.setitem(1, 'cvcodnm', sCvcodNm)
dw_2.SetItem(1, 'iojpno',gs_code)

dw_2.setitem(1, 'fr_date', f_afterday(f_today(),-20 ))
dw_2.setitem(1, 'to_date', f_today())
dw_2.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhist_02050_popup
boolean visible = false
integer x = 73
integer y = 204
integer width = 1787
integer height = 152
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_imhist_02050_popup
integer x = 3323
end type

event p_exit::clicked;call super::clicked;cb_return.TriggerEvent(Clicked!)
end event

type p_inq from w_inherite_popup`p_inq within w_imhist_02050_popup
integer x = 2976
end type

event p_inq::clicked;call super::clicked;cb_inq.TriggerEvent(Clicked!)
end event

type p_choose from w_inherite_popup`p_choose within w_imhist_02050_popup
integer x = 3150
end type

event p_choose::clicked;call super::clicked;cb_1.TriggerEvent(Clicked!)
end event

type dw_1 from w_inherite_popup`dw_1 within w_imhist_02050_popup
integer x = 37
integer y = 436
integer width = 3451
integer height = 1464
string dataobject = "d_imhist_02050_popup"
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

gs_code     = dw_1.GetItemString(Row, "iojpno")
gs_codename = String(dw_1.GetItemNumber(Row, "ioprc"))    /* 단가 */
gs_gubun    = String(dw_1.GetItemNumber(Row, "ioreqty"))  /* 수량 */

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_imhist_02050_popup
boolean visible = false
integer x = 1015
integer y = 176
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhist_02050_popup
integer x = 3209
integer y = 2172
end type

event cb_1::clicked;Long row

row = dw_1.GetSelectedRow(0)

IF row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(row, "iojpno")
gs_codename = String(dw_1.GetItemNumber(Row, "ioprc"))    /* 단가 */
gs_gubun    = String(dw_1.GetItemNumber(Row, "ioreqty"))  /* 수량 */

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_imhist_02050_popup
integer x = 3209
integer y = 2172
integer taborder = 40
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_imhist_02050_popup
integer x = 3209
integer y = 2172
integer taborder = 20
boolean default = false
end type

event cb_inq::clicked;String sdatef,sdatet,sarea,scvcod,sItnbr,sIojpno
String sItdsc, sIspec, sJijil, sIspeccode

If dw_2.AcceptText() <> 1 Then Return 1

sdatef   = dw_2.GetItemString(1,"fr_date")
sdatet   = dw_2.GetItemString(1,"to_date")
sarea    = Trim(dw_2.GetItemString(1,"sarea"))
scvcod   = Trim(dw_2.GetItemString(1,"cvcod"))
sItnbr   = Trim(dw_2.GetItemString(1,"itnbr"))
sIojpno  = Trim(dw_2.GetItemString(1,"iojpno"))

sItdsc	= Trim(dw_2.GetItemString(1,"itdsc"))
sIspec	= Trim(dw_2.GetItemString(1,"ispec"))
sJijil	= Trim(dw_2.GetItemString(1,"jijil"))
sIspeccode = Trim(dw_2.GetItemString(1,"ispec_code"))
If IsNull(sItdsc) Then sItdsc = ''
If IsNull(sIspec) Then sIspec = ''
If IsNull(sJijil) Then sJijil = ''
If IsNull(sIspeccode) Then sIspeccode = ''

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

If sItnbr = '' Or IsNull(sItnbr) Then 	sItnbr = ''
IF sarea =  '' OR IsNull(sarea)  THEN  sarea =''
IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''
IF sIojpno = "" OR IsNull(sIojpno) THEN sIojpno =''

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet,sarea+'%',scvcod+'%',sitnbr+'%',sIojpno+'%', is_saupj, sItdsc+'%', sIspec+'%', sJijil+'%', sIspecCode+'%') <= 0 THEN
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type sle_1 from w_inherite_popup`sle_1 within w_imhist_02050_popup
boolean visible = false
integer x = 352
integer y = 152
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imhist_02050_popup
boolean visible = false
integer x = 82
integer y = 172
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_imhist_02050_popup
event ue_processenter pbm_dwnprocessenter
integer x = 9
integer y = 168
integer width = 3497
integer height = 256
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imhist_02050_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull,sItnbr, sItdsc, sIspec, sJijil, sgub, sispeccode
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow, ireturn

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case "fr_date"
		IF f_datechk(trim(gettext())) = -1	then
			setitem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(gettext())) = -1	then
			setitem(1, "to_date", sNull)
			return 1
		END IF
	/* 관할구역 */
	Case 'sarea'
		SetItem(nRow,'cvcod',sNull)
		SetItem(nRow,'cvcodnm',sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		sName1 = '2'	/*수출 */
		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvcodnm", snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		sName1 = '2'	/*수출 */
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvcodnm", snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcod", sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event itemerror;RETURN 1
end event

event rbuttondown;String sArea
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return 

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	Case "itnbr"
	 gs_gubun = '1'
	 Open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)	 
  Case "itdsc"
 	 gs_gubun = '1'
	 gs_codename = this.GetText()
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
  Case "ispec", "jijil"
	 gs_gubun = '1'
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
End Choose

end event

type rb_1 from radiobutton within w_imhist_02050_popup
integer x = 73
integer y = 52
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;dw_1.SetFilter("")
dw_1.Filter()
end event

type rb_2 from radiobutton within w_imhist_02050_popup
integer x = 366
integer y = 52
integer width = 521
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "계산서 발행"
end type

event clicked;dw_1.SetFilter("Not(IsNull(imhist_checkno))")
dw_1.Filter()
end event

type rb_3 from radiobutton within w_imhist_02050_popup
integer x = 873
integer y = 52
integer width = 512
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "계산서 미발행"
end type

event clicked;dw_1.SetFilter("IsNull(imhist_checkno)")
dw_1.Filter()
end event

type pb_2 from u_pb_cal within w_imhist_02050_popup
integer x = 640
integer y = 200
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('fr_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'fr_date', gs_code)

end event

type pb_1 from u_pb_cal within w_imhist_02050_popup
integer x = 1097
integer y = 200
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('to_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'to_date', gs_code)

end event

type gb_1 from groupbox within w_imhist_02050_popup
integer x = 37
integer width = 1399
integer height = 144
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_imhist_02050_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 432
integer width = 3470
integer height = 1472
integer cornerheight = 40
integer cornerwidth = 55
end type

