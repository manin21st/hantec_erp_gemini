$PBExportHeader$w_sal_02220.srw
$PBExportComments$품목별 수량별 할인율 등록
forward
global type w_sal_02220 from w_inherite
end type
type gb_5 from groupbox within w_sal_02220
end type
type gb_4 from groupbox within w_sal_02220
end type
type gb_2 from groupbox within w_sal_02220
end type
type gb_1 from groupbox within w_sal_02220
end type
type dw_ip from u_key_enter within w_sal_02220
end type
type dw_list from datawindow within w_sal_02220
end type
type rb_1 from radiobutton within w_sal_02220
end type
type rb_2 from radiobutton within w_sal_02220
end type
type rb_itnbr from radiobutton within w_sal_02220
end type
type rb_itcls from radiobutton within w_sal_02220
end type
type pb_1 from u_pb_cal within w_sal_02220
end type
type pb_2 from u_pb_cal within w_sal_02220
end type
type rr_1 from roundrectangle within w_sal_02220
end type
type rr_2 from roundrectangle within w_sal_02220
end type
type rr_3 from roundrectangle within w_sal_02220
end type
end forward

global type w_sal_02220 from w_inherite
string title = "품목별 수량별 할인율 등록"
gb_5 gb_5
gb_4 gb_4
gb_2 gb_2
gb_1 gb_1
dw_ip dw_ip
dw_list dw_list
rb_1 rb_1
rb_2 rb_2
rb_itnbr rb_itnbr
rb_itcls rb_itcls
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_02220 w_sal_02220

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_clear_item (integer nrow)
public function integer wf_chk (long arg_row)
public function integer wf_check_qty (integer row, string itnbr, long qtyf, long qtyt)
public function integer wf_protect (string gb)
end prototypes

public function integer wf_clear_item (integer nrow);String sNull

SetNull(snull)

dw_insert.SetItem(nRow,"itnbr",snull)
dw_insert.SetItem(nRow,"itdsc",snull)
dw_insert.SetItem(nRow,"ispec",snull)

dw_insert.SetItem(nRow,"qtyf",   0)
dw_insert.SetItem(nRow,"qtyt",   0)
dw_insert.SetItem(nRow,"sales_dcrate",   0)
dw_insert.SetItem(nRow,"sales_price",    0)

Return 0
end function

public function integer wf_chk (long arg_row);string ls_ittyp , ls_itcls , ls_itnbr , ls_dcrate , ls_gubun
long   ll_qtyf , ll_qtyt 

if dw_insert.accepttext() <> 1 then return -1

if rb_itcls.checked = true then
	ls_ittyp = Trim(dw_insert.getitemstring(arg_row,'ittyp'))
	ls_itcls = Trim(dw_insert.getitemstring(arg_row,'itcls'))
	
	if ls_ittyp = "" or isnull(ls_ittyp) then 
      f_message_chk(30,'[품목구분]')
		dw_insert.setfocus()
		dw_insert.setrow(arg_row)
		dw_insert.setcolumn('ittyp')
		return -1
	end if
   
	if ls_itcls = "" or isnull(ls_itcls) then 
      f_message_chk(30,'[품목분류]')
		dw_insert.setfocus()
		dw_insert.setrow(arg_row)
		dw_insert.setcolumn('itcls')
		return -1
	end if
elseif rb_itnbr.checked = true then
	ls_itnbr = Trim(dw_insert.getitemstring(arg_row,'itnbr'))
	
	if ls_itnbr = "" or isnull(ls_itnbr) then 
      f_message_chk(30,'[품번]')
		dw_insert.setfocus()
		dw_insert.setrow(arg_row)
		dw_insert.setcolumn('itnbr')
		return -1
	end if
end if

/* 공통 */

ll_qtyf = dw_insert.getitemnumber(arg_row,'qtyf')
ll_qtyt = dw_insert.getitemnumber(arg_row,'qtyt')

if isnull(ll_qtyf) then
	f_message_chk(30,'[수량 FROM]')
	dw_insert.setfocus()
	dw_insert.setrow(arg_row)
	dw_insert.setcolumn('qtyf')
	return -1
