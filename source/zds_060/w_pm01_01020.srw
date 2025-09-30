$PBExportHeader$w_pm01_01020.srw
$PBExportComments$월 생산능력 검토
forward
global type w_pm01_01020 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_01020
end type
type dw_2 from datawindow within w_pm01_01020
end type
type dw_3 from datawindow within w_pm01_01020
end type
type st_kun from statichyperlink within w_pm01_01020
end type
type st_hu from statichyperlink within w_pm01_01020
end type
type st_2 from statictext within w_pm01_01020
end type
type rr_1 from roundrectangle within w_pm01_01020
end type
type rr_2 from roundrectangle within w_pm01_01020
end type
type rr_3 from roundrectangle within w_pm01_01020
end type
type cb_1 from commandbutton within w_pm01_01020
end type
type dw_change from u_key_enter within w_pm01_01020
end type
type pb_1 from u_pb_cal within w_pm01_01020
end type
type p_1 from picture within w_pm01_01020
end type
type ole_chart from uo_chartfx_ie4 within w_pm01_01020
end type
end forward

global type w_pm01_01020 from w_inherite
integer width = 5490
string title = "월 생산능력 검토"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
st_kun st_kun
st_hu st_hu
st_2 st_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
cb_1 cb_1
dw_change dw_change
pb_1 pb_1
p_1 p_1
ole_chart ole_chart
end type
global w_pm01_01020 w_pm01_01020

type variables
String is_gubun='11111'	// 근무계획
String is_calgbn = '1'//부하계산기준
end variables

forward prototypes
public function integer wf_kunmu ()
public function integer wf_chart (integer arg_row)
public function integer wf_protect (string arg_yymm)
public subroutine wf_set_qty ()
public subroutine wf_subitem (string as_yymm)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_kunmu ();Int ikun, ihu
String sdate, edate

sDate = dw_2.GetItemString(1, 'week_sdate')
eDate = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')

SELECT COUNT(CLDATE) INTO :ikun
  FROM (SELECT CLDATE AS CLDATE FROM P4_CALENDAR
		   WHERE WORKGUB <> '9'
			  AND CLDATE BETWEEN :sdate AND :edate
		   GROUP BY CLDATE );
If IsNull(ikun) Then iKun = 0

SELECT COUNT(CLDATE) INTO :ihu
  FROM (SELECT CLDATE AS CLDATE FROM P4_CALENDAR
		   WHERE WORKGUB = '9'
			  AND CLDATE BETWEEN :sdate AND :edate
		   GROUP BY CLDATE );
If IsNull(ihu) Then ihu = 0

//SELECT COUNT(CLDATE) INTO :ikun
//  FROM (SELECT CLDATE AS CLDATE FROM PM01_CAPA_LOD
//		   WHERE RQCGU <> '0'
//			  AND CLDATE BETWEEN :sdate AND :edate
//		   GROUP BY CLDATE );
//If IsNull(ikun) Then iKun = 0
//
//SELECT COUNT(CLDATE) INTO :ihu
//  FROM (SELECT CLDATE AS CLDATE FROM PM01_CAPA_LOD
//		 WHERE RQCGU = '0'
//		  AND CLDATE BETWEEN :sdate AND :edate
//		 GROUP BY CLDATE );
//If IsNull(ihu) Then ihu = 0

st_kun.Text = '근무일수 : ' + string(ikun,'#0') + '일'
st_hu.Text  = '휴무일수 : ' + string(ihu,'#0') + '일'

return ikun
end function

public function integer wf_chart (integer arg_row);int				i, j, li_colno = 0, li_rowcnt = 8
st_chartdata	lst_chartdata
string			ls_colname
boolean			lb_sumtag = false
String			syymm, syymm2, syymm3

iF dw_1.AcceptText() <> 1 Then Return -1
if dw_3.rowcount() <= 0 then return -1

syymm = dw_1.GetItemString(1, 'yymm')
syymm2 = f_aftermonth(syymm,1)
syymm3 = f_aftermonth(syymm,2)

if arg_row > 0 then
	If dw_3.GetItemString(arg_row, 'gubun') = '1' Then
		lst_chartdata.toptitle  = trim(dw_3.getitemstring(arg_row, 'wcdsc'))
	Else
		lst_chartdata.toptitle  = trim(dw_3.getitemstring(arg_row, 'mchnam'))
	End If
else
	
	String sPdtgu
	
	sPdtgu = Trim(dw_1.getItemstring(1, 'pdtgu'))
	If IsNull(sPdtgu) Or sPdtgu = '' Then
		lst_chartdata.toptitle  = '생산능력검토'
	Else
		lst_chartdata.toptitle  = Trim(dw_1.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	End If
end if

	lst_chartdata.rowcnt    = li_rowcnt


// Series 숫자
lst_chartdata.colcnt = 2
//lst_chartdata.colcnt    = dw_list.rowcount() -2

for i = 1 to 6
	lst_chartdata.rowname[i] = string(i) + ' 주차'
next

lst_chartdata.rowname[7] = string(Right(syymm2,2),'@@월')
lst_chartdata.rowname[8] = string(Right(syymm3,2),'@@월')

for i = 1 to 2
	
	li_colno++

	/* 사용공수 */
	if i = 1 Then
		lst_chartdata.colname[li_colno] = '사용공수'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_bar
		
		for j = 1 to 8
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j))
			end if
		next
	end if

	/* 보유공수 */
	if i = 2 Then
		lst_chartdata.colname[li_colno] = '보유공수'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
		
		for j = 1 to 8
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'bo' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_bo' + string(j))
			end if
		next
	end if
next

ole_chart.setdata(lst_chartdata)

return 1

end function

public function integer wf_protect (string arg_yymm);Long lcount
String sCode, sPdtgu, sJocod

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

If IsNull(sCode) Or sCode = '' Then
	sPdtgu = ''
	sJocod = ''
Else
	sPdtgu = Trim(Mid(sCode, 2,6))
	sJocod = Trim(Mid(sCode, 8,6))
End If

SELECT COUNT(*) INTO :lcount
 FROM ITEMAS B, PM01_MONPLAN_SUM A
