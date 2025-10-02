$PBExportHeader$w_sal_02750.srw
$PBExportComments$내수->수출전환
forward
global type w_sal_02750 from w_inherite
end type
type rb_1 from radiobutton within w_sal_02750
end type
type rb_2 from radiobutton within w_sal_02750
end type
type cbx_chk from checkbox within w_sal_02750
end type
type gb_1 from groupbox within w_sal_02750
end type
type gb_2 from groupbox within w_sal_02750
end type
type gb_3 from groupbox within w_sal_02750
end type
type gb_4 from groupbox within w_sal_02750
end type
type gb_5 from groupbox within w_sal_02750
end type
type dw_2 from datawindow within w_sal_02750
end type
type dw_1 from datawindow within w_sal_02750
end type
type pb_1 from u_pic_cal within w_sal_02750
end type
type pb_2 from u_pic_cal within w_sal_02750
end type
type pb_3 from u_pic_cal within w_sal_02750
end type
end forward

global type w_sal_02750 from w_inherite
integer width = 4686
integer height = 2468
string title = "내수->수출매출처리"
rb_1 rb_1
rb_2 rb_2
cbx_chk cbx_chk
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
dw_2 dw_2
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
end type
global w_sal_02750 w_sal_02750

forward prototypes
public subroutine wf_init (string arg_status)
public function integer wf_danga ()
end prototypes

public subroutine wf_init (string arg_status);String	sname, sname2

dw_1.Reset()
dw_2.Reset()
dw_1.InsertRow(0)
dw_2.InsertRow(0)

dw_1.SetItem(1, 'fdate', Left(f_today(), 6) + '01')
dw_1.SetItem(1, 'tdate', f_today())

IF arg_status = 'I' THEN
	p_search.Enabled = True
	p_search.PictureName = '..\image\외화단가적용_up.gif'
	dw_2.Modify('repno.protect = 1')
	//dw_2.Modify("repno.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.Modify('local.protect = 0')
	//dw_2.Modify("local.background.color = '"+String(Rgb(255,255,255))+"'")
	dw_2.Modify('curr.protect = 0')
	//dw_2.Modify("curr.background.color = '"+String(Rgb(190,225,184))+"'")
	dw_2.SetItem(1, 'd_date', f_today())
	dw_2.Modify('d_date.protect = 0')
	//dw_2.Modify("d_date.background.color = '"+String(Rgb(190,225,184))+"'")
	dw_2.Modify('dept.protect = 0')
	//dw_2.Modify("dept.background.color = '"+String(Rgb(255,255,0))+"'")
	dw_2.Modify('empno.protect = 0')
	//dw_2.Modify("empno.background.color = '"+String(Rgb(255,255,0))+"'")
	
	f_get_name2('부서', 'Y', gs_dept, sname, sname2)	 
	
	dw_2.SetItem(1, 'dept', gs_dept)
	dw_2.SetItem(1, 'deptnm', sname)
	
	f_get_name2('사번', 'N', gs_empno, sname, sname2)	 
	
	dw_2.SetItem(1, 'empno', gs_empno)
	dw_2.SetItem(1, 'empnm', sname)
	if isnull(sname) or trim(sname) = '' then
		dw_2.setitem(1, "empno", '')
	End if
	
	dw_1.SetFocus()
	dw_1.SetColumn('cvcod')
	
	dw_insert.DataObject = 'd_sal_02750_1'
ELSE
	p_search.Enabled = False	
	p_search.PictureName = '..\image\외화단가적용_d.gif'
	dw_2.Modify('repno.protect = 0')
	//dw_2.Modify("repno.background.color = '"+String(Rgb(255,255,0))+"'")
	dw_2.Modify('local.protect = 1')
	//dw_2.Modify("local.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.SetItem(1, 'curr', '')
	dw_2.Modify('curr.protect = 1')
	//dw_2.Modify("curr.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.SetItem(1, 'd_date', '')
	dw_2.Modify('d_date.protect = 1')
	//dw_2.Modify("d_date.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.Modify('dept.protect = 1')
	//dw_2.Modify("dept.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.Modify('empno.protect = 1')
	//dw_2.Modify("empno.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_2.SetFocus()
	dw_2.SetColumn('repno')
	
	dw_insert.DataObject = 'd_sal_02750_4'
