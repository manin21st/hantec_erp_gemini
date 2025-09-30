$PBExportHeader$w_sm40_0057_popup3.srw
$PBExportComments$거래처 일괄변경
forward
global type w_sm40_0057_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sm40_0057_popup3
end type
end forward

global type w_sm40_0057_popup3 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 2743
integer height = 1444
string title = "일검수통보서 내역"
rr_1 rr_1
end type
global w_sm40_0057_popup3 w_sm40_0057_popup3

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

on w_sm40_0057_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sm40_0057_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;ist_code = message.powerobjectparm

f_window_center_response(this) 

Long lCount
String ls_factory , ls_itnbr , ls_yymm , ls_sdate , ls_edate , ls_saupj ,ls_custcd ,ls_orderno
dw_1.SetTransObject(SQLCA)


ls_itnbr   = Trim(ist_code.code[1]) 
ls_factory = Trim(ist_code.sgubun1[1]) 
ls_yymm    = Trim(ist_code.sgubun2[1]) 
ls_saupj   = Trim(ist_code.sgubun3[1]) 

ls_orderno   = Trim(ist_code.sgubun4[1])

ls_sdate = ls_yymm+'01' 
ls_edate = f_last_date(ls_sdate)

lCount = dw_1.retrieve(ls_saupj,  ls_factory, ls_sdate , ls_edate , ls_itnbr , ls_orderno )

if lCount < 1 then
	Messagebox("D1 내역", "조회할 내역이 없읍니다", stopsign!)
	Close(This)
	return
end if

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm40_0057_popup3
boolean visible = false
integer x = 14
integer y = 284
integer width = 2674
integer height = 1112
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
			SetItem(1,"saupj",   	ssaupj)
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
			SetItem(1,"saupj",    ssaupj)
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
			SetItem(1,"saupj",   	ssaupj)
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
			SetItem(1,"saupj",    ssaupj)
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

type p_exit from w_inherite_popup`p_exit within w_sm40_0057_popup3
integer x = 2514
integer y = 32
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm40_0057_popup3
boolean visible = false
integer x = 1915
boolean originalsize = false
string picturename = "C:\erpman\image\처리_up.gif"
end type

type p_choose from w_inherite_popup`p_choose within w_sm40_0057_popup3
boolean visible = false
integer x = 2341
integer y = 32
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_choose::ue_lbuttondown;//
PictureName = 'C:\erpman\image\처리_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\처리_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm40_0057_popup3
integer x = 14
integer y = 212
integer width = 2674
integer height = 1108
integer taborder = 100
string dataobject = "d_sm40_0057_popup3"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm40_0057_popup3
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm40_0057_popup3
end type

type cb_return from w_inherite_popup`cb_return within w_sm40_0057_popup3
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm40_0057_popup3
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm40_0057_popup3
end type

type st_1 from w_inherite_popup`st_1 within w_sm40_0057_popup3
end type

type rr_1 from roundrectangle within w_sm40_0057_popup3
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 5
integer y = 204
integer width = 2697
integer height = 1136
integer cornerheight = 40
integer cornerwidth = 55
end type

