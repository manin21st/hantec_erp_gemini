$PBExportHeader$w_sal_010511.srw
$PBExportComments$ 연동 판매 계획 자동 생성(생성)
forward
global type w_sal_010511 from w_inherite_popup
end type
type dw_ip from datawindow within w_sal_010511
end type
type gb_2 from groupbox within w_sal_010511
end type
type cbx_select from checkbox within w_sal_010511
end type
type p_1 from picture within w_sal_010511
end type
type rr_1 from roundrectangle within w_sal_010511
end type
type rr_2 from roundrectangle within w_sal_010511
end type
end forward

global type w_sal_010511 from w_inherite_popup
integer width = 2853
integer height = 2288
string title = "연동판매계획 생성"
dw_ip dw_ip
gb_2 gb_2
cbx_select cbx_select
p_1 p_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_010511 w_sal_010511

type variables
String syymm, sCvcod
end variables

forward prototypes
public function double wf_get_avg (integer nrow, long lmonths)
end prototypes

public function double wf_get_avg (integer nrow, long lmonths);Double dQty, dAmt
String sym, seym, sLmsgu, sItcls
Int    iLen

/* 기간 설정 */
select to_char(add_months(to_date(:syymm,'yyyymm'),:lMonths*-1),'yyyymm'),
		 to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm')
  into :sym, :seym from dual;

sLmsgu = dw_ip.GetItemString(1, 'lmsgu')
sItcls = dw_1.GetItemString(nRow, 'itcls')

If sLmsgu = 'L' Then
	iLen = 2
ElseIf sLmsgu = 'M' Then
	iLen = 4
Else
	iLen = 7
End If

/* 평균 수량,금액 */
select round(sum(qty)/sum(cnt),0), round(sum(amt)/sum(cnt),0)
  into :dqty, :dAmt
  from ( Select b.sales_yymm, 
                sum(b.sales_qty) as qty,
                sum(b.sales_qty * fun_erp100000012(to_char(sysdate,'yyyymmdd'), b.itnbr, '.') ) as amt,
					 1 as cnt
		  From salesum b, vndmst v, sarea a, itemas i
		 Where b.sabu = :gs_sabu and 
				 b.sales_yymm between :sym and :seym and
				 b.cvcod = :sCvcod and 
				 b.sales_qty <> 0 and
				 b.itnbr = i.itnbr and
				 b.silgu = ( select substr(dataname,1,1) from syscnfg 
                               where sysgu = 'S' and
                                     serial = 8 and
                                     lineno = '40' ) and
				 i.itcls like :sitcls||'%' and
				 b.cvcod = v.cvcod and
				 v.sarea = a.sarea 
		  GROUP BY b.sales_yymm) x;
				  
If IsNull(dQty) Then dQty = 0
If IsNull(dAmt) Then dAmt = 0

dw_1.SetItem(nRow, 'qty', dQty)
dw_1.SetItem(nRow, 'amt', dAmt)

Return 0
end function

event open;call super::open;sCvcod = gs_code

syymm = Message.Stringparm
If IsNull(syymm) Or syymm = '' Then
	Close(this)
	Return
End If

f_window_center_response(this)

dw_1.SetTransObject(sqlca)
dw_ip.SetTransObject(sqlca)

dw_ip.InsertRow(0)

/* 대분류 조회 */
Long ix

dw_1.Retrieve(gs_sabu, 'L')

For ix = 1 To dw_1.RowCount()
	dw_1.SetItem(ix, 'chk', 'Y')
	dw_1.SetItem(ix, 'shift', 'Y')
Next
end event

on w_sal_010511.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.gb_2=create gb_2
this.cbx_select=create cbx_select
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cbx_select
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sal_010511.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.gb_2)
destroy(this.cbx_select)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_010511
boolean visible = false
integer width = 2025
string dataobject = "d_sal_010511_4"
end type

type p_exit from w_inherite_popup`p_exit within w_sal_010511
integer x = 2629
integer y = 24
integer taborder = 50
end type

event p_exit::clicked;call super::clicked;gs_code = '0'
close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_010511
integer x = 2455
integer y = 24
integer taborder = 40
boolean originalsize = false
end type

type p_choose from w_inherite_popup`p_choose within w_sal_010511
boolean visible = false
integer x = 2103
integer y = 180
integer taborder = 70
end type

