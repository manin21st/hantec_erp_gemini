$PBExportHeader$w_adt_01300.srw
$PBExportComments$보세창고입하
forward
global type w_adt_01300 from w_inherite
end type
type rr_3 from roundrectangle within w_adt_01300
end type
type dw_1 from datawindow within w_adt_01300
end type
type cbx_1 from checkbox within w_adt_01300
end type
type rr_4 from roundrectangle within w_adt_01300
end type
type dw_detail from datawindow within w_adt_01300
end type
type pb_1 from u_pb_cal within w_adt_01300
end type
type pb_2 from u_pb_cal within w_adt_01300
end type
type pb_3 from u_pb_cal within w_adt_01300
end type
type pb_4 from u_pb_cal within w_adt_01300
end type
type rb_4 from radiobutton within w_adt_01300
end type
type rb_3 from radiobutton within w_adt_01300
end type
type rr_2 from roundrectangle within w_adt_01300
end type
end forward

global type w_adt_01300 from w_inherite
boolean visible = false
integer width = 4654
string title = "보세창고 입하등록"
rr_3 rr_3
dw_1 dw_1
cbx_1 cbx_1
rr_4 rr_4
dw_detail dw_detail
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rb_4 rb_4
rb_3 rb_3
rr_2 rr_2
end type
global w_adt_01300 w_adt_01300

type variables
char   ic_status
string is_Last_Jpno, is_Date, is_gubun
int    ii_Last_Jpno


end variables

forward prototypes
public subroutine wf_taborderzero ()
public subroutine wf_taborder ()
public subroutine wf_reset ()
public function integer wf_delete ()
public subroutine wf_new ()
public subroutine wf_query ()
end prototypes

public subroutine wf_taborderzero ();dw_detail.SetTabOrder("poblno", 0)

end subroutine

public subroutine wf_taborder ();dw_detail.SetTabOrder("poblno", 10)
dw_detail.SetColumn("poblno")
end subroutine

public subroutine wf_reset ();string   snull
integer  iNull
long		lRow

SetNull(sNull)
SetNull(iNull)
lRow  = dw_insert.GetRow()	
dw_insert.setitem(lRow, 'polcno', snull)
dw_insert.setitem(lRow, 'itnbr', snull)
dw_insert.setitem(lRow, 'itdsc', snull)
dw_insert.setitem(lRow, 'ispec', snull)
dw_insert.setitem(lRow, 'jijil', snull)
dw_insert.setitem(lRow, 'ispec_code', snull)
dw_insert.setitem(lRow, 'polchd_pocurr', snull)
dw_insert.setitem(lRow, 'baljpno', snull)
dw_insert.setitem(lRow, 'balseq', inull)
dw_insert.setitem(lRow, 'poblsq', inull)
dw_insert.setitem(lRow, 'polcdt_lcqty', 0)
dw_insert.setitem(lRow, 'polcdt_blqty', 0)
dw_insert.setitem(lRow, 'blqty', 0)
dw_insert.setitem(lRow, 'polcdt_lcprc', 0)
dw_insert.SetItem(lRow, "amt", 0)		// LC금액
dw_insert.setitem(lRow, 'saupj', snull)

end subroutine

public function integer wf_delete ();long	lRow, lRowCount


lRowCount = dw_insert.RowCount()

FOR  lRow = lRowCount 	TO	 1		STEP -1
	
	dw_insert.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public subroutine wf_new ();ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)

wf_TabOrder()
dw_detail.setredraw(true)
///////////////////////////////////////////////
dw_detail.enabled = true
dw_insert.enabled = true

p_mod.enabled = false
p_del.enabled = false
p_inq.enabled = true

p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

dw_detail.SetFocus()

rb_3.checked = true
rb_4.checked = false

ib_any_typing = false


end subroutine

public subroutine wf_query ();w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()
dw_detail.SetFocus()
	
// button
p_mod.enabled = true
p_del.enabled = true
//cb_insert.enabled = false

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"



end subroutine

