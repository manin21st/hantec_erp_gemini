$PBExportHeader$w_sal_02030.srw
$PBExportComments$수주할당 처리
forward
global type w_sal_02030 from w_inherite
end type
type r_1 from rectangle within w_sal_02030
end type
type rb_perform from radiobutton within w_sal_02030
end type
type rb_cancel from radiobutton within w_sal_02030
end type
type cbx_select from checkbox within w_sal_02030
end type
type st_title from statictext within w_sal_02030
end type
type pb_1 from u_pic_cal within w_sal_02030
end type
type pb_2 from u_pic_cal within w_sal_02030
end type
type dw_head from u_key_enter within w_sal_02030
end type
type dw_cust_lst from u_d_popup_sort within w_sal_02030
end type
type dw_haldang from u_d_popup_sort within w_sal_02030
end type
end forward

global type w_sal_02030 from w_inherite
integer width = 4750
integer height = 2520
string title = "출고요청(할당)"
r_1 r_1
rb_perform rb_perform
rb_cancel rb_cancel
cbx_select cbx_select
st_title st_title
pb_1 pb_1
pb_2 pb_2
dw_head dw_head
dw_cust_lst dw_cust_lst
dw_haldang dw_haldang
end type
global w_sal_02030 w_sal_02030

type variables
String LsDepotNo,LsHoldDate,is_ret, LsRqdat
str_itnct str_sitnct
String  sMinus  /* 가용재고 허용여부 */
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function string wf_depot_gubun (string sDepotNo)
public function long wf_calc_validqty (integer nrow)
public subroutine wf_init ()
end prototypes

public function integer wf_requiredchk (integer icurrow);If dw_input.AcceptText() <> 1 Then Return -1

LsDepotNo  	= Trim(dw_input.GetItemString(1,"depot_no"))
LsHoldDate 	= Trim(dw_input.GetItemString(1,"holddate"))
LsRqdat 		= Trim(dw_input.GetItemString(1,"rqdat"))
	
IF LsDepotNo = "" OR IsNull(LsDepotNo) THEN
	f_message_chk(30,'[창고]')
	dw_input.SetColumn("depot_no")
	dw_input.SetFocus()
	Return -1
END IF

IF 	rb_perform.Checked = True THEN
	IF 	f_datechk(LsHoldDate) = -1 THEN
		f_message_chk(30,'[할당일자]')
		dw_input.SetColumn("holddate")
		dw_input.SetFocus()
		Return -1
  	END IF
End If

IF 	rb_perform.Checked = True THEN
	IF 	f_datechk(LsRqdat) = -1 THEN
	  	f_message_chk(30,'[출고일자]')
	  	dw_input.SetColumn("rqdat")
	  	dw_input.SetFocus()
  	  	Return -1
  	END IF
End If
IF 	LsRqdat <> "" 	then
	IF 	f_datechk(LsRqdat) = -1 THEN
	  	f_message_chk(30,'[출고일자]')
	  	dw_input.SetColumn("rqdat")
	  	dw_input.SetFocus()
  	  	Return -1
	End If
End If
Return 1
end function

public function string wf_depot_gubun (string sDepotNo);/* 창고의 내수/수출 구분 */
String sJuHanDle

  SELECT "VNDMST"."JUHANDLE"  
    INTO :sJuHanDle  
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :sDepotNo   ;

If IsNull(sJuHanDle  ) or sJuHanDle  = '' then
	sJuHanDle  = '1'
End If

Return sJuHanDle
end function

public function long wf_calc_validqty (integer nrow);/* 현재 데이타원도우상에서 가용재고 수량 */
String sItnbr ,sIspec
double dValidQty, dChoiceQty
Long   ix

If nRow > dw_cust_lst.RowCount() Then Return 0

sItnbr = Trim(dw_cust_lst.GetItemString(nRow,'itnbr'))
sIspec = Trim(dw_cust_lst.GetItemString(nRow,'order_spec'))
dValidQty = dw_cust_lst.GetItemNumber(nRow,'valid_qty')

For ix = 1 To dw_cust_lst.RowCount()
	If ix = nRow Then continue
	
	If sItnbr = Trim(dw_cust_lst.GetItemString(ix,'itnbr')) and &
	   sIspec = Trim(dw_cust_lst.GetItemString(ix,'order_spec')) then
		
		dValidQty -= dw_cust_lst.GetItemNumber(ix,'choice_qty')
	End If
Next

Return dValidQty

end function

public subroutine wf_init ();String sNull

rollback;

SetNull(sNull)

dw_cust_lst.Reset()
dw_haldang.Reset()
dw_head.Reset()
dw_head.InsertRow(0)

IF rb_perform.Checked = True THEN
	
	ST_TITLE.Text = '수주 현황'
	
	dw_cust_lst.Visible  = True
	dw_haldang.Visible   = False
	dw_input.object.t_8.Visible = True
	
	w_mdi_frame.sle_msg.text = '할당 처리 작업'
	
	dw_input.SetItem(1,"holddate",is_today)
