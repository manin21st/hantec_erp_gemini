$PBExportHeader$w_sm90_0050_new.srw
$PBExportComments$주간 판매계획 현황(NEW)
forward
global type w_sm90_0050_new from w_inherite
end type
type rr_1 from roundrectangle within w_sm90_0050_new
end type
type dw_1 from u_key_enter within w_sm90_0050_new
end type
type dw_2 from datawindow within w_sm90_0050_new
end type
end forward

global type w_sm90_0050_new from w_inherite
string title = "주간판매계획 현황"
rr_1 rr_1
dw_1 dw_1
dw_2 dw_2
end type
global w_sm90_0050_new w_sm90_0050_new

type variables
String is_obj
end variables

on w_sm90_0050_new.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
end on

on w_sm90_0050_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.Object.sdate[1] = String(TODAY(), 'yyyymm')
end event

type dw_insert from w_inherite`dw_insert within w_sm90_0050_new
integer x = 41
integer y = 216
integer width = 4549
integer height = 1948
string dataobject = "d_sm90_0050_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::doubleclicked;call super::doubleclicked;If row < 1 Then Return

String  ls_mon
ls_mon = dw_1.GetItemString(1, 'sdate')

dw_2.ReSet()

String  ls_col
ls_col = dwo.name

Long    ll_jqty
String  ls_date
Choose Case LEFT(ls_col, 2)
	Case 'mj', 'cj'
		If MID(ls_col, 3, LEN(ls_col)) = 'qty' Then
			ls_date = ls_mon + '01'
		Else
			ls_date = ls_mon + RIGHT(ls_col, 2)
		End If
		
		ll_jqty = This.GetItemNumber(row, ls_col)
		
		dw_2.InsertRow(0)
		
		dw_2.SetItem(1, 'jg_qty', ll_jqty               )
		dw_2.SetItem(1, 'gbn'   , UPPER(LEFT(ls_col, 1)))
		dw_2.SetItem(1, 'jdate' , ls_date               )
		
		dw_2.X       = This.PointerX()
		dw_2.Y       = This.PointerY() + 200
		dw_2.Visible = True
		
		is_obj = ls_col
End Choose

end event

type p_delrow from w_inherite`p_delrow within w_sm90_0050_new
boolean visible = false
integer y = 168
end type

type p_addrow from w_inherite`p_addrow within w_sm90_0050_new
boolean visible = false
integer y = 168
end type

type p_search from w_inherite`p_search within w_sm90_0050_new
boolean visible = false
integer y = 172
end type

type p_ins from w_inherite`p_ins within w_sm90_0050_new
boolean visible = false
integer y = 168
end type

type p_exit from w_inherite`p_exit within w_sm90_0050_new
end type

type p_can from w_inherite`p_can within w_sm90_0050_new
end type

type p_print from w_inherite`p_print within w_sm90_0050_new
boolean visible = false
integer y = 172
end type

type p_inq from w_inherite`p_inq within w_sm90_0050_new
integer x = 3922
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_saupj
String  ls_mon
String  ls_fac
String  ls_itnbr
String  ls_cust
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('확인', '사업장을 선택 하십시오.')
	Return
End If

ls_mon   = Trim(dw_1.GetItemString(row, 'sdate'))
If IsDate(Left(ls_mon, 4) + '.' + RIGHT(ls_mon, 2) + '.01') = False Then
	MessageBox('확인', '일자 형식이 잘못 되었습니다.')
	Return
End If

ls_fac   = dw_1.GetItemString(row, 'plant' )
If ls_fac = '.' OR Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

ls_itnbr = dw_1.GetItemString(row, 'tx_itnbr_f')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

ls_cust  = 'P655'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_sabu, ls_saupj, ls_cust, ls_mon, ls_fac)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm90_0050_new
boolean visible = false
integer y = 168
end type

type p_mod from w_inherite`p_mod within w_sm90_0050_new
boolean visible = false
integer y = 168
end type

type cb_exit from w_inherite`cb_exit within w_sm90_0050_new
end type

type cb_mod from w_inherite`cb_mod within w_sm90_0050_new
end type

type cb_ins from w_inherite`cb_ins within w_sm90_0050_new
end type

type cb_del from w_inherite`cb_del within w_sm90_0050_new
end type

type cb_inq from w_inherite`cb_inq within w_sm90_0050_new
end type

type cb_print from w_inherite`cb_print within w_sm90_0050_new
end type

type st_1 from w_inherite`st_1 within w_sm90_0050_new
end type

type cb_can from w_inherite`cb_can within w_sm90_0050_new
end type

type cb_search from w_inherite`cb_search within w_sm90_0050_new
end type







type gb_button1 from w_inherite`gb_button1 within w_sm90_0050_new
end type

