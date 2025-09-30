$PBExportHeader$w_imhist_02047_popup.srw
$PBExportComments$출고 조회 (미수주)
forward
global type w_imhist_02047_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_imhist_02047_popup
end type
type pb_1 from u_pb_cal within w_imhist_02047_popup
end type
type pb_2 from u_pb_cal within w_imhist_02047_popup
end type
type rr_1 from roundrectangle within w_imhist_02047_popup
end type
end forward

global type w_imhist_02047_popup from w_inherite_popup
integer x = 5
integer y = 272
integer width = 3648
integer height = 2084
string title = "출고번호조회"
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imhist_02047_popup w_imhist_02047_popup

type variables
string isJuncrt1, isJuncrt2
end variables

on w_imhist_02047_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_imhist_02047_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;/* --------------------------------------------------------------------------- */
/*            gs_gubun      gs_codename  datawindow                            */
/*          (전표생성구분)                                                     */
/* --------------------------------------------------------------------------  */
/* 판매출고      004            B        d_imhist_02040_popup1   출고확인전/후 */
/* 판매출고      004            A        d_imhist_02040_popup2   출고확인후    */
/* --------------------------------------------------------------------------- */

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_2.Insertrow(0)
dw_2.SetFocus()


// 부가세 사업장 설정
f_mod_saupj(dw_2, 'saupj')

// 관할구역 설정
f_child_saupj(dw_2, 'sarea', gs_saupj)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhist_02047_popup
integer x = 14
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_imhist_02047_popup
integer x = 3456
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imhist_02047_popup
integer x = 3109
integer y = 8
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet,sarea,scvcod,sItnbr,ls_saupj
Long   nCnt

If dw_2.AcceptText() <> 1 Then Return 1

sdatef = dw_2.GetItemString(1,"fr_date")
sdatet = dw_2.GetItemString(1,"to_date")
sarea  = dw_2.GetItemString(1,"sarea")
scvcod = dw_2.GetItemString(1,"cvcod")
ls_saupj = dw_2.getitemstring(1,'saupj')

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

if ls_saupj = "" or isnull(ls_saupj) then
	f_message_chk(30,'[부가사업장]')
	dw_2.setcolumn('saupj')
	dw_2.setfocus()
	return
end if
	
IF sarea  = "" OR IsNull(sarea) THEN	sarea =''
IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

 nCnt = dw_1.Retrieve(gs_sabu,sdatef,sdatet, sarea+'%',scvcod+'%',ls_saupj)


If nCnt <= 0 THEN
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_imhist_02047_popup
integer x = 3282
integer y = 8
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

type dw_1 from w_inherite_popup`dw_1 within w_imhist_02047_popup
integer x = 41
integer y = 300
integer width = 3579
integer height = 1664
string dataobject = "d_imhist_02047_popup1"
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

gs_code= dw_1.GetItemString(Row, "iojpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_imhist_02047_popup
boolean visible = false
integer x = 1015
integer y = 152
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhist_02047_popup
integer x = 2327
integer y = 2144
end type

type cb_return from w_inherite_popup`cb_return within w_imhist_02047_popup
integer x = 2949
integer y = 2144
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_imhist_02047_popup
integer x = 2638
integer y = 2144
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imhist_02047_popup
boolean visible = false
integer x = 352
integer y = 152
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imhist_02047_popup
boolean visible = false
integer x = 82
integer y = 172
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_imhist_02047_popup
event ue_processenter pbm_dwnprocessenter
integer x = 14
integer y = 32
integer width = 2377
integer height = 236
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imhist_02047"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow

SetNull(snull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
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
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', 	sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
END Choose
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type pb_1 from u_pb_cal within w_imhist_02047_popup
integer x = 704
integer y = 60
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('fr_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'fr_date', gs_code)

end event

type pb_2 from u_pb_cal within w_imhist_02047_popup
integer x = 1161
integer y = 60
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('to_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'to_date', gs_code)

end event

type rr_1 from roundrectangle within w_imhist_02047_popup
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 284
integer width = 3602
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

