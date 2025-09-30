$PBExportHeader$w_sal_01035.srw
$PBExportComments$ ===> 년간 판매 계획 거래처별 증감율 조정 및 생성
forward
global type w_sal_01035 from w_inherite
end type
type gb_5 from groupbox within w_sal_01035
end type
type gb_6 from groupbox within w_sal_01035
end type
type tab_1 from tab within w_sal_01035
end type
type tab1 from userobject within tab_1
end type
type dw_insert1 from u_key_enter within tab1
end type
type rr_2 from roundrectangle within tab1
end type
type tab1 from userobject within tab_1
dw_insert1 dw_insert1
rr_2 rr_2
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
type dw_insert3 from u_key_enter within tab3
end type
type rr_4 from roundrectangle within tab3
end type
type tab3 from userobject within tab_1
dw_insert3 dw_insert3
rr_4 rr_4
end type
type tab_1 from tab within w_sal_01035
tab1 tab1
tab2 tab2
tab3 tab3
end type
type rb_1 from radiobutton within w_sal_01035
end type
type rb_2 from radiobutton within w_sal_01035
end type
type dw_ip from datawindow within w_sal_01035
end type
type st_2 from statictext within w_sal_01035
end type
type rr_1 from roundrectangle within w_sal_01035
end type
end forward

global type w_sal_01035 from w_inherite
string title = "년간 판매계획 거래처별 증감율 조정 및 생성"
gb_5 gb_5
gb_6 gb_6
tab_1 tab_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
st_2 st_2
rr_1 rr_1
end type
global w_sal_01035 w_sal_01035

type variables
string is_year, &
         is_year_1, &
         is_year_2, &
         is_year_3, &
         is_year_4, &
         is_tns_mode, &
         is_sarea,isAreaChk
dec   id_app_rate
end variables

forward prototypes
public function integer wf_delete_yp (string syymm, integer ichasu, string ssarea)
end prototypes

public function integer wf_delete_yp (string syymm, integer ichasu, string ssarea);// 년간판매계획 영업팀별 증감율 테이블 삭제
Delete From yptir a 
 Where a.sabu = :gs_sabu and
		 a.plan_year = :syymm and
		 a.plan_chasu = :ichasu and
		 exists ( select 'x' from sarea b
		  			  Where b.steamcd = a.steamcd
						 and b.saupj Like :sSarea);
		 
If SQLCA.SqlCode < 0 Then
	f_Message_Chk(31, '[년간판매계획을 위한 영업팀별 증감율 삭제]')
	Rollback;
	return -1
else
	commit;
end if

// 년간판매계획 관할구역별 증감율 테이블 삭제
Delete From ypair a
Where a.sabu = :gs_sabu and
		a.plan_year = :syymm and
		a.plan_chasu = :ichasu and
		 exists ( select 'x' from sarea b
		  			  Where b.steamcd = a.steamcd
						 and b.saupj Like :sSarea);
If SQLCA.SqlCode < 0 Then
	f_Message_Chk(31, '[년간판매계획을 위한 관할구역별 증감율 삭제]')
	Rollback;
	return -1
else
	commit;
end if

// 년간판매계획 거래처별 증감율 테이블 삭제			
Delete From ypvir
Where sabu = :gs_sabu and
		plan_year = :syymm and
		plan_chasu = :ichasu;
If SQLCA.SqlCode < 0 Then
	f_Message_Chk(31, '[년간판매계획을 위한 거래처별 증감율 삭제]')
	Rollback;
	return -1
else
	commit;
end if

Return 0
end function

on w_sal_01035.create
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

on w_sal_01035.destroy
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
//***  PGM NAME : 년간 판매계획 거래처별 증감율 조정 및 생성                ***//
//***  PGM ID   : W_SAL_01030                                               ***//
//***  SUBJECT  : 제품별 생성된 년간 판매계획을 기준으로 영업팀 => 관할구역 ***//
//***             => 거래처 순으로 세분화 생성한다.                         ***//
//***             GLOVAL VALIABLE의 gs_dept에 의해 해당부서의 관할구역 및   ***//
//***             거래처의 조정을 할 수 있다.(조회는 가능)                  ***//
//*****************************************************************************//
String sYn

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

tab_1.tab1.dw_insert1.SetTransObject(sqlca)
tab_1.tab2.dw_insert2.SetTransObject(sqlca)
tab_1.tab3.dw_insert3.SetTransObject(sqlca)

