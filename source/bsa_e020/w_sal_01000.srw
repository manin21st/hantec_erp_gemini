$PBExportHeader$w_sal_01000.srw
$PBExportComments$ ===>월별 예상실적 가중치 등록 및 예상실적 생성
forward
global type w_sal_01000 from w_inherite
end type
type st_2 from statictext within w_sal_01000
end type
type st_3 from statictext within w_sal_01000
end type
type st_4 from statictext within w_sal_01000
end type
type st_5 from statictext within w_sal_01000
end type
type gb_1 from groupbox within w_sal_01000
end type
type gb_3 from groupbox within w_sal_01000
end type
type st_10 from statictext within w_sal_01000
end type
type st_11 from statictext within w_sal_01000
end type
type gb_2 from groupbox within w_sal_01000
end type
type dw_jogun from u_key_enter within w_sal_01000
end type
type rb_new from radiobutton within w_sal_01000
end type
type rb_update from radiobutton within w_sal_01000
end type
type cbx_chk from checkbox within w_sal_01000
end type
type st_7 from statictext within w_sal_01000
end type
type rb_2 from radiobutton within w_sal_01000
end type
type rb_1 from radiobutton within w_sal_01000
end type
type rr_1 from roundrectangle within w_sal_01000
end type
end forward

global type w_sal_01000 from w_inherite
string title = "월별 예상실적 가중치 등록 및 예상실적 생성"
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
gb_1 gb_1
gb_3 gb_3
st_10 st_10
st_11 st_11
gb_2 gb_2
dw_jogun dw_jogun
rb_new rb_new
rb_update rb_update
cbx_chk cbx_chk
st_7 st_7
rb_2 rb_2
rb_1 rb_1
rr_1 rr_1
end type
global w_sal_01000 w_sal_01000

type variables
string is_yy01, &
         is_yy02, &
         is_yy03, &
         is_yy04, &
         is_yy05, &
         is_yy06, &
         is_yy07, &
         is_yy08, &
         is_yy09, &
         is_yy10, &
         is_yy11, &
         is_yy12, &
         is_year
end variables

on w_sal_01000.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_3=create gb_3
this.st_10=create st_10
this.st_11=create st_11
this.gb_2=create gb_2
this.dw_jogun=create dw_jogun
this.rb_new=create rb_new
this.rb_update=create rb_update
this.cbx_chk=create cbx_chk
this.st_7=create st_7
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.st_10
this.Control[iCurrent+8]=this.st_11
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.dw_jogun
this.Control[iCurrent+11]=this.rb_new
this.Control[iCurrent+12]=this.rb_update
this.Control[iCurrent+13]=this.cbx_chk
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.rb_2
this.Control[iCurrent+16]=this.rb_1
this.Control[iCurrent+17]=this.rr_1
end on

on w_sal_01000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.gb_2)
destroy(this.dw_jogun)
destroy(this.rb_new)
destroy(this.rb_update)
destroy(this.cbx_chk)
destroy(this.st_7)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")

end event

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : 월별 예상실적 가중치 등록 및 예상실적 생성                ***//
//***  PGM ID   : W_SAL_01000                                               ***//
//***  SUBJECT  : 장기 및 년간 판매 생성시 수립년월 이후의 미 판매월의      ***//
//***             실적을 미판매 월별 가중치를 부여하여 당년도 년간판매      ***//
//***             계획의 해당월에 가중치를 적용하여 예상실적을 만든다.      ***//
//*****************************************************************************//

dw_Jogun.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)

rb_new.TriggerEvent(Clicked!)

setnull(gs_code)


end event

type dw_insert from w_inherite`dw_insert within w_sal_01000
boolean visible = false
integer x = 306
integer y = 2788
integer width = 2862
integer height = 224
integer taborder = 10
end type

type p_delrow from w_inherite`p_delrow within w_sal_01000
boolean visible = false
integer x = 3589
integer y = 2692
end type

type p_addrow from w_inherite`p_addrow within w_sal_01000
boolean visible = false
integer x = 3415
integer y = 2692
end type

type p_search from w_inherite`p_search within w_sal_01000
integer x = 3954
integer width = 320
string picturename = "C:\erpman\image\판매실적추출_up.gif"
end type

event p_search::clicked;call super::clicked;String sYear, sMM, sNull, sSaupj
Long   nCnt
Double sale_amt01 = 0, sale_amt02 = 0, sale_amt03 = 0, sale_amt04 = 0, &
       sale_amt05 = 0, sale_amt06 = 0, sale_amt07 = 0, sale_amt08 = 0, &
	    sale_amt09 = 0, sale_amt10 = 0, sale_amt11 = 0, sale_amt12 = 0		 
Int    ix

If dw_jogun.AcceptText() <> 1 Then Return

sMM 	 = Trim(dw_jogun.GetItemString(1,'sales_mm'))
sSaupj = Trim(dw_jogun.GetItemString(1,'saupj'))

If IsNull(sMM) or sMM = '' then
	f_Message_Chk(35, '[수립월]')
	dw_jogun.SetItem(1, "sales_mm", sNull)
	return 1
end if

/* 판매실적 추출은 수립년월 이전 */
sMM = String(Integer(sMM) - 1,'00')

SetPointer(HourGlass!)	

/* 기등록자료 확인 */
sYear = Trim(dw_jogun.GetItemString(1,'sales_yy'))
If IsNull(sYear) or sYear = '' Then
	f_message_chk(35,'[수립년도]')
	dw_jogun.SetItem(1, "sales_mm", sNull)
	return 1
End If

select count(*) into :nCnt 
  from salesumplan a, itemas b, itnct c 
 where a.sabu = :gs_sabu and a.sales_yymm like :sYear||'%'
	and a.itnbr = b.itnbr
	and b.ittyp = c.ittyp
	and b.itcls = c.itcls
	and c.porgu Like :sSaupj;
