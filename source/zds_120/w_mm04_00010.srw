$PBExportHeader$w_mm04_00010.srw
$PBExportComments$** 매입 반품
forward
global type w_mm04_00010 from window
end type
type cb_2 from commandbutton within w_mm04_00010
end type
type dw_1 from datawindow within w_mm04_00010
end type
type pb_2 from u_pb_cal within w_mm04_00010
end type
type pb_1 from u_pb_cal within w_mm04_00010
end type
type p_1 from picture within w_mm04_00010
end type
type dw_imhist from datawindow within w_mm04_00010
end type
type p_delrow from uo_picture within w_mm04_00010
end type
type p_addrow from uo_picture within w_mm04_00010
end type
type p_search from uo_picture within w_mm04_00010
end type
type p_exit from uo_picture within w_mm04_00010
end type
type p_can from uo_picture within w_mm04_00010
end type
type p_del from uo_picture within w_mm04_00010
end type
type p_mod from uo_picture within w_mm04_00010
end type
type p_inq from uo_picture within w_mm04_00010
end type
type cb_1 from commandbutton within w_mm04_00010
end type
type cb_delete from commandbutton within w_mm04_00010
end type
type cb_cancel from commandbutton within w_mm04_00010
end type
type rb_delete from radiobutton within w_mm04_00010
end type
type rb_insert from radiobutton within w_mm04_00010
end type
type dw_detail from datawindow within w_mm04_00010
end type
type cb_save from commandbutton within w_mm04_00010
end type
type cb_exit from commandbutton within w_mm04_00010
end type
type cb_retrieve from commandbutton within w_mm04_00010
end type
type rr_1 from roundrectangle within w_mm04_00010
end type
type rr_2 from roundrectangle within w_mm04_00010
end type
type rr_3 from roundrectangle within w_mm04_00010
end type
type dw_list from datawindow within w_mm04_00010
end type
type cbx_1 from checkbox within w_mm04_00010
end type
type dw_print from datawindow within w_mm04_00010
end type
type rr_4 from roundrectangle within w_mm04_00010
end type
end forward

global type w_mm04_00010 from window
integer width = 5344
integer height = 2536
boolean titlebar = true
string title = "매입 공제"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
cb_2 cb_2
dw_1 dw_1
pb_2 pb_2
pb_1 pb_1
p_1 p_1
dw_imhist dw_imhist
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
cbx_1 cbx_1
dw_print dw_print
rr_4 rr_4
end type
global w_mm04_00010 w_mm04_00010

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
public function integer wf_imhist_update ()
public function integer wf_required_chk ()
public function integer wf_initial ()
public function integer wf_imhist_create (ref string rsdate, ref long rdseq)
public subroutine wf_print2 (boolean printyn)
public subroutine wf_print (long arg_row)
end prototypes

public function integer wf_imhist_update ();long		lrow
string	sabu, sjpno, sbigo
decimal	dqty, dprc, damt

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	
	sabu = dw_list.getitemstring(lrow,'sabu')
	sjpno= dw_list.getitemstring(lrow,'shpjpno')
	dqty = dw_list.getitemnumber(lrow,'ioqty')
	dprc = dw_list.getitemnumber(lrow,'ioprc')
	damt = dw_list.getitemnumber(lrow,'vamt')
	sbigo= dw_list.getitemstring(lrow,'bigo')
	
	if dw_list.getitemstring(lrow,'gubun') = '1' then  /* 반품만 */
		update imhist
			set ioqty = :dqty,
				 ioprc = :dprc,
				 ioamt = :damt,
				 bigo  = :sbigo
		 where sabu = :sabu and iojpno = :sjpno ;
		 
		if sqlca.sqlcode <> 0 then return -1
	else
		update shpfat_qa_sum
			set io_date = null,
				 outjpno = null,
				 gubun = null
		 where sabu = :gs_saupj and crsjpno = :sjpno ;
		
		if sqlca.sqlcode <> 0 then return -1
	end if
NEXT

return 1
end function

public function integer wf_required_chk ();long		lrow
string	sdept, sempno, sdepot

if ic_status = '2' then return 1

sdept  = dw_detail.getitemstring(1,'deptcode')
sempno = dw_detail.getitemstring(1,'empno')
sdepot = dw_detail.getitemstring(1,'house')

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

