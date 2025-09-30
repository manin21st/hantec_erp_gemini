$PBExportHeader$w_sm40_0057_popup2.srw
$PBExportComments$거래처 일괄변경
forward
global type w_sm40_0057_popup2 from w_inherite_popup
end type
end forward

global type w_sm40_0057_popup2 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 1879
integer height = 880
string title = "거래처 일괄변경"
end type
global w_sm40_0057_popup2 w_sm40_0057_popup2

type variables
string is_itcls

str_code ist_code
end variables

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

on w_sm40_0057_popup2.create
call super::create
end on

on w_sm40_0057_popup2.destroy
call super::destroy
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)

ist_code = message.powerobjectparm

f_window_center_response(this) 

dw_jogun.insertRow(0)
dw_jogun.object.saupj[1] = Trim(ist_code.code[1]) 
dw_jogun.object.sdatef[1] = Trim(ist_code.sgubun1[1])+'01'
dw_jogun.object.sdatet[1] = f_last_date(Trim(ist_code.sgubun1[1])+'01')





end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm40_0057_popup2
integer x = 14
integer y = 216
integer width = 1815
integer height = 552
string dataobject = "d_sm40_0057_popup_cvcod"
end type

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::itemchanged;call super::itemchanged;String sNull, sDate
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

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod1"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm1" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod1",gs_code)
		SetColumn("cvcod1")
		TriggerEvent(ItemChanged!)
	/* 거래처 */
	Case "cvcod2"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod2",gs_code)
		SetColumn("cvcod2")
		TriggerEvent(ItemChanged!)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sm40_0057_popup2
integer x = 1659
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm40_0057_popup2
boolean visible = false
integer x = 1915
boolean originalsize = false
string picturename = "C:\erpman\image\처리_up.gif"
end type

type p_choose from w_inherite_popup`p_choose within w_sm40_0057_popup2
integer x = 1486
integer y = 28
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_choose::ue_lbuttondown;//
PictureName = 'C:\erpman\image\처리_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\처리_up.gif'
end event

event p_choose::clicked;call super::clicked;string sDatef, sDatet, sNull, sCvcod1, sCvcod2, sIoJpno, smsg, sSaupj
Long   nRow, nCnt

SetNull(sNull)

If dw_jogun.AcceptText() <> 1 then Return

nRow  = dw_jogun.GetRow()
If nRow <=0 Then Return

sSaupj  = Trim(dw_jogun.GetItemString(nRow,'saupj'))
sDatef  = Trim(dw_jogun.GetItemString(nRow,'sdatef'))
sDatet  = Trim(dw_jogun.GetItemString(nRow,'sdatet'))
sCvcod1 = Trim(dw_jogun.GetItemString(nRow,'cvcod1'))
sCvcod2 = Trim(dw_jogun.GetItemString(nRow,'cvcod2'))

dw_jogun.SetFocus()
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_jogun.SetColumn('saupj')
	Return
End If

If IsNull(sCvcod1) or sCvcod1 = '' Then
	f_message_chk(1400,'[변경전 거래처]')
	dw_jogun.SetColumn('cvcod1')
	Return
End If

If IsNull(sCvcod2) or sCvcod2 = '' Then
	f_message_chk(1400,'[변경후 거래처]')
	dw_jogun.SetColumn('cvcod2')
	Return
End If

If IsNull(sdatef) Or sdatef = '' Then
  f_message_chk(1400,'[출고기간]')
	dw_jogun.SetColumn('sdatef')
	Return 
End If

If IsNull(sdatet) Or sdatet = '' Then
  f_message_chk(1400,'[출고기간]')
	dw_jogun.SetColumn('sdatet')
	Return 
End If

/* 매출마감여부 확인 */
If wf_junpyo_closing(Left(sDatef,6)) > 0 Then
	dw_jogun.SetItem(1,'sdatef',sNull)
	dw_jogun.SetColumn('sdatef')
	return 1
End If

If wf_junpyo_closing(Left(sDatet,6)) > 0 Then
	dw_jogun.SetItem(1,'sdatet',sNull)
	dw_jogun.SetColumn('sdatet')
	return 1
End If

IF MessageBox("출고처 조정","해당 기간동안 출고된 거래처를 일괄조정합니다." +"~n~n" +&
                    	 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

nCnt = sqlca.FUN_ERP100000018(gs_sabu, sdatef, sdatet, scvcod1, scvcod2, sSaupj)
If sqlca.sqlcode = 0 then
  commit;
  f_message_chk(202,'[처리건수 : ' +String(nCnt) + ']')
  
  Close(parent)
Else
	smsg = sqlca.sqlerrtext
	RollBack;
	f_message_chk(57,smsg)
	Return	
End If



end event

type dw_1 from w_inherite_popup`dw_1 within w_sm40_0057_popup2
boolean visible = false
integer x = 14
integer y = 216
integer width = 1815
integer height = 552
integer taborder = 100
string dataobject = "d_sal_02130"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm40_0057_popup2
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm40_0057_popup2
end type

type cb_return from w_inherite_popup`cb_return within w_sm40_0057_popup2
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm40_0057_popup2
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm40_0057_popup2
end type

type st_1 from w_inherite_popup`st_1 within w_sm40_0057_popup2
end type