//	dw_input.Modify("saupj_t.visible = 1")
//	dw_input.Modify("saupj.visible = 1")
ELSE
	ST_TITLE.Text = '할당 현황'
	
	dw_cust_lst.Visible  = False
	dw_haldang.Visible = True
	cbx_select.Checked = False
	dw_input.object.t_8.Visible = False
	
	w_mdi_frame.sle_msg.text = '할당 취소 작업'
	dw_input.SetItem(1,"holddate",is_today)
//	dw_input.Modify("saupj_t.visible = 0")
//	dw_input.Modify("saupj.visible = 0") 
END IF

is_Ret = 'N'
dw_input.SetColumn("depot_no")
dw_input.SetFocus()

ib_any_typing = False
end subroutine

on w_sal_02030.create
int iCurrent
call super::create
this.r_1=create r_1
this.rb_perform=create rb_perform
this.rb_cancel=create rb_cancel
this.cbx_select=create cbx_select
this.st_title=create st_title
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_head=create dw_head
this.dw_cust_lst=create dw_cust_lst
this.dw_haldang=create dw_haldang
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_1
this.Control[iCurrent+2]=this.rb_perform
this.Control[iCurrent+3]=this.rb_cancel
this.Control[iCurrent+4]=this.cbx_select
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.dw_head
this.Control[iCurrent+9]=this.dw_cust_lst
this.Control[iCurrent+10]=this.dw_haldang
end on

on w_sal_02030.destroy
call super::destroy
destroy(this.r_1)
destroy(this.rb_perform)
destroy(this.rb_cancel)
destroy(this.cbx_select)
destroy(this.st_title)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_head)
destroy(this.dw_cust_lst)
destroy(this.dw_haldang)
end on

event open;call super::open;dw_input.SetTransObject(SQLCA)
dw_input.InsertRow(0)

dw_head.SetTransObject(SQLCA)
dw_head.InsertRow(0)

dw_cust_lst.SetTransObject(SQLCA)
dw_cust_lst.Reset()

dw_haldang.SetTransObject(SQLCA)
dw_haldang.Reset()

rb_perform.Checked = True
rb_perform.TriggerEvent(Clicked!)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam,saupj) = 1 Then
	dw_input.Modify("sarea.protect=1")
	dw_input.Modify("sarea.background.color = 80859087")
End If
dw_input.SetItem(1, 'sarea', sarea)
	
Wf_Init()

// 부가세 사업장 설정
f_mod_saupj  (dw_input, 'saupj')
f_child_saupj(dw_input, 'depot_no', gs_saupj)
f_child_saupj(dw_input, 'sarea', gs_saupj)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65

dw_cust_lst.width = this.width - 70
dw_cust_lst.height = this.height - dw_cust_lst.y - 70

dw_haldang.width = this.width - 70
dw_haldang.height = this.height - dw_haldang.y - 70.

r_head.width = this.width - 60
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", true) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sal_02030
integer x = 3223
integer y = 2952
integer taborder = 70
end type

type sle_msg from w_inherite`sle_msg within w_sal_02030
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_02030
end type

type st_1 from w_inherite`st_1 within w_sal_02030
integer x = 87
integer y = 2804
end type

type p_search from w_inherite`p_search within w_sal_02030
integer x = 2149
integer y = 3236
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;String docname, sCust, sPlanDate, sWeekDate, sMsg, sCustName, sReturn, sDate, eDate, stemp, sLine, sModel
Int	 li_filenum, irtn
Long   nCnt, icust, ix, iy, irow, nfind
Dec	 nQty
String sSaupj

If dw_input.AcceptText() <> 1 Then Return

sPlanDate	= Trim(dw_input.GetItemString(1,'rqdat'))
If f_datechk(sPlanDate) <> 1 Then
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_input.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_input.SetFocus()
	dw_input.SetColumn('saupj')
	Return -1
End If

If  MessageBox("자료생성", '주간계획으로부터 출하의뢰 자료를 일괄생성합니다.', Exclamation!, OKCancel!, 1) = 2 Then Return

/* 고객별 출하의뢰 자료 생성 */
sMsg = ''

// 주간계획 수립일자 조회
SELECT MIN(WEEK_SDATE) INTO :sWeekDate FROM PDTWEEK 
 WHERE WEEK_YEAR = SUBSTR(:sPlanDate,1,4) 
	AND WEEK_YEAR_JUCHA = (SELECT WEEK_YEAR_JUCHA FROM PDTWEEK WHERE WEEK_SDATE <= :sPlanDate AND WEEK_EDATE >= :sPlanDate );
		
w_mdi_frame.sle_msg.text = sCustName +": 주간계획에서 자료를 읽어옵니다.!!"
			
SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM
 WHERE SAUPJ = :sSaupj
	AND YYMMDD = :sWeekDate
	AND CNFIRM IS NOT NULL;

// 고객구분 'A' :GMDAT
sCust = 'A'

If nCnt > 0 Then
	iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
	If iRtn <> 1 Then
		RollBack;
		MessageBox('확인', '생성실패')
	Else
		COMMIT;
		MessageBox('확인', '정상완료')
	End If
Else
	MessageBox('확인', '주간계획 미마감')
End If
end event

type p_addrow from w_inherite`p_addrow within w_sal_02030
integer x = 3835
integer y = 2984
end type

