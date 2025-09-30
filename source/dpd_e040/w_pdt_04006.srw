$PBExportHeader$w_pdt_04006.srw
$PBExportComments$Spare Part & 유류품 구매의뢰
forward
global type w_pdt_04006 from window
end type
type p_2 from uo_picture within w_pdt_04006
end type
type p_1 from uo_picture within w_pdt_04006
end type
type p_retrieve from uo_picture within w_pdt_04006
end type
type p_insert from uo_picture within w_pdt_04006
end type
type p_del from uo_picture within w_pdt_04006
end type
type p_save from uo_picture within w_pdt_04006
end type
type p_delete from uo_picture within w_pdt_04006
end type
type p_cancel from uo_picture within w_pdt_04006
end type
type p_exit from uo_picture within w_pdt_04006
end type
type rb_delete from radiobutton within w_pdt_04006
end type
type rb_insert from radiobutton within w_pdt_04006
end type
type dw_detail from datawindow within w_pdt_04006
end type
type dw_list from datawindow within w_pdt_04006
end type
type rr_1 from roundrectangle within w_pdt_04006
end type
type rr_2 from roundrectangle within w_pdt_04006
end type
end forward

global type w_pdt_04006 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "Spare Part & 유류품 구매의뢰"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_2 p_2
p_1 p_1
p_retrieve p_retrieve
p_insert p_insert
p_del p_del
p_save p_save
p_delete p_delete
p_cancel p_cancel
p_exit p_exit
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_04006 w_pdt_04006

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_cnvart             // 변환연산자
sTring    is_cnvgu             // 변환적용여부
end variables

forward prototypes
public function integer wf_update ()
public subroutine wf_cal_qty (decimal ad_qty, long al_row)
public function integer wf_delete ()
public function integer wf_item (string sitem, string sspec, long lrow)
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_pspec, string arg_opseq)
end prototypes

public function integer wf_update ();string	sJpno, sDate
long		lRow, dSeq

if dw_detail.AcceptText() = -1 then return -1

sDate = trim(dw_detail.GetItemString(1, "sdate"))

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')

IF dSeq < 1	 or dseq > 9999	THEN
	rollback;
	f_message_chk(51, '')
   RETURN -1
END IF

COMMIT;


sJpno = sDate + string(dSeq, "0000")

FOR	lRow = 1		TO		dw_list.RowCount()

	dw_list.SetItem(lRow, "estno", sJpno + string(lRow, "000"))

NEXT


MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r생성되었습니다.")

RETURN 1
end function

public subroutine wf_cal_qty (decimal ad_qty, long al_row);
IF dw_list.AcceptText() = -1	THEN	RETURN 

string	sItem
dec{3}	dBalQty, dMinqt, dMulqt, dMul


sItem  = dw_list.GetItemString(al_Row, "itnbr")
dBalQty = dw_list.GetItemDecimal(al_Row, "vnqty")

//IF IsNull(sItem) or sItem = ''	THEN	RETURN
	
  SELECT NVL("ITEMAS"."MINQT", 1),    
         NVL("ITEMAS"."MULQT", 1)   
    INTO :dMinqt,   
         :dMulqt  
    FROM "ITEMAS"  
   WHERE "ITEMAS"."ITNBR" = :sItem   ;
	
IF isnull(dMinqt) or DMINQT < 1 THEN dminqt = 1
IF isnull(dMulqt) or DMulQT < 1 THEN dmulqt = 1

IF ad_qty < dMinqt 	THEN
	dBalQty = dMinqt
ELSE

	IF dMulqt =	0	THEN	
		dMul = 1
	ELSE
		dMul = dMulqt
	END IF
	
	dBalQty = dMinqt + ( CEILING( (ad_Qty - dMinqt) / dMul ) * dMulqt)
	
END IF

dw_list.SetItem(al_Row, "vnqty", 	dBalQty)

// 발주단위에 대한 업체발주량 변환(소숫점 2자리 까지만 사용)
if dw_list.getitemdecimal(al_row, "cnvfat") = 1  then
	dw_list.Setitem(al_row, "cnvqty", dBalqty)
elseif dw_list.getitemstring(al_row, "cnvart") = '/' then
	if dBalqty = 0 then
		dw_list.Setitem(al_row, "cnvqty",	0)	
	Else
		dw_list.Setitem(al_row, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(Al_row, "cnvfat"),3))
	end if
else
	dw_list.Setitem(al_row, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(Al_row, "cnvfat"),3))
end if




end subroutine

public function integer wf_delete ();
string	sGubun
long		lRow, lRowCount
lRowCount = dw_list.RowCount()


FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	sGubun = dw_list.GetItemString(lRow, "blynd")

	IF sGubun <> '1'	THEN
		MessageBox("확인", "검토완료된 자료는 삭제할 수 없습니다.~r" +	&
								 "LINE : " + string(lRow) )
		RETURN -1
	END IF

	dw_list.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public function integer wf_item (string sitem, string sspec, long lrow);String sname, sitgu, snull, sispec, spumsr, sAccod, sjijil, sIspec_code
Decimal {3} dJegoqty, dInqty, dOutqty, DbALQTY
Decimal {6} dCnvfat 

Setnull(sNull)