WHERE A.SABU = :gs_sabu AND A.MONYYMM = :arg_yymm AND A.MOSEQ = 0 AND
      A.ITNBR = B.ITNBR AND
		B.PDTGU LIKE :sPdtgu||'%' AND
		B.JOCOD LIKE :sJocod||'%';

if lcount > 0 then 
	messagebox("확 인", "생산계획이 확정된 반이 있으므로 수정 및 삭제 할 수 없습니다.")
	p_print.picturename = 'C:\erpman\image\부하계산_d.gif'
	p_search.picturename = 'C:\erpman\image\조정_d.gif'
	p_mod.picturename = 'C:\erpman\image\저장_d.gif'
	
	cb_1.Enabled = False
	
	p_print.enabled = false
	p_search.enabled = false
	p_mod.enabled = false
else
	p_print.picturename = 'C:\erpman\image\부하계산_up.gif'
	p_search.picturename = 'C:\erpman\image\조정_up.gif'
	p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	
	cb_1.Enabled = true
	
	p_print.enabled = true
	p_search.enabled = true
	p_mod.enabled = true
end if

return 1
end function

public subroutine wf_set_qty ();String 	syymm, sitnbr, stoday
Long	 	ll_row
Dec {0}	dJqty, dSqty, dPqty, dPqty1, dPqty2, dPqty3, dPqty4, dPqty5, dPqty6, dPqty7

syymm	= dw_1.GetItemString(1, 'yymm')

stoday = f_today()
//stoday = '20061004'

For ll_row = 1 To dw_insert.Rowcount()
	sitnbr = dw_insert.getitemstring(ll_row,'itnbr')
	// 현재고
	select sum(jego_qty) into :dJqty from stock where itnbr = :sitnbr;
	if IsNull(dJqty) then dJqty = 0
	// 안전재고
	select nvl(minsaf,0) into :dSqty from itemas where itnbr = :sitnbr;
	
//	// 계획잔량
//	select sum(lotqty1), sum(lotqty2), sum(lotqty3), sum(lotqty4), sum(lotqty5), sum(lotqty6), sum(lotqty7)
//	  into :dPqty1, 		:dPqty2, 		:dPqty3, 	:dPqty4, 		:dPqty5, 		:dPqty6, 	:dPqty7
//	 from pm02_capa_dtl
//	where yymm = :syymm and itnbr = :sitnbr;
//	if IsNull(dPqty1) then
//		dPqty = 0
//	else
//		if stoday > f_afterday(syymm,6) then
//			dPqty = 0
//		elseif stoday <= syymm then
//			dPqty = dPqty1 + dPqty2 + dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
//		else
//			choose case f_dayterm(syymm,stoday)
//				case 1
//					dPqty = dPqty2 + dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
//				case 2
//					dPqty = dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
//				case 3
//					dPqty = dPqty4 + dPqty5 + dPqty6 + dPqty7
//				case 4
//					dPqty = dPqty5 + dPqty6 + dPqty7
//				case 5
//					dPqty = dPqty6 + dPqty7
//				case 6
//					dPqty = dPqty7
//				case else
//					dPqty = 0
//			end choose
//		end if
//	end if
	
	dw_insert.setitem(ll_row,'jego_qty',dJqty)
	dw_insert.setitem(ll_row,'safe_qty',dSqty)
//	dw_insert.setitem(ll_row,'plan_qty',dPqty)
Next
end subroutine

public subroutine wf_subitem (string as_yymm);DECLARE sub_cur CURSOR FOR
	SELECT ITNBR, WKCTR
	  FROM PM01_CAPA_DTL
	 WHERE YYMM = :as_yymm ;

OPEN sub_cur ;

String ls_sub
String ls_wkctr
Long   ll_cnt
Long   i
Long   ll_chk

SELECT COUNT('X')
  INTO :ll_cnt
  FROM PM01_CAPA_DTL
 WHERE YYMM = :as_yymm ;

For i = 1 To ll_cnt
	FETCH sub_cur INTO :ls_sub, :ls_wkctr ;
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM KUMITEM_KUM
	 WHERE USEYN = 'N'
		AND ITNBR = :ls_sub ;
	If ll_chk > 0 Then
		UPDATE PM01_CAPA_DTL
		   SET S1QTY   = 0, S2QTY   = 0, S3QTY   = 0, S4QTY   = 0, S5QTY   = 0, S6QTY   = 0, S7QTY   = 0, S8QTY   = 0,
			    LOTQTY1 = 0, LOTQTY2 = 0, LOTQTY3 = 0, LOTQTY4 = 0, LOTQTY5 = 0, LOTQTY6 = 0, LOTQTY7 = 0, LOTQTY8 = 0
		 WHERE YYMM  = :as_yymm
		   AND ITNBR = :ls_sub
			AND WKCTR = :ls_wkctr ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('동시작업 품번 For ~ Next', '동시작업 품번 중 SUB ITEM 작업 처리에 실패 했습니다.')
			Return
		End If
	End If
Next

CLOSE sub_cur ;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('동시작업 품번', 'SUB ITEM자료 정리 성공')
Else
	ROLLBACK USING SQLCA;
	MessageBox('동시작업 품번', '동시작업 품번 중 SUB ITEM 작업 처리에 실패 했습니다.')
End If
end subroutine

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

on w_pm01_01020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_kun=create st_kun
this.st_hu=create st_hu
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.cb_1=create cb_1
this.dw_change=create dw_change
this.pb_1=create pb_1
this.p_1=create p_1
this.ole_chart=create ole_chart
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.st_kun
this.Control[iCurrent+5]=this.st_hu
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_change
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.p_1
this.Control[iCurrent+14]=this.ole_chart
end on

on w_pm01_01020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_kun)
destroy(this.st_hu)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.cb_1)
destroy(this.dw_change)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.ole_chart)
end on

event open;call super::open;String sYymm, sdate, edate
Long   nCnt

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)

dw_insert.SetTransObject(sqlca)
dw_change.SetTransObject(sqlca)

dw_1.InsertRow(0)

