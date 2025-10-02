$PBExportHeader$w_res01_00010.srw
$PBExportComments$** EO NO 관리
forward
global type w_res01_00010 from w_inherite
end type
type cb_1 from commandbutton within w_res01_00010
end type
type dw_list from u_d_popup_sort within w_res01_00010
end type
type tab_1 from tab within w_res01_00010
end type
type tabpage_1 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type dw_4 from datawindow within tabpage_1
end type
type p_2 from picture within tabpage_1
end type
type p_3 from picture within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_2 rr_2
dw_1 dw_1
dw_4 dw_4
p_2 p_2
p_3 p_3
end type
type tabpage_2 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type dw_6 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_1 rr_1
dw_2 dw_2
dw_6 dw_6
end type
type tabpage_3 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type dw_7 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_4 rr_4
dw_3 dw_3
dw_7 dw_7
end type
type tabpage_4 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_4
end type
type dw_5 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rr_5 rr_5
dw_5 dw_5
end type
type tab_1 from tab within w_res01_00010
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type p_1 from uo_picture within w_res01_00010
end type
type r_list from rectangle within w_res01_00010
end type
end forward

global type w_res01_00010 from w_inherite
integer width = 4672
integer height = 2512
string title = "EO NO 관리"
boolean controlmenu = false
boolean minbox = false
boolean resizable = false
cb_1 cb_1
dw_list dw_list
tab_1 tab_1
p_1 p_1
r_list r_list
end type
global w_res01_00010 w_res01_00010

type variables
datawindowchild	idwc1, idwc2

end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_init ()
end prototypes

public function integer wf_required_chk ();If dw_insert.AcceptText() < 1 Then Return -1
If dw_insert.RowCount() < 1 Then Return -1

String ls_itnbr , ls_cvcod ,ls_cvgub ,ls_act_dt ,ls_result
Long   ll_row

ls_itnbr   = Trim(dw_insert.Object.itnbr[1])
ls_cvcod   = Trim(dw_insert.Object.cvcod[1])
ls_cvgub   = Trim(dw_insert.Object.cvgub[1])
ls_act_dt  = Trim(dw_insert.Object.act_dt[1])

ls_result  = Trim(dw_insert.Object.result_yn[1])

If ls_itnbr = '' Or isNull(ls_itnbr) Then
	f_message_chk(33 , '[품번]')
	dw_insert.SetColumn("itnbr")
	Return -1
End If
	
If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(33 , '[거래처코드]')
	dw_insert.SetColumn("cvcod")
	Return -1
End If

If ls_cvgub = '' Or isNull(ls_cvgub) Then
	f_message_chk(33 , '[거래처구분]')
	dw_insert.SetColumn("cvgub")
	Return -1
End If


If ls_act_dt = '' Or isNull(ls_act_dt) Or f_datechk(ls_act_dt) < 0  Then
	f_message_chk(35 , '[처리일자]')
	dw_insert.SetColumn("act_dt")
	Return -1
End If


If ls_result = '' Or isNull(ls_result) Then
	f_message_chk(33 , '[판정]')
	dw_insert.SetColumn("result_yn")
	Return -1
End If


return 1
end function

public function integer wf_init ();dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.Object.bal_dt[1] = is_today
dw_insert.SetRedraw(True)

Return 1
end function

on w_res01_00010.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_list=create dw_list
this.tab_1=create tab_1
this.p_1=create p_1
this.r_list=create r_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.r_list
end on

on w_res01_00010.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.tab_1)
destroy(this.p_1)
destroy(this.r_list)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

tab_1.tabpage_1.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_4.GetChild('eo_no2', idwc1)
idwc1.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_4.GetChild('eo_no3', idwc2)
idwc2.SetTransObject(SQLCA)

wf_init()

dw_input.SetRedraw(False)
dw_input.Reset()
dw_input.InsertRow(0)
dw_input.SetFocus()
dw_input.SetRedraw(True)

