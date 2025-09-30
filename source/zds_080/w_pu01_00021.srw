$PBExportHeader$w_pu01_00021.srw
$PBExportComments$** 월 구매계획 마감처리
forward
global type w_pu01_00021 from w_inherite
end type
type p_1 from picture within w_pu01_00021
end type
type dw_7 from datawindow within w_pu01_00021
end type
type dw_1 from datawindow within w_pu01_00021
end type
type st_2 from statictext within w_pu01_00021
end type
type dw_pomast from datawindow within w_pu01_00021
end type
type dw_poblkt from datawindow within w_pu01_00021
end type
type dw_weekplan from datawindow within w_pu01_00021
end type
type rr_2 from roundrectangle within w_pu01_00021
end type
type rr_3 from roundrectangle within w_pu01_00021
end type
type rr_1 from roundrectangle within w_pu01_00021
end type
type dw_insert2 from datawindow within w_pu01_00021
end type
type pb_1 from u_pb_cal within w_pu01_00021
end type
end forward

global type w_pu01_00021 from w_inherite
integer width = 4608
string title = "월 구매계획 확정"
p_1 p_1
dw_7 dw_7
dw_1 dw_1
st_2 st_2
dw_pomast dw_pomast
dw_poblkt dw_poblkt
dw_weekplan dw_weekplan
rr_2 rr_2
rr_3 rr_3
rr_1 rr_1
dw_insert2 dw_insert2
pb_1 pb_1
end type
global w_pu01_00021 w_pu01_00021

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_taborder_zero ()
public function integer wf_initial ()
public function integer wf_balju (string arg_yymmdd, string arg_cvcod)
public function integer wf_balju_cancel (string arg_yymmdd, string arg_cvcod)
end prototypes

public function integer wf_taborder_zero ();dw_insert.settaborder("qty_01",0)
dw_insert.settaborder("qty_02",0)
dw_insert.settaborder("qty_03",0)
dw_insert.settaborder("qty_04",0)
dw_insert.settaborder("qty_05",0)
dw_insert.settaborder("qty_06",0)

return 1
end function

public function integer wf_initial ();dw_1.Reset()
dw_7.Reset()
dw_insert.Reset()
dw_insert2.Reset()

dw_7.insertrow(0)
dw_7.setitem(1,'gubun','1')
dw_7.triggerevent(itemchanged!)

dw_1.insertrow(0)

string	smaxyymm

select max(yymm) into :smaxyymm from pu02_monplan ;
if isnull(smaxyymm) or smaxyymm = '' then
	dw_1.Object.yymm[1] = Left(f_today(),6)
else	
	dw_1.Object.yymm[1] = smaxyymm
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()

return 1
end function

public function integer wf_balju (string arg_yymmdd, string arg_cvcod);////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 발주처리
string	sdate, ssidt, sempno, sdeptno, sittyp, syymm, scvcod, sgudat
string	sjasa, sbaljpno, sitnbr, sdepot, spdtgu, saccod
long		lrow1, lrow2, lrow3, lins1, lins2, lfrow, lcnt
integer	i, ijucha, dseq
decimal	dunprc, dm01, dm02, dm03, dm04, dm05, dm06, dmqty

sdate = f_today()

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

// 월 발주내역만 조회후 발주 확정한다
if dw_weekplan.retrieve(gs_saupj,arg_yymmdd, arg_cvcod) < 1 then return -1

