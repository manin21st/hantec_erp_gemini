$PBExportHeader$w_pdt_00140.srw
$PBExportComments$ ===> 주간 외주계획 조정
forward
global type w_pdt_00140 from w_inherite
end type
type gb_3 from groupbox within w_pdt_00140
end type
type cb_add from commandbutton within w_pdt_00140
end type
type p_create from uo_picture within w_pdt_00140
end type
type rb_1 from radiobutton within w_pdt_00140
end type
type rb_2 from radiobutton within w_pdt_00140
end type
type gb_2 from groupbox within w_pdt_00140
end type
type gb_1 from groupbox within w_pdt_00140
end type
type rr_2 from roundrectangle within w_pdt_00140
end type
type dw_jogun from u_key_enter within w_pdt_00140
end type
type dw_search from datawindow within w_pdt_00140
end type
type p_6 from picture within w_pdt_00140
end type
type pb_1 from u_pb_cal within w_pdt_00140
end type
end forward

global type w_pdt_00140 from w_inherite
integer width = 4677
integer height = 2476
string title = "주간 외주 계획 조정"
gb_3 gb_3
cb_add cb_add
p_create p_create
rb_1 rb_1
rb_2 rb_2
gb_2 gb_2
gb_1 gb_1
rr_2 rr_2
dw_jogun dw_jogun
dw_search dw_search
p_6 p_6
pb_1 pb_1
end type
global w_pdt_00140 w_pdt_00140

type variables
string is_ymd, is_cvcod, is_itgu
        
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
public subroutine wf_clear_item (integer icurrow)
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String spl_yymm, sNull, sToday, sItdsc, sIspec, sJijil, scvcod, stuncu, scvnas, smatch
Decimal {2} dunprc
Long   cnt, frow

SetNull(sNull)

dw_insert.accepttext()

spl_yymm = dw_insert.GetItemString(lrow, "prod_ymd")
sCvcod   = dw_insert.GetItemString(lrow, "cvcod")

/* 추가 품번이 존재하는지 여부 체크 */
Select count(*) Into :cnt From weekouplan
 Where sabu  = :gs_sabu and prod_ymd = :is_ymd 
   and cvcod = :scvcod  and itnbr   = :sitnbr;
	
if cnt > 0 then
  	MessageBox("자료 확인", "해당 품목의 주간계획이 이미 존재합니다.")
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
	dw_insert.SetItem(lrow, "itemas_ispec", sNull)
	dw_insert.SetItem(lrow, "itemas_jijil", sNull)
  	return 1			
end if 

sMatch = scvcod + sitnbr

frow = dw_insert.find("match_case = '"+ smatch +"'", 0, dw_insert.rowcount())
if frow > 0 and frow <> lrow then
  	MessageBox("자료 확인", "해당 품목의 주간계획이 이미 존재합니다." + '~n' + &
	  								"Row-No -> " + String(Frow))
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
	dw_insert.SetItem(lrow, "itemas_ispec", sNull)
	dw_insert.SetItem(lrow, "itemas_jijil", sNull)
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
//*****************************************************************************
dw_insert.SetItem(lrow, "itnbr", sNull)
dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
dw_insert.SetItem(lrow, "itemas_ispec", sNull)
dw_insert.SetItem(lrow, "itemas_jijil", sNull)
	
if sitnbr = '' Or IsNull(sitnbr) Then Return 1	
	
dw_insert.SetItem(lrow, "itnbr", sitnbr)
dw_insert.SetItem(lrow, "itemas_itdsc", sitdsc)		  
dw_insert.SetItem(lrow, "itemas_ispec", sispec)
dw_insert.SetItem(lrow, "itemas_jijil", sJijil)

Return 0
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"wonprc",   		   0)


end subroutine

on w_pdt_00140.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.cb_add=create cb_add
this.p_create=create p_create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rr_2=create rr_2
this.dw_jogun=create dw_jogun
this.dw_search=create dw_search
this.p_6=create p_6
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.p_create
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.dw_jogun
this.Control[iCurrent+10]=this.dw_search
this.Control[iCurrent+11]=this.p_6
this.Control[iCurrent+12]=this.pb_1
end on

