$PBExportHeader$w_pdt_05010.srw
$PBExportComments$외주 재고조정
forward
global type w_pdt_05010 from w_inherite
end type
type pb_1 from u_pic_cal within w_pdt_05010
end type
type cbx_select from checkbox within w_pdt_05010
end type
type dw_imhist from datawindow within w_pdt_05010
end type
type rb_delete from radiobutton within w_pdt_05010
end type
type rb_insert from radiobutton within w_pdt_05010
end type
end forward

global type w_pdt_05010 from w_inherite
integer width = 4658
integer height = 2440
string title = "외주재고조정"
boolean maxbox = true
long backcolor = 32106727
pb_1 pb_1
cbx_select cbx_select
dw_imhist dw_imhist
rb_delete rb_delete
rb_insert rb_insert
end type
global w_pdt_05010 w_pdt_05010

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

//String     is_today              //시작일자
//String     is_totime             //시작시간
//String     is_window_id      //윈도우 ID
//String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_imhist_create ()
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
end prototypes

public function integer wf_imhist_create ();///////////////////////////////////////////////////////////////////////
//
//	* 등록모드  
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '003'
//
///////////////////////////////////////////////////////////////////////
string	sJpno, 				&
			sDate, sToday,		&
			sVendor, sEmpno,	&
			sSpec
long		lRow, lRowHist
dec		dSeq, dQty

dw_input.AcceptText()

sDate = dw_input.GetItemString(1, "edate")				// 조정일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	RETURN -1

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")
sToday = f_Today()
sVendor= dw_input.GetItemString(1, "vendor")
sEmpno = dw_input.GetItemString(1, "empno")


FOR	lRow = 1		TO		dw_insert.RowCount()

	dQty  = dw_insert.GetItemDecimal(lRow, "qty")
	sSpec = dw_insert.GetItemString(lRow, "pspec")
	IF IsNull(sSpec) or sSpec = ''	THEN	sSpec = '.'


	IF dQty <> 0		THEN
	
		/////////////////////////////////////////////////////////////////////////
		//
		// ** 입출고HISTORY 생성 **
		//
		////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
	
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'003')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   'O21') 			// 수불구분='외주재고조정'
	
		dw_imhist.SetItem(lRowHist, "sudat",	sToday)			// 수불일자=현재일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	sSpec) 			// 사양
		dw_imhist.SetItem(lRowHist, "opseq",	dw_insert.GetItemString(lRow, "opseq")) // 공정순서
		dw_imhist.SetItem(lRowHist, "depot_no",sVendor)			// 기준창고  =거래처
		dw_imhist.SetItem(lRowHist, "cvcod",	sVendor) 		// 거래처창고=거래처
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemDecimal(lRow, "qty")) 	// 수불수량=조정수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "qty")) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=조정일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "qty")) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=조정일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "bigo",    dw_insert.getitemstring(lrow, "bigo"))			// 사유
		
		dw_imhist.SetItem(lRowHist, "crt_user", gs_empno)      //등록자(Login)
//		dw_imhist.SetItem(lRowHist, "hold_no", dw_insert.GetItemString(lRow, "hold_no")) 	// 할당번호
//		dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
//		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
//		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
//		dw_imhist.SetItem(lRowHist, "outchk",  dw_insert.GetItemString(lRow, "hosts")) 			// 출고의뢰완료
//		
	END IF

NEXT

MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r생성되었습니다.")

