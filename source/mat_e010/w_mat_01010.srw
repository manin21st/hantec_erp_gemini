$PBExportHeader$w_mat_01010.srw
$PBExportComments$기타 입고의뢰 등록
forward
global type w_mat_01010 from window
end type
type cb_1 from commandbutton within w_mat_01010
end type
type p_bar from uo_picture within w_mat_01010
end type
type pb_1 from u_pb_cal within w_mat_01010
end type
type p_print from uo_picture within w_mat_01010
end type
type p_2 from uo_picture within w_mat_01010
end type
type p_copy from uo_picture within w_mat_01010
end type
type p_exit from uo_picture within w_mat_01010
end type
type p_cancel from uo_picture within w_mat_01010
end type
type p_delete from uo_picture within w_mat_01010
end type
type p_save from uo_picture within w_mat_01010
end type
type p_inq from uo_picture within w_mat_01010
end type
type p_delrow from uo_picture within w_mat_01010
end type
type p_addrow from uo_picture within w_mat_01010
end type
type dw_print from datawindow within w_mat_01010
end type
type dw_imhist from datawindow within w_mat_01010
end type
type dw_copy from datawindow within w_mat_01010
end type
type rb_delete from radiobutton within w_mat_01010
end type
type rb_insert from radiobutton within w_mat_01010
end type
type dw_detail from datawindow within w_mat_01010
end type
type gb_2 from groupbox within w_mat_01010
end type
type rr_1 from roundrectangle within w_mat_01010
end type
type dw_list from datawindow within w_mat_01010
end type
end forward

global type w_mat_01010 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "기타 입고의뢰 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_open ( )
cb_1 cb_1
p_bar p_bar
pb_1 pb_1
p_print p_print
p_2 p_2
p_copy p_copy
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_inq p_inq
p_delrow p_delrow
p_addrow p_addrow
dw_print dw_print
dw_imhist dw_imhist
dw_copy dw_copy
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
gb_2 gb_2
rr_1 rr_1
dw_list dw_list
end type
global w_mat_01010 w_mat_01010

type variables
boolean ib_ItemError, ib_changed = False
char ic_status
string is_Last_Jpno, is_Date
long	     il_row

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_ispec ,  is_jijil
String	  is_itnbr

end variables

forward prototypes
public function integer wf_imhist_delete ()
public subroutine wf_focus ()
public function integer wf_update_gubun ()
public function integer wf_imhist_create (ref string rsdate, ref long rdseq)
public function integer wf_imhist_update ()
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
public function string wf_boxno ()
end prototypes

event ue_open();// commandbutton function
rb_insert.TriggerEvent("clicked")
end event

public function integer wf_imhist_delete ();
string	sHist_jpno
long		lRow, lRowCount
lRowCount = dw_list.RowCount()


FOR  lRow = lRowCount 	TO		1		STEP  -1
		

	dw_list.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public subroutine wf_focus ();dw_list.setcolumn("itnbr")
dw_list.setfocus()
end subroutine

public function integer wf_update_gubun ();long		lRow, lCount
string	sQcgubun, sQcdate, sIoConfirm, sIoDate

SetPointer(HourGlass!)
lCount = dw_list.RowCount()

/* 수정인 경우에만 check */
IF ic_status <> '1' THEN
	FOR  lRow = 1	TO	lCount 
		//수정가능 셋팅
		dw_list.SetItem(Lrow, "schk", 'Y')
		dw_list.SetItem(Lrow, "schk2", 'Y')
		
		// 검사구분, 검사일자입력시 수정불가
		sQcgubun = dw_list.GetItemString(Lrow, "qcgub")
		sQcdate  = dw_list.GetItemString(Lrow, "insdat")
		IF sQcgubun > '1'	THEN
			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(Lrow, "schk", 'N')
		END IF
		
		// 수불승인여부, 수불일자입력시 수정불가
		sIoConfirm = dw_list.GetItemString(Lrow, "io_confirm")
		sIoDate    = dw_list.GetItemString(Lrow, "io_date")
		IF sIoConfirm = 'N'	THEN
			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(Lrow, "schk2", 'N')
		END IF
		
	NEXT
END IF

RETURN 1


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
			sQcGubun,	&
			sNull, svendorgubun, ssaleyn, sstockgubun, svendor, scvcod, get_yn, sitnbr,&
			sitgu, spdtgu, siosp, sIttyp 
int		iCount
long		lRow, lRowHist, dSeq
SetNull(sNull)
dw_detail.AcceptText()

sDate  = dw_detail.GetItemString(1, "sdate")				// 입고의뢰일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'')
	RETURN -1
END IF

COMMIT;

rsdate = sdate
rdseq	 = dseq

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")

sEmpno = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sDept  = dw_detail.GetItemString(1, "dept")
sGubun = dw_detail.GetItemString(1, "gubun")
scvcod = dw_detail.GetItemString(1, "cvcod")

SELECT PDTGU, IOSP   INTO :get_yn, :siosp    FROM IOMATRIX  
 WHERE SABU = :gs_sabu AND IOGBN = :sgubun  ;
		 
if isnull(get_yn) then get_yn = 'N'		 

