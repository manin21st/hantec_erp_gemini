$PBExportHeader$w_mat_03025.srw
$PBExportComments$** 이월 재고 관리
forward
global type w_mat_03025 from w_inherite
end type
type dw_1 from datawindow within w_mat_03025
end type
type st_2 from statictext within w_mat_03025
end type
type st_3 from statictext within w_mat_03025
end type
type rr_1 from roundrectangle within w_mat_03025
end type
end forward

global type w_mat_03025 from w_inherite
string title = "이월 재고 관리"
dw_1 dw_1
st_2 st_2
st_3 st_3
rr_1 rr_1
end type
global w_mat_03025 w_mat_03025

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_dup_chk ()
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'pspec')) or &
	dw_insert.GetItemString(i,'pspec') = '' then
	dw_insert.SetItem(i, 'pspec', '.')
end if	

if isnull(dw_insert.GetItemString(i,'iogbn')) or &
	dw_insert.GetItemString(i,'iogbn') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  수불구분]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('iogbn')
	dw_insert.SetFocus()
	return -1		
end if	

If dw_insert.GetItemString(i,'lotgub') = 'Y' Then
	if isnull(dw_insert.GetItemString(i,'lotno')) or &
		dw_insert.GetItemString(i,'lotno') = '.' then
		f_message_chk(1400,'[ '+string(i)+' 행  LOT NO]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('lotno')
		dw_insert.SetFocus()
		return -1		
	end if
End If

if isnull(dw_insert.GetItemNumber(i,'jqty')) then
	f_message_chk(1400,'[ '+string(i)+' 행  수불수량]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('jqty')
	dw_insert.SetFocus()
	return -1		
end if

//if isnull(dw_insert.GetItemNumber(i,'jamt')) then
//	f_message_chk(1400,'[ '+string(i)+' 행  수불금액]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('jamt')
//	dw_insert.SetFocus()
//	return -1		
//end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)
dw_1.setitem(1, 'yymm', left(is_today, 6))
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind

FOR k = dw_insert.rowcount() TO 1 step - 1
   sfind = dw_insert.getitemstring(k, 'sdup')

	lReturnRow = dw_insert.Find("sdup = '"+sfind+"' ", 1, dw_insert.RowCount())
	
	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번/사양]')
		dw_insert.Setrow(k)
		dw_insert.Setcolumn('pspec')
		dw_insert.setfocus()
		RETURN  -1
	END IF
NEXT

return 1
end function

on w_mat_03025.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_mat_03025.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'yymm', left(is_today, 6))
dw_1.SetFocus()


//입고 
f_child_saupj(dw_1, 'sdepot', gs_saupj)
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose




end event

type dw_insert from w_inherite`dw_insert within w_mat_03025
integer x = 32
integer y = 192
integer width = 4571
integer height = 2124
integer taborder = 40
string dataobject = "d_mat_03025_lot"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

choose case key
	case KeyF1! 
   	TriggerEvent(RbuttonDown!)
	case KeyF2! 
		IF This.GetColumnName() = "itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(this.getrow(),"itnbr",gs_code)
			this.TriggerEvent(ItemChanged!)
		End If
	case KeyEnter! 
		if this.getcolumnname() = "jamt" then
			if this.rowcount() = this.getrow() then
				cb_ins.postevent(clicked!)
				return 1
			end if
		end if
end choose

end event

event dw_insert::rbuttondown;Long iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec , ls_jijil , ls_ispec_code, ls_itnbr, sLotgub, sLotno, sdup
integer  ireturn
long     lrow, lreturnrow, i
dec {3}  dqty

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	
	sdup = sitnbr + trim(getitemstring(lrow, 'pspec'))  + trim(getitemstring(lrow, 'lotno'))
	For i=1 to this.RowCount()
		ls_itnbr = Trim(this.GetItemString(i,'itnbr')) + trim(getitemstring(i, 'pspec'))  + trim(getitemstring(i, 'lotno'))
		If sItnbr = ls_itnbr and i <> lrow Then 
			MessageBox("동일품번 존재","동일한 품번이 " + String(i) + " 번째 줄에 있습니다.~n품번을 확인하십시요")
			this.SetItem(lrow, 'itnbr', '')
			Return 1
		End If
	Next
	
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	
	SELECT LOTGUB INTO :sLotgub FROM ITEMAS WHERE ITNBR = :sItnbr;
	this.setitem(lrow, "lotgub", sLotgub)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	ls_jijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)

	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	ls_ispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)

	RETURN ireturn
ELSEIF this.GetColumnName() = "jqty"	THEN	
	dqty = dec(gettext())
	setitem(lrow, "stockmonth_lot_iqty", dqty)
ELSEIF this.GetColumnName() = "jamt"	THEN		
	dqty = dec(gettext())
	setitem(lrow, "stockmonth_lot_iamt", dqty)	
ElseIF this.GetColumnName() = "lotno"	THEN
	sLotNo = Trim(GetText())
	If Trim(sLotNo) = '' Then
		SetItem(lrow, 'lotno', '.')
		return 1
	End If
END IF
end event

event dw_insert::sqlpreview;//dw_1.accepttext()
//
//STRING SJUMIN, SSABUN, SSDATE, SSTIME
//
//sjumin = dw_1.getitemstring(1, "jumin")
//ssabun = dw_1.getitemstring(1, "sabun")
//
//if isnull(sjumin) or trim(sjumin) = '' or isnull(ssabun) or trim(ssabun) = '' then
//	rollback;
//	messagebox("확인", "사번및 주민등록 번호를 입력하십시요", stopsign!)
//	return 1
//end if
//
//SELECT TO_CHAR(SYSDATE, 'HH:MM:SS:MI'),
//		 TO_CHAR(SYSDATE, 'YYYYMMDD')
//  INTO :SSDATE, :SSTIME
//  FROM DUAL;
//  
//  string sss
//  sss = sqlsyntax
//
//if LEFT(UPPER(SSS), 6) = 'INSERT' OR &
//   LEFT(UPPER(SSS), 6) = 'UPDATE' OR &
//   LEFT(UPPER(SSS), 6) = 'DELETE' THEN
//	INSERT INTO STOCKMONTH_SAVE (JUMIN, SABUN, SQLTAX, CDATE, CTIME)
//	VALUES (:sjumin, :ssabun, :sss, :ssdate, :sstime);
//END IF
//
end event

type p_delrow from w_inherite`p_delrow within w_mat_03025
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;long i, irow, irow2
string sdepot, sitnbr, spspec

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中....."

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN
			w_mdi_frame.sle_msg.text = ""
			RETURN
		END IF	
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN
		w_mdi_frame.sle_msg.text = ""
		RETURN
	END IF	
