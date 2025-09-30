$PBExportHeader$w_sm00_00010.srw
$PBExportComments$년 판매계획 접수
forward
global type w_sm00_00010 from w_inherite
end type
type dw_1 from u_key_enter within w_sm00_00010
end type
type dw_import from datawindow within w_sm00_00010
end type
type p_1 from uo_picture within w_sm00_00010
end type
type st_2 from statictext within w_sm00_00010
end type
type rr_2 from roundrectangle within w_sm00_00010
end type
type rr_1 from roundrectangle within w_sm00_00010
end type
end forward

global type w_sm00_00010 from w_inherite
integer height = 2444
string title = "년 판매계획 접수"
dw_1 dw_1
dw_import dw_import
p_1 p_1
st_2 st_2
rr_2 rr_2
rr_1 rr_1
end type
global w_sm00_00010 w_sm00_00010

type variables
// 공장구분
DataWindowChild idw_plnt
end variables

forward prototypes
public function integer wf_protect (string arg_year, integer arg_chasu)
public function integer wf_danga (integer arg_row)
end prototypes

public function integer wf_protect (string arg_year, integer arg_chasu);String sSaupj
Long   nCnt

sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))

SELECT COUNT(*) INTO :nCnt FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :sSaupj 
	AND YYYY = :arg_year
	AND CHASU = :arg_chasu
	AND CNFIRM IS NOT NULL;
If nCnt > 0 Then
	MessageBox('확 인','년 판매계획이 마감처리 되어있습니다.!!')
	p_search.Enabled = False
	p_print.Enabled = False
	p_mod.Enabled = False
	p_addrow.Enabled = False
	p_delrow.Enabled = False
	p_del.Enabled = False
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	p_print.PictureName = 'C:\erpman\image\소요량계산_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
Else
	p_search.Enabled = True
	p_print.Enabled = True
	p_mod.Enabled = True
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	p_del.Enabled = True
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	p_print.PictureName = 'C:\erpman\image\소요량계산_up.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
End If

Return 1
end function

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate, sSaupj, sYear, sStrmm
Dec	 dDanga, nChasu

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'0101'	// 단가기준일자
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

select fun_erp100000012_1(:sGiDate, :sCVCOD, :sITNBR,'1') into :dDanga from dual;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'plan_prc', dDanga)

sSaupj = trim(dw_1.getitemstring(1, 'saupj'))
sYear = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return 1
End If

nChasu = dw_1.getitemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return 1
End If

SELECT MAX(STRMM) INTO :sStrmm FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :sSaupj 
	AND YYYY = :syear
	AND CHASU = :nChasu;
If IsNull(sStrmm) Or sStrmm = '' Then
//	MessageBox('확인','계획시작월이 지정되지 않았습니다!!')
//	RETURN 1

	sStrmm = '01'
End If
	
if sStrmm <= '01' Then dw_insert.SetItem(arg_row, 'amt_01', dw_insert.GetItemNumber(arg_row, 'qty_01') * dDanga)
if sStrmm <= '02' Then dw_insert.SetItem(arg_row, 'amt_02', dw_insert.GetItemNumber(arg_row, 'qty_02') * dDanga)
if sStrmm <= '03' Then dw_insert.SetItem(arg_row, 'amt_03', dw_insert.GetItemNumber(arg_row, 'qty_03') * dDanga)
if sStrmm <= '04' Then dw_insert.SetItem(arg_row, 'amt_04', dw_insert.GetItemNumber(arg_row, 'qty_04') * dDanga)
if sStrmm <= '05' Then dw_insert.SetItem(arg_row, 'amt_05', dw_insert.GetItemNumber(arg_row, 'qty_05') * dDanga)
if sStrmm <= '06' Then dw_insert.SetItem(arg_row, 'amt_06', dw_insert.GetItemNumber(arg_row, 'qty_06') * dDanga)
if sStrmm <= '07' Then dw_insert.SetItem(arg_row, 'amt_07', dw_insert.GetItemNumber(arg_row, 'qty_07') * dDanga)
if sStrmm <= '08' Then dw_insert.SetItem(arg_row, 'amt_08', dw_insert.GetItemNumber(arg_row, 'qty_08') * dDanga)
if sStrmm <= '09' Then dw_insert.SetItem(arg_row, 'amt_09', dw_insert.GetItemNumber(arg_row, 'qty_09') * dDanga)
if sStrmm <= '10' Then dw_insert.SetItem(arg_row, 'amt_10', dw_insert.GetItemNumber(arg_row, 'qty_10') * dDanga)
if sStrmm <= '11' Then dw_insert.SetItem(arg_row, 'amt_11', dw_insert.GetItemNumber(arg_row, 'qty_11') * dDanga)
if sStrmm <= '12' Then dw_insert.SetItem(arg_row, 'amt_12', dw_insert.GetItemNumber(arg_row, 'qty_12') * dDanga)
	