FOR lrow1 = 1 TO dw_weekplan.rowcount()
	sitnbr = dw_weekplan.getitemstring(lrow1,'itnbr')
	scvcod = dw_weekplan.getitemstring(lrow1,'cvcod')
	saccod = dw_weekplan.getitemstring(lrow1,'accod')
	
	if sjasa = scvcod then continue
	
	lfrow = dw_pomast.find("cvcod = '"+scvcod+"'",1,dw_pomast.rowcount())
	if lfrow > 0 then continue
	
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
	dw_pomast.setitem(lins1,'saupj',gs_saupj)
	dw_pomast.setitem(lins1,'docno', arg_yymmdd)

	i = 0
	FOR lrow2 = 1 TO dw_weekplan.rowcount()
		if scvcod <> dw_weekplan.getitemstring(lrow2,'cvcod') then continue
		
		sitnbr = dw_weekplan.getitemstring(lrow2,'itnbr')
		
		// 자재 입고창고는 생산창고로 대신
		select cvcod into :sdepot from vndmst
		 where cvgu = '5' and jumaechul = '1'  and ipjogun = :gs_saupj and rownum = 1 ;
		 
		dunprc = dw_weekplan.getitemnumber(lrow2,'unprc')
		dm01   = dw_weekplan.getitemnumber(lrow2,'qty_01')
		dm02   = dw_weekplan.getitemnumber(lrow2,'qty_02')
		dm03   = dw_weekplan.getitemnumber(lrow2,'qty_03')
		dm04   = dw_weekplan.getitemnumber(lrow2,'qty_04')
		dm05   = dw_weekplan.getitemnumber(lrow2,'qty_05')
		dm06   = dw_weekplan.getitemnumber(lrow2,'qty_06')
		
		// 월총계 발주
		dmqty = dm01 + dm02 + dm03 + dm04 + dm05 + dm06
//		if dmqty > 0 then
//			i++
//			lins2 = dw_poblkt.insertrow(0)
//			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
//			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
//			dw_poblkt.setitem(lins2,'balseq',i)
//			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
//			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
//			dw_poblkt.setitem(lins2,'balqty',dmqty)
//			dw_poblkt.setitem(lins2,'balsts','1')
//			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
//			dw_poblkt.setitem(lins2,'unprc',dunprc)
//			dw_poblkt.setitem(lins2,'unamt',truncate(dmqty*dunprc,0))
//			dw_poblkt.setitem(lins2,'poblkt_gudat',f_last_date(ssidt+'01'))
//			dw_poblkt.setitem(lins2,'nadat',f_last_date(ssidt+'01'))
//			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
//			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
//			dw_poblkt.SetItem(lins2,'accod',saccod)
//		end if

		if dm01 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm01)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm01*dunprc,0))
			
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 1;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',ssidt)
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm02 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm02)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm02*dunprc,0))
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 2;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',f_afterday(ssidt,1))
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm03 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm03)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm03*dunprc,0))
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 3;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',f_afterday(ssidt,2))
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm04 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm04)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm04*dunprc,0))
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 4;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',f_afterday(ssidt,3))
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm05 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm05)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm05*dunprc,0))
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 5;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',f_afterday(ssidt,4))
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
		if dm06 > 0 then
			i++
			lins2 = dw_poblkt.insertrow(0)
			dw_poblkt.setitem(lins2,'sabu',gs_sabu)
			dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
			dw_poblkt.setitem(lins2,'balseq',i)
			dw_poblkt.setitem(lins2,'saupj',gs_saupj)
			dw_poblkt.setitem(lins2,'itnbr',sitnbr)
			dw_poblkt.setitem(lins2,'balqty',dm06)
			dw_poblkt.setitem(lins2,'balsts','1')
			dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
			dw_poblkt.setitem(lins2,'unprc',dunprc)
			dw_poblkt.setitem(lins2,'unamt',truncate(dm06*dunprc,0))
			select week_sdate into :sgudat from pdtweek where week_sdate like :ssidt||'%' and mon_jucha = 6;
			dw_poblkt.setitem(lins2,'poblkt_gudat',sgudat)
			dw_poblkt.setitem(lins2,'nadat',f_afterday(ssidt,5))
			dw_poblkt.setitem(lins2,'rdptno',sdeptno)
			dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
			dw_poblkt.SetItem(lins2,'accod',saccod)
		end if
	NEXT
NEXT

if dw_pomast.update() = 1 then
	if dw_poblkt.update() <> 1 then
		rollback ;
		messagebox("저장실패", "월 발주처리를 실패하였읍니다 [POBLKT]")
		return -1
   end if
else
	rollback ;
	messagebox("저장실패", "월 발주처리를 실패하였읍니다 [POMAST]")
	return -1
end if

//if dw_weekplan.update() <> 1 then
//	rollback ;
//	messagebox("저장실패", "월 구매계획갱신을  실패하였읍니다 [PU03_WEEKPLAN]")
//	return -1
//end if
COMMIT;

messagebox('확인','월 발주처리를 완료하였습니다.')

return 1
end function

public function integer wf_balju_cancel (string arg_yymmdd, string arg_cvcod);long	lcnt

