$PBExportHeader$w_poblkt_popup3.srw
$PBExportComments$** 발주품목정보 조회 선택(외자 일괄선택)
forward
global type w_poblkt_popup3 from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_poblkt_popup3
end type
type pb_2 from u_pb_cal within w_poblkt_popup3
end type
type rr_1 from roundrectangle within w_poblkt_popup3
end type
end forward

global type w_poblkt_popup3 from w_inherite_popup
integer x = 82
integer y = 160
integer width = 3442
integer height = 2040
string title = "발주품목정보 조회 일괄선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_poblkt_popup3 w_poblkt_popup3

on w_poblkt_popup3.create
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

on w_poblkt_popup3.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

//if gs_gubun = "" or isnull(gs_gubun) then gs_gubun = '1'    

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)

///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

if sCnvgu = 'Y' then // 발주단위 사용시
	dw_1.dataobject = 'd_poblkt_popup3_3'
Else						// 발주단위 사용안함
	dw_1.dataobject = 'd_poblkt_popup3'	
End if

dw_1.SetTransObject(sqlca)

dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_poblkt_popup3
integer x = 23
integer y = 32
integer width = 2775
integer height = 140
string dataobject = "d_poblkt_popup3_1"
end type

type p_exit from w_inherite_popup`p_exit within w_poblkt_popup3
integer x = 3214
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_poblkt_popup3
integer x = 2866
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sempno

dw_jogun.AcceptText()

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))
sempno = dw_jogun.GetItemString(1,"sempno")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sempno ="" OR IsNull(sempno) THEN
	sempno ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet,sempno) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_poblkt_popup3
integer x = 3040
integer y = 16
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_poblkt_popup3
integer x = 37
integer y = 192
integer width = 3355
integer height = 1736
string dataobject = "d_poblkt_popup3"
boolean hscrollbar = true
end type

event dw_1::clicked;call super::clicked;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_poblkt_popup3
boolean visible = false
integer x = 1175
integer y = 2088
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_poblkt_popup3
integer x = 1371
integer y = 2044
end type

type cb_return from w_inherite_popup`cb_return within w_poblkt_popup3
integer x = 1993
integer y = 2044
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_poblkt_popup3
integer x = 1682
integer y = 2044
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_poblkt_popup3
boolean visible = false
integer x = 512
integer y = 2088
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_poblkt_popup3
boolean visible = false
integer x = 242
integer y = 2108
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_poblkt_popup3
integer x = 672
integer y = 64
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_poblkt_popup3
integer x = 1115
integer y = 64
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_poblkt_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 188
integer width = 3378
integer height = 1748
integer cornerheight = 40
integer cornerwidth = 55
end type