// 부하계산 기준(1:작업장단위, 2:설비단위)
SELECT SUBSTR(DATANAME,1,1) INTO :is_calgbn FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 15 AND LINENO = 90;
If IsNull(is_calgbn)  or is_calgbn <> '2' then is_calgbn = '1'

// 타설비 대체 popup은 설비단위에서만 사용가능
//If is_calgbn = '1' Then
//	p_search.Visible = False
//End If

/* 최종계획년월 */
SELECT MAX(MONYYMM) INTO :syymm FROM PM01_MONPLAN_SUM;
dw_1.SetItem(1, 'yymm', sYymm)
dw_2.Retrieve(sYymm)

/* 주문변경 유무 */
sdate = dw_2.GetItemString(1, 'week_sdate')
edate = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')

SELECT COUNT(*) INTO :nCnt
  FROM SORDER A
 WHERE A.SABU = :gs_sabu
   AND A.CUST_NAPGI BETWEEN :sdate AND :edate
   AND A.SPECIAL_YN <> 'Y'
	AND A.WEB = 'Y';
If nCnt > 0 Then
	MessageBox('확인','주문내역중 변경된 사항이 존재합니다.!!~r~n생산계획 변경을 먼저 처리하세요.!!')
End If

Post wf_protect(sYymm)
end event

type dw_insert from w_inherite`dw_insert within w_pm01_01020
integer x = 69
integer y = 1132
integer width = 4530
integer height = 1120
string dataobject = "d_pm01_02010_3_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;//Dec dQty, dLotQty, dMinQty, dMulQty
//String sIdx
//Long nRow
//
//nRow = GetRow()
//If nRow <= 0 Then Return
//
//Choose Case GetColumnName()
//	Case 'weekqty1', 'weekqty2', 'weekqty3', 'weekqty4', 'weekqty5', 'weekqty6'		
//		dQty = Dec(GetText())
//		
//		dMinQty = GetItemNumber(nRow, 'minqty')
//		dMulQty = GetItemNumber(nRow, 'minqty')
//		If IsNull(dMinqty) Or dMinqty = 0 Then dMinqty = 0
//		If IsNull(dMulQty) Or dMulQty = 0 Then dMulQty = 1
//				
//		dLotQty = dMinqty + (ceiling((dQty - dMinqty)/dMulQty) * dMulQty)
//		If IsNull(dLotQty) Or dLotQty = 0 Then dLotQty = 0
//		
//		sIdx = Mid(GetColumnName(),8,1)
//		SetItem(nRow, 'weeklot'+sidx, dLotQty)
//		
//		w_mdi_frame.sle_msg.text = 'LOT 적용수량은 ' + STRING(dLotQty,'#,##0') + ' 입니다'
//End Choose
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;//String sCol
//
//sCol = dwo.name
//
//Choose Case dwo.name
//	Case 'weekqty1', 'weekqty2', 'weekqty3','weekqty4', 'weekqty5', 'weekqty6'
//		w_mdi_frame.sle_msg.text = 'LOT 적용수량은 ' + STRING(GetItemNumber(row,'weeklot'+Right(scol,1)),'#,##0') + ' 입니다'
//End Choose
end event

event dw_insert::doubleclicked;call super::doubleclicked;Long		ii
Dec 		dQty, dCumQty, dLotQty, dMinQty, dMulQty
String 	sIdx, sCol

sCol = dwo.name

Choose Case sCol
	Case 'lotqty1', 'lotqty2', 'lotqty3', 'lotqty4', 'lotqty5', 'lotqty6'
		
		dQty = GetItemNumber(row, sCol)
		dCumQty = dQty
		dLotQty = GetItemNumber(row, 'capa_qty')
		
		For ii = 1 To 6
			if dCumQty >= dLotQty then	Exit
			if sCol = 'lotqty'+string(ii) then continue
			dCumQty = dCumQty + GetItemNumber(row, 'lotqty'+string(ii))
			SetItem(row, 'lotqty'+string(ii), 0)
		Next
		SetItem(row, sCol, dCumQty)
End Choose
end event

event dw_insert::rbuttondown;call super::rbuttondown;//cb_1.PostEvent(Clicked!)
dw_insert.accepttext()
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("확인", "부하 조정 실패!!!")
	return
end if

commit;

//p_mod.PostEvent(Clicked!)
p_search.PostEvent(Clicked!)
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
if row > 0 then
	this.selectrow(row,true)
end if
end event

type p_delrow from w_inherite`p_delrow within w_pm01_01020
boolean visible = false
integer x = 2880
integer y = 192
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long nRow

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_pm01_01020
boolean visible = false
integer x = 4928
integer y = 288
boolean enabled = false
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sCarCode = Trim(dw_1.GetItemString(1, 'carcode'))
sCarGbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCarGbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))
If IsNull(sCarCode) Or sCarCode = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'carcode', sCarCode)
dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)

dMax = dw_insert.GetItemNumber(1, 'maxseq')
If IsNull(dMax) then dMax = 0
dMax += 1
dw_insert.SetItem(nRow, 'seq', dMax)
end event

type p_search from w_inherite`p_search within w_pm01_01020
integer x = 3387
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\조정_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조정_up.gif"
end event

event p_search::clicked;call super::clicked;Long nRow
String sMchno, sItnbr, sYYMM, sCol, sGubun, sOpseq

nRow = dw_3.GetSelectedRow(0)
If nRow <= 0 Then 
	messagebox('확인','작업장을 선택하십시오!!!')
	Return
End If

sGubun = dw_3.GetItemString(nRow, 'gubun')
sMchno = dw_3.GetItemString(nRow, 'wkctr')

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then 
	messagebox('확인','품목을 선택하십시오!!!')
	Return
End If

sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sOpseq = dw_insert.GetItemString(nRow, 'opseq')
sYymm = dw_1.GetItemString(1, 'yymm')

gs_code = syymm
gs_codename = sItnbr
gs_codename2 = sMchno
gs_codename3 = sOpseq
gs_gubun     = sGubun	// 1:작업장, 2:설비

//Open(w_pm01_01020_1_new)
Open(w_pm01_01020_1_han)		// 2017.07.10 표준공정 대체작업장으로 변경
If gs_code = 'OK' Then p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_pm01_01020
integer x = 3566
string picturename = "C:\erpman\image\mrp_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\mrp_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\mrp_up.gif"
end event

event p_ins::clicked;call super::clicked;Openwithparm(w_pm01_02040, '2')
SetNull(gs_code)

//동시작업품번 중 sub품일 경우 계획수량을 0으로 update - 안병국과장 요청
//2008.10.10 by shingoon
String ls_yymm
ls_yymm = dw_1.GetItemString(1, 'yymm')
wf_subitem(ls_yymm)
end event

type p_exit from w_inherite`p_exit within w_pm01_01020
end type