Return 0
end function

on w_sm00_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_import=create dw_import
this.p_1=create p_1
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_import
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_sm00_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_import)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_import.SetTransObject(sqlca)

dw_1.InsertRow(0)

f_mod_saupj(dw_1, 'saupj')

// 공장구분
dw_1.GetChild('plnt', idw_plnt)
idw_plnt.SetTransObject(SQLCA)
idw_plnt.Retrieve()
end event

type dw_insert from w_inherite`dw_insert within w_sm00_00010
integer x = 27
integer y = 292
integer width = 4585
integer height = 1968
integer taborder = 130
string dataobject = "d_sm00_00010_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust,sDate, sitnbr, sitdsc, sispec, sjijil, sispec_code
Long   nCnt, nChasu, nRow
Int    ireturn
String sSaupj

SetNull(sNull)

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
		
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nRow, 'cvnas2', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nRow, 'cvnas2', get_nm)
			Post wf_danga(nrow)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itdsc", sitdsc)	
//		setitem(nrow, "ispec", sispec)
		
		Post wf_danga(nrow)
		
		RETURN ireturn
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		this.SetItem(lrow,"itnbr",gs_code)
		this.SetItem(lrow,"itdsc",gs_codename)
		
		Post wf_danga(lrow)
		
		Return 1
	Case 'cvcod'
		gs_code = GetText()

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(lrow, "cvcod", gs_Code)
		this.SetItem(lrow, "cvnas2", gs_Codename)
		
		Post wf_danga(lrow)
End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;
If currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if
end event

type p_delrow from w_inherite`p_delrow within w_sm00_00010
integer x = 3922
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc

If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))


If dw_insert.DataObject <> 'd_sm00_00010_3' Then
	MessageBox('확 인','계획은 삭제하실 수 없습니다.!!')
	Return
End If

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	nRow = dw_insert.RowCount()
	For ix = nRow To 1 Step -1
		sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
		sItdsc = Trim(dw_insert.GetItemString(ix, 'itdsc'))
		If IsNull(sCvcod) Or sCvcod = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		If IsNull(sItdsc) Or sItdsc = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		// 품번이 없을 경우 '.'으로 설정 
		sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
		If IsNull(sItnbr) Or sItnbr = '' Then
			dw_insert.SetItem(ix, 'itnbr','.')
		End If
	Next
End If

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

Commit;


p_inq.TriggerEvent(Clicked!)
end event

