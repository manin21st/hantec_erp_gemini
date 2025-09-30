$PBExportHeader$w_pdt_05620_new.srw
$PBExportComments$작업실적등록(임의)-작지자동생성
forward
global type w_pdt_05620_new from w_inherite
end type
type gb_3 from groupbox within w_pdt_05620_new
end type
type gb_2 from groupbox within w_pdt_05620_new
end type
type dw_detail from datawindow within w_pdt_05620_new
end type
type dw_list from u_d_select_sort within w_pdt_05620_new
end type
type rb_insert from radiobutton within w_pdt_05620_new
end type
type rb_delete from radiobutton within w_pdt_05620_new
end type
type dw_jaje from datawindow within w_pdt_05620_new
end type
type dw_list2 from u_d_select_sort within w_pdt_05620_new
end type
type pb_1 from u_pb_cal within w_pdt_05620_new
end type
type cb_1 from commandbutton within w_pdt_05620_new
end type
type cbx_1 from checkbox within w_pdt_05620_new
end type
type rr_1 from roundrectangle within w_pdt_05620_new
end type
type rr_2 from roundrectangle within w_pdt_05620_new
end type
type rr_3 from roundrectangle within w_pdt_05620_new
end type
type dw_1 from datawindow within w_pdt_05620_new
end type
end forward

global type w_pdt_05620_new from w_inherite
integer width = 5449
integer height = 5176
string title = "작업실적등록 (임시)"
event ue_insert ( )
gb_3 gb_3
gb_2 gb_2
dw_detail dw_detail
dw_list dw_list
rb_insert rb_insert
rb_delete rb_delete
dw_jaje dw_jaje
dw_list2 dw_list2
pb_1 pb_1
cb_1 cb_1
cbx_1 cbx_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_1 dw_1
end type
global w_pdt_05620_new w_pdt_05620_new

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_item_chk (string sitem)
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_duplication_chk (long crow)
public function integer wf_danmst (string sredate)
public function integer wf_insert_cinbr ()
public function integer wf_update_gubun ()
public function integer wf_inqty ()
public function integer wf_mo_create ()
public function integer wf_insert_shpact ()
public function integer wf_requiredchk (ref long lcrow, ref string scolumn)
public function integer wf_settime ()
public subroutine wf_calc_tuipqty ()
end prototypes

event ue_insert();long		lrow, ll_row, i, ll_i
string	sitnbr, spspec, slotsno
str_code lst_code

lst_code = Message.PowerObjectParm
IF isValid(lst_code) = False Then Return 
If UpperBound(lst_code.code) < 1 Then Return 


lrow = dw_list.RowCount() + 1

For i = lrow To UpperBound(lst_code.code) + lrow - 1
	ll_i++
	
	sitnbr = lst_code.code[ll_i]
	slotsno= lst_code.sgubun2[ll_i]
	spspec = lst_code.sgubun1[ll_i]
		
//	if dw_list.find("itnbr='"+sitnbr+"' and pspec='"+spspec+"' and lotsno='"+slotsno+"'",1,dw_list.rowcount()) > 0 then continue

	ll_row = dw_list.InsertRow(0)
	
	dw_list.object.itnbr[ll_row] = sitnbr
	dw_list.object.itemas_itdsc[ll_row] = lst_code.codename[ll_i]
	dw_list.object.pspec[ll_row] = spspec
	dw_list.object.lotsno[ll_row] = slotsno
	dw_list.object.ioqty[ll_row] = lst_code.dgubun1[ll_i]

Next

dw_list.ScrollToRow(lRow)
//dw_list.SetColumn("itnbr")
//dw_list.SetFocus()

end event

public function integer wf_item_chk (string sitem);long  get_count

SELECT COUNT(*)  
  INTO :get_count
  FROM "ITEMAS"  
 WHERE "ITEMAS"."STDNBR" = :sitem  ;

if get_count > 0 then 
	messagebox("확 인", "표준품번으로 등록된 자료는 사용정지/단종 시킬 수 없습니다.")
	return -1
end if	

return 1
end function

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

