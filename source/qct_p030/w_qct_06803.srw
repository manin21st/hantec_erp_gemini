$PBExportHeader$w_qct_06803.srw
$PBExportComments$년간품질현황 - Level (1.3) - 제품별
forward
global type w_qct_06803 from w_standard_print
end type
type shl_1 from statichyperlink within w_qct_06803
end type
type st_1 from statictext within w_qct_06803
end type
type shl_2 from statichyperlink within w_qct_06803
end type
type st_2 from statictext within w_qct_06803
end type
type shl_3 from statichyperlink within w_qct_06803
end type
type rr_1 from roundrectangle within w_qct_06803
end type
end forward

global type w_qct_06803 from w_standard_print
string title = "년간품질현황 - 제품별"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
st_1 st_1
shl_2 shl_2
st_2 st_2
shl_3 shl_3
rr_1 rr_1
end type
global w_qct_06803 w_qct_06803

type variables
String	is_Tag = '1'
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_cvcod (string arg_cvcod)
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_cvcod

ls_year = dw_ip.GetItemString(1, 'year') + dw_ip.GetItemString(1, 'month')
ls_cvcod = dw_ip.GetItemString(1, 'cvcod')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year,ls_cvcod) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

public function integer wf_cvcod (string arg_cvcod);String sCustName, sEmpId, sCvstatus, sGumgu,  sArea, sSaupj, sCvgu
String chksarea, chksteam, sNull
Dec    dNapqty, dLimitAmount
Int    iReturn = 0

SetNull(sNull)

If Not IsNull(arg_cvcod) And Trim(arg_cvcod) <> '' Then
	SELECT "VNDMST"."CVNAS2", "VNDMST"."SALE_EMP",     "VNDMST"."CVSTATUS", "VNDMST"."GUMGU",
			 "VNDMST"."NAPQTY", "VNDMST"."CREDIT_LIMIT", "VNDMST"."SAREA", "SAREA"."SAUPJ",
			 "VNDMST"."CVGU"
	  INTO :sCustName, :sEmpId ,:sCvstatus, :sGumgu, :dNapqty, :dLimitAmount, :sArea, :sSaupj,
	       :sCvgu
	  FROM "VNDMST", "SAREA"
	 WHERE "VNDMST"."CVCOD" = :arg_cvcod AND 
			 "VNDMST"."SAREA" = "SAREA"."SAREA"(+);

	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox('확 인','거래처를 확인하십시요!!')
		iReturn = 1
	/* 부서일 경우 */
	ElseIf sCvgu = '4' Then
		iReturn = 0
	ElseIf Trim(sCvstatus ) = '1' Then
		MessageBox('확 인','거래중지된 거래처입니다')
		iReturn = 1
	ElseIf Trim(sCvstatus ) = '2' Then
		MessageBox('확 인','거래종료된 거래처입니다')
		iReturn = 1
	ELSEIF IsNull(sArea) Or Trim(sArea) = '' THEN
		MessageBox('확 인','관할구역이 등록되어있지 않습니다.!!')
		iReturn = 1
	/* User별 관할구역 Check */	
	ELSEIf f_check_sarea(chksarea, chksteam, sSaupj) = 1 And chksarea <> sarea Then
		f_message_chk(114,'')
		iReturn = 1
	End If
Else
	iReturn = 1
End If

If	iReturn = 0 Then
	dw_ip.SetItem(1,"cvcod",  arg_cvcod)
	dw_ip.SetItem(1,"cvnas",  sCustName)

	Return 1
Else
	dw_ip.SetItem(1,"cvcod",	snull)
	dw_ip.SetItem(1,"cvnas",	snull)
			
	Return -1
End If
end function

on w_qct_06803.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.shl_2=create shl_2
this.st_2=create st_2
this.shl_3=create shl_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.shl_2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.shl_3
this.Control[iCurrent+6]=this.rr_1
end on