SELECT "ITEMAS"."ITDSC",
		 "ITEMAS"."ISPEC",
		 "ITEMAS"."JIJIL",
		 "ITEMAS"."ISPEC_CODE",
		 "ITEMAS"."ITGU", 
		 "ITEMAS"."PUMSR", 
		 "ITEMAS"."CNVFAT" 
  INTO :sName, 
		 :sIspec,
		 :sjijil, 
		 :sIspec_code,
		 :sItgu, :sPumsr, :dCnvfat  
  FROM "ITEMAS"
 WHERE ( "ITEMAS"."ITNBR" = :sItem )	AND
		 ( "ITEMAS"."USEYN" = '0' ) ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[품번]')
	dw_list.setitem(lRow, "itnbr", sNull)	
	dw_list.SetItem(lRow, "itemas_itdsc", sNull)
	dw_list.SetItem(lRow, "itemas_ispec", sNull)
	dw_list.SetItem(lRow, "itemas_jijil", sNull)
	dw_list.SetItem(lRow, "itemas_ispec_code", sNull)
	dw_list.SetItem(lRow, "itemas_pumsr", sNull)
	dw_list.SetItem(lRow, "yebi1", sNull)
	dw_list.SetItem(lRow, "itgu",   sNull)
	dw_list.SetItem(lRow, "suipgu", sNull)
	dw_list.setitem(lrow, "stock_view_jego", 0)
	dw_list.setitem(lrow, "inqty", 0)
	dw_list.setitem(lrow, "outqty", 0)
	dw_list.setitem(lrow, "cnvfat", 1)
	RETURN 1
END IF

dw_list.SetItem(lRow, "itemas_itdsc", sName)
dw_list.SetItem(lRow, "itemas_ispec", sIspec)
dw_list.SetItem(lRow, "itemas_jijil", sjijil)
dw_list.SetItem(lRow, "itemas_ispec_code", sIspec_code)
dw_list.SetItem(lRow, "itemas_pumsr", sPumsr)
if sitgu >= '1' and sitgu <= '6' then
	dw_list.setitem(lrow, "itgu", sitgu)
else
	dw_list.setitem(lrow, "itgu", '1')
end if
if sitgu = '3' or sitgu = '4' then
	dw_list.SetItem(lRow, "suipgu", '2')
else
	dw_list.SetItem(lRow, "suipgu", '1')
end if	

// 변환계수 저장
if isnull(dCnvfat) or dCnvfat = 0 then
	dCnvfat = 1
end if

if is_cnvgu = 'Y' then
	dw_list.setitem(lrow, "cnvfat", dcnvfat)
else
	dw_list.setitem(lrow, "cnvfat", 1)
end if

dBalqty = dw_list.getItemdecimal(LROW, "vnqty")

// 발주단위에 대한 업체발주량 변환(소숫점 2자리 까지만 사용)
if dw_list.getitemstring(LROW, "cnvart") = '/' then
	if dBalqty = 0 then
		dw_list.Setitem(LROW, "cnvqty",	0)	
	Else
		dw_list.Setitem(LROW, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(LROW, "cnvfat"),3))
	end if
else
	dw_list.Setitem(LROW, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(LROW, "cnvfat"),3))
end if

/* 재고정보 */
SELECT   A.JEGO_QTY AS JEGO,  
		( A.JISI_QTY + A.PROD_QTY + A.BALJU_QTY + A.POB_QC_QTY + A.INS_QTY
		  + A.GI_QC_QTY + A.GITA_IN_QTY ) AS INQTY, 
		( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) AS OUTQTY
 INTO :dJegoqty, :dInqty, :dOutqty
 FROM "STOCK_VIEW" A
WHERE A.ITNBR = :SITEM
  AND A.PSPEC = :SSPEC; 
  
dw_list.setitem(lrow, "stock_view_jego", dJegoqty)
dw_list.setitem(lrow, "inqty", dInqty)
dw_list.setitem(lrow, "outqty", dOutqty)

wf_buy_unprc(lrow, sitem, sspec, dw_list.getitemstring(lrow, "opseq"))

sAccod = SQLCA.FUN_GET_ITNACC(sitem, '4') ;
dw_list.setitem(lrow, "yebi1", sAccod)
		
return 0
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sToday, host_damcd, sCheck
dec{3}	dQty, dBalQty
dec{2}   dPrice
long		lRow, lCount

sToday = f_today()

lcount = dw_list.RowCount()

//시스템관리에서 필수여부를 체크하여 'Y'인 경우 필수로 체크 
SELECT DATANAME  
  INTO :sCheck  
  FROM SYSCNFG  
 WHERE SYSGU = 'Y'  AND  SERIAL = 31  AND  LINENO = '1'    ;

if sqlca.sqlcode <> 0  then sCheck = 'N'

