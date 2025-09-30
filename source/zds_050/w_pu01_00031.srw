$PBExportHeader$w_pu01_00031.srw
$PBExportComments$** 주간 구매계획 마감
forward
global type w_pu01_00031 from w_inherite
end type
type dw_pomast from datawindow within w_pu01_00031
end type
type dw_poblkt from datawindow within w_pu01_00031
end type
type dw_weekplan from datawindow within w_pu01_00031
end type
type p_1 from picture within w_pu01_00031
end type
type dw_1 from datawindow within w_pu01_00031
end type
type rr_2 from roundrectangle within w_pu01_00031
end type
type dw_insert2 from datawindow within w_pu01_00031
end type
type dw_7 from datawindow within w_pu01_00031
end type
type st_2 from statictext within w_pu01_00031
end type
type cbx_qty from checkbox within w_pu01_00031
end type
type pb_1 from u_pb_cal within w_pu01_00031
end type
type st_3 from statictext within w_pu01_00031
end type
type rr_3 from roundrectangle within w_pu01_00031
end type
type rr_1 from roundrectangle within w_pu01_00031
end type
end forward

global type w_pu01_00031 from w_inherite
integer width = 6309
integer height = 2416
string title = "주간 구매계획 확정"
dw_pomast dw_pomast
dw_poblkt dw_poblkt
dw_weekplan dw_weekplan
p_1 p_1
dw_1 dw_1
rr_2 rr_2
dw_insert2 dw_insert2
dw_7 dw_7
st_2 st_2
cbx_qty cbx_qty
pb_1 pb_1
st_3 st_3
rr_3 rr_3
rr_1 rr_1
end type
global w_pu01_00031 w_pu01_00031

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_taborder_zero ()
public function integer wf_initial ()
public subroutine wf_set_magamyn ()
public function integer wf_plan_add ()
public function integer wf_balju_cnt (string arg_yymmdd, string arg_date, string arg_cvcod, string arg_itnbr)
public function integer wf_balju (string arg_saupj, string arg_yymmdd, string arg_cvcod)
public function integer wf_balju_cancel (string arg_saupj, string arg_yymmdd, string arg_cvcod)
end prototypes

public function integer wf_taborder_zero ();dw_insert.settaborder("qty_01",0)
dw_insert.settaborder("qty_02",0)
dw_insert.settaborder("qty_03",0)
dw_insert.settaborder("qty_04",0)
dw_insert.settaborder("qty_05",0)
dw_insert.settaborder("qty_06",0)
dw_insert.settaborder("qty_07",0)

return 1
end function

public function integer wf_initial ();dw_1.Reset()
dw_7.Reset()
dw_insert.Reset()
dw_insert2.Reset()
dw_pomast.Reset()
dw_poblkt.Reset()
dw_weekplan.Reset()

dw_7.insertrow(0)
dw_7.setitem(1,'gubun','1')
dw_7.triggerevent(itemchanged!)

dw_1.insertrow(0)

string	smaxdate

select max(yymmdd) into :smaxdate from pu03_weekplan
 where waigb = '1' ;
if isnull(smaxdate) or smaxdate = '' then
	smaxdate = f_nearday(f_today(),2)  /* 가장 가까운 월요일 */
	dw_1.Object.sdate[1] = smaxdate
else
	dw_1.Object.sdate[1] = smaxdate
end if
dw_1.setitem(1, 'empno',gs_empno)
dw_1.postevent(itemchanged!)

dw_1.setfocus()

return 1
end function

public subroutine wf_set_magamyn ();string	syymm  ,sjucha ,syymmdd ,syymmdd_pre, stemp, scvcod, ssaupj
Long     ll_jucha , ll_confirm

ssaupj = trim(dw_1.getitemstring(1,'saupj'))
syymmdd = trim(dw_1.getitemstring(1,'sdate'))
scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then sCvcod = ''

If IsNull(ssaupj) Then
	MessageBox('확인', '사업장을 선택 하십시오')
	Return
End If

select yymmdd into :stemp 
 from PU03_WEEKPLAN
 where sabu = :ssaupj and yymmdd = :syymmdd and cvcod like :scvcod||'%' 
   and waigb = '1' and cnftime is not null and rownum = 1 ;

if sqlca.sqlcode = 0 then
	dw_1.setitem(1,'cnfirm','Y')
else
	dw_1.setitem(1,'cnfirm','N')
end if
end subroutine

public function integer wf_plan_add ();
return 1
end function

public function integer wf_balju_cnt (string arg_yymmdd, string arg_date, string arg_cvcod, string arg_itnbr);integer	lcnt