FOR	lRow = 1		TO		dw_list.RowCount()

	/////////////////////////////////////////////////////////////////////////
	//
	// ** 입출고HISTORY 생성 **
	//
	////////////////////////////////////////////////////////////////////////
	lRowHist = dw_imhist.InsertRow(0)

	sQcGubun = dw_list.GetItemString(lRow, "qcgub")
	
	dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
	dw_imhist.SetItem(lRowHist, "saupj",	dw_detail.GetItemString(1, "saupj"))
	dw_imhist.SetItem(lRowHist, "jnpcrt",	'009')			// 전표생성구분
	dw_imhist.SetItem(lRowHist, "inpcnf",  siosp)	// 입출고구분
	dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
	dw_imhist.SetItem(lRowHist, "iogbn",   sGubun) 			// 수불구분=입고구분

	dw_imhist.SetItem(lRowHist, "sudat",	sDate)			// 수불일자=수불의뢰일자

   sitnbr = 	dw_list.GetItemString(lRow, "itnbr")
	dw_imhist.SetItem(lRowHist, "itnbr", sitnbr ) // 품번
	dw_imhist.SetItem(lRowHist, "pspec", dw_list.GetItemString(lRow, "pspec")) // 사양

   //생산실적이 Y 인 경우만 생산팀 입력
	SELECT A.ITGU, B.PDTGU, A.ITTYP 
	  INTO :sItgu, :sPdtgu, :sIttyp
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
	dw_imhist.SetItem(lRowHist, "depot_no",dw_list.GetItemString(lRow, "depot_no"))	// 기준창고=입고처
	svendor = dw_list.GetItemString(lRow, "depot_no")
	dw_imhist.SetItem(lRowHist, "cvcod",	scvcod) 			// 거래처창고=입고의뢰부서
	dw_imhist.SetItem(lRowHist, "cust_no",	scvcod) 			// 거래처창고=입고의뢰부서
	dw_imhist.SetItem(lRowHist, "ioprc",	0) 				// 수불단가=0
	dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "ioreqty")) 	// 수불의뢰수량=입고수량		

	dw_imhist.SetItem(lRowHist, "qcgub",	sQcGubun) 		// 검사구분
	dw_imhist.SetItem(lRowHist, "insemp",  dw_list.getitemstring(lrow, "insemp"))			// 검사담당자=입고의뢰자	
	dw_imhist.SetItem(lRowHist, "filsk",   'Y') 				// 재고관리유무
	dw_imhist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=입고의뢰자
	dw_imhist.SetItem(lRowHist, "ioredept",sDept)			// 수불의뢰부서=입고의뢰부서
	// 수불승인은 창고기준이지만 기타입고는 수동승인을 기본원칙으로 함
		SELECT HOMEPAGE
		  INTO :sSaleYN
		  FROM VNDMST
		 WHERE ( CVCOD = :sVendor ) ;	
	
//	sSaleYn = 'N'
	dw_imhist.SetItem(lRowHist, "io_confirm", ssaleYn)			// 수불승인여부
	
	dw_imhist.SetItem(lRowHist, "gurdat",	dw_list.GetItemString(lRow, "gurdat"))		// 검사요청일
	dw_imhist.SetItem(lRowHist, "bigo", 	dw_list.GetItemString(lRow, "bigo"))		// 비고=입고사유

   // 입고 lot no
	If sIttyp = '3' Then //원자재일 경우 lot는 필수
		If Trim(dw_list.GetItemString(lRow, 'lotsno')) = '' OR IsNull(dw_list.GetItemString(lRow, 'lotsno')) Then
			MessageBox('Lot No. 확인', '원자재일 경우 Lot No.는 필수 입력 사항입니다.')
			dw_list.SetColumn('lotsno')
			dw_list.ScrollToRow(lRow)
			dw_list.SetRow(lRow)
			dw_list.SetFocus()
			Return -1
		End If
		dw_imhist.SetItem(lRowHist, "lotsno", 	dw_list.GetItemString(lRow, "lotsno"))
		dw_imhist.SetItem(lRowHist, "loteno", 	dw_list.GetItemString(lRow, "loteno"))
	End If
	
	IF sQcGubun = '1'		THEN										// 검사구분=무검사일 경우
		dw_imhist.SetItem(lRowHist, "insdat",sDate)			// 검사일자=입고의뢰일자
		dw_imhist.SetItem(lRowHist, "insemp",snull)			// 검사담당자
		dw_imhist.SetItem(lRowHist, "ioamt", 0)													 // 수불금액=0(입고단가)
		dw_imhist.SetItem(lRowHist, "iosuqty",dw_list.GetItemDecimal(lRow, "ioreqty")) // 합격수량=입고수량
		dw_imhist.SetItem(lRowHist, "decisionyn", 'Y')    //합격처리 
	END IF
	
	// 무검사이고 수불 자동 승인인 경우
	IF sqcgubun = '1' and ssaleyn = 'Y' then
		dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)		// 수불승인여부	
		dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_imhist.SetItem(lRowHist, "io_empno", sNull)		// 수불승인자=NULL
		dw_imhist.SetItem(lRowHist, "ioqty", dw_list.GetItemDecimal(lRow, "ioreqty"))  // 수불수량=입고수량		
	END IF
NEXT

RETURN 1
end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 입출고history -> 입고수량 update (입고수량을 변경할 경우에만)
//	
//////////////////////////////////////////////////////////////////
string	sJpno, 		&
			sDate, 		&
			sEmpno,		&
			sDept,		&
			sGubun,		&
			sQcGubun,	&
			sNull,	sCvcod, sSaleyn, svendor, get_yn, sitgu, spdtgu, sitnbr, siosp
int		iCount
long		lRow

SetNull(sNull)
dw_detail.AcceptText()

sDate  = dw_detail.GetItemString(1, "sdate")				// 입고의뢰일자
sEmpno = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sDept  = dw_detail.GetItemString(1, "dept")
sGubun = dw_detail.GetItemString(1, "gubun")
sCvcod = dw_detail.GetItemString(1, "Cvcod")

SELECT PDTGU, IOSP   INTO :get_yn, :siosp    FROM IOMATRIX  
 WHERE SABU = :gs_sabu AND IOGBN = :sgubun  ;
		 
if isnull(get_yn) then get_yn = 'N'		 