END IF

dw_insert.SetTransObject(Sqlca)
end subroutine

public function integer wf_danga ();String	ls_date, ls_itnbr, ls_cvcod, ls_curr
Dec		ld_danga, ld_unprc, ld_qty
Long		ll_row

IF dw_insert.AcceptText() = -1 THEN Return -1
IF dw_1.AcceptText() = -1 THEN Return -1
IF dw_2.AcceptText() = -1 THEN Return -1

ls_cvcod = dw_1.GetItemString(1, 'cvcod')
ls_curr  = dw_2.GetItemString(1, 'curr')

SetPointer(HourGlass!)

For	ll_row = 1 TO dw_insert.RowCount()
	
	ls_date  = dw_insert.GetItemString(ll_row, 'io_date')
	ls_itnbr = dw_insert.GetItemString(ll_row, 'imhist_itnbr')
	ld_qty	= dw_insert.GetItemNumber(ll_row, 'ioqty')

	select	sales_price, unprc
	into		:ld_danga, :ld_unprc
	from		vnddan
	where		cvcod = :ls_cvcod
	  and		itnbr = :ls_itnbr
	  and		start_date	= ( select Max(start_date)
										from vnddan
									  where cvcod = :ls_cvcod
										 and itnbr = :ls_itnbr
										 and start_date <= :ls_date) ;
	  
	IF Sqlca.SqlCode = 0 THEN
		IF ls_curr = 'WON' THEN		
			dw_insert.SetItem(ll_row, 'dyebi2', ld_danga)
			dw_insert.SetItem(ll_row, 'foramt', ld_danga * ld_qty)
		ELSE
			dw_insert.SetItem(ll_row, 'dyebi2', ld_unprc)
			dw_insert.SetItem(ll_row, 'foramt', ld_unprc * ld_qty)
		END IF
	ELSE
		dw_insert.SetItem(ll_row, 'dyebi2', 0)
	END IF
	
Next
Return 1

end function

on w_sal_02750.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_chk=create cbx_chk
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.dw_2=create dw_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cbx_chk
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_4
this.Control[iCurrent+8]=this.gb_5
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.pb_3
end on

on w_sal_02750.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_chk)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_2.SetTransObject(Sqlca)
//dw_1.InsertRow(0)
//dw_2.InsertRow(0)
//
//dw_1.SetItem(1, 'fdate', Left(f_today(), 6) + '01')
//dw_1.SetItem(1, 'edate', f_today())
//dw_2.SetItem(1, 'd_date', f_today())

rb_1.TriggerEvent(clicked!)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
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
m_main2.m_window.m_del.enabled = true  //// 삭제
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

type cb_exit from w_inherite`cb_exit within w_sal_02750
integer x = 3401
integer y = 3128
end type

type sle_msg from w_inherite`sle_msg within w_sal_02750
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_02750
end type

type st_1 from w_inherite`st_1 within w_sal_02750
end type

type p_search from w_inherite`p_search within w_sal_02750
integer x = 2875
integer y = 76
integer width = 384
string picturename = "..\image\외화단가적용_up.gif"
end type

event p_search::clicked;call super::clicked;wf_danga()
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;p_search.PictureName = '..\image\외화단가적용_d.gif'
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;p_search.PictureName = '..\image\외화단가적용_up.gif'
end event

type p_addrow from w_inherite`p_addrow within w_sal_02750
integer x = 3744
integer y = 3252
end type

type p_delrow from w_inherite`p_delrow within w_sal_02750
integer x = 3918
integer y = 3252
end type