select count(*) into :lcnt from pomast a, poblkt b
 where a.sabu = :gs_sabu and a.cvcod = :arg_cvcod and a.balgu = '1' and a.docno = :arg_yymmdd
	and a.sabu = b.sabu and a.baljpno = b.baljpno and b.nadat = :arg_date
	and b.itnbr = :arg_itnbr and b.balsts <> '4' ;

return lcnt
end function

public function integer wf_balju (string arg_saupj, string arg_yymmdd, string arg_cvcod);////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 발주처리
string	sdate, ssidt, sempno, sdeptno, sittyp, syymm, scvcod
string	sjasa, sbaljpno, sitnbr, sdepot, spdtgu, saccod
long		lrow1, lrow2, lrow3, lins1, lins2, lfrow, lcnt
integer	i, ijucha, dseq
decimal	dunprc, dm01, dm02, dm03, dm04, dm05, dm06, dm07
string	date01, date02, date03, date04, date05, date06, date07

//sdate = f_today()
sdate = arg_yymmdd
date01= arg_yymmdd
date02= f_afterday(arg_yymmdd,1)
date03= f_afterday(arg_yymmdd,2)
date04= f_afterday(arg_yymmdd,3)
date05= f_afterday(arg_yymmdd,4)
date06= f_afterday(arg_yymmdd,5)
date07= f_afterday(arg_yymmdd,6)


// 발주담당자
//sempno= gs_empno	//trim(dw_insert.getitemstring(1,"empno"))
SELECT DATANAME INTO :sempno FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 14 AND LINENO = 1;

// 발주부서
//SELECT DEPTCODE INTO :sdeptno FROM P1_MASTER WHERE EMPNO = :sempno ;			 
SELECT DATANAME INTO :sdeptno FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 12 AND LINENO = 1;

ssidt = arg_yymmdd

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;
 
dw_pomast.reset()
dw_poblkt.reset()
setpointer(hourglass!)

// 주간발주내역만 가져와 발주확정한다
if dw_weekplan.retrieve(arg_saupj,arg_yymmdd, arg_cvcod) < 1 then return -1

// 자재 입고창고 - 2006.08.30 - 한텍
select cvcod into :sdepot from vndmst
 where cvgu = '5' and soguan = '3'  and ipjogun = :arg_saupj and rownum = 1 ;

