$PBExportHeader$w_bkcost10_00010.srw
$PBExportComments$ item별 생산수량 확인
forward
global type w_bkcost10_00010 from w_inherite
end type
type dw_jogun from datawindow within w_bkcost10_00010
end type
type cb_add from commandbutton within w_bkcost10_00010
end type
type dw_update from u_key_enter within w_bkcost10_00010
end type
type p_1 from picture within w_bkcost10_00010
end type
type p_2 from picture within w_bkcost10_00010
end type
type rr_1 from roundrectangle within w_bkcost10_00010
end type
type rr_2 from roundrectangle within w_bkcost10_00010
end type
type rr_3 from roundrectangle within w_bkcost10_00010
end type
end forward

global type w_bkcost10_00010 from w_inherite
integer width = 4649
integer height = 2524
string title = "ITEM별 생산수량 확인"
dw_jogun dw_jogun
cb_add cb_add
dw_update dw_update
p_1 p_1
p_2 p_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_bkcost10_00010 w_bkcost10_00010

type variables
str_itnct str_sitnct
string is_yymm, is_upmu 
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String sFryymm, sToyymm, sNull, sToday, sItdsc, sIspec, sJijil
Long   cnt

SetNull(sNull)

sFryymm = dw_jogun.GetItemString(1, "fryymm")
sToyymm = dw_jogun.GetItemString(1, "toyymm")

/* 추가 품번이 존재하는지 여부 체크 */
Select count(*) Into :cnt From bk_cost_base1
 Where yymm_fr = :sFryymm and yymm_to = :sToyymm and itnbr = :sitnbr;

if cnt > 0 then
  	MessageBox("자료 확인", "해당 품목이 이미 존재합니다.")
	dw_update.SetItem(lrow, "itnbr", sNull)
	dw_update.SetItem(lrow, "itdsc", sNull)
	dw_update.SetItem(lrow, "ispec", sNull)
	dw_update.SetItem(lrow, "jijil", sNull)
  	return 1			
end if
		
sToday = f_today()
//*****************************************************************************
Select itnbr, itdsc, ispec, jijil Into :sitnbr, :sitdsc, :sispec, :sJijil From itemas
 Where (itnbr = :sitnbr) and (useyn = '0');
//*****************************************************************************
if SQLCA.SQLCODE <> 0  then
   open(w_itemas_popup)
	sitnbr = gs_code 
	sitdsc = gs_codename
	sispec = gs_gubun			
end if
		
dw_update.SetItem(lrow, "itnbr", sNull)
dw_update.SetItem(lrow, "itdsc", sNull)
dw_update.SetItem(lrow, "ispec", sNull)
dw_update.SetItem(lrow, "jijil", sNull)
dw_update.SetItem(lrow, "yymm_fr",sNull)
dw_update.SetItem(lrow, "yymm_to",sNull)
dw_update.SetItem(lrow, "saupj", sNull)

if sitnbr = '' Or IsNull(sitnbr) Then Return 1	
		
dw_update.SetItem(lrow, "itnbr", sitnbr)
dw_update.SetItem(lrow, "itdsc", sitdsc)		  
dw_update.SetItem(lrow, "ispec", sispec)
dw_update.SetItem(lrow, "jijil", sJijil)

Return 0
end function

on w_bkcost10_00010.create
int iCurrent
call super::create
this.dw_jogun=create dw_jogun
this.cb_add=create cb_add
this.dw_update=create dw_update
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jogun
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_bkcost10_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jogun)
destroy(this.cb_add)
destroy(this.dw_update)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_Jogun.SetTransObject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_Update.Settransobject(sqlca)

dw_Jogun.Reset()
dw_Jogun.Insertrow(0)

dw_Jogun.setitem(1,'fryymm',left(string(today(),'yyyymmdd'),6))
dw_Jogun.setitem(1,'toyymm',left(string(today(),'yyyymmdd'),6))

w_mdi_frame.sle_msg.Text = 'ITEM별 생산수량을 확인할 기준년월 입력하세요'






end event