SELECT COUNT(*)
  INTO :lcnt
  FROM POMAST A,
  		 POBLKT B
 WHERE A.SABU 		= B.SABU
 	AND A.BALJPNO  = B.BALJPNO
	AND A.SABU		= :gs_sabu
	AND A.DOCNO	= :arg_yymmdd
	AND A.CVCOD LIKE :arg_cvcod||'%'
	AND B.SAUPJ		= :gs_saupj
	AND B.BALSTS   = '1' ;

if lcnt > 0 then
	messagebox('확인','발주 처리된 자료가 존재합니다')
	return -1
end if


string	sbaljpno

SELECT A.BALJPNO 
  INTO :sbaljpno 
  FROM POMAST A,
  		 POBLKT B
 WHERE A.SABU = :gs_sabu
   AND A.DOCNO = :arg_yymmdd
	AND A.CVCOD LIKE :arg_cvcod||'%'
	AND A.SABU = B.SABU
	AND A.BALJPNO = B.BALJPNO
	AND B.SAUPJ	  = :gs_saupj
	AND B.BALSTS = '1' 
	AND ROWNUM = 1 ;

if sqlca.sqlcode = 0 then
	UPDATE POBLKT
		SET BALSTS = '4'
	 WHERE SABU = :gs_sabu
	   AND SAUPJ= :gs_saupj
	 	AND EXISTS ( SELECT 'X' FROM POMAST
					  	  WHERE SABU = POBLKT.SABU
						    AND BALJPNO = POBLKT.BALJPNO
						    AND DOCNO = :arg_yymmdd
							 AND CVCOD LIKE :arg_cvcod||'%') ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','발주자료를 취소할 수 없습니다')
		return -1
	end if
end if

return 1
end function

on w_pu01_00021.create
int iCurrent
call super::create
this.p_1=create p_1
this.dw_7=create dw_7
this.dw_1=create dw_1
this.st_2=create st_2
this.dw_pomast=create dw_pomast
this.dw_poblkt=create dw_poblkt
this.dw_weekplan=create dw_weekplan
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_1=create rr_1
this.dw_insert2=create dw_insert2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.dw_7
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_pomast
this.Control[iCurrent+6]=this.dw_poblkt
this.Control[iCurrent+7]=this.dw_weekplan
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.dw_insert2
this.Control[iCurrent+12]=this.pb_1
end on

on w_pu01_00021.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.dw_7)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.dw_pomast)
destroy(this.dw_poblkt)
destroy(this.dw_weekplan)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_1)
destroy(this.dw_insert2)
destroy(this.pb_1)
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

type dw_insert from w_inherite`dw_insert within w_pu01_00021
integer x = 69
integer y = 280
integer width = 4494
integer height = 1908
string dataobject = "d_pu01_00021_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
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

type p_delrow from w_inherite`p_delrow within w_pu01_00021
boolean visible = false
integer x = 5280
integer y = 596
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pu01_00021
boolean visible = false
integer x = 5106
integer y = 596
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu01_00021
integer x = 3703
integer y = 28
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\마감취소_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\마감취소_UP.gif"
end event

event p_search::clicked;call super::clicked;String sYymm ,ls_confirm_t
Long   ll_cnt 

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '1'
	AND CNFTIME IS NOT NULL ;
	
If ll_cnt < 1 Then
	Return
Else
	SELECT COUNT(*) Into :ll_cnt
	  FROM PU02_MONPLAN A
	 WHERE A.SABU = :gs_saupj
		AND A.YYMM = :sYymm
		AND A.WAIGB = '1'
		AND A.WEBCNF IS NOT NULL ;
	
	if ll_cnt > 0 then
		messagebox('확인','이미 WEB 전송 처리가 완료된 자료입니다.')
		RETURN
	END IF
End If