FOR lrow1 = 1 TO dw_weekplan.rowcount()
	sitnbr = dw_weekplan.getitemstring(lrow1,'itnbr')
	scvcod = dw_weekplan.getitemstring(lrow1,'cvcod')
	saccod = dw_weekplan.getitemstring(lrow1,'accod')
	
	if sjasa = scvcod then continue
	
	lfrow = dw_pomast.find("cvcod = '"+scvcod+"'",1,dw_pomast.rowcount())
	if lfrow > 0 then continue	

	// 발주처리된 자료는 skip - 2009.03.30 - 송병호
	if Trim(dw_weekplan.getitemstring(lrow1,'baljpno')) > '.' then continue

	i = 0
	sbaljpno = '999999999999'
	FOR lrow2 = 1 TO dw_weekplan.rowcount()
		if scvcod <> dw_weekplan.getitemstring(lrow2,'cvcod') then continue
		
		sitnbr = dw_weekplan.getitemstring(lrow2,'itnbr')
		
		dunprc = dw_weekplan.getitemnumber(lrow2,'unprc')
		dm01   = dw_weekplan.getitemnumber(lrow2,'qty_01')
		dm02   = dw_weekplan.getitemnumber(lrow2,'qty_02')
		dm03   = dw_weekplan.getitemnumber(lrow2,'qty_03')
		dm04   = dw_weekplan.getitemnumber(lrow2,'qty_04')
		dm05   = dw_weekplan.getitemnumber(lrow2,'qty_05')
		dm06   = dw_weekplan.getitemnumber(lrow2,'qty_06')
		dm07   = dw_weekplan.getitemnumber(lrow2,'qty_07')	
		
		dw_weekplan.SetItem(lrow2, 'baljpno', sbaljpno)  //주간구매 계획에 발주번호 저장.		

		if dm01 > 0 and wf_balju_cnt(arg_yymmdd, date01, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm01)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm01*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date01)
			dw_poblkt.setitem(lins2,'nadat',date01)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm02 > 0 and wf_balju_cnt(arg_yymmdd, date02, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm02)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm02*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date02)
			dw_poblkt.setitem(lins2,'nadat',date02)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm03 > 0 and wf_balju_cnt(arg_yymmdd, date03, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm03)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm03*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date03)
			dw_poblkt.setitem(lins2,'nadat',date03)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm04 > 0 and wf_balju_cnt(arg_yymmdd, date04, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm04)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm04*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date04)
			dw_poblkt.setitem(lins2,'nadat',date04)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm05 > 0 and wf_balju_cnt(arg_yymmdd, date05, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm05)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm05*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date05)
			dw_poblkt.setitem(lins2,'nadat',date05)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm06 > 0 and wf_balju_cnt(arg_yymmdd, date06, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm06)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm06*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date06)
			dw_poblkt.setitem(lins2,'nadat',date06)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm07 > 0 and wf_balju_cnt(arg_yymmdd, date07, scvcod, sitnbr) = 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',arg_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm07)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm07*dunprc,0))
			dw_poblkt.setitem(lins2,'poblkt_gudat',date07)
			dw_poblkt.setitem(lins2,'nadat',date07)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
	NEXT


	// 발주품목정보(POBLKT) 가 작성되었을 경우에만 발주마스타정보(POMAST) 작성
	IF i > 0 THEN
		dseq = SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'K0')
		if dseq = -1 then 
			rollback;
			f_message_chk(51, 'err')
			return -1
		end if
		Commit;
		sbaljpno = sdate + string(dseq, '0000')
	
		lins1 = dw_pomast.insertrow(0)
		dw_pomast.setitem(lins1,'sabu',gs_sabu)
		dw_pomast.setitem(lins1,'baljpno',sbaljpno)
		dw_pomast.setitem(lins1,'bal_empno',sempno)
		dw_pomast.setitem(lins1,'baldate',sdate)
		dw_pomast.setitem(lins1,'balgu','1') // 생산용(계획)
		dw_pomast.setitem(lins1,'cvcod',scvcod)
		dw_pomast.setitem(lins1,'bal_suip','1')
		dw_pomast.setitem(lins1,'saupj',arg_saupj)
		dw_pomast.setitem(lins1,'docno', arg_yymmdd)
		// 발주품목정보(POMAST)에 발주번호 기록
		lfrow = 0
		do while true
			lfrow = dw_poblkt.find("baljpno='999999999999'", lfrow, dw_poblkt.rowcount())
			if lfrow > 0 then
				dw_poblkt.setitem(lfrow,'baljpno',sbaljpno)
				lfrow++
				if lfrow > dw_poblkt.rowcount() then exit
			else
				exit
			end if
		loop
		// 주간구매계획에 발주번호 적용
		lfrow = 0
		do while true
			lfrow = dw_weekplan.find("baljpno='999999999999'", 1, dw_weekplan.rowcount())
			if lfrow > 0 then
				dw_weekplan.setitem(lfrow,'baljpno',sbaljpno)
				lfrow++
				if lfrow > dw_weekplan.rowcount() then exit
			else
				exit
			end if
		loop
	END IF
NEXT

if dw_pomast.update() = 1 then
	if dw_poblkt.update() <> 1 then
		rollback ;
		messagebox("저장실패", "주간 발주처리를 실패하였습니다 [POBLKT]")
		return -1
   end if
else
	rollback ;
	messagebox("저장실패", "주간 발주처리를 실패하였습니다 [POMAST]")
	return -1
end if

if dw_weekplan.update() <> 1 then
	rollback ;
	messagebox("저장실패", "주간 구매계획갱신을  실패하였습니다 [PU03_WEEKPLAN]")
	return -1
end if
	
messagebox('확인','주간 발주처리를 완료하였습니다.')

return 1
end function

public function integer wf_balju_cancel (string arg_saupj, string arg_yymmdd, string arg_cvcod);dw_weekplan.Retrieve(arg_saupj, arg_yymmdd, arg_cvcod)

Long   ll_cnt

ll_cnt = dw_weekplan.RowCount()
If ll_cnt < 1 Then Return -1

Long   i
Long   ll_chk
Long   ll_scm
String ls_baljpno

For i = 1 To ll_cnt
	ls_baljpno = dw_weekplan.GetItemString(i, 'baljpno')
	
	/* 출발처리 항목 확인 - SCM */
	SELECT COUNT('X')
	  INTO :ll_scm
	  FROM POBLKT_HIST
	 WHERE BALJPNO = :ls_baljpno ;
	If ll_scm > 0 Then Continue
//	If ll_scm > 0 Then
//		MessageBox('출발처리 확인 - SCM', '이미 SCM에서 출발처리 된 발주내역이 있습니다.')
//		Return -1
//	End If
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM POMAST
	 WHERE BALJPNO = :ls_baljpno ;
	If ll_chk > 0 Then
		DELETE FROM POMAST
		 WHERE BALJPNO = :ls_baljpno ;
		 
		 COMMIT;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			Return -1
		End If
		
		DELETE FROM POBLKT
		 WHERE BALJPNO = :ls_baljpno ;
		 
		 COMMIT;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			Return -1
		End If
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	Return -1
End If