on w_pdt_00140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.cb_add)
destroy(this.p_create)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rr_2)
destroy(this.dw_jogun)
destroy(this.dw_search)
destroy(this.p_6)
destroy(this.pb_1)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_search.Settransobject(sqlca)
dw_Jogun.SetTransObject(sqlca)
dw_Jogun.Insertrow(0)
dw_search.Insertrow(0)

// 외주담당자
f_child_saupj(dw_jogun, 'empno', gs_saupj)
//생산팀
f_child_saupj(dw_jogun, 'steam', gs_saupj)
f_mod_saupj(dw_jogun, 'saupj')

is_itgu = '%'

p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'

w_mdi_frame.sle_msg.Text = '조정할 계획년도 및 차수 관할구역을 입력 및 선택하세요'

dw_jogun.SetItem(1,'symd',f_today())

dw_Jogun.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_00140
integer x = 64
integer y = 464
integer width = 4535
integer height = 1832
integer taborder = 10
string dataobject = "d_pdt_00140_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;String sCol_Name
Long   lrow

sCol_Name = GetColumnName()
lrow = GetRow()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
	// 품목코드 에디트에 Right 버턴클릭시 Popup 화면
	Case "itnbr", "itemas_itdsc", "itemas_ispec", "itemas_jijil"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"itnbr",gs_code)
		
		triggerevent(Itemchanged!)
		Return 1
	Case "cvcod"
   	Open(w_vndmst_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"cvcod",gs_code)
		
		triggerevent(Itemchanged!)
		Return 1		
End Choose

end event

event dw_insert::itemchanged;call super::itemchanged;String sNull, sitnbr, stoday, sitdsc, sispec, spl_yymm, sJijil, sispeccode, scvcod, semp_id, scvnas, scvgu
Long lRow, lQty, cnt, lPqty, i
Dec  dDan, ddanga, dIncrRate, lAmt

lRow = GetRow()
If lRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()

	/* 품번 */
	Case "itnbr"
      sitnbr = Trim(GetText())
      If IsNull(sitnbr) Or sitnbr = '' Then			Return 1
		
		wf_check_itnbr(lrow, sItnbr)
		Return 1
		
//		FOR i = 1 to this.rowCount()
//      	if sitnbr = this.GetItemString(i, "itnbr") then
//				MessageBox("확인", "품명이 중복되었습니다.")
//				return 1
//			End If
//		NEXT
		
	Case  "itemas_itdsc"                   // 품명입력시
		sitdsc = Trim(GetText())

		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		

		wf_check_itnbr(lrow, sItnbr)
   Case  "itemas_ispec"                   // 규격입력시
	   sispec = Trim(GetText())

		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)		
   Case  "itemas_jijil"                   // 규격입력시
	   sJijil = Trim(GetText())
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)
   Case  "cvcod" 
		scvcod = gettext()
//		Select cvgu, cvnas2, outorder_emp into :scvgu, :scvnas, :semp_id
//		  From vndmst
//		 Where cvcod = :scvcod;
		 
 		Select cvgu, cvnas2, rfna1
		into :scvgu, :scvnas, :semp_id
		From vndmst, reffpf
		Where cvcod = :scvcod
		and outorder_emp = reffpf.rfgub (+)
		and reffpf.rfcod(+) = '43';
		 
		If sqlca.sqlcode <> 0  or (scvgu <> '1' and scvgu <> '2' and scvgu <> '9') then
			Setitem(Lrow, "cvcod",  sNull)
			Setitem(Lrow, "cvnas2", sNull)
			Setitem(Lrow, "emname", sNull)
			MessageBox("거래처", "거래처코드가 부정확합니다", stopsign!)
			return 1
		End if
		Setitem(Lrow, "cvnas2", scvnas)
		Setitem(Lrow, "emname", semp_id)
		
		sitnbr = getitemstring(Lrow, "itnbr")
		if not isnull( sitnbr ) or trim( sitnbr ) = '' then
			wf_check_itnbr(lrow, sItnbr)
		End if
End Choose 
end event

