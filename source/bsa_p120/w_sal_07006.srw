$PBExportHeader$w_sal_07006.srw
$PBExportComments$년간판매계획및실적 - Level (1-4) - 제품별
forward
global type w_sal_07006 from w_standard_print
end type
type shl_3 from statichyperlink within w_sal_07006
end type
type st_2 from statictext within w_sal_07006
end type
type shl_1 from statichyperlink within w_sal_07006
end type
type shl_2 from statichyperlink within w_sal_07006
end type
type st_1 from statictext within w_sal_07006
end type
type st_3 from statictext within w_sal_07006
end type
type st_4 from statictext within w_sal_07006
end type
type rr_1 from roundrectangle within w_sal_07006
end type
end forward

global type w_sal_07006 from w_standard_print
string title = "년간판매계획및실적 - 제품별"
string menuname = ""
shl_3 shl_3
st_2 st_2
shl_1 shl_1
shl_2 shl_2
st_1 st_1
st_3 st_3
st_4 st_4
rr_1 rr_1
end type
global w_sal_07006 w_sal_07006

forward prototypes
public function integer wf_cvcod (string arg_cvcod)
public function integer wf_retrieve ()
end prototypes

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

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_steamcd, ls_sarea, ls_cvcod, ls_month, ls_last_date

ls_year = dw_ip.GetItemString(1, 'year')
ls_steamcd = dw_ip.GetItemString(1, 'steamcd')
ls_sarea = dw_ip.GetItemString(1, 'sarea')
ls_cvcod = dw_ip.GetItemString(1, 'cvcod')
ls_month = dw_ip.GetItemString(1, 'month')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year + ls_month, ls_steamcd, ls_sarea, ls_cvcod) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

st_4.Text = "제품별(" + ls_month + "월)"

Return 1
end function

on w_sal_07006.create
int iCurrent
call super::create
this.shl_3=create shl_3
this.st_2=create st_2
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.st_3=create st_3
this.st_4=create st_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.shl_1
this.Control[iCurrent+4]=this.shl_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_07006.destroy
call super::destroy
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'steamcd', gs_code)
dw_ip.SetItem(1, 'sarea', gs_codename)
dw_ip.SetItem(1, 'cvcod', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'cvnas', f_get_token(gs_codename2, '~t'))
dw_ip.SetItem(1, 'month', f_get_token(gs_codename2, '~t'))

SetNull(gs_gubun)
SetNull(gs_code)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_sal_07006
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_sal_07006
end type

type p_print from w_standard_print`p_print within w_sal_07006
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_07006
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_sal_07006
end type



type dw_print from w_standard_print`dw_print within w_sal_07006
integer x = 3255
string dataobject = "d_sal_07006"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_07006
event ue_key pbm_dwnkey
integer x = 14
integer y = 96
integer width = 3383
integer height = 152
string dataobject = "d_sal_06886_a"
end type

event dw_ip::ue_key;/* Override Ancestor Script */
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_ip::itemchanged;call super::itemchanged;String  sOrderNo, sOrderDate, sNewOrderDate, sCust, sCustName, sSuJuYm, snull, sDepotNo, sSaupj
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

type dw_list from w_standard_print`dw_list within w_sal_07006
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_sal_07006"
boolean border = false
end type

type shl_3 from statichyperlink within w_sal_07006
integer x = 882
integer y = 36
integer width = 279
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
string text = "거래처별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_07004' then
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
	OpenSheet(w_sal_07004, w_mdi_frame, 0, Layered!)	
end if
end event

type st_2 from statictext within w_sal_07006
integer x = 754
integer y = 32
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_sal_07006
integer x = 69
integer y = 36
integer width = 187
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
string text = "년도별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_07000' then
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
	OpenSheet(w_sal_07000, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_2 from statichyperlink within w_sal_07006
integer x = 421
integer y = 36
integer width = 311
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
string text = "관할구역별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_sal_07002' then
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
	OpenSheet(w_sal_07002, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_sal_07006
integer x = 283
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
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_07006
integer x = 1170
integer y = 32
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_07006
integer x = 1317
integer y = 36
integer width = 521
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "제품별"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_07006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