type dw_insert from w_inherite`dw_insert within w_bkcost10_00010
boolean visible = false
integer x = 101
integer y = 2516
integer width = 78
integer height = 68
integer taborder = 10
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String sNull, sCol_Name
Long lRow, lQty, lAmt
Dec  dDan

//dw_Insert.AcceptText()
sCol_Name = This.GetColumnName()
lRow = this.GetRow()
SetNull(sNull)

Choose Case sCol_Name
	// 계획수량 조정시 표준단가에 의해 계획금액이 재생성됨
   Case "plan_qty_m1"
		lQty = Long(this.GetText())
		dDan = this.GetItemDecimal(lRow, 'danga')
		lAmt = lQty * dDan
		this.SetItem(lRow, 'plan_amt_m1', lAmt)
   Case "plan_qty_m2"
		lQty = Long(this.GetText())
		dDan = this.GetItemDecimal(lRow, 'danga')
		lAmt = lQty * dDan
		this.SetItem(lRow, 'plan_amt_m2', lAmt)
   Case "plan_qty_m3"
		lQty = Long(this.GetText())
		dDan = this.GetItemDecimal(lRow, 'danga')
		lAmt = lQty * dDan
		this.SetItem(lRow, 'plan_amt_m3', lAmt)
   Case "plan_qty_m4"
		lQty = Long(this.GetText())
		dDan = this.GetItemDecimal(lRow, 'danga')
		lAmt = lQty * dDan
		this.SetItem(lRow, 'plan_amt_m4', lAmt)
end Choose
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_bkcost10_00010
boolean visible = false
integer x = 384
integer y = 3152
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_bkcost10_00010
boolean visible = false
integer x = 210
integer y = 3152
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_bkcost10_00010
integer x = 3054
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;call super::clicked;If dw_jogun.AcceptText() = -1 Then Return

String sFryymm, sToyymm, sSaupj, sItnbr, sItdsc, sIspec, sJijil, sStatus
Long lnewrow

sFryymm  = Trim(dw_jogun.GetItemString(1, 'fryymm'))
If sFryymm = '' or isNull(sFryymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('fryymm')
	Return 1
End If

sToyymm  = Trim(dw_jogun.GetItemString(1, 'toyymm'))
If sToyymm = '' or isNull(sToyymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('toyymm')
	Return 1
End If

if dw_update.rowcount() <= 0 then
	SELECT STATUS
	INTO :sStatus
	FROM BK_COST_BASE1 
	WHERE YYMM_FR = :sFryymm 
	AND YYMM_TO = :sToyymm
	AND ROWNUM = 1;
else
	sStatus = dw_update.object.status[1]
end if

IF sStatus = '2' THEN
	messagebox('확인','이미 확정된 자료가 존재합니다. 확정 취소후 생성하세요.')
	return
end if
	
if MessageBox("생성", sFryymm + " ~ " +sToyymm + "기간의 ITEM별 생산수량을 생성하시겠습니까? ",question!,yesno!, 1) <> 1 THEN Return

Double dIoqty=0, dCnt=0

SELECT STATUS
INTO :sStatus
FROM BK_COST_BASE1 
WHERE YYMM_FR = :sFryymm 
AND YYMM_TO = :sToyymm
AND ROWNUM = 1;
	
IF sStatus = '2' THEN
	messagebox('확인','이미 확정된 자료가 존재합니다. 확정 취소후 생성하세요.')
	return
else 
	if MessageBox("확인", "해당 기간의 자료가 이미 존재합니다. 삭제 후 생성하시겠습니까? ",question!,yesno!, 2) = 2 THEN
		Return
	ELSE
		DELETE FROM BK_COST_BASE1 WHERE YYMM_FR = :sFryymm AND YYMM_TO = :sToyymm;
		
		IF SQLCA.SQLCODE <> 0 THEN
			ROLLBACK;
		ELSE
			COMMIT;
		END IF
	END IF
END IF

SETPOINTER(HOURGLASS!)

dw_update.reset()
dw_update.setredraw(false)

DECLARE CUR_GET_ITNBR CURSOR FOR
SELECT A.SAUPJ, A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, SUM(A.IOQTY)
FROM (SELECT '10' AS SAUPJ, A.ITNBR AS ITNBR, B.ITDSC AS ITDSC, B.ISPEC AS ISPEC, B.JIJIL AS JIJIL, SUM(A.IOQTY) AS IOQTY
		FROM ITEMAS B, IMHIST A
		WHERE A.SABU = B.SABU
		AND A.ITNBR = B.ITNBR
		AND A.IOGBN = 'I10'
		AND A.IO_DATE BETWEEN :sFryymm||'01' AND :sToyymm||'31'
		AND B.ITTYP = '1'
		GROUP BY A.ITNBR, B.ITDSC, B.ISPEC, B.JIJIL
		UNION
		SELECT '10' AS SAUPJ, A.ITNBR AS ITNBR, B.ITDSC AS ITDSC, B.ISPEC AS ISPEC, B.JIJIL AS JIJIL, SUM(A.IOQTY) AS IOQTY
		FROM ITEMAS B, IMHIST A
		WHERE A.SABU = B.SABU
		AND A.ITNBR = B.ITNBR
		AND A.IOGBN = 'I03'
		AND A.OPSEQ = '9999'
		AND A.IO_DATE BETWEEN :sFryymm||'01' AND :sToyymm||'31'
		AND B.ITTYP = '1'
		GROUP BY  A.ITNBR, B.ITDSC, B.ISPEC, B.JIJIL) A
GROUP BY A.SAUPJ, A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL;

OPEN CUR_GET_ITNBR;

DO
	FETCH CUR_GET_ITNBR INTO :sSaupj, :sItnbr, :sItdsc, :sIspec, :sJijil, :dIoqty;
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	lnewrow = dw_update.insertrow(0)
	
	dw_update.setitem(lnewrow,'saupj',sSaupj)
	dw_update.setitem(lnewrow,'yymm_fr',sFryymm)
	dw_update.setitem(lnewrow,'yymm_to',sToyymm)
	dw_update.setitem(lnewrow,'itnbr',sItnbr)
	dw_update.setitem(lnewrow,'itdsc',sItdsc)
	dw_update.setitem(lnewrow,'ispec',sIspec)
	dw_update.setitem(lnewrow,'jijil',sJijil)
	dw_update.setitem(lnewrow,'ioqty',dIoqty)
	dw_update.setitem(lnewrow,'status','1')
LOOP WHILE TRUE

CLOSE CUR_GET_ITNBR;

IF lnewrow > 0 THEN
	if dw_update.update() = 1 then
		commit;
	else
		rollback;
	end if
END IF

dw_update.setredraw(true)

	
	
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_bkcost10_00010
end type

event p_ins::clicked;call super::clicked;If dw_jogun.AcceptText() = -1 Then Return

Long lrow
String sFryymm, sToyymm, sStatus

sFryymm  = Trim(dw_jogun.GetItemString(1, 'fryymm'))
If sFryymm = '' or isNull(sFryymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('fryymm')
	Return 1
End If

sToyymm  = Trim(dw_jogun.GetItemString(1, 'toyymm'))
If sToyymm = '' or isNull(sToyymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('toyymm')
	Return 1
End If

if dw_update.rowcount() > 0 then
	sStatus = dw_update.GetItemString(1, 'status')
else
	select status
	into :sStatus
	from bk_cost_base1
	where yymm_fr = :sFryymm
	and yymm_to = :sToyymm;
end if

if sStatus = '2' then 
	messagebox('확인','확정된 자료는 추가할 수 없습니다.')
	return
end if

lrow = dw_update.InsertRow(0)
dw_update.SetItem(lrow, "saupj", '10')
dw_update.SetItem(lrow, "yymm_fr", sFryymm)
dw_update.SetItem(lrow, "yymm_to", sToyymm)
dw_update.SetItem(lrow, "ioqty", 0)
dw_update.setitem(lrow, "status",'1')

dw_update.scrolltorow(lrow)
dw_update.setcolumn('itnbr')
dw_update.setfocus()

w_mdi_frame.sle_msg.Text = 'ITEM별 생산수량 추가작업 입니다.'

ib_any_typing = False

end event

type p_exit from w_inherite`p_exit within w_bkcost10_00010
end type