string	sdate, sgubun
decimal	dqty, dprc

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	dqty = dw_list.getitemnumber(lrow,'ioqty')
	if isnull(dqty) or dqty <= 0 then
		messagebox('확인','수량을 지정하십시오.')
		dw_list.setrow(lrow)
		dw_list.scrolltorow(lrow)
		dw_list.setcolumn("ioqty")
		dw_list.setfocus()
		return -1
	end if
		
	dprc = dw_list.getitemnumber(lrow,'ioprc')
//	if isnull(dprc) or dprc <= 0 then
//		messagebox('확인','단가를 지정하십시오.')
//		dw_list.setrow(lrow)
//		dw_list.scrolltorow(lrow)
//		dw_list.setcolumn("ioprc")
//		dw_list.setfocus()
//		return -1
//	end if
	
	sdate = dw_list.getitemstring(lrow,'io_date')
	if f_datechk(sdate) <= 0 then
		messagebox('확인','처리일자를 확인하세요.')
		dw_list.setrow(lrow)
		dw_list.scrolltorow(lrow)
		dw_list.setcolumn("io_date")
		dw_list.setfocus()
		return -1
	end if

	sgubun = dw_list.getitemstring(lrow,'gubun')
	if isnull(sgubun) or sgubun = '' then
		messagebox('확인','처리구분을 지정하세요.')
		dw_list.setrow(lrow)
		dw_list.scrolltorow(lrow)
		dw_list.setcolumn("gubun")
		dw_list.setfocus()
		return -1
	end if
	
	if sgubun = '2' then
		dw_list.setitem(lrow,'outjpno','000000000000000')
	end if
NEXT

return 1
end function

public function integer wf_initial ();dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

dw_detail.enabled = TRUE

////////////////////////////////////////////////////////////////////////
dw_detail.setredraw(false)
if ic_status = '1' then
	dw_list.dataobject = 'd_mm04_00010_a'
	w_mdi_frame.sle_msg.text = "등록"
else
	dw_list.dataobject = 'd_mm04_00010_b'
	w_mdi_frame.sle_msg.text = "삭제"	
END IF

dw_list.settransobject(sqlca)

dw_detail.insertrow(0)

dw_detail.setitem(1,'fdate',Left(f_today(),6) + '01')
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

select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = '4' ;
if sqlca.sqlcode = 0 then
	dw_detail.setitem(1,'vendor',sdepot)
end if	

dw_detail.setcolumn("fdate")
dw_detail.setfocus()
dw_detail.setredraw(true)
dw_1.reset()
return  1
end function

public function integer wf_imhist_create (ref string rsdate, ref long rdseq);///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '008'
///////////////////////////////////////////////////////////////////////
string	sJpno, 		&
			sDate, 		&
			sEmpno,		&
			sDept,		&
			sGubun,		&
			sNull, 		&
			svendor, scvcod, sitnbr,&
			sitgu, spdtgu, siosp, get_yn, sjnpcrt, sSaupj, sdepot 
long		lRow, lRowHist, lcount, dSeq
dec {2}   damt
dec {3}  dqty
dec {5}  dprice

SetNull(sNull)
dw_detail.AcceptText()

rsdate = sdate
rdseq	 = dseq

////////////////////////////////////////////////////////////////////////
sEmpno = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sDept  = dw_detail.GetItemString(1, "deptcode")
sGubun = 'I21'  /* 구매반품출고 */
sdepot = dw_detail.GetItemString(1, "house")

//sSaupj = dw_detail.GetItemString(1, "saupj")
sSaupj = gs_saupj

SELECT PDTGU, IOSP, JNPCRT  INTO :get_yn, :siosp, :sjnpcrt    FROM IOMATRIX  
 WHERE SABU = :gs_sabu AND IOGBN = :sgubun  ;
		 
if isnull(get_yn) then get_yn = 'N'		 
if isnull(sIosp)  then sIosp = 'I'		 
if isnull(sjnpcrt) then sjnpcrt = '027'		 

