$PBExportHeader$w_pdt_05025.srw
$PBExportComments$외주처 기초재고 등록(외주자료가 진행중일 때 사용)--삭제요구
forward
global type w_pdt_05025 from w_inherite
end type
end forward

global type w_pdt_05025 from w_inherite
string title = "외주처 기초재고 등록"
end type
global w_pdt_05025 w_pdt_05025

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_dup_chk ()
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'pspec')) or &
	dw_insert.GetItemString(i,'pspec') = '' then
	dw_insert.SetItem(i, 'pspec', '.')
end if	

if isnull(dw_insert.GetItemString(i,'opseq')) or &
	dw_insert.GetItemString(i,'opseq') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  공정순서]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'iwol_stock_qty')) then
	f_message_chk(1400,'[ '+string(i)+' 행  이월수량]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('iwol_stock_qty')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'iwol_stock_amt')) then
	f_message_chk(1400,'[ '+string(i)+' 행  이월금액]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('iwol_stock_amt')
	dw_insert.SetFocus()
	return -1		
end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_input.setredraw(false)

dw_insert.reset()
dw_input.reset()

dw_input.insertrow(0)
dw_input.setitem(1, 'yymm', left(is_today, 6))
dw_input.setfocus()

dw_input.setredraw(true)
dw_insert.setredraw(true)


end subroutine

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind

FOR k = dw_insert.rowcount() TO 1 step - 1
   sfind = dw_insert.getitemstring(k, 'sdup')

	lReturnRow = dw_insert.Find("sdup = '"+sfind+"' ", 1, dw_insert.RowCount())
	
	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번/사양/공정]')
		dw_insert.Setrow(k)
		dw_insert.Setcolumn('itnbr')
		dw_insert.setfocus()
		RETURN  -1
	END IF
NEXT

return 1
end function

on w_pdt_05025.create
call super::create
end on

on w_pdt_05025.destroy
call super::destroy
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_input.SetTransObject(sqlca)

dw_input.insertrow(0)

dw_input.setitem(1, 'yymm', left(is_today, 6))

dw_input.SetFocus()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", true) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", true) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", true) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", true) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", true) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = true //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = true //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)

end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)

end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)

end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)

end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_05025
integer x = 3141
integer y = 5000
end type

type sle_msg from w_inherite`sle_msg within w_pdt_05025
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_05025
end type

type st_1 from w_inherite`st_1 within w_pdt_05025
end type

type p_search from w_inherite`p_search within w_pdt_05025
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_05025
integer y = 5000
end type

type p_delrow from w_inherite`p_delrow within w_pdt_05025
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_05025
integer x = 3899
end type

event p_mod::clicked;call super::clicked;string sdepot, syymm, sitnbr, spspec, get_nm, sopseq, sopt
long i, k
dec  dqty

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

sdepot = dw_input.getitemstring(1, 'cvcod')
syymm  = dw_input.getitemstring(1, 'yymm')

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中........."

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN 
      w_mdi_frame.sle_msg.text = ""
		RETURN
	END IF	
NEXT

w_mdi_frame.sle_msg.text = "자료 중복 여부 확인 中........."

if wf_dup_chk() = -1 then 
   w_mdi_frame.sle_msg.text = ""
	return 
END IF

w_mdi_frame.sle_msg.text = ""
IF Messagebox('저 장','저장 하시겠습니까?'  +'~n~n'+&
  '저장하시면 새로입력하신 창고, 품번, 사양, 공정에 대한 이월수량이 외주처 재고수량으로 '  +'~n'+&
  '모두 새로 입력됩니다.', Question!,YesNo!,1) = 2 THEN
   Return 
END IF

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 저장 中........."

if dw_insert.update() = 1 then
   w_mdi_frame.sle_msg.text = "외주처 재고자료 조정 中........."
	FOR k = 1 TO dw_insert.rowcount()
		sitnbr = dw_insert.getitemstring(k, 'itnbr')
		spspec = dw_insert.getitemstring(k, 'pspec')
		sOpseq = dw_insert.getitemstring(k, 'opseq')
		sOpt   = dw_insert.getitemstring(k, 'opt')
		dqty   = dw_insert.getitemDecimal(k, 'iwol_stock_qty')

      IF sOpt = 'I' then 
		  SELECT "STOCK_VENDOR"."CVCOD"  
			 INTO :get_nm  
			 FROM "STOCK_VENDOR"  
			WHERE ( "STOCK_VENDOR"."CVCOD" = :sdepot ) AND  
					( "STOCK_VENDOR"."ITNBR" = :sitnbr ) AND  
					( "STOCK_VENDOR"."PSPEC" = :spspec ) AND  
					( "STOCK_VENDOR"."OPSEQ" = :sopseq )   ;
	
		  IF SQLCA.SQLCODE = 0 THEN 
			
				UPDATE STOCK_VENDOR  
					SET JEGO_QTY = :dqty  
				 WHERE ( CVCOD = :sdepot ) AND ( ITNBR = :sitnbr ) AND  
						 ( PSPEC = :spspec ) AND ( OPSEQ = :sopseq )  ;
	
		  ELSEIF SQLCA.SQLCODE = 100 THEN 	
			  INSERT INTO STOCK_VENDOR  
				( CVCOD,      ITNBR,      PSPEC,     OPSEQ,     JEGO_QTY)  
			  VALUES
				(  :sdepot,   :sitnbr,    :spspec,   :sopseq,   :dqty   )  ;
				
		  END IF
	
		  IF SQLCA.SQLNROWS < 1 THEN 
			  rollback ;
			  w_mdi_frame.sle_msg.text = ""
			  messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
			  return 
		  END IF	 
	  END IF	 
			
   NEXT

	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   w_mdi_frame.sle_msg.text = ""
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