if isnull(dw_list.GetItemString(i,'itnbr')) or Trim(dw_list.GetItemString(i,'itnbr')) = '' then
	f_message_chk(1400,'[품번]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('itnbr')
	dw_list.SetFocus()
	return -1
end if	

//if isnull(dw_list.GetItemString(i,'grade')) or Trim(dw_list.GetItemString(i,'grade')) = '' then
//	f_message_chk(1400,'[등급]')
//	dw_list.ScrollToRow(i)
//	dw_list.SetColumn('grade')
//	dw_list.SetFocus()
//	return -1
//end if	

return 1
end function

public subroutine wf_reset ();//dw_detail.RESET()
//dw_detail.insertrow(0)
//dw_detail.setitem(1,'edate',f_today())
//dw_detail.setitem(1,'fdate',f_today())
//dw_detail.setitem(1,'tdate',f_today())
//dw_detail.setitem(1,'saupj',gs_saupj)

dw_list.reset()
dw_list.insertrow(0)
//dw_list.setitem(1,'lots',f_today())
//dw_list.setitem(1,'sdate',f_today())
//dw_list.setitem(1,'edate',f_today())
String ls_date
ls_date = dw_detail.GetItemString(1, 'fdate')
dw_list.setitem(1,'lots',ls_date)
dw_list.setitem(1,'sdate',ls_date)
dw_list.setitem(1,'edate',ls_date)

dw_list.setitem(1,'empno',gs_empno)
dw_list.setitem(1,'empname',f_get_name5('02',gs_empno,''))

//dw_list2.reset()

dw_detail.SetFocus()

ib_any_typing = FALSE
end subroutine

public function integer wf_duplication_chk (long crow);String s1, snew
long   ll_frow, ll_cnt

dw_list.AcceptText()

s1 = dw_list.object.itnbr[crow]
snew = dw_list.object.create_flag[crow]

if snew = 'Y' then
	select count(*) into :ll_cnt from keyitem_kum where itnbr = :s1 ;
	if ll_cnt > 0 then
		messagebox('확인','이미 등록된 품번입니다!!!')
		dw_list.ScrollToRow(crow)
		dw_list.SetColumn('itnbr')
		dw_list.SetFocus()
		return -1
	end if
end if

ll_frow = dw_list.Find("itnbr = '" + s1 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[품번")
	dw_list.ScrollToRow(ll_frow)
	dw_list.SetColumn('itnbr')
	dw_list.SetFocus()
	return -1
end if

ll_frow = dw_list.Find("itnbr = '" + s1 + "'", crow + 1, dw_list.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[품번")
	dw_list.ScrollToRow(ll_frow)
	dw_list.SetColumn('itnbr')
	dw_list.SetFocus()
	return -1
end if

return 1
end function

public function integer wf_danmst (string sredate);string	sItem, 		&
			sCust,		&
			sCustName,	&
			sIndate,		&
			sCustom,		&	
			sNull
int		iCount

SetPointer(HourGlass!)
/* 단가마스터에 검사담당자가 없는 경우 환경설정에 있는 기본 검사담당자를 이용한다 */
Setnull(sNull)
select dataname
  into :scustom
  from syscnfg
 where sysgu = 'Y' and serial = '13' and lineno = '1';

if sqlca.sqlcode <> 0 then
//	f_message_chk(207,'[검사담당자]')
end if

SELECT 	to_char(SYSDATE, 'hh24')
  INTO	:sIndate
  FROM 	DUAL;

IF sIndate < '12'	THEN
	iCount = 1
ELSE
	iCount = 2
END IF

string	sEmpno, sGubun, sStock, sOpseq
sItem  = dw_list.GetItemString(1, "itnbr")
sCust  = dw_list.GetItemString(1, "cvcod")
sStock = dw_list.GetItemString(1, "itemas_filsk")
sOpseq = dw_list.GetItemString(1, "opseq")

SELECT "DANMST"."QCEMP",   
		"DANMST"."QCGUB"  
 INTO :sEmpno,   
		:sGubun  
 FROM "DANMST"  
WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
		( "DANMST"."CVCOD" = :sCust ) AND ("DANMST"."OPSEQ" = :sOpseq )  ;
		
IF SQLCA.SQLCODE <> 0	THEN
	SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
	  INTO :sgubun,  :sempno    
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sitem ;
	
	if sgubun = '' or isnull(sgubun) then 
//			dw_list.SetItem(1, "qcgubun", '4')		// 까다로운 검사
		dw_list.SetItem(1, "qcgubun", '1')		// 무검사-KUM
	else
		dw_list.SetItem(1, "qcgubun", sgubun)		// 까다로운 검사
	end if
	if sgubun = '1' then //무검사인 경우
		dw_list.SetItem(1, "empno", sNull) 
	else
		if sempno = '' or isnull(sempno) then 
			dw_list.SetItem(1, "empno", scustom) // 기본검사 담당자		
		else
			dw_list.SetItem(1, "empno", sempno)	
		end if
	end if		
ELSE
//		IF Isnull(sGubun)		THEN	sGubun = '4'
	IF Isnull(sGubun)		THEN	sGubun = '1'		// 무검사-KUM
	dw_list.SetItem(1, "qcgubun", sGubun)
	
	If sGubun = '1' then
		dw_list.SetItem(1, "empno", 	sNull)		
	Else
		If Isnull(sEmpno) or Trim(sEmpno) = '' then
			dw_list.SetItem(1, "empno", 	sCustom)
		else
			dw_list.SetItem(1, "empno", 	sEmpno)				
		end if
	End if
END IF

// 재고관리 하지 않을 경우 : 무검사, 검사담당자 없음
if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then
	sStock = 'Y'
end if
dw_list.setitem(1, "itemas_filsk", sStock)
IF sStock = 'N'	THEN	
	dw_list.SetItem(1, "qcgubun", '1')
	dw_list.Setitem(1, "empno", snull)
End if
	
// 검사요구일자는 무검사 이면 null 
IF sStock = 'N' or sgubun = '1'	THEN	
	dw_list.SetItem(1, "qcdate", sNull)
ELSE
	dw_list.SetItem(1, "qcdate", sRedate)
END IF

//dw_list.setitem(1, "qcsugbn", is_qccheck)		// 검사구분 수정여부


RETURN 1
end function

public function integer wf_insert_cinbr ();long		ii, ll_cnt, ll_rnt, ll_row
string	ls_pordno,	ls_jidat, ls_itnbr, ls_itdsc, ls_null
string	ls_opseq,	ls_opdsc, ls_qcgub, ls_roslt
decimal	ld_qtypr, ld_unprc

dw_list.accepttext()

 DECLARE CBOM CURSOR FOR  
  SELECT A.CINBR, B.ITDSC, NVL(A.QTYPR,0)
    FROM PSTRUC A, ITEMAS B
	WHERE A.PINBR = :ls_itnbr
	  AND A.BOMEND = 'Y'
	  AND A.GUBUN = '1'
	  AND A.EFRDT <= TO_CHAR(SYSDATE,'YYYYMMDD')
	  AND A.EFTDT >= TO_CHAR(SYSDATE,'YYYYMMDD')
	  AND A.OPSNO IN ('9999',:ls_opseq)
	  AND A.CINBR = B.ITNBR(+) ;


setnull(ls_null)
ls_itnbr = dw_list.getitemstring(1,'morout_itnbr')
ls_opseq = dw_list.getitemstring(1,'morout_opseq')

w_mdi_frame.sle_msg.text = "작업지시공정상세 생성중..."

dw_jaje.reset()

OPEN CBOM;
DO WHILE TRUE
	FETCH CBOM INTO :ls_itnbr, :ls_itdsc, :ld_qtypr ;
	if sqlca.sqlcode <> 0 then EXIT
	

	ll_row = dw_jaje.insertrow(0)
	
	dw_jaje.object.chk[ll_row] = 'Y'
	dw_jaje.object.sabu[ll_row] = gs_sabu
	dw_jaje.object.itnbr[ll_row] = ls_itnbr
	dw_jaje.object.itdsc[ll_row] = ls_itdsc
	dw_jaje.object.pspec[ll_row] = '.'
	dw_jaje.object.lotsno[ll_row] = f_today()
	dw_jaje.object.qtypr[ll_row] = ld_qtypr
	
LOOP
CLOSE CBOM;

w_mdi_frame.sle_msg.text = "작업지시 생성 완료!!!"

RETURN 1

end function

public function integer wf_update_gubun ();//long		lRow, lCount
//string	sQcgubun, sQcdate, sIoConfirm, sIoDate, sMagub, sBlno
//
//string   sittyp, sitcls, scvcod, sitnbr, sPspec
//
//SetPointer(HourGlass!)
//
//lCount = dw_list.RowCount()
//
//if String(dw_detail.object.jagbn[1]) <> 'Y' then
//	
//	FOR  lRow = 1	TO	lCount
//		// 검사구분, 검사일자입력시 수정불가
//		sQcgubun = dw_list.GetItemString(lRow, "imhist_qcgub")
//		sQcdate  = dw_list.GetItemString(lRow, "imhist_insdat")
//		
//		dw_list.SetItem(lRow, "updategubun", 'Y')
//
//	   if sMagub = 'Y' then 
//			dw_list.SetItem(lRow, "blmagub", 'Y')
//	   end if
//		
//		IF sQcgubun > '1'	THEN
//			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
//		END IF
//		
//		// 수불승인여부, 수불일자입력시 수정불가
//		sIoConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
//		sIoDate    = dw_list.GetItemString(lRow, "imhist_io_date")
//		
//		IF sIoConfirm = 'N'	THEN
//			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
//		END IF
//		
//		// 외주인 경우 생산입고CHECK
//		IF dw_list.getitemstring(LRow, "shpgu") = 'N' then
//			dw_list.SetItem(lRow, "updategubun", 'N')			
//		end if
//	
////		dw_list.setitem(lRow, "qcsugbn", is_qccheck)		// 검사구분 수정여부
//	NEXT
//ELSE
//	FOR  lRow = 1	TO	lCount
//		// 변환계수를 변환('*'인 경우 '/'로, '/'인 경우 '*'로 (단 * and 1이면 동일))
//		if is_gubun = 'Y' then
//			if dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' and &
//				dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 1   then
//				dw_list.setitem(Lrow, "poblkt_cnvart", '*')				
//			elseif dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' then
//				dw_list.setitem(Lrow, "poblkt_cnvart", '/')
//			else
//				dw_list.setitem(Lrow, "poblkt_cnvart", '*')
//			end if	
//		else
//				dw_list.setitem(Lrow, "poblkt_cnvart", '*')			
//		end if
//		
//		If dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' OR &
//			dw_list.getitemstring(Lrow, "poblkt_cnvart") = '/' THEN
//		ELSE
//			dw_list.setitem(Lrow, "poblkt_cnvart", '*')
//		END IF
//		
//		IF dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 0  OR &
//			ISNULL(dw_list.getitemdecimal(Lrow, "poblkt_cnvfat"))  THEN
//			dw_list.setitem(Lrow, "poblkt_cnvfat", 1)			
//		End if
//	NEXT
//END IF

RETURN 1


end function

public function integer wf_inqty ();long		lrow1, lrow2
string	sitnbr1, sitnbr2
decimal	dqty1=10000000, dqty2

setpointer(hourglass!)
dw_jaje.accepttext()

for lrow1 = 1 to dw_jaje.rowcount()
	sitnbr1 = dw_jaje.getitemstring(lrow1,'itnbr')
	
	dqty2 = 0
	for lrow2 = 1 to dw_jaje.rowcount()
		sitnbr2 = dw_jaje.getitemstring(lrow2,'itnbr')
		if sitnbr1 = sitnbr2 then
			dqty2 = dqty2 + dw_jaje.getitemnumber(lrow2,'tuipqty')
		end if		
	next
	
	if dqty1 > dqty2 then dqty1 = dqty2
next

dw_list.setitem(1,'inqty',dqty1)

return 1
end function

public function integer wf_mo_create ();long		ii, nn, ll_cnt, ll_rnt
string	ls_pordno,	ls_jidat, ls_itnbr, ls_pspec, ls_today, ls_totime, ls_depot, ls_masterno, ls_null, ls_defdepot
string	ls_opseq, ls_deseq, ls_prseq, ls_wkctr, ls_jocod, ls_purgc, ls_lastc, ls_wcvcod, ls_saupj
string	ls_opdsc, ls_qcgub, ls_roslt, ls_pdtgu
decimal	ld_qty, ld_unprc, ld_stdst, ld_manhr, ld_mchr


 DECLARE CROUT CURSOR FOR  
  SELECT A.OPSEQ, A.OPDSC, A.ROSLT, A.PURGC, A.LASTC, A.QCGUB, A.WKCTR, B.JOCOD, A.STDST, A.MANHR, A.MCHR
    FROM ROUTNG A, WRKCTR B
	WHERE A.ITNBR = :ls_itnbr
	  AND A.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR AND UPTGU = 'Y' )
	  AND A.WKCTR = B.WKCTR(+)
  ORDER BY A.OPSEQ ;

setnull(ls_null)
ls_jidat = dw_detail.getitemstring(1, 'fdate')
ls_itnbr = dw_list.getitemstring(1,'morout_itnbr')
ls_pspec = dw_list.getitemstring(1,'morout_pspec')
ls_saupj = dw_detail.getitemstring(1,'saupj')
ld_qty   = dw_list.getitemdecimal(1, "waqty") + dw_list.getitemdecimal(1, "buqty")
ld_unprc = 0
ls_today = f_today()
ls_totime = f_totime()
ls_pdtgu = '1'


/////////////////////////////////////////////////////////////////////////////////////////////////
// 0.작업지시번호 생성
// 화면상에 보이는 작업지시번호 채번
ii = sqlca.fun_junpyo(gs_sabu, ls_jidat, 'N0')
if ii < 1 then
	f_message_chk(51,'[작업지시번호]') 
	rollback;
	return -1
end if

// 작업지시 기준번호 채번(모든 계산단위는 작업지시 기준번호를 기준으로 한다)
nn = sqlca.fun_junpyo(gs_sabu, ls_jidat, 'N3')
if nn < 1 then
	f_message_chk(51,'[작업지시 기준번호]') 
	rollback;
	return -1
end if

Commit;

ls_pordno = ls_jidat + String(ii, '0000') + '0010'
ls_masterno = ls_jidat + String(nn, '0000')



/////////////////////////////////////////////////////////////////////////////////////////////////
// 1.작업지시마스타 생성
w_mdi_frame.sle_msg.text = "작업지시마스타 COPY 생성중..."

/* 기본창고(생산창고)  */
Select Min(cvcod) Into :ls_defdepot from Vndmst where cvgu = '5' and jumaechul = '1' and ipjogun = :ls_saupj;

/* 품목마스터-KUM의 생산입고창고를 기준으로 작성 */
ls_depot = ls_defdepot


INSERT INTO MOMAST_COPY  
( SABU,              PORDNO,              JIDAT,              ITNBR,              PSPEC,              PORGU,   
  PDTGU,             ESDAT,               EEDAT,              FSDAT,              FEDAT,              PDQTY,   
  ROQTY,             PEQTY,               WTQTY,              WAQTY,              PAQTY,              PDSTS,   
  PURGC,             CVCOD,               UNPRC,              ASSIQT,             PA_PORDNO,          PA_OSPEQ,   
  ST_OPSEQ,          SYSTEM_END_DATE,     BAJPNO,             CRT_DATE,           CRT_TIME,           CRT_USER,   
  UPD_DATE,          UPD_TIME,            UPD_USER,           IPCHANGO,           STDITNBR,    
  REQNO,             REQATE,              PDPRC,              HOLDCT,             ROUTCT,             TIMECT,   
  MOGUBN,            MATCHK,              SYSTEM_STR_DATE,    PARENT_PORDNO,      ORDER_NO,   
  ASSEQ,             MASTER_NO,           MASTER_PARENT,      KUMNO,              UNTNO,              KESTNO,   
  MOCNT,               MCHNO )  
VALUES 
( :gs_sabu,				:ls_pordno,				:ls_jidat,			  :ls_itnbr,			 :ls_pspec,				'10',
  :ls_pdtgu,			:ls_jidat,				:ls_jidat,			  :ls_jidat,			 :ls_jidat,				:ld_qty,
  0,						0,							0,						  0,						 0,						'1',
  'N',					NULL,						:ld_unprc,			  0,						 NULL,					NULL,
  NULL,					:ls_jidat,				NULL,					  :ls_today,			 :ls_totime,			:gs_userid,
  NULL,					NULL,						NULL,					  :ls_depot,			 :ls_itnbr,	
  NULL,					NULL,						0,						  'Y',					 'Y',						'Y',
  '1',					'2',						:ls_jidat,			  :ls_jidat,			 NULL,
  NULL,					:ls_masterno,			NULL,			  		  NULL,					 NULL,					NULL,
  0,						NULL )  ;


IF SQLCA.SQLCODE <> 0	THEN
	w_mdi_frame.sle_msg.text = "작업지시마스타 COPY 생성중 오류발생!!!"
	messagebox('확인', sqlca.sqlerrtext)	
	ROLLBACK;
	f_Rollback()
	RETURN -1
END IF



/////////////////////////////////////////////////////////////////////////////////////////////////
// 2.작업지시공정상세
select count(*) into :ll_rnt from routng where itnbr = :ls_itnbr and uptgu = 'Y' ;

w_mdi_frame.sle_msg.text = "작업지시공정상세 COPY 생성중..."

ll_cnt = 0
OPEN CROUT;
DO WHILE TRUE
	FETCH CROUT INTO :ls_opseq, :ls_opdsc, :ls_roslt, :ls_purgc, :ls_lastc, :ls_qcgub, :ls_wkctr, :ls_jocod,
							:ld_stdst, :ld_manhr, :ld_mchr ;
	if sqlca.sqlcode <> 0 then EXIT
	

	select opseq into :ls_deseq from routng 
	 where itnbr = :ls_itnbr and uptgu = 'Y' and opseq > :ls_opseq and rownum = 1 ;
	
	ll_cnt++
	if ll_rnt = 1 then
		ls_lastc = '9'
		ls_deseq = ls_null
		ls_prseq = '0000'
	elseif ll_cnt = 1 then
		ls_lastc = '1'
		ls_prseq = '0000'
	elseif ll_cnt = ll_rnt then
		ls_lastc = '3'
		ls_deseq = ls_null
	else
		ls_lastc = '0'
	end if
		
	
	INSERT INTO MOROUT_COPY  
	( SABU,              PORDNO,              ITNBR,              PSPEC,              OPSEQ,              DE_OPSEQ,   
	  MCHCOD,            WKCTR,               JOCOD,              PURGC,              UPTGU,              ESDAT,   
	  EEDAT,             ESTIM,               ESINW,              RSTIM,              TSINW,              NTIME,   
	  LASTC,             FSDAT,               FEDAT,              ROQTY,              FAQTY,              SUQTY,   
	  PEQTY,             COQTY,               PAQTY,              NEDAT,              LADAT,              WICVCOD,   
	  WIUNPRC,           PR_OPSEQ,            DO_OPSEQ,           SYSTEM_END_DATE,    BAJPNO,             RMKS,   
	  WATIMS,            STTIM,               ESSET,              ESMAN,              ESMCH,              ESGBN,   
	  RSSET,             RSMAN,               RSMCH,              QCGUB,              OPDSC,              ROSLT,   
	  SYSTEM_STR_DATE,   QCGIN,               STDMN,              MASTER_NO )  
	VALUES
	( :gs_sabu,				:ls_pordno,				:ls_itnbr,			  :ls_pspec,			 :ls_opseq,				:ls_deseq,
	  NULL,					:ls_wkctr,				:ls_jocod,			  :ls_purgc,			 'Y',						:ls_jidat,
	  :ls_jidat,			0,							0,						  0,						 0,						0,
	  :ls_lastc,			:ls_jidat,				:ls_jidat,			  0,						 0,						0,
	  0,						0,							0,						  NULL,					 NULL,					:ls_wcvcod,
	  0,						:ls_prseq,				NULL,					  :ls_jidat,			 NULL,					NULL,
	  0,						0,							0,						  0,						 0,						'3',
	  :ld_stdst,			:ld_manhr,				:ld_mchr,			  :ls_qcgub,			 :ls_opdsc,				:ls_roslt,
	  :ls_jidat,			NULL,						1,						  :ls_masterno )  ;
	  
	IF SQLCA.SQLCODE <> 0	THEN
		w_mdi_frame.sle_msg.text = "작업지시공정상세 COPY 생성중 오류발생!!!"
		messagebox('확인', sqlca.sqlerrtext)	
		ROLLBACK;
		f_Rollback()
		RETURN -1
	END IF
	
	ls_prseq = ls_opseq
LOOP
CLOSE CROUT;


// 작업실적 작성정보 기록
dw_list.setitem(1,'morout_pordno',ls_pordno)
dw_list.setitem(1,'morout_qcgub',ls_qcgub)
dw_list.setitem(1,'momast_pdtgu',ls_pdtgu)
dw_list.setitem(1,'morout_jocod',ls_jocod)
dw_list.setitem(1,'gubun',ls_depot)
dw_list.setitem(1,'lastc',ls_lastc)
dw_list.setitem(1,'rlastc','X')


//////////////////////////////////////////////////////////////////////////////////////////////////////
// 작업지시정보 이관 ( MOMAST_COPY->MOMAST, MOROUT_COPY->MOROUT )
w_mdi_frame.sle_msg.text = "작업지시마스타 생성중..."
INSERT INTO MOMAST  
( SABU,              PORDNO,              JIDAT,              ITNBR,              PSPEC,              PORGU,   
  PDTGU,             ESDAT,               EEDAT,              FSDAT,              FEDAT,              PDQTY,   
  ROQTY,             PEQTY,               WTQTY,              WAQTY,              PAQTY,              PDSTS,   
  PURGC,             CVCOD,               UNPRC,              ASSIQT,             PA_PORDNO,          PA_OSPEQ,   
  ST_OPSEQ,          SYSTEM_END_DATE,     BAJPNO,             CRT_DATE,           CRT_TIME,           CRT_USER,   
  UPD_DATE,          UPD_TIME,            UPD_USER,           IPCHANGO,           STDITNBR,    
  REQNO,             REQATE,              PDPRC,              HOLDCT,             ROUTCT,             TIMECT,   
  MOGUBN,            MATCHK,              SYSTEM_STR_DATE,    PARENT_PORDNO,      ORDER_NO,   
  ASSEQ,             MASTER_NO,           MASTER_PARENT,      KUMNO,              UNTNO,              KESTNO,   
  MOCNT,               MCHNO )  
SELECT
  SABU,              PORDNO,              JIDAT,              ITNBR,              PSPEC,              PORGU,   
  PDTGU,             ESDAT,               EEDAT,              FSDAT,              FEDAT,              PDQTY,   
  ROQTY,             PEQTY,               WTQTY,              WAQTY,              PAQTY,              PDSTS,   
  PURGC,             CVCOD,               UNPRC,              ASSIQT,             PA_PORDNO,          PA_OSPEQ,   
  ST_OPSEQ,          SYSTEM_END_DATE,     BAJPNO,             CRT_DATE,           CRT_TIME,           CRT_USER,   
  UPD_DATE,          UPD_TIME,            UPD_USER,           IPCHANGO,           STDITNBR,    
  REQNO,             REQATE,              PDPRC,              HOLDCT,             ROUTCT,             TIMECT,   
  MOGUBN,            MATCHK,              SYSTEM_STR_DATE,    PARENT_PORDNO,      ORDER_NO,   
  ASSEQ,             MASTER_NO,           MASTER_PARENT,      KUMNO,              UNTNO,              KESTNO,   
  MOCNT,               MCHNO
FROM MOMAST_COPY
WHERE SABU = :gs_sabu AND PORDNO = :ls_pordno ;
IF SQLCA.SQLCODE <> 0	THEN
	w_mdi_frame.sle_msg.text = "작업지시마스타 생성중 오류발생!!!"
	messagebox('확인', sqlca.sqlerrtext)	
	ROLLBACK;
	f_Rollback()
	RETURN -1
END IF

w_mdi_frame.sle_msg.text = "작업지시공정상세 생성중..."
INSERT INTO MOROUT  
( SABU,              PORDNO,              ITNBR,              PSPEC,              OPSEQ,              DE_OPSEQ,   
  MCHCOD,            WKCTR,               JOCOD,              PURGC,              UPTGU,              ESDAT,   
  EEDAT,             ESTIM,               ESINW,              RSTIM,              TSINW,              NTIME,   
  LASTC,             FSDAT,               FEDAT,              ROQTY,              FAQTY,              SUQTY,   
  PEQTY,             COQTY,               PAQTY,              NEDAT,              LADAT,              WICVCOD,   
  WIUNPRC,           PR_OPSEQ,            DO_OPSEQ,           SYSTEM_END_DATE,    BAJPNO,             RMKS,   
  WATIMS,            STTIM,               ESSET,              ESMAN,              ESMCH,              ESGBN,   
  RSSET,             RSMAN,               RSMCH,              QCGUB,              OPDSC,              ROSLT,   
  SYSTEM_STR_DATE,   QCGIN,               STDMN,              MASTER_NO )  
SELECT
  SABU,              PORDNO,              ITNBR,              PSPEC,              OPSEQ,              DE_OPSEQ,   
  MCHCOD,            WKCTR,               JOCOD,              PURGC,              UPTGU,              ESDAT,   
  EEDAT,             ESTIM,               ESINW,              RSTIM,              TSINW,              NTIME,   
  LASTC,             FSDAT,               FEDAT,              ROQTY,              FAQTY,              SUQTY,   
  PEQTY,             COQTY,               PAQTY,              NEDAT,              LADAT,              WICVCOD,   
  WIUNPRC,           PR_OPSEQ,            DO_OPSEQ,           SYSTEM_END_DATE,    BAJPNO,             RMKS,   
  WATIMS,            STTIM,               ESSET,              ESMAN,              ESMCH,              ESGBN,   
  RSSET,             RSMAN,               RSMCH,              QCGUB,              OPDSC,              ROSLT,   
  SYSTEM_STR_DATE,   QCGIN,               STDMN,              MASTER_NO
FROM MOROUT_COPY
WHERE SABU = :gs_sabu AND PORDNO = :ls_pordno ;
IF SQLCA.SQLCODE <> 0	THEN
	w_mdi_frame.sle_msg.text = "작업지시공정상세 생성중 오류발생!!!"
	messagebox('확인', sqlca.sqlerrtext)	
	ROLLBACK;
	f_Rollback()
	RETURN -1
END IF

//////////////////////////////////////////////////////////////////////////////////////////////////////


w_mdi_frame.sle_msg.text = "작업지시 생성 완료!!!"

RETURN 1

end function

public function integer wf_insert_shpact ();Long 	  lrow, lcnt, lirow, ljpno, lseq, lipjpno
String  sreff, sreff1, sitdsc, sispec, sitnbr, scolumn, scdate, serror, sjpno
integer ireturn

w_mdi_frame.sle_msg.text = "자료를 저장하고 있읍니다."

lrow = 1
dw_insert.reset()

scdate = dw_detail.getitemstring(1, 'fdate')

w_mdi_frame.sle_msg.text = "실적번호를 채번 중............."
ljpno = sqlca.fun_junpyo(gs_sabu, scdate, 'N1')
if ljpno = 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(51,'[생산실적 전표번호]')	
	rollback;
	return -1
else
	commit;
End if
//isjpno = scdate + string(ljpno, '0000')

w_mdi_frame.sle_msg.text = "실적자료를 SETTING 중............."
For lcnt = 1 to lrow
		
		lirow = dw_insert.insertrow(0)
		lseq++

		dw_insert.setitem(lirow, "sabu", gs_sabu)
		dw_insert.setitem(lirow, "shpjpno", scdate+string(ljpno, '0000')+string(lseq, '000'))
		dw_insert.setitem(lcnt, "shpjpno", scdate+string(ljpno, '0000')+string(lseq, '000'))
		
		dw_insert.setitem(lirow, "itnbr", dw_list.getitemstring(1, "morout_itnbr"))
		if isnull(dw_list.getitemstring(1, "morout_pspec")) or &
		   trim(dw_list.getitemstring(1, "morout_pspec")) = '' then
			dw_insert.setitem(lirow, "pspec", '.')
		else
			dw_insert.setitem(lirow, "pspec", dw_list.getitemstring(1, "morout_pspec"))
		end if
		dw_insert.setitem(lirow, "wkctr", dw_list.getitemstring(1, "morout_wkctr"))
		dw_insert.setitem(lirow, "pdtgu", dw_list.getitemstring(1, "momast_pdtgu"))
		dw_insert.setitem(lirow, "mchcod", dw_list.getitemstring(1, "morout_mchcod"))
		dw_insert.setitem(lirow, "kumno", dw_list.getitemstring(1, "kumno"))
		dw_insert.setitem(lirow, "jocod", dw_list.getitemstring(1, "morout_jocod"))
		dw_insert.setitem(lirow, "opemp",  dw_list.getitemstring(1, "empno"))
		dw_insert.setitem(lirow, "sidat", dw_list.getitemstring(1, "edate"))
		dw_insert.setitem(lirow, "inwon", dw_list.getitemdecimal(1, "toiwn"))
		dw_insert.setitem(lirow, "totim", dw_list.getitemdecimal(1, "sotim"))
		dw_insert.setitem(lirow, "stime", dw_list.getitemstring(1, "stime"))
		dw_insert.setitem(lirow, "etime", dw_list.getitemstring(1, "etime"))
		dw_insert.setitem(lirow, "pordno", dw_list.getitemstring(1, "morout_pordno"))
		dw_insert.setitem(lirow, "sigbn", '1')
		dw_insert.setitem(lirow, "purgc", 'N')
		dw_insert.setitem(lirow, "roqty", dw_list.getitemdecimal(1, "waqty") + &
													 dw_list.getitemdecimal(1, "buqty") + &
													 dw_list.getitemdecimal(1, "ppqty"))
//		if dw_detail.getitemstring(1, "sigbn") = '2' then
//			dw_insert.setitem(lirow, "suqty", dw_list.getitemdecimal(1, "waqty"))
//		end if
		dw_insert.setitem(lirow, "faqty", dw_list.getitemdecimal(1, "buqty"))
		dw_insert.setitem(lirow, "peqty", dw_list.getitemdecimal(1, "ppqty"))
		dw_insert.setitem(lirow, "coqty", dw_list.getitemdecimal(1, "waqty"))
		if dw_list.getitemdecimal(1, "waqty") >= dw_list.getitemdecimal(1, "janqty") then
			dw_insert.setitem(lirow, "ji_gu", 'Y')
		else
			dw_insert.setitem(lirow, "ji_gu", 'N')
		end if

 		dw_insert.setitem(lirow, "insgu",  dw_list.getitemstring(1, "morout_qcgub"))
		dw_insert.setitem(lirow, "lotsno", dw_list.getitemstring(1, "lots"))
		dw_insert.setitem(lirow, "ipgub",  dw_list.getitemstring(1, "gubun"))
		dw_insert.setitem(lirow, "opsno",  dw_list.getitemstring(1, "morout_opseq"))
		dw_insert.setitem(lirow, "lastc",  dw_list.getitemstring(1, "lastc"))
		dw_insert.setitem(lirow, "de_lastc",  dw_list.getitemstring(1, "rlastc"))
		/* 최종공정인 경우에만 입고번호를 삽입 */
		if dw_list.getitemstring(1, "lastc") = '3' or &
			dw_list.getitemstring(1, "lastc") = '9' then
			lipjpno = sqlca.fun_junpyo(gs_sabu, scdate, 'C0')
			if lipjpno = 0 then
				w_mdi_frame.sle_msg.text = ''
				f_message_chk(51,'[입고예정번호]')	
				rollback;
				return -1
			else
				commit;
			End if			
			dw_insert.setitem(lirow, "ipjpno", scdate+string(lipjpno, '0000')+'001')
		end if
		
		// 시작일자 및 시간내역을 저장
		dw_insert.setitem(lirow, "stdat",  dw_list.getitemstring(1, "sdate"))
		dw_insert.setitem(lirow, "rsset",  dw_list.getitemdecimal(1, "toset"))
		dw_insert.setitem(lirow, "rsman",  dw_list.getitemdecimal(1, "toman"))
		dw_insert.setitem(lirow, "rsmch",  dw_list.getitemdecimal(1, "tomch"))
		dw_insert.setitem(lirow, "silgbn", '1')
	 
Next


/////////////////////////////////////////////////////////////////////////////
// 반제품 투입내역-2006.08.05-송병호
FOR lrow = 1 TO dw_jaje.rowcount()
	dw_jaje.setitem(lrow,'shpjpno',dw_insert.getitemstring(1,'shpjpno'))
NEXT

IF dw_jaje.Update() <> 1	THEN
	ROLLBACK;
	f_Rollback()
	RETURN -1
END IF
/////////////////////////////////////////////////////////////////////////////


w_mdi_frame.sle_msg.text = "실적자료를 저장 中............."
if dw_insert.update() = -1 then
	f_message_chk(-20262,'[자료저장]') 
	w_mdi_frame.sle_msg.text = ''
//	rollback;
	return -1
end if


w_mdi_frame.sle_msg.text = ""
return 1
end function

public function integer wf_requiredchk (ref long lcrow, ref string scolumn);Long 	  lrow, lcnt
String  sreff, sreff1, sitdsc, sispec, sitnbr, sWanlot, sBanlot, sIttyp
integer ireturn
time		tchk
decimal	ll_inqty

w_mdi_frame.sle_msg.text = "자료를 check하고 있습니다."

dw_list.accepttext()
lrow = dw_list.rowcount()


// 완제품에 대한 입고LOT 필수check 여부
select dataname
  into :swanlot
  from syscnfg
 where sysgu = 'Y' and serial = 25 and lineno = '3';
 
if sqlca.sqlcode <> 0 or isnull(swanlot) or trim(sWanlot) = '' then
	sWanlot = 'Y'
end if

// 반제품에 대한 입고LOT 필수check 여부
select dataname
  into :sBanlot
  from syscnfg
 where sysgu = 'Y' and serial = '25' and lineno = '2';
 
if sqlca.sqlcode <> 0 or isnull(sBanlot) or trim(sBanlot) = '' then
	sBanlot = 'Y'
end if

lcnt = 1

// 작업 시작 일자 check
if f_datechk(dw_list.getitemstring(lcnt, "sdate")) = -1 then
	f_message_chk(35, "시작일자")
	scolumn = "sdate"
	return -1
end if
	
// 작업 시작 시간 check
sreff = dw_list.getitemstring(lcnt, "stime")
if isnull(sreff)  or trim(sreff) = '' then
	f_message_chk(1400,'[작업시작시간]') 
	scolumn = "stime"
	RETURN  -1
end if
if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
	f_message_chk(1400,'[작업시작시간]') 
	dw_list.setitem(lcnt, "toset", 0)
	dw_list.setitem(lcnt, "toman", 0)
	dw_list.setitem(lcnt, "tomch", 0)
	dw_list.setitem(lcnt, "sotim", 0)
	dw_list.setitem(lcnt, "stime", '')
	scolumn = "stime"
	RETURN  -1	
end if

// 작업 종료 일자 check
if f_datechk(dw_list.getitemstring(lcnt, "edate")) = -1 then
	f_message_chk(35, "종료일자")
	scolumn = "edate"
	return -1	
end if

// 작업 종료 시간
sreff = dw_list.getitemstring(lcnt, "etime")
if isnull(sreff)  or trim(sreff) = '' then
	f_message_chk(1400,'[작업시작시간]') 
	scolumn = "etime"
	RETURN  -1
end if
if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
	f_message_chk(1400,'[작업시작시간]') 
	dw_list.setitem(lcnt, "toset", 0)
	dw_list.setitem(lcnt, "toman", 0)
	dw_list.setitem(lcnt, "tomch", 0)
	dw_list.setitem(lcnt, "sotim", 0)
	dw_list.setitem(lcnt, "etime", '')
	scolumn = "etime"
	RETURN  -1	
end if
		
if isnull(dw_list.getitemdecimal(lcnt, "toiwn"))  or &
	dw_list.getitemdecimal(lcnt, "toiwn") < 1  then
	scolumn = "toiwn"
	f_message_chk(1400,'[투입인원]') 
	RETURN  -1
end if

//if isnull(dw_list.getitemdecimal(lcnt, "sotim"))  or &
//	dw_list.getitemdecimal(lcnt, "sotim") < 1  then
//	scolumn = "sotim"
//	f_message_chk(1400,'[소요시간]') 
//	RETURN  -1	
//end if

String ls_stim
String ls_etim
if isnull(dw_list.getitemdecimal(lcnt, "sotim")) or dw_list.getitemdecimal(lcnt, "sotim") < 1 then
	ls_stim = dw_list.GetItemString(lcnt, 'stime')
	ls_etim = dw_list.GetItemString(lcnt, 'etime')
   if not Istime(left(ls_stim, 2) + ':' + right(ls_stim, 2)) then
		f_message_chk(176, "시작시간")
		dw_list.setitem(1, "stime",   '')
		dw_list.setitem(1, 'stime', '')
		dw_list.setitem(1, 'toset', 0)
		dw_list.setitem(1, 'toman', 0)
		dw_list.setitem(1, 'tomch', 0)
		dw_list.setitem(1, 'sotim', 0)
		return 1 
   end if
	
	if not Istime(left(ls_etim, 2) + ':' + right(ls_etim, 2)) then
		f_message_chk(176, "종료시간")
		dw_list.setitem(1, "etime",   '')
		dw_list.setitem(1, 'etime', '')
		dw_list.setitem(1, 'toset', 0)
		dw_list.setitem(1, 'toman', 0)
		dw_list.setitem(1, 'tomch', 0)
		dw_list.setitem(1, 'sotim', 0)
		return 1 
   end if
	
	if wf_settime() = -1 then
		dw_list.setitem(1, 'toset', 0)
		dw_list.setitem(1, 'toman', 0)
		dw_list.setitem(1, 'tomch', 0)
		dw_list.setitem(1, 'sotim', 0)		
	end if
End If



if dw_detail.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 에 만 check하고 수정에서는 품번을 수정 못 함*/
	if isnull(dw_list.getitemstring(lcnt, "morout_itnbr"))  or &
		trim(dw_list.getitemstring(lcnt, "morout_itnbr")) =  ""  then
		scolumn = "morout_itnbr"
		f_message_chk(1400,'[품번]') 
		RETURN  -1	
	end if

	if isnull(dw_list.getitemstring(lcnt, "morout_pspec"))  or &
		trim(dw_list.getitemstring(lcnt, "morout_pspec")) =  ""  then
		dw_list.setitem(lcnt, "morout_pspec", '.')
	end if
end if

/* 잔량check  < Y = 완료수량 - (이전양품 + 이전불량 + 이전폐기) + 
												양품 +     불량 +     폐기 	*/
			
IF dw_detail.getitemstring(1, "jagbn") = 'Y' THEN		/* 신규인 경우 */
	if dw_list.getitemdecimal(lcnt, "janqty") <  &
		dw_list.getitemdecimal(lcnt, "waqty") + &
		dw_list.getitemdecimal(lcnt, "buqty") + &
		dw_list.getitemdecimal(lcnt, "ppqty") then
		f_message_chk(96,'[잔량]') 
		scolumn = "waqty"			
		return -1	
	end if
ELSE
	if dw_list.getitemdecimal(lcnt, "janqty") <  &
		dw_list.getitemdecimal(lcnt, "waqty") + &
		dw_list.getitemdecimal(lcnt, "buqty") + &
		dw_list.getitemdecimal(lcnt, "ppqty") - &
		dw_list.getitemdecimal(lcnt, "old_coqty") - &
		dw_list.getitemdecimal(lcnt, "old_peqty") - &
		dw_list.getitemdecimal(lcnt, "old_faqty") then
		f_message_chk(96,'[잔량]') 
		scolumn = "waqty"			
		return -1	
	end if
END IF
		
if dw_list.getitemdecimal(lcnt, "waqty") < 0  then
	scolumn = "waqty"
	f_message_chk(1400,'[양품]') 
	RETURN  -1
end if
		
if dw_list.getitemdecimal(lcnt, "buqty") < 0  then
	scolumn = "buqty"
	f_message_chk(1400,'[불량]') 
	RETURN  -1
end if

if dw_list.getitemdecimal(lcnt, "ppqty") < 0  then
	scolumn = "ppqty"
	f_message_chk(1400,'[폐기]') 
	RETURN  -1
end if

if dw_list.getitemdecimal(lcnt, "waqty") + dw_list.getitemdecimal(lcnt, "buqty") &
   + dw_list.getitemdecimal(lcnt, "ppqty") <= 0  then
	scolumn = "waqty"
	f_message_chk(1400,'[수량]') 
	RETURN  -1
end if
		
ireturn = 0
sreff = dw_list.getitemstring(lcnt, "morout_wkctr")
select a.wkctr, a.wcdsc, b.jocod, b.jonam
  into :sitnbr, :sreff1, :sitdsc, :sispec
  from wrkctr a, jomast b
 where a.wkctr = :sreff and a.jocod = b.jocod (+);
if sqlca.sqlcode <> 0 then
	f_message_chk(90,'[작업장]')
	setnull(sreff1)		
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
if not isnull(sitdsc)  and isnull(sitdsc) then
	f_message_chk(91,'[블럭]')
	setnull(sreff1)
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
dw_list.setitem(lcnt, "morout_wkctr", sitnbr)
dw_list.setitem(lcnt, "wrkctr_wcdsc", sreff1)
dw_list.setitem(lcnt, "morout_jocod", sitdsc)
dw_list.setitem(lcnt, "jomast_jonam", sispec)
if ireturn  = -1 then 
	scolumn = "morout_wkctr"
	return -1
end if

ireturn = 0
sreff = dw_list.getitemstring(lcnt, "morout_mchcod")
if isnull(sreff) or trim(sreff) = '' then
else	
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = -1
	end if
	dw_list.setitem(lcnt, "mchmst_mchnam", sreff1)
	if ireturn  = -1 then 
		scolumn = "morout_mchcod"
		return -1
	end if
end if

 if dw_list.getitemstring(lcnt, "lastc")  = '3' or &
	 dw_list.getitemstring(lcnt, "lastc")  = '9' then
	 if isnull(dw_list.getitemstring(lcnt, "gubun")) then
		 f_message_chk(1400,'[입고창고]') 
		 scolumn = "gubun"
		 return -1	
	 end if
  end if

 sItnbr = dw_list.getitemstring(Lcnt, "morout_itnbr")
 Select ittyp into :sittyp from itemas 
  where itnbr = :sItnbr;

// if dw_list.getitemstring(lcnt, "lastc")  = '3' or &
//	 dw_list.getitemstring(lcnt, "lastc")  = '9' then
//	 if (sittyp = '1' and sWanlot = 'Y' )  or &
//		 (sittyp = '2' and sBanlot = 'Y' )  Then 
//		 if isnull(dw_list.getitemstring(lcnt, "lots"))  or &
//			 trim(dw_list.getitemstring(lcnt, "lots")) = '' then
//			 f_message_chk(1400,'[LOT번호]') 
//			 scolumn = "lots"
//			 return -1	
//		 end if
//	 end if
// end if

// IF is_chk = 'Y' then 
//	 if isnull(dw_list.getitemstring(lcnt, "empname"))  or &
//		 trim(dw_list.getitemstring(lcnt, "empname")) = '' then
//		 f_message_chk(1400,'[작업자]') 
//		 scolumn = "empno"
//		 return -1	
//	 end if		  
// END IF



//////////////////////////////////////////////////////////////////////////////////////////////////////
// 반제품 투입 저장 - 2006.08.05 - 송병호
FOR lRow = 1 TO dw_jaje.Rowcount()
	sitnbr = Trim(String(dw_jaje.object.itnbr[lRow]))
	IF IsNull(sitnbr) Or sitnbr = '' Then
		f_message_chk(30,'[품번]')
		dw_jaje.ScrollToRow(lrow)
		dw_jaje.Setcolumn("itnbr")
		dw_jaje.setfocus()
		Return -1
	End If

//	ls_pspec = Trim(String(dw_jaje.object.pspec[lRow]))
//	IF IsNull(ls_pspec) Or ls_pspec = '' Then
//		f_message_chk(30,'[생산구분]')
//		dw_jaje.ScrollToRow(lrow)
//		dw_jaje.Setcolumn("pspec")
//		dw_jaje.setfocus()
//		Return -1
//	End If

//	ls_lotsno = Trim(String(dw_jaje.object.lotsno[lRow]))
//	IF IsNull(ls_lotsno) Or ls_lotsno = '' Then
//		f_message_chk(30,'[LOT-NO]')
//		dw_jaje.ScrollToRow(lrow)
//		dw_jaje.Setcolumn("lotsno")
//		dw_jaje.setfocus()
//		Return -1
//	End If

	ll_inqty 	= Long(dw_jaje.object.tuipqty[lRow])		
	If ll_inqty <= 0 then
		f_message_chk(30,'[투입수량]')
		dw_jaje.ScrollToRow(lrow)
		dw_jaje.Setcolumn("tuipqty")
		dw_jaje.setfocus()
		Return -1
	end if
NEXT

return 1
end function

public function integer wf_settime ();sTring sdate, stime, edate, etime, spoint
Long   Lday, Linwon
Dec {2} dfirtime, dsectime, dtotal, desset, desman, desmch
Dec {2} dsetrate, dmanrate, dmchrate, dset, dman, dmch

sdate  = dw_list.getitemstring(1, "sdate")
stime  = dw_list.getitemstring(1, "stime")
edate  = dw_list.getitemstring(1, "edate")
etime  = dw_list.getitemstring(1, "etime")
Linwon = dw_list.getitemdecimal(1, "toiwn")


// 시작일자와 종료일자사이의 일수를 구함 ( 9999인 경우에는 Error )
Lday = f_dayterm(sdate, edate)
if Lday = 9999 then return -1

// 시작일의 시작시간 부터 종료시간 까지의 시간을 구함
// 일수가 0인      경우 (시작일 시작시간(휴식시간 제외 > ) + 종료시간(휴식시간 제외 < ))
// 일수가 1인      경우 (시작일 시작시간(휴식시간 제외 > ) + 24시까지) + (00 ~ 종료일 종료시간(휴식시간 제외 < ))
// 일수가 1이상 인 경우 (시작일 시작시간(휴식시간 제외 > ) + 24시까지) + (00 ~ 종료일 종료시간(휴식시간 제외 < ))

if Lday > 0 then
	spoint = '9999'
Else
	spoint = etime
End if

// 시작시간 이후 휴식시간 검색(From ~ to)
SELECT SUM(NVL(TO_NUMBER(DATANAME),0))
  INTO :dFirtime
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = 28 AND LINENO <> '00'
	and TITLENAME >= :stime And TITLENAME <= :spoint;
	
if isnull(dfirtime) then 
	dfirtime = 0
end if

//dfirtime = dfirtime * Linwon
dfirtime = dfirtime 

// 종료시간 이전 휴식시간 검색(From ~ to)
dSectime = 0
if Lday > 0 then
	SELECT SUM(NVL(TO_NUMBER(DATANAME),0))
	  INTO :dSectime
	  FROM SYSCNFG
	 WHERE SYSGU = 'Y' and SERIAL = 28 AND LINENO <> '00'
		and TITLENAME <= :etime;
		
	if isnull(dSectime) then 
		dSectime = 0
	end if		
		
End if

//dsectime = dsectime * Linwon
dsectime = dsectime 

// 시간계산
dtotal = f_daytimeterm(sdate, edate, stime, etime)
if dtotal = -1 then return -1

// 배분하기 위하여 준비시간, man, m/c의 시간을 구함
// 총 시간으로 시간을 배부하고 사용자가 수정한다. 
desset = dw_list.getitemdecimal(1, "morout_esset")
desman = dw_list.getitemdecimal(1, "morout_esman")
desmch = dw_list.getitemdecimal(1, "morout_esmch")

if (desset + desman + desmch) <= 0 then 
	dsetrate = 0
	dmanrate = 0 
	dmchrate = 0
else
	dsetrate = desset / (desset + desman + desmch) 
	dmanrate = desman / (desset + desman + desmch)
	dmchrate = desmch / (desset + desman + desmch)
end if

// 비율별로 시간계산을 한다.
dset = truncate(dtotal * dsetrate, 2)
//dman = truncate(dtotal * dmanrate * Linwon, 2)
dman = truncate(dtotal * dmanrate , 2)

// 휴식시간은 Man H/R기준인 경우에만 가감하고 휴식시간이 큰 경우에는 Skip한다.
if dw_list.getitemstring(1, "morout_esgbn") = '1' and dman > (dfirtime + dsectime) Then
   dman = dman - (dfirtime + dsectime)	
End if
dmch = truncate(dtotal * dmchrate, 2)

if IsNull( dSet ) then dSet = 0
if IsNull( dman ) then dman = 0
if IsNull( dmch ) then dmch = 0

dw_list.setitem(1, "toset", dset)

// Man 시간 보고가 잘못 된 경우 (예를 들어서 점심시간이 12:00~13:00 인데 11:50~12:10으로 보고하면 Minus가 나타남
if dman < 0 then
	f_message_chk(177, '완료시간')
	return -1
End if
dw_list.setitem(1, "toman", dman)
dw_list.setitem(1, "tomch", dmch)
dw_list.setitem(1, "sotim", dset + dman + dmch)

return 1
end function

public subroutine wf_calc_tuipqty ();long		lrow
decimal	dqtypr, doldqty, dnewqty, droqty

dw_list.accepttext()
dw_jaje.accepttext()

droqty = dw_list.getitemnumber(1,"waqty") + dw_list.getitemnumber(1,"buqty")

for lrow = 1 to dw_jaje.rowcount()
	dqtypr = dw_jaje.getitemnumber(lrow,'qtypr')

//	doldqty = dw_jaje.getitemnumber(lrow,'tuipqty')
//	if doldqty = 0 then
		dw_jaje.setitem(lrow,'tuipqty',round(dqtypr*droqty,2))
//	end if
next
end subroutine

on w_pdt_05620_new.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.dw_jaje=create dw_jaje
this.dw_list2=create dw_list2
this.pb_1=create pb_1
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.rb_insert
this.Control[iCurrent+6]=this.rb_delete
this.Control[iCurrent+7]=this.dw_jaje
this.Control[iCurrent+8]=this.dw_list2
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cbx_1
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_2
this.Control[iCurrent+14]=this.rr_3
this.Control[iCurrent+15]=this.dw_1
end on

on w_pdt_05620_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.dw_jaje)
destroy(this.dw_list2)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_1)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)
dw_list2.SetTransObject(sqlca)
dw_jaje.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_detail.SetTransObject(sqlca)
dw_detail.insertrow(0)
//dw_detail.setitem(1,'edate',f_today())
dw_detail.setitem(1,'fdate',f_today())
dw_detail.setitem(1,'tdate',f_today())
dw_detail.setitem(1,'saupj',gs_saupj)
dw_detail.SetFocus()

dw_list.insertrow(0)
dw_list.setitem(1,'lots',f_today())
dw_list.setitem(1,'sdate',f_today())
dw_list.setitem(1,'edate',f_today())
dw_list.setitem(1,'empno',gs_empno)
dw_list.setitem(1,'empname',f_get_name5('02',gs_empno,''))


//f_mod_saupj(dw_detail, 'porgu')

end event

event key;call super::key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_05620_new
boolean visible = false
integer x = 133
integer y = 2404
integer width = 2295
integer height = 648
integer taborder = 30
string dataobject = "d_pdt_02130_2"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
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

type p_delrow from w_inherite`p_delrow within w_pdt_05620_new
boolean visible = false
integer x = 5088
integer y = 428
end type

event p_delrow::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long	lrow

lrow = dw_list.GetRow()
if lrow > 0 then dw_list.DeleteRow(lrow)
end event

type p_addrow from w_inherite`p_addrow within w_pdt_05620_new
boolean visible = false
integer x = 4914
integer y = 428
end type

event p_addrow::clicked;call super::clicked;//str_code lst_code


//gs_code = Trim(dw_jaje.object.itnbr[ll_srow])
//gs_codename = Trim(dw_jaje.object.itdsc[ll_srow])
//gs_gubun = Trim(dw_insert.object.saupj[1])

gs_gubun = 'w_pdt_05610_new'

//Open(w_pdt_05610_lot_pop)
//lst_code = Message.PowerObjectParm
//IF isValid(lst_code) = False Then Return 
//If UpperBound(lst_code.code) < 1 Then Return 




//w_mdi_frame.sle_msg.text =""
//
//long	lrow
//
//lrow = dw_list.InsertRow(0)
//
//dw_list.ScrollToRow(lRow)
//dw_list.SetColumn("itnbr")
//dw_list.SetFocus()
end event

type p_search from w_inherite`p_search within w_pdt_05620_new
boolean visible = false
integer x = 3173
integer y = 2792
end type

type p_ins from w_inherite`p_ins within w_pdt_05620_new
boolean visible = false
integer x = 3694
integer y = 2792
end type

type p_exit from w_inherite`p_exit within w_pdt_05620_new
integer x = 4411
end type

type p_can from w_inherite`p_can within w_pdt_05620_new
integer x = 4238
end type

event p_can::clicked;call super::clicked;wf_reset()
dw_list2.reset()
end event

type p_print from w_inherite`p_print within w_pdt_05620_new
boolean visible = false
integer x = 3346
integer y = 2792
end type

type p_inq from w_inherite`p_inq within w_pdt_05620_new
integer x = 3717
end type

event p_inq::clicked;call super::clicked;String ls_itnbr, ls_itdsc, ls_depot, ls_date1, ls_date2, ls_saupj, ls_jocod

IF dw_detail.AcceptText() = -1 THEN RETURN 

ls_itnbr = TRIM(dw_detail.GetItemString(1,"itnbr"))
//ls_itdsc = TRIM(dw_detail.GetItemString(1,"itdsc"))
ls_depot = TRIM(dw_detail.GetItemString(1,"chango"))
ls_date1  = TRIM(dw_detail.GetItemString(1,"fdate"))
ls_date2  = TRIM(dw_detail.GetItemString(1,"tdate"))
ls_saupj = TRIM(dw_detail.GetItemString(1,"saupj"))
ls_jocod = TRIM(dw_detail.GetItemString(1,"jocod"))

	
IF f_datechk(ls_date1) = -1 THEN 
	f_message_chk(30,'[실적일자]')
	dw_detail.SetColumn("fdate")
	dw_detail.SetFocus()
	Return
END IF

//IF ls_jocod ='' or isNull(ls_jocod) THEN 
//	f_message_chk(30,'[블럭]')
//	dw_detail.SetColumn("jocod")
//	dw_detail.SetFocus()
//	Return
//END IF

IF ls_itnbr ='' or isNull(ls_itnbr) THEN ls_itnbr = '%'
IF ls_saupj ='' or isNull(ls_saupj) THEN ls_saupj = '%'

IF ls_jocod = '' or isnull(ls_jocod) Then ls_jocod = '%'

Setpointer(Hourglass!)
IF dw_list2.Retrieve(gs_sabu, ls_date1, ls_jocod, ls_itnbr) <= 0 THEN
	f_message_chk(50, '[작업실적]')
	dw_detail.SetColumn("itnbr")
	dw_detail.SetFocus()
	w_mdi_frame.sle_msg.text = "조건에 맞는 내역이 없습니다."
	Return
END IF

dw_1.Retrieve(ls_date1, ls_jocod, ls_itnbr)

Setpointer(Arrow!)
wf_reset()

w_mdi_frame.sle_msg.text = "조회완료!!"
end event

type p_del from w_inherite`p_del within w_pdt_05620_new
integer x = 4064
end type

event p_del::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String 	sError, sGubun, shpjpno, sWigbn
int    	ireturn 
Long		ll_row


IF dw_jaje.AcceptText() = -1	THEN	RETURN
IF dw_detail.AcceptText() = -1	THEN	RETURN

ll_row = dw_list2.getselectedrow(0)
If ll_row <= 0 Then
	Messagebox("확인","선택된 자료가 없습니다.",Information!)
	Return
End If


IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)
shpjpno = dw_list2.getitemstring(ll_row,'shpjpno')

dw_list2.deleterow(ll_row)
IF dw_list2.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	return 
END IF

// 반제품 투입내역 삭제
DELETE FROM SHPACT_JAJE_LOT WHERE SABU = :gs_sabu AND SHPJPNO = :shpjpno ;

Commit;

SetPointer(Arrow!)
p_inq.TriggerEvent("clicked")

end event

type p_mod from w_inherite`p_mod within w_pdt_05620_new
integer x = 3890
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////////////
string 	sdate, sWigbn, sError, shpjpno, sGubun, ls_iojpno, scolumn, lst_stime, lst_etime, lst_old_stime, lst_old_etime ,lst_stdat ,lst_sidat, lst_old_stdat ,lst_old_sidat
long	 	lRow, ll_cnt
dec	 	dSeq
Long		ll_qty
Integer iReturn


//IF f_msg_update() = -1 	THEN	RETURN

iReturn = Messagebox('저 장','저장 하시겠습니까?~n하단 리스트의 작업시간 수정 저장은 예(Y), 품목 등록 저장은 아니오(N)를 선택하세요.',Question!,YesNoCancel!,1) 

IF iReturn = 1 THEN			 // Process OK.
   
    dw_list.setfocus()
	FOR lrow = 1 TO dw_list2.rowcount()
		
		shpjpno = dw_list2.getItemString(lrow,'shpjpno')
		lst_stime = dw_list2.getItemString(lrow, 'shpact_stime')
		lst_etime = dw_list2.getItemString(lrow, 'shpact_etime')
		
		lst_old_stime = dw_list2.getItemString(lrow, 'shpact_old_stime')
		lst_old_etime = dw_list2.getItemString(lrow, 'shpact_old_etime')
		
		lst_stdat = dw_list2.getItemString(lrow, 'shpact_stdat')
		lst_sidat = dw_list2.getItemString(lrow, 'shpact_sidat')
		
		lst_old_stdat = dw_list2.getItemString(lrow, 'shpact_old_stdat')
		lst_old_sidat = dw_list2.getItemString(lrow, 'shpact_old_sidat')
	
				
		if ((lst_stime <> lst_old_stime) or (lst_etime <> lst_old_etime)) then
				 
		   update SHPACT
			    set stime = :lst_stime, etime = :lst_etime
			where sabu = :gs_sabu 
			    and shpjpno = :shpjpno; 
				 
			IF SQLCA.SQLCODE <> 0	THEN
				w_mdi_frame.sle_msg.text = "작업시간 저장 중 에러 발생!!! 전표번호:"+shpjpno
				messagebox('확인', sqlca.sqlerrtext)	
				ROLLBACK;
				f_Rollback()
				RETURN -1
			END IF
		end if

	if ((lst_stdat <> lst_old_stdat) or (lst_sidat <> lst_old_sidat)) then
		
		update SHPACT
		     set stdat=:lst_stdat ,sidat=:lst_sidat
	     where sabu = :gs_sabu 
	         and shpjpno = :shpjpno; 

	IF SQLCA.SQLCODE <> 0	THEN
				w_mdi_frame.sle_msg.text = "작업시간 저장 중 에러 발생!!! 전표번호:"+shpjpno
				messagebox('확인', sqlca.sqlerrtext)	
				ROLLBACK;
				f_Rollback()
				RETURN -1
			END IF
		end if
	NEXT	
	Commit;
		
ELSEIF iReturn  = 2 THEN    // Process NO.	  
	if wf_requiredchk(lrow, scolumn)  = -1 then 
	//	dw_list.setcolumn(scolumn)
	//	dw_list.scrolltorow(lrow)
		dw_list.setfocus()
		w_mdi_frame.sle_msg.text = ''
		return
	end if        
	
	SetPointer(HourGlass!)
	IF dw_list.getitemstring(1,'create_flag') = 'Y' THEN
		SetPointer(HourGlass!)
		// 작업지시 내역 생성
		IF wf_mo_create() < 0 THEN 
			Rollback;
			RETURN 	
		End If
	
		// 작업실적 내역 생성
		IF wf_insert_shpact() < 0 THEN 
			Rollback;
			RETURN 	
		End If
	
		Commit;
	
	// 수정
	ELSE
		shpjpno = dw_list.getitemstring(1,'shpjpno')
		if shpjpno > '.' then
			lrow = dw_list2.find("shpjpno='"+shpjpno+"'",1,dw_list2.rowcount())
			if lrow > 0 then
				dw_list2.setitem(lrow,'shpact_lotsno',dw_list.getitemstring(1,'lots'))
				dw_list2.setitem(lrow,'shpact_opemp',dw_list.getitemstring(1,'empno'))
				dw_list2.setitem(lrow,'empname',dw_list.getitemstring(1,'empname'))
				dw_list2.setitem(lrow,'shpact_wkctr',dw_list.getitemstring(1,'morout_wkctr'))
				dw_list2.setitem(lrow,'wrkctr_wcdsc',dw_list.getitemstring(1,'wrkctr_wcdsc'))
				dw_list2.setitem(lrow,'shpact_mchcod',dw_list.getitemstring(1,'morout_mchcod'))
				dw_list2.setitem(lrow,'mchmst_mchnam',dw_list.getitemstring(1,'mchmst_mchnam'))
				dw_list2.setitem(lrow,'shpact_kumno',dw_list.getitemstring(1,'kumno'))
				dw_list2.setitem(lrow,'kummst_kumname',dw_list.getitemstring(1,'kumname'))
				dw_list2.setitem(lrow,'shpact_stdat',dw_list.getitemstring(1,'sdate'))
				dw_list2.setitem(lrow,'shpact_stime',dw_list.getitemstring(1,'stime'))
				dw_list2.setitem(lrow,'shpact_sidat',dw_list.getitemstring(1,'edate'))
				dw_list2.setitem(lrow,'shpact_etime',dw_list.getitemstring(1,'etime'))
				dw_list2.setitem(lrow,'shpact_coqty',dw_list.getitemnumber(1,'waqty'))
				dw_list2.setitem(lrow,'shpact_faqty',dw_list.getitemnumber(1,'buqty'))
				dw_list2.setitem(lrow,'shpact_stdat',dw_list.getitemstring(1,'stdat'))
				dw_list2.setitem(lrow,'shpact_sidat',dw_list.getitemstring(1,'sidat'))
				
			end if
		end if
	 
	
		// 반제품 투입내역-2006.08.05-송병호
		FOR lrow = 1 TO dw_jaje.rowcount()
			dw_jaje.setitem(lrow,'shpjpno',dw_list.getitemstring(1,'shpjpno'))
		NEXT
	
		IF dw_jaje.Update() <> 1	THEN
			ROLLBACK;
			f_Rollback()
			RETURN -1
		END IF
	
		// 
		IF dw_list2.Update() <> 1	THEN
			ROLLBACK;
			f_Rollback()
			RETURN		
		END IF
		
		Commit;
	END IF				  
ELSE
   Return -1 // Process CANCEL.
END IF


	
SetPointer(Arrow!)
wf_reset()
p_inq.TriggerEvent("clicked")
dw_list.setfocus()
end event

type cb_exit from w_inherite`cb_exit within w_pdt_05620_new
integer x = 2825
integer y = 2640
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdt_05620_new
integer x = 2126
integer y = 2640
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;//if dw_list.AcceptText() = -1 then return 
//
//if dw_list.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_list.update() = 1 then
//	sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdt_05620_new
integer x = 581
integer y = 2816
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_05620_new
integer x = 1184
integer y = 2736
end type

type cb_inq from w_inherite`cb_inq within w_pdt_05620_new
integer x = 1641
integer y = 2648
integer width = 329
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls, sfilter, newsort
//
//if dw_detail.AcceptText() = -1 then return 
//
//s_ittyp = dw_detail.GetItemString(1,'ittyp')
//s_itcls = dw_detail.GetItemString(1,'itcls')
//
//if isnull(s_ittyp) or s_ittyp = "" then
//	f_message_chk(30,'[품목구분]')
//	dw_detail.SetColumn('ittyp')
//	dw_detail.SetFocus()
//	return
//end if	
//
//SetPointer(HourGlass!)
//
//dw_list.setredraw(false)
//
//if isnull(s_itcls) Then s_itcls = ""
//
//if dw_list.Retrieve(s_ittyp, s_itcls) <= 0 then 
//	dw_detail.Setfocus()
//   dw_list.setredraw(true)
//	return
//else
//	dw_list.SetFocus()
//end if	
//
//ib_any_typing = FALSE
//
//dw_list.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_pdt_05620_new
integer x = 686
integer y = 2668
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_05620_new
end type

type cb_can from w_inherite`cb_can within w_pdt_05620_new
integer x = 2473
integer y = 2640
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_pdt_05620_new
integer x = 2661
integer y = 2876
end type





type gb_10 from w_inherite`gb_10 within w_pdt_05620_new
integer y = 2976
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_05620_new
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_05620_new
end type

type gb_3 from groupbox within w_pdt_05620_new
boolean visible = false
integer x = 2080
integer y = 2580
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdt_05620_new
boolean visible = false
integer x = 1591
integer y = 2588
integer width = 421
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_detail from datawindow within w_pdt_05620_new
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 16
integer width = 3255
integer height = 164
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_05620_new_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
      p_inq.TriggerEvent(Clicked!)
   End If
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
   p_inq.TriggerEvent(Clicked!)

elseif this.GetColumnName() = 'itnbr' then
	gs_gubun = '2'
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	SetItem(1,"itnbr",gs_code)
	PostEvent(ItemChanged!)	 
end if	
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull, sitnbr, sitdsc
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
//      cb_inq.TriggerEvent(Clicked!)
   end if

ELSEIF this.GetColumnName() = "itcls"	THEN
	s_itcls = this.gettext()
   IF s_itcls = "" OR IsNull(s_itcls) THEN 
		this.SetItem(1,'itnm', snull)
   ELSE
		s_itt  = this.getitemstring(1, 'ittyp')
		ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_name, s_itt)
		This.setitem(1, 'itcls', s_itcls)
		This.setitem(1, 'itnm', s_name)
   END IF
   p_inq.TriggerEvent(Clicked!)
	return ireturn 