lCount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	if dw_list.getitemstring(lrow,'gubun') = '2' then 
		dw_list.setitem(lrow,'outjpno','000000000000000')
		continue // 교환은 skip
	end if

	sDate = dw_list.GetItemString(lRow, "cdate")
	dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'')
		RETURN -1
	END IF
	COMMIT;
	sJpno  = sDate + string(dSeq, "0000")

	/////////////////////////////////////////////////////////////////////////
	//
	// ** 입출고HISTORY 생성 **
	//
	////////////////////////////////////////////////////////////////////////
	lRowHist = dw_imhist.InsertRow(0)

	dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
	dw_imhist.SetItem(lRowHist, "jnpcrt",	sjnpcrt)			// 전표생성구분
	dw_imhist.SetItem(lRowHist, "inpcnf",  siosp)	// 입출고구분
	dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + "001" )
	
	//////////////////////////////////////////////////////////////
	dw_imhist.SetItem(lRowHist, "iogbn",   sGubun) 			// 수불구분=입고구분

	dw_list.setitem(lrow,'outjpno',sJpno + "001")

	dw_imhist.SetItem(lRowHist, "sudat",	sDate)			// 수불일자=수불의뢰일자

   sitnbr = dw_list.GetItemString(lRow, "itnbr")
	dw_imhist.SetItem(lRowHist, "itnbr",   sitnbr ) // 품번
	dw_imhist.SetItem(lRowHist, "pspec",	'.') // 사양

	dw_imhist.SetItem(lRowHist, "saupj",	sSaupj) // 사업장
//	dw_imhist.SetItem(lRowHist, "lotsno",	trim(dw_list.GetItemString(lRow, "lotsno"))) // lot no
	dw_imhist.SetItem(lRowHist, "bigo",	   dw_list.GetItemString(lRow, "bigo"))

   //생산실적이 Y 인 경우만 생산팀 입력
	SELECT A.ITGU, B.PDTGU 
	  INTO :sItgu, :sPdtgu
	  FROM ITEMAS A, ITNCT B
	 WHERE A.ITNBR = :sitnbr AND A.ITTYP = B.ITTYP and A.ITCLS = B.ITCLS ;                   
	
	if get_yn = 'Y' then 
		if sqlca.sqlcode = 0 then 
			dw_imhist.SetItem(lRowHist, "pdtgu",   spdtgu) 	// 생산팀
		else
			dw_imhist.SetItem(lRowHist, "pdtgu",   sNull) 	// 생산팀
		end if	
   end if
	if sqlca.sqlcode = 0 then 
		dw_imhist.SetItem(lRowHist, "itgu",    sitgu) 	// 구입형태
	else
		dw_imhist.SetItem(lRowHist, "itgu",    sNull) 	// 구입형태
	end if	
	
	dw_imhist.SetItem(lRowHist, "opseq",	'9999') 			// 공정순서
	svendor = dw_list.GetItemString(lRow, "cvcod")
	dw_imhist.SetItem(lRowHist, "depot_no",sdepot)	      // 기준창고=입고처
	dw_imhist.SetItem(lRowHist, "cvcod",	svendor) 			// 거래처창고=입고의뢰부서
	dw_imhist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=입고의뢰자
	dw_imhist.SetItem(lRowHist, "ioredept",sDept)			// 수불의뢰부서=입고의뢰부서
	dw_imhist.SetItem(lRowHist, "insdat",  dw_list.GetItemString(lRow, "io_date"))			// 검사일자=입고의뢰일자
	
	dw_imhist.SetItem(lRowHist, "io_confirm", 'Y')		// 수불승인여부	
	dw_imhist.SetItem(lRowHist, "io_date",  dw_list.GetItemString(lRow, "io_date"))		// 수불승인일자=입고의뢰일자
	dw_imhist.SetItem(lRowHist, "io_empno", sNull)		// 수불승인자=NULL

   dprice = dw_list.GetItemDecimal(lRow, "ioprc")
	dqty   = dw_list.GetItemDecimal(lRow, "ioqty")
	damt   = Truncate(dw_list.GetItemDecimal(lRow, "ioamt"), 0) 
	
	dw_imhist.SetItem(lRowHist, "ioprc",	dprice) 				// 수불단가=0
	dw_imhist.SetItem(lRowHist, "ioreqty",	dqty) 	// 수불의뢰수량=입고수량		
	dw_imhist.SetItem(lRowHist, "iosuqty", dqty) // 합격수량=입고수량
	dw_imhist.SetItem(lRowHist, "ioqty", dqty)  // 수불수량=입고수량		
	dw_imhist.SetItem(lRowHist, "ioamt", damt)		// 수불금액=0(입고단가)
	
