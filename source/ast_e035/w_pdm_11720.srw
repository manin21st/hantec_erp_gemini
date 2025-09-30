$PBExportHeader$w_pdm_11720.srw
$PBExportComments$외주bom등록
forward
global type w_pdm_11720 from w_inherite
end type
type dw_head from u_key_enter within w_pdm_11720
end type
type cbx_1 from checkbox within w_pdm_11720
end type
type p_2 from uo_picture within w_pdm_11720
end type
type rr_2 from roundrectangle within w_pdm_11720
end type
type rr_1 from roundrectangle within w_pdm_11720
end type
end forward

global type w_pdm_11720 from w_inherite
string tag = "외주BOM등록"
integer width = 4635
integer height = 2432
string title = "외주BOM등록"
dw_head dw_head
cbx_1 cbx_1
p_2 p_2
rr_2 rr_2
rr_1 rr_1
end type
global w_pdm_11720 w_pdm_11720

type variables
Long il_dragsource, il_droptarget, il_prvtarget, il_dragparent, il_crttree
String iSlabel[], iSdata[]
Integer iIpic[], iISel[], iIlevel[], Iicnt
Boolean iBchild[], iBflash
Str_pstruc wstruc_str
String is_masterno   // 현재품목의 상위품번
sTRING is_cvcod
end variables

forward prototypes
public function integer wf_estupdate ()
end prototypes

public function integer wf_estupdate ();

Long Lrow

For Lrow = 1 to dw_insert.rowcount()
	 If Len(dw_insert.getitemstring(Lrow, "wstruc_usseq")) <> 5 then
		 MessageBox("사용번호", "사용번호는 다섯자리입니다(ex:00030)", stopsign!)
		 dw_insert.setcolumn("wstruc_usseq")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if
	 
	 If isnull(dw_insert.getitemstring(Lrow, "wstruc_cinbr")) or &
	    Trim(dw_insert.getitemstring(Lrow, "wstruc_cinbr"))  = '' then
		 MessageBox("품목번호", "품목번호는 필수입니다.", stopsign!)
		 dw_insert.setcolumn("wstruc_cinbr")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if	
	 
	 If dw_insert.getitemdecimal(Lrow, "wstruc_qtypr")  = 0 then
		 MessageBox("구성수량", "구성수량은 필수입니다.", stopsign!)
		 dw_insert.setcolumn("wstruc_qtypr")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if	
	 
	 If f_datechk(dw_insert.getitemstring(Lrow, "wstruc_efrdt")) = -1  then
		 MessageBox("적용시작일", "일자가 부정확합니다..", stopsign!)
		 dw_insert.setcolumn("wstruc_efrdt")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if		 
	 
	 If f_datechk(dw_insert.getitemstring(Lrow, "wstruc_eftdt")) = -1  then
		 IF dw_insert.getitemstring(Lrow, "wstruc_eftdt") <> '99999999' THEN		 
			 MessageBox("적용완료일", "일자가 부정확합니다..", stopsign!)
			 dw_insert.setcolumn("wstruc_eftdt")
			 dw_insert.setrow(Lrow)
			 dw_insert.scrolltorow(Lrow)
			 dw_insert.setfocus()
			 return -1
		 End if
	 End if	
	 
	 if isnull(dw_insert.getitemstring(Lrow, "wstruc_opsno")) or &
	    Trim(dw_insert.getitemstring(Lrow, "wstruc_opsno")) = '' then
	 	 dw_insert.setitem(Lrow, "wstruc_opsno", '9999')
 
	 End if
NExt

return 1
end function

on w_pdm_11720.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.cbx_1=create cbx_1
this.p_2=create p_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_pdm_11720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.cbx_1)
destroy(this.p_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;
cbx_1.text = '상세'
dw_insert.Modify("DataWindow.Header.Height=68")		
dw_insert.Modify("DataWindow.Detail.Height=72")		
   
postevent("ue_open")
end event

event ue_open;call super::ue_open;dw_head.settransobject(sqlca)
dw_insert.settransobject(sqlca)

p_can.triggerevent(clicked!)

dw_head.setcolumn("itnbr")
dw_head.setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_pdm_11720
integer x = 18
integer y = 436
integer width = 4590
integer height = 1808
string dataobject = "d_pdm_11720_4"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then
	cbx_1.enabled = true
	
	p_mod.enabled    = true
	p_addrow.enabled = true
	p_delrow.enabled = true

	p_mod.picturename    = "C:\erpman\image\저장_up.gif"
	p_addrow.picturename = "C:\erpman\image\행추가_up.gif"
	p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"
	
Else
	cbx_1.enabled = false
End if
end event

event dw_insert::retrievestart;call super::retrievestart;cbx_1.text = '상세'
cbx_1.checked = false
dw_insert.Modify("DataWindow.Header.Height=68")		
dw_insert.Modify("DataWindow.Detail.Height=72")		
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "wstruc_cinbr"

		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"wstruc_cinbr",gs_code)
		PostEvent(ItemChanged!)
	 Case "wstruc_opsno"
			OpenWithParm(w_routng_popup,is_masterno)
			IF IsNull(Gs_Code) THEN RETURN
			this.SetItem(nrow,"wstruc_opsno",Gs_Code)
			this.setcolumn("wstruc_opsno")
			triggerevent(itemchanged!)
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode,snull,sopsno
Long    nRow, Lprv

SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"wstruc_cinbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
			SetItem(nRow,"wstruc_cinbr",   snull)			
			SetItem(nRow,"itemas_itemas_itdsc",   snull)
			SetItem(nRow,"itemas_itemas_ispec",   snull)
			SetItem(nRow,"itemas_itemas_jijil",   snull)
			Return 1
		END IF
	
		SetItem(nRow,"itemas_itemas_itdsc",   sItDsc)
		SetItem(nRow,"itemas_itemas_ispec",   sIspec)
		SetItem(nRow,"itemas_itemas_jijil",   sJijil)
	/* 규격 */
	Case "itemas_itemas_itdsc"
		sItdsc = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"wstruc_cinbr",sItnbr)
			SetColumn("wstruc_cinbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,"itemas_itemas_itdsc",   snull)
			SetItem(nRow,"itemas_itemas_ispec",   snull)
			SetItem(nRow,"itemas_itemas_jijil",   snull)
			SetColumn("itemas_itemas_itdsc")
			Return 1
		End If		
	Case	"wstruc_opsno" 
		sopsno = gettext()
		SELECT opdsc
		  INTO :sItDsc
		  FROM routng
		 WHERE itnbr = :is_masterno And opseq = :sopsno;

		IF SQLCA.SQLCODE <> 0 THEN

			MessageBox("공정", "품목에 정의되지 않은 공정입니다.", stopsign!)
			SetItem(nRow,"wstruc_opsno",  '9999')
			SetItem(nRow,"routng_opdsc",   snull)
			Return 1
		END IF
	
			SetItem(nRow,"routng_opdsc",   sitdsc)		
	Case	"wstruc_efrdt" 
		sopsno = gettext()		
		if f_datechk(sopsno) = -1 then
			MessageBox("확인", "시작일자가 부정확합니다", stopsign!)
			setitem(nrow, "wstruc_efrdt", f_today())
			return 1
		End if
	Case	"wstruc_eftdt" 
		sopsno = gettext()
		if f_datechk(sopsno) = -1 then
			MessageBox("확인", "시작일자가 부정확합니다", stopsign!)
			setitem(nrow, "wstruc_eftdt", '99991231')
			return 1
		End if
	Case	"wstruc_gubun" 
		If Nrow = 1 then
			MessageBox("대체", "첫번째 행은 대체품목으로 지정될 수 없읍니다", stopsign!)
			setitem(nrow, "wstruc_gubun", '1')
			return 1
		End if
		sopsno = gettext()
		if sopsno = '2' then
			For Lprv = nrow - 1 to 1 step -1
				if getitemstring(Lprv, "wstruc_gubun") = '1' then
					setitem(nrow, "wstruc_usseq", getitemstring(Lprv, "wstruc_usseq"))
					setitem(nrow, "wstruc_dcinbr", getitemstring(Lprv, "wstruc_cinbr"))
					Exit
				End if
			Next
		Else	
			setitem(nrow, "wstruc_dcinbr", snull)
		End if		
END Choose

end event

type p_delrow from w_inherite`p_delrow within w_pdm_11720
integer x = 3863
integer y = 40
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long Lrow 
String sitnbr, susseq, sSitem


Lrow = dw_insert.getrow()
if Lrow < 1 then return

sitnbr = dw_insert.getitemstring(Lrow, "wstruc_cinbr")
susseq = dw_insert.getitemstring(Lrow, "wstruc_usseq")
if isnull(sitnbr) then sitnbr = '.'

if MessageBox("삭제확인", "품번 : " + sitnbr + '~n' + &
								  "을 삭제하시겠읍니까?", question!, yesno!) = 1 then
								  
	ib_any_typing = true								  							  
	dw_insert.deleterow(Lrow)
								  
End if
end event

type p_addrow from w_inherite`p_addrow within w_pdm_11720
integer x = 3689
integer y = 40
boolean enabled = false
end type

event p_addrow::clicked;call super::clicked;long lRow, lIn

Lin  = dw_insert.getrow()
lrow = dw_insert.insertrow(Lin+1)

dw_insert.setitem(lRow, "wstruc_pinbr", is_masterno)
dw_insert.setitem(lRow, "cvcod", is_cvcod)
dw_insert.setitem(lRow, "wstruc_efrdt", f_today())
dw_insert.setcolumn("wstruc_usseq")
dw_insert.setfocus()
end event

event p_addrow::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event p_addrow::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from w_inherite`p_search within w_pdm_11720
boolean visible = false
integer x = 3369
integer y = 2428
end type

type p_ins from w_inherite`p_ins within w_pdm_11720
boolean visible = false
integer x = 3991
integer y = 2432
end type

type p_exit from w_inherite`p_exit within w_pdm_11720
integer x = 4384
integer y = 40
end type

type p_can from w_inherite`p_can within w_pdm_11720
integer x = 4210
integer y = 40
end type

event p_can::clicked;call super::clicked;dw_insert.reset()

dw_head.enabled = true
p_inq.enabled = true
p_inq.picturename = "C:\erpman\image\조회_up.gif"

p_mod.enabled = false
p_addrow.enabled = false
p_delrow.enabled = false

p_mod.picturename = "C:\erpman\image\저장_d.gif"
p_addrow.picturename = "C:\erpman\image\행추가_d.gif"
p_delrow.picturename = "C:\erpman\image\행삭제_d.gif"

cbx_1.text = '상세'
cbx_1.checked = false
cbx_1.triggerevent(clicked!)
cbx_1.enabled = false

dw_head.setredraw(false)
dw_head.reset()
dw_head.insertrow(0)
dw_head.setredraw(true)

dw_head.setfocus()
end event

type p_print from w_inherite`p_print within w_pdm_11720
boolean visible = false
integer x = 3584
integer y = 2428
end type

type p_inq from w_inherite`p_inq within w_pdm_11720
integer x = 3515
integer y = 40
end type

event p_inq::clicked;call super::clicked;if dw_head.accepttext() = -1 then return

String sitnbr, scvcod
Long Lrow

sitnbr = dw_head.getitemstring(1, "itnbr")
scvcod = dw_head.getitemstring(1, "cvcod")

is_masterno = sitnbr
is_cvcod    = scvcod

If isnull( sitnbr ) or trim( sitnbr ) = '' then
	MessageBox("품번", "품번을 입력하세요", stopsign!)
	dw_head.setcolumn("itnbr")
	dw_head.setfocus()
	return 1
end if

If isnull( scvcod ) or trim( scvcod) = '' then
	MessageBox("거래처", "거래처를 입력하세요", stopsign!)
	dw_head.setcolumn("cvcod")
	dw_head.setfocus()
	return 1
end if

Lrow = dw_insert.retrieve(sitnbr, scvcod)
If Lrow = 0 then
	Messagebox("외주BOM", "외주BOM을 신규로 입력하세요", information!)
End if

dw_head.enabled = false

p_inq.enabled = false
p_inq.picturename = "C:\erpman\image\조회_d.gif"

p_mod.enabled = true
p_addrow.enabled = true
p_delrow.enabled = true

p_mod.picturename = "C:\erpman\image\저장_up.gif"
p_addrow.picturename = "C:\erpman\image\행추가_up.gif"
p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"

cbx_1.text = '요약'
cbx_1.checked = false
cbx_1.triggerevent(clicked!)
cbx_1.enabled = false
end event

type p_del from w_inherite`p_del within w_pdm_11720
boolean visible = false
integer x = 4219
integer y = 2428
end type

type p_mod from w_inherite`p_mod within w_pdm_11720
integer x = 4037
integer y = 40
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

if messagebox("저장확인", "저장하시겠읍니까?", question!, yesno!) = 2 then return

if wf_estupdate() = -1 then
 	return
end if

if dw_insert.update() = -1 then
	rollback;
	Messagebox("저장실패", "저장중 오류발생", stopsign!)
	return
end if

commit;

ib_any_typing = false

p_can.triggerevent(clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_pdm_11720
end type

type cb_mod from w_inherite`cb_mod within w_pdm_11720
end type

type cb_ins from w_inherite`cb_ins within w_pdm_11720
end type

type cb_del from w_inherite`cb_del within w_pdm_11720
end type

type cb_inq from w_inherite`cb_inq within w_pdm_11720
end type

type cb_print from w_inherite`cb_print within w_pdm_11720
end type

type st_1 from w_inherite`st_1 within w_pdm_11720
integer x = 1422
integer y = 2484
integer width = 1582
string text = ""
end type

type cb_can from w_inherite`cb_can within w_pdm_11720
integer x = 2117
integer y = 2784
end type

type cb_search from w_inherite`cb_search within w_pdm_11720
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_11720
integer x = 910
integer y = 3244
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_11720
end type

type dw_head from u_key_enter within w_pdm_11720
event ue_key pbm_dwnkey
integer y = 16
integer width = 2519
integer height = 336
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdm_11720_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;call super::dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)

RETURN 1
end event

event rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
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
	Case "cvcod"
		open(w_vndmst_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN

		SetColumn("cvcod")
		SetItem(nRow,"cvcod",gs_code)
		PostEvent(ItemChanged!)

	Case "opseq"
		sitnbr = getitemstring(1, "itnbr")
		
		if isnull( sitnbr ) or trim( sitnbr ) = '' then 
			Messagebox("공정", "품번을 먼저선택한 후 조회 하세요", stopsign!)
			return
		End if
		
		openwithparm(w_routng_popup, sitnbr)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		SetColumn("opseq")
		SetItem(nRow,"opseq",gs_code)
		PostEvent(ItemChanged!)

END Choose
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode, snull
Decimal dnull
Long    nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(dNull)
SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"itnbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
         p_can.triggerevent(clicked!)
			Return 1
		END IF
	
		SetItem(nRow,"itdsc",   sItDsc)
		SetItem(nRow,"ispec",   sIspec)
		SetItem(nRow,"jijil",   sJijil)

	/* 규격 */
	Case "itdsc"
		sItdsc = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
         p_can.triggerevent(clicked!)			
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itemas_itdsc")
			Return 1
		End If
		
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itemas_ispec")
			Return 1
		End If		
		
	/* 재질 */
	Case "jijil"
		sjijil = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itemas_jijl")
			Return 1
		End If	
	/* 거래처코드 */
	Case "cvcod"
		sitnbr = trim(GetText())	
		Select cvnas2, cvgu into :sitdsc, :sispec
		  from vndmst
		 Where cvcod = :sitnbr;
	   If sqlca.sqlcode <> 0 then
			Messagebox("거래처", "코드가 없읍니다", stopsign!)
			setitem(1, "cvcod", snull)
			setitem(1, "cvnas", snull)			
			return 1			
		End if
		
	   If sispec <> '1' and sispec <> '2' then
			Messagebox("거래처", "거래처만 선택이 가능합니다", stopsign!)
			setitem(1, "cvcod", snull)
			setitem(1, "cvnas", snull)			
			return 1			
		End if		

		setitem(1, "cvnas", sitdsc)
	/* 공정코드 */
	Case "opseq"
		sitnbr = getitemstring(1, "itnbr")
		sitdsc = trim(GetText())	
		Select opdsc into :sispec
		  from routng
		 Where itnbr = :sitnbr and opseq = :sitdsc;
	   If sqlca.sqlcode <> 0 then
			Messagebox("공정", "코드가 없읍니다", stopsign!)
			setitem(1, "opseq", '9999')
			setitem(1, "opdsc", '전체공정')
			return 1			
		End if
	
		setitem(1, "opdsc", sispec)		
END Choose

dw_insert.reset()

cbx_1.text = '상세'
cbx_1.checked = false
cbx_1.triggerevent(clicked!)
cbx_1.enabled = false

end event

type cbx_1 from checkbox within w_pdm_11720
integer x = 983
integer y = 68
integer width = 233
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "요약"
end type

event clicked;if cbx_1.checked  then
	cbx_1.text = '요약'
	dw_insert.Modify("DataWindow.Header.Height=144")	
	dw_insert.Modify("DataWindow.Detail.Height=152")
   dw_insert.modify("wstruc_bomend.protect=0")
	dw_insert.modify("wstruc_pcbloc.protect=0")	
	dw_insert.modify("wstruc_rmks.protect=0")
else
	cbx_1.text = '상세'
	dw_insert.Modify("DataWindow.Header.Height=68")		
	dw_insert.Modify("DataWindow.Detail.Height=72")	
	dw_insert.modify("wstruc_bomend.protect=1")
	dw_insert.modify("wstruc_pcbloc.protect=1")
	dw_insert.modify("wstruc_rmks.protect=1")	
End if


end event

type p_2 from uo_picture within w_pdm_11720
integer x = 3159
integer y = 40
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\일괄복사_up.gif"
end type

event clicked;call super::clicked;String scvcod

if dw_head.accepttext() = -1 then return
scvcod = dw_head.getitemstring(1, "cvcod")

If isnull( scvcod ) or trim( scvcod ) = '' then
	MessageBox("거래처", "거래처선택후 click하세요", stopsign!)
	return
End if

openwithparm(w_pdm_11713, scvcod)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄복사_up.gif"
end event

type rr_2 from roundrectangle within w_pdm_11720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3447
integer y = 12
integer width = 1161
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdm_11720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3104
integer y = 12
integer width = 302
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