type p_addrow from w_inherite`p_addrow within w_sm00_00010
integer x = 3749
integer taborder = 50
end type

event p_addrow::clicked;String sYymm, sCust, sSaupj, sStrmm, sPlnt
Long	 nRow, dMax, nChasu

If dw_1.AcceptText() <> 1 Then Return

sYymm = Trim(dw_1.GetItemString(1, 'yymm'))
scust = Trim(dw_1.GetItemString(1, 'cust'))
sPlnt = Trim(dw_1.GetItemString(1, 'plnt'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	Return
End If

If dw_insert.DataObject <> 'd_sm00_00010_3' Then
	w_mdi_frame.sle_msg.text = '품목별 계획만 추가등록이 가능합니다.!!'
	Return
End If

If IsNull(sCust ) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

If IsNull(sPlnt ) Or sPlnt = '' Or sPlnt = '.' Then
	f_message_chk(1400,'[공장구분]')
	Return
End If

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

nChasu = dw_1.getitemNumber(1, 'chasu')
If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

SELECT MAX(STRMM) INTO :sStrmm FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :sSaupj 
	AND YYYY = :sYymm
	AND CHASU = :nChasu;
If IsNull(sStrmm) Or sStrmm = '' Then
//	MessageBox('확인','계획시작월이 지정되지 않았습니다.!!')
//	Return
	sStrmm = '01'
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'sabu', gs_sabu)
dw_insert.SetItem(nRow, 'yyyy', sYymm)
dw_insert.SetItem(nRow, 'cvcod', dw_1.GetItemString(1, 'cvcod'))
dw_insert.SetItem(nRow, 'cvnas2', dw_1.GetItemString(1, 'cvnas'))
dw_insert.SetItem(nRow, 'gubun', sCust)
dw_insert.SetItem(nRow, 'saupj', sSaupj)
dw_insert.SetItem(nRow, 'chasu', nChasu)
dw_insert.SetItem(nRow, 'plnt' , sPlnt)
dw_insert.SetItem(nRow, 'strmm', sStrmm)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_sm00_00010
integer x = 3355
integer taborder = 110
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;String sYear, sCust, sCvcod, sToday, sPlnt, sSaupj
Int    nChasu
Dec    dCnt

If dw_1.AcceptText() <> 1 Then Return

sYear  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sPlnt  = trim(dw_1.getitemstring(1, 'plnt'))
sSaupj = trim(dw_1.getitemstring(1, 'saupj'))
//sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
nChasu = dw_1.GetItemNumber(1, 'chasu')

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

//gs_code = sYear
//gs_gubun = String(nChasu)
//Open(w_sm00_00010_popup)
//
If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

If IsNull(sPlnt) Or sPlnt = ''  Or sPlnt = '.' Then
	f_message_chk(1400,'[공장구분]')
	Return
End If

select rfna2 into :scvcod
  from reffpf
 where sabu  = '1'
   and rfcod = '8I'
	and rfgub = :sPlnt;

If IsNull(scvcod) Or scvcod = '' Or scvcod = '.' Then
	f_message_chk(1400,'[공장구분(참조코드:거래처)]')
	Return
End If

SELECT  count(*) into :dCnt
   FROM sm01_yearplan
  WHERE sabu  = :gs_sabu
    AND saupj = :sSaupj
    AND yyyy  = :sYear
    AND gubun = :sCust
    AND plnt  = :sPlnt
    AND chasu = :nchasu
    AND rownum < 10;
if dCnt > 0 then
	IF MessageBox("확인", '기존 자료가 존재 합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
		Return
	Else
		delete from sm01_yearplan where saupj = :sSaupj
											 AND yyyy  = :sYear
											 AND gubun = :sCust
											 AND plnt  = :sPlnt
											 AND chasu = :nchasu;
	END IF
End if

INSERT INTO SM01_YEARPLAN
				( SABU, YYYY, CVCOD, ITNBR,    GUBUN, ITDSC, SAUPJ, PLAN_PRC,
				  QTY_01, QTY_02, QTY_03, QTY_04, QTY_05, QTY_06, QTY_07, QTY_08, QTY_09, QTY_10, QTY_11, QTY_12,
				  AMT_01, AMT_02, AMT_03, AMT_04, AMT_05, AMT_06, AMT_07, AMT_08, AMT_09, AMT_10, AMT_11, AMT_12,
				  CHASU, STRMM, PLNT )
	SELECT DISTINCT :gs_sabu, :sYear, :sCvcod, A.ITNBR, :sCust, I.ITDSC, :sSaupj, 
						  fun_erp100000012_1(:sYear||'0101', :sCvcod, A.ITNBR,'1'),
			 0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,
			 :nChasu, '01', :sPlnt
	  FROM stock_napum a,
			 ITEMAS I 
	 WHERE a.itnbr = i.itnbr
		AND a.plnt  = :sPlnt
		AND A.ITNBR = I.ITNBR
		AND I.USEYN = '0'
		AND I.ITTYP = '1';			
COMMIT;

If dw_insert.Retrieve(gs_sabu, sYear, scust, sSaupj, nChasu, sPlnt) <= 0 Then
	f_message_chk(50,'')
End If

Return
end event

type p_ins from w_inherite`p_ins within w_sm00_00010
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm00_00010
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_sm00_00010
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm00_00010
boolean visible = false
integer x = 3406
integer y = 192
integer taborder = 120
boolean enabled = false
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

event p_print::clicked;String sYear, sToday, sCvcod, sItnbr, sSpec, sDate, edate, s1date,e1date, s2date, e2date, stemp, sCargbn1, sCargbn2
String sGubun, sCust
double ditemprice,ddcrate
Int    iRtnValue, ix, nChasu
String sSaupj, sStrmm
String sGbn2[4] = { 'E', 'T', 'M', 'D' }

If dw_1.AcceptText() <> 1 Then Return

