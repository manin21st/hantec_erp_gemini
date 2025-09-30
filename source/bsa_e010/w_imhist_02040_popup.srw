$PBExportHeader$w_imhist_02040_popup.srw
$PBExportComments$출고송장 조회 선택(판매/무상출고송장)
forward
global type w_imhist_02040_popup from w_inherite_popup
end type
type pb_2 from u_pb_cal within w_imhist_02040_popup
end type
type pb_1 from u_pb_cal within w_imhist_02040_popup
end type
type rr_1 from roundrectangle within w_imhist_02040_popup
end type
end forward

global type w_imhist_02040_popup from w_inherite_popup
integer x = 5
integer y = 272
integer width = 3666
integer height = 2056
string title = "출고송장 조회 선택"
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_imhist_02040_popup w_imhist_02040_popup

type variables
string isJuncrt1, isJuncrt2
end variables

on w_imhist_02040_popup.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_imhist_02040_popup.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;/* --------------------------------------------------------------------------- */
/*            gs_gubun      gs_codename  datawindow                            */
/*          (전표생성구분)                                                     */
/* --------------------------------------------------------------------------  */
/* 판매출고      004            B        d_imhist_02040_popup1   출고확인전/후 */
/* 판매출고      004            A        d_imhist_02040_popup2   출고확인후    */
/* 판매출고      037            C        d_imhist_02040_popup6   출고등록(유상사급)    */
/* 기타매출      024            B        d_imhist_02040_popup5                 */
/* 무상출고      001            B        d_imhist_02040_popup3   출고확인전/후 */
/* 무상출고      001            A        d_imhist_02040_popup4   출고확인후    */
/* 반품출고      005            B        d_imhist_02040_popup1   출고확인전 => 미사용 */
/* 반품출고      005            A        d_imhist_02040_popup2   출고확인후 => 미사용 */
/* --------------------------------------------------------------------------- */
If Left(Gs_Gubun,3) = '005' Then 
	MessageBox('지원안함','종료하세요')
	Close(This)
	Return
End If

If Trim(Gs_Gubun) = '024'  Then
  If gs_codename = 'A' Then
	 dw_1.dataobject = 'd_imhist_02040_popup5'
  Else
	 dw_1.dataobject = 'd_imhist_02040_popup5'
  End If
ElseIf Left(Gs_Gubun,3) = '004' Then
  If gs_codename = 'A' Then
	 dw_1.dataobject = 'd_imhist_02040_popup2'
  Else
	 dw_1.dataobject = 'd_imhist_02040_popup1'
  End If
ElseIf Left(Gs_Gubun,3) = '037' Then
  If gs_codename = 'A' Then
	 dw_1.dataobject = 'd_imhist_02040_popup22'
  Else
	 dw_1.dataobject = 'd_imhist_02040_popup11'
  End If
ElseIf Left(Gs_Gubun,3) = '001' Then
  If gs_codename = 'A' Then
	 dw_1.dataobject = 'd_imhist_02040_popup4'
  Else
	 dw_1.dataobject = 'd_imhist_02040_popup3'
  End If
ElseIf Left(Gs_Gubun,3) = 'ALL' Then
	dw_1.dataobject = 'd_imhist_02040_popup7'
Else
//	MessageBox('지원안함',gs_gubun)
	Close(This)
	Return
End If

dw_1.SetTransObject(SQLCA)
dw_jogun.SetTransObject(SQLCA)
// 관할구역 설정
f_child_saupj(dw_jogun, 'sarea', gs_saupj)
dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'cvcod',gs_code)

If Left(Gs_Gubun,3) = 'ALL' Then
   dw_jogun.setitem(1, 'gub', '004' )
	isJunCrt1 = '004'
	isJunCrt2 = '001'
ElseIf Len(gs_gubun) = 3 Then
   dw_jogun.setitem(1, 'gub', gs_gubun )
	isJunCrt1 = gs_gubun
	isJunCrt2 = gs_gubun
End If

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())


/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If
dw_jogun.SetItem(1, 'sarea', sarea)

// 부가세 사업장 설정 - 통제 해제(통합사업장 관련으로 인해 선택가능) - BY SHINGOON 2016.02.26
//f_mod_saupj(dw_jogun, 'saupj')
dw_jogun.SetItem(1, 'saupj', gs_saupj)

