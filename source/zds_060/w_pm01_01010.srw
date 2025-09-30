$PBExportHeader$w_pm01_01010.srw
$PBExportComments$월 판매계획 접수
forward
global type w_pm01_01010 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_01010
end type
type pb_1 from u_pb_cal within w_pm01_01010
end type
type p_1 from picture within w_pm01_01010
end type
type rr_1 from roundrectangle within w_pm01_01010
end type
end forward

global type w_pm01_01010 from w_inherite
string title = "월 판매계획 접수"
dw_1 dw_1
pb_1 pb_1
p_1 p_1
rr_1 rr_1
end type
global w_pm01_01010 w_pm01_01010

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_setnull ()
public subroutine wf_reset ()
public function integer wf_protect (string arg_yymm)
public subroutine wf_jego (string arg_itnbr, integer arg_row)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'monqty1')) or &
	dw_insert.GetItemNumber(i,'monqty1') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty1')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty2')) or &  
	dw_insert.GetItemNumber(i,'monqty2') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+1 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty2')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty3')) or &  
	dw_insert.GetItemNumber(i,'monqty3') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+2 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty3')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'weekqty1')) or &  
	dw_insert.GetItemNumber(i,'weekqty1') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  1주]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty1')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'weekqty2')) or &  
	dw_insert.GetItemNumber(i,'weekqty2') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  2주]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty2')
	dw_insert.SetFocus()
	return -1		
end if

if isnull(dw_insert.GetItemNumber(i,'weekqty3')) or &  
	dw_insert.GetItemNumber(i,'weekqty3') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  3주]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty3')
	dw_insert.SetFocus()
	return -1		
end if
if isnull(dw_insert.GetItemNumber(i,'weekqty4')) or &  
	dw_insert.GetItemNumber(i,'weekqty4') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  4주]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty4')
	dw_insert.SetFocus()
	return -1		
end if
if isnull(dw_insert.GetItemNumber(i,'weekqty5')) or &  
	dw_insert.GetItemNumber(i,'weekqty5') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  5주]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty5')
	dw_insert.SetFocus()
	return -1		
end if

Return 1
end function

public subroutine wf_setnull ();string snull
int    inull
long   lrow

setnull(snull)
setnull(inull)

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	

dw_insert.setitem(lrow, "jaego", inull)
dw_insert.setitem(lrow, "shrat", inull)
dw_insert.setitem(lrow, "minqty", inull)

end subroutine

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

get_yeacha = 1

dw_1.setitem(1, 'jjcha', get_yeacha )
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public function integer wf_protect (string arg_yymm);String syymm, sJoCod
Long   lcount = 1

syymm = Trim(dw_1.GetItemString(1, 'syymm'))
If IsNull(syymm) Or syymm = '' Then lcount = 0

sJoCod = Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sJocod) Or sJocod = '' Then lcount = 0

If lcount = 1 Then
	SELECT COUNT(*) INTO :lcount
	  FROM PM01_MONPLAN_SUM A, ITEMAS B
	 WHERE ( A.SABU = :gs_sabu AND A.MONYYMM = :syymm AND A.MOSEQ = 0 ) AND
			 ( A.ITNBR = B.ITNBR ) AND
			 ( A.JOCOD = :sJocod );
End If
		
if lcount > 0 then 
	messagebox("확 인", "월 생산계획이 확정되어 있으므로 수정 및 삭제 할 수 없습니다.")
	p_addrow.picturename = 'C:\erpman\image\행추가_d.gif'
	p_delrow.picturename = 'C:\erpman\image\행삭제_d.gif'
	p_mod.picturename = 'C:\erpman\image\저장_d.gif'
	p_search.picturename = 'C:\erpman\image\생성_d.gif'
	p_del.picturename = 'C:\erpman\image\삭제_d.gif'
	p_delrow.enabled = false
	p_addrow.enabled = false
	p_mod.enabled = false
	p_search.enabled = false
	p_del.enabled = false
