$PBExportHeader$w_sys_02000.srw
$PBExportComments$** 공정 LOT 검색
forward
global type w_sys_02000 from w_inherite
end type
type st_7 from statictext within w_sys_02000
end type
type st_2 from statictext within w_sys_02000
end type
type st_3 from statictext within w_sys_02000
end type
type st_4 from statictext within w_sys_02000
end type
type st_5 from statictext within w_sys_02000
end type
type st_6 from statictext within w_sys_02000
end type
type st_8 from statictext within w_sys_02000
end type
type st_9 from statictext within w_sys_02000
end type
type st_10 from statictext within w_sys_02000
end type
type st_11 from statictext within w_sys_02000
end type
type cb_1 from commandbutton within w_sys_02000
end type
type dw_1 from u_key_enter within w_sys_02000
end type
type gb_1 from groupbox within w_sys_02000
end type
type gb_3 from groupbox within w_sys_02000
end type
type r_1 from rectangle within w_sys_02000
end type
type dw_list from datawindow within w_sys_02000
end type
type pb_1 from u_pb_cal within w_sys_02000
end type
type pb_2 from u_pb_cal within w_sys_02000
end type
type rr_1 from roundrectangle within w_sys_02000
end type
type dw_2 from u_d_select_sort within w_sys_02000
end type
end forward

global type w_sys_02000 from w_inherite
string title = "공정 LOT 현황"
st_7 st_7
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_8 st_8
st_9 st_9
st_10 st_10
st_11 st_11
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
gb_3 gb_3
r_1 r_1
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
dw_2 dw_2
end type
global w_sys_02000 w_sys_02000

type variables
String	isMayymm
end variables

on w_sys_02000.create
int iCurrent
call super::create
this.st_7=create st_7
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.gb_3=create gb_3
this.r_1=create r_1
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.st_8
this.Control[iCurrent+8]=this.st_9
this.Control[iCurrent+9]=this.st_10
this.Control[iCurrent+10]=this.st_11
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.r_1
this.Control[iCurrent+16]=this.dw_list
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.pb_2
this.Control[iCurrent+19]=this.rr_1
this.Control[iCurrent+20]=this.dw_2
end on

on w_sys_02000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.r_1)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.dw_2)
end on

event open;call super::open;gs_saupj = '1'

SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
  INTO :isMayymm
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_saupj ) AND  
       ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;
 
dw_list.SetTransObject(sqlca)

dw_1.InsertRow(0)
dw_1.SetItem(1,'frdate',Left(is_today,6)+'01')
dw_1.SetItem(1,'todate',is_today)

dw_1.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_sys_02000
boolean visible = false
integer x = 165
integer y = 2400
integer width = 320
integer height = 124
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", left(f_today(), 6))
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sys_02000
boolean visible = false
integer x = 4064
integer y = 192
end type

type p_addrow from w_inherite`p_addrow within w_sys_02000
boolean visible = false
integer x = 3890
integer y = 192
end type

type p_search from w_inherite`p_search within w_sys_02000
boolean visible = false
integer x = 3035
integer y = 192
end type

type p_ins from w_inherite`p_ins within w_sys_02000
boolean visible = false
integer x = 3717
integer y = 192
end type

type p_exit from w_inherite`p_exit within w_sys_02000
end type

type p_can from w_inherite`p_can within w_sys_02000
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_2.ReSet()
dw_list.ReSet()

dw_1.InsertRow(0)
dw_1.SetItem(1,'frdate',Left(is_today,6)+'01')
dw_1.SetItem(1,'todate',is_today)

dw_list.Visible = False
dw_2.Visible = True

cb_print.Enabled = False
		
sle_msg.Text = ''
dw_1.SetFocus()

end event

type p_print from w_inherite`p_print within w_sys_02000
integer x = 4087
end type