If nCnt > 0 Then
	If MessageBox('확 인','기존에 등록된 자료가 있습니다~r~n~r~n계속할까요?',Question!,YesNo!,2) = 2 Then Return
End If

w_mdi_frame.sle_msg.Text = '해당 월까지의 판매 실적 추출중...'

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

//*****************************************************************************
Select nvl(sum(Decode(a.sales_yymm, :is_yy01, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy02, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy03, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy04, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy05, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy06, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy07, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy08, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy09, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy10, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy11, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy12, nvl(a.sales_amt,0))),0)		 		 	 
	Into :sale_amt01, :sale_amt02, :sale_amt03, :sale_amt04, :sale_amt05, :sale_amt06, 
		 :sale_amt07, :sale_amt08, :sale_amt09, :sale_amt10, :sale_amt11, :sale_amt12
  From salesum a, itemas b, itnct c
 Where a.sabu = :gs_sabu 
	and a.sales_yymm >= :sYear||'01' and a.sales_yymm <= :sYear||:sMM and a.silgu = :ls_silgu
	and a.itnbr = b.itnbr
	and b.ittyp = c.ittyp
	and b.itcls = c.itcls
	and c.porgu Like :sSaupj;	

dw_jogun.SetItem(1, 'sale_1',  sale_amt01)
dw_jogun.SetItem(1, 'sale_2',  sale_amt02)
dw_jogun.SetItem(1, 'sale_3',  sale_amt03)
dw_jogun.SetItem(1, 'sale_4',  sale_amt04)		
dw_jogun.SetItem(1, 'sale_5',  sale_amt05)
dw_jogun.SetItem(1, 'sale_6',  sale_amt06)
dw_jogun.SetItem(1, 'sale_7',  sale_amt07)
dw_jogun.SetItem(1, 'sale_8',  sale_amt08)
dw_jogun.SetItem(1, 'sale_9',  sale_amt09)
dw_jogun.SetItem(1, 'sale_10', sale_amt10)
dw_jogun.SetItem(1, 'sale_11', sale_amt11)
dw_jogun.SetItem(1, 'sale_12', sale_amt12)

/* 수립년월 이후는 계획금액 */
For ix = Integer(sMM) + 1 To 12
	dw_jogun.SetItem(1, 'sale_'+string(ix), dw_jogun.GetItemNumber(1,'plan_'+string(ix)))
Next

w_mdi_frame.sle_msg.Text = ''
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\판매실적추출_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\판매실적추출_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_01000
integer x = 4270
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_ins::clicked;call super::clicked;Integer i, iMonth
String  sYear, sMonth, sYYMM, sSalesYYMM, sFrYymm, sToYymm, sTemp, sgubun, sSaupj
Long    lPlanQty, lWonSrc, lSalesQty, lSalesAmt
Dec     dRate[12], dDcRate, dActRate

If dw_Jogun.AcceptText() <> 1 Then Return

sYear   = dw_Jogun.GetItemString(1, 'sales_yy')
sMonth  = dw_Jogun.GetItemString(1, 'sales_mm')
sSaupj  = dw_Jogun.GetItemString(1, 'saupj')
iMonth  = Integer(sMonth)

if MessageBox("확 인", sYear + '년도 ' + sMonth + '월 이후 미판매분 예상실적을 생성합니다.' + '~r~r' + &
                       '미판매 월별 가중치를 입력했는지 확인하세요' + '~r~r' + &
							  '미판매월 예상 판매실적을 생성 하시겠습니까?', + &
							  question!,yesno!, 2) = 2 THEN 
	Return
end if

SetPointer(HourGlass!)

/* 적용품번 저장 (대표품번 생성 및 일반 품번 생성)*/
If cbx_chk.Checked = True Then
	UPDATE ITEM_REL
		SET ITNBRMD = ITNBRYD;
Else
	UPDATE ITEM_REL
		SET ITNBRMD = ITNBR;
End If

If SQLCA.SqlCode <> 0 then
	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	Rollback;
	return
Else
	Commit;
End If
		
dRate[1]  = dw_Jogun.GetItemNumber(1, 'rate_1')
if isNull(dRate[1]) then dRate[1] = 0.0 
dRate[2]  = dw_Jogun.GetItemNumber(1, 'rate_2')
if isNull(dRate[2]) then dRate[2] = 0.0 
dRate[3]  = dw_Jogun.GetItemNumber(1, 'rate_3')
if isNull(dRate[3]) then dRate[3] = 0.0 
dRate[4]  = dw_Jogun.GetItemNumber(1, 'rate_4')
if isNull(dRate[4]) then dRate[4] = 0.0 
dRate[5]  = dw_Jogun.GetItemNumber(1, 'rate_5')
if isNull(dRate[5]) then dRate[5] = 0.0 
dRate[6]  = dw_Jogun.GetItemNumber(1, 'rate_6')
if isNull(dRate[6]) then dRate[6] = 0.0 
dRate[7]  = dw_Jogun.GetItemNumber(1, 'rate_7')
if isNull(dRate[7]) then dRate[7] = 0.0 
dRate[8]  = dw_Jogun.GetItemNumber(1, 'rate_8')
if isNull(dRate[8]) then dRate[8] = 0.0 
dRate[9]  = dw_Jogun.GetItemNumber(1, 'rate_9')
if isNull(dRate[9]) then dRate[9] = 0.0 
dRate[10] = dw_Jogun.GetItemNumber(1, 'rate_10')
if isNull(dRate[10]) then dRate[10] = 0.0 
dRate[11] = dw_Jogun.GetItemNumber(1, 'rate_11')
if isNull(dRate[11]) then dRate[11] = 0.0 
dRate[12] = dw_Jogun.GetItemNumber(1, 'rate_12')
if isNull(dRate[12]) then dRate[12] = 0.0 

//*******************************************************************//
//*** 판매 실적 예상 테이블 당해년도 데이타 삭제                  ***//
//*******************************************************************//
w_mdi_frame.sle_msg.Text = '판매 실적 예상 테이블 당해년도 데이타 삭제중...'