else
	dw_insert.SetFocus()
	p_search.picturename = 'C:\erpman\image\생성_d.gif'
	p_search.enabled = false
	ib_any_typing = FALSE
	p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
	p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
	p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	p_search.picturename = 'C:\erpman\image\생성_up.gif'
	p_del.picturename = 'C:\erpman\image\삭제_up.gif'
	p_addrow.enabled = true
	p_delrow.enabled = true
	p_mod.enabled = true
	p_search.enabled = true
	p_del.enabled = true
end if	

Return 1
end function

public subroutine wf_jego (string arg_itnbr, integer arg_row);////////////////////////////////////////////
/* 품목별로 재고관련 사항을 가져온다.     */
/* 안전재고(MAX), 재고, 할당미처리, 재공재고   */  
////////////////////////////////////////////
String get_itnbr
Dec{3} get_minqt, sum_jego_qty, get_shrat

SELECT "ITEMAS"."ITNBR",    "ITEMAS"."MINQT",  "ITEMAS"."SHRAT", SUM(NVL("STOCK"."JEGO_QTY" , 0))
  INTO :get_itnbr,          :get_minqt,     	  :get_shrat, 		  :sum_jego_qty
  FROM "ITEMAS", "STOCK"  
 WHERE ( "ITEMAS"."ITNBR" = "STOCK"."ITNBR"(+) ) and  
		 ( "ITEMAS"."ITNBR" = :arg_itnbr )  
GROUP BY	 "ITEMAS"."ITNBR", "ITEMAS"."MINQT", "ITEMAS"."SHRAT";
		
if isnull(get_itnbr) then get_itnbr = ''

MessageBox(arg_itnbr , get_itnbr)

if isnull(get_minqt) 	then get_minqt = 0
if isnull(sum_jego_qty) then sum_jego_qty = 0
if isnull(get_shrat) 	then get_shrat = 0

dw_insert.setitem(arg_row, 'minqty',    get_minqt)    //안전재고
dw_insert.setitem(arg_row, 'jaego' ,    sum_jego_qty)  //재고
dw_insert.setitem(arg_row, 'shrat',     get_shrat)    //안전재고

end subroutine

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

on w_pm01_01010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_pm01_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;call super::open;String syymm

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_insert.SetTransObject(sqlca)

///* 최종계획년월 */
//SELECT MAX(MONYYMM) INTO :syymm FROM PM01_MONPLAN_SUM;
//dw_1.SetItem(1, 'syymm', sYymm)
end event

