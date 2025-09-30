$PBExportHeader$w_itemspec.srw
$PBExportComments$원자재 규격 및 중량관리
forward
global type w_itemspec from w_inherite
end type
type dw_1 from datawindow within w_itemspec
end type
type cb_1 from commandbutton within w_itemspec
end type
type rr_1 from roundrectangle within w_itemspec
end type
end forward

global type w_itemspec from w_inherite
string title = "원자재 규격 및 중량등록"
dw_1 dw_1
cb_1 cb_1
rr_1 rr_1
end type
global w_itemspec w_itemspec

on w_itemspec.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_itemspec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(SQLCA)
end event

type dw_insert from w_inherite`dw_insert within w_itemspec
integer x = 55
integer y = 240
integer width = 4507
integer height = 1976
string dataobject = "d_itemspec_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
end event

event dw_insert::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)
SetNull(gs_codename2)

Choose Case dwo.name
	Case 'cinbr'
		Open(w_itemspec_pop)
		
		If Trim(gs_codename) = '' OR IsNull(gs_codename) Then
//			MessageBox('품목선택 확인', '하위 품목 선택이 되지 않았습니다.')
			Return
		End If
		
		Long   ll_cnt
		Long   ll_gus
		
//		SELECT DECODE(NVL(B.CNT, 0), 0, C.HITCNT, B.CNT)
//		  INTO :ll_cnt
//        FROM PSTRUC A,
//             (  SELECT KUMNO, COUNT('X') AS CNT
//                  FROM KUMITEM_KUM
//              GROUP BY KUMNO ) B,
//             ROUTNG C
//       WHERE A.PINBR = :gs_code
//         AND A.CINBR = :gs_codename
//         AND A.PINBR = B.KUMNO(+)
//         AND A.PINBR = C.ITNBR(+) ;
			
		  SELECT NVL(B.CNT, 0), FUN_GET_DITEMCNT_HAN(A.PINBR)
		    INTO :ll_cnt, :ll_gus
    		 FROM ITEMAS_SPEC A,
					(  SELECT KUMNO, COUNT('X') AS CNT
						  FROM KUMITEM_KUM
					 GROUP BY KUMNO ) B
			WHERE A.PINBR = :gs_code
			  AND A.CINBR = :gs_codename
			  AND A.PINBR = B.KUMNO(+) ;
		
		If IsNull(ll_cnt) OR ll_cnt < 1 Then ll_cnt = 1
		
		This.SetItem(row, 'cinbr' , gs_codename)
		This.SetItem(row, 'pinbr' , gs_code    )
		This.SetItem(row, 'gus'   , ll_cnt     )
		This.SetItem(row, 'hitcnt', ll_gus     )
		
End Choose
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

This.AcceptText()

Long   ll_gus

Double ldb_pitch
Double ldb_thick
Double ldb_width
Double ldb_weight

/**************************************************
구성수에서 타점수로 변경 - 2008.08.29 BY SHINGOON
ll_gus = This.GetItemNumber(row, 'gus')
If ll_gus < 1 OR IsNull(ll_gus) Then ll_gus = 1
**************************************************/

ll_gus = This.GetItemNumber(row, 'hitcnt')
If ll_gus < 1 OR IsNull(ll_gus) Then ll_gus = 1

Choose Case dwo.name
	Case 'pitch'
		ldb_pitch = This.GetItemNumber(row, 'pitch')
		ldb_thick = This.GetItemNumber(row, 'thick')
		ldb_width = This.GetItemNumber(row, 'width')
		
		If IsNull(ldb_pitch) Then ldb_pitch = 0
		If IsNull(ldb_thick) Then ldb_thick = 0
		If IsNull(ldb_width) Then ldb_width = 0
		
		ldb_weight = (((ldb_pitch * ldb_thick * ldb_width) * 7.85) / 1000000) / ll_gus
		
		This.SetItem(row, 'weight', ldb_weight)
		
	Case 'thick'
		ldb_pitch = This.GetItemNumber(row, 'pitch')
		ldb_thick = This.GetItemNumber(row, 'thick')
		ldb_width = This.GetItemNumber(row, 'width')
		
		If IsNull(ldb_pitch) Then ldb_pitch = 0
		If IsNull(ldb_thick) Then ldb_thick = 0
		If IsNull(ldb_width) Then ldb_width = 0
		
		ldb_weight = (((ldb_pitch * ldb_thick * ldb_width) * 7.85) / 1000000) / ll_gus
		
		This.SetItem(row, 'weight', ldb_weight)
		
	Case 'width'
		ldb_pitch = This.GetItemNumber(row, 'pitch')
		ldb_thick = This.GetItemNumber(row, 'thick')
		ldb_width = This.GetItemNumber(row, 'width')
		
		If IsNull(ldb_pitch) Then ldb_pitch = 0
		If IsNull(ldb_thick) Then ldb_thick = 0
		If IsNull(ldb_width) Then ldb_width = 0
		
		ldb_weight = (((ldb_pitch * ldb_thick * ldb_width) * 7.85) / 1000000) / ll_gus
		
		This.SetItem(row, 'weight', ldb_weight)
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_itemspec
integer x = 3890
end type

event p_delrow::clicked;call super::clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_delete() <> 1 Then Return

Long   i

For i = 1 To dw_insert.RowCount()
	i = dw_insert.GetSelectedRow(i)
	If i < 1 Then Exit
	
	dw_insert.DeleteRow(i)
	i = i - 1
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If
end event

type p_addrow from w_inherite`p_addrow within w_itemspec
integer x = 3717
end type

