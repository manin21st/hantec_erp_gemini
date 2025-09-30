$PBExportHeader$w_sm01_00015_ex.srw
$PBExportComments$PO Sheet등록 (한텍추가-수출월판)
forward
global type w_sm01_00015_ex from w_inherite
end type
type dw_temp from datawindow within w_sm01_00015_ex
end type
type dw_save from datawindow within w_sm01_00015_ex
end type
type rb_car from radiobutton within w_sm01_00015_ex
end type
type rb_itnbr from radiobutton within w_sm01_00015_ex
end type
type rr_1 from roundrectangle within w_sm01_00015_ex
end type
type dw_1 from u_key_enter within w_sm01_00015_ex
end type
type p_1 from uo_picture within w_sm01_00015_ex
end type
type p_2 from uo_picture within w_sm01_00015_ex
end type
type cb_1 from commandbutton within w_sm01_00015_ex
end type
end forward

global type w_sm01_00015_ex from w_inherite
integer width = 4654
integer height = 2632
string title = "PO Sheet 등록"
dw_temp dw_temp
dw_save dw_save
rb_car rb_car
rb_itnbr rb_itnbr
rr_1 rr_1
dw_1 dw_1
p_1 p_1
p_2 p_2
cb_1 cb_1
end type
global w_sm01_00015_ex w_sm01_00015_ex

forward prototypes
public function integer wf_danga (integer arg_row)
public subroutine wf_init ()
public function integer wf_requiredchk ()
end prototypes

public function integer wf_danga (integer arg_row);//String sCvcod, sItnbr, stoday, sGiDate ,sCurr
//Double	 dDanga
//Long ll_rtn
//
//If arg_row <= 0 Then Return 1
//
//sToday	= f_today()
//sGiDate	= dw_1.GetItemString(1, 'yymm')+'01'	// 단가기준일자
//sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
//sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))
//
//dDanga = sqlca.fun_erp100000012_1(sGiDate, sCVCOD, sITNBR,'1') ;
//
//If IsNull(dDanga) Then dDanga = 0
//
//dw_insert.Setitem(arg_row, 'sprc', dDanga)

Return 0
end function

public subroutine wf_init ();dw_1.Reset()
dw_1.InsertRow(0)
dw_1.Object.yymm[1] = Left(is_today,6)
/* User별 사업장 Setting Start */
setnull(gs_code)
//사업장 선택 할 수 있도록 수정 2016.04.12 신동준
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
//End If
/* ---------------------- End  */
dw_1.SetColumn("cvcod")

dw_insert.Reset()

end subroutine

public function integer wf_requiredchk ();Long 		ix, nRow
String 	ls_new, ls_saupj, ls_cvcod, ls_itnbr, ls_itemno, ls_yymm, ls_jpno
Decimal	ld_mmqty, ld_sqty
Integer	iMaxNo, icnt

/* 번호채번 */
iMaxNo = sqlca.fun_junpyo(gs_sabu, is_today, 'F0')
IF iMaxNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
commit;

ls_jpno = is_today + String(iMaxNo,'0000')

For ix = 1 To dw_insert.RowCount()
	ls_saupj = Trim(dw_insert.Object.saupj[ix])
	ls_cvcod = Trim(dw_insert.Object.cvcod[ix])
	ls_yymm  = Trim(dw_insert.Object.yymm[ix])
	ls_itnbr = Trim(dw_insert.Object.itnbr[ix])
	ls_itemno= Trim(dw_insert.Object.itemno[ix])
	ld_mmqty = dw_insert.GetItemNumber(ix, "mmqty1")
	ld_sqty  = dw_insert.GetItemNumber(ix, "s1qty")
	
	If IsNull(ls_cvcod) Or ls_cvcod = '' Then
		f_message_chk(1400,'[Buyer]')
		dw_insert.SetColumn('cvcod')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetFocus()
		return -1
	End If
	
	If IsNull(ls_itnbr) Or ls_itnbr = '' Then
		f_message_chk(1400,'[품번]')
		dw_insert.SetColumn('itnbr')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetFocus()
		return -1
	End If

	If IsNull(ld_mmqty) Or ld_mmqty <= 0 Then
		f_message_chk(1400,'[수량]')
		dw_insert.SetColumn('mmqty1')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetFocus()
		return -1
	End If

	If IsNull(ld_sqty) Or ld_sqty <= 0 Then
		f_message_chk(1400,'[PLT수량]')
		dw_insert.SetColumn('s1qty')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetFocus()
		return -1
	End If

	/* 번호채번 */
	If IsNull(ls_itemno) Or ls_itemno = '' Then
		icnt++
		dw_insert.SetItem(ix, 'itemno', ls_jpno + String(icnt,'000'))
	End If