FOR	lRow = 1		TO		dw_list.RowCount()
	IF dw_list.getitemstring(lRow, 'schk3') = 'N' then continue
		
	IF dw_list.getitemstring(lRow, 'schk2') = 'N' then continue
	 
	if dw_list.getitemstring(lRow, 'schk') = 'N' then continue
	
	dw_list.SetItem(lRow, "saupj",	dw_detail.GetItemString(1, "saupj"))
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	
	sJpno    = dw_list.GetitemString(lRow, "iojpno")
	sSaleyn  = dw_list.GetitemString(lRow,  "io_confirm")
	sQcGubun = dw_list.GetItemString(lRow, "qcgub")
	sVendor  = dw_list.GetitemString(lRow,  "depot_no")	
	
	// 수불승인은 창고기준이지만 기타입고는 수동승인을 기본원칙으로 함
		SELECT HOMEPAGE
		  INTO :sSaleYN
		  FROM VNDMST
		 WHERE ( CVCOD = :sVendor ) ;	
	
	dw_list.SetItem(lRow, "io_confirm", ssaleYn)			// 수불승인여부	

	IF IsNull(sjpno)	OR sJpno = '' 	THEN
		is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
		dw_list.SetItem(lRow, "iojpno", is_Last_Jpno)

		dw_list.SetItem(lRow, "sabu",		gs_sabu)
		dw_list.SetItem(lRow, "jnpcrt",	'009')			// 전표생성구분
		dw_list.SetItem(lRow, "inpcnf",  siosp)	// 입출고구분
		dw_list.SetItem(lRow, "iogbn",   sGubun) 			// 수불구분=입고구분
		dw_list.SetItem(lRow, "sudat",	sDate)			// 수불일자=현재일자

		dw_list.SetItem(lRow, "opseq",	'9999') 			// 공정순서
		dw_list.SetItem(lRow, "cvcod",	sCvcod) 			// 거래처창고=입고의뢰부서
		dw_list.SetItem(lRow, "ioprc",	0) 				// 수불단가=0

		dw_list.SetItem(lRow, "filsk",   'Y') 				// 재고관리유무
		dw_list.SetItem(lRow, "ioreemp",	sEmpno)			// 수불의뢰담당자=입고의뢰자
		dw_list.SetItem(lRow, "ioredept",sDept)			// 수불의뢰부서=입고의뢰부서
	END IF

   sitnbr = dw_list.GetItemString(lRow, "itnbr")

	SELECT A.ITGU, B.PDTGU 
	  INTO :sItgu, :sPdtgu
	  FROM ITEMAS A, ITNCT B
	 WHERE A.ITNBR = :sitnbr AND A.ITTYP = B.ITTYP and A.ITCLS = B.ITCLS ;  
	//생산실적이 Y 인 경우만 생산팀 입력
	if get_yn = 'Y' then 
		if sqlca.sqlcode = 0 then 
			dw_list.SetItem(lRow, "pdtgu",   spdtgu) 	// 생산팀
		else
			dw_list.SetItem(lRow, "pdtgu",   sNull) 	// 생산팀
		end if	
	else	
		dw_list.SetItem(lRow, "pdtgu",   sNull) 	// 생산팀
   end if
	if sqlca.sqlcode = 0 then 
		dw_list.SetItem(lRow, "itgu",    sitgu) 	// 구입형태
	else
		dw_list.SetItem(lRow, "itgu",    sNull) 	// 구입형태
	end if	
	
	IF sQcGubun = '1'		THEN								// 검사구분=무검사일 경우
		dw_list.SetItem(lRow, "insdat",sDate)			// 검사일자=입고의뢰일자
		dw_list.SetItem(lRow, "insemp",sNull)			// 검사담당자=입고의뢰자
		dw_list.SetItem(lRow, "ioamt", 0)				// 수불금액=0(입고단가)
		dw_list.SetItem(lRow, "iosuqty",dw_list.GetItemDecimal(lRow, "ioreqty")) // 합격수량=입고수량
		dw_list.SetItem(lRow, "decisionyn", 'Y')     //합격처리 
	else		
		dw_list.SetItem(lRow, "insdat",snull)			// 검사일자=입고의뢰일자
		dw_list.SetItem(lRow, "ioamt", 0)				// 수불금액=0(입고단가)
		dw_list.SetItem(lRow, "iosuqty",0)
		dw_list.SetItem(lRow, "decisionyn", sNull)   //합불판정 = Null 
	END IF
	
	// 무검사이고 수불 자동 승인인 경우
	IF sqcgubun = '1' and ssaleyn = 'Y' then
		dw_list.SetItem(lRow, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_list.SetItem(lRow, "io_empno", sNull)		// 수불승인자=NULL
		dw_list.SetItem(lRow, "ioqty", dw_list.GetItemDecimal(lRow, "ioreqty"))  // 수불수량=입고수량		
	else		
		dw_list.SetItem(lRow, "io_date",  sNull)		// 수불승인일자=입고의뢰일자
		dw_list.SetItem(lRow, "io_empno", sNull)		// 수불승인자=NULL
		dw_list.SetItem(lRow, "ioqty", 0)  // 수불수량=입고수량				
	END IF			

NEXT

RETURN 1
end function

public function integer wf_initial ();String scode, sname1, sname2, sdept, sdeptname
Int    ireturn

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

//cb_save.enabled = false
p_delete.enabled = false
dw_detail.enabled = TRUE
p_copy.enabled = false

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// 등록시
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("sdate", 10)
	dw_detail.settaborder("saupj", 15)
	dw_detail.settaborder("empno", 0)
//	dw_detail.settaborder("gubun", 30)
	dw_detail.settaborder("dept",  0)
	dw_detail.settaborder("depot_no",  45)
	dw_detail.settaborder("cvcod", 50)

	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_saupj.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
	dw_detail.Modify("t_dsp_gbn.visible = 1")
	dw_detail.Modify("t_dsp_dept.visible = 1")
	dw_detail.Modify("t_dsp_chang.visible = 1")
	dw_detail.Modify("t_dsp_cust.visible = 1")
	
	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.setcolumn("gubun")
	dw_detail.SetItem(1, "sdate", is_Date)
	

	scode = gs_empno
   ireturn = f_get_name2('사번', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	

	dw_detail.setitem(1, 'empno', scode)
	dw_detail.setitem(1, 'empname', sname1)
	
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :sDept, :sDeptName
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		dw_detail.setitem(1, 'dept', sDept)
		dw_detail.setitem(1, 'deptname', sDeptName)
   END IF
	
	w_mdi_frame.sle_msg.text = "등록"
ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sdate", 0)
	dw_detail.settaborder("empno", 0)
	dw_detail.settaborder("dept",  0)
	dw_detail.settaborder("gubun", 0)
	dw_detail.settaborder("cvcod", 0)
	dw_detail.settaborder("saupj", 20)
	dw_detail.settaborder("depot_no", 0)

	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_saupj.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")
	dw_detail.Modify("t_dsp_gbn.visible = 0")
	dw_detail.Modify("t_dsp_dept.visible = 0")
	dw_detail.Modify("t_dsp_chang.visible = 0")
	dw_detail.Modify("t_dsp_cust.visible = 0")
	
	dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.setcolumn("JPNO")

	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)


//사업장
f_mod_saupj(dw_detail, 'saupj' )

//입고창고 
f_child_saupj(dw_detail, 'depot_no', gs_saupj )

return  1

end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 입고수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sCode, sItem, sLotgub,		&
			sDepot_no, sSaupj
dec{3}	dQty
long		lRow

sCode = dw_detail.GetitemString(1, "sdate")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[의뢰일자]')
	dw_detail.Setcolumn("sdate")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "empno")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[입고의뢰담당자]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "dept")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[입고의뢰부서]')
	dw_detail.Setcolumn("dept")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "gubun")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[수불구분]')
	dw_detail.Setcolumn("gubun")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "cvcod")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[거래처]')
	dw_detail.Setcolumn("cvcod")
	dw_detail.setfocus()
	RETURN -1
