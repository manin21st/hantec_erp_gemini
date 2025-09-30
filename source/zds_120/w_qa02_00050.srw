$PBExportHeader$w_qa02_00050.srw
$PBExportComments$** 수정불합격 처리
forward
global type w_qa02_00050 from w_inherite
end type
type dw_1 from datawindow within w_qa02_00050
end type
type rr_1 from roundrectangle within w_qa02_00050
end type
type tab_1 from tab within w_qa02_00050
end type
type tabpage_1 from userobject within tab_1
end type
type pb_2 from u_pb_cal within tabpage_1
end type
type pb_1 from u_pb_cal within tabpage_1
end type
type p_t1 from picture within tabpage_1
end type
type cbx_t1 from checkbox within tabpage_1
end type
type dw_t1_0 from datawindow within tabpage_1
end type
type rr_2 from roundrectangle within tabpage_1
end type
type dw_t1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
pb_2 pb_2
pb_1 pb_1
p_t1 p_t1
cbx_t1 cbx_t1
dw_t1_0 dw_t1_0
rr_2 rr_2
dw_t1 dw_t1
end type
type tabpage_2 from userobject within tab_1
end type
type p_t2 from picture within tabpage_2
end type
type dw_t2_0 from datawindow within tabpage_2
end type
type rr_3 from roundrectangle within tabpage_2
end type
type dw_t2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
p_t2 p_t2
dw_t2_0 dw_t2_0
rr_3 rr_3
dw_t2 dw_t2
end type
type tabpage_3 from userobject within tab_1
end type
type p_1 from picture within tabpage_3
end type
type p_sub from picture within tabpage_3
end type
type p_add from picture within tabpage_3
end type
type dw_t3_0 from datawindow within tabpage_3
end type
type rr_5 from roundrectangle within tabpage_3
end type
type dw_t3_2 from datawindow within tabpage_3
end type
type rr_4 from roundrectangle within tabpage_3
end type
type dw_t3_1 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
p_1 p_1
p_sub p_sub
p_add p_add
dw_t3_0 dw_t3_0
rr_5 rr_5
dw_t3_2 dw_t3_2
rr_4 rr_4
dw_t3_1 dw_t3_1
end type
type tab_1 from tab within w_qa02_00050
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type rb_1 from radiobutton within w_qa02_00050
end type
type rb_2 from radiobutton within w_qa02_00050
end type
type dw_shpfat_qa from datawindow within w_qa02_00050
end type
type p_2 from picture within w_qa02_00050
end type
type p_3 from picture within w_qa02_00050
end type
type dw_t2_dump from datawindow within w_qa02_00050
end type
end forward

global type w_qa02_00050 from w_inherite
integer height = 2352
string title = "수정 불합격 처리"
dw_1 dw_1
rr_1 rr_1
tab_1 tab_1
rb_1 rb_1
rb_2 rb_2
dw_shpfat_qa dw_shpfat_qa
p_2 p_2
p_3 p_3
dw_t2_dump dw_t2_dump
end type
global w_qa02_00050 w_qa02_00050

type variables
string	ic_status
end variables

forward prototypes
public function integer wf_tabpage_3_required_chk ()
public subroutine wf_refresh_qty (integer oldindex, integer newindex)
public subroutine wf_dw_t2_vs_dump (string arg_gubun)
public subroutine wf_modify_setitem (string arg_gubun, string arg_jpno)
public subroutine wf_tabpage_1_retrieve ()
public subroutine wf_initial ()
public function integer wf_new_send ()
public function integer wf_re_send ()
public function integer wf_create_shpfat_qa_sum (string arg_jpno)
public function integer wf_tabpage_1_all_apply ()
public function integer wf_tabpage_2_all_apply ()
end prototypes

public function integer wf_tabpage_3_required_chk ();long		lrow, lqty, lsumqty1, lsumqty2
string	sitnbr, scvcod, sapear, scause 

tab_1.tabpage_3.dw_t3_2.accepttext()

FOR lRow = 1 TO tab_1.tabpage_3.dw_t3_2.RowCount()
	
	// 외주품번
	sitnbr = tab_1.tabpage_3.dw_t3_2.getitemstring(lrow,'itnbr')
	if isnull(sitnbr) or sitnbr = '' then
		f_message_chk(30,'[외주품번]')
		tab_1.tabpage_3.dw_t3_2.ScrollToRow(lrow)
		tab_1.tabpage_3.dw_t3_2.Setcolumn("itnbr")
		tab_1.tabpage_3.dw_t3_2.setfocus()
		return -1
	end if
//	
	// 외주업체
	scvcod = tab_1.tabpage_3.dw_t3_2.getitemstring(lrow,'cvcod')
	if isnull(scvcod) or scvcod = '' then
		f_message_chk(30,'[외주업체]')
		tab_1.tabpage_3.dw_t3_2.ScrollToRow(lrow)
		tab_1.tabpage_3.dw_t3_2.Setcolumn("cvcod")
		tab_1.tabpage_3.dw_t3_2.setfocus()
		return -1
	end if

	// 현상코드
	sapear = tab_1.tabpage_3.dw_t3_2.getitemstring(lrow,'hcode')
	if isnull(sapear) or sapear = '' then
		f_message_chk(30,'[현상코드]')
		tab_1.tabpage_3.dw_t3_2.ScrollToRow(lrow)
		tab_1.tabpage_3.dw_t3_2.Setcolumn("hcode")
		tab_1.tabpage_3.dw_t3_2.setfocus()
		return -1
	end if
	
	// 원인코드
//	scause = tab_1.tabpage_3.dw_t3_2.getitemstring(lrow,'wcode')
//	if isnull(scause) or scause = '' then
//		f_message_chk(30,'[원인코드]')
//		tab_1.tabpage_3.dw_t3_2.ScrollToRow(lrow)
//		tab_1.tabpage_3.dw_t3_2.Setcolumn("wcode")
//		tab_1.tabpage_3.dw_t3_2.setfocus()
//		return -1
//	end if
	
	// 불량수량
	lqty = tab_1.tabpage_3.dw_t3_2.Getitemnumber(lRow, "qaqty")
	if isnull(lqty) or lqty <= 0 then
		f_message_chk(30,'[불량수량]')
		tab_1.tabpage_3.dw_t3_2.ScrollToRow(lrow)
		tab_1.tabpage_3.dw_t3_2.Setcolumn("qaqty")
		tab_1.tabpage_3.dw_t3_2.setfocus()
		return -1
	end if
NEXT

if	tab_1.tabpage_3.dw_t3_1.RowCount() > 0	then
	lsumqty1 = tab_1.tabpage_3.dw_t3_1.Getitemnumber(1, "sum_qty")
else
	lsumqty1 = 0
end if	

if	tab_1.tabpage_3.dw_t3_2.RowCount() > 0	then
 	lsumqty2 = tab_1.tabpage_3.dw_t3_2.Getitemnumber(1, "sum_qty")
else
	lsumqty2 = 0
end if	

if lsumqty2 > lsumqty1 then
	messagebox('확인','품질판정수량이 생산판정수량을 초과합니다')
	return -1
end if

RETURN 1
end function

public subroutine wf_refresh_qty (integer oldindex, integer newindex);long		lfrow
string	skey, sgubun
decimal	dqty

if oldindex = 3 and newindex = 2 then
	sgubun = '1'
elseif oldindex = 2 and newindex = 1 then
	sgubun = '2'
elseif oldindex = 3 and newindex = 1 then
	sgubun = '3'
end if

if sgubun = '1' or sgubun = '3' then
	skey = tab_1.tabpage_3.dw_t3_0.getitemstring(1,'shpjpno')
	
	if tab_1.tabpage_3.dw_t3_2.rowcount() > 0 then
		dqty = tab_1.tabpage_3.dw_t3_2.getitemnumber(1,'sum_qty')
	else
		dqty = 0
	end if
	
	lfrow = tab_1.tabpage_2.dw_t2.find("shpjpno='"+skey+"'",1, &
													tab_1.tabpage_2.dw_t2.rowcount())
	if lfrow > 0 then tab_1.tabpage_2.dw_t2.setitem(lfrow,'qasqty',dqty)
end if


if sgubun = '2' or sgubun = '3' then
	skey = tab_1.tabpage_2.dw_t2_0.getitemstring(1,'itnbr')
	
	if tab_1.tabpage_2.dw_t2.rowcount() > 0 then
		dqty = tab_1.tabpage_2.dw_t2.getitemnumber(1,'sum_qty')
	else
		dqty = 0
	end if
	
	lfrow = tab_1.tabpage_1.dw_t1.find("itnbr='"+skey+"'",1, &
													tab_1.tabpage_1.dw_t1.rowcount())
	if lfrow > 0 then 
		tab_1.tabpage_1.dw_t1.setitem(lfrow,'qsqty',dqty)
		if dqty > 0 then tab_1.tabpage_1.dw_t1.setitem(lfrow,'fag_yn','Y')
	end if
end if
end subroutine

public subroutine wf_dw_t2_vs_dump (string arg_gubun);long		lrow, lfrow, lins
string	shpjpno, itnbr, sidat, opsno, fag_yn
string	wai_itnbr, wai_itdsc, wai_cvcod, wai_cvnas

if ic_status = '2' then return

IF arg_gubun = '1' THEN
	FOR lrow = 1 TO tab_1.tabpage_2.dw_t2.rowcount()
		shpjpno	= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'shpjpno')
		itnbr		= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'itnbr')
		sidat		= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'sidat')
		opsno		= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'opsno')
		fag_yn	= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'fag_yn')
		wai_itnbr= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'wai_itnbr')
		wai_itdsc= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'wai_itdsc')
		wai_cvcod= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'wai_cvcod')
		wai_cvnas= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'wai_cvnas')
		
		lfrow = dw_t2_dump.find("shpjpno='"+shpjpno+"'",1,dw_t2_dump.rowcount())
		if lfrow > 0 then
			lins = lfrow
		else
			lins = dw_t2_dump.insertrow(0)
		end if
		
		dw_t2_dump.setitem(lins,'shpjpno',shpjpno)
		dw_t2_dump.setitem(lins,'itnbr',itnbr)
		dw_t2_dump.setitem(lins,'sidat',sidat)
		dw_t2_dump.setitem(lins,'opsno',opsno)
		dw_t2_dump.setitem(lins,'fag_yn',fag_yn)
		dw_t2_dump.setitem(lins,'wai_itnbr',wai_itnbr)
		dw_t2_dump.setitem(lins,'wai_itdsc',wai_itdsc)
		dw_t2_dump.setitem(lins,'wai_cvcod',wai_cvcod)
		dw_t2_dump.setitem(lins,'wai_cvnas',wai_cvnas)
	NEXT

