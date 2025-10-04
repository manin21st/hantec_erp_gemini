$PBExportHeader$w_sal_02047.srw
$PBExportComments$출고등록(미수주)
forward
global type w_sal_02047 from w_inherite
end type
type gb_2 from groupbox within w_sal_02047
end type
type rb_1 from radiobutton within w_sal_02047
end type
type rb_2 from radiobutton within w_sal_02047
end type
type dw_cond from u_key_enter within w_sal_02047
end type
type dw_list from u_d_popup_sort within w_sal_02047
end type
type dw_hidden from datawindow within w_sal_02047
end type
type p_1 from uo_picture within w_sal_02047
end type
type pb_1 from u_pb_cal within w_sal_02047
end type
type p_3 from picture within w_sal_02047
end type
type dw_autoimhist from datawindow within w_sal_02047
end type
type cbx_move from checkbox within w_sal_02047
end type
type rr_1 from roundrectangle within w_sal_02047
end type
end forward

global type w_sal_02047 from w_inherite
integer width = 4681
integer height = 2668
string title = "외주사급출고(유상사급)"
gb_2 gb_2
rb_1 rb_1
rb_2 rb_2
dw_cond dw_cond
dw_list dw_list
dw_hidden dw_hidden
p_1 p_1
pb_1 pb_1
p_3 p_3
dw_autoimhist dw_autoimhist
cbx_move cbx_move
rr_1 rr_1
end type
global w_sal_02047 w_sal_02047

type variables
String 	LsIoJpNo,LsSuBulDate
string  sCursor
end variables

forward prototypes
public function integer wf_clear_item (integer nrow)
public subroutine wf_init ()
public function integer wf_requiredchk (integer option)
public function integer wf_add_imhist ()
public function integer wf_create_imhist ()
public function integer wf_calc_danga (integer nrow, string itnbr, string pspec)
public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date)
end prototypes

public function integer wf_clear_item (integer nrow);String sNull

SetNull(snull)

dw_insert.SetItem(nRow,"itnbr",snull)
dw_insert.SetItem(nRow,"itemas_itdsc",snull)
dw_insert.SetItem(nRow,"itemas_ispec",snull)
dw_insert.SetItem(nRow,"ioprc",      0)
dw_insert.SetItem(nRow,"ioreqty",    0)
dw_insert.SetItem(nRow,"ioqty",      0)
dw_insert.SetItem(nRow,"ioamt",      0)

Return 0

end function

public subroutine wf_init ();rollback;

dw_cond.enabled = true

SetNull(Lsiojpno)

dw_list.Reset()   // 출력물 

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

dw_insert.Reset()
dw_autoimhist.Reset()

String siogbn, ssalegu, samtgu, sdepot

IF sModStatus = 'I' THEN
	p_1.Visible = True
	p_print.Enabled = False
	p_print.PictureName = "C:\erpman\image\인쇄_d.gif"

	dw_cond.Modify('iojpno.protect = 1')
	dw_cond.Modify('iojpno_img.visible = 0')
	dw_cond.Modify('iogbn.protect = 0')
	dw_cond.Modify('cvcod.protect = 0')
	dw_cond.Modify('vndname.protect = 0')
	dw_cond.Modify('pjt_cd.protect = 0')
//	dw_cond.Modify('saupj.protect = 0')
	dw_cond.Modify('sudat.protect = 0')
//	dw_cond.Modify('io_empno.protect = 0')
	dw_cond.Modify('depot_no.protect = 0')
	
	siogbn = dw_cond.getitemstring(1, "iogbn")
	Select salegu,amtgu into :ssalegu, :samtgu from iomatrix where iogbn = :siogbn;
	If ssalegu = 'Y' then
		dw_cond.object.t_gbn.text = "유상"
		dw_insert.Modify('ioprc.protect = 0')
		dw_insert.Modify('ioamt.protect = 0')
		IF samtgu = 'Y' then
			dw_insert.Modify('ioreqty.protect = 1')
			dw_insert.Modify('ioprc.protect = 1')
		Else
			dw_insert.Modify('ioreqty.protect = 0')
			dw_insert.Modify('ioprc.protect = 0')			
		End if
	Else
		dw_cond.object.t_gbn.text = "무상"
		dw_insert.Modify('ioprc.protect = 1')		
		dw_insert.Modify('ioamt.protect = 1')			
	End if

//	dw_cond.SetItem(1, 'sudat', is_today)
	dw_cond.SetRow(1)
	dw_cond.SetFocus()
	dw_cond.SetColumn("sudat")
ELSE
	p_1.Visible = False
	
	p_print.Enabled = True
   p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	dw_cond.Modify('iojpno.protect = 0')
	dw_cond.Modify('iojpno_img.visible = 1')
	dw_cond.Modify('iogbn.protect = 1')
	dw_cond.Modify('sudat.protect = 1')
	dw_cond.Modify('cvcod.protect = 1')
	dw_cond.Modify('vndname.protect = 1')
//	dw_cond.Modify('io_empno.protect = 1')
	dw_cond.Modify('depot_no.protect = 1')
	dw_cond.Modify('pjt_cd.protect = 1')
	
	siogbn = dw_cond.getitemstring(1, "iogbn")
	Select salegu,amtgu into :ssalegu, :samtgu from iomatrix where iogbn = :siogbn;
	If ssalegu = 'Y' then
		dw_cond.object.t_gbn.text = "유상"
		dw_insert.Modify('ioprc.protect = 0')
		dw_insert.Modify('ioamt.protect = 0')
		IF samtgu = 'Y' then
			dw_insert.Modify('ioreqty.protect = 1')
			dw_insert.Modify('ioprc.protect = 1')
		Else
			dw_insert.Modify('ioreqty.protect = 0')
			dw_insert.Modify('ioprc.protect = 0')			
		End if
	Else
		dw_cond.object.t_gbn.text = "무상"
		dw_insert.Modify('ioprc.protect = 1')		
		dw_insert.Modify('ioamt.protect = 1')			
	End if
		
   dw_cond.SetFocus()
   dw_cond.SetRow(1)
	dw_cond.SetColumn("iojpno")
END IF

// 부가세 사업장 설정 - 통제 해제(통합사업장 관련 사업장 선택가능) - BY SHINGOON 2016.02.26
//f_mod_saupj(dw_cond, 'saupj')
String  ls_saupj
ls_saupj = dw_cond.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	ls_saupj = gs_saupj
	dw_cond.SetItem(1, 'saupj', ls_saupj)
End If
f_child_saupj(dw_cond, 'depot_no', ls_saupj)
//f_child_saupj(dw_cond, 'depot_no', gs_saupj)
//f_child_saupj(dw_cond, 'iogbn', gs_saupj)

// 창고
select cvcod into :sdepot  from vndmst    where cvgu = '5' and jumaechul = '1'  and ipjogun = :gs_saupj and rownum = 1 ;
dw_cond.SetItem(1, 'depot_no', sdepot)


ib_any_typing = False

DataWindowChild state_child
integer rtncode