END IF

// 입고창고
sDepot_no = dw_detail.GetitemString(1, "depot_no")
IF IsNull(sDepot_no)	or   trim(sDepot_no) = ''	THEN
	f_message_chk(30,'[입고창고]')
	dw_detail.Setcolumn("depot_no")
	dw_detail.setfocus()
	RETURN -1
END IF

sDepot_no = dw_detail.GetitemString(1, "depot_no")
IF IsNull(sDepot_no)	or   trim(sDepot_no) = ''	THEN
	f_message_chk(30,'[입고창고]')
	dw_detail.Setcolumn("depot_no")
	dw_detail.setfocus()
	RETURN -1
END IF


/////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_list.RowCount()

		sitem = dw_list.GetitemString(lRow, "itnbr")
		IF IsNull(sitem)	or   trim(sitem) = ''	THEN
			f_message_chk(30,'[품번]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("itnbr")
			dw_list.setfocus()
			RETURN -1
		END IF

		SELECT LOTGUB INTO :sLotgub FROM ITEMAS WHERE ITNBR = :sitem ;
		
		IF sLotgub = 'Y' THEN 
			sCode = dw_list.GetitemString(lRow, "lotsno")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[입고 LOT NO]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("lotsno")
				dw_list.setfocus()
				RETURN -1
			END IF
      END IF

		sCode = dw_list.GetitemString(lRow, "pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.setitem(lrow, 'pspec', '.')
		END IF
		
		dQty = dw_list.getitemdecimal(lrow, "ioreqty")
		IF IsNull(dQty)  or  dQty = 0		THEN
			f_message_chk(30,'[입고수량]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("ioreqty")
			dw_list.setfocus()
			RETURN -1
		END IF

		// 입고창고
		dw_list.Setitem(lRow, "depot_no", sDepot_no)

		if dw_list.getitemstring(lrow, "qcgub") > '1' then
			sCode = dw_list.GetitemString(lRow, "insemp")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[검사담당자]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("insemp")
				dw_list.setfocus()
				RETURN -1
			END IF		
			
			sCode = dw_list.GetitemString(lRow, "gurdat")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[검사요청일]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("gurdat")
				dw_list.setfocus()
				RETURN -1
			END IF		
		
		end if

NEXT

RETURN 1


end function

public function string wf_boxno ();// 박스번호 채번 - NC
Int dSeq, ijucha
String sNo, sDate

SetNull(sNo)

//// 주차
//SELECT WEEK_YEAR_JUCHA INTO :ijucha 
//  FROM PDTWEEK 
// WHERE WEEK_SDATE <= :is_today AND WEEK_EDATE >= :is_today;
//sDate = 'VD-' + Mid(is_today,3,2) + String(ijucha,'00')
//		
//dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'ND')
//
//IF dSeq < 1		THEN
//	ROLLBACK;
//	f_message_chk(51,'[BOX NO]')
//	RETURN sNo
//END IF
//
//COMMIT;
//
//sNo = sDate + string(dSeq,'0000')

Return sNo
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


IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
ELSE	
	is_ispec = '규격'
	is_jijil = '재질'
END IF

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_print.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_copy.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

is_Date = f_Today()

PostEvent('ue_open')
end event

on w_mat_01010.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.cb_1=create cb_1
this.p_bar=create p_bar
this.pb_1=create pb_1
this.p_print=create p_print
this.p_2=create p_2
this.p_copy=create p_copy
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_inq=create p_inq
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.dw_print=create dw_print
this.dw_imhist=create dw_imhist
this.dw_copy=create dw_copy
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_list=create dw_list
this.Control[]={this.cb_1,&
this.p_bar,&
this.pb_1,&
this.p_print,&
this.p_2,&
this.p_copy,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_inq,&
this.p_delrow,&
this.p_addrow,&
this.dw_print,&
this.dw_imhist,&
this.dw_copy,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.gb_2,&
this.rr_1,&
this.dw_list}
end on

on w_mat_01010.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.p_bar)
destroy(this.pb_1)
destroy(this.p_print)
destroy(this.p_2)
destroy(this.p_copy)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.dw_print)
destroy(this.dw_imhist)
destroy(this.dw_copy)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.dw_list)
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
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type cb_1 from commandbutton within w_mat_01010
integer x = 3237
integer y = 184
integer width = 530
integer height = 104
integer taborder = 100
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "LOT No. 재 생성"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_list.RowCount()
If ll_cnt < 1 Then Return

Long   i
String ls_itnbr
String ls_ittyp
String ls_lot

String ls_dat

ls_dat = dw_detail.GetItemString(1, 'sdate')

MessageBox('입고 LOT No. 생성', '품목구분이 원자재 COIL인 품목만 생성 됩니다!!')

String  ls_max
String  ls_iogbn

ls_iogbn = dw_detail.GetItemString(1, 'gubun')
Choose Case ls_iogbn
	Case 'I01', 'I03'
		SELECT MAX(LOTSNO)
		  INTO :ls_max
		  FROM IMHIST
		 WHERE SABU  =  :gs_sabu
			AND IOGBN IN ('I01', 'I03')
			AND SUDAT =  :ls_dat ;
	Case 'IM2'
		SELECT MAX(LOTSNO)
		  INTO :ls_max
		  FROM IMHIST
		 WHERE SABU  =  :gs_sabu
			AND IOGBN =  'IM2'
			AND SUDAT =  :ls_dat ;
End Choose
	
If Trim(ls_max) = '' OR IsNull(ls_max) Then
	ls_max = '001'
Else
	ls_max = String(Long(RIGHT(ls_max, 3)) + 1, '000')
End If