dw_insert.sharedata(tab_1.tabpage_1.dw_1)
dw_insert.sharedata(tab_1.tabpage_2.dw_2)
dw_insert.sharedata(tab_1.tabpage_3.dw_3)
dw_insert.sharedata(tab_1.tabpage_4.dw_5)

tab_1.tabpage_1.dw_4.sharedata(tab_1.tabpage_2.dw_6)
tab_1.tabpage_1.dw_4.sharedata(tab_1.tabpage_3.dw_7)







end event

event resize;r_head.width = this.width - 60
dw_input.width = this.width - 70

r_list.width = this.width - 2779
r_list.height = this.height - r_list.y - 65
dw_list.width = this.width - 2789
dw_list.height = this.height - dw_list.y - 70

tab_1.x = r_list.x + r_list.width + 22
tab_1.height = this.height - tab_1.y - 65

tab_1.tabpage_1.rr_2.height = tab_1.height - 204
tab_1.tabpage_2.rr_1.height = tab_1.height - 204
tab_1.tabpage_3.rr_4.height = tab_1.height - 204
tab_1.tabpage_4.rr_5.height = tab_1.height - 204

tab_1.tabpage_1.dw_4.height = tab_1.height - 1308
tab_1.tabpage_2.dw_6.height = tab_1.height - 1308
tab_1.tabpage_3.dw_7.height = tab_1.height - 1308
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_res01_00010
end type

type sle_msg from w_inherite`sle_msg within w_res01_00010
integer x = 352
integer y = 3520
end type

type dw_datetime from w_inherite`dw_datetime within w_res01_00010
integer x = 2843
integer y = 3520
end type

type st_1 from w_inherite`st_1 within w_res01_00010
integer y = 3520
end type

type p_search from w_inherite`p_search within w_res01_00010
end type

type p_addrow from w_inherite`p_addrow within w_res01_00010
integer x = 3049
integer y = 80
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_res01_00010
integer x = 3237
integer y = 80
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_res01_00010
integer y = 3200
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)
If dw_insert.AcceptText() = -1 Then Return -1
If dw_insert.RowCount() < 1 Then Return

int li_cnt
String ls_itnbr , ls_eono ,ls_actdt, ls_baldt

ls_itnbr = Trim(dw_insert.Object.itnbr[1])
ls_eono  = Trim(dw_insert.Object.eo_no[1])
ls_actdt = Trim(dw_insert.Object.act_dt[1])
ls_baldt = Trim(dw_insert.Object.bal_dt[1])


//eo_tb_sul_act_qty

If ls_itnbr = '' Or isNull(ls_itnbr) Then 
	f_message_chk(33,'[품번]')
	dw_insert.SetFocus()
	dw_insert.SetColumn("itnbr")
	Return
End if

If ls_eono = '' Or isNull(ls_eono) Then 
	f_message_chk(33,'[EO NO]')
	dw_insert.SetFocus()
	dw_insert.SetColumn("eo_no")
	Return
End if

If ls_actdt = '' Or isNull(ls_actdt) Or f_datechk(ls_actdt) < 1  Then 
	f_message_chk(35,'[적용일자]')
	dw_insert.SetFocus()
	dw_insert.SetColumn("act_dt")
	Return
End if

If f_datechk(ls_baldt) < 1  Then 
	f_message_chk(35,'[발행일자]')
	dw_insert.SetFocus()
	dw_insert.SetColumn("bal_dt")
	Return
End if

IF dw_insert.getitemstatus( 1, 0, primary!) = NewModified!	then
	// 중복 체크
	SELECT COUNT(*) INTO :li_cnt
	FROM EO_TB
	WHERE ITNBR = :ls_itnbr
	  AND EO_NO = :ls_eono ;
	if li_cnt > 0 then 
		messagebox('확인','중복된 자료가 존재 합니다')
		return 
	end if	  
end if 
 

long		i
string		ls_plnt, ls_eono3

FOR i = 1 TO tab_1.tabpage_1.dw_4.RowCount()
	ls_plnt = tab_1.tabpage_1.dw_4.GetItemString(i, 'plnt')
	If ls_plnt = '' Or isNull(ls_plnt) Then 
		f_message_chk(33,'[납품처 공장]')
		Return
	End if
	
	ls_eono3 = tab_1.tabpage_1.dw_4.GetItemString(i, 'eo_no3')
	If ls_eono3 = '' Or isNull(ls_eono3) Then 
		f_message_chk(33,'[적용 EO]')
		Return
	End if
NEXT


If f_msg_update() = -1 Then Return  //저장 Yes/No ?


dw_insert.Object.sabu[1] = gs_sabu
dw_insert.AcceptText()

If dw_insert.Update() <> 1 Then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]')
	w_mdi_frame.sle_msg.text = "저장작업을 실패 하였습니다!"
	Return
Else
	tab_1.tabpage_1.dw_4.Update()
	
	Commit ;
//	dw_input.Object.itnbr[1] = ls_itnbr
	w_mdi_frame.sle_msg.text = "저장작업을 완료 하였습니다!"
//	p_inq.TriggerEvent(Clicked!)
End If

ib_any_typing = False //입력필드 변경여부 No

SetPointer(Arrow!)
 
end event

type p_del from w_inherite`p_del within w_res01_00010
integer y = 3200
end type