//제품 출고 담당자
rtncode 	= dw_cond.GetChild('io_empno', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 제품 출고 담당자")
state_child.SetTransObject(SQLCA)
//state_child.Retrieve('26',gs_saupj)
state_child.Retrieve('26',ls_saupj)
end subroutine

public function integer wf_requiredchk (integer option);String sIoCust, sSaupj, sIo_empno, sDepot_no

If dw_cond.AcceptText() <> 1 Then Return -1

LsIoJpNo    	= Left(dw_cond.GetItemString(1,"iojpno"),12)
LsSuBulDate = Trim(dw_cond.GetItemString(1,"sudat"))
sIoCust     	= Trim(dw_cond.GetItemString(1,"cvcod"))
sSaupj	   	= Trim(dw_cond.GetItemString(1,"saupj"))
sIo_empno   	= Trim(dw_cond.GetItemString(1,"io_empno"))
sDepot_no   	= Trim(dw_cond.GetItemString(1,"depot_no"))

IF Option = 1 And ( sSaupj = "" OR IsNull(sSaupj) ) THEN
	f_message_chk(30,'[부가사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF
	 
//IF Option = 1 And ( sIo_empno = "" OR IsNull(sIo_empno) ) THEN
//	f_message_chk(30,'[출고담당자]')
//	dw_cond.SetColumn("io_empno")
//	dw_cond.SetFocus()
//	Return -1
//END IF
	 
IF Option = 1 And ( sDepot_no = "" OR IsNull(sDepot_no) ) THEN
	f_message_chk(30,'[출고창고]')
	dw_cond.SetColumn("depot_no")
	dw_cond.SetFocus()
	Return -1
END IF

	 
/* detail check */
If 	Option = 2 Then
	string sIogbn, sItnbr, sItdsc, sIspec, sPspec
	Double dIoreqty
	Long   nCnt,ix
	
	nCnt = dw_insert.RowCount()
	If nCnt <=0 Then Return 1
	
	For ix = 1 To nCnt
		sIogbn 	= dw_insert.GetItemString(ix,'iogbn')
		sItnbr 		= dw_insert.GetItemString(ix,'itnbr')
		sItdsc 	= dw_insert.GetItemString(ix,'itemas_itdsc')
		sIspec 	= dw_insert.GetItemString(ix,'itemas_ispec')
		sPspec 	= dw_insert.GetItemString(ix,'pspec')
		dIoreqty 	= dw_insert.GetItemNumber(ix,'ioreqty')
		
	   IF	sIogbn = "" OR IsNull(sIogbn) THEN
		  	f_message_chk(30,'[출고구분]')
		  	dw_insert.SetRow(ix)
		  	dw_insert.SetColumn("iogbn")
		  	dw_insert.SetFocus()
		  	Return -1
	   END IF
	   IF 	sItnbr = "" OR IsNull(sItnbr) THEN
		  	f_message_chk(30,'[품번]')
		  	dw_insert.SetRow(ix)
		  	dw_insert.SetColumn("itnbr")
		  	dw_insert.SetFocus()
		  	Return -1
	   END IF
	   IF dIoreqty = 0  OR IsNull(dIoreqty) THEN
		  	f_message_chk(1402,'[삭제 처리]')
		  	dw_insert.SetRow(ix)
		  	dw_insert.SetColumn("itnbr")
		  	dw_insert.SetFocus()
		  	Return -1
	   END IF
	Next	
	Return 1
Else
/* 송장 수정*/
  IF 	sModStatus = 'C' THEN
	 	IF 	LsIoJpNo = "" OR IsNull(LsIoJpNo) THEN
			f_message_chk(30,'[송장번호]')
			dw_cond.SetColumn("iojpno")
			dw_cond.SetFocus()
			Return -1
		END IF
/* 신규 송장*/
	ELSEIF sModStatus = 'I' THEN
		IF 	sIoCust = "" OR IsNull(sIoCust) THEN
			f_message_chk(30,'[거래처]')
			dw_cond.SetColumn("cvcod")
			dw_cond.SetFocus()
			Return -1
		END IF
		
		IF 	LsSuBulDate = "" OR IsNull(LsSuBulDate) THEN
			f_message_chk(30,'[발행일자]')
			dw_cond.SetColumn("sudat")
			dw_cond.SetFocus()
			Return -1
		END IF
	END IF
	
	Return 1
End If

end function

public function integer wf_add_imhist ();/* -------------------------------- */
/* 송장에 추가할 경우 사용          */
/* -------------------------------- */
Long  nRcnt,iMaxIoSeq,k,nCnt
String siogbn, samtgu

nRcnt = dw_insert.RowCount()
IF nRcnt <=0 THEN
	f_message_chk(36,'')
	Return -1
END IF

IF MessageBox("확 인","송장 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

iMaxIoSeq = Long(dw_insert.GetItemSTring(1,'maxseq'))
If IsNull(iMaxIoSeq) Then iMaxIoSeq = 0

////////////////////////////////////////////////////////////////////////
string	sCvcod, sNappum, sAuto, sDepot_no, sNull
SetNull(sNull)

sCvcod = dw_cond.GetItemString(1,"cvcod")
sdepot_no = dw_cond.GetItemString(1,"depot_no")

SELECT NVL(GUMGU,'N')
  INTO :sNappum
  FROM VNDMST
 WHERE CVCOD = :sCvcod ;
  
SELECT NVL(email, 'N')
  INTO :sauto
  FROM VNDMST
 WHERE CVCOD = :sdepot_no ; 

String ls_jnpcrt
siogbn = dw_cond.getitemstring(1, "iogbn")
select amtgu, jnpcrt into :samtgu, :ls_jnpcrt from iomatrix where iogbn = :sIogbn;

For k = 1 TO nRcnt
	If dw_insert.GetItemStatus(k, 0, Primary!) = NewModified! Then 
	  iMaxIoseq += 1
	  dw_insert.SetItem(k,"sabu",       gs_sabu)
	  dw_insert.SetItem(k,"iojpno",     LsIoJpNo+String(iMaxIoSeq,'000'))
	  dw_insert.SetItem(k,"sudat",      LsSuBulDate)

	  dw_insert.SetItem(k,"cvcod",	   dw_cond.GetItemString(1,"cvcod"))
	  dw_insert.SetItem(k,"sarea",	   dw_cond.GetItemString(1,"cust_area"))
	  dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,'ioreqty'))
	  dw_insert.SetItem(k,"iosuqty",    dw_insert.GetItemNumber(k,'ioreqty'))
	  dw_insert.SetItem(k,"pjt_cd",	   dw_cond.GetItemString(1,"pjt_cd")) /* 프로젝트 */
	  
	  dw_insert.setitem(k,"insdat", LsSuBulDate)
	  dw_insert.SetItem(k,"io_confirm", 'Y')
	  dw_insert.SetItem(k,"io_date",    LsSuBulDate)
	  dw_insert.SetItem(k,"filsk",   	'Y') /* 재고관리구분 */
	  dw_insert.SetItem(k,"inpcnf",	   'O') /* 입출고 구분 */
	  dw_insert.SetItem(k,"jnpcrt",     ls_jnpcrt) /* 전표생성구분 */
	  dw_insert.SetItem(k,"opseq",      '9999')
	  dw_insert.SetItem(k,"outchk",     'N')
  	  dw_insert.SetItem(k,"depot_no",    dw_cond.GetItemString(1, "depot_no"))
//	  dw_insert.SetItem(k,"io_empno",    dw_cond.GetItemString(1, "io_empno"))

		dw_insert.SetItem(k,"io_empno",    gs_empno)
		dw_insert.SetItem(k,"itgu",    '5')
		dw_insert.SetItem(k,"yebi2",    'WON')
		dw_insert.SetItem(k,"yebi3",    '6')		// 고객구분(6) 일반시판
		dw_insert.SetItem(k,"dyebi1",    1)
		dw_insert.SetItem(k,"dyebi2",    dw_insert.GetItemNumber(k,'ioprc'))
		dw_insert.SetItem(k,"facgbn",    'Z1')		// 공장구분
		dw_insert.SetItem(k,"gungbn",    'D')		// 주야구분	
	
		dw_insert.SetItem(k,"io_confirm", 'Y')
		dw_insert.SetItem(k, "yebi1",   LsSuBulDate)
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 이전자료가 울산에서 처리된자료로 되어있기 때문에 항목을 추가한경우는 처리되지 않음		 */
		/* ---------------------------------------------------- */		
//		If cbx_move.Checked = True Then
//			String ls_autojpno
//			ls_autojpno = wf_automove(k, dw_insert, LsSuBulDate)
//			If ls_autojpno <> '-1' Then
//				dw_insert.SetItem(k, "ip_jpno",	  ls_autojpno)
//			End If
//		End If		
	
	  nCnt += 1
	Else
		dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,'ioreqty'))
				
		// 수불일자 변경 요청으로 저장 시 일자 재 세팅 추가 by shjeon 20130401
	   dw_insert.SetItem(k,"sudat",      LsSuBulDate)
	   dw_insert.setitem(k,"insdat",     LsSuBulDate)
	   dw_insert.SetItem(k,"io_date",    LsSuBulDate)
		dw_insert.SetItem(k,"yebi1",      LsSuBulDate)
		
		String ls_ipjpno
		
		Int li_row, li_i
		Double ld_qty
		
		ls_ipjpno = dw_insert.GetItemString(k, 'ip_jpno')
		ld_qty = dw_insert.GetItemNumber(k, 'ioreqty')
		
		IF IsNull(ls_ipjpno) = False Then
			String ls_IM2jpno
			
			SELECT IP_JPNO
			INTO :ls_IM2jpno
			FROM IMHIST
			WHERE IOGBN = 'IM7'
				AND IOJPNO = :ls_ipjpno;
			
			UPDATE IMHIST
				SET IOQTY = :ld_qty,
						IOREQTY = :ld_qty,
						IOSUQTY = :ld_qty,
						SUDAT = :LsSuBulDate,
						INSDAT = :LsSuBulDate,
						IO_DATE = :LsSuBulDate
			WHERE IOGBN = 'IM7' 
				AND IOJPNO = :ls_ipjpno;
				
			UPDATE IMHIST		 
				SET IOQTY = :ld_qty,
						IOREQTY = :ld_qty,
						IOSUQTY = :ld_qty,
						SUDAT = :LsSuBulDate,
						INSDAT = :LsSuBulDate,
						IO_DATE = :LsSuBulDate 
			WHERE IOGBN = 'OM7' 
				AND IOJPNO = :ls_IM2jpno;
		End If	
   End If