FOR	lRow = 1		TO		lCount

	// 품번
	sItem = dw_list.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[품번]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// 사업장
	sCode = dw_list.GetitemString(lRow, "saupj")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[사업장]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("saupj")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// 거래처
	sCode = dw_list.GetitemString(lRow, "cvcod")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[거래처]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("cvcod")
		dw_list.setfocus()
		RETURN -1
	END IF

	//
	dQty = dw_list.getitemdecimal(lrow, "guqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[구매요구수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("guqty")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	//
	dBalQty = dw_list.getitemdecimal(lrow, "vnqty")
	IF IsNull(dBalQty)  or  dBalQty = 0		THEN
		f_message_chk(30,'[발주예정수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("vnqty")
		dw_list.setfocus()
		RETURN -1
	END IF

//	IF dQty > dBalQty		THEN
//		MessageBox("확인", "발주예정량은 구매요구량보다 큽니다.")
//		dw_list.ScrollToRow(lrow)
//		dw_list.Setcolumn("vnqty")
//		dw_list.setfocus()
//		RETURN -1
//	END IF
	
   //'Y'인 	경우 필수 체크
	IF sCheck = 'Y' then 
		sCode = dw_list.GetitemString(lRow, "order_no")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[수주번호]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("order_no")
			dw_list.setfocus()
			RETURN -1
		END IF
   END IF	

	sCode = dw_list.GetitemString(lRow, "rempno")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[의뢰담당자]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("rempno")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	//
	sCode = dw_list.GetitemString(lRow, "ipdpt")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[입고예정창고]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("ipdpt")
		dw_list.setfocus()
		RETURN -1
	END IF

	sCode = dw_list.GetitemString(lRow, "yebi1")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[계정코드]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("yebi1")
		dw_list.setfocus()
		RETURN -1
	END IF

	// 사양 : 입력값 없을 경우 -> '.' 입력
	sCode = dw_list.GetitemString(lRow, "pspec")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "pspec", '.')
	END IF


	// 구입형태가 NULL인 경우
	sCode = dw_list.GetitemString(lRow, "itgu")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "itgu", '1')
	END IF
	
	// 입력일자가 null인 경우
	sCode = trim(dw_list.GetitemString(lRow, "widat"))
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "widat", sToday)
	END IF	
	
	// 수입형태가 NULL인 경우
	sCode = dw_list.GetitemString(lRow, "suipgu")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		sCode = dw_list.GetitemString(lRow, "itgu")
		if scode = '3' or scode = '4' then
			dw_list.SetItem(lRow, "suipgu", '2')
		else
			dw_list.SetItem(lRow, "suipgu", '1')
		end if
	END IF
	
	// 구매담당자가 null인 경우
	sCode = dw_list.GetitemString(lRow, "sempno")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		string sCvcod, sEmpno
		sCvcod = dw_list.GetitemString(lRow, "cvcod")
		
		setnull(sEmpno)
		SELECT A.EMP_ID
		  INTO :sEmpno
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :sCvcod;
		 
		if sqlca.sqlcode <> 0 or isnull(sEmpno) or trim(sEmpno) = '' then	
			Setnull(host_damcd)
			select dataname
			  into :host_damcd
			  from syscnfg
			 where sysgu = 'Y' and serial = '14' and lineno = '1';
			dw_list.SetItem(lRow, "sempno", host_damcd)
		else
			dw_list.SetItem(lRow, "sempno", sempno)			
		end if
	END IF		

	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_list.GetitemString(lRow, "estno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_list.SetItem(lRow, "estno", is_Last_Jpno)
		END IF
	END IF

NEXT


RETURN 1
end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

//cb_save.enabled = false
p_delete.enabled = false
p_delete.picturename = 'c:\erpman\image\삭제_d.gif'

dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// 등록시
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("sDATE", 10)
	dw_detail.settaborder("EDATE", 20)
	dw_detail.settaborder("DEPT",  30)
	dw_detail.settaborder("empno", 40)
	dw_detail.settaborder("saupj", 50)
	dw_detail.settaborder("gigan", 60)
	dw_detail.settaborder("rate",  70)
	dw_detail.settaborder("depot", 80)
   dw_detail.settaborder("gubun", 90)
	
		dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.SetItem(1, "edate", is_Date)
	
	dw_detail.setcolumn("gubun")

	p_retrieve.enabled = false
	p_retrieve.picturename = 'c:\erpman\image\조회_d.gif'
	p_1.enabled = true
	p_1.picturename = 'c:\erpman\image\자동의뢰생성_up.gif'

ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sDATE", 0)
	dw_detail.settaborder("EDATE", 0)
	dw_detail.settaborder("DEPT",  0)
	dw_detail.settaborder("empno", 0)
	dw_detail.settaborder("saupj", 0)
	dw_detail.settaborder("gigan", 0)
	dw_detail.settaborder("rate", 0)
   dw_detail.settaborder("depot", 0)
	dw_detail.settaborder("gubun", 0)
	
   dw_detail.setcolumn("JPNO")

	p_retrieve.enabled = true
	p_retrieve.picturename = 'c:\erpman\image\조회_up.gif'
	p_1.enabled = false
	p_1.picturename = 'c:\erpman\image\자동의뢰생성_d.gif'
	
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_pspec, string arg_opseq);String sCvcod, sTuncu ,sCvnas
Decimal {5} dUnprc

f_buy_unprc(arg_itnbr, arg_pspec, arg_opseq, sCvcod, sCvnas, dUnprc, sTuncu)

if isnull(dUnprc) then dUnprc = 0 

dw_list.setitem(arg_row, "cvcod", scvcod)
dw_list.setitem(arg_row, "vndmst_cvnas2", sCvnas)
dw_list.setitem(arg_row, "cnvprc", dunprc)
dw_list.setitem(arg_row, "tuncu", stuncu)

// 발주예정단가 변환
if dw_list.getitemdecimal(arg_row, "cnvfat") = 1 then
	dw_list.setitem(arg_row, "unprc", dunprc)