///* 사업장 체크 */
//sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400, '[사업장]')
//	Return
//End If
//
//sYear = trim(dw_1.getitemstring(1, 'yymm'))
//sCust = trim(dw_1.getitemstring(1, 'cust'))
//If IsNull(sYear) Or sYear = '' Then
//	f_message_chk(1400,'[계획년도]')
//	Return
//End If
//
//nChasu = dw_1.getitemNumber(1, 'chasu')
//If IsNull(nChasu) Or nChasu <= 0 Then
//	f_message_chk(1400,'[계획차수]')
//	Return
//End If
//
//SELECT MAX(STRMM) INTO :sStrmm FROM SM01_YEARPLAN 
// WHERE SABU = :gs_sabu 
//	AND SAUPJ = :sSaupj 
//	AND YYYY = :syear
//	AND CHASU = :nChasu;
//If IsNull(sStrmm) Or sStrmm = '' Then
//	MessageBox('확인','계획시작월이 지정되지 않았습니다!!')
//	RETURN
//End If
//
//IF MessageBox("확인", '차종별 계획을 소요량 계산합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
//	Return
//END IF
//
//sToday = f_today()
//
//SetPointer(hourGlass!)
//
///* 기존자료 삭제 - 차종,기종 */
//sCargbn1 = dw_1.GetItemString(1, 'cargbn1')	// 'E'하나만 있음
//
//For ix = 1 To 4
//	sCargbn2 = sGbn2[ix]
//	sGubun 	= sCargbn1 + sCargbn2
//	
//	DELETE FROM "SM01_YEARPLAN"
//		WHERE SABU = :gs_sabu 
//		  AND YYYY = :sYear
//		  AND GUBUN = :sGubun
//		  AND SAUPJ = :sSaupj
//		  AND CHASU = :nChasu;
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//		RollBack;
//		Return
//	End If
//	
//	// 차종에 대한 소요량 계산
//	INSERT INTO SM01_YEARPLAN
//					( SABU, YYYY, CVCOD, ITNBR,  GUBUN, ITDSC, SAUPJ, PLAN_PRC,
//					  QTY_01, QTY_02, QTY_03, QTY_04, QTY_05, QTY_06, QTY_07, QTY_08, QTY_09, QTY_10, QTY_11, QTY_12,
//					  AMT_01, AMT_02, AMT_03, AMT_04, AMT_05, AMT_06, AMT_07, AMT_08, AMT_09, AMT_10, AMT_11, AMT_12,
//					  CHASU, STRMM)
//			SELECT :gs_sabu, :sYear, X.CVCOD, X.ITNBR, X.GUBUN, X.ITDSC, :sSaupj, X.PRC,
//					 X.QTY01, X.QTY02, X.QTY03, X.QTY04, X.QTY05, X.QTY06, X.QTY07, X.QTY08, X.QTY09, X.QTY10, X.QTY11, X.QTY12,
//					 X.QTY01 * X.PRC, X.QTY02 * X.PRC, X.QTY03 * X.PRC, X.QTY04 * X.PRC, X.QTY05 * X.PRC, X.QTY06 * X.PRC,
//					 X.QTY07 * X.PRC, X.QTY08 * X.PRC, X.QTY09 * X.PRC, X.QTY10 * X.PRC, X.QTY11 * X.PRC, X.QTY12 * X.PRC,
//					 :nChasu, :sStrmm
//			  FROM ( SELECT B.ITNBR, C.CVCOD, I.ITDSC, B.CARGBN1||B.CARGBN2 AS GUBUN,
//							 fun_erp100000012_1(:sYear||'0101', C.CVCOD,B.ITNBR, '1') AS PRC,
//							 SUM(A.YQTY01 * B.USAGE * C.USAGE/100) AS QTY01,
//							 SUM(A.YQTY02 * B.USAGE * C.USAGE/100) AS QTY02,
//							 SUM(A.YQTY03 * B.USAGE * C.USAGE/100) AS QTY03,
//							 SUM(A.YQTY04 * B.USAGE * C.USAGE/100) AS QTY04,
//							 SUM(A.YQTY05 * B.USAGE * C.USAGE/100) AS QTY05,
//							 SUM(A.YQTY06 * B.USAGE * C.USAGE/100) AS QTY06,
//							 SUM(A.YQTY07 * B.USAGE * C.USAGE/100) AS QTY07,
//							 SUM(A.YQTY08 * B.USAGE * C.USAGE/100) AS QTY08,
//							 SUM(A.YQTY09 * B.USAGE * C.USAGE/100) AS QTY09,
//							 SUM(A.YQTY10 * B.USAGE * C.USAGE/100) AS QTY10,
//							 SUM(A.YQTY11 * B.USAGE * C.USAGE/100) AS QTY11,
//							 SUM(A.YQTY12 * B.USAGE * C.USAGE/100) AS QTY12
//					  FROM SM01_YEARPLAN_CAR A,
//							 ( SELECT A.CARCODE, A.SEQ AS CARSEQ, A.CARGBN1, A.CARGBN2, B.ITNBR, B.USAGE
//								FROM CARMST A, CARBOM B
//							  WHERE A.CARCODE = B.CARCODE
//								 AND A.SEQ = B.SEQ
//								 AND A.CARGBN1 = B.CARGBN1
//								 AND A.CARGBN2 = B.CARGBN2) B,
//							 CARBOM_VND C, ITEMAS I
//					 WHERE A.SAUPJ = :sSaupj
//						AND A.BASE_YEAR = :syear
//						AND A.CHASU = :nChasu
//						AND A.CARGBN1 = :sCargbn1
//						AND A.CARGBN2 = :sCargbn2
//						AND A.CARCODE = B.CARCODE
//						AND A.CARSEQ = B.CARSEQ
//						AND A.CARGBN1 = B.CARGBN1
//						AND A.CARGBN2 = B.CARGBN2
//						AND B.CARCODE = C.CARCODE
//						AND B.CARSEQ = C.SEQ
//						AND B.CARGBN1 = C.CARGBN1
//						AND B.CARGBN2 = C.CARGBN2
//						AND B.ITNBR = C.ITNBR
//						AND B.ITNBR = I.ITNBR
//					 GROUP BY B.ITNBR, C.CVCOD, I.ITDSC, B.CARGBN1||B.CARGBN2 ) X;
//	
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//		RollBack;
//		Return
//	End If
//
//	// 실적자료 생성
//	iRtnValue = SQLCA.SM03_CREATE_DATA(sSaupj, sYear, '1', nChasu);
//	If iRtnValue <> 1 Then
//		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
//		RollBack;
//		dw_insert.SetRedraw(True)
//		REturn
//	End If
//			
//	COMMIT;
//Next
//
//dw_insert.SetRedraw(True)
//
//MessageBox('확 인', '소요량 계산이 완료되었습니다.!!')
end event