RETURN 1
end function

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////
////
////		* 등록모드
////		1. 출고수량 = 0		-> SKIP
////		2. 출고수량 > 0 인 것만 전표처리
////		3. 기출고수량 + 출고수량 = 요청수량 -> 촐고완료('Y')
////	
////////////////////////////////////////////////////////////////////
//dec		dOutQty, dIsQty, dQty, dTemp_OutQty
//long		lRow,	lCount
//
//
//FOR	lRow = 1		TO		dw_insert.RowCount()
//
//	dQty  = dw_insert.GetItemDecimal(lRow, "qty")			// 출고요청수량
//	dIsQty  = dw_insert.GetItemDecimal(lRow, "isqty")		// 기출고수량	
//	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")	// 출고수량
//
//	IF ic_status = '1'	THEN
//		IF dOutQty > 0		THEN
//		
//			IF dIsQty + dOutQty = dQty		THEN		dw_insert.SetItem(lRow, "hosts", 'Y')
//			dw_insert.SetItem(lRow, "isqty", dw_insert.GetItemDecimal(lRow, "isqty") + dOutQty)
//			dw_insert.SetItem(lRow, "unqty", dw_insert.GetItemDecimal(lRow, "unqty") - dOutQty)
//			lCount++
//
//		END IF
//	END IF
////
//	
//	/////////////////////////////////////////////////////////////////////////
//	//	1. 수정시 
//	/////////////////////////////////////////////////////////////////////////
//	IF iC_status = '2'	THEN
//
//		dTemp_OutQty = dw_insert.GetItemDecimal(lRow, "temp_outqty")
//		dOutQty = dOutQty - dTemp_OutQty
//
//		IF dIsQty + dOutQty = dQty		THEN		dw_insert.SetItem(lRow, "hosts", 'Y')
//		dw_insert.SetItem(lRow, "isqty", dw_insert.GetItemDecimal(lRow, "isqty") + dOutQty)
//		dw_insert.SetItem(lRow, "unqty", dw_insert.GetItemDecimal(lRow, "unqty") - dOutQty)
//		lCount++
//
//	END IF
//
//NEXT
//
//
//
//IF lCount < 1		THEN	RETURN -1





/********************************************************************************************/
/* 범한수정 비고란 필수입력체크 - 2001.11.05 - 송병호 */
dec		dQty
long		lRow
string	sBigo


FOR	lRow = 1		TO		dw_insert.RowCount()

	IF ic_status = '1'	THEN
		dQty = dw_insert.GetItemDecimal(lRow, "qty")		// 출고요청수량
		if dQty = 0 then Continue

		sBigo = dw_insert.GetItemString(lRow, "bigo")	// 비고
		if IsNull(sBigo) or sBigo = '' then
			MessageBox("확인","비고란은 필수입력 항목입니다.")
			dw_insert.SetRow(lRow)
			dw_insert.SetColumn('bigo')
			dw_insert.SetFocus()
			return -1
		end if
	ELSE
		dQty = dw_insert.GetItemDecimal(lRow, "imhist_ioqty")		// 출고요청수량
		if dQty = 0 then Continue
		
		sBigo = dw_insert.GetItemString(lRow, "imhist_bigo")	// 비고
		if IsNull(sBigo) or sBigo = '' then
			MessageBox("확인","비고란은 필수입력 항목입니다.")
			dw_insert.SetRow(lRow)
			dw_insert.SetColumn('imhist_bigo')
			dw_insert.SetFocus()
			return -1
		end if
	END IF
NEXT


RETURN 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 입출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////

long		lRow, lRowCount

lRowCount = dw_insert.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
   IF dw_insert.getitemstring(lrow, 'opt') = 'Y' then 
		dw_insert.DeleteRow(lRow)
	END IF
NEXT


RETURN 1
end function

public function integer wf_imhist_update ();
IF dw_insert.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
	RETURN -1
END IF

RETURN 1
end function

public function integer wf_initial ();
dw_input.setredraw(false)
dw_input.reset()
dw_insert.reset()
dw_imhist.reset()

//cb_save.enabled = false
//p_del.enabled = false

//dw_input.enabled = TRUE

dw_input.insertrow(0)

IF ic_status = '1'	then

	// 등록시

	dw_input.settaborder("vendor", 10)
	dw_input.settaborder("empno",  20)
	dw_input.settaborder("edate",  0)

	dw_input.setcolumn("vendor")
	dw_input.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "등록"
	
	dw_input.Modify("t_req_vendor.visible = 1")
	dw_input.Modify("t_req_empno.visible = 1")
	dw_input.Modify("t_req_date.visible = 0")