event p_addrow::clicked;call super::clicked;Long   ll_ins

ll_ins = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(ll_ins)
dw_insert.SetRow(ll_ins)
dw_insert.SetColumn('cinbr')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_itemspec
boolean visible = false
integer x = 3086
end type

type p_ins from w_inherite`p_ins within w_itemspec
boolean visible = false
integer x = 2912
end type

type p_exit from w_inherite`p_exit within w_itemspec
integer x = 4411
end type

type p_can from w_inherite`p_can within w_itemspec
integer x = 4238
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_insert.ReSet()

dw_1.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_itemspec
boolean visible = false
integer x = 3259
end type

type p_inq from w_inherite`p_inq within w_itemspec
integer x = 3543
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return -1

String ls_pinbr

ls_pinbr = dw_1.GetItemString(row, 'pinbr')
If Trim(ls_pinbr) = '' OR IsNull(ls_pinbr) Then ls_pinbr = '%'

String ls_cinbr

ls_cinbr = dw_1.GetItemString(row, 'cinbr')
If Trim(ls_cinbr) = '' OR IsNull(ls_cinbr) Then ls_cinbr = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_pinbr, ls_cinbr)
dw_insert.SetRedraw(True)

If dw_insert.RowCount() < 1 Then
	MessageBox('자료조회', '조회된 내용이 없습니다.')
	Return -1
End If
end event

type p_del from w_inherite`p_del within w_itemspec
boolean visible = false
integer x = 2738
end type

type p_mod from w_inherite`p_mod within w_itemspec
integer x = 4064
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() <> 1 Then Return

Long   i
Long   ll_chk
String ls_pinbr
String ls_cinbr
Double ldb_qtyp

For i = 1 To ll_cnt
 	i = dw_insert.GetNextModified(i - 1, Primary!)
	If i < 1 Then Exit
	
	ls_pinbr = dw_insert.GetItemString(i, 'pinbr' )
	ls_cinbr = dw_insert.GetItemString(i, 'cinbr' )
	ldb_qtyp = dw_insert.GetItemNumber(i, 'weight')
	
	If Trim(ls_pinbr) = '' OR IsNull(ls_pinbr) Then
		MessageBox('상위품번 확인', '상위품번이 선택되지 않았습니다.')
		dw_insert.SetColumn('cinbr')
		dw_insert.SetFocus()
		Return
	End If
	
	If Trim(ls_cinbr) = '' OR IsNull(ls_cinbr) Then
		MessageBox('하위품번 확인', '하위품번이 선택되지 않았습니다.')
		dw_insert.SetColumn('cinbr')
		dw_insert.SetFocus()
		Return
	End If
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM PSTRUC
	 WHERE PINBR = :ls_pinbr
	   AND CINBR = :ls_cinbr ;
	If ll_chk > 0 Then
		UPDATE PSTRUC
		   SET QTYPR = :ldb_qtyp
		 WHERE PINBR = :ls_pinbr
		   AND CINBR = :ls_cinbr ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox('동시작업 오류', '생산BOM 구성수 UPDATE 중 오류가 발생했습니다.' + '~r~n' + SQLCA.SQLERRTEXT)
			ROLLBACK USING SQLCA;
		End If			
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장 중 오류가 발생 했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_itemspec
end type

type cb_mod from w_inherite`cb_mod within w_itemspec
end type

type cb_ins from w_inherite`cb_ins within w_itemspec
end type

type cb_del from w_inherite`cb_del within w_itemspec
end type

type cb_inq from w_inherite`cb_inq within w_itemspec
end type

type cb_print from w_inherite`cb_print within w_itemspec
end type

type st_1 from w_inherite`st_1 within w_itemspec
end type

type cb_can from w_inherite`cb_can within w_itemspec
end type

type cb_search from w_inherite`cb_search within w_itemspec
end type







type gb_button1 from w_inherite`gb_button1 within w_itemspec
end type

type gb_button2 from w_inherite`gb_button2 within w_itemspec
end type

type dw_1 from datawindow within w_itemspec
integer x = 37
integer y = 32
integer width = 2011
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_itemspec_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(gs_codename2)

String ls_ret

