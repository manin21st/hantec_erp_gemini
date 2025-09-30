$PBExportHeader$w_sm04_00050_popup01.srw
$PBExportComments$반품송장 조회 popup
forward
global type w_sm04_00050_popup01 from w_inherite_popup
end type
type dw_2 from datawindow within w_sm04_00050_popup01
end type
type rr_1 from roundrectangle within w_sm04_00050_popup01
end type
end forward

global type w_sm04_00050_popup01 from w_inherite_popup
integer x = 27
integer y = 4
integer width = 3717
integer height = 1936
string title = "입출고이력"
boolean controlmenu = true
dw_2 dw_2
rr_1 rr_1
end type
global w_sm04_00050_popup01 w_sm04_00050_popup01

type variables
string is_Juncrt , is_iogbn1, is_iogbn2
end variables

on w_sm04_00050_popup01.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm04_00050_popup01.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;String ls_today 

ls_today = f_today()

dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)
dw_2.setitem(1, 'fr_date', f_afterday(ls_today , -30))
dw_2.setitem(1, 'to_date', ls_today )

dw_1.SetTransObject(Sqlca)
If gs_gubun = '1'  Then
	is_iogbn1 = 'OY2'
	is_iogbn2 = ''
	is_Juncrt = '024'
ElseIf gs_gubun = '4' Then
	is_iogbn1 = 'OY2'
	is_iogbn2 = ''
	is_Juncrt = '037'
ElseIf gs_gubun = '5' Then
	is_iogbn1 = 'O18'
	is_iogbn2 = ''
	is_Juncrt = '001'
ElseIf gs_gubun = '2' Then
	is_iogbn1 = 'O41'
	is_iogbn2 = 'O4A'
	is_Juncrt = '005'
Else
	is_iogbn1 = 'OY3'
	is_iogbn2 = ''
	is_Juncrt = '036'
//	is_iogbn1 = 'OY5'
//	is_iogbn2 = 'OY6'
//	is_Juncrt = '036'
End If

dw_1.Retrieve(gs_sabu , f_afterday(ls_today , -30)  , ls_today , is_iogbn1,is_iogbn2 , is_Juncrt,'%%',gs_saupj)
//dw_1.Retrieve(gs_sabu , left(ls_today, 6) + '01' , ls_today , is_iogbn1,is_iogbn2 , is_Juncrt,'%%',gs_saupj)
dw_2.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm04_00050_popup01
integer x = 23
integer y = 2620
end type

type p_exit from w_inherite_popup`p_exit within w_sm04_00050_popup01
integer x = 3493
integer y = 36
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm04_00050_popup01
integer x = 3145
integer y = 36
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet,sarea,scvcod,sItnbr, sSaupj

If dw_2.AcceptText() <> 1 Then Return 1

sdatef = dw_2.GetItemString(1,"fr_date")
sdatet = dw_2.GetItemString(1,"to_date")
scvcod = dw_2.GetItemString(1,"cvcod")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

If IsNull(sCvcod) Then sCVcod = ''

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet, is_iogbn1,is_iogbn2 , is_Juncrt,sCVcod+'%',gs_saupj) <= 0 THEN
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF


dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_sm04_00050_popup01
integer x = 3319
integer y = 36
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "iojpno")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm04_00050_popup01
integer x = 55
integer y = 220
integer width = 3589
integer height = 1568
string dataobject = "d_sm04_00050_popup01_a"
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

gs_code= dw_1.GetItemString(Row, "iojpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sm04_00050_popup01
boolean visible = false
integer x = 1015
integer y = 372
integer width = 1001
integer height = 40
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm04_00050_popup01
integer x = 2048
integer y = 2296
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code= dw_1.GetItemString(ll_Row, "iojpno")
//
//Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_sm04_00050_popup01
integer x = 2670
integer y = 2296
integer taborder = 40
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sm04_00050_popup01
integer x = 2359
integer y = 2296
integer taborder = 20
boolean default = false
end type

event cb_inq::clicked;call super::clicked;//String sdatef,sdatet,sarea,scvcod,sItnbr, sSaupj
//
//If dw_2.AcceptText() <> 1 Then Return 1
//
//sdatef = dw_2.GetItemString(1,"fr_date")
//sdatet = dw_2.GetItemString(1,"to_date")
//sarea  = dw_2.GetItemString(1,"sarea")
//scvcod = dw_2.GetItemString(1,"cvcod")
//sSaupj = dw_2.GetItemString(1,"saupj")
//
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400,'[부가사업장]')
//	Return
//End If
//
//IF sdatef ="" OR IsNull(sdatef) THEN
//	sdatef ='.'
//END IF
//
//IF sdatet = "" OR IsNull(sdatet) THEN
//	sdatet ='99999999'
//END IF
//
//IF sarea  = "" OR IsNull(sarea) THEN	sarea =''
//IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''
//
//IF sdatet < sdatef THEN
//	f_message_chk(34,'[기간]')
//	dw_2.SetColumn("fr_date")
//	dw_2.SetFocus()
//	Return
//END IF
//
//IF dw_1.Retrieve(gs_sabu,sdatef,sdatet, isJunCrt1,isJunCrt2,sarea+'%',scvcod+'%', sSaupj) <= 0 THEN
//	dw_2.SetColumn("fr_date")
//	dw_2.SetFocus()
//	Return
//END IF
//
//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_sm04_00050_popup01
boolean visible = false
integer x = 352
integer y = 372
integer width = 425
integer height = 40
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_sm04_00050_popup01
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_sm04_00050_popup01
event ue_processenter pbm_dwnprocessenter
integer x = 37
integer y = 24
integer width = 2638
integer height = 184
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sm04_00050_popup01_1"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String snull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow

SetNull(snull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case "fr_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "to_date", sNull)
			return 1
		END IF
	/* 관할구역 */
	Case 'sarea'
		SetItem(nRow,'cvcod',sNull)
		SetItem(nRow,'cvcodnm',sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"saupj",   	ssaupj)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			SetItem(1,"saupj",   ssaupj)
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
END Choose
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type rr_1 from roundrectangle within w_sm04_00050_popup01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 212
integer width = 3616
integer height = 1592
integer cornerheight = 40
integer cornerwidth = 55
end type