ELSEIF this.GetColumnName() = "itnbr"	THEN
	sitnbr = Trim(gettext())
	SELECT "ITEMAS"."ITDSC"
	  INTO :sItDsc
	  FROM "ITEMAS"
	 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
		setitem(1, "itnbr", snull)
		setitem(1, "itdsc", snull)
		Return 1
	END IF

	SetItem(1,"itdsc",   sItDsc)

ELSEIF this.GetColumnName() = "fdate"	THEN
	s_name = this.gettext()
	if f_datechk(s_name) = -1 then
		MessageBox("확인", "일자가 잘못 지정되었습니다", stopsign!)
		setitem(1, "fdate", snull)
		Return 1
	END IF
		
	dw_list.setitem(1,'sdate',s_name)
	dw_list.setitem(1,'edate',s_name)
	dw_list.setitem(1,'lots',s_name)

	if wf_settime() = -1 then
		dw_list.setitem(1, 'toset', 0)
		dw_list.setitem(1, 'toman', 0)
		dw_list.setitem(1, 'tomch', 0)
		dw_list.setitem(1, 'sotim', 0)		
	end if

END IF
end event

type dw_list from u_d_select_sort within w_pdt_05620_new
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 228
integer width = 2391
integer height = 748
integer taborder = 11
boolean bringtotop = true
string title = "d_pdt_05620_new_02"
string dataobject = "d_pdt_05620_new_a"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, sjijil, sispec_code, scvcod
string	sopseq, sopdsc, sPordno, swkctr, swcdsc, smchno, smchname
string   sEdate, sLots, sMon
time     tchk
integer  ireturn
Decimal  {3}  dtime, dtime1, dSaVeqty, dPrqty, dPdqty, dsilrate, dstdst, dmanhr, dmchr

