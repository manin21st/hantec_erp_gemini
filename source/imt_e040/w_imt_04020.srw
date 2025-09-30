$PBExportHeader$w_imt_04020.srw
$PBExportComments$구매/외주 입고마감-거래처
forward
global type w_imt_04020 from window
end type
type dw_gamagam from datawindow within w_imt_04020
end type
type pb_2 from u_pb_cal within w_imt_04020
end type
type pb_1 from u_pb_cal within w_imt_04020
end type
type p_exit from uo_picture within w_imt_04020
end type
type p_can from uo_picture within w_imt_04020
end type
type p_del from uo_picture within w_imt_04020
end type
type p_mod from uo_picture within w_imt_04020
end type
type p_delrow from uo_picture within w_imt_04020
end type
type p_inq from uo_picture within w_imt_04020
end type
type st_2 from statictext within w_imt_04020
end type
type cb_all_del from commandbutton within w_imt_04020
end type
type cb_delete from commandbutton within w_imt_04020
end type
type rb_3 from radiobutton within w_imt_04020
end type
type dw_hist from datawindow within w_imt_04020
end type
type dw_detail from datawindow within w_imt_04020
end type
type rb_1 from radiobutton within w_imt_04020
end type
type cb_cancel from commandbutton within w_imt_04020
end type
type cb_retrieve from commandbutton within w_imt_04020
end type
type cb_exit from commandbutton within w_imt_04020
end type
type cb_save from commandbutton within w_imt_04020
end type
type rr_1 from roundrectangle within w_imt_04020
end type
type rr_2 from roundrectangle within w_imt_04020
end type
type rr_3 from roundrectangle within w_imt_04020
end type
end forward

shared variables

end variables

global type w_imt_04020 from window
integer width = 4731
integer height = 2440
boolean titlebar = true
string title = "구매/외주 입고 마감 - 거래처"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_gamagam dw_gamagam
pb_2 pb_2
pb_1 pb_1
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_delrow p_delrow
p_inq p_inq
st_2 st_2
cb_all_del cb_all_del
cb_delete cb_delete
rb_3 rb_3
dw_hist dw_hist
dw_detail dw_detail
rb_1 rb_1
cb_cancel cb_cancel
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_imt_04020 w_imt_04020

type variables
char  ic_status
string is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_magubn					// mro여부
end variables

forward prototypes
public function integer wf_initial ()
end prototypes

public function integer wf_initial ();string snull, syymm, ssaupj 
long   get_seq

