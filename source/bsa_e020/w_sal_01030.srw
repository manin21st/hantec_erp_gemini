$PBExportHeader$w_sal_01030.srw
$PBExportComments$ ===> 년간 판매 계획 제품별 증감율 등록 및 생성
forward
global type w_sal_01030 from w_inherite
end type
type gb_5 from groupbox within w_sal_01030
end type
type gb_6 from groupbox within w_sal_01030
end type
type tab_1 from tab within w_sal_01030
end type
type tab1 from userobject within tab_1
end type
type dw_insert1 from u_key_enter within tab1
end type
type rr_5 from roundrectangle within tab1
end type
type tab1 from userobject within tab_1
dw_insert1 dw_insert1
rr_5 rr_5
end type
type tab4 from userobject within tab_1
end type
type dw_insert4 from datawindow within tab4
end type
type rr_4 from roundrectangle within tab4
end type
type tab4 from userobject within tab_1
dw_insert4 dw_insert4
rr_4 rr_4
end type
type tab2 from userobject within tab_1
end type
type dw_insert2 from u_key_enter within tab2
end type
type rr_3 from roundrectangle within tab2
end type
type tab2 from userobject within tab_1
dw_insert2 dw_insert2
rr_3 rr_3
end type
type tab3 from userobject within tab_1
end type
type cbx_2 from checkbox within tab3
end type
type dw_insert3 from u_key_enter within tab3
end type
type dw_jogun from datawindow within tab3
end type
type rr_2 from roundrectangle within tab3
end type
type tab3 from userobject within tab_1
cbx_2 cbx_2
dw_insert3 dw_insert3
dw_jogun dw_jogun
rr_2 rr_2
end type
type tab_1 from tab within w_sal_01030
tab1 tab1
tab4 tab4
tab2 tab2
tab3 tab3
end type
type rb_1 from radiobutton within w_sal_01030
end type
type rb_2 from radiobutton within w_sal_01030
end type
type dw_ip from datawindow within w_sal_01030
end type
type st_2 from statictext within w_sal_01030
end type
type rr_1 from roundrectangle within w_sal_01030
end type
end forward

global type w_sal_01030 from w_inherite
string title = "년간 판매계획 제품별 증감율 등록 및 생성"
gb_5 gb_5
gb_6 gb_6
tab_1 tab_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
st_2 st_2
rr_1 rr_1
end type
global w_sal_01030 w_sal_01030

type variables
string is_year, &
         is_year_1, &
         is_year_2, &
         is_year_3, &
         is_year_4, &
         is_year_31, &
         is_year_41, &
         is_tns_mode

end variables

on w_sal_01030.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_6=create gb_6
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_ip
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_01030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : 년간 판매계획 제품별 증감율 등록 및 생성                  ***//
//***  PGM ID   : W_SAL_01030                                               ***//
//***  SUBJECT  : 년간 판매계획 생성을 위해 제품분류의 상위 레벨부터 조정   ***//
//***             하여 하위레벨로 세분화 한다.                              ***//
//***             제품군 증감율 등록(하위일괄생성) => 시리즈 증감율 가감    ***//
//***             조정(제품별 조정생성)=> 제품별 증감율 가감 조정           ***//
//*****************************************************************************//
String sYYmm, sYn

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

tab_1.tab1.dw_insert1.SetTransObject(sqlca)
tab_1.tab2.dw_insert2.SetTransObject(sqlca)
tab_1.tab3.dw_insert3.SetTransObject(sqlca)
tab_1.tab4.dw_insert4.SetTransObject(sqlca)

tab_1.tab3.dw_jogun.SetTransObject(sqlca)
tab_1.tab3.dw_jogun.InsertRow(0)


dw_ip.SetFocus()

setnull(gs_code)


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'sarea')

end event

type dw_insert from w_inherite`dw_insert within w_sal_01030
boolean visible = false
integer x = 937
integer y = 2612
integer width = 270
integer height = 60
integer taborder = 10
end type

type p_delrow from w_inherite`p_delrow within w_sal_01030
boolean visible = false
integer x = 3666
integer y = 2788
end type

type p_addrow from w_inherite`p_addrow within w_sal_01030
boolean visible = false
integer x = 3493
integer y = 2788
end type

type p_search from w_inherite`p_search within w_sal_01030
boolean visible = false
integer x = 2798
integer y = 2788
end type

