$PBExportHeader$w_qct_01060.srw
$PBExportComments$외주검사 등록
forward
global type w_qct_01060 from window
end type
type pb_2 from u_pb_cal within w_qct_01060
end type
type pb_1 from u_pb_cal within w_qct_01060
end type
type cb_delete from commandbutton within w_qct_01060
end type
type cb_cancel from commandbutton within w_qct_01060
end type
type rb_delete from radiobutton within w_qct_01060
end type
type rb_insert from radiobutton within w_qct_01060
end type
type dw_detail from datawindow within w_qct_01060
end type
type dw_datetime from datawindow within w_qct_01060
end type
type cb_save from commandbutton within w_qct_01060
end type
type st_message_text from statictext within w_qct_01060
end type
type cb_exit from commandbutton within w_qct_01060
end type
type cb_retrieve from commandbutton within w_qct_01060
end type
type sle_message_line from statictext within w_qct_01060
end type
type gb_6 from groupbox within w_qct_01060
end type
type gb_4 from groupbox within w_qct_01060
end type
type gb_2 from groupbox within w_qct_01060
end type
type gb_3 from groupbox within w_qct_01060
end type
type gb_1 from groupbox within w_qct_01060
end type
type dw_list from datawindow within w_qct_01060
end type
end forward

global type w_qct_01060 from window
integer width = 3657
integer height = 2416
boolean titlebar = true
string title = "외주검사 등록"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 12632256
pb_2 pb_2
pb_1 pb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_datetime dw_datetime
cb_save cb_save
st_message_text st_message_text
cb_exit cb_exit
cb_retrieve cb_retrieve
sle_message_line sle_message_line
gb_6 gb_6
gb_4 gb_4
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
dw_list dw_list
end type
global w_qct_01060 w_qct_01060

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_initial ()
public function integer wf_imhist_delete ()
public subroutine wf_modify_gubun ()
public subroutine wf_update ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_initial ();
dw_detail.setredraw(false)

dw_list.reset()

cb_save.enabled = false
cb_delete.enabled = false
dw_detail.enabled = TRUE

//dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

	dw_detail.settaborder("SDATE", 10)
	dw_detail.settaborder("jpno",  20)
	dw_detail.settaborder("EDATE", 30)
	dw_detail.settaborder("CUST", 40)
	
	dw_detail.setcolumn("EDATE")
	dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.SetItem(1, "edate", is_Date)


dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////
string	sJpno
long		lRow, lRowCount
lRowCount = dw_list.RowCount()


////////////////////////////////////////////////////////////////////////
FOR  lRow = lRowCount 	TO		1		STEP	-1

	dw_list.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public subroutine wf_modify_gubun ();
//////////////////////////////////////////////////////////////////////
// 1. 검사결과내역
//	2. 수불승인된 내역은 수정불가
//	3. 수불승인자 = NULL 인내역은 수정가능
//////////////////////////////////////////////////////////////////////

string	sConfirm, sEmpno
long		lRow 

FOR lRow = 1	TO		dw_list.RowCount()
	
	sConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
	sEmpno   = dw_list.GetItemString(lRow, "imhist_io_empno")
	
	IF ( sConfirm = 'Y' ) and	Not IsNull(sEmpno)	THEN
		dw_list.SetItem(lRow, "gubun", 'N')							// 수정불가
	ELSE
		dw_list.SetItem(lRow, "gubun", 'Y')
	END IF
	
NEXT
end subroutine

public subroutine wf_update ();string	sStockGubun,	&
			sVendorGubun,	&
			sVendor,			&
			sJpno,			&
			sGubun,			&
			sNull
long		lRow
dec		dBadQty, dBadQty_Temp,		&
			dSpQty, dQty
SetNull(sNull)


FOR lRow = 1	TO		dw_list.RowCount()
	
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		dBadQty_Temp = dw_list.GetItemDecimal(lRow, "iofaqty_temp")			// 불량수량
		dSpQty = dw_list.GetItemDecimal(lRow, "imhist_iospqty")				// 특채수량


		IF (dBadQty <> dBadQty_Temp)		THEN	
			gs_Code = dw_list.GetItemString(lRow, "imhist_iojpno")
			gi_Page = dBadQty
			Open(w_qct_01050)

			dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty + dSpQty)	// 합격수량
				
		END IF
				

NEXT


end subroutine

