$PBExportHeader$w_qct_01030.srw
$PBExportComments$재검사 결과 등록
forward
global type w_qct_01030 from window
end type
type dw_4 from datawindow within w_qct_01030
end type
type dw_3 from datawindow within w_qct_01030
end type
type dw_2 from datawindow within w_qct_01030
end type
type dw_1 from datawindow within w_qct_01030
end type
type dw_imhist from datawindow within w_qct_01030
end type
type pb_3 from u_pb_cal within w_qct_01030
end type
type pb_2 from u_pb_cal within w_qct_01030
end type
type pb_1 from u_pb_cal within w_qct_01030
end type
type p_exit from uo_picture within w_qct_01030
end type
type p_can from uo_picture within w_qct_01030
end type
type p_mod from uo_picture within w_qct_01030
end type
type p_inq from uo_picture within w_qct_01030
end type
type rb_wai from radiobutton within w_qct_01030
end type
type rb_nae from radiobutton within w_qct_01030
end type
type rb_delete from radiobutton within w_qct_01030
end type
type rb_insert from radiobutton within w_qct_01030
end type
type dw_detail from datawindow within w_qct_01030
end type
type dw_list from datawindow within w_qct_01030
end type
type gb_2 from groupbox within w_qct_01030
end type
type gb_5 from groupbox within w_qct_01030
end type
type rr_1 from roundrectangle within w_qct_01030
end type
end forward

global type w_qct_01030 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "재검사결과 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
dw_imhist dw_imhist
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
rb_wai rb_wai
rb_nae rb_nae
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_list dw_list
gb_2 gb_2
gb_5 gb_5
rr_1 rr_1
end type
global w_qct_01030 w_qct_01030

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_qct_01040 str_01040
str_qa01_00020 str_00020

String      is_ispec, is_jijil

end variables

forward prototypes
public function integer wf_initial ()
public function integer wf_nae_update ()
public function integer wf_checkrequiredfield ()
public function integer wf_wai_update ()
public function integer wf_ref_delete ()
public function integer wf_imhist_o10_insert ()
public function integer wf_imhist_i11_insert ()
end prototypes

public function integer wf_initial ();
dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()


dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

// 등록시
dw_detail.setcolumn("sdate")
dw_detail.SetItem(1, "sdate", Left(is_Date,4) + Mid(is_Date,5,2) + '01')
dw_detail.SetItem(1, "edate", is_Date)
dw_detail.SetItem(1, "insdat", is_Date)  // 검사일자

dw_detail.setfocus()


dw_detail.setredraw(true)

f_mod_saupj(dw_detail,"porgu")

dw_detail.modify('porgu.protect = 0')
Return  1

end function

public function integer wf_nae_update ();////////////////////////////////////////////////////////////////////////////
string	sGubun, sNull
long		lRow
dec  {3}	dQty, dBadQty

String sInsDat
sInsDat = dw_detail.GetItemString(1,'insdat')
If f_datechk(sInsDat) <> 1 Then
	f_message_chk(35,'[검사일자]')
	Return -1
End If


FOR lRow = 1	TO		dw_list.RowCount()

	sGubun = dw_list.GetItemString(lRow, "gubun")
	
	IF sGubun = 'Y'	THEN		
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")
		
		IF dBadQty > 0 THEN 
			dw_list.SetItem(lRow, "decisionyn", 'N')
		ELSE
			dw_list.SetItem(lRow, "decisionyn", 'Y')
		END IF
		/*********************************************************************************************/
		/*   승인업무를 제품창고 담당자가 처리하도록 변경(안병국과장 요청) - 2008.11.12 BY SHINGOON  */
		/*********************************************************************************************/
		dw_list.SetItem(lRow, "imhist_insdat",  sInsDat)
		//  수불수량은 모두 포함, 왜냐하면 폐기출고할거니깐.. 따라서 재고수불을 위해서..
		dw_list.SetItem(lRow, "imhist_ioqty",   dQty)
		dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty)
		dw_list.SetItem(lRow, "imhist_io_date", sInsDat)
		dw_list.SetItem(lRow, "imhist_io_confirm", 'Y')
		/*********************************************************************************************/
		/*   승인업무를 제품창고 담당자가 처리하도록 변경(안병국과장 요청) - 2008.11.12 BY SHINGOON  */
		/*********************************************************************************************/