Return 0

/*
long	lcnt

SELECT COUNT(*)
  INTO :lcnt
  FROM POMAST A,
  		 POBLKT B
 WHERE A.SABU 		= B.SABU
 	AND A.BALJPNO  = B.BALJPNO
	AND A.SABU		= :gs_sabu
	AND A.DOCNO		= :arg_yymmdd
	AND A.BALGU		= '1'		/* 생산용 */
	AND A.CVCOD LIKE :arg_cvcod||'%'
	AND B.SAUPJ		= :gs_saupj
	AND B.BALSTS   = '1' ;

if lcnt > 0 then
	messagebox('확인','발주 처리된 자료가 존재합니다')
	return -1
end if
*/  

//string	sbaljpno
//
//SELECT A.BALJPNO 
//  INTO :sbaljpno 
//  FROM POMAST A,
//  		 POBLKT B
// WHERE A.SABU 		= :gs_sabu
//   AND A.DOCNO 	= :arg_yymmdd
//	AND A.BALGU		= '1'		/* 생산용 */
//	AND A.CVCOD 	LIKE :arg_cvcod||'%'
//	AND A.SABU 		= B.SABU
//	AND A.BALJPNO 	= B.BALJPNO
//	AND B.SAUPJ	  	= :gs_saupj
//	AND B.BALSTS  	= '1' 
//	AND ROWNUM 	  	= 1 ;
//
//if sqlca.sqlcode = 0 then
//	UPDATE POBLKT
//		SET BALSTS = '4'
//	 WHERE SABU = :gs_sabu
//	   AND SAUPJ= :gs_saupj
//	 	AND EXISTS ( SELECT 'X' FROM POMAST
//					  	  WHERE SABU 	= POBLKT.SABU
//						    AND BALJPNO= POBLKT.BALJPNO
//						    AND DOCNO 	= :arg_yymmdd
//							 AND A.BALGU= '1'		/* 생산용 */
//							 AND CVCOD 	LIKE :arg_cvcod||'%') ;
//	if sqlca.sqlcode <> 0 then
//		rollback ;
//		messagebox('확인','발주자료를 취소할 수 없습니다')
//		return -1
//	end if
//end if

return 1
end function

on w_pu01_00031.create
int iCurrent
call super::create
this.dw_pomast=create dw_pomast
this.dw_poblkt=create dw_poblkt
this.dw_weekplan=create dw_weekplan
this.p_1=create p_1
this.dw_1=create dw_1
this.rr_2=create rr_2
this.dw_insert2=create dw_insert2
this.dw_7=create dw_7
this.st_2=create st_2
this.cbx_qty=create cbx_qty
this.pb_1=create pb_1
this.st_3=create st_3
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pomast
this.Control[iCurrent+2]=this.dw_poblkt
this.Control[iCurrent+3]=this.dw_weekplan
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.dw_insert2
this.Control[iCurrent+8]=this.dw_7
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cbx_qty
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_1
end on

on w_pu01_00031.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_pomast)
destroy(this.dw_poblkt)
destroy(this.dw_weekplan)
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.rr_2)
destroy(this.dw_insert2)
destroy(this.dw_7)
destroy(this.st_2)
destroy(this.cbx_qty)
destroy(this.pb_1)
destroy(this.st_3)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)
dw_pomast.settransobject(sqlca)
dw_poblkt.settransobject(sqlca)
dw_weekplan.settransobject(sqlca)

wf_taborder_zero()
wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00031
integer x = 69
integer y = 304
integer width = 4489
integer height = 1912
string dataobject = "d_pu01_00031_3_new2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::other;call super::other;//CONSTANT integer WM_MOUSEWHEEL = 522 
//
//IF message.number = WM_MOUSEWHEEL AND & 
//    KeyDown (KeyControl!) THEN 
//  message.processed = TRUE 
//  RETURN 1 
//END IF 
//
end event

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//	
//	this.selectrow(0,false)
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
if row <= 0 then return
this.selectrow(row,true)
end event