ELSE

	dw_input.settaborder("vendor", 10)
	dw_input.settaborder("empno",  0)
	dw_input.settaborder("edate",  30)

	dw_input.setcolumn("vendor")
	dw_input.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "삭제"
	
	dw_input.Modify("t_req_vendor.visible = 0")
	dw_input.Modify("t_req_empno.visible = 0")
	dw_input.Modify("t_req_date.visible = 1")
END IF

pb_1.Visible = True

dw_input.setfocus()

dw_insert.SetFilter("itemas_useyn='0' ")
dw_insert.Filter()

dw_input.setredraw(true)

return  1

end function

event open;Integer  li_idx

// 마이그레이션 오류로 인해 주석처리함. 25.09.22. jwlee
//li_idx = w_mdi_frame.dw_insertbar.InsertRow(0)
//w_mdi_frame.dw_insertbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
//w_mdi_frame.dw_insertbar.SetItem(li_idx,'window_name',Upper(This.Title))
//w_mdi_frame.Postevent("ue_barrefresh")

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

dw_input.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()


// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_05010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.cbx_select=create cbx_select
this.dw_imhist=create dw_imhist
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.cbx_select
this.Control[iCurrent+3]=this.dw_imhist
this.Control[iCurrent+4]=this.rb_delete
this.Control[iCurrent+5]=this.rb_insert
end on

on w_pdt_05010.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.cbx_select)
destroy(this.dw_imhist)
destroy(this.rb_delete)
destroy(this.rb_insert)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

//li_index = w_mdi_frame.dw_insertbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_insertbar.RowCount())

//w_mdi_frame.dw_insertbar.DeleteRow(li_index)
//w_mdi_frame.Postevent("ue_barrefresh")
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
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
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
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", false)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
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

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)

end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)

end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)

end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_05010
end type

type sle_msg from w_inherite`sle_msg within w_pdt_05010
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_05010
end type

type st_1 from w_inherite`st_1 within w_pdt_05010
end type

type p_search from w_inherite`p_search within w_pdt_05010
end type

type p_addrow from w_inherite`p_addrow within w_pdt_05010
end type

type p_delrow from w_inherite`p_delrow within w_pdt_05010
end type

type p_mod from w_inherite`p_mod within w_pdt_05010
integer x = 3881
integer y = 24
integer width = 178
integer taborder = 40
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_input.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN

string	sDate
sdate  = dw_input.GetItemstring(1, "Edate")			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1	THEN	RETURN 
	

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	wf_imhist_create()

	IF dw_insert.Update() <= 0		THEN
		f_Rollback()
		ROLLBACK;
	END IF

	IF dw_imhist.Update() > 0		THEN
		COMMIT;
	ELSE
		f_Rollback()
		ROLLBACK;
	END IF

/////////////////////////////////////////////////////////////////////////
//	1. 수정 : 입출고HISTORY(조정수량)
/////////////////////////////////////////////////////////////////////////
ELSE

	wf_imhist_update()
	
END IF



//p_retrieve.TriggerEvent("clicked")	
p_inq.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_del from w_inherite`p_del within w_pdt_05010
integer x = 4055
integer y = 24
integer width = 178
integer taborder = 50
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN


IF dw_insert.Update() >= 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF


//cb_cancel.TriggerEvent("clicked")
	
	

end event

type p_inq from w_inherite`p_inq within w_pdt_05010
integer x = 3707
integer y = 24
integer width = 178
integer taborder = 20
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;	
if dw_input.Accepttext() = -1	then 	return

string  	sVendor,		&
			sEmpno,		&
			sDate,		&
			sNull, ls_ittyp
SetNull(sNull)

