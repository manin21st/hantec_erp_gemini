$PBExportHeader$w_pm01_02020_1_han.srw
$PBExportComments$월 생산능력 검토(17.07.09변경)
forward
global type w_pm01_02020_1_han from w_inherite_popup
end type
type dw_0 from datawindow within w_pm01_02020_1_han
end type
type st_2 from statictext within w_pm01_02020_1_han
end type
type rr_2 from roundrectangle within w_pm01_02020_1_han
end type
type rr_3 from roundrectangle within w_pm01_02020_1_han
end type
end forward

global type w_pm01_02020_1_han from w_inherite_popup
integer width = 2848
integer height = 2084
string title = "부하 조정 (ver.17.10.10)"
dw_0 dw_0
st_2 st_2
rr_2 rr_2
rr_3 rr_3
end type
global w_pm01_02020_1_han w_pm01_02020_1_han

type variables
String is_yymm
Int    ii_jucha
String    is_calgbn
end variables

on w_pm01_02020_1_han.create
int iCurrent
call super::create
this.dw_0=create dw_0
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_0
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_3
end on

on w_pm01_02020_1_han.destroy
call super::destroy
destroy(this.dw_0)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;f_window_center_response(this)

String sItnbr, sOpseq, sWkctr
string sdate, edate
String stemp
Long ix

is_Yymm = Left(gs_code,8)
ii_jucha = Dec(Right(gs_code,1))
is_calgbn = gs_gubun // 1:작업장, 2:설비

dw_jogun.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

sItnbr = gs_codename
sWkctr = gs_codename2
sOpseq = gs_codename3


//------------------------------------------------------------------------------------------------------------
// 2017.10.10 - 표준공정 대체작업장 DDDW 조회
datawindowchild	dwc

dw_jogun.GetChild('dwkctr', dwc)
dwc.SetTransObject(sqlca)
dwc.Retrieve(sItnbr, sOpseq)
//------------------------------------------------------------------------------------------------------------


If dw_jogun.Retrieve(is_yymm, sItnbr, sWkctr) <= 0 Then
	Close(this)
	Return
End If
	
/* 대체작업장 조회 */
sdate = is_yymm
edate = f_afterday(sdate, 6)


//------------------------------------------------------------------------------------------------------------
// 2017.10.10 - CO2 용접 공정이면서 1호기인 경우만 아이템 조합 기능 활성화
string	ls_roslt

SELECT ROSLT INTO :ls_roslt FROM ROUTNG WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
if ls_roslt = 'RCW' and Pos(sWkctr, '-1') > 0 then
	st_2.visible = False
	dw_0.InsertRow(0)
end if
//------------------------------------------------------------------------------------------------------------
//dw_1.Retrieve(sdate, edate, sItnbr, sOpseq)
//For ix = 1 To dw_1.RowCount()
//	dw_1.SetItem(ix, 'mchr', dw_jogun.GetItemNumber(1, 'mchr'))
//Next
end event

event key;//call super::key;choose case key
//	case keypageup!
//		dw_1.scrollpriorpage()
//	case keypagedown!
//		dw_1.scrollnextpage()
//	case keyhome!
//		dw_1.scrolltorow(1)
//	case keyend!
//		dw_1.scrolltorow(dw_1.rowcount())
//end choose

//If keyDown(keyQ!) And keyDown(keyAlt!) Then
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyV!) And keyDown(keyAlt!) Then
//	p_choose.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyC!) And keyDown(keyAlt!) Then
//	p_exit.TriggerEvent(Clicked!)
//End If

Choose Case key
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
//	Case KeyT!
//		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
//	Case KeyS!
//		p_mod.TriggerEvent(Clicked!)
//	Case KeyD!
//		p_del.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
//	Case KeyX!
//		p_exit.TriggerEvent(Clicked!)
	Case KeyV!
		p_choose.TriggerEvent(Clicked!)
End Choose
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_02020_1_han
integer x = 64
integer y = 176
integer width = 2715
integer height = 760
integer taborder = 30
string dataobject = "d_pm01_02020_1_11_han"
end type