w_mdi_frame.sle_msg.Text = '계획년도를 입력하고 조회버턴을 누르세요'

dw_ip.SetFocus()

setnull(gs_code)

// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'sarea')

end event

type dw_insert from w_inherite`dw_insert within w_sal_01035
boolean visible = false
integer x = 882
integer y = 3300
integer width = 270
integer height = 60
integer taborder = 10
end type

type p_delrow from w_inherite`p_delrow within w_sal_01035
boolean visible = false
integer x = 3543
integer y = 3100
end type

type p_addrow from w_inherite`p_addrow within w_sal_01035
boolean visible = false
integer x = 3369
integer y = 3100
end type

type p_search from w_inherite`p_search within w_sal_01035
boolean visible = false
integer x = 2674
integer y = 3100
end type

type p_ins from w_inherite`p_ins within w_sal_01035
integer x = 3790
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\년간판매계획조정생성_up.gif"
end type

event p_ins::clicked;call super::clicked;String sapp_rate, sjyear, syymm, sarea
Dec    dapp_rate
String sDataGu
int	 ichasu

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

If MessageBox("확 인", '년간 판매계획 거래처별 조정분을을 생성합니다.' + '~r~r' + &
                       '거래처별 증감율 조정분을 저장 했습니까?' + '~r' + &
							  '저장을 해야 조정분이 적용됩니다.' + '~r~r' + &
							  '년간 판매계획 거래처별 조정분을 일괄 생성 하시겠습니까?', + &
							  question!,yesno!, 2) = 2 THEN 	Return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.Text = '년간 판매계획 조정 생성중 입니다. 잠시 기다려 주세요!!!'

If rb_1.Checked = True Then
	sDataGu = '1'
Else
	sDataGu = '2'
End If

SQLCA.ERP000000511(gs_sabu, syymm, ichasu, sarea, sDatagu)
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return
End If

f_message_Chk(202, '[년간 판매계획 조정 생성]')	
tab_1.TriggerEvent(SelectionChanged!)
end event

event p_ins::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\년간판매계획조정생성_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\년간판매계획조정생성_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_01035
end type

type p_can from w_inherite`p_can within w_sal_01035
boolean visible = false
integer x = 4064
integer y = 3100
end type

type p_print from w_inherite`p_print within w_sal_01035
boolean visible = false
integer x = 2848
integer y = 3100
end type

type p_inq from w_inherite`p_inq within w_sal_01035
integer x = 4096
end type

event p_inq::clicked;call super::clicked;Integer rtn_v, cnt, ichasu, ix
String  sSteam, syymm, sarea

If dw_ip.AcceptText() <> 1 Then Return

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

Choose Case tab_1.SelectedTab
	/* 영업팀별 증감율 계획 */
	Case 1
	   // 수립된 영업팀별 증감율 계획이 존재하는지 유무 Check
		Select Count(*) Into :cnt From yptir a 
		 Where a.sabu 	  = :gs_sabu  and a.plan_year = :sYYmm 	  and a.plan_chasu = :ichasu
		   and a.saupj  Like :sArea;

		tab_1.tab1.dw_insert1.Enabled = True
		
		/* 이미 수립되어 있는지check */
		If cnt > 0 Then
			If MessageBox('Warning', '"' + is_year + '"' + '년의 영업팀별 증감율이 이미 수립되어 있습니다. ' + '~n~n' + &
							  '모두 삭제하고 다시 생성하겠습니까?', question!,yesno!, 2) = 2 Then
				MessageBox('확인', '영업팀별 증감율 계획을 조정하세요')
				is_tns_mode = 'U'
				
				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu, is_year_4, is_year_3, is_year_2, is_year_1, is_year, ichasu, sarea)
			Else
				MessageBox('확인', '영업팀별 증감율 계획을 신규 생성하세요')						
				is_tns_mode = 'I'

				If wf_delete_yp(syymm, ichasu, sarea) <> 0 Then	Return

   	   	rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu, sarea)
			End If
		Else
			is_tns_mode = 'I'
			If wf_delete_yp(syymm, ichasu, sarea) <> 0 Then	Return
			  
   		rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu,sarea)

			MessageBox('확인', '영업팀별 증감율 계획을 신규 생성하세요')
		End If
	Case 2 // 관할구역별 증감율 계획
		MessageBox('확인', '관할구역별 증감율 계획을 조정하세요')

		rtn_v = tab_1.tab2.dw_insert2.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sArea, ichasu)
	Case 3 // 거래처별 증감율 계획
		If tab_1.tab3.dw_insert3.AcceptText() <> 1 Then Return
		
		MessageBox('확인', '거래처별 증감율 계획을 조정하세요')	

		rtn_v = tab_1.tab3.dw_insert3.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sArea, ichasu)