on w_adt_01300.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.rr_4=create rr_4
this.dw_detail=create dw_detail
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.rr_4
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.pb_3
this.Control[iCurrent+9]=this.pb_4
this.Control[iCurrent+10]=this.rb_4
this.Control[iCurrent+11]=this.rb_3
this.Control[iCurrent+12]=this.rr_2
end on

on w_adt_01300.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.rr_4)
destroy(this.dw_detail)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)

is_Date = f_Today()

rb_3.checked = true
rb_4.checked = false

is_gubun = '0'
p_can.TriggerEvent("clicked")


end event

type dw_insert from w_inherite`dw_insert within w_adt_01300
integer x = 27
integer y = 448
integer width = 4567
integer height = 1872
integer taborder = 20
string dataobject = "d_adt_01300_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_adt_01300
boolean visible = false
integer x = 2327
integer y = 20
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;string sblno
long	lrow, lcount
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

// 물대비용이 등록된 경우에는 수정불가
SELECT COUNT(*)  INTO :lcount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno and mulgu = 'Y'  ;
 
IF lcount > 0 then 
	MessageBox("확인", "구매결제된 B/L번호는 삭제할 수 없습니다.")
	RETURN 
END IF	

//IF f_msg_delete() = -1 THEN	RETURN

dw_insert.DeleteRow(lRow)
//sBlno = trim(dw_detail.GetItemString(1, "poblno"))
//
//if dw_insert.rowcount() < 1 then
//	
//	// 수입비용이 등록된 경우에는 수정불가
//	SELECT COUNT(*)  INTO :lcount
//	  FROM IMPEXP 
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno;
//	 
//	IF lcount > 0 then 
//		MessageBox("확인", "수입비용이 등록된 B/L번호는 삭제할 수 없습니다.")
//		RETURN 
//	END IF		
//	
//	// HEAD삭제
//	DELETE POLCBLHD
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		rollback;
//		MESSAGEBOX("B/L-HEAD", "B/L-HEAD삭제시 오류가 발생", stopsign!)
//		return
//	END IF	
//end if
//

ib_any_typing = true

end event

type p_addrow from w_inherite`p_addrow within w_adt_01300
boolean visible = false
integer x = 2149
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return


//////////////////////////////////////////////////////////
long		lRow
string  	sBlno

sBlno	= dw_detail.getitemstring(1, "poblno")


lRow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_adt_01300
boolean visible = false
integer x = 2697
integer y = 28
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_adt_01300
boolean visible = false
integer x = 2510
integer y = 20
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return

//////////////////////////////////////////////////////////
long	 k, lcurrow
string sopt, spolcno, sblno, sbajno, slocalyn
int	 iCount, ibaseq
decimal dqty, dprice

sBlno	= dw_detail.getitemstring(1, "poblno")

