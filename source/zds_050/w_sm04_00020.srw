$PBExportHeader$w_sm04_00020.srw
$PBExportComments$출하 LIST
forward
global type w_sm04_00020 from w_standard_print
end type
type p_mod from picture within w_sm04_00020
end type
type rr_2 from roundrectangle within w_sm04_00020
end type
type rr_1 from roundrectangle within w_sm04_00020
end type
end forward

global type w_sm04_00020 from w_standard_print
string title = "일일 출하 계획"
p_mod p_mod
rr_2 rr_2
rr_1 rr_1
end type
global w_sm04_00020 w_sm04_00020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sdate, edate, sPlnt, sGrpNam, tx_name
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

sPlnt = Trim(dw_ip.GetItemString(1, 'plnt'))
If IsNull(sPlnt) or sPlnt = '.' Then sPlnt = '%'

IF dw_print.Retrieve(sSaupj, syymm, sPlnt) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

//dw_list.Retrieve(sSaupj, syymm, sCust+'%', sGrpNam+'%')
dw_print.sharedata(dw_list)

tx_name = Left(sYymm,4) + '.' + Mid(sYymm,5,2) + '.' + Right(sYymm,2) 
dw_print.Modify("t_sdate.text = '"+tx_name+"'")

return 1
end function

on w_sm04_00020.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm04_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_mod)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')

dw_ip.SetItem(1, 'yymm', is_today)

dw_print.Sharedataoff()
end event

type p_preview from w_standard_print`p_preview within w_sm04_00020
end type

type p_exit from w_standard_print`p_exit within w_sm04_00020
end type

type p_print from w_standard_print`p_print within w_sm04_00020
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm04_00020
end type

event p_retrieve::clicked;if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="1"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_mod.Enabled =False
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'

	p_mod.Enabled =True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)	
end event







type st_10 from w_standard_print`st_10 within w_sm04_00020
end type



type dw_print from w_standard_print`dw_print within w_sm04_00020
integer x = 3319
integer y = 24
string dataobject = "d_sm04_00020_2_PP"
end type

type dw_ip from w_standard_print`dw_ip within w_sm04_00020
integer x = 105
integer y = 96
integer width = 3150
integer height = 96
string dataobject = "d_sm04_00020_1"
end type

