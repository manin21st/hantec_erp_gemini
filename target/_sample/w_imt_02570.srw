$PBExportHeader$w_imt_02570.srw
$PBExportComments$** 발주서
forward
global type w_imt_02570 from w_standard_print
end type
end forward

global type w_imt_02570 from w_standard_print
string title = "발주서"
boolean maxbox = true
end type
global w_imt_02570 w_imt_02570

type variables
string    is_printgu  = 'N'   //발주서 출력여부
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//string sdate, edate, emp1, emp2, cvcod1, cvcod2, gubun, gubun2, sbaljpno, sortgu
//Long   ll_i
//
//if dw_ip.AcceptText() = -1 then 
//	dw_ip.SetFocus()
//	return -1
//end if
//sdate    = trim(dw_ip.object.sdate[1])
//edate    = trim(dw_ip.object.edate[1])
//emp1     = trim(dw_ip.object.emp1[1])
//emp2     = trim(dw_ip.object.emp2[1])
//cvcod1   = trim(dw_ip.object.cvcod1[1])
//cvcod2   = trim(dw_ip.object.cvcod2[1])
//gubun    = trim(dw_ip.object.gubun[1]) 
//gubun2   = trim(dw_ip.object.gubun2[1]) 
//sbaljpno = trim(dw_ip.object.baljpno[1]) 
//sortgu   = trim(dw_ip.object.sortgu[1]) 
//
//if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
//if (IsNull(edate) or edate = "")  then edate = "99991231"
//if (IsNull(emp1) or emp1 = "")  then emp1 = "."
//if (IsNull(emp2) or emp2 = "")  then emp2 = "ZZZZZZ"
//if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
//if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
//if (IsNull(sbaljpno) or sbaljpno = "")  then sbaljpno = "%"
//
//IF dw_print.Retrieve(gs_sabu, sdate, edate, emp1, emp2, cvcod1, cvcod2, gubun, sbaljpno, sortgu, gs_saupj) <= 0 then
//	f_message_chk(50,'[발 주 서]')
//	dw_ip.Setfocus()
//	dw_list.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
//dw_print.ShareData(dw_list)
//
//if dw_print.rowcount() > 0 then 
//	For ll_i = 1 to dw_print.rowcount()
//		dw_print.object.reffpf_rfna1[ll_i] = gs_username
//	Next 
//End if 
//
//if dw_list.rowcount() > 0 then 
//	For ll_i = 1 to dw_list.rowcount()
//		dw_list.object.reffpf_rfna1[ll_i] = gs_username 
//	Next 
//End if 
//
///* 입고장소, 담당자, 전화번호, FAX */
//String a1, a2,a3, a4
//
//a1 = trim(dw_ip.GetItemString(1, 'a1'))
//a2 = trim(dw_ip.GetItemString(1, 'a2'))
////a3 = trim(dw_ip.GetItemString(1, 'a3')) 전화번호 사용안함
//a4 = trim(dw_ip.GetItemString(1, 'a4'))
//
//dw_list.Object.a1_t.text = a1
//dw_print.Object.a1_t.text = a1
////dw_list.Object.a2_t.text = a2
//
//For ll_i = 1 To dw_list.RowCount()
////	If Not IsNull(a3) Then dw_list.SetItem(ll_i, 'jasa_tel', a3)
//	If Not IsNull(a2) Then dw_list.SetItem(ll_i, 'vndmst_cvpln', a2)
//	If Not IsNull(a4) Then dw_list.SetItem(ll_i, 'jasa_fax', a4)
//Next
//
//return 1

dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_baljpno

ls_baljpno = dw_ip.GetItemString(row, 'baljpno')
If Trim(ls_baljpno) = '' OR IsNull(ls_baljpno) Then
	MessageBox('발주번호 확인', '발주번호는 필수 항목입니다.')
	Return -1
End If

String ls_baldate

ls_baldate = dw_ip.GetItemString(row, 'sdate')
If Trim(ls_baldate) = '' OR IsNull(ls_baldate) Then
	MessageBox('발주일자 확인', '발주일자는 필수 항목입니다.')
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_baljpno, ls_baldate)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_imt_02570.create
call super::create
end on