For i = 1 To ll_cnt
	ls_itnbr = dw_list.GetItemString(i, 'itnbr')
	
	SELECT ITTYP
	  INTO :ls_ittyp
	  FROM ITEMAS
	 WHERE ITNBR = :ls_itnbr ;
	 
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then Return
	
	If ls_ittyp = '3' AND LEFT(ls_itnbr, 1) = 'C' Then
		If ls_iogbn = 'IM2' Then
			dw_list.SetItem(i, 'lotsno', 'F' + ls_dat + ls_max)
		Else
			dw_list.SetItem(i, 'lotsno', ls_dat + ls_max)
		End If
		ls_max = String(Long(ls_max) + 1, '000')		
	End If
Next
end event

type p_bar from uo_picture within w_mat_01010
boolean visible = false
integer x = 2775
integer y = 184
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\barcode.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

setnull(gs_code)
if dw_detail.accepttext() = -1 then return 
gs_code = dw_detail.GetItemString(1, 'jpno')

//바코드 출력 선택 WINDOW OPEN
open(w_mat_01010_barcode)
end event

event ue_lbuttondown;call super::ue_lbuttondown;//PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;//PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type pb_1 from u_pb_cal within w_mat_01010
integer x = 869
integer y = 32
integer taborder = 20
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type p_print from uo_picture within w_mat_01010
integer x = 4055
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

event clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sJpno

sJpno  = dw_detail.getitemstring(1, "jpno")

// 전표번호
IF IsNull(sJpno)	or   trim(sJpno) = ''	THEN
	f_message_chk(30,'[입고번호]')
	dw_detail.Setcolumn("jpno")
	dw_detail.setfocus()
	RETURN 
END IF

//////////////////////////////////////////////////////////////////////////

sJpno = sJpno + '%'

