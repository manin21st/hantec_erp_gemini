$PBExportHeader$w_mat_01020_banpum2.srw
$PBExportComments$** 공정검사승인
forward
global type w_mat_01020_banpum2 from w_inherite
end type
type dw_1 from datawindow within w_mat_01020_banpum2
end type
type rb_1 from radiobutton within w_mat_01020_banpum2
end type
type rb_2 from radiobutton within w_mat_01020_banpum2
end type
type rb_3 from radiobutton within w_mat_01020_banpum2
end type
type rb_4 from radiobutton within w_mat_01020_banpum2
end type
type p_1 from picture within w_mat_01020_banpum2
end type
type dw_imhist from datawindow within w_mat_01020_banpum2
end type
type p_2 from picture within w_mat_01020_banpum2
end type
type rr_1 from roundrectangle within w_mat_01020_banpum2
end type
end forward

global type w_mat_01020_banpum2 from w_inherite
integer width = 4681
integer height = 2780
string title = "공정 검사 승인"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
p_1 p_1
dw_imhist dw_imhist
p_2 p_2
rr_1 rr_1
end type
global w_mat_01020_banpum2 w_mat_01020_banpum2

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" alias for "ShellExecuteA;Ansi" 
end prototypes

forward prototypes
public function integer wf_imhist_o10_insert ()
public function integer wf_qchist_insert ()
end prototypes

public function integer wf_imhist_o10_insert ();////////////////////////////////////////////////////////////////////////////
string	sGubun, sNull, sIojpno
long		lRow
dec  {3}	dQty, dBadQty

//==============================================================================
long		i, k, ll_maxjpno, ll_cnt
string	ls_sudat, ls_saupj, ls_depot, ls_cvcod, ls_iogbn, ls_jpno,	ls_jnpcrt


dw_imhist.reset()

ls_sudat = f_today()
ls_saupj = gs_saupj

// 폐기 구분이 있는 경우 전표채번
IF dw_insert.Find("shpfat_gugub = '2'", 1, dw_insert.RowCount()) > 0 THEN

	ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
	IF ll_maxjpno <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		Return -1
	END IF
	//commit;
	
	ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
		f_message_chk(51,'[전표번호]')
		Return -1
	End If
END IF
//==============================================================================

String  ls_wkctr
String  ls_pdtgu
String  ls_rfna2

FOR lRow = 1	TO	dw_insert.RowCount()

	sGubun = dw_insert.GetItemString(lRow, "shpfat_gugub")

	IF sGubun = '2' THEN
		dBadQty = dw_insert.GetItemDecimal(lRow, "shpfat_guqty")

		////////////////////////////////////////////////////////////////////////////////////////
		// 폐기출고 전표 생성 - 2008.03.25 - 송병호
		// (삭제 처리는 SHPFAT 트리거에서 됨)
		/////////////////////////////////////////////////////////////////////////////////////////
		IF dBadQty > 0 THEN
			
			/* 다중 사업장 사용으로 출고창고는 발생사업장의 창고로 지정 - by shingoon 2016.01.20 ********************************/
			//ls_depot = 'Z99'  	// 출고 창고
			ls_wkctr = dw_insert.GetItemString(lRow, 'shpact_wkctr')
			SELECT PDTGU INTO :ls_pdtgu FROM WRKCTR WHERE WKCTR = :ls_wkctr ;
			SELECT RFNA2 INTO :ls_rfna2 FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :ls_pdtgu ;
			SELECT CVCOD INTO :ls_depot FROM VNDMST WHERE CVGU = '5' AND SOGUAN = '4' AND IPJOGUN = :ls_rfna2 AND ROWNUM = 1 ;
			/********************************************************************************************************************/
			
			ls_cvcod	= gs_dept  	// 폐기 부서			
			ls_iogbn = 'O10'	 	// 폐기
			ls_jnpcrt= '001'
			
			k++
			i = dw_imhist.insertrow(0)
			
			dw_imhist.SetItem(i,"sabu",       gs_sabu)
			dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(k,'000'))
			dw_imhist.SetItem(i,"iogbn",      ls_iogbn)
			dw_imhist.SetItem(i,"itnbr",      dw_insert.GetItemString(lRow,'shpact_itnbr'))
			dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
			dw_imhist.SetItem(i,"pspec",   	'.')
			dw_imhist.SetItem(i,"opseq",		'9999')
			dw_imhist.SetItem(i,"depot_no",   ls_depot)				// 불량창고
			dw_imhist.SetItem(i,"cvcod",      ls_cvcod)				
			dw_imhist.SetItem(i,"io_confirm", 'Y')
			dw_imhist.SetItem(i,"filsk",      'Y') 	     // 재고관리유무
			dw_imhist.SetItem(i,"ioredept",   gs_dept)
			dw_imhist.SetItem(i,"ioreemp",    gs_empno)
			dw_imhist.SetItem(i,"saupj",      ls_saupj)
			dw_imhist.SetItem(i,"inpcnf", 	 'O')   					// 입출고구분(입고)
			dw_imhist.SetItem(i,"outchk",		 'N')
			dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt)	
