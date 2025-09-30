$PBExportHeader$w_sal_01070.srw
$PBExportComments$ ===> 주간 판매계획 조정
forward
global type w_sal_01070 from w_inherite
end type
type st_4 from statictext within w_sal_01070
end type
type dw_jogun from u_key_enter within w_sal_01070
end type
type gb_3 from groupbox within w_sal_01070
end type
type cb_add from commandbutton within w_sal_01070
end type
type p_create from uo_picture within w_sal_01070
end type
type rb_1 from radiobutton within w_sal_01070
end type
type rb_2 from radiobutton within w_sal_01070
end type
type p_1 from uo_picture within w_sal_01070
end type
type cbx_1 from checkbox within w_sal_01070
end type
type pb_1 from u_pb_cal within w_sal_01070
end type
type gb_2 from groupbox within w_sal_01070
end type
type rr_2 from roundrectangle within w_sal_01070
end type
end forward

global type w_sal_01070 from w_inherite
integer width = 4704
integer height = 2480
string title = "주간 판매 계획 조정"
st_4 st_4
dw_jogun dw_jogun
gb_3 gb_3
cb_add cb_add
p_create p_create
rb_1 rb_1
rb_2 rb_2
p_1 p_1
cbx_1 cbx_1
pb_1 pb_1
gb_2 gb_2
rr_2 rr_2
end type
global w_sal_01070 w_sal_01070

type variables
string is_cvcod, &
         is_ymd, &
         is_cvnas2 
        
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
public subroutine wf_clear_item (integer icurrow)
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String spl_yymm, sNull, sToday, sItdsc, sIspec, sJijil, scvcod
Decimal {2} dDanga
Long   cnt

SetNull(sNull)

spl_yymm = dw_insert.GetItemString(lrow, "plan_ymd")
sCvcod   = dw_insert.GetItemString(lrow, "cvcod")

/* 추가 품번이 존재하는지 여부 체크 */
Select count(*) Into :cnt From weeksaplan
 Where sabu = :gs_sabu and plan_ymd = :is_ymd and cvcod = :is_cvcod
   and itnbr = :sitnbr;

if cnt > 0 then
  	MessageBox("자료 확인", "해당 품목의 주간계획이 이미 존재합니다.")
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
dw_insert.SetItem(lrow, "weeksaplan_wonsrc", 0)
	
if sitnbr = '' Or IsNull(sitnbr) Then Return 1	

/* 단가 */
Select Fun_Erp100000012(:sToday, :sitnbr, '.')
  Into :dDanga
  From dual;

If IsNull(dDanga) Then dDanga = 0
dw_insert.SetItem(lrow, "weeksaplan_wonsrc", ddanga)
		
dw_insert.SetItem(lrow, "itnbr", sitnbr)
dw_insert.SetItem(lrow, "itemas_itdsc", sitdsc)		  
dw_insert.SetItem(lrow, "itemas_ispec", sispec)
dw_insert.SetItem(lrow, "itemas_jijil", sJijil)

/* 미검수수량 */
dDanga = 0
select Nvl(sum(x.ioqty), 0) into :dDanga
  from imhist x, iomatrix y
 where x.sabu = :gs_sabu and
       x.cvcod = :scvcod and
		 x.itnbr = :sitnbr and 
       x.checkno is null and
       x.yebi1 is null and
       x.iogbn = y.iogbn and
       y.salegu = 'Y' and
       y.jepumio = 'Y' ;
		 
If IsNull(dDanga) Then dDanga = 0
dw_insert.SetItem(lrow, "weeksaplan_plan_conqty", ddanga)		 



Return 0
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"weeksaplan_wonsrc",   		   0)
dw_insert.SetItem(iCurRow,"weeksaplan_plan_conqty",      0)

end subroutine

on w_sal_01070.create
int iCurrent
call super::create
this.st_4=create st_4
this.dw_jogun=create dw_jogun
this.gb_3=create gb_3
this.cb_add=create cb_add
this.p_create=create p_create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_1=create p_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.dw_jogun
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.p_create
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.rr_2
end on