type p_mod from w_inherite`p_mod within w_sal_02750
integer x = 3223
integer y = 3396
end type

event p_mod::clicked;call super::clicked;String	ls_date, ls_repno, ls_local, ls_curr, ls_dept, ls_empno, ls_chk, ls_iojpno
Long		ll_row, ll_cnt, ll_rtn
Dec		ld_forprc, ld_foramt, ld_jpno

IF dw_2.AcceptText() = -1 THEN Return

ls_date = Trim(dw_2.GetItemString(1, 'd_date'))
ls_local = Trim(dw_2.GetItemString(1, 'local'))
ls_curr  = Trim(dw_2.GetItemString(1, 'curr'))
ls_dept  = Trim(dw_2.GetItemString(1, 'dept'))
ls_empno = Trim(dw_2.GetItemString(1, 'empno'))

IF ls_date = '' Or IsNull(ls_date) THEN
	f_message_chk(30, '[대체일자]')
	dw_2.SetFocus()
	dw_2.SetColumn('d_date')
	Return
END IF

IF ls_dept = '' Or IsNull(ls_dept) THEN
	f_message_chk(30, '[의뢰부서]')
	dw_2.SetFocus()
	dw_2.SetColumn('dept')
	Return
END IF

IF ls_empno = '' Or IsNull(ls_empno) THEN
	f_message_chk(30, '[의뢰자]')
	dw_2.SetFocus()
	dw_2.SetColumn('empno')
	Return
END IF

IF MessageBox('확인', '선택된 항목을 수출로 처리하시겠습니까?', Question!, YesNo!) = 2 THEN Return

SetPointer(HourGlass!)

select count(*)
  into :ll_cnt
  from ratemt x, reffpf y
 where x.rcurr = y.rfgub(+) and
		 y.rfcod = '10' and
		 x.rdate = :ls_date and
		 x.rcurr = :ls_curr	;

IF Sqlca.SqlCode <> 0 OR ll_cnt <= 0 THEN
	MessageBox('확인', '대체일자에 해당하는 환율정보가 없습니다!!!')
	Return
END IF
 
ld_jpno = SQLCA.fun_junpyo(gs_sabu, ls_date, 'C1')
ls_repno = ls_date + String(ld_jpno, '0000')


//외화단가 셋팅확인
For ll_row = 1 To dw_insert.RowCount()
	
	ls_chk 	 = dw_insert.GetItemString(ll_row, 'chk')
	
	IF ls_chk = 'N' THEN Continue
	ld_forprc = dw_insert.GetItemNumber(ll_row, 'dyebi2')
	
	IF ld_forprc <= 0 OR IsNull(ld_forprc) THEN 
		f_message_chk(30,'[외화단가]')
		dw_insert.SetFocus()
		dw_insert.ScrollToRow(ll_row)
		dw_insert.SetColumn('dyebi2')
		Return
	END IF
Next

//데체처리.....
For ll_row = 1 To dw_insert.RowCount()

	ls_chk 	 = dw_insert.GetItemString(ll_row, 'chk')
	ls_iojpno = dw_insert.GetItemString(ll_row, 'iojpno')
	ld_forprc = dw_insert.GetItemNumber(ll_row, 'dyebi2')
	ld_foramt = dw_insert.GetItemNumber(ll_row, 'foramt')
	
	IF ls_chk = 'N' THEN Continue

   INSERT INTO "IMHIST_DAECHE"  
	( "SABU",   	  "REPNO",   	  "IOJPNO",
	  "FORPRC",      "FORAMT",      "CURR",   	  "LOCALYN")  
   VALUES 
   ( :gs_sabu,      :ls_repno,     :ls_iojpno,   
     :ld_forprc,    :ld_foramt,    :ls_curr,      :ls_local) ;
	  
	IF	Sqlca.SqlCode <> 0 THEN
		RollBack ;
		MessageBox('확인', '수출대체 처리시 Error발생')
		Return
	END IF
Next

ll_rtn = SQLCA.FUN_ERP100000100(gs_sabu, ls_repno, ls_date, ls_dept, ls_empno, 'C')

IF ll_rtn > 0 THEN
	Commit ;
	MessageBox('확인','대체번호 : ' + ls_repno +'로 정상완료 되었습니다.')
ELSE
	RollBack ;
	MessageBox('확인', '수출대체 처리시 Error발생' + String(ll_rtn))
	
	DELETE FROM	"IMHIST_DAECHE"
	WHERE			"SABU" = :gs_sabu
	AND			"REPNO" = :ls_repno ;
	
	Commit ;
END IF
ib_any_typing =False

p_inq.TriggerEvent(clicked!)
end event

type p_del from w_inherite`p_del within w_sal_02750
integer x = 3575
integer y = 3396
end type

