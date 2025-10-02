$PBExportHeader$w_pdm_01445.srw
$PBExportComments$** 표준공정 등록
forward
global type w_pdm_01445 from w_inherite
end type
end forward

global type w_pdm_01445 from w_inherite
string title = "환산표준 등록"
end type
global w_pdm_01445 w_pdm_01445

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);long ll_cnt
string ls_itnbr, ls_opseq, ls_wkctr
dwItemStatus l_status

ls_itnbr = dw_insert.GetItemString(i,'typecd')
ls_opseq = dw_insert.GetItemString(i,'opseq')
ls_wkctr = dw_insert.GetItemString(i,'wkctr')

if dw_input.AcceptText() = -1 then return  -1
if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'typecd')) or &
	dw_insert.GetItemString(i,'typecd') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('typecd')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'opseq')) or &
	dw_insert.GetItemString(i,'opseq') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'wkctr')) or &
	dw_insert.GetItemString(i,'wkctr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('wkctr')
	dw_insert.SetFocus()
	return -1		
end if	

l_status = dw_insert.GetItemStatus(i, 0, Primary!)

if l_status = NewModified! or l_status = New! then
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM ROUTNG_WKCTR
	 WHERE TYPECD = :ls_itnbr
	   AND OPSEQ = :ls_opseq
		AND WKCTR = :ls_wkctr;
		
	if ll_cnt > 0 then
		f_message_chk(10001,'[ '+string(i)+' 행]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('typecd')
		dw_insert.SetFocus()
		return -1
	end if
end if

return 1
end function

on w_pdm_01445.create
call super::create
end on

on w_pdm_01445.destroy
call super::destroy
end on

event open;call super::open;dw_input.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_input.InsertRow(0)

dw_input.SetFocus()
end event

event key;call super::key;// Page Up & Page Down & Home & End Key 사용 정의
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

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01445
integer y = 3624
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01445
integer y = 3440
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01445
integer y = 3440
end type

type st_1 from w_inherite`st_1 within w_pdm_01445
integer y = 3412
end type

type p_search from w_inherite`p_search within w_pdm_01445
integer y = 3444
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01445
integer y = 3444
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01445
integer y = 3444
end type

type p_mod from w_inherite`p_mod within w_pdm_01445
integer y = 3444
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 
if dw_input.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if
end event

type p_del from w_inherite`p_del within w_pdm_01445
integer y = 3444
end type

event p_del::clicked;call super::clicked;long irow

dw_insert.AcceptText()
dw_input.AcceptText()

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

if f_msg_delete() = -1 then return

irow = dw_insert.getrow()
   
dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(irow)

if dw_insert.Update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_inq from w_inherite`p_inq within w_pdm_01445
integer y = 3444
end type

event p_inq::clicked;call super::clicked;string ls_itnbr, ls_opseq, ls_wkctr

dw_input.AcceptText()

ls_itnbr = dw_input.GetItemString(1, "itnbr")
ls_opseq = dw_input.GetItemString(1, "opseq")
ls_wkctr = dw_input.GetItemString(1, "wkctr")

if ls_itnbr = "" or isNull(ls_itnbr) then ls_itnbr = '%'
if ls_opseq = "" or isNull(ls_opseq) then ls_opseq = '%'
if ls_wkctr = "" or isNull(ls_wkctr) then ls_wkctr = '%'

dw_insert.Retrieve(ls_itnbr, ls_wkctr, ls_opseq)
end event

type p_print from w_inherite`p_print within w_pdm_01445
integer y = 3444
end type

type p_can from w_inherite`p_can within w_pdm_01445
integer y = 3444
end type

event p_can::clicked;call super::clicked;dw_input.reset()
dw_insert.reset()

dw_input.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_pdm_01445
integer y = 3444
end type

type p_ins from w_inherite`p_ins within w_pdm_01445
integer y = 3444
end type

event p_ins::clicked;call super::clicked;dw_insert.InsertRow(0)
end event

type p_new from w_inherite`p_new within w_pdm_01445
integer y = 3444
end type

type dw_input from w_inherite`dw_input within w_pdm_01445
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01445_a"
end type

event itemchanged;w_mdi_frame.sle_msg.text = ''

string	sNull, sOpseq, s_ispec, s_itdsc, s_jijil, s_ispec_code, sroslt, sname, sitem, sname2, sItnbr
integer  ireturn 

SetNull(sNull)

IF this.GetColumnName() = "itnbr"	THEN
	
	sItnbr = this.GetText()
	
	IF sItnbr = ''	or		IsNull(sItnbr)	THEN	
		this.SetItem(1, "itdsc", snull)
		RETURN 
   END IF

	ireturn = f_get_name4('품번', 'Y', sItnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sItnbr)	
	this.setitem(1, "itdsc", s_itdsc)	
	
ELSEIF this.GetColumnName() ="opseq" THEN
	sOpseq = this.GetText()
	
	IF sOpseq = '' or IsNull(sOpseq) THEN
		this.SetItem(1, "opseq", snull)
	END IF
	
	IF Len(sOpseq) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(sOpseq) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	IF sOpseq < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	
ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	string	sCode
	sCode = this.GetText()
	
	IF sCode = '' or IsNull(sCode) THEN
		this.SetItem(1, "wkctr", snull)
		this.SetItem(1, "wcdsc", snull)
		RETURN
	END IF
	
	SELECT "WCDSC"
		INTO :sName
   	FROM "WRKCTR"  
	   WHERE ( "WKCTR" = :sCode )   ;
	IF sqlca.sqlcode <> 0		THEN
		messagebox("확인", "등록된 작업장이 아닙니다." )
		this.setitem(1, "wkctr", sNull)	
		RETURN 1
	END IF
	
	this.SetItem(1, "wcdsc", sName)

END IF


end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

String sItnbr, sOpseq
Long   nCnt
Dec	 dMchr

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(1, "itnbr", gs_code)

   this.Event ItemChanged(row, this.object.itnbr, gs_code)

ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(1, "wkctr", 	 gs_Code)
	this.SetItem(1, "wcdsc", 	 gs_CodeName)
	
END IF
end event

type cb_delrow from w_inherite`cb_delrow within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_addrow from w_inherite`cb_addrow within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type dw_insert from w_inherite`dw_insert within w_pdm_01445
integer x = 37
integer y = 284
integer height = 1964
string dataobject = "d_pdm_01445_1"
end type

event dw_insert::itemchanged;call super::itemchanged;string sNull
string sItnbr, sItdsc, sWcdsc

SetNull(sNull)

IF dwo.name = "typecd"	THEN
	
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "itdsc", snull)
		RETURN 
   END IF
	
	SELECT ITDSC
	  INTO :sItdsc
	  FROM ITEMAS
	 WHERE ITNBR = :data;
	 
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "typecd", snull)
		this.SetItem(row, "itdsc", snull)
		RETURN 1
	ELSE
		this.setitem(1, "typecd", data)	
		this.setitem(1, "itdsc", sItdsc)
   END IF
	
	
ELSEIF dwo.name ="opseq" THEN

	IF Len(data) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(data) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	IF data < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	
ELSEIF dwo.name = "wkctr"	THEN
	
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "wcdsc", snull)
		RETURN 
   END IF
		
	SELECT "WCDSC"
		INTO :sWcdsc
   	FROM "WRKCTR"  
	   WHERE ( "WKCTR" = :data )   ;
	IF sqlca.sqlcode <> 0		THEN
		messagebox("확인", "등록된 작업장이 아닙니다." )
		this.setitem(row, "wkctr", sNull)	
		this.setitem(row, "wcdsc", sNull)	
		RETURN 1
	END IF
	
	this.SetItem(row, "wcdsc", sWcdsc)

END IF
end event

event dw_insert::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

String sItnbr, sOpseq
Long   nCnt
Dec	 dMchr

IF this.GetColumnName() = "typecd"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(row, "typecd", gs_code)

   this.Event ItemChanged(row, this.object.typecd, gs_code)

ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(row, "wkctr", 	 gs_Code)
	this.SetItem(row, "wcdsc", 	 gs_CodeName)
	
END IF
end event

type cb_mod from w_inherite`cb_mod within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_del from w_inherite`cb_del within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_print from w_inherite`cb_print within w_pdm_01445
boolean visible = false
integer y = 3448
end type

type cb_can from w_inherite`cb_can within w_pdm_01445
boolean visible = false
integer y = 3460
end type

type cb_search from w_inherite`cb_search within w_pdm_01445
boolean visible = false
integer y = 3444
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01445
integer y = 3440
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01445
integer y = 3440
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01445
integer y = 3440
end type

type r_head from w_inherite`r_head within w_pdm_01445
integer y = 60
end type

type r_detail from w_inherite`r_detail within w_pdm_01445
end type