//		dw_list.SetItem(lRow, "imhist_io_confirm",  'N')		// --> 창고강제승인
//		dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// 수불승인일자=입고의뢰일자
//		dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
//		dw_list.setitem(lrow, "imhist_ioqty",  sNull)
//		dw_list.setitem(Lrow, "imhist_ioamt", sNull)			
		/*********************************************************************************************/

	ELSE
		dw_list.SetItem(lRow, "decisionyn",  sNull)
		dw_list.SetItem(lRow, "imhist_insdat",  sNull)
		dw_list.SetItem(lRow, "imhist_ioqty", 0)
		dw_list.SetItem(lRow, "imhist_iosuqty", 0)
		dw_list.SetItem(lRow, "imhist_iofaqty", 0)
		dw_list.SetItem(lRow, "imhist_io_date", sNull)
		dw_list.SetItem(lRow, "imhist_io_empno",sNull)
		dw_list.SetItem(lRow, "imhist_io_confirm", 'Y')

	END IF

NEXT

RETURN 0
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		* 등록모드
//	
//////////////////////////////////////////////////////////////////

long lrow, lcount
Decimal {3} dQty, dBadqty

lCount = dw_list.RowCount()

FOR lRow = 1	TO	 lCount	
	
	dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
	dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량

	IF dBadQty > 0	AND rb_insert.checked	THEN	
		dw_list.SetItem(lRow, "gubun", 'Y')
		gs_Code = dw_list.GetItemString(lRow, "imhist_iojpno")
		gi_Page = dBadQty
		
		str_00020.sabu 	= gs_sabu
		str_00020.iojpno	= dw_list.getitemstring(lRow, "imhist_iojpno")
		str_00020.itnbr	= dw_list.getitemstring(lRow, "imhist_itnbr")
		str_00020.itdsc	= dw_list.getitemstring(lRow, "itemas_itdsc")
		str_00020.ispec	= dw_list.getitemstring(lRow, "itemas_ispec")
		str_00020.ioqty	= dw_list.getitemDecimal(lRow, "imhist_ioreqty")
		str_00020.buqty	= dw_list.getitemDecimal(lRow, "imhist_iofaqty")
		str_00020.joqty	= 0
		str_00020.siqty	= dw_list.getitemDecimal(lRow, "imhist_ioreqty")
		str_00020.rowno	= lrow
		str_00020.dwname  = dw_list
		str_00020.gubun   = 'N' //수입검사구분
		Openwithparm(w_qa01_00021, str_00020)
	END IF
Next

RETURN 1
end function

public function integer wf_wai_update ();////////////////////////////////////////////////////////////////////////////
string	sGubun, sNull, sIojpno, sSalegu, sUdate, sDepot, sComp
long		lRow, lcount
dec  {3}	dQty, dBadQty
dec  {5} dprc

String sInsDat
sInsDat = dw_detail.GetItemString(1,'insdat')
If f_datechk(sInsDat) <> 1 Then
	f_message_chk(35,'[검사일자]')
	Return -1
End If


lcount = 	dw_list.RowCount()
FOR lRow = 1	TO	 lcount

	sGubun  = dw_list.GetItemString(lRow, "gubun")
	sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")
	sUdate = dw_list.GetItemString(lRow, "imhist_sudat")
	sDepot = dw_list.GetItemString(lRow, "imhist_depot_no")
	
	IF sGubun = 'Y' AND rb_insert.checked		THEN		
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")
		dPrc	  = dw_list.GetItemDecimal(lRow, "imhist_ioprc")
		dw_list.SetItem(lRow, "imhist_insdat",  sInsDat)
		dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty)
		
		IF dBadQty > 0 THEN 
			dw_list.SetItem(lRow, "decisionyn", 'N')
		ELSE
			dw_list.SetItem(lRow, "decisionyn", 'Y')
		END IF
		