setnull(snull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_hist.reset()

f_child_saupj(dw_detail,'empno',gs_saupj)

p_inq.enabled = true
p_mod.enabled = false
p_delrow.enabled = false
p_del.enabled = false

p_mod.picturename = "C:\erpman\image\저장_d.gif"
p_delrow.picturename = "C:\erpman\image\행삭제_d.gif"
p_del.picturename = "C:\erpman\image\삭제_d.gif"

dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////
/* User별 사업장 Setting */
f_mod_saupj(dw_detail,'saupj')

IF ic_status = '1'	then

	p_inq.picturename = "C:\erpman\image\생성_up.gif"

	// 등록시
	dw_detail.setcolumn("magbn")
	
	dw_detail.SetItem(1, "yyyymm", left(is_date,6))
	dw_detail.SetItem(1, "sdate",  left(is_date,4) + '0101')
	dw_detail.SetItem(1, "edate", is_Date)
	dw_detail.SetItem(1, "seq",    0)	
	dw_detail.setitem(1, "gubun", '2')
ELSE
	p_inq.picturename = "C:\erpman\image\조회_up.gif"

	// 수정시

	dw_detail.setcolumn("magbn")
	
	syymm = left(is_date, 6) 
	
   SELECT MAX(MAYYSQ)  
	  INTO :get_seq
     FROM MAHIST  
    WHERE SABU = :gs_sabu AND MAYYMM = :syymm AND MAGUBN = '2'  ;
	
//   SELECT SAUPJ
//	  INTO :ssaupj
//     FROM MAHIST  
//    WHERE SABU = :gs_sabu AND MAYYMM = :syymm AND MAYYSQ = :get_seq  ;
//	
	dw_detail.SetItem(1, "yyyymm", syymm)
	dw_detail.SetItem(1, "seq",    get_seq)
//	dw_detail.SetItem(1, "saupj",  ssaupj)
	dw_detail.SetItem(1, "sdate",  snull)
	dw_detail.SetItem(1, "edate",  snull)
	dw_detail.setitem(1, "gubun",  '1')
END IF

// MRO 부서인 경우 설정
dw_detail.SetItem(1, 'magbn', is_magubn)
If is_magubn = 'Z' Then
	dw_detail.Object.magbn.protect = 1
Else
	dw_detail.Object.magbn.protect = 0
End If

dw_detail.setfocus()

dw_detail.setredraw(true)

Return  1


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
/////////////////////////////////////////////////////////////////////////////
// MRO 관리부서 여부
Int nCnt
select count(*) into :ncnt from vndmst a
 where a.cvgu = '5' and a.soguan = 'Z' and a.ipjogun = :gs_saupj 
   and a.deptcode = ( select b.deptcode from p1_master b where b.empno = :gs_empno);
If nCnt > 0 Then
	is_magubn = 'Z'	// Mro
else
	is_magubn = '9'	// 구매
End If

f_child_saupj(dw_detail,'empno',gs_saupj)
dw_detail.settransobject(sqlca)
dw_hist.settransobject(sqlca)
//dw_hist.SetRowFocusIndicator(Hand!)

is_Date = f_Today()


p_can.TriggerEvent("clicked")
end event

on w_imt_04020.create
this.dw_gamagam=create dw_gamagam
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_delrow=create p_delrow
this.p_inq=create p_inq
this.st_2=create st_2
this.cb_all_del=create cb_all_del
this.cb_delete=create cb_delete
this.rb_3=create rb_3
this.dw_hist=create dw_hist
this.dw_detail=create dw_detail
this.rb_1=create rb_1
this.cb_cancel=create cb_cancel
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.dw_gamagam,&
this.pb_2,&
this.pb_1,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_delrow,&
this.p_inq,&
this.st_2,&
this.cb_all_del,&
this.cb_delete,&
this.rb_3,&
this.dw_hist,&
this.dw_detail,&
this.rb_1,&
this.cb_cancel,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_imt_04020.destroy
destroy(this.dw_gamagam)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_delrow)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.cb_all_del)
destroy(this.cb_delete)
destroy(this.rb_3)
destroy(this.dw_hist)
destroy(this.dw_detail)
destroy(this.rb_1)
destroy(this.cb_cancel)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event closequery;
string s_frday, s_frtime

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

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
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

type dw_gamagam from datawindow within w_imt_04020
boolean visible = false
integer x = 4727
integer y = 312
integer width = 686
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_imt_04020_1"
boolean border = false
boolean livescroll = true
end type

type pb_2 from u_pb_cal within w_imt_04020
integer x = 2592
integer y = 32
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'edate', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04020
integer x = 2144
integer y = 32
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type p_exit from uo_picture within w_imt_04020
integer x = 4398
integer y = 20
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN
rollback;
close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_imt_04020
integer x = 4224
integer y = 20
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Rollback;
rb_1.checked = true

rb_1.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_imt_04020
integer x = 4050
integer y = 20
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
Long lrow, lcnt
String sMayymm, sCvcod
Integer iseq

if dw_detail.AcceptText() = -1 then return 
SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

sMayymm 	= trim(dw_detail.getitemstring(1, "yyyymm"))
iSeq 		= dw_detail.getitemNumber(1, "seq")

String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	f_message_chk(30, '[사업장]')
	dw_detail.SetColumn('saupj')
	dw_detail.SetFocus()
	Return
End If

If Messagebox("삭제확인", left(sMayymm, 4) + '년 ' + mid(sMayymm, 5, 2) + '월 ' + &
    string(iseq) + "차 마감내역 전체를 삭제 하시겠읍니까?", question!, yesno!, 2) = 2 then
	return
end if

SetPointer(HourGlass!)

dw_hist.SetRedraw(false)	

lcnt 		= dw_hist.rowcount()

For lrow = lcnt to 1 step -1
	dw_hist.deleterow(lrow)  
Next 