End Choose		

If rtn_v < 1 Then
	MessageBox('확인', '조정할 기초자료가 존재하지 않습니다.' + '~r~r' + &
	                   '먼저 영업팀별 계획을 수립하세요' + '~r' + &
							 '영업팀별 계획을 수립해야 기초자료가 생성됩니다')
   tab_1.SelectedTab = 1
	Return
End If
end event

type p_del from w_inherite`p_del within w_sal_01035
boolean visible = false
integer x = 3890
integer y = 3100
end type

type p_mod from w_inherite`p_mod within w_sal_01035
integer x = 4270
end type

event p_mod::clicked;call super::clicked;Integer i, ichasu
String  s_steam, s_sarea, s_cvcod, syymm, sarea, sgubun
Dec     d_rate
Long    lrow = 0

If dw_ip.AcceptText() <> 1 Then Return 

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

Choose Case tab_1.SelectedTab
	Case 1 // 영업팀별 증감율 계획
		If tab_1.tab1.dw_insert1.AcceptText() <> 1 Then Return
		
		SetPointer(HourGlass!)
		w_mdi_frame.sle_msg.Text = '영업팀별 증감율 계획 생성중......  잠시 기다리세요!!!'
		
		/* 영업팀의 증감율이 조정된 ROW를 찾아 일괄(영업팀, 관할구역, 거래처) 조정 생성 */
		Do While lrow <= tab_1.tab1.dw_insert1.RowCount()
			lrow = tab_1.tab1.dw_insert1.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_steam = tab_1.tab1.dw_insert1.GetItemString(lrow, 'steamcd')
				d_rate  = tab_1.tab1.dw_insert1.GetItemDecimal(lrow, 'jo_rate')
				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, s_steam, sarea, '', d_rate, '1')
			else
				lrow = tab_1.tab1.dw_insert1.RowCount() + 1
			end if
		Loop			

		f_message_Chk(202, '[영업팀별 증감율 계획 조정등록]')		
	Case 2 // 관할구역별 증감율 계획
		If tab_1.tab2.dw_insert2.AcceptText() <> 1 Then Return
		
		SetPointer(HourGlass!)
		w_mdi_frame.sle_msg.Text = '관할구역별 증감율 계획 생성중......  잠시 기다리세요!!!'
		
		// 관할구역의 증감율이 조정된 ROW를 찾아 일괄(관할구역, 거래처) 조정 생성
		Do While lrow <= tab_1.tab2.dw_insert2.RowCount()
			lrow = tab_1.tab2.dw_insert2.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_sarea = tab_1.tab2.dw_insert2.GetItemString(lrow, 'sarea')
				d_rate  = tab_1.tab2.dw_insert2.GetItemDecimal(lrow, 'jo_rate')
				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, s_sarea, sarea, '', d_rate, '3')
			else
				lrow = tab_1.tab2.dw_insert2.RowCount() + 1
			end if
		Loop			

		f_message_Chk(202, '[관할구역별 증감율 계획 조정등록]')
	Case 3 // 거래처별 증감율 계획
		If tab_1.tab3.dw_insert3.AcceptText() <> 1 Then Return
		
		SetPointer(HourGlass!)
		w_mdi_frame.sle_msg.Text = '거래처별 증감율 계획 생성중......  잠시 기다리세요!!!'
		
		// 거래처의 증감율이 조정된 ROW를 찾아 일괄 거래처 조정 생성
		Do While lrow <= tab_1.tab3.dw_insert3.RowCount()
			lrow = tab_1.tab3.dw_insert3.GetNextModified(lrow, Primary!)
			if lrow > 0 then
				s_cvcod = tab_1.tab3.dw_insert3.GetItemString(lrow, 'cvcod')
				d_rate  = tab_1.tab3.dw_insert3.GetItemDecimal(lrow, 'jo_rate')
				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, '', sarea, s_cvcod, d_rate, '4')
			else
				lrow = tab_1.tab3.dw_insert3.RowCount() + 1
			end if
		Loop
		
		f_message_Chk(202, '[거래처별 증감율 계획 조정등록]')		
		p_ins.SetFocus()						