Next

return 1
end function

on w_sm01_00015_ex.create
int iCurrent
call super::create
this.dw_temp=create dw_temp
this.dw_save=create dw_save
this.rb_car=create rb_car
this.rb_itnbr=create rb_itnbr
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temp
this.Control[iCurrent+2]=this.dw_save
this.Control[iCurrent+3]=this.rb_car
this.Control[iCurrent+4]=this.rb_itnbr
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.p_2
this.Control[iCurrent+9]=this.cb_1
end on

on w_sm01_00015_ex.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_temp)
destroy(this.dw_save)
destroy(this.rb_car)
destroy(this.rb_itnbr)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.cb_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sm01_00015_ex
integer x = 32
integer y = 292
integer width = 4553
integer height = 1992
integer taborder = 130
string dataobject = "d_sm01_00015_ex_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec 	 dQty, dAmt, dPrc, dmmqty, djucha, davg, dsum, dcha, dDayQty
Long   nRow, ix, dWorkMon, dWorkWeek
String sCol, sItnbr, sItdsc, siSpec, sjijil, sispec_code,s_cvcod, snull, get_nm, syymm, sDate, eDate, sFistCol
Int    ireturn, njucha
Long   ll_containqty
String ls_carcode

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

sCol = GetColumnName()
Choose Case GetColumnName()
	
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		Select ITDSC ,
		       CONTAINQTY ,
				 fun_get_carcode(:sitnbr) 
			Into :sitdsc ,
			     :ll_containqty ,
				  :ls_carcode
		  FROM ITEMAS
		 WHERE ITNBR = :sitnbr ;
		If sqlca.sqlcode <> 0 Then
			setitem(nrow, "itnbr", sNull)	
			setitem(nrow, "itdsc", sNull)	
			Return 1
		End If
		
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itdsc", sitdsc)
		Post wf_danga(nrow)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if

	Case 'napgi1'
		sDate = this.GetText()
		if sDate = "" or isnull(sDate) then return 
		
		syymm = Trim(dw_1.GetItemString(1, 'yymm'))
		if syymm <> Left(sDate,6) then
			MessageBox('확인','일자를 확인하세요!!!')
			this.setitem(nrow, 'napgi1', snull)
			this.SetColumn('napgi1')
			Return 1
		end if

	Case 'napgi2'
		sDate = this.GetText()
		if sDate = "" or isnull(sDate) then return 
		
		syymm = Trim(dw_1.GetItemString(1, 'yymm'))
		syymm = f_aftermonth(syymm, 1)
		if syymm <> Left(sDate,6) then
			MessageBox('확인','일자를 확인하세요!!!')
			this.setitem(nrow, 'napgi2', snull)
			this.SetColumn('napgi2')
			Return 1
		end if

	Case 'napgi3'
		sDate = this.GetText()
		if sDate = "" or isnull(sDate) then return 
		
		syymm = Trim(dw_1.GetItemString(1, 'yymm'))
		syymm = f_aftermonth(syymm, 2)
		if syymm <> Left(sDate,6) then
			MessageBox('확인','일자를 확인하세요!!!')
			this.setitem(nrow, 'napgi3', snull)
			this.SetColumn('napgi3')
			Return 1
		end if
		
//		   Case 's1qty'
//            MessageBox('확인','일자를 확인하세요!!!')
//        sDate = this.GetText()

End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow , i , ll_i = 0
String sItnbr, sNull, sname
str_code lst_code
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)


nRow     = GetRow()
If nRow <= 0 Then Return