For i = 1 to 12
	sTemp = sYear + String(i,'00')
	Delete From salesumplan a 
	 Where a.sabu = :gs_sabu and a.sales_yymm = :sTemp
	   And a.itnbr In ( Select itnbr From itemas b, itnct c
		 						Where b.itnbr = a.itnbr
								  And b.ittyp = c.ittyp
								  And b.itcls = c.itcls And c.porgu Like :sSaupj);
	
	If SQLCA.SqlCode < 0 then
		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		f_Message_Chk(31, '[판매실적 예상테이블 삭제]')
		Rollback;
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''
		return
	Else
		commit;
	End if
Next			

//*******************************************************************//
//*** 판매실적 테이블에서 당해년도 실적을 예상 테이블에 복사      ***//
//*******************************************************************//
w_mdi_frame.sle_msg.Text = '판매실적 테이블에서 당해년도 실적을 예상 테이블에 복사중...'
If sMonth > '01' Then
	sFrYymm = sYear + '01'
	sToYymm = sYear + String(iMonth - 1,'00')

	For i = 1 To iMonth
		sToYymm = sYear + String(i,'00')
		
		Insert Into salesumplan
			Select A.sabu, A.sales_yymm, A.cvcod, A.itnbr, nvl(A.sales_qty,0),
					 nvl(A.sales_amt,0), nvl(A.sales_amt_usd,0)
		 	  From salesum_ypln_view A, itemas b, itnct c
			 Where (A.sabu = :gs_sabu) and
					 (A.sales_yymm = :sToYymm ) and
					 (a.itnbr = b.itnbr And b.ittyp = c.ittyp And b.itcls = c.itcls And c.porgu Like :sSaupj) ;
		
		if SQLCA.SqlCode < 0 then
			messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			f_message_Chk(32, '[판매 실적 => 판매실적 예상테이블]')
			Rollback;
			SetPointer(Arrow!)
			w_mdi_frame.sle_msg.Text = ''	
			return
		else
			commit;
		end if
	Next
End If
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
w_mdi_frame.sle_msg.Text = '당해년도 미판매 월 실적 계산 생성중...'

If rb_1.checked then
	sgubun = '1'
Else
	sgubun = '2'
end if


For i = iMonth to 12
	sYYMM = sYear + Mid('0'+string(i), Len(string(i)), 2)
	SQLCA.ERP000000530(gs_sabu, sYear, sYYMM, dRate[i], sgubun, ssaupj)
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	End If
Next

w_mdi_frame.sle_msg.Text = ''		
f_Message_Chk(202, '[판매실적예상 생성]')

ib_any_typing = False
dw_Jogun.SetColumn("sales_yy")
dw_Jogun.SetFocus()


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_01000
end type

type p_can from w_inherite`p_can within w_sal_01000
boolean visible = false
integer x = 4110
integer y = 2692
end type

type p_print from w_inherite`p_print within w_sal_01000
boolean visible = false
integer x = 2894
integer y = 2692
end type

type p_inq from w_inherite`p_inq within w_sal_01000
integer x = 3785
end type

event p_inq::clicked;call super::clicked;String sYear, sMM, sNull, saupj
Long   nCnt
Double sale_amt01 = 0, sale_amt02 = 0, sale_amt03 = 0, sale_amt04 = 0, &
       sale_amt05 = 0, sale_amt06 = 0, sale_amt07 = 0, sale_amt08 = 0, &
	    sale_amt09 = 0, sale_amt10 = 0, sale_amt11 = 0, sale_amt12 = 0		 

If dw_jogun.AcceptText() <> 1 Then Return

sMM   = Trim(dw_jogun.GetItemString(1,'sales_mm'))
saupj = Trim(dw_jogun.GetItemString(1,'saupj'))

If IsNull(sMM) or sMM = '' then
	f_Message_Chk(35, '[수립월]')
	dw_jogun.SetItem(1, "sales_mm", sNull)
	return 1
end if

SetPointer(HourGlass!)	

/* 기등록자료 확인 */
sYear = Trim(dw_jogun.GetItemString(1,'sales_yy'))
If IsNull(sYear) or sYear = '' Then
	f_message_chk(35,'[수립년도]')
	dw_jogun.SetItem(1, "sales_mm", sNull)
	return 1
End If

select count(*) into :nCnt 
  from salesumplan a, itemas b, itnct c
 where a.sabu  = :gs_sabu and a.sales_yymm like :sYear||'%'
 	and a.itnbr = b.itnbr
	and b.ittyp = c.ittyp
	and b.itcls = c.itcls
	and c.porgu Like :saupj;
If nCnt <= 0 Then
	f_message_chk(50,'')
	Return 
End If

w_mdi_frame.sle_msg.Text = '해당 월까지의 기등록자료 추출중...'

//*****************************************************************************
Select nvl(sum(Decode(a.sales_yymm, :is_yy01, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy02, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy03, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy04, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy05, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy06, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy07, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy08, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy09, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy10, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy11, nvl(a.sales_amt,0))),0),
		 nvl(sum(Decode(a.sales_yymm, :is_yy12, nvl(a.sales_amt,0))),0)
	Into :sale_amt01, :sale_amt02, :sale_amt03, :sale_amt04, :sale_amt05, :sale_amt06, 
		 :sale_amt07, :sale_amt08, :sale_amt09, :sale_amt10, :sale_amt11, :sale_amt12
  From salesumplan a, itemas b, itnct c
 Where a.sabu = :gs_sabu 
	and a.sales_yymm >= :is_year||'01' and a.sales_yymm <= :is_year||'12'
	and a.itnbr = b.itnbr
	and b.ittyp = c.ittyp
	and b.itcls = c.itcls
	and c.porgu Like :saupj;
//*****************************************************************************									 
dw_jogun.SetItem(1, 'sale_1',  sale_amt01)
dw_jogun.SetItem(1, 'sale_2',  sale_amt02)
dw_jogun.SetItem(1, 'sale_3',  sale_amt03)
dw_jogun.SetItem(1, 'sale_4',  sale_amt04)		
dw_jogun.SetItem(1, 'sale_5',  sale_amt05)
dw_jogun.SetItem(1, 'sale_6',  sale_amt06)
dw_jogun.SetItem(1, 'sale_7',  sale_amt07)
dw_jogun.SetItem(1, 'sale_8',  sale_amt08)
dw_jogun.SetItem(1, 'sale_9',  sale_amt09)
dw_jogun.SetItem(1, 'sale_10', sale_amt10)
dw_jogun.SetItem(1, 'sale_11', sale_amt11)
dw_jogun.SetItem(1, 'sale_12', sale_amt12)

SetPointer(Arrow!)
w_mdi_frame.sle_msg.Text = ''

end event

type p_del from w_inherite`p_del within w_sal_01000
boolean visible = false
integer x = 3936
integer y = 2692
end type