If  MessageBox("확인", '월 구매계획을 확정취소처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

SetNull(ls_confirm_t)

UPDATE PU02_MONPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '1' ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정취소 처리되었습니다.!!')
dw_1.triggerevent(itemchanged!)
end event

type p_ins from w_inherite`p_ins within w_pu01_00021
boolean visible = false
integer x = 4933
integer y = 596
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pu01_00021
integer x = 4361
integer y = 28
end type

event p_exit::clicked;close(parent)

end event

type p_can from w_inherite`p_can within w_pu01_00021
integer x = 4183
integer y = 28
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00021
boolean visible = false
integer x = 4585
integer y = 596
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00021
integer x = 3346
integer y = 28
end type

event p_inq::clicked;call super::clicked;string	syymm, sgubun , scvcod, sitcls, sittyp
String   ls_confirm
Long     ll_cnt

dw_1.accepttext()
syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

sgubun = trim(dw_1.getitemstring(1,'gubun'))
scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If Isnull(scvcod) Then scvcod=''

sitcls = trim(dw_1.getitemstring(1,'itcls'))
If IsNull(sItcls) Then sItcls = ''

sittyp = trim(dw_1.getitemstring(1,'ittyp'))
If IsNull(sittyp) Then sittyp = ''

SELECT COUNT(*) Into :ll_cnt 
  FROM PU02_MONPLAN
  WHERE SABU = :gs_saupj
    AND YYMM = :syymm
	 AND WAIGB = '1' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then	
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'월 구매계획')
	Return
End if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syymm,sgubun, sItcls+'%', scvcod+'%', sittyp+'%') <= 0 Then
	f_message_chk(50,'월 구매계획')
End If
end event

type p_del from w_inherite`p_del within w_pu01_00021
boolean visible = false
integer x = 5627
integer y = 596
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pu01_00021
integer x = 3525
integer y = 28
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::ue_lbuttondown;//PictureName = "C:\erpman\image\마감처리_dn.gif"
end event

event p_mod::ue_lbuttonup;//PictureName = "C:\erpman\image\마감처리_UP.gif"
end event

event p_mod::clicked;call super::clicked;String sYymm ,ls_confirm_t
Long   ll_cnt ,ll_confirm 

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Or f_datechk(syymm+'01') < 0 Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '1' ;
	
If SQLCA.SQLCODE <> 0 OR ll_cnt < 1 Then
	MessageBox('확인','해당 년월의 구매계획이 존재하지 않습니다.')
	dw_1.setfocus()
	Return
End If

select Count(cnftime) into :ll_confirm 
  from pu02_monplan
 where sabu = :gs_saupj 
   and yymm = :syymm 
	and waigb = '1'
	and cnftime is not null ;
	
if ll_confirm > 0 then
	MessageBox('확인','해당 년월의 구매계획이 이미 확정되었습니다.')
	dw_1.setfocus()
	Return
end If

If  MessageBox("마감", '월 구매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

/* 박홍섭대리 요청으로 통코일 전개는 제외 - by shingoon 2009.05.20 **********************************/
/****************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////
// 통코일 소요량 전개
string	serror
serror = 'X'
Sqlca.erp000000050_7_hantec(gs_saupj, sYymm, '2', serror);				
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

UPDATE PU02_MONPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
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

type cb_exit from w_inherite`cb_exit within w_pu01_00021
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00021
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00021
end type

type cb_del from w_inherite`cb_del within w_pu01_00021
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00021
end type

type cb_print from w_inherite`cb_print within w_pu01_00021
end type

type st_1 from w_inherite`st_1 within w_pu01_00021
end type

type cb_can from w_inherite`cb_can within w_pu01_00021
end type

type cb_search from w_inherite`cb_search within w_pu01_00021
end type







type gb_button1 from w_inherite`gb_button1 within w_pu01_00021
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00021
end type

type p_1 from picture within w_pu01_00021
integer x = 3877
integer y = 28
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\WEB.gif"
boolean focusrectangle = false
end type

event clicked;string	syymm , ls_confirm_t, stemp

If dw_1.AcceptText() <> 1 Then Return
syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

SELECT CNFTIME INTO :stemp FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj 
 	AND YYMM = :syymm 
	AND WAIGB = '1' 
	AND CNFTIME IS NOT NULL
	AND ROWNUM = 1 ;

IF SQLCA.SQLCODE <> 0 THEN
	MESSAGEBOX('확인','먼저 확정 처리를 하십시오.')
	return
end if


SELECT MIN(WEBCNF) INTO :stemp FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj 
 	AND YYMM = :syymm 
	AND WAIGB = '1' 
	AND CNFTIME IS NOT NULL;