type p_exit from w_inherite_popup`p_exit within w_pm01_02020_1_han
integer x = 2619
integer y = 0
integer taborder = 20
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;gs_code = 'OK'
//SetNull(gs_code)
Close(Parent)
end event

event p_exit::ue_lbuttondown;//
PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;//
PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_02020_1_han
integer x = 2446
integer y = 0
integer taborder = 10
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_inq::clicked;Dec {2} dSqty,dJqty, dGapQty, nCnt, dQty, dMchr
Dec {2} dJqty1, dJqty2, dJqty3, dJqty4, dJqty5, dJqty6, dJqty7
Dec {2} dSqty1, dSqty2, dSqty3, dSqty4, dSqty5, dSqty6, dSqty7
String sItnbr, sMchno, sWkctr, sDWkctr, spWkctr, sDate, sOpseq, sPdtgu
Long i, ix, iy, nRow

If dw_1.AcceptText() <> 1 Then Return
If dw_jogun.AcceptText() <> 1 Then Return

//dSqty = dw_jogun.GetItemNumber(1, 'sum_gapqty')
//If dSqty = 0 Then
//	MessageBox('확 인','조정할 사항이 없습니다.!!')
//	Return
//End If

sPdtgu = dw_jogun.GetItemString(1, 'pdtgu')

Long   lcount
SELECT COUNT('X') INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :is_yymm AND A.MOSEQ = 0 AND JOCOD = :sPdtgu;
If lcount > 0 Then
	messagebox("확 인", "주간 생산계획이 확정되어 있으므로 수정 및 삭제 할 수 없습니다.")
	Return
End If

If MessageBox("확 인", "조정하시겠습니까?",	Exclamation!, OKCancel!, 1) = 2 Then Return

SetPointer(HourGlass!)

sItnbr = dw_jogun.GetItemString(1, 'itnbr')

For i = 1 To dw_jogun.rowcount()
	sWkctr	= dw_jogun.GetItemString(i, 'wkctr')
	sDWkctr	= dw_jogun.GetItemString(i, 'dwkctr')
	
	dSqty		= dw_jogun.GetItemNumber(i, 'sqty')
	dJqty		= dw_jogun.GetItemNumber(i, 'jqty')
	dGapQty	= dw_jogun.GetItemNumber(i, 'gapqty')
	
	// 대체작업장이 동일작업장이거나 대체량이 0이면 대체 처리 안함
	IF sWkctr = sDWkctr Or dJqty <= 0 THEN
		
		if i = 1 then dSqty1 = dSqty
		if i = 2 then dSqty2 = dSqty
		if i = 3 then dSqty3 = dSqty
		if i = 4 then dSqty4 = dSqty
		if i = 5 then dSqty5 = dSqty
		if i = 6 then dSqty6 = dSqty
		if i = 7 then dSqty7 = dSqty

	ELSE
		
		// 1. 작업장대체된 경우는 잔량을 기존 작업장의 계획량으로 보관
		if dSqty < dGapQty then dGapQty = dSqty
		if dGapQty < 0 then dGapQty = 0
		
		if i = 1 then dSqty1 = dGapQty
		if i = 2 then dSqty2 = dGapQty
		if i = 3 then dSqty3 = dGapQty
		if i = 4 then dSqty4 = dGapQty
		if i = 5 then dSqty5 = dGapQty
		if i = 6 then dSqty6 = dGapQty
		if i = 7 then dSqty7 = dGapQty

		// 2. 대체작업장 기존 계획 확인 후 대체계획량 반영
		dJqty1 = 0; dJqty2 = 0; dJqty3 = 0; dJqty4 = 0; dJqty5 = 0; dJqty6 = 0; dJqty7 = 0
		
		if i = 1 then dJqty1 = dJqty
		if i = 2 then dJqty2 = dJqty
		if i = 3 then dJqty3 = dJqty
		if i = 4 then dJqty4 = dJqty
		if i = 5 then dJqty5 = dJqty
		if i = 6 then dJqty6 = dJqty
		if i = 7 then dJqty7 = dJqty

		SELECT COUNT(*) INTO :nCnt FROM PM02_CAPA_DTL WHERE YYMM = :is_yymm AND ITNBR = :sItnbr AND WKCTR = :sDWkctr;
			
		If nCnt > 0 Then
			UPDATE PM02_CAPA_DTL
				SET LOTQTY1 = LOTQTY1 + :dJqty1,
					 LOTQTY2 = LOTQTY2 + :dJqty2,
					 LOTQTY3 = LOTQTY3 + :dJqty3,
					 LOTQTY4 = LOTQTY4 + :dJqty4,
					 LOTQTY5 = LOTQTY5 + :dJqty5,
					 LOTQTY6 = LOTQTY6 + :dJqty6,
					 LOTQTY7 = LOTQTY7 + :dJqty7
			 WHERE YYMM = :is_yymm AND ITNBR = :sItnbr AND WKCTR = :sDWkctr;
		Else
			INSERT INTO PM02_CAPA_DTL
			( YYMM, ITNBR, WKCTR, MCHR, S1QTY, S2QTY, S3QTY, S4QTY, S5QTY, S6QTY, S7QTY,
				LOTQTY1, LOTQTY2, LOTQTY3, LOTQTY4, LOTQTY5, LOTQTY6, LOTQTY7, OPSEQ)
			VALUES
			( :is_yymm, :sItnbr, :sDWkctr, :dMchr,	:dJqty1,	:dJqty2, :dJqty3, :dJqty4, :dJqty5, :dJqty6, :dJqty7,
				:dJqty1,	:dJqty2, :dJqty3, :dJqty4, :dJqty5, :dJqty6, :dJqty7, :sOpseq);
		End If
		
		If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
			Rollback;
			Return
		End If
		
	END IF
	
Next

/* 변경전 설비에 대한 조정 */
sWkctr = dw_jogun.GetItemString(1, 'wkctr')
dMchr = dw_jogun.GetItemNumber(1, 'mchr')

/* 작업장 */
UPDATE PM02_CAPA_DTL
   SET LOTQTY1 = :dSqty1,
		 LOTQTY2 = :dSqty2,
		 LOTQTY3 = :dSqty3,
		 LOTQTY4 = :dSqty4,
		 LOTQTY5 = :dSqty5,
		 LOTQTY6 = :dSqty7,
		 LOTQTY7 = :dSqty7
 WHERE YYMM = :is_yymm AND ITNBR = :sItnbr AND WKCTR = :sWkctr;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #1')
	Rollback;
	Return
End If

COMMIT;

// 작업장 부하계산(사용공수만 재계산)
sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, is_yymm, '3');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

// 복사하기
sWkctr = dw_jogun.GetItemString(1, 'wkctr')

SELECT COUNT(*) INTO :nRow FROM WRKCTR WHERE MCHNO = (select MCHNO from WRKCTR WHERE wkctr = :sWkctr);

IF nRow > 1 THEN

	if	MESSAGEBOX("확인", "다른 작업장에 남은 공수를 넘기겠습니까?", Question!, YesNo!, 1) = 1 then

		FOR ix = 1 To dw_jogun.RowCount()
			
			sWkctr = dw_jogun.GetItemString(ix, 'wkctr')
			sDate = dw_jogun.GetItemString(ix, 'cldate')
			
			sqlca.PM02_CAPA_LOD_COPY(sWkctr, sDate);
			If sqlca.sqlcode <> 0 Then
				MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
				RETURN
			END iF	
		
		NEXT

	end if
	
end if

gs_code = 'OK'
Close(Parent)

end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\조정_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\조정_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pm01_02020_1_han
boolean visible = false
integer x = 1879
integer y = 12
integer taborder = 50
end type

type dw_1 from w_inherite_popup`dw_1 within w_pm01_02020_1_han
integer x = 55
integer y = 1168
integer width = 2715
integer height = 760
integer taborder = 40
string dataobject = "d_pm01_02020_1_21_han"
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::itemchanged;call super::itemchanged;Dec dQty, dJqty