type p_mod from w_inherite`p_mod within w_sal_01000
boolean visible = false
integer x = 3762
integer y = 2692
end type

type cb_exit from w_inherite`cb_exit within w_sal_01000
integer x = 3177
integer y = 2640
integer height = 120
integer taborder = 130
end type

type cb_mod from w_inherite`cb_mod within w_sal_01000
integer x = 649
integer y = 2612
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_sal_01000
integer x = 3995
integer y = 2868
integer width = 443
integer height = 120
integer taborder = 50
string text = "생성처리(&G)"
end type

event cb_ins::clicked;call super::clicked;//Integer i, iMonth
//String  sYear, sMonth, sYYMM, sSalesYYMM, sFrYymm, sToYymm, sTemp
//Long    lPlanQty, lWonSrc, lSalesQty, lSalesAmt
//Dec     dRate[12], dDcRate, dActRate
//
//If dw_Jogun.AcceptText() <> 1 Then Return
//
//sYear   = dw_Jogun.GetItemString(1, 'sales_yy')
//sMonth  = dw_Jogun.GetItemString(1, 'sales_mm')
//iMonth  = Integer(sMonth)
//
//if MessageBox("확 인", sYear + '년도 ' + sMonth + '월 이후 미판매분 예상실적을 생성합니다.' + '~r~r' + &
//                       '미판매 월별 가중치를 입력했는지 확인하세요' + '~r~r' + &
//							  '미판매월 예상 판매실적을 생성 하시겠습니까?', + &
//							  question!,yesno!, 2) = 2 THEN 
//	Return
//end if
//
//SetPointer(HourGlass!)
//
///* 적용품번 저장 (대표품번 생성 및 일반 품번 생성)*/
//If cbx_chk.Checked = True Then
//	UPDATE ITEM_REL
//		SET ITNBRMD = ITNBRYD;
//Else
//	UPDATE ITEM_REL
//		SET ITNBRMD = ITNBR;
//End If
//
//If SQLCA.SqlCode <> 0 then
//	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	Rollback;
//	return
//Else
//	Commit;
//End If
//		
//dRate[1]  = dw_Jogun.GetItemNumber(1, 'rate_1')
//if isNull(dRate[1]) then dRate[1] = 0.0 
//dRate[2]  = dw_Jogun.GetItemNumber(1, 'rate_2')
//if isNull(dRate[2]) then dRate[2] = 0.0 
//dRate[3]  = dw_Jogun.GetItemNumber(1, 'rate_3')
//if isNull(dRate[3]) then dRate[3] = 0.0 
//dRate[4]  = dw_Jogun.GetItemNumber(1, 'rate_4')
//if isNull(dRate[4]) then dRate[4] = 0.0 
//dRate[5]  = dw_Jogun.GetItemNumber(1, 'rate_5')
//if isNull(dRate[5]) then dRate[5] = 0.0 
//dRate[6]  = dw_Jogun.GetItemNumber(1, 'rate_6')
//if isNull(dRate[6]) then dRate[6] = 0.0 
//dRate[7]  = dw_Jogun.GetItemNumber(1, 'rate_7')
//if isNull(dRate[7]) then dRate[7] = 0.0 
//dRate[8]  = dw_Jogun.GetItemNumber(1, 'rate_8')
//if isNull(dRate[8]) then dRate[8] = 0.0 
//dRate[9]  = dw_Jogun.GetItemNumber(1, 'rate_9')
//if isNull(dRate[9]) then dRate[9] = 0.0 
//dRate[10] = dw_Jogun.GetItemNumber(1, 'rate_10')
//if isNull(dRate[10]) then dRate[10] = 0.0 
//dRate[11] = dw_Jogun.GetItemNumber(1, 'rate_11')
//if isNull(dRate[11]) then dRate[11] = 0.0 
//dRate[12] = dw_Jogun.GetItemNumber(1, 'rate_12')
//if isNull(dRate[12]) then dRate[12] = 0.0 
//
////*******************************************************************//
////*** 판매 실적 예상 테이블 당해년도 데이타 삭제                  ***//
////*******************************************************************//
//w_mdi_frame.sle_msg.Text = '판매 실적 예상 테이블 당해년도 데이타 삭제중...'
//
//For i = 1 to 12
//	sTemp = sYear + String(i,'00')
//	Delete From salesumplan Where sabu = :gs_sabu and sales_yymm = :sTemp;
//	
//	If SQLCA.SqlCode < 0 then
//		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//		f_Message_Chk(31, '[판매실적 예상테이블 삭제]')
//		Rollback;
//		SetPointer(Arrow!)
//		w_mdi_frame.sle_msg.Text = ''
//		return
//	Else
//		commit;
//	End if
//Next			
//
////*******************************************************************//
////*** 판매실적 테이블에서 당해년도 실적을 예상 테이블에 복사      ***//
////*******************************************************************//
//w_mdi_frame.sle_msg.Text = '판매실적 테이블에서 당해년도 실적을 예상 테이블에 복사중...'
//If sMonth > '01' Then
//	sFrYymm = sYear + '01'
//	sToYymm = sYear + String(iMonth - 1,'00')
//
//	For i = 1 To iMonth
//		sToYymm = sYear + String(i,'00')
//		
//		Insert Into salesumplan
//			Select A.sabu, A.sales_yymm, A.cvcod, A.itnbr, nvl(A.sales_qty,0),
//					 nvl(A.sales_amt,0), nvl(A.sales_amt_usd,0)
//		 	  From salesum_ypln_view A
//			 Where (A.sabu = :gs_sabu) and
//					 (A.sales_yymm = :sToYymm );
//		
//		if SQLCA.SqlCode < 0 then
//			messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//			f_message_Chk(32, '[판매 실적 => 판매실적 예상테이블]')
//			Rollback;
//			SetPointer(Arrow!)
//			w_mdi_frame.sle_msg.Text = ''	
//			return
//		else
//			commit;
//		end if
//	Next
//End If
////+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//w_mdi_frame.sle_msg.Text = '당해년도 미판매 월 실적 계산 생성중...'
//
//For i = iMonth to 12
//	sYYMM = sYear + Mid('0'+string(i), Len(string(i)), 2)
//	SQLCA.ERP000000530(gs_sabu, sYear, sYYMM, dRate[i])
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	End If
//Next
//
//w_mdi_frame.sle_msg.Text = ''		
//f_Message_Chk(202, '[판매실적예상 생성]')
//
//ib_any_typing = False
//dw_Jogun.SetColumn("sales_yy")
//dw_Jogun.SetFocus()
//
//
end event

type cb_del from w_inherite`cb_del within w_sal_01000
integer x = 1015
integer y = 2612
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_sal_01000
integer x = 206
integer y = 2640
integer taborder = 90
boolean enabled = false
end type