if dw_hist.update() = 1 then
	/* 전표이력 Clear */
	Update imhist
		Set mayymm = Null,
			 mayysq = 0
	 where sabu = :gs_sabu and saupj = :ls_saupj and mayymm = :sMayymm and mayysq = :iSeq ;
	 
	if sqlca.sqlcode < 0 then
		rollback;
		f_rollback()
		cb_cancel.TriggerEvent("clicked")			
		dw_hist.SetRedraw(true)	
		return		
	end if
	
	commit;
else
	rollback;
	f_rollback()
end if

p_can.TriggerEvent("clicked")
dw_hist.SetRedraw(true)	


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_imt_04020
integer x = 3703
integer y = 20
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

if dw_hist.update() = 1 then
	commit;
	
	String ls_ym, ls_sdat, ls_edat
	ls_ym   = dw_detail.GetItemString(dw_detail.Getrow(), 'yyyymm')
	ls_sdat = dw_detail.GetItemString(dw_detail.Getrow(), 'sdate' )
	ls_edat = dw_detail.GetItemString(dw_detail.Getrow(), 'edate' )
	
	dw_hist.ReSet()
	dw_detail.ReSet()
	
	dw_detail.InsertRow(0)
	
	f_mod_saupj(dw_detail,'saupj')
	
	dw_detail.SetItem(1, 'yyyymm', ls_ym  )
	dw_detail.SetItem(1, 'sdate' , ls_sdat)
	dw_detail.SetItem(1, 'edate' , ls_edat)
	dw_detail.SetItem(1, 'seq'   , 0      )
	dw_detail.SetItem(1, 'gubun' , '2'    )
	
	dw_detail.enabled = true
	p_inq.Enabled = true
	p_inq.picturename = "C:\erpman\image\생성_up.gif"
	
else
	rollback;
	f_rollback()
	p_can.TriggerEvent("clicked")
end if

SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_delrow from uo_picture within w_imt_04020
integer x = 3877
integer y = 20
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
Long lrow, lcnt
String sMayymm, sCvcod, sDelgu
Integer iseq

SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

If Messagebox("삭제확인", "선택한 마감내역을 삭제 하시겠읍니까?", question!, yesno!, 2) = 2 then
	return
end if

lcnt 	= dw_hist.rowcount()
For lrow = lcnt to 1 step -1 
	sDelgu 	= dw_hist.getitemstring(lrow, "delgu")
	If sDelgu = 'Y' then 
		sCvcod 	= dw_hist.getitemstring(lrow, "cvcod")
		sMayymm 	= dw_hist.getitemstring(lrow, "mayymm")
		iSeq 		= dw_hist.getitemNumber(lrow, "mayysq")
		dw_hist.deleterow(lrow)
		/* 전표이력 Clear */
		Update imhist
			Set mayymm = Null,
				 mayysq = 0
		 where sabu = :gs_sabu and mayymm = :sMayymm and mayysq = :iSeq and cvcod = :sCvcod;
		 
		if sqlca.sqlcode < 0 then
			rollback;
			f_rollback()
			p_can.TriggerEvent("clicked")
			return		
		end if
	End if	
Next
	
if dw_hist.update() = 1 then
	commit;
else
	rollback;
	f_rollback()
	p_can.TriggerEvent("clicked")
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_inq from uo_picture within w_imt_04020
integer x = 3529
integer y = 20
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
string	sYearMonth, sDateFrom, sDateTo,	&
			sTitle,	sNull, sscvcod, sEcvcod, sError, smagam, sGubun, ssaupj, sEmpno
Double	diseq, dcnt
long		lRow, lRowCount
int		iSeq

if dw_detail.AcceptText() = -1 then return 

////////////////////////////////////////////////////////////////////////////

sgubun     	= dw_detail.GetItemString(1, "magbn")
sYearMonth 	= trim(dw_detail.GetItemString(1, "yyyymm"))
sDateFrom  	= trim(dw_detail.GetItemString(1, "sdate"))
sDateTo    	= trim(dw_detail.GetItemString(1, "edate"))
sScvcod	  	= trim(dw_detail.GetItemString(1, "scvcod"))
sEcvcod    	= trim(dw_detail.GetItemString(1, "ecvcod"))
iSeq		  	= dw_detail.GetItemNumber(1, "seq")

