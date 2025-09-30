$PBExportHeader$w_qct_01020.srw
$PBExportComments$사내 재검사의뢰 등록
forward
global type w_qct_01020 from window
end type
type pb_1 from u_pb_cal within w_qct_01020
end type
type p_exit from uo_picture within w_qct_01020
end type
type p_cancel from uo_picture within w_qct_01020
end type
type p_select from uo_picture within w_qct_01020
end type
type p_delete from uo_picture within w_qct_01020
end type
type p_insert from uo_picture within w_qct_01020
end type
type p_save from uo_picture within w_qct_01020
end type
type p_retrieve from uo_picture within w_qct_01020
end type
type rb_delete from radiobutton within w_qct_01020
end type
type rb_insert from radiobutton within w_qct_01020
end type
type dw_detail from datawindow within w_qct_01020
end type
type gb_2 from groupbox within w_qct_01020
end type
type dw_list from datawindow within w_qct_01020
end type
type rr_1 from roundrectangle within w_qct_01020
end type
end forward

global type w_qct_01020 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "사내 재검사의뢰 등록"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
pb_1 pb_1
p_exit p_exit
p_cancel p_cancel
p_select p_select
p_delete p_delete
p_insert p_insert
p_save p_save
p_retrieve p_retrieve
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
gb_2 gb_2
dw_list dw_list
rr_1 rr_1
end type
global w_qct_01020 w_qct_01020

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
public function integer wf_imhist_delete ()
public subroutine wf_setting (string sgubun, string sdepot, string sitem, string spspec, long lrow)
public function integer wf_save2 ()
public function integer wf_check ()
public function integer wf_initial ()
public function integer wf_save1 ()
end prototypes

public function integer wf_imhist_delete ();string	sGubun
long		lRow, lRowCount, k

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
	
	if dw_list.GetItemString(lRow, "del") 	= 'Y' then 
   	sGubun = dw_list.GetItemString(lRow, "GUBUN")

		IF sGubun = 'Y'	THEN
			MessageBox("확인", "검토완료된 자료는 삭제할 수 없습니다.~r" +	&
									 "LINE : " + string(lRow) )
			RETURN -1
		END IF
	   
		k ++ 
		dw_list.DeleteRow(lRow)
	else 
		// 추가된 자료중에서 삭제가 아닌 자료는 modify 변경 안되게
		IF NewModified!  = dw_list.GetItemStatus(lrow, 0, Primary!) then 
			dw_list.SetItemStatus(lrow, 0, Primary!, NotModified!)
		END IF
	end if
	
NEXT

if k < 1 then 
	MessageBox("확인", "삭제할 자료를 선택하세요!")
	RETURN -1
end if

RETURN 1

end function

public subroutine wf_setting (string sgubun, string sdepot, string sitem, string spspec, long lrow);string get_fr, get_to, get_lastdate, snull
dec {3} get_qty

setnull(snull)

if sgubun = 'Y' then 
	SELECT "JEGO_QTY", "LOCFR", "LOCTO", "LAST_IN_DATE"  
	  INTO :get_qty,   :get_fr, :get_to, :get_lastdate
	  FROM "STOCK"  
	 WHERE "DEPOT_NO" = :sdepot
		AND "ITNBR"    = :sitem
		AND "PSPEC"    = :spspec ;

	dw_list.SetItem(lRow, "stock_jego_qty", get_qty)
	dw_list.SetItem(lRow, "stock_locfr", get_fr)
	dw_list.SetItem(lRow, "stock_locto", get_to)
	dw_list.SetItem(lRow, "imhist_jukedat", get_lastdate)
else	
	dw_list.SetItem(lRow, "stock_jego_qty", 0)
	dw_list.SetItem(lRow, "stock_locfr", snull)
	dw_list.SetItem(lRow, "stock_locto", snull)
	dw_list.SetItem(lRow, "imhist_jukedat", snull)
end if		

end subroutine

public function integer wf_save2 ();///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '010'
///////////////////////////////////////////////////////////////////////
string	sJpno,   sDate, 		&
			sQcEmp,	sQcitem, &
			sDept,   sNull, sitgu, sdepot, sitnbr
long		lRow, lRowHist, lseq, lcount

SetNull(sNull)

sDate  = dw_detail.GetItemString(1, "edate")				// 의뢰일자
lSeq   = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'C0')

IF lSeq < 0		THEN
	ROLLBACK;
	f_message_chk(51,'')
	RETURN -1