End Choose	

ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''
end event

type cb_exit from w_inherite`cb_exit within w_sal_01035
integer x = 3337
integer y = 2720
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01035
integer x = 2971
integer y = 2720
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//Integer i, ichasu
//String  s_steam, s_sarea, s_cvcod, syymm, sarea, sgubun
//Dec     d_rate
//Long    lrow = 0
//
//If dw_ip.AcceptText() <> 1 Then Return 
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
//	Case 1 // 영업팀별 증감율 계획
//		If tab_1.tab1.dw_insert1.AcceptText() <> 1 Then Return
//		
//		SetPointer(HourGlass!)
//		sle_msg.Text = '영업팀별 증감율 계획 생성중......  잠시 기다리세요!!!'
//		
//		If is_tns_mode = 'I' Then
//			sgubun = '1'
//		Else
//			sgubun = '2'
//		End If
//
//		/* 영업팀의 증감율이 조정된 ROW를 찾아 일괄(영업팀, 관할구역, 거래처) 조정 생성 */
//		Do While lrow <= tab_1.tab1.dw_insert1.RowCount()
//			lrow = tab_1.tab1.dw_insert1.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_steam = tab_1.tab1.dw_insert1.GetItemString(lrow, 'steamcd')
//				d_rate  = tab_1.tab1.dw_insert1.GetItemDecimal(lrow, 'jo_rate')
//				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, s_steam, '', '', d_rate, sgubun)
//			else
//				lrow = tab_1.tab1.dw_insert1.RowCount() + 1
//			end if
//		Loop			
//
//		f_message_Chk(202, '[영업팀별 증감율 계획 조정등록]')		
//	Case 2 // 관할구역별 증감율 계획
//		If tab_1.tab2.dw_insert2.AcceptText() <> 1 Then Return
//		
//		SetPointer(HourGlass!)
//		sle_msg.Text = '관할구역별 증감율 계획 생성중......  잠시 기다리세요!!!'
//		
//		// 관할구역의 증감율이 조정된 ROW를 찾아 일괄(관할구역, 거래처) 조정 생성
//		Do While lrow <= tab_1.tab2.dw_insert2.RowCount()
//			lrow = tab_1.tab2.dw_insert2.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_sarea = tab_1.tab2.dw_insert2.GetItemString(lrow, 'sarea')
//				d_rate  = tab_1.tab2.dw_insert2.GetItemDecimal(lrow, 'jo_rate')
//				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, '', s_sarea, '', d_rate, '3')
//			else
//				lrow = tab_1.tab2.dw_insert2.RowCount() + 1
//			end if
//		Loop			
//
//		f_message_Chk(202, '[관할구역별 증감율 계획 조정등록]')
//	Case 3 // 거래처별 증감율 계획
//		If tab_1.tab3.dw_insert3.AcceptText() <> 1 Then Return
//		
//		SetPointer(HourGlass!)
//		sle_msg.Text = '거래처별 증감율 계획 생성중......  잠시 기다리세요!!!'
//		
//		// 거래처의 증감율이 조정된 ROW를 찾아 일괄 거래처 조정 생성
//		Do While lrow <= tab_1.tab3.dw_insert3.RowCount()
//			lrow = tab_1.tab3.dw_insert3.GetNextModified(lrow, Primary!)
//			if lrow > 0 then
//				s_cvcod = tab_1.tab3.dw_insert3.GetItemString(lrow, 'cvcod')
//				d_rate  = tab_1.tab3.dw_insert3.GetItemDecimal(lrow, 'jo_rate')
//				SQLCA.ERP000000510(gs_sabu, syymm, ichasu, '', '', s_cvcod, d_rate, '4')
//			else
//				lrow = tab_1.tab3.dw_insert3.RowCount() + 1
//			end if
//		Loop
//		
//		f_message_Chk(202, '[거래처별 증감율 계획 조정등록]')		
//		cb_ins.SetFocus()						
//End Choose	
//
//ib_any_typing = False
//
//sle_msg.Text = ''
end event

type cb_ins from w_inherite`cb_ins within w_sal_01035
integer x = 3653
integer y = 2968
integer width = 905
integer taborder = 30
string text = "년간판매계획조정생성(&G)"
end type