type p_ins from w_inherite`p_ins within w_sal_01030
integer x = 3931
integer width = 343
string picturename = "C:\erpman\image\년간판매계획생성_up.gif"
end type

event p_ins::clicked;call super::clicked;String sapp_rate, sjyear
Dec    dapp_rate
String sDataGu, sYymm, sarea
int    ichasu

If dw_ip.AcceptText() <> 1 then Return

sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
If f_datechk(sYYmm +'0101') <> 1 Then
	f_message_chk(35,'[계획년도]')
	Return
End If

ichasu = dw_ip.GetItemNumber(1,'chasu')
If IsNull(ichasu) Or ichasu <= 0 Then
	f_message_chk(1400,'[차수]')
	Return
End If

sArea = Trim(dw_ip.GetItemString(1,'sarea'))
If IsNull(sArea) Or Trim(sArea) = '' Then
	f_message_chk(1400,'[사업장]')
	Return
End If

If MessageBox("확 인", '년간 판매계획을 생성합니다.' + '~r~r' + &
							  '저장을 해야 수정분이 적용됩니다.' + '~r~r' + &
							  '년간 판매계획을 일괄 생성 하시겠습니까?', + &
							  question!,YesNo!, 2) = 2 Then Return

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.Text = '년간 판매계획 일괄 생성중 입니다. 잠시 기다려 주세요!!!'

sjyear = String(Integer(sYymm) - 1)

If rb_1.Checked = True Then
	sDataGu = '1'
Else
	sDataGu = '2'
End If

SQLCA.ERP000000501(gs_sabu, syymm, ichasu, sjyear, sArea, sDatagu)

w_mdi_frame.sle_msg.Text = ''
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return
End If

f_message_Chk(202, '[년간 판매계획 생성]')	
tab_1.TriggerEvent(SelectionChanged!)

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\년간판매계획생성_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\년간판매계획생성_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_01030
end type

type p_can from w_inherite`p_can within w_sal_01030
boolean visible = false
integer x = 4187
integer y = 2788
end type

type p_print from w_inherite`p_print within w_sal_01030
boolean visible = false
integer x = 2971
integer y = 2788
end type

type p_inq from w_inherite`p_inq within w_sal_01030
integer x = 3762
end type

event p_inq::clicked;call super::clicked;Integer rtn_v, cnt
String  sItcls, syymm, sArea
int     ichasu

If dw_ip.AcceptText() <> 1 then Return

sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
If f_datechk(sYYmm +'0101') <> 1 Then
	f_message_chk(35,'[계획년도]')
	Return
End If

ichasu = dw_ip.GetItemNumber(1,'chasu')
If IsNull(ichasu) Or ichasu <= 0 Then
	f_message_chk(1400,'[차수]')
	Return
End If

sArea = Trim(dw_ip.GetItemString(1,'sarea'))
If IsNull(sArea) Or trim(sArea) = '' Then
	f_message_chk(1400,'[사업장]')
	Return
End If

/* 수립된 제품군별 증감율 계획이 존재하는지 유무 Check */
Select Count(*) Into :cnt From ypsir
 Where sabu = :gs_sabu and plan_year = :is_year and plan_chasu = :ichasu and sarea like :sarea||'%';
		 