//		IF dw_list.getitemstring(lrow, "imhist_io_confirm") = 'Y'  then
			/*********************************************************************************************/
			/*   승인업무를 제품창고 담당자가 처리하도록 변경(안병국과장 요청) - 2008.10.24 BY SHINGOON  */
			/**********************************************************************************************
			dw_list.SetItem(lRow, "imhist_io_confirm",  'Y')		// --> 창고강제승인
			dw_list.SetItem(lRow, "imhist_io_date",  sInsDat)		// 수불승인일자=입고의뢰일자
			dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
			
			//  수불수량은 모두 포함, 왜냐하면 폐기출고할거니깐.. 따라서 재고수불을 위해서..
			//	 매출금액도 일단 모든 반품수량에 대해서 적용되므로..
			dw_list.setitem(lrow, "imhist_ioqty",  dQty)
			dw_list.setitem(Lrow, "imhist_ioamt", Truncate(dQty * dPrc, 0))
			**********************************************************************************************/
			
			/*********************************************************************************************/
			/*   승인업무를 제품창고 담당자가 처리하도록 변경(안병국과장 요청) - 2008.10.24 BY SHINGOON  */
			/*********************************************************************************************/
			SELECT HOMEPAGE into :sComp FROM VNDMST WHERE CVGU = '5' AND CVCOD = :sDepot;
			
			If sComp = 'Y' Then
				dw_list.SetItem(lRow, "imhist_io_confirm",  'Y')		// --> 창고강제승인
				dw_list.SetItem(lRow, "imhist_io_date",  sInsDat)		// 수불승인일자=입고의뢰일자
				dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
				dw_list.setitem(lrow, "imhist_ioqty",  dQty)
				dw_list.setitem(Lrow, "imhist_ioamt", Truncate(dQty * dPrc, 0))			
			Else
				dw_list.SetItem(lRow, "imhist_io_confirm",  'N')		// --> 창고강제승인
				dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// 수불승인일자=입고의뢰일자
				dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
				dw_list.setitem(lrow, "imhist_ioqty",  sNull)
				dw_list.setitem(Lrow, "imhist_ioamt", sNull)	
			End If
         /*********************************************************************************************/

//			dw_list.setitem(lrow, "imhist_ioqty",  dQty - dBadqty)
//			dw_list.setitem(Lrow, "imhist_ioamt", Truncate((dQty - dBadqty) * dPrc, 0))
			
			//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
			//검수일자에 승인일자를 move
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sUdate)	// 검수일자는 수불의뢰일자 기준
				dw_list.Setitem(lRow, "dyebi3", Truncate(dQty * dPrc, 0) * 0.1)
				
//				dw_list.SetItem(lRow, "yebi1",  sInsDat)
//				dw_list.Setitem(lRow, "dyebi3", Truncate((dQty - dBadqty) * dPrc, 0) * 0.1)
	      END IF 		
//		END IF		 		
	ELSEIF sGubun = 'N' THEN  
		dw_list.SetItem(lRow, "imhist_insdat",  sNull)
		dw_list.SetItem(lRow, "imhist_iosuqty", 0)
		dw_list.SetItem(lRow, "imhist_iofaqty", 0)
		dw_list.SetItem(lRow, "imhist_iocdqty", 0)
		dw_list.SetItem(lRow, "decisionyn",  sNull)
		
//		IF dw_list.getitemstring(lrow, "imhist_io_confirm") = 'Y'  then
			dw_list.SetItem(lRow, "imhist_io_confirm",  'N')		// --> 창고강제승인
			dw_list.SetItem(lRow, "imhist_io_date",  Snull)		// 수불승인일자=입고의뢰일자
			dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
			dw_list.setitem(lrow, "imhist_ioqty",    0)
			dw_list.setitem(Lrow, "imhist_ioamt",    0)

			//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sNull)
				dw_list.Setitem(lRow, "dyebi3", 0)
	      END IF 		