event p_del::clicked;call super::clicked;String	ls_date, ls_repno, ls_local, ls_curr, ls_dept, ls_empno, ls_chk, ls_iojpno
Long		ll_row, ll_rtn
Dec		ld_forprc, ld_foramt, ld_jpno

IF dw_2.AcceptText() = -1 THEN Return

ls_repno = Trim(dw_2.GetItemString(1, 'repno'))

IF ls_repno = '' Or IsNull(ls_repno) THEN
	f_message_chk(30, '[대체번호]')
	dw_2.SetFocus()
	dw_2.SetColumn('repno')
	Return
END IF

IF MessageBox('확인', '삭제 처리하시겠습니까?', Question!, YesNo!) = 2 THEN Return

 SetPointer(HourGlass!)
ll_rtn = SQLCA.FUN_ERP100000100(gs_sabu, ls_repno, ls_date, ls_dept, ls_empno, 'D')

IF ll_rtn > 0 THEN
	
	//대체출고 내역 삭제...
	
	DELETE FROM	IMHIST_DAECHE
	WHERE			SABU = :gs_sabu	
	  AND			REPNO = :ls_repno ;
	 
	IF Sqlca.SqlCode <> 0 THEN 
		RollBack ;
		MessageBox('확인', '대체출고 삭제시 Error 발생!!!')
		Return
	END IF
ELSE
	RollBack ;
	MessageBox('확인', '대체출고 삭제시 Error 발생!!!')
	Return
END IF

Commit ;
MessageBox('확인', '대체출고 삭제완료 !!!')

p_can.TriggerEvent(clicked!)

ib_any_typing =False
end event

type p_inq from w_inherite`p_inq within w_sal_02750
integer x = 3703
integer y = 3396
end type

event p_inq::clicked;call super::clicked;String	ls_cvcod, ls_fdate, ls_tdate, ls_repno, ls_chk

IF dw_1.AcceptText() = -1 OR dw_2.AcceptText() = -1 THEN Return 

IF cbx_chk.checked THEN
	ls_chk = 'Y'
ELSE
	ls_chk = 'N'
END IF

IF rb_1.checked THEN
	
	ls_cvcod = Trim(dw_1.GetItemString(1, 'cvcod'))
	ls_fdate = Trim(dw_1.GetItemString(1, 'fdate'))
	ls_tdate = Trim(dw_1.GetItemString(1, 'tdate'))
	
	IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
		f_message_chk(30, '[거래처]')
		dw_1.SetFocus()
		dw_1.SetColumn('cvcod')
		Return 
	END IF
	
	IF ls_fdate = '' OR IsNull(ls_fdate) THEN
		f_message_chk(30, '[일자From]')
		dw_1.SetFocus()
		dw_1.SetColumn('fdate')
		Return 
	END IF
	
	IF ls_tdate = '' OR IsNull(ls_tdate) THEN
		f_message_chk(30, '[일자To]')
		dw_1.SetFocus()
		dw_1.SetColumn('tdate')
		Return 
	END IF
	
	IF dw_insert.Retrieve(gs_sabu, ls_cvcod, ls_fdate, ls_tdate, ls_chk) <= 0 THEN
		f_message_chk(50,'[매출현황]')
		dw_1.SetFocus()
		dw_1.SetColumn('cvcod')
		Return
	END IF
	
ELSE
	
	ls_repno = Trim(dw_2.GetItemString(1, 'repno'))	
	
	IF ls_repno = '' OR IsNull(ls_repno) THEN
		f_message_chk(30, '[대체번호]')
		dw_2.SetFocus()
		dw_2.SetColumn('repno')
		Return 
	END IF	
	
	IF dw_insert.Retrieve(ls_repno) <= 0 THEN
		f_message_chk(50,'[대체현황]')
		dw_2.SetFocus()
		dw_2.SetColumn('repno')
		Return
	END IF
	
END IF

ib_any_typing =False
end event

type p_print from w_inherite`p_print within w_sal_02750
integer x = 3223
integer y = 3252
end type