NEXT


////////////////////////////////////////////////////////////////////////////////
// 2002.03.21 유상웅 : 구매반품 거래명세표 생성
////////////////////////////////////////////////////////////////////////////////
//SQLCA.ERP000000580(gs_sabu, sJpno)
//IF SQLCA.SQLCODE <> 0	THEN
//	f_message_chk(32,'')
//	ROLLBACK;
//	RETURN -1
//END IF

////////////////////////////////////////////////////////////////////////////////

RETURN 1

end function

public subroutine wf_print2 (boolean printyn);long		i, lrow1, lrow2, lrowcnt1, lseq, lins, lfrow, lcnt
string	scrsjpno, sitnbr, sitdsc, scvcod, scvnas, sdate, spdtgu, sdepot, sprtjpno, sgubun

sdate = f_today()
lrowcnt1 = dw_list.rowcount()

setpointer(hourglass!)

FOR lrow1 = 1 TO lrowcnt1
	if dw_list.getitemstring(lrow1,'chk_flag') = 'N' then continue
	
	sdate = dw_list.getitemstring(lrow1,'io_date')

	lseq = sqlca.fun_junpyo(gs_sabu,sdate,'Z1')
	if lseq < 1 then
		rollback ;
		f_message_chk(51,'')
		return
	end if
	sprtjpno  = sdate + string(lseq, "0000")

	scvcod = dw_list.getitemstring(lrow1,'cvcod')
	scvnas = dw_list.getitemstring(lrow1,'cvnas')
	spdtgu = dw_list.getitemstring(lrow1,'pdtgu')
	sgubun = dw_list.getitemstring(lrow1,'gubun')
	
	// 생산팀 지정된 자재 창고
	select cvnas into :sdepot from vndmst
	 where cvgu = '5' and jumaeip = :spdtgu and soguan = '2' and rownum = 1 ;
	if sqlca.sqlcode <> 0 then sdepot = 'Z30'
	
	i = 0
	FOR lrow2 = 1 TO lrowcnt1
		lfrow = dw_list.find("chk_flag='Y' and cvcod='"+scvcod+"' and io_date='"+sdate+&
									"' and pdtgu='"+spdtgu+"' and gubun='"+sgubun+"'",lrow2,lrowcnt1)
		if lfrow > 0 then
			scrsjpno = dw_list.getitemstring(lfrow,'crsjpno')
				
			i++
			if Mod(i,5) = 1 then		// 5칸씩
				i = 1
				lins = dw_print.insertrow(0)
				dw_print.setitem(lins,'cvcod',scvcod)
				dw_print.setitem(lins,'cvnas',scvnas)
				dw_print.setitem(lins,'baldate',sdate)
				dw_print.setitem(lins,'empname',sdate)
				dw_print.setitem(lins,'pdtgu',sdepot)
				dw_print.setitem(lins,'gubun',sgubun)
			end if
			dw_print.setitem(lins,"itnbr_"+string(i),dw_list.getitemstring(lfrow,'itnbr'))
			dw_print.setitem(lins,"itdsc_"+string(i),dw_list.getitemstring(lfrow,'itdsc'))
			dw_print.setitem(lins,"unmsr_"+string(i),dw_list.getitemstring(lfrow,'unmsr'))
			dw_print.setitem(lins,"balqty_"+string(i),dw_list.getitemnumber(lfrow,'ioqty'))
			dw_print.setitem(lins,"gudat_"+string(i),f_get_reffer('33',dw_list.getitemstring(lfrow,'hcode')))
			dw_list.setitem(lfrow,'chk_flag','N') // skip 지정
			
			update shpfat_qa_sum
				set outjpno2 = :sprtjpno
			 where sabu = :gs_saupj and crsjpno = :scrsjpno ;
		else
			exit
		end if
		lrow2 = lfrow
	NEXT

	if printyn then dw_print.print()
	dw_print.reset()
NEXT

end subroutine