ELSE
	FOR lrow = 1 TO dw_t2_dump.rowcount()
		shpjpno	= dw_t2_dump.getitemstring(lrow,'shpjpno')
		itnbr		= dw_t2_dump.getitemstring(lrow,'itnbr')
		sidat		= dw_t2_dump.getitemstring(lrow,'sidat')
		opsno		= dw_t2_dump.getitemstring(lrow,'opsno')
		fag_yn	= dw_t2_dump.getitemstring(lrow,'fag_yn')
		wai_itnbr= dw_t2_dump.getitemstring(lrow,'wai_itnbr')
		wai_itdsc= dw_t2_dump.getitemstring(lrow,'wai_itdsc')
		wai_cvcod= dw_t2_dump.getitemstring(lrow,'wai_cvcod')
		wai_cvnas= dw_t2_dump.getitemstring(lrow,'wai_cvnas')
		
		lfrow = tab_1.tabpage_2.dw_t2.find("shpjpno='"+shpjpno+"'",1,tab_1.tabpage_2.dw_t2.rowcount())
		if lfrow > 0 then
			tab_1.tabpage_2.dw_t2.setitem(lfrow,'fag_yn',fag_yn)
			tab_1.tabpage_2.dw_t2.setitem(lfrow,'wai_itnbr',wai_itnbr)
			tab_1.tabpage_2.dw_t2.setitem(lfrow,'wai_itdsc',wai_itdsc)
			tab_1.tabpage_2.dw_t2.setitem(lfrow,'wai_cvcod',wai_cvcod)
			tab_1.tabpage_2.dw_t2.setitem(lfrow,'wai_cvnas',wai_cvnas)
		end if
	NEXT
END IF
end subroutine

public subroutine wf_modify_setitem (string arg_gubun, string arg_jpno);long		lrow, lcnt
string	sitnbr, scinbr, scidsc, scvcod, scvnas, shpjpno, strans, snull

if ic_status = '1' then return

setnull(snull)

if arg_gubun = '1' then
	FOR lrow = 1 TO tab_1.tabpage_1.dw_t1.rowcount()
		sitnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
		
		select distinct a.itnbr, c.itdsc, a.cvcod, d.cvnas
		  into :scinbr, :scidsc, :scvcod, :scvnas
		  from shpfat_qa 	a,
				 shpact		b,
				 itemas		c,
				 vndmst		d
		 where a.sabu = :gs_saupj
			and a.crjpno = :arg_jpno
			and a.sabu = b.sabu
			and a.shpjpno = b.shpjpno
			and b.itnbr = :sitnbr
			and a.itnbr = c.itnbr
			and a.cvcod = d.cvcod ;
		
		if sqlca.sqlcode = 0 then
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itnbr',scinbr)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itdsc',scidsc)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvcod',scvcod)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvnas',scvnas)
		else
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itnbr',snull)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itdsc',snull)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvcod',snull)
			tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvnas',snull)
		end if
	NEXT

	select count(*) into :lcnt from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :arg_jpno and transyn = 'Y' ;
	if lcnt = 0 then
		tab_1.tabpage_1.dw_t1.modify("fag_yn.visible=1")
		tab_1.tabpage_1.dw_t1.modify("t_check.visible=0")
	else
		tab_1.tabpage_1.dw_t1.modify("fag_yn.visible=0")
		tab_1.tabpage_1.dw_t1.modify("t_check.visible=1")
	end if			

else
	FOR lrow = 1 TO tab_1.tabpage_2.dw_t2.rowcount()
		shpjpno= tab_1.tabpage_2.dw_t2.getitemstring(lrow,'shpjpno')
		
		select distinct a.itnbr, c.itdsc, a.cvcod, d.cvnas
		  into :scinbr, :scidsc, :scvcod, :scvnas
		  from shpfat_qa 	a,
				 shpact		b,
				 itemas		c,
				 vndmst		d
		 where a.sabu = :gs_saupj
			and a.crjpno = :arg_jpno
			and a.sabu = b.sabu
			and a.shpjpno = b.shpjpno
			and b.shpjpno = :shpjpno
			and a.itnbr = c.itnbr
			and a.cvcod = d.cvcod ;
		
		if sqlca.sqlcode = 0 then
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_itnbr',scinbr)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_itdsc',scidsc)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_cvcod',scvcod)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_cvnas',scvnas)
		else
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_itnbr',snull)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_itdsc',snull)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_cvcod',snull)
			tab_1.tabpage_2.dw_t2.setitem(lrow,'wai_cvnas',snull)
		end if
	NEXT

	select count(*) into :lcnt from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :arg_jpno and transyn = 'Y' ;
	if lcnt = 0 then
		tab_1.tabpage_2.dw_t2.modify("fag_yn.visible=1")
		tab_1.tabpage_2.dw_t2.modify("t_check.visible=0")
	else
		tab_1.tabpage_2.dw_t2.modify("fag_yn.visible=0")
		tab_1.tabpage_2.dw_t2.modify("t_check.visible=1")
	end if			
end if
end subroutine

public subroutine wf_tabpage_1_retrieve ();long		lcnt
string 	ssdate, sedate, sitnbr, sjpno, spdtgu, snull

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

ssdate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "sdate"))
sedate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "edate"))
sitnbr  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "itnbr"))
sjpno	  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
spdtgu  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "pdtgu"))

if isnull(ssdate) or trim(ssdate) = '' then ssdate = '10000101'
if isnull(sedate) or trim(sedate) = '' then ssdate = '99991231'
if isnull(sitnbr) or trim(sitnbr) = '' then sitnbr = '%'

if ic_status = '2' then
	if isnull(sjpno) or trim(sjpno) = '' then
		messagebox('확인','처리번호를 지정하세요!!!')
		return
	end if
	select count(*) into :lcnt from shpfat_qa_cnf
	 where sabu = :gs_saupj and crjpno = :sjpno ;
	if lcnt = 0 then
		messagebox('확인','잘못된 처리번호입니다.')
		return
	end if
end if

if tab_1.tabpage_1.dw_t1.retrieve(gs_saupj,ssdate,sedate,sitnbr,sjpno,spdtgu) > 0 then
else
   f_message_chk(50, '[수정불합격처리-품목별 집계]')
end if

// 수정 모드에서 외주품번 및 외주업체 지정
wf_modify_setitem('1',sjpno)

end subroutine

public subroutine wf_initial ();tab_1.tabpage_1.dw_t1_0.reset()
tab_1.tabpage_1.dw_t1.reset()
tab_1.tabpage_2.dw_t2_0.reset()
tab_1.tabpage_2.dw_t2.reset()
tab_1.tabpage_3.dw_t3_0.reset()
tab_1.tabpage_3.dw_t3_1.reset()
tab_1.tabpage_3.dw_t3_2.reset()

if ic_status = '1' then
	tab_1.tabpage_1.dw_t1_0.dataobject 	= 'd_qa02_00050_02'
	tab_1.tabpage_1.dw_t1.dataobject 	= 'd_qa02_00050_00'
	tab_1.tabpage_2.dw_t2_0.dataobject 	= 'd_qa02_00050_03'
	tab_1.tabpage_2.dw_t2.dataobject 	= 'd_qa02_00050_01'
	dw_t2_dump.dataobject 					= 'd_qa02_00050_01'
	tab_1.tabpage_1.cbx_t1.visible 	= true
	tab_1.tabpage_1.p_t1.visible 		= false
	tab_1.tabpage_2.p_t2.visible 		= false

	tab_1.tabpage_1.pb_2.visible 		= true
	tab_1.tabpage_1.pb_1.x 				= 690
	
	p_print.visible 	= true
	p_del.visible 		= false
	p_mod.visible 		= false
else
	tab_1.tabpage_1.dw_t1_0.dataobject = 'd_qa02_00050_02_1'
	tab_1.tabpage_1.dw_t1.dataobject = 'd_qa02_00050_00_1'
	tab_1.tabpage_2.dw_t2_0.dataobject = 'd_qa02_00050_03_1'
	tab_1.tabpage_2.dw_t2.dataobject = 'd_qa02_00050_01_1'
	dw_t2_dump.dataobject = 'd_qa02_00050_01_1'
	tab_1.tabpage_1.cbx_t1.visible 	= false
	tab_1.tabpage_1.p_t1.visible 		= true
	tab_1.tabpage_2.p_t2.visible 		= true
	
	tab_1.tabpage_1.pb_2.visible 		= false
	tab_1.tabpage_1.pb_1.x 				= 1770
	
	p_print.visible 	= false
	p_del.visible 		= true
	p_mod.visible 		= true
end if

tab_1.tabpage_1.dw_t1.settransobject(sqlca)
tab_1.tabpage_2.dw_t2.settransobject(sqlca)
	
tab_1.tabpage_1.dw_t1_0.insertrow(0)
tab_1.tabpage_2.dw_t2_0.insertrow(0)
tab_1.tabpage_3.dw_t3_0.insertrow(0)

tab_1.tabpage_1.dw_t1_0.Object.sdate[1] = left(f_today(),6) + '01'
tab_1.tabpage_1.dw_t1_0.Object.edate[1] = f_today()

tab_1.selecttab(1)

tab_1.tabpage_1.dw_t1_0.setfocus()

dw_1.insertrow(0)
///* User별 사업장 Setting Start */
//String saupj
// 
//If f_check_saupj(saupj) = 1 Then
//	dw_1.Modify("saupj.protect=1")
//End If
f_mod_saupj(dw_1, 'saupj')
dw_1.SetItem(1, 'saupj', gs_saupj)


end subroutine

public function integer wf_new_send ();long		lseq, lcnt
string	scrjpno, sjpno, sdate, sitnbr, ssdate, sedate, spdtgu, scnfirm
long		lrow, lrowcnt, lrow2, lrowcnt2, lrow3, lrowcnt3, lrow4, lrowcnt4, lfrow

if messagebox('확인','저장 하시겠습니까?',question!,yesno!,1) = 2 then 
	return -1
end if

if tab_1.selectedtab <> 1 then tab_1.selecttab(1)