sname = GetcolumnName() 
Choose Case sname
		
	Case 'cvcod'
		
		gs_gubun = '1'

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(nRow, "cvcod", gs_Code)
		this.TriggerEvent("itemchanged")

	Case "napgi1", "napgi2", "napgi3"
		SetNull(gs_code)
		
		str_pos.x = Int(this.x + xpos)  
		str_pos.y = Int(this.y + ypos)
		
		OpenWithParm(w_ddcal, str_pos)
		IF IsNull(gs_code) THEN Return 
		
		this.SetItem(nRow, sname, gs_code)
		this.SetColumn(sname)

	Case "itnbr"

		gs_gubun = '1'
		Open(w_itemas_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.SetItem(row, "itnbr", gs_code)
		this.TriggerEvent("itemchanged")
//		this.SetItem(row, "itdsc", gs_codename)

//		gs_code = Trim(Object.cvcod[nRow])
//		gs_codename =Trim(Object.cvnas[nRow])
//	
//		If isNull(gs_code) or gs_code = '' Then 
//			Messagebox('확인','거래처를 선택하세요.')
//			Return
//		End iF
//		Open(w_sal_02000_vnddan)
//
//		lst_code = Message.PowerObjectParm
//		IF isValid(lst_code) = False Then Return 
//		If UpperBound(lst_code.code) < 1 Then Return 
//		
//		For i = row To UpperBound(lst_code.code) + row - 1
//			ll_i++
//			if i > row then p_addrow.triggerevent("clicked")
//			this.SetItem(i, "cvcod", gs_Code)
//			this.SetItem(i, "cvnas", gs_Codename)
//			
//			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			this.TriggerEvent("itemchanged")
//			
//		Next
	
END Choose


end event

event dw_insert::ue_pressenter;Dec dqty

/* 품번을 입력하면 수량으로 이동 */
If getcolumnname() = "mmqty"  then
	dQty = Dec(GetText())
	If IsNull(dQty) Or dQty = 0 Then
	Else
		SetColumn('mmqty2')
		Return 1
	End If
End If

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm01_00015_ex
integer x = 3922
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Long i , ll_r , ll_cnt=0
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

If dw_insert.AcceptText() <> 1 Then Return


ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_yymm  = trim(dw_1.getitemstring(1, 'yymm'))
ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))

//ll_cnt = 0 
//select count(*) into :ll_cnt 
//  from sm01_monplan_dt
// where saupj = :ls_saupj
//   and yymm = :ls_yymm
//	and wandate is not null;
//	
//If ll_cnt > 0 Then
//	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.  ')
//	Return
//End if

If f_msg_delete() <> 1 Then	REturn

ll_r = dw_insert.Rowcount()

For i = ll_r To 1 Step -1
	If dw_insert.IsSelected(i) Then
		dw_insert.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
		
		w_mdi_frame.sle_msg.text =String(ll_cnt)+'건의 삭제하였습니다.'
	End iF
End IF


end event

type p_addrow from w_inherite`p_addrow within w_sm01_00015_ex
integer x = 3749
integer taborder = 50
end type

event p_addrow::clicked;Long	 nRow, dMax ,ll_cnt 
String ls_saupj ,ls_yymm ,ls_cvcod

If dw_1.AcceptText() <> 1 Then REturn

ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_yymm  = trim(dw_1.getitemstring(1, 'yymm'))
ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))

//ll_cnt = 0 
//select count(*) into :ll_cnt 
//  from sm01_monplan_dt
// where saupj = :ls_saupj
//   and yymm = :ls_yymm
//	and wandate is not null;
//	
//If ll_cnt > 0 Then
//	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.   ')
//	Return
//End if

/* 사업장 체크 */
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')

	Return -1
End If

If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[기준년월]')
	dw_1.SetFocus()
	dw_1.SetColumn('yymm')
	Return
End If

//If IsNull(ls_cvcod) Or ls_cvcod = '' Then
//	f_message_chk(1400,'[거래처]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('cvcod')
//	Return
//End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'saupj', ls_saupj)
dw_insert.SetItem(nRow, 'yymm', ls_yymm)
dw_insert.SetItem(nRow, 'cvcod', dw_1.GetItemString(1, 'cvcod'))
dw_insert.SetItem(nRow, 'cvnas', dw_1.GetItemString(1, 'cvnas'))
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_sm01_00015_ex
boolean visible = false
integer x = 3086
integer taborder = 110
string picturename = "C:\erpman\image\from_excel.gif"
end type

event p_search::ue_lbuttondown;//
end event

event p_search::ue_lbuttonup;//
end event

type p_ins from w_inherite`p_ins within w_sm01_00015_ex
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm01_00015_ex
integer taborder = 100
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm01_00015_ex
integer taborder = 90
end type

