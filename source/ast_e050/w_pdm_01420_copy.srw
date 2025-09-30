$PBExportHeader$w_pdm_01420_copy.srw
$PBExportComments$작업장별 부하시간 복사
forward
global type w_pdm_01420_copy from w_inherite_popup
end type
type dw_2 from datawindow within w_pdm_01420_copy
end type
type rb_1 from radiobutton within w_pdm_01420_copy
end type
type rb_2 from radiobutton within w_pdm_01420_copy
end type
type rr_1 from roundrectangle within w_pdm_01420_copy
end type
end forward

global type w_pdm_01420_copy from w_inherite_popup
integer width = 1984
integer height = 1760
string title = "부하시간 복사"
dw_2 dw_2
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_pdm_01420_copy w_pdm_01420_copy

forward prototypes
public function integer wf_update (string as_getmon, string as_getwrk, string as_inswrk)
public subroutine wf_mon ()
public subroutine wf_day ()
public function integer wf_update2 (string as_getday_s, string as_getday_e, string as_getwrk, string as_inswrk)
end prototypes

public function integer wf_update (string as_getmon, string as_getwrk, string as_inswrk);String ls_last

SELECT TO_CHAR(LAST_DAY(TO_DATE(:as_getmon, 'yyyymm')), 'dd')
  INTO :ls_last
  FROM DUAL ;

Long   ll_cnt

ll_cnt = Long(ls_last)

Long   i
Double ldb_bot, lbl_day, lbl_night
String ls_day

For i = 1 To ll_cnt
	ls_day = String(i, '00')
	
	SELECT BOTIME1, TIME_DAY, TIME_NIGHT
	  INTO :ldb_bot, :lbl_day, :lbl_night
	  FROM PDTCAL
	 WHERE CALNDR = :as_getmon || :ls_day
	   AND PDTGU  = :as_getwrk ;
	If ldb_bot < 1 OR IsNull(ldb_bot) Then ldb_bot = 0
	
	UPDATE PDTCAL
	   SET BOTIME1 = :ldb_bot,
		    TIME_DAY = :lbl_day,
			 TIME_NIGHT = :lbl_night
	 WHERE CALNDR  = :as_getmon || :ls_day
	   AND PDTGU   = :as_inswrk ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('복사실패', '자료 복사 중 오류가 발생했습니다!')
		Return -1
	End If
Next

Return 1
end function

public subroutine wf_mon ();dw_1.AcceptText()
dw_2.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_wrk_b

ls_wrk_b = dw_1.GetItemString(row, 'wkctr_base')
If Trim(ls_wrk_b) = '' OR IsNull(ls_wrk_b) Then
	MessageBox('From 항목 확인', '원본 대상의 작업장을 확인 하십시오.')
	dw_1.SetColumn('wkctr_base')
	dw_1.SetFocus()
	Return
End If

String ls_mon_b

ls_mon_b = dw_1.GetItemString(row, 'mon_base')
If Trim(ls_mon_b) = '' OR IsNull(ls_mon_b) Then
	MessageBox('From 항목 확인', '원본 대상의 기준 월을 확인 하십시오.')
	dw_1.SetColumn('mon_base')
	dw_1.SetFocus()
	Return
End If

Long   ll_cnt
Long   i

ll_cnt  = dw_2.RowCount()
If ll_cnt < 1 Then Return

String ls_chk
String ls_wrk_c