Next

IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

COMMIT;

Return nCnt
end function

public function integer wf_create_imhist ();/* -------------------------------- */
/* 신규로 송장을 등록할 경우 사용   */
/* -------------------------------- */
Long    nRcnt,iMaxIoNo,k
String  sIoJpGbn, sNull, siogbn, samtgu

SetNull(sNull)

nRcnt = dw_insert.RowCount()
IF nRcnt <=0 THEN
	f_message_chk(83,'')
	Return -1
END IF

IF MessageBox("확 인","송장을 발행 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

/*송장번호 채번*/
sIoJpGbn = 'C0'
iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate,sIoJpGbn)
IF iMaxIoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
commit;

LsIoJpNo = LsSuBulDate + String(iMaxIoNo,'0000')

dw_cond.SetItem(1,"iojpno",LsIoJpNo)
MessageBox("확 인","채번된 출고번호는 "+LsIoJpNo+" 번 입니다!!")

///////////////////////////////////////////////////////////////////////////////
string	sCvcod, sNappum, sDepot_no, sAuto

sCvcod = dw_cond.GetItemString(1,"cvcod")
sdepot_no = dw_cond.GetItemString(1,"depot_no")

SELECT NVL(GUMGU,'N')
  INTO :sNappum
  FROM VNDMST
 WHERE CVCOD = :sCvcod ;
  
SELECT NVL(email, 'N')
  INTO :sauto
  FROM VNDMST
 WHERE CVCOD = :sdepot_no ; 
 
siogbn = dw_cond.getitemstring(1, "iogbn")
select amtgu into :samtgu from iomatrix where iogbn = :sIogbn;
 
////////////////////////////////////////////////////////////////////////////////

For k = 1 TO nRcnt
	dw_insert.SetItem(k,"sabu",       gs_sabu)
	dw_insert.SetItem(k,"saupj",	    dw_cond.GetItemString(1,"saupj"))
	dw_insert.SetItem(k,"iojpno",     LsIoJpNo+String(k,'000'))
	dw_insert.SetItem(k,"sudat",      LsSuBulDate)
	
	dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,'ioreqty'))
	dw_insert.SetItem(k,"iosuqty",      dw_insert.GetItemNumber(k,'ioreqty'))
	dw_insert.SetItem(k,"cvcod",	    dw_cond.GetItemString(1,"cvcod"))
	dw_insert.SetItem(k,"sarea",	    dw_cond.GetItemString(1,"cust_area"))
   dw_insert.SetItem(k,"pjt_cd",	    dw_cond.GetItemString(1,"pjt_cd")) /* 프로젝트 */
	
	dw_insert.setitem(k,"insdat", Lssubuldate)
	dw_insert.SetItem(k,"io_confirm", 'Y') 
	dw_insert.SetItem(k,"io_date",    LsSuBulDate) 
	dw_insert.SetItem(k,"filsk",   	 'Y') /* 재고관리구분 */
	dw_insert.SetItem(k,"inpcnf",	    'O') /* 입출고 구분 */
	dw_insert.SetItem(k,"jnpcrt",     '037') /* 전표생성구분 */
	dw_insert.SetItem(k,"opseq",      '9999')
	dw_insert.SetItem(k,"outchk",      'N')
	dw_insert.SetItem(k,"depot_no",    dw_cond.GetItemString(1, "depot_no"))
	
	//dw_insert.SetItem(k,"io_empno",    dw_cond.GetItemString(1, "io_empno"))
	dw_insert.SetItem(k,"io_empno",    gs_empno)
	dw_insert.SetItem(k,"itgu",    '5')
	dw_insert.SetItem(k,"yebi2",    'WON')
	dw_insert.SetItem(k,"yebi3",    '6')		// 고객구분(6) 일반시판
	dw_insert.SetItem(k,"dyebi1",    1)
	dw_insert.SetItem(k,"dyebi2",    dw_insert.GetItemNumber(k,'ioprc'))
	dw_insert.SetItem(k,"facgbn",    'Z1')		// 공장구분
	dw_insert.SetItem(k,"gungbn",    'D')		// 주야구분	
	
	dw_insert.SetItem(k,"io_confirm", 'Y')
	dw_insert.SetItem(k,"yebi1",   LsSuBulDate)
		
	/* ----------------------------------------------------- */
	/* 울산이동출고 처리 2016.01.21 신동준 			 */
	/* 울산이동출고가 체크 되어있고 사업장이 장인일경우 실행 			 */
	/* ---------------------------------------------------- */		
//	If cbx_move.Checked = True And  dw_cond.GetItemString(1,"saupj") = '20' Then
	If cbx_move.Checked = True Then
		String ls_autojpno
		ls_autojpno = wf_automove(k, dw_insert, LsSuBulDate)
		If ls_autojpno <> '-1' Then
			dw_insert.SetItem(k, "ip_jpno",	  ls_autojpno)
		End If
	End If
Next

IF dw_autoimhist.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF


sqlca.ERP000000580(gs_sabu, LsIoJpNo)
IF sqlca.sqlcode <> 0 Then
	f_message_chk(32,'')
	ROLLBACK;
	Return -1
END IF

COMMIT;

Return nRcnt
end function

public function integer wf_calc_danga (integer nrow, string itnbr, string pspec);string sOrderDate, sCvcod
int    iRtnValue
double ditemprice,ddcrate,dItemqty