elseif dw_list.getitemstring(arg_row, "cnvart") = '/' then
	dw_list.setitem(arg_row, "unprc", round(dunprc / dw_list.getitemdecimal(arg_row, "cnvfat"),5))
else
	dw_list.setitem(arg_row, "unprc", round(dunprc * dw_list.getitemdecimal(arg_row, "cnvfat"),5))
end if
end subroutine

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
///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

/* 구매의뢰 -> 발주확정 연산자를 환경설정에서 검색함 */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '4';
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
is_cnvart = sCnvart

if sCnvgu = 'Y' then // 발주단위 사용시
	is_cnvgu  = 'Y'
	dw_list.dataobject = 'd_pdt_04002'
Else						// 발주단위 사용안함
	is_cnvgu  = 'N'	
	dw_list.dataobject = 'd_pdt_04000'	
End if

//////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
is_Date = f_Today()

if f_change_name('1') = 'Y' then 
	dw_list.Modify("ispec_t.text = '" + f_change_name('2') + "'" )
	dw_list.Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end if	

// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_04006.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.p_2=create p_2
this.p_1=create p_1
this.p_retrieve=create p_retrieve
this.p_insert=create p_insert
this.p_del=create p_del
this.p_save=create p_save
this.p_delete=create p_delete
this.p_cancel=create p_cancel
this.p_exit=create p_exit
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_2,&
this.p_1,&
this.p_retrieve,&
this.p_insert,&
this.p_del,&
this.p_save,&
this.p_delete,&
this.p_cancel,&
this.p_exit,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_list,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_04006.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_retrieve)
destroy(this.p_insert)
destroy(this.p_del)
destroy(this.p_save)
destroy(this.p_delete)
destroy(this.p_cancel)
destroy(this.p_exit)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
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

type p_2 from uo_picture within w_pdt_04006
integer x = 4078
integer y = 284
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\공식_up.gif"
end type

event clicked;call super::clicked;open (w_pdt_formula)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\공식_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\공식_dn.gif'
end event

type p_1 from uo_picture within w_pdt_04006
integer x = 3776
integer y = 284
integer width = 306
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\자동의뢰생성_up.gif"
end type

event clicked;call super::clicked;String  ls_gubun , ls_sabu , ls_sdate, ls_edate, ls_dept, ls_empno, ls_rate , ls_return , ls_temp , ls_lastday, ls_firstday , ls_depot
integer li_gigan 
date    ld_lastday ,ld_firstday

 if dw_detail.Accepttext() = -1 then return 


ls_gubun = dw_detail.getitemstring( 1, "gubun" )
ls_sabu  = dw_detail.getitemstring( 1, "saupj" )
ls_sdate = dw_detail.getitemstring( 1, "sdate" )
ls_edate = dw_detail.getitemstring( 1, "edate" )
ls_dept  = dw_detail.getitemstring( 1, "dept" )
ls_empno = dw_detail.getitemstring( 1, "empno" )
li_gigan = dw_detail.getitemnumber( 1, "gigan" )
ls_rate  = dw_detail.getitemstring( 1, "rate" )
ls_depot = dw_detail.getitemstring( 1, "depot" )

// 필수 입력 항목 체크 --- 사업장, 의뢰 일자, 납기요구일, 의뢰 부서 , 의뢰 담당자 ,  기간 , 증감율  
if ls_gubun = "" or isnull(ls_gubun) then
	MessageBox("확인", " 구분 필수항목이 비었습니다." )
	dw_detail.setcolumn("gubun")
	dw_detail.setfocus()
	return
end if
if ls_sabu = "" or isnull(ls_sabu) then
	MessageBox("확인", " 사업장 필수항목이 비었습니다." )
	dw_detail.setcolumn("saupj")
	dw_detail.setfocus()
	return
end if
if ls_sdate = "" or isnull(ls_sdate) then
	MessageBox("확인", " 의뢰일자 필수항목이 비었습니다." )
	dw_detail.setcolumn("sdate")
	dw_detail.setfocus()
	return
end if
if ls_edate = "" or isnull(ls_edate) then
	MessageBox("확인", " 납기 요구일 필수항목이 비었습니다." )
	dw_detail.setcolumn("edate")
	dw_detail.setfocus()
	return
end if
if ls_dept = "" or isnull(ls_dept) then
	MessageBox("확인", " 부서 필수항목이 비었습니다." )
	dw_detail.setcolumn("dept")
	dw_detail.setfocus()
	return
end if
if ls_empno = "" or isnull(ls_empno) then
	MessageBox("확인", " 의뢰담당자 필수항목이 비었습니다." )
	dw_detail.setcolumn("empno")
	dw_detail.setfocus()
	return
end if
if li_gigan = 0 or isnull(li_gigan) then
	MessageBox("확인", " 기간 필수항목이 비었습니다." )
	dw_detail.setcolumn("gigan")
	dw_detail.setfocus()
	return
end if
if ls_rate = "" or isnull(ls_rate) then
	MessageBox("확인", " 증감율 필수항목이 비었습니다." )
	dw_detail.setcolumn("rate")
	dw_detail.setfocus()
	return
end if
if ls_depot = "" or isnull(ls_depot) then 
	MessageBox("확인", " 입고예정창고 필수항목이 비었습니다." )
	dw_detail.setcolumn("depot")
	dw_detail.setfocus()
	return