type p_can from w_inherite`p_can within w_pm01_01020
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
//dw_1.SetItem(1, 'carcode', sNull)
end event

type p_print from w_inherite`p_print within w_pm01_01020
integer x = 3744
string picturename = "C:\erpman\image\부하계산_up.gif"
end type

event p_print::clicked;String syymm, sdate, edate, sPdtgu, sJocod, sCode
int	 nCnt

If dw_1.AcceptText() <> 1 Then Return

If MessageBox("확 인", "부하조정전 초기 부하로 재계산하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

is_gubun = gs_code

// 작업장 부하계산
nCnt = sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, syymm, '1');

//messagebox('확인', nCnt)

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

COMMIT;

p_inq.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\부하계산_up.gif"
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\부하계산_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_pm01_01020
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String syymm, sdate, edate, sPdtgu, sJocod, sCode, sWkctr
Long		nRow

If dw_1.AcceptText() <> 1 Then Return

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

sJocod = Trim(dw_1.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

sDate = dw_2.GetItemString(1, 'week_sdate')
eDate = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')

string sdate2, edate2, sdate3, edate3, syymm2, syymm3

syymm2 = f_aftermonth(syymm,1)
syymm3 = f_aftermonth(syymm,2)

select min(week_sdate), max(week_edate) into :sdate2, :edate2 from pdtweek where substr(week_sdate,1,6) = :syymm2;
select min(week_sdate), max(week_edate) into :sdate3, :edate3 from pdtweek where substr(week_sdate,1,6) = :syymm3;

/////////////////////////////////////////////////////////////////////////////////
//nRow = dw_3.GetSelectedRow(0)
nRow = Long(dw_3.Describe("datawindow.firstrowonpage"))
If nRow > 0 Then 
	sWkctr = dw_3.GetItemString(nRow,'wkctr')
End If
/////////////////////////////////////////////////////////////////////////////////

//If IsNull(sCode) Or sCode = '' Then
//	sPdtgu = ''
//	sJocod = ''
//Else
//	sPdtgu = Trim(Mid(sCode, 2,6))
//	sJocod = Trim(Mid(sCode, 8,6))
//End If
		
dw_3.Reset()
dw_insert.Reset()

dw_3.SetFilter("gubun = '1'")
dw_3.Filter()


/////////////////////////////////////////////////////////////////////////////////
dw_3.SetRedraw(False)
dw_3.Retrieve(sDate, eDate, sPdtgu+'%', sdate2, edate2, sdate3, edate3, sJocod+'%')
nRow = dw_3.Find("wkctr='"+sWkctr+"'",1,dw_3.RowCount())
If nRow > 0 Then 
dw_3.ScrollToRow(nRow)
End If
dw_3.SetRedraw(True)
/////////////////////////////////////////////////////////////////////////////////
If dw_3.RowCount() < 1 Then
	p_1.picturename = 'C:\erpman\image\엑셀변환_d.gif'
	p_1.Enabled     = False
	Return
End If
p_1.picturename = 'C:\erpman\image\엑셀변환_up.gif'
p_1.Enabled     = True

wf_kunmu()

//WF_CHART(0)

dw_change.Visible = false
dw_insert.Visible = true

Post wf_protect(syymm)
end event

type p_del from w_inherite`p_del within w_pm01_01020
boolean visible = false
integer x = 4837
integer y = 156
end type

type p_mod from w_inherite`p_mod within w_pm01_01020
integer x = 4096
end type

event p_mod::clicked;Long ix, iy, iChng, iNo, iCnt=0
Dec  dReq, dQty[7], dOld[7]
String sOrderNo, sdate, syymm, sCvcod, sItnbr, sCustGbn, sCustNapgi, sPordno, sMogub, sNapgi[7]
String sPdtgu
Int    nJucha

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

syymm = dw_1.GetItemString(1, 'yymm')
sPdtgu = dw_1.GetItemString(1, 'pdtgu')

////주차
//select mon_jucha into :njucha from pdtweek where week_sdate = :sdate;

if dw_insert.update() <> 1 then
	rollback ;
	messagebox("확인", "부하 조정 실패!!!")
	return
end if

commit;

// 작업장 부하계산(사용공수만 재계산)
sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, syymm, '3');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF


////////////////////////////////////////////////////////////////////////////////////////////////////
// 월생산계획 변경
//   - 품목별로 최초공정의 조정된 작업장 생산량 합계값을 생산계획량으로 갱신
UPDATE PM01_MONPLAN_SUM A
   SET A.WEEKLOT1	= ( SELECT SUM(X.LOTQTY1) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.WEEKLOT2	= ( SELECT SUM(X.LOTQTY2) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.WEEKLOT3	= ( SELECT SUM(X.LOTQTY3) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.WEEKLOT4	= ( SELECT SUM(X.LOTQTY4) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.WEEKLOT5	= ( SELECT SUM(X.LOTQTY5) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.WEEKLOT6	= ( SELECT SUM(X.LOTQTY6) FROM PM01_CAPA_DTL X
							  WHERE X.YYMM = A.MONYYMM AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) )
 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :syymm 
   AND EXISTS ( SELECT 'X' FROM PM01_CAPA_DTL WHERE YYMM = A.MONYYMM AND ITNBR = A.ITNBR ) ;

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	rollback ;
	RETURN
END iF

COMMIT;

w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"



//Long ix, iy, iChng, iNo, icnt
//Dec  dReq, dQty[8], dOld[8]
//String sOrderNo, syymm, sCvcod, sItnbr, sCustGbn, sCustNapgi, sPordno, sMogub, sNapgi[8]
//String sPdtgu
//
//syymm = dw_1.GetItemString(1, 'yymm')
//spdtgu = dw_1.GetItemString(1, 'pdtgu')
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//If MessageBox("확 인", "변경된 일정을 조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return
//
//// 기초자료 설정
//sOrderNo = '.'
//select dataname into :sCvcod from syscnfg where sysgu = 'C' AND serial = '4' and lineno = 1; // 자사거래처 코드
//sCustGbn 	= 'Z'	// 고객구분
//sCustNapgi 	= '99991231' // 납기
//
//// 생산일자 선정
//For ix = 1 To 6
//	select min(week_sdate) into :sNapgi[ix] from pdtweek where substr(week_sdate,1,6) = :sYymm and mon_jucha = :ix;
//Next
//For ix = 1 To 2
//	select min(week_sdate) into :sNapgi[ix+6] from pdtweek where substr(week_sdate,1,6) = to_char(add_months(to_date(:sYymm,'yyyymm'), :ix),'yyyymm');
//Next
//
//For ix = 1 To dw_insert.RowCount()
//	
//	iChng		= 0
//	
//	For iy = 1 To 6
//		dQty[iy]	= dw_insert.GetItemNumber(ix, 'weekqty'+string(iy))		// New Value
//		dOld[iy]	= dw_insert.GetItemNumber(ix, 'old_weekqty'+string(iy)) // Old Value
//		
//		If dQty[iy] <> dOld[iy] Then
//			iChng++
//		End If
//	Next
//	
//	For iy = 2 To 3
//		dQty[iy+5]	= dw_insert.GetItemNumber(ix, 'monqty'+string(iy))		// New Value
//		dOld[iy+5]	= dw_insert.GetItemNumber(ix, 'old_monqty'+string(iy)) // Old Value
//		
//		If dQty[iy+5] <> dOld[iy+5] Then
//			iChng++
//		End If
//	Next
//	
//	// 변경된 자료가 있을 경우 기존 자료 cancel후 신규로 자료 작성
//	If iChng > 0 Then
//		sItnbr 		= dw_insert.GetItemString(ix, 'itnbr')
//		sMogub	 	= dw_insert.GetItemString(ix, 'mogub')
//				
//		SELECT MAX(MONSEQ) INTO :iNo
//		  FROM PM01_MONPLAN_DTL
//		 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = 0;
//		
//		For iy = 1 To 8
//			dReq = dQty[iy] - dOld[iy]
//			
//			If dReq <> 0 Then
//				iNo = iNo + 1
//				icnt += 1
//				
//				sPordno = syymm + string(iNo,'00000')
//				
//				INSERT INTO PM01_MONPLAN_DTL 
//						 ( SABU,        MONYYMM,     MONSEQ, CVCOD,   ITNBR,      PLAN_QTY,  ORDER_NO,  CUST_NAPGI,  CUSTGBN, 
//						   ESDATE,      EEDATE,      MOGUB,  PLANSTS, PLDATE,     JUCHA,     PORDNO,    JOCOD )
//				 values( :gs_sabu,    :syymm,      :iNo,   :sCvcod, :sItnbr,    :dReq, 		:sOrderNo, :sCustNapgi, :sCustGbn,
//				         :sNapgi[iy], :sNapgi[iy], :sMogub,'N',     :sNapgi[iy], 0,		   :sPordno,  :spdtgu  );
//				If sqlca.sqlcode <> 0 Then
//					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
//					Rollback;
//					Return
//				End If
//			End If
//		Next
//	End If
//Next
//
//COMMIT;
//
//// 수량 변경시 사용공수 재계산
//If icnt > 0 Then
//	If MessageBox('확인','사용공수를 다시계산하시겠습니까?',Information!, YesNo!) = 1 Then
//		// 작업장 부하계산(사용공수만 재계산)
//		sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, syymm, '3');
//		
//		If sqlca.sqlcode <> 0 Then
//			MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
//			ROLLBACK;
//			RETURN
//		END iF
//		COMMIT;
//		
//		p_inq.TriggerEvent(Clicked!)
//	End If
//End If
//
//dw_insert.Reset()
end event

type cb_exit from w_inherite`cb_exit within w_pm01_01020
end type

type cb_mod from w_inherite`cb_mod within w_pm01_01020
end type

type cb_ins from w_inherite`cb_ins within w_pm01_01020
end type

type cb_del from w_inherite`cb_del within w_pm01_01020
end type

type cb_inq from w_inherite`cb_inq within w_pm01_01020
end type

type cb_print from w_inherite`cb_print within w_pm01_01020
end type

type st_1 from w_inherite`st_1 within w_pm01_01020
end type

type cb_can from w_inherite`cb_can within w_pm01_01020
end type

type cb_search from w_inherite`cb_search within w_pm01_01020
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_01020
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_01020
end type

type dw_1 from u_key_enter within w_pm01_01020
integer x = 78
integer y = 88
integer width = 1609
integer height = 76
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_01020_1"
boolean border = false
end type

event itemchanged;String syymm, sdate, edate, spdtgu, sjocod, snull
Long   nCnt

setnull(snull)
Choose Case GetColumnName()
	Case 'yymm'
		syymm = GetText()
		dw_2.Retrieve(syymm)
		
		/* 주문변경 유무 */
		sdate = dw_2.GetItemString(1, 'week_sdate')
		edate = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')
		
		SELECT COUNT(*) INTO :nCnt
		  FROM SORDER A
		 WHERE A.SABU = :gs_sabu
			AND CUST_NAPGI BETWEEN :sdate AND :edate
			AND A.SPECIAL_YN = 'N'
			AND A.WEB = 'Y'
			AND A.SAUPJ = :gs_saupj;
		If nCnt > 0 Then
			MessageBox('확인','주문내역중 변경된 사항이 존재합니다.!!')
		End If

		Post wf_protect(syymm)
	Case 'pdtgu'
		p_inq.TriggerEvent(Clicked!)
	Case 'jocod'
		sjocod = GetText()
		
		select pdtgu into :spdtgu from jomast where jocod = :sjocod ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'pdtgu',spdtgu)
		else
			this.setitem(1,'pdtgu',snull)
		end if
		
		p_inq.TriggerEvent(Clicked!)
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_2 from datawindow within w_pm01_01020
integer x = 1682
integer y = 92
integer width = 1015
integer height = 72
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00010_3"
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_pm01_01020
event ue_mousemove pbm_mousemove
integer x = 64
integer y = 252
integer width = 2523
integer height = 844
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pm01_01020_5"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;String ls_Object
Long	 ll_Row

If this.Rowcount() < 1 Then Return

ls_Object = Lower(This.GetObjectAtPointer())

/* 작업장 */
If mid(ls_Object, 1, 5)  = 'wcdsc' Then
	ll_Row = long(mid(ls_Object, 6, 3))
	If ll_Row < 1 or isnull(ll_Row) Then Return 
	This.SetRow(ll_row)
	This.SetItem(ll_row, 'opt', '1')
Else
	This.SetItem(This.GetRow(), 'opt', '0')
End If

Return 1
end event

event clicked;String syymm, swkctr, sFilter, ls_Object, sMchno, smindate, smaxdate
Long	 ll_row

If row > 0 Then
	syymm	= dw_1.GetItemString(1, 'yymm')
	swkctr = GetItemString(row, 'wkctr')
	sMchno = Trim(GetItemString(row, 'mchno'))
	If IsNull(sMchno) then sMchno = ''
	
//	If sMchno = '' Then
//		dw_insert.DataObject = 'd_pm01_02010_3'
//		dw_insert.SetTransObject(sqlca)
//		dw_insert.Retrieve(gs_sabu, syymm, swkctr, '%')
//	Else
//		dw_insert.DataObject = 'd_pm01_02010_3_1'
//		dw_insert.SetTransObject(sqlca)
//		dw_insert.Retrieve(gs_sabu, syymm, swkctr, sMchno)
//	End If

	
	dw_insert.Retrieve(syymm, swkctr)

	wf_set_qty()		// 수량-2006.10.11


	////////////////////////////////////////////////////////////////////////////////////////////////////
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	
	wf_chart(row)
	
	If GetItemString(row, 'gubun') = '2' Then Return
	
	ls_Object = Lower(This.GetObjectAtPointer())
	
//	/* 작업장 */
//	IF mid(ls_Object, 1, 5)  = 'wcdsc' THEN 
//		ll_Row = long(mid(ls_Object, 6, 3))
//		if ll_Row < 1 or isnull(ll_Row) then return 
//	
//		If GetItemString(row, 'sub') = '0' Then
//			SetItem(row, 'sub','1')
//			sFilter = "gubun = '1' or ( gubun = '2' and wkctr = '" + GetItemString(row, 'wkctr') + "' )"
//		Else
//			SetItem(row, 'sub','0')
//			sFilter = "gubun = '1' "
//		End If
//		SetFilter(sFilter)
//		Filter()
//		
//		dw_3.SetSort("wkctr, gubun, mchno")
//		dw_3.Sort()
//	END IF

	/* 근무형태 */
	sMindate = dw_2.GetItemString(1, 'min_date')
	sMaxdate = dw_2.GetItemString(1, 'max_date')
	sMinDate = Left(sMinDate,4)+Mid(sMinDate,6,2)+Right(sMinDate,2)
	sMaxdate = Left(sMaxdate,4)+Mid(sMaxdate,6,2)+Right(sMaxdate,2)
	dw_change.Retrieve(sMindate, sMaxDate, sWkctr)
Else
	This.SelectRow(0, FALSE)
	wf_chart(0)
	
//	dw_change.Reset()
End If
end event

type st_kun from statichyperlink within w_pm01_01020
integer x = 2743
integer y = 64
integer width = 507
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "근무일수 :"
boolean focusrectangle = false
end type

event clicked;Long   nRow
String sGubun

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sGubun = Trim(dw_3.GetItemString(nRow, 'gubun'))
	
	// 부하계산이 작업장기준이면서 설비클릭시 return
	If is_calgbn = '1' And sGubun = '2' Then Return
	
	If dw_change.Visible = False Then
		dw_change.Visible = true
		dw_insert.Visible = false
	Else
		dw_change.Visible = False
		dw_insert.Visible = true
	End If
End If

end event

type st_hu from statichyperlink within w_pm01_01020
integer x = 2743
integer y = 140
integer width = 507
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "휴무일수 :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pm01_01020
integer x = 4279
integer y = 192
integer width = 329
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "단위 : HOUR"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pm01_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 244
integer width = 2542
integer height = 860
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pm01_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 59
integer y = 52
integer width = 2647
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 1124
integer width = 4553
integer height = 1144
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_1 from commandbutton within w_pm01_01020
boolean visible = false
integer x = 2971
integer width = 219
integer height = 120
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일정"
end type

event clicked;Long nRow
String sItnbr, sYYMM, sCol

nRow = dw_3.GetSelectedRow(0)
If nRow <= 0 Then Return

If dw_insert.GetRow() <= 0 Then Return

nRow = dw_insert.GetRow()
sCol = dw_insert.GetColumnName()
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')

sYymm = dw_1.GetItemString(1, 'yymm')

gs_gubun = syymm
gs_code = sitnbr
gs_codename = dw_insert.GetItemString(nRow, 'itdsc')

Open(w_pm01_01020_2)
//If gs_code = 'OK' Then p_inq.TriggerEvent(Clicked!)
end event

type dw_change from u_key_enter within w_pm01_01020
boolean visible = false
integer x = 69
integer y = 1140
integer width = 4448
integer height = 1112
integer taborder = 11
string dataobject = "d_pm01_01020_4"
boolean border = false
end type

event itemchanged;String sWkctr, sCldate, sRqcgu, sPdtgu, sDate, edate, sCol, sGubun, sMchno
Dec	 dMin
Long	 nRow

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
	sGubun = Trim(dw_3.GetItemString(nRow, 'gubun'))
	sMchno = Trim(dw_3.GetItemString(nRow, 'mchno'))
Else
	Return
End If
If IsNull(sMchno) Then sMchno = ''

sRqcgu = Trim(GetText())

// 주야로 구분하여 부하계산하는 경우(이원정공) 근무형태에 따른 근무시간
//select to_number(dataname) into :dMin from syscnfg where sysgu = 'Y' and serial = '90' and lineno = :sRqcgu;
//If IsNull(dMin) Then dMin = 0

// 작업장별 시프트로 부하계산하는 경우(패키지 기준)
SELECT DECODE(:sRqcgu, '1', SF1SA, '2', SF2SA, '3', SF3SA, '4', SF4SA,0) INTO :dMin FROM WRKCTR WHERE WKCTR = :sWkctr;
If IsNull(dMin) Then dMin = 0

sCol = GetColumnName()
sCldate= Trim(GetItemString(Row, 'cldate'))

// 설비별 부하계산할 경우 저장
If is_calgbn = '2' Then
	Choose Case left(GetColumnName(),6)
		Case 'rqcgu_'
			UPDATE PM01_CAPA_LOD_MCH
				SET BOTIME3 = (:dMin + BOTIME2) * fun_get_wrkgrp_rate(:sCldate, MCHNO,'2','.'),
					 BOTIME1 = :dMin,
					 RTYPE1 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate
				AND MCHNO LIKE :sMchno||'%';
		Case 'rqcgu2'
			UPDATE PM01_CAPA_LOD_MCH
				SET BOTIME3 = (BOTIME1 + :dMin) * fun_get_wrkgrp_rate(:sCldate, MCHNO,'2','A'),
					 BOTIME2 = :dMin,
					 RTYPE2 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate
				AND MCHNO LIKE :sMchno||'%';
	End Choose
	
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
	
	// 작업장 수정한 경우
	If sGubun = '1' Then
		UPDATE PM01_CAPA_LOD A
			SET ( A.BOTIME3, A.BOTIME1, A.BOTIME2, A.RTYPE1, A.RTYPE2 ) = ( SELECT SUM(B.BOTIME3), SUM(B.BOTIME1), SUM(BOTIME2), MAX(B.RTYPE1), MAX(B.RTYPE2)
																									FROM PM01_CAPA_LOD_MCH B
																								  WHERE B.WKCTR = A.WKCTR
																									 AND B.CLDATE = A.CLDATE )
		 WHERE A.WKCTR = :sWkctr
			AND A.CLDATE = :sCldate;
	// 설비 수정한 경우
	Else
		UPDATE PM01_CAPA_LOD A
			SET ( A.BOTIME3, A.BOTIME1, A.BOTIME2 ) = ( SELECT SUM(B.BOTIME3), SUM(B.BOTIME1), SUM(BOTIME2)
																						FROM PM01_CAPA_LOD_MCH B
																					  WHERE B.WKCTR = A.WKCTR
																						 AND B.CLDATE = A.CLDATE )
		 WHERE A.WKCTR = :sWkctr
			AND A.CLDATE = :sCldate;	
	End If
	
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	Else
		COMMIT;
	End If
Else
// 작업장별 부하계산
	Choose Case left(GetColumnName(),6)
		Case 'rqcgu_'
			UPDATE PM01_CAPA_LOD
				SET BOTIME3 = (:dMin + BOTIME2),
					 BOTIME1 = :dMin,
					 RTYPE1 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate;
		Case 'rqcgu2'
			UPDATE PM01_CAPA_LOD
				SET BOTIME3 = (BOTIME1 + :dMin),
					 BOTIME2 = :dMin,
					 RTYPE2 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate;
	End Choose
	
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

/* 작업장별 부하 재조회 */
String sfilter, sCode, sJocod
string sdate2, edate2, sdate3, edate3, syymm, syymm2, syymm3
Long   nFind

nRow = dw_3.GetRow()
If nRow <= 0 Then Return

syymm  = dw_1.GetItemString(1, 'yymm')
sGubun = dw_3.GetItemString(nrow, 'gubun')
sWkctr = dw_3.GetItemString(nrow, 'wkctr')
sMchno = dw_3.GetItemString(nrow, 'mchno')
sCode  = dw_1.GetItemString(1, 'pdtgu')
sDate = dw_2.GetItemString(1, 'week_sdate')
eDate = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')
If IsNull(sMchno) Then sMchno = ''
If IsNull(sPdtgu) Then sPdtgu = ''

If sGubun = '2' Then
	sFilter = "gubun = '1' or ( gubun = '2' and wkctr = '" + sWkctr + "' )"
Else
	sFilter = "gubun = '1'"
End If

syymm2 = f_aftermonth(syymm,1)
syymm3 = f_aftermonth(syymm,2)

select min(week_sdate), max(week_edate) into :sdate2, :edate2 from pdtweek where substr(week_sdate,1,6) = :syymm2;
select min(week_sdate), max(week_edate) into :sdate3, :edate3 from pdtweek where substr(week_sdate,1,6) = :syymm3;

If IsNull(sCode) Or sCode = '' Then
	sPdtgu = ''
	sJocod = ''
Else
	sPdtgu = Trim(Mid(sCode, 2,6))
	sJocod = Trim(Mid(sCode, 8,6))
End If

dw_3.SetFilter(sFilter)
dw_3.Filter()
dw_3.Retrieve(sDate, eDate, sPdtgu+'%', sdate2, edate2, sdate3, edate3, sJocod+'%')

dw_3.SetSort("wkctr, gubun, mchno")
dw_3.Sort()
		
dw_insert.Reset()

If sGubun = '1' Then
	nFind = dw_3.Find("wkctr = '" + sWkctr + "'", 1, dw_3.RowCount())
Else
	nFind = dw_3.Find("wkctr = '" + sWkctr + "' and mchno = '" + sMchno + "'", 1, dw_3.RowCount())
End If

dw_3.SelectRow(0, FALSE)
dw_3.SelectRow(nFind, TRUE)
dw_3.ScrollToRow(nFind)

WF_CHART(nFind)
wf_kunmu()
end event

type pb_1 from u_pb_cal within w_pm01_01020
integer x = 654
integer y = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'yymm', left(gs_code,6))
dw_1.triggerevent(itemchanged!)
end event

type p_1 from picture within w_pm01_01020
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3186
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type ole_chart from uo_chartfx_ie4 within w_pm01_01020
integer x = 2638
integer y = 248
integer width = 1957
integer height = 848
integer taborder = 100
boolean bringtotop = true
string binarykey = "w_pm01_01020.win"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Dw_pm01_01020.bin 
2600001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe00000006000000070000000800000009fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000003cda8a3001d2f86b0000000300000a400000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000421f498a211d2bfa910009ca8dabd624b000000003cda8a3001d2f86b3cda8a3001d2f86b00000000000000000000000000000001fffffffe000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022000000230000002400000025000000260000002700000028fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
25ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00610061006100610061006f006e0067006500650061006a006d006600650070007300660065006f0073006b006c006f0070006b0065006d0065006c006c007100730066006c0070006b006c006b0066007200660065006c006d006b0066006600720069007a00640000000000000000000000000000000000000000000000000000030000002c3c000015e948435f5f465452415f5f3458040005002ebf0f0000020000000246a8ffff00000032ff7f001e002c0000001e00000004000000000050000000000001000020840000031000020004000000000000000000000000000b002000010003000000000001005a0000000000030000000000010000008000000008007f000000000000000000000000c024000000000000c0240000000000003ff000000000000000000000000000004059000000000002000000003828000280010000000000000000000000003ff00000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000c024000000000000c0240000000000003ff0000000000000000000000000000040590000000000000000000038280002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000000000000000000003ff0006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000002000009c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bff00000000000003ff000000000000000000000000000004059000000000000000000003828000200010000000040440000000000003ff00000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003ff00000ffffffff7fefffffffffffffffefffff000000000000000038680002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000800000000010000010100000f010000108000000000c40031030000ffffff00ff99990066339900ccffff00ffffcc00660066008080ff00cc660000ffcccc0080000000ff00ff0000ffff00ffff0000800080000000800080800000ff000000ffcc0000ffffcc00ccffcc0099ffff00ffcc9900ffffcc00ccffcc0099ffff00ffcc9900cc99ff00ff99cc0099ccff00ff663300cccc330000cc990000ccff000099ff000066ff00996666009696960066330000669933000033000000333300003399006633990099333300333333000000ff0000ff0000ff0000000000800100000701000002010000030100000401000005010000060100000701000008010000090100000a0100000b0100000c0100000d0100000e0100000f0100001000ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff000000000000000000000000200000080000000060000008000000000000000800000000100000080041000500690072006c00610001424400000000000001900000000000000000000000000000000000000008000000000000000800000000000000080000000000000008000000000000000800000000000a000c000000000000000800000000000000080000000000000008000000050000000200000000000000000000000500000002000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000010008ff00000000000000000000000000000000000000000000000000030100000076030006000000000000b1000001f555c42aa111d3440450005dff6451a7010000ff0000010055c42ab111d344f550005da16451a7040000ffff00010002c42ab100d344f555005da11151a7045000ffff6401000300
222ab1000044f555c45da111d3a7045000ffff645100040000b1000001f555c42aa111d3440450005dff6451a7050000ff0000010055c42ab111d344f550005da16451a7040000ffff01000601c435000098f39f373b9c11d14d24a000ffff2029000100000000000273677300001c00680045006b73450150000002200000016e0001ffff0068001276000126000001216e41001061746f6e54206574626c6f6fffff72610126006901217601001000006f6e6e41657461746f6f54207261626c006affff76020126000001216e41001061746f6e54206574626c6f6fffff72610000ffff0007731031000001f39f37c49c11d19824a0003bff20294d2b0000ffe0000030030000011000000200015e73000001000001ab000000d30000015d00000001000001ab000000d30053000d0065697265654c2073646e6567ffff0006ffffffffffffffffffffffff0008ffff0028010000280000000200000028000000280000004d000000180000ffff0000ffffffff0201ffff00024000ffff00007312ffff0001000837c43300d198f39f003b9c11294d24a000ffff2000708b0000007006000100000973120001000000d40000001d0000020100000001000000d40000001e000002070000006f6f54007261626cffff0006ffffffff01d5ffff00330000000f000001cd800001a20000fff000000028ffff0028000000190000001c0000ffff0000ffffffff0046ffff0002400001020000000100000003000000010000000300000044000000090000000000041500000601000973c431000098f39f373b9c11d14d24a000ffff202970ab0000003000000100000073150000000000090000001e000002d400000035000000010000001e000002d4000000366150000a726574747261426effff0006ffffffffffffffffffffffff000fffff0028800000280000ffff00000016ffff001600000016000000160000ffff0000ffffffff0140ffff00024000731400000001000a37c43100d198f39f003b9c11294d24a000ffff200070ab000000300000010000097314001e000000d400000035000002010000001e000000d4000000360000020a0000006c6150006574746506726142ffffff00ffffffffffffffffffffffff00000fff0000288000002800ffffff00000016ff000016000000160000001600ffffff00ffffffff000140ff000002400b730f00000001009f37c43111d198f3a0003b9c20294d240000ffff0000302b000000a00000020302d4730f001e000002d4000001bf000002d30000001e000002d4000001bf0000000600006567654c0006646effffffffffffffffffffffffffffffff0100000800000028000000280000000200000028000000280000000000000018ffffffffffffffff4000030100000002000c731333000001f39f37c49c11d19824a0003bff20294d8b0000ff1006007200000000130000010000097300001e0000028600000038000000010000001e0000028600000039004d00040006756e65ffffff00ffffffff0000e6ff0000300000000f000000de8000003d00fffff000000028ff000028000000150000001900ffffff00ffffffff000046ff0000024000010400000001000000030000000100000003000c8084000400040006000000ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Dw_pm01_01020.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