p_inq.TriggerEvent(Clicked!)



end event

type p_del from w_inherite`p_del within w_pdt_05025
integer x = 4073
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long i, irow, irow2
string sdepot, sitnbr, spspec, sopseq

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中........."

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN
 		   w_mdi_frame.sle_msg.text = ""
			RETURN
		END IF	
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN 
		w_mdi_frame.sle_msg.text = ""
		RETURN
	END IF	
NEXT

w_mdi_frame.sle_msg.text = ""

if f_msg_delete() = -1 then return

sdepot = dw_insert.getitemstring(dw_insert.getrow(), 'cvcod')
sitnbr = dw_insert.getitemstring(dw_insert.getrow(), 'itnbr')
spspec = dw_insert.getitemstring(dw_insert.getrow(), 'pspec')
sOpseq = dw_insert.getitemstring(dw_insert.getrow(), 'opseq')

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	UPDATE STOCK_VENDOR  
		SET JEGO_QTY = 0  
	 WHERE ( CVCOD = :sdepot ) AND  ( ITNBR = :sitnbr ) AND  
			 ( PSPEC = :spspec ) AND  ( OPSEQ = :sopseq )  ;

   IF SQLCA.SQLNROWS < 1 THEN 
	   rollback ;
	   w_mdi_frame.sle_msg.text = ""
	   messagebox("삭제실패", "자료에 대한 삭제가 실패하였읍니다.")
	   return 
   END IF	 

	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_inq from w_inherite`p_inq within w_pdt_05025
integer x = 3552
end type

event p_inq::clicked;call super::clicked;string s_yymm, s_depot

if dw_input.AcceptText() = -1 then return 

s_yymm = trim(dw_input.GetItemString(1,'yymm'))
s_depot = trim(dw_input.GetItemString(1,'cvcod'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_input.SetColumn('yymm')
	dw_input.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[외주처]')
	dw_input.SetColumn('cvcod')
	dw_input.SetFocus()
	return
end if	

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 조회 中........."

if dw_insert.Retrieve(s_yymm, s_depot) <= 0 then 
	dw_input.Setfocus()
	return
else
   dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
end if	

w_mdi_frame.sle_msg.text = ""
ib_any_typing = FALSE

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If


end event

type p_print from w_inherite`p_print within w_pdt_05025
integer y = 5000
end type

type p_can from w_inherite`p_can within w_pdt_05025
integer x = 4247
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If



end event

type p_exit from w_inherite`p_exit within w_pdt_05025
integer x = 4421
end type

type p_ins from w_inherite`p_ins within w_pdt_05025
integer x = 3726
end type

event p_ins::clicked;call super::clicked;string s_yymm, s_depot
long   i, il_currow, il_rowcount

if dw_input.AcceptText() = -1 then return 

s_yymm  = trim(dw_input.GetItemString(1,'yymm'))
s_depot = dw_input.GetItemString(1,'cvcod')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_input.Setcolumn('yymm')
	dw_input.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[외주처]')
	dw_input.Setcolumn('cvcod')
	dw_input.SetFocus()
	return
end if	

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "자료 유효성 여부 확인 中........."

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'base_yymm', s_yymm )
dw_insert.setitem(il_currow, 'cvcod', s_depot )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

ib_any_typing =True
w_mdi_frame.sle_msg.text = ""

end event

type p_new from w_inherite`p_new within w_pdt_05025
end type

type dw_input from w_inherite`dw_input within w_pdt_05025
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 56
integer width = 3488
integer height = 188
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_05020_a"
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//setnull(gs_code)
//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//		IF This.GetColumnName() = "fr_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"fr_itnbr",gs_code)
//			RETURN 1
//		ELSEIF This.GetColumnName() = "to_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"to_itnbr",gs_code)
//			RETURN 1
//      End If
//END IF
//
end event

event itemerror;//return 1
end event

event rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//if this.GetColumnName() = 'fr_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"fr_itnbr",gs_code)
//elseif this.GetColumnName() = 'to_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"to_itnbr",gs_code)
//end if	
//
end event

event itemchanged;string  snull, s_depot, s_depnm, s_depnm2, sdate
integer ireturn 

setnull(snull)

if this.accepttext() = -1 then return 

IF this.GetColumnName() ="yymm" THEN
	sdate = trim(this.GetText())
	s_depot = this.getitemstring(1, 'cvcod')
	
	if sdate = "" or isnull(sdate) then
      dw_insert.reset()
		return 
   end if
	
  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "yymm", sNull)
      dw_insert.reset()
		return 1
   END IF

	dw_insert.Retrieve(sdate, s_depot) 
	
