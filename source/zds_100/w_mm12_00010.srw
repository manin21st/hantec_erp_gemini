$PBExportHeader$w_mm12_00010.srw
$PBExportComments$** MRO 자재 불출
forward
global type w_mm12_00010 from window
end type
type dw_imhist from datawindow within w_mm12_00010
end type
type dw_imhist_mro from datawindow within w_mm12_00010
end type
type p_delrow from uo_picture within w_mm12_00010
end type
type p_addrow from uo_picture within w_mm12_00010
end type
type p_search from uo_picture within w_mm12_00010
end type
type p_exit from uo_picture within w_mm12_00010
end type
type p_can from uo_picture within w_mm12_00010
end type
type p_del from uo_picture within w_mm12_00010
end type
type p_mod from uo_picture within w_mm12_00010
end type
type p_inq from uo_picture within w_mm12_00010
end type
type cb_1 from commandbutton within w_mm12_00010
end type
type cb_delete from commandbutton within w_mm12_00010
end type
type cb_cancel from commandbutton within w_mm12_00010
end type
type rb_delete from radiobutton within w_mm12_00010
end type
type rb_insert from radiobutton within w_mm12_00010
end type
type dw_detail from datawindow within w_mm12_00010
end type
type cb_save from commandbutton within w_mm12_00010
end type
type cb_exit from commandbutton within w_mm12_00010
end type
type cb_retrieve from commandbutton within w_mm12_00010
end type
type rr_1 from roundrectangle within w_mm12_00010
end type
type rr_2 from roundrectangle within w_mm12_00010
end type
type rr_3 from roundrectangle within w_mm12_00010
end type
type dw_list from datawindow within w_mm12_00010
end type
end forward

global type w_mm12_00010 from window
integer width = 5856
integer height = 2504
boolean titlebar = true
string title = "소모품 불출"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_imhist dw_imhist
dw_imhist_mro dw_imhist_mro
p_delrow p_delrow
p_addrow p_addrow
p_search p_search
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
cb_1 cb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_list dw_list
end type
global w_mm12_00010 w_mm12_00010

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_RateGub       //환율 사용여부(1:일일,2:예측)            

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_qccheck         //검사수정여부
String     is_cnvart             //변환연산자
String     is_gubun             //변환계수사용여부
string      is_ispec, is_jijil  //규격, 재질명
end variables

forward prototypes
public subroutine wf_valid_jego ()
public function integer wf_required_chk ()
public function integer wf_imhist_create ()
public function integer wf_initial ()
public function integer wf_imhist_inquiry (string ar_depot_no)
end prototypes

public subroutine wf_valid_jego ();long		lrow1, lrow2
string	sdept, sitnbr1, sitnbr2
decimal	dioqty, djego

//sdept = dw_detail.getitemstring(1,'deptcode')
sdept = dw_detail.getitemstring(1,'vendor')

FOR lrow1 = 1 TO dw_list.rowcount()
	dw_list.setitem(lrow1,'calc_jego','N')
NEXT

FOR lrow1 = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow1,'calc_jego') = 'Y' then continue
	
	sitnbr1 = dw_list.getitemstring(lrow1,'imhist_itnbr')
	if isnull(sitnbr1) or sitnbr1 = '' then continue
	
//	select jego_qty into :djego from stock_mro
//	 where deptcode = :sdept and itnbr = :sitnbr1 ;
//	if sqlca.sqlcode <> 0 then djego = 0

	select jego_qty into :djego from stock
	 where depot_no = :sdept and itnbr = :sitnbr1 and pspec = '.' ;
	if sqlca.sqlcode <> 0 then djego = 0

	dw_list.setitem(lrow1,'jego_qty',djego)
	dw_list.setitem(lrow1,'calc_jego','Y')
	
	dioqty = dw_list.getitemnumber(lrow1,'imhist_ioqty')
	djego = djego - dioqty
	
	FOR lrow2 = lrow1 + 1 TO dw_list.rowcount()
		sitnbr2 = dw_list.getitemstring(lrow2,'imhist_itnbr')
		if sitnbr1 <> sitnbr2 then continue
		
		dw_list.setitem(lrow2,'jego_qty',djego)
		dw_list.setitem(lrow2,'calc_jego','Y')
		
		dioqty = dw_list.getitemnumber(lrow2,'imhist_ioqty')		
		djego = djego - dioqty		
	NEXT		
NEXT
end subroutine

