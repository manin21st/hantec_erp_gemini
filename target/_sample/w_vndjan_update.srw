$PBExportHeader$w_vndjan_update.srw
$PBExportComments$거래처 기초잔고 생성(내수,수출)
forward
global type w_vndjan_update from w_inherite
end type
type dw_print from datawindow within w_vndjan_update
end type
end forward

global type w_vndjan_update from w_inherite
string title = "거래처 기초잔고 등록(매출)"
dw_print dw_print
end type
global w_vndjan_update w_vndjan_update

on w_vndjan_update.create
int iCurrent
call super::create
this.dw_print=create dw_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_print
end on

on w_vndjan_update.destroy
call super::destroy
destroy(this.dw_print)
end on

event open;call super::open;dw_input.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_input.InsertRow(0)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_print;call super::ue_print;p_print.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event ue_preview;call super::ue_preview;IF dw_print.rowcount() <= 0 then 
	MessageBox('확인', '출력할 자료가 없습니다.')
	return 
end if

dw_print.object.datawindow.print.preview = "yes"	

OpenWithParm(w_print_preview, dw_print)	

end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", false) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", true) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", true) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = true //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = false //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = true  //// 출력
m_main2.m_window.m_preview.enabled = true //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_vndjan_update
integer y = 3476
end type

type sle_msg from w_inherite`sle_msg within w_vndjan_update
integer y = 3292
end type

type dw_datetime from w_inherite`dw_datetime within w_vndjan_update
integer y = 3292
end type

type st_1 from w_inherite`st_1 within w_vndjan_update
integer y = 3264
end type

type p_search from w_inherite`p_search within w_vndjan_update
integer y = 3296
end type

type p_addrow from w_inherite`p_addrow within w_vndjan_update
integer y = 3296
end type

type p_delrow from w_inherite`p_delrow within w_vndjan_update
integer y = 3296
end type

type p_mod from w_inherite`p_mod within w_vndjan_update
integer y = 3296
end type

event p_mod::clicked;call super::clicked;String sSaleGu, sYYmm, sCvcod, sCurr
Long   nCnt, ix

If dw_insert.AcceptText() <> 1 Then Return 

sSaleGu = Trim(dw_input.GetItemString(1,'salegu'))
sYYmm   = Trim(dw_input.GetItemString(1,'yymm'))

/* key check */
nCnt = dw_insert.RowCount()
If nCnt <= 0 Then Return
For ix = nCnt to 1 Step -1
	sCvcod = Trim(dw_insert.GetItemString(ix,'cvcod'))
	If IsNull(sCvcod) or sCvcod = '' then
		dw_insert.DeleteRow(ix)
		continue
	End If
	
	/* 수출일 경우 통화단위 확인 */
	If sSaleGu = '2' Then 
		sCurr = Trim(dw_insert.GetItemString(ix,'curr'))
		If IsNull(sCurr ) or sCurr = '' Then 
			dw_insert.DeleteRow(ix)
			Continue
		End If	
      dw_insert.SetItem(ix,'sales_yymm', sYYmm )
	Else
      dw_insert.SetItem(ix,'base_yymm', sYYmm )
	End If
	
	dw_insert.SetItem(ix,'sabu',gs_sabu)
Next

/* 저장 */
If dw_insert.update() > 0 then
	commit using sqlca;
Else
	rollback using sqlca ;
//	f_message_chk(160,'')
	cb_inq.TriggerEvent(Clicked!)
	return
End if

cb_inq.TriggerEvent(Clicked!)

sle_msg.Text = '자료를 저장하였습니다'

end event

type p_del from w_inherite`p_del within w_vndjan_update
integer y = 3296
end type

type p_inq from w_inherite`p_inq within w_vndjan_update
integer y = 3296
end type

event p_inq::clicked;call super::clicked;String syymm, sSaleGu, sSarea, silgu

If dw_input.AcceptText() <> 1 Then Return

sYYmm = Trim(dw_input.GetItemString(1,'yymm'))
sSaleGu = Trim(dw_input.GetItemString(1,'salegu'))
sSarea = Trim(dw_input.GetItemString(1,'sarea'))
silgu  = Trim(dw_input.GetItemString(1,'silgu'))

dw_input.SetFocus()
If IsNull(sYymm) or sYymm = '' Then
	f_message_chk(1400,'[실적년월]')
	dw_input.SetColumn('yymm')
	Return
End If

If IsNull(silgu) or silgu = '' Then
	f_message_chk(1400,'[실적구분]')
	dw_input.SetColumn('silgu')
	Return
End If

If IsNull(sSarea) or sSarea = '' Then sSarea = ''

SetPointer(HourGlass!)
dw_insert.Retrieve(gs_sabu, sYymm, sSarea+'%',silgu)
end event

type p_print from w_inherite`p_print within w_vndjan_update
integer y = 3296
end type

event p_print::clicked;call super::clicked;String syymm, sSaleGu, sSarea

If dw_input.AcceptText() <> 1 Then Return

sYYmm = Trim(dw_input.GetItemString(1,'yymm'))
sSaleGu = Trim(dw_input.GetItemString(1,'salegu'))
sSarea = Trim(dw_input.GetItemString(1,'sarea'))

dw_input.SetFocus()
If IsNull(sYymm) or sYymm = '' Then
	f_message_chk(1400,'[실적년월]')
	dw_input.SetColumn('yymm')
	Return
End If

If IsNull(sSarea) or sSarea = '' Then sSarea = ''

If sSaleGu = '1' Then Return //수출만 출력

SetPointer(HourGlass!)