event cb_inq::clicked;call super::clicked;//String sYear, sMM, sNull
//Long   nCnt
//Double sale_amt01 = 0, sale_amt02 = 0, sale_amt03 = 0, sale_amt04 = 0, &
//       sale_amt05 = 0, sale_amt06 = 0, sale_amt07 = 0, sale_amt08 = 0, &
//	    sale_amt09 = 0, sale_amt10 = 0, sale_amt11 = 0, sale_amt12 = 0		 
//
//If dw_jogun.AcceptText() <> 1 Then Return
//
//sMM = Trim(dw_jogun.GetItemString(1,'sales_mm'))
//
//If IsNull(sMM) or sMM = '' then
//	f_Message_Chk(35, '[수립월]')
//	dw_jogun.SetItem(1, "sales_mm", sNull)
//	return 1
//end if
//
//SetPointer(HourGlass!)	
//
///* 기등록자료 확인 */
//sYear = Trim(dw_jogun.GetItemString(1,'sales_yy'))
//If IsNull(sYear) or sYear = '' Then
//	f_message_chk(35,'[수립년도]')
//	dw_jogun.SetItem(1, "sales_mm", sNull)
//	return 1
//End If
//
//select count(*) into :nCnt 
//  from salesumplan 
// where sabu = :gs_sabu and sales_yymm like :sYear||'%';
//If nCnt <= 0 Then
//	f_message_chk(50,'')
//	Return 
//End If
//
//sle_msg.Text = '해당 월까지의 기등록자료 추출중...'
//
////*****************************************************************************
//Select nvl(sum(Decode(sales_yymm, :is_yy01, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy02, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy03, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy04, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy05, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy06, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy07, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy08, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy09, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy10, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy11, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy12, nvl(sales_amt,0))),0)
//	Into :sale_amt01, :sale_amt02, :sale_amt03, :sale_amt04, :sale_amt05, :sale_amt06, 
//		 :sale_amt07, :sale_amt08, :sale_amt09, :sale_amt10, :sale_amt11, :sale_amt12
//  From salesumplan
// Where sabu = :gs_sabu and
//		 sales_yymm >= :is_year||'01' and sales_yymm <= :is_year||'12';
////*****************************************************************************									 
//dw_jogun.SetItem(1, 'sale_1',  sale_amt01)
//dw_jogun.SetItem(1, 'sale_2',  sale_amt02)
//dw_jogun.SetItem(1, 'sale_3',  sale_amt03)
//dw_jogun.SetItem(1, 'sale_4',  sale_amt04)		
//dw_jogun.SetItem(1, 'sale_5',  sale_amt05)
//dw_jogun.SetItem(1, 'sale_6',  sale_amt06)
//dw_jogun.SetItem(1, 'sale_7',  sale_amt07)
//dw_jogun.SetItem(1, 'sale_8',  sale_amt08)
//dw_jogun.SetItem(1, 'sale_9',  sale_amt09)
//dw_jogun.SetItem(1, 'sale_10', sale_amt10)
//dw_jogun.SetItem(1, 'sale_11', sale_amt11)
//dw_jogun.SetItem(1, 'sale_12', sale_amt12)
//
//SetPointer(Arrow!)
//sle_msg.Text = ''
//
end event

type cb_print from w_inherite`cb_print within w_sal_01000
integer y = 2612
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_sal_01000
end type

type cb_can from w_inherite`cb_can within w_sal_01000
integer x = 2112
integer y = 2612
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_sal_01000
integer x = 3360
integer y = 2876
integer width = 635
integer taborder = 120
boolean enabled = false
string text = "판매실적추출(&W)"
end type