ELSEIF this.GetColumnName() ="cvcod" THEN
	s_depot = trim(this.GetText())
	sdate   = this.getitemstring(1, 'yymm')
	dw_insert.Retrieve(sdate, s_depot) 
	return ireturn
End if

ib_any_typing = FALSE

end event

event losefocus;if this.accepttext() = -1 then return 

end event

type cb_delrow from w_inherite`cb_delrow within w_pdt_05025
boolean visible = false
end type

type cb_addrow from w_inherite`cb_addrow within w_pdt_05025
boolean visible = false
end type

type dw_insert from w_inherite`dw_insert within w_pdt_05025
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
integer taborder = 40
string dataobject = "d_pdt_05025"
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

choose case key
	case KeyF1! 
   	TriggerEvent(RbuttonDown!)
	case KeyF2! 
		IF This.GetColumnName() = "itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(this.getrow(),"itnbr",gs_code)
			this.TriggerEvent(ItemChanged!)
		End If
	case KeyEnter! 
		if this.getcolumnname() = "iwol_stock_amt" then
			if this.rowcount() = this.getrow() then
				p_ins.postevent(clicked!)
				return 1
			end if
		end if
end choose

end event

event dw_insert::rbuttondown;Long iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "opseq"	THEN
   this.accepttext()

	IF this.GetItemString(iCurRow,"itnbr") = "" OR &
	   IsNull(this.GetItemString(iCurRow,"itnbr")) THEN
		MessageBox("확 인","품번을 먼저 입력하세요!!")
		Return
	ELSE
		OpenWithParm(w_routng_popup, this.GetItemString(iCurRow,"itnbr"))
		
		IF IsNull(Gs_Code) THEN RETURN
		
		this.SetItem(1,"opseq",Gs_Code)
		this.SetItem(1,"opdsc",Gs_CodeName)
		
	END IF					
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, sopseq, sopseqname ,ls_jijil,ls_ispec_code
integer  ireturn
long     lrow

setnull(snull)

lrow   = this.getrow()

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec,ls_jijil,ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	this.SetItem(lrow,"opseq", '9999')
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec,ls_jijil,ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	this.SetItem(lrow,"opseq", '9999')
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec,ls_jijil,ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	this.SetItem(lrow,"opseq", '9999')
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	ls_jijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec,ls_jijil,ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	this.SetItem(lrow,"opseq", '9999')
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	ls_ispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec,ls_jijil,ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	this.SetItem(lrow,"opseq", '9999')
	RETURN ireturn
ELSEIF this.GetColumnName() = "opseq"	THEN
	if this.accepttext() = -1 then return 
	
   sOpseq  = this.gettext()
	sItnbr  = this.GetItemString(lrow,"itnbr")
	
	IF sOpseq ="" OR IsNull(sOpseq) THEN 
		this.SetItem(lrow,"opseq", snull)
		this.SetItem(lrow,"opdsc",snull)
		Return
	END IF
	
	IF sOpseq <> '9999' THEN
		SELECT "ROUTNG"."OPDSC"
		  INTO :sOpSeqName
		  FROM "ROUTNG"
		 WHERE "ROUTNG"."ITNBR" = :sitnbr AND "ROUTNG"."OPSEQ" =:sopseq;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","입력하신 품번으로 등록된 공정순서가 없습니다!!")
			this.SetItem(lrow,"opseq",snull)
			this.SetItem(lrow,"opdsc",snull)
			Return 1
		ELSE
			this.SetItem(lrow,"opdsc",sOpSeqName)
		END IF
	END IF
END IF
end event

type cb_mod from w_inherite`cb_mod within w_pdt_05025
boolean visible = false
integer x = 2085
integer y = 5000
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_pdt_05025
boolean visible = false
integer x = 2446
integer y = 5000
integer height = 100
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_pdt_05025
boolean visible = false
integer x = 2437
integer y = 5000
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_05025
boolean visible = false
integer x = 2094
integer y = 5000
integer height = 100
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_05025
boolean visible = false
integer x = 1984
integer y = 2544
end type

type cb_can from w_inherite`cb_can within w_pdt_05025
boolean visible = false
integer x = 2789
integer y = 5000
integer taborder = 70
end type

type cb_search from w_inherite`cb_search within w_pdt_05025
boolean visible = false
integer x = 2619
integer y = 2532
end type

type gb_10 from w_inherite`gb_10 within w_pdt_05025
integer y = 4996
integer height = 148
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_05025
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_05025
end type

type r_head from w_inherite`r_head within w_pdt_05025
end type

type r_detail from w_inherite`r_detail within w_pdt_05025
end type

type rr_1 from roundrectangle within w_pdt_05025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 184
integer width = 4567
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