Choose Case GetColumnName()
	Case 'opt'
		If GetText() = 'N' Then
			SetItem(row, 'qty', 0)
		End If
	Case 'qty'
		dQty = Dec(GetText())
		If IsNull(dQty) Then dQty = 0
		
//		dJqty = dw_jogun.GetItemNumber(1, 'jqty')
//		If IsNull(dJqty) Then dJqty = 0
//		If dJqty - dQty < 0 Then
//			MessageBox('확 인','계획수량이 (-)됩니다.!!')
//			Return 2
//		End If
//		
//		dw_jogun.SetItem(1, 'jqty', dJqty - dQty)
//		
//		If dJqty - dQty > 0 Then
//			SetItem(row, 'opt','Y')
//		End If

		If dQty > 0 Then
			SetItem(row, 'opt','Y')
		End If
End Choose
end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_02020_1_han
boolean visible = false
integer x = 576
integer y = 2580
end type

type cb_1 from w_inherite_popup`cb_1 within w_pm01_02020_1_han
boolean visible = false
integer x = 1051
integer y = 2328
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_02020_1_han
boolean visible = false
integer x = 1687
integer y = 2328
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_02020_1_han
boolean visible = false
integer x = 1371
integer y = 2328
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_02020_1_han
boolean visible = false
integer x = 411
integer y = 2464
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_02020_1_han
boolean visible = false
integer x = 133
integer y = 2476
end type

type dw_0 from datawindow within w_pm01_02020_1_han
integer x = 55
integer y = 988
integer width = 2743
integer height = 168
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pm01_02020_1_20_han"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;long		i
string		sitdsc, swkctr, sdwkctr, sdwcdsc
decimal	dman, dmch, dct1, dct2, dct3
datawindowchild	dwc

IF dwo.name = 'b_1' THEN
	gs_gubun = dw_jogun.GetItemString(1,'cldate')
	gs_code = dw_jogun.GetItemString(1,'itnbr')
	
	// 아이템 조합 2번 작업장
	swkctr = dw_jogun.GetItemString(1,'wkctr')
	sdwkctr = Left(swkctr, Pos(swkctr, '-')) + '2'

	Open(w_pm01_02020_1_pop)
	If gs_gubun = 'OK' Then
		
		dw_1.GetChild('dwkctr', dwc)
		dwc.SetTransObject(sqlca)
		dwc.Retrieve(gs_code, '0010')

		dw_1.SetRedraw(False)
		If dw_1.Retrieve(is_yymm, gs_code, '%') > 0 Then
			
		Else
			// 생산계획이 없는 경우 강제 추가 로직 구현			
			SELECT B.ITDSC, A.STDST7, A.STDST8, A.STDST9, FUN_GET_WCDSC(:sdwkctr)
			   INTO :sitdsc, :dct1, :dct2, :dct3, :sdwcdsc
			  FROM ROUTNG_SETTM A, ITEMAS B
			WHERE A.ITNBR = :gs_code
				AND A.OPSEQ = '0010'
				AND A.ITNBR = B.ITNBR ;
				
			dw_jogun.RowsCopy(1, dw_jogun.RowCount(), Primary!, dw_1, 1, Primary!)
			For i = 1 To dw_1.RowCount()
				dw_1.SetItem(i, 'itnbr', gs_code)
				dw_1.SetItem(i, 'itdsc', sitdsc)
				dw_1.SetItem(i, 'load_time', dct1)
				dw_1.SetItem(i, 'work_time', dct2)
				dw_1.SetItem(i, 'unload_time', dct3)
				dw_1.SetItem(i, 'sqty', 0)
				dw_1.SetItem(i, 'jqty', 0)
			Next
		End If

		For i = 1 To dw_1.RowCount()
			dw_1.SetItem(i, 'wkctr', sdwkctr)
			dw_1.SetItem(i, 'wrkctr_wcdsc', sdwcdsc)
			dw_1.SetItem(i, 'dwkctr', sdwkctr)
		Next
		dw_1.SetRedraw(True)
		
		// 조합 아이템 C/T 계산
		dman = dw_jogun.GetItemNumber(1,'load_time') + dw_jogun.GetItemNumber(1,'unload_time')
		dmch = dw_jogun.GetItemNumber(1,'work_time')
		if dman > dmch then
			dct1 = dman
		else
			dct1 = dmch
		end if

		dman = dw_1.GetItemNumber(1,'load_time') + dw_1.GetItemNumber(1,'unload_time')
		dmch = dw_1.GetItemNumber(1,'work_time')
		if dman > dmch then
			dct2 = dman
		else
			dct2 = dmch
		end if
		
		dw_0.SetItem(1, 'c_sec', dct1 + dct2)
	End If
	
END IF
end event

type st_2 from statictext within w_pm01_02020_1_han
integer x = 50
integer y = 1084
integer width = 1893
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long backcolor = 32106727
string text = "※ CO2용접(RCW)인 경우는 아래 아이템 조합 기능이 활성화됩니다."
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pm01_02020_1_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 168
integer width = 2747
integer height = 788
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_02020_1_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 1160
integer width = 2747
integer height = 788
integer cornerheight = 40
integer cornerwidth = 55
end type