setpointer(hourglass!)
//////////////////////////////////////////////////////////////////////////////////
sdate = f_today()
lseq = sqlca.fun_junpyo(gs_sabu,sdate,'Q2')
if lseq = -1 then 
	rollback;
	f_message_chk(51, '')
	return -1
end if
commit;
scrjpno = 'CR' + mid(sdate,3) + string(lseq,'0000')


//////////////////////////////////////////////////////////////////////////////////
ssdate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "sdate"))
sedate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "edate"))
spdtgu  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "pdtgu"))

lrowcnt = tab_1.tabpage_1.dw_t1.rowcount()
FOR lrow = 1 TO lrowcnt
	sitnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
	scnfirm= tab_1.tabpage_1.dw_t1.getitemstring(lrow,'fag_yn')
	if scnfirm = 'N' then continue
	
	lrowcnt2 = tab_1.tabpage_2.dw_t2.retrieve(gs_saupj,ssdate,sedate,sitnbr,scrjpno,spdtgu)
	FOR lrow2 = 1 TO lrowcnt2
		sjpno = tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'shpjpno')

		lrowcnt3 = tab_1.tabpage_3.dw_t3_2.retrieve(gs_saupj,sjpno)
		FOR lrow3 = 1 TO lrowcnt3
			tab_1.tabpage_3.dw_t3_2.setitem(lrow3,'crjpno',scrjpno)
			tab_1.tabpage_3.dw_t3_2.setitem(lrow3,'cdate',sdate)
		NEXT
		
		if tab_1.tabpage_3.dw_t3_2.rowcount() > 0 then
			tab_1.tabpage_3.dw_t3_2.accepttext()
			if tab_1.tabpage_3.dw_t3_2.update() <> 1 then
				rollback ;
				messagebox('확인','[ '+sitnbr+' : '+string(sjpno,'@@@@@@@@-@@@@')+ '] ~n저장 실패')
				return -1
			end if
		end if
		tab_1.tabpage_3.dw_t3_2.reset()
		
		/////////////////////////////////////////////////////////////////////////////////////////
		// QA 확인 여부  -2004.02.06
		lrowcnt4 = tab_1.tabpage_3.dw_t3_1.retrieve(gs_saupj,sjpno)
		FOR lrow4 = 1 TO lrowcnt4
			tab_1.tabpage_3.dw_t3_1.setitem(lrow4,'gugub','Y')	// QA 확인
		NEXT
		
		if tab_1.tabpage_3.dw_t3_1.rowcount() > 0 then
			tab_1.tabpage_3.dw_t3_1.accepttext()
			if tab_1.tabpage_3.dw_t3_1.update() <> 1 then
				rollback ;
				messagebox('확인','[ '+sitnbr+' : '+string(sjpno,'@@@@@@@@-@@@@')+ '] ~n저장 실패')
				return -1
			end if
		end if
		
		select count(*) into :lcnt from shpfat_qa_cnf
		 where sabu = :gs_saupj and crjpno = :scrjpno and shpjpno = :sjpno ;
		if lcnt = 0 then
			insert into shpfat_qa_cnf
			( sabu,			crjpno,		shpjpno,			cdate )
			values
			( :gs_saupj,		:scrjpno,	:sjpno,			:sdate ) ;
		end if
	NEXT
NEXT

if wf_create_shpfat_qa_sum(scrjpno) = -1 then return -1

return 1
end function

public function integer wf_re_send ();long		lseq, lcnt
string	scrjpno, sjpno, sitnbr, ssdate, sedate, spdtgu, sdate
long		lrow, lrowcnt, lrow2, lrowcnt2, lrow3, lrowcnt3, lrow4, lrowcnt4, lfrow

scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
select count(*) into :lcnt from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :scrjpno and rownum = 1 ;
if lcnt = 0 then
	messagebox('확인','잘못된 처리번호입니다.')
	return -1
end if

//select count(*) into :lcnt from shpfat_qa_sum
// where sabu = :gs_saupj and crjpno = :scrjpno and rownum = 1 ;
//if lcnt > 0 then
//	messagebox('확인','이미 통보된 자료입니다.')
//	return -1
//end if

if messagebox('확인','저장 하시겠습니까?',question!,yesno!,1) = 2 then 
	return -1
end if

if tab_1.selectedtab <> 1 then tab_1.selecttab(1)

setpointer(hourglass!)

sdate = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'sdate'))
//sdate = f_today()

//////////////////////////////////////////////////////////////////////////////////
ssdate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "sdate"))
sedate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "edate"))
spdtgu  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "pdtgu"))

lrowcnt = tab_1.tabpage_1.dw_t1.rowcount()
FOR lrow = 1 TO lrowcnt
	sitnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
	
	lrowcnt2 = tab_1.tabpage_2.dw_t2.retrieve(gs_saupj,ssdate,sedate,sitnbr,scrjpno,spdtgu)
	FOR lrow2 = 1 TO lrowcnt2
		sjpno = tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'shpjpno')
		lrowcnt3 = tab_1.tabpage_3.dw_t3_2.retrieve(gs_saupj,sjpno)
		FOR lrow3 = 1 TO lrowcnt3
			tab_1.tabpage_3.dw_t3_2.setitem(lrow3,'cdate',sdate)
		NEXT
		
		if tab_1.tabpage_3.dw_t3_2.rowcount() > 0 then
			tab_1.tabpage_3.dw_t3_2.accepttext()
			if tab_1.tabpage_3.dw_t3_2.update() <> 1 then
				rollback ;
				messagebox('확인','[ '+sitnbr+' : '+string(sjpno,'@@@@@@@@-@@@@')+ '] ~n저장 실패')
				return -1
			end if
		end if
		tab_1.tabpage_3.dw_t3_2.reset()
		
		/////////////////////////////////////////////////////////////////////////////////////////
		// QA 확인 여부  -2004.02.06
		lrowcnt4 = tab_1.tabpage_3.dw_t3_1.retrieve(gs_saupj,sjpno)
		FOR lrow4 = 1 TO lrowcnt4
			tab_1.tabpage_3.dw_t3_1.setitem(lrow4,'gugub','Y')	// QA 확인
		NEXT
		
		if tab_1.tabpage_3.dw_t3_1.rowcount() > 0 then
			tab_1.tabpage_3.dw_t3_1.accepttext()
			if tab_1.tabpage_3.dw_t3_1.update() <> 1 then
				rollback ;
				messagebox('확인','[ '+sitnbr+' : '+string(sjpno,'@@@@@@@@-@@@@')+ '] ~n저장 실패')
				return -1
			end if
		end if
		
		select count(*) into :lcnt from shpfat_qa_cnf
		 where sabu = :gs_saupj and crjpno = :scrjpno and shpjpno = :sjpno ;
		if lcnt = 0 then
			insert into shpfat_qa_cnf
			( sabu,			crjpno,		shpjpno,		cdate )
			values
			( :gs_saupj,		:scrjpno,	:sjpno,		:sdate ) ;
		end if

	NEXT
NEXT

//if wf_create_shpfat_qa_sum(scrjpno) = -1 then return -1

return 1
end function

public function integer wf_create_shpfat_qa_sum (string arg_jpno);long		lrow, lins, lrowcnt
string	sdate, sitnbr, scvcod, shcode
String	ls_saupj

dw_insert.reset()

sdate = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'sdate'))
//sdate   = f_today()

ls_saupj	= dw_1.GetItemString(1, "saupj")
lrowcnt = dw_shpfat_qa.retrieve(ls_saupj,arg_jpno)

FOR lrow = 1 TO lrowcnt
	lins = dw_insert.insertrow(0)
	dw_insert.setitem(lins,'sabu',ls_saupj)
	dw_insert.setitem(lins,'crsjpno',arg_jpno+string(lins,'000'))
	
	sitnbr = dw_shpfat_qa.getitemstring(lrow,'itnbr')
	scvcod = dw_shpfat_qa.getitemstring(lrow,'cvcod')
	
	dw_insert.setitem(lins,'itnbr',sitnbr)
	dw_insert.setitem(lins,'cvcod',scvcod)
	
	select hcode into :shcode from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :arg_jpno 
	   and itnbr = :sitnbr and cvcod = :scvcod and rownum = 1 ;
	
	dw_insert.setitem(lins,'cdate',sdate)
	dw_insert.setitem(lins,'hcode',shcode)
	dw_insert.setitem(lins,'bjukhap','1')	// 수정불합격처리-임의등록 ('2')
	dw_insert.setitem(lins,'faqty',dw_shpfat_qa.getitemnumber(lrow,'qaqty'))
	dw_insert.setitem(lins,'crjpno',arg_jpno)
	dw_insert.setitem(lins,'depot_no',dw_shpfat_qa.getitemstring(lrow,'depot_no'))
NEXT

dw_insert.accepttext()
if dw_insert.update() <> 1 then
	rollback ;
	messagebox('확인','자재 통보 실패!!!')
	return -1
end if

return 1
end function

public function integer wf_tabpage_1_all_apply ();long		lrow, lrowcnt, lrow2, lrowcnt2, lrow3, lrowcnt3, linsrow, lcnt
string	switnbr, switdsc, swcvcod, swcvnas, sitnbr, sjpno, sbaldt, snull
string	shcode, swcode, sgubun, ssdate, sedate, scrjpno, spdtgu, sdepot, sopsno, spinbr
decimal	dqty

if tab_1.selectedtab <> 1 then return -1

if messagebox('품목별집계-일괄적용','생산판정불량 중 가공불량을 복사한 후~n' + &
							'지정한 외주업체-품번으로 일괄 적용합니다.',exclamation!,yesno!,1) = 2 then return -1

setnull(snull)
if tab_1.tabpage_1.dw_t1.rowcount() < 1 then return -1

setpointer(hourglass!)
//////////////////////////////////////////////////////////////////////////////////
ssdate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "sdate"))
sedate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "edate"))
scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
spdtgu  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "pdtgu"))