NEXT
sle_msg.text = ""

if f_msg_delete() = -1 then return

sdepot = dw_insert.getitemstring(dw_insert.getrow(), 'depot_no')
sitnbr = dw_insert.getitemstring(dw_insert.getrow(), 'itnbr')
spspec = dw_insert.getitemstring(dw_insert.getrow(), 'pspec')

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   w_mdi_frame.sle_msg.text = ""
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_mat_03025
integer x = 3749
end type

event p_addrow::clicked;call super::clicked;string s_yymm, s_depot
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_yymm  = trim(dw_1.GetItemString(1,'yymm'))
s_depot = dw_1.GetItemString(1,'sdepot')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('yymm')
	dw_1.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.Setcolumn('sdepot')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中....."

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN 
      sle_msg.text = ""
		RETURN
	END IF	
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'stock_yymm', s_yymm )
dw_insert.setitem(il_currow, 'depot_no', s_depot )
dw_insert.setitem(il_currow, 'opt', 'Y' )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

ib_any_typing =True
w_mdi_frame.sle_msg.text = ""

end event

type p_search from w_inherite`p_search within w_mat_03025
boolean visible = false
integer x = 1710
integer y = 2440
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mat_03025
boolean visible = false
integer x = 2066
integer y = 2424
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mat_03025
end type

type p_can from w_inherite`p_can within w_mat_03025
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE
end event

type p_print from w_inherite`p_print within w_mat_03025
boolean visible = false
integer x = 1883
integer y = 2440
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mat_03025
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string s_yymm, s_depot, s_fritnbr, s_toitnbr

if dw_1.AcceptText() = -1 then return 

s_yymm = trim(dw_1.GetItemString(1,'yymm'))
s_depot = trim(dw_1.GetItemString(1,'sdepot'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('sdepot')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)

if dw_insert.Retrieve(s_yymm, s_depot) <= 0 then 
	dw_1.Setfocus()
	return
else
   dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_mat_03025
boolean visible = false
integer x = 2263
integer y = 2444
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_mat_03025
integer x = 4096
end type

event p_mod::clicked;call super::clicked;string sdepot, syymm, sitnbr, spspec, get_nm
long i, k, icount
dec  dqty

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

sdepot = dw_1.getitemstring(1, 'sdepot')
syymm  = dw_1.getitemstring(1, 'yymm')

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中....."

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN
      sle_msg.text = ""
		RETURN
	END IF	
NEXT

//sle_msg.text = "자료 중복 여부 확인 中....."
//if wf_dup_chk() = -1 then
//   sle_msg.text = ""
//	return 
//END IF

w_mdi_frame.sle_msg.text = ""
IF Messagebox('저 장','저장 하시겠습니까?', Question!,YesNo!,1) = 2 THEN
   Return 
END IF

SetPointer(HourGlass!)
sle_msg.text = "자료 저장 中....."
if dw_insert.update() = 1 then
	/* STOCKMONTH_LOT 에서 STOCKMONTH 로 UPDATE 실시 */
	DELETE FROM STOCKMONTH WHERE STOCK_YYMM = :syymm AND DEPOT_NO = :sdepot AND IOGBN = 'A00';
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK;
		RETURN
	END IF
	
	INSERT INTO STOCKMONTH 
	( STOCK_YYMM, DEPOT_NO, ITNBR, PSPEC, IOGBN, JQTY, JAMT, JGONG_QTY, JGONG_AMT, IQTY, IAMT, OQTY, OAMT )
	SELECT STOCK_YYMM, DEPOT_NO, ITNBR, PSPEC, IOGBN, SUM(JQTY), SUM(JAMT), SUM(JGONG_QTY), SUM(JGONG_AMT), SUM(IQTY), SUM(IAMT), SUM(OQTY), SUM(OAMT)
	  FROM STOCKMONTH_LOT
	 WHERE STOCK_YYMM = :syymm AND DEPOT_NO = :sdepot AND IOGBN = 'A00'
	 GROUP BY STOCK_YYMM, DEPOT_NO, ITNBR, PSPEC, IOGBN;
   IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK;
		RETURN
	END IF
	
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	w_mdi_frame.sle_msg.text = ""
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if
end event

type cb_exit from w_inherite`cb_exit within w_mat_03025
end type

