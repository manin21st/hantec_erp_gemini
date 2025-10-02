$PBExportHeader$w_sm10_0045.srw
$PBExportComments$모비스 납품관리
forward
global type w_sm10_0045 from w_inherite
end type
type dw_print from datawindow within w_sm10_0045
end type
type rr_2 from roundrectangle within w_sm10_0045
end type
type st_3 from statictext within w_sm10_0045
end type
type e_ek from singlelineedit within w_sm10_0045
end type
type cb_ek from commandbutton within w_sm10_0045
end type
type cb_eh from commandbutton within w_sm10_0045
end type
type e_eh from singlelineedit within w_sm10_0045
end type
type st_2 from statictext within w_sm10_0045
end type
type st_4 from statictext within w_sm10_0045
end type
type cb_1 from commandbutton within w_sm10_0045
end type
type em_1 from editmask within w_sm10_0045
end type
type dw_prt from datawindow within w_sm10_0045
end type
type cb_2 from commandbutton within w_sm10_0045
end type
type r_1 from rectangle within w_sm10_0045
end type
end forward

global type w_sm10_0045 from w_inherite
string title = "MOBIS A/S VAN 일 발주 현황"
dw_print dw_print
rr_2 rr_2
st_3 st_3
e_ek e_ek
cb_ek cb_ek
cb_eh cb_eh
e_eh e_eh
st_2 st_2
st_4 st_4
cb_1 cb_1
em_1 em_1
dw_prt dw_prt
cb_2 cb_2
r_1 r_1
end type
global w_sm10_0045 w_sm10_0045

forward prototypes
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

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

on w_sm10_0045.create
int iCurrent
call super::create
this.dw_print=create dw_print
this.rr_2=create rr_2
this.st_3=create st_3
this.e_ek=create e_ek
this.cb_ek=create cb_ek
this.cb_eh=create cb_eh
this.e_eh=create e_eh
this.st_2=create st_2
this.st_4=create st_4
this.cb_1=create cb_1
this.em_1=create em_1
this.dw_prt=create dw_prt
this.cb_2=create cb_2
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_print
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.e_ek
this.Control[iCurrent+5]=this.cb_ek
this.Control[iCurrent+6]=this.cb_eh
this.Control[iCurrent+7]=this.e_eh
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.em_1
this.Control[iCurrent+12]=this.dw_prt
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.r_1
end on

on w_sm10_0045.destroy
call super::destroy
destroy(this.dw_print)
destroy(this.rr_2)
destroy(this.st_3)
destroy(this.e_ek)
destroy(this.cb_ek)
destroy(this.cb_eh)
destroy(this.e_eh)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.dw_prt)
destroy(this.cb_2)
destroy(this.r_1)
end on

event open;call super::open;dw_input.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

dw_input.InsertRow(0)

//dw_input.Object.nap_date1[1] = is_today
//dw_input.Object.nap_date2[1] = is_today

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_input.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_input.Modify("saupj.protect=1")
   End if
End If




end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", false) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
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
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
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

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0045
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0045
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0045
end type

type st_1 from w_inherite`st_1 within w_sm10_0045
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm10_0045
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0045
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0045
end type

type p_mod from w_inherite`p_mod within w_sm10_0045
integer y = 3200
end type

event p_mod::clicked;call super::clicked;
String ls_itnbr ,ls_cmark,ls_vndcd , ls_comord , ls_saupj
Long i
If dw_insert.AcceptText() < 1 Then Return

If f_msg_update() < 1 Then Return

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장 실패')
	Return
Else
	Commit;
End if


end event

type p_del from w_inherite`p_del within w_sm10_0045
integer y = 3200
end type

type p_inq from w_inherite`p_inq within w_sm10_0045
integer y = 3200
end type

event p_inq::clicked;call super::clicked;
string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

dw_input.accepttext()

ls_gubun = Trim(dw_input.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_input.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_input.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_input.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_input.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '19000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '29991231'

//dw_insert.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)
dw_insert.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate)


end event

type p_print from w_inherite`p_print within w_sm10_0045
integer y = 3200
end type

event p_print::clicked;call super::clicked;string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

if dw_insert.rowcount() = 0 then
	Return
end if

ls_gubun = Trim(dw_input.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_input.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_input.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_input.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_input.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '20000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '30000101'

dw_print.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)

OpenWithParm(w_print_preview, dw_print)
end event

type p_can from w_inherite`p_can within w_sm10_0045
integer y = 3200
end type

event p_can::clicked;call super::clicked;dw_input.SetRedraw(False)
dw_input.Reset()
dw_input.InsertRow(0)
dw_input.SetRedraw(True)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_input.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_input.Modify("saupj.protect=1")
   End if
End If


end event