sVendor	= dw_input.getitemstring(1, "vendor")
sEmpno  	= dw_input.getitemstring(1, "empno")
sDate    = trim(dw_input.getitemstring(1, "edate"))
ls_ittyp    = trim(dw_input.getitemstring(1, "ittyp"))	// 품목구분 추가 by shjeon 20120920

if (IsNull(ls_ittyp) or ls_ittyp = "")  then ls_ittyp = "%"

////////////////////////////////////////////////////////////////////////////

IF ic_status = '1'		THEN

	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30,'[거래처]')
		dw_input.SetColumn("vendor")
		dw_input.SetFocus()
		RETURN
	END IF

	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[담당자]')
		dw_input.SetColumn("empno")
		dw_input.SetFocus()
		RETURN
	END IF

	IF	dw_insert.Retrieve(sVendor, ls_ittyp) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_input.setcolumn("vendor")
		dw_input.setfocus()
		return
	END IF

	dw_insert.SetColumn("qty")
	
ELSE

	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[조정일자]')
		dw_input.SetColumn("edate")
		dw_input.SetFocus()
		RETURN
	END IF

	IF	dw_insert.Retrieve(gs_sabu, sVendor, sDate, ls_ittyp) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_input.setcolumn("vendor")
		dw_input.setfocus()
		return
	END IF

	// 삭제모드에서만 삭제가능
	p_del.enabled = true	
	dw_insert.SetColumn("imhist_ioqty")
	
END IF

//////////////////////////////////////////////////////////////////////////

//dw_input.enabled = false

dw_input.settaborder("vendor", 0)
dw_input.settaborder("empno",  0)
dw_input.settaborder("edate",  0)

pb_1.Visible = False

dw_insert.SetFocus()
//cb_save.enabled = true

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If

end event

type p_print from w_inherite`p_print within w_pdt_05010
integer x = 3849
integer y = 144
end type

type p_can from w_inherite`p_can within w_pdt_05010
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_exit from w_inherite`p_exit within w_pdt_05010
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_ins from w_inherite`p_ins within w_pdt_05010
integer x = 4553
integer y = 144
end type

type p_new from w_inherite`p_new within w_pdt_05010
integer x = 3497
integer y = 144
end type

type dw_input from w_inherite`dw_input within w_pdt_05010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 56
integer width = 3488
integer height = 188
integer taborder = 10
string dataobject = "d_pdt_05011"
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;
string	sCode, sName,	sname2,	&
			sNull, s_date
int      ireturn 
SetNull(sNull)

// 거래처
IF this.GetColumnName() = "vendor" THEN
	

	scode = this.GetText()								
	
   ireturn = f_get_name2('V1', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'vendor', scode)
	this.setitem(1, 'vendorname', sName)
   return ireturn 

ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
   ireturn = f_get_name2('사번', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname)
   return ireturn 
	
ELSEIF this.GetColumnName() = "edate" THEN

	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[조정일자]')
		this.SetItem(1,"edate",snull)
		this.Setcolumn("edate")
		this.SetFocus()
		Return 1
	END IF
	
ELSEIF this.GetColumnName() = "useyn" THEN

	scode = Trim(this.Gettext())
	if scode = 'Y' 	then
		dw_insert.SetFilter("itemas_useyn='0' ")
		dw_insert.Filter()
	else
		dw_insert.SetFilter("")
		dw_insert.Filter()
	end if
	
END IF
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 거래처
IF this.GetColumnName() = 'vendor'	THEN
   Gs_gubun = '1' 
	
	Open(w_vndmst_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"vendor",gs_code)
	SetItem(1,"vendorname",gs_codename)

	this.TriggerEvent("itemchanged")
	
END IF


// 의뢰담당자
IF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",  gs_code)
	SetItem(1,"empname",gs_codename)

END IF


end event

type cb_delrow from w_inherite`cb_delrow within w_pdt_05010
boolean visible = false
end type

type cb_addrow from w_inherite`cb_addrow within w_pdt_05010
boolean visible = false
end type