IF dw_print.Retrieve(gs_sabu, sYymm, sSarea+'%') > 0 THEN
	dw_print.object.datawindow.print.preview="yes"
	
	gi_page = dw_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_print)
END IF
end event

type p_can from w_inherite`p_can within w_vndjan_update
integer y = 3296
end type

type p_exit from w_inherite`p_exit within w_vndjan_update
integer y = 3296
end type

type p_ins from w_inherite`p_ins within w_vndjan_update
integer y = 3296
end type

event p_ins::clicked;call super::clicked;Long   nRow
String sSaleGu, sYymm, sSilGu

nRow = dw_insert.InsertRow(0)

sYymm = Trim(dw_input.GetItemString(1,'yymm'))
sSaleGu = Trim(dw_input.GetItemString(1,'salegu'))
sSilGu  = Trim(dw_input.GetItemString(1,'silgu'))

If sSaleGu = '1' Then	/* 내수 */
	dw_insert.SetItem(nRow,'sabu',gs_sabu)
	dw_insert.SetItem(nRow,'base_yymm',syymm)
	dw_insert.SetItem(nRow,'silgu', sSilgu)
Else
	dw_insert.SetItem(nRow,'sabu',gs_sabu)
	dw_insert.SetItem(nRow,'sales_yymm',syymm)
End If

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('cvcod')
end event

type p_new from w_inherite`p_new within w_vndjan_update
integer y = 3296
end type

type dw_input from w_inherite`dw_input within w_vndjan_update
integer y = 56
integer width = 3488
integer height = 116
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_vndjan_update_key"
end type

event itemchanged;String sNull

dw_insert.Reset()
SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		IF f_datechk(GetText()+'01') = -1 THEN
			f_message_chk(35,'[실적년월]')
			SetItem(1,"yymm",snull)
			Return 1
		End If
	Case 'salegu'
		If GetText() = '1' Then
			dw_insert.DataObject = 'd_vndjan_update_02'
		Else
			dw_insert.DataObject = 'd_vndjan_update_01'			
		End If
		dw_insert.SetTransObject(sqlca)
End Choose
end event

event itemerror;return 1
end event

type cb_delrow from w_inherite`cb_delrow within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_addrow from w_inherite`cb_addrow within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type dw_insert from w_inherite`dw_insert within w_vndjan_update
integer x = 37
integer y = 212
integer width = 3488
integer height = 1964
string dataobject = "d_vndjan_update_02"
end type

event dw_insert::itemchanged;String sNull, sCustCd, sCustName, sArea
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case "cvcod"
		sCustCd = Trim(this.GetText())
		IF sCustCd ="" OR IsNull(sCustCd) THEN
			this.SetItem(nRow,"cvnas2",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2" ,"VNDMST"."SAREA" INTO :sCustName , :sArea
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sCustCd  AND
				 "VNDMST"."CVSTATUS" = '0';
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				this.SetItem(nRow,"cvcod",snull)
				this.SetItem(nRow,"cvnas2",snull)
			END IF
			Return 1
		ELSE
			this.SetItem(nRow,"cvnas2",sCustName)
		END IF
	Case "cvnas2"
		sCustName = Trim(this.GetText())
		IF sCustName ="" OR IsNull(sCustName) THEN
			this.SetItem(nRow,"cvcod",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."SAREA" INTO :sCustCd  , :sArea
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVNAS2" = :sCustName AND
				 "VNDMST"."CVSTATUS" = '0';
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				this.SetItem(nRow,"cvcod",snull)
				this.SetItem(nRow,"cvnas2",snull)
			END IF
			Return 1
		ELSE
			this.SetItem(nRow,"cvcod",sCustCd)
		END IF
End Choose
end event

event dw_insert::rbuttondown;string sArea,sCvcod, sCvcodNm
Long   nRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
  Case "cvcod" 
	 gs_code = Trim(GetText())
	 gs_gubun = dw_input.GetItemString(1,'salegu')
	 Open(w_vndmst_popup)
	
	 this.SetItem(nrow,"cvcod",gs_code)
	 this.SetItem(nrow,"cvnas2",gs_codeName)
	 
  Case "cvnas2"
	 gs_gubun = dw_input.GetItemString(1,'salegu')
	 gs_codename = Trim(GetText())
	 Open(w_vndmst_popup)
	
	 IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	 this.SetItem(nrow,"cvcod",gs_code)
	 this.SetItem(nrow,"cvnas2",gs_codeName)
END Choose

end event

type cb_mod from w_inherite`cb_mod within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_ins from w_inherite`cb_ins within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_del from w_inherite`cb_del within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_inq from w_inherite`cb_inq within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_print from w_inherite`cb_print within w_vndjan_update
boolean visible = false
integer y = 3300
end type

type cb_can from w_inherite`cb_can within w_vndjan_update
boolean visible = false
integer y = 3312
end type

type cb_search from w_inherite`cb_search within w_vndjan_update
boolean visible = false
integer y = 3296
end type

type gb_10 from w_inherite`gb_10 within w_vndjan_update
integer y = 3292
end type

type gb_button1 from w_inherite`gb_button1 within w_vndjan_update
integer y = 3292
end type

type gb_button2 from w_inherite`gb_button2 within w_vndjan_update
integer y = 3292
end type

type r_head from w_inherite`r_head within w_vndjan_update
integer height = 124
end type

type r_detail from w_inherite`r_detail within w_vndjan_update
integer y = 208
end type

type dw_print from datawindow within w_vndjan_update
boolean visible = false
integer x = 361
integer y = 2452
integer width = 494
integer height = 360
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_vndjan_update_011"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_vndjan_update
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 16
integer width = 2821
integer height = 148
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_vndjan_update
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4567
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