on w_sal_01070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.dw_jogun)
destroy(this.gb_3)
destroy(this.cb_add)
destroy(this.p_create)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.gb_2)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String sYn

dw_Jogun.SetTransObject(sqlca)
dw_Insert.Settransobject(sqlca)

dw_Jogun.Insertrow(0)

dw_jogun.SetItem(1,'symd',f_today())


// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')


p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'

w_mdi_frame.sle_msg.Text = '조정할 기준일자를 입력 및 선택하세요'

dw_Jogun.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_sal_01070
integer x = 64
integer y = 352
integer width = 4544
integer height = 1932
integer taborder = 10
string dataobject = "d_sal_01070"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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
	Case "itnbr"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"itnbr",gs_code)
		
		wf_check_itnbr(lrow, gs_code)
		Return 1
	Case "itemas_itdsc"
   	gs_codename = GetText()
	
	   open(w_itemas_popup)
   	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	   SetItem(lrow,"itnbr",gs_code)
		wf_check_itnbr(lrow, gs_code)
		Return 1
   Case "itemas_ispec", "itemas_jijil"
	   gs_gubun = GetText()
 	
   	open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
   	SetItem(lrow,"itnbr",gs_code)
		wf_check_itnbr(lrow, gs_code)
		Return 1
End Choose

end event

event dw_insert::itemchanged;call super::itemchanged;String sNull, sitnbr, stoday, sitdsc, sispec, spl_yymm, sJijil, sispeccode
Long lRow, lQty, cnt, lPqty
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
End Choose 
end event

type p_delrow from w_inherite`p_delrow within w_sal_01070
boolean visible = false
integer x = 4151
integer y = 3196
end type

type p_addrow from w_inherite`p_addrow within w_sal_01070
boolean visible = false
integer x = 3977
integer y = 3196
end type

type p_search from w_inherite`p_search within w_sal_01070
boolean visible = false
integer x = 3282
integer y = 3196
end type

type p_ins from w_inherite`p_ins within w_sal_01070
integer x = 3749
end type

event p_ins::clicked;call super::clicked;long lrow

If (is_ymd = '') or isNull(is_ymd) or  &
   (is_cvcod = '') or isNull(is_cvcod) then
	If (is_cvcod = '') or isNull(is_cvcod) then
		f_Message_Chk(203, '[거래처 입력 확인]')
	   dw_jogun.SetFocus()
	Else
   	f_Message_Chk(30, '[필수입력자료 확인]')
	   dw_jogun.SetFocus()
	End If
	Return 1
End If


Lrow = dw_insert.insertrow(0)
dw_insert.setitem(Lrow, "sabu", gs_sabu)
dw_insert.setitem(Lrow, "plan_ymd", is_ymd)
dw_insert.setitem(Lrow, "cvcod",    is_cvcod)
dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("itnbr")
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_sal_01070
end type

type p_can from w_inherite`p_can within w_sal_01070
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()


p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
p_create.enabled = true
p_create.PictureName = 'C:\erpman\image\자료생성_up.gif'

ib_any_typing = False

w_mdi_frame.sle_msg.Text = '조정할 계획년도 및 차수 관할구역을 입력 및 선택하세요'

rb_1.triggerevent(clicked!)

dw_Jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_sal_01070
boolean visible = false
integer x = 3456
integer y = 3196
end type

type p_inq from w_inherite`p_inq within w_sal_01070
integer x = 3575
end type

event p_inq::clicked;String  sYmd, scvcod

SetPointer(hourGlass!)

w_mdi_frame.sle_msg.Text = '주간 판매 계획을 조회중 입니다... 잠시 기다려 주세요'
If dw_Jogun.AcceptText() <> 1 Then Return

sYmd  = dw_Jogun.GetItemString(1, 'symd')
scvcod = dw_Jogun.GetItemString(1, 'cvcod')

is_ymd = symd
is_cvcod = scvcod