event cb_search::clicked;call super::clicked;//String sYear, sMM, sNull
//Long   nCnt
//Double sale_amt01 = 0, sale_amt02 = 0, sale_amt03 = 0, sale_amt04 = 0, &
//       sale_amt05 = 0, sale_amt06 = 0, sale_amt07 = 0, sale_amt08 = 0, &
//	    sale_amt09 = 0, sale_amt10 = 0, sale_amt11 = 0, sale_amt12 = 0		 
//Int    ix
//
//If dw_jogun.AcceptText() <> 1 Then Return
//
//sMM = Trim(dw_jogun.GetItemString(1,'sales_mm'))
//
//If IsNull(sMM) or sMM = '' then
//	f_Message_Chk(35, '[수립월]')
//	dw_jogun.SetItem(1, "sales_mm", sNull)
//	return 1
//end if
//
///* 판매실적 추출은 수립년월 이전 */
//sMM = String(Integer(sMM) - 1,'00')
//
//SetPointer(HourGlass!)	
//
///* 기등록자료 확인 */
//sYear = Trim(dw_jogun.GetItemString(1,'sales_yy'))
//If IsNull(sYear) or sYear = '' Then
//	f_message_chk(35,'[수립년도]')
//	dw_jogun.SetItem(1, "sales_mm", sNull)
//	return 1
//End If
//
//select count(*) into :nCnt 
//  from salesumplan 
// where sabu = :gs_sabu and sales_yymm like :sYear||'%';
//If nCnt > 0 Then
//	If MessageBox('확 인','기존에 등록된 자료가 있습니다~r~n~r~n계속할까요?',Question!,YesNo!,2) = 2 Then Return
//End If
//
//w_mdi_frame.sle_msg.Text = '해당 월까지의 판매 실적 추출중...'
//
////*****************************************************************************
//Select nvl(sum(Decode(sales_yymm, :is_yy01, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy02, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy03, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy04, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy05, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy06, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy07, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy08, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy09, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy10, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy11, nvl(sales_amt,0))),0),
//		 nvl(sum(Decode(sales_yymm, :is_yy12, nvl(sales_amt,0))),0)
//	Into :sale_amt01, :sale_amt02, :sale_amt03, :sale_amt04, :sale_amt05, :sale_amt06, 
//		 :sale_amt07, :sale_amt08, :sale_amt09, :sale_amt10, :sale_amt11, :sale_amt12
//  From salesum
// Where sabu = :gs_sabu and
//		 sales_yymm >= :sYear||'01' and sales_yymm <= :sYear||:sMM;
//
//dw_jogun.SetItem(1, 'sale_1',  sale_amt01)
//dw_jogun.SetItem(1, 'sale_2',  sale_amt02)
//dw_jogun.SetItem(1, 'sale_3',  sale_amt03)
//dw_jogun.SetItem(1, 'sale_4',  sale_amt04)		
//dw_jogun.SetItem(1, 'sale_5',  sale_amt05)
//dw_jogun.SetItem(1, 'sale_6',  sale_amt06)
//dw_jogun.SetItem(1, 'sale_7',  sale_amt07)
//dw_jogun.SetItem(1, 'sale_8',  sale_amt08)
//dw_jogun.SetItem(1, 'sale_9',  sale_amt09)
//dw_jogun.SetItem(1, 'sale_10', sale_amt10)
//dw_jogun.SetItem(1, 'sale_11', sale_amt11)
//dw_jogun.SetItem(1, 'sale_12', sale_amt12)
//
///* 수립년월 이후는 계획금액 */
//For ix = Integer(sMM) + 1 To 12
//	dw_jogun.SetItem(1, 'sale_'+string(ix), dw_jogun.GetItemNumber(1,'plan_'+string(ix)))
//Next
//
end event