END IF

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(lSeq, "0000")

sDepot = dw_detail.GetItemString(1, "house")				

lcount = dw_list.RowCount()
lRowHist = 0
	
FOR	lRow = 1	TO	lCount
	
	if dw_list.GetitemString(lRow, "opt") = 'Y' then continue 
	
	lRowHist ++ 
	
	dw_list.SetItem(lRow, "imhist_sabu",		gs_Sabu)
	dw_list.SetItem(lRow, "imhist_iojpno", 	sJpno + string(lRowHist, "000") )
	dw_list.SetItem(lRow, "imhist_iogbn",     'O30')
	dw_list.SetItem(lRow, "imhist_sudat",  	sDate)	
	dw_list.SetItem(lRow, "imhist_opseq",	   '9999') 			// 공정순서
	dw_list.SetItem(lRow, "imhist_depot_no",  sDepot)
	
	sDept = dw_list.getitemstring(lRow, 'imhist_ioredept')
	dw_list.SetItem(lRow, "imhist_cvcod",	   sdept) 			// 거래처=의뢰부서

	dw_list.SetItem(lRow, "imhist_filsk",   'N') 				// 재고관리유무
	dw_list.SetItem(lRow, "imhist_botimh",  'N')

   sitnbr = 	dw_list.GetItemString(lRow, "imhist_itnbr")

   //생산실적이 Y 인 경우만 생산팀 입력
	SELECT A.ITGU, A.QCEMP
	  INTO :sItgu, :sQcitem
	  FROM ITEMAS A
	 WHERE A.ITNBR = :sitnbr ;                   
	
	dw_list.SetItem(lRow, "imhist_itgu",    sitgu) 	// 구입형태
	dw_list.SetItem(lRow, "imhist_jnpcrt",  	'010')	
	dw_list.SetItem(lRow, "imhist_inpcnf",     'M')	
	dw_list.SetItem(lRow, "imhist_io_confirm", 'N')			// 수불승인여부

	SELECT QCEMP
	  INTO :sQcEmp	
	  FROM DANMST
	 WHERE ITNBR = :sitnbr	AND SLTCD = 'Y' AND ROWNUM = 1 ;

   if isnull(sQcemp) or sQcemp = '' then sQcemp = sQcitem

	dw_list.SetItem(lRow, "imhist_qcgub",	'2') 		// 검사구분
	dw_list.SetItem(lRow, "imhist_insemp",  sqcemp)
	
NEXT

RETURN 1
end function

public function integer wf_check ();string	sCode
dec		dQty, dJego_qty
long		lRow, lCount, k

lCount = dw_list.RowCount()

FOR	lRow = 1	TO	lCount
      
		if dw_list.GetitemString(lRow, "opt") = 'Y' then continue 
		
		k ++ 
		
		sCode = dw_list.GetitemString(lRow, "imhist_itnbr")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[품번]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_itnbr")
			dw_list.setfocus()
			RETURN -1
		END IF

		sCode = dw_list.GetitemString(lRow, "imhist_pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[사양]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_pspec")
			dw_list.setfocus()
			RETURN -1
		END IF