on w_imt_02570.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', is_today)
dw_ip.setitem(1, 'edate', is_today)

end event

event ue_print;long k, lCount

//출력시 y로 변경
if is_printgu  = 'Y' then 

	lCount = dw_list.rowcount()
		
	IF lCount <= 0 then 
		f_message_chk(110,'')   
		return 
	end if
		
	FOR k = 1 TO lCount
		dw_list.setitem(k, 'pomast_printgu', 'Y')
	NEXT
	
	if dw_list.update() = 1 then
		commit ;
	else
		rollback ;
	end if	

   is_printgu  = 'N'
end if

IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_list)
end event

event activate;/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
gw_window = this

//// 버튼 활성화 처리
if gs_lang = "CH" then
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", false) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", false) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// 엑셀다운

	//w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", false) //// 출력
	//w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기

	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", true) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기
	
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("조회(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("추가(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("삭제(&D)", false) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("저장(&S)", false) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("신규(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("찾기(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("필터(&F)", true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("엑셀변환(&E)", true) //// 엑셀다운
	
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("출력(&P)", true)  //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("미리보기(&R)", false)  //// 미리보기
	
	//w_mdi_frame.uo_toolbarstrip.of_SetEnabled("출력(&P)", false)
	//w_mdi_frame.uo_toolbarstrip.of_SetEnabled("미리보기(&R)", false) 

	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("도움말(&G)", true) 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("PDF(&P)", true) 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("설정(&C)", true) 
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true   //// 조회
m_main2.m_window.m_add.enabled = false ////추가
m_main2.m_window.m_del.enabled = false	  //// 삭제
m_main2.m_window.m_save.enabled = false //// 저장
m_main2.m_window.m_new.enabled = false  //// 신규
m_main2.m_window.m_find.enabled = true   //// 필터
m_main2.m_window.m_filter.enabled = true  //// 필터
m_main2.m_window.m_excel.enabled = true //// 엑셀다운

m_main2.m_window.m_print.enabled = true  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

//m_main2.m_window.m_print.enabled = false //// 출력
//m_main2.m_window.m_preview.enabled = false //// 미리보기 

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type dw_list from w_standard_print`dw_list within w_imt_02570
integer width = 3489
integer height = 1964
string dataobject = "d_imt_02570_02_han"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_list::printend;is_printgu  = 'Y'

end event

type cb_print from w_standard_print`cb_print within w_imt_02570
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02570
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02570
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02570
end type

type dw_print from w_standard_print`dw_print within w_imt_02570
integer x = 3287
integer width = 174
integer height = 144
string dataobject = "d_imt_02570_02_han"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02570
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_02570_01_han"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2, snull
integer i_rtn

s_cod = Trim(this.gettext())

setnull(snull)

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)	
	this.SetItem(1,"cvnam1",s_nam1)	
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)	
	this.SetItem(1,"cvnam2",s_nam1)	
	return i_rtn
elseIF this.GetColumnName() ="baljpno" THEN
	if IsNull(s_cod) or s_cod = "" then return 

  SELECT "POMAST"."BALDATE", 
  			"POMAST"."BALGU" 
    INTO :s_nam1, :s_nam2
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :s_cod )   ;

	IF SQLCA.SQLCODE <> 0 then 
		setitem(1, "baljpno", snull)
      RETURN 1
//	Elseif s_nam2 = '3' then
//		Messagebox("발주내역", "외주발주 내역은 출력할 수 없읍니다", stopsign!)
//		setitem(1, "baljpno", snull)
//		return 1
	END IF
	this.object.sdate[1] = s_nam1
	this.object.edate[1] = s_nam1
END IF	

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
elseIF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	this.setitem(1, "baljpno", left(gs_code, 12))
	this.triggerevent(itemchanged!)
END IF
end event

event dw_ip::itemerror;return 1
end event

type r_1 from w_standard_print`r_1 within w_imt_02570
end type

type r_2 from w_standard_print`r_2 within w_imt_02570
end type