public subroutine wf_print (long arg_row);long		i, lins
string	scvcod, scvnas, sdate, spdtgu, sdepot, sprtjpno, sgubun
string	sitnbr, sitdsc, sunmsr, sbigo
decimal	dioqty

setpointer(hourglass!)

sprtjpno = dw_list.getitemstring(arg_row,'prtjpno')

declare c1 cursor for
	select a.cvcod, c.cvnas, b.pdtgu, a.gubun, a.io_date,
			 a.itnbr, b.itdsc, b.unmsr, a.faqty, fun_get_reffpf('33',a.hcode)
	  from shpfat_qa_sum a, itemas b, vndmst c
	 where a.sabu = :gs_saupj and a.outjpno2 = :sprtjpno
	   and a.itnbr = b.itnbr and a.cvcod = c.cvcod ;

open c1 ;

DO WHILE TRUE
	fetch c1 into :scvcod, :scvnas, :spdtgu, :sgubun, :sdate,
					  :sitnbr, :sitdsc, :sunmsr, :dioqty, :sbigo ;
	if sqlca.sqlcode <> 0 then exit
	
	// 생산팀 지정된 자재 창고
	select cvnas into :sdepot from vndmst
	 where cvgu = '5' and jumaeip = :spdtgu and soguan = '3' and rownum = 1 ;
	if sqlca.sqlcode <> 0 then sdepot = 'Z03'
	
	i++
	if Mod(i,5) = 1 then		// 5칸씩
		i = 1
		lins = dw_print.insertrow(0)
		dw_print.setitem(lins,'cvcod',scvcod)
		dw_print.setitem(lins,'cvnas',scvnas)
		dw_print.setitem(lins,'baldate',sdate)
		dw_print.setitem(lins,'empname',sdate)
		dw_print.setitem(lins,'pdtgu',sdepot)
		dw_print.setitem(lins,'gubun',sgubun)
	end if
	dw_print.setitem(lins,"itnbr_"+string(i),sitnbr)
	dw_print.setitem(lins,"itdsc_"+string(i),sitdsc)
	dw_print.setitem(lins,"unmsr_"+string(i),sunmsr)
	dw_print.setitem(lins,"balqty_"+string(i),dioqty)
	dw_print.setitem(lins,"gudat_"+string(i),sbigo)

LOOP

close c1 ;

dw_print.print()
dw_print.reset()

end subroutine

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
dw_detail.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_1.settransobject(sqlca)

rb_insert.TriggerEvent("clicked")
end event

on w_mm04_00010.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.cb_2=create cb_2
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_1=create p_1
this.dw_imhist=create dw_imhist
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
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.rr_4=create rr_4
this.Control[]={this.cb_2,&
this.dw_1,&
this.pb_2,&
this.pb_1,&
this.p_1,&
this.dw_imhist,&
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
this.dw_list,&
this.cbx_1,&
this.dw_print,&
this.rr_4}
end on

on w_mm04_00010.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.dw_imhist)
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
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.rr_4)
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

type cb_2 from commandbutton within w_mm04_00010
integer x = 3040
integer y = 24
integer width = 343
integer height = 148
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "금액 재계산"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_detail.accepttext() = -1 then return

string	sfdate, stdate, scvcod, sgubun

sfdate = trim(dw_detail.getitemstring(1,'fdate'))
stdate = trim(dw_detail.getitemstring(1,'tdate'))
scvcod = dw_detail.getitemstring(1,'cvcod')

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

if isnull(scvcod) or scvcod = '' then 
	f_message_chk(30,'[거래처]')
	dw_detail.setcolumn('cvcod')
	dw_detail.setfocus()
	return
end if

setpointer(hourglass!)

update shpfat_qa_detail a set a.ioprc = (select fun_danmst_danga10(b.cdate,a.cvcod,a.cinbr,'.') +
                                                  decode(c.ittyp,'A',ERP_CALC_PSTRUC(a.cinbr,1,b.cdate,'1','Y'),0)
														from shpfat_qa_sum b,
														     itemas        c
													  where a.sabu    = b.sabu 
														 and a.crsjpno = b.crsjpno
														 and b.cdate   between :sFdate and :sTdate
														 and b.cvcod   = :scvcod
														 and b.outjpno is null
														 and a.cinbr   = c.itnbr)
							  where exists (select *
													from shpfat_qa_sum b
												  where a.sabu    = b.sabu 
													 and a.crsjpno = b.crsjpno
													 and b.cdate   between :sFdate and :sTdate
													 and b.cvcod   = :scvcod
													 and b.outjpno is null);