type dw_insert from w_inherite`dw_insert within w_pdt_05010
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
integer taborder = 20
string dataobject = "d_pdt_05010"
end type

event itemchanged;call super::itemchanged;String ls_colNm
Double ld_realqty, ld_jego_qty, ld_qty

ls_colNm = GetColumnName() 
	
If ls_colNm = "real_stock" or ( ls_colNm = "opt" and data ='Y' ) Then
	ld_realqty = Double(this.GetText())
//	IF ld_realqty = 0 OR IsNull(ld_realqty) THEN Return

	ld_jego_qty = this.GetItemNumber(row,"jego_qty")
	ld_qty = ld_jego_qty - ld_realqty

	If	rb_insert.Checked Then
		SetItem(row,"qty", ld_qty)
	ElseIf rb_delete.Checked and ls_colNm = "real_stock" Then
		SetItem(row,"imhist_ioqty", ld_qty)
	End If
Elseif ls_colNm = "opt" and data ='N' Then
	If	rb_insert.Checked Then
		SetItem(row,"qty", 0 )
		SetItem(row,"real_stock", 0 )
	End If
End If

end event

type cb_mod from w_inherite`cb_mod within w_pdt_05010
boolean visible = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_05010
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_pdt_05010
boolean visible = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_05010
boolean visible = false
end type

type cb_print from w_inherite`cb_print within w_pdt_05010
boolean visible = false
boolean enabled = false
end type

type cb_can from w_inherite`cb_can within w_pdt_05010
boolean visible = false
end type

type cb_search from w_inherite`cb_search within w_pdt_05010
boolean visible = false
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pdt_05010
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_05010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_05010
end type

type r_head from w_inherite`r_head within w_pdt_05010
end type

type r_detail from w_inherite`r_detail within w_pdt_05010
end type

type pb_1 from u_pic_cal within w_pdt_05010
integer x = 3461
integer y = 72
integer taborder = 20
end type

event clicked;call super::clicked;dw_input.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_input.SetItem(1, 'edate', gs_code)
end event

type cbx_select from checkbox within w_pdt_05010
integer x = 1861
integer y = 180
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "전체 선택"
end type

event clicked;Double ld_realqty, ld_jego_qty, ld_qty
long i

IF cbx_select.Checked = True THEN
	For i = 1 to dw_insert.RowCount()
		dw_insert.SetItem(i, "opt", 'Y')

//		ld_realqty = Double(dw_insert.GetItemNumber(i,'real_stock'))

		ld_jego_qty = dw_insert.GetItemNumber(i,"jego_qty")
		ld_qty = ld_jego_qty - ld_realqty

		If	rb_insert.Checked Then
			//dw_insert.SetItem(i,"qty", ld_qty)
			dw_insert.SetItem(i,"real_stock", ld_jego_qty)
			dw_insert.SetItem(i,"qty", 0)
		End If
	Next
Else 
	For i = 1 to dw_insert.RowCount()
		dw_insert.SetItem(i, "opt", 'N')
		If	rb_insert.Checked Then
			dw_insert.SetItem(i,"qty", 0 )
			dw_insert.SetItem(i,"real_stock", 0 )
		End If

	Next
End If
end event

type dw_imhist from datawindow within w_pdt_05010
boolean visible = false
integer x = 96
integer y = 2316
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type rb_delete from radiobutton within w_pdt_05010
integer x = 201
integer y = 160
integer width = 224
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "수정"
end type

event clicked;
ic_status = '2'

dw_insert.DataObject = 'd_pdt_05012'
dw_insert.SetTransObject(sqlca)

wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If
end event

type rb_insert from radiobutton within w_pdt_05010
integer x = 201
integer y = 80
integer width = 224
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "등록"
boolean checked = true
end type

event clicked;
ic_status = '1'	// 등록

dw_insert.DataObject = 'd_pdt_05010'
dw_insert.SetTransObject(sqlca)

wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If

end event

type p_cancel from w_inherite`p_exit within w_pdt_05010
boolean visible = false
integer x = 4229
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If

end event