type p_can from w_inherite`p_can within w_bkcost10_00010
end type

event p_can::clicked;call super::clicked;dw_Update.Reset()

ib_any_typing = False

/* 요약 */
dw_update.Modify("DataWindow.Header.Height=80")	
dw_update.Modify("DataWindow.Detail.Height=72")

/* Protect */
dw_jogun.Modify("fryymm.protect = 0")
dw_jogun.Modify("toyymm.protect = 0")

dw_Jogun.SetFocus()
dw_jogun.SetColumn("fryymm")
end event

type p_print from w_inherite`p_print within w_bkcost10_00010
boolean visible = false
integer x = 594
integer y = 3164
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_bkcost10_00010
end type

event p_inq::clicked;call super::clicked;If dw_jogun.AcceptText() = -1 Then Return

String sFryymm, sToyymm

sFryymm  = Trim(dw_jogun.GetItemString(1, 'fryymm'))
If sFryymm = '' or isNull(sFryymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('fryymm')
	Return 1
End If

sToyymm  = Trim(dw_jogun.GetItemString(1, 'toyymm'))
If sToyymm = '' or isNull(sToyymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_jogun.SetColumn('toyymm')
	Return 1
End If

/* 조회 */
If dw_Update.Retrieve(sFryymm, sToyymm) > 0 Then
	w_mdi_frame.sle_msg.Text = '조회 완료.'
Else
	MessageBox("확인", '해당 자료가 존재하지 않습니다.')
	w_mdi_frame.sle_msg.Text = '해당 자료가 존재하지 않습니다.'	
	Return
End If

/* 요약 */
dw_update.Modify("DataWindow.Header.Height=80")	
dw_update.Modify("DataWindow.Detail.Height=72")

Return
end event

type p_del from w_inherite`p_del within w_bkcost10_00010
integer x = 3575
end type

event p_del::clicked;call super::clicked;If dw_update.AcceptText() <> 1 Then Return

String sFryymm, sToyymm, sitnbr, sitdsc, sStatus
Long   lrow

lrow = dw_update.GetRow()
If lrow <= 0 Then Return

sFryymm = dw_update.GetItemString(lrow, 'yymm_fr')
sToyymm = dw_update.GetItemString(lrow, 'yymm_to')
sitnbr  = dw_update.GetItemString(lrow, 'itnbr')
sitdsc  = dw_update.GetItemString(lrow, 'itdsc')
sStatus = dw_update.GetItemString(lrow, 'status')

if sStatus = '2' then 
	messagebox('확인','확정된 자료는 삭제할 수 없습니다.')
	return
end if

Beep (1)
if MessageBox("삭제 확인", sitdsc + "를 삭제하시겠습니까? ",question!,yesno!, 2) = 2 THEN Return

// ITEM별 생산수량 확인의 품목 데이타 삭제
DELETE FROM BK_COST_BASE1
WHERE YYMM_FR = :sFryymm 
AND YYMM_TO = :sToyymm
AND ITNBR = :sitnbr;

If SQLCA.SqlCode < 0 then
   f_Message_Chk(31, '[삭제확인]')
	Rollback;
	Return
Else
   Commit;
End If

dw_update.DeleteRow(lrow)

ib_any_typing = False

end event

type p_mod from w_inherite`p_mod within w_bkcost10_00010
integer x = 3749
end type

event p_mod::clicked;call super::clicked;if dw_update.rowcount() <= 0 then return

String  sCheck, sStatus 
Double  dCheck
Long    lrow = 0

sStatus = dw_update.GetItemString(1, 'status')
if sStatus = '2' then 
	return
end if

//**************************************************************//
//*** 생성후 조정 발생시                                     ***//
//**************************************************************//	
w_mdi_frame.sle_msg.Text = '데이타를 저장합니다. 잠시 기다려 주세요!!!'
SetPointer(HourGlass!)	
If dw_Update.AcceptText() <> 1 Then Return
//**********************************************************
// 수량이 조정된 ROW를 찾아 UPDATE
//**********************************************************
Do While lrow <= dw_update.RowCount()
   lrow = dw_update.GetNextModified(lrow, Primary!)
  	if lrow > 0 then
		sCheck = dw_update.GetItemString(lrow, 'itnbr')
		IF ISNULL(sCheck) OR Len(sCheck) = 0 THEN
			messagebox("확인","품번을 입력하세요")
			dw_update.SetColumn('itnbr')
			RETURN
		END IF
  		
		dCheck = dw_update.GetItemNumber(lrow, 'ioqty')
		IF ISNULL(dCheck) THEN
			messagebox("확인","수량을 입력하세요")
			dw_update.SetColumn('ioqty')
			RETURN
		END IF
	else
  		lrow = dw_update.RowCount() + 1
  	end if
Loop

IF dw_update.Update() = 1 THEN
	COMMIT;
	MessageBox('확 인','ITEM별 생산수량을 저장하였습니다')
ELSE
	ROLLBACK;
	MessageBox('확 인','ITEM별 생산수량을 저장에 실패하였습니다')
	RETURN
END IF

p_inq.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_bkcost10_00010
integer x = 3182
integer y = 3352
integer taborder = 140
end type

type cb_mod from w_inherite`cb_mod within w_bkcost10_00010
integer x = 2459
integer y = 3352
integer taborder = 80
end type

type cb_ins from w_inherite`cb_ins within w_bkcost10_00010
integer x = 1102
integer y = 3352
integer taborder = 70
string text = "생성(&I)"
end type

type cb_del from w_inherite`cb_del within w_bkcost10_00010
integer x = 741
integer y = 3352
integer taborder = 90
string text = "삭제(&E)"
end type

type cb_inq from w_inherite`cb_inq within w_bkcost10_00010
integer x = 18
integer y = 3352
integer taborder = 100
end type

type cb_print from w_inherite`cb_print within w_bkcost10_00010
integer x = 1527
integer y = 3156
integer taborder = 110
end type

type st_1 from w_inherite`st_1 within w_bkcost10_00010
end type

type cb_can from w_inherite`cb_can within w_bkcost10_00010
integer x = 2825
integer y = 3352
integer taborder = 120
end type

type cb_search from w_inherite`cb_search within w_bkcost10_00010
integer x = 1957
integer y = 3152
integer taborder = 130
end type







type gb_button1 from w_inherite`gb_button1 within w_bkcost10_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_bkcost10_00010
end type

type dw_jogun from datawindow within w_bkcost10_00010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 56
integer width = 1015
integer height = 88
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_bkcost_00010_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;if key = keyf1! then
	triggerevent(rbuttondown!)
End if
end event

event itemchanged;String  sNull, sdata, sname, sname1
Long    nRow, ireturn

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* 계획년도 */
	Case 'sym'
		is_yymm = gettext()
		If f_datechk(is_yymm+'01') <> 1 Then
			f_message_chk(35,'')
			is_yymm = ''
			Return 1
		End If
	/* 거래처 */
	Case "fr_itcls"

		sData = gettext()
		ireturn = f_get_name2("V1", 'Y', sdata, sname, sname1)
		if ireturn = 0 then
			setitem(1, "fr_itclsnm", sName)
		Else
			setitem(1, "fr_itcls",   sNull)
			setitem(1, "fr_itclsnm", sNull)
			return 1
		End if		
	/* 요약/상세구분 */
	Case "to_itcls"
		sData = gettext()
		If Sdata = '1' then
			dw_update.Modify("DataWindow.Header.Height=80")	
			dw_update.Modify("DataWindow.Detail.Height=72")
		Else
			dw_update.Modify("DataWindow.Header.Height=156")	
			dw_update.Modify("DataWindow.Detail.Height=150")
		End if
End Choose
end event

event itemerror;return 1
end event

event rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* 거래처 */
	Case "fr_itcls"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'fr_itcls', gs_code)
		TriggerEvent(ItemChanged!)
END Choose

end event

type cb_add from commandbutton within w_bkcost10_00010
integer x = 379
integer y = 3352
integer width = 334
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

type dw_update from u_key_enter within w_bkcost10_00010
event ue_key pbm_dwnkey
integer x = 23
integer y = 192
integer width = 4571
integer height = 2096
integer taborder = 40
string dataobject = "d_bkcost_00010_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keyhome!
		dw_update.scrolltorow(1)
	case keyend!
		dw_update.scrolltorow(dw_update.rowcount())
	case keyf1!
		triggerevent(rbuttondown!)
end choose


end event

event itemchanged;String sNull, sitnbr, sData, sitdsc, sispec, sItnbrGbn, sPangb, sJijil
Long i, lRow, nRtn

lRow = GetRow()
If lRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* 품번 */
	Case "itnbr"
      sData = Trim(GetText())
      If IsNull(sData) Or sData = '' Then Return 1
		Select itnbr
		Into :sitnbr
		From itemas
 		Where (itnbr = :sData) ;
//		and (useyn in('0','1'));
			
		if SQLCA.SQLCODE <> 0  then
			Messagebox('확인','미등록 품목은 추가 할 수 없습니다.')
			sData = dw_update.object.itnbr[row]
			SetItem(lRow,"itnbr",sData)
			return 1
		end if
		If lRow > 0 Then
			For i = 1 To this.RowCount()
				If i = lRow Then exit
				sItnbr = GetItemString(i,'itnbr')
				If sData = sItnbr Then 
					Messagebox('확인','이미 등록된 품목은 추가 할 수 없습니다.')
					nRtn = -1
					Exit					
				End If
			Next
			If nRtn < 0 Then
				this.SetItem(lRow, "itnbr", sNull)
				this.SetColumn('itnbr')
				Return 1
			Else
				SELECT "ITEMAS"."ITDSC",
					 "ITEMAS"."ITTYP",
					 "ITEMAS"."PANGBN"
			  INTO :sItDsc,
					 :sItnbrGbn, 
					 :sPangb
			  FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sData ;
//			  AND	  "ITEMAS"."USEYN" in('0','1') ;
			
				SetItem(lRow,"itnbr",sData)
				SetItem(lRow,"itdsc",sItDsc)
			End If
		Else
			nRtn = wf_check_itnbr(lRow,sData)
			If nRtn < 0 Then Return 1
			
			Select itnbr, itdsc, ispec, jijil 
			Into :sItnbr, :sItdsc, :sIspec, :sJijil 
			From itemas
			Where (itnbr = :sItnbr) ;
//			and (useyn in('0','1'));
			
			SetItem(lRow, "itnbr", sItnbr)
			SetItem(lRow, "itdsc", sItdsc)
			SetItem(lRow, "ispec", sIspec)
			SetItem(lRow, "jijil", sJijil)
		End If
End Choose 
end event

event itemerror;return 1
end event

event rbuttondown;String sCol_Name, sItnbr, sItDsc, sItnbrGbn, sPangb, lsItnbrYn, sNull
Long   i, lrow, nRtn

sCol_Name = GetColumnName()
lrow = GetRow()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
	// 품목코드 에디트에 Right 버턴클릭시 Popup 화면
	Case "itnbr"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		If lrow > 0 Then
			For i = 1 To lrow
				If i = lrow Then exit
				sItnbr = this.GetItemString(i,'itnbr')
				If gs_code = sItnbr Then 
					messagebox('확인','이미 등록된 품목은 추가 할 수 없습니다.')
					nRtn = -1
					Return
				End If
			Next
			If nRtn < 0 Then
				this.SetItem(lrow, "itnbr", sNull)
				this.SetColumn('itnbr')
				Return 1
			End If
			
			SELECT "ITEMAS"."ITDSC",
					 "ITEMAS"."ITTYP",
					 "ITEMAS"."PANGBN"
			  INTO :sItDsc,
					 :sItnbrGbn, 
					 :sPangb
			  FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :gs_code ; 
//			  AND		"ITEMAS"."USEYN" in('0','1') ;
	
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(lrow, "itnbr", sNull)
				this.TriggerEvent(RbuttonDown!)
				Return 2
			END IF
	
			/* 입력가능여부 */
			SELECT DECODE(RFNA2,'N',RFNA2,'Y') INTO :lsItnbrYn
			  FROM REFFPF  
			 WHERE RFCOD = '05' AND     RFGUB <> '00' AND
					 RFGUB = :sItnbrGbn;
			
			If IsNull(lsItnbrYn) Then lsItnbrYn = 'Y'
			
			If lsItnbrYn = 'N' Then
				f_message_chk(58,'')
				Return 1
			End If
			
			SetItem(lrow,"itnbr",gs_code)		
			SetItem(lrow,"itdsc",sItDsc)
		Else
			nRtn = wf_check_itnbr(lrow,gs_code)
			If nRtn < 0 Then Return 1
			
			Select itnbr
			Into :sItnbr
			From itemas
			Where (itnbr = :sItnbr) ;
//			and (useyn in('0','1'));
			
			SetItem(lrow, "itnbr", gs_code)
			SetItem(lrow, "itdsc", sItdsc)
		End If
//	Case "itdsc"
//   	gs_codename = GetText()
//	
//	   open(w_itemas_popup)
//   	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
//	
//	   SetItem(lrow,"itnbr",gs_code)
//		wf_check_itnbr(lrow, gs_code)
//		Return 1
//   Case "ispec", "jijil"
//	   gs_gubun = GetText()
// 	
//   	open(w_itemas_popup)
//	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
//	
//   	SetItem(lrow,"itnbr",gs_code)
//		wf_check_itnbr(lrow, gs_code)
//		Return 1
End Choose

end event

event clicked;call super::clicked;IF ROW > 0 THEN
	SELECTROW(0,FALSE)
	SELECTROW(ROW,TRUE)
ELSE
	SELECTROW(0,FALSE)
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;SELECTROW(0,FALSE)
SELECTROW(CURRENTROW,TRUE)
end event

type p_1 from picture within w_bkcost10_00010
event ue_lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
integer x = 3922
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\확정_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

event clicked;Integer i

If dw_update.RowCount() <= 0 Then
	MessageBox('확 인','확정할 자료가 없습니다.')
	Return
End If

If MessageBox('확 인','ITEM별 생산수량을 확정 합니다.'+&
								 '~n~r~n~r확정 하시겠습니까?', Exclamation!, OKCancel!, 2) = 1 then
	For i = 1 To dw_update.Rowcount()
		dw_update.SetItem(i,'status','2')
	Next
		
	IF dw_update.Update() = 1 THEN
		COMMIT;
		w_mdi_frame.sle_msg.Text = ''
	ELSE
		ROLLBACK;
		MessageBox('확 인',SQLCA.SQLErrText)
	END IF
end if

MessageBox('확 인','ITEM별 생산수량을 확정하였습니다')

ib_any_typing = false
end event

type p_2 from picture within w_bkcost10_00010
event ue_lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\확정취소_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\확정취소_dn.gif"
end event

event lbuttonup;PictureName = "C:\erpman\image\확정취소_up.gif"
end event

event clicked;Integer i

If dw_update.RowCount() <= 0 Then
	MessageBox('확 인','확정 취소할 자료가 없습니다.')
	Return
End If

If MessageBox('확 인','ITEM별 생산수량을 확정 취소 합니다.'+&
								 '~n~r~n~r확정 취소 하시겠습니까?', Exclamation!, OKCancel!, 2) = 1 then
	For i = 1 To dw_update.Rowcount()
		dw_update.SetItem(i,'status','1')
	Next
		
	IF dw_update.Update() = 1 THEN
		COMMIT;
		w_mdi_frame.sle_msg.Text = ''
	ELSE
		ROLLBACK;
		MessageBox('확 인',SQLCA.SQLErrText)
	END IF	
End If
	
MessageBox('확 인','ITEM별 생산수량을 확정취소하였습니다')

ib_any_typing = false
end event

type rr_1 from roundrectangle within w_bkcost10_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 32
integer width = 1051
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_bkcost10_00010
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 300
integer width = 3365
integer height = 68
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_bkcost10_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 180
integer width = 4599
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