IF isnull(stemp) or stemp = '' THEN
	If  MessageBox("마감", '월 구매계획을 WEB 전송처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	ls_confirm_t = f_today() + ' ' +f_totime()
	
	UPDATE PU02_MONPLAN
		SET WEBCNF = :ls_confirm_t
	 WHERE SABU = :gs_saupj
		AND YYMM = :sYymm
		AND WAIGB = '1'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If

	if wf_balju(sYymm, '%') = -1 then
		rollback ;
		messagebox('확인','월 계획에 대한 발주처리를 실패하였습니다')
		return
	end if
	
	long		lseq
	string	subject, scontent
	
	subject = left(syymm,4) + ' 년 ' + right(syymm,2) + ' 월 구매계획 확정 통보!!!'
	scontent= '월 구매계획이 확정되었습니다.~n업무에 참고하십시오'
	
	select nvl(max(no),0) into :lseq from et_notice;
	
	lseq = lseq + 1

	insert into et_notice
	(	no,			subject,				content,				cre_id,				cre_dt,			cvcod	)
	values
	(	:lseq,		:subject,			:scontent,			:gs_userid,			sysdate,			'TOTAL'	) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Return
	End If

	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 처리되었습니다.!!')
ELSE
	/////////////////////////////////////////////////////////////
	// 발주취소가능 체크
	if wf_balju_cancel(sYymm, '%') = -1 then return
	
	If  MessageBox("마감", '월 구매계획을 WEB 전송 취소 처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	UPDATE PU02_MONPLAN
		SET WEBCNF = NULL
	 WHERE SABU = :gs_saupj
		AND YYMM = :sYymm
		AND WAIGB = '1'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 취소 처리되었습니다.!!')
end if
end event

type dw_7 from datawindow within w_pu01_00021
boolean visible = false
integer x = 4736
integer y = 888
integer width = 453
integer height = 148
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00011_4"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_insert.setredraw(false)
dw_insert2.setredraw(false)

if this.gettext() = '1' then
	st_2.visible = false
	dw_insert.visible = true
	dw_insert2.visible = false
	
else
	st_2.visible = true
	dw_insert.visible = false
	dw_insert2.visible = true
	
end if

dw_insert.setredraw(true)
dw_insert2.setredraw(true)
end event

type dw_1 from datawindow within w_pu01_00021
integer x = 101
integer y = 56
integer width = 3054
integer height = 164
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00020_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	syymm, scnfirm, sm, sm1, sm2, s_empno, s_name, get_nm
Integer	ireturn

IF this.GetColumnName() = "cvcod" THEN
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
	
/* 품목분류 지정 */
ElseIF this.GetColumnName() = "itcls" THEN
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

ElseIF this.GetColumnName() = "yymm" THEN	
	syymm = trim(this.gettext())
	
	select substr(cnftime,1,8) into :scnfirm from pu02_monplan
	 where sabu = :gs_saupj and yymm = :syymm and waigb = '1'
		and cnftime is not null and rownum = 1 ;
	
	if sqlca.sqlcode = 0 then 
		this.setitem(1,'cnfirm','Y')
	else
		this.setitem(1,'cnfirm','N')
	end if
End If
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
	 
	 this.SetItem(1,"ittyp",str_sitnct.s_ittyp)
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
End If
end event

type st_2 from statictext within w_pu01_00021
integer x = 4119
integer y = 204
integer width = 434
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

type dw_pomast from datawindow within w_pu01_00021
boolean visible = false
integer x = 2377
integer y = 216
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00030_pomast"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_poblkt from datawindow within w_pu01_00021
boolean visible = false
integer x = 3145
integer y = 224
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00030_poblkt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_weekplan from datawindow within w_pu01_00021
boolean visible = false
integer x = 3977
integer y = 220
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00021_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_pu01_00021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 40
integer width = 3141
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pu01_00021
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4731
integer y = 860
integer width = 471
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pu01_00021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 272
integer width = 4507
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert2 from datawindow within w_pu01_00021
boolean visible = false
integer x = 69
integer y = 280
integer width = 4494
integer height = 1908
integer taborder = 50
string title = "none"
string dataobject = "d_pu01_00021_2"
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

type pb_1 from u_pb_cal within w_pu01_00021
integer x = 635
integer y = 60
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 
dw_1.SetItem(1, 'yymm', left(gs_code,6))
dw_1.triggerevent(itemchanged!)

//post wf_set_magamyn()
end event