If isnull( symd ) or trim( symd ) = '' then
	MessageBox("기준일자", "기준일자를 먼저 입력하세요", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If isnull( scvcod ) or trim( scvcod ) = '' then
	MessageBox("거래처", "거래처코드를 먼저 입력하세요", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If dw_Insert.Retrieve(gs_sabu, sYmd, scvcod) < 1 then
	f_message_Chk(50, '[주간 판매 계획 조회]')
	w_mdi_frame.sle_msg.text = ''
End if

p_ins.enabled = True
p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.enabled = True
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
p_mod.enabled = True
p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
p_create.enabled = false
p_create.PictureName = 'C:\erpman\image\자료생성_d.gif'

w_mdi_frame.sle_msg.Text = '주간 판매 계획 조회 완료. 조정 및 추가, 삭제를 할 수 있습니다.'

rb_1.triggerevent(clicked!)

dw_Insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_sal_01070
end type

event p_del::clicked;call super::clicked;long i

If dw_insert.AcceptText() <> 1 Then Return

//If dw_insert.GetRow() <= 0 Then Return
//
//sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
//sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itemas_itdsc')

if MessageBox("삭제 확인", "선택된 자료를 삭제하시겠습니까? ",question!,yesno!, 2) = 2 THEN Return

//FOR  lRow = lRowCount 	TO		1		STEP  -1

FOR i = dw_insert.RowCount() to 1 Step -1
	If dw_insert.GetItemString(i,'opt') = 'Y' Then
//     	MessageBox("EE",i)
		dw_insert.deleterow(i)
	End If
NEXT


end event

type p_mod from w_inherite`p_mod within w_sal_01070
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)
If dw_insert.AcceptText() <> 1 Then Return 1

if dw_insert.Update() = -1 then  
   f_message_Chk(32,'[주간판매계획 조정작업]')
 	Rollback;
   SetPointer(Arrow!)	 
   return
else
   Commit;		
   f_message_Chk(202,'[주간판매계획 조정작업]')
	ib_any_typing = False
end if
SetPointer(Arrow!)	 

String  sYmd, scvcod, sSaupj

SetPointer(hourGlass!)

sYmd  = dw_Jogun.GetItemString(1, 'symd')
scvcod = dw_Jogun.GetItemString(1, 'cvcod')
sSaupj = dw_Jogun.GetItemString(1, 'saupj')
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[사업장]')
	dw_jogun.SetFocus()
	dw_jogun.Setcolumn('saupj')
	Return
End If

Long lcnt = 0
If MessageBox("작업생성","이후 계획을 생성할까요", question!, yesno!) = 1 then
	Lcnt = sqlca.van_weekplan3(gs_sabu, symd, scvcod, sSaupj);
	If Lcnt = -1 then 
		Messagebox("생성실패", "일자별 계획생성이 실패", stopsign!)
		rollback;		
	End if
End if

SetPointer(Arrow!)

p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_sal_01070
integer x = 3369
integer y = 3132
integer width = 352
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01070
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

type cb_ins from w_inherite`cb_ins within w_sal_01070
integer x = 2459
integer y = 2820
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_sal_01070
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

type cb_inq from w_inherite`cb_inq within w_sal_01070
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

type cb_print from w_inherite`cb_print within w_sal_01070
integer x = 2473
integer y = 2692
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_sal_01070
end type

type cb_can from w_inherite`cb_can within w_sal_01070
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

type cb_search from w_inherite`cb_search within w_sal_01070
integer x = 2414
integer y = 2556
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01070
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01070
end type

type st_4 from statictext within w_sal_01070
integer x = 69
integer y = 272
integer width = 1243
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = " 제품별 주간 판매계획 조정"
boolean focusrectangle = false
end type

type dw_jogun from u_key_enter within w_sal_01070
event ue_key pbm_dwnkey
integer x = 50
integer y = 40
integer width = 3278
integer height = 136
integer taborder = 20
string dataobject = "d_sal_01070_01"
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

Choose Case sCol_Name
   // 기준년도 유효성 Check
	Case "symd"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 8) then
			f_Message_Chk(35, '[기준일자]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		is_ymd = this.GetText()
	// 거래처등록
	Case "cvcod"
		sData = gettext()
		ii = f_get_name2("V1", 'Y', sdata, sname, sname1)
		if ii = 0 then
			setitem(1, "cvnas", sName)
		Else
			setitem(1, "cvcod", sNull)
			setitem(1, "cvnas", sNull)
			return 1
		End if		
end Choose
end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;String sEmpId, sSaupj

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
END Choose

end event

type gb_3 from groupbox within w_sal_01070
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

type cb_add from commandbutton within w_sal_01070
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

type p_create from uo_picture within w_sal_01070
integer x = 3401
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\자료생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

event clicked;call super::clicked;dw_jogun.AcceptText()

gs_code = dw_jogun.getitemstring(1, "symd")

If isnull( gs_code ) or trim( gs_code ) = '' then
	MessageBox("기준일자", "기준일자를 입력하세요", stopsign!)
	Setnull(gs_code)
	return 
end if

open(w_sal_01070_1)

end event

type rb_1 from radiobutton within w_sal_01070
integer x = 1038
integer y = 272
integer width = 224
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
string text = "요약"
boolean checked = true
end type

event clicked;dw_insert.Modify("DataWindow.Header.Height=70")	
dw_insert.Modify("DataWindow.Detail.Height=72")
dw_insert.modify("itemas_ispec.protect = 1")
dw_insert.modify("itemas_jijil.protect = 1")

end event

type rb_2 from radiobutton within w_sal_01070
integer x = 1326
integer y = 272
integer width = 247
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
string text = "상세1"
end type

event clicked;dw_insert.Modify("DataWindow.Header.Height=152")	
dw_insert.Modify("DataWindow.Detail.Height=142")
dw_insert.modify("itemas_ispec.protect = 0")
dw_insert.modify("itemas_jijil.protect = 0")


end event

type p_1 from uo_picture within w_sal_01070
boolean visible = false
integer x = 3227
integer y = 24
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event clicked;call super::clicked;String symd
integer icnt

if dw_jogun.accepttext() = -1 then return

symd = dw_jogun.getitemstring(1, "symd")

If isnull( symd ) or trim( symd ) = '' then
	MessageBox("기준일자", "기준일자를 입력하세요", stopsign!)
	Setnull( symd )
	return 
end if

Long Lrow
Lrow = 0
Select Count(*) into :Lrow
  From weeksaplan
 Where sabu = :gs_sabu and plan_ymd = :symd;
If Lrow <1 then
	MessageBox("소요량 계산", "계산할 자료가 없읍니다" + '~n' + &
									  "주간 판매계획 수립후 다시 실행하세요", information!)
	return
End if

w_mdi_frame.sle_msg.Text = '주간 소요량을 조회중 입니다... 잠시 기다려 주세요'


/* MRP Server procedure 를 실행
   step마다 error check를 실행하여 error가 발생할 경우 해당시점에서
	중단 */
String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, ssaupj
String temp_calgu
integer dseq, dCnt, dMaxno, dAddNo

sgijun = '3'  // 주간 영업계획 기준
sgyymm = symd
scalgu = '1'  // Factor적용 
sstdat = symd
seddat = f_afterday(symd, 13)
ssaupj = dw_jogun.getitemstring(1, "saupj")

smsgtxt = symd + ' 일 기준 주간 소요량 전개(MRP)처리를 하시겠습니까?'
if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

setpointer(hourglass!)

serror = 'X'
icnt = 0

// Mrp History Create
/* MRP실행이력의 최대 실행순번을 구한다 */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu;

if isnull(dmaxno) then dmaxno = 0;

dMaxno = dmaxno + 1

IF sCalgu = '1' THEN
	sTXT	= 'FACTOR적용';
ELSEIF sCalgu = '2' THEN
	sTXT  = 'FACTOR적용안함';
ELSE
	sTXT  = 'FACTOR적용+적용안함';
END IF;

/* MRP이력을 작성한다 */
INSERT INTO MRPSYS (SABU, ACTNO, MRPRUN, MRPGIYYMM, MRPDATA, MRPCUDAT, MRPSIDAT,
						  MRPEDDAT, MRPTXT, MRPSEQ, MRPCALGU, MRPPDTSND, MRPMATSND, MRPDELETE, SAUPJ)
		VALUES(:gs_sabu, :dMAXNO, TO_CHAR(SYSDATE, 'YYYYMMDD'), :symd, :sgijun,
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), :sstdat, :seddat, :stxt, :dseq, 'N','N','N','N', :ssaupj);
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp History Create]' + '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END If