//		END IF		 				
		
	END IF

NEXT

RETURN 0

end function

public function integer wf_ref_delete ();//////////////////////////////////////////////////////////////////////////////
string	sIojpno
long		lRow, ll_cnt
decimal	dBadQty, dOkQty
	
FOR lRow = 1	TO	dw_list.RowCount()
	if dw_list.GetItemString(lRow,'chk') = 'N' then CONTINUE
	
	sIojpno = dw_list.GetItemString(lRow,'imhist_iojpno')
	dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")
	dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iosuqty")

	//양품, 불량 모두 창고재고로 입고됨. - BY SHINGOON 2009.10.01
	//불량은 불량창고 입고 후 별도 폐기처리함. - BY SHINGOON 2009.10.01
//	IF rb_nae.checked AND dOkQty > 0 THEN
	If rb_nae.Checked Then 
		// 양품입고전표 삭제 [사내의뢰만]
		DELETE FROM IMHIST
		 WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND IOGBN||'' = 'I11' ;
	END IF

	
	IF dBadQty > 0 THEN
//		// 폐기전표 삭제
//		DELETE FROM IMHIST
//		 WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND IOGBN||'' = 'O10' ;
		
	
		/* 불량 및 조건부 내역 */
		Delete from imhfat
		 Where sabu = :gs_sabu and iojpno = :sIojpno;
		 
//		if sqlca.sqlcode <> 0 then 
//			messagebox('확 인', '불량 및 조건부 내역에 삭제를 실패하였습니다.', StopSign!)
//			rollback;
//			return -1 
//		end if


		/* 원자재 이상 통지 내역 */
		Delete from imhfag
		 Where sabu = :gs_sabu and iojpno = :sIojpno; 

//		if sqlca.sqlcode <> 0 then 
//			messagebox('확 인', '조치 내역에 삭제를 실패하였습니다.', StopSign!)
//			rollback;
//			return -1 
//		end if

	END IF	 
NEXT

RETURN 0
end function

public function integer wf_imhist_o10_insert ();////////////////////////////////////////////////////////////////////////////
string	sGubun, sNull, sIojpno
long		lRow
dec  {3}	dQty, dBadQty

//==============================================================================
long		i, k, ll_maxjpno, ll_cnt
string	ls_sudat, ls_saupj, ls_depot, ls_cvcod, ls_iogbn, ls_jpno,	ls_jnpcrt


//dw_imhist.reset()

ls_sudat = dw_detail.GetItemString(1,'insdat')
ls_saupj = Trim(dw_detail.Object.porgu[1])

// 불량수량이 없으면 리턴
if dw_list.Find("imhist_iofaqty > 0", 1, dw_list.RowCount()) = 0 then Return 1

ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_maxjpno <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
//commit;

ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
IF ls_jpno = "" OR IsNull(ls_jpno) THEN
	f_message_chk(51,'[전표번호]')
	Return -1
End If
//==============================================================================