//		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
//			dw_list.setitem(lrow, 'imhist_pspec', '.')
//		END IF

		dQty = dw_list.getitemdecimal(lrow, "imhist_ioreqty")
		IF IsNull(dQty)  or  dQty <= 0		THEN
			f_message_chk(30,'[의뢰수량]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreqty")
			dw_list.setfocus()
			RETURN -1
		END IF

		sCode = dw_list.GetitemString(lRow, "imhist_ioredept")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[의뢰부서]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioredept")
			dw_list.setfocus()
			RETURN -1
		END IF

		sCode = dw_list.GetitemString(lRow, "imhist_ioreemp")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[의뢰담당자]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreemp")
			dw_list.setfocus()
			RETURN -1
		END IF		
 
		dJego_Qty = dw_list.getitemdecimal(lrow, "stock_jego_qty")
		IF IsNull(dQty)  or  dQty <= 0		THEN
			messagebox('확 인', '재고수량이 없습니다. 입력한 자료를 확인하세요!')
			dw_list.ScrollToRow(lrow)
			dw_list.setfocus()
			RETURN -1
		ELSEIF dJego_Qty < dQty then  	
			messagebox('확 인', '의뢰수량이 재고수량보다 큽니다. 입력한 자료를 확인하세요!')
			dw_list.ScrollToRow(lrow)
			dw_list.setfocus()
			RETURN -1
		END IF
NEXT

if k < 1 then 
	messagebox('확 인', '저장 할 자료를 없습니다. 자료를 확인하세요!')
	RETURN -1
end if

RETURN 1

end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

p_delete.enabled = false
p_delete.PictureName = "c:\erpman\image\삭제_d.gif"
p_insert.enabled = false
p_insert.PictureName = "c:\erpman\image\추가_d.gif"
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// 등록시
	dw_detail.settaborder("day",    30)
	dw_detail.settaborder("gubun",  40)
	dw_detail.settaborder("dept",   50)
	dw_detail.settaborder("empno",  60)

	dw_detail.setcolumn("edate")
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "등록"
	p_save.enabled = true
	p_save.PictureName = "c:\erpman\image\의뢰생성_up.gif"
	p_retrieve.enabled = false
	p_retrieve.PictureName = "c:\erpman\image\조회_d.gif"

ELSE
	dw_detail.settaborder("day",    0)
	dw_detail.settaborder("gubun",  0)
	dw_detail.settaborder("dept",   0)
	dw_detail.settaborder("empno",  0)

	dw_detail.setcolumn("edate")
	dw_detail.SetItem(1, "edate", is_Date)
	w_mdi_frame.sle_msg.text = "삭제"
	p_save.enabled = FALSE
	p_save.PictureName = "c:\erpman\image\저장_d.gif"
	p_retrieve.enabled = true
	p_retrieve.PictureName = "c:\erpman\image\조회_up.gif"
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1
end function

public function integer wf_save1 ();/////////////////////////////////////////////////////////////////////////
string	sDate, 		&
			sTempDate,	&
			sLimitDate,	&
			sHouse,		&
			sGubun,		&
			sDept,		&
			sEmpno
int		iDay

sDate  = Trim(dw_detail.GetItemString(1, "edate"))
sHouse = dw_detail.GetItemString(1, "house")
iDay   = dw_detail.GetItemNumber(1, "day")
sGubun = dw_detail.GetItemString(1, "gubun")
sDept  = dw_detail.GetItemString(1, "dept")
sEmpno = dw_detail.GetItemString(1, "empno")

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[기준창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(iDay) or iDay = 0 	THEN
	f_message_chk(30,'[기준일수]')
	dw_detail.SetColumn("day")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[계산방법]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[의뢰부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[의뢰담당자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN -1
END IF

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////
int	iReturn
IF Messagebox('의뢰자료생성','사내 재검사 의뢰자료를 생성 하시겠습니까?', &
              Question!,YesNo!,1) <> 1 	THEN	RETURN -1

sTempDate = Left(sDate,4) + '/' + mid(sdate,5,2) + '/' + Right(sDate,2)

sLimitDate = String(RelativeDate(Date(sTempDate), -iDay), 'YYYYMMDD')

IF ic_status = '1'	THEN
	
	iRETURN = SQLCA.erp000000100(gs_Sabu,sDate,sHouse,string(iDay),sLimitDate,sGubun,sDept,sEmpno) 
	IF iReturn = -1	THEN
		ROLLBACK;
		f_Rollback()
		RETURN -1 
	ELSEIF iReturn = 0		THEN
		ROLLBACK;
		f_message_chk(50, '[의뢰생성자료]')
		RETURN -1
	END IF
	
END IF

////////////////////////////////////////////////////////////////////////////

dw_list.Retrieve(gs_Sabu, sDate, sHouse) 
dw_detail.enabled = false
p_delete.enabled = true
p_delete.PictureName = "c:\erpman\image\삭제_up.gif"
p_insert.enabled = true
p_insert.PictureName = "c:\erpman\image\추가_up.gif"
p_retrieve.enabled = true
p_retrieve.PictureName = "c:\erpman\image\조회_up.gif"
rb_delete.checked = true
ic_status = '2'

p_save.PictureName = "c:\erpman\image\저장_up.gif"
p_select.PictureName = "c:\erpman\image\전체선택_up.gif"

w_mdi_frame.sle_msg.text = "삭제"

RETURN 1
end function

event open;is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

w_mdi_frame.st_window.Text = Upper(is_window_id)

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

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)


//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_qct_01020.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_select=create p_select
this.p_delete=create p_delete
this.p_insert=create p_insert
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_1,&
this.p_exit,&
this.p_cancel,&
this.p_select,&
this.p_delete,&
this.p_insert,&
this.p_save,&
this.p_retrieve,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.gb_2,&
this.dw_list,&
this.rr_1}
end on

on w_qct_01020.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_select)
destroy(this.p_delete)
destroy(this.p_insert)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.dw_list)
destroy(this.rr_1)
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