type dw_1 from w_inherite_popup`dw_1 within w_sal_010511
integer x = 37
integer y = 360
integer width = 2738
integer height = 1656
integer taborder = 60
string dataobject = "d_sal_010511_2"
end type

event dw_1::itemchanged;call super::itemchanged;Long nRow
String sCrtgu

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'chk'
		sCrtgu = dw_ip.GetItemString(1, 'crtgu')
		
		/* Shift생성일 경우 */
		If sCrtgu = '1' Then	Return 2
	Case 'months'
		wf_get_avg(nRow, Long(GetText()))
	Case 'shift'
		sCrtgu = dw_ip.GetItemString(1, 'crtgu')
		
		/* Shift생성일 경우 */
		If sCrtgu = '1' Then	Return 2
End Choose
end event

event dw_1::ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event dw_1::itemerror;call super::itemerror;return 1
end event

event dw_1::rowfocuschanged;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_010511
boolean visible = false
integer x = 558
integer y = 2228
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_010511
boolean visible = false
integer x = 1874
integer y = 1928
integer taborder = 90
string text = "생성(&S)"
end type

event cb_1::clicked;call super::clicked;String sCrtgu, seym, sym, sLmsgu, sItcls
Long	 lMonths, lRate, ix
Dec    dCrtCnt

If dw_ip.AcceptText() <> 1 Then Return 
If dw_1.AcceptText()  <> 1 Then Return 

sCrtgu = dw_ip.GetItemString(1, 'crtgu')

SetPointer(HourGlass!)
 
Choose Case sCrtgu
	/* 생성구분 : SHIFT */
	Case '1'
		/* 기간 검색 */
		select to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm')
		  into :seym from dual;

		/* 해당 년월의 판매계획 삭제 */
		Delete From shortsaplan
		 Where sabu = :gs_sabu and
		       plan_yymm = :sYYMM and
				 cvcod = :scvcod;
		if SQLCA.SqlCode = -1 then
			MessageBox('ERROR', '신규 기초데이타 생성을 위한 Data Clear 실패' + '~r~r' + &
									  '전산실 문의 하세요')
			Rollback;
			return
		end if
		
		/* 해당 년월의 판매계획 생성 */
		Insert Into shortsaplan
			 Select sabu, :sYYMM, cvcod, itnbr, 
					  plan_qty_m2, plan_qty_m3, plan_qty_m4, plan_qty_m5, 0,
					  plan_amt_m2, plan_amt_m3, plan_amt_m4, plan_amt_m5, 0, 0, '', '', '', '',
					  0, 0, 0, 0
				From shortsaplan
			  Where sabu = :gs_sabu and
			        plan_yymm = :seym and
					  cvcod = :sCvcod;
		If SQLCA.SqlCode = -1 then
			MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
									  '전산실로 문의 하세요')
			Rollback;
			Return
		End If
	
		/* 생성건수 */
		dCrtCnt = sqlca.sqlnrows
		
		Commit;
		
		gs_code = String(dCrtCnt)
		MessageBox('확 인', '정상적으로 생성되었습니다.~n~n[생성건수 : '+string(dCrtcnt) + '건]')
		
		Close(Parent)
		Return
	/* 생성구분 : SHIFT + RATE, RATE */
	Case '2', '3'
		sLmsgu = dw_ip.GetItemString(1, 'lmsgu')
		
		dCrtCnt = 0
		For ix = 1 To dw_1.RowCount()
			If dw_1.GetItemString(ix, 'chk') = 'N' Then Continue
			
			sItcls = dw_1.GetItemString(ix, 'itcls')

			/* 해당 년월의 판매계획 삭제 */
			Delete From shortsaplan a
			 Where a.sabu = :gs_sabu and
					 a.plan_yymm = :sYYMM and
					 a.cvcod = :sCvcod and
					 exists ( select * from itemas i, itnct t
					           where i.itnbr = a.itnbr and
								        i.ittyp = t.ittyp and
										  substr(i.itcls,1,length(:sItcls)) = t.itcls and
										  t.ittyp = '1' and
										  t.itcls = :sItcls and
										  t.lmsgu = :sLmsgu
										  );

			If SQLCA.SqlCode = -1 then
				MessageBox('ERROR', '신규 기초데이타 생성을 위한 Data Clear 실패' + '~r~r' + &
										  '전산실 문의 하세요')
				Rollback;
				Return
			End If
				
			/* 생성이 SHIFT일 경우 */
			If dw_1.GetItemString(ix, 'shift') = 'Y' Then
				Insert Into shortsaplan
					 Select a.sabu, :sYYMM, a.cvcod, a.itnbr, 
							  a.plan_qty_m2, a.plan_qty_m3, a.plan_qty_m4, a.plan_qty_m5, 0,
							  a.plan_amt_m2, a.plan_amt_m3, a.plan_amt_m4, a.plan_amt_m5, 0, 0, '', '', '', '',
							  0, 0, 0, 0
						From shortsaplan a, itemas i, itnct t
					  Where a.sabu = :gs_sabu and
							  a.plan_yymm = :seym and
							  a.cvcod = :sCvcod and
							  a.itnbr = i.itnbr and
							  i.ittyp = t.ittyp and
							  substr(i.itcls,1,length(:sItcls)) = t.itcls and
							  t.ittyp = '1' and
							  t.itcls = :sItcls and
							  t.lmsgu = :sLmsgu;
				If SQLCA.SqlCode = -1 then
					MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
											  '전산실로 문의 하세요')
					Rollback;
					Return
				End If
				
				dCrtCnt += sqlca.sqlnrows
			/* 생성이 RATE일 경우 */
			Else
				lMonths = dw_1.GetItemNumber(ix, 'months')
				lRate	  = dw_1.GetItemNumber(ix, 'rate')
				
				If IsNull(lMonths) Then
					f_message_chk(1400,'[실적개월수]')
					Return
				End If
				
				If IsNull(lRate) Then
					f_message_chk(1400,'[증감율]')
					Return
				End If
		
				/* 기간 검색 */
				select to_char(add_months(to_date(:syymm,'yyyymm'),:lMonths*-1),'yyyymm'),
						 to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm')
				  into :sym, :seym from dual;
				  
				/* 해당 년월의 판매계획 생성 */
				Insert Into shortsaplan
					 Select :gs_sabu, :sYYMM, a.cvcod, a.itnbr, '1', 
							  a.qty, a.qty, a.qty, a.qty, a.qty,
							  round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), 
							  :lRate,
							  '', '', '', '',
							  0, 0, 0, 0
						from ( Select a.itnbr, 
										  round((Round((sum(a.sales_qty)/:lMonths ),0))*(:lRate /100 + 1),0) as qty,
										  fun_erp100000012(to_char(sysdate,'yyyymmdd'), a.itnbr,'.') as Danga
									From salesum a, itemas i, itnct t
								  Where a.sabu = :gs_sabu and 
										  a.sales_yymm between :sym and :seym and
										  a.cvcod  = :sCvcod and
										  a.itnbr = i.itnbr and
										  a.silgu = ( select substr(dataname,1,1) from syscnfg 
															 where sysgu = 'S' and
																	 serial = 8 and
																	 lineno = '40' ) and
								        i.ittyp = t.ittyp and
										  substr(i.itcls,1,length(:sItcls)) = t.itcls and
										  t.ittyp = '1' and
										  t.itcls = :sItcls and
										  t.lmsgu = :sLmsgu
								  group by a.itnbr ) a ;
					 
				If SQLCA.SqlCode = -1 then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
					MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
											  '전산실로 문의 하세요')
					Rollback;
					Return
				End If
				
				dCrtCnt += sqlca.sqlnrows
			End If
		Next
		
		Commit;

		MessageBox('확 인', '정상적으로 생성되었습니다.~n~n[생성건수 : '+string(dCrtcnt) + '건]')
		gs_code = String(dCrtCnt)
		
		Close(Parent)
		Return
End Choose
end event

type cb_return from w_inherite_popup`cb_return within w_sal_010511
boolean visible = false
integer x = 2510
integer y = 1928
integer taborder = 110
end type