event p_can::clicked;call super::clicked;wf_init()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm01_00015_ex
boolean visible = false
integer x = 3259
integer taborder = 120
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm01_00015_ex
integer x = 3575
end type

event p_inq::clicked;String ls_saupj , ls_yymm , ls_cvcod , ls_carcode ,ls_itnbr


If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[기준년월]')
	Return
End If

ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))
If ls_cvcod = '' Or isNull(ls_cvcod) Then 
	ls_cvcod = '%'
Else
	ls_cvcod = ls_cvcod+'%'
End If

ls_itnbr = trim(dw_1.getitemstring(1, 'itnbr'))
If ls_itnbr = '' Or isNull(ls_itnbr) Then 
	ls_itnbr = '%'
Else
	ls_itnbr = ls_itnbr+'%'
End If

If dw_insert.Retrieve(ls_saupj, ls_yymm, ls_cvcod, ls_itnbr) <= 0 Then
	f_message_chk(50,'')
End If	


/* 월 셋팅 */
dw_insert.object.t_mm.text = String(ls_yymm,'@@@@.@@')+'월'
dw_insert.object.t_mm1.text = String(f_aftermonth(ls_yymm,1),'@@@@.@@')+'월'
dw_insert.object.t_mm2.text = String(f_aftermonth(ls_yymm,2),'@@@@.@@')+'월'


end event

type p_del from w_inherite`p_del within w_sm01_00015_ex
boolean visible = false
integer x = 3881
integer y = 204
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
	Return -1
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

type p_mod from w_inherite`p_mod within w_sm01_00015_ex
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Long ix, nRow
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return
If wf_requiredchk() <= 0 Then Return

dw_insert.AcceptText()
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