sSaupj     	= dw_detail.GetItemString(1, "saupj")
sEmpno     	= trim(dw_detail.GetItemString(1, "empno"))

IF 	isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[마감년월]')
	dw_detail.SetColumn("yyyymm")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or sEmpno = "" 		THEN	sEmpno = '%'
IF isnull(sScvcod) or sScvcod = "" 	THEN	sScvcod = '.'
IF isnull(sEcvcod) or sEcvcod = "" 	THEN	sEcvcod = 'ZZZZZZ'

// 마감처리
IF 	rb_1.checked = true	THEN
	IF 	isnull(sSaupj) or sSaupj = "" 	THEN
		f_message_chk(30,'[사업장]')
		dw_detail.SetColumn("saupj")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF 	f_datechk(sDateFrom) = -1 	THEN
		f_message_chk(30,'[마감시작일]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF
	
	IF 	f_datechk(sDateTo) = -1 	THEN
		f_message_chk(30,'[마감종료일]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

// 마감취소
ELSE
	
	IF 	isnull(iSeq) or iSeq = 0 	THEN
		f_message_chk(30,'[마감순번]')
		dw_detail.SetColumn("seq")
		dw_detail.SetFocus()
		RETURN
	END IF
	
END IF

// 수불마감여부 확인
SELECT MAX(JPDAT) into :smagam
  FROM JUNPYO_CLOSING 
 WHERE SABU = :gs_sabu AND JPGU = 'C0';
 
if 	smagam >= left(syearmonth, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "yyyymm", sNull)
	return 1		
end if			 

if 	smagam >= left(sdatefrom, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "sdate", sNull)
	return 1		
end if			 

if 	smagam >= left(sdateto, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "edate", sNull)
	return 1		
end if			 

if 	ic_status = '1' then

	If 	Messagebox("마감확인", "마감자료를 생성 하시겠읍니까?", question!, yesno!, 2) = 2 then
		return
	end if	

   	SetPointer(HourGlass!)
	
	w_mdi_frame.sle_msg.text = '자료를 집계중입니다. 잠시 기다려 주십시요......!!'

	sError = 'X';
	SQLCA.ERP000000600(gs_sabu, sGubun, sYearmonth, sDatefrom, sDateTo, sScvcod, sEcvcod, &
	                   sSaupj, sEmpno, diseq, dcnt, sError);
	iseq = diseq;
	
	If sError = 'X' or sError = 'Y' then
		rollback;
		f_message_chk(41, '[마감 생성]')
		return
	elseif dcnt > 0 then
		commit;
		Messagebox("[마감 생성]", '마감  년월 -> ' + sYearmonth 		+ '~n' + &
										  '마감  차수 -> ' + String(iseq)	+ '~n' + &
										  '거래처건수 -> ' + String(dCnt) + ' 가 생성되었읍니다', information!)
		dw_detail.SetItem(1, "seq", iseq)
	end if;
		
	w_mdi_frame.sle_msg.text = ''
		
end if

if dw_hist.retrieve(gs_sabu, sYearmonth, iseq, sGubun) < 1 then
	f_message_chk(50, '[ 마감 현황 ]')
	return
end if

dw_detail.enabled = false
p_inq.enabled = false

If ic_status = '1' Then
	p_inq.picturename = "C:\erpman\image\생성_d.gif"
Else
	p_inq.picturename = "C:\erpman\image\조회_d.gif"
End If

p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"

p_delrow.enabled = true
p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"

p_del.enabled = true
p_del.picturename = "C:\erpman\image\삭제_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;If ic_status = '2' Then
	PictureName = "C:\erpman\image\조회_dn.gif"
Else
	PictureName = "C:\erpman\image\생성_dn.gif"
End If
end event

event ue_lbuttonup;call super::ue_lbuttonup;If ic_status = '2' Then
	PictureName = "C:\erpman\image\조회_up.gif"
Else
	PictureName = "C:\erpman\image\생성_up.gif"
End If
end event

type st_2 from statictext within w_imt_04020
boolean visible = false
integer x = 3045
integer y = 176
integer width = 1641
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "(매입 상세내역은 아래 자료를 Double Clicked을 하세요)"
boolean focusrectangle = false
end type

type cb_all_del from commandbutton within w_imt_04020
boolean visible = false
integer x = 1710
integer y = 2944
integer width = 517
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "전체삭제(&A)"
end type

event clicked;Long lrow, lcnt
String sMayymm, sCvcod
Integer iseq

if dw_detail.AcceptText() = -1 then return 
SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

sMayymm 	= trim(dw_detail.getitemstring(1, "yyyymm"))
iSeq 		= dw_detail.getitemNumber(1, "seq")

If Messagebox("삭제확인", left(sMayymm, 4) + '년 ' + mid(sMayymm, 5, 2) + '월 ' + &
    string(iseq) + "차 마감내역 전체를 삭제 하시겠읍니까?", question!, yesno!, 2) = 2 then
	return
end if

SetPointer(HourGlass!)

dw_hist.SetRedraw(false)	

lcnt 		= dw_hist.rowcount()

For lrow = lcnt to 1 step -1
	dw_hist.deleterow(lrow)  
Next 

if dw_hist.update() = 1 then
	/* 전표이력 Clear */
	Update imhist
		Set mayymm = Null,
			 mayysq = 0
	 where sabu = :gs_sabu and mayymm = :sMayymm and mayysq = :iSeq ;
	 
	if sqlca.sqlcode < 0 then
		rollback;
		f_rollback()
		cb_cancel.TriggerEvent("clicked")			
		dw_hist.SetRedraw(true)	
		return		
	end if
	
	commit;
else
	rollback;
	f_rollback()
end if

cb_cancel.TriggerEvent("clicked")
dw_hist.SetRedraw(true)	


end event

type cb_delete from commandbutton within w_imt_04020
boolean visible = false
integer x = 1189
integer y = 2944
integer width = 498
integer height = 92
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

event clicked;Long lrow, lcnt
String sMayymm, sCvcod, sDelgu
Integer iseq

SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

If Messagebox("삭제확인", "선택한 마감내역을 삭제 하시겠읍니까?", question!, yesno!, 2) = 2 then
	return
end if

lcnt 	= dw_hist.rowcount()
For lrow = lcnt to 1 step -1 
	sDelgu 	= dw_hist.getitemstring(lrow, "delgu")
	If sDelgu = 'Y' then 
		sCvcod 	= dw_hist.getitemstring(lrow, "cvcod")
		sMayymm 	= dw_hist.getitemstring(lrow, "mayymm")
		iSeq 		= dw_hist.getitemNumber(lrow, "mayysq")
		dw_hist.deleterow(lrow)
		/* 전표이력 Clear */
		Update imhist
			Set mayymm = Null,
				 mayysq = 0
		 where sabu = :gs_sabu and mayymm = :sMayymm and mayysq = :iSeq and cvcod = :sCvcod;
		 
		if sqlca.sqlcode < 0 then
			rollback;
			f_rollback()
			cb_cancel.TriggerEvent("clicked")
			return		
		end if
	End if	
Next
	
if dw_hist.update() = 1 then
	commit;
else
	rollback;
	f_rollback()
	cb_cancel.TriggerEvent("clicked")
end if


end event

type rb_3 from radiobutton within w_imt_04020
integer x = 3154
integer y = 136
integer width = 338
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감수정"
end type

event clicked;
ic_status = '2'


p_inq.picturename = "C:\erpman\image\조회_up.gif"
wf_initial()

end event

type dw_hist from datawindow within w_imt_04020
integer x = 46
integer y = 252
integer width = 4526
integer height = 2040
integer taborder = 30
string dataobject = "d_imt_04020_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_parm, sgubun, sYearMonth
int	 iSeq

if row < 1 then return 

/* 전표이력 조회선택 */
str_05000 istr_05000

istr_05000.sabu 		= gs_sabu
istr_05000.mayymm 	= this.getitemstring(row, "mayymm")
istr_05000.mayysq		= this.getitemdecimal(row, "mayysq")
istr_05000.cvcod		= this.getitemstring(row, "cvcod")
istr_05000.sdate		= this.getitemstring(row, "mastdat")
istr_05000.edate		= this.getitemstring(row, "maeddat")
istr_05000.magubn 	= this.getitemstring(row, "magubn") /* 마감구분 */
istr_05000.saupj  	= this.getitemstring(row, "saupj") /* 부가사업장 */

if istr_05000.magubn = '1' then //외주입고
	istr_05000.gubun 		= 'Y' 
elseif istr_05000.magubn = '2' then //구매입고
	istr_05000.gubun 		= 'N' 
else //외주구매
	istr_05000.gubun 		= '%' 
end if

istr_05000.dwname		= this
istr_05000.lrow		= row
istr_05000.move_yn	= this.getitemstring(row, "move_yn")  //회계전송 여부(Y:전송)

openwithparm(w_pdt_05004, istr_05000)

ls_parm = Message.StringParm

If ls_parm = '1' Then
	sgubun     	= dw_detail.GetItemString(1, "magbn")
	sYearMonth 	= trim(dw_detail.GetItemString(1, "yyyymm"))
	iSeq		  	= dw_detail.GetItemNumber(1, "seq")
	
	if dw_hist.retrieve(gs_sabu, sYearmonth, iseq, sGubun) < 1 then
		f_message_chk(50, '[ 마감 현황 ]')
		return
	end if
End If
end event

event clicked;If row <= 0 then
	this.SelectRow(0,False)
	Return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF

end event

type dw_detail from datawindow within w_imt_04020
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 41
integer y = 28
integer width = 3063
integer height = 188
integer taborder = 10
string dataobject = "d_imt_04020_a"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ud_downkey;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;// 거래처
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'scvcod'	THEN
   gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"scvcod",gs_code)
ELSEIF this.GetColumnName() = 'ecvcod'	THEN
   gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"ecvcod",gs_code)