type p_delrow from w_inherite`p_delrow within w_pu01_00031
boolean visible = false
integer x = 5659
integer y = 592
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pu01_00031
boolean visible = false
integer x = 5486
integer y = 592
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu01_00031
integer x = 3598
integer y = 40
boolean originalsize = true
string picturename = "C:\erpman\image\확정취소_up.gif"
boolean focusrectangle = true
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\마감취소_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\마감취소_UP.gif"
end event

event p_search::clicked;string	syymm  ,sjucha ,syymmdd ,ls_confirm_t
Long     ll_jucha , ll_cnt , ll_confirm
String   sCvcod, ssaupj

If dw_1.AcceptText() <> 1 Then Return

ssaupj = Trim(dw_1.GetItemString(1,'saupj'))
If ssaupj = '' OR IsNull(ssaupj) Then
	f_message_chk(35, '[사업장]')
	Return
End If

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자]')
	Return
End if

scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then sCvcod = ''

SELECT COUNT('x') Into :ll_cnt
  FROM PU03_WEEKPLAN
 WHERE SABU = :ssaupj
   AND YYMMDD = :sYymmdd
	and cvcod like :scvcod||'%'
	AND WAIGB = '1'
	AND CNFTIME IS NOT NULL ;
	
If ll_cnt < 1 Then
	Return
Else
	SELECT COUNT(*) Into :ll_cnt
	  FROM PU03_WEEKPLAN A
	 WHERE A.SABU = :ssaupj
		AND A.YYMMDD = :sYymmdd
		and a.cvcod like :scvcod||'%'
		AND A.WAIGB = '1'
		AND A.WEBCNF IS NOT NULL ;
	
	if ll_cnt > 0 then
		messagebox('확인','이미 WEB 전송 처리가 완료된 자료입니다.')
		RETURN
	END IF
	
End If

If  MessageBox("확정", '주간 구매계획을 확정취소처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
setpointer(hourglass!)
SetNull(ls_confirm_t)

UPDATE PU03_WEEKPLAN
   SET CNFTIME = :ls_confirm_t,
		 BALJPNO = NULL
 WHERE SABU = :ssaupj
   AND YYMMDD = :sYymmdd
	and cvcod like :scvcod||'%'
	AND WAIGB = '1'
	And CNFTIME is not null ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정취소 처리되었습니다.!!')
dw_1.triggerevent(itemchanged!)
end event

type p_ins from w_inherite`p_ins within w_pu01_00031
boolean visible = false
integer x = 5312
integer y = 592
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pu01_00031
integer x = 4256
integer y = 40
end type

event p_exit::clicked;close(parent)
end event

type p_can from w_inherite`p_can within w_pu01_00031
integer x = 4078
integer y = 40
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00031
boolean visible = false
integer x = 4965
integer y = 592
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00031
integer x = 3241
integer y = 40
end type

event p_inq::clicked;call super::clicked;string	syymm  ,sjucha ,syymmdd ,ls_confirm, sgubun, sitcls, scvcod, sittyp, sitnbr, ssaupj
Long     ll_jucha ,ll_cnt

if dw_1.accepttext() = -1 then return

ssaupj = trim(dw_1.getitemstring(1,'saupj'))
If ssaupj = '' OR IsNull(ssaupj) Then
	f_message_chk(35,'[사업장]')
	Return
End If

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획년월')
	Return
End if

If DayNumber(Date( Left(syymmdd,4)+'-'+Mid(syymmdd,5,2) +'-'+Right(syymmdd,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	Return
End If

sitcls = trim(dw_1.getitemstring(1,'itcls'))
If IsNull(sItcls) Then sItcls = ''

sittyp = trim(dw_1.getitemstring(1,'ittyp'))
If IsNull(sittyp) Then sittyp = ''

scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then scvcod = ''

sitnbr = trim(dw_1.getitemstring(1,'itnbr'))
If IsNull(sitnbr) or sitnbr = '' Then sitnbr = '%'

sgubun = trim(dw_1.getitemstring(1,'gubun'))

SELECT COUNT('x') Into :ll_cnt
  FROM PU03_WEEKPLAN
 WHERE SABU = :ssaupj
   AND YYMMDD = :syymmdd
	AND WAIGB = '1' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'주간 구매계획')
	Return
End If


setpointer(hourglass!)
If dw_insert.Retrieve(ssaupj,syymmdd,sgubun, sItcls+'%', scvcod+'%', sittyp+'%', sitnbr) <= 0 Then
	f_message_chk(50,'주간 구매계획')
End If


////////////////////////////////////////////////////////////////////////////////////
// FILTER
if cbx_qty.checked then
	dw_insert.setfilter("sum_week > 0")
else
	dw_insert.setfilter("")
end if
dw_insert.filter()
////////////////////////////////////////////////////////////////////////////////////


dw_7.setitem(1,'gubun','2')
dw_7.postevent(itemchanged!)
end event

type p_del from w_inherite`p_del within w_pu01_00031
boolean visible = false
integer x = 5129
integer y = 312
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pu01_00031
integer x = 3419
integer y = 40
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::ue_lbuttondown;//PictureName = "C:\erpman\image\마감처리_dn.gif"
end event