end if

// 의뢰 일자 + 기간 

ld_firstday = Relativedate ( date(string(ls_sdate, left(ls_sdate,4)+'-'+mid(ls_sdate,5,2)+'-'+right(ls_sdate,2))) ,  li_gigan * (-1))             
ld_lastday = Relativedate ( date(string(ls_sdate, left(ls_sdate,4)+'-'+mid(ls_sdate,5,2)+'-'+right(ls_sdate,2))) , li_gigan )

ls_firstday = string (ld_firstday, 'YYYYMMDD')
ls_lastday  = string (ld_lastday, 'YYYYMMDD' )


//(    a_sabu  in varchar2   -- 사부 ( gs_sabu)  
//     a_gubun in varchar2,  -- 구분 ( 1:유류품 , 2:Spare Part ) 
//     a_saupj in varchar2,  -- 사업장 (부가세 사업장 )
//     a_sdate in varchar2, -- 의뢰일자 
//     a_firstday in varchar2, -- 의뢰 일자 - 기간 
//     a_lastday in varchar2, -- 의뢰 일자 +기간
//     a_edate in varchar2 , -- 납기요구일
//     a_dept  in varchar2 , -- 의뢰부서 
//     a_empno in varchar2 , -- 의뢰 담당자 
//     a_rate  in varchar2 ,  -- 증감율
//     a_depot ins varchar2 , -- 입고 예정 창고      
//     a_delgu in varchar2 ) -- 삭제구분 (Y:이전분 삭제 , N:이전분 무시 ) 


ls_return = sqlca.fun_oil_spare( gs_sabu, ls_gubun, ls_sabu ,ls_sdate, ls_firstday, ls_lastday, ls_edate, ls_dept, ls_empno, ls_rate ,ls_depot, 'Y' ) 

if ls_return = 'N' then 
	  messageBox("알림", "자료생성중 오류가 발생 했습니다." )
elseif ls_return = 'C' then 
	  messageBox ("알림", "자료생성중 전표번호 채번 실패에 실패 했습니다." ) 
else
	  dw_detail.SetTabOrder( "jpno", 10)
	  dw_detail.setcolumn("jpno")
	  dw_detail.setitem(1,"jpno", ls_return )
     p_retrieve.triggerevent(clicked!)
	  dw_detail.SetTaborder( "jpno", 0 )
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\자동의뢰생성_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\자동의뢰생성_up.gif"
end event

type p_retrieve from uo_picture within w_pdt_04006
integer x = 3730
integer y = 76
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

sJpno   	= trim(dw_detail.getitemstring(1, "jpno"))

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[의뢰번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve('1', sjpno) <	1		THEN
	f_message_chk(50, '[구매의뢰]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if
///////////////////////////////
 /* 자동 의뢰 생성 후 조회   */
 
    ic_status = '2'

//////////////////////////////////////////////////////////////////////////
// 최종의뢰번호
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "estno")

dw_detail.enabled = false
p_delete.enabled = true
p_delete.picturename = 'c:\erpman\image\삭제_up.gif'

dw_list.SetColumn("itnbr")
dw_list.SetFocus()
//cb_save.enabled = true

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_insert from uo_picture within w_pdt_04006
integer x = 4251
integer y = 284
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_list) = -1	then	return

//////////////////////////////////////////////////////////
string	sStartDate, sEndDate, sDept, sGubun, saupj, sDepot,sEmpno
long		lRow

sStartDate = trim(dw_detail.GetItemString(1, "sdate"))
sEndDate = trim(dw_detail.GetItemString(1, "edate"))
saupj    = dw_detail.GetItemString(1, "saupj")
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")
sDepot   = dw_detail.GetItemString(1, "depot")
sEmpno   = dw_detail.GetItemString(1, "empno")

// 의뢰일자
IF isnull(sstartDate) or sstartDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 사업장
IF isnull(saupj) or saupj = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

