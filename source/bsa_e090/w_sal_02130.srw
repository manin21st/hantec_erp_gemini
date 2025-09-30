$PBExportHeader$w_sal_02130.srw
$PBExportComments$거래처 매출 일괄변경
forward
global type w_sal_02130 from w_inherite
end type
type st_2 from statictext within w_sal_02130
end type
type st_3 from statictext within w_sal_02130
end type
type st_4 from statictext within w_sal_02130
end type
type pb_1 from u_pb_cal within w_sal_02130
end type
type pb_2 from u_pb_cal within w_sal_02130
end type
type gb_2 from groupbox within w_sal_02130
end type
type gb_1 from groupbox within w_sal_02130
end type
end forward

global type w_sal_02130 from w_inherite
string title = "매출 단가 일괄 갱신"
st_2 st_2
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_sal_02130 w_sal_02130

forward prototypes
public function integer wf_junpyo_closing (string syymm)
end prototypes

public function integer wf_junpyo_closing (string syymm);/* 매출 마감여부                  */
/* Return : 0(마감전), > 0 (마감) */
Long nCnt

  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sYYmm )   ;

If nCnt > 0 Then
	f_message_chk(60,'[매출월마감]')
	Return nCnt
End If

Return 0

end function

on w_sal_02130.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_sal_02130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_insert.InsertRow(0)


// 부가세 사업장 설정
f_mod_saupj(dw_insert, 'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_sal_02130
integer x = 1431
integer y = 620
integer width = 1806
integer height = 576
string dataobject = "d_sal_02130"
boolean border = false
end type

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod1", "cvcodnm1"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm1" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod1",gs_code)
		SetColumn("cvcod1")
		TriggerEvent(ItemChanged!)
	/* 거래처 */
	Case "cvcod2", "cvcodnm2"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod2",gs_code)
		SetColumn("cvcod2")
		TriggerEvent(ItemChanged!)
End Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "sdatef"  , "sdatet"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[출고일자]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* 거래처 */
	Case "cvcod1"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm1",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod1', sNull)
			SetItem(1, 'cvcodnm1', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm1",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm1"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod1",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod1', sNull)
			SetItem(1, 'cvcodnm1', snull)
			Return 1
		ELSE
			SetItem(1,'cvcod1', sCvcod)
			SetItem(1,"cvcodnm1", scvnas)
			Return 1
		END IF
	/* 거래처 */
	Case "cvcod2"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod2', sNull)
			SetItem(1, 'cvcodnm2', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm2",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod2",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod2', sNull)
			SetItem(1, 'cvcodnm2', snull)
			Return 1
		ELSE
			SetItem(1,'cvcod2', sCvcod)
			SetItem(1,"cvcodnm2", scvnas)
			Return 1
		END IF
End Choose

end event

event dw_insert::editchanged;Return
end event

type p_delrow from w_inherite`p_delrow within w_sal_02130
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_02130
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_02130
integer x = 2907
integer y = 416
string picturename = "C:\ERPMAN\image\처리_up.gif"
end type

event p_search::ue_lbuttonup;pictureName = "C:\ERPMAN\image\처리_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\ERPMAN\image\처리_dn.gif"
end event

event p_search::clicked;call super::clicked;string sDatef, sDatet, sNull, sCvcod1, sCvcod2, sIoJpno, smsg, sSaupj
Long   nRow, nCnt

SetNull(sNull)

If dw_insert.AcceptText() <> 1 then Return

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

sSaupj  = Trim(dw_insert.GetItemString(nRow,'saupj'))
sDatef  = Trim(dw_insert.GetItemString(nRow,'sdatef'))
sDatet  = Trim(dw_insert.GetItemString(nRow,'sdatet'))
sCvcod1 = Trim(dw_insert.GetItemString(nRow,'cvcod1'))
sCvcod2 = Trim(dw_insert.GetItemString(nRow,'cvcod2'))

dw_insert.SetFocus()
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_insert.SetColumn('saupj')
	Return
End If

//If IsNull(sCvcod1) or sCvcod1 = '' Then 
//	f_message_chk(1400,'[변경전 거래처]')
//	dw_insert.SetColumn('cvcod1')
//	Return
//End If
//
//If IsNull(sCvcod2) or sCvcod2 = '' Then
//	f_message_chk(1400,'[변경후 거래처]')
//	dw_insert.SetColumn('cvcod2')
//	Return
//End If

If IsNull(sdatef) Or sdatef = '' Then
  f_message_chk(1400,'[출고기간]')
	dw_insert.SetColumn('sdatef')
	Return 
End If

If IsNull(sdatet) Or sdatet = '' Then
  f_message_chk(1400,'[출고기간]')
	dw_insert.SetColumn('sdatet')
	Return 
End If

/* 매출마감여부 확인 */
If wf_junpyo_closing(Left(sDatef,6)) > 0 Then
	dw_insert.SetItem(1,'sdatef',sNull)
	dw_insert.SetColumn('sdatef')
	return 1
End If

If wf_junpyo_closing(Left(sDatet,6)) > 0 Then
	dw_insert.SetItem(1,'sdatet',sNull)
	dw_insert.SetColumn('sdatet')
	return 1
End If

IF MessageBox("출고처 조정","해당 기간동안 출고된 거래처를 일괄조정합니다." +"~n~n" +&
                    	 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

nCnt = sqlca.FUN_ERP100000018(gs_sabu, sdatef, sdatet, scvcod1, scvcod2, sSaupj)
If sqlca.sqlcode = 0 then
  commit;
  f_message_chk(202,'[처리건수 : ' +String(nCnt) + ']')
Else
	smsg = sqlca.sqlerrtext
	RollBack;
	f_message_chk(57,smsg)
	Return	
End If

dw_insert.Reset()
dw_insert.InsertRow(0)
ib_any_typing = false
end event

type p_ins from w_inherite`p_ins within w_sal_02130
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_02130
integer x = 3081
integer y = 416
end type

type p_can from w_inherite`p_can within w_sal_02130
integer y = 5000
end type

type p_print from w_inherite`p_print within w_sal_02130
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_02130
integer y = 5000
end type

type p_del from w_inherite`p_del within w_sal_02130
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_02130
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_sal_02130
integer x = 2405
integer y = 5000
integer width = 443
integer taborder = 40
end type

type cb_mod from w_inherite`cb_mod within w_sal_02130
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_02130
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_sal_02130
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02130
integer x = 1600
integer y = 2416
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_02130
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_02130
end type

type cb_can from w_inherite`cb_can within w_sal_02130
integer x = 1449
integer y = 2380
integer width = 443
integer taborder = 30
boolean enabled = false
string text = "마감취소(&C)"
end type

type cb_search from w_inherite`cb_search within w_sal_02130
integer x = 1797
integer y = 5000
integer width = 498
integer taborder = 20
string text = "일괄변경(&P)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02130
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02130
end type

type st_2 from statictext within w_sal_02130
integer x = 1435
integer y = 1372
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "* 기간내 출고단가를 "
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_02130
integer x = 2021
integer y = 1372
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "제품단가마스타"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_02130
integer x = 2459
integer y = 1372
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "기준으로 일괄 갱신합니다."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_sal_02130
integer x = 2400
integer y = 924
integer width = 78
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02130
integer x = 2926
integer y = 924
integer width = 78
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatet', gs_code)

end event

type gb_2 from groupbox within w_sal_02130
integer x = 1403
integer y = 1260
integer width = 1861
integer height = 244
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_sal_02130
integer x = 1403
integer y = 560
integer width = 1861
integer height = 672
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
end type