type dw_insert from w_inherite`dw_insert within w_pm01_01010
integer x = 69
integer y = 232
integer width = 4448
integer height = 2028
string dataobject = "d_pm01_01010_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, steam, sjijil, sispeccode, sJocod
integer  ireturn, iseq
long     lrow, lreturnrow
decimal  dItemPrice    //출하단가
Dec	   dQty, dMinQt, dMulqt, dLot

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()
syymm  = dw_1.getitemstring(1, 'syymm')
steam   = dw_1.getitemstring(1, 'steam')
sJocod   = dw_1.getitemstring(1, 'jocod')
iseq   = dw_1.getitemnumber(1, 'jjcha')

Choose Case GetColumnName()
	Case "itnbr"
		sItnbr = trim(this.GetText())
	
		if sitnbr = "" or isnull(sitnbr) then
			wf_setnull()
			return 
		end if	
		//자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN  1
		END IF
		//등록된 자료에서 체크
	  SELECT "PM01_MONPLAN_SUM"."ITNBR"  
		 INTO :get_itnbr  
		 FROM "PM01_MONPLAN_SUM"  
		WHERE ( "PM01_MONPLAN_SUM"."SABU" = :gs_sabu ) AND  
				( "PM01_MONPLAN_SUM"."MONYYMM" = :syymm ) AND  
				( "PM01_MONPLAN_SUM"."ITNBR" = :sitnbr ) AND  
				( "PM01_MONPLAN_SUM"."MOSEQ" = :iseq )   ;
	
		if sqlca.sqlcode <> 0 then 
			ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패		
//			if ireturn = 1 then ireturn = 0 else ireturn = 1		
			this.setitem(lrow, "itnbr", sitnbr)	
			this.setitem(lrow, "itdsc", sitdsc)	
	
			IF ireturn = 0 then
				//생산팀이 등록되였는지 체크
				SELECT "ITEMAS"."ITNBR"
				  INTO :get_itnbr
				  FROM "ITEMAS"
				 WHERE ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
						 ( "ITEMAS"."JOCOD" = :sJocod ) )   ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('확인', '생산팀/반을 확인하세요.!!' ) 
					wf_setnull()
					RETURN 1
				END IF
				
				If IsNull(dMinQt) Then dMinQt = 0
								
				wf_jego(sitnbr, lrow)                //재고내역을 셋팅
	
				dItemPrice = sqlca.Fun_Erp100000012(is_today, syymm, sItnbr)   //판매단가를 가져옴
				this.SetItem(lRow,"mchdan", dItemPrice)
	
				this.Setfocus()
			END IF
			RETURN ireturn
		else
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN 1
		end if	
	Case 'monqty2', 'monqty3'
		dQty = Dec(GetText())
		
		dMinQt = GetItemNumber(lrow, 'minqty')
		dMulQt = GetItemNumber(lrow, 'minqty')
		
		If IsNull(dMinQt) then dMinQt = 0
		If IsNull(dMulQt) Or dMulqt = 0 then dMulQt = 1
		
		dLot = dMinQt + (Ceiling((dQty - dMinQt)/dMulQt) * dMulQt)

		SetItem(lRow, 'monlot'+right(GetColumnName(),1), dLot)
	Case 'weekqty1', 'weekqty2', 'weekqty3', 'weekqty4', 'weekqty5'
		dQty = Dec(GetText())
		
		dMinQt = GetItemNumber(lrow, 'minqty')
		dMulQt = GetItemNumber(lrow, 'minqty')
		
		If IsNull(dMinQt) then dMinQt = 0
		If IsNull(dMulQt) Or dMulqt = 0 then dMulQt = 1
		
		dLot = dMinQt + (Ceiling((dQty - dMinQt)/dMulQt) * dMulQt)

		SetItem(lRow, 'weeklot'+right(GetColumnName(),1), dLot)
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Integer iCurRow

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

END IF
end event

event dw_insert::buttonclicked;String syymm, sItnbr, sMogub, sJocod
Long   nCnt

if dw_1.AcceptText() = -1 then return 

syymm  = trim(dw_1.GetItemString(1,'syymm'))
sJocod = trim(dw_1.GetItemString(1,'jocod'))

If IsNull(sJocod) Or sJocod = '' Then Return

// Sub item에 대한 계획 수립되어있을 경우 end-item 조정 불가
  SELECT COUNT(*) INTO :nCnt
    FROM PM01_MONPLAN_SUM A, JOMAST B
   WHERE ( A.SABU = :gs_sabu AND A.MONYYMM = :syymm AND A.MOSEQ = 0 ) AND
	      ( A.JOCOD = B.JOCOD ) AND
			( A.JOCOD = :sJocod );
If nCnt > 0 Then
	MessageBox('확 인','월 생산계획이 확정되어 있습니다.!!')
	Return
End If

If dwo.name = 'b_mod' Then
	gs_code = GetItemString(row, 'itnbr')
	gs_gubun = GetItemString(row, 'mogub')
	gs_codename = syymm
	OpenWithParm(w_pm01_01010_2,'MOD')
End If

If dwo.name = 'b_del' Then
	if messagebox("확 인", '자료를 삭제하시겠습니까?', Question!, YesNo!, 2) = 2 then return
	
	sItnbr = GetItemString(row, 'itnbr')
	sMogub = GetItemString(row, 'mogub')
	
	DELETE FROM PM01_MONPLAN_DTL  
	 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND MOGUB = :sMogub AND ITNBR = :sItnbr AND JUCHA = 0;
	if SQLCA.SQLCODE = 0 then
		commit ;
		sle_msg.text = "자료가 삭제되었습니다!!"
		ib_any_typing= FALSE
	Else
		rollback ;
		messagebox("삭제실패", "삭제가 실패하였읍니다")
		return 
	End If
	
	p_inq.TriggerEvent(Clicked!)
End If
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_pm01_01010
boolean visible = false
integer x = 2985
integer y = 40
end type

event p_delrow::clicked;call super::clicked;messagebox("공사중", "다음에...!!")
return

Integer i, irow, irow2
string s_yymm, s_toym

if dw_1.AcceptText() = -1 then return 

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then return 	


s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 삭제할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pm01_01010
integer x = 2569
integer y = 40
end type

event p_addrow::clicked;string s_team, s_yymm, s_toym, sJocod
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
sJocod = dw_1.GetItemString(1,'jocod')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if

//if isnull(sJocod) or sJocod = "" then
//	f_message_chk(30,'[생산팀/반]')
//	dw_1.Setcolumn('jocod')
//	dw_1.SetFocus()
//	return
//end if

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 추가할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

SetNull(gs_code)

Message.StringParm = 'NEW'	//신규계획
gs_gubun = '1'		// 초도품
gs_codename = s_yymm
OpenWithParm(w_pm01_01010_2,'NEW')

p_inq.triggerevent(clicked!)
end event

event p_addrow::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가_dn.gif'
end event

event p_addrow::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가_up.gif'
end event

type p_search from w_inherite`p_search within w_pm01_01010
integer x = 2213
integer y = 40
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\생성_dn.gif'
end event