dw_jogun.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhist_02040_popup
integer x = 14
integer y = 28
integer width = 2373
integer height = 324
string dataobject = "d_imhist_02040"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1, sItnbr, sItdsc
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
//			SetItem(1,"sarea",   sarea)
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
//			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', 	sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = Trim(GetTexT())
		IF sItnbr = "" OR IsNull(sItnbr) THEN
			SetItem(1, "itdsc", snull)
			Return
		END IF
		
		SELECT NVL(ITDSC, NULL)
		   INTO :sItdsc
		 FROM  ITEMAS
	    WHERE ITNBR = :sItnbr; 
		 
		IF sqlca.sqlcode = 0 then
			SetItem(1, "itdsc" , sItdsc)
		ELSE
			SetItem(1, "itnbr", snull)
			SetItem(1, "itdsc" , snull)
		END IF
		
		
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
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
		
	Case "itnbr"
		gs_gubun = '1'
		If GetColumnName() = "itdsc" then
			gs_codename = Trim(GetText())
		End If
		Open(w_itemas_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr", gs_code)
		SetItem(1,"itdsc" , gs_codename)
		SetColumn("itnbr")
		
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_imhist_02040_popup
integer x = 3360
integer y = 40
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imhist_02040_popup
integer x = 3013
integer y = 40
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet,sarea,scvcod,sItnbr,ls_saupj
Long   nCnt

If dw_jogun.AcceptText() <> 1 Then Return 1

sdatef = dw_jogun.GetItemString(1,"fr_date")
sdatet = dw_jogun.GetItemString(1,"to_date")
sarea  = dw_jogun.GetItemString(1,"sarea")
scvcod = dw_jogun.GetItemString(1,"cvcod")
ls_saupj = dw_jogun.getitemstring(1,'saupj')
sitnbr = dw_jogun.GetItemString(1, "itnbr")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

if ls_saupj = "" or isnull(ls_saupj) then
	f_message_chk(30,'[부가사업장]')
	dw_jogun.setcolumn('saupj')
	dw_jogun.setfocus()
	return
end if
	
IF sarea  = "" OR IsNull(sarea) THEN	sarea =''
IF scvcod = "" OR IsNull(scvcod) THEN	scvcod =''
IF sitnbr  = "" OR IsNull(sitnbr) THEN sitnbr = ''

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF



If isJunCrt1 = '001' Then
  nCnt = dw_1.Retrieve(gs_sabu,sdatef,sdatet, sarea+'%',scvcod+'%', sitnbr+'%') /* 무상출고 */
Else
  nCnt = dw_1.Retrieve(gs_sabu,sdatef,sdatet, isJunCrt1,isJunCrt2,sarea+'%',scvcod+'%',ls_saupj,sitnbr+'%')
End If

If nCnt <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_imhist_02040_popup
integer x = 3186
integer y = 40
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

type dw_1 from w_inherite_popup`dw_1 within w_imhist_02040_popup
integer x = 37
integer y = 372
integer width = 3575
integer height = 1568
string dataobject = "d_imhist_02040_popup1"
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

type sle_2 from w_inherite_popup`sle_2 within w_imhist_02040_popup
boolean visible = false
integer x = 1010
integer y = 2164
integer width = 1001
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhist_02040_popup
boolean visible = false
integer x = 320
integer y = 2368
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_imhist_02040_popup
boolean visible = false
integer x = 942
integer y = 2368
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_imhist_02040_popup
boolean visible = false
integer x = 631
integer y = 2368
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imhist_02040_popup
boolean visible = false
integer x = 347
integer y = 2164
integer width = 425
boolean enabled = false
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imhist_02040_popup
boolean visible = false
integer x = 78
integer y = 2184
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_2 from u_pb_cal within w_imhist_02040_popup
integer x = 709
integer y = 52
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('fr_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'fr_date', gs_code)

end event

type pb_1 from u_pb_cal within w_imhist_02040_popup
integer x = 1161
integer y = 52
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('to_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'to_date', gs_code)

end event

type rr_1 from roundrectangle within w_imhist_02040_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 360
integer width = 3611
integer height = 1616
integer cornerheight = 40
integer cornerwidth = 55
end type