event p_del::clicked;call super::clicked;If dw_insert.RowCount() < 1 Then Return

If f_msg_delete() < 1 Then Return

String ls_new ,ls_itnbr, ls_eono
Long   ll_fr

dw_insert.AcceptText()

ls_itnbr = Trim(dw_insert.Object.itnbr[1])
ls_eono  = Trim(dw_insert.Object.eo_no[1])
ls_new   = Trim(dw_insert.Object.is_new[1])

dw_insert.DeleteRow(1)
If ls_new = 'Y' Then Return

If dw_insert.Update() = 1 Then
	Commit;
	ll_fr = dw_list.Find("itnbr = '"+ls_itnbr+"' and eo_no = '"+ls_eono+"'",1,dw_list.RowCount())
	If ll_fr > 0 Then
		dw_list.DeleteRow(ll_fr)
	End if
	wf_init()
Else
	Rollback ;
	f_rollback()
	Return
End If


end event

type p_inq from w_inherite`p_inq within w_res01_00010
integer y = 3200
end type

event p_inq::clicked;call super::clicked;If dw_input.AcceptText() < 1 Then Return
If dw_input.RowCount() < 1 Then Return

String ls_itnbr, ls_eo_no
Long   ll_row

ls_itnbr = Trim(dw_input.Object.itnbr[1])
ls_eo_no = Trim(dw_input.Object.eo_no[1])

if isnull(ls_itnbr) then ls_itnbr = ''
if isnull(ls_eo_no) then ls_eo_no = ''

ll_row = dw_list.Retrieve(gs_sabu, ls_itnbr + '%', ls_eo_no + '%')

If ll_row > 0 Then
	ib_any_typing = False //입력필드 변경여부 No
Else
	wf_init()
	f_message_chk(50, "")
End If



		

end event

type p_print from w_inherite`p_print within w_res01_00010
integer y = 3200
end type

type p_can from w_inherite`p_can within w_res01_00010
integer y = 3200
end type

event p_can::clicked;call super::clicked;

wf_init()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

p_del.Enabled = False
p_del.PictureName = '..\image\삭제_d.gif'
ib_any_typing = False //입력필드 변경여부 No


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "..\image\자료조회_dn.gif"
end event

type p_exit from w_inherite`p_exit within w_res01_00010
integer y = 3200
end type

event p_exit::clicked;Close(parent)
end event

type p_ins from w_inherite`p_ins within w_res01_00010
integer y = 3200
end type

type p_new from w_inherite`p_new within w_res01_00010
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_res01_00010
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer y = 56
integer width = 4559
integer height = 188
integer taborder = 90
string title = "none"
string dataobject = "d_res01_00010_1"
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;String ls_col ,ls_cod
Long   ll_cnt ,ll_row

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			ls_itdsc = ''
//			f_message_chk(33, "[품번]")
//			This.Object.itnbr[GetRow()] = ""
//			open(w_itemas_popup)
//			Return 1
		End If
		
		This.Object.itdsc[GetRow()] = ls_itdsc	
		p_inq.TriggerEvent(Clicked!)