/* 판매단가및 할인율 */
sOrderDate = dw_cond.GetItemString(1,"sudat")
sCvcod = dw_cond.GetItemString(1,"cvcod")

iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu, sOrderDate, sCvcod, Itnbr, pspec,&
                                    'WON','1',dItemPrice,dDcRate) 
If IsNull(dItemPrice) Then dItemPrice = 0
If IsNull(dDcRate) Then dDcRate = 0

Choose Case iRtnValue
	Case is < 0 
		Wf_Clear_Item(nRow)
		f_message_chk(41,'[단가 계산]')
		Return 1
	Case Else
		dw_insert.SetItem(nRow,"ioprc", truncate(dItemPrice,3))
		
		/* 금액 계산 */
		dItemQty = dw_insert.GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		dw_insert.SetItem(nRow,"ioamt", ROUND(TrunCate(dItemQty * dItemPrice,0), 0))
End Choose
Return 0

end function

public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date);/*출고처리시 자동으로 장안에서 출고처리, 울산에서 입고처리 하기위한 함수, 입고 전표번호를 리턴한다.
   장안에서 일반출고할 행을 가져와서 자동출고 처리한다.
	arg_rownum : 복사할 행
	arg_imhistdw : 복사할 데이터 윈도우
	arg_date : 출고일자*/

If IsNull(arg_date) Or arg_date = '' Then
	MessageBox('확인', '출고일자를 확인해 주십시요. (automove)')
	Return '-1'
End If
	
String ls_chulStock, ls_chIogbn, ls_chIojpno //출고처리 변수
String ls_ipStock, ls_ipIogbn, ls_ipIojpno //입고처리 변수
Int li_seq, li_chRow, li_ipRow

String ls_cvgu, ls_ipjogun, ls_jumaechul, ls_juhandle, ls_soguan

ls_chulStock = arg_imhistdw.GetItemString(arg_rownum, 'depot_no')

SELECT CVGU, IPJOGUN, JUMAECHUL, JUHANDLE, SOGUAN
INTO :ls_cvgu, :ls_ipjogun, :ls_jumaechul, :ls_juhandle, :ls_soguan
FROM VNDMST
WHERE CVCOD = :ls_chulStock
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 1')
    Return '-1'
End If

//출고창고의 사업장이 울산일경우 울산이동출고처리 하지 않는다.
If ls_ipjogun = '10' Then
	Return '-1'
End If

SELECT CVCOD
INTO :ls_ipStock
FROM VNDMST
WHERE NVL(CVGU, '.') LIKE NVL(:ls_cvgu, '%')
    AND NVL(IPJOGUN, '.') = '10'
    AND NVL(JUMAECHUL, '.') LIKE NVL(:ls_jumaechul, '%')
    AND NVL(JUHANDLE, '.') LIKE NVL(:ls_juhandle, '%')
    AND NVL(SOGUAN, '.') LIKE NVL(:ls_soguan, '%')
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 2')
    Return '-1'
End If

//SELECT CVCOD
//INTO :ls_ipStock
//FROM VNDMST
//WHERE CVGU = '5'
//    AND IPJOGUN = '10'
//    AND JUMAECHUL = '2'    
//    AND JUHANDLE = '1'
//    AND SOGUAN = '1';
//	 
//IF SQLCA.SQLCODE <> 0 THEN
//	MessageBox('출고오류', '울산이동출고 창고조회 오류')
//	Return '-1'
//End If
	 
//ls_chulStock = 'Z07'	//장안 제품창고 (자동 출고창고)
//ls_ipStock = 'Z01' //울산 제품창고 (자동 입고창고)

//자동수불 이동입,출고 수불구분
ls_chIogbn = 'OM7'
ls_ipIogbn = 'IM7'

li_seq = SQLCA.FUN_JUNPYO(gs_sabu, arg_date, 'C0')
If li_seq < 0 Then
	RollBack;
	Return '-1'
End If
Commit;

String ls_pspec, ls_itnbr, ls_opseq, ls_ioreemp, ls_filsk, ls_itgu, ls_pjtcd
Double ld_ioqty

ls_pspec = trim(arg_imhistdw.GetItemString(arg_rownum, 'pspec'))
If ls_pspec = '' Or isnull(ls_pspec) Then ls_pspec = '.'

ls_itnbr = arg_imhistdw.GetItemString(arg_rownum, 'itnbr')
ld_ioqty = arg_imhistdw.GetItemNumber(arg_rownum, 'ioqty')
ls_opseq = arg_imhistdw.GetitemString(arg_rownum, 'opseq')
ls_ioreemp = arg_imhistdw.GetitemString(arg_rownum, 'ioreemp')
ls_filsk = arg_imhistdw.GetitemString(arg_rownum, 'filsk')
ls_itgu = arg_imhistdw.GetitemString(arg_rownum, 'itgu')
ls_pjtcd = arg_imhistdw.GetitemString(arg_rownum, 'pjt_cd')

//앞의 자료를 울산출고 자료로 만들어 준다.
arg_imhistdw.SetItem(arg_rownum, 'saupj', '10')
arg_imhistdw.SetItem(arg_rownum, 'depot_no', ls_ipStock)

//자동출고 처리
li_chRow = dw_autoimhist.InsertRow(0)

ls_chIojpno = arg_date + String(li_seq, '0000') + String(li_chRow, '000')

dw_autoimhist.SetItem(li_chRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_chRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_chRow, 'inpcnf', 'O')		//입출고 구분
dw_autoimhist.SetItem(li_chRow, 'iojpno', ls_chIojpno)	
dw_autoimhist.SetItem(li_chRow, 'iogbn', ls_chIogbn)		//수불구분

dw_autoimhist.SetItem(li_chRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_chRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_chRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_chRow, 'depot_no', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_chRow, 'cvcod', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_chRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_chRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_chRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_chRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_chRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_chRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_chRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_chRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_chRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_chRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_chRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_chRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_chRow, 'bigo', '자동출고(울산이동)')

String ls_chSaupj
select ipjogun into :ls_chSaupj from vndmst where cvcod = :ls_chulStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_chRow, 'saupj', ls_chSaupj)

//자동입고 처리
li_ipRow = dw_autoimhist.InsertRow(0)

ls_ipIojpno = arg_date + String(li_seq, '0000') + String(li_ipRow, '000')

dw_autoimhist.SetItem(li_ipRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_ipRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_ipRow, 'inpcnf', 'O')		//입출고 구분
dw_autoimhist.SetItem(li_ipRow, 'iojpno', ls_ipIojpno)	
dw_autoimhist.SetItem(li_ipRow, 'iogbn', ls_ipIogbn)		//수불구분

dw_autoimhist.SetItem(li_ipRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_ipRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_ipRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_ipRow, 'depot_no', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_ipRow, 'cvcod', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_ipRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_ipRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_ipRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_ipRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_ipRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_ipRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_ipRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_ipRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_ipRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_ipRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_ipRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)

String ls_ipSaupj
select ipjogun into :ls_ipSaupj from vndmst where cvcod = :ls_ipStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_ipRow, 'saupj', ls_ipSaupj)

dw_autoimhist.SetItem(li_ipRow, 'ip_jpno', ls_chIojpno)
dw_autoimhist.SetItem(li_ipRow, 'bigo', '자동입고(울산이동)')

Return ls_ipIojpno
end function

on w_sal_02047.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.dw_hidden=create dw_hidden
this.p_1=create p_1
this.pb_1=create pb_1
this.p_3=create p_3
this.dw_autoimhist=create dw_autoimhist
this.cbx_move=create cbx_move
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_cond
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_hidden
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.p_3
this.Control[iCurrent+10]=this.dw_autoimhist
this.Control[iCurrent+11]=this.cbx_move
this.Control[iCurrent+12]=this.rr_1
end on