type p_delrow from w_inherite`p_delrow within w_sal_02030
integer x = 4009
integer y = 2984
end type

type p_mod from w_inherite`p_mod within w_sal_02030
integer x = 3758
integer y = 3232
end type

event p_mod::clicked;call super::clicked;String  sSqlSynTax,sDepotNo,sholddate,sOut_gu,sNaougu, sCheckOption, sHoldNo
Integer iRtnValue,nCnt,k,Pcnt,nRow
Double  dChoiceQty,dHoldRemainQty,djunpoyNo,dCanCelQty,dHoldQty, dIoReQty
string  sOrder_No, sOrder_spec, sItnbr, sHoldStock_No, sHoldStock_JpGbn, ls_rqdat

IF Wf_RequiredChk(1) = -1 THEN RETURN

/* 할당처리 */
IF rb_perform.Checked = True THEN
	/* 분할할당일 경우 분할자료 분리여부 :'Y'일경우 분리*/
	select substr(dataname,1,1) into :sCheckOption
	  from syscnfg
	 where sysgu = 'S' and
   	    serial = 1 and
      	 lineno = 60;
		 
	IF Wf_RequiredChk(1) = -1 THEN RETURN
	
	If dw_cust_lst.AcceptText() <> 1 Then Return
	
	If dw_cust_lst.RowCount() <= 0 Then Return
		
	IF MessageBox("확 인",rb_perform.Text +" 를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

   dw_haldang.Reset()
   nCnt = dw_cust_lst.RowCount()
	If nCnt <= 0 Then Return
	
	/* 전표번호 채번 */
	sHoldStock_JpGbn = 'B0'
	sHoldDate = Trim(dw_input.GetItemString(dw_input.GetRow(),'holddate'))
	djunpoyNo = sqlca.fun_junpyo(gs_sabu,sHoldDate,sHoldStock_JpGbn)
	
	IF djunpoyNo <= 0 THEN
		f_message_chk(51,'')
		rollback;
		Return -1
	END IF
   commit;
	sHoldNo = sHoldDate + String(djunpoyNo,'0000')
	
   /* 창고 */
   sDepotNo = Trim(dw_input.GetItemString(dw_input.GetRow(),'depot_no'))
	
   Pcnt = 0
	FOR k = 1 To nCnt
	  	IF dw_cust_lst.GetItemString(k,"flag_choice") <> 'Y' THEN continue
		 
     		dChoiceQty = dw_cust_lst.GetItemNumber(k,"choice_qty")
	  	If 	dChoiceQty <= 0 Then Continue

     /* 수주번호 */
     		sOrder_no   = dw_cust_lst.GetItemString(k,'order_no')
     		sOrder_spec = dw_cust_lst.GetItemString(k,'order_spec')
	  	sItnbr      = dw_cust_lst.GetItemString(k,'itnbr')

	  /* 분할일 경우 분리조건이면 새로운 할당자료를 생성한다 */
	  	If 	sCheckOption <> 'Y' Then
		  /* 같은 수주번호로 이미 할당되어 있으면 수량만 update */
			  select nvl(hold_qty,0)    into :dHoldQty
				 from holdstock 
				where out_chk = '1' and
						hold_qty > 0 and
						order_no = :sOrder_No and
						itnbr    = :sItnbr and
						pspec    = :sOrder_Spec ;
					
		  	If 	Sqlca.sqlcode = -1 Then
			  	MessageBox('Error','분할자료 저장중 오류')
			  	rollback;
			  	Return
		  	End If
		  
		  	If 	dHoldQty > 0 Then
			 	update holdstock
				   set hold_qty = hold_qty + :dChoiceQty
			  	where order_no = :sOrder_no and
					  itnbr    = :sItnbr and
					  pspec    = :sOrder_Spec and
					  out_chk = '1';
	
				 If 	sqlca.sqlcode <> 0 Then
					MessageBox(string(dHoldQty)+' '+string(dChoiceQty),sqlca.sqlerrtext)
					Rollback;
					f_message_chk(89,'[수주번호 :'+sOrder_no+']')
					Return -1
				 End If
	  
			 	Continue
		  	End If
     		End If
	  
     /* 출고,출문구분 */
     sOut_gu = dw_cust_lst.GetItemString(k,'out_gu')
     select naougu into :sNaougu
      from iomatrix 
     where iogbn = :sOut_gu;

		Pcnt += 1
		If Pcnt > 999 Then
			MessageBox('확 인','할당건수가 1000건이 넘었습니다.!!')
			Exit
		End If
		
  		sHoldStock_No = sHoldDate + String(djunpoyNo,'0000') + String(Pcnt,'000')

     	nRow = dw_haldang.InsertRow(0)
	  dw_haldang.SetItem(nRow,'sabu',       gs_sabu )
	  dw_haldang.SetItem(nRow,'hold_no',    sHoldStock_no )
	  dw_haldang.SetItem(nRow,'hold_date',  sHoldDate )
	  dw_haldang.SetItem(nRow,'hold_gu',    dw_cust_lst.GetItemString(k,'out_gu') )
	  dw_haldang.SetItem(nRow,'itnbr',      sItnbr )
	  dw_haldang.SetItem(nRow,'pspec',      sOrder_spec )
	  dw_haldang.SetItem(nRow,'hold_qty',   dChoiceQty )
	  dw_haldang.SetItem(nRow,'addqty',     0 )
	  dw_haldang.SetItem(nRow,'isqty',      0 )
	  dw_haldang.SetItem(nRow,'unqty',      0 )
     dw_haldang.SetItem(nRow,'out_store',  sDepotNo )
	  dw_haldang.SetItem(nRow,'req_dept',   dw_cust_lst.GetItemString(k,'cvcod') )
	  dw_haldang.SetItem(nRow,'order_no',   sOrder_no )
	  dw_haldang.SetItem(nRow,'out_chk',    '1' )
	  dw_haldang.SetItem(nRow,'cancelqty',  0 )
	  dw_haldang.SetItem(nRow,'in_store',   dw_cust_lst.GetItemString(k,'house_no') )	/* 납품창고 */
	  dw_haldang.SetItem(nRow,'hosts',      'N')
	  dw_haldang.SetItem(nRow,'naougu',     sNaougu)
	  dw_haldang.SetItem(nRow,'hyebia2',    dw_cust_lst.GetItemString(k,'cust_no') )	   /* 하치장 */
//	  dw_haldang.SetItem(nRow,'rqdat',      dw_cust_lst.GetItemString(k,'cust_napgi'))
   	If 	LsRqdat <> "" 	then
	  	dw_haldang.SetItem(nRow,'rqdat',      LsRqdat)
	End If  
	  dw_haldang.SetItem(nRow,'opseq',      '9999')
	NEXT
	
	// 헤더정보를 저장
	dw_head.SetItem(1, 'sabu', gs_sabu)
	dw_head.SetItem(1, 'hold_no', sHoldNo)
End If

/* 할당취소 */
If 	rb_cancel.Checked = True Then
	If 	dw_haldang.AcceptText() <> 1 Then Return
	If 	dw_haldang.RowCount() <= 0 Then Return
	
	IF 	MessageBox("확 인",rb_cancel.Text +" 를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN	

   	nCnt = dw_haldang.RowCount()
	FOR 	k = 1 TO nCnt
		IF 	dw_haldang.GetItemString(k,"flag_choice") = 'Y' THEN
			// 출고요구일 입력..
			If 	LsRqdat <> "" 	then
	  			dw_haldang.SetItem(k ,'rqdat',      LsRqdat)
			End If
			
			// 수량 정정처리.
			dHoldRemainQty = dw_haldang.GetItemNumber(k,"valid_qty")
			IF 	IsNull(dHoldRemainQty) THEN dHoldRemainQty =0
			
			dChoiceQty = dw_haldang.GetItemNumber(k,"choice_qty")
			IF 	IsNull(dChoiceQty) THEN dChoiceQty =0
			
			dCancelQty = dw_haldang.GetItemNumber(k,"cancelqty")
			If 	IsNull(dCancelQty ) Then dCancelQty = 0

			/* 분할출고의뢰 건수 */
			dIoReQty = dw_haldang.GetItemNumber(k,"ioreqty")
			If 	IsNull(dIoReQty ) Then dIoReQty = 0
			
			/* 분할출고건이 존재할경우 할당분할취소 */
			If 	dIoReQty > 0 Then
				dw_haldang.SetItem(k,'cancelqty',dCancelQty + dChoiceQty)
			/* 전량 취소 */
			ElseIf dHoldRemainQty = dChoiceQty Then
				dw_haldang.SetItem(k,'out_chk','3')
				dw_haldang.SetItem(k,'cancelqty',dCancelQty + dChoiceQty)
//				dw_haldang.SetItem(k,'hosts','Y')
			/* 분할 취소 */
			ElseIf dHoldRemainQty - dChoiceQty > 0 Then
				dw_haldang.SetItem(k,'cancelqty',dCancelQty + dChoiceQty)
			End If
		END IF
	NEXT
END IF

/* 오류발생(데드록)시 3번 update 시도 */
For k = 1 To 3
  	iRtnValue = dw_haldang.Update()
	If	iRtnValue = 1 Then Exit
Next

IF iRtnValue <> 1 THEN
  	f_message_chk(41,string(sqlca.sqlcode)+sqlca.sqlerrtext)
  	rollback;
  	Return
//ElseIf dw_head.Update() <> 1 Then
//  	f_message_chk(41,string(sqlca.sqlcode)+sqlca.sqlerrtext)
//  	rollback;
//  	Return	
END IF

Commit;

is_Ret = 'Y'
p_inq.TriggerEvent(Clicked!)
sle_msg.text = '자료를 처리하였습니다!!'

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sal_02030
integer x = 4137
integer y = 3024
end type

type p_inq from w_inherite`p_inq within w_sal_02030
integer x = 3584
integer y = 3232
end type

event p_inq::clicked;call super::clicked;String sCust,sItemCls,sArea,sItnbr,sOutGu, sHoldDate, sSaupj, sSugugb

If dw_input.AcceptText() <> 1 Then Return

IF Wf_RequiredChk(1) = -1 THEN RETURN

sArea    = dw_input.GetItemString(1,"sarea")
sCust    = Trim(dw_input.GetItemString(1,"cust_cd"))
sItnbr    = Trim(dw_input.GetItemString(1,"itnbr"))
//sOutGu    = Trim(dw_input.GetItemString(1,"out_gu"))     //050719 OPTION 삭제 HJP
sHoldDate = Trim(dw_input.GetItemString(1,"holddate"))
sSaupj    = Trim(dw_input.GetItemString(1,"saupj"))
sSugugb	 = Trim(dw_input.GetItemString(1,"sugugb"))    //050719 OPTION 삭제 HJP

IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_input.SetColumn("saupj")
	dw_input.SetFocus()
	Return -1
END IF

IF sSugugb = "" OR IsNull(sSugugb) THEN
	f_message_chk(30,'[수주구분]')
	dw_input.SetColumn('sugugb')
	dw_input.SetFocus()
	Return -1
END IF

//IF rb_perform.Checked = True And (sCust = "" OR IsNull(sCust)) THEN
//	f_message_chk(30,'[거래처]')
//	dw_input.SetColumn('cust_cd')
//	dw_input.SetFocus()
//	Return -1
//END IF

IF sArea ="" OR IsNull(sArea) THEN	sArea = ''
IF sCust ="" OR IsNull(sCust) THEN	sCust = ''
IF sOutGu ="" OR IsNull(sOutGu) THEN sOutGu = ''
IF sHoldDate ="" OR IsNull(sHoldDate) THEN sHoldDate = '99999999'

IF IsNull(sItemCls) or sItemCls = '' THEN	sItemCls = ''
IF IsNull(sItnbr) or sItnbr = '' THEN	sItnbr = ''

SetPointer(HourGlass!)
/*할당 처리*/
IF rb_perform.Checked = True THEN
	/* 가용재고 허용여부 */
	select substr(rewapunish,1,1) into :sMinus
	  from vndmst
	 where cvcod = :LsDepotNo;
	
	If IsNull(sMinus) Then sMinus = 'N'
	
	dw_cust_lst.SetRedraw(False)
//	IF dw_cust_lst.Retrieve(gs_sabu,LsDepotNo,sArea+'%',sCust+'%', sSugugb, sItnbr+'%',sOutGu+'%', sSaupj) <=0 THEN
	IF dw_cust_lst.Retrieve(gs_sabu,LsDepotNo,sArea+'%',sCust+'%', sItnbr+'%', sSaupj) <=0 THEN
		If is_Ret = 'N' Then f_message_chk(50,'')
		dw_input.Setfocus()
		dw_cust_lst.SetRedraw(True)
		Return
	END IF
	
	If sMinus = 'Y' Then
		dw_cust_lst.SetFilter('')
	Else
		dw_cust_lst.SetFilter('valid_qty > 0')
	End If
	dw_cust_lst.Filter()
	dw_cust_lst.SetRedraw(True)
ELSE
	
/*할당 취소*/
//	IF dw_haldang.Retrieve(gs_sabu,LsDepotNo,sArea+'%',sCust+'%',sSugugb, sItnbr+'%',sOutGu+'%', sSaupj) <=0 THEN
	IF dw_haldang.Retrieve(gs_sabu,LsDepotNo,sArea+'%',sCust+'%', sItnbr+'%', sSaupj) <=0 THEN
		If is_Ret = 'N' Then f_message_chk(50,'')
		dw_input.Setfocus()
		Return
	END IF	
END IF

IF rb_perform.Checked = True THEN
	dw_cust_lst.SetFocus()
	dw_cust_lst.SetColumn('choice_qty')
Else
	dw_haldang.SetFocus()
	dw_haldang.SetColumn('choice_qty')
End If

dw_head.Reset()
dw_head.InsertRow(0)

cbx_select.Checked = False 
end event

type p_print from w_inherite`p_print within w_sal_02030
integer x = 3950
integer y = 3016
end type

type p_can from w_inherite`p_can within w_sal_02030
integer x = 3634
integer y = 3232
end type

event p_can::clicked;call super::clicked;
Wf_Init()
end event

type p_exit from w_inherite`p_exit within w_sal_02030
integer x = 3986
integer y = 3232
end type

type p_ins from w_inherite`p_ins within w_sal_02030
integer x = 3662
integer y = 2984
end type

type p_new from w_inherite`p_new within w_sal_02030
integer x = 3168
integer y = 3236
end type

type dw_input from w_inherite`dw_input within w_sal_02030
event ue_key pbm_dwnkey
integer x = 14
integer y = 188
integer width = 4631
integer height = 284
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_020301"
end type

event ue_key;string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
  If this.GetColumnName() ="itcls" then
	OpenWithParm(w_ittyp_popup3, this.GetItemString(this.GetRow(),"ittyp"))
	
   str_sitnct = Message.PowerObjectParm	
	
	IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	Return
  end If

	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event itemerror;
Return 1
end event

event itemchanged;String  sDepotNo,sHoldDate, sItemGbn, sItemCls, sItemClsName, snull
String  sItnbr, sItdsc, sIspec, sIttyp, sItcls, sJijil, sIspeccode
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

Long    nRow, ireturn

SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'depot_no', sSaupj)
	/* 창고 선택 */
	Case "depot_no"
		sDepotNo = GetText()
		IF sDepotNo = "" OR IsNull(sDepotNo) THEN RETURN
		
		SELECT "VNDMST"."CVNAS2", "VNDMST"."IPJOGUN"  	INTO :sDepotNo, :sSaupj  
		  FROM "VNDMST"  
		 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[창고]')
			SetItem(1,"depot_no",snull)
			Return 1
		END IF
		
//		SetItem(1, 'saupj', sSaupj)
	/* 할당일자 */
	Case "holddate"
		/* 할당처리일 경우 할당일자 변경 불가 */
//		If rb_perform.Checked = True Then
//			Return 2
//		End If
		
		sHoldDate = Trim(GetText())
		IF sHoldDate ="" OR IsNull(sHoldDate) THEN RETURN
		
		IF f_datechk(sHoldDate) = -1 THEN
			f_message_chk(35,'[할당일자]')
			SetItem(1,"holddate",snull)
			Return 1
		END IF
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 거래처 */
	Case "cust_cd"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cust_name",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cust_cd', sNull)
			SetItem(1, 'cust_name', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea",  		sarea)
			SetItem(1,"cust_name",	scvnas)
		END IF
	/* 거래처명 */
	Case "cust_name"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cust_cd",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cust_cd', sNull)
			SetItem(1, 'cust_name', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cust_cd', sCvcod)
			SetItem(1,"cust_name", scvnas)
			Return 1
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
	/* 규격콛 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
END Choose

end event

event rbuttondown;string sArea,sCvcod, sCvcodNm, sDepotNo, sJuhaldle
Long   nRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cust_cd", "cust_name"
		gs_gubun = '1'
		If GetColumnName() = "cust_name" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cust_cd",gs_code)
		SetColumn("cust_cd")
		TriggerEvent(ItemChanged!)
	Case "itcls"
		OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
		Return
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
		Return
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = this.GetText()
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

ib_any_typing = True
end event

type cb_delrow from w_inherite`cb_delrow within w_sal_02030
boolean visible = false
integer x = 2706
integer y = 3244
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_02030
boolean visible = false
integer x = 2395
integer y = 3244
end type

type dw_insert from w_inherite`dw_insert within w_sal_02030
boolean visible = false
integer x = 201
integer y = 2772
integer width = 311
integer height = 132
integer taborder = 0
borderstyle borderstyle = stylelowered!
end type

type cb_mod from w_inherite`cb_mod within w_sal_02030
boolean visible = false
integer x = 2528
integer y = 2952
integer taborder = 50
boolean enabled = false
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_sal_02030
boolean visible = false
integer x = 471
integer y = 2952
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02030
boolean visible = false
integer x = 2487
integer y = 2952
end type

type cb_inq from w_inherite`cb_inq within w_sal_02030
boolean visible = false
integer x = 78
integer y = 2952
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_02030
boolean visible = false
integer x = 818
integer y = 2952
integer width = 567
string text = "의뢰서출력(&P)"
end type

type cb_can from w_inherite`cb_can within w_sal_02030
boolean visible = false
integer x = 2875
integer y = 2952
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_02030
boolean visible = false
integer x = 2144
integer y = 2952
end type

type gb_10 from w_inherite`gb_10 within w_sal_02030
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02030
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02030
end type

type r_head from w_inherite`r_head within w_sal_02030
long fillcolor = 12639424
integer y = 184
integer width = 4620
integer height = 292
end type

type r_detail from w_inherite`r_detail within w_sal_02030
integer y = 572
integer width = 4562
integer height = 1732
end type

type r_1 from rectangle within w_sal_02030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 32
integer y = 28
integer width = 919
integer height = 144
end type

type rb_perform from radiobutton within w_sal_02030
integer x = 87
integer y = 64
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "할당 처리"
boolean checked = true
end type

event clicked;Wf_Init()

end event

type rb_cancel from radiobutton within w_sal_02030
integer x = 517
integer y = 64
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "할당 취소"
end type

event clicked;Wf_Init()
end event

type cbx_select from checkbox within w_sal_02030
integer x = 4224
integer y = 492
integer width = 370
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "전체 선택"
end type

event clicked;String  sStatus ,sItnbr,sIspec
Long    k,nRow
Double  dHoldRemainQty,dHoldQty,dRemainQty,dValidQty

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

Setpointer(HourGlass!)
IF rb_perform.Checked = True THEN /* 할당 */
	/* 가용재고 Minus 허용함 */
	If sMinus = 'Y' Then
		For k = 1 To dw_cust_lst.RowCount()
			If sStatus = 'Y' Then
				dRemainQty = dw_cust_lst.GetItemNumber(k,"suju_remain")
				IF IsNull(dRemainQty) THEN dRemainQty =0
			
				dw_cust_lst.SetItem(k,"choice_qty",dRemainQty)
			Else
				dw_cust_lst.SetItem(k,"choice_qty",0)
			End If
			dw_cust_lst.SetItem(k,"flag_choice",sStatus)
		Next
	Else
	/* 가용재고 허용안할경우 */
		dw_cust_lst.SetRedraw(False)
		/* 품번별 소트 */
		dw_cust_lst.SetSort('itnbr a,order_spec a,ord_ok_date a,order_no a')
		dw_cust_lst.Sort()
	
		nRow = dw_cust_lst.RowCount()
		FOR k = 1 TO nRow
			If sItnbr <> Trim(dw_cust_lst.GetItemString(k,'itnbr')) or &
				sIspec <> Trim(dw_cust_lst.GetItemString(k,'order_spec')) then
				
				sItnbr = Trim(dw_cust_lst.GetItemString(k,'itnbr'))
				sIspec = Trim(dw_cust_lst.GetItemString(k,'order_spec'))
				
				dValidQty = dw_cust_lst.GetItemNumber(k,'valid_qty')
				IF IsNull(dValidQty) THEN dValidQty =0
			End If
			
			/* 가용재고가 없을경우 할당불가 */
			IF dValidQty <= 0 THEN
				dw_cust_lst.SetItem(k,"flag_choice",'N')
			ELSE
				dRemainQty = dw_cust_lst.GetItemNumber(k,"suju_remain")
				IF IsNull(dRemainQty) THEN dRemainQty =0
		
				IF sStatus = 'Y' THEN
					IF dRemainQty <= dValidQty THEN
						dw_cust_lst.SetItem(k,"choice_qty",dRemainQty)
					ELSE
						dw_cust_lst.SetItem(k,"choice_qty",dValidQty)
					END IF
					
					dValidQty -= dRemainQty
				ELSE
					dw_cust_lst.SetItem(k,"choice_qty",0)
				END IF
				
				dw_cust_lst.SetItem(k,"flag_choice",sStatus)
			END IF
			sle_msg.Text = string(k)+'/'+string(nRow) + ' 처리중...'
		NEXT
		dw_cust_lst.SetSort('ord_ok_date a,order_no a')
		dw_cust_lst.Sort()
		dw_cust_lst.SetRedraw(True)
	End If
ELSE
	FOR k = 1 TO dw_haldang.RowCount()
		IF sStatus = 'Y' THEN
			dHoldRemainQty = dw_haldang.GetItemNumber(k,"valid_qty")
			IF IsNull(dHoldRemainQty) THEN dHoldRemainQty =0
			
			dw_haldang.SetItem(k,"choice_qty",dHoldRemainQty)
			dw_haldang.SetItem(k,"flag_choice",  sStatus)
		ELSE
			dw_haldang.SetItem(k,"choice_qty", 0)
			dw_haldang.SetItem(k,"flag_choice",sStatus)
		END IF
	NEXT
END IF

sle_msg.text = ''
end event

type st_title from statictext within w_sal_02030
integer x = 78
integer y = 528
integer width = 311
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pic_cal within w_sal_02030
integer x = 1810
integer y = 272
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('rqdat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'rqdat', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_02030
integer x = 1810
integer y = 356
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('holddate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'holddate', gs_code)

end event

type dw_head from u_key_enter within w_sal_02030
boolean visible = false
integer x = 41
integer y = 1748
integer width = 3328
integer height = 532
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_020304"
borderstyle borderstyle = stylelowered!
end type

event itemchanged;call super::itemchanged;String sCvcod, scvnas, sarea, steam, sSaupj, sName1, snull

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "frcust"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'frcust', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas2",	scvnas)
		END IF
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;string sArea,sCvcod, sCvcodNm, sDepotNo, sJuhaldle
Long   nRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 거래처 */
	Case "frcust"
		Open(w_vndmst_popup)		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"frcust",gs_code)
		SetItem(1,"cvnas2",gs_codename)
End Choose
end event

type dw_cust_lst from u_d_popup_sort within w_sal_02030
integer x = 37
integer y = 576
integer width = 4549
integer height = 1724
integer taborder = 20
string dataobject = "d_sal_020302"
boolean border = false
end type

event itemerror;Return 1
end event

event itemchanged;String  sFlag
Dec  dRemainQty,dValidQty,dChoiceQty, dMinQty, dMaxQty, dNapQty, dOrderQty
Integer nRow
Long	  nNapQty

nRow = GetRow()
If nRow <= 0 Then Return

IF GetColumnName() = "flag_choice" THEN
	sFlag = GetText()
	
	dRemainQty = GetItemNumber(nRow,"suju_remain")
	IF IsNull(dRemainQty) THEN dRemainQty =0
	
	dValidQty = wf_calc_validqty(nRow)
	IF IsNull(dValidQty) THEN dValidQty =0
	
	IF sFlag = 'Y' THEN
		/* 가용재고 Minus 허용함 */
		If sMinus = 'Y' Then
			SetItem(nRow,"choice_qty",dRemainQty)
		Else			
			IF dRemainQty <= dValidQty THEN
				SetItem(nRow,"choice_qty",dRemainQty)
			ELSE
				SetItem(nRow,"choice_qty",dValidQty)
			END IF
		End If
	ELSE
		SetItem(nRow,"choice_qty",0)
	END IF
END IF

/* 할당수량 */
IF GetColumnName() = "choice_qty" THEN
	dChoiceQty = Double(GetText())

	/* 납품배수 */
	nNapQty = GetItemNumber(nRow, 'napqty')
	If IsNull(nNapqty) Or nNapQty = 0 Then
	Else
		If Mod(dChoiceQty, nNapQty) <> 0 Then
			MessageBox('확 인','수량조정은 납품배수 범위내에서 가능합니다.!!~n~n납품배수 : ' +string(nNapQty) +'배수')
			Return 2
		End If
	End If
	
	dValidQty = wf_calc_validqty(nRow)
	IF IsNull(dValidQty) THEN dValidQty =0

	/* 가용재고 Minus 허용함 */
	IF sMinus = 'N' And dValidQty < dChoiceQty THEN
		f_message_chk(57,'[가용재고수량 < 할당수량]')
		Return 2
	END IF

	dMinQty = GetItemNumber(nRow,"minqty")
	IF IsNull(dMinQty) THEN dMinQty =0

	dMaxQty = GetItemNumber(nRow,"maxqty")
	IF IsNull(dMaxQty) THEN dMaxQty =0

	dOrderQty = GetItemNumber(nRow,"order_qty")
	IF IsNull(dOrderQty) THEN dOrderQty =0
	
	dRemainQty = GetItemNumber(nRow,"hold_qty")
	IF IsNull(dRemainQty) THEN dRemainQty =0
	
//	IF ( dOrderQty + dMaxQty ) < (dRemainQty + dChoiceQty) Or ( dOrderQty - dMinQty ) > ( dRemainQty + dChoiceQty) THEN
	IF ( dOrderQty + dMinQty ) < (dRemainQty + dChoiceQty) THEN
		MessageBox('확 인','[할당수량 조정은 수주수량(절대수) 범위내에서 가능합니다.]')
		Return 2
	END IF

   If dChoiceQty = 0 Then
		SetItem(nRow,'flag_choice','N')
	Else
		SetItem(nRow,'flag_choice','Y')
	End If
END IF

/* 할당수량 */
IF GetColumnName() = "order_spec" THEN
	sFlag = GetText()
	if IsNull( sFlag ) or sFlag = '' then
		setitem(nrow, "order_spec", '.')
		return 2
	End if

end if;
end event

event rbuttondown;call super::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 (수정)*/
	Case "hyebia2"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"hyebia2",gs_code)
	/* 거래처 (입력)*/
	Case "CUST_NO"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"CUST_NO",gs_code)
END Choose

end event

event clicked;call super::clicked;if dw_cust_lst.RowCount() = 0 then return

dw_cust_lst.SelectRow(0, False)
dw_cust_lst.SelectRow(row, true)
end event

type dw_haldang from u_d_popup_sort within w_sal_02030
integer x = 37
integer y = 576
integer width = 4549
integer height = 1724
integer taborder = 30
string dataobject = "d_sal_020303"
boolean border = false
end type

event itemchanged;String  sFlag, sHoldNo
DEC  dChoiceQty,dHoldRemainQty, nNapQty
Integer nRow

nRow = this.GetRow()

Choose Case GetColumnName() 
  Case "flag_choice"
	sFlag = this.GetText()
	
	dHoldRemainQty = this.GetItemNumber(nRow,"valid_qty")
	IF IsNull(dHoldRemainQty) THEN dHoldRemainQty =0
	
	IF sFlag = 'Y' THEN
		this.SetItem(nRow,"choice_qty",dHoldRemainQty)
	ELSE
		this.SetItem(nRow,"choice_qty",0)
	END IF
 /* 취소수량 */
 Case 'choice_qty'
	dChoiceQty = Double(GetText())

	/* 납품배수 */
	nNapQty = GetItemNumber(nRow, 'napqty')
	If IsNull(nNapqty) Or nNapQty = 0 Then
	Else
		If Mod(dChoiceQty, nNapQty) <> 0 Then
			MessageBox('확 인','수량조정은 납품배수 범위내에서 가능합니다.!!~n~n납품배수 : ' +string(nNapQty) +'배수')
			Return 2
		End If
	End If
	
	dHoldRemainQty = this.GetItemNumber(nRow,"valid_qty")
	IF IsNull(dHoldRemainQty) THEN dHoldRemainQty =0
	
	If dHoldRemainQty < dChoiceQty Then
		f_message_chk(57,'[할당수량 < 취소수량]')
		Return 2
	End If
	
   If dChoiceQty = 0 Then
		this.SetItem(nRow,'flag_choice','N')
	Else
		this.SetItem(nRow,'flag_choice','Y')
	End If
END Choose

end event

event itemerror;
Return 1
end event

event editchanged;sle_msg.text = ''
end event

event updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event clicked;call super::clicked;if row <= 0 then return

dw_haldang.selectRow(0, false)
dw_haldang.selectRow(row, true)

// 박스헤더정보 조회
String sHoldNo

sHoldNo = Left(GetItemString(row, 'hold_no'),12)
If dw_head.Retrieve(gs_sabu, sHoldNo) <= 0 Then
	dw_head.InsertRow(0)
	dw_head.SEtitem(1, 'sabu', gs_sabu)
	dw_head.SEtitem(1, 'hold_no', sHoldNo)
End If
end event