FOR lRow = 1	TO	dw_list.RowCount()

	sGubun = dw_list.GetItemString(lRow, "gubun")
	sIojpno = dw_list.GetItemString(lRow,'imhist_iojpno')
	

	IF sGubun = 'Y'	THEN
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")

		////////////////////////////////////////////////////////////////////////////////////////
		// 폐기출고 전표 생성 - 2006.12.27 - 송병호
		/////////////////////////////////////////////////////////////////////////////////////////
		IF dBadQty > 0 THEN

			ls_depot = dw_list.GetItemString(lRow, "imhist_depot_no")  // 출고 창고
			ls_cvcod	= gs_dept  // 폐기 부서
			
			ls_iogbn = 'O10'	 // 폐기
			ls_jnpcrt= '001'
			
			k++
			i = dw_imhist.insertrow(0)
			
			dw_imhist.SetItem(i,"sabu",       gs_sabu)
			dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(k,'000'))
			dw_imhist.SetItem(i,"iogbn",      ls_iogbn)
			dw_imhist.SetItem(i,"itnbr",      dw_list.GetItemString(lRow,'imhist_itnbr'))
			dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
			dw_imhist.SetItem(i,"pspec",   	'.')
			dw_imhist.SetItem(i,"opseq",		'9999')
			dw_imhist.SetItem(i,"depot_no",   ls_depot)				// 제품창고
			dw_imhist.SetItem(i,"cvcod",      ls_cvcod)				
			dw_imhist.SetItem(i,"io_confirm", 'Y')
			dw_imhist.SetItem(i,"filsk",      'Y') 	     // 재고관리유무
			dw_imhist.SetItem(i,"ioredept",   gs_dept)
			dw_imhist.SetItem(i,"ioreemp",    gs_empno)
			dw_imhist.SetItem(i,"saupj",      ls_saupj)
			dw_imhist.SetItem(i,"inpcnf", 	 'O')   					// 입출고구분(입고)
			dw_imhist.SetItem(i,"outchk",		 'N')
			dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt)	
			dw_imhist.SetItem(i,"bigo",	 	 dw_list.GetItemString(lRow,'imhist_bigo'))
			
			dw_imhist.SetItem(i,"ioreqty",    dBadQty)
			dw_imhist.SetItem(i,"ioqty",      dBadQty)
			dw_imhist.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
			dw_imhist.SetItem(i,"iosuqty",    dBadQty) // 합격수량
			dw_imhist.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
			dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
			dw_imhist.SetItem(i,"qcgub",'1')
			dw_imhist.SetItem(i,"ip_jpno",	 sIojpno)	
		END IF
		/////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////

	END IF

NEXT

//IF dw_imhist.Update() > 0		THEN
//	COMMIT;
//ELSE
//	ROLLBACK;
//	f_Rollback()
//	return -1
//END IF
//


RETURN 0
end function

public function integer wf_imhist_i11_insert ();////////////////////////////////////////////////////////////////////////////
string	sGubun, sNull, sIojpno
long		lRow
dec  {3}	dQty, dOkQty, dBadQty

//==============================================================================
long		i, k, ll_maxjpno, ll_cnt
string	ls_sudat, ls_saupj, ls_depot, ls_cvcod, ls_iogbn, ls_jpno,	ls_jnpcrt


//dw_imhist.reset()

ls_sudat = dw_detail.GetItemString(1,'insdat')
ls_saupj = Trim(dw_detail.Object.porgu[1])


// 사내의뢰가 아니면 리턴
if not rb_nae.checked then Return 1
// 합격수량이 없으면 리턴
//if dw_list.Find("imhist_iosuqty > 0", 1, dw_list.RowCount()) = 0 then Return 1

ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_maxjpno <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
//commit;

ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
IF ls_jpno = "" OR IsNull(ls_jpno) THEN
	f_message_chk(51,'[전표번호]')
	Return -1
End If
//==============================================================================


FOR lRow = 1	TO	dw_list.RowCount()

	sGubun = dw_list.GetItemString(lRow, "gubun")
	sIojpno = dw_list.GetItemString(lRow,'imhist_iojpno')
	

	IF sGubun = 'Y'	THEN
		dQty = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")
		dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iosuqty")

		////////////////////////////////////////////////////////////////////////////////////////
		// 창고이동입고 전표 생성 - 2007.01.03 - 송병호
		/////////////////////////////////////////////////////////////////////////////////////////
		/****************************************************************************************************************/
		/* 합격수량이 없어도 의뢰수량 만큼 Z99:제품창고(불량) 으로 창고이동입고 수불 발생 처리 - by shingoon 2009.04.02 */
		/****************************************************************************************************************/