on w_sal_02047.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.dw_hidden)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.p_3)
destroy(this.dw_autoimhist)
destroy(this.cbx_move)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

f_child_saupj(dw_cond, 'depot_no', gs_saupj)

dw_insert.SetTransObject(SQLCA)
dw_autoimhist.SetTransObject(SQLCA)
/* 출고송장 발행 report */
dw_list.SetTransObject(SQLCA)

/* 품목입력시 커서위치 여부 - '1' : 품번, '2' : 품명 */
select substr(dataname,1,1) into :sCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;
		 
rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_02047
integer x = 32
integer y = 312
integer width = 4576
integer height = 2008
integer taborder = 20
string dataobject = "d_sal_02047_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;Return 1
end event

event dw_insert::ue_key;str_itnct 	str_sitnct
string 		snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF


if 	key = keyenter! then
	if 	this.getcolumnname() = "dyebi3" then
		if 	this.rowcount() <> this.getrow() then  return
		if 	this.accepttext() = 1 then
			this.Insertrow( 0 )
		else
			p_ins.triggerevent(clicked!)
//			post function wf_focus1()
		end if
		dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")
	end if
end if



end event

event dw_insert::itemchanged;String  	sMsgParm[7] = {'품목마스타','일일환율','특정제품 할인율','거래처 할인율','정책 할인율','판매단가 없음','단가 = 0'}

String 		sItem,sItemDsc,sItemSize,sItemUnit,sOrderDate,sSpecialYn,sItemGbn,sOrderSpec,&
			sSuJuDate,snull, sItgu, spspec, ls_saupj
Double  	dItemQty,dItemPrice,dDcRate,dValidQty,dNewDcRate,dItemWonPrc,dHoldQty
Integer 	nRow,iRtnValue,iRowCount
Dec      ljegoqty
String  	sOverSea,sDepotNo,sColNm, ls_jijil, sdepot_no

sdepot_no = dw_cond.GetItemString(1, "depot_no")

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow   	= GetRow()
sColNm 	= GetColumnName() 

Choose Case sColNm
	Case	"itnbr" 
		sItem 		= this.GetText()
		IF 	sItem 	="" OR IsNull(sItem) THEN
		  	Wf_Clear_Item(nRow)
		  	Return
		END IF
		
		SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",	"ITEMAS"."ITGU",	
				 "ITEMAS"."ITTYP",	"ITEMAS"."JIJIL",   fun_get_porgu("ITEMAS"."SABU", "ITEMAS"."ITNBR" )
		  INTO :sItemDsc,   		:sItemSize,   		  :sItemUnit,				:sItgu,
				 :sItemGbn,			:ls_jijil,				:ls_saupj
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItem AND
				 "ITEMAS"."USEYN" = '0' ;
		
		IF 	SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		END IF
	
		this.SetItem(nRow,"itemas_itdsc",   sItemDsc)
		this.SetItem(nRow,"itemas_ispec",   sItemSize)
		this.SetItem(nRow,"jijil",   ls_jijil)

		spspec = getitemstring(nRow, "pspec")
		
		Select Nvl(jego_qty, 0)
		  Into :ljegoqty
		  From stock
		 Where depot_no  = :sdepot_no
		   and itnbr     = :sItem
			and pspec     = :spspec
		 Using sqlca; 	
		 
		this.SetItem(nRow, "jego_qty", ljegoqty)
		wf_calc_danga(nrow, sitem, spspec)
	
	/* 품명 */
	Case "itemas_itdsc"
		sItemDsc = trim(this.GetText())	
		IF 	sItemDsc = ""	or	IsNull(sItemDsc)	THEN
		  	Wf_Clear_Item(nRow)
		END IF
	
		SELECT "ITEMAS"."ITNBR"
		  INTO :sItem
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITDSC" like :sItemDsc||'%' AND "ITEMAS"."GBWAN" = 'Y' ;
	
		IF 	SQLCA.SQLCODE = 0 THEN
			this.SetItem(nRow,"itnbr",sItem)
			this.SetColumn("itnbr")
			this.SetFocus()
			
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSEIF SQLCA.SQLCODE = 100 THEN
			Wf_Clear_Item(nRow)
			this.SetColumn("itemas_itdsc")
			Return 1
		ELSE
			Gs_CodeName = '품명'
			Gs_Code = sItemDsc
			Gs_gubun = '%'
			
			open(w_itemas_popup5)
			
			if Isnull(Gs_Code) OR Gs_Code = "" then 		return 1
			
			this.SetItem(nRow,"itnbr",Gs_Code)
			this.SetColumn("itnbr")
			this.SetFocus()
			
			this.TriggerEvent(ItemChanged!)
			Return 1
		END IF
	/* 규격 */
	Case "itemas_ispec"
		sItemSize = trim(this.GetText())	
		IF 	sItemSize = ""	or	IsNull(sItemSize)	THEN
		  	Wf_Clear_Item(nRow)
		  	this.SetColumn("itemas_ispec")
		  	Return
		End If
	
		SELECT "ITEMAS"."ITNBR"
		  INTO :sItem
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ISPEC" like :sItemSize||'%' AND "ITEMAS"."GBWAN" = 'Y' ;
			 
		IF 	SQLCA.SQLCODE = 0 THEN
			this.SetItem(nRow,"itnbr",sItem)
			this.SetColumn("itnbr")
			this.SetFocus()
			
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSEIF SQLCA.SQLCODE = 100 THEN
			Wf_Clear_Item(nRow)
			this.SetColumn("itemas_ispec")
			Return 1
		ELSE
			Gs_Code = sItemSize
			Gs_CodeName = '규격'
			Gs_gubun = '%'
			
			open(w_itemas_popup5)
			
			if Isnull(Gs_Code) OR Gs_Code = "" then 			return 1
			
			this.SetItem(nRow,"itnbr",Gs_Code)
			this.SetColumn("itnbr")
			this.SetFocus()
			
			this.TriggerEvent(ItemChanged!)
			Return 1
		END IF
	Case 'pspec'
		sOrderSpec = Trim(this.GetText())
		IF 	sOrderSpec = "" OR IsNull(sOrderSpec) THEN
			this.SetItem(nRow,"pspec",'.')
			Return 1
		END IF
		
		sItem = getitemstring(nRow, "itnbr")
		
		Select Nvl(jego_qty, 0)
		  Into :ljegoqty
		  From stock
		 Where depot_no  = :sdepot_no
		   and itnbr     = :sItem
			and pspec     = :sOrderSpec
		 Using sqlca; 	
		 
		this.SetItem(nRow, "jego_qty", ljegoqty)
		wf_calc_danga(nrow, sitem, sorderspec)		
	/* 수량 */
	Case "ioreqty"
		dItemQty = Double(this.GetText())
		IF dItemQty = 0 OR IsNull(dItemQty) THEN 
			SetItem(nRow,"ioqty", 0)
			SetItem(nRow,"ioamt", 0)
			SetItem(nRow,"dyebi3",0)
			SetItem(nRow,"ioprc",0)	
			Return
		End if
	
		dItemPrice = this.GetItemNumber(nRow,"ioprc")
		IF dItemPrice = 0 Or IsNull(dItemPrice) THEN Return
		dItemWonPrc  = dItemQty * dItemPrice