//			dw_imhist.SetItem(i,"bigo",	 	 dw_insert.GetItemString(lRow,'imhist_bigo'))
			
			dw_imhist.SetItem(i,"ioreqty",    dBadQty)
			dw_imhist.SetItem(i,"ioqty",      dBadQty)
			dw_imhist.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
			dw_imhist.SetItem(i,"iosuqty",    dBadQty) // 합격수량
			dw_imhist.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
			dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
			dw_imhist.SetItem(i,"qcgub",'1')
//			dw_imhist.SetItem(i,"ip_jpno",	 sIojpno)

			dw_insert.SetItem(lRow, "shpfat_iojpno", ls_jpno+String(k,'000'))            // 폐기전표기록
		ELSE
			dw_insert.SetItem(lRow, "shpfat_iojpno", "")            // 폐기전표기록
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


RETURN 0
end function

public function integer wf_qchist_insert ();//발생번호 생성
String ls_day
ls_day = String(TODAY(), 'yyyymm')

String ls_max
SELECT MAX(SUBSTR(CLAJPNO, 7, 3))
  INTO :ls_max
  FROM QCHIST
 WHERE CLAJPNO LIKE :ls_day||'%';

Long   ll_max
If Trim(ls_max) = '' OR IsNull(ls_max) Then
	ll_max = 1
Else
	ll_max = Long(ls_max) + 1
End If

Long   ll_cnt
ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return 0