//		IF dOkQty > 0 THEN

			ls_depot = dw_list.GetItemString(lRow, "imhist_cvcod")  		// 입고 창고
			ls_cvcod	= dw_list.GetItemString(lRow, "imhist_depot_no")   // 출고 창고
			
			ls_iogbn = 'I11'	 // 창고이동입고
			ls_jnpcrt= '011'
			
			k++
			i = dw_imhist.insertrow(0)
			
			dw_imhist.SetItem(i,"sabu",       gs_sabu)
			dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(k,'000'))
			dw_imhist.SetItem(i,"iogbn",      ls_iogbn)
			dw_imhist.SetItem(i,"itnbr",      dw_list.GetItemString(lRow,'imhist_itnbr'))
			dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
			dw_imhist.SetItem(i,"pspec",   	'.')
			dw_imhist.SetItem(i,"opseq",		'9999')
			dw_imhist.SetItem(i,"depot_no",   ls_depot)				// 제품창고
			dw_imhist.SetItem(i,"cvcod",      ls_cvcod)				
			dw_imhist.SetItem(i,"io_confirm", 'Y')
			dw_imhist.SetItem(i,"filsk",      'Y') 	     // 재고관리유무
			dw_imhist.SetItem(i,"ioredept",   gs_dept)
			dw_imhist.SetItem(i,"ioreemp",    gs_empno)
			dw_imhist.SetItem(i,"saupj",      ls_saupj)
			dw_imhist.SetItem(i,"inpcnf", 	 'I')   					// 입출고구분(입고)
			dw_imhist.SetItem(i,"outchk",		 'N')
			dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt)	
			dw_imhist.SetItem(i,"bigo",	 	 dw_list.GetItemString(lRow,'imhist_bigo'))
			
			dw_imhist.SetItem(i,"ioreqty",    dQty)
			dw_imhist.SetItem(i,"ioqty",      dQty)
			dw_imhist.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
			dw_imhist.SetItem(i,"iosuqty",    dQty) // 합격수량 - 입고는 합격수량 기준으로 수불발생됨
			dw_imhist.SetItem(i,"iopeqty",    dQty - dOkQty)
			dw_imhist.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
			dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
			dw_imhist.SetItem(i,"qcgub",'1')
			dw_imhist.SetItem(i,"ip_jpno",	 sIojpno)	
//		END IF
		/////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////

	END IF

NEXT

//IF dw_imhist.Update() > 0		THEN
//	COMMIT;
//ELSE
//	ROLLBACK;
//	f_Rollback()
//	return -1
//END IF


RETURN 0
end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

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

is_Date = f_Today()

p_can.TriggerEvent("clicked")




end event

on w_qct_01030.create
this.dw_4=create dw_4
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_imhist=create dw_imhist
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.rb_wai=create rb_wai
this.rb_nae=create rb_nae
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_5=create gb_5
this.rr_1=create rr_1
this.Control[]={this.dw_4,&
this.dw_3,&
this.dw_2,&
this.dw_1,&
this.dw_imhist,&
this.pb_3,&
this.pb_2,&
this.pb_1,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.rb_wai,&
this.rb_nae,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_list,&
this.gb_2,&
this.gb_5,&
this.rr_1}
end on

on w_qct_01030.destroy
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_imhist)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.rb_wai)
destroy(this.rb_nae)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.rr_1)
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

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_4 from datawindow within w_qct_01030
boolean visible = false
integer x = 2482
integer y = 28
integer width = 297
integer height = 200
integer taborder = 20
boolean enabled = false
boolean titlebar = true
string title = "재검결과"
string dataobject = "d_qct_01031_a"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_qct_01030
boolean visible = false
integer x = 2185
integer y = 28
integer width = 297
integer height = 200
integer taborder = 10
boolean enabled = false
boolean titlebar = true
string title = "재검의뢰"
string dataobject = "d_qct_01031"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_qct_01030
boolean visible = false
integer x = 1888
integer y = 28
integer width = 297
integer height = 200
integer taborder = 10
boolean enabled = false
boolean titlebar = true
string title = "반품결과"
string dataobject = "d_qct_01031_1_a"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_qct_01030
boolean visible = false
integer x = 1591
integer y = 28
integer width = 297
integer height = 200
integer taborder = 70
boolean enabled = false
boolean titlebar = true
string title = "반품의뢰"
string dataobject = "d_qct_01031_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_qct_01030
boolean visible = false
integer x = 3333
integer y = 84
integer width = 475
integer height = 116
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_imhist"
boolean border = false
boolean livescroll = true
end type