elseif this.getcolumnname() = 'seq' then
	gi_page = 0
	this.accepttext()
	
	gs_code = this.getitemstring(1, 'magbn')

	open(w_imt_05000_1)

   if gs_code = '' or isnull(gs_code) then return
   if gs_gubun = '3' then 
		messagebox('확 인', 'LOCAL은 선택할 수 없습니다. 자료를 확인하세요')
		RETURN 
	end if
	setitem(1, "magbn", gs_gubun)
	setitem(1, "yyyymm", gs_code)
	setitem(1, "seq", gi_page)

	setnull(gs_code)
	gi_page = 0
	
	p_inq.TriggerEvent(Clicked!)
END IF

end event

event itemerror;return 1
end event

event itemchanged;string	sNull, sDate, sYYMM, sYm, SMAGAM, sGubun, ssaupj
long     get_seq

SetNull(sNull)

sSaupj 	= dw_detail.GetItemString(1,'saupj')

SELECT MAX(JPDAT) into :smagam
  FROM JUNPYO_CLOSING 
 WHERE SABU = :gs_sabu AND JPGU = 'C0';

//마감구분
IF this.GetColumnName() = 'magbn' THEN

	sGubun = this.Gettext()
	
	IF ic_status = '2' THEN 
		
		sYm   = trim(this.getitemstring(1, 'yyyymm'))
		
		if sym = '' or isnull(sym) then 
			SELECT MAX(MAYYMM)  
			  INTO :sYYMM 
			  FROM MAHIST  
			 WHERE SABU = :gs_sabu AND MAGUBN = :sgubun  ;
			
			if not (sYYmm = '' or isnull(sYYMm)) then 
				SELECT MAX(MAYYSQ)  
				  INTO :get_seq
				  FROM MAHIST  
				 WHERE SABU = :gs_sabu AND MAYYMM = :sYYMM AND MAGUBN = :sgubun  ;
				 
				if get_seq > 0 then 
					SELECT SAUPJ
					  INTO :ssaupj
					  FROM MAHIST  
					 WHERE SABU = :gs_sabu AND MAYYMM = :sYYMM AND MAYYSQ = :get_seq  ;
				end if
			end if
         			
			this.setitem(1, "yyyymm", sYYMM)
			this.setitem(1, "seq", get_seq)
			this.setitem(1, "saupj", ssaupj)
			
      else
			SELECT MAX(MAYYSQ)  
			  INTO :get_seq
			  FROM MAHIST  
			 WHERE SABU = :gs_sabu AND MAYYMM = :sYm AND MAGUBN = :sgubun  ;
	
			if get_seq > 0 then 
				SELECT SAUPJ
				  INTO :ssaupj
				  FROM MAHIST  
				 WHERE SABU = :gs_sabu AND MAYYMM = :sYYMM AND MAYYSQ = :get_seq  ;
			end if

			this.setitem(1, "seq", get_seq)
			this.setitem(1, "saupj", ssaupj)
			 
		end if
		
	END IF 	 
	
