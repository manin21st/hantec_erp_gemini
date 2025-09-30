$PBExportHeader$w_pdt_04010.srw
$PBExportComments$출고의뢰등록
forward
global type w_pdt_04010 from window
end type
type pb_1 from picturebutton within w_pdt_04010
end type
type dw_hidden from datawindow within w_pdt_04010
end type
type p_select from picture within w_pdt_04010
end type
type p_jago from uo_picture within w_pdt_04010
end type
type p_mod from uo_picture within w_pdt_04010
end type
type p_del from uo_picture within w_pdt_04010
end type
type p_inq from uo_picture within w_pdt_04010
end type
type p_can from uo_picture within w_pdt_04010
end type
type p_exit from uo_picture within w_pdt_04010
end type
type p_copy from uo_picture within w_pdt_04010
end type
type p_addrow from uo_picture within w_pdt_04010
end type
type p_delrow from uo_picture within w_pdt_04010
end type
type cb_1 from commandbutton within w_pdt_04010
end type
type cb_copy from commandbutton within w_pdt_04010
end type
type dw_copy from datawindow within w_pdt_04010
end type
type dw_req from datawindow within w_pdt_04010
end type
type cbx_print from checkbox within w_pdt_04010
end type
type dw_1 from datawindow within w_pdt_04010
end type
type cb_delete from commandbutton within w_pdt_04010
end type
type cb_cancel from commandbutton within w_pdt_04010
end type
type cb_del from commandbutton within w_pdt_04010
end type
type cb_insert from commandbutton within w_pdt_04010
end type
type rb_delete from radiobutton within w_pdt_04010
end type
type rb_insert from radiobutton within w_pdt_04010
end type
type dw_detail from datawindow within w_pdt_04010
end type
type cb_save from commandbutton within w_pdt_04010
end type
type cb_exit from commandbutton within w_pdt_04010
end type
type cb_retrieve from commandbutton within w_pdt_04010
end type
type dw_list from datawindow within w_pdt_04010
end type
type rr_1 from roundrectangle within w_pdt_04010
end type
type rr_2 from roundrectangle within w_pdt_04010
end type
type rr_3 from roundrectangle within w_pdt_04010
end type
type rr_4 from roundrectangle within w_pdt_04010
end type
type dw_instore from datawindow within w_pdt_04010
end type
end forward

global type w_pdt_04010 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "출고의뢰 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_1 pb_1
dw_hidden dw_hidden
p_select p_select
p_jago p_jago
p_mod p_mod
p_del p_del
p_inq p_inq
p_can p_can
p_exit p_exit
p_copy p_copy
p_addrow p_addrow
p_delrow p_delrow
cb_1 cb_1
cb_copy cb_copy
dw_copy dw_copy
dw_req dw_req
cbx_print cbx_print
dw_1 dw_1
cb_delete cb_delete
cb_cancel cb_cancel
cb_del cb_del
cb_insert cb_insert
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
dw_instore dw_instore
end type
global w_pdt_04010 w_pdt_04010

type variables
boolean ib_ItemError
char  ic_status, ic_yn    //타계정 사용여부(Y:사용)
string is_Last_Jpno, is_date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
datawindowchild dws

String     is_return 
String 	    is_batch	        //자료 일괄생성처리 여부.
end variables

forward prototypes
public subroutine wf_focus1 ()
public function integer wf_update (ref string sdate, ref long dseq)
public function integer wf_delete ()
public function integer wf_dup_chk ()
public subroutine wf_focus ()
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
public function integer wf_copy ()
end prototypes

public subroutine wf_focus1 ();dw_list.setcolumn("in_store")
dw_list.setfocus()
end subroutine

public function integer wf_update (ref string sdate, ref long dseq);string	sJpno, ls_gubun, ls_depot
long		lRow

if dw_detail.AcceptText() = -1 then return -1

sDate = trim(dw_detail.GetItemString(1, "sdate"))
ls_gubun = trim(dw_detail.GetItemString(1, "gubun"))
ls_depot = trim(dw_detail.GetItemString(1, "house"))

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'B0')

IF dSeq < 0		THEN	
	ROLLBACK;
	RETURN -1
END IF
COMMIT;

sJpno = sDate + string(dSeq, "0000")

dw_detail.setitem(1, "jpno", sJpno)

FOR lRow = 1		TO		dw_list.RowCount()
	dw_list.SetItem(lRow, "hold_no", sJpno + string(lRow, "000"))
	dw_list.SetItem(lRow, "hold_gu", ls_gubun)
	dw_list.SetItem(lRow, "out_store", ls_depot)
	
	if isnull(dw_list.getitemstring(lrow, "pspec")) or &
		trim(dw_list.getitemstring(lrow, "pspec")) = '' then
		dw_list.setitem(lrow, "pspec", '.')
	end if
	
	if ic_yn = 'Y' then 
		if isnull(dw_list.getitemstring(lrow, "dpspec")) or &
			trim(dw_list.getitemstring(lrow, "dpspec")) = '' then
			dw_list.setitem(lrow, "dpspec", '.')
		end if
	end if	
NEXT

RETURN 1

end function

public function integer wf_delete ();string	sGubun
long		lRow, lRowCount, nDelCnt
lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	if dw_list.getitemdecimal(lrow, "isqty") = 0 then
		dw_list.DeleteRow(lRow)
		
		nDelCnt += 1
	end if
	
NEXT

RETURN nDelCnt
end function

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind

FOR k = dw_list.rowcount() TO 1 step - 1
   sfind = dw_list.getitemstring(k, 'itnbr')

	lReturnRow = dw_list.Find("itnbr = '"+sfind+"' ", 1, dw_list.RowCount())
	
	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번/사양]')
		dw_list.Setrow(k)
		dw_list.Setcolumn('pspec')
		dw_list.setfocus()
		RETURN  -1
	END IF
NEXT

return 1
end function

public subroutine wf_focus ();dw_list.setcolumn("itnbr")
dw_list.setfocus()
end subroutine

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sdItem, sPspec, sdPspec
dec{3}	dQty, dOutQty
long		lRow