Choose Case tab_1.SelectedTab
	Case 1 // 제품군별 증감율 계획
		If cnt > 0 then
			// 이미 수립되어 있으면
			If MessageBox('Warning', '"' + is_year + '"' + '년의 제품군별 증감율이 이미 수립되어 있습니다. ' + '~n~n' + &
							  '모두 삭제하고 다시 생성하겠습니까?', question!,yesno!, 2) = 2 THEN
				MessageBox('확인', '제품군별 증감율 계획을 조정하세요')
				
				is_tns_mode = 'U'

				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year, ichasu,sArea+'%')
			Else
				SetPointer(HourGlass!)
				
				/* 분류 삭제 */
				DELETE FROM YPSIR
				 WHERE SABU = :gs_sabu AND
				       PLAN_YEAR = :sYYmm AND
						 PLAN_CHASU = :ichasu AND
						 SAREA LIKE :sarea||'%';
				If sqlca.sqlcode <> 0 Then
					RollBack;
					f_message_chk(31,'')
					Return
				End If
				/* 품번 삭제 */
				DELETE FROM YPIIR
				 WHERE SABU = :gs_sabu AND
				       PLAN_YEAR = :sYYmm AND
						 PLAN_CHASU = :ichasu AND
						 SAREA LIKE :sarea||'%';
				If sqlca.sqlcode <> 0 Then
					RollBack;
					f_message_chk(31,'')
					Return
				End If
				
				MessageBox('확인', '제품군별 증감율 계획을 신규 생성하세요')						
				is_tns_mode = 'I'
					
				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
			end if
		else
			MessageBox('확인', '제품군별 증감율 계획을 신규 생성하세요')
			is_tns_mode = 'I'

			rtn_v = tab_1.tab1.dw_Insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
		end if
	/* 중분류 증감율 계획 */
	Case 2
		If cnt <= 0 Then
			rtn_v = -1
		Else
			rtn_v = tab_1.tab4.dw_insert4.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
		End If
	/* 소분류 증감율 계획 */
	Case 3
		If cnt <= 0 Then
			rtn_v = -1
		Else
			rtn_v = tab_1.tab2.dw_insert2.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
		End If
	/* 제품별 증감율 계획 */
	Case 4
		If cnt <= 0 Then
			rtn_v = -1
		Else
			If tab_1.tab3.dw_jogun.AcceptText() <> 1 Then Return
			
			sItcls = tab_1.tab3.dw_jogun.GetItemString(1, 'itcls')
			If sItcls = '' Or isNull(sItcls) Then sItcls = '%'
			sItcls = sItcls + '%'
			
			MessageBox('확인', '제품별 증감율 계획을 조정하세요')
			rtn_v = tab_1.tab3.dw_insert3.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sItcls,ichasu, sArea+'%')
		End If
End Choose		

If rtn_v < 1 Then
	MessageBox('확인', '조정할 기초자료가 존재하지 않습니다.' + '~r~r' + &
	                   '먼저 제품군별 계획을 수립하세요' + '~r' + &
							 '제품군별 계획을 수립해야 기초자료가 생성됩니다')
   tab_1.SelectedTab = 1
	return -1
End If
end event

type p_del from w_inherite`p_del within w_sal_01030
boolean visible = false
integer x = 4014
integer y = 2788
end type

type p_mod from w_inherite`p_mod within w_sal_01030
integer x = 4270
end type

event p_mod::clicked;call super::clicked;Long    i
String  s_ittyp, s_itcls, s_itnbr, syymm, sarea, stitnm
Dec     d_rate
Long    lrow = 0
int     ichasu

If dw_ip.AcceptText() <> 1 then Return

sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
If f_datechk(sYYmm +'0101') <> 1 Then
	f_message_chk(35,'[계획년도]')
	Return
End If

ichasu = dw_ip.GetItemNumber(1,'chasu')
If IsNull(ichasu) Or ichasu <= 0 Then
	f_message_chk(1400,'[차수]')
	Return
End If

sArea = Trim(dw_ip.GetItemString(1,'sarea'))
If IsNull(sArea) Then sArea = ''