type pb_3 from u_pb_cal within w_qct_01030
integer x = 3095
integer y = 192
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('insdat')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'insdat', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01030
integer x = 2249
integer y = 192
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_01030
integer x = 1737
integer y = 192
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'sdate', gs_code)
end event

type p_exit from uo_picture within w_qct_01030
integer x = 4393
integer y = 28
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01030
integer x = 4219
integer y = 28
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;
wf_initial()

end event

type p_mod from uo_picture within w_qct_01030
integer x = 4046
integer y = 28
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;string	sNull

IF dw_list.AcceptText() = -1	THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)	

If wf_checkrequiredfield() = -1 Then Return


//---------------------------------------------------------------------------
//-1. 관련자료 먼저 삭제 [검사결과 모드만]
If rb_delete.checked then
	if wf_ref_delete() = -1 then
		return
	end if
End If	


//---------------------------------------------------------------------------
//-2. 검사결과 저장
if rb_nae.checked then
	if wf_nae_update() = -1 then
		return
	end if
ELSE	
	if wf_wai_update() = -1 then
		return
	end if	
end if

IF dw_list.Update() > 0		THEN
//	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF



//---------------------------------------------------------------------------
//-3. 창고이동입고 생성
dw_imhist.reset()
// 중복자료 발생하는 오류로 조건 추가 - 2010.07.21 - 송병호
If rb_insert.checked then
	if wf_imhist_i11_insert() = -1 then
		return
	end if
End If	


////---------------------------------------------------------------------------
////-4. 폐기자료 생성 - 폐기처리안함 - 2009.03.04
//if wf_imhist_o10_insert() = -1 then
//	return
//end if

IF dw_imhist.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF


p_can.TriggerEvent("clicked")

SetPointer(Arrow!)


end event

type p_inq from uo_picture within w_qct_01030
integer x = 3872
integer y = 28
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

string	sDateFrom, sDateTo,ls_porgu

ls_porgu = trim(dw_detail.GetItemString(1, "porgu"))

f_mod_saupj(dw_detail,"porgu")

IF isnull(ls_porgu) or ls_porgu = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

sDateFrom = trim(dw_detail.GetItemString(1, "sdate"))
sDateTo   = trim(dw_detail.GetItemString(1, "edate"))

IF isnull(sDateFrom) or sDateFrom = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sDateTo) or sDateTo = "" 	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

SetPointer(HourGlass!)	
	
IF	dw_list.Retrieve(ls_porgu,gs_Sabu, sDateFrom, sDateTo) <	1		THEN
	f_message_chk(50, '[재검사 의뢰내역]')
	dw_detail.setcolumn("sdate")
	dw_detail.setfocus()
	RETURN
END IF

/* 검사결과 수정 AND 기타입고(사외입고)인 경우에만 계산서발행여부를 검색하여 수정여부 판독*/
//LONG LROW
//if rb_delete.checked and rb_wai.checked then
//	for lrow = 1 to dw_list.rowcount()
//		 if dw_list.getitemstring(Lrow, "uptgub") = 'N' then
//			 if isnull(dw_list.getitemstring(Lrow, "imhist_checkno")) or &
//				 trim(dw_list.getitemstring(Lrow, "imhist_checkno")) = '' then
//			 else
//				 dw_list.setitem(Lrow, "sungin", "발행")
//				 dw_list.setitem(Lrow, "uptgub", "Y")				 
//			 end if
//		 end if
//	next
//end if

dw_imhist.reset()

dw_list.SetFocus()
dw_detail.enabled = true
p_mod.enabled = true

end event

type rb_wai from radiobutton within w_qct_01030
integer x = 928
integer y = 60
integer width = 251
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "반품"
boolean checked = true
end type