End Choose
 
end event

event rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_gubun = '1'
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')

End Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_res01_00010
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_res01_00010
boolean visible = false
integer x = 3579
integer y = 3368
integer width = 773
integer height = 412
integer taborder = 20
string dataobject = "d_res01_00010_b"
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod
Long   ll_cnt ,ll_row

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc
		
End Choose
 
end event

event dw_insert::rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')

End Choose

end event

event dw_insert::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_insert::ue_pressenter;Choose Case Lower(GetColumnName())
	Case "ecd_txt","dong_eono"
		Return
	Case Else
		Send(Handle(this),256,9,0)
		Return 1
End Choose
end event

type cb_mod from w_inherite`cb_mod within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_res01_00010
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_res01_00010
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_res01_00010
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_res01_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_res01_00010
end type

type r_head from w_inherite`r_head within w_res01_00010
integer width = 4567
end type

type r_detail from w_inherite`r_detail within w_res01_00010
boolean visible = false
integer x = 3575
integer y = 3364
integer width = 781
integer height = 420
end type

type cb_1 from commandbutton within w_res01_00010
boolean visible = false
integer x = 2267
integer y = 2440
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_list from u_d_popup_sort within w_res01_00010
integer x = 37
integer y = 300
integer width = 1876
integer height = 2100
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_res01_00010_a"
boolean border = false
end type

event doubleclicked;call super::doubleclicked;If row < 1 Then Return

AcceptText()

String ls_itnbr, ls_eono 

ls_eono = Trim(Object.eo_no[row])
ls_itnbr = Trim(Object.itnbr[row])

If ls_itnbr = '' Or isNull(ls_itnbr) Then Return
If ls_eono = '' Or isNull(ls_eono) Then Return

dw_insert.SetRedraw(False)

If dw_insert.Retrieve(gs_sabu ,ls_itnbr, ls_eono) < 1 Then
	dw_insert.Reset()
	dw_insert.InsertRow(0)
	dw_insert.object.bal_dt[1] = is_today
	p_del.Enabled = False
	p_del.PictureName = '..\image\삭제_d.gif'
Else
	p_del.Enabled = True
	p_del.PictureName = '..\image\삭제_up.gif'
End If

dw_insert.SetRedraw(True)
	

end event

event clicked;call super::clicked;setrow(row)

If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
END IF

If currentrow < 1 Then Return

AcceptText()

String ls_itnbr, ls_eono 

ls_eono = Trim(Object.eo_no[currentrow])
ls_itnbr = Trim(Object.itnbr[currentrow])

If ls_itnbr = '' Or isNull(ls_itnbr) Then Return
If ls_eono = '' Or isNull(ls_eono) Then Return

dw_insert.SetRedraw(False)

If dw_insert.Retrieve(gs_sabu ,ls_itnbr, ls_eono) < 1 Then
	dw_insert.Reset()
	dw_insert.InsertRow(0)
	dw_insert.object.bal_dt[1] = is_today
	p_del.Enabled = False
	p_del.PictureName = '..\image\삭제_d.gif'
Else
	p_del.Enabled = True
	p_del.PictureName = '..\image\삭제_up.gif'
End If

dw_insert.SetRedraw(True)

// 
idwc1.Retrieve(ls_itnbr)
idwc2.Retrieve(ls_itnbr)
tab_1.tabpage_1.dw_4.Retrieve(gs_sabu ,ls_itnbr, '%')

end event

type tab_1 from tab within w_res01_00010
integer x = 1938
integer y = 296
integer width = 2665
integer height = 2108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2629
integer height = 1996
long backcolor = 16777215
string text = "개발"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_1 dw_1
dw_4 dw_4
p_2 p_2
p_3 p_3
end type

on tabpage_1.create
this.rr_2=create rr_2
this.dw_1=create dw_1
this.dw_4=create dw_4
this.p_2=create p_2
this.p_3=create p_3
this.Control[]={this.rr_2,&
this.dw_1,&
this.dw_4,&
this.p_2,&
this.p_3}
end on

on tabpage_1.destroy
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.dw_4)
destroy(this.p_2)
destroy(this.p_3)
end on

type rr_2 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 14
integer y = 24
integer width = 2542
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within tabpage_1
event ue_enter pbm_dwnprocessenter
integer x = 82
integer y = 88
integer width = 2469
integer height = 852
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_b1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;If This.GetColumnName() <> 'ecd_txt'Then
	Send(Handle(This), 256, 9, 0)
	Return 1
End If

end event

event rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_gubun = '1'
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')

End Choose

end event

event itemchanged;String ls_col ,ls_cod, s_date, snull
Long   ll_cnt ,ll_row

setnull(snull)

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc
		
	case 'act_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[적용일자]')
//			this.SetItem(1,"act_dt",snull)
			this.Setcolumn("act_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'bal_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[발행일자]')
//			this.SetItem(1,"bal_dt",snull)
			this.Setcolumn("bal_dt")
			this.SetFocus()
			Return 1
		END IF				
	case 'eo_tb_sul_act_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[일자]')
//			this.SetItem(1,"eo_tb_sul_act_dt",snull)
			this.Setcolumn("eo_tb_sul_act_dt")
			this.SetFocus()
			Return 1
		END IF						
//		
	Case 'eo_no'
		s_date = Trim(This.GetText())
		If s_date = '' OR IsNull(s_date) Then
			This.SetItem(1, 'eo_no2', '')
		Else
			This.SetItem(1, 'eo_no2', s_date)
		End If
		
		
End Choose
 
end event

event itemerror;RETURN 1
end event

type dw_4 from datawindow within tabpage_1
integer x = 55
integer y = 1084
integer width = 2450
integer height = 800
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_c1"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;setrow(row)

If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

event itemchanged;long	ll_row

if dwo.name = 'plnt' then
	
	if row > 1 then
		ll_row = this.find("plnt = '"+data+"'", 1, row - 1)
		if ll_row > 0 then
			messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
			this.setitem(row, 'plnt', '')
			return 1
		end if
	end if
	
	ll_row = this.find("plnt = '"+data+"'", row + 1, this.rowcount())
	if ll_row > 0 then
		messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
		this.setitem(row, 'plnt', '')
		return 1
	end if
		
end if
end event

event itemerror;return 1
end event

type p_2 from picture within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2126
integer y = 932
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "..\image\행추가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "..\image\행추가_dn.gif"
end event

event ue_lbuttonup;PictureName = "..\image\행추가_up.gif"
end event

event clicked;long		ll_row
string		ls_itnbr, ls_eono

ls_itnbr = dw_1.GetItemString(1, 'itnbr')

SELECT MAX(EO_NO)
     INTO :ls_eono
   FROM EO_TB
WHERE ITNBR = :ls_itnbr
     AND ACT_DT = (SELECT MAX(ACT_DT) FROM EO_TB WHERE ITNBR = :ls_itnbr);
	 

ll_row = dw_4.InsertRow(0)
dw_4.SetItem(ll_row, 'sabu', gs_sabu)
dw_4.SetItem(ll_row, 'itnbr', ls_itnbr)
dw_4.SetItem(ll_row, 'eo_no', ls_eono)

end event

type p_3 from picture within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2304
integer y = 932
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "..\image\행삭제_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "..\image\행삭제_dn.gif"
end event

event ue_lbuttonup;PictureName = "..\image\행삭제_up.gif"
end event

event clicked;dw_4.DeleteRow(0)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2629
integer height = 1996
long backcolor = 16777215
string text = "영업"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_2 dw_2
dw_6 dw_6
end type

on tabpage_2.create
this.rr_1=create rr_1
this.dw_2=create dw_2
this.dw_6=create dw_6
this.Control[]={this.rr_1,&
this.dw_2,&
this.dw_6}
end on

on tabpage_2.destroy
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.dw_6)
end on

type rr_1 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 18
integer y = 28
integer width = 2542
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within tabpage_2
event ue_enter pbm_dwnprocessenter
integer x = 82
integer y = 76
integer width = 2459
integer height = 836
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_b2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;If This.GetColumnName() <> 'req_part'Then
	Send(Handle(This), 256, 9, 0)
	Return 1
End If

end event

event rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_gubun = '1'
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')

End Choose

end event

event itemchanged;String ls_col ,ls_cod, s_date, snull
Long   ll_cnt ,ll_row

setnull(snull)

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc
		
	case 'eo_tb_chungu_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[청구일자]')
//			this.SetItem(1,"eo_tb_chungu_dt",snull)
			this.Setcolumn("eo_tb_chungu_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_ploto_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[견본생산일자]')
//			this.SetItem(1,"eo_tb_ploto_dt",snull)
			this.Setcolumn("eo_tb_ploto_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_isir_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[ISIR 승인일자]')
//			this.SetItem(1,"eo_tb_isir_dt",snull)
			this.Setcolumn("eo_tb_isir_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_chodo_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[초도품 생산일자]')
//			this.SetItem(1,"eo_tb_chodo_dt",snull)
			this.Setcolumn("eo_tb_chodo_dt")
			this.SetFocus()
			Return 1
		END IF	
	case 'eo_tb_chul_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[출하일자]')
//			this.SetItem(1,"eo_tb_chul_dt",snull)
			this.Setcolumn("eo_tb_chul_dt")
			this.SetFocus()
			Return 1
		END IF		
		
	Case 'eo_no'
		This.SetItem(1, 'eo_tb_eo_no2', data)
End Choose
 
end event

event itemerror;RETURN 1
end event

type dw_6 from datawindow within tabpage_2
integer x = 55
integer y = 1084
integer width = 2450
integer height = 800
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_c2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;setrow(row)

If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

event itemchanged;long	ll_row

if dwo.name = 'plnt' then
	
	if row > 1 then
		ll_row = this.find("plnt = '"+data+"'", 1, row - 1)
		if ll_row > 0 then
			messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
			this.setitem(row, 'plnt', '')
			return 1
		end if
	end if
	
	ll_row = this.find("plnt = '"+data+"'", row + 1, this.rowcount())
	if ll_row > 0 then
		messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
		this.setitem(row, 'plnt', '')
		return 1
	end if
		
end if
end event

event itemerror;return 1
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2629
integer height = 1996
long backcolor = 16777215
string text = "자재"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_3 dw_3
dw_7 dw_7
end type

on tabpage_3.create
this.rr_4=create rr_4
this.dw_3=create dw_3
this.dw_7=create dw_7
this.Control[]={this.rr_4,&
this.dw_3,&
this.dw_7}
end on

on tabpage_3.destroy
destroy(this.rr_4)
destroy(this.dw_3)
destroy(this.dw_7)
end on

type rr_4 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 14
integer y = 24
integer width = 2542
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within tabpage_3
event ue_enter pbm_dwnprocessenter
integer x = 82
integer y = 80
integer width = 2409
integer height = 800
integer taborder = 21
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_b3"
boolean border = false
boolean livescroll = true
end type

event ue_enter;If This.GetColumnName() <> 'kum_chg_txt'Then
	Send(Handle(This), 256, 9, 0)
	Return 1
End If

end event

event rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_gubun = '1'
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
		
	Case "kumno"
		gs_code = this.GetText()
		open(w_kummst_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.kumno[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')		
		

End Choose

end event

event itemchanged;String ls_col ,ls_cod
Long   ll_cnt ,ll_row

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc
		
	Case 'eo_no'
		This.SetItem(1, 'eo_tb_eo_no2', data)
		
End Choose
 
end event

event itemerror;RETURN 1
end event

type dw_7 from datawindow within tabpage_3
integer x = 55
integer y = 1084
integer width = 2450
integer height = 800
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_c3"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;setrow(row)

If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

event itemchanged;long	ll_row

if dwo.name = 'plnt' then
	
	if row > 1 then
		ll_row = this.find("plnt = '"+data+"'", 1, row - 1)
		if ll_row > 0 then
			messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
			this.setitem(row, 'plnt', '')
			return 1
		end if
	end if
	
	ll_row = this.find("plnt = '"+data+"'", row + 1, this.rowcount())
	if ll_row > 0 then
		messagebox('확인','납품처 공장은 중복 지정할 수 없습니다!')
		this.setitem(row, 'plnt', '')
		return 1
	end if
		
end if
end event

event itemerror;return 1
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2629
integer height = 1996
long backcolor = 16777215
string text = "품질"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_5 dw_5
end type

on tabpage_4.create
this.rr_5=create rr_5
this.dw_5=create dw_5
this.Control[]={this.rr_5,&
this.dw_5}
end on

on tabpage_4.destroy
destroy(this.rr_5)
destroy(this.dw_5)
end on

type rr_5 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 14
integer y = 24
integer width = 2542
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_5 from datawindow within tabpage_4
event ue_enter pbm_dwnprocessenter
integer x = 59
integer y = 48
integer width = 2459
integer height = 1856
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_res01_00010_b4"
boolean border = false
boolean livescroll = true
end type

event ue_enter;If This.GetColumnName() <> 'req_part'Then
	Send(Handle(This), 256, 9, 0)
	Return 1
End If

end event

event itemchanged;String ls_col ,ls_cod, s_date, snull
Long   ll_cnt ,ll_row

setnull(snull)

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc
		
	case 'eo_tb_chungu_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[청구일자]')
//			this.SetItem(1,"eo_tb_chungu_dt",snull)
			this.Setcolumn("eo_tb_chungu_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_ploto_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[견본생산일자]')
//			this.SetItem(1,"eo_tb_ploto_dt",snull)
			this.Setcolumn("eo_tb_ploto_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_isir_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[ISIR 승인일자]')
//			this.SetItem(1,"eo_tb_isir_dt",snull)
			this.Setcolumn("eo_tb_isir_dt")
			this.SetFocus()
			Return 1
		END IF		
	case 'eo_tb_chodo_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[초도품 생산일자]')
//			this.SetItem(1,"eo_tb_chodo_dt",snull)
			this.Setcolumn("eo_tb_chodo_dt")
			this.SetFocus()
			Return 1
		END IF	
	case 'eo_tb_chul_dt'
		s_date = Trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN RETURN
		
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[출하일자]')
//			this.SetItem(1,"eo_tb_chul_dt",snull)
			this.Setcolumn("eo_tb_chul_dt")
			this.SetFocus()
			Return 1
		END IF		
		
	Case 'eo_no'
		This.SetItem(1, 'eo_tb_eo_no2', data)
End Choose
 
end event

event itemerror;RETURN 1
end event

event rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_gubun = '1'
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')

End Choose

end event

type p_1 from uo_picture within w_res01_00010
integer x = 2441
integer y = 80
boolean bringtotop = true
string picturename = "..\image\복사_up.gif"
end type

event clicked;call super::clicked;string snull
setnull(snull)

// 복사...

if dw_insert.rowcount() <> 1  then return

if isnull(dw_insert.object.itnbr[1]) or trim(dw_insert.object.itnbr[1]) = '' then
	return
end if
if isnull(dw_insert.object.eo_no[1]) or trim(dw_insert.object.eo_no[1]) = '' then
	return
end if
if isnull(dw_insert.object.act_dt[1]) or trim(dw_insert.object.act_dt[1]) = '' then
	return
end if

IF MessageBox("확 인", "현재 EO 를 복사 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_insert.setitemstatus(1, 0, primary!, new!)
dw_insert.setitem(1,'itnbr',snull)
dw_insert.setitem(1,'itemas_itdsc',snull)

tab_1.tabpage_1.dw_1.Setcolumn('itnbr')
//tab_1.tabpage_1.dw_1.SetTaborder('itnbr',1)
tab_1.tabpage_1.dw_1.setfocus()

end event

type r_list from rectangle within w_res01_00010
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 32
integer y = 296
integer width = 1884
integer height = 2108
end type