type p_inq from w_inherite`p_inq within w_sm00_00010
integer x = 3575
end type

event p_inq::clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2, sPlnt
String scvcod
Long   nCnt, ix, nrow, nChasu
String sSaupj

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
scust = trim(dw_1.getitemstring(1, 'cust'))
//scvcod = trim(dw_1.getitemstring(1, 'cvcod'))
sPlnt  = trim(dw_1.getitemstring(1, 'plnt'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

nChasu = dw_1.getitemNumber(1, 'chasu')
If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

//If IsNull(scust) Or scust = '' Then
//	f_message_chk(1400,'[고객구분]')
//	Return
//End If

If IsNull(sPlnt) Or sPlnt = '' Or sPlnt = '.' Then
	f_message_chk(1400,'[공장구분]')
	Return
End If

select rfna2 into :scvcod
  from reffpf
 where sabu  = '1'
   and rfcod = '8I'
	and rfgub = :sPlnt;

If IsNull(scvcod) Or scvcod = '' Or scvcod = '.' Then
	f_message_chk(1400,'[공장구분(참조코드:거래처)]')
	Return
End If

dw_1.Setitem(1, "cvcod", scvcod)

//// 차종
//If ( scust = '1' or scust = '7' or scust = '8'  Or sCust = 'A' ) And dw_1.GetItemString(1, 'item') = 'N'  Then
//	dw_insert.DataObject = 'd_sm00_00010_2'
//// 기타(품목별)
//Else
//	dw_insert.DataObject = 'd_sm00_00010_3'
//End If
//dw_insert.SetTransObject(sqlca)
		
Choose Case dw_insert.DataObject
	// 품목별 계획인 경우
	Case 'd_sm00_00010_3'		
		
		If dw_insert.Retrieve(gs_sabu, sYear, scust, sSaupj, nChasu, sPlnt) <= 0 Then
			f_message_chk(50,'')
		End If
	// 차종/기종별 계획인 경우
//	Case Else
//		sCargbn1 = dw_1.GetItemString(1, 'cargbn1')
//		sCargbn2 = dw_1.GetItemString(1, 'cargbn2')
//		
//		If dw_insert.Retrieve(sSaupj, sYear, sCargbn1, sCargbn2, sCust, nChasu) <= 0 Then
//			f_message_chk(50,'')
//		End If
//		
//		If sCargbn1 = 'E' Or sCargbn1 = 'C' Then
//			If sCargbn2 = 'E' Then
//				dw_insert.Object.tx_0.text = '차종명'
//				dw_insert.Object.tx_1.text = '엔진명'
//				dw_insert.Object.tx_2.text = '엔진형식'
//				dw_insert.Object.tx_3.text = ''
//				dw_insert.Object.tx_4.text = ''
//			End If
//			If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
//				dw_insert.Object.tx_0.text = '차종명'
//				dw_insert.Object.tx_1.text = '엔진명'
//				dw_insert.Object.tx_2.text = '엔진형식'
//				dw_insert.Object.tx_3.text = '계열'
//				dw_insert.Object.tx_4.text = '기종'
//			End If
//			If sCargbn2 = 'D' Then
//				dw_insert.Object.tx_0.text = '차종명'
//				dw_insert.Object.tx_1.text = '구분'
//				dw_insert.Object.tx_2.text = '형식'
//				dw_insert.Object.tx_3.text = 'ABS'
//				dw_insert.Object.tx_4.text = ''
//			End If
//		ElseIf sCargbn1 = '0' Or sCargbn1 = '1' Then
//				dw_insert.Object.tx_0.text = '기종명'
//				dw_insert.Object.tx_1.text = '모델'
//				dw_insert.Object.tx_2.text = ''
//				dw_insert.Object.tx_3.text = ''
//				dw_insert.Object.tx_4.text = ''
//		Else
//			dw_insert.Object.tx_0.text = ''
//			dw_insert.Object.tx_1.text = ''
//			dw_insert.Object.tx_2.text = ''
//			dw_insert.Object.tx_3.text = ''
//			dw_insert.Object.tx_4.text = ''
//		End If
End Choose
end event

type p_del from w_inherite`p_del within w_sm00_00010
boolean visible = false
integer x = 3035
integer taborder = 80
boolean enabled = false
end type