type p_delrow from w_inherite`p_delrow within w_pdt_00140
boolean visible = false
integer x = 4151
integer y = 3196
end type

type p_addrow from w_inherite`p_addrow within w_pdt_00140
boolean visible = false
integer x = 3977
integer y = 3196
end type

type p_search from w_inherite`p_search within w_pdt_00140
boolean visible = false
integer x = 3282
integer y = 3196
end type

type p_ins from w_inherite`p_ins within w_pdt_00140
integer x = 3749
end type

event p_ins::clicked;call super::clicked;long lrow

If (is_ymd = '') or isNull(is_ymd) Then
  	f_Message_Chk(30, '[일자 확인]')
   dw_jogun.SetFocus()
	Return 1
End If


Lrow = dw_insert.insertrow(0)
dw_insert.setitem(Lrow, "sabu", gs_sabu)
dw_insert.setitem(Lrow, "prod_ymd", is_ymd)
dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("cvcod")
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_pdt_00140
end type

type p_can from w_inherite`p_can within w_pdt_00140
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

 
p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
p_create.enabled = true
p_create.PictureName = 'C:\erpman\image\정기발주의뢰_up.gif'

ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''


dw_Jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_pdt_00140
boolean visible = false
integer x = 3456
integer y = 3196
end type

type p_inq from w_inherite`p_inq within w_pdt_00140
integer x = 3575
end type

event p_inq::clicked;String  sYmd, scvcod, sitnbr1, sitnbr2, sempno, ssaupj, Sprtgu
Long Lrow, LCNT

SetPointer(hourGlass!)

w_mdi_frame.sle_msg.Text = '주간 외주 계획을 조회중 입니다... 잠시 기다려 주세요'
If dw_Jogun.AcceptText() <> 1 Then Return

ssaupj  = dw_Jogun.GetItemString(1, 'saupj')
sYmd    = dw_Jogun.GetItemString(1, 'symd')
scvcod  = dw_Jogun.GetItemString(1, 'cvcod')
sempno  = dw_Jogun.GetItemString(1, 'empno')
sitnbr1 = dw_Jogun.GetItemString(1, 'itnbr1')
sitnbr2 = dw_Jogun.GetItemString(1, 'itnbr2')
Sprtgu  = dw_Jogun.GetItemString(1, 'steam') 

is_ymd 	= symd
is_cvcod	= scvcod