Choose Case dwo.name
	Case 'pinbr'
		gs_gubun = '2'
		
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		SELECT ITTYP
		  INTO :ls_ret
		  FROM ITEMAS
		 WHERE ITNBR = :gs_code ;
		If ls_ret <> '2' Then
			MessageBox('품목구분 확인', '품목구분이 반제품이 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'pinbr', gs_code)
		
	Case 'cinbr'
		gs_gubun = '3'
		
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		SELECT ITTYP
		  INTO :ls_ret
		  FROM ITEMAS
		 WHERE ITNBR = :gs_code ;
		If ls_ret <> '3' Then
			MessageBox('품목구분 확인', '품목구분이 반제품이 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'cinbr', gs_code)
		
End Choose
end event

type cb_1 from commandbutton within w_itemspec
boolean visible = false
integer x = 2062
integer y = 64
integer width = 475
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "File Up-Load"
end type

event clicked;Long		lXlrow, lValue, lCnt, lQty[], lTotal, lRow
String		sDocname, sNamed, sPspec
String		sWcdsc,  sItemnum, sItemname, sIspec, sOpdsc, sKumno, sQty, sTotal, sayu		// 호기-품번-품명-공정-금형-수량...
uo_xlobject 		uo_xl
Integer 	i, j, k, iNotNullCnt

//기존자료 삭제
If MessageBox('기존자료 삭제 여부', '기존 자료를 삭제하고 진행합니다. 계속 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

DELETE FROM ITEMAS_SPEC ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('자료 삭제 오류', '기존 자료 삭제 중 오류가 발생했습니다.')
	Return
End If

// 액셀 IMPORT ***************************************************************

lValue = GetFileOpenName("파일선택", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

////===========================================================================================
////UserObject 생성
w_mdi_frame.sle_msg.text = "액셀 업로드 준비중..."
uo_xl = create uo_xlobject

//엑셀과 연결
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
//Excel 에서 A: 1 , B :2 로 시작 

lXlrow = 1		// 첫 헤드부터 진행 -첫헤드를 제외하고 두번째행부터 진행-

String ls_pinbr
String ls_cinbr
Double ldb_t
Double ldb_w
Double ldb_p

Long   ll_ins
Long   ll_cnt

Do While(True)
	
	iNotNullCnt = 0
	
	// 사용자 ID(A,1)
	// Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	// 총 36개 열로 구성
	For i =1 To 5
		uo_xl.uf_set_format(lXlrow, i, '@' + space(50))
	Next
	
	ls_pinbr = Trim(uo_xl.uf_gettext(lXlrow, 1))					// 상위품번
	ls_cinbr = Trim(uo_xl.uf_gettext(lXlrow, 2))             // 하위품번
	ldb_t    = Double(Trim(uo_xl.uf_gettext(lXlrow, 3)))     // 두께
	ldb_w    = Double(Trim(uo_xl.uf_gettext(lXlrow, 4)))     // 폭
	ldb_p    = Double(Trim(uo_xl.uf_gettext(lXlrow, 5)))     // 피치
	
	//구성수----------------------------------------------------------
		
	SELECT DECODE(NVL(B.CNT, 0), 0, C.HITCNT, B.CNT)
	  INTO :ll_cnt
	  FROM PSTRUC A,
			 (  SELECT KUMNO, COUNT('X') AS CNT
					FROM KUMITEM_KUM
			  GROUP BY KUMNO ) B,
			 ROUTNG C
	 WHERE A.PINBR = :ls_pinbr
		AND A.CINBR = :ls_cinbr
		AND A.PINBR = B.KUMNO(+)
		AND A.PINBR = C.ITNBR(+) ;
	
	If IsNull(ll_cnt) OR ll_cnt < 1 Then ll_cnt = 1 
	//----------------------------------------------------------------
	
	If Trim(ls_pinbr) = '' OR IsNull(ls_pinbr) Then
		Exit
	Else
		iNotNullCnt++
		ll_ins = dw_insert.InsertRow(0)
		
		dw_insert.SetItem(ll_ins, 'pinbr', ls_pinbr)
		dw_insert.SetItem(ll_ins, 'cinbr', ls_cinbr)
		dw_insert.SetItem(ll_ins, 'thick', ldb_t   )
		dw_insert.SetItem(ll_ins, 'width', ldb_w   )
		dw_insert.SetItem(ll_ins, 'pitch', ldb_p   )
		dw_insert.SetItem(ll_ins, 'gus'  , ll_cnt  )
		
		dw_insert.SetColumn('pitch')
		dw_insert.SetRow(ll_ins)
		dw_insert.ScrollToRow(ll_ins)
			
		dw_insert.TriggerEvent(ItemChanged!)
			
		lCnt++
	End If
	
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

MessageBox('확인', String(lCnt) + ' 건의 DATA IMPORT를 완료하였습니다.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type rr_1 from roundrectangle within w_itemspec
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 228
integer width = 4539
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