// 마감년월
ELSEIF this.GetColumnName() = 'yyyymm' THEN

	sDate  	= trim(this.GetItemString(1, "sdate"))
	sGubun 	= this.GetItemString(1, "magbn")
	
	sYm   		= trim(this.gettext())
	sYYMM 	= sYm + '01'
	IF 	f_datechk(sYYMM) = -1	then
		this.setitem(1, "yyyymm", sNull)
		return 1
	END IF
 
	IF ic_status = '2' THEN 
		SELECT MAX(MAYYSQ)  
		  INTO :get_seq
		  FROM MAHIST  
		 WHERE SABU = :gs_sabu AND MAYYMM = :sYm AND MAGUBN = :sGubun  ;

		if get_seq > 0 then 
			SELECT SAUPJ
			  INTO :ssaupj
			  FROM MAHIST  
			 WHERE SABU = :gs_sabu AND MAYYMM = :sYYMM AND MAYYSQ = :get_seq 
			      AND ROWNUM = 1;
		end if
      
		this.setitem(1, "seq", get_seq)
		this.setitem(1, "saupj", ssaupj)
	END IF 	 
	
	if smagam >= left(syymm, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "yyyymm", sNull)
		return 1		
	end if			
	
END IF

// 마감시작일
IF this.GetColumnName() = 'sdate' THEN

	sYYMM = trim(this.GetItemString(1, "yyyymm")) + '01'
	
	sDate = trim(this.gettext())
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
	if smagam >= left(sdate, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "sdate", sNull)
		return 1		
	end if		
	