event p_print::clicked;call super::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_inq from w_inherite`p_inq within w_sys_02000
integer x = 3909
end type

event p_inq::clicked;call super::clicked;String	sGubun, sFrDate, sToDate, sFrLotNo, sToLotNo

//dw_list.Visible = False
dw_2.Visible = True
SetPointer(HourGlass!)

if dw_1.AcceptText() = -1 then return -1

sGubun   = dw_1.GetItemString(1,"gubun")
sFrDate  = dw_1.GetItemString(1,"frdate")
sToDate  = dw_1.GetItemString(1,"todate")
sFrLotNo = dw_1.GetItemString(1,"frlotno")
sToLotNo = dw_1.GetItemString(1,"tolotno")

if IsNull(sFrDate) or sFrDate = '' then sFrDate = '10000101'
if IsNull(sToDate) or sToDate = '' then sToDate = '99999999'
if IsNull(sFrLotNo) or sFrLotNo = '' then sFrLotNo = '.'
if IsNull(sToLotNo) or sToLotNo = '' then sToLotNo = 'zzzzzzzzzzzzzzzzzzzz'

if sGubun = '1' then
	dw_2.DataObject = 'd_sys_02102_1'
elseif sGubun = '2' then
	dw_2.DataObject = 'd_sys_02102_2'
elseif sGubun = '3' then
	dw_2.DataObject = 'd_sys_02102_3'
else
	dw_2.DataObject = 'd_sys_02102_4'
	sFrDate = sFrLotNo
	sToLotNo= sToLotNo
end if
dw_2.SetTransObject(sqlca)
dw_2.is_old_dwobject_name = ''

dw_2.SetRedraw(False)
IF dw_2.Retrieve(gs_saupj, sFrDate, sToDate) <=0 THEN
	dw_2.SetRedraw(True)
	f_message_chk(50,"[공정 LOT 검색]")
	sle_msg.Text = ''
	Return -1
END IF
dw_2.SetRedraw(True)

sle_msg.Text = '조회된 자료를 더블클릭하면 공정 LOT 정보를 상세히 볼 수 있습니다.'

Return 1
end event

type p_del from w_inherite`p_del within w_sys_02000
boolean visible = false
integer x = 4411
integer y = 192
end type

type p_mod from w_inherite`p_mod within w_sys_02000
boolean visible = false
integer x = 4238
integer y = 192
end type

type cb_exit from w_inherite`cb_exit within w_sys_02000
integer x = 3232
integer y = 1928
integer taborder = 60
integer textsize = -9
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_sys_02000
integer x = 864
integer y = 2392
end type

type cb_ins from w_inherite`cb_ins within w_sys_02000
integer x = 2706
integer y = 2296
integer width = 594
integer height = 120
integer taborder = 40
integer textsize = -9
string text = "LOT 이력 생성(&G)"
end type

event cb_ins::clicked;call super::clicked;//String  serror
//
//IF Messagebox('LOT이력 생성',"LOT이력을 새로 생성하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
//SetPointer(HourGlass!)
//
//sle_msg.text = "LOT이력 생성 中 .........!!"
//
////에러 30자리 까지 
////serror = '123456789012345678901234567890'
//serror = Space(1000)
//
//sqlca.erp000002000(serror);
//If serror <> 'N' then
//	sle_msg.text = ''
//	rollback;
//	f_message_chk(89,'[' + serror + ']') 
//	return
//end if
//
//Commit;
//sle_msg.text = "LOT이력 생성을 완료하였습니다.!!"
//
//
end event

type cb_del from w_inherite`cb_del within w_sys_02000
integer x = 2071
integer y = 2304
integer width = 581
integer height = 120
integer taborder = 50
integer textsize = -9
string text = "마감이력삭제(&D)"
end type

event cb_del::clicked;call super::clicked;//String  s_yymm
//
//IF dw_insert.AcceptText() = -1 THEN RETURN 
//
//s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))
//
//if isnull(s_yymm) or s_yymm = "" then
//	f_message_chk(30,'[기준년월]')
//	dw_insert.SetColumn('syymm')
//	dw_insert.SetFocus()
//	return
//end if	
////전표처리 된 내역있는지 여부 체크하여 마감 취소할 수 없도록 체크
//
//IF Messagebox('삭제확인',"최종 마감년월보다 이전년월을 입력시 기준년월부터 최종마감 이력자료를 삭제합니다."+&
//              '~n~n' +  "마감이력을 삭제 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
//SetPointer(HourGlass!)
//
//
///* 수불마감 전표이력 삭제 */
//DELETE FROM JUNPYO_CLOSING  
//WHERE SABU   = :gs_saupj AND JPGU = 'C0' AND
//      JPDAT >= :s_yymm   ;
//		
//		
//
//if sqlca.sqlcode < 0 then 
//	rollback;	
//	f_message_chk(31,'') 
//	return
//end if
//
//commit;
//sle_msg.text = "마감이력 삭제 완료"
//
end event

type cb_inq from w_inherite`cb_inq within w_sys_02000
integer x = 64
integer y = 1928
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sys_02000
integer x = 2519
integer y = 1928
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sys_02000
end type

type cb_can from w_inherite`cb_can within w_sys_02000
integer x = 2875
integer y = 1928
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sys_02000
integer x = 1536
integer y = 2316
end type