If isnull( symd ) or trim( symd ) = '' then
	MessageBox("기준일자", "기준일자를 먼저 입력하세요", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If isnull( scvcod ) or trim( scvcod ) = '' then
	scvcod = '%'
End if

If isnull( sitnbr1 ) or trim( sitnbr1 ) = '' then
	sitnbr1 = '.'
End if

If isnull( sitnbr2 ) or trim( sitnbr2 ) = '' then
	sitnbr2 = 'zzzzzzzzzzzz'
End if

If isnull( sempno )  or trim( sempno ) = '' then
	sempno  = '%'
End if

If isnull( Sprtgu ) or trim( Sprtgu ) = '' then
	Sprtgu = '%'
End if

Lrow = 0
Select count(*) into :Lrow
  From weekouplan
 Where sabu = :gs_sabu And prod_ymd = :symd;
If Lrow = 0 then
	Messagebox("외주계획", "외주계획이 없으므로 자동생성합니다", stopsign!)
	Insert into weekouplan
		Select sabu, prod_ymd, fun_danmst_danga4(itnbr, '.','9999'), itnbr,
				 prod_qty_d201,prod_qty_d202,prod_qty_d203,prod_qty_d204,prod_qty_d205,prod_qty_d206,prod_qty_d207,
				 prod_qty_d208,prod_qty_d209,prod_qty_d210,prod_qty_d211,prod_qty_d212,prod_qty_d213,prod_qty_d214
		  From weekprplan
 	Where sabu = :gs_sabu And prod_ymd = :symd;
	If sqlca.sqlcode <> 0 then
		rollback;
		Messagebox("자료생성", "생산계획을 기준으로 외주계획생성이 실패", information!)
		return
	End if
	
	LCNT = sqlca.van_weekplan4(gs_sabu, symd, gs_saupj, '%', '2');	
	
 	Commit;
End if

If dw_Insert.Retrieve(gs_sabu, sYmd, scvcod, sitnbr1, sitnbr2, sempno, ssaupj, is_itgu, Sprtgu ) < 1 then
	f_message_Chk(50, '[주간 외주 계획 조회]')
	w_mdi_frame.sle_msg.text = ''
End if

p_ins.enabled = True
p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.enabled = True
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
p_mod.enabled = True
p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
p_create.enabled = false
p_create.PictureName = 'C:\erpman\image\정기발주의뢰_up.gif'

w_mdi_frame.sle_msg.Text = '주간 외주 계획 조회 완료. 조정 및 추가, 삭제를 할 수 있습니다.'

dw_Insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_pdt_00140
end type

event p_del::clicked;call super::clicked;string sitnbr, sitdsc

If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.GetRow() <= 0 Then Return

sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itemas_itdsc')

if MessageBox("삭제 확인", sitdsc + "를 삭제하시겠습니까? ",question!,yesno!, 2) = 2 THEN Return

dw_insert.deleterow(dw_insert.getrow())


end event

type p_mod from w_inherite`p_mod within w_pdt_00140
end type

event p_mod::clicked;call super::clicked;long lcnt

SetPointer(HourGlass!)
If dw_insert.AcceptText() <> 1 Then Return 1

if dw_insert.Update() = -1 then  
   f_message_Chk(32,'[주간외주계획 조정작업]')
 	Rollback;
   SetPointer(Arrow!)	 
   return
else
	
	LCNT = sqlca.van_weekplan4(gs_sabu, is_ymd, gs_saupj, '%', '2');	
	
   Commit;		
   f_message_Chk(202,'[주간외주계획 조정작업]')
	ib_any_typing = False
end if
SetPointer(Arrow!)	 

p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_00140
integer x = 3369
integer y = 3132
integer width = 352
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_pdt_00140
integer x = 2583
integer y = 3132
integer width = 370
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//SetPointer(HourGlass!)
//If dw_update.AcceptText() <> 1 Then Return 1
//
//if dw_update.Update() = -1 then  
//   f_message_Chk(32,'[년간판매계획 조정작업]')
// 	Rollback;
//   SetPointer(Arrow!)	 
//   return
//else
//   Commit;		
//   f_message_Chk(202,'[년간판매계획 조정작업]')
//	ib_any_typing = False
//end if
//SetPointer(Arrow!)	 
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdt_00140
integer x = 2459
integer y = 2820
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_pdt_00140
integer x = 1015
integer y = 3132
integer width = 393
integer taborder = 80
end type

event cb_del::clicked;call super::clicked;//string sitnbr, sitdsc
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//If dw_insert.GetRow() <= 0 Then Return
//
//sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
//sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itdsc')
//
//if MessageBox("삭제 확인", sitdsc + "를 삭제하시겠습니까? ",question!,yesno!, 2) = 2 THEN Return
//
///* 년간판매계획 해당년도의 거래처의 품번 데이타 삭제 */
//Delete From yearsaplan
//Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4) = :is_Year) and
//      (plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and
//		(itnbr = :sitnbr);
//
//if SQLCA.SqlCode < 0 then
//   f_Message_Chk(31, '[년간판매계획 거래처,품번 삭제]')
//	Rollback;
//	return
//else
//   commit;
//	ib_any_typing = False
//end if
//
//cb_inq.TriggerEvent(Clicked!)
//
//
end event

type cb_inq from w_inherite`cb_inq within w_pdt_00140
integer x = 183
integer y = 3132
integer width = 393
integer taborder = 90
end type

event cb_inq::clicked;call super::clicked;//String  sYear, sjYear
//Integer iChasu
//
//SetPointer(hourGlass!)
//
//sle_msg.Text = '해당 년간 판매 계획을 조회중 입니다... 잠시 기다려 주세요'
//If dw_Jogun.AcceptText() <> 1 Then Return
//
//sYear  = dw_Jogun.GetItemString(1, 'syy')
//sjYear = String(integer(sYear) - 1)
//iChasu = dw_Jogun.GetItemNumber(1, 'sChasu')
//
//cb_add.enabled = True
//cb_del.enabled = True
//
//dw_update.Reset()
//If dw_Insert.Retrieve(gs_sabu, sYear, iChasu, is_cvcod, f_today(), sjYear) < 1 then
//	f_message_Chk(50, '[년간 판매 계획 조회]')
//	sle_msg.text = ''
//	return -1
//End if
//
//dw_update.Retrieve(gs_sabu, sYear, iChasu, is_cvcod)
//
//sle_msg.Text = '년간 판매 계획 조회 완료. 조정 및 추가, 삭제를 할 수 있습니다.'
//
//dw_Insert.SetFocus()
//
end event

type cb_print from w_inherite`cb_print within w_pdt_00140
integer x = 2473
integer y = 2692
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_pdt_00140
end type

type cb_can from w_inherite`cb_can within w_pdt_00140
integer x = 2981
integer y = 3132
integer width = 361
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
//dw_update.Reset()
//
//cb_add.enabled = False
//cb_del.enabled = False
//ib_any_typing = False
//
//sle_msg.Text = '조정할 계획년도 및 차수 관할구역을 입력 및 선택하세요'
//
//dw_Jogun.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_pdt_00140
integer x = 2414
integer y = 2556
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_00140
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_00140
end type

type gb_3 from groupbox within w_pdt_00140
boolean visible = false
integer x = 2551
integer y = 3084
integer width = 1202
integer height = 176
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_add from commandbutton within w_pdt_00140
boolean visible = false
integer x = 599
integer y = 3132
integer width = 393
integer height = 108
integer taborder = 160
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event cb_add::clicked;call super::clicked;//str_yearsaplan str_plan
//Double dRtn
//
//If (is_year = '') or isNull(is_year) or (is_chasu = 0) or isNull(is_chasu) or &
//   (is_cvcod = '') or isNull(is_cvcod) then
//	If (is_cvcod = '') or isNull(is_cvcod) then
//		f_Message_Chk(203, '[거래처 입력 확인]')
//		dw_vnd.SetFocus()
//	Else
//   	f_Message_Chk(30, '[필수입력자료 확인]')
//	   dw_jogun.SetFocus()
//	End If
//	Return 1
//End If
//
//sle_msg.Text = '년간 판매 계획 품목추가 작업을 하세요'
//
//str_plan.str_year = is_year
//str_plan.str_chasu = is_chasu
//str_plan.str_cvcod = is_cvcod
//str_plan.str_cvnas2 = is_cvnas2
//str_plan.str_series = is_series
//
//openwithparm(w_sal_01040_01, str_plan)
//dRtn = Message.DoubleParm 
//If dRtn = -1 Then Return
//
//If dw_update.Update() = -1 Then
// 	Rollback;
//   Return
//Else
//   Commit;
//	ib_any_typing = False
//End if
//
//sle_msg.Text = ''
//cb_inq.TriggerEvent(Clicked!)
//dw_insert.scrolltorow(dw_insert.rowcount())
end event

type p_create from uo_picture within w_pdt_00140
integer x = 3269
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\정기발주의뢰_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\정기발주의뢰_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\정기발주의뢰_up.gif"
end event

event clicked;call super::clicked;gs_code = dw_jogun.getitemstring(1, "symd")

If isnull( gs_code ) or trim( gs_code ) = '' then
	MessageBox("기준일자", "기준일자를 입력하세요", stopsign!)
	Setnull(gs_code)
	return 
end if

open(w_pdt_01016)
 


end event

type rb_1 from radiobutton within w_pdt_00140
integer x = 2587
integer y = 144
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "외주"
end type

event clicked;is_itgu = '6'

dw_insert.Reset()
dw_insert.InsertRow(0)

dw_insert.DataObject = 'd_pdt_00140_03'
dw_Insert.Settransobject(sqlca)
end event

type rb_2 from radiobutton within w_pdt_00140
integer x = 2587
integer y = 60
integer width = 261
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체"
boolean checked = true
end type

event clicked;is_itgu = '%'

dw_insert.Reset()
dw_insert.InsertRow(0)

dw_insert.DataObject = 'd_pdt_00140_02'
dw_Insert.Settransobject(sqlca)

end event

type gb_2 from groupbox within w_pdt_00140
boolean visible = false
integer x = 155
integer y = 3084
integer width = 1294
integer height = 176
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_pdt_00140
integer x = 2519
integer y = 20
integer width = 379
integer height = 200
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
end type

type rr_2 from roundrectangle within w_pdt_00140
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 452
integer width = 4585
integer height = 1872
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_jogun from u_key_enter within w_pdt_00140
event ue_key pbm_dwnkey
integer x = 59
integer y = 4
integer width = 2935
integer height = 280
integer taborder = 20
string dataobject = "d_pdt_00140_01"
boolean border = false
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(Rbuttondown!)
End if
end event

event itemchanged;String sCol_Name, sNull, mm_chk, sData, sName, sName1
integer ii

dw_Jogun.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)
//cb_inq.Enabled = False
p_ins.Enabled = False
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
dw_insert.Reset()