Choose Case tab_1.SelectedTab
	Case 1 // 제품군별 증감율 계획
		If tab_1.tab1.dw_insert1.AcceptText() <> 1 Then Return
		
		SetPointer(HourGlass!)
		w_mdi_frame.sle_msg.Text = '제품군별 증감율 계획 생성중......  잠시 기다리세요!!!'
		
		For i = 1 to tab_1.tab1.dw_insert1.RowCount()
			s_ittyp = tab_1.tab1.dw_insert1.GetItemString(i, 'ittyp')
			s_itcls = tab_1.tab1.dw_insert1.GetItemString(i, 'itcls')
			d_rate  = tab_1.tab1.dw_insert1.GetItemDecimal(i, 'rate')
			If IsNull(d_rate) Then d_rate = 0
			
			sTitnm = tab_1.tab1.dw_insert1.GetItemString(i, 'titnm')
			w_mdi_frame.sle_msg.Text = sTitnm + ' 생성중...'
			
			SQLCA.ERP000000500(gs_sabu, sYymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '1')
			If sqlca.sqlcode <> 0 Then
				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
				RollBack;
			End If
		Next

	/* 중분류 증감율 계획 */
	Case 2
		w_mdi_frame.sle_msg.Text = '중분류 증감율 계획 생성중......  잠시 기다리세요!!!'	
		
		// 시리즈의 증감율이 조정된 ROW를 찾아 일괄(시리즈, 제품) 조정 생성
		Do While lrow <= tab_1.tab4.dw_insert4.RowCount()
			lrow = tab_1.tab4.dw_insert4.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_ittyp = tab_1.tab4.dw_insert4.GetItemString(lrow, 'ittyp')
				s_itcls = tab_1.tab4.dw_insert4.GetItemString(lrow, 'itcls')
				d_rate  = tab_1.tab4.dw_insert4.GetItemDecimal(lrow, 'rate')
				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '3')
			else
				lrow = tab_1.tab4.dw_insert4.RowCount() + 1
			end if
		Loop
	/* 소분류 증감율 계획 */
	Case 3
		w_mdi_frame.sle_msg.Text = '소분류 증감율 계획 생성중......  잠시 기다리세요!!!'	
		
		// 시리즈의 증감율이 조정된 ROW를 찾아 일괄(시리즈, 제품) 조정 생성
		Do While lrow <= tab_1.tab2.dw_insert2.RowCount()
			lrow = tab_1.tab2.dw_insert2.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_ittyp = tab_1.tab2.dw_insert2.GetItemString(lrow, 'ittyp')
				s_itcls = tab_1.tab2.dw_insert2.GetItemString(lrow, 'itcls')
				d_rate  = tab_1.tab2.dw_insert2.GetItemDecimal(lrow, 'rate')
				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '3')
			else
				lrow = tab_1.tab2.dw_insert2.RowCount() + 1
			end if
		Loop
	Case 4 // 제품별 증감율 계획
		w_mdi_frame.sle_msg.Text = '제품별 증감율 계획 생성중......  잠시 기다리세요!!!'
		
		// 제품의 증감율이 조정된 ROW를 찾아 일괄 제품 조정 생성
		Do While lrow <= tab_1.tab3.dw_insert3.RowCount()
			lrow = tab_1.tab3.dw_insert3.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_itnbr = tab_1.tab3.dw_insert3.GetItemString(lrow, 'itnbr')
				d_rate  = tab_1.tab3.dw_insert3.GetItemDecimal(lrow, 'rate')
				
				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, '', sarea, s_itnbr, d_rate, '5')
				If sqlca.sqlcode <> 0 Then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
				End If
			else
				lrow = tab_1.tab3.dw_insert3.RowCount() + 1
			end if
		Loop
End Choose	

MessageBox('확 인','저장하였습니다.!!')