Setnull(gs_code)
open(w_lc_detail_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return
dw_1.reset()
dw_1.ImportClipboard()

FOR k=1 TO dw_1.rowcount()
	sopt = dw_1.getitemstring(k, 'opt')
	if sopt = 'Y' then 
		sPolcno = dw_1.getitemstring(k, 'polcdt_polcno')
		sbajno  = dw_1.getitemstring(k, 'polcdt_baljpno')
		ibaseq  = dw_1.getitemnumber(k, 'polcdt_balseq')
//		if wf_dupchk(99999999, spolcno, sbajno, ibaseq) = -1 then 
//			continue 
//		end if	

		// L/C내역이 local인 내역은 무시
		select localyn into :slocalyn from polchd
		 where sabu = :gs_sabu and polcno = :spolcno;
		if slocalyn = 'Y' then 
			Messagebox("Local", "L/C-NO : " + spolcno + " 는 Local L/C입니다", stopsign!)
			continue
		end if

		lcurrow = dw_insert.insertrow(0)
		
		dw_insert.SetItem(lcurrow, "sabu", gs_sabu)
		

		dw_insert.setitem(lcurrow, 'polcno', sPolcno )
		dw_insert.setitem(lcurrow, 'baljpno', sbajno)
		dw_insert.setitem(lcurrow, 'balseq', ibaseq)
		dw_insert.setitem(lcurrow, 'itnbr', dw_1.getitemstring(k, 'poblkt_itnbr' ))
		dw_insert.setitem(lcurrow, 'itdsc', dw_1.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lcurrow, 'ispec', dw_1.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lcurrow, 'jijil', dw_1.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lcurrow, 'ispec_code', dw_1.getitemstring(k, 'itemas_ispec_code' ))
		dw_insert.setitem(lcurrow, 'saupj', dw_1.getitemstring(k, 'poblkt_saupj' ))
		dw_insert.setitem(lcurrow, 'polchd_pocurr', dw_1.getitemstring(k, 'polchd_pocurr' ))
		dw_insert.setitem(lcurrow, 'polcdt_lcqty', dw_1.getitemdecimal(k, 'polcdt_lcqty' ))
		dw_insert.setitem(lcurrow, 'polcdt_blqty', dw_1.getitemdecimal(k, 'polcdt_blqty' ))
		dw_insert.setitem(lcurrow, 'blqty', dw_1.getitemdecimal(k, 'janqty' ))
		dw_insert.setitem(lcurrow, 'polcdt_lcprc', dw_1.getitemdecimal(k, 'polcdt_lcprc' ))
		dQty   = dw_1.getitemdecimal(k, 'janqty' )
		dPrice = dw_1.getitemdecimal(k, "polcdt_lcprc")
		dw_insert.SetItem(lcurrow, "amt", dQty * dPrice)		// LC금액

		SELECT MAX(POBLSQ)
		  INTO :iCount
		  FROM POLCBL
		 WHERE SABU = :gs_sabu		and
				 POBLNO <> :sBlno		and
				 POLCNO = :sPolcno ;

		IF isnull(iCount) OR iCount = 0 then
			icount = 1
		ELSE
			iCount++
		END IF	

		dw_insert.SetItem(lcurrow, "poblsq", iCount)
	end if	
NEXT
dw_1.reset()
dw_insert.ScrollToRow(lcurrow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_exit from w_inherite`p_exit within w_adt_01300
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_adt_01300
integer taborder = 90
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

Rollback ;

wf_New()

dw_insert.Reset()
dw_insert.dataobject = "d_adt_01300_1"
dw_insert.settransobject(sqlca)

p_del.Enabled = false	
p_del.Picturename = 'c:\erpman\image\삭제_d.gif'
p_mod.Enabled = true	
p_mod.Picturename = 'c:\erpman\image\저장_up.gif'

is_gubun = '0'
cbx_1.checked = false
end event

type p_print from w_inherite`p_print within w_adt_01300
boolean visible = false
integer x = 1966
integer y = 20
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_adt_01300
integer x = 3749
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sBlno,		&
			sDate,		&
			sNull
int      get_count			
			
SetNull(sNull)

sBlno	= dw_detail.getitemstring(1, "poblno")

IF isnull(sBlno) or sBlno = "" 	THEN
	f_message_chk(30,'[B/L번호]')
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, sBlno) < 1	THEN
	f_message_chk(50, '[B/L번호]')
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_can.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

IF dw_insert.Retrieve(gs_Sabu, sBlno) < 1 THEN 
	f_message_chk(50, '[L/C번호]')
	dw_detail.reset()
	dw_detail.insertrow(0)
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()
	RETURN
END IF


ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_adt_01300
integer taborder = 80
end type

event p_del::clicked;call super::clicked;string	ls_blno, ls_lcno, ls_baljpno, ls_itnbr
integer  i
long     lcnt, ll_cnt, ll_blseq, ll_balseq
decimal  ld_blqty


SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1		THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1	THEN	RETURN


//입고여부 체크 및 선택 여부체크
if is_gubun = '1' then	
	for i = 1 to dw_insert.Rowcount()	
	 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
		 if dw_insert.GetItemnumber(i,'entqty') > 0 then
			 messagebox('알림', '선택하신 내역중' + string(i) + '번째 선택 내역은 ~n이미 통관처리되어 입고취소 작업을 할 수 없습니다.')
			 return
		 end if		  
		 lCnt++
	 end if	 
   Next
else
   MessageBox('알림','미입고된 자료입니다. 입고 후 작업가능 합니다')
	return
end if

if lcnt < 1 then
		MessageBox('확인', '선택하신 내역이 없습니다.~n선택 후 작업하시기 바랍니다', Exclamation!)
		return
end if	

if MessageBox('확인', '선택하신 B/L을 입고 취소 하시겠습니까?', &
														question!, YesNo!, 2) = 2 then
	return 2
end if	

//보세창고 입하(입고 내역 취소처리)
if is_gubun = '1' then	
	for i = 1 to dw_insert.rowcount()
		 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
			 ls_blno    = dw_insert.GetItemString(i, 'poblno')
			 ll_blseq   = dw_insert.GetItemNumber(i, 'pobseq')
			 ls_lcno    = dw_insert.GetItemString(i, 'polcno')
			 ls_baljpno = dw_insert.GetItemString(i, 'baljpno')
			 ll_balseq  = dw_insert.GetItemNumber(i, 'balseq')
			 ls_itnbr   = dw_insert.GetItemString(i, 'itnbr')	
			 
			 select count(*) 
			   into :ll_cnt
				from bondhst
 			  where sabu    = :gs_sabu
				 and poblno  = :ls_blno
				 and pobseq  = :ll_blseq
				 and polcno  = :ls_lcno
				 and baljpno = :ls_baljpno
				 and balseq  = :ll_balseq ;
				 
			 if ll_cnt > 0 then				
				  delete from bondhst
				  where sabu    = :gs_sabu    and poblno  = :ls_blno
					 and pobseq  = :ll_blseq   and polcno  = :ls_lcno
					 and baljpno = :ls_baljpno and balseq  = :ll_balseq ;
					 
			     if sqlca.sqlcode <> 0 then
				     MessageBox('취소실패', '[보세창고 입고취소] DELETE 실패!~r' + &
					 	  					       '전산실에 문의 하세요.', Stopsign!)
				     Rollback;
				     return
			     end if
			 else	  
				Messagebox('확인', '취소할 보세창고 입고 자료가 존재하지 않습니다')
				return
			 end if				 
		 end if	
	next	
end if	

Commit;

ib_any_typing = False

p_inq.TriggerEvent("clicked")	
cbx_1.checked = false

SetPointer(Arrow!)


end event

type p_mod from w_inherite`p_mod within w_adt_01300
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;string	ls_blno, ls_lcno, ls_baljpno, ls_itnbr, ls_ipdate, ls_jpno
integer  i
long     lcnt, ll_cnt, ll_blseq, ll_balseq, ll_jpseq
decimal  ld_blqty
double   ld_maxno


SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1		THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1	THEN	RETURN


//입고여부 체크 및 선택 여부체크
if is_gubun = '1' then	
	for i = 1 to dw_insert.Rowcount()	
	 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
		 if dw_insert.GetItemnumber(i,'bondqty') > 0 then
			 messagebox('알림', '선택하신 내역중' + string(i) + '번째 선택 내역은 이미 입고처리 되었습니다~n 미입고 내역 조회후 작업하세요')
			 return
		 end if		  
		 lCnt++
	 end if	 
   Next
else
   for i = 1 to dw_insert.Rowcount()	
	  if dw_insert.GetItemString(i, 'chk') = 'Y' then 
		  lCnt++	   
	  end if	 
   Next	
end if

if lcnt < 1 then
		MessageBox('확인', '선택하신 내역이 없습니다.~n선택 후 작업하시기 바랍니다', Exclamation!)
		return
end if	

if MessageBox('확인', '선택하신 B/L을 보세창고에 입고 하시겠습니까?', &
														question!, YesNo!, 2) = 2 then
	return 2
end if	

//보세창고 입하(미입고 내역 입고처리)
if is_gubun = '0' then	
	//접수일자
	ls_ipdate = dw_detail.GetItemString(1, 'rcvdat')
	ll_jpseq = 0
	for i = 1 to dw_insert.rowcount()
		 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
			 ls_blno    = dw_insert.GetItemString(i, 'poblno')
			 ll_blseq   = dw_insert.GetItemNumber(i, 'pobseq')
			 ls_lcno    = dw_insert.GetItemString(i, 'polcno')
			 ls_baljpno = dw_insert.GetItemString(i, 'baljpno')
			 ll_balseq  = dw_insert.GetItemNumber(i, 'balseq')
			 ls_itnbr   = dw_insert.GetItemString(i, 'itnbr')	
			 ld_blqty   = dw_insert.GetItemNumber(i, 'blqty')
			 
			 select count(*) 
			   into :ll_cnt
				from bondhst
 			  where sabu    = :gs_sabu
				 and poblno  = :ls_blno
				 and pobseq  = :ll_blseq
				 and polcno  = :ls_lcno
				 and baljpno = :ls_baljpno
				 and balseq  = :ll_balseq ;
			 if ll_cnt = 0 then
			    ll_jpseq ++	
			    // 입고전표 번호 채번
	          ld_maxno = sqlca.fun_junpyo(gs_sabu, ls_ipdate, 'Y5') 
	          commit;
	
	          ls_jpno  = ls_ipdate + string(ld_maxno, '0000') + string(ll_jpseq, '000')	
	
			    insert into bondhst
					   ( sabu, bondjpno, iogbn, poblno, pobseq, polcno, baljpno, balseq, itnbr, pspec, ipdat, bondcd, bondqty)
				   values
					   ( :gs_sabu, :ls_jpno, 'I', :ls_blno, :ll_blseq, :ls_lcno, :ls_baljpno, :ll_balseq, :ls_itnbr, '.', :ls_ipdate, '.', :ld_blqty);
		
		       if sqlca.sqlcode <> 0 then
				    MessageBox('입고실패', '[보세창고 입고] INSERT 실패!~r' + &
						  					       '전산실에 문의 하세요.', Stopsign!)
				    Rollback;
				    return
			    end if
			 end if				 
		 end if	
	next	
end if	

Commit;

ib_any_typing = False

p_inq.TriggerEvent("clicked")	
cbx_1.checked = false
SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_adt_01300
end type

type cb_mod from w_inherite`cb_mod within w_adt_01300
end type

type cb_ins from w_inherite`cb_ins within w_adt_01300
end type

type cb_del from w_inherite`cb_del within w_adt_01300
end type

type cb_inq from w_inherite`cb_inq within w_adt_01300
end type

type cb_print from w_inherite`cb_print within w_adt_01300
end type

type st_1 from w_inherite`st_1 within w_adt_01300
end type

type cb_can from w_inherite`cb_can within w_adt_01300
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_adt_01300
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01300
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01300
end type

type rr_3 from roundrectangle within w_adt_01300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 184
integer width = 4590
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_adt_01300
boolean visible = false
integer x = 837
integer y = 2540
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_lc_detail_popup1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_adt_01300
integer x = 4219
integer y = 328
integer width = 366
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long i

if dw_insert.RowCount() < 1 then return

For i = 1 to dw_insert.RowCount()
	IF checked then
		dw_insert.SetItem(i, 'chk', 'Y')
	ELSE
		dw_insert.SetItem(i, 'chk', 'N')
	END IF
NEXT


	
end event

type rr_4 from roundrectangle within w_adt_01300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 440
integer width = 4590
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_adt_01300
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 27
integer y = 212
integer width = 4571
integer height = 164
integer taborder = 10
string title = "none"
string dataobject = "d_adt_01300"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;string	sDate, 			&
			sCode, sName,	&
			sNull, sBigub
int      icount			
SetNull(sNull)


// B/L NO
IF this.GetcolumnName() = 'poblno'	THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then return 

  SELECT COUNT("POLCBL"."POBLNO"), MAX("POLCBL"."BIGUB")
    INTO :icount, :sBigub  
    FROM "POLCBL"  
   WHERE ( "POLCBL"."SABU" = :gs_sabu ) AND  
         ( "POLCBL"."POBLNO" = :scode )   ;

	p_inq.TriggerEvent(Clicked!)
	
//	IF icount > 0 THEN
//		if sBigub = '1' then //B/L
//	   	rb_1.checked = true
//		else
//	   	rb_2.checked = true
//		end if
//		p_inq.TriggerEvent(Clicked!)
//	   return 1
//   END IF	
END IF
// 운송회사
IF this.GetcolumnName() = 'tra_cvcod'	THEN
	
	sCode = this.GetText()								
	
  	if scode = '' or isnull(scode) then
		this.setitem(1, 'vndmst_cvnas', snull)
		return 
   end if
	
   SELECT CVNAS
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode  AND
	 		 CVSTATUS = '0' ;

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[운송회사]')
		this.setitem(1, 'tra_cvcod', sNull)
		this.setitem(1, 'vndmst_cvnas', snull)
	   return 1
   ELSE
		this.setitem(1, 'vndmst_cvnas', sName)
   END IF
	
END IF


// 접수일자
IF this.GetColumnName() = 'rcvdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[접수일자]')
		This.setitem(1, "rcvdat", sNull)
		return 1
	END IF
	