//	IF sYYMM > sDate	THEN
//		MessageBox("확인", "마감시작일은 마감년월보다 작습니다.")
//		this.setitem(1, "sdate", sNull)
//		RETURN 1
//	END IF
	
END IF

// 마감종료일
IF this.GetColumnName() = 'edate' THEN

	sDate = trim(this.gettext())
	
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
	if smagam >= left(sdate, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "edate", sNull)
		return 1		
	end if	
elseif getcolumnname() = 'saupj' then
	sdate = gettext()
	f_child_saupj(dw_detail, 'empno', sdate)
END IF


end event

event losefocus;this.AcceptText()
end event

type rb_1 from radiobutton within w_imt_04020
integer x = 3154
integer y = 64
integer width = 338
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감처리"
boolean checked = true
end type

event clicked;ic_status = '1'

//cb_retrieve.text = '마감(&R)'
p_inq.enabled = true
p_inq.picturename = "C:\erpman\image\생성_up.gif"

wf_initial()

end event

type cb_cancel from commandbutton within w_imt_04020
boolean visible = false
integer x = 2336
integer y = 2944
integer width = 498
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;Rollback;
rb_1.checked = true

rb_1.TriggerEvent("clicked")
end event

type cb_retrieve from commandbutton within w_imt_04020
boolean visible = false
integer x = 55
integer y = 2944
integer width = 498
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string	sYearMonth, sDateFrom, sDateTo,	&
			sTitle,	sNull, sscvcod, sEcvcod, sError, smagam, sGubun, ssaupj, sEmpno
Double	diseq, dcnt
long		lRow, lRowCount
int		iSeq

if dw_detail.AcceptText() = -1 then return 

////////////////////////////////////////////////////////////////////////////

sgubun     = dw_detail.GetItemString(1, "magbn")
sYearMonth = trim(dw_detail.GetItemString(1, "yyyymm"))
sDateFrom  = trim(dw_detail.GetItemString(1, "sdate"))
sDateTo    = trim(dw_detail.GetItemString(1, "edate"))
sScvcod	  = trim(dw_detail.GetItemString(1, "scvcod"))
sEcvcod    = trim(dw_detail.GetItemString(1, "ecvcod"))
iSeq		  = dw_detail.GetItemNumber(1, "seq")