String  s_cod, s_nam1, s_nam2
Integer i_rtn
Long ll

s_cod = Trim(this.GetText())

if this.GetColumnName() = "symd" then //기준일자
   if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[기준일자]")
	   this.object.symd[1] = ""
	   return 1
   end if
  
elseif this.getcolumnname() = 'cvcod' then 
	s_cod = this.gettext()
	
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod[1] = s_cod
	this.object.cvname[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr1' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1]  = s_cod
//	this.object.itdsc1[1]  = s_nam1
	return i_rtn 
elseif this.getcolumnname() = 'itnbr2' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1]  = s_cod
//	this.object.itdsc2[1]  = s_nam1
	return i_rtn 
elseif this.getcolumnname() = 'saupj' then 
	s_cod = this.gettext()
	f_child_saupj(dw_jogun, 'empno', s_cod)
	f_child_saupj(dw_jogun, 'steam', s_cod)
end if

return

end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
if this.getcolumnname() = "itnbr1" then //품번1
   gs_gubun ='1'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr1[1] = gs_code
elseif this.getcolumnname() = "itnbr2" then //품번2
   gs_gubun ='1'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr2[1] = gs_code
elseif this.getcolumnname() = "cvcod"	then
   gs_gubun ='1'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvname", gs_codename)
end if	
end event