type gb_10 from w_inherite`gb_10 within w_sys_02000
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_sys_02000
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_02000
end type

type st_7 from statictext within w_sys_02000
boolean visible = false
integer x = 507
integer y = 2672
integer width = 2190
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "1) 기존에 생성한 자료를 모두 삭제한다."
boolean focusrectangle = false
end type

type st_2 from statictext within w_sys_02000
boolean visible = false
integer x = 507
integer y = 2788
integer width = 2190
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "2) 작업실적 자료를 LOT 이력 마스타로 COPY한다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_sys_02000
boolean visible = false
integer x = 507
integer y = 2900
integer width = 2391
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "3) 전공정 LOT별 자신공정 실적을 분할한 LOT 이력 상세정보를 생성한다."
boolean focusrectangle = false
end type

type st_4 from statictext within w_sys_02000
boolean visible = false
integer x = 599
integer y = 2980
integer width = 965
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "ex) 0100 공정 LOT-01 [ 10 EA ]"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sys_02000
boolean visible = false
integer x = 727
integer y = 3048
integer width = 837
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "0100 공정 LOT-02 [ 10 EA ]"
boolean focusrectangle = false
end type

type st_6 from statictext within w_sys_02000
boolean visible = false
integer x = 727
integer y = 3112
integer width = 837
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "0200 공정 LOT-03 [ 15 EA ]"
boolean focusrectangle = false
end type

type st_8 from statictext within w_sys_02000
boolean visible = false
integer x = 1742
integer y = 3084
integer width = 1312
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "0200 공정 LOT-03 [ 10 EA ] → from LOT-01"
boolean focusrectangle = false
end type

type st_9 from statictext within w_sys_02000
boolean visible = false
integer x = 1742
integer y = 3148
integer width = 1312
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "0200 공정 LOT-03 [  5 EA ] → from LOT-02"
boolean focusrectangle = false
end type

type st_10 from statictext within w_sys_02000
boolean visible = false
integer x = 1595
integer y = 3092
integer width = 110
integer height = 84
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "▷"
boolean focusrectangle = false
end type

type st_11 from statictext within w_sys_02000
boolean visible = false
integer x = 507
integer y = 3260
integer width = 2601
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "4) 실적구분이 [정상 or 외주] 인 경우와 [수리] 인 경우를 구분해서 처리한다."
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sys_02000
integer x = 4101
integer y = 232
integer width = 475
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "화면전환(&T)"
end type

event clicked;if dw_2.Visible then
	dw_2.Visible = False
	dw_list.Visible = True

	if dw_list.RowCount() > 0 then
		cb_print.Enabled = True
		sle_msg.Text = '조회된 자료를 출력할 수 있습니다.'
	else
		cb_print.Enabled = False
		sle_msg.Text = ''
	end if

else
	dw_list.Visible = False
	dw_2.Visible = True
	
	if dw_2.RowCount() > 0 then
		sle_msg.Text = '조회된 자료를 더블클릭하면 공정 LOT 정보를 상세히 볼 수 있습니다.'
	else

		sle_msg.Text = ''
	end if
end if
end event

type dw_1 from u_key_enter within w_sys_02000
integer x = 59
integer y = 108
integer width = 2318
integer height = 208
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sys_02001"
boolean border = false
end type

event itemchanged;String  sCode, sName, sNull
		
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(snull)


Choose Case GetColumnName() 
	Case "gubun"
		sCode = this.GetText()
		
		if sCode = '1' then
			this.Object.date_t.Text = '출고일자'
		elseif sCode = '2' then
			this.Object.date_t.Text = '입고일자'
		elseif sCode = '3' then
			this.Object.date_t.Text = '지시일자'
		else
			this.Object.date_t.Text = '사용안함'
		end if
		
//		if sCode = '4' then
//			this.SetColumn('frlotno')
//			this.SetFocus()
//		else
//			this.SetColumn('frdate')
//			this.SetFocus()
//		end if

	Case "frdate"
		sCode = Trim(this.GetText())
		
		if IsNull(sCode) or sCode = '' then return
		
		if f_datechk(sCode) = -1 then
			MessageBox("확인","날짜를 확인하세요.")
			return -1
		end if

	Case "todate"
		sCode = Trim(this.GetText())
		
		if IsNull(sCode) or sCode = '' then return
		
		if f_datechk(sCode) = -1 then
			MessageBox("확인","날짜를 확인하세요.")
			return -1
		end if
END Choose
end event

event itemerror;call super::itemerror;return 1
end event

type gb_1 from groupbox within w_sys_02000
boolean visible = false
integer x = 2473
integer y = 1864
integer width = 1138
integer height = 204
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type gb_3 from groupbox within w_sys_02000
boolean visible = false
integer x = 23
integer y = 1864
integer width = 914
integer height = 204
integer taborder = 70
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type r_1 from rectangle within w_sys_02000
boolean visible = false
long linecolor = 8388608
integer linethickness = 8
long fillcolor = 79741120
integer x = 375
integer y = 2568
integer width = 2894
integer height = 852
end type

type dw_list from datawindow within w_sys_02000
boolean visible = false
integer x = 37
integer y = 356
integer width = 4567
integer height = 1860
integer taborder = 70
boolean titlebar = true
string title = "공정 LOT 정보"
string dataobject = "d_sys_0200_1"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_sys_02000
integer x = 763
integer y = 168
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('frdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
If dw_1.Object.frdate.protect = '1' Then return

dw_1.SetItem(1, 'frdate', gs_code)
end event

type pb_2 from u_pb_cal within w_sys_02000
integer x = 1243
integer y = 168
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('todate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
If dw_1.Object.todate.protect = '1' Then return

dw_1.SetItem(1, 'todate', gs_code)
end event

type rr_1 from roundrectangle within w_sys_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 336
integer width = 4594
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from u_d_select_sort within w_sys_02000
integer x = 37
integer y = 356
integer width = 4567
integer height = 1860
integer taborder = 11
string dataobject = "d_sys_02102_1"
boolean border = false
end type

event doubleclicked;call super::doubleclicked;if row <= 0 then return

String	sGubun, sPordno, sLotsno, sItnbr, sIogbn, sAlegu, sError, sTrcNo

SetPointer(HourGlass!)
sle_msg.text = '공정 LOT 이력 자료를 생성중 입니다!!!...'

dw_1.AcceptText()
sGubun = dw_1.GetItemString(1,'gubun')

// 출고기준 (판매출고) - 작지번호 無, LOT번호 有
if sGubun = '1' then
	sLotsno = trim(this.GetItemString(row,'imhist_lotsno'))
	sItnbr  = trim(this.GetItemString(row,'imhist_itnbr'))
	
//	Select pordno Into :sPordno From shpact
//	 Where sabu = :gs_saupj And lotsno = :sLotsno And rownum = 1 ;
//	
//	if IsNull(sLotsno) or sLotsno = '' then
//		dw_list.DataObject = 'd_sys_02103'
//	else
//		dw_list.DataObject = 'd_sys_02103_0'
//	end if
// 입고기준	(생산입고) - 작지번호 有, LOT번호 有
elseif sGubun = '2' then
	sPordno = trim(this.GetItemString(row,'imhist_jakjino'))
	sLotsno = trim(this.GetItemString(row,'imhist_lotsno'))
	sItnbr  = trim(this.GetItemString(row,'imhist_itnbr'))
	
//	if IsNull(sLotsno) or sLotsno = '' then
//		dw_list.DataObject = 'd_sys_02103'
//	else
//		dw_list.DataObject = 'd_sys_02103_0'
//	end if
// 작업지시기준		  - 작지번호 有, LOT번호 無
elseif sGubun = '3' then
	sPordno = trim(this.GetItemString(row,'momast_pordno'))
	sItnbr  = trim(this.GetItemString(row,'momast_itnbr'))
	
//	dw_list.DataObject = 'd_sys_02103'
	
// LOT번호기준 (판매출고 or 생산입고) 
elseif sGubun = '4' then
	sPordno = trim(this.GetItemString(row,'imhist_jakjino'))
	sLotsno = trim(this.GetItemString(row,'imhist_lotsno'))
	sItnbr  = trim(this.GetItemString(row,'imhist_itnbr'))
	
//	if IsNull(sPordno) Or sPordno = '' then
//		Select pordno Into :sPordno From shpact
//		 Where sabu = :gs_saupj And lotsno = :sLotsno And rownum = 1 ;
//	end if
//
//	if IsNull(sLotsno) or sLotsno = '' then
//		dw_list.DataObject = 'd_sys_02103'
//	else
//		dw_list.DataObject = 'd_sys_02103_0'
//	end if
end if


/******************************************************************************************/
// 공정 LOT 이력 생성 및 검색 결과 조회.
sError = Space(1000)
//sqlca.erp000002000(gs_saupj, sPordno, sError);
//If sError <> 'N' then
//	sle_msg.text = ''
//	Rollback ;
//	f_message_chk(89,'[' + serror + ']') 
//	return
//end if
strcno = '20050708001'
DECLARE ERP_LOT_TRACING2 procedure for ERP_LOT_TRACING2(:gs_sabu, :strcno, :sItnbr,:sLotsno) ;

Execute ERP_LOT_TRACING2;

FETCH ERP_LOT_TRACING2 INTO :sError;

Commit ;


sle_msg.text = '공정 LOT 검색 현황을 조회중 입니다!!!...'
dw_list.SetTransObject(sqlca)
If dw_list.Retrieve(gs_saupj, sPordno, sLotsno, sItnbr) <= 0 then
	sle_msg.text = ''
	f_message_chk(50,'[공정 LOT 검색]') 
	return
end if

sle_msg.text = ''
//dw_list.Object.t_mayymm.Text = Left(isMayymm,4) + '년 ' + Right(isMayymm,2) + '월'
cb_1.TriggerEvent(Clicked!)
end event