update shpfat_qa_detail a set a.ioamt = a.ioprc * a.faqty
							  where exists (select *
													from shpfat_qa_sum b
												  where a.sabu    = b.sabu 
													 and a.crsjpno = b.crsjpno
													 and b.cdate   between :sFdate and :sTdate
													 and b.cvcod   = :scvcod
													 and b.outjpno is null);

update shpfat_qa_sum a set a.ioamt = (select sum(b.ioamt)
													from shpfat_qa_detail b
												  where a.sabu    = b.sabu 
													 and a.crsjpno = b.crsjpno
													 and a.cdate   between :sFdate and :sTdate
													 and a.cvcod   = :scvcod)
		  where exists (select *
								from shpfat_qa_detail b
							  where a.sabu    = b.sabu 
								 and a.crsjpno = b.crsjpno
								 and a.cdate   between :sFdate and :sTdate
								 and a.cvcod   = :scvcod
								 and a.outjpno is null);

commit;

IF SQLCA.SQLCode <> 0 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	rollback;
	return
End if;
messagebox('확인','자료를 저장하였습니다.')
p_inq.TriggerEvent(Clicked!)
dw_1.reset()


//update shpfat_qa_detail a set (a.ioprc, a.ioamt) = (select fun_danmst_danga10(b.cdate,b.cvcod,a.cinbr,'.'),
//                                                           fun_danmst_danga10(b.cdate,b.cvcod,a.cinbr,'.') * a.faqty
//																		from shpfat_qa_sum b
//																	  where a.sabu    = b.sabu 
//																		 and a.crsjpno = b.crsjpno
//																		 and b.cdate   between :sFdate and :sTdate
//																		 and b.cvcod   = :scvcod
//																		 and b.outjpno is null)
//							  where exists (select *
//													from shpfat_qa_sum b
//												  where a.sabu    = b.sabu 
//													 and a.crsjpno = b.crsjpno
//													 and b.cdate   between :sFdate and :sTdate
//													 and b.cvcod   = :scvcod
//													 and b.outjpno is null);

end event