event dw_ip::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
	Case 'grpnam'
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm04_00020
integer x = 73
integer y = 264
integer width = 4512
integer height = 2004
string dataobject = "d_sm04_00020_2"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type p_mod from picture within w_sm04_00020
boolean visible = false
integer x = 3465
integer y = 56
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;//String sOrderDate, sPlnt, svndstk, sItnbr, sCvcod, sGidate, host_jpno, sHoldNo
//Long ix,iy, nCnt, nUpd=0, host_iono, host_seqno
//Boolean bOk = False
//Dec	 dIqty,  dOldIQty
//String sSaupj
//
//If dw_list.AcceptText() <> 1 Then Return
//If f_msg_update() <> 1 Then Return
//
//// 출하의뢰일
//sOrderDate = Trim(dw_ip.GetItemString(1, 'yymm'))
//
///* 사업장 체크 */
//sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400, '[사업장]')
//	dw_ip.SetFocus()
//	dw_ip.SetColumn('saupj')
//	Return -1
//End If
//
///* 전표번호 생성 */
//host_iono = 0;
//host_iono = sqlca.fun_junpyo(gs_sabu, sOrderDate, 'S1')
//if host_iono < 1 then
//	return -1
//end if
//
//commit;
//
//host_jpno 	= sOrderDate +string(host_iono,'0000');
//host_seqno	= 0;
//	
//For ix = 1 To dw_list.RowCount()
//	If dw_list.GetItemStatus(ix, 0, Primary!) = DataModified! Or dw_list.GetItemStatus(ix, 0, Primary!) = NewModified!  Then
//		bOk = False
//		
//		// 출하의뢰일 하루만 처리한다
//		For iy = 1 To 1
//			dOldIQty = 0
//			dIqty		= 0
//		
//			If dw_list.GetItemStatus(ix, 'itm_qty'+string(iy), Primary!) = DataModified! Or dw_list.GetItemStatus(ix, 'itm_qty'+string(iy), Primary!) = NewModified! Then
//				bOk = True
//			End If
//			
//			// 수정사항이 존재할 경우
//			If bOk Then
//				nUpd ++
//				
//				sPlnt		= Trim(dw_list.GetItemString(ix, 'plnt'))
//				svndstk	= Trim(dw_list.GetItemString(ix, 'vstk'))
//				sItnbr	= Trim(dw_list.GetItemString(ix, 'itnbr'))
//				sCvcod	= Trim(dw_list.GetItemString(ix, 'cvcod'))
//			
//				dIqty		= dw_list.GetItemNumber(ix, 'itm_qty'+string(iy))
//				
//				// 기준일자
//				sGidate = f_afterday(sOrderDate, iy - 1)
//				
//				SELECT COUNT(*) INTO :nCnt FROM SM04_DAILY_ITEM
//				 WHERE SAUPJ = :sSaupj
//				   AND YYMMDD = :sGidate
//					AND CVCOD = :sCvcod
//					AND ITNBR = :sItnbr
//					AND PLNT = :sPlnt
//					AND VNDSTK = :sVndstk
//					AND GUBUN = '4';
//
//				// 임의로 등록된 수량외
//				SELECT SUM(ITM_QTY1) INTO :dOldIQty FROM SM04_DAILY_ITEM
//				 WHERE SAUPJ = :sSaupj
//				   AND YYMMDD = :sGidate
//					AND CVCOD = :sCvcod
//					AND ITNBR = :sItnbr
//					AND PLNT = :sPlnt
//					AND VNDSTK = :sVndstk
//					AND GUBUN <> '4';
//				If IsNull(dOldIQty) Then dOldIQty = 0
//				
//				dIqty = dIqty - dOldIQty
//				
//				If nCnt > 0  Then
//					UPDATE SM04_DAILY_ITEM
//					   SET ITM_QTY1 = :dIqty
//					 WHERE SAUPJ = :sSaupj
//						AND YYMMDD = :sGidate
//						AND CVCOD = :sCvcod
//						AND ITNBR = :sItnbr
//						AND PLNT = :sPlnt
//						AND VNDSTK = :sVndstk
//						AND GUBUN = '4';
//				Else
//					host_seqno += 1
//					sHoldNo = host_jpno + String(host_seqno,'000')
//					INSERT INTO SM04_DAILY_ITEM
//							  ( SAUPJ,    YYMMDD,   GUBUN,    CVCOD,    ITNBR,    
//							    ITM_PRC, 
//								 ITM_QTY1, ITM_QTY2, ITM_QTY3,  ITM_QTY4, ITM_QTY5, ITM_QTY6, ITM_QTY7, 
//								 CNFIRM,   VNDSTK,   JPROD_QTY, ORDER_NO, PROD_QTY, PLNT,
//								 OUT_CHK,  ISQTY,    HOLD_NO)
//					 VALUES ( :sSaupj, :sGidate, '4', 		:sCvcod,   :sItnbr,
//					          fun_erp100000012_1(to_char(sysdate,'yyyymmdd'), :sCvcod, :sItnbr, '1') ,
//					          :dIqty,   0,        0,         0,        0,        0,        0,
//								 'N',      :sVndstk, 0,         NULL,     0,   :sPlnt,
//								 '1',	     0,        :sHoldNo);
//				End If
//				If SQLCA.SQLCODE <> 0 Then
//					MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
//					RollBack;
//					Return
//				End If
//			End If
//		Next
//	End If
//Next
//
//If nUpd > 0 Then
//	COMMIT;
//	
//	// 재조회후 출력한다
//	p_retrieve.TriggerEvent(Clicked!)
//	
//	If  MessageBox("출력", '출력 하시겠습니까?', Exclamation!, OKCancel!, 1) = 2 Then Return
//
//	p_print.TriggerEvent(Clicked!)
//End If
end event

type rr_2 from roundrectangle within w_sm04_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 59
integer y = 52
integer width = 3227
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm04_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4553
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