type p_can from w_inherite`p_can within w_sal_02750
integer x = 3927
integer y = 3396
end type

event p_can::clicked;call super::clicked;ib_any_typing =False
rb_1.checked = True

rb_1.TriggerEvent(clicked!)
end event

type p_exit from w_inherite`p_exit within w_sal_02750
integer x = 4279
integer y = 3396
end type

type p_ins from w_inherite`p_ins within w_sal_02750
integer x = 3570
integer y = 3252
end type

type p_new from w_inherite`p_new within w_sal_02750
integer x = 1815
integer y = 3396
end type

type dw_input from w_inherite`dw_input within w_sal_02750
boolean visible = false
integer x = 0
integer y = 3608
end type

type cb_delrow from w_inherite`cb_delrow within w_sal_02750
integer x = 2647
integer y = 3292
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_02750
integer x = 2336
integer y = 3292
end type

type dw_insert from w_inherite`dw_insert within w_sal_02750
integer x = 37
integer y = 544
integer width = 4480
integer height = 1744
string dataobject = "d_sal_02750_1"
end type

event dw_insert::itemchanged;call super::itemchanged;Dec	ld_ioqty, ld_forprc
Long	ll_row

ll_row = GetRow()

IF GetColumnName() = 'dyebi2' THEN
	ld_ioqty = GetItemNumber(ll_row, 'ioqty')
	ld_forprc = Dec(GetText())
	
	SetItem(ll_row, 'foramt', Truncate(ld_ioqty * ld_forprc, 2))
	
END IF
end event

type cb_mod from w_inherite`cb_mod within w_sal_02750
boolean visible = false
integer x = 2373
integer y = 3128
end type

event cb_mod::clicked;call super::clicked;//String	ls_date, ls_repno, ls_local, ls_curr, ls_dept, ls_empno, ls_chk, ls_iojpno
//Long		ll_row, ll_cnt, ll_rtn
//Dec		ld_forprc, ld_foramt, ld_jpno
//
//IF dw_2.AcceptText() = -1 THEN Return
//
//ls_date = Trim(dw_2.GetItemString(1, 'd_date'))
//ls_local = Trim(dw_2.GetItemString(1, 'local'))
//ls_curr  = Trim(dw_2.GetItemString(1, 'curr'))
//ls_dept  = Trim(dw_2.GetItemString(1, 'dept'))
//ls_empno = Trim(dw_2.GetItemString(1, 'empno'))
//
//IF ls_date = '' Or IsNull(ls_date) THEN
//	f_message_chk(30, '[대체일자]')
//	dw_2.SetFocus()
//	dw_2.SetColumn('d_date')
//	Return
//END IF
//
//IF ls_dept = '' Or IsNull(ls_dept) THEN
//	f_message_chk(30, '[의뢰부서]')
//	dw_2.SetFocus()
//	dw_2.SetColumn('dept')
//	Return
//END IF
//
//IF ls_empno = '' Or IsNull(ls_empno) THEN
//	f_message_chk(30, '[의뢰자]')
//	dw_2.SetFocus()
//	dw_2.SetColumn('empno')
//	Return
//END IF
//
//IF MessageBox('확인', '선택된 항목을 수출로 처리하시겠습니까?', Question!, YesNo!) = 2 THEN Return
//
//SetPointer(HourGlass!)
//
//select count(*)
//  into :ll_cnt
//  from ratemt x, reffpf y
// where x.rcurr = y.rfgub(+) and
//		 y.rfcod = '10' and
//		 x.rdate = :ls_date and
//		 x.rcurr = :ls_curr	;
//
//IF Sqlca.SqlCode <> 0 OR ll_cnt <= 0 THEN
//	MessageBox('확인', '대체일자에 해당하는 환율정보가 없습니다!!!')
//	Return
//END IF
// 
//ld_jpno = SQLCA.fun_junpyo(gs_sabu, ls_date, 'C1')
//ls_repno = ls_date + String(ld_jpno, '0000')
//
//
////외화단가 셋팅확인
//For ll_row = 1 To dw_insert.RowCount()
//	
//	ls_chk 	 = dw_insert.GetItemString(ll_row, 'chk')
//	
//	IF ls_chk = 'N' THEN Continue
//	ld_forprc = dw_insert.GetItemNumber(ll_row, 'dyebi2')
//	
//	IF ld_forprc <= 0 OR IsNull(ld_forprc) THEN 
//		f_message_chk(30,'[외화단가]')
//		dw_insert.SetFocus()
//		dw_insert.ScrollToRow(ll_row)
//		dw_insert.SetColumn('dyebi2')
//		Return
//	END IF
//Next
//
////데체처리.....
//For ll_row = 1 To dw_insert.RowCount()
//
//	ls_chk 	 = dw_insert.GetItemString(ll_row, 'chk')
//	ls_iojpno = dw_insert.GetItemString(ll_row, 'iojpno')
//	ld_forprc = dw_insert.GetItemNumber(ll_row, 'dyebi2')
//	ld_foramt = dw_insert.GetItemNumber(ll_row, 'foramt')
//	
//	IF ls_chk = 'N' THEN Continue
//
//   INSERT INTO "IMHIST_DAECHE"  
//	( "SABU",   	  "REPNO",   	  "IOJPNO",
//	  "FORPRC",      "FORAMT",      "CURR",   	  "LOCALYN")  
//   VALUES 
//   ( :gs_sabu,      :ls_repno,     :ls_iojpno,   
//     :ld_forprc,    :ld_foramt,    :ls_curr,      :ls_local) ;
//	  
//	IF	Sqlca.SqlCode <> 0 THEN
//		RollBack ;
//		MessageBox('확인', '수출대체 처리시 Error발생')
//		Return
//	END IF
//Next
//
//ll_rtn = SQLCA.FUN_ERP100000100(gs_sabu, ls_repno, ls_date, ls_dept, ls_empno, 'C')
//
//IF ll_rtn > 0 THEN
//	Commit ;
//	MessageBox('확인','대체번호 : ' + ls_repno +'로 정상완료 되었습니다.')
//ELSE
//	RollBack ;
//	MessageBox('확인', '수출대체 처리시 Error발생' + String(ll_rtn))
//	
//	DELETE FROM	"IMHIST_DAECHE"
//	WHERE			"SABU" = :gs_sabu
//	AND			"REPNO" = :ls_repno ;
//	
//	Commit ;
//END IF
//ib_any_typing =False
//
//cb_inq.TriggerEvent(clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_sal_02750
boolean visible = false
integer x = 1513
integer y = 3128
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_02750
boolean visible = false
integer x = 2715
integer y = 3128
end type