Long    i
Long    ll_guqty
Long    ll_err
String  ls_err
String  ls_jpno
String  ls_shpjpno
String  ls_sidat
String  ls_itnbr
String  ls_gucod
String  ls_respo
String  ls_saupj
String  ls_chk
dwItemStatus l_sts
For i = 1 To ll_cnt
	ls_jpno    = ls_day + String(ll_max, '000')               //발생번호
	ls_shpjpno = dw_insert.GetItemString(i, 'shpact_shpjpno') //생산실적번호
	ls_sidat   = dw_insert.GetItemString(i, 'shpact_sidat'  ) //발생일자
	ls_itnbr   = dw_insert.GetItemString(i, 'shpact_itnbr'  ) //품번
	ls_gucod   = dw_insert.GetItemString(i, 'shpfat_gucod'  ) //불량유형(33)
	ll_guqty   = dw_insert.GetItemNumber(i, 'shpfat_guqty'  ) //발생수량
	ls_respo   = dw_insert.GetItemString(i, 'shpfat_scode2' ) //귀책처
	
	/* 귀책처 입력이 없으면 Continue */
	If Trim(ls_respo) = '' OR IsNull(ls_respo) Then	Continue
	
	/* 변경사항이 없으면 Continue */
	l_sts = dw_insert.GetItemStatus(i, 'shpfat_scode2', Primary!)
	If l_sts = NotModified! Then Continue
	
	/* 이미 등록된 자료이면 Continue */
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_chk
	  FROM QCHIST
	 WHERE LOTNO = :ls_shpjpno ;
	If ls_chk = 'Y' Then Continue
	
	/* 품번의 생산팀 사업장 */
	SELECT B.RFNA2 INTO :ls_saupj
	  FROM ITEMAS A, ( SELECT SABU, RFGUB, RFNA2 FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' ) B
	 WHERE A.SABU = :gs_sabu AND A.ITNBR = :ls_itnbr AND A.SABU = B.SABU AND A.PDTGU = B.RFGUB ;
	
	/* 품질이력 전송 */
	/* 발생번호, 발생구분(M:사내불만), 등록자, 발생일자, 품번, 불량유형(33), 발생수량, 발생장소(09), 담당자, 대응자, 불량내용, 귀책처, 사업장, 생산실적번호 */
	INSERT INTO QCHIST
	( CLAJPNO, CLAGBN, INS_EMP, CLADATE, ITNBR, FATYPE, CLAQTY, JODESC, CARCO, BALEMPNO, CLADESC, RESPOFC, SAUPJ, LOTNO )
	VALUES
	(:ls_jpno, 'M', :gs_empno, :ls_sidat, :ls_itnbr, :ls_gucod, :ll_guqty, NULL, NULL, NULL, NULL, :ls_respo, :ls_saupj, :ls_shpjpno);
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Insert Err[' + String(ll_err) + ']', '품질이력 전송 중 오류가 발생 했습니다.~r~n' + ls_err)
		Return -1
	End If
	/*
	--발생번호 : MAX생성
	--발생구분 : 'M'
	--등록자  : gs_empno
	--발생일자 : SHPACT_SIDAT
	--품번    : SHPACT_ITNBR
	--불량유형 : SHPFAT_GUCOD
	--발생수량 : SHPFAT_GUQTY
	--발생장소 : -
	--담당자  : -
	--대응자  : -
	--불량내용 : -
	--귀책처  : SHPFAT_SCODE2
	--사업장  : 품번의 사업장
	*/
	
	ll_max = ll_max + 1
	
Next

Return 1
end function

on w_mat_01020_banpum2.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.p_1=create p_1
this.dw_imhist=create dw_imhist
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.dw_imhist
this.Control[iCurrent+8]=this.p_2
this.Control[iCurrent+9]=this.rr_1
end on

on w_mat_01020_banpum2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.p_1)
destroy(this.dw_imhist)
destroy(this.p_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(SQLCA)
dw_insert.settransobject(SQLCA)
dw_imhist.settransobject(sqlca)

dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
dw_1.SetItem(1, 'okdate', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_1.SetItem(1, 'stim', ls_st)
dw_1.SetItem(1, 'etim', ls_ed)
end event

type dw_insert from w_inherite`dw_insert within w_mat_01020_banpum2
integer x = 32
integer y = 216
integer width = 4558
integer height = 2064
integer taborder = 20
string dataobject = "d_mat_01020_banpum2_l"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;Long		ll_row
String	ls_baldat, ls_yn, ls_cod, ls_nam, ls_null
//AcceptText()

SetNull(ls_null)

ll_row = GetRow()
If GetColumnName() = "submit_dt" Then
	
	ls_baldat = Trim(GetText())
	if isnull(ls_baldat) or ls_baldat = '' then return
	
	if f_datechk(ls_baldat) = -1 then
		messagebox('확인','날짜 지정 오류!!!')
		return 1
	end if
		
ElseIf GetColumnName() = "jochwdat" Then
	
	ls_baldat = Trim(GetText())
	if isnull(ls_baldat) or ls_baldat = '' then return
	
	if f_datechk(ls_baldat) = -1 then
		messagebox('확인','날짜 지정 오류!!!')
		SetFocus()
		return 1
	end if

ElseIf GetColumnName() = "shpfat_scode2" Then
	
	ls_cod = Trim(GetText())
	if isnull(ls_cod) or ls_cod = '' then 
		SetItem(ll_row, 'sname', ls_null)
		return
	end if
	
	select cvnas2 into :ls_nam from vndmst where cvcod = :ls_cod ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','귀책처 지정 오류!!!')
		SetItem(ll_row, 'shpfat_scode2', ls_null)
		SetItem(ll_row, 'sname', ls_null)
		return
	end if
	
	SetItem(ll_row, 'sname', ls_nam)
End if

end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::clicked;call super::clicked;//If row > 0 Then
//	If isSelected(row) Then
//		SelectRow(row, False)
//	Else
//		SelectRow(0, False)
//		SelectRow(row, True)
//	End If
//End If

f_multi_select(this)
end event

event dw_insert::rbuttondown;call super::rbuttondown;
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'shpfat_scode2' THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(row,'shpfat_scode2',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

type p_delrow from w_inherite`p_delrow within w_mat_01020_banpum2
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_01020_banpum2
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_01020_banpum2
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mat_01020_banpum2
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mat_01020_banpum2
integer x = 4425
end type

type p_can from w_inherite`p_can within w_mat_01020_banpum2
integer x = 4251
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_mat_01020_banpum2
boolean visible = false
integer x = 4827
integer y = 132
end type

event p_print::clicked;call super::clicked;//if dw_1.accepttext() = -1 then return
//
//gs_code  	 = dw_1.getitemstring(1, "sdate")
//gs_codename  = dw_1.getitemstring(1, "edate")
//
//if isnull(gs_code) or trim(gs_code) = '' then
//	gs_code = '10000101'
//end if
//
//if isnull(gs_codename) or trim(gs_codename) = '' then
//	gs_codename = '99991231'
//end if
//
//open(w_qct_01075_1)
//
//Setnull(gs_code)
//Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_mat_01020_banpum2
integer x = 3904
end type

event p_inq::clicked;dw_1.AcceptText()

String ls_st, ls_ed, ls_jocod, ls_gubun

ls_st = dw_1.GetItemString(1, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_1.SetColumn('d_st')
		dw_1.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_1.GetItemString(1, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_1.SetColumn('d_ed')
		dw_1.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return -1
End If

String ls_stim

ls_stim = dw_1.GetItemString(1, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_1.GetItemString(1, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

ls_jocod = dw_1.GetItemString(1, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

ls_gubun = dw_1.GetItemString(1, 'gubun')

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(ls_st, ls_ed, ls_jocod, ls_gubun, ls_stim, ls_etim) <= 0 Then
   f_message_chk(50, '[공정 검사 승인]')
End If

dw_insert.Setredraw(True)
end event

type p_del from w_inherite`p_del within w_mat_01020_banpum2
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_mat_01020_banpum2
boolean visible = false
integer x = 4078
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_mod::clicked;//If dw_insert.AcceptText() < 1 Then Return
//If dw_insert.RowCount() < 1 Then Return
//
//If f_msg_update() < 1 Then Return
//
//setpointer(hourglass!)
//
////---------------------------------------------------------------------------
//// 폐기자료 생성
//if wf_imhist_o10_insert() < 0 then
//	messagebox("확인", "폐기자료 생성 실패(1)!!!")
//	return
//end if
//
///* 품질이력에 등록은 취소 함 - 각각의 현황이 존재하는데 굳이 품질이력에 수입검사, 공정검사, 사외검사 등의 내역을 등록할 필요가 없음.
//   한텍 내 업무인수인계 하면서 품질이력 등록에 사용자가 일일이 등록 하였음. - 2016.05.11 안병국 부장(5/10일 품질 미팅 중 요청) */
/////* 공정검사 자료를 품질이력에 자동 생성 */
////If wf_qchist_insert() < 0 Then
////	MessageBox('확인', '품질이력 자료 생성 실패(2)!!!')
////	Return
////End If
//
//if dw_insert.update() <> 1 then
//	rollback ;
//	messagebox("확인", "공정 검사 승인 저장 실패!!!")
//	return
//end if
//
//if dw_imhist.update() <> 1 then
//	rollback ;
//	messagebox("확인", "폐기자료 생성 실패(2)!!!")
//	return
//end if
//
//commit ;
//
//p_inq.TriggerEvent(Clicked!)
////////////////////////////////////////////////////////////////////////////////
//Long Lrow, Lgrow, Lfind
//String sItnbr, scustNo
//Dec    Lunprc
//
//dw_1.accepttext()
//dwname.setredraw(false)
//For Lrow = 1 to dw_1.rowcount()
//	
//	 if dw_1.getitemstring(Lrow, "gbn") = 'N' then continue
//
//	 // 구매반품인 경우
//	 If dwname.dataobject = 'd_mat_01021' then
//		 Lgrow =	dwname.insertrow(0)
//		 
//		 sItnbr = dw_1.getitemstring(Lrow, "itnbr")
//		 dwname.setitem(Lgrow, "itnbr", 			dw_1.getitemstring(Lrow, "itnbr"))
//		 dwname.setitem(Lgrow, "itemas_itdsc",	dw_1.getitemstring(Lrow, "itdsc"))
//		 dwname.setitem(Lgrow, "itemas_ispec",	dw_1.getitemstring(Lrow, "ispec"))
//		 dwname.setitem(Lgrow, "pspec", 			dw_1.getitemstring(Lrow, "pspec"))
//		 dwname.setitem(Lgrow, "depot_no",		isdepot)
//		 dwname.setitem(Lgrow, "lotsno", 		dw_1.getitemstring(Lrow, "lotno"))
//		 dwname.setitem(Lgrow, "ioqty", 			dw_1.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "jego_qty", 		dw_1.getitemdecimal(Lrow, "jego_qty"))
//		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_1.getitemstring(Lrow, "itm_shtnm"))
//		 dwname.setitem(Lgrow, "lotgub", 		dw_1.getitemstring(Lrow, "lotgub"))
//		 
//		/* 업체별 단가 */
//		Select Nvl(unprc, 0)	  Into :Lunprc	  From danmst
//		 Where itnbr  = :sItnbr	And cvcod  = :iscvcod	and rownum = 1	 Using sqlca;	
//		 dwname.setitem(Lgrow, "price", 			0)
//	 // 출고등록(직출)
//	 ElseIf dwname.dataobject = 'd_pdt_04035_1' Or dwname.dataobject = 'd_pdt_04035_han_1' Or &
//				dwname.dataobject = 'd_pdt_04036_2' Or dwname.dataobject = 'd_adt_00250_1' Then
//		 Lgrow =	dwname.insertrow(0)
//		
//		 dwname.setitem(Lgrow, "lotsno", 		dw_1.getitemstring(Lrow, "lotno"))
//		 dwname.setitem(Lgrow, "itnbr", 			dw_1.getitemstring(Lrow, "itnbr"))
//		 dwname.setitem(Lgrow, "itdsc", 			dw_1.getitemstring(Lrow, "itdsc"))
//		 dwname.setitem(Lgrow, "ispec", 			dw_1.getitemstring(Lrow, "ispec"))
//		 dwname.setitem(Lgrow, "jijil", 			dw_1.getitemstring(Lrow, "jijil"))
//		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_1.getitemstring(Lrow, "itm_shtnm"))
//		 dwname.setitem(Lgrow, "ispec_code",	dw_1.getitemstring(Lrow, "ispec_code"))
//		 dwname.setitem(Lgrow, "pspec", 			dw_1.getitemstring(Lrow, "pspec"))	 
//		 dwname.setitem(Lgrow, "jego_qty", 		dw_1.getitemdecimal(Lrow, "jego_qty"))
//		 dwname.setitem(Lgrow, "jego_temp", 	dw_1.getitemdecimal(Lrow, "jego_temp"))
//		 dwname.setitem(Lgrow, "valid_qty", 	dw_1.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "outqty", 		dw_1.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "lotgub", 		dw_1.getitemstring(Lrow, "lotgub"))
//		 dwname.setitem(Lgrow, "grpno2", 		dw_1.getitemstring(Lrow, "grpno2"))
//		 
//		 // 입고처를 찾지 못한경우 자사코드 입력
//		 sCustNo = Trim(dw_1.getitemstring(Lrow, "cust_no"))
//		 If IsNull(sCustNo) Or scustNo = '' Then sCustNo = isjasa
//			
//		 dwname.setitem(Lgrow, "cust_no",	sCustNo)		// 입고처(최초)
//	End If
//Next
//dwname.setredraw(true)
//Close(Parent)
//
end event

event p_mod::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event p_mod::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"

end event

type cb_exit from w_inherite`cb_exit within w_mat_01020_banpum2
end type

type cb_mod from w_inherite`cb_mod within w_mat_01020_banpum2
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_mat_01020_banpum2
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_mat_01020_banpum2
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_mat_01020_banpum2
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_mat_01020_banpum2
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_mat_01020_banpum2
end type

type cb_can from w_inherite`cb_can within w_mat_01020_banpum2
end type

type cb_search from w_inherite`cb_search within w_mat_01020_banpum2
end type







type gb_button1 from w_inherite`gb_button1 within w_mat_01020_banpum2
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_01020_banpum2
end type

type dw_1 from datawindow within w_mat_01020_banpum2
integer x = 14
integer y = 20
integer width = 3456
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mat_01020_banpum2_c"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, sdata , sname, scode
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
	
end if


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
END IF

IF this.GetColumnName() = 'd_st' THEN
	If Trim(data) = '' OR IsNull(data) Then Return
	
	If data = This.GetItemString(row, 'd_ed') Then
		This.SetItem(row, 'etim', '2400')
	Else
		This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
	End If
End If
		
IF this.GetColumnName() = 'd_ed' THEN
	If Trim(data) = '' OR IsNull(data) Then Return
	
	If data = This.GetItemString(row, 'd_st') Then
		This.SetItem(row, 'etim', '2400')
	Else
		This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
	End If
End If
end event

event itemerror;return 1
end event

event constructor;//this.settransobject(sqlca)
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

type rb_1 from radiobutton within w_mat_01020_banpum2
boolean visible = false
integer x = 4663
integer y = 424
integer width = 279
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
string text = "발행"
end type

type rb_2 from radiobutton within w_mat_01020_banpum2
boolean visible = false
integer x = 4663
integer y = 492
integer width = 279
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
string text = "미발행"
end type

type rb_3 from radiobutton within w_mat_01020_banpum2
boolean visible = false
integer x = 5001
integer y = 416
integer width = 279
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
string text = "검토중"
boolean checked = true
end type

type rb_4 from radiobutton within w_mat_01020_banpum2
boolean visible = false
integer x = 5033
integer y = 496
integer width = 279
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
string text = "전체"
end type

type p_1 from picture within w_mat_01020_banpum2
integer x = 3703
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\일괄지정_up.gif"
boolean focusrectangle = false
end type

event clicked;Long 		i
string 	ls_date

if dw_1.AcceptText() = -1 then return
if dw_insert.rowcount() <= 0 then return

ls_date = Trim(dw_1.Object.okdate[1])
if isnull(ls_date) or ls_date = '' then
else
	if f_datechk(ls_date) = -1 then
		messagebox('확인','승인일자가 잘못 지정되었습니다!!!')
		return
	end if
end if

if messagebox('확인','선택된 자료를 지정한 승인일자로 일괄 지정합니다.', &
					question!, yesno!, 1) = 2 then return

dw_insert.SetRedraw(FALSE)
For i = 1 To dw_insert.RowCount()	
	If dw_insert.isSelected(i) Then
		dw_insert.SetItem(i, 'shpfat_scode1', ls_date)
	End if		
Next

dw_insert.selectrow(0, false)
dw_insert.SetRedraw(TRUE)
end event

type dw_imhist from datawindow within w_mat_01020_banpum2
boolean visible = false
integer x = 3474
integer y = 32
integer width = 155
integer height = 120
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_imhist"
boolean border = false
boolean livescroll = true
end type

type p_2 from picture within w_mat_01020_banpum2
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4078
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\확인_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

event clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

//If f_msg_update() < 1 Then Return
//
//setpointer(hourglass!)
//
////---------------------------------------------------------------------------
//// 폐기자료 생성
//if wf_imhist_o10_insert() < 0 then
//	messagebox("확인", "폐기자료 생성 실패(1)!!!")
//	return
//end if
//
///* 품질이력에 등록은 취소 함 - 각각의 현황이 존재하는데 굳이 품질이력에 수입검사, 공정검사, 사외검사 등의 내역을 등록할 필요가 없음.
//   한텍 내 업무인수인계 하면서 품질이력 등록에 사용자가 일일이 등록 하였음. - 2016.05.11 안병국 부장(5/10일 품질 미팅 중 요청) */
/////* 공정검사 자료를 품질이력에 자동 생성 */
////If wf_qchist_insert() < 0 Then
////	MessageBox('확인', '품질이력 자료 생성 실패(2)!!!')
////	Return
////End If
//
//if dw_insert.update() <> 1 then
//	rollback ;
//	messagebox("확인", "공정 검사 승인 저장 실패!!!")
//	return
//end if
//
//if dw_imhist.update() <> 1 then
//	rollback ;
//	messagebox("확인", "폐기자료 생성 실패(2)!!!")
//	return
//end if
//
//commit ;
//
//p_inq.TriggerEvent(Clicked!)
////////////////////////////////////////////////////////////////////////////////
Long Lrow, Lgrow, Lfind
String sItnbr, scustNo
Dec    Lunprc

dw_insert.accepttext()
//dwname.setredraw(false)
For Lrow = 1 to dw_insert.rowcount()
	
	 if dw_insert.getitemstring(Lrow, "gbn") = 'N' then continue

	 // 구매반품인 경우
//	 If dwname.dataobject = 'd_mat_01020' then
//		 Lgrow =	dwname.insertrow(0)
//		 
//		 sItnbr = dw_insert.getitemstring(Lrow, "itnbr")
//		 dwname.setitem(Lgrow, "itnbr", 			dw_insert.getitemstring(Lrow, "itnbr"))
//		 dwname.setitem(Lgrow, "itemas_itdsc",	dw_insert.getitemstring(Lrow, "itdsc"))
//		 dwname.setitem(Lgrow, "itemas_ispec",	dw_insert.getitemstring(Lrow, "ispec"))
//		 dwname.setitem(Lgrow, "pspec", 			dw_insert.getitemstring(Lrow, "pspec"))
//		 dwname.setitem(Lgrow, "depot_no",		isdepot)
//		 dwname.setitem(Lgrow, "lotsno", 		dw_insert.getitemstring(Lrow, "lotno"))
//		 dwname.setitem(Lgrow, "ioqty", 			dw_insert.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "jego_qty", 		dw_insert.getitemdecimal(Lrow, "jego_qty"))
//		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_insert.getitemstring(Lrow, "itm_shtnm"))
//		 dwname.setitem(Lgrow, "lotgub", 		dw_insert.getitemstring(Lrow, "lotgub"))
//		 
//		/* 업체별 단가 */
//		Select Nvl(unprc, 0)	  Into :Lunprc	  From danmst
//		 Where itnbr  = :sItnbr	And cvcod  = :iscvcod	and rownum = 1	 Using sqlca;	
//		 dwname.setitem(Lgrow, "price", 			0)
//	 // 출고등록(직출)
//	 ElseIf dwname.dataobject = 'd_pdt_04035_1' Or dwname.dataobject = 'd_pdt_04035_han_1' Or &
//				dwname.dataobject = 'd_pdt_04036_2' Or dwname.dataobject = 'd_adt_00250_1' Then
//		 Lgrow =	dwname.insertrow(0)
//		
//		 dwname.setitem(Lgrow, "lotsno", 		dw_insert.getitemstring(Lrow, "lotno"))
//		 dwname.setitem(Lgrow, "itnbr", 			dw_insert.getitemstring(Lrow, "itnbr"))
//		 dwname.setitem(Lgrow, "itdsc", 			dw_insert.getitemstring(Lrow, "itdsc"))
//		 dwname.setitem(Lgrow, "ispec", 			dw_insert.getitemstring(Lrow, "ispec"))
//		 dwname.setitem(Lgrow, "jijil", 			dw_insert.getitemstring(Lrow, "jijil"))
//		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_insert.getitemstring(Lrow, "itm_shtnm"))
//		 dwname.setitem(Lgrow, "ispec_code",	dw_insert.getitemstring(Lrow, "ispec_code"))
//		 dwname.setitem(Lgrow, "pspec", 			dw_insert.getitemstring(Lrow, "pspec"))	 
//		 dwname.setitem(Lgrow, "jego_qty", 		dw_insert.getitemdecimal(Lrow, "jego_qty"))
//		 dwname.setitem(Lgrow, "jego_temp", 	dw_insert.getitemdecimal(Lrow, "jego_temp"))
//		 dwname.setitem(Lgrow, "valid_qty", 	dw_insert.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "outqty", 		dw_insert.getitemdecimal(Lrow, "valid_qty"))
//		 dwname.setitem(Lgrow, "lotgub", 		dw_insert.getitemstring(Lrow, "lotgub"))
//		 dwname.setitem(Lgrow, "grpno2", 		dw_insert.getitemstring(Lrow, "grpno2"))
//		 
//		 // 입고처를 찾지 못한경우 자사코드 입력
//		 sCustNo = Trim(dw_insert.getitemstring(Lrow, "cust_no"))
//		 If IsNull(sCustNo) Or scustNo = '' Then sCustNo = isjasa
			
//		 dwname.setitem(Lgrow, "cust_no",	sCustNo)		// 입고처(최초)
//	End If
Next
//dwname.setredraw(true)
Close(Parent)

end event

type rr_1 from roundrectangle within w_mat_01020_banpum2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4585
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