event cb_ins::clicked;call super::clicked;//String sapp_rate, sjyear, syymm, sarea
//Dec    dapp_rate
//String sDataGu
//int	 ichasu
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
//If MessageBox("확 인", '년간 판매계획 거래처별 조정분을을 생성합니다.' + '~r~r' + &
//                       '거래처별 증감율 조정분을 저장 했습니까?' + '~r' + &
//							  '저장을 해야 조정분이 적용됩니다.' + '~r~r' + &
//							  '년간 판매계획 거래처별 조정분을 일괄 생성 하시겠습니까?', + &
//							  question!,yesno!, 2) = 2 THEN 	Return
//
//SetPointer(HourGlass!)
//w_mdi_frame.sle_msg.Text = '년간 판매계획 조정 생성중 입니다. 잠시 기다려 주세요!!!'
//
//If rb_1.Checked = True Then
//	sDataGu = '1'
//Else
//	sDataGu = '2'
//End If
//
//SQLCA.ERP000000511(gs_sabu, syymm, ichasu, sDatagu)
//If sqlca.sqlcode <> 0 Then
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	rollback;
//	Return
//End If
//
//f_message_Chk(202, '[년간 판매계획 조정 생성]')	
//tab_1.TriggerEvent(SelectionChanged!)
end event

type cb_del from w_inherite`cb_del within w_sal_01035
integer x = 1285
integer y = 3284
integer taborder = 100
end type

type cb_inq from w_inherite`cb_inq within w_sal_01035
integer x = 165
integer y = 2720
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;//Integer rtn_v, cnt, ichasu, ix
//String  sSteam, syymm, sarea
//
//If dw_ip.AcceptText() <> 1 Then Return
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
//	/* 영업팀별 증감율 계획 */
//	Case 1
//	   // 수립된 영업팀별 증감율 계획이 존재하는지 유무 Check
//		Select Count(*) Into :cnt From yptir
//		 Where  sabu = :gs_sabu and plan_year = :sYYmm and plan_chasu = :ichasu;
//
//		tab_1.tab1.dw_insert1.Enabled = True
//		
//		/* 이미 수립되어 있고 수퍼유저인 경우 */
//		If cnt > 0 and isareachk = '' Then
//			If MessageBox('Warning', '"' + is_year + '"' + '년의 영업팀별 증감율이 이미 수립되어 있습니다. ' + '~n~n' + &
//							  '모두 삭제하고 다시 생성하겠습니까?', question!,yesno!, 2) = 2 Then
//				MessageBox('확인', '영업팀별 증감율 계획을 조정하세요')
//				is_tns_mode = 'U'
//				
//				rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu, is_year_4, is_year_3, is_year_2, is_year_1, is_year, ichasu)
//			Else
//				MessageBox('확인', '영업팀별 증감율 계획을 신규 생성하세요')						
//				is_tns_mode = 'I'
//
//				If wf_delete_yp(syymm, ichasu) <> 0 Then	Return
//
//   	   	rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu)
//			End If
//		Else
//			is_tns_mode = 'I'
//			If wf_delete_yp(syymm, ichasu) <> 0 Then	Return
//			  
//   		rtn_v = tab_1.tab1.dw_insert1.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,ichasu)
//
//			If iSareaChk = '' Then 
//				MessageBox('확인', '영업팀별 증감율 계획을 신규 생성하세요')
//			Else
//				/* 일반 사용자일 경우 영업팀별 수립을 하지 못한다 */
//				tab_1.tab1.dw_insert1.Enabled = False
//				
//				sle_msg.Text = '일반 사용자일 경우 영업팀별 계획을 수립을 하지 못합니다.!!'
//			End If
//		End If
//	Case 2 // 관할구역별 증감율 계획
//		MessageBox('확인', '관할구역별 증감율 계획을 조정하세요')
//
//		rtn_v = tab_1.tab2.dw_insert2.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sArea, ichasu)
//	Case 3 // 거래처별 증감율 계획
//		If tab_1.tab3.dw_insert3.AcceptText() <> 1 Then Return
//		
//		MessageBox('확인', '거래처별 증감율 계획을 조정하세요')	
//
//		rtn_v = tab_1.tab3.dw_insert3.retrieve(gs_sabu,is_year_4,is_year_3,is_year_2,is_year_1,is_year,sArea, ichasu)
//End Choose		
//
//If rtn_v < 1 Then
//	MessageBox('확인', '조정할 기초자료가 존재하지 않습니다.' + '~r~r' + &
//	                   '먼저 영업팀별 계획을 수립하세요' + '~r' + &
//							 '영업팀별 계획을 수립해야 기초자료가 생성됩니다')
//   tab_1.SelectedTab = 1
//	Return
//End If
end event