lrowcnt = tab_1.tabpage_1.dw_t1.rowcount()
FOR lrow = 1 TO lrowcnt
	sitnbr  = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
	switnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_itnbr')
	select count(*) into :lcnt from itemas
	 where itnbr = :switnbr ;
	if lcnt = 0 then
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itnbr',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itdsc',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvcod',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvnas',snull)
		continue
	end if
		
	swcvcod = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_cvcod')
	select count(*) into :lcnt from vndmst
	 where cvcod = :swcvcod ;
	if lcnt = 0 then
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itnbr',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_itdsc',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvcod',snull)
		tab_1.tabpage_1.dw_t1.setitem(lrow,'wai_cvnas',snull)
		continue
	end if

	tab_1.tabpage_2.dw_t2_0.setitem(1,'itnbr',sitnbr)	
		
	lrowcnt2 = tab_1.tabpage_2.dw_t2.retrieve(gs_saupj,ssdate,sedate,sitnbr,scrjpno,spdtgu)
	FOR lrow2 = 1 TO lrowcnt2
		sjpno = tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'shpjpno')
		sbaldt= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'sidat')
		spdtgu= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'pdtgu')
		sopsno= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'opsno')
		spinbr= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'itnbr')
		
		if tab_1.tabpage_3.dw_t3_2.retrieve(gs_saupj,sjpno) > 0 then continue  // 등록된게 있으면 skip

		tab_1.tabpage_3.dw_t3_0.setitem(1,'shpjpno',sjpno)
		lrowcnt3 = tab_1.tabpage_3.dw_t3_1.retrieve(gs_saupj,sjpno)
		FOR lrow3 = 1 TO lrowcnt3
			
			shcode = tab_1.tabpage_3.dw_t3_1.getitemstring(lrow3,'gucod')
			sgubun = tab_1.tabpage_3.dw_t3_1.getitemstring(lrow3,'sojaegb')
			swcode = tab_1.tabpage_3.dw_t3_1.getitemstring(lrow3,'scode1')
			dqty	 = tab_1.tabpage_3.dw_t3_1.getitemnumber(lrow3,'guqty')

			select cvcod into :sdepot from vndmst
			 where cvgu = '5' and jumaeip = :spdtgu and soguan = '2' and rownum = 1 ;
			if sqlca.sqlcode <> 0 then
				sdepot = 'Z30'
			end if

			if sgubun = '1' then  // 소재불량만
				linsrow = tab_1.tabpage_3.dw_t3_2.insertrow(0)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'sabu',gs_saupj)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'shpjpno',sjpno)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'opsno',sopsno)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'pinbr',spinbr)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'itnbr',switnbr)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'cvcod',swcvcod)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'hcode',shcode)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'wcode',swcode)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'idate',sbaldt) // 발생일자
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'qaqty',dqty)
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'crtgbn','A') // 일괄생성
				tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'depot_no',sdepot)
			end if
		NEXT
		
		if tab_1.tabpage_3.dw_t3_2.rowcount() > 0 then
			tab_1.tabpage_3.dw_t3_2.accepttext()
			if tab_1.tabpage_3.dw_t3_2.update() <> 1 then
				rollback ;
				messagebox('확인','[ '+sitnbr+' : '+string(sjpno,'@@@@@@@@-@@@@')+ '] ~n일괄적용 실패')
			else
				commit ;
			end if
		end if
		wf_refresh_qty(3,1)	// 수량갱신
		tab_1.tabpage_3.dw_t3_2.reset()
	NEXT
NEXT

tab_1.tabpage_2.dw_t2_0.reset()
tab_1.tabpage_2.dw_t2.reset()
tab_1.tabpage_3.dw_t3_0.reset()
tab_1.tabpage_3.dw_t3_1.reset()
tab_1.tabpage_3.dw_t3_2.reset()

tab_1.tabpage_2.dw_t2_0.insertrow(0)
tab_1.tabpage_3.dw_t3_0.insertrow(0)

return 1
end function

public function integer wf_tabpage_2_all_apply ();long		lrow, lrowcnt, lrow2, lrowcnt2, lrow3, lrowcnt3, linsrow, lcnt
string	switnbr, switdsc, swcvcod, swcvnas, sitnbr, sjpno, snull
string	shcode, swcode, sgubun, ssdate, sedate, sbaldt, spdtgu, sdepot, sopsno, spinbr
decimal	dqty

if tab_1.selectedtab <> 2 then return -1

if messagebox('불량발생내역-일괄적용','생산판정불량 중 가공불량을 복사한 후~n' + &
							'지정한 외주업체-품번으로 일괄 적용합니다.',exclamation!,yesno!,1) = 2 then return -1

setnull(snull)
if tab_1.tabpage_2.dw_t2.rowcount() < 1 then return -1

setpointer(hourglass!)
//////////////////////////////////////////////////////////////////////////////////
lrowcnt2 = tab_1.tabpage_2.dw_t2.rowcount()
FOR lrow2 = 1 TO lrowcnt2
	sjpno = tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'shpjpno')
	sbaldt= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'sidat')
	switnbr= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'wai_itnbr')
	spdtgu= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'pdtgu')	
	sopsno= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'opsno')
	spinbr= tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'itnbr')
	
	select count(*) into :lcnt from itemas
	 where itnbr = :switnbr ;
	if lcnt = 0 then
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itnbr',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itdsc',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvcod',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvnas',snull)
		continue
	end if
		
	swcvcod = tab_1.tabpage_2.dw_t2.getitemstring(lrow2,'wai_cvcod')
	select count(*) into :lcnt from vndmst
	 where cvcod = :swcvcod ;
	if lcnt = 0 then
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itnbr',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itdsc',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvcod',snull)
		tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvnas',snull)
		continue
	end if

	if tab_1.tabpage_3.dw_t3_2.retrieve(gs_saupj,sjpno) > 0 then continue  // 등록된게 있으면 skip
	
	tab_1.tabpage_3.dw_t3_0.setitem(1,'shpjpno',sjpno)
	lrowcnt3 = tab_1.tabpage_3.dw_t3_1.retrieve(gs_saupj,sjpno)
	FOR lrow3 = 1 TO lrowcnt3
		shcode = tab_1.tabpage_3.dw_t3_1.getitemstring(lrow3,'gucod')
		swcode = tab_1.tabpage_3.dw_t3_1.getitemstring(lrow3,'scode1')
		dqty	 = tab_1.tabpage_3.dw_t3_1.getitemnumber(lrow3,'guqty')
		
		select rfna3 into :sgubun from reffpf
		 where rfcod = '33' and rfgub = :shcode ;
		if sgubun <> '1' then continue	// 가공불량이면 skip

		select cvcod into :sdepot from vndmst
		 where cvgu = '5' and jumaeip = :spdtgu and soguan = '2' and rownum = 1 ;
		if sqlca.sqlcode <> 0 then
			sdepot = 'Z30'
		end if

		linsrow = tab_1.tabpage_3.dw_t3_2.insertrow(0)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'sabu',gs_saupj)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'shpjpno',sjpno)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'opsno',sopsno)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'pinbr',spinbr)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'itnbr',switnbr)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'cvcod',swcvcod)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'hcode',shcode)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'wcode',swcode)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'idate',sbaldt) // 발생일자
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'qaqty',dqty)
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'crtgbn','A') // 일괄생성
		tab_1.tabpage_3.dw_t3_2.setitem(linsrow,'depot_no',sdepot)
	NEXT
	
	if tab_1.tabpage_3.dw_t3_2.rowcount() > 0 then
		tab_1.tabpage_3.dw_t3_2.accepttext()
		if tab_1.tabpage_3.dw_t3_2.update() <> 1 then
			rollback ;
		else
			commit ;
		end if
	end if
	wf_refresh_qty(3,2)	// 수량갱신
	tab_1.tabpage_3.dw_t3_2.reset()
NEXT

tab_1.tabpage_3.dw_t3_0.reset()
tab_1.tabpage_3.dw_t3_1.reset()
tab_1.tabpage_3.dw_t3_2.reset()

tab_1.tabpage_3.dw_t3_0.insertrow(0)

return 1
end function

on w_qa02_00050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_shpfat_qa=create dw_shpfat_qa
this.p_2=create p_2
this.p_3=create p_3
this.dw_t2_dump=create dw_t2_dump
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_shpfat_qa
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.p_3
this.Control[iCurrent+9]=this.dw_t2_dump
end on

on w_qa02_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_shpfat_qa)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.dw_t2_dump)
end on

event open;call super::open;dw_insert.settransobject(SQLCA)
dw_shpfat_qa.settransobject(SQLCA)
dw_1.settransobject(SQLCA)

tab_1.tabpage_3.dw_t3_1.settransobject(SQLCA)
tab_1.tabpage_3.dw_t3_2.settransobject(SQLCA)

tab_1.tabpage_1.dw_t1_0.insertrow(0)
tab_1.tabpage_2.dw_t2_0.insertrow(0)
tab_1.tabpage_3.dw_t3_0.insertrow(0)

tab_1.tabpage_1.dw_t1_0.Object.sdate[1] = f_afterday(f_today() , -90)
tab_1.tabpage_1.dw_t1_0.Object.edate[1] = f_today()

rb_1.checked = true
rb_1.postevent(clicked!)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00050
boolean visible = false
integer x = 4850
integer y = 480
integer width = 1367
integer height = 608
integer taborder = 20
boolean titlebar = true
string title = "SHPFAT_QA_SUM"
string dataobject = "d_shpfat_qa_sum"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''
Long ll_row 
ll_row = GetRow()
If ll_row < 1 Then Return

IF this.GetColumnName() = "sojae_itnbr" THEN
//	gs_gubun = Trim(This.Object.itnbr[ll_row])
//	
//	dw_bom.Retrieve(gs_gubun)  // 라인 투입수량을 계산하기 위한 bom
//	
//	Open(w_qa02_00050_popup01)
//	
//	IF isnull(gs_Code)  or  gs_Code = '' or &
//	   isnull(gs_Codename)  or  gs_Codename = '' then 
//		
//		This.Object.sojae_itnbr[ll_row] = ''
//		This.Object.sojae_itdsc[ll_row] = '' 
//		This.Object.cvcod[ll_row] = ''
//		This.Object.cvnas[ll_row] = ''
//		return
//	End If
//	
//	String ls_itdsc ,ls_cvnas
//	
//	SELECT B.ITDSC,
//	       C.CVNAS2
//	  Into :ls_itdsc , :ls_cvnas 
//	  FROM DANMST A , ITEMAS B, VNDMST C
//	 WHERE A.ITNBR = :gs_code
//	   AND A.CVCOD = :gs_codename
//		AND A.ITNBR = B.ITNBR
//		AND A.CVCOD = C.CVCOD ;
//
//	If SQLCA.SQLCODE <> 0 Then
//		f_message_chk(33,'')
//		
//	Else
//	   This.Object.sojae_itnbr[ll_row] = gs_code
//		This.Object.sojae_itdsc[ll_row] = ls_itdsc
//		This.Object.cvcod[ll_row] = gs_codename
//		This.Object.cvnas[ll_row] = ls_cvnas
//	End If
//	
//	Dec ld_roqty = 0 ,ld_rq 
//	Long   i,ll_level
//	String ls_p , ls_c
//	
//	For i = 1 To dw_bom.RowCount()
//		ll_level = dw_bom.Object.lvlno[i]
//		
//		If i = 1 Then
//			ld_rq = dw_bom.Object.qtypr[i]
//		Else
//			If ll_level <> 1 Then
//				ld_rq = ld_rq *  dw_bom.Object.qtypr[i]
//			Else
//				ld_rq = dw_bom.Object.qtypr[i]
//			End If
//		End if
//		
//		dw_bom.Object.s_qty[i] = ld_rq
//		
//		ls_c = dw_bom.Object.cinbr[i]
//		If ls_c = gs_code Then
//			ld_roqty = ld_roqty + dw_bom.Object.s_qty[i]
//		End If
//	Next
//	
//	dw_insert.Object.shpact_qa_roqty[ll_row] = ld_roqty * dw_insert.Object.roqty[ll_row]
//
	