event p_search::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\생성_up.gif'
end event

event p_search::clicked;call super::clicked;string s_yymm, s_toym, s_team
int    i_seq, nCnt, lRtnValue

if dw_1.AcceptText() = -1 then return 
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_team = dw_1.GetItemString(1,'steam')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
//if s_yymm < s_toym then
//
//	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")
//
//	dw_1.setcolumn('syymm')
//	dw_1.setfocus()
//	return 
//end if

/* 주문변경 유무 */
String sDate, eDate, sjocod

sjocod = dw_1.GetItemString(1,'jocod')

SELECT MIN(WEEK_SDATE), MAX(WEEK_EDATE) INTO :SDATE, :EDATE
  FROM PDTWEEK 
 WHERE SUBSTR(WEEK_SDATE,1,6) BETWEEN :S_YYMM AND TO_CHAR(ADD_MONTHS(TO_DATE(:S_YYMM,'YYYYMM'),2),'YYYYMM');
		  
//SELECT COUNT(*) INTO :nCnt
//  FROM SORDER A
// WHERE A.SABU = :gs_sabu
//   AND A.CUST_NAPGI BETWEEN :sdate AND :edate
//   AND A.SPECIAL_YN <> 'Y'
//	AND A.WEB = 'Y'
//	AND A.SAUPJ = :gs_saupj
//	AND EXISTS ( SELECT 'X' FROM ITEMAS WHERE ITNBR = A.ITNBR AND JOCOD = :sjocod AND ITTYP < '3' AND ITGU = '5' );
//If nCnt > 0 Then
//	MessageBox('확인','주문내역중 변경된 사항이 존재합니다.!!~r~n생산계획 변경을 먼저 처리하세요.!!')
//	Return
//End If

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	


SetPointer(HourGlass!)
dw_insert.Reset()

If MessageBox("확인", '월 생산계획을 생성합니다.!!~r~n기존 자료는 모두 삭제됩니다.!!', Exclamation!, OKCancel!, 2) = 2 Then Return

lRtnValue = SQLCA.FUN_PM01_MONPLAN_SUM(gs_sabu, s_yymm, i_seq, s_team)
IF lRtnValue < 0 THEN
	MESSAGEBOX(STRING(lRtnValue),SQLCA.SQLERRTEXT)
	ROLLBACK;
	f_message_chk(41,'')
	Return
ELSE
	commit ;
//	MessageBox('확 인',string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!')
END IF

p_inq.TriggerEvent(Clicked!)

//gs_code = s_yymm
//gs_codename = string(i_seq) 
//		
//Open(w_pm01_01010_1)
end event

type p_ins from w_inherite`p_ins within w_pm01_01010
boolean visible = false
integer x = 3168
integer y = 32
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pm01_01010
end type

type p_can from w_inherite`p_can within w_pm01_01010
end type