end if

if isnull(ll_qtyt) then
	f_message_chk(30,'[수량 TO]')
	dw_insert.setfocus()
	dw_insert.setrow(arg_row)
	dw_insert.setcolumn('qtyt')
	return -1
end if

return 1
end function

public function integer wf_check_qty (integer row, string itnbr, long qtyf, long qtyt);String sIttyp
Long nRow

If qtyf > qtyt Then
	MessageBox('확 인','From 수량이 To수량보다 큽니다')
	Return 1
End If

If qtyf = 0 and qtyt = 0 Then
	MessageBox('확 인','수량을 입력하세요.!!')
	Return 1
End If

If rb_itnbr.Checked = True Then
	nRow = dw_insert.Find(" itnbr = '" + itnbr + &
								 "' and qtyf <= " + string(qtyf) + &
								 "  and qtyt >= " + string(qtyf), 1, dw_insert.RowCount())
	
	If nRow > 0 and nRow <> row Then
		MessageBox('확 인','From 수량이 중복되었습니다')
		Return 1
	End If
	
	nRow = dw_insert.Find(" itnbr = '" + itnbr + &
								 "' and qtyf <= " + string(qtyt) + &
								 "  and qtyt >= " + string(qtyt), 1, dw_insert.RowCount())
	
	dw_insert.SetFocus()
	If nRow > 0 and nRow <> row Then
		MessageBox('확 인','To 수량이 중복되었습니다')
		Return 1
	End If
Else
	sIttyp = dw_insert.GetItemString(row, 'ittyp')
	If IsNull(sIttyp) Or sIttyp = '' Then
		MessageBox('확 인','품목구분을 입력하세요.!!')
		Return 1
	End If

	nRow = dw_insert.Find("ittyp ='" + sIttyp + "' and itcls = '" + itnbr + &
								 "' and qtyf <= " + string(qtyf) + &
								 "  and qtyt >= " + string(qtyf), 1, dw_insert.RowCount())
	
	If nRow > 0 and nRow <> row Then
		MessageBox('확 인','From 수량이 중복되었습니다')
		Return 1
	End If
	
	nRow = dw_insert.Find("ittyp ='" + sIttyp + "' and itcls = '" + itnbr + &
								 "' and qtyf <= " + string(qtyt) + &
								 "  and qtyt >= " + string(qtyt), 1, dw_insert.RowCount())
	
	dw_insert.SetFocus()
	If nRow > 0 and nRow <> row Then
		MessageBox('확 인','To 수량이 중복되었습니다')
		Return 1
	End If
End If

Return 0
end function

public function integer wf_protect (string gb);/* Protect */

Choose Case gb
	Case '1' //등록
		dw_ip.Modify('custcode.protect = 0')
//      dw_ip.Modify("custcode.background.color = '"+String(Rgb(255,255,0))+"'")
		dw_ip.Modify('custname.protect = 0')
//      dw_ip.Modify("custname.background.color = '"+String(Rgb(255,255,255))+"'")
		
		dw_ip.Modify('start_date.protect = 0')
//		dw_ip.Modify("start_date.background.color = '" + string(Rgb(195,225,184)) + "'")
		
		dw_ip.Modify('curr.protect = 0')
//		dw_ip.Modify("curr.background.color = '" + string(Rgb(195,225,184)) + "'")
	Case '2' //수정
		dw_ip.Modify('spcvnd_date.protect = 0')
//		dw_ip.Modify("spcvnd_date.background.color = '" + string(Rgb(195,225,184)) + "'") 
		dw_ip.Modify('spcvnd_no.protect = 0')
//		dw_ip.Modify("spcvnd_no.background.color = '" + string(Rgb(255,255,0)) + "'") 
		dw_ip.Modify('cvcod.protect = 0')
//		dw_ip.Modify("cvcod.background.color '" + string(Rgb(255,255,0)) + "'") 
		dw_ip.Modify('cvnas2.protect = 0')