public function integer wf_checkrequiredfield ();
////////////////////////////////////////////////////////////////////////////
string	sInDate,		&
			sQcDate, 	&
			sGubun,		&
			sStockGubun,		&
			sConfirm,	&
			sVendor,		&
			sNull
long		lRow, lRowOut
dec		dBadQty, dQty, dSpQty
SetNull(sNull)


sInDate = dw_detail.GetItemString(1, "sdate")
sQcDate = dw_detail.GetItemString(1, "edate")


FOR lRow = 1	TO		dw_list.RowCount()
	
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		dSpQty  = dw_list.GetItemDecimal(lRow, "imhist_iospqty")				// 특채수량
		
		IF dBadQty > 0		THEN	
			dw_list.SetItem(lRow, "gubun", 'Y')
			gs_Code = dw_list.GetItemString(lRow, "imhist_iojpno")
			gi_Page = dBadQty
			Open(w_qct_01050)
		END IF
				
		sGubun = dw_list.GetItemString(lRow, "gubun")
		IF sGubun = 'N'	THEN CONTINUE
		
		// 검사완료시
		IF sGubun = 'Y'	THEN
			dw_list.SetItem(lRow, "imhist_insdat",  sQcDate)						// 검사일자
			dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty + dSpQty)	// 합격수량
			dw_list.SetItem(lRow, "imhist_filsk",   'Y')
		END IF


NEXT

RETURN 1


end function

event open;is_window_id = Message.StringParm	
is_today = f_today()
is_totime = f_totime()

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


// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

is_Date = f_Today()

dw_detail.InsertRow(0)
dw_datetime.insertrow(0)

// commandbutton function
cb_cancel.TriggerEvent("clicked")


end event

on w_qct_01060.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_datetime=create dw_datetime
this.cb_save=create cb_save
this.st_message_text=create st_message_text
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.sle_message_line=create sle_message_line
this.gb_6=create gb_6
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.dw_list=create dw_list
this.Control[]={this.pb_2,&
this.pb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_datetime,&
this.cb_save,&
this.st_message_text,&
this.cb_exit,&
this.cb_retrieve,&
this.sle_message_line,&
this.gb_6,&
this.gb_4,&
this.gb_2,&
this.gb_3,&
this.gb_1,&
this.dw_list}
end on

on w_qct_01060.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_datetime)
destroy(this.cb_save)
destroy(this.st_message_text)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.sle_message_line)
destroy(this.gb_6)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.dw_list)
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


end event

type pb_2 from u_pb_cal within w_qct_01060
integer x = 997
integer y = 216
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_01060
integer x = 997
integer y = 104
integer taborder = 10
end type

event clicked;call super::clicked;dw_detail.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'sdate', gs_code)
end event

type cb_delete from commandbutton within w_qct_01060
boolean visible = false
integer x = 919
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&D)"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN


IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF


cb_cancel.TriggerEvent("clicked")
	
	

end event

type cb_cancel from commandbutton within w_qct_01060
integer x = 2715
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

type rb_delete from radiobutton within w_qct_01060
integer x = 3049
integer y = 220
integer width = 338
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "검사결과"
end type

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_qct_01062'
dw_list.SetTransObject(sqlca)

wf_initial()
end event

type rb_insert from radiobutton within w_qct_01060
integer x = 3049
integer y = 116
integer width = 398
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "검사의뢰"
boolean checked = true
end type

event clicked;
ic_status = '1'

dw_list.DataObject = 'd_qct_01061'
dw_list.SetTransObject(sqlca)

wf_initial()
end event

type dw_detail from datawindow within w_qct_01060
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 192
integer y = 80
integer width = 2505
integer height = 248
integer taborder = 10
string dataobject = "d_qct_01060"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate,	&
			sNull
SetNull(sNull)


/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
	IF is_Date > sDate	THEN
		MessageBox("확인", "입고일자는 현재일자보다 클 수 없습니다.")
		this.setitem(1, "sdate", is_Date)
		return 1
	END IF
	
END IF

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'edate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
	IF is_Date > sDate	THEN
		MessageBox("확인", "검사일자는 현재일자보다 클 수 없습니다.")
		this.setitem(1, "edate", is_Date)
		return 1
	END IF
	
END IF