w_mdi_frame.sle_msg.text = ''
ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_sal_01030
integer x = 1874
integer y = 2736
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01030
integer x = 1509
integer y = 2736
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//Long    i
//String  s_ittyp, s_itcls, s_itnbr, syymm, sarea, stitnm
//Dec     d_rate
//Long    lrow = 0
//int     ichasu
//
//If dw_ip.AcceptText() <> 1 then Return
//
//sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
//If f_datechk(sYYmm +'0101') <> 1 Then
//	f_message_chk(35,'[계획년도]')
//	Return
//End If
//
//ichasu = dw_ip.GetItemNumber(1,'chasu')
//If IsNull(ichasu) Or ichasu <= 0 Then
//	f_message_chk(1400,'[차수]')
//	Return
//End If
//
//sArea = Trim(dw_ip.GetItemString(1,'sarea'))
//If IsNull(sArea) Then sArea = ''
//
//Choose Case tab_1.SelectedTab
//	Case 1 // 제품군별 증감율 계획
//		If tab_1.tab1.dw_insert1.AcceptText() <> 1 Then Return
//		
//		SetPointer(HourGlass!)
//		sle_msg.Text = '제품군별 증감율 계획 생성중......  잠시 기다리세요!!!'
//		
//		If is_tns_mode = 'I' then
//			For i = 1 to tab_1.tab1.dw_insert1.RowCount()
//				s_ittyp = tab_1.tab1.dw_insert1.GetItemString(i, 'ittyp')
//				s_itcls = tab_1.tab1.dw_insert1.GetItemString(i, 'itcls')
//				d_rate  = tab_1.tab1.dw_insert1.GetItemDecimal(i, 'rate')
//				If IsNull(d_rate) Then d_rate = 0
//				
//				sTitnm = tab_1.tab1.dw_insert1.GetItemString(i, 'titnm')
//				sle_msg.Text = sTitnm + ' 생성중...'
//				
//				SQLCA.ERP000000500(gs_sabu, sYymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '1')
//				If sqlca.sqlcode <> 0 Then
//					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//					RollBack;
//				End If
//			Next
//		Else
//			// 제품군의 증감율이 조정된 ROW를 찾아 일괄(제품군, 시리즈, 제품) 조정 생성
//			Do While lrow <= tab_1.tab1.dw_insert1.RowCount()
//				lrow = tab_1.tab1.dw_insert1.GetNextModified(lrow, Primary!)
//				if lrow > 0 then
//					s_ittyp = tab_1.tab1.dw_insert1.GetItemString(lrow, 'ittyp')
//					s_itcls = tab_1.tab1.dw_insert1.GetItemString(lrow, 'itcls')
//					d_rate  = tab_1.tab1.dw_insert1.GetItemDecimal(lrow, 'rate')
//					SQLCA.ERP000000500(gs_sabu, sYymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '2')
//				else
//					lrow = tab_1.tab1.dw_insert1.RowCount() + 1
//				end if
//			Loop			
//		End if
//	/* 중분류 증감율 계획 */
//	Case 2
//		sle_msg.Text = '중분류 증감율 계획 생성중......  잠시 기다리세요!!!'	
//		
//		// 시리즈의 증감율이 조정된 ROW를 찾아 일괄(시리즈, 제품) 조정 생성
//		Do While lrow <= tab_1.tab4.dw_insert4.RowCount()
//			lrow = tab_1.tab4.dw_insert4.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_ittyp = tab_1.tab4.dw_insert4.GetItemString(lrow, 'ittyp')
//				s_itcls = tab_1.tab4.dw_insert4.GetItemString(lrow, 'itcls')
//				d_rate  = tab_1.tab4.dw_insert4.GetItemDecimal(lrow, 'rate')
//				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '3')
//			else
//				lrow = tab_1.tab4.dw_insert4.RowCount() + 1
//			end if
//		Loop
//	/* 소분류 증감율 계획 */
//	Case 3
//		sle_msg.Text = '소분류 증감율 계획 생성중......  잠시 기다리세요!!!'	
//		
//		// 시리즈의 증감율이 조정된 ROW를 찾아 일괄(시리즈, 제품) 조정 생성
//		Do While lrow <= tab_1.tab2.dw_insert2.RowCount()
//			lrow = tab_1.tab2.dw_insert2.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_ittyp = tab_1.tab2.dw_insert2.GetItemString(lrow, 'ittyp')
//				s_itcls = tab_1.tab2.dw_insert2.GetItemString(lrow, 'itcls')
//				d_rate  = tab_1.tab2.dw_insert2.GetItemDecimal(lrow, 'rate')
//				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, s_ittyp, s_itcls, sarea, d_rate, '3')
//			else
//				lrow = tab_1.tab2.dw_insert2.RowCount() + 1
//			end if
//		Loop
//	Case 4 // 제품별 증감율 계획
//		sle_msg.Text = '제품별 증감율 계획 생성중......  잠시 기다리세요!!!'
//		
//		// 제품의 증감율이 조정된 ROW를 찾아 일괄 제품 조정 생성
//		Do While lrow <= tab_1.tab3.dw_insert3.RowCount()
//			lrow = tab_1.tab3.dw_insert3.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_itnbr = tab_1.tab3.dw_insert3.GetItemString(lrow, 'itnbr')
//				d_rate  = tab_1.tab3.dw_insert3.GetItemDecimal(lrow, 'rate')
//				
//				SQLCA.ERP000000500(gs_sabu, syymm, ichasu, '', sarea, s_itnbr, d_rate, '5')
//				If sqlca.sqlcode <> 0 Then
//					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//				End If
//			else
//				lrow = tab_1.tab3.dw_insert3.RowCount() + 1
//			end if
//		Loop
//End Choose	
//
//MessageBox('확 인','저장하였습니다.!!')
//
//sle_msg.text = ''
//ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_01030
integer x = 3822
integer y = 2664
integer width = 763
integer taborder = 40
string text = "년간 판매 계획 생성(&G)"
end type