setnull(snull)

if this.getcolumnname() = "waqty" then
	dSaveqty = this.getitemdecimal(row, "waqty")
end if

this.accepttext()

IF GetColumnName() = "morout_itnbr"	THEN
	sItnbr = trim(GetText())
	/*************** 외작품은 등록 할 수 없음. - by shingoon 2007.01.29 ****************/
	String ls_gu
	SELECT ITGU
	  INTO :ls_gu
	  FROM ITEMAS
	 WHERE SABU  = '1'
	   AND ITNBR = :sItnbr;
	If ls_gu = '6' Then
		MessageBox('품번 확인', '해당 품번은 외작품이므로 등록하실 수 없습니다.')
		SetNull(ls_gu)
		This.SetItem(1, 'morout_itnbr', ls_gu)
		Return 1
	End If
	/************************************************************************************/
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(1, "morout_itnbr", sitnbr)	
	setitem(1, "itemas_itdsc", sitdsc)	
	setitem(1, "itemas_ispec", sispec)
	setitem(1, "itemas_jijil", sjijil)	
	setitem(1, "itemas_ispec_code", sispec_code)
	
	SELECT A.OPSEQ, A.OPDSC, A.WKCTR, B.WCDSC, C.MCHNO, C.MCHNAM, A.STDST, A.MANHR, A.MCHR
	  INTO :sopseq, :sopdsc, :swkctr, :swcdsc, :smchno, :smchname, :dstdst, :dmanhr, :dmchr
	  FROM ROUTNG A, WRKCTR B, MCHMST C
	 WHERE A.ITNBR = :sitnbr
		AND A.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR AND UPTGU = 'Y' )
		AND A.WKCTR = B.WKCTR(+)
		AND A.WKCTR = C.WKCTR(+) ;
		
	if sqlca.sqlcode = 0 then
		setitem(1, "morout_opseq", sopseq)	
		setitem(1, "routng_opdsc", sopdsc)	
		setitem(1, "morout_wkctr", swkctr)	
		setitem(1, "wrkctr_wcdsc", swcdsc)
		setitem(1, "morout_mchcod", smchno)
		setitem(1, "mchmst_mchnam", smchname)
		setitem(1, "morout_esset", dstdst)
		setitem(1, "morout_esman", dmanhr)
		setitem(1, "morout_esmch", dmchr)
	else
		messagebox('확인','표준공정이 없습니다!!!')
		setitem(1, "morout_itnbr", snull)	
		setitem(1, "itemas_itdsc", snull)	
		setitem(1, "itemas_ispec", snull)
		setitem(1, "itemas_jijil", snull)	
		setitem(1, "itemas_ispec_code", snull)
		setitem(1, "morout_opseq", snull)	
		setitem(1, "routng_opdsc", snull)	
		setitem(1, "morout_wkctr", snull)	
		setitem(1, "wrkctr_wcdsc", snull)
		setitem(1, "morout_mchcod", snull)
		setitem(1, "mchmst_mchnam", snull)
		setitem(1, "morout_esset", 0)
		setitem(1, "morout_esman", 0)
		setitem(1, "morout_esmch", 0)
		return 1
	end if
	
	
	// 투입대상품번 리스트업
	wf_insert_cinbr()