COMMIT;

openwithparm(w_pdt_01030_2, dmaxno)
sCheck = message.stringparm
if sCheck = 'N' then 
	return
end if
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. .............."

String ssilgu
ssilgu = f_get_syscnfg('S', 8, '40')

// mrp initial
w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. .............." + "MRP Initial Create"
sqlca.erp000000050_1(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, ssilgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Initial]' + '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// open order merge
w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. ..............Open Order Merge"
IF SCALGU = '1' THEN /* FACTOR를 적용하는 경우에만 생성 */
	sqlca.erp000000050_2(gs_sabu, dmaxno, sgijun, serror);
	If isnull(serror) or serror = 'X' or serror = 'Y' then
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(41,'[MRP RUN-Open Order Merge]'+ '~n' + sqlca.sqlerrtext)
		dw_jogun.setfocus()
		return
	END IF
END IF

// product schedule
w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. ..............Open Product Schedule"
sqlca.erp000000050_3(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN- Product Schedule]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// manufacturing resource create
w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. ..............Manufacturing Resource Create"
sqlca.erp000000050_4(gs_sabu, dmaxno, sgijun, sgyymm, scalgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Manufacturing Resource Create]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// mrp detail record create
//w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. ..............MRP Detail Record Create"
//sqlca.erp000000050_5(gs_sabu, dmaxno, sgijun, serror);
//If isnull(serror) or serror = 'X' or serror = 'Y' then
//	w_mdi_frame.sle_msg.text = ""
//	f_message_chk(41,'[MRP RUN-Mrp Detail Record Create-1]'+ '~n' + sqlca.sqlerrtext)
//	dw_jogun.setfocus()
//	return
//END IF