sSaupj     = dw_detail.GetItemString(1, "saupj")
sEmpno     = trim(dw_detail.GetItemString(1, "empno"))

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[마감년월]')
	dw_detail.SetColumn("yyyymm")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or sEmpno = "" 	THEN	sEmpno = '%'
IF isnull(sScvcod) or sScvcod = "" 	THEN	sScvcod = '.'
IF isnull(sEcvcod) or sEcvcod = "" 	THEN	sEcvcod = 'ZZZZZZ'

// 마감처리
IF rb_1.checked = true	THEN
	IF isnull(sSaupj) or sSaupj = "" 	THEN
		f_message_chk(30,'[사업장]')
		dw_detail.SetColumn("saupj")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sDateFrom) or sDateFrom = "" 	THEN
		f_message_chk(30,'[마감시작일]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF
	
	IF isnull(sDateTo)   or sDateTo = "" 	THEN
		f_message_chk(30,'[마감종료일]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

// 마감취소
ELSE
	
	IF isnull(iSeq) or iSeq = 0 	THEN
		f_message_chk(30,'[마감순번]')
		dw_detail.SetColumn("seq")
		dw_detail.SetFocus()
		RETURN
	END IF
	
END IF

// 수불마감여부 확인
SELECT MAX(JPDAT) into :smagam
  FROM JUNPYO_CLOSING 
 WHERE SABU = :gs_sabu AND JPGU = 'C0';
 
if smagam >= left(syearmonth, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "yyyymm", sNull)
	return 1		
end if			 

if smagam >= left(sdatefrom, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "sdate", sNull)
	return 1		
end if			 

if smagam >= left(sdateto, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "edate", sNull)
	return 1		
end if			 

if ic_status = '1' then

	If Messagebox("마감확인", "마감자료를 생성 하시겠읍니까?", question!, yesno!, 2) = 2 then
		return
	end if	

   SetPointer(HourGlass!)
	
//	st_status.text = '자료를 집계중입니다. 잠시 기다려 주십시요......!!'

	sError = 'X';
	SQLCA.ERP000000600(gs_sabu, sGubun, sYearmonth, sDatefrom, sDateTo, sScvcod, sEcvcod, &
	                   sSaupj, sEmpno, diseq, dcnt, sError);
	iseq = diseq;
	
	If sError = 'X' or sError = 'Y' then
		rollback;
		f_message_chk(41, '[마감 생성]')
		return
	elseif dcnt > 0 then
		Messagebox("[마감 생성]", '마감  년월 -> ' + sYearmonth 		+ '~n' + &
										  '마감  차수 -> ' + String(iseq)	+ '~n' + &
										  '거래처건수 -> ' + String(dCnt) + ' 가 생성되었읍니다', information!)
		dw_detail.SetItem(1, "seq", iseq)
	end if;
		
//	st_status.text = ''
		
end if

if dw_hist.retrieve(gs_sabu, sYearmonth, iseq, sGubun) < 1 then
	f_message_chk(50, '[ 마감 현황 ]')
	return
end if

dw_detail.enabled = false
cb_retrieve.enabled = false

cb_save.enabled = true
cb_delete.enabled = true
cb_all_del.enabled = true

end event

type cb_exit from commandbutton within w_imt_04020
boolean visible = false
integer x = 2857
integer y = 2944
integer width = 498
integer height = 92
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;Rollback;
close(parent)


end event

type cb_save from commandbutton within w_imt_04020
boolean visible = false
integer x = 576
integer y = 2944
integer width = 498
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

event clicked;SetPointer(HourGlass!)

IF dw_hist.RowCount() < 1			THEN 	RETURN 
IF dw_hist.AcceptText() = -1		THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

if dw_hist.update() = 1 then
	commit;
else
	rollback;
	f_rollback()
	cb_cancel.TriggerEvent("clicked")
end if


end event

type rr_1 from roundrectangle within w_imt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3122
integer y = 24
integer width = 402
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 3086
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_imt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 244
integer width = 4553
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 46
end type