//	RETURN ireturn
ELSEIF GetColumnName() = "morout_pspec"	THEN
   if isnull(trim(this.gettext())) or trim(this.gettext()) = "" then
		f_message_chk(30, '사양')
		this.setitem(1, 'morout_pspec', '.')
		return 1
   end if 

	RETURN 
elseif this.getcolumnname() = "gubun" then
	 if this.getitemstring(1, "lastc") = '3' or &
		 this.getitemstring(1, "lastc") = '9' then
		 if isnull(this.getitemstring(1, "gubun")) then
			 f_message_chk(1400,'[입고창고]') 
		 	 RETURN  1	
		 end if
	  end if		 		
elseif this.getcolumnname() = "empno" then
   sitnbr = trim(this.gettext())
	 
  	ireturn = f_get_name2('사번', 'Y', sitnbr, sitdsc, sispec) 
	this.setitem(1, "empno", sitnbr)
	this.setitem(1, "empname", sitdsc)
	return ireturn 	  
elseif this.getcolumnname() = 'sdate' then
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "시작일자")
		setitem(1, "sdate",   snull)
		return 1
	end if
	
	if wf_settime() = -1 then
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)		
	end if
	
ELSEif this.getcolumnname() = "stime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(176, "시작시간")
		setitem(1, "stime",   snull)
		this.setitem(1, 'stime', snull)
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)
		return 1 
   end if 
	
	if wf_settime() = -1 then
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)		
	end if
	