event p_mod::ue_lbuttonup;//PictureName = "C:\erpman\image\마감처리_UP.gif"
end event

event p_mod::clicked;string	syymm  ,sjucha ,syymmdd ,ls_confirm_t
Long     ll_jucha , ll_cnt , ll_confirm
String   sCvcod, ssaupj

If dw_1.AcceptText() <> 1 Then Return

ssaupj = trim(dw_1.getitemstring(1, 'saupj'))
If ssaupj = '' OR IsNull(ssaupj) Then
	f_message_chk(35,'[사업장]')
	Return
End If

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자]')
	Return
End if

scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then sCvcod = ''

select Count('x') into :ll_cnt
  from pu03_weekplan
 where sabu = :ssaupj 
   and yymmdd = :syymmdd 
	and cvcod like :scvcod||'%'
	and waigb = '1' ;
	
If SQLCA.SQLCODE <> 0 OR ll_cnt < 1 Then
	MessageBox('확인','해당 계획일자로 구매계획이 존재하지 않습니다. 다시 확인 하세요.')
	dw_1.setfocus()
	Return
End If

select Count(cnftime) into :ll_confirm 
  from pu03_weekplan
 where sabu = :ssaupj 
   and yymmdd = :syymmdd
	and cvcod like :scvcod||'%'
	and waigb = '1'
	and cnftime is not null ;
	
if ll_confirm > 0 then
	MessageBox('확인','해당 계획일자로 이미 확정된 구매계획이 존재합니다.  다시 확인 하세요.')
	dw_1.setfocus()
	Return	
end If


If  MessageBox("확인", '주간 구매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
setpointer(hourglass!)

/* 박홍섭대리 요청으로 통코일 전개는 제외 - by shingoon 2009.05.20 **********************************/
/****************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////
// 통코일 소요량 전개
string	serror
serror = 'X'
Sqlca.erp000000050_7_hantec(ssaupj, syymmdd, '3', serror);				
IF serror <> 'N' THEN
	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	ROLLBACK;
	messagebox("확 인", "통코일 소요량 전개가 실패하였습니다.!!")
	Return
else
	Commit;
END IF
///////////////////////////////////////////////////////////////////////////////////////////
*****************************************************************************************************/
/*****************************************************************************************************/

ls_confirm_t = f_today() + ' ' +f_totime()

UPDATE PU03_WEEKPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :ssaupj
   AND YYMMDD = :sYymmdd
	and cvcod like :scvcod||'%'
	AND WAIGB = '1' ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	dw_1.setfocus()
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정 처리되었습니다.!!')
dw_1.triggerevent(itemchanged!)
end event

event p_mod::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_mod)
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00031
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00031
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00031
end type

type cb_del from w_inherite`cb_del within w_pu01_00031
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00031
end type

type cb_print from w_inherite`cb_print within w_pu01_00031
end type

type st_1 from w_inherite`st_1 within w_pu01_00031
end type

type cb_can from w_inherite`cb_can within w_pu01_00031
end type

type cb_search from w_inherite`cb_search within w_pu01_00031
end type







type gb_button1 from w_inherite`gb_button1 within w_pu01_00031
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00031
end type

type dw_pomast from datawindow within w_pu01_00031
boolean visible = false
integer x = 4677
integer y = 1236
integer width = 864
integer height = 232
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "POMAST"
string dataobject = "d_pu01_00030_pomast"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_poblkt from datawindow within w_pu01_00031
boolean visible = false
integer x = 4677
integer y = 1580
integer width = 832
integer height = 260
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "POBLKT"
string dataobject = "d_pu01_00030_poblkt"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_weekplan from datawindow within w_pu01_00031
boolean visible = false
integer y = 1868
integer width = 4558
integer height = 360
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "WEEKPLAN"
string dataobject = "d_pu01_00031_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type p_1 from picture within w_pu01_00031
integer x = 3771
integer y = 40
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\WEB.gif"
boolean focusrectangle = false
end type

event clicked;string	syymm  ,sjucha ,syymmdd ,ls_confirm_t, stemp
Long     ll_jucha , ll_cnt , ll_confirm
String   sCvcod, ssaupj

If dw_1.AcceptText() <> 1 Then Return

ssaupj = trim(dw_1.getitemstring(1,'saupj'))
If ssaupj = '' or IsNull(ssaupj) Then
	f_message_chk(35,'[사업장]')
	Return
End If

scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then sCvcod = ''

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자]')
	Return
End if

SELECT CNFTIME INTO :stemp FROM PU03_WEEKPLAN
 WHERE SABU = :ssaupj 
 	AND YYMMDD = :syymmdd 
   and cvcod like :scvcod||'%'
	AND WAIGB = '1' 
	AND CNFTIME IS NOT NULL
	AND ROWNUM = 1 ;