event cb_del::clicked;call super::clicked;//String	ls_date, ls_repno, ls_local, ls_curr, ls_dept, ls_empno, ls_chk, ls_iojpno
//Long		ll_row, ll_rtn
//Dec		ld_forprc, ld_foramt, ld_jpno
//
//IF dw_2.AcceptText() = -1 THEN Return
//
//ls_repno = Trim(dw_2.GetItemString(1, 'repno'))
//
//IF ls_repno = '' Or IsNull(ls_repno) THEN
//	f_message_chk(30, '[대체번호]')
//	dw_2.SetFocus()
//	dw_2.SetColumn('repno')
//	Return
//END IF
//
//IF MessageBox('확인', '삭제 처리하시겠습니까?', Question!, YesNo!) = 2 THEN Return
//
// SetPointer(HourGlass!)
//ll_rtn = SQLCA.FUN_ERP100000100(gs_sabu, ls_repno, ls_date, ls_dept, ls_empno, 'D')
//
//IF ll_rtn > 0 THEN
//	
//	//대체출고 내역 삭제...
//	
//	DELETE FROM	IMHIST_DAECHE
//	WHERE			SABU = :gs_sabu	
//	  AND			REPNO = :ls_repno ;
//	 
//	IF Sqlca.SqlCode <> 0 THEN 
//		RollBack ;
//		MessageBox('확인', '대체출고 삭제시 Error 발생!!!')
//		Return
//	END IF
//ELSE
//	RollBack ;
//	MessageBox('확인', '대체출고 삭제시 Error 발생!!!')
//	Return
//END IF
//
//Commit ;
//MessageBox('확인', '대체출고 삭제완료 !!!')
//
//cb_can.TriggerEvent(clicked!)
//
//ib_any_typing =False
end event