type cb_mod from w_inherite`cb_mod within w_mat_03025
end type

type cb_ins from w_inherite`cb_ins within w_mat_03025
end type

type cb_del from w_inherite`cb_del within w_mat_03025
end type

type cb_inq from w_inherite`cb_inq within w_mat_03025
end type

type cb_print from w_inherite`cb_print within w_mat_03025
integer x = 1984
integer y = 2544
end type

type st_1 from w_inherite`st_1 within w_mat_03025
end type

type cb_can from w_inherite`cb_can within w_mat_03025
end type

type cb_search from w_inherite`cb_search within w_mat_03025
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_mat_03025
integer y = 2952
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_mat_03025
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03025
end type

type dw_1 from datawindow within w_mat_03025
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer y = 24
integer width = 1925
integer height = 140
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mat_03025_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//setnull(gs_code)
//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//		IF This.GetColumnName() = "fr_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"fr_itnbr",gs_code)
//			RETURN 1
//		ELSEIF This.GetColumnName() = "to_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"to_itnbr",gs_code)
//			RETURN 1
//      End If
//END IF
//
end event

event itemerror;return 1
end event

event rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//if this.GetColumnName() = 'fr_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"fr_itnbr",gs_code)
//elseif this.GetColumnName() = 'to_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"to_itnbr",gs_code)
//end if	
//
end event

event itemchanged;string  snull, s_depot, s_depnm, s_depnm2, sdate
integer ireturn 

setnull(snull)

if this.accepttext() = -1 then return 

IF this.GetColumnName() ="yymm" THEN
	sdate = trim(this.GetText())
	s_depot = this.getitemstring(1, 'sdepot')
	
	if sdate = "" or isnull(sdate) then
      dw_insert.reset()
		return 
   end if
	
  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "yymm", sNull)
      dw_insert.reset()
		return 1
   END IF

	dw_insert.Retrieve(sdate, s_depot) 
	
ELSEIF this.GetColumnName() ="sdepot" THEN
	s_depot = trim(this.GetText())
	sdate   = this.getitemstring(1, 'yymm')
	ireturn = f_get_name2('창고', 'N', s_depot, s_depnm, s_depnm2)
	dw_insert.Retrieve(sdate, s_depot) 
	return ireturn
	
//ELSEIF this.GetColumnName() ="sabun" THEN	
//	s_depot = gettext()
//	setnull(sdate)
//	select retiredate into :sdate
//	  from p1_master
//	 where companycode = 'GR' and empno = :s_depot;
//	 
//	if sqlca.sqlcode <> 0 or not isnull(sdate) then
//		Messagebox("사번","사번이 부정확합니다", stopsign!)
//		setitem(1, "sabun", snull)
//		return 1
//	end if
//ELSEIF this.GetColumnName() ="jumin" THEN	
//	s_depot = gettext()
//	setnull(sdate)
//	select retiredate, empno into :sdate, :s_depnm
//	  from p1_master
//	 where companycode = 'GR' and residentno1||residentno2 = :s_depot;
//	 
//	if sqlca.sqlcode <> 0 or not isnull(sdate) or getitemstring(1, "sabun") <> s_depnm then
//		Messagebox("사번","사번이 부정확합니다", stopsign!)
//		setitem(1, "sabun", snull)
//		return 1
//	end if	
//	
//	
End if

ib_any_typing = FALSE

end event

event losefocus;if this.accepttext() = -1 then return 

end event

type st_2 from statictext within w_mat_03025
integer x = 1993
integer y = 40
integer width = 1280
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "* 이월 재고 변경시 수불자료 복구프로그램을 "
boolean focusrectangle = false
end type

type st_3 from statictext within w_mat_03025
integer x = 2057
integer y = 100
integer width = 1038
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "이용하여 수불을 복구하여야 합니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_mat_03025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 4590
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