event cb_return::clicked;call super::clicked;gs_code = '0'
close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_010511
boolean visible = false
integer x = 2194
integer y = 1928
integer taborder = 100
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_010511
boolean visible = false
integer x = 334
integer y = 2232
end type

type st_1 from w_inherite_popup`st_1 within w_sal_010511
integer x = 59
integer y = 2048
integer width = 2702
integer height = 104
long backcolor = 16777215
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_sal_010511
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 44
integer width = 1787
integer height = 276
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_010511_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sLmsgu, sCrtgu, sLCvcod, sItnbr, sRmk, sToday
Double dRate, dCrtcnt
Int	 ix
string docname, named
integer value
Long   Lrow, lcnt1, lcnt2, lcnt3, Lins
sTring  sErrname [3] = {'거래처없음', '품번없음', '계획존재'}
decimal {2} dprice

sToday = f_today()

Choose Case GetColumnName()
	/* 생성구분 */
	Case 'crtgu'
		sCrtgu = GetText()
	
		Choose Case sCrtgu 
			Case '1'
				
				dw_1.dataobject = 'd_sal_010511_2'
				dw_1.settransobject(sqlca)
				
				SetItem(1, 'lmsgu','L')
				dw_1.Retrieve(gs_sabu, 'L')
				
				For ix = 1 To dw_1.RowCount()
					dw_1.SetItem(ix, 'chk', 'Y')
					dw_1.SetItem(ix, 'shift', 'Y')
				Next
			Case '2','3'

				dw_1.dataobject = 'd_sal_010511_2'
				dw_1.settransobject(sqlca)				
				
				sLmsgu = getItemString(1, 'lmsgu')
				dw_1.Retrieve(gs_sabu, sLmsgu)
				
				For ix = 1 To dw_1.RowCount()
					dw_1.SetItem(ix, 'shift', 'N')
				Next
			Case '4'
				
				dw_1.dataobject = 'd_sal_010511_3'
				dw_1.settransobject(sqlca)			
	
				value = GetFileOpenName("Select File", docname, named, "TXT", "Text Files (*.TXT),*.TXT")

				IF value = 1 THEN 
					dw_1.importfile(docname)
					dw_jogun.reset()				
					For Lrow = 1 to dw_1.rowcount()
						 
						 dw_1.setitem(Lrow, "sabu", 		gs_sabu)
						 dw_1.setitem(Lrow, "plan_yymm", syymm)
						 
						 sLCvcod = dw_1.getitemstring(Lrow, "cvcod")
						 sItnbr  = dw_1.getitemstring(Lrow, "itnbr")
						 
						/* 단가 */
						Select Fun_Erp100000012(:sToday, :sitnbr, '.')
						  Into :dPrice
						  From dual;
						
						If IsNull(dPrice) Then dPrice = 0
						
						 dw_1.setitem(Lrow, "plan_amt_m1", round(dPrice * dw_1.getitemdecimal(Lrow, "plan_qty_m1"), 0))
						 dw_1.setitem(Lrow, "plan_amt_m2", round(dPrice * dw_1.getitemdecimal(Lrow, "plan_qty_m2"), 0))
						 dw_1.setitem(Lrow, "plan_amt_m3", round(dPrice * dw_1.getitemdecimal(Lrow, "plan_qty_m3"), 0))
						 dw_1.setitem(Lrow, "plan_amt_m4", round(dPrice * dw_1.getitemdecimal(Lrow, "plan_qty_m4"), 0))
						 dw_1.setitem(Lrow, "plan_amt_m5", round(dPrice * dw_1.getitemdecimal(Lrow, "plan_qty_m5"), 0))
						 
						 /* 거래처여부 */
						 Lcnt1 = 0
						 Select count(*) into :Lcnt1 From vndmst
						  Where cvcod = :sLCvcod;

						 /* 품번여부 */
						 Lcnt2 = 0
						 Select count(*) into :Lcnt2 From itemas
						  Where itnbr = :sItnbr;	  
						  	 
						 
						 /* 계획존재여부 검색 */
						 Lcnt3 = 0
						 Select count(*) into :Lcnt3 From shortsaplan
						  Where sabu = :gs_sabu And plan_yymm = :syymm and cvcod = :sLCvcod
						  	 And itnbr = :sitnbr;
								
						 If Lcnt1 = 0 or Lcnt2  = 0 or Lcnt3 > 0 then
							 Lins = dw_jogun.insertrow(0)
							 dw_jogun.object.cvcod[Lins]  = dw_1.object.cvcod[Lrow]
							 dw_jogun.object.itnbr[Lins]  = dw_1.object.itnbr[Lrow]
							 sRmk = ' '
							 If Lcnt1 = 0 Then srmk = sRmk + sErrname[1] 
							 If Lcnt2 = 0 Then srmk = sRmk + sErrname[2] 
							 If Lcnt3 > 0 Then srmk = sRmk + sErrname[3] 
							 dw_jogun.object.rmk[Lins] = srmk
						 End if
						 
					Next
					
					If dw_jogun.rowcount() > 0 then
						Messagebox("저장", "오류가 발생하여 보고서를 발행하니 참조바랍니다", stopsign!)
						dw_jogun.print()
						st_1.text = ''
						rollback;
						return						
						
					end if
					
					if dw_1.update() <> 1 then
						Messagebox("저장", "저장에 실패하였읍니다", stopsign!)
						st_1.text = ''
						rollback;
						return
					End if
					commit;
					
					dcrtcnt = dw_1.rowcount()
					
					MessageBox('확 인', '정상적으로 생성되었습니다.~n~n[생성건수 : '+string(dCrtcnt) + '건]')
					gs_code = String(dCrtCnt)		
					Close(parent)
					return

				Else
					dw_1.dataobject = 'd_sal_010511_2'
					dw_1.settransobject(sqlca)
					
					SetItem(1, 'crtgu','1')					
					SetItem(1, 'lmsgu','L')
					dw_1.Retrieve(gs_sabu, 'L')
					
					For ix = 1 To dw_1.RowCount()
						dw_1.SetItem(ix, 'chk', 'Y')
						dw_1.SetItem(ix, 'shift', 'Y')
					Next
					return 2
				End if
				
		End Choose
	/* 품목분류 */
	Case 'lmsgu'
		sLmsgu = GetText()
		
		dw_1.Retrieve(gs_sabu, sLmsgu)
	/* 증감율 */
	Case 'rate'
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		For ix = 1 To dw_1.RowCount()
			dw_1.SetItem(ix, 'rate', dRate)
		Next
End Choose
end event

event itemerror;Return 1
end event

type gb_2 from groupbox within w_sal_010511
integer x = 2286
integer y = 192
integer width = 512
integer height = 140
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type cbx_select from checkbox within w_sal_010511
integer x = 2377
integer y = 236
integer width = 393
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
boolean checked = true
end type

event clicked;String sStatus
Long 	 k

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

FOR k = 1 TO dw_1.RowCount()
	dw_1.SetItem(k,"chk",sStatus)
Next
end event

type p_1 from picture within w_sal_010511
integer x = 2281
integer y = 24
integer width = 178
integer height = 144
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event clicked;String sCrtgu, seym, sym, sLmsgu, sItcls
Long	 lMonths, lRate, ix
Dec    dCrtCnt

If dw_ip.AcceptText() <> 1 Then Return 
If dw_1.AcceptText()  <> 1 Then Return 

sCrtgu = dw_ip.GetItemString(1, 'crtgu')

SetPointer(HourGlass!)
 
Choose Case sCrtgu
	/* 생성구분 : SHIFT */
	Case '1'
		/* 기간 검색 */
		select to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm')
		  into :seym from dual;
 
		/* 해당 년월의 판매계획 삭제 */
		Delete From shortsaplan
		 Where sabu = :gs_sabu and
		       plan_yymm = :sYYMM and
				 cvcod     = :sCvcod;
		if SQLCA.SqlCode = -1 then
			MessageBox('ERROR', '신규 기초데이타 생성을 위한 Data Clear 실패' + '~r~r' + &
									  '전산실 문의 하세요')
			Rollback;
			return
		end if
		
		/* 해당 년월의 판매계획 생성 */
		Insert Into shortsaplan
			 Select sabu, :sYYMM, cvcod, itnbr, 
					  plan_qty_m2, plan_qty_m3, plan_qty_m4, plan_qty_m5, 0,
					  plan_amt_m2, plan_amt_m3, plan_amt_m4, plan_amt_m5, 0, 0, '', '', '', '',
					  0, 0, 0, 0
				From shortsaplan
			  Where sabu = :gs_sabu and
			        plan_yymm = :seym and
					  cvcod = :sCvcod;
		If SQLCA.SqlCode = -1 then
			MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
									  '전산실로 문의 하세요')
			Rollback;
			Return
		End If
	
		/* 생성건수 */
		dCrtCnt = sqlca.sqlnrows
		
		Commit;
		
		gs_code = String(dCrtCnt)
		MessageBox('확 인', '정상적으로 생성되었습니다.~n~n[생성건수 : '+string(dCrtcnt) + '건]')
		
		Close(Parent)
		Return
	/* 생성구분 : SHIFT + RATE, RATE */
	Case '2', '3'
		sLmsgu = dw_ip.GetItemString(1, 'lmsgu')
		
		dCrtCnt = 0
		For ix = 1 To dw_1.RowCount()
			If dw_1.GetItemString(ix, 'chk') = 'N' Then Continue
			
			sItcls = dw_1.GetItemString(ix, 'itcls')

			/* 해당 년월의 판매계획 삭제 */
			Delete From shortsaplan a
			 Where a.sabu = :gs_sabu and
					 a.plan_yymm = :sYYMM  and
					 a.cvcod     = :sCvcod and
					 exists ( select * from itemas i, itnct t
					           where i.itnbr = a.itnbr and
								        i.ittyp = t.ittyp and
										  substr(i.itcls,1,length(:sItcls)) = t.itcls and
										  t.ittyp = '1' and
										  t.itcls = :sItcls and
										  t.lmsgu = :sLmsgu
										  );

			If SQLCA.SqlCode = -1 then
				MessageBox('ERROR', '신규 기초데이타 생성을 위한 Data Clear 실패' + '~r~r' + &
										  '전산실 문의 하세요')
				Rollback;
				Return
			End If
				
			/* 생성이 SHIFT일 경우 */
			If dw_1.GetItemString(ix, 'shift') = 'Y' Then
				Insert Into shortsaplan
					 Select a.sabu, :sYYMM, a.cvcod, a.itnbr, 
							  a.plan_qty_m2, a.plan_qty_m3, a.plan_qty_m4, a.plan_qty_m5, 0,
							  a.plan_amt_m2, a.plan_amt_m3, a.plan_amt_m4, a.plan_amt_m5, 0, 0, '', '', '', '',
							  0, 0, 0, 0
						From shortsaplan a, itemas i, itnct t
					  Where a.sabu = :gs_sabu and
							  a.plan_yymm = :seym and
							  a.cvcod = :sCvcod and
							  a.itnbr = i.itnbr and
							  i.ittyp = t.ittyp and
							  substr(i.itcls,1,length(:sItcls)) = t.itcls and
							  t.itcls = :sItcls and
							  t.lmsgu = :sLmsgu;
				If SQLCA.SqlCode = -1 then
					MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
											  '전산실로 문의 하세요')
					Rollback;
					Return
				End If
				
				dCrtCnt += sqlca.sqlnrows
			/* 생성이 RATE일 경우 */
			Else
				lMonths = dw_1.GetItemNumber(ix, 'months')
				lRate	  = dw_1.GetItemNumber(ix, 'rate')
				
				If IsNull(lMonths) Then
					f_message_chk(1400,'[실적개월수]')
					Return
				End If
				
				If IsNull(lRate) Then
					f_message_chk(1400,'[증감율]')
					Return
				End If
		
				/* 기간 검색 */
				select to_char(add_months(to_date(:syymm,'yyyymm'),:lMonths*-1),'yyyymm'),
						 to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm')
				  into :sym, :seym from dual;
		 		  
				/* 해당 년월의 판매계획 생성 */
				Insert Into shortsaplan
					 Select :gs_sabu, :sYYMM, a.cvcod, a.itnbr, 
							  a.qty, a.qty, a.qty, a.qty, a.qty,
							  round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), round(a.qty*a.danga,0), 
							  :lRate,
							  '', '', '', '',
							  0, 0, 0, 0
						from ( Select a.itnbr, a.cvcod, 
										  round((Round((sum(a.sales_qty)/:lMonths ),0))*(:lRate /100 + 1),0) as qty,
										  fun_erp100000012(to_char(sysdate,'yyyymmdd'), a.itnbr, '.') as Danga
									From salesum a, itemas i, itnct t
								  Where a.sabu = :gs_sabu and 
										  a.sales_yymm between :sym and :seym and
										  a.cvcod = :sCvcod and
										  a.itnbr = i.itnbr and
										  a.silgu = ( select substr(dataname,1,1) from syscnfg 
															 where sysgu = 'S' and
																	 serial = 8 and
																	 lineno = '40' ) and
								        i.ittyp = t.ittyp and
										  substr(i.itcls,1,length(:sItcls)) = t.itcls and
										  t.ittyp = '1' and
										  t.itcls = :sItcls and
										  t.lmsgu = :sLmsgu
								  group by a.itnbr, a.cvcod ) a ;
					 
				If SQLCA.SqlCode = -1 then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
					MessageBox('ERROR', '신규 기초데이타 생성 실패' + '~r~r' + &
											  '전산실로 문의 하세요')
					Rollback;
					Return
				End If
				
				dCrtCnt += sqlca.sqlnrows
			End If
		Next
		
		Commit;

		MessageBox('확 인', '정상적으로 생성되었습니다.~n~n[생성건수 : '+string(dCrtcnt) + '건]')
		gs_code = String(dCrtCnt)
		
		Close(Parent)
		Return
End Choose

end event

type rr_1 from roundrectangle within w_sal_010511
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 352
integer width = 2766
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_010511
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 2032
integer width = 2766
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