event cb_ins::clicked;call super::clicked;//String sapp_rate, sjyear
//Dec    dapp_rate
//String sDataGu, sYymm, sarea
//int    ichasu
//
//If dw_ip.AcceptText() <> 1 then Return
//
//sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
//If f_datechk(sYYmm +'0101') <> 1 Then
//	f_message_chk(35,'[계획년도]')
//	Return
//End If
//
//ichasu = dw_ip.GetItemNumber(1,'chasu')
//If IsNull(ichasu) Or ichasu <= 0 Then
//	f_message_chk(1400,'[차수]')
//	Return
//End If
//
//sArea = Trim(dw_ip.GetItemString(1,'sarea'))
//If IsNull(sArea) Then sArea = ''
//
//If MessageBox("확 인", '년간 판매계획을 생성합니다.' + '~r~r' + &
//							  '저장을 해야 수정분이 적용됩니다.' + '~r~r' + &
//							  '년간 판매계획을 일괄 생성 하시겠습니까?', + &
//							  question!,YesNo!, 2) = 2 Then Return
//
//SetPointer(HourGlass!)
//
//w_mdi_frame.sle_msg.Text = '년간 판매계획 일괄 생성중 입니다. 잠시 기다려 주세요!!!'
//
//sjyear = String(Integer(sYymm) - 1)
//
//If rb_1.Checked = True Then
//	sDataGu = '1'
//Else
//	sDataGu = '2'
//End If
//
//SQLCA.ERP000000501(gs_sabu, syymm, ichasu, sjyear, sArea, sDatagu)
//If sqlca.sqlcode <> 0 Then
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	rollback;
//	Return
//End If
//
//f_message_Chk(202, '[년간 판매계획 생성]')	
//tab_1.TriggerEvent(SelectionChanged!)
//
end event

type cb_del from w_inherite`cb_del within w_sal_01030
integer x = 2638
integer y = 2640
integer taborder = 100
end type

type cb_inq from w_inherite`cb_inq within w_sal_01030
integer x = 101
integer y = 2748
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;//Integer rtn_v, cnt
//String  sItcls, syymm, sArea
//int     ichasu
//
//If dw_ip.AcceptText() <> 1 then Return
//
//sYYmm = Trim(dw_ip.GetItemString(1,'yymm'))
//If f_datechk(sYYmm +'0101') <> 1 Then
//	f_message_chk(35,'[계획년도]')
//	Return
//End If
//
//ichasu = dw_ip.GetItemNumber(1,'chasu')
//If IsNull(ichasu) Or ichasu <= 0 Then
//	f_message_chk(1400,'[차수]')
//	Return
//End If
//
//sArea = Trim(dw_ip.GetItemString(1,'sarea'))
//If IsNull(sArea) Then sArea = ''
//
///* 수립된 제품군별 증감율 계획이 존재하는지 유무 Check */
//Select Count(*) Into :cnt From ypsir
// Where sabu = :gs_sabu and plan_year = :is_year and plan_chasu = :ichasu and sarea like :sarea||'%';
//		 
//Choose Case tab_1.SelectedTab
//	Case 1 // 제품군별 증감율 계획
//		If cnt > 0 then
//			// 이미 수립되어 있으면
//			If MessageBox('Warning', '"' + is_year + '"' + '년의 제품군별 증감율이 이미 수립되어 있습니다. ' + '~n~n' + &
//							  '모두 삭제하고 다시 생성하겠습니까?', question!,yesno!, 2) = 2 THEN
//				MessageBox('확인', '제품군별 증감율 계획을 조정하세요')
//				
//				is_tns_mode = 'U'
//
//				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year, ichasu,sArea+'%')
//			Else
//				SetPointer(HourGlass!)
//				
//				/* 분류 삭제 */
//				DELETE FROM YPSIR
//				 WHERE SABU = :gs_sabu AND
//				       PLAN_YEAR = :sYYmm AND
//						 PLAN_CHASU = :ichasu AND
//						 SAREA LIKE :sarea||'%';
//				If sqlca.sqlcode <> 0 Then
//					RollBack;
//					f_message_chk(31,'')
//					Return
//				End If
//				/* 품번 삭제 */
//				DELETE FROM YPIIR
//				 WHERE SABU = :gs_sabu AND
//				       PLAN_YEAR = :sYYmm AND
//						 PLAN_CHASU = :ichasu AND
//						 SAREA LIKE :sarea||'%';
//				If sqlca.sqlcode <> 0 Then
//					RollBack;
//					f_message_chk(31,'')
//					Return
//				End If
//				
//				MessageBox('확인', '제품군별 증감율 계획을 신규 생성하세요')						
//				is_tns_mode = 'I'
//					
//				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
//			end if
//		else
//			MessageBox('확인', '제품군별 증감율 계획을 신규 생성하세요')
//			is_tns_mode = 'I'
//
//			rtn_v = tab_1.tab1.dw_Insert1.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
//		end if
//	/* 중분류 증감율 계획 */
//	Case 2
//		If cnt <= 0 Then
//			rtn_v = -1
//		Else
//			rtn_v = tab_1.tab4.dw_insert4.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
//		End If
//	/* 소분류 증감율 계획 */
//	Case 3
//		If cnt <= 0 Then
//			rtn_v = -1
//		Else
//			rtn_v = tab_1.tab2.dw_insert2.retrieve(gs_sabu,is_year_41, is_year_31, is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sArea+'%')
//		End If
//	/* 제품별 증감율 계획 */
//	Case 4
//		If cnt <= 0 Then
//			rtn_v = -1
//		Else
//			If tab_1.tab3.dw_jogun.AcceptText() <> 1 Then Return
//			
//			sItcls = tab_1.tab3.dw_jogun.GetItemString(1, 'itcls')
//			If sItcls = '' Or isNull(sItcls) Then
//				f_message_Chk(30, '[제품군]')
//				tab_1.tab3.dw_jogun.SetFocus()
//				return 1
//			End If
//			
//			MessageBox('확인', '제품별 증감율 계획을 조정하세요')
//			rtn_v = tab_1.tab3.dw_insert3.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sItcls,ichasu, sArea+'%')
//		End If
//End Choose		
//
//If rtn_v < 1 Then
//	MessageBox('확인', '조정할 기초자료가 존재하지 않습니다.' + '~r~r' + &
//	                   '먼저 제품군별 계획을 수립하세요' + '~r' + &
//							 '제품군별 계획을 수립해야 기초자료가 생성됩니다')
//   tab_1.SelectedTab = 1
//	return -1
//End If
end event