string	sCust, sCustName
// 거래처
IF this.GetColumnName() = 'cust'		THEN

	sCust = this.gettext()
	SELECT CVNAS2
	  INTO :sCustName
	  FROM VNDMST
	 WHERE CVCOD = :sCust AND 
	 		 CVGU  = '1'	 AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "cust", sNull)
		return 1
	end if

	this.setitem(1, "custname", sCustName)
	 
END IF
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''



IF this.GetColumnName() = 'cust'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cust",	  gs_code)
	SetItem(1, "custname", gs_codename)

	this.TriggerEvent("itemchanged")
	
END IF


end event

type dw_datetime from datawindow within w_qct_01060
integer x = 2875
integer y = 2120
integer width = 768
integer height = 108
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type cb_save from commandbutton within w_qct_01060
integer x = 558
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;string	sNull
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1		THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

IF ic_status = '1'	THEN

	IF wf_CheckRequiredField() = -1	THEN	RETURN

ELSE

	wf_Update()

END IF


/////////////////////////////////////////////////////////////////////////////

IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF



cb_cancel.TriggerEvent("clicked")

SetPointer(Arrow!)


end event

type st_message_text from statictext within w_qct_01060
integer x = 32
integer y = 2120
integer width = 347
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_qct_01060
event key_in pbm_keydown
integer x = 3081
integer y = 1976
integer width = 370
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_qct_01060
integer x = 197
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;
IF dw_detail.AcceptText() = -1	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
string	sInDate, 	&
			sQcDate,		&
			sJpno,		&
			sCust

sInDate = dw_detail.GetItemString(1, "sdate")
sQcDate = dw_detail.GetItemString(1, "edate")
sJpno   = dw_detail.GetItemString(1, "jpno")
sCust  = dw_detail.GetItemString(1, "Cust")



IF ic_status = '1'	THEN
	IF isnull(sInDate) or sInDate = "" 	THEN
		f_message_chk(30,'[입고일자]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF

	// 거래처코드
	IF isnull(sCust) or sCust = "" 	THEN
		sCust = '%'
	END IF

END IF

IF isnull(sQcDate) or sQcDate = "" 	THEN
	f_message_chk(30,'[검사일자]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF


// 전표번호
IF isnull(sJpno) or sJpno = "" 	THEN
	sJpno = '%'
ELSE
	sJpno = sJpno + '%'
END IF




//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN	
	IF	dw_list.Retrieve(gs_sabu, sJpno, sInDate, sCust) <	1		THEN
		f_message_chk(50, '[검사의뢰내역]')
		dw_detail.setcolumn("edate")
		dw_detail.setfocus()
		RETURN
	END IF
ELSE
	IF	dw_list.Retrieve(gs_sabu, sQcDate) <	1		THEN
		f_message_chk(50, '[검사결과내역]')
		dw_detail.setcolumn("edate")
		dw_detail.setfocus()
		RETURN
	END IF

//	wf_Modify_Gubun()
//	cb_delete.enabled = true
	
END IF
//////////////////////////////////////////////////////////////////////////

dw_list.SetFocus()
dw_detail.enabled = false


cb_save.enabled = true


end event

type sle_message_line from statictext within w_qct_01060
integer x = 384
integer y = 2120
integer width = 2491
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_6 from groupbox within w_qct_01060
integer x = 1449
integer y = 1908
integer width = 1097
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type gb_4 from groupbox within w_qct_01060
integer x = 37
integer width = 2816
integer height = 364
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type

type gb_2 from groupbox within w_qct_01060
integer x = 2862
integer width = 722
integer height = 364
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_qct_01060
integer x = 2555
integer y = 1908
integer width = 1038
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type gb_1 from groupbox within w_qct_01060
integer x = 64
integer y = 1908
integer width = 1376
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type dw_list from datawindow within w_qct_01060
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 388
integer width = 3552
integer height = 1520
integer taborder = 20
string dataobject = "d_qct_01061"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  에서 Error 발생시 

string	sColumnName
sColumnName = dwo.name + "_t.text"


sle_message_line.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
	
	
end event

event itemchanged;
long	lRow
lRow = this.GetRow()

IF this.GetColumnName() = 'imhist_iofaqty'	THEN
	
	dec	dBadQty, dQty
	dQty = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dBadQty = dec(this.GetText())
	
	IF dBadQty > dQty		THEN
		MessageBox("확인", "불량수량은 현재수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_iofaqty", 0)
		RETURN 1
	END IF
	
END IF
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