public function integer wf_required_chk ();long		lrow
string	sfdate, stdate, sdept, sempno
string	sitnbr, stemp, sgubun, sdept2, sempno2, sdepot
decimal	dqty, djego

sfdate = trim(dw_detail.getitemstring(1,'fdate'))
sdept  = dw_detail.getitemstring(1,'deptcode')
sempno = dw_detail.getitemstring(1,'empno')
sgubun = dw_detail.getitemstring(1,'gubun')
sdepot = dw_detail.getitemstring(1,'vendor')

if ic_status = '1' then
	if f_datechk(sfdate) = -1 then
		f_message_chk(30,'[기간 from]')
		dw_detail.setcolumn('fdate')
		dw_detail.setfocus()
		return -1
	end if
	
	if isnull(sdept) or sdept = '' then
		f_message_chk(30,'[담당부서]')
		dw_detail.setfocus()
		return -1
	end if
	
	if isnull(sempno) or sempno = '' then
		f_message_chk(30,'[담당자]')
		dw_detail.setfocus()
		return -1
	end if

	if isnull(sdepot) or sdepot = '' then
		f_message_chk(30,'[창고]')
		dw_detail.setfocus()
		return -1
	end if
end if


FOR lrow = 1 TO dw_list.rowcount()
	if ic_status = '1' then
		sitnbr = dw_list.getitemstring(lrow,'imhist_itnbr')
		if isnull(sitnbr) or sitnbr = '' then
			f_message_chk(30,'[품번]')
			dw_list.setrow(lrow)
			dw_list.scrolltorow(lrow)
			dw_list.setcolumn("imhist_itnbr")
			dw_list.setfocus()
			return -1
		end if
		
		select itnbr into :stemp from itemas
		 where itnbr = :sitnbr and ittyp in ( '5' ,'6');
		if sqlca.sqlcode <> 0 then
			messagebox('확인','MRO 품번이 아닙니다.')
			dw_list.setrow(lrow)
			dw_list.scrolltorow(lrow)
			dw_list.setcolumn("imhist_itnbr")
			dw_list.setfocus()
			return -1
		end if
	end if
	
//	sdept2 = dw_list.getitemstring(lrow,'imhist_ioredept')
//	if isnull(sdept2) or sdept2 = '' then
//		f_message_chk(30,'[사용부서]')
//		dw_list.setrow(lrow)
//		dw_list.scrolltorow(lrow)
//		dw_list.setcolumn("imhist_ioredept")
//		dw_list.setfocus()
//		return -1
//	end if

	dqty = dw_list.getitemnumber(lrow,'imhist_ioqty')
	if isnull(dqty) or dqty <= 0 then
		messagebox('확인','불출수량을 지정하십시오.')
		dw_list.setrow(lrow)
		dw_list.scrolltorow(lrow)
		dw_list.setcolumn("ioqty")
		dw_list.setfocus()
		return -1
	end if
	
	if ic_status = '1' then
		djego = dw_list.getitemnumber(lrow,'jego_qty')
		if djego < dqty then
			messagebox('확인','line : '+string(lrow)+' [ '+sitnbr+' ] 불출 가능수량을 확인하십시오.')
		end if
	end if
	
NEXT

return 1
end function

public function integer wf_imhist_create ();string	sJpno, 		&
			sEmpno,		&
			sDate, 		&
			sVendor,		&
			sNull, sIogbn, sField_cd
long		lRow, lRowOut
long 		dSeq

SetNull(sNull)

dw_detail.AcceptText()
dw_list.AcceptText()

sDate   = dw_detail.getitemstring(1,'fdate')
sVendor = dw_detail.getitemstring(1,'vendor')
sempno  = dw_detail.getitemstring(1,'empno')

IF IsNull(sdate)	or   trim(sdate) = ''	THEN
	f_message_chk(30,'[불출일자]')
   return -1
END IF	

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[출고번호]')
	RETURN -1
END IF
COMMIT;
			
siogbn = 'O81'	/* 수불구분 - MRO 불출	*/
sJpno  = sDate + string(dSeq, "0000")