type gb_button1 from w_inherite`gb_button1 within w_sal_01000
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01000
end type

type st_2 from statictext within w_sal_01000
integer x = 631
integer y = 1908
integer width = 1170
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "* 판매계획(장기,년간)을 수립하기 위해,"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_01000
integer x = 631
integer y = 2016
integer width = 2162
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "* 수립월을 기준으로 수립월을 포함한 이후 12월까지의 년간판매계획 수량에 "
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_01000
integer x = 2770
integer y = 2016
integer width = 1202
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "가중치를 적용하여 예상 판매실적으로 생성"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sal_01000
integer x = 690
integer y = 2120
integer width = 2752
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "생성된 예상판매실적은 장기 및 년간판매계획 수립의 전년도 실적DATA로 사용된다."
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sal_01000
boolean visible = false
integer x = 133
integer y = 2576
integer width = 1152
integer height = 212
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_sal_01000
boolean visible = false
integer x = 2674
integer y = 2576
integer width = 869
integer height = 212
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type st_10 from statictext within w_sal_01000
integer x = 1783
integer y = 1904
integer width = 2162
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "수립년도의 미판매 월에 대한 예상 판매실적과 년마감 예상금액 자료를 생성"
boolean focusrectangle = false
end type

type st_11 from statictext within w_sal_01000
integer x = 585
integer y = 1888
integer width = 50
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "*"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_sal_01000
integer x = 2862
integer y = 188
integer width = 718
integer height = 180
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "[작업구분]"
end type

type dw_jogun from u_key_enter within w_sal_01000
integer x = 571
integer y = 168
integer width = 3109
integer height = 1688
integer taborder = 40
string dataobject = "d_sal_01000_01"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sCol_Name, sNull, mm_chk, sToday, sYear,sMm, sSaupj

Double plan_amt01 = 0, plan_amt02 = 0, plan_amt03 = 0, plan_amt04 = 0, &
       plan_amt05 = 0, plan_amt06 = 0, plan_amt07 = 0, plan_amt08 = 0, &
	   plan_amt09 = 0, plan_amt10 = 0, plan_amt11 = 0, plan_amt12 = 0
	   
Dec    dRate, sale_amt
Long   nCnt
Integer imm

sCol_Name = GetColumnName()
SetNull(sNull)
stoday = f_today()

Choose Case sCol_Name
   // 수립년도 유효성 Check
	Case "sales_yy"  
		if (Not(isNumber(Trim(getText())))) or (Len(Trim(getText())) <> 4) then
			f_Message_Chk(35, '[수립년도]')
			SetItem(1, "sales_yy", sNull)
			return 1
		end if
		
		w_mdi_frame.sle_msg.Text = '해당 수립년도의 월별 판매계획 추출중...'
		
		dw_jogun.SetRedraw(False)
		
		SetPointer(HourGlass!)
		sYear = Trim(GetText())
		is_year = sYear
      is_yy01 = sYear + '01'
      is_yy02 = sYear + '02'
      is_yy03 = sYear + '03'
      is_yy04 = sYear + '04'
      is_yy05 = sYear + '05'
      is_yy06 = sYear + '06'
      is_yy07 = sYear + '07'
      is_yy08 = sYear + '08'
      is_yy09 = sYear + '09'
      is_yy10 = sYear + '10'
      is_yy11 = sYear + '11'
      is_yy12 = sYear + '12'	
		
		ssaupj = getitemstring(1, "saupj")
		
      //*****************************************************************************
      // 월별 년간 판매계획을 추출
      //*****************************************************************************
      Select nvl(sum(Decode(a.plan_yymm, :is_yy01, nvl(a.plan_amt,0))),0),
             nvl(sum(Decode(a.plan_yymm, :is_yy02, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy03, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy04, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy05, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy06, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy07, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy08, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy09, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy10, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy11, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy12, nvl(a.plan_amt,0))),0)
      Into   :plan_amt01, :plan_amt02, :plan_amt03, :plan_amt04, :plan_amt05, :plan_amt06, 
             :plan_amt07, :plan_amt08, :plan_amt09, :plan_amt10, :plan_amt11, :plan_amt12
      From   yearsaplan a, itemas c, itnct d
      Where  a.sabu = :gs_sabu and
			    a.plan_yymm like :sYear||'%' and
             a.plan_chasu = (Select Max(a.plan_chasu) From yphead b
		                        Where b.sabu = :gs_sabu and b.plan_year Like :sYear||'%')
		  And  a.itnbr = c.itnbr and c.ittyp = d.ittyp and c.itcls = d.itcls and d.porgu Like :sSaupj;

      //*****************************************************************************
		
      dw_jogun.SetItem(1, 'plan_1',  plan_amt01)
      dw_jogun.SetItem(1, 'plan_2',  plan_amt02)
      dw_jogun.SetItem(1, 'plan_3',  plan_amt03)
      dw_jogun.SetItem(1, 'plan_4',  plan_amt04)		
      dw_jogun.SetItem(1, 'plan_5',  plan_amt05)
      dw_jogun.SetItem(1, 'plan_6',  plan_amt06)
      dw_jogun.SetItem(1, 'plan_7',  plan_amt07)
      dw_jogun.SetItem(1, 'plan_8',  plan_amt08)
      dw_jogun.SetItem(1, 'plan_9',  plan_amt09)
      dw_jogun.SetItem(1, 'plan_10', plan_amt10)
      dw_jogun.SetItem(1, 'plan_11', plan_amt11)
      dw_jogun.SetItem(1, 'plan_12', plan_amt12)		
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''

		dw_jogun.SetItem(1,'sales_mm', sNull)
		p_search.Enabled = False
		p_search.PictureName = 'C:\erpman\image\판매실적추출_up.gif'
		
		dw_jogun.SetRedraw(True)
   // 사업장 check
	Case "saupj"
		ssaupj = gettext()
		syear = getitemstring(1, "sales_yy")
		if (Not(isNumber(Trim(syear)))) or (Len(Trim(syear)) <> 4) then
			f_Message_Chk(35, '[수립년도]')
			SetItem(1, "sales_yy", sNull)
			return 1
		end if
		
		w_mdi_frame.sle_msg.Text = '해당 수립년도의 월별 판매계획 추출중...'
		
		dw_jogun.SetRedraw(False)
		
		SetPointer(HourGlass!)
		is_year = sYear
      is_yy01 = sYear + '01'
      is_yy02 = sYear + '02'
      is_yy03 = sYear + '03'
      is_yy04 = sYear + '04'
      is_yy05 = sYear + '05'
      is_yy06 = sYear + '06'
      is_yy07 = sYear + '07'
      is_yy08 = sYear + '08'
      is_yy09 = sYear + '09'
      is_yy10 = sYear + '10'
      is_yy11 = sYear + '11'
      is_yy12 = sYear + '12'	
		
      //*****************************************************************************
      // 월별 년간 판매계획을 추출
      //*****************************************************************************
      Select nvl(sum(Decode(a.plan_yymm, :is_yy01, nvl(a.plan_amt,0))),0),
             nvl(sum(Decode(a.plan_yymm, :is_yy02, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy03, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy04, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy05, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy06, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy07, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy08, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy09, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy10, nvl(a.plan_amt,0))),0),
      		 nvl(sum(Decode(a.plan_yymm, :is_yy11, nvl(a.plan_amt,0))),0),
		       nvl(sum(Decode(a.plan_yymm, :is_yy12, nvl(a.plan_amt,0))),0)
      Into   :plan_amt01, :plan_amt02, :plan_amt03, :plan_amt04, :plan_amt05, :plan_amt06, 
             :plan_amt07, :plan_amt08, :plan_amt09, :plan_amt10, :plan_amt11, :plan_amt12
      From   yearsaplan a, itemas c, itnct d
      Where  a.sabu = :gs_sabu and
			    a.plan_yymm like :sYear||'%' and
             a.plan_chasu = (Select Max(a.plan_chasu) From yphead b
		                        Where b.sabu = :gs_sabu and b.plan_year Like :sYear||'%')
		  And  a.itnbr = c.itnbr and c.ittyp = d.ittyp and c.itcls = d.itcls and d.porgu Like :sSaupj;

      //*****************************************************************************
		
      dw_jogun.SetItem(1, 'plan_1',  plan_amt01)
      dw_jogun.SetItem(1, 'plan_2',  plan_amt02)
      dw_jogun.SetItem(1, 'plan_3',  plan_amt03)
      dw_jogun.SetItem(1, 'plan_4',  plan_amt04)		
      dw_jogun.SetItem(1, 'plan_5',  plan_amt05)
      dw_jogun.SetItem(1, 'plan_6',  plan_amt06)
      dw_jogun.SetItem(1, 'plan_7',  plan_amt07)
      dw_jogun.SetItem(1, 'plan_8',  plan_amt08)
      dw_jogun.SetItem(1, 'plan_9',  plan_amt09)
      dw_jogun.SetItem(1, 'plan_10', plan_amt10)
      dw_jogun.SetItem(1, 'plan_11', plan_amt11)
      dw_jogun.SetItem(1, 'plan_12', plan_amt12)		
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''

		dw_jogun.SetItem(1,'sales_mm', sNull)
		p_search.Enabled = False
		p_search.PictureName = 'C:\erpman\image\판매실적추출_up.gif'
		
		dw_jogun.SetRedraw(True)		
	// 기준월 유효성 Check
   Case "sales_mm"
		sMM = Trim(GetText())
		
		If sMM > '12' or IsNull(sMM) or sMM = '' or sMM = '0' Or sMM = '00' Then
			f_Message_Chk(35, '[수립년월]')
			SetItem(1, "sales_mm", sNull)
			return 1
		End If
		
		sMM = String(Integer(sMM),'00')
		If sMM = '' Or IsNull(sMM) Then
			p_search.Enabled = False
			p_search.PictureName = 'C:\erpman\image\판매실적추출_up.gif'
		Else
			p_search.Enabled = True
			p_search.PictureName = 'C:\erpman\image\판매실적추출_up.gif'
		End If
		
		SetItem(1,'sales_mm',smm)
		Return 1
   //  가중치 부여 숫자 CHECK 
	Case "rate_1" ,"rate_2" ,"rate_3" ,"rate_4" ,"rate_5" ,"rate_6" , &
		   "rate_7" ,"rate_8" ,"rate_9"  ,"rate_10" ,"rate_11" ,"rate_12"
		if Not(isNumber(Trim(getText()))) then
			f_Message_Chk(201, '[가중치]')
			SetItem(1, GetColumnName(), 0)
			return 1
		end if
		
		dRate = Dec(Trim(getText()))
		SetPointer(Hourglass!)

	   /* 검색년월 */
		sMm = is_year + String(Integer(Mid(GetColumnName(),6)),'00')
		ssaupj = getitemstring(1, "saupj")		

		/* 수량에 증감율을 적용한후 단가적용=> sum(변경수량 * 단가 = 실적예상금액) */
		If rb_1.checked then
		  select sum(round(a.plan_qty * (1 + :dRate / 100),0) * fun_erp100000012(:sToday, a.itnbr, '.')) as amt
				into :sale_amt
			 From yearsaplan a, itemas b, itnct c
			Where a.sabu = :gs_sabu and a.plan_yymm = :sMm and
					a.plan_chasu = (Select Max(plan_chasu) From yphead
										  Where  sabu = :gs_sabu and plan_year = :is_Year) 
			  And a.itnbr = b.itnbr and b.ittyp = c.ittyp and b.itcls = c.itcls and c.porgu Like :sSaupj;
		Else
		  select sum(round(a.plan_amt * (1 + :dRate / 100),0)) as amt
				into :sale_amt
			 From yearsaplan a, itemas b, itnct c
			Where a.sabu = :gs_sabu and a.plan_yymm = :sMm and
					a.plan_chasu = (Select Max(plan_chasu) From yphead
										  Where  sabu = :gs_sabu and plan_year = :is_Year) 
			  And a.itnbr = b.itnbr and b.ittyp = c.ittyp and b.itcls = c.itcls and c.porgu Like :sSaupj;			
			
		End if

		if isNull(sale_amt) then 
			sale_amt = 0
		end if
		
		/* 실적금액에 설정 */
		SetItem(1, 'sale_'+ Mid(GetColumnName(),6), sale_amt)
		SetPointer(Arrow!)		
End Choose

end event

event itemerror;Return 1
end event

type rb_new from radiobutton within w_sal_01000
integer x = 2944
integer y = 264
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "신규"
boolean checked = true
end type

event clicked;String sChk

/* 조회 가능 */
p_inq.Enabled = False
p_inq.pictureName = "C:\erpman\image\조회_d.gif"

dw_Jogun.SetRedraw(False)
dw_Jogun.Reset()
dw_Jogun.Insertrow(0)
dw_Jogun.SetRedraw(True)

w_mdi_frame.sle_msg.Text = '판매계획 수립년도 및 월과 가중치를 입력하세요'

dw_Jogun.SetColumn("sales_yy")
dw_jogun.SetFocus()

sChk = f_get_syscnfg('S',1,'80')
If sChk = 'Y' Then
	cbx_chk.Checked = True
Else
	cbx_chk.Checked = False
End If


// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')
end event

type rb_update from radiobutton within w_sal_01000
integer x = 3246
integer y = 264
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "수정"
end type

event clicked;/* 조회 가능 */
p_inq.Enabled = True
p_inq.pictureName = "C:\erpman\image\조회_up.gif"

dw_Jogun.SetRedraw(False)
dw_Jogun.Reset()
dw_Jogun.Insertrow(0)
dw_Jogun.SetRedraw(True)

w_mdi_frame.sle_msg.Text = '판매계획 수립년도 및 월과 가중치를 입력하세요'

dw_Jogun.SetColumn("sales_yy")
dw_jogun.SetFocus()


// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')
end event

type cbx_chk from checkbox within w_sal_01000
integer x = 2830
integer y = 468
integer width = 82
integer height = 76
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
end type

type st_7 from statictext within w_sal_01000
integer x = 2903
integer y = 480
integer width = 558
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
string text = "대표품번 적용 여부"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_sal_01000
integer x = 3730
integer y = 336
integer width = 814
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "예상실적금액 * 증감율 적용"
end type

type rb_1 from radiobutton within w_sal_01000
integer x = 3730
integer y = 268
integer width = 896
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "수량 * 증감율 * 현재단가 적용"
boolean checked = true
end type

type rr_1 from roundrectangle within w_sal_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3707
integer y = 252
integer width = 937
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