type cb_inq from w_inherite`cb_inq within w_sal_02750
boolean visible = false
integer x = 178
integer y = 3128
end type

event cb_inq::clicked;call super::clicked;//String	ls_cvcod, ls_fdate, ls_tdate, ls_repno, ls_chk
//
//IF dw_1.AcceptText() = -1 OR dw_2.AcceptText() = -1 THEN Return 
//
//IF cbx_chk.checked THEN
//	ls_chk = 'Y'
//ELSE
//	ls_chk = 'N'
//END IF
//
//IF rb_1.checked THEN
//	
//	ls_cvcod = Trim(dw_1.GetItemString(1, 'cvcod'))
//	ls_fdate = Trim(dw_1.GetItemString(1, 'fdate'))
//	ls_tdate = Trim(dw_1.GetItemString(1, 'tdate'))
//	
//	IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
//		f_message_chk(30, '[거래처]')
//		dw_1.SetFocus()
//		dw_1.SetColumn('cvcod')
//		Return 
//	END IF
//	
//	IF ls_fdate = '' OR IsNull(ls_fdate) THEN
//		f_message_chk(30, '[일자From]')
//		dw_1.SetFocus()
//		dw_1.SetColumn('fdate')
//		Return 
//	END IF
//	
//	IF ls_tdate = '' OR IsNull(ls_tdate) THEN
//		f_message_chk(30, '[일자To]')
//		dw_1.SetFocus()
//		dw_1.SetColumn('tdate')
//		Return 
//	END IF
//	
//	IF dw_insert.Retrieve(gs_sabu, ls_cvcod, ls_fdate, ls_tdate, ls_chk) <= 0 THEN
//		f_message_chk(50,'[매출현황]')
//		dw_1.SetFocus()
//		dw_1.SetColumn('cvcod')
//		Return
//	END IF
//	
//ELSE
//	
//	ls_repno = Trim(dw_2.GetItemString(1, 'repno'))	
//	
//	IF ls_repno = '' OR IsNull(ls_repno) THEN
//		f_message_chk(30, '[대체번호]')
//		dw_2.SetFocus()
//		dw_2.SetColumn('repno')
//		Return 
//	END IF	
//	
//	IF dw_insert.Retrieve(ls_repno) <= 0 THEN
//		f_message_chk(50,'[대체현황]')
//		dw_2.SetFocus()
//		dw_2.SetColumn('repno')
//		Return
//	END IF
//	
//END IF
//
//ib_any_typing =False
end event

type cb_print from w_inherite`cb_print within w_sal_02750
integer x = 1842
integer y = 3264
boolean enabled = false
end type

type cb_can from w_inherite`cb_can within w_sal_02750
boolean visible = false
integer x = 3058
integer y = 3128
end type

event cb_can::clicked;call super::clicked;//ib_any_typing =False
//rb_1.checked = True
//
//rb_1.TriggerEvent(clicked!)
end event

type cb_search from w_inherite`cb_search within w_sal_02750
boolean visible = false
integer x = 1842
integer y = 3128
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_02750
integer y = 2976
integer height = 124
integer textsize = -2
fontcharset fontcharset = ansi!
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02750
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02750
end type

type r_head from w_inherite`r_head within w_sal_02750
long fillcolor = 12639424
integer y = 40
integer width = 3291
integer height = 484
end type

type r_detail from w_inherite`r_detail within w_sal_02750
integer y = 540
integer width = 4488
integer height = 1752
end type

type rb_1 from radiobutton within w_sal_02750
integer x = 2953
integer y = 308
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "생성"
boolean checked = true
end type

event clicked;wf_init('I')
end event

type rb_2 from radiobutton within w_sal_02750
integer x = 2953
integer y = 392
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "삭제"
end type

event clicked;wf_init('D')
end event

type cbx_chk from checkbox within w_sal_02750
integer x = 2542
integer y = 120
integer width = 334
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "전체선택"
end type

event clicked;String	ls_chk
Long		ll_row

IF This.Checked THEN
	ls_chk = 'Y'
ELSE
	ls_chk = 'N'
END IF
		
For ll_row = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ll_row, 'chk', ls_chk)
Next
	
end event

type gb_1 from groupbox within w_sal_02750
integer x = 96
integer y = 68
integer width = 2441
integer height = 160
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "선택조건"
end type