//		dw_ip.Modify("cvnas2.background.color '" + string(Rgb(255,255,255)) + "'") 
		dw_ip.Modify('cust_no.protect = 0')
//		dw_ip.Modify("cust_no.background.color '" + string(Rgb(255,255,0)) + "'") 
		dw_ip.Modify('cust_name.protect = 0')
//		dw_ip.Modify("cust_name.background.color '" + string(Rgb(255,255,255)) + "'") 
	Case '3' //조회
		dw_ip.Modify('start_date.protect = 1')
//		dw_ip.Modify("start_date.background.color = 80859087") 
		dw_ip.Modify('custcode.protect = 1')
//		dw_ip.Modify("custcode.background.color = 80859087") 
		dw_ip.Modify('custname.protect = 1')
//		dw_ip.Modify("custname.background.color = 80859087") 
		dw_ip.Modify('curr.protect = 1')
//		dw_ip.Modify("curr.background.color = 80859087") 
End Choose

Return 0
end function

on w_sal_02220.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_itnbr=create rb_itnbr
this.rb_itcls=create rb_itcls
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_ip
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_itnbr
this.Control[iCurrent+10]=this.rb_itcls
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_sal_02220.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_itnbr)
destroy(this.rb_itcls)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.SetTransObject(Sqlca)
dw_list.SetTransObject(Sqlca)

dw_ip.SetTransObject(Sqlca)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02220
integer x = 55
integer y = 804
integer width = 4375
integer height = 1488
integer taborder = 10
string dataobject = "d_sal_022205"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String sOrderDate, sNull
String sItnbr, sItdsc, sIspec, sJijil, sIspeccode
Long   nRow, ireturn
Double dItemPrice, dNewDcRate, dQty
String sItemcls, sItemgbn, sItemclsname

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'titnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'titnm',sNull)
	
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(nRow, 'ittyp')
		
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(nRow,"titnm",sItemClsName)
			END IF
		END IF		
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
   	ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
				
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		RETURN ireturn
	/* 재질 */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		RETURN ireturn
	/* 수량 from */
	Case 'qtyf'
		dQty = GetItemNumber(nRow,'qtyt')
		If dQty = 0 Then dQty = 999999

		If rb_itnbr.Checked = True Then
			Return wf_check_qty(nRow, GetItemString(nRow, 'itnbr'), Long(GetText()), dQty)
		Else
			Return wf_check_qty(nRow, GetItemString(nRow, 'itcls'), Long(GetText()), dQty)
		End If
	/* 수량 to */
	Case 'qtyt'
		
		If rb_itnbr.Checked = True Then
			Return wf_check_qty(nRow, GetItemString(nRow, 'itnbr'), GetItemNumber(nRow,'qtyf'), Long(GetText()))
		Else
			Return wf_check_qty(nRow, GetItemString(nRow, 'itcls'), GetItemNumber(nRow,'qtyf'), Long(GetText()))
		End If
END Choose
end event