//		dItemWonPrc  =	round(dItemWonPrc,0)	
		dItemWonPrc  =	ROUND(Truncate(dItemWonPrc, 1), 0)		// 2007.04.20
		SetItem(nRow,"ioamt", ditemWonPrc)
		SetItem(nRow,"dyebi3", ROUND(TrunCate(dItemWonPrc * 0.1, 0), 0))	/* 부가세 */
		
		SetItem(nRow,"iosuqty", dItemQty)
		SetItem(nRow,"ioqty",   dItemQty)
	/* 단가 */
	Case "ioprc"
		dItemPrice = Double(this.GetText())
		If dItemPrice = 0 Or IsNull(dItemPrice) Then 
			SetItem(nRow,"ioamt", 0)
 			SetItem(nRow,"dyebi3",0)
			Return
		End if
	
		/* 금액 계산 */
		dItemQty = this.GetItemNumber(nRow,"ioreqty")
		IF 	IsNull(dItemQty) THEN Return
		
		dItemWonPrc  = 	dItemQty * dItemPrice
//		dItemWonPrc  =	round(dItemWonPrc,0)
		dItemWonPrc  =	ROUND(Truncate(dItemWonPrc, 1), 0)		// 2007.04.20
		SetItem(nRow,"ioamt", ditemWonPrc)
		SetItem(nRow,"dyebi3", ROUND(TrunCate(dItemWonPrc * 0.1, 0), 0))	/* 부가세 */
		SetItem(nRow,"dyebi2", dItemPrice)
	/* 금액 */
	Case "ioamt"
		dItemPrice = Double(this.GetText())
		If 	dItemPrice = 0 Or IsNull(dItemPrice) Then Return
			
		SetItem(nRow,"dyebi3", ROUND(TrunCate(dItemPrice * 0.1, 0), 0))	/* 부가세 */
END Choose

end event

event dw_insert::rbuttondown;Integer nRow
string  scolnm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

w_mdi_frame.sle_msg.text = ''

nRow     = GetRow()
If nRow <= 0 Then Return

sColNm   = GetColumnName()

Choose Case GetcolumnName() 
  Case "itnbr"
	 gs_gubun = '4'
	 Open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)	 
  Case "itemas_itdsc"
 	 gs_gubun = '4'
	 gs_codename = this.GetText()
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
  Case "itemas_ispec"
	 gs_gubun = '4'
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
END Choose

end event

event dw_insert::rowfocuschanged;If currentrow <= 0 Then return

If GetItemString(currentrow,'jnpcrt') = '037' Then
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
Else
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
End If

end event

event dw_insert::ue_pressenter;if this.getcolumnname() = "dyebi3" then
  if this.rowcount() = this.getrow() then
	  p_ins.postevent(clicked!)
	  return 1
  end if
end if
	
Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;//integer	nRow
//
//nRow   	= GetRow()
//
//Choose Case GetColumnName()
//	/* 부가세.. */
//	Case "dyebi3"
//		Choose Case GetItemStatus(nrow,0,Primary!)
////			Case NewModified!
////				p_ins.TriggerEvent(Clicked!)
//			Case DataModified!
//				p_ins.TriggerEvent(Clicked!)
//				dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")				
//		End Choose
//End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_02047
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_02047
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_02047
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_02047
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long nRow
String	ls_iogbn, ls_jnpcrt

IF Wf_RequiredChk(1) = -1 THEN RETURN -1
IF Wf_RequiredChk(2) = -1 THEN RETURN -1


nRow = dw_insert.InsertRow(0)
// 수불구분 입력
ls_iogbn	= dw_cond.getitemstring(1, "iogbn")
dw_insert.setitem(nRow, "iogbn", ls_iogbn)

SELECT     JNPCRT INTO :ls_jnpcrt	From IOMATRIX
   WHERE   iogbn = :ls_iogbn;

IF	SQLCA.sqlcode <> 0	then  ls_jnpcrt = '2'
	
if	ls_jnpcrt = ''   or  isNull(ls_jnpcrt)	then  ls_jnpcrt = '1'
	
dw_insert.setitem(nRow, "jnpcrt", ls_jnpcrt)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)

If	sCursor = '1' Then
  	dw_insert.SetColumn('itnbr')
Else
  	dw_insert.SetColumn('itemas_itdsc')
End If

dw_cond.enabled = false

end event

type p_exit from w_inherite`p_exit within w_sal_02047
end type

type p_can from w_inherite`p_can within w_sal_02047
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_02047
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_02047
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sIojpno, siogbn, ssalegu, samtgu
long lcnt

If dw_cond.AcceptText() <> 1 Then Return

IF Wf_RequiredChk(3) = -1 THEN RETURN

/*송장 수정*/
IF sModStatus = 'C' THEN
	
	sIojpno = dw_cond.getitemstring(1, "iojpno")
	lcnt = 0
	Select count(*) into :lcnt
	  from imhist
	 where sabu = :gs_sabu
	   and iojpno like :siojpno||'%'
		and yebi4 is not null;
		
	If lcnt > 0 then
		Messagebox("출고", "이미 매출 확정된 자료입니다", stopsign!)
		return
	End if
	
	IF dw_insert.Retrieve(gs_sabu,LsIoJpNo) <=0 THEN
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
	   dw_insert.SetFocus()
	END IF

//	dw_cond.Retrieve(gs_sabu,LsIoJpNo)
	
	siogbn = dw_cond.getitemstring(1, "iogbn")
	Select salegu,amtgu into :ssalegu, :samtgu from iomatrix where iogbn = :siogbn;
	If ssalegu = 'Y' then
		dw_cond.object.t_gbn.text = "유상"
		dw_insert.Modify('ioprc.protect = 0')
		dw_insert.Modify('ioamt.protect = 0')
		IF samtgu = 'Y' then
			dw_insert.Modify('ioreqty.protect = 1')
			dw_insert.Modify('ioprc.protect = 1')
		Else
			dw_insert.Modify('ioreqty.protect = 0')
			dw_insert.Modify('ioprc.protect = 0')			
		End if
	Else
		dw_cond.object.t_gbn.text = "무상"
		dw_insert.Modify('ioprc.protect = 1')		
		dw_insert.Modify('ioamt.protect = 1')			
	End if		
	
//	dw_cond.enabled = false
	ib_any_typing = false
END IF
end event

type p_del from w_inherite`p_del within w_sal_02047
end type

event p_del::clicked;call super::clicked;Long nRow, iCnt
String sSudat

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

/* 매출마감시 송장 발행 안함 */
sSudat = dw_cond.GetItemString(1, 'sudat')

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if


////////////////////////////////////////////////////////////////////////
string	sCheckno 
sCheckno = dw_insert.GetItemString(nRow, "checkno")

IF Not IsNull(sCheckno)		THEN
	MessageBox("삭제불가", "세금계산서가 발행된 자료입니다")
	RETURN
END IF


IF MessageBox("삭 제","출고송장 자료가 삭제됩니다." +"~n~n" +&
           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

////////////////////////////////////////////////////////////////////////

Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified!
		dw_insert.DeleteRow(nRow)
	Case Else
			/*울산이동출고자료 삭제 */
			/*2016.01.21 신동준*/
			/* 자동수불용 수불구분 변경(IM7, OM7) - BY SHINGOON 2016.02.26 */
			String ls_ipjpno
			ls_ipjpno = dw_insert.GetItemString(nRow, 'ip_jpno')
			IF IsNull(ls_ipjpno) = False Then
				String ls_IM7jpno
				
				SELECT IP_JPNO
				INTO :ls_IM7jpno
				FROM IMHIST
				WHERE IOGBN = 'IM7'
					AND IOJPNO = :ls_ipjpno;
				
				DELETE FROM IMHIST WHERE IOGBN = 'IM7' AND IOJPNO = :ls_ipjpno;
				DELETE FROM IMHIST WHERE IOGBN = 'OM7' AND IOJPNO = :ls_IM7jpno;
			End If
			
			IF SQLCA.SQLCODE <> 0 THEN
				f_message_chk(32,'[울산이동출고자료 삭제 오류]')
				ROLLBACK;
				Return -1
			END IF
		
		dw_insert.DeleteRow(nRow)
      If dw_insert.Update() <> 1 Then
        RollBack;
        Return
      End If
      Commit;
END CHOOSE

If dw_insert.RowCount() = 0 Then	p_can.TriggerEvent(Clicked!)
	
w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다.!!'
ib_any_typing = False
SetNull(Lsiojpno)
end event

type p_mod from w_inherite`p_mod within w_sal_02047
end type