type gb_2 from groupbox within w_sal_02750
integer x = 96
integer y = 244
integer width = 2560
integer height = 244
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "대체내역"
end type

type gb_3 from groupbox within w_sal_02750
boolean visible = false
integer x = 155
integer y = 3104
integer width = 384
integer height = 156
integer taborder = 20
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type gb_4 from groupbox within w_sal_02750
boolean visible = false
integer x = 2341
integer y = 3100
integer width = 1426
integer height = 156
integer taborder = 30
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type gb_5 from groupbox within w_sal_02750
integer x = 2903
integer y = 244
integer width = 338
integer height = 244
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
end type

type dw_2 from datawindow within w_sal_02750
event ue_pressenter pbm_dwnprocessenter
event ue_keydown pbm_dwnkey
integer x = 114
integer y = 300
integer width = 2505
integer height = 172
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02750_3"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_keydown;if Key = KeyF1! THEN
	Triggerevent(RbuttonDown!)
end if
end event

event itemchanged;String	sdept, sname, sname2, sempno, sempnm
Int		ireturn

IF this.GetColumnName() = 'dept' THEN

	sDept = this.gettext()
	
   ireturn = f_get_name2('부서', 'Y', sdept, sname, sname2)	 
	this.setitem(1, "dept", sdept)
	this.setitem(1, "deptnm", sName)
   return ireturn 	 
	
	
ELSEIF this.GetColumnName() = 'empno' THEN

	sEmpno = this.gettext()
	
   ireturn = f_get_name2('사번', 'Y', sEmpno, sEmpnm, sname2)	 
	this.setitem(1, "empno", sEmpno)
	this.setitem(1, "empnm", sEmpnm)
	
	select deptcode into :sDept from p1_master where empno = :sEmpno;
	f_get_name2('부서', 'Y', sdept, sname, sname2)	 
	this.setitem(1, "dept", sDept)
	this.setitem(1, "deptnm", sname)
   return ireturn 	 
END IF
end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = 'repno'	THEN
	Open(w_daeche_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"repno",gs_code)

ELSEIF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptnm",gs_codename)

elseIF this.GetColumnName() = 'empno'	THEN
	
	this.accepttext()
	gs_gubun  = this.getitemstring(1, 'dept')

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1, "empno", gs_code)
	SetItem(1, "empnm", gs_codename)
	this.setitem(1, "dept", gs_gubun)
	
	string sdata
	Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
	this.setitem(1, "deptnm", sdata)

end if
end event

type dw_1 from datawindow within w_sal_02750
event ue_pressenter pbm_dwnprocessenter
event ue_keydown pbm_dwnkey
integer x = 105
integer y = 120
integer width = 2336
integer height = 92
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02750_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_keydown;if key = KeyF1! THEN 
	triggerevent(rbuttondown!)
end if
	
end event

event itemerror;Return 1
end event

event itemchanged;String	ls_data, ls_name

IF GetColumnName() = 'cvcod' THEN
	
	ls_data = GetText()
	
	SELECT	cvnas2
	INTO		:ls_name
	FROM		vndmst
	WHERE		cvcod = :ls_data	
	  AND		cvstatus = '0'	;
	  
	IF Sqlca.SqlCode <> 0 THEN
		MessageBox('확인', '등록되지않은 거래처 입니다.')
		SetItem(1, 'cvcod', '')
		SetItem(1, 'cvnas', '')
		Return 1
	END IF
	
	SetItem(1, 'cvnas', ls_name)
	
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF GetColumnName() = 'cvcod' THEN
	open(w_vndmst_popup)
	IF gs_code = '' OR IsNull(gs_code) THEN Return
		
	SetItem(1, 'cvcod', gs_code)
	SetItem(1, 'cvnas', gs_codename)
END IF
end event

type pb_1 from u_pic_cal within w_sal_02750
integer x = 1998
integer y = 128
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'fdate', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_02750
integer x = 2437
integer y = 128
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'tdate', gs_code)

end event

type pb_3 from u_pic_cal within w_sal_02750
integer x = 960
integer y = 388
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('d_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'd_date', gs_code)

end event