type pb_1 from u_pb_cal within w_qct_01020
integer x = 681
integer y = 64
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'edate', gs_code)
end event

type p_exit from uo_picture within w_qct_01020
integer x = 4421
integer y = 20
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;CLOSE(PARENT)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\닫기_dn.gif"
end event

type p_cancel from uo_picture within w_qct_01020
integer x = 4247
integer y = 20
integer width = 178
string picturename = "c:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")

p_select.picturename = "c:\erpman\image\전체선택_up.gif"


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\취소_dn.gif"
end event

type p_select from uo_picture within w_qct_01020
integer x = 4073
integer y = 20
integer width = 178
string picturename = "c:\erpman\image\전체선택_up.gif"
end type

event clicked;call super::clicked;Long Lrow, lcount

lcount = dw_list.rowcount()

If this.PictureName = "c:\erpman\image\전체선택_up.gif" Then
	For Lrow = 1 to lcount
		if dw_list.getitemstring(lrow, "gubun") = 'Y' then continue 
		dw_list.setitem(lrow, "del", 'Y')
	Next
	
	this.PictureName = "c:\erpman\image\전체해제_up.gif"	
Else
	For Lrow = 1 to lcount
		dw_list.setitem(lrow, "del", 'N')
	Next
	
	this.PictureName = "c:\erpman\image\전체선택_up.gif"
End if
end event

event ue_lbuttonup;call super::ue_lbuttonup;if this.PictureName = "c:\erpman\image\전체해제_up.gif" or &
   this.PictureName = "c:\erpman\image\전체해제_dn.gif" then
	
	this.PictureName = "c:\erpman\image\전체해제_up.gif"
	
Else
	
	this.PictureName = "c:\erpman\image\전체선택_up.gif"
	
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;if this.PictureName = "c:\erpman\image\전체해제_up.gif" or &
   this.PictureName = "c:\erpman\image\전체해제_dn.gif" then
	
	this.PictureName = "c:\erpman\image\전체해제_dn.gif"
	
Else
	
	this.PictureName = "c:\erpman\image\전체선택_dn.gif"
	
end if
end event

type p_delete from uo_picture within w_qct_01020
integer x = 3899
integer y = 20
integer width = 178
string picturename = "c:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;/////////////////////////////////////////////////////////////////
//	* 입고내역 삭제
/////////////////////////////////////////////////////////////////
if dw_list.rowcount() < 1 then return 

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN

IF dw_list.Update() >= 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

if dw_list.rowcount() < 1 then 
	p_cancel.TriggerEvent("clicked")
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\삭제_dn.gif"
end event

type p_insert from uo_picture within w_qct_01020
boolean visible = false
integer x = 3621
integer y = 204
integer width = 178
boolean enabled = false
string picturename = "c:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN
if dw_list.AcceptText() = -1 then return 

/////////////////////////////////////////////////////////////////////////
string	sDate, 	&
			sHouse
long     il_currow