event p_mod::clicked;call super::clicked;Int nRcnt, iCnt
String sSudat

IF Wf_RequiredChk(1) = -1 THEN RETURN -1
IF Wf_RequiredChk(2) = -1 THEN RETURN -1

/* 매출마감시 송장 발행 안함 */
sSudat = dw_cond.GetItemString(1, 'sudat')

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
	
IF rb_1.Checked = True THEN
	nRcnt = Wf_Create_Imhist()
ELSE
	nRcnt = Wf_Add_Imhist()
END IF

/* 송장처리 완료된 경우 발행 여부에 따라 출고송장을 출력한다 => 출력은 송장발행에서 */
If Not isNull(Lsiojpno) Or Lsiojpno >  '' Then
  IF MessageBox("확 인","출고송장을 출력하시겠습니까?",Question!,YesNo!,2) = 1 THEN 
     nRcnt = dw_list.Retrieve(gs_sabu, Lsiojpno, Lsiojpno, gs_saupj)
	
	  If nRcnt > 0 Then
	    dw_list.object.datawindow.print.preview="yes"
//	    gi_page = dw_list.GetItemNumber(1,"last_page")
	
	    OpenWithParm(w_print_options, dw_list)
     End If
  End If
END IF

wf_init()

w_mdi_frame.sle_msg.text = '자료를 처리하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_sal_02047
integer x = 4142
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_sal_02047
integer x = 3099
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_sal_02047
integer x = 3442
integer y = 5000
integer taborder = 40
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02047
integer x = 3447
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_02047
integer x = 3104
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sal_02047
integer x = 727
integer y = 2432
integer width = 439
boolean enabled = false
string text = "송장출력(&P)"
end type

event cb_print::clicked;call super::clicked;Long  iRowCount

If rb_2.Checked = False   Then Return
IF Wf_RequiredChk(1) = -1 THEN Return

IF MessageBox("확 인","출고송장을 출력하시겠습니까?",Question!,YesNo!) = 1 THEN 
//	MessageBox(lssubuldate,lsiojpno)
	iRowCount = dw_list.Retrieve(gs_sabu,LsSuBulDate,'%','%','%',Lsiojpno+'%')
	
	If iRowCount > 0 Then
	  dw_list.object.datawindow.print.preview="yes"
	  gi_page = dw_list.GetItemNumber(1,"last_page")
	
	  OpenWithParm(w_print_options, dw_list)
   End If
END IF

end event

type st_1 from w_inherite`st_1 within w_sal_02047
end type

type cb_can from w_inherite`cb_can within w_sal_02047
integer x = 3794
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_02047
integer x = 992
integer y = 2676
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02047
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02047
end type

type gb_2 from groupbox within w_sal_02047
integer x = 3584
integer y = 168
integer width = 1015
integer height = 124
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rb_1 from radiobutton within w_sal_02047
integer x = 3698
integer y = 208
integer width = 370
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "신규 송장"
boolean checked = true
end type

event clicked;sModStatus = 'I'

Wf_Init()





end event

type rb_2 from radiobutton within w_sal_02047
integer x = 4142
integer y = 208
integer width = 370
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "송장 수정"
end type

event clicked;sModStatus = 'C'

Wf_Init()
end event

type dw_cond from u_key_enter within w_sal_02047
event ue_key pbm_dwnkey
integer x = 9
integer y = 36
integer width = 2953
integer height = 248
integer taborder = 10
string dataobject = "d_sal_02047_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;
Return 1
end event

event itemchanged;String  sIoJpNo,sSuDate, sIoConFirm,snull, siogbn, ssalegu, samtgu
String  sProject_no,sOrderCust, sProject_prjnm
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1
String  ls_jpno, ls_saupj, ls_vnd, ls_sudat, ls_depot, ls_vndnm

DataWindowChild state_child
integer rtncode
			
Int     icnt
SetNull(snull)

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(dw_cond, 'depot_no', ssaupj)
		
		//제품 출고 담당자
		rtncode 	= dw_cond.GetChild('io_empno', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 제품 출고 담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('26',ssaupj)
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		/*SELECT DISTINCT "IMHIST"."IO_CONFIRM"   INTO :sIoconFirm  
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND ( substr("IMHIST"."IOJPNO",1,12) = :sIoJpNo||'%' ) AND
		 		 ( "IMHIST"."IOGBN" like 'OY%' );*/
		/* 장안사업장 자동수불 처리로 인해 자료 선택 추가 - BY SHINGOON 2016.02.27 */
			/*SELECT DISTINCT IO_CONFIRM INTO :sIoconFirm
			  FROM IMHIST
			 WHERE ( SABU = :gs_sabu ) AND ( IOJPNO LIKE :sIoJpNo||'%' ) AND ( TRIM(JNPCRT) = '037' ) ; */
		SELECT IOJPNO, SAUPJ, CVCOD, SUDAT, DEPOT_NO, FUN_GET_CVNAS(CVCOD)
		  INTO :ls_jpno, :ls_saupj, :ls_vnd, :ls_sudat, :ls_depot, :ls_vndnm
		  FROM (	SELECT DISTINCT SUBSTR(IOJPNO, 1, 12) IOJPNO, SAUPJ, CVCOD, SUDAT, DEPOT_NO
					  FROM IMHIST
					 WHERE SABU = :gs_sabu AND IOJPNO LIKE :sIoJpNo||'%' AND TRIM(JNPCRT) = '037'
					UNION ALL
					SELECT DISTINCT SUBSTR(C.IOJPNO, 1, 12) IOJPNO, A.SAUPJ, C.CVCOD, C.SUDAT, A.DEPOT_NO
					  FROM IMHIST A,
							 ( SELECT SABU, IOJPNO, IP_JPNO FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'IM7' ) B,
							 ( SELECT SABU, IP_JPNO, CVCOD, SUDAT, DEPOT_NO, SAUPJ, IOJPNO FROM IMHIST WHERE SABU = :gs_sabu AND JNPCRT = '037' ) C
					 WHERE A.SABU = :gs_sabu AND A.IOJPNO LIKE :sIoJpNo||'%' AND A.IOGBN = 'OM7'
						AND A.SABU = B.SABU AND A.IOJPNO = B.IP_JPNO
						AND B.SABU = C.SABU AND B.IOJPNO = C.IP_JPNO ) ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			This.SetItem(1, 'iojpno'  , ls_jpno )
			This.SetItem(1, 'saupj'   , ls_saupj)
			This.SetItem(1, 'cvcod'   , ls_vnd  )
			This.SetItem(1, 'sudat'   , ls_sudat)
			This.SetItem(1, 'depot_no', ls_depot)
			This.SetItem(1, 'vndname' , ls_vndnm)
			p_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[발행일자]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
		
		/* 매출마감시 송장 발행 안함 */
		SELECT COUNT(*)  INTO :icnt
		 FROM "JUNPYO_CLOSING"  
		WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
				( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
				( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudate,1,6) );
		
		If iCnt >= 1 then
			f_message_chk(60,'[매출마감]')
			Return 1
		End if
	
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndname",snull)
			Return
		END IF

		SELECT "CVNAS2" INTO :scvnas FROM "VNDMST" 
		 WHERE "CVCOD" = :sCvcod AND "CVSTATUS" = '0';
		
		IF SQLCA.SQLCODE <> 0 THEN
//		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"cust_area",   sarea)
			SetItem(1,"vndname",		 scvnas)
			
					
//			//제품 출고 담당자
//			rtncode 	= dw_cond.GetChild('io_empno', state_child)
//			IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 제품 출고 담당자")
//			state_child.SetTransObject(SQLCA)
//			state_child.Retrieve('26',ssaupj)
		END IF
	/* 거래처명 */
	Case "vndname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF

		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"cust_area",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"vndname", scvnas)
			