FOR lRow = 1	TO	dw_list.RowCount()
	dw_list.SetItem(lRow, "imhist_sabu",	gs_sabu)
	dw_list.SetItem(lRow, "imhist_jnpcrt",	'001')												// 전표생성구분
	dw_list.SetItem(lRow, "imhist_inpcnf",	'O')													// 입출고구분
	dw_list.SetItem(lRow, "imhist_iojpno", sJpno+string(lRow, "000"))
	dw_list.SetItem(lRow, "imhist_iogbn",  siogbn) 												// 수불구분
	dw_list.SetItem(lRow, "imhist_sudat",	sDate)												// 수불일자=현재일자
	dw_list.SetItem(lRow, "imhist_pspec",	".")													//사양
	dw_list.SetItem(lRow, "imhist_opseq",	'9999') 												// 공정순서

	dw_list.SetItem(lRow, "imhist_depot_no",	sVendor) 											// 기준창고=담당부서창고
	dw_list.SetItem(lRow, "imhist_io_empno",	sempno)												// 수불승인자=담당자
	dw_list.SetItem(lRow, "imhist_cvcod",		dw_list.GetItemstring(lRow, "imhist_ioredept"))	// 거래처창고=사용부서
	
	dw_list.SetItem(lRow, "imhist_insdat",	sDate) 												// 검사일자=입고의뢰일자
	dw_list.SetItem(lRow, "imhist_iosuqty", dw_list.GetItemDecimal(lRow, "imhist_ioqty"))		// 합격수량=입고수량

	dw_list.SetItem(lRow, "imhist_io_confirm", 'Y')												// 수불승인여부
	dw_list.SetItem(lRow, "imhist_io_date", 	sDate)												// 수불승인일자=입고일자
	dw_list.SetItem(lRow, "imhist_filsk", 	'Y')													// 재고관리구분
	sField_cd = dw_list.GetItemString(lRow, "imhist_field_cd")		// 사용처
	if IsNull(sField_cd) or sField_cd = "" then
		dw_list.SetItem(lRow, "imhist_field_cd", dw_list.GetItemString(lRow, "imhist_usage"))		// 사용처
	end if
NEXT

dw_list.accepttext()
if dw_list.update() <> 1 then
	rollback ;
	messagebox('확인','MRO 불출자료 생성실패!!!')
	return -1
end if
	
RETURN 1
end function

public function integer wf_initial ();dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist_mro.reset()

dw_detail.enabled = TRUE

////////////////////////////////////////////////////////////////////////
dw_detail.setredraw(false)
if ic_status = '1' then
	dw_detail.dataobject = 'd_mm12_00010_1'
	dw_list.dataobject = 'd_mm12_00010_a'
	
	p_addrow.visible = true
	p_delrow.visible = true
	w_mdi_frame.sle_msg.text = "등록"
else
	dw_detail.dataobject = 'd_mm12_00010_2'
	dw_list.dataobject = 'd_mm12_00010_b'
	
	p_addrow.visible = false
	p_delrow.visible = false
	w_mdi_frame.sle_msg.text = "삭제"	
END IF

dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_detail.insertrow(0)

dw_detail.setitem(1,'fdate',f_today())
dw_detail.setitem(1,'tdate',f_today())
dw_detail.setitem(1, "empno", gs_empno)
dw_detail.setitem(1, "empname", f_get_name5("02",gs_empno,""))

string	sdeptcode, sdeptname

select deptcode, fun_get_dptno(deptcode)
  into :sdeptcode, :sdeptname
  from p1_master
 where empno = :gs_empno ;

dw_detail.setitem(1,'deptcode',sdeptcode)
dw_detail.setitem(1,'deptname',sdeptname)

string	sdepot

/* 저장품은 'Z'가 아니고 '5'임 - by shingoon 2008.01.08 */
/*
select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = 'Z' ;
*/
//select cvcod into :sdepot from vndmst
// where cvgu = '5' and deptcode = :sdeptcode and juprod = '5' ;
SELECT CVCOD
  INTO :sdepot
  FROM VNDMST
 WHERE CVGU = '5'
   AND JUMAECHUL = '9';

if sqlca.sqlcode = 0 then
	dw_detail.setitem(1,'vendor',sdepot)
end if

dw_detail.setitem(1, "sdate", is_Date)

dw_detail.setcolumn("fdate")
dw_detail.setfocus()
dw_detail.setredraw(true)

return  1
end function

public function integer wf_imhist_inquiry (string ar_depot_no);string sdepot_no, sitnbr, sitdsc, sispec, slitcls
decimal {3} djego_qty
long lrow

DECLARE cs1 CURSOR FOR
select a.itnbr, b.itdsc, b.ispec, a.jego_qty
  from stock a, itemas b
 where a.itnbr = b.itnbr
   and a.depot_no = :ar_depot_no
   and b.ittyp IN ( '5','6')
	and a.jego_qty > 0;

OPEN cs1;