// 의뢰구분
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[의뢰구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF


// 납기요구일
IF isnull(sEndDate) or sEndDate = "" 	THEN
	f_message_chk(30,'[납기요구일]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

// 의뢰부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[의뢰부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF

// 의뢰담당자
IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[의뢰담당자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

// 입고예정창고
IF isnull(sDepot) or sDepot = "" 	THEN
	f_message_chk(30,'[입고예정창고]')
	dw_detail.SetColumn("depot")
	dw_detail.SetFocus()
	RETURN
END IF

lRow = dw_list.InsertRow(0)

if ic_status = '1' and  dw_list.rowcount() = 1 then 
	dw_detail.settaborder("sDATE", 0)
end if

dw_list.SetItem(lRow, "saupj", saupj)
dw_list.SetItem(lRow, "rdate", sStartDate)
dw_list.SetItem(lRow, "yodat", sEndDate)
dw_list.SetItem(lRow, "rdptno", sDept)
dw_list.SetItem(lRow, "estgu", sGubun)
dw_list.SetItem(lRow, "ipdpt", sDepot)
dw_list.SetItem(lRow, "rempno", sEmpno)

//dw_list.SetItem(lRow, "rempno", dw_detail.GetItemString(1, "empno"))
dw_list.SetItem(lRow, "p1_master_empname", dw_detail.GetItemString(1, "empnm"))

// 연산자에 대한 자료 저장
if is_cnvgu = 'Y' then
	dw_list.SetItem(lRow, "cnvart", is_cnvart)
else
	dw_list.SetItem(lRow, "cnvart", '*')
end if


dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_del from uo_picture within w_pdt_04006
integer x = 4425
integer y = 284
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
////////////////////////////////////////////////////////
string	sGubun

sGubun = dw_list.GetItemString(lRow, "blynd")

IF sGubun <> '1'	THEN
	MessageBox("확인", "검토완료된 자료는 삭제할 수 없습니다.")
	RETURN 
END IF

dw_list.DeleteRow(lRow)

if ic_status = '1' and  dw_list.rowcount() < 1 then 
	dw_detail.settaborder("sDATE", 10)
   dw_detail.Object.sdate.Background.Color= 12639424
end if

///////////////////////////////////////////////////////
//IF dw_list.Update() > 0		THEN
//	COMMIT;
//ELSE
//	f_Rollback()
//	ROLLBACK;
//END IF
///////////////////////////////////////////////////////


end event

type p_save from uo_picture within w_pdt_04006
integer x = 3904
integer y = 76
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 전표채번구분('A0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq
string sdate

sDate = trim(dw_detail.GetItemString(1, "sdate"))

// 의뢰일자
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

IF	wf_CheckRequiredField() = -1		THEN		
	dw_list.setfocus()
	RETURN
END IF

IF f_msg_update() = -1 	THEN	RETURN
/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_update() = -1 THEN RETURN 

END IF

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;

ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_delete from uo_picture within w_pdt_04006
integer x = 4078
integer y = 76
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Delete() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF

p_cancel.TriggerEvent("clicked")
	
	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_cancel from uo_picture within w_pdt_04006
integer x = 4251
integer y = 76
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

type p_exit from uo_picture within w_pdt_04006
integer x = 4425
integer y = 76
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type rb_delete from radiobutton within w_pdt_04006
integer x = 3461
integer y = 160
integer width = 233
integer height = 72
integer taborder = 40
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

event clicked;
ic_status = '2'

wf_Initial()
end event

type rb_insert from radiobutton within w_pdt_04006
integer x = 3461
integer y = 92
integer width = 233
integer height = 72
integer taborder = 20
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

event clicked;
ic_status = '1'	// 등록

wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04006
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 60
integer width = 3397
integer height = 292
integer taborder = 10
string dataobject = "d_pdt_04006"
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

event itemchanged;string	sDate,  sDate2, sDept, sName, 	&
			sGubun, sNull, sname2, sPordno, sempno, sempnm, sSaupj
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "sdate", is_date)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[납기요구일]')
		this.setitem(1, "edate", is_date)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'dept' THEN

	sDept = this.gettext()
	
   ireturn = f_get_name2('부서', 'Y', sdept, sname, sname2)	 
	this.setitem(1, "dept", sdept)
	this.setitem(1, "deptname", sName)
   return ireturn 	 
	
	
ELSEIF this.GetColumnName() = 'empno' THEN

	sEmpno = this.gettext()
	
   ireturn = f_get_name2('사번', 'Y', sEmpno, sEmpnm, sname2)	 
	this.setitem(1, "empno", sEmpno)
	this.setitem(1, "empnm", sEmpnm)
   return ireturn 	 
	
ELSEIF this.getcolumnname() = "jpno"	then

	string	sJpno
	sJpno = this.gettext() 

  SELECT "ESTIMA"."RDATE",   
  			"ESTIMA"."YODAT",   
         "ESTIMA"."RDPTNO",   
         "ESTIMA"."ESTGU",   
         "ESTIMA"."REMPNO",   
			FUN_GET_EMPNO("ESTIMA"."REMPNO"), 
         "ESTIMA"."PORDNO",
			"ESTIMA"."SAUPJ",
         "VNDMST"."CVNAS2"  
    INTO :sDate,   
	 		:sDate2, 
         :sDept,   
         :sGubun,   
         :sEmpno,   
         :sEmpnm,   
			:sPordno,  
			:sSaupj,
         :sName  
    FROM "ESTIMA",   
         "VNDMST"  
   WHERE ( "ESTIMA"."RDPTNO" = "VNDMST"."CVCOD" ) and  
         ( SUBSTR("ESTIMA"."ESTNO",1,12) = :sJpno ) and rownum = 1 ;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[의뢰번호]')
		this.setitem(1, "jpno", sNull)
		return 1
	end if

   if not (spordno = '' or isnull(sPordno)) then 
		messageBox('확 인', '작업지시에 의한 구매의뢰자료는 선택할 수 없습니다.')
		this.setitem(1, "jpno", sNull)
		return 1
	end if

	this.setitem(1, "sdate",   sDate)	
	this.setitem(1, "edate", 	sDate2)		
	this.setitem(1, "dept", 	sDept)	
	this.setitem(1, "deptname", sName)	
	this.setitem(1, "gubun",    sGubun)	
	this.setitem(1, "empno", 	sEmpno)	
	this.setitem(1, "empnm", sEmpnm)	
	this.setitem(1, "saupj", sSaupj)	
END IF



end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code = ''
gs_codename = ''

// 부서
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptname",gs_codename)

ELSEif this.getcolumnname() = "jpno" 	then
	
	gs_Gubun = '1'
	open(w_estima_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
	
elseIF this.GetColumnName() = 'empno'	THEN
	
	this.accepttext()
	gs_gubun  = this.getitemstring(1, 'dept')

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1, "empno", gs_code)
	SetItem(1, "empnm", gs_codename)

	this.setitem(1, "dept", gs_gubun)
	
	string sdata
	Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
	this.setitem(1, "deptname", sdata)

end if


end event

type dw_list from datawindow within w_pdt_04006
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 456
integer width = 4544
integer height = 1752
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_04000"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)
setnull(gs_codename)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF this.GetColumnName() = 'cvcod'	THEN
		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
	
      if gs_code = '' or isnull(gs_code) then return 		
	
		SetItem(this.getrow(),"cvcod",gs_code)

		this.TriggerEvent("itemchanged")
		
	END IF
END IF
end event

event itemchanged;string	sNull, sispec_code, sjijil
string	sCode,  sName, 	&
			sItem,  sSpec, &
			sEmpno, sDate,	sItdsc, sIspec, sItnbr, sOpseq, sTuncu, sItgu
long		lRow, lReturnRow
dec {5}	dPrice
dec {3}	dQty, dBalQty, djegoqty, dInqty, dOutqty
Integer  iReturn
SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'itnbr'	THEN
	
	sItem = THIS.GETTEXT()	
	sspec = this.getitemstring(lrow, "pspec")

	ireturn = wf_item(sitem, sspec, lrow)
	return ireturn
	
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sItdsc = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	if ireturn = 0 then
		wf_item(sitnbr, sspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sIspec = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if ireturn = 0 then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if ireturn = 0 then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if ireturn = 0 then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
// 발주예정수량 계산
ELSEif this.getcolumnname() = "guqty" 	then

	dQty	= dec(this.GetText())
	
	wf_Cal_Qty(dQty, lRow)
	
// 거래처
ELSEIF this.GetColumnName() = "cvcod" THEN
	
	sCode  = this.GetText()								
	sItem  = this.GetItemString(lRow, "itnbr")
	sOpseq = this.GetItemString(lRow, "opseq")	
    
	if sCode = "" or isnull(sCode) then 
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		this.setitem(lRow, "unprc", 0)		
		this.setitem(Lrow, "cnvprc", 0)
		this.setitem(lrow, "tuncu", 'WON')
		return 
	end if

	/* 거래처 확인 */
   SELECT A.CVNAS, A.EMP_ID
     INTO :sName, :sEmpno
     FROM "VNDMST" A
    WHERE A.CVCOD = :sCode
	 	AND A.CVGU IN ('1','2','9'); 
		 
	IF SQLCA.SQLCODE <> 0 THEN
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		THIS.SETITEM(LROW, "sempno", SNULL)
		this.setitem(lRow, "unprc", 0)		
		this.setitem(Lrow, "cnvprc", 0)
		this.setitem(lrow, "tuncu", 'WON')
		F_MESSAGE_CHK(33, '[거래처]')
		RETURN 1
	END IF
	
	THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNAME)
	this.SetItem(lRow, "sempno", sEmpno)	
	
	dprice = 0
	STUNCU = 'WON'
			 
	/* 단가내역 확인 */
   SELECT NVL(B.UNPRC, 0), cunit
     INTO :dPrice, :sTuncu
     FROM "DANMST" B 
    WHERE B.ITNBR	   = :sItem 
	 	AND B.OPSEQ    = :SOPSEQ
	 	AND B.CVCOD 	= :sCode ; 

/* 계약된 거래처가 아닌 경우에도 입력 가능하도록 함 */
//	IF sqlca.sqlcode <> 0 	THEN
//		F_MESSAGE_CHK(303, '[단가 내역]')
//		this.setitem(lRow, "unprc", 0)
//		this.setitem(lrow, "tuncu", 'WON')
//		RETURN 1
//   END IF	
	
	this.setitem(lRow, "cnvprc", DPRICE)
	this.setitem(lrow, "tuncu", stuncu)
	
	// 발주예정단가 변환
	if dw_list.getitemdecimal(lrow, "cnvfat") = 1   then
		dw_list.setitem(lrow, "unprc", dprice)
	elseif dw_list.getitemstring(Lrow, "cnvart") = '/' then
		dw_list.setitem(Lrow, "unprc", round(dprice / dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	else
		dw_list.setitem(Lrow, "unprc", round(dprice * dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	end if	

// 의뢰담당자 
ELSEIF this.GetColumnName() = "rempno" THEN

	sCode = this.GetText()
	SELECT EMPNAME
	  INTO :sName
	  FROM P1_MASTER
	 WHERE EMPNO = :sCode	AND
	 		 SERVICEKINDCODE <> '3'	;
	IF sqlca.sqlcode = 100 	THEN
		this.triggerevent(RbuttonDown!)
	   return 1
	ELSE
		this.setitem(lRow, 'p1_master_empname', sName)
   END IF
// 수주번호
ELSEIF this.GetColumnName() = "order_no" THEN

	sCode = this.GetText()
	
	IF scode = '' or isnull(scode) then return 

  SELECT "SORDER"."SABU"  
    INTO :sName  
    FROM "SORDER"  
   WHERE ( "SORDER"."SABU" = :gs_sabu ) AND  
         ( "SORDER"."ORDER_NO" = :sCode )   ; 
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[수주번호]')
		this.setitem(lRow, "order_no", sNull)	
		RETURN 1
	END IF

// 구매요구량 > 발주예정량 이면 ERROR
ELSEIF this.GetColumnName() = "vnqty" THEN

	dBalQty = dec(this.GetText())
	dQty = this.GetItemDecimal(lRow, "guqty")
	IF dQty > dBalQty		THEN
		MessageBox("확인", "발주예정량은 구매요구량보다 커야합니다.")
		RETURN 1
	END IF
	
// 납기요구일
ELSEIF this.GetColumnName() = 'yodat' THEN

	sDate  = TRIM(this.gettext())

	IF sdate = '' or isnull(sdate) then return 

	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "yodat", sNull)
		return 1
	END IF

// 단가
elseif this.getcolumnname() = 'unprc' then
	dprice = dec(this.gettext())
	// 발주예정단가 변환
	if dw_list.getitemdecimal(lrow, "cnvfat") = 1   then
		dw_list.setitem(lrow, "cnvprc", dprice)
	elseif dw_list.getitemstring(Lrow, "cnvart") = '/' then
		dw_list.setitem(Lrow, "cnvprc", round(dprice * dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	else
		dw_list.setitem(Lrow, "cnvprc", round(dprice / dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	end if		
ELSEIF this.GetColumnName() = 'kumno' then
	 
	sCode = this.GetText()
	
	if isnull(scode) or scode = '' then 
		this.setitem(lRow, 'kummst_kumname', sNull)
      return 
	end if
	
  SELECT "KUMMST"."KUMNAME"  
    INTO :sname
    FROM "KUMMST"  
   WHERE ( "KUMMST"."SABU" =  :gs_sabu) AND  
         ( "KUMMST"."KUMNO" = :scode )   ;
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[금형/치공구 번호]')
		this.setitem(lRow, 'kumno', sNull)
		this.setitem(lRow, 'kummst_kumname', sNull)
		RETURN 1
	else
		this.setitem(lRow, 'kummst_kumname', sName)
	END IF
ELSEIF this.GetColumnName() = 'mchno' then
	sCode = this.GetText()
	
	if isnull(scode) or scode = '' then 
		this.setitem(lRow, 'mchmst_mchnam', sNull)
      return 
	end if
	
  SELECT MCHNAM  
    INTO :sname
    FROM MCHMST  
   WHERE SABU  = :gs_sabu AND  
         MCHNO = :scode    ;
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[설비 번호]')
		this.setitem(lRow, 'mchno', sNull)
		this.setitem(lRow, 'mchmst_mchnam', sNull)
		RETURN 1
	else
		this.setitem(lRow, 'mchmst_mchnam', sName)
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
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	
	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
// 거래처
ELSEIF this.GetColumnName() = 'cvcod'	THEN
	w_mdi_frame.sle_msg.text = '일반 거래처 조회는 F2 KEY 를 누르세요!'
	
	gs_code 		= getitemstring(lrow, "itnbr")
	gs_codename = getitemstring(lrow, "opseq")

	Open(w_danmst_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(lRow,"cvcod",gs_code)
	SetItem(lRow,"unprc",Dec(gs_codename))
	
	setnull(gs_code)
	setnull(gs_codename)

	this.TriggerEvent("itemchanged")
	
// 의뢰담당자
elseIF this.GetColumnName() = 'rempno'	THEN

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(lRow,"rempno",gs_code)
	SetItem(lRow,"p1_master_empname",gs_codename)

// 수주번호
ELSEIF this.GetColumnName() = 'order_no'	THEN

	Open(w_suju_popup)

	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"order_no",gs_code)

// 금형/치공구 번호
ELSEIF this.GetColumnName() = 'kumno' then
	 
	 open(w_imt_04630_popup)
	 
	 if gs_code = '' or isnull(gs_code) then return
	 
	 SetItem(lRow, "kumno",gs_code)
	 SetItem(lRow, "kummst_kumname", gs_codename)

ELSEIF this.GetColumnName() = 'mchno' then
	 
	 open(w_mchmst_popup)
	 
	 if gs_code = '' or isnull(gs_code) then return
	  
	 SetItem(lRow, "mchno", gs_code )
	 SetItem(lRow, "mchmst_mchnam", gs_codename)


END IF




end event

event doubleclicked;Long Lrow

Lrow = getrow()

if Lrow <  1 then return

gs_code 		= getitemstring(Lrow, "itnbr")
gs_codename = getitemstring(Lrow, "itemas_itdsc")

if isnull(gs_code) or trim(gs_code) = '' or isnull(gs_codename) or trim(gs_codename) = '' then
	return
end if


open(w_pdt_04000_1)

setnull(gs_code)
setnull(gs_codename)
end event

event getfocus;w_mdi_frame.sle_msg.text = '재고에 대한 상세정보는 Doublic Click을 하십시요'
end event

event rowfocuschanged;w_mdi_frame.sle_msg.text = '재고에 대한 상세정보는 Doublic Click을 하십시요'
end event

type rr_1 from roundrectangle within w_pdt_04006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3429
integer y = 76
integer width = 293
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_04006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 444
integer width = 4581
integer height = 1792
integer cornerheight = 40
integer cornerwidth = 55
end type

