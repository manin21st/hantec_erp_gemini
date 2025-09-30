$PBExportHeader$w_poblkt_popup.srw
$PBExportComments$** 발주품목정보 조회 선택
forward
global type w_poblkt_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_poblkt_popup
end type
type pb_2 from u_pb_cal within w_poblkt_popup
end type
type rb_1 from radiobutton within w_poblkt_popup
end type
type rb_2 from radiobutton within w_poblkt_popup
end type
type rr_1 from roundrectangle within w_poblkt_popup
end type
end forward

global type w_poblkt_popup from w_inherite_popup
integer x = 46
integer y = 160
integer width = 3529
integer height = 2092
string title = "발주품목정보 조회 선택"
pb_1 pb_1
pb_2 pb_2
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_poblkt_popup w_poblkt_popup

type variables

end variables

on w_poblkt_popup.create
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

on w_poblkt_popup.destroy
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

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())

IF gs_code = '3' then 
	dw_jogun.setitem(1, 'gubun', gs_code)
END IF

// mro인 경우
IF gs_code = '9' then 
	dw_jogun.setitem(1, 'gubun', gs_code)
	dw_jogun.SetTabOrder('gubun', 0)
END IF

dw_jogun.SetFocus()

///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if
//
//if sCnvgu = 'Y' then // 발주단위 사용시
//	dw_1.dataobject = 'd_poblkt_popup1_1'
//Else						// 발주단위 사용안함
//	dw_1.dataobject = 'd_poblkt_popup12'	
//End if
//
dw_1.SetTransObject(sqlca)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


// 부가세 사업장 설정
//f_mod_saupj(dw_jogun, 'saupj')
dw_jogun.SetItem(1, 'saupj', gs_saupj)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_poblkt_popup
integer x = 23
integer y = 164
integer width = 3497
integer height = 192
string dataobject = "d_poblkt_popup"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;IF this.GetColumnName() = 'cvcod'	THEN
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas", gs_codename)
	
ELSEIF this.GetColumnName() = 'itnbr'	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
END IF
end event

type p_exit from w_inherite_popup`p_exit within w_poblkt_popup
integer x = 3291
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_poblkt_popup
integer x = 2944
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sempno, sgubun, sbalsts, scvcod, sitnbr, sno, ssaupj

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef 	= TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet 	= TRIM(dw_jogun.GetItemString(1,"to_date"))
sempno 	= dw_jogun.GetItemString(1,"sempno")
sgubun 	= dw_jogun.GetItemString(1,"gubun")
sbalsts 	= dw_jogun.GetItemString(1,"balsts")
scvcod 	= dw_jogun.GetItemString(1,"cvcod")
sitnbr 		= dw_jogun.GetItemString(1,"itnbr")
ssaupj 		= dw_jogun.GetItemString(1,"saupj")

IF 	sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF 	sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF 	sempno ="" OR IsNull(sempno) THEN
	sempno ='%'
END IF

IF 	sgubun ="" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF 	sbalsts ="" OR IsNull(sbalsts) THEN
	sbalsts ='%'
END IF

IF 	scvcod ="" OR IsNull(scvcod) THEN
	scvcod ='%'
END IF

IF 	sitnbr ="" OR IsNull(sitnbr) THEN
	sitnbr ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF


if gs_gubun = 'I03' then
	dw_1.setfilter("pomast_plncrt <> '1'")		
	dw_1.filter()
end if	


IF dw_1.Retrieve(gs_sabu,ssaupj, sdatef,sdatet,sempno, sgubun,sbalsts,sitnbr, scvcod) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_poblkt_popup
integer x = 3118
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= Left(dw_1.GetItemString(ll_Row, "baljpno"),12)
If rb_2.Checked Then 
	gs_codename= string(dw_1.GetItemNumber(ll_Row, "poblkt_balseq"))
Else
	Setnull(gs_codename)
End If

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_poblkt_popup
integer x = 37
integer y = 372
integer width = 3447
integer height = 1600
string dataobject = "d_poblkt_popup12"
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

gs_code= Left(dw_1.GetItemString(Row, "baljpno"),12)
If rb_2.Checked Then
	gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
Else
	SetNull(gs_codename)
End If

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_poblkt_popup
boolean visible = false
integer x = 1038
integer y = 2044
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_poblkt_popup
integer x = 1170
integer y = 2052
end type

type cb_return from w_inherite_popup`cb_return within w_poblkt_popup
integer x = 1792
integer y = 2052
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_poblkt_popup
integer x = 1481
integer y = 2052
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_poblkt_popup
boolean visible = false
integer x = 375
integer y = 2044
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_poblkt_popup
boolean visible = false
integer x = 105
integer y = 2064
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_poblkt_popup
integer x = 613
integer y = 188
integer width = 101
integer height = 80
integer taborder = 20
boolean bringtotop = true
boolean originalsize = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_poblkt_popup
integer x = 1061
integer y = 188
integer width = 101
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rb_1 from radiobutton within w_poblkt_popup
integer x = 2894
integer y = 268
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

event clicked;dw_1.dataobject = 'd_poblkt_popup12'

dw_1.settransobject(sqlca)
end event

type rb_2 from radiobutton within w_poblkt_popup
integer x = 3159
integer y = 268
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

event clicked;dw_1.dataobject = 'd_poblkt_popup1'

dw_1.settransobject(sqlca)
end event

type rr_1 from roundrectangle within w_poblkt_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 368
integer width = 3470
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