type dw_1 from datawindow within w_mm04_00010
integer x = 69
integer y = 1624
integer width = 4133
integer height = 668
integer taborder = 40
boolean titlebar = true
string title = "불량단품 내역"
string dataobject = "d_mm04_00010_d"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_2 from u_pb_cal within w_mm04_00010
integer x = 814
integer y = 48
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_detail.SetColumn('fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_detail.SetItem(1, 'fdate', gs_code)

end event

type pb_1 from u_pb_cal within w_mm04_00010
integer x = 1262
integer y = 48
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_detail.SetColumn('tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_detail.SetItem(1, 'tdate', gs_code)

end event

type p_1 from picture within w_mm04_00010
integer x = 3977
integer y = 60
integer width = 178
integer height = 144
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\인쇄_up.gif"
boolean focusrectangle = false
end type

event clicked;if ic_status = '1' then
	messagebox('확인','수정 상태에서만 반송장 출력이 가능합니다!!!')
	return
end if

long	lrow

lrow = dw_list.getselectedrow(0)
if lrow < 1 then return

if messagebox('확인','불량 반송장을 출력하시겠습니까?',question!,yesno!,1) = 2 then
	return
end if

wf_print(lrow)
end event

type dw_imhist from datawindow within w_mm04_00010
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

type p_delrow from uo_picture within w_mm04_00010
boolean visible = false
integer x = 4869
integer y = 228
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_addrow from uo_picture within w_mm04_00010
boolean visible = false
integer x = 4690
integer y = 228
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from uo_picture within w_mm04_00010
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

type p_exit from uo_picture within w_mm04_00010
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

type p_can from uo_picture within w_mm04_00010
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

type p_del from uo_picture within w_mm04_00010
integer x = 3803
integer y = 60
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
if ic_status = '1' then 
		messagebox('확인','수정 상태 일때만 삭제 가능합니다.')
	return
end if

long		i, lrow
string	sabu, sjpno, sgubun, serror, serrtxt

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	i++
NEXT
if i < 1 then return

if messagebox('확인','선택된 자료를 삭제합니다.',question!,yesno!,1) = 2 then return


setpointer(hourglass!)
FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue

	sabu  = dw_list.getitemstring(lrow,'sabu')
	sjpno = dw_list.getitemstring(lrow,'shpjpno')
	sgubun= dw_list.getitemstring(lrow,'gubun')
	
	if sgubun = '1' then
		/* 반품 수불 삭제 - 2004.02.20 */
		serror = 'N'
		sqlca.pu_banpum_imhist_delete(gs_saupj,sjpno,serror) ;
		if serror <> 'N' then
//			serrtxt = sqlca.sqlerrtext
			rollback;
			messagebox('ERROR','매입 반품 삭제시 DB ERROR !!!')
			return
		end if		

		update shpfat_qa_sum
			set outjpno = null, io_date = null, gubun = null, outjpno2 = null
		 where sabu = :gs_saupj and outjpno = :sjpno ;
		if sqlca.sqlcode <> 0 then
			rollback ;
			messagebox('확인','자료 삭제 실패!!!')
			return
		end if
	else
		update shpfat_qa_sum
			set outjpno = null, io_date = null, gubun = null, outjpno2 = null
		 where sabu = :gs_saupj and crsjpno = :sjpno ;
		if sqlca.sqlcode <> 0 then
			rollback ;
			messagebox('확인','자료 삭제 실패!!!')
			return
		end if
	end if		

NEXT

commit ;
messagebox('확인','자료를 삭제하였습니다.')
p_can.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_mm04_00010
integer x = 3630
integer y = 60
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

string	sdate, snull, serror, serrtxt
long		i, lrow, lseq

setnull(snull)
if dw_list.rowcount() < 1 then return

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'Y' then
		i++
	else
		dw_list.setitem(lrow,'io_date',snull)
		dw_list.setitem(lrow,'outjpno',snull)
		dw_list.setitem(lrow,'gubun',snull)
	end if
	
//	dw_list.setitem(lrow,'ioamt', dw_list.GetItemNumber(lrow, 'vamt'))
NEXT
if i < 1 then 
	messagebox('확인','처리할 자료를 선택하세요!!!')
	return
end if
	
if dw_detail.accepttext() = -1 then return
if dw_list.accepttext() = -1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

setpointer(hourglass!)
if ic_status = '1' then
	if dw_list.update() <> 1 then
		rollback ;
		messagebox('확인','수정불합격 갱신실패!!!')
		return
	end if

	
	/* 반품 수불 생성 - 2004.02.20 */
	serror = 'N'
	sqlca.pu_banpum_imhist(gs_saupj,gs_empno,gs_dept,serror) ;
	if serror <> 'N' then
//		serrtxt = sqlca.sqlerrtext
		rollback;
		messagebox('ERROR','매입 반품 처리시 DB ERROR !!!')
		return
	end if	

	if messagebox('확인','불량 반송장을 출력하시겠습니까?',question!,yesno!,1) = 1 then
		wf_print2(true)
	else
		wf_print2(false)
	end if

end if

commit ;

messagebox('확인','자료를 저장하였습니다.')
p_inq.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_mm04_00010
integer x = 3456
integer y = 60
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_detail.accepttext() = -1 then return

cbx_1.checked = false

string	sfdate, stdate, scvcod, sgubun

sfdate = trim(dw_detail.getitemstring(1,'fdate'))
stdate = trim(dw_detail.getitemstring(1,'tdate'))
scvcod = dw_detail.getitemstring(1,'cvcod')
sgubun = dw_detail.getitemstring(1,'gubun')

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

if isnull(scvcod) or scvcod = '' then
	f_message_chk(30,'[거래처]')
	dw_detail.setcolumn('cvcod')
	dw_detail.setfocus()
	return
end if

setpointer(hourglass!)
if dw_list.retrieve(gs_saupj,sfdate,stdate,scvcod,sgubun) < 1 then
	f_message_chk(50, '[매입 반품]')
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

type cb_1 from commandbutton within w_mm04_00010
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

type cb_delete from commandbutton within w_mm04_00010
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

type cb_cancel from commandbutton within w_mm04_00010
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

type rb_delete from radiobutton within w_mm04_00010
integer x = 2738
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

type rb_insert from radiobutton within w_mm04_00010
integer x = 2738
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

type dw_detail from datawindow within w_mm04_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 82
integer y = 48
integer width = 2487
integer height = 172
integer taborder = 10
string dataobject = "d_mm04_00010_1"
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

event rbuttondown;string	snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 거래처
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	open(w_vndmst_popup)

	if Isnull(gs_code) or Trim(gs_code) = "" then 
		this.SetItem(1, "cvnas", snull)
	else
		this.SetItem(1, "cvcod", gs_code)
		this.SetItem(1, "cvnas", gs_codename)
	end if

END IF

end event

event itemchanged;string	scvcod, scvnas, snull

setnull(snull)

if this.getcolumnname() = 'cvcod' then
	scvcod = this.gettext()
	
	select cvnas into :scvnas from vndmst
	 where cvcod = :scvcod ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',scvnas)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
	
end if
end event

type cb_save from commandbutton within w_mm04_00010
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

type cb_exit from commandbutton within w_mm04_00010
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

type cb_retrieve from commandbutton within w_mm04_00010
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

type rr_1 from roundrectangle within w_mm04_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 16
integer width = 2569
integer height = 236
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_mm04_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2679
integer y = 16
integer width = 325
integer height = 236
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_mm04_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 276
integer width = 4526
integer height = 1312
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_mm04_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 288
integer width = 4503
integer height = 1252
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mm04_00010_a"
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

event itemerror;//////////////////////////////////////////////////////////////////////////////
////		* Error Message Handling  1
//////////////////////////////////////////////////////////////////////////////
//
////	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 
//
//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF
//
//
//
////	2) Required Column  에서 Error 발생시 
//
//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//w_mdi_frame.sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
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

event itemchanged;string	schk, sdate, slast, snull, sgubun

setnull(snull)

if ic_status = '1' and this.getcolumnname() = 'chk_flag' then
	schk = this.gettext()
	sdate= trim(this.getitemstring(row,'cdate'))
	
//	SELECT TO_CHAR(LAST_DAY(TO_DATE(:sdate,'YYYYMMDD')),'YYYYMMDD') 
//	  INTO :slast
//	  FROM DUAL ;

	if schk = 'Y' then
		this.setitem(row,'io_date',sdate)
	else
		this.setitem(row,'gubun',snull)
		this.setitem(row,'io_date',snull)
		this.setitem(row,'outjpno',snull)
	end if
end if
end event

event clicked;String sCrsjpno, sBgbn

If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	if ic_status = '1' then
		sCrsjpno = dw_list.GetItemString(row, 'crsjpno')
   Else
		sCrsjpno = dw_list.GetItemString(row, 'shpjpno')
	End if
   dw_1.retrieve(gs_saupj, sCrsjpno)	
	
END IF

end event

type cbx_1 from checkbox within w_mm04_00010
integer x = 78
integer y = 296
integer width = 78
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 28144969
end type

event clicked;long		lrow
string	snull

setnull(snull)

dw_list.setredraw(false)
if this.checked then
	FOR lrow = 1 TO dw_list.rowcount()
		if dw_list.getitemstring(lrow,'chk_flag') = 'Y' then continue
		dw_list.setitem(lrow,'chk_flag','Y')
		if ic_status = '2' then continue
		
		dw_list.setitem(lrow,'io_date',trim(dw_list.getitemstring(lrow,'cdate')))
		dw_list.setitem(lrow,'gubun','1')
	NEXT
else
	FOR lrow = 1 TO dw_list.rowcount()
		if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
		dw_list.setitem(lrow,'chk_flag','N')
		if ic_status = '2' then continue
		
		dw_list.setitem(lrow,'io_date',snull)
		dw_list.setitem(lrow,'gubun',snull)
	NEXT
end if
dw_list.setredraw(true)
end event

type dw_print from datawindow within w_mm04_00010
boolean visible = false
integer x = 727
integer y = 468
integer width = 2299
integer height = 1228
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_mm04_00010_c"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_4 from roundrectangle within w_mm04_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 50
integer y = 1612
integer width = 4526
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