type dw_search from datawindow within w_pdt_00140
integer x = 55
integer y = 268
integer width = 1477
integer height = 176
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mas_p_010_search"
boolean border = false
end type

type p_6 from picture within w_pdt_00140
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1541
integer y = 272
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\검색_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\검색_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\검색_up.gif'
end event

event clicked;long lReturnRow, i
string sitdsc, sgub

if dw_search.accepttext() = -1 then return 

if dw_insert.rowcount() < 1 then return 

sitdsc = trim(dw_search.getitemstring(1, 'itdsc'))

if sitdsc = '' or isnull(sitdsc) then 
	dw_insert.selectrow(1, true)
	dw_insert.scrolltorow(1)
else
	sitdsc = sitdsc + '%'
	
	sgub = dw_search.getitemstring(1, 'gub')
	if sgub = '1' then 
		lReturnRow = dw_insert.Find("itnbr like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	elseif sgub = '2' then 
		lReturnRow = dw_insert.Find("itemas_itdsc like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	elseif sgub = '3' then 
		lReturnRow = dw_insert.Find("itemas_ispec like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	else
		lReturnRow = dw_insert.Find("itemas_jijil like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	end if

	if isnull(lreturnrow) or lreturnrow < 1 then return 
	
	For i = 1 To dw_insert.RowCount()
		dw_insert.selectrow(i, False)
	Next
	
	dw_insert.selectrow(lReturnRow, true)
	dw_insert.scrolltorow(lReturnRow)
end if

end event

type pb_1 from u_pb_cal within w_pdt_00140
integer x = 782
integer y = 88
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('symd')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'symd', gs_code)
end event