//			//제품 출고 담당자
//			rtncode 	= dw_cond.GetChild('io_empno', state_child)
//			IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 제품 출고 담당자")
//			state_child.SetTransObject(SQLCA)
//			state_child.Retrieve('26',ssaupj)
//			
//			Return 1
		END IF
	/* 프로젝트 */
	Case "project_no"
		sproject_no = Trim(GetText())
		IF sproject_no ="" OR IsNull(sproject_no) THEN
			this.SetItem(1,"prjnm",snull)
			Return
		END IF
		
		sOrderCust = GetItemString(1,'cvcod')
		SELECT "PROJECT"."PRJNM"  
		  INTO :sproject_prjnm  
		  FROM "PROJECT"  
		 WHERE ( "PROJECT"."PRJNO" = :sproject_no ) AND
				 ( "PROJECT"."CUST_NO" = :sOrderCust )   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			This.TriggerEvent(rbuttondown!)
			return 2
		End If
		
		this.SetItem(1,"prjnm",sproject_prjnm)
	/* 수불구분 */
Case "iogbn"
	siogbn = gettext()
	Select salegu,amtgu into :ssalegu, :samtgu from iomatrix where iogbn = :siogbn;
	If ssalegu = 'Y' then
		dw_cond.object.t_gbn.text = "유상"
		dw_insert.Modify('ioprc.protect = 0')
		dw_insert.Modify('ioamt.protect = 0')
		IF samtgu = 'Y' then
			dw_insert.Modify('ioreqty.protect = 1')
			dw_insert.Modify('ioprc.protect = 1')
		Else
			dw_insert.Modify('ioreqty.protect = 0')
			dw_insert.Modify('ioprc.protect = 0')			
		End if
	Else
		dw_cond.object.t_gbn.text = "무상"
		dw_insert.Modify('ioprc.protect = 1')		
		dw_insert.Modify('ioamt.protect = 1')			
	End if
End Choose

end event

event rbuttondown;SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "iojpno"
		gs_gubun = '037'	//유상사급
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"iojpno",left(gs_code, 12))
		TriggerEvent(ItemChanged!)
		p_inq.TriggerEvent(Clicked!)
	/* 거래처 */
	Case "cvcod", "vndname"
		gs_gubun = '1'
		If GetColumnName() = "vndname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from u_d_popup_sort within w_sal_02047
boolean visible = false
integer x = 3159
integer y = 172
integer width = 169
integer height = 116
integer taborder = 0
boolean enabled = false
string title = "출고송장 "
string dataobject = "d_sal_02047_p1"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type dw_hidden from datawindow within w_sal_02047
boolean visible = false
integer x = 576
integer y = 784
integer width = 3081
integer height = 504
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_vnddan_popup_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_sal_02047
integer x = 3182
integer y = 24
integer width = 306
integer taborder = 230
boolean bringtotop = true
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event clicked;call super::clicked;/*******************************************************************************/
/**************************** [2공장일경우만 사용] *****************************/
/*******************************************************************************/
//발주처 품목선택	-버턴명
string scvcod, sempno, sin_house, SO_house, sopt, sitem, sopseq, ls_bunbr, scur_ymd,sOrderDate, spspec
int    k, lRow,iRtnValue
Decimal {5} ddata
Double dDcRate, ddanga
Long	ljegoqty

IF dw_cond.AcceptText() = -1	THEN	RETURN

dw_insert.Reset()
sCvcod 	= dw_cond.getitemstring(1, "cvcod"    ) /* 거 래 처  */ 
Sempno   = dw_cond.getitemstring(1, "io_empno" ) /* 담 당 자  */
SO_house = dw_cond.getitemstring(1, "depot_no" ) /* 출고 창고 */
sOrderDate = dw_cond.getitemstring(1, "sudat" ) /* 출고 창고 */

scur_ymd = f_today()
sempno   = gs_empno

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[거래처]')
	dw_cond.SetColumn("cvcod")
	dw_cond.SetFocus()
	RETURN
END IF

// 영업담당자
IF IsNull(Sempno)	or   trim(Sempno) = ''	THEN
	dw_insert.setredraw(true)
	f_message_chk(30,'[담당자]')
	dw_cond.Setcolumn("io_empno")
	dw_cond.setfocus()
	RETURN 
END IF

// 출고창고
IF IsNull(SO_house)	or   trim(SO_house) = ''	THEN
	dw_insert.setredraw(true)
	f_message_chk(30,'[출고창고]')
	dw_cond.Setcolumn("depot_no")
	dw_cond.setfocus()
	RETURN 
END IF


  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code = sCvcod
open(w_vnddan_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"


FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if sopt  = 'Y' then 
		lRow  = dw_insert.insertrow(0)
      dw_insert.SetItem(lRow, 'cvcod', sCvcod)
		sitem  = dw_hidden.getitemstring(k, 'itnbr' )
		dw_insert.setitem(lRow, 'itnbr', sitem)
		dw_insert.setitem(lRow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lRow, 'jijil'       , dw_hidden.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lRow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lRow, 'pspec'       , '.' )

		iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu, sOrderDate, sCvcod, sitem, '.',&
                     'WON','1',dDanga,dDcRate) 
							
		If IsNull(dDanga) Then dDanga = 0
		If IsNull(dDcRate) Then dDcRate = 0
		
		if iRtnValue < 0 then
			dDcRate = 0
		Else
			dw_insert.SetItem(lRow,"ioprc", truncate(dDanga,3))
				
		End if	
		
		/* 재고 수량 선택 */
		Select Nvl(jego_qty, 0)
		  Into :ljegoqty
		  From stock
		 Where depot_no  = :SO_house
		   and itnbr     = :sItem
			and pspec     = '.'
		 Using sqlca; 	
		 
		dw_insert.SetItem(lRow, "jego_qty", ljegoqty)
		dw_insert.SetItem(lRow, "lclgbn"  , 'V')
	end if	
NEXT
dw_hidden.reset()
dw_insert.ScrollToRow(1)
dw_insert.setrow(1)
dw_insert.SetColumn("ioreqty")
dw_insert.SetFocus()
end event

type pb_1 from u_pb_cal within w_sal_02047
integer x = 1998
integer y = 168
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sudat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sudat', gs_code)

end event

type p_3 from picture within w_sal_02047
integer x = 3013
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\미리보기_up.gif"
boolean focusrectangle = false
end type

event clicked;string	sArg_sdate

sArg_sdate = dw_cond.getitemstring(1,'iojpno')
if dw_list.Retrieve(gs_sabu, Lsiojpno, Lsiojpno, gs_saupj) > 0 then
	OpenWithParm(w_print_preview, dw_list)
end if
end event

type dw_autoimhist from datawindow within w_sal_02047
boolean visible = false
integer x = 1330
integer y = 1380
integer width = 1024
integer height = 756
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sal_020403_auto"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type cbx_move from checkbox within w_sal_02047
integer x = 3013
integer y = 208
integer width = 462
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "울산이동출고"
boolean checked = true
end type

type rr_1 from roundrectangle within w_sal_02047
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 300
integer width = 4617
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