If MessageBox('자료복사-월별', '작업장의 부하시간을 복사 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

Long   ll_ret
Long   ll_chk

For i = 1 To ll_cnt
	ls_chk = dw_2.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_wrk_c = dw_2.GetItemString(i, 'wkctr')
		If Trim(ls_wrk_c) = '' OR IsNull(ls_wrk_c) Then
			MessageBox('From 항목 확인', '복사 대상의 작업장을 확인 하십시오.')
			dw_2.SetColumn('wkctr')
			dw_2.SetFocus()
			Return
		End If
		
		SELECT COUNT('X')
		  INTO :ll_chk
		  FROM PDTCAL
		 WHERE CALNDR LIKE :ls_mon_b||'%'
		   AND PDTGU  =    :ls_wrk_c ;
		If ll_chk < 1 OR IsNull(ll_chk) Then		
			INSERT INTO PDTCAL ( CALNDR, PDTGU, JANUP, YAYUP  , CHLYA  , TUKGN  , RATE1  ,
										RATE2 , RATE3, RATE4, BOTIME1, BOTIME2, BOTIME3, BOTIME4, TIME_DAY, TIME_NIGHT )
			SELECT CALNDR, :ls_wrk_c, JANUP, YAYUP  , CHLYA  , TUKGN  , RATE1  ,
					 RATE2 , RATE3    , RATE4, BOTIME1, BOTIME2, BOTIME3, BOTIME4, TIME_DAY, TIME_NIGHT
			  FROM PDTCAL
			 WHERE CALNDR LIKE :ls_mon_b||'%'
				AND PDTGU  =    :ls_wrk_b ;
			If SQLCA.SQLCODE <> 0 Then
				ROLLBACK USING SQLCA;
				MessageBox('복사 실패 - by Loop(ins)', '자료 복사 중 오류가 발생 했습니다.')
				Return
			End If
		Else
			ll_ret = wf_update(ls_mon_b, ls_wrk_b, ls_wrk_c)
			If ll_ret <> 1 Then
				ROLLBACK USING SQLCA;
				MessageBox('복사 실패 - wf_update()', '자료 복사 중 오류가 발생했습니다.')
				Return
			End If
		End If	
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('복사 실패', '자료 복사 중 오류가 발생 했습니다.')
	Return
End If
end subroutine

public subroutine wf_day ();dw_1.AcceptText()
dw_2.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_wrk_b

ls_wrk_b = dw_1.GetItemString(row, 'wkctr_base')
If Trim(ls_wrk_b) = '' OR IsNull(ls_wrk_b) Then
	MessageBox('From 항목 확인', '원본 대상의 작업장을 확인 하십시오.')
	dw_1.SetColumn('wkctr_base')
	dw_1.SetFocus()
	Return
End If

String ls_days_b
String ls_daye_b

ls_days_b = dw_1.GetItemString(row, 'sd_base')
If Trim(ls_days_b) = '' OR IsNull(ls_days_b) Then
	MessageBox('From 항목 확인', '원본 대상의 기간을 확인 하십시오.')
	dw_1.SetColumn('sd_base')
	dw_1.SetFocus()
	Return
End If

ls_daye_b = dw_1.GetItemString(row, 'ed_base')
If Trim(ls_daye_b) = '' OR IsNull(ls_daye_b) Then
	MessageBox('From 항목 확인', '원본 대상의 기간을 확인 하십시오.')
	dw_1.SetColumn('ed_base')
	dw_1.SetFocus()
	Return
End If

Long   ll_cnt
Long   i

ll_cnt  = dw_2.RowCount()
If ll_cnt < 1 Then Return

String ls_chk
String ls_wrk_c

If MessageBox('자료복사-일별', '작업장의 부하시간을 복사 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

Long   ll_ret
Long   ll_chk

For i = 1 To ll_cnt
	ls_chk = dw_2.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_wrk_c = dw_2.GetItemString(i, 'wkctr')
		If Trim(ls_wrk_c) = '' OR IsNull(ls_wrk_c) Then
			MessageBox('From 항목 확인', '복사 대상의 작업장을 확인 하십시오.')
			dw_2.SetColumn('wkctr')
			dw_2.SetFocus()
			Return
		End If
		
		SELECT COUNT('X')
		  INTO :ll_chk
		  FROM PDTCAL
		 WHERE CALNDR >= :ls_days_b
		   AND CALNDR <= :ls_daye_b
		   AND PDTGU  =  :ls_wrk_c ;
		If ll_chk < 1 OR IsNull(ll_chk) Then		
			INSERT INTO PDTCAL ( CALNDR, PDTGU, JANUP, YAYUP  , CHLYA  , TUKGN  , RATE1  ,
										RATE2 , RATE3, RATE4, BOTIME1, BOTIME2, BOTIME3, BOTIME4, TIME_DAY, TIME_NIGHT )
			SELECT CALNDR, :ls_wrk_c, JANUP, YAYUP  , CHLYA  , TUKGN  , RATE1  ,
					 RATE2 , RATE3    , RATE4, BOTIME1, BOTIME2, BOTIME3, BOTIME4, TIME_DAY, TIME_NIGHT
			  FROM PDTCAL
			 WHERE CALNDR >= :ls_days_b
		      AND CALNDR <= :ls_daye_b
				AND PDTGU  =  :ls_wrk_b ;
			If SQLCA.SQLCODE <> 0 Then
				ROLLBACK USING SQLCA;
				MessageBox('복사 실패 - by Loop(ins)', '자료 복사 중 오류가 발생 했습니다.')
				Return
			End If
		Else
			ll_ret = wf_update2(ls_days_b, ls_daye_b, ls_wrk_b, ls_wrk_c)
			If ll_ret <> 1 Then
				ROLLBACK USING SQLCA;
				MessageBox('복사 실패 - wf_update2()', '자료 복사 중 오류가 발생했습니다.')
				Return
			End If
		End If	
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('복사 실패', '자료 복사 중 오류가 발생 했습니다.')
	Return
End If
end subroutine

public function integer wf_update2 (string as_getday_s, string as_getday_e, string as_getwrk, string as_inswrk);Date ld_st
Date ld_ed

ld_st = Date(LEFT(as_getday_s, 4) + '-' + MID(as_getday_s, 5, 2) + '-' + RIGHT(as_getday_s, 2))
ld_ed = Date(LEFT(as_getday_e, 4) + '-' + MID(as_getday_e, 5, 2) + '-' + RIGHT(as_getday_e, 2))

Long   ll_cnt

ll_cnt = DaysAfter(ld_st, ld_ed) + 1

Long   i
Double ldb_bot, lbl_day, lbl_night
String ls_day

For i = 1 To ll_cnt
	ls_day = String(RelativeDate(ld_st, (i - 1)), 'yyyymmdd')
	
	SELECT BOTIME1, TIME_DAY, TIME_NIGHT
	  INTO :ldb_bot, :lbl_day, :lbl_night
	  FROM PDTCAL
	 WHERE CALNDR = :ls_day
	   AND PDTGU  = :as_getwrk ;
	If ldb_bot < 1 OR IsNull(ldb_bot) Then ldb_bot = 0
	
	UPDATE PDTCAL
	   SET BOTIME1 = :ldb_bot,
		    TIME_DAY = :lbl_day,
			 TIME_NIGHT = :lbl_night
	 WHERE CALNDR  = :ls_day
	   AND PDTGU   = :as_inswrk ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('복사실패', '자료 복사 중 오류가 발생했습니다!')
		Return -1
	End If
Next

Return 1
end function

on w_pdm_01420_copy.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdm_01420_copy.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_1.SetItem(1, 'mon_base', String(TODAY(), 'yyyymm'))

dw_2.Retrieve()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdm_01420_copy
boolean visible = false
integer x = 0
integer y = 0
integer width = 41
integer height = 44
end type

type p_exit from w_inherite_popup`p_exit within w_pdm_01420_copy
integer x = 1737
integer y = 28
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdm_01420_copy
boolean visible = false
integer x = 1335
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_pdm_01420_copy
integer x = 1563
integer y = 28
end type

event p_choose::clicked;call super::clicked;If rb_1.Checked = True Then
	wf_mon()
Else
	wf_day()
End If
end event

type dw_1 from w_inherite_popup`dw_1 within w_pdm_01420_copy
integer x = 23
integer y = 8
integer width = 1298
integer height = 324
string dataobject = "d_pdm_01420_copy"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::rowfocuschanged;//

end event

type sle_2 from w_inherite_popup`sle_2 within w_pdm_01420_copy
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdm_01420_copy
end type

type cb_return from w_inherite_popup`cb_return within w_pdm_01420_copy
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdm_01420_copy
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdm_01420_copy
end type

type st_1 from w_inherite_popup`st_1 within w_pdm_01420_copy
end type

type dw_2 from datawindow within w_pdm_01420_copy
integer x = 41
integer y = 348
integer width = 1879
integer height = 1280
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01420_copy_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event itemchanged;This.AcceptText()

Choose Case dwo.name
	Case 'chk'
		
End Choose
end event

event clicked;Long	ll_i, snull

IF row <= 0 THEN 

	this.SelectRow(0, False)
	Setnull(sNull)
	
	if dwo.name = 'chk_t' then
		if this.RowCount() <= 0 then return
		if this.object.chk_t.text = '▣' then 
			for ll_i = 1 to this.RowCount() 
				SetItem(ll_i, 'chk', 'N')
			next
			this.object.chk_t.text = '□'
		else
			for ll_i = 1 to this.RowCount()   
				SetItem(ll_i, 'chk', 'Y') 
			next
			this.object.chk_t.text = '▣'
		end if
		return
	end if
	
ELSE
	f_multi_select(This)
END IF 

end event

type rb_1 from radiobutton within w_pdm_01420_copy
integer x = 1358
integer y = 188
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "月 복사"
boolean checked = true
end type

event clicked;dw_1.DataObject = 'd_pdm_01420_copy'
dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
end event

type rb_2 from radiobutton within w_pdm_01420_copy
integer x = 1358
integer y = 256
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "日 복사"
end type

event clicked;dw_1.DataObject = 'd_pdm_01420_copy1'
dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
end event

type rr_1 from roundrectangle within w_pdm_01420_copy
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 336
integer width = 1911
integer height = 1308
integer cornerheight = 40
integer cornerwidth = 55
end type