lrow = 0
dw_list.Reset()

dw_list.SetRedraw(false)

DO
	FETCH cs1 INTO :sitnbr, :sitdsc, :sispec, :djego_qty;
	IF sqlca.sqlcode <> 0 THEN EXIT
	lrow = dw_list.InsertRow(0)
	dw_list.SetItem(lrow, "imhist_itnbr", sitnbr)
	dw_list.SetItem(lrow, "itemas_itdsc", sitdsc)
	dw_list.SetItem(lrow, "itemas_ispec", sispec)
	dw_list.SetItem(lrow, "jego_qty", djego_qty)
LOOP WHILE SQLCA.SQLCODE = 0

dw_list.SetRedraw(true)

CLOSE cs1;

IF dw_list.RowCount() <= 0 THEN return -1

return 1
end function

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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

dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_mro.settransobject(sqlca)

rb_insert.TriggerEvent("clicked")


end event

on w_mm12_00010.create
this.dw_imhist=create dw_imhist
this.dw_imhist_mro=create dw_imhist_mro
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_search=create p_search
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_list=create dw_list
this.Control[]={this.dw_imhist,&
this.dw_imhist_mro,&
this.p_delrow,&
this.p_addrow,&
this.p_search,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.cb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.dw_list}
end on

on w_mm12_00010.destroy
destroy(this.dw_imhist)
destroy(this.dw_imhist_mro)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_search)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

type dw_imhist from datawindow within w_mm12_00010
boolean visible = false
integer x = 4745
integer y = 588
integer width = 571
integer height = 600
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type dw_imhist_mro from datawindow within w_mm12_00010
boolean visible = false
integer x = 1760
integer y = 2480
integer width = 494
integer height = 360
integer taborder = 30
boolean titlebar = true
string title = "none"
string dataobject = "d_mm12_00010_0a"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from uo_picture within w_mm12_00010
integer x = 3337
integer y = 60
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;long	lrow

lrow = dw_list.getrow()
if lrow < 1 then return

dw_list.deleterow(lrow)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_addrow from uo_picture within w_mm12_00010
integer x = 3159
integer y = 60
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;long	lrow

lrow = dw_list.insertrow(0)

dw_list.setrow(Lrow)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("imhist_itnbr")
dw_list.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from uo_picture within w_mm12_00010
boolean visible = false
integer x = 2784
integer y = 2532
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\재고조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type p_exit from uo_picture within w_mm12_00010
integer x = 4325
integer y = 60
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

type p_can from uo_picture within w_mm12_00010
integer x = 4151
integer y = 60
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

type p_del from uo_picture within w_mm12_00010
integer x = 3977
integer y = 60
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
if ic_status = '1' then return

long		i, lrow, lrowcnt

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	i++
NEXT
if i < 1 then return

if messagebox('확인','선택된 불출자료를 삭제합니다.',question!,yesno!,1) = 2 then return

/* 불출 자료 삭제 */
FOR lrow = dw_list.rowcount() TO 1 STEP -1
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	dw_list.deleterow(lrow)
NEXT

if dw_list.update() <> 1 then
	rollback ;
	messagebox('확인','불출 자료 삭제 실패!!!')
	return
end if

commit ;
messagebox('확인','자료를 삭제하였습니다.')
p_can.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_mm12_00010
integer x = 3803
integer y = 60
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_detail.accepttext() = -1 then return
if dw_list.accepttext() = -1 then return

if ic_status = '1' then
	dw_list.SetReDraw(false)
	long i, lcnt, lioqty
	lcnt = dw_list.RowCount()
	for i = lcnt to 1 step -1
		lioqty = dw_list.GetItemNumber(i, "imhist_ioqty")
		if lioqty <= 0 then dw_list.DeleteRow(i)
	next
	dw_list.SetReDraw(true)
end if

if dw_list.rowcount() < 1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

long		lrow
string	sgubun

sgubun = dw_detail.getitemstring(1,'gubun')

setpointer(hourglass!)
if ic_status = '1' then
	if wf_imhist_create() = -1 then return

else
	FOR lRow = 1	TO	dw_list.RowCount()
		
		dw_list.SetItem(lRow, "imhist_field_cd", dw_list.GetItemString(lRow, "imhist_usage"))		// 사용처
		
	NEXT
	if dw_list.update() <> 1 then
		rollback ;
		messagebox('확인','MRO 불출자료 저장실패!!!')
		return
	end if
	
end if

commit ;