event dw_insert::rbuttondown;Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(nRow,"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(nRow,"itcls",str_sitnct.s_sumgub)
		SetItem(nRow,"titnm",str_sitnct.s_titnm)
		SetItem(nRow,"ittyp",str_sitnct.s_ittyp)
		
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
	Case "ispec"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose

end event

event dw_insert::itemerror;Return 1
end event

event dw_insert::ue_pressenter;String ls_dcrate
Long   ll_row

ll_row = this.getrow()

if ll_row < 1 then return

Choose Case this.getcolumnname()
	Case 'sales_dcrate'
       ls_dcrate = Trim(this.gettext())
		 
		 if getrow() = rowcount() then
			 cb_ins.postevent(clicked!)
			 return
		End If

//		 if ls_dcrate = "" or isnull(ls_dcrate) then return
//       
//       cb_ins.postevent(clicked!)
//		 this.setfocus()
//		 ll_row = ll_row + 1
//		 this.setrow(ll_row)
//		 if rb_itnbr.checked = true then
//			this.setcolumn('itnbr')
//		elseif rb_itcls.checked = true then
//			this.setcolumn('ittyp')
//		end if
End Choose	 

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::error;call super::error;return
end event

type p_delrow from w_inherite`p_delrow within w_sal_02220
boolean visible = false
integer x = 4375
integer y = 564
end type

type p_addrow from w_inherite`p_addrow within w_sal_02220
boolean visible = false
integer x = 4201
integer y = 564
end type

type p_search from w_inherite`p_search within w_sal_02220
boolean visible = false
integer x = 3506
integer y = 564
end type

type p_ins from w_inherite`p_ins within w_sal_02220
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long nRow ,ll_return
String sCvcod, sCurr, sDatef, sDatet, sItnbr ,ls_gubun

If dw_ip.AcceptText() <> 1 Then Return 

nRow = dw_insert.GetRow()
If nRow <= 0 Then nRow = 0

/* Key Check */
dw_ip.SetFocus()

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(30,'[거래처]')
	dw_ip.SetColumn('custcode')
	Return
End If

sCurr = Trim(dw_ip.GetItemString(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(30,'[통화단위]')
	dw_ip.SetColumn('curr')
	Return
End If

sDatef = Trim(dw_ip.GetItemString(1,'start_date'))
If f_datechk(sDatef) <> 1  Then
	f_message_chk(30,'[적용시작일]')
	dw_ip.SetColumn('start_date')
	Return
End If

sDatet = Trim(dw_ip.GetItemString(1,'end_date'))

/* 마지막 row check */
//If nRow > 0 Then
//	sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		f_message_chk(30,'[품번]')
//		dw_insert.SetColumn('itnbr')
//		Return
//	End If
//	
//	/* 수량 check */
//	If wf_check_qty(nRow, sItnbr, dw_insert.GetItemNumber(nRow,'qtyf'), dw_insert.GetItemNumber(nRow,'qtyt')) <> 0 Then 
//		dw_insert.SetRow(nRow)
//		dw_insert.SetColumn('qtyt')
//		Return
//	End If
//End If

/* 신규 row 추가 */
dw_insert.SetFocus()
/* 필수 입력사항검색 */
if nrow >0 then
	ll_return = wf_chk(nrow)
	
	if ll_return = -1 then 
		return
	end if
end if

nRow = dw_insert.InsertRow(nRow+1)

/* 기초데이타 */
dw_insert.SetItem(nRow, 'sabu',  gs_sabu)
dw_insert.SetItem(nRow, 'cvcod', sCvcod)
dw_insert.SetItem(nRow, 'curr',  sCurr)
dw_insert.SetItem(nRow, 'start_date', sDatef)
dw_insert.SetItem(nRow, 'end_date', sDatet)

/* 조회 */
wf_protect('3')

dw_insert.SetRow(nRow)
dw_insert.ScrollToRow(nRow)

if rb_itcls.checked = true then
	dw_insert.SetColumn('ittyp')
else
	dw_insert.setcolumn('itnbr')
end if
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_sal_02220
end type

type p_can from w_inherite`p_can within w_sal_02220
end type

event p_can::clicked;call super::clicked;dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetRedraw(True)

dw_insert.Reset()

wf_protect('1')

dw_ip.SetFocus()
dw_ip.SetColumn('custcode')

if rb_1.checked=true then
	dw_list.reset()
end if
	
end event

type p_print from w_inherite`p_print within w_sal_02220
boolean visible = false
integer x = 3680
integer y = 564
end type

type p_inq from w_inherite`p_inq within w_sal_02220
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sCvcod , ls_filter

If rb_2.Checked = True Then
	sCvcod = dw_ip.GetItemString(1, 'custcode')
	If IsNull(sCvcod) Or sCvcod = '' Then
		f_message_chk(30,'[거래처]')
		dw_ip.SetColumn('custcode')
		Return
	End If
Elseif rb_2.checked = false then
	sCvcod = '.'
End If

dw_list.setredraw(false)
if rb_1.checked = true then
	ls_filter = "cvcod <> '.' "
end if
if rb_2.checked = true then
	ls_filter = "cvcod = '.' "
end if
dw_list.SetFilter(ls_filter)
dw_list.Filter( )
dw_list.setredraw(true)
	
If dw_list.retrieve(gs_sabu, sCvcod, is_today) <= 0 Then
   f_message_chk(50,'')	
	Return
End If
end event

type p_del from w_inherite`p_del within w_sal_02220
end type

event p_del::clicked;call super::clicked;long nRow , ll_row
String sCvcod

If dw_insert.accepttext() <> 1 Then Return

nRow = dw_insert.getrow()

IF nRow <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
//	wf_chk()
	dw_insert.deleterow(nRow)
	
	if dw_insert.update() = 1 then
		commit ;
		w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!!"
	else 
		rollback;
	end if		
end if

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
dw_list.Retrieve(gs_sabu, sCvcod, is_today)

//dw_ip.reset()
//dw_ip.insertrow(0)
end event

type p_mod from w_inherite`p_mod within w_sal_02220
end type

event p_mod::clicked;call super::clicked;Long nRow , ll_row ,i , ll_return
String sCvcod, sCurr, sDatef, sDatet, sItnbr

If dw_ip.AcceptText() <> 1 Then Return 
IF DW_INSERT.ACCEPTTEXT() <> 1 THEN RETURN

nRow = dw_insert.GetRow()
ll_row = dw_insert.rowcount()
If nRow <= 0 Then nRow = 0

dw_ip.SetFocus()

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(30,'[거래처]')
	dw_ip.SetColumn('custcode')
	Return
End If

sCurr = Trim(dw_ip.GetItemString(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(30,'[통화단위]')
	dw_ip.SetColumn('curr')
	Return
End If

sDatef = Trim(dw_ip.GetItemString(1,'start_date'))
If f_datechk(sDatef) <> 1  Then
	f_message_chk(30,'[적용시작일]')
	dw_ip.SetColumn('start_date')
	Return
End If

sDatet = Trim(dw_ip.GetItemString(1,'end_date'))

/* 마지막 row check */
//If nRow > 0 Then
//	sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		f_message_chk(30,'[품번]')
//		dw_insert.SetColumn('itnbr')
//		Return
//	End If
//	
//	/* 수량 check */
//	If wf_check_qty(nRow, sItnbr, dw_insert.GetItemNumber(nRow,'qtyf'), dw_insert.GetItemNumber(nRow,'qtyt')) <> 0 Then 
//		dw_insert.SetRow(nRow)
//		dw_insert.SetColumn('qtyt')
//		Return
//	End If
//End If
/* 입력사항 체크 */
for i= 1 to ll_row
	ll_return = wf_chk(i)
	
	if ll_return = -1 then
		return 1
	end if
next


/* 저장 */
If dw_insert.update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

dw_list.Retrieve(gs_sabu, sCvcod, is_today)

dw_insert.Sort()
dw_insert.GroupCalc()
dw_ip.reset()
dw_ip.insertrow(0)
if rb_1.checked=true then
	rb_1.triggerevent(clicked!)
else
	rb_2.triggerevent(clicked!)
end if


ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_sal_02220
integer x = 3163
integer y = 1864
integer taborder = 160
end type

type cb_mod from w_inherite`cb_mod within w_sal_02220
boolean visible = false
integer x = 2953
integer y = 20
integer taborder = 100
end type

event cb_mod::clicked;call super::clicked;Long nRow , ll_row ,i , ll_return
String sCvcod, sCurr, sDatef, sDatet, sItnbr

If dw_ip.AcceptText() <> 1 Then Return 
IF DW_INSERT.ACCEPTTEXT() <> 1 THEN RETURN

nRow = dw_insert.GetRow()
ll_row = dw_insert.rowcount()
If nRow <= 0 Then nRow = 0

dw_ip.SetFocus()

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(30,'[거래처]')
	dw_ip.SetColumn('custcode')
	Return
End If

sCurr = Trim(dw_ip.GetItemString(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(30,'[통화단위]')
	dw_ip.SetColumn('curr')
	Return
End If

sDatef = Trim(dw_ip.GetItemString(1,'start_date'))
If f_datechk(sDatef) <> 1  Then
	f_message_chk(30,'[적용시작일]')
	dw_ip.SetColumn('start_date')
	Return
End If

sDatet = Trim(dw_ip.GetItemString(1,'end_date'))

/* 마지막 row check */
//If nRow > 0 Then
//	sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		f_message_chk(30,'[품번]')
//		dw_insert.SetColumn('itnbr')
//		Return
//	End If
//	
//	/* 수량 check */
//	If wf_check_qty(nRow, sItnbr, dw_insert.GetItemNumber(nRow,'qtyf'), dw_insert.GetItemNumber(nRow,'qtyt')) <> 0 Then 
//		dw_insert.SetRow(nRow)
//		dw_insert.SetColumn('qtyt')
//		Return
//	End If
//End If
/* 입력사항 체크 */
for i= 1 to ll_row
	ll_return = wf_chk(i)
	
	if ll_return = -1 then
		return 1
	end if
next


/* 저장 */
If dw_insert.update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

dw_list.Retrieve(gs_sabu, sCvcod, is_today)

dw_insert.Sort()
dw_insert.GroupCalc()
dw_ip.reset()
dw_ip.insertrow(0)
if rb_1.checked=true then
	rb_1.triggerevent(clicked!)
else
	rb_2.triggerevent(clicked!)
end if


ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_02220
boolean visible = false
integer x = 2587
integer y = 8
integer taborder = 80
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Long nRow ,ll_return
String sCvcod, sCurr, sDatef, sDatet, sItnbr ,ls_gubun

If dw_ip.AcceptText() <> 1 Then Return 

nRow = dw_insert.GetRow()
If nRow <= 0 Then nRow = 0

/* Key Check */
dw_ip.SetFocus()

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(30,'[거래처]')
	dw_ip.SetColumn('custcode')
	Return
End If

sCurr = Trim(dw_ip.GetItemString(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(30,'[통화단위]')
	dw_ip.SetColumn('curr')
	Return
End If

sDatef = Trim(dw_ip.GetItemString(1,'start_date'))
If f_datechk(sDatef) <> 1  Then
	f_message_chk(30,'[적용시작일]')
	dw_ip.SetColumn('start_date')
	Return
End If

sDatet = Trim(dw_ip.GetItemString(1,'end_date'))

/* 마지막 row check */
//If nRow > 0 Then
//	sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		f_message_chk(30,'[품번]')
//		dw_insert.SetColumn('itnbr')
//		Return
//	End If
//	
//	/* 수량 check */
//	If wf_check_qty(nRow, sItnbr, dw_insert.GetItemNumber(nRow,'qtyf'), dw_insert.GetItemNumber(nRow,'qtyt')) <> 0 Then 
//		dw_insert.SetRow(nRow)
//		dw_insert.SetColumn('qtyt')
//		Return
//	End If
//End If

/* 신규 row 추가 */
dw_insert.SetFocus()
/* 필수 입력사항검색 */
if nrow >0 then
	ll_return = wf_chk(nrow)
	
	if ll_return = -1 then 
		return
	end if
end if

nRow = dw_insert.InsertRow(nRow+1)

/* 기초데이타 */
dw_insert.SetItem(nRow, 'sabu',  gs_sabu)
dw_insert.SetItem(nRow, 'cvcod', sCvcod)
dw_insert.SetItem(nRow, 'curr',  sCurr)
dw_insert.SetItem(nRow, 'start_date', sDatef)
dw_insert.SetItem(nRow, 'end_date', sDatet)

/* 조회 */
wf_protect('3')

dw_insert.SetRow(nRow)
dw_insert.ScrollToRow(nRow)

if rb_itcls.checked = true then
	dw_insert.SetColumn('ittyp')
else
	dw_insert.setcolumn('itnbr')
end if
dw_insert.SetFocus()
end event

type cb_del from w_inherite`cb_del within w_sal_02220
boolean visible = false
integer x = 2880
integer y = 76
integer taborder = 110
end type

event cb_del::clicked;call super::clicked;long nRow , ll_row
String sCvcod

If dw_insert.accepttext() <> 1 Then Return

nRow = dw_insert.getrow()

IF nRow <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
//	wf_chk()
	dw_insert.deleterow(nRow)
	
	if dw_insert.update() = 1 then
		commit ;
		w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!!"
	else 
		rollback;
	end if		
end if

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
dw_list.Retrieve(gs_sabu, sCvcod, is_today)

//dw_ip.reset()
//dw_ip.insertrow(0)
end event

type cb_inq from w_inherite`cb_inq within w_sal_02220
boolean visible = false
integer x = 2505
integer y = 80
integer taborder = 120
end type

event cb_inq::clicked;call super::clicked;String sCvcod , ls_filter

If rb_2.Checked = True Then
	sCvcod = dw_ip.GetItemString(1, 'custcode')
	If IsNull(sCvcod) Or sCvcod = '' Then
		f_message_chk(30,'[거래처]')
		dw_ip.SetColumn('custcode')
		Return
	End If
Elseif rb_2.checked = false then
	sCvcod = '.'
End If

dw_list.setredraw(false)
if rb_1.checked = true then
	ls_filter = "cvcod <> '.' "
end if
if rb_2.checked = true then
	ls_filter = "cvcod = '.' "
end if
dw_list.SetFilter(ls_filter)
dw_list.Filter( )
dw_list.setredraw(true)
	
If dw_list.retrieve(gs_sabu, sCvcod, is_today) <= 0 Then
   f_message_chk(50,'')	
	Return
End If
end event

type cb_print from w_inherite`cb_print within w_sal_02220
boolean visible = false
integer x = 1947
integer y = 2376
integer taborder = 130
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_02220
end type

type cb_can from w_inherite`cb_can within w_sal_02220
boolean visible = false
integer x = 3241
integer y = 76
integer taborder = 140
end type

event cb_can::clicked;call super::clicked;dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetRedraw(True)

dw_insert.Reset()

wf_protect('1')

dw_ip.SetFocus()
dw_ip.SetColumn('custcode')

if rb_1.checked=true then
	dw_list.reset()
end if
	
end event

type cb_search from w_inherite`cb_search within w_sal_02220
boolean visible = false
integer x = 2395
integer y = 2376
integer taborder = 150
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02220
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02220
end type

type gb_5 from groupbox within w_sal_02220
integer x = 1454
integer y = 36
integer width = 850
integer height = 176
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "적용구분"
end type

type gb_4 from groupbox within w_sal_02220
integer x = 32
integer y = 36
integer width = 1353
integer height = 176
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "할인율 적용범위"
end type

type gb_2 from groupbox within w_sal_02220
integer x = 1541
integer y = 248
integer width = 2391
integer height = 488
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[미완료 자료]"
end type

type gb_1 from groupbox within w_sal_02220
integer x = 59
integer y = 248
integer width = 1358
integer height = 488
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "[처리조건]"
end type

type dw_ip from u_key_enter within w_sal_02220
integer x = 101
integer y = 308
integer width = 1289
integer height = 408
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sal_022201"
boolean border = false
end type

event rbuttondown;String sIoCustName, sIoCustArea, sDept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "custcode","custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(1,"custname",  sIoCustName)
		END IF
		
		dw_list.Retrieve(gs_sabu, GS_CODE, is_today)
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
END Choose
end event

event itemchanged;String sIoCust, sNull, sIoCustName, sIoCustArea, sDept, sOrderDate
String sItemCls, sItemgbn, sItemClsName, sItnbr, sIttyp, sItcls, sItdsc, sIspec
Long   ix

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "custcode"
	 if rb_1.checked=true then
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custname",  sIoCustName)
		END IF
		
		dw_list.Retrieve(gs_sabu, sIoCust, is_today)
	end if
	/* 거래처명 */
	Case "custname"
	  if rb_1.checked=true then
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			Return
		END IF
		
		dw_list.Retrieve(gs_sabu, sIoCust, is_today)
	end if
	/* 품목구분 */
	Case "ittyp"
		SetItem(1,'itcls',sNull)
		SetItem(1,'itclsnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(1,'itclsnm',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
	
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 this.TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 this.SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 적용시작일 */
	Case "start_date"
		sOrderDate = Trim(this.GetText())
		IF sOrderDate = "" OR IsNull(sOrderDate) THEN Return
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[적용시작일]')
			this.SetItem(1,"start_date",snull)
			Return 1
		END IF
	/* 적용마감일 */
	Case "end_date"
		sOrderDate = Trim(this.GetText())
	
		IF f_datechk(sOrderDate) = -1 THEN SetNull(sOrderDate)

		/* 마감일자 입력 */
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix, 'end_date', sOrderDate)
		Next
End Choose
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_list from datawindow within w_sal_02220
integer x = 1563
integer y = 300
integer width = 2331
integer height = 408
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_sal_022204"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String sCvcod, sDatef, sDatet, sCurr
If row <= 0 Then Return

SelectRow(0,False)
SelectRow(row,True)

sCvcod = GetItemString(row, 'cvcod')
sCurr  = GetItemString(row, 'curr')
sDatef = GetItemString(row, 'start_date')
sDatet = GetItemString(row, 'end_date')

dw_ip.SetItem(1, 'custcode', sCvcod)
dw_ip.SetItem(1, 'custname', GetItemString(row, 'cvnas2'))
dw_ip.SetItem(1, 'curr', sCurr)
dw_ip.SetItem(1, 'start_date', sDatef)
dw_ip.SetItem(1, 'end_date', sDatet)

dw_insert.Retrieve(gs_sabu, sCvcod, sCurr, sDatef)

/* 조회 */
wf_protect('3')

end event

type rb_1 from radiobutton within w_sal_02220
integer x = 96
integer y = 104
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "특정거래처"
boolean checked = true
end type

event clicked;dw_ip.setredraw(false)
dw_ip.dataobject="d_sal_022201"
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.setredraw(true)

dw_ip.setfocus()
dw_ip.setcolumn("custcode")
dw_list.reset()
dw_insert.reset()

end event

type rb_2 from radiobutton within w_sal_02220
integer x = 539
integer y = 100
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체거래처"
end type

event clicked;dw_ip.setredraw(false)
dw_ip.dataobject="d_sal_022201_01"
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.accepttext()
dw_ip.setredraw(true)

dw_ip.setitem(1,"custcode", '.' )
dw_ip.setitem(1,"custname",'전체')
dw_ip.setfocus()
dw_ip.setcolumn("start_date")
dw_list.reset()
dw_insert.reset()

dw_list.retrieve(gs_sabu,'.',is_today)
end event

type rb_itnbr from radiobutton within w_sal_02220
integer x = 1522
integer y = 104
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번"
end type

event clicked;dw_list.SetRedraw(false)
dw_insert.SetRedraw(false)
dw_list.DataObject   = 'd_sal_022203'
dw_insert.DataObject = 'd_sal_022202'

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

if rb_2.checked = true then
	dw_list.retrieve(gs_sabu,'.',is_today)
end if

p_can.triggerevent(clicked!)

dw_list.SetRedraw(true)
dw_insert.SetRedraw(true)


end event

type rb_itcls from radiobutton within w_sal_02220
integer x = 1829
integer y = 104
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목분류"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(false)
dw_insert.SetRedraw(false)
dw_list.DataObject   = 'd_sal_022204'
dw_insert.DataObject = 'd_sal_022205'

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

if rb_2.checked = true then
	dw_list.retrieve(gs_sabu,'.',is_today)
end if

p_can.triggerevent(clicked!)

dw_list.SetRedraw(true)
dw_insert.SetRedraw(true)


end event

type pb_1 from u_pb_cal within w_sal_02220
integer x = 795
integer y = 412
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'start_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02220
integer x = 795
integer y = 504
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('end_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'end_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 232
integer width = 1422
integer height = 528
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1499
integer y = 232
integer width = 2459
integer height = 528
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 788
integer width = 4585
integer height = 1532
integer cornerheight = 40
integer cornerwidth = 55
end type