event p_can::clicked;wf_reset()

dw_1.enabled = true

p_search.picturename = 'C:\erpman\image\생성_up.gif'
p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
p_mod.picturename = 'C:\erpman\image\저장_up.gif'

p_search.enabled = true
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false

ib_any_typing = FALSE

dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pm01_01010
boolean visible = false
integer x = 2930
integer y = 40
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pm01_01010
integer x = 3922
end type

event p_inq::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_gub2, sjocod
Int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 
SetPointer(HourGlass!)

s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
sjocod = dw_1.GetItemString(1,'jocod')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_gub2 = dw_1.GetItemString(1,'gubun')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

//if isnull(sjocod) or sjocod = "" then
//	f_message_chk(30,'[생산팀/반]')
//	dw_1.Setcolumn('jocod')
//	dw_1.SetFocus()
//	return
//end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

dw_insert.object.t_mm.text = string(s_yymm, '@@@@.@@')
dw_insert.object.t_mm1.text = string(f_aftermonth(s_yymm, 1), '@@@@.@@')
dw_insert.object.t_mm2.text = string(f_aftermonth(s_yymm, 2), '@@@@.@@')
	
if dw_insert.Retrieve(gs_sabu,s_yymm, s_team) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('jocod')
	dw_1.SetFocus()
	p_1.picturename = 'C:\erpman\image\엑셀변환_d.gif'
	p_1.Enabled     = False
//	p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
//	p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
//	p_mod.picturename = 'C:\erpman\image\저장_up.gif'		
//	p_addrow.enabled = true
//	p_delrow.enabled = true
//	p_mod.enabled = true
	return
end if

p_1.picturename = 'C:\erpman\image\엑셀변환_up.gif'
p_1.Enabled     = True
end event

type p_del from w_inherite`p_del within w_pm01_01010
integer x = 2391
integer y = 40
end type

event p_del::clicked;string s_yymm, smsgtxt, stext, s_team, get_nm, s_toym, sjocod
int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
sjocod = dw_1.GetItemString(1,'jocod')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀/반]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
else
  SELECT "JONAM"  
    INTO :get_nm  
    FROM "JOMAST"  
   WHERE ( "JOCOD" = :sjocod )   ;
	
	get_nm = ''
end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = '확정분'
	else
		stext = '조정분'
	end if	
end if	

  SELECT COUNT(*) INTO :lcount
    FROM ITEMAS B, PM01_MONPLAN_SUM A, ITNCT C
   WHERE ( B.ITNBR = A.ITNBR ) AND  
         ( B.ITTYP = C.ITTYP ) AND  
         ( B.ITCLS = C.ITCLS ) AND  
         ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = 0 ) AND    
			( A.JOCOD = :s_team );

if lcount > 0 then 
   messagebox("확 인", "월 생산계획이 확정되어 있으므로 삭제 할 수 없습니다.")
	dw_1.SetFocus()
	return 
end if
		
smsgtxt = get_nm + '에 ' + left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' &
          + stext + ' 월 생산계획을 삭제 하시겠습니까?'
if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

i_seq = 1

DELETE FROM PM01_MONPLAN_DTL
 WHERE SABU = :gs_sabu AND MONYYMM = :s_yymm AND JOCOD = :s_team;
 
//	AND ITNBR IN ( SELECT B.ITNBR  FROM ITEMAS B
//					    WHERE B.JOCOD = :sjocod );

If SQLCA.SQLCODE = 0 then
	DELETE FROM PM01_MONPLAN_SUM  
	 WHERE SABU = :gs_sabu AND MONYYMM = :s_yymm AND MOSEQ = :i_seq AND  JOCOD = :s_team;
//			 ITNBR IN ( SELECT B.ITNBR  FROM  ITNCT A, ITEMAS B
//							 WHERE A.ITTYP = B.ITTYP AND A.ITCLS = B.ITCLS AND 
//								    B.JOCOD = :sjocod);
	if SQLCA.SQLCODE = 0 then
		commit ;
		sle_msg.text = "자료가 삭제되었습니다!!"
		ib_any_typing= FALSE
	Else
		rollback ;
		messagebox("삭제실패", "반별 삭제가 실패하였읍니다")
		return 
	End If
Else
	rollback ;
   messagebox("삭제실패", "반별 삭제가 실패하였읍니다")
	return 
End If
		
p_can.TriggerEvent(clicked!)
end event

type p_mod from w_inherite`p_mod within w_pm01_01010
integer x = 4096
end type