// plan detail record create
w_mdi_frame.sle_msg.Text = "자재 소요량 전개(MRP)처리중. ..............Plan Detail Record Create"
sqlca.erp000000050_6(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create-2]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// Data Transfer
w_mdi_frame.sle_msg.Text = "자료 전송중. ..............Data Transfer"

sqlca.erp000000050_8(gs_sabu, dmaxno, symd, sgijun, serror); 
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create-3]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

/* MRP계산이 정상적으로 종료되었다는 표시를 한다 */
Update mrpsys
   set mrpcalgu = 'Y'
 Where sabu = :gs_sabu and actno = :dmaxno;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[계산이력 작성중 오류발생]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END If 

Update reffpf
   set rfna2 = to_char(:dmaxno)
 where sabu = '1' and rfcod = '1A' and rfgub = '1';

COMMIT;

messagebox("자재 소요량 계산", "실행번호 -> " + string(dmaxno) + " 로 정상종료되었읍니다")

w_mdi_frame.sle_msg.text = ""
dw_jogun.setfocus()



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

type cbx_1 from checkbox within w_sal_01070
integer x = 1627
integer y = 272
integer width = 457
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
string text = "전체 선택"
end type

event clicked;Long Lrow

If this.Checked = True Then
	For Lrow = 1 to dw_insert.rowcount()
  		 dw_insert.Setitem(Lrow, "opt", 'Y')
	Next
Else
	For Lrow = 1 to dw_insert.rowcount()
		 dw_insert.Setitem(Lrow, "opt", 'N')
	Next
End if
end event

type pb_1 from u_pb_cal within w_sal_01070
integer x = 905
integer y = 60
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('symd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'symd', gs_code)

end event

type gb_2 from groupbox within w_sal_01070
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

type rr_2 from roundrectangle within w_sal_01070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 256
integer width = 4594
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