messagebox('확인','자료를 저장하였습니다.')
p_can.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_mm12_00010
integer x = 3630
integer y = 60
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;string	sfdate, stdate, sempno, sdepot

w_mdi_frame.sle_msg.text =""
sdepot = dw_detail.getitemstring(1,'vendor')
// 등록시 조회 기능 추가 '23.06.16
//if ic_status = '1' then return
if ic_status = '1' then
	wf_imhist_inquiry(sdepot)
	return
end if

if dw_detail.accepttext() = -1 then return

sfdate = trim(dw_detail.getitemstring(1,'fdate'))
stdate = trim(dw_detail.getitemstring(1,'tdate'))
sempno = dw_detail.getitemstring(1,'empno')

if isnull(sfdate) or sfdate = '' then
	f_message_chk(30,'[기간 from]')
	dw_detail.setcolumn('fdate')
	dw_detail.setfocus()
	return
end if

if isnull(stdate) or stdate = '' then
	f_message_chk(30,'[기간 to]')
	dw_detail.setcolumn('tdate')
	dw_detail.setfocus()
	return
end if

setpointer(hourglass!)
if dw_list.retrieve(gs_sabu,sfdate,stdate,sempno,sdepot) < 1 then
	f_message_chk(50, '[MRO 불출내역]')
	dw_detail.setcolumn("fdate")
	dw_detail.setfocus()
	return
end if

p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_mm12_00010
boolean visible = false
integer x = 3264
integer y = 2580
integer width = 421
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고조회"
end type

type cb_delete from commandbutton within w_mm12_00010
boolean visible = false
integer x = 722
integer y = 2956
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

type cb_cancel from commandbutton within w_mm12_00010
boolean visible = false
integer x = 2459
integer y = 3040
integer width = 347
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type rb_delete from radiobutton within w_mm12_00010
integer x = 2619
integer y = 160
integer width = 242
integer height = 52
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

dw_list.setredraw(false)
wf_Initial()
dw_list.setredraw(true)
end event

type rb_insert from radiobutton within w_mm12_00010
integer x = 2619
integer y = 68
integer width = 242
integer height = 52
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

event clicked;ic_status = '1'	// 등록

dw_list.setredraw(False)
wf_Initial()
dw_list.setredraw(true)
end event

type dw_detail from datawindow within w_mm12_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 110
integer y = 52
integer width = 2368
integer height = 160
integer taborder = 10
string dataobject = "d_mm12_00010_1"
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

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event itemchanged;string	sgubun

if this.getcolumnname() = 'gubun' then
	sgubun = this.gettext()
	
	if ic_status = '1' then 		// 등록
		if sgubun = 'OA1' then		// 개인불출
			dw_list.dataobject = 'd_mm12_00010_a'
		else
			dw_list.dataobject = 'd_mm12_00010_b'
		end if
	else
		if sgubun = 'OA1' then		// 개인불출
			dw_list.dataobject = 'd_mm12_00010_c'
		else
			dw_list.dataobject = 'd_mm12_00010_d'
		end if
	end if		
	dw_list.settransobject(sqlca)
end if
end event

type cb_save from commandbutton within w_mm12_00010
boolean visible = false
integer x = 361
integer y = 2956
integer width = 347
integer height = 108
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

type cb_exit from commandbutton within w_mm12_00010
event key_in pbm_keydown
boolean visible = false
integer x = 2825
integer y = 3040
integer width = 347
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

type cb_retrieve from commandbutton within w_mm12_00010
boolean visible = false
integer y = 2956
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

type rr_1 from roundrectangle within w_mm12_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 16
integer width = 2478
integer height = 236
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_mm12_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2560
integer y = 16
integer width = 325
integer height = 236
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_mm12_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 292
integer width = 4526
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_mm12_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 304
integer width = 4503
integer height = 1996
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mm12_00010_b"
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

event itemchanged;long		lrow
string	sitnbr, sitdsc, sispec, sdept, sdeptname, sempno, sempname, snull, slitcls

lrow = this.getrow()
if lrow < 1 then return