IF SQLCA.SQLCODE <> 0 THEN
	MESSAGEBOX('확인','먼저 확정 처리를 하십시오.')
	return
end if


SELECT MIN(WEBCNF) INTO :stemp FROM PU03_WEEKPLAN
 WHERE SABU = :ssaupj 
 	AND YYMMDD = :syymmdd
	and cvcod like :scvcod||'%'
	AND WAIGB = '1' 
	AND CNFTIME IS NOT NULL;

IF isnull(stemp) or stemp = '' THEN
	If  MessageBox("확정", '주간 구매계획을 WEB 전송처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	ls_confirm_t = f_today() + ' ' +f_totime()
	
	UPDATE PU03_WEEKPLAN
		SET WEBCNF = :ls_confirm_t
	 WHERE SABU = :ssaupj
		AND YYMMDD = :sYymmdd
		and cvcod like :scvcod||'%'
		AND WAIGB = '1'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	
	if wf_balju(ssaupj, syymmdd, scvcod) = -1 then
		rollback ;
		messagebox('확인','주간 계획에 대한 발주처리를 실패하였습니다')
		return
	end if

	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 처리되었습니다.!!')
	
	long		lseq
	string	subject, scontent
	
	subject = left(syymm,4) + '계획일자 ' + string(syymmdd,'@@@@.@@.@@') + ' 구매계획 확정 통보!!!'
	scontent= '주간 구매계획이 확정되었습니다.~n업무에 참고하십시오'
	
//	/* 전주 발주 강제 완료처리(곽윤호부장) - 2009.05.03 BY SHINGOON */
//	UPDATE POBLKT A
//	   SET A.BALSTS = '3'
//	 WHERE A.BALSTS = '1'
//		AND EXISTS (  SELECT 'X' FROM POMAST B
//							WHERE B.BALDATE BETWEEN TO_CHAR(TO_DATE(:syymmdd, 'YYYYMMDD') - 7, 'YYYYMMDD')
//							                    AND TO_CHAR(TO_DATE(:syymmdd, 'YYYYMMDD') - 1, 'YYYYMMDD')
//							  AND B.PLNCRT  = '1' //계획발주
//							  AND B.BALGU   = '1' //구매용 발주
//							  AND B.SABU    = A.SABU
//							  AND B.BALJPNO = A.BALJPNO ) ;
//   If SQLCA.SQLCODE <> 0 Then
//		ROLLBACK USING SQLCA;
//		MessageBox('전주 발주 완료처리', '발주 완료 처리 중 오류가 발생했습니다.')
//		Return
//	End If
//	
//	COMMIT USING SQLCA ;
	
	select nvl(max(no),0) into :lseq from et_notice;
	
	lseq = lseq + 1
	
	insert into et_notice
	(	no,			subject,				content,				cre_id,				cre_dt,			cvcod	)
	values
	(	:lseq,		:subject,			:scontent,			:gs_userid,			sysdate,			'TOTAL'	) ;
	if sqlca.sqlcode <> 0 then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	COMMIT;
ELSE
	/////////////////////////////////////////////////////////////
	// 발주취소가능 체크
	If wf_balju_cancel(ssaupj, syymmdd,scvcod) = -1 Then
		MessageBox('SCM 취소처리', 'SCM 전송취소 작업 중 오류가 발생했습니다.')
		Return
	End If

	If  MessageBox("확정", '주간 구매계획을 WEB 전송 취소처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)

	setnull(ls_confirm_t)
	
	UPDATE PU03_WEEKPLAN
		SET WEBCNF = :ls_confirm_t, BALJPNO = NULL
	 WHERE SABU = :ssaupj
		AND YYMMDD = :sYymmdd
		and cvcod like :scvcod||'%'
		AND WAIGB = '1'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If	
	
	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 취소 처리되었습니다.!!')
END IF
end event

type dw_1 from datawindow within w_pu01_00031
integer x = 69
integer y = 8
integer width = 2734
integer height = 256
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00031_2_new"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	scolnm , sdate, scnfirm,s_empno, s_name, get_nm,sitnbr,sitdsc
Int      ireturn
string snull


setnull(snull)
scolnm = Lower(GetColumnName())

Choose Case scolnm
	Case 'saupj'
		String  ls_rfgub, ls_saupj
		ls_saupj = This.GetText()
		SELECT RFGUB INTO :ls_rfgub FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :ls_saupj ;
		If Trim(ls_rfgub) = '' OR IsNull(ls_rfgub) Then
			MessageBox('확인', '해당 사업장 코드는 지정된 생산팀이 없습니다.')
			Return
		End If
		
		This.SetItem(1, 'gubun', ls_rfgub)
		
	Case "cvcod"
		s_empno = this.GetText()
		s_name  = this.getitemstring(1,"cvcod")
		
		ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
		this.setitem(1, "cvcod", s_empno)	
		this.setitem(1, "cvnas", get_nm)
		
		if isnull(s_name) or s_name = '' then
			this.setitem(1, "cvcod", s_empno)	
			this.setitem(1, "cvnas", get_nm)
		end if
		RETURN ireturn
	Case 'sdate'
		sdate = this.gettext()
		If DayNumber(Date( Left(sdate,4)+'-'+Mid(sdate,5,2) +'-'+Right(sdate,2) )) <> 2 Then
			MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
			Return 1
		End If
	/* 품목분류 지정 */
	Case 'itcls'
		string	s_ittyp, s_itcls, s_titnm
		s_ittyp = trim(this.getitemstring(1,'ittyp'))
		if isnull(s_ittyp) or s_ittyp = '' then
			messagebox('확인','품목구분을 지정하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		s_itcls = trim(this.gettext())
		if isnull(s_itcls) or s_itcls = '' then
			messagebox('확인','품목분류를 지정하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		select titnm into :s_titnm from itnct where ittyp = :s_ittyp and itcls = :s_itcls ;
		if sqlca.sqlcode <> 0 then
			messagebox('확인','품목분류를 확인하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		this.setitem(1,'titnm',s_titnm)
	Case "itnbr"
		sItnbr = trim(GetText())
	
		Select itnbr , itdsc 
		  Into :sitnbr, :sitdsc
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
		Else
			setitem(1, "itnbr", snull)	
			setitem(1, "itdsc", snull)	
		End IF	
End Choose

post wf_set_magamyn()
end event

event itemerror;return 1
end event

event rbuttondown;String sNull, sdate

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)


IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
End If

IF this.GetColumnName() = "itcls" Then
	 OpenWithParm(w_ittyp_popup, this.getitemstring(1,'ittyp'))
    str_sitnct = Message.PowerObjectParm	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
End If

IF this.GetColumnName() =  'itnbr' Then
		gs_code = Trim(this.GetText())
		gs_gubun = '3'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
End If
end event

type rr_2 from roundrectangle within w_pu01_00031
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer width = 2770
integer height = 272
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert2 from datawindow within w_pu01_00031
boolean visible = false
integer x = 69
integer y = 340
integer width = 4489
integer height = 1876
integer taborder = 60
string title = "none"
string dataobject = "d_pu01_00031_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
end event

event doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','1')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//
//	this.selectrow(0,false)
//	dw_insert.setrow(lrow)
//	dw_insert.selectrow(0,false)
//	dw_insert.selectrow(lrow,true)
//	dw_insert.scrolltorow(lrow)	
//end if
end event

type dw_7 from datawindow within w_pu01_00031
boolean visible = false
integer x = 4681
integer y = 124
integer width = 453
integer height = 148
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00011_4"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_insert.setredraw(false)
dw_insert2.setredraw(false)

if this.gettext() = '1' then
//	st_2.visible = false
//	dw_insert.visible = true
//	dw_insert2.visible = false
else
//	st_2.visible = true
//	dw_insert.visible = false
//	dw_insert2.visible = true
end if

dw_insert.setredraw(true)
dw_insert2.setredraw(true)
end event

type st_2 from statictext within w_pu01_00031
boolean visible = false
integer x = 2688
integer y = 24
integer width = 507
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "(금액단위:천원)"
boolean focusrectangle = false
end type

type cbx_qty from checkbox within w_pu01_00031
integer x = 2889
integer y = 68
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "계획량 "
end type

event clicked;////////////////////////////////////////////////////////////////////////////////////
// FILTER
if this.checked then
	dw_insert.setfilter("sum_week > 0")
else
	dw_insert.setfilter("")
end if
dw_insert.filter()
////////////////////////////////////////////////////////////////////////////////////

end event

type pb_1 from u_pb_cal within w_pu01_00031
integer x = 690
integer y = 12
integer taborder = 31
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF IsNull(gs_code) THEN Return 

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	Return 1
End If

dw_1.SetItem(1, 'sdate', gs_code)

post wf_set_magamyn()
end event

type st_3 from statictext within w_pu01_00031
integer x = 2939
integer y = 148
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "有만 표시"
boolean focusrectangle = false
end type

type rr_3 from roundrectangle within w_pu01_00031
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4677
integer y = 96
integer width = 471
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pu01_00031
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 292
integer width = 4507
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