elseif this.getcolumnname() = 'edate' then	
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "완료일자")
		setitem(1, "edate",   snull)
		return 1
	end if
	
	if wf_settime() = -1 then
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)		
	end if	
	
ELSEif this.getcolumnname() = "etime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2))  then
		f_message_chk(176, "완료시간")		
		this.setitem(1, 'etime', snull)
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)
		return 1 
   end if 
	
	if wf_settime() = -1 then
		this.setitem(1, 'stime', snull)
		this.setitem(1, 'toset', 0)
		this.setitem(1, 'toman', 0)
		this.setitem(1, 'tomch', 0)
		this.setitem(1, 'sotim', 0)		
	end if
		
elseif this.getcolumnname() = "toiwn"  then
	dtime = dec(gettext())
   if isnull(dec(this.gettext())) then 
		dtime = 0
   end if 

	// 인원수는 MAN H/R에만 적용한다.
//	this.setitem(1, "toman", this.getitemdecimal(1, "toman") * dtime)
//	
//	this.setitem(1, "sotim", this.getitemdecimal(1, "toset") + &
//												this.getitemdecimal(1, "toman") + &
//												this.getitemdecimal(1, "tomch"))	
elseif this.getcolumnname() = "toset"  then
	dtime = dec(gettext())
	this.setitem(1, "sotim", dtime + &
												this.getitemdecimal(1, "toman") + &
												this.getitemdecimal(1, "tomch"))