END IF

// 도착일자
IF this.GetColumnName() = 'desdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[도착일자]')
		this.setitem(1, "desdat", sNull)
		return 1
	END IF
	
END IF

// 통관예정일
IF this.GetColumnName() = 'entfoct' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[통관예정일]')
		this.setitem(1, "entfoct", sNull)
		return 1
	END IF
	
END IF


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''


// 운송회사
IF this.GetColumnName() = 'tra_cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tra_cvcod",		gs_code)
	SetItem(1,"vndmst_cvnas",  gs_codename)
	
END IF

// BL번호
IF this.GetColumnName() = 'poblno'	THEN
   
   Open(w_bl_popup5)

   if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "poblno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

type pb_1 from u_pb_cal within w_adt_01300
integer x = 2085
integer y = 204
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('rcvdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'rcvdat', gs_code)



end event

type pb_2 from u_pb_cal within w_adt_01300
boolean visible = false
integer x = 2871
integer y = 204
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('desdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'desdat', gs_code)



end event

type pb_3 from u_pb_cal within w_adt_01300
boolean visible = false
integer x = 2871
integer y = 288
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('entdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'entdat', gs_code)



end event

type pb_4 from u_pb_cal within w_adt_01300
boolean visible = false
integer x = 2085
integer y = 288
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('entfoct')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'entfoct', gs_code)



end event

type rb_4 from radiobutton within w_adt_01300
integer x = 411
integer y = 64
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "입고"
end type

event clicked;dw_detail.reset()
dw_detail.insertrow(0)

dw_insert.reset()
dw_insert.dataobject = "d_adt_01300_2"
dw_insert.settransobject(sqlca)

p_del.Enabled = true	
p_del.Picturename = 'c:\erpman\image\삭제_up.gif'
p_mod.Enabled = false	
p_mod.Picturename = 'c:\erpman\image\저장_d.gif'	

is_gubun = '1'
cbx_1.checked = false
end event

type rb_3 from radiobutton within w_adt_01300
integer x = 73
integer y = 64
integer width = 315
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "미입고"
boolean checked = true
end type

event clicked;dw_detail.reset()
dw_detail.insertrow(0)

dw_insert.reset()
dw_insert.dataobject = "d_adt_01300_1"
dw_insert.settransobject(sqlca)

p_del.Enabled = false	
p_del.Picturename = 'c:\erpman\image\삭제_d.gif'
p_mod.Enabled = true	
p_mod.Picturename = 'c:\erpman\image\저장_up.gif'	

is_gubun = '0'
cbx_1.checked = false
end event

type rr_2 from roundrectangle within w_adt_01300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 24
integer width = 727
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