sDate  = TRIM(dw_detail.GetItemString(1, "edate"))
sHouse = dw_detail.GetItemString(1, "house")

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[기준창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN
END IF

il_currow = dw_list.rowcount() + 1

dw_list.InsertRow(il_currow)
dw_list.ScrollToRow(il_currow)
dw_list.SetColumn('imhist_itnbr')
dw_list.SetFocus()

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\추가_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\추가_dn.gif"
end event

type p_save from uo_picture within w_qct_01020
integer x = 3726
integer y = 20
integer width = 178
string picturename = "c:\erpman\image\의뢰생성_up.gif"
end type

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN

if ic_status = '1' then 
	// 의뢰자료 생성
	IF wf_save1() = -1 THEN RETURN 
else
	IF dw_list.rowcount() < 1	THEN	RETURN
	// 필수 입력 체크 
	if wf_check() < 1 then return 

	IF f_msg_update() = -1 	THEN	RETURN

	// 추가된 내용을 저장처리
	IF wf_save2() = -1	THEN RETURN

	IF dw_list.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF
	
	p_cancel.TriggerEvent("clicked")	
	
end if

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;if PictureName = "c:\erpman\image\의뢰생성_up.gif" or &
   PictureName = "c:\erpman\image\의뢰생성_dn.gif" then
	
	PictureName = "c:\erpman\image\의뢰생성_dn.gif"
	
else
	
	PictureName = "c:\erpman\image\저장_dn.gif"
	
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;if PictureName = "c:\erpman\image\의뢰생성_up.gif" or &
   PictureName = "c:\erpman\image\의뢰생성_dn.gif" then
	
	PictureName = "c:\erpman\image\의뢰생성_up.gif"
	
else
	
	PictureName = "c:\erpman\image\저장_up.gif"
	
end if
end event

type p_retrieve from uo_picture within w_qct_01020
integer x = 3552
integer y = 20
integer width = 178
string picturename = "c:\erpman\image\조회_d.gif"
end type

event clicked;
IF dw_detail.AcceptText() = -1	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
string	sDate, 	&
			sHouse

sDate  = TRIM(dw_detail.GetItemString(1, "edate"))
sHouse = dw_detail.GetItemString(1, "house")

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[기준창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
	
IF	dw_list.Retrieve(gs_sabu, sDate, sHouse) <	1		THEN
	f_message_chk(50, '[의뢰생성내역]')
	dw_detail.setcolumn("edate")
	dw_detail.setfocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////

dw_detail.enabled = false
p_delete.enabled = true
p_delete.PictureName = "c:\erpman\image\삭제_up.gif"
p_insert.enabled = true
p_insert.PictureName = "c:\erpman\image\추가_up.gif"
p_save.enabled = true
p_save.PictureName = "c:\erpman\image\의뢰생성_up.gif"

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\조회_dn.gif"
end event

type rb_delete from radiobutton within w_qct_01020
integer x = 3035
integer y = 184
integer width = 229
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
end type

event clicked;ic_status = '2'

wf_Initial()
end event

type rb_insert from radiobutton within w_qct_01020
integer x = 3035
integer y = 76
integer width = 229
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'	// 등록


wf_Initial()
end event

type dw_detail from datawindow within w_qct_01020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 24
integer width = 2834
integer height = 324
integer taborder = 10
string dataobject = "d_qct_01020"
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

event itemchanged;string	sDept, sDeptName,		&
			sEmpno, sEmpname,		&
			sNull
SetNull(sNull)


// 의뢰부서
IF this.GetColumnName() = 'dept'		THEN

	sDept = this.gettext()
	SELECT CVNAS2
	  INTO :sDeptName
	  FROM VNDMST
	 WHERE CVCOD = :sDept AND 
	 		 CVGU = '4'		 AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰부서]')
		this.setitem(1, "dept", sNull)
		this.setitem(1, "deptname", sNull)
		return 1
	end if

	this.setitem(1, "deptname", sDeptName)
	 
END IF

// 의뢰담당자
IF this.GetColumnName() = 'empno'		THEN

	sEmpno = this.gettext()
	
	SELECT EMPNAME, DEPTCODE, FUN_GET_DPTNO(DEPTCODE) 
	  INTO :sEmpname, :sDept, :sDeptName
	  FROM P1_MASTER
	 WHERE EMPNO = :sEmpno AND 
			 SERVICEKINDCODE <> '3' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰담당자]')
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	this.setitem(1, "name", sEmpName)
	this.setitem(1, "dept", sDept)
	this.setitem(1, "deptname", sDeptName)
	 
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 담당자
IF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
	this.triggerevent(itemchanged!)
	
END IF

// 부서
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "dept",	  gs_code)
	SetItem(1, "deptname", gs_codename)

END IF


end event

type gb_2 from groupbox within w_qct_01020
integer x = 2921
integer width = 430
integer height = 308
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type dw_list from datawindow within w_qct_01020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 364
integer width = 4549
integer height = 1840
integer taborder = 20
string dataobject = "d_qct_01021"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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

event itemerror;return 1
end event

event itemchanged;long		lRow
string	sItem, sName, sSpec,	sJijil, sSpec_code,	sPspec, sDepot, &
			sNull, sqcgub, sqcemp, sdept, sdeptname, sempno, sempname, &
			get_fr, get_to, get_lastdate , sitnbr , sitdsc, sispec, sispec_code
integer  ireturn
dec {3}  get_qty

SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'imhist_itnbr'	THEN
	sItem = trim(THIS.GETTEXT())								
	ireturn = f_get_name4('품번', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	this.setitem(lrow, "imhist_itnbr", sitem)	
	this.SetItem(lRow, "itemas_itdsc", sName)
	this.SetItem(lRow, "itemas_ispec", sSpec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	
	if not isnull(sitem) then 
      sPspec = this.getitemstring(lrow, 'imhist_pspec')		
		if isnull(spspec) then spspec = '.'
      sDepot = dw_detail.getitemstring(1, 'house')		
      wf_setting('Y', sdepot, sitem, spspec, lrow)		
	else	
      wf_setting('N', sdepot, sitem, spspec, lrow)		
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	this.setitem(lrow, "imhist_itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
      sPspec = this.getitemstring(lrow, 'imhist_pspec')		
		if isnull(spspec) then spspec = '.'
      sDepot = dw_detail.getitemstring(1, 'house')		
      wf_setting('Y', sdepot, sitem, spspec, lrow)		
	else	
      wf_setting('N', sdepot, sitem, spspec, lrow)		
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
   this.setitem(lrow, "imhist_itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
      sPspec = this.getitemstring(lrow, 'imhist_pspec')		
		if isnull(spspec) then spspec = '.'
      sDepot = dw_detail.getitemstring(1, 'house')		
      wf_setting('Y', sdepot, sitem, spspec, lrow)		
	else	
      wf_setting('N', sdepot, sitem, spspec, lrow)		
   end if		
	RETURN ireturn
	

ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())

	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	this.setitem(lrow, "itemas_jijil", sjijil)
	if not isnull(sitem) then 
      sPspec = this.getitemstring(lrow, 'imhist_pspec')		
		if isnull(spspec) then spspec = '.'
      sDepot = dw_detail.getitemstring(1, 'house')		
      wf_setting('Y', sdepot, sitem, spspec, lrow)		
	else	
      wf_setting('N', sdepot, sitem, spspec, lrow)		
   end if		
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())

	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	this.setitem(lrow, "itemas_jijil", sjijil)
	if not isnull(sitem) then 
      sPspec = this.getitemstring(lrow, 'imhist_pspec')		
		if isnull(spspec) then spspec = '.'
      sDepot = dw_detail.getitemstring(1, 'house')		
      wf_setting('Y', sdepot, sitem, spspec, lrow)		
	else	
      wf_setting('N', sdepot, sitem, spspec, lrow)		
   end if		
	RETURN ireturn
	
ELSEIF this.GetColumnName() = 'imhist_pspec'	THEN
	spspec  = THIS.GETTEXT()								
	
	if isnull(spspec) then spspec = '.'
	
	sitem  = this.getitemstring(lrow, 'imhist_itnbr')		
	sDepot = dw_detail.getitemstring(1, 'house')		
	wf_setting('Y', sdepot, sitem, spspec, lrow)		
	// 의뢰부서
ELSEIF this.GetColumnName() = 'imhist_ioredept'		THEN

	sDept = this.gettext()
	
	SELECT CVNAS2
	  INTO :sDeptName
	  FROM VNDMST
	 WHERE CVCOD    = :sDept AND 
	 		 CVGU     = '4'	 AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰부서]')
		this.setitem(lRow, "imhist_ioredept", sNull)
		this.setitem(lrow, "dptnm", sNull)
		return 1
	end if

	this.setitem(lrow, "dptnm", sDeptName)
	 
// 의뢰담당자
ELSEIF this.GetColumnName() = 'imhist_ioreemp'		THEN

	sEmpno = this.gettext()
	
	SELECT EMPNAME, DEPTCODE, FUN_GET_DPTNO(DEPTCODE) 
	  INTO :sEmpname, :sDept, :sDeptName
	  FROM P1_MASTER
	 WHERE EMPNO = :sEmpno AND 
			 SERVICEKINDCODE <> '3' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰담당자]')
		this.setitem(lRow, "imhist_ioreemp", sNull)
		this.setitem(lRow, "empnm", sNull)
		return 1
	end if

	this.setitem(lRow, "empnm", sEmpName)
	this.setitem(lRow, "imhist_ioredept", sDept)
	this.setitem(lrow, "dptnm", sDeptName)
	 
END IF

end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'imhist_itnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(lRow,"imhist_itnbr",gs_code)
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = 'imhist_ioreemp'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lrow,"imhist_ioreemp",gs_code)
	this.triggerevent(itemchanged!)
	
ELSEIF this.GetColumnName() = 'imhist_ioredept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lrow, "imhist_ioredept",	  gs_code)
	this.triggerevent(itemchanged!)

END IF



end event

type rr_1 from roundrectangle within w_qct_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 356
integer width = 4581
integer height = 1864
integer cornerheight = 40
integer cornerwidth = 55
end type