elseif this.getcolumnname() = "toman"  then
	dtime = dec(gettext())
	this.setitem(1, "sotim", this.getitemdecimal(1, "toset") + &
												dtime + &
												this.getitemdecimal(1, "tomch"))
elseif this.getcolumnname() = "toman"  then
	dtime = dec(gettext())
	this.setitem(1, "sotim", this.getitemdecimal(1, "toset") + &
												this.getitemdecimal(1, "tomch") + &
												dtime)
elseif this.getcolumnname() = "waqty"  then	/* 불량, 폐기는 check안함 */
	dTime = dec(this.gettext())
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(1, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate
	
	sreff = this.getitemstring(1, "shpjpno")
	
//	Select Sum(Nvl(ipqty, 0)) into :dTime1
//	  From shpact_ipgo
//	 Where sabu = :gs_sabu and shpjpno = :sReff;
//	
//	if dTime < dTime1 then
//		Messagebox("수량확인","입고예정량 보다 작으면 안됩니다", stopsign!)
//		this.setitem(1, "waqty", dSaveqty)
//		RETURN  1	
//	end if
	
	setitem(row, "waqty", dtime)
	setitem(row, "roqty", dTime + &
								 getitemdecimal(row, "buqty") + &
								 getitemdecimal(row, "ppqty"))	
	sEdate = this.getitemstring(1, "edate")
   
	select chr(64 + to_number(substr(:sedate,5,2))) into :sMon from dual;
	
//	sLots  = Mid(sEdate,4,1) + sMon + Mid(sEdate,7,2)
//	setitem(row, "lots", sLots)

elseif this.getcolumnname() = "buqty"  then	
	dTime = dec(this.gettext())
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(1, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate	
	
	setitem(row, "buqty", dtime)
	setitem(row, "roqty", getitemdecimal(row, "waqty") + &
								 dTime + &
								 getitemdecimal(row, "ppqty"))

elseif this.getcolumnname() = "ppqty"  then	
	dTime = dec(this.gettext())
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(1, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate	
	
	setitem(row, "ppqty", dtime)	
	setitem(row, "roqty", getitemdecimal(row, "waqty") + &
								 getitemdecimal(row, "buqty") + &
								 dTime)
elseif this.getcolumnname() = "morout_wkctr" then
	ireturn = 0
	sreff = this.gettext()
	
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[조]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	
	String ls_mch[]
	SELECT MCHNO, MCHNAM
	  INTO :ls_mch[1], :ls_mch[2]
	  FROM MCHMST
	 WHERE WKCTR = :sitnbr ;
	If Trim(ls_mch[1]) = '' OR IsNull(ls_mch[1]) Then ls_mch[1] = ''
	this.setitem(1, "morout_mchcod", ls_mch[1])
	this.setitem(1, "mchmst_mchnam", ls_mch[2])
	
	this.setitem(1, "morout_wkctr", sitnbr)
	this.setitem(1, "wrkctr_wcdsc", sreff1)
	this.setitem(1, "morout_jocod", sitdsc)
	this.setitem(1, "jomast_jonam", sispec)
	return ireturn
elseif this.getcolumnname() = "morout_mchcod" then
	ireturn = 0
	sreff = this.gettext()
	
	if isnull(sreff) or trim(sreff) = '' then
		this.setitem(1, "mchmst_mchnam", snull)
		return
	end if
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(1, "morout_mchcod",  sreff)
	this.setitem(1, "mchmst_mchnam", sreff1)
	return ireturn	
elseif this.getcolumnname() = "kumno" then
	sreff = Trim(GetText())
	IF sreff ="" OR IsNull(sreff) THEN  
		this.setitem(1, "kumname", snull)
		Return
	End If
	
	SELECT "KUMNAME"  INTO :sreff1
	  FROM "KUMMST"
	 WHERE "SABU" = :gs_sabu AND "KUMNO" = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[금형]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(1, "kumno",  sreff)
	this.setitem(1, "kumname", sreff1)
	return ireturn	
end if

post wf_calc_tuipqty()
end event

event rbuttondown;call super::rbuttondown;string colname, sItnbr, sitdsc, sSpec
long   lrow

gs_code = ''
gs_codename = ''
gs_gubun = ''

colname = this.getcolumnname()
lrow    = this.getrow()

if colname = "morout_itnbr" or &
	colname = "itemas_itdsc" or &
	colname = "itemas_ispec" then
   gs_code = this.getitemstring(lrow, "morout_itnbr")
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(lrow,"morout_itnbr",gs_code)

	Select itnbr, itdsc, ispec into :sitnbr, :sItdsc, :sSpec
	  From itemas
	 where itnbr = :Gs_code;
	 
	setitem(lrow, "morout_itnbr", sitnbr)	
	this.triggerevent(itemchanged!)
//	setitem(lrow, "itemas_itdsc", sitdsc)	
//	setitem(lrow, "itemas_ispec", sspec)	 
	
elseif colname = "morout_mchcod" then
		 gs_gubun    = this.getitemstring(lrow, "morout_wkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "morout_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_wkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "morout_wkctr", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "empno" then
		 gs_code = this.gettext()
		 open(w_sawon_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "empno", gs_code)
		 this.triggerevent(itemchanged!)		 
elseif colname = "kumno" then
		gs_gubun = this.getitemstring(1, 'gubun')
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1,'kumno', gs_code)
		this.triggerevent(itemchanged!)
end if


end event

event clicked;//
end event

type rb_insert from radiobutton within w_pdt_05620_new
boolean visible = false
integer x = 4987
integer y = 64
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등 록"
boolean checked = true
end type

event clicked;dw_detail.setitem(1,'jagbn','Y')

dw_list.dataobject = 'd_pdt_05620_new_02'
dw_list.settransobject(sqlca)

dw_list.insertrow(0)
dw_list.setitem(1,'lotsno',f_today())
dw_list.setitem(1,'ip_date',f_today())
dw_list.setitem(1,'cvcod','ZZZ')
dw_list.setitem(1,'vndmst_cvnas2',f_get_name5('11','ZZZ',''))

dw_jaje.reset()
dw_jaje.visible = true
end event

type rb_delete from radiobutton within w_pdt_05620_new
boolean visible = false
integer x = 4987
integer y = 128
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "삭 제"
end type

event clicked;dw_detail.setitem(1,'jagbn','N')

dw_list.dataobject = 'd_pdt_05620_new_03'
dw_list.settransobject(sqlca)

dw_jaje.reset()
dw_jaje.visible = false
end event

type dw_jaje from datawindow within w_pdt_05620_new
integer x = 2469
integer y = 212
integer width = 2139
integer height = 788
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "자재소진내역"
string dataobject = "d_pdt_05620_new_02_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event buttonclicked;Long	ll_row, ii
String ls_null
SetNull(ls_null)

if dwo.name = 'b_ins' then	
	
	for ii = 1 to dw_jaje.rowcount()
		if dw_jaje.object.chk[ii] = 'Y' then
			dw_jaje.object.chk[ii] = 'N'
			
			ll_row = dw_jaje.RowCount() + 1
			dw_jaje.RowsCopy(ii,ii, Primary!, dw_jaje, ll_row , Primary!)	
				
			dw_jaje.SetColumn('itnbr')
			dw_jaje.SetRow(ll_row)
			dw_jaje.ScrollToRow(ll_row)
			dw_jaje.SetFocus()	
		end if
	next
	
	
end if


if dwo.name = 'b_del' then
	
	For ll_row = dw_jaje.RowCount() to 1 Step -1	
		
		If Trim(dw_jaje.object.chk[ll_row]) = 'Y' Then
			dw_jaje.DeleteRow(ll_row)
		End If
	Next	
end if

end event

type dw_list2 from u_d_select_sort within w_pdt_05620_new
integer x = 27
integer y = 1032
integer width = 4571
integer height = 1288
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pdt_05620_new_b"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;//if row <= 0 then return
//
////
//dw_list.setredraw(false)
//if dw_list.retrieve(gs_sabu, this.getitemstring(row,'pordno'), this.getitemstring(row,'opsno')) <= 0 then
//	dw_list.insertrow(0)
//else
//	dw_list.setitem(1,'shpjpno',this.getitemstring(row,'shpjpno'))
//	dw_list.setitem(1,'lots',this.getitemstring(row,'shpact_lotsno'))
//	dw_list.setitem(1,'empno',this.getitemstring(row,'shpact_opemp'))
//	dw_list.setitem(1,'empname',this.getitemstring(row,'empname'))
//	dw_list.setitem(1,'morout_wkctr',this.getitemstring(row,'shpact_wkctr'))
//	dw_list.setitem(1,'wrkctr_wcdsc',this.getitemstring(row,'wrkctr_wcdsc'))
//	dw_list.setitem(1,'morout_mchcod',this.getitemstring(row,'shpact_mchcod'))
//	dw_list.setitem(1,'mchmst_mchnam',this.getitemstring(row,'mchmst_mchnam'))
//	dw_list.setitem(1,'kumno',this.getitemstring(row,'shpact_kumno'))
//	dw_list.setitem(1,'kumname',this.getitemstring(row,'kummst_kumname'))
//	dw_list.setitem(1,'sdate',this.getitemstring(row,'shpact_stdat'))
//	dw_list.setitem(1,'stime',this.getitemstring(row,'shpact_stime'))
//	dw_list.setitem(1,'edate',this.getitemstring(row,'shpact_sidat'))
//	dw_list.setitem(1,'etime',this.getitemstring(row,'shpact_etime'))
//	dw_list.setitem(1,'waqty',this.getitemnumber(row,'shpact_coqty'))
//	dw_list.setitem(1,'buqty',this.getitemnumber(row,'shpact_faqty'))
//end if
//dw_list.setredraw(true)
//
////
//dw_jaje.retrieve(gs_sabu, this.getitemstring(row,'shpjpno'))
end event

event itemchanged;call super::itemchanged;String sreff
this.accepttext()

if this.getcolumnname() = "shpact_stime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(176, "시작시간")
		return 1 
   end if 
	
elseif this.getcolumnname() = "shpact_etime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2))  then
		f_message_chk(176, "완료시간")		
		return 1 
   end if 	
end if
end event

event itemerror;call super::itemerror;return 1
end event

type pb_1 from u_pb_cal within w_pdt_05620_new
integer x = 759
integer y = 56
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_detail.SetColumn('fdate')
IF IsNull(gs_code) THEN Return
dw_detail.SetItem(1, 'fdate', gs_code)

dw_list.setitem(1,'sdate',gs_code)
dw_list.setitem(1,'edate',gs_code)
dw_list.setitem(1,'lots',gs_code)

end event

type cb_1 from commandbutton within w_pdt_05620_new
integer x = 3287
integer y = 108
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이 버튼 저장"
end type

event clicked;If dw_1.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장 실패!!')
	Return
End If
end event

event constructor;If String(TODAY(), 'yyyymmdd') > '20071224' Then
	This.Visible = False
Else
	This.Visible = True
End If
end event

type cbx_1 from checkbox within w_pdt_05620_new
integer x = 3296
integer y = 36
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "수정"
end type

event clicked;If This.Checked = True Then	
	dw_1.Visible = True
Else
	dw_1.Visible = False
End If

end event

event constructor;If String(TODAY(), 'yyyymmdd') > '20071224' Then
	This.Visible = False
Else
	This.Visible = True
End If
end event

type rr_1 from roundrectangle within w_pdt_05620_new
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 200
integer width = 2423
integer height = 800
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_05620_new
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 4942
integer y = 40
integer width = 334
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_05620_new
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 1024
integer width = 4594
integer height = 1316
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_pdt_05620_new
boolean visible = false
integer x = 27
integer y = 212
integer width = 4567
integer height = 2128
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "test"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