IF	dw_print.Retrieve(gs_sabu, sjpno) <	1	THEN
	f_message_chk(50, '[입고내역]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	RETURN
END IF

dw_print.print()
end event

type p_2 from uo_picture within w_mat_01010
boolean visible = false
integer x = 2953
integer y = 4
integer width = 178
integer taborder = 100
string pointer = "c:\ERPMAN\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\재고조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고조회_up.gif"
end event

event clicked;call super::clicked;long lRow

if dw_list.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('확 인', '조회할 자료를 선택하세요!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')
IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[품번]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF

gs_gubun = dw_list.getitemstring(lRow, 'depot_no')

// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
gs_codename = 'N' 
open(w_stock_popup)
end event

type p_copy from uo_picture within w_mat_01010
boolean visible = false
integer x = 2775
integer y = 4
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\복사_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event clicked;call super::clicked;string snull
long   k
datawindowchild dws

Setnull(snull)

if dw_detail.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

IF MessageBox("확 인", "현재 자료를 복사 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_copy.reset()

FOR k = 1 TO dw_list.Rowcount()
	dw_copy.insertrow(k)
	dw_copy.setitem(k, 'itnbr', dw_list.getitemstring(k, 'itnbr'))
	dw_copy.setitem(k, 'itemas_itdsc', dw_list.getitemstring(k, 'itemas_itdsc'))
	dw_copy.setitem(k, 'itemas_ispec', dw_list.getitemstring(k, 'itemas_ispec'))
	dw_copy.setitem(k, 'pspec', dw_list.getitemstring(k, 'pspec'))
	dw_copy.setitem(k, 'ioreqty', dw_list.getitemdecimal(k, 'ioreqty'))
	dw_copy.setitem(k, 'insemp', dw_list.getitemstring(k, 'insemp'))
	dw_copy.setitem(k, 'depot_no', dw_list.getitemstring(k, 'depot_no'))
	dw_copy.setitem(k, 'vndmst_cvnas2', dw_list.getitemstring(k, 'vndmst_cvnas2'))
	dw_copy.setitem(k, 'bigo', dw_list.getitemstring(k, 'bigo'))
	dw_copy.setitem(k, 'gurdat', dw_list.getitemstring(k, 'gurdat'))
	dw_copy.setitem(k, 'qcgub', dw_list.getitemstring(k, 'qcgub'))
NEXT

ic_status = '1'	// 등록

dw_detail.setredraw(false)
dw_list.setredraw(false)

dw_list.DataObject = 'd_mat_01011'
dw_list.SetTransObject(SQLCA)
dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

dw_copy.RowsCopy(1, dw_copy.RowCount(), Primary!, dw_list, 1, Primary!)

dw_list.getchild("qcgub", dws)
dws.settransobject(sqlca)
dws.retrieve()

dw_imhist.reset()
dw_copy.reset()

dw_detail.enabled = TRUE
p_delete.enabled = false
p_copy.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true
p_inq.enabled = false

dw_detail.settaborder("jpno",  0)
dw_detail.setitem(1, "jpno",  snull)
dw_detail.settaborder("sdate", 10)
dw_detail.settaborder("empno", 20)
dw_detail.settaborder("gubun", 30)
dw_detail.settaborder("dept",  40)
dw_detail.settaborder("cvcod", 50)

dw_detail.setcolumn("empno")
dw_detail.setfocus()
	
w_mdi_frame.sle_msg.text = "등록"
dw_detail.setredraw(true)
dw_list.setredraw(true)


end event

type p_exit from uo_picture within w_mat_01010
integer x = 4402
integer y = 4
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_cancel from uo_picture within w_mat_01010
integer x = 4229
integer y = 4
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_delete from uo_picture within w_mat_01010
integer x = 3877
integer y = 4
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
int i

if ic_status = '2' then 
	FOR i=1 TO dw_list.rowcount() 
		if ic_status = '2' then 
			IF dw_list.getitemstring(i, 'schk3') = 'N' then 
				messagebox("확 인", "송장발행된 자료는 삭제 할 수 없습니다.")
				return 
			end if
		
			IF dw_list.getitemstring(i, 'schk2') = 'N' then 
				messagebox("확 인", "수불승인된 자료는 삭제 할 수 없습니다.")
				return 
			end if
			 
			if dw_list.getitemstring(i, 'schk') = 'N' then 
				messagebox("확 인", "검사완료된 자료는 삭제할 수 없습니다.")
				return  
			end if	 
		end if
	NEXT
end if


IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN

IF dw_list.Update() >= 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_cancel.triggerevent(clicked!)

end event

type p_save from uo_picture within w_mat_01010
integer x = 3703
integer y = 4
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN


//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 입고수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
String sDate
long 	 dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 
	

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
   if	wf_imhist_create(sdate, dseq) < 0 then return 

	IF dw_imhist.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF
	

	MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r생성되었습니다.")

/////////////////////////////////////////////////////////////////////////
//	1. 수정 
/////////////////////////////////////////////////////////////////////////
ELSE

	IF wf_imhist_update() = -1	THEN RETURN

	IF dw_list.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

END IF


////////////////////////////////////////////////////////////////////////

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_inq from uo_picture within w_mat_01010
integer x = 3529
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;This.Enabled = False

if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sNull
long		lRow 
SetNull(sNull)

sJpno  = dw_detail.getitemstring(1, "jpno")

// 전표번호
IF IsNull(sJpno)	or   trim(sJpno) = ''	THEN
	f_message_chk(30,'[입고번호]')
	dw_detail.Setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

//////////////////////////////////////////////////////////////////////////

sJpno = sJpno + '%'

dw_list.setredraw(false)

IF	dw_list.Retrieve(gs_sabu, sjpno) <	1	THEN
	dw_list.setredraw(true)
	f_message_chk(50, '[입고내역]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN
END IF

wf_Update_Gubun()

dw_list.setredraw(true)
//////////////////////////////////////////////////////////////////////////
// 최종의뢰번호
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "iojpno")

dw_detail.enabled = false
p_delete.enabled = true
p_copy.enabled = true

p_addrow.enabled = true
p_delrow.enabled = true

dw_list.SetFocus()
//cb_save.enabled = true
This.Enabled = True

end event

type p_delrow from uo_picture within w_mat_01010
integer x = 3333
integer y = 4
integer width = 178
integer taborder = 120
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;
long	lrow
lRow = dw_list.GetSelectedRow(0)

IF lRow < 1		THEN	RETURN

if ic_status = '2' then 
   IF dw_list.getitemstring(lrow, 'schk3') = 'N' then 
		messagebox("확 인", "송장발행된 자료는 삭제 할 수 없습니다.")
		return 
	end if

   IF dw_list.getitemstring(lrow, 'schk2') = 'N' then 
		messagebox("확 인", "수불승인된 자료는 삭제 할 수 없습니다.")
		return 
	end if
	 
	if dw_list.getitemstring(lrow, 'schk') = 'N' then 
	   messagebox("확 인", "검사완료된 자료는 삭제할 수 없습니다.")
		return  
	end if	 
end if

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(lRow)


end event

type p_addrow from uo_picture within w_mat_01010
integer x = 3159
integer y = 4
integer width = 178
integer taborder = 110
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sDept, sDate, stime, stodate,		&
			sSaupj, sDepot_no
long		lRow
int		iCount

stoDate = trim(dw_detail.GetItemString(1, "sdate"))
sDept = dw_detail.GetItemString(1, "empno")

IF isnull(stoDate) or stoDate = "" 	THEN
	f_message_chk(30,'[입고의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 의뢰담당자
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[의뢰담당자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = dw_detail.GetItemString(1, "gubun")
// 입고구분
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[입고구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = dw_detail.GetItemString(1, "dept")
// 의뢰부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[의뢰부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = dw_detail.GetItemString(1, "cvcod")
// 의뢰거래처
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[거래처코드]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

sSaupj = dw_detail.GetItemString(1, "saupj")
sDepot_no = dw_detail.GetItemString(1, "depot_no")

IF isnull(sSaupj) or sSaupj = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sDepot_no) or sDepot_no = "" 	THEN
	f_message_chk(30,'[입고창고]')
	dw_detail.SetColumn("depot_no")
	dw_detail.SetFocus()
	RETURN
END IF




///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

// 검사요청일
stime = f_totime()
IF stime < '12'	THEN
	iCount = 1
ELSE
	iCount = 2
END IF

sDate = f_afterday(stodate, iCount)
dw_list.SetItem(lRow, "gurdat", sDate)
//dw_list.setitem(lrow, "insemp", is_custom)
SetNull(is_itnbr)

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

type dw_print from datawindow within w_mat_01010
boolean visible = false
integer x = 18
integer y = 604
integer width = 905
integer height = 96
boolean titlebar = true
string dataobject = "d_mat_01013"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_imhist from datawindow within w_mat_01010
boolean visible = false
integer x = 626
integer y = 2300
integer width = 494
integer height = 360
string dataobject = "d_pdt_imhist"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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

type dw_copy from datawindow within w_mat_01010
boolean visible = false
integer x = 18
integer y = 2332
integer width = 590
integer height = 240
string dataobject = "d_mat_01011"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_delete from radiobutton within w_mat_01010
integer x = 4233
integer y = 196
integer width = 242
integer height = 72
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

dw_list.DataObject = 'd_mat_01012'
dw_list.SetTransObject(SQLCA)

dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

p_inq.enabled = true

p_addrow.enabled = false
p_delrow.enabled = false
end event

type rb_insert from radiobutton within w_mat_01010
integer x = 3918
integer y = 196
integer width = 242
integer height = 72
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

dw_list.DataObject = 'd_mat_01011'
dw_list.SetTransObject(SQLCA)

dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

p_inq.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true


end event

type dw_detail from datawindow within w_mat_01010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 8
integer width = 2633
integer height = 376
integer taborder = 10
string dataobject = "d_mat_01010"
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

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''


IF this.GetColumnName() = 'jpno'	THEN

	gs_gubun = '009'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")

// 입고의뢰담당자
ELSEIF this.GetColumnName() = 'empno'	THEN
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"empno",	gs_code)
	this.TriggerEvent("itemchanged")
// 부서
ELSEIF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",	gs_code)
	SetItem(1,"deptname", gs_codename)

// 거래처
ELSEIF this.GetColumnName() = 'cvcod'	THEN

	string	sCheck, sIogbn
	sIogbn = THIS.getitemstring(1, "gubun")

	if sIogbn = "" or isnull(sIogbn) then 
		messagebox('확 인', '입고구분을 먼저 입력하세요!')
		this.setitem(1, 'cvcod', siogbn)
		this.setitem(1, 'cvnas', siogbn)
		return 1
	end if

	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck  //관련처코드(1:창고, 2:부서, 3:거래처, 4:창고+부서, 5:ALL)
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case else
					f_message_chk(208,'[거래처]')
					this.setitem(1, 'cvcod', "")
					this.setitem(1, 'cvnas', "")
				   return 1
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas", gs_codename)
	this.TriggerEvent("itemchanged")

END IF

end event

event itemchanged;string	sEmpno, 			&
			sEmpName,		&
			sDept,			&
			sDeptName,		&
			sDate,			&
			sGubun,			&
			sJpno,			&
			sDepot_no,		&
			sSaupj,			&
			sNull, scvcod, scvnas, scode, sname1, sname2
int      ireturn, ilen 			
			
SetNull(sNull)

// 입고의뢰일자
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고의뢰일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF

//////////////////////////////////////////////////////////////////////////
// 담당자
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetcolumnName() = 'empno'	THEN
	
	scode = this.GetText()								
	
   ireturn = f_get_name2('사번', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname1)
	
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :sDept, :sDeptName
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', sDept)
		this.setitem(1, 'deptname', sDeptName)
		
		/* 임시로 셋팅 adt */
		this.setitem(1, 'cvcod', sDept)
		this.setitem(1, 'cvnas', sDeptName)
   END IF
   return ireturn 
//////////////////////////////////////////////////////////////////////////
// 입고의뢰부서
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "dept" THEN
	scode = this.GetText()								
	
   ireturn = f_get_name2('부서', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'dept', scode)
	this.setitem(1, 'deptname', sname1)
   return ireturn 
//////////////////////////////////////////////////////////////////////////
// 입고구분
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "gubun" THEN
	this.setitem(1, 'cvnas', snull)
	this.setitem(1, 'cvcod', snull)
//////////////////////////////////////////////////////////////////////////
// 거래처(관련처)
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "cvcod" THEN
	sCvcod  = trim(this.GetText())						
	if sCvcod = "" or isnull(scvcod) then 
		this.setitem(1, 'cvnas', snull)
		return 
	end if

	sGubun = this.getitemstring(1, "gubun")
	
	if sGubun = "" or isnull(sGubun) then 
		messagebox('확 인', '입고구분을 먼저 입력하세요!')
		this.setitem(1, 'cvcod', snull)
		this.setitem(1, 'cvnas', snull)
		return 1
	end if

	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :sCode FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sGubun;
	    
	string	sgbn1, sgbn2, sgbn3, sgbn4, sgbn5

	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case sCode //관련처코드(1:창고, 2:부서, 3:거래처, 4:창고+부서, 5:ALL)
			 case '1'
					sgbn1 = '5'; sgbn2 = '5'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '2'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '4'; sgbn4 = '4'; sgbn5 = '4'
			 case '3'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '9'; sgbn4 = '9'; sgbn5 = '9'
			 case '4'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '5'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '4'; sgbn4 = '5'; sgbn5 = '9'
			 case else
					f_message_chk(208,'[거래처]')
					this.setitem(1, 'cvcod', snull)
					this.setitem(1, 'cvnas', snull)
				   return 1
	End choose

	SELECT "CVNAS2"
	  INTO :sName1
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sCvcod  AND "CVSTATUS" <> '2'
		AND "CVGU"  IN (:sgbn1, :sgbn2, :sgbn3, :sgbn4, :sgbn5) ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[거래처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
	   return 1
	ELSE
		this.setitem(1, 'cvnas', sName1)
	END IF

//////////////////////////////////////////////////////////////////////////
// 전표번호
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = this.GetText()
	
	if sJpno = '' or isnull(sJpno) then 
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)	
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)	
		return 
   end if	
   ilen = len(sJpno)
	
	if ilen < 12 then 
		f_message_chk(33,'[입고번호]')
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)	
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)	
		this.SetItem(1, "jpno",	sNull)
		return 1
   end if	
	
	SELECT A.SUDAT,  A.IOREEMP,
			 A.IOGBN,  A.IOREDEPT, 
			 B.CVNAS2, D.EMPNAME, A.CVCOD, E.CVNAS,
			 A.DEPOT_NO,
			 A.SAUPJ
	  INTO :sDate, :sEmpno, 
	  		 :sGubun, :sDept, 
	  		 :sDeptName, :sEmpName, :SCVCOD, :SCVNAS,
			 :sDepot_no,
			 :sSaupj
	  FROM IMHIST A, VNDMST B, P1_MASTER D, VNDMST E
	 WHERE A.SABU     = :gs_sabu			AND
	 		 A.IOJPNO   LIKE :sJpno||'%'		AND
			 A.JNPCRT   = '009' AND
			 A.IOREDEPT = B.CVCOD(+) AND
			 A.IOREEMP  = D.EMPNO(+) AND
			 A.CVCOD		= E.CVCOD(+) AND ROWNUM = 1 ;
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[입고번호]')
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)	
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)	
		this.SetItem(1, "jpno",	sNull)
		RETURN 1
	END IF

	this.SetItem(1, "sdate",   sDate)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "dept",  	sDept)
	this.SetItem(1, "deptname",sDeptName)
	this.SetItem(1, "gubun",   sGUBUN)	
	this.SetItem(1, "cvcod",  	scvcod)
	this.SetItem(1, "cvnas",	scvnas)	
	this.SetItem(1, "depot_no",  	sDepot_no)
	this.SetItem(1, "saupj",	sSaupj)	