setnull(snull)
if this.getcolumnname() = 'imhist_itnbr' then
	sitnbr = this.gettext()
	
	if isnull(sitnbr) or sitnbr = '' then 
		this.setitem(lrow,'itemas_itdsc',snull)
		this.setitem(lrow,'itemas_ispec',snull)
		return
	end if
	
	select itdsc, ispec, substr(itcls,1,2) into :sitdsc, :sispec, :slitcls from itemas
	 where itnbr = :sitnbr and ittyp IN ( '5','6') ;
	if sqlca.sqlcode = 0 then
		this.setitem(lrow,'itemas_itdsc',sitdsc)
		this.setitem(lrow,'itemas_ispec',sispec)
		this.setitem(lrow,'litcls',slitcls)
	else
		messagebox('확인','MRO 품목이 아닙니다.')
		this.setitem(lrow,'imhist_itnbr',snull)
		this.setitem(lrow,'itemas_itdsc',snull)
		this.setitem(lrow,'itemas_ispec',snull)
		this.setitem(lrow,'litcls',snull)
		return 1
	end if

elseif this.getcolumnname() = 'imhist_ioredept' then
	sdept = this.gettext()
	
	if isnull(sdept) or sdept = '' then 
		this.setitem(lrow,'todptname',snull)
		return
	end if
   sItnbr = this.GetItemString(lrow,'imhist_itnbr')
	
//	if Left(sItnbr,1) = '6' then    //spare part
//
//		select wcdsc into :sdeptname from wrkctr
//		 where wkctr = :sdept ;
//		if sqlca.sqlcode = 0 then
//			this.setitem(lrow,'todptname',sdeptname)
//		else
//			messagebox('확인','등록되지 않은 작업장코드입니다.')
//			this.setitem(lrow,'imhist_ioredept',snull)
//			this.setitem(lrow,'todptname',snull)
//			return 1
//		end if
//		
//	Else
		select deptname into :sdeptname from p0_dept
		 where deptcode = :sdept ;
		if sqlca.sqlcode = 0 then
			this.setitem(lrow,'todptname',sdeptname)
		else
			messagebox('확인','등록되지 않은 부서코드입니다.')
			this.setitem(lrow,'imhist_ioredept',snull)
			this.setitem(lrow,'todptname',snull)
			return 1
		end if
//	End if
	
//elseif this.getcolumnname() = 'toemp' then
//	sempno = this.gettext()
//	
//	if isnull(sempno) or sempno = '' then 
//		this.setitem(lrow,'toempname',snull)
//		return
//	end if
//	
//	select empname, deptcode, fun_get_dptno(deptcode) into :sempname, :sdept, :sdeptname from p1_master
//	 where empno = :sempno ;
//	if sqlca.sqlcode = 0 then
//		this.setitem(lrow,'toempname',sempname)
//		this.setitem(lrow,'todept',sdept)
//		this.setitem(lrow,'todptname',sdeptname)
//	else
//		messagebox('확인','등록되지 않은 사원코드입니다.')
//		this.setitem(lrow,'toemp',snull)
//		this.setitem(lrow,'toempname',snull)
//		this.setitem(lrow,'todept',snull)
//		this.setitem(lrow,'todptname',snull)
//		return 1
//	end if

end if

if ic_status = '1' then post wf_valid_jego()
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

event rbuttondown;long		lrow
string	slitcls, sitnbr

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()
if lrow < 1 then return

if this.getcolumnname() = 'imhist_itnbr' then
	gs_gubun = '5'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(lrow,'imhist_itnbr',gs_code)
	this.triggerevent(itemchanged!)
	
elseif this.getcolumnname() = 'imhist_ioredept' then
//   sitnbr = this.getitemstring(lrow,'imhist_itnbr')
//	if left(sitnbr,1) = '6' then
//		gs_code = this.GetText()
//		open(w_workplace_popup)
//		
//		IF Isnull(gs_Code) or gs_Code = '' THEN RETURN
//	
//		this.SetItem(1, 'imhist_ioredept', 	 gs_Code)
//		this.triggerevent(itemchanged!)
//	Else
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(lrow,'imhist_ioredept',gs_code)
		this.triggerevent(itemchanged!)
//	End if

elseif this.getcolumnname() = 'imhist_usage' then
	slitcls = this.getitemstring(lrow,'litcls')
	if slitcls = '05' then		// 소모성 공구류 - 설비코드 팝업
		open(w_mchmst_popup)
		this.SetItem(lrow, "imhist_usage", gs_code)
	elseif slitcls = '07' then	// 포장재 - 제품코드 팝업
		gs_gubun = '1'
		open(w_itemas_popup)
		this.SetItem(lrow, "imhist_usage", gs_code)
	end if
	
elseif this.getcolumnname() = 'toemp' then
	open(w_sawon_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(lrow,'toemp',gs_code)
	this.triggerevent(itemchanged!)
	
end if

end event

event type long updatestart();///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
return 0
end event