type cb_print from w_inherite`cb_print within w_sal_01030
integer x = 3360
integer y = 2640
integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_01030
end type

type cb_can from w_inherite`cb_can within w_sal_01030
integer x = 3721
integer y = 2640
integer taborder = 130
end type

type cb_search from w_inherite`cb_search within w_sal_01030
integer x = 4082
integer y = 2640
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01030
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01030
end type

type gb_5 from groupbox within w_sal_01030
boolean visible = false
integer x = 55
integer y = 2700
integer width = 1312
integer height = 180
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_6 from groupbox within w_sal_01030
boolean visible = false
integer x = 1467
integer y = 2688
integer width = 777
integer height = 180
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type tab_1 from tab within w_sal_01030
event create ( )
event destroy ( )
integer x = 37
integer y = 308
integer width = 4576
integer height = 2012
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tab1 tab1
tab4 tab4
tab2 tab2
tab3 tab3
end type

on tab_1.create
this.tab1=create tab1
this.tab4=create tab4
this.tab2=create tab2
this.tab3=create tab3
this.Control[]={this.tab1,&
this.tab4,&
this.tab2,&
this.tab3}
end on

on tab_1.destroy
destroy(this.tab1)
destroy(this.tab4)
destroy(this.tab2)
destroy(this.tab3)
end on

event selectionchanged;Choose Case tab_1.SelectedTab
	Case 1
		cb_Ins.Enabled = False
	Case 3
		cb_Ins.Enabled = False
	Case 4
		tab_1.tab3.dw_jogun.reset()
		tab_1.tab3.dw_jogun.InsertRow(0)
		cb_Ins.Enabled = True
End Choose

end event

type tab1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4539
integer height = 1900
long backcolor = 32106727
string text = "대분류별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_insert1 dw_insert1
rr_5 rr_5
end type

on tab1.create
this.dw_insert1=create dw_insert1
this.rr_5=create rr_5
this.Control[]={this.dw_insert1,&
this.rr_5}
end on

on tab1.destroy
destroy(this.dw_insert1)
destroy(this.rr_5)
end on

type dw_insert1 from u_key_enter within tab1
event ue_key pbm_dwnkey
integer x = 215
integer y = 44
integer width = 4064
integer height = 1824
integer taborder = 40
string dataobject = "d_sal_01030_04"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

type rr_5 from roundrectangle within tab1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 206
integer y = 36
integer width = 4087
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4539
integer height = 1900
long backcolor = 32106727
string text = "중분류별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_insert4 dw_insert4
rr_4 rr_4
end type

on tab4.create
this.dw_insert4=create dw_insert4
this.rr_4=create rr_4
this.Control[]={this.dw_insert4,&
this.rr_4}
end on

on tab4.destroy
destroy(this.dw_insert4)
destroy(this.rr_4)
end on

type dw_insert4 from datawindow within tab4
integer x = 219
integer y = 36
integer width = 4059
integer height = 1832
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_01030_06"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_4 from roundrectangle within tab4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 206
integer y = 32
integer width = 4087
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4539
integer height = 1900
long backcolor = 32106727
string text = "소분류별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_insert2 dw_insert2
rr_3 rr_3
end type

on tab2.create
this.dw_insert2=create dw_insert2
this.rr_3=create rr_3
this.Control[]={this.dw_insert2,&
this.rr_3}
end on

on tab2.destroy
destroy(this.dw_insert2)
destroy(this.rr_3)
end on

type dw_insert2 from u_key_enter within tab2
event ue_key pbm_dwnkey
integer x = 215
integer y = 44
integer width = 4064
integer height = 1824
integer taborder = 11
string dataobject = "d_sal_01030_02"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

type rr_3 from roundrectangle within tab2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 206
integer y = 36
integer width = 4087
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4539
integer height = 1900
long backcolor = 32106727
string text = "제품별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
cbx_2 cbx_2
dw_insert3 dw_insert3
dw_jogun dw_jogun
rr_2 rr_2
end type

on tab3.create
this.cbx_2=create cbx_2
this.dw_insert3=create dw_insert3
this.dw_jogun=create dw_jogun
this.rr_2=create rr_2
this.Control[]={this.cbx_2,&
this.dw_insert3,&
this.dw_jogun,&
this.rr_2}
end on

on tab3.destroy
destroy(this.cbx_2)
destroy(this.dw_insert3)
destroy(this.dw_jogun)
destroy(this.rr_2)
end on

type cbx_2 from checkbox within tab3
integer x = 2057
integer y = 72
integer width = 247
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "요약"
end type

event clicked;if this.checked  then
	this.text = '요약'
	tab_1.tab3.dw_insert3.Modify("DataWindow.Detail.Height=136")
else
	this.text = '상세'
	tab_1.tab3.dw_insert3.Modify("DataWindow.Detail.Height=72")	
End if


end event

type dw_insert3 from u_key_enter within tab3
event ue_key pbm_dwnkey
integer x = 210
integer y = 176
integer width = 4073
integer height = 1704
integer taborder = 30
string dataobject = "d_sal_01030_03"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

type dw_jogun from datawindow within tab3
integer x = 201
integer y = 12
integer width = 1413
integer height = 148
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_01030_05"
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within tab3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 201
integer y = 168
integer width = 4096
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_sal_01030
integer x = 2560
integer y = 60
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

type rb_2 from radiobutton within w_sal_01030
integer x = 2560
integer y = 128
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

type dw_ip from datawindow within w_sal_01030
event ue_processenter pbm_dwnprocessenter
integer x = 41
integer y = 44
integer width = 2418
integer height = 176
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_010301"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sYYmm

Choose Case GetColumnName()
	Case 'yymm'
		sYYmm = Trim(GetText())
		If IsNull(syymm) Or sYymm = '' Then
			f_message_chk(35,'')
			Return 1
		End If
		
		is_year = sYYmm
		is_year_1 = String(Integer(is_year) - 1)
		is_year_2 = String(Integer(is_year_1) - 1)
		is_year_3 = String(Integer(is_year_2) - 1)
		is_year_4 = String(Integer(is_year_3) - 1)
		is_year_41 = is_year_4 + '01'
		is_year_31 = is_year_2 + '12'
End Choose
end event

type st_2 from statictext within w_sal_01030
integer x = 3767
integer y = 316
integer width = 521
integer height = 64
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
string text = "[단위 : 천원]"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_01030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2510
integer y = 44
integer width = 983
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

