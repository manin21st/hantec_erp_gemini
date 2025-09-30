$PBExportHeader$w_itmbuy2_popup.srw
$PBExportComments$** 거래처 관리품목 조회 선택
forward
global type w_itmbuy2_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_itmbuy2_popup
end type
type rr_1 from roundrectangle within w_itmbuy2_popup
end type
end forward

global type w_itmbuy2_popup from w_inherite_popup
integer x = 169
integer y = 588
integer width = 3447
integer height = 1844
string title = "관리 품목 조회 선택"
dw_2 dw_2
rr_1 rr_1
end type
global w_itmbuy2_popup w_itmbuy2_popup

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_saupj, ls_cvcod, ls_itnbr


/////////////////////////////////////////////////////////////////////////
dw_2.acceptText()

ls_saupj	= dw_2.GetItemString(1, "saupj")
ls_cvcod	= dw_2.GetItemString(1, "cvcod")
ls_itnbr	= dw_2.GetItemString(1, "itnbr")

if	isnull(ls_cvcod) or ls_cvcod = "" then
	ls_cvcod 	= ls_cvcod + '%'
end if

if	isnull(ls_itnbr) or ls_itnbr = "" then
	ls_itnbr 	= '%'
end if

if 	dw_1.Retrieve(gs_sabu, ls_saupj, ls_cvcod+'%', ls_itnbr + '%') <= 0 then
	dw_2.Setcolumn(1)
	dw_2.Setfocus()
	return -1
end if	




return 1

end function

on w_itmbuy2_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_itmbuy2_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;string sitdsc, sispec, sjijil, scvnas, ls_cvcod, ls_itnbr

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
  
SELECT "ITDSC", "ISPEC", "JIJIL"  
  INTO :sitdsc, :sispec, :sjijil
  FROM "ITEMAS"  
 WHERE "ITNBR" = :gs_code   ;

SELECT CVNAS2 
  INTO :scvnas
  FROM VNDMST
 WHERE CVCOD = :gs_codename ;

dw_2.insertrow(0)
dw_2.setitem(1, 'cvcod', gs_codename)

dw_2.setitem(1, 'cvnas', scvnas)
dw_2.setitem(1, 'itnbr', gs_code)
dw_2.setitem(1, 'itdsc', sitdsc)
dw_2.setitem(1, 'ispec', sispec)
dw_2.setitem(1, 'jijil', sjijil)

ls_cvcod	= gs_codename
ls_itnbr	= gs_code

/* User별 사업장 Setting */
setnull(gs_code)
f_mod_saupj(dw_jogun, 'saupj')

if	isnull(ls_cvcod) or ls_cvcod = "" then
	ls_cvcod 	= ls_cvcod + '%'
end if

if	isnull(ls_itnbr) or ls_itnbr = "" then
	ls_itnbr 	=  '%'
end if

// - Data Retrieve.
dw_1.Retrieve(gs_sabu, gs_saupj, ls_cvcod, ls_itnbr ) 

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmbuy2_popup
boolean visible = false
integer x = 151
integer y = 1184
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_itmbuy2_popup
integer x = 3269
integer y = 12
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmbuy2_popup
integer x = 2921
integer y = 12
end type

event p_inq::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)
IF 	wf_retrieve() = -1 THEN
	f_message_chk(50,'[관리품번]')
	SetPointer(Arrow!)
	Return
End If	
dw_1.scrolltorow(1)
SetPointer(Arrow!)	

end event

type p_choose from w_inherite_popup`p_choose within w_itmbuy2_popup
integer x = 3095
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemString(ll_Row, "itnbr")) 

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmbuy2_popup
integer x = 59
integer y = 196
integer width = 3346
integer height = 1540
integer taborder = 10
string dataobject = "d_itmbuy2_popup"
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

gs_code = string(dw_1.GetItemString(Row, "itnbr")) 

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itmbuy2_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmbuy2_popup
integer x = 1417
integer y = 1984
end type

type cb_return from w_inherite_popup`cb_return within w_itmbuy2_popup
integer x = 1737
integer y = 1984
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmbuy2_popup
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmbuy2_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_itmbuy2_popup
boolean visible = false
end type

type dw_2 from datawindow within w_itmbuy2_popup
event ue_presenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer width = 2880
integer height = 176
boolean bringtotop = true
string dataobject = "d_itmbuy2_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_presenter;Send(Handle(this),256,9,0)
Return 1

end event

event ue_key;IF 	keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow     = GetRow()
If 	nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "cvcod"
		open(w_vndmst_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN

		SetColumn("cvcod")
		SetItem(nRow,"cvcod",gs_code)
		PostEvent(ItemChanged!)
		
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = GetText()
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "ispec", "jijil"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose
end event

event itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode
Decimal snull
Long    nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(snull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 거래처코드 */
	Case "cvcod"
		sitnbr = trim(GetText())	
		Select cvnas2, cvgu into :sitdsc, :sispec
		  	from vndmst
		 	Where cvcod = :sitnbr;
	   	If 	sqlca.sqlcode <> 0 then
			Messagebox("거래처", "코드가 없읍니다", stopsign!)
			setitem(1, "cvcod", snull)
			setitem(1, "cvnas", snull)			
			return 1			
		End if
		setitem(1, "cvnas", sitdsc)
		
	Case	"itnbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF 	SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
			Return 1
		END IF
	
		SetItem(nRow,"itdsc",   sItDsc)
		SetItem(nRow,"ispec",   sIspec)
		SetItem(nRow,"jijil",   sJijil)
		
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If 	IsNull(sItnbr) Then
			f_message_chk(33,'[품명]')
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			f_message_chk(33,'[품명]')
			SetColumn("itemas_itdsc")
			Return 1
		End If
		
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If 	IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			f_message_chk(33,'[품명]')
			SetColumn("itemas_ispec")
			Return 1
		End If		
		
	/* 재질 */
	Case "jijil"
		sjijil = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If 	IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			f_message_chk(33,'[품명]')
			SetColumn("itemas_jijil")
			Return 1
		End If	
END Choose

end event

type rr_1 from roundrectangle within w_itmbuy2_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 184
integer width = 3378
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