event p_del::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc, tx_name, sCargbn1, sCargbn2, sYear
String sSaupj

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))
sYear = Trim(dw_1.GetItemString(1, 'yymm'))
tx_name = Trim(dw_1.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
sCargbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCargbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

IF MessageBox("확인", '고객구분 ' + tx_name + ' 의 자료를 삭제합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

// 차종별 계획인 경우
If dw_insert.DataObject = 'd_sm00_00010_2' Then
/* 기존자료 삭제 - 차종,기종 */
	DELETE FROM "SM01_YEARPLAN"
		WHERE SABU = :gs_sabu 
		  AND YYYY = :sYear
		  AND GUBUN = :sCargbn1||:sCargbn2
		  AND SAUPJ = :sSaupj;
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sm00_00010
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Long ix, nRow
String sCust, sItnbr, sItdsc, sCvcod

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

/* 품목별 계획일 경우 체크 */
sCust = dw_1.GetItemString(1, 'cust')
If dw_insert.DataObject = 'd_sm00_00010_3' Then
	nRow = dw_insert.RowCount()
	For ix = nRow To 1 Step -1
		sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
		sItdsc = Trim(dw_insert.GetItemString(ix, 'itdsc'))
		If IsNull(sCvcod) Or sCvcod = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		If IsNull(sItdsc) Or sItdsc = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		// 품번이 없을 경우 '.'으로 설정 
		sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
		If IsNull(sItnbr) Or sItnbr = '' Then
			dw_insert.SetItem(ix, 'itnbr','.')
		End If
	Next
End If


If dw_insert.RowCount() > 0 Then
	If dw_insert.Update() <> 1 Then
		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If

	COMMIT;
	
	MessageBox('확 인','저장하였습니다')
Else
	MessageBox('확 인','저장할 자료가 없습니다.!!')
End If

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sm00_00010
end type

type cb_mod from w_inherite`cb_mod within w_sm00_00010
end type

type cb_ins from w_inherite`cb_ins within w_sm00_00010
end type

type cb_del from w_inherite`cb_del within w_sm00_00010
end type

type cb_inq from w_inherite`cb_inq within w_sm00_00010
end type

type cb_print from w_inherite`cb_print within w_sm00_00010
end type

type st_1 from w_inherite`st_1 within w_sm00_00010
end type

type cb_can from w_inherite`cb_can within w_sm00_00010
end type

type cb_search from w_inherite`cb_search within w_sm00_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_sm00_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm00_00010
end type

type dw_1 from u_key_enter within w_sm00_00010
integer x = 41
integer y = 68
integer width = 2697
integer height = 188
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm00_00010_1"
boolean border = false
end type

event itemchanged;String s_cvcod, snull, get_nm, sItem, sCust,sDate, sPlnt
Long   nCnt, nChasu
String sSaupj

SetNull(sNull)

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

Choose Case GetColumnName()
	Case 'plnt'
		sPlnt = this.GetText()								
		 
		if sPlnt = "" or sPlnt = "." or isnull(sPlnt) then 
			return 
		end if
		
		SELECT a.rfna2 , v.cvnas2
		  INTO :s_cvcod, :get_nm  
		  FROM reffpf a , vndmst v
		 WHERE a.sabu = '1'
		   and a.rfcod = '8I'
			and a.rfgub = :sPlnt
			and a.rfna2 = v.cvcod(+);
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvcod', s_cvcod)
			this.setitem(1, 'cvnas', get_nm)
		else
			return 1
		end if
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'cust'
		sCust = GetText()
		
		// 차종
		If GetText() = '1' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 기종
		ElseIf GetText() = '2' Then
			SetItem(1, 'cargbn1', '0')
			SetItem(1, 'cargbn2', '9')
		// 대림
		ElseIf GetText() = '3' Then
			//SetItem(1, 'cargbn1', '1')
			SetItem(1, 'cargbn1', '9')
			SetItem(1, 'cargbn2', '9')
		// 기아
		ElseIf GetText() = '7' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// CKD
		ElseIf GetText() = '8' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 파워텍
		ElseIf GetText() = 'A' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'T')
		// 기타(품목별)
		Else
			SetItem(1, 'cargbn1', '9')
			SetItem(1, 'cargbn2', '9')
		End If
		
//		If sCust = '1' Or sCust = '7' Or sCust = '8' Or sCust = 'A' Or sCust = '3' Then
//			p_print.Visible = true
//		Else
//			p_print.Visible = False
//		End If
		
		dw_insert.Reset()
		
		// 고객구분에 따라 공장를 필터링한다		
		idw_plnt.SetFilter("rfna3 = '" + sCust +"'")
		idw_plnt.Filter()
		SetItem(1, 'plnt', sNull)
//		SetItem(1, 'plnt', idw_plnt.GetItemSTring(1, 'rfgub'))
	Case 'item'
		sItem = GetText()
	/* 계획년도 */
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			// 해당년도의 최종차수 계산
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
			
			Post wf_protect(sDate, nChasu)
		End If
	/* 계획차수 */
	Case 'chasu'
		nChasu = Dec(GetText())
		If nChasu <= 0 Then Return
		
		sDate = GetitemString(1, 'yymm')
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			Post wf_protect(sDate, nChasu)
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type dw_import from datawindow within w_sm00_00010
boolean visible = false
integer x = 206
integer y = 876
integer width = 3122
integer height = 808
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm00_00010_import"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_sm00_00010
integer x = 2789
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\파일열기_up.gif"
end type

event clicked;call super::clicked;String sYear, sCust, sCvcod, sToday, sPlnt, sSaupj, sItdsc, sItnbr
Int    nChasu
Dec    dCnt, i, ddanga, dQty1,  dQty2,  dQty3,  dQty4,  dQty5,  dQty6,  &
                        dQty7,  dQty8,  dQty9,  dQty10, dQty11, dQty12, &
								dAmt1,  dAmt2,  dAmt3,  dAmt4,  dAmt5,  dAmt6,  &
								dAmt7,  dAmt8,  dAmt9,  dAmt10,  dAmt11,dAmt12

If dw_1.AcceptText() <> 1 Then Return

sYear  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sPlnt  = trim(dw_1.getitemstring(1, 'plnt'))
sSaupj = trim(dw_1.getitemstring(1, 'saupj'))
//sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
nChasu = dw_1.GetItemNumber(1, 'chasu')

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

If IsNull(sPlnt) Or sPlnt = ''  Or sPlnt = '.' Then
	f_message_chk(1400,'[공장구분]')
	Return
End If

select rfna2 into :scvcod
  from reffpf
 where sabu  = '1'
   and rfcod = '8I'
	and rfgub = :sPlnt;

If IsNull(scvcod) Or scvcod = '' Or scvcod = '.' Then
	f_message_chk(1400,'[공장구분(참조코드:거래처)]')
	Return
End If

SELECT  count(*) into :dCnt
   FROM sm01_yearplan
  WHERE sabu  = :gs_sabu
    AND saupj = :sSaupj
    AND yyyy  = :sYear
    AND gubun = :sCust
    AND plnt  = :sPlnt
    AND chasu = :nchasu
    AND rownum < 10;
if dCnt > 0 then
	IF MessageBox("확인", '기존 자료가 존재 합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
		Return
	Else
		delete from sm01_yearplan where saupj = :sSaupj
											 AND yyyy  = :sYear
											 AND gubun = :sCust
											 AND plnt  = :sPlnt
											 AND chasu = :nchasu;
	END IF
End if

dw_import.Reset()
dw_import.ImportFile("C:\ERPMAN\PLAN\YEAR\PLAN_YY.TXT")

for i = 1 to dw_import.Rowcount()
	dw_import.Setitem(i, 'sabu', gs_sabu)
	dw_import.Setitem(i, 'saupj',sSaupj)
	dw_import.Setitem(i, 'yyyy', sYear)
//	dw_import.Setitem(i, 'gubun',sCust)
//	dw_import.Setitem(i, 'plnt', sPlnt)
	dw_import.Setitem(i, 'cvcod',sCvcod)
	dw_import.Setitem(i, 'chasu',nChasu)
	dw_import.Setitem(i, 'strmm','01')
	
	sItnbr	= Trim(dw_import.GetItemString(i, 'itnbr'))
   select fun_erp100000012_1(:syear + '0101', :sCvcod, :sItnbr,'1') 
	  into :ddanga from dual;

   If IsNull(dDanga) Then dDanga = 0

   dw_import.Setitem(i, 'plan_prc', dDanga)
	
	select itdsc into :sItdsc from itemas where itnbr = :sItnbr;
   If IsNull(sItdsc) or sitdsc = "" Then sItdsc = '.'
   dw_import.Setitem(i, 'itdsc', sItdsc)

	dw_import.Setitem(i, 'amt_01' ,dw_import.GetItemNumber(i, 'qty_01') * dDanga)
	dw_import.Setitem(i, 'amt_02' ,dw_import.GetItemNumber(i, 'qty_02') * dDanga)
	dw_import.Setitem(i, 'amt_03' ,dw_import.GetItemNumber(i, 'qty_03') * dDanga)
	dw_import.Setitem(i, 'amt_04' ,dw_import.GetItemNumber(i, 'qty_04') * dDanga)
	dw_import.Setitem(i, 'amt_05' ,dw_import.GetItemNumber(i, 'qty_05') * dDanga)
	dw_import.Setitem(i, 'amt_06' ,dw_import.GetItemNumber(i, 'qty_06') * dDanga)
	dw_import.Setitem(i, 'amt_07' ,dw_import.GetItemNumber(i, 'qty_07') * dDanga)
	dw_import.Setitem(i, 'amt_08' ,dw_import.GetItemNumber(i, 'qty_08') * dDanga)
	dw_import.Setitem(i, 'amt_09' ,dw_import.GetItemNumber(i, 'qty_09') * dDanga)
	dw_import.Setitem(i, 'amt_10' ,dw_import.GetItemNumber(i, 'qty_10') * dDanga)
	dw_import.Setitem(i, 'amt_11' ,dw_import.GetItemNumber(i, 'qty_11') * dDanga)
	dw_import.Setitem(i, 'amt_12' ,dw_import.GetItemNumber(i, 'qty_12') * dDanga)

Next

if dw_import.update() <> 1 then
	MessageBox('저장실패', '[LOAD] 등록에 실패했습니다.~r' + &
								  '  문의 하세요.', Stopsign!)
	Rollback;
	return
end if

If dw_insert.Retrieve(gs_sabu, sYear, scust, sSaupj, nChasu, sPlnt) <= 0 Then
	f_message_chk(50,'')
End If

end event

type st_2 from statictext within w_sm00_00010
integer x = 2802
integer y = 196
integer width = 2030
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[파일형식:고객구분,공장,품번, 1월수량 , 2월 ... 12월 수량 ]"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm00_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 36
integer width = 2743
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm00_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4613
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