on w_qct_06803.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.shl_2)
destroy(this.st_2)
destroy(this.shl_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'year', gs_gubun)
dw_ip.SetItem(1,'cvcod', gs_code)
dw_ip.SetItem(1,'cvnas', gs_codename)
dw_ip.SetItem(1,'month', gs_codename2)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_qct_06803
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_qct_06803
end type

type p_print from w_standard_print`p_print within w_qct_06803
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06803
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_qct_06803
end type



type dw_print from w_standard_print`dw_print within w_qct_06803
string dataobject = "d_qct_06803"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06803
integer x = 18
integer y = 96
integer width = 2258
integer height = 152
string dataobject = "d_qct_06803_a"
end type

event dw_ip::itemchanged;String  sOrderNo, sOrderDate, sNewOrderDate, sCust, sCustName, sSuJuYm, snull, sDepotNo, sSaupj
Long    nRow, nLen, nCnt
string  sproject_prjnm,sproject_no, sCvStatus
		
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(snull)

nRow = GetRow()
If nRow <=0 Then Return

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCust = Trim(GetText())
		
		Post wf_cvcod(sCust)
	/* 거래처명 */
	Case "cvnas"
		sCustName = Trim(GetText())
		IF sCustName ="" OR IsNull(sCustName) THEN 
			Post wf_cvcod(sNull)
			Return
		End If

		SELECT MAX("VNDMST"."CVCOD"),   COUNT(*)
		  INTO :sCust, :nCnt
		  FROM "VNDMST", "SAREA"
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND
		       "VNDMST"."CVNAS2" like '%'||:sCustName||'%' AND
				 "VNDMST"."CVSTATUS" = '0';
	
		Choose Case nCnt
			Case 0
				gs_gubun = '1'
				Open(w_agent_popup)
				If gs_code = '' Or IsNull(gs_code) Then Return 1
			Case 1
				gs_code = sCust
			Case Else
				gs_codename = sCustName
				Open(w_vndmst_popup)
				If gs_code = '' Or IsNull(gs_code) Then Return 1
		End Choose
		
		Post wf_cvcod(gs_code)

END Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'cvcod', gs_code)
		TriggerEvent(ItemChanged!)
	/* 거래처명 */
	Case "cvnas"
		Open(w_vndmst_popup)
		
		IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN 2
		
		SetItem(1,"cvnas",gs_codename)
		SetItem(1,"cvcod",gs_code)
		
END Choose

end event

event dw_ip::ue_key;/* Override Ancestor Script */
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_06803
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_qct_06803"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

If mid(ls_Object, 1, 5)  = 'titnm' Then
	ll_Row = long(mid(ls_Object, 6, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', '1')
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event dw_list::clicked;call super::clicked;String	ls_Object
Long		ll_Row

Boolean	lb_isopen
Window	lw_window

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())


/* 품종분류별 */
IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
	ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'itcls')
	gs_codename = this.GetItemString(row, 'titnm')
	gs_codename2 = this.GetItemString(row, 'ittyp')	
	
	// 윈도우가 이미 열려있으면 닫는다.
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_qct_06801' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	If lb_isopen Then
		Close(lw_window)
	End If
	
	OpenSheet(w_qct_06801, w_mdi_frame, 0, Layered!)
	
END IF
end event

type shl_1 from statichyperlink within w_qct_06803
integer x = 41
integer y = 36
integer width = 265
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_qct_06801' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_qct_06801, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_qct_06803
integer x = 334
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_qct_06803
integer x = 471
integer y = 36
integer width = 553
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "(수입검사)거래처별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_qct_06802' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_qct_06802, w_mdi_frame, 0, Layered!)	
end if
end event

type st_2 from statictext within w_qct_06803
integer x = 1051
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_3 from statichyperlink within w_qct_06803
integer x = 1193
integer y = 36
integer width = 224
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "제품별"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_06803
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