type cb_exit from w_inherite`cb_exit within w_sm01_00015_ex
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm01_00015_ex
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm01_00015_ex
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm01_00015_ex
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm01_00015_ex
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm01_00015_ex
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm01_00015_ex
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm01_00015_ex
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm01_00015_ex
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm01_00015_ex
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm01_00015_ex
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm01_00015_ex
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm01_00015_ex
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_00015_ex
boolean visible = true
end type

type dw_temp from datawindow within w_sm01_00015_ex
boolean visible = false
integer x = 2441
integer y = 508
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00015_sumqty"
boolean border = false
boolean livescroll = true
end type

type dw_save from datawindow within w_sm01_00015_ex
boolean visible = false
integer x = 2053
integer y = 1224
integer width = 2510
integer height = 1000
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sm01_00015_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type rb_car from radiobutton within w_sm01_00015_ex
boolean visible = false
integer x = 2231
integer y = 48
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종"
end type

event clicked;wf_init()
end event

type rb_itnbr from radiobutton within w_sm01_00015_ex
boolean visible = false
integer x = 2537
integer y = 48
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번"
boolean checked = true
end type

event clicked;wf_init()
end event

type rr_1 from roundrectangle within w_sm01_00015_ex
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 284
integer width = 4585
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_sm01_00015_ex
integer x = 18
integer y = 16
integer width = 2194
integer height = 252
integer taborder = 20
string dataobject = "d_sm01_00015_ex_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate
Long   nCnt
String sSaupj

SetNull(sNull)

If dw_1.AcceptText() <> 1 Then Return

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

Choose Case GetColumnName()
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
	
	Case 'item'
		sItem = GetText()
		
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'01') <> 1 Then
			f_message_chk(35,'')
			return 1
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

event ue_pressenter;//

Choose Case This.GetColumnName()
	Case 'itnbr'
		p_inq.TriggerEvent(Clicked!)
		Return 1
End Choose

Send(Handle(this),256,9,0)
Return 1
end event

type p_1 from uo_picture within w_sm01_00015_ex
boolean visible = false
integer x = 3255
integer y = 24
integer width = 315
string picturename = "C:\erpman\image\용기량적용_up.gif"
end type

event clicked;call super::clicked;Long i, nRow 
Long ll_conqty ,ll_s1qty , ll_s2qty , ll_s3qty, ll_s4qty, ll_s5qty, ll_s6qty
Long ll_mmqty , ll_mmqty2 , ll_mmqty3, ll_mmqty4, ll_mmqty5
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

/* 품목별 계획일 경우 체크 */

If trim(dw_1.getitemstring(1, 'cust')) <> '1' Then
	MessageBox('확인','해당 월의 마감된 판매계획이 존재합니다. ')
	Return
End If

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

If dw_insert.DataObject = 'd_sm01_00015_b' Then
	
	If dw_insert.Retrieve(ls_saupj, ls_yymm, '%' , '%' , '%') < 1 Then
		MessageBox('확인','소요량 전개된 수량이 존재하지 않습니다.')
		Return
	End IF
	
	If dw_insert.AcceptText() <> 1 Then Return
	If dw_insert.RowCount() <= 0 Then Return
	nRow = dw_insert.RowCount()
	For i = nRow To 1 Step -1
		
		ll_conqty = dw_insert.Object.containqty[i]
		
		If ll_conqty <= 0 Then Continue ; 
		
		ll_s1qty = dw_insert.Object.s1qty[i]
		ll_s2qty = dw_insert.Object.s2qty[i]
		ll_s3qty = dw_insert.Object.s3qty[i]
		ll_s4qty = dw_insert.Object.s4qty[i]
		ll_s5qty = dw_insert.Object.s5qty[i]
		ll_s6qty = dw_insert.Object.s6qty[i]
		
		ll_mmqty2 = dw_insert.Object.mmqty2[i]
		ll_mmqty3 = dw_insert.Object.mmqty3[i]
		ll_mmqty4 = dw_insert.Object.mmqty4[i]
		ll_mmqty5 = dw_insert.Object.mmqty5[i]
		
		//messagebox(string(i) , ll_conqty)
		
		If mod(ll_s1qty,ll_conqty) = 0 Then
			dw_insert.Object.s1qty[i] = ll_s1qty
		Else
			dw_insert.Object.s1qty[i] = Truncate(ll_s1qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s2qty,ll_conqty) = 0 Then
			dw_insert.Object.s2qty[i] = ll_s2qty
		Else
			dw_insert.Object.s2qty[i] = Truncate(ll_s2qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s3qty,ll_conqty) = 0 Then
			dw_insert.Object.s3qty[i] = ll_s3qty
		Else
			dw_insert.Object.s3qty[i] = Truncate(ll_s3qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s4qty,ll_conqty) = 0 Then
			dw_insert.Object.s4qty[i] = ll_s4qty
		Else
			dw_insert.Object.s4qty[i] = Truncate(ll_s4qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s5qty,ll_conqty) = 0 Then
			dw_insert.Object.s5qty[i] = ll_s5qty
		Else
			dw_insert.Object.s5qty[i] = Truncate(ll_s5qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s6qty,ll_conqty) = 0 Then
			dw_insert.Object.s6qty[i] = ll_s6qty
		Else
			dw_insert.Object.s6qty[i] = Truncate(ll_s6qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty2,ll_conqty) = 0 Then
			dw_insert.Object.mmqty2[i] = ll_mmqty2
		Else
			dw_insert.Object.mmqty2[i] = Truncate(ll_mmqty2/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty3,ll_conqty) = 0 Then
			dw_insert.Object.mmqty3[i] = ll_mmqty3
		Else
			dw_insert.Object.mmqty3[i] = Truncate(ll_mmqty3/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty4,ll_conqty) = 0 Then
			dw_insert.Object.mmqty4[i] = ll_mmqty4
		Else
			dw_insert.Object.mmqty4[i] = Truncate(ll_mmqty4/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty5,ll_conqty) = 0 Then
			dw_insert.Object.mmqty5[i] = ll_mmqty5
		Else
			dw_insert.Object.mmqty5[i] = Truncate(ll_mmqty5/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		
	Next
	
	messagebox('확인','용기적입량 적용완료 하였습니다.')

End If



ib_any_typing = false
end event

type p_2 from uo_picture within w_sm01_00015_ex
boolean visible = false
integer x = 3086
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\CKD입력_up.gif"
end type

event clicked;call super::clicked;String sYear, sCust, sCvcod, sToday , ls_saupj ,ls_factory ,ls_itnbr ,ls_itdsc ,ls_itnbr_t,ls_curr ,ls_cvnas
Long   ll_cnt=0 ,ll_containqty , ll_rcnt ,ll_rowcnt ,ll_f
Double ld_price
String ls_m0qty ,ls_m1qty ,ls_m2qty ,ls_m3qty , ls_m4qty

If dw_1.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
sCust = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_cvnas = trim(dw_1.getitemstring(1, 'cvnas'))

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

//If IsNull(sCvcod) Or sCvcod = '' Then
//	f_message_chk(1400,'[거래처]')
//	dw_1.SetFocus()
//	dw_1.SetColumn("cvcod")
//	Return
//End If

gs_code = sYear
w_mdi_frame.sle_msg.text =""

If rb_car.checked Then
	MessageBox('확인','품번 Checked 상태일때만 엑셀 파일 Import 가 가능합니다. ')
	Return
End if

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_car 
 where saupj = :ls_saupj
   and yymm = :sYear ;
	
If ll_cnt < 1 Then
	MessageBox('확인', '해당월의 차종별 판매계획이 존재하지 않습니다 . ')
	Return
End if

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :sYear
	and wandate is not null;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.  ')
	Return
End if


ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :sYear 
	and gubun = '3' ;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 CKD 판매계획이 이미 적용한 상태입니다. '+&
	                   '~n~r~n~r추가 적용할 경우 전체 소요량 계산 후 다시 적용하세요.  ')
	Return
End if


// 엘셀 IMPORT ***************************************************************
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line 
Long   ll_FileNum ,ll_value
String ls_gubun , ls_col ,ls_line_t , ls_data[]
Long   ll_xl_row , ll_r , i 

If dw_1.AcceptText() = -1 Then Return


ll_value = GetFileOpenName("월간계획 CKD 데이타 가져오기", ls_docname, ls_named, & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

If sCvcod = '' or isNull(sCvcod) Then
	select fun_get_reffpf_value('2A','Y','1') , fun_get_cvnas(fun_get_reffpf_value('2A','Y','1')) 
	  into :sCvcod , :ls_cvnas 
	 From dual ;
End If

ll_rcnt = dw_insert.Retrieve(ls_saupj, sYear,sCvcod , '%' , '%')

Setpointer(Hourglass!)

// 주차 가져오기 ==============================================================================
String ls_end_date 
Long   ll_jusu[],ll_jucnt=0 ,ll_su ,ll_m0_qty

select TO_CHAR(LAST_DAY(:sYear||'01'),'yyyymmdd') Into :ls_end_date
  from dual ;
  
ll_su = Long(Right(ls_end_date,2))

select count(*) Into :ll_jucnt
  from pdtweek where week_sdate like :sYear||'%' ;

If ll_jucnt < 1 Then
	MessageBox('확인','년간 주차 데이타가 없습니다. 년간 주차를 생성하세요')
	Return
End If

For i = 1 To ll_jucnt

	select week_edate - week_sdate + 1 Into :ll_jusu[i]
	  from pdtweek 
	 where week_sdate like :sYear||'%'
		and mon_jucha = :i ;
		
Next

//===========================================================================================

//===========================================================================================
//UserObject 생성
uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, false , 3)

uo_xl.uf_selectsheet(1)

If sYear <> Trim(uo_xl.uf_gettext(2,6)) Then
	MessageBox('확인','등록하신 기준년월이 파일의 년월과 일치하지 않습니다. 확인 후 등록하세요')
	uo_xl.uf_excel_Disconnect()
	Return
End If

//Data 시작 Row Setting
ll_xl_row =4
ll_cnt = 0 
ls_factory = 'Y'

Do While(True)
	
	//Data가 없을경우엔 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit

	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i =1 To 20
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
	Next
	
	ll_cnt++
	
	  ls_m0qty =Trim(uo_xl.uf_gettext(ll_xl_row,6))
	  //messagebox(string(len(ls_m0qty)),ls_m0qty)
//     ls_m0qty = Mid(ls_m0qty , 1,len(ls_m0qty)-1)  // 특수문자 있음  ?
  
     If isNull(ls_m0qty) Then ls_m0qty = '0'
  
     ll_m0_qty = Long( Dec(ls_m0qty))
	  
	  ls_m1qty =Trim(uo_xl.uf_gettext(ll_xl_row,7))
	  ls_m2qty =Trim(uo_xl.uf_gettext(ll_xl_row,8))
	  ls_m3qty =Trim(uo_xl.uf_gettext(ll_xl_row,9))
	  ls_m4qty =Trim(uo_xl.uf_gettext(ll_xl_row,10))
	  
//	  ls_m1qty = Mid(ls_m1qty , 1,len(ls_m1qty)-1)  // 특수문자 있음  ?
//	  ls_m2qty = Mid(ls_m2qty , 1,len(ls_m2qty)-1)  // 특수문자 있음  ?
//	  ls_m3qty = Mid(ls_m3qty , 1,len(ls_m3qty)-1)  // 특수문자 있음  ?
//	  ls_m4qty = Mid(ls_m4qty , 1,len(ls_m4qty)-1)  // 특수문자 있음  ?
	  
     If isNull(ls_m1qty) Then ls_m1qty = '0'
	  If isNull(ls_m2qty) Then ls_m2qty = '0'
	  If isNull(ls_m3qty) Then ls_m3qty = '0'
	  If isNull(ls_m4qty) Then ls_m4qty = '0'
	  
	  If Long( Dec(ls_m0qty)) + Long( Dec(ls_m1qty)) +Long( Dec(ls_m2qty)) +Long( Dec(ls_m3qty)) +Long( Dec(ls_m4qty)) <= 0 Then 
			ll_xl_row ++
			Continue 
		End If
		
				  
	  ls_itnbr_t = trim(uo_xl.uf_gettext(ll_xl_row,1))
	  
	  Select MAX(a.itnbr) , MAX(fun_get_itdsc(a.itnbr)) , MAX(a.containqty)
		 Into :ls_itnbr , :ls_itdsc , :ll_containqty
		 From vndmrp a, reffpf b
		where a.cvcod = b.rfna2
		  and b.rfcod = '2A'
		  and b.rfgub IN ('Y', 'L1', 'L2', 'L3', 'C1', 'C2', 'C3', 'C4') /* CKD공장 */
		  and (Replace(a.itnbr,'-','') = Replace(:ls_itnbr_t,' ','') OR
		       Replace(a.itnbr,'-','') = Replace(:ls_itnbr_t,'-','')) ; 
	  
	  If sqlca.sqlcode <> 0 OR Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then 
		  ll_xl_row ++
		  Continue
	  End If
////			MessageBox('확인','거래처 품번정보에 품번이 미등록 항목입니다.')
//			MessageBox('확인','거래처 품번정보에 품번이 미등록 항목입니다.~r~n~n' + ls_itnbr_t)
//			uo_xl.uf_excel_Disconnect()
//			Return
//		End iF
		
	  ll_f = dw_insert.Find("saupj = '"+ls_saupj+"' and cvcod='"+sCvcod+"' and yymm='"+sYear+"' and "+&
	                        "itnbr = '"+ls_itnbr+"' and carcode ='.' and gubun='3' " , 1 ,dw_insert.RowCount() )
	  
	  If ll_f > 0 Then
			
		  dw_insert.Scrolltorow(ll_r)
	
		   If ll_m0_qty = 0 Then
			
			Else
				If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
					dw_insert.object.s1qty[ll_f] = dw_insert.object.s1qty[ll_f]+ ll_m0_qty
					dw_insert.object.s2qty[ll_f] = 0 
					dw_insert.object.s3qty[ll_f] = 0 
					dw_insert.object.s4qty[ll_f] = 0 
					dw_insert.object.s5qty[ll_f] = 0 
					dw_insert.object.s6qty[ll_f] = 0 
				Else
				  dw_insert.object.s1qty[ll_f] =  dw_insert.object.s1qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
				  dw_insert.object.s2qty[ll_f] =  dw_insert.object.s2qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
				  dw_insert.object.s3qty[ll_f] =  dw_insert.object.s3qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
				  dw_insert.object.s4qty[ll_f] =  dw_insert.object.s4qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
				 
				  If ll_jucnt = 5 Then
						dw_insert.object.s5qty[ll_f] = dw_insert.object.s5qty[ll_r] + &
						                                 ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
						dw_insert.object.s6qty[ll_f] = 0
						 
				  Else
						dw_insert.object.s5qty[ll_f] =   dw_insert.object.s5qty[ll_r] +  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
						dw_insert.object.s6qty[ll_f] =   dw_insert.object.s6qty[ll_r] + &
						                                 ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
				  End If
				End If
			End If
	
		  dw_insert.object.mmqty[ll_f] = dw_insert.object.mmqty[ll_f] + ll_m0_qty
		  dw_insert.object.mmqty2[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m1qty))
		  dw_insert.object.mmqty3[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m2qty))
		  dw_insert.object.mmqty4[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m3qty))  
		  dw_insert.object.mmqty5[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m4qty))
		
	  Else
		
		  ll_r = dw_insert.InsertRow(0) 
		 
		  dw_insert.Scrolltorow(ll_r)
		
		  dw_insert.object.saupj[ll_r] =  ls_saupj
		  dw_insert.object.yymm[ll_r] =   sYear 
		  dw_insert.object.cvcod[ll_r] = sCvcod
		  dw_insert.object.cvnas[ll_r] = ls_cvnas
		  dw_insert.object.carcode[ll_r] = '.'
		 
		  dw_insert.object.itnbr[ll_r] =  ls_itnbr
		  dw_insert.object.itdsc[ll_r] =  ls_itdsc
		  dw_insert.object.containqty[ll_r] = ll_containqty
		  dw_insert.object.gubun[ll_r] = '3'
			    
		  ld_price =  sqlca.fun_erp100000012_1(is_today , sCvcod , ls_itnbr,'1')
	
		  dw_insert.object.sprc[ll_r] = ld_price
		  
	
		  If ll_m0_qty = 0 Then
				dw_insert.object.s1qty[ll_r] = 0 
				dw_insert.object.s2qty[ll_r] = 0 
				dw_insert.object.s3qty[ll_r] = 0 
				dw_insert.object.s4qty[ll_r] = 0 
				dw_insert.object.s5qty[ll_r] = 0 
				dw_insert.object.s6qty[ll_r] = 0 
			Else
				If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
					dw_insert.object.s1qty[ll_r] = ll_m0_qty
					dw_insert.object.s2qty[ll_r] = 0 
					dw_insert.object.s3qty[ll_r] = 0 
					dw_insert.object.s4qty[ll_r] = 0 
					dw_insert.object.s5qty[ll_r] = 0 
					dw_insert.object.s6qty[ll_r] = 0 
				Else
				  dw_insert.object.s1qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
				  dw_insert.object.s2qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
				  dw_insert.object.s3qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
				  dw_insert.object.s4qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
				 
				  If ll_jucnt = 5 Then
						dw_insert.object.s5qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
						dw_insert.object.s6qty[ll_r] = 0
						 
				  Else
						dw_insert.object.s5qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
						dw_insert.object.s6qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
				  End If
				End If
			End If
	
		  dw_insert.object.mmqty[ll_r] =    ll_m0_qty
	
		  dw_insert.object.mmqty2[ll_r] =  Long( Dec(ls_m1qty))
		  dw_insert.object.mmqty3[ll_r] =  Long( Dec(ls_m2qty))
		  dw_insert.object.mmqty4[ll_r] =  Long( Dec(ls_m3qty))  
		  dw_insert.object.mmqty5[ll_r] =  Long( Dec(ls_m4qty))
	End IF
	
	ll_xl_row ++
	
Loop
uo_xl.uf_excel_Disconnect()

DESTROY uo_xl

// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
End If

w_mdi_frame.sle_msg.text =String(ll_cnt)+'건의 CKD 월간계획 DATA IMPORT 를 완료하였습니다.'
MessageBox('확인',String(ll_cnt)+'건의  CKD 월간계획 DATA IMPORT 를 완료하였습니다.')


Return
end event

type cb_1 from commandbutton within w_sm01_00015_ex
boolean visible = false
integer x = 3173
integer y = 176
integer width = 457
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "excel import"
end type