type p_exit from w_inherite`p_exit within w_sm10_0045
integer y = 3200
end type

event p_exit::clicked;close(parent)
end event

type p_ins from w_inherite`p_ins within w_sm10_0045
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0045
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0045
event ue_enter pbm_dwnprocessenter
integer y = 56
integer width = 2377
integer height = 252
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0045_menu"
end type

event ue_enter;SEND(Handle(This), 256, 9, 0)
Return 1
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0045
integer x = 37
integer y = 328
integer width = 3488
integer height = 1964
string dataobject = "d_sm10_0045_napum"
end type

event dw_insert::clicked;call super::clicked;f_multi_select(this)
//IF row <= 0  THEN RETURN
//
//IF IsSelected(row) THEN
//	Selectrow(0,False)
//ELSE
//	Selectrow(0,False)
//	Selectrow(row,True)
//END IF

end event

type cb_mod from w_inherite`cb_mod within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0045
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0045
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0045
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0045
end type

type r_head from w_inherite`r_head within w_sm10_0045
integer width = 2386
integer height = 260
end type

type r_detail from w_inherite`r_detail within w_sm10_0045
integer y = 324
end type

type dw_print from datawindow within w_sm10_0045
boolean visible = false
integer x = 3415
integer y = 168
integer width = 183
integer height = 128
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0045p"
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_sm10_0045
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3616
integer y = 2328
integer width = 878
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_3 from statictext within w_sm10_0045
boolean visible = false
integer x = 3653
integer y = 2480
integer width = 238
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
string text = "EK, DH"
boolean focusrectangle = false
end type

type e_ek from singlelineedit within w_sm10_0045
boolean visible = false
integer x = 3909
integer y = 2468
integer width = 366
integer height = 64
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean autohscroll = false
boolean hideselection = false
end type

type cb_ek from commandbutton within w_sm10_0045
boolean visible = false
integer x = 4347
integer y = 2468
integer width = 128
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "OK"
end type

event clicked;	Update van_mobis_br Set due_date_boogook = :e_ek.text
	                where (SUBSTR(ORDNO,1,2) = 'EK') or (SUBSTR(ORDNO,1,2) = 'DT');

	If sqlca.sqlcode <> 0 Then
		messageBox('',sqlca.sqlerrtext)
		rollback ;
		Return
	else
		commit;
	end if
	
	p_inq.triggerevent(clicked!)	
end event

type cb_eh from commandbutton within w_sm10_0045
boolean visible = false
integer x = 4347
integer y = 2372
integer width = 128
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "OK"
end type

event clicked;	Update van_mobis_br Set due_date_boogook = :e_eh.text
	                where SUBSTR(ORDNO,1,2) = 'EH';

	If sqlca.sqlcode <> 0 Then
		messageBox('',sqlca.sqlerrtext)
		rollback ;
		Return
	else
		commit;
	end if
	
	p_inq.triggerevent(clicked!)	
end event

type e_eh from singlelineedit within w_sm10_0045
boolean visible = false
integer x = 3909
integer y = 2372
integer width = 366
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean autohscroll = false
boolean hideselection = false
end type

type st_2 from statictext within w_sm10_0045
boolean visible = false
integer x = 3653
integer y = 2384
integer width = 183
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
string text = "EH"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sm10_0045
boolean visible = false
integer x = 2519
integer y = 96
integer width = 462
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "납품일 일괄지정"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sm10_0045
boolean visible = false
integer x = 2981
integer y = 168
integer width = 206
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "적용"
end type

event clicked;String ls_text

ls_text = LEFT(em_1.Text, 4) + MID(em_1.Text, 6, 2) + RIGHT(em_1.Text, 2)
If Trim(ls_text) = '' OR IsNull(ls_text) OR ls_text = '00000000' Then
	MessageBox('일자확인', '일자를 입력 하십시오.')
	Return
End If

Long   i

For i = 1 To dw_insert.RowCount()
	i = dw_insert.GetSelectedRow(i - 1)
	If i < 1 Then Exit
	dw_insert.SetItem(i, 'due_date_boogook', ls_text)
Next

end event

type em_1 from editmask within w_sm10_0045
boolean visible = false
integer x = 2519
integer y = 172
integer width = 457
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

type dw_prt from datawindow within w_sm10_0045
boolean visible = false
integer x = 3250
integer y = 172
integer width = 146
integer height = 112
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm10_0045p_minap"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_sm10_0045
integer x = 3259
integer y = 64
integer width = 457
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미납품 출력"
end type

event clicked;string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

if dw_insert.rowcount() = 0 then
	Return
end if

ls_gubun = Trim(dw_input.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_input.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_input.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_input.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_input.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '19000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '29991231'

dw_prt.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)

OpenWithParm(w_print_preview, dw_prt)
end event

type r_1 from rectangle within w_sm10_0045
boolean visible = false
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 12639424
integer x = 2455
integer y = 52
integer width = 782
integer height = 260
end type