type cb_print from w_inherite`cb_print within w_sal_01035
integer x = 2007
integer y = 3284
integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_01035
end type

type cb_can from w_inherite`cb_can within w_sal_01035
integer x = 2368
integer y = 3284
integer taborder = 130
end type

type cb_search from w_inherite`cb_search within w_sal_01035
integer x = 2729
integer y = 3284
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01035
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01035
end type

type gb_5 from groupbox within w_sal_01035
boolean visible = false
integer x = 128
integer y = 2672
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

type gb_6 from groupbox within w_sal_01035
boolean visible = false
integer x = 2930
integer y = 2672
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

type tab_1 from tab within w_sal_01035
event create ( )
event destroy ( )
integer x = 46
integer y = 240
integer width = 4567
integer height = 2076
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
tab2 tab2
tab3 tab3
end type

on tab_1.create
this.tab1=create tab1
this.tab2=create tab2
this.tab3=create tab3
this.Control[]={this.tab1,&
this.tab2,&
this.tab3}
end on

on tab_1.destroy
destroy(this.tab1)
destroy(this.tab2)
destroy(this.tab3)
end on

event selectionchanged;Choose Case tab_1.SelectedTab
	Case 1
		cb_Ins.Enabled = False
	Case 2
		cb_Ins.Enabled = False
	Case 3
		cb_Ins.Enabled = True
End Choose		

end event

type tab1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4530
integer height = 1964
long backcolor = 32106727
string text = "영업팀별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_insert1 dw_insert1
rr_2 rr_2
end type

on tab1.create
this.dw_insert1=create dw_insert1
this.rr_2=create rr_2
this.Control[]={this.dw_insert1,&
this.rr_2}
end on

on tab1.destroy
destroy(this.dw_insert1)
destroy(this.rr_2)
end on

type dw_insert1 from u_key_enter within tab1
event ue_key pbm_dwnkey
integer x = 224
integer y = 48
integer width = 4037
integer height = 1872
integer taborder = 40
string dataobject = "d_sal_01035_04"
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

type rr_2 from roundrectangle within tab1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 210
integer y = 40
integer width = 4064
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4530
integer height = 1964
long backcolor = 32106727
string text = "관할구역별증감율"
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
integer x = 165
integer y = 44
integer width = 4146
integer height = 1880
integer taborder = 11
string dataobject = "d_sal_01035_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
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
integer x = 155
integer y = 40
integer width = 4169
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4530
integer height = 1964
long backcolor = 32106727
string text = "거래처별증감율"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_insert3 dw_insert3
rr_4 rr_4
end type

on tab3.create
this.dw_insert3=create dw_insert3
this.rr_4=create rr_4
this.Control[]={this.dw_insert3,&
this.rr_4}
end on

on tab3.destroy
destroy(this.dw_insert3)
destroy(this.rr_4)
end on

type dw_insert3 from u_key_enter within tab3
event ue_key pbm_dwnkey
integer x = 146
integer y = 44
integer width = 4201
integer height = 1880
integer taborder = 10
string dataobject = "d_sal_01035_03"
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

type rr_4 from roundrectangle within tab3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 137
integer y = 36
integer width = 4219
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_sal_01035
integer x = 2574
integer y = 56
integer width = 887
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

type rb_2 from radiobutton within w_sal_01035
integer x = 2574
integer y = 120
integer width = 837
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

type dw_ip from datawindow within w_sal_01035
event ue_pressenter pbm_dwnprocessenter
integer x = 37
integer y = 36
integer width = 2409
integer height = 180
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_010301"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
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
End Choose
end event

type st_2 from statictext within w_sal_01035
integer x = 4105
integer y = 248
integer width = 480
integer height = 68
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
string text = "[ 단위 : 천원 ]"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_01035
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2519
integer y = 36
integer width = 1010
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