FOR	lRow = 1		TO		dw_list.RowCount()

	// 품번
	sItem = dw_list.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[품번]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		RETURN -1
	END IF

	// 사양
	sPspec = dw_list.GetitemString(lRow, "pspec")
	IF IsNull(sPspec)	or   trim(sPspec) = ''	THEN
		sPspec = '.'
		dw_list.Setitem(lRow, "pspec", sPspec)
	END IF
	
	// 대체품번
	if ic_yn = 'Y' then 
		sdItem = dw_list.GetitemString(lRow, "ditnbr")
		IF IsNull(sdItem) 	or   trim(sdItem) = ''	THEN
			f_message_chk(30,'[타계정 대체품번]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("ditnbr")
			dw_list.setfocus()
			RETURN -1
		END IF
		
		sdPspec = dw_list.GetitemString(lRow, "dpspec")
		IF IsNull(sdpspec) 	or   trim(sdpspec) = ''	THEN
			f_message_chk(30,'[타계정 대체사양]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("dpspec")
			dw_list.setfocus()
			RETURN -1
		ELSE	
			if sitem + spspec = sditem + sdpspec then 
				MessageBox('확 인', '품번/사양이 타계정 대체품번/사양과 같으니 확인하세요.')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("ditnbr")
				dw_list.setfocus()
				RETURN -1
			end if				
		END IF
	end if	
	
	// 출고요청수량	
	dQty = dw_list.getitemdecimal(lrow, "hold_qty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[출고요청수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("hold_qty")
		dw_list.setfocus()
		RETURN -1
	END IF

	// 미출고수량 = 출고요청량 - 출고수량
	dOutQty = dw_list.GetItemDecimal(lRow, "isqty")
	dw_list.SetItem(lRow, "unqty", dQty - dOutQty)
	

	// 입고처
	sCode = dw_list.GetitemString(lRow, "in_store")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[입고처]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("in_store")
		dw_list.setfocus()
		RETURN -1
	END IF

	
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_list.GetitemString(lRow, "hold_no")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_list.SetItem(lRow, "hold_no", is_Last_Jpno)
		END IF
	END IF

NEXT

RETURN 1
end function

public function integer wf_initial ();string sempno, sempnm, sDept, sname

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

// 입고창고
datawindowchild state_child
integer rtncode
String		ls_saupj, ls_empnm

ls_saupj	= gs_saupj
//if 	gs_saupj	= '%' 	then ls_saupj = '10'
rtncode = dw_detail.GetChild("house", state_child)
IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 입고창고")
state_child.SetTransObject(SQLCA)
//state_child.Retrieve( gs_saupj, "2", gs_empno)
state_child.Retrieve( Ls_saupj)

dw_detail.settransobject(sqlca)

//cb_save.enabled = false
p_del.enabled = false
p_copy.enabled = false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_copy.PictureName = 'C:\erpman\image\복사_d.gif'

dw_detail.enabled = TRUE
dw_1.reset()

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////
//2004.03.05 김현식(요청부서 에러메시지로 인해 사용자가 선택토록 수정)
//dw_detail.SetItem(1, "empno", gs_empno)
//Select fun_get_empnO(:gs_empno) into :ls_empnm from dual;
//dw_detail.SetItem(1, "empnm", ls_empnm)


IF ic_status = '1'	then
	// 등록시
	dw_detail.settaborder("jpno",   0)
	dw_detail.settaborder("sdate",  10)
	dw_detail.settaborder("edate",  20)
	dw_detail.settaborder("HOUSE",  30)
	dw_detail.settaborder("PROJECT",40)
	dw_detail.settaborder("empno",  50)
//	dw_detail.settaborder("DEPT",   60)
	dw_detail.settaborder("GUBUN",  70)

//   dw_detail.Object.jpno.Background.Color= 79741120
//   dw_detail.Object.sdate.Background.Color= 12639424
//   dw_detail.Object.edate.Background.Color= 12639424
//   dw_detail.Object.house.Background.Color= 12639424
//   dw_detail.Object.gubun.Background.Color= 12639424
//   dw_detail.Object.empno.Background.Color= 65535
//  // dw_detail.Object.dept.Background.Color= 65535
//   dw_detail.Object.project.Background.Color= 65535

	dw_detail.setcolumn("edate")
	dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.SetItem(1, "edate", is_Date)
	if dws.rowcount() > 0 then
		dw_detail.setitem(1, "gubun",  dws.getitemstring(1, "iogbn"))
		dw_detail.SetItem(1, "check", dws.getitemstring(1, "naougu"))
	end if

	p_inq.enabled = false
	p_inq.picturename = "C:\erpman\image\조회_d.gif"
	
	w_mdi_frame.sle_msg.text = "등록"
	
	select a.empno, a.empname, a.deptcode, b.deptname into :sempno, :sempnm, :sDept, :sname from p1_master a, p0_dept b
	 where a.empno = :gs_empno and a.deptcode = b.deptcode;
	If SQLCA.SQLCODE = 0 THEN
		dw_detail.setitem(1, "empno", sEmpno)
		dw_detail.setitem(1, "empnm", sEmpnm)
		dw_detail.setitem(1, "dept", sDept)
		dw_detail.setitem(1, "deptname", sName)
	End If
ELSE
	dw_detail.settaborder("jpno",   10)
	dw_detail.settaborder("GUBUN",  0)
	dw_detail.settaborder("sDATE",  0)
	dw_detail.settaborder("EDATE",  0)
	dw_detail.settaborder("PROJECT",0)
//	dw_detail.settaborder("DEPT",   0)
	dw_detail.settaborder("HOUSE",  0)
	dw_detail.settaborder("empno",   0)

//   dw_detail.Object.jpno.Background.Color= 65535
//   dw_detail.Object.sdate.Background.Color= 79741120
//   dw_detail.Object.edate.Background.Color= 79741120
//   dw_detail.Object.house.Background.Color= 79741120
//   dw_detail.Object.gubun.Background.Color= 79741120
//   dw_detail.Object.empno.Background.Color= 79741120
////   dw_detail.Object.dept.Background.Color= 79741120
//   dw_detail.Object.project.Background.Color= 79741120

	dw_detail.setcolumn("JPNO")

	p_inq.enabled = true
	p_inq.picturename = "C:\erpman\image\조회_up.gif"
	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

f_mod_saupj(dw_detail, 'saupj')

is_batch 	= 'N'

return  1

end function

public function integer wf_copy ();dw_copy.reset()

Long Lrow
String sNull

Setnull(sNull)

if dw_detail.AcceptText() = -1 then return -1
if dw_list.AcceptText() = -1 then return -1

IF MessageBox("확 인", "현재 자료를 복사 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN 1
end if

For Lrow = 1 to dw_list.rowcount()

	 dw_copy.insertrow(Lrow)
	 dw_copy.setitem(Lrow, "itnbr", 	  		dw_list.getitemstring(Lrow, "itnbr"))
	 dw_copy.setitem(Lrow, "itdsc", 	  		dw_list.getitemstring(Lrow, "itdsc"))
	 dw_copy.setitem(Lrow, "ispec", 	  		dw_list.getitemstring(Lrow, "ispec"))
	 dw_copy.setitem(Lrow, "jijil", 	  		dw_list.getitemstring(Lrow, "jijil"))
	 dw_copy.setitem(Lrow, "ispec_code",	dw_list.getitemstring(Lrow, "ispec_code"))
	 dw_copy.setitem(Lrow, "pspec", 	  		dw_list.getitemstring(Lrow, "pspec"))	 
	 dw_copy.setitem(Lrow, "rqdat", 	  		is_date)	 
//	 dw_copy.setitem(Lrow, "hold_qty", 		dw_list.getitemdecimal(Lrow, "hold_qty"))
	 dw_copy.setitem(Lrow, "out_store",	  	dw_list.getitemstring(Lrow, "out_store"))	 
	 dw_copy.setitem(Lrow, "hold_gu",	  	dw_list.getitemstring(Lrow, "hold_gu"))
	 dw_copy.setitem(Lrow, "itemas_unmsr",	dw_list.getitemstring(Lrow, "itemas_unmsr"))
	 dw_copy.setitem(Lrow, "in_store",		dw_list.getitemstring(Lrow, "in_store"))
	 dw_copy.setitem(Lrow, "vndmst_cvnas2",dw_list.getitemstring(Lrow, "vndmst_cvnas2"))
	 dw_copy.setitem(Lrow, "hold_date",		is_date)
	 dw_copy.setitem(Lrow, "req_dept",		dw_list.getitemstring(Lrow, "req_dept"))
	 dw_copy.setitem(Lrow, "wiemp",			dw_list.getitemstring(Lrow, "wiemp"))
	 dw_copy.setitem(Lrow, "hold_gu",		dw_list.getitemstring(Lrow, "hold_gu"))
	 dw_copy.setitem(Lrow, "naougu",			dw_list.getitemstring(Lrow, "naougu"))
	 dw_copy.setitem(Lrow, "pjtno",			dw_list.getitemstring(Lrow, "pjtno"))
	 
Next

dw_detail.setredraw(false)
dw_list.setredraw(false)

dw_list.DataObject = 'd_pdt_04010'
dw_list.SetTransObject(SQLCA)

//dw_list.object.ispec_t.text = is_ispec
//dw_list.object.jijil_t.text = is_jijil

dw_copy.RowsCopy(1, dw_copy.RowCount(), Primary!, dw_list, 1, Primary!)

dw_copy.reset()
dw_detail.setitem(1, "jpno", sNull)

rb_insert.checked = true
dw_detail.enabled = false

p_inq.enabled = false
p_inq.picturename = "C:\erpman\image\조회_d.gif" 


w_mdi_frame.sle_msg.text = "등록"

ic_status = '1'

dw_detail.setredraw(true)
dw_list.setredraw(true)

return 1

end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

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


// datawindow initial value
dw_detail.settransobject(sqlca)
dw_req.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_instore.settransobject(sqlca)
dw_instore.InsertRow(0)

is_Date = f_today()

// commandbutton function
rb_insert.TriggerEvent("clicked")

DataWindowChild state_child
integer rtncode

//창고
rtncode 	= dw_detail.GetChild('house', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")

String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj

state_child.SetTransObject(SQLCA)
state_child.Retrieve(ls_saupj)
end event

on w_pdt_04010.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_1=create pb_1
this.dw_hidden=create dw_hidden
this.p_select=create p_select
this.p_jago=create p_jago
this.p_mod=create p_mod
this.p_del=create p_del
this.p_inq=create p_inq
this.p_can=create p_can
this.p_exit=create p_exit
this.p_copy=create p_copy
this.p_addrow=create p_addrow
this.p_delrow=create p_delrow
this.cb_1=create cb_1
this.cb_copy=create cb_copy
this.dw_copy=create dw_copy
this.dw_req=create dw_req
this.cbx_print=create cbx_print
this.dw_1=create dw_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.cb_del=create cb_del
this.cb_insert=create cb_insert
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_instore=create dw_instore
this.Control[]={this.pb_1,&
this.dw_hidden,&
this.p_select,&
this.p_jago,&
this.p_mod,&
this.p_del,&
this.p_inq,&
this.p_can,&
this.p_exit,&
this.p_copy,&
this.p_addrow,&
this.p_delrow,&
this.cb_1,&
this.cb_copy,&
this.dw_copy,&
this.dw_req,&
this.cbx_print,&
this.dw_1,&
this.cb_delete,&
this.cb_cancel,&
this.cb_del,&
this.cb_insert,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.dw_list,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.rr_4,&
this.dw_instore}
end on

on w_pdt_04010.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.dw_hidden)
destroy(this.p_select)
destroy(this.p_jago)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_inq)
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.p_copy)
destroy(this.p_addrow)
destroy(this.p_delrow)
destroy(this.cb_1)
destroy(this.cb_copy)
destroy(this.dw_copy)
destroy(this.dw_req)
destroy(this.cbx_print)
destroy(this.dw_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.cb_del)
destroy(this.cb_insert)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_instore)
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

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;
Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_1 from picturebutton within w_pdt_04010
integer x = 2793
integer y = 24
integer width = 315
integer height = 144
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "입고품목 선택"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;If rb_insert.Checked = False Then
	MessageBox('상태 확인', '등록 상태일 경우만 가능합니다.')
	Return
End If
//
///* 입고품목 선택 버튼으로 선택 시 상단 등록 조건에 default값 고정 - by shingoo 2015.10.14 */
//dw_detail.SetItem(1, 'house' , 'Z06'  )  //출고창고
//dw_detail.SetItem(1, 'gubun' , 'O05'  )  //수불구분
//dw_detail.SetItem(1, 'empno2', '1274' )  //출고담당자
//dw_detail.SetItem(1, 'cvcod' , 'Z03'  )  //입고처
//dw_detail.SetItem(1, 'empno' , '1379' )  //요청자
//dw_detail.SetItem(1, 'dept'  , '30040')  //요청부서
//
//String  ls_name
//SELECT EMPNAME INTO :ls_name FROM P1_MASTER WHERE EMPNO = '1274' ;
//dw_detail.SetItem(1, 'empnm2', ls_name)
//
//SetNull(ls_name)
//SELECT EMPNAME INTO :ls_name FROM P1_MASTER WHERE EMPNO = '1379' ;
//dw_detail.SetItem(1, 'empnm', ls_name)
//
//SetNull(ls_name)
//SELECT CVNAS INTO :ls_name FROM VNDMST WHERE CVCOD = 'Z03' ;
//dw_detail.SetItem(1, 'cvnas', ls_name)
//
//SetNull(ls_name)
//SELECT DEPTNAME INTO :ls_name FROM P0_DEPT WHERE COMPANYCODE = 'KN' AND DEPTCODE = '30040' ;
//dw_detail.SetItem(1, 'deptname', ls_name)
//
/* 입고품 내역 선택 */
Open(w_pdt_04035_ip)

str_code  lstr_code
lstr_code = Message.PowerObjectParm
If IsValid(lstr_code) = False OR lstr_code.code[1] = 'X' Then Return

String  ls_rqdat
ls_rqdat = dw_detail.GetItemString(1, 'edate')
If Trim(ls_rqdat) = '' OR IsNull(ls_rqdat) Then
	Messagebox('확인', '출고요청일을 입력 하십시오.')
	dw_detail.SetFocus()
	dw_detail.SetColumn('edate')
	Return
End If

String  ls_ip
ls_ip = dw_instore.GetItemString(1, 'vendor')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
	Messagebox('확인', '입고창고를 입력 하십시오.')
	dw_detail.SetFocus()
	dw_detail.SetColumn('vendor')
	Return
End If

String  ls_nam
ls_nam = dw_instore.GetItemString(1, 'vendorname')

String  ls_sdate, ls_edate, ls_dept, ls_gubun, ls_house, ls_empno, ls_check, ls_proj
ls_sdate = TRIM(dw_detail.GetItemString(1, "sdate"))
ls_edate = TRIM(dw_detail.GetItemString(1, "edate"))
ls_dept  = dw_detail.GetItemString(1, "dept")
ls_gubun	= dw_detail.GetItemString(1, "gubun")
ls_house = dw_detail.GetItemString(1, "house")
ls_empno = dw_detail.GetItemString(1, "empno")
ls_check = dw_detail.GetItemString(1, "check")
ls_proj  = dw_detail.GetItemString(1, "project")

SetNull(is_return)
// 출고요청일
IF isnull(ls_sdate) or ls_sdate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF

// 출고요청일
IF isnull(ls_edate) or ls_edate = "" 	THEN
	f_message_chk(30,'[출고요청일]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 출고창고
IF isnull(ls_house) or ls_house = "" 	THEN
	f_message_chk(30,'[출고창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF

// 요청자
IF isnull(ls_empno) or ls_empno = "" 	THEN
	f_message_chk(30,'[요청자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청부서
IF isnull(ls_dept) or ls_dept = "" 	THEN
	f_message_chk(30,'[요청부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청구분
IF isnull(ls_gubun) or ls_gubun = "" 	THEN
	f_message_chk(30,'[요청구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청구분에 대한 관련처코드
String ls_relcod, ls_naougu
Setnull(ls_relcod)
Setnull(ls_naougu)
select relcod, naougu into :ls_relcod, :ls_naougu from iomatrix 
 where sabu = :gs_sabu and iogbn = :ls_gubun;
if  isnull(ls_naougu) or trim(ls_naougu) = '' or &
	(ls_naougu <> '1' and ls_naougu <> '2') then
	f_message_chk(208,'[출고,출문구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
end if 
if isnull(ls_relcod) or trim(ls_relcod) = '' then
	f_message_chk(208,'[입고처]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
end if

if	is_batch	= 'Y'	then Return 0

Integer i
Integer li_ins
For i = 1 To UpperBound(lstr_code.code[])
	li_ins = dw_list.InsertRow(0)
	
	dw_list.SetItem(li_ins, 'itnbr'        , lstr_code.code[i]   )
	dw_list.SetItem(li_ins, 'itdsc'        , lstr_code.sgubun1[i])
	dw_list.SetItem(li_ins, 'ispec'        , lstr_code.sgubun2[i])
	dw_list.SetItem(li_ins, 'lotno'        , lstr_code.sgubun3[i])
	dw_list.SetItem(li_ins, 'hold_qty'     , lstr_code.dgubun1[i])
	dw_list.SetItem(li_ins, 'in_store'     , ls_ip               )
	dw_list.SetItem(li_ins, 'vndmst_cvnas2', ls_nam              )
	dw_list.SetItem(li_ins, 'rqdat'        , ls_rqdat            )
	dw_list.SetItem(li_ins, 'hyebia2'      , '.'                 )
	dw_list.SetItem(li_ins, "sabu"         , gs_sabu             )
	dw_list.SetItem(li_ins, "hold_date"    , ls_sdate            )
	dw_list.SetItem(li_ins, "req_dept"     , ls_dept             )
	dw_list.SetItem(li_ins, "wiemp"        , ls_empno            )
	dw_list.SetItem(li_ins, "hold_gu"      , ls_gubun            )
	dw_list.SetItem(li_ins, "out_store"    , ls_house            )
	dw_list.SetItem(li_ins, "naougu"       , ls_check            )
	dw_list.SetItem(li_ins, "pjtno"        , ls_proj             )
	dw_list.SetItem(li_ins, "pspec"        , '.'                 )
	
//	If wf_item(lstr_code.code[i], lstr_code.code[i], li_ins) < 0 Then Return
Next
end event

type dw_hidden from datawindow within w_pdt_04010
boolean visible = false
integer x = 1522
integer y = 940
integer width = 2903
integer height = 400
integer taborder = 60
string title = "none"
string dataobject = "d_itmbuy_popup5"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_select from picture within w_pdt_04010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3150
integer y = 24
integer width = 178
integer height = 144
boolean enabled = false
string picturename = "C:\erpman\image\일괄생성_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;//
PictureName = "C:\erpman\image\일괄생성_dn.gif"
end event

event ue_lbuttonup;//
PictureName = "C:\erpman\image\일괄생성_up.gif"
end event

event clicked;// 외주사급출고에 대한 내용으로 변경 LJJ
String ls_gubun, ls_iogbn
integer	k, lrow
String		sopt
string	sStartDate, sEndDate, sDept, sGubun,	&
			sHouse, sCheck, sProject, sRelcod, sNaougu, sEmpno 
				
ls_gubun = dw_detail.GetItemString(1, "gubun")
// 외주출고 에 대한 출고구분을 검색 (외주사급출고는 1개이어야 한다).
// 외주사급 및 창고 이동
Select iogbn into :ls_iogbn from iomatrix
 where sabu = :gs_sabu and autvnd = 'Y';

If	ls_gubun = ls_iogbn or ls_gubun = 'O05' then                  
	p_addrow.TriggerEvent(Clicked!)
	if is_Return = 'N' then return
		sDept   = dw_detail.GetItemString(1, "dept")
		Setnull(gs_code)
		openwithParm(w_pdt_04010_1, sdept)
		if	gs_code	<> ""	and not isNull(gs_code) then
			IF	dw_list.Retrieve(gs_sabu, gs_code+'%') <	1		THEN
				messagebox("확인","해당자료가 없습니다.")
			return
		end if			
	End If
Else	
	is_batch 	= 'Y'
	p_addrow.TriggerEvent(Clicked!)
	if	is_return = 'N'	then Return -1 
	
	SetNull(gs_code)
	open(w_itmbuy_popup5)
	if Isnull(gs_code) or Trim(gs_code) = "" then
		is_batch 	= 'N'
		return
	End If
	
	sStartDate 	= TRIM(dw_detail.GetItemString(1, "sdate"))
	sEndDate 	= TRIM(dw_detail.GetItemString(1, "edate"))
	sDept 			= dw_detail.GetItemString(1, "dept")
	sGubun 		= dw_detail.GetItemString(1, "gubun")
	sHouse   		= dw_detail.GetItemString(1, "house")
	sEmpno   	= dw_detail.GetItemString(1, "empno")
	sCheck   		= dw_detail.GetItemString(1, "check")
	sProject 		= dw_detail.GetItemString(1, "project")
	
	
	SetPointer(HourGlass!)
	
	dw_hidden.reset()
	dw_hidden.ImportClipboard()
	//
	
	FOR k=1 TO dw_hidden.rowcount()
		sopt = dw_hidden.getitemstring(k, 'opt')
		if sopt  = 'Y' then 
			lRow  = dw_list.insertrow(0)
			dw_list.setitem(lRow, 'itnbr'       , dw_hidden.getitemstring(k, 'itnbr' ))
			dw_list.setitem(lRow, 'itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
			dw_list.setitem(lRow, 'ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
	
			dw_list.SetItem(lRow, "sabu",     	gs_sabu)
			dw_list.SetItem(lRow, "hold_date", sStartDate)
			dw_list.SetItem(lRow, "rqdat", 	  	sEndDate)
			dw_list.SetItem(lRow, "req_dept",  	sDept)
			dw_list.SetItem(lRow, "wiemp",     	sEmpno)
			dw_list.SetItem(lRow, "hold_gu",   	sGubun)
			dw_list.SetItem(lRow, "out_store", 	sHouse)
			dw_list.SetItem(lRow, "naougu",  	sCheck)
			dw_list.SetItem(lRow, "pjtno",	  	sProject)
			dw_list.SetItem(lRow, "pspec",	  	'.')
		end if	
	NEXT
	dw_hidden.reset()
	dw_list.ScrollToRow(lRow)
	dw_list.setrow(lRow)
	dw_list.SetColumn("hold_qty")
	dw_list.SetFocus()
End If
end event

type p_jago from uo_picture within w_pdt_04010
integer x = 41
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\재고조회_up.gif"
end type

event clicked;call super::clicked;long lRow

if dw_list.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('확 인', '조회할 자료를 선택하세요!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')
IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[품번]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF
gs_gubun = dw_list.getitemstring(lRow, 'out_store')

// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
gs_codename = 'N' 
open(w_stock_popup)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\재고조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\재고조회_up.gif'
end event

type p_mod from uo_picture within w_pdt_04010
integer x = 3538
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sJpno
long  	dSeq
//////////////////////////////////////////////////////////////////////////////////
//		1. 수량 = 0		-> RETURN
//		2. 전표채번구분('B0')
//////////////////////////////////////////////////////////////////////////////////
IF	wf_CheckRequiredField() = -1		THEN		RETURN

if wf_dup_chk() = -1 then return 

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_update(sdate, dseq) = -1 THEN 
		Messagebox("확 인", "저장을 실패하였습니다. [전표채번 실패]")
		RETURN 
	END IF

END IF

IF len(dw_list.GetitemString(dw_list.RowCount(), "hold_no")) < 15 then 
	Messagebox("확 인", "저장을 실패하였습니다. [할당번호 확인]")
	RETURN 
END IF
	
////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN

	COMMIT;

	IF ic_status = '1'	THEN
		MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
											 "~r~r생성되었습니다.")
	
		if cbx_print.checked then
			
			dw_detail.AcceptText()
			sjpno  = trim(dw_detail.GetItemstring(1, "jpno"))				
			
			String  ls_saupj
			ls_saupj = dw_detail.GetItemString(1, 'saupj')
			If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj
			
			if dw_req.retrieve(gs_sabu, '.', 'ZZZZZZZZ', '.','ZZZZZZ',sjpno, sjpno+'999', ls_saupj) > 0 then
				dw_req.print()
			end if	
		end if
	END IF
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_del from uo_picture within w_pdt_04010
integer x = 3712
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Long nCnt

w_mdi_frame.sle_msg.text =""
//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)

ncnt = wf_Delete()
IF ncnt = -1 THEN	RETURN

If nCnt = 0 Then
	MessageBox('확인','삭제된 건이 없습니다.!!')
	Return
Else
	//////////////////////////////////////////////
	IF dw_list.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF
End If

p_can.TriggerEvent("clicked")
	
SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_inq from uo_picture within w_pdt_04010
integer x = 3365
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno   	= dw_detail.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[의뢰번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("확인","해당자료가 없습니다.")
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if
//////////////////////////////////////////////////////////////////////////
// 최종의뢰번호
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "hold_no")

dw_detail.enabled = false

p_del.enabled = true
p_del.picturename = "C:\erpman\image\삭제_up.gif" 

dw_list.SetColumn("itnbr")
dw_list.SetFocus()
//cb_save.enabled = true

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_can from uo_picture within w_pdt_04010
integer x = 4233
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_pdt_04010
integer x = 4407
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_copy from uo_picture within w_pdt_04010
boolean visible = false
integer x = 229
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
dw_detail.SetItem(1, "sdate", is_Date)
dw_detail.SetItem(1, "edate", is_Date)

wf_copy()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_addrow from uo_picture within w_pdt_04010
integer x = 3886
integer y = 24
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF dw_detail.AcceptText() = -1	THEN	RETURN -1

//////////////////////////////////////////////////////////
string	sStartDate, sEndDate, sDept, sGubun,	&
			sHouse, sCheck, sProject, sRelcod, sNaougu, sEmpno 
long		lRow
String   svendor, svendorname, sopseq

IF dw_detail.AcceptText() <> 1	THEN	RETURN

sStartDate = TRIM(dw_detail.GetItemString(1, "sdate"))
sEndDate = TRIM(dw_detail.GetItemString(1, "edate"))
sDept 		= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")
sHouse   = dw_detail.GetItemString(1, "house")
sEmpno   = dw_detail.GetItemString(1, "empno")
sCheck   = dw_detail.GetItemString(1, "check")
sProject = dw_detail.GetItemString(1, "project")

svendor			= dw_instore.getitemstring(1, 'vendor')
svendorname		= dw_instore.getitemstring(1, 'vendorname')
sopseq			= dw_instore.getitemstring(1, 'opseq')

SetNull(is_return)
// 출고요청일
IF isnull(sStartDate) or sStartDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF

// 출고요청일
IF isnull(sEndDate) or sEndDate = "" 	THEN
	f_message_chk(30,'[출고요청일]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 출고창고
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[출고창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF

// 요청자
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[요청자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[요청부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청구분
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[요청구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
END IF
// 요청구분에 대한 관련처코드
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu into :sRelcod, :sNaougu from iomatrix 
 where sabu = :gs_sabu and iogbn = :sGubun;
if  isnull(sNaougu) or trim(sNaougu) = '' or &
	(sNaougu <> '1' and sNaougu <> '2') then
	f_message_chk(208,'[출고,출문구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[입고처]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	is_return	= 'N'
	RETURN -1
end if

if	is_batch	= 'Y'	then Return 0

///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

dw_list.SetItem(lRow, "sabu",     gs_sabu)
dw_list.SetItem(lRow, "hold_date", sStartDate)
dw_list.SetItem(lRow, "rqdat", 	  sEndDate)
dw_list.SetItem(lRow, "req_dept",  sDept)
dw_list.SetItem(lRow, "wiemp",     sEmpno)
dw_list.SetItem(lRow, "hold_gu",   sGubun)
dw_list.SetItem(lRow, "out_store", sHouse)
dw_list.SetItem(lRow, "naougu",	  sCheck)
dw_list.SetItem(lRow, "pjtno",	  sProject)
dw_list.SetItem(lRow, "pspec",	  '.')

dw_list.SetItem(lRow, "in_store",	  svendor)
dw_list.SetItem(lRow, "vndmst_cvnas2",	  svendorname)
dw_list.SetItem(lRow, "hyebia2",	  sopseq)

// 자료가 한건이라도 있으면 HEAD사항은 수정할 수 없음
dw_detail.enabled = False

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()

setNull(is_batch)

return 0
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_delrow from uo_picture within w_pdt_04010
integer x = 4059
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

if dw_list.getitemdecimal(lrow, "isqty") > 0 then
	f_message_chk(301, '[출고의뢰]')
	return
end if

IF f_msg_delete() = -1 THEN	RETURN
	
////////////////////////////////////////////////////////
//string	sGubun
//
//sGubun = dw_list.GetItemString(lRow, "blynd")
//
//IF sGubun <> '1'	THEN
//	MessageBox("확인", "검토완료된 자료는 삭제할 수 없습니다.")
//	RETURN 
//END IF

// 자료가 없으면 HEAD사항을 수정할 수 없음
dw_list.DeleteRow(lRow)

if dw_list.rowcount() < 1 then
	dw_detail.enabled = true
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type cb_1 from commandbutton within w_pdt_04010
boolean visible = false
integer x = 2345
integer y = 2400
integer width = 366
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고조회"
end type

event clicked;long lRow

if dw_list.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('확 인', '조회할 자료를 선택하세요!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')
IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[품번]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF
gs_gubun = dw_list.getitemstring(lRow, 'out_store')

// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
gs_codename = 'N' 
open(w_stock_popup)
end event

type cb_copy from commandbutton within w_pdt_04010
boolean visible = false
integer x = 1147
integer y = 2400
integer width = 361
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "복사(&B)"
end type

event clicked;dw_detail.SetItem(1, "sdate", is_Date)
dw_detail.SetItem(1, "edate", is_Date)

wf_copy()
end event

type dw_copy from datawindow within w_pdt_04010
boolean visible = false
integer x = 1819
integer y = 2680
integer width = 494
integer height = 360
string dataobject = "d_pdt_04010"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_req from datawindow within w_pdt_04010
boolean visible = false
integer x = 663
integer y = 2692
integer width = 494
integer height = 360
integer taborder = 70
string dataobject = "d_mat_03560_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_print from checkbox within w_pdt_04010
integer x = 4247
integer y = 392
integer width = 366
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "의뢰서출력"
end type

type dw_1 from datawindow within w_pdt_04010
boolean visible = false
integer x = 50
integer y = 2136
integer width = 4521
integer height = 152
string dataobject = "d_pdt_04012"
boolean border = false
boolean livescroll = true
end type

type cb_delete from commandbutton within w_pdt_04010
boolean visible = false
integer x = 773
integer y = 2400
integer width = 361
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

SetPointer(HourGlass!)

IF wf_Delete() = -1		THEN	RETURN

//////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

cb_cancel.TriggerEvent("clicked")
	
SetPointer(Arrow!)

end event

type cb_cancel from commandbutton within w_pdt_04010
boolean visible = false
integer x = 2793
integer y = 2400
integer width = 347
integer height = 108
integer taborder = 110
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

type cb_del from commandbutton within w_pdt_04010
boolean visible = false
integer x = 1966
integer y = 2400
integer width = 366
integer height = 108
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행삭제(&L)"
end type

event clicked;
long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

if dw_list.getitemdecimal(lrow, "isqty") > 0 then
	f_message_chk(301, '[출고의뢰]')
	return
end if

IF f_msg_delete() = -1 THEN	RETURN
	
////////////////////////////////////////////////////////
//string	sGubun
//
//sGubun = dw_list.GetItemString(lRow, "blynd")
//
//IF sGubun <> '1'	THEN
//	MessageBox("확인", "검토완료된 자료는 삭제할 수 없습니다.")
//	RETURN 
//END IF

// 자료가 없으면 HEAD사항을 수정할 수 없음
dw_list.DeleteRow(lRow)

if dw_list.rowcount() < 1 then
	dw_detail.enabled = true
end if


end event

type cb_insert from commandbutton within w_pdt_04010
boolean visible = false
integer x = 1586
integer y = 2400
integer width = 366
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행추가(&I)"
end type

event clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sStartDate, sEndDate, sDept, sGubun,	&
			sHouse, sCheck, sProject, sRelcod, sNaougu, sEmpno 
long		lRow

sStartDate = TRIM(dw_detail.GetItemString(1, "sdate"))
sEndDate = TRIM(dw_detail.GetItemString(1, "edate"))
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")
sHouse   = dw_detail.GetItemString(1, "house")
sEmpno   = dw_detail.GetItemString(1, "empno")
sCheck   = dw_detail.GetItemString(1, "check")
sProject = dw_detail.GetItemString(1, "project")

// 출고요청일
IF isnull(sStartDate) or sStartDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 출고요청일
IF isnull(sEndDate) or sEndDate = "" 	THEN
	f_message_chk(30,'[출고요청일]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF
// 출고창고
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[출고창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN
END IF

// 요청자
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[요청자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF
// 요청부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[요청부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF
// 요청구분
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[요청구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF
// 요청구분에 대한 관련처코드
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu into :sRelcod, :sNaougu from iomatrix 
 where sabu = :gs_sabu and iogbn = :sGubun;
if  isnull(sNaougu) or trim(sNaougu) = '' or &
	(sNaougu <> '1' and sNaougu <> '2') then
	f_message_chk(208,'[출고,출문구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[입고처]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if
///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

dw_list.SetItem(lRow, "sabu",     gs_sabu)
dw_list.SetItem(lRow, "hold_date", sStartDate)
dw_list.SetItem(lRow, "rqdat", 	  sEndDate)
dw_list.SetItem(lRow, "req_dept",  sDept)
dw_list.SetItem(lRow, "wiemp",     sEmpno)
dw_list.SetItem(lRow, "hold_gu",   sGubun)
dw_list.SetItem(lRow, "out_store", sHouse)
dw_list.SetItem(lRow, "naougu",	  sCheck)
dw_list.SetItem(lRow, "pjtno",	  sProject)
dw_list.SetItem(lRow, "pspec",	  '.')

// 자료가 한건이라도 있으면 HEAD사항은 수정할 수 없음
dw_detail.enabled = False

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

type rb_delete from radiobutton within w_pdt_04010
integer x = 4283
integer y = 288
integer width = 251
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ic_status = '2'

ic_yn = 'N'
dw_list.DataObject = 'd_pdt_04010'

//dw_list.Modify("ispec_t.text = '" + is_ispec + "'" )
//dw_list.Modify("jijil_t.text = '" + is_jijil + "'" )

wf_Initial()

end event

type rb_insert from radiobutton within w_pdt_04010
integer x = 4283
integer y = 212
integer width = 251
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;
ic_status = '1'	// 등록
ic_yn = 'N'
dw_list.DataObject = 'd_pdt_04010'

//dw_list.Modify("ispec_t.text = '" + is_ispec + "'" )
//dw_list.Modify("jijil_t.text = '" + is_jijil + "'" )

wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 188
integer width = 4165
integer height = 264
integer taborder = 10
string dataobject = "d_pdt_04011"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;string		sDept, ls_gubun, ls_iogbn


IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ElseIf 	keydown(keyF3!) then
	ls_gubun = dw_detail.GetItemString(1, "gubun")
	// 외주출고 에 대한 출고구분을 검색 (외주사급출고는 1개이어야 한다).
	// 외주사급 및 창고 이동
	Select iogbn into :ls_iogbn from iomatrix
	 where sabu = :gs_sabu and autvnd = 'Y';
	
	If	ls_gubun = ls_iogbn or ls_gubun = 'O05' then                  
		p_addrow.TriggerEvent(Clicked!)
		if is_Return = 'N' then return
		sDept   = dw_detail.GetItemString(1, "dept")
		Setnull(gs_code)
		openwithParm(w_pdt_04010_1, sdept)
		if	gs_code	<> ""	and not isNull(gs_code) then
			IF	dw_list.Retrieve(gs_sabu, gs_code+'%') <	1		THEN
				messagebox("확인","해당자료가 없습니다.")
				return
			end if			
		End If
	End If
END IF
end event

event itemchanged;string	sDate,  sDate2, sDept, sName, sProject,	&
			sGubun, sHouse, sCheck, sNull, sRelcod, sNaougu, sEmpno, sEmpnm, sTagbn
string   scode, sname1, sname2, get_dept, get_deptnm, sOwner
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[출고요청일]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
//	IF is_Date > sDate	THEN
//		MessageBox("확인", "출고요청일은 현재일자보다 클 수 없습니다.")
//		this.setitem(1, "edate", is_Date)
//		return 1
//	END IF
ELSEIF this.GetColumnName() = 'empno' THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empnm', sNull)
		this.setitem(1, 'dept', sNull)
		this.setitem(1, 'deptname', sNull)
      return 
   end if
   ireturn = f_get_name2('사번', 'Y', scode, sname1, shouse)    //1이면 실패, 0이 성공	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empnm', sname1)
	IF ireturn <> 1	THEN
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :get_dept, :get_deptnm  
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', get_dept)
		this.setitem(1, 'deptname', get_deptnm)
	END IF
   return ireturn 
ELSEIF this.GetColumnName() = 'dept' THEN

	scode = this.GetText()								
	
   ireturn = f_get_name2('부서', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'dept', scode)
	this.setitem(1, 'deptname', sname1)
   return ireturn 
	
ELSEif this.getcolumnname() = 'gubun' then
	sGubun = gettext()
	// 요청구분에 대한 관련처코드
	Setnull(sRelcod)
	Setnull(sNaougu)
	select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
	 where sabu = :gs_sabu and iogbn = :sGubun;

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		dw_list.DataObject = 'd_pdt_04013'
//		dw_list.object.tispec_t.text = '타계정 ' + is_ispec
//		dw_list.object.tjijil_t.text = '타계정 ' + is_jijil
	ELSE
		ic_yn = 'N'
		dw_list.DataObject = 'd_pdt_04010'
	END IF
	dw_list.SetTransObject(sqlca)

//	dw_list.object.ispec_t.text = is_ispec
//	dw_list.object.jijil_t.text = is_jijil

	if  isnull(sNaougu) or trim(sNaougu) = '' or &
		(sNaougu <> '1' and sNaougu <> '2') then
		f_message_chk(208,'[출고,출문구분]')
		dw_detail.SetColumn("gubun")
		dw_detail.SetFocus()
		RETURN 1
	end if 
	if isnull(sRelcod) or trim(sRelcod) = '' then
		f_message_chk(208,'[입고처]')
		dw_detail.SetColumn("gubun")
		dw_detail.SetFocus()
		RETURN 1
	end if	
	
	this.setitem(1, "check", sNaougu)

ELSEIF this.getcolumnname() = "jpno"	then

	string	sJpno
	sJpno = this.gettext() 
	
	  SELECT A.HOLD_DATE,   A.RQDAT,   A.REQ_DEPT,   A.HOLD_GU,   A.OUT_STORE, 
				A.NAOUGU, 		A.PJTNO,   B.CVNAS2,     A.WIEMP,    D.EMPNAME  
		 INTO :sDate,   		:sDate2,   :sDept,       :sGubun,     :sHouse, 
				:sCheck,    	:sProject, :sName,       :sEmpno,     :sEmpnm   
		 FROM HOLDSTOCK A, VNDMST B, IOMATRIX C, P1_MASTER D  
		WHERE ( A.SABU     = :gs_sabu )	 AND  ( A.HOLD_NO   like :sJpno||'%' )	AND
				( A.REQ_DEPT = B.CVCOD(+) ) AND  ( A.WIEMP   = D.EMPNO(+) ) 	AND			
				( A.SABU  = C.SABU )        AND  ( A.HOLD_GU  = C.IOGBN )    AND  
				( A.PORDNO   IS NULL )      AND  ( C.JNPCRT    = '001' )  AND ROWNUM = 1 
	GROUP BY A.HOLD_DATE, A.RQDAT,    A.REQ_DEPT,  A.HOLD_GU,   A.OUT_STORE, 
				A.NAOUGU,    	A.PJTNO,    B.CVNAS2,    A.WIEMP,    D.EMPNAME  ;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰번호]')
		this.setitem(1, "jpno",     sNull)
		this.setitem(1, "sdate",    sNull)
		this.setitem(1, "edate",    sNull)
		this.setitem(1, "dept",     sNull)
		this.setitem(1, "deptname", sNull)
		this.setitem(1, "empno", 	 sNull)
		this.setitem(1, "empnm",    sNull)
		this.setitem(1, "gubun",    sNull)
		this.setitem(1, "house",    sNull)
		this.setitem(1, "check",    sNull)
		this.setitem(1, "project",  sNull)
		return 1
	end if

	this.setitem(1, "sdate",    sDate)	
	this.setitem(1, "edate", 	 sDate2)		
	this.setitem(1, "dept", 	 sDept)	
	this.setitem(1, "deptname", sName)	
	this.setitem(1, "empno", 	 sEmpno)	
	this.setitem(1, "empnm",    sempnm)	
	this.setitem(1, "gubun",    sGubun)	
	this.setitem(1, "house",    sHouse)		
	this.setitem(1, "check",    sCheck)		
	this.setitem(1, "project",  sProject)		
	
	select tagbn into :sTagbn from iomatrix where sabu = :gs_sabu and iogbn = :sGubun; 

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		p_copy.enabled = false
		p_copy.picturename = "C:\erpman\image\복사_d.gif"
		
		dw_list.DataObject = 'd_pdt_04013'
//		dw_list.object.tispec_t.text = '타계정 ' + is_ispec
//		dw_list.object.tjijil_t.text = '타계정 ' + is_jijil
	ELSE
		ic_yn = 'N'
		p_copy.enabled = true
		p_copy.picturename = "C:\erpman\image\복사_up.gif"
		dw_list.DataObject = 'd_pdt_04010'
	END IF
//	dw_list.object.ispec_t.text = is_ispec
//	dw_list.object.jijil_t.text = is_jijil
	dw_list.SetTransObject(sqlca)

	p_inq.TriggerEvent(Clicked!)

ELSEIF this.getcolumnname() = "project"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
	SELECT "VW_PROJECT"."SABU"  
     INTO :sCode
     FROM "VW_PROJECT"  
    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
          ( "VW_PROJECT"."PJTNO" = :sProject )   ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[프로젝트 번호]')
		this.setitem(1, "project", sNull)
	   return 1
	END IF
ElseIf This.GetColumnName() = 'saupj' Then
	String  ls_saupj
	ls_saupj = Trim(This.GetText())
	
	If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Then ls_saupj = '%'
	
	f_child_saupj(This, 'house', ls_saupj)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 부서
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptname",gs_codename)

elseIF this.GetColumnName() = "empno" THEN
   
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
   this.triggerEvent(itemchanged!)	
// 출고의뢰번호
elseif this.getcolumnname() = "jpno" 	then
	
	open(w_haldang_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
   RETURN 1	
elseif this.getcolumnname() = "project" 	then
	gs_gubun = '1'
	open(w_project_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "project", gs_code)
end if


end event

type cb_save from commandbutton within w_pdt_04010
boolean visible = false
integer x = 411
integer y = 2400
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

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sJpno
long  	dSeq
//////////////////////////////////////////////////////////////////////////////////
//		1. 수량 = 0		-> RETURN
//		2. 전표채번구분('B0')
//////////////////////////////////////////////////////////////////////////////////
IF	wf_CheckRequiredField() = -1		THEN		RETURN

if wf_dup_chk() = -1 then return 

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_update(sdate, dseq) = -1 THEN 
		Messagebox("확 인", "저장을 실패하였습니다. [전표채번 실패]")
		RETURN 
	END IF

END IF

IF len(dw_list.GetitemString(dw_list.RowCount(), "hold_no")) < 15 then 
	Messagebox("확 인", "저장을 실패하였습니다. [할당번호 확인]")
	RETURN 
END IF
	
////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN

	COMMIT;

	IF ic_status = '1'	THEN
		MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
											 "~r~r생성되었습니다.")
	
		if cbx_print.checked then
			
			dw_detail.AcceptText()
			sjpno  = trim(dw_detail.GetItemstring(1, "jpno"))				
			
			if dw_req.retrieve(gs_sabu, '.', 'ZZZZZZZZ', '.','ZZZZZZ',sjpno, sjpno+'999') > 0 then
				dw_req.print()
			end if	
		end if
	END IF
ELSE
	ROLLBACK;
	f_Rollback()
END IF

cb_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from commandbutton within w_pdt_04010
event key_in pbm_keydown
boolean visible = false
integer x = 3159
integer y = 2400
integer width = 347
integer height = 108
integer taborder = 120
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

type cb_retrieve from commandbutton within w_pdt_04010
boolean visible = false
integer x = 50
integer y = 2400
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
if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno   	= dw_detail.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[의뢰번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("확인","해당자료가 없습니다.")
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if
//////////////////////////////////////////////////////////////////////////
// 최종의뢰번호
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "hold_no")

dw_detail.enabled = false
cb_delete.enabled = true

dw_list.SetColumn("itnbr")
dw_list.SetFocus()
//cb_save.enabled = true

end event

type dw_list from datawindow within w_pdt_04010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 496
integer width = 4521
integer height = 1704
integer taborder = 20
string dataobject = "d_pdt_04010"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
if key = keyenter! then
	if this.getcolumnname() = "in_store" then
		if this.rowcount() <> this.getrow() then  return
		if accepttext() = 1 then
			cb_insert.triggerevent(clicked!)
			post function wf_focus()
		else
			post function wf_focus1()
		end if
	end if
end if

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sNull, sjijil, sispec_code, sfilsk, sName2
string	sItem, sCode, sName, sSpec, sDate, sHouse, sItemGubun, sIogbn, sPspec, sUnmsr, stagbn
long		lRow, lReturnRow
integer  ireturn
SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'itnbr'	THEN
	
	sItem  = THIS.GETTEXT()								
	sHouse = dw_detail.GetItemString(1, "house")
	sPspec = this.GetItemString(lrow, "pspec")
	
	SELECT "ITEMAS"."ITDSC",
			 "ITEMAS"."ISPEC", 
			 "ITEMAS"."JIJIL",
			 "ITEMAS"."ISPEC_CODE", 
			 "ITEMAS"."ITTYP",  
 			 "ITEMAS"."UNMSR",  
 			 "ITEMAS"."FILSK",
		   FUN_GET_ITMSHT(:gs_saupj, "ITEMAS"."ITNBR") AS ITM_SHTNM
	  INTO :sName, 
	  		 :sSpec,
			 :sjijil, 
	  		 :sIspec_code,
			 :sItemGubun,
			 :sunmsr, :sfilsk, :sName2
	  FROM "ITEMAS"
	 WHERE ( "ITEMAS"."ITNBR" = :sItem )	AND
	 		 ( "ITEMAS"."USEYN" = '0' ) ;                   
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[품번]')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		this.SetItem(lRow, "ITM_SHTNM", snULL)
		RETURN 1
	END IF
	
	IF sfilsk = 'N' then 
		MessageBox('확 인', '재고관리품만 출고의뢰 할 수 있습니다. 품목을 확인하세요!')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		this.SetItem(lRow, "ITM_SHTNM", snULL)
		RETURN 1
	END IF
	
	this.SetItem(lRow, "itdsc", sName)
	this.SetItem(lRow, "ispec", sSpec)
	this.SetItem(lRow, "jijil", sJijil)
	this.SetItem(lRow, "ispec_code", sIspec_code)
	this.SetItem(lRow, "itemas_ittyp",  sItemGubun)
	this.SetItem(lRow, "itemas_unmsr",  sUnmsr)
	this.SetItem(lRow, "ITM_SHTNM", sName2)
	
	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	// 재고 조회
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name3('품명', 'Y', sitEM, sname, sspec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sJijil)	
	this.setitem(lrow, "ispec_code", sIspec_code)
	
	SELECT "ITEMAS"."UNMSR",  
 			 "ITEMAS"."FILSK" 
	  INTO :sunmsr, :sfilsk 
	  FROM "ITEMAS"
	 WHERE ( "ITEMAS"."ITNBR" = :sItem );                  	
	this.SetItem(lRow, "itemas_unmsr",  sUnmsr)	
	
	IF sfilsk = 'N' then 
		MessageBox('확 인', '재고관리품만 출고의뢰 할 수 있습니다. 품목을 확인하세요!')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		RETURN 1
	END IF
	
	// 재고 조회
	sHouse = dw_detail.GetItemString(1, "house")	
	sPspec = this.GetItemString(lrow, "pspec")

	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	// 재고 조회
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name3('규격', 'Y', sitEM, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sJijil)	
	this.setitem(lrow, "ispec_code", sIspec_code)
	
	SELECT "ITEMAS"."UNMSR",  
 			 "ITEMAS"."FILSK" 
	  INTO :sunmsr, :sfilsk 
	  FROM "ITEMAS"
	 WHERE ( "ITEMAS"."ITNBR" = :sItem );                  	

	this.SetItem(lRow, "itemas_unmsr",  sUnmsr)		
	
	IF sfilsk = 'N' then 
		MessageBox('확 인', '재고관리품만 출고의뢰 할 수 있습니다. 품목을 확인하세요!')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		RETURN 1
	END IF
	// 재고 조회
	sHouse = dw_detail.GetItemString(1, "house")	
	sPspec = this.GetItemString(lrow, "pspec")
	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	// 재고 조회
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name3('재질', 'Y', sitEM, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sJijil)	
	this.setitem(lrow, "ispec_code", sIspec_code)
	
	SELECT "ITEMAS"."UNMSR",  
 			 "ITEMAS"."FILSK" 
	  INTO :sunmsr, :sfilsk 
	  FROM "ITEMAS"
	 WHERE ( "ITEMAS"."ITNBR" = :sItem );                  	
	this.SetItem(lRow, "itemas_unmsr",  sUnmsr)		
	
	IF sfilsk = 'N' then 
		MessageBox('확 인', '재고관리품만 출고의뢰 할 수 있습니다. 품목을 확인하세요!')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		RETURN 1
	END IF
	// 재고 조회
	sHouse = dw_detail.GetItemString(1, "house")	
	sPspec = this.GetItemString(lrow, "pspec")
	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	// 재고 조회
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name3('규격코드', 'Y', sitEM, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sJijil)	
	this.setitem(lrow, "ispec_code", sIspec_code)
	
	SELECT "ITEMAS"."UNMSR",  
 			 "ITEMAS"."FILSK" 
	  INTO :sunmsr, :sfilsk 
	  FROM "ITEMAS"
	 WHERE ( "ITEMAS"."ITNBR" = :sItem );                  	

	this.SetItem(lRow, "itemas_unmsr",  sUnmsr)		
	
	IF sfilsk = 'N' then 
		MessageBox('확 인', '재고관리품만 출고의뢰 할 수 있습니다. 품목을 확인하세요!')
		this.setitem(lRow, "itnbr", sNull)	
	   this.SetItem(lRow, "itdsc", sNull)
	   this.SetItem(lRow, "ispec", sNull)
	   this.SetItem(lRow, "jijil", sNull)
	   this.SetItem(lRow, "ispec_code", sNull)
	   this.SetItem(lRow, "itemas_unmsr", snULL)
		RETURN 1
	END IF
	// 재고 조회
	sHouse = dw_detail.GetItemString(1, "house")	
	sPspec = this.GetItemString(lrow, "pspec")
	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	// 재고 조회
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
	
	RETURN ireturn
// 사양 입력시 재고 조회
ELSEIF this.GetColumnName() = "pspec"	THEN
	sPspec = trim(this.GetText())
	
	sHouse = dw_detail.GetItemString(1, "house")	
	sItem  = this.GetItemString(lrow, "itnbr")
	
	IF sPspec = '' or ISNULL(sPspec) THEN sPspec = '.' 
	dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
// 타계정 대체일때 품번/품명/규격
ELSEIF this.GetColumnName() = "ditnbr"	THEN
	sitem = trim(this.GetText())
	ireturn = f_get_name3('품번', 'Y', sitem, sname, sspec, sjijil, sispec_code) 
	this.setitem(lrow, "ditnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "tjijil", sJijil)	
	this.setitem(lrow, "tispec_code", sIspec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name3('품명', 'Y', sitem, sname, sspec, sjijil, sispec_code) 
	this.setitem(lrow, "ditnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "tjijil", sJijil)	
	this.setitem(lrow, "tispec_code", sIspec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name3('규격', 'Y', sitem, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "ditnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "tjijil", sJijil)	
	this.setitem(lrow, "tispec_code", sIspec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "tjijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name3('재질', 'Y', sitem, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "ditnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "tjijil", sJijil)	
	this.setitem(lrow, "tispec_code", sIspec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "tispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name3('규격코드', 'Y', sitem, sname, sspec, sjijil, sispec_code) 
	
	this.setitem(lrow, "ditnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "tjijil", sJijil)	
	this.setitem(lrow, "tispec_code", sIspec_code)
	RETURN ireturn
// 입고처 : 출고(부서,창고), 출문(거래처)
ELSEIF this.GetColumnName() = "in_store" THEN

	string	sCheck, sgbn1, sgbn2, sgbn3, sgbn4, sgbn5
	sIogbn = dw_detail.getitemstring(1, "gubun")
	sHouse = dw_detail.getitemstring(1, "house")
	sCode  = this.GetText()						
   	
	/* 관련처 기준 검색 */
	SELECT RELCOD, TAGBN INTO :SCHECK, :stagbn FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	if sCode = "" or isnull(sCode) then 
		this.setitem(lrow, 'vndmst_cvnas2', snull)
		return 
	end if
	
	if stagbn = 'N' and sCode = sHouse then 
		messagebox("확 인", "출고창고와 입고처가 같을 수가 없습니다.", StopSign!) 
		this.setitem(lrow, 'in_store', snull)
		this.setitem(lrow, 'vndmst_cvnas2', snull)
		return 1
   end if	
	
	/* 코드 중복 
	If sCode = dw_detail.getitemstring(1, "house") then
		f_message_chk(209, '[입고예정]')
		this.setitem(lrow, "in_store", sNull)
		this.setitem(lRow, 'vndmst_cvnas2', sNull)				
		return 1
	end if	*/

	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck
			 case '1'
					sgbn1 = '5'; sgbn2 = '5'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '2'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '4'; sgbn4 = '4'; sgbn5 = '4'
			 case '3'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '9'; sgbn4 = '9'; sgbn5 = '9'
			 case '4'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '5'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '4'; sgbn4 = '5'; sgbn5 = '9'
			 case else
					f_message_chk(208,'[입고처]')
					this.setitem(lrow, "in_store", sNull)
					this.setitem(lRow, 'vndmst_cvnas2', sNull)		
				   return 1
	End choose

	SELECT "CVNAS"
	  INTO :sName
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sCode  AND "CVSTATUS" <> '2' AND 
			 "CVGU"  IN (:sgbn1, :sgbn2, :sgbn3, :sgbn4, :sgbn5) ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[거래처코드]')
		this.setitem(lrow, "in_store", sNull)
		this.setitem(lRow, 'vndmst_cvnas2', sNull)		
	   return 1
	ELSE
		this.setitem(lRow, 'vndmst_cvnas2', sName)
	END IF
ELSEIF this.GetColumnName() = 'rqdat' THEN

	sDate = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "rqdat", sNull)
		return 1
	END IF
// 출고요청수량 : 요청수량 > 재고 -> ERROR (제품일 경우)
ELSEIF this.GetColumnName() = 'hold_qty'	THEN
	dec{3} dOutQty, dStock, dOld_qty

	dOutQty  = dec(this.GetText())
	dold_Qty = this.GetItemDecimal(lRow, 'old_hold_qty')
	
	IF dOutQty = 0 or isnull(dOutQty) then return 
	IF isnull(dOutQty) then dold_Qty = 0  
		
	IF dw_1.RowCount() > 0	THEN	
		dStock = dw_1.GetItemDecimal(1, "valid_qty")
	ELSE
		dStock = 0 
	END IF
	
	sHouse = dw_detail.GetItemString(1, "house")	
	
	// 가용재고 허용여부 창고별로 조회 
   SELECT REWAPUNISH INTO :sName FROM VNDMST WHERE CVCOD = :sHouse ;
	
	IF sName = 'N' THEN 
		IF dStock + dold_qty - dOutqty < 0		THEN
			MessageBox("확인", "출고창고가 가용재고를 허용하지 않습니다. 출고요청수량을 확인하세요!.")
			this.SetItem(lRow, "hold_qty", dOld_qty)
			RETURN 1
		END IF
	END IF
	
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


w_mdi_frame.sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
String sHouse, sTagbn

lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = 'ditnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"ditnbr",gs_code)
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = 'in_store'	THEN

	string	sCheck, sIogbn
	sIogbn = dw_detail.getitemstring(1, "gubun")

	/* 관련처 기준 검색 */
	SELECT RELCOD , TAGBN INTO :SCHECK, :stagbn FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
					open(w_vndmst_popup)
	End choose


	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	sHouse = dw_detail.GetItemString(1,'house')
	IF sTagbn = 'N' and sHouse =  gs_code	THEN
		MessageBox('확인','출고요청창고와 입고창고는 동일할 수 없습니다.!!')
		this.setitem(lRow, "in_store", '')
	   return 1
	END IF
	
	SetItem(lRow,"in_store",gs_code)
	SetItem(lRow,"vndmst_cvnas2",gs_codename)
	this.TriggerEvent("itemchanged")
END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )

IF currentrow < 1	THEN	RETURN
	
string	sItem, sHouse, sPspec
sItem  = this.GetItemString(currentrow, "itnbr")
sPspec = this.GetItemString(currentrow, "pspec")
sHouse = this.GetItemString(currentrow, "out_store")

dw_1.Retrieve(gs_sabu, sItem, sHouse, sPspec)
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

type rr_1 from roundrectangle within w_pdt_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4256
integer y = 184
integer width = 311
integer height = 184
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 184
integer width = 4192
integer height = 284
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pdt_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 488
integer width = 4544
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_pdt_04010
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 2124
integer width = 4553
integer height = 176
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_instore from datawindow within w_pdt_04010
integer x = 2830
integer y = 204
integer width = 1367
integer height = 152
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_04011_2"
boolean border = false
end type

event rbuttondown;IF this.GetColumnName() = 'vendor'	THEN
   gs_gubun = '5'
	gs_code = ''
	gs_codename = ''
	
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	this.SetItem(1, "vendor", gs_code)
	this.SetItem(1, "vendorname", gs_codename)
	this.TriggerEvent("itemchanged")	
End If
end event

event itemchanged;String ls_cvcod, ls_cvnas2, shouse, tagbn, SIOGBN, SCHECK, stagbn
Long i

If this.getcolumnname() = "vendor"	then
	ls_cvcod = trim(this.gettext())
	
	if ls_cvcod = '' or isnull(ls_cvcod) then return 
	
	SELECT CVNAS2
     INTO :ls_cvnas2
     FROM "VNDMST"  
    WHERE cvcod  = :ls_cvcod;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[입고처 코드]')
		this.setitem(1, "vendor", '')
	   return 1
	END IF
	
	sIogbn = dw_detail.getitemstring(1, "gubun")
	sHouse = dw_detail.getitemstring(1, "house")
   	
	/* 관련처 기준 검색 */
	SELECT RELCOD, TAGBN INTO :SCHECK, :stagbn FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	
	IF stagbn= 'N' and sHouse =  ls_cvcod	THEN
		MessageBox('확인','출고요청창고와 입고창고는 동일할 수 없습니다.!!')
		this.setitem(1, "vendor", '')
	   return 1
	END IF
	
	this.setitem(1, "vendorname", ls_cvnas2)

	For i = 1 to dw_list.RowCount()
		dw_list.SetItem( i, 'in_store', ls_cvcod )
		dw_list.SetItem( i, 'vndmst_cvnas2', ls_cvnas2 )
	Next

END IF

/* 입고장소 */
If this.getcolumnname() = "opseq"	then
	ls_cvcod = trim(this.gettext())

	For i = 1 to dw_list.RowCount()
		dw_list.SetItem( i, 'hyebia2', ls_cvcod )
	Next
END IF
end event