type gb_button2 from w_inherite`gb_button2 within w_sm90_0050_new
end type

type rr_1 from roundrectangle within w_sm90_0050_new
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 208
integer width = 4567
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_sm90_0050_new
integer x = 32
integer y = 24
integer width = 3410
integer height = 176
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sm90_0050_1_new"
boolean border = false
end type

event itemchanged;String sDate, sNull
String ls_value, ls_itnbr_t, ls_itnbr_f

ls_value = Trim(GetText())
SetNull(sNull)

Choose Case GetColumnName()
	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'tx_itnbr_f', ls_value)
	   end if
	Case "prtgu"
//		ls_value = GetText()
//		if ls_value = '1' then //주간판매계획현황
//			dw_insert.dataobject = 'd_sm90_0050_b'
//		else
//			dw_insert.dataobject = 'd_sm90_0050_a'
//		end if
//		dw_insert.settransobject(sqlca)
End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

//IF this.GetColumnName() = "cvcod" THEN
//	gs_code = this.GetText()
//	IF Gs_code ="" OR IsNull(gs_code) THEN 
//		gs_code =""
//	END IF
//	
////	gs_gubun = '2'
//	Open(w_vndmst_popup)
//	
//	IF isnull(gs_Code)  or  gs_Code = ''	then  
//		this.SetItem(lrow, "cvcod", snull)
//		this.SetItem(lrow, "cvnas", snull)
//   	return
//   ELSE
//		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
//		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
//			f_message_chk(37,'[거래처]') 
//			this.SetItem(lRow, "cvcod", sNull)
//		   this.SetItem(lRow, "cvnas", sNull)
//			RETURN  1
//		END IF
//   END IF	
//
//	this.SetItem(lrow, "cvcod", gs_Code)
//	this.SetItem(lrow, "cvnas", gs_Codename)
//END IF
//
end event

type dw_2 from datawindow within w_sm90_0050_new
boolean visible = false
integer x = 1650
integer y = 444
integer width = 1275
integer height = 592
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "재고수정"
string dataobject = "d_sm90_0050_01_new"
boolean controlmenu = true
boolean border = false
end type

event buttonclicked;This.AcceptText()

If row < 1 Then Return

Choose Case dwo.name
	Case 'b_commit'
		Long li_cha
		li_cha = This.GetItemNumber(row, 'cha2_qty')
		
		Integer li_row
		li_row = dw_insert.GetRow()
		
		String  ls_saupj
		String  ls_fac
		String  ls_itnbr
		String  ls_stkgub
		String  ls_mdate
		Long    li_jg
		Long    li_fix
		
		ls_saupj = dw_1.GetItemString(1, 'saupj')
		
		ls_mdate  = This.GetItemString(row, 'jdate'   ) //적용일자
		ls_stkgub = This.GetItemString(row, 'gbn'     ) //재고구분(M:물류사, C:고객사)
		li_jg     = This.GetItemNumber(row, 'jg_qty'  ) //현 재고수량
		li_fix    = This.GetItemNumber(row, 'fix_qty' ) //갱신수량
		
		ls_fac   = dw_insert.GetItemString(li_row, 'factory')
		ls_itnbr = dw_insert.GetItemString(li_row, 'mitnbr' )
		
		/* 중복확인 */
		String  ls_chk
		Long    ll_g
		Long    ll_j
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END, MAX(NVL(GAPQTY, 0)), MAX(NVL(JQTY, 0))
		  INTO :ls_chk                                       , :ll_g              , :ll_j
		  FROM STOCK_DAILY_FIX
		 WHERE SAUPJ = :ls_saupj AND PLNT = :ls_fac AND STKGUB = :ls_stkgub AND ITNBR = :ls_itnbr AND MDATE = :ls_mdate ;
		
		Long    ll_err
		String  ls_err
		If ls_chk = 'Y' Then
			UPDATE STOCK_DAILY_FIX
			   SET JQTY = :li_fix, GAPQTY = GAPQTY - (JQTY - :li_fix)
			 WHERE SAUPJ = :ls_saupj AND PLNT = :ls_fac AND STKGUB = :ls_stkgub AND ITNBR = :ls_itnbr AND MDATE = :ls_mdate ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('갱신 오류[UPDATE] ' + String(ll_err), ls_err)
				Return
			End If
		
			/* 사용자가 보는 DATAWINDOW에 임시로 표시
				아래 저장 후 재 조회 시 DB에 차이수량으로 표시되어 나타나게 처리 */
			dw_insert.SetItem(li_row, 'f' + LEFT(is_obj, 1) + RIGHT(is_obj, 2), ll_g - (ll_j - li_fix))
		Else
			INSERT INTO STOCK_DAILY_FIX (
			SAUPJ, PLNT, STKGUB, ITNBR, MDATE, JQTY, RQTY, GAPQTY )
			VALUES (
			:ls_saupj, :ls_fac, :ls_stkgub, :ls_itnbr, :ls_mdate, :li_fix, :li_jg, :li_cha ) ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('갱신 오류[INSERT] ' + String(ll_err), ls_err)
				Return
			End If
		
			/* 사용자가 보는 DATAWINDOW에 임시로 표시
				아래 저장 후 재 조회 시 DB에 차이수량으로 표시되어 나타나게 처리 */
			dw_insert.SetItem(li_row, 'f' + LEFT(is_obj, 1) + RIGHT(is_obj, 2), li_cha)
		End If
End Choose

COMMIT USING SQLCA;
MessageBox('재고 갱신', '재고 갱신처리 되었습니다.')

This.Visible = False
end event

event editchanged;If row < 1 Then Return

Long   ll_rqty
ll_rqty = This.GetItemNumber(row, 'jg_qty')
If IsNull(ll_rqty) Then ll_rqty = 0
Choose Case dwo.name
	Case 'fix_qty'
		Long  ll_gap
		ll_gap = Long(data) - ll_rqty 
		This.SetItem(row, 'cha2_qty', ll_gap)
End choose
end event