END IF
end event

event dw_insert::buttonclicked;call super::buttonclicked;If row < 1 Then Return

decimal	dqty

Choose Case Lower(dwo.name)
	Case 'b_fat'
		gs_code = Trim(This.Object.shpjpno[row])
		
		If gs_code > '' Then
			Open(w_qa02_00050_popup03)
			dqty = message.doubleparm
			this.setitem(row,'qasqty',dqty)
		End If
End Choose


end event

event dw_insert::itemchanged;call super::itemchanged;gs_code = ''
gs_codename = ''
gs_gubun = ''
Long ll_row 
Dec  ld_qasqty

AcceptText()

ll_row = GetRow()
If ll_row < 1 Then Return

IF this.GetColumnName() = "qasqty" THEN
	
//	ld_qasqty =This.Object.qasqty[ll_row]
//	If ld_qasqty > 0 Then
//		gs_gubun = Trim(This.Object.itnbr[ll_row])
//		
//		dw_bom.Retrieve(gs_gubun)  // 라인 투입수량을 계산하기 위한 bom
//		
//		Open(w_qa02_00050_popup01)
//		
//		IF isnull(gs_Code)  or  gs_Code = '' or &
//			isnull(gs_Codename)  or  gs_Codename = '' then 
//			
//			This.Object.sojae_itnbr[ll_row] = ''
//			This.Object.sojae_itdsc[ll_row] = '' 
//			This.Object.cvcod[ll_row] = ''
//			This.Object.cvnas[ll_row] = ''
//			return
//		End If
//		
//		String ls_itdsc ,ls_cvnas
//		
//		SELECT B.ITDSC,
//				 C.CVNAS2
//		  Into :ls_itdsc , :ls_cvnas 
//		  FROM DANMST A , ITEMAS B, VNDMST C
//		 WHERE A.ITNBR = :gs_code
//			AND A.CVCOD = :gs_codename
//			AND A.ITNBR = B.ITNBR
//			AND A.CVCOD = C.CVCOD ;
//	
//		If SQLCA.SQLCODE <> 0 Then
//			f_message_chk(33,'')
//			
//		Else
//			This.Object.sojae_itnbr[ll_row] = gs_code
//			This.Object.sojae_itdsc[ll_row] = ls_itdsc
//			This.Object.cvcod[ll_row] = gs_codename
//			This.Object.cvnas[ll_row] = ls_cvnas
//		End If
//		
//		Dec ld_roqty = 0 ,ld_rq 
//		Long   i,ll_level
//		String ls_p , ls_c
//		
//		For i = 1 To dw_bom.RowCount()
//			ll_level = dw_bom.Object.lvlno[i]
//			
//			If i = 1 Then
//				ld_rq = dw_bom.Object.qtypr[i]
//			Else
//				If ll_level <> 1 Then
//					ld_rq = ld_rq *  dw_bom.Object.qtypr[i]
//				Else
//					ld_rq = dw_bom.Object.qtypr[i]
//				End If
//			End if
//			
//			dw_bom.Object.s_qty[i] = ld_rq
//			
//			ls_c = dw_bom.Object.cinbr[i]
//			If ls_c = gs_code Then
//				ld_roqty = ld_roqty + dw_bom.Object.s_qty[i]
//			End If
//		Next
//		
//		dw_insert.Object.shpact_qa_roqty[ll_row] = ld_roqty * dw_insert.Object.roqty[ll_row]
//	End If
	
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00050
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00050
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa02_00050
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa02_00050
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa02_00050
integer x = 4370
integer y = 16
end type

type p_can from w_inherite`p_can within w_qa02_00050
integer x = 4197
integer y = 16
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_qa02_00050
integer x = 3438
integer y = 16
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\일괄적용_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\일괄적용_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\일괄적용_up.gif"
end event

event p_print::clicked;call super::clicked;if ic_status = '2' then
	messagebox('확인','일괄적용은 등록모드일 경우만 가능합니다.')
	return
end if

if tab_1.selectedtab = 1 then
	if wf_tabpage_1_all_apply() < 1 then return
elseif tab_1.selectedtab = 2 then
	if wf_tabpage_2_all_apply() < 1 then return
else
	return
end if

messagebox('확인','일괄적용을 완료하였습니다.')
end event

type p_inq from w_inherite`p_inq within w_qa02_00050
integer x = 3675
integer y = 16
end type

event p_inq::clicked;tab_1.tabpage_1.dw_t1.setfilter("")
tab_1.tabpage_1.dw_t1.filter()

wf_tabpage_1_retrieve()
dw_t2_dump.reset()
tab_1.selecttab(1)
end event

type p_del from w_inherite`p_del within w_qa02_00050
integer x = 3264
integer y = 16
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\통보취소_up.gif"
end type

event p_del::ue_lbuttondown;//PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_del::ue_lbuttonup;//PictureName = "C:\erpman\image\삭제_up.gif"
end event

event p_del::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_del)
end event

event p_del::clicked;call super::clicked;long		lcnt
string	scrjpno, soutjpno, snull

if ic_status = '1' then
	messagebox('확인','자재통보취소는 수정상태일때만 가능합니다')
	return
end if

setnull(snull)
scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :scrjpno ;
if lcnt = 0 then
	messagebox('확인','자재 통보하지 않은 자료입니다.')
	return
end if

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :scrjpno and outjpno is not null ;
if lcnt > 0 then
	messagebox('확인','반품 처리된 자료가 있어 취소 불가합니다')
	return
end if

SELECT count(*) INTO :lcnt FROM IMHFAG
 WHERE SABU = :GS_SABU AND IOGBN = 'Q03'
	AND IOJPNO = :scrjpno ;
if lcnt > 0 then
	messagebox('확인','부적합 통보된 자료는 취소 불가합니다.')
	return
end if

if messagebox('확인','자재 통보 취소 하시겠습니까?',question!,yesno!,1) = 2 then return

setpointer(hourglass!)

delete from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :scrjpno ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','자재 통보 취소 실패!!!')
	return
end if

update shpfat_qa
	set transyn = 'N', idate = null
 where sabu = :gs_saupj and crjpno = :scrjpno ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','자재 통보 취소 실패!!!')
	return
end if

commit ;

messagebox('확인','자재 통보 취소 완료!!!')

if tab_1.selectedtab <> 1 then tab_1.selecttab(1)

tab_1.tabpage_1.dw_t1_0.setitem(1,'status',snull)
tab_1.tabpage_2.dw_t2_0.setitem(1,'status',snull)
p_inq.triggerevent(clicked!)
end event

type p_mod from w_inherite`p_mod within w_qa02_00050
integer x = 3090
integer y = 16
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\자재통보_up.gif"
end type

event p_mod::clicked;long		lcnt
string	sjpno, sdate

if ic_status = '1' then
	messagebox('확인','자재통보는 수정상태일때만 가능합니다')
	return
end if

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

sjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
if isnull(sjpno) or trim(sjpno) = '' then
	messagebox('확인','처리번호를 지정하세요!!!')
	return
end if

select count(*) into :lcnt from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt = 0 then
	messagebox('확인','잘못된 처리번호입니다.')
	return
end if

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt > 0 then
	messagebox('확인','이미 통보된 자료입니다!!!')
	return
end if

if messagebox('확인','자재 통보 하시겠습니까?',question!,yesno!,1) = 2 then 
	return -1
end if

if wf_create_shpfat_qa_sum(sjpno) = -1 then 
	rollback;
	messagebox('확인','자재 통보 실패!!!')
	return
end if

sdate = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'sdate'))
//sdate = f_today()

update shpfat_qa
	set transyn = 'Y', idate = :sdate
 where sabu = :gs_saupj and crjpno = :sjpno ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','자재 통보 실패!!!')
	return
end if

commit ;

messagebox('확인','자재 통보 완료!!!')
p_can.triggerevent(clicked!)
end event

event p_mod::ue_lbuttondown;//PictureName = "C:\erpman\image\완료처리_dn.gif"
end event

event p_mod::ue_lbuttonup;//PictureName = "C:\erpman\image\완료처리_up.gif"
end event

event p_mod::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_mod)
end event

type cb_exit from w_inherite`cb_exit within w_qa02_00050
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00050
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00050
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa02_00050
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00050
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa02_00050
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa02_00050
end type

type cb_can from w_inherite`cb_can within w_qa02_00050
end type