ELSEIF this.GetColumnName() = 'saupj'	THEN
	scode = this.GetText()								
	//사업장
	f_child_saupj(dw_detail, 'depot_no',scode )
END IF


end event

type gb_2 from groupbox within w_mat_01010
integer x = 3840
integer y = 140
integer width = 731
integer height = 152
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_mat_01010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 384
integer width = 4530
integer height = 1828
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_mat_01010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 392
integer width = 4507
integer height = 1808
integer taborder = 30
string dataobject = "d_mat_01011"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;Long lrow
lrow = this.getrow()

if key = keyenter! then
	if this.getcolumnname()   = "qcgub" then
		if this.rowcount()   <> this.getrow() then return
	   p_addrow.triggerevent(clicked!)
		post function wf_focus()
	end if
end if


IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

setnull(gs_code)

IF keydown(keyF3!) THEN
	IF This.GetColumnName() = "itnbr" Then
		gs_codename = dw_detail.GetItemString(1,"cvcod")
		open(w_itmbuy2_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(lrow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF
end event

event itemchanged;dec{3}	dInqty,  dQty, ncnt
long		lRow, 	lReturnRow
string	sCode, sName, sitmsht, sqcgbn, sLotyn,	&
			sItem, sSpec,	sJijil, sSpec_code,	&
			sItgu, sDate, 	&
			sNull, sqcgub, sqcemp, scvcod, sPdtgu, sLotgub, ls_itnbr, sPanel, sPinbr, sPspec
integer  ireturn
SetNull(sNull)

lRow  = this.GetRow()	

scvcod = dw_detail.getitemstring(1, 'cvcod')

IF this.GetColumnName() = 'itnbr' THEN
	sItem = trim(THIS.GETTEXT())						
	ireturn = f_get_name4('품번', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 

 	ib_changed = true
	is_itnbr   = sitem

	SetNull(sPinbr)
	SetNull(sPanel)
	SetItem(lRow, "itemas_itdsc", sName)
	SetItem(lRow, "itemas_ispec", sSpec)
	SetItem(lRow, "itemas_jijil", sJijil)
	SetItem(lRow, "itemas_ispec_code", sSpec_code)
	
	SELECT a.lotgub, b.itm_shtnm, c.grpno2
	  into :slotyn, :sitmsht, :sqcgbn
	  from itemas a, itmsht b, itemas_inspection c
	 where a.itnbr = b.itnbr
	   and a.itnbr = c.itnbr
		and a.itnbr = :sItem
		and b.saupj = :gs_saupj;
		
	SetItem(lRow, "itm_shtnm", sitmsht)
	SetItem(lRow, "lotgub",    slotyn)
	SetItem(lRow, "grpno2",    sqcgbn)
	
	if not isnull(sitem) then 
		if sqcgbn = 'Y' then   // 입고후 검사품일 경우 무검사 셋팅
			this.SetItem(lRow, "qcgub", '1')
			this.SetItem(lRow, "insemp", sNull)
		else
			// 임시로 무검사로 지정한다
			this.SetItem(lRow, "qcgub", '1')
			this.SetItem(lRow, "insemp", sNull)
//			F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
//			this.SetItem(lRow, "qcgub", sqcgub)
//			this.SetItem(lRow, "insemp", sqcemp)
		end if
   end if
	
	RETURN ireturn
ElseIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	setitem(lrow, "itnbr", sitem)	
	setitem(lrow, "itemas_itdsc", sname)	
	setitem(lrow, "itemas_ispec", sspec)
	setItem(lRow, "itemas_jijil", sJijil)
	SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgub", sqcgub)
		this.SetItem(lRow, "insemp", sqcemp)
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
   setitem(lrow, "itnbr", sitem)	
	setitem(lrow, "itemas_itdsc", sname)	
	setitem(lrow, "itemas_ispec", sspec)
	SetItem(lRow, "itemas_jijil", sJijil)
	SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		SetItem(lRow, "qcgub", sqcgub)
		SetItem(lRow, "insemp", sqcemp)
   	setitem(lrow, "itnbr", sitem)
	end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	setitem(lrow, "itnbr", sitem)	
	setitem(lrow, "itemas_itdsc", sname)	
	setitem(lrow, "itemas_ispec", sspec)
	SetItem(lRow, "itemas_jijil", sJijil)
	SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgub", sqcgub)
		this.SetItem(lRow, "insemp", sqcemp)
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sspec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgub", sqcgub)
		this.SetItem(lRow, "insemp", sqcemp)
   end if		
	RETURN ireturn
//////////////////////////////////////////////////////////////////////////
// 입고처
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "depot_no" THEN
	
	sCode = this.GetText()								
   SELECT CVNAS2
     INTO :sName
     FROM "VNDMST" 
    WHERE CVCOD = :sCode	AND
	 		 CVGU = '5' 		AND
			 CVSTATUS = '0' ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[입고창고]')		
		this.SetItem(lRow, "depot_no", sNull)
		this.setitem(lRow, 'vndmst_cvnas2', sNull)		
	   return 1
	ELSE
		this.setitem(lRow, 'vndmst_cvnas2', sName)
   END IF
// 검사요청일
ELSEIF this.GetColumnName() = 'gurdat' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1 then
		this.setitem(lRow, "gurdat", sNull)
		return 1
	END IF
// 검사구분
ELSEif this.getcolumnname() = 'qcgub' then
	scode = this.gettext()
	// 무검사인 경우에는 검사담당자를 null로 setting
	if scode = '1' then
		this.setitem(lrow, "insemp", snull)
		this.setitem(lRow, "gurdat", sNull)
	else
		this.setitem(lRow, "gurdat", is_today)
	end if
// 의뢰수량
ELSEif this.getcolumnname() = 'ioreqty' then
	sPanel = GetItemString(lRow, "rmark2")

	// 판넬인 경우 BOX NO를 채번한다
	If ( sPanel = 'L' or sPanel = 'S' ) Then
		sPspec = GetItemString(lRow, "pspec")
		If IsNull(sPspec) Or sPspec = '.' Then
			SetItem(lRow, 'pspec', wf_boxno())
		End If
	End If
end if
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
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(lRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = 'depot_no'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(lRow,"depot_no", gs_code)
	this.SetItem(lRow,"vndmst_cvnas2", gs_codename)

	this.TriggerEvent("itemchanged")
END IF



end event

event retrieverow;//string	sQcgubun, sQcdate, sIoConfirm, sIoDate, siojpno
//long     lcount
//
///* 수정인 경우에만 check */
//if ic_status <> '1' then
//
//	if row > 0 then 
//		// 검사구분, 검사일자입력시 수정불가
//		sQcgubun = dw_list.GetItemString(row, "qcgub")
//		sQcdate  = dw_list.GetItemString(row, "insdat")
//		IF sQcgubun > '1'	THEN
//			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(row, "schk", 'N')
//		END IF
//		
//		// 수불승인여부, 수불일자입력시 수정불가
//		sIoConfirm = dw_list.GetItemString(row, "io_confirm")
//		sIoDate    = dw_list.GetItemString(row, "io_date")
//		IF sIoConfirm = 'N'	THEN
//			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(row, "schk2", 'N')
//		END IF
//		
//		siojpno = this.getitemstring(row, 'iojpno')
//
//	end if
//end if
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

event itemfocuschanged;If ib_changed = True Then
	this.setItem( row, 'itnbr', is_itnbr)
	ib_changed = False
	return
End If
end event

event rowfocuschanged;If currentrow > 0 then
	selectrow(0,false)
	selectrow(currentrow, true)
Else
	selectrow(0,false)
End If
end event

event clicked;If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
Else
	selectrow(0,false)
End If
end event