event clicked;dw_list.setredraw(false)
IF rb_insert.checked then
	dw_list.dataobject = 'd_qct_01031_1'
else
	dw_list.dataobject = 'd_qct_01031_1_a'	
end if
dw_list.settransobject(sqlca)
dw_list.setredraw(true)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

end event

type rb_nae from radiobutton within w_qct_01030
integer x = 1202
integer y = 60
integer width = 325
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "재 검사"
end type

event clicked;dw_list.setredraw(false)
IF rb_insert.checked then
	dw_list.dataobject = 'd_qct_01031'
else
	dw_list.dataobject = 'd_qct_01031_a'	
end if
dw_list.settransobject(sqlca)
dw_list.setredraw(true)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

end event

type rb_delete from radiobutton within w_qct_01030
integer x = 457
integer y = 60
integer width = 338
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "검사결과"
end type

event clicked;dw_list.setredraw(false)
IF rb_wai.checked then
	dw_list.dataobject = 'd_qct_01031_1_a'
else
	dw_list.dataobject = 'd_qct_01031_a'	
end if
dw_list.settransobject(sqlca)
dw_list.setredraw(true)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

end event

type rb_insert from radiobutton within w_qct_01030
integer x = 110
integer y = 60
integer width = 338
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "검사의뢰"
boolean checked = true
end type

event clicked;dw_list.setredraw(false)

IF rb_wai.checked then
	dw_list.dataobject = 'd_qct_01031_1'	
else
	dw_list.dataobject = 'd_qct_01031'
end if

dw_list.settransobject(sqlca)
dw_list.setredraw(true)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

end event

type dw_detail from datawindow within w_qct_01030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 164
integer width = 3237
integer height = 140
integer taborder = 10
string dataobject = "d_qct_01030"
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

type dw_list from datawindow within w_qct_01030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 64
integer y = 332
integer width = 4494
integer height = 1964
integer taborder = 30
string dataobject = "d_qct_01031_1"
boolean hscrollbar = true
boolean vscrollbar = true
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

event itemchanged;
long	lRow
String sdata
lRow = this.GetRow()

if this.getcolumnname() = 'gubun' then
	sData = this.gettext()
//	if sData = 'N' then
//		this.setitem(lrow, "imhist_iofaqty", 0)
//	end if

elseIF this.GetColumnName() = 'imhist_iofaqty'	THEN
	
	if this.getitemstring(lrow, "gubun") = 'N' then
		MessageBox("확인", "검사구분이 YES인 경우에만 입력 가능합니다.")
		this.SetItem(lRow, "imhist_iofaqty", 0)
		RETURN 1		
	end if
	
	dec	dBadQty, dQty
	dQty = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dBadQty = dec(this.GetText())
	
	IF dBadQty > dQty		THEN
		MessageBox("확인", "불량수량은 현재수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_iofaqty", 0)
		RETURN 1
	END IF
	
elseIF this.GetColumnName() = 'chk'	THEN	//검사결과에서 취소선택시
	sData = this.gettext()
	if sData = 'Y' then
		this.setitem(lrow,'gubun','N')
	else
		this.setitem(lrow,'gubun','Y')
	end if

END IF
end event

event retrieverow;//IF ROW > 0 THEN
//	if rb_delete.checked and rb_wai.checked then
//		if not isnull(getitemstring(row, "imhist_io_empno")) then 
//			this.setitem(row, "uptgub", 'Y')
//		end if
//	end if
//END IF
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

//For iPos = Len(sErrorSyntax) to 1 STEP -1
//	 sMsg = Mid(sErrorSyntax, ipos, 1)
//	 If sMsg   = sReturn or sMsg = sNewline Then
//		 iCount++
//	 End if
//Next
//
//sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)
//

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

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type gb_2 from groupbox within w_qct_01030
integer x = 55
integer y = 20
integer width = 795
integer height = 128
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type gb_5 from groupbox within w_qct_01030
integer x = 873
integer y = 20
integer width = 704
integer height = 128
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_qct_01030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 324
integer width = 4521
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

