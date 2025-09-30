$PBExportHeader$w_estima_popup.srw
$PBExportComments$** 구매상태별 조회 선택
forward
global type w_estima_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_estima_popup
end type
type pb_2 from u_pb_cal within w_estima_popup
end type
type rb_1 from radiobutton within w_estima_popup
end type
type rb_2 from radiobutton within w_estima_popup
end type
type rr_1 from roundrectangle within w_estima_popup
end type
end forward

global type w_estima_popup from w_inherite_popup
integer x = 37
integer y = 172
integer width = 3726
integer height = 1820
string title = "구매상태별 조회 선택"
pb_1 pb_1
pb_2 pb_2
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_estima_popup w_estima_popup

on w_estima_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_estima_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

if gs_gubun = "" or isnull(gs_gubun) then gs_gubun = '1'    //1: 의뢰

dw_jogun.setitem(1, 'sgub', gs_gubun )

IF gs_code = '외주' THEN 
	dw_jogun.setitem(1, 'sgubun', '3' )
ELSEIF gs_code = '생산' THEN 	
	dw_jogun.setitem(1, 'sgubun', '1' )
END IF	

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_estima_popup
integer x = 23
integer y = 16
integer width = 3122
integer height = 132
string dataobject = "d_estima_popup"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull

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

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
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

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_estima_popup
integer x = 3511
integer y = 0
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_estima_popup
integer x = 3163
integer y = 0
end type

event p_inq::clicked;call super::clicked;
String sdatef,sdatet, sblynd, sgubun

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))
sblynd = dw_jogun.GetItemString(1,"sgub")
sgubun = dw_jogun.GetItemString(1,"sgubun")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sgubun = "" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, gs_saupj, sdatef,sdatet,sblynd, sgubun) <= 0 THEN
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

type p_choose from w_inherite_popup`p_choose within w_estima_popup
integer x = 3337
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "estno")
gs_codename = dw_1.GetItemString(ll_Row, "blynd")  //발주구분

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_estima_popup
integer x = 37
integer y = 180
integer width = 3653
integer height = 1536
string dataobject = "d_estima_popup1"
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

gs_code= dw_1.GetItemString(Row, "estno")  //구매의뢰번호
gs_codename = dw_1.GetItemString(Row, "blynd")  //발주구분

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_estima_popup
boolean visible = false
integer x = 992
integer y = 2048
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_estima_popup
integer x = 329
integer y = 2088
end type

type cb_return from w_inherite_popup`cb_return within w_estima_popup
integer x = 951
integer y = 2088
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_estima_popup
integer x = 640
integer y = 2088
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_estima_popup
boolean visible = false
integer x = 329
integer y = 2048
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_estima_popup
boolean visible = false
integer x = 59
integer y = 2068
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_estima_popup
integer x = 544
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_estima_popup
integer x = 992
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('TO_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rb_1 from radiobutton within w_estima_popup
integer x = 2551
integer y = 48
integer width = 247
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "요약"
boolean checked = true
end type

event clicked;dw_1.dataobject = 'd_estima_popup1'

dw_1.settransobject(sqlca)
end event

type rb_2 from radiobutton within w_estima_popup
integer x = 2789
integer y = 48
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "상세"
end type

event clicked;dw_1.dataobject = 'd_estima_popup2'

dw_1.settransobject(sqlca)
end event

type rr_1 from roundrectangle within w_estima_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 172
integer width = 3666
integer height = 1552
integer cornerheight = 40
integer cornerwidth = 55
end type