event p_mod::clicked;call super::clicked;string s_yymm, s_toym
long   i

if dw_1.AcceptText() = -1 then return 

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
//if s_yymm < s_toym then
//	messagebox("확인", "현재 이전 년월 자료는 저장할 수 없습니다!!")
//	dw_1.setcolumn('syymm')
//	dw_1.setfocus()
//	return 
//end if		

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
	
	// M월 계 계산
	dw_insert.SetItem(i, 'monqty1', dw_insert.GetItemNumber(i,'weekqty1')+dw_insert.GetItemNumber(i,'weekqty2')+ &
	                                dw_insert.GetItemNumber(i,'weekqty3')+dw_insert.GetItemNumber(i,'weekqty4')+ &
											  dw_insert.GetItemNumber(i,'weekqty5')+dw_insert.GetItemNumber(i,'weekqty6'))
	dw_insert.SetItem(i, 'monlot1', dw_insert.GetItemNumber(i,'weeklot1')+dw_insert.GetItemNumber(i,'weeklot2')+ &
	                                dw_insert.GetItemNumber(i,'weeklot3')+dw_insert.GetItemNumber(i,'weeklot4')+ &
											  dw_insert.GetItemNumber(i,'weeklot5') +dw_insert.GetItemNumber(i,'weeklot6'))
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	commit ;
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pm01_01010
end type

type cb_mod from w_inherite`cb_mod within w_pm01_01010
end type

type cb_ins from w_inherite`cb_ins within w_pm01_01010
end type

type cb_del from w_inherite`cb_del within w_pm01_01010
end type

type cb_inq from w_inherite`cb_inq within w_pm01_01010
end type

type cb_print from w_inherite`cb_print within w_pm01_01010
end type

type st_1 from w_inherite`st_1 within w_pm01_01010
end type

type cb_can from w_inherite`cb_can within w_pm01_01010
end type

type cb_search from w_inherite`cb_search within w_pm01_01010
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_01010
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_01010
end type

type dw_1 from u_key_enter within w_pm01_01010
integer x = 69
integer y = 48
integer width = 1765
integer height = 140
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_01010_1"
boolean border = false
end type

event itemchanged;String syymm, sNull, sJocod, sPdtgu
Long   lcount

SetNull(sNull)

Choose Case GetColumnName() 
	Case "syymm"
		syymm = trim(this.GetText())
		IF f_datechk(syymm + '01') = -1	then
			f_message_chk(35, '[기준년월]')
			setitem(1, "syymm", sNull)
			setitem(1, 'jjcha', 1)
			return 1
		END IF

		sJoCod = Trim(GetItemString(1, 'steam'))
		If IsNull(sJocod) Or sJocod = '' Then
			f_message_chk(1400, '[생산팀]')
			setitem(1, "syymm", sNull)
			setitem(1, 'jjcha', 1)
			return 1
		End If
		
		Post wf_protect(syymm)

	Case 'jocod'
		sJocod = Trim(GetText())
		If IsNull(sJocod) Or sJocod = '' Then
			SetItem(1, 'pdtgu', sNull)
		Else
			select pdtgu into :spdtgu from jomast where jocod = :sjocod;
			SetItem(1, 'pdtgu', sPdtgu)
		End If
		
		Post wf_protect(syymm)
End Choose

dw_insert.Reset()
end event

event itemerror;call super::itemerror;return 1
end event

type pb_1 from u_pb_cal within w_pm01_01010
integer x = 1659
integer y = 68
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('syymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'syymm', left(gs_code,6))
end event

type p_1 from picture within w_pm01_01010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3703
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\엑셀변환_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type rr_1 from roundrectangle within w_pm01_01010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 224
integer width = 4471
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