type cb_search from w_inherite`cb_search within w_qa02_00050
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00050
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00050
end type

type dw_1 from datawindow within w_qa02_00050
event ue_processenter pbm_dwnprocessenter
boolean visible = false
integer x = 1851
integer y = 12
integer width = 1001
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa02_00050_1"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string snull, sdata, sname 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'sdate' then
	sdata = this.gettext()
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[시작일자]');
		this.setitem(1, "sdate", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'edate' then
	sdata = this.gettext()	
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[종료일자]');
		this.setitem(1, "edate", snull)
		return 1		
	end if
	if this.getitemstring(1, "sdate") > sdata then
		
		
	end if
	
// 공급업체
ELSEIF this.GetColumnName() = 'cvcod' THEN
	sdata = this.gettext()
	
	select cvnas into :sname from vndmst
	 where cvcod = :sdata ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if

END IF
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

type rr_1 from roundrectangle within w_qa02_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 20
integer width = 809
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type tab_1 from tab within w_qa02_00050
integer x = 23
integer y = 168
integer width = 4585
integer height = 2040
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;long		lrow, lrow2, lrowcnt2
string	ssdate, sedate, sitnbr, sitdsc, sjpno, sopsno, sopdsc, status
string	switnbr, switdsc, swcvcod, swcvnas, sfagyn, scrjpno, spdtgu

setpointer(hourglass!)

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

ssdate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "sdate"))
sedate  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "edate"))
scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
spdtgu  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "pdtgu"))
status  = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "status"))

// 불량 발생 내역
if oldindex = 1 and newindex = 2 then
	lrow = tab_1.tabpage_1.dw_t1.getselectedrow(0)
	if lrow < 1 then
		tab_1.tabpage_2.dw_t2.reset()
	else
		tab_1.tabpage_2.dw_t2_0.setitem(1,'sdate',ssdate)
		tab_1.tabpage_2.dw_t2_0.setitem(1,'edate',sedate)
		
		sitnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
		sitdsc = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itdsc')
		switnbr= tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_itnbr')
		switdsc= tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_itdsc')
		swcvcod= tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_cvcod')
		swcvnas= tab_1.tabpage_1.dw_t1.getitemstring(lrow,'wai_cvnas')
		sfagyn = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'fag_yn')
		
		tab_1.tabpage_2.dw_t2_0.setitem(1,'itnbr',sitnbr)
		tab_1.tabpage_2.dw_t2_0.setitem(1,'itdsc',sitdsc)
		tab_1.tabpage_2.dw_t2_0.setitem(1,'crjpno',scrjpno)
		tab_1.tabpage_2.dw_t2_0.setitem(1,'pdtgu',spdtgu)
		tab_1.tabpage_2.dw_t2_0.setitem(1,'status',status)
		
		lrowcnt2 = tab_1.tabpage_2.dw_t2.retrieve(gs_saupj,ssdate,sedate,sitnbr,scrjpno,spdtgu)
		FOR lrow2 = 1 TO lrowcnt2
			tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itnbr',switnbr)
			tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_itdsc',switdsc)
			tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvcod',swcvcod)
			tab_1.tabpage_2.dw_t2.setitem(lrow2,'wai_cvnas',swcvnas)
//			tab_1.tabpage_2.dw_t2.setitem(lrow2,'fag_yn',sfagyn)
		NEXT
		tab_1.tabpage_2.dw_t2.selectrow(1, true)
	end if
end if

// 불량 상세 내역
if oldindex = 2 and newindex = 3 then
	lrow = tab_1.tabpage_2.dw_t2.getselectedrow(0)
	if lrow < 1 then
		tab_1.tabpage_3.dw_t3_1.reset()
		tab_1.tabpage_3.dw_t3_2.reset()
	else
		sjpno  = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'shpjpno')
		sitnbr = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'itnbr')
		sitdsc = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'itdsc')
		sopsno = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'opsno')
		sopdsc = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'opdsc')
		ssdate = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'sidat')
		
		tab_1.tabpage_3.dw_t3_0.setitem(1,'shpjpno',sjpno)
		tab_1.tabpage_3.dw_t3_0.setitem(1,'itnbr',sitnbr)
		tab_1.tabpage_3.dw_t3_0.setitem(1,'itdsc',sitdsc)
		tab_1.tabpage_3.dw_t3_0.setitem(1,'opsno',sopsno)
		tab_1.tabpage_3.dw_t3_0.setitem(1,'opdsc',sopdsc)
		tab_1.tabpage_3.dw_t3_0.setitem(1,'sidat',ssdate)
		
		tab_1.tabpage_3.dw_t3_1.retrieve(gs_saupj,sjpno)
		tab_1.tabpage_3.dw_t3_2.retrieve(gs_saupj,sjpno)
	end if
end if

if oldindex = 1 and newindex = 3 then
	tab_1.tabpage_3.dw_t3_0.reset()
	tab_1.tabpage_3.dw_t3_0.insertrow(0)
	tab_1.tabpage_3.dw_t3_1.reset()
	tab_1.tabpage_3.dw_t3_2.reset()
end if

/* 불량상세내역 저장 */
if oldindex = 3 and newindex <> 3 then
	if wf_tabpage_3_required_chk() < 1 then return
	if tab_1.tabpage_3.dw_t3_2.update() <> 1 then
		rollback ;
		messagebox('확인','불량상세내역 저장 실패')
	else
		commit ;
	end if
	
	// 수정 모드에서 외주품번 및 외주업체 지정
	if newindex = 2 then
		wf_modify_setitem('2',scrjpno)
	else
		wf_modify_setitem('1',scrjpno)
	end if
end if


/* 불량 발생 내역 지정 값 보관 - 2004.02.06 */
//if newindex = 2 then
//	wf_dw_t2_vs_dump('2')
//end if
//
//if oldindex = 2 then
//	wf_dw_t2_vs_dump('1')
//end if



/* 수량갱신 */
if oldindex = 3 and newindex = 2 then
	wf_refresh_qty(3,2)
elseif oldindex = 2 and newindex = 1 then
	wf_refresh_qty(2,1)
elseif oldindex = 3 and newindex = 1 then
	wf_refresh_qty(3,1)
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4549
integer height = 1928
long backcolor = 32106727
string text = "품목별 집계"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
pb_2 pb_2
pb_1 pb_1
p_t1 p_t1
cbx_t1 cbx_t1
dw_t1_0 dw_t1_0
rr_2 rr_2
dw_t1 dw_t1
end type

on tabpage_1.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_t1=create p_t1
this.cbx_t1=create cbx_t1
this.dw_t1_0=create dw_t1_0
this.rr_2=create rr_2
this.dw_t1=create dw_t1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_t1,&
this.cbx_t1,&
this.dw_t1_0,&
this.rr_2,&
this.dw_t1}
end on

on tabpage_1.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_t1)
destroy(this.cbx_t1)
destroy(this.dw_t1_0)
destroy(this.rr_2)
destroy(this.dw_t1)
end on

type pb_2 from u_pb_cal within tabpage_1
integer x = 1193
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;
//해당 컬럼 지정
tab_1.tabpage_1.dw_t1_0.SetColumn('edate')
//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 
//Gs Code에 지정된 날짜 값 지정
tab_1.tabpage_1.dw_t1_0.SetItem(1, 'edate', gs_code)	

end event

type pb_1 from u_pb_cal within tabpage_1
integer x = 690
integer y = 24
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;
//해당 컬럼 지정
tab_1.tabpage_1.dw_t1_0.SetColumn('sdate')
//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 
//Gs Code에 지정된 날짜 값 지정
tab_1.tabpage_1.dw_t1_0.SetItem(1, 'sdate', gs_code)	

end event

type p_t1 from picture within tabpage_1
integer x = 4302
integer y = 4
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lrowcnt, lcnt
string	sjpno, sitnbr

if ic_status = '1' then
	messagebox('확인','삭제는 수정상태일때만 가능합니다')
	return
end if

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

sjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
if isnull(sjpno) or trim(sjpno) = '' then
	messagebox('확인','처리번호를 지정하세요!!!')
	return
end if

select count(*) into :lcnt from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt = 0 then
	messagebox('확인','잘못된 처리번호입니다.')
	return
end if

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt > 0 then
	messagebox('확인','이미 통보된 자료입니다!!!')
	return
end if

if tab_1.tabpage_1.dw_t1.find("fag_yn='Y'",1,tab_1.tabpage_1.dw_t1.rowcount()) < 1 then
	messagebox('확인','삭제할 대상을 선택하세요!!!')
	return
end if

if messagebox('확인','해당 처리번호의 선택된 자료를 삭제합니다.',question!,yesno!,1) = 2 then 
	return
end if

setpointer(hourglass!)

lrowcnt = tab_1.tabpage_1.dw_t1.rowcount() 
FOR lrow = lrowcnt TO 1 STEP -1
	if tab_1.tabpage_1.dw_t1.getitemstring(lrow,'fag_yn') = 'N' then continue
	
	sitnbr = tab_1.tabpage_1.dw_t1.getitemstring(lrow,'itnbr')
	
	update shpfat
		set gugub = null
	 where sabu = :gs_sabu
		and shpjpno in ( select x.shpjpno
									from shpfat_qa x,
										  shpact		y
								  where x.sabu = :gs_saupj
									 and x.crjpno = :sjpno
									 and x.shpjpno = y.shpjpno
									 and y.itnbr = :sitnbr ) ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if

	delete from shpfat_qa_cnf
	 where sabu = :gs_saupj and crjpno = :sjpno
		and shpjpno in ( select x.shpjpno
									from shpfat_qa_cnf x,
										  shpact		y
								  where x.sabu = :gs_saupj
									 and x.crjpno = :sjpno
									 and x.shpjpno = y.shpjpno
									 and y.itnbr = :sitnbr ) ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if

	delete from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :sjpno
		and shpjpno in ( select x.shpjpno
									from shpfat_qa x,
										  shpact		y
								  where x.sabu = :gs_saupj
									 and x.crjpno = :sjpno
									 and x.shpjpno = y.shpjpno
									 and y.itnbr = :sitnbr ) ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if
	
	tab_1.tabpage_1.dw_t1.deleterow(lrow)
NEXT

commit ;

messagebox('확인','삭제 완료!!!')

if tab_1.tabpage_1.dw_t1.rowcount() < 1 then
	p_can.triggerevent(clicked!)
end if
end event

type cbx_t1 from checkbox within tabpage_1
integer x = 3913
integer y = 48
integer width = 576
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "선택된 자료만 표시"
end type

event clicked;if this.checked then
	dw_t1.setfilter("fag_yn='Y'")
	dw_t1.filter()
else
	dw_t1.setfilter("")
	dw_t1.filter()
end if	
end event

type dw_t1_0 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer width = 3881
integer height = 152
integer taborder = 90
string title = "none"
string dataobject = "d_qa02_00050_02"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String	scode, sname, sdate, snull
long		lcnt

setnull(snull)

IF this.GetColumnName() = 'itnbr' THEN
	scode = this.gettext()
	
	select itdsc into :sname from itemas
	 where itnbr = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'itdsc',sname)
	else
		this.setitem(1,'itnbr',snull)
		this.setitem(1,'itdsc',snull)
		return 1
	end if

ELSEIF this.GetColumnName() = 'crjpno' THEN
	scode = this.gettext()

	select cdate into :sdate from shpfat_qa_cnf
	 where sabu = :gs_saupj and crjpno = :scode and rownum = 1 ;

	select count(*) into :lcnt from shpfat_qa_sum
	 where sabu = :gs_saupj and crjpno = :scode and bjukhap = '1' ;
	
	if lcnt > 0 then 
		this.setitem(1,'status','통보')
	else
		this.setitem(1,'status',snull)
	end if
	this.setitem(1,'sdate',sdate)
	
	p_inq.triggerevent(clicked!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;string	snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'itnbr' THEN
	Open(w_itemas_popup)
	
	IF isnull(gs_Code)  or  gs_Code = '' then return

	this.setitem(1,'itnbr',gs_code)
	this.triggerevent(itemchanged!)

ELSEIF this.GetColumnName() = 'crjpno' THEN
	open(w_qa02_00050_popup4)
	
	IF isnull(gs_Code)  or  gs_Code = '' then return

	this.setitem(1,'crjpno',gs_code)
	this.triggerevent(itemchanged!)
END IF
end event

type rr_2 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 156
integer width = 4544
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_t1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 168
integer width = 4498
integer height = 1744
integer taborder = 50
string title = "none"
string dataobject = "d_qa02_00050_00"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;Long		ll_row 
String	scode, sname, snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)

// 소재품번
IF this.GetColumnName() = 'wai_itnbr' THEN
	scode = this.gettext()
	
	select itdsc into :sname from itemas
	 where itnbr = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'wai_itdsc',sname)
	else
		this.setitem(ll_row,'wai_itnbr',snull)
		this.setitem(ll_row,'wai_itdsc',snull)
		return 1
	end if

// 공급업체
ELSEIF this.GetColumnName() = 'wai_cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'wai_cvnas',sname)
	else
		this.setitem(ll_row,'wai_cvcod',snull)
		this.setitem(ll_row,'wai_cvnas',snull)
		return 1
	end if

END IF
end event

event itemerror;
RETURN 1
end event

event rbuttondown;Long		ll_row
string	snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'wai_itnbr' THEN
	gs_gubun = this.getitemstring(ll_row,'itnbr')

	Open(w_qa02_00050_popup01)
	
	IF isnull(gs_Code)  or  gs_Code = '' or &
	   isnull(gs_Codename)  or  gs_Codename = '' then 
		this.setitem(ll_row,'wai_itnbr',snull)
		this.setitem(ll_row,'wai_itdsc',snull)
		this.setitem(ll_row,'wai_cvcod',snull)
		this.setitem(ll_row,'wai_cvnas',snull)
		return
	End If
	
	String ls_itdsc, ls_cvnas
	
	SELECT B.ITDSC, C.CVNAS2
	  Into :ls_itdsc, :ls_cvnas 
	  FROM DANMST A, ITEMAS B, VNDMST C
	 WHERE A.ITNBR = :gs_code
	   AND A.CVCOD = :gs_codename
		AND A.ITNBR = B.ITNBR
		AND A.CVCOD = C.CVCOD ;

	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33,'')
	Else
		this.setitem(ll_row,'wai_itnbr',gs_code)
		this.setitem(ll_row,'wai_itdsc',ls_itdsc)
		this.setitem(ll_row,'wai_cvcod',gs_codename)
		this.setitem(ll_row,'wai_cvnas',ls_cvnas)
	End If


// 공급업체
ELSEIF this.GetColumnName() = 'wai_cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(ll_row,'wai_cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

event rowfocuschanged;If currentrow <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(currentrow,TRUE)
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4549
integer height = 1928
long backcolor = 32106727
string text = "불량 발생 내역"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_t2 p_t2
dw_t2_0 dw_t2_0
rr_3 rr_3
dw_t2 dw_t2
end type

on tabpage_2.create
this.p_t2=create p_t2
this.dw_t2_0=create dw_t2_0
this.rr_3=create rr_3
this.dw_t2=create dw_t2
this.Control[]={this.p_t2,&
this.dw_t2_0,&
this.rr_3,&
this.dw_t2}
end on

on tabpage_2.destroy
destroy(this.p_t2)
destroy(this.dw_t2_0)
destroy(this.rr_3)
destroy(this.dw_t2)
end on

type p_t2 from picture within tabpage_2
integer x = 4306
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lfrow, lrowcnt, lcnt
string	sjpno, sitnbr, shpjpno

if ic_status = '1' then
	messagebox('확인','삭제는 수정상태일때만 가능합니다')
	return
end if

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

sjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
if isnull(sjpno) or trim(sjpno) = '' then
	messagebox('확인','처리번호를 지정하세요!!!')
	return
end if

select count(*) into :lcnt from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt = 0 then
	messagebox('확인','잘못된 처리번호입니다.')
	return
end if

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt > 0 then
	messagebox('확인','이미 통보된 자료입니다!!!')
	return
end if

if messagebox('확인','해당 처리번호의 선택된 자료를 삭제합니다.',question!,yesno!,1) = 2 then 
	return
end if

setpointer(hourglass!)

lrowcnt = tab_1.tabpage_2.dw_t2.rowcount() 
FOR lrow = lrowcnt TO 1 STEP -1
	if tab_1.tabpage_2.dw_t2.getitemstring(lrow,'fag_yn') = 'N' then continue
	
	shpjpno = tab_1.tabpage_2.dw_t2.getitemstring(lrow,'shpjpno')
	
	update shpfat
		set gugub = null
	 where sabu = :gs_sabu
		and shpjpno = :shpjpno ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if

	delete from shpfat_qa
	 where sabu = :gs_saupj
		and shpjpno = :shpjpno ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if

	delete from shpfat_qa_cnf
	 where sabu = :gs_saupj and crjpno = :sjpno
		and shpjpno = :shpjpno ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','삭제 실패!!!')
		return
	end if
	
	tab_1.tabpage_2.dw_t2.deleterow(lrow)
NEXT

commit ;

if tab_1.tabpage_2.dw_t2.rowcount() < 1 then
	sitnbr = tab_1.tabpage_2.dw_t2_0.getitemstring(1,'itnbr')
	lfrow = tab_1.tabpage_1.dw_t1.find("itnbr='"+sitnbr+"'",1,tab_1.tabpage_1.dw_t1.rowcount())
	if lfrow > 0 then	tab_1.tabpage_1.dw_t1.deleterow(lfrow)
end if

messagebox('확인','삭제 완료!!!')
end event

type dw_t2_0 from datawindow within tabpage_2
integer width = 3909
integer height = 152
integer taborder = 10
string title = "none"
string dataobject = "d_qa02_00050_03"
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 156
integer width = 4544
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_t2 from datawindow within tabpage_2
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 9
integer y = 164
integer width = 4521
integer height = 1748
integer taborder = 50
string title = "none"
string dataobject = "d_qa02_00050_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

event itemchanged;Long		ll_row 
String	scode, sname, snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)

// 소재품번
IF this.GetColumnName() = 'wai_itnbr' THEN
	scode = this.gettext()
	
	select itdsc into :sname from itemas
	 where itnbr = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'wai_itdsc',sname)
	else
		this.setitem(ll_row,'wai_itnbr',snull)
		this.setitem(ll_row,'wai_itdsc',snull)
		return 1
	end if

// 공급업체
ELSEIF this.GetColumnName() = 'wai_cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'wai_cvnas',sname)
	else
		this.setitem(ll_row,'wai_cvcod',snull)
		this.setitem(ll_row,'wai_cvnas',snull)
		return 1
	end if

END IF
end event

event itemerror;
RETURN 1
end event

event rbuttondown;Long		ll_row
string	snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'wai_itnbr' THEN
	gs_gubun = this.getitemstring(ll_row,'itnbr')

	Open(w_qa02_00050_popup01)
	
	IF isnull(gs_Code)  or  gs_Code = '' or &
	   isnull(gs_Codename)  or  gs_Codename = '' then 
		this.setitem(ll_row,'wai_itnbr',snull)
		this.setitem(ll_row,'wai_itdsc',snull)
		this.setitem(ll_row,'wai_cvcod',snull)
		this.setitem(ll_row,'wai_cvnas',snull)
		return
	End If
	
	String ls_itdsc, ls_cvnas
	
	SELECT B.ITDSC, C.CVNAS2
	  Into :ls_itdsc, :ls_cvnas 
	  FROM DANMST A, ITEMAS B, VNDMST C
	 WHERE A.ITNBR = :gs_code
	   AND A.CVCOD = :gs_codename
		AND A.ITNBR = B.ITNBR
		AND A.CVCOD = C.CVCOD ;

	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33,'')
	Else
		this.setitem(ll_row,'wai_itnbr',gs_code)
		this.setitem(ll_row,'wai_itdsc',ls_itdsc)
		this.setitem(ll_row,'wai_cvcod',gs_codename)
		this.setitem(ll_row,'wai_cvnas',ls_cvnas)
	End If


// 공급업체
ELSEIF this.GetColumnName() = 'wai_cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(ll_row,'wai_cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event rowfocuschanged;//If currentrow <= 0 then
//	this.SelectRow(0,False)
//ELSE
//	this.SelectRow(0, FALSE)
//	this.SelectRow(currentrow,TRUE)
//END IF
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4549
integer height = 1928
long backcolor = 32106727
string text = "불량 상세 내역"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_1 p_1
p_sub p_sub
p_add p_add
dw_t3_0 dw_t3_0
rr_5 rr_5
dw_t3_2 dw_t3_2
rr_4 rr_4
dw_t3_1 dw_t3_1
end type

on tabpage_3.create
this.p_1=create p_1
this.p_sub=create p_sub
this.p_add=create p_add
this.dw_t3_0=create dw_t3_0
this.rr_5=create rr_5
this.dw_t3_2=create dw_t3_2
this.rr_4=create rr_4
this.dw_t3_1=create dw_t3_1
this.Control[]={this.p_1,&
this.p_sub,&
this.p_add,&
this.dw_t3_0,&
this.rr_5,&
this.dw_t3_2,&
this.rr_4,&
this.dw_t3_1}
end on

on tabpage_3.destroy
destroy(this.p_1)
destroy(this.p_sub)
destroy(this.p_add)
destroy(this.dw_t3_0)
destroy(this.rr_5)
destroy(this.dw_t3_2)
destroy(this.rr_4)
destroy(this.dw_t3_1)
end on

type p_1 from picture within tabpage_3
integer x = 4315
integer y = 480
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lcnt
string	scrjpno

if ic_status = '2' then
	scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
	
	select count(*) into :lcnt from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :scrjpno and transyn = 'Y' ;
	if lcnt > 0 then
		messagebox('확인','자재 통보된 내역은 수정 불가합니다')
		return
	end if
end if

if dw_t3_2.accepttext() = -1 then return
if wf_tabpage_3_required_chk() < 1 then return

if dw_t3_2.update() <> 1 then
	rollback ;
	messagebox('확인','불량상세내역 저장 실패')
	return
else
	commit ;
end if

messagebox('확인','자료를 저장하였습니다')
end event

type p_sub from picture within tabpage_3
integer x = 4315
integer y = 328
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lcnt
string	scrjpno

lRow = dw_t3_2.GetRow()
IF lRow < 1	THEN	RETURN

if ic_status = '2' then
	scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
	
	select count(*) into :lcnt from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :scrjpno and transyn = 'Y' ;
	if lcnt > 0 then
		messagebox('확인','자재 통보된 내역은 수정 불가합니다')
		return
	end if
end if

IF f_msg_delete() = -1 THEN	RETURN

dw_t3_2.DeleteRow(lRow)
IF dw_t3_2.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
	Return
Else
	Commit ;
END IF
end event

type p_add from picture within tabpage_3
integer x = 4315
integer y = 176
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lcnt
string	scrjpno, shpjpno, spdtgu, sdepot, SOPSNO, SPINBR

if ic_status = '2' then
	scrjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
	
	select count(*) into :lcnt from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :scrjpno and transyn = 'Y' ;
	if lcnt > 0 then
		messagebox('확인','자재 통보된 내역은 수정 불가합니다')
		return
	end if
end if

lRow = dw_t3_2.InsertRow(0)

shpjpno = dw_t3_0.getitemstring(1,'shpjpno')

select ITNBR, pdtgu, OPSNO into :SPINBR, :spdtgu, :SOPSNO from shpact
 where sabu = :gs_sabu and shpjpno = :shpjpno ;
 
select cvcod into :sdepot from vndmst
 where cvgu = '5' and jumaeip = :spdtgu and soguan = '2' and rownum = 1 ;
if sqlca.sqlcode <> 0 then
	sdepot = 'Z30'
end if

dw_t3_2.setitem(lrow,'sabu',gs_saupj)
dw_t3_2.setitem(lrow,'shpjpno',shpjpno)
dw_t3_2.setitem(lrow,'opsno',SOPSNO)
dw_t3_2.setitem(lrow,'pinbr',SPINBR)
dw_t3_2.setitem(lrow,'depot_no',sdepot)
//dw_t3_2.setitem(lrow,'idate',dw_t3_0.getitemstring(1,'sidat'))
dw_t3_2.setitem(lrow,'crtgbn','M')

dw_t3_2.ScrollToRow(lRow)
dw_t3_2.SetColumn("hcode")
dw_t3_2.SetFocus()




end event

type dw_t3_0 from datawindow within tabpage_3
integer x = 5
integer width = 4343
integer height = 152
integer taborder = 10
string title = "none"
string dataobject = "d_qa02_00050_04"
boolean border = false
boolean livescroll = true
end type

type rr_5 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1179
integer y = 156
integer width = 3081
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_t3_2 from datawindow within tabpage_3
integer x = 1193
integer y = 168
integer width = 3026
integer height = 1744
integer taborder = 110
string title = "none"
string dataobject = "d_qa02_00050_11"
boolean border = false
boolean livescroll = true
end type

event clicked;//If Row <= 0 then
//	this.SelectRow(0,False)
//ELSE
//	this.SelectRow(0, FALSE)
//	this.SelectRow(Row,TRUE)
//END IF
end event

event rowfocuschanged;If currentrow <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(currentrow,TRUE)
END IF
end event

event rbuttondown;Long		ll_row
string	snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'itnbr' THEN
	gs_gubun = dw_t3_0.getitemstring(1,'itnbr')

	Open(w_qa02_00050_popup01)
	
	IF isnull(gs_Code)  or  gs_Code = '' or &
	   isnull(gs_Codename)  or  gs_Codename = '' then 
		this.setitem(ll_row,'itnbr',snull)
		this.setitem(ll_row,'itdsc',snull)
		this.setitem(ll_row,'cvcod',snull)
		this.setitem(ll_row,'cvnas',snull)
		return
	End If
	
	String ls_itdsc, ls_cvnas
	
	SELECT B.ITDSC, C.CVNAS2
	  Into :ls_itdsc, :ls_cvnas 
	  FROM DANMST A, ITEMAS B, VNDMST C
	 WHERE A.ITNBR = :gs_code
	   AND A.CVCOD = :gs_codename
		AND A.ITNBR = B.ITNBR
		AND A.CVCOD = C.CVCOD ;

	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33,'')
	Else
		this.setitem(ll_row,'itnbr',gs_code)
		this.setitem(ll_row,'itdsc',ls_itdsc)
		this.setitem(ll_row,'cvcod',gs_codename)
		this.setitem(ll_row,'cvnas',ls_cvnas)
	End If


// 공급업체
ELSEIF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(ll_row,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event itemchanged;Long		ll_row 
String	scode, sname, snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)

// 소재품번
IF this.GetColumnName() = 'itnbr' THEN
	scode = this.gettext()
	
	select itdsc into :sname from itemas
	 where itnbr = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'itdsc',sname)
	else
		this.setitem(ll_row,'itnbr',snull)
		this.setitem(ll_row,'itdsc',snull)
		return 1
	end if

// 공급업체
ELSEIF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'cvnas',sname)
	else
		this.setitem(ll_row,'cvcod',snull)
		this.setitem(ll_row,'cvnas',snull)
		return 1
	end if

END IF
end event

event itemerror;return 1
end event

type rr_4 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 156
integer width = 1106
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_t3_1 from datawindow within tabpage_3
integer x = 27
integer y = 168
integer width = 1083
integer height = 1744
integer taborder = 50
string title = "none"
string dataobject = "d_qa02_00050_10"
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type rb_1 from radiobutton within w_qa02_00050
integer x = 128
integer y = 56
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "등 록"
boolean checked = true
end type

event clicked;ic_status = '1'
wf_initial()
end event

type rb_2 from radiobutton within w_qa02_00050
integer x = 485
integer y = 56
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "수 정"
end type

event clicked;ic_status = '2'
wf_initial()
end event

type dw_shpfat_qa from datawindow within w_qa02_00050
boolean visible = false
integer x = 4850
integer y = 1172
integer width = 1367
integer height = 608
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "SUM SHPFAT_QA"
string dataobject = "d_sum_shpfat_qa"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type p_2 from picture within w_qa02_00050
integer x = 3849
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lcnt, lrowcnt
string	sjpno, sdate, sdate2, sdate3, status

lrowcnt = tab_1.tabpage_1.dw_t1.rowcount()
if lrowcnt < 1 then return -1
if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

if ic_status = '1' then
	if wf_new_send() = -1 then return
else
	sjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'crjpno'))
	status= trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'status'))
	sdate = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1,'sdate'))

	if status = '통보' then
		messagebox('확인','이미 통보된 자료입니다!!! ~n변경할 수 없습니다.')
		return
	end if

	if f_datechk(sdate) = -1 then
		messagebox('확인','처리일자를 확인하세요!')
		return
	end if

	if wf_re_send() = -1 then return
	
	select cdate into :sdate2 from shpfat_qa_cnf
	 where sabu = :gs_saupj and crjpno = :sjpno and rownum = 1 ;

	if sdate <> sdate2 then
		update shpfat_qa_cnf
			set cdate = :sdate
		 where sabu = :gs_saupj
			and crjpno = :sjpno ;
		if sqlca.sqlcode <> 0 then
			rollback ;
			messagebox('확인','처리일자 변경 실패!!!')
			return
		end if	
	end if

	select cdate into :sdate3 from shpfat_qa
	 where sabu = :gs_saupj and crjpno = :sjpno and rownum = 1 ;

	if sdate <> sdate3 then
		update shpfat_qa
			set cdate = :sdate
		 where sabu = :gs_saupj
			and crjpno = :sjpno ;
		if sqlca.sqlcode <> 0 then
			rollback ;
			messagebox('확인','처리일자 변경 실패!!!')
			return
		end if	
	end if
end if

commit ;

messagebox('확인','저장 완료!!!')
p_can.triggerevent(clicked!)
end event

type p_3 from picture within w_qa02_00050
integer x = 4023
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\전체삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lcnt
string	sjpno

if ic_status = '1' then
	messagebox('확인','삭제는 수정상태일때만 가능합니다')
	return
end if

if tab_1.tabpage_1.dw_t1_0.accepttext() = -1 then return

sjpno = trim(tab_1.tabpage_1.dw_t1_0.getitemstring(1, "crjpno"))
if isnull(sjpno) or trim(sjpno) = '' then
	messagebox('확인','처리번호를 지정하세요!!!')
	return
end if

select count(*) into :lcnt from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt = 0 then
	messagebox('확인','잘못된 처리번호입니다.')
	return
end if

select count(*) into :lcnt from shpfat_qa_sum
 where sabu = :gs_saupj and crjpno = :sjpno ;
if lcnt > 0 then
	messagebox('확인','이미 통보된 자료입니다!!!')
	return
end if

if messagebox('확인','해당 처리번호의 내역전체를 삭제합니다.',question!,yesno!,1) = 2 then 
	return -1
end if

setpointer(hourglass!)

update shpfat a
	set a.gugub = null
 where a.sabu = :gs_sabu
   and exists ( select 'x' from shpfat_qa
 					  where sabu = :gs_saupj and shpjpno = a.shpjpno and crjpno = :sjpno ) ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','삭제 실패!!!')
	return
end if

delete from shpfat_qa
 where sabu = :gs_saupj and crjpno = :sjpno ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','삭제 실패!!!')
	return
end if

delete from shpfat_qa_cnf
 where sabu = :gs_saupj and crjpno = :sjpno ;
if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','삭제 실패!!!')
	return
end if

commit ;

messagebox('확인','삭제 완료!!!')
p_can.triggerevent(clicked!)
end event

type dw_t2_dump from datawindow within w_qa02_00050
boolean visible = false
integer x = 4722
integer width = 571
integer height = 600
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00050_01_1"
boolean border = false
boolean livescroll = true
end type

